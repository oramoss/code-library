REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    pid.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows details from DBA_INDEXES and DBA_TABLES for a given 
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
,      i.index_type
,      i.status
,      i.compression
,      i.tablespace_name
,      i.partitioned "Partitioned"
,      i.clustering_factor
,      (DECODE((t.num_rows - t.blocks),0,0,(i.clustering_factor) / (t.num_rows - t.blocks))) * 100 CLFPCT
,      DECODE(i.uniqueness,'UNIQUE','Yes','No') uniqueness
,      i.blevel blev
FROM   dba_indexes i
,      dba_tables t
WHERE  i.table_name = t.table_name
AND    UPPER(i.table_name) = UPPER('&Table_name')
AND    i.table_owner = UPPER(NVL('&Owner',USER))
AND    t.owner = UPPER(NVL('&Owner',user))
/
