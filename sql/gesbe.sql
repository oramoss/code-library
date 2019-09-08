SET WRAP OFF
COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN resource_name1 HEADING "Resource|Name1" FORMAT A30
COLUMN grant_level HEADING "Grant|Level" FORMAT A9
COLUMN request_level HEADING "Request|Level" FORMAT A9
COLUMN pid HEADING "PID" FORMAT 999999999
COLUMN owner_node HEADING "Owner|Node" FORMAT 999999
COLUMN which_queue HEADING "Which|Queue" FORMAT 999999
COLUMN state HEADING "State" FORMAT A20
COLUMN blocked HEADING "Blocked" FORMAT 999999
COLUMN blocker HEADING "Blocker" FORMAT 999999
SELECT inst_id
,      resource_name1
,      grant_level
,      request_level
,      pid
,      owner_node
,      which_queue
,      state
,      blocked
,      blocker
FROM   gv$ges_blocking_enqueue
WHERE  blocker = 1
ORDER BY inst_id
,        pid
/
