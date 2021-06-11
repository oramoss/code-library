set echo off
set pagesize 10000
set timing off
set verify off
set feed off
column sql_text format a132
ACCEPT owner PROMPT 'Please enter Name of Table Owner: '
ACCEPT table_name PROMPT 'Please enter Name of Table Name: '

spool tab_grants.sql

select 'GRANT '||privilege||' ON '||owner||'.'||table_name||' TO '||grantee||
case when grantable = 'YES' then ' with grant option;' else ';' end
from dba_tab_privs
where owner='&&owner'
and table_name='&&table_name'
/

spool off

set pagesize 10000
set timing on
set feed on
