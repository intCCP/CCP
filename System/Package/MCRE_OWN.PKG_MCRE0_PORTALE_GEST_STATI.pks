CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcre0_portale_gest_stati AS
  /******************************************************************************
     NAME:     PKG_MCRE0_PORTALE_GESTIONE_STATI
     PURPOSE: Gestione stati da portale

     REVISIONS:
     Ver        Date        Author             Description
     ---------  ----------  -----------------  ------------------------------------
     1.0        25/01/2011  Galli Valeria      Created this package.
     2.0        09/03/2011  Galli Valeria      fnc_pt_avanzamento.
     3.0        01/04/2011  Galli Valeria      Gestito No_Data_Found in Anomalie
     3.1        08/04/2011  Galli Valeria      esito inizializzato a ok
     4.0        12/04/2011  Galli Valeria      gestione proroghe
     4.1        25/04/2011  Galli Valeria      Storicizzazione proroghe vecchie
     4.2        26/05/2011  GAlli Valeria      Nuova gestione LOG
     4.3        30/05/2011  Galli Valeria      RIO azioni check gruppo
     4.4        30/06/2011  Murro Marco        Rimuovi record dopo 2gg dal cambio stato(ISPCPP-811)
     4.5        01/07/2011  Murro Marco        Svecchiamneto tab GB (365gg)
     5.0        03/08/2011  Murro Marco        Tuning - v_upd_fields
     6.0        21/05/2012  Murro Marco        Fix scadenza proroga e num proroghe
     7.0        06/06/2012   V.Galli   Commenti con label:   VG - CIB/BDT - INIZIO
     8.0        13/09/2012  d'errico           modificata logica di rimozione azioni in fnc_delete_rio_set
     8.1        20/09/2012   V.Galli           Delete Advisor ( Commenti con label:   VG - CIB/BDT - INIZIO )
     8.2        01/10/2012   V.Galli           Delete_RIO_Sett: trasformazione da cancellazione fisica a logica
     8.3        24/10/2012  Murro Marco        num proroghe+1 anche su Rifiuto
     8.4        24/10/2012  Murro Marco        tolto controllo data servizio se non direzione
     8.5        03/12/2012  Murro Marco        rafforzato controllo su delete PT e fix delete RIO
     8.6        07/01/2013  Murro Marco        rafforzato controllo su delete delete RIO (flg_delete = 0)
     8.7        15/01/2013  Murro Marco        aggiunta pulizia proroghe in attesa dopo cambio stato
     8.8        21/01/2013  Federico Galletti  mofiificato il cursore c_rio_proroghe
     8.9        04/04/2013  Murro Marco        gestione proroghe Divisione
     9.0        03/05/2013  Murro Marco        fix gestioen flg_storico su nuova/conferma proroga
     9.1        03/07/2013  Murro Marco        nuova fix gestione flg_storico su nuova/conferma proroga
     9.2        20/08/2013  Murro Marco        nuova gestione Proroghe Incagli --fix 13/9
    ******************************************************************************/

  ok NUMBER := 1;
  ko NUMBER := 0;

  FUNCTION fnc_pt_avanzamento(p_cod_log t_mcre0_wrk_audit_etl.id%TYPE DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION fnc_delete_pt_sett(p_cod_abi t_mcre0_app_pt_gestione_tavoli.cod_abi_cartolarizzato%TYPE,
                              p_cod_ndg t_mcre0_app_pt_gestione_tavoli.cod_ndg%TYPE,
                              p_cod_log t_mcre0_wrk_audit_etl.id%TYPE DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION fnc_delete_pt(p_cod_log t_mcre0_wrk_audit_etl.id%TYPE DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION fnc_delete_rio_sett(p_cod_abi      t_mcre0_app_pt_gestione_tavoli.cod_abi_cartolarizzato%TYPE,
                               p_cod_ndg      t_mcre0_app_pt_gestione_tavoli.cod_ndg%TYPE,
                               p_flg_proroghe NUMBER,
                               p_cod_log      t_mcre0_wrk_audit_etl.id%TYPE DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION fnc_delete_rio(p_cod_log t_mcre0_wrk_audit_etl.id%TYPE DEFAULT NULL)
    RETURN NUMBER;

  /*******************************************************************
  **** Nuova proroga
  **** Storicizzato record precendete, inserito il nuovo. Alert.
  *******************************************************************/
  FUNCTION fnc_nuova_proroga(p_cod_abi_cartolarizzato t_mcre0_app_rio_proroghe.cod_abi_cartolarizzato%TYPE,
                             p_cod_ndg                t_mcre0_app_rio_proroghe.cod_ndg%TYPE,
                             p_cod_sndg               t_mcre0_app_alert_pos.cod_sndg%TYPE,
                             p_id_utente              t_mcre0_app_rio_proroghe.id_utente%TYPE,
                             p_val_motivo_richiesta   t_mcre0_app_rio_proroghe.val_motivo_richiesta%TYPE,
                             p_protocollo_delibera    t_mcrei_app_delibere.cod_protocollo_delibera%TYPE DEFAULT NULL,
                             p_cod_log                t_mcre0_wrk_audit_applicativo.id%TYPE DEFAULT NULL)
    RETURN NUMBER;

  /*******************************************************************
  **** Esito proroga
  **** Aggiorna la richiesta con conferma o rifuto. Alert.
  *******************************************************************/
  FUNCTION fnc_esito_proroga(p_cod_abi_cartolarizzato t_mcre0_app_rio_proroghe.cod_abi_cartolarizzato%TYPE,
                             p_cod_ndg                t_mcre0_app_rio_proroghe.cod_ndg%TYPE,
                             p_cod_sndg               t_mcre0_app_alert_pos.cod_sndg%TYPE,
                             p_cod_matricola_resp     t_mcre0_app_rio_proroghe.cod_matricola_resp%TYPE,
                             p_id_ruolo_resp          t_mcre0_app_rio_proroghe.id_ruolo_resp%TYPE,
                             p_flg_esito              t_mcre0_app_rio_proroghe.flg_esito%TYPE,
                             p_id_utente              t_mcre0_app_rio_proroghe.id_utente%TYPE,
                             p_val_motivo_esito       t_mcre0_app_rio_proroghe.val_motivo_esito%TYPE,
                             p_protocollo_delibera    t_mcrei_app_delibere.cod_protocollo_delibera%TYPE DEFAULT NULL,
                             p_cod_log                t_mcre0_wrk_audit_applicativo.id%TYPE DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION fnc_delete_gb(p_cod_log t_mcre0_wrk_audit_etl.id%TYPE DEFAULT NULL)
    RETURN NUMBER;

END pkg_mcre0_portale_gest_stati;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_PORTALE_GEST_STATI FOR MCRE_OWN.PKG_MCRE0_PORTALE_GEST_STATI;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_PORTALE_GEST_STATI FOR MCRE_OWN.PKG_MCRE0_PORTALE_GEST_STATI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_PORTALE_GEST_STATI TO MCRE_USR;

