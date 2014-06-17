/* Formatted on 17/06/2014 18:05:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_DAY_CGEG
(
   ID_DPER,
   DTA_RIFERIMENTO_CR,
   VAL_ACC_CR_GE,
   VAL_ACC_SIS_GE,
   VAL_GAR_CR_GE,
   VAL_GAR_SIS_GE,
   VAL_SCO_CR_GE,
   VAL_SCO_SIS_GE,
   VAL_UTI_CR_GE,
   VAL_UTI_SIS_GE,
   COD_SNDG_GE
)
AS
   SELECT "ID_DPER",
          "DTA_RIFERIMENTO_CR",
          "VAL_ACC_CR_GE",
          "VAL_ACC_SIS_GE",
          "VAL_GAR_CR_GE",
          "VAL_GAR_SIS_GE",
          "VAL_SCO_CR_GE",
          "VAL_SCO_SIS_GE",
          "VAL_UTI_CR_GE",
          "VAL_UTI_SIS_GE",
          "COD_SNDG_GE"
     FROM mcre_own.T_MCRE0_STG_CGEG
    WHERE (COD_SNDG_GE) IN (SELECT COD_SNDG_GE
                              FROM (SELECT DTA_RIFERIMENTO_CR,
                                           VAL_ACC_CR_GE,
                                           VAL_ACC_SIS_GE,
                                           VAL_GAR_CR_GE,
                                           VAL_GAR_SIS_GE,
                                           VAL_SCO_CR_GE,
                                           VAL_SCO_SIS_GE,
                                           VAL_UTI_CR_GE,
                                           VAL_UTI_SIS_GE,
                                           COD_SNDG_GE
                                      FROM mcre_own.T_MCRE0_STG_CGEG
                                    MINUS
                                    SELECT DTA_RIFERIMENTO_CR,
                                           VAL_ACC_CR_GE,
                                           VAL_ACC_SIS_GE,
                                           VAL_GAR_CR_GE,
                                           VAL_GAR_SIS_GE,
                                           VAL_SCO_CR_GE,
                                           VAL_SCO_SIS_GE,
                                           VAL_UTI_CR_GE,
                                           VAL_UTI_SIS_GE,
                                           COD_SNDG_GE
                                      FROM mcre_own.T_MCRE0_DWH_CGEG));


GRANT SELECT ON MCRE_OWN.V_MCRE0_DAY_CGEG TO MCRE_USR;
