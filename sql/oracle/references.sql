UNDEFINE owner
UNDEFINE name
ACCEPT owner PROMPT 'Please enter Name of Table Owner: '
ACCEPT name PROMPT 'Please enter Name of Table Name: '
SELECT referenced_owner
,      referenced_name
,      referenced_type
,      dependency_type
FROM   dba_dependencies
WHERE  (owner = '&owner' OR owner = 'PUBLIC')
AND    name = '&name'
ORDER BY referenced_owner
,        referenced_name
/
