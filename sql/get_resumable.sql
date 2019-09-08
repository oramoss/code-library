SELECT user_id
,      session_id
,      coord_session_id qcsid
,      status
,      start_time
,      suspend_time
,      resume_time
,      error_number
,      error_msg
FROM   dba_resumable
ORDER BY coord_session_id
,        session_id
/
