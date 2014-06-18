/* Formatted on 17/06/2014 18:17:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_CHECK_POS_PROCESSO
(
   PROCESSO,
   POS_DIR,
   POS
)
AS
     SELECT NVL (dir.processo, NVL (n.processo, 'null')) AS PROCESSO,
            NVL (dir.posizioni, 0) AS POS_DIR,
            n.posizioni AS POS
       FROM (  SELECT a.COD_PROCESSO AS PROCESSO, COUNT (*) AS POSIZIONI
                 FROM VTMCRE0_APP_HP_EXCEL a, t_mcre0_app_stati b
                WHERE     1 = 1
                      AND cod_comparto IN
                             ('011905', '006601', '011906', '004195', '011901')
                      AND a.COD_STATO = b.COD_MICROSTATO
                      AND a.FLG_OUTSOURCING = 'Y'
             -- and     a.COD_PROCESSO in ('GF','GI','GR','GC','GL','GP','EG','CG')
             GROUP BY a.COD_PROCESSO
             ORDER BY a.COD_PROCESSO) dir,
            (  SELECT a.COD_PROCESSO AS PROCESSO, COUNT (*) AS POSIZIONI
                 FROM VTMCRE0_APP_HP_EXCEL a, t_mcre0_app_stati b
                WHERE     1 = 1
                      AND a.COD_STATO = b.COD_MICROSTATO
                      AND a.FLG_OUTSOURCING = 'Y'
             GROUP BY a.COD_PROCESSO
             ORDER BY a.COD_PROCESSO) n
      WHERE dir.processo(+) = n.processo
   ORDER BY processo;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_CHECK_POS_PROCESSO TO MCRE_USR;
