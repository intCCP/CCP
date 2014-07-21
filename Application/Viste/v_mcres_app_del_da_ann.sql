/* Formatted on 21/07/2014 18:41:53 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_DEL_DA_ANN
(
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT                                                --VG 20140310 created
          --- VG 20140610 Evolutive Sofferenze 5.6 annullamento delibere trasferite
          d.cod_abi, d.cod_ndg, d.cod_protocollo_delibera
     FROM t_mcres_app_pratiche p, t_mcres_app_delibere d
    WHERE     p.flg_attiva = 1
          AND p.cod_abi = d.cod_abi
          AND p.cod_ndg = d.cod_ndg
          AND p.COD_TIPO_GESTIONE = 'Z'
          AND d.cod_delibera IN ('NS', 'RV', 'AS')
          AND cod_stato_delibera IN ('IN', 'IT')
   UNION ALL
   SELECT --- VG 20140610 Evolutive Sofferenze 5.6 annullamento delibere trasferite
         d.cod_abi, d.cod_ndg, d.cod_protocollo_delibera
     FROM t_mcres_app_pratiche p, t_mcres_app_delibere d
    WHERE     p.flg_attiva = 1
          AND p.cod_abi = d.cod_abi
          AND p.cod_ndg = d.cod_ndg
          AND d.cod_stato_rischio = 'S'
          AND p.COD_UO_PRATICA != d.cod_uo
          AND SUBSTR (d.cod_protocollo_delibera, 1, 1) = 9
          AND d.cod_uo NOT IN ('02440', '06472', '04416')
          AND cod_stato_delibera IN ('IN', 'IT');
