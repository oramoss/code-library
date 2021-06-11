column query heading "Query" format a80 wrap
set long 40000
set linesize 132
SELECT query
,      owner
FROM   dba_snapshots
WHERE  name LIKE '%&snapshot%'
/
