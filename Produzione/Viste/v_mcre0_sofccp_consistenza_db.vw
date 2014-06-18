/* Formatted on 17/06/2014 18:05:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_SOFCCP_CONSISTENZA_DB
(
   REC
)
AS
   SELECT ' Verifica che le posizioni a sofferenza sul portale sofferenze siano coerenti con quelle presenti sul cruscotto credito problematico'
             AS REC
     FROM DUAL
   UNION
   SELECT ' ABI;NDG' AS REC FROM DUAL
   UNION -- Verifica che le posizioni a sofferenza sul portale sofferenze siano coerenti con quelle presenti sul cruscotto credito problematico
   SELECT '''' || b.cod_abi || ';''' || b.cod_ndg AS REC
     FROM T_MCRES_APP_POSIZIONI b
    WHERE b.COD_STATO_RISCHIO = 'S' AND flg_attiva = 1
   MINUS
   SELECT '''' || a.cod_abi_cartolarizzato || ';''' || a.cod_ndg
     FROM T_MCRE0_APP_ALL_DATA a
    WHERE a.TODAY_FLG = '1' AND a.COD_STATO = 'SO';


GRANT SELECT ON MCRE_OWN.V_MCRE0_SOFCCP_CONSISTENZA_DB TO MCRE_USR;
