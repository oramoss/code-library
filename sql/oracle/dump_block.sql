ACCEPT segment_owner PROMPT 'Please enter Name of Segment Owner: '
ACCEPT segment_name PROMPT 'Please enter Name of Segment: '
select dt.tablespace_name
,      df.file_id
from   dba_segments ds
,      dba_data_files df
,      dba_tablespaces dt
where  df.tablespace_name = dt.tablespace_name
and    ds.tablespace_name = dt.tablespace_name
and    ds.owner = '&segment_owner'
and    ds.segment_name = '&segment_name'
/
alter system dump datafile 1 block min 1 block max 20;
alter system dump datafile 1 block 1417541;
