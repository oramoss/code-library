set linesize 400
set wrap on
set long 400000
column text format a250
select text 
from   dba_views
where Upper(view_name)=upper('&view_name')
/
