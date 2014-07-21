/* Formatted on 21/07/2014 18:43:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MAIN_SOFF_IDC
(
   COD_ABI,
   ID_DPER,
   VAL_ANNOMESE,
   COD_NDG,
   COD_SNDG,
   DTA_PASSAGGIO_SOFF,
   VAL_GBV,
   VAL_NBV
)
AS
     SELECT P.COD_ABI,
            b.id_dper,
            b.VAL_ANNOMESE,
            P.COD_NDG,
            R.COD_SNDG,
            P.DTA_PASSAGGIO_SOFF,
            SUM (-R.VAL_IMP_GBV) VAL_GBV,
            SUM (-R.VAL_IMP_NBV) VAL_NBV
       FROM T_MCRES_APP_POSIZIONI P,
            T_MCRES_APP_RAPPORTI R,
            v_MCRES_ULTIMA_ACQ_BILANCIO B
      WHERE     P.DTA_PASSAGGIO_SOFF > b.DTA_DPER
            AND R.COD_ABI = P.COD_ABI
            AND R.COD_NDG = P.COD_NDG
            AND P.COD_ABI = B.COD_ABI
            AND P.FLG_ATTIVA = 1
   GROUP BY P.COD_ABI,
            b.id_dper,
            b.VAL_ANNOMESE,
            P.COD_NDG,
            R.COD_SNDG,
            P.DTA_PASSAGGIO_SOFF;
