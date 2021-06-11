REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    cbo.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows various pieces of information for a given table
REM   The purpose of the script is to provide information which the CBO
REM   may be using to determine its plans.
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 27-NOV-2007  Jeff Moss          Initial Version
REM *************************************************************************

REM Local settings...
SET TIMING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET NULL ~

UNDEFINE table_name
UNDEFINE owner

ACCEPT owner PROMPT 'Please enter Name of Table Owner: '
ACCEPT table_name PROMPT 'Please enter Table Name to show Statistics for: '

SET WRAP OFF

@@td
@@ppd
@@bpd
@@cd
@@pid
@@bid
REM @@pipd
REM @@bipd
@@icd
@@cond
REM @@trgd
@@pkd
@@skd

CLEAR BREAKS
SET TIMING ON
SET FEEDBACK ON
SET VERIFY ON

