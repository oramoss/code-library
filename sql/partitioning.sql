REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    partitioning.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows various partitioning pieces of information for a given table
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 24-NOV-2010  Jeff Moss          Initial Version
REM
REM *************************************************************************
@@setup_sqlplus

REM Local settings...
SET TIMING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET NULL ~

UNDEFINE table_name
UNDEFINE owner

PROMPT

ACCEPT owner PROMPT 'Please enter Name of Table Owner: '
ACCEPT table_name PROMPT 'Please enter Table Name to show Statistics for: '

SET WRAP OFF

@@pkd
@@skd

CLEAR BREAKS
SET TIMING ON
SET FEEDBACK ON
SET VERIFY ON

