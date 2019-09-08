SET PAGESIZE 1000
SET LINESIZE 250
SET WRAP OFF
COLUMN inst_id HEADING "Inst|ID" FORMAT 999
COLUMN group# HEADING "Group#" FORMAT 999
COLUMN status HEADING "Status" FORMAT a7
COLUMN type HEADING "Type" FORMAT a7
COLUMN member HEADING "Member" FORMAT a60
COLUMN is_recovery_dest_file HEADING "Is Recovery|Dest File?" FORMAT a3
SELECT inst_id
,      group#
,      status
,      type
,      member
,      is_recovery_dest_file
FROM   gv$logfile
ORDER BY inst_id
,        group#
,        is_recovery_dest_file;
