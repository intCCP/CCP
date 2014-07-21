/* Formatted on 17/06/2014 18:05:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_POS_PD_CONSISTENZA_DB
(
   REC
)
AS
   SELECT ' Elenco delle posizioni che hanno più di una delibera di sofferenza'
             AS rec
     FROM DUAL
   UNION
   SELECT ' ABI;NDG;QUANTI' AS REC FROM DUAL -- Elenco delle posizioni che hanno più di una delibera di sofferenza
   UNION
     SELECT a.COD_ABI || ';' || a.COD_NDG || ';' || COUNT (*) AS REC
       FROM T_MCRES_APP_PRATICHE a, MCRE_OWN.T_MCRES_APP_DELIBERE b
      WHERE     a.cod_abi = b.cod_abi
            AND a.cod_ndg = b.cod_ndg
            AND a.flg_attiva = 1                                    --  attive
            AND B.COD_DELIBERA IN ('NS', 'NZ')
            AND B.cod_stato_delibera = 'CO'
            AND a.cod_pratica = b.cod_pratica
            AND a.val_anno = B.VAL_ANNO_PRATICA
   GROUP BY a.cod_abi, a.cod_ndg
     HAVING COUNT (*) > 1
   UNION
     SELECT a.COD_ABI || ';' || a.COD_NDG || ';' || COUNT (*) AS REC
       FROM T_MCRES_APP_PRATICHE a, MCRE_OWN.T_MCRES_APP_DELIBERE b
      WHERE     a.cod_abi = b.cod_abi
            AND a.cod_ndg = b.cod_ndg
            AND a.flg_attiva = 1                                    --  attive
            AND B.COD_DELIBERA IN ('IS')
            AND B.cod_stato_delibera = 'CO'
            AND a.cod_pratica = b.cod_pratica
            AND a.val_anno = B.VAL_ANNO_PRATICA
   GROUP BY a.cod_abi, a.cod_ndg
     HAVING COUNT (*) > 1;


GRANT SELECT ON MCRE_OWN.V_MCRE0_POS_PD_CONSISTENZA_DB TO MCRE_USR;
