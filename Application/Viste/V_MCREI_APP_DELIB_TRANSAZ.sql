/* Formatted on 21/07/2014 18:39:35 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DELIB_TRANSAZ
(
   COD_SNDG,
   COD_ABI,
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_PROTOCOLLO_PACCHETTO,
   COD_MACROTIPOLOGIA_DELIB,
   DESC_MACROTIPOLOGIA,
   COD_MICROTIPOLOGIA_DELIB,
   DESC_MICROTIPOLOGIA,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   STATO_DI_RISCHIO,
   UTILIZZATO_TOTALE,
   VAL_ESP_LORDA,
   SCSB_UTI_CASSA,
   INTERESSI_DI_MORA,
   VAL_RINUNCIA_PREGRESSA,
   VAL_RINUNCIA_CAPITALE,
   VAL_RINUNCIA_MORA,
   VAL_RINUNCIA_TOTALE,
   DTA_SCADENZA_TRANSAZ,
   VAL_RINUNCIA_PERC,
   FLG_NO_DELIBERA,
   COD_FASE_DELIBERA,
   COD_FASE_MICROTIPOLOGIA,
   COD_FASE_PACCHETTO,
   DESC_NOTE,
   RETTIFICA_ESISTENTE_CASSA,
   ORDINAMENTO,
   COD_DOC_APPENDICE_PARERE,
   COD_DOC_CLASSIFICAZIONE,
   COD_DOC_DELIBERA_BANCA,
   COD_DOC_DELIBERA_CAPOGRUPPO,
   COD_DOC_PARERE_CONFORMITA,
   FLG_RISTRUTTURATO,
   COD_TIPO_GESTIONE,
   DESC_NO_DELIBERA,
   COD_DOC_CLASSIFICAZIONE_MCI
)
AS
   SELECT DISTINCT
          d.cod_sndg,                               ---1 giu aggiunta distinct
          d.cod_abi,
          i.cod_abi_visualizzato AS cod_abi_cartolarizzato,
          i.desc_istituto,
          d.cod_ndg,
          d.cod_protocollo_delibera,
          d.cod_protocollo_pacchetto,
          d.cod_macrotipologia_delib,
          t.desc_macrotipologia,
          d.cod_microtipologia_delib,
          t.desc_microtipologia,
          a.dta_decorrenza_stato,
          a.dta_scadenza_stato,
          a.cod_stato AS stato_di_rischio,
          d.scsb_uti_tot AS utilizzato_totale,                         --ca+fi
          (NVL (d.scsb_uti_cassa, 0) + NVL (rate.interessi_di_mora, 0))
             AS val_esp_lorda,
          d.scsb_uti_cassa,
          NVL (rate.interessi_di_mora, 0) AS interessi_di_mora,
          --mm0808
          --val_rinuncia_deliberata AS val_rinuncia_pregressa,       ---10 APRILE
          NVL (
             mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct (
                d.cod_abi,
                d.cod_ndg),
             0)
             AS val_rinuncia_pregressa,
          val_rinuncia_capitale,
          val_rinuncia_mora,
          --val_imp_perdita AS val_rinuncia_totale,
          --mm0808
          CASE
             WHEN cod_fase_delibera IN ('IN', 'CM')
             THEN
                  NVL (
                     mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct (
                        d.cod_abi,
                        d.cod_ndg),
                     0)
                --      + NVL (
                --       mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia(d.cod_abi, d.cod_ndg,'CM'),0)
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
             AS val_rinuncia_totale,
          dta_scadenza_transaz,                   ---aggiunta decode 18 luglio
          DECODE (
             (  (NVL (
                    DECODE (d.cod_fase_delibera,
                            'IN', d.scsb_uti_cassa,
                            d.val_uti_cassa_scsb),
                    0))
              + NVL (
                   mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (
                      d.cod_abi,
                      d.cod_ndg,
                      'CT'),
                   0)),
             0, 100,
             (CASE
                 WHEN cod_fase_delibera IN ('IN', 'CM')
                 THEN
                    TRUNC (
                         ( (  (  NVL (
                                    mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_stralci_ct (
                                       d.cod_abi,
                                       d.cod_ndg),
                                    0)
                               --        + NVL (
                               --         mcre_own.pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia(d.cod_abi, d.cod_ndg,'CM'),0)
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
                       * 100)
                 ELSE
                    TO_NUMBER (d.val_perc_perd_rm)
              END))
             AS val_rinuncia_perc,                                    --12 lug
          DECODE (d.flg_no_delibera,  1, 'Y',  0, 'N',  2, 'U')
             AS flg_no_delibera,
          d.cod_fase_delibera,
          d.cod_fase_microtipologia,
          d.cod_fase_pacchetto,
          d.desc_note,
          d.val_rdv_qc_ante_delib AS "RETTIFICA_ESISTENTE_CASSA",
          CASE
             WHEN d.cod_abi = '01025' THEN 1 || d.cod_abi
             ELSE 2 || d.cod_abi
          END
             AS ordinamento,
          d.cod_doc_appendice_parere,
          d.cod_doc_classificazione,
          d.cod_doc_delibera_banca,
          d.cod_doc_delibera_capogruppo,
          d.cod_doc_parere_conformita,
          d.flg_ristrutturato,
          p.cod_tipo_gestione,
          d.desc_no_delibera,                                       --20131230
          D.COD_DOC_CLASSIFICAZIONE_MCI           --T.B. APERTURA MCI 25-06-14
     FROM t_mcre0_app_all_data a,
          (SELECT d.*, r.scsb_uti_tot, scsb_uti_cassa
             FROM t_mcrei_app_delibere d, t_mcrei_app_pcr_rapp_aggr r
            WHERE     d.cod_abi = r.cod_abi_cartolarizzato(+)
                  AND d.cod_ndg = r.cod_ndg(+))       ---aggiunto outer su ndg
                                               d,
          t_mcrei_cl_tipologie t,
          t_mcre0_app_istituti_all i,
          t_mcrei_app_pratiche p,                                   --mm131206
          (SELECT cod_abi_cartolarizzato,
                  cod_ndg,
                  SUM (NVL (i.val_imp_mora, 0))
                     OVER (PARTITION BY i.cod_abi_cartolarizzato, i.cod_ndg)
                     AS interessi_di_mora
             FROM t_mcre0_app_rate_daily i) rate
    WHERE     a.cod_abi_cartolarizzato = d.cod_abi
          AND a.cod_ndg = d.cod_ndg
          AND a.today_flg = '1'
          --mm131206 perdo eventuali delib senza pratica!
          AND d.cod_abi = p.cod_abi
          AND d.cod_ndg = p.cod_ndg
          AND d.cod_macrotipologia_delib = t.cod_macrotipologia(+)
          AND d.cod_microtipologia_delib = t.cod_microtipologia(+)
          AND d.flg_attiva = '1'
          AND d.cod_fase_delibera NOT IN ('AN')                   --13Dicembre
          AND d.cod_abi = i.cod_abi
          AND d.cod_abi = rate.cod_abi_cartolarizzato(+)
          AND d.cod_ndg = rate.cod_ndg(+)
          AND (   t.cod_famiglia_tipologia(+) IN ('DTR', 'DRV')    --17 APRILE
               OR t.cod_microtipologia(+) = 'IR')                     --130423
          AND t.flg_attivo(+) = 1;
