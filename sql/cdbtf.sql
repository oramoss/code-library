REM **********************************************************************************
REM
REM File:    cdbtf.sql
REM Purpose: Gets the Temp file details for a Container database.
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM              Jeff Moss          Initial Version
REM
REM **********************************************************************************
COLUMN CON_ID FORMAT 999
COLUMN FILE_ID FORMAT 9999
COLUMN TABLESPACE_NAME FORMAT A30
COLUMN FILE_NAME FORMAT A60

SELECT CON_ID, FILE_ID, TABLESPACE_NAME, FILE_NAME
  FROM CDB_TEMP_FILES
  ORDER BY CON_ID;