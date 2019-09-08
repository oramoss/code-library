REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    physical_partition_details.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows details from DBA_TABLES, DBA_TAB_PARTITIONS and 
REM    DBA_TAB_SUBPARTITIONS for a given Owner/Table Name
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************
BREAK ON partition_name
REM Get Table details...
SELECT partition_name
,      subpartition_name
,      tablespace_name
,      compression
,      pct_free
,      pct_used
,      avg_space
FROM (
SELECT dtp.partition_name
,      dtp.subpartition_name
,      '' degree
,      dtp.tablespace_name
,      compression
,      dtp.pct_free
,      dtp.pct_used
,      0 partition_position
,      dtp.subpartition_position
,      dtp.avg_space
FROM   dba_tab_subpartitions dtp
WHERE  dtp.table_owner = UPPER(NVL('&&Owner',USER))
AND    UPPER(dtp.table_name) = UPPER('&&Table_name')
UNION ALL
SELECT dtp.partition_name
,      ''
,      ''
,      dtp.tablespace_name
,      compression
,      dtp.pct_free
,      dtp.pct_used
,      dtp.partition_position
,      0
,      dtp.avg_space
FROM   dba_tab_partitions dtp
WHERE  dtp.table_owner = UPPER(NVL('&&Owner',USER))
AND    UPPER(dtp.table_name) = UPPER('&&Table_name')
UNION ALL
SELECT ''
,      ''
,      ''
,      dtab.tablespace_name
,      compression
,      dtab.pct_free
,      dtab.pct_used
,      0
,      0
,      dtab.avg_space
FROM   dba_tables dtab
WHERE  dtab.owner = UPPER(NVL('&&Owner',USER))
AND    UPPER(dtab.table_name) = UPPER('&&Table_name')
)
ORDER BY partition_position,subpartition_position
/
