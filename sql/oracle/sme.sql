SET WRAP OFF
SET LINESIZE 250
SET PAGESIZE 1000
COLUMN inst_id HEADING "Ins|ID" FORMAT 999
COLUMN username HEADING "User Name" FORMAT a10
COLUMN client_identifier HEADING "Client|ID" FORMAT a20 TRUNCATED
COLUMN px_qcsid HEADING "QC|SID" FORMAT 9999
COLUMN sid HEADING "SID" FORMAT 99999
COLUMN osuser HEADING "OS|User" FORMAT A10
COLUMN session_serial# HEADING "Ser#" FORMAT 99999
COLUMN px_maxdop HEADING "PX MAX|DOP" FORMAT 9999
COLUMN px_maxdop_instances HEADING "PX MAX|DOP Inst" FORMAT 9999
COLUMN px_servers_requested HEADING "Svrs|Rqstd" FORMAT 9999
COLUMN px_servers_allocated HEADING "Svrs|Alloc" FORMAT 9999
COLUMN elapsed_time HEADING "Elapsed|(s)" FORMAT 999,990
COLUMN sql_id HEADING "SQL_ID" FORMAT a13
COLUMN sql_text HEADING "SQL Text" FORMAT a50 TRUNCATED
SELECT sm.inst_id
,      sm.username
,      sm.client_identifier
,      sm.px_qcsid
,      sm.sid
,      s.osuser
,      sm.session_serial#
,      sm.px_maxdop
,      sm.px_maxdop_instances
,      sm.px_servers_requested
,      sm.px_servers_allocated
,      (sm.elapsed_time / 1000000) elapsed_time
,      sm.sql_id
,      sm.sql_text
FROM   gv$sql_monitor sm
,      gv$session s
WHERE  sm.inst_id = s.inst_id
AND    sm.sid = s.sid
AND    sm.session_serial# = s.serial#
AND    sm.status = 'EXECUTING'
--and sm.username='J4134'
ORDER BY sm.px_servers_allocated NULLS FIRST
/
