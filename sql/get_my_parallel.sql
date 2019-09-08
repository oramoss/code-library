REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    get_my_parallel.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows parallel query details for the current user.
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************
break on qcsid
set linesize 132
set wrap off
select ps.qcsid
,      ps.sid
,      s.status status
,      TO_CHAR(ps.degree)||'/'||TO_CHAR(ps.req_degree) "Degree"
,      s.osuser
,      s.username
,      sl.message
,      (CASE WHEN INSTR(s.program,'P0') > 0 
             THEN SUBSTR(s.program,INSTR(s.program,'P0'),4)
             END) PX
,      sw.event wait_event
,      s.wait_class
from v$px_session ps
,    v$session_longops sl
,    v$session s
,    v$session_wait sw
where ps.sid = sl.sid(+)
and   ps.sid = s.sid
and   ps.sid = sw.sid
and   sl.time_remaining(+) != 0
and   UPPER(s.osuser)=USER
order by ps.qcsid
,        ps.sid
,        ps.degree nulls first
,        sl.message
/
