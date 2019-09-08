SELECT ss.dbid
--******************************************************************************
--*
--*  Description
--*  ***********
--*
--*  Written in response to a blog post from Kevin Closson:
--*
--*  http://kevinclosson.wordpress.com/2009/04/28/how-to-produce-raw-spreadsheet-
--*         ready-physical-io-data-with-plsql-good-for-exadata-good-for-
--*         traditional-storage/#comment-34219
--*
--*  Looks at AWR repository to determine IO stats by snapshot period.
--*
--*  Granularity is obviously determined by the AWR snapshot frequency.
--*
--*  Can add other statistics as you see fit. Currently shows:
--*
--*   39  physical read total bytes
--*   42  physical write total bytes
--*
--*  NOTE - Instance bounces will cause negative values for the first snap
--*         after the bounce.
--*
--* ----------------------------------------------------------------------------
--* Date         Author             Description
--* ===========  =================  ============================================
--* 30-APR-2009  Jeff Moss          Created
--******************************************************************************
,      ss.instance_number
,      ss.snap_id
,      ss.begin_interval_time
,      (ss.end_interval_time - ss.begin_interval_time) snap_duration
,      hs.stat_name
,      hs.value
,      ROUND(((hs.value - LAG(hs.value) OVER(PARTITION BY ss.dbid,ss.instance_number,hs.stat_id
                                             ORDER BY ss.snap_id)) / (1024*1024))) mb
,      ROUND(((hs.value - LAG(hs.value) OVER(PARTITION BY ss.dbid,ss.instance_number,hs.stat_id
                                        ORDER BY ss.snap_id)) / (1024*1024) )
        / (extract( SECOND from (ss.end_interval_time - ss.begin_interval_time))+
           extract( MINUTE from (ss.end_interval_time - ss.begin_interval_time))*60+
           extract( HOUR from (ss.end_interval_time - ss.begin_interval_time))*60*60+
           extract( DAY from (ss.end_interval_time - ss.begin_interval_time))*60*60*24)) avg_mb_per_sec
FROM   dba_hist_snapshot ss
,      dba_hist_sysstat hs
WHERE  ss.dbid=hs.dbid
AND    ss.instance_number=hs.instance_number
AND    ss.snap_id=hs.snap_id
AND    hs.stat_id IN(SELECT stat_id FROM v$statname WHERE statistic# IN(39,42))
ORDER BY hs.dbid
,        hs.instance_number
,        hs.snap_id
,        hs.stat_id
/
