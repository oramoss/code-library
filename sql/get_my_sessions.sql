select s.sid,s.serial#,s.program
,substr(q.sql_text,1,60) SQL
from v$session s
,v$sql q
where s.username=USER
and s.sql_id=q.sql_id(+)
and s.sql_child_number = q.child_number(+)
/
