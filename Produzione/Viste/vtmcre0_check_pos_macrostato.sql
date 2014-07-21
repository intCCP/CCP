/* Formatted on 17/06/2014 18:17:26 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_CHECK_POS_MACROSTATO
(
   MACROSTATO,
   POS_DIR,
   POS
)
AS
   SELECT dir.macro AS MACROSTATO,
          dir.posizioni AS POS_DIR,
          n.posizioni AS POS
     FROM (  SELECT b.COD_MACROSTATO AS MACRO, COUNT (*) AS POSIZIONI
               FROM MCRE_OWN.VTMCRE0_APP_HP_EXCEL a,
                    MCRE_OWN.t_mcre0_app_stati b
              WHERE     1 = 1
                    AND cod_comparto IN
                           ('011905', '006601', '011906', '004195', '011901')
                    AND a.COD_STATO = b.COD_MICROSTATO
                    AND a.FLG_OUTSOURCING = 'Y'
           --and     a.COD_PROCESSO in ('GF','GI','GR','GC','GL','GP','EG','CG')
           GROUP BY b.COD_MACROSTATO
           ORDER BY b.COD_MACROSTATO) dir,
          (  SELECT b.COD_MACROSTATO AS MACRO, COUNT (*) AS POSIZIONI
               FROM MCRE_OWN.VTMCRE0_APP_HP_EXCEL a,
                    MCRE_OWN.t_mcre0_app_stati b
              WHERE     1 = 1
                    AND a.COD_STATO = b.COD_MICROSTATO
                    AND a.FLG_OUTSOURCING = 'Y'
           GROUP BY b.COD_MACROSTATO
           ORDER BY b.COD_MACROSTATO) n
    WHERE dir.macro = n.macro(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_CHECK_POS_MACROSTATO TO MCRE_USR;
