REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    pkd.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows details for partition keys on partitions for a 
REM   given Owner/Table Name
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************
SELECT dpt.partitioning_type
,      dpt.subpartitioning_type
,      dpt.partition_count
,      dpt.status
,      dpt.interval
,      dpkc.object_type
,      dpkc.column_name
,      dpkc.column_position
FROM   dba_part_key_columns dpkc
,      dba_part_tables dpt
WHERE  dpkc.owner = UPPER(NVL('&&Owner',USER))
AND    UPPER(dpkc.name) = UPPER('&&Table_name')
AND    dpkc.owner = dpt.owner
AND    dpkc.name = dpt.table_name
ORDER BY dpkc.column_position
/
