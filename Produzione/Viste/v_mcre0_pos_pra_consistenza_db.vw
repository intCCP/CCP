/* Formatted on 17/06/2014 18:05:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_POS_PRA_CONSISTENZA_DB
(
   REC
)
AS
   SELECT ' Posizioni attive delle pratiche chiuse' AS REC FROM DUAL
   UNION
   SELECT ' ABI;NDG;DATA_PASSAGGIO_SOFFERENZA;STATO_RISCHIO;POSIZIONE_ATTIVA;DATA_FINE_STATO;ANNO;COD_PRATICA;PRATICA_ATTIVA'
             AS REC
     FROM DUAL
   UNION
   SELECT    b.COD_ABI
          || ';'
          || b.COD_NDG
          || ';'
          || b.DTA_PASSAGGIO_SOFF
          || ';'
          || b.COD_STATO_RISCHIO
          || ';'
          || b.FLG_ATTIVA
          || ';'
          || b.DTA_CHIUSURA
          || ';'
          || a.VAL_ANNO
          || ';'
          || a.COD_PRATICA
          || ';'
          || a.FLG_ATTIVA
             AS REC
     FROM MCRE_OWN.T_MCRES_APP_PRATICHE a, T_MCRES_APP_POSIZIONI b
    WHERE     a.COD_ABI = b.cod_abi
          AND a.cod_ndg = b.cod_ndg
          AND a.flg_attiva = 0                              -- pratiche chiuse
          AND b.flg_attiva = 1                             -- posizioni attive
          AND b.cod_stato_rischio = 'S'
          AND NOT EXISTS
                     (SELECT 1
                        FROM MCRE_OWN.T_MCRES_APP_PRATICHE c
                       WHERE     a.COD_ABI = c.cod_abi
                             AND a.cod_ndg = c.cod_ndg
                             AND c.flg_attiva = 1);


GRANT SELECT ON MCRE_OWN.V_MCRE0_POS_PRA_CONSISTENZA_DB TO MCRE_USR;
