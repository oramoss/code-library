COLUMN inst_id HEADING "Inst|ID" FORMAT 999
COLUMN tablespace_name HEADING "Tablespace|Name" FORMAT A10
COLUMN segment_file HEADING "Seg|File" FORMAT 999
COLUMN total_blocks HEADING "Tot|Blks" FORMAT 999,999,999
COLUMN used_blocks HEADING "Used|Blks" FORMAT 999,999,999
COLUMN free_blocks HEADING "Free|Blks" FORMAT 999,999,999
COLUMN max_used_blocks HEADING "Max Used|Blks" FORMAT 999,999
COLUMN max_sort_blocks HEADING "Max Sort|Blks" FORMAT 999,999
SELECT inst_id
,      tablespace_name
,      segment_file
,      total_blocks
,      used_blocks
,      free_blocks
,      max_used_blocks
,      max_sort_blocks 
FROM   gv$sort_segment
ORDER BY inst_id; 
