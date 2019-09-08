undefine sql_id
undefine child_no
set lines 220
select * from table(dbms_xplan.display_cursor('&sql_id','&child_no','allstats  +peeked_binds'))
/

