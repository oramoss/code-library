UNDEFINE owner
UNDEFINE segment_name

PROMPT

ACCEPT owner PROMPT 'Please enter Name of Table Owner: '
ACCEPT segment_name PROMPT 'Please enter Segment Name to show size for: '
select sum(bytes)/(1024*1024) MB
from dba_segments
where owner='&owner'
and segment_name = '&segment_name'
/
