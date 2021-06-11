SET WRAP OFF
SET LINES 155 PAGES 9999
PROMPT ASM Disks In Use
PROMPT ================
COLUMN inst_id HEADING "Inst|ID" FORMAT 999
COLUMN group_number FORMAT 999 HEADING "Grp|#"
COLUMN disk_number FORMAT 999 HEADING "Dsk|#"
COLUMN header_status FORMAT a9 HEADING "Header|Status"
COLUMN mode_status FORMAT a8 HEADING "Mode|Status"
COLUMN state FORMAT a8 HEADING "State"
COLUMN create_date FORMAT a10 HEADING "Create|Date"
COLUMN redundancy FORMAT a10 HEADING "Redundancy"
COLUMN failgroup FORMAT a10 HEADING "Failure|Group"
COLUMN path FORMAT a30 HEADING "Path"
COLUMN total_gb FORMAT 999,999 HEADING "Total|GB"
COLUMN free_gb FORMAT 999,999 HEADING "Free|GB"
COLUMN name FORMAT a30 HEADING "Disk|Name"

SELECT inst_id
,      path
,      group_number
,      disk_number
,      header_status
,      mode_status
,      state
,      create_date
,      redundancy
,      (total_mb/1024) total_gb
,      (free_mb/1024) free_gb
,      name
,      failgroup
FROM   gv$asm_disk_stat
ORDER BY group_number
,        disk_number
/
