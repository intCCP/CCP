/* Formatted on 17/06/2014 18:04:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_CHECK_POS_ISTITUTO
(
   ABI,
   POS_DIR,
   POS
)
AS
   SELECT dir.cod_abi_cartolarizzato ABI,
          dir.posizioni_direzione POS_DIR,
          n.posizioni POS
     FROM (  SELECT a.cod_abi_cartolarizzato, COUNT (*) AS POSIZIONI_DIREZIONE
               FROM MCRE_OWN.V_MCRE0_APP_HP_EXCEL a,
                    MCRE_OWN.t_mcre0_app_stati b
              WHERE     1 = 1
                    AND a.cod_comparto IN
                           ('011905', '006601', '011906', '004195', '011901')
                    AND a.COD_STATO = b.COD_MICROSTATO
                    AND a.FLG_OUTSOURCING = 'Y'
           -- and     a.COD_PROCESSO in ('GF','GI','GR','GC','GL','GP','EG','CG')
           GROUP BY a.cod_abi_cartolarizzato
           ORDER BY a.cod_abi_cartolarizzato) dir,
          (  SELECT c.cod_abi_cartolarizzato, COUNT (*) AS POSIZIONI
               FROM MCRE_OWN.V_MCRE0_APP_HP_EXCEL c,
                    MCRE_OWN.t_mcre0_app_stati d
              WHERE     1 = 1
                    AND c.COD_STATO = d.COD_MICROSTATO
                    AND c.FLG_OUTSOURCING = 'Y'
           GROUP BY c.cod_abi_cartolarizzato
           ORDER BY c.cod_abi_cartolarizzato) n
    WHERE dir.cod_abi_cartolarizzato = n.cod_abi_cartolarizzato;


GRANT SELECT ON MCRE_OWN.V_MCRE0_CHECK_POS_ISTITUTO TO MCRE_USR;
