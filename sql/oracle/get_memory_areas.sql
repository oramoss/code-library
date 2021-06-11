SET LINESIZE 132
SET WRAP OFF

ACCEPT sid CHAR FORMAT 'A20' PROMPT 'Enter SID:  '

COLUMN operation HEADING "Operation" FORMAT A60
COLUMN last_execution HEADING "Last|Exec" FORMAT 999
COLUMN last_degree HEADING "Last|Degr" FORMAT 999
COLUMN cardinality HEADING "Card" FORMAT 999,999,999,990
COLUMN bytes_gb HEADING "Bytes|Gb" FORMAT 9,999
COLUMN cpu_cost_p HEADING "CPU|Cost" FORMAT 999
COLUMN io_cost_g HEADING "IO|Cost" FORMAT 999
COLUMN max_tempseg_size HEADING "Max|Temp Gb" FORMAT 9,999
COLUMN last_tempseg_size HEADING "Last|Temp Gb" FORMAT 9,999
COLUMN last_memory_used HEADING "Last|Mem Used" FORMAT 9,999

WITH x AS
(
SELECT /*+ NO_MERGE
        */
       sp.operation
,      sp.options
,      sp.object_name
,      sp.id
,      sp.parent_id
,      wa.last_execution
,      wa.last_degree
,      spsa.cardinality
,      (spsa.bytes/1024/1024/1024) bytes_gb
,      (spsa.cpu_cost/1000000000000) cpu_cost_p
,      (spsa.io_cost/1000000000) io_cost_g
,      (wa.max_tempseg_size / (1024 * 1024 * 1024) ) max_tempseg_size
,      (wa.last_tempseg_size / (1024 * 1024 * 1024) ) last_tempseg_size
,      (wa.last_memory_used / (1024 * 1024 * 1024) ) last_memory_used
FROM   v$session se
,      v$sql s
,      v$sql_plan sp
,      v$sql_workarea wa
,      v$sql_plan_statistics_all spsa
WHERE  se.sid = &sid
AND    se.sql_id = s.sql_id
AND    se.sql_child_number = s.child_number
AND    s.sql_id = sp.sql_id
AND    s.child_number = sp.child_number
AND    sp.sql_id = wa.sql_id(+)
AND    sp.child_number = wa.child_number(+)
AND    sp.id = wa.operation_id(+)
AND    sp.sql_id = spsa.sql_id(+)
AND    sp.child_number = spsa.child_number(+)
AND    sp.id = spsa.id(+)
)
SELECT /*+ NO_MERGE
        */
       substr(lpad('  ',(level-1))||operation,1,75)||' '||
       options||' '||
       object_name operation
,      last_execution
,      last_degree
,      cardinality
,      bytes_gb
,      cpu_cost_p
,      io_cost_g
,      max_tempseg_size
,      last_tempseg_size
,      last_memory_used
FROM   x
START WITH id = 0
CONNECT BY PRIOR id = parent_id
ORDER BY id
/
