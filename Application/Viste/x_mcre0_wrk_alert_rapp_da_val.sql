/* Formatted on 21/07/2014 18:46:55 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.X_MCRE0_WRK_ALERT_RAPP_DA_VAL
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   VAL_ALERT,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI,
   DTA_INS
)
AS
   SELECT DISTINCT
          DE.cod_abi,
          DE.cod_ndg,
          d.cod_sndg,
          d.cod_stato,
          'R' val_alert,
          1 VAL_CNT_DELIBERE,
          COUNT (DISTINCT P.COD_RAPPORTO)
             OVER (PARTITION BY p.COD_ABI, p.COD_NDG)
             AS val_cnt_rapporti,
          SYSDATE DTA_INS
     FROM t_mcrei_app_pcr_rapporti p,
          t_mcre0_app_all_data PARTITION (CCP_P1) d,
          t_mcrei_app_delibere PARTITION (INC_PATTIVE) DE
    --                      t_mcrei_APP_STIME PARTITION
    WHERE     cod_classe_ft IN ('CA', 'FI')
          AND val_imp_utilizzato > 0
          AND P.flg_attiva = '1'
          AND P.COD_ABI = DE.COD_ABI
          AND P.COD_NDG = DE.COD_NDG
          AND EXISTS
                 (SELECT 1
                    FROM t_mcrei_app_stime s
                   WHERE     flg_attiva = '1'
                         AND s.cod_abi = p.cod_abi
                         AND s.cod_ndg = p.cod_ndg)
          AND NOT EXISTS
                     (SELECT cod_rapporto
                        FROM t_mcrei_app_stime s
                       WHERE     flg_attiva = '1'
                             AND s.cod_abi = p.cod_abi
                             AND S.cod_ndg = p.cod_ndg
                             AND s.cod_rapporto = p.cod_rapporto)
          AND p.cod_abi = d.cod_abi_cartolarizzato
          AND p.cod_ndg = d.cod_ndg
          AND d.today_flg = 1
          AND p.flg_attiva = '1'
          AND d.cod_stato IN ('IN', 'RS')
          AND D.FLG_OUTSOURCING = 'Y'
          AND D.FLG_TARGET = 'Y';
