REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    ctc.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script compares table columns for differences.
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 04-AUG-2014  Jeff Moss          Initial Version
REM *************************************************************************
UNDEFINE srcowner
UNDEFINE srctabname
UNDEFINE tgtowner
UNDEFINE tgttabname

ACCEPT srcowner PROMPT 'Please enter Name of Source Owner: '
ACCEPT srctabname PROMPT 'Please enter Name of Source Table: '
ACCEPT tgtowner PROMPT 'Please enter Name of Target Owner: '
ACCEPT tgttabname PROMPT 'Please enter Name of Target Table: '

SET WRAP OFF
WITH stg AS
(
SELECT table_name
,      column_name
,      column_id 
FROM   dba_tab_columns
WHERE  owner = '&&srcowner' 
AND    table_name = '&&srctabname'
)
, tgt AS
(
SELECT table_name
,      column_name
,      column_id 
FROM   dba_tab_columns
WHERE  owner = '&&tgtowner' 
AND    table_name = '&&tgttabname'
)
SELECT COALESCE(stg.column_id,tgt.column_id) column_id
,      stg.column_name
,      tgt.column_name
,      (CASE WHEN stg.column_name = tgt.column_name THEN 'MATCH' ELSE 'PROBLEM' END) indicator
FROM   stg
FULL OUTER JOIN tgt
ON  stg.column_id = tgt.column_id
ORDER BY 1
/
