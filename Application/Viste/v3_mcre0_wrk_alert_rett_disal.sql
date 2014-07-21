/* Formatted on 21/07/2014 18:44:53 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V3_MCRE0_WRK_ALERT_RETT_DISAL
(
   VAL_ALERT,
   COD_SNDG,
   COD_ABI,
   COD_NDG,
   COD_STATO,
   COD_PROTOCOLLO_DELIBERA,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI
)
AS
   SELECT DISTINCT 'R' VAL_ALERT, -- VERDE 1 MESE SE SONO STATE RIVISTE E CONFERMATE LE VALUTAZIONI, ROSSO 1 MESE SE LE VALUTAZIONI NON SONO STATE RIVISTE E CONFERMATE
                   B.COD_SNDG,
                   B.COD_ABI,
                   B.COD_NDG,
                   AD.COD_STATO,
                   B.COD_PROTOCOLLO_DELIBERA,
                   1 VAL_CNT_DELIBERE,
                   1 VAL_CNT_RAPPORTI
     FROM (SELECT DISTINCT
                  S1.COD_ABI,
                  S1.COD_SNDG,
                  S1.COD_NDG,
                  S1.DTA_STIMA,
                  S1.FLG_TIPO_DATO,
                  S1.COD_PROTOCOLLO_DELIBERA,
                  S1.COD_CLASSE_FT,
                  SUM (
                     DECODE (COD_CLASSE_FT,
                             'CA', VAL_RDV_TOT,
                             TO_CHAR (NULL), VAL_RDV_TOT,
                             0))
                  OVER (
                     PARTITION BY S1.COD_ABI,
                                  S1.COD_NDG,
                                  S1.COD_PROTOCOLLO_DELIBERA)
                     RDV_STIME_CA,
                  SUM (
                     DECODE (COD_CLASSE_FT, 'FI', VAL_RDV_TOT, 0))
                  OVER (
                     PARTITION BY S1.COD_ABI,
                                  S1.COD_NDG,
                                  S1.COD_PROTOCOLLO_DELIBERA)
                     RDV_STIME_FI,
                  MAX (DTA_STIMA) OVER (PARTITION BY S1.COD_ABI, S1.COD_NDG)
                     AS MAX_STIMA
             FROM T_MCREI_APP_STIME PARTITION (INC_PATTIVE) S1,
                  T_MCREI_APP_DELIBERE D
            WHERE     S1.COD_ABI = D.COD_ABI  -- V_MCRE0_WRK_ALERT_RAPP_DA_VAL
                  AND S1.COD_NDG = D.COD_NDG
                  AND S1.COD_PROTOCOLLO_DELIBERA = D.COD_PROTOCOLLO_DELIBERA
                  AND D.COD_TIPO_PACCHETTO = 'M'
                  AND D.COD_FASE_DELIBERA = 'CO'
                  AND D.FLG_ATTIVA = '1'
                  AND D.FLG_NO_DELIBERA = 0
                  AND D.COD_MICROTIPOLOGIA_DELIB IN ('A0', 'T4', 'RV', 'IM')) S,
          (SELECT DISTINCT
                  S1.COD_ABI,
                  S1.COD_SNDG,
                  S1.COD_NDG,
                  S1.DTA_STIMA,
                  S1.FLG_TIPO_DATO,
                  S1.COD_PROTOCOLLO_DELIBERA,
                  S1.COD_CLASSE_FT,
                  SUM (
                     DECODE (COD_CLASSE_FT,
                             'CA', VAL_RDV_TOT,
                             TO_CHAR (NULL), VAL_RDV_TOT,
                             0))
                  OVER (
                     PARTITION BY S1.COD_ABI,
                                  S1.COD_NDG,
                                  S1.COD_PROTOCOLLO_DELIBERA)
                     RDV_STIME_BATCH_CA,
                  SUM (
                     DECODE (COD_CLASSE_FT, 'FI', VAL_RDV_TOT, 0))
                  OVER (
                     PARTITION BY S1.COD_ABI,
                                  S1.COD_NDG,
                                  S1.COD_PROTOCOLLO_DELIBERA)
                     RDV_STIME_BATCH_FI,
                  MAX (DTA_STIMA) OVER (PARTITION BY S1.COD_ABI, S1.COD_NDG)
                     AS MAX_STIMA_BATCH
             FROM T_MCREI_APP_STIME_BATCH S1, T_MCREI_APP_DELIBERE D
            WHERE     S1.COD_ABI = D.COD_ABI  -- V_MCRE0_WRK_ALERT_RAPP_DA_VAL
                  AND S1.COD_NDG = D.COD_NDG
                  AND S1.COD_PROTOCOLLO_DELIBERA = D.COD_PROTOCOLLO_DELIBERA
                  AND D.COD_TIPO_PACCHETTO = 'M'
                  AND D.COD_FASE_DELIBERA = 'CO'
                  AND D.FLG_ATTIVA = '1'
                  AND D.FLG_NO_DELIBERA = 0
                  AND D.COD_MICROTIPOLOGIA_DELIB IN ('A0', 'T4', 'RV', 'IM')) B,
          V_MCRE0_APP_UPD_FIELDS AD
    WHERE     AD.COD_ABI_CARTOLARIZZATO = S.COD_ABI
          AND AD.COD_NDG = S.COD_NDG
          AND AD.FLG_TARGET = 'Y'
          AND AD.FLG_OUTSOURCING = 'Y'
          AND AD.COD_STATO IN ('IN', 'RS')
          AND S.COD_ABI = B.COD_ABI
          AND S.COD_NDG = B.COD_NDG
          AND S.FLG_TIPO_DATO = B.FLG_TIPO_DATO
          AND S.COD_PROTOCOLLO_DELIBERA = B.COD_PROTOCOLLO_DELIBERA
          AND S.DTA_STIMA = S.MAX_STIMA
          AND B.DTA_STIMA = B.MAX_STIMA_BATCH
          --AND S.COD_CLASSE_FT = B.COD_CLASSE_FT
          AND B.MAX_STIMA_BATCH >= S.MAX_STIMA
          AND (   S.RDV_STIME_CA <> B.RDV_STIME_BATCH_CA
               OR S.RDV_STIME_FI <> B.RDV_STIME_BATCH_FI);
