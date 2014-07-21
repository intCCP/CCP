/* Formatted on 17/06/2014 18:07:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DATI_GENERALI_MPL
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
   SELECT P.COD_NDG,
          P.NOME_CONTROPARTE AS DESC_NOME_CONTROPARTE,
          P.COD_ABI AS COD_ABI_CARTOLARIZZATO,
          P.DESC_IST AS DESC_ISTITUTO,
          D.COD_SNDG AS COD_SNDG,
          D.COD_PROTOCOLLO_DELIBERA,
          D.COD_PROTOCOLLO_PACCHETTO,
          D.COD_ORGANO_DELIBERANTE,
          NULLIF (D.COD_STATO_PROVENIENZA, '-1') AS STATO_PROVENIENZA,
          D.DTA_DECORRENZA_STATO,
          DECODE (d.desc_tipo_gestione,
                  'A', 'FORFETTARIO',
                  'E', 'ANALITICO',
                  '')
             AS tipo_gestione,
          d.desc_tipo_gestione AS cod_tipo_gestione,
          d.dta_ins_delibera AS data_ins_delibera,
          --p.dta_disposizione e' sempre NULL
          P.COD_UO_PROPONENTE AS COD_UO_PROPONENTE,
          P.COD_UTENTE AS cod_matr_proponente,
          p.DTA_INIZIO_RAPP AS data_inizio_rapporti,
          d.desc_motivo_pass_rischio AS motivo_passaggio_rischio,
          -- =?  p.DESC_CAUSALE_APE_PRO
          D.DTA_MOTIVO_PASS_RISCHIO,
          -- =? p.DTA_INIZ_MOTIVI_APE_PRO
          d.cod_sag,
          d.cod_stato_sag,
          NVL (d.dta_calc_conf_sag, d.dta_conferma_pacchetto) AS dta_sag,
          NULL AS modalita_conferma_sag,                                -- ???
          NVL (p.FLG_INTERV_ORG_SUP, 'N') flg_interven_organi_superiori,
          -- dato manuale
          p.DTA_ULTIMA_DELIB_FIDO AS dta_ult_delibera_fido,
          p.COD_UO_DELIB_ULT_FIDO AS ult_organo_delib_fido,
          p.DTA_REVOCA_FIDO AS data_revoca_fido, -- rischi indiretti rilevati da PCR
          P.VAL_TOT_ULT_RISCHI_GRUP_CRED AS scgb_uti_rischi_indiretti, -- d.val_rischi_indiretti
          NVL (p.DEPOSITI_COLLATERALI, 'N') flg_depositi_collaterali,
          p.VAL_IMP_ESP_COMPL AS esp_singolo_cliente_gb,              --- ????
          p.FLG_AFFID_SOC_RECUPERO AS flg_affid_soc_rec,
          NVL (p.FLG_SOG_FALLIBILE, 'N') flg_soggetto_pot_fallibile, -- dato manuale
          NVL (p.FLG_PRESENZA_COVENANTS, 'N') flg_presen_covenants, -- dato manuale
          d.val_uti_tot_gegb AS esp_ge_gb,
          g.cod_gruppo_economico,                                  -- 27319823
          g.desc_gruppo_economico,
          P.COD_TIPO_RISCHIO AS proposta_di_stato_rischio, --d.cod_tipo_proposta
          d.dta_conferma_delibera AS dta_conferma_proposta,
          d.cod_fase_delibera AS stato_proposta,
          p.desc_ramo_affari AS ramo_affari,
          p.cod_desc_delibera_fido AS liv_ultimo_delib_fido,
          d.dta_last_upd_delibera AS dta_ultimo_aggiornamento,
          p.val_anno_proposta || '/' || p.val_progr_proposta AS num_proposta,
          d.dta_ins_delibera AS dta_inizio_proposta,
          p.DISPOSIZIONE,
          NVL (d.flg_posiz_da_cedere, 'N') flg_posiz_da_cedere         --> '??
     FROM mcre_own.T_MCREI_APP_MPL_PROPOSTE P,
          T_MCREI_APP_DELIBERE D,
          t_mcre0_App_all_data g
    --T_MCREI_APP_MPL_RAPPORTI
    WHERE     P.COD_ABI = D.COD_ABI
          AND P.COD_NDG = D.COD_NDG
          AND P.VAL_ANNO_PROPOSTA = D.VAL_ANNO_PROPOSTA
          AND P.VAL_PROGR_PROPOSTA = D.VAL_PROGR_PROPOSTA
          AND p.cod_abi = g.cod_abi_cartolarizzato
          AND p.cod_ndg = g.cod_ndg;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DATI_GENERALI_MPL TO MCRE_USR;
