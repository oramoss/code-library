set pages 300 lines 300
col wait_event format a30
select 
  sw.SID as RCVSID,
  decode(pp.server_name, 
         NULL, 'A QC', 
         pp.server_name) as RCVR,
  sw.inst_id as RCVRINST,
case  sw.state WHEN 'WAITING' THEN substr(sw.event,1,30) ELSE NULL end as wait_event ,
  decode(bitand(p1, 65535),
         65535, 'QC', 
         'P'||to_char(bitand(p1, 65535),'fm000')) as SNDR,
  bitand(p1, 16711680) - 65535 as SNDRINST,
  decode(bitand(p1, 65535),
         65535, ps.qcsid,
         (select 
            sid 
          from 
            gv$px_process 
          where 
            server_name = 'P'||to_char(bitand(sw.p1, 65535),'fm000') and
            inst_id = bitand(sw.p1, 16711680) - 65535)
        ) as SNDRSID,
   decode(sw.state,'WAITING', 'WAIT', 'NOT WAIT' ) as STATE     
from 
  gv$session_wait sw,
  gv$px_process pp,
  gv$px_session ps
where
  sw.sid = pp.sid (+) and
  sw.inst_id = pp.inst_id (+) and 
  sw.sid = ps.sid (+) and
  sw.inst_id = ps.inst_id (+) and 
  p1text  = 'sleeptime/senderid' and
  bitand(p1, 268435456) = 268435456
order by
  decode(ps.QCINST_ID,  NULL, ps.INST_ID,  ps.QCINST_ID),
  ps.QCSID,
  decode(ps.SERVER_GROUP, NULL, 0, ps.SERVER_GROUP), 
  ps.SERVER_SET, 
  ps.INST_ID
/
