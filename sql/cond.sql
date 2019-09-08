REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    cond.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows details for constraints for a given Owner/Table Name
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************
SELECT constraint_name
,      DECODE(r_constraint_name,NULL,'Check Constraint...',r_constraint_name) r_constraint_name
,      search_condition
,      status
,      validated
FROM   dba_constraints
WHERE  UPPER(table_name) = UPPER('&Table_name')
AND    owner = UPPER(NVL('&Owner',USER))
ORDER BY 4,2 NULLS LAST,1
/
