SELECT username
,      v$lock.sid
,      TRUNC(id1/POWER(2,16)) rbs
,id1
,      BITAND(id1,TO_NUMBER('ffff','xxxx'))+0 slot
,      id2 seq
,      lmode
,      request
,v$lock.type
FROM   v$lock, v$session
WHERE  1=1
--AND    v$lock.type = 'TX'
AND    v$lock.sid = v$session.sid
AND username='AE_SCRATCH'
and v$lock.sid=803
/

