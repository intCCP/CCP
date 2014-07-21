/* Formatted on 17/06/2014 18:17:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCREI_APP_DETT_DELIB_TRANSAZ
(
   COD_ABI,
   COD_NDG,
   COD_MACROTIPOLOGIA_DELIB,
   COD_MICROTIPOLOGIA_DELIB,
   DESC_MICROTIPOLOGIA,
   DESC_MACROTIPOLOGIA,
   COD_STATO_RISCHIO,
   COD_PROTOCOLLO_PACCHETTO,
   COD_PROTOCOLLO_DELIBERA,
   VAL_ACCORDATO_TOT,
   VAL_ACCORDATO_CASSA,
   VAL_ACCORDATO_FIRMA,
   VAL_ACCORDATO_DERIVATI,
   VAL_ESPOSIZIONE_TOT,
   VAL_ESPOSIZIONE_CASSA,
   VAL_ESPOSIZIONE_CASSA_QTA_CAP,
   VAL_ESPOSIZIONE_CASSA_MORA,
   VAL_ESPOSIZIONE_FIRMA,
   VAL_ESPOSIZIONE_DERIVATI,
   VAL_RDV_TOT,
   VAL_RDV_CASSA,
   VAL_RDV_FIRMA,
   VAL_RDV_DERIVATI,
   VAL_RINUNCIA_TOTALE,
   VAL_STRALCI_CONTABILIZZATI,
   VAL_RINUNCIA_DELIBERATA,
   VAL_RINUNCIA_CAPITALE,
   VAL_RINUNCIA_MORA,
   VAL_PERC_RINUNCIA,
   DTA_SCADENZA_TRANSAZIONE,
   FLG_TASSO_BASE_APPL,
   FLG_STRALCIO_CREDITO_IRRECUP,
   DESC_NOTE,
   FLG_NO_GARANZIE_CAPIENTI,
   FLG_NO_COLLEG_ALTRE_POS,
   FLG_NO_RISCHI_FIRMA,
   FLG_PERDUR_DIFFICOLTA_ECON,
   FLG_NO_PATRIMON_AGGRED,
   FLG_NO_PRESUPPOSTI_CLASS_SOFF,
   FLG_NO_GRUPPO_ECONOMICO,
   NUOVA_RINUNCIA_PROPOSTA,
   VAL_SACRIFICIO,
   VAL_SACRIFICIO_DI_CUI_CAPIT,
   RINUNCIA_CONTABILIZZATA
)
AS
   SELECT DISTINCT
          d.cod_abi,
          d.cod_ndg,
          d.cod_macrotipologia_delib,
          d.cod_microtipologia_delib,
          t1.desc_microtipologia,
          t2.desc_macrotipologia,
          ad.cod_stato AS cod_stato_rischio,
          d.cod_protocollo_pacchetto,
          d.cod_protocollo_delibera,
          -- ACCORDATI
          DECODE (d.cod_fase_delibera, 'IN', d.scsb_acc_tot, d.val_accordato)
             AS val_accordato_tot,
          DECODE (d.cod_fase_delibera,
                  'IN', d.scsb_acc_cassa,
                  d.val_accordato_cassa)
             AS val_accordato_cassa,
          DECODE (d.cod_fase_delibera,
                  'IN', d.scsb_acc_firma,
                  d.val_accordato_firma)
             AS val_accordato_firma,
          DECODE (d.cod_fase_delibera,
                  'IN', d.scsb_acc_sostituzioni,
                  d.val_accordato_derivati)
             AS val_accordato_derivati,
          -- ESPOSIZIONI
          DECODE (d.cod_fase_delibera,
                  'IN', d.scsb_uti_tot,
                  d.val_uti_tot_scsb)
             AS val_esposizione_tot,
          DECODE (d.cod_fase_delibera,
                  'IN', d.scsb_uti_cassa,
                  d.val_uti_cassa_scsb)
             AS val_esposizione_cassa,
          DECODE (
             d.cod_fase_delibera,
             'IN', NVL (d.scsb_uti_cassa, 0) - NVL (i.interessi_di_mora, 0),
             (d.val_uti_cassa_scsb))
             AS val_esposizione_cassa_qta_cap,
          NVL (i.interessi_di_mora, 0) AS val_esposizione_cassa_mora,
          DECODE (d.cod_fase_delibera,
                  'IN', d.scsb_uti_firma,
                  d.val_uti_firma_scsb)
             AS val_esposizione_firma,
          DECODE (d.cod_fase_delibera,
                  'IN', d.scsb_uti_sostituzioni,
                  d.val_uti_sosti_scsb)
             AS val_esposizione_derivati,
          -- RETTIFICHE DI VALORE  ----10 APRILE
          NVL (d.val_rdv_progr_fi, 0) + NVL (d.val_rdv_qc_progressiva, 0)
             AS val_rdv_tot,            --STIM_IMP.VAL_RDV_TOT AS VAL_RDV_TOT,
          NVL (d.val_rdv_qc_progressiva, 0) AS val_rdv_cassa,
          NVL (d.val_rdv_progr_fi, 0) AS val_rdv_firma,
          0 AS val_rdv_derivati,
          -- RINUNCE
          --mm0808
          CASE
             WHEN cod_fase_delibera IN ('IN', 'CM')
             THEN
                  NVL (
                     mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct (
                        d.cod_abi,
                        d.cod_ndg),
                     0)
                --               +  NVL (
                --                   mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia(d.cod_abi, d.cod_ndg,'CM'),0)
                + NVL (
                     mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (
                        d.cod_abi,
                        d.cod_ndg,
                        'CO'),
                     0)
                + NVL (val_rinuncia_capitale, 0)
                + NVL (val_rinuncia_mora, 0)
             ELSE
                NVL (d.val_imp_perdita, 0)
          END
             AS val_rinuncia_totale,                               --17 aprile
          CASE                   ---stralci contabilizzati modificato il 28/08
             WHEN cod_fase_delibera IN ('IN', 'CM')
             THEN
                NVL (
                   mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct (
                      d.cod_abi,
                      d.cod_ndg),
                   0)
             ELSE
                d.Val_Stralcio_Senza_Accantonam ---valore salvato all'atto dell acreazione della delibera
          END
             AS val_stralci_contabilizzati,
          CASE
             WHEN cod_fase_delibera IN ('IN', 'CM')
             THEN
                (  0
                 --                  NVL (
                 --             mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (d.cod_abi,
                 --                                                                                                d.cod_ndg,
                 --                                                                                                'CM'),
                 --             0
                 --         )
                 + NVL (
                      mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (
                         d.cod_abi,
                         d.cod_ndg,
                         'CO'),
                      0))
             ELSE
                0             --22.08MM da capire... d.val_rinuncia_deliberata
          END
             AS val_rinuncia_deliberata,
          d.val_rinuncia_capitale,
          d.val_rinuncia_mora,
          (CASE
              WHEN COD_FASE_DELIBERA IN ('IN', 'CM')
              THEN
                 DECODE (
                    (  (NVL (
                           DECODE (d.cod_fase_delibera,
                                   'IN', d.scsb_uti_cassa,
                                   d.val_uti_cassa_scsb),
                           0))
                     + NVL (
                          mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct (
                             d.cod_abi,
                             d.cod_ndg),
                          0)),
                    0, 100,
                    TRUNC (
                         ( (  (  NVL (
                                    mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct (
                                       d.cod_abi,
                                       d.cod_ndg),
                                    0)
                               --                          +  NVL (
                               --                              mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia(d.cod_abi, d.cod_ndg,'CM'),0)
                               + NVL (
                                    mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (
                                       d.cod_abi,
                                       d.cod_ndg,
                                       'CO'),
                                    0)
                               + NVL (val_rinuncia_capitale, 0)
                               + NVL (val_rinuncia_mora, 0))
                            / (  (NVL (
                                     DECODE (d.cod_fase_delibera,
                                             'IN', d.scsb_uti_cassa,
                                             d.val_uti_cassa_scsb),
                                     0))
                               + NVL (
                                    mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct (
                                       d.cod_abi,
                                       d.cod_ndg),
                                    0))))
                       * 100))
              ELSE
                 TO_NUMBER (D.VAL_PERC_PERD_RM)
           END)
             AS val_perc_rinuncia,                                    --12 lug
          d.dta_scadenza_transaz,
          TO_CHAR (d.val_tasso_base_appl) AS flg_tasso_base_appl,
          DECODE (d.cod_microtipologia_delib, 'G1', 'Y', 'N')
             AS flg_stralcio_credito_irrecup,
          d.desc_note,
          flg_no_garanzie_capienti,
          flg_no_colleg_altre_pos,
          flg_no_rischi_firma,
          flg_perdur_difficolta_econ,
          flg_no_patrimon_aggred,
          flg_no_presupposti_class_soff,
          flg_no_gruppo_economico,
          --d.val_imp_perdita AS "NUOVA_RINUNCIA_PROPOSTA",
          --0608 - sommo val rinuncia capitale + mora
          NVL (val_rinuncia_capitale, 0) + NVL (val_rinuncia_mora, 0)
             AS "NUOVA_RINUNCIA_PROPOSTA",
            NVL (d.val_stralcio_quota_cap, 0)
          + NVL (d.val_stralcio_quota_mora, 0)
             AS val_sacrificio,
          NVL (d.val_stralcio_quota_cap, 0) AS val_sacrificio_di_cui_capit, --17 apr
          NVL (
             mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct (
                d.cod_abi,
                d.cod_ndg),
             0)
             AS RINUNCIA_CONTABILIZZATA
     FROM (SELECT d.*,
                  r.scsb_uti_tot,
                  r.scsb_uti_sostituzioni,
                  r.scsb_uti_firma,
                  r.scsb_uti_cassa,
                  r.scsb_acc_tot,
                  r.scsb_acc_sostituzioni,
                  r.scsb_acc_firma,
                  r.scsb_acc_cassa
             FROM t_mcrei_app_delibere d, t_mcrei_app_pcr_rapp_aggr r
            WHERE     d.cod_abi = r.cod_abi_cartolarizzato(+)
                  AND d.cod_ndg = r.cod_ndg(+)) d,
          t_mcre0_app_all_data_DAY ad,
          t_mcrei_cl_tipologie t1,
          t_mcrei_cl_tipologie t2,
          (SELECT cod_abi_cartolarizzato,
                  cod_ndg,
                  SUM (NVL (i.val_imp_mora, 0))
                     OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg)
                     AS interessi_di_mora
             FROM t_mcre0_app_rate_daily i                               --5/3
                                          ) i
    WHERE     d.flg_attiva = '1'
          AND d.cod_abi = ad.cod_abi_cartolarizzato
          AND d.cod_ndg = ad.cod_ndg
          AND ad.today_flg = 1
          AND ad.cod_abi_cartolarizzato = i.cod_abi_cartolarizzato(+)
          AND ad.cod_ndg = i.cod_ndg(+)
          AND d.cod_microtipologia_delib = t1.cod_microtipologia(+)
          AND t1.flg_attivo(+) = 1
          AND (   t1.cod_famiglia_tipologia(+) IN ('DTR', 'DRV') --aggiunta DRV il 3 maggio
               OR t1.cod_microtipologia(+) = 'IR')                    --130423
          AND d.cod_macrotipologia_delib = t2.cod_macrotipologia(+)
          AND t2.flg_attivo(+) = 1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCREI_APP_DETT_DELIB_TRANSAZ TO MCRE_USR;
