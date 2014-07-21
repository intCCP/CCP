/* Formatted on 17/06/2014 18:07:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DETT_DATI_GEN_EXTR
(
   COD_ABI,
   COD_NDG,
   COD_PROT_DELIBERA,
   COD_PROT_PACCHETTO,
   DTA_SCADENZA,
   DTA_ULTIMA_DELIB,
   VAL_ESP_CASSA_QTA_CAP,
   VAL_ESP_COMPLESSIVA,
   VAL_ESP_COMPLESSIVA_DA_VAL,
   VAL_ESP_FIRMA,
   VAL_ESP_NETTA_CASSA_QTA_CAP,
   VAL_RETT_ATTUALE,
   VAL_TOT_DERIVATI,
   VAL_TOT_FONDI_TERZI,
   VAL_TOT_INTERESSI_DI_MORA,
   VAL_TOT_RETT_CALCOLATA,
   VAL_TOT_RETT_PROGR_DELIB,
   VAL_RETT_CASSA_QTA_CAP,
   VAL_RETT_FIRMA,
   VAL_RETT_RAPP_OP_DELIB,
   VAL_PERC_RETT_RAPP_FIRMA,
   VAL_RDV_PREGR_CASSA,
   VAL_RDV_PREGR_FIRMA,
   VAL_VARIAZIONE_RDV,
   VAL_RETT_ATTUALE_FIRMA,
   VAL_RETT_RAPP_FIRMA,
   VAL_RETT_RAPP_FIRMA_DELIB,
   VAL_TOT_RETT_PROGR_PARERE,
   VAL_RETT_ATTUALE_CASSA,
   VAL_ESP_NETTA_POST_DELIBERA,
   VAL_RDV_ATT_CASSA,
   VAL_RDV_ATT_FIRMA,
   VAL_RDV_CASSA_MESE_PREC,
   VAL_RDV_FIRMA_MESE_PREC,
   VAL_TOT_RDV_MESE_PREC,
   VAL_RETT_RAPP_OP_PROGR,
   VAL_RDV_DELIB_BANCA_RETE,
   DTA_AGGIORNAMENTO
)
AS
   SELECT "COD_ABI",
          "COD_NDG",
          "COD_PROT_DELIBERA",
          "COD_PROT_PACCHETTO",
          "DTA_SCADENZA",
          "DTA_ULTIMA_DELIB",
          "VAL_ESP_CASSA_QTA_CAP",
          "VAL_ESP_COMPLESSIVA",
          "VAL_ESP_COMPLESSIVA_DA_VAL",
          "VAL_ESP_FIRMA",
          "VAL_ESP_NETTA_CASSA_QTA_CAP",
          "VAL_RETT_ATTUALE",
          "VAL_TOT_DERIVATI",
          "VAL_TOT_FONDI_TERZI",
          "VAL_TOT_INTERESSI_DI_MORA",
          "VAL_TOT_RETT_CALCOLATA",
          "VAL_TOT_RETT_PROGR_DELIB",
          "VAL_RETT_CASSA_QTA_CAP",
          "VAL_RETT_FIRMA",
          "VAL_RETT_RAPP_OP_DELIB",
          "VAL_PERC_RETT_RAPP_FIRMA",
          "VAL_RDV_PREGR_CASSA",
          "VAL_RDV_PREGR_FIRMA",
          "VAL_VARIAZIONE_RDV",
          "VAL_RETT_ATTUALE_FIRMA",
          "VAL_RETT_RAPP_FIRMA",
          "VAL_RETT_RAPP_FIRMA_DELIB",
          "VAL_TOT_RETT_PROGR_PARERE",
          "VAL_RETT_ATTUALE_CASSA",
          "VAL_ESP_NETTA_POST_DELIBERA",
          "VAL_RDV_ATT_CASSA",
          "VAL_RDV_ATT_FIRMA",
          "VAL_RDV_CASSA_MESE_PREC",
          "VAL_RDV_FIRMA_MESE_PREC",
          "VAL_TOT_RDV_MESE_PREC",
          "VAL_RETT_RAPP_OP_PROGR",
          "VAL_RDV_DELIB_BANCA_RETE",
          "DTA_AGGIORNAMENTO"
     FROM (SELECT -- 23/10/2012 I.Gueorguieva Aggiunte distinct nelle sottoselect sulle stime, che moltiplicavano i record per rapporto
                 cod_abi,
                  cod_ndg,
                  cod_prot_delibera,
                  cod_prot_pacchetto,
                  dta_scadenza,
                  dta_ultima_delib,
                  val_esp_cassa_qta_cap,
                  val_esp_complessiva,
                  val_esp_complessiva_da_val,
                  val_esp_firma,
                  val_esp_netta_cassa_qta_cap,
                  val_rett_attuale,
                  val_tot_derivati,
                  val_tot_fondi_terzi,
                  val_tot_interessi_di_mora,
                  val_tot_rett_calcolata,
                  val_tot_rett_progr_delib,
                  val_rett_cassa_qta_cap,
                  val_rett_firma,
                  val_rett_rapp_op_delib,
                  val_perc_rett_rapp_firma,
                  val_rdv_pregr_cassa,
                  val_rdv_pregr_firma,
                  val_variazione_rdv,
                  val_rett_attuale_firma,
                  val_rett_rapp_firma,
                  val_rett_rapp_firma_delib,
                  val_tot_rett_progr_parere,
                  val_rett_attuale_cassa,
                  (  NVL (val_esp_cassa_qta_cap, 0)
                   - NVL (val_rett_cassa_qta_cap, 0))
                     AS val_esp_netta_post_delibera,                --22 marzo
                  (  NVL (val_rett_cassa_qta_cap, 0)
                   - NVL (val_rdv_pregr_cassa, 0))
                     AS val_rdv_att_cassa,
                  (NVL (val_rett_firma, 0) - NVL (val_rdv_pregr_firma, 0))
                     AS val_rdv_att_firma,
                  val_rdv_cassa_mese_prec,                            --14 mar
                  val_rdv_firma_mese_prec,
                  VAL_TOT_RDV_MESE_PREC,
                  VAL_RETT_RAPP_OP_PROGR,
                  VAL_RDV_DELIB_BANCA_RETE,
                  dta_last_upd_delibera AS DTA_AGGIORNAMENTO
             FROM ( (SELECT DISTINCT
                            r.cod_abi,
                            r.cod_ndg,
                            r.cod_prot_delibera,
                            r.cod_prot_pacchetto,
                            MAX (d.dta_scadenza)
                               OVER (PARTITION BY d.cod_abi, d.cod_ndg)
                               AS dta_scadenza,
                            d2.dta_delibera AS dta_ultima_delib,
                            --2 aprile: modifica su richiesta utente
                            SUM (
                                 NVL (val_utilizzato_lordo, 0)
                               - NVL (val_utilizzato_mora, 0))
                            OVER (
                               PARTITION BY r.cod_abi,
                                            r.cod_ndg,
                                            r.cod_prot_delibera)
                               AS val_esp_cassa_qta_cap,
                            SUM (
                                 NVL (val_utilizzato_firma, 0)
                               + NVL (val_utilizzato_lordo, 0))
                            OVER (
                               PARTITION BY r.cod_abi,
                                            r.cod_ndg,
                                            r.cod_prot_delibera)
                               AS val_esp_complessiva,
                            SUM (
                                 (  NVL (val_utilizzato_lordo, 0)
                                  - NVL (val_utilizzato_mora, 0))
                               + NVL (val_utilizzato_firma, 0))
                            OVER (
                               PARTITION BY r.cod_abi,
                                            r.cod_ndg,
                                            r.cod_prot_delibera)
                               AS val_esp_complessiva_da_val,
                            SUM (
                               NVL (val_utilizzato_firma, 0))
                            OVER (
                               PARTITION BY r.cod_abi,
                                            r.cod_ndg,
                                            r.cod_prot_delibera)
                               AS val_esp_firma,
                            SUM (
                                 NVL (val_utilizzato_lordo, 0)
                               - NVL (val_utilizzato_mora, 0)
                               - NVL (val_rett_cassa_qta_cap, 0))
                            OVER (
                               PARTITION BY r.cod_abi,
                                            r.cod_ndg,
                                            r.cod_prot_delibera)
                               AS val_esp_netta_cassa_qta_cap,
                              NVL (d2.val_rdv_extra_delibera, 0)
                            + NVL (d2.val_rdv_extra_fi, 0)
                               AS val_rett_attuale,
                            SUM (
                               NVL (val_utilizzato_sosti, 0))
                            OVER (
                               PARTITION BY r.cod_abi,
                                            r.cod_ndg,
                                            r.cod_prot_delibera)
                               AS val_tot_derivati,
                            SUM (
                               fondo_terzi)
                            OVER (
                               PARTITION BY r.cod_abi,
                                            r.cod_ndg,
                                            r.cod_prot_delibera)
                               AS val_tot_fondi_terzi,
                            SUM (
                               NVL (val_utilizzato_mora, 0))
                            OVER (
                               PARTITION BY r.cod_abi,
                                            r.cod_ndg,
                                            r.cod_prot_delibera)
                               AS val_tot_interessi_di_mora,
                            (  NVL (d.val_rdv_qc_progressiva, 0)
                             + NVL (d.val_rdv_progr_fi, 0))
                               AS val_tot_rett_calcolata,
                              ----RDV DI CA + RDV DI FI

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
                            d2.val_rdv_extra_delibera
                               AS val_rett_attuale_cassa,
                            d.val_rdv_progr_fi AS val_rett_rapp_firma,
                            d.val_rdv_qc_progressiva
                               AS val_rett_cassa_qta_cap,
                            d.val_rdv_progr_fi AS val_rett_firma,
                            --AD 24 OTT: INSERITO NVL PER REPERIMENTO TOT_RDV_rAPP_OPERATIVI
                            DECODE (
                               d2.cod_tipo_pacchetto,
                               'M', d2.val_rdv_rapp_operativi,
                               NVL (d2.val_rdv_rapp_operativi,
                                    s2.rdv_operativi))
                               AS val_rett_rapp_op_delib,
                            --ultima delibera PRECEDENTE
                            DECODE (
                               d.cod_tipo_pacchetto,
                               'M', d.val_rdv_rapp_operativi,
                               NVL (
                                  d.val_rdv_rapp_operativi,
                                  SUM (
                                     r.val_rdv_rapp_operativi)
                                  OVER (
                                     PARTITION BY r.cod_abi,
                                                  r.cod_ndg,
                                                  r.cod_prot_delibera)))
                               AS val_rett_rapp_op_progr,
                            d.val_perc_rett_rapp_firma,
                            d.val_rdv_qc_ante_delib AS val_rdv_pregr_cassa,
                            ---IN HOST LA RDV ? SEMPRE E SOLO DI CASSA
                            NVL (d.val_rdv_pregr_fi, 0)
                               AS val_rdv_pregr_firma,              --3 APRILE
                              (  NVL (d.val_rdv_qc_progressiva, 0)
                               + NVL (d.val_rdv_progr_fi, 0))
                            - (  NVL (d.val_rdv_qc_ante_delib, 0)
                               + NVL (d2.val_rdv_progr_fi, 0))
                               AS val_variazione_rdv,
                            NULL AS val_rdv_cassa_mese_prec,
                            NULL AS val_rdv_firma_mese_prec,
                            NULL AS VAL_TOT_RDV_MESE_PREC,
                            D.VAL_RDV_DELIB_BANCA_RETE,
                            d.dta_last_upd_delibera
                          /*,
R.VAL_RDV_rAPP_OPERATIVI\*,
                        s.rdv_operativi*\*/
                       FROM v_mcrei_app_dett_rapporti r,
                            t_mcrei_app_delibere d,
                            t_mcrei_app_delibere d2,
                            /*(SELECT distinct cod_abi,
                                    cod_ndg,
                                    cod_protocollo_delibera,
                                    SUM(val_rdv_tot) over(PARTITION BY cod_abi, cod_ndg, cod_protocollo_delibera) AS rdv_operativi
                               FROM t_mcrei_app_stime
                              WHERE flg_tipo_dato = 'R' AND FLG_ATTIVA= 1) s,*/
                            (SELECT DISTINCT
                                    cod_abi,
                                    cod_ndg,
                                    cod_protocollo_delibera,
                                    SUM (
                                       val_rdv_tot)
                                    OVER (
                                       PARTITION BY cod_abi,
                                                    cod_ndg,
                                                    cod_protocollo_delibera)
                                       AS rdv_operativi
                               FROM t_mcrei_app_stime
                              WHERE     flg_tipo_dato = 'R'
                                    AND flg_attiva = 1
                                    AND NVL (cod_classe_ft, 'CA') = 'CA') s2
                      WHERE     d.cod_abi = r.cod_abi
                            AND d.cod_ndg = r.cod_ndg
                            AND d.cod_protocollo_delibera =
                                   r.cod_prot_delibera
                            AND d.cod_abi = d2.cod_abi(+)
                            AND d.cod_ndg = d2.cod_ndg(+)
                            AND d.cod_protocollo_delibera_pre =
                                   d2.cod_protocollo_delibera(+)
                            /* AND d.cod_abi = s.cod_abi(+)
                             AND d.cod_ndg = s.cod_ndg(+)
                             AND d.cod_protocollo_delibera = s.cod_protocollo_delibera(+)
                          */
                            AND d2.cod_abi = s2.cod_abi(+)
                            AND d2.cod_ndg = s2.cod_ndg(+)
                            AND d2.cod_protocollo_delibera =
                                   s2.cod_protocollo_delibera(+)
                            AND d.flg_attiva = 1
                            AND d2.flg_attiva(+) = 1
                            AND d.cod_fase_delibera NOT IN ('AN', 'VA') --13Dicembre
                            AND d2.cod_fase_delibera(+) NOT IN ('AN', 'VA'))))
    WHERE cod_prot_pacchetto IS NOT NULL;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DETT_DATI_GEN_EXTR TO MCRE_USR;
