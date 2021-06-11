undefine search
select *
from   v$parameter p
where UPPER(name) like UPPER('%&search%')
order by 1
/
