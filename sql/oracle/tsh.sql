SET PAGESIZE 1000
SET LINESIZE 250
SET WRAP OFF
COLUMN inst_id HEADING "Inst|ID" FORMAT 999
COLUMN tablespace_name HEADING "Tablespace|Name" FORMAT A20
COLUMN blocks_used HEADING "Blocks|Used" FORMAT 999,999,999
COLUMN blocks_free HEADING "Blocks|Free" FORMAT 999,999,999
SELECT inst_id
,      tablespace_name
,      SUM(blocks_used) blocks_used
,      SUM(blocks_free) blocks_free
FROM   gv$temp_space_header
GROUP BY inst_id
,        tablespace_name
ORDER BY inst_id
,        tablespace_name;
