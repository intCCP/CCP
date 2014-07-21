/* Formatted on 17/06/2014 18:05:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_DAY_CLGG
(
   ID_DPER,
   COD_SNDG_LG,
   VAL_ACC_LGGB,
   VAL_UTI_LGGB,
   VAL_SCO_LGGB,
   VAL_GAR_LGGB,
   VAL_ACC_SIS_LG,
   VAL_UTI_SIS_LG,
   VAL_SCO_SIS_LG,
   VAL_IMP_GAR_SIS_LG,
   DTA_RIFERIMENTO_CR
)
AS
   SELECT "ID_DPER",
          "COD_SNDG_LG",
          "VAL_ACC_LGGB",
          "VAL_UTI_LGGB",
          "VAL_SCO_LGGB",
          "VAL_GAR_LGGB",
          "VAL_ACC_SIS_LG",
          "VAL_UTI_SIS_LG",
          "VAL_SCO_SIS_LG",
          "VAL_IMP_GAR_SIS_LG",
          "DTA_RIFERIMENTO_CR"
     FROM mcre_own.T_MCRE0_STG_CLGG
    WHERE (COD_SNDG_LG) IN (SELECT COD_SNDG_LG
                              FROM (SELECT COD_SNDG_LG,
                                           VAL_ACC_LGGB,
                                           VAL_UTI_LGGB,
                                           VAL_SCO_LGGB,
                                           VAL_GAR_LGGB,
                                           VAL_ACC_SIS_LG,
                                           VAL_UTI_SIS_LG,
                                           VAL_SCO_SIS_LG,
                                           VAL_IMP_GAR_SIS_LG,
                                           DTA_RIFERIMENTO_CR
                                      FROM T_MCRE0_STG_CLGG
                                    MINUS
                                    SELECT COD_SNDG_LG,
                                           VAL_ACC_LGGB,
                                           VAL_UTI_LGGB,
                                           VAL_SCO_LGGB,
                                           VAL_GAR_LGGB,
                                           VAL_ACC_SIS_LG,
                                           VAL_UTI_SIS_LG,
                                           VAL_SCO_SIS_LG,
                                           VAL_IMP_GAR_SIS_LG,
                                           DTA_RIFERIMENTO_CR
                                      FROM T_MCRE0_DWH_CLGG));


GRANT SELECT ON MCRE_OWN.V_MCRE0_DAY_CLGG TO MCRE_USR;
