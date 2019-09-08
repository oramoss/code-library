SET WRAP OFF
COLUMN instance HEADING "Instance|ID" FORMAT 999
COLUMN sid HEADING "SID" FORMAT 99999
COLUMN session_serial# HEADING "Ser#" FORMAT 99999
COLUMN blocker_instance HEADING "Blocker|Instance|ID" FORMAT 999
COLUMN blocker_sid HEADING "Blocker|SID" FORMAT 99999
COLUMN num_waiters HEADING "Waiters" FORMAT 999
COLUMN chain_id HEADING "Chain|ID" FORMAT 999
COLUMN chain_is_cycle HEADING "Chain|Is Cycle" FORMAT A5
COLUMN time_remaining_secs HEADING "Time(s)|Remaining" FORMAT 999
COLUMN row_wait_obj# HEADING "Row Wait|Obj#" FORMAT 99999999
COLUMN row_wait_file# HEADING "Row Wait|File#" FORMAT 99999
COLUMN row_wait_block# HEADING "Row Wait|Block#" FORMAT 99999999
COLUMN row_wait_row# HEADING "Row Wait|Row#" FORMAT 99999
SELECT instance
,      sid
,      sess_serial#
,      blocker_instance
,      blocker_sid
,      num_waiters
,      chain_id
,      chain_is_cycle
,      time_remaining_secs
,      row_wait_obj#
,      row_wait_file#
,      row_wait_block#
,      row_wait_row#
FROM   v$wait_chains
WHERE  blocker_is_valid = 'TRUE'
ORDER BY chain_id;
