# sql
A bunch of SQL scripts.

## ASM
- [ASM Disk Stats](./asmds.sql)
- [ASM Disk Status](./asmdsu.sql)
- [Get ASM Disk Group Usage](./get_asm_disk_group_usage.sql)
- [Get ASM Disk Stats](./get_asm_disk_stats.sql)
- [Get ASM Disk Status](./get_asm_disk_status.sql)
- [Mother Of All ASM Scripts](./moaasm.sql)

## RAC
- [RAC Buffer Cache Stats](./rac_bufcache.sql)
- [RAC Explain Plan](./RAC_Xplan.sql)

## AWR
- [AWR Load Profile](./awr_load_profile.sql)
- [Get AWR IO Stats](./get_awr_io_stats.sql)

## ASH
- [Execution Analysis From ASH](./xplan_ash.sql)
- [ASH Details for SQL ID](./smp.sql)

## Plans
- [Get Plan](./plan.sql)
- [Profiles](./profiles.sql)
- [SQL History Search By Text](./sqltxt.sql)
- [gt_plan4](./gt_plan4.sql)
- [Query Plan With Work Areas](./qp.sql)
- [Query Plan With Work Areas Materialised View](./qpmv.sql)
- [SQL Monitor Executing Queries](./sme.sql)
- [SQL Monitor Report](./smr.sql)
- [SQL Profile Hints](./sql_profile_hints.sql)
- [SQL Profiles](./sql_profiles.sql)
- [1 Hint SQL Profile](./create_1_hint_sql_profile.sql)
- [Actual Plan](./ap.sql)
- [Baseslines Off](./baselines_off.sql)
- [Baselines On](./baselines_on.sql)
- [Display Execution Plan with All Stats](./dplan_allstats.sql)
- [Drop SQL Profile](./drop_sql_profile.sql)
- [Explain Plan](./explain.sql)

## Dictionary
- [Index Column Details](./icd.sql)
- [Index Details](./index_details.sql)
- [Index Partition Details](./index_partition_details.sql)
- [Get Partition Key Details](./partition_key_details.sql)
- [Get Partitioning For Table](./partitioning.sql)
- [Physical Index Details](./physical_index_details.sql)
- [Physical Index Partition Details](./physical_index_partition_details.sql)
- [Physical Partition Details](./physical_partition_details.sql)
- [Table Details](./pid.sql)
- [Partitioned index Details](./pipd.sql)
- [Partition Key Details](./pkd.sql)
- [Get Subpartition Key Details](./subpartition_key_details.sql)
- [Subpartition Keys](./skd.sql)
- [Table Grants](./tabgrants.sql)
- [Table Details](./table_details.sql)
- [Table Details](./td.sql)
- [Triggers](./trgd.sql)
- [Trigger Details](./trigger_details.sql)
- [Table & Index Details](./bid.sql)
- [Table, Index and Index Partition Details](./bipd.sql)
- [Block Index Details](./block_index_details.sql)
- [Get Table Grants](./get_tab_grants.sql)
- [Get Materialised View](./get_mv.sql)
- [Get Partitions](./get_partitions.sql)
- [Block Index Partition Details](./block_index_partition_details.sql)
- [Block Partition Details](./block_partition_details.sql)
- [Materialied View](./mv.sql)
- [Table Partition and Subpartition Details](./bpd.sql)
- [Cost Based Optimiser - master script which given owner/table comes back with lots of useful info](./cbo.sql)
- [Table and Column Statistics](./cd.sql)
- [Column Details](./column_details.sql)
- [Constraints for a table](./cond.sql)
- [Constraint Details](./constraint_details.sql)
- [Compare Table Columns](./ctc.sql)
- [Get View](./v.sql)

## Files
- [Container Database Data File Details](./cdbdf.sql)
- [Container Database Temp File Details](./cdbtf.sql)

## Tablespaces
- [Tablespace Usage By Session](./tus.sql)
- [Tablespace Usage By Tablespace](./tut.sql)

## Dynamic Performance
- [Average Active Sessions](./aas.sql)
- [SGA Stats](./sgas.sql)
- [Session Waits](./sw.sql)
- [System Stats](./syss.sql)
- [Snapper (Tanel Poder)](./snapper.sql)
- [Snapper Example Calls](./snapper_calls.txt)
- [Buffer Cache Objects](./bco.sql)
- [Distributed Lock Manager Resources](./dlmress.sql)
- [Get Process](./get_process.sql)
- [Get Query Progress](./get_query_progress.sql)
- [Get Query Progress Materialised View](./get_query_progress_mv.sql)
- [Wait Chains](./wcb.sql)
- [Work Areas](./wa.sql)
- [Work Areas Active](./waa.sql)
- [Dump Block](./dump_block.sql)
- [Event Waiters](./evwtrs.sql)
- [Oracle utllockt Script](./utllockt.sql)

## RMAN
- [Get RMAN Details](./get_rman_details.sql)

## Parallel
- [Get Parallel Parameters](./get_parallel_parameters.sql)
- [Get Parallel Session Details](./get_parallel_session_details.sql)
- [Get Parallel Stats](./get_parallel_stats.sql)
- [Get Parallel Query Session Stats](./get_pq_sess_stats.sql)
- [Get Parallel Query System Stats](./get_pq_sys_stats.sql)
- [Get Parallel Process Stats](./get_px_process_stats.sql)
- [GPS Parallel Query Long Ops](./gps_px_longops.sql)
- [Parallel Query Sessions](./pqses.sql)
- [Parallel Query System Stats](./pqss.sql)
- [Parallel Query Thread Queues](./pqtq.sql)
- [Parallel Query Stats](./ps.sql)
- [Parallel Query Session Details](./psd.sql)
- [Parallel Query Process Stats](./pxps.sql)

## Miscellaneous

- [Connect](./conn.sql)
- [Set Date Format](./date.sql)
- [Search SQL With Stats](./fs.sql)
- [Global Blocked Locks](./gbl.sql)
- [Global Blocked Enqueues](./gesbe.sql)
- [Get Active Workareas](./get_active_workarea.sql)
- [Get Actual Plans](./get_actual_plan.sql)
- [Get Response Time Histogram](./get_sql_response_time_histogram.sql)
- [Get Block Waits](./get_block_waits.sql)
- [Get Lock Object](./get_lock_object.sql)
- [Get Locks](./get_locks.sql)
- [Get Memory Areas](./get_memory_areas.sql)
- [Get Memory Areas Materialised View](./get_memory_areas_mv.sql)
- [Get My Parallel Queries](./get_my_parallel.sql)
- [Get My Sessions](./get_my_sessions.sql)
- [Get Parameters](./get_parameter.sql)
- [Get Resumable Transactions](./get_resumable.sql)
- [Get Row Cache Lockers](./get_row_cache_lockers.sql)
- [Get Segment Size](./get_seg_size.sql)
- [Get Session Waits](./get_session_waits.sql)
- [Get Sessions](./get_sessions.sql)
- [Get SGA Stats](./get_sga_stats.sql)
- [Get Temp Usage By Session](./get_temp_usage_by_session.sql)
- [Get Temp Usage By Tablespace](./get_temp_usage_by_tablespace.sql)
- [Get Unusable Indexes](./get_unusable.sql)
- [Get View](./get_view.sql)
- [GPS Dequeue Events](./gps_deq_events.sql)
- [GPS Overview](./gps_overview.sql)
- [Log](./log.sql)
- [Log File](./logfile.sql)
- [Procedure MGMT_P_GET_MAX_COMPRESSION_ORDER](./mgmt_p_get_max_compression_order.prc)
- [Maximum PGA Memory Used](./mmp.sql)
- [Get Process Details](./p.sql)
- [Get Parameters](./par.sql)
- [Get Parameters (ALL)](./param.sql)
- [Resource Consumer Groups](./rcg.sql)
- [Referenced Dependencies](./referenced.sql)
- [Referencing Dependencies](./references.sql)
- [Resumable Transactions](./resumable.sql)
- [Rollback Details](./rollback.sql)
- [Resource Plans](./rp.sql)
- [Set up SQL*Plus Session](./setup_sqlplus.sql)
- [Sort Segments](./ss.sql)
- [Get Segment Size](./ssz.sql)
- [Temp Extent Pool](./tep.sql)
- [Temp Space Header](./tsh.sql)
