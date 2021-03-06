/* Formatted on 17/06/2014 18:04:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_CCPSOFF_CONSISTENZA_DB
(
   REC
)
AS
   SELECT ' Verifica che le posizioni a sofferenza sul cruscotto credito problematico siano coerenti con quelle presenti sul portale sofferenze'
             AS REC
     FROM DUAL
   UNION
   SELECT ' ABI;NDG' AS REC FROM DUAL
   UNION -- Verifica che le posizioni a sofferenza sul cruscotto credito problematico siano coerenti con quelle presenti sul portale sofferenze
   SELECT a.cod_abi_cartolarizzato || ';' || a.cod_ndg AS REC
     FROM T_MCRE0_APP_ALL_DATA a
    WHERE a.TODAY_FLG = '1' AND a.COD_STATO = 'SO'
   MINUS
   SELECT b.cod_abi || ';' || b.cod_ndg
     FROM T_MCRES_APP_POSIZIONI b
    WHERE b.COD_STATO_RISCHIO = 'S' AND flg_attiva = 1;


GRANT SELECT ON MCRE_OWN.V_MCRE0_CCPSOFF_CONSISTENZA_DB TO MCRE_USR;
