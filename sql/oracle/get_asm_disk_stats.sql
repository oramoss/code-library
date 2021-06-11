SET WRAP OFF
SET LINESIZE 155 
SET PAGESIZE 9999
COLUMN inst_id HEADING "Inst|ID" FORMAT 999
COLUMN name FORMAT a30 HEADING "Disk|Name"
COLUMN read_time FORMAT 999,999,990 HEADING "Read Time|seconds"
COLUMN write_time FORMAT 999,999,990 HEADING "Write Time|seconds"
COLUMN gb_read FORMAT 999,999,990 HEADING "GB|Read"
COLUMN gb_written FORMAT 999,999,990 HEADING "GB|Wrote"
COLUMN read_ms FORMAT 999,999.00 HEADING "Avg Read|Speed ms"
COLUMN reads FORMAT 999,999,990 HEADING "Reads"
COLUMN write_ms FORMAT 999.00 HEADING "Avg Write|Speed ms"
COLUMN writes FORMAT B999,999,990 HEADING "Writes"

SELECT inst_id
,      name
,      read_time
,      (bytes_read/1073741824) gb_read
,      (case when reads = 0 then null else read_time*1000/reads end) read_ms
,      reads
,      write_time
,      (bytes_written/1073741824) gb_written
,      (CASE WHEN writes = 0 then null else write_time*1000/writes end) write_ms
,      writes
FROM   gv$asm_disk_stat
order by inst_id
,        disk_number
/
