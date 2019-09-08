COLUMN sid heading "SID" format 99999
COLUMN seq# heading "Seq" format 99
COLUMN event heading "Event" format a25
COLUMN p1text heading "Parameter 1" format 999999999999999
COLUMN p1 heading "P1|Val" format 999,999,999
COLUMN p2text heading "Parameter 2" format 999999999999999
COLUMN p2 heading "P2|Val" format 999,999,999
COLUMN p3text heading "Parameter 3" format 999999999999999
COLUMN p3 heading "P3|Val" format 999,999,999
COLUMN wait_time heading "Wait|Time" format 999999
COLUMN wait_class heading "Wait|Class" format a15
COLUMN file_name heading "Filename" format a45
SET LINESIZE 132
SET WRAP ON
BREAK ON sid
ACCEPT inst_id PROMPT 'Please enter Instance ID: '
ACCEPT sid PROMPT 'Please enter SID: '
WITH sids AS
(
SELECT sid 
FROM   gv$px_session 
WHERE  inst_id = &inst_id
AND    qcsid=&sid
UNION ALL
SELECT sid 
FROM   gv$session 
WHERE  inst_id = &inst_id
AND    sid=&sid
)
, ddf AS
(
SELECT name file_name
,      file# file_id
,      'D' file_type
FROM   gv$datafile
WHERE  inst_id = &inst_id
UNION ALL
SELECT name
,      file#
,      'T'
FROM   gv$tempfile
WHERE  inst_id = &inst_id
)
, ddf2 AS
(
SELECT (SELECT TO_CHAR(value) db_files 
        FROM   gv$parameter 
		WHERE  name = 'db_files' 
		AND    inst_id = &inst_id) db_files
,      ddf.file_name
,      ddf.file_id
,      ddf.file_type
FROM   ddf
)
SELECT swh.sid
,      swh.seq#
,      swh.event
,      swh.p1text
,      swh.p1
,      swh.p2text
,      swh.p2
,      swh.p3text
,      swh.p3
,      swh.wait_time
,      en.wait_class
,      ddf2.file_name
FROM   sids
,      gv$session_wait_history swh
,      gv$event_name en
,      ddf2
WHERE  swh.event# = en.event#
AND    (CASE WHEN ddf2.file_type(+) = 'T' 
             THEN (swh.p1 - ddf2.db_files(+))
             ELSE swh.p1 
              END) = NVL(ddf2.file_id(+),-1)
AND    sids.sid = swh.sid
AND    swh.inst_id = &inst_id
AND    en.inst_id = &inst_id
ORDER BY swh.sid
,        swh.seq#
/

