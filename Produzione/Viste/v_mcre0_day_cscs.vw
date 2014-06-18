/* Formatted on 17/06/2014 18:05:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_DAY_CSCS
(
   ID_DPER,
   COD_ABI_CARTOLARIZZATO,
   DTA_CR_SCSB,
   VAL_ACC_CR_SCSB,
   VAL_GAR_CR_SCSB,
   VAL_SCO_CR_SCSB,
   VAL_UTI_CR_SCSB,
   COD_NDG
)
AS
   SELECT "ID_DPER",
          "COD_ABI_CARTOLARIZZATO",
          "DTA_CR_SCSB",
          "VAL_ACC_CR_SCSB",
          "VAL_GAR_CR_SCSB",
          "VAL_SCO_CR_SCSB",
          "VAL_UTI_CR_SCSB",
          "COD_NDG"
     FROM mcre_own.T_MCRE0_STG_CSCS
    WHERE (cod_abi_cartolarizzato, cod_ndg) IN
             (SELECT cod_abi_cartolarizzato, cod_ndg
                FROM (SELECT COD_ABI_CARTOLARIZZATO,
                             DTA_CR_SCSB,
                             VAL_ACC_CR_SCSB,
                             VAL_GAR_CR_SCSB,
                             VAL_SCO_CR_SCSB,
                             VAL_UTI_CR_SCSB,
                             COD_NDG
                        FROM mcre_own.T_MCRE0_STG_CSCS
                      MINUS
                      SELECT COD_ABI_CARTOLARIZZATO,
                             DTA_CR_SCSB,
                             VAL_ACC_CR_SCSB,
                             VAL_GAR_CR_SCSB,
                             VAL_SCO_CR_SCSB,
                             VAL_UTI_CR_SCSB,
                             COD_NDG
                        FROM mcre_own.T_MCRE0_DWH_CSCS));


GRANT SELECT ON MCRE_OWN.V_MCRE0_DAY_CSCS TO MCRE_USR;
