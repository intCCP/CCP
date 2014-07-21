/* Formatted on 21/07/2014 18:38:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_RAPP_DA_VAL_POS_BK
(
   COD_STATO,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA,
   VAL_CNT_RAPPORTI,
   VAL_ALERT,
   VAL_CNT_DELIBERE,
   FLG_ACC
)
AS
   SELECT cod_stato,
          concs.cod_abi,
          concs.cod_ndg,
          concs.cod_sndg,
          cod_protocollo_delibera,
          val_cnt_rapporti,
          'R' AS val_alert,
          1 AS val_cnt_delibere,
          1 AS flg_acc                  --DECODE (concs, TO_CHAR (NULL), 0, 1)
     FROM (SELECT DISTINCT -- 04.10.2012 V3 - AGGIUNTA EXISTS SULLE STIME, DA OTTIMIZZARE SE POSSIBILE
                  -- 04.10.2012 V4 - RICOSTRUITA LOGICA CON JOIN SENZA T_MCRE0_APP_ALL_DATA, COD_STATO S SEMPRE A NULL
                  -- 12.10.2012 V4.1 - AGGIUNTE STIME EXTRA
                  -- 15.10.2012  V.4.2 TOLTE STIME EXTRA -- LA PAGINA DI EXTRA DELIBERA NON COMPORTA LA SCRITTURA NELLA STIME EXTRA
                  --21.03.2013 v5 max dta-delibera per conteggio rapporti senza rownum
                  pr.cod_abi,
                  pr.cod_ndg,
                  pr.cod_sndg,
                  pr.cod_protocollo_delibera,
                  COUNT (pr.cod_rapporto)
                     OVER (PARTITION BY pr.cod_abi, pr.cod_ndg)
                     val_cnt_rapporti
             --  cod_stato
             FROM (SELECT ppcr.cod_abi,
                          ppcr.cod_ndg,
                          ppcr.cod_sndg,
                          ppcr.cod_rapporto,
                          ppcr.cod_protocollo_delibera
                     --  ppcr.cod_stato
                     FROM (SELECT DISTINCT                     --uf.cod_stato,
                                  pcr.cod_abi,
                                  pcr.cod_ndg,
                                  pcr.cod_sndg,
                                  pcr.cod_rapporto,
                                  d.cod_protocollo_delibera,
                                  d.dta_conferma_delibera,
                                  MAX (d.dta_conferma_delibera)
                                     OVER (PARTITION BY d.cod_abi, d.cod_ndg)
                                     mdata,
                                  SUM (
                                     pcr.val_imp_utilizzato)
                                  OVER (
                                     PARTITION BY pcr.cod_abi,
                                                  pcr.cod_ndg,
                                                  d.cod_protocollo_delibera)
                                     val_imp_utilizzato
                             FROM t_mcrei_app_rapporti_estero re,
                                  t_mcrei_app_pcr_rapporti pcr,
                                  t_mcrei_app_delibere
                                  PARTITION (inc_pattive) d,
                                  t_mcrei_app_stime
                                  PARTITION (inc_pattive) s1               --,
                            --  v_mcre0_app_upd_fields_p1 uf
                            WHERE     pcr.cod_abi = d.cod_abi
                                  AND pcr.cod_ndg = d.cod_ndg
                                  AND d.cod_abi = s1.cod_abi
                                  AND d.cod_ndg = s1.cod_ndg
                                  AND pcr.cod_abi = s1.cod_abi
                                  AND pcr.cod_ndg = s1.cod_ndg
                                  AND d.cod_protocollo_delibera =
                                         s1.cod_protocollo_delibera
                                  AND pcr.cod_abi = re.cod_abi(+)
                                  AND pcr.cod_ndg = re.cod_ndg(+)
                                  AND pcr.cod_rapporto =
                                         re.cod_rapporto_estero(+)
                                  AND re.cod_rapporto_estero IS NULL
                                  AND d.cod_fase_delibera = 'CO'
                                  AND d.flg_no_delibera = 0
                                  AND d.flg_attiva = '1'
                                  AND d.cod_microtipologia_delib IN
                                         ('A0', 'T4', 'RV', 'IM') --                                                                     and     flg_target = 'Y'
                                                                 --                        AND flg_outsourcing = 'Y'
                                                                 --                        AND uf.cod_stato IN ('IN', 'RS')
                          ) ppcr
                    WHERE     ppcr.val_imp_utilizzato > 0
                          AND mdata = ppcr.dta_conferma_delibera) pr,
                  --- (2) PCR A MENO DI RAPPORTI ESTERI E POS
                  (SELECT s3.cod_abi,
                          s3.cod_ndg,
                          s3.cod_rapporto,
                          s3.dta_stima
                     FROM (SELECT s2.cod_abi,
                                  s2.cod_ndg,
                                  s2.cod_rapporto,
                                  s2.max_dta
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_rapporto,
                                          MAX (
                                             s11.dta_stima)
                                          OVER (
                                             PARTITION BY s11.cod_abi,
                                                          s11.cod_ndg)
                                             AS max_dta
                                     FROM t_mcrei_app_stime s11) s2) max_st2,
                          ---- (2.1) STIME E STIME EXTRA CON MAX_DTA
                          t_mcrei_app_stime s3
                    ---- (2.1) STIME E STIME EXTRA
                    WHERE     max_st2.cod_abi = s3.cod_abi
                          AND max_st2.cod_ndg = s3.cod_ndg
                          AND max_st2.cod_rapporto = s3.cod_rapporto
                          AND max_st2.max_dta = s3.dta_stima) s2
            --- (2) STIME LIVELLO RAPPORTO INSIEMI CON MAX_DTA_STIMA
            WHERE     pr.cod_abi = s2.cod_abi(+)
                  AND pr.cod_ndg = s2.cod_ndg(+)
                  AND pr.cod_rapporto = s2.cod_rapporto(+)
                  AND s2.cod_rapporto IS NULL --               AND pr.cod_abi = uf.cod_abi_cartolarizzato
                                             --               AND pr.cod_ndg = uf.cod_ndg
                                             --               AND ROWNUM = 1 --aggiunta distinct
          ) concs,
          v_mcre0_app_upd_fields_p1 uf
    WHERE     uf.flg_target = 'Y'
          AND uf.flg_outsourcing = 'Y'
          AND uf.cod_stato IN ('IN', 'RS')
          AND concs.cod_abi = uf.cod_abi_cartolarizzato
          AND concs.cod_ndg = uf.cod_ndg;
