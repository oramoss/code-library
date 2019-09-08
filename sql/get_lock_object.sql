REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    get_lock_object.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script gets lock and object information
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 15-JAN-2010  Jeff Moss          Initial Version
REM
REM *************************************************************************
select lck.sid
,      lck.type
,      lck.lmode
,      lck.request
,      lck.ctime
,      lck.block
,      obj.owner
,      obj.object_name
FROM   v$lock lck
,      dba_objects obj
WHERE  lck.id1 = obj.object_id
/
