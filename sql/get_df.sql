REM **********************************************************************************
REM
REM File:    get_ae_sql_response_time_histogram.sql
REM Purpose: Gets a count of SQL executions by elapsed time buckets (histogram)
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM              Jeff Moss          Initial Version
REM
REM **********************************************************************************
COLUMN PDB_ID FORMAT 999
COLUMN PDB_NAME FORMAT A8
COLUMN FILE_ID FORMAT 9999
COLUMN TABLESPACE_NAME FORMAT A30
COLUMN FILE_NAME FORMAT A60

SELECT p.PDB_ID, p.PDB_NAME, d.FILE_ID, d.TABLESPACE_NAME, d.FILE_NAME
  FROM DBA_PDBS p, CDB_DATA_FILES d
  WHERE p.PDB_ID = d.CON_ID
  ORDER BY p.PDB_ID;
