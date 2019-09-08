SET LINESIZE 200
SET WRAP OFF
SET TRIMSPOOL OFF
COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN name HEADING "Parameter Name" FORMAT a35
COLUMN value HEADING "Parameter Value" FORMAT a30
COLUMN display_value HEADING "Display Value" FORMAT a30
COLUMN isdefault HEADING "Dflt" FORMAT a5
COLUMN isses_modifiable HEADING "Sess|Mod" FORMAT a5
COLUMN issys_modifiable HEADING "Sys|Mod" FORMAT a5
COLUMN ismodified HEADING "Is|Mod?" FORMAT a5
COLUMN isadjusted HEADING "Is|Adj?" FORMAT a5
COLUMN isdeprecated HEADING "Is|Dep?" FORMAT a5
COLUMN isbasic HEADING "Is|Basc?" FORMAT a5
SELECT name
,      inst_id
,      value
,      isdefault
,      isses_modifiable
,      issys_modifiable
,      ismodified
,      isadjusted
,      isdeprecated
,      isbasic
,      display_value
FROM   gv$parameter
WHERE  UPPER(name) LIKE UPPER('%&1%')
ORDER BY 1,2
/
