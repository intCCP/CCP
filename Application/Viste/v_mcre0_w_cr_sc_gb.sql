/* Formatted on 21/07/2014 18:38:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_W_CR_SC_GB
(
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   DTA_RIFERIMENTO_CR,
   DTA_STATO_SIS,
   VAL_ACC_CR_SC,
   VAL_ACC_SIS_SC,
   VAL_GAR_CR_SC,
   VAL_GAR_SIS_SC,
   VAL_SCO_CR_SC,
   VAL_SCO_SIS_SC,
   VAL_UTI_CR_SC,
   VAL_UTI_SIS_SC,
   COD_STATO_SIS,
   SCGB_QIS_ACC,
   SCGB_QIS_UTI,
   FLG_FLUSSO_SC_GB
)
AS
   SELECT SC_GB.COD_SNDG,
          NULL AS cod_abi_cartolarizzato,
          NULL AS cod_ndg,
          SC_GB.DTA_RIFERIMENTO_CR,
          SC_GB.DTA_STATO_SIS,
          SC_GB.VAL_ACC_CR_SC,
          SC_GB.VAL_ACC_SIS_SC,
          SC_GB.VAL_GAR_CR_SC,
          SC_GB.VAL_GAR_SIS_SC,
          SC_GB.VAL_SCO_CR_SC,
          SC_GB.VAL_SCO_SIS_SC,
          SC_GB.VAL_UTI_CR_SC,
          SC_GB.VAL_UTI_SIS_SC,
          SC_GB.COD_STATO_SIS,
          CASE
             WHEN ROUND (
                       sc_gb.VAL_ACC_CR_SC
                     / ( (CASE
                             WHEN NVL (sc_gb.VAL_ACC_SIS_SC, 0) = 0 THEN -1
                             ELSE sc_gb.VAL_ACC_SIS_SC
                          END))
                     * 100) < 0
             THEN
                NULL
             ELSE
                ROUND (
                     sc_gb.VAL_ACC_CR_SC
                   / ( (CASE
                           WHEN NVL (sc_gb.VAL_ACC_SIS_SC, 0) = 0 THEN -1
                           ELSE sc_gb.VAL_ACC_SIS_SC
                        END))
                   * 100)
          END
             SCGB_QIS_ACC,
          CASE
             WHEN ROUND (
                       sc_gb.VAL_UTI_CR_SC
                     / ( (CASE
                             WHEN NVL (sc_gb.VAL_UTI_SIS_SC, 0) = 0 THEN -1
                             ELSE sc_gb.VAL_UTI_SIS_SC
                          END))
                     * 100) < 0
             THEN
                NULL
             ELSE
                ROUND (
                     sc_gb.VAL_UTI_CR_SC
                   / ( (CASE
                           WHEN NVL (sc_gb.VAL_UTI_SIS_SC, 0) = 0 THEN -1
                           ELSE sc_gb.VAL_UTI_SIS_SC
                        END))
                   * 100)
          END
             SCGB_QIS_UTI,
          1 AS FLG_FLUSSO_SC_GB
     FROM T_MCRE0_DAY_CSCG SC_GB
   UNION ALL
   SELECT dwh.COD_SNDG,
          DWH.COD_ABI_CARTOLARIZZATO,
          DWH.COD_NDG,
          dwh.SCGB_DTA_RIF_CR AS DTA_RIFERIMENTO_CR,
          dwh.SCGB_DTA_STATO_SIS AS DTA_STATO_SIS,
          dwh.SCGB_ACC_CR AS VAL_ACC_CR_SC,
          dwh.SCGB_ACC_SIS AS VAL_ACC_SIS_SC,
          dwh.SCGB_GAR_CR AS VAL_GAR_CR_SC,
          dwh.SCGB_GAR_SIS AS VAL_GAR_SIS_SC,
          dwh.SCGB_SCO_CR AS VAL_SCO_CR_SC,
          dwh.SCGB_SCO_SIS AS VAL_SCO_SIS_SC,
          dwh.SCGB_UTI_CR AS VAL_UTI_CR_SC,
          dwh.SCGB_UTI_SIS AS VAL_UTI_SIS_SC,
          dwh.SCGB_COD_STATO_SIS AS COD_STATO_SIS,
          dwh.SCGB_QIS_ACC,
          dwh.SCGB_QIS_UTI,
          0 AS FLG_FLUSSO_SC_GB
     FROM MCRE_OWN.T_MCRE0_DWH_DATA dwh,
          (SELECT /*+ full(fg) */
                 cod_abi_Cartolarizzato, cod_ndg
             FROM MCRE_OWN.T_MCRE0_DAY_FG fg
            WHERE NOT EXISTS
                     (SELECT 1
                        FROM MCRE_OWN.T_MCRE0_DAY_CSCG cg
                       WHERE cg.cod_sndg = fg.cod_sndg)) oth
    WHERE     DWH.COD_ABI_CARTOLARIZZATO = oth.cod_abi_cartolarizzato
          AND DWH.COD_NDG = oth.cod_ndg;
