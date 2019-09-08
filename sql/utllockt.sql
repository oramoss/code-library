rem 
rem $Header: utllockt.sql 21-jan-2003.16:21:56 bnnguyen Exp $ locktree.sql 
rem 
Rem Copyright (c) 1989, 2003, Oracle Corporation.  All rights reserved.  
Rem NAME
REM    UTLLOCKT.SQL
Rem  FUNCTION   - Print out the lock wait-for graph in tree structured fashion.
Rem               This is useful for diagnosing systems that are hung on locks.
Rem  NOTES
Rem  MODIFIED
Rem     bnnguyen   01/21/03  - bug2166717
Rem     pgreenwa   04/27/95 -  fix column definitions for LOCK_HOLDERS
Rem     pgreenwa   04/26/95 -  modify lock_holders query to use new dba_locks f
Rem     glumpkin   10/20/92 -  Renamed from LOCKTREE.SQL 
Rem     jloaiza    05/24/91 - update for v7 
Rem     rlim       04/29/91 - change char to varchar2 
Rem     Loaiza     11/01/89 - Creation
Rem

/* Print out the lock wait-for graph in a tree structured fashion.
 *  
 * This script  prints  the  sessions in   the system  that  are waiting for
 * locks,  and the locks that they  are waiting for.   The  printout is tree
 * structured.  If a sessionid is printed immediately below and to the right
 * of another session, then it is waiting for that session.  The session ids
 * printed at the left hand side of the page are  the ones  that everyone is
 * waiting for.
 *  
 * For example, in the following printout session 9 is waiting for
 * session 8, 7 is waiting for 9, and 10 is waiting for 9.
 *  
 * WAITING_SESSION   TYPE MODE REQUESTED    MODE HELD         LOCK ID1 LOCK ID2
 * ----------------- ---- ----------------- ----------------- -------- --------
 * 8                 NONE None              None              0         0
 *    9              TX   Share (S)         Exclusive (X)     65547     16
 *       7           RW   Exclusive (X)     S/Row-X (SSX)     33554440  2
 *       10          RW   Exclusive (X)     S/Row-X (SSX)     33554440  2
 *  
 * The lock information to the right of the session id describes the lock
 * that the session is waiting for (not the lock it is holding).
 *  
 * Note that  this is a  script and not a  set  of view  definitions because
 * connect-by is used in the implementation and therefore  a temporary table
 * is created and dropped since you cannot do a join in a connect-by.
 *  
 * This script has two  small disadvantages.  One, a  table is created  when
 * this  script is run.   To create  a table   a  number of   locks must  be
 * acquired. This  might cause the session running  the script to get caught
 * in the lock problem it is trying to diagnose.  Two, if a session waits on
 * a lock held by more than one session (share lock) then the wait-for graph
 * is no longer a tree  and the  conenct-by will show the session  (and  any
 * sessions waiting on it) several times.
 */


/* Select all sids waiting for a lock, the lock they are waiting on, and the
 * sid of the session that holds the lock.
 *  UNION
 * The sids of all session holding locks that someone is waiting on that
 * are not themselves waiting for locks. These are included so that the roots
 * of the wait for graph (the sessions holding things up) will be displayed.
 */
drop table lock_holders;

create table LOCK_HOLDERS   /* temporary table */
(
  waiting_session   number,
  holding_session   number,
  lock_type         varchar2(26),
  mode_held         varchar2(14),
  mode_requested    varchar2(14),
  lock_id1          varchar2(22),
  lock_id2          varchar2(22)
);

drop   table dba_locks_temp;
create table dba_locks_temp as select * from dba_locks;

/* This is essentially a copy of the dba_waiters view but runs faster since
 *  it caches the result of selecting from dba_locks.
 */
insert into lock_holders 
  select w.session_id,
        h.session_id,
        w.lock_type,
        h.mode_held,
        w.mode_requested,
        w.lock_id1,
        w.lock_id2
  from dba_locks_temp w, dba_locks_temp h
 where h.blocking_others =  'Blocking'
  and  h.mode_held      !=  'None'
  and  h.mode_held      !=  'Null'
  and  w.mode_requested !=  'None'
  and  w.lock_type       =  h.lock_type
  and  w.lock_id1        =  h.lock_id1
  and  w.lock_id2        =  h.lock_id2;

commit;

drop table dba_locks_temp;

insert into lock_holders 
  select holding_session, null, 'None', null, null, null, null 
    from lock_holders 
 minus
  select waiting_session, null, 'None', null, null, null, null
    from lock_holders;
commit;

column waiting_session format a17;
column lock_type format a17;
column lock_id1 format a17;
column lock_id2 format a17;

/* Print out the result in a tree structured fashion */
select  lpad(' ',3*(level-1)) || waiting_session waiting_session,
	lock_type,
	mode_requested,
	mode_held,
	lock_id1,
	lock_id2
 from lock_holders
connect by  prior waiting_session = holding_session
  start with holding_session is null;

drop table lock_holders;
