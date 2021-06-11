--******************************************************************************
--*
--*  Description
--*  ***********
--*
--*  File:    get_temp_usage_by_tablespace.sql
--*
--*  Description: This script shows temp tablespace usage metrics for the
--*               current database.
--*
--* ----------------------------------------------------------------------------
--* Date         Author             Description
--* ===========  =================  ============================================
--* 27-JAN-2009  Jeff Moss          Created
--*
SELECT dt.tablespace_name
,      dt.block_size
,      ROUND(ss.free_blocks * dt.block_size / (1024 * 1024 * 1024)) free_blocks_GB
,      ROUND(ss.used_blocks * dt.block_size / (1024 * 1024 * 1024)) used_blocks_GB
,      ROUND(ss.total_blocks * dt.block_size / (1024 * 1024 * 1024)) total_blocks_GB
FROM   v$sort_segment ss
,      dba_tablespaces dt
WHERE  ss.tablespace_name = dt.tablespace_name
ORDER BY dt.tablespace_name
/
