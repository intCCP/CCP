/* Formatted on 21/07/2014 18:41:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_NEWSOFFDAASS
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   COD_UO_PRATICA,
   DTA_PASSAGGIO_SOFF,
   ALERT
)
AS
   SELECT 5 id_alert,
          p.cod_abi,
          p.cod_ndg,
          P.COD_UO_PRATICA,
          Z.DTA_PASSAGGIO_SOFF,
          CASE
             WHEN ( (TRUNC (SYSDATE) - Z.DTA_PASSAGGIO_SOFF) BETWEEN 0 AND 7)
             THEN
                'V'
             WHEN ( (TRUNC (SYSDATE) - Z.DTA_PASSAGGIO_SOFF) BETWEEN 8 AND 30)
             THEN
                'A'
             WHEN ( (TRUNC (SYSDATE) - Z.DTA_PASSAGGIO_SOFF) > 30)
             THEN
                'R'
             ELSE
                NULL
          END
             ALERT
     FROM T_MCRES_APP_PRATICHE P, T_MCRES_APP_Posizioni z
    WHERE     P.FLG_ATTIVA = 1
          AND Z.FLG_ATTIVA = 1
          AND P.COD_ABI = Z.COD_ABI
          AND P.COD_NDG = Z.COD_NDG
          AND P.COD_MATR_PRATICA IS NULL;
