CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcrei_web_util_delib IS
/******************************************************************************
NAME:       PKG_MCREI_WEB_UTIL_DELIB
PURPOSE:

REVISIONS:
Ver        Date              Author             Description
---------  ----------      -----------------  ------------------------------------
1.0      13/03/2012                           Created this package.
1.1      02/08/2012         M.Murro           Aggiunta funzione per presa visione alert incagli
1.2      24/10/2012         M.Murro           Presavisione alert incagli - conferimenti-no commit
1.3      31/10/2012         I.Gueorguieva     Gestisci_utente
1.4      21/11/2012         M.Ceru            switch_criterio_assegnazione, assegnazione_gestori
1.5      03/04/2013         I.Gueorguieva
1.6      11/04/2013         M.Murro           aggiunta popola_rapporti_in_essere
1.7      14/05/2013         M.Murro           aggiunte funzioni RWA di Luca
1.8      15/05/2013         M.Murro           agginte funzioni check pos scadute
1.9      27/05/2013         M.Murro           agginta gestione dta_conferma_host
2.0      07/11/2013         M.Ceru'           fix pos_scadute_pacchetto - fix 11.11
2.1      28/11/2013         M.Murro           fix pos_scadute
2.2      29/01/2014         T.Bernardi        modificata fnc set_presa_visione_alert per gestione alert 48
2.3      24/03/2014         T.Bernardi        modificate func switch_criterio_assegnazione,assegnazione_gestori aggiunto caso 'PR'
******************************************************************************/
   c_package CONSTANT VARCHAR2 (50) := 'PKG_MCREI_WEB_UTIL_DELIB';
   const_esito_ok CONSTANT NUMBER := 1;
   const_esito_ko CONSTANT NUMBER := 0;

   PROCEDURE verifica_gestione_esterna (
      p_cod_sndg_da_class IN t_mcrei_app_delibere.cod_sndg%TYPE,
      p_cod_ndg IN t_mcrei_app_delibere.cod_ndg%TYPE,
      p_cod_abi IN t_mcrei_app_delibere.cod_abi%TYPE,
      p_cod_protocollo_delibera IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
      p_cod_protocollo_pacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
      p_forz_man_gest_interna IN t_mcrei_app_delibere.flg_forz_man_gest_interna%TYPE,
      p_esp_complessiva_cassa IN t_mcrei_app_delibere.val_esp_tot_cassa%TYPE,
      p_motivo_pass_rischio IN t_mcrei_app_delibere.desc_motivo_pass_rischio%TYPE,
      out_motivo_no_cess_rout IN OUT VARCHAR2,
      out_motivo_gestione IN OUT VARCHAR2,
      out_motivo_errore IN OUT VARCHAR2,
      out_esito IN OUT NUMBER
   );

   FUNCTION set_presa_visione_alert (
      codabi IN t_mcrei_app_delibere.cod_abi%TYPE,
      codndg IN t_mcrei_app_delibere.cod_ndg%TYPE,
      codsndg IN t_mcrei_app_delibere.cod_sndg%TYPE,
      codprotocollopacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
      codprotocollodelibera IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
      id_alert IN NUMBER,
      codutente IN t_mcrei_app_delibere.cod_matricola_inserente%TYPE
            DEFAULT NULL
   )
      RETURN NUMBER;

-- %AUTHOR REPLY
-- %VERSION 0.2
-- %USAGE  FUNZIONE CHE INSERISCE UN NUOVO UTENTE
-- %PARAM P_ID_UTENTE ID del nuovo utente da inserire
-- %PARAM P_FLG_AZIONE: I insert, U update, D delete
-- %PARAM P_STATI_ASSOCIATI concatenazione degli stati separati da ;
-- %CD 31 OTT
-- %RETURN -> 1 se l'inserimento e' andato a buon fine, false altrimenti
   FUNCTION gestisci_utente (
      p_id_utente IN t_mcre0_app_utenti.id_utente%TYPE,
      p_cod_matricola IN t_mcre0_app_utenti.cod_matricola%TYPE,
      p_cod_fiscale IN t_mcre0_app_utenti.cod_fiscale%TYPE,
      p_cognome IN t_mcre0_app_utenti.cognome%TYPE,
      p_nome IN t_mcre0_app_utenti.nome%TYPE,
      p_id_referente IN t_mcre0_app_utenti.id_referente%TYPE,
      p_data_assegnazione_ref IN t_mcre0_app_utenti.data_assegnazione_ref%TYPE,
      p_flg_gestore_abilitato IN t_mcre0_app_utenti.flg_gestore_abilitato%TYPE,
      p_cod_comparto_utente IN t_mcre0_app_utenti.cod_comparto_utente%TYPE,
      p_stati_associati IN VARCHAR2,
      p_flg_azione IN VARCHAR2,
      p_id_utente_new IN t_mcre0_app_utenti.id_utente%TYPE,
      p_flg_referente IN t_mcre0_app_utenti.flg_referente%TYPE,
      p_cod_comparto_appart IN t_mcre0_app_utenti.cod_comparto_appart%TYPE,
      p_cod_priv IN t_mcre0_app_utenti.cod_priv%TYPE,
      p_cod_comparto_assegn IN t_mcre0_app_utenti.cod_comparto_assegn%TYPE,
      p_cod_processo IN VARCHAR2 default 'XX'--tutti i processi
   )
      RETURN NUMBER;

   FUNCTION switch_criterio_assegnazione (
      p_cod_struttura_competente_rg IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE,
      p_cod_abi_istituto IN t_mcre0_app_struttura_org.cod_abi_istituto%TYPE,
      p_desc_criterio_assegnazione IN t_mcre0_app_associa_gestori_uo.desc_criterio_assegnazione%TYPE,
      p_cod_matricola_assegnatario IN t_mcre0_app_utenti.cod_matricola%TYPE,
      p_cod_comparto_assegnatario IN t_mcre0_app_utenti.cod_comparto_appart%TYPE,
      p_cod_struttura_competente_ar IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE DEFAULT NULL
   )
      RETURN NUMBER;

   FUNCTION assegnazione_gestori (
      p_cod_struttura_competente_dc IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE,
      p_cod_struttura_competente_dv IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE,
      p_cod_struttura_competente_rg IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE,
      p_cod_abi_istituto IN t_mcre0_app_struttura_org.cod_abi_istituto%TYPE,
      p_desc_criterio_assegnazione IN t_mcre0_app_associa_gestori_uo.desc_criterio_assegnazione%TYPE,
                                                      --P_COD_CRITERIO_ASSEGN
      p_cod_matricola_assegnatario IN t_mcre0_app_utenti.cod_matricola%TYPE,
                                                     --P_COD_MATRICOLA_ASSEGN
      p_cod_comparto_assegnatario IN t_mcre0_app_utenti.cod_comparto_appart%TYPE,
                                                      --P_COD_COMPARTO_ASSEGN
      p_cod_struttura_competente IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE,
      p_cod_matricola_assegnata IN t_mcre0_app_utenti.cod_matricola%TYPE,
                                                            --P_COD_MATRICOLA
      p_cod_struttura_competente_ar IN t_mcre0_app_struttura_org.cod_struttura_competente%TYPE
            DEFAULT NULL,
      P_TEAM in varchar2,                                                   --MOD
      P_COD_PROCESSO in VARCHAR2 default '*'
   )
      RETURN NUMBER;

FUNCTION SET_CONFERMA_HOST(
  P_COD_PROTOCOLLO_PACCHETTO IN T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_PACCHETTO%TYPE,
  P_COD_PROTOCOLLO_DELIBERA  IN  T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA %TYPE,
  P_COD_ABI IN  T_MCREI_APP_DELIBERE.COD_ABI%TYPE,
  P_COD_NDG IN  T_MCREI_APP_DELIBERE.COD_NDG%TYPE,
  P_COD_SNDG IN  T_MCREI_APP_DELIBERE.COD_SNDG%TYPE
) RETURN NUMBER;

FUNCTION POPOLA_RAPPORTI_IN_ESSERE(
  P_COD_PROTOCOLLO_PACCHETTO IN T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_PACCHETTO%TYPE,
  p_flg_report IN varchar2 default 'N'
) RETURN NUMBER;

--FUNZIONE DI SALVATAGGIO ED INIZIALIZZAZIONE NUOVO RECORD
-- %return 1 -> se l'insert e' andata a buon fine, 0 altrimenti
FUNCTION FNC_INSERT_RWA_PACCHETTO
    (P_COD_PROTOCOLLO_PACCHETTO    IN T_MCREI_RWA_PACCHETTO.COD_PROTOCOLLO_PACCHETTO%TYPE,
     P_COD_BS                    IN T_MCREI_RWA_PACCHETTO.COD_BS%TYPE,
     P_TICKET_ID                IN T_MCREI_RWA_PACCHETTO.TICKET_ID%TYPE,
     P_RWA_TICKET_ID            IN T_MCREI_RWA_PACCHETTO.RWA_TICKET_ID%TYPE,
     P_COD_MATRICOLA            IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE default null)
RETURN NUMBER ;

--FUNZIONE DI AGGIORNAMENTO DEL FLG_VALIDITA
-- %return 1 -> se l'update e' andata a buon fine, 0 altrimenti
FUNCTION FNC_UPD_VALIDITA_RWA_PACCHETTO
    (P_COD_PROTOCOLLO_PACCHETTO    IN T_MCREI_RWA_PACCHETTO.COD_PROTOCOLLO_PACCHETTO%TYPE,
     P_COD_BS                    IN T_MCREI_RWA_PACCHETTO.COD_BS%TYPE,
     P_FLG_VALIDITA                IN T_MCREI_RWA_PACCHETTO.FLG_VALIDITA%TYPE,
     P_COD_MATRICOLA            IN T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE default null)
RETURN NUMBER;


   FUNCTION check_pos_scadute (
      codprotocollopacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
      codmicrotipologia IN t_mcrei_app_delibere.cod_microtipologia_delib%TYPE
   )
      RETURN NUMBER;

   FUNCTION check_pos_scadute_pacchetto (
      codprotocollopacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE
   )
      RETURN NUMBER;

PROCEDURE POPOLA_NOTE_DELIBERE(
          P_COD_ABI IN T_MCREI_APP_DELIBERE.COD_ABI%TYPE ,
          P_COD_NDG IN T_MCREI_APP_DELIBERE.COD_NDG%TYPE ,
          P_PROTO_DELIBERA IN T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA%TYPE ,
          P_PROTO_PACCHETTO IN T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_PACCHETTO%TYPE ,
          P_NOTE_DEL IN T_MCREI_APP_DELIBERE.DESC_NOTE%TYPE DEFAULT NULL,
          out_esito IN OUT NUMBER
                              );



FUNCTION POPOLA_ALLEGATI_DELIBERA(
  P_COD_PROTOCOLLO_PACCHETTO IN  T_MCREI_APP_ALLEGATI_DELIBERA.COD_PROTOCOLLO_PACCHETTO%TYPE,
  P_COD_DOCUMENTO IN T_MCREI_APP_ALLEGATI_DELIBERA.COD_DOCUMENTO%TYPE,
  P_DTA_UPD IN T_MCREI_APP_ALLEGATI_DELIBERA.DTA_UPD%TYPE
) RETURN NUMBER;


FUNCTION DELETE_ALLEGATI_DELIBERA (
   P_COD_PROTOCOLLO_PACCHETTO IN T_MCREI_APP_ALLEGATI_DELIBERA.COD_PROTOCOLLO_PACCHETTO%TYPE)
   RETURN NUMBER;

FUNCTION TRASFERISCI_PACCHETTO (
   P_COD_PROTOCOLLO_PACCHETTO IN T_MCREI_APP_ALLEGATI_DELIBERA.COD_PROTOCOLLO_PACCHETTO%TYPE)
   RETURN NUMBER;

END pkg_mcrei_web_util_delib;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_WEB_UTIL_DELIB FOR MCRE_OWN.PKG_MCREI_WEB_UTIL_DELIB;


CREATE SYNONYM MCRE_USR.PKG_MCREI_WEB_UTIL_DELIB FOR MCRE_OWN.PKG_MCREI_WEB_UTIL_DELIB;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_WEB_UTIL_DELIB TO MCRE_USR;

