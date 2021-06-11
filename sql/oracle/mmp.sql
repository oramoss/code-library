alter session set NLS_TIMESTAMP_TZ_FORMAT = 'DD-MON-YYYY HH24.MI.SS.FF';
COLUMN pga_allocated FORMAT 999,999,999,999,990
COLUMN sql_text FORMAT A50
SET WRAP OFF
REM Maximum PGA Memory by SQL_ID over the last 24 hours...
WITH group_px AS
(
SELECT instance_number
,      dbid
,      sql_id
,      sample_time
,      SUM(pga_allocated) pga_allocated -- group up for parallel queries
FROM   sys.wrh$_active_session_history
WHERE  TRUNC(sample_time) > (SYSDATE - 1)
GROUP BY instance_number
,        dbid
,        sql_id
,        sample_time
)
, add_rn AS
(
SELECT gp.instance_number
,      gp.sql_id
,      gp.sample_time
,      gp.pga_allocated
,      tex.sql_text
,      ROW_NUMBER() OVER(PARTITION BY gp.instance_number,gp.sql_id ORDER BY gp.pga_allocated DESC) rn
FROM   group_px gp
,      sys.wrh$_sqltext tex
WHERE  gp.sql_id = tex.sql_id(+)
AND    gp.dbid = tex.dbid(+)
)
SELECT instance_number
,      sql_id
,      sample_time
,      sql_text
,      pga_allocated
FROM   add_rn
WHERE  rn = 1
AND    ROUND((pga_allocated / (1024*1024*1024)),2) > 5 -- Filter out the small stuff
ORDER BY pga_allocated DESC,sample_time
/
