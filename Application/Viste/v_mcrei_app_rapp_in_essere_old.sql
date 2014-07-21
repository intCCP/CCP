/* Formatted on 21/07/2014 18:40:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_RAPP_IN_ESSERE_OLD
(
   COD_SNDG,
   COD_ABI,
   COD_STATO,
   "CASSA BT ACC",
   "CASSA BT UTI",
   "CASSA ML ACC",
   "CASSA ML UTI",
   "TOT.CASSA ACC",
   "TOT.CASSA UTI",
   "FIRMA ACC",
   "FIRMA UTI",
   "DERIVATI ACC",
   "DERIVATI UTI",
   "TOT.COMPLESSIVO ACC ",
   "TOT.COMPLESSIVO UTI",
   DTA_RIFERIMENTO_DATI
)
AS
     SELECT a.cod_sndg,
            a.cod_abi,
            a.cod_stato,
            SUM (a.cassa_bt_accordato) "CASSA BT ACC",
            SUM (a.cassa_bt_utilizzato) "CASSA BT UTI",
            SUM (a.cassa_ml_accordato) "CASSA ML ACC",
            SUM (a.cassa_ml_utilizzato) "CASSA ML UTI",
            SUM (a.cassa_tot_accordato) "TOT.CASSA ACC",
            SUM (a.cassa_tot_utilizzato) "TOT.CASSA UTI",
            SUM (a.firma_accordato) "FIRMA ACC",
            SUM (a.firma_utilizzato) "FIRMA UTI",
            SUM (a.derivati_accordato) "DERIVATI ACC",
            SUM (a.derivati_utilizzato) "DERIVATI UTI",
            SUM (a.totale_compl_acc) "TOT.COMPLESSIVO ACC ",
            SUM (a.totale_compl_uti) "TOT.COMPLESSIVO UTI",
            dta_riferimento_dati                                   --16 maggio
       FROM (  SELECT pcr.cod_sndg,
                      pcr.cod_abi,
                      pcr.cod_ndg,
                      pcr.dta_INZ_VLD AS dta_riferimento_dati,
                      d.cod_stato,
                      nat.cod_natura,
                      nat.desc_natura,
                      pcr.cod_classe_ft,
                      CASE
                         WHEN cod_natura = '01' AND pcr.cod_classe_ft = 'CA'
                         THEN
                            SUM (pcr.val_accordato_delib)
                         ELSE
                            NULL
                      END
                         AS cassa_bt_accordato,
                      CASE
                         WHEN cod_natura = '01' AND pcr.cod_classe_ft = 'CA'
                         THEN
                            SUM (pcr.val_imp_utilizzato)
                         ELSE
                            NULL
                      END
                         AS cassa_bt_utilizzato,
                      CASE
                         WHEN cod_natura = '02' AND pcr.cod_classe_ft = 'CA'
                         THEN
                            SUM (pcr.val_accordato_delib)
                         ELSE
                            NULL
                      END
                         AS cassa_ml_accordato,
                      CASE
                         WHEN cod_natura = '02' AND pcr.cod_classe_ft = 'CA'
                         THEN
                            SUM (pcr.val_imp_utilizzato)
                         ELSE
                            NULL
                      END
                         AS cassa_ml_utilizzato,
                      CASE
                         WHEN     cod_natura IN ('01', '02')
                              AND pcr.cod_classe_ft = 'CA'
                         THEN
                            SUM (pcr.val_accordato_delib)
                         ELSE
                            NULL
                      END
                         AS cassa_tot_accordato,
                      CASE
                         WHEN     cod_natura IN ('01', '02')
                              AND pcr.cod_classe_ft = 'CA'
                         THEN
                            SUM (pcr.val_imp_utilizzato)
                         ELSE
                            NULL
                      END
                         AS cassa_tot_utilizzato,
                      CASE
                         WHEN cod_natura = '03' AND pcr.cod_classe_ft = 'FI'
                         THEN
                            SUM (pcr.val_accordato_delib)
                         ELSE
                            NULL
                      END
                         AS firma_accordato,
                      CASE
                         WHEN cod_natura = '03' AND pcr.cod_classe_ft = 'FI'
                         THEN
                            SUM (pcr.val_imp_utilizzato)
                         ELSE
                            NULL
                      END
                         AS firma_utilizzato,
                      CASE
                         WHEN cod_natura = '04' AND pcr.cod_classe_ft = 'ST'
                         THEN
                            SUM (pcr.val_accordato_delib)
                         ELSE
                            NULL
                      END
                         AS derivati_accordato,
                      CASE
                         WHEN cod_natura = '04' AND pcr.cod_classe_ft = 'ST'
                         THEN
                            SUM (pcr.val_imp_utilizzato)
                         ELSE
                            NULL
                      END
                         AS derivati_utilizzato,
                      SUM (pcr.val_accordato_delib) totale_compl_acc,
                      SUM (pcr.val_imp_utilizzato) totale_compl_uti
                 FROM t_mcrei_app_pcr_rapporti pcr,
                      t_mcre0_app_natura_ftecnica nat,
                      t_mcre0_app_all_data d
                WHERE     pcr.cod_forma_tecnica = nat.cod_ftecnica(+)
                      -- da valutare se levare l'outer
                      AND pcr.cod_abi = d.cod_abi_cartolarizzato
                      AND pcr.cod_ndg = d.cod_ndg
                      AND pcr.cod_classe_ft IN ('CA', 'FI', 'ST')
             GROUP BY pcr.cod_sndg,
                      pcr.cod_abi,
                      pcr.dta_INZ_VLD,
                      pcr.cod_ndg,
                      d.cod_stato,
                      nat.cod_natura,
                      nat.desc_natura,
                      pcr.cod_classe_ft) a
   GROUP BY a.cod_sndg,
            a.cod_abi,
            a.cod_stato,
            dta_riferimento_dati;
