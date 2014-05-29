CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcrei_audit
AS
/******************************************************************************
 NAME:       PKG_MCREI_GESTIONE_PARTIZIONI
 PURPOSE:

 REVISIONS:
 Ver        Date              Author             Description
 ---------  ----------      -----------------  ------------------------------------
 1.0      20/10/2011         E.Pellizzi         Created this package.
******************************************************************************/
   PROCEDURE log_app (
      p_id        NUMBER,
      p_proc      VARCHAR2,
      p_livello   NUMBER,
      p_sqlcode   NUMBER,
      p_mssg      VARCHAR2,
      p_note      VARCHAR2,
      p_utente    VARCHAR2
   )
   AS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      IF p_livello <= c_level
      THEN
         INSERT INTO mcre_own.t_mcrei_wrk_audit_applicativo
                     (ID, procedura, livello, sql_code, MESSAGE, note,
                      utente
                     )
              VALUES (p_id, p_proc, p_livello, p_sqlcode, p_mssg, p_note,
                      p_utente
                     );

         COMMIT;
      END IF;
   END;

   PROCEDURE log_app (
      p_proc      VARCHAR2,
      p_livello   NUMBER,
      p_sqlcode   NUMBER,
      p_mssg      VARCHAR2,
      p_note      VARCHAR2,
      p_utente    VARCHAR2
   )
   AS
      PRAGMA AUTONOMOUS_TRANSACTION;
      seq   NUMBER;
   BEGIN
      IF p_livello <= c_level
      THEN
         SELECT seq_mcr0_log_app.NEXTVAL
           INTO seq
           FROM DUAL;

         INSERT INTO mcre_own.t_mcrei_wrk_audit_applicativo
                     (ID, procedura, livello, sql_code, MESSAGE, note,
                      utente
                     )
              VALUES (seq, p_proc, p_livello, p_sqlcode, p_mssg, p_note,
                      p_utente
                     );

         COMMIT;
      END IF;
   END;

   PROCEDURE log_etl (
      p_id        NUMBER,
      p_proc      VARCHAR2,
      p_livello   NUMBER,
      p_sqlcode   NUMBER,
      p_mssg      VARCHAR2,
      p_note      VARCHAR2 DEFAULT NULL
   )
   AS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      IF p_livello <= c_level_etl
      THEN
         INSERT INTO mcre_own.t_mcrei_wrk_audit_etl
                     (ID, procedura, livello, sql_code, MESSAGE, note
                     )
              VALUES (p_id, p_proc, p_livello, p_sqlcode, p_mssg, p_note
                     );

         COMMIT;
      END IF;
   END;

   PROCEDURE log_etl (
      p_proc      VARCHAR2,
      p_livello   NUMBER,
      p_sqlcode   NUMBER,
      p_mssg      VARCHAR2,
      p_note      VARCHAR2
   )
   AS
      PRAGMA AUTONOMOUS_TRANSACTION;
      seq   NUMBER;
   BEGIN
      IF p_livello <= c_level_etl
      THEN
         SELECT seq_mcr0_log_etl.NEXTVAL
           INTO seq
           FROM DUAL;

         INSERT INTO mcre_own.t_mcrei_wrk_audit_etl
                     (ID, procedura, livello, sql_code, MESSAGE, note
                     )
              VALUES (seq, p_proc, p_livello, p_sqlcode, p_mssg, p_note
                     );

         COMMIT;
      END IF;
   END;

   PROCEDURE log_caricamenti (
      p_id_flusso   NUMBER,
      p_proc        VARCHAR2,
      p_livello     NUMBER,
      p_sqlcode     NUMBER,
      p_mssg        VARCHAR2,
      p_note        VARCHAR2
   )
   AS
      PRAGMA AUTONOMOUS_TRANSACTION;
      seq   NUMBER;
   BEGIN
      IF p_livello <= c_level_etl
      THEN
         SELECT seq_mcrei_log.NEXTVAL
           INTO seq
           FROM DUAL;

         INSERT INTO mcre_own.t_mcrei_wrk_audit_caricamenti
                     (id_flusso, procedura, livello, sql_code, MESSAGE,
                      note, ID
                     )
              VALUES (p_id_flusso, p_proc, p_livello, p_sqlcode, p_mssg,
                      p_note, seq
                     );

         COMMIT;
      END IF;
   END;

   PROCEDURE log_caricamenti (
      p_id          NUMBER,
      p_id_flusso   NUMBER,
      p_proc        VARCHAR2,
      p_livello     NUMBER,
      p_sqlcode     NUMBER,
      p_mssg        VARCHAR2,
      p_note        VARCHAR2
   )
   AS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      IF p_livello <= c_level_etl
      THEN
         INSERT INTO mcre_own.t_mcrei_wrk_audit_caricamenti
                     (id_flusso, procedura, livello, sql_code, MESSAGE,
                      note, ID
                     )
              VALUES (p_id_flusso, p_proc, p_livello, p_sqlcode, p_mssg,
                      p_note, p_id
                     );

         COMMIT;
      END IF;
   END;

   --elimino le righe di log 'vecchie'
   FUNCTION svecchia_log_app
      RETURN NUMBER
   IS
   BEGIN
      DELETE      mcre_own.t_mcrei_wrk_audit_applicativo
            WHERE dta_ins < SYSDATE - c_offset;

      COMMIT;
      RETURN 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         log_etl ('svecchia_log_app', 1, SQLCODE, SQLERRM, '');
         RETURN 0;
   END;

   --elimino le righe di log 'vecchie'
   FUNCTION svecchia_log_etl
      RETURN NUMBER
   IS
   BEGIN
      DELETE      mcre_own.t_mcrei_wrk_audit_etl
            WHERE dta_ins < SYSDATE - c_offset;

      COMMIT;
      RETURN 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         log_etl ('svecchia_log_etl', 1, SQLCODE, SQLERRM, '');
         RETURN 0;
   END;

   --elimino le righe di log 'vecchie'
   FUNCTION svecchia_log_caricamenti
      RETURN NUMBER
   IS
   BEGIN
      DELETE      mcre_own.t_mcrei_wrk_audit_caricamenti
            WHERE dta_ins < SYSDATE - c_offset;

      COMMIT;
      RETURN 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         log_etl ('svecchia_log_caricamenti', 1, SQLCODE, SQLERRM, '');
         RETURN 0;
   END;
END pkg_mcrei_audit;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_AUDIT FOR MCRE_OWN.PKG_MCREI_AUDIT;


CREATE SYNONYM MCRE_USR.PKG_MCREI_AUDIT FOR MCRE_OWN.PKG_MCREI_AUDIT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_AUDIT TO MCRE_USR;

