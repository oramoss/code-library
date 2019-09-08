SET LINESIZE 250
SET WRAP OFF
SET TRIMSPOOL OFF
COLUMN plan_id HEADING "Plan|ID" FORMAT 999999999
COLUMN plan HEADING "Plan" FORMAT a30
COLUMN num_plan_directives HEADING "# Pln|Dirs" FORMAT 99999
COLUMN cpu_method HEADING "CPU|Method" FORMAT A11
COLUMN mgmt_method HEADING "Mgmt|Method" FORMAT A11
COLUMN active_sess_pool_mth HEADING "Active Sess|Pool Mth" FORMAT A25
COLUMN parallel_degree_limit_mth HEADING "Par Deg|Lmt Mth" FORMAT A30
COLUMN queueing_mth HEADING "Queueing|Method" FORMAT A15
COLUMN sub_plan HEADING "Sub|Plan" FORMAT A4
COLUMN status HEADING "Status" FORMAT A10
COLUMN mandatory HEADING "Mand?" FORMAT A5
SELECT plan_id
,      plan
,      num_plan_directives
,      cpu_method
,      mgmt_method
,      active_sess_pool_mth
,      parallel_degree_limit_mth
,      queueing_mth
,      sub_plan
,      status
,      mandatory
FROM   dba_rsrc_plans
ORDER BY plan_id;
