SELECT segment_name, segment_type, owner, tablespace_name 
FROM   sys.dba_extents 
WHERE  file_id = &file_num
AND    &block_num
BETWEEN block_id AND block_id + blocks -1
/

