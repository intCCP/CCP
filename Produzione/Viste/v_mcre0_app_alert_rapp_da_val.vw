/* Formatted on 17/06/2014 18:00:34 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_RAPP_DA_VAL
(
   VAL_ALERT,
   COD_STRUTTURA_COMPETENTE,
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_PROCESSO,
   COD_STATO,
   DTA_DECORRENZA_STATO_ATTUALE,
   COD_GESTORE,
   COD_COMPARTO_POSIZIONE,
   COD_COMPARTO_UTENTE,
   COD_MICROTIPOLOGIA,
   COD_PRIV,
   DESC_COGNOME,
   DESC_NOME_CONTROPARTE,
   DESC_NOME,
   ID_UTENTE,
   DTA_INS_ALERT,
   DTA_SCADENZA_STATO,
   DTA_UTENTE_ASSEGNATO,
   DESC_ISTITUTO,
   COD_PROTOCOLLO_DELIBERA,
   VAL_NUM_RAPPORTI,
   COD_PROTOCOLLO_PACCHETTO,
   VAL_RETT_PROGRESSIVA,
   FLG_ABI_LAVORATO,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   VAL_ANA_GRE,
   VAL_ORDINE_COLORE,
   COD_FASE_DELIBERA,
   COD_RAMO_CALCOLATO,
   COD_MACROSTATO,
   VAL_UTI_TOT,
   COD_GRUPPO_SUPER
)
AS
   SELECT pos.alert AS val_alert,
          ad.cod_struttura_competente,
          ad.cod_sndg,
          ad.cod_abi_cartolarizzato,
          ad.cod_abi_istituto,
          ad.cod_ndg,
          ad.cod_gruppo_economico AS cod_gruppo_economico,
          ad.desc_gruppo_economico AS desc_gruppo_economico,
          ad.cod_struttura_competente_rg,
          ad.desc_struttura_competente_rg,
          ad.cod_struttura_competente_ar,
          ad.desc_struttura_competente_ar,
          ad.cod_struttura_competente_fi,
          ad.desc_struttura_competente_fi,
          ad.cod_struttura_competente_dc,
          ad.desc_struttura_competente_dc,
          ad.cod_processo,
          ad.cod_stato,
          ad.dta_decorrenza_stato AS dta_decorrenza_stato_attuale,
          ad.cod_gestore_mkt AS cod_gestore,
          ad.cod_comparto AS cod_comparto_posizione,
          ad.cod_comparto_utente,
          pos.cod_microtipologia_delib AS cod_microtipologia,
          ad.cod_priv,
          ad.cognome AS desc_cognome,
          ad.desc_nome_controparte,
          ad.nome AS desc_nome,
          ad.id_utente,
          pos.dta_ins AS dta_ins_alert,
          ad.dta_scadenza_stato,
          ad.dta_utente_assegnato,
          ad.desc_istituto,
          pos.cod_protocollo_delibera,
          pos.val_cnt_rapporti AS val_num_rapporti,
          pos.cod_protocollo_pacchetto,
          pos.val_rett_progressiva,
          -- A LIVELLO DI POSIZIONE, LA SOMMA, OPPURE L'ULTIMA ???
          '1' AS flg_abi_lavorato,
          ad.flg_gestore_abilitato,
          ad.id_referente,
          ad.desc_gruppo_economico AS val_ana_gre,
          DECODE (pos.alert, 'R', 9) AS val_ordine_colore,
          pos.cod_fase_delibera,
          ad.cod_ramo_calcolato,
          AD.COD_MACROSTATO,
          AD.SCSB_UTI_TOT VAL_UTI_TOT,
          AD.COD_GRUPPO_SUPER
     FROM (SELECT DISTINCT D.cod_abi,
                           D.cod_ndg,
                           D.cod_sndg,
                           --st_max.min_dta,
                           ST.val_cnt_rapporti,
                           ST.alert,
                           ST.dta_ins,
                           ST.val_ordine_colore,
                           -- st_max.max_dta,
                           D.cod_protocollo_delibera,
                           d.cod_fase_delibera,
                           d.cod_protocollo_pacchetto,
                           d.val_rdv_qc_progressiva AS val_rett_progressiva,
                           d.cod_microtipologia_delib
             FROM T_MCREI_APP_ALERT_POS_WRK PARTITION (inc_p01) st,
                  t_mcrei_app_delibere d
            WHERE     ST.cod_abi = d.cod_abi
                  AND ST.cod_ndg = d.cod_ndg
                  AND ST.cod_protocollo_delibera = d.cod_protocollo_delibera
                  AND d.flg_no_delibera = 0
                  AND d.flg_attiva = '1') pos,
          v_mcre0_app_upd_fields ad
    WHERE     pos.cod_abi = ad.cod_abi_cartolarizzato
          AND pos.cod_ndg = ad.cod_ndg;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_ALERT_RAPP_DA_VAL TO MCRE_USR;
