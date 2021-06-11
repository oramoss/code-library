SET LINESIZE 250
SET WRAP ON
SET LONG 40000
COLUMN instance_number HEADING "Inst|Num" FORMAT 999
COLUMN snap_id HEADING "Snap|ID" FORMAT 999999
COLUMN event HEADING "Event" FORMAT A64
COLUMN session_state HEADING "Session|State" FORMAT A7
COLUMN sql_id HEADING "SQL|ID" FORMAT 999999

UNDEFINE event
UNDEFINE start_time
UNDEFINE end_time
ACCEPT event PROMPT 'Please enter event (Leave blank for all events): '
ACCEPT start_time PROMPT 'Please enter start_time (Format DD-MON-YYYY HH24:MI:SS): '
ACCEPT end_time PROMPT 'Please enter end_time (Format DD-MON-YYYY HH24:MI:SS): '

SELECT instance_number
,      snap_id
,      event
,      session_state
,      sql_id
,      COUNT(*)
FROM   dba_hist_active_sess_history
WHERE  UPPER(event) LIKE UPPER('%&event%')
AND    snap_id = (SELECT DISTINCT snap_id
                  FROM   dba_hist_snapshot
                  WHERE  end_interval_time BETWEEN TO_DATE('&start_time','DD-MON-YYYY HH24:MI:SS')
                  AND    TO_DATE('&end_time','DD-MON-YYYY HH24:MI:SS')
                 )
GROUP BY instance_number
,        snap_id
,        event
,        session_state
,        sql_id
ORDER BY COUNT(*) DESC;
     
