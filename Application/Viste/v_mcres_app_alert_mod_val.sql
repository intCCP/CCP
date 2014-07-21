/* Formatted on 21/07/2014 18:41:23 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_MOD_VAL
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   ALERT
)
AS
   SELECT DISTINCT 13 id_alert,
                   p.cod_abi,
                   p.cod_ndg,
                   P.COD_UO_PRATICA,
                   P.COD_MATR_PRATICA,
                   'V' ALERT
     FROM T_MCRES_APP_PRATICHE P,
          T_MCRES_APP_Posizioni z,
          T_MCRES_APP_RAPPORTI S
    WHERE     P.FLG_ATTIVA = 1
          AND z.FLG_ATTIVA = 1
          AND P.COD_ABI = S.COD_ABI
          AND P.COD_NDG = S.COD_NDG
          AND P.COD_ABI = z.COD_ABI
          AND P.COD_NDG = Z.COD_NDG
          AND S.VAL_IMP_GBV < 250000
          AND Z.DTA_PASSAGGIO_SOFF >= TRUNC (SYSDATE, 'MM')
          AND NOT EXISTS
                 (SELECT DISTINCT 1
                    FROM T_MCRES_APP_DELIBERE R
                   WHERE R.COD_ABI = p.COD_ABI AND r.COD_NDG = p.COD_NDG);
