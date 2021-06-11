REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    skd.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows details for subpartition keys for a given Owner/Table Name
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************
SELECT dpt.subpartitioning_type
,      dskc.object_type
,      dskc.column_name
,      dskc.column_position
FROM   dba_subpart_key_columns dskc
,      dba_part_tables dpt
WHERE  dskc.owner = UPPER(NVL('&&Owner',USER))
AND    UPPER(dskc.name) = UPPER('&&Table_name')
AND    dskc.owner = dpt.owner
AND    dskc.name = dpt.table_name
ORDER BY dskc.column_position
/
