REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    get_parallel_stats.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows various details for parallel query including:
REM     Large Pool stats
REM     PQ Process System Stats
REM     Parallel parameters
REM     PQ System Stats
REM     PQ Session stats
REM     Active PQ sessions and what they are up to
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************

REM break on qcsid on sql_id
REM set wrap off
REM set linesize 190
REM set pagesize 10000

@@sgas

@@pxps

@@par parallel

@@pqss

@@pqses

@@syss Parallel

@@psd

REM select p.*
REM ,s.username
REM ,s.osuser
REM ,      c.sql_text
REM from v$px_process p
REM ,    v$session s
REM ,      v$sqlarea c
REM where p.sid=s.sid
REM and    s.sql_address = c.address

