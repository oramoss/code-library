REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    ap.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows the actual plan that a piece of SQL is executing with
REM   Supply with SID for the session running the SQL and then choose the SQL_ID
REM   from the list offered (generally 1 choice).
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************
UNDEFINE sid
UNDEFINE sql_id

ACCEPT sid NUMBER FORMAT 9999999990 PROMPT 'Enter SID:  '

-- Columns to set SQL Prompt...
COLUMN sql_id NEW_VALUE sql_id

select sql_id,sql_child_number
from v$session
where sid = &sid
/
ACCEPT child_number NUMBER FORMAT 9999999990 PROMPT 'Enter Child Number:  '

select * from table(dbms_xplan.display_cursor('&sql_id',&child_number,'ALLSTATS LAST'))
/
