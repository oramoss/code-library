SET LINESIZE 256
SET WRAP OFF

COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN sql_id HEADING "SQL ID" FORMAT a13
COLUMN qcsid HEADING "QC" FORMAT 9999
COLUMN sid HEADING "SID" FORMAT 9999
COLUMN operation_id heading "Op|ID" format 999
COLUMN operation_type heading "Operation|Type" format A20
COLUMN policy HEADING "Policy" FORMAT A6
COLUMN active_time HEADING "Active|Time(s)" FORMAT 999,999
COLUMN work_area_size HEADING "Workarea|Size Mb" FORMAT 999,999
COLUMN expected_size HEADING "Expected|Size Mb" FORMAT 999,999
COLUMN actual_mem_used HEADING "Actual|Used Mb" FORMAT 999,999
COLUMN max_mem_used HEADING "Max Mem|Used Mb" FORMAT 999,999
COLUMN number_passes HEADING "Number|Passes" FORMAT 999,999,999,999
COLUMN tempseg_size HEADING "Temp Seg|Size Mb" FORMAT 999,999
COLUMN sql_hash_value HEADING "SQL Hash|Value" FORMAT 999999999999
COLUMN sql_exec_start HEADING "SQL Exec|Start" FORMAT A11
COLUMN sql_exec_id HEADING "SQL Exec|ID" FORMAT 99999999
COLUMN workarea_address HEADING "Workarea|Address" FORMAT A16

SELECT inst_id
,      sql_id
,      qcsid
,      sid
,      sql_hash_value
,      sql_exec_start
,      sql_exec_id
,      workarea_address
,      operation_id
,      operation_type
,      policy
,      (active_time / 1000000) active_time
,      (work_area_size / (1024 * 1024)) work_area_size
,      (expected_size / (1024 * 1024)) expected_size
,      (actual_mem_used / (1024 * 1024)) actual_mem_used
,      (max_mem_used / (1024 * 1024)) max_mem_used
,      number_passes
,      (tempseg_size / (1024 * 1024)) tempseg_size
FROM   gv$sql_workarea_active
ORDER BY sql_id
,        operation_id DESC
,        inst_id;
