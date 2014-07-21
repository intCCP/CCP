/* Formatted on 17/06/2014 18:06:44 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_W_CR_LG_GB
(
   COD_SNDG_LG,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   DTA_RIFERIMENTO_CR,
   VAL_ACC_LGGB,
   VAL_ACC_SIS_LG,
   VAL_GAR_LGGB,
   VAL_IMP_GAR_SIS_LG,
   VAL_SCO_LGGB,
   VAL_SCO_SIS_LG,
   VAL_UTI_LGGB,
   VAL_UTI_SIS_LG,
   GLGB_QIS_ACC,
   GLGB_QIS_UTI,
   FLG_FLUSSO_CR_LG
)
AS
   SELECT CR_LG.COD_SNDG_LG,
          NULL AS cod_abi_cartolarizzato,
          NULL AS cod_ndg,
          CR_LG.DTA_RIFERIMENTO_CR,
          CR_LG.VAL_ACC_LGGB,
          CR_LG.VAL_ACC_SIS_LG,
          CR_LG.VAL_GAR_LGGB,
          CR_LG.VAL_IMP_GAR_SIS_LG,
          CR_LG.VAL_SCO_LGGB,
          CR_LG.VAL_SCO_SIS_LG,
          CR_LG.VAL_UTI_LGGB,
          CR_LG.VAL_UTI_SIS_LG,
          CASE
             WHEN ROUND (
                       cr_lg.VAL_ACC_LGGB
                     / ( (CASE
                             WHEN NVL (cr_lg.VAL_ACC_SIS_LG, 0) = 0 THEN -1
                             ELSE cr_lg.VAL_ACC_SIS_LG
                          END))
                     * 100) < 0
             THEN
                NULL
             ELSE
                ROUND (
                     cr_lg.VAL_ACC_LGGB
                   / ( (CASE
                           WHEN NVL (cr_lg.VAL_ACC_SIS_LG, 0) = 0 THEN -1
                           ELSE cr_lg.VAL_ACC_SIS_LG
                        END))
                   * 100)
          END
             glgb_qis_acc,
          CASE
             WHEN ROUND (
                       cr_lg.VAL_UTI_LGGB
                     / ( (CASE
                             WHEN NVL (cr_lg.VAL_UTI_SIS_LG, 0) = 0 THEN -1
                             ELSE cr_lg.VAL_UTI_SIS_LG
                          END))
                     * 100) < 0
             THEN
                NULL
             ELSE
                ROUND (
                     cr_lg.VAL_UTI_LGGB
                   / ( (CASE
                           WHEN NVL (cr_lg.VAL_UTI_SIS_LG, 0) = 0 THEN -1
                           ELSE cr_lg.VAL_UTI_SIS_LG
                        END))
                   * 100)
          END
             glgb_qis_uti,
          1 AS FLG_FLUSSO_CR_LG
     FROM MCRE_OWN.T_MCRE0_DAY_CLGG CR_LG
   UNION ALL
   SELECT dwh.COD_SNDG AS COD_SNDG_LG,
          DWH.COD_ABI_CARTOLARIZZATO,
          DWH.COD_NDG,
          dwh.GLGB_DTA_RIF_CR AS DTA_RIFERIMENTO_CR,
          dwh.GLGB_ACC_CR AS VAL_ACC_LGGB,
          dwh.GLGB_ACC_SIS AS VAL_ACC_SIS_LG,
          dwh.GLGB_GAR_CR AS VAL_GAR_LGGB,
          dwh.GLGB_IMP_GAR_SIS AS VAL_IMP_GAR_SIS_LG,
          dwh.GLGB_SCO_CR AS VAL_SCO_LGGB,
          dwh.GLGB_SCO_SIS AS VAL_SCO_SIS_LG,
          dwh.GLGB_UTI_CR AS VAL_UTI_LGGB,
          dwh.GLGB_UTI_SIS AS VAL_UTI_SIS_LG,
          dwh.GLGB_QIS_ACC,
          dwh.GLGB_QIS_UTI,
          0 AS FLG_FLUSSO_CR_LG
     FROM MCRE_OWN.T_MCRE0_DWH_DATA dwh,
          (SELECT /*+ full(fg) */
                 cod_abi_Cartolarizzato, cod_ndg
             FROM MCRE_OWN.T_MCRE0_DAY_FG fg
            WHERE NOT EXISTS
                     (SELECT 1
                        FROM MCRE_OWN.T_MCRE0_DAY_CLGG cg
                       WHERE cg.cod_sndg_lg = fg.cod_sndg)) oth
    WHERE     DWH.COD_ABI_CARTOLARIZZATO = oth.cod_abi_cartolarizzato
          AND DWH.COD_NDG = oth.cod_ndg;


GRANT SELECT ON MCRE_OWN.V_MCRE0_W_CR_LG_GB TO MCRE_USR;
