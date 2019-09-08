SET LINESIZE 250
SET WRAP OFF
SET PAGESIZE 1000
COLUMN inst_id HEADING "Inst|ID" FORMAT 999
COLUMN tablespace_name HEADING "Tablespace|Name" FORMAT a10
COLUMN file_id HEADING "File|ID" FORMAT 999
COLUMN extents_cached HEADING "Extents|Cached" FORMAT 999,999,999
COLUMN extents_used HEADING "Extents|Used" FORMAT 999,999,999
COLUMN blocks_cached HEADING "Blocks|Cached" FORMAT 999,999,999
COLUMN blocks_used HEADING "Blocks|Used" FORMAT 999,999,999
COLUMN bytes_cached HEADING "Bytes|Cached" FORMAT 999,999,999,999
COLUMN bytes_used HEADING "Bytes|Used" FORMAT 999,999,999,999
SELECT inst_id
,      tablespace_name
,      file_id
,      extents_cached
,      extents_used 
,      blocks_cached
,      blocks_used 
,      bytes_cached
,      bytes_used 
FROM   gv$temp_extent_pool;
