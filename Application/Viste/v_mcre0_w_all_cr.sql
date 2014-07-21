/* Formatted on 21/07/2014 18:38:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_W_ALL_CR
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   GESB_COD_ABI_CART,
   GESB_COD_SNDG,
   GESB_DTA_CR,
   GESB_ACC_CR,
   GESB_GAR_CR,
   GESB_SCO_CR,
   GESB_UTI_CR,
   GESB_QIS_ACC,
   GESB_QIS_UTI,
   GEGB_COD_SNDG,
   GEGB_ACC_CR,
   GEGB_ACC_SIS,
   GEGB_GAR_CR,
   GEGB_GAR_SIS,
   GEGB_SCO_CR,
   GEGB_SCO_SIS,
   GEGB_UTI_CR,
   GEGB_UTI_SIS,
   GEGB_DTA_RIF_CR,
   GEGB_QIS_ACC,
   GEGB_QIS_UTI,
   SCGB_COD_SNDG,
   SCGB_DTA_RIF_CR,
   SCGB_DTA_STATO_SIS,
   SCGB_ACC_CR,
   SCGB_ACC_SIS,
   SCGB_GAR_CR,
   SCGB_GAR_SIS,
   SCGB_SCO_CR,
   SCGB_SCO_SIS,
   SCGB_UTI_CR,
   SCGB_UTI_SIS,
   SCGB_COD_STATO_SIS,
   SCGB_QIS_ACC,
   SCGB_QIS_UTI,
   SCSB_COD_ABI_CART,
   SCSB_COD_NDG,
   SCSB_DTA_CR,
   SCSB_ACC_CR,
   SCSB_GAR_CR,
   SCSB_SCO_CR,
   SCSB_UTI_CR,
   QIS_SCSB_ACC,
   QIS_SCSB_UTI,
   GLGB_COD_SNDG,
   GLGB_DTA_RIF_CR,
   GLGB_ACC_CR,
   GLGB_ACC_SIS,
   GLGB_GAR_CR,
   GLGB_IMP_GAR_SIS,
   GLGB_SCO_CR,
   GLGB_SCO_SIS,
   GLGB_UTI_CR,
   GLGB_UTI_SIS,
   GLGB_QIS_ACC,
   GLGB_QIS_UTI,
   FLG_FLUSSO_GE_SB,
   FLG_FLUSSO_GE_GB,
   FLG_FLUSSO_SC_GB,
   FLG_FLUSSO_SC_SB,
   FLG_FLUSSO_CR_LG
)
AS
   SELECT DISTINCT
          fg.COD_ABI_CARTOLARIZZATO,
          fg.COD_NDG,
          fg.COD_SNDG,
          GESB.COD_ABI_CARTOLARIZZATO AS GESB_COD_ABI_CART,
          GESB.COD_SNDG_GE AS GESB_COD_SNDG,
          GESB.DTA_CR_GESB AS GESB_DTA_CR,
          GESB.VAL_ACC_CR_GESB AS GESB_ACC_CR,
          GESB.VAL_GAR_CR_GESB AS GESB_GAR_CR,
          GESB.VAL_SCO_CR_GESB AS GESB_SCO_CR,
          GESB.VAL_UTI_CR_GESB AS GESB_UTI_CR,
          CASE
             WHEN ROUND (
                       gesb.VAL_ACC_CR_GESB
                     / ( (CASE
                             WHEN NVL (gegb.VAL_ACC_SIS_GE, 0) = 0 THEN -1
                             ELSE gegb.VAL_ACC_SIS_GE
                          END))
                     * 100) < 0
             THEN
                NULL
             ELSE
                ROUND (
                     gesb.VAL_ACC_CR_GESB
                   / ( (CASE
                           WHEN NVL (gegb.VAL_ACC_SIS_GE, 0) = 0 THEN -1
                           ELSE gegb.VAL_ACC_SIS_GE
                        END))
                   * 100)
          END
             GESB_QIS_ACC,
          CASE
             WHEN ROUND (
                       gesb.VAL_UTI_CR_GESB
                     / ( (CASE
                             WHEN NVL (gegb.VAL_UTI_SIS_GE, 0) = 0 THEN -1
                             ELSE gegb.VAL_UTI_SIS_GE
                          END))
                     * 100) < 0
             THEN
                NULL
             ELSE
                ROUND (
                     gesb.VAL_UTI_CR_GESB
                   / ( (CASE
                           WHEN NVL (gegb.VAL_UTI_SIS_GE, 0) = 0 THEN -1
                           ELSE gegb.VAL_UTI_SIS_GE
                        END))
                   * 100)
          END
             GESB_QIS_UTI,
          GEGB.COD_SNDG_GE AS GEGB_COD_SNDG,
          GEGB.VAL_ACC_CR_GE AS GEGB_ACC_CR,
          GEGB.VAL_ACC_SIS_GE AS GEGB_ACC_SIS,
          GEGB.VAL_GAR_CR_GE AS GEGB_GAR_CR,
          GEGB.VAL_GAR_SIS_GE AS GEGB_GAR_SIS,
          GEGB.VAL_SCO_CR_GE AS GEGB_SCO_CR,
          GEGB.VAL_SCO_SIS_GE AS GEGB_SCO_SIS,
          GEGB.VAL_UTI_CR_GE AS GEGB_UTI_CR,
          GEGB.VAL_UTI_SIS_GE AS GEGB_UTI_SIS,
          GEGB.DTA_RIFERIMENTO_CR AS GEGB_DTA_RIF_CR,
          GEGB.GEGB_QIS_ACC,
          GEGB.GEGB_QIS_UTI,
          SCGB.COD_SNDG AS SCGB_COD_SNDG,
          SCGB.DTA_RIFERIMENTO_CR AS SCGB_DTA_RIF_CR,
          SCGB.DTA_STATO_SIS AS SCGB_DTA_STATO_SIS,
          SCGB.VAL_ACC_CR_SC AS SCGB_ACC_CR,
          SCGB.VAL_ACC_SIS_SC AS SCGB_ACC_SIS,
          SCGB.VAL_GAR_CR_SC AS SCGB_GAR_CR,
          SCGB.VAL_GAR_SIS_SC AS SCGB_GAR_SIS,
          SCGB.VAL_SCO_CR_SC AS SCGB_SCO_CR,
          SCGB.VAL_SCO_SIS_SC AS SCGB_SCO_SIS,
          SCGB.VAL_UTI_CR_SC AS SCGB_UTI_CR,
          SCGB.VAL_UTI_SIS_SC AS SCGB_UTI_SIS,
          SCGB.COD_STATO_SIS AS SCGB_COD_STATO_SIS,
          SCGB.SCGB_QIS_ACC,
          SCGB.SCGB_QIS_UTI,
          SCSB.COD_ABI_CARTOLARIZZATO AS SCSB_COD_ABI_CART,
          SCSB.COD_NDG AS SCSB_COD_NDG,
          SCSB.DTA_CR_SCSB AS SCSB_DTA_CR,
          SCSB.VAL_ACC_CR_SCSB AS SCSB_ACC_CR,
          SCSB.VAL_GAR_CR_SCSB AS SCSB_GAR_CR,
          SCSB.VAL_SCO_CR_SCSB AS SCSB_SCO_CR,
          SCSB.VAL_UTI_CR_SCSB AS SCSB_UTI_CR,
          CASE
             WHEN ROUND (
                       SCSB.VAL_ACC_CR_SCSB
                     / ( (CASE
                             WHEN NVL (SCGB.VAL_ACC_SIS_SC, 0) = 0 THEN -1
                             ELSE SCGB.VAL_ACC_SIS_SC
                          END))
                     * 100) < 0
             THEN
                NULL
             ELSE
                ROUND (
                     SCSB.VAL_ACC_CR_SCSB
                   / ( (CASE
                           WHEN NVL (SCGB.VAL_ACC_SIS_SC, 0) = 0 THEN -1
                           ELSE SCGB.VAL_ACC_SIS_SC
                        END))
                   * 100)
          END
             QIS_SCSB_ACC,
          CASE
             WHEN ROUND (
                       SCSB.VAL_UTI_CR_SCSB
                     / ( (CASE
                             WHEN NVL (SCGB.VAL_UTI_SIS_SC, 0) = 0 THEN -1
                             ELSE SCGB.VAL_UTI_SIS_SC
                          END))
                     * 100) < 0
             THEN
                NULL
             ELSE
                ROUND (
                     SCSB.VAL_UTI_CR_SCSB
                   / ( (CASE
                           WHEN NVL (SCGB.VAL_UTI_SIS_SC, 0) = 0 THEN -1
                           ELSE SCGB.VAL_UTI_SIS_SC
                        END))
                   * 100)
          END
             QIS_SCSB_UTI,
          LGGB.COD_SNDG_LG AS GLGB_COD_SNDG,
          LGGB.DTA_RIFERIMENTO_CR AS GLGB_DTA_RIF_CR,
          LGGB.VAL_ACC_LGGB AS GLGB_ACC_CR,
          LGGB.VAL_ACC_SIS_LG AS GLGB_ACC_SIS,
          LGGB.VAL_GAR_LGGB AS GLGB_GAR_CR,
          LGGB.VAL_IMP_GAR_SIS_LG AS GLGB_IMP_GAR_SIS,
          LGGB.VAL_SCO_LGGB AS GLGB_SCO_CR,
          LGGB.VAL_SCO_SIS_LG AS GLGB_SCO_SIS,
          LGGB.VAL_UTI_LGGB AS GLGB_UTI_CR,
          LGGB.VAL_UTI_SIS_LG AS GLGB_UTI_SIS,
          LGGB.GLGB_QIS_ACC,
          LGGB.GLGB_QIS_UTI,
          NVL (GESB.FLG_FLUSSO_GE_SB, 0) AS FLG_FLUSSO_GE_SB,
          NVL (GEGB.FLG_FLUSSO_GE_GB, 0) AS FLG_FLUSSO_GE_GB,
          NVL (SCGB.FLG_FLUSSO_SC_GB, 0) AS FLG_FLUSSO_SC_GB,
          NVL (SCSB.FLG_FLUSSO_SC_SB, 0) AS FLG_FLUSSO_SC_SB,
          NVL (LGGB.FLG_FLUSSO_CR_LG, 0) AS FLG_FLUSSO_CR_LG
     FROM MCRE_OWN.T_MCRE0_DAY_FG fg,
          MCRE_OWN.V_MCRE0_W_CR_GE_SB GESB,
          MCRE_OWN.V_MCRE0_W_CR_GE_GB GEGB,
          MCRE_OWN.V_MCRE0_W_CR_SC_GB SCGB,
          MCRE_OWN.V_MCRE0_W_CR_SC_SB SCSB,
          MCRE_OWN.V_MCRE0_W_CR_LG_GB LGGB
    WHERE     FG.COD_SNDG = GESB.COD_SNDG_GE(+)
          AND FG.COD_ABI_CARTOLARIZZATO = GESB.COD_ABI_CARTOLARIZZATO(+)
          AND FG.COD_NDG = GESB.COD_NDG(+)
          --
          AND FG.COD_SNDG = GEGB.COD_SNDG_GE(+)
          AND FG.COD_ABI_CARTOLARIZZATO = GEGB.COD_ABI_CARTOLARIZZATO(+)
          AND FG.COD_NDG = GEGB.COD_NDG(+)
          --
          AND FG.COD_SNDG = SCGB.COD_SNDG(+)
          AND FG.COD_ABI_CARTOLARIZZATO = SCGB.COD_ABI_CARTOLARIZZATO(+)
          AND FG.COD_NDG = SCGB.COD_NDG(+)
          --
          AND FG.COD_ABI_CARTOLARIZZATO = SCSB.COD_ABI_CARTOLARIZZATO(+)
          AND FG.COD_NDG = SCSB.COD_NDG(+)
          --
          AND FG.COD_SNDG = LGGB.COD_SNDG_LG(+)
          AND FG.COD_ABI_CARTOLARIZZATO = LGGB.COD_ABI_CARTOLARIZZATO(+)
          AND FG.COD_NDG = LGGB.COD_NDG(+)
          --
          AND FG.COD_SNDG <> '0000000000000000';
