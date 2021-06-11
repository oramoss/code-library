UNDEFINE sql_id
ACCEPT sql_id PROMPT 'Please enter SQL_ID: '

REM PGA Memory Profile of a given SQL_ID over the last 24 hours...
SELECT ash.instance_number
,      TO_CHAR(ash.sample_time,'dd-mon-yyyy hh24:mi:ss') sample_time
,      ROUND(SUM(ash.pga_allocated/ (1024*1024*1024)),2) mem_gb_time
FROM   sys.wrh$_active_session_history ash
WHERE  TRUNC(ash.sample_time) > (SYSDATE - 1)
AND    ash.sql_id='&sql_id'
GROUP BY ash.instance_number
,        ash.sample_time
ORDER BY 2
/
