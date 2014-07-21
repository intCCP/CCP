/* Formatted on 21/07/2014 18:42:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_MAIN_SOFF_GR_POS
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   VAL_ANNOMESE,
   COD_SEGM_IRB,
   DTA_DECORRENZA_STATO,
   COD_STATO_GIURIDICO,
   VAL_VANTATO,
   VAL_GBV,
   VAL_NBV,
   VAL_GBV_MLT,
   VAL_NBV_MLT,
   VAL_GBV_BT,
   VAL_NBV_BT,
   VAL_GAR_REALI,
   VAL_GAR_PERSONALI,
   RN,
   VAL_RISCHIO_FIRMA,
   DESC_NOME_CONTROPARTE,
   DESC_ISTITUTO,
   DESC_ISTITUTO_BREVE,
   VAL_ANA_GRE
)
AS
     SELECT p."COD_ABI",
            p."COD_NDG",
            p."COD_SNDG",
            p."COD_GRUPPO_ECONOMICO",
            p."VAL_ANNOMESE",
            p."COD_SEGM_IRB",
            p."DTA_DECORRENZA_STATO",
            P."COD_STATO_GIURIDICO",
            SUM (P."VAL_VANTATO") VAL_VANTATO,
            SUM (P."VAL_GBV") VAL_GBV,
            SUM (P."VAL_NBV") VAL_NBV,
            SUM (P."VAL_GBV_MLT") VAL_GBV_MLT,
            SUM (P."VAL_NBV_MLT") VAL_NBV_MLT,
            SUM (P."VAL_GBV_BT") VAL_GBV_BT,
            SUM (p."VAL_NBV_BT") VAL_NBV_BT,
            p."VAL_GAR_REALI",
            P."VAL_GAR_PERSONALI",
            --p."RN",
            ROW_NUMBER ()
            OVER (
               PARTITION BY NVL (p."COD_GRUPPO_ECONOMICO", p.COD_SNDG),
                            P.VAL_ANNOMESE
               ORDER BY P.VAL_ANNOMESE, SUM (P.VAL_GBV) DESC)
               RN,
            p."VAL_RISCHIO_FIRMA",
            A.DESC_NOME_CONTROPARTE,
            I.DESC_ISTITUTO,
            I.DESC_BREVE DESC_ISTITUTO_breve,
            E.VAL_ANA_GRE
       FROM T_MCRES_FEN_MAIN_SOFF_GR_POS_n P,
            T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
            T_MCRES_APP_ISTITUTI I,
            T_MCRE0_APP_ANAGR_GRE e
      WHERE     P.COD_SNDG = A.COD_SNDG(+)
            AND P.COD_ABI = I.COD_ABI
            AND P.COD_GRUPPO_ECONOMICO = E.COD_GRE(+)
   GROUP BY p."COD_ABI",
            p."COD_NDG",
            p."COD_SNDG",
            p."COD_GRUPPO_ECONOMICO",
            p."VAL_ANNOMESE",
            p."COD_SEGM_IRB",
            p."DTA_DECORRENZA_STATO",
            P."COD_STATO_GIURIDICO",
            p."VAL_GAR_REALI",
            P."VAL_GAR_PERSONALI",
            p."VAL_RISCHIO_FIRMA",
            A.DESC_NOME_CONTROPARTE,
            I.DESC_ISTITUTO,
            I.DESC_BREVE,
            E.VAL_ANA_GRE;
