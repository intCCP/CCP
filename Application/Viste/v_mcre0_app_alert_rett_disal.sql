/* Formatted on 21/07/2014 18:32:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_RETT_DISAL
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
   VAL_RETT_TOT_DEL,
   VAL_UTI_TOT,
   COD_GRUPPO_SUPER
)
AS
   SELECT DISTINCT
          pw.alert AS val_alert,
          ad.cod_sndg,
          ad.cod_abi_cartolarizzato,
          ad.desc_istituto,
          ad.cod_ndg,
          ad.desc_nome_controparte,
          de.cod_protocollo_delibera,
          b.dta_stima dta_stima_batch,
          s.dta_stima,
          ad.cod_gruppo_economico,
          ad.cod_stato,
          ad.cod_struttura_competente_ar,
          ad.desc_struttura_competente_ar,
          ad.cod_struttura_competente_fi,
          ad.desc_struttura_competente_fi,
          ad.cod_struttura_competente_rg,
          ad.desc_struttura_competente_rg,
          ad.cod_struttura_competente_dc,
          ad.desc_struttura_competente_dc,
          ad.cod_processo,
          NVL (rdv_stime_batch_ca, 0) rdv_stime_batch_ca,
          NVL (rdv_stime_ca, 0) rdv_stime_ca,
          NVL (rdv_stime_batch_fi, 0) rdv_stime_batch_fi,
          NVL (rdv_stime_fi, 0) rdv_stime_fi,
          NVL (rdv_stime_batch_tot, 0) rdv_stime_batch_tot,
          NVL (rdv_stime_tot, 0) rdv_stime_tot,
          ad.cognome AS desc_cognome,
          ad.nome AS desc_nome,
          ad.cod_abi_istituto,
          ad.cod_comparto_assegnato AS cod_comparto_posizione,
          ad.cod_comparto_utente AS cod_comparto_utente,
          de.cod_fase_delibera,
          ad.cod_macrostato,
          de.cod_microtipologia_delib AS cod_micro_tipol,
          ad.cod_priv,
          de.cod_protocollo_pacchetto,
          ad.cod_ramo_calcolato,
          ad.dta_decorrenza_stato,
          pw.dta_ins AS dta_ins_alert,
          ad.dta_scadenza_stato,
          ad.dta_utente_assegnato,
          '1' AS flg_abi_lavorato,
          ad.flg_gestore_abilitato,
          ad.id_referente,
          ad.id_utente,
          ad.desc_gruppo_economico AS val_ana_gre,
          pw.val_ordine_colore,
          NVL (rdv_stime_batch_ca, 0) AS val_rett_cassa_qc,
          NVL (de.val_rdv_qc_progressiva, 0) AS val_rett_cassa_qc_del,
          NVL (rdv_stime_batch_fi, 0) AS val_rett_firma,
          NVL (de.val_rdv_progr_fi, 0) AS val_rett_firma_del,
          NVL (rdv_stime_batch_tot, 0) AS val_rett_tot,
          (NVL (de.val_rdv_qc_progressiva, 0) + NVL (de.val_rdv_progr_fi, 0))
             AS val_rett_tot_del,
          AD.SCSB_UTI_TOT VAL_UTI_TOT,
          AD.COD_GRUPPO_SUPER
     FROM v_mcre0_app_upd_fields ad,
          t_mcrei_app_alert_pos_wrk PARTITION (inc_p07) pw,
          t_mcrei_app_delibere de,
          (SELECT DISTINCT
                  s.cod_abi,
                  s.cod_sndg,
                  s.cod_ndg,
                  s.cod_protocollo_delibera,
                  SUM (
                     DECODE (
                        d.cod_tipo_pacchetto,
                        'M', DECODE (cod_classe_ft,
                                     'CA', val_rdv_tot,
                                     TO_CHAR (NULL), val_rdv_tot,
                                     0),
                        'A', DECODE (
                                cod_classe_ft,
                                'CA', DECODE (s.flg_tipo_dato,
                                              'S', s.val_prev_recupero,
                                              NVL (val_rdv_tot, 0)),
                                TO_CHAR (NULL), DECODE (
                                                   s.flg_tipo_dato,
                                                   'S', s.val_prev_recupero,
                                                   NVL (val_rdv_tot, 0)),
                                0)))
                  OVER (
                     PARTITION BY s.cod_abi,
                                  s.cod_ndg,
                                  s.cod_protocollo_delibera)
                     rdv_stime_ca,
                  SUM (
                     DECODE (
                        d.cod_tipo_pacchetto,
                        'M', DECODE (cod_classe_ft, 'FI', val_rdv_tot, 0),
                        'A', DECODE (
                                cod_classe_ft,
                                'FI', DECODE (s.flg_tipo_dato,
                                              'S', s.val_prev_recupero,
                                              NVL (val_rdv_tot, 0)),
                                TO_CHAR (NULL), DECODE (
                                                   s.flg_tipo_dato,
                                                   'S', s.val_prev_recupero,
                                                   NVL (val_rdv_tot, 0)),
                                0)))
                  OVER (
                     PARTITION BY s.cod_abi,
                                  s.cod_ndg,
                                  s.cod_protocollo_delibera)
                     rdv_stime_fi,
                  SUM (
                     DECODE (
                        d.cod_tipo_pacchetto,
                        'M', NVL (val_rdv_tot, 0),
                        'A', DECODE (s.flg_tipo_dato,
                                     'S', s.val_prev_recupero,
                                     NVL (val_rdv_tot, 0))))
                  OVER (
                     PARTITION BY s.cod_abi,
                                  s.cod_ndg,
                                  s.cod_protocollo_delibera)
                     rdv_stime_tot,
                  MAX (dta_stima) OVER (PARTITION BY s.cod_abi, s.cod_ndg)
                     AS dta_stima
             FROM t_mcrei_app_alert_pos_wrk PARTITION (inc_p07) p,
                  t_mcrei_app_delibere d,
                  t_mcrei_app_stime PARTITION (inc_pattive) s
            WHERE     p.cod_abi = s.cod_abi
                  AND p.cod_ndg = s.cod_ndg
                  AND p.cod_protocollo_delibera = s.cod_protocollo_delibera
                  AND p.cod_abi = d.cod_abi
                  AND p.cod_ndg = d.cod_ndg
                  AND p.cod_protocollo_delibera = d.cod_protocollo_delibera) s,
          (SELECT s.cod_abi,
                  s.cod_sndg,
                  s.cod_ndg,
                  s.cod_protocollo_delibera,
                  SUM (
                     DECODE (
                        d.cod_tipo_pacchetto,
                        'M', DECODE (cod_classe_ft,
                                     'CA', val_rdv_tot,
                                     TO_CHAR (NULL), val_rdv_tot,
                                     0),
                        'A', DECODE (
                                cod_classe_ft,
                                'CA', DECODE (s.flg_tipo_dato,
                                              'S', s.val_prev_recupero,
                                              NVL (val_rdv_tot, 0)),
                                TO_CHAR (NULL), DECODE (
                                                   s.flg_tipo_dato,
                                                   'S', s.val_prev_recupero,
                                                   NVL (val_rdv_tot, 0)),
                                0)))
                  OVER (
                     PARTITION BY s.cod_abi,
                                  s.cod_ndg,
                                  s.cod_protocollo_delibera)
                     rdv_stime_batch_ca,
                  SUM (
                     DECODE (
                        d.cod_tipo_pacchetto,
                        'M', DECODE (cod_classe_ft, 'FI', val_rdv_tot, 0),
                        'A', DECODE (
                                cod_classe_ft,
                                'FI', DECODE (s.flg_tipo_dato,
                                              'S', s.val_prev_recupero,
                                              NVL (val_rdv_tot, 0)),
                                TO_CHAR (NULL), DECODE (
                                                   s.flg_tipo_dato,
                                                   'S', s.val_prev_recupero,
                                                   NVL (val_rdv_tot, 0)),
                                0)))
                  OVER (
                     PARTITION BY s.cod_abi,
                                  s.cod_ndg,
                                  s.cod_protocollo_delibera)
                     rdv_stime_batch_fi,
                  SUM (
                     DECODE (
                        d.cod_tipo_pacchetto,
                        'M', NVL (val_rdv_tot, 0),
                        'A', DECODE (s.flg_tipo_dato,
                                     'S', s.val_prev_recupero,
                                     NVL (val_rdv_tot, 0))))
                  OVER (
                     PARTITION BY s.cod_abi,
                                  s.cod_ndg,
                                  s.cod_protocollo_delibera)
                     rdv_stime_batch_tot,
                  MAX (dta_stima) OVER (PARTITION BY s.cod_abi, s.cod_ndg)
                     AS dta_stima
             FROM t_mcrei_app_alert_pos_wrk PARTITION (inc_p07) p,
                  t_mcrei_app_delibere d,
                  t_mcrei_app_stime_batch s
            WHERE     s.cod_abi = p.cod_abi
                  AND s.cod_ndg = p.cod_ndg
                  AND s.cod_protocollo_delibera = p.cod_protocollo_delibera
                  AND s.cod_abi = d.cod_abi
                  AND s.cod_ndg = d.cod_ndg
                  AND s.cod_protocollo_delibera = d.cod_protocollo_delibera) b
    WHERE     ad.flg_target = 'Y'
          AND ad.flg_outsourcing = 'Y'
          AND pw.cod_abi = ad.cod_abi_cartolarizzato
          AND pw.cod_ndg = ad.cod_ndg
          AND pw.cod_abi = s.cod_abi
          AND pw.cod_ndg = s.cod_ndg
          AND pw.cod_protocollo_delibera = s.cod_protocollo_delibera
          AND pw.cod_abi = b.cod_abi
          AND pw.cod_ndg = b.cod_ndg
          AND pw.cod_protocollo_delibera = b.cod_protocollo_delibera
          AND s.cod_abi = b.cod_abi
          AND s.cod_ndg = b.cod_ndg
          AND s.cod_protocollo_delibera = b.cod_protocollo_delibera
          AND pw.id_alert = 7
          AND pw.cod_abi = de.cod_abi
          AND pw.cod_ndg = de.cod_ndg
          AND pw.cod_protocollo_delibera = de.cod_protocollo_delibera
          AND de.cod_fase_delibera NOT IN ('AN', 'AM', 'VA')           --13dic
          --     AND de.cod_tipo_pacchetto = 'M'
          AND de.flg_no_delibera = 0
          AND de.flg_attiva = '1';
