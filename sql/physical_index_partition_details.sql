REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    table_details.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows details from DBA_TABLES, DBA_INDEXES and DBA_IND_PARTITIONS
REM    for a given Owner/Table Name
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************
SELECT dip.index_name
,      dip.partition_name
,      dip.subpartition_count
,      dip.status
,      dip.tablespace_name
,      dip.compression
,      dip.blevel
,      dip.clustering_factor
,      (DECODE((t.num_rows - t.blocks),0,0,(ip.clustering_factor) / (t.num_rows - t.blocks))) * 100 clfpct
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
