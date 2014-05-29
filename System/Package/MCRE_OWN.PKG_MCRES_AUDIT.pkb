CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRES_AUDIT AS
/******************************************************************************
   NAME:       PKG_MCRES_ALIMENTAZIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0     30/06/2010    V.Galli       Created this package.
   1.1     07/11/2010    V.Galli       Dta_INS
******************************************************************************/

  PROCEDURE log_app (p_id number, p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2, p_utente varchar2) as
  pragma autonomous_transaction;

  BEGIN

   IF P_LIVELLO <= C_LEVEL THEN
    INSERT INTO MCRE_OWN.T_MCRES_WRK_AUDIT_APPLICATIVO (ID, PROCEDURA, LIVELLO, SQL_CODE, MESSAGE, NOTE, UTENTE,DTA_INS)
    values (p_id, p_proc, p_livello, p_sqlcode, p_mssg, p_note, p_utente,sysdate);
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

    INSERT INTO MCRE_OWN.T_MCRES_WRK_AUDIT_APPLICATIVO (ID, PROCEDURA, LIVELLO, SQL_CODE, MESSAGE, NOTE, UTENTE,DTA_INS)
    values (seq, p_proc, p_livello, p_sqlcode, p_mssg, p_note, p_utente,sysdate);
    commit;
   end if;

  END;

  PROCEDURE log_etl (p_id number, p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2 default null) as
  pragma autonomous_transaction;

  BEGIN

   IF P_LIVELLO <= C_LEVEL_ETL THEN
    INSERT INTO MCRE_OWN.T_MCRES_WRK_AUDIT_ETL (ID, PROCEDURA, LIVELLO, SQL_CODE, MESSAGE, NOTE,DTA_INS)
    values (p_id, p_proc, p_livello, p_sqlcode, p_mssg, p_note,sysdate);
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

    INSERT INTO MCRE_OWN.T_MCRES_WRK_AUDIT_ETL (ID, PROCEDURA, LIVELLO, SQL_CODE, MESSAGE, NOTE,DTA_INS)
    values (seq, p_proc, p_livello, p_sqlcode, p_mssg, p_note,sysdate);
    commit;
   end if;

  END;

  PROCEDURE log_caricamenti (p_id_flusso number, p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2) as
  pragma autonomous_transaction;

  seq number;

  BEGIN

   if p_livello <= c_level_etl then
    select SEQ_MCRES_LOG.nextval
        INTO SEQ FROM DUAL;
    INSERT INTO MCRE_OWN.T_MCRES_WRK_AUDIT_CARICAMENTI (ID_FLUSSO, PROCEDURA, LIVELLO, SQL_CODE, MESSAGE, NOTE, ID,DTA_INS)
    values (p_id_flusso, p_proc, p_livello, p_sqlcode, p_mssg, p_note, seq,sysdate);
    commit;
   end if;

  END;


  PROCEDURE log_caricamenti (p_id number, p_id_flusso number,p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2) as
  pragma autonomous_transaction;


  BEGIN

   IF P_LIVELLO <= C_LEVEL_ETL THEN
    INSERT INTO MCRE_OWN.T_MCRES_WRK_AUDIT_CARICAMENTI (ID_FLUSSO, PROCEDURA, LIVELLO, SQL_CODE, MESSAGE, NOTE, ID,DTA_INS)
    values (p_id_flusso, p_proc, p_livello, p_sqlcode, p_mssg, p_note, p_id,sysdate);
    commit;
   end if;

  END;

  --elimino le righe di log 'vecchie'
  FUNCTION svecchia_log_app return number is

  begin
    delete MCRE_OWN.T_MCRES_WRK_AUDIT_APPLICATIVO
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
    delete MCRE_OWN.T_MCRES_WRK_AUDIT_ETL
    where dta_ins < sysdate  - c_offset;
    commit;
    return 1;
  exception when others then
    log_etl('svecchia_log_etl', 1, sqlcode, sqlerrm, '');
    return 0;
  end;

  --elimino le righe di log 'vecchie'
  FUNCTION svecchia_log_caricamenti return number is

  begin
    delete MCRE_OWN.T_MCRES_WRK_AUDIT_caricamenti
    where dta_ins < sysdate  - c_offset;
    commit;
    return 1;
  exception when others then
    log_etl('svecchia_log_caricamenti', 1, sqlcode, sqlerrm, '');
    return 0;
  end;


END PKG_MCRES_AUDIT;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_AUDIT FOR MCRE_OWN.PKG_MCRES_AUDIT;


CREATE SYNONYM MCRE_USR.PKG_MCRES_AUDIT FOR MCRE_OWN.PKG_MCRES_AUDIT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_AUDIT TO MCRE_USR;

