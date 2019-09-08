SELECT dip.index_name
,      dip.partition_name
,      dip.subpartition_count
,      dip.status
,      dip.tablespace_name
,      dip.compression
,      dip.blevel
,      dip.leaf_blocks
,      dip.distinct_keys
,      dip.avg_leaf_blocks_per_key
,      dip.avg_data_blocks_per_key
,      dip.clustering_factor
,      (DECODE((t.num_rows - t.blocks),0,0,(ip.clustering_factor) / (t.num_rows - t.blocks))) * 100 CLFPCT
FROM   dba_tables t
,      dba_indexes ip
,      dba_ind_partitions dip
WHERE  ip.table_name = t.table_name
AND    ip.index_name = dip.index_name
AND    UPPER(ip.table_name) = UPPER('&Table_name')
AND    ip.table_owner = UPPER(NVL('&Owner',USER))
AND    ip.table_owner = t.owner
ORDER BY dip.index_name
,        dip.partition_position
/
