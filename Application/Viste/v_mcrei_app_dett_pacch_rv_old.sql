/* Formatted on 21/07/2014 18:39:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_PACCH_RV_OLD
(
   COD_FASE_DELIBERA,
   COD_FASE_MICROTIPOLOGIA,
   COD_MICROTIPOLOGIA_DELIB,
   COD_FASE_PACCHETTO,
   FLG_NO_DELIBERA,
   COD_STATO,
   DESC_STATO_DI_RISCHIO,
   COD_PROTOCOLLO_PACCHETTO,
   COD_PROTOCOLLO_DELIBERA,
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
   ORDINAMENTO,
   COD_DOC_DELIBERA_BANCA,
   COD_DOC_PARERE_CONFORMITA,
   COD_DOC_APPENDICE_PARERE,
   COD_DOC_DELIBERA_CAPOGRUPPO,
   COD_DOC_CLASSIFICAZIONE,
   VAL_RETT_ESISTENTE_TOTALE,
   VAL_NUOVA_RETT_PROP_TOTALE,
   VAL_RETT_PROGRESSIVA_TOTALE
)
AS
   SELECT DISTINCT
          aa.cod_fase_delibera,
          aa.cod_fase_microtipologia,
          aa.cod_microtipologia_delib,
          aa.cod_fase_pacchetto,
          DECODE (aa.flg_no_delibera,
                  1, 'Y',
                  0, 'N',
                  2, 'U',
                  aa.flg_no_delibera)
             AS flg_no_delibera,
          cod_stato,
          desc_stato_di_rischio,
          aa.cod_protocollo_pacchetto,
          aa.cod_protocollo_delibera,
          aa.cod_abi,
          cod_abi_carto,
          desc_istituto,
          aa.cod_ndg,
          dta_decorrenza_stato_rischio,
          dta_scadenza_stato_rischio,
          MAX (
             NVL (val_accordato_totale, 0))
          OVER (
             PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera)
             val_accordato_totale,                                  --20 marzo
          MAX (
             NVL (val_utilizzato_totale, 0))
          OVER (
             PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera)
             val_utilizzato_totale,                                 --20 marzo
          ---- 29 MARZO: I CAMPI CON DICITURA BT CONTENGONO IN REALTà I TOTALI DI CASSA (BT+MLT)
          SUM (
               NVL (val_esp_lorda_cassa_bt, 0)
             + NVL (val_esp_lorda_cassa_MLT, 0))
          OVER (
             PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera)
             val_esp_lorda_cassa_bt,              ----7/3 RIVISTE LE PARTITION
          SUM (
               NVL (val_di_cui_mora_cassa_bt, 0)
             + NVL (val_di_cui_mora_cassa_MLT, 0))
          OVER (
             PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera)
             val_di_cui_mora_cassa_bt,
          -- 2 APRILE: MODIFICATA VARIAZ DI CASSA ANDANDO SU DELIBERE
          NVL (D2.val_rdv_qc_progressiva, 0) AS val_rett_esistente_cassa_bt, --30 marzo: dato preso dalla delibera precedente invece che dedotto dalle stime
          --SUM(val_rett_totale_cassa_bt + val_rett_totale_cassa_MLT)-  over(PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera) val_nuova_rett_prop_cassa_bt,
          (  NVL (aa.val_rdv_qc_progressiva, 0)
           - NVL (D2.val_rdv_qc_progressiva, 0))
             AS val_nuova_rett_prop_cassa_bt,
          SUM (
               NVL (val_rett_totale_cassa_bt, 0)
             + NVL (val_rett_totale_cassa_MLT, 0))
          OVER (
             PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera)
             val_rett_totale_cassa_bt,
          SUM (
               NVL (val_di_cui_capitale_cassa_bt, 0)
             + NVL (val_di_cui_capitale_cassa_MLT, 0))
          OVER (
             PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera)
             val_di_cui_capitale_cassa_bt,
          SUM (
               NVL (val_esp_netta_cassa_bt, 0)
             + NVL (val_esp_netta_cassa_MLT, 0))
          OVER (
             PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera)
             val_esp_netta_cassa_bt,
          ----
          TO_NUMBER (NULL) AS val_esp_lorda_cassa_mlt,
          TO_NUMBER (NULL) AS val_di_cui_mora_cassa_mlt,
          TO_NUMBER (NULL) AS val_rett_esistente_cassa_mlt,
          TO_NUMBER (NULL) AS val_nuova_rett_prop_cassa_mlt,
          TO_NUMBER (NULL) AS val_rett_totale_cassa_mlt,
          TO_NUMBER (NULL) AS val_di_cui_capitale_cassa_mlt,
          TO_NUMBER (NULL) AS val_esp_netta_cassa_mlt,
          ----
          SUM (
             NVL (aa.val_esp_firma, 0))
          OVER (
             PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera)
             AS val_esp_firma,
          NVL (d2.val_rdv_progr_fi, 0) AS val_rett_esistente_firma,
          (NVL (aa.val_rdv_progr_fi, 0) - NVL (d2.val_rdv_progr_fi, 0))
             AS val_nuova_rett_prop_firma,              --30 mar: aggiunto nvl
          NVL (aa.val_rdv_progr_fi, 0) AS val_rett_totale_firma,
          SUM (
             NVL (val_esp_derivati, 0))
          OVER (
             PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera)
             val_esp_derivati,
          SUM (
             NVL (val_rett_esistente_derivati, 0))
          OVER (
             PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera)
             val_rett_esistente_derivati,
          SUM (
             NVL (val_nuova_rett_prop_derivati, 0))
          OVER (
             PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera)
             val_nuova_rett_prop_derivati,
          SUM (
             NVL (val_rett_totale_derivati, 0))
          OVER (
             PARTITION BY aa.cod_abi, aa.cod_ndg, aa.cod_protocollo_delibera)
             val_rett_totale_derivati,
          aa.ordinamento,
          aa.cod_doc_delibera_banca,
          aa.cod_doc_parere_conformita,
          aa.cod_doc_appendice_parere,
          aa.cod_doc_delibera_capogruppo,
          aa.cod_doc_classificazione,
          (NVL (aa.val_rdv_qc_ante_delib, 0) + NVL (d2.val_rdv_progr_fi, 0))
             AS val_rett_esistente_totale,
            (  NVL (aa.val_rdv_qc_progressiva, 0)
             + NVL (aa.val_rdv_progr_fi, 0))
          - (NVL (aa.val_rdv_qc_ante_delib, 0) + NVL (d2.val_rdv_progr_fi, 0))
             AS val_nuova_rett_prop_totale,
          (NVL (aa.val_rdv_qc_progressiva, 0) + NVL (aa.val_rdv_progr_fi, 0))
             AS val_rett_progressiva_totale                                ---
     FROM (SELECT /*+ INDEX(d IDX_T_MCREI_APP_DELIBERE)  INDEX(s PK_T_MCREI_APP_STIME)
                      INDEX(p ixpk_T_MCREI_APP_PCR_RAPP) INDEX(a PKT_MCRE0_APP_ALL_DATA)
                      INDEX(i PK_T_MCRE0_APP_RATE_DAILY)*/
 /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
 BEGIN dbms_application_info.set_client_info( prot_pacc||cod_microtipol ); END;*/
                 DISTINCT
                 p.cod_fase_delibera,
                 p.cod_fase_microtipologia,
                 p.cod_microtipologia_delib,
                 p.cod_fase_pacchetto,
                 p.flg_no_delibera,
                 a.cod_stato,
                 ' ' AS desc_stato_di_rischio,
                 p.cod_protocollo_pacchetto,
                 p.cod_protocollo_delibera,
                 p.cod_abi,
                 a.cod_abi_cartolarizzato AS cod_abi_carto,
                 a.desc_istituto,
                 p.cod_ndg,
                 a.dta_decorrenza_stato AS dta_decorrenza_stato_rischio,
                 a.dta_scadenza_stato AS dta_scadenza_stato_rischio,
                 NVL (
                    (CASE
                        WHEN cod_fase_delibera = 'IN'
                        THEN
                           SUM (p.val_accordato_delib)
                              OVER (PARTITION BY p.cod_abi, p.cod_ndg)
                        ELSE
                           SUM (
                              s.val_accordato)
                           OVER (
                              PARTITION BY s.cod_abi,
                                           s.cod_ndg,
                                           s.cod_protocollo_delibera)
                     END),
                    0)
                    val_accordato_totale,
                 NVL (
                    CASE
                       WHEN cod_fase_delibera = 'IN'
                       THEN
                          SUM (p.val_imp_utilizzato)
                             OVER (PARTITION BY p.cod_abi, p.cod_ndg)
                       ELSE
                          SUM (
                             s.val_esposizione)
                          OVER (
                             PARTITION BY s.cod_abi,
                                          s.cod_ndg,
                                          s.cod_protocollo_delibera)
                    END,
                    0)
                    val_utilizzato_totale,
                 /* val_rett_esistente_totale,
                 val_nuova_rett_prop_totale,
                 val_rett_progressiva_totale,
                 */
                 NVL (
                    CASE
                       WHEN cod_fase_delibera = 'IN'
                       THEN
                          CASE
                             WHEN n.cod_natura = '01'
                             THEN                                --cassa breve
                                SUM (
                                   p.val_imp_utilizzato)
                                OVER (
                                   PARTITION BY p.cod_abi,
                                                p.cod_ndg,
                                                p.cod_rapporto)
                          END
                       ELSE
                          CASE
                             WHEN n.cod_natura = '01'
                             THEN                                --cassa breve
                                SUM (
                                   s.val_esposizione)
                                OVER (
                                   PARTITION BY s.cod_abi,
                                                s.cod_ndg,
                                                s.cod_rapporto)
                          END
                    END,
                    0)
                    val_esp_lorda_cassa_bt,
                 NVL (
                    CASE
                       WHEN cod_fase_delibera = 'IN'
                       THEN
                          CASE
                             WHEN n.cod_natura = '01'
                             THEN                                --cassa breve
                                SUM (
                                   i.val_imp_mora)
                                OVER (
                                   PARTITION BY i.cod_abi_cartolarizzato,
                                                i.cod_ndg,
                                                i.cod_rapporto)
                          END
                       ELSE
                          CASE
                             WHEN n.cod_natura = '01'
                             THEN                                --cassa breve
                                SUM (
                                   s.val_utilizzato_mora)
                                OVER (
                                   PARTITION BY s.cod_abi,
                                                s.cod_ndg,
                                                s.cod_rapporto)
                          END
                    END,
                    0)
                    val_di_cui_mora_cassa_bt,
                 NVL (
                    CASE
                       WHEN n.cod_natura = '01'
                       THEN                                      --cassa breve
                          SUM (s.val_imp_rettifica_pregr)
                          OVER (PARTITION BY s.cod_abi, s.cod_ndg, s.cod_rapporto)
                    END,
                    0)
                    val_rett_esistente_cassa_bt,
                 NVL (
                    CASE
                       WHEN n.cod_natura = '01'
                       THEN                                      --cassa breve
                          SUM (s.val_imp_rettifica_att)
                          OVER (PARTITION BY s.cod_abi, s.cod_ndg, s.cod_rapporto)
                    END,
                    0)
                    val_nuova_rett_prop_cassa_bt,
                 NVL (
                    CASE
                       WHEN n.cod_natura = '01'
                       THEN                                      --cassa breve
                          SUM (s.val_rdv_tot)
                          OVER (PARTITION BY s.cod_abi, s.cod_ndg, s.cod_rapporto)
                    END,
                    0)
                    val_rett_totale_cassa_bt,
                 NVL (
                    CASE
                       WHEN cod_fase_delibera = 'IN'
                       THEN
                          CASE
                             WHEN n.cod_natura = '01'
                             THEN                                --cassa breve
                                (  SUM (
                                      p.val_imp_utilizzato)
                                   OVER (
                                      PARTITION BY p.cod_abi,
                                                   p.cod_ndg,
                                                   p.cod_rapporto)
                                 - SUM (
                                      NVL (i.val_imp_mora, 0))
                                   OVER (
                                      PARTITION BY i.cod_abi_cartolarizzato,
                                                   i.cod_ndg,
                                                   i.cod_rapporto))
                          END
                       ELSE
                          CASE
                             WHEN n.cod_natura = '01'
                             THEN                                --cassa breve
                                (  SUM (
                                      s.val_esposizione)
                                   OVER (
                                      PARTITION BY s.cod_abi,
                                                   s.cod_ndg,
                                                   s.cod_rapporto)
                                 - SUM (
                                      s.val_utilizzato_mora)
                                   OVER (
                                      PARTITION BY s.cod_abi,
                                                   s.cod_ndg,
                                                   s.cod_rapporto))
                          END
                    END,
                    0)
                    val_di_cui_capitale_cassa_bt,
                 NVL (
                    CASE
                       WHEN cod_fase_delibera = 'IN'
                       THEN
                          CASE
                             WHEN n.cod_natura = '01'
                             THEN                                --cassa breve
                                SUM (
                                     p.val_imp_utilizzato
                                   - NVL (s.val_rdv_tot, 0)
                                   - s.val_utilizzato_mora)      --PAG.105 AFU
                                OVER (
                                   PARTITION BY p.cod_abi,
                                                p.cod_ndg,
                                                p.cod_rapporto)
                          END
                       ELSE
                          CASE
                             WHEN n.cod_natura = '01'
                             THEN                                --cassa breve
                                SUM (
                                     s.val_esposizione
                                   - NVL (s.val_rdv_tot, 0)
                                   - s.val_utilizzato_mora)      --PAG.105 AFU
                                OVER (
                                   PARTITION BY p.cod_abi,
                                                p.cod_ndg,
                                                p.cod_rapporto)
                          END
                    END,
                    0)
                    val_esp_netta_cassa_bt,
                 NVL (
                    CASE
                       WHEN cod_fase_delibera = 'IN'
                       THEN
                          CASE
                             WHEN n.cod_natura = '02'
                             THEN                                  --cassa mlt
                                SUM (
                                   p.val_imp_utilizzato)
                                OVER (
                                   PARTITION BY p.cod_abi,
                                                p.cod_ndg,
                                                p.cod_rapporto)
                          END
                       ELSE
                          CASE
                             WHEN n.cod_natura = '02'
                             THEN                                  --cassa mlt
                                SUM (
                                   s.val_esposizione)
                                OVER (
                                   PARTITION BY s.cod_abi,
                                                s.cod_ndg,
                                                s.cod_rapporto)
                          END
                    END,
                    0)
                    val_esp_lorda_cassa_mlt,
                 NVL (
                    CASE
                       WHEN cod_fase_delibera = 'IN'
                       THEN
                          CASE
                             WHEN n.cod_natura = '02'
                             THEN                                  --cassa mlt
                                SUM (
                                   i.val_imp_mora)
                                OVER (
                                   PARTITION BY i.cod_abi_cartolarizzato,
                                                i.cod_ndg,
                                                i.cod_rapporto)
                          END
                       ELSE
                          CASE
                             WHEN n.cod_natura = '02'
                             THEN                                  --cassa mlt
                                SUM (
                                   s.val_utilizzato_mora)
                                OVER (
                                   PARTITION BY s.cod_abi,
                                                s.cod_ndg,
                                                s.cod_rapporto)
                          END
                    END,
                    0)
                    val_di_cui_mora_cassa_mlt,
                 NVL (
                    CASE
                       WHEN n.cod_natura = '02'
                       THEN                                        --cassa mlt
                          SUM (s.val_imp_rettifica_pregr)
                          OVER (PARTITION BY s.cod_abi, s.cod_ndg, s.cod_rapporto)
                    END,
                    0)
                    val_rett_esistente_cassa_mlt,
                 NVL (
                    CASE
                       WHEN n.cod_natura = '02'
                       THEN                                        --cassa mlt
                          SUM (s.val_imp_rettifica_att)
                          OVER (PARTITION BY s.cod_abi, s.cod_ndg, s.cod_rapporto)
                    END,
                    0)
                    val_nuova_rett_prop_cassa_mlt,
                 NVL (
                    CASE
                       WHEN n.cod_natura = '02'
                       THEN                                        --cassa mlt
                          SUM (s.val_rdv_tot)
                          OVER (PARTITION BY s.cod_abi, s.cod_ndg, s.cod_rapporto)
                    END,
                    0)
                    val_rett_totale_cassa_mlt,
                 NVL (
                    CASE
                       WHEN cod_fase_delibera = 'IN'
                       THEN
                          CASE
                             WHEN n.cod_natura = '02'
                             THEN                                  --cassa mlt
                                (  SUM (
                                      p.val_imp_utilizzato)
                                   OVER (
                                      PARTITION BY p.cod_abi,
                                                   p.cod_ndg,
                                                   p.cod_rapporto)
                                 - SUM (
                                      i.val_imp_mora)
                                   OVER (
                                      PARTITION BY i.cod_abi_cartolarizzato,
                                                   i.cod_ndg,
                                                   i.cod_rapporto))
                          END
                       ELSE
                          CASE
                             WHEN n.cod_natura = '02'
                             THEN                                  --cassa mlt
                                (  SUM (
                                      s.val_esposizione)
                                   OVER (
                                      PARTITION BY s.cod_abi,
                                                   s.cod_ndg,
                                                   s.cod_rapporto)
                                 - SUM (
                                      s.val_utilizzato_mora)
                                   OVER (
                                      PARTITION BY s.cod_abi,
                                                   s.cod_ndg,
                                                   s.cod_rapporto))
                          END
                    END,
                    0)
                    val_di_cui_capitale_cassa_mlt,
                 NVL (
                    CASE
                       WHEN cod_fase_delibera = 'IN'
                       THEN
                          CASE
                             WHEN n.cod_natura = '02'
                             THEN                                --cassa breve
                                SUM (
                                     p.val_imp_utilizzato
                                   - NVL (s.val_rdv_tot, 0)
                                   - s.val_utilizzato_mora)      --PAG.105 AFU
                                OVER (
                                   PARTITION BY p.cod_abi,
                                                p.cod_ndg,
                                                p.cod_rapporto)
                          END
                       ELSE
                          CASE
                             WHEN n.cod_natura = '02'
                             THEN                                --cassa breve
                                SUM (
                                     s.val_esposizione
                                   - NVL (s.val_rdv_tot, 0)
                                   - s.val_utilizzato_mora)      --PAG.105 AFU
                                OVER (
                                   PARTITION BY p.cod_abi,
                                                p.cod_ndg,
                                                p.cod_rapporto)
                          END
                    END,
                    0)
                    val_esp_netta_cassa_MLT,
                 NVL (
                    CASE
                       WHEN cod_fase_delibera = 'IN'
                       THEN
                          CASE
                             WHEN n.cod_natura = '03'
                             THEN                                      --firma
                                SUM (
                                   p.val_imp_utilizzato)
                                OVER (
                                   PARTITION BY p.cod_abi,
                                                p.cod_ndg,
                                                p.cod_rapporto)
                          END
                       ELSE
                          CASE
                             WHEN n.cod_natura = '03'
                             THEN                                      --firma
                                SUM (
                                   s.val_esposizione)
                                OVER (
                                   PARTITION BY s.cod_abi,
                                                s.cod_ndg,
                                                s.cod_rapporto)
                          END
                    END,
                    0)
                    val_esp_firma,
                 NVL (
                    CASE
                       WHEN cod_fase_delibera = 'IN'
                       THEN
                          CASE
                             WHEN n.cod_natura = '04'
                             THEN                                   --derivati
                                SUM (
                                   p.val_imp_utilizzato)
                                OVER (
                                   PARTITION BY p.cod_abi,
                                                p.cod_ndg,
                                                p.cod_rapporto)
                          END
                       ELSE
                          CASE
                             WHEN n.cod_natura = '04'
                             THEN                                   --derivati
                                SUM (
                                   s.val_esposizione)
                                OVER (
                                   PARTITION BY s.cod_abi,
                                                s.cod_ndg,
                                                s.cod_rapporto)
                          END
                    END,
                    0)
                    val_esp_derivati,
                 CASE
                    WHEN n.cod_natura = '04'
                    THEN                                            --derivati
                       SUM (s.val_imp_rettifica_pregr)
                          OVER (PARTITION BY s.cod_abi, s.cod_ndg, s.cod_rapporto)
                 END
                    AS val_rett_esistente_derivati,
                 CASE
                    WHEN n.cod_natura = '04'
                    THEN                                            --derivati
                       SUM (s.val_imp_rettifica_att)
                          OVER (PARTITION BY s.cod_abi, s.cod_ndg, s.cod_rapporto)
                 END
                    AS val_nuova_rett_prop_derivati,
                 CASE
                    WHEN n.cod_natura = '04'
                    THEN                                            --derivati
                       SUM (s.val_rdv_tot)
                          OVER (PARTITION BY s.cod_abi, s.cod_ndg, s.cod_rapporto)
                 END
                    AS val_rett_totale_derivati,
                 DECODE (p.cod_abi, '01025', 1 || p.cod_abi, 2 || p.cod_abi)
                    AS ordinamento,
                 cod_doc_delibera_banca,
                 cod_doc_parere_conformita,
                 cod_doc_appendice_parere,
                 cod_doc_delibera_capogruppo,
                 cod_doc_classificazione,
                 p.cod_protocollo_delibera_pre,
                 p.val_rdv_progr_fi,
                 p.val_rdv_qc_ante_delib,
                 p.val_rdv_qc_progressiva
            FROM t_mcre0_app_all_data a,
                 t_mcrei_app_stime s,
                 (SELECT dd.cod_abi,
                         dd.cod_ndg,
                         pc.cod_rapporto,
                         dd.cod_protocollo_delibera,
                         cod_protocollo_delibera_pre,
                         dd.val_rdv_progr_fi,
                         dd.val_rdv_qc_ante_delib,
                         dd.val_rdv_qc_progressiva,
                         cod_forma_tecnica,
                         val_imp_utilizzato,
                         dd.cod_protocollo_pacchetto,
                         cod_classe_ft,
                         dd.cod_fase_delibera,
                         dd.cod_fase_pacchetto,
                         dd.flg_attiva,
                         val_accordato_delib,
                         dd.flg_no_delibera,
                         dd.cod_microtipologia_delib,
                         dd.cod_fase_microtipologia,
                         dd.cod_doc_delibera_banca,
                         dd.cod_doc_parere_conformita,
                         dd.cod_doc_appendice_parere,
                         dd.cod_doc_delibera_capogruppo,
                         dd.cod_doc_classificazione
                    FROM t_mcrei_app_delibere dd, t_mcrei_app_pcr_rapporti pc
                   WHERE     dd.cod_abi = pc.cod_abi
                         AND dd.cod_ndg = pc.cod_ndg
                         AND dd.flg_attiva = '1'
                         AND dd.cod_protocollo_pacchetto =
                                TRIM (
                                   SUBSTR (
                                      (SYS_CONTEXT ('userenv', 'client_info')),
                                      0,
                                      30))
                         AND dd.cod_microtipologia_delib =
                                TRIM (
                                   SUBSTR (
                                      (SYS_CONTEXT ('userenv', 'client_info')),
                                      31,
                                      2))) p,                           ---8/3
                 t_mcre0_app_rate_daily i,                               --5/3
                 t_mcre0_app_natura_ftecnica n
           WHERE     p.cod_abi = s.cod_abi(+)
                 AND p.cod_ndg = s.cod_ndg(+)
                 AND p.cod_protocollo_delibera = s.cod_protocollo_delibera(+)
                 AND p.cod_rapporto = s.cod_rapporto(+)                 ---9/3
                 AND p.flg_attiva = '1'
                 AND s.flg_attiva(+) = '1'
                 AND s.cod_abi = i.cod_abi_cartolarizzato(+)
                 AND s.cod_ndg = i.cod_ndg(+)
                 AND s.cod_rapporto = i.cod_rapporto(+)
                 AND p.cod_abi = a.cod_abi_cartolarizzato
                 AND p.cod_ndg = a.cod_ndg
                 AND p.cod_forma_tecnica = n.cod_ftecnica(+)
                 AND p.cod_fase_pacchetto NOT IN ('ANA', 'ANM')
                 AND p.cod_fase_delibera != 'AN') aa,
          t_mcrei_app_delibere d2
    WHERE     aa.cod_abi = d2.cod_abi(+)
          AND aa.cod_ndg = d2.cod_ndg(+)
          AND aa.cod_protocollo_delibera_pre = d2.cod_protocollo_delibera(+);
