COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN pool HEADING "Buffer Pool" FORMAT a12
COLUMN name HEADING "Statistic" FORMAT a26
COLUMN bytes HEADING "Bytes" FORMAT 999,999,999,999
SELECT inst_id
,      pool
,      name
,      SUM(bytes) bytes
FROM   gv$sgastat
WHERE pool='large pool'
GROUP BY ROLLUP(inst_id,pool,name)
ORDER BY inst_id
,        pool
,        name
/
