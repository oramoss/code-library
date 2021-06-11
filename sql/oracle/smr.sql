SET TIMING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET LONG 100000
SET PAGESIZE 50000

UNDEFINE sql_id

ACCEPT sql_id PROMPT 'Please enter SQL_ID: '

SET WRAP ON
SET LINESIZE 250
COLUMN my_rept FORMAT A250

VARIABLE my_rept CLOB;
BEGIN
  :my_rept :=DBMS_SQLTUNE.REPORT_SQL_MONITOR(sql_id=>'&&sql_id');
END;
/
PRINT :my_rept