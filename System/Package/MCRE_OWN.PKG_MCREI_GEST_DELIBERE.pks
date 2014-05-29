CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCREI_GEST_DELIBERE AS
  /******************************************************************************
   NAME:       PKG_MCREI_GEST_DELIBERE
   PURPOSE:

   REVISIONS:
   Ver        Date              Author             Description
   ---------  ----------      -----------------  ------------------------------------
   1.0      13/01/2012            L.Ferretti      Created this package.
   1.1      20/01/2012            M.Murro         variazioni varie.
   1.2      16/02/2012            M.Murro         fix ordinale delibera
   1.3      20/02/2012            M.Murro         modificato ordinale delibera
   1.4      02/04/2012            Gueorguieva     aggiunte funzioni di recupero dei valori per il calcolo OD
   1.5      13/04/2012            D'ERRICO        aggiunta funct per recupero last rinuncia contabilizzata
   1.6      05/06/2012            d'errico        gestione automatica viene generalizzata su tutte le proposte
   1.7      12/07/2012            d'errico        aggiunto no_Data_found per get_last_rinuncia
   1.8      18/07/2012            d'errico        gestita assenza uo nella creazione del protocollo delibera. restituisce -1
   1.9      26/07/2012            d'errico        creazione funzione rdv_light abilitata
   2.0      31/07/2012            d'errico        corretto popolamento dta_last_upd_delibera nella gest_classif_autom
   2.1      31/08/2012            d'errico        popolato anche campo dta_delibera in fase di creazione CI
   2.2      26/09/2012            M.Murro         fix controllo rdv_light_abilitata
   2.3      12/10/2012            d'errico        modificato commento in gestione  exception per rdv_abilitata
   2.4      08/11/2012            Gueorguieva     eliminata filtro fase delibera CM da fnc_mcrei_get_max_rdv e
                                                  fnc_mcrei_get_max_rdv_in
   2.5      09/11/2012            d'errico        tolto filtro su fase_Delibera = 'CO'
   3.0      12/11/2012            pellizzi        update cod_fase delibera e cod_fase_microtipologia
   3.1      13/12/2012            M.Murro         fix scarta_proposta, insert di abi-ndg-sndg
   3.2       7/01/2013             D'ERRICO      modificata sovrascrivi_proposta e inserita distinct su controllo fase_pacchetto nella gest_classif_autom
                                                              aggiunto flg_no_delibera = 0 e cod_Fase_Delibera !='AN' NELLA CTRL_ESIST_PACC_APERTO
   3.4    29/01/2013            i.gueorguieva aggiunta T_MCRE0_APP_ALL_DATA IN JOIN NELLA QUERY DI CREA_PACCEHTTO_CLASSIF_AUTO   PER ESTRAZIONE STATO E DECORRENZA STATO
   3.5      14/02/2013            D'ERRICO        CORRETTA fnc_gest_classif_autom per gestione annullamento pacchetti in attesa di conferma da banca rete in caso di arrivo di un incaglio automatico
   3.6      04/03/2013            M.Murro         Modifica gestione conferma di proposte automatiche
   3.7      20/03/2013            D'ERRICO        RIVISTA GESTIONE INCAGLI AUTOMATICI NELLA GEST_CLASSIF_AUTOM IN CASO SIA PRESENTE CI in fase (CA,CO) in un pacchetto gi? confermato
                                                    corretta sovrascrivi_proposta_esistente ,ponendo fase_Delibera= 'CA' e lasciando le altre fasi cos? com'erano gi? sulla tabella delibere
   3.8      07/05/2013           I.Gueorguieva    Fix prima update fnc_gest_classif_autom
   3.9      20/05/2013           IM.Murro         nuova Fix prima update fnc_gest_classif_autom
  ******************************************************************************/
  c_package CONSTANT VARCHAR2(50) := 'PKG_MCREI_GEST_DELIBERE';

  FUNCTION fnc_mcrei_protocollo_delibera(cod_uo IN VARCHAR2,
                                         utente IN VARCHAR2 DEFAULT NULL,
                                         p_abi  IN VARCHAR2 DEFAULT NULL,
                                         p_ndg  IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2;

  FUNCTION fnc_mcrei_ordinale_delibera(pratica   IN VARCHAR2,
                                       anno      IN NUMBER,
                                       utente    IN VARCHAR2 DEFAULT NULL,
                                       pacchetto IN VARCHAR2) RETURN NUMBER;

  FUNCTION fnc_mcrei_coll_pacchetto(p_cod_abi            IN t_mcrei_app_delibere.cod_abi%TYPE,
                                    p_cod_ndg            IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                    p_val_anno_proposta  IN t_mcrei_app_delibere.val_anno_proposta%TYPE,
                                    p_val_progr_proposta IN t_mcrei_app_delibere.val_progr_proposta%TYPE)
    RETURN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che verifica l'esistenza di un pacchetto non ancora confermato per l'abi, ndg e microtipologia in input
  -- %usage (da usare nella gestione automatica degli incagli)
  -- %d  La funzione, per l'abi, ndg, e microtipologia in input, verifica l'esistenza di un eventuale
  -- %d  pacchetto ancora aperto. Se esiste, ne restituisce il protocollo,in caso contrario
  -- %d  restituisce NULL
  -- %cd 7 nov 2011
  -- %param P_ABI ABI
  -- %param P_NDG: NDG
  -- %param P_MICROTIPOLOG microtipologia pacchetto
  FUNCTION ctrl_esist_pacc_aperto(p_abi          IN VARCHAR2,
                                  p_ndg          IN VARCHAR2,
                                  p_microtipolog IN VARCHAR2) RETURN VARCHAR2;

  -- %author Reply
  -- %version 0.1
  -- %usage  Function che gestisce le classificazioni a incaglio e a sofferenza AUTOMATICHE
  -- %d La function, in base al tipo di classificazione, effettua controlli sull'eventuale
  -- %d pacchetto presente nella tabella t_mcrei_App_delibere, contenente eventualmente una
  -- %d delibera di classificazione dello stesso tipo. A seguito dei controlli, gestisce
  -- %d le diverse casistiche.
  -- %cd 24/01/2012
  FUNCTION fnc_gest_classif_autom(p_iddper        NUMBER,
                                  p_cod_abi       VARCHAR2,
                                  p_tipo_proposta VARCHAR2) RETURN VARCHAR2;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che crea un pacchetto automatico in base al tipo di classificazione in input
  -- %d La funzione crea un pacchetto monotipologia/monodelibera in stato confermato
  -- %d importando i dati di una proposta ricevuta automaticamente
  -- %cd 26 gen 2012
  -- %param p_tipo_classif: E -> incaglio, S -> sofferenza
 FUNCTION crea_pacchetto_classif_auto(p_tipo_classif VARCHAR2,
                                       p_abi          VARCHAR2,
                                       p_ndg          VARCHAR2,
                                       p_periodo      NUMBER,
                                       V_PROTO_PAC  IN VARCHAR2 DEFAULT NULL) RETURN NUMBER;
  FUNCTION sovrascrivi_proposta_esistente(p_abi         VARCHAR2,
                                          p_ndg         VARCHAR2,
                                          p_proto_pac   VARCHAR2,
                                          p_microtipol  VARCHAR2,
                                          p_proto_delib VARCHAR2,
                                          p_iddper      NUMBER) RETURN NUMBER;

  FUNCTION scarta_proposta_automatica(p_progres_proposta NUMBER,
                                      p_anno_propost     NUMBER,
                                      p_idper            NUMBER,
                                      P_CODABI VARCHAR2,
                                      P_CODNDG VARCHAR2)
    RETURN NUMBER;

  -- FUNZIONE USATA DA VISTA V_MCREI_APP_INFO_PER_CALC_OD
  FUNCTION fnc_mcrei_get_max_rdv_in(v_cod_abi  IN VARCHAR2,
                                    v_cod_ndg  IN VARCHAR2,
                                    v_cod_fase IN VARCHAR2) RETURN NUMBER;

  -- FUNZIONE USATA DA VISTA V_MCREI_APP_INFO_PER_CALC_OD
  FUNCTION fnc_mcrei_get_max_rdv(v_cod_abi                  IN VARCHAR2,
                                 v_cod_ndg                  IN VARCHAR2,
                                 v_cod_fase                 IN VARCHAR2,
                                 v_cod_protocollo_pacchetto IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  -- FUNZIONE USATA DA VISTA V_MCREI_APP_INFO_PER_CALC_OD
  FUNCTION fnc_mcrei_get_sum_rin(v_cod_abi                  IN VARCHAR2,
                                 v_cod_ndg                  IN VARCHAR2,
                                 v_cod_fase                 IN VARCHAR2,
                                 v_cod_protocollo_pacchetto IN VARCHAR2)
    RETURN NUMBER;

  FUNCTION fnc_mcrei_get_sum_utilizzati(v_cod_abi VARCHAR2,
                                        v_cod_ndg VARCHAR2,
                                        v_cod_pac VARCHAR2) RETURN NUMBER;

  FUNCTION fnc_mcrei_get_last_rinuncia(p_abi      VARCHAR2,
                                       p_ndg      VARCHAR2,
                                       p_cod_fase IN VARCHAR2) RETURN NUMBER;

  FUNCTION fnc_mcrei_get_stralci_ct(p_abi VARCHAR2, p_ndg VARCHAR2)
    RETURN NUMBER;

  FUNCTION ctrl_esist_pacc_aperto_sndg(p_cod_sndg          IN VARCHAR2,
                                   p_microtipolog IN VARCHAR2) RETURN VARCHAR2;
 -- controlla se esiste una delibera di una determinata microtipologia
 -- Se esiste ritorna il protocollo pacchetto altrimenti NULL
 FUNCTION CNTRL_ESIST_DELIB(P_COD_ABI  IN VARCHAR2,
                            P_COD_NDG  IN VARCHAR2,
                            P_MICROTIP IN VARCHAR2,
                            P_PROTO_PACCHETTO   IN VARCHAR2) RETURN varchar2;
  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che, data la posizione (abi + ndg) o l'sndg in input, restituisce il flag di abilitazione o meno alla rdv light post-impianto
  -- %d Se p_sndg is not null, verifica se esiste almeno un ndg associato che presenti come ultima delibera un IM o IF. Se si, restituisce Y, altrimenti N
  -- %d Se p_ndg is not null, verifica se la posizione presenta come ultima delibera una IM o IF.Se si, restituisce Y, altrimenti N
  -- %cd 26 lug 2012
    FUNCTION RDV_LIGHT_ABILITATA(P_SNDG           IN VARCHAR2,
                                 P_ABI           IN VARCHAR2,
                                 P_NDG           IN VARCHAR2,
                                 P_COD_GRUPPO_SUPER IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

END pkg_mcrei_gest_delibere;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_GEST_DELIBERE FOR MCRE_OWN.PKG_MCREI_GEST_DELIBERE;


CREATE SYNONYM MCRE_USR.PKG_MCREI_GEST_DELIBERE FOR MCRE_OWN.PKG_MCREI_GEST_DELIBERE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_GEST_DELIBERE TO MCRE_USR;

