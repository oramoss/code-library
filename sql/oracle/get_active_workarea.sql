undefine qrysid
set wrap off
set linesize 255
ACCEPT qrysid PROMPT 'Please enter SID: '
WITH sql_id AS
(
select distinct sql_id from v$open_cursor where sid=&&qrysid
)
SELECT operation_id
,operation_type
,sid
,round(active_time/(1000000)) active_secs
,(work_area_size / (1024*1024)) work_area_size
,(expected_size / (1024*1024)) expected_size
,(actual_mem_used / (1024*1024)) actual_mem_used
,(max_mem_used / (1024*1024)) max_mem_used
,number_passes
,(tempseg_size / (1024*1024)) tempseg_size
FROM   v$sql_workarea_active a
,      sql_id
WHERE  a.sql_id = sql_id.sql_id
order by a.operation_Id,qcsid
/

WITH sql_id AS
(
select sql_id
,      1 source
from v$session
where sid=&&qrysid
UNION ALL
SELECT oc.sql_id
,      2
FROM   (
SELECT sid,sql_id
FROM   v$session
WHERE  sid = &search_sid
) s
,      v$open_cursor oc
WHERE  s.sid = oc.sid
and    oc.sql_text like 'INSERT%BYPASS%'
)
, add_rn AS
(
SELECT x.*
,      ROW_NUMBER() OVER(ORDER BY x.source DESC) rn
FROM   sql_id x
)
, get_one_sql_id AS
(
SELECT *
FROM   add_rn
WHERE  rn =1
)
select w.operation_id
,w.operation_type
,(w.last_memory_used / (1024*1024)) last_memory_used
,w.last_execution
,w.total_executions
,w.optimal_executions
,w.onepass_executions
,w.multipasses_executions
,ROUND(w.active_time/1000000) active_secs
,(w.max_tempseg_size / (1024*1024)) max_tempseg_size
,(w.last_tempseg_size / (1024*1024)) last_tempseg_size
from v$sql_workarea w
,    get_one_sql_id s
where w.sql_id=s.sql_id
order by w.operation_id
/
