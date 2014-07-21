/* Formatted on 17/06/2014 18:10:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_DEL_DA_ANN
(
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT                                                --VG 20140310 created
         d.cod_abi, d.cod_ndg, d.cod_protocollo_delibera
     FROM t_mcres_app_pratiche p, t_mcres_app_delibere d
    WHERE     p.flg_attiva = 1
          AND p.cod_abi = d.cod_abi
          AND p.cod_ndg = d.cod_ndg
          AND p.COD_TIPO_GESTIONE = 'Z'
          AND d.cod_delibera IN ('NS', 'RV', 'AS')
          AND cod_stato_delibera IN ('IN', 'IT');


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_DEL_DA_ANN TO MCRE_USR;
