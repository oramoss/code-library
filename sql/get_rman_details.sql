select status,to_char(start_time,'dd-mon-yyyy hh24:mi:ss') start_time,to_char(end_time,'dd-mon-yyyy hh24:mi:ss') end_time
,input_bytes_per_sec_display,output_bytes_per_sec_display,time_taken_display
from v$rman_backup_job_details where input_type not in('ARCHIVELOG','CONTROLFILE')
order by to_date(start_time,'dd-mon-yyyy hh24:mi:ss') desc
/
