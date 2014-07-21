/* Formatted on 21/07/2014 18:41:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_CONFERIMENTO_NT
(
   COD_ABI,
   COD_NDG
)
AS
   SELECT "COD_ABI", "COD_NDG"
     FROM (SELECT DISTINCT cod_abi, cod_ndg
             FROM t_mcres_app_posizioni n
            WHERE     N.flg_attiva = 1
                  AND INSTR ( (SELECT valore_costante
                                 FROM T_MCRES_WRK_CONFIGURAZIONE
                                WHERE nome_costante = 'ABI_CONFERIMENTO'),
                             cod_abi) > 0
           UNION ALL
           SELECT cod_abi_old cod_abi, cod_ndg_old cod_ndg
             FROM V_MCRES_APP_CONFERIMENTO_POS
            WHERE (SELECT valore_costante
                     FROM T_MCRES_WRK_CONFIGURAZIONE
                    WHERE nome_costante = 'ABI_CONFERIMENTO')
                     IS NULL)
    WHERE 1 = (SELECT valore_costante
                 FROM T_MCRES_WRK_CONFIGURAZIONE
                WHERE nome_costante = 'CONFERIMENTO');
