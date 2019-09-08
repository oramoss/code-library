SET LINESIZE 250
SET WRAP ON
SET LONG 40000
COLUMN command_type HEADING "Cmd|Type" FORMAT 999
COLUMN sql_text HEADING "SQL Text" FORMAT a150

UNDEFINE sql_id
ACCEPT sql_id PROMPT 'Please enter SQL_ID: '

SELECT command_type
,      sql_text
FROM   dba_hist_sqltext
WHERE  sql_id = '&sql_id'
/
