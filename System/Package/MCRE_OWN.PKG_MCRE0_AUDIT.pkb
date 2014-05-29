CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_AUDIT AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALIMENTAZIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        08/04/2010  Marco Murro        Created this package.
   1.1        26/04/2010  Marco Murro        Variata log_etl + svecchia
   1.3        20/05/2011  Luca Ferretti      Aggiunto default null a parametro NOTE
   1.4        26/05/2011  Valeria Galli      Costanti di livello
******************************************************************************/



  PROCEDURE log_app (p_id number, p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2, p_utente varchar2) as
  pragma autonomous_transaction;

  BEGIN

   if p_livello <= c_level then
    insert into MCRE_OWN.T_MCRE0_WRK_AUDIT_APPLICATIVO (ID, PROCEDURA, LIVELLO, SQL_CODE, MESSAGE, NOTE, UTENTE)
    values (p_id, p_proc, p_livello, p_sqlcode, p_mssg, p_note, p_utente);
    commit;
   end if;

  END;

  PROCEDURE log_app (p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2, p_utente varchar2) as
  pragma autonomous_transaction;

  seq number;

  BEGIN

   if p_livello <= c_level then
   select SEQ_MCR0_LOG_APP.nextval
    into seq from dual;

    insert into MCRE_OWN.T_MCRE0_WRK_AUDIT_APPLICATIVO (ID, PROCEDURA, LIVELLO, SQL_CODE, MESSAGE, NOTE, UTENTE)
    values (seq, p_proc, p_livello, p_sqlcode, p_mssg, p_note, p_utente);
    commit;
   end if;

  END;

  PROCEDURE log_etl (p_id number, p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2 default null) as
  pragma autonomous_transaction;

  BEGIN

   if p_livello <= c_level_etl then
    insert into MCRE_OWN.T_MCRE0_WRK_AUDIT_ETL (ID, PROCEDURA, LIVELLO, SQL_CODE, MESSAGE, NOTE)
    values (p_id, p_proc, p_livello, p_sqlcode, p_mssg, p_note);
    commit;
   end if;

  END;

  PROCEDURE log_etl (p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2) as
  pragma autonomous_transaction;

  seq number;

  BEGIN

   if p_livello <= c_level_etl then
   select SEQ_MCR0_LOG_ETL.nextval
    into seq from dual;

    insert into MCRE_OWN.T_MCRE0_WRK_AUDIT_ETL (ID, PROCEDURA, LIVELLO, SQL_CODE, MESSAGE, NOTE)
    values (seq, p_proc, p_livello, p_sqlcode, p_mssg, p_note);
    commit;
   end if;

  END;

  --elimino le righe di log 'vecchie'
  FUNCTION svecchia_log_app return number is

  begin
    delete MCRE_OWN.T_MCRE0_WRK_AUDIT_APPLICATIVO
    where dta_ins < sysdate  - c_offset;
    commit;
    return 1;
  exception when others then
    log_etl('svecchia_log_app', 1, sqlcode, sqlerrm, '');
    return 0;
  end;

  --elimino le righe di log 'vecchie'
  FUNCTION svecchia_log_etl return number is

  begin
    delete MCRE_OWN.T_MCRE0_WRK_AUDIT_ETL
    where dta_ins < sysdate  - c_offset;
    commit;
    return 1;
  exception when others then
    log_etl('svecchia_log_etl', 1, sqlcode, sqlerrm, '');
    return 0;
  end;


END PKG_MCRE0_AUDIT;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_AUDIT FOR MCRE_OWN.PKG_MCRE0_AUDIT;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_AUDIT FOR MCRE_OWN.PKG_MCRE0_AUDIT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_AUDIT TO MCRE_USR;

