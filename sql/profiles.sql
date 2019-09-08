SET LINESIZE 250
SET WRAP OFF
SET TRIMSPOOL OFF
COLUMN profile HEADING "Profile" FORMAT A30
COLUMN resource_type HEADING "Resource|Type" FORMAT a10
COLUMN resource_name HEADING "Resource|Name" FORMAT A30
COLUMN limit HEADING "Limit" FORMAT A30
SELECT profile
,      resource_type
,      resource_name
,      limit
FROM   dba_profiles
ORDER BY profile
,        resource_type
,        resource_name;
