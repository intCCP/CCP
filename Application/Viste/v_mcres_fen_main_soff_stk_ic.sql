/* Formatted on 21/07/2014 18:43:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MAIN_SOFF_STK_IC
(
   COD_ABI,
   VAL_ANNOMESE,
   COD_NDG,
   COD_SNDG,
   VAL_GBV,
   VAL_NBV,
   DTA_DECORRENZA_STATO,
   FLG_DA_CONTABILIZZARE,
   RN_IDC,
   RN_STK
)
AS
   SELECT COD_ABI,
          VAL_ANNOMESE,
          COD_NDG,
          COD_SNDG,
          VAL_GBV,
          VAL_NBV,
          DTA_DECORRENZA_STATO,
          FLG_DA_CONTABILIZZARE,
          RN_IDC,
          RN_STK
     FROM (SELECT A.*,
                  ROW_NUMBER ()
                  OVER (
                     PARTITION BY COD_ABI,
                                  VAL_ANNOMESE,
                                  FLG_DA_CONTABILIZZARE
                     ORDER BY VAL_GBV DESC)
                     RN_IDC,
                  ROW_NUMBER ()
                  OVER (PARTITION BY COD_ABI, VAL_ANNOMESE
                        ORDER BY VAL_GBV DESC)
                     RN_STK
             FROM (  SELECT CP.COD_ABI,
                            TO_CHAR (CP.DTA_SISBA_CP, 'YYYYMM') VAL_ANNOMESE,
                            CP.COD_NDG,
                            CP.COD_SNDG,
                            SUM (CP.VAL_UTI_RET) VAL_GBV,
                            SUM (CP.VAL_ATT) VAL_NBV,
                            MIN (CP.DTA_DECORRENZA_STATO) DTA_DECORRENZA_STATO,
                            CASE
                               WHEN MIN (CP.DTA_DECORRENZA_STATO) BETWEEN TO_DATE (
                                                                                TO_CHAR (
                                                                                   DTA_SISBA_CP,
                                                                                   'YYYY')
                                                                             || '0101',
                                                                             'YYYYMMDD')
                                                                      AND DTA_SISBA_CP
                               THEN
                                  1
                               ELSE
                                  0
                            END
                               FLG_DA_CONTABILIZZARE
                       FROM T_MCRES_APP_SISBA_CP CP
                      WHERE CP.VAL_FIRMA != 'FIRMA' AND COD_STATO_RISCHIO = 'S'
                   GROUP BY CP.COD_ABI,
                            CP.COD_NDG,
                            CP.COD_SNDG,
                            CP.DTA_SISBA_CP) A)
    WHERE (RN_IDC <= 50 AND FLG_DA_CONTABILIZZARE = 1) OR RN_STK <= 50;
