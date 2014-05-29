CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCREI_ALIMENTAZIONE"
AS
   /******************************************************************************
    NAME:       PKG_MCREI_ALIMENTAZIONE
    PURPOSE:

    REVISIONS:
    Ver        Date              Author             Description
    ---------  ----------      -----------------  ------------------------------------
    1.0        20/10/2011         E.Pellizzi         Created this package.
    1.1        07/03/2012         E.Pellizzi         Synchronizing sessions with DBMS_LOCK (ST)
    1.2        14/03/2012         E.Pellizzi         Synchronizing sessions with DBMS_LOCK (APP)
    1.3        23/03/2012         E.Pellizzi         Add function fnc_mcrei_alimenta_mpl
    1.4        07/05/2012         I.Gueorguieva      Add function fnc_mcrei_alimenta_st_batch
    1.5        09/05/2012         E.Pellizzi         Add called pkg_mcrei_gest_delibere.fnc_gest_classif_autom
    1.6        16/05/2012         E.Pellizzi         Optimized function fnc_mcrei_alimenta_st_batch
    1.7        11/06/2012         I.Guerguiva        Add procedura fnc_upd_del_flg_lavorati
    1.8        13/06/2012         E.Pellizzi         Add function fnc_mcrei_damp_abi
    1.9        03/07/2012         I.Gueorguieva      Modificata fnc_alimenta_st per PIANI
    1.10       04/01/2013         I.Gueorguieva      Gestione FLG_STORICO_CALCOLATO, aggiornamento a 1 alla fine del calcolo flg_attiva per abi
    2.0        28/01/2013         E.Pellizzi         Storicizzazione Delibere
    ******************************************************************************/
   c_package   CONSTANT VARCHAR2 (50) := 'PKG_MCREI_ALIMENTAZIONE';
   ok                   NUMBER        := 1;
   ko                   NUMBER        := 0;
   pk_violata           EXCEPTION;
   PRAGMA EXCEPTION_INIT (pk_violata, -1);

   FUNCTION fnc_mcrei_alimenta_fl (p_rec IN f_slave_par_type)
      RETURN NUMBER;

   FUNCTION fnc_mcrei_alimenta_st (p_rec IN f_slave_par_type)
      RETURN NUMBER;

   FUNCTION fnc_mcrei_alimenta_app (p_rec IN f_slave_par_type)
      RETURN NUMBER;

   FUNCTION fnc_mcrei_alimenta_hst (p_rec IN f_slave_par_type)
      RETURN NUMBER;

   FUNCTION fnc_mcrei_calcola_flg (p_rec IN f_slave_par_type)
      RETURN NUMBER;

   /*per il LOG:
    pkg_mcrei_audit.log_caricamenti
   nelle funzioni del portale*/

   -- ============== Gestione archiviazione ==================================

   -- %author E.Pellizzi
   -- %version 0.1.1
   -- %usage  Funzione che gestisce l'archiviazione di tabelle APP per un certo ABI.
   -- %d
   -- %d  La funzione, sposta tutti i record delle partizioni
   -- %d  INC_PSTORICHE delle tabelle APP nelle tabelle HST corrispondenti.
   -- %d
   -- %d  Per il corretto funzionamento ? necessario che le tabelle APP
   -- %d  siano partizionate sul campo FLG_ATTIVA (che pu¿ valere 0 o 1).
   -- %d  Le due partizioni devono essere chiamate rispettivamente
   -- %d  INC_PSTORICHE e INC_PATTIVE.
   -- %cd 30 nov 2011
   -- %param p_rec di tipo f_slave_par_type(SEQ_FLUSSO, NOME_FILE, PERIODO, TAB_EXT,
   -- TAB_TRG, ORDINE_ALIMENTAZIONE); In base a questo parametro vengono determinati
   -- le tabelle APP, HST e l'ABI per i quali viene effettuata l'archiviazione
   FUNCTION fnc_mcrei_archiviatore (p_rec IN f_slave_par_type)
      RETURN NUMBER;

   FUNCTION fnc_mcrei_estrattore (p_rec IN f_slave_par_type)
      RETURN NUMBER;

   FUNCTION fnc_mcrei_alimenta_mpl (p_rec IN f_slave_par_type)
      RETURN NUMBER;

  /***********************************************************************************************
    Per tutte le coppie (ABI,NDG) prive di pratica legale,individuate nella tabella DELIBERE,
    (si tratta di delibere di classificazione a incaglio o sofferenza fatte almeno il giorno prima),
    recupera (se esistente) la pratica legale corrispondente.
  **************************************************************************************************/
    PROCEDURE AGGANCIO_PRATICA(V_RESULT OUT NUMBER, P_SEQ IN NUMBER);

  /***********************************************************************************************
    Per tutte le coppie (ABI,NDG) prive di pratica legale,individuate nella tabella DELIBERE,
    (si tratta di delibere di classificazione a incaglio o sofferenza fatte almeno il giorno prima),
    recupera (se esistente) la pratica legale corrispondente.
  **************************************************************************************************/
    PROCEDURE AGGANCIO_PRATICA_HST(V_RESULT OUT NUMBER, P_SEQ IN NUMBER);

  /***********************************************************************************************
    Tutte le coppie (ABI,NDG) prive di pratica legale,individuate nella tabella DELIBERE,
    e per cui esite una coppia (ABI, NDG) con una o pi¿ pratiche chiuse nella tabella delle pratiche,
    vengono aggiornate come non attive (flg_attiva = 0)
  **************************************************************************************************/
    PROCEDURE AGGANCIO_PR_CHIUS(V_RESULT OUT NUMBER, P_SEQ IN NUMBER);
 /**
            Azzera il flg_abi lavorato per tutti gli abi
 **/
   PROCEDURE FNC_UPD_DEL_FLG_LAVORATI;
    FUNCTION fnc_mcrei_damp_abi (p_rec IN f_slave_par_type)RETURN NUMBER;
END pkg_mcrei_alimentazione;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_ALIMENTAZIONE FOR MCRE_OWN.PKG_MCREI_ALIMENTAZIONE;


CREATE SYNONYM MCRE_USR.PKG_MCREI_ALIMENTAZIONE FOR MCRE_OWN.PKG_MCREI_ALIMENTAZIONE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_ALIMENTAZIONE TO MCRE_USR;

