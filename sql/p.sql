REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    get_process.sql
REM *************************************************************************
REM PURPOSE:
REM   This Script shows details for a given process (SID).
REM *************************************************************************
set linesize 132
set wrap on
set long 40000
ACCEPT sid CHAR FORMAT 'A20' PROMPT 'Enter SID:  '
SELECT a.inst_id
,      SUBSTR(a.username,1,15) "User"
,      a.status "Status"
,      a.sid "SID"
,      a.audsid "AUDSID"
,      a.serial# "Serial"
,      a.last_call_et "Last Call ET"
,      c.parse_calls "Parse Calls"
,      c.loads "Loads"
,      c2.last_load_time
,      b.spid "OS PID"
,      a.osuser "OS User"
,      SUBSTR(b.program,1,15) "Program"
,      DECODE(xx.rb_name,NULL,'NO RBS!',xx.rb_name) "RB NAME"
,      t.used_ublk "Used RB Blks"
,      sw.event "Event"
,      sw.p1 "P1"
,      sw.p2 "P2"
,      sw.p3 "P3"
,      sw.seconds_in_wait "Secs Wait"
,      sw.state "State"
,      SUM(su.blocks*8192) / 1048576 "Sort Blocks (Mb)"
,      SUM(DECODE(statistic#,232,value,0)) total_parses
,      SUM(DECODE(statistic#,233,value,0)) hard_parses
,      (SUM(DECODE(statistic#,232,value,0)) - SUM(DECODE(statistic#,233,value,0))) soft_parses
,      ROUND(DECODE(SUM(DECODE(statistic#,232,value,0)),0,NULL,((SUM(DECODE(statistic#,232,value,0)) - SUM(DECODE(statistic#,233,value,0))) / SUM(DECODE(statistic#,232,value,0))) * 100)) soft_parse_ratio
,      c.sql_text
FROM   gv$session a
,      gv$session_wait sw
,      (SELECT inst_id
        ,      value
        ,      statistic#
        ,      sid
        FROM   gv$sesstat
        WHERE  statistic# in(232,233)
       ) s
,      gv$sort_usage su
,      gv$process b
,      gv$sql c2
,      gv$sqlarea c
,      (SELECT r.name rb_name
        ,      r.usn r_usn
        ,      l.sid l_sid
        ,      l.id1 l_id1
        ,      l.type
        ,      l.lmode
        FROM   v$rollname r
        ,      gv$lock l
        WHERE  1=1
        AND    TRUNC (l.id1(+)/65536) = r.usn
        AND    l.type(+) = 'TX'
        AND    l.lmode(+) = 6
       ) xx
,      gv$transaction t
WHERE  a.paddr=b.addr(+)
AND    a.inst_id = sw.inst_id(+)
AND    a.inst_id = s.inst_id(+)
AND    a.inst_id = su.inst_id(+)
AND    a.inst_id = b.inst_id(+)
AND    a.inst_id = c2.inst_id(+)
AND    a.inst_id = c.inst_id(+)
AND    a.inst_id = t.inst_id(+)
and    su.session_addr(+) = a.saddr
and    a.sql_address = c.address(+)
and    a.sql_address = c2.address(+)
and    a.audsid !=0
and    xx.l_sid(+) = a.sid
and    s.sid(+) = a.sid
AND    t.addr(+) = a.taddr
AND    a.sid = &sid
AND    a.sid = sw.sid(+)
GROUP BY a.inst_id
,      SUBSTR(a.username,1,15)
,      a.status
,      a.sid
,      a.audsid
,      a.serial#
,      a.last_call_et
,      c.parse_calls
,      c.loads
,      c2.last_load_time
,      b.spid
,      a.osuser
,      SUBSTR(b.program,1,15)
,      DECODE(xx.rb_name,NULL,'NO RBS!',xx.rb_name)
,      t.used_ublk
,      sw.event
,      sw.seconds_in_wait
,      sw.state
,      c.sql_text
,      sw.p1
,      sw.p2
,      sw.p3
ORDER BY a.status desc
,        a.sid
,        SUBSTR(a.username,1,15)
,        a.osuser
/
SELECT t.sql_text
FROM v$sqltext t
, v$session s
WHERE t.address(+)=s.sql_address
AND s.sid=&sid
ORDER BY t.piece
/
SELECT * FROM v$open_cursor
WHERE sid=&sid
/
SELECT * FROM v$sess_io
WHERE sid=&sid
/

