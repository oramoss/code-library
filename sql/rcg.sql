SET LINESIZE 250
SET WRAP OFF
SET TRIMSPOOL OFF
COLUMN consumer_group_id HEADING "Consumer|Group ID" FORMAT 999999999
COLUMN consumer_group HEADING "Consumer Group" FORMAT a30
COLUMN cpu_method HEADING "CPU|Method" FORMAT A11
COLUMN mgmt_method HEADING "Mgmt|Method" FORMAT A11
COLUMN internal_use HEADING "Int|Use?" FORMAT A4
COLUMN category HEADING "Category" FORMAT A15
COLUMN status HEADING "Status" FORMAT A10
COLUMN mandatory HEADING "Mand?" FORMAT A5
SELECT consumer_group_id
,      consumer_group
,      cpu_method
,      mgmt_method
,      internal_use
,      category
,      status
,      mandatory
FROM   dba_rsrc_consumer_groups
ORDER BY consumer_group_id;
