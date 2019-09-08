COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN statistic HEADING "Statistic" FORMAT a30
COLUMN value HEADING "Bytes" FORMAT 999,999,999,999
SELECT statistic
,      inst_id
,      value
FROM   gv$px_process_sysstat
ORDER BY statistic
,        inst_id
/
