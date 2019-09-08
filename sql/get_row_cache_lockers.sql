select h.address
,      h.saddr
,      s.sid
,      h.lock_mode
from   v$rowcache_parent h
,      v$rowcache_parent w
,      v$session s
where  h.address = w.address 
and    w.saddr = (select saddr from v$session where event = 'row cache lock' and rownum = 1) 
and    h.saddr = s.saddr 
and    h.lock_mode > 0
/
