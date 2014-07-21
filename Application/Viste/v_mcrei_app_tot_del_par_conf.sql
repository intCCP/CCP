/* Formatted on 21/07/2014 18:40:56 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_TOT_DEL_PAR_CONF
(
   COD_SNDG,
   COD_PROTOCOLLO_PACCHETTO,
   "Cassa Rett.Esistente",
   "Cassa Rett.Proposta",
   "Cassa Totale Rett.",
   "Derivati Rett.Esistente",
   "Derivati Rett.Proposta",
   "Derivati Totale Rett.",
   "Firma Rett.Esistente",
   "Firma Rett.Proposta",
   "Firma Totale Rett.",
   TOTALE_RINUNCIA,
   TOTALE_RINUNCIA_PREGRESSA,
   TOT_UTILIZZATO,
   "Totale Rett.",
   "Totale Rett.Esistente",
   "Totale Rett.Proposta",
   UTILIZZATO_CASSA,
   UTILIZZATO_DERIVATI,
   UTILIZZATO_FIRMA,
   VAL_ESP_LORDA_MORA,
   VAL_RDV_DELIB_BANCA_RETE,
   VAL_RINUNCIA_PROPOSTA
)
AS
   SELECT /*chiamare BEGIN dbms_application_info.set_client_info( proto_pacchetto); END;*/
         DISTINCT
          to_join.cod_sndg,
          to_join.cod_protocollo_pacchetto,
          sum_ok."Cassa Rett.Esistente",
          sum_ok."Cassa Rett.Proposta",
          sum_ok."Cassa Totale Rett.",
          sum_ok."Derivati Rett.Esistente",
          sum_ok."Derivati Rett.Proposta",
          sum_ok."Derivati Totale Rett.",
          sum_ok."Firma Rett.Esistente",
          sum_ok."Firma Rett.Proposta",
          sum_ok."Firma Totale Rett.",
          to_join.totale_rinuncia,
          to_join.totale_rinuncia_pregressa,
          to_join.tot_utilizzato,
          (  NVL (sum_ok."Cassa Totale Rett.", 0)
           + NVL (sum_ok."Derivati Totale Rett.", 0)
           + NVL (sum_ok."Firma Totale Rett.", 0))
             AS "Totale Rett.",
          (  NVL (sum_ok."Cassa Rett.Esistente", 0)
           + NVL (sum_ok."Derivati Rett.Esistente", 0)
           + NVL (sum_ok."Firma Rett.Esistente", 0))
             AS "Totale Rett.Esistente",
          (  NVL (sum_ok."Cassa Rett.Proposta", 0)
           + NVL (sum_ok."Derivati Rett.Proposta", 0)
           + NVL (sum_ok."Firma Rett.Proposta", 0))
             AS "Totale Rett.Proposta",
          to_join.utilizzato_cassa,
          to_join.utilizzato_derivati,
          to_join.utilizzato_firma,
          to_join.val_esp_lorda_mora,
          to_join.val_rdv_delib_banca_rete,
          to_join.val_rinuncia_proposta
     FROM (SELECT cod_protocollo_pacchetto,
                  cod_sndg,
                  SUM ("Cassa Rett.Esistente")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Cassa Rett.Esistente",
                  SUM ("Firma Rett.Esistente")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Firma Rett.Esistente",
                  SUM ("Derivati Rett.Esistente")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Derivati Rett.Esistente",
                  SUM ("Cassa Rett.Proposta")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Cassa Rett.Proposta",
                  SUM ("Firma Rett.Proposta")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Firma Rett.Proposta",
                  SUM ("Derivati Rett.Proposta")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Derivati Rett.Proposta",
                  SUM ("Cassa Totale Rett.")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Cassa Totale Rett.",
                  SUM ("Firma Totale Rett.")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Firma Totale Rett.",
                  SUM ("Derivati Totale Rett.")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Derivati Totale Rett."
             FROM (SELECT DISTINCT cod_abi,
                                   cod_ndg,
                                   cod_sndg,
                                   cod_protocollo_pacchetto,
                                   "Cassa Rett.Esistente",
                                   "Firma Rett.Esistente",
                                   "Derivati Rett.Esistente",
                                   "Cassa Rett.Proposta",
                                   "Firma Rett.Proposta",
                                   "Derivati Rett.Proposta",
                                   "Cassa Totale Rett.",
                                   "Firma Totale Rett.",
                                   "Derivati Totale Rett."
                     FROM (SELECT                                    --CALCOLO
                                 cod_abi,
                                  cod_protocollo_pacchetto,
                                  cod_ndg,
                                  cod_sndg,
                                  MIN (
                                     "Cassa Rett.Esistente")
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_pacchetto)
                                     AS "Cassa Rett.Esistente",
                                  MIN (
                                     "Firma Rett.Esistente")
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_pacchetto)
                                     AS "Firma Rett.Esistente",
                                  MIN (
                                     "Derivati Rett.Esistente")
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_pacchetto)
                                     "Derivati Rett.Esistente",
                                  SUM (
                                     "Cassa Rett.Proposta")
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_pacchetto)
                                     AS "Cassa Rett.Proposta",
                                  SUM (
                                     "Firma Rett.Proposta")
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_pacchetto)
                                     AS "Firma Rett.Proposta",
                                  SUM (
                                     "Derivati Rett.Proposta")
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_pacchetto)
                                     AS "Derivati Rett.Proposta",
                                  MAX (
                                     "Cassa Totale Rett.")
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_pacchetto)
                                     AS "Cassa Totale Rett.",
                                  MAX (
                                     "Firma Totale Rett.")
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_pacchetto)
                                     AS "Firma Totale Rett.",
                                  MAX (
                                     "Derivati Totale Rett.")
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_protocollo_pacchetto)
                                     AS "Derivati Totale Rett."
                             FROM (  SELECT /*+  no_parallel (f)*/
                                            -- 0216 aggiunto filtro no_delibera = 0 e fase-delibera != 'AN
                                            d.cod_abi,
                                            d.cod_protocollo_pacchetto,
                                            d.cod_ndg,
                                            d.cod_sndg,
                                            d.cod_microtipologia_delib,
                                            (CASE
                                                WHEN d.cod_microtipologia_delib NOT IN
                                                        ('CI', 'CS', 'CH')
                                                THEN
                                                   NVL (val_rdv_qc_ante_delib,
                                                        0)
                                                --7 giu
                                                ELSE
                                                   TO_NUMBER (NULL)
                                             END)
                                               AS "Cassa Rett.Esistente",
                                            (CASE
                                                WHEN d.cod_microtipologia_delib NOT IN
                                                        ('CI', 'CS', 'CH')
                                                THEN
                                                   NVL (d.val_rdv_pregr_fi, 0)
                                                ELSE
                                                   TO_NUMBER (NULL)
                                             END)
                                               AS "Firma Rett.Esistente",
                                            TO_NUMBER (NULL)
                                               AS "Derivati Rett.Esistente",
                                            --variazioni proposte
                                            ---maschero rdv per le classificazioni
                                            (CASE
                                                WHEN d.cod_microtipologia_delib NOT IN
                                                        ('CI', 'CS', 'CH')
                                                THEN
                                                   (  NVL (
                                                         val_rdv_qc_progressiva,
                                                         0)
                                                    - NVL (
                                                         val_rdv_qc_ante_delib,
                                                         0))
                                                ELSE
                                                   TO_NUMBER (NULL)
                                             END)
                                               AS "Cassa Rett.Proposta",
                                            (CASE
                                                WHEN d.cod_microtipologia_delib NOT IN
                                                        ('CI', 'CS', 'CH')
                                                THEN
                                                   (  NVL (d.val_rdv_progr_fi,
                                                           0)
                                                    - NVL (d.val_rdv_pregr_fi,
                                                           0))
                                                ELSE
                                                   TO_NUMBER (NULL)
                                             END)
                                               AS "Firma Rett.Proposta",
                                            TO_NUMBER (NULL)
                                               AS "Derivati Rett.Proposta",
                                            ----totali_da_deliberare
                                            ---maschero rdv per le classificazioni
                                            (CASE
                                                WHEN d.cod_microtipologia_delib NOT IN
                                                        ('CI', 'CS', 'CH')
                                                THEN
                                                   NVL (val_rdv_qc_progressiva,
                                                        0)
                                                ELSE
                                                   TO_NUMBER (NULL)
                                             END)
                                               AS "Cassa Totale Rett.",
                                            (CASE
                                                WHEN d.cod_microtipologia_delib NOT IN
                                                        ('CI', 'CS', 'CH')
                                                THEN
                                                   NVL (d.val_rdv_progr_fi, 0)
                                                ELSE
                                                   TO_NUMBER (NULL)
                                             END)
                                               AS "Firma Totale Rett.",
                                            TO_NUMBER (NULL)
                                               AS "Derivati Totale Rett.",
                                            --totale
                                            (CASE
                                                WHEN d.cod_microtipologia_delib NOT IN
                                                        ('CI', 'CS', 'CH')
                                                THEN
                                                   (  NVL (
                                                         val_rdv_qc_ante_delib,
                                                         0)
                                                    + NVL (d.val_rdv_pregr_fi,
                                                           0))
                                                ELSE
                                                   TO_NUMBER (NULL)
                                             END)
                                               AS "Totale Rett.Esistente",
                                            ---maschero rdv per le classificazioni
                                            (CASE
                                                WHEN d.cod_microtipologia_delib NOT IN
                                                        ('CI', 'CS', 'CH')
                                                THEN
                                                     (  NVL (
                                                           val_rdv_qc_progressiva,
                                                           0)
                                                      - NVL (
                                                           val_rdv_qc_ante_delib,
                                                           0))
                                                   + (  NVL (
                                                           d.val_rdv_progr_fi,
                                                           0)
                                                      - NVL (
                                                           d.val_rdv_pregr_fi,
                                                           0))
                                                ELSE
                                                   TO_NUMBER (NULL)
                                             END)
                                               AS "Totale Rett.Proposta",
                                            (CASE
                                                WHEN d.cod_microtipologia_delib NOT IN
                                                        ('CI', 'CS', 'CH')
                                                THEN
                                                   (  NVL (
                                                         val_rdv_qc_progressiva,
                                                         0)
                                                    + NVL (d.val_rdv_progr_fi,
                                                           0))
                                                ELSE
                                                   TO_NUMBER (NULL)
                                             END)
                                               AS "Totale Rett.",
                                            --------------
                                            d.cod_fase_microtipologia,
                                            --17/05/2012
                                            t1.desc_dominio
                                               desc_fase_microtipologia,
                                            d.cod_fase_pacchetto,
                                            d1.desc_dominio desc_fase_pacchetto
                                       FROM t_mcrei_app_delibere d,
                                            t_mcre0_app_istituti i,
                                            t_mcre0_app_all_data f,
                                            t_mcrei_cl_domini t1,
                                            t_mcrei_cl_domini d1
                                      WHERE     d.cod_fase_delibera NOT IN
                                                   ('AN', 'VA')
                                            --13Dicembre
                                            --AND d.cod_fase_pacchetto = 'COD'  ----6 MARZO
                                            AND d.flg_no_delibera = 0
                                            AND d.flg_attiva = '1'
                                            AND d.cod_abi =
                                                   f.cod_abi_cartolarizzato
                                            AND d.cod_ndg = f.cod_ndg
                                            AND d.cod_abi = i.cod_abi
                                            AND t1.cod_dominio =
                                                   'MICROTIPOLOGIA'
                                            AND t1.val_dominio =
                                                   d.cod_fase_microtipologia
                                            AND d1.cod_dominio = 'PACCHETTO'
                                            AND d1.val_dominio =
                                                   d.cod_fase_pacchetto
                                            AND d.cod_protocollo_pacchetto =
                                                   SUBSTR (
                                                      (SYS_CONTEXT (
                                                          'userenv',
                                                          'client_info')),
                                                      1,
                                                      30)
                                   ORDER BY d.cod_abi, d.cod_ndg) gd
                            WHERE cod_microtipologia_delib NOT IN
                                     ('CS', 'CI', 'CH')) dist) sum_distinct) sum_ok,
          (SELECT cod_protocollo_pacchetto,
                  cod_sndg,
                  SUM ("Cassa Rett.Esistente")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Cassa Rett.Esistente",
                  SUM ("Cassa Rett.Proposta")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Cassa Rett.Proposta",
                  SUM ("Cassa Totale Rett.")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Cassa Totale Rett.",
                  SUM ("Derivati Rett.Esistente")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Derivati Rett.Esistente",
                  SUM ("Derivati Rett.Proposta")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Derivati Rett.Proposta",
                  SUM ("Derivati Totale Rett.")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Derivati Totale Rett.",
                  SUM ("Firma Rett.Esistente")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Firma Rett.Esistente",
                  SUM ("Firma Rett.Proposta")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Firma Rett.Proposta",
                  SUM ("Firma Totale Rett.")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Firma Totale Rett.",
                  totale_rinuncia,
                  totale_rinuncia_pregressa,
                  SUM (tot_utilizzato)
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS tot_utilizzato,
                  SUM ("Totale Rett.")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Totale Rett.",
                  SUM ("Totale Rett.Esistente")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Totale Rett.Esistente",
                  SUM ("Totale Rett.Proposta")
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS "Totale Rett.Proposta",
                  SUM (utilizzato_cassa)
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS utilizzato_cassa,
                  SUM (utilizzato_derivati)
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS utilizzato_derivati,
                  SUM (utilizzato_firma)
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS utilizzato_firma,
                  SUM (val_esp_lorda_mora)
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS val_esp_lorda_mora,
                  SUM (val_rdv_delib_banca_rete)
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS val_rdv_delib_banca_rete,
                  SUM (val_rinuncia_proposta)
                     OVER (PARTITION BY cod_protocollo_pacchetto)
                     AS val_rinuncia_proposta
             FROM (SELECT DISTINCT
                          cod_protocollo_pacchetto,
                          cod_sndg,
                          SUM (
                             "Cassa Rett.Esistente")
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS "Cassa Rett.Esistente",
                          SUM (
                             "Cassa Rett.Proposta")
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS "Cassa Rett.Proposta",
                          SUM (
                             "Cassa Totale Rett.")
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS "Cassa Totale Rett.",
                          SUM (
                             "Derivati Rett.Esistente")
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS "Derivati Rett.Esistente",
                          SUM ("Derivati Rett.Proposta")
                             OVER (PARTITION BY cod_abi, cod_ndg)
                             AS "Derivati Rett.Proposta",
                          SUM (
                             "Derivati Totale Rett.")
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS "Derivati Totale Rett.",
                          SUM (
                             "Firma Rett.Esistente")
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS "Firma Rett.Esistente",
                          SUM (
                             "Firma Rett.Proposta")
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS "Firma Rett.Proposta",
                          SUM (
                             "Firma Totale Rett.")
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS "Firma Totale Rett.",
                          MAX (
                             totale_rinuncia)
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS totale_rinuncia,
                          MAX (
                             totale_rinuncia_pregressa)
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS totale_rinuncia_pregressa,
                          MAX (
                             tot_utilizzato)
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS tot_utilizzato,
                          SUM (
                             "Totale Rett.")
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS "Totale Rett.",
                          SUM (
                             "Totale Rett.Esistente")
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS "Totale Rett.Esistente",
                          SUM (
                             "Totale Rett.Proposta")
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS "Totale Rett.Proposta",
                          MAX (
                             utilizzato_cassa)
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS utilizzato_cassa,
                          MAX (
                             utilizzato_derivati)
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS utilizzato_derivati,
                          MAX (
                             utilizzato_firma)
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS utilizzato_firma,
                          MAX (
                             val_esp_lorda_mora)
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS val_esp_lorda_mora,
                          SUM (
                             val_rdv_delib_banca_rete)
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS val_rdv_delib_banca_rete,
                          SUM (
                             val_rinuncia_proposta)
                          OVER (
                             PARTITION BY cod_protocollo_pacchetto,
                                          cod_abi,
                                          cod_ndg)
                             AS val_rinuncia_proposta
                     FROM mcre_own.v_mcrei_app_delib_par_conf
                    WHERE cod_protocollo_pacchetto =
                             SUBSTR (
                                (SYS_CONTEXT ('userenv', 'client_info')),
                                1,
                                30))) to_join
    WHERE sum_ok.cod_protocollo_pacchetto = to_join.cod_protocollo_pacchetto;
