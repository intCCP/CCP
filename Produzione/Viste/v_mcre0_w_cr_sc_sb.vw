/* Formatted on 17/06/2014 18:06:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_W_CR_SC_SB
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   DTA_CR_SCSB,
   VAL_ACC_CR_SCSB,
   VAL_GAR_CR_SCSB,
   VAL_SCO_CR_SCSB,
   VAL_UTI_CR_SCSB,
   FLG_FLUSSO_SC_SB
)
AS
   SELECT CR_SC_SB.COD_ABI_CARTOLARIZZATO AS COD_ABI_CARTOLARIZZATO,
          CR_SC_SB.COD_NDG AS cod_ndg,
          CR_SC_SB.DTA_CR_SCSB,
          CR_SC_SB.VAL_ACC_CR_SCSB,
          CR_SC_SB.VAL_GAR_CR_SCSB,
          CR_SC_SB.VAL_SCO_CR_SCSB,
          CR_SC_SB.VAL_UTI_CR_SCSB,
          1 AS FLG_FLUSSO_SC_SB
     FROM MCRE_OWN.T_MCRE0_DAY_CSCS CR_SC_SB
   UNION ALL
   SELECT dwh.COD_ABI_CARTOLARIZZATO,
          dwh.COD_NDG,
          dwh.SCSB_DTA_CR AS DTA_CR_SCSB,
          dwh.SCSB_ACC_CR AS VAL_ACC_CR_SCSB,
          dwh.SCSB_GAR_CR AS VAL_GAR_CR_SCSB,
          dwh.SCSB_SCO_CR AS VAL_SCO_CR_SCSB,
          dwh.SCSB_UTI_CR AS VAL_UTI_CR_SCSB,
          0 AS FLG_FLUSSO_SC_SB
     FROM MCRE_OWN.T_MCRE0_DWH_DATA dwh,
          (SELECT /*+ full(fg) */
                 cod_abi_Cartolarizzato, cod_ndg
             FROM MCRE_OWN.T_MCRE0_DAY_FG fg
            WHERE NOT EXISTS
                         (SELECT 1
                            FROM MCRE_OWN.T_MCRE0_DAY_CSCS cs
                           WHERE     CS.COD_ABI_CARTOLARIZZATO =
                                        FG.COD_ABI_CARTOLARIZZATO
                                 AND CS.COD_NDG = FG.COD_NDG)) oth
    WHERE     DWH.COD_ABI_CARTOLARIZZATO = oth.cod_abi_cartolarizzato
          AND DWH.COD_NDG = oth.cod_ndg;


GRANT SELECT ON MCRE_OWN.V_MCRE0_W_CR_SC_SB TO MCRE_USR;
