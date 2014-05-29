CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_GEST_CONFERIMENTI AS
  /******************************************************************************
  NAME:       PKG_MCRE0_MIG_NDG_RAP
  PURPOSE:

  REVISIONS:
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        22/06/2012  1.I.Gueorguieva  Created this package body.
  1.1        17/07/2012  M.Murro          estesa logica
  1.2        30/07/2012  d'errico         corretto popolamento mor5 e aggiunti campi nelle crea_delibere_impianto
  1.3        27/09/2012  d'errico         inserita decode del flg_recupero_tot per popolamento mor5_rap
  1.4        27/09/2012  I.Gueorguieva    corretta query di recupero_last_rdv_cedente
  1.5        27/09/2012  d'errico         corretto recupero_stime_ricevente
  2.0        04/10/2012  M.Murro          introdotte tabelle tmp e filtro stime su rapporti ancora attivi
  2.1        11/10/2012  M.Murro          fix calcolo fine gestione (mor5) e delib cedente
  2.2        23/10/2012  M.Murro          aggiunta dta_conferma su delibere impianto
  3.0        30/10/2012  M.Murro          calcolo esposizioni e rettifiche da Stime
  3.1        07/11/2012  M.Murro          limitato corsore a presa_visione 0
  3.2        19/11/2012  M.Murro          esposta Archivia Evento e Rimuovi Blocco
  ******************************************************************************/

  c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_GEST_CONFERIMENTI';
  ok NUMBER := 1;
  ko NUMBER := 0;
  c_caricata_st        CONSTANT VARCHAR2(45) := 'ST_CARICATA';
  c_caricata_app       CONSTANT VARCHAR2(45) := 'APP_CARICATA';
  c_calcolati_flg      CONSTANT VARCHAR2(45) := 'FLG_CALCOLATI';
  c_inizio_caricamento CONSTANT VARCHAR2(45) := 'INIZIO';

  -- %author
  -- %version 0.1
  -- %usage  Function che lancia il caricamnto e il calcolo flag
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %param NDG_OR_RAPP valori possibili: AFTABRAC_NDG  oppure AFTABRAC_RAPP
  -- %return ID_DPER --> successo CARICAMRNTO, 0 altrimenti
  -- %cd 29 GIU 2012
  FUNCTION fnc_exe_load(v_id_flusso IN NUMBER,
                        ndg_or_rapp IN VARCHAR2,
                        v_cod_abi   IN VARCHAR2) RETURN NUMBER;

  PROCEDURE recupera_last_rdv_conf(p_cod_abi        IN t_mcrei_app_delibere.cod_abi%TYPE,
                                   p_cod_ndg        IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                   v_last_rdv_cassa OUT t_mcrei_app_delibere.val_rdv_qc_progressiva%TYPE,
                                   v_last_rdv_firma OUT t_mcrei_app_delibere.val_rdv_progr_fi%TYPE);

  FUNCTION recupera_tipo_gestione(p_cod_abi  IN t_mcrei_app_delibere.cod_abi%TYPE,
                                  p_cod_ndg  IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                  p_tipo_pos IN t_mcre0_app_mig_recode_ndg.flg_condiviso%TYPE)
    RETURN VARCHAR2;

  PROCEDURE crea_delibera_impianto(p_new_cod_abi       IN VARCHAR2,
                                   p_new_cod_ndg       IN VARCHAR2,
                                   p_tipo_posiz        IN VARCHAR2,
                                   p_lista_abi_old     IN VARCHAR2,
                                   out_proto_delibera  OUT VARCHAR2,
                                   out_proto_pacchetto OUT VARCHAR2,
                                   out_esito           OUT NUMBER);
  PROCEDURE prc_calcola_lista_abi_old;

  PROCEDURE crea_delibera_impianto_cedente(p_new_cod_abi         IN VARCHAR2,
                                           p_new_cod_ndg         IN VARCHAR2,
                                           p_old_cod_abi         IN VARCHAR2,
                                           p_old_cod_ndg         IN VARCHAR2,
                                           p_tipo_posiz          IN VARCHAR2,
                                           out_proto_delibera    OUT VARCHAR2,
                                           out_proto_pacchetto   OUT VARCHAR2,
                                           out_esito             OUT NUMBER,
                                           out_proto_del_cedente OUT VARCHAR2); ---1 OK, 0 KO

  PROCEDURE recupera_last_rdv_cedente(p_cod_abi        IN t_mcrei_app_delibere.cod_abi%TYPE,
                                      p_cod_ndg        IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                      v_last_rdv_cassa OUT t_mcrei_app_delibere.val_rdv_qc_progressiva%TYPE,
                                      v_last_rdv_firma OUT t_mcrei_app_delibere.val_rdv_progr_fi%TYPE,
                                      v_delibera_rv    OUT t_mcrei_app_delibere.cod_protocollo_delibera%TYPE);

  FUNCTION clona_stime_cedente(p_cod_abi          VARCHAR2,
                               p_cod_ndg          VARCHAR2,
                               p_proto_delibera   VARCHAR2,
                               p_delibera_cedente VARCHAR2) RETURN NUMBER;

  FUNCTION annulla_delibere_ins_cedenti RETURN NUMBER;

  FUNCTION popola_tab_mig_mor5(p_abi       t_mcrei_app_delibere.cod_abi%TYPE,
                               p_ndg       t_mcrei_app_delibere.cod_ndg%TYPE,
                               p_proto_del t_mcrei_app_delibere.cod_protocollo_delibera%TYPE)
    RETURN NUMBER;

  FUNCTION popola_tab_mig_mor5_rate(p_abi       t_mcrei_app_delibere.cod_abi%TYPE,
                                    p_ndg       t_mcrei_app_delibere.cod_ndg%TYPE,
                                    p_proto_del t_mcrei_app_delibere.cod_protocollo_delibera%TYPE)
    RETURN NUMBER;

  FUNCTION popola_tab_mig_mor5_rapp(p_abi       t_mcrei_app_delibere.cod_abi%TYPE,
                                    p_ndg       t_mcrei_app_delibere.cod_ndg%TYPE,
                                    p_proto_del t_mcrei_app_delibere.cod_protocollo_delibera%TYPE)
    RETURN NUMBER;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE AGGIORNA I FLAG DI ESITO PER L'ALERT E/O PER LA TABELLA DEI CONFERIMENTI
  -- %D LA FUNCTION, SE P_FLG_ESITO SETTATO LO IMPOSTA SULLA TABELLA DEI CONFERIMENTI
  -- %D SE P_FLG_ALERT SETTATO LO IMPOSTA SULLA TABELLA DELL'ALERT DEI CONFERIMENTI
  -- %CD 13 JUL 2012
  FUNCTION setta_esito_conferimento(p_proto_pacchetto IN t_mcre0_mig_mor5.cod_protocollo_pacchetto%TYPE,
                                    p_proto_delibera  IN t_mcre0_mig_mor5.cod_protocollo_delibera%TYPE,
                                    p_cod_abi         IN t_mcre0_mig_mor5.cod_abi%TYPE,
                                    p_cod_ndg         IN t_mcre0_mig_mor5.cod_ndg%TYPE,
                                    p_flg_esito       IN t_mcre0_mig_mor5.flg_esito%TYPE DEFAULT NULL, --Valori possibili: [NULL, 'Y', 'N']
                                    p_flg_alert       IN NUMBER DEFAULT NULL --Valori possibili: [NULL, 0, 1, 2]
                                    ) RETURN NUMBER;

  FUNCTION recupera_stime_ricevente(p_cod_abi VARCHAR2, p_cod_ndg VARCHAR2)
    RETURN NUMBER;

  FUNCTION aggancia_stime(p_cod_abi        VARCHAR2,
                                  p_cod_ndg        VARCHAR2,
                                  p_proto_delibera VARCHAR2) RETURN NUMBER;

  FUNCTION aggancia_piani(p_cod_abi        VARCHAR2,
                                  p_cod_ndg        VARCHAR2,
                                  p_proto_delibera VARCHAR2) RETURN NUMBER;

  --v3.0
  FUNCTION aggiorna_delibera(p_cod_abi        VARCHAR2,
                                  p_cod_ndg        VARCHAR2,
                                  p_proto_delibera VARCHAR2) RETURN NUMBER;

  ----23 luglio
  PROCEDURE crea_rdv_light(p_new_cod_abi       IN VARCHAR2,
                           p_new_cod_ndg       IN VARCHAR2,
                           p_utente            IN VARCHAR2,
                           p_lista_abi_old     IN VARCHAR2,
                           out_proto_delibera  OUT VARCHAR2,
                           out_proto_pacchetto OUT VARCHAR2,
                           out_esito           OUT NUMBER);
  FUNCTION recupera_abi_cedenti RETURN NUMBER;
  FUNCTION calcolo_classe_ft RETURN NUMBER;

  FUNCTION archivia_evento RETURN NUMBER;

  FUNCTION rimuovi_blocco RETURN NUMBER;

  PROCEDURE main;

END pkg_mcre0_gest_conferimenti;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_GEST_CONFERIMENTI FOR MCRE_OWN.PKG_MCRE0_GEST_CONFERIMENTI;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_GEST_CONFERIMENTI FOR MCRE_OWN.PKG_MCRE0_GEST_CONFERIMENTI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GEST_CONFERIMENTI TO MCRE_USR;

