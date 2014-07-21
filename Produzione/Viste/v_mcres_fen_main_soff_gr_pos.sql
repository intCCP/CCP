/* Formatted on 17/06/2014 18:12:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MAIN_SOFF_GR_POS
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   ID_DPER,
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
   VAL_FIRMA
)
AS
     SELECT CP.COD_ABI,
            cp.cod_ndg,
            CP.COD_SNDG,
            GR.COD_GRUPPO_ECONOMICO,
            CP.ID_DPER,
            SUBSTR (CP.ID_DPER, 1, 6) VAL_ANNOMESE,
            cod_segm_irb,
            MAX (cp.dta_decorrenza_stato) dta_decorrenza_stato,
            UPPER (CP.COD_STATO_GIURIDICO) COD_STATO_GIURIDICO,
            SUM (
               CASE
                  WHEN UPPER (CP.VAL_FIRMA) != 'FIRMA' THEN CP.VAL_VANT
                  ELSE 0
               END)
               VAL_VANTATO,
            SUM (
               CASE
                  WHEN UPPER (CP.VAL_FIRMA) != 'FIRMA' THEN CP.VAL_UTI_RET
                  ELSE 0
               END)
               VAL_GBV,
            SUM (
               CASE
                  WHEN UPPER (CP.VAL_FIRMA) != 'FIRMA' THEN CP.VAL_ATT
                  ELSE 0
               END)
               VAL_NBV,
            SUM (
               CASE
                  WHEN UPPER (CP.VAL_FIRMA) != 'FIRMA' THEN CP.VAL_UTI_RET
                  ELSE 0
               END)
               VAL_GBV_MLT,
            SUM (
               CASE
                  WHEN UPPER (CP.VAL_FIRMA) != 'FIRMA' THEN CP.VAL_ATT
                  ELSE 0
               END)
               VAL_NBV_MLT,
            SUM (
               CASE
                  WHEN UPPER (CP.VAL_FIRMA) != 'FIRMA' THEN CP.VAL_UTI_RET
                  ELSE 0
               END)
               VAL_GBV_BT,
            SUM (
               CASE
                  WHEN UPPER (CP.VAL_FIRMA) != 'FIRMA' THEN CP.VAL_ATT
                  ELSE 0
               END)
               VAL_NBV_BT,
            SUM (
               CASE
                  WHEN UPPER (CP.VAL_FIRMA) != 'FIRMA'
                  THEN
                       S.VAL_IMP_GARANZIA_IPOTECARIA
                     + S.VAL_IMP_GARANZIE_PIGNORATIZIE
                  ELSE
                     0
               END)
               VAL_GAR_REALI,
            SUM (
               CASE
                  WHEN UPPER (CP.VAL_FIRMA) != 'FIRMA'
                  THEN
                     S.VAL_IMP_GARANZIE_PERSONALI
                  ELSE
                     0
               END)
               VAL_GAR_PERSONALI,
            ROW_NUMBER ()
            OVER (
               PARTITION BY CP.COD_ABI, SUBSTR (CP.ID_DPER, 1, 6)
               ORDER BY SUBSTR (CP.ID_DPER, 1, 6), SUM (CP.VAL_UTI_RET) DESC)
               RN,
            SUM (
               CASE
                  WHEN UPPER (CP.VAL_FIRMA) = 'FIRMA' THEN CP.VAL_UTI_firma
                  ELSE 0
               END)
               VAL_RISCHIO_FIRMA,
            UPPER (CP.VAL_FIRMA) VAL_FIRMA
       FROM T_MCRES_ST_SISBA S,
            T_MCRES_st_SISBA_CP CP,
            T_MCRE0_APP_GRUPPO_ECONOMICO GR
      WHERE     CP.COD_ABI = S.COD_ABI(+)
            AND CP.COD_NDG = S.COD_NDG(+)
            AND CP.ID_DPER = S.ID_DPER(+)
            AND CP.COD_RAPPORTO = S.COD_RAPPORTO_SISBA(+)
            AND CP.COD_SPORTELLO = S.COD_FILIALE_RAPPORTO(+)
            AND cp.cod_sndg = gr.cod_sndg(+)
            AND UPPER (CP.COD_STATO_RISCHIO) = 'S'
   GROUP BY CP.COD_ABI,
            cp.cod_ndg,
            CP.COD_SNDG,
            GR.COD_GRUPPO_ECONOMICO,
            CP.ID_DPER,
            SUBSTR (CP.ID_DPER, 1, 6),
            COD_SEGM_IRB,
            DTA_DECORRENZA_STATO,
            UPPER (CP.COD_STATO_GIURIDICO),
            UPPER (CP.VAL_FIRMA);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_MAIN_SOFF_GR_POS TO MCRE_USR;
