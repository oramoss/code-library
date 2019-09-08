REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    trgd.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows details triggers for a given Owner/Table Name
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************
SELECT trigger_name
,trigger_type
,triggering_event
,status
FROM   dba_triggers
WHERE  UPPER(table_name) = UPPER('&Table_name')
AND    table_owner = UPPER(NVL('&Owner',USER))
/
