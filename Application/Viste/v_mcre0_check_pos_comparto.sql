/* Formatted on 21/07/2014 18:36:35 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_CHECK_POS_COMPARTO
(
   COMPARTO,
   POS
)
AS
     SELECT NVL (a.COD_COMPARTO, 'N.D.') AS COMPARTO, COUNT (*) AS POS
       FROM V_MCRE0_APP_HP_EXCEL a, t_mcre0_app_stati b, t_mcre0_app_comparti c
      WHERE     1 = 1
            AND a.cod_comparto = c.cod_comparto(+)
            AND c.flg_chk = 1
            AND c.flg_comparti_filtro = 1
            AND a.COD_STATO = b.COD_MICROSTATO
            AND a.FLG_OUTSOURCING = 'Y'
   GROUP BY a.COD_COMPARTO;
