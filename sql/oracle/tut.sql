--******************************************************************************
--*
--*  Description
--*  ***********
--*
--*  File:    tut.sql
--*
--*  Description: This script shows temp tablespace usage metrics for the
--*               current database.
--*
--* ----------------------------------------------------------------------------
--* Date         Author             Description
--* ===========  =================  ============================================
--* 27-JAN-2009  Jeff Moss          Created
--*
COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN tablespace_name HEADING "Tablespace|Name" FORMAT a30
COLUMN block_size HEADING "Block|Size" FORMAT 99999
COLUMN free_blocks HEADING "Free|Blocks GB" FORMAT 999
COLUMN used_blocks HEADING "Used|Blocks GB" FORMAT 999
COLUMN total_blocks HEADING "Total|Blocks GB" FORMAT 999
SELECT ss.inst_id
,      dt.tablespace_name
,      dt.block_size
,      ROUND(ss.free_blocks * dt.block_size / (1024 * 1024 * 1024)) free_blocks_GB
,      ROUND(ss.used_blocks * dt.block_size / (1024 * 1024 * 1024)) used_blocks_GB
,      ROUND(ss.total_blocks * dt.block_size / (1024 * 1024 * 1024)) total_blocks_GB
FROM   gv$sort_segment ss
,      dba_tablespaces dt
WHERE  ss.tablespace_name = dt.tablespace_name
ORDER BY ss.inst_id
,        dt.tablespace_name
/
