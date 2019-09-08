REM **********************************************************************************
REM
REM File:    get_ae_sql_response_time_histogram.sql
REM Purpose: Gets a count of SQL executions by elapsed time buckets (histogram)
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM              Jeff Moss          Initial Version
REM
REM **********************************************************************************
WITH min_max_snap AS
(
SELECT MIN(snap_id) min_snap_id
,      MAX(snap_id) max_snap_id
FROM   dba_hist_snapshot
WHERE  TRUNC(begin_interval_time) > TRUNC(ADD_MONTHS(SYSDATE,-1))
)
, all_rows AS
(
SELECT ash.user_id
,      CAST(MIN(ash.sample_time) OVER(PARTITION BY ash.instance_number,ash.sql_id,ash.sql_exec_start,ash.sql_exec_id,ash.sql_child_number) AS DATE) min_sample_time
,      CAST(MAX(ash.sample_time) OVER(PARTITION BY ash.instance_number,ash.sql_id,ash.sql_exec_start,ash.sql_exec_id,ash.sql_child_number) AS DATE) max_sample_time
,      ROW_NUMBER() OVER(PARTITION BY ash.instance_number,ash.sql_id,ash.sql_exec_start,ash.sql_exec_id,ash.sql_child_number
                         ORDER BY ash.sample_time DESC) rn
,      ash.instance_number,ash.sql_id,ash.sql_exec_start,ash.sql_exec_id,ash.sql_child_number
,      ROUND(MAX(pga_allocated) OVER(PARTITION BY ash.instance_number,ash.sql_id,ash.sql_exec_start,ash.sql_exec_id,ash.sql_child_number) / (1024*1024)) max_pga_allocated_mb
,      ROUND(MAX(temp_space_allocated) OVER(PARTITION BY ash.instance_number,ash.sql_id,ash.sql_exec_start,ash.sql_exec_id,ash.sql_child_number) / (1024*1024)) max_temp_space_allocated_mb
FROM   dba_hist_active_sess_history ash
,      min_max_snap mms
WHERE  ash.snap_id BETWEEN mms.min_snap_id AND mms.max_snap_id
AND    ash.sql_exec_id IS NOT NULL
AND    ash.sql_exec_start IS NOT NULL
AND    ash.user_id NOT IN(0)
)
SELECT --du.initial_rsrc_consumer_group,
      (CASE WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= 5 THEN 'Bucket 1: <5s'
             WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= 20 THEN 'Bucket 2: <20s'
             WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= 30 THEN 'Bucket 3: <30s'
             WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= 60 THEN 'Bucket 4: <60s'
             WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= (5 * 60) THEN 'Bucket 5: <5m'
             WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= (10 * 60) THEN 'Bucket 6: <10m'
             WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= (20 * 60) THEN 'Bucket 7: <20m'
             WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= (60 * 60) THEN 'Bucket 8: <1h'
             ELSE 'Bucket 9: >1h'
              END) elapsed_time_bucket
,      COUNT(DISTINCT TO_CHAR(sql_id)||TO_CHAR(sql_child_number)||TO_CHAR(sql_exec_id))
FROM   all_rows ar
,      dba_users du
WHERE  ar.rn = 1
AND    ar.user_id = du.user_id(+)
GROUP BY --du.initial_rsrc_consumer_group,
        (CASE WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= 5 THEN 'Bucket 1: <5s'
               WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= 20 THEN 'Bucket 2: <20s'
               WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= 30 THEN 'Bucket 3: <30s'
               WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= 60 THEN 'Bucket 4: <60s'
               WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= (5 * 60) THEN 'Bucket 5: <5m'
               WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= (10 * 60) THEN 'Bucket 6: <10m'
               WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= (20 * 60) THEN 'Bucket 7: <20m'
               WHEN (CAST(ar.max_sample_time - ar.min_sample_time AS NUMBER) * 24 * 60 * 60) <= (60 * 60) THEN 'Bucket 8: <1h'
               ELSE 'Bucket 9: >1h'
                END)
ORDER BY 1,2
/
