COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN statistic HEADING "Statistic" FORMAT a30
COLUMN value HEADING "Bytes" FORMAT 999,999,999,999
SELECT inst_id
,      statistic
,      value
FROM   gv$pq_sysstat
ORDER BY inst_id
,        statistic
/
