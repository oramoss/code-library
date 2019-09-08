REM **********************************************************************************
REM
REM File:    explain.sql
REM Purpose: Explains a plan for a statement - replace the statement to plan it!
REM          Calls gt_plan4 afterwards to show the plan.
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM              Jeff Moss          Initial Version
REM
REM **********************************************************************************

ACCEPT stmt CHAR FORMAT 'A20' PROMPT 'Enter Statement ID:  '
DELETE FROM plan_table
WHERE statement_id = '&stmt'
/
COMMIT
/
EXPLAIN PLAN SET STATEMENT_ID='&stmt' FOR
SELECT ...
/
@@gt_plan4
DELETE FROM plan_table
WHERE statement_id = '&stmt'
/
COMMIT
/
