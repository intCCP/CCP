/* Formatted on 17/06/2014 18:10:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_PTF
(
   COD_ABI,
   VAL_ANNOMESE,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COD_PRESIDIO,
   COD_SEG_ECONOMICO,
   VAL_TIPO_GESTIONE,
   FLG_GRUPPO,
   COD_LABEL,
   DESC_LABEL,
   VAL_NUM_RAPPORTI,
   VAL_NUM_NDG,
   VAL_VANTATO,
   VAL_GBV,
   VAL_GBV_MEDIO,
   VAL_NBV,
   VAL_GBV_BT,
   VAL_NBV_BT,
   VAL_GBV_MLT,
   VAL_NBV_MLT,
   VAL_IC_ABI,
   VAL_INCASSI,
   VAL_NUM_ADDETTI,
   VAL_NUM_PRATICHE_FTE
)
AS
   SELECT t."COD_ABI",
          "VAL_ANNOMESE",
          DECODE (COD_UO_PRATICA, '-1', NULL, COD_UO_PRATICA) COD_UO_PRATICA,
          DECODE (COD_MATR_PRATICA, '-1', NULL, COD_MATR_PRATICA)
             COD_MATR_PRATICA,
          DECODE (T.COD_PRESIDIO, '-1', NULL, T.COD_PRESIDIO) COD_PRESIDIO,
          DECODE (T.COD_SEG_ECONOMICO, '-1', NULL, t.COD_SEG_ECONOMICO)
             COD_SEG_ECONOMICO,
          t.val_tipo_gestione,
          T.FLG_GRUPPO,
          DECODE (T.COD_LABEL, -1, NULL, T.COD_LABEL) COD_LABEL,
          CASE
             WHEN T.FLG_GRUPPO = 5 THEN p.desc_presidio
             WHEN T.FLG_GRUPPO = 6 THEN I.DESC_ISTITUTO
             WHEN T.FLG_GRUPPO = 7 THEN S.DESC_SEG_ECONOMICO
             ELSE L.DESCRIZIONE
          END
             DESC_LABEL,
          "VAL_NUM_RAPPORTI",
          T.VAL_NUM_NDG,
          "VAL_VANTATO",
          "VAL_GBV",
          VAL_GBV / (SUBSTR (val_annomese, 5, 2) + 1) val_gbv_medio,
          "VAL_NBV",
          val_gbv_bt,
          val_nbv_bt,
          val_gbv_mlt,
          val_nbv_mlt,
            1
          - (  SUM (val_nbv) OVER (PARTITION BY t.cod_abi, val_annomese)
             / DECODE (
                  SUM (val_gbv) OVER (PARTITION BY t.cod_abi, val_annomese),
                  0, NULL,
                  SUM (val_gbv) OVER (PARTITION BY t.cod_abi, val_annomese)))
             VAL_IC_ABI,
          "VAL_INCASSI",
          "VAL_NUM_ADDETTI",
          NULL val_num_pratiche_fte
     FROM T_MCRES_FEN_PTF T,
          T_MCRES_CL_LABELS L,
          T_MCRES_APP_ISTITUTI I,
          V_MCRES_APP_LISTA_struttureptf P,
          (SELECT DISTINCT COD_SEG_ECONOMICO, DESC_SEG_ECONOMICO
             FROM T_MCRES_CL_SEG_REGOLAMENTARI) s
    WHERE     L.COD_UTILIZZO = 'PTF'
          AND T.FLG_GRUPPO = L.COD_GRUPPO
          AND DECODE (
                 FLG_GRUPPO,
                 7, 1,
                 DECODE (FLG_GRUPPO,
                         5, 1,
                         DECODE (FLG_GRUPPO, 6, 1, t.COD_LABEL))) =
                 l.COD_LABEL(+)
          AND T.COD_ABI = I.COD_ABI(+)
          AND T.COD_PRESIDIO = P.COD_PRESIDIO(+)
          AND T.COD_SEG_ECONOMICO = s.COD_SEG_ECONOMICO(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_PTF TO MCRE_USR;
