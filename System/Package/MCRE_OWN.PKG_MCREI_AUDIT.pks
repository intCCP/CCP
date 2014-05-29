CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcrei_audit
AS
/******************************************************************************
 NAME:       PKG_MCREI_GESTIONE_PARTIZIONI
 PURPOSE:

 REVISIONS:
 Ver        Date              Author             Description
 ---------  ----------      -----------------  ------------------------------------
 1.0      20/10/2011         E.Pellizzi         Created this package.
******************************************************************************/
   c_package     CONSTANT VARCHAR2 (50) := 'PKG_MCREI_AUDIT';
   c_level       CONSTANT NUMBER        := 3;                         --debug
   c_level_etl   CONSTANT NUMBER        := 3;                         --debug
   c_offset      CONSTANT NUMBER        := 180;
   c_debug       CONSTANT NUMBER        := 3;
   c_warning     CONSTANT NUMBER        := 2;
   c_error       CONSTANT NUMBER        := 1;

   --log dell'applicazione
   PROCEDURE log_app (
      p_id        NUMBER,
      p_proc      VARCHAR2,
      p_livello   NUMBER,
      p_sqlcode   NUMBER,
      p_mssg      VARCHAR2,
      p_note      VARCHAR2,
      p_utente    VARCHAR2
   );

   --versione con chiamata interna alla sequence
   PROCEDURE log_app (
      p_proc      VARCHAR2,
      p_livello   NUMBER,
      p_sqlcode   NUMBER,
      p_mssg      VARCHAR2,
      p_note      VARCHAR2,
      p_utente    VARCHAR2
   );

   --log ETL
   PROCEDURE log_etl (
      p_id        NUMBER,
      p_proc      VARCHAR2,
      p_livello   NUMBER,
      p_sqlcode   NUMBER,
      p_mssg      VARCHAR2,
      p_note      VARCHAR2 DEFAULT NULL
   );

   --versione con chiamata interna alla sequence
   PROCEDURE log_etl (
      p_proc      VARCHAR2,
      p_livello   NUMBER,
      p_sqlcode   NUMBER,
      p_mssg      VARCHAR2,
      p_note      VARCHAR2
   );

   --log dei caricameenti
   PROCEDURE log_caricamenti (
      p_id_flusso   NUMBER,
      p_proc        VARCHAR2,
      p_livello     NUMBER,
      p_sqlcode     NUMBER,
      p_mssg        VARCHAR2,
      p_note        VARCHAR2 DEFAULT NULL
   );

   --elimino le righe di log 'vecchie'
   FUNCTION svecchia_log_app
      RETURN NUMBER;

   --elimino le righe di log 'vecchie'
   FUNCTION svecchia_log_etl
      RETURN NUMBER;

   --elimino le righe di log 'vecchie'
   FUNCTION svecchia_log_caricamenti
      RETURN NUMBER;
END pkg_mcrei_audit;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_AUDIT FOR MCRE_OWN.PKG_MCREI_AUDIT;


CREATE SYNONYM MCRE_USR.PKG_MCREI_AUDIT FOR MCRE_OWN.PKG_MCREI_AUDIT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_AUDIT TO MCRE_USR;

