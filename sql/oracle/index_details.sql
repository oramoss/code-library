SELECT i.index_name
,      i.index_type
,      i.status
,      DECODE(i.uniqueness,'UNIQUE','Yes','No') uniqueness
,      i.blevel blev
,      i.leaf_blocks
,      i.distinct_keys
,      DECODE(t.num_rows,0,-1,(i.distinct_keys / t.num_rows) * 100) cardinality
,      i.compression
,      i.avg_leaf_blocks_per_key
,      i.avg_data_blocks_per_key
,      i.clustering_factor
,      (DECODE((t.num_rows - t.blocks),0,0,(i.clustering_factor) / (t.num_rows - t.blocks))) * 100 CLFPCT
,      i.partitioned "Partitioned"
FROM   dba_indexes i
,      dba_tables t
WHERE  i.table_name = t.table_name
AND    UPPER(i.table_name) = UPPER('&Table_name')
AND    i.table_owner = UPPER(NVL('&Owner',USER))
AND    t.owner = UPPER(NVL('&Owner',user))
/
