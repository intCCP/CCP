/* Formatted on 21/07/2014 18:32:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_RETT_DISX
(
   VAL_ALERT,
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_PROTOCOLLO_DELIBERA,
   DTA_STIMA_BATCH,
   DTA_STIMA,
   COD_GRUPPO_ECONOMICO,
   COD_STATO,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_PROCESSO,
   RDV_STIME_BATCH_CA,
   RDV_STIME_CA,
   RDV_STIME_BATCH_FI,
   RDV_STIME_FI,
   RDV_STIME_BATCH_TOT,
   RDV_STIME_TOT,
   DESC_COGNOME,
   DESC_NOME,
   COD_ABI_ISTITUTO,
   COD_COMPARTO_POSIZIONE,
   COD_COMPARTO_UTENTE,
   COD_FASE_DELIBERA,
   COD_MACROSTATO,
   COD_MICRO_TIPOL,
   COD_PRIV,
   COD_PROTOCOLLO_PACCHETTO,
   COD_RAMO_CALCOLATO,
   DTA_DECORRENZA_STATO,
   DTA_INS_ALERT,
   DTA_SCADENZA_STATO,
   DTA_UTENTE_ASSEGNATO,
   FLG_ABI_LAVORATO,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   ID_UTENTE,
   VAL_ANA_GRE,
   VAL_ORDINE_COLORE,
   VAL_RETT_CASSA_QC,
   VAL_RETT_CASSA_QC_DEL,
   VAL_RETT_FIRMA,
   VAL_RETT_FIRMA_DEL,
   VAL_RETT_TOT,
   VAL_RETT_TOT_DEL
)
AS
   SELECT pw.alert AS val_alert,
          bb.cod_sndg,
          bb.cod_abi AS cod_abi_cartolarizzato,
          ad.desc_istituto,
          bb.cod_ndg,
          ad.desc_nome_controparte,
          bb.cod_protocollo_delibera,
          bb.dta_stima dta_stima_batch,
          bb.dta_stima,
          ad.cod_gruppo_economico,
          ad.cod_stato,
          AD.cod_struttura_competente_ar,
          AD.desc_struttura_competente_ar,
          AD.cod_struttura_competente_fi,
          AD.desc_struttura_competente_fi,
          AD.cod_struttura_competente_rg,
          AD.desc_struttura_competente_rg,
          AD.cod_struttura_competente_dc,
          AD.desc_struttura_competente_dc,
          ad.cod_processo,
          bb.rdv_stime_batch_ca,
          bb.rdv_stime_ca,
          bb.rdv_stime_batch_fi,
          bb.rdv_stime_fi,
          bb.rdv_stime_batch_tot,
          bb.rdv_stime_tot,
          AD.cognome AS desc_cognome,
          AD.nome AS desc_nome,
          ad.cod_abi_istituto,
          ad.cod_comparto_assegnato AS cod_comparto_posizione,
          AD.cod_comparto_utente AS cod_comparto_utente,
          de.cod_fase_delibera,
          ad.cod_macrostato,
          de.cod_microtipologia_delib AS cod_micro_tipol,
          AD.cod_priv,
          de.cod_protocollo_pacchetto,
          ad.cod_ramo_calcolato,
          ad.dta_decorrenza_stato,
          pw.dta_ins AS dta_ins_alert,
          ad.dta_scadenza_stato,
          ad.dta_utente_assegnato,
          '1' AS flg_abi_lavorato,
          AD.flg_gestore_abilitato,
          AD.id_referente,
          AD.id_utente,
          ad.desc_gruppo_economico AS val_ana_gre,
          pw.val_ordine_colore,
          de.val_rdv_qc_progressiva AS val_rett_cassa_qc,
          de.val_rdv_qc_ante_delib AS val_rett_cassa_qc_del,
          de.val_rdv_progr_fi AS val_rett_firma,
          de.val_rdv_pregr_fi AS val_rett_firma_del,
          (NVL (de.val_rdv_qc_progressiva, 0) + NVL (de.val_rdv_progr_fi, 0))
             AS val_rett_tot,
          (NVL (de.val_rdv_qc_ante_delib, 0) + NVL (de.val_rdv_pregr_fi, 0))
             AS val_rett_tot_del
     FROM (SELECT p.cod_sndg,
                  p.cod_abi,
                  p.cod_ndg,
                  p.cod_protocollo_delibera,
                  p.cod_classe_ft,
                  p.dta_stima_batch,
                  p.dta_stima,
                  p.rdv_stime_batch_ca,
                  p.rdv_stime_ca,
                  p.rdv_stime_batch_fi,
                  p.rdv_stime_fi,
                  p.rdv_stime_batch_tot,
                  p.rdv_stime_tot
             FROM (SELECT *
                     FROM (SELECT DISTINCT
                                  b.cod_sndg,
                                  b.cod_abi,
                                  b.cod_ndg,
                                  b.cod_protocollo_delibera,
                                  b.cod_classe_ft,
                                  b.dta_stima dta_stima_batch,
                                  s.dta_stima,
                                  SUM (
                                     CASE
                                        WHEN b.cod_classe_ft = 'CA'
                                        THEN
                                           b.val_rdv_tot
                                        ELSE
                                           0
                                     END)
                                  OVER (
                                     PARTITION BY b.cod_abi,
                                                  b.cod_ndg,
                                                  b.cod_protocollo_delibera,
                                                  b.cod_classe_ft)
                                     rdv_stime_batch_ca,
                                  SUM (
                                     CASE
                                        WHEN s.cod_classe_ft = 'CA'
                                        THEN
                                           s.val_rdv_tot
                                        ELSE
                                           0
                                     END)
                                  OVER (
                                     PARTITION BY s.cod_abi,
                                                  s.cod_ndg,
                                                  s.cod_protocollo_delibera,
                                                  s.cod_classe_ft)
                                     rdv_stime_ca,
                                  SUM (
                                     CASE
                                        WHEN b.cod_classe_ft = 'FI'
                                        THEN
                                           b.val_rdv_tot
                                        ELSE
                                           0
                                     END)
                                  OVER (
                                     PARTITION BY b.cod_abi,
                                                  b.cod_ndg,
                                                  b.cod_protocollo_delibera,
                                                  b.cod_classe_ft)
                                     rdv_stime_batch_fi,
                                  SUM (
                                     CASE
                                        WHEN s.cod_classe_ft = 'FI'
                                        THEN
                                           s.val_rdv_tot
                                        ELSE
                                           0
                                     END)
                                  OVER (
                                     PARTITION BY s.cod_abi,
                                                  s.cod_ndg,
                                                  s.cod_protocollo_delibera,
                                                  s.cod_classe_ft)
                                     rdv_stime_fi,
                                  SUM (
                                     NVL (b.val_rdv_tot, 0))
                                  OVER (
                                     PARTITION BY b.cod_abi,
                                                  b.cod_ndg,
                                                  b.cod_protocollo_delibera)
                                     rdv_stime_batch_tot,
                                  SUM (
                                     NVL (s.val_rdv_tot, 0))
                                  OVER (
                                     PARTITION BY s.cod_abi,
                                                  s.cod_ndg,
                                                  s.cod_protocollo_delibera)
                                     rdv_stime_tot
                             FROM (SELECT cod_abi,
                                          cod_sndg,
                                          cod_ndg,
                                          --COD_RAPPORTO,
                                          dta_stima,
                                          flg_tipo_dato,
                                          cod_protocollo_delibera,
                                          cod_classe_ft,
                                          val_rdv_tot,
                                          MAX (
                                             dta_stima)
                                          OVER (
                                             PARTITION BY cod_abi, cod_ndg)
                                             AS max_stima
                                     FROM t_mcrei_app_stime
                                          PARTITION (inc_pattive)) s,
                                  (SELECT DISTINCT
                                          cod_abi,
                                          cod_sndg,
                                          cod_ndg,
                                          -- COD_RAPPORTO,
                                          dta_stima,
                                          flg_tipo_dato,
                                          cod_protocollo_delibera,
                                          cod_classe_ft,
                                          SUM (
                                             val_rdv_tot)
                                          OVER (
                                             PARTITION BY cod_abi,
                                                          cod_ndg,
                                                          cod_protocollo_delibera)
                                             val_rdv_tot,
                                          MAX (
                                             dta_stima)
                                          OVER (
                                             PARTITION BY cod_abi, cod_ndg)
                                             AS max_stima_batch
                                     FROM t_mcrei_app_stime_batch) b
                            WHERE     s.dta_stima = s.max_stima
                                  AND b.dta_stima = b.max_stima_batch
                                  AND s.cod_abi = b.cod_abi
                                  AND s.cod_ndg = b.cod_ndg
                                  -- AND s.cod_rapporto = b.cod_rapporto
                                  AND s.flg_tipo_dato = b.flg_tipo_dato
                                  AND s.cod_protocollo_delibera =
                                         b.cod_protocollo_delibera
                                  AND b.cod_classe_ft IN ('CA', 'FI'))
                    WHERE    rdv_stime_batch_ca <> rdv_stime_ca
                          OR rdv_stime_batch_fi <> rdv_stime_fi) p) bb,
          v_mcre0_app_upd_fields ad,
          t_mcrei_app_alert_pos_wrk PARTITION (INC_P07) pw,
          t_mcrei_app_delibere PARTITION (inc_pattive) de
    WHERE     ad.flg_target = 'Y'
          AND ad.flg_outsourcing = 'Y'
          AND pw.cod_abi = ad.cod_abi_cartolarizzato
          AND pw.cod_ndg = ad.cod_ndg
          AND pw.cod_abi = bb.cod_abi
          AND pw.cod_ndg = bb.cod_ndg
          AND pw.id_alert = 7
          AND pw.cod_abi = de.cod_abi
          AND pw.cod_ndg = de.cod_ndg
          AND de.cod_fase_delibera NOT IN ('AN', 'AM')
          AND de.flg_no_delibera = 0
          AND de.cod_protocollo_delibera = bb.cod_protocollo_delibera;
