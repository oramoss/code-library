REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    table_details.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows details from DBA_TABLES for a given Owner/Table Name
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************
SELECT owner
,      table_name
,      degree
,      last_analyzed
,      freelists
,      logging
FROM   dba_tables
WHERE  owner = UPPER(NVL('&&Owner',USER))
AND    UPPER(table_name) = UPPER('&&Table_name')
/
