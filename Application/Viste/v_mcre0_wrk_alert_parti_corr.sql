/* Formatted on 21/07/2014 18:38:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_PARTI_CORR
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   VAL_ALERT,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI,
   DTA_INS,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT DISTINCT c.cod_abi AS COD_ABI,
                   C.COD_NDG,
                   c.COD_SNDG_GRUPPO AS COD_SNDG,
                   D.COD_STATO,
                   'R' AS VAL_ALERT,
                   1 AS VAL_CNT_DELIBERE,
                   1 AS VAL_CNT_RAPPORTI,
                   D.DTA_INS AS DTA_INS,
                   NULL AS COD_PROTOCOLLO_DELIBERA
     FROM T_MCREI_APP_PARTI_CORRELATE C,
          T_MCREI_APP_ALERT_FLG_PR_VIS V,
          V_MCRE0_APP_UPD_FIELDS D
    WHERE     C.COD_ABI = D.COD_ABI_CARTOLARIZZATO
          AND C.COD_ABI = V.COD_ABI(+)
          AND C.COD_NDG = V.COD_NDG(+)
          --escludo presavisione
          AND C.DTA_INS >
                 NVL (V.DTA_PR_VIS, TO_DATE ('01011900', 'ddmmyyyy'))
          AND c.COD_NDG = D.COD_NDG
          AND D.COD_STATO IN ('IN', 'RS', 'SO');
