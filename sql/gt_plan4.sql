REM **********************************************************************************
REM
REM File:    gt_plan.sql
REM Purpose: generates an explain plan definition
REM
REM **********************************************************************************
set scan on
set define on
set linesize 300
set pagesize 10000
set wrap off
--select plan_table_output from table(dbms_xplan.display('plan_table',null,'BASIC'))
select plan_table_output from table(dbms_xplan.display(format=>'ALL -PROJECTION'))
--select plan_table_output from table(dbms_xplan.display(format=>'ADVANCED'))
/

