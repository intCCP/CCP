/* Formatted on 17/06/2014 18:05:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_POS_PL_CONSISTENZA_DB
(
   REC
)
AS
   SELECT ' Elenco delle posizioni che hanno più di una pratica legale'
             AS REC
     FROM DUAL
   UNION
   SELECT ' ABI;NDG;QUANTI' AS REC FROM DUAL -- Elenco delle posizioni che hanno più di una pratica legale
   UNION
     SELECT a.COD_ABI || ';' || a.COD_NDG || ';' || COUNT (*) AS REC
       FROM MCRE_OWN.T_MCRES_APP_PRATICHE a, T_MCRES_APP_POSIZIONI b
      WHERE     a.COD_ABI = b.cod_abi
            AND a.cod_ndg = b.cod_ndg
            AND a.flg_attiva = 1                            -- pratiche chiuse
            AND b.flg_attiva = 1                           -- posizioni attive
   GROUP BY a.cod_abi, a.cod_ndg
     HAVING COUNT (*) > 1;


GRANT SELECT ON MCRE_OWN.V_MCRE0_POS_PL_CONSISTENZA_DB TO MCRE_USR;
