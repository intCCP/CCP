/* Formatted on 21/07/2014 18:42:34 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_PERFORMANCE
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_PRESIDIO,
   DESC_PRESIDIO,
   COD_MATR_PRATICA,
   VAL_ANNOMESE,
   VAL_GBV_MEDIO,
   VAL_NBV_MEDIO,
   VAL_VANTATO_MEDIO,
   VAL_INCASSI,
   VAL_TMR_VANTATO,
   VAL_TMR_GBV,
   VAL_NUM_MESI,
   VAL_SOPRAVVENIENZE,
   VAL_SOP_IN_PRESIDIO,
   VAL_VAN_PRESIDIO,
   VAL_SOP_IN_ABI,
   VAL_VAN_ABI,
   VAL_SOP_IN_PR_MATR,
   VAL_VAN_PR_MATR,
   VAL_GBV_PRESIDIO,
   VAL_GBV_ABI,
   VAL_GBV_PR_MATR,
   VAL_SOPRAVVENIENZE_ATTIVE,
   VAL_SPESE,
   VAL_TMR_VANT_PRESIDIO,
   VAL_TMR_VANT_ABI,
   VAL_TMR_VANT_PR_MATR,
   VAL_TMR_GBV_PRESIDIO,
   VAL_TMR_GBV_ABI,
   VAL_TMR_GBV_PR_MATR
)
AS
   SELECT a."COD_ABI",
          a."DESC_ISTITUTO",
          a."COD_PRESIDIO",
          a."DESC_PRESIDIO",
          a."COD_MATR_PRATICA",
          a."VAL_ANNOMESE",
          a."VAL_GBV_MEDIO",
          a."VAL_NBV_MEDIO",
          a."VAL_VANTATO_MEDIO",
          a."VAL_INCASSI",
          a."VAL_TMR_VANTATO",
          a."VAL_TMR_GBV",
          a."VAL_NUM_MESI",
          a."VAL_SOPRAVVENIENZE",
          a."VAL_SOP_IN_PRESIDIO",
          a."VAL_VAN_PRESIDIO",
          a."VAL_SOP_IN_ABI",
          a."VAL_VAN_ABI",
          a."VAL_SOP_IN_PR_MATR",
          a."VAL_VAN_PR_MATR",
          a."VAL_GBV_PRESIDIO",
          a."VAL_GBV_ABI",
          a."VAL_GBV_PR_MATR",
          a."VAL_SOPRAVVENIENZE_ATTIVE",
          a."VAL_SPESE",
          DECODE (val_num_mesi,
                  0, NULL,
                  val_sop_in_presidio / (val_van_presidio / val_num_mesi))
             val_tmr_vant_presidio,
          DECODE (val_num_mesi,
                  0, NULL,
                  val_sop_in_abi / (val_van_abi / val_num_mesi))
             val_tmr_vant_abi,
          DECODE (val_num_mesi,
                  0, NULL,
                  val_sop_in_pr_matr / (val_van_pr_matr / val_num_mesi))
             val_tmr_vant_pr_matr,
          DECODE (val_num_mesi,
                  0, NULL,
                  val_sop_in_presidio / (val_gbv_presidio / val_num_mesi))
             val_tmr_gbv_presidio,
          DECODE (val_num_mesi,
                  0, NULL,
                  val_sop_in_abi / (val_gbv_abi / val_num_mesi))
             val_tmr_gbv_abi,
          DECODE (val_num_mesi,
                  0, NULL,
                  val_sop_in_pr_matr / (val_gbv_pr_matr / val_num_mesi))
             val_tmr_gbv_pr_matr
     FROM (SELECT p.COD_ABI,
                  I.DESC_ISTITUTO,
                  "COD_UO_PRATICA" COD_PRESIDIO,
                  R.DESC_PRESIDIO,
                  DECODE (COD_MATR_PRATICA, '-1', NULL, COD_MATR_PRATICA)
                     COD_MATR_PRATICA,
                  "VAL_ANNOMESE",
                  "VAL_GBV_MEDIO",
                  "VAL_NBV_MEDIO",
                  "VAL_VANTATO_MEDIO",
                  "VAL_INCASSI",
                  "VAL_TMR_VANTATO",
                  "VAL_TMR_GBV",
                  val_num_mesi,
                  val_sopravvenienze,
                  SUM (val_sopravvenienze + val_incassi)
                     OVER (PARTITION BY val_annomese, cod_uo_pratica)
                     val_sop_in_presidio,
                  DECODE (
                     SUM (val_vantato)
                        OVER (PARTITION BY val_annomese, cod_uo_pratica),
                     0, 1,
                     SUM (val_vantato)
                        OVER (PARTITION BY val_annomese, cod_uo_pratica))
                     val_van_presidio,
                  SUM (val_sopravvenienze + val_incassi)
                     OVER (PARTITION BY val_annomese, p.cod_abi)
                     val_sop_in_abi,
                  DECODE (
                     SUM (val_vantato)
                        OVER (PARTITION BY val_annomese, p.cod_abi),
                     0, 1,
                     SUM (val_vantato)
                        OVER (PARTITION BY val_annomese, p.cod_abi))
                     val_van_abi,
                  SUM (val_sopravvenienze + val_incassi)
                     OVER (PARTITION BY val_annomese, cod_matr_pratica)
                     val_sop_in_pr_matr,
                  DECODE (
                     SUM (val_vantato)
                        OVER (PARTITION BY val_annomese, cod_uo_pratica),
                     0, 1,
                     SUM (
                        val_vantato)
                     OVER (
                        PARTITION BY val_annomese,
                                     cod_uo_pratica,
                                     cod_matr_pratica))
                     val_van_pr_matr,
                  DECODE (
                     SUM (val_gbv)
                        OVER (PARTITION BY val_annomese, cod_uo_pratica),
                     0, 1,
                     SUM (val_gbv)
                        OVER (PARTITION BY val_annomese, cod_uo_pratica))
                     val_gbv_presidio,
                  DECODE (
                     SUM (val_gbv)
                        OVER (PARTITION BY val_annomese, p.cod_abi),
                     0, 1,
                     SUM (val_gbv)
                        OVER (PARTITION BY val_annomese, p.cod_abi))
                     val_gbv_abi,
                  DECODE (
                     SUM (val_gbv)
                        OVER (PARTITION BY val_annomese, cod_uo_pratica),
                     0, 1,
                     SUM (
                        val_gbv)
                     OVER (
                        PARTITION BY val_annomese,
                                     cod_uo_pratica,
                                     cod_matr_pratica))
                     val_gbv_pr_matr,
                  VAL_SOPRAVVENIENZE VAL_SOPRAVVENIENZE_ATTIVE,
                  TO_NUMBER (NULL) val_spese
             FROM T_MCRES_FEN_PERFORMANCE P,
                  T_MCRES_APP_ISTITUTI I,
                  (SELECT *
                     FROM v_MCRES_APP_lista_presidi
                    WHERE cod_tipo = 'P') r
            WHERE p.cod_abi = i.cod_abi AND p.cod_uo_pratica = r.cod_presidio) a;
