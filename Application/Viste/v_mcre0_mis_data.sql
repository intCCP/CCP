/* Formatted on 21/07/2014 18:37:11 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_MIS_DATA
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_SUPER,
   FLG_BLOCCO_ABI,
   FLG_BLOCCO_SNDG,
   FLG_BLOCCO_GRUPPO
)
AS
   SELECT f.cod_abi_istituto,
          f.cod_abi_cartolarizzato,
          f.cod_ndg,
          f.cod_sndg,
          f.cod_gruppo_super,
          flg_blocco_abi,
          flg_blocco_sndg,
          flg_blocco_gruppo
     FROM v_mcre0_pos_mancanti f
   UNION ALL
   SELECT DISTINCT
          cod_abi_istituto,
          f.cod_abi_cartolarizzato,
          f.cod_ndg,
          f.cod_sndg,
          f.cod_gruppo_super,
          '0' flg_blocco_abi,
          MAX (NVL (flg_blocco_sndg, 0))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             flg_blocco_sndg,
          MAX (NVL (flg_blocco_gruppo, 0))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             flg_blocco_gruppo
     FROM (SELECT f.cod_abi_istituto,
                  f.cod_abi_cartolarizzato,
                  f.cod_ndg,
                  f.cod_sndg,
                  f.cod_gruppo_super,
                  '1' flg_blocco_sndg,
                  NULL flg_blocco_gruppo
             FROM t_mcre0_web_data f, v_mcre0_pos_mancanti m
            WHERE     f.flg_active = '1'
                  AND m.cod_sndg = f.cod_sndg
                  AND NOT EXISTS
                             (SELECT 1
                                FROM v_mcre0_pos_mancanti x
                               WHERE     x.cod_abi_cartolarizzato =
                                            f.cod_abi_cartolarizzato
                                     AND x.cod_ndg = f.cod_ndg)
           UNION ALL
           SELECT f.cod_abi_istituto,
                  f.cod_abi_cartolarizzato,
                  f.cod_ndg,
                  f.cod_sndg,
                  f.cod_gruppo_super,
                  NULL flg_blocco_sndg,
                  '1' flg_blocco_gruppo
             FROM t_mcre0_web_data f, v_mcre0_pos_mancanti m
            WHERE     f.flg_active = '1'
                  AND m.cod_gruppo_super = f.cod_gruppo_super
                  AND NOT EXISTS
                             (SELECT 1
                                FROM v_mcre0_pos_mancanti x
                               WHERE     x.cod_abi_cartolarizzato =
                                            f.cod_abi_cartolarizzato
                                     AND x.cod_ndg = f.cod_ndg)) f;
