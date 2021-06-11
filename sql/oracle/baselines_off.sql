REM **********************************************************************************
REM
REM File:    baselines_off.sql
REM Purpose: Turns of SQL Plan Baselines
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM              Jeff Moss          Initial Version
REM
REM **********************************************************************************
alter session set optimizer_capture_sql_plan_baselines = false
/
