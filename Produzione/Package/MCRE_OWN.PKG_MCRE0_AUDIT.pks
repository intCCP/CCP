CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_AUDIT AS
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
   1.5        05/08/2011  VMarco Murro       svecchio dopo 120gg
******************************************************************************/

  c_package   CONSTANT VARCHAR2(50) := 'PKG_MCRE0_AUDIT';
  c_level     CONSTANT NUMBER :=  3; --debug
  c_level_etl CONSTANT NUMBER :=  3; --debug
  c_offset    CONSTANT NUMBER := 120;
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

  --log dei caricameenti
  PROCEDURE log_etl (p_id number, p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2 default null);

  --versione con chiamata interna alla sequence
  PROCEDURE log_etl (p_proc varchar2, p_livello number, p_sqlcode number, p_mssg varchar2, p_note varchar2);

  --elimino le righe di log 'vecchie'
  FUNCTION svecchia_log_app return number;

  --elimino le righe di log 'vecchie'
  FUNCTION svecchia_log_etl return number;

END PKG_MCRE0_AUDIT;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_AUDIT FOR MCRE_OWN.PKG_MCRE0_AUDIT;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_AUDIT FOR MCRE_OWN.PKG_MCRE0_AUDIT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_AUDIT TO MCRE_USR;

