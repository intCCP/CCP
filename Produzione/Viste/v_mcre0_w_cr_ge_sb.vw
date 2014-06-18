/* Formatted on 17/06/2014 18:06:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_W_CR_GE_SB
(
   COD_ABI_CARTOLARIZZATO,
   COD_SNDG_GE,
   COD_NDG,
   DTA_CR_GESB,
   VAL_ACC_CR_GESB,
   VAL_GAR_CR_GESB,
   VAL_SCO_CR_GESB,
   VAL_UTI_CR_GESB,
   FLG_FLUSSO_GE_SB
)
AS
   SELECT GE_SB.COD_ABI_CARTOLARIZZATO,
          GE_SB.COD_SNDG_GE,
          NULL AS cod_ndg,
          GE_SB.DTA_CR_GESB,
          GE_SB.VAL_ACC_CR_GESB,
          GE_SB.VAL_GAR_CR_GESB,
          GE_SB.VAL_SCO_CR_GESB,
          GE_SB.VAL_UTI_CR_GESB,
          1 AS FLG_FLUSSO_GE_SB
     FROM MCRE_OWN.T_MCRE0_DAY_CGES GE_SB
   UNION ALL
   SELECT dwh.COD_ABI_CARTOLARIZZATO,
          dwh.COD_SNDG AS COD_SNDG_GE,
          dwh.cod_ndg,
          dwh.GESB_DTA_CR AS DTA_CR_GESB,
          dwh.GESB_ACC_CR AS VAL_ACC_CR_GESB,
          dwh.GESB_GAR_CR AS VAL_GAR_CR_GESB,
          dwh.GESB_SCO_CR AS VAL_SCO_CR_GESB,
          dwh.GESB_UTI_CR AS VAL_UTI_CR_GESB,
          0 AS FLG_FLUSSO_GE_SB
     FROM MCRE_OWN.T_MCRE0_DWH_DATA dwh,
          (SELECT /*+ full(fg) */
                 cod_abi_Cartolarizzato, cod_ndg
             FROM MCRE_OWN.T_MCRE0_DAY_FG fg
            WHERE NOT EXISTS
                         (SELECT 1
                            FROM MCRE_OWN.T_MCRE0_DAY_CGES cg
                           WHERE     cg.cod_sndg_ge = fg.cod_sndg
                                 AND CG.COD_ABI_CARTOLARIZZATO =
                                        FG.COD_ABI_CARTOLARIZZATO)) oth
    WHERE     DWH.COD_ABI_CARTOLARIZZATO = oth.cod_abi_cartolarizzato
          AND DWH.COD_NDG = oth.cod_ndg;


GRANT SELECT ON MCRE_OWN.V_MCRE0_W_CR_GE_SB TO MCRE_USR;
