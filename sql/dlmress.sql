SET WRAP OFF
COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN resource_name HEADING "Resource|Name" FORMAT A30
COLUMN on_convert_q HEADING "On Convert|Queue" FORMAT 999
COLUMN on_grant_q HEADING "On Grant|Queue" FORMAT 999
COLUMN next_cvt_level HEADING "Next CVT|Level" FORMAT A9
COLUMN master_node HEADING "Master|Node" FORMAT 999
UNDEFINE resource_name
ACCEPT resource_name PROMPT 'Please enter Resource Name: '
SELECT inst_id
,      resource_name
,      on_convert_q
,      on_grant_q
,      next_cvt_level
,      master_node
FROM   gv$dlm_ress
WHERE  resource_name like '%&&resource_name%'
ORDER BY inst_id
/
