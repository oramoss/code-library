ACCEPT sid CHAR FORMAT 'A20' PROMPT 'Enter SID:  '
WITH sess AS
(
SELECT sid
,      serial#
,      sql_child_number
,      sql_id
FROM   v$session
WHERE  sid = &search_sid
)
,session_details AS (
SELECT s.sid
,      s.serial#
,      s.sql_child_number
,      oc.sql_id
FROM   sess s
,      v$open_cursor oc
WHERE  s.sid = oc.sid
and    oc.sql_text like 'INSERT%BYPASS%'
)
SELECT wa.operation_id
,      wa.operation_type
,      wa.last_execution,wa.last_degree
,      spsa.cardinality
,      (spsa.bytes/1024) bytes_kb
,      (spsa.cpu_cost/1000000) cpu_cost_m
,      (spsa.io_cost/1000) io_cost_k
,      (wa.max_tempseg_size / (1024 * 1024) ) max_tempseg_size
,      (wa.last_tempseg_size / (1024 * 1024) ) last_tempseg_size
,      (wa.last_memory_used / (1024 * 1024) ) last_memory_used
FROM   session_details sd
,      v$sql s
,      v$sql_workarea wa
,      v$sql_plan_statistics_all spsa
WHERE  wa.sql_id = s.sql_id
AND    wa.child_number = s.child_number
AND    wa.sql_id = spsa.sql_id
AND    wa.child_number = spsa.child_number
AND    wa.operation_id = spsa.id
AND    s.sql_id = sd.sql_id
AND    s.child_number = sd.sql_child_number
ORDER BY wa.operation_id
/

