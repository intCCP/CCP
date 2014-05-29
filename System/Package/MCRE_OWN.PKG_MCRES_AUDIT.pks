CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRES_AUDIT AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALIMENTAZIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------       -----------------  ------------------------------------
   1.0     30/06/2010    V.Galli       Created this package.
   1.1     07/11/2010    V.Galli       Dta_INS
******************************************************************************/

  c_package   CONSTANT VARCHAR2(50) := 'PKG_MCRES_AUDIT';
  c_level     CONSTANT NUMBER :=  3; --debug
  c_level_etl CONSTANT NUMBER :=  3; --debug
  c_offset    CONSTANT NUMBER := 45;
--  c_level   CONSTANT NUMBER := 3; --debug
--  c_level   CONSTANT NUMBER := 2; --warning
--  c_level   CONSTANT NUMBER := 1; --error
  C_DEBUG CONSTANT NUMBER := 3;
  C_WARNING CONSTANT NUMBER := 2;
  C_ERROR CONSTANT NUMBER := 1;

  --log dell'applicazione
  PROCEDURE log_app (p_id number, p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2, p_utente varchar2);

  --versione con chiamata interna alla sequence
  PROCEDURE log_app (p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2, p_utente varchar2);

  --log ETL
  PROCEDURE log_etl (p_id number, p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2 default null);

  --versione con chiamata interna alla sequence
  PROCEDURE log_etl (p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2);

   --log dei caricameenti
  PROCEDURE log_caricamenti (p_id_flusso number, p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2 default null);

  --elimino le righe di log 'vecchie'
  FUNCTION svecchia_log_app return number;

  --elimino le righe di log 'vecchie'
  FUNCTION svecchia_log_etl return number;

  --elimino le righe di log 'vecchie'
  FUNCTION svecchia_log_caricamenti return number;

END PKG_MCRES_AUDIT;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_AUDIT FOR MCRE_OWN.PKG_MCRES_AUDIT;


CREATE SYNONYM MCRE_USR.PKG_MCRES_AUDIT FOR MCRE_OWN.PKG_MCRES_AUDIT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_AUDIT TO MCRE_USR;

