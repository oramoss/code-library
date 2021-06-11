SET LINESIZE 200
SET WRAP OFF
SET TRIMSPOOL OFF
COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN qcsid HEADING "QC|SID" FORMAT 999,999
COLUMN sql_id HEADING "SQL|ID" FORMAT a15
COLUMN sid HEADING "SID" FORMAT 999,999
COLUMN status HEADING "Status" FORMAT A8
COLUMN degree HEADING "Degree" FORMAT A9
COLUMN osuser HEADING "OS|User" FORMAT A15
COLUMN username HEADING "Username" FORMAT A30
COLUMN message HEADING "Message" FORMAT A50
COLUMN px HEADING "PX|Slave" FORMAT A5
COLUMN wait_event HEADING "Wait|Event" FORMAT A10
SELECT ps.inst_id
,      ps.qcsid
,      ps.sid
,      s.sql_id
,      s.status status
,      TO_CHAR(ps.degree)||'/'||TO_CHAR(ps.req_degree) "Degree"
,      s.osuser
,      NVL((CASE WHEN INSTR(s.program,'P0') > 0
             THEN SUBSTR(s.program,INSTR(s.program,'P0'),4)
             END),'-') px
,      sw.state||'('||sw.event||')' wait_event
,      s.username
,      NVL(sl.message,'-') message
FROM  gv$px_session ps
,     gv$session_longops sl
,     gv$session s
,     gv$session_wait sw
WHERE ps.inst_id = sl.inst_id(+)
AND   ps.sid = sl.sid(+)
AND   ps.inst_id = s.inst_id
AND   ps.sid = s.sid
AND   ps.sid = sw.sid
AND   ps.inst_id = sw.inst_id
AND   sl.time_remaining(+) != 0
AND   ( (ps.sid = ps.qcsid AND s.status ='ACTIVE')
       OR
        (ps.sid != ps.qcsid AND EXISTS(SELECT 1
                                       FROM   v$px_session ps2
                                       ,      v$session s2
                                       WHERE  ps2.sid = s2.sid
                                       AND    ps.qcsid = ps2.sid
                                       AND    s2.status = 'ACTIVE')
        )
      )
AND   sw.event NOT LIKE '%rdbms ipc message%'
AND   sw.event NOT LIKE '%Streams AQ:%'
ORDER BY ps.inst_id
,        ps.qcsid
,        s.status
,        ps.sid
,        ps.degree NULLS FIRST
,        sl.message
/

