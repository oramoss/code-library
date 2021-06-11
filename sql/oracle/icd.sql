REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    icd.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows details of index columns for a given Owner/Table Name
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************
BREAK ON index_name
SELECT ic.index_name
,      ic.COLUMN_name
,      ic.COLUMN_POSITION
,      DECODE(tc.data_type
             ,'NUMBER',tc.data_type||'('||
                      decode(tc.data_precision
                            ,NULL,tc.data_length||')'
                            ,tc.data_precision||','||tc.data_scale||')')
                            ,'DATE',tc.data_type
                            ,'LONG',tc.data_type
                            ,'LONG RAW',tc.data_type
                            ,'ROWID',tc.data_type
                            ,'MLSLABEL',tc.data_type
                            ,tc.data_type||'('||tc.data_length||')') ||' '||
       DECODE(UPPER(tc.nullable),
              'N','NOT NULL'
              ,NULL) col
,      DECODE(i.distinct_keys,0,-1,ROUND((t.num_rows/i.distinct_keys))) selectivity
,      DECODE(NVL(t.num_rows,0),0,0,ROUND(ROUND((i.distinct_keys/t.num_rows),2)* 100)) cardinality
FROM   dba_ind_COLUMNs ic
,      dba_indexes i
,      dba_tab_COLs tc
,      dba_tables t
WHERE  UPPER(ic.table_name) = UPPER('&Table_name')
AND    tc.owner = UPPER(NVL('&Owner',user))
AND    t.owner = UPPER(NVL('&Owner',user))
AND    ic.table_owner = UPPER(NVL('&Owner',USER))
AND    ic.index_owner = UPPER(NVL('&Owner',USER))
AND    i.owner = UPPER(NVL('&Owner',user))
AND    ic.index_name = i.index_name
AND    i.table_name = t.table_name
AND    ic.table_name = t.table_name
AND    tc.COLUMN_name = ic.COLUMN_name
AND    tc.table_name = t.table_name
ORDER BY index_name
,        COLUMN_position
/
