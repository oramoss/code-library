rem
rem	Script:		get_query_progress.sql
rem	Author:		Jeff Moss
rem	Dated:		November 2005
rem	Purpose:	Gets the execution plan for a query and shows the work areas
rem                      and longops associated with it...in order to try and show
rem                      where a query is at in it's execution.
rem
rem	Versions tested 
rem		10.1.0.4
rem
rem	Notes:
rem	 The script isn't perfect for example, it doesn't cope well with:
rem       1. Situations where there is no work area for an operation
rem       2. Situations where there are no long ops for an operation
rem       3. There is a bug in 10.1.0.4 where the PARENT_ID columns can
rem           be corrupted - Bug ###, SR 4990863.
rem           Causes retrieved execution plan to be malformed even when statement runs
rem       4. Doesn't deal with some cases where the statement pointed to by V$SESSION is
rem           not the actual statement being run, e.g. when refreshing a Materialized View.
rem
rem      BUT, at least it's better than nothing.

UNDEFINE sid

ACCEPT search_sid NUMBER FORMAT 9999999990 PROMPT 'Enter SID:  '

COLUMN id HEADING "ID" FORMAT 999 WRAP
COLUMN operation HEADING "Operation" FORMAT A40 WRAP
COLUMN options HEADING "Options" FORMAT A15 WRAP
COLUMN object_name HEADING "Object|Name" FORMAT A20 WRAP
COLUMN cardinality HEADING "Cardinality" FORMAT 999,999,999,990 WRAP
COLUMN operation_type HEADING "Operation|Type" FORMAT A15 WRAP
COLUMN active_time HEADING "Active|For(s)" FORMAT 999,990 WRAP
COLUMN WA_Size HEADING "Workarea|Size (Mb)" FORMAT 999,990 WRAP
COLUMN sid HEADING "SID" FORMAT 99999 WRAP
COLUMN time_remaining HEADING "Time|Left" FORMAT A7 WRAP
COLUMN last_execution HEADING "Last|Execution" FORMAT A10 WRAP
COLUMN message HEADING "Longop|Msg" FORMAT A20 WRAP
COLUMN partition_start HEADING "Ptn|Start" FORMAT A4 WRAP
COLUMN partition_stop HEADING "Ptn|Stop" FORMAT A4 WRAP

SET VERIFY OFF
SET FEEDBACK OFF
SET TIMING OFF
SET PAGESIZE 10000
SET LINESIZE 200
SET WRAP OFF

clear breaks
clear computes

break ON id ON operation ON options ON object_name ON CARDINALITY ON operation_type ON active_time ON REPORT
COMPUTE SUM OF WA_Size ON REPORT

WITH v_session AS
(
SELECT /*+ NO_MERGE */ 
       inst_id
,      sql_child_number
,      sql_id
FROM   gv$session
WHERE  sid = &search_sid
)
, v_sql_plan AS (
SELECT s.inst_id
,      sp.child_number
,      sp.sql_id
,      sp.parent_id
,      sp.id
,      sp.operation
,      sp.object_name
,      sp.partition_start
,      sp.partition_stop
FROM   gv$sql_plan sp
,      v_session s
WHERE  sp.inst_id = s.inst_id
AND    sp.sql_id = s.sql_id
AND    sp.child_number = s.sql_child_number
ORDER BY sp.id
)
, get_plan_lines AS
(
SELECT /*+ NO_MERGE */
       s.inst_id
,      sp_sw_swa.id
,      sp_sw_swa.parent_id
,      sp_sw_swa.operation
,      sp_sw_swa.object_name
,      sp_sw_swa.operation_type
,      sp_sw_swa.message
,      sp_sw_swa.partition_start
,      sp_sw_swa.partition_stop
,      (CASE WHEN sp_sw_swa.active_time > 0 THEN ROUND(sp_sw_swa.active_time / 1000000) ELSE 0 END) active_time
,      (CASE WHEN sp_sw_swa.work_area_size > 0 THEN ROUND(sp_sw_swa.work_area_size / (1024*1024) ) ELSE 0 END) WA_Size
,      sp_sw_swa.sid sid
,      sp_sw_swa.time_remaining
FROM   v_session s
,      gv$sqlarea sq
,      (SELECT sp.id
        ,      sp.parent_id
        ,      sp.sql_id
        ,      sp.operation
        ,      sp.object_name
        ,      sp.partition_start
        ,      sp.partition_stop
        ,      sw.operation_type
        ,      sw.last_memory_used
        ,      sw.last_tempseg_size
        ,      swa.active_time
        ,      swa.work_area_size
        ,      swa.sid
        ,      sl.time_remaining
        ,      sl.message
        FROM   v_sql_plan sp
        ,      gv$sql_workarea sw
        ,      gv$sql_workarea_active swa
        ,      gv$session_longops sl
        WHERE  sp.inst_id = sw.inst_id(+)
        AND    sp.sql_id = sw.sql_id(+)
        AND    sp.child_number = sw.child_number(+)
        AND    sp.id = sw.operation_id(+)
        AND    sp.inst_id = swa.inst_id(+)
        AND    sp.sql_id = swa.sql_id(+)
        AND    sp.id = swa.operation_id(+)
        AND    swa.inst_id = sl.inst_id(+)
        AND    swa.sql_id = sl.sql_id(+)
        AND    swa.sid = sl.sid(+)
        AND    sl.time_remaining(+) != 0
        AND    DECODE(swa.operation_type,'HASH-JOIN','HASH'
		                        ,'BUFFER','SORT'
			                ,'WINDOW (SORT)','SORT'
					,'GROUP BY (SORT)','SORT'
					,'LOAD WRITE BUFFERS','SORT'
					,'XXXX') = UPPER(SUBSTR(sl.opname(+),1,4))
       ) sp_sw_swa
WHERE  s.inst_id = sq.inst_id(+)
AND    s.sql_id = sq.sql_id(+)
AND    s.sql_id = sp_sw_swa.sql_id(+)
)
, get_whole_plan AS
(
SELECT id
,      LPAD('  ',1*(level-1))||operation operation
,      object_name
,      operation_type
,      partition_start
,      partition_stop
,      active_time
,      NVL(TO_CHAR(time_remaining),'N/A') time_remaining
,      sid
,      WA_Size
,      NVL(message,'No Long Op Running') message
FROM   get_plan_lines
START WITH id = 0
CONNECT BY PRIOR id = parent_id
ORDER BY id
)
, add_rn AS
(
SELECT id
,      operation
,      object_name
,      operation_type
,      partition_start
,      partition_stop
,      active_time
,      time_remaining
,      sid
,      WA_Size
,      message
,      ROW_NUMBER() OVER(PARTITION BY id,sid
                         ORDER BY id) rn
FROM   get_whole_plan
)
SELECT id
,      operation
,      object_name
,      operation_type
,      partition_start
,      partition_stop
,      active_time
,      time_remaining
,      sid
,      WA_Size
,      message
FROM   add_rn
WHERE  rn = 1
/
