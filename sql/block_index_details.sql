REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    block_index_details.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows details from DBA_TABLES and DBA_INDEXES for a given 
REM   Owner/Table Name
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************
SELECT i.index_name
,      i.leaf_blocks
,      i.distinct_keys
,      DECODE(t.num_rows,0,-1,(i.distinct_keys / t.num_rows) * 100) cardinality
,      i.avg_leaf_blocks_per_key
,      i.avg_data_blocks_per_key
FROM   dba_indexes i
,      dba_tables t
WHERE  i.table_name = t.table_name
AND    UPPER(i.table_name) = UPPER('&Table_name')
AND    i.table_owner = UPPER(NVL('&Owner',USER))
AND    t.owner = UPPER(NVL('&Owner',user))
/
