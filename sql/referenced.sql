UNDEFINE owner
UNDEFINE name
ACCEPT owner PROMPT 'Please enter Name of Table Referenced Owner: '
ACCEPT name PROMPT 'Please enter Name of Table Referenced Name: '
SELECT owner
,      name
,      type
,      dependency_type
FROM   dba_dependencies
WHERE  referenced_owner = '&owner'
AND    referenced_name = '&name'
/
