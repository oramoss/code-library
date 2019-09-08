REM **********************************************************************************
REM
REM File:    get_partitions.sql
REM Purpose: Gets the partitions, boundaries and number of rows for a given table
REM
REM **********************************************************************************
ACCEPT own CHAR FORMAT 'A40' PROMPT 'Enter Owner:  '
ACCEPT tab CHAR FORMAT 'A40' PROMPT 'Enter Table Name:  '
set long 20
select partition_position
,      partition_name "Partition Name"
,      high_value "High Value"
,      num_rows "Number Of Rows"
,      tablespace_name "Tablespace"
from   dba_tab_partitions
where  table_name='&tab'
and    table_owner='&own'
order by partition_position asc
/
