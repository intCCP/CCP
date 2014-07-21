/* Formatted on 21/07/2014 18:32:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_RAPP_DA_VALX
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
   COD_MACROSTATO
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
          ad.cod_macrostato
     FROM (SELECT DISTINCT st_max.cod_abi,
                           st_max.cod_ndg,
                           st_max.cod_sndg,
                           st_max.min_dta,
                           st_max.val_cnt_rapporti,
                           st_max.alert,
                           st_max.dta_ins,
                           st_max.val_ordine_colore,
                           st_max.max_dta,
                           st.cod_protocollo_delibera,
                           d.cod_fase_delibera,
                           d.cod_protocollo_pacchetto,
                           d.val_rdv_qc_progressiva AS val_rett_progressiva,
                           d.cod_microtipologia_delib
             FROM (SELECT pw.cod_abi,
                          pw.cod_ndg,
                          pw.cod_sndg,
                          s.cod_microtipologia_delibera,
                          s.cod_protocollo_delibera,
                          TO_DATE (NULL) min_dta,
                          pw.val_cnt_rapporti,
                          pw.alert,
                          pw.dta_ins,
                          pw.val_ordine_colore,
                          MAX (dta_stima)
                             OVER (PARTITION BY s.cod_abi, s.cod_ndg)
                             AS max_dta,
                          cod_rapporto
                     FROM t_mcrei_app_stime PARTITION (inc_pattive) s,
                          t_mcrei_app_alert_pos_wrk PARTITION (inc_p01) pw
                    -- CONDIZIONI DI ACCENSIONE ALERT "INTRINSECHE"
                    WHERE     pw.cod_abi = s.cod_abi(+)
                          AND pw.cod_ndg = s.cod_ndg(+)) st_max,
                  t_mcrei_app_stime PARTITION (inc_pattive) st,
                  t_mcrei_app_delibere d
            WHERE     st_max.cod_abi = st.cod_abi(+)
                  AND st_max.cod_ndg = st.cod_ndg(+)
                  AND st_max.cod_rapporto = st.cod_rapporto(+)
                  AND st_max.max_dta = st.dta_stima(+)
                  AND st_max.cod_protocollo_delibera =
                         st.cod_protocollo_delibera(+)
                  AND (   st_max.cod_protocollo_delibera IS NULL
                       OR (    st_max.cod_protocollo_delibera IS NOT NULL
                           AND st.cod_rapporto IS NOT NULL))
                  AND st_max.cod_abi = d.cod_abi(+)
                  AND st_max.cod_ndg = d.cod_ndg(+)
                  AND st_max.cod_protocollo_delibera =
                         d.cod_protocollo_delibera(+)) pos,
          v_mcre0_app_upd_fields ad
    WHERE     pos.cod_abi = ad.cod_abi_cartolarizzato
          AND pos.cod_ndg = ad.cod_ndg
          AND ad.flg_outsourcing = 'Y'
          AND ad.flg_target = 'Y';
