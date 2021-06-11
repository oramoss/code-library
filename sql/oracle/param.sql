SET LINESIZE 250
SET WRAP ON
SET LONG 40000
SET PAGESIZE 1000
COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN ksppinm HEADING "Parameter" FORMAT A40
COLUMN ksppdesc HEADING "Description" FORMAT A80
COLUMN ksppstvl HEADING "Value" FORMAT A30

UNDEFINE param
ACCEPT param PROMPT 'Please enter parameter to search for : '

SELECT a.inst_id
,      a.ksppinm
,      a.ksppdesc
,      b.ksppstvl
FROM   sys.x$ksppi a
,      sys.x$ksppsv b
WHERE  a.indx = b.indx
AND    UPPER(ksppinm) LIKE UPPER('%&param%')
ORDER BY 2;
