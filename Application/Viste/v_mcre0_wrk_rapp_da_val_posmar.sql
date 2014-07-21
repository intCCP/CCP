/* Formatted on 21/07/2014 18:38:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_RAPP_DA_VAL_POSMAR
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
     SELECT r.cod_stato,
            r.cod_abi,
            r.cod_ndg,
            r.cod_sndg,
            r.cod_protocollo_delibera,
            COUNT (DISTINCT rapp_pcr) val_cnt_rapporti,
            'R' AS val_alert,
            1 AS val_cnt_delibere,
            1 AS flg_acc
       FROM (SELECT d.*, p.cod_rapporto rapp_pcr, a.cod_stato
               FROM (SELECT /*+   INDEX(pcr IX_MCREI_APP_RAPPORTI_ESTERO) INDEX(re IX_MCREI_APP_RAPPORTI_ESTERO) */
                           d.cod_abi,
                            d.cod_ndg,
                            d.cod_sndg,
                            d.cod_protocollo_delibera,
                            d.dta_conferma_delibera,
                            s1.cod_rapporto,
                            MAX (d.dta_conferma_delibera)
                               OVER (PARTITION BY d.cod_abi, d.cod_ndg)
                               mdata
                       FROM t_mcrei_app_delibere PARTITION (inc_pattive) d,
                            t_mcrei_app_stime PARTITION (inc_pattive) s1,
                            t_mcrei_app_pcr_rapporti pcr,
                            t_mcrei_app_rapporti_estero re
                      --  v_mcre0_app_upd_fields_p1 uf
                      WHERE     pcr.cod_abi = d.cod_abi
                            AND pcr.cod_ndg = d.cod_ndg
                            AND d.cod_abi = s1.cod_abi
                            AND d.cod_ndg = s1.cod_ndg
                            AND d.cod_protocollo_delibera =
                                   s1.cod_protocollo_delibera
                            AND pcr.cod_abi = s1.cod_abi
                            AND pcr.cod_ndg = s1.cod_ndg
                            AND pcr.cod_rapporto = s1.cod_rapporto
                            AND pcr.cod_abi = re.cod_abi(+)
                            AND pcr.cod_ndg = re.cod_ndg(+)
                            AND pcr.cod_rapporto = re.cod_rapporto_estero(+)
                            AND re.cod_rapporto_estero IS NULL
                            --and s1.cod_rapporto is null
                            AND d.cod_fase_delibera = 'CO'
                            AND d.flg_no_delibera = 0
                            AND d.flg_attiva = '1'
                            AND d.cod_microtipologia_delib IN
                                   ('A0', 'T4', 'RV', 'IM')) d,
                    t_mcre0_app_all_data a,
                    t_mcrei_app_pcr_rapporti p
              WHERE     dta_conferma_delibera = mdata
                    AND p.cod_abi = d.cod_abi(+)
                    AND p.cod_ndg = d.cod_ndg(+)
                    AND p.cod_rapporto != d.cod_rapporto(+)
                    --and d.cod_rapporto is null
                    AND p.cod_abi = a.cod_abi_cartolarizzato
                    AND p.cod_ndg = a.cod_ndg
                    AND a.flg_target = 'Y'
                    AND a.flg_outsourcing = 'Y'
                    AND a.cod_stato IN ('IN', 'RS')
                    AND a.today_flg = '1') r
   GROUP BY r.cod_stato,
            r.cod_abi,
            r.cod_ndg,
            r.cod_sndg,
            r.cod_protocollo_delibera;
