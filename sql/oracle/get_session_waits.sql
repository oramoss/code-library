column sid heading "SID" format 99999
column seq# heading "Seq" format 99
column event heading "Event" format a25
column p1text heading "Parameter 1" format 999999999999999
column p1 heading "P1|Val" format 999,999,999
column p2text heading "Parameter 2" format 999999999999999
column p2 heading "P2|Val" format 999,999,999
column p3text heading "Parameter 3" format 999999999999999
column p3 heading "P3|Val" format 999,999,999
column wait_time heading "Wait|Time" format 999999
REM column wait_count heading "Wait|Count" format 999999
column wait_class heading "Wait|Class" format a15
column file_name heading "Filename" format a45
set linesize 132
set wrap on
break on sid
ACCEPT sid PROMPT 'Please enter QCSID: '
WITH sids AS
(
select sid from v$px_session where qcsid=&sid
union all
select sid from v$session where sid=&sid
)
, ddf AS
(
select name file_name
,      file# file_id
,      'D' file_type
from   v$datafile
union all
select name
,      file#
,      'T'
from   v$tempfile
)
, ddf2 AS
(
select (select to_char(value) db_files from   v$parameter where  name = 'db_files') db_files
,      ddf.file_name
,      ddf.file_id
,      ddf.file_type
from   ddf
)
select swh.sid
,      swh.seq#
,      swh.event
,      swh.p1text
,      swh.p1
,      swh.p2text
,      swh.p2
,      swh.p3text
,      swh.p3
,      swh.wait_time
--,      swh.wait_count
,      en.wait_class
,      ddf2.file_name
from   sids
,      v$session_wait_history swh
,      v$event_name en
,      ddf2
where  swh.event# = en.event#
and    (case when ddf2.file_type(+) = 'T' 
             then (swh.p1 - ddf2.db_files(+))
             else swh.p1 
              end) = NVL(ddf2.file_id(+),-1)
and    sids.sid = swh.sid
order by swh.sid
,        swh.seq#
/

