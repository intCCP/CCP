CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcrei_gestione_partizioni
AS
/******************************************************************************
 NAME:       PKG_MCREI_GESTIONE_PARTIZIONI
 PURPOSE:

 REVISIONS:
 Ver        Date              Author             Description
 ---------  ----------      -----------------  ------------------------------------
 1.0      20/10/2011         E.Pellizzi         Created this package.
 2.0      18/04/2013         I.Gueorguieva      Fix fnc_crea_sottopartizione dato che il parametro p_partition viene inizializzato da PKG_MCREI_ALIMENTAZIONE con l'abi

******************************************************************************/
   ok          NUMBER        := 1;
   ko          NUMBER        := 0;
   c_package   VARCHAR2 (30) := 'PKG_MCREI_GESTIONE_PARTIZIONI';
   in_use      EXCEPTION;
   PRAGMA EXCEPTION_INIT (in_use, -54);

   -- Truncate partition
   FUNCTION fnc_truncate_subpartition (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER;

   -- Truncate partition
   FUNCTION fnc_truncate_partition (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER;

    -- Exchange partition
   /* function fnc_exchange_partition(
       P_ID_FLUSSO T_MCREI_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE)
    RETURN NUMBER;*/

   -- Elimina sottopartizione
   FUNCTION fnc_elimina_sottopartizione (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER;

   -- Crea sottopartizione
   FUNCTION fnc_crea_sottopartizione (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER;

   -- Set template per sottopartizioni
   FUNCTION fnc_set_subpart_template (
      p_table       IN   VARCHAR2,
      p_id_flusso        t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER;

   -- Esiste sotto_partizione
   FUNCTION fnc_esiste_sottopartizione (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER;

   -- Aggiorna sottopartizioni
   FUNCTION fnc_update_subpartition_list (
      p_tabella      VARCHAR2 DEFAULT NULL,
      p_type_table   VARCHAR2 DEFAULT NULL,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER;

   -- Aggiorna partizioni
   FUNCTION fnc_update_partition_list (
      p_tabella      VARCHAR2 DEFAULT NULL,
      p_type_table   VARCHAR2 DEFAULT NULL,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER;

   -- Suffisso partizioni
   FUNCTION fnc_get_suffix_partition (
      p_id_flusso   t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN t_mcrei_wrk_configurazione.valore_costante%TYPE;

   -- Partizione default
   FUNCTION fnc_get_default_partition (
      p_id_flusso   t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN t_mcrei_wrk_configurazione.valore_costante%TYPE;

   -- Esiste partizione
   FUNCTION fnc_esiste_partizione (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER;

   -- Crea partizione
   FUNCTION fnc_crea_partizione (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE,
      p_desc_flusso  t_mcrei_wrk_alimentazione.DESC_FLUSSO%TYPE
   )
      RETURN NUMBER;

   -- Elimina partizione
   FUNCTION fnc_elimina_partizione (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER;
-- Ricostruisce tutte le partizioni attualmente
-- esistenti di un indice partizionato
FUNCTION fnc_rebuild_all_index_parts(
   p_tabella VARCHAR2,
   p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE)
    RETURN NUMBER;

-- Ricostruisce tutte le sottopartizioni attualmente
-- esistenti di tutti gli indici della tabella passata
-- per argomento;
-- gli indici devono essere sottopartizionati
FUNCTION fnc_rebuild_all_index_subparts(
   p_tabella VARCHAR2,
   p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE)
    RETURN NUMBER;

END pkg_mcrei_gestione_partizioni;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_GESTIONE_PARTIZIONI FOR MCRE_OWN.PKG_MCREI_GESTIONE_PARTIZIONI;


CREATE SYNONYM MCRE_USR.PKG_MCREI_GESTIONE_PARTIZIONI FOR MCRE_OWN.PKG_MCREI_GESTIONE_PARTIZIONI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_GESTIONE_PARTIZIONI TO MCRE_USR;

