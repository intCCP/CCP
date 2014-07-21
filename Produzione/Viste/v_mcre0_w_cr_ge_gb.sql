/* Formatted on 17/06/2014 18:06:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_W_CR_GE_GB
(
   COD_SNDG_GE,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   VAL_ACC_CR_GE,
   VAL_ACC_SIS_GE,
   VAL_GAR_CR_GE,
   VAL_GAR_SIS_GE,
   VAL_SCO_CR_GE,
   VAL_SCO_SIS_GE,
   VAL_UTI_CR_GE,
   VAL_UTI_SIS_GE,
   DTA_RIFERIMENTO_CR,
   GEGB_QIS_ACC,
   GEGB_QIS_UTI,
   FLG_FLUSSO_GE_GB
)
AS
   SELECT cr_ge_gb.COD_SNDG_GE,
          NULL AS cod_abi_cartolarizzato,
          NULL AS cod_ndg,
          cr_ge_gb.VAL_ACC_CR_GE,
          cr_ge_gb.VAL_ACC_SIS_GE,
          cr_ge_gb.VAL_GAR_CR_GE,
          cr_ge_gb.VAL_GAR_SIS_GE,
          cr_ge_gb.VAL_SCO_CR_GE,
          cr_ge_gb.VAL_SCO_SIS_GE,
          cr_ge_gb.VAL_UTI_CR_GE,
          cr_ge_gb.VAL_UTI_SIS_GE,
          cr_ge_gb.DTA_RIFERIMENTO_CR,
          CASE
             WHEN ROUND (
                       CR_GE_GB.VAL_ACC_CR_GE
                     / ( (CASE
                             WHEN NVL (cr_ge_gb.VAL_ACC_SIS_GE, 0) = 0
                             THEN
                                -1
                             ELSE
                                cr_ge_gb.VAL_ACC_SIS_GE
                          END))
                     * 100) < 0
             THEN
                NULL
             ELSE
                ROUND (
                     CR_GE_GB.VAL_ACC_CR_GE
                   / ( (CASE
                           WHEN NVL (cr_ge_gb.VAL_ACC_SIS_GE, 0) = 0 THEN -1
                           ELSE cr_ge_gb.VAL_ACC_SIS_GE
                        END))
                   * 100)
          END
             GEGB_QIS_ACC,
          CASE
             WHEN ROUND (
                       CR_GE_GB.VAL_UTI_CR_GE
                     / ( (CASE
                             WHEN NVL (cr_ge_gb.VAL_UTI_SIS_GE, 0) = 0
                             THEN
                                -1
                             ELSE
                                cr_ge_gb.VAL_UTI_SIS_GE
                          END))
                     * 100) < 0
             THEN
                NULL
             ELSE
                ROUND (
                     CR_GE_GB.VAL_UTI_CR_GE
                   / ( (CASE
                           WHEN NVL (cr_ge_gb.VAL_UTI_SIS_GE, 0) = 0 THEN -1
                           ELSE cr_ge_gb.VAL_UTI_SIS_GE
                        END))
                   * 100)
          END
             GEGB_QIS_UTI,
          1 AS FLG_FLUSSO_GE_GB
     FROM MCRE_OWN.T_MCRE0_DAY_CGEG cr_ge_gb
   UNION ALL
   SELECT dwh.COD_SNDG,
          DWH.COD_ABI_CARTOLARIZZATO,
          DWH.COD_NDG,
          DWH.GEGB_ACC_CR AS VAL_ACC_CR_GE,
          DWH.GEGB_ACC_SIS AS VAL_ACC_SIS_GE,
          DWH.GEGB_GAR_CR AS VAL_GAR_CR_GE,
          DWH.GEGB_GAR_SIS AS VAL_GAR_SIS_GE,
          DWH.GEGB_SCO_CR AS VAL_SCO_CR_GE,
          DWH.GEGB_SCO_SIS AS VAL_SCO_SIS_GE,
          DWH.GEGB_UTI_CR AS VAL_UTI_CR_GE,
          DWH.GEGB_UTI_SIS AS VAL_UTI_SIS_GE,
          dwh.GEGB_DTA_RIF_CR,
          DWH.GEGB_QIS_ACC,
          DWH.GEGB_QIS_UTI,
          0 AS FLG_FLUSSO_GE_GB
     FROM MCRE_OWN.T_MCRE0_DWH_DATA dwh,
          (SELECT /*+ full(fg) */
                 cod_abi_Cartolarizzato, cod_ndg
             FROM MCRE_OWN.T_MCRE0_DAY_FG fg
            WHERE NOT EXISTS
                     (SELECT 1
                        FROM MCRE_OWN.T_MCRE0_DAY_CGEG cg
                       WHERE cg.cod_sndg_ge = fg.cod_sndg)) oth
    WHERE     DWH.COD_ABI_CARTOLARIZZATO = oth.cod_abi_cartolarizzato
          AND DWH.COD_NDG = oth.cod_ndg;


GRANT SELECT ON MCRE_OWN.V_MCRE0_W_CR_GE_GB TO MCRE_USR;
