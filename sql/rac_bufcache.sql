/* RAC Buffer cache (db cache + cache fusion) contents status Christo Kutrovsky - The Pythian Group */
select *
from   (select *
   from   (select distinct o.owner, o.object_name, o.object_type as type, SUBOBJECT_NAME,
          round(case
             when sum(d_cnt) / sum(tot) * 100 >= 1 then
            sum(d_cnt) / sum(tot) * 100
           end,
           2) as "D%", sum(d_cnt) as dirty, round(sum(tot) * p.bs / 1024, 1) as mbytes,
          round(sum(cur_sha) * p.bs / 1024, 1) as sha,
          round(sum(cur_sha) / sum(tot) * 100, 1) as "sha%", round(sum(r) * 100, 1) as "%",
          round(sum(pi) * p.bs / 1024, 1) as pi, round(sum(cr) * p.bs / 1024, 1) as cr,
          round((sum(cr_sha)) * p.bs / 1024, 1) as cr_sha,
          round((sum(assm)) * p.bs / 1024, 1) as assm,
          round((1 - sum(cur_sha) / sum(tot) * 2) * 100, 1) as "cfe2%",
          sum(cur_x) as x
      from   (select to_number(decode(temp, 'Y', 9, decode(status, 'free', 0, objd))) as objd, temp,
          count(nullif(dirty, 'N')) as d_cnt, sum(pi) as pi, sum(cr) as cr, round(avg(cr), 1) as cr_i,
          sum(cr_min_inst / nullif(i, 1)) as cr_sha, sum(assm / i) as assm,
          sum(assm) - sum(assm / i) as assm_sha, sum(xcur) as cur_x,
          sum(scur / nullif(i, 1)) as cur_sha, sum(tot) as tot, sum(r) as r
         from   (select inst_id, file#, block#, temp, dirty, status, objd, class#, count(*) as tot,
             decode(status, 'cr', count(*)) as cr,
             case
              when status in ('scur') then
               count(*)
            end as sha1, decode(status, 'pi', count(*)) as pi,
             count(distinct inst_id) over(partition by class#, file#, block#) as i,
             sum(decode(status, 'cr', count(*))) over(partition by inst_id, file#, block#) as cr_min_inst,
             decode(status, 'xcur', count(*)) as xcur, decode(status, 'scur', count(*)) as scur,
             case
              when class# in (8, 9, 10) then
               count(*)
            end as assm, ratio_to_report(count(*)) over() as r
          from   gv$bh
          group  by inst_id, file#, block#, status, temp, dirty, objd, class#)
         group  by decode(status, 'free', 0, objd), temp) h,
       (select owner, object_name, subobject_name, object_id, data_object_id, object_type,
          row_number() over(partition by data_object_id order by object_type) rn, 'N' as temp
         from   dba_objects
         where  data_object_id > 0
         union all
         select ' ', '<<<FREE BLOCKS>>>', null, null, 0, null, 1, 'N'
         from   dual
         union all
         select ' ', '<<<ROLLBACK>>>', null, /*to_char(rownum)*/ null, 4294967296 - rownum, '', 1, 'N'
         from   dual
         connect by dummy = dummy
           and  rownum < 100
         union all
         select ' ', '<<<TEMP SEGMENT>>>', null, null, 9, null, 1, 'Y' as temp
         from   dual) o,
       (select value / 1024 as bs
         from   v$parameter
         where  name = 'db_block_size') p
      where  o.data_object_id = h.objd
      and  o.rn = 1
      and  o.temp = h.temp
      --and o.owner not in ('SYS','SYSTEM')
      group  by p.bs, rollup((o.owner, o.object_name, o.object_type), (SUBOBJECT_NAME)))
   order  by mbytes desc)
where  rownum <= 100
/
