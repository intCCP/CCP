CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCREI_WEB_UTILITIES" IS
  /*
  Version       Date              Author             Description
  ---------  ----------      -----------------  ------------------------------------
    1.0        10/11/2011                           Created this package.
    1.1        22/12/2011       M.Murro             Fix Crea Pacchetto.
    1.2        10/01/2012       M.Murro             Crea Pacchetto, rdv pregressa se CS
    1.3        30/01/2012       M.Murro             fix su get_capogruppo (gestione no_delibera)
    1.4        31/01/2012       M.Murro             fix pareri e gestione flg_no_delibera
    1.5        03/02/2012       M.Murro             fix popola rapporti_proposte
    1.6        07/02/2012       D'Errico            aggiunto filtro NELLA CREA PACCHETTO E NELLA ctrl_esist_pacc_aperto ( esclude pacchetti annullati)
    1.7        08/02/2012       D'Errico            modificato popolamento VAL_NUM_PROGR_DELIBERA IN crea pacchetto per CS
    1.8        13/02/2012       M.Murro             aggiunta retrocedi_wf, aggiornato annulla_pacchetto
    2.0        14/02/2012       M.Murro , Irena     variata gestione Beni, fix CS, inclusa aggiorna-proposta
    2.1        14/02/2012       M.Murro             fix crea_pacchetto
    2.2        16/02/2012       M.Murro             fix popola_generica.. dtata con defaul null
    3.0        21/02/2012       M.Murro             variata logica crea-pacchetto e aggiungi-microtipol
    3.1        21/02/2012       M.Murro             integrata gestione Piani
    3.2        22/02/2012       M.Murro             variata gestione No_Delibera
    3.3        23/02/2012       M.Murro             variata gestione upd_data_delibera
    3.4        23/02/2012       D'Errico            reintrodotti no-delibera a 1, aggiungi_microt filtra per stato
    3.5        23/02/2012       M.Murro             fix inserisci stime, aggiorna data delibera, chechk su pcr_aggr
    3.61       27/02/2012       M.Murro             aggiornato popola pareri e seq pareri, popola coint
    3.7        28/02/2012       M.Murro             variata popola_cointestatari
    3.8        28/02/2012       D'Errico            aggiunto calcolo campi aggregati post inserimento rettifiche in popola_dett_rapp_rv
    3.9        28/02/2012       D'Errico            aggiunta procedure di creazione pacchetto batch
    4.0        07/03/2012       M.Murro             annulla pacchetto sbianca anche l'ID documenti
    4.1        07/03/2012       D'Errico            aggiunto su crea pacchetto filtro fase != 'AN'
    4.2        07/03/2012       M.Murro             aggiornato popola dati banca rete
    4.3        15/03/2012       M.Murro             aggiunta gestione prot.delibera precedente
    4.4        15/03/2012       D'Errico            aggiunta creazione pacchetto extra delibera
    4.5        19/03/2012       D'Errico            modificato salvataggio in delibere nella popola_dett_Rapp_rv
    4.6        20/03/2012       D'Errico            modificata popola pareri con decode su tipo_parere
    4.7        20/03/2012       M.Murro             modificata calcola_od
    5.0        20/03/2012       M.Murro             aggiungi microtipologia retrocede wf se pacchetto non in stato INS
    5.1.       22/03/2012       M.Murro             aggiunta aggiungi_microtipologia_act
    5.2        23/03/2012       M.Murro             fix popola_rapporti_proposte e recupero ante delibera
    5.3        26/03/2012       M.Murro             estesa POPOLA_DATI_OUT_OD, gestione delibere CH
    5.4        27/03/2012       D'Errico            modificata gestione rinunce in popola dati delibere generiche
    5.5        27/03/2012       D'Errico            AGGIUNTO SALVATAGGIO CAMPI DA STIME A DELIBERE NELLA POPOLA_MAN_DETT_RAPP_RV
    5.5        28/03/2012       M.Murro             valori pregressi, filtro per fase CO o AD, inizializzo anche post
    5.6        28/03/2012       D'Errico            modificato calcolo esposizione netta post delibera in popola_man_dett_rapp_rv
    5.7        02/04/2012       D'Errico            modificato RECUPERO VALORI PREGRESSI DI FIRMA
    5.8.       03/04/2012       D'Errico            modificato RECUPERO LAST_RDV_PROGRESSIVA eliminando filtro su dta_conferma perch? spesso nulla
    5.9        05/04/2012       M.Murro             aggionto filtro no_delibera legato a stato (10.4 - commentato)
    6.0        11/04/2012       M.Murro             aggiunto recupero e propagazione val_imp_perdita + CT
    6.1        16/04/2012       D'Errico            modificata creazione protocollo delibera in crea pacchetto batch
    6.2        17/04/2012       D'ERRICO            aggiunto proto pacchetto in merge popola_elenco_pareri
    6.3        18/04/2012       M.Murro             fix pacchetto batch (upd)
    6.4        23/04/2012       d'errico            aggiunto filtro su flg_no_delibera in query di recupero valori pregressi
    6.5        23/04/2012       d'errico            aggiunto campo p_ftecnica al popolamento dei rapporti_rv
    6.6        24/04/2012       d'errico            aggiunta fase delibera NA nel recupero dei valori pregressi
    6.7        30/04/2012       E.Pelizzi, Irena    aggiunte funzioni di gestione Ristrutturazioni
    6.8        03/05/2012       M.Murro             estensione Beni Proposte
    6.9        03/05/2012       d'errico            aggiunta gestione archivizione stime e piani in caso di rivalutazione rapporti
    6.10       04/05/2012       d'errico            aggiunto flg_archiviazione in funct elimina_piano_rientro
    6.11       07/05/2012       d'errico            modificata update di aggionramento valori aggregati nelle delibere
    6.12       07/05/2012       d'errico            corretto recupero val_accordato_delib in popola_dett_Rapp_rv
    6.13       08/05/2012       Murro               Merge per gestione archivia stime
    6.14       09/05/2012       I.Gueorguieva       Gestione ristrutturazioni anche a livello di delibera
    6.15       09/05/2012       d'errico            modificato calcolo esp_netta_ante_delibera e post_delibera in fase di creazione nuova delibera
                                                  modificata elimina_piano_rientro
                                                  modificato calcolo rdv_deliberata (variazione) salvato come aggregato nella delibera post-stima
    6.16       11/05/2012       d'errico            aggiunta gestione fase NA nel cambio_fase_Delibera
                                                  aggiunta decode su fase CT nel recupero dei valori pregressi
    6.17       21/05/2012       D'ERRICO            modificata retrocedi_wf_pacchetto per gestione delib automatiche
    6.18       22/05/2012       d'errico            modificata popola_dati_contabili con dta_scadenza_incaglio
    6.19       22/05/2012       d'errico            aggiunta gestione microtipologia CZ nelle funct che gestiscono CS
    6.20       25/05/2012       d'errico            aggiunto aggiornamento dta_Stima nella popola_Dett_rapp_rv
    6.21       28/05/2012       d'errico..          eliminato dta_last_upd_delibera dall'ordinamento per il recupero dei valori pregressi
    6.22       30/05/2012       Murro               flg per non spalmare i pareri di proroga anche per capogruppo
    6.23       31/05/2012       d'errico..          modificata popola_Dett_rapp_rv con utilizzo forma_Tecnica nel recupero dell'utilizzato da salvare
    6.24       05/06/2012       d'errico..          aggiunto settaggio desc_tipo_Gestione
    6.25       07/06/2012       d'errico            aggiunta funct chiudi_ristrutturazione
    6.26       07/06/2012       d'errico            aggiunto popolamento campi esp cassa, firma in tutte le funzioni in cui presenti
    6.27       11/06/2012       d'errico            aggiunto popolamento motivo_prev_recupero nella popola_man_dett_rapp_rv
    6.28       15/06/2012       d'errico            aggiunto popolamento val_Esp_netta_post_delib nella popola_dett_delib_generiche
    6.29       18/06/2012       I.Gueorguieva       aggiunte duplica_rapporti_ristr e setta_flg_rapp_ristr_chiusura
    6.30       20/06/2012       d'errico            corretto popolamento esposizione in popola_man_del_chiusura e in popola_del_chiusura
    6.31       21/06/2012       I.Gueorguieva       popolamento date conferma e organo_pacchetto di aggiungi_microtipologia_ct
    6.32       21/06/2012       M.Murro             inizializzazione dati di ristrutturazione su setta_flg_ristr
    6.33       27/06/2012       M.Murro             inizializzazione dati CH (rdv progr a 0)
    6.34       02/07/2012       d'errico            aggiunto popolamento data conferma in aggiungi_microtipologia_ct
                                                  aggiunto calcolo perc_rdv in popola_man_dett_Rapp_rv e e popola_dett_rapporti_rv
                                                  spostato salvataggio stralcio nella aggiungi_microtipologia
    6.35       04/07/2012       d'errico/I.Gueorguieva eliminato scrittura in hst_ristrutturazioni nella popola_man_dett_ristr
                                                  aggiunto recupero campi di ristrutturazione (se esistenti) nella crea pacchetto e nell'aggiungi_microtipologia
    6.36       06/07/2012       I.Gueorguieva       gestione hst_ristrutturazioni per protocollo_pacchetto, modificata
    6.37       12/07/2012       d'errico            aggiunto salvataggio della percentuale di rinuncia nelle popola_man e popola_dett delib transaz nel campo val_perc_perd_rm
    6.38       13/07/2012       d'errico            eliminato salvataggio date efficacia in popolamento manuale delle ristrutturazioni
    6.39       16/07/2012       I.Gueorguieva       modificato logica salvataggio di chiusura ristrutturazione: popola_man_dett_del_ch_ristr, popola_dett_del_ch_ristr, chiudi_ristrutturazione, setta_flg_rapp_ristr
    6.40       18/07/2012       d'errico            modificate crea pacchetto e aggiungi microtipologia per non creare delibera in caso di mancanza UO per la posizione
    6.41       20/07/2012       d'errico            gestita divisione per 0 nel calcolo perc_rdv_su popola_man_dett_rapp_rv e e nella popola_dett_Rapp_rv
    6.42       26/07/2012       d'errico            aggiunto salvataggio del P_FLG_FORZ_IMP per le rdv light successive a delibera di impianto IM o IF
    6.43       08/08/2012       M.Murro             aggiunta valorizzazione del campo val_imp_perdita oltre che val_rinuncia_deliberata
    6.44       21/08/2012       d'errico            sostituito cod_stato_post_ristr nella chiudi ristrutturazione
    6.45       23/08/2012       d'errico            in fase di creazione delibera si popola campo val_stralcio_senza_accantonam con somma di stralci precedentemente contabilizzati per la posizione corrente
    6.46       25/09/2012       d'errico            corretta popola_man_dett_rapp_ristr per gestione rapporti con doppia FT su pcr
    6.47       28/09/2012       i.gueorguieva       aggiunto popolamento t_mcrei_hst_rapp_ristr.cod_npe nella popola_dett_rapp_ristr
    6.48       02/10/2012       d'errico            modificato recupero valori di utilizzato nella popola_dett_delib_transaz, includendo fase_delibera cm
    6.49       02/10/2012       d'errico            aggiunto trascinamento dell'organo_deliberante nella aggiungi_microtipologia_ct
    6.50       03/10/2012       i.gueorguieva       fix chiamata popola_man_dett_rapp_ristr da parte di popola_dett_rapp_ristr, con p_salv_or_conf = 'C'
    6.51       17/10/2012       d'errico            corretta popola_dett_dati_gen_rv, aggiunti campi ed eliminato erroneo popolamento rv banca rete
    6.52       31/10/2012       i.gueorguieva       fix chiamata popola_man_dett_ristr  da parte di popola_dett_ristr, con parametro p_salv_or_conf = 'C'
    6.53       14/11/2012       i.gueorguieva       popola_dati_banca_rete popolamento dta_last_upd_delibera con sysdate
    6.54       15/11/2012       i.gueorguieva       crea_pacchetto e aggiungi_microtipologia creano delibere con flg_no_delibera per le posizioni di area o regione non assegnate al gestore corrente (o quello per cui si sta operando)
    6.55       22/11/2012       d'errico            aggiunto salvataggio dta_Scadenza in fase di conferma di una rv (popola_dett_Rapp_rv) E IN CAMBIA_FASE_dELIBERA
    6.56       09/01/2013       d'errico            corretto salvataggio data scadenza_incaglio per CI. Tolto dalla popo_dati_contabili e gestito nella cambia_FasE_delibere
    6.57       09/01/2013       M.Murro             logging id documenti in update_id_doc
    6.58        09/01/2013      d'errico            modifica rimuovi_microtipologia e rimuovi_pacchetto: sostituita delete con update settando fasi come annullate manualmente
    6.59       21/01/2013       gueorguieva         crea_pacchetto e aggiungi_microtipologia creano delibere con flg_no_delibera per le posizioni di area o regione ripristina
    6.60       31/01/2013       georguieva          modificata cambia_fase_delibera per salvare cod_Stato_posiz e dta_dec_Stato_posiz in fase dei conferma delibera
    6.61       01/02/2013       georgiieva          modificata cambia_fase_delibera e aggiungi microtipologia con filtro nel cursore posizioni su comparto non nullo e diverso da #
    6.62       07/02/2013       d'errico            corretto calcolo perc_rinuncia in popola_dett_delib_transaz.Eliminato calcolo perc_rinuncia dal popola_man_dett_delib_transaz
    6.63       15/02/2012       i.gueorguieva       cambia_fase_delibera popolamento dta_scadenza_perm_servizio su t_mcrei_app_posiz_inc_ri
    6.64       1/03/2012        d'errico            aggiunto salvataggio mora sulle stime nella popola_man_dett_rapp_rv (per l'extra_delibera)
    6.65       5/03/2012        d'errico            aggiunta gestione spalamatura data scadenza per le progohe incaglio delle divisioni nelle popola_delib_generiche e popola_man_delib_generiche
    6.66       7/03/2013        d'errico            aggiunto popolamento cod_stato_post_ristr in popola_man_dett_Ristr
    6.67       7/03/2013        d'errico            corretta gestione v_scadenza_stato per CI e CS nel cambia fase delibera
    7.0        13/03/2013       M.Murro             fix crea pacchetto (filtro lfg_active=1 e ricerca stato (nullif se -1), pacchetto_batch(protocollo), ordinamento last rv
    7.1        21/03/2013       d'errico            CORRETTO salvataggio mora E UTILIZZATO sulle stime nella popola_man_dett_rapp_rv (per l'extra_delibera)
    7.2        02/04/2013       gueorguieva         aggiunto popolamento campi storici delibere in crea_pacchetto_batch e cambia_fase_delibera
    7.3        15/04/2013       d'errico            CORRETTO popolamento dta_creaz_pacchetto in aggiungi_microtipologia
    7.5        13/05/2013       M.Murro             CR: testati anche i derivati x flg_no_delibera in creazione CI
    8.0        05/08/2013       M.Murro             CR Proroghe Incagli - gestione dta_scadenza
    8.1        23/09/2013       M.Murro             Fix cambia fase delibera pr, pd, pt
    8.2        02/10/2013       T.Bernardi          estensione popola rischi
    8.3        29/10/2013       M.Murro             Fix protocollo nullo
    8.4        28/11/2013       M.Murro             fix flg_no_delibera a 0 per  'PR', 'PS', 'PU'
    8.5        11/12/2013       M.Murro             fix cambia-fase_delibera per scadenza incaglio
    8.6        20/12/2013       M.Murro/M.Ceru      popolamento campo desc_no_delibera nella crea_pacchetto e aggiungi_microtipologia
    8.7        20/01/2014       T.Bernardi          modifica di RIMUOVI MICROTIPOLOGIA,ANNULLA PACCHETTO per aggiunta campi delibere annullate
    8.8        21/03/2014       T.Bernardi          aggiunto campo cod_gruppo_super per estensione alle DR e modifica alla calcola_od con p_abi=p_abi_rif
    8.9        14/05/2014       M.Ceru              fix per variazione perimetro DR, aggiunto parametro p_abi_riferimento alla conferma_od
    9.0        17/06/2014       M.Murro             aggiunto FLG_POSIZ_DA_CEDERE in Crea_Pacchetto_batch
    9.1        27/06/2014       T.Bernardi          aggiunto p_doc_classif_mci a UPDATE_ID_DOCUMENTI,RETROCEDI_WF_PACCHETTO, ANNULLA_PACCHETTO 
*/
  /**********************************************************************************/
  /*                                COSTANTI                                        */
  /**********************************************************************************/
  const_first_date       CONSTANT DATE := to_date('01/01/0001',
                                                  'dd/mm/yyyy');
  const_last_date        CONSTANT DATE := to_date('31/12/9999',
                                                  'dd/mm/yyyy');
  const_esito_ok         CONSTANT NUMBER := 1;
  const_esito_ko         CONSTANT NUMBER := 0;
  const_pacch_confermato CONSTANT VARCHAR2(5) := 'CNF';
  const_delib_confermata CONSTANT VARCHAR2(5) := 'CO';
  c_package VARCHAR2(30) := 'PKG_MCREI_WEB_UTILITIES';

  -- ======================== gestione CLASSIFICAZIONI ============================================

  --Dentro ogni gestione microtipologia
  FUNCTION popola_dati_generali(p_proto_pacchetto             IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                p_proto_delibera              IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                p_cod_abi                     IN t_mcrei_app_delibere.cod_abi%TYPE,
                                p_cod_ndg                     IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                p_cod_stato_proposto          IN t_mcrei_app_delibere.cod_stato_proposto%TYPE,
                                p_cod_organo_deliberante      IN t_mcrei_app_delibere.cod_organo_deliberante%TYPE,
                                p_cod_stato_provenienza       IN t_mcrei_app_delibere.cod_stato_provenienza%TYPE,
                                p_dta_accensione_prop_rischio IN t_mcrei_app_delibere.dta_accensione_prop_rischio%TYPE,
                                p_desc_tipo_gestione          IN t_mcrei_app_delibere.desc_tipo_gestione%TYPE,
                                p_dta_ins_delibera            IN t_mcrei_app_delibere.dta_ins_delibera%TYPE,
                                p_cod_uo_proponente           IN t_mcrei_app_delibere.cod_uo_proponente%TYPE,
                                p_cod_matricola_inserente     IN t_mcrei_app_delibere.cod_matricola_inserente%TYPE,
                                p_dta_inizio_rapporto_cliente IN t_mcrei_app_delibere.dta_inizio_rapporto_cliente%TYPE,
                                p_desc_motivo_pass_rischio    IN t_mcrei_app_delibere.desc_motivo_pass_rischio%TYPE,
                                p_flg_interven_organi_sup     IN t_mcrei_app_delibere.flg_interven_organi_superiori%TYPE,
                                p_dta_revoca_fido_in_essere   IN t_mcrei_app_delibere.dta_revoca_fido_in_essere%TYPE,
                                p_val_rischiindiretti         IN t_mcrei_app_delibere.val_rischi_indiretti%TYPE,
                                p_flg_depositi_collaterali    IN t_mcrei_app_delibere.flg_depositi_collaterali%TYPE,
                                p_val_uti_tot_scgb            IN t_mcrei_app_delibere.val_uti_tot_scsb%TYPE,
                                p_flg_affidam_soc_recupero    IN t_mcrei_app_delibere.flg_affidam_soc_recupero%TYPE,
                                p_flg_soggetto_pot_fallibile  IN t_mcrei_app_delibere.flg_soggetto_pot_fallibile%TYPE,
                                p_flg_presen_covenants        IN t_mcrei_app_delibere.flg_presen_covenants%TYPE,
                                p_val_uti_tot_gegb            IN t_mcrei_app_delibere.val_uti_tot_gegb%TYPE,
                                p_cod_sag                     IN t_mcrei_app_delibere.cod_sag%TYPE,
                                p_cod_stato_sag               IN t_mcrei_app_delibere.cod_stato_sag%TYPE,
                                p_dta_calc_conf_sag           IN t_mcrei_app_delibere.dta_calc_conf_sag%TYPE,
                                p_desc_modal_conferma_sag     IN t_mcrei_app_delibere.desc_modal_conferma_sag%TYPE,
                                p_dta_last_delibera_fido      IN t_mcrei_app_delibere.dta_last_delibera_fido%TYPE,
                                p_cod_last_organo_delib_fido  IN t_mcrei_app_delibere.cod_last_organo_delib_fido%TYPE)
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che SALVA i dati GENERALI inseriti manualmente di una delibera di classificazione
  -- %d La function, per ogni protocollo di delibera in input, aggiorna gli attributi presenti
  -- %d nella tabella delibere relativamente alla sezione "dati generali" della delibera di
  -- %d classificazione
  -- %cd 4 GEN 2012
  FUNCTION popola_man_dati_generali(p_proto_pacchetto            IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                    p_proto_delibera             IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                    p_cod_abi                    IN t_mcrei_app_delibere.cod_abi%TYPE,
                                    p_cod_ndg                    IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                    p_desc_motivo_pass_rischio   IN t_mcrei_app_delibere.desc_motivo_pass_rischio%TYPE,
                                    p_dta_motivo_pass_rischio    IN t_mcrei_app_delibere.dta_motivo_pass_rischio%TYPE,
                                    p_flg_interven_organi_sup    IN t_mcrei_app_delibere.flg_interven_organi_superiori%TYPE,
                                    p_flg_depositi_collaterali   IN t_mcrei_app_delibere.flg_depositi_collaterali%TYPE,
                                    p_flg_soggetto_pot_fallibile IN t_mcrei_app_delibere.flg_soggetto_pot_fallibile%TYPE,
                                    p_flg_presen_covenants       IN t_mcrei_app_delibere.flg_presen_covenants%TYPE)
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che SALVA la percentuale di dubbio esito di una delibera di classificazione
  -- %d La function, per ogni protocollo di delibera in input, aggiorna la percentuale di dubbio esito
  -- %d nella tabella delibere relativamente alla sezione "dati contabili" della delibera di
  -- %d classificazione
  -- %cd 9 DEC 201?1
  FUNCTION popola_dati_contabili(p_proto_pacchetto           IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                 p_proto_delibera            IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                 p_cod_abi                   IN t_mcrei_app_delibere.cod_abi%TYPE,
                                 p_cod_ndg                   IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                 p_dta_rif_dati_contabili    IN t_mcrei_app_delibere.dta_rif_dati_contabili%TYPE,
                                 p_val_perc_dubbio_esito     IN t_mcrei_app_delibere.val_perc_dubbio_esito%TYPE,
                                 p_dta_scadenza              IN t_mcrei_app_delibere.dta_scadenza%TYPE,
                                 p_val_accordato             IN t_mcrei_app_delibere.val_accordato%TYPE,
                                 p_val_esp_lorda             IN t_mcrei_app_delibere.val_esp_lorda%TYPE,
                                 p_val_fondo_terzi           IN t_mcrei_app_delibere.flg_fondo_terzi%TYPE,
                                 p_val_uti_netto_fondo_terzi IN t_mcrei_app_delibere.val_uti_netto_fondo_terzi%TYPE,
                                 p_val_uti_firma_scsb        IN t_mcrei_app_delibere.val_uti_firma_scsb%TYPE,
                                 p_val_uti_sosti_scsb        IN t_mcrei_app_delibere.val_uti_sosti_scsb%TYPE,
                                 p_val_esp_lorda_capitale    IN t_mcrei_app_delibere.val_esp_lorda_capitale%TYPE,
                                 p_val_esp_lorda_mora        IN t_mcrei_app_delibere.val_esp_lorda_mora%TYPE)
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che SALVA i dati CONTABILI di una delibera di classificazione
  -- %d La function, per ogni protocollo di delibera in input, aggiorna gli attributi presenti
  -- %d nella tabella delibere relativamente alla sezione "dati contabili" della delibera di
  -- %d classificazione
  -- %cd 4 GEN 2012
  FUNCTION popola_man_dati_contabili(p_proto_pacchetto       IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                     p_proto_delibera        IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                     p_cod_abi               IN t_mcrei_app_delibere.cod_abi%TYPE,
                                     P_COD_NDG               IN T_MCREI_APP_DELIBERE.COD_NDG%TYPE,
                                     P_VAL_PERC_DUBBIO_ESITO IN T_MCREI_APP_DELIBERE.VAL_PERC_DUBBIO_ESITO%TYPE,
                                     p_dta_scad              IN T_MCREI_APP_DELIBERE.DTA_SCADENZA%TYPE DEFAULT NULL)
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  function che SALVA i dati RELATIVI AI RAPPORTI AL MOMENTO DELLA CLASSIFICAZIONE
  -- %d La function, per ogni protocollo di delibera in input, aggiorna gli attributi presenti
  -- %d nella tabella rapporti_proposte relativamente allE sezionI "LISTE RAPPORTI" della delibera di
  -- %d classificazione
  -- %cd 13 DEC 2011
  FUNCTION popola_rapporti_proposte(p_proto_pacchetto    IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                    p_proto_delibera     IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                    p_cod_abi            IN t_mcrei_app_delibere.cod_abi%TYPE,
                                    p_cod_ndg            IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                    p_codice_rapporto    IN t_mcrei_app_rapporti_proposte.cod_rapporto%TYPE,
                                    p_cod_forma_tecnica  IN t_mcrei_app_pcr_rapporti.cod_forma_tecnica%TYPE,
                                    p_desc_forma_tecnica IN t_mcrei_app_rapporti_proposte.desc_forma_tecnica_rp%TYPE,
                                    p_natura             IN t_mcrei_app_rapporti_proposte.cod_natura%TYPE,
                                    p_accordato          IN t_mcrei_app_rapporti_proposte.val_accordato_rp%TYPE,
                                    p_utilizzato         IN t_mcrei_app_rapporti_proposte.val_utilizzato_rp%TYPE,
                                    p_di_cui_capitale    IN t_mcrei_app_rapporti_proposte.val_esp_quota_capitale_rp%TYPE,
                                    p_di_cui_mora        IN t_mcrei_app_rapporti_proposte.val_interessi%TYPE,
                                    p_num_rate_impagate  IN t_mcrei_app_rapporti_proposte.val_importo_tot_rate_impagate%TYPE,
                                    p_debito_residuo     IN t_mcrei_app_rapporti_proposte.val_debito_residuo%TYPE,
                                    p_classe_ft          IN t_mcrei_app_rapporti_proposte.cod_classe_ft%TYPE)
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage  Function che SALVA i dati delle GARANZIE, in GARANZIE_PROPOSTE, relativi alla PROPOSTA/DELIBERA,
  -- %usage  individata dagli argomenti passati.
  -- %d La function, per ogni protocollo di delibera in input cerca, se e' gia presente una GARANZIA.
  -- %d Se viene trovata una corrispondenza vengono aggiornati i dati della GARANZIA,
  -- %d altrimenti viene inserita una nuova garanzia assocciata al protocollo di delibera.
  -- %param p_abi ABI
  -- %param p_ndg NDG
  -- %param p_proto_delib protocollo di delibera
  -- %param p_proto_pacch protocollo di pacchetto
  -- %param p_note_garanzie note integrative garanzie
  -- %cd 11 GEN 2012
  FUNCTION popola_garanzie_proposte(p_abi            IN t_mcrei_app_garanzie_proposte.cod_abi%TYPE,
                                    p_ndg            IN t_mcrei_app_garanzie_proposte.cod_ndg%TYPE,
                                    p_proto_delib    IN t_mcrei_app_garanzie_proposte.cod_protocollo_delibera%TYPE,
                                    p_proto_pacch    IN t_mcrei_app_garanzie_proposte.cod_protocollo_pacchetto%TYPE,
                                    p_note_gar_ric   IN t_mcrei_app_delibere.desc_note_garanzie_ricevute%TYPE,
                                    p_note_gar_prest IN t_mcrei_app_delibere.desc_note_garanzie_prestate%TYPE)
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage function che SALVA i campi delle proposte inseriti manulamente
  -- %d La function, per ogni protocollo di delibera in input, aggiorna gli attributi presenti
  -- %d nella tabella delibere relativamente alle sezioni "Rischi", "Urgenze",
  -- %d "Cause mantenimenti impieghi vivi" e
  -- %d "Riferimenti pratica della delibera di classificazione" delle proposte
  -- %cd 28 DEC 2011
  FUNCTION popola_man_ri_urg_cau_rif(p_proto_pacchetto              IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                     p_proto_delibera               IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                     p_cod_abi                      IN t_mcrei_app_delibere.cod_abi%TYPE,
                                     p_cod_ndg                      IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                     p_dta_udienza_ver_cred         IN t_mcrei_app_delibere.dta_udienza_ver_cred%TYPE,
                                     p_flg_esist_deb_sotto_proc     IN t_mcrei_app_delibere.flg_esist_debitore_sotto_proc%TYPE,
                                     p_flg_beni_non_in_garanzia     IN t_mcrei_app_delibere.flg_beni_non_in_garanzia%TYPE,
                                     p_flg_avviso_ex498cpc          IN t_mcrei_app_delibere.flg_avviso_ex498cpc%TYPE,
                                     p_flg_pignoramenti_immobiliari IN t_mcrei_app_delibere.flg_pignoramenti_immobiliari%TYPE,
                                     p_flg_pignoramenti_mobiliari   IN t_mcrei_app_delibere.flg_pignoramenti_mobiliari%TYPE,
                                     p_flg_pignoramenti_terzi       IN t_mcrei_app_delibere.flg_pignoramenti_terzi%TYPE,
                                     p_flg_protesti                 IN t_mcrei_app_delibere.flg_protesti%TYPE,
                                     p_flg_ipoteche_beni_deb_gar    IN t_mcrei_app_delibere.flg_ipoteche_beni_deb_gar%TYPE,
                                     p_flg_garanzie_sgfa            IN t_mcrei_app_delibere.flg_garanzie_sgfa%TYPE,
                                     p_flg_garanzie_sace            IN t_mcrei_app_delibere.flg_garanzie_sace%TYPE,
                                     p_flg_garanzie_con_fidi        IN t_mcrei_app_delibere.flg_garanzie_con_fidi%TYPE,
                                     p_flg_garanzie_genworth        IN t_mcrei_app_delibere.flg_garanzie_genworth%TYPE,
                                     p_flg_pratica_urg              IN t_mcrei_app_delibere.flg_pratica_urg%TYPE,
                                     p_desc_note_urg                IN t_mcrei_app_delibere.desc_note_urg%TYPE,
                                     p_flg_forz_man_gest_interna    IN t_mcrei_app_delibere.flg_forz_man_gest_interna%TYPE,
                                     p_desc_note_forzatura          IN t_mcrei_app_delibere.desc_note_forzatura%TYPE,
                                     p_flg_libretti_port_min        IN t_mcrei_app_delibere.flg_libretti_portatore_minori%TYPE,
                                     p_flg_rap_con_depos_titoli     IN t_mcrei_app_delibere.flg_rapporti_con_depos_titoli%TYPE,
                                     p_flg_rapporti_bloccati        IN t_mcrei_app_delibere.flg_rapporti_bloccati%TYPE,
                                     p_flg_rap_garanzia_cred_fir    IN t_mcrei_app_delibere.flg_rapporti_garanzia_cred_fir%TYPE,
                                     p_flg_rap_concordato_preven    IN t_mcrei_app_delibere.flg_rapporto_concordato_preven%TYPE,
                                     p_flg_conti_categ_2000         IN t_mcrei_app_delibere.flg_conti_categ_2000%TYPE,
                                     p_num_telefono                 IN t_mcrei_app_delibere.num_telefono%TYPE,
                                     p_indirizzo_email              IN t_mcrei_app_delibere.indirizzo_email%TYPE,
                                     p_desc_secondo_referente       IN t_mcrei_app_delibere.desc_secondo_referente%TYPE,
                                     p_num_tel_secondo_referente    IN t_mcrei_app_delibere.num_tel_secondo_referente%TYPE,
                                     p_desc_note_rischi             IN t_mcrei_app_delibere.desc_note_rischi%TYPE,
                                     p_cod_sag                      IN t_mcrei_app_delibere.cod_sag%TYPE,
                                     p_cod_stato_sag                IN t_mcrei_app_delibere.cod_stato_sag%TYPE,
                                     p_dta_calc_conf_sag            IN t_mcrei_app_delibere.dta_calc_conf_sag%TYPE,
                                     p_desc_modal_conferma_sag      IN t_mcrei_app_delibere.desc_modal_conferma_sag%TYPE,
                                     p_dta_last_delibera_fido       IN t_mcrei_app_delibere.dta_last_delibera_fido%TYPE,
                                     p_cod_last_organo_delib_fido   IN t_mcrei_app_delibere.cod_last_organo_delib_fido%TYPE)
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage function che SALVA i campi delle delibere inseriti manulamente
  -- %d La function, per ogni protocollo pacchetto in input, aggiorna gli attributi presenti
  -- %d nella tabella delibere relativamente alla sezione "Rischi"
  -- %cd 4 GEN 2012
  --v8.2 estesa
  FUNCTION popola_man_rischi(p_proto_pacchetto   IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                             P_PROTO_DELIBERA    IN T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA%TYPE,
                             P_COD_ABI           IN T_MCREI_APP_DELIBERE.COD_ABI%TYPE,
                             P_COD_NDG           IN T_MCREI_APP_DELIBERE.COD_NDG%TYPE,
                             P_DESC_NOTE_RISCHI  IN T_MCREI_APP_DELIBERE.DESC_NOTE_RISCHI%TYPE,
                             P_COD_MOTIV_INSOLV  IN T_MCREI_APP_DELIBERE.COD_MOTIV_INSOLV%TYPE DEFAULT NULL,
                             P_COD_INFO_TERZI    IN T_MCREI_APP_DELIBERE.COD_INFO_TERZI%TYPE DEFAULT NULL,
                             P_COD_PORTAF_SCAD   IN T_MCREI_APP_DELIBERE.COD_PORTAF_SCAD%TYPE DEFAULT NULL,
                             P_COD_TIPO_CESSIONE IN T_MCREI_APP_DELIBERE.COD_TIPO_CESSIONE%TYPE DEFAULT NULL
                             )
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage function che SALVA i campi delle delibere inseriti manulamente
  -- %d La function, per ogni protocollo pacchetto in input, aggiorna gli attributi presenti
  -- %d nella tabella delibere relativamente alla sezione "Urgenze"
  -- %cd 4 GEN 2012
  FUNCTION popola_man_urgenze(p_proto_pacchetto              IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                              p_proto_delibera               IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                              p_cod_abi                      IN t_mcrei_app_delibere.cod_abi%TYPE,
                              p_cod_ndg                      IN t_mcrei_app_delibere.cod_ndg%TYPE,
                              p_dta_udienza_ver_cred         IN t_mcrei_app_delibere.dta_udienza_ver_cred%TYPE,
                              p_flg_esist_deb_sotto_proc     IN t_mcrei_app_delibere.flg_esist_debitore_sotto_proc%TYPE,
                              p_flg_beni_non_in_garanzia     IN t_mcrei_app_delibere.flg_beni_non_in_garanzia%TYPE,
                              p_flg_avviso_ex498cpc          IN t_mcrei_app_delibere.flg_avviso_ex498cpc%TYPE,
                              p_flg_pignoramenti_immobiliari IN t_mcrei_app_delibere.flg_pignoramenti_immobiliari%TYPE,
                              p_flg_pignoramenti_mobiliari   IN t_mcrei_app_delibere.flg_pignoramenti_mobiliari%TYPE,
                              p_flg_pignoramenti_terzi       IN t_mcrei_app_delibere.flg_pignoramenti_terzi%TYPE,
                              p_flg_protesti                 IN t_mcrei_app_delibere.flg_protesti%TYPE,
                              p_flg_ipoteche_beni_deb_gar    IN t_mcrei_app_delibere.flg_ipoteche_beni_deb_gar%TYPE,
                              p_flg_garanzie_sgfa            IN t_mcrei_app_delibere.flg_garanzie_sgfa%TYPE,
                              p_flg_garanzie_sace            IN t_mcrei_app_delibere.flg_garanzie_sace%TYPE,
                              p_flg_garanzie_con_fidi        IN t_mcrei_app_delibere.flg_garanzie_con_fidi%TYPE,
                              p_flg_garanzie_genworth        IN t_mcrei_app_delibere.flg_garanzie_genworth%TYPE,
                              p_flg_pratica_urg              IN t_mcrei_app_delibere.flg_pratica_urg%TYPE,
                              p_desc_note_urg                IN t_mcrei_app_delibere.desc_note_urg%TYPE,
                              p_flg_forz_man_gest_interna    IN t_mcrei_app_delibere.flg_forz_man_gest_interna%TYPE,
                              p_desc_note_forzatura          IN t_mcrei_app_delibere.desc_note_forzatura%TYPE)
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage function che SALVA i campi delle delibere inseriti manulamente
  -- %d La function, per ogni protocollo pacchetto in input, aggiorna gli attributi presenti
  -- %d nella tabella delibere relativamente alla sezione"Cause mantenimento impieghi vivi"
  -- %cd 4 GEN 2012
  FUNCTION popola_man_cause_mantenim(p_proto_pacchetto           IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                     p_proto_delibera            IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                     p_cod_abi                   IN t_mcrei_app_delibere.cod_abi%TYPE,
                                     p_cod_ndg                   IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                     p_flg_libretti_port_min     IN t_mcrei_app_delibere.flg_libretti_portatore_minori%TYPE,
                                     p_flg_rap_con_depos_titoli  IN t_mcrei_app_delibere.flg_rapporti_con_depos_titoli%TYPE,
                                     p_flg_rapporti_bloccati     IN t_mcrei_app_delibere.flg_rapporti_bloccati%TYPE,
                                     p_flg_rap_garanzia_cred_fir IN t_mcrei_app_delibere.flg_rapporti_garanzia_cred_fir%TYPE,
                                     p_flg_rap_concordato_preven IN t_mcrei_app_delibere.flg_rapporto_concordato_preven%TYPE,
                                     p_flg_conti_categ_2000      IN t_mcrei_app_delibere.flg_conti_categ_2000%TYPE)
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage function che SALVA i campi delle delibere inseriti manulamente
  -- %d La function, per ogni protocollo pacchetto in input, aggiorna gli attributi presenti
  -- %d nella tabella delibere relativamente alla sezione "Riferimenti pratica"
  -- %cd 4 GEN 2012
  FUNCTION popola_man_riferimenti_pratica(p_proto_pacchetto           IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                          p_proto_delibera            IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                          p_cod_abi                   IN t_mcrei_app_delibere.cod_abi%TYPE,
                                          p_cod_ndg                   IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                          p_num_telefono              IN t_mcrei_app_delibere.num_telefono%TYPE,
                                          p_indirizzo_email           IN t_mcrei_app_delibere.indirizzo_email%TYPE,
                                          p_desc_secondo_referente    IN t_mcrei_app_delibere.desc_secondo_referente%TYPE,
                                          p_num_tel_secondo_referente IN t_mcrei_app_delibere.num_tel_secondo_referente%TYPE)
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage function che SALVA i campi dei pareri inseriti manulamente
  -- %d La function, per ogni identificativo di parere e protocollo delibera, ricevuti in input
  -- %d aggiorna gli attributi presenti nella tabella pareri relativamente
  -- %d alla sezione"Elenco pareri"
  -- %cd 4 GEN 2011
  FUNCTION popola_elenco_pareri(p_cod_abi                  IN t_mcrei_app_pareri.cod_abi%TYPE,
                                p_cod_ndg                  IN t_mcrei_app_pareri.cod_ndg%TYPE,
                                p_cod_microtipol           IN t_mcrei_app_delibere.cod_macrotipologia_delib%TYPE,
                                p_cod_protocollo_delibera  IN t_mcrei_app_pareri.cod_protocollo_delibera%TYPE,
                                p_cod_protocollo_pacchetto IN t_mcrei_app_pareri.cod_protocollo_pacchetto%TYPE,
                                p_cod_tipo_par             IN t_mcrei_app_pareri.cod_tipo_par%TYPE,
                                p_desc_parere              IN t_mcrei_app_pareri.desc_parere%TYPE,
                                p_flg_difforme             IN t_mcrei_app_pareri.flg_difforme%TYPE,
                                p_desc_parere_esteso       IN t_mcrei_app_pareri.desc_parere_esteso%TYPE,
                                p_utente                   IN t_mcrei_app_pareri.cod_utente%TYPE DEFAULT NULL,
                                p_uo                       IN t_mcrei_app_pareri.cod_uo%TYPE DEFAULT NULL,
                                p_dta_ins_parere           IN t_mcrei_app_pareri.dta_ins_parere%TYPE DEFAULT NULL,
                                p_spalma_parere            IN VARCHAR2 DEFAULT 'Y')
    RETURN NUMBER;

  --funzione richiamata a seguito di impianto proposta:
  --setta anno e progressivo proposta sulle tabelle appena popolate
  FUNCTION aggiorna_proposta(delibera             IN VARCHAR2,
                             pacchetto            IN VARCHAR2,
                             abi                  IN VARCHAR2,
                             ndg                  IN VARCHAR2,
                             anno_proposta        IN NUMBER,
                             progressivo_proposta IN NUMBER) RETURN NUMBER;

  -- t_mcrei_app_pareri
  -- v_mcrei_app_elenco_pareri

  -- ============== Gestione pacchetto, microtipologia e delibera =================================

  -- %author Reply
  -- %version 0.1
  -- %usage  funzione che verifica l'esistenza di un pacchetto non ancora confermato per l'sndg in input
  -- %d  La funzione, per l'SNDG in input, verifica l'esistenza di un eventuale
  -- %d  pacchetto ancora aperto. Se esiste, ne restituisce il protocollo,in caso contrario
  -- %d  restituisce NULL
  -- %cd 7 nov 2011
  -- %param P_SNDG: super NDG
  FUNCTION ctrl_esist_pacc_aperto(p_sndg IN VARCHAR2
                                 ,P_COD_GRUPPO_SUPER IN VARCHAR2 default NULL --DR
                                 ) RETURN VARCHAR2;

  -- %author Reply
  -- %version 0.1
  -- %usage  FUNCTION che aggiunge una delibera ad un pacchetto gi? esistente
  -- %d La FUNCTION permette di aggiungere una microtipologia di delibera ad un pacchetto
  -- %d di delibere NON ancora CONFERMATO
  -- %cd 17 NOV 2011
  -- %param P_SUPERNDG
  -- %param P_MICROTIPOLO
  -- %param P_UTE_INSE
  FUNCTION crea_pacchetto(p_sndg         IN VARCHAR2,
                          p_microtipolog IN VARCHAR2,
                          p_utente_ins   IN VARCHAR2,
                                                    P_FLG_FORZ_IMP IN VARCHAR2 DEFAULT 'N') RETURN VARCHAR2;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che gestisce lo step di creazione pacchetto e/o creazione delibera
  -- %d  La funzione effettua controlli ed operazioni necessarie alla creazione di un pacchetto
  -- %d  o alla aggiunta di una nuova delibera. Gli step eseguiti sono i seguenti:
  -- %d
  -- %d    * Controlla esistenza pacchetto aperto per l'SNDG in input
  -- %d    * Se NON esiste un pacchetto aperto (in stato n? CNF n? ULT), allora:
  -- %d           --> CREA UN NUOVO PACCHETTO, generando i protocolli delle delibere
  -- %d               per gli NDG associati al SNDG
  -- %d    * Se ESISTE un pacchetto aperto (in stato n? CNF n? ULT), allora:
  -- %d           --> aggiunge SOLO le delibere, generando i protocolli delle delibere
  -- %d               per gli NDG associati al SNDG
  -- %cd 7 nov 2011
  -- %param P_SNDG: super NDG
  -- %param P_MICROTIPOL
  -- %param P_UTE_INS
  FUNCTION imposta_microtipologia(p_sndg       IN VARCHAR2,
                                  p_microtipol IN VARCHAR2,
                                  p_ute_ins    IN VARCHAR2,
                                  P_FLG_FORZ_IMP IN VARCHAR2 DEFAULT 'N'
                                  ,P_COD_GRUPPO_SUPER IN VARCHAR2 default NULL) RETURN VARCHAR2;--DR

  -- %author Reply
  -- %version 0.1
  -- %usage  FUNCTION che aggiunge una delibera ad un pacchetto gi? esistente
  -- %d La FUNCTION permette di aggiungere una microtipologia di delibera ad un pacchetto
  -- %d di delibere NON ancora CONFERMATO
  -- %cd 17 NOV 2011
  -- %param P_PROTO_PACCHETTO
  -- %param P_SUPERNDG
  -- %param P_MICROTIPOLO
  -- %param P_UTE_INSE
  FUNCTION aggiungi_microtipologia(p_proto_pacchetto VARCHAR2,
                                   p_sndg            VARCHAR2,
                                   p_microtipolog    VARCHAR2,
                                   p_utente_ins      VARCHAR2,
                                   p_dta_creaz       DATE,
                                                             P_FLG_FORZ_IMP IN VARCHAR2 DEFAULT 'N') RETURN VARCHAR2;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  FUNCTION CHE AGGIUNGE UNA DELIBERA AD UN PACCHETTO GIo ESISTENTE E NON ANCORA CONFERMATO
  -- %D LA FUNCTION CREA, PER IL PACCHETTO PASSATO IN INPUT, una sola delibera per abi, nsd passati
  -- %D QUANTI SONO GLI NDG COLLEGATI AL SNDG
  -- %D DI DELIBERE
  -- %CD 22 MAR 2012
  -- %PARAM P_PROTO_PACCHETTO
  -- %PARAM P_ABI
  -- %PARAM P_NDG
  -- %PARAM P_SUPERNDG
  -- %PARAM P_MICROTIPOLO
  -- %PARAM P_UTE_INSE
  FUNCTION aggiungi_microtipologia_act(p_proto_pacchetto VARCHAR2,
                                       p_abi             VARCHAR2,
                                       p_ndg             VARCHAR2,
                                       p_sndg            VARCHAR2,
                                       p_microtipolog    VARCHAR2,
                                       p_utente_ins      VARCHAR2)
    RETURN VARCHAR2;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che rimuove una microtipologia da un pacchetto
  -- %d  La funzione, per il pacchetto in input, cancella le delibere corrispondenti alla microtipologia in input
  -- %cd 7 nov 2011
  -- %param P_PROT_PACCH
  -- %param P_MICROTIPOL
  FUNCTION RIMUOVI_MICROTIPOLOGIA(P_PROT_PACCH IN VARCHAR2,
                                  p_microtipol IN VARCHAR2--,
                                --  P_DTA_ANNULLO IN T_MCREI_APP_DELIBERE.DTA_ANNULLO%TYPE DEFAULT SYSDATE,
                                --  P_COD_MATRICOLA_ANNULLO IN T_MCREI_APP_DELIBERE.COD_MATRICOLA_ANNULLO%TYPE DEFAULT NULL,
                                --  P_COD_OPERA_COME_ANNULLO IN T_MCREI_APP_DELIBERE.COD_OPERA_COME_ANNULLO%TYPE DEFAULT NULL,
                                --  P_DESC_NOTE_DELIBERE_ANNULLATE IN T_MCREI_APP_DELIBERE.DESC_NOTE_DELIBERE_ANNULLATE%TYPE DEFAULT NULL
                                ) RETURN NUMBER;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che rimuove un pacchetto
  -- %d  La funzione, per il pacchetto in input, cancella tutte le delibere corrispondenti
  -- %param P_PROT_PACCH
  FUNCTION rimuovi_pacchetto(p_prot_pacch IN VARCHAR2) RETURN NUMBER;

  -- %author Reply
  -- %version 0.2
  -- %usage  Funzione che modifica l'abilitazione della delibera indicata in input
  -- %d  La funzione, per il pacchetto in input, setta per la delibera corrispondente
  -- %d  al protocollo delibera in input il flag di abilitazione in input
  -- %cd 04.01.2011
  -- %param P_PROT_PACCH
  -- %param P_NDG
  -- %param P_ABI
  -- %param P_PROT_DELIB
  -- %param p_flg_no_del
  -- %param p_utente -->matricola che effettua l'update
  FUNCTION setta_abilitazione_delib(p_abi        IN VARCHAR2,
                                    p_ndg        IN VARCHAR2,
                                    p_prot_delib IN VARCHAR2,
                                    p_flg_no_del IN NUMBER,
                                    p_utente     VARCHAR2,
                                    p_desc_no_delibera VARCHAR2 default null
                                    ) RETURN NUMBER;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che conferma il pacchetto in input
  -- %d  La funzione, per il pacchetto in input, setta gli attributi di pacchetto sulla tabelle
  -- %d  delle delibere, indicando la avvenuta conferma da parte del gestore
  -- %cd 25 nov 2011
  -- %param P_PROT_PACCHET
  FUNCTION conferma_pacchetto(p_prot_pacchet IN VARCHAR2) RETURN NUMBER;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che congela i dati su richiesta dell'utente
  -- %d  La funzione, per il pacchetto in input, setta gli attributi di pacchetto sulla tabelle
  -- %d  delle delibere, indicando la avvenuta conferma da parte del gestore
  -- %cd 25 nov 2011
  -- %param P_PROT_PACCHET
  --->>>>>>>>>>>>>>>>>     function congela_dati   <<<<<<<<<<<<<<<<<<<<<<<<<<<<

  -- ======================= aggiornamento FASI ===============================

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che retrocede il wf del pacchetto (e fase delibera/microtip.)
  -- %cd 13 feb 2012
  -- %param P_PROT_PACCHETTO
  -- %param P_utente
  FUNCTION retrocedi_wf(p_prot_pacchetto IN VARCHAR2, p_utente IN VARCHAR2)
    RETURN NUMBER;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE RETROCEDE IL WF DEL PACCHETTO (E FASE DELIBERA/MICROTIP.)
  -- %CD 13 FEB 2012
  -- %PARAM P_PROT_PACCHETTO
  -- %PARAM P_UTENTE
  FUNCTION retrocedi_wf_microtipologia(p_prot_pacchetto IN VARCHAR2,
                                       p_cod_microtipol IN VARCHAR2,
                                       p_utente         IN VARCHAR2)
    RETURN NUMBER;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE RETROCEDE IL WF DEL PACCHETTO (E FASE DELIBERA/MICROTIP.)
  -- %CD 13 FEB 2012
  -- %PARAM P_PROT_PACCHETTO
  -- %PARAM P_UTENTE
  -- %PARAM P_PACC_CH_RISTR : Y SE ESISTE NEL PACCHETTO UNA DELIBERA B8, ALTRIMENTI N
  FUNCTION retrocedi_wf_pacchetto(p_prot_pacchetto IN VARCHAR2,
                                  p_cod_microtipol IN VARCHAR2,
                                  p_utente         IN VARCHAR2,
                                 -- P_FLG_CH_RISTR  IN VARCHAR2 DEFAULT 'N'
                                 p_doc_classif_mci      t_mcrei_app_delibere.cod_doc_classificazione_mci%TYPE DEFAULT NULL)
    RETURN NUMBER;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che fa avanzare la fase della delibera (stato delibera)
  -- %d  La funzione, per la delibera in input, aggiorna la fase (ovvero lo stato)
  -- %cd 25 nov 2011
  -- %param P_PROT_PACCHETTO
  -- %param P_NEW_FASE
  -- %param P_FLG_CONFERMA: Y --> la delibera S stata confermata, quindi P_NEW_FASE = 'CO'
  FUNCTION cambia_fase_pacchetto(p_prot_pacchetto IN VARCHAR2,
                                 p_new_fase       IN VARCHAR2,
                                 p_flg_conferma   IN VARCHAR2 DEFAULT 'N')
    RETURN NUMBER;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che fa avanzare la fase della delibera (stato delibera)
  -- %d  La funzione, per la delibera in input, aggiorna la fase (ovvero lo stato)
  -- %cd 25 nov 2011
  -- %param P_ABI
  -- %param P_NDG
  -- %param P_PROT_DELIB
  -- %param P_NEW_FASE
  -- %param P_FLG_CONFERMA: Y --> la delibera S stata confermata, quindi P_NEW_FASE = 'CO'
  FUNCTION cambia_fase_delibera(p_abi            IN VARCHAR2,
                                p_ndg            IN VARCHAR2,
                                p_prot_delib     IN VARCHAR2,
                                p_new_fase       IN VARCHAR2,
                                p_microtipologia IN VARCHAR2,
                                p_flg_conferma   IN VARCHAR2 DEFAULT 'N' /*,
                                                                p_v_stralcio_quota_cap  IN t_mcrei_app_delibere.val_stralcio_quota_cap%TYPE DEFAULT NULL,
                                                                p_v_stralcio_quota_mora IN t_mcrei_app_delibere.val_stralcio_quota_mora%TYPE DEFAULT NULL*/)
    RETURN NUMBER;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che fa avanzare la fase della microtipologia in input
  -- %d  La funzione, per il pacchetto in input, fa avanzare la fase in cui si trova
  -- %d  la microtipologia specificata in input
  -- %cd 25 nov 2011
  -- %param P_PROT_pacc
  -- %param P_MICROTIPO
  -- %param P_NEW_FASE: Sigla nella fase in cui viene fatta avanzare la microtipologia
  FUNCTION cambia_fase_microtipologia(p_prot_pacc IN VARCHAR2,
                                      p_microtipo IN VARCHAR2,
                                      p_new_fase  IN VARCHAR2) RETURN NUMBER;

  -- ======= Inserimento Proposta (delibera di classificazione) ===============

  -- ======================== gestione OD =====================================

  -- %author reply
  -- %version 0.1
  -- %usage  funzione che salva l'od calcolato sulle Delibere
  -- %d L'aggiornamento avviene a livello di pacchetto
  -- %cd 19 mar 2012
  -- %param p_abi non null
  -- %param p_proto_pacch protocollo pacchetto, non nullo
  -- %param p_od_calc_abi OD calcolato a livello di capogruppo (01025)
  -- %param p_od_cal_pacch OD calcolato a livello di pacchetto
  FUNCTION calcola_od(p_abi             IN t_mcrei_app_delibere.cod_abi%TYPE,
                      p_proto_pacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                      p_od_calc_abi     IN VARCHAR2,
                      --p_od_calc_pacch      IN VARCHAR2
                      p_abi_rif          IN t_mcrei_app_delibere.cod_abi%TYPE
                      ) RETURN NUMBER;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che conferma l'Organo deliberante a livello gestore delle DELIBERE
  -- %d  La funzione, per la posizione, protocollo delibera e protocollo pacchetto in input
  -- %d salva per le posizioni "gestore" (se p_abi = 01025), l'organo passato, come
  -- %d organo deliberante; per tutte le altre viene aggiornato l'organo pacchetto
  -- %cd 11 GEN 2011
  -- %param p_abi ABI
  -- %param p_ndg NDG
  -- %param p_proto_delib Protocollo delibera
  -- %param p_proto_pacch Protocollo pacchetto
  -- %param p_od Codice Organo deliberante
  FUNCTION conferma_od(p_abi                IN t_mcrei_app_delibere.cod_abi%TYPE,
                       p_ndg                IN t_mcrei_app_delibere.cod_ndg%TYPE,
                       p_proto_delib        IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                       p_proto_pacch        IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                       p_cod_microtipologia IN t_mcrei_app_delibere.cod_microtipologia_delib%TYPE,
                       p_od                 IN VARCHAR2,
                       p_flg_tipo_dato      IN VARCHAR2) RETURN NUMBER;

  FUNCTION conferma_od(p_abi         IN t_mcrei_app_delibere.cod_abi%TYPE,
                       p_ndg         IN t_mcrei_app_delibere.cod_ndg%TYPE,
                       p_proto_pacch IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                       p_od          IN VARCHAR2,
                       p_abi_riferimento IN t_mcrei_app_delibere.cod_abi%TYPE default null) RETURN NUMBER;

  -- ======================== gestione PARERI =================================

  --Dentro ogni gestione microtipologia
  FUNCTION propaga_parere_sndg(p_sndg       IN VARCHAR2,
                               p_microtipol IN VARCHAR2
                              ,P_COD_GRUPPO_SUPER IN VARCHAR2 default NULL --DR
                               ) RETURN NUMBER;

  --Dentro ogni gestione microtipologia
  FUNCTION associa_parere_ndg(p_ndg        IN VARCHAR2,
                              p_abi        IN VARCHAR2,
                              p_prot_delib IN VARCHAR2) RETURN NUMBER;

  --Gestione Delibere (Genera Parere)

  FUNCTION ANNULLA_PACCHETTO(P_PROTO_PACCH IN T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_PACCHETTO%TYPE,
                             P_FLG_TIPO    VARCHAR2,--,
                             p_doc_classif_mci      t_mcrei_app_delibere.cod_doc_classificazione_mci%TYPE DEFAULT NULL
                            -- P_DTA_ANNULLO IN T_MCREI_APP_DELIBERE.DTA_ANNULLO%TYPE DEFAULT SYSDATE,
                            -- P_COD_MATRICOLA_ANNULLO IN T_MCREI_APP_DELIBERE.COD_MATRICOLA_ANNULLO%TYPE DEFAULT NULL,
                            -- P_COD_OPERA_COME_ANNULLO IN T_MCREI_APP_DELIBERE.COD_OPERA_COME_ANNULLO%TYPE DEFAULT NULL,
                            -- P_DESC_NOTE_DELIBERE_ANNULLATE IN T_MCREI_APP_DELIBERE.DESC_NOTE_DELIBERE_ANNULLATE%TYPE DEFAULT NULL
                            ) RETURN NUMBER;

  FUNCTION get_capogruppo(p_proto_pacch IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE)
    RETURN VARCHAR2;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  FUNCTION CHE popola i dati in fase di controproposta rv da parte di una banca rete
    -- %d   Se la banca rete non S d'accordo sui dati presenti nel parere di conformit? della capogruppo
  -- %d      contropropone un valore di rettifica alternativo (p_rdv_delib), e il flg_coerenza indica la conformit?
    -- %d   o meno al parere della capogruppo(null--> forzata da capogruppo, 0--> non conforme,1--> conforme)
  -- %CD 9 MAR 2012
    FUNCTION popola_dati_banca_rete(p_abi          IN t_mcrei_app_delibere.cod_abi%TYPE,
                                  p_ndg          IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                  p_proto_delib  IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                  p_proto_pacch  IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                  p_od_calcolato IN t_mcrei_app_delibere.cod_organo_calcolato%TYPE,
                                  p_od_delib     IN t_mcrei_app_delibere.cod_organo_deliberante%TYPE,
                                  --p_dta_delib       IN t_mcrei_app_delibere.dta_delibera%TYPE,
                                  p_dta_cnf_delib IN t_mcrei_app_delibere.dta_conferma_delibera%TYPE,
                                  p_flg_coerenza  IN t_mcrei_app_delibere.flg_delib_in_linea%TYPE,
                                  p_note_coerenza IN t_mcrei_app_delibere.desc_note_coerenza%TYPE,
                                  p_rdv_delib     IN t_mcrei_app_delibere.val_rdv_delib_banca_rete%TYPE,
                                  P_FLG_DELIB_FORZATA IN T_MCREI_APP_DELIBERE.FLG_DELIB_FORZATA%TYPE DEFAULT '0'
                                  -- Risposta di delibera inviata - evidenza dell'avvenuta
                                  -- conferma da parte della banca. L'icona sar? valorizzata: V
                                  ) RETURN NUMBER;

  --========================= POPOLAMENTO BENI =========================

  FUNCTION salva_beni_proposta(p_id_bene t_mcrei_app_beni.id_logical_bene%TYPE,
                               --V_MCREI_APP_BENI
                               p_cod_sndg          t_mcrei_app_beni_proposte.cod_sndg%TYPE,
                               p_cod_tipo_bene     t_mcrei_app_beni_proposte.cod_tipo_bene%TYPE,
                               p_cod_proto_delib   t_mcrei_app_beni_proposte.cod_protocollo_delibera%TYPE,
                               p_cod_proto_pacch   t_mcrei_app_beni_proposte.cod_protocollo_pacchetto%TYPE,
                               p_desc_intestatario t_mcrei_app_beni_proposte.desc_intestatario%TYPE,
                               p_desc_comune       t_mcrei_app_beni_proposte.desc_comune%TYPE,
                               p_cod_fogl_map_sub  t_mcrei_app_beni_proposte.cod_fogl_map_sub%TYPE,
                               p_cod_diritto       t_mcrei_app_beni_proposte.cod_diritto%TYPE,
                               p_val_quota         t_mcrei_app_beni_proposte.val_quota%TYPE)
    RETURN NUMBER;

  FUNCTION popola_beni(
                       /* chiave secondaria */p_c_sndg            t_mcrei_app_beni.cod_sndg%TYPE,
                       p_c_tipo_bene       t_mcrei_app_beni.cod_tipo_bene%TYPE,
                       p_c_catasto         t_mcrei_app_beni.cod_catasto%TYPE,
                       p_c_cespite         t_mcrei_app_beni.cod_cespite%TYPE,
                       p_c_fogl_map_sub    t_mcrei_app_beni.cod_fogl_map_sub%TYPE,
                       p_v_progr_bene_cesp t_mcrei_app_beni.val_progr_bene_cesp%TYPE,
                       /* CAMPI DA AGGIORNARE O INSERIRE */
                       p_c_conservatoria     t_mcrei_app_beni.cod_conservatoria%TYPE,
                       p_c_diritto           t_mcrei_app_beni.cod_diritto%TYPE,
                       p_c_divisa            t_mcrei_app_beni.cod_divisa%TYPE,
                       p_c_interno           t_mcrei_app_beni.cod_interno%TYPE,
                       p_c_piano             t_mcrei_app_beni.cod_piano%TYPE,
                       p_c_provincia         t_mcrei_app_beni.cod_provincia%TYPE,
                       p_c_scala             t_mcrei_app_beni.cod_scala%TYPE,
                       p_c_tipo              t_mcrei_app_beni.cod_tipo%TYPE,
                       p_c_denuncia          t_mcrei_app_beni.cod_tipo_denuncia%TYPE,
                       p_c_tipologia_terreno t_mcrei_app_beni.cod_tipologia_terreno%TYPE,
                       p_d_comune            t_mcrei_app_beni.desc_comune%TYPE,
                       p_d_conservatoria     t_mcrei_app_beni.desc_conservatoria%TYPE,
                       p_d_indirizzo         t_mcrei_app_beni.desc_indirizzo%TYPE,
                       p_d_localita          t_mcrei_app_beni.desc_localita%TYPE,
                       p_dta_visura          t_mcrei_app_beni.dta_visura%TYPE,
                       p_f_cantina           t_mcrei_app_beni.flg_pres_cantina%TYPE,
                       p_f_servizi           t_mcrei_app_beni.flg_pres_servizi%TYPE,
                       p_f_solaio            t_mcrei_app_beni.flg_pres_solaio%TYPE,
                       p_v_rendita           t_mcrei_app_beni.val_num_rendita%TYPE,
                       p_v_vani              t_mcrei_app_beni.val_num_vani%TYPE,
                       p_v_superficie        t_mcrei_app_beni.val_superficie%TYPE,
                       p_val_quota           t_mcrei_app_beni.val_quo_diritto%TYPE,
                       p_desc_intestatario   t_mcrei_app_beni.desc_intestatario%TYPE)
    RETURN NUMBER;

  FUNCTION popola_beni_man(p_id_bene t_mcrei_app_beni.id_logical_bene%TYPE,
                           /*key*/
                           p_c_sndg         t_mcrei_app_beni.cod_sndg%TYPE,
                           p_d_intestatario t_mcrei_app_beni.desc_intestatario%TYPE,
                           /*key*/
                           p_c_tipo_bene t_mcrei_app_beni.cod_tipo_bene%TYPE,
                           /*key*/
                           p_c_fogl_map_sub t_mcrei_app_beni.cod_fogl_map_sub%TYPE,
                           p_c_diritto      t_mcrei_app_beni.cod_diritto%TYPE,
                           p_v_quota_dir    t_mcrei_app_beni.val_quo_diritto%TYPE,
                           p_desc_comune    t_mcrei_app_beni.desc_comune%TYPE)
    RETURN NUMBER;

  FUNCTION elimina_bene(p_id_bene t_mcrei_app_beni.id_logical_bene%TYPE)
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage function che SALVA la foto dei cointestatari associati alla proposta
  -- %cd 26 GEN 2012
  FUNCTION popola_cointestatari_proposta(p_cod_abi                 IN t_mcrei_app_cointest_prop.cod_abi%TYPE,
                                         p_cod_sndg                IN t_mcrei_app_cointest_prop.cod_sndg%TYPE,
                                         p_cod_ndg                 IN t_mcrei_app_cointest_prop.cod_ndg%TYPE,
                                         p_protocollo_pacchetto    IN t_mcrei_app_cointest_prop.cod_protocollo_pacchetto%TYPE,
                                         p_protocollo_delibera     IN t_mcrei_app_cointest_prop.cod_protocollo_delibera%TYPE,
                                         p_cod_sndg_cointestatario IN t_mcrei_app_cointest_prop.cod_sndg_cointestatario%TYPE,
                                         p_cod_ndg_cointestatario  IN t_mcrei_app_cointest_prop.cod_ndg_cointestatario%TYPE,
                                         p_cod_abi_cointestatario  IN t_mcrei_app_cointest_prop.cod_abi_cointestatario%TYPE,
                                         p_desc_nome_controparte   IN t_mcrei_app_cointest_prop.desc_nome_controparte%TYPE)
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage Function che aggiorna gli id dei documenti presenti nella tabella in cui scrive documentum da web.
  -- %d La function aggiorna gli id dei doc in input in corrispondenza della delibera in input
  -- %cd 2 feb 2012
  FUNCTION update_id_documenti(p_abi                  t_mcrei_app_delibere.cod_abi%TYPE,
                               p_ndg                  t_mcrei_app_delibere.cod_ndg%TYPE,
                               p_proto_delib          t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                               p_doc_delibera_banca   t_mcrei_app_delibere.cod_doc_delibera_banca%TYPE,
                               p_doc_parere_conform   t_mcrei_app_delibere.cod_doc_parere_conformita%TYPE,
                               p_doc_appendice_parere t_mcrei_app_delibere.cod_doc_appendice_parere%TYPE,
                               p_doc_delib_capogr     t_mcrei_app_delibere.cod_doc_delibera_capogruppo%TYPE,
                               p_doc_classif          t_mcrei_app_delibere.cod_doc_classificazione%TYPE,
                               p_doc_classif_mci      t_mcrei_app_delibere.cod_doc_classificazione_mci%TYPE DEFAULT NULL
                               )
    RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage function che SALVA i campi delle delibere generiche
  -- %d La function, per ogni abi, ndg, protocollo di delibera e protocollo_pacchetto in input,
  -- %d aggiorna gli attributi corrispondenti con i valori passati in input,
  -- %d e recupera i dati contabili direttamente da PCR
  -- %cd 10 FEB 2012
  -- V_MCREI_APP_DELIB_GENERICHE
  FUNCTION popola_del_generica(p_cod_abi         IN t_mcrei_app_delibere.cod_abi%TYPE,
                               p_cod_ndg         IN t_mcrei_app_delibere.cod_ndg%TYPE,
                               p_proto_pacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                               p_proto_delibera  IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                               -----------------------------------------------------------------------------------
                               p_val_del_rinuncia  IN t_mcrei_app_delibere.val_rinuncia_deliberata%TYPE,
                               p_val_prop_rinuncia IN t_mcrei_app_delibere.val_rinuncia_proposta%TYPE,
                               p_val_tot_rinuncia  IN t_mcrei_app_delibere.val_rinuncia_totale%TYPE,
                               p_val_del_rettifica IN t_mcrei_app_delibere.val_rdv_qc_deliberata%TYPE,
                               p_desc_note         IN t_mcrei_app_delibere.desc_note%TYPE,
                               p_dta_scadenza      IN t_mcrei_app_delibere.dta_scadenza%TYPE DEFAULT NULL

                               ) RETURN NUMBER;

  -- %author
  -- %version 0.1
  -- %usage function che SALVA i campi inseriti manualmente delle delibere generiche mentre
  -- %d La function, per ogni abi, ndg, protocollo di delibera e protocollo_pacchetto in input,
  -- %d aggiorna gli attributi corrispondenti con
  -- %d i valori passati in input
  -- %cd 10 FEB 2012
  FUNCTION popola_man_del_generica(p_cod_abi         IN t_mcrei_app_delibere.cod_abi%TYPE,
                                   p_cod_ndg         IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                   p_proto_pacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                   p_proto_delibera  IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                   -------------------------------------------------------------------------------------
                                   p_val_del_rinuncia  IN t_mcrei_app_delibere.val_rinuncia_deliberata%TYPE,
                                   p_val_prop_rinuncia IN t_mcrei_app_delibere.val_rinuncia_proposta%TYPE,
                                   p_val_tot_rinuncia  IN t_mcrei_app_delibere.val_rinuncia_totale%TYPE,
                                   p_desc_note         IN t_mcrei_app_delibere.desc_note%TYPE,
                                   p_dta_scadenza      IN t_mcrei_app_delibere.dta_scadenza%TYPE DEFAULT NULL

                                   ) RETURN NUMBER;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  Function che salva i dati manuali relativi ad una delibera di chiusura (incaglio o ristrutturazione)
  -- %cd 07 giu 2012
  FUNCTION popola_man_del_chiusura(p_cod_abi         IN t_mcrei_app_delibere.cod_abi%TYPE,
                                   p_cod_ndg         IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                   p_proto_pacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                   p_proto_delibera  IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                   -------------------------------------------------------------------------------------
                                   p_causale_chiusura   IN t_mcrei_app_delibere.cod_causa_chius_delibera%TYPE,
                                   p_desc_note          IN t_mcrei_app_delibere.desc_note%TYPE,
                                   p_dta_scadenza       IN t_mcrei_app_delibere.dta_scadenza%TYPE,
                                   p_tipo_ristr         IN VARCHAR2 DEFAULT NULL,
                                   p_intento_ristr      IN VARCHAR2 DEFAULT NULL,
                                   p_dta_scadenza_ristr IN DATE DEFAULT NULL,
                                   p_stato_post_ristr   IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  Function che chiude effettivamente la ristrutturazione settando la data nella delibera e nella tabella delle ristrutturazioni su posizionecongela i dati di una delibera di Chiusura di Ristrutturazione
  -- %cd 07 giu 2012
  -- %PARAM P_ABI Not Null
  -- %PARAM P_NDG Not Null
  -- %PARAM P_PROTO_DELIB Not Null
  -- %PARAM P_UTE_INSE UTENTE
  FUNCTION chiudi_ristrutturazione(p_abi         VARCHAR2,
                                   p_ndg         VARCHAR2,
                                   p_proto_delib VARCHAR2,
                                   p_utente      VARCHAR2) RETURN NUMBER;

  FUNCTION popola_del_chiusura(p_cod_abi         IN t_mcrei_app_delibere.cod_abi%TYPE,
                               p_cod_ndg         IN t_mcrei_app_delibere.cod_ndg%TYPE,
                               p_proto_pacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                               p_proto_delibera  IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                               -------------------------------------------------------------------------------------
                               p_causale_chiusura   IN t_mcrei_app_delibere.cod_causa_chius_delibera%TYPE,
                               p_desc_note          IN t_mcrei_app_delibere.desc_note%TYPE,
                               p_dta_scadenza       IN t_mcrei_app_delibere.dta_scadenza%TYPE,
                               p_tipo_ristr         IN VARCHAR2 DEFAULT NULL,
                               p_intento_ristr      IN VARCHAR2 DEFAULT NULL,
                               p_dta_scadenza_ristr IN DATE DEFAULT NULL,
                               p_stato_post_ristr   IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION popola_man_dett_rapp_rv(p_cod_abi           t_mcrei_app_stime.cod_abi%TYPE,
                                   p_cod_ndg           t_mcrei_app_stime.cod_ndg%TYPE,
                                   p_proto_delibera    t_mcrei_app_stime.cod_protocollo_delibera%TYPE,
                                   p_proto_pacchetto   t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                   p_cod_tipo_rapporto t_mcrei_app_stime.cod_tipo_rapporto%TYPE,
                                   ---> stime.cod_tipo_rapporto (attributo_rapporto da pcr) equivalente a COD_CLASSE_Ft
                                   p_cod_operat_rientro t_mcrei_app_stime.flg_tipo_dato%TYPE,
                                   ---> stime.cod_tipo_dato
                                   p_flg_ristrutt t_mcrei_app_stime.flg_ristrutturato%TYPE,
                                   ---> rapporti. flg_ristrutturato?
                                   p_flg_recupero_tot t_mcrei_app_stime.flg_ristrutturato%TYPE,
                                   ---> stime.FLG_RECUPERO_TOT
                                   p_val_stima_di_rec t_mcrei_app_stime.val_prev_recupero%TYPE,
                                   ---> stime.val_prev_recupero
                                   p_val_rett_liv_rapporto t_mcrei_app_stime.val_imp_rettifica_att%TYPE,
                                   ---> stime.val_rdv_tot
                                   p_val_rett_effettuata t_mcrei_app_stime.val_imp_rettifica_att%TYPE,
                                   p_val_percentuale     t_mcrei_app_stime.val_perc_rett_rapporto%TYPE, --->nullable
                                   utente                t_mcrei_app_stime.cod_utente%TYPE,
                                   p_cod_rapporto        t_mcrei_app_stime.cod_rapporto%TYPE,
                                   p_ftecnica            VARCHAR2 DEFAULT NULL,
                                   p_flg_archiviazione   VARCHAR2 DEFAULT NULL,
                                   p_flg_estinto         VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION popola_dett_rapp_rv(p_proto_delibera    IN t_mcrei_app_stime.cod_protocollo_delibera%TYPE,
                               p_cod_tipo_rapporto IN t_mcrei_app_stime.cod_tipo_rapporto%TYPE,
                               ---> stime.cod_tipo_rapporto (attributo_rapporto da pcr) equivalente a COD_CLASSE_Ft
                               p_cod_rapporto          IN t_mcrei_app_stime.cod_rapporto%TYPE,
                               p_val_forma_tecnica     IN VARCHAR2,
                               p_val_utilizzato_lordo  IN t_mcrei_app_stime.val_esposizione%TYPE,
                               p_val_utilizzato_mora   IN t_mcrei_app_stime.val_utilizzato_mora%TYPE,
                               p_val_utilizzato_netto  IN t_mcrei_app_stime.val_utilizzato_netto%TYPE,
                               p_val_utilizzato_firma  IN t_mcrei_app_stime.val_utilizzato_netto%TYPE,
                               p_cod_operat_rientro    IN t_mcrei_app_stime.flg_tipo_dato%TYPE,
                               p_flg_ristrutt          IN t_mcrei_app_stime.flg_ristrutturato%TYPE,
                               p_flg_recupero_tot      IN t_mcrei_app_stime.flg_recupero_tot%TYPE,
                               p_val_rett_liv_rapporto IN t_mcrei_app_stime.val_imp_rettifica_att%TYPE,
                               p_val_stima_di_rec      IN t_mcrei_app_stime.val_prev_recupero%TYPE,
                               p_flg_storico           IN VARCHAR2,
                               -- PER ADESSO NON GESTITO
                               --
                               p_cod_abi IN t_mcrei_app_stime.cod_abi%TYPE,
                               p_cod_ndg IN t_mcrei_app_stime.cod_ndg%TYPE,
                               --
                               p_val_intervallo IN VARCHAR2,
                               -- CAMPO RECUPERATO DA PCR A LIVELLO VISTA
                               p_flg_fondo_terzi IN VARCHAR2,
                               -- RECUPERATO DA DELIBERE
                               p_proto_pacchetto IN VARCHAR2,
                               -- Non salvato
                               p_val_rett_effettuata IN t_mcrei_app_stime.val_imp_rettifica_att%TYPE,
                               p_val_percentuale     IN t_mcrei_app_stime.val_perc_rett_rapporto%TYPE,
                               utente                IN t_mcrei_app_stime.cod_utente%TYPE,
                               p_ftecnica            VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION popola_man_dett_dati_gen_rv(p_cod_abi            VARCHAR2,
                                       p_cod_ndg            VARCHAR2,
                                       p_cod_prot_delibera  VARCHAR2,
                                       p_cod_prot_pacchetto VARCHAR2,
                                       p_dta_scadenza       DATE,
                                       utente               VARCHAR2)
    RETURN NUMBER;

    -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE congela i dati generali di una rv in fase di controllo dati
  -- %mD 17 oct 2012
  FUNCTION popola_dett_dati_gen_rv(p_cod_abi                     VARCHAR2,
                                   p_cod_ndg                     VARCHAR2,
                                   p_cod_prot_delibera           VARCHAR2,
                                   p_cod_prot_pacchetto          VARCHAR2,
                                   p_val_esp_complessiva         NUMBER,
                                   p_val_tot_fondi_terzi         NUMBER,
                                   p_val_tot_derivati            NUMBER,
                                   p_val_tot_interessi_di_mora   NUMBER,
                                   p_val_esp_complessiva_da_val  NUMBER,
                                   p_val_esp_cassa_qta_cap       NUMBER,
                                   p_val_rett_cassa_qta_cap      NUMBER,
                                   p_val_esp_netta_cassa_qta_cap NUMBER,
                                   p_val_esp_firma               NUMBER,
                                   p_val_rett_firma              NUMBER,
                                   p_val_tot_rett_calcolata      NUMBER,
                                   p_val_tot_rett_progr_parere   NUMBER,
                                   p_val_tot_rett_progr_delib    NUMBER,
                                   p_dta_ultima_delib            DATE,
                                   p_val_rett_rapp_op_delib      NUMBER,
                                   p_val_rett_attuale            NUMBER,
                                   p_val_rett_rapp_firma_delib   NUMBER,
                                   p_val_rett_attuale_firma      NUMBER,
                                   p_val_rett_rapp_firma         NUMBER,
                                   p_dta_scadenza                DATE,
                                   utente                        VARCHAR2)
    RETURN NUMBER;

  -------GESTIONE PIANI -----
  FUNCTION popola_piano_rientro(
                                /*key*/p_cod_abi                 IN t_mcrei_app_piani_rientro.cod_abi%TYPE,
                                p_cod_ndg                 IN t_mcrei_app_piani_rientro.cod_ndg%TYPE,
                                p_cod_protocollo_delibera IN t_mcrei_app_piani_rientro.cod_protocollo_delibera%TYPE,
                                p_cod_rapporto            IN t_mcrei_app_piani_rientro.cod_rapporto%TYPE,
                                p_cod_num_rata            IN t_mcrei_app_piani_rientro.num_rata%TYPE,
                                /*   */
                                p_cod_sndg              IN t_mcrei_app_piani_rientro.cod_sndg%TYPE,
                                p_dta_stima             IN t_mcrei_app_piani_rientro.dta_stima%TYPE,
                                p_dta_scadenza_rata     IN t_mcrei_app_piani_rientro.dta_scadenza_rata%TYPE,
                                p_val_rata              IN t_mcrei_app_piani_rientro.val_rata%TYPE,
                                p_cod_utente            IN t_mcrei_app_piani_rientro.cod_utente%TYPE,
                                p_cod_operatore_ins_upd IN t_mcrei_app_piani_rientro.cod_operatore_ins_upd%TYPE,
                                p_ftecnica              IN VARCHAR2 DEFAULT NULL,
                                p_flg_archiviazione     IN VARCHAR DEFAULT NULL) -- 'Y' in caso di archiviazione necessaria
   RETURN NUMBER;

  FUNCTION elimina_piano_rientro(
                                 /*key*/p_cod_abi                 t_mcrei_app_piani_rientro.cod_abi%TYPE,
                                 p_cod_ndg                 t_mcrei_app_piani_rientro.cod_ndg%TYPE,
                                 p_cod_rapporto            t_mcrei_app_piani_rientro.cod_rapporto%TYPE,
                                 p_cod_protocollo_delibera t_mcrei_app_piani_rientro.cod_protocollo_delibera%TYPE,
                                 p_cod_utente              t_mcrei_app_piani_rientro.cod_utente%TYPE DEFAULT NULL,
                                 p_ftecnica                IN VARCHAR2 DEFAULT NULL,
                                 p_flg_archiviazione       VARCHAR2 DEFAULT NULL,
                                 p_datastima               DATE DEFAULT NULL)
    RETURN NUMBER;

  -- %author Reply
  -- %version 0.1
  -- %usage  Funzione che SETTA LA DATA DELIBERA A LIVELLO DI PACCHETTO IN INPUT
  -- %usage  se valorizzati anche abi e ndg, aggiorna solo la data delibera banca rete
  -- %cd 23 FEB 20112
  FUNCTION update_data_delib_pacch(p_prot_pacch    IN VARCHAR2,
                                   p_data_delibera IN DATE,
                                   p_utente        IN VARCHAR2,
                                   p_abi           VARCHAR2 DEFAULT NULL,
                                   p_ndg           VARCHAR2 DEFAULT NULL,
                                   p_prot_delibera VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION popola_dett_delib_transaz(p_cod_abi                   IN t_mcrei_app_delibere.cod_abi%TYPE,
                                     p_cod_ndg                   IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                     p_cod_protocollo_pacchetto  IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                     p_cod_protocollo_delibera   IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                     p_val_rinuncia_capitale     IN t_mcrei_app_delibere.val_rinuncia_capitale%TYPE,
                                     p_val_rinuncia_mora         IN t_mcrei_app_delibere.val_rinuncia_mora%TYPE,
                                     p_dta_scadenza_transazione  IN t_mcrei_app_delibere.dta_scadenza_transaz%TYPE,
                                     p_flg_tasso_base_appl       IN t_mcrei_app_delibere.val_tasso_base_appl%TYPE,
                                     p_desc_note                 IN t_mcrei_app_delibere.desc_note%TYPE,
                                     f_no_garanzie_capienti      IN t_mcrei_app_delibere.flg_no_garanzie_capienti%TYPE,
                                     f_no_colleg_altre_pos       IN t_mcrei_app_delibere.flg_no_colleg_altre_pos%TYPE,
                                     f_no_rischi_firma           IN t_mcrei_app_delibere.flg_no_rischi_firma%TYPE,
                                     f_perdur_difficolta_econ    IN t_mcrei_app_delibere.flg_perdur_difficolta_econ%TYPE,
                                     f_no_patrimon_aggred        IN t_mcrei_app_delibere.flg_no_patrimon_aggred%TYPE,
                                     f_no_presupposti_class_soff IN t_mcrei_app_delibere.flg_no_presupposti_class_soff%TYPE,
                                     f_no_gruppo_economico       IN t_mcrei_app_delibere.flg_no_gruppo_economico%TYPE)
    RETURN NUMBER;

  -- %author Reply
  -- %version 0.1
  -- %usage  Procedura di popolamento manuale dei campi delle delibere di transazione
  -- %cd 27 mar 2012
  FUNCTION popola_man_dett_delib_transaz(p_cod_abi                   IN t_mcrei_app_delibere.cod_abi%TYPE,
                                         p_cod_ndg                   IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                         p_cod_protocollo_pacchetto  IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                         p_cod_protocollo_delibera   IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                         p_val_rinuncia_capitale     IN t_mcrei_app_delibere.val_rinuncia_capitale%TYPE,
                                         p_val_rinuncia_mora         IN t_mcrei_app_delibere.val_rinuncia_mora%TYPE,
                                         p_dta_scadenza_transazione  IN t_mcrei_app_delibere.dta_scadenza_transaz%TYPE,
                                         p_flg_tasso_base_appl       IN t_mcrei_app_delibere.val_tasso_base_appl%TYPE,
                                         p_desc_note                 IN t_mcrei_app_delibere.desc_note%TYPE,
                                         f_no_garanzie_capienti      IN t_mcrei_app_delibere.flg_no_garanzie_capienti%TYPE,
                                         f_no_colleg_altre_pos       IN t_mcrei_app_delibere.flg_no_colleg_altre_pos%TYPE,
                                         f_no_rischi_firma           IN t_mcrei_app_delibere.flg_no_rischi_firma%TYPE,
                                         f_perdur_difficolta_econ    IN t_mcrei_app_delibere.flg_perdur_difficolta_econ%TYPE,
                                         f_no_patrimon_aggred        IN t_mcrei_app_delibere.flg_no_patrimon_aggred%TYPE,
                                         f_no_presupposti_class_soff IN t_mcrei_app_delibere.flg_no_presupposti_class_soff%TYPE,
                                         f_no_gruppo_economico       IN t_mcrei_app_delibere.flg_no_gruppo_economico%TYPE)
    RETURN NUMBER;

  -- %author Reply
  -- %version 0.1
  -- %usage  Procedura di creazione di un pacchetto monodelibera a seguito della chiamata batch del BS
  -- %cd 28 FEB 2012
  PROCEDURE crea_pacchetto_batch(p_cod_abi       IN VARCHAR2,
                                 p_cod_ndg       IN VARCHAR2,
                                 p_tipo_proposta IN VARCHAR2,
                                 --(E oppure S)
                                 p_anno_proposta     IN t_mcrei_app_delibere.val_anno_proposta%TYPE,
                                 p_progre_proposta   IN t_mcrei_app_delibere.val_progr_proposta%TYPE,
                                 p_uo                IN t_mcrei_app_delibere.cod_uo_proposta%TYPE,
                                 p_pos_da_cedere     IN T_MCREI_APP_DELIBERE.FLG_POSIZ_DA_CEDERE%type,
                                 out_proto_delibera  OUT VARCHAR2,
                                 out_proto_pacchetto OUT VARCHAR2,
                                 out_esito           OUT NUMBER);

  -- %author Reply
  -- %version 0.1
  -- %d  Procedura di salvataggio dei valori di rettifica da spalmare sui rapporti per le RDV
  -- %d  Se p_box = 'CA', p_rettifica = valore della rettifica che verr? spalmata tramite algoritmo sui rapporti
  -- %d  Se p_box = 'FI', p_rettifica = percentuale di rettifica che verr? spalmata tramite algoritmo sui rapporti
  -- %param P_RETTIFICA: valore di rettifica o percentuale di rettifica
  -- %param P_BOX: CA se si sta salvando il valore della rettifica, FI se si sta salvando la percentuale
  -- %cd 14 MAR 2012
  -- %md 04 mag 2012: inserito flg_archiviazione ma attualmente non viene gestito
  FUNCTION popola_tot_rett_da_spalmare(p_cod_abi            VARCHAR2,
                                       p_cod_ndg            VARCHAR2,
                                       p_cod_prot_delibera  VARCHAR2,
                                       p_cod_prot_pacchetto VARCHAR2,
                                       p_rettifica          NUMBER,
                                       p_box                VARCHAR2,
                                       utente               VARCHAR2,
                                       p_flg_archiviazione  VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  -- %author Reply
  -- %version 0.1
  -- %d  Procedura di creazione di un pacchetto monodelibera corrispondente ad un EXTRADELIBERA
  -- %cd 15 MAR 2012
  /*FUNCTION crea_pacchetto_extra_del(p_sndg       IN VARCHAR2,
  p_abi        IN VARCHAR2,
  p_ndg        IN VARCHAR2,
  p_utente_ins IN VARCHAR2) RETURN VARCHAR2;*/

  -- %author Reply
  -- %version 0.1
  -- %usage  Procedura di salvataggio dei dati risultanti dal calcolo dell'OD
  -- %cd 22 MAR 2012
  FUNCTION popola_dati_out_od(p_abi                       IN t_mcre0_app_od_calcolati.cod_abi%TYPE,
                              p_ndg                       IN t_mcre0_app_od_calcolati.cod_ndg%TYPE,
                              p_proto_pacch               IN t_mcre0_app_od_calcolati.cod_protocollo_pacchetto%TYPE,
                              pc_microtipologia           IN t_mcre0_app_od_calcolati.cod_microtipologia%TYPE,
                              pv_imp_rdv                  IN t_mcre0_app_od_calcolati.val_imp_rdv%TYPE,
                              pv_rinuncia                 IN t_mcre0_app_od_calcolati.val_rinuncia%TYPE,
                              pv_imp_lim_gest             IN t_mcre0_app_od_calcolati.val_imp_lim_gest%TYPE,
                              pv_durata                   IN t_mcre0_app_od_calcolati.val_durata%TYPE,
                              pv_tur                      IN t_mcre0_app_od_calcolati.val_tur%TYPE,
                              pv_perc_perdita             IN t_mcre0_app_od_calcolati.val_perc_perdita%TYPE,
                              pf_fattori_mitiganti        IN t_mcre0_app_od_calcolati.flg_fattori_mitiganti%TYPE,
                              pdc_fattori_mitiganti       IN t_mcre0_app_od_calcolati.desc_fattori_mitiganti%TYPE,
                              pv_ind_dim_oc_conc          IN t_mcre0_app_od_calcolati.val_ind_dim_oc_conc%TYPE,
                              pv_tot_od_conc_gb           IN t_mcre0_app_od_calcolati.vat_tot_od_conc_gb%TYPE,
                              pv_tot_od_conc              IN t_mcre0_app_od_calcolati.val_tot_od_conc%TYPE,
                              pc_rif_calcolo_od_conc      IN t_mcre0_app_od_calcolati.cod_rif_calcolo_od_conc%TYPE,
                              pc_organo_gestionale        IN t_mcre0_app_od_calcolati.cod_organo_gestionale%TYPE,
                              pc_progr_organo_gest        IN t_mcre0_app_od_calcolati.cod_progr_organo_gest%TYPE,
                              pc_organo_concessione       IN t_mcre0_app_od_calcolati.cod_organo_concessione%TYPE,
                              pc_progr_organo_concessione IN t_mcre0_app_od_calcolati.cod_progr_organo_concessione%TYPE,
                              pc_organo_massimo           IN t_mcre0_app_od_calcolati.cod_organo_massimo%TYPE,
                              pc_progr_organo_massimo     IN t_mcre0_app_od_calcolati.cod_progr_organo_massimo%TYPE,
                              pv_rinuncia_ins             IN t_mcre0_app_od_calcolati.val_rinuncia_ins%TYPE DEFAULT NULL,
                              pv_rinuncia_conf            IN t_mcre0_app_od_calcolati.val_rinuncia_conf%TYPE DEFAULT NULL,
                              pv_rinuncia_cont            IN t_mcre0_app_od_calcolati.val_rinuncia_cont%TYPE DEFAULT NULL,
                              pv_imp_rdv_ins              IN t_mcre0_app_od_calcolati.val_imp_rdv_ins%TYPE DEFAULT NULL,
                              pv_imp_rdv_conf             IN t_mcre0_app_od_calcolati.val_imp_rdv_conf%TYPE DEFAULT NULL,
                              pv_imp_utilizzato           IN t_mcre0_app_od_calcolati.val_imp_utilizzato%TYPE DEFAULT NULL,
                              p_esito_rc_clone            IN t_mcre0_app_od_calcolati.cod_esito_rc_clone%TYPE DEFAULT NULL,
                              p_tot_utilizzato_gb         IN t_mcre0_app_od_calcolati.val_tot_utilizzato_gb%TYPE DEFAULT NULL,
                              p_tot_utilizzato_ir         IN t_mcre0_app_od_calcolati.val_tot_utilizzato_ir%TYPE DEFAULT NULL,
                              p_tot_rwa_in_var_su_gb      IN t_mcre0_app_od_calcolati.val_tot_rwa_in_var_su_gb%TYPE DEFAULT NULL,
                              p_tot_rwa_a_new_ord_su_gb   IN t_mcre0_app_od_calcolati.val_tot_rwa_a_new_ord_su_gb%TYPE DEFAULT NULL,
                              p_tot_rwa_a_new_cons_su_gb  IN t_mcre0_app_od_calcolati.val_tot_rwa_a_new_cons_su_gb%TYPE DEFAULT NULL,
                              p_tot_rwa_in_essere_su_ir   IN t_mcre0_app_od_calcolati.val_tot_rwa_in_essere_su_ir%TYPE DEFAULT NULL,
                              p_tot_rwa_in_var_su_ir      IN t_mcre0_app_od_calcolati.val_tot_rwa_in_var_su_ir%TYPE DEFAULT NULL,
                              p_tot_rwa_a_new_ord_su_ir   IN t_mcre0_app_od_calcolati.val_tot_rwa_a_new_ord_su_ir%TYPE DEFAULT NULL,
                              p_tot_rwa_a_new_cons_su_ir  IN t_mcre0_app_od_calcolati.val_tot_rwa_a_new_cons_su_ir%TYPE DEFAULT NULL,
                              p_tot_rwa_in_essere_su_gb   IN t_mcre0_app_od_calcolati.val_tot_rwa_in_essere_su_gb%TYPE DEFAULT NULL)
    RETURN NUMBER;
  -- %author Reply
  -- %version 0.1
  -- %usage  Procedura di cancellazione dei dati risultanti dal calcolo dell'OD
  -- %cd 12 APR 2012
  FUNCTION pulisci_dati_out_od(p_proto_pacch IN t_mcre0_app_od_calcolati.cod_protocollo_pacchetto%TYPE)
    RETURN NUMBER;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  FUNCTION CHE AGGIUNGE UNA DELIBERA di Stralcio IN STATO CT AD UN PACCHETTO GIo ESISTENTE
  -- (E NON ANCORA CONFERMATO ?)
  -- %D LA FUNCTION CREA, PER IL PACCHETTO PASSATO IN INPUT, una sola delibera per abi, ndg passati
  -- %D nel pacchetto passato; il protocollo collettivo della nuova delibera verra' popolato
  -- %D con il parametro p_ptoto_delib_coll, che deve essere quello della delibera di Transazione
  -- %D che ha scatenato la generazione automatica della DELIBERA di Stralcio
  -- %D DI DELIBERE
  -- %cd 6 APR 2012
  -- %PARAM P_ABI
  -- %PARAM P_NDG
  -- %PARAM P_PROTO_DELIB
  -- %PARAM P_PROTO_PACCHETTO
  -- %PARAM P_MICROTIPOLO
  -- %PARAM P_UTE_INSE
  FUNCTION aggiungi_microtipologia_ct(p_cod_abi                 IN t_mcrei_app_delibere.cod_abi%TYPE,
                                      p_cod_ndg                 IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                      p_proto_delib             IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                      p_proto_pacchetto         IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                      p_microtipolo             IN t_mcrei_app_delibere.cod_microtipologia_delib%TYPE,
                                      p_ute_inse                IN t_mcrei_app_delibere.cod_matricola_inserente%TYPE,
                                      p_cod_fase_microtipologia IN t_mcrei_app_delibere.cod_fase_microtipologia%TYPE,
                                      p_v_stralcio_quota_cap    IN t_mcrei_app_delibere.val_stralcio_quota_cap%TYPE,
                                      p_v_stralcio_quota_mora   IN t_mcrei_app_delibere.val_stralcio_quota_mora%TYPE)
    RETURN VARCHAR2;

  -- %AUTHOR Reply
  -- %VERSION 0.1
  -- %D  function che data la delibera di rettifica in input, reimposta i valori di rettifica
  -- %D  IN tutte le delibere presenti nel pacchetto e create prima che la delibera di rettifica inclusa nel
  -- %D  pacchetto fosse completata
  -- %CD 02 mag 2012
  -- %PARAM P_PROTO_PACCHETTO
  -- %PARAM p_proto_delibera: protocollo della delibera T4 di cui si sono appena controllati i dati
  -- %PARAM p_cod_abi
  -- %PARAM p_cod_ndg
  -- %PARAM p_microt_delib
  -- %PARAM p_rdv_progr_ca: rdv progressiva di cassa digitata dall'utente nella delibera T4 corrente
  -- %PARAM p_rdv_progr_fi: rdv progressiva di firma digitata dall'utente nella delibera T4 corrente
  -- %PARAM p_utente: utente utilizzato per il log dell'attivit?
  FUNCTION aggiorna_valori_pregressi(p_proto_pacchetto IN VARCHAR2,
                                     p_proto_delibera  IN VARCHAR2,
                                     p_cod_abi         IN VARCHAR2,
                                     p_cod_ndg         IN VARCHAR2,
                                     p_microt_delib    IN VARCHAR2,
                                     p_rdv_progr_ca    IN NUMBER,
                                     p_rdv_progr_fi    IN NUMBER,
                                     p_utente          IN VARCHAR2)
    RETURN NUMBER;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  Function che salva i dati di una delibera di Ristrutturazione
  -- %d La function aggiorna i dati presenti sulle Delibere e sulla tabella
  -- %d di storico delle Ristrutturazioni. Se la ristrutturazione non S
  -- %d registrata nello storico, allora viene inserita.
  -- %cd 09 MAG 2012
  -- %PARAM P_ABI Not Null
  -- %PARAM P_NDG Not Null
  -- %PARAM P_PROTO_DELIB Not Null
  -- %PARAM P_PROTO_PACCHETTO Not Null
  -- %PARAM P_UTE_INSE
  FUNCTION popola_man_dett_ristr(p_cod_abi             IN t_mcrei_app_delibere.cod_abi%TYPE,
                                 p_cod_ndg             IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                 p_proto_pacchetto     IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                 p_proto_delib         IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                 p_microtip            IN t_mcrei_app_delibere.cod_microtipologia_delib%TYPE,
                                 p_tipo_ristr          IN t_mcrei_app_delibere.desc_tipo_ristr%TYPE,
                                 p_desc_intento_rist   IN t_mcrei_app_delibere.desc_intento_ristr%TYPE,
                                 p_data_scadenza_ristr IN t_mcrei_app_delibere.dta_scadenza_ristr%TYPE,
                                 p_ute_inse            IN t_mcrei_app_delibere.cod_matricola_inserente%TYPE,
                                 p_salv_or_conf        IN VARCHAR2 DEFAULT 'S')
    RETURN NUMBER;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  Function che congela i dati di una delibera di Ristrutturazione
  -- %d La function aggiorna i dati presenti sulle Delibere e sulla tabella
  -- %d di storico delle Ristrutturazioni. Se la ristrutturazione non S
  -- %d registrata nello storico, allora viene inserita.
  -- %cd 09 MAG 2012
  -- %PARAM P_ABI Not Null
  -- %PARAM P_NDG Not Null
  -- %PARAM P_PROTO_DELIB Not Null
  -- %PARAM P_PROTO_PACCHETTO Not Null
  -- %PARAM P_UTE_INSE
  FUNCTION popola_dett_ristr(p_cod_abi            IN t_mcrei_app_delibere.cod_abi%TYPE,
                             p_cod_ndg            IN t_mcrei_app_delibere.cod_ndg%TYPE,
                             p_proto_pacchetto    IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                             p_proto_delib        IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                             p_microtip           IN t_mcrei_app_delibere.cod_microtipologia_delib%TYPE,
                             p_tipo_ristr         IN t_mcrei_app_delibere.desc_tipo_ristr%TYPE,
                             p_desc_intento_rist  IN t_mcrei_app_delibere.desc_intento_ristr%TYPE,
                             p_dta_scadenza_ristr IN t_mcrei_app_delibere.dta_scadenza_ristr%TYPE,
                             p_ute_inse           IN t_mcrei_app_delibere.cod_matricola_inserente%TYPE)
    RETURN NUMBER;
  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  Function che salva i dati di una stima relativa ad un rapporto
  -- su cui S stata effetuata una Ristrutturazione
  -- %d La function aggiorna i dati presenti sulle Delibere e sulla tabella
  -- %d di storico delle Ristrutturazioni. Se la ristrutturazione non S
  -- %d registrata nello storico, allora viene inserita.
  -- %cd 09 MAG 2012
  -- %PARAM P_ABI Not Null
  -- %PARAM P_NDG Not Null
  -- %PARAM P_PROTO_DELIB Not Null
  -- %PARAM P_PROTO_PACCHETTO Not Null
  -- %PARAM P_UTE_INSE
  FUNCTION popola_man_dett_rapp_ristr(p_cod_abi           IN t_mcrei_app_delibere.cod_abi%TYPE,
                                      p_cod_ndg           IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                      p_proto_pacchetto   IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                      p_proto_delib       IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                      p_cod_ftecnica      IN t_mcrei_app_stime.cod_forma_tecnica%TYPE, --???
                                      p_flg_tipo_dato     IN t_mcrei_app_stime.flg_tipo_dato%TYPE,
                                      p_cod_rapporto      IN t_mcrei_app_stime.cod_rapporto%TYPE,
                                      p_flg_ristrutturato IN t_mcrei_app_stime.flg_ristrutturato%TYPE,
                                      p_ute_inse          IN t_mcrei_app_stime.cod_utente%TYPE,
                                      p_salv_or_conf       IN VARCHAR2 DEFAULT 'S')
    RETURN NUMBER;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  Function che congela i dati di una stima relativa ad un rapporto
  -- su cui S stata effetuata una Ristrutturazione
  -- %d La function aggiorna i dati presenti sulle Delibere e sulla tabella
  -- %d di storico delle Ristrutturazioni. Se la ristrutturazione non S
  -- %d registrata nello storico, allora viene inserita.
  -- %cd 09 MAG 2012
  -- %PARAM P_ABI Not Null
  -- %PARAM P_NDG Not Null
  -- %PARAM P_PROTO_DELIB Not Null
  -- %PARAM P_PROTO_PACCHETTO Not Null
  -- %PARAM P_COD_FTECNICA Not null, quando sar? inserito in chiave
  -- %PARAM P_FLG_TIPO_DATO Not null da togliere quando cod_ftecnica entrera in chiave
  -- %PARAM P_UTE_INSE
  FUNCTION popola_dett_rapp_ristr(p_cod_abi           IN t_mcrei_app_delibere.cod_abi%TYPE,
                                  p_cod_ndg           IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                  p_proto_pacchetto   IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                  p_proto_delib       IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                  p_cod_ftecnica      IN t_mcrei_app_stime.cod_forma_tecnica%TYPE, --???
                                  p_flg_tipo_dato     IN t_mcrei_app_stime.flg_tipo_dato%TYPE,
                                  p_cod_rapporto      IN t_mcrei_app_stime.cod_rapporto%TYPE,
                                  p_flg_ristrutturato IN t_mcrei_app_stime.flg_ristrutturato%TYPE,
                                  p_ute_inse          IN t_mcrei_app_stime.cod_utente%TYPE,
                                  p_flg_da_alert      IN t_mcrei_hst_rapp_ristr.flg_da_alert%TYPE DEFAULT 'N')
    RETURN NUMBER;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  Function che congela i dati di una delibera di Chiusura di Ristrutturazione
  -- %d La function aggiorna i dati presenti sulle Delibere e sulla tabella
  -- %d di storico delle Ristrutturazioni. Se la ristrutturazione non S
  -- %d registrata nello storico, allora viene inserita.
  -- %cd 09 MAG 2012
  -- %PARAM P_ABI Not Null
  -- %PARAM P_NDG Not Null
  -- %PARAM P_PROTO_DELIB Not Null
  -- %PARAM P_PROTO_PACCHETTO Not Null
  -- %PARAM P_UTE_INSE UTENTE
  FUNCTION popola_dett_del_ch_ristr(p_cod_abi            IN t_mcrei_app_delibere.cod_abi%TYPE,
                                    p_cod_ndg            IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                    p_proto_pacchetto    IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                    p_proto_delibera     IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE, -- chiusura di ristrutturazione
                                    p_cod_microtipologia IN t_mcrei_app_delibere.cod_microtipologia_delib%TYPE,
                                    p_causale_chiusura   IN t_mcrei_app_delibere.cod_causa_chius_delibera%TYPE,
                                    p_stato_post_ristr   IN VARCHAR2 DEFAULT NULL,
                                    p_desc_note          IN t_mcrei_app_delibere.desc_note%TYPE,
                                    p_ute_inse           IN t_mcrei_app_delibere.cod_matricola_inserente%TYPE,
                                    -------------------------------------------------------------------------------------
                                    p_tipo_ristr         IN VARCHAR2 DEFAULT NULL,
                                    p_intento_ristr      IN VARCHAR2 DEFAULT NULL,
                                    p_dta_scadenza_ristr IN DATE DEFAULT NULL,
                                    p_flg_rdv            IN VARCHAR2)
    RETURN NUMBER;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  Function che salva i dati di una delibera di Chiusura di Ristrutturazione
  -- %d La function aggiorna i dati presenti sulle Delibere e sulla tabella
  -- %d di storico delle Ristrutturazioni. Se la ristrutturazione non S
  -- %d registrata nello storico, allora viene inserita.
  -- %cd 09 MAG 2012
  -- %PARAM P_ABI Not Null
  -- %PARAM P_NDG Not Null
  -- %PARAM P_PROTO_DELIB Not Null
  -- %PARAM P_PROTO_PACCHETTO Not Null
  -- %PARAM P_UTE_INSE UTENTE
  FUNCTION popola_man_dett_del_ch_ristr(p_cod_abi            IN t_mcrei_app_delibere.cod_abi%TYPE,
                                        p_cod_ndg            IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                        p_proto_pacchetto    IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                        p_proto_delibera     IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                        p_cod_microtipologia IN t_mcrei_app_delibere.cod_microtipologia_delib%TYPE,
                                        p_causale_chiusura   IN t_mcrei_app_delibere.cod_causa_chius_delibera%TYPE,
                                        p_stato_post_ristr   IN VARCHAR2 DEFAULT NULL,
                                        p_desc_note          IN t_mcrei_app_delibere.desc_note%TYPE,
                                        p_ute_inse           IN t_mcrei_app_delibere.cod_matricola_inserente%TYPE,
                                        -------------------------------------------------------------------------------------
                                        p_tipo_ristr         IN VARCHAR2 DEFAULT NULL,
                                        p_intento_ristr      IN VARCHAR2 DEFAULT NULL,
                                        p_dta_scadenza_ristr IN DATE DEFAULT NULL,
                                        p_flg_rdv            IN VARCHAR2)
    RETURN NUMBER;

  -- %AUTHOR REPLY
  -- %VERSION 0.2
  -- %USAGE  FUNZIONE CHE MODIFICA L'ABILITAZIONE DELLA DELIBERA INDICATA IN INPUT
  -- %D  LA FUNZIONE, PER IL PACCHETTO IN INPUT, SETTA PER LA DELIBERA CORRISPONDENTE
  -- %D  AL PROTOCOLLO DELIBERA IN INPUT IL FLAG DI ABILITAZIONE IN INPUT
  -- %CD 09 MAG 2012
  -- %PARAM P_PROT_PACCH
  -- %PARAM P_NDG
  -- %PARAM P_ABI
  -- %PARAM P_PROT_DELIB
  -- %PARAM P_FLG_RISTR 'Y' OPPURE 'N'
  -- %PARAM P_UTENTE -->MATRICOLA CHE EFFETTUA L'UPDATE
  FUNCTION setta_flg_ristr(p_abi            IN VARCHAR2,
                           p_ndg            IN VARCHAR2,
                           p_prot_delib     IN VARCHAR2,
                           p_prot_pacchetto IN VARCHAR2,
                           p_flg_ristr      IN VARCHAR2,
                           p_utente         IN VARCHAR2) RETURN NUMBER;

  FUNCTION insert_hst_ristrutturazioni(p_dta_scadenza             IN DATE,
                                       p_cod_abi                  IN VARCHAR2,
                                       p_cod_ndg                  IN VARCHAR2,
                                       p_cod_protocollo_delibera  IN VARCHAR2,
                                       p_cod_protocollo_pacchetto IN VARCHAR2,
                                       p_desc_tipo_ristr          IN VARCHAR2,
                                       p_desc_intento_ristr       IN VARCHAR2,
                                       p_cod_stato_proposto       IN VARCHAR2,
                                       p_cod_matricola_ins        IN VARCHAR2,
                                       p_cod_microtipologia_delib IN VARCHAR2,
                                       p_flg_rdv                  IN VARCHAR2,
                                       v_dta_effic                IN DATE,
                                       v_dta_efficacia_add        IN DATE DEFAULT NULL,
                                       v_dta_chiusura_ristr       IN DATE DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION update_hst_ristrutturazioni(p_dta_scadenza             IN DATE,
                                       p_cod_abi                  IN VARCHAR2,
                                       p_cod_ndg                  IN VARCHAR2,
                                       p_cod_protocollo_delibera  IN VARCHAR2,
                                       p_cod_protocollo_pacchetto IN VARCHAR2,
                                       p_desc_tipo_ristr          IN VARCHAR2,
                                       p_desc_intento_ristr       IN VARCHAR2,
                                       p_cod_stato_proposto       IN VARCHAR2,
                                       p_cod_matricola_ins        IN VARCHAR2,
                                       p_cod_microtipologia_delib IN VARCHAR2,
                                       p_flg_rdv                  IN VARCHAR2,
                                       v_dta_efficacia_ristr      IN DATE,
                                       v_dta_efficacia_add        IN DATE,
                                       v_dta_chiusura_ristr       IN DATE DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION popola_effic_add_hst_ristr(p_cod_abi                  IN VARCHAR2,
                                      p_cod_ndg                  IN VARCHAR2,
                                      p_cod_protocollo_delibera  IN VARCHAR2,
                                      p_cod_protocollo_pacchetto IN VARCHAR2,
                                      p_desc_tipo_ristr          IN VARCHAR2,
                                      p_desc_intento_ristr       IN VARCHAR2,
                                      p_cod_stato_proposto       IN VARCHAR2,
                                      p_cod_matricola_ins        IN VARCHAR2,
                                      p_cod_microtipologia_delib IN VARCHAR2,
                                      p_flg_rdv                  IN VARCHAR2,
                                      p_flg_upd_add              IN VARCHAR2,
                                      p_flg_ins_add              IN VARCHAR2,
                                      p_flg_pop_ris              IN VARCHAR2,
                                      p_dta_scadenza             IN DATE)
    RETURN NUMBER;

  -- %AUTHOR REPLY
  -- %VERSION 0.2
  -- %USAGE  FUNZIONE INDICA LA PRESENZA O MENO DI UNA RISTRUTTURAZIONE IN CORSO PER LA POSIZIONE IN INPUT
  -- %CD 05 GIU
  -- %RETURN -> 1: ESISTE, 0: NON ESISTE, -1: ERRORE DELLA FUNCTION
  FUNCTION esiste_ristrutturazione(p_cod_abi IN VARCHAR2,
                                   p_cod_ndg IN VARCHAR2) RETURN NUMBER;
  /*
     Recupera il protocollo  della delibera precedente a quella di chiusura passata
     per argomento. Se esisre duplica tutte le stime assocciate al protocollo precedente
     e le inserisce con P_PROTO_DELIBERA.

     P_PROTO_DELIBERA Codice protocollo delibera di chiusura
  */
  FUNCTION duplica_rapporti_ristr(p_cod_abi        IN t_mcrei_app_stime.cod_abi%TYPE,
                                  p_cod_ndg        IN t_mcrei_app_stime.cod_ndg%TYPE,
                                  p_proto_delibera IN t_mcrei_app_stime.cod_protocollo_delibera%TYPE)
    RETURN NUMBER;

  -- %AUTHOR REPLY
  -- %VERSION 0.2
  -- %USAGE  FUNZIONE Che setta il flg_ristrutturato a 'N' di un insieme di rapporti
  -- %D lA FUNZIONE SETTA IL FLG_RISTRUTTURATO A 'N' DEI RAPPORTI INDIVIDUATI DAL
  -- %D PROTOCOLLO DELIBERA PASSATO PER ARGOMENTO;
  -- %D DA CHIAMARE POST CONFERMA BS
  -- %PARAM P_PROT_DELIB PROTOCOLLO DELIBERA ASSOCCIATO AD UNA DELIBERA DI CHIUSURA RISTRUTTURAZIONE
  -- %CD 18 GIU
  FUNCTION setta_flg_rapp_ristr_chiusura(p_abi        IN VARCHAR2,
                                         p_ndg        IN VARCHAR2,
                                         p_prot_delib IN VARCHAR2)
    RETURN NUMBER;


  FUNCTION archivia_stime(p_proto_delibera     VARCHAR2,
                          p_cod_rapporto       VARCHAR2,
                          p_flg_tipo_dato      VARCHAR2,
                          p_tipo_archiviazione VARCHAR2,
                          p_utente             VARCHAR2,
                          p_flg_estint         VARCHAR2,
                          p_dta_stima          DATE) RETURN NUMBER;


END PKG_MCREI_WEB_UTILITIES;
/
