COLUMN inst_id HEADING "Inst|ID" FORMAT 999
COLUMN id1 HEADING "ID1" FORMAT 999
COLUMN id2 HEADING "ID2" FORMAT 999
COLUMN time_secs HEADING "Time|Seconds" FORMAT 99999
COLUMN sid HEADING "SID" FORMAT 9999
COLUMN type HEADING "Type" FORMAT A6
COLUMN username HEADING "Username" FORMAT A15
COLUMN serial# HEADING "Serial" FORMAT 99999
COLUMN process HEADING "Process" FORMAT 99999
COLUMN lmode HEADING "Lock|Mode" FORMAT A10
COLUMN request HEADING "Request" FORMAT A10
COLUMN state HEADING "State" FORMAT A10
SELECT g.inst_id
,      g.id1
,      g.id2
,      (g.ctime / 100) time_secs
,      s.sid
,      g.type
,      s.username 
,      s.serial#
,      s.process 
,      DECODE(lmode,0,'None',1,'Null',2,'Row-S',3,'Row-X',4,'Share',5,'S/ROW', 6,'Exclusive') lmode
,      DECODE(request,0,'None',1,'Null',2,'Row-S',3,'Row-X',4,'Share', 5,'S/ROW',6,'Exclusive') request 
,      DECODE(request,0,'BLOCKER','WAITER') state
FROM   gv$global_blocked_locks g
,      gv$session s
WHERE  g.sid = s.sid
AND    g.inst_id = s.inst_id 
ORDER BY s.state;

