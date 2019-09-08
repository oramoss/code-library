SET LINESIZE 250
SET PAGESIZE 1000
SET WRAP OFF
COLUMN inst_id HEADING "Inst|ID" FORMAT 999
COLUMN owner HEADING "Owner" FORMAT a15
COLUMN buffer_pool HEADING "Buffer|Pool" FORMAT a10
COLUMN object_name HEADING "Object|Name" FORMAT a30
COLUMN blocks HEADING "Total|Blocks" FORMAT 999999999
COLUMN cached_blocks HEADING "Cached|Blocks" FORMAT 999999999
SELECT v.inst_id
,      do.owner
,      ds.buffer_pool
,      do.object_name
,      ds.blocks
,      COUNT(*) cached_blocks
FROM   dba_objects do
,      dba_segments ds
,      gv$bh v
WHERE  do.data_object_id = v.objd
AND    do.owner = ds.owner(+)
AND    do.object_name = ds.segment_name(+)
AND    do.object_type = ds.segment_type(+)
GROUP BY v.inst_id
,      do.owner
,        ds.buffer_pool
,        do.object_name
,        ds.blocks
ORDER BY COUNT(*) DESC
,        do.object_name
,        ds.buffer_pool;