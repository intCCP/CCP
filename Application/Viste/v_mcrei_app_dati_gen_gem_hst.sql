/* Formatted on 21/07/2014 18:39:26 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DATI_GEN_GEM_HST
(
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_PROTOCOLLO_PACCHETTO,
   OD_EFFETTIVO,
   STATO_PROVENIENZA,
   DTA_DECORRENZA_STATO,
   TIPO_GESTIONE,
   COD_TIPO_GESTIONE,
   DATA_INS_DELIBERA,
   UO_PROPONENTE,
   COD_MATR_PROPONENTE,
   DATA_INIZIO_RAPPORTI,
   MOTIVO_PASSAGGIO_RISCHIO,
   DTA_MOTIVO_PASS_RISCHIO,
   SAG,
   COD_STATO_SAG,
   DTA_SAG,
   MODALITA_CONFERMA_SAG,
   FLG_INTERVEN_ORGANI_SUPERIORI,
   DTA_ULT_DELIBERA_FIDO,
   ULT_ORGANO_DELIB_FIDO,
   DATA_REVOCA_FIDO,
   SCGB_UTI_RISCHI_INDIRETTI,
   FLG_DEPOSITI_COLLATERALI,
   ESP_SINGOLO_CLIENTE_GB,
   FLG_AFFID_SOC_REC,
   FLG_SOGGETTO_POT_FALLIBILE,
   FLG_PRESEN_COVENANTS,
   ESP_GE_GB,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   PROPOSTA_DI_STATO_RISCHIO,
   DTA_CONFERMA_PROPOSTA,
   STATO_PROPOSTA,
   RAMO_AFFARI,
   LIV_ULTIMO_DELIB_FIDO,
   DTA_ULTIMO_AGGIORNAMENTO,
   NUM_PROPOSTA,
   DTA_INIZIO_PROPOSTA,
   FLG_DISPOSIZIONE,
   FLG_POSIZ_DA_CEDERE
)
AS
   SELECT /*+ no_parallel (g)*/
         d.cod_ndg,
          g.desc_nome_controparte,
          d.cod_abi AS cod_abi_cartolarizzato,
          i.desc_istituto,
          d.cod_sndg,
          d.cod_protocollo_delibera,
          d.cod_protocollo_pacchetto,
          d.cod_organo_deliberante AS od_effettivo,
          NULLIF (d.cod_stato_provenienza, '-1') AS stato_provenienza,
          d.dta_decorrenza_stato,
          DECODE (d.desc_tipo_gestione,
                  'A', 'FORFETTARIO',
                  'E', 'ANALITICO',
                  '')
             AS tipo_gestione,                                      -- solo CI
          d.desc_tipo_gestione AS cod_tipo_gestione,
          d.dta_ins_delibera AS data_ins_delibera,
          NVL (d.cod_uo_proponente, p.cod_uo_proponente) AS cod_uo_proponente,
          NVL (d.cod_matricola_inserente, p.cod_utente)
             AS cod_matr_proponente,                                  -- nuovo
          NVL (d.dta_inizio_rapporto_cliente, p.dta_inizio_rapp)
             AS data_inizio_rapporti,
          d.desc_motivo_pass_rischio AS motivo_passaggio_rischio,
          --visualizzato solo se si tratta di CI
          d.dta_motivo_pass_rischio,
          d.cod_sag AS sag,                                      -- NUOVO L.F.
          d.cod_stato_sag,
          NVL (d.dta_calc_conf_sag, d.dta_conferma_pacchetto) AS dta_sag,
          NULL AS modalita_conferma_sag,                                -- ???
          NVL (d.flg_interven_organi_superiori,
               NVL (p.flg_interv_org_sup, 'N'))
             AS flg_interven_organi_superiori,                 -- dato manuale
          NVL (d.dta_last_delibera_fido, p.dta_ultima_delib_fido)
             AS dta_ult_delibera_fido,
          NVL (d.cod_last_organo_delib_fido, p.cod_uo_delib_ult_fido)
             AS ult_organo_delib_fido,
          --            TO_DATE (NULL, 'ddmmyyyy') AS data_revoca_fido,
          p.dta_revoca_fido AS data_revoca_fido,
          -- rischi indiretti rilevati da PCR
          NVL (d.val_rischi_indiretti, p.val_tot_ult_rischi_grup_cred)
             AS scgb_uti_rischi_indiretti,
          NVL (d.flg_depositi_collaterali, NVL (p.depositi_collaterali, 'N'))
             flg_depositi_collaterali,                ------------------------
          NVL (d.val_uti_tot_scgb, p.val_imp_esp_compl)
             AS esp_singolo_cliente_gb,
          NVL (d.flg_affidam_soc_recupero, p.flg_affid_soc_recupero)
             AS flg_affid_soc_rec,                                 ----2 marzo
          NVL (d.flg_soggetto_pot_fallibile, NVL (p.flg_sog_fallibile, 'N'))
             flg_soggetto_pot_fallibile,                       -- dato manuale
          NVL (d.flg_presen_covenants, NVL (p.flg_presenza_covenants, 'N'))
             flg_presen_covenants,                             -- dato manuale
          d.val_uti_tot_gegb AS esp_ge_gb,
          g.cod_gruppo_economico,
          g.desc_gruppo_economico,
          NVL (d.cod_tipo_proposta, p.cod_tipo_rischio)
             AS proposta_di_stato_rischio,
          d.dta_conferma_delibera AS dta_conferma_proposta,
          d.cod_fase_delibera AS stato_proposta,
          NVL (d.desc_ramo_affari, p.desc_ramo_affari) AS ramo_affari,
          NVL (d.desc_liv_last_delib_fido, p.cod_desc_delibera_fido)
             AS liv_ultimo_delib_fido,
          d.dta_last_upd_delibera AS dta_ultimo_aggiornamento,
          d.val_anno_proposta || '/' || d.val_progr_proposta AS num_proposta,
          d.dta_ins_delibera AS dta_inizio_proposta,
          NVL (d.flg_disposizione, p.disposizione) AS disposizione,
          NVL (d.flg_posiz_da_cedere, 'N') flg_posiz_da_cedere
     FROM t_mcrei_hst_delibere d,
          t_mcre0_app_all_data g,
          t_mcre0_app_istituti_all i,
          t_mcrei_cl_domini DO,
          t_mcrei_app_mpl_proposte p
    WHERE     d.cod_abi = p.cod_abi(+)
          AND d.cod_ndg = p.cod_ndg(+)
          AND d.val_anno_proposta = p.val_anno_proposta(+)
          AND TO_CHAR (d.val_progr_proposta) = p.val_progr_proposta(+)
          AND d.cod_abi = g.cod_abi_cartolarizzato
          AND d.cod_ndg = g.cod_ndg
          AND d.cod_abi = i.cod_abi
          AND d.cod_abi = DO.val_dominio(+)
          AND DO.cod_dominio(+) = 'LIM_INC_FORF';
