/* Formatted on 21/07/2014 18:36:39 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_CHECK_POS_STATO
(
   STATO,
   POS_DIR,
   POS
)
AS
   SELECT dir.cod_stato STATO, dir.posizioni AS POS_DIR, n.posizioni AS POS
     FROM (  SELECT a.COD_STATO AS COD_STATO, COUNT (*) AS POSIZIONI
               FROM V_MCRE0_APP_HP_EXCEL a, t_mcre0_app_stati b
              WHERE     1 = 1
                    AND cod_comparto IN
                           ('011905', '006601', '011906', '004195', '011901')
                    AND a.COD_STATO = b.COD_MICROSTATO
                    AND a.FLG_OUTSOURCING = 'Y'
           -- and     a.COD_PROCESSO in ('GF','GI','GR','GC','GL','GP','EG','CG')
           GROUP BY a.COD_STATO
           ORDER BY a.COD_STATO) dir,
          (  SELECT a.COD_STATO AS COD_STATO, COUNT (*) AS POSIZIONI
               FROM V_MCRE0_APP_HP_EXCEL a, t_mcre0_app_stati b
              WHERE     1 = 1
                    AND a.COD_STATO = b.COD_MICROSTATO
                    AND a.FLG_OUTSOURCING = 'Y'
           GROUP BY a.COD_STATO
           ORDER BY a.COD_STATO) n
    WHERE dir.cod_stato = n.cod_stato;
