SET LINESIZE 256
SET WRAP OFF

COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN sql_id HEADING "SQL ID" FORMAT a13
COLUMN hash_value HEADING "Hash|Value" FORMAT 999999999999
COLUMN child_number HEADING "Child|Number" FORMAT 999
COLUMN address HEADING "SQL Address" FORMAT A20
COLUMN hash_value HEADING "Hash Value" FORMAT 999999999999
COLUMN operation_id heading "Op|ID" format 999
COLUMN operation_type heading "Operation|Type" format A20
COLUMN estimated_optimal_size HEADING "Est|Opt MB" FORMAT 999,999
COLUMN estimated_onepass_size HEADING "Est|1P MB" FORMAT 999,999
COLUMN last_memory_used HEADING "Last Mem|Used MB" FORMAT 999,999
COLUMN last_execution HEADING "Last|Execution" FORMAT A9
COLUMN last_degree HEADING "Lst|Deg" FORMAT 999
COLUMN total_executions HEADING "Tot|Exe" FORMAT 999,999
COLUMN optimal_executions HEADING "Opt|Exe" FORMAT 999,999
COLUMN onepass_executions HEADING "1P|Exe" FORMAT 999,999
COLUMN multipasses_executions HEADING "Mul|Exe" FORMAT 999,999
COLUMN active_time HEADING "Active|Time(s)" FORMAT 999,999
COLUMN max_tempseg_size HEADING "Max Temp|Size MB" FORMAT 999,999
COLUMN last_tempseg_size HEADING "Last Temp|Size MB" FORMAT 999,999

SELECT inst_id
,      sql_id
,      hash_value
,      child_number
,      operation_id
,      operation_type
,      (estimated_optimal_size / (1024 * 1024)) estimated_optimal_size
,      (estimated_onepass_size / (1024 * 1024)) estimated_onepass_size
,      (last_memory_used / (1024 * 1024)) last_memory_used
,      last_execution
,      last_degree
,      total_executions
,      optimal_executions
,      onepass_executions
,      multipasses_executions
,      (active_time / 1000000) active_time
,      (max_tempseg_size / (1024 * 1024)) max_tempseg_size
,      (last_tempseg_size / (1024 * 1024)) last_tempseg_size
FROM   gv$sql_workarea
WHERE  sql_id LIKE '%&sql_id%'
AND    inst_id = &inst_id
ORDER BY inst_id
,        sql_id
,        hash_value
,        child_number
,        operation_id;
