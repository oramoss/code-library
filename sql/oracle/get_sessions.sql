select s.sid
,s.program
,s.username
,s.osuser
,t.used_ublk
,      SUM(DECODE(e.statistic#,41,e.value,0)) cgs
,      SUM(DECODE(e.statistic#,12,e.value,0)) cpu
,      SUM(DECODE(e.statistic#,20,e.value,0)) spm
,      SUM(DECODE(e.statistic#,21,e.value,0)) spm_max
,      SUM(DECODE(e.statistic#,232,e.value,0)) total_parses
,      SUM(DECODE(e.statistic#,233,e.value,0)) hard_parses
,      (SUM(DECODE(e.statistic#,232,e.value,0)) - SUM(DECODE(e.statistic#,233,e.value,0))) soft_parses
,      ROUND(DECODE(SUM(DECODE(e.statistic#,232,e.value,0)),0,NULL,((SUM(DECODE(e.statistic#,232,e.value,0)) - SUM(DECODE(e.statistic#,233,e.value,0))) / SUM(DECODE(statistic#,232,value,0))) * 100)) soft_parse_ratio
,q.sql_text
from v$session s
,    (SELECT sid
      ,      statistic#
      ,      value
      FROM   v$sesstat
      WHERE  statistic# IN(12,20,21,41,232,233)
     ) e
,    v$transaction t
,v$sql q
where t.addr(+) = s.taddr
AND   e.sid(+) = s.sid
and s.sql_id=q.sql_id
and s.sql_child_number = q.child_number
--and lower(s.osuser)='aebatch'
GROUP BY s.sid
,s.program
,s.username
,s.osuser
,t.used_ublk
,q.sql_text
order by 6 desc
/
