/* Formatted on 21/07/2014 18:30:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_PM
(
   COD_SRC,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_ABI,
   ID_DPER,
   COD_NDG,
   COD_SNDG,
   VAL_GBV,
   VAL_NBV,
   VAL_TOT_INCASSI,
   DTA_INIZIO_STATO,
   DTA_FINE_STATO,
   FLG_NDG,
   FLG_CHIUSURA
)
AS
     SELECT 'PM' cod_src,
            'S' cod_stato_rischio,
            'Sofferenze' des_stato_rischio,
            p.cod_abi,
            SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6) id_dper,
            p.cod_ndg,
            r.cod_sndg,
            SUM (-r.val_imp_gbv_iniziale) val_gbv,
            SUM (-r.val_imp_nbv_iniziale) val_nbv,
            SUM (-r.val_imp_tot_incassi) val_tot_incassi,
            MAX (p.dta_apertura) dta_inizio_stato,
            MAX (p.dta_chiusura) dta_Fine_stato,
            1 flg_ndg,
            0 flg_chiusura
       FROM t_mcres_app_rapporti r, t_mcres_app_pratiche p                 --,
      -- (select distinct val_annomese from v_mcres_ultima_acq_bilancio  where  id_dper = SYS_CONTEXT ('userenv', 'client_info') )  f
      WHERE     p.cod_abi = r.cod_abi
            AND p.cod_ndg = r.cod_ndg
            AND TO_DATE (SYS_CONTEXT ('userenv', 'client_info'), 'yyyymmdd') BETWEEN dta_apertura
                                                                                 AND   dta_chiusura
                                                                                     - 1
   GROUP BY p.cod_abi, p.cod_ndg, r.cod_sndg
   UNION ALL
     --posiz aperte
     SELECT 'PM' cod_src,
            'S' cod_stato_rischio,
            'Sofferenze' des_stato_rischio,
            p.cod_abi,
            SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6) id_dper,
            p.cod_ndg,
            r.cod_sndg,
            SUM (-r.val_imp_gbv_iniziale) val_gbv,
            SUM (-r.val_imp_nbv_iniziale) val_nbv,
            SUM (-r.val_imp_tot_incassi) val_tot_incassi,
            MIN (p.dta_apertura) dta_inizio_stato,
            MAX (p.dta_chiusura) dta_fine_stato,
            1 flg_ndg,
            1 flg_chiusura
       FROM t_mcres_app_rapporti r, t_mcres_app_pratiche p                 --,
      --v_mcres_ultima_acq_bilancio f
      WHERE     p.flg_attiva = 0
            --AND p.dta_chiusura <= f.dta_dper --per lo storico, prima non c'era!
            AND p.cod_abi = r.cod_abi
            AND p.cod_ndg = r.cod_ndg
            --AND P.COD_ABI = F.COD_ABI
            --AND p.dta_chiusura >= ADD_MONTHS (TO_DATE (F.ID_DPER, 'YYYYMMDD'), -12)
            AND p.dta_chiusura BETWEEN ADD_MONTHS (
                                          TO_DATE (
                                             SYS_CONTEXT ('userenv',
                                                          'client_info'),
                                             'YYYYMMDD'),
                                          -12)
                                   AND TO_DATE (
                                          SYS_CONTEXT ('userenv',
                                                       'client_info'),
                                          'YYYYMMDD')
   GROUP BY p.cod_abi, p.cod_ndg, r.cod_sndg
   --     SELECT 'PM' cod_src,'S' cod_stato_rischio,'Sofferenze' des_stato_rischio,
   --            p.cod_abi,
   --            substr(SYS_CONTEXT ('userenv', 'client_info'),1,6) id_dper,
   --            p.cod_ndg,
   --            r.cod_sndg,
   --            SUM (-r.val_imp_gbv_iniziale) val_gbv,
   --            SUM (-r.val_imp_nbv_iniziale) val_nbv,
   --            SUM (-r.val_imp_tot_incassi) val_tot_incassi,
   --            p.dta_chiusura dta_Fine_stato,
   --          1 flg_ndg,
   --          1 flg_chiusura
   --       FROM t_mcres_app_rapporti r,
   --            t_mcres_app_pratiche p--,
   --            --v_mcres_ultima_acq_bilancio f
   --      WHERE     p.flg_attiva = 0
   --            AND p.dta_chiusura <= f.dta_dper --per lo storico, prima non c'era!
   --            AND p.cod_abi = r.cod_abi
   --            AND p.cod_ndg = r.cod_ndg
   --            --AND P.COD_ABI = F.COD_ABI
   --            --AND p.dta_chiusura >= ADD_MONTHS (TO_DATE (F.ID_DPER, 'YYYYMMDD'), -12)
   --            AND p.dta_chiusura >= ADD_MONTHS (TO_DATE (SYS_CONTEXT ('userenv', 'client_info'), 'YYYYMMDD'), -12)
   --   GROUP BY p.cod_abi,
   --            p.cod_ndg,
   --            r.cod_sndg,
   --            p.dta_chiusura,
   --            f.val_annomese;
   UNION ALL
   SELECT 'PM' cod_src,
          'I' cod_stato_rischio,
          'Incagli' des_stato_rischio,
          p.cod_abi,
          SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6) id_dper,
          p.cod_ndg,
          p.cod_sndg,
          d.val_proposta val_gbv,
          d.val_proposta * (1 - d.val_perc_dubbio_esito / 100) val_nbv,
          NULL val_tot_incassi,
          p.dta_decorrenza_stato dta_inizio_stato,
          p.dta_fine_stato,
          1 flg_ndg,
          1 flg_chiusura
     FROM t_mcrei_app_pratiche p,
          (SELECT cod_abi,
                  cod_ndg,
                  val_anno_pratica,
                  cod_pratica,
                  val_perc_dubbio_esito,
                  NVL (val_esp_lorda, 0) + NVL (val_accordato_derivati, 0)
                     val_proposta,
                  ROW_NUMBER ()
                  OVER (
                     PARTITION BY cod_abi,
                                  cod_ndg,
                                  val_anno_pratica,
                                  cod_pratica
                     ORDER BY val_progr_proposta DESC)
                     rn
             FROM t_mcrei_app_delibere
            WHERE 0 = 0 AND cod_microtipologia_delib = 'CI') d
    WHERE     0 = 0
          AND p.cod_abi = d.cod_abi
          AND p.cod_ndg = d.cod_ndg
          AND p.val_anno_pratica = d.val_anno_pratica
          AND p.cod_pratica = d.cod_pratica
          AND p.dta_fine_stato BETWEEN ADD_MONTHS (
                                          TO_DATE (
                                             SYS_CONTEXT ('userenv',
                                                          'client_info'),
                                             'YYYYMMDD'),
                                          -12)
                                   AND TO_DATE (
                                          SYS_CONTEXT ('userenv',
                                                       'client_info'),
                                          'YYYYMMDD')
          AND d.rn = 1;
