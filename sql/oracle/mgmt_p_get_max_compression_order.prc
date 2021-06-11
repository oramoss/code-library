REM *************************************************************************************************
REM *
REM * File: mgmt_p_get_max_compression_order.prc
REM *
REM * Author: Jeff Moss
REM *
REM * Purpose: Provides facility to get the compressability of each column in a given table
REM *          Can be run at Table or Partition level and for a defined sample size.
REM *          Can specify string that must be the prefix order by columns - routine will work out
REM *          compressability of all the other columns individually with this prefix, e.g.
REM *           TABLE X(col1, col2, col3, col4, col5, col6)
REM *           specifying 'col3','col2','col5' as the prefix strings will make the routine work out compression
REM *           for col1 with order by col3,col2,col5,col1
REM *              ,col4 with order by col3,col2,col5,col4
REM *              and col6 with order by col3,col2,col5,col6
REM *            
REM * Execution: 
REM *   To just get the compressability of each individual column...
REM *     exec mgmt_p_get_max_compress_order(USER,'BIG_TABLE','PARTITION1',10000);
REM *   Then to get the compressability of the remaining columns when ordered by 
REM *     a commonly used access path:
REM *     exec mgmt_p_get_max_compress_order(USER,'BIG_TABLE','PARTITION1',10,'COL1','COL2','COL3');
REM *            
REM * History:
REM *
REM * Date         Author    Change
REM * 02-NOV-2005  Jeff Moss Initial version
REM * 26-NOV-2005  Jeff Moss Added facility to specify the prefix order by columns as suggested by
REM *                         David Aldridge.
REM * 25-JAN-2006  Jeff Moss Removed hard coded 32K block size dependency!
REM * 12-AUG-2007  Jeff Moss Removed hard coded schema name of AE_MGMT!
REM * 18-JUL-2012  Changed C_TABLES to look in USER schema for the TEMP_COL tables.
REM *************************************************************************************************
CREATE OR REPLACE
PROCEDURE mgmt_p_get_max_compress_order(p_table_owner IN VARCHAR2 DEFAULT USER
                                       ,p_table_name IN VARCHAR2
                                       ,p_partition_name IN VARCHAR2 DEFAULT NULL
                                       ,p_sample_size IN NUMBER DEFAULT 1000000
                                       ,p_prefix_column1 IN VARCHAR2 DEFAULT NULL
                                       ,p_prefix_column2 IN VARCHAR2 DEFAULT NULL
                                       ,p_prefix_column3 IN VARCHAR2 DEFAULT NULL
                                       ) IS
                                      

  CURSOR c_tab_columns(b_table_name VARCHAR2
                      ,b_table_owner VARCHAR2
                      ,b_prefix_column1 VARCHAR2
                      ,b_prefix_column2 VARCHAR2
                      ,b_prefix_column3 VARCHAR2) IS
    SELECT column_name
    ,      column_id
    FROM   dba_tab_columns
    WHERE  table_name = b_table_name
    AND    owner = b_table_owner
    AND    column_name != NVL(b_prefix_column1,'1234567890123456789012345678901')
    AND    column_name != NVL(b_prefix_column2,'1234567890123456789012345678901')
    AND    column_name != NVL(b_prefix_column3,'1234567890123456789012345678901')
    ORDER BY column_id;
  CURSOR c_tables(b_unique_id VARCHAR2,b_table_name VARCHAR2,b_table_owner VARCHAR2) IS
    SELECT dt.table_name
    ,      dt.blocks
    ,      dt.num_rows
    ,      dtc.column_name
    FROM   dba_tables dt
    ,      dba_tab_columns dtc
    WHERE  dt.table_name LIKE 'TEMP_COL%'||b_unique_id
    AND    dtc.table_name = b_table_name
    AND    dtc.owner = b_table_owner
    AND    dt.owner = USER --b_table_owner
    AND    TO_NUMBER(SUBSTR(dt.table_name,10,3)) = dtc.column_id
    ORDER BY dt.blocks,dt.num_rows;

  CURSOR c_get_block_size IS
    SELECT (value / 1024) block_size_k
    FROM   v$parameter 
    WHERE  name = 'db_block_size';

  l_block_size NUMBER;
  l_unique_id NUMBER;
  l_master_table VARCHAR2(30);
  l_sql VARCHAR2(32767);
  l_column_table VARCHAR2(30);
  l_order_by_prefix VARCHAR2(254);
  
  e_942 EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_942,-942);
  e_invalid_prefix_column EXCEPTION;

  FUNCTION mgmt_f_validate_prefix_column(p_table_owner IN VARCHAR2
                                        ,p_table_name IN VARCHAR2
                                        ,p_prefix_column IN VARCHAR2) RETURN BOOLEAN IS
    CURSOR c_column(b_table_owner VARCHAR2
                   ,b_table_name VARCHAR2
                   ,b_prefix_name VARCHAR2) IS
      SELECT 1
      FROM   dba_tab_columns
      WHERE  owner = b_table_owner
      AND    table_name = b_table_name
      AND    column_name = b_prefix_name;
  BEGIN
    FOR r_column IN c_column(p_table_owner
                            ,p_table_name
                            ,p_prefix_column) LOOP
      RETURN TRUE; -- we found a match
    END LOOP;
    RETURN FALSE; -- nothing found so no match
  END mgmt_f_validate_prefix_column;

BEGIN
  -- output paramters...
  dbms_output.put_line(LPAD('-',100,'-'));
  dbms_output.put_line('Running mgmt_p_get_max_compress_order...');
  dbms_output.put_line(LPAD('-',100,'-'));
  dbms_output.put_line('Table        : '||p_table_name);
  dbms_output.put_line('Sample Size  : '||TO_CHAR(p_sample_size));

  -- get a unique id to use for the working tables
  l_unique_id := TO_CHAR(SYSDATE,'DDMMYYYYHH24MISS');
  dbms_output.put_line('Unique Run ID: '||TO_CHAR(l_unique_id));

  -- now get block size from 
  OPEN c_get_block_size;
  FETCH c_get_block_size INTO l_block_size;
  IF c_get_block_size%NOTFOUND OR c_get_block_size%NOTFOUND IS NULL THEN
    CLOSE c_get_block_size;
    RAISE_APPLICATION_ERROR(-20001,'Cannot get block size!');
  ELSE
    CLOSE c_get_block_size;
  END IF;
  
  -- Now if we have any p_prefix_columns specified then we need to factor those in...
  -- Lets check the prefix_columns first to see if they are valid...
  IF p_prefix_column1 IS NOT NULL THEN
    IF NOT mgmt_f_validate_prefix_column(p_table_owner,p_table_name,p_prefix_column1) THEN
      RAISE e_invalid_prefix_column;
    END IF;
  END IF;

  IF p_prefix_column2 IS NOT NULL THEN
    IF NOT mgmt_f_validate_prefix_column(p_table_owner,p_table_name,p_prefix_column2) THEN
      RAISE e_invalid_prefix_column;
    END IF;
  END IF;

  IF p_prefix_column3 IS NOT NULL THEN
    IF NOT mgmt_f_validate_prefix_column(p_table_owner,p_table_name,p_prefix_column3) THEN
      RAISE e_invalid_prefix_column;
    END IF;
  END IF;

  -- Ok, we now have valid prefix columns...
  -- let's create the prefix string for the order by clause
  l_order_by_prefix := (CASE WHEN p_prefix_column1 IS NOT NULL THEN p_prefix_column1||',' END)||
                       (CASE WHEN p_prefix_column2 IS NOT NULL THEN p_prefix_column2||',' END)||
                       (CASE WHEN p_prefix_column3 IS NOT NULL THEN p_prefix_column3||',' END);
  
  dbms_output.put_line('ORDER BY Prefix: '||SUBSTR(l_order_by_prefix,1,LENGTH(l_order_by_prefix)-1));

  dbms_output.put_line(LPAD('-',100,'-'));

  l_master_table := 'TEMP_MASTER_'||TO_CHAR(l_unique_id);
  l_sql := 'CREATE TABLE '||l_master_table||
           ' NOLOGGING COMPRESS AS SELECT * FROM '||p_table_owner||'.'||p_table_name;

  IF p_partition_name IS NOT NULL THEN
    l_sql := l_sql||' PARTITION('||p_partition_name||')';
  END IF;

  l_sql := l_sql||' WHERE ROWNUM <= '||TO_CHAR(p_sample_size);

  dbms_output.put_line('Creating MASTER Table  : '||l_master_table);
  execute immediate(l_sql);

  FOR r_tab_columns IN c_tab_columns(p_table_name,p_table_owner,p_prefix_column1,p_prefix_column2,p_prefix_column3) LOOP
    dbms_output.put_line('Creating COLUMN Table '||TO_CHAR(r_tab_columns.column_id)||': '||r_tab_columns.column_name);
    l_column_table := 'TEMP_COL_'||LPAD(TO_CHAR(r_tab_columns.column_id),3,'0')||'_'||TO_CHAR(l_unique_id);
    l_sql := 'CREATE TABLE '||l_column_table||
             ' NOLOGGING COMPRESS AS SELECT * FROM '||l_master_table||
             ' ORDER BY '||l_order_by_prefix||r_tab_columns.column_name;
    execute immediate(l_sql);
    DBMS_STATS.GATHER_TABLE_STATS (ownname=>USER,tabname=>l_column_table,estimate_percent=>100);
  END LOOP;

  -- Now print out individual column compressions...
  dbms_output.put_line(LPAD('-',100,'-'));
  dbms_output.put_line('The output below lists each column in the table and the number of blocks/rows and space');
  dbms_output.put_line(' used when the table data is ordered by only that column, or in the case where a prefix');
  dbms_output.put_line(' has been specified, where the table data is ordered by the prefix and then that column.');
  dbms_output.put_line(' ');
  dbms_output.put_line('From this one can determine if there is a specific ORDER BY which can be applied to');
  dbms_output.put_line(' to the data in order to maximise compression within the table whilst, in the case of a');
  dbms_output.put_line(' a prefix being present, ordering data as efficiently as possible for the most common ');
  dbms_output.put_line(' access path(s).');
  dbms_output.put_line(LPAD('-',100,'-'));
  dbms_output.put_line('NAME                           COLUMN                         BLOCKS       ROWS         SPACE_GB');
  dbms_output.put_line('============================== ============================== ============ ============ ========');
  FOR r_tables IN c_tables(l_unique_id,p_table_name,p_table_owner) LOOP
    dbms_output.put_line(RPAD(r_tables.table_name,31)||
	                     RPAD(r_tables.column_name,30)||
	                     LPAD(TO_CHAR(r_tables.blocks),13)||
	                     LPAD(TO_CHAR(r_tables.num_rows),13)||
	                     LPAD(TO_CHAR(ROUND(r_tables.blocks * l_block_size / (1024*1024),4)),9)
                        );
  END LOOP;

  dbms_output.put_line(LPAD('-',100,'-'));

  -- First drop the Master table...
  l_sql := 'DROP TABLE '||l_master_table;
  BEGIN
    execute immediate(l_sql);
  EXCEPTION
    WHEN e_942 THEN NULL;
  END;   

  -- Next drop the Column tables...
  FOR r_tab_columns IN c_tab_columns(p_table_name,p_table_owner,p_prefix_column1,p_prefix_column2,p_prefix_column3) LOOP
    l_sql := 'DROP TABLE TEMP_COL_'||LPAD(TO_CHAR(r_tab_columns.column_id),3,'0')||'_'||TO_CHAR(l_unique_id);
    BEGIN
      execute immediate(l_sql);
    EXCEPTION
      WHEN e_942 THEN NULL;
    END;   
  END LOOP;
EXCEPTION
  WHEN e_invalid_prefix_column THEN
    RAISE_APPLICATION_ERROR(-20002,'mgmt_p_get_max_compress_order: Invalid prefix column specified.');
  WHEN OTHERS THEN
    -- Clear up the schema
    -- First drop the Master table...
    l_sql := 'DROP TABLE '||l_master_table;
    execute immediate(l_sql);

    -- Next drop the Column tables...
    FOR r_tab_columns IN c_tab_columns(p_table_name,p_table_owner,p_prefix_column1,p_prefix_column2,p_prefix_column3) LOOP
      l_sql := 'DROP TABLE TEMP_COL_'||LPAD(TO_CHAR(r_tab_columns.column_id),3,'0')||'_'||TO_CHAR(l_unique_id);
      execute immediate(l_sql);
    END LOOP;

  -- Now raise an application error...
  RAISE_APPLICATION_ERROR(-20001,'mgmt_p_get_max_compress_order encountered error: '||SQLERRM);
  
END mgmt_p_get_max_compress_order;
/
