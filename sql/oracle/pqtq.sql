--******************************************************************************
--*
--*  Description
--*  ***********
--*
--*  File:    pqtq.sql
--*
--*  Description: This script shows contents of gv$pq_tqstat.
--*               Run it immediately after a piece of SQL to show the slave
--*               details for the prior executed SQL.
--*
--* ----------------------------------------------------------------------------
--* Date         Author             Description
--* ===========  =================  ============================================
--* 03-JUN-2013  Jeff Moss          Created
--*
COLUMN dfo_number HEADING "DFO|#" FORMAT 999
COLUMN tq_id HEADING "TQ|ID" FORMAT 999
COLUMN server_type HEADING "Server|Type" FORMAT a10
COLUMN num_rows HEADING "Num|Rows" FORMAT 999999999999
COLUMN bytes HEADING "Bytes" FORMAT 999999999999
COLUMN open_time HEADING "Open|Time" FORMAT 999999
COLUMN avg_latency HEADING "Avg|Latency" FORMAT 999999
COLUMN waits HEADING "Waits" FORMAT 999999999
COLUMN timeouts HEADING "Timeouts" FORMAT 999999999
COLUMN process HEADING "Process" FORMAT A6
COLUMN instance HEADING "Instance" FORMAT 999
SELECT dfo_number
,      tq_id
,      server_type
,      process
,      num_rows
,      bytes
,      open_time
,      avg_latency
,      waits
,      timeouts
,      instance
FROM   v$pq_tqstat
ORDER BY dfo_number DESC
,        tq_id
,        server_type DESC 
,        process
/
