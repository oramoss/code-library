UNDEFINE table_name
ACCEPT table_name PROMPT 'Please enter Table Name: '

select 'grant '|| privilege||' on '||owner||','||table_name||' to '||grantee||
case when grantable = 'YES' then ' with grant option;' else ';' end
from dba_tab_privs
where table_name='&table_name'
/
