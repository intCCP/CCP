/* Formatted on 21/07/2014 18:37:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_POS_RAP_CONSISTENZA_DB
(
   REC
)
AS
   SELECT ' Posizioni chiuse  che presentano rapporti aperti ' AS REC
     FROM DUAL
   UNION
   SELECT ' ABI;NDG;DATA_PASSAGGIO_SOFFERENZA;STATO_RISCHIO;POSIZIONE_ATTIVA;DATA_CHIUSURA;COD_RAPPORTO;DATA_APERTURA_RAPPORTO;DATA_CHIUSURA_RAPPORTO'
             AS REC
     FROM DUAL
   UNION                               -- posizioni chiuse con rapporti aperti
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
          || a.cod_rapporto
          || ';'
          || a.DTA_APERTURA_RAPP
          || ';'
          || a.DTA_CHIUSURA_RAPP
             AS REC
     FROM T_MCRES_APP_POSIZIONI b, T_MCRES_APP_RAPPORTI a
    WHERE     a.COD_ABI = b.cod_abi
          AND a.cod_ndg = b.cod_ndg
          AND b.flg_attiva = 0                             -- posizioni chiuse
          AND TRUNC (a.DTA_CHIUSURA_RAPP) > TRUNC (SYSDATE)
          AND b.cod_stato_rischio = 'S'
          AND NOT EXISTS
                     (SELECT 1
                        FROM MCRE_OWN.T_MCRES_APP_POSIZIONI c
                       WHERE     b.COD_ABI = c.cod_abi
                             AND b.cod_ndg = c.cod_ndg
                             AND c.flg_attiva = 1);
