--******************************************************************************
--*
--*  Description
--*  ***********
--*
--*  File:    tus.sql
--*
--*  Description: This script shows temp tablespace usage metrics by session,
--*               for the current database.
--*
--* ----------------------------------------------------------------------------
--* Date         Author             Description
--* ===========  =================  ============================================
--* 27-JAN-2009  Jeff Moss          Created
--* 16-MAY-2013  Jeff Moss          Added RAC inst_id and use GV$
--*

COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN username HEADING "UserName" FORMAT a30
COLUMN osuser HEADING "OS User" FORMAT A10
COLUMN qcsid HEADING "QC" FORMAT 9999
COLUMN sid HEADING "SID" FORMAT 9999
COLUMN segtype HEADING "Segment|Type" FORMAT A10
COLUMN sql_id HEADING "SQL ID" FORMAT A15

CLEAR BREAKS
COMPUTE SUM OF sum_blocks ON qcsid
COMPUTE SUM OF sum_blocks ON osuser
COMPUTE SUM OF sum_blocks ON report
COMPUTE SUM OF sum_mb ON qcsid
COMPUTE SUM OF sum_mb ON osuser
COMPUTE SUM OF sum_mb ON report
BREAK ON username ON osuser ON qcsid ON report

SELECT s.inst_id
,      s.username
,      s.osuser
,      ps.qcsid
,      s.sid
,      su.segtype
,      su.sql_id
,      SUM(su.blocks) sum_blocks
,      ROUND(SUM(su.blocks) * dt.block_size / (1024 * 1024) ) sum_mb
FROM   gv$sort_usage su
,      gv$session s
,      gv$px_session ps
,      dba_tablespaces dt
WHERE  s.sid = ps.sid(+)
AND    s.saddr = su.session_addr
AND    s.serial# = su.session_num
AND    su.tablespace = dt.tablespace_name
AND    s.inst_id = ps.inst_id(+)
AND    s.inst_id = su.inst_id
GROUP BY s.inst_id
,        s.username
,        s.osuser
,        s.sid
,        ps.qcsid
,        su.contents
,        su.segtype
,        su.sqladdr
,        su.sqlhash
,        su.sql_id
,        dt.block_size
ORDER BY s.inst_id
,        s.username
,        s.osuser
,        ps.qcsid
,        su.sqladdr
,        s.sid
/
