REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    get_asm_disk_group_usage.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows the ASM Disk Groups and their Segment, Free and Recycle
REM   sizes.
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 06-OCT-2010  Jeff Moss          Initial Version
REM
REM *************************************************************************
@@setup_sqlplus
WITH ddf_tablespace_stats AS
(
select substr(ddf.file_name,2,4) asm_disk_group
,      tablespace_name
,      round(sum(ddf.bytes)/(1024*1024*1024)) total_datafile_size_gb
,      round(sum(ddf.blocks)) total_datafile_size_blocks
from   dba_data_files ddf
group by substr(ddf.file_name,2,4)
,        tablespace_name
)
,ds_tablespace_stats AS
(
select ds.tablespace_name
,      round(sum(ds.bytes)/(1024*1024*1024)) total_segment_size_gb
,      round(sum(ds.blocks)) total_segment_size_blocks
from   dba_segments ds
group by ds.tablespace_name
)
,drb_tablespace_stats AS
(
select drb.ts_name tablespace_name
,      round(sum(drb.space)) total_recyclebin_size_blocks
from   dba_recyclebin drb
group by drb.ts_name
)
, dfs_tablespace_stats AS
(
select /*+ use_hash (A.ts A.fi) */ tablespace_name
,      round(sum(dfs.bytes)/(1024*1024*1024)) total_free_size_gb
,      round(sum(dfs.blocks)) total_free_size_blocks
from   dba_free_space dfs
group by tablespace_name
)
SELECT ddf.asm_disk_group
,      SUM(ddf.total_datafile_size_gb) total_datafile_size_gb
,      SUM(ddf.total_datafile_size_blocks) total_datafile_size_blocks
,      SUM(ds.total_segment_size_gb) total_segment_size_gb
,      SUM(ds.total_segment_size_blocks) total_segment_size_blocks
,      SUM(dfs.total_free_size_gb) total_free_size_gb
,      SUM(dfs.total_free_size_blocks) total_free_size_blocks
,      ROUND(SUM(drb.total_recyclebin_size_blocks * 32 / (1024*1024))) total_recyclebin_size_gb
,      SUM(drb.total_recyclebin_size_blocks) total_recyclebin_size_blocks
FROM   ddf_tablespace_stats ddf
,      ds_tablespace_stats ds
,      dfs_tablespace_stats dfs
,      drb_tablespace_stats drb
WHERE  ddf.tablespace_name = ds.tablespace_name(+)
AND    ddf.tablespace_name = dfs.tablespace_name(+)
AND    ddf.tablespace_name = drb.tablespace_name(+)
GROUP BY ddf.asm_disk_group
/
