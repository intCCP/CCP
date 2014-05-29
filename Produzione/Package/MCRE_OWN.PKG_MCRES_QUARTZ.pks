CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRES_QUARTZ AS

/******************************************************************************
   NAME:      PKG_MCRES_QUARTZ
   PURPOSE:   Gestione job sofferenze

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  -------------------------------
   1.0        29/10/2013  Pepe Mauro         Created this package.
******************************************************************************/

  --costanti
  c_package CONSTANT VARCHAR2(50) := 'PKG_MCRES_QUARTZ';
  c_ok CONSTANT NUMBER(1) := 1; --esecuzione avvenuta corretamente
  c_ko CONSTANT NUMBER(1) := 0; --esecuzione avvenuta con errori

  --nomi job
  c_job_sollecito_filiali_doc CONSTANT CHAR := 'S';
  c_job_pratiche_cessione_rou CONSTANT CHAR := 'P';

  --stati job
  c_stato_avviato CONSTANT VARCHAR2(1) := 'A';      --Job Avviato
  c_stato_completato CONSTANT VARCHAR2(1) := 'C';   --Job Completato
  c_stato_errore CONSTANT VARCHAR2(1) := 'E';       --Job Completato con errori
  c_stato_da_annullare CONSTANT VARCHAR2(1) := 'D'; --Job da Annullare
  c_stato_annullato CONSTANT VARCHAR2(1) := 'N';    --Job Annullato

  --output inizio_job
  c_procedi CONSTANT NUMBER(1) := 1;       --il processo java può eseguire il task
  c_non_procedere CONSTANT NUMBER(1) := 0; --il processo java non deve eseguire il task

  FUNCTION inserisci_log ( P_COD_JOB IN CHAR, P_DESC_ERRORE IN VARCHAR2, P_VAL_PARAMS IN VARCHAR2 ) RETURN NUMBER;
  FUNCTION get_ultima_esecuzione ( p_cod_job IN CHAR ) RETURN TIMESTAMP;
  FUNCTION inizio_job ( p_cod_job IN CHAR, p_val_servername IN VARCHAR2 ) RETURN NUMBER;
  FUNCTION fine_job ( p_cod_job IN CHAR ) RETURN NUMBER;
  FUNCTION fine_job_con_errore ( p_cod_job IN CHAR ) RETURN NUMBER;
  FUNCTION richiedi_annullo_job ( p_cod_job IN CHAR ) RETURN NUMBER;
  FUNCTION annulla_job ( p_cod_job IN CHAR ) RETURN NUMBER;
  FUNCTION elimina_ultima_esecuzione_job ( p_cod_job IN CHAR ) RETURN NUMBER;

  FUNCTION get_stato_job ( p_cod_job IN CHAR ) RETURN CHAR;

END pkg_mcres_quartz;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_QUARTZ FOR MCRE_OWN.PKG_MCRES_QUARTZ;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_QUARTZ TO MCRE_USR;

