REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    cd.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows details from DBA_TAB_COLS and DBA_TAB_COL_STATISTICS
REM   for a given Owner/Table Name
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 25-NOV-2011  Jeff Moss          Initial Version
REM
REM *************************************************************************
SELECT t.COLUMN_name
,      DECODE(t.data_type
             ,'NUMBER',t.data_type||'('||
                       DECODE(t.data_precision
                             ,NULL,t.data_length||')'
                             ,t.data_precision||','||t.data_scale||')')
             ,'DATE',t.data_type
             ,'LONG',t.data_type
             ,'LONG RAW',t.data_type
             ,'ROWID',t.data_type
             ,'MLSLABEL',t.data_type
             ,t.data_type||'('||t.data_length||')') ||' '||
                           DECODE(UPPER(t.nullable)
                                 ,'N','NOT NULL'
                                 ,NULL) col
,      t.num_distinct
,      t.num_nulls
,      tcs.histogram
,      t.density
,      DECODE(t.low_value,NULL,'N/A'
                       ,DECODE(t.data_type
                              ,'DATE'
                              ,LPAD(TO_CHAR(TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),8,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                            ,SUBSTR(rawtohex(t.low_value),8,1))) +
                                            TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),7,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                            ,SUBSTR(rawtohex(t.low_value),7,1))) * 16),2,'0')||'-'||
                               LPAD(TO_CHAR(TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),6,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                            ,SUBSTR(rawtohex(t.low_value),6,1))) +
                                            TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),5,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                            ,SUBSTR(rawtohex(t.low_value),5,1))) * 16),2,'0')||'-'||
                               LPAD(TO_CHAR((TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),2,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.low_value),2,1))) +
                                             TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),1,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.low_value),1,1))) * 16) - 100),2,'0')||
                               LPAD(TO_CHAR((TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),4,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.low_value),4,1))) +
                                             TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),3,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.low_value),3,1))) * 16) - 100),2,'0')||' '||
                               LPAD(TO_CHAR((TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),10,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.low_value),10,1))) +
                                             TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),9,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.low_value),9,1))) * 16) - 1),2,'0')||':'||
                               LPAD(TO_CHAR((TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),12,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.low_value),12,1))) +
                                             TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),11,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.low_value),11,1))) * 16) - 1),2,'0')||':'||
                               LPAD(TO_CHAR((TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),14,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.low_value),14,1))) +
                                             TO_NUMBER(DECODE(SUBSTR(rawtohex(t.low_value),13,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.low_value),13,1))) * 16) - 1),2,'0')
             ,'NUMBER'
             ,DECODE(SIGN(NVL(LENGTH(rawtohex(t.low_value)),0) - 3),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),4,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.low_value),4,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),3,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.low_value),3,1))) * 16) - 1)
                         ),2,'0'))||
              DECODE(SIGN(NVL(LENGTH(rawtohex(t.low_value)),0) - 5),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),6,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.low_value),6,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),5,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.low_value),5,1))) * 16) - 1)
                         ),2,'0'))||
              DECODE(SIGN(NVL(LENGTH(rawtohex(t.low_value)),0) - 7),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),8,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.low_value),8,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),7,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.low_value),7,1))) * 16) - 1)
                         ),2,'0'))||
              DECODE(SIGN(NVL(LENGTH(rawtohex(t.low_value)),0) - 9),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),10,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.low_value),10,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),9,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.low_value),9,1))) * 16) - 1)
                         ),2,'0'))||
              DECODE(SIGN(NVL(LENGTH(rawtohex(t.low_value)),0) - 11),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),12,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.low_value),12,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),11,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.low_value),11,1))) * 16) - 1)
                         ),2,'0'))||
              DECODE(SIGN(NVL(LENGTH(rawtohex(t.low_value)),0) - 13),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),14,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.low_value),14,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),13,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.low_value),13,1))) * 16) - 1)
                         ),2,'0'))||
              DECODE(SIGN(NVL(LENGTH(rawtohex(t.low_value)),0) - 15),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),16,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.low_value),16,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.low_value),15,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.low_value),15,1))) * 16) - 1)
                         ),2,'0'))
             ,'N/A'
            )) low_value
,      DECODE(t.high_value,NULL,'N/A'
                       ,DECODE(t.data_type
                              ,'DATE'
                              ,LPAD(TO_CHAR(TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),8,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                            ,SUBSTR(rawtohex(t.high_value),8,1))) +
                                            TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),7,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                            ,SUBSTR(rawtohex(t.high_value),7,1))) * 16),2,'0')||'-'||
                               LPAD(TO_CHAR(TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),6,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                            ,SUBSTR(rawtohex(t.high_value),6,1))) +
                                            TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),5,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                            ,SUBSTR(rawtohex(t.high_value),5,1))) * 16),2,'0')||'-'||
                               LPAD(TO_CHAR((TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),2,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.high_value),2,1))) +
                                             TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),1,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.high_value),1,1))) * 16) - 100),2,'0')||
                               LPAD(TO_CHAR((TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),4,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.high_value),4,1))) +
                                             TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),3,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.high_value),3,1))) * 16) - 100),2,'0')||' '||
                               LPAD(TO_CHAR((TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),10,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.high_value),10,1))) +
                                             TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),9,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.high_value),9,1))) * 16) - 1),2,'0')||':'||
                               LPAD(TO_CHAR((TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),12,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.high_value),12,1))) +
                                             TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),11,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.high_value),11,1))) * 16) - 1),2,'0')||':'||
                               LPAD(TO_CHAR((TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),14,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.high_value),14,1))) +
                                             TO_NUMBER(DECODE(SUBSTR(rawtohex(t.high_value),13,1),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                             ,SUBSTR(rawtohex(t.high_value),13,1))) * 16) - 1),2,'0')
             ,'NUMBER'
             ,DECODE(SIGN(NVL(LENGTH(rawtohex(t.high_value)),0) - 3),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),4,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.high_value),4,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),3,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.high_value),3,1))) * 16) - 1)
                         ),2,'0'))||
              DECODE(SIGN(NVL(LENGTH(rawtohex(t.high_value)),0) - 5),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),6,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.high_value),6,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),5,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.high_value),5,1))) * 16) - 1)
                         ),2,'0'))||
              DECODE(SIGN(NVL(LENGTH(rawtohex(t.high_value)),0) - 7),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),8,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.high_value),8,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),7,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.high_value),7,1))) * 16) - 1)
                         ),2,'0'))||
              DECODE(SIGN(NVL(LENGTH(rawtohex(t.high_value)),0) - 9),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),10,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.high_value),10,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),9,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.high_value),9,1))) * 16) - 1)
                         ),2,'0'))||
              DECODE(SIGN(NVL(LENGTH(rawtohex(t.high_value)),0) - 11),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),12,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.high_value),12,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),11,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.high_value),11,1))) * 16) - 1)
                         ),2,'0'))||
              DECODE(SIGN(NVL(LENGTH(rawtohex(t.high_value)),0) - 13),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),14,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.high_value),14,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),13,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.high_value),13,1))) * 16) - 1)
                         ),2,'0'))||
              DECODE(SIGN(NVL(LENGTH(rawtohex(t.high_value)),0) - 15),-1,''
                    ,LPAD(TO_CHAR(((TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),16,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                               ,SUBSTR(rawtohex(t.high_value),16,1))) +
                                    TO_NUMBER(DECODE(NVL(SUBSTR(rawtohex(t.high_value),15,1),'0'),'A','10','B','11','C','12','D','13','E','14','F','15'
                                                                                              ,SUBSTR(rawtohex(t.high_value),15,1))) * 16) - 1)
                         ),2,'0'))
             ,'N/A'
            )) high_value
,     t.data_default
FROM  dba_tab_cols t
,     dba_tab_col_statistics tcs
WHERE UPPER(t.table_name) = UPPER('&Table_name')
AND   t.owner = UPPER(NVL('&Owner',USER))
AND   t.table_name = tcs.table_name(+)
AND   t.column_name = tcs.column_name(+)
AND   t.owner = tcs.owner(+)
/
