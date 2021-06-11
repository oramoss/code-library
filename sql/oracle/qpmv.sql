rem
rem	Script:		qpmv.sql
rem	Author:		Jeff Moss
rem	Dated:		February 2006
rem	Purpose:	Gets the execution plan for an MV refresh query and shows the work areas
rem                      and longops associated with it...in order to try and show
rem                      where a query is at in its execution.
rem
rem	Versions tested 
rem		10.1.0.4
rem
rem	Notes:
rem	 The script is not perfect for example, it does not cope well with:
rem       1. Situations where there is no work area for an operation
rem       2. Situations where there are no long ops for an operation
rem       3. There is a bug in 10.1.0.4 where the PARENT_ID columns can
rem           be corrupted - Bug ###, SR 4990863.
rem           Causes retrieved execution plan to be malformed even when statement runs
rem       4. Does not deal with some cases where the statement pointed to by V$SESSION is
rem           not the actual statement being run, e.g. when refreshing a Materialized View.
rem
rem      BUT, at least it is better than nothing.

UNDEFINE sid

ACCEPT inst_id NUMBER FORMAT 9999999990 PROMPT 'Enter Instance ID:  '
ACCEPT search_sid NUMBER FORMAT 9999999990 PROMPT 'Enter SID:  '

COLUMN id HEADING "ID" FORMAT 999
COLUMN operation HEADING "Operation" FORMAT A40 WRAP
COLUMN options HEADING "Options" FORMAT A15 WRAP
COLUMN object_name HEADING "Object|Name" FORMAT A20 WRAP
COLUMN cardinality HEADING "Cardinality" FORMAT 999,999,999,990
COLUMN operation_type HEADING "Operation|Type" FORMAT A15 WRAP
COLUMN active_time HEADING "Active|For(s)" FORMAT 999,990
COLUMN WA_Size HEADING "Workarea|Size (Mb)" FORMAT 999,990
COLUMN sid HEADING "SID" FORMAT 99999
COLUMN time_remaining HEADING "Time|Left" FORMAT 999,999,990
COLUMN last_execution HEADING "Last|Execution" FORMAT A10
COLUMN message HEADING "Longop|Msg" FORMAT A20 WRAP
COLUMN actual_mem_used HEADING "Actual|Mem Used" FORMAT 999,999,999,990
COLUMN tempseg_size HEADING "Temp Seg|Size" FORMAT 999,999,999,990

SET VERIFY OFF
SET FEEDBACK OFF
SET TIMING OFF
SET PAGESIZE 10000
SET LINESIZE 200
SET WRAP OFF

CLEAR BREAKS
CLEAR COMPUTES

BREAK ON id ON operation ON options ON object_name ON CARDINALITY ON operation_type ON active_time ON REPORT
COMPUTE SUM OF WA_Size ON REPORT

WITH sess AS
(
SELECT sid
,      serial#
,      sql_child_number
,      sql_id
FROM   gv$session
WHERE  inst_id = &inst_id
AND    sid = &search_sid
)
,session_details AS 
(
SELECT s.sid
,      s.serial#
,      s.sql_child_number
,      oc.sql_id
FROM   sess s
,      gv$open_cursor oc
WHERE  s.sid = oc.sid
AND    oc.inst_id = &inst_id
AND    oc.sql_text LIKE 'INSERT%BYPASS%'
)
, sp2 AS 
(
SELECT sp3.child_number,sp3.sql_id,sp3.parent_id,sp3.depth,sp3.position,sp3.id,sp3.operation,sp3.options,sp3.object_owner,sp3.object_name
,      sp3.object_alias,sp3.cost,sp3.cardinality,sp3.other_tag,sp3.partition_start,sp3.partition_stop,sp3.time,sp3.qblock_name
FROM   gv$sql_plan sp3
,      session_details s
WHERE  sp3.sql_id = s.sql_id
AND    sp3.child_number = s.sql_child_number
AND    sp3.inst_id = &inst_id
)
, add_connect_by AS 
(
SELECT sp2.child_number,sp2.sql_id,sp2.parent_id,sp2.depth,sp2.position,sp2.id,sp2.operation,sp2.options,sp2.object_owner,sp2.object_name
,      sp2.object_alias,sp2.cost,sp2.cardinality,sp2.other_tag,sp2.partition_start,sp2.partition_stop,sp2.time,sp2.qblock_name
FROM   sp2
START WITH sp2.id=0
CONNECT BY PRIOR sp2.id = sp2.parent_id
ORDER BY sp2.id
)
, get_plan_lines AS
(
SELECT /*+ NO_MERGE */ 
       sp_sw_swa.id
,      sp_sw_swa.actual_operation_id
,      sp_sw_swa.parent_id
,      sp_sw_swa.operation
,      sp_sw_swa.object_name
,      sp_sw_swa.operation_type
,      sp_sw_swa.qcsid
,      sp_sw_swa.sl_message message
,      (CASE WHEN sp_sw_swa.active_time > 0 THEN ROUND(sp_sw_swa.active_time / 1000000) ELSE 0 END) active_time
,      (CASE WHEN sp_sw_swa.work_area_size > 0 THEN ROUND(sp_sw_swa.work_area_size / (1024*1024) ) ELSE 0 END) WA_Size
,      sp_sw_swa.sid sid
,      sp_sw_swa.time_remaining
,      sp_sw_swa.actual_mem_used
,      sp_sw_swa.tempseg_size
FROM   session_details s
,      gv$sqlarea sq
,      (SELECT sp.parent_id,sp.actual_operation_id,sp.sql_id,sp.id,sp.operation,sp.options,sp.object_owner,sp.object_name
        ,      sp.object_alias,sp.cost,sp.cardinality,sp.other_tag,sp.partition_start,sp.partition_stop,sp.time,sp.qblock_name
        ,      sw.workarea_address,sw.operation_type,sw.last_memory_used,sw.last_execution,sw.last_degree
        ,      sw.total_executions,sw.optimal_executions
        ,      sw.onepass_executions,sw.multipasses_executions,sw.active_time sw_active_time,sw.max_tempseg_size,sw.last_tempseg_size
        ,      swa.qcinst_id,swa.qcsid,swa.active_time,swa.work_area_size,swa.expected_size,swa.actual_mem_used
        ,      swa.max_mem_used,swa.number_passes,swa.tempseg_size,swa.sid,sl.time_remaining
        ,      sl.message sl_message
        FROM   (SELECT (ROWNUM-1) actual_operation_id
                ,      acb.*
                FROM   add_connect_by acb
               ) sp
        ,      gv$sql_workarea sw
        ,      gv$sql_workarea_active swa
        ,      (SELECT * 
                FROM   gv$session_longops
                WHERE  time_remaining != 0
                AND    inst_id = &inst_id
               )  sl
        WHERE  sp.sql_id = sw.sql_id(+)
        AND    sp.child_number = sw.child_number(+)
        AND    sp.id = sw.operation_id(+)
        AND    sp.sql_id = swa.sql_id(+)
--         AND    sp.actual_operation_id = swa.operation_id(+)
        AND    sp.id = swa.operation_id(+)
--        AND    swa.sql_id = sl.sql_id(+)
        AND    swa.sid = sl.sid(+)
        AND    DECODE(swa.operation_type,'HASH-JOIN','HASH'
		                        ,'BUFFER','SORT'
			                ,'WINDOW (SORT)','SORT'
					,'GROUP BY (SORT)','SORT'
					,'LOAD WRITE BUFFERS','SORT'
					,'XXXX') = UPPER(SUBSTR(sl.opname(+),1,4))
        AND    sw.inst_id = &inst_id
        AND    swa.inst_id = &inst_id
       ) sp_sw_swa 
WHERE  s.sql_id = sq.sql_id(+)
AND    s.sql_id = sp_sw_swa.sql_id(+)
AND    sq.inst_id = &inst_id
)
SELECT DISTINCT id
,      LPAD('  ',1*(level-1))||operation operation
,      object_name
,      operation_type
,      active_time
,      time_remaining
,      sid
,      WA_Size
,      message
,      actual_mem_used
,      tempseg_size
FROM   get_plan_lines
START WITH id=0
CONNECT BY PRIOR id=parent_id
ORDER BY id;

