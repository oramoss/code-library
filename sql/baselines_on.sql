REM **********************************************************************************
REM
REM File:    baselines_on.sql
REM Purpose: Turns on SQL Plan Baselines
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM              Jeff Moss          Initial Version
REM
REM **********************************************************************************
alter session set optimizer_capture_sql_plan_baselines = true
/
