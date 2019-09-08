--Purpose: check rollback transactions and give ETA
--Created by: Alex Zeng, Sept 11, 2011
set serveroutput on
DECLARE
  type t_undoblocks is table of number index by varchar2(100);
  type t_ublk is table of number index by varchar2(100);
  v_undoblocks t_undoblocks;
  v_ublk t_ublk;
  v_eta number;
  v_sleep number := 3;
BEGIN
  for r in (SELECT cast(b.XID as varchar2(100)) xid, b.used_urec FROM v$transaction b)
  LOOP
     v_ublk(r.xid) := r.used_urec;
  end loop; 
  dbms_output.put_line('Checking if SMON is recovering any transactions');
  for r in (select cast(XID as varchar2(100)) xid, state,undoblocksdone,undoblockstotal,RCVSERVERS from V$FAST_START_TRANSACTIONS where state<>'RECOVERED')
  LOOP
    v_undoblocks(r.xid) := r.undoblocksdone;
    dbms_output.put_line(rpad('TransactionID',25) || rpad('state',15) || rpad('recover_servers',20) || rpad('undo_blocks_total',20) || rpad('undo_blocks_done',20));
    dbms_output.put_line(rpad(r.XID,25) || rpad(r.state,25) || rpad(to_char(r.RCVSERVERS),20) || rpad(to_char(r.undoblockstotal),20) || rpad(to_char(r.undoblocksdone),20));
  end loop;
 
  dbms_output.put_line(chr(10) ||'Sleep '||v_sleep||' seconds to check again...');
  dbms_lock.sleep(v_sleep);
 
  for r in (select cast(XID as varchar2(100)) xid, state,undoblocksdone,undoblockstotal,RCVSERVERS from V$FAST_START_TRANSACTIONS where state<>'RECOVERED')
  LOOP
    if v_undoblocks.exists(r.xid) then
       if r.undoblocksdone > v_undoblocks(r.xid) then
         v_eta := round((r.undoblockstotal-r.undoblocksdone)*v_sleep/60/(r.undoblocksdone-v_undoblocks(r.xid)),1);
         dbms_output.put_line('SMON is rolling back '||r.xid||'...'||r.undoblocksdone||' out of '||r.undoblockstotal||' blocks are done...ETA
is '||v_eta||' minutes');
       else
         dbms_output.put_line('SMON is rolling back '||r.xid||'...'||r.undoblocksdone||' out of '||r.undoblockstotal||' blocks are done...ETA
is unknown, pls try again');
       end if;
    end if;
  end loop;
 
  dbms_output.put_line(chr(10) ||'Checking if any transaction is rolling back by itself');
  for r in (SELECT a.sid, cast(b.XID as varchar2(100)) xid, b.used_urec FROM v$session a, v$transaction b WHERE a.saddr = b.ses_addr)
  LOOP
      if v_ublk.exists(r.xid) then
         if v_ublk(r.xid) > r.used_urec THEN
            v_eta := round(r.used_urec * v_sleep/60/(v_ublk(r.xid) - r.used_urec), 1);
            dbms_output.put_line('SID,XID : '||r.sid||','||r.xid||' is rolling back...'||r.used_urec||' blocks to go...ETA is '||v_eta||' minutes');
         end if;
      end if;
  end loop; 
end;
/
