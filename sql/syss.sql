COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN statistic# HEADING "Stat|#" FORMAT 999
COLUMN name HEADING "Parameter Name" FORMAT a64
COLUMN class HEADING "Class" FORMAT 999
COLUMN value HEADING "Value" FORMAT 999,999,999,999
COLUMN stat_id HEADING "Stat|ID" FORMAT 999999999999
SELECT statistic#
,      name
,      inst_id
,      class
,      value
,      stat_id
FROM   gv$sysstat
WHERE  UPPER(name) like UPPER('%&1%')
ORDER BY name
,        inst_id
/
