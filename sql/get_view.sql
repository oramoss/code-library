set linesize 132
set wrap on
set long 400000
select owner,text 
from dba_views
where Upper(view_name)=upper('&viewname')
/
