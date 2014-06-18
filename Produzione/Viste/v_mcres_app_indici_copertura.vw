/* Formatted on 17/06/2014 18:10:31 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_INDICI_COPERTURA
(
   COD_ABI,
   FLG_GAR_REALI,
   FLG_GAR_REALI_PERSONALI,
   VAL_ANNOMESE,
   VAL_IC_ABI,
   VAL_IC_GB,
   VAL_IC_INTERNO,
   VAL_ANNO,
   COD_Q,
   FINE_NUMBER
)
AS
   SELECT E.COD_ABI,
          E.FLG_GAR_REALI,
          E.FLG_GAR_REALI_PERSONALI,
          e.VAL_ANNOMESE,
          1 - (val_nbv_abi / DECODE (val_gbv_abi, 0, NULL, val_gbv_abi))
             VAL_IC_ABI,
          1 - (val_nbv_gb / DECODE (val_gbv_gb, 0, NULL, val_gbv_gb))
             VAL_IC_GB,
            1
          - (  val_nbv_INTERNO
             / DECODE (val_gbv_INTERNO, 0, NULL, val_gbv_INTERNO))
             VAL_IC_INTERNO,
          SUBSTR (E.VAL_ANNOMESE, 1, 4) VAL_ANNO,
          Q.COD_Q,
          SUBSTR (E.VAL_ANNOMESE, 1, 4) || SUBSTR (Q.FINE_NUMBER, 5, 2)
             FINE_NUMBER
     FROM (SELECT DISTINCT
                  COD_ABI,
                  FLG_GAR_REALI,
                  FLG_GAR_REALI_PERSONALI,
                  val_annomese,
                  SUM (
                     val_nbv)
                  OVER (
                     PARTITION BY cod_abi,
                                  flg_gar_reali,
                                  flg_gar_reali_personali,
                                  val_annomese)
                     val_nbv_abi,
                  SUM (
                     val_gbv)
                  OVER (
                     PARTITION BY cod_abi,
                                  flg_gar_reali,
                                  flg_gar_reali_personali,
                                  val_annomese)
                     val_gbv_abi,
                  SUM (
                     val_nbv)
                  OVER (
                     PARTITION BY flg_gar_reali,
                                  flg_gar_reali_personali,
                                  val_annomese)
                     val_nbv_gb,
                  SUM (
                     val_gbv)
                  OVER (
                     PARTITION BY flg_gar_reali,
                                  flg_gar_reali_personali,
                                  val_annomese)
                     val_gbv_gb,
                  CASE
                     WHEN val_gestione = 'I'
                     THEN
                        SUM (
                           VAL_NBV)
                        OVER (
                           PARTITION BY COD_ABI,
                                        FLG_GAR_REALI,
                                        FLG_GAR_REALI_PERSONALI,
                                        VAL_ANNOMESE)
                     ELSE
                        0
                  END
                     val_nbv_interno,
                  CASE
                     WHEN val_gestione = 'I'
                     THEN
                        SUM (
                           VAL_gBV)
                        OVER (
                           PARTITION BY COD_ABI,
                                        FLG_GAR_REALI,
                                        FLG_GAR_REALI_PERSONALI,
                                        VAL_ANNOMESE)
                     ELSE
                        0
                  END
                     val_gbv_interno
             FROM T_MCRES_FEN_INDICI_COPERTURA) e,
          (SELECT cod_q, INIZIO_NUMBER, FINE_NUMBER
             FROM V_MCRES_APP_QUARTERS
            WHERE cod_q != 5) Q
    WHERE SUBSTR (q.fine_number, 1, 4) || SUBSTR (E.VAL_ANNOMESE, 5, 6) BETWEEN Q.INIZIO_NUMBER
                                                                            AND Q.FINE_NUMBER;


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_INDICI_COPERTURA TO MCRE_USR;
