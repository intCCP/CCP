/* Formatted on 17/06/2014 18:08:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_PACCH_RV_GEM
(
   COD_FASE_DELIBERA,
   COD_FASE_MICROTIPOLOGIA,
   COD_MICROTIPOLOGIA_DELIB,
   COD_FASE_PACCHETTO,
   FLG_NO_DELIBERA,
   COD_STATO,
   DESC_STATO_DI_RISCHIO,
   COD_PROTOCOLLO_DELIBERA,
   COD_PROTOCOLLO_PACCHETTO,
   COD_ABI,
   COD_ABI_CARTO,
   DESC_ISTITUTO,
   COD_NDG,
   DTA_DECORRENZA_STATO_RISCHIO,
   DTA_SCADENZA_STATO_RISCHIO,
   VAL_ACCORDATO_TOTALE,
   VAL_UTILIZZATO_TOTALE,
   VAL_ESP_LORDA_CASSA_BT,
   VAL_DI_CUI_MORA_CASSA_BT,
   VAL_RETT_ESISTENTE_CASSA_BT,
   VAL_NUOVA_RETT_PROP_CASSA_BT,
   VAL_RETT_TOTALE_CASSA_BT,
   VAL_DI_CUI_CAPITALE_CASSA_BT,
   VAL_ESP_NETTA_CASSA_BT,
   VAL_ESP_LORDA_CASSA_MLT,
   VAL_DI_CUI_MORA_CASSA_MLT,
   VAL_RETT_ESISTENTE_CASSA_MLT,
   VAL_NUOVA_RETT_PROP_CASSA_MLT,
   VAL_RETT_TOTALE_CASSA_MLT,
   VAL_DI_CUI_CAPITALE_CASSA_MLT,
   VAL_ESP_NETTA_CASSA_MLT,
   VAL_ESP_FIRMA,
   VAL_RETT_ESISTENTE_FIRMA,
   VAL_NUOVA_RETT_PROP_FIRMA,
   VAL_RETT_TOTALE_FIRMA,
   VAL_ESP_DERIVATI,
   VAL_RETT_ESISTENTE_DERIVATI,
   VAL_NUOVA_RETT_PROP_DERIVATI,
   VAL_RETT_TOTALE_DERIVATI,
   VAL_RETT_ESISTENTE_TOTALE,
   VAL_NUOVA_RETT_PROP_TOTALE,
   VAL_RETT_PROGRESSIVA_TOTALE,
   ORDINAMENTO,
   COD_DOC_DELIBERA_BANCA,
   COD_DOC_PARERE_CONFORMITA,
   COD_DOC_APPENDICE_PARERE,
   COD_DOC_DELIBERA_CAPOGRUPPO,
   COD_DOC_CLASSIFICAZIONE,
   RDV_PROGR_CASSA,
   RDV_PROGR_FIRMA,
   DESC_NO_DELIBERA
)
AS
   SELECT DISTINCT
          cod_fase_delibera,
          cod_fase_microtipologia,
          cod_microtipologia_delib,
          cod_fase_pacchetto,
          DECODE (flg_no_delibera,
                  1, 'Y',
                  0, 'N',
                  2, 'U',
                  flg_no_delibera)
             AS flg_no_delibera,
          cod_stato,                                                        --
          ' ' AS desc_stato_di_rischio,
          cod_prot_delibera AS cod_protocollo_delibera,
          cod_prot_pacchetto AS cod_protocollo_pacchetto,
          cod_abi,
          a.cod_abi_cartolarizzato AS cod_abi_carto,
          a.desc_istituto,
          a.cod_ndg,
          a.dta_decorrenza_stato AS dta_decorrenza_stato_rischio,
          a.dta_scadenza_stato AS dta_scadenza_stato_rischio,
          val_accordato_delib AS val_accordato_totale,
            NVL (val_esp_firma, 0)
          + NVL (esp_lorda_cassa, 0)
          + NVL (val_tot_derivati, 0)
             AS val_utilizzato_totale,
          esp_lorda_cassa AS val_esp_lorda_cassa_bt,
          val_tot_interessi_di_mora AS val_di_cui_mora_cassa_bt,
          val_rdv_pregr_cassa AS val_rett_esistente_cassa_bt,
          val_rett_cassa_qta_cap - val_rdv_pregr_cassa
             AS val_nuova_rett_prop_cassa_bt,
          val_rett_cassa_qta_cap AS val_rett_totale_cassa_bt,
          --val_esp_cassa_qta_cap AS val_di_cui_capitale_cassa_bt,
          esp_lorda_cassa - NVL (val_tot_interessi_di_mora, 0)
             AS val_di_cui_capitale_cassa_bt,
            (esp_lorda_cassa - NVL (val_tot_interessi_di_mora, 0))
          - val_rett_cassa_qta_cap
             AS val_esp_netta_cassa_bt,
          TO_NUMBER (NULL) AS val_esp_lorda_cassa_mlt,
          TO_NUMBER (NULL) AS val_di_cui_mora_cassa_mlt,
          TO_NUMBER (NULL) AS val_rett_esistente_cassa_mlt,
          TO_NUMBER (NULL) AS val_nuova_rett_prop_cassa_mlt,
          TO_NUMBER (NULL) AS val_rett_totale_cassa_mlt,
          TO_NUMBER (NULL) AS val_di_cui_capitale_cassa_mlt,
          TO_NUMBER (NULL) AS val_esp_netta_cassa_mlt,
          val_esp_firma AS val_esp_firma,
          val_rdv_pregr_firma AS val_rett_esistente_firma,
          val_rett_rapp_firma - val_rdv_pregr_firma
             AS val_nuova_rett_prop_firma,
          val_rett_rapp_firma AS val_rett_totale_firma,
          val_tot_derivati AS val_esp_derivati,
          0 AS val_rett_esistente_derivati,
          0 AS val_nuova_rett_prop_derivati,
          0 AS val_rett_totale_derivati,
          val_rdv_pregr_firma + val_rdv_pregr_cassa
             AS val_rett_esistente_totale,
          val_variazione_rdv AS val_nuova_rett_prop_totale,
          val_tot_rett_calcolata AS val_rett_progressiva_totale,
          ordinamento,
          cod_doc_delibera_banca,
          cod_doc_parere_conformita,
          cod_doc_appendice_parere,
          cod_doc_delibera_capogruppo,
          cod_doc_classificazione,
          val_rett_cassa_qta_cap AS rdv_progr_cassa,               -- 3 maggio
          val_rett_rapp_firma AS rdv_progr_firma,                  -- 3 maggio
          desc_no_delibera
     FROM (SELECT DISTINCT
                  r.cod_abi,
                  r.cod_ndg,
                  r.cod_prot_delibera,
                  d.cod_protocollo_pacchetto AS cod_prot_pacchetto,
                  d.cod_microtipologia_delib,
                  d.cod_fase_microtipologia,
                  d.cod_fase_delibera,
                  d.cod_fase_pacchetto,
                  MAX (d.dta_scadenza)
                     OVER (PARTITION BY d.cod_abi, d.cod_ndg)
                     AS dta_scadenza,
                  d2.dta_delibera AS dta_ultima_delib,
                  --2 aprile: modifica su richiesta utente
                  SUM (
                     NVL (val_utilizzato_lordo, 0))
                  OVER (
                     PARTITION BY r.cod_abi, r.cod_ndg, r.cod_prot_delibera)
                     AS esp_lorda_cassa,
                  SUM (
                       NVL (val_utilizzato_lordo, 0)
                     - NVL (val_utilizzato_mora, 0))
                  OVER (
                     PARTITION BY r.cod_abi, r.cod_ndg, r.cod_prot_delibera)
                     AS val_esp_cassa_qta_cap,
                  SUM (
                       NVL (val_utilizzato_firma, 0)
                     + NVL (val_utilizzato_lordo, 0))
                  OVER (
                     PARTITION BY r.cod_abi, r.cod_ndg, r.cod_prot_delibera)
                     AS val_esp_complessiva,
                  SUM (
                       (  NVL (val_utilizzato_lordo, 0)
                        - NVL (val_utilizzato_mora, 0))
                     + NVL (val_utilizzato_firma, 0))
                  OVER (
                     PARTITION BY r.cod_abi, r.cod_ndg, r.cod_prot_delibera)
                     AS val_esp_complessiva_da_val,
                  SUM (
                     NVL (val_utilizzato_firma, 0))
                  OVER (
                     PARTITION BY r.cod_abi, r.cod_ndg, r.cod_prot_delibera)
                     AS val_esp_firma,
                  SUM (
                       NVL (val_utilizzato_lordo, 0)
                     - NVL (val_utilizzato_mora, 0)
                     - NVL (val_rett_cassa_qta_cap, 0))
                  OVER (
                     PARTITION BY r.cod_abi, r.cod_ndg, r.cod_prot_delibera)
                     AS val_esp_netta_cassa_qta_cap,
                    NVL (d2.val_rdv_extra_delibera, 0)
                  + NVL (d2.val_rdv_extra_fi, 0)
                     AS val_rett_attuale,
                  SUM (
                     NVL (val_utilizzato_sosti, 0))
                  OVER (
                     PARTITION BY r.cod_abi, r.cod_ndg, r.cod_prot_delibera)
                     AS val_tot_derivati,
                  SUM (
                     fondo_terzi)
                  OVER (
                     PARTITION BY r.cod_abi, r.cod_ndg, r.cod_prot_delibera)
                     AS val_tot_fondi_terzi,
                  SUM (
                     NVL (val_utilizzato_mora, 0))
                  OVER (
                     PARTITION BY r.cod_abi, r.cod_ndg, r.cod_prot_delibera)
                     AS val_tot_interessi_di_mora,
                  (  NVL (d.val_rdv_qc_progressiva, 0)
                   + NVL (d.val_rdv_progr_fi, 0))
                     AS val_tot_rett_calcolata,
                  ----RDV DI CA + RDV DI FI
                  SUM (
                     NVL (val_accordato_delib, 0))
                  OVER (
                     PARTITION BY r.cod_abi, r.cod_ndg, r.cod_prot_delibera)
                     AS val_accordato_delib,
                    --21 MARZO
                    --SUM(val_rdv_tot) over(PARTITION BY r.cod_abi, r.cod_ndg, r.cod_prot_delibera) AS val_tot_rett_calcolata, ----RDV DI CA + RDV DI FI
                    NVL (d.val_rdv_qc_ante_delib, 0)
                  + NVL (d2.val_rdv_progr_fi, 0)
                     AS val_tot_rett_progr_delib,
                  ---TOT RDV ANTE DELIBERA
                  NULL AS val_tot_rett_progr_parere,
                  d2.val_rdv_progr_fi AS val_rett_rapp_firma_delib,
                  --3 aprile
                  d2.val_rdv_extra_fi AS val_rett_attuale_firma,
                  d2.val_rdv_extra_delibera AS val_rett_attuale_cassa,
                  d.val_rdv_progr_fi AS val_rett_rapp_firma,
                  d.val_rdv_qc_progressiva AS val_rett_cassa_qta_cap,
                  d.val_rdv_progr_fi AS val_rett_firma,
                  d2.val_rdv_rapp_operativi AS val_rett_rapp_op_delib,
                  --ultima delibera PRECEDENTE
                  d.val_rdv_rapp_operativi AS val_rett_rapp_op_progr,
                  d.val_perc_rett_rapp_firma,
                  d.val_rdv_qc_ante_delib AS val_rdv_pregr_cassa,
                  ---IN HOST LA RDV ? SEMPRE E SOLO DI CASSA
                  NVL (d.val_rdv_pregr_fi, 0) AS val_rdv_pregr_firma, --3 APRILE
                    (  NVL (d.val_rdv_qc_progressiva, 0)
                     + NVL (d.val_rdv_progr_fi, 0))
                  - (  NVL (d.val_rdv_qc_ante_delib, 0)
                     + NVL (d2.val_rdv_progr_fi, 0))
                     AS val_variazione_rdv,
                  NULL AS val_rdv_cassa_mese_prec,
                  NULL AS val_rdv_firma_mese_prec,
                  NULL AS val_tot_rdv_mese_prec,
                  DECODE (d.cod_abi, '01025', 1 || d.cod_abi, 2 || d.cod_abi)
                     AS ordinamento,
                  d.cod_doc_delibera_banca,
                  d.cod_doc_parere_conformita,
                  d.cod_doc_appendice_parere,
                  d.cod_doc_delibera_capogruppo,
                  d.flg_no_delibera,
                  d.cod_doc_classificazione,
                  D.DESC_NO_DELIBERA
             FROM                     --v_mcrei_app_dett_rapporti_rv 18 aprile
                 (SELECT DISTINCT
                         dett.cod_abi,
                         dett.cod_ndg,
                         dta_stima,
                         cod_prot_delibera,
                         cod_rapporto,
                         cod_tipo_rapporto,
                         val_num_rapporto,
                         val_forma_tecnica,
                         val_utilizzato_lordo,
                         val_utilizzato_lordo - val_utilizzato_mora
                            AS val_utilizzato_netto,
                         --18 apr
                         val_utilizzato_mora,
                         val_utilizzato_firma,
                         cod_operat_rientro,
                         flg_ristrutt,
                         flg_recupero_tot,
                         val_rettifica_livello_rapporto,
                         val_stima_di_rec,
                         flg_storico,
                         val_intervallo,
                         flg_fondo_terzi,
                         -- cod_prot_pacchetto,
                         val_percentuale,
                         val_imp_prev_pregr,
                         val_imp_rettifica_pregr,
                         val_rdv_tot,
                         fondo_terzi,
                         val_utilizzato_sosti,
                         val_rdv_rapp_operativi,
                         val_imp_rettifica_att,
                         val_rett_cassa_qta_cap,
                         --14/3
                         val_rdv_firma,
                         val_rdv_pregr_cassa,
                         val_rdv_pregr_firma,
                         e.cod_npe,
                         val_accordato_delib
                    --21 MARZO
                    FROM ((SELECT DISTINCT
                                  st.cod_abi,
                                  st.cod_ndg,
                                  dta_stima,
                                  st.cod_protocollo_delibera
                                     AS cod_prot_delibera,
                                  st.cod_rapporto,
                                  st.cod_classe_ft AS cod_tipo_rapporto,
                                  st.cod_rapporto AS val_num_rapporto,
                                  st.val_accordato AS val_accordato_delib,
                                     nat.cod_ftecnica
                                  || ' '
                                  || nat.desc_ftecnica
                                     AS val_forma_tecnica,
                                  DECODE (st.cod_classe_ft,
                                          'CA', st.val_esposizione,
                                          0)
                                     AS val_utilizzato_lordo,
                                  ---in pcr l'utilizzato ? gi? comprensivo di mora
                                  DECODE (st.cod_classe_ft,
                                          'FI', st.val_esposizione,
                                          0)
                                     AS val_utilizzato_firma,
                                  DECODE (st.cod_classe_ft,
                                          'ST', st.val_esposizione,
                                          0)
                                     AS val_utilizzato_sosti,
                                  DECODE (st.cod_classe_ft,
                                          'CA', st.val_esposizione,
                                          -NVL (i.val_imp_mora, 0), 0)
                                     AS val_utilizzato_netto,
                                  NVL (i.val_imp_mora, 0)
                                     AS val_utilizzato_mora,
                                  st.flg_tipo_dato AS cod_operat_rientro,
                                  NVL (st.flg_ristrutturato,
                                       ra.flg_ristrutturato)
                                     AS flg_ristrutt,
                                  st.flg_recupero_tot,
                                  st.val_rdv_tot
                                     AS val_rettifica_livello_rapporto,
                                  --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                                  st.val_prev_recupero AS val_stima_di_rec,
                                  --MODIFICATO IL 13 MARZO PER CAMBIO LOGICA
                                  'N' AS flg_storico,
                                  ----verificare
                                  DECODE (nat.cod_natura,
                                          '01', 'BR',
                                          '02', 'MLT')
                                     AS val_intervallo,
                                  DECODE (st.flg_tipo_dato,
                                          'R', st.val_rdv_tot,
                                          0)
                                     AS val_rdv_rapp_operativi,
                                  DECODE (st.cod_classe_ft,
                                          'CA', val_rdv_tot,
                                          0)
                                     AS val_rett_cassa_qta_cap,
                                  DECODE (st.cod_classe_ft,
                                          'FI', val_rdv_tot,
                                          0)
                                     AS val_rdv_firma,
                                  DECODE (st.cod_classe_ft,
                                          'CA', st.val_imp_rettifica_pregr,
                                          0)
                                     AS val_rdv_pregr_cassa,
                                  DECODE (st.cod_classe_ft,
                                          'FI', st.val_imp_rettifica_pregr,
                                          0)
                                     AS val_rdv_pregr_firma,
                                  ra.flg_fondo_terzi,
                                  /*  pcr.cod_protocollo_pacchetto
                                  AS cod_prot_pacchetto,
                                  */
                                  st.val_perc_rett_rapporto
                                     AS val_percentuale,
                                  st.val_imp_prev_pregr,
                                  st.val_imp_rettifica_pregr,
                                  st.val_rdv_tot,
                                  st.val_imp_rettifica_att,
                                    NVL (st.val_esposizione, 0)
                                  - (  (  (100 - ra.val_perc_fondo_terzi)
                                        * NVL (st.val_esposizione, 0))
                                     / 100)
                                     AS fondo_terzi,
                                  DECODE (
                                     st.cod_protocollo_delibera,
                                     NULL, 1,
                                     (RANK ()
                                      OVER (
                                         PARTITION BY st.cod_abi,
                                                      st.cod_ndg,
                                                      st.cod_protocollo_delibera,
                                                      st.cod_rapporto
                                         ORDER BY st.dta_stima DESC)))
                                     rn
                             FROM t_mcrei_app_stime st,
                                  t_mcrei_app_delibere d,
                                  t_mcre0_app_natura_ftecnica nat,
                                  t_mcre0_app_rate_daily i,
                                  ----a livello di rapporti
                                  t_mcrei_app_rapporti ra
                            WHERE /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
                                                                     BEGIN dbms_application_info.set_client_info( prot_pacc||cod_microtipol ); END;*/
                                 d    .cod_abi = st.cod_abi
                                  AND d.cod_ndg = st.cod_ndg
                                  AND d.cod_protocollo_delibera =
                                         st.cod_protocollo_delibera
                                  AND d.flg_attiva = 1
                                  AND D.FLG_NO_DELIBERA = 0
                                  AND (   D.COD_FASE_DELIBERA NOT IN
                                             ('AN', 'VA')         --13Dicembre
                                       OR d.flg_to_copy = '9') --14Gennaio2014: condizione per visualizzare le delibere annullate con flg_to_copi='9'
                                  AND d.cod_protocollo_pacchetto =
                                         TRIM (
                                            SUBSTR (
                                               (SYS_CONTEXT ('userenv',
                                                             'client_info')),
                                               0,
                                               30))
                                  AND d.cod_microtipologia_delib =
                                         TRIM (
                                            SUBSTR (
                                               (SYS_CONTEXT ('userenv',
                                                             'client_info')),
                                               31,
                                               2))
                                  AND st.flg_attiva = '1'
                                  AND st.cod_abi =
                                         i.cod_abi_cartolarizzato(+)
                                  AND st.cod_ndg = i.cod_ndg(+)
                                  AND st.cod_rapporto = i.cod_rapporto(+)
                                  AND st.cod_abi = ra.cod_abi(+)
                                  AND st.cod_ndg = ra.cod_ndg(+)
                                  AND st.cod_rapporto = ra.cod_rapporto(+)
                                  -- 23 marzo
                                  AND ra.flg_attiva(+) = '1'
                                  AND st.cod_forma_tecnica =
                                         nat.cod_ftecnica(+))) dett,
                         t_mcrei_app_rapporti_estero e
                   WHERE     rn = 1
                         AND dett.cod_abi = e.cod_abi(+)
                         AND dett.cod_ndg = e.cod_ndg(+)
                         AND dett.cod_rapporto = e.cod_rapporto_estero(+)) r,
                  t_mcrei_app_delibere d,
                  t_mcrei_app_delibere d2
            WHERE     d.cod_abi = r.cod_abi
                  AND d.cod_ndg = r.cod_ndg
                  AND d.cod_protocollo_delibera = r.cod_prot_delibera
                  AND d.cod_abi = d2.cod_abi(+)
                  AND d.cod_ndg = d2.cod_ndg(+)
                  AND d.cod_protocollo_delibera_pre =
                         d2.cod_protocollo_delibera(+)) dett,
          t_mcre0_app_all_data a
    WHERE     dett.cod_abi = a.cod_abi_cartolarizzato
          AND DETT.COD_NDG = A.COD_NDG;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DETT_PACCH_RV_GEM TO MCRE_USR;
