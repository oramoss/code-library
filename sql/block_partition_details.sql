REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    block_partition_details.sql
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
SELECT partition_name
,      subpartition_name
,      num_rows
,      blocks
,      empty_blocks
,      chain_cnt
,      avg_row_len
,      space_mb
FROM (
SELECT p.partition_name
,      p.partition_position
,      s.subpartition_name
,      s.subpartition_position
,      s.num_rows
,      s.blocks
,      s.empty_blocks
,      s.chain_cnt
,      s.avg_row_len
,      s.blocks * ((SELECT DISTINCT t.block_size
                    FROM dba_tablespaces t
                    WHERE p.tablespace_name = t.tablespace_name
                   ) / (1024 * 1024)
                  ) space_mb
FROM   dba_tab_subpartitions s
,      dba_tab_partitions p
WHERE  s.table_owner = UPPER(NVL('&&Owner',USER))
AND    UPPER(s.table_name) = UPPER('&&Table_name')
AND    p.table_owner = UPPER(NVL('&&Owner',USER))
AND    UPPER(p.table_name) = UPPER('&&Table_name')
AND    p.partition_name = s.partition_name
UNION ALL
SELECT dtp.partition_name
,      dtp.partition_position
,      '' subpartition_name
,      0 subpartition_position
,      dtp.num_rows
,      dtp.blocks
,      dtp.empty_blocks
,      dtp.chain_cnt
,      dtp.avg_row_len
,      dtp.blocks * ((SELECT DISTINCT t.block_size
                    FROM dba_tablespaces t
                    WHERE dtp.tablespace_name = t.tablespace_name
                   ) / (1024 * 1024)
                  ) space_mb
FROM   dba_tab_partitions dtp
WHERE  dtp.table_owner = UPPER(NVL('&&Owner',USER))
AND    UPPER(dtp.table_name) = UPPER('&&Table_name')
UNION ALL
SELECT ''
,      0
,      ''
,      0
,      dtab.num_rows
,      dtab.blocks
,      dtab.empty_blocks
,      dtab.chain_cnt
,      dtab.avg_row_len
,      dtab.blocks * (
                    NVL((SELECT DISTINCT t.block_size
                    FROM dba_tablespaces t
                    ,    dba_tab_partitions dtp
                    WHERE dtp.tablespace_name = t.tablespace_name
                    AND   dtp.partition_position = 1
                    AND   dtp.table_name = dtab.table_name
                    AND   dtp.table_owner=dtab.owner
                   ),(SELECT DISTINCT t.block_size
                    FROM dba_tablespaces t
                    WHERE dtab.tablespace_name = t.tablespace_name
                   )
                   ) / (1024 * 1024)
                  ) space_mb
FROM   dba_tables dtab
WHERE  dtab.owner = UPPER(NVL('&&Owner',USER))
AND    UPPER(dtab.table_name) = UPPER('&&Table_name')
)
ORDER BY partition_position,subpartition_position
/
