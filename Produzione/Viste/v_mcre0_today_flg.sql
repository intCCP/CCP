/* Formatted on 17/06/2014 18:06:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_TODAY_FLG
(
   TODAY_FLG,
   COD_NDG,
   COD_ABI_CARTOLARIZZATO
)
AS
   SELECT '1' today_flg, u.cod_ndg, u.cod_abi_cartolarizzato
     FROM t_mcre0_day_mopl u
   UNION ALL
   SELECT '1' today_flg, u.cod_ndg, u.cod_abi_cartolarizzato
     FROM t_mcre0_all_data d, t_mcre0_day_fg u
    WHERE     u.cod_ndg = d.cod_ndg
          AND u.cod_abi_cartolarizzato = d.cod_abi_cartolarizzato
          AND today_flg = '1'
          AND NOT EXISTS
                     (SELECT 1
                        FROM t_mcre0_day_mopl m
                       WHERE     m.cod_ndg = d.cod_ndg
                             AND m.cod_abi_cartolarizzato =
                                    d.cod_abi_cartolarizzato);


GRANT SELECT ON MCRE_OWN.V_MCRE0_TODAY_FLG TO MCRE_USR;
