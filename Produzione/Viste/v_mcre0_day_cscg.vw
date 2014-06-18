/* Formatted on 17/06/2014 18:05:04 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_DAY_CSCG
(
   ID_DPER,
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
   COD_SNDG,
   COD_STATO_SIS
)
AS
   SELECT "ID_DPER",
          "DTA_RIFERIMENTO_CR",
          "DTA_STATO_SIS",
          "VAL_ACC_CR_SC",
          "VAL_ACC_SIS_SC",
          "VAL_GAR_CR_SC",
          "VAL_GAR_SIS_SC",
          "VAL_SCO_CR_SC",
          "VAL_SCO_SIS_SC",
          "VAL_UTI_CR_SC",
          "VAL_UTI_SIS_SC",
          "COD_SNDG",
          "COD_STATO_SIS"
     FROM mcre_own.T_MCRE0_STG_CSCG
    WHERE cod_sndg IN (SELECT cod_sndg
                         FROM (SELECT DTA_RIFERIMENTO_CR,
                                      DTA_STATO_SIS,
                                      VAL_ACC_CR_SC,
                                      VAL_ACC_SIS_SC,
                                      VAL_GAR_CR_SC,
                                      VAL_GAR_SIS_SC,
                                      VAL_SCO_CR_SC,
                                      VAL_SCO_SIS_SC,
                                      VAL_UTI_CR_SC,
                                      VAL_UTI_SIS_SC,
                                      COD_SNDG,
                                      COD_STATO_SIS
                                 FROM mcre_own.T_MCRE0_STG_CSCG
                               MINUS
                               SELECT DTA_RIFERIMENTO_CR,
                                      DTA_STATO_SIS,
                                      VAL_ACC_CR_SC,
                                      VAL_ACC_SIS_SC,
                                      VAL_GAR_CR_SC,
                                      VAL_GAR_SIS_SC,
                                      VAL_SCO_CR_SC,
                                      VAL_SCO_SIS_SC,
                                      VAL_UTI_CR_SC,
                                      VAL_UTI_SIS_SC,
                                      COD_SNDG,
                                      COD_STATO_SIS
                                 FROM mcre_own.T_MCRE0_DWH_CSCG));


GRANT SELECT ON MCRE_OWN.V_MCRE0_DAY_CSCG TO MCRE_USR;
