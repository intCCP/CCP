CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCREI_WEB_UTILITIES" IS
  /*
  Ver        Date              Author             Description
  ---------  ----------      -----------------  ------------------------------------
  1.0        10/11/2011                           Created this package.f
  1.1        22/12/2011       M.Murro             Fix Crea Pacchetto.
  1.2        10/01/2012       M.Murro             Crea Pacchetto, rdv pregressa se CS
  1.3        30/01/2012       M.Murro             fix su get_capogruppo (gestione no_delibera)
  1.4        31/01/2012       M.Murro             fix pareri e gestione flg_no_delibera
  1.5        03/02/2012       M.Murro             fix popola rapporti_proposte
  1.6        07/02/2012       D'Errico            aggiunto filtro NELLA CREA PACCHETTO E NELLA ctrl_esist_pacc_aperto ( esclude pacchetti annullati)
  1.7        08/02/2012       D'Errico            modificato popolamento VAL_NUM_PROGR_DELIBERA IN crea pacchetto per CS
  1.8        13/02/2012       M.Murro             aggiunta retrocedi_wf, aggiornato annulla_pacchetto
  2.0        14/02/2012       M.Murro , Irena     variata gestioen Beni, fix CS, inclusa aggiorna-proposta
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
  5.4        27/03/2012       M.Murro             fix popola_garanzie_proposte
  5.5        28/03/2012       M.Murro             valori pregressi, filtro per fase CO o AD, inizializzo anche post
  5.6        28/03/2012       D'Errico            modificato calcolo esposizione netta post delibera in popola_man_dett_rapp_rv
  5.7        02/04/2012       D'Errico            modificato RECUPERO VALORI PREGRESSI DI FIRMA
  5.8.       03/04/2012       D'Errico            modificato RECUPERO LAST_RDV_PROGRESSIVA eliminando filtro su dta_conferma perche' spesso nulla
  5.9        05/04/2012       M.Murro             aggionto filtro no_delibera legato a stato (10.4 - commentato)
  6.0        11/04/2012       M.Murro             aggiunto recupero e propagazione val_imp_perdita + CT
  6.1        16/04/2012       D'Errico            modificata creazione protocollo delibera in crea pacchetto batch
  6.2        17/04/2012       D'ERRICO            aggiunto proto pacchetto in merge popola_elenco_pareri
  6.3        18/04/2012       M.Murro             fix pacchetto batch (upd)
  6.4        23/04/2012       d'errico            aggiunto filtro su flg_no_delibera in query di recupero valori pregressi
  6.5        23/04/2012       d'errico            aggiunto campo p_ftecnica al popolamento dei rapporti_rv
  6.6        24/04/2012       d'errico            aggiunta fase delibera NA nel recupero dei valori pregressi
  6.7        30/04/2012       E.Pelizzi, Irena    aggiunte funzioni di gestione Ristrutturazioni
  6.8        02/05/2012       D'ERRICO            modificata popola_man_dett_rapp_rv per gestione rapporti con doppia FT da pcr
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
  6.21       28/05/2012       d'errico            eliminato dta_last_upd_delibera dall'ordinamento per il recupero dei valori pregressi
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
                                                  aggiunto calcolo perc_rdv in popola_?man_dett_Rapp_rv e e popola_dett_rapporti_rv
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
  6.58        09/01/2013      d'errico          modifica rimuovi_microtipologia e rimuovi_pacchetto: sostituita delete con update settando fasi come annullate manualmente
  6.59       09/01/2013       gueorguieva         crea_pacchetto e aggiungi_microtipologia creano delibere con flg_no_delibera per le posizioni di area o regione ripristina
  6.59       21/01/2013       gueorguieva         crea_pacchetto e aggiungi_microtipologia creano delibere con flg_no_delibera per le posizioni di area o regione ripristina
  6.60       31/01/2013       georguieva          modificata cambia_fase_delibera per salvare cod_Stato_posiz e dta_dec_Stato_posiz in fase dei conferma delibera
  6.61       01/02/2013       georgiieva          modificata cambia_fase_delibera e aggiungi microtipologia con filtro nel cursore posizioni su comparto non nullo e diverso da #
  6.62       07/02/2013       d'errico            corretto calcolo perc_rinuncia in popola_dett_delib_transaz.Eliminato calcolo perc_rinuncia dal popola_man_dett_delib_transaz
  6.63       15/02/2013       i.gueorguieva       cambia_fase_delibera popolamento dta_scadenza_perm_servizio su t_mcrei_app_posiz_inc_ri
  6.64       1/03/2013        d'errico            aggiunto salvataggio mora sulle stime nella popola_man_dett_rapp_rv (per l'extra_delibera)
  6.65       5/03/2013        d'errico            aggiunta gestione spalamatura data scadenza per le progohe incaglio delle divisioni nelle popola_delib_generiche e popola_man_delib_generiche
  6.66      7/03/2013         d'errico            aggiunto popolamento cod_stato_post_ristr in popola_man_dett_Ristr
  6.67       7/03/2013        d'errico            corretta gestione v_scadenza_stato per CI e CS nel cambia fase delibera
  7.0       13/03/2013        murro               fix crea pacchetto (filtro lfg_active=1 e ricerca stato (nullif se -1), pacchetto_batch(protocollo), ordinamento last rv
  7.1       21/03/2013        d'errico            CORRETTO salvataggio mora E UTILIZZATO sulle stime nella popola_man_dett_rapp_rv (per l'extra_delibera)
  7.2       02/04/2013        gueorguieva         aggiunto popolamento campi storici delibere in crea_pacchetto_batch e cambia_fase_delibera
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
  8.9        14/05/2014       M.Ceru               fix per variazione perimetro DR, aggiunto parametro p_abi_riferimento alla conferma_od
  */
  FUNCTION archivia_piano(p_proto_delibera     VARCHAR2,
                          p_cod_rapporto       VARCHAR2,
                          p_tipo_archiviazione VARCHAR2,
                          p_utente             VARCHAR2,
                          p_datastima          DATE) RETURN NUMBER;

--21/03/2014 spostata firma archivia_stime nello spec, per utilizzarla dal pkg_mcrei_alert_2
--  FUNCTION archivia_stime(p_proto_delibera     VARCHAR2,
--                          p_cod_rapporto       VARCHAR2,
--                          p_flg_tipo_dato      VARCHAR2,
--                          p_tipo_archiviazione VARCHAR2,
--                          p_utente             VARCHAR2,
--                          p_flg_estint         VARCHAR2,
--                          p_dta_stima          DATE) RETURN NUMBER;

  -- ======================== GESTIONE CLASSIFICAZIONI ============================================

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  FUNCTION CHE SALVA I DATI GENERALI DIN UNA DELIBERA DI CLASSIFICAZIONE
  -- %D LA FUNCTION, PER OGNI PROTOCOLLO DI DELIBERA IN INPUT, AGGIORNA GLI ATTRIBUTI PRESENTI
  -- %D NELLA TABELLA DELIBERE RELATIVAMENTE ALLA SEZIONE "DATI GENERALI" DELLA DELIBERA DI
  -- %D CLASSIFICAZIONE
  -- %CD 9 DEC 2011
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
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.POPOLA_DATI_GENERALI';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri in ingresso: ' || p_cod_abi || ', ' ||
              p_cod_ndg || ', ' || p_proto_pacchetto || ', ' ||
              p_proto_delibera;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'UPDATE T_MCREI_APP_DELIBERE popola dati generali:' ||
              p_cod_abi || ', ' || p_cod_ndg || ', ' || p_proto_pacchetto || ', ' ||
              p_proto_delibera;

    UPDATE t_mcrei_app_delibere d
       SET cod_stato_proposto            = p_cod_stato_proposto,
           cod_organo_deliberante        = p_cod_organo_deliberante,
           cod_stato_provenienza         = p_cod_stato_provenienza,
           dta_accensione_prop_rischio   = p_dta_accensione_prop_rischio,
           desc_tipo_gestione            = p_desc_tipo_gestione,
           dta_ins_delibera              = p_dta_ins_delibera,
           cod_uo_proponente             = p_cod_uo_proponente,
           cod_matricola_inserente       = p_cod_matricola_inserente,
           dta_inizio_rapporto_cliente   = p_dta_inizio_rapporto_cliente,
           desc_motivo_pass_rischio      = p_desc_motivo_pass_rischio,
           flg_interven_organi_superiori = p_flg_interven_organi_sup,
           dta_revoca_fido_in_essere     = p_dta_revoca_fido_in_essere,
           val_rischi_indiretti          = p_val_rischiindiretti,
           flg_depositi_collaterali      = p_flg_depositi_collaterali,
           val_uti_tot_scgb              = p_val_uti_tot_scgb,
           flg_affidam_soc_recupero      = p_flg_affidam_soc_recupero,
           flg_soggetto_pot_fallibile    = p_flg_soggetto_pot_fallibile,
           flg_presen_covenants          = p_flg_presen_covenants,
           val_uti_tot_gegb              = p_val_uti_tot_gegb,
           dta_delib_prop_da_proponente  = SYSDATE,
           dta_last_upd_delibera         = SYSDATE,
           cod_sag                       = p_cod_sag,
           cod_stato_sag                 = p_cod_stato_sag,
           dta_calc_conf_sag             = p_dta_calc_conf_sag,
           desc_modal_conferma_sag       = p_desc_modal_conferma_sag,
           dta_last_delibera_fido        = p_dta_last_delibera_fido,
           cod_last_organo_delib_fido    = p_cod_last_organo_delib_fido
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_pacchetto = p_proto_pacchetto
       AND d.cod_protocollo_delibera = p_proto_delibera;

    pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_debug,SQLCODE,SQLERRM,p_note,NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE,SQLERRM, p_note,NULL);
      RETURN const_esito_ko;
  END popola_dati_generali;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  FUNCTION CHE SALVA I DATI GENERALI INSERITI MANUALMENTE DI UNA DELIBERA DI CLASSIFICAZIONE
  -- %D LA FUNCTION, PER OGNI PROTOCOLLO DI DELIBERA IN INPUT, AGGIORNA GLI ATTRIBUTI PRESENTI
  -- %D NELLA TABELLA DELIBERE RELATIVAMENTE ALLA SEZIONE "DATI GENERALI" DELLA DELIBERA DI
  -- %D CLASSIFICAZIONE
  -- %CD 4 GEN 2012
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
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.POPOLA_MAN_DATI_GENERALI';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri in ingresso: ' || p_cod_abi || ', ' ||
              p_cod_ndg || ', ' || p_proto_pacchetto || ', ' ||
              p_proto_delibera;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'UPDATE T_MCREI_APP_DELIBERE popola dati generali manuali' ||
              p_cod_abi || ', ' || p_cod_ndg || ', ' || p_proto_pacchetto || ', ' ||
              p_proto_delibera;

    UPDATE t_mcrei_app_delibere d
       SET desc_motivo_pass_rischio      = p_desc_motivo_pass_rischio,
           dta_motivo_pass_rischio       = p_dta_motivo_pass_rischio,
           flg_interven_organi_superiori = p_flg_interven_organi_sup,
           flg_depositi_collaterali      = p_flg_depositi_collaterali,
           flg_soggetto_pot_fallibile    = p_flg_soggetto_pot_fallibile,
           flg_presen_covenants          = p_flg_presen_covenants
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_pacchetto = p_proto_pacchetto
       AND d.cod_protocollo_delibera = p_proto_delibera;

    pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_debug,SQLCODE,SQLERRM,p_note,NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE, SQLERRM, p_note,NULL);
      RETURN const_esito_ko;
  END popola_man_dati_generali;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  FUNCTION CHE SALVA I DATI CONTABILI DI UNA DELIBERA DI CLASSIFICAZIONE
  -- %D LA FUNCTION, PER OGNI PROTOCOLLO DI DELIBERA IN INPUT, AGGIORNA GLI ATTRIBUTI PRESENTI
  -- %D NELLA TABELLA DELIBERE RELATIVAMENTE ALLA SEZIONE "DATI CONTABILI" DELLA DELIBERA DI
  -- %D CLASSIFICAZIONE
  -- %CD 9 DEC 201?1
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
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.POPOLA_DATI_CONTABILI';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri in ingresso: ' || p_cod_abi || ', ' ||
              p_cod_ndg || ', ' || p_proto_pacchetto || ', ' ||
              p_proto_delibera;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'UPDATE T_MCREI_APP_DELIBERE popola dati contabili' ||
              p_cod_abi || ', ' || p_cod_ndg || ', ' || p_proto_pacchetto || ', ' ||
              p_proto_delibera;

    UPDATE t_mcrei_app_delibere d
       SET (dta_rif_dati_contabili,
            VAL_PERC_DUBBIO_ESITO,
            --dta_scadenza_incaglio,---non viene pi? salvata in questo momento, ma solo al cambio_Fase_Delibera in 'CA'
            val_accordato,
            val_esp_lorda,
            flg_fondo_terzi,
            val_uti_netto_fondo_terzi,
            val_uti_firma_scsb,
            val_uti_sosti_scsb,
            val_esp_lorda_capitale,
            val_esp_lorda_mora,
            val_uti_cassa_scsb, --31 maggio
            val_uti_tot_scsb) =
           (SELECT data_aggiornamento_dati,
                   P_VAL_PERC_DUBBIO_ESITO,
                   --scadenza_incaglio,
                   totale_accordato,
                   totale_utilizzato,
                   p_val_fondo_terzi,
                   tot_uti_al_netto_fondo_terzi,
                   p_val_uti_firma_scsb,
                   p_val_uti_sosti_scsb,
                   p_val_esp_lorda_capitale,
                   p_val_esp_lorda_mora,
                   c.utilizzato_di_cassa,
                   totale_utilizzato
              FROM v_mcrei_app_dati_contabili c
             WHERE cod_abi = p_cod_abi
               AND cod_ndg = p_cod_ndg
               AND cod_protocollo_delibera = p_proto_delibera
               AND cod_protocollo_pacchetto = p_proto_pacchetto)
     WHERE d.cod_protocollo_pacchetto = p_proto_pacchetto
       AND d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_delibera = p_proto_delibera;

  IF P_DTA_SCADENZA IS NOT NULL
     THEN
       UPDATE T_MCREI_APP_DELIBERE D
       SET D.DTA_SCADENZA = P_DTA_SCADENZA,
           D.DTA_SCADENZA_INCAGLIO = P_dta_scadenza
       WHERE d.cod_protocollo_pacchetto = p_proto_pacchetto
         AND D.COD_ABI = P_COD_ABI
         AND D.COD_NDG = P_COD_NDG
         AND D.COD_MICROTIPOLOGIA_DELIB = 'CI';
     END IF;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE,SQLERRM, p_note,NULL);
      RETURN const_esito_ko;
  END popola_dati_contabili;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  FUNCTION CHE SALVA I DATI CONTABILI DI UNA DELIBERA DI CLASSIFICAZIONE
  -- %D LA FUNCTION, PER OGNI PROTOCOLLO DI DELIBERA IN INPUT, AGGIORNA GLI ATTRIBUTI PRESENTI
  -- %D NELLA TABELLA DELIBERE RELATIVAMENTE ALLA SEZIONE "DATI CONTABILI" DELLA DELIBERA DI
  -- %D CLASSIFICAZIONE
  -- %CD 4 GEN 2012
  FUNCTION popola_man_dati_contabili(p_proto_pacchetto       IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                     p_proto_delibera        IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                     p_cod_abi               IN t_mcrei_app_delibere.cod_abi%TYPE,
                                     p_cod_ndg               IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                     P_VAL_PERC_DUBBIO_ESITO IN T_MCREI_APP_DELIBERE.VAL_PERC_DUBBIO_ESITO%TYPE,
                                     p_dta_scad              IN T_MCREI_APP_DELIBERE.DTA_SCADENZA%TYPE DEFAULT NULL)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.POPOLA_MAN_DATI_CONTABILI';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri in ingresso: ' || p_cod_abi || ', ' ||
              p_cod_ndg || ', ' || p_proto_pacchetto || ', ' ||
              p_proto_delibera;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'UPDATE T_MCREI_APP_DELIBERE popola dati contabili manuali' ||
              p_cod_abi || ', ' || p_cod_ndg || ', ' || p_proto_pacchetto || ', ' ||
              p_proto_delibera;

    UPDATE T_MCREI_APP_DELIBERE D
       SET D.VAL_PERC_DUBBIO_ESITO = P_VAL_PERC_DUBBIO_ESITO
     WHERE d.cod_protocollo_pacchetto = p_proto_pacchetto
       AND D.COD_ABI = P_COD_ABI
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_delibera = p_proto_delibera;

     IF P_DTA_SCAD IS NOT NULL
     THEN
       UPDATE T_MCREI_APP_DELIBERE D
       SET DTA_SCADENZA = P_DTA_SCAD
       WHERE d.cod_protocollo_pacchetto = p_proto_pacchetto
         AND D.COD_ABI = P_COD_ABI
         AND D.COD_NDG = P_COD_NDG
         AND D.COD_MICROTIPOLOGIA_DELIB = 'CI';
     END IF;


    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END popola_man_dati_contabili;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  FUNCTION CHE SALVA I DATI RELATIVI AI RAPPORTI AL MOMENTO DELLA CLASSIFICAZIONE
  -- %D LA FUNCTION, PER OGNI PROTOCOLLO DI DELIBERA IN INPUT, AGGIORNA GLI ATTRIBUTI PRESENTI
  -- %D NELLA TABELLA RAPPORTI_PROPOSTE RELATIVAMENTE ALLE SEZIONI "LISTE RAPPORTI" DELLA DELIBERA DI
  -- %D CLASSIFICAZIONE
  -- %CD 13 DEC 2011
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
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.POPOLA_RAPPORTI_PROPOSTE';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    -- P_NOTE := 'INSERT T_MCREI_APP_RAPPORTI_PROPOSTE POPOLA RAPPORTI PROPOSTE';
    p_note := p_proto_pacchetto || ', ' || p_proto_delibera || ', ' ||
              p_cod_abi || ', ' || p_cod_ndg || ', ' || p_codice_rapporto;
    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    --AGGIORNO I DATI: DELETE/INSERT
    DELETE t_mcrei_app_rapporti_proposte
     WHERE cod_abi = p_cod_abi
       AND cod_ndg = p_cod_ndg
       AND cod_protocollo_delibera = p_proto_delibera
          --!!
       AND cod_rapporto = p_codice_rapporto;

    INSERT INTO t_mcrei_app_rapporti_proposte
      (id_dper,
       cod_abi,
       cod_sndg,
       cod_ndg,
       cod_protocollo_delibera,
       val_anno_proposta,
       val_progr_proposta,
       cod_rapporto,
       val_progr_fido_rp,
       cod_tipo_rapporto_rp,
       flg_ins_manuale_rp,
       dta_upd_rp,
       desc_forma_tecnica_rp,
       cod_natura,
       desc_attr_anagrafico_rp,
       flg_provenienza_sicli,
       cod_tipo_fido_rp,
       cod_categ_rischio_rp,
       val_accordato_rp,
       val_utilizzato_rp,
       val_esp_quota_capitale_rp,
       val_interessi,
       num_rate_rp,
       val_debito_residuo,
       val_rdv_rp,
       flg_attiva,
       cod_classe_ft,
       cod_forma_tecnica)
      (SELECT id_dper,
              cod_abi,
              cod_sndg,
              cod_ndg,
              cod_protocollo_delibera,
              val_anno_proposta,
              val_progr_proposta,
              cod_rapporto,
              val_progr_fido_rp,
              cod_tipo_rapporto_rp,
              flg_ins_manuale_rp,
              dta_upd_rp,
              desc_forma_tecnica_rp,
              cod_natura,
              desc_attr_anagrafico_rp,
              flg_provenienza_sicli,
              cod_tipo_fido_rp,
              cod_categ_rischio_rp,
              val_accordato_rp,
              val_utilizzato_rp,
              val_esp_quota_capitale_rp,
              val_interessi,
              num_rate_rp,
              val_debito_residuo,
              SUM(val_imp_rettifica_att) val_rdv_rp,
              flg_attiva,
              cod_classe_ft,
              cod_forma_tecnica
         FROM (SELECT DISTINCT to_number(to_char(trunc(SYSDATE), 'YYYYMMDD')) id_dper,
                               d.cod_abi,
                               d.cod_sndg,
                               d.cod_ndg,
                               d.cod_protocollo_delibera,
                               d.val_anno_proposta,
                               d.val_progr_proposta,
                               r.cod_rapporto, --P_CODICE_RAPPORTO,
                               0 val_progr_fido_rp,
                               f.cod_tipo_rapporto cod_tipo_rapporto_rp,

                               --AS COD_TIPO_RAPPORTO,
                               NULL flg_ins_manuale_rp,

                               --FLG_INS_MANUALE,
                               SYSDATE dta_upd_rp, -- DTA_UPD_RP,
                               p_desc_forma_tecnica desc_forma_tecnica_rp,
                               f.cod_natura,
                               r.cod_rapporto_attr desc_attr_anagrafico_rp,
                               'N' flg_provenienza_sicli, -- PROV_SICLI,
                               r.cod_tipo_fido cod_tipo_fido_rp,
                               NULL cod_categ_rischio_rp,
                               p_accordato val_accordato_rp,
                               p_utilizzato val_utilizzato_rp,
                               p_di_cui_capitale val_esp_quota_capitale_rp,
                               p_di_cui_mora val_interessi,
                               p_num_rate_impagate num_rate_rp,
                               p_debito_residuo val_debito_residuo,
                               s.val_imp_rettifica_att, -- VAL_RDV_RP,
                               '1' flg_attiva,
                               p_classe_ft cod_classe_ft,
                               r.cod_forma_tecnica cod_forma_tecnica
                 FROM t_mcrei_app_delibere        d,
                      t_mcrei_app_pcr_rapporti    r,
                      t_mcrei_app_stime           s,
                      t_mcre0_app_natura_ftecnica f
                WHERE d.cod_abi = r.cod_abi
                  AND d.cod_ndg = r.cod_ndg
                  AND d.cod_abi = s.cod_abi(+)
                  AND d.cod_ndg = s.cod_ndg(+)
                  AND d.cod_abi = p_cod_abi
                  AND d.cod_ndg = p_cod_ndg
                  AND d.cod_protocollo_delibera = p_proto_delibera
                  AND d.cod_protocollo_pacchetto = p_proto_pacchetto
                  AND d.flg_attiva = '1'
                  AND s.flg_attiva(+) = '1'
                  AND r.cod_rapporto = p_codice_rapporto
                  AND r.cod_forma_tecnica = cod_ftecnica
                  AND cod_ftecnica = p_cod_forma_tecnica)
        GROUP BY id_dper,
                 cod_abi,
                 cod_sndg,
                 cod_ndg,
                 cod_protocollo_delibera,
                 val_anno_proposta,
                 val_progr_proposta,
                 cod_rapporto,
                 val_progr_fido_rp,
                 cod_tipo_rapporto_rp,
                 flg_ins_manuale_rp,
                 dta_upd_rp,
                 desc_forma_tecnica_rp,
                 cod_natura,
                 desc_attr_anagrafico_rp,
                 flg_provenienza_sicli,
                 cod_tipo_fido_rp,
                 cod_categ_rischio_rp,
                 val_accordato_rp,
                 val_utilizzato_rp,
                 val_esp_quota_capitale_rp,
                 val_interessi,
                 num_rate_rp,
                 val_debito_residuo,
                 flg_attiva,
                 cod_classe_ft,
                 cod_forma_tecnica);

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END popola_rapporti_proposte;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  FUNCTION CHE SALVA I DATI DELLE GARANZIE, IN GARANZIE_PROPOSTE, RELATIVI ALLA PROPOSTA/DELIBERA,
  -- %USAGE  INDIVIDATA DAGLI ARGOMENTI PASSATI.
  -- %D LA FUNCTION, PER OGNI PROTOCOLLO DI DELIBERA IN INPUT CERCA, SE E' GIA PRESENTE UNA GARANZIA.
  -- %D SE VIENE TROVATA UNA CORRISPONDENZA VENGONO AGGIORNATI I DATI DELLA GARANZIA,
  -- %D ALTRIMENTI VIENE INSERITA UNA NUOVA GARANZIA ASSOCCIATA AL PROTOCOLLO DI DELIBERA.
  -- %PARAM P_ABI ABI
  -- %PARAM P_NDG NDG
  -- %PARAM P_PROTO_DELIB PROTOCOLLO DI DELIBERA
  -- %PARAM P_PROTO_PACCH PROTOCOLLO DI PACCHETTO
  -- %PARAM P_NOTE_GARANZIE NOTE INTEGRATIVE GARANZIE
  -- %CD 11 GEN 2012
  FUNCTION popola_garanzie_proposte(p_abi            IN t_mcrei_app_garanzie_proposte.cod_abi%TYPE,
                                    p_ndg            IN t_mcrei_app_garanzie_proposte.cod_ndg%TYPE,
                                    p_proto_delib    IN t_mcrei_app_garanzie_proposte.cod_protocollo_delibera%TYPE,
                                    p_proto_pacch    IN t_mcrei_app_garanzie_proposte.cod_protocollo_pacchetto%TYPE,
                                    p_note_gar_ric   IN t_mcrei_app_delibere. desc_note_garanzie_ricevute%TYPE,
                                    p_note_gar_prest IN t_mcrei_app_delibere. desc_note_garanzie_prestate%TYPE)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.POPOLA_GARANZIE_PROPOSTE';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'T_MCREI_APP_GARANZIE_PROPOSTE controllo parametri';

    IF p_abi IS NULL OR
       p_ndg IS NULL OR
       p_proto_delib IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'DELETE T_MCREI_APP_GARANZIE_PROPOSTE popola garanzie proposte';

    DELETE t_mcrei_app_garanzie_proposte gp
     WHERE gp.cod_abi = p_abi
       AND gp.cod_ndg = p_ndg
       AND gp.cod_protocollo_delibera = p_proto_delib;

    p_note := 'INSERT T_MCREI_APP_GARANZIE_PROPOSTE popola garanzie proposte';

    INSERT INTO t_mcrei_app_garanzie_proposte
      (cod_abi,
       cod_ndg,
       cod_garanzia,
       cod_protocollo_delibera,
       cod_protocollo_pacchetto,
       cod_ndg_garante,
       cod_ndg_garantito,
       cod_rapporto,
       cod_forma_tecnica,
       val_imp_garanzia,
       dta_scad_garanzia,
       flg_tipo_copertura,
       cod_stato_garanzia,
       dta_delib_garanzia,
       dta_perf_garanzia,
       cod_abi_cartolarizzato,
       cod_sndg,
       dta_ins,
       cod_operatore_ins_upd)
      SELECT s.cod_abi,
             s.cod_ndg,
             s.cod_garanzia,
             p_proto_delib,
             p_proto_pacch,
             s.cod_ndg_garante,
             s.cod_ndg_garantito,
             s.cod_rapporto,
             s.cod_forma_tecnica,
             s.val_imp_garanzia,
             s.dta_scad_garanzia,
             s.flg_tipo_copertura,
             s.cod_stato_garanzia,
             s.dta_delib_garanzia,
             s.dta_perf_garanzia,
             s.cod_abi_cartolarizzato,
             s.cod_sndg,
             SYSDATE,
             NULL
        FROM t_mcrei_app_garanzie s
       WHERE s.cod_abi = p_abi
         AND s.cod_ndg = p_ndg
         AND (cod_abi, id_dper) IN
            --27.03 (si visualizzano SOLO le garanzie ricevute nell'ultimo flusso)
             (SELECT cod_abi,
                     MAX(id_dper) over(PARTITION BY cod_abi) last_load
                FROM t_mcrei_app_garanzie);

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    p_note := 'UPDATE desc_note_integrative_garanzie di T_MCREI_APP_DELIBERE popola garanzie proposte';

    UPDATE t_mcrei_app_delibere de
       SET de.desc_note_garanzie_ricevute = p_note_gar_ric,
           de.desc_note_garanzie_prestate = p_note_gar_prest
     WHERE de.cod_abi = p_abi
       AND de.cod_ndg = p_ndg
       AND de.cod_protocollo_delibera = p_proto_delib
       AND de.cod_protocollo_pacchetto = p_proto_pacch
       AND de.flg_attiva = '1';

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END popola_garanzie_proposte;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI DELLE DELIBERE INSERITI MANULAMENTE
  -- %D LA FUNCTION, PER OGNI PROTOCOLLO PACCHETTO IN INPUT, AGGIORNA GLI ATTRIBUTI PRESENTI
  -- %D NELLA TABELLA DELIBERE RELATIVAMENTE ALLE SEZIONI "RISCHI", "URGENZE",
  -- %D "CAUSE MANTENIMENTO IMPIEGHI VIVI"", "RIFERIMENTI PRATICA"
  -- %D E "GARANZIE RICEVUTE"
  -- %CD 28 DEC 2011
  -- %CD 4 GEN 2012
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
                                     ---
                                     p_flg_libretti_port_min     IN t_mcrei_app_delibere.flg_libretti_portatore_minori%TYPE,
                                     p_flg_rap_con_depos_titoli  IN t_mcrei_app_delibere.flg_rapporti_con_depos_titoli%TYPE,
                                     p_flg_rapporti_bloccati     IN t_mcrei_app_delibere.flg_rapporti_bloccati%TYPE,
                                     p_flg_rap_garanzia_cred_fir IN t_mcrei_app_delibere.flg_rapporti_garanzia_cred_fir%TYPE,
                                     p_flg_rap_concordato_preven IN t_mcrei_app_delibere.flg_rapporto_concordato_preven%TYPE,
                                     p_flg_conti_categ_2000      IN t_mcrei_app_delibere.flg_conti_categ_2000%TYPE,
                                     ---
                                     p_num_telefono              IN t_mcrei_app_delibere.num_telefono%TYPE,
                                     p_indirizzo_email           IN t_mcrei_app_delibere.indirizzo_email%TYPE,
                                     p_desc_secondo_referente    IN t_mcrei_app_delibere.desc_secondo_referente%TYPE,
                                     p_num_tel_secondo_referente IN t_mcrei_app_delibere.num_tel_secondo_referente%TYPE,
                                     ---
                                     p_desc_note_rischi IN t_mcrei_app_delibere.desc_note_rischi%TYPE,
                                     --- QUESTI CAMPI SONO DEI DATI GENERALI
                                     p_cod_sag                    IN t_mcrei_app_delibere.cod_sag%TYPE,
                                     p_cod_stato_sag              IN t_mcrei_app_delibere.cod_stato_sag%TYPE,
                                     p_dta_calc_conf_sag          IN t_mcrei_app_delibere.dta_calc_conf_sag%TYPE,
                                     p_desc_modal_conferma_sag    IN t_mcrei_app_delibere.desc_modal_conferma_sag%TYPE,
                                     p_dta_last_delibera_fido     IN t_mcrei_app_delibere.dta_last_delibera_fido%TYPE,
                                     p_cod_last_organo_delib_fido IN t_mcrei_app_delibere.cod_last_organo_delib_fido%TYPE)
    RETURN NUMBER IS
    /*  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE ||
                                       '.POPOLA_MAN_RI_URG_CAU_RIF';
    */
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'UPDATE POPOLA_MAN_RI_URG_CAU_RIF popola sezioni Rischi, Urgenze, Cause mantenimento impieghi vivi, Riferimenti Pratica di Delibere';

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    UPDATE t_mcrei_app_delibere d
       SET dta_udienza_ver_cred           = p_dta_udienza_ver_cred,
           flg_esist_debitore_sotto_proc  = p_flg_esist_deb_sotto_proc,
           flg_beni_non_in_garanzia       = p_flg_beni_non_in_garanzia,
           flg_avviso_ex498cpc            = p_flg_avviso_ex498cpc,
           flg_pignoramenti_immobiliari   = p_flg_pignoramenti_immobiliari,
           flg_pignoramenti_mobiliari     = p_flg_pignoramenti_mobiliari,
           flg_pignoramenti_terzi         = p_flg_pignoramenti_terzi,
           flg_protesti                   = p_flg_protesti,
           flg_ipoteche_beni_deb_gar      = p_flg_ipoteche_beni_deb_gar,
           flg_garanzie_sgfa              = p_flg_garanzie_sgfa,
           flg_garanzie_sace              = p_flg_garanzie_sace,
           flg_garanzie_con_fidi          = p_flg_garanzie_con_fidi,
           flg_garanzie_genworth          = p_flg_garanzie_genworth,
           flg_pratica_urg                = p_flg_pratica_urg,
           desc_note_urg                  = p_desc_note_urg,
           flg_forz_man_gest_interna      = p_flg_forz_man_gest_interna,
           desc_note_forzatura            = p_desc_note_forzatura,
           flg_libretti_portatore_minori  = p_flg_libretti_port_min,
           flg_rapporti_con_depos_titoli  = p_flg_rap_con_depos_titoli,
           flg_rapporti_bloccati          = p_flg_rapporti_bloccati,
           flg_rapporti_garanzia_cred_fir = p_flg_rap_garanzia_cred_fir,
           flg_rapporto_concordato_preven = p_flg_rap_concordato_preven,
           flg_conti_categ_2000           = p_flg_conti_categ_2000,
           num_telefono                   = p_num_telefono,
           indirizzo_email                = p_indirizzo_email,
           desc_secondo_referente         = p_desc_secondo_referente,
           num_tel_secondo_referente      = p_num_tel_secondo_referente,
           desc_note_rischi               = p_desc_note_rischi,
           cod_sag                        = p_cod_sag,
           cod_stato_sag                  = p_cod_stato_sag,
           dta_calc_conf_sag              = p_dta_calc_conf_sag,
           desc_modal_conferma_sag        = p_desc_modal_conferma_sag,
           dta_last_delibera_fido         = p_dta_last_delibera_fido,
           cod_last_organo_delib_fido     = p_cod_last_organo_delib_fido
     WHERE d.cod_protocollo_pacchetto = p_proto_pacchetto
       AND d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_delibera = p_proto_delibera;

    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(PKG_MCREI_WEB_UTILITIES.c_package ||
                              '.POPOLA_MAN_RI_URG_CAU_RIF',
                              3,
                              SQLCODE,
                              SQLERRM,
                              p_note || '; abi: ' || p_cod_abi || ' ndg: ' ||
                              p_cod_ndg || ' proto_pacchetto: ' ||
                              p_proto_pacchetto,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_ri_urg_cau_rif;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI DELLE DELIBERE INSERITI MANULAMENTE
  -- %D LA FUNCTION, PER OGNI PROTOCOLLO PACCHETTO IN INPUT, AGGIORNA GLI ATTRIBUTI PRESENTI
  -- %D NELLA TABELLA DELIBERE RELATIVAMENTE ALLA SEZIONE "RISCHI"
  -- %CD 4 GEN 2012
  FUNCTION popola_man_rischi(P_PROTO_PACCHETTO   IN T_MCREI_APP_DELIBERE. COD_PROTOCOLLO_PACCHETTO%TYPE,
                             p_proto_delibera    IN t_mcrei_app_delibere. cod_protocollo_delibera%TYPE,
                             p_cod_abi           IN t_mcrei_app_delibere. cod_abi%TYPE,
                             p_cod_ndg           IN t_mcrei_app_delibere. cod_ndg%TYPE,
                             P_DESC_NOTE_RISCHI  IN T_MCREI_APP_DELIBERE. DESC_NOTE_RISCHI%TYPE,
                             P_COD_MOTIV_INSOLV  IN T_MCREI_APP_DELIBERE.COD_MOTIV_INSOLV%TYPE DEFAULT NULL,
                             P_COD_INFO_TERZI    IN T_MCREI_APP_DELIBERE.COD_INFO_TERZI%TYPE DEFAULT NULL,
                             P_COD_PORTAF_SCAD   IN T_MCREI_APP_DELIBERE.COD_PORTAF_SCAD%TYPE DEFAULT NULL,
                             P_COD_TIPO_CESSIONE IN T_MCREI_APP_DELIBERE.COD_TIPO_CESSIONE%TYPE DEFAULT NULL)
    RETURN NUMBER IS
    --C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.POPOLA_MAN_RISCHI';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'UPDATE POPOLA_MAN_RISCHI popola sezione Rischi di Delibere';

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    UPDATE T_MCREI_APP_DELIBERE D
       SET DESC_NOTE_RISCHI  = P_DESC_NOTE_RISCHI,
           COD_MOTIV_INSOLV  = P_COD_MOTIV_INSOLV,
           COD_INFO_TERZI    = P_COD_INFO_TERZI,
           COD_PORTAF_SCAD   = P_COD_PORTAF_SCAD,
           COD_TIPO_CESSIONE = P_COD_TIPO_CESSIONE
     WHERE d.cod_protocollo_pacchetto = p_proto_pacchetto
       AND d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_delibera = p_proto_delibera;

    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(PKG_MCREI_WEB_UTILITIES.c_package ||
                              '.POPOLA_MAN_RISCHI',
                              3,
                              SQLCODE,
                              SQLERRM,
                              p_note || '; abi: ' || p_cod_abi || ' ndg: ' ||
                              p_cod_ndg || ' proto_pacchetto: ' ||
                              p_proto_pacchetto,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_rischi;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI DELLE DELIBERE INSERITI MANULAMENTE
  -- %D LA FUNCTION, PER OGNI PROTOCOLLO PACCHETTO IN INPUT, AGGIORNA GLI ATTRIBUTI PRESENTI
  -- %D NELLA TABELLA DELIBERE RELATIVAMENTE ALLA SEZIONE "URGENZE"
  -- %CD 4 GEN 2012
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
    RETURN NUMBER IS
    --C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.POPOLA_MAN_URGENZE';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'UPDATE popola_man_urgenze popola sezione Urgenze di Delibere';

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    UPDATE t_mcrei_app_delibere d
       SET dta_udienza_ver_cred          = p_dta_udienza_ver_cred,
           flg_esist_debitore_sotto_proc = p_flg_esist_deb_sotto_proc,
           flg_beni_non_in_garanzia      = p_flg_beni_non_in_garanzia,
           flg_avviso_ex498cpc           = p_flg_avviso_ex498cpc,
           flg_pignoramenti_immobiliari  = p_flg_pignoramenti_immobiliari,
           flg_pignoramenti_mobiliari    = p_flg_pignoramenti_mobiliari,
           flg_pignoramenti_terzi        = p_flg_pignoramenti_terzi,
           flg_protesti                  = p_flg_protesti,
           flg_ipoteche_beni_deb_gar     = p_flg_ipoteche_beni_deb_gar,
           flg_garanzie_sgfa             = p_flg_garanzie_sgfa,
           flg_garanzie_sace             = p_flg_garanzie_sace,
           flg_garanzie_con_fidi         = p_flg_garanzie_con_fidi,
           flg_garanzie_genworth         = p_flg_garanzie_genworth,
           flg_pratica_urg               = p_flg_pratica_urg,
           desc_note_urg                 = p_desc_note_urg,
           flg_forz_man_gest_interna     = p_flg_forz_man_gest_interna,
           desc_note_forzatura           = p_desc_note_forzatura
     WHERE d.cod_protocollo_pacchetto = p_proto_pacchetto
       AND d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_delibera = p_proto_delibera;

    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(PKG_MCREI_WEB_UTILITIES.c_package ||
                              '.POPOLA_MAN_RISCHI',
                              3,
                              SQLCODE,
                              SQLERRM,
                              p_note || '; abi: ' || p_cod_abi || ' ndg: ' ||
                              p_cod_ndg || ' proto_pacchetto: ' ||
                              p_proto_pacchetto,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_urgenze;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI DELLE DELIBERE INSERITI MANULAMENTE
  -- %D LA FUNCTION, PER OGNI PROTOCOLLO PACCHETTO IN INPUT, AGGIORNA GLI ATTRIBUTI PRESENTI
  -- %D NELLA TABELLA DELIBERE RELATIVAMENTE ALLA SEZIONE"CAUSE MANTENIMENTO IMPIEGHI VIVI"
  -- %CD 4 GEN 2012
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
    RETURN NUMBER IS
    --C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE ||
    --         '.POPOLA_MAN_CAUSE_MANTENIM';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'UPDATE POPOLA_MAN_CAUSE_MANTENIM popola sezione Cause mantenimento impieghi vivi di Delibere';

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    UPDATE t_mcrei_app_delibere d
       SET flg_libretti_portatore_minori  = p_flg_libretti_port_min,
           flg_rapporti_con_depos_titoli  = p_flg_rap_con_depos_titoli,
           flg_rapporti_bloccati          = p_flg_rapporti_bloccati,
           flg_rapporti_garanzia_cred_fir = p_flg_rap_garanzia_cred_fir,
           flg_rapporto_concordato_preven = p_flg_rap_concordato_preven,
           flg_conti_categ_2000           = p_flg_conti_categ_2000
     WHERE d.cod_protocollo_pacchetto = p_proto_pacchetto
       AND d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_delibera = p_proto_delibera;

    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(PKG_MCREI_WEB_UTILITIES.c_package ||
                              '.POPOLA_MAN_CAUSE_MANTENIM',
                              3,
                              SQLCODE,
                              SQLERRM,
                              p_note || 'abi: ' || p_cod_abi || ' ndg: ' ||
                              p_cod_ndg || ' proto_pacchetto: ' ||
                              p_proto_pacchetto,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_cause_mantenim;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI DELLE DELIBERE INSERITI MANULAMENTE
  -- %D LA FUNCTION, PER OGNI PROTOCOLLO PACCHETTO IN INPUT, AGGIORNA GLI ATTRIBUTI PRESENTI
  -- %D NELLA TABELLA DELIBERE RELATIVAMENTE ALLA SEZIONE "RIFERIMENTI PRATICA"
  -- %CD 4 GEN 2012
  FUNCTION popola_man_riferimenti_pratica(p_proto_pacchetto           IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                          p_proto_delibera            IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                          p_cod_abi                   IN t_mcrei_app_delibere.cod_abi%TYPE,
                                          p_cod_ndg                   IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                          p_num_telefono              IN t_mcrei_app_delibere.num_telefono%TYPE,
                                          p_indirizzo_email           IN t_mcrei_app_delibere.indirizzo_email%TYPE,
                                          p_desc_secondo_referente    IN t_mcrei_app_delibere.desc_secondo_referente%TYPE,
                                          p_num_tel_secondo_referente IN t_mcrei_app_delibere.num_tel_secondo_referente%TYPE)
    RETURN NUMBER IS
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'UPDATE POPOLA_MAN_RIFERIMENTI_PRATICA popola sezione Riferimenti pratica di Delibere';

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    UPDATE t_mcrei_app_delibere d
       SET num_telefono              = p_num_telefono,
           indirizzo_email           = p_indirizzo_email,
           desc_secondo_referente    = p_desc_secondo_referente,
           num_tel_secondo_referente = p_num_tel_secondo_referente
     WHERE d.cod_protocollo_pacchetto = p_proto_pacchetto
       AND d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_delibera = p_proto_delibera;

    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(PKG_MCREI_WEB_UTILITIES.c_package ||
                              '.POPOLA_MAN_CAUSE_MANTENIM',
                              3,
                              SQLCODE,
                              SQLERRM,
                              p_note || '; abi: ' || p_cod_abi || ' ndg: ' ||
                              p_cod_ndg || ' proto_pacchetto: ' ||
                              p_proto_pacchetto,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_riferimenti_pratica;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI DEI PARERI INSERITI MANULAMENTE
  -- %D LA FUNCTION, PER OGNI IDENTIFICATIVO DI PARERE E PROTOCOLLO DELIBERA, RICEVUTI IN INPUT
  -- %D AGGIORNA GLI ATTRIBUTI PRESENTI NELLA TABELLA PARERI RELATIVAMENTE
  -- %D ALLA SEZIONE"ELENCO PARERI"
  -- %CD 24 GEN 2012
  -- %MD 2 FEB 2012: AGGIUNTO PASSAGGIO DEL P_UTENTE
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
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.POPOLA_ELENCO_PARERI';
    p_note           t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_capo_gruppo    t_mcrei_app_pareri.cod_abi%TYPE;
    v_flg_capogruppo VARCHAR2(1);

    CURSOR c_del IS
      SELECT cod_abi,
             cod_ndg,
             cod_sndg,
             val_anno_proposta,
             cod_protocollo_delibera,
             cod_protocollo_pacchetto,

             --p_cod_tipo_par,  modificato il 20 marzo
             decode(p_cod_microtipol,
                    'CS',
                    decode(p_cod_tipo_par,
                           'F01',
                           'F05',
                           'A01',
                           'F09',
                           'A07',
                           'F10',
                           p_cod_tipo_par),
                    'CZ',
                    decode(p_cod_tipo_par,
                           'F01',
                           'F05',
                           'A01',
                           'F09',
                           'A07',
                           'F10',
                           p_cod_tipo_par),
                    p_cod_tipo_par) AS p_cod_tipo_par,
             val_progr_proposta,
             p_desc_parere,
             p_desc_parere_esteso
        FROM t_mcrei_app_delibere
       WHERE cod_protocollo_pacchetto = p_cod_protocollo_pacchetto
         AND cod_microtipologia_delib = p_cod_microtipol
         AND COD_FASE_PACCHETTO NOT IN ('ANM','ANA');

    CURSOR c_del_1 IS
      SELECT cod_abi,
             cod_ndg,
             cod_sndg,
             val_anno_proposta,
             cod_protocollo_delibera,
             cod_protocollo_pacchetto,

             --p_cod_tipo_par,  modificato il 20 marzo
             decode(p_cod_microtipol,
                    'CS',
                    decode(p_cod_tipo_par,
                           'F01',
                           'F05',
                           'A01',
                           'F09',
                           'A07',
                           'F10',
                           p_cod_tipo_par),
                    'CZ',
                    decode(p_cod_tipo_par,
                           'F01',
                           'F05',
                           'A01',
                           'F09',
                           'A07',
                           'F10',
                           p_cod_tipo_par),
                    p_cod_tipo_par) AS p_cod_tipo_par,
             val_progr_proposta,
             p_desc_parere,
             p_desc_parere_esteso
        FROM t_mcrei_app_delibere
       WHERE cod_protocollo_pacchetto = p_cod_protocollo_pacchetto
         AND cod_abi = p_cod_abi
         AND cod_ndg = p_cod_ndg
         AND cod_protocollo_delibera = p_cod_protocollo_delibera;

    v_prog_parere NUMBER := 0;
  BEGIN
    p_note := 'POPOLA_ELENCO_PARERI popola campi manuali Pareri';

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_cod_protocollo_delibera IS NULL OR
       p_cod_tipo_par IS NULL OR
       p_cod_protocollo_pacchetto IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    IF p_spalma_parere = 'Y'
    THEN
      v_capo_gruppo := PKG_MCREI_WEB_UTILITIES.get_capogruppo(p_cod_protocollo_pacchetto);
    ELSE
      v_capo_gruppo := '-';
    END IF;

    IF v_capo_gruppo = p_cod_abi
    THEN
      FOR r_del IN c_del
      LOOP
        v_prog_parere := v_prog_parere + 1;

        IF r_del.cod_abi = v_capo_gruppo
        THEN
          v_flg_capogruppo := 'Y';
        ELSE
          v_flg_capogruppo := 'N';
        END IF;

        MERGE INTO t_mcrei_app_pareri t
        USING (SELECT p_cod_abi,
                      p_cod_ndg,
                      --R_DEL.P_COD_PROTOCOLLO_DELIBERA,
                      p_cod_protocollo_pacchetto,
                      p_cod_microtipol,
                      p_cod_tipo_par,
                      p_desc_parere,
                      p_desc_parere_esteso
                 FROM dual) s
        ON (r_del.cod_abi = t.cod_abi AND r_del.cod_ndg = t.cod_ndg AND r_del. p_cod_tipo_par = t.cod_tipo_par AND r_del.cod_protocollo_delibera = t.cod_protocollo_delibera AND r_del.cod_protocollo_pacchetto = t.cod_protocollo_pacchetto)
        WHEN MATCHED THEN
          UPDATE
             SET t.desc_parere        = r_del.p_desc_parere,
                 t.dta_upd            = SYSDATE,
                 t.flg_difforme       = 'N',
                 t.desc_parere_esteso = r_del.p_desc_parere_esteso,
                 t.cod_utente         = p_utente,
                 t.cod_uo             = p_uo
        WHEN NOT MATCHED THEN
          INSERT
            (t.id_dper,
             t.cod_abi,
             t.id_parere,
             t.cod_protocollo_delibera,
             t.cod_progr_parere,
             t.desc_parere,
             t.cod_tipo_par,
             t.dta_ins_parere,
             t.cod_ndg,
             t.val_anno_proposta,
             t.val_progr_proposta,
             t.flg_attiva,
             t.dta_ins,
             t.dta_upd,
             t.flg_parere_capogruppo,
             t.cod_sndg,
             t.cod_protocollo_pacchetto,
             flg_difforme,
             t.desc_parere_esteso,
             t.cod_utente,
             t.cod_uo)
          VALUES
            (to_number(to_char(trunc(SYSDATE), 'yyyymmdd')),
             r_del.cod_abi,
             to_number('9' || lpad(seq_mcrei_pareri.nextval, 10, '0')),

             ---modificato da 8 a 9 il 27/2
             r_del.cod_protocollo_delibera,
             lpad(v_prog_parere, 5, '0'),
             r_del.p_desc_parere,
             r_del.p_cod_tipo_par,
             nvl(p_dta_ins_parere, SYSDATE),
             r_del.cod_ndg,
             r_del.val_anno_proposta,
             r_del.val_progr_proposta,
             1,
             SYSDATE,
             SYSDATE,
             v_flg_capogruppo,
             r_del.cod_sndg,
             r_del.cod_protocollo_pacchetto,
             'N',
             r_del.p_desc_parere_esteso,
             p_utente,
             p_uo);
      END LOOP;
    ELSE
      FOR r_del IN c_del_1
      LOOP
        v_prog_parere := v_prog_parere + 1;
        MERGE INTO t_mcrei_app_pareri t
        USING (SELECT p_cod_abi,
                      p_cod_ndg,

                      -- R_DEL.COD_PROTOCOLLO_DELIBERA,
                      p_cod_protocollo_pacchetto,
                      p_cod_tipo_par,
                      p_desc_parere,
                      p_desc_parere_esteso
                 FROM dual) s
        ON (r_del.cod_abi = t.cod_abi AND r_del.cod_ndg = t.cod_ndg AND r_del. p_cod_tipo_par = t.cod_tipo_par AND r_del.cod_protocollo_delibera = t.cod_protocollo_delibera)
        WHEN MATCHED THEN
          UPDATE
             SET t.desc_parere        = r_del.p_desc_parere,
                 t.dta_upd            = SYSDATE,
                 t.flg_difforme       = nvl(p_flg_difforme, 'Y'),
                 t.desc_parere_esteso = r_del.p_desc_parere_esteso,
                 t.cod_utente         = p_utente,
                 t.cod_uo             = p_uo
        WHEN NOT MATCHED THEN
          INSERT
            (t.id_dper,
             t.cod_abi,
             t.id_parere,
             t.cod_protocollo_delibera,
             t.cod_progr_parere,
             t.desc_parere,
             t.cod_tipo_par,
             t.dta_ins_parere,
             t.cod_ndg,
             t.val_anno_proposta,
             t.val_progr_proposta,
             t.flg_attiva,
             t.dta_ins,
             t.dta_upd,
             t.flg_parere_capogruppo,
             t.cod_sndg,
             t.cod_protocollo_pacchetto,
             t.flg_difforme,
             t.desc_parere_esteso,
             t.cod_utente,
             t.cod_uo)
          VALUES
            (to_number(to_char(trunc(SYSDATE), 'yyyymmdd')),
             r_del.cod_abi,
             to_number('8' || lpad(seq_mcrei_pareri.nextval, 10, '0')),
             r_del.cod_protocollo_delibera,
             lpad(v_prog_parere, 5, '0'),
             r_del.p_desc_parere,
             r_del.p_cod_tipo_par,
             SYSDATE,
             r_del.cod_ndg,
             r_del.val_anno_proposta,
             r_del.val_progr_proposta,
             1,
             SYSDATE,
             SYSDATE,
             'N',
             r_del.cod_sndg,
             r_del.cod_protocollo_pacchetto,
             nvl(p_flg_difforme, 'Y'),
             r_del.p_desc_parere_esteso,
             p_utente,
             p_uo);
      END LOOP;
    END IF;

    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              3,
                              SQLCODE,
                              SQLERRM,
                              'abi: ' || p_cod_abi || ' ndg: ' || p_cod_ndg ||
                              ' cod_garanzia: ' || p_note,
                              p_utente);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_elenco_pareri;

  --FUNZIONE RICHIAMATA A SEGUITO DI IMPIANTO PROPOSTA:
  --SETTA ANNO E PROGRESSIVO PROPOSTA SULLE TABELLE APPENA POPOLATE
  FUNCTION aggiorna_proposta(delibera             IN VARCHAR2,
                             pacchetto            IN VARCHAR2,
                             abi                  IN VARCHAR2,
                             ndg                  IN VARCHAR2,
                             anno_proposta        IN NUMBER,
                             progressivo_proposta IN NUMBER) RETURN NUMBER IS
    c_nome VARCHAR2(50) := c_package || '.AGGIORNA_PROPOSTA';
    v_dove VARCHAR2(30) := 'inizio';
    ok     NUMBER := 1;
    ko     NUMBER := 0;
  BEGIN
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            'pacchetto: ' || pacchetto || ' delibera: ' ||
                            delibera || ' abi: ' || abi || ' proposta: ' ||
                            progressivo_proposta,
                            '');
    v_dove := 'T_MCREI_APP_DELIBERE';

    UPDATE t_mcrei_app_delibere
       SET val_anno_proposta  = anno_proposta,
           val_progr_proposta = progressivo_proposta
     WHERE cod_abi = abi
       AND cod_ndg = ndg
       AND cod_protocollo_delibera = delibera
       AND cod_protocollo_pacchetto = pacchetto;

    v_dove := 'T_MCREI_APP_PARERI';

    UPDATE t_mcrei_app_pareri
       SET val_anno_proposta  = anno_proposta,
           val_progr_proposta = progressivo_proposta
     WHERE cod_abi = abi
       AND cod_ndg = ndg
       AND cod_protocollo_delibera = delibera;

    v_dove := 'T_MCREI_APP_RAPPORTI_PROPOSTE';

    UPDATE t_mcrei_app_rapporti_proposte
       SET val_anno_proposta  = anno_proposta,
           val_progr_proposta = progressivo_proposta
     WHERE cod_abi = abi
       AND cod_ndg = ndg
       AND cod_protocollo_delibera = delibera;

    v_dove := 'T_MCREI_APP_BENI_PROPOSTE';

    UPDATE t_mcrei_app_beni_proposte
       SET val_anno_proposta  = anno_proposta,
           val_progr_proposta = progressivo_proposta
     WHERE cod_abi = abi
       AND cod_ndg = ndg
       AND cod_protocollo_delibera = delibera
       AND cod_protocollo_pacchetto = pacchetto;

    RETURN ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome || ' ' || v_dove,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              'pacchetto: ' || pacchetto || ' delibera: ' ||
                              delibera || ' abi: ' || abi || ' proposta: ' ||
                              progressivo_proposta,
                              '');
      RETURN ko;
  END aggiorna_proposta;

  -- ============== GESTIONE PACCHETTO, MICROTIPOLOGIA E DELIBERA =================================
  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE GESTISCE LO STEP DI CREAZIONE PACCHETTO E/O CREAZIONE DELIBERA
  -- %D  LA FUNZIONE EFFETTUA CONTROLLI ED OPERAZIONI NECESSARIE ALLA CREAZIONE DI UN PACCHETTO
  -- %D  O ALLA AGGIUNTA DI UNA NUOVA DELIBERA. GLI STEP ESEGUITI SONO I SEGUENTI:
  -- %D
  -- %D    * CONTROLLA ESISTENZA PACCHETTO APERTO PER L'SNDG IN INPUT
  -- %D    * SE NON ESISTE UN PACCHETTO APERTO (IN STATO N? CNF N? ULT), ALLORA:
  -- %D           --> CREA UN NUOVO PACCHETTO, GENERANDO I PROTOCOLLI DELLE DELIBERE
  -- %D               PER GLI NDG ASSOCIATI AL SNDG
  -- %D    * SE ESISTE UN PACCHETTO APERTO (IN STATO N? CNF N? ULT), ALLORA:
  -- %D           --> AGGIUNGE SOLO LE DELIBERE, GENERANDO I PROTOCOLLI DELLE DELIBERE
  -- %D               PER GLI NDG ASSOCIATI AL SNDG
  -- %CD 7 NOV 2011
  -- %PARAM P_SNDG: SUPER NDG
  -- %PARAM P_MICROTIPOL
  -- %PARAM P_UTE_INS
  FUNCTION imposta_microtipologia(p_sndg       IN VARCHAR2,
                                  p_microtipol IN VARCHAR2,
                                  p_ute_ins    IN VARCHAR2,
                                  P_FLG_FORZ_IMP IN VARCHAR2 DEFAULT 'N'
                                  ,P_COD_GRUPPO_SUPER IN VARCHAR2 default NULL--DR
                                  ) RETURN VARCHAR2 IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.IMPOSTA_MICROTIPOLOGIA';
    v_proto_pacchetto t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    p_note            t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_tipo            VARCHAR2(200);
    v_dta_creaz       DATE;
  BEGIN
    p_note := 'IMPOSTA_MICROTIPOLOGIA';

    IF p_sndg IS NULL OR
       p_microtipol IS NULL OR
       p_ute_ins IS NULL
    THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              'p_sndg ' || p_sndg || 'p_microtipol ' ||
                              p_microtipol,
                              p_note,
                              NULL);
      raise_application_error(-20666, 'Null parameter');
    END IF;

    ---CONTROLLA ESISTENZA PACCHETTO APERTO PER L'SNDG IN INPUT
    v_proto_pacchetto := ctrl_esist_pacc_aperto(p_sndg,p_cod_gruppo_super);--DR

    IF v_proto_pacchetto IS NULL
    THEN
      p_note := 'CREAZIONE NUOVO PACCHETTO, AGGIUNGENDO ANCHE LE DELIBERE CON LA GENERAZIONE ';
      --CREA UN NUOVO PACCHETTO, AGGIUNGENDO ANCHE LE DELIBERE CON LA GENERAZIONE
      --ANCHE I PROTOCOLLI DELLE DELIBERE PER GLI NDG ASSOCIATI
      v_proto_pacchetto := crea_pacchetto(p_sndg         => p_sndg,
                                          p_microtipolog => p_microtipol,
                                          p_utente_ins   => p_ute_ins,
                                          P_FLG_FORZ_IMP => P_FLG_FORZ_IMP);
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_ute_ins);
    ELSE
      --      IF P_MICROTIPOL IN ('CI', 'CS')
      --      THEN
      --        RETURN V_PROTO_PACCHETTO;
      --      END IF;
      ---AGGIUNGO CONTROLLO DI ESISTENZA DELLA MICROTIPOLGOIA NEL PACCHETTO
      BEGIN
        SELECT 1 ---SE ESISTE GIA' LA MICROTIPOLOGIA, RITORNO ERRORE
          INTO v_tipo
          FROM t_mcrei_app_delibere d
         WHERE d.cod_protocollo_pacchetto = v_proto_pacchetto
           AND d.cod_microtipologia_delib = p_microtipol
           AND d.cod_fase_delibera != 'AN'
           AND rownum = 1;

        RETURN v_proto_pacchetto;
        ---SI STA CERCANDO DI AGGIUNGERE UNA TIPOLOGIA GIA' PRESENTE IN UN PACCHETTO APERTO
      EXCEPTION
        WHEN no_data_found THEN
          ---recupera la dta_creazione pacchetto da utilizzare nella successiva insert
          SELECT min(dta_creazione_pacchetto) --- in presenza eventuale di pi¿ delibere, prende cmq la minima
            INTO v_dta_creaz
            FROM t_mcrei_app_delibere d
           WHERE d.cod_protocollo_pacchetto = v_proto_pacchetto
            AND COD_FASE_PACCHETTO NOT IN ('ANM','ANA')
            AND rownum = 1;

          p_note := 'PER LA MICROTIPOLOGIA IN INPUT, INSERISCE TANTE DELIBERE QUANTI SONO GLI NDG COLLEGATI AL SNDG';
          -- PER LA MICROTIPOLOGIA IN INPUT, INSERISCE TANTE DELIBERE QUANTI SONO GLI NDG COLLEGATI AL SNDG
          v_proto_pacchetto := aggiungi_microtipologia(p_proto_pacchetto => v_proto_pacchetto,
                                                       p_sndg            => p_sndg,
                                                       p_microtipolog    => p_microtipol,
                                                       p_utente_ins      => p_ute_ins,
                                                       p_dta_creaz       => v_dta_creaz,
                                                                                                             P_FLG_FORZ_IMP => P_FLG_FORZ_IMP);
          pkg_mcrei_audit.log_app(c_nome,
                                  pkg_mcrei_audit.c_debug,
                                  SQLCODE,
                                  SQLERRM,
                                  p_note,
                                  p_ute_ins);
      END;
    END IF;

    RETURN v_proto_pacchetto;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_ute_ins);
      RETURN const_esito_ko;
  END imposta_microtipologia;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE CREA IL PACCHETTO DI DELIBERE ASSOCIATE ALL'SNDG IN INPUT.
  -- %D  LA FUNZIONE E' RESPONSABILE DELLA CREAZIONE DI UN PACCHETTO DI DELIBERE ASSOCIATE AL SNDG IN QUESTIONE
  -- %D   QUANDO L'UTENTE SELEZIONA UNA MICROTIPOLOGIA, VIENE EFFETTUATO IL CONTROLLO PACCHETTO:
  -- %D
  -- %D     * SE ESISTE UN PROTOCOLLO DI PACCHETTO ASSOCIATO AL SNDG IN UNA FASE NON ANCORA CONFERMATA,
  -- %D       ALLORA SI AGGIUNGONO LE DELIBERE SUGLI NDG COLLEGATI AL SNDG, ASSOCIANDOGLI IL PROTOCOLLO DI PACCHETTO ESISTENTE
  -- %D     * SE NON ESISTE UN PROTOCOLLO DI PACCHETTO ASSOCIATO AL SNDG OPPURE ESISTE MA IN FASE CONFERMATA,
  -- %D       ALLORA:
  -- %D         --> VIENE GENERATO UN NUOVO PROTOCOLLO DI PACCHETTO
  -- %D         --> SI AGGIUNGONO LE DELIBERE SUGLI NDG COLLEGATI AL SNDG, ASSOCIANDOLE AL NUOVO PROTOCOLLO DI PACCHETTO GENERATO
  -- %D
  -- %D  IN PRATICA, LA CREAZIONE DEL PACCHETTO HA LO SCOPO DI CREARE NELLA TABELLA T_MCREI_APP_DELIBERE
  -- %D  TANTI RECORD QUANTI SONO GLI NDG COLLEGATI AL SNDG. QUESTA OPERAZIONE VIENE RIPETUTA PER TUTTE LE
  -- %D  MICROTIPOLOGIE DI DELIBERA CHE VENGONO SCELTE DALL'UTENTE. IN OGNI RECORD SARo NECESSARIO POPOLARE
  -- %D  GLI ATTRIBUTI DI DELIBERE E DI PACCHETTO
  -- %CD 7 NOV 2011
  -- %PARAM P_SNDG: SUPER NDG
  -- %PARAM P_MICROTIPOLOG: MICROTIPOLOGIA DI DELIBERA
  -- %PARAM P_UTENTE_INS
  FUNCTION crea_pacchetto(p_sndg         IN VARCHAR2,
                          p_microtipolog IN VARCHAR2,
                          p_utente_ins   IN VARCHAR2,
                          P_FLG_FORZ_IMP IN VARCHAR2 DEFAULT 'N') RETURN VARCHAR2 IS

    c_nome CONSTANT VARCHAR2(100) := c_package || '.CREA_PACCHETTO';
    v_prot                  t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    p_note                  t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_cod_proto_del_pre     t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
    v_flg_ristr             VARCHAR2(1);
    v_proto_delib           t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
    v_cod_uo                t_mcrei_app_pratiche.cod_uo_pratica%TYPE;
    v_dta_inizio_segn_ristr DATE;
    v_dta_fine_segn_ristr   DATE;
    v_flg_ristrutturato     VARCHAR2(1);
    V_IS_DI_REG_O_AR        BOOLEAN;
    V_CREA_DELIBERA         NUMBER:=1;
    V_COMPARTO_UTENTE       T_MCRE0_APP_UTENTI.COD_COMPARTO_UTENTE%TYPE;

    CURSOR posizioni(v_sndg VARCHAR2, v_microtip VARCHAR2) IS
      SELECT g.cod_abi_cartolarizzato,
             g.cod_ndg,
             g.cod_sndg,
             g.cod_stato,
             nvl(g.cod_comparto_assegnato,g.cod_comparto_calcolato) as cod_comparto,
             g.id_utente,
             u.cod_matricola
        FROM t_mcre0_app_all_data g,
             t_mcrei_cl_tipologie t,
             t_mcre0_app_utenti u
       WHERE g.cod_sndg = v_sndg --AND G.TODAY_FLG = '1'-- SOLO TARGET E OUTSOURCING
         AND g.flg_outsourcing = 'Y'
         AND g.flg_target = 'Y'
         AND t.cod_microtipologia = v_microtip
         AND t.flg_attivo = 1
         AND g.flg_active='1'
         AND g.id_utente = u.id_utente
         and nvl(g.cod_comparto_assegnato,g.cod_comparto_calcolato) is not null
         and LENGTH(nvl(g.cod_comparto_assegnato,g.cod_comparto_calcolato)) > 1; --01/02/2013 in seguto a caso di test

    CURSOR rap_pos(v_abi VARCHAR2, v_ndg VARCHAR2) IS
      SELECT DISTINCT cod_sndg,
                      cod_abi,
                      cod_ndg,
                      cod_rapporto,
                      MAX(cod_forma_tecnica) over(PARTITION BY cod_abi, cod_ndg, cod_rapporto) AS cod_forma_tecnica,
                      MAX(cod_classe_ft) over(PARTITION BY cod_abi, cod_ndg, cod_rapporto) AS cod_classe_ft
        FROM t_mcrei_app_pcr_rapporti
       WHERE cod_abi = v_abi
         AND cod_ndg = v_ndg
         AND flg_attiva = '1';

    v_rec              posizioni%ROWTYPE;
    v_rec_rapp_pos     rap_pos%ROWTYPE;
    val_rdv_qc_progr   NUMBER := 0;
    val_esp_netta_post NUMBER := 0;
    v_delibera_pre     t_mcrei_app_delibere.cod_protocollo_delibera_pre%TYPE;
    v_rdv_progr_fi     NUMBER := 0;
    v_imp_perdita      NUMBER := 0;
    V_dta_chiusura_ristr DATE;
    v_stralcio_ct      NUMBER  :=0;

  BEGIN
    p_note := 'CREA_PACCHETTO';

    IF p_sndg IS NULL OR
       p_microtipolog IS NULL OR
       p_utente_ins IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    SELECT p_sndg || '_' || mcre_own.seq_mcrei_pacchetto.nextval
      INTO v_prot
      FROM dual;
    p_note := 'SNDG: ' || p_sndg || ' TIP: ' || 'p_utente_ins: '||p_utente_ins||' microtip: '||
    p_microtipolog || ' prot: ' ||v_prot||CHR(10);
    ---test sulla microtipologia: se di ristrutturazione, fara' il recupero delle info
    --dall'eventuale ristrutturazione ultima esistente
    SELECT flg_segn_ristr
      INTO v_flg_ristr
      FROM t_mcrei_cl_tipologie
     WHERE flg_attivo = 1
       AND cod_microtipologia = p_microtipolog;

    V_CREA_DELIBERA:=1;
    BEGIN
    SELECT COD_COMPARTO_UTENTE
     INTO V_COMPARTO_UTENTE
     FROM T_MCRE0_APP_UTENTI
    WHERE COD_MATRICOLA = P_UTENTE_INS;
    IF V_COMPARTO_UTENTE IS NOT NULL THEN
    V_IS_DI_REG_O_AR:= PKG_MCREI_WEB_UTILITIES_EVOL.FNC_IS_AR_RG_LIV_AREA(V_COMPARTO_UTENTE);
    ELSE
    V_IS_DI_REG_O_AR:=TRUE;
    P_NOTE:=P_NOTE||'COD_COMPARTO_UTENTE NULL PER '||P_UTENTE_INS||'IN T_MCRE0_APP_UTENTI;'||CHR(10);
    P_NOTE:=P_NOTE||'Si prosegue con comportamento comparto non di area o di regione'||chr(10);
    END IF;
    EXCEPTION WHEN OTHERS THEN
        P_NOTE:=P_NOTE||'Impossibile recuperare il comparto utente per '||P_UTENTE_INS||' a partire da T_MCRE0_APP_UTENTI;'||CHR(10);
    END;

    IF p_microtipolog IN ('CI', 'CS')
    THEN
      OPEN posizioni(p_sndg, p_microtipolog);
      LOOP
        FETCH posizioni INTO v_rec;
        EXIT WHEN posizioni%NOTFOUND;
        V_CREA_DELIBERA:=1;
        IF V_IS_DI_REG_O_AR THEN
        V_CREA_DELIBERA:= 0;
            IF TO_CHAR(V_REC.COD_MATRICOLA) = P_UTENTE_INS THEN V_CREA_DELIBERA:= 1; END IF;
        END IF;
        IF V_CREA_DELIBERA = 0 then
            p_note:=p_note||CHR(10)||'Attenzione: Non creata delibera per '||v_rec.cod_abi_cartolarizzato||
            ' '||v_rec.cod_ndg||' che e'' di area o regione'||
            CHR(10)||' e non e'' assegnata al gestore corrente (o quello per cui si sta operando).'||chr(10);
        END IF;
        IF V_CREA_DELIBERA = 1 THEN
          --0808 se l'ultima delibera contabilizzata  CT recupero la somma degli stralci come perdita iniziale
          begin
            v_stralcio_ct := NVL (pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct(v_rec.cod_abi_cartolarizzato,v_rec.cod_ndg), 0  );
          exception when others then
          v_stralcio_ct := 0;
          end;

          BEGIN
            SELECT   val_rdv_qc_progressiva,val_esp_netta_post_delib,cod_protocollo_delibera,
                     val_rdv_progr_fi,val_imp_perdita
                INTO val_rdv_qc_progr,val_esp_netta_post, v_delibera_pre,
                     v_rdv_progr_fi,v_imp_perdita
                FROM (SELECT nvl(s.val_rdv_qc_progressiva, 0) val_rdv_qc_progressiva,
                             nvl(s.val_esp_netta_post_delib, 0) val_esp_netta_post_delib,
                             s.cod_protocollo_delibera,
                             nvl(s.val_rdv_progr_fi, 0) AS val_rdv_progr_fi,
                             decode(s.cod_fase_delibera,
                                    'CT',
                                    --11 MAGGIO: aaggiunta logica su rinuncia pregressa in caso di CT
                                    --MM 0808: in fase di inizializzazione, la rinuncia pregressa CT S lo stralcio capitalizzato
                                    --nvl(s.val_rinuncia_totale, 0) -
                                    --nvl(val_imp_perdita, 0) +
                                    --nvl(s.val_sacrif_capit_mora, 0),
                                    v_stralcio_ct,
                                    nvl(s.val_imp_perdita, 0)) AS val_imp_perdita--6.0
                        FROM t_mcrei_app_delibere s
                       WHERE s.cod_abi = v_rec.cod_abi_cartolarizzato
                         AND s.cod_ndg = v_rec.cod_ndg
                         AND s.cod_fase_delibera IN ('AD', 'CO', 'CT', 'NA')---aggiunto CT il 11/4, NA il 24/4
                         AND s.flg_no_delibera = 0
                         AND flg_attiva = '1'
                       ORDER BY s.dta_conferma_delibera  DESC,
                                s.val_num_progr_delibera DESC )
               WHERE rownum <= 1;
            EXCEPTION
              WHEN no_data_found THEN
                val_rdv_qc_progr   := 0;
                v_rdv_progr_fi     := 0;
                val_esp_netta_post := 0;
                v_imp_perdita      := 0;
                v_delibera_pre     := '#';
            END;
          INSERT INTO t_mcrei_app_delibere d
              (id_dper,
               cod_sndg,
               cod_abi,
               cod_ndg,
               cod_protocollo_pacchetto,
               cod_protocollo_delibera,
               cod_protocollo_delibera_pre,--tengo il puntatore alla delibera precedente
               flg_attiva,
               cod_microtipologia_delib,
               cod_fase_delibera,
               cod_fase_microtipologia,
               cod_fase_pacchetto,
               dta_creazione_pacchetto,
               dta_ins_delibera,
               cod_tipo_pacchetto,
               cod_matricola_inserente,
               cod_macrotipologia_delib,
               cod_pratica,
               val_anno_pratica,
               cod_uo_pratica,
               cod_segmento,
               desc_denominaz_ins_delibera,
               cod_filiale_delibera,
               val_rdv_qc_progressiva,
               val_esp_netta_post_delib,
               val_rdv_qc_ante_delib,
               val_esp_netta_ante_delib,
               val_num_progr_delibera,
               flg_no_delibera,
               val_rdv_pregr_fi,
               val_rdv_progr_fi,
               val_rinuncia_deliberata,----rinuncia pregressa (v_stralcio_ct)
               val_imp_perdita, --0807
               val_stralcio_senza_accantonam,  ----contiene il valore degli stralci contabilizzati fino al momento della creazione della delibera corrente
               desc_no_delibera
               )
              (SELECT to_number(to_char(trunc(SYSDATE), 'YYYYMMDD')),
                      p_sndg,
                      g.cod_abi_cartolarizzato,
                      g.cod_ndg,
                      v_prot,
                      to_char(SYSDATE, 'YYYY') ||
                      lpad(mcre_own.seq_mcrei_pacchetto.nextval, 13, '0'), --v_proto_delib
                      v_delibera_pre,
                      '1' AS flg_attiva,
                      p_microtipolog,
                      'IN',
                      'INS',
                      'INS',
                      SYSDATE,
                      SYSDATE,
                      'M',
                      p_utente_ins,
                      t.cod_macrotipologia,
                      p.cod_pratica,
                      p.val_anno_pratica,
                      p.cod_uo_pratica,
                      a.val_segmento_regolamentare,
                      (SELECT u.cognome || ' ' || u.nome AS denom_matricola
                         FROM t_mcre0_app_utenti u
                        WHERE u.cod_matricola = p_utente_ins),
                      g.cod_filiale,
                      val_rdv_qc_progr AS val_rdv_qc_progressiva, --29.03
                      pc.scsb_uti_cassa - val_rdv_qc_progr AS val_esp_netta_post_delib,--9 maggio
                      val_rdv_qc_progr AS val_rdv_qc_ante_delib,
                      pc.scsb_uti_cassa - val_rdv_qc_progr AS val_esp_netta_ante_delib,--9 maggio
                      decode(p_microtipolog, 'CI',0,decode(p.cod_pratica,NULL,0, seq_mcrei_prog_del.nextval)),
                      ----VAL_NUM_PROGR_DELIBERA = 0 PER LE CLASSIFICAZIONI SENZA PRATICA
                      CASE
                        WHEN p_microtipolog = 'CI' AND g.cod_stato IN ('IN', 'SO') THEN
                         1
                        WHEN p_microtipolog = 'CS' AND g.cod_stato = 'SO' THEN
                         1
                        WHEN nvl(pc.scsb_acc_tot + pc.scsb_uti_tot, 0) = 0 THEN
                         1
                        WHEN V_CREA_DELIBERA = 0 THEN
                         1
                        ELSE
                         0
                      END fl_no_del,
                      nvl(v_rdv_progr_fi, 0),
                      nvl(v_rdv_progr_fi, 0),
                      v_imp_perdita,
                      v_imp_perdita  AS val_imp_perdita ,--0807
                      v_stralcio_ct,
                      CASE --v8.6
                        WHEN p_microtipolog = 'CI' AND g.cod_stato IN ('IN', 'SO') THEN
                         'Posizione in stato non compatibile'
                        WHEN p_microtipolog = 'CS' AND g.cod_stato = 'SO' THEN
                          'Posizione in stato non compatibile'
                        WHEN nvl(pc.scsb_acc_tot + pc.scsb_uti_tot, 0) = 0 THEN
                         'Posizione con esposizione 0'
                        WHEN V_CREA_DELIBERA = 0 THEN
                         'Posizione non di competenza'
                        ELSE
                         null
                      END as desc_no_delibera
                             FROM t_mcre0_app_all_data          g,
                      t_mcrei_app_pratiche          p,
                      t_mcrei_cl_tipologie          t,
                      t_mcre0_app_anagrafica_gruppo a,
                      t_mcrei_app_pcr_rapp_aggr     pc
                WHERE g.cod_abi_cartolarizzato = v_rec.cod_abi_cartolarizzato
                  AND g.cod_ndg = v_rec.cod_ndg
                  AND g.cod_sndg = a.cod_sndg
                     --AND G.TODAY_FLG = '1'    PRENDO TUTTE LE POSIZIONI, ANCHE NON IN MOPLE
                     --v7.0 uso flg_active
                  AND g.flg_active = '1'
                  AND g.cod_abi_cartolarizzato = p.cod_abi(+)
                  AND g.cod_ndg = p.cod_ndg(+)
                  AND g.cod_abi_cartolarizzato = pc.cod_abi_cartolarizzato(+)
                  AND g.cod_ndg = pc.cod_ndg(+)
                     -- SOLO TARGET E OUTSOURCING
                  AND g.flg_outsourcing = 'Y'
                  AND g.flg_target = 'Y'
                  AND p.flg_attiva(+) = '1'
                  AND t.cod_microtipologia = p_microtipolog
                  AND t.flg_attivo = 1);


                  if sql%rowcount =0 then
                  pkg_mcrei_audit.log_app(c_nome,  pkg_mcrei_audit.c_debug, SQLCODE,
                                        'create '||sql%rowcount||' delibere per il pacchetto '||v_prot,
                                        ' forzo pacchetto a null',   p_utente_ins);
                  --v_prot := NULL;
                  END IF;

       END IF;
      END LOOP;
      CLOSE posizioni;

    ELSE
      OPEN posizioni(p_sndg, p_microtipolog);
      LOOP
        FETCH posizioni INTO v_rec;
        EXIT WHEN posizioni%NOTFOUND;
         V_CREA_DELIBERA:=1;
         IF V_IS_DI_REG_O_AR THEN
            V_CREA_DELIBERA:= 0;
            IF TO_CHAR(V_REC.COD_MATRICOLA) = P_UTENTE_INS THEN V_CREA_DELIBERA:= 1; END IF;
        END IF;
        IF V_CREA_DELIBERA = 0 then
            p_note:=p_note||CHR(10)||'Attenzione: Non creata delibera per '||v_rec.cod_abi_cartolarizzato||
            ' '||v_rec.cod_ndg||' che e'' di area o regione'||
            CHR(10)||' e non e'' assegnata al gestore corrente (o quello per cui si sta operando).'||chr(10);
        END IF;
       IF V_CREA_DELIBERA = 1 THEN
        BEGIN
      --0808 se l'ultima delibera contabilizzata S CT recupero la somma degli stralci come perdita iniziale
          begin
          v_stralcio_ct := NVL (pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct
                                    (v_rec.cod_abi_cartolarizzato,v_rec.cod_ndg), 0  );
          exception when others then
          v_stralcio_ct := 0;
          end;
          SELECT val_rdv_qc_progressiva,
                 val_esp_netta_post_delib,
                 cod_protocollo_delibera,
                 val_rdv_progr_fi,
                 val_imp_perdita
            INTO val_rdv_qc_progr,
                 val_esp_netta_post,
                 v_delibera_pre,
                 v_rdv_progr_fi,
                 v_imp_perdita
            FROM (SELECT nvl(s.val_rdv_qc_progressiva, 0) val_rdv_qc_progressiva,
                         nvl(s.val_esp_netta_post_delib, 0) val_esp_netta_post_delib,
                         s.cod_protocollo_delibera,
                         nvl(s.val_rdv_progr_fi, 0) AS val_rdv_progr_fi,
                         decode(s.cod_fase_delibera,
                                'CT',
                                --11 MAGGIO: aggiunta logica su rinuncia pregressa in caso di CT
                                --MM 0808: in fase di inizializzazione, la rinuncia pregressa CT S lo stralcio capitalizzato
                                --nvl(s.val_rinuncia_totale, 0) -
                                --nvl(val_imp_perdita, 0) +
                                --nvl(s.val_sacrif_capit_mora, 0),
                                v_stralcio_ct,
                                nvl(s.val_imp_perdita, 0)) AS val_imp_perdita
                  --6.0
                    FROM t_mcrei_app_delibere s
                   WHERE s.cod_abi = v_rec.cod_abi_cartolarizzato
                     AND s.cod_ndg = v_rec.cod_ndg
                     AND s.cod_fase_delibera IN ('AD', 'CO', 'CT', 'NA')
                        ---aggiunto CT il 11/4, NA il 24/4
                     AND s.flg_no_delibera = 0
                       ORDER BY s.dta_conferma_delibera  DESC,
                                s.val_num_progr_delibera DESC )
           WHERE rownum <= 1;
        EXCEPTION
          WHEN no_data_found THEN
            val_rdv_qc_progr   := 0;
            v_rdv_progr_fi     := 0;
            val_esp_netta_post := 0;
            v_imp_perdita      := 0;
            v_delibera_pre     := '#';
        END;
        BEGIN
          SELECT p.cod_uo_pratica
            INTO v_cod_uo
            FROM t_mcrei_app_pratiche p
           WHERE p.cod_abi = v_rec.cod_abi_cartolarizzato
             AND p.cod_ndg = v_rec.cod_ndg
             AND flg_attiva = '1'
             AND rownum = 1;
        EXCEPTION
          WHEN no_data_found THEN
            v_cod_uo := NULL;

        END;
        v_proto_delib := mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_protocollo_delibera(v_cod_uo,
                                                                                        p_utente_ins,
                                                                                        v_rec.cod_abi_cartolarizzato,
                                                                                        v_rec.cod_ndg);
        -- se non eiste una UO utile per la posizione corrente, la delibera non viene creata
        IF v_proto_delib != -1
                THEN   ---esiste quindi un uo pratica che permette la generazione del protodelibera
        INSERT INTO t_mcrei_app_delibere d
          (id_dper,
           cod_sndg,
           cod_abi,
           cod_ndg,
           cod_protocollo_pacchetto,
           cod_protocollo_delibera,
           cod_protocollo_delibera_pre,
           flg_attiva,
           cod_microtipologia_delib,
           val_rdv_qc_progressiva,
           val_esp_netta_post_delib,
           val_rdv_qc_ante_delib,
           val_esp_netta_ante_delib,
           --v6.33 inizializzo anche il deliberato per le CH
           val_rdv_qc_deliberata,
           cod_fase_delibera,
           cod_fase_microtipologia,
           cod_fase_pacchetto,
           dta_creazione_pacchetto,
           dta_ins_delibera,
           cod_tipo_pacchetto,
           cod_matricola_inserente,
           cod_macrotipologia_delib,
           cod_pratica,
           val_anno_pratica,
           cod_uo_pratica,
           cod_segmento,
           desc_denominaz_ins_delibera,
           cod_filiale_delibera,
           val_num_progr_delibera,
           flg_no_delibera,
           val_rdv_pregr_fi,
           val_rdv_progr_fi,
           val_rinuncia_deliberata,
           val_imp_perdita, --0807
                     FLG_FORZ_DA_IMP,
                     desc_no_delibera)
          (SELECT to_number(to_char(trunc(SYSDATE), 'YYYYMMDD')),
                  p_sndg,
                  g.cod_abi_cartolarizzato,
                  g.cod_ndg,
                  v_prot,
                  --mcre_own.pkg_mcrei_gest_delibere. fnc_mcrei_protocollo_delibera(p.cod_uo_pratica, p_utente_ins, g .cod_abi_cartolarizzato, g .cod_ndg),
                  v_proto_delib,
                  v_delibera_pre,
                  '1' AS flg_attiva,
                  p_microtipolog,
                  --v6.32 06.26 se CH/CF forzo progressivo a 0
                  CASE
                    WHEN p_microtipolog IN ('CH', 'CF') THEN
                     0
                    ELSE
                     val_rdv_qc_progr
                  END AS val_rdv_qc_progressiva, --29.03
                  pc.scsb_uti_cassa - val_rdv_qc_progr AS val_esp_netta_post_delib, --29.03, 15-giu,
                  val_rdv_qc_progr val_rdv_qc_ante_delib,
                  pc.scsb_uti_cassa - val_rdv_qc_progr AS val_esp_netta_ante_delib,
                  --inizializzo solo per CH
                  CASE
                    WHEN p_microtipolog IN ('CH', 'CF') THEN
                     0 - val_rdv_qc_progr
                    ELSE
                     0
                  END AS val_rdv_qc_deliberata,
                  --9 maggio
                  'IN',
                  'INS',
                  'INS',
                  SYSDATE,
                  SYSDATE,
                  'M',
                  p_utente_ins,
                  t.cod_macrotipologia,
                  p.cod_pratica,
                  p.val_anno_pratica,
                  p.cod_uo_pratica,
                  a.val_segmento_regolamentare,
                  (SELECT u.cognome || ' ' || u.nome AS denom_matricola
                     FROM t_mcre0_app_utenti u
                    WHERE u.cod_matricola = p_utente_ins),
                  g.cod_filiale,
                  --                V_PROGRE_DELIB,
                  seq_mcrei_prog_del.nextval,
                  CASE --v7.5 considero dervivati su CI/CS
                    WHEN ((nvl(pc.scsb_acc_tot, 0) + nvl(pc.scsb_uti_tot, 0) +
                           case when p_microtipolog in ('CI','CS') then
                            nvl(pc.scsb_acc_sostituzioni, 0) + nvl(pc.scsb_uti_sostituzioni, 0)
                            else 0 end) = 0 AND
                         p_microtipolog not in ( 'CH', 'PR', 'PS', 'PU' ) ) THEN --v5.3--v8.4 aggiunte proroghe
                     1
                     WHEN V_CREA_DELIBERA = 0 THEN
                     1
                  --  WHEN g.cod_stato != 'IN'  THEN --applico le delibere solo all epos in incaglio!
                  --   1
                    ELSE 0
                  END fl_no_del,
                  nvl(v_rdv_progr_fi, 0),
                  -- v6.32 06.26 se CH/CF forzo progressivo a 0
                  CASE
                    WHEN p_microtipolog IN ('CH', 'CF') THEN
                     0
                    ELSE nvl(v_rdv_progr_fi, 0)
                  END AS val_rdv_progr_fi,
                  v_imp_perdita,
                  v_imp_perdita as val_imp_perdita,
                                    P_FLG_FORZ_IMp,
                  CASE --v8.6
                    WHEN ((nvl(pc.scsb_acc_tot, 0) + nvl(pc.scsb_uti_tot, 0) +
                           case when p_microtipolog in ('CI','CS') then
                            nvl(pc.scsb_acc_sostituzioni, 0) + nvl(pc.scsb_uti_sostituzioni, 0)
                            else 0 end) = 0 AND
                         p_microtipolog not in ( 'CH', 'PR', 'PS', 'PU' ) ) THEN --v5.3--v8.4 aggiunte proroghe
                     'Posizione con esposizione 0'
                     WHEN V_CREA_DELIBERA = 0 THEN
                     'Posizione non di competenza'
                  --  WHEN g.cod_stato != 'IN'  THEN --applico le delibere solo all epos in incaglio!
                  --   1
                    ELSE null
                  END as  desc_no_delibera
             FROM t_mcre0_app_all_data          g,
                  t_mcrei_app_pratiche          p,
                  t_mcrei_cl_tipologie          t,
                  t_mcre0_app_anagrafica_gruppo a,
                  t_mcrei_app_pcr_rapp_aggr     pc
            WHERE g.cod_abi_cartolarizzato = v_rec.cod_abi_cartolarizzato
              AND g.cod_ndg = v_rec.cod_ndg
              AND g.cod_sndg = a.cod_sndg
              AND g.today_flg = '1'
              AND g.cod_abi_cartolarizzato = p.cod_abi(+)
              AND g.cod_ndg = p.cod_ndg(+)
              AND g.cod_abi_cartolarizzato = pc.cod_abi_cartolarizzato(+)
              AND g.cod_ndg = pc.cod_ndg(+)
                 -- SOLO TARGET E OUTSOURCING
              AND g.flg_outsourcing = 'Y'
              AND g.flg_target = 'Y'
              AND p.flg_attiva(+) = '1'
              AND t.cod_microtipologia = p_microtipolog
              AND t.flg_attivo = 1);

--             IF (SQL%ROWCOUNT = 0) THEN
--                  pkg_mcrei_audit.log_app(c_nome,  pkg_mcrei_audit.c_debug, SQLCODE,
--                                        'create '||sql%rowcount||' delibere per il pacchetto '||v_prot,
--                                        '.. non forzo pacchetto a null??',   p_utente_ins);
--             --v_prot := NULL;
--             end if;

        ---SE HO INSERITO UNA DELIB DI RISTRUTT, RECUPERO GLI ATTRIBUTI DELL'ULTIMA EVENTUALE
        ---RISTRUTTURAZIONE PRESENTE PER LA POSIZIONE CORRENTE
            IF (v_flg_ristr = '1' OR p_microtipolog = 'B8')
        THEN
          BEGIN
            --SE ESISTE, RECUPERO IL PROTO DELIBERA DELL'ULTIMA RISTRUTTURAZIONE EFFETTUATA SULLA POSIZIONE
            SELECT cod_protocollo_delibera,dta_chiusura_ristr
              INTO v_cod_proto_del_pre,V_dta_chiusura_ristr
              FROM (SELECT cod_protocollo_delibera,
                           dta_chiusura_ristr
                      FROM t_mcrei_hst_ristrutturazioni
                     WHERE cod_abi = v_rec.cod_abi_cartolarizzato
                       AND cod_ndg = v_rec.cod_ndg
                     ORDER BY val_ordinale DESC NULLS LAST)
             WHERE rownum = 1;

                    IF V_dta_chiusura_ristr IS NULL ---QUINDI NON SI TRATTA DI UNA CHIUSURA
                    THEN

            ---EREDITA GLI ATTRIBUTI DELL'ULTIMA EVENTUALE RISTRUTTURAZIONE PRESENTE SULLE DELIBERE
             UPDATE t_mcrei_app_delibere D
               SET (desc_tipo_ristr,
                    desc_intento_ristr,
                    dta_efficacia_add,
                    dta_scadenza_ristr,
                    dta_efficacia_ristr,
                    D.COD_STATO_POST_RISTR) =
                   (SELECT desc_tipo_ristr,
                           desc_intento_ristr,
                           dta_efficacia_add,
                           decode(p_microtipolog,
                                  'B8',
                                  dta_scadenza_ristr,
                                  NULL),
                           dta_efficacia_ristr,
                                                     R.COD_STATO_PROPOSTO --13 LUGLIO
                      FROM t_mcrei_hst_ristrutturazioni R
                     WHERE cod_abi = v_rec.cod_abi_cartolarizzato
                       AND cod_ndg = v_rec.cod_ndg
                       AND cod_protocollo_delibera = v_cod_proto_del_pre)
             WHERE cod_abi = v_rec.cod_abi_cartolarizzato
               AND cod_ndg = v_rec.cod_ndg
               AND cod_protocollo_delibera = v_proto_delib;
          ELSE

                    NULL; ---NON EREDITO NULLA PERCHe' L'ULTIMA S UNA CHIUSURA
                    END IF;


          EXCEPTION
            WHEN no_data_found THEN
                   pkg_mcrei_audit.log_app(c_nome,  pkg_mcrei_audit.c_debug, SQLCODE,SQLERRM,
                                        ' nessuna ristrutturazione precedente trovata',   p_utente_ins);
              NULL;
          END;
          ---effettua aggiornamento dati di ristrutturazione solo se l'ultima delibera
          ---precedente non S una chiusura di ristrutturazione

          OPEN rap_pos(v_rec.cod_abi_cartolarizzato, v_rec.cod_ndg);
          -- inserisco le stime per quella delibera    06.07
          LOOP
            FETCH rap_pos
              INTO v_rec_rapp_pos;
            EXIT WHEN rap_pos%NOTFOUND;

            BEGIN
              SELECT dta_inizio_segnalazione_ristr,
                     dta_fine_segnalazione_ristr,
                     flg_ristrutturato
                INTO v_dta_inizio_segn_ristr,
                     v_dta_fine_segn_ristr,
                     v_flg_ristrutturato
                FROM (SELECT dta_inizio_segnalazione_ristr,
                             dta_fine_segnalazione_ristr,
                             flg_ristrutturato
                        FROM t_mcrei_hst_rapp_ristr
                       WHERE cod_abi = v_rec_rapp_pos.cod_abi
                         AND cod_ndg = v_rec_rapp_pos.cod_ndg
                         AND cod_rapporto = v_rec_rapp_pos.cod_rapporto
                       ORDER BY val_ordinale DESC)
               WHERE rownum = 1;

              IF v_flg_ristrutturato = 'Y'
              THEN
                --                V_DTA_INIZIO_SEGN_RISTR:=V_DTA_INIZIO_SEGN_RISTR
                v_dta_fine_segn_ristr := NULL;
              ELSE
                v_dta_inizio_segn_ristr := NULL;
                v_dta_fine_segn_ristr   := NULL;
              END IF;

            EXCEPTION
              WHEN no_data_found THEN
                v_dta_inizio_segn_ristr := NULL;
                v_dta_fine_segn_ristr   := NULL;
                v_flg_ristrutturato     := 'N';
            END;

            BEGIN
              INSERT INTO t_mcrei_app_stime s
                (s.id_dper,
                 s.cod_sndg,
                 s.cod_abi,
                 s.cod_ndg,
                 s.cod_rapporto,
                 s.cod_protocollo_delibera,
                 s.flg_tipo_dato,
                 s.cod_forma_tecnica,
                 s.cod_classe_ft,
                 s.flg_ristrutturato,
                 s.dta_stima,
                 s.dta_ins,
                 s.cod_microtipologia_delibera,
                 s.flg_attiva,
                 s.dta_inizio_segnalazione_ristr,
                 s.dta_fine_segnalazione_ristr)
              VALUES
                (to_number(to_char(SYSDATE, 'YYYYMMDD')),
                 v_rec_rapp_pos.cod_sndg,
                 v_rec_rapp_pos.cod_abi,
                 v_rec_rapp_pos.cod_ndg,
                 v_rec_rapp_pos.cod_rapporto,
                 v_proto_delib,
                 'R',
                 v_rec_rapp_pos.cod_forma_tecnica,
                 v_rec_rapp_pos.cod_classe_ft,
                 v_flg_ristrutturato,
                 trunc(SYSDATE),
                 SYSDATE,
                 p_microtipolog,
                 '1',
                 v_dta_inizio_segn_ristr,
                 v_dta_fine_segn_ristr);
            EXCEPTION
              WHEN dup_val_on_index THEN
                -- null;
                pkg_mcrei_audit.log_app(c_nome,
                                        pkg_mcrei_audit.c_debug,
                                        SQLCODE,
                                        SQLERRM,
                                        p_note,
                                        p_utente_ins);

            END;

          END LOOP;  ---su rapporti ristrutturati

          CLOSE rap_pos;
        END IF;  --(v_flg_ristr = '1' OR p_microtipolog = 'B8')
        END IF;--if protodelibera != -1, ovvero se esiste l'uo pratica per la posizione

       END IF;
      END LOOP;
      CLOSE posizioni;
    END IF;
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            p_utente_ins);
    RETURN v_prot;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_utente_ins);
      RETURN NULL;
  END crea_pacchetto;

  -- %AUTHOR Reply
  -- %VERSION 0.1
  -- %USAGE  function che data la delibera di rettifica in input, reimposta i valori di rettifica
  -- %USAGE  IN tutte le delibere presenti nel pacchetto e CREATE prima che la delibera di rettifica inclusa nel
  -- %USAGE  pacchetto fosse completata
  -- %CD 02 mag 2012
  -- %PARAM P_PROTO_PACCHETTO
  -- %PARAM p_proto_delibera: protocollo della delibera T4 di cui si sono appena controllati i dati
  -- %PARAM p_cod_abi
  -- %PARAM p_cod_ndg
  -- %PARAM p_microt_delib
  -- %PARAM p_rdv_progr_ca: rdv progressiva di cassa digitata dall'utente nella delibera T4 corrente
  -- %PARAM p_rdv_progr_fi: rdv progressiva di firma digitata dall'utente nella delibera T4 corrente
  -- %PARAM p_utente: utente utilizzato per il log dell'attivita'
  FUNCTION aggiorna_valori_pregressi(p_proto_pacchetto IN VARCHAR2,
                                     p_proto_delibera  IN VARCHAR2,
                                     p_cod_abi         IN VARCHAR2,
                                     p_cod_ndg         IN VARCHAR2,
                                     p_microt_delib    IN VARCHAR2,
                                     p_rdv_progr_ca    IN NUMBER,
                                     p_rdv_progr_fi    IN NUMBER,
                                     p_utente          IN VARCHAR2)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.AGGIORNA_VALORI_PREGRESSI';
    v_ret              NUMBER := 0;
    p_note             t_mcrei_wrk_audit_applicativo.note%TYPE;
    val_rdv_qc_progr   NUMBER := 0;
    val_esp_netta_post NUMBER := 0;
    v_rdv_progr_fi     NUMBER := 0;
  BEGIN
    BEGIN
      SELECT nvl(s.val_rdv_qc_progressiva, 0) val_rdv_qc_progressiva,
             nvl(val_esp_netta_post_delib, 0) val_esp_netta_post_delib,
             nvl(val_rdv_progr_fi, 0) AS val_rdv_progr_fi
        INTO val_rdv_qc_progr,
             val_esp_netta_post,
             v_rdv_progr_fi
        FROM t_mcrei_app_delibere s
       WHERE s.cod_abi = p_cod_abi
         AND s.cod_ndg = p_cod_ndg
         AND s.cod_fase_delibera != 'AN' --7 GIU
         AND s.flg_attiva = '1'
         AND s.cod_protocollo_pacchetto = p_proto_pacchetto
         AND s.cod_microtipologia_delib = p_microt_delib;
    EXCEPTION
      WHEN no_data_found THEN
        val_rdv_qc_progr   := 0;
        v_rdv_progr_fi     := 0;
        val_esp_netta_post := 0;
    END;

    ---recupero info rettifica dalla T4 o Rv CORRENTE e aggiorno i valori a livello di pacchetto
    p_note := 'Aggiorna valori pregressi sul pacchetto contenente una ' ||
              p_microt_delib;

    BEGIN
      UPDATE t_mcrei_app_delibere d
         SET d.val_rdv_qc_ante_delib       = val_rdv_qc_progr,
             d.val_rdv_qc_progressiva      = val_rdv_qc_progr,
             d.val_rdv_pregr_fi            = v_rdv_progr_fi,
             d.val_rdv_progr_fi            = v_rdv_progr_fi,
             d.cod_protocollo_delibera_pre = p_proto_delibera
       WHERE d.cod_abi = p_cod_abi
            ---aggiorno tutte le delibere del pacchetto tranne la T4
         AND d.cod_ndg = p_cod_ndg
         AND d.cod_protocollo_pacchetto = p_proto_pacchetto
         AND d.cod_protocollo_delibera <> p_proto_delibera
            ---esclude la T4/RV dall'aggiornamento
         AND d.cod_fase_delibera <> 'AN';
    EXCEPTION
      WHEN OTHERS THEN
        p_note := 'fallito aggiornamento dei valori pregressi sul pacchetto contenente una ' ||
                  p_microt_delib;
        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_error,
                                SQLCODE,
                                SQLERRM,
                                p_note,
                                p_utente);
        RETURN const_esito_ko;
    END;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            p_utente);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_utente);
      RETURN const_esito_ko;
  END aggiorna_valori_pregressi;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  FUNCTION CHE AGGIUNGE UNA DELIBERA AD UN PACCHETTO GIo ESISTENTE E NON ANCORA CONFERMATO
  -- %D LA FUNCTION CREA, PER IL PACCHETTO PASSATO IN INPUT, TANTI PROTOCOLLI DI DELIBERA
  -- %D QUANTI SONO GLI NDG COLLEGATI AL SNDG
  -- %D DI DELIBERE
  -- %CD 17 NOV 2011
  -- %PARAM P_PROTO_PACCHETTO
  -- %PARAM P_SUPERNDG
  -- %PARAM P_MICROTIPOLO
  -- %PARAM P_UTE_INSE
  FUNCTION aggiungi_microtipologia(p_proto_pacchetto VARCHAR2,
                                   p_sndg            VARCHAR2,
                                   p_microtipolog    VARCHAR2,
                                   p_utente_ins      VARCHAR2,
                                   p_dta_creaz       DATE,
                                                                     P_FLG_FORZ_IMP IN VARCHAR2 DEFAULT 'N') RETURN VARCHAR2 IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.AGGIUNGI_MICROTIPOLOGIA';
    p_note                  t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_cod_proto_del_pre     t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
    v_flg_ristr             VARCHAR2(1);
    v_proto_delib           t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
    v_cod_uo                t_mcrei_app_pratiche.cod_uo_pratica%TYPE;
    v_dta_inizio_segn_ristr DATE;
    v_dta_fine_segn_ristr   DATE;
    v_flg_ristrutturato     VARCHAR2(1);
    V_dta_chiusura_ristr    DATE; --17 LUG

    CURSOR posizioni(v_sndg VARCHAR2, v_microtip VARCHAR2) IS
      SELECT g.cod_abi_cartolarizzato,
             g.cod_ndg,
             g.cod_sndg,
             g.cod_stato,
             nvl(g.cod_comparto_assegnato, g.cod_comparto_calcolato) as cod_comparto,
             g.id_utente,
             u.cod_matricola
        FROM t_mcre0_app_all_data g,
             t_mcrei_cl_tipologie t,
             t_mcre0_app_utenti u
       WHERE g.cod_sndg = v_sndg
         AND g.today_flg = '1'
            -- SOLO TARGET E OUTSOURCING
         AND g.flg_outsourcing = 'Y'
         AND g.flg_target = 'Y'
         AND t.cod_microtipologia(+) = v_microtip
         AND t.flg_attivo(+) = 1
         AND g.id_utente = u.id_utente
         AND nvl(g.cod_comparto_assegnato, g.cod_comparto_calcolato) IS NOT NULL
         and LENGTH(nvl(g.cod_comparto_assegnato,g.cod_comparto_calcolato)) > 1; --01/02/2013 in seguto a caso di test

    CURSOR rap_pos(v_abi VARCHAR2, v_ndg VARCHAR2) IS
      SELECT DISTINCT cod_sndg,
                      cod_abi,
                      cod_ndg,
                      cod_rapporto,
                      MAX(cod_forma_tecnica) over(PARTITION BY cod_abi, cod_ndg, cod_rapporto) AS cod_forma_tecnica,
                      MAX(cod_classe_ft) over(PARTITION BY cod_abi, cod_ndg, cod_rapporto) AS cod_classe_ft
        FROM t_mcrei_app_pcr_rapporti
       WHERE cod_abi = v_abi
         AND cod_ndg = v_ndg
         AND flg_attiva = '1';

    v_rec              posizioni%ROWTYPE;
    v_rec_rapp_pos     rap_pos%ROWTYPE;
    val_rdv_qc_progr   NUMBER := 0;
    v_rdv_progr_fi     NUMBER := 0;
    val_esp_netta_post NUMBER := 0;
    v_imp_perdita      NUMBER := 0;
    v_delibera_pre     t_mcrei_app_delibere.cod_protocollo_delibera_pre%TYPE;
    v_fase_pacc        t_mcrei_app_delibere.cod_fase_pacchetto%TYPE;
    esito              NUMBER;
    v_stralcio_ct      NUMBER := 0;
    V_IS_DI_REG_O_AR        BOOLEAN;
    V_CREA_DELIBERA         NUMBER:=1;--TRUE;
    V_COMPARTO_UTENTE       T_MCRE0_APP_UTENTI.COD_COMPARTO_UTENTE%TYPE;
  BEGIN
    p_note := 'Controllo parametri in ingresso';

    IF p_proto_pacchetto IS NULL OR
       p_sndg IS NULL OR
       p_microtipolog IS NULL OR
       p_utente_ins IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'SNDG: ' || p_sndg || ' TIP: ' || p_microtipolog||
     ' p_utente_ins: '||p_utente_ins|| ' prot: ' ||p_proto_pacchetto;

    --v5.0 0320 aggiungo la tipologia con la stessa fase attuale del pacchetto
    SELECT DISTINCT cod_fase_pacchetto
      INTO v_fase_pacc
      FROM t_mcrei_app_delibere
     WHERE cod_protocollo_pacchetto = p_proto_pacchetto
     AND COD_FASE_PACCHETTO NOT IN ('ANM', 'ANA');

    ---DETERMINO SE LA MICROTIPOLOGIA PREVEDERE SEGNALAZ DI RISTRUTTURAZIONE
    SELECT flg_segn_ristr
      INTO v_flg_ristr
      FROM t_mcrei_cl_tipologie
     WHERE flg_attivo = 1
       AND cod_microtipologia = p_microtipolog;

    V_CREA_DELIBERA:=1;
    BEGIN
    SELECT COD_COMPARTO_UTENTE
     INTO V_COMPARTO_UTENTE
     FROM T_MCRE0_APP_UTENTI
    WHERE COD_MATRICOLA = P_UTENTE_INS;
    IF V_COMPARTO_UTENTE IS NOT NULL THEN
    V_IS_DI_REG_O_AR:= PKG_MCREI_WEB_UTILITIES_EVOL.FNC_IS_AR_RG_LIV_AREA(V_COMPARTO_UTENTE);
    ELSE
    V_IS_DI_REG_O_AR:=TRUE;
    P_NOTE:=P_NOTE||'COD_COMPARTO_UTENTE NULL PER '||P_UTENTE_INS||'IN T_MCRE0_APP_UTENTI;'||CHR(10);
    P_NOTE:=P_NOTE||'Si prosegue con comportamento comparto non di area o di regione'||chr(10);
    END IF;
    EXCEPTION WHEN OTHERS THEN
        P_NOTE:=P_NOTE||'Impossibile recuperare il comparto utente per '||P_UTENTE_INS||' a partire da T_MCRE0_APP_UTENTI;'||CHR(10);
    END;



    OPEN posizioni(p_sndg, p_microtipolog);
    LOOP
      FETCH posizioni INTO v_rec;
      EXIT WHEN posizioni%NOTFOUND;
        V_CREA_DELIBERA:=1;
        IF V_IS_DI_REG_O_AR THEN
        V_CREA_DELIBERA:= 0;
            IF TO_CHAR(V_REC.COD_MATRICOLA) = P_UTENTE_INS THEN V_CREA_DELIBERA:= 1; END IF;
        END IF;
        IF V_CREA_DELIBERA = 0 then
            p_note:=p_note||CHR(10)||'Attenzione: Non creata delibera per '||v_rec.cod_abi_cartolarizzato||
            ' '||v_rec.cod_ndg||' che e'' di area o regione'||
            CHR(10)||' e non e'' assegnata al gestore corrente (o quello per cui si sta operando).'||chr(10);
        END IF;
      IF V_CREA_DELIBERA = 1 THEN
       BEGIN
      --0808 se l'ultima delibera contabilizzata S CT recupero la somma degli stralci come perdita iniziale
      begin
      v_stralcio_ct := NVL (pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct(v_rec.cod_abi_cartolarizzato,v_rec.cod_ndg), 0);
      exception when others then
      v_stralcio_ct := 0;
      end;

        SELECT val_rdv_qc_progressiva,val_esp_netta_post_delib,
               cod_protocollo_delibera,val_rdv_progr_fi,val_imp_perdita
          INTO val_rdv_qc_progr,val_esp_netta_post,
               v_delibera_pre,v_rdv_progr_fi,v_imp_perdita
          FROM (SELECT nvl(s.val_rdv_qc_progressiva, 0) val_rdv_qc_progressiva,
                       nvl(s.val_esp_netta_post_delib, 0) val_esp_netta_post_delib,
                       s.cod_protocollo_delibera,
                       nvl(s.val_rdv_progr_fi, 0) AS val_rdv_progr_fi,
                       decode(s.cod_fase_delibera,
                              'CT',
                              --11 MAGGIO: aaggiunta logica su rinuncia pregressa in caso di CT
                              --MM 0808: in fase di inizializzazione, la rinuncia pregressa CT S lo stralcio capitalizzato
                              --nvl(s.val_rinuncia_totale, 0) -
                              --nvl(val_imp_perdita, 0) +
                              --nvl(s.val_sacrif_capit_mora, 0),
                              v_stralcio_ct,
                              nvl(s.val_imp_perdita, 0)) AS val_imp_perdita
                --6.0
                  FROM t_mcrei_app_delibere s
                 WHERE s.cod_abi = v_rec.cod_abi_cartolarizzato
                   AND s.cod_ndg = v_rec.cod_ndg
                   AND s.cod_fase_delibera IN ('AD', 'CO', 'CT', 'NA')
                      ---aggiunto CT il 11/4, NA il 24/4
                   AND s.flg_no_delibera = 0
                   AND flg_attiva = '1'
                       ORDER BY s.dta_conferma_delibera  DESC,
                                s.val_num_progr_delibera DESC )
         WHERE rownum <= 1;
      EXCEPTION
        WHEN no_data_found THEN
          val_rdv_qc_progr   := 0;
          v_rdv_progr_fi     := 0;
          val_esp_netta_post := 0;
          v_imp_perdita      := 0;
          v_delibera_pre     := '#';
      END;

      ---METTO IN UNA VARIABILE IL PROTO DELIBERA CHE MI SERVIR? PER
      ---L'EVNETUALE RECUPERO DEI DATI DI RISTRUTTURAZIONE PREGRESSA
       BEGIN
        SELECT p.cod_uo_pratica
          INTO v_cod_uo
          FROM t_mcrei_app_pratiche p
         WHERE p.cod_abi = v_rec.cod_abi_cartolarizzato
           AND p.cod_ndg = v_rec.cod_ndg
           AND flg_attiva = '1'
           AND rownum = 1;

      EXCEPTION
        WHEN no_data_found THEN
          v_cod_uo := NULL;
      END;
       v_proto_delib := mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_protocollo_delibera(v_cod_uo,
                                                                                      p_utente_ins,
                                                                                      v_rec.cod_abi_cartolarizzato,
                                                                                      v_rec.cod_ndg);
      -- se non eiste una UO utile per la posizione corrente, la delibera non viene creata
         IF v_proto_delib != -1 THEN   ---esiste quindi un uo pratica che permette la generazione del protodelibera

          INSERT INTO t_mcrei_app_delibere d
            (id_dper,
             cod_sndg,
             cod_abi,
             cod_ndg,
             cod_protocollo_pacchetto,
             cod_protocollo_delibera,
             cod_protocollo_delibera_pre,
             flg_attiva,
             cod_microtipologia_delib,
             val_rdv_qc_progressiva,
             val_esp_netta_post_delib,
             val_rdv_qc_ante_delib,
             val_esp_netta_ante_delib,--v6.33 inizializzo anche il deliberato per le CH
             val_rdv_qc_deliberata,
             cod_fase_delibera,
             cod_fase_microtipologia,
             cod_fase_pacchetto,
             dta_creazione_pacchetto,
             dta_ins_delibera,
             cod_tipo_pacchetto,
             cod_matricola_inserente,
             cod_macrotipologia_delib,
             cod_pratica,
             val_anno_pratica,
             cod_uo_pratica,
             cod_segmento,
             desc_denominaz_ins_delibera,
             cod_filiale_delibera,
             val_num_progr_delibera,
             flg_no_delibera,
             val_rdv_pregr_fi,
             val_rdv_progr_fi,
             val_rinuncia_deliberata,
             val_imp_perdita,--0806 inizializzo anche l'imp_perdita
             FLG_FORZ_DA_IMP,
             VAL_STRALCIO_SENZA_ACCANTONAM,
             desc_no_delibera)
            (SELECT to_number(to_char(trunc(SYSDATE), 'YYYYMMDD')),
                    p_sndg,
                    g.cod_abi_cartolarizzato,
                    g.cod_ndg,
                    p_proto_pacchetto,
                    v_proto_delib, --4 LUGLIO
                    /*mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_protocollo_delibera(p.cod_uo_pratica,
                    p_utente_ins,
                    g.cod_abi_cartolarizzato,
                    g.cod_ndg),
                    */
                    v_delibera_pre,
                    '1' AS flg_attiva,
                    p_microtipolog,
                    --v6.32 06.26 se CH/CF forzo progressivo a 0
                    CASE
                      WHEN p_microtipolog IN ('CH', 'CF') THEN
                       0
                      ELSE
                       val_rdv_qc_progr
                    END AS val_rdv_qc_progressiva, --29.03
                    pc.scsb_uti_cassa - val_rdv_qc_progr AS val_esp_netta_post_delib,
                    val_rdv_qc_progr AS val_rdv_qc_ante_delib,
                    pc.scsb_uti_cassa - val_rdv_qc_progr AS val_esp_netta_ante_delib, --9 maggio
                    --inizializzo solo per CH
                    CASE
                      WHEN p_microtipolog IN ('CH', 'CF') THEN
                       0 - val_rdv_qc_progr
                      ELSE
                       0
                    END AS val_rdv_qc_deliberata,
                    'IN',
                    'INS',
                    v_fase_pacc, --'INS',
                    p_dta_creaz,  -----AD: 15 aprile, invertite le date: la dta_creaz_pacchetto deve essere quella passata in input, ovvero quella del pacch gi¿ creato
                    SYSDATE,
                    ----dta_creazione_pacchetto esistente
                    'M',
                    p_utente_ins,
                    t.cod_macrotipologia,
                    p.cod_pratica,
                    p.val_anno_pratica,
                    p.cod_uo_pratica,
                    a.val_segmento_regolamentare,
                    (SELECT u.cognome || ' ' || u.nome AS denom_matricola
                       FROM t_mcre0_app_utenti u
                      WHERE u.cod_matricola = p_utente_ins),
                    g.cod_filiale,

                    --                V_PROGRE_DELIB,
                    seq_mcrei_prog_del.nextval,
                    CASE --v7.5 considero dervivati su CI/CS
                    WHEN ((nvl(pc.scsb_acc_tot, 0) + nvl(pc.scsb_uti_tot, 0) +
                           case when p_microtipolog in ('CI','CS') then
                            nvl(pc.scsb_acc_sostituzioni, 0) + nvl(pc.scsb_uti_sostituzioni, 0)
                            else 0 end) = 0 AND
                         p_microtipolog not in ( 'CH', 'PR', 'PS', 'PU' ) ) THEN --v5.3--v8.4 aggiunte proroghe
                       1
                      WHEN V_CREA_DELIBERA = 0 THEN 1
                    --  WHEN (v_rec.cod_stato != 'IN' AND
                    --  p_microtipolog != 'CS') THEN --applico le delibere solo all epos in incaglio!
                    -- 1
                      ELSE
                       0
                    END fl_no_del,
                    nvl(v_rdv_progr_fi, 0),--v6.32 06.26 se CH/CF forzo progressivo a 0
                    CASE
                      WHEN p_microtipolog IN ('CH', 'CF') THEN
                       0
                      ELSE
                       nvl(v_rdv_progr_fi, 0)
                    END AS val_rdv_progr_fi,
                    v_imp_perdita as val_rinuncia_deliberata,
                    v_imp_perdita as val_imp_perdita,
                                    P_FLG_FORZ_IMP,
                                    v_stralcio_ct,
                    CASE --v8.6
                    WHEN ((nvl(pc.scsb_acc_tot, 0) + nvl(pc.scsb_uti_tot, 0) +
                           case when p_microtipolog in ('CI','CS') then
                            nvl(pc.scsb_acc_sostituzioni, 0) + nvl(pc.scsb_uti_sostituzioni, 0)
                            else 0 end) = 0 AND
                         p_microtipolog not in ( 'CH', 'PR', 'PS', 'PU' ) ) THEN --v5.3--v8.4 aggiunte proroghe
                       'Posizione con esposizione a 0'
                      WHEN V_CREA_DELIBERA = 0 THEN 'Posizione non di competenza'
                    --  WHEN (v_rec.cod_stato != 'IN' AND
                    --  p_microtipolog != 'CS') THEN --applico le delibere solo all epos in incaglio!
                    -- 1
                      ELSE
                       null
                    END as desc_no_delibera
               FROM t_mcre0_app_all_data          g,
                    t_mcrei_app_pratiche          p,
                    t_mcrei_cl_tipologie          t,
                    t_mcre0_app_anagrafica_gruppo a,
                    t_mcrei_app_pcr_rapp_aggr     pc
              WHERE g.cod_abi_cartolarizzato = v_rec.cod_abi_cartolarizzato
                AND g.cod_ndg = v_rec.cod_ndg
                AND g.cod_sndg = a.cod_sndg
                AND g.today_flg = '1'
                AND g.cod_abi_cartolarizzato = p.cod_abi(+)
                AND g.cod_ndg = p.cod_ndg(+)
                AND g.cod_abi_cartolarizzato = pc.cod_abi_cartolarizzato(+)
                AND g.cod_ndg = pc.cod_ndg(+)
                   --ESCLUDO CI PER INCAGLI E CI/CS PER SO
                AND decode(g.cod_stato, 'IN', 1, 'SO', 2, 0) <
                    decode(p_microtipolog, 'CI', 1, 'CS', 2, 3)
                   --            AND (SELECT NVL(PC.SCSB_ACC_TOT + PC.SCSB_UTI_TOT, 0)
                   --                          FROM T_MCRE0_APP_PCR PC
                   --                         WHERE PC.COD_ABI_CARTOLARIZZATO =
                   --                               G.COD_ABI_CARTOLARIZZATO
                   --                           AND PC.COD_NDG = G.COD_NDG) > 0
                   -- SOLO TARGET E OUTSOURCING
                AND g.flg_outsourcing = 'Y'
                AND g.flg_target = 'Y'
                AND p.flg_attiva(+) = '1'
                AND t.cod_microtipologia = p_microtipolog
                AND t.flg_attivo = 1);

          IF (v_flg_ristr = '1' OR p_microtipolog = 'B8')
            THEN

              BEGIN
                --SE ESISTE, RECUPERO IL PROTO DELIBERA DELL'ULTIMA RISTRUTTURAZIONE EFFETTUATA SULLA POSIZIONE
                SELECT cod_protocollo_delibera,dta_chiusura_ristr
                  INTO v_cod_proto_del_pre,V_dta_chiusura_ristr
                  FROM (SELECT cod_protocollo_delibera,
                               dta_chiusura_ristr
                          FROM t_mcrei_hst_ristrutturazioni
                         WHERE cod_abi = v_rec.cod_abi_cartolarizzato
                           AND cod_ndg = v_rec.cod_ndg
                         ORDER BY val_ordinale DESC NULLS LAST)
                 WHERE rownum = 1;

                        IF V_dta_chiusura_ristr IS NULL  ---QUINDI NON SI TRATTA DI UNA CHIUSURA
                        THEN

                ---EREDITA GLI ATTRIBUTI DELL'ULTIMA EVENTUALE RISTRUTTURAZIONE PRESENTE SULLE DELIBERE
                            UPDATE t_mcrei_app_delibere D
                   SET (desc_tipo_ristr,
                        desc_intento_ristr,
                        dta_efficacia_add,
                        dta_scadenza_ristr,
                        dta_efficacia_ristr,
                                            D.COD_STATO_POST_RISTR) =
                       (SELECT desc_tipo_ristr,
                               desc_intento_ristr,
                               dta_efficacia_add,
                               decode(p_microtipolog,
                                      'B8',
                                      dta_scadenza_ristr,
                                      NULL),
                               dta_efficacia_ristr,
                                                         R.COD_STATO_PROPOSTO --13 LUGLIO
                          FROM t_mcrei_hst_ristrutturazioni R
                         WHERE cod_abi = v_rec.cod_abi_cartolarizzato
                           AND cod_ndg = v_rec.cod_ndg
                           AND cod_protocollo_delibera = v_cod_proto_del_pre)
                 WHERE cod_abi = v_rec.cod_abi_cartolarizzato
                   AND cod_ndg = v_rec.cod_ndg
                   AND cod_protocollo_delibera = v_proto_delib;
              ELSE

                        NULL; ---NON EREDITO NULLA PERCH? L'ULTIMA S UNA CHIUSURA
                        END IF;


              EXCEPTION
                WHEN no_data_found THEN
                  NULL;
              END;

            OPEN rap_pos(v_rec.cod_abi_cartolarizzato, v_rec.cod_ndg);
            -- inserisco le stime per quella delibera    06.07
            LOOP
              FETCH rap_pos
                INTO v_rec_rapp_pos;
              EXIT WHEN rap_pos%NOTFOUND;

              BEGIN
                SELECT dta_inizio_segnalazione_ristr,
                       dta_fine_segnalazione_ristr,
                       flg_ristrutturato
                  INTO v_dta_inizio_segn_ristr,
                       v_dta_fine_segn_ristr,
                       v_flg_ristrutturato
                  FROM (SELECT dta_inizio_segnalazione_ristr,
                               dta_fine_segnalazione_ristr,
                               flg_ristrutturato
                          FROM t_mcrei_hst_rapp_ristr
                         WHERE cod_abi = v_rec_rapp_pos.cod_abi
                           AND cod_ndg = v_rec_rapp_pos.cod_ndg
                           AND cod_rapporto = v_rec_rapp_pos.cod_rapporto
                         ORDER BY val_ordinale DESC)
                 WHERE rownum = 1;

                IF v_flg_ristrutturato = 'Y'
                THEN
                  --                V_DTA_INIZIO_SEGN_RISTR:=V_DTA_INIZIO_SEGN_RISTR
                  v_dta_fine_segn_ristr := NULL;
                ELSE
                  v_dta_inizio_segn_ristr := NULL;
                  v_dta_fine_segn_ristr   := NULL;
                END IF;

              EXCEPTION
                WHEN no_data_found THEN
                  v_dta_inizio_segn_ristr := NULL;
                  v_dta_fine_segn_ristr   := NULL;
                  v_flg_ristrutturato     := 'N';
              END;

              BEGIN
                INSERT INTO t_mcrei_app_stime s
                  (s.id_dper,
                   s.cod_sndg,
                   s.cod_abi,
                   s.cod_ndg,
                   s.cod_rapporto,
                   s.cod_protocollo_delibera,
                   s.flg_tipo_dato,
                   s.cod_forma_tecnica,
                   s.cod_classe_ft,
                   s.flg_ristrutturato,
                   s.dta_stima,
                   s.dta_ins,
                   s.cod_microtipologia_delibera,
                   s.flg_attiva,
                   s.dta_inizio_segnalazione_ristr,
                   s.dta_fine_segnalazione_ristr)
                VALUES
                  (to_number(to_char(SYSDATE, 'YYYYMMDD')),
                   v_rec_rapp_pos.cod_sndg,
                   v_rec_rapp_pos.cod_abi,
                   v_rec_rapp_pos.cod_ndg,
                   v_rec_rapp_pos.cod_rapporto,
                   v_proto_delib,
                   'R',
                   v_rec_rapp_pos.cod_forma_tecnica,
                   v_rec_rapp_pos.cod_classe_ft,
                   v_flg_ristrutturato,
                   trunc(SYSDATE),
                   SYSDATE,
                   p_microtipolog,
                   '1',
                   v_dta_inizio_segn_ristr,
                   v_dta_fine_segn_ristr);
              EXCEPTION
                WHEN dup_val_on_index THEN
                  NULL;
              END;
            END LOOP;
            CLOSE rap_pos;

          END IF;
        END IF;--if protodelibera != -1, ovvero se esiste l'uo pratica per la posizione
    END IF;
    END LOOP;

    CLOSE posizioni;
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            p_utente_ins);
    RETURN p_proto_pacchetto;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_utente_ins);
      RETURN const_esito_ko;
  END aggiungi_microtipologia;

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
    RETURN VARCHAR2 IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.AGGIUNGI_MICROTIPOLOGIA_ACT';
    p_note             t_mcrei_wrk_audit_applicativo.note%TYPE;
    val_rdv_qc_progr   NUMBER := 0;
    v_rdv_progr_fi     NUMBER := 0;
    val_esp_netta_post NUMBER := 0;
    v_imp_perdita      NUMBER := 0;
    v_delibera_pre     t_mcrei_app_delibere.cod_protocollo_delibera_pre%TYPE;
    v_fase_pacc        t_mcrei_app_delibere.cod_fase_pacchetto%TYPE;
    v_data_pacc        t_mcrei_app_delibere.dta_creazione_pacchetto%TYPE;
    v_proto_delibera   t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
    v_uo_pratica       t_mcrei_app_pratiche.cod_uo_pratica%TYPE;
    v_stralcio_ct      NUMBER :=0;
  BEGIN
    p_note := 'Controllo parametri in ingresso';

    IF p_proto_pacchetto IS NULL OR
       p_abi IS NULL OR
       p_ndg IS NULL OR
       p_sndg IS NULL OR
       p_microtipolog IS NULL OR
       p_utente_ins IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'ABI: ' || p_abi || 'NDG: ' || p_ndg || ' TIP: ' ||
              p_microtipolog || ' prot: ' || p_proto_pacchetto;

    --v5.0 0320 aggiungo la tipologia con la stessa fase attuale del pacchetto
    SELECT DISTINCT cod_fase_pacchetto,
                    dta_creazione_pacchetto
      INTO v_fase_pacc,
           v_data_pacc
      FROM t_mcrei_app_delibere
     WHERE cod_protocollo_pacchetto = p_proto_pacchetto
       AND COD_FASE_PACCHETTO NOT IN ('ANA','ANM');

    BEGIN

      --0808 se l'ultima delibera contabilizzata S CT recupero la somma degli stralci come perdita iniziale
      begin
      v_stralcio_ct := NVL (pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct(p_abi,p_ndg), 0  );
      exception when others then
      v_stralcio_ct := 0;
      end;

      SELECT val_rdv_qc_progressiva,
             val_esp_netta_post_delib,
             cod_protocollo_delibera,
             val_rdv_progr_fi,
             val_imp_perdita
        INTO val_rdv_qc_progr,
             val_esp_netta_post,
             v_delibera_pre,
             v_rdv_progr_fi,
             v_imp_perdita
        FROM (SELECT nvl(s.val_rdv_qc_progressiva, 0) val_rdv_qc_progressiva,
                     nvl(s.val_esp_netta_post_delib, 0) val_esp_netta_post_delib,
                     s.cod_protocollo_delibera,
                     nvl(s.val_rdv_progr_fi, 0) AS val_rdv_progr_fi,
                     decode(s.cod_fase_delibera,
                            'CT',
                            --11 MAGGIO: aaggiunta logica su rinuncia pregressa in caso di CT
                            --MM 0808: in fase di inizializzazione, la rinuncia pregressa CT S lo stralcio capitalizzato
                            --nvl(s.val_rinuncia_totale, 0) -
                            --nvl(val_imp_perdita, 0) +
                            --nvl(s.val_sacrif_capit_mora, 0),
                            v_stralcio_ct,
                            nvl(s.val_imp_perdita, 0)) AS val_imp_perdita
              --6.0
                FROM t_mcrei_app_delibere s
               WHERE s.cod_abi = p_abi
                 AND s.cod_ndg = p_ndg
                 AND s.cod_fase_delibera IN ('AD', 'CO', 'CT', 'NA')
                    ---aggiunto CT il 11/4, NA il 24/4
                 AND s.flg_no_delibera = 0
                       ORDER BY s.dta_conferma_delibera  DESC,
                                s.val_num_progr_delibera DESC )
       WHERE rownum <= 1;
    EXCEPTION
      WHEN no_data_found THEN
        val_rdv_qc_progr   := 0;
        v_rdv_progr_fi     := 0;
        val_esp_netta_post := 0;
        v_imp_perdita      := 0;
        v_delibera_pre     := '#';
    END;

    BEGIN
      SELECT cod_uo_pratica
        INTO v_uo_pratica
        FROM t_mcrei_app_pratiche p
       WHERE p.cod_abi = p_abi
         AND p.cod_ndg = p_ndg;
    EXCEPTION
      WHEN OTHERS THEN
        v_uo_pratica := NULL;
    END;

    --invoco procedure per protocollo delibera
    v_proto_delibera := mcre_own.pkg_mcrei_gest_delibere.
                        fnc_mcrei_protocollo_delibera(v_uo_pratica,
                                                      p_utente_ins,
                                                      p_abi,
                                                      p_ndg);
    p_note           := p_note || ' nuova delibere: ' || v_proto_delibera;

    INSERT INTO t_mcrei_app_delibere d
      (id_dper,
       cod_sndg,
       cod_abi,
       cod_ndg,
       cod_protocollo_pacchetto,
       cod_protocollo_delibera,
       cod_protocollo_delibera_pre,
       flg_attiva,
       cod_microtipologia_delib,
       val_rdv_qc_progressiva,
       val_esp_netta_post_delib,
       val_rdv_qc_ante_delib,
       val_esp_netta_ante_delib,
       cod_fase_delibera,
       cod_fase_microtipologia,
       cod_fase_pacchetto,
       dta_creazione_pacchetto,
       dta_ins_delibera,
       cod_tipo_pacchetto,
       cod_matricola_inserente,
       cod_macrotipologia_delib,
       cod_pratica,
       val_anno_pratica,
       cod_uo_pratica,
       cod_segmento,
       desc_denominaz_ins_delibera,
       cod_filiale_delibera,
       val_num_progr_delibera,
       flg_no_delibera,
       val_rdv_progr_fi,
       val_rdv_pregr_fi,
       val_rinuncia_deliberata,
       val_imp_perdita ,--0807
       val_stralcio_senza_accantonam,
       desc_no_delibera)
      (SELECT to_number(to_char(trunc(SYSDATE), 'YYYYMMDD')),
              p_sndg,
              g.cod_abi_cartolarizzato,
              g.cod_ndg,
              p_proto_pacchetto,
              v_proto_delibera,
              v_delibera_pre,
              '1' AS flg_attiva,
              p_microtipolog,
              val_rdv_qc_progr AS val_rdv_qc_progressiva,

              --29.03
              pc.scsb_uti_cassa - val_rdv_qc_progr AS val_esp_netta_post_delib, --9 maggio
              val_rdv_qc_progr AS val_rdv_qc_ante_delib,
              pc.scsb_uti_cassa - val_rdv_qc_progr AS val_esp_netta_ante_delib, --9 maggio
              'IN',
              'INS',
              v_fase_pacc, --'INS',
              SYSDATE,
              v_data_pacc,
              ----dta_creazione_pacchetto esistente
              'M',
              p_utente_ins,
              t.cod_macrotipologia,
              p.cod_pratica,
              p.val_anno_pratica,
              p.cod_uo_pratica,
              a.val_segmento_regolamentare,
              (SELECT u.cognome || ' ' || u.nome AS denom_matricola
                 FROM t_mcre0_app_utenti u
                WHERE u.cod_matricola = p_utente_ins),
              g.cod_filiale,

              --                V_PROGRE_DELIB,
              seq_mcrei_prog_del.nextval,
              CASE --v7.5 considero dervivati su CI/CS
                WHEN ((nvl(pc.scsb_acc_tot, 0) + nvl(pc.scsb_uti_tot, 0) +
                       case when p_microtipolog in ('CI','CS') then
                        nvl(pc.scsb_acc_sostituzioni, 0) + nvl(pc.scsb_uti_sostituzioni, 0)
                        else 0 end) = 0 AND
                    p_microtipolog not in ( 'CH', 'PR', 'PS', 'PU' ) ) THEN --v5.3--v8.4 aggiunte proroghe
                 1
                ELSE
                 0
              END fl_no_del,
              nvl(v_rdv_progr_fi, 0),
              nvl(v_rdv_progr_fi, 0),
              v_imp_perdita,
              v_imp_perdita val_imp_perdita ,--0807
                            v_stralcio_ct,
                            CASE --v8.6
                WHEN ((nvl(pc.scsb_acc_tot, 0) + nvl(pc.scsb_uti_tot, 0) +
                       case when p_microtipolog in ('CI','CS') then
                        nvl(pc.scsb_acc_sostituzioni, 0) + nvl(pc.scsb_uti_sostituzioni, 0)
                        else 0 end) = 0 AND
                    p_microtipolog not in ( 'CH', 'PR', 'PS', 'PU' ) ) THEN --v5.3--v8.4 aggiunte proroghe
                 'Posizione con esposizione a 0'
                ELSE
                 null
              END desc_no_delibera
         FROM t_mcre0_app_all_data          g,
              t_mcrei_app_pratiche          p,
              t_mcrei_cl_tipologie          t,
              t_mcre0_app_anagrafica_gruppo a,
              t_mcrei_app_pcr_rapp_aggr     pc
        WHERE g.cod_abi_cartolarizzato = p_abi
          AND g.cod_ndg = p_ndg
          AND g.cod_sndg = a.cod_sndg
          AND g.today_flg = '1'
          AND g.cod_abi_cartolarizzato = p.cod_abi(+)
          AND g.cod_ndg = p.cod_ndg(+)
          AND g.cod_abi_cartolarizzato = pc.cod_abi_cartolarizzato(+)
          AND g.cod_ndg = pc.cod_ndg(+)
             --ESCLUTO CI PER INCAGLI E CI/CS PER SO
          AND decode(g.cod_stato, 'IN', 1, 'SO', 2, 0) <
              decode(p_microtipolog, 'CI', 1, 'CS', 2, 3)
             --            AND (SELECT NVL(PC.SCSB_ACC_TOT + PC.SCSB_UTI_TOT, 0)
             --                          FROM T_MCRE0_APP_PCR PC
             --                         WHERE PC.COD_ABI_CARTOLARIZZATO =
             --                               G.COD_ABI_CARTOLARIZZATO
             --                           AND PC.COD_NDG = G.COD_NDG) > 0
             -- SOLO TARGET E OUTSOURCING
          AND g.flg_outsourcing = 'Y'
          AND g.flg_target = 'Y'
          AND p.flg_attiva(+) = '1'
          AND t.cod_microtipologia = p_microtipolog
          AND t.flg_attivo = 1);

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            p_utente_ins);
    RETURN v_proto_delibera;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_utente_ins);
      RETURN const_esito_ko;
  END aggiungi_microtipologia_act;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE VERIFICA L'ESISTENZA DI UN PACCHETTO NON ANCORA CONFERMATO PER L'SNDG IN INPUT
  -- %D  LA FUNZIONE, PER L'SNDG IN INPUT, VERIFICA L'ESISTENZA DI UN EVENTUALE
  -- %D  PACCHETTO ANCORA APERTO. SE ESISTE, NE RESTITUISCE IL PROTOCOLLO,IN CASO CONTRARIO
  -- %D  RESTITUISCE NULL
  -- %CD 7 NOV 2011
  -- %PARAM P_SNDG: SUPER NDG
FUNCTION ctrl_esist_pacc_aperto(p_sndg IN VARCHAR2
                                ,P_COD_GRUPPO_SUPER IN VARCHAR2 default NULL --DR
                                ) RETURN VARCHAR2 IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.CTRL_ESIST_PACC_APERTO';
    v_protoc t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    p_note   t_mcrei_wrk_audit_applicativo.note%TYPE;

  BEGIN
    p_note := 'Controlla esistenza pacchetto aperto per sndg';

    IF p_sndg IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    BEGIN
      p_note := 'VERIFICA ESISTENZA PACCHETTO per ' || p_sndg;

      SELECT d.cod_protocollo_pacchetto
        INTO v_protoc
        FROM t_mcrei_app_delibere d,
             T_MCRE0_APP_ALL_DATA A
       WHERE d.cod_sndg = p_sndg
         AND cod_fase_pacchetto NOT IN ('ANM', 'ANA', 'ULT','VAR','SST')  ----AD:CORRETTO 28 DICEMBRE
            --PACCHETTO IN FASE DI ELABORAZIONE
         AND flg_attiva = '1'
         AND rownum = 1
         AND D.COD_ABI = A.COD_ABI_CARTOLARIZZATO
         AND D.COD_NDG = A.COD_NDG
         and a.cod_gruppo_super = nvl(P_COD_GRUPPO_SUPER,a.cod_gruppo_super);

      p_note := 'VERIFICA ESISTENZA PACCHETTO per ' || p_sndg || ': ' ||
                v_protoc;

      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN v_protoc;
    EXCEPTION
      WHEN no_data_found THEN
        v_protoc := NULL; ----NON ESISTE PROTOCOLLO
        RETURN v_protoc;
    END;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END ctrl_esist_pacc_aperto;  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE SETTA LA DATA DELIBERA A LIVELLO DI PACCHETTO IN INPUT
  -- %CD 23 FEB 20112
  FUNCTION update_data_delib_pacch(p_prot_pacch    IN VARCHAR2,
                                   p_data_delibera IN DATE,
                                   p_utente        IN VARCHAR2,
                                   p_abi           VARCHAR2 DEFAULT NULL,
                                   p_ndg           VARCHAR2 DEFAULT NULL,
                                   p_prot_delibera VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.UPDATE_DATA_DELIB_PACCH';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'UPDATE DATA DELIBERA SU PACCHETTO ' || p_prot_pacch ||
              ' ABI ' || p_abi || ' NDG ' || p_ndg;

    IF p_prot_pacch IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    CASE
      WHEN (p_abi IS NULL AND p_ndg IS NULL) THEN
        UPDATE t_mcrei_app_delibere de
           SET de.dta_delibera          = p_data_delibera,
               de.dta_last_upd_delibera = SYSDATE
         WHERE de.cod_protocollo_pacchetto = p_prot_pacch;

        --AGGIORNO ANCHE DATA RETE SE ESISTE UN 01025
        UPDATE t_mcrei_app_delibere de
           SET de.dta_delibera_rete     = p_data_delibera,
               de.dta_last_upd_delibera = SYSDATE
         WHERE de.cod_protocollo_pacchetto = p_prot_pacch
           AND de.cod_abi = '01025';
      ELSE
        UPDATE t_mcrei_app_delibere de
           SET de.dta_delibera_rete     = p_data_delibera,
               de.dta_last_upd_delibera = SYSDATE
         WHERE de.cod_protocollo_pacchetto = p_prot_pacch
           AND de.cod_abi = p_abi
           AND de.cod_ndg = p_ndg
           AND de.cod_protocollo_delibera = p_prot_delibera;
    END CASE;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            p_utente);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_utente);
      RETURN const_esito_ko;
  END update_data_delib_pacch;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE RIMUOVE UNA MICROTIPOLOGIA DA UN PACCHETTO
  -- %D  LA FUNZIONE, PER IL PACCHETTO IN INPUT, CANCELLA LE DELIBERE CORRISPONDENTI ALLA MICROTIPOLOGIA IN INPUT
  -- %CD 7 NOV 2011
  -- %PARAM P_PROT_PACCH
  -- %PARAM P_MICROTIPOL
  /* Formatted on 12/02/2013 19:10:36 (QP5 v5.115.810.9015) */
FUNCTION RIMUOVI_MICROTIPOLOGIA(P_PROT_PACCH IN VARCHAR2,
                                  p_microtipol IN VARCHAR2--,
                                 -- P_DTA_ANNULLO IN T_MCREI_APP_DELIBERE.DTA_ANNULLO%TYPE DEFAULT SYSDATE,
                                 -- P_COD_MATRICOLA_ANNULLO IN T_MCREI_APP_DELIBERE.COD_MATRICOLA_ANNULLO%TYPE DEFAULT NULL,
                                 -- P_COD_OPERA_COME_ANNULLO IN T_MCREI_APP_DELIBERE.COD_OPERA_COME_ANNULLO%TYPE DEFAULT NULL,
                                 -- P_DESC_NOTE_DELIBERE_ANNULLATE IN T_MCREI_APP_DELIBERE.DESC_NOTE_DELIBERE_ANNULLATE%TYPE DEFAULT NULL
                                 ) RETURN NUMBER IS

    c_nome CONSTANT VARCHAR2(100) := c_package || '.RIMUOVI_MICROTIPOLOGIA';
    v_fase_pacch t_mcrei_app_delibere.cod_fase_pacchetto%TYPE;
    P_NOTE       T_MCREI_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    P_COUNT      NUMBER;
    ret          NUMBER;

  BEGIN
    p_note := 'Rimuovi microtipologia per sndg';

    IF p_prot_pacch IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'RICERCA PACCHETTO ANCORA NON CONFERMATO su ' || p_prot_pacch ||
      ' ' ||
              p_microtipol;

    -- E' POSSIBILE RIMUOVERE UNA MICROTIPOLOGIA SOLO SE LA FASE DEL PACCHETTO
    -- A CUI APPARTIENE NON E' ANCORA CONFERMATA
    SELECT cod_fase_pacchetto
      INTO v_fase_pacch
      FROM t_mcrei_app_delibere d
     WHERE d.cod_protocollo_pacchetto = p_prot_pacch
       AND d.flg_attiva = '1'
        AND COD_FASE_PACCHETTO NOT IN ('ANA','ANM')
       AND rownum = 1;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);

    IF v_fase_pacch NOT IN ('CNF', 'ULT')
    THEN
      p_note := 'DELETE E ARCHIVIA MICROTIPOLIGIA O INTERO PACCHETTO su ' ||
                P_PROT_PACCH || ' ' || P_MICROTIPOL;

--aggiorno il pacchetto in base alla microtipologia
    UPDATE T_MCREI_APP_DELIBERE DE SET DE.COD_FASE_DELIBERA ='AN',
                                       DE.DTA_UPD_FASE_DELIBERA = SYSDATE,
                                       DE.COD_FASE_MICROTIPOLOGIA ='ANM',
                                       DE.DTA_UPD_FASE_MICROTIPOLOGIA = SYSDATE--,
                                       --DE.COD_MATRICOLA_ANNULLO = P_COD_MATRICOLA_ANNULLO,
                                       --DE.COD_OPERA_COME_ANNULLO = P_COD_OPERA_COME_ANNULLO,
                                       --DE.DTA_ANNULLO = P_DTA_ANNULLO,
                                       --DE.DESC_NOTE_DELIBERE_ANNULLATE = P_DESC_NOTE_DELIBERE_ANNULLATE
        WHERE DE.COD_PROTOCOLLO_PACCHETTO = P_PROT_PACCH
        AND (DE.COD_MICROTIPOLOGIA_DELIB = P_MICROTIPOL OR P_MICROTIPOL IS NULL)
                                       ;
    END IF;

     SELECT COUNT(*)
     INTO P_COUNT
     FROM T_MCREI_APP_DELIBERE
     WHERE COD_PROTOCOLLO_PACCHETTO = P_PROT_PACCH
     AND COD_FASE_MICROTIPOLOGIA NOT IN ('ANM','ANA')
     ;

--se all'interno del pacchetto ho solo delibere annullate allora annullo anche il pacchetto
      IF P_COUNT = 0
      THEN
        UPDATE T_MCREI_APP_DELIBERE DE SET DE.COD_FASE_PACCHETTO ='ANM',
                                           DE.DTA_UPD_FASE_PACCHETTO = SYSDATE
            WHERE DE.COD_PROTOCOLLO_PACCHETTO = P_PROT_PACCH
            ;

      END IF;
/*
       -- AD. 9 gen: sostituita delete con update settando fasi come annullate manualmente
       --AD:12 feb 2013 la delibera con microtipologia in input viene rimossa fisicamente dalla delibere e spostata nella tabella di scarti t_mcrei_app_Delib_rimosse
INSERT INTO mcre_own.t_mcrei_bkp_delib_rimosse (ID_DPER,
                                       COD_SNDG,
                                       COD_PROTOCOLLO_PACCHETTO,
                                       COD_ABI,
                                       COD_NDG,
                                       COD_PROTOCOLLO_DELIBERA,
                                       COD_PRATICA,
                                       VAL_ANNO_PRATICA,
                                       COD_MACROTIPOLOGIA_DELIB,
                                       COD_MICROTIPOLOGIA_DELIB,
                                       COD_FASE_DELIBERA,
                                       COD_FASE_MICROTIPOLOGIA,
                                       COD_FASE_PACCHETTO,
                                       COD_CAUSA_CHIUS_DELIBERA,
                                       COD_FILIALE_DELIBERA,
                                       COD_MATRICOLA_INSERENTE,
                                       COD_ORGANO_CALCOLATO,
                                       COD_ORGANO_DELIBERANTE,
                                       COD_ORGANO_DELIBERATO,
                                       COD_ORGANO_PACCHETTO,
                                       COD_PROTOCOLLO_DELIBERA_COL,
                                       COD_SEGMENTO,
                                       COD_TIPO_TRANSAZIONE,
                                       COD_UO_PRATICA,
                                       DESC_DENOMINAZ_INS_DELIBERA,
                                       DESC_NOTE,
                                       DESC_NOTE_DELIBERE_ANNULLATE,
                                       DESC_NOTE_RDV,
                                       DESC_PARERE_SNDG,
                                       DESC_TIPO_CONFERMA_DELIBERA,
                                       DTA_CONFERMA_DELIBERA,
                                       DTA_CREAZIONE_PACCHETTO,
                                       DTA_DELIBERA,
                                       DTA_DELIBERA_ESTERO,
                                       DTA_INGRESSO_RDV_SERVIZIO,
                                       DTA_CONFERMA_PACCHETTO,
                                       DTA_SCADENZA,
                                       DTA_SCADENZA_ESTERO,
                                       DTA_SCADENZA_TRANSAZ,
                                       DTA_LAST_UPD_DELIBERA,
                                       DTA_UPD_FASE_DELIBERA,
                                       DTA_UPD_FASE_MICROTIPOLOGIA,
                                       DTA_UPD_FASE_PACCHETTO,
                                       FLG_ART_136,
                                       FLG_ATTIVA,
                                       FLG_DELIB_IN_LINEA,
                                       FLG_NO_COLLEG_ALTRE_POS,
                                       FLG_NO_GARANZIE_CAPIENTI,
                                       FLG_NO_PATRIMON_AGGRED,
                                       FLG_NO_PRESUPPOSTI_CLASS_SOFF,
                                       FLG_NO_RISCHI_FIRMA,
                                       FLG_PARTI_CORRELATE,
                                       FLG_PERDUR_DIFFICOLTA_ECON,
                                       FLG_VISIONATO,
                                       VAL_ESP_LORDA,
                                       VAL_ESP_LORDA_CAPITALE,
                                       VAL_ESP_LORDA_MORA,
                                       VAL_ESP_NETTA_ANTE_DELIB,
                                       VAL_ESP_NETTA_POST_DELIB,
                                       VAL_IMP_OFFERTO,
                                       VAL_IMP_PERDITA,
                                       VAL_INTERESSI_FUTURI,
                                       VAL_PERC_PERD_RM,
                                       VAL_PERC_RDV,
                                       VAL_PERC_RDV_ESTERO,
                                       VAL_PERDITA_ATTUALE,
                                       VAL_PERDITA_DELIBERATA,
                                       VAL_PROGR_PROPOSTA,
                                       VAL_RDV_QC_ANTE_DELIB,
                                       VAL_RDV_QC_DELIBERATA,
                                       VAL_RDV_QC_PROGRESSIVA,
                                       VAL_RDV_QUOTA_MORA,
                                       VAL_RINUNCIA_CAPITALE,
                                       VAL_RINUNCIA_DELIBERATA,
                                       VAL_RINUNCIA_MORA,
                                       VAL_RINUNCIA_PROPOSTA,
                                       VAL_RDV_EXTRA_DELIBERA,
                                       VAL_STRALCIO_SENZA_ACCANTONAM,
                                       VAL_STRALCIO_QUOTA_CAP,
                                       VAL_STRALCIO_QUOTA_MORA,
                                       VAL_TASSO_BASE_APPL,
                                       VAL_ANNO_PROPOSTA,
                                       DTA_INS_DELIBERA,
                                       VAL_SACRIF_CAPIT_MORA,
                                       COD_TIPO_PACCHETTO,
                                       DTA_INS,
                                       DTA_UPD,
                                       COD_OPERATORE_INS_UPD,
                                       VAL_PERC_DUBBIO_ESITO,
                                       COD_INTEST_SCHED_GEN,
                                       COD_MATRICOLA_CONF_PROPOS,
                                       COD_STATO_PROPOSTO,
                                       COD_UO_PROPONENTE,
                                       COD_UO_PROPOSTA,
                                       DESC_ANAG_DELIBERANTE,
                                       DESC_ANAG_PROPONENTE,
                                       DESC_GARANZIE_ACCANTON,
                                       DESC_LIV_LAST_DELIB_FIDO,
                                       DESC_NOTE_ANNULLO_PROP,
                                       DESC_RAMO_AFFARI,
                                       DESC_RISCHI_INDIRETTI,
                                       DTA_ACCENSIONE_PROP_RISCHIO,
                                       DTA_CONSOLID_PROP_ORG_VIG,
                                       DTA_DELIB_PROP_DA_DELIBERANTE,
                                       DTA_DELIB_PROP_DA_PROPONENTE,
                                       DTA_INIZIO_RAPPORTO_CLIENTE,
                                       DTA_LAST_DELIBERA_FIDO,
                                       DTA_REVOCA_FIDO_IN_ESSERE,
                                       DTA_SUPERAM_STATO_RISCHIO,
                                       DTA_TRASFER_PROPO_FIL_AREA,
                                       FLG_CANCELLAZ_PROPOSTA,
                                       FLG_DISPOSIZIONE,
                                       NOTE_LAST_DELIB_FIDO,
                                       VAL_ACCORDATO,
                                       VAL_ACCORDATO_DERIVATI,
                                       VAL_ESP_TOT_CASSA,
                                       VAL_IMP_CREDITI_FIRMA,
                                       VAL_IMP_FONDI_TERZI,
                                       VAL_IMP_FONDI_TERZI_NB,
                                       VAL_IMP_UTILIZZO,
                                       VAL_INTERESSI_MORA_CASSA,
                                       FLG_NO_DELIBERA,
                                       DTA_CONGELAMENTO,
                                       VAL_UTI_TOT_SCSB,
                                       VAL_UTI_TOT_GEGB,
                                       VAL_UTI_CASSA_SCSB,
                                       VAL_UTI_FIRMA_SCSB,
                                       VAL_UTI_SOSTI_SCSB,
                                       FLG_100,
                                       FLG_DEPOSITI_COLLATERALI,
                                       FLG_SOGGETTO_POT_FALLIBILE,
                                       FLG_PRESEN_COVENANTS,
                                       FLG_INTERVEN_ORGANI_SUPERIORI,
                                       FLG_AFFIDAM_SOC_RECUPERO,
                                       DTA_RIF_DATI_CONTABILI,
                                       VAL_RISCHI_INDIRETTI,
                                       DESC_TIPO_GESTIONE,
                                       FLG_FONDO_TERZI,
                                       VAL_UTI_NETTO_FONDO_TERZI,
                                       DESC_MOTIVO_PASS_RISCHIO,
                                       COD_STATO_PROVENIENZA,
                                       VAL_NUM_PROGR_DELIBERA,
                                       FLG_TO_COPY,
                                       DTA_UDIENZA_VER_CRED,
                                       FLG_ESIST_DEBITORE_SOTTO_PROC,
                                       FLG_BENI_NON_IN_GARANZIA,
                                       FLG_AVVISO_EX498CPC,
                                       FLG_PIGNORAMENTI_IMMOBILIARI,
                                       FLG_PIGNORAMENTI_MOBILIARI,
                                       FLG_PIGNORAMENTI_TERZI,
                                       FLG_PROTESTI,
                                       FLG_IPOTECHE_BENI_DEB_GAR,
                                       FLG_GARANZIE_SGFA,
                                       FLG_GARANZIE_SACE,
                                       FLG_GARANZIE_CON_FIDI,
                                       FLG_GARANZIE_GENWORTH,
                                       FLG_PRATICA_URG,
                                       DESC_NOTE_URG,
                                       FLG_FORZ_MAN_GEST_INTERNA,
                                       DESC_NOTE_FORZATURA,
                                       FLG_LIBRETTI_PORTATORE_MINORI,
                                       FLG_RAPPORTI_CON_DEPOS_TITOLI,
                                       FLG_RAPPORTI_BLOCCATI,
                                       FLG_RAPPORTI_GARANZIA_CRED_FIR,
                                       FLG_RAPPORTO_CONCORDATO_PREVEN,
                                       FLG_CONTI_CATEG_2000,
                                       NUM_TELEFONO,
                                       INDIRIZZO_EMAIL,
                                       DESC_SECONDO_REFERENTE,
                                       NUM_TEL_SECONDO_REFERENTE,
                                       DESC_NOTE_RISCHI,
                                       COD_SAG,
                                       COD_STATO_SAG,
                                       DTA_CALC_CONF_SAG,
                                       DESC_MODAL_CONFERMA_SAG,
                                       COD_LAST_ORGANO_DELIB_FIDO,
                                       DTA_MOTIVO_PASS_RISCHIO,
                                       COD_MICROTIPOLOGIA_HOST,
                                       COD_TIPO_PROPOSTA,
                                       DESC_NOTE_GARANZIE_RICEVUTE,
                                       DESC_NOTE_GARANZIE_PRESTATE,
                                       DESC_NOTE_COERENZA,
                                       VAL_RDV_DELIB_BANCA_RETE,
                                       COD_STATO_PROPOSTA,
                                       COD_ORGANO_PACCHETTO_CALC,
                                       COD_DOC_DELIBERA_BANCA,
                                       COD_DOC_PARERE_CONFORMITA,
                                       COD_DOC_APPENDICE_PARERE,
                                       COD_DOC_DELIBERA_CAPOGRUPPO,
                                       COD_DOC_CLASSIFICAZIONE,
                                       DTA_SCADENZA_INCAGLIO,
                                       VAL_RINUNCIA_TOTALE,
                                       VAL_ACCORDATO_FIRMA,
                                       VAL_ACCORDATO_CASSA,
                                       DTA_DECORRENZA_STATO,
                                       VAL_UTI_TOT_SCGB,
                                       DTA_DELIBERA_RETE,
                                       COD_PROTOCOLLO_DELIBERA_NF,
                                       FLG_NO_GRUPPO_ECONOMICO,
                                       FLG_POSIZ_DA_CEDERE,
                                       DTA_SCAD_POST_PROROGA,
                                       VAL_RDV_RAPP_OPERATIVI,
                                       VAL_PERC_RETT_RAPP_FIRMA,
                                       DESC_TIPO_RISTR,
                                       DESC_INTENTO_RISTR,
                                       DTA_SCADENZA_RISTR,
                                       COD_STATO_POST_RISTR,
                                       COD_PROTOCOLLO_DELIBERA_PRE,
                                       VAL_RDV_PROGR_FI,
                                       VAL_RDV_PREGR_FI,
                                       VAL_RDV_EXTRA_FI,
                                       VAL_ESP_FIRMA,
                                       DTA_EFFICACIA_RISTR,
                                       DTA_EFFICACIA_ADD,
                                       DTA_CHIUSURA_RISTR,
                                       FLG_RISTR_EREDITATA,
                                       FLG_RISTRUTTURATO,
                                       FLG_RDV,
                                       FLG_FORZ_DA_IMP,
                                       COD_FASE_MICROTIP_PRE_ADD,
                                       COD_FASE_DELIB_PRE_ADD,
                                       COD_PACCHETTO_MODIFICATO,
                                       COD_MICROTIP_VARIAZIONE,
                                       COD_DELIBERA_MODIFICATO,
                                       FLG_DELIB_FORZATA,
                                       FLG_PACCHETTO_CLONATO,
                                       COD_PACCHETTO_SERVIZIO,
                                       COD_DELIBERA_SERVIZIO,
                                       COD_STATO_POSIZ,
                                       DTA_DEC_STATO_POSIZ)
   SELECT   ID_DPER,
            COD_SNDG,
            COD_PROTOCOLLO_PACCHETTO,
            COD_ABI,
            COD_NDG,
            COD_PROTOCOLLO_DELIBERA,
            COD_PRATICA,
            VAL_ANNO_PRATICA,
            COD_MACROTIPOLOGIA_DELIB,
            COD_MICROTIPOLOGIA_DELIB,
            COD_FASE_DELIBERA,
            COD_FASE_MICROTIPOLOGIA,
            COD_FASE_PACCHETTO,
            COD_CAUSA_CHIUS_DELIBERA,
            COD_FILIALE_DELIBERA,
            COD_MATRICOLA_INSERENTE,
            COD_ORGANO_CALCOLATO,
            COD_ORGANO_DELIBERANTE,
            COD_ORGANO_DELIBERATO,
            COD_ORGANO_PACCHETTO,
            COD_PROTOCOLLO_DELIBERA_COL,
            COD_SEGMENTO,
            COD_TIPO_TRANSAZIONE,
            COD_UO_PRATICA,
            DESC_DENOMINAZ_INS_DELIBERA,
            DESC_NOTE,
            DESC_NOTE_DELIBERE_ANNULLATE,
            DESC_NOTE_RDV,
            DESC_PARERE_SNDG,
            DESC_TIPO_CONFERMA_DELIBERA,
            DTA_CONFERMA_DELIBERA,
            DTA_CREAZIONE_PACCHETTO,
            DTA_DELIBERA,
            DTA_DELIBERA_ESTERO,
            DTA_INGRESSO_RDV_SERVIZIO,
            DTA_CONFERMA_PACCHETTO,
            DTA_SCADENZA,
            DTA_SCADENZA_ESTERO,
            DTA_SCADENZA_TRANSAZ,
            DTA_LAST_UPD_DELIBERA,
            DTA_UPD_FASE_DELIBERA,
            DTA_UPD_FASE_MICROTIPOLOGIA,
            DTA_UPD_FASE_PACCHETTO,
            FLG_ART_136,
            FLG_ATTIVA,
            FLG_DELIB_IN_LINEA,
            FLG_NO_COLLEG_ALTRE_POS,
            FLG_NO_GARANZIE_CAPIENTI,
            FLG_NO_PATRIMON_AGGRED,
            FLG_NO_PRESUPPOSTI_CLASS_SOFF,
            FLG_NO_RISCHI_FIRMA,
            FLG_PARTI_CORRELATE,
            FLG_PERDUR_DIFFICOLTA_ECON,
            FLG_VISIONATO,
            VAL_ESP_LORDA,
            VAL_ESP_LORDA_CAPITALE,
            VAL_ESP_LORDA_MORA,
            VAL_ESP_NETTA_ANTE_DELIB,
            VAL_ESP_NETTA_POST_DELIB,
            VAL_IMP_OFFERTO,
            VAL_IMP_PERDITA,
            VAL_INTERESSI_FUTURI,
            VAL_PERC_PERD_RM,
            VAL_PERC_RDV,
            VAL_PERC_RDV_ESTERO,
            VAL_PERDITA_ATTUALE,
            VAL_PERDITA_DELIBERATA,
            VAL_PROGR_PROPOSTA,
            VAL_RDV_QC_ANTE_DELIB,
            VAL_RDV_QC_DELIBERATA,
            VAL_RDV_QC_PROGRESSIVA,
            VAL_RDV_QUOTA_MORA,
            VAL_RINUNCIA_CAPITALE,
            VAL_RINUNCIA_DELIBERATA,
            VAL_RINUNCIA_MORA,
            VAL_RINUNCIA_PROPOSTA,
            VAL_RDV_EXTRA_DELIBERA,
            VAL_STRALCIO_SENZA_ACCANTONAM,
            VAL_STRALCIO_QUOTA_CAP,
            VAL_STRALCIO_QUOTA_MORA,
            VAL_TASSO_BASE_APPL,
            VAL_ANNO_PROPOSTA,
            DTA_INS_DELIBERA,
            VAL_SACRIF_CAPIT_MORA,
            COD_TIPO_PACCHETTO,
            DTA_INS,
            DTA_UPD,
            COD_OPERATORE_INS_UPD,
            VAL_PERC_DUBBIO_ESITO,
            COD_INTEST_SCHED_GEN,
            COD_MATRICOLA_CONF_PROPOS,
            COD_STATO_PROPOSTO,
            COD_UO_PROPONENTE,
            COD_UO_PROPOSTA,
            DESC_ANAG_DELIBERANTE,
            DESC_ANAG_PROPONENTE,
            DESC_GARANZIE_ACCANTON,
            DESC_LIV_LAST_DELIB_FIDO,
            DESC_NOTE_ANNULLO_PROP,
            DESC_RAMO_AFFARI,
            DESC_RISCHI_INDIRETTI,
            DTA_ACCENSIONE_PROP_RISCHIO,
            DTA_CONSOLID_PROP_ORG_VIG,
            DTA_DELIB_PROP_DA_DELIBERANTE,
            DTA_DELIB_PROP_DA_PROPONENTE,
            DTA_INIZIO_RAPPORTO_CLIENTE,
            DTA_LAST_DELIBERA_FIDO,
            DTA_REVOCA_FIDO_IN_ESSERE,
            DTA_SUPERAM_STATO_RISCHIO,
            DTA_TRASFER_PROPO_FIL_AREA,
            FLG_CANCELLAZ_PROPOSTA,
            FLG_DISPOSIZIONE,
            NOTE_LAST_DELIB_FIDO,
            VAL_ACCORDATO,
            VAL_ACCORDATO_DERIVATI,
            VAL_ESP_TOT_CASSA,
            VAL_IMP_CREDITI_FIRMA,
            VAL_IMP_FONDI_TERZI,
            VAL_IMP_FONDI_TERZI_NB,
            VAL_IMP_UTILIZZO,
            VAL_INTERESSI_MORA_CASSA,
            FLG_NO_DELIBERA,
            DTA_CONGELAMENTO,
            VAL_UTI_TOT_SCSB,
            VAL_UTI_TOT_GEGB,
            VAL_UTI_CASSA_SCSB,
            VAL_UTI_FIRMA_SCSB,
            VAL_UTI_SOSTI_SCSB,
            FLG_100,
            FLG_DEPOSITI_COLLATERALI,
            FLG_SOGGETTO_POT_FALLIBILE,
            FLG_PRESEN_COVENANTS,
            FLG_INTERVEN_ORGANI_SUPERIORI,
            FLG_AFFIDAM_SOC_RECUPERO,
            DTA_RIF_DATI_CONTABILI,
            VAL_RISCHI_INDIRETTI,
            DESC_TIPO_GESTIONE,
            FLG_FONDO_TERZI,
            VAL_UTI_NETTO_FONDO_TERZI,
            DESC_MOTIVO_PASS_RISCHIO,
            COD_STATO_PROVENIENZA,
            VAL_NUM_PROGR_DELIBERA,
            FLG_TO_COPY,
            DTA_UDIENZA_VER_CRED,
            FLG_ESIST_DEBITORE_SOTTO_PROC,
            FLG_BENI_NON_IN_GARANZIA,
            FLG_AVVISO_EX498CPC,
            FLG_PIGNORAMENTI_IMMOBILIARI,
            FLG_PIGNORAMENTI_MOBILIARI,
            FLG_PIGNORAMENTI_TERZI,
            FLG_PROTESTI,
            FLG_IPOTECHE_BENI_DEB_GAR,
            FLG_GARANZIE_SGFA,
            FLG_GARANZIE_SACE,
            FLG_GARANZIE_CON_FIDI,
            FLG_GARANZIE_GENWORTH,
            FLG_PRATICA_URG,
            DESC_NOTE_URG,
            FLG_FORZ_MAN_GEST_INTERNA,
            DESC_NOTE_FORZATURA,
            FLG_LIBRETTI_PORTATORE_MINORI,
            FLG_RAPPORTI_CON_DEPOS_TITOLI,
            FLG_RAPPORTI_BLOCCATI,
            FLG_RAPPORTI_GARANZIA_CRED_FIR,
            FLG_RAPPORTO_CONCORDATO_PREVEN,
            FLG_CONTI_CATEG_2000,
            NUM_TELEFONO,
            INDIRIZZO_EMAIL,
            DESC_SECONDO_REFERENTE,
            NUM_TEL_SECONDO_REFERENTE,
            DESC_NOTE_RISCHI,
            COD_SAG,
            COD_STATO_SAG,
            DTA_CALC_CONF_SAG,
            DESC_MODAL_CONFERMA_SAG,
            COD_LAST_ORGANO_DELIB_FIDO,
            DTA_MOTIVO_PASS_RISCHIO,
            COD_MICROTIPOLOGIA_HOST,
            COD_TIPO_PROPOSTA,
            DESC_NOTE_GARANZIE_RICEVUTE,
            DESC_NOTE_GARANZIE_PRESTATE,
            DESC_NOTE_COERENZA,
            VAL_RDV_DELIB_BANCA_RETE,
            COD_STATO_PROPOSTA,
            COD_ORGANO_PACCHETTO_CALC,
            COD_DOC_DELIBERA_BANCA,
            COD_DOC_PARERE_CONFORMITA,
            COD_DOC_APPENDICE_PARERE,
            COD_DOC_DELIBERA_CAPOGRUPPO,
            COD_DOC_CLASSIFICAZIONE,
            DTA_SCADENZA_INCAGLIO,
            VAL_RINUNCIA_TOTALE,
            VAL_ACCORDATO_FIRMA,
            VAL_ACCORDATO_CASSA,
            DTA_DECORRENZA_STATO,
            VAL_UTI_TOT_SCGB,
            DTA_DELIBERA_RETE,
            COD_PROTOCOLLO_DELIBERA_NF,
            FLG_NO_GRUPPO_ECONOMICO,
            FLG_POSIZ_DA_CEDERE,
            DTA_SCAD_POST_PROROGA,
            VAL_RDV_RAPP_OPERATIVI,
            VAL_PERC_RETT_RAPP_FIRMA,
            DESC_TIPO_RISTR,
            DESC_INTENTO_RISTR,
            DTA_SCADENZA_RISTR,
            COD_STATO_POST_RISTR,
            COD_PROTOCOLLO_DELIBERA_PRE,
            VAL_RDV_PROGR_FI,
            VAL_RDV_PREGR_FI,
            VAL_RDV_EXTRA_FI,
            VAL_ESP_FIRMA,
            DTA_EFFICACIA_RISTR,
            DTA_EFFICACIA_ADD,
            DTA_CHIUSURA_RISTR,
            FLG_RISTR_EREDITATA,
            FLG_RISTRUTTURATO,
            FLG_RDV,
            FLG_FORZ_DA_IMP,
            COD_FASE_MICROTIP_PRE_ADD,
            COD_FASE_DELIB_PRE_ADD,
            COD_PACCHETTO_MODIFICATO,
            COD_MICROTIP_VARIAZIONE,
            COD_DELIBERA_MODIFICATO,
            FLG_DELIB_FORZATA,
            FLG_PACCHETTO_CLONATO,
            COD_PACCHETTO_SERVIZIO,
            COD_DELIBERA_SERVIZIO,
            COD_STATO_POSIZ,
            DTA_DEC_STATO_POSIZ
     FROM   t_mcrei_app_delibere
    WHERE   cod_protocollo_pacchetto = p_prot_pacch
            AND (cod_microtipologia_delib = p_microtipol
                 OR p_microtipol IS NULL);


       DELETE t_mcrei_app_delibere de
         WHERE de.cod_protocollo_pacchetto = p_prot_pacch
         AND (de.cod_microtipologia_delib = p_microtipol OR
             P_MICROTIPOL IS NULL);
*/
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      --SE NON VIENE PASSATA LA MICROTIPOLOGIA, SI CANCELLA e si archivia L'INTERO PACCHETTO
   -- END IF;

    --A seguito della rimozione di una microtipologia,
    --recupero le restanti microtipologie del pacchetto corrente che sono da retrocedere

    p_note :=
      'loop per retrocessione wf su tutte le microtipologie del pacchetto ' ||
              p_prot_pacch;

    FOR c IN (SELECT cod_microtipologia_delib
                FROM mcre_own.t_mcrei_app_delibere d
               WHERE cod_protocollo_pacchetto = p_prot_pacch
                 AND cod_fase_delibera != 'AN'
                 AND flg_attiva = '1')

    LOOP
      p_note := 'retrocedi_wf_pacchetto per microtipologia ' ||
                c.cod_microtipologia_delib;

      ret := retrocedi_wf_pacchetto(p_prot_pacch,
                                    c.cod_microtipologia_delib,
                                    'AUTO');

    END LOOP;

    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END rimuovi_microtipologia;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE RIMUOVE UN PACCHETTO
  -- %D  LA FUNZIONE, PER IL PACCHETTO IN INPUT, CANCELLA TUTTE LE DELIBERE CORRISPONDENTI
  -- %PARAM P_PROT_PACCH
  FUNCTION rimuovi_pacchetto(p_prot_pacch IN VARCHAR2) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.RIMUOVI_PACCHETTO';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'rimuovi pacchetto ' || p_prot_pacch;

    IF p_prot_pacch IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    --ad: 9 GEN, sostituita delete con update settando fasi come annullate manualmente
    --DELETE t_mcrei_app_delibere de
     update T_MCREI_APP_DELIBERE de
       SET cod_fase_delibera = 'AN',
       COD_FASE_MICROTIPOLOGIA = 'ANM',
       COD_fASE_PACCHETTO = 'ANM'
     WHERE de.cod_protocollo_pacchetto = p_prot_pacch;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END rimuovi_pacchetto;

  -- %AUTHOR REPLY
  -- %VERSION 0.2
  -- %USAGE  FUNZIONE CHE MODIFICA L'ABILITAZIONE DELLA DELIBERA INDICATA IN INPUT
  -- %D  LA FUNZIONE, PER IL PACCHETTO IN INPUT, SETTA PER LA DELIBERA CORRISPONDENTE
  -- %D  AL PROTOCOLLO DELIBERA IN INPUT IL FLAG DI ABILITAZIONE IN INPUT
  -- %CD 04.01.2011
  -- %PARAM P_PROT_PACCH
  -- %PARAM P_NDG
  -- %PARAM P_ABI
  -- %PARAM P_PROT_DELIB
  -- %PARAM P_FLG_NO_DEL
  -- %PARAM P_UTENTE -->MATRICOLA CHE EFFETTUA L'UPDATE
  FUNCTION setta_abilitazione_delib(p_abi        IN VARCHAR2,
                                    p_ndg        IN VARCHAR2,
                                    p_prot_delib IN VARCHAR2,
                                    p_flg_no_del IN NUMBER,
                                    p_utente     VARCHAR2,
                                    p_desc_no_delibera VARCHAR2 default null
                                    ) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.SETTA_ABILITAZIONE_DELIB';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'SETTA ABILITAZIONE DELIBERA';

    IF p_abi IS NULL OR
       p_ndg IS NULL OR
       p_prot_delib IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    UPDATE t_mcrei_app_delibere g--v8.6
       SET g.flg_no_delibera       = p_flg_no_del,
           g.dta_last_upd_delibera = SYSDATE,
           g.desc_no_delibera=p_desc_no_delibera
     WHERE g.cod_abi = p_abi
       AND g.cod_ndg = p_ndg
       AND g.cod_protocollo_delibera = p_prot_delib;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            'abi: ' || p_abi || 'ndg: ' || p_ndg ||
                            'delibera: ' || p_prot_delib || 'flag: ' ||
                            p_flg_no_del,
                            p_utente);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END setta_abilitazione_delib;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE CONFERMA IL PACCHETTO IN INPUT
  -- %D  LA FUNZIONE, PER IL PACCHETTO IN INPUT, SETTA GLI ATTRIBUTI DI PACCHETTO SULLA TABELLE
  -- %D  DELLE DELIBERE, INDICANDO LA AVVENUTA CONFERMA DA PARTE DEL GESTORE
  -- %CD 25 NOV 2011
  -- %PARAM P_PROT_PACCHET
  FUNCTION conferma_pacchetto(p_prot_pacchet IN VARCHAR2) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.CONFERMA_PACCHETTO';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'CONFERMA PACCHETTO ' || p_prot_pacchet;

    IF p_prot_pacchet IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    UPDATE t_mcrei_app_delibere de
       SET de.dta_conferma_pacchetto = SYSDATE,
           de.cod_fase_pacchetto     = const_pacch_confermato
     WHERE de.cod_protocollo_pacchetto = p_prot_pacchet;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END conferma_pacchetto;

  -- ======================= AGGIORNAMENTO FASI ===============================

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE FA AVANZARE LA FASE DELLA MICROTIPOLOGIA IN INPUT
  -- %D  LA FUNZIONE, PER IL PACCHETTO IN INPUT, FA AVANZARE LA FASE IN CUI SI TROVA
  -- %D  LA MICROTIPOLOGIA SPECIFICATA IN INPUT
  -- %CD 25 NOV 2011
  -- %PARAM P_PROT_PACC
  -- %PARAM P_MICROTIPO
  -- %PARAM P_NEW_FASE: SIGLA NELLA FASE IN CUI VIENE FATTA AVANZARE LA MICROTIPOLOGIA
  FUNCTION cambia_fase_microtipologia(p_prot_pacc IN VARCHAR2,
                                      p_microtipo IN VARCHAR2,
                                      p_new_fase  IN VARCHAR2) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.CAMBIA_FASE_MICROTIPOLOGIA';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'CAMBIA FASE MICROTIPOLIGIA ' || p_prot_pacc || ' ' ||
              p_microtipo || ' ->' || p_new_fase;

    IF p_prot_pacc IS NULL OR
       p_microtipo IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    UPDATE t_mcrei_app_delibere de
       SET de.dta_last_upd_delibera       = SYSDATE,
           de.cod_fase_microtipologia     = p_new_fase,
           de.dta_upd_fase_microtipologia = SYSDATE
     WHERE de.cod_protocollo_pacchetto = p_prot_pacc
       AND de.cod_microtipologia_delib = p_microtipo
       AND de.cod_fase_microtipologia NOT IN ('ANM', 'ANA');

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END cambia_fase_microtipologia;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE FA AVANZARE LA FASE DELLA DELIBERA (STATO DELIBERA)
  -- %D  LA FUNZIONE, PER LA DELIBERA IN INPUT, AGGIORNA LA FASE (OVVERO LO STATO)
  -- %CD 25 NOV 2011
  -- %PARAM P_ABI
  -- %PARAM P_NDG
  -- %PARAM P_PROT_DELIB
  -- %PARAM P_NEW_FASE
  -- %PARAM P_FLG_CONFERMA: Y --> LA DELIBERA E' STATA CONFERMATA, QUINDI P_NEW_FASE = 'CO'
    FUNCTION cambia_fase_delibera(p_abi            IN VARCHAR2,
                                p_ndg            IN VARCHAR2,
                                p_prot_delib     IN VARCHAR2,
                                p_new_fase       IN VARCHAR2,
                                p_microtipologia IN VARCHAR2,
                                p_flg_conferma   IN VARCHAR2 DEFAULT 'N' /*,
                                                                p_v_stralcio_quota_cap  IN t_mcrei_app_delibere.val_stralcio_quota_cap%TYPE DEFAULT NULL,
                                                                p_v_stralcio_quota_mora IN t_mcrei_app_delibere.val_stralcio_quota_mora%TYPE DEFAULT NULL*/)
  --t_mcrei_app_delibere
   RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.CAMBIA_FASE_DELIBERA';
    p_note         t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_flg_conferma VARCHAR2(1);
    v_protoc       t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    v_rin_proposta NUMBER := 0;
    v_scadenza_stato date:= null; --22 nov
    V_SCADENZA_INCAGLIO date:= null; --9 GENNAIO
    v_stato_posiz  t_mcre0_App_all_Data.cod_Stato%type;--28 gen AD: per salvataggio stato della posizione in fase di conferma delibera
    v_dta_dec_stato_posiz date;
  BEGIN
    p_note := 'Cambia fase delibera';
    v_stato_posiz := NULL;
    v_dta_dec_stato_posiz := null;

    IF p_abi IS NULL OR
       p_ndg IS NULL OR
       p_prot_delib IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    IF p_new_fase = 'CO' ---
    THEN
      v_flg_conferma := 'Y';

    IF p_microtipologia NOT IN ('CI', 'CS', 'CZ') THEN   ----per delibere diverse dalle classificazioni

     BEGIN


        SELECT DISTINCT
           --0629 fine gestione come proroga implicita se RV
          CASE
             WHEN d."COD_MICROTIPOLOGIA_DELIB" IN    ('RV', 'T4', 'A0', 'IM', 'IF') THEN  --uso la regola standard, usata anche nelle classificazioni
              CASE WHEN (X.cod_comparto_calcolato = '011901') THEN
                   CASE
                       WHEN DECODE (dta_esito,  NULL, dta_servizio + c.val_gg_prima_proroga,  dta_esito + c.val_gg_seconda_proroga) <  SYSDATE
                       THEN TRUNC (SYSDATE) + c.val_gg_seconda_proroga
                       ELSE DECODE (dta_esito, NULL, dta_servizio + c.val_gg_prima_proroga,  dta_esito + c.val_gg_seconda_proroga)
                    END
              ELSE -- DA DIVISIONE IN GIU
                     CASE
                           WHEN  (X.DTA_SCADENZA_STATO <  SYSDATE) THEN TRUNC (SYSDATE) + 30
                           ELSE X.DTA_SCADENZA_STATO
                        END
                END
             ELSE  p."DTA_FINE_GESTIONE"
          END
             AS DTA_FINE_GESTIONE,
              x.cod_Stato,
              x.dta_decorrenza_stato
          INTO v_scadenza_stato,
               v_stato_posiz,
               v_dta_dec_stato_posiz
      FROM t_mcrei_app_delibere d,
           t_mcrei_app_pratiche p,
           t_mcre0_app_rio_proroghe r,
           t_mcre0_app_comparti c,
           t_mcre0_app_all_data x
    WHERE     d.cod_abi = p.cod_abi
           AND d.cod_ndg = p.cod_ndg
           AND d.cod_sndg = p.cod_sndg
           AND d.cod_pratica = p.cod_pratica
           AND d.val_anno_pratica = p.val_anno_pratica
           AND p.flg_attiva = '1'
           AND d.flg_attiva = '1'
           AND D.FLG_NO_DELIBERA = 0                                      --11 OCT
           AND d.cod_abi = x.cod_abi_cartolarizzato
           AND d.cod_ndg = x.cod_ndg
           and d.cod_abi =p_abi
           and d.cod_ndg =p_ndg
           and d.cod_protocollo_delibera = p_prot_delib
           AND NVL (x.cod_comparto_assegnato, cod_comparto_calcolato) =c.cod_comparto(+)
           AND x.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
           AND x.cod_ndg = r.cod_ndg(+)
           AND X.TODAY_FLG = '1'
           AND r.flg_storico(+) = 0
           AND r.flg_esito(+) = 1;
    EXCEPTION WHEN OTHERS THEN
        v_scadenza_stato:=NULL;
        v_stato_posiz := 'nd';
        v_dta_dec_stato_posiz:=to_date(null);
        pkg_mcrei_audit.log_app(c_nome,
                        pkg_mcrei_audit.c_debug,
                        SQLCODE,
                        SQLERRM,
                        'FALLIMENTO RECUPERO DATA SCADENZA STATO PER DELIBERA '||P_PROT_DELIB||CHR(10),
                        NULL);
    END;
    ELSE
        v_scadenza_stato:=to_Date ('31/12/9999','dd/mm/yyyy');
        v_stato_posiz := 'nd';
        v_dta_dec_stato_posiz:=to_date(null);
    END IF;   -----FINE GESTIONE DELIBERE NOT IN CI E CS


    END IF;


    CASE
      WHEN v_flg_conferma = 'Y' THEN
        p_note := 'FLG_CONFERMA = ''Y'', UPDATE T_MCREI_APP_DELIBERE ' ||
                  p_prot_delib || ' ' || p_new_fase || ' ' ||
                  p_microtipologia;

    IF p_microtipologia NOT IN ('CI','CS','CZ')
        THEN
        BEGIN


        SELECT DISTINCT
           --0629 fine gestione come proroga implicita se RV
--           CASE
--              WHEN d."COD_MICROTIPOLOGIA_DELIB" IN ('RV', 'T4', 'A0', 'IM', 'IF') THEN
--                 --uso la regola standard, usata anche nelle classificazioni
--                 CASE
--                    WHEN DECODE (dta_esito,
--                                 NULL, dta_servizio + c.val_gg_prima_proroga,
--                                 dta_esito + c.val_gg_seconda_proroga) < SYSDATE
--                    THEN
--                       TRUNC (SYSDATE) + c.val_gg_seconda_proroga
--                    ELSE
                       DECODE (dta_esito,NULL, dta_servizio + c.val_gg_prima_proroga,DTA_ESITO + C.VAL_GG_SECONDA_PROROGA)  AS DTA_FINE_GESTIONE, --01/08/2013  CR Proroghe
--                 END
             -- ELSE
           --      P."DTA_FINE_GESTIONE"
          -- END
              --AS DTA_FINE_GESTIONE,
              x.cod_Stato,
              x.dta_decorrenza_stato
          INTO v_scadenza_stato,
               v_stato_posiz,
               v_dta_dec_stato_posiz
      FROM t_mcrei_app_delibere d,
           t_mcrei_app_pratiche p,
           t_mcre0_app_rio_proroghe r,
           t_mcre0_app_comparti c,
           t_mcre0_app_all_data x
    WHERE     d.cod_abi = p.cod_abi
           AND d.cod_ndg = p.cod_ndg
           AND d.cod_sndg = p.cod_sndg
           AND d.cod_pratica = p.cod_pratica
           AND d.val_anno_pratica = p.val_anno_pratica
           AND p.flg_attiva = '1'
           AND d.flg_attiva = '1'
           AND D.FLG_NO_DELIBERA = 0                                      --11 OCT
           AND d.cod_abi = x.cod_abi_cartolarizzato
           AND d.cod_ndg = x.cod_ndg
           and d.cod_abi =p_abi
           and d.cod_ndg =p_ndg
           and d.cod_protocollo_delibera = p_prot_delib
           AND NVL (x.cod_comparto_assegnato, cod_comparto_calcolato) =c.cod_comparto(+)
           AND x.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
           AND x.cod_ndg = r.cod_ndg(+)
           AND X.TODAY_FLG = '1'
           AND r.flg_storico(+) = 0
           AND r.flg_esito(+) = 1;

    EXCEPTION WHEN OTHERS THEN
        v_scadenza_stato:=NULL;
        v_stato_posiz := 'nd';
        v_dta_dec_stato_posiz:=to_date(null);
        pkg_mcrei_audit.log_app(c_nome,
                        pkg_mcrei_audit.c_debug,
                        SQLCODE,
                        SQLERRM,
                        'FALLIMENTO RECUPERO DATA SCADENZA STATO PER DELIBERA '||P_PROT_DELIB||CHR(10),
                        NULL);
    END;

    ELSE
        v_scadenza_stato:=to_Date ('31/12/9999','dd/mm/yyyy');
        v_stato_posiz := 'nd';
        v_dta_dec_stato_posiz:=to_date(null);
    end if;

    BEGIN --v7.0
    SELECT   DISTINCT nullif(cod_Stato,'-1') cod_Stato,
             dta_decorrenza_stato
      INTO   v_stato_posiz,
             v_dta_dec_stato_posiz
      FROM   t_mcre0_App_all_Data dd
     WHERE   dd.cod_abi_Cartolarizzato = P_ABI
             AND dd.cod_ndg = P_ndg
             AND flg_active = '1';
    EXCEPTION WHEN OTHERS THEN
             v_stato_posiz := null;
             v_dta_dec_stato_posiz := null;
    END;


        UPDATE t_mcrei_app_delibere de
           SET de.dta_conferma_delibera = SYSDATE,
               de.dta_scadenza = --decode(cod_microtipologia_delib,'PR', DE.dta_scadenza,v_scadenza_stato),
               --MM131211 - aggiunta CI alle tipol che non cambiano scadenza
                        case when cod_microtipologia_delib in ('PS','PU','PR','CI') then DE.dta_scadenza else v_scadenza_stato end ,--('PT','PD','PR')
               de.dta_last_upd_delibera = SYSDATE,
               de.cod_fase_delibera     = p_new_fase,
               de.cod_stato_posiz       = v_stato_posiz,--28 gen
               de.dta_dec_stato_posiz   = v_dta_dec_stato_posiz, --31 gen
               de.desc_tipo_gestione    = decode(p_microtipologia,
                                                 'RV',
                                                 'F',
                                                 de.desc_tipo_gestione), --5 GIU: L'RV viene inserita sempre con gestione analitica
               de.dta_upd_fase_delibera = SYSDATE /*,
                       de.val_stralcio_quota_cap  = nvl(p_v_stralcio_quota_cap,
                                                        de.val_stralcio_quota_cap),
                       de.val_stralcio_quota_mora = nvl(p_v_stralcio_quota_mora,
                                                        val_stralcio_quota_mora)*/
         WHERE de.cod_abi = p_abi
           AND de.cod_ndg = p_ndg
           AND de.cod_protocollo_delibera = p_prot_delib
           AND de.cod_fase_delibera != 'AN';

        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                SQLERRM,
                                p_note,
                                NULL);

        -- Se SI STA CONFERMANDO UNA CLASSIFICAZIONE, SI AGGIUNGE ALLA TABELLA DELLE
        --POSIZIONI CON CLASSIFICAZIONE IN CORSO IL RECORD
        IF p_microtipologia IN ('CI', 'CS', 'CZ')   ----delibere di classificazione
        THEN
          p_note := ' INSERT INTO t_mcrei_app_posiz_con_classif PER MICROTIPOLIGIA IN ''CI'',''CS'',''CZ''';

          INSERT INTO t_mcrei_app_posiz_con_classif
            (cod_sndg,
             desc_nome_controparte,
             cod_ndg,
             cod_abi_istituto,
             desc_istituto,
             cod_abi_cartolarizzato,
             cod_gruppo_economico,
             desc_gruppo_economico,
             cod_struttura_competente_dc,
             desc_struttura_competente_dc,
             cod_struttura_competente_rg,
             desc_struttura_competente_rg,
             cod_struttura_competente_ar,
             desc_struttura_competente_ar,
             cod_struttura_competente_fi,
             desc_struttura_competente_fi,
             cod_processo,
             cod_stato,
             cod_stato_precedente,
             id_utente,
             stato_proposto,
             dta_decorrenza_stato,
             dta_scadenza_stato,
             dta_servizio,
             dta_apertura_delibera,
             dta_utente_assegnato,
             scsb_acc_tot_cf,
             scsb_acc_tot_d,
             scsb_uti_tot_cf,
             scsb_uti_tot_d,
             val_rdv_tot,
             ultima_tipologia_conf,
             desc_ultima_tipologia_conf,
             cod_macrotipologia_delib,
             cod_comparto,
             id_referente,
             cod_fase_delibera,
             dta_scadenza_perm_servizio,
             COD_LIVELLO,
             COD_STRUTTURA_COMPETENTE_DV,
             DESC_STRUTTURA_COMPETENTE_DV,
             DTA_UPD
              )
            (SELECT f.cod_sndg,
                    f.desc_nome_controparte,
                    f.cod_ndg,
                    f.cod_abi_istituto,
                    f.desc_istituto,
                    f.cod_abi_cartolarizzato,
                    f.cod_gruppo_economico,
                    f.desc_gruppo_economico AS desc_gruppo_economico,
                    nor.cod_struttura_competente_dc,
                    nor.desc_struttura_competente_dc,
                    nor.cod_struttura_competente_rg,
                    nor.desc_struttura_competente_rg,
                    nor.cod_struttura_competente_ar,
                    nor.desc_struttura_competente_ar,
                    nor.cod_struttura_competente_fi,
                    nor.desc_struttura_competente_fi,
                    f.cod_processo,
                    nullif(f.cod_stato, '-1') AS cod_stato,
                    nullif(f.cod_stato_precedente, '-1') AS cod_stato_precedente,
                    nullif(f.id_utente, -1) AS id_utente,
                    decode(de.cod_microtipologia_delib,
                           'CI',
                           'IN',
                           'CS',
                           'SO',
                           'CZ',
                           'SO') AS stato_proposto,
                    f.dta_decorrenza_stato,
                    f.dta_scadenza_stato,
                    f.dta_servizio,
                    de.dta_delibera AS dta_apertura_delibera,
                    f.dta_utente_assegnato,
                    f.scsb_acc_tot AS scsb_acc_tot_cf,
                    --ACC CASSA+FIRMA
                    f.scsb_acc_sostituzioni AS scsb_acc_tot_d,
                    --ACC DERIVATI
                    f.scsb_uti_tot AS scsb_uti_tot_cf,
                    --ACC CASSA+FIRMA
                    f.scsb_uti_sostituzioni AS scsb_uti_tot_d,
                    --ACC DERIVATI
                    de.val_rdv_qc_progressiva AS val_rdv_tot,
                    de.cod_microtipologia_delib AS ultima_tipologia_conf,
                    t.desc_microtipologia AS desc_ultima_tipologia_conf,
                    de.cod_macrotipologia_delib,
                    nvl(f.cod_comparto_assegnato,
                        nullif(f.cod_comparto_calcolato, '#')) AS cod_comparto,
                    u.id_referente,
                    cod_fase_delibera,
                    DECODE (pro.dta_esito,NULL, f.dta_servizio + c.val_gg_prima_proroga,pro.dta_esito + c.val_gg_seconda_proroga
                 ) AS dta_scadenza_perm_servizio,
                 C.COD_LIVELLO,
                 NOR.COD_STRUTTURA_COMPETENTE_DV,
                 NOR.DESC_STRUTTURA_COMPETENTE_DV,
                 SYSDATE
               FROM t_mcrei_app_delibere    de,
                    t_mcre0_app_all_data    f,
                    mv_mcre0_denorm_str_org nor,
                    t_mcrei_cl_tipologie    t,
                    t_mcre0_app_utenti      u,
                    t_mcre0_app_rio_proroghe pro,
                    T_MCRE0_APP_COMPARTI C
              WHERE de.cod_abi = f.cod_abi_cartolarizzato
                AND de.cod_ndg = f.cod_ndg
                AND de.flg_attiva = '1'
                AND de.cod_abi = p_abi
                AND de.cod_ndg = p_ndg
                AND de.cod_protocollo_delibera = p_prot_delib
                AND f.today_flg = '1'
                AND de.cod_microtipologia_delib = t.cod_microtipologia
                AND t.flg_attivo = 1
                AND f.cod_abi_cartolarizzato = nor.cod_abi_istituto_fi
                AND f.cod_filiale = nor.cod_struttura_competente_fi
                AND f.id_utente = u.id_utente
                AND f.cod_abi_cartolarizzato = pro.cod_abi_cartolarizzato(+)
                AND f.cod_ndg = pro.cod_ndg(+)
                AND pro.flg_storico(+) = 0
                AND pro.flg_esito(+) = 1
                AND NVL (f.cod_comparto_assegnato, cod_comparto_calcolato) = c.cod_comparto(+));

           pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_debug,SQLCODE,SQLERRM, p_note,NULL);
        END IF;
      ELSE

        p_note := 'FLG_CONFERMA != ''Y'', UPDATE T_MCREI_APP_DELIBERE ' ||
                  p_prot_delib || ' ' || p_new_fase || ' ' ||
                  p_microtipologia;
        --p_note := 'MICROTIPOLOGIA NOT IN ''CI'',''CS'',''CZ''';

        UPDATE t_mcrei_app_delibere de
           SET de.dta_last_upd_delibera = SYSDATE,
               de.cod_fase_delibera     = p_new_fase,
               de.dta_scadenza = --decode(cod_microtipologia_delib,'PR', DE.dta_scadenza,v_scadenza_stato),
               --MM131211 - aggiunta CI alle tipol che non cambiano scadenza
                        case when cod_microtipologia_delib in ('PS','PU','PR','CI') then DE.dta_scadenza else v_scadenza_stato end ,--('PT','PD','PR')
               de.dta_upd_fase_delibera = SYSDATE ,
               de.cod_Stato_posiz = v_stato_posiz, --28 gen
               de.dta_dec_stato_posiz = v_dta_dec_stato_posiz
         WHERE de.cod_abi = p_abi
           AND de.cod_ndg = p_ndg
           AND de.cod_protocollo_delibera = p_prot_delib;

      pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                SQLERRM,
                                p_note,
                                NULL);
        /* aggiungo controllo sullo stato AD (adempiuto): l'avanzamento a questa fase
        implica l'adeguamento di alcuni campi della delibera di riferimento     */

        -- Se si sta mettendo in NA la delibera, occorre decurtare la rinuncia totale di pacchetto
        -- dell'ammontare pari alla rinuncia capitale + mora digitata nella delibera che non sara' adempiuta
        IF p_new_fase = 'NA'
        THEN
          --recupero il protocollo_pacchetto cui appartiene la delibera corrente
          SELECT de.cod_protocollo_pacchetto,
                 val_rinuncia_proposta
            INTO v_protoc,
                 v_rin_proposta
            FROM t_mcrei_app_delibere de
           WHERE de.cod_abi = p_abi
             AND de.cod_ndg = p_ndg
             AND de.cod_protocollo_delibera = p_prot_delib
             AND de.flg_attiva = '1' --28 maggio
             AND rownum = 1;

          --aggiorno valore della rinuncia totale sul pacchetto
          UPDATE t_mcrei_app_delibere de
             SET de.val_rinuncia_totale = nvl(de.val_rinuncia_totale, 0) -
                                          nvl(v_rin_proposta, 0),
                 de.val_imp_perdita     = nvl(de.val_rinuncia_totale, 0) -
                                          nvl(v_rin_proposta, 0)
           WHERE de.cod_abi = p_abi
             AND de.cod_ndg = p_ndg
                --AND de.cod_protocollo_delibera = p_prot_delib
             AND de.cod_protocollo_pacchetto = v_protoc;
        P_NOTE := 'AGGIORNATE RINUNCIA E PERDITA PER PROTOCOLLO_PACCHETTO: '||v_protoc;

         pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                SQLERRM,
                                p_note,
                                NULL);
        END IF;


        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                SQLERRM,
                                p_note,
                                NULL);
    END CASE;

    ---SE STO PONENDO LA NUOVA FASE IN CA E SONO UNA CI ALLORA AGGIORNO SCADENZA_INCAGLIO
    --ad 9 GENNAIO 2013
    ---> sel sto passando la CI in fase CA, vuol dire che la sto comunicando ad HOST, quindi salvo sulla delibera CI la dta_scadenza_incaglio
    IF  (p_microtipologia IN ('CI','CS')  and p_new_fase = 'CA' )
    THEN
    p_note := 'popola la scadenza incaglio per la CI con protocollo_delib: '||P_PROT_dELIB;
      IF p_microtipologia = 'CI' THEN
        BEGIN
        SELECT   DISTINCT SCADENZA_INCAGLIO
          INTO   V_SCADENZA_INCAGLIO
          FROM   V_MCREI_APP_dATI_CONTABILI V
         WHERE   COD_ABI_Cartolarizzato = P_ABI
                 AND COD_NDG = P_NDG
                 AND COD_PROTOCOLLO_DELIBERA = P_PROT_dELIB;
        EXCEPTION WHEN OTHERS THEN
            V_SCADENZA_INCAGLIO:=NULL;
        END;
    END IF;

    BEGIN
    p_note := 'POPOLA STATO DELLA  POSIZIONE AL MOMENTO DELL''INOLTRO AD HOST DELLA DELIB: '||P_PROT_dELIB;

    BEGIN --v7.0
    SELECT   DISTINCT nullif(cod_Stato,'-1') cod_Stato,
             dta_decorrenza_stato
      INTO   v_stato_posiz,
             v_dta_dec_stato_posiz
      FROM   t_mcre0_App_all_Data dd
     WHERE   dd.cod_abi_Cartolarizzato = P_ABI
             AND dd.cod_ndg = P_ndg
             AND flg_active = '1';
    EXCEPTION WHEN OTHERS THEN
             v_stato_posiz := null;
             v_dta_dec_stato_posiz := null;
    END;


    EXCEPTION WHEN OTHERS THEN
    v_stato_posiz:=NULL;
    v_dta_dec_stato_posiz:=NULL;
    END;


    UPDATE t_mcrei_app_delibere de
           SET de.dta_last_upd_delibera = SYSDATE,
               de.cod_fase_delibera     = p_new_fase,
               de.dta_scadenza_INCAGLIO = DECODE (p_microtipologia,'CI',v_scadenza_incaglio,NULL),---POPOLA SCADENZA INCAGLIO SOLO PER LE CI
               de.cod_stato_posiz       = v_stato_posiz, ----28 gen
               de.dta_dec_stato_posiz = v_dta_dec_stato_posiz
         WHERE de.cod_abi = p_abi
           AND de.cod_ndg = p_ndg
           AND de.cod_protocollo_delibera = p_prot_delib;

         pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                SQLERRM,
                                p_note,
                                NULL);
    end if;

    BEGIN
        -- BLOCCO CAMPI AGGIUNTIVI DELIBERE
        UPDATE T_MCREI_APP_DELIBERE DE
          SET (                DESC_MICROTIPOLOGIA2,
                DESC_MACROTIPOLOGIA2,
                COD_TIPO_GESTIONE2,
                DESC_STRUTTURA_COMPETENTE_DV2,
                DESC_ISTITUTO2,
                COD_STRUTTURA_COMPETENTE_DC2,
                COD_STRUTTURA_COMPETENTE_FI2,
                COD_STRUTTURA_COMPETENTE_AR2,
                COD_PROCESSO2,
                COD_STRUTTURA_COMPETENTE_RG2,
                DESC_STRUTTURA_COMPETENTE_AR2,
                DESC_GRUPPO_ECONOMICO2,
                COD_COMPARTO2,
                COD_STRUTTURA_COMPETENTE_DV2,
                NOME2,
                COD_STRUTTURA_COMPETENTE2,
                DESC_STRUTTURA_COMPETENTE_RG2,
                COD_GRUPPO_ECONOMICO2,
                COD_FILIALE2,
                DESC_NOME_CONTROPARTE2,
                DESC_STRUTTURA_COMPETENTE_DC2,
                COD_STATO2,
                COGNOME2,
                COD_MATRICOLA2,
                DESC_COMPARTO2,
                DESC_STRUTTURA_COMPETENTE_FI2)
            = (
            SELECT TIP.DESC_MICROTIPOLOGIA,
                TIP.DESC_MACROTIPOLOGIA,
                P.COD_TIPO_GESTIONE,
                G.DESC_STRUTTURA_COMPETENTE_DV,
                G.DESC_ISTITUTO,
                G.COD_STRUTTURA_COMPETENTE_DC,
                G.COD_STRUTTURA_COMPETENTE_FI,
                G.COD_STRUTTURA_COMPETENTE_AR,
                G.COD_PROCESSO,
                G.COD_STRUTTURA_COMPETENTE_RG,
                G.DESC_STRUTTURA_COMPETENTE_AR,
                G.DESC_GRUPPO_ECONOMICO,
                G.COD_COMPARTO,
                G.COD_STRUTTURA_COMPETENTE_DV,
                G.NOME,
                G.COD_STRUTTURA_COMPETENTE,
                G.DESC_STRUTTURA_COMPETENTE_RG,
                G.COD_GRUPPO_ECONOMICO,
                G.COD_FILIALE,
                G.DESC_NOME_CONTROPARTE,
                G.DESC_STRUTTURA_COMPETENTE_DC,
                G.COD_STATO,
                G.COGNOME,
                G.COD_MATRICOLA,
                G.DESC_COMPARTO,
                G.DESC_STRUTTURA_COMPETENTE_FI
             FROM t_mcrei_App_delibere d,
             V_MCRE0_APP_UPD_FIELDS_ALL g,
             T_MCREI_APP_PRATICHE P,
             t_mcrei_cl_tipologie tip
            WHERE D.COD_ABI = P_ABI
              AND D.COD_NDG = P_NDG
              AND D.COD_PROTOCOLLO_DELIBERA = P_PROT_DELIB
              AND D.COD_ABI = P.COD_ABI(+)
              AND D.COD_NDG = P.COD_NDG(+)
              AND D.COD_PRATICA = P.COD_PRATICA(+)
              AND D.VAL_ANNO_PRATICA = P.VAL_ANNO_PRATICA(+)
              AND D.COD_ABI = G.COD_ABI_CARTOLARIZZATO
              AND D.COD_NDG = G.COD_NDG
              AND TIP.COD_MICROTIPOLOGIA = P_MICROTIPOLOGIA
              AND ROWNUM = 1
            )
           WHERE DE.COD_ABI = P_ABI
             AND DE.COD_NDG = P_NDG
             AND DE.COD_PROTOCOLLO_DELIBERA = P_PROT_DELIB;

    EXCEPTION WHEN OTHERS THEN
          pkg_mcrei_audit.log_app(c_nome,pkg_mcrei_audit.c_error,SQLCODE,SQLERRM,p_note,NULL);

    END;
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END cambia_fase_delibera;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE FA AVANZARE LA FASE DELLA DELIBERA (STATO DELIBERA)
  -- %D  LA FUNZIONE, PER LA DELIBERA IN INPUT, AGGIORNA LA FASE (OVVERO LO STATO)
  -- %CD 25 NOV 2011
  -- %PARAM P_PROT_PACCHETTO
  -- %PARAM P_NEW_FASE
  -- %PARAM P_FLG_CONFERMA: Y --> LA DELIBERA E' STATA CONFERMATA, QUINDI P_NEW_FASE = 'CO'
  FUNCTION cambia_fase_pacchetto(p_prot_pacchetto IN VARCHAR2,
                                 p_new_fase       IN VARCHAR2,
                                 p_flg_conferma   IN VARCHAR2 DEFAULT 'N')
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.CAMBIA_FASE_PACCHETTO';
    p_note         t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_flg_conferma VARCHAR2(1);
    esito number := const_esito_ok;
  BEGIN
    p_note := 'Cambia fase pacchetto';

    IF p_prot_pacchetto IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    ---> TRASFORMARE IN: IF P_FLG_CONFERMA= 'Y'
    IF p_new_fase = 'CNF' ---
    THEN
      v_flg_conferma := 'Y';
    END IF;

    CASE
      WHEN v_flg_conferma = 'Y' THEN
        p_note := 'cambia fase pacchetto FLG_CONFERMA = ''Y'', ' ||
                  p_prot_pacchetto || ' ->' || p_new_fase;

        UPDATE t_mcrei_app_delibere de
           SET de.dta_conferma_pacchetto = SYSDATE,
               de.cod_fase_pacchetto     = p_new_fase,
               de.dta_upd_fase_pacchetto = SYSDATE
         WHERE de.cod_protocollo_pacchetto = p_prot_pacchetto
           AND de.cod_fase_pacchetto NOT IN ('ANM', 'ANA');

        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                SQLERRM,
                                p_note,
                                NULL);
      ELSE
        p_note := 'cambia fase pacchetto FLG_CONFERMA <> ''Y'', ' ||
                  p_prot_pacchetto || ' ->' || p_new_fase;

        UPDATE t_mcrei_app_delibere de
           SET de.cod_fase_pacchetto     = p_new_fase,
               de.dta_upd_fase_pacchetto = SYSDATE
         WHERE de.cod_protocollo_pacchetto = p_prot_pacchetto;

        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                SQLERRM,
                                p_note,
                                NULL);
    END CASE;

    IF p_new_fase = 'CMP' THEN
    --ho congelato tutte le microtipologie, salvo i rapporti
        esito := pkg_mcrei_web_util_delib.POPOLA_RAPPORTI_IN_ESSERE(p_prot_pacchetto);
    END IF;

    RETURN esito;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END cambia_fase_pacchetto;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE RETROCEDE IL WF DEL PACCHETTO (E FASE DELIBERA/MICROTIP.)
  -- %CD 13 FEB 2012
  -- %PARAM P_PROT_PACCHETTO
  -- %PARAM P_UTENTE
  FUNCTION retrocedi_wf(p_prot_pacchetto IN VARCHAR2, p_utente IN VARCHAR2)
    RETURN NUMBER AS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.RETROCEDI_WF';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Retrocede fase pacchetto, delibere, microtipologie ' ||
              p_prot_pacchetto;

    IF p_prot_pacchetto IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    UPDATE t_mcrei_app_delibere de
       SET de.dta_upd_fase_pacchetto      = SYSDATE,
           de.cod_fase_pacchetto          = 'INS',
           de.dta_upd_fase_delibera       = SYSDATE,
           de.cod_fase_delibera           = 'IN',
           de.dta_upd_fase_microtipologia = SYSDATE,
           de.cod_fase_microtipologia     = 'INS',
           de.cod_doc_delibera_banca      = NULL,
           de.cod_doc_parere_conformita   = NULL,
           de.cod_doc_appendice_parere    = NULL,
           de.cod_doc_delibera_capogruppo = NULL,
           de.cod_doc_classificazione     = NULL,
           de.cod_organo_calcolato        = NULL,
           de.cod_organo_pacchetto_calc   = NULL,
           de.cod_organo_deliberante      = NULL,
           de.cod_organo_pacchetto        = NULL,
           de.dta_delibera                = NULL
     WHERE de.cod_protocollo_pacchetto = p_prot_pacchetto;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            p_utente);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_utente);
      RETURN const_esito_ko;
  END retrocedi_wf;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE RETROCEDE IL WF DEL PACCHETTO (E FASE DELIBERA/MICROTIP.)
  -- %CD 13 FEB 2012
  -- %PARAM P_PROT_PACCHETTO
  -- %PARAM P_UTENTE
  FUNCTION retrocedi_wf_microtipologia(p_prot_pacchetto IN VARCHAR2,
                                       p_cod_microtipol IN VARCHAR2,
                                       p_utente         IN VARCHAR2)
    RETURN NUMBER AS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.RETROCEDI_WF_MICROTIPOL';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Retrocede fase pacchetto, delibere, microtipologie ' ||
              p_prot_pacchetto || ' ' || p_cod_microtipol;

    IF p_prot_pacchetto IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    UPDATE t_mcrei_app_delibere de
       SET de.dta_upd_fase_delibera       = SYSDATE,
           de.cod_fase_delibera           = 'IN',
           de.dta_upd_fase_microtipologia = SYSDATE,
           de.cod_fase_microtipologia     = 'INS',
           de.cod_doc_delibera_banca      = NULL,
           de.cod_doc_parere_conformita   = NULL,
           de.cod_doc_appendice_parere    = NULL,
           de.cod_doc_delibera_capogruppo = NULL,
           de.cod_doc_classificazione     = NULL,
           de.cod_organo_calcolato        = NULL,
           de.cod_organo_pacchetto_calc   = NULL,
           de.cod_organo_deliberante      = NULL,
           de.cod_organo_pacchetto        = NULL,
           de.dta_delibera                = NULL
     WHERE de.cod_protocollo_pacchetto = p_prot_pacchetto
       AND de.cod_microtipologia_delib = p_cod_microtipol;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            p_utente);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_utente);
      RETURN const_esito_ko;
  END retrocedi_wf_microtipologia;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE RETROCEDE IL WF DEL PACCHETTO (E FASE DELIBERA/MICROTIP.)
  -- %CD 13 FEB 2012
  -- %PARAM P_PROT_PACCHETTO
  -- %PARAM P_UTENTE
  -- %PARAM P_PACC_CH_RISTR : Y SE ESISTE NEL PACCHETTO UNA DELIBERA B8, ALTRIMENTI N
  FUNCTION retrocedi_wf_pacchetto(p_prot_pacchetto IN VARCHAR2,
                                  p_cod_microtipol IN VARCHAR2,
                                  p_utente         IN VARCHAR2 /*,
                                                                                                                                                                                                                                                                          p_flg_ch_ristr   IN VARCHAR2 DEFAULT 'N'*/)
    RETURN NUMBER AS

    c_nome CONSTANT VARCHAR2(100) := c_package || '.RETROCEDI_WF_PACCHETTO';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_ret  NUMBER;
    --Variabile per reperire lo stato del pacchetto da regredire
    v_fase_pacchetto t_mcrei_app_delibere.cod_fase_pacchetto%TYPE;
    v_flg_ch_ristr   VARCHAR2(1) := NULL;

  BEGIN
    p_note := 'Retrocede fase pacchetto, delibere, microtipologie ' ||
              p_prot_pacchetto || ' ' || p_cod_microtipol;

    IF p_prot_pacchetto IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    --Calcola il flg indicatore della presenza di una B8 nel pacchetto
    SELECT CASE
             WHEN EXISTS (SELECT 1
                     FROM t_mcrei_app_delibere
                    WHERE cod_microtipologia_delib = 'B8'
                      AND cod_protocollo_pacchetto = p_prot_pacchetto
                      AND flg_attiva = '1'
                      AND cod_fase_delibera != 'AN') THEN
              'Y'
             ELSE
              'N'
           END CASE
      INTO v_flg_ch_ristr
      FROM dual;

    --Recupero lo stato del pacchetto da regredire
    SELECT MAX(d.cod_fase_pacchetto)
      INTO v_fase_pacchetto
      FROM t_mcrei_app_delibere d
     WHERE d.cod_protocollo_pacchetto = p_prot_pacchetto
      AND COD_FASE_PACCHETTO NOT IN ('ANA','ANM');

    --Se la fase attuale del pacchetto da regredire e' gia' INS (inserito)
    IF v_fase_pacchetto = 'INS'
    THEN
      --Retrocedo solamente lo stato della microtipologia in lavorazione e di tutte le sue delibere
      UPDATE t_mcrei_app_delibere de
         SET de.dta_upd_fase_delibera       = SYSDATE,
             de.cod_fase_delibera           = 'IN',
             de.dta_upd_fase_microtipologia = SYSDATE,
             de.cod_fase_microtipologia     = 'INS',
             de.cod_doc_delibera_banca      = NULL,
             de.cod_doc_parere_conformita   = NULL,
             de.cod_doc_appendice_parere    = NULL,
             de.cod_doc_delibera_capogruppo = NULL,
             de.cod_doc_classificazione     = NULL,
             de.cod_organo_calcolato        = NULL,
             de.cod_organo_pacchetto_calc   = NULL,
             de.cod_organo_deliberante      = NULL,
             de.cod_organo_pacchetto        = NULL,
             de.dta_delibera                = NULL,
             de.dta_delibera_rete           = NULL --06.28
       WHERE de.cod_protocollo_pacchetto = p_prot_pacchetto
         AND de.cod_microtipologia_delib = p_cod_microtipol
         AND de.cod_fase_delibera != 'AN'
         AND de.cod_fase_microtipologia NOT IN ('ANA', 'ANM');
    ELSE

      IF v_flg_ch_ristr = 'Y'
      THEN
        --  Se il pacchetto contiene una chiusura di ristrutt (B8), allora:

        --      1) retrocedo lo stato della singola microtipologia e di tutte le sue delibere
        UPDATE t_mcrei_app_delibere de
           SET de.dta_upd_fase_delibera       = SYSDATE,
               de.cod_fase_delibera           = 'IN',
               de.dta_upd_fase_microtipologia = SYSDATE,
               de.cod_fase_microtipologia     = 'INS'
         WHERE de.cod_protocollo_pacchetto = p_prot_pacchetto
           AND de.cod_microtipologia_delib = p_cod_microtipol
           AND de.cod_fase_delibera NOT IN ('AN')
           AND de.cod_fase_microtipologia NOT IN ('ANM', 'ANA');

        --      2) retrocedo lo stato del pacchetto
        UPDATE t_mcrei_app_delibere de
           SET de.dta_upd_fase_pacchetto      = SYSDATE,
               de.cod_fase_pacchetto          = 'INS',
               de.cod_doc_delibera_banca      = NULL,
               de.cod_doc_parere_conformita   = NULL,
               de.cod_doc_appendice_parere    = NULL,
               de.cod_doc_delibera_capogruppo = NULL,
               de.cod_doc_classificazione     = NULL,
               de.cod_organo_calcolato        = NULL,
               de.cod_organo_pacchetto_calc   = NULL,
               de.cod_organo_deliberante      = NULL,
               de.cod_organo_pacchetto        = NULL,
               de.dta_delibera                = NULL,
               de.dta_delibera_rete           = NULL --06.28
         WHERE de.cod_protocollo_pacchetto = p_prot_pacchetto
           AND de.cod_fase_pacchetto NOT IN ('ANM', 'ANA');

      ELSE
        --Retrocedo lo stato del pacchetto, di tutte le sue microtipologie e di tutte le sue delibere

        UPDATE t_mcrei_app_delibere de
           SET de.dta_upd_fase_pacchetto      = SYSDATE,
               de.cod_fase_pacchetto          = 'INS',
               de.dta_upd_fase_delibera       = SYSDATE,
               de.cod_fase_delibera           = 'IN',
               de.dta_upd_fase_microtipologia = SYSDATE,
               de.cod_fase_microtipologia     = 'INS',
               de.cod_doc_delibera_banca      = NULL,
               de.cod_doc_parere_conformita   = NULL,
               de.cod_doc_appendice_parere    = NULL,
               de.cod_doc_delibera_capogruppo = NULL,
               de.cod_doc_classificazione     = NULL,
               de.cod_organo_calcolato        = NULL,
               de.cod_organo_pacchetto_calc   = NULL,
               de.cod_organo_deliberante      = NULL,
               de.cod_organo_pacchetto        = NULL,
               de.dta_delibera                = NULL,
               de.dta_delibera_rete           = NULL --06.28
         WHERE de.cod_protocollo_pacchetto = p_prot_pacchetto
           AND de.cod_fase_delibera != 'AN'
           AND de.cod_fase_microtipologia NOT IN ('ANA', 'ANM')
           AND de.cod_fase_pacchetto NOT IN ('ANM', 'ANA');

      END IF;
    END IF;

    p_note := 'Cancellazione OD calcolati';
    v_ret  := pulisci_dati_out_od(p_prot_pacchetto);

    p_note := 'Eliminazione delibere automatiche legate alla tipologia B8';
    /* Se si sta retrocedendo un pacchetto contenente la delibera di
    CHIUSURA RISTRUTTURAZIONE (B8)
    vengono ANNULLATE AUTOMATICAMENTE tutte le eventuali delibere di tipo
    A0 (rettifica di valore), CZ (classificazione a sofferenza tecnica) e
    CX (chiusura incaglio tecnica) presenti nello stesso pacchetto
    (queste delibere sono quelle inserite in automatico in accordo con i
    dati di dettaglio di ciascuna delibera di chiusura ristrutturazione)*/
    IF p_cod_microtipol = 'B8'
    THEN
      UPDATE t_mcrei_app_delibere
         SET cod_fase_microtipologia = 'ANM',
             cod_fase_delibera       = 'AN'
       WHERE cod_protocollo_pacchetto = p_prot_pacchetto
         AND cod_microtipologia_delib IN ('A0', 'CZ', 'CX');

      IF v_flg_ch_ristr = 'Y'
      THEN
        UPDATE t_mcrei_app_delibere
           SET cod_fase_pacchetto = 'INS'
         WHERE cod_protocollo_pacchetto = p_prot_pacchetto
           AND cod_microtipologia_delib IN ('A0', 'CZ', 'CX');
      ELSE
        UPDATE t_mcrei_app_delibere
           SET cod_fase_pacchetto = 'ANM'
         WHERE cod_protocollo_pacchetto = p_prot_pacchetto
           AND cod_microtipologia_delib IN ('A0', 'CZ', 'CX');
      END IF;

    END IF;
    p_note := 'Retrocede fase pacchetto, delibere, microtipologie ' ||
              p_prot_pacchetto || ' ' || p_cod_microtipol;
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            p_utente);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_utente);
      RETURN const_esito_ko;
  END retrocedi_wf_pacchetto;

  -- ======================== GESTIONE OD =============================
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
                      p_proto_pacchetto IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE,
                      p_od_calc_abi     IN VARCHAR2,
                      --  p_od_calc_pacch      IN VARCHAR2
                      p_abi_rif          IN t_mcrei_app_delibere.cod_abi%TYPE
                      ) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.CONFERMA_OD';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri, P_ABI = ' || p_abi || ' PROTO_PACC = ' ||
              p_proto_pacchetto || ' P_ABI_RIF= ' || p_abi_rif;

    IF p_abi IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_abi_rif IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'UPDATE T_MCREI_APP_DELIBERE salvataggio organi calcolati
   a livello pacchetto,  P_ABI = ' || p_abi || 'PROTO_PACC = ' ||
              p_proto_pacchetto || ' P_ABI_RIF= ' || p_abi_rif;

    IF p_abi = p_abi_rif--'01025'
    THEN
      UPDATE t_mcrei_app_delibere de
         SET de.cod_organo_pacchetto_calc = p_od_calc_abi,
             -- de.cod_organo_calcolato = p_od_calc_abi,
             de.dta_last_upd_delibera = SYSDATE
       WHERE de.cod_protocollo_pacchetto = p_proto_pacchetto;
    END IF;

    UPDATE t_mcrei_app_delibere de
       SET de.cod_organo_calcolato  = p_od_calc_abi,
           de.dta_last_upd_delibera = SYSDATE
     WHERE de.cod_protocollo_pacchetto = p_proto_pacchetto
       AND de.cod_abi = p_abi;

    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END calcola_od;

  -- %author reply
  -- %version 0.1
  -- %usage  funzione che salva l'od calcolato oppure conferma l'od deliberato
  -- %d se p_proto_delib non e' null l'aggiornamento avviene a livello di
  -- %d delibera, altrimenti a livello di pacchetto
  -- se p_flg_tipo_dato = 'D' allora viene aggiornato l'od deliberante,
  -- se p_flg_tipo_dato = 'C', viene aggiornato l'od calcolato.
  -- %cd 12 mar 2012
  -- %param p_abi non null
  -- %param p_ndg null oppure ndg
  -- %param p_proto_pacch protocollo pacchetto, non nullo
  -- %param p_flg_tipo_dato 'c' oppure 'd'
  FUNCTION conferma_od(p_abi                IN t_mcrei_app_delibere.cod_abi% TYPE,
                       p_ndg                IN t_mcrei_app_delibere.cod_ndg% TYPE,
                       p_proto_delib        IN t_mcrei_app_delibere. cod_protocollo_delibera%TYPE,
                       p_proto_pacch        IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE,
                       p_cod_microtipologia IN t_mcrei_app_delibere. cod_microtipologia_delib%TYPE,
                       p_od                 IN VARCHAR2,
                       p_flg_tipo_dato      IN VARCHAR2) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.CONFERMA_OD';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri, P_ABI = ' || p_abi || ', NDG = ' ||
              p_ndg || ', P_PROTO_DELIB = ' || p_proto_delib ||
              'PROTO_PACC = ' || p_proto_pacch ||
              ', COD_MICROTIPOLOGIA_DELIB = ' || p_cod_microtipologia ||
              ' FLG_TIPO_DATO, ' || p_flg_tipo_dato;

    IF p_abi IS NULL OR
       p_ndg IS NULL OR
       p_proto_pacch IS NULL OR
       p_flg_tipo_dato IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'UPDATE T_MCREI_APP_DELIBERE salvataggio organi calcolati
   a livello pacchetto,  P_ABI = ' || p_abi || ', NDG = ' ||
              p_ndg || ', P_PROTO_DELIB = ' || p_proto_delib ||
              'PROTO_PACC = ' || p_proto_pacch ||
              ', COD_MICROTIPOLOGIA_DELIB = ' || p_cod_microtipologia ||
              ' FLG_TIPO_DATO, ' || p_flg_tipo_dato;

    CASE
      WHEN p_proto_delib IS NULL AND
           upper(p_flg_tipo_dato) = 'D' THEN
        UPDATE t_mcrei_app_delibere de
           SET de.cod_organo_pacchetto  = p_od,
               de.dta_last_upd_delibera = SYSDATE
         WHERE de.cod_abi = p_abi
           AND de.cod_ndg = p_ndg
           AND de.cod_protocollo_delibera = p_proto_delib
           AND de.cod_protocollo_pacchetto = p_proto_pacch
           AND de.cod_microtipologia_delib = p_cod_microtipologia;
      WHEN p_proto_delib IS NULL AND
           upper(p_flg_tipo_dato) = 'C' THEN
        UPDATE t_mcrei_app_delibere de
           SET de.cod_organo_pacchetto_calc = p_od,
               de.dta_last_upd_delibera     = SYSDATE
         WHERE de.cod_abi = p_abi
           AND de.cod_ndg = p_ndg
           AND de.cod_protocollo_delibera = p_proto_delib
           AND de.cod_protocollo_pacchetto = p_proto_pacch
           AND de.cod_microtipologia_delib = p_cod_microtipologia;
      WHEN p_proto_delib IS NOT NULL AND
           upper(p_flg_tipo_dato) = 'D' THEN
        UPDATE t_mcrei_app_delibere de
           SET de.cod_organo_deliberante = p_od,
               de.dta_last_upd_delibera  = SYSDATE
         WHERE de.cod_abi = p_abi
           AND de.cod_ndg = p_ndg
           AND de.cod_protocollo_pacchetto = p_proto_pacch
           AND de.cod_microtipologia_delib = p_cod_microtipologia;
      WHEN p_proto_delib IS NOT NULL AND
           upper(p_flg_tipo_dato) = 'C' THEN
        UPDATE t_mcrei_app_delibere de
           SET de.cod_organo_calcolato  = p_od,
               de.dta_last_upd_delibera = SYSDATE
         WHERE de.cod_abi = p_abi
           AND de.cod_ndg = p_ndg
           AND de.cod_protocollo_pacchetto = p_proto_pacch
           AND de.cod_microtipologia_delib = p_cod_microtipologia;
      ELSE
        raise_application_error(-20666, 'FLG_TIPO_DATO NON ATTESO');
    END CASE;

    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END conferma_od;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE CONFERMA L'ORGANO DELIBERANTE A LIVELLO GESTORE DELLE DELIBERE
  -- %D  SE P_ABI E P_NDG SONO NULL, LA FUNZIONE AGGIORNA L'ORGANO DI PACCHETTO
  -- %D DI TUTTE LE DELIBERE DI QUEL PACCHETTO E L'ORGANO DELIBERANTE SOLAMENTE
  -- %D PER L'ABI 01025 DI QUEL PACCHETTO.
  -- %D ALTRIMENTI, SE P_ABI E P_NDG NON SONO NULL, VIENE AGGIORNATO L'ORGANO DELIBERANTE
  -- %D DI TUTTE LE DELIBERE CHE RIGUARDANO QUELL'ABI E QUEL NDG.
  -- %CD 12 GEN 2011
  -- %PARAM P_ABI NULL OPPURE ABI
  -- %PARAM P_NDG NULL OPPURE NDG
  -- %PARAM P_PROTO_PACCH PROTOCOLLO PACCHETTO, NON NULLO
  -- %PARAM P_OD CODICE ORGANO DELIBERANTE
  FUNCTION conferma_od(p_abi         IN t_mcrei_app_delibere.cod_abi%TYPE,
                       p_ndg         IN t_mcrei_app_delibere.cod_ndg%TYPE,
                       p_proto_pacch IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE,
                       p_od          IN VARCHAR2,
                       p_abi_riferimento IN t_mcrei_app_delibere.cod_abi%TYPE default null) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.CONFERMA_OD_GESTORE';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri, P_ABI = ' || p_abi || ', P_NDG = ' ||
              p_ndg || ', P_PROTO_PACCH = ' || p_proto_pacch||', P_ABI_RIFERIMENTO= '||p_abi_riferimento;

    IF p_proto_pacch IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'UPDATE T_MCREI_APP_DELIBERE conferma OD gestore, P_ABI = ' ||
              p_abi || ', P_NDG = ' || p_ndg || ', P_PROTO_PACCH = ' ||
              p_proto_pacch;

    IF p_abi IS NOT NULL AND
       p_ndg IS NOT NULL
    THEN
      UPDATE t_mcrei_app_delibere de
         SET de.cod_organo_deliberante = p_od,
             de.dta_upd                = SYSDATE
       WHERE de.cod_abi = p_abi
         AND de.cod_ndg = p_ndg
         AND de.cod_protocollo_pacchetto = p_proto_pacch;
    ELSE
      UPDATE t_mcrei_app_delibere de
         SET de.cod_organo_pacchetto   = p_od,
             de.cod_organo_deliberante = decode(de.cod_abi,
                                                p_abi_riferimento,
                                                p_od,
                                                de.cod_organo_deliberante),
             de.dta_upd                = SYSDATE
       WHERE de.cod_protocollo_pacchetto = p_proto_pacch;
    END IF;

    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END conferma_od;

  -- ======================== GESTIONE PARERI ==========================

  --DENTRO OGNI GESTIONE MICROTIPOLOGIA
  FUNCTION propaga_parere_sndg(p_sndg       IN VARCHAR2,
                               p_microtipol IN VARCHAR2
                               ,P_COD_GRUPPO_SUPER IN VARCHAR2 default NULL--DR
                               ) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.PROPAGA_PARERE_SNDG';
    v_proto_pacchetto t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    p_note            t_mcrei_wrk_audit_applicativo.note%TYPE;
    -- A LIVELLO DI SNDG
  BEGIN
    p_note := 'PROPAGA PARERE SNDG';

    IF p_sndg IS NULL OR
       p_microtipol IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    v_proto_pacchetto := ctrl_esist_pacc_aperto(p_sndg,P_COD_GRUPPO_SUPER);
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN const_esito_ok;
  END propaga_parere_sndg;

  --DENTRO OGNI GESTIONE MICROTIPOLOGIA
  FUNCTION associa_parere_ndg(p_ndg        IN VARCHAR2,
                              p_abi        IN VARCHAR2,
                              p_prot_delib IN VARCHAR2) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.ASSOCIA_PARERE_NDG';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'AGGIORNA PARERE';

    IF p_prot_delib IS NULL OR
       p_abi IS NULL OR
       p_ndg IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END associa_parere_ndg;

  FUNCTION ANNULLA_PACCHETTO(P_PROTO_PACCH IN T_MCREI_APP_DELIBERE. COD_PROTOCOLLO_PACCHETTO%TYPE,
                             p_flg_tipo    VARCHAR2--,
                           --  P_DTA_ANNULLO IN T_MCREI_APP_DELIBERE.DTA_ANNULLO%TYPE DEFAULT SYSDATE,
                           --  P_COD_MATRICOLA_ANNULLO IN T_MCREI_APP_DELIBERE.COD_MATRICOLA_ANNULLO%TYPE DEFAULT NULL,
                           --  P_COD_OPERA_COME_ANNULLO IN T_MCREI_APP_DELIBERE.COD_OPERA_COME_ANNULLO%TYPE DEFAULT NULL,
                           --  P_DESC_NOTE_DELIBERE_ANNULLATE IN T_MCREI_APP_DELIBERE.DESC_NOTE_DELIBERE_ANNULLATE%TYPE DEFAULT NULL
                           ) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.ANNULLA_PACCHETTO';
    p_note  t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_esito NUMBER;
  BEGIN
    p_note := 'ANNULLA PACCHETTO ' || p_proto_pacch;

    IF p_proto_pacch IS NULL OR
       p_flg_tipo IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    v_esito := cambia_fase_pacchetto(p_proto_pacch,
                                     CASE
                                       WHEN p_flg_tipo = 'A' THEN
                                        'ANA'
                                       WHEN p_flg_tipo = 'M' THEN
                                        'ANM'
                                     END);

    --V1.8 SETTO AD 'AN' LA FASE DELIBERA E ANA/M SULLA MICROTIPOLOGIA
    UPDATE t_mcrei_app_delibere d
       SET d.cod_fase_delibera           = 'AN',
           d.dta_upd_fase_delibera       = SYSDATE,
           d.cod_fase_microtipologia     = cod_fase_pacchetto,
           d.dta_upd_fase_microtipologia = SYSDATE,
           d.cod_doc_appendice_parere    = NULL,
           d.cod_doc_classificazione     = NULL,
           d.cod_doc_delibera_banca      = NULL,
           D.COD_DOC_DELIBERA_CAPOGRUPPO = NULL,
           d.cod_doc_parere_conformita   = NULL--,
           --d.COD_MATRICOLA_ANNULLO = P_COD_MATRICOLA_ANNULLO,
           --D.COD_OPERA_COME_ANNULLO = P_COD_OPERA_COME_ANNULLO,
           --D.DTA_ANNULLO = P_DTA_ANNULLO,
           --d.DESC_NOTE_DELIBERE_ANNULLATE = P_DESC_NOTE_DELIBERE_ANNULLATE
     WHERE d.cod_protocollo_pacchetto = p_proto_pacch;

    RETURN v_esito * const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END annulla_pacchetto;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI DELLE DELIBERE INSERITI MANUALMENTE A LIVELLO DI BANCA RETE
  -- %D LA FUNCTION, SALVA LE INFORMAZIONI PASSATE PER ARGOMENTO NELLA TABELLA DELIBERE,
  -- %CD 13 GEN 2012
  FUNCTION get_capogruppo(p_proto_pacch IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE)
    RETURN VARCHAR2 IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.GET_CAPOGRUPPO';
    p_note    t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_cod_abi t_mcrei_app_delibere.cod_abi%TYPE;
  BEGIN
    p_note := 'Controllo parametri in ingresso';

    IF p_proto_pacch IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'recupero abi capogruppo';

    SELECT substr(c.aa, 3, 6)
      INTO v_cod_abi
      FROM (SELECT CASE
                     WHEN cod_abi = '01025' THEN
                      flg_no_delibera || '1' || cod_abi
                     ELSE
                      flg_no_delibera || '2' || cod_abi
                   END aa
              FROM t_mcrei_app_delibere
             WHERE cod_protocollo_pacchetto = p_proto_pacch
              AND COD_FASE_PACCHETTO NOT IN ('ANA','ANM')
             ORDER BY aa) c
     WHERE rownum < 2;

    RETURN v_cod_abi;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END get_capogruppo;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  FUNCTION CHE popola i dati in fase di controproposta rv da parte di una banca rete
    -- %d   Se la banca rete non S d'accordo sui dati presenti nel parere di conformit? della capogruppo
  -- %d      contropropone un valore di rettifica alternativo (p_rdv_delib), e il flg_coerenza indica la conformit?
    -- %d   o meno al parere della capogruppo(null--> forzata da capogruppo, 0--> non conforme,1--> conforme)
  -- %CD 9 MAR 2012
    FUNCTION popola_dati_banca_rete(p_abi          IN t_mcrei_app_delibere. cod_abi%TYPE,
                                  p_ndg          IN t_mcrei_app_delibere. cod_ndg%TYPE,
                                  p_proto_delib  IN t_mcrei_app_delibere. cod_protocollo_delibera%TYPE,
                                  p_proto_pacch  IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE,
                                  p_od_calcolato IN t_mcrei_app_delibere. cod_organo_calcolato%TYPE,
                                  p_od_delib     IN t_mcrei_app_delibere. cod_organo_deliberante%TYPE,
                                  --P_DTA_DELIB     IN T_MCREI_APP_DELIBERE.DTA_DELIBERA%TYPE,
                                  p_dta_cnf_delib IN t_mcrei_app_delibere. dta_conferma_delibera%TYPE,
                                  p_flg_coerenza  IN t_mcrei_app_delibere. flg_delib_in_linea%TYPE,
                                  p_note_coerenza IN t_mcrei_app_delibere. desc_note_coerenza%TYPE,
                                  p_rdv_delib     IN t_mcrei_app_delibere. val_rdv_delib_banca_rete%TYPE,
                                  P_FLG_DELIB_FORZATA IN T_MCREI_APP_DELIBERE.FLG_DELIB_FORZATA%TYPE DEFAULT '0'
                                  -- RISPOSTA DI DELIBERA INVIATA - EVIDENZA DELL'AVVENUTA
                                  -- CONFERMA DA PARTE DELLA BANCA. L'ICONA SARo VALORIZZATA: V
                                  --                                                P_STATO_DELIB   IN T_MCREI_APP_DELIBERE.COD_FASE_DELIBERA%TYPE --
                                  ) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_DATI_BANCA_RETE';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri in ingresso';

    IF p_abi IS NULL OR
       p_ndg IS NULL OR
       p_proto_delib IS NULL OR
       p_proto_pacch IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'Salvataggio dati banca rete ' || p_abi || ' ' || p_ndg || ' ' ||
              p_proto_delib;

    UPDATE t_mcrei_app_delibere de
       SET de.cod_organo_calcolato   = p_od_calcolato,
           de.cod_organo_deliberante = p_od_delib,
           --DE.DTA_DELIBERA             = P_DTA_DELIB,
           --de.dta_conferma_delibera    = p_dta_cnf_delib,--MM24.05, non ora, verra' confermata contestualmente al BS
           DE.FLG_DELIB_IN_LINEA       = P_FLG_COERENZA,
           DE.DESC_NOTE_COERENZA       = P_NOTE_COERENZA,
           DE.VAL_RDV_DELIB_BANCA_RETE = P_RDV_DELIB,
           DE.FLG_DELIB_FORZATA = P_FLG_DELIB_FORZATA,
           DE.DTA_LAST_UPD_DELIBERA = SYSDATE       -- 14112012
     WHERE de.cod_abi = p_abi
       AND de.cod_ndg = p_ndg
       AND de.cod_protocollo_delibera = p_proto_delib
       AND de.cod_protocollo_pacchetto = p_proto_pacch;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI DEI BENI INSERITI DALL'UTENTE NELLA SEZIONE BENI
  -- %D LA FUNCTION SALVA I CAMPI INSERITI DALL'UTENTE NELLA SEZIONE BENI
  -- %CD 26 GEN 2012
  -- %PARAM P_ID_BENE ID LOGICO DEL BENE, SE NULL VERRo CREATO UN NUOVO BENE, ALTRIMENTI VERRA'
  --                  AGGIORNATO IL BENE CORRISPONDENTE A QUEL ID
  -- %PARAM P_C_ABI ABI, NOT NULL
  -- %PARAM P_C_NDG NDG, NOT NULL
  -- %PARAM P_D_INTESTATARIO DESCRIZIONE INTESTATARIO
  -- %PARAM P_C_TIPO_BENE   CODICE TIPO BENE
  -- %PARAM P_C_FOGL_MAP_SUB  CODICE FOGLIO MAPPALE SUBALTERNO
  -- %PARAM P_C_FOGL_MAP_SUB FOGLIO, MAPPALE E SUBALTERNO, NOT NULL
  -- %PARAM P_V_PROGR_BENE_CESP PROGRESSIVO BENE CESPITE, NOT NULL
  FUNCTION popola_beni_man(p_id_bene t_mcrei_app_beni.id_logical_bene%TYPE,
                           /*KEY*/
                           p_c_sndg         t_mcrei_app_beni.cod_sndg%TYPE,
                           p_d_intestatario t_mcrei_app_beni.desc_intestatario %TYPE,
                           /*KEY*/
                           p_c_tipo_bene t_mcrei_app_beni.cod_tipo_bene%TYPE,
                           /*KEY*/
                           p_c_fogl_map_sub t_mcrei_app_beni.cod_fogl_map_sub% TYPE,
                           p_c_diritto      t_mcrei_app_beni.cod_diritto%TYPE,
                           p_v_quota_dir    t_mcrei_app_beni.val_quo_diritto% TYPE,
                           p_desc_comune    t_mcrei_app_beni.desc_comune%TYPE)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_BENI_MAN';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'POPOLA_BENI_MAN controllo parametri: ' || p_c_sndg;

    IF p_c_sndg IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    IF p_id_bene IS NOT NULL
    THEN
      p_note := 'Aggiornamento BENI con i campi inseriti dall''utente, ' ||
                p_c_sndg;

      UPDATE t_mcrei_app_beni b
         SET b.desc_intestatario = p_d_intestatario,
             b.cod_tipo_bene     = p_c_tipo_bene,
             b.cod_fogl_map_sub  = p_c_fogl_map_sub,
             b.cod_diritto       = p_c_diritto,
             b.val_quo_diritto   = p_v_quota_dir, ---MODIFICATO IL 23/2
             b.desc_comune       = p_desc_comune,
             b.flg_manuale       = 'Y',
             b.dta_upd_bene      = SYSDATE
       WHERE b.id_logical_bene = p_id_bene
         AND b.cod_sndg = p_c_sndg;
    ELSE
      p_note := 'Inserimento nuovo bene con i campi inseriti dall''utente';

      INSERT INTO t_mcrei_app_beni
        (id_dper,
         id_logical_bene,
         cod_sndg,
         desc_intestatario,
         cod_tipo_bene,
         cod_fogl_map_sub,
         cod_diritto,
         val_quo_diritto,
         flg_manuale,
         desc_comune,
         dta_ins_bene,
         dta_upd_bene,
         dta_ins)
      VALUES
        (to_number(to_char(SYSDATE, 'YYYYMMDD')),
         seq_mcrei_beni.nextval,
         p_c_sndg,
         p_d_intestatario,
         p_c_tipo_bene,
         p_c_fogl_map_sub,
         p_c_diritto,
         p_v_quota_dir,
         'Y',
         p_desc_comune,
         SYSDATE,
         SYSDATE,
         SYSDATE);
    END IF;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_beni_man;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  FUNCTION CHE ELIMINA FISICAMENTE IL BENE PASSATO IN INPUT
  -- %CD 9 MAR 2012
  FUNCTION elimina_bene(p_id_bene t_mcrei_app_beni.id_logical_bene%TYPE)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.ELIMINA_BENE';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'INSERISCI_BENI_MAN controllo parametri, ID_BENE = ' ||
              p_id_bene;

    IF p_id_bene IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'ELIMINAZIONE BENE CON ID_BENE = ' || p_id_bene;

    DELETE t_mcrei_app_beni WHERE id_logical_bene = p_id_bene;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END elimina_bene;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI DEI BENI_PROPOSTE INSERITI DALL'UTENTE
  -- %D LA FUNCTION SALVA I CAMPI INSERITI DALL'UTENTE NELLA SEZIONE BENI
  -- %CD 26 GEN 2012
  -- %PARAM P_ID_BENE ID LOGICO DEL BENE, NOT NULL
  -- %PARAM P_C_ABI ABI, NOT NULL
  -- %PARAM P_C_NDG NDG, NOT NULL
  -- %PARAM P_D_INTESTATARIO DESCRIZIONE INTESTATARIO
  -- %PARAM P_C_TIPO_BENE   CODICE TIPO BENE
  -- %PARAM P_C_FOGL_MAP_SUB  CODICE FOGLIO MAPPALE SUBALTERNO
  -- %PARAM P_C_FOGL_MAP_SUB FOGLIO, MAPPALE E SUBALTERNO, NOT NULL
  -- %PARAM P_V_PROGR_BENE_CESP PROGRESSIVO BENE CESPITE, NOT NULL
  FUNCTION salva_beni_proposta(p_id_bene t_mcrei_app_beni.id_logical_bene%TYPE,
                               --V_MCREI_APP_BENI
                               p_cod_sndg          t_mcrei_app_beni_proposte. cod_sndg%TYPE,
                               p_cod_tipo_bene     t_mcrei_app_beni_proposte. cod_tipo_bene%TYPE,
                               p_cod_proto_delib   t_mcrei_app_beni_proposte. cod_protocollo_delibera%TYPE,
                               p_cod_proto_pacch   t_mcrei_app_beni_proposte. cod_protocollo_pacchetto%TYPE,
                               p_desc_intestatario t_mcrei_app_beni_proposte. desc_intestatario%TYPE,
                               p_desc_comune       t_mcrei_app_beni_proposte. desc_comune%TYPE,
                               p_cod_fogl_map_sub  t_mcrei_app_beni_proposte. cod_fogl_map_sub%TYPE,
                               p_cod_diritto       t_mcrei_app_beni_proposte. cod_diritto%TYPE,
                               p_val_quota         t_mcrei_app_beni_proposte. val_quota%TYPE)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.SALVA_BENI_PROPOSTA';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'T_MCREI_APP_BENI_PROPOSTE controllo parametri';

    IF p_cod_sndg IS NULL OR
       p_cod_proto_delib IS NULL OR
       p_cod_proto_pacch IS NULL OR
       p_id_bene IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'delete T_MCREI_APP_BENI_PROPOSTE popola beni proposte';

    DELETE t_mcrei_app_beni_proposte pp
     WHERE pp.cod_protocollo_delibera = p_cod_proto_delib
       AND pp.cod_protocollo_pacchetto = p_cod_proto_pacch;

    p_note := 'insert T_MCREI_APP_BENI_PROPOSTE popola beni proposte';

    INSERT INTO t_mcrei_app_beni_proposte t
      (t.id_logical_bene,
       t.cod_sndg,
       t.cod_protocollo_delibera,
       t.cod_protocollo_pacchetto,
       t.desc_intestatario,
       t.desc_comune,
       t.cod_tipo_bene,
       t.cod_fogl_map_sub,
       t.cod_diritto,
       t.val_quota,
       t.flg_manuale,
       t.dta_visura)
      SELECT b.id_logical_bene,
             b.cod_sndg,
             p_cod_proto_delib,
             p_cod_proto_pacch,
             b.desc_intestatario,
             b.desc_comune,
             b.cod_tipo_bene,
             b.cod_fogl_map_sub,
             b.cod_diritto,
             b.val_quo_diritto,
             b.flg_manuale,
             b.dta_visura
        FROM t_mcrei_app_beni b
       WHERE b.cod_sndg = p_cod_sndg;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END salva_beni_proposta;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI DEI BENI INSERITI IN MODO AUTOMATICO DALLE VISURE
  -- %D LA FUNCTION SALVA I CAMPI PROVENIENTI DA VISURE
  -- %CD 26 GEN 2012
  -- %PARAM P_C_ABI ABI, NOT NULL
  -- %PARAM P_C_NDG NDG, NOT NULL
  -- %PARAM P_C_TIPO_BENE CODICE TIPO BENE, LUNGHEZZA 1, NOT NULL
  -- %PARAM P_C_CATASTO   CATEGORIA CATASTALE, LUNGHEZZA MAX 3, NOT NULL
  -- %PARAM P_C_CESPITE   PROGRESSIVO CESPITE, NOT NULL
  -- %PARAM P_C_FOGL_MAP_SUB FOGLIO, MAPPALE E SUBALTERNO, NOT NULL
  -- %PARAM P_V_PROGR_BENE_CESP PROGRESSIVO BENE CESPITE, NOT NULL
  FUNCTION popola_beni(
                       /* CHIAVE SECONDARIA */p_c_sndg            t_mcrei_app_beni.cod_sndg%TYPE,
                       p_c_tipo_bene       t_mcrei_app_beni.cod_tipo_bene%TYPE,
                       p_c_catasto         t_mcrei_app_beni.cod_catasto%TYPE,
                       p_c_cespite         t_mcrei_app_beni.cod_cespite%TYPE,
                       p_c_fogl_map_sub    t_mcrei_app_beni.cod_fogl_map_sub% TYPE,
                       p_v_progr_bene_cesp t_mcrei_app_beni. val_progr_bene_cesp%TYPE,
                       /* CAMPI DA AGGIORNARE O INSERIRE */
                       p_c_conservatoria     t_mcrei_app_beni. cod_conservatoria%TYPE,
                       p_c_diritto           t_mcrei_app_beni.cod_diritto%TYPE,
                       p_c_divisa            t_mcrei_app_beni.cod_divisa%TYPE,
                       p_c_interno           t_mcrei_app_beni.cod_interno%TYPE,
                       p_c_piano             t_mcrei_app_beni.cod_piano%TYPE,
                       p_c_provincia         t_mcrei_app_beni.cod_provincia% TYPE,
                       p_c_scala             t_mcrei_app_beni.cod_scala%TYPE,
                       p_c_tipo              t_mcrei_app_beni.cod_tipo%TYPE,
                       p_c_denuncia          t_mcrei_app_beni. cod_tipo_denuncia%TYPE,
                       p_c_tipologia_terreno t_mcrei_app_beni. cod_tipologia_terreno%TYPE,
                       p_d_comune            t_mcrei_app_beni.desc_comune%TYPE,
                       p_d_conservatoria     t_mcrei_app_beni. desc_conservatoria%TYPE,
                       p_d_indirizzo         t_mcrei_app_beni.desc_indirizzo% TYPE,
                       p_d_localita          t_mcrei_app_beni.desc_localita% TYPE,
                       p_dta_visura          t_mcrei_app_beni.dta_visura%TYPE,
                       p_f_cantina           t_mcrei_app_beni.flg_pres_cantina %TYPE,
                       p_f_servizi           t_mcrei_app_beni.flg_pres_servizi %TYPE,
                       p_f_solaio            t_mcrei_app_beni.flg_pres_solaio% TYPE,
                       p_v_rendita           t_mcrei_app_beni.val_num_rendita% TYPE,
                       p_v_vani              t_mcrei_app_beni.val_num_vani% TYPE,
                       p_v_superficie        t_mcrei_app_beni.val_superficie% TYPE,
                       p_val_quota           t_mcrei_app_beni.val_quo_diritto% TYPE,
                       p_desc_intestatario   t_mcrei_app_beni. desc_intestatario%TYPE)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_BENI';
    p_note    t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_flg_ins NUMBER(1) := 0;
  BEGIN
    p_note := 'POPOLA_BENI controllo parametri: ' || p_c_sndg || ', ' ||
              p_c_cespite || ', ' || p_c_fogl_map_sub || ',' ||
              p_v_progr_bene_cesp;

    IF p_c_sndg IS NULL OR
       p_c_tipo_bene IS NULL
      --         OR P_C_CATASTO IS NULL
       OR
       p_c_cespite IS NULL OR
       p_c_fogl_map_sub IS NULL OR
       p_v_progr_bene_cesp IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'Aggiornamento BENI con i campi provenienti da VISURE' ||
              p_c_sndg || ', ' || p_c_cespite || ', ' || p_c_fogl_map_sub || ',' ||
              p_v_progr_bene_cesp;
    MERGE INTO t_mcrei_app_beni t
    USING (SELECT p_c_sndg AS cod_sndg,
                  TRIM(p_c_tipo_bene) AS cod_tipo_bene,

                  --arriva con degli spazi!
                  p_c_catasto           AS cod_catasto,
                  p_c_cespite           AS cod_cespite,
                  p_c_fogl_map_sub      AS cod_fogl_map_sub,
                  p_v_progr_bene_cesp   AS val_progr_bene_cesp,
                  p_c_conservatoria     AS cod_conservatoria,
                  p_c_diritto           AS cod_diritto,
                  p_c_divisa            AS cod_divisa,
                  p_c_interno           AS cod_interno,
                  p_c_piano             AS cod_piano,
                  p_c_provincia         AS cod_provincia,
                  p_c_scala             AS cod_scala,
                  p_c_tipo              AS cod_tipo,
                  p_c_denuncia          AS cod_tipo_denuncia,
                  p_c_tipologia_terreno AS cod_tipologia_terreno,
                  p_d_comune            AS desc_comune,
                  p_d_conservatoria     AS desc_conservatoria,
                  p_d_indirizzo         AS desc_indirizzo,
                  p_d_localita          AS desc_localita,
                  p_dta_visura          AS dta_visura,
                  p_f_cantina           AS flg_pres_cantina,
                  p_f_servizi           AS flg_pres_servizi,
                  p_f_solaio            AS flg_pres_solaio,
                  p_v_rendita           AS val_num_rendita,
                  p_v_vani              AS val_num_vani,
                  p_v_superficie        AS val_superficie,
                  p_val_quota           AS val_quota,
                  p_desc_intestatario   AS desc_intestatario
             FROM dual) s
    ON (t.cod_sndg = s.cod_sndg AND t.cod_tipo_bene = s.cod_tipo_bene
    --                    AND T.COD_CATASTO = S.COD_CATASTO
    AND t.cod_cespite = s.cod_cespite AND t.cod_fogl_map_sub = s. cod_fogl_map_sub AND t.val_progr_bene_cesp = s.val_progr_bene_cesp)
    WHEN MATCHED THEN
      UPDATE
         SET t.cod_conservatoria     = s.cod_conservatoria,
             t.cod_diritto           = s.cod_diritto,
             t.cod_divisa            = s.cod_divisa,
             t.cod_interno           = s.cod_interno,
             t.cod_piano             = s.cod_piano,
             t.cod_provincia         = s.cod_provincia,
             t.cod_scala             = s.cod_scala,
             t.cod_tipo              = s.cod_tipo,
             t.cod_tipo_denuncia     = s.cod_tipo_denuncia,
             t.cod_tipologia_terreno = s.cod_tipologia_terreno,
             t.desc_comune           = s.desc_comune,
             t.desc_conservatoria    = s.desc_conservatoria,
             t.desc_indirizzo        = s.desc_indirizzo,
             t.desc_localita         = s.desc_localita,
             t.dta_visura            = s.dta_visura,
             t.flg_pres_cantina      = s.flg_pres_cantina,
             t.flg_pres_servizi      = s.flg_pres_servizi,
             t.flg_pres_solaio       = s.flg_pres_solaio,
             t.val_num_rendita       = s.val_num_rendita,
             t.val_num_vani          = s.val_num_vani,
             t.val_superficie        = s.val_superficie,
             t.flg_manuale           = 'N',
             t.dta_upd_bene          = SYSDATE,
             t.val_quo_diritto       = val_quota,
             t.desc_intestatario     = desc_intestatario
    WHEN NOT MATCHED THEN
      INSERT
        (t.id_dper,
         t.cod_sndg,
         t.cod_tipo_bene,
         t.cod_catasto,
         t.cod_cespite,
         t.cod_fogl_map_sub,
         t.val_progr_bene_cesp,
         t.cod_conservatoria,
         t.cod_diritto,
         t.cod_divisa,
         t.cod_interno,
         t.cod_piano,
         t.cod_provincia,
         t.cod_scala,
         t.cod_tipo,
         t.cod_tipo_denuncia,
         t.cod_tipologia_terreno,
         t.desc_comune,
         t.desc_conservatoria,
         t.desc_indirizzo,
         t.desc_localita,
         t.dta_visura,
         t.flg_pres_cantina,
         t.flg_pres_servizi,
         t.flg_pres_solaio,
         t.val_num_rendita,
         t.val_num_vani,
         t.val_superficie,
         t.id_logical_bene,
         t.flg_manuale,
         t.dta_ins,
         t.dta_ins_bene,
         t.val_quo_diritto,
         t.desc_intestatario)
      VALUES
        (to_number(to_char(SYSDATE, 'YYYYMMDD')), --id_dper
         s.cod_sndg,
         s.cod_tipo_bene,
         s.cod_catasto,
         s.cod_cespite,
         s.cod_fogl_map_sub,
         s.val_progr_bene_cesp,
         s.cod_conservatoria,
         s.cod_diritto,
         s.cod_divisa,
         s.cod_interno,
         s.cod_piano,
         s.cod_provincia,
         s.cod_scala,
         s.cod_tipo,
         s.cod_tipo_denuncia,
         s.cod_tipologia_terreno,
         s.desc_comune,
         s.desc_conservatoria,
         s.desc_indirizzo,
         s.desc_localita,
         s.dta_visura,
         s.flg_pres_cantina,
         s.flg_pres_servizi,
         s.flg_pres_solaio,
         s.val_num_rendita,
         s.val_num_vani,
         s.val_superficie,
         seq_mcrei_beni.nextval,
         'N',
         SYSDATE,
         SYSDATE,
         s.val_quota,
         s.desc_intestatario);
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_beni;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA LA FOTO DEI COINTESTATARI ASSOCIATI ALLA PROPOSTA
  -- %CD 26 GEN 2012
  FUNCTION popola_cointestatari_proposta(p_cod_abi                 IN t_mcrei_app_cointest_prop.cod_abi%TYPE,
                                         p_cod_sndg                IN t_mcrei_app_cointest_prop.cod_sndg%TYPE,
                                         p_cod_ndg                 IN t_mcrei_app_cointest_prop.cod_ndg%TYPE,
                                         p_protocollo_pacchetto    IN t_mcrei_app_cointest_prop.cod_protocollo_pacchetto%TYPE,
                                         p_protocollo_delibera     IN t_mcrei_app_cointest_prop.cod_protocollo_delibera%TYPE,
                                         p_cod_sndg_cointestatario IN t_mcrei_app_cointest_prop.cod_sndg_cointestatario%TYPE,
                                         p_cod_ndg_cointestatario  IN t_mcrei_app_cointest_prop.cod_ndg_cointestatario%TYPE,
                                         p_cod_abi_cointestatario  IN t_mcrei_app_cointest_prop.cod_abi_cointestatario%TYPE,
                                         p_desc_nome_controparte   IN t_mcrei_app_cointest_prop.desc_nome_controparte%TYPE)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.POPOLA_PROPOSTE_COINTEST';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'POPOLA T_MCREI_APP_COINTEST_PROP proposte cointestatari';

    IF p_cod_sndg IS NULL OR
       p_cod_sndg_cointestatario IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    MERGE INTO t_mcrei_app_cointest_prop t
    USING (SELECT p_cod_abi                 cod_abi,
                  p_cod_sndg                cod_sndg,
                  p_cod_ndg                 cod_ndg,
                  p_cod_sndg_cointestatario cod_sndg_cointestatario,
                  p_cod_ndg_cointestatario  cod_ndg_cointestatario,
                  p_cod_abi_cointestatario  cod_abi_cointestatario,
                  p_desc_nome_controparte   desc_nome_controparte,
                  p_protocollo_delibera     cod_protocollo_delibera,
                  p_protocollo_pacchetto    cod_protocollo_pacchetto
             FROM dual) s
    ON (t.cod_abi = s.cod_abi AND t.cod_ndg = s.cod_ndg AND t. cod_protocollo_delibera = s.cod_protocollo_delibera AND t.cod_protocollo_pacchetto = s.cod_protocollo_pacchetto AND t.cod_abi_cointestatario = s.cod_abi_cointestatario AND t.cod_ndg_cointestatario = s.cod_ndg_cointestatario)
    WHEN MATCHED THEN
      UPDATE SET t.desc_nome_controparte = s.desc_nome_controparte
    WHEN NOT MATCHED THEN
      INSERT
        (t.cod_abi,
         t.cod_sndg,
         t.cod_ndg,
         t.cod_sndg_cointestatario,
         t.cod_ndg_cointestatario,
         t.cod_abi_cointestatario,
         t.desc_nome_controparte,
         t.cod_protocollo_delibera,
         t.cod_protocollo_pacchetto)
      VALUES
        (s.cod_abi,
         s.cod_sndg,
         s.cod_ndg,
         s.cod_sndg_cointestatario,
         s.cod_ndg_cointestatario,
         s.cod_abi_cointestatario,
         s.desc_nome_controparte,
         s.cod_protocollo_delibera,
         s.cod_protocollo_pacchetto);
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END popola_cointestatari_proposta;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE AGGIORNA GLI ID DEI DOCUMENTI PRESENTI NELLA TABELLA IN CUI SCRIVE DOCUMENTUM DA WEB.
  -- %D LA FUNCTION AGGIORNA GLI ID DEI DOC IN INPUT IN CORRISPONDENZA DELLA DELIBERA IN INPUT
  -- %CD 2 FEB 2012
  FUNCTION update_id_documenti(p_abi                  t_mcrei_app_delibere. cod_abi%TYPE,
                               p_ndg                  t_mcrei_app_delibere. cod_ndg%TYPE,
                               p_proto_delib          t_mcrei_app_delibere. cod_protocollo_delibera%TYPE,
                               p_doc_delibera_banca   t_mcrei_app_delibere. cod_doc_delibera_banca%TYPE,
                               p_doc_parere_conform   t_mcrei_app_delibere. cod_doc_parere_conformita%TYPE,
                               p_doc_appendice_parere t_mcrei_app_delibere. cod_doc_appendice_parere%TYPE,
                               p_doc_delib_capogr     t_mcrei_app_delibere. cod_doc_delibera_capogruppo%TYPE,
                               p_doc_classif          t_mcrei_app_delibere. cod_doc_classificazione%TYPE)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.UPDATE_ID_DOCUMENTI';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'aggiorna id del/i documento/i da web' || p_abi || ', ' ||
              p_ndg || ', ' || p_proto_delib||' '
              --v6.57
              ||p_doc_delibera_banca||'-'||p_doc_parere_conform||'-'
              ||p_doc_appendice_parere||'-'||p_doc_delib_capogr||'-'||p_doc_classif;

    UPDATE t_mcrei_app_delibere de
       SET cod_doc_delibera_banca      = p_doc_delibera_banca,
           cod_doc_parere_conformita   = p_doc_parere_conform,
           cod_doc_appendice_parere    = p_doc_appendice_parere,
           cod_doc_delibera_capogruppo = p_doc_delib_capogr,
           cod_doc_classificazione     = p_doc_classif,
           de.dta_last_upd_delibera    = SYSDATE
     WHERE de.cod_abi = p_abi
       AND de.cod_ndg = p_ndg
       AND de.cod_protocollo_delibera = p_proto_delib;

    p_note := p_note || 'rowcount: ' || SQL%ROWCOUNT;
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END update_id_documenti;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI DELLE DELIBERE GENERICHE
  -- %D LA FUNCTION, PER OGNI ABI, NDG, PROTOCOLLO DI DELIBERA E PROTOCOLLO_PACCHETTO IN INPUT,
  -- %D AGGIORNA GLI ATTRIBUTI CORRISPONDENTI CON I VALORI PASSATI IN INPUT,
  -- %D E RECUPERA I DATI CONTABILI DIRETTAMENTE DA PCR
  -- %CD 10 FEB 2012
  -- V_MCREI_APP_DELIB_GENERICHE
  FUNCTION popola_del_generica(p_cod_abi         IN t_mcrei_app_delibere. cod_abi%TYPE,
                               p_cod_ndg         IN t_mcrei_app_delibere. cod_ndg%TYPE,
                               p_proto_pacchetto IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE,
                               p_proto_delibera  IN t_mcrei_app_delibere. cod_protocollo_delibera%TYPE,
                               -----------------------------------------------------------------------------------
                               p_val_del_rinuncia  IN t_mcrei_app_delibere. val_rinuncia_deliberata%TYPE,
                               p_val_prop_rinuncia IN t_mcrei_app_delibere. val_rinuncia_proposta%TYPE,
                               p_val_tot_rinuncia  IN t_mcrei_app_delibere. val_rinuncia_totale%TYPE,
                               p_val_del_rettifica IN t_mcrei_app_delibere. val_rdv_qc_deliberata%TYPE,
                               p_desc_note         IN t_mcrei_app_delibere. desc_note%TYPE,
                               p_dta_scadenza      IN t_mcrei_app_delibere. dta_scadenza%TYPE DEFAULT NULL)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_DEL_GENERICA';
    p_note             t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_perdita_parziale NUMBER;
    v_livello          varchar2(5);
  BEGIN
    p_note := 'UPDATE T_MCREI_APP_DELIBERE popola dati manuali delibera generica,' ||
              p_cod_abi || ',' || p_cod_ndg || ',' || p_proto_pacchetto || ',' ||
              p_proto_delibera;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    MERGE INTO t_mcrei_app_delibere t
    USING (SELECT f.cod_abi_cartolarizzato,
                  f.cod_ndg,
                  f.dta_decorrenza_stato,
                  f.dta_scadenza_stato,
                  p.scsb_acc_cassa AS val_acc_cassa,
                  p.scsb_acc_firma AS val_acc_firma,
                  p.scsb_acc_sostituzioni AS val_acc_derivati,
                  p.scsb_acc_tot AS val_acc_totale,
                  p.scsb_uti_cassa AS val_util_cassa,
                  p.scsb_uti_firma AS val_util_firma,
                  p.scsb_uti_sostituzioni AS val_util_derivati,
                  p.scsb_uti_tot AS val_util_totale,
                  (nvl(p.scsb_uti_cassa, 0) - nvl(i.interessi_di_mora, 0)) AS val_util_capitale, --modificato il 27/2
                  nvl(i.interessi_di_mora, 0) AS val_util_mora,
                  f.cod_stato AS cod_stato
             FROM t_mcre0_app_all_data f,
                  t_mcrei_app_pcr_rapp_aggr p,
                  (SELECT cod_abi_cartolarizzato,
                          cod_ndg,
                          SUM(nvl(i.val_imp_mora, 0)) AS interessi_di_mora
                     FROM t_mcre0_app_rate_daily i
                    GROUP BY cod_abi_cartolarizzato,
                             cod_ndg) i
            WHERE f.cod_abi_cartolarizzato = p_cod_abi
              AND f.cod_ndg = p_cod_ndg
              AND p.cod_abi_cartolarizzato = p_cod_abi
              AND p.cod_ndg = p_cod_ndg
              AND p.cod_abi_cartolarizzato = i.cod_abi_cartolarizzato(+)
              AND p.cod_ndg = i.cod_ndg(+)) s
    ON (T.COD_ABI = S.COD_ABI_CARTOLARIZZATO AND T.COD_NDG = S.COD_NDG AND T. COD_PROTOCOLLO_PACCHETTO = P_PROTO_PACCHETTO AND T.COD_PROTOCOLLO_DELIBERA = P_PROTO_DELIBERA AND T.FLG_ATTIVA = '1'
    --AND t.cod_macrotipologia_delib = 'GE' AND t.cod_microtipologia_delib NOT IN('CI','RV')
    AND t.cod_fase_pacchetto NOT IN('ANA','ANM'))
    WHEN MATCHED THEN
      UPDATE
         SET t.dta_decorrenza_stato     = s.dta_decorrenza_stato,
             t.dta_scadenza_incaglio    = s.dta_scadenza_stato,
             t.val_accordato_cassa      = s.val_acc_cassa,
             t.val_accordato_firma      = s.val_acc_firma,
             t.val_accordato_derivati   = s.val_acc_derivati,
             t.val_accordato            = s.val_acc_totale,
             t.val_uti_firma_scsb       = s.val_util_firma,
             t.val_uti_cassa_scsb       = s.val_util_cassa, ---10 aprile
             t.val_uti_sosti_scsb       = s.val_util_derivati,
             t.val_uti_tot_scsb         = s.val_util_totale,
             t.val_esp_lorda            = s.val_util_totale, --7 giu
             t.val_esp_lorda_capitale   = s.val_util_capitale,
             t.val_esp_lorda_mora       = s.val_util_mora,
             t.val_esp_netta_post_delib = t.val_esp_netta_ante_delib, --15 giu
             t.val_rinuncia_proposta    = p_val_prop_rinuncia,
             t.val_rinuncia_capitale    = p_val_prop_rinuncia,
             t.val_imp_perdita          = p_val_del_rinuncia +
                                          p_val_prop_rinuncia,
             t.val_rinuncia_totale      = p_val_del_rinuncia +
                                          p_val_prop_rinuncia,
             t.desc_note                = p_desc_note,
             t.dta_last_upd_delibera    = SYSDATE,
             t.dta_scadenza             = p_dta_scadenza;

  --- INIZIO gestione proroghe incaglio di divisione: AD: 5 MARZO, PER LE DIVISIONI LA DATA SCADENZA DIGITATA PER LA PROROGA VIENE SPALMATA SU TUTTE LE PROROGHE DEL PACCHETTO

--    begin
--    select cod_livello
--    into v_livello
--    from t_mcrei_app_delibere t,t_mcre0_app_comparti c
--    where cod_protocollo_delibera = p_proto_delibera
--    and cod_abi = p_cod_abi
--    and cod_ndg = p_cod_ndg
--    and cod_uo_pratica = c.cod_comparto;
--
--    exception when no_DAta_found
--    then
--
--    select cod_livello
--    into v_livello
--    from t_mcre0_app_all_Data t, t_mcre0_app_comparti c
--    where cod_abi_cartolarizzato = p_cod_abi
--    and cod_ndg = p_cod_ndg
--    and today_flg='1'
--    and nvl(cod_comparto_Calcolato,cod_comparto_Assegnato)= c.cod_comparto;
--
--    end;
--
--    IF v_livello != 'DC'
--    THEN ----SPALMA DTA_SCADENZA SU TUTTE LE PROROGHE DEL PACCHETTO

    UPDATE T_MCREI_aPP_dELIBERE
       SET DTA_sCADENZA = P_DTA_SCADENZA
     WHERE COD_PROTOCOLLO_PACCHETTO = P_PROTO_PACCHETTO
       AND COD_MICROTIPOLOGIA_DELIB in ('PS','PU','PR') --('PT','PD','PR')
       and (select cod_microtipologia_delib from t_mcrei_app_delibere where cod_abi = p_cod_abi
                and cod_ndg = p_cod_ndg and cod_protocollo_delibera = p_proto_delibera)   in ('PS','PU','PR'); --('PT','PD','PR')

    p_note := 'spalmata data scadenza sulle proroghe del pacchetto '||P_PROTO_PACCHETTO;
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
  --  END IF;
    -----FINE gestione proroghe INCAGLIO di divisione

    -- new: aggiorno il valore di rinuncia complessiva per tutte le delibere del pacchetto, abi e ndg
    -- sulla base di tutte le rinunce digitate finora su di esso
    SELECT DISTINCT SUM(val_rinuncia_capitale + nvl(val_rinuncia_mora, 0)) over(PARTITION BY cod_abi, cod_ndg, cod_protocollo_pacchetto)
      INTO v_perdita_parziale
      FROM t_mcrei_app_delibere d
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_pacchetto = p_proto_pacchetto
       AND D.COD_FASE_PACCHETTO NOT IN ('ANA','ANM');

    UPDATE t_mcrei_app_delibere d
       SET val_imp_perdita     = p_val_del_rinuncia + v_perdita_parziale,
           val_rinuncia_totale = p_val_del_rinuncia + v_perdita_parziale
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_pacchetto = p_proto_pacchetto;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_del_generica;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI INSERITI MANUALMENTE DELLE DELIBERE GENERICHE
  -- %D LA FUNCTION, PER OGNI ABI, NDG, PROTOCOLLO DI DELIBERA E PROTOCOLLO_PACCHETTO IN INPUT,
  -- %D AGGIORNA GLI ATTRIBUTI CORRISPONDENTI CON
  -- %D I VALORI PASSATI IN INPUT
  -- %CD 10 FEB 2012
  FUNCTION popola_man_del_generica(p_cod_abi         IN t_mcrei_app_delibere. cod_abi%TYPE,
                                   p_cod_ndg         IN t_mcrei_app_delibere. cod_ndg%TYPE,
                                   p_proto_pacchetto IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE,
                                   p_proto_delibera  IN t_mcrei_app_delibere. cod_protocollo_delibera%TYPE,
                                   -------------------------------------------------------------------------------------
                                   p_val_del_rinuncia  IN t_mcrei_app_delibere .val_rinuncia_deliberata%TYPE,
                                   p_val_prop_rinuncia IN t_mcrei_app_delibere .val_rinuncia_proposta%TYPE,
                                   p_val_tot_rinuncia  IN t_mcrei_app_delibere .val_rinuncia_totale%TYPE,
                                   p_desc_note         IN t_mcrei_app_delibere .desc_note%TYPE,
                                   p_dta_scadenza      IN t_mcrei_app_delibere .dta_scadenza%TYPE DEFAULT NULL)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_MAN_DEL_GENERICA';
    p_note             t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_perdita_parziale NUMBER;
    v_livello          varchar2(5);
  BEGIN
    p_note := 'POPOLA_MAN_DEL_GENERICA: controllo parametri in input';

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'UPDATE T_MCREI_APP_DELIBERE popola dati manuali delibera generica';

    UPDATE t_mcrei_app_delibere d
       SET val_rinuncia_proposta = p_val_prop_rinuncia,
           val_rinuncia_capitale = p_val_prop_rinuncia,
           val_imp_perdita       = p_val_del_rinuncia + p_val_prop_rinuncia,
           val_rinuncia_totale   = p_val_del_rinuncia + p_val_prop_rinuncia,
           desc_note             = p_desc_note,
           dta_last_upd_delibera = SYSDATE,
           dta_scadenza          = p_dta_scadenza
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_pacchetto = p_proto_pacchetto
       AND d.cod_protocollo_delibera = p_proto_delibera;

    --- INIZIO gestione proroghe incaglio di divisione: AD: 5 MARZO, PER LE DIVISIONI LA DATA SCADENZA DIGITATA PER LA PROROGA VIENE SPALMATA SU TUTTE LE PROROGHE DEL PACCHETTO

--    begin
--    select cod_livello
--    into v_livello
--    from t_mcrei_app_delibere t,t_mcre0_app_comparti c
--    where cod_protocollo_delibera = p_proto_delibera
--    and cod_abi = p_cod_abi
--    and cod_ndg = p_cod_ndg
--    and cod_uo_pratica = c.cod_comparto;
--
--    exception when no_DAta_found
--    then
--
--    select cod_livello
--    into v_livello
--    from t_mcre0_app_all_Data t,t_mcre0_app_comparti c
--    where cod_abi_cartolarizzato = p_cod_abi
--    and cod_ndg = p_cod_ndg
--    and today_flg='1'
--    and nvl(cod_comparto_Calcolato,cod_comparto_Assegnato)= c.cod_comparto;
--
--    end;
--
--    IF v_livello != 'DC'
--    THEN ----SPALMA DTA_SCADENZA SU TUTTE LE PROROGHE DEL PACCHETTO

    UPDATE T_MCREI_aPP_dELIBERE
       SET DTA_sCADENZA = P_DTA_SCADENZA
     WHERE COD_PROTOCOLLO_PACCHETTO = P_PROTO_PACCHETTO
       AND COD_MICROTIPOLOGIA_DELIB in ('PS','PU','PR') --('PT','PD','PR')
       and (select cod_microtipologia_delib from t_mcrei_app_delibere where cod_abi = p_cod_abi
                and cod_ndg = p_cod_ndg and cod_protocollo_delibera = p_proto_delibera)   in ('PS','PU','PR');--('PT','PD','PR')

    p_note := 'spalmata data scadenza sulle proroghe del pacchetto '||P_PROTO_PACCHETTO;
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
 --   END IF;
    -----FINE gestione proroghe INCAGLIO di divisione

    -- new: aggiorno il valore di rinuncia complessiva per tutte le delibere del pacchetto, abi e ndg
    -- sulla base di tutte le rinunce digitate finora su di esso
    SELECT DISTINCT SUM(val_rinuncia_capitale + nvl(val_rinuncia_mora, 0)) over(PARTITION BY cod_abi, cod_ndg, cod_protocollo_pacchetto)
      INTO v_perdita_parziale
      FROM t_mcrei_app_delibere d
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_pacchetto = p_proto_pacchetto
        AND COD_FASE_PACCHETTO NOT IN ('ANA','ANM');

    UPDATE t_mcrei_app_delibere d
       SET val_imp_perdita     = p_val_del_rinuncia + v_perdita_parziale,
           val_rinuncia_totale = p_val_del_rinuncia + v_perdita_parziale
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_pacchetto = p_proto_pacchetto;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_del_generica;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI INSERITI MANUALMENTE DELLE DELIBERE DI CHIUSURA
  -- %D LA FUNCTION, PER OGNI ABI, NDG, PROTOCOLLO DI DELIBERA E PROTOCOLLO_PACCHETTO IN INPUT,
  -- %D AGGIORNA GLI ATTRIBUTI CORRISPONDENTI CON
  -- %D I VALORI PASSATI IN INPUT
  -- %CD 10 FEB 2012
  FUNCTION popola_man_del_chiusura(p_cod_abi          IN t_mcrei_app_delibere. cod_abi%TYPE,
                                   p_cod_ndg          IN t_mcrei_app_delibere. cod_ndg%TYPE,
                                   p_proto_pacchetto  IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE,
                                   p_proto_delibera   IN t_mcrei_app_delibere. cod_protocollo_delibera%TYPE,
                                   p_causale_chiusura IN t_mcrei_app_delibere. cod_causa_chius_delibera%TYPE,
                                   p_desc_note        IN t_mcrei_app_delibere. desc_note%TYPE,
                                   p_dta_scadenza     IN t_mcrei_app_delibere. dta_scadenza%TYPE,
                                   ---------------------------------------------------------------
                                   p_tipo_ristr         IN VARCHAR2 DEFAULT NULL,
                                   p_intento_ristr      IN VARCHAR2 DEFAULT NULL,
                                   p_dta_scadenza_ristr IN DATE DEFAULT NULL,
                                   p_stato_post_ristr   IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_MAN_DEL_CHIUSURA';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri input' || p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_proto_pacchetto || ', ' || p_proto_delibera;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'POPOLA_MAN_DEL_CHIUSURA: Salvataggio dati manuali dettaglio chiusura incaglio ' ||
              p_cod_abi || ', ' || p_cod_ndg || ', ' || p_proto_pacchetto || ', ' ||
              p_proto_delibera;

    /*QUI SI POPOLANO I POCHI CAMPI MANUALE CHE L'UTENTE PUO' INSERIRE DA INTERFACCIA.
    CHIEDERE INFO SUI PARERI PER CAPIRE IN QUALE CAMPO INSERIRLO: SENTIRE LEONCINI E VEDERE NOTA
    CHE HO INSERITO ANCHE NELLA POPOLA_DEL_CHIUSURA */
    --    UPDATE T_MCREI_APP_DELIBERE
    --       SET COD_CAUSA_CHIUS_DELIBERA = P_CAUSALE_CHIUSURA,
    --           DESC_NOTE                = P_DESC_NOTE,
    --           DTA_SCADENZA             = P_DTA_SCADENZA,
    --           DESC_TIPO_RISTR          = NVL(P_TIPO_RISTR,DESC_TIPO_RISTR),
    --           DESC_INTENTO_RISTR       = NVL(P_INTENTO_RISTR,DESC_INTENTO_RISTR),
    --           DTA_SCADENZA_RISTR       = NVL(P_DTA_SCADENZA_RISTR,DTA_SCADENZA_RISTR),
    --           COD_STATO_POST_RISTR     = NVL(P_STATO_POST_RISTR,COD_STATO_POST_RISTR),
    --           DTA_LAST_UPD_DELIBERA    = SYSDATE
    --     WHERE COD_ABI = P_COD_ABI
    --       AND COD_NDG = P_COD_NDG
    --       AND COD_PROTOCOLLO_PACCHETTO = P_PROTO_PACCHETTO
    --       AND COD_PROTOCOLLO_DELIBERA = P_PROTO_DELIBERA;
    --
    UPDATE t_mcrei_app_delibere
       SET (val_accordato,
            val_accordato_derivati,
            val_uti_tot_scsb,
            val_esp_lorda,
            cod_causa_chius_delibera,
            desc_note,
            dta_last_upd_delibera,
            dta_scadenza,
            desc_tipo_ristr,
            desc_intento_ristr,
            dta_scadenza_ristr,
            cod_stato_post_ristr) =
           (SELECT p.scsb_acc_tot AS val_accordato,
                   p.scsb_acc_sostituzioni AS val_accordato_derivati,
                   p.scsb_uti_tot AS val_uti_tot_scsb,
                   p.scsb_uti_tot AS val_esp_lorda,
                   p_causale_chiusura AS cod_causa_chius_delibera,
                   p_desc_note AS desc_note,
                   SYSDATE AS dta_last_upd_delibera,
                   SYSDATE AS dta_scadenza,
                   nvl(p_tipo_ristr, d.desc_tipo_ristr) AS desc_tipo_ristr,
                   nvl(p_intento_ristr, d.desc_intento_ristr) AS desc_intento_ristr,
                   nvl(p_dta_scadenza_ristr, d.dta_scadenza_ristr) AS dta_scadenza_ristr,
                   nvl(p_stato_post_ristr, d.cod_stato_post_ristr) AS cod_stato_post_ristr
              FROM t_mcrei_app_delibere      d,
                   t_mcrei_app_pcr_rapp_aggr p
             WHERE d.cod_abi = p.cod_abi_cartolarizzato(+)
               AND d.cod_ndg = p.cod_ndg(+)
               AND d.cod_abi = p_cod_abi
               AND d.cod_ndg = p_cod_ndg
               AND d.cod_protocollo_pacchetto = p_proto_pacchetto
               AND d.cod_protocollo_delibera = p_proto_delibera
               AND d.flg_attiva = '1'
                  --AND   D.COD_MICROTIPOLOGIA_DELIB = 'CH'
               AND d.cod_fase_pacchetto NOT IN ('ANA', 'ANM'))
     WHERE cod_abi = p_cod_abi
       AND cod_ndg = p_cod_ndg
       AND cod_protocollo_pacchetto = p_proto_pacchetto
       AND cod_protocollo_delibera = p_proto_delibera
       AND flg_attiva = '1';

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_del_chiusura;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE CONGELA I CAMPI INSERITI MANUALMENTE DELLE DELIBERE DI CHIUSURA
  -- %D LA FUNCTION, PER OGNI ABI, NDG, PROTOCOLLO DI DELIBERA E PROTOCOLLO_PACCHETTO IN INPUT,
  -- %D AGGIORNA GLI ATTRIBUTI CORRISPONDENTI CON
  -- %D I VALORI PASSATI IN INPUT
  -- %CD 10 FEB 2012
  FUNCTION popola_del_chiusura(p_cod_abi          IN t_mcrei_app_delibere. cod_abi%TYPE,
                               p_cod_ndg          IN t_mcrei_app_delibere. cod_ndg%TYPE,
                               p_proto_pacchetto  IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE,
                               p_proto_delibera   IN t_mcrei_app_delibere. cod_protocollo_delibera%TYPE,
                               p_causale_chiusura IN t_mcrei_app_delibere. cod_causa_chius_delibera%TYPE,
                               p_desc_note        IN t_mcrei_app_delibere. desc_note%TYPE,
                               p_dta_scadenza     IN t_mcrei_app_delibere. dta_scadenza%TYPE,
                               -------------------------------------------------------------------------------------
                               p_tipo_ristr         IN VARCHAR2 DEFAULT NULL,
                               p_intento_ristr      IN VARCHAR2 DEFAULT NULL,
                               p_dta_scadenza_ristr IN DATE DEFAULT NULL,
                               p_stato_post_ristr   IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_DEL_CHIUSURA';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri input' || p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_proto_pacchetto || ', ' || p_proto_delibera;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'POPOLA_DEL_CHIUSURA: Salvataggio dati della vista V_MCREI_APP_DATI_DETT_CHIUS SU DELIBERE' ||
              p_cod_abi || ', ' || p_cod_ndg || ', ' || p_proto_pacchetto || ', ' ||
              p_proto_delibera;

    UPDATE t_mcrei_app_delibere d
       SET (d.val_accordato,
            d.val_accordato_derivati,
            d.val_uti_tot_scsb,
            d.val_esp_lorda,
            d.cod_causa_chius_delibera,
            d.desc_note,
            d.dta_last_upd_delibera,
            d.dta_scadenza,
            d.desc_tipo_ristr,
            d.desc_intento_ristr,
            d.dta_scadenza_ristr,
            d.cod_stato_post_ristr,
            d.val_esp_lorda_capitale,
            d.val_esp_lorda_mora,
            d.val_uti_cassa_scsb,
            d.val_uti_firma_scsb,
            d.val_uti_sosti_scsb) =
           (SELECT p.scsb_acc_tot AS val_accordato,
                   p.scsb_acc_sostituzioni AS val_accordato_derivati,
                   p.scsb_uti_tot AS val_uti_tot_scsb,
                   p.scsb_uti_tot AS val_esp_lorda,
                   p_causale_chiusura,
                   p_desc_note,
                   SYSDATE,
                   p_dta_scadenza,
                   nvl(p_tipo_ristr, desc_tipo_ristr),
                   nvl(p_intento_ristr, desc_intento_ristr),
                   nvl(p_dta_scadenza_ristr, dta_scadenza_ristr),
                   nvl(p_stato_post_ristr, cod_stato_post_ristr),
                   p.scsb_uti_cassa AS val_esp_lorda_capitale,
                   i.interessi_di_mora AS val_esp_lorda_mora,
                   p.scsb_uti_cassa AS val_uti_cassa_scsb,
                   p.scsb_uti_firma AS val_uti_firma_scsb,
                   p.scsb_uti_sostituzioni AS val_uti_sosti_scsb
              FROM t_mcrei_app_delibere d,
                   t_mcrei_app_pcr_rapp_aggr p,
                   (SELECT cod_abi_cartolarizzato,
                           cod_ndg,
                           SUM(nvl(i.val_imp_mora, 0)) AS interessi_di_mora
                      FROM t_mcre0_app_rate_daily i --5/3
                     GROUP BY cod_abi_cartolarizzato,
                              cod_ndg) i
             WHERE d.cod_abi = p.cod_abi_cartolarizzato(+)
               AND d.cod_ndg = p.cod_ndg(+)
               AND d.cod_abi = i.cod_abi_cartolarizzato(+)
               AND d.cod_ndg = i.cod_ndg(+)
               AND d.cod_abi = p_cod_abi
               AND d.cod_ndg = p_cod_ndg
               AND d.cod_protocollo_pacchetto = p_proto_pacchetto
               AND d.cod_protocollo_delibera = p_proto_delibera
               AND d.flg_attiva = '1'
               AND cod_fase_delibera != 'AN'
               AND d.cod_fase_pacchetto NOT IN ('ANA', 'ANM'))
     WHERE cod_abi = p_cod_abi
       AND cod_ndg = p_cod_ndg
       AND cod_protocollo_pacchetto = p_proto_pacchetto
       AND cod_protocollo_delibera = p_proto_delibera
       AND flg_attiva = '1';

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_del_chiusura;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI INSERITI MANUALMENTE DELLE DELIBERE DI RDV
  -- %D LA FUNCTION, PER OGNI ABI, NDG, PROTOCOLLO DI DELIBERA E PROTOCOLLO_PACCHETTO IN INPUT,
  -- %D AGGIORNA GLI ATTRIBUTI CORRISPONDENTI CON
  -- %D I VALORI PASSATI IN INPUT
  -- %CD 10 FEB 2012
  -- %PARAM P_VAL_RETT_LIV_RAPPORTO :RDV PASSATA NELLA SEZ DEI RAPPORTI DI FIRMA
  -- %PARAM P_VAL_RETT_EFFETTUATA  :RDV PASSATA NELLA SEZIONE DEI RAPPORTI DI CASSA
  FUNCTION popola_man_dett_rapp_rv(p_cod_abi               t_mcrei_app_stime. cod_abi%TYPE,
                                   p_cod_ndg               t_mcrei_app_stime. cod_ndg%TYPE,
                                   p_proto_delibera        t_mcrei_app_stime. cod_protocollo_delibera%TYPE,
                                   p_proto_pacchetto       t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                   p_cod_tipo_rapporto     t_mcrei_app_stime. cod_tipo_rapporto%TYPE,
                                   p_cod_operat_rientro    t_mcrei_app_stime. flg_tipo_dato%TYPE,
                                   p_flg_ristrutt          t_mcrei_app_stime. flg_ristrutturato%TYPE,
                                   p_flg_recupero_tot      t_mcrei_app_stime. flg_ristrutturato%TYPE,
                                   p_val_stima_di_rec      t_mcrei_app_stime. val_prev_recupero%TYPE,
                                   p_val_rett_liv_rapporto t_mcrei_app_stime. val_imp_rettifica_att%TYPE,
                                   p_val_rett_effettuata   t_mcrei_app_stime. val_imp_rettifica_att%TYPE,
                                   p_val_percentuale       t_mcrei_app_stime. val_perc_rett_rapporto%TYPE,
                                   --->nullable
                                   utente              t_mcrei_app_stime. cod_utente%TYPE,
                                   p_cod_rapporto      t_mcrei_app_stime. cod_rapporto%TYPE,
                                   p_ftecnica          VARCHAR2 DEFAULT NULL,
                                   p_flg_archiviazione VARCHAR2 DEFAULT NULL,
                                   p_flg_estinto       VARCHAR2 DEFAULT NULL)
  -- 'Y' in caso di archiviazione necessaria
   RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_MAN_DETT_RAPP_RV ';
    p_note            t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_tipo_del        VARCHAR2(5) := 'RV';
    v_rdv_pregr       t_mcrei_app_stime.val_imp_rettifica_pregr%TYPE := 0;
    v_stima_pregr     t_mcrei_app_stime.val_imp_prev_pregr%TYPE := 0;
    v_tot             NUMBER(1);
    v_dta_stima       DATE;
    v_val_esposizione NUMBER;
    v_val_mora number;

  BEGIN

    p_note := 'POPOLA_MAN_DETT_RAPP_RV: controllo parametri in input ' ||
              p_cod_abi || ', ' || p_cod_ndg || ', proto pacchetto:' ||
              p_proto_pacchetto || ', proto delibera:' || p_proto_delibera ||
              ', tipo rapporto:' || p_cod_tipo_rapporto;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_cod_rapporto IS NULL OR
       p_proto_delibera IS NULL

    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'popola dati manuali stime del:' || p_proto_delibera ||
              ' rapp:' || p_cod_rapporto || ' ft:' || p_ftecnica;


    ---Se S richiesta l'archiviazione delle stime per la delibera in input, si tratta di una rivalutazione

    IF p_flg_archiviazione = 'Y'
    THEN

      ---calcolo utilizzato e mora che verranno salvati in caso di extradelibera
     BEGIN
         SELECT DISTINCT SUM (val_imp_utilizzato) OVER (PARTITION BY P.COD_ABI,P.COD_NDG, P.COD_rAPPORTO) AS val_imp_utilizzato,
              SUM (val_imp_MORA) OVER (PARTITION BY D.COD_ABI_CARTOLARIZZATO,D.COD_NDG, D.COD_RAPPORTO) AS val_imp_mora
          INTO v_val_esposizione, v_val_mora
          FROM t_mcrei_app_pcr_rapporti p, t_mcre0_App_Rate_daily d
         WHERE p.cod_abi = p_cod_abi
           AND p.cod_ndg = p_cod_ndg
           AND p.cod_rapporto = p_cod_rapporto
           --AND p.cod_forma_tecnica = p_ftecnica
           and p.cod_abi = d.cod_abi_Cartolarizzato(+)
           and p.cod_ndg = d.cod_ndg(+)
           and p.cod_rapporto= d.cod_rapporto(+); ----corretta 1 marzo 2013 per recupero mora in caso di exradelibera
      EXCEPTION
        WHEN no_data_found THEN
          v_val_esposizione := NULL;
          v_val_mora := null;
      END;
      ---determino LA DTA_sTIMA DELLA RETTIFICA CORRENTE CHE VA ARCHIVIATA

      SELECT MAX(dta_stima)
        INTO v_dta_stima
        FROM t_mcrei_app_stime d
       WHERE cod_abi = p_cod_abi
         AND cod_ndg = p_cod_ndg
         AND cod_protocollo_delibera = p_proto_delibera
         AND cod_rapporto = p_cod_rapporto
         AND flg_attiva = '1';

      ----archivia la stima corrente SOLO SE trunc(sysdate) <> dta_Stima

      IF v_dta_stima != trunc(SYSDATE)

      THEN
        ---RECUPERO IL VALORE ATTUALE DI UTILIZZO PER IL RAPPORTO

        --archivio il singolo record di stima
        v_tot := archivia_stime(p_proto_delibera,
                                p_cod_rapporto,
                                p_cod_operat_rientro,
                                'R', --R:RIVALUTAZIONE,...
                                utente,
                                p_flg_estinto,
                                v_dta_stima);

        IF v_tot = PKG_MCREI_WEB_UTILITIES.const_esito_ko
        ---fallita archiviazione
        THEN
          RETURN v_tot;
        ELSE
          v_tot := 0;
        END IF;

      END IF;

    END IF; --fine gestione archiviazione

    BEGIN
      SELECT 1 ---verifica presenza di stime per la delibera corrente
        INTO v_tot
        FROM t_mcrei_app_stime s
       WHERE s.cod_abi = p_cod_abi
         AND s.cod_ndg = p_cod_ndg
         AND s.cod_rapporto = p_cod_rapporto
         AND s.cod_protocollo_delibera = p_proto_delibera
            --AND s.flg_tipo_dato = p_cod_operat_rientro 24 maggio
         --AND s.cod_forma_tecnica = p_ftecnica
         AND flg_attiva = '1'
         AND rownum = 1;

      UPDATE t_mcrei_app_stime st
         SET st.cod_classe_ft     = p_cod_tipo_rapporto,
             st.cod_forma_tecnica = p_ftecnica,
             st.flg_tipo_dato     = p_cod_operat_rientro,
             st.flg_ristrutturato = p_flg_ristrutt,
             st.flg_recupero_tot  = p_flg_recupero_tot,
             st.val_prev_recupero = p_val_stima_di_rec,
             st.val_esposizione   = decode(p_flg_archiviazione,
                                           'Y',
                                           v_val_esposizione,
                                           NULL),
             ---STIMA PROGRESSIVA
             st.val_rdv_tot = decode(p_cod_tipo_rapporto,
                                     'CA',
                                     p_val_rett_effettuata,
                                     'FI',
                                     p_val_rett_liv_rapporto,
                                     nvl(p_val_rett_effettuata,
                                         p_val_rett_liv_rapporto)),
             --RETTIFICA PROGRESSIVA
             st.val_imp_prev_att      =
             (p_val_stima_di_rec - st.val_imp_prev_pregr),
             st.val_imp_rettifica_att =
             (decode(p_cod_tipo_rapporto,
                     'CA',
                     p_val_rett_effettuata,
                     'FI',
                     p_val_rett_liv_rapporto,
                     nvl(p_val_rett_effettuata, p_val_rett_liv_rapporto)) -
             st.val_imp_rettifica_pregr),
             st.val_perc_rett_rapporto = p_val_percentuale,
             st.cod_utente             = utente,
             st.dta_upd                = SYSDATE,
             st.dta_stima              = trunc(SYSDATE),
             st.val_utilizzato_mora = decode(p_flg_archiviazione,
                                             'Y',
                                             v_val_mora,
                                             NULL),
             st.val_utilizzato_netto =decode(p_flg_archiviazione,
                                             'Y',(nvl(v_val_esposizione,0) - nvl(v_val_mora,0)),null) ----1 marzo 2013
       WHERE st.cod_abi = p_cod_abi
         AND st.cod_ndg = p_cod_ndg
         AND st.cod_protocollo_delibera = p_proto_delibera
         AND st.cod_rapporto = p_cod_rapporto
         AND (st.cod_forma_tecnica = p_ftecnica OR p_ftecnica = '-');

    EXCEPTION
      WHEN no_data_found THEN
        /*INSERISCE I DATI DELLA NUOVA STIMA E CONTESTUALMENTE RECUPERA I DATI PREGRESSI,
        CONSIDERANDO LA TRIPLA ABI-NDG-RAPPORTO, PRENDE RDV PREV_RECUPERO RELATIVE
        ALL'ULTIMA DTA_STIMA*/
        BEGIN
          SELECT rdv_pregressa,
                 stima_pregressa
            INTO v_rdv_pregr,
                 v_stima_pregr
            FROM (SELECT val_rdv_tot       AS rdv_pregressa,
                         val_prev_recupero AS stima_pregressa
                    FROM t_mcrei_app_stime s
                   WHERE cod_rapporto = p_cod_rapporto
                     AND s.cod_abi = p_cod_abi
                     AND s.cod_ndg = p_cod_ndg
                     AND s.flg_tipo_dato = p_cod_operat_rientro
                     AND s.cod_microtipologia_delibera = v_tipo_del
                  ---ultima rettifica su quel tipo di microtipologia
                   ORDER BY dta_stima DESC)
           WHERE rownum = 1;
        EXCEPTION
          WHEN no_data_found THEN
            v_rdv_pregr   := 0;
            v_stima_pregr := 0;
        END;

        BEGIN

          INSERT INTO t_mcrei_app_stime st
            (st.val_esposizione, ----solo per extradelibera
             st.cod_classe_ft,
             st.cod_forma_tecnica,

             --23 aprile
             st.flg_tipo_dato,
             st.flg_ristrutturato,
             st.flg_recupero_tot,
             st.val_imp_prev_pregr,
             st.val_imp_rettifica_pregr,
             st.val_imp_prev_att,

             --- VARIAZIONE PROPOSTA SULLA STIMA
             st.val_imp_rettifica_att,
             ---VARIAZIONE PROPOSTA SULLA RETTIFICA
             st.val_prev_recupero,
             st.val_rdv_tot,
             st.val_perc_rett_rapporto,
             st.cod_utente,
             st.cod_abi,
             st.cod_ndg,
             st.cod_protocollo_delibera,
             st.cod_rapporto,
             st.flg_attiva,
             cod_sndg,
             st.id_dper,
             dta_stima,
             dta_ins,
             st.cod_microtipologia_delibera,
             st.desc_causa_prev_recupero,
             st.val_utilizzato_mora,
             st.val_utilizzato_netto)
            SELECT DISTINCT decode(p_flg_archiviazione,
                                   'Y',
                                   v_val_esposizione,
                                   NULL),
                            p_cod_tipo_rapporto,
                            decode((COUNT(DISTINCT p_ftecnica)
                                    over(PARTITION BY p_cod_abi,
                                         p_cod_ndg,
                                         p_cod_rapporto)),
                                   1,
                                   p_ftecnica,
                                   '-'), --FORMA_TECNICA
                            p_cod_operat_rientro,
                            p_flg_ristrutt,
                            p_flg_recupero_tot,
                            v_stima_pregr,
                            v_rdv_pregr,

                            /*  P_VAL_STIMA_DI_REC, --STIMA ATTUALE
                            NVL(P_VAL_RETT_EFFETTUATA, P_VAL_RETT_LIV_RAPPORTO), --RETTIFICA ATTUALE
                            (V_STIMA_PREGR + P_VAL_STIMA_DI_REC), ---STIMA PROGRESSIVA
                            (V_RDV_PREGR + NVL(P_VAL_RETT_EFFETTUATA, P_VAL_RETT_LIV_RAPPORTO)), --RETTIFICA PROGRESSIVA
                            */ --> nuova logica:
                            (p_val_stima_di_rec - v_stima_pregr),

                            --STIMA ATTUALE
                            (decode(p_cod_tipo_rapporto,
                                    'CA',
                                    p_val_rett_effettuata,
                                    'FI',
                                    p_val_rett_liv_rapporto,
                                    nvl(p_val_rett_effettuata,
                                        p_val_rett_liv_rapporto)) -
                            v_rdv_pregr), --RETTIFICA ATTUALE
                            p_val_stima_di_rec, --STIMA PROGRESSIVA
                            decode(p_cod_tipo_rapporto,
                                   'CA',
                                   p_val_rett_effettuata,
                                   'FI',
                                   p_val_rett_liv_rapporto,
                                   nvl(p_val_rett_effettuata,
                                       p_val_rett_liv_rapporto)),

                            --RETTIFICA PROGRESSIVA
                            p_val_percentuale,
                            utente,
                            p_cod_abi,
                            p_cod_ndg,
                            p_proto_delibera,
                            p_cod_rapporto,
                            '1',
                            p.cod_sndg,
                            to_number(to_char(trunc(SYSDATE), 'YYYYMMDD')),
                            ---IDDPER
                            trunc(SYSDATE), ---DTA_STIMA,25MAGGIO: AGGIUNTA TRUNC
                            SYSDATE, --DTA_INS
                            v_tipo_del,
                            'DELIBERA ' || (substr(p_proto_delibera, 13, 5) || '/' ||
                            substr(p_proto_delibera, 9, 4) || '/' ||
                            substr(p_proto_delibera, 1, 8)) || '-',
                            decode(p_flg_archiviazione,
                                             'Y',
                                             v_val_mora,
                                             NULL),
                            decode(p_flg_archiviazione,
                                             'Y',(nvl(v_val_esposizione,0) - nvl(v_val_mora,0)),null)
              FROM t_mcrei_app_pcr_rapporti p
             WHERE p.cod_abi = p_cod_abi
               AND p.cod_ndg = p_cod_ndg
               AND p.cod_rapporto = p_cod_rapporto
               AND (p.cod_forma_tecnica = p_ftecnica OR p_ftecnica = '-');
          ---gestione rapporto doppio dello stesso tipo (operativo)

        EXCEPTION
          WHEN dup_val_on_index THEN
            UPDATE t_mcrei_app_stime st
               SET st.cod_classe_ft     = p_cod_tipo_rapporto,
                   st.cod_forma_tecnica = p_ftecnica,
                   st.flg_tipo_dato     = p_cod_operat_rientro,
                   st.flg_ristrutturato = p_flg_ristrutt,
                   st.flg_recupero_tot  = p_flg_recupero_tot,
                   st.val_prev_recupero = p_val_stima_di_rec,
                   ---STIMA PROGRESSIVA
                   st.val_rdv_tot            = decode(p_cod_tipo_rapporto,
                                                      'CA',
                                                      p_val_rett_effettuata,
                                                      'FI',
                                                      p_val_rett_liv_rapporto,
                                                      nvl(p_val_rett_effettuata,
                                                          p_val_rett_liv_rapporto)), --RETTIFICA PROGRESSIVA
                   st.val_imp_prev_att      =
                   (p_val_stima_di_rec - st.val_imp_prev_pregr),
                   st.val_imp_rettifica_att =
                   (decode(p_cod_tipo_rapporto,
                           'CA',
                           p_val_rett_effettuata,
                           'FI',
                           p_val_rett_liv_rapporto,
                           nvl(p_val_rett_effettuata,
                               p_val_rett_liv_rapporto)) -
                   st.val_imp_rettifica_pregr),
                   st.val_perc_rett_rapporto = p_val_percentuale,
                   st.cod_utente             = utente,
                   st.dta_upd                = SYSDATE,
                   st.dta_stima              = SYSDATE,
                   st.val_utilizzato_mora    =v_val_mora,
                   st.val_esposizione        =v_val_esposizione,
                   st.val_utilizzato_netto = nvl(v_val_esposizione,0)-nvl(v_val_mora,0)
             WHERE st.cod_abi = p_cod_abi
               AND st.cod_ndg = p_cod_ndg
               AND st.cod_protocollo_delibera = p_proto_delibera
               AND st.cod_rapporto = p_cod_rapporto
               AND (st.cod_forma_tecnica = p_ftecnica OR p_ftecnica = '-');
        END;
    END;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            utente);

   p_note := 'AGGIORNAMENTO DELLA DELIBERA '||p_proto_delibera || 'CON I VALORI AGGREGATI SUI RAPPORTI';
    ----AGGIORNA SUBITO I DATI AGGREGATI SULLA DELIBERA CORRISPONDENTE NELLA TABELLA DELIBERE
    /*calcolo dalle stime effettuate i valori aggregati da aggiornare sulla delibera corrispondente*/

    BEGIN
        UPDATE t_mcrei_app_delibere dd
       SET (dd.val_perc_rdv,
             dd.val_rdv_qc_deliberata,
             val_rdv_qc_progressiva,
             ----indica la rdv tot di cassa
             dd.val_rdv_progr_fi,
             dd.val_esp_lorda,
             val_accordato,
             val_esp_netta_post_delib,
             val_esp_lorda_capitale,
             val_esp_lorda_mora,
             val_esp_tot_cassa,
             val_uti_cassa_scsb,
             dd.val_esp_firma,
             dd.val_uti_firma_scsb,
             dd.val_uti_sosti_scsb,
             dd.val_uti_tot_scsb,
                         dd.dta_upd) =
             (SELECT CASE
                   WHEN (nvl(val_esp_lorda, 0) + nvl(val_utilizzato_firma, 0)) = 0 THEN
                    100
                   WHEN ((nvl(val_rdv_qc_progressiva, 0) +
                        nvl(val_rdv_progr_fi, 0)) * 100) = 0 THEN
                    100
                   ELSE
                    round((((nvl(val_rdv_qc_progressiva, 0) +
                    nvl(val_rdv_progr_fi, 0)) * 100) / (nvl(val_esp_lorda, 0) +
                    nvl(val_utilizzato_firma, 0))),2)--20 luglio
                 END  AS perc_rdv,
                     (rdv_qc_deliberata - dd.val_rdv_qc_ante_delib),
                     val_rdv_qc_progressiva,
                     val_rdv_progr_fi,
                     val_esp_lorda,
                     val_accordato_delib,
                     val_esp_netta_post_delib,
                     val_esp_lorda_capitale,
                     val_esp_lorda_mora,
                     val_utilizzato_lordo,
                     val_utilizzato_cassa,
                     val_utilizzato_firm,
                     val_utilizzato_firma,
                     val_utilizzato_sosti,
                     uti_tot,
                                         SYSDATE
                FROM (SELECT DISTINCT (SUM(val_rett_cassa_qta_cap)
                                        over(PARTITION BY rapp.cod_abi,
                                             rapp.cod_ndg,
                                             rapp.cod_protocollo_delibera)) AS rdv_qc_deliberata,
                                       ---9 maggio :rdv_qc_deliberata
                                       SUM(val_rett_cassa_qta_cap) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_rdv_qc_progressiva,
                                       SUM(val_rdv_firma) over(PARTITION BY rapp. cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_rdv_progr_fi,
                                       SUM(val_utilizzato_lordo) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_lorda,
                                       SUM(val_accordato_delib) over(PARTITION BY rapp. cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_accordato_delib,
                                       --29 marzo
                                       SUM(nvl(val_utilizzato_lordo, 0) -
                                           nvl(val_rett_cassa_qta_cap, 0) -
                                           nvl(val_utilizzato_mora, 0)) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_netta_post_delib,
                                       SUM((nvl(val_utilizzato_lordo, 0) -
                                           nvl(val_utilizzato_mora, 0))) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_lorda_capitale,
                                       SUM(nvl(val_utilizzato_mora, 0)) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_lorda_mora,
                                       SUM(nvl(val_utilizzato_lordo, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_lordo,
                                       SUM(nvl(val_utilizzato_lordo, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_cassa,
                                       SUM(nvl(val_utilizzato_firma, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_firm,
                                       SUM(nvl(val_utilizzato_firma, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_firma,
                                       SUM(nvl(val_utilizzato_sosti, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_sosti,
                                       SUM(nvl(val_utilizzato_lordo, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) + SUM(nvl(val_utilizzato_firma, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS uti_tot
                         FROM (SELECT DISTINCT pcr.cod_abi,
                                                pcr.cod_ndg,
                                                dta_stima,
                                                pcr.cod_protocollo_delibera AS cod_protocollo_delibera,
                                                pcr.cod_rapporto,
                                                pcr.cod_classe_ft AS cod_tipo_rapporto,
                                                pcr.cod_rapporto AS val_num_rapporto,
                                                pcr.val_accordato_delib,
                                                nat.cod_ftecnica || ' ' ||
                                                nat.desc_ftecnica AS val_forma_tecnica,
                                                decode(pcr.cod_classe_ft,
                                                       'CA',
                                                       nvl(st.val_esposizione,
                                                           pcr.val_imp_utilizzato
                                                           /*+ NVL (i.val_imp_mora, 0)*/),
                                                       0) AS val_utilizzato_lordo,

                                                ---in pcr l'utilizzato e' gia' comprensivo di mora
                                             decode(pcr.cod_classe_ft,
                                                    'FI',
                                                    nvl(st.val_esposizione,
                                                        pcr.val_imp_utilizzato),
                                                    0) AS val_utilizzato_firma,
                                             decode(pcr.cod_classe_ft,
                                                    'ST',
                                                    nvl(st.val_esposizione,
                                                        pcr.val_imp_utilizzato),
                                                    0) AS val_utilizzato_sosti,
                                             decode(pcr.cod_classe_ft,
                                                    'CA',
                                                    nvl(st.val_esposizione,
                                                        pcr.val_imp_utilizzato),
                                                    -nvl(i.val_imp_mora, 0),
                                                    0) AS val_utilizzato_netto,
                                             nvl(i.val_imp_mora, 0) AS val_utilizzato_mora,
                                             st.flg_tipo_dato AS cod_operat_rientro,
                                             nvl(st.flg_ristrutturato,
                                                 ra.flg_ristrutturato) AS flg_ristrutt,
                                             st.flg_recupero_tot,
                                             st.val_rdv_tot AS val_rettifica_livello_rapporto,
                                             --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                                             st.val_prev_recupero AS val_stima_di_rec,
                                             --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                                             'N' AS flg_storico,
                                             ----verificare
                                             decode(nat.cod_natura,
                                                    '01',
                                                    'BR',
                                                    '02',
                                                    'MLT') AS val_intervallo,
                                             decode(st.flg_tipo_dato,
                                                    'R',
                                                    st.val_rdv_tot,
                                                    0) AS val_rdv_rapp_operativi,
                                             decode(pcr.cod_classe_ft,
                                                    'CA',
                                                    val_rdv_tot,
                                                    0) AS val_rett_cassa_qta_cap,
                                             decode(pcr.cod_classe_ft,
                                                    'FI',
                                                    val_rdv_tot,
                                                    0) AS val_rdv_firma,
                                             decode(pcr.cod_classe_ft,
                                                    'CA',
                                                    st.val_imp_rettifica_pregr,
                                                    0) AS val_rdv_pregr_cassa,
                                             decode(pcr.cod_classe_ft,
                                                    'FI',
                                                    st.val_imp_rettifica_pregr,
                                                    0) AS val_rdv_pregr_firma,
                                             ra.flg_fondo_terzi,
                                             pcr.cod_protocollo_pacchetto AS cod_prot_pacchetto,
                                             st.val_perc_rett_rapporto AS val_percentuale,
                                             st.val_imp_prev_pregr,
                                             st.val_imp_rettifica_pregr,
                                             st.val_rdv_tot,
                                             st.val_imp_rettifica_att,
                                             nvl(pcr.val_imp_utilizzato, 0) -
                                             (((100 - ra.val_perc_fondo_terzi) *
                                              nvl(pcr.val_imp_utilizzato, 0)) / 100) AS fondo_terzi,
                                             decode(st.cod_protocollo_delibera,
                                                    NULL,
                                                    1,
                                                    (rank()
                                                     over(PARTITION BY st.cod_abi,
                                                          st.cod_ndg,
                                                          st.cod_protocollo_delibera,
                                                          st.cod_rapporto,
                                                          st.cod_forma_tecnica
                                                          ORDER BY st.dta_stima DESC))) rn
                               FROM t_mcrei_app_stime st,
                                    (SELECT DISTINCT dd.cod_abi,
                                                     dd.cod_ndg,
                                                     pc.cod_rapporto,
                                                     dd.cod_protocollo_delibera,
                                                     decode((COUNT(DISTINCT
                                                                   cod_forma_tecnica)
                                                             over(PARTITION BY
                                                                  pc.cod_abi,
                                                                  pc.cod_ndg,
                                                                  pc.cod_rapporto,
                                                                  f.cod_natura)),
                                                            1,
                                                            cod_forma_tecnica,
                                                            '-') AS cod_forma_tecnica,
                                                     f.cod_natura,

                                                     --01= CASSA BT, 02= CASSA VMLT
                                                     SUM(pc.val_imp_utilizzato) over(PARTITION BY pc.cod_abi, pc.cod_ndg, pc.cod_rapporto, f.cod_natura) AS val_imp_utilizzato,
                                                     SUM(pc.val_accordato_delib) over(PARTITION BY pc.cod_abi, pc.cod_ndg, pc.cod_rapporto, f.cod_natura) AS val_accordato_delib,
                                                     cod_protocollo_pacchetto,
                                                     cod_classe_ft,
                                                     dd.dta_efficacia_ristr,

                                                     --30 APRILE PER GESTIONE RISTRUTTURATI
                                                     dd.dta_efficacia_add
                                       FROM t_mcrei_app_delibere        dd,
                                            t_mcrei_app_pcr_rapporti    pc,
                                            t_mcre0_app_natura_ftecnica f
                                      WHERE dd.cod_abi = pc.cod_abi
                                        AND dd.cod_ndg = pc.cod_ndg
                                        AND dd.flg_attiva = '1'
                                        AND pc.cod_classe_ft IN
                                            ('CA', 'FI', 'ST')
                                           ----7/3
                                        AND dd.cod_abi = p_cod_abi
                                        AND dd.cod_ndg = p_cod_ndg
                                        AND dd.cod_protocollo_delibera =
                                            p_proto_delibera
                                        AND cod_forma_tecnica = f.cod_ftecnica) pcr,
                                    t_mcre0_app_natura_ftecnica nat,
                                    t_mcre0_app_rate_daily i,
                                    ----a livello di rapporti
                                    t_mcrei_app_rapporti ra
                              WHERE
                             /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA                                                                                                                                                                                                                                           BEGIN dbms_application_info.set_client_info( abi||ndg||cod_protocollo_delibera ); END;*/
                              pcr.cod_abi = st.cod_abi(+)
                           AND pcr.cod_ndg = st.cod_ndg(+)
                           AND pcr.cod_rapporto = st.cod_rapporto(+)
                           AND pcr.cod_protocollo_delibera =
                              st.cod_protocollo_delibera(+)
                           AND st.flg_attiva(+) = '1'
                           AND pcr.cod_abi = i.cod_abi_cartolarizzato(+)
                           AND pcr.cod_ndg = i.cod_ndg(+)
                           AND pcr.cod_rapporto = i.cod_rapporto(+)
                           AND pcr.cod_abi = ra.cod_abi(+)
                           AND pcr.cod_ndg = ra.cod_ndg(+)
                           AND pcr.cod_rapporto = ra.cod_rapporto(+)
                             --29 marzo
                           AND ra.flg_attiva(+) = '1'
                           AND pcr.cod_forma_tecnica = nat.cod_ftecnica) rapp))
     WHERE dd.cod_protocollo_delibera = p_proto_delibera
       AND dd.cod_abi = p_cod_abi
       AND dd.cod_ndg = p_cod_ndg;

         EXCEPTION WHEN OTHERS
             THEN
                 ----non salva la percentuale
             UPDATE t_mcrei_app_delibere dd
       SET (dd.val_perc_rdv,
             dd.val_rdv_qc_deliberata,
             val_rdv_qc_progressiva,
             ----indica la rdv tot di cassa
             dd.val_rdv_progr_fi,
             dd.val_esp_lorda,
             val_accordato,
             val_esp_netta_post_delib,
             val_esp_lorda_capitale,
             val_esp_lorda_mora,
             val_esp_tot_cassa,
             val_uti_cassa_scsb,
             dd.val_esp_firma,
             dd.val_uti_firma_scsb,
             dd.val_uti_sosti_scsb,
             dd.val_uti_tot_scsb) =
             (SELECT NULL  AS perc_rdv,
                     (rdv_qc_deliberata - dd.val_rdv_qc_ante_delib),
                     val_rdv_qc_progressiva,
                     val_rdv_progr_fi,
                     val_esp_lorda,
                     val_accordato_delib,
                     val_esp_netta_post_delib,
                     val_esp_lorda_capitale,
                     val_esp_lorda_mora,
                     val_utilizzato_lordo,
                     val_utilizzato_cassa,
                     val_utilizzato_firm,
                     val_utilizzato_firma,
                     val_utilizzato_sosti,
                     uti_tot
                FROM (SELECT DISTINCT (SUM(val_rett_cassa_qta_cap)
                                        over(PARTITION BY rapp.cod_abi,
                                             rapp.cod_ndg,
                                             rapp.cod_protocollo_delibera)) AS rdv_qc_deliberata,
                                       ---9 maggio :rdv_qc_deliberata
                                       SUM(val_rett_cassa_qta_cap) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_rdv_qc_progressiva,
                                       SUM(val_rdv_firma) over(PARTITION BY rapp. cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_rdv_progr_fi,
                                       SUM(val_utilizzato_lordo) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_lorda,
                                       SUM(val_accordato_delib) over(PARTITION BY rapp. cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_accordato_delib,
                                       --29 marzo
                                       SUM(nvl(val_utilizzato_lordo, 0) -
                                           nvl(val_rett_cassa_qta_cap, 0) -
                                           nvl(val_utilizzato_mora, 0)) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_netta_post_delib,
                                       SUM((nvl(val_utilizzato_lordo, 0) -
                                           nvl(val_utilizzato_mora, 0))) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_lorda_capitale,
                                       SUM(nvl(val_utilizzato_mora, 0)) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_lorda_mora,
                                       SUM(nvl(val_utilizzato_lordo, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_lordo,
                                       SUM(nvl(val_utilizzato_lordo, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_cassa,
                                       SUM(nvl(val_utilizzato_firma, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_firm,
                                       SUM(nvl(val_utilizzato_firma, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_firma,
                                       SUM(nvl(val_utilizzato_sosti, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_sosti,
                                       SUM(nvl(val_utilizzato_lordo, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) + SUM(nvl(val_utilizzato_firma, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS uti_tot
                         FROM (SELECT DISTINCT pcr.cod_abi,
                                                pcr.cod_ndg,
                                                dta_stima,
                                                pcr.cod_protocollo_delibera AS cod_protocollo_delibera,
                                                pcr.cod_rapporto,
                                                pcr.cod_classe_ft AS cod_tipo_rapporto,
                                                pcr.cod_rapporto AS val_num_rapporto,
                                                pcr.val_accordato_delib,
                                                nat.cod_ftecnica || ' ' ||
                                                nat.desc_ftecnica AS val_forma_tecnica,
                                                decode(pcr.cod_classe_ft,
                                                       'CA',
                                                       nvl(st.val_esposizione,
                                                           pcr.val_imp_utilizzato
                                                           /*+ NVL (i.val_imp_mora, 0)*/),
                                                       0) AS val_utilizzato_lordo,

                                                ---in pcr l'utilizzato e' gia' comprensivo di mora
                                             decode(pcr.cod_classe_ft,
                                                    'FI',
                                                    nvl(st.val_esposizione,
                                                        pcr.val_imp_utilizzato),
                                                    0) AS val_utilizzato_firma,
                                             decode(pcr.cod_classe_ft,
                                                    'ST',
                                                    nvl(st.val_esposizione,
                                                        pcr.val_imp_utilizzato),
                                                    0) AS val_utilizzato_sosti,
                                             decode(pcr.cod_classe_ft,
                                                    'CA',
                                                    nvl(st.val_esposizione,
                                                        pcr.val_imp_utilizzato),
                                                    -nvl(i.val_imp_mora, 0),
                                                    0) AS val_utilizzato_netto,
                                             nvl(i.val_imp_mora, 0) AS val_utilizzato_mora,
                                             st.flg_tipo_dato AS cod_operat_rientro,
                                             nvl(st.flg_ristrutturato,
                                                 ra.flg_ristrutturato) AS flg_ristrutt,
                                             st.flg_recupero_tot,
                                             st.val_rdv_tot AS val_rettifica_livello_rapporto,

                                             --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                                             st.val_prev_recupero AS val_stima_di_rec,

                                             --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                                             'N' AS flg_storico,

                                             ----verificare
                                             decode(nat.cod_natura,
                                                    '01',
                                                    'BR',
                                                    '02',
                                                    'MLT') AS val_intervallo,
                                             decode(st.flg_tipo_dato,
                                                    'R',
                                                    st.val_rdv_tot,
                                                    0) AS val_rdv_rapp_operativi,
                                             decode(pcr.cod_classe_ft,
                                                    'CA',
                                                    val_rdv_tot,
                                                    0) AS val_rett_cassa_qta_cap,
                                             decode(pcr.cod_classe_ft,
                                                    'FI',
                                                    val_rdv_tot,
                                                    0) AS val_rdv_firma,
                                             decode(pcr.cod_classe_ft,
                                                    'CA',
                                                    st.val_imp_rettifica_pregr,
                                                    0) AS val_rdv_pregr_cassa,
                                             decode(pcr.cod_classe_ft,
                                                    'FI',
                                                    st.val_imp_rettifica_pregr,
                                                    0) AS val_rdv_pregr_firma,
                                             ra.flg_fondo_terzi,
                                             pcr.cod_protocollo_pacchetto AS cod_prot_pacchetto,
                                             st.val_perc_rett_rapporto AS val_percentuale,
                                             st.val_imp_prev_pregr,
                                             st.val_imp_rettifica_pregr,
                                             st.val_rdv_tot,
                                             st.val_imp_rettifica_att,
                                             nvl(pcr.val_imp_utilizzato, 0) -
                                             (((100 - ra.val_perc_fondo_terzi) *
                                              nvl(pcr.val_imp_utilizzato, 0)) / 100) AS fondo_terzi,
                                             decode(st.cod_protocollo_delibera,
                                                    NULL,
                                                    1,
                                                    (rank()
                                                     over(PARTITION BY st.cod_abi,
                                                          st.cod_ndg,
                                                          st.cod_protocollo_delibera,
                                                          st.cod_rapporto,
                                                          st.cod_forma_tecnica
                                                          ORDER BY st.dta_stima DESC))) rn
                               FROM t_mcrei_app_stime st,
                                    (SELECT DISTINCT dd.cod_abi,
                                                     dd.cod_ndg,
                                                     pc.cod_rapporto,
                                                     dd.cod_protocollo_delibera,
                                                     decode((COUNT(DISTINCT
                                                                   cod_forma_tecnica)
                                                             over(PARTITION BY
                                                                  pc.cod_abi,
                                                                  pc.cod_ndg,
                                                                  pc.cod_rapporto,
                                                                  f.cod_natura)),
                                                            1,
                                                            cod_forma_tecnica,
                                                            '-') AS cod_forma_tecnica,
                                                     f.cod_natura,

                                                     --01= CASSA BT, 02= CASSA VMLT
                                                     SUM(pc.val_imp_utilizzato) over(PARTITION BY pc.cod_abi, pc.cod_ndg, pc.cod_rapporto, f.cod_natura) AS val_imp_utilizzato,
                                                     SUM(pc.val_accordato_delib) over(PARTITION BY pc.cod_abi, pc.cod_ndg, pc.cod_rapporto, f.cod_natura) AS val_accordato_delib,
                                                     cod_protocollo_pacchetto,
                                                     cod_classe_ft,
                                                     dd.dta_efficacia_ristr,

                                                     --30 APRILE PER GESTIONE RISTRUTTURATI
                                                     dd.dta_efficacia_add
                                       FROM t_mcrei_app_delibere        dd,
                                            t_mcrei_app_pcr_rapporti    pc,
                                            t_mcre0_app_natura_ftecnica f
                                      WHERE dd.cod_abi = pc.cod_abi
                                        AND dd.cod_ndg = pc.cod_ndg
                                        AND dd.flg_attiva = '1'
                                        AND pc.cod_classe_ft IN
                                            ('CA', 'FI', 'ST')
                                           ----7/3
                                        AND dd.cod_abi = p_cod_abi
                                        AND dd.cod_ndg = p_cod_ndg
                                        AND dd.cod_protocollo_delibera =
                                            p_proto_delibera
                                        AND cod_forma_tecnica = f.cod_ftecnica) pcr,
                                    t_mcre0_app_natura_ftecnica nat,
                                    t_mcre0_app_rate_daily i,
                                    ----a livello di rapporti
                                    t_mcrei_app_rapporti ra
                              WHERE
                             /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA                                                                                                                                                                                                                                           BEGIN dbms_application_info.set_client_info( abi||ndg||cod_protocollo_delibera ); END;*/
                              pcr.cod_abi = st.cod_abi(+)
                           AND pcr.cod_ndg = st.cod_ndg(+)
                           AND pcr.cod_rapporto = st.cod_rapporto(+)
                           AND pcr.cod_protocollo_delibera =
                              st.cod_protocollo_delibera(+)
                           AND st.flg_attiva(+) = '1'
                           AND pcr.cod_abi = i.cod_abi_cartolarizzato(+)
                           AND pcr.cod_ndg = i.cod_ndg(+)
                           AND pcr.cod_rapporto = i.cod_rapporto(+)
                           AND pcr.cod_abi = ra.cod_abi(+)
                           AND pcr.cod_ndg = ra.cod_ndg(+)
                           AND pcr.cod_rapporto = ra.cod_rapporto(+)
                             --29 marzo
                           AND ra.flg_attiva(+) = '1'
                           AND pcr.cod_forma_tecnica = nat.cod_ftecnica) rapp))
     WHERE dd.cod_protocollo_delibera = p_proto_delibera
       AND dd.cod_abi = p_cod_abi
       AND dd.cod_ndg = p_cod_ndg;

             ROLLBACK;
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);

            RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
             END;


    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              utente);

      IF SQLCODE = -20666
      THEN
        raise_application_error(-20666,
                                'Null parameter: COD_ABI OR COD_NDG OR COD_PROTOCOLLO_DELIBERA
             OR COD_RAPPORTO');
      END IF;

      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_dett_rapp_rv;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE congela in tabella I CAMPI INSERITI MANUALMENTE DELLE DELIBERE DI RDV
  -- %D LA FUNCTION, PER OGNI ABI, NDG, PROTOCOLLO DI DELIBERA E PROTOCOLLO_PACCHETTO IN INPUT,
  -- %D AGGIORNA GLI ATTRIBUTI CORRISPONDENTI CON
  -- %D I VALORI PASSATI IN INPUT
  -- %CD 10 FEB 2012
  FUNCTION popola_dett_rapp_rv(p_proto_delibera    IN t_mcrei_app_stime. cod_protocollo_delibera%TYPE,
                               p_cod_tipo_rapporto IN t_mcrei_app_stime. cod_tipo_rapporto%TYPE,
                               ---> STIME.COD_TIPO_RAPPORTO (ATTRIBUTO_RAPPORTO DA PCR) EQUIVALENTE A COD_CLASSE_FT
                               p_cod_rapporto          IN t_mcrei_app_stime. cod_rapporto%TYPE,
                               p_val_forma_tecnica     IN VARCHAR2,
                               p_val_utilizzato_lordo  IN t_mcrei_app_stime. val_esposizione%TYPE,
                               p_val_utilizzato_mora   IN t_mcrei_app_stime. val_utilizzato_mora%TYPE,
                               p_val_utilizzato_netto  IN t_mcrei_app_stime. val_utilizzato_netto%TYPE,
                               p_val_utilizzato_firma  IN t_mcrei_app_stime. val_utilizzato_netto%TYPE,
                               p_cod_operat_rientro    IN t_mcrei_app_stime. flg_tipo_dato%TYPE,
                               p_flg_ristrutt          IN t_mcrei_app_stime. flg_ristrutturato%TYPE,
                               p_flg_recupero_tot      IN t_mcrei_app_stime. flg_recupero_tot%TYPE,
                               p_val_rett_liv_rapporto IN t_mcrei_app_stime. val_imp_rettifica_att%TYPE,
                               p_val_stima_di_rec      IN t_mcrei_app_stime. val_prev_recupero%TYPE,
                               p_flg_storico           IN VARCHAR2,
                               p_cod_abi               IN t_mcrei_app_stime. cod_abi%TYPE,
                               p_cod_ndg               IN t_mcrei_app_stime. cod_ndg%TYPE,
                               p_val_intervallo        IN VARCHAR2,
                               -- CAMPO RECUPERATO DA PCR A LIVELLO VISTA
                               p_flg_fondo_terzi IN VARCHAR2,
                               -- RECUPERATO DA DELIBERE
                               p_proto_pacchetto IN VARCHAR2,
                               -- NON SALVATO
                               p_val_rett_effettuata IN t_mcrei_app_stime. val_imp_rettifica_att%TYPE,
                               p_val_percentuale     IN t_mcrei_app_stime. val_perc_rett_rapporto%TYPE,
                               utente                IN t_mcrei_app_stime. cod_utente%TYPE,
                               p_ftecnica            VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_DETT_RAPP_RV ';
    p_note     t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_accord   t_mcrei_app_stime.val_accordato%TYPE;
    v_tipo_del VARCHAR2(5);
  BEGIN
    p_note := 'POPOLA_DETT_RAPP_RV: controllo parametri in input ' ||
              p_cod_abi || ', ' || p_cod_ndg || ', PROTO PACCHETTO:' ||
              p_proto_pacchetto || ', PROTO DELIBERA:' || p_proto_delibera ||
              ', TIPO RAPPORTO:' || p_cod_tipo_rapporto || 'COD_RAPPORTO:' ||
              p_cod_rapporto;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_cod_rapporto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'update T_MCREI_APP_STIME popola dati stime ' || p_cod_abi || ', ' ||
              p_cod_ndg || ', PROTO PACCHETTO:' || p_proto_pacchetto ||
              ', PROTO DELIBERA:' || p_proto_delibera || ', TIPO RAPPORTO:' ||
              p_cod_tipo_rapporto || ', COD_RAPPORTO:' || p_cod_rapporto ||
              ',FLG_RECUPERO_TOT: ' || p_flg_recupero_tot ||
              ', VAL_RETT_LIV_RAPPORTO: ' || p_val_rett_liv_rapporto ||
              ', VAL_STIMA_DI_REC: ' || p_val_stima_di_rec;

    BEGIN
      SELECT DISTINCT SUM(val_accordato_delib) over(PARTITION BY i.cod_abi, i. cod_ndg, i.cod_rapporto) AS val_accordato_delib,
                      cod_microtipologia_delibera
        INTO v_accord,
             v_tipo_del
        FROM t_mcrei_app_stime        tt,
             t_mcrei_app_pcr_rapporti i
       WHERE tt.cod_abi = i.cod_abi
         AND tt.cod_ndg = i.cod_ndg
         AND tt.cod_rapporto = i.cod_rapporto
         AND tt.cod_abi = p_cod_abi
         AND tt.cod_ndg = p_cod_ndg
         AND tt.cod_protocollo_delibera = p_proto_delibera
         AND tt.cod_rapporto = p_cod_rapporto
         AND tt.flg_tipo_dato = p_cod_operat_rientro
         AND i.cod_classe_ft = nvl(tt.cod_classe_ft, i.cod_classe_ft);

    EXCEPTION
      WHEN no_data_found THEN
        v_accord   := 0;
        v_tipo_del := '?';
    END;

    UPDATE t_mcrei_app_stime t
       SET t.cod_tipo_rapporto = p_cod_tipo_rapporto,
           t.cod_forma_tecnica = p_ftecnica,
           t.dta_stima         = trunc(SYSDATE), ----- 25 MAGGIO: AGGIORNO LA DATA AL MOMENTO DEL CONGELAMENTO
           -- 23 aprile (per gestire rapporti con 2 FT diverse)
           t.val_esposizione      = decode(t.cod_classe_ft,
                                           'FI',
                                           p_val_utilizzato_firma,
                                           p_val_utilizzato_lordo),
           t.val_utilizzato_mora  = p_val_utilizzato_mora,
           t.val_utilizzato_netto = p_val_utilizzato_netto,
           --          t.flg_tipo_dato           = p_cod_operat_rientro,
           t.flg_ristrutturato = p_flg_ristrutt,
           t.flg_recupero_tot  = p_flg_recupero_tot,
           ---nuova logica:
           t.val_prev_recupero = p_val_stima_di_rec,
           t.val_rdv_tot       = decode(p_cod_tipo_rapporto,
                                        'CA',
                                        p_val_rett_effettuata,
                                        'FI',
                                        p_val_rett_liv_rapporto,
                                        nvl(p_val_rett_effettuata,
                                            p_val_rett_liv_rapporto)),
           --RETTIFICA PROGRESSIVA
           t.val_imp_prev_att      =
           (p_val_stima_di_rec - t.val_imp_prev_pregr),
           t.val_imp_rettifica_att =
           (decode(p_cod_tipo_rapporto,
                   'CA',
                   p_val_rett_effettuata,
                   'FI',
                   p_val_rett_liv_rapporto,
                   nvl(p_val_rett_effettuata, p_val_rett_liv_rapporto)) -
           t.val_imp_rettifica_pregr),
           t.val_perc_rett_rapporto = p_val_percentuale,
           t.cod_utente             = utente,
           t.dta_upd                = SYSDATE,
           t.val_accordato          = v_accord
     WHERE t.cod_abi = p_cod_abi
       AND t.cod_ndg = p_cod_ndg
       AND t.cod_protocollo_delibera = p_proto_delibera
       AND t.cod_rapporto = p_cod_rapporto
       AND (t.cod_forma_tecnica = p_ftecnica OR p_ftecnica = '-');

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);

    p_note := 'AGGIORNAMENTO DELLA DELIBERA '||p_proto_delibera || 'CON I VALORI AGGREGATI SUI RAPPORTI';
        ----AGGIORNA SUBITO I DATI AGGREGATI SULLA DELIBERA CORRISPONDENTE NELLA TABELLA DELIBERE
    /*calcolo dalle stime effettuate i valori aggregati da aggiornare sulla delibera corrispondente*/

        BEGIN
        UPDATE t_mcrei_app_delibere dd
       SET (dd.val_perc_rdv,
             dd.val_rdv_qc_deliberata,
             val_rdv_qc_progressiva,
             ----indica la rdv tot di cassa
             dd.val_rdv_progr_fi,
             dd.val_esp_lorda,
             val_accordato,
             val_esp_netta_post_delib,
             val_esp_lorda_capitale,
             val_esp_lorda_mora,
             val_esp_tot_cassa,
             val_uti_cassa_scsb,
             dd.val_esp_firma,
             dd.val_uti_firma_scsb,
             dd.val_uti_sosti_scsb,
             dd.val_uti_tot_scsb,
                         dd.dta_upd) =
             (SELECT CASE
                   WHEN (nvl(val_esp_lorda, 0) + nvl(val_utilizzato_firma, 0)) = 0 THEN
                    100
                   WHEN ((nvl(val_rdv_qc_progressiva, 0) +
                        nvl(val_rdv_progr_fi, 0)) * 100) = 0 THEN
                    100
                   ELSE
                    round((((nvl(val_rdv_qc_progressiva, 0) +
                    nvl(val_rdv_progr_fi, 0)) * 100) / (nvl(val_esp_lorda, 0) +
                    nvl(val_utilizzato_firma, 0))),2)--27 luglio
                 END AS perc_rdv,
                     (rdv_qc_deliberata - dd.val_rdv_qc_ante_delib),
                     val_rdv_qc_progressiva,
                     val_rdv_progr_fi,
                     val_esp_lorda,
                     val_accordato_delib,
                     val_esp_netta_post_delib,
                     val_esp_lorda_capitale,
                     val_esp_lorda_mora,
                     val_utilizzato_lordo,
                     val_utilizzato_cassa,
                     val_utilizzato_firm,
                     val_utilizzato_firma,
                     val_utilizzato_sosti,
                     uti_tot,
                                         SYSDATE
                FROM (SELECT DISTINCT (SUM(val_rett_cassa_qta_cap)
                                        over(PARTITION BY rapp.cod_abi,
                                             rapp.cod_ndg,
                                             rapp.cod_protocollo_delibera)) AS rdv_qc_deliberata,
                                       ---9 maggio :rdv_qc_deliberata
                                       SUM(val_rett_cassa_qta_cap) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_rdv_qc_progressiva,
                                       SUM(val_rdv_firma) over(PARTITION BY rapp. cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_rdv_progr_fi,
                                       SUM(val_utilizzato_lordo) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_lorda,
                                       SUM(val_accordato_delib) over(PARTITION BY rapp. cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_accordato_delib,
                                       --29 marzo
                                       SUM(nvl(val_utilizzato_lordo, 0) -
                                           nvl(val_rett_cassa_qta_cap, 0) -
                                           nvl(val_utilizzato_mora, 0)) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_netta_post_delib,
                                       SUM((nvl(val_utilizzato_lordo, 0) -
                                           nvl(val_utilizzato_mora, 0))) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_lorda_capitale,
                                       SUM(nvl(val_utilizzato_mora, 0)) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_lorda_mora,
                                       SUM(nvl(val_utilizzato_lordo, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_lordo,
                                       SUM(nvl(val_utilizzato_lordo, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_cassa,
                                       SUM(nvl(val_utilizzato_firma, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_firm,
                                       SUM(nvl(val_utilizzato_firma, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_firma,
                                       SUM(nvl(val_utilizzato_sosti, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_sosti,
                                       SUM(nvl(val_utilizzato_lordo, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) + SUM(nvl(val_utilizzato_firma, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS uti_tot
                         FROM (SELECT DISTINCT pcr.cod_abi,
                                                pcr.cod_ndg,
                                                dta_stima,
                                                pcr.cod_protocollo_delibera AS cod_protocollo_delibera,
                                                pcr.cod_rapporto,
                                                pcr.cod_classe_ft AS cod_tipo_rapporto,
                                                pcr.cod_rapporto AS val_num_rapporto,
                                                pcr.val_accordato_delib,
                                                nat.cod_ftecnica || ' ' ||
                                                nat.desc_ftecnica AS val_forma_tecnica,
                                                decode(pcr.cod_classe_ft,
                                                       'CA',
                                                       nvl(st.val_esposizione,
                                                           pcr.val_imp_utilizzato
                                                           /*+ NVL (i.val_imp_mora, 0)*/),
                                                       0) AS val_utilizzato_lordo,

                                                ---in pcr l'utilizzato e' gia' comprensivo di mora
                                             decode(pcr.cod_classe_ft,
                                                    'FI',
                                                    nvl(st.val_esposizione,
                                                        pcr.val_imp_utilizzato),
                                                    0) AS val_utilizzato_firma,
                                             decode(pcr.cod_classe_ft,
                                                    'ST',
                                                    nvl(st.val_esposizione,
                                                        pcr.val_imp_utilizzato),
                                                    0) AS val_utilizzato_sosti,
                                             decode(pcr.cod_classe_ft,
                                                    'CA',
                                                    nvl(st.val_esposizione,
                                                        pcr.val_imp_utilizzato),
                                                    -nvl(i.val_imp_mora, 0),
                                                    0) AS val_utilizzato_netto,
                                             nvl(i.val_imp_mora, 0) AS val_utilizzato_mora,
                                             st.flg_tipo_dato AS cod_operat_rientro,
                                             nvl(st.flg_ristrutturato,
                                                 ra.flg_ristrutturato) AS flg_ristrutt,
                                             st.flg_recupero_tot,
                                             st.val_rdv_tot AS val_rettifica_livello_rapporto,

                                             --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                                             st.val_prev_recupero AS val_stima_di_rec,

                                             --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                                             'N' AS flg_storico,

                                             ----verificare
                                             decode(nat.cod_natura,
                                                    '01',
                                                    'BR',
                                                    '02',
                                                    'MLT') AS val_intervallo,
                                             decode(st.flg_tipo_dato,
                                                    'R',
                                                    st.val_rdv_tot,
                                                    0) AS val_rdv_rapp_operativi,
                                             decode(pcr.cod_classe_ft,
                                                    'CA',
                                                    val_rdv_tot,
                                                    0) AS val_rett_cassa_qta_cap,
                                             decode(pcr.cod_classe_ft,
                                                    'FI',
                                                    val_rdv_tot,
                                                    0) AS val_rdv_firma,
                                             decode(pcr.cod_classe_ft,
                                                    'CA',
                                                    st.val_imp_rettifica_pregr,
                                                    0) AS val_rdv_pregr_cassa,
                                             decode(pcr.cod_classe_ft,
                                                    'FI',
                                                    st.val_imp_rettifica_pregr,
                                                    0) AS val_rdv_pregr_firma,
                                             ra.flg_fondo_terzi,
                                             pcr.cod_protocollo_pacchetto AS cod_prot_pacchetto,
                                             st.val_perc_rett_rapporto AS val_percentuale,
                                             st.val_imp_prev_pregr,
                                             st.val_imp_rettifica_pregr,
                                             st.val_rdv_tot,
                                             st.val_imp_rettifica_att,
                                             nvl(pcr.val_imp_utilizzato, 0) -
                                             (((100 - ra.val_perc_fondo_terzi) *
                                              nvl(pcr.val_imp_utilizzato, 0)) / 100) AS fondo_terzi,
                                             decode(st.cod_protocollo_delibera,
                                                    NULL,
                                                    1,
                                                    (rank()
                                                     over(PARTITION BY st.cod_abi,
                                                          st.cod_ndg,
                                                          st.cod_protocollo_delibera,
                                                          st.cod_rapporto,
                                                          st.cod_forma_tecnica
                                                          ORDER BY st.dta_stima DESC))) rn
                               FROM t_mcrei_app_stime st,
                                    (SELECT DISTINCT dd.cod_abi,
                                                     dd.cod_ndg,
                                                     pc.cod_rapporto,
                                                     dd.cod_protocollo_delibera,
                                                     decode((COUNT(DISTINCT
                                                                   cod_forma_tecnica)
                                                             over(PARTITION BY
                                                                  pc.cod_abi,
                                                                  pc.cod_ndg,
                                                                  pc.cod_rapporto,
                                                                  f.cod_natura)),
                                                            1,
                                                            cod_forma_tecnica,
                                                            '-') AS cod_forma_tecnica,
                                                     f.cod_natura,

                                                     --01= CASSA BT, 02= CASSA VMLT
                                                     SUM(pc.val_imp_utilizzato) over(PARTITION BY pc.cod_abi, pc.cod_ndg, pc.cod_rapporto, f.cod_natura) AS val_imp_utilizzato,
                                                     SUM(pc.val_accordato_delib) over(PARTITION BY pc.cod_abi, pc.cod_ndg, pc.cod_rapporto, f.cod_natura) AS val_accordato_delib,
                                                     cod_protocollo_pacchetto,
                                                     cod_classe_ft,
                                                     dd.dta_efficacia_ristr,
                                                     --30 APRILE PER GESTIONE RISTRUTTURATI
                                                     dd.dta_efficacia_add
                                       FROM t_mcrei_app_delibere        dd,
                                            t_mcrei_app_pcr_rapporti    pc,
                                            t_mcre0_app_natura_ftecnica f
                                      WHERE dd.cod_abi = pc.cod_abi
                                        AND dd.cod_ndg = pc.cod_ndg
                                        AND dd.flg_attiva = '1'
                                        AND pc.cod_classe_ft IN
                                            ('CA', 'FI', 'ST')
                                           ----7/3
                                        AND dd.cod_abi = p_cod_abi
                                        AND dd.cod_ndg = p_cod_ndg
                                        AND dd.cod_protocollo_delibera =
                                            p_proto_delibera
                                        AND cod_forma_tecnica = f.cod_ftecnica) pcr,
                                    t_mcre0_app_natura_ftecnica nat,
                                    t_mcre0_app_rate_daily i,
                                    ----a livello di rapporti
                                    t_mcrei_app_rapporti ra
                              WHERE
                             /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA                                                                                                                                                                                                                                           BEGIN dbms_application_info.set_client_info( abi||ndg||cod_protocollo_delibera ); END;*/
                              pcr.cod_abi = st.cod_abi(+)
                           AND pcr.cod_ndg = st.cod_ndg(+)
                           AND pcr.cod_rapporto = st.cod_rapporto(+)
                           AND pcr.cod_protocollo_delibera =
                              st.cod_protocollo_delibera(+)
                           AND st.flg_attiva(+) = '1'
                           AND pcr.cod_abi = i.cod_abi_cartolarizzato(+)
                           AND pcr.cod_ndg = i.cod_ndg(+)
                           AND pcr.cod_rapporto = i.cod_rapporto(+)
                           AND pcr.cod_abi = ra.cod_abi(+)
                           AND pcr.cod_ndg = ra.cod_ndg(+)
                           AND pcr.cod_rapporto = ra.cod_rapporto(+)
                             --29 marzo
                           AND ra.flg_attiva(+) = '1'
                           AND pcr.cod_forma_tecnica = nat.cod_ftecnica) rapp))
     WHERE dd.cod_protocollo_delibera = p_proto_delibera
       AND dd.cod_abi = p_cod_abi
       AND dd.cod_ndg = p_cod_ndg;
    EXCEPTION WHEN OTHERS
             THEN
                     ----non salva la percentuale
             UPDATE t_mcrei_app_delibere dd
       SET (dd.val_perc_rdv,
             dd.val_rdv_qc_deliberata,
             val_rdv_qc_progressiva,
             ----indica la rdv tot di cassa
             dd.val_rdv_progr_fi,
             dd.val_esp_lorda,
             val_accordato,
             val_esp_netta_post_delib,
             val_esp_lorda_capitale,
             val_esp_lorda_mora,
             val_esp_tot_cassa,
             val_uti_cassa_scsb,
             dd.val_esp_firma,
             dd.val_uti_firma_scsb,
             dd.val_uti_sosti_scsb,
             dd.val_uti_tot_scsb) =
             (SELECT NULL  AS perc_rdv,
                     (rdv_qc_deliberata - dd.val_rdv_qc_ante_delib),
                     val_rdv_qc_progressiva,
                     val_rdv_progr_fi,
                     val_esp_lorda,
                     val_accordato_delib,
                     val_esp_netta_post_delib,
                     val_esp_lorda_capitale,
                     val_esp_lorda_mora,
                     val_utilizzato_lordo,
                     val_utilizzato_cassa,
                     val_utilizzato_firm,
                     val_utilizzato_firma,
                     val_utilizzato_sosti,
                     uti_tot
                FROM (SELECT DISTINCT (SUM(val_rett_cassa_qta_cap)
                                        over(PARTITION BY rapp.cod_abi,
                                             rapp.cod_ndg,
                                             rapp.cod_protocollo_delibera)) AS rdv_qc_deliberata,
                                       ---9 maggio :rdv_qc_deliberata
                                       SUM(val_rett_cassa_qta_cap) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_rdv_qc_progressiva,
                                       SUM(val_rdv_firma) over(PARTITION BY rapp. cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_rdv_progr_fi,
                                       SUM(val_utilizzato_lordo) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_lorda,
                                       SUM(val_accordato_delib) over(PARTITION BY rapp. cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_accordato_delib,
                                       --29 marzo
                                       SUM(nvl(val_utilizzato_lordo, 0) -
                                           nvl(val_rett_cassa_qta_cap, 0) -
                                           nvl(val_utilizzato_mora, 0)) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_netta_post_delib,
                                       SUM((nvl(val_utilizzato_lordo, 0) -
                                           nvl(val_utilizzato_mora, 0))) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_lorda_capitale,
                                       SUM(nvl(val_utilizzato_mora, 0)) over(PARTITION BY rapp.cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_esp_lorda_mora,
                                       SUM(nvl(val_utilizzato_lordo, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_lordo,
                                       SUM(nvl(val_utilizzato_lordo, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_cassa,
                                       SUM(nvl(val_utilizzato_firma, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_firm,
                                       SUM(nvl(val_utilizzato_firma, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_firma,
                                       SUM(nvl(val_utilizzato_sosti, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS val_utilizzato_sosti,
                                       SUM(nvl(val_utilizzato_lordo, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) + SUM(nvl(val_utilizzato_firma, 0)) over(PARTITION BY rapp .cod_abi, rapp.cod_ndg, rapp.cod_protocollo_delibera) AS uti_tot
                         FROM (SELECT DISTINCT pcr.cod_abi,
                                                pcr.cod_ndg,
                                                dta_stima,
                                                pcr.cod_protocollo_delibera AS cod_protocollo_delibera,
                                                pcr.cod_rapporto,
                                                pcr.cod_classe_ft AS cod_tipo_rapporto,
                                                pcr.cod_rapporto AS val_num_rapporto,
                                                pcr.val_accordato_delib,
                                                nat.cod_ftecnica || ' ' ||
                                                nat.desc_ftecnica AS val_forma_tecnica,
                                                decode(pcr.cod_classe_ft,
                                                       'CA',
                                                       nvl(st.val_esposizione,
                                                           pcr.val_imp_utilizzato
                                                           /*+ NVL (i.val_imp_mora, 0)*/),
                                                       0) AS val_utilizzato_lordo,

                                                ---in pcr l'utilizzato e' gia' comprensivo di mora
                                             decode(pcr.cod_classe_ft,
                                                    'FI',
                                                    nvl(st.val_esposizione,
                                                        pcr.val_imp_utilizzato),
                                                    0) AS val_utilizzato_firma,
                                             decode(pcr.cod_classe_ft,
                                                    'ST',
                                                    nvl(st.val_esposizione,
                                                        pcr.val_imp_utilizzato),
                                                    0) AS val_utilizzato_sosti,
                                             decode(pcr.cod_classe_ft,
                                                    'CA',
                                                    nvl(st.val_esposizione,
                                                        pcr.val_imp_utilizzato),
                                                    -nvl(i.val_imp_mora, 0),
                                                    0) AS val_utilizzato_netto,
                                             nvl(i.val_imp_mora, 0) AS val_utilizzato_mora,
                                             st.flg_tipo_dato AS cod_operat_rientro,
                                             nvl(st.flg_ristrutturato,
                                                 ra.flg_ristrutturato) AS flg_ristrutt,
                                             st.flg_recupero_tot,
                                             st.val_rdv_tot AS val_rettifica_livello_rapporto,

                                             --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                                             st.val_prev_recupero AS val_stima_di_rec,

                                             --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                                             'N' AS flg_storico,

                                             ----verificare
                                             decode(nat.cod_natura,
                                                    '01',
                                                    'BR',
                                                    '02',
                                                    'MLT') AS val_intervallo,
                                             decode(st.flg_tipo_dato,
                                                    'R',
                                                    st.val_rdv_tot,
                                                    0) AS val_rdv_rapp_operativi,
                                             decode(pcr.cod_classe_ft,
                                                    'CA',
                                                    val_rdv_tot,
                                                    0) AS val_rett_cassa_qta_cap,
                                             decode(pcr.cod_classe_ft,
                                                    'FI',
                                                    val_rdv_tot,
                                                    0) AS val_rdv_firma,
                                             decode(pcr.cod_classe_ft,
                                                    'CA',
                                                    st.val_imp_rettifica_pregr,
                                                    0) AS val_rdv_pregr_cassa,
                                             decode(pcr.cod_classe_ft,
                                                    'FI',
                                                    st.val_imp_rettifica_pregr,
                                                    0) AS val_rdv_pregr_firma,
                                             ra.flg_fondo_terzi,
                                             pcr.cod_protocollo_pacchetto AS cod_prot_pacchetto,
                                             st.val_perc_rett_rapporto AS val_percentuale,
                                             st.val_imp_prev_pregr,
                                             st.val_imp_rettifica_pregr,
                                             st.val_rdv_tot,
                                             st.val_imp_rettifica_att,
                                             nvl(pcr.val_imp_utilizzato, 0) -
                                             (((100 - ra.val_perc_fondo_terzi) *
                                              nvl(pcr.val_imp_utilizzato, 0)) / 100) AS fondo_terzi,
                                             decode(st.cod_protocollo_delibera,
                                                    NULL,
                                                    1,
                                                    (rank()
                                                     over(PARTITION BY st.cod_abi,
                                                          st.cod_ndg,
                                                          st.cod_protocollo_delibera,
                                                          st.cod_rapporto,
                                                          st.cod_forma_tecnica
                                                          ORDER BY st.dta_stima DESC))) rn
                               FROM t_mcrei_app_stime st,
                                    (SELECT DISTINCT dd.cod_abi,
                                                     dd.cod_ndg,
                                                     pc.cod_rapporto,
                                                     dd.cod_protocollo_delibera,
                                                     decode((COUNT(DISTINCT
                                                                   cod_forma_tecnica)
                                                             over(PARTITION BY
                                                                  pc.cod_abi,
                                                                  pc.cod_ndg,
                                                                  pc.cod_rapporto,
                                                                  f.cod_natura)),
                                                            1,
                                                            cod_forma_tecnica,
                                                            '-') AS cod_forma_tecnica,
                                                     f.cod_natura,

                                                     --01= CASSA BT, 02= CASSA VMLT
                                                     SUM(pc.val_imp_utilizzato) over(PARTITION BY pc.cod_abi, pc.cod_ndg, pc.cod_rapporto, f.cod_natura) AS val_imp_utilizzato,
                                                     SUM(pc.val_accordato_delib) over(PARTITION BY pc.cod_abi, pc.cod_ndg, pc.cod_rapporto, f.cod_natura) AS val_accordato_delib,
                                                     cod_protocollo_pacchetto,
                                                     cod_classe_ft,
                                                     dd.dta_efficacia_ristr,

                                                     --30 APRILE PER GESTIONE RISTRUTTURATI
                                                     dd.dta_efficacia_add
                                       FROM t_mcrei_app_delibere        dd,
                                            t_mcrei_app_pcr_rapporti    pc,
                                            t_mcre0_app_natura_ftecnica f
                                      WHERE dd.cod_abi = pc.cod_abi
                                        AND dd.cod_ndg = pc.cod_ndg
                                        AND dd.flg_attiva = '1'
                                        AND pc.cod_classe_ft IN
                                            ('CA', 'FI', 'ST')
                                           ----7/3
                                        AND dd.cod_abi = p_cod_abi
                                        AND dd.cod_ndg = p_cod_ndg
                                        AND dd.cod_protocollo_delibera =
                                            p_proto_delibera
                                        AND cod_forma_tecnica = f.cod_ftecnica) pcr,
                                    t_mcre0_app_natura_ftecnica nat,
                                    t_mcre0_app_rate_daily i,
                                    ----a livello di rapporti
                                    t_mcrei_app_rapporti ra
                              WHERE
                             /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA                                                                                                                                                                                                                                           BEGIN dbms_application_info.set_client_info( abi||ndg||cod_protocollo_delibera ); END;*/
                              pcr.cod_abi = st.cod_abi(+)
                           AND pcr.cod_ndg = st.cod_ndg(+)
                           AND pcr.cod_rapporto = st.cod_rapporto(+)
                           AND pcr.cod_protocollo_delibera =
                              st.cod_protocollo_delibera(+)
                           AND st.flg_attiva(+) = '1'
                           AND pcr.cod_abi = i.cod_abi_cartolarizzato(+)
                           AND pcr.cod_ndg = i.cod_ndg(+)
                           AND pcr.cod_rapporto = i.cod_rapporto(+)
                           AND pcr.cod_abi = ra.cod_abi(+)
                           AND pcr.cod_ndg = ra.cod_ndg(+)
                           AND pcr.cod_rapporto = ra.cod_rapporto(+)
                             --29 marzo
                           AND ra.flg_attiva(+) = '1'
                           AND pcr.cod_forma_tecnica = nat.cod_ftecnica) rapp))
     WHERE dd.cod_protocollo_delibera = p_proto_delibera
       AND dd.cod_abi = p_cod_abi
       AND dd.cod_ndg = p_cod_ndg;

             ROLLBACK;
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);

            RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
             END;


    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);

      IF SQLCODE = -20666
      THEN
        raise_application_error(-20666,
                                'Null parameter: COD_ABI OR COD_NDG OR COD_PROTOCOLLO_DELIBERA
             OR COD_RAPPORTO');
      END IF;

      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_dett_rapp_rv;


 FUNCTION popola_man_dett_dati_gen_rv(p_cod_abi            VARCHAR2,
                                       p_cod_ndg            VARCHAR2,
                                       p_cod_prot_delibera  VARCHAR2,
                                       p_cod_prot_pacchetto VARCHAR2,
                                       p_dta_scadenza       DATE,
                                       utente               VARCHAR2)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_MAN_DETT_DATI_GEN_RV';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri input' || p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_cod_prot_pacchetto || ', ' || p_cod_prot_delibera;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_cod_prot_pacchetto IS NULL OR
       p_cod_prot_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'POPOLA_MAN_DETT_DATI_GEN_RV: Salvataggio dati manuali delibera RDV ' ||
              p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_cod_prot_pacchetto || ', ' || p_cod_prot_delibera;

    UPDATE t_mcrei_app_delibere d
       SET d.dta_scadenza          = p_dta_scadenza,
           d.dta_last_upd_delibera = SYSDATE
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_delibera = p_cod_prot_delibera
       AND d.cod_protocollo_pacchetto = p_cod_prot_pacchetto;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_dett_dati_gen_rv;

  FUNCTION popola_tot_rett_da_spalmare(p_cod_abi            VARCHAR2,
                                       p_cod_ndg            VARCHAR2,
                                       p_cod_prot_delibera  VARCHAR2,
                                       p_cod_prot_pacchetto VARCHAR2,
                                       p_rettifica          NUMBER,
                                       p_box                VARCHAR2,
                                       utente               VARCHAR2,
                                       p_flg_archiviazione  VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_TOT_RETT_DA_SPALMARE';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri input' || p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_cod_prot_pacchetto || ', ' || p_cod_prot_delibera;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_cod_prot_pacchetto IS NULL OR
       p_cod_prot_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'POPOLA_TOT_RETT_DA_SPALMARE: Salvataggio RDV da spalmare su cassa e firma' ||
              p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_cod_prot_pacchetto || ', ' || p_cod_prot_delibera;

    IF p_box = 'CA'
    THEN
      UPDATE t_mcrei_app_delibere d
         SET d.val_rdv_rapp_operativi = p_rettifica
       WHERE d.cod_abi = p_cod_abi
         AND d.cod_ndg = p_cod_ndg
         AND d.cod_protocollo_delibera = p_cod_prot_delibera
         AND d.cod_protocollo_pacchetto = p_cod_prot_pacchetto;
    ELSE
      UPDATE t_mcrei_app_delibere d
         SET d.val_perc_rett_rapp_firma = p_rettifica
       WHERE d.cod_abi = p_cod_abi
         AND d.cod_ndg = p_cod_ndg
         AND d.cod_protocollo_delibera = p_cod_prot_delibera
         AND d.cod_protocollo_pacchetto = p_cod_prot_pacchetto;
    END IF;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_tot_rett_da_spalmare;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE congela i dati generali in fase di controllo dati
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
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.popola_dett_dati_gen_rv';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_note := 'Controllo parametri input' || p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_cod_prot_pacchetto || ', ' || p_cod_prot_delibera;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_cod_prot_pacchetto IS NULL OR
       p_cod_prot_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'popola_dett_dati_gen_rv: congelamento dati_gen_rv al controllo dati' ||
              p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_cod_prot_pacchetto || ', ' || p_cod_prot_delibera;

    UPDATE t_mcrei_app_delibere d
       SET val_esp_lorda          = nvl(p_val_esp_cassa_qta_cap, 0) +
                                    nvl(p_val_tot_interessi_di_mora, 0),
           val_uti_cassa_scsb     = p_val_esp_cassa_qta_cap,
           val_uti_firma_scsb     = p_val_esp_firma,
           val_esp_firma          = p_val_esp_firma,
           val_esp_lorda_capitale = p_val_esp_cassa_qta_cap,
           val_esp_tot_cassa      = p_val_esp_cassa_qta_cap,
           val_esp_lorda_mora     = p_val_tot_interessi_di_mora,
           val_uti_tot_scsb     = p_val_esp_complessiva_da_val, --(ca+ fi)
           val_imp_fondi_terzi    = p_val_tot_fondi_terzi,
           val_uti_sosti_scsb     = p_val_tot_derivati,
           val_rdv_qc_progressiva = p_val_rett_cassa_qta_cap,
           val_rdv_progr_fi       = p_val_rett_rapp_firma,
           dta_scadenza = p_dta_scadenza
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_delibera = p_cod_prot_delibera
       AND d.cod_protocollo_pacchetto = p_cod_prot_pacchetto;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            utente);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              utente);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_dett_dati_gen_rv;

  ------------GESTIONE PIANI -----------------
  FUNCTION popola_piano_rientro(
                                /*KEY*/p_cod_abi                 IN t_mcrei_app_piani_rientro.cod_abi%TYPE,
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
                                p_flg_archiviazione     IN VARCHAR DEFAULT NULL -- 'Y' in caso di archiviazione necessaria
                                ) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_PIANO_RIENTRO';
    p_note       t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_dta_update DATE;
    v_count      NUMBER;
  BEGIN
    v_dta_update := SYSDATE;
    p_note       := 'T_MCREI_APP_PIANI_RIENTRO controllo parametri';

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_cod_sndg IS NULL OR
       p_cod_protocollo_delibera IS NULL OR
       p_cod_rapporto IS NULL OR
       p_cod_num_rata IS NULL OR
       p_dta_scadenza_rata IS NULL OR
       p_val_rata IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'popola piani di rientro abi: ' || p_cod_abi || ' ndg: ' ||
              p_cod_ndg || ' del: ' || p_cod_protocollo_delibera ||
              ' p_cod_rapporto:' || p_cod_rapporto;

    INSERT INTO t_mcrei_app_piani_rientro
      (id_dper,
       cod_abi,
       cod_sndg,
       cod_ndg,
       cod_rapporto,
       dta_stima,
       num_rata,
       dta_scadenza_rata,
       val_rata,
       dta_ins_piano,
       dta_upd_piano,
       cod_utente,
       cod_protocollo_delibera,
       flg_attiva,
       dta_ins,
       dta_upd,
       cod_operatore_ins_upd,
       cod_forma_tecnica)
    VALUES
      (to_number(to_char(trunc(v_dta_update), 'YYYYMMDD')),
       p_cod_abi,
       p_cod_sndg,
       p_cod_ndg,
       p_cod_rapporto,
       p_dta_stima,
       p_cod_num_rata,
       p_dta_scadenza_rata,
       p_val_rata,
       v_dta_update,
       NULL,
       p_cod_utente,
       p_cod_protocollo_delibera,
       '1',
       v_dta_update,
       v_dta_update,
       p_cod_operatore_ins_upd,
       p_ftecnica);

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note || ' count: ' || v_count,
                            p_cod_utente);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_cod_utente);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_piano_rientro;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  Function che elimina o archivia il piano di rientro associato al rapporto in input
  -- %CD 4 MAR 2012
  -- %MD 4 MAG 2012
  -- %PARAM p_flg_archiviazione: Y -> indica l'archiviazione a causa di una rivalutazione del rapporto corrispondente
  FUNCTION elimina_piano_rientro( /*KEY*/p_cod_abi                 t_mcrei_app_piani_rientro.cod_abi%TYPE,
                                 p_cod_ndg                 t_mcrei_app_piani_rientro.cod_ndg%TYPE,
                                 p_cod_rapporto            t_mcrei_app_piani_rientro.cod_rapporto% TYPE,
                                 p_cod_protocollo_delibera t_mcrei_app_piani_rientro. cod_protocollo_delibera%TYPE,
                                 p_cod_utente              t_mcrei_app_piani_rientro.cod_utente%TYPE DEFAULT NULL,
                                 p_ftecnica                VARCHAR2 DEFAULT NULL,
                                 p_flg_archiviazione       VARCHAR2 DEFAULT NULL,
                                 p_datastima               DATE DEFAULT NULL)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.ELIMINA_PIANO_RIENTRO';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_ret  NUMBER;
  BEGIN
    p_note := 'ELIMINA_PIANO_RIENTRO controllo parametri';
    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_cod_protocollo_delibera IS NULL OR
       p_cod_rapporto IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'ELIMINAZIONE PIANO CON ID ' || p_cod_abi || ' ' || p_cod_ndg || ' ' ||
              p_cod_protocollo_delibera || ' ' || p_cod_rapporto;

    IF p_flg_archiviazione = 'Y'
    THEN

      IF trunc(SYSDATE) != trunc(p_datastima)
      THEN

        v_ret := archivia_piano(p_cod_protocollo_delibera,
                                p_cod_rapporto,
                                'R',
                                p_cod_utente,
                                p_datastima);
      END IF;
      -- CANCELLA IL PIANO ATTUALE PER LASCIAR POSTO ALLE RIVALUTAZIONI
      DELETE t_mcrei_app_piani_rientro
       WHERE cod_abi = p_cod_abi
         AND cod_ndg = p_cod_ndg
         AND cod_rapporto = p_cod_rapporto
         AND cod_protocollo_delibera = p_cod_protocollo_delibera;

    ELSE
      DELETE t_mcrei_app_piani_rientro
       WHERE cod_abi = p_cod_abi
         AND cod_ndg = p_cod_ndg
         AND cod_rapporto = p_cod_rapporto
         AND cod_protocollo_delibera = p_cod_protocollo_delibera;

      v_ret := SQL%ROWCOUNT;
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              p_note || ' count: ' || v_ret,
                              p_cod_utente);
    END IF;

    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_cod_utente);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END elimina_piano_rientro;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI INSERITI MANUALMENTE DELLE DELIBERE di transazione
  -- %D LA FUNCTION, PER OGNI ABI, NDG, PROTOCOLLO DI DELIBERA E PROTOCOLLO_PACCHETTO IN INPUT,
  -- %D AGGIORNA GLI ATTRIBUTI CORRISPONDENTI CON
  -- %D I VALORI PASSATI IN INPUT
  -- %CD 17 apr 2012
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
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_MAN_DETT_DELIB_TRANSAZ';
    p_note             t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_perdita_parziale NUMBER;
    v_val_del_rinuncia NUMBER;
    v_perc_rinuncia    t_mcrei_app_delibere.val_perc_perd_rm%TYPE;

  BEGIN
    p_note := 'Controllo parametri input' || p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_cod_protocollo_pacchetto || ', ' ||
              p_cod_protocollo_delibera;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_cod_protocollo_pacchetto IS NULL OR
       p_cod_protocollo_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'POPOLA_MAN_DETT_DELIB_PRONTI: Salvataggio dati manuali delibera transazione a pronti ' ||
              p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_cod_protocollo_delibera || ', ' ||
              p_cod_protocollo_pacchetto;



    --V_MCREI_APP_DETT_DELIB_TRANSAZ
    UPDATE t_mcrei_app_delibere d
       SET d.val_rinuncia_capitale         = p_val_rinuncia_capitale,
           d.val_rinuncia_mora             = p_val_rinuncia_mora,
           d.val_rinuncia_proposta         = nvl(p_val_rinuncia_capitale, 0) +
                                             nvl(p_val_rinuncia_mora, 0),
           d.dta_scadenza_transaz          = p_dta_scadenza_transazione,
           d.val_tasso_base_appl           = p_flg_tasso_base_appl,
           d.desc_note                     = p_desc_note,
           d.dta_last_upd_delibera         = SYSDATE,
           d.flg_no_garanzie_capienti      = f_no_garanzie_capienti,
           d.flg_no_colleg_altre_pos       = f_no_colleg_altre_pos,
           d.flg_no_rischi_firma           = f_no_rischi_firma,
           d.flg_perdur_difficolta_econ    = f_perdur_difficolta_econ,
           d.flg_no_patrimon_aggred        = f_no_patrimon_aggred,
           d.flg_no_presupposti_class_soff = f_no_presupposti_class_soff,
           d.flg_no_gruppo_economico       = f_no_gruppo_economico,
           d.val_imp_perdita               = nvl(d.val_rinuncia_deliberata,
                                                 0) +
                                             nvl(p_val_rinuncia_capitale, 0) +
                                             nvl(p_val_rinuncia_mora, 0),
           d.val_rinuncia_totale           = nvl(d.val_rinuncia_deliberata,
                                                 0) +
                                             nvl(p_val_rinuncia_capitale, 0) +
                                             nvl(p_val_rinuncia_mora, 0)
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_delibera = p_cod_protocollo_delibera
       AND d.cod_protocollo_pacchetto = p_cod_protocollo_pacchetto;

    -- new: aggiorno il valore di rinuncia complessiva per tutte le delibere del pacchetto, abi e ndg
    -- sulla base di tutte le rinunce digitate finora su di esso
    SELECT DISTINCT nvl(val_rinuncia_deliberata, 0),
                    SUM(val_rinuncia_capitale + nvl(val_rinuncia_mora, 0)) over(PARTITION BY cod_abi, cod_ndg, cod_protocollo_pacchetto)
      INTO v_val_del_rinuncia,
           v_perdita_parziale
      FROM t_mcrei_app_delibere d
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_pacchetto = p_cod_protocollo_pacchetto
       AND d.flg_no_delibera = 0
       AND d.cod_fase_delibera != 'AN';

    UPDATE t_mcrei_app_delibere d
       SET val_rinuncia_totale = v_val_del_rinuncia + v_perdita_parziale
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_pacchetto = p_cod_protocollo_pacchetto;

    p_note := p_note || '; Record aggiornati: ' || SQL%ROWCOUNT;
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_dett_delib_transaz;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE FUNCTION CHE SALVA I CAMPI DELLE DELIBERE di transazione a pronti
  -- %D LA FUNCTION, PER OGNI ABI, NDG, PROTOCOLLO DI DELIBERA E PROTOCOLLO_PACCHETTO IN INPUT,
  -- %D AGGIORNA GLI ATTRIBUTI CORRISPONDENTI CON I VALORI PASSATI IN INPUT,
  -- %CD 17 apr 2012
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
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_DETT_DELIB_TRANSAZ';
    p_note             t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_val_del_rinuncia NUMBER;
    v_perdita_parziale NUMBER;
    v_perc_rinuncia    t_mcrei_app_delibere.val_perc_perd_rm%TYPE;

  BEGIN
    p_note := 'Controllo parametri input' || p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_cod_protocollo_pacchetto || ', ' ||
              p_cod_protocollo_delibera;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_cod_protocollo_pacchetto IS NULL OR
       p_cod_protocollo_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'POPOLA_DETT_DELIB_TRANSAZ: Salvataggio dati delibera transazione a pronti ' ||
              p_cod_abi || ', ' || p_cod_ndg || ', ' ||
              p_cod_protocollo_delibera || ', ' ||
              p_cod_protocollo_delibera;

   -- BEGIN

--SELECT CASE
--         WHEN cod_fase_delibera IN ('IN', 'CM') THEN
--          to_char(trunc(((nvl(mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct(d.cod_abi,
--                                                                                        d.cod_ndg),
--                              0) + nvl(mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia(d.cod_abi,
--                                                                                                      d.cod_ndg,
--                                                                                                      'CO'),
--                                         0) +
--                        nvl(val_rinuncia_capitale, 0) +
--                        nvl(val_rinuncia_mora, 0)) /
--                        (nvl(val_uti_cassa_scsb, nvl(val_esp_lorda, 0)) +
--                        nvl(mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct(d.cod_abi,
--                                                                                        d.cod_ndg),
--                              0))) * 100))
--         ELSE
--          val_perc_perd_rm
--       END
--  INTO v_perc_rinuncia
--  FROM t_mcrei_app_delibere d
-- WHERE cod_abi = p_cod_abi
--   AND cod_ndg = p_cod_ndg
--   AND cod_protocollo_delibera = p_cod_protocollo_delibera;

--    EXCEPTION
--      WHEN no_data_found THEN
--        v_perc_rinuncia := NULL;
--    END;

     UPDATE (SELECT --= DELIBERE =--
             d.val_accordato,
             d.val_accordato_cassa,
             d.val_accordato_firma,
             d.val_accordato_derivati,
             d.val_uti_tot_scsb,
             d.val_esp_lorda,
             d.val_uti_cassa_scsb,
             d.cod_fase_delibera,
             d.val_rinuncia_capitale,
             d.val_rinuncia_mora,
             d.val_imp_perdita,
             d.val_rinuncia_proposta,
             d.val_rinuncia_deliberata,
             d.val_rinuncia_totale,
             d.dta_scadenza_transaz,
             d.val_tasso_base_appl,
             d.desc_note,
             d.dta_last_upd_delibera,
             d.flg_no_garanzie_capienti,
             d.flg_no_colleg_altre_pos,
             d.flg_no_rischi_firma,
             d.flg_perdur_difficolta_econ,
             d.flg_no_patrimon_aggred,
             d.flg_no_presupposti_class_soff,
             d.flg_no_gruppo_economico,
             --= PCR_RAPP_AGGR =--
             p.scsb_acc_tot,
             p.scsb_acc_cassa,
             p.scsb_acc_firma,
             p.scsb_acc_sostituzioni,
             p.scsb_uti_tot,
             p.scsb_uti_cassa,
             p.scsb_uti_firma,
             d.VAL_UTI_FIRMA_SCSB,
             D.val_perc_PERD_RM,
             (CASE
                     WHEN cod_fase_delibera IN ('IN', 'CM') THEN

                     CASE WHEN (nvl(p.scsb_uti_cassa, nvl(val_esp_lorda, 0)) +
                                    nvl(mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct(d.cod_abi,
                                                                                                    d.cod_ndg),
                                          0)) = 0
                     THEN '100'
                     ELSE

                      to_char(trunc(((nvl(mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct(d.cod_abi,
                                                                                                    d.cod_ndg),
                                          0) + nvl(mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia(d.cod_abi,
                                                                                                                  d.cod_ndg,
                                                                                                                  'CO'),
                                                     0) +
                                    nvl(val_rinuncia_capitale, 0) +
                                    nvl(val_rinuncia_mora, 0)) /
                                    (nvl(p.scsb_uti_cassa, nvl(val_esp_lorda, 0)) +
                                    nvl(mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct(d.cod_abi,
                                                                                                    d.cod_ndg),
                                          0))) * 100))
                     END
                     ELSE
                      D.val_perc_PERD_RM
              END) AS v_perc_rinuncia
              FROM t_mcrei_app_delibere      d,
                   t_mcrei_app_pcr_rapp_aggr p
             WHERE d.cod_abi = p.cod_abi_cartolarizzato(+)
               AND d.cod_ndg = p.cod_ndg(+)
               AND d.cod_abi = p_cod_abi
               AND d.cod_ndg = p_cod_ndg
               AND d.cod_protocollo_delibera = p_cod_protocollo_delibera
               AND d.cod_protocollo_pacchetto = p_cod_protocollo_pacchetto)PP
       SET val_accordato          = PP.scsb_acc_tot,
           val_accordato_cassa    = PP.scsb_acc_cassa,
           val_accordato_firma    = PP.scsb_acc_firma,
           val_accordato_derivati = PP.scsb_acc_sostituzioni,
           val_uti_tot_scsb       = nvl(PP.scsb_uti_cassa,0)+ nvl(PP.scsb_uti_firma,0) ,--7 marzo--PP.scsb_uti_tot,
           val_esp_lorda          = PP.scsb_uti_tot,
           val_uti_cassa_scsb     = PP.scsb_uti_cassa,
           VAL_UTI_FIRMA_SCSB     = PP.scsb_uti_firma,
           -- CAMPI MANUALI
           val_rinuncia_capitale         = p_val_rinuncia_capitale,
           val_rinuncia_mora             = p_val_rinuncia_mora,
           val_imp_perdita               = nvl(val_rinuncia_deliberata, 0) +
                                           nvl(p_val_rinuncia_capitale, 0) +
                                           nvl(p_val_rinuncia_mora, 0),
           val_rinuncia_proposta         = nvl(p_val_rinuncia_capitale, 0) +
                                           nvl(p_val_rinuncia_mora, 0),
           val_rinuncia_totale           = nvl(val_rinuncia_deliberata, 0) +
                                           nvl(p_val_rinuncia_capitale, 0) +
                                           nvl(p_val_rinuncia_mora, 0),
           dta_scadenza_transaz          = p_dta_scadenza_transazione,
           val_tasso_base_appl           = p_flg_tasso_base_appl,
           desc_note                     = p_desc_note,
           dta_last_upd_delibera         = SYSDATE,
           flg_no_garanzie_capienti      = f_no_garanzie_capienti,
           flg_no_colleg_altre_pos       = f_no_colleg_altre_pos,
           flg_no_rischi_firma           = f_no_rischi_firma,
           flg_perdur_difficolta_econ    = f_perdur_difficolta_econ,
           flg_no_patrimon_aggred        = f_no_patrimon_aggred,
           flg_no_presupposti_class_soff = f_no_presupposti_class_soff,
           flg_no_gruppo_economico       = f_no_gruppo_economico,
           val_perc_PERD_RM             = v_perc_rinuncia;

    -- new: aggiorno il valore di rinuncia complessiva per tutte le delibere del pacchetto, abi e ndg
    -- sulla base di tutte le rinunce valide e digitate finora sul pacchetto stesse
    SELECT DISTINCT nvl(val_rinuncia_deliberata, 0),
                    SUM(nvl(val_rinuncia_capitale, 0) +
                        nvl(val_rinuncia_mora, 0)) over(PARTITION BY cod_abi, cod_ndg, cod_protocollo_pacchetto)
      INTO v_val_del_rinuncia,
           v_perdita_parziale
      FROM t_mcrei_app_delibere d
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_pacchetto = p_cod_protocollo_pacchetto
       AND d.flg_no_delibera = 0
       AND d.cod_fase_delibera != 'AN';

    UPDATE t_mcrei_app_delibere d
       SET val_imp_perdita     = v_val_del_rinuncia + v_perdita_parziale,
           val_rinuncia_totale = v_val_del_rinuncia + v_perdita_parziale
     WHERE d.cod_abi = p_cod_abi
       AND d.cod_ndg = p_cod_ndg
       AND d.cod_protocollo_pacchetto = p_cod_protocollo_pacchetto;

    p_note := p_note || '; Record aggiornati: ' || SQL%ROWCOUNT;
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_dett_delib_transaz;

  -- %AUTHOR REPLY
  -- %VERSION 0.1
  -- %USAGE  FUNZIONE CHE CREA IL PACCHETTO MONODELIBERA A SEGUITO DELLA CHIAMATA DA BUSINESS SERVICE
  -- %D  LA FUNZIONE E' RESPONSABILE DELLA CREAZIONE DI UN PACCHETTO MONODELIBERA IN STATO INSERITO
  -- %CD 28 FEB 2012
  PROCEDURE crea_pacchetto_batch(p_cod_abi       IN VARCHAR2,
                                 p_cod_ndg       IN VARCHAR2,
                                 p_tipo_proposta IN VARCHAR2,
                                 --(E oppure S)
                                 p_anno_proposta     IN t_mcrei_app_delibere. val_anno_proposta%TYPE,
                                 p_progre_proposta   IN t_mcrei_app_delibere. val_progr_proposta%TYPE,
                                 p_uo                IN t_mcrei_app_delibere. cod_uo_proposta%TYPE,
                                 out_proto_delibera  OUT VARCHAR2,
                                 out_proto_pacchetto OUT VARCHAR2,
                                 out_esito           OUT NUMBER) ---1 OK, 0 KO
   AS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.CREA_PACCHETTO_BATCH';
    v_prot             t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    p_note             t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_progre_delib     NUMBER;
    v_cod_pratica      VARCHAR2(11);
    v_anno_pratica     NUMBER(4);
    val_rdv_qc_progr   NUMBER := 0;
    v_rdv_progr_fi     NUMBER := 0;
    val_esp_netta_post NUMBER := 0;
    v_imp_perdita      NUMBER := 0;
    v_delibera_pre     t_mcrei_app_delibere.cod_protocollo_delibera_pre%TYPE;
    v_stralcio_ct      NUMBER := 0;
  BEGIN
    p_note := 'CREA_PACCHETTO batch ' || p_cod_abi || ' ' || p_cod_ndg || ' ' ||
              p_tipo_proposta;

    IF p_cod_ndg IS NULL OR
       p_cod_abi IS NULL OR
       p_tipo_proposta IS NULL
    THEN
      out_esito := const_esito_ko;
      raise_application_error(-20666, 'Null parameter');
    END IF;

    BEGIN

      --0808 se l'ultima delibera contabilizzata S CT recupero la somma degli stralci come perdita iniziale
      begin
      v_stralcio_ct := NVL (pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct(p_cod_abi,p_cod_ndg), 0  );
      exception when others then
      v_stralcio_ct := 0;
      end;

      SELECT val_rdv_qc_progressiva,
             val_esp_netta_post_delib,
             cod_protocollo_delibera,
             val_rdv_progr_fi,
             val_imp_perdita
        INTO val_rdv_qc_progr,
             val_esp_netta_post,
             v_delibera_pre,
             v_rdv_progr_fi,
             v_imp_perdita
        FROM (SELECT nvl(s.val_rdv_qc_progressiva, 0) val_rdv_qc_progressiva,
                     nvl(s.val_esp_netta_post_delib, 0) val_esp_netta_post_delib,
                     s.cod_protocollo_delibera,
                     nvl(s.val_rdv_progr_fi, 0) AS val_rdv_progr_fi,
                     decode(s.cod_fase_delibera,
                            'CT',
                            --11 MAGGIO: aaggiunta logica su rinuncia pregressa in caso di CT
                            --MM 0808: in fase di inizializzazione, la rinuncia pregressa CT S lo stralcio capitalizzato
                            --nvl(s.val_rinuncia_totale, 0) -
                            --nvl(val_imp_perdita, 0) +
                            --nvl(s.val_sacrif_capit_mora, 0),
                            v_stralcio_ct,
                            nvl(s.val_imp_perdita, 0)) AS val_imp_perdita
              --6.0
                FROM t_mcrei_app_delibere s
               WHERE s.cod_abi = p_cod_abi
                 AND s.cod_ndg = p_cod_ndg
                 AND s.cod_fase_delibera IN ('AD', 'CO', 'CT', 'NA')
                    ---aggiunto CT il 11/4, NA il 24/4
                 AND s.flg_no_delibera = 0
                 AND flg_attiva = '1'
                   ORDER BY s.dta_conferma_delibera  DESC,
                            s.val_num_progr_delibera DESC )
       WHERE rownum <= 1;
    EXCEPTION
      WHEN no_data_found THEN
        val_rdv_qc_progr   := 0;
        v_rdv_progr_fi     := 0;
        val_esp_netta_post := 0;
        v_imp_perdita      := 0;
        v_delibera_pre     := '#';
    END;

     BEGIN
      INSERT INTO t_mcrei_app_delibere d
        (id_dper,
         cod_sndg,
         cod_abi,
         cod_ndg,
         cod_protocollo_pacchetto,
         cod_protocollo_delibera,
         cod_protocollo_delibera_pre,
         flg_attiva,
         cod_microtipologia_delib,
         cod_fase_delibera,
         cod_fase_microtipologia,
         cod_fase_pacchetto,
         dta_creazione_pacchetto,
         dta_ins_delibera,
         cod_tipo_pacchetto,
         cod_matricola_inserente,
         cod_macrotipologia_delib,
         cod_pratica,
         val_anno_pratica,
         cod_uo_pratica,
         cod_segmento,
         desc_denominaz_ins_delibera,
         cod_filiale_delibera,
         val_rdv_qc_progressiva,
         val_esp_netta_post_delib,
         val_rdv_qc_ante_delib,
         val_esp_netta_ante_delib,
         val_num_progr_delibera,
         flg_no_delibera,
         val_anno_proposta,
         val_progr_proposta,
         cod_uo_proponente,
         val_rdv_progr_fi,
         val_rdv_pregr_fi,
         val_rinuncia_deliberata,
         val_imp_perdita,
         val_stralcio_senza_accantonam,
                COD_STATO_POSIZ,
                DTA_DEC_STATO_POSIZ,
                DESC_MICROTIPOLOGIA2,
                DESC_MACROTIPOLOGIA2,
                COD_TIPO_GESTIONE2,
                DESC_STRUTTURA_COMPETENTE_DV2,
                DESC_ISTITUTO2,
                COD_STRUTTURA_COMPETENTE_DC2,
                COD_STRUTTURA_COMPETENTE_FI2,
                COD_STRUTTURA_COMPETENTE_AR2,
                COD_PROCESSO2,
                COD_STRUTTURA_COMPETENTE_RG2,
                DESC_STRUTTURA_COMPETENTE_AR2,
                DESC_GRUPPO_ECONOMICO2,
                COD_COMPARTO2,
                COD_STRUTTURA_COMPETENTE_DV2,
                NOME2,
                COD_STRUTTURA_COMPETENTE2,
                DESC_STRUTTURA_COMPETENTE_RG2,
                COD_GRUPPO_ECONOMICO2,
                COD_FILIALE2,
                DESC_NOME_CONTROPARTE2,
                DESC_STRUTTURA_COMPETENTE_DC2,
                COD_STATO2,
                COGNOME2,
                COD_MATRICOLA2,
                DESC_COMPARTO2,
                DESC_STRUTTURA_COMPETENTE_FI2 )
        (SELECT to_number(to_char(trunc(SYSDATE), 'YYYYMMDD')),
                g.cod_sndg,
                p_cod_abi,
                p_cod_ndg,
                g.cod_sndg || '_' || mcre_own.seq_mcrei_pacchetto.nextval,

                ---proto_pacchetto
                /*TO_CHAR(SYSDATE, 'YYYY') ||
                LPAD(mcre_own.seq_mcrei_pacchetto.NEXTVAL, 13, '0'),
                */
                --lpad(to_char(SYSDATE, 'YYYY'), 6, '0') || --v7.0
                lpad(p_anno_proposta, 6, '0') ||
                lpad(p_progre_proposta, 11, '0'), --proto_Delibera
                v_delibera_pre,
                '1' AS flg_attiva,
                decode(p_tipo_proposta, 'E', 'CI', 'CS'),
                --P_MICROTIPOLOG,
                'IN',
                'INS',
                'INS',
                SYSDATE,
                SYSDATE,
                'B',
                ----PROPOSTA BATCH
                'BATCH',
                'GE',

                --T.COD_MACROTIPOLOGIA,
                p.cod_pratica,
                p.val_anno_pratica,
                p.cod_uo_pratica,
                a.val_segmento_regolamentare,
                'BATCH',
                g.cod_filiale,
                val_rdv_qc_progr val_rdv_qc_progressiva, --29.03
                pc.scsb_uti_cassa - val_rdv_qc_progr AS val_esp_netta_post_delib, --9 maggio
                val_rdv_qc_progr val_rdv_qc_ante_delib,
                pc.scsb_uti_cassa - val_rdv_qc_progr AS val_esp_netta_ante_delib,

                -- 9 maggio
                decode(p_tipo_proposta,
                       'E',
                       0,
                       decode(p.cod_pratica,
                              NULL,
                              0,
                              seq_mcrei_prog_del.nextval)),

                ----VAL_NUM_PROGR_DELIBERA = 0 PER LE CLASSIFICAZIONI SENZA PRATICA
                CASE --v7.5 considero dervivati su CI/CS
                 WHEN p_tipo_proposta = 'E' AND
                      g.cod_stato IN ('IN', 'SO') THEN
                  1
                 WHEN p_tipo_proposta = 'S' AND
                      g.cod_stato = 'SO' THEN
                  1
--                       WHEN nvl(pc.scsb_acc_tot + pc.scsb_uti_tot, 0) = 0 THEN
                 WHEN nvl(pc.scsb_acc_tot, 0) + nvl(pc.scsb_uti_tot, 0) +
                    nvl(pc.scsb_acc_sostituzioni, 0) + nvl(pc.scsb_uti_sostituzioni, 0) = 0 THEN
                  1
                 ELSE
                  0
                END fl_no_del,
                p_anno_proposta,
                p_progre_proposta,
                p_uo,
                nvl(v_rdv_progr_fi, 0),
                nvl(v_rdv_progr_fi, 0),
                v_imp_perdita,
                v_imp_perdita AS val_imp_perdita,
                v_stralcio_ct,
                G.COD_STATO,
                G.DTA_DECORRENZA_STATO,
                TIP.DESC_MICROTIPOLOGIA,
                TIP.DESC_MACROTIPOLOGIA,
                P.COD_TIPO_GESTIONE,
                G.DESC_STRUTTURA_COMPETENTE_DV,
                G.DESC_ISTITUTO,
                G.COD_STRUTTURA_COMPETENTE_DC,
                G.COD_STRUTTURA_COMPETENTE_FI,
                G.COD_STRUTTURA_COMPETENTE_AR,
                G.COD_PROCESSO,
                G.COD_STRUTTURA_COMPETENTE_RG,
                G.DESC_STRUTTURA_COMPETENTE_AR,
                G.DESC_GRUPPO_ECONOMICO,
                G.COD_COMPARTO,
                G.COD_STRUTTURA_COMPETENTE_DV,
                G.NOME,
                G.COD_STRUTTURA_COMPETENTE,
                G.DESC_STRUTTURA_COMPETENTE_RG,
                G.COD_GRUPPO_ECONOMICO,
                G.COD_FILIALE,
                G.DESC_NOME_CONTROPARTE,
                G.DESC_STRUTTURA_COMPETENTE_DC,
                G.COD_STATO,
                G.COGNOME,
                G.COD_MATRICOLA,
                G.DESC_COMPARTO,
                G.DESC_STRUTTURA_COMPETENTE_FI
           FROM V_MCRE0_APP_UPD_FIELDS_ALL          g,
                t_mcrei_app_pratiche          p,
                t_mcre0_app_anagrafica_gruppo a,
                t_mcrei_app_pcr_rapp_aggr     pc,
                T_MCREI_CL_TIPOLOGIE TIP
          WHERE g.cod_abi_cartolarizzato = p_cod_abi
            AND g.cod_ndg = p_cod_ndg
            AND g.cod_sndg = a.cod_sndg
            AND g.cod_abi_cartolarizzato = p.cod_abi(+)
            AND g.cod_ndg = p.cod_ndg(+)
            AND g.cod_abi_cartolarizzato = pc.cod_abi_cartolarizzato(+)
            AND g.cod_ndg = pc.cod_ndg(+)
            AND p.flg_attiva(+) = '1'
            AND decode(p_tipo_proposta, 'E', 'CI', 'CS') = TIP.COD_MICROTIPOLOGIA);
    EXCEPTION
      WHEN dup_val_on_index THEN
        ---SE ESISTE GIA' UNA PROPOSTA AUTOMATICA NELLE DELIBERE, AGGIORNO IL RECORD
        UPDATE t_mcrei_app_delibere de
           SET (id_dper,
                cod_sndg,
                cod_abi,
                cod_ndg,

                --cod_protocollo_pacchetto,
                --cod_protocollo_delibera,
                cod_protocollo_delibera_pre,
                flg_attiva,
                cod_microtipologia_delib,
                cod_fase_delibera,
                cod_fase_microtipologia,
                cod_fase_pacchetto,

                --dta_creazione_pacchetto,
                --dta_ins_delibera,
                cod_tipo_pacchetto,
                cod_matricola_inserente,
                cod_macrotipologia_delib,
                cod_pratica,
                val_anno_pratica,
                cod_uo_pratica,
                cod_segmento,
                --desc_denominaz_ins_delibera,
                cod_filiale_delibera,
                val_rdv_qc_progressiva,
                val_esp_netta_post_delib,
                val_rdv_qc_ante_delib,
                val_esp_netta_ante_delib,

                --val_num_progr_delibera,
                flg_no_delibera,
                val_anno_proposta,
                val_progr_proposta,
                cod_uo_proponente,
                val_rdv_progr_fi,
                val_rdv_pregr_fi,
                val_rinuncia_deliberata,
                COD_STATO_POSIZ,
                DTA_DEC_STATO_POSIZ,
                DESC_MICROTIPOLOGIA2,
                DESC_MACROTIPOLOGIA2,
                COD_TIPO_GESTIONE2,
                DESC_STRUTTURA_COMPETENTE_DV2,
                DESC_ISTITUTO2,
                COD_STRUTTURA_COMPETENTE_DC2,
                COD_STRUTTURA_COMPETENTE_FI2,
                COD_STRUTTURA_COMPETENTE_AR2,
                COD_PROCESSO2,
                COD_STRUTTURA_COMPETENTE_RG2,
                DESC_STRUTTURA_COMPETENTE_AR2,
                DESC_GRUPPO_ECONOMICO2,
                COD_COMPARTO2,
                COD_STRUTTURA_COMPETENTE_DV2,
                NOME2,
                COD_STRUTTURA_COMPETENTE2,
                DESC_STRUTTURA_COMPETENTE_RG2,
                COD_GRUPPO_ECONOMICO2,
                COD_FILIALE2,
                DESC_NOME_CONTROPARTE2,
                DESC_STRUTTURA_COMPETENTE_DC2,
                COD_STATO2,
                COGNOME2,
                COD_MATRICOLA2,
                DESC_COMPARTO2,
                DESC_STRUTTURA_COMPETENTE_FI2) =
               (SELECT to_number(to_char(trunc(SYSDATE), 'YYYYMMDD')),
                       g.cod_sndg,
                       p_cod_abi,
                       p_cod_ndg,

                       --g.cod_sndg || '_' || mcre_own.seq_mcrei_pacchetto.NEXTVAL,
                       ---proto_pacchetto
                       --lpad (TO_CHAR(SYSDATE, 'YYYY'),6,'0')||lpad (p_progre_proposta,11,'0'),--proto_Delibera
                       v_delibera_pre,
                       '1' AS flg_attiva,
                       decode(p_tipo_proposta, 'E', 'CI', 'CS'),
                       --P_MICROTIPOLOG,
                       'IN',
                       'INS',
                       'INS',
                       --SYSDATE,
                       --SYSDATE,
                       'B', ----PROPOSTA BATCH
                       'BATCH',
                       'GE', --T.COD_MACROTIPOLOGIA,
                       p.cod_pratica,
                       p.val_anno_pratica,
                       p.cod_uo_pratica,
                       a.val_segmento_regolamentare,
                       --'BATCH',
                       g.cod_filiale,
                       val_rdv_qc_progr val_rdv_qc_progressiva, --29.03
                       pc.scsb_uti_cassa - val_rdv_qc_progr AS val_esp_netta_post_delib,

                       --9 maggio val_esp_netta_post_delib, --29.03,
                       val_rdv_qc_progr val_rdv_qc_ante_delib,
                       pc.scsb_uti_cassa - val_rdv_qc_progr AS val_esp_netta_ante_delib,

                       --9 maggio

                       --decode(p_tipo_proposta,
                       --       'E',
                       --       0,
                       --       decode(p.cod_pratica,
                       --              NULL,
                       --              0,
                       --              seq_mcrei_prog_del.nextval)),
                       ----VAL_NUM_PROGR_DELIBERA = 0 PER LE CLASSIFICAZIONI SENZA PRATICA
                       CASE --v7.5 considero dervivati su CI/CS
                         WHEN p_tipo_proposta = 'E' AND
                              g.cod_stato IN ('IN', 'SO') THEN
                          1
                         WHEN p_tipo_proposta = 'S' AND
                              g.cod_stato = 'SO' THEN
                          1
--                       WHEN nvl(pc.scsb_acc_tot + pc.scsb_uti_tot, 0) = 0 THEN
                         WHEN nvl(pc.scsb_acc_tot, 0) + nvl(pc.scsb_uti_tot, 0) +
                            nvl(pc.scsb_acc_sostituzioni, 0) + nvl(pc.scsb_uti_sostituzioni, 0) = 0 THEN
                          1
                         ELSE
                          0
                       END fl_no_del,
                       p_anno_proposta,
                       p_progre_proposta,
                       p_uo,
                       nvl(v_rdv_progr_fi, 0),
                       nvl(v_rdv_progr_fi, 0),
                       v_imp_perdita,
                        G.COD_STATO,
                        G.DTA_DECORRENZA_STATO,
                        TIP.DESC_MICROTIPOLOGIA,
                        TIP.DESC_MACROTIPOLOGIA,
                        P.COD_TIPO_GESTIONE,
                        G.DESC_STRUTTURA_COMPETENTE_DV,
                        G.DESC_ISTITUTO,
                        G.COD_STRUTTURA_COMPETENTE_DC,
                        G.COD_STRUTTURA_COMPETENTE_FI,
                        G.COD_STRUTTURA_COMPETENTE_AR,
                        G.COD_PROCESSO,
                        G.COD_STRUTTURA_COMPETENTE_RG,
                        G.DESC_STRUTTURA_COMPETENTE_AR,
                        G.DESC_GRUPPO_ECONOMICO,
                        G.COD_COMPARTO,
                        G.COD_STRUTTURA_COMPETENTE_DV,
                        G.NOME,
                        G.COD_STRUTTURA_COMPETENTE,
                        G.DESC_STRUTTURA_COMPETENTE_RG,
                        G.COD_GRUPPO_ECONOMICO,
                        G.COD_FILIALE,
                        G.DESC_NOME_CONTROPARTE,
                        G.DESC_STRUTTURA_COMPETENTE_DC,
                        G.COD_STATO,
                        G.COGNOME,
                        G.COD_MATRICOLA,
                        G.DESC_COMPARTO,
                        G.DESC_STRUTTURA_COMPETENTE_FI
                  FROM V_MCRE0_APP_UPD_FIELDS_ALL    g,
                       t_mcrei_app_pratiche          p,
                       t_mcre0_app_anagrafica_gruppo a,
                       t_mcrei_app_pcr_rapp_aggr     pc,
                       T_MCREI_CL_TIPOLOGIE TIP
                 WHERE g.cod_abi_cartolarizzato = p_cod_abi
                   AND g.cod_ndg = p_cod_ndg
                   AND g.cod_sndg = a.cod_sndg
                   AND g.cod_abi_cartolarizzato = p.cod_abi(+)
                   AND g.cod_ndg = p.cod_ndg(+)
                   AND g.cod_abi_cartolarizzato =
                       pc.cod_abi_cartolarizzato(+)
                   AND g.cod_ndg = pc.cod_ndg(+)
                   AND p.flg_attiva(+) = '1'
                   AND decode(p_tipo_proposta, 'E', 'CI', 'CS') = TIP.COD_MICROTIPOLOGIA)
         WHERE de.cod_abi = p_cod_abi
           AND de.cod_ndg = p_cod_ndg
           AND de.cod_protocollo_delibera =
               lpad(p_anno_proposta, 6, '0') || --v7.0 anno_proposta e non sysdate!
               lpad(p_progre_proposta, 11, '0');
    END;


    ---restituisco i valori dei protocolli generati
    SELECT cod_protocollo_delibera,
           cod_protocollo_pacchetto
      INTO out_proto_delibera,
           out_proto_pacchetto
      FROM t_mcrei_app_delibere r
     WHERE r.cod_abi = p_cod_abi
       AND r.cod_ndg = p_cod_ndg
       AND cod_matricola_inserente = 'BATCH'
        AND COD_FASE_PACCHETTO NOT IN ('ANA','ANM')
       AND flg_attiva = '1';

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            'out: del ' || out_proto_delibera || ' pacc ' ||
                            out_proto_pacchetto,
                            p_note,
                            'BATCH');
    out_esito := const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      out_esito := const_esito_ko;
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              'BATCH');
  END crea_pacchetto_batch;

  -- %author Reply
  -- %version 0.1
  -- %d  Procedura di salvataggio dei dati restituiti dal motore di calcolo OD ad ogni invocazione
  -- %cd 15 MAR 2012
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
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_DATI_OUT_OD';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
    retval NUMBER;
  BEGIN
    p_note := 'POPOLA_DATI_OUT_OD: Controllo_parametri: ABI = ' || p_abi ||
              ', NDG = ' || p_ndg || ', MICROTIPOLOGIA =  ' ||
              pc_microtipologia || ', PROTO_PACCHETTO = ' || p_proto_pacch;

    IF p_abi IS NULL OR
       p_ndg IS NULL OR
       pc_microtipologia IS NULL OR
       p_proto_pacch IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    p_note := 'POPOLA_DATI_OUT_OD, DELETE OD CALCOLATI PRECEDENTEMENTE INSERITI; ABI = ' ||
              p_abi || ', MICROTIPOLOGIA =  ' || pc_microtipologia ||
              ', PROTO_PACCHETTO = ' || p_proto_pacch;

    DELETE t_mcre0_app_od_calcolati od
     WHERE od.cod_abi = p_abi
       AND od.cod_protocollo_pacchetto = p_proto_pacch
       AND od.cod_microtipologia = pc_microtipologia;

    p_note := 'POPOLA_DATI_OUT_OD, INSERIMENTO NUOVI DATI PASSATI IN INPUT; ABI = ' ||
              p_abi || ', MICROTIPOLOGIA =  ' || pc_microtipologia ||
              ', PROTO_PACCHETTO = ' || p_proto_pacch;

    INSERT INTO t_mcre0_app_od_calcolati
      (cod_abi,
       cod_ndg,
       cod_protocollo_pacchetto,
       cod_microtipologia,
       val_imp_rdv,
       val_rinuncia,
       val_imp_lim_gest,
       val_durata,
       val_tur,
       val_perc_perdita,
       flg_fattori_mitiganti,
       desc_fattori_mitiganti,
       val_ind_dim_oc_conc,
       vat_tot_od_conc_gb,
       val_tot_od_conc,
       dta_calcolo_od_conc,
       cod_rif_calcolo_od_conc,
       cod_organo_gestionale,
       cod_progr_organo_gest,
       cod_organo_concessione,
       cod_progr_organo_concessione,
       cod_organo_massimo,
       cod_progr_organo_massimo,
       dta_ins,
       val_rinuncia_ins,
       val_rinuncia_conf,
       val_rinuncia_cont,
       val_imp_rdv_ins,
       val_imp_rdv_conf,
       val_imp_utilizzato,
       cod_esito_rc_clone,
       val_tot_utilizzato_gb,
       val_tot_utilizzato_ir,
       val_tot_rwa_in_var_su_gb,
       val_tot_rwa_a_new_ord_su_gb,
       val_tot_rwa_a_new_cons_su_gb,
       val_tot_rwa_in_essere_su_ir,
       val_tot_rwa_in_var_su_ir,
       val_tot_rwa_a_new_ord_su_ir,
       val_tot_rwa_a_new_cons_su_ir,
       val_tot_rwa_in_essere_su_gb)
    VALUES
      (p_abi,
       p_ndg,
       p_proto_pacch,
       pc_microtipologia,
       pv_imp_rdv,
       pv_rinuncia,
       pv_imp_lim_gest,
       pv_durata,
       pv_tur,
       pv_perc_perdita,
       pf_fattori_mitiganti,
       pdc_fattori_mitiganti,
       pv_ind_dim_oc_conc,
       pv_tot_od_conc_gb,
       pv_tot_od_conc,
       SYSDATE,
       pc_rif_calcolo_od_conc,
       pc_organo_gestionale,
       pc_progr_organo_gest,
       pc_organo_concessione,
       pc_progr_organo_concessione,
       pc_organo_massimo,
       pc_progr_organo_massimo,
       SYSDATE,
       pv_rinuncia_ins,
       pv_rinuncia_conf,
       pv_rinuncia_cont,
       pv_imp_rdv_ins,
       pv_imp_rdv_conf,
       pv_imp_utilizzato,
       p_esito_rc_clone,
       p_tot_utilizzato_gb,
       p_tot_utilizzato_ir,
       p_tot_rwa_in_var_su_gb,
       p_tot_rwa_a_new_ord_su_gb,
       p_tot_rwa_a_new_cons_su_gb,
       p_tot_rwa_in_essere_su_ir,
       p_tot_rwa_in_var_su_ir,
       p_tot_rwa_a_new_ord_su_ir,
       p_tot_rwa_a_new_cons_su_ir,
       p_tot_rwa_in_essere_su_gb);

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_dati_out_od;

  FUNCTION pulisci_dati_out_od(p_proto_pacch IN t_mcre0_app_od_calcolati. cod_protocollo_pacchetto%TYPE)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_DATI_OUT_OD';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
    retval NUMBER;
  BEGIN
    p_note := 'PULISCI_DATI_OUT_OD: Controllo_parametri:' ||
              ' PROTO_PACCHETTO = ' || p_proto_pacch;

    IF p_proto_pacch IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    DELETE t_mcre0_app_od_calcolati
     WHERE cod_protocollo_pacchetto = p_proto_pacch;

    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END pulisci_dati_out_od;

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
  -- %PARAM P_PROTO_DELIB_COLL
  -- %PARAM P_PROTO_PACCHETTO
  -- %PARAM P_MICROTIPOLO
  -- %PARAM P_UTE_INSE
  --------------------> ATTENZIONE IL CAMBIO DELLA FASE DELIBERA TR AVVIENE QUI, OPPURE NELLA CAMBIA_FASE_DELIBERA????
  FUNCTION aggiungi_microtipologia_ct(p_cod_abi                 IN t_mcrei_app_delibere.cod_abi%TYPE,
                                      p_cod_ndg                 IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                      p_proto_delib             IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                      p_proto_pacchetto         IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                      p_microtipolo             IN t_mcrei_app_delibere.cod_microtipologia_delib%TYPE,
                                      p_ute_inse                IN t_mcrei_app_delibere.cod_matricola_inserente%TYPE,
                                      p_cod_fase_microtipologia IN t_mcrei_app_delibere.cod_fase_microtipologia%TYPE,
                                      p_v_stralcio_quota_cap    IN t_mcrei_app_delibere.val_stralcio_quota_cap%TYPE,
                                      p_v_stralcio_quota_mora   IN t_mcrei_app_delibere.val_stralcio_quota_mora%TYPE)
    RETURN VARCHAR2 IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.AGGIUNGI_MICROTIPOLOGIA_ST';
    p_note                 t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_params               t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_count                NUMBER;
    v_fase_pacc            t_mcrei_app_delibere.cod_fase_pacchetto%TYPE;
    v_data_pacc            t_mcrei_app_delibere.dta_creazione_pacchetto%TYPE;
    v_uo_pratica           t_mcrei_app_pratiche.cod_uo_pratica%TYPE;
    v_proto_delibera       t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
    v_proto_delibera_pre   t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
    v_microtipologia_delib t_mcrei_app_delibere.cod_microtipologia_delib%TYPE;
    ko                     VARCHAR2(6) := 'ERRORE';
    --> variaile dichiarata ll'interno di pkg_mcrei_gest_delibere.fnc_mcrei_protocollo_delibera
  BEGIN
    p_params := 'abi = ' || p_cod_abi || 'ndg = ' || p_cod_ndg ||
                ' proto_delib_coll = ' || p_proto_delib ||
                ' proto_pacchetto = ' || p_proto_pacchetto ||
                ' microtipologia = ' || p_microtipolo ||
                ' utente inserente = ' || p_ute_inse;
    p_note   := 'Controllo parametri in ingresso: ' || p_params;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_delib IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_microtipolo IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    BEGIN
      p_note := 'Recupero cod_uo_pratica: ' || p_params;

      SELECT cod_uo_pratica
        INTO v_uo_pratica
        FROM t_mcrei_app_pratiche p
       WHERE p.cod_abi = p_cod_abi
         AND p.cod_ndg = p_cod_ndg;
    EXCEPTION
      WHEN OTHERS THEN
        v_uo_pratica := NULL;
    END;

    v_proto_delibera := mcre_own.pkg_mcrei_gest_delibere.
                        fnc_mcrei_protocollo_delibera(v_uo_pratica,
                                                      p_ute_inse,
                                                      p_cod_abi,
                                                      p_cod_ndg);

    IF v_proto_delibera IS NULL OR
       v_proto_delibera = ko
    THEN
      p_note := 'Generazione protocollo delibera non riuscita, uo_pratica = ' ||
                v_uo_pratica || ' , utente_inserente = ' || p_ute_inse ||
                ' , cod_abi  = ' || p_cod_abi || ' , cod_ndg = ' ||
                p_cod_ndg;
      raise_application_error(-20666,
                              'Generazione protocollo delibera non riuscita');
    END IF;

    -- Prima di creare la microtipologia ST,
    -- popolo il valore dello stralcio con eventuale mora sulla delibera appena adempiuta

    UPDATE t_mcrei_app_delibere de
       SET de.val_stralcio_quota_cap  = p_v_stralcio_quota_cap,
           de.val_stralcio_quota_mora = p_v_stralcio_quota_mora
     WHERE de.cod_abi = p_cod_abi
       AND de.cod_ndg = p_cod_ndg
       AND de.cod_protocollo_delibera = p_proto_delib
       AND de.cod_protocollo_pacchetto = p_proto_pacchetto;

    -- controllo esistenza delibera
    BEGIN
      SELECT cod_protocollo_delibera_pre,
             cod_microtipologia_delib
        INTO v_proto_delibera_pre,
             v_microtipologia_delib
        FROM t_mcrei_app_delibere
       WHERE cod_abi = p_cod_abi
         AND cod_ndg = p_cod_ndg
         AND cod_protocollo_delibera_pre = p_proto_delib
         AND cod_microtipologia_delib = 'ST';

      p_note := 'Delibera di Stralcio gia'' presente, ' || p_params;
    EXCEPTION
      WHEN no_data_found THEN
        p_note := p_note || ' Nuova delibere: ' || v_proto_delibera;

        INSERT INTO t_mcrei_app_delibere d
          (id_dper,
           cod_sndg,
           cod_abi,
           cod_ndg,
           cod_protocollo_pacchetto,
           cod_protocollo_delibera,
           cod_protocollo_delibera_pre,
           flg_attiva,
           cod_microtipologia_delib,
           cod_fase_delibera,
           cod_fase_microtipologia,
           cod_fase_pacchetto,
           cod_filiale_delibera,
           cod_macrotipologia_delib,
           cod_matricola_inserente,
           cod_pratica,
           cod_segmento,
           cod_tipo_pacchetto,
           cod_uo_pratica,
           desc_denominaz_ins_delibera,
           dta_creazione_pacchetto,
           dta_ins,
           dta_ins_delibera,
           dta_last_upd_delibera,
           flg_no_delibera,
           val_anno_pratica,
           ------------------------------
           val_esp_lorda,
           val_esp_netta_ante_delib,
           val_esp_netta_post_delib,
           val_imp_perdita,
           val_num_progr_delibera,
           val_rdv_pregr_fi,
           val_rdv_progr_fi,
           val_rdv_qc_ante_delib,
           val_rdv_qc_progressiva,
           val_rinuncia_capitale,
           val_rinuncia_deliberata,
           val_rinuncia_mora,
           val_rinuncia_proposta,
           val_rinuncia_totale,
           val_sacrif_capit_mora,
           val_stralcio_quota_cap,
           val_stralcio_quota_mora,
           val_stralcio_senza_accantonam,
           dta_conferma_delibera,
           dta_conferma_pacchetto,
           cod_organo_pacchetto,
           dta_delibera,
                     COD_ORGANO_dELIBERANTE )----2 OTTOBRE
          SELECT to_number(to_char(trunc(SYSDATE), 'YYYYMMDD')),
                 cod_sndg,
                 cod_abi,
                 cod_ndg,
                 cod_protocollo_pacchetto,
                 v_proto_delibera,
                 p_proto_delib,
                 '1',
                 'ST',
                 'CT',
                 p_cod_fase_microtipologia,
                 cod_fase_pacchetto,
                 cod_filiale_delibera,
                 cod_macrotipologia_delib,
                 cod_matricola_inserente,
                 cod_pratica,
                 cod_segmento,
                 cod_tipo_pacchetto,
                 cod_uo_pratica,
                 desc_denominaz_ins_delibera,
                 dta_creazione_pacchetto,
                 SYSDATE,
                 dta_ins_delibera,
                 SYSDATE,
                 flg_no_delibera,
                 val_anno_pratica,
                 -------------
                 val_esp_lorda,
                 val_esp_netta_ante_delib,
                 val_esp_netta_post_delib,
                 val_imp_perdita, --PERDITA
                 seq_mcrei_prog_del.nextval, --val_num_progr_delibera,
                 val_rdv_pregr_fi,
                 val_rdv_progr_fi,
                 val_rdv_qc_ante_delib,
                 nvl(val_rdv_qc_ante_delib, 0) -
                 nvl(val_stralcio_quota_cap, 0), -- val_rdv_qc_progressiva:solo qta capitale
                 val_rinuncia_capitale,
                 val_rinuncia_deliberata,
                 val_rinuncia_mora,
                 val_rinuncia_proposta,
                 val_rinuncia_totale,
                 (nvl(val_stralcio_quota_cap, 0) +
                 nvl(val_stralcio_quota_mora, 0)), --val_sacrif_capit_mora
                 p_v_stralcio_quota_cap,
                 p_v_stralcio_quota_mora,
                 val_stralcio_senza_accantonam,---- stralci contabilizzati al momento della creazione della delibera precedente
                 dta_conferma_delibera,
                 dta_conferma_pacchetto,
                 cod_organo_pacchetto,
                 dta_delibera,
                                 COD_ORGANO_dELIBERANTE
            FROM t_mcrei_app_delibere d1
           WHERE d1.cod_abi = p_cod_abi
             AND d1.cod_ndg = p_cod_ndg
             AND d1.cod_protocollo_delibera = p_proto_delib;
    END;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            p_ute_inse);
    RETURN v_proto_delibera;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              p_ute_inse);
      RETURN NULL;
  END;

  -- %author Reply
  -- %version 0.1
  -- %d Procedura di archiviazione delle stime che l'utente decide di rivalutare
  -- %d LA rivalutazione puo' dipendere dall'esigenza di correggere i parziali di rettifica
  -- %d o dal fatto che la banca rete abbia controproposto un'altra rettifica da applicare
  -- %cd 23 MAR 2012
  -- %param p_proto_delibera: protocollo della delibera che deve essere rivalutata nei rapporti
  -- %param p_tipo_archiviazione: R -> RIVALUTAZIONE,
  -- %param p_utente:
  FUNCTION archivia_stime(p_proto_delibera     VARCHAR2,
                          p_cod_rapporto       VARCHAR2,
                          p_flg_tipo_dato      VARCHAR2,
                          p_tipo_archiviazione VARCHAR2,
                          p_utente             VARCHAR2,
                          p_flg_estint         VARCHAR2,
                          p_dta_stima          DATE) RETURN NUMBER IS

    v_dt_ins    DATE := NULL;
    p_datastima DATE := NULL;
    c_nome CONSTANT VARCHAR2(100) := c_package || '.ARCHIVIA_STIME';
    p_note   t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_params t_mcrei_wrk_audit_applicativo.note%TYPE;

  BEGIN

    v_dt_ins := SYSDATE;

    /* DELETE t_mcrei_hst_valutazioni t
         WHERE t.cod_protocollo_delibera = p_proto_delibera
           AND t.cod_rapporto = p_cod_rapporto
           AND TRUNC(t.dta_stima) = p_dta_stima;   -- NON S POSSIBILE AVERE DTA_sTIMA  = A QUELLA DELLA APP_sTIME
    */
    INSERT INTO t_mcrei_hst_valutazioni
      (cod_abi,
       cod_classe_ft,
       cod_microtipologia_delibera,
       cod_ndg,
       cod_protocollo_delibera,
       cod_rapporto,
       cod_sndg,
       cod_tipo_rapporto,
       cod_uo_stima,
       cod_utente,
       cod_utente_upd,
       desc_causa_prev_recupero,
       flg_tipo_archiviazione,
       dta_ins,
       dta_stima,
       dta_upd,
       flg_attiva,
       flg_pres_piano,
       flg_recupero_tot,
       flg_ristrutturato,
       flg_tipo_dato,
       id_dper,
       val_accordato,
       val_attualizzato,
       val_esposizione,
       val_imp_prev_att,
       val_imp_prev_pregr,
       val_imp_rettifica_att,
       val_imp_rettifica_pregr,
       val_perc_rett_rapporto,
       val_prev_recupero,
       val_rdv_tot,
       val_utilizzato_mora,
       val_utilizzato_netto,
       dta_archiviazione)
      SELECT cod_abi,
             cod_classe_ft,
             cod_microtipologia_delibera,
             cod_ndg,
             cod_protocollo_delibera,
             cod_rapporto,
             cod_sndg,
             cod_tipo_rapporto,
             cod_uo_stima,
             cod_utente,
             p_utente cod_utente_upd,
             desc_causa_prev_recupero,
             p_tipo_archiviazione flg_tipo_archiviazione,
             SYSDATE,
             trunc(t.dta_stima) dta_stima,
             dta_upd,
             flg_attiva,
             flg_pres_piano,
             flg_recupero_tot,
             flg_ristrutturato,
             flg_tipo_dato,
             id_dper,
             val_accordato,
             val_attualizzato,
             val_esposizione,
             val_imp_prev_att,
             val_imp_prev_pregr,
             val_imp_rettifica_att,
             val_imp_rettifica_pregr,
             val_perc_rett_rapporto,
             val_prev_recupero,
             val_rdv_tot,
             val_utilizzato_mora,
             val_utilizzato_netto,
             v_dt_ins dta_archiviazione
        FROM t_mcrei_app_stime t
       WHERE t.cod_protocollo_delibera = p_proto_delibera
         AND t.cod_rapporto = p_cod_rapporto
            --AND t.flg_tipo_dato = p_flg_tipo_dato --MM
         AND t.flg_attiva = '1' /*
                     AND t.dta_stima = p_dta_stima*/
      ; ---30MAGGIO: ELIMINATA DATA

         pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              'insert into t_mcrei_hst_valutazioni per delibera ' || p_proto_delibera ||
                              ' rapporto ' || p_cod_rapporto,
                              p_utente);

    DELETE t_mcrei_app_stime t
     WHERE t.cod_protocollo_delibera = p_proto_delibera
       AND t.cod_rapporto = p_cod_rapporto
          --AND t.flg_tipo_dato = p_flg_tipo_dato --MM
       AND t.flg_attiva = '1' /*
               AND t.dta_stima = p_dta_stima*/
    ; ---30MAGGIO: ELIMINATA DATA

         pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                              'delete t_mcrei_App_stime per delibera ' || p_proto_delibera ||
                              ' rapporto ' || p_cod_rapporto,
                              p_utente);

    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'delibera ' || p_proto_delibera ||
                              ' rapporto ' || p_cod_rapporto,
                              p_utente);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END archivia_stime;

  -- %author Reply
  -- %version 0.1
  -- %d Procedura di archiviazione delle stime che l'utente decide di rivalutare
  -- %d LA rivalutazione puo' dipendere dall'esigenza di correggere i parziali di rettifica
  -- %d o dal fatto che la banca rete abbia controproposto un'altra rettifica da applicare
  -- %cd 23 MAR 2012
  -- %param p_proto_delibera: protocollo della delibera che deve essere rivalutata nei rapporti
  -- %param p_tipo_archiviazione: R -> RIVALUTAZIONE,
  -- %param p_utente:
  FUNCTION archivia_piano(p_proto_delibera     VARCHAR2,
                          p_cod_rapporto       VARCHAR2,
                          p_tipo_archiviazione VARCHAR2,
                          p_utente             VARCHAR2,
                          p_datastima          DATE) RETURN NUMBER IS
    v_dt_ins DATE := NULL;
    c_nome CONSTANT VARCHAR2(100) := c_package || '.archivia_piano';
    p_note   t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_params t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    v_dt_ins := SYSDATE;

    DELETE t_mcrei_hst_piani_rivalutati h
     WHERE h.cod_rapporto = p_cod_rapporto
       AND h.cod_protocollo_delibera = p_proto_delibera
       AND trunc(h.dta_stima) = trunc(p_datastima);

    -----copia le stime attualmente presenti in tabella relativamente al protocollo_Delibera in input
    INSERT INTO t_mcrei_hst_piani_rivalutati
      (id_dper,
       cod_abi,
       cod_sndg,
       cod_ndg,
       cod_rapporto,
       dta_stima,
       num_rata,
       dta_scadenza_rata,
       val_rata,
       dta_ins_piano,
       dta_upd_piano,
       cod_utente,
       cod_protocollo_delibera,
       flg_attiva,
       dta_ins,
       dta_upd,
       cod_operatore_ins_upd,
       cod_forma_tecnica,
       dta_archiviazione,
       flg_tipo_archiviazione)
      SELECT id_dper,
             cod_abi,
             cod_sndg,
             cod_ndg,
             cod_rapporto,
             p_datastima dta_stima,
             num_rata,
             dta_scadenza_rata,
             val_rata,
             dta_ins_piano,
             dta_upd_piano,
             cod_utente,
             cod_protocollo_delibera,
             flg_attiva,
             dta_ins,
             dta_upd,
             cod_operatore_ins_upd,
             cod_forma_tecnica,
             v_dt_ins,
             p_tipo_archiviazione
        FROM t_mcrei_app_piani_rientro
       WHERE cod_protocollo_delibera = p_proto_delibera
         AND cod_rapporto = p_cod_rapporto
            --AND TRUNC(DTA_STIMA) = TRUNC( v_dt_ins )
         AND flg_attiva = '1';

    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END archivia_piano;

  -- %AUTHOR
  -- %VERSION 0.1
  -- %USAGE  Function che salva i dati di una delibera di Ristrutturazione
  -- %d La function aggiorna i dati presenti sulle Delibere e sulla tabella
  -- %d di storico delle Ristrutturazioni. Se la ristrutturazione non S
  -- %d registrata nello storico, allora viene inserita. La data efficacia
  -- %d non viene popolata. Verra' popolata solo all'atto del congelamento.
  -- %cd 09 MAG 2012
  -- %PARAM P_ABI Not Null
  -- %PARAM P_NDG Not Null
  -- %PARAM P_PROTO_DELIB Not Null
  -- %PARAM P_PROTO_PACCHETTO Not Null
  -- %PARAM P_UTE_INSE
  -- %PARAM P_TIPO_RISTR Dominio T oppure P, T = Totale, P = Parziale
  -- %PARAM P_DESC_INTENTO_RIST Dominio: Y oppure N, Y = Con Intento liquidatorio, N = Senza intento liquidatorio
  FUNCTION popola_man_dett_ristr(p_cod_abi             IN t_mcrei_app_delibere.cod_abi%TYPE,
                                 p_cod_ndg             IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                 p_proto_pacchetto     IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE,
                                 p_proto_delib         IN t_mcrei_app_delibere. cod_protocollo_delibera%TYPE,
                                 p_microtip            IN t_mcrei_app_delibere. cod_microtipologia_delib%TYPE,
                                 p_tipo_ristr          IN t_mcrei_app_delibere.desc_tipo_ristr%TYPE,
                                 p_desc_intento_rist   IN t_mcrei_app_delibere.desc_intento_ristr% TYPE,
                                 p_data_scadenza_ristr IN t_mcrei_app_delibere.dta_scadenza_ristr% TYPE,
                                 p_ute_inse            IN t_mcrei_app_delibere. cod_matricola_inserente%TYPE,
                                 p_salv_or_conf        IN VARCHAR2 DEFAULT 'S')

    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.POPOLA_MAN_DETT_RISTR';
    p_note                t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_params              t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_dta_efficacia_add   DATE := to_date(NULL);
    v_dta_efficacia       DATE := to_date(NULL);
    v_cod_stato_calcolato t_mcrei_app_delibere.cod_stato_proposto%TYPE := 'IN';
    v_proto_pacchetto     t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    v_dta_now             DATE;
    v_ret                 NUMBER;

  BEGIN
    p_params := 'abi = ' || p_cod_abi || 'ndg = ' || p_cod_ndg ||
                ' proto_delibera = ' || p_proto_delib ||
                ' proto_pacchetto = ' || p_proto_pacchetto ||
                ' utente inserente = ' || p_ute_inse;
    p_note   := 'Controllo parametri in input: ' || p_params;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_delib IS NULL OR
       p_proto_pacchetto IS NULL
    THEN
      raise_application_error(-20666, 'Null param');
    END IF;

    --    SELECT SYSDATE INTO v_dta_now FROM DUAL;

    IF p_tipo_ristr = 'T' AND
       p_desc_intento_rist = 'N'
    THEN
      v_cod_stato_calcolato := 'RS';
    END IF;

    BEGIN

      SELECT dta_efficacia_ristr,
             cod_protocollo_pacchetto
        INTO v_dta_efficacia,
             v_proto_pacchetto
        FROM (SELECT dta_efficacia_ristr,
                     cod_protocollo_pacchetto
                FROM t_mcrei_hst_ristrutturazioni
               WHERE cod_abi = p_cod_abi
                 AND cod_ndg = p_cod_ndg
                 AND p_proto_pacchetto = p_proto_pacchetto
               ORDER BY val_ordinale DESC)
       WHERE rownum = 1;

      IF v_proto_pacchetto != p_proto_pacchetto
      THEN
        v_dta_efficacia_add := SYSDATE;
      ELSE
        v_dta_efficacia_add := NULL;
      END IF;
    EXCEPTION
      WHEN no_data_found THEN
        v_dta_efficacia     := SYSDATE;
        v_dta_efficacia_add := NULL;
      ---le date vengono slavate sulla delibere solo in fase di congelamento
    END;

    p_note := 'Update DELIBERE' || p_params;
    UPDATE t_mcrei_app_delibere t
       SET desc_tipo_ristr         = p_tipo_ristr,
           desc_intento_ristr      = p_desc_intento_rist,
           dta_scadenza_ristr      = p_data_scadenza_ristr,
           cod_matricola_inserente = p_ute_inse,
           dta_efficacia_ristr=decode(p_salv_or_conf,'C',v_dta_efficacia,dta_efficacia_ristr),
           dta_efficacia_add=decode(p_salv_or_conf,'C',v_dta_efficacia_add,dta_efficacia_add),
           dta_last_upd_delibera = SYSDATE,
           cod_stato_post_ristr = v_cod_stato_calcolato   --7 marzo
     WHERE t.cod_abi = p_cod_abi
       AND t.cod_ndg = p_cod_ndg
       AND t.cod_protocollo_pacchetto = p_proto_pacchetto
       AND t.flg_ristrutturato IN ('Y', 'y', '1')
       AND t.cod_microtipologia_delib IN
           (SELECT cod_microtipologia
              FROM t_mcrei_cl_tipologie
             WHERE flg_segn_ristr = '1');

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_dett_ristr;

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
  -- %PARAM P_TIPO_RISTR Dominio T oppure P, T = Totale, P = Parziale
  -- %PARAM P_DESC_INTENTO_RIST Dominio: Y oppure N, Y = Con Intento liquidatorio, N = Senza intento liquidatorio
  FUNCTION popola_dett_ristr(p_cod_abi            IN t_mcrei_app_delibere.cod_abi%TYPE,
                             p_cod_ndg            IN t_mcrei_app_delibere.cod_ndg%TYPE,
                             p_proto_pacchetto    IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE,
                             p_proto_delib        IN t_mcrei_app_delibere.cod_protocollo_delibera %TYPE,
                             p_microtip           IN t_mcrei_app_delibere. cod_microtipologia_delib%TYPE,
                             p_tipo_ristr         IN t_mcrei_app_delibere.desc_tipo_ristr%TYPE,
                             p_desc_intento_rist  IN t_mcrei_app_delibere.desc_intento_ristr%TYPE,
                             p_dta_scadenza_ristr IN t_mcrei_app_delibere.dta_scadenza_ristr%TYPE,
                             p_ute_inse           IN t_mcrei_app_delibere.cod_matricola_inserente %TYPE)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.POPOLA_DETT_RISTR';
    p_note                  t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_params                t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_dta_efficacia         DATE;
    v_dta_efficacia_add     DATE;
    v_cod_stato_calcolato   VARCHAR2(2 BYTE) := 'IN';
    v_dta_conferma_delibera DATE := to_date(NULL);
    v_dta_now               DATE := SYSDATE;
    v_cod_stato_proposto    VARCHAR2(2 BYTE);
    v_ret                   NUMBER := PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  BEGIN
    p_params := 'abi = ' || p_cod_abi || ', ndg = ' || p_cod_ndg ||
                ', proto_delibera = ' || p_proto_delib ||
                ', proto_pacchetto = ' || p_proto_pacchetto ||
                ', utente inserente = ' || p_ute_inse;
    p_note   := 'Controllo parametri in input: ' || p_params;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_delib IS NULL OR
       p_proto_pacchetto IS NULL
    THEN
      raise_application_error(-20666, 'Null param');
    END IF;

    IF p_tipo_ristr = 'T' AND
       p_desc_intento_rist = 'N'
    THEN
      v_cod_stato_calcolato := 'RS';
    END IF;

    v_ret := popola_man_dett_ristr(p_cod_abi,
                                   p_cod_ndg,
                                   p_proto_pacchetto,
                                   p_proto_delib,
                                   p_microtip,
                                   p_tipo_ristr,
                                   p_desc_intento_rist,
                                   p_dta_scadenza_ristr,
                                   p_ute_inse,
                                   'C');

    IF v_ret = PKG_MCREI_WEB_UTILITIES.const_esito_ok
    THEN
      v_ret := popola_effic_add_hst_ristr(p_cod_abi,
                                          p_cod_ndg,
                                          p_proto_delib,
                                          p_proto_pacchetto,
                                          p_tipo_ristr,
                                          p_desc_intento_rist,
                                          v_cod_stato_calcolato,
                                          --P_COD_STATO_PROPOSTO,
                                          p_ute_inse,
                                          p_microtip,
                                          NULL,
                                          --P_FLG_RDV, SOLO PER LE DELIBERE DI CHIUSURA
                                          'Y',
                                          'Y',
                                          'Y',
                                          p_dta_scadenza_ristr);
    END IF;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            p_ute_inse);
    RETURN v_ret;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_dett_ristr;

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
  FUNCTION popola_man_dett_rapp_ristr(p_cod_abi         IN t_mcrei_app_delibere.cod_abi%TYPE,
                                      p_cod_ndg         IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                      p_proto_pacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto %TYPE,
                                      p_proto_delib     IN t_mcrei_app_delibere.cod_protocollo_delibera% TYPE,
                                      p_cod_ftecnica    IN t_mcrei_app_stime.cod_forma_tecnica%TYPE,
                                      --???
                                      p_flg_tipo_dato     IN t_mcrei_app_stime.flg_tipo_dato%TYPE,
                                      p_cod_rapporto      IN t_mcrei_app_stime.cod_rapporto%TYPE,
                                      p_flg_ristrutturato IN t_mcrei_app_stime.flg_ristrutturato%TYPE,
                                      p_ute_inse          IN t_mcrei_app_stime.cod_utente%TYPE,
                                      p_salv_or_conf        IN VARCHAR2 DEFAULT 'S')    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.POPOLA_MAN_DETT_RAPP_RISTR';
    p_note                   t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_params                 t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_tot                    NUMBER(1);
    V_COD_NPE                T_MCREI_APP_RAPPORTI_ESTERO.COD_NPE%TYPE:=NULL;
    v_flg_ristr_pre          VARCHAR2(1);
    v_dta_inizio_segn        DATE := NULL;
    v_dta_fine_rist          DATE := NULL;
    v_flg_ristr              VARCHAR2(1);
    v_dta_now                DATE;
    v_ret                    NUMBER := PKG_MCREI_WEB_UTILITIES.const_esito_ok;

  BEGIN
    p_params := 'abi = ' || p_cod_abi || ', ndg = ' || p_cod_ndg ||
                ', proto_delibera = ' || p_proto_delib ||
                ', proto_pacchetto = ' || p_proto_pacchetto ||
                ', codice rapporto = ' || p_cod_rapporto ||
                ', utente inserente = ' || p_ute_inse ||
                ', flg_tipo_dato = ' || p_flg_tipo_dato ||
                ', flg_ristrutturato = ' || p_flg_ristrutturato;
    p_note   := 'Controllo parametri in input: ' || p_params;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_delib IS NULL OR
       p_proto_pacchetto IS NULL
    THEN
      raise_application_error(-20666, 'Null param');
    END IF;

    SELECT trunc(SYSDATE) INTO v_dta_now FROM dual;

    BEGIN
        SELECT COD_NPE
         INTO V_COD_NPE
         FROM T_MCREI_APP_RAPPORTI_ESTERO
        WHERE COD_ABI = P_COD_ABI
          AND COD_NDG = P_COD_NDG
          AND COD_RAPPORTO_ESTERO = P_COD_RAPPORTO;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        V_COD_NPE:=NULL;
    END;

    ---- si effettuano gli ins/upd per tutte le delibere con segnalazione di risutrtturazione
    ---- presenti nel pacchetto IN input

    FOR v IN (SELECT cod_protocollo_delibera, cod_sndg, cod_microtipologia_delib
                FROM t_mcrei_app_delibere g
               WHERE g.cod_abi = p_cod_abi
                 AND g.cod_ndg = p_cod_ndg
                 AND g.cod_protocollo_pacchetto = p_proto_pacchetto
                  AND COD_FASE_PACCHETTO NOT IN ('ANA','ANM')
                 AND flg_attiva = '1'
                 AND g.cod_microtipologia_delib IN
                     (SELECT cod_microtipologia
                        FROM t_mcrei_cl_tipologie
                       WHERE flg_segn_ristr = '1'
                         AND flg_attivo = 1))
    LOOP
      BEGIN

                BEGIN
                SELECT DTA_INIZIO_SEGNALAZIONE_RISTR, DTA_FINE_SEGNALAZIONE_RISTR, flg_ristrutturato
                  INTO v_dta_inizio_segn,v_dta_fine_rist, v_flg_ristr
                  FROM(
                SELECT DTA_INIZIO_SEGNALAZIONE_RISTR, DTA_FINE_SEGNALAZIONE_RISTR,
                        flg_ristrutturato
                  FROM t_mcrei_hst_rapp_ristr
                WHERE cod_abi = p_cod_abi
                  AND cod_ndg = p_cod_ndg
                  AND cod_rapporto = p_cod_rapporto
                ORDER BY val_ordinale DESC NULLS LAST)
               WHERE ROWNUM = 1;

                  IF v_flg_ristr = 'N' THEN
                    IF p_flg_ristrutturato = 'N' THEN
                        v_dta_inizio_segn:= NULL;
                        v_dta_fine_rist:= NULL;
                    ELSE
                        v_dta_inizio_segn:= SYSDATE;
                        v_dta_fine_rist:= NULL;
                    END IF;
                  ELSE -- se l'ultimo rapporto era segnalato come da ristrutturare
                     IF P_FLG_RISTRUTTURATO = 'N' THEN
                            -- v_dta_inizio_segn INVARIATA
                          v_dta_fine_rist:= SYSDATE;

                     ELSE -- SE IL RAPPORTO E' SEGNALATO COME DA RISTRUTTURARE
                        v_dta_fine_rist:= SYSDATE;

                     END IF;
                    END IF;

                  EXCEPTION WHEN NO_DATA_FOUND THEN
                    IF p_flg_ristrutturato = 'N' THEN
                        v_dta_inizio_segn:= NULL;
                        v_dta_fine_rist:= NULL;
                    ELSE
                        v_dta_inizio_segn:= SYSDATE;
                        v_dta_fine_rist:= NULL;
                    END IF;

                  END;

        SELECT flg_ristrutturato
          INTO v_flg_ristr_pre
          FROM t_mcrei_app_stime s
         WHERE s.cod_abi = p_cod_abi
           AND s.cod_ndg = p_cod_ndg
           AND s.cod_rapporto = p_cod_rapporto
           AND s.cod_protocollo_delibera = v.cod_protocollo_delibera
           AND flg_attiva = '1'
           AND rownum = 1;

        p_note := 'Aggiornamento stime, flg_ristrutturato: ' || p_params;
 UPDATE t_mcrei_app_stime s
    SET (s.flg_ristrutturato,
         s.val_esposizione,
         s.val_utilizzato_netto, -- ESPOSIZIONE NETTA
         s.val_utilizzato_mora,
         s.dta_stima,
         s.dta_upd,
         s.cod_utente,
         s.dta_inizio_segnalazione_ristr,
         s.dta_fine_segnalazione_ristr,
         S.COD_NPE) =
        (SELECT DISTINCT p_flg_ristrutturato,
                         decode(ipcr.cod_classe_ft,
                                'CA',
                                nvl(s1.val_esposizione,
                                    ipcr.val_imp_utilizzato),
                                0),
                         decode(ipcr.cod_classe_ft,
                                'CA',
                                nvl(s1.val_esposizione,
                                    ipcr.val_imp_utilizzato) -
                                nvl(ipcr.val_imp_mora, 0),
                                0),
                         nvl(ipcr.val_imp_mora, 0),
                         trunc(SYSDATE),
                         SYSDATE,
                         p_ute_inse,
                         decode(p_salv_or_conf,
                                'C',
                                v_dta_inizio_segn,
                                s.dta_inizio_segnalazione_ristr),
                         decode(p_salv_or_conf,
                                'C',
                                v_dta_fine_rist,
                                s.dta_fine_segnalazione_ristr),
                         NVL(V_COD_NPE, S.COD_NPE)
           FROM (SELECT pcr.cod_rapporto,
                        pcr.cod_abi,
                        pcr.cod_ndg,
                        pcr.cod_classe_ft,
                        SUM(val_imp_utilizzato) over(PARTITION BY pcr.cod_abi, pcr.cod_ndg, pcr.cod_rapporto) AS val_imp_utilizzato,
                        SUM(val_imp_mora) over(PARTITION BY i.cod_abi_cartolarizzato, i.cod_ndg, i.cod_rapporto) AS val_imp_mora,
                        decode((COUNT(DISTINCT pcr.cod_forma_tecnica)
                                over(PARTITION BY pcr.cod_abi,
                                     pcr.cod_ndg,
                                     pcr.cod_rapporto /*,                                                                                                                                                                                                                                                                                                                    f.cod_natura*/)),
                               1,
                               pcr.cod_forma_tecnica,
                               '-')
                   FROM t_mcrei_app_pcr_rapporti pcr,
                        t_mcre0_app_rate_daily   i
                  WHERE pcr.cod_abi = i.cod_abi_cartolarizzato(+)
                    AND pcr.cod_ndg = i.cod_ndg(+)
                    AND pcr.cod_rapporto = i.cod_rapporto(+)
                    AND pcr.cod_abi = p_cod_abi
                    AND pcr.cod_ndg = p_cod_ndg
                    AND pcr.cod_rapporto = p_cod_rapporto) ipcr,
                t_mcrei_app_stime s1
          WHERE s1.cod_abi = ipcr.cod_abi(+)
            AND s1.cod_ndg = ipcr.cod_ndg(+)
            AND s1.cod_rapporto = ipcr.cod_rapporto(+)
            AND s1.cod_abi = p_cod_abi
            AND s1.cod_ndg = p_cod_ndg
            AND s1.cod_rapporto = p_cod_rapporto
            AND s1.cod_protocollo_delibera = p_proto_delib)
  WHERE s.cod_abi = p_cod_abi
    AND s.cod_ndg = p_cod_ndg
    AND s.cod_rapporto = p_cod_rapporto
    AND s.cod_protocollo_delibera = v.cod_protocollo_delibera
    AND s.flg_attiva = '1';

      EXCEPTION
        WHEN no_data_found THEN
          BEGIN
            p_note := 'Inserimento stime ' || p_params;
            INSERT INTO t_mcrei_app_stime
              (cod_abi,
               cod_ndg,
               cod_protocollo_delibera,
               cod_rapporto,
               flg_tipo_dato,
               cod_forma_tecnica,
               flg_ristrutturato,
               dta_inizio_segnalazione_ristr,
               dta_fine_segnalazione_ristr,
               val_esposizione,
               val_utilizzato_netto,
               val_utilizzato_mora,
               dta_stima,
               dta_ins,
               flg_attiva,
               COD_SNDG,
               COD_MICROTIPOLOGIA_DELIBERA,
               COD_NPE
               )
              SELECT DISTINCT p_cod_abi,
                              p_cod_ndg,
                              p_proto_delib,
                              p_cod_rapporto,
                              p_flg_tipo_dato,
                              decode((COUNT(DISTINCT pcr.cod_forma_tecnica)
                       over(PARTITION BY pcr.cod_abi,
                            pcr.cod_ndg,
                            pcr.cod_rapporto /*,                                                                                                                                                                                                                                          f.cod_natura*/)),
                      1,
                      pcr.cod_forma_tecnica,
                      '-') ,--p_cod_ftecnica, --???
                              p_flg_ristrutturato,
                              decode(p_salv_or_conf,'C',v_dta_inizio_segn),
                              decode(p_salv_or_conf,'C',v_dta_fine_rist),
                              SUM(nvl(pcr.val_imp_utilizzato, 0)) over(PARTITION BY pcr.cod_abi, pcr.cod_ndg, pcr.cod_rapporto) AS val_imp_utilizzato,--nvl(pcr.val_imp_utilizzato, 0),
                              SUM (nvl(pcr.val_imp_utilizzato, 0) - nvl(i.val_imp_mora, 0)) over(PARTITION BY pcr.cod_abi, pcr.cod_ndg, pcr.cod_rapporto) ,
                              SUM(nvl(i.val_imp_mora, 0)) over(PARTITION BY pcr.cod_abi, pcr.cod_ndg, pcr.cod_rapporto),
                              SYSDATE,
                              SYSDATE,
                              '1',
                              V.COD_SNDG,
                              V.cod_microtipologia_delib,
                              V_COD_NPE
                FROM t_mcrei_app_pcr_rapporti pcr,
                     t_mcre0_app_rate_daily   i
               WHERE pcr.cod_abi = i.cod_abi_cartolarizzato(+)
                 AND pcr.cod_ndg = i.cod_ndg(+)
                 AND pcr.cod_rapporto = i.cod_rapporto(+)
                                 AND pcr.cod_abi = p_cod_abi  ----AD:aggiunto filtro per posizione il 25 sep
                 AND pcr.cod_ndg = p_cod_ndg
                 AND pcr.cod_rapporto = p_cod_rapporto;

          EXCEPTION
            WHEN dup_val_on_index THEN
              UPDATE t_mcrei_app_stime st
                 SET st.flg_ristrutturato           = p_flg_ristrutturato,
                     st.dta_stima                   = v_dta_now,
                     st.dta_upd                     = v_dta_now,
                     st.cod_utente                  = p_ute_inse,
                     st.dta_fine_segnalazione_ristr = v_dta_inizio_segn,
                     st.dta_fine_segnalazione_ristr = v_dta_fine_rist,
                     ST.COD_NPE                     = NVL(V_COD_NPE,ST.COD_NPE)
               WHERE st.cod_abi = p_cod_abi
                 AND st.cod_ndg = p_cod_ndg
                 AND st.cod_protocollo_delibera = v.cod_protocollo_delibera
                 AND st.cod_rapporto = p_cod_rapporto
                 AND st.flg_tipo_dato = p_flg_tipo_dato;
          END;
      END;

    END LOOP;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            p_ute_inse);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_dett_rapp_ristr;

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
  -- %PARAM P_COD_FTECNICA Not null, quando sara' inserito in chiave
  -- %PARAM P_FLG_TIPO_DATO Not null da togliere quando cod_ftecnica entrera in chiave
  -- %PARAM P_UTE_INSE
  FUNCTION popola_dett_rapp_ristr(p_cod_abi         IN t_mcrei_app_delibere. cod_abi%TYPE,
                                  p_cod_ndg         IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                  p_proto_pacchetto IN t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
                                  p_proto_delib     IN t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
                                  p_cod_ftecnica    IN t_mcrei_app_stime.cod_forma_tecnica%TYPE,
                                  --???
                                  p_flg_tipo_dato     IN t_mcrei_app_stime.flg_tipo_dato%TYPE,
                                  p_cod_rapporto      IN t_mcrei_app_stime.cod_rapporto%TYPE,
                                  p_flg_ristrutturato IN t_mcrei_app_stime.flg_ristrutturato%TYPE,
                                  p_ute_inse          IN t_mcrei_app_stime.cod_utente%TYPE,
                                  p_flg_da_alert      IN t_mcrei_hst_rapp_ristr.flg_da_alert%TYPE DEFAULT 'N')
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.POPOLA_DETT_RAPP_RISTR';
    p_note            t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_params          t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_dta_inizio_segn DATE;
    v_dta_fine_rist   DATE := to_date(NULL);
    v_val_ordinale    NUMBER := NULL;
    v_ret             NUMBER := const_esito_ok;
    v_flg_estinto     VARCHAR2(1) := 'N';
    v_flg_ristr       VARCHAR2(1) := 'N';
    v_desc_tipo_ristr t_mcrei_hst_ristrutturazioni.desc_tipo_ristr%TYPE;

  BEGIN
    p_params := 'abi = ' || p_cod_abi || ', ndg = ' || p_cod_ndg ||
                ', proto_delibera = ' || p_proto_delib ||
                ', proto_pacchetto = ' || p_proto_pacchetto ||
                ', codice rapporto = ' || p_cod_rapporto ||
                ', utente inserente = ' || p_ute_inse;
    p_note   := 'Controllo parametri in input: ' || p_params;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_delib IS NULL OR
       p_proto_pacchetto IS NULL
    THEN
      raise_application_error(-20666, 'Null param');
    END IF;

    p_note := 'Aggiornamento stime, flg_ristrutturato: ' || p_params;
    v_ret  := popola_man_dett_rapp_ristr(p_cod_abi,
                                         p_cod_ndg,
                                         p_proto_pacchetto,
                                         p_proto_delib,
                                         p_cod_ftecnica,
                                         p_flg_tipo_dato,
                                         p_cod_rapporto,
                                         p_flg_ristrutturato,
                                         p_ute_inse,
                                         'C');

    -- CALCOLA L'ORDINALE
    BEGIN
      SELECT val_ordinale,
             desc_tipo_ristr
        INTO v_val_ordinale,
             v_desc_tipo_ristr
        FROM (SELECT val_ordinale,
                     desc_tipo_ristr
                FROM t_mcrei_hst_ristrutturazioni
               WHERE cod_abi = p_cod_abi
                 AND cod_ndg = p_cod_ndg
               ORDER BY val_ordinale DESC)
       WHERE rownum = 1;

    EXCEPTION
      WHEN no_data_found THEN
        p_note := 'Nessuna ristrutturazione per ' || 'abi = ' || p_cod_abi ||
                  ', ndg = ' || p_cod_ndg ||
                  ': chiamare prima popola_dett_ristr per crearla';
        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_debug,
                                SQLCODE,
                                SQLERRM,
                                p_note,
                                p_ute_inse);
        RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
    END;

    -- CALCOLO FLG_ESTINTO solo per ristrutturazioni parziali?
    -- 2) Rapporto estinto ==> non c'e' su PCR
    IF v_desc_tipo_ristr = 'P'
    THEN
      p_note := 'Ristrutturazione parziale, ricerca rapporti estinti ' ||
                p_params;
      BEGIN
        SELECT 'N'
          INTO v_flg_estinto
          FROM t_mcrei_app_stime        s,
               t_mcrei_app_pcr_rapporti pcr
         WHERE s.cod_abi = pcr.cod_abi
           AND s.cod_ndg = pcr.cod_ndg
           AND s.cod_rapporto = pcr.cod_rapporto
           AND s.cod_abi = p_cod_abi
           AND s.flg_attiva = '1'
           AND s.cod_ndg = p_cod_ndg
           AND s.cod_rapporto = p_cod_rapporto
           AND rownum = 1;

      EXCEPTION
        WHEN no_data_found THEN
          v_flg_estinto := 'Y';
      END;

      IF v_flg_estinto = 'Y'
      THEN
        -- NUOVO ORDINALE --> SOLO NEL BATCH
        p_note := 'Rapporto estinto ' || p_params;
        BEGIN
          SELECT dta_inizio_segnalazione_ristr,
                 dta_fine_segnalazione_ristr,
                 flg_ristrutturato
            INTO v_dta_inizio_segn,
                 v_dta_fine_rist,
                 v_flg_ristr
            FROM (SELECT dta_inizio_segnalazione_ristr,
                         dta_fine_segnalazione_ristr,
                         flg_ristrutturato
                    FROM t_mcrei_hst_rapp_ristr
                   WHERE cod_abi = p_cod_abi
                     AND cod_ndg = p_cod_ndg
                     AND cod_rapporto = p_cod_rapporto
                   ORDER BY val_ordinale DESC NULLS LAST)
           WHERE rownum = 1;

          IF v_flg_ristr = 'Y'
          THEN
            --        v_dta_inizio_segn     quella dell'ultimo record
            v_dta_fine_rist := SYSDATE;

          END IF;

          INSERT INTO t_mcrei_hst_rapp_ristr
            (id_dper,
             cod_abi,
             cod_sndg,
             cod_ndg,
             cod_rapporto,
             dta_stima,
             val_esposizione,
             flg_tipo_dato,
             cod_utente,
             cod_protocollo_delibera_padre,
             flg_attiva,
             dta_ins,
             cod_classe_ft,
             flg_ristrutturato,
             cod_microtipologia_delibera,
             flg_tipo_rapporto,
             cod_forma_tecnica,
             dta_inizio_segnalazione_ristr,
             dta_fine_segnalazione_ristr,
             flg_da_alert,
             val_ordinale,
             flg_estinto)
            SELECT s.id_dper,
                   s.cod_abi,
                   s.cod_sndg,
                   s.cod_ndg,
                   s.cod_rapporto,
                   s.dta_stima,
                   s.val_esposizione,
                   s.flg_tipo_dato,
                   s.cod_utente,
                   p_proto_delib,
                   '1',
                   SYSDATE,
                   s.cod_classe_ft,
                   p_flg_ristrutturato,
                   s.cod_microtipologia_delibera,
                   s.flg_tipo_rapporto,
                   s.cod_forma_tecnica,
                   v_dta_inizio_segn,
                   v_dta_fine_rist,
                   p_flg_da_alert,
                   v_val_ordinale,
                   v_flg_estinto
              FROM t_mcrei_app_stime s, t_mcrei_app_rapporti_estero re
             WHERE s.cod_abi = p_cod_abi
               AND s.cod_ndg = p_cod_ndg
               AND s.cod_protocollo_delibera = p_proto_delib
               AND s.cod_rapporto = p_cod_rapporto
               AND s.cod_abi = re.cod_abi(+)
               AND s.cod_ndg = re.cod_ndg(+)
               AND s.cod_rapporto = re.cod_rapporto_estero(+)
               AND rownum = 1;
        EXCEPTION
          WHEN no_data_found THEN
            NULL;

        END;
      END IF;

    END IF;

    IF v_flg_estinto = 'N'
    THEN
      -- ESPLICITO INVECE CHE ELSE, SE NON E' ESTINTO
      BEGIN
        p_note := 'Rapporto non estinto ' || p_params;
        SELECT dta_inizio_segnalazione_ristr,
               dta_fine_segnalazione_ristr,
               flg_ristrutturato
          INTO v_dta_inizio_segn,
               v_dta_fine_rist,
               v_flg_ristr
          FROM (SELECT dta_inizio_segnalazione_ristr,
                       dta_fine_segnalazione_ristr,
                       flg_ristrutturato
                  FROM t_mcrei_hst_rapp_ristr
                 WHERE cod_abi = p_cod_abi
                   AND cod_ndg = p_cod_ndg
                   AND cod_rapporto = p_cod_rapporto
                 ORDER BY val_ordinale DESC NULLS LAST)
         WHERE rownum = 1;

        IF v_flg_ristr = 'N'
        THEN
          IF p_flg_ristrutturato = 'N'
          THEN
            v_dta_inizio_segn := NULL;
            v_dta_fine_rist   := NULL;
          ELSE
            v_dta_inizio_segn := SYSDATE;
            v_dta_fine_rist   := NULL;
          END IF;

        ELSE
          -- se l'ultimo rapporto era segnalato come da ristrutturare
          IF p_flg_ristrutturato = 'N'
          THEN
            -- v_dta_inizio_segn INVARIATA
            v_dta_fine_rist := SYSDATE;
          ELSE
            -- SE IL RAPPORTO E' SEGNALATO COME DA RISTRUTTURARE
            v_dta_fine_rist := NULL; ---17 LUG
          END IF;
        END IF;

        INSERT INTO t_mcrei_hst_rapp_ristr
          (id_dper,
           cod_abi,
           cod_sndg,
           cod_ndg,
           cod_rapporto,
           dta_stima,
           val_esposizione,
           flg_tipo_dato,
           cod_utente,
           cod_protocollo_delibera_padre,
           flg_attiva,
           dta_ins,
           cod_classe_ft,
           flg_ristrutturato,
           cod_microtipologia_delibera,
           flg_tipo_rapporto,
           cod_forma_tecnica,
           dta_inizio_segnalazione_ristr,
           dta_fine_segnalazione_ristr,
           flg_da_alert,
           val_ordinale,
           flg_estinto,
           cod_npe)
          SELECT s.id_dper,
                 s.cod_abi,
                 s.cod_sndg,
                 s.cod_ndg,
                 s.cod_rapporto,
                 s.dta_stima,
                 s.val_esposizione,
                 s.flg_tipo_dato,
                 s.cod_utente,
                 p_proto_delib,
                 '1',
                 SYSDATE,
                 s.cod_classe_ft,
                 p_flg_ristrutturato,
                 s.cod_microtipologia_delibera,
                 s.flg_tipo_rapporto,
                 s.cod_forma_tecnica,
                 v_dta_inizio_segn,
                 v_dta_fine_rist,
                 p_flg_da_alert,
                 v_val_ordinale,
                 v_flg_estinto,
                 re.cod_npe
            FROM t_mcrei_app_stime s, t_mcrei_app_rapporti_estero re
           WHERE s.cod_abi = p_cod_abi
             AND s.cod_ndg = p_cod_ndg
             AND s.cod_protocollo_delibera = p_proto_delib
             AND s.cod_rapporto = p_cod_rapporto
             AND s.cod_abi = re.cod_abi(+)
             AND s.cod_ndg = re.cod_ndg(+)
             AND s.cod_rapporto = re.cod_rapporto_estero(+)
             AND rownum = 1;

      EXCEPTION
        WHEN no_data_found THEN
          IF p_flg_ristrutturato = 'N'
          THEN
            v_dta_inizio_segn := NULL;
            v_dta_fine_rist   := NULL;
          ELSE
            v_dta_inizio_segn := SYSDATE;
            v_dta_fine_rist   := NULL;
          END IF;

          INSERT INTO t_mcrei_hst_rapp_ristr
            (id_dper,
             cod_abi,
             cod_sndg,
             cod_ndg,
             cod_rapporto,
             dta_stima,
             val_esposizione,
             flg_tipo_dato,
             cod_utente,
             cod_protocollo_delibera_padre,
             flg_attiva,
             dta_ins,
             cod_classe_ft,
             flg_ristrutturato,
             cod_microtipologia_delibera,
             flg_tipo_rapporto,
             cod_forma_tecnica,
             dta_inizio_segnalazione_ristr,
             dta_fine_segnalazione_ristr,
             flg_da_alert,
             val_ordinale,
             flg_estinto,
             cod_npe)
            SELECT s.id_dper,
                   s.cod_abi,
                   s.cod_sndg,
                   s.cod_ndg,
                   s.cod_rapporto,
                   s.dta_stima,
                   s.val_esposizione,
                   s.flg_tipo_dato,
                   s.cod_utente,
                   p_proto_delib,
                   '1',
                   SYSDATE,
                   s.cod_classe_ft,
                   p_flg_ristrutturato,
                   s.cod_microtipologia_delibera,
                   s.flg_tipo_rapporto,
                   s.cod_forma_tecnica,
                   v_dta_inizio_segn,
                   v_dta_fine_rist,
                   p_flg_da_alert,
                   v_val_ordinale,
                   v_flg_estinto,
                   re.cod_npe
              FROM t_mcrei_app_stime s, t_mcrei_app_rapporti_estero re
             WHERE s.cod_abi = p_cod_abi
               AND s.cod_ndg = p_cod_ndg
               AND s.cod_protocollo_delibera = p_proto_delib
               AND s.cod_rapporto = p_cod_rapporto
               AND s.cod_abi = RE.COD_ABI(+)
               and s.cod_ndg = re.cod_ndg(+)
               and s.cod_rapporto = re.cod_rapporto_estero(+)
               AND rownum = 1;

      END;
    END IF;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            p_ute_inse);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_dett_rapp_ristr;

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
  FUNCTION popola_dett_del_ch_ristr(p_cod_abi         IN t_mcrei_app_delibere.cod_abi%TYPE,
                                    p_cod_ndg         IN t_mcrei_app_delibere.cod_ndg%TYPE,
                                    p_proto_pacchetto IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE,
                                    p_proto_delibera  IN t_mcrei_app_delibere.cod_protocollo_delibera %TYPE,
                                    -- chiusura di ristrutturazione
                                    p_cod_microtipologia IN t_mcrei_app_delibere. cod_microtipologia_delib%TYPE,
                                    p_causale_chiusura   IN t_mcrei_app_delibere. cod_causa_chius_delibera%TYPE,
                                    p_stato_post_ristr   IN VARCHAR2 DEFAULT NULL,
                                    p_desc_note          IN t_mcrei_app_delibere.desc_note%TYPE,
                                    p_ute_inse           IN t_mcrei_app_delibere.cod_matricola_inserente %TYPE,
                                    -------------------------------------------------------------------------------------
                                    p_tipo_ristr         IN VARCHAR2 DEFAULT NULL,
                                    p_intento_ristr      IN VARCHAR2 DEFAULT NULL,
                                    p_dta_scadenza_ristr IN DATE DEFAULT NULL,
                                    p_flg_rdv            IN VARCHAR2)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_DETT_DEL_CH_RISTR';
    p_note          t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_data_eff_rist DATE;
    p_params        t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_dta_now       DATE;
  BEGIN
    p_params := p_cod_abi || ', ' || p_cod_ndg || ', ' || p_proto_pacchetto || ', ' ||
                p_proto_delibera;
    p_note   := 'Controllo parametri input: ' || p_params;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    SELECT SYSDATE INTO v_dta_now FROM dual;

    p_note := 'POPOLA_DETT_DEL_CH_RISTR: Salvataggio dati della vista V_MCREI_APP_DATI_DETT_CHIUS SU DELIBERE' ||
              p_params;

    p_note := 'POPOLA_DETT_DEL_CH_RISTR: update valori Delibere; ' ||
              p_params;

    UPDATE t_mcrei_app_delibere tar
       SET (
            COD_STATO_proposto,
            cod_causa_chius_delibera,
            val_accordato,
            val_accordato_derivati,
            val_esp_lorda,
            val_uti_sosti_scsb,
            flg_ristr_ereditata,
            desc_note,
            flg_rdv) =
           (SELECT DISTINCT p_stato_post_ristr,
                            p_causale_chiusura,
                            nvl(decode(cod_fase_delibera,
                                       'IN',
                                       p.scsb_acc_tot,
                                       d.val_accordato),
                                0) AS val_totale_accordato,
                            nvl(decode(cod_fase_delibera,
                                       'IN',
                                       p.scsb_acc_sostituzioni,
                                       d.val_accordato_derivati),
                                0) AS val_accordato_derivati,
                            nvl(decode(cod_fase_delibera,
                                       'IN',
                                       p.scsb_uti_tot,
                                       d.val_esp_lorda),
                                0) AS val_totale_utilizzato,
                            nvl(decode(cod_fase_delibera,
                                       'IN',
                                       p.scsb_uti_sostituzioni,
                                       d.val_uti_sosti_scsb),
                                0) AS val_totale_utilizzato_derivati,
                            decode(d.cod_protocollo_delibera,
                                   p_proto_delibera,
                                   'Y',
                                   'N') AS flg_ristr_ereditata, -- 08/05/2012
                            p_desc_note AS desc_note,
                            p_flg_rdv
              FROM t_mcrei_app_delibere      d,
--                   t_mcre0_app_all_data      f,
                   t_mcrei_app_pcr_rapp_aggr p
--                   t_mcrei_cl_tipologie      t1,
--                   t_mcrei_cl_tipologie      t2,
--                   t_mcrei_app_pratiche      a,
--                   t_mcrei_cl_domini         do,
--                   t_mcrei_app_pareri        pa,
--                   t_mcrei_cl_domini         do1,
--                   t_mcrei_cl_domini         do2
             WHERE d.cod_abi = p_cod_abi
               AND d.cod_ndg = p_cod_ndg
               AND d.cod_protocollo_delibera = p_proto_delibera
--               AND d.cod_abi = f.cod_abi_cartolarizzato
--               AND d.cod_ndg = f.cod_ndg
               AND d.flg_attiva = '1'
                  --AND d.cod_microtipologia_delib = 'CH'
               AND d.cod_abi = p.cod_abi_cartolarizzato(+)
               AND d.cod_ndg = p.cod_ndg(+)
               AND d.cod_fase_pacchetto NOT IN ('ANA', 'ANM')
--               AND d.cod_abi = a.cod_abi
--               AND d.cod_ndg = a.cod_ndg
--               AND a.flg_attiva = '1'
--               AND d.cod_protocollo_delibera = pa.cod_protocollo_delibera(+)
--               AND d.cod_abi = pa.cod_abi(+)
--               AND d.cod_ndg = pa.cod_ndg(+)
--               AND pa.flg_attiva(+) = '1'
--               AND a.cod_tipo_gestione = do.val_dominio
--               AND do.cod_dominio = 'TIPO_GESTIONE'
--               AND d.cod_causa_chius_delibera = do1.val_dominio(+)
--               AND do1.cod_dominio(+) = 'CAUSALE_CHIUSURA'
--               AND d.cod_causa_chius_delibera = do2.val_dominio(+)
--               AND do2.cod_dominio(+) = 'CAUSALE_CHIUSURA_RISTR'
--               AND d.cod_microtipologia_delib = t1.cod_microtipologia
--               AND t1.flg_attivo = 1
--               AND d.cod_macrotipologia_delib = t2.cod_macrotipologia
--               AND t2.flg_attivo = 1
               )
     WHERE tar.cod_abi = p_cod_abi
       AND tar.cod_ndg = p_cod_ndg
       AND tar.cod_protocollo_delibera = p_proto_delibera;
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_dett_del_ch_ristr;

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
                                   p_utente      VARCHAR2) RETURN NUMBER IS

    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.chiudi_ristrutturazione';
    p_note          t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_data_eff_rist DATE;
    p_params        t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_dta_now       DATE;
    v_val_ordinale  NUMBER;
    v_dta_efficacia_ristr   DATE:=NULL;
    v_dta_efficacia_add     DATE:=NULL;

  BEGIN
    p_params := p_abi || ', ' || p_ndg || ', ' || p_proto_delib;
    p_note   := 'Controllo parametri input: ' || p_params;

    IF p_abi IS NULL OR
       p_ndg IS NULL OR
       p_proto_delib IS NULL OR
       p_utente IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    BEGIN
        SELECT DTA_EFFICACIA_RISTR,DTA_EFFICACIA_ADD
          INTO v_dta_efficacia_ristr,
                v_dta_efficacia_add
          FROM(
        SELECT DTA_EFFICACIA_RISTR,DTA_EFFICACIA_ADD
          FROM T_MCREI_HST_RISTRUTTURAZIONI
         WHERE COD_ABI = P_ABI
           AND COD_NDG = P_NDG
        ORDER BY VAL_ORDINALE DESC)
        WHERE ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_dta_efficacia_ristr:=NULL;
        v_dta_efficacia_add:=NULL;
    END;


    SELECT SYSDATE INTO v_dta_now FROM dual;

    p_note := 'CHIUDI_RISTRUTTURAZIONE: chiusura ristrutturazione sulla delibera' ||p_params;
    IF v_dta_efficacia_ristr IS NULL AND v_dta_efficacia_add IS NULL THEN
        P_NOTE:='Nessuna ristrutturazione precedente per '||p_params;
    END IF;
    UPDATE t_mcrei_app_delibere d
       SET d.dta_chiusura_ristr      = v_dta_now,
           d.cod_matricola_inserente = p_utente
     WHERE d.cod_abi = p_abi
       AND d.cod_ndg = p_ndg
       AND d.cod_protocollo_delibera = p_proto_delib
       AND cod_fase_delibera != 'AN'
       AND flg_attiva = '1';

    p_note := 'CHIUDI_RISTRUTTURAZIONE: chiusura ristrutturazione sulla hst_ristrutturazioni' ||
              p_params;

    SELECT SEQ_MCREI_HST_RISTRUTTURAZIONI.NEXTVAL
      INTO V_VAL_ORDINALE
      FROM DUAL;

    -- SOLO QUI SI STORICIZZA: record uguale alla delibera gi? presente  16/07/2012
    INSERT INTO t_mcrei_hst_ristrutturazioni
      (cod_abi,
       cod_ndg,
       cod_protocollo_delibera,
       cod_protocollo_pacchetto,
       desc_tipo_ristr,
       desc_intento_ristr,
       dta_efficacia_ristr,
       dta_efficacia_add,
       dta_scadenza_ristr,
       cod_stato_proposto,
       dta_chiusura_ristr,
       cod_matricola_inserente,
       cod_causale_ch_ristr,
       cod_microtipologia_delib,
       flg_rdv,
       val_ordinale)
      SELECT cod_abi,
             cod_ndg,
             cod_protocollo_delibera,
             cod_protocollo_pacchetto,
             desc_tipo_ristr,
             desc_intento_ristr,
             v_dta_efficacia_ristr,
             v_dta_efficacia_add,
             dta_scadenza_ristr,
             cod_stato_proposto,-- 21 agosto: sostituito cod_stato_post_ristr,
             v_dta_now,
             cod_matricola_inserente,
             cod_causa_chius_delibera,
             cod_microtipologia_delib,
             flg_rdv,
             v_val_ordinale
        FROM t_mcrei_app_delibere
       WHERE cod_abi = p_abi
         AND cod_ndg = p_ndg
         AND cod_protocollo_delibera = p_proto_delib
         AND flg_attiva = '1';

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);

    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END chiudi_ristrutturazione;

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
                                        p_proto_pacchetto    IN t_mcrei_app_delibere. cod_protocollo_pacchetto%TYPE,
                                        p_proto_delibera     IN t_mcrei_app_delibere.cod_protocollo_delibera %TYPE,
                                        p_cod_microtipologia IN t_mcrei_app_delibere. cod_microtipologia_delib%TYPE,
                                        p_causale_chiusura   IN t_mcrei_app_delibere. cod_causa_chius_delibera%TYPE,
                                        p_stato_post_ristr   IN VARCHAR2 DEFAULT NULL,
                                        p_desc_note          IN t_mcrei_app_delibere.desc_note%TYPE,
                                        p_ute_inse           IN t_mcrei_app_delibere.cod_matricola_inserente %TYPE,
                                        -------------------------------------------------------------------------------------
                                        p_tipo_ristr         IN VARCHAR2 DEFAULT NULL,
                                        p_intento_ristr      IN VARCHAR2 DEFAULT NULL,
                                        p_dta_scadenza_ristr IN DATE DEFAULT NULL,
                                        p_flg_rdv            IN VARCHAR2)
    RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.POPOLA_MAN_DETT_DEL_CH_RISTR';
    p_note              t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_data_eff_rist     DATE;
    v_microtipologia    t_mcrei_app_delibere.cod_microtipologia_delib%TYPE;
    v_dta_efficacia     DATE;
    p_params            t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_dta_now           DATE;
    p_val_ordinale      NUMBER;
    v_cod_proto_del_pre t_mcrei_app_delibere.cod_protocollo_delibera%TYPE := NULL;
  BEGIN
    p_params := p_cod_abi || ', ' || p_cod_ndg || ', ' || p_proto_pacchetto || ', ' ||
                p_proto_delibera;
    p_note   := 'Controllo parametri input ' || p_params;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_pacchetto IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    SELECT SYSDATE INTO v_dta_now FROM dual;



    p_note := 'Update DELIBERE: ' || p_params;
    UPDATE t_mcrei_app_delibere t  ------eliminato campi 13 lug
       SET --t.desc_tipo_ristr          = p_tipo_ristr,
           --t.desc_intento_ristr       = p_intento_ristr,
           --t.dta_scadenza_ristr       = p_dta_scadenza_ristr,
           t.cod_matricola_inserente  = p_ute_inse,
           t.dta_last_upd_delibera    = v_dta_now,
           --t.dta_efficacia_ristr      = nvl(v_dta_efficacia, v_dta_now),
           t.cod_causa_chius_delibera = p_causale_chiusura,
           t.COD_STATO_proposto     = nvl(p_stato_post_ristr,
                                            t.COD_STATO_proposto),
           t.desc_note                = p_desc_note,
           t.flg_rdv                  = p_flg_rdv
     WHERE t.cod_abi = p_cod_abi
       AND t.cod_ndg = p_cod_ndg
       AND t.cod_protocollo_delibera = p_proto_delibera;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN PKG_MCREI_WEB_UTILITIES.const_esito_ko;
  END popola_man_dett_del_ch_ristr;

  -- %AUTHOR REPLY
  -- %VERSION 0.2
  -- %USAGE  FUNZIONE CHE MODIFICA L'ABILITAZIONE DELLA DELIBERA INDICATA IN INPUT
  -- %D  LA FUNZIONE, PER IL PACCHETTO IN INPUT, SETTA PER LA DELIBERA CORRISPONDENTE
  -- %D  AL PROTOCOLLO DELIBERA IN INPUT IL FLAG DI ABILITAZIONE IN INPUT
  -- %CD 09 MAG
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
                           p_utente         IN VARCHAR2) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package || '.setta_flg_ristr';
    p_note t_mcrei_wrk_audit_applicativo.note%TYPE;

    v_proto_delib t_mcrei_app_delibere.cod_protocollo_delibera%TYPE := '-1';

  BEGIN
    p_note := 'SETTA FLG_RISTRUTTURATO SU DELIBERA';

    IF p_abi IS NULL OR
       p_ndg IS NULL OR
       p_prot_pacchetto IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    UPDATE t_mcrei_app_delibere g
       SET g.flg_ristrutturato     = p_flg_ristr,
           g.dta_last_upd_delibera = SYSDATE
     WHERE g.cod_abi = p_abi
       AND g.cod_protocollo_pacchetto = p_prot_pacchetto
       AND g.cod_microtipologia_delib IN (
                                          -- di microtipologia censita in T_MCREI_CL_TIPOLOGIE
                                          SELECT cod_microtipologia
                                          -- con flg_segn_ristr = '1' 09/05/2012
                                            FROM t_mcrei_cl_tipologie
                                           WHERE flg_segn_ristr = '1'
                                             AND flg_attivo = 1);
    -- aggiorna tutte le delibere per abi del pacchetto

    --inizializzo i dettagli ristrutturazione qualora ne esista gia' una
    --    if p_flg_ristr = 'Y' then
    --        --select

    --    UPDATE t_mcrei_app_delibere d
    --       SET (d.desc_tipo_ristr,
    --            d.desc_intento_ristr,
    --            d.dta_efficacia_ristr,
    --            d.dta_efficacia_add,
    --            d.dta_scadenza_ristr,
    --            d.cod_stato_proposto,
    --            d.dta_chiusura_ristr) =
    --           (SELECT desc_tipo_ristr,
    --                   desc_intento_ristr,
    --                   dta_efficacia_ristr,
    --                   dta_efficacia_add,
    --                   dta_scadenza_ristr,
    --                   cod_stato_proposto,
    --                   dta_chiusura_ristr
    --              FROM t_mcrei_hst_ristrutturazioni
    --             WHERE cod_abi = p_abi
    --               AND cod_ndg = p_ndg
    --               AND cod_protocollo_delibera = v_proto_delib)
    --     WHERE d.cod_abi = p_abi
    --       AND d.cod_ndg = p_ndg
    --       and d.cod_protocollo_delibera = p_prot_delib;

    --    end if;
    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            'abi: ' || p_abi || 'pacchetto: ' ||
                            p_prot_pacchetto || 'flag: ' || p_flg_ristr,
                            p_utente);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ko;
  END setta_flg_ristr;
  -------------------------------------------------------------------------------------------------------------------

  -- DTA_EFFICACIA_ADD VERRA' POPOLATA SOLO SE DIVERSA DA NULL
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
    RETURN NUMBER IS
    p_val_ordinale NUMBER:=0;

  BEGIN

    SELECT seq_mcrei_hst_ristrutturazioni.nextval
      INTO p_val_ordinale
      FROM dual;

    INSERT INTO t_mcrei_hst_ristrutturazioni
      (cod_abi,
       cod_ndg,
       cod_protocollo_delibera,
       cod_protocollo_pacchetto,
       desc_tipo_ristr,
       desc_intento_ristr,
       dta_efficacia_ristr,
       dta_efficacia_add,
       cod_stato_proposto,
       cod_matricola_inserente,
       flg_rdv,
       dta_chiusura_ristr,
       val_ordinale,
       dta_scadenza_ristr,
       cod_microtipologia_delib)
    VALUES
      (p_cod_abi,
       p_cod_ndg,
       p_cod_protocollo_delibera,
       p_cod_protocollo_pacchetto,
       p_desc_tipo_ristr,
       p_desc_intento_ristr,
       v_dta_effic, --P_DTA_EFFICACIA_RISTR,
       v_dta_efficacia_add,
       p_cod_stato_proposto,
       p_cod_matricola_ins,
       p_flg_rdv,
       v_dta_chiusura_ristr,
       p_val_ordinale,
       p_dta_scadenza,
       p_cod_microtipologia_delib);
    RETURN p_val_ordinale;         -- 30.07
  END insert_hst_ristrutturazioni;

  -- V_DTA_CHIUSURA_RISTR SOLO DALLE FUNZIONI PER LE RISTRUTTURAZIONI
  -- RETURNS SQL%ROWCOUNT POST UPDATE
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
    RETURN NUMBER IS

    v_ret NUMBER;

  BEGIN
    -- propagazione per posizione all'interno del paccehtto 06.07
    UPDATE t_mcrei_hst_ristrutturazioni t
       SET t.desc_tipo_ristr     = p_desc_tipo_ristr,
           t.desc_intento_ristr  = p_desc_intento_ristr,
           t.dta_efficacia_ristr = nvl(t.dta_efficacia_ristr,
                                       v_dta_efficacia_ristr),
           t.dta_efficacia_add   = decode(t.dta_efficacia_add,
                                          to_date(NULL),
                                          to_date(NULL),
                                          v_dta_efficacia_add),
           -- DATA_EFFICACIA_ADDENDUM
           t.cod_stato_proposto       = nvl(p_cod_stato_proposto,
                                            t. cod_stato_proposto),
           t.cod_matricola_inserente  = p_cod_matricola_ins,
           t.flg_rdv                  = nvl(p_flg_rdv, t.flg_rdv),
           t.dta_chiusura_ristr       = v_dta_chiusura_ristr,
           t.dta_scadenza_ristr       = nvl(p_dta_scadenza,
                                            t. dta_scadenza_ristr),
           t.cod_microtipologia_delib = p_cod_microtipologia_delib
     WHERE t.cod_abi = p_cod_abi
       AND t.cod_ndg = p_cod_ndg
       AND t.cod_protocollo_pacchetto = p_cod_protocollo_pacchetto
       AND t.cod_microtipologia_delib IN
           (SELECT cod_microtipologia
              FROM t_mcrei_cl_tipologie
             WHERE flg_segn_ristr = '1'
               AND flg_attivo = 1);
    v_ret := SQL%ROWCOUNT;
    RETURN v_ret;

  END update_hst_ristrutturazioni;

  -- agisce solo su hst_ristrutturazioni
  -- algoritmo: PER delibera NON di chiusura:
  -- Se NON esiste posizione su T_MCREI_HST_RISTRUTTURAZIONI
  -- -- inserisci nuovo record con DTA_EFFICACIA_RISTR = SYSDATE + salva parametri passati per argomento (*)
  -- Se esiste posizione su T_MCREI_HST_RISTRUTTURAZIONI
  -- -- Se l'ultima delibera NON E' di chiusura
  -- -- -- DTA_EFFICACIA_RISTR = DTA_EFFICACIA_RISTR_ultima; DTA_EFFICACIA_ADD = SYSDATE (**)
  -- -- Se l'ultima delibera S di chiusura
  -- -- -- inserisci nuovo record con DTA_EFFICACIA_RISTR = SYSDATE + salva parametri passati per argomento (*)
  -- -- Se la delibera di chiusura non S l'ultima, avendo recuperato l'ultima delibera
  -- -- -- -- DTA_EFFICACIA_RISTR = DTA_EFFICACIA_RISTR_ultima; DTA_EFFICACIA_ADD = SYSDATE (**)

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
    RETURN NUMBER IS

    c_nome CONSTANT VARCHAR2(100) := c_package ||
                                     '.popola_effic_add_hst_ristr';
    p_note                     t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_params                   t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_dta_efficacia_ristr      t_mcrei_hst_ristrutturazioni. dta_efficacia_ristr%TYPE;
    v_dta_now                  DATE;
    v_dta_flg_upd              DATE;
    v_dta_flg_ins              DATE;
    v_dta_flg_ris              DATE;
    v_dta_efficacia_add        DATE;
    v_dta_chiusura_ristr       DATE;
    v_ret                      NUMBER;
    v_ret_l2                   NUMBER;
    v_cod_protocollo_delibera  t_mcrei_hst_ristrutturazioni. cod_protocollo_delibera%TYPE;
    v_cod_protocollo_pacchetto t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
    v_microtip                 t_mcrei_app_delibere.cod_microtipologia_delib%TYPE;

  BEGIN
    p_params := 'COD_ABI                 : ' || p_cod_abi ||
                'COD_NDG                 : ' || p_cod_ndg ||
                'COD_PROTOCOLLO_DELIBERA : ' || p_cod_protocollo_delibera ||
                'COD_PROTOCOLLO_PACCHETTO: ' || p_cod_protocollo_pacchetto ||
                'FLG_TIPO_RISTR          : ' || p_desc_tipo_ristr ||
                'FLG_INTENTO_RISTR       : ' || p_desc_intento_ristr ||
                'COD_STATO_PROPOSTO      : ' || p_cod_stato_proposto ||
                'COD_MATRICOLA_INS       : ' || p_cod_matricola_ins ||
                'COD_MICROTIPOLOGIA_DELIB: ' || p_cod_microtipologia_delib ||
                'FLG_RDV                 : ' || p_flg_rdv;
    p_note   := 'CONTROLLO PARAMETRI';

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_cod_protocollo_delibera IS NULL OR
       p_cod_protocollo_pacchetto IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    SELECT SYSDATE INTO v_dta_now FROM dual;

    SELECT decode(p_flg_upd_add, 'Y', v_dta_now) --Y
      INTO v_dta_flg_upd
      FROM dual;

    SELECT decode(p_flg_ins_add, 'Y', v_dta_now) --Y
      INTO v_dta_flg_ins
      FROM dual;

    SELECT decode(p_flg_pop_ris, 'Y', nvl(v_dta_efficacia_ristr, v_dta_now))
      INTO v_dta_flg_ris
      FROM dual;

    BEGIN

      p_note := 'Ricerca per posizione su T_MCREI_HST_RISTRUTTURAZIONI';
      SELECT dta_efficacia_ristr,
             dta_chiusura_ristr,
             dta_efficacia_add,
             cod_microtipologia_delib,
             cod_protocollo_pacchetto
        INTO v_dta_efficacia_ristr,
             v_dta_chiusura_ristr,
             v_dta_efficacia_add,
             v_microtip,
             v_cod_protocollo_pacchetto -- si va per protocollo pacchetto 6.07
        FROM (SELECT dta_efficacia_ristr,
                     dta_chiusura_ristr,
                     dta_efficacia_add,
                     cod_microtipologia_delib,
                     cod_protocollo_delibera,
                     cod_protocollo_pacchetto
                FROM t_mcrei_hst_ristrutturazioni
               WHERE cod_abi = p_cod_abi
                 AND cod_ndg = p_cod_ndg
               ORDER BY val_ordinale DESC NULLS LAST)
       WHERE rownum = 1;

      p_note := 'Esiste posizione su T_MCREI_HST_RISTRUTTURAZIONI';

      IF v_microtip != 'B8' OR
         v_microtip IS NULL
      THEN

        IF v_cod_protocollo_pacchetto = p_cod_protocollo_pacchetto
        THEN
          p_note := 'L''ultima posizione non E'' di chiusura, update T_MCREI_HST_RISTRUTTURAZIONI';
          v_ret  := update_hst_ristrutturazioni(p_dta_scadenza,
                                                p_cod_abi,
                                                p_cod_ndg,
                                                p_cod_protocollo_delibera,
                                                p_cod_protocollo_pacchetto,
                                                p_desc_tipo_ristr,
                                                p_desc_intento_ristr,
                                                p_cod_stato_proposto,
                                                p_cod_matricola_ins,
                                                p_cod_microtipologia_delib,
                                                p_flg_rdv,
                                                v_dta_flg_ris,
                                                v_dta_flg_upd); -- senza addendum
        ELSE
          p_note := 'L''ultima posizione non E'' di chiusura, inserimento T_MCREI_HST_RISTRUTTURAZIONI';

          BEGIN
            v_ret_l2 := insert_hst_ristrutturazioni(p_dta_scadenza,
                                                    p_cod_abi,
                                                    p_cod_ndg,
                                                    p_cod_protocollo_delibera,
                                                    p_cod_protocollo_pacchetto,
                                                    p_desc_tipo_ristr,
                                                    p_desc_intento_ristr,
                                                    p_cod_stato_proposto,
                                                    p_cod_matricola_ins,
                                                    p_cod_microtipologia_delib,
                                                    p_flg_rdv,
                                                    v_dta_efficacia_ristr,
                                                    v_dta_flg_ins); -- DTA_EFFICACIA_ADD;
          END;

        END IF;

      ELSE
        p_note := 'L''ULTIMA POSIZIONE E'' DI CHIUSURA';

        v_ret := insert_hst_ristrutturazioni(p_dta_scadenza,
                                             p_cod_abi,
                                             p_cod_ndg,
                                             p_cod_protocollo_delibera,
                                             p_cod_protocollo_pacchetto,
                                             p_desc_tipo_ristr,
                                             p_desc_intento_ristr,
                                             p_cod_stato_proposto,
                                             p_cod_matricola_ins,
                                             p_cod_microtipologia_delib,
                                             p_flg_rdv,
                                             v_dta_flg_ris); -- SENZA ADDENDUM

      END IF;

    EXCEPTION
      WHEN no_data_found THEN
        p_note := 'NON esiste posizione su T_MCREI_HST_RISTRUTTURAZIONI';
        v_ret  := insert_hst_ristrutturazioni(p_dta_scadenza,
                                              p_cod_abi,
                                              p_cod_ndg,
                                              p_cod_protocollo_delibera,
                                              p_cod_protocollo_pacchetto,
                                              p_desc_tipo_ristr,
                                              p_desc_intento_ristr,
                                              p_cod_stato_proposto,
                                              p_cod_matricola_ins,
                                              p_cod_microtipologia_delib,
                                              p_flg_rdv,
                                              v_dta_flg_ris); -- SENZA ADDENDUM

    END;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            p_note || '____' || p_params,
                            p_cod_matricola_ins);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note || '____' || p_params,
                              NULL);
      RETURN const_esito_ko;
  END popola_effic_add_hst_ristr;

  -- %AUTHOR REPLY
  -- %VERSION 0.2
  -- %USAGE  FUNZIONE INDICA LA PRESENZA O MENO DI UNA RISTRUTTURAZIONE IN CORSO PER LA POSIZIONE IN INPUT
  -- %CD 05 GIU
  -- %RETURN -> 1: ESISTE, 0: NON ESISTE, -1: ERRORE DELLA FUNCTION
  FUNCTION esiste_ristrutturazione(p_cod_abi IN VARCHAR2,
                                   p_cod_ndg IN VARCHAR2) RETURN NUMBER IS
    v_dta_chius DATE;
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.ESISTE_RISTRUTTURAZIONE';
    p_note   t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_params t_mcrei_wrk_audit_applicativo.note%TYPE;
  BEGIN
    p_params := 'ABI :' || p_cod_abi || ', NDG: ' || p_cod_ndg;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    BEGIN
      p_note := 'Controllo se esiste una posizione con ristrutturazione non chiusa';
      SELECT dta_chiusura_ristr
        INTO v_dta_chius
        FROM (SELECT dta_chiusura_ristr
                FROM t_mcrei_hst_ristrutturazioni
               WHERE cod_abi = p_cod_abi
                 AND cod_ndg = p_cod_ndg
               ORDER BY val_ordinale DESC NULLS LAST)
       WHERE rownum = 1;
    EXCEPTION
      WHEN no_data_found THEN
        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_error,
                                SQLCODE,
                                SQLERRM,
                                p_note || '____' || p_params,
                                NULL);

        RETURN 0;
    END;

    IF v_dta_chius IS NOT NULL
    THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note || '____' || p_params,
                              NULL);
      RETURN 0;
    END IF;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_error,
                            SQLCODE,
                            SQLERRM,
                            p_note || '____' || p_params,
                            NULL);
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note || '____' || p_params,
                              NULL);
      RETURN - 1;
  END esiste_ristrutturazione;

  /*
     Recupera il protocollo  della delibera precedente a quella di chiusura passata
     per argomento. Se esisre duplica tutte le stime assocciate al protocollo precedente
     e le inserisce con P_PROTO_DELIBERA.

     P_PROTO_DELIBERA Codice protocollo delibera di chiusura
  */
  FUNCTION duplica_rapporti_ristr(p_cod_abi        IN t_mcrei_app_stime.cod_abi%TYPE,
                                  p_cod_ndg        IN t_mcrei_app_stime.cod_ndg%TYPE,
                                  p_proto_delibera IN t_mcrei_app_stime.cod_protocollo_delibera%TYPE)
    RETURN NUMBER IS

    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.duplica_RAPPORTI_RISTR';
    p_note             t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_data_eff_rist    DATE;
    p_params           t_mcrei_wrk_audit_applicativo.note%TYPE;
    v_dta_now          DATE;
    v_protoc_delib_pre t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
  BEGIN
    p_params := p_cod_abi || ', ' || p_cod_ndg || ', ' || p_proto_delibera;
    p_note   := 'Controllo parametri input: ' || p_params;

    IF p_cod_abi IS NULL OR
       p_cod_ndg IS NULL OR
       p_proto_delibera IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    BEGIN
      SELECT cod_protocollo_delibera
        INTO v_protoc_delib_pre
        FROM (SELECT cod_protocollo_delibera
                FROM t_mcrei_hst_ristrutturazioni
               WHERE cod_abi = p_cod_abi
                 AND cod_ndg = p_cod_ndg
                 AND dta_chiusura_ristr IS NULL
               ORDER BY val_ordinale DESC NULLS LAST)
       WHERE rownum = 1;

      -- SE EVENTUALMENTE ESISTONO STIME ASSOCIATE
      -- AL PROTOCOLLO DELIBERA DI CHIUSURA VENGONO CANCELLATE
      DELETE FROM t_mcrei_app_stime
       WHERE cod_abi = p_cod_abi
         AND cod_ndg = p_cod_ndg
         AND cod_protocollo_delibera = p_proto_delibera;
      p_note := 'INSERIMENTO duplicaTI STIME DELLA DELIBERA PRECENDENTE; ' ||
                p_params;
      -- INSERISCO LE STIME "duplicaTE"
      INSERT INTO t_mcrei_app_stime
        (id_dper,
         cod_abi,
         cod_sndg,
         cod_ndg,
         cod_rapporto,
         dta_stima,
         desc_causa_prev_recupero,
         flg_recupero_tot,
         cod_uo_stima,
         val_imp_prev_pregr,
         val_imp_prev_att,
         val_prev_recupero,
         val_esposizione,
         val_rdv_tot,
         val_imp_rettifica_pregr,
         val_imp_rettifica_att,
         flg_tipo_dato,
         cod_utente,
         val_attualizzato,
         flg_pres_piano,
         cod_tipo_rapporto,
         cod_protocollo_delibera,
         flg_attiva,
         dta_ins,
         dta_upd,
         cod_operatore_ins_upd,
         cod_classe_ft,
         flg_ristrutturato,
         val_utilizzato_netto,
         val_utilizzato_mora,
         val_perc_rett_rapporto,
         val_accordato,
         cod_microtipologia_delibera,
         cod_npe,
         flg_tipo_rapporto,
         cod_forma_tecnica,
         dta_inizio_segnalazione_ristr,
         dta_fine_segnalazione_ristr,
         dta_decorrenza_stato)
        SELECT to_number(to_char(SYSDATE, 'YYYYMMDD')) AS id_dper,
               cod_abi,
               cod_sndg,
               cod_ndg,
               cod_rapporto,
               dta_stima,
               desc_causa_prev_recupero,
               flg_recupero_tot,
               cod_uo_stima,
               val_imp_prev_pregr,
               val_imp_prev_att,
               val_prev_recupero,
               val_esposizione,
               val_rdv_tot,
               val_imp_rettifica_pregr,
               val_imp_rettifica_att,
               flg_tipo_dato,
               cod_utente,
               val_attualizzato,
               flg_pres_piano,
               cod_tipo_rapporto,
               p_proto_delibera, -- COD_PROTOCOLLO_DELIBERA DI CHIUSURA
               flg_attiva,
               dta_ins,
               dta_upd,
               cod_operatore_ins_upd,
               cod_classe_ft,
               flg_ristrutturato,
               val_utilizzato_netto,
               val_utilizzato_mora,
               val_perc_rett_rapporto,
               val_accordato,
               cod_microtipologia_delibera,
               cod_npe,
               flg_tipo_rapporto,
               cod_forma_tecnica,
               dta_inizio_segnalazione_ristr,
               dta_fine_segnalazione_ristr,
               dta_decorrenza_stato
          FROM t_mcrei_app_stime
         WHERE cod_abi = p_cod_abi
           AND cod_ndg = p_cod_ndg
           AND cod_protocollo_delibera = v_protoc_delib_pre; -- COD_PROTOCOLLO_DELIBERA PASSATA PER ARGOMENTO
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note,
                              NULL);
      RETURN const_esito_ok;
    EXCEPTION
      WHEN no_data_found THEN
        p_note := 'Non esiste alcuna delibera che non e'' di chiusura su TMCREI_HST_RISTRUTTURAZIONI per: ' ||
                  p_params;
        pkg_mcrei_audit.log_app(c_nome,
                                pkg_mcrei_audit.c_error,
                                SQLCODE,
                                SQLERRM,
                                p_note,
                                NULL);
        RETURN const_esito_ko;
    END;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note || '____' || p_params,
                              NULL);
      RETURN const_esito_ko;

  END duplica_rapporti_ristr;

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
    RETURN NUMBER IS
    p_note   t_mcrei_wrk_audit_applicativo.note%TYPE;
    p_params t_mcrei_wrk_audit_applicativo.note%TYPE;
    c_nome CONSTANT VARCHAR2(100) := PKG_MCREI_WEB_UTILITIES.c_package ||
                                     '.SETTA_FLG_RAPP_RISTR_CHIUSURA';
    v_dta_now      DATE;
    v_dta_chiusura DATE := NULL;
    v_val_ordinale NUMBER := -1;

  BEGIN
    p_params := p_abi || ', ' || p_ndg || ', ' || p_prot_delib;
    p_note   := 'Controllo parametri input: ' || p_params;

    IF p_abi IS NULL OR
       p_ndg IS NULL OR
       p_prot_delib IS NULL
    THEN
      raise_application_error(-20666, 'Null parameter');
    END IF;

    ---recupera dalla hst_ristrutturazioni la data di chiusura
    ---dell'ultimo record per la posizione corrente
    ---(dta_fine_segnalaz= dta_chiusura
    /* UPDATE t_mcrei_app_stime
      SET flg_ristrutturato = 'N',
          DTA_FINE_SEGNALAZIONE = <DATA CHIUSURA RECUPERATA AL PASSO PRIMA>
          dta_upd           = SYSDATE
    WHERE cod_abi = p_abi
      AND cod_ndg = p_ndg
      AND cod_protocollo_delibera = p_prot_delib
      AND flg_ristrutturato = 'Y';*/
    BEGIN
      SELECT dta_chiusura_ristr,
             val_ordinale
        INTO v_dta_chiusura,
             v_val_ordinale
        FROM (SELECT dta_chiusura_ristr,
                     val_ordinale
                FROM t_mcrei_hst_ristrutturazioni
               WHERE cod_abi = p_abi
                 AND cod_ndg = p_ndg
               ORDER BY val_ordinale DESC)
       WHERE rownum = 1;

      UPDATE t_mcrei_app_stime
         SET flg_ristrutturato           = 'N',
             dta_fine_segnalazione_ristr = v_dta_chiusura,
             dta_upd                     = SYSDATE
       WHERE cod_abi = p_abi
         AND cod_ndg = p_ndg
         AND cod_protocollo_delibera = p_prot_delib
         AND flg_ristrutturato = 'Y';

      INSERT INTO t_mcrei_hst_rapp_ristr
        (id_dper,
         cod_abi,
         cod_sndg,
         cod_ndg,
         cod_rapporto,
         dta_stima,
         desc_causa_prev_recupero,
         flg_recupero_tot,
         cod_uo_stima,
         val_imp_prev_pregr,
         val_imp_prev_att,
         val_prev_recupero,
         val_esposizione,
         val_rdv_tot,
         val_imp_rettifica_pregr,
         val_imp_rettifica_att,
         flg_tipo_dato,
         cod_utente,
         val_attualizzato,
         flg_pres_piano,
         cod_tipo_rapporto,
         cod_protocollo_delibera_padre,
         flg_attiva,
         dta_ins,
         dta_upd,
         cod_operatore_ins_upd,
         cod_classe_ft,
         flg_ristrutturato,
         val_utilizzato_netto,
         val_utilizzato_mora,
         val_perc_rett_rapporto,
         val_accordato,
         cod_microtipologia_delibera,
         cod_npe,
         flg_tipo_rapporto,
         cod_forma_tecnica,
         dta_inizio_segnalazione_ristr,
         dta_fine_segnalazione_ristr,
         dta_decorrenza_stato,
         flg_da_alert,
         val_ordinale,
         flg_estinto)
        SELECT id_dper,
               cod_abi,
               cod_sndg,
               cod_ndg,
               cod_rapporto,
               dta_stima,
               desc_causa_prev_recupero,
               flg_recupero_tot,
               cod_uo_stima,
               val_imp_prev_pregr,
               val_imp_prev_att,
               val_prev_recupero,
               val_esposizione,
               val_rdv_tot,
               val_imp_rettifica_pregr,
               val_imp_rettifica_att,
               flg_tipo_dato,
               cod_utente,
               val_attualizzato,
               flg_pres_piano,
               cod_tipo_rapporto,
               cod_protocollo_delibera,
               flg_attiva,
               SYSDATE,
               NULL,
               cod_operatore_ins_upd,
               cod_classe_ft,
               flg_ristrutturato,
               val_utilizzato_netto,
               val_utilizzato_mora,
               val_perc_rett_rapporto,
               val_accordato,
               cod_microtipologia_delibera,
               cod_npe,
               flg_tipo_rapporto,
               cod_forma_tecnica,
               dta_inizio_segnalazione_ristr,
               dta_fine_segnalazione_ristr,
               dta_decorrenza_stato,
               'N',
               v_val_ordinale,
               'N'
          FROM t_mcrei_app_stime
         WHERE cod_abi = p_abi
           AND cod_ndg = p_ndg
           AND cod_protocollo_delibera = p_prot_delib
           AND flg_attiva = '1';
    EXCEPTION
      WHEN no_data_found THEN
        p_note := 'Nessuna ristrutturazione trovata per ' || p_params ||
                  chr(10) ||
                  'Controllare l''esito della function chiudi_ristrutturazione';
    END;
    /*INSERISCO NUOVO BLOCCO DI RAPPORTI RISTRUTTURATI CON LO STESSO ORDINALE
    DELLA RISTRUTTURAZIONE B8 APPENA INSERITA
    FINE_SEGNALAZIONE = DTA_CHUSURA RECUPERATA COME SOPRA*/
    RETURN const_esito_ok;

    pkg_mcrei_audit.log_app(c_nome,
                            pkg_mcrei_audit.c_error,
                            SQLCODE,
                            SQLERRM,
                            p_note,
                            NULL);
    RETURN const_esito_ok;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              p_note || '____' || p_params,
                              NULL);
      RETURN const_esito_ko;

  END setta_flg_rapp_ristr_chiusura;

END PKG_MCREI_WEB_UTILITIES;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_WEB_UTILITIES FOR MCRE_OWN.PKG_MCREI_WEB_UTILITIES;


CREATE SYNONYM MCRE_USR.PKG_MCREI_WEB_UTILITIES FOR MCRE_OWN.PKG_MCREI_WEB_UTILITIES;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_WEB_UTILITIES TO MCRE_USR;

