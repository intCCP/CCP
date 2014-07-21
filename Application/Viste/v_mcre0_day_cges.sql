/* Formatted on 21/07/2014 18:36:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_DAY_CGES
(
   ID_DPER,
   COD_ABI_CARTOLARIZZATO,
   DTA_CR_GESB,
   VAL_ACC_CR_GESB,
   VAL_GAR_CR_GESB,
   VAL_SCO_CR_GESB,
   VAL_UTI_CR_GESB,
   COD_SNDG_GE
)
AS
   SELECT "ID_DPER",
          "COD_ABI_CARTOLARIZZATO",
          "DTA_CR_GESB",
          "VAL_ACC_CR_GESB",
          "VAL_GAR_CR_GESB",
          "VAL_SCO_CR_GESB",
          "VAL_UTI_CR_GESB",
          "COD_SNDG_GE"
     FROM mcre_own.T_MCRE0_STG_CGES
    WHERE (cod_abi_cartolarizzato, COD_SNDG_GE) IN
             (SELECT cod_abi_cartolarizzato, COD_SNDG_GE
                FROM (SELECT COD_ABI_CARTOLARIZZATO,
                             DTA_CR_GESB,
                             VAL_ACC_CR_GESB,
                             VAL_GAR_CR_GESB,
                             VAL_SCO_CR_GESB,
                             VAL_UTI_CR_GESB,
                             COD_SNDG_GE
                        FROM mcre_own.T_MCRE0_STG_CGES
                      MINUS
                      SELECT COD_ABI_CARTOLARIZZATO,
                             DTA_CR_GESB,
                             VAL_ACC_CR_GESB,
                             VAL_GAR_CR_GESB,
                             VAL_SCO_CR_GESB,
                             VAL_UTI_CR_GESB,
                             COD_SNDG_GE
                        FROM mcre_own.T_MCRE0_DWH_CGES));
