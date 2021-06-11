--******************************************************************************
--*
--*  Description
--*  ***********
--*
--*  File:    setup_sqlplus.sql
--*
--*  Description: This script shows temp tablespace usage metrics by session,
--*               for the current database.
--*
--* ----------------------------------------------------------------------------
--* Date         Author             Description
--* ===========  =================  ============================================
--* 27-JAN-2009  Jeff Moss          Created
--*
REM Do not display the execution of this script...
SET TERMOUT OFF

-- Powergen column specific formats...
COLUMN base_id FORMAT 999999999999
COLUMN ice_customer_id FORMAT 999999999999
COLUMN premise_id FORMAT 999999999999
COLUMN status FORMAT 999
COLUMN street_id FORMAT 999999999999

-- Oracle column specific formats...
COLUMN active_secs HEADING "Active|Secs" FORMAT 999,999
COLUMN active_time HEADING "Active|Time" FORMAT 999,999,999,999
COLUMN actual_mem_used HEADING "Actual|Used Mb" FORMAT 999,999,999,999
COLUMN address HEADING "SQL Address" FORMAT A20
COLUMN allow_runs_in_restricted_mode HEADING "Allow Run|Restrict" FORMAT A9
COLUMN aq_ha_notifications HEADING "AQ HA|Notif" FORMAT A5
COLUMN auto_drop HEADING "Auto|Drop" FORMAT A5
COLUMN avg_col_len HEADING "Average|Col Len" FORMAT 990
COLUMN avg_data_blocks_per_key HEADING "Average|Data Blocks|Per Key" FORMAT 99,990
COLUMN avg_leaf_blocks_per_key HEADING "Average|Leaf Blocks|Per Key" FORMAT 99,990
COLUMN avg_row_len HEADING "Average|Row Len" FORMAT 990
COLUMN avg_space HEADING "Average|Space" FORMAT 999,990
COLUMN avg_space_pct HEADING "Average|Space" FORMAT A12
COLUMN active_time HEADING "Active|Time" FORMAT 999,999
COLUMN blev HEADING "B|Tree|Level" FORMAT 90
COLUMN blocks HEADING "Blocks" FORMAT 999,999,990
COLUMN block_gets HEADING "Block Gets" FORMAT 999,999,999,999
COLUMN buffer_gets HEADING "Buffer Gets" FORMAT 999,999,999,999
COLUMN buffer_pool HEADING "BUffer|Pool" FORMAT A15
COLUMN bytes_kb HEADING "Bytes|KB" FORMAT 999,999,999
COLUMN bytes_gb HEADING "Bytes|GB" FORMAT 999,999
COLUMN cardinality HEADING "Cardinality" FORMAT 999,999,999,990
COLUMN chain_cnt HEADING "Chain|Count" FORMAT 999,999,990
COLUMN child_number HEADING "Child|Number" FORMAT 999
COLUMN class HEADING "Class" FORMAT 9,990
COLUMN clb_goal HEADING "Conn Load|Bal Goal" FORMAT A9
COLUMN clfpct HEADING "Clustering|Percent|(Low Good)" FORMAT 990.00
COLUMN client_id HEADING "Client ID" FORMAT A10
COLUMN clustering_factor HEADING "Cluster|Factor" FORMAT 999,999,990
COLUMN cmp HEADING "Cmp?" FORMAT A4
COLUMN col HEADING "Column|Details" FORMAT A24
COLUMN column_id HEADING "Column|ID" FORMAT 990
COLUMN column_length HEADING "Col|Len" FORMAT 990
COLUMN column_name  HEADING "Column|Name" FORMAT A30
COLUMN column_position HEADING "Col|Pos" FORMAT 990
COLUMN compression HEADING "Compression" FORMAT A10
COLUMN consistent_gets HEADING "Consistent Gets" FORMAT 999,999,999,999
COLUMN constraint_name HEADING "Constraint|Name" FORMAT A25
COLUMN cpu_cost_m HEADING "CPU|Cost M" FORMAT 999,999,999
COLUMN cpu_cost_p HEADING "CPU|Cost P" FORMAT 999
COLUMN creation_date HEADING "Creation|Date" FORMAT A20
COLUMN credential_name HEADING "Credential" FORMAT A20
COLUMN credential_owner HEADING "Credential Owner" FORMAT A20
COLUMN data_default HEADING "Default" FORMAT A10
COLUMN data_length HEADING "Data|Length" FORMAT 999,990
COLUMN data_precision HEADING "Data|Prec" FORMAT 990
COLUMN data_scale HEADING "Data|Scal" FORMAT 990
COLUMN data_type HEADING "Data|Type" FORMAT A10
COLUMN default_length HEADING "Default|Length" FORMAT 990
COLUMN deferred_drop HEADING "Defer|Drop" FORMAT A5
COLUMN degree HEADING "Degree" FORMAT A10
COLUMN density HEADING "Density" FORMAT 990
COLUMN destination HEADING "Destination" FORMAT A20
COLUMN destination_owner HEADING "Destination Owner" FORMAT A20
COLUMN disk_reads HEADING "Disk Reads" FORMAT 999,999,999,999
COLUMN distinct_keys HEADING "Distinct|Keys" FORMAT 999,999,990
COLUMN distribution HEADING "Distribution" FORMAT A30
COLUMN do_object_name HEADING "Object Name" FORMAT a20
COLUMN dtp HEADING "DTP" FORMAT A3
COLUMN edition HEADING "Edition" FORMAT A10
COLUMN empty_blocks HEADING "Empty|Blocks" FORMAT 999,990
COLUMN enabled HEADING "Enabled" FORMAT A7
COLUMN end_date HEADING "End Date" FORMAT A20
COLUMN estimated_optimal_size HEADING "Est|Opt" FORMAT 999,999,999
COLUMN estimated_onepass_size HEADING "Est|1P" FORMAT 999,999,999
COLUMN event_queue_owner HEADING "Event Q|Owner" FORMAT A20
COLUMN event_queue_name HEADING "Event Q|Name" FORMAT A20
COLUMN event_queue_agent HEADING "Event Q|Agent" FORMAT A20
COLUMN event_condition HEADING "Event Q|Condition" FORMAT A20
COLUMN event_rule HEADING "Event|Rule" FORMAT A20
COLUMN executions HEADING "Executions" FORMAT 999,999,999,999
COLUMN expected_size HEADING "Expected|Size Mb" FORMAT 999,999,999,999
COLUMN failover_delay HEADING "Failover|Delay" FORMAT 990
COLUMN failover_method HEADING "Failover|Method" FORMAT A10
COLUMN failover_retries HEADING "Failover|Retries" FORMAT 99,999,990
COLUMN failover_type HEADING "Failover|Type" FORMAT A10
COLUMN failure_count HEADING "Failure|Count" FORMAT 9,999
COLUMN fetches HEADING "Fetches" FORMAT 999,999,999,999
COLUMN file_watcher_owner HEADING "Filewatcher|Owner" FORMAT A20
COLUMN file_watcher_name HEADING "Filewatcher|Name" FORMAT A20
COLUMN free_bytes HEADING "Free Bytes" FORMAT 999,999,999,990
COLUMN free_mb HEADING "Free Mb" FORMAT 999,990
COLUMN freelists HEADING "FreeLists" FORMAT 999,990
COLUMN global_uid HEADING "Global UID" FORMAT A10
COLUMN goal HEADING "Goal" FORMAT A10
COLUMN hard_parses HEADING "Hard|Parses" FORMAT 999,999,990
COLUMN hash_value HEADING "Hash Value" FORMAT 999999999999
COLUMN high_value HEADING "High|Value" FORMAT A10
COLUMN histogram HEADING "Histogram" FORMAT A15
COLUMN index_name HEADING "Index|Name" FORMAT A30
COLUMN index_type HEADING "Index|Type" FORMAT A6
COLUMN input_bytes_per_sec_display HEADING "Input|Bytes/Sec" FORMAT A10
COLUMN instance_stickiness HEADING "Inst|Stick" FORMAT A5
COLUMN inst_id HEADING "Inst" FORMAT 9
COLUMN instance_id HEADING "Inst|ID" FORMAT 9
COLUMN interval HEADING "Interval" FORMAT A50
COLUMN io_cost_k HEADING "IO|Cost K" FORMAT 999,999,999
COLUMN io_cost_g HEADING "IO|Cost G" FORMAT 999
COLUMN job_action HEADING "Job Action" FORMAT A160
COLUMN job_class HEADING "Job Class" FORMAT A30
COLUMN job_creator HEADING "Job Creator" FORMAT A15
COLUMN job_name HEADING "Job Name" FORMAT A30
COLUMN job_priority HEADING "Job|Pri" FORMAT 990
COLUMN job_subname HEADING "Job Subname" FORMAT A30
COLUMN job_style HEADING "Job Style" FORMAT A10
COLUMN job_type HEADING "Job Type" FORMAT A16
COLUMN job_weight HEADING "Weight" FORMAT 990
COLUMN last_degree HEADING "Lst|Deg" FORMAT 999
COLUMN last_execution HEADING "Last|Execution" FORMAT A9
COLUMN last_analyzed HEADING "Last|Analyzed" FORMAT A11
COLUMN last_memory_used HEADING "Last Mem|Used Mb" FORMAT 999,999,999
COLUMN last_run_duration HEADING "Last Run Duration" FORMAT A19
COLUMN last_start_date HEADING "Last Start Date" FORMAT A20
COLUMN last_tempseg_size HEADING "Last Temp|Size Mb" FORMAT 999,999
COLUMN leaf_blocks HEADING "Leaf|Blks" FORMAT 999,999,990
COLUMN line HEADING "Line" FORMAT 999,999
COLUMN lio_per_exec HEADING "LIO Per Exec" FORMAT 999,999,999,990
COLUMN lio_per_row HEADING "LIO Per Row" FORMAT 999,999,999,990
COLUMN logging HEADING "Log?" FORMAT A4
COLUMN logging_level HEADING "Log|Lvl" FORMAT A4
COLUMN low_value HEADING "Low|Value" FORMAT A10
COLUMN machine HEADING "Machine" FORMAT A25
COLUMN max_cardinality HEADING "Max|Card" FORMAT 999,999,999,990
COLUMN max_failures HEADING "Max#|Fail" FORMAT 9,999
COLUMN max_mem_used HEADING "Max Mem|Used Mb" FORMAT 999,999,999,999
COLUMN max_run_duration HEADING "Max Run|Duration" FORMAT A8
COLUMN max_runs HEADING "Max|Runs" FORMAT 990
COLUMN max_tempseg_size HEADING "Max Temp|Size Mb" FORMAT 999,999
COLUMN message HEADING "Message" FORMAT A70
COLUMN min_cardinality HEADING "Min|Card" FORMAT 990
COLUMN multipasses_executions HEADING "Mul|Exe" FORMAT 990
COLUMN name HEADING "Name" FORMAT A35
COLUMN network_name HEADING "Network Name" FORMAT A60
COLUMN next_run_date HEADING "Next Run Date" FORMAT A20
COLUMN nullable HEADING Null|able FORMAT A4
COLUMN num_buckets HEADING "Number|Buckets" FORMAT 999,990
COLUMN num_distinct HEADING "Distinct|Values" FORMAT 999,999,990
COLUMN num_freelist_blocks HEADING "Freelist|Blocks" FORMAT 999,990
COLUMN num_nulls HEADING "Number|Nulls" FORMAT 999,999,999,990
COLUMN num_rows HEADING "Number|of Rows" FORMAT 999,999,999,990
COLUMN number_passes HEADING "Number|Passes" FORMAT 999,999,999,999
COLUMN number_of_arguments HEADING "#Args" FORMAT 999,990
COLUMN number_of_destinations HEADING "#Dests" FORMAT 999,990
COLUMN object_name HEADING "Object|Name" FORMAT A30
COLUMN object_type HEADING "Object|Type" FORMAT A15
COLUMN onepass_executions HEADING "1P|Exe" FORMAT 990
column operation heading "Operation" format a50
column operation_id heading "Op|ID" format 999
column operation_type heading "Operation|Type" format A20
COLUMN optimal_executions HEADING "Opt|Exe" FORMAT 990
column options heading "Options" format a30
column order heading "Order" format a10
COLUMN osuser HEADING "OS User" FORMAT A10
column other_tag heading "Parallel" format a10
COLUMN output_bytes_per_sec_display HEADING "Output|Bytes/Sec" FORMAT A10
COLUMN owner HEADING "Owner" FORMAT A20
COLUMN partition_name HEADING "Partition|Name" FORMAT A30
COLUMN partition_position HEADING "Partition|Position" FORMAT 990
COLUMN passes HEADING "Passee" FORMAT 99
COLUMN pct_free HEADING "Pct|Free" FORMAT 990
COLUMN pct_increase HEADING "Pct|Inc" FORMAT 990
COLUMN pct_used HEADING "Pct|Used" FORMAT 990
COLUMN policy HEADING "Policy" FORMAT A6
COLUMN pq_status HEADING "PQ Status" FORMAT A8
COLUMN program HEADING "Program" FORMAT A15
COLUMN program_name HEADING "Program|Name" FORMAT A30
COLUMN program_owner HEADING "Program|Owner" FORMAT A10
COLUMN px HEADING "PX" FORMAT A4
COLUMN qcsid HEADING "QC" FORMAT 9999
COLUMN r_constraint_name HEADING "Referential|Constraint Name" FORMAT A25
COLUMN raise_events HEADING "Raise|Events" FORMAT A10
COLUMN redo_size HEADING "Redo|Size" FORMAT 999,999,999,990
COLUMN repeat_interval HEADING "Repeat|Inter" FORMAT A10
COLUMN restartable HEADING "Restart?" FORMAT A8
COLUMN retry_count HEADING "Retry|Count" FORMAT 9,999
COLUMN rn_name HEADING "RBS|Name" FORMAT a5
COLUMN rows_per_block HEADING "Rows|Block" FORMAT 999,990
COLUMN rs_extents HEADING "Extents" FORMAT 999,990
COLUMN rs_status HEADING "Status" FORMAT a7
COLUMN run_count HEADING "#Run" FORMAT 999,990
COLUMN sample_size HEADING "Sample|Size" FORMAT 999,999,999,990
COLUMN schedule_name HEADING "Schedule Name" FORMAT A25
COLUMN schedule_owner HEADING "Schedule Owner" FORMAT A15
COLUMN schedule_type HEADING "Schedule|Type" FORMAT A12
COLUMN search_condition HEADING "Search|Condition" FORMAT A40
COLUMN segtype HEADING "Segment|Type" FORMAT A10
COLUMN selectivity HEADING "Selectivity" FORMAT 999,999,999,990
COLUMN serial# HEADING "Serial" FORMAT 99999
COLUMN service_id HEADING "Svc|ID" FORMAT 999
COLUMN short_table_name HEADING "Table|Name" FORMAT A5
COLUMN sid HEADING "SID" FORMAT 9999
COLUMN soft_parses HEADING "Soft|Parses" FORMAT 999,999,990
COLUMN soft_parse_ratio HEADING "Soft Parse|Ratio %" FORMAT 990.00
COLUMN source HEADING "Source" FORMAT A10
COLUMN space_mb HEADING "Space|(Mb)" FORMAT 999,999,990.00
--COLUMN SQL "SQL" FORMAT A30 WRAP
--COLUMN sql_id "SQL ID" FORMAT A15 WRAP
COLUMN sql_text HEADING "SQL Text" FORMAT A45 WRAP
COLUMN start_date HEADING "Start Date" FORMAT A20
COLUMN state HEADING "State" FORMAT A9
COLUMN statistic# HEADING "Statistic#" FORMAT 9,990
COLUMN stop_on_window_close HEADING "Stop On|Win Close" FORMAT A9
COLUMN subpartition_name HEADING "Sub Part|Name" FORMAT A30
COLUMN subpartition_count HEADING "Sub|Part|Count" FORMAT 990
COLUMN sum_blocks HEADING "Sum|Blocks" FORMAT 999,999,990
COLUMN sum_mb HEADING "Sum Mb" FORMAT 999,990
COLUMN system HEADING "System" FORMAT A6
COLUMN table_name HEADING "Table|Name" FORMAT A30
COLUMN tablespace_name HEADING "Tablespace|Name" FORMAT A30
COLUMN temp_space HEADING "Temporary|Tablespace" FORMAT 999,999,999,990
COLUMN tempseg_size HEADING "Temp Seg|Size Mb" FORMAT 999,999,999,999
COLUMN text HEADING "Text" FORMAT A80
COLUMN time_taken_display HEADING "Time|Taken" FORMAT A8
COLUMN total_bytes HEADING "Total Bytes" FORMAT 999,999,999,990
COLUMN total_executions HEADING "Tot|Exe" FORMAT 990
COLUMN total_mb HEADING "Total Mb" FORMAT 999,990
COLUMN total_parses HEADING "Total|Parses" FORMAT 999,999,990
COLUMN trigger_body HEADING "Trigger|Body" FORMAT A57
COLUMN trigger_name HEADING "Trigger|Name" FORMAT A20
COLUMN trigger_type HEADING "Trigger|Type" FORMAT A20
COLUMN triggering_event HEADING "Triggering|Event" FORMAT A20
COLUMN type HEADING "Type" FORMAT A15
COLUMN uniqueness HEADING "Unq|?" FORMAT A9
COLUMN username HEADING "User" FORMAT A10
COLUMN used_ublk HEADING "Used|Blocks" FORMAT 999,990
COLUMN used_urec HEADING "Used|Records" FORMAT 999,999,990
COLUMN value HEADING "Value" FORMAT 999,999,999,999,999
COLUMN wait_class HEADING "Wait|Class" FORMAT A10
COLUMN wait_event HEADING "Wait Event" FORMAT A10
COLUMN work_area_size HEADING "Workarea|Size Mb" FORMAT 999,999,999,999
COLUMN xidusn HEADING "XIDUSN" FORMAT 99999

ALTER SESSION SET nls_date_format = 'DD-MON-YYYY HH24:MI:SS'
/

-- Columns to set SQL Prompt...
COLUMN user_name NEW_VALUE user_name
COLUMN db_name NEW_VALUE db_name
COLUMN host_name NEW_VALUE host_name
COLUMN sid NEW_VALUE sid
COLUMN serial NEW_VALUE serial

SELECT LOWER(USER) user_name
,      instance_name db_name
,      substr(host_name,1,7) host_name
FROM   v$instance
/

SELECT LTRIM(RTRIM(TO_CHAR(sid))) sid
,      LTRIM(RTRIM(TO_CHAR(serial#))) serial
FROM   v$session
WHERE  audsid = userenv('sessionid')
/

SET SQLPROMPT "&user_name[&sid/&serial]@&host_name:&db_name> "
REM TTITLE "&user_name[&sid/&serial]@&host_name:&db_name> "

SET DESCRIBE DEPTH ALL INDENT ON

REM Various session settings...
SET SERVEROUTPUT ON SIZE 1000000
SET LINESIZE 249
SET PAGESIZE 1000
SET WRAP ON
SET TIMING ON
SET FEEDBACK ON
SET VERIFY ON
SET TAB OFF

REM Turn on display now that script has finished...
SET TERMOUT ON

 