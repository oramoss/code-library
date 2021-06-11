SET PAGESIZE 1000
SET LINESIZE 250
SET WRAP OFF
COLUMN thread# HEADING "Thread#" FORMAT 999
COLUMN inst_id HEADING "Inst|ID" FORMAT 999
COLUMN group# HEADING "Group#" FORMAT 999
COLUMN bytes_mb HEADING "Bytes|MB" FORMAT 999,999
COLUMN members HEADING "Members" FORMAT 999
COLUMN archived HEADING "Archived" FORMAT A3
COLUMN status HEADING "Status" FORMAT a10
SELECT thread#
,      inst_id
,      group#
,      (bytes / (1024*1024)) bytes_mb
,      members
,      archived
,      status
FROM   gv$log
ORDER BY thread#
,        inst_id
,        group#;
