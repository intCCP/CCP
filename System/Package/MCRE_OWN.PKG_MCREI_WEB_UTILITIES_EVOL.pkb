CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCREI_WEB_UTILITIES_EVOL
AS
   /******************************************************************************
   NAME:       PKG_MCREI_WEB_UTILITIES_EVOL
   PURPOSE:
   f
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/09/2012                    Created this package body.
   1.1        21/01/2014   T.Bernardi       Modificate le fnc FNC_ANNULLA_PAC_MODIFICATO, FNC_ANNULLA_PAC_MODIFICATO con aggiunta campi annullo delibera
   IN PRODUZIONE ESEGUIRE PRIMA:
   ALTER TABLE T_MCREI_APP_DELIBERE ADD
   (COD_FASE_MICROTIP_PRE_ADD VARCHAR2(5),
   COD_FASE_DELIB_PRE_ADD VARCHAR2(2),
   COD_PACCHETTO_MODIFICATO VARCHAR2(30),
   COD_MICROTIP_VARIAZIONE VARCHAR2(200),
   COD_DELIBERA_MODIFICATO VARCHAR2(17)
   );

   ******************************************************************************/


   -- %AUTHOR REPLY
   -- %VERSION 0.2
   -- %USAGE  FUNZIONE CHE MODIFICA UN PACCHETTO E LO CLONA
   -- %PARAM p_cod_protocollo_delibera:
   -- %PARAM p_cod_protocollo_pacchetto
   -- %PARAM p_cod_pacchetto_modificato
   -- %PARAM P_ELENCO_FLAG

   -- %CD 14 SET
   -- %RETURN -> COD_PROTOCOLLO_PACCHETTO ESECUZIONE COMPLETATA CON SUCCESSO: NULL ERRORE DELLA FUNCTION


   FUNCTION fnc_modifica_fasi (
      p_cod_abi                     t_mcrei_app_delibere.cod_abi%TYPE,
      p_cod_ndg                     t_mcrei_app_delibere.cod_ndg%TYPE,
      p_cod_sndg                    t_mcrei_app_delibere.cod_sndg%TYPE,
      p_cod_protocollo_delibera     t_mcrei_app_delibere.cod_protocollo_delibera%TYPE,
      p_utente_ins                  VARCHAR2,
      p_elenco_flag                 VARCHAR2,
      p_cod_protocollo_pacchetto    t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE DEFAULT NULL,
      p_flg_sostituzione            VARCHAR2 DEFAULT NULL --Deve valere 1 per sostituzioni
                                                         )
      RETURN VARCHAR2
   IS
      p_note                       t_mcrei_wrk_audit_applicativo.note%TYPE;
      p_nome_fun                   VARCHAR2 (50) := 'fnc_modifica_fasi';
      p_param                      VARCHAR2 (200)
         :=    ' abi: '
            || p_cod_abi
            || ' ndg: '
            || p_cod_ndg
            || ' sndg'
            || p_cod_sndg
            || ' protocollo_delibera: '
            || p_cod_protocollo_delibera
            || ' utente_ins '
            || p_utente_ins
            || ' elenco_flag '
            || p_elenco_flag
            || ' protocollo_pacchetto: '
            || p_cod_protocollo_pacchetto;

      v_prot_pac_new               t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
      v_cod_prot_pac_old           t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
      v_cod_microtipologia_delib   t_mcrei_app_delibere.cod_microtipologia_delib%TYPE;
      v_cod_uo                     t_mcrei_app_pratiche.cod_uo_pratica%TYPE;
      v_proto_delib                t_mcrei_app_delibere.cod_protocollo_delibera%TYPE;
   BEGIN
      BEGIN
         SELECT cod_protocollo_pacchetto
           INTO v_cod_prot_pac_old
           FROM t_mcrei_app_delibere
          WHERE     cod_abi = p_cod_abi
                AND cod_ndg = p_cod_ndg
                AND cod_protocollo_delibera = p_cod_protocollo_delibera;

         SELECT cod_microtipologia_delib
           INTO v_cod_microtipologia_delib
           FROM t_mcrei_app_delibere
          WHERE     cod_abi = p_cod_abi
                AND cod_ndg = p_cod_ndg
                AND cod_protocollo_delibera = p_cod_protocollo_delibera;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_app (
               pkg_mcrei_web_utilities.c_package || p_nome_fun,
               3,
               SQLCODE,
               SQLERRM,
               p_note || p_param,
               NULL);
            RETURN TO_CHAR (NULL);
      END;

      IF (p_cod_protocollo_pacchetto IS NULL) --Se e' la prima volta che chiamo la funzione:
      THEN
         --creo il protocollo per il pacchetto clone:
         SELECT p_cod_sndg || '_' || mcre_own.seq_mcrei_pacchetto.NEXTVAL
           INTO v_prot_pac_new
           FROM DUAL;

         UPDATE t_mcrei_app_delibere           --update per tutto il pacchetto
            SET COD_FASE_PACCHETTO =
                   DECODE (NVL (p_flg_sostituzione, '0'),
                           '0', 'VAR',
                           '1', 'SST'),
                COD_PACCHETTO_SERVIZIO = v_prot_pac_new
          WHERE cod_protocollo_pacchetto = v_cod_prot_pac_old;
      ELSE
         v_prot_pac_new := p_cod_protocollo_pacchetto;
      END IF;

      BEGIN
         SELECT p.cod_uo_pratica
           INTO v_cod_uo
           FROM t_mcrei_app_pratiche p
          WHERE     p.cod_abi = p_cod_abi
                AND p.cod_ndg = p_cod_ndg
                AND flg_attiva = '1'
                AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_cod_uo := NULL;
      END;

      v_proto_delib :=
         mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_protocollo_delibera (
            v_cod_uo,
            p_utente_ins,
            p_cod_abi,
            p_cod_ndg);

      --UPDATE
      UPDATE t_mcrei_app_delibere --update per tutte le delibere che hanno la stessa microtipologia della delibera passata
         SET COD_FASE_MICROTIPOLOGIA =
                DECODE (NVL (p_flg_sostituzione, '0'),
                        '0', 'VAR',
                        '1', 'SST'),
             COD_FASE_MICROTIP_PRE_ADD = COD_FASE_MICROTIPOLOGIA
       WHERE cod_microtipologia_delib = v_cod_microtipologia_delib
             AND cod_protocollo_pacchetto = v_cod_prot_pac_old;

      --update vecchia delibera che passa in stato variato (o sostituito):
      UPDATE T_MCREI_APP_DELIBERE
         SET COD_FASE_DELIBERA =
                DECODE (NVL (p_flg_sostituzione, '0'),
                        '0', 'VA',
                        '1', 'AS'),
             COD_FASE_DELIB_PRE_ADD = COD_FASE_DELIBERA,
             COD_DELIBERA_SERVIZIO = v_proto_delib
       WHERE     cod_abi = p_cod_abi
             AND cod_ndg = p_cod_ndg
             AND cod_protocollo_delibera = p_cod_protocollo_delibera;


      --creazione nuova delibera clonata:
      INSERT INTO t_mcrei_app_delibere (id_dper,
                                        cod_sndg,
                                        cod_protocollo_pacchetto, -- v_prot_pac_new
                                        cod_abi,
                                        cod_ndg,
                                        cod_protocollo_delibera, --v_proto_delib
                                        cod_pratica,
                                        val_anno_pratica,
                                        cod_macrotipologia_delib,
                                        cod_microtipologia_delib, -- vecchia microtipologia
                                        cod_fase_delibera,               -- IN
                                        cod_fase_microtipologia,         --INS
                                        cod_fase_pacchetto,             -- INS
                                        cod_causa_chius_delibera,
                                        cod_filiale_delibera,
                                        cod_matricola_inserente,
                                        --   cod_organo_calcolato,
                                        --  cod_organo_deliberante,
                                        cod_organo_deliberato,
                                        --   cod_organo_pacchetto,
                                        cod_protocollo_delibera_col,
                                        cod_segmento,
                                        cod_tipo_transazione,
                                        cod_uo_pratica,
                                        desc_denominaz_ins_delibera,
                                        desc_note,
                                        desc_note_delibere_annullate,
                                        desc_note_rdv,
                                        desc_parere_sndg,
                                        desc_tipo_conferma_delibera,
                                        dta_conferma_delibera,
                                        dta_creazione_pacchetto,
                                        -- dta_delibera ,
                                        dta_delibera_estero,
                                        dta_ingresso_rdv_servizio,
                                        dta_conferma_pacchetto,
                                        dta_scadenza,
                                        dta_scadenza_estero,
                                        dta_scadenza_transaz,
                                        dta_last_upd_delibera,
                                        dta_upd_fase_delibera,
                                        dta_upd_fase_microtipologia,
                                        dta_upd_fase_pacchetto,
                                        flg_art_136,
                                        flg_attiva,
                                        flg_delib_in_linea,
                                        flg_no_colleg_altre_pos,
                                        flg_no_garanzie_capienti,
                                        flg_no_patrimon_aggred,
                                        flg_no_presupposti_class_soff,
                                        flg_no_rischi_firma,
                                        flg_parti_correlate,
                                        flg_perdur_difficolta_econ,
                                        flg_visionato,
                                        val_esp_lorda,
                                        val_esp_lorda_capitale,
                                        val_esp_lorda_mora,
                                        val_esp_netta_ante_delib,
                                        val_esp_netta_post_delib,
                                        val_imp_offerto,
                                        val_imp_perdita,
                                        val_interessi_futuri,
                                        val_perc_perd_rm,
                                        val_perc_rdv,
                                        val_perc_rdv_estero,
                                        val_perdita_attuale,
                                        val_perdita_deliberata,
                                        val_progr_proposta,
                                        val_rdv_qc_ante_delib,
                                        val_rdv_qc_deliberata,
                                        val_rdv_qc_progressiva,
                                        val_rdv_quota_mora,
                                        val_rinuncia_capitale,
                                        val_rinuncia_deliberata,
                                        val_rinuncia_mora,
                                        val_rinuncia_proposta,
                                        val_rdv_extra_delibera,
                                        val_stralcio_senza_accantonam,
                                        val_stralcio_quota_cap,
                                        val_stralcio_quota_mora,
                                        val_tasso_base_appl,
                                        val_anno_proposta,
                                        dta_ins_delibera,
                                        val_sacrif_capit_mora,
                                        cod_tipo_pacchetto,
                                        dta_ins,
                                        dta_upd,
                                        cod_operatore_ins_upd,
                                        val_perc_dubbio_esito,
                                        cod_intest_sched_gen,
                                        cod_matricola_conf_propos,
                                        cod_stato_proposto,
                                        cod_uo_proponente,
                                        cod_uo_proposta,
                                        desc_anag_deliberante,
                                        desc_anag_proponente,
                                        desc_garanzie_accanton,
                                        desc_liv_last_delib_fido,
                                        desc_note_annullo_prop,
                                        desc_ramo_affari,
                                        desc_rischi_indiretti,
                                        dta_accensione_prop_rischio,
                                        dta_consolid_prop_org_vig,
                                        dta_delib_prop_da_deliberante,
                                        dta_delib_prop_da_proponente,
                                        dta_inizio_rapporto_cliente,
                                        dta_last_delibera_fido,
                                        dta_revoca_fido_in_essere,
                                        dta_superam_stato_rischio,
                                        dta_trasfer_propo_fil_area,
                                        flg_cancellaz_proposta,
                                        flg_disposizione,
                                        note_last_delib_fido,
                                        val_accordato,
                                        val_accordato_derivati,
                                        val_esp_tot_cassa,
                                        val_imp_crediti_firma,
                                        val_imp_fondi_terzi,
                                        val_imp_fondi_terzi_nb,
                                        val_imp_utilizzo,
                                        val_interessi_mora_cassa,
                                        flg_no_delibera,                   --0
                                        dta_congelamento,
                                        val_uti_tot_scsb,
                                        val_uti_tot_gegb,
                                        val_uti_cassa_scsb,
                                        val_uti_firma_scsb,
                                        val_uti_sosti_scsb,
                                        flg_100,
                                        flg_depositi_collaterali,
                                        flg_soggetto_pot_fallibile,
                                        flg_presen_covenants,
                                        flg_interven_organi_superiori,
                                        flg_affidam_soc_recupero,
                                        dta_rif_dati_contabili,
                                        val_rischi_indiretti,
                                        desc_tipo_gestione,
                                        flg_fondo_terzi,
                                        val_uti_netto_fondo_terzi,
                                        desc_motivo_pass_rischio,
                                        cod_stato_provenienza,
                                        val_num_progr_delibera,
                                        flg_to_copy,
                                        dta_udienza_ver_cred,
                                        flg_esist_debitore_sotto_proc,
                                        flg_beni_non_in_garanzia,
                                        flg_avviso_ex498cpc,
                                        flg_pignoramenti_immobiliari,
                                        flg_pignoramenti_mobiliari,
                                        flg_pignoramenti_terzi,
                                        flg_protesti,
                                        flg_ipoteche_beni_deb_gar,
                                        flg_garanzie_sgfa,
                                        flg_garanzie_sace,
                                        flg_garanzie_con_fidi,
                                        flg_garanzie_genworth,
                                        flg_pratica_urg,
                                        desc_note_urg,
                                        flg_forz_man_gest_interna,
                                        desc_note_forzatura,
                                        flg_libretti_portatore_minori,
                                        flg_rapporti_con_depos_titoli,
                                        flg_rapporti_bloccati,
                                        flg_rapporti_garanzia_cred_fir,
                                        flg_rapporto_concordato_preven,
                                        flg_conti_categ_2000,
                                        num_telefono,
                                        indirizzo_email,
                                        desc_secondo_referente,
                                        num_tel_secondo_referente,
                                        desc_note_rischi,
                                        cod_sag,
                                        cod_stato_sag,
                                        dta_calc_conf_sag,
                                        desc_modal_conferma_sag,
                                        cod_last_organo_delib_fido,
                                        dta_motivo_pass_rischio,
                                        cod_microtipologia_host,
                                        cod_tipo_proposta,
                                        desc_note_garanzie_ricevute,
                                        desc_note_garanzie_prestate,
                                        desc_note_coerenza,
                                        val_rdv_delib_banca_rete,
                                        cod_stato_proposta,
                                        --  cod_organo_pacchetto_calc,
                                        --  cod_doc_delibera_banca,
                                        --  cod_doc_parere_conformita,
                                        --  cod_doc_appendice_parere,
                                        --  cod_doc_delibera_capogruppo,
                                        --  cod_doc_classificazione,
                                        dta_scadenza_incaglio,
                                        val_rinuncia_totale,
                                        val_accordato_firma,
                                        val_accordato_cassa,
                                        dta_decorrenza_stato,
                                        val_uti_tot_scgb,
                                        --  dta_delibera_rete,
                                        cod_protocollo_delibera_nf,
                                        flg_no_gruppo_economico,
                                        flg_posiz_da_cedere,
                                        dta_scad_post_proroga,
                                        val_rdv_rapp_operativi,
                                        val_perc_rett_rapp_firma,
                                        desc_tipo_ristr,
                                        desc_intento_ristr,
                                        dta_scadenza_ristr,
                                        cod_stato_post_ristr,
                                        cod_protocollo_delibera_pre,
                                        val_rdv_progr_fi,
                                        val_rdv_pregr_fi,
                                        val_rdv_extra_fi,
                                        val_esp_firma,
                                        dta_efficacia_ristr,
                                        dta_efficacia_add,
                                        dta_chiusura_ristr,
                                        flg_ristr_ereditata,
                                        flg_ristrutturato,
                                        flg_rdv,
                                        flg_forz_da_imp,
                                        cod_fase_microtip_pre_add,
                                        cod_fase_delib_pre_add,
                                        cod_pacchetto_modificato, --D.cod_protocollo_pacchetto: vecchio pacchetto
                                        cod_microtip_variazione, --elenco delle variazioni che devo prendere con i flag bisogna decidere se mettere 6 flag diversi o una lista di 6 binari che indicano se il flag e' acceso o spento
                                        cod_delibera_modificato, --D.cod_protocollo_delibera: vecchia delibera
                                        FLG_DELIB_FORZATA,
                                        FLG_PACCHETTO_CLONATO --Y dato che questo e' il pacchetto clone
                                                             )
         SELECT TO_NUMBER (TO_CHAR ( (SYSDATE), 'yyyymmdd')),
                D.cod_sndg,
                v_prot_pac_new,
                D.cod_abi,
                D.cod_ndg,
                v_proto_delib,
                D.cod_pratica,
                D.val_anno_pratica,
                D.cod_macrotipologia_delib,
                D.cod_microtipologia_delib,
                'IN',
                'INS',
                'INS',
                D.cod_causa_chius_delibera,
                D.cod_filiale_delibera,
                D.cod_matricola_inserente,
                --   D.cod_organo_calcolato,
                --   D.cod_organo_deliberante,
                D.cod_organo_deliberato,
                -- D.cod_organo_pacchetto,
                D.cod_protocollo_delibera_col,
                D.cod_segmento,
                D.cod_tipo_transazione,
                D.cod_uo_pratica,
                D.desc_denominaz_ins_delibera,
                D.desc_note,
                D.desc_note_delibere_annullate,
                D.desc_note_rdv,
                D.desc_parere_sndg,
                D.desc_tipo_conferma_delibera,
                NULL,
                DECODE (p_cod_protocollo_pacchetto,
                        TO_CHAR (NULL), SYSDATE,
                        D.dta_conferma_delibera),
                --  D.dta_delibera,
                D.dta_delibera_estero,
                D.dta_ingresso_rdv_servizio,
                NULL,
                D.dta_scadenza,
                D.dta_scadenza_estero,
                D.dta_scadenza_transaz,
                SYSDATE,
                SYSDATE,
                SYSDATE,
                SYSDATE,
                D.flg_art_136,
                D.flg_attiva,
                D.flg_delib_in_linea,
                D.flg_no_colleg_altre_pos,
                D.flg_no_garanzie_capienti,
                D.flg_no_patrimon_aggred,
                D.flg_no_presupposti_class_soff,
                D.flg_no_rischi_firma,
                D.flg_parti_correlate,
                D.flg_perdur_difficolta_econ,
                D.flg_visionato,
                D.val_esp_lorda,
                D.val_esp_lorda_capitale,
                D.val_esp_lorda_mora,
                D.val_esp_netta_ante_delib,
                D.val_esp_netta_post_delib,
                D.val_imp_offerto,
                D.val_imp_perdita,
                D.val_interessi_futuri,
                D.val_perc_perd_rm,
                D.val_perc_rdv,
                D.val_perc_rdv_estero,
                D.val_perdita_attuale,
                D.val_perdita_deliberata,
                D.val_progr_proposta,
                D.val_rdv_qc_ante_delib,
                D.val_rdv_qc_deliberata,
                D.val_rdv_qc_progressiva,
                D.val_rdv_quota_mora,
                D.val_rinuncia_capitale,
                D.val_rinuncia_deliberata,
                D.val_rinuncia_mora,
                D.val_rinuncia_proposta,
                D.val_rdv_extra_delibera,
                D.val_stralcio_senza_accantonam,
                D.val_stralcio_quota_cap,
                D.val_stralcio_quota_mora,
                D.val_tasso_base_appl,
                D.val_anno_proposta,
                SYSDATE,
                D.val_sacrif_capit_mora,
                D.cod_tipo_pacchetto,
                SYSDATE,
                NULL,
                D.cod_operatore_ins_upd,
                D.val_perc_dubbio_esito,
                D.cod_intest_sched_gen,
                D.cod_matricola_conf_propos,
                D.cod_stato_proposto,
                D.cod_uo_proponente,
                D.cod_uo_proposta,
                D.desc_anag_deliberante,
                D.desc_anag_proponente,
                D.desc_garanzie_accanton,
                D.desc_liv_last_delib_fido,
                D.desc_note_annullo_prop,
                D.desc_ramo_affari,
                D.desc_rischi_indiretti,
                D.dta_accensione_prop_rischio,
                D.dta_consolid_prop_org_vig,
                D.dta_delib_prop_da_deliberante,
                D.dta_delib_prop_da_proponente,
                D.dta_inizio_rapporto_cliente,
                D.dta_last_delibera_fido,
                D.dta_revoca_fido_in_essere,
                D.dta_superam_stato_rischio,
                D.dta_trasfer_propo_fil_area,
                D.flg_cancellaz_proposta,
                D.flg_disposizione,
                D.note_last_delib_fido,
                D.val_accordato,
                D.val_accordato_derivati,
                D.val_esp_tot_cassa,
                D.val_imp_crediti_firma,
                D.val_imp_fondi_terzi,
                D.val_imp_fondi_terzi_nb,
                D.val_imp_utilizzo,
                D.val_interessi_mora_cassa,
                0,                                           --flg_no_delibera
                D.dta_congelamento,
                D.val_uti_tot_scsb,
                D.val_uti_tot_gegb,
                D.val_uti_cassa_scsb,
                D.val_uti_firma_scsb,
                D.val_uti_sosti_scsb,
                D.flg_100,
                D.flg_depositi_collaterali,
                D.flg_soggetto_pot_fallibile,
                D.flg_presen_covenants,
                D.flg_interven_organi_superiori,
                D.flg_affidam_soc_recupero,
                D.dta_rif_dati_contabili,
                D.val_rischi_indiretti,
                D.desc_tipo_gestione,
                D.flg_fondo_terzi,
                D.val_uti_netto_fondo_terzi,
                D.desc_motivo_pass_rischio,
                D.cod_stato_provenienza,
                D.val_num_progr_delibera,
                D.flg_to_copy,
                D.dta_udienza_ver_cred,
                D.flg_esist_debitore_sotto_proc,
                D.flg_beni_non_in_garanzia,
                D.flg_avviso_ex498cpc,
                D.flg_pignoramenti_immobiliari,
                D.flg_pignoramenti_mobiliari,
                D.flg_pignoramenti_terzi,
                D.flg_protesti,
                D.flg_ipoteche_beni_deb_gar,
                D.flg_garanzie_sgfa,
                D.flg_garanzie_sace,
                D.flg_garanzie_con_fidi,
                D.flg_garanzie_genworth,
                D.flg_pratica_urg,
                D.desc_note_urg,
                D.flg_forz_man_gest_interna,
                D.desc_note_forzatura,
                D.flg_libretti_portatore_minori,
                D.flg_rapporti_con_depos_titoli,
                D.flg_rapporti_bloccati,
                D.flg_rapporti_garanzia_cred_fir,
                D.flg_rapporto_concordato_preven,
                D.flg_conti_categ_2000,
                D.num_telefono,
                D.indirizzo_email,
                D.desc_secondo_referente,
                D.num_tel_secondo_referente,
                D.desc_note_rischi,
                D.cod_sag,
                D.cod_stato_sag,
                D.dta_calc_conf_sag,
                D.desc_modal_conferma_sag,
                D.cod_last_organo_delib_fido,
                D.dta_motivo_pass_rischio,
                D.cod_microtipologia_host,
                D.cod_tipo_proposta,
                D.desc_note_garanzie_ricevute,
                D.desc_note_garanzie_prestate,
                D.desc_note_coerenza,
                D.val_rdv_delib_banca_rete,
                D.cod_stato_proposta,
                --    D.cod_organo_pacchetto_calc,
                --   D.cod_doc_delibera_banca,
                --    D.cod_doc_parere_conformita,
                --    D.cod_doc_appendice_parere,
                --   D.cod_doc_delibera_capogruppo,
                --    D.cod_doc_classificazione,
                D.dta_scadenza_incaglio,
                D.val_rinuncia_totale,
                D.val_accordato_firma,
                D.val_accordato_cassa,
                D.dta_decorrenza_stato,
                D.val_uti_tot_scgb,
                --  D.dta_delibera_rete,
                D.cod_protocollo_delibera_nf,
                D.flg_no_gruppo_economico,
                D.flg_posiz_da_cedere,
                D.dta_scad_post_proroga,
                D.val_rdv_rapp_operativi,
                D.val_perc_rett_rapp_firma,
                D.desc_tipo_ristr,
                D.desc_intento_ristr,
                D.dta_scadenza_ristr,
                D.cod_stato_post_ristr,
                D.cod_protocollo_delibera_pre,
                D.val_rdv_progr_fi,
                D.val_rdv_pregr_fi,
                D.val_rdv_extra_fi,
                D.val_esp_firma,
                D.dta_efficacia_ristr,
                D.dta_efficacia_add,
                D.dta_chiusura_ristr,
                D.flg_ristr_ereditata,
                D.flg_ristrutturato,
                D.flg_rdv,
                D.flg_forz_da_imp,
                D.cod_fase_microtip_pre_add,
                D.cod_fase_delib_pre_add,
                D.cod_protocollo_pacchetto,         --COD_PACCHETTO_MODIFICATO
                p_elenco_flag,
                D.cod_protocollo_delibera,           --COD_DELIBERA_MODIFICATO
                D.FLG_DELIB_FORZATA,
                'Y'                                    --FLG_PACCHETTO_CLONATO
           FROM T_MCREI_APP_DELIBERE D
          WHERE     D.COD_ABI = p_cod_abi
                AND D.COD_NDG = p_cod_ndg
                AND D.COD_PROTOCOLLO_DELIBERA = p_cod_protocollo_delibera;

      RETURN v_prot_pac_new;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (
            pkg_mcrei_web_utilities.c_package || p_nome_fun,
            3,
            SQLCODE,
            SQLERRM,
            p_note || p_param,
            NULL);
         RETURN TO_CHAR (NULL);
   END;

   --Il pacchetto clone viene modificato e confermato
   --cod_protocollo_pacchetto del pacchetto clone su cui sto lavorando
   FUNCTION fnc_conf_pac_modificato (
      p_cod_protocollo_pacchetto    t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE,
      p_flg_sostituzione            VARCHAR2 DEFAULT NULL --Deve valere 1 per sostituzioni
                                                         )
      RETURN NUMBER
   IS
      p_note            t_mcrei_wrk_audit_applicativo.note%TYPE;
      v_prot_pac_old    t_mcrei_app_delibere.cod_protocollo_pacchetto%TYPE;
      p_nome_fun        VARCHAR2 (50) := 'fnc_conf_pac_modificato';
      p_param           VARCHAR2 (200)
         := ' protocollo_pacchetto: ' || p_cod_protocollo_pacchetto;
      v_count           NUMBER;
      v_tot_delibere    NUMBER;
      v_delibere_comp   NUMBER;
      v_cod_org_max     VARCHAR2 (2);
      count_org_max     NUMBER;
   BEGIN
      --recupero il cod_protocollo_pacchetto del pacchetto originario
      SELECT cod_pacchetto_modificato
        INTO v_prot_pac_old
        FROM t_mcrei_app_delibere
       WHERE cod_protocollo_pacchetto = p_cod_protocollo_pacchetto
             AND ROWNUM = 1;


      --UPDATE SUL PACCHETTO ORIGINARIO:
      --Viene confermato tutto il pacchetto (sia per VARIAZIONE che per SOSTITUZIONE)
      UPDATE T_MCREI_APP_DELIBERE
         SET COD_FASE_PACCHETTO = 'CNF'
       WHERE COD_PROTOCOLLO_PACCHETTO = v_prot_pac_old;

      --per VARIAZIONE
      IF (NVL (p_flg_sostituzione, '0') = '0')
      THEN
         --viene portata a CNF la microtipologia di tutte le delibere con fase microtipologia VAR
         UPDATE T_MCREI_APP_DELIBERE
            SET COD_FASE_MICROTIPOLOGIA = 'CNF'
          WHERE COD_FASE_MICROTIPOLOGIA = 'VAR'
                AND COD_PROTOCOLLO_PACCHETTO = v_prot_pac_old;
      END IF;

      --per SOSTITUZIONE
      IF (p_flg_sostituzione = '1')
      THEN
         -- viene portata a CNF la microtipologia di tutte le delibere con fase microtipologia SST
         UPDATE T_MCREI_APP_DELIBERE
            SET COD_FASE_MICROTIPOLOGIA = 'CNF'
          WHERE cod_fase_microtipologia = 'SST'
                AND COD_PROTOCOLLO_PACCHETTO = v_prot_pac_old;

         --viene portata a SO la fase delle delibere con fase AS
         UPDATE T_MCREI_APP_DELIBERE
            SET COD_FASE_DELIBERA = 'SO'
          WHERE COD_FASE_DELIBERA = 'AS'
                AND COD_PROTOCOLLO_PACCHETTO = v_prot_pac_old;
      END IF;

      --------------------------------------------------------------------------------
      --19/12 Update da eseguire prima di riportare il pacchetto clone all'interno del pacchetto originale.

      --Update T_MCREI_APP_DELIBERE
        ---28/12 aggiunto set su documenti .AD
      UPDATE T_MCREI_APP_DELIBERE
         SET COD_ORGANO_PACCHETTO_CALC =
                (SELECT DISTINCT COD_ORGANO_PACCHETTO_CALC
                   FROM T_MCREI_APP_DELIBERE
                  WHERE COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto
                        AND ROWNUM = 1),
             COD_ORGANO_PACCHETTO =
                (SELECT DISTINCT COD_ORGANO_PACCHETTO
                   FROM T_MCREI_APP_DELIBERE
                  WHERE COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto
                        AND ROWNUM = 1),
              cod_doc_parere_conformita =  (SELECT DISTINCT cod_doc_parere_conformita
                   FROM T_MCREI_APP_DELIBERE
                  WHERE COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto
                        AND ROWNUM = 1),
              cod_doc_delibera_capogruppo =  (SELECT DISTINCT cod_doc_delibera_capogruppo
                   FROM T_MCREI_APP_DELIBERE
                  WHERE COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto
                        AND ROWNUM = 1)
       WHERE COD_PROTOCOLLO_PACCHETTO = v_prot_pac_old
             AND COD_FASE_DELIBERA NOT IN ('VA', 'AS', 'SO');

      FOR v_rec
         IN (SELECT DISTINCT COD_ABI
               FROM T_MCREI_APP_DELIBERE
              WHERE     COD_PROTOCOLLO_PACCHETTO = P_COD_PROTOCOLLO_PACCHETTO
                    AND COD_FASE_PACCHETTO != 'ANM'
                    AND COD_FASE_MICROTIPOLOGIA != 'ANM')
      LOOP
         SELECT COUNT (COD_ORGANO_MASSIMO)
           INTO count_org_max
           FROM T_MCRE0_APP_OD_CALCOLATI
          WHERE COD_ABI = v_rec.cod_abi
                AND COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto;

         IF (count_org_max > 0)
         THEN
            SELECT COD_ORGANO_MASSIMO
              INTO v_cod_org_max
              FROM T_MCRE0_APP_OD_CALCOLATI
             WHERE     COD_ABI = v_rec.cod_abi
                   AND COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto
                   AND ROWNUM = 1;

            UPDATE T_MCREI_APP_DELIBERE
               SET COD_ORGANO_CALCOLATO = v_cod_org_max
             WHERE     COD_ABI = v_rec.cod_abi
                   AND COD_PROTOCOLLO_PACCHETTO = v_prot_pac_old
                   AND COD_FASE_PACCHETTO != 'ANM'
                   AND COD_FASE_MICROTIPOLOGIA != 'ANM';
         END IF;
      END LOOP;

      UPDATE T_MCREI_APP_DELIBERE
         SET DTA_DELIBERA =
                (SELECT DTA_DELIBERA
                   FROM T_MCREI_APP_DELIBERE
                  WHERE COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto
                        AND ROWNUM = 1),
             COD_DOC_DELIBERA_CAPOGRUPPO =
                (SELECT DISTINCT COD_DOC_DELIBERA_CAPOGRUPPO
                   FROM T_MCREI_APP_DELIBERE
                  WHERE COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto
                        AND ROWNUM = 1)
       WHERE COD_PROTOCOLLO_PACCHETTO = v_prot_pac_old;

      --Update T_MCRE0_APP_OD_CALCOLATI

      --tutti i record aventi COD_PROTOCOLLO_PACCHETTO = 'P1' devono essere aggiornati in modo tale da avere COD_PROTOCOLLO_PACCHETTO = 'P1_SST'
      UPDATE T_MCRE0_APP_OD_CALCOLATI
         SET COD_PROTOCOLLO_PACCHETTO = COD_PROTOCOLLO_PACCHETTO || '_SST'
       WHERE COD_PROTOCOLLO_PACCHETTO = v_prot_pac_old;

      -- tutti i record aventi COD_PROTOCOLLO_PACCHETTO = 'P2' devono essere aggiornati in modo tale da avere COD_PROTOCOLLO_PACCHETTO = 'P1'
      UPDATE T_MCRE0_APP_OD_CALCOLATI
         SET COD_PROTOCOLLO_PACCHETTO = v_prot_pac_old
       WHERE COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto;

    --18.06 aggiorno la rapporti in essere!
      --tutti i record aventi COD_PROTOCOLLO_PACCHETTO = 'P1' devono essere aggiornati in modo tale da avere COD_PROTOCOLLO_PACCHETTO = 'P1_SST'
      UPDATE T_MCREI_APP_RAPPORTI_IN_ESSERE
         SET COD_PROTOCOLLO_PACCHETTO = COD_PROTOCOLLO_PACCHETTO || '_SST'
       WHERE COD_PROTOCOLLO_PACCHETTO = v_prot_pac_old;

      -- tutti i record aventi COD_PROTOCOLLO_PACCHETTO = 'P2' devono essere aggiornati in modo tale da avere COD_PROTOCOLLO_PACCHETTO = 'P1'
      UPDATE T_MCREI_APP_RAPPORTI_IN_ESSERE
         SET COD_PROTOCOLLO_PACCHETTO = v_prot_pac_old
       WHERE COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto;


      --------------------------------------------------------------------------------

      --CONFERMA DEL PACCHETTO CLONE E INSERIMENTO NEL PACCHETTO ORIGINALE:
      --conferma del pacchetto clonato:
      UPDATE t_MCREI_APP_DELIBERE
         SET COD_FASE_PACCHETTO = 'CNF',
             COD_FASE_MICROTIPOLOGIA = 'CNF',
             COD_FASE_DELIBERA = 'CO'
       WHERE     COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto
             AND COD_FASE_PACCHETTO != 'ANM'
             AND COD_FASE_MICROTIPOLOGIA != 'ANM';


      --riporto  tutte le delibere nel pacchetto clonato sotto il pacchetto originario:
      UPDATE T_MCREI_APP_DELIBERE
         SET COD_PACCHETTO_SERVIZIO = COD_PROTOCOLLO_PACCHETTO,
             COD_PROTOCOLLO_PACCHETTO = COD_PACCHETTO_MODIFICATO,
             COD_PACCHETTO_MODIFICATO = NULL,
             FLG_PACCHETTO_CLONATO = 'N'
       WHERE     COD_PROTOCOLLO_PACCHETTO = P_COD_PROTOCOLLO_PACCHETTO
             AND COD_FASE_PACCHETTO != 'ANM' --se la microtipologia o il pacchetto sono stati annullati non li prendo
             AND COD_FASE_MICROTIPOLOGIA != 'ANM';

      --Se nel pacchetto clone sono rimasti dei record, hanno sicuramente tutti cod_fase_microtipologia = 'ANM'.
      --Quindi porto tutto il pacchetto clone a cod_fase_pacchetto = 'ANM'
      UPDATE T_MCREI_APP_DELIBERE
         SET COD_FASE_PACCHETTO = 'ANM'
       WHERE cod_protocollo_pacchetto = p_cod_protocollo_pacchetto
             AND cod_fase_microtipologia = 'ANM';

      --update sulla T_MCRE0_APP_DOCUMENTI per ripristinare il protocollo del pacchetto originale
      UPDATE T_MCRE0_APP_DOCUMENTI
         SET COD_PROTOCOLLO_PACCHETTO = v_prot_pac_old
       WHERE COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto;

      RETURN const_esito_ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (
            pkg_mcrei_web_utilities.c_package || p_nome_fun,
            3,
            SQLCODE,
            SQLERRM,
            p_note || p_param,
            NULL);
         RETURN const_esito_ko;
   END;

   --Se viene passato p_cod_microtipologia_delib si rimuove solo questa microtipologia dal pacchetto clone.
   --Altrimenti si rimuove tutto il pacchetto clone.
   --Si ripristinano i valori di cod_fase_microtipologia e cod_fase_delibera ai valori originari per una microtipologia (se passata)
   --o per tutte le microtipologie che sono state variate (se non passata).
   --p_cod_protocollo_pacchetto e' il cod_protocollo_pacchetto del pacchetto clone.


   FUNCTION fnc_annulla_pac_modificato (
                                        P_COD_PROTOCOLLO_PACCHETTO T_MCREI_APP_DELIBERE.COD_PROTOCOLLO_PACCHETTO%TYPE,
                                        P_COD_MICROTIPOLOGIA_DELIB T_MCREI_APP_DELIBERE.COD_MICROTIPOLOGIA_DELIB%TYPE DEFAULT NULL--,
                                       -- P_DTA_ANNULLO IN T_MCREI_APP_DELIBERE.DTA_ANNULLO%TYPE DEFAULT SYSDATE,
                                       -- P_COD_MATRICOLA_ANNULLO IN T_MCREI_APP_DELIBERE.COD_MATRICOLA_ANNULLO%TYPE DEFAULT NULL,
                                       -- P_COD_OPERA_COME_ANNULLO IN T_MCREI_APP_DELIBERE.COD_OPERA_COME_ANNULLO%TYPE DEFAULT NULL,
                                       -- P_DESC_NOTE_DELIBERE_ANNULLATE IN T_MCREI_APP_DELIBERE.DESC_NOTE_DELIBERE_ANNULLATE%TYPE DEFAULT NULL
                                       )
                                        RETURN NUMBER
   IS
      p_note       t_mcrei_wrk_audit_applicativo.note%TYPE;
      p_nome_fun   VARCHAR2 (50) := 'fnc_annulla_pac_modificato';
      p_param      VARCHAR2 (200)
         :=    ' protocollo_pacchetto: '
            || p_cod_protocollo_pacchetto
            || ' cod_microtipologia_delib '
            || p_cod_microtipologia_delib;
      v_count      NUMBER := 0;
      v_tipo_mod   VARCHAR2 (10);
   BEGIN
      --per sapere se il pacchetto e' di variazione o di sostituzione:
      SELECT COD_FASE_PACCHETTO
        INTO v_tipo_mod
        FROM T_MCREI_APP_DELIBERE
       WHERE COD_PACCHETTO_SERVIZIO = p_cod_protocollo_pacchetto
             AND ROWNUM = 1;

      --numero di tipi di microtipologia presenti nel pacchetto clone :
      SELECT COUNT (DISTINCT COD_MICROTIPOLOGIA_DELIB)
        INTO v_count
        FROM T_MCREI_APP_DELIBERE
       WHERE COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto
             AND COD_FASE_MICROTIPOLOGIA <> 'ANM';

      --se il valore della microtipologia non viene passato alla funzione oppure se il valore che viene passato e'
      --l'unico tipo di microtipologia presente nel pacchetto clone, agisco su tutto il pacchetto.

      IF (p_cod_microtipologia_delib IS NULL OR v_count <= 1)
      THEN
         UPDATE T_MCREI_APP_DELIBERE       --riporto tutto il pacchetto in CNF
            SET COD_FASE_PACCHETTO = 'CNF'
          WHERE COD_PACCHETTO_SERVIZIO = p_cod_protocollo_pacchetto;

         IF (v_tipo_mod = 'SST')               --per pacchetti di sostituzione
         THEN
            --ripristino i valori originario nel pacchetto originario:
            UPDATE T_MCREI_APP_DELIBERE
               SET COD_FASE_MICROTIPOLOGIA = COD_FASE_MICROTIP_PRE_ADD,
                   COD_FASE_MICROTIP_PRE_ADD = NULL
             WHERE COD_PACCHETTO_SERVIZIO = p_cod_protocollo_pacchetto
                   AND COD_FASE_MICROTIPOLOGIA = 'SST';

            UPDATE T_MCREI_APP_DELIBERE
               SET COD_FASE_DELIBERA = COD_FASE_DELIB_PRE_ADD,
                   COD_FASE_DELIB_PRE_ADD = NULL,
                   COD_DELIBERA_SERVIZIO = NULL
             WHERE COD_PACCHETTO_SERVIZIO = p_cod_protocollo_pacchetto
                   AND COD_FASE_DELIBERA = 'AS';
         END IF;


         IF (v_tipo_mod = 'VAR')               --per pacchetti di sostituzione
         THEN
            --ripristino i valori originario nel pacchetto originario:
            UPDATE T_MCREI_APP_DELIBERE
               SET COD_FASE_MICROTIPOLOGIA = COD_FASE_MICROTIP_PRE_ADD,
                   COD_FASE_MICROTIP_PRE_ADD = NULL
             WHERE COD_PACCHETTO_SERVIZIO = p_cod_protocollo_pacchetto
                   AND COD_FASE_MICROTIPOLOGIA = 'VAR';

            UPDATE T_MCREI_APP_DELIBERE
               SET COD_FASE_DELIBERA = COD_FASE_DELIB_PRE_ADD,
                   COD_FASE_DELIB_PRE_ADD = NULL,
                   COD_DELIBERA_SERVIZIO = NULL
             WHERE COD_PACCHETTO_SERVIZIO = p_cod_protocollo_pacchetto
                   AND COD_FASE_DELIBERA = 'VA';
         END IF;


         --annullo il pacchetto clonato:
         UPDATE T_MCREI_APP_DELIBERE
            SET COD_FASE_PACCHETTO = 'ANM',
                COD_FASE_MICROTIPOLOGIA = 'ANM',
                COD_FASE_DELIBERA = 'AN',
                DTA_UPD_FASE_DELIBERA = SYSDATE,
                DTA_UPD_FASE_PACCHETTO = SYSDATE,
                DTA_UPD_FASE_MICROTIPOLOGIA = SYSDATE
--                COD_MATRICOLA_ANNULLO = P_COD_MATRICOLA_ANNULLO,
--                COD_OPERA_COME_ANNULLO = P_COD_OPERA_COME_ANNULLO,
--                DTA_ANNULLO = P_DTA_ANNULLO,
--                DESC_NOTE_DELIBERE_ANNULLATE = P_DESC_NOTE_DELIBERE_ANNULLATE
          WHERE COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto;



      --se nella funzione viene passato un valore per cod_microtipologia_delib e se questa non e' l'ultima microtipologia nel pacchetto:                                        );
      ELSE
         IF (v_tipo_mod = 'SST')               --per pacchetti di sostituzione
         THEN
            --ripristino i valori originario nel pacchetto originario:
            UPDATE T_MCREI_APP_DELIBERE
               SET COD_FASE_MICROTIPOLOGIA = COD_FASE_MICROTIP_PRE_ADD,
                   COD_FASE_MICROTIP_PRE_ADD = NULL
             WHERE     COD_PACCHETTO_SERVIZIO = p_cod_protocollo_pacchetto
                   AND COD_FASE_MICROTIPOLOGIA = 'SST'
                   AND COD_MICROTIPOLOGIA_DELIB = p_cod_microtipologia_delib;

            UPDATE T_MCREI_APP_DELIBERE
               SET COD_FASE_DELIBERA = COD_FASE_DELIB_PRE_ADD,
                   COD_FASE_DELIB_PRE_ADD = NULL,
                   COD_DELIBERA_SERVIZIO = NULL
             WHERE     COD_PACCHETTO_SERVIZIO = p_cod_protocollo_pacchetto
                   AND COD_FASE_DELIBERA = 'AS'
                   AND COD_MICROTIPOLOGIA_DELIB = p_cod_microtipologia_delib;
         END IF;


         IF (v_tipo_mod = 'VAR')               --per pacchetti di sostituzione
         THEN
            --ripristino i valori originario nel pacchetto originario:
            UPDATE T_MCREI_APP_DELIBERE
               SET COD_FASE_MICROTIPOLOGIA = COD_FASE_MICROTIP_PRE_ADD,
                   COD_FASE_MICROTIP_PRE_ADD = NULL
             WHERE     COD_PACCHETTO_SERVIZIO = p_cod_protocollo_pacchetto
                   AND COD_FASE_MICROTIPOLOGIA = 'VAR'
                   AND COD_MICROTIPOLOGIA_DELIB = p_cod_microtipologia_delib;

            UPDATE T_MCREI_APP_DELIBERE
               SET COD_FASE_DELIBERA = COD_FASE_DELIB_PRE_ADD,
                   COD_FASE_DELIB_PRE_ADD = NULL,
                   COD_DELIBERA_SERVIZIO = NULL
             WHERE     COD_PACCHETTO_SERVIZIO = p_cod_protocollo_pacchetto
                   AND COD_FASE_DELIBERA = 'VA'
                   AND COD_MICROTIPOLOGIA_DELIB = p_cod_microtipologia_delib;
         END IF;


         --annullo tutte le delibere della data micrologia presenti nel pacchetto clone:
         UPDATE T_MCREI_APP_DELIBERE
            SET COD_FASE_MICROTIPOLOGIA = 'ANM',
                COD_FASE_DELIBERA = 'AN',
                COD_FASE_PACCHETTO = 'ANM',--02/01/13
                DTA_UPD_FASE_DELIBERA = SYSDATE,
                DTA_UPD_FASE_PACCHETTO = SYSDATE,
                DTA_UPD_FASE_MICROTIPOLOGIA = SYSDATE
--                COD_MATRICOLA_ANNULLO = P_COD_MATRICOLA_ANNULLO,
--                COD_OPERA_COME_ANNULLO = P_COD_OPERA_COME_ANNULLO,
--                DTA_ANNULLO = P_DTA_ANNULLO,
--                DESC_NOTE_DELIBERE_ANNULLATE = P_DESC_NOTE_DELIBERE_ANNULLATE
          WHERE COD_PROTOCOLLO_PACCHETTO = p_cod_protocollo_pacchetto
                AND COD_MICROTIPOLOGIA_DELIB = p_cod_microtipologia_delib;
      END IF;



      RETURN const_esito_ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (
            pkg_mcrei_web_utilities.c_package || p_nome_fun,
            3,
            SQLCODE,
            SQLERRM,
            p_note || p_param,
            NULL);
         RETURN CONST_ESITO_KO;
   END fnc_annulla_pac_modificato ;



   --  -- %AUTHOR REPLY
   --  -- %VERSION 0.2
   --  -- %USAGE  FUNZIONE CHE INSERISCE UN NUOVO UTENTE
   --  -- %PARAM P_ID_UTENTE ID del nuovo utente da inserire
   --  -- %CD 31 OTT
   --  -- %RETURN -> 1 se l'inserimento e' andato a buon fine, false altrimenti
   --   FUNCTION FNC_TEST_LIVELLO_POS(P_COD_ABI IN VARCHAR2, P_COD_NDG IN VARCHAR2, P_COD_LIVELLO IN VARCHAR2) RETURN BOOLEAN IS
   --        p_note t_mcrei_wrk_audit_applicativo.note%TYPE;
   --        p_nome_fun VARCHAR2(50):='fnc_annulla_pacchetto';
   --        p_param VARCHAR2(200):= ' ABI: ' || P_COD_ABI||
   --        ' NDG ' || P_COD_NDG;
   --        V_COD_COMPARTO_AD       T_MCRE0_APP_ALL_DATA.COD_COMPARTO_ASSEGNATO%TYPE;
   --        V_LIV_COMP_EFFETIVO     T_MCRE0_APP_COMPARTI.COD_LIVELLO%TYPE;
   --        V_TROVATO_LIVELLO       BOOLEAN;
   --        CURSOR C1 IS
   --            SELECT DISTINCT COD_LIVELLO
   --              FROM T_MCRE0_APP_COMPARTI;
   --        R1                  C1%ROWTYPE;
   --
   --
   --    BEGIN
   --
   --        IF  P_COD_ABI IS NULL OR
   --            P_COD_NDG IS NULL OR
   --            P_COD_LIVELLO IS NULL THEN
   --             raise_application_error(-20666, 'Null parameter');
   --        END IF;
   --
   --        OPEN C1;
   --        LOOP -- VERIFICA CHE L'ARGOMENTO PASSATO SIA UN LIVELLO ESISTENTE
   --            EXIT WHEN NOT C1%ISOPEN OR C1%NOTFOUND;
   --            FETCH C1 INTO R1;
   --            IF P_COD_LIVELLO = R1.COD_LIVELLO THEN
   --                V_TROVATO_LIVELLO:= TRUE;
   --                CLOSE C1;
   --            END IF;
   --        END LOOP;
   --
   --        IF NOT V_TROVATO_LIVELLO THEN
   --            raise_application_error(-20666, 'Livello area non riconosciuto');
   --        END IF;
   --
   --        V_TROVATO_LIVELLO:=TRUE;
   --
   --        BEGIN
   --            SELECT COD_COMPARTO_ASSEGNATO,
   --              INTO V_COD_COMPARTO_AD
   --              FROM T_MCRE0_APP_ALL_DATA
   --            WHERE COD_ABI_CARTOLARIZZATO = P_COD_ABI
   --              AND COD_NDG = P_COD_NDG
   --              AND TODAY_FLG = '1';
   --
   --             SELECT COD_LIVELLO
   --                INTO V_LIV_COMP_EFFETIVO
   --                FROM T_MCRE0_APP_COMPARTI
   --               WHERE COD_COMPARTO = V_COD_COMPARTO_AD;
   --        EXCEPTION WHEN NO_DATA_FOUND THEN
   --            V_TROVATO_LIVELLO:=FALSE;
   --        END;
   --
   --        IF V_TROVATO_LIVELLO AND V_LIV_COMP_EFFETIVO != P_COD_LIVELLO THEN
   --            V_TROVATO_LIVELLO:=FALSE;
   --        END IF;
   --
   --        pkg_mcrei_audit.log_app(pkg_mcrei_web_utilities.c_package ||
   --        p_nome_fun,
   --        3,
   --        SQLCODE,
   --        SQLERRM,
   --        p_note || p_param,
   --        NULL);
   --        RETURN V_TROVATO_LIVELLO;
   --        EXCEPTION
   --        WHEN OTHERS THEN
   --        pkg_mcrei_audit.log_app(pkg_mcrei_web_utilities.c_package ||
   --        p_nome_fun,
   --        3,
   --        SQLCODE,
   --        SQLERRM,
   --        p_note || p_param,
   --        NULL);
   --        RETURN FALSE;
   --    END;

   FUNCTION FNC_IS_AR_RG_LIV_AREA (
      P_COD_COMPARTO IN T_MCRE0_APP_ALL_DATA.COD_COMPARTO_ASSEGNATO%TYPE)
      RETURN BOOLEAN
   IS
      P_NOTE              T_MCREI_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
      P_NOME_FUN          VARCHAR2 (50) := 'FNC_IS_AR_RG_LIV_AREA';
      P_PARAM             VARCHAR2 (200) := ' p_cod_comaprto: ' || P_COD_COMPARTO;
      V_COD_LIV_TROVATO   T_MCRE0_APP_COMPARTI.COD_LIVELLO%TYPE;
   BEGIN
      BEGIN
         SELECT COD_LIVELLO
           INTO V_COD_LIV_TROVATO
           FROM T_MCRE0_APP_COMPARTI
          WHERE COD_COMPARTO = P_COD_COMPARTO;

         IF V_COD_LIV_TROVATO IN ('AR', 'RG')
         THEN
            RETURN TRUE;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN FALSE;
      END;

      RETURN FALSE;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (
            PKG_MCREI_WEB_UTILITIES_EVOL.c_package || p_nome_fun,
            3,
            SQLCODE,
            SQLERRM,
            p_note || p_param,
            NULL);
             RETURN FALSE;
   END FNC_IS_AR_RG_LIV_AREA;

   FUNCTION new_rap_conf_invio_host(p_cod_abi T_MCRE0_APP_NEW_RAPP_OP.cod_abi%TYPE,
             p_cod_ndg T_MCRE0_APP_NEW_RAPP_OP.cod_ndg%TYPE,
             p_cod_protocollo_delibera T_MCRE0_APP_NEW_RAPP_OP.cod_protocollo_delibera%TYPE,
             p_val_ordinale T_MCRE0_APP_NEW_RAPP_OP.val_ordinale%TYPE
            )
             RETURN VARCHAR2
    IS
    BEGIN
    UPDATE T_MCRE0_APP_NEW_RAPP_OP
    SET FLG_ESITO='Y',
    DTA_ESITO=sysdate
    where cod_abi=p_cod_abi
    and cod_ndg=p_cod_ndg
    and cod_protocollo_delibera=p_cod_protocollo_delibera
    and val_ordinale=p_val_ordinale;

    COMMIT;

    RETURN CONST_ESITO_OK;

    EXCEPTION WHEN OTHERS THEN
    RETURN CONST_ESITO_KO;


    END;

END PKG_MCREI_WEB_UTILITIES_EVOL;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_WEB_UTILITIES_EVOL FOR MCRE_OWN.PKG_MCREI_WEB_UTILITIES_EVOL;


CREATE SYNONYM MCRE_USR.PKG_MCREI_WEB_UTILITIES_EVOL FOR MCRE_OWN.PKG_MCREI_WEB_UTILITIES_EVOL;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_WEB_UTILITIES_EVOL TO MCRE_USR;

