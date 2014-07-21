/* Formatted on 17/06/2014 18:05:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_POSZ_WEB
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_STATO,
   FLG_STATO_CHK,
   FLG_OUTSOURCING,
   FLG_WEB
)
AS
   SELECT v.cod_abi_cartolarizzato,
          v.cod_ndg,
          v.cod_stato,
          s.flg_stato_chk,
          NVL (i.flg_outsourcing, 'N') flg_outsourcing,
          1 flg_web
     FROM v_mcre0_stato v, t_mcre0_app_stati s, t_mcre0_app_istituti i
    WHERE                              --  v.cod_stato NOT IN ('GB', 'RS') AND
         v    .cod_stato = s.cod_microstato
          AND s.flg_stato_chk = 1
          AND v.cod_abi_cartolarizzato = i.cod_abi
          AND NVL (i.flg_outsourcing, 'N') = 'Y';


GRANT SELECT ON MCRE_OWN.V_MCRE0_POSZ_WEB TO MCRE_USR;
