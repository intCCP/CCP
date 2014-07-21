/* Formatted on 21/07/2014 18:36:56 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_DWH_DATA_0
(
   TODAY_FLG,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_GRUPPO_ECONOMICO,
   DTA_RIF_PD_ONLINE,
   VAL_RATING_ONLINE,
   VAL_PD_ONLINE,
   SCSB_UTI_TOT,
   SCSB_ACC_TOT,
   SCSB_UTI_CASSA,
   SCSB_UTI_FIRMA,
   SCSB_ACC_CASSA,
   SCSB_ACC_FIRMA,
   GB_VAL_MAU,
   GEGB_ACC_CASSA,
   GEGB_ACC_FIRMA,
   GEGB_UTI_CASSA,
   GEGB_UTI_FIRMA,
   GLGB_ACC_CASSA,
   GLGB_ACC_FIRMA,
   GLGB_UTI_CASSA,
   GLGB_UTI_FIRMA,
   SCSB_ACC_SOSTITUZIONI,
   SCSB_UTI_SOSTITUZIONI,
   SCSB_UTI_CASSA_BT,
   SCSB_UTI_CASSA_MLT,
   SCSB_UTI_SMOBILIZZO,
   SCSB_ACC_CASSA_BT,
   SCSB_UTI_FIRMA_DT,
   SCSB_ACC_CASSA_MLT,
   SCSB_ACC_SMOBILIZZO,
   SCSB_ACC_FIRMA_DT,
   SCSB_TOT_GAR,
   SCSB_DTA_RIFERIMENTO,
   SCSB_ACC_CONSEGNE,
   SCSB_ACC_MASSIMALI,
   SCSB_ACC_RISCHI_INDIRETTI,
   SCSB_UTI_CONSEGNE,
   SCSB_UTI_MASSIMALI,
   SCSB_UTI_RISCHI_INDIRETTI,
   GESB_UTI_CASSA,
   GESB_UTI_FIRMA,
   GESB_ACC_CASSA,
   GESB_ACC_FIRMA,
   GESB_UTI_CASSA_BT,
   GESB_UTI_CASSA_MLT,
   GESB_UTI_SMOBILIZZO,
   GESB_UTI_FIRMA_DT,
   GESB_ACC_CASSA_BT,
   GESB_ACC_CASSA_MLT,
   GESB_ACC_SMOBILIZZO,
   GESB_ACC_FIRMA_DT,
   GESB_TOT_GAR,
   GESB_DTA_RIFERIMENTO,
   GESB_ACC_CONSEGNE,
   GESB_ACC_MASSIMALI,
   GESB_ACC_RISCHI_INDIRETTI,
   GESB_ACC_SOSTITUZIONI,
   GESB_UTI_CONSEGNE,
   GESB_UTI_MASSIMALI,
   GESB_UTI_RISCHI_INDIRETTI,
   GESB_UTI_SOSTITUZIONI,
   SCGB_UTI_CASSA,
   SCGB_UTI_FIRMA,
   SCGB_ACC_CASSA,
   SCGB_ACC_FIRMA,
   SCGB_UTI_CASSA_BT,
   SCGB_UTI_CASSA_MLT,
   SCGB_UTI_SMOBILIZZO,
   SCGB_UTI_FIRMA_DT,
   SCGB_ACC_CASSA_BT,
   SCGB_ACC_CASSA_MLT,
   SCGB_ACC_SMOBILIZZO,
   SCGB_ACC_FIRMA_DT,
   SCGB_TOT_GAR,
   SCGB_ACC_CONSEGNE,
   SCGB_ACC_MASSIMALI,
   SCGB_ACC_RISCHI_INDIRETTI,
   SCGB_ACC_SOSTITUZIONI,
   SCGB_UTI_CONSEGNE,
   SCGB_UTI_MASSIMALI,
   SCGB_UTI_RISCHI_INDIRETTI,
   SCGB_UTI_SOSTITUZIONI,
   GEGB_UTI_CASSA_BT,
   GEGB_UTI_CASSA_MLT,
   GEGB_UTI_SMOBILIZZO,
   GEGB_UTI_FIRMA_DT,
   GEGB_ACC_CASSA_BT,
   GEGB_ACC_CASSA_MLT,
   GEGB_ACC_SMOBILIZZO,
   GEGB_ACC_FIRMA_DT,
   GEGB_TOT_GAR,
   GEGB_ACC_CONSEGNE,
   GEGB_ACC_MASSIMALI,
   GEGB_ACC_RISCHI_INDIRETTI,
   GEGB_ACC_SOSTITUZIONI,
   GEGB_UTI_CONSEGNE,
   GEGB_UTI_MASSIMALI,
   GEGB_UTI_RISCHI_INDIRETTI,
   GEGB_UTI_SOSTITUZIONI,
   GLGB_UTI_CASSA_BT,
   GLGB_UTI_CASSA_MLT,
   GLGB_UTI_SMOBILIZZO,
   GLGB_UTI_FIRMA_DT,
   GLGB_ACC_CASSA_BT,
   GLGB_ACC_CASSA_MLT,
   GLGB_ACC_SMOBILIZZO,
   GLGB_ACC_FIRMA_DT,
   GLGB_TOT_GAR,
   GB_DTA_RIFERIMENTO,
   GLGB_ACC_CONSEGNE,
   GLGB_ACC_MASSIMALI,
   GLGB_ACC_RISCHI_INDIRETTI,
   GLGB_ACC_SOSTITUZIONI,
   GLGB_UTI_CONSEGNE,
   GLGB_UTI_MASSIMALI,
   GLGB_UTI_RISCHI_INDIRETTI,
   GLGB_UTI_SOSTITUZIONI,
   SCSB_ACC_CR,
   SCSB_UTI_CR,
   SCSB_GAR_CR,
   SCSB_SCO_CR,
   SCSB_QIS_ACC,
   SCSB_QIS_UTI,
   SCSB_DTA_CR,
   SCGB_ACC_CR,
   SCGB_ACC_SIS,
   SCGB_GAR_CR,
   SCGB_GAR_SIS,
   SCGB_SCO_CR,
   SCGB_SCO_SIS,
   SCGB_UTI_CR,
   SCGB_UTI_SIS,
   SCGB_QIS_ACC,
   SCGB_QIS_UTI,
   SCGB_DTA_RIF_CR,
   SCGB_DTA_STATO_SIS,
   SCGB_COD_STATO_SIS,
   GESB_ACC_CR,
   GESB_UTI_CR,
   GESB_GAR_CR,
   GESB_SCO_CR,
   GESB_QIS_ACC,
   GESB_QIS_UTI,
   GESB_DTA_CR,
   GEGB_ACC_CR,
   GEGB_ACC_SIS,
   GEGB_UTI_CR,
   GEGB_UTI_SIS,
   GEGB_GAR_CR,
   GEGB_GAR_SIS,
   GEGB_SCO_CR,
   GEGB_SCO_SIS,
   GEGB_QIS_ACC,
   GEGB_QIS_UTI,
   GEGB_DTA_RIF_CR,
   GLGB_ACC_CR,
   GLGB_UTI_CR,
   GLGB_SCO_CR,
   GLGB_GAR_CR,
   GLGB_ACC_SIS,
   GLGB_UTI_SIS,
   GLGB_SCO_SIS,
   GLGB_IMP_GAR_SIS,
   GLGB_QIS_ACC,
   GLGB_QIS_UTI,
   GLGB_DTA_RIF_CR,
   COD_PEF,
   COD_FASE_PEF,
   DTA_ULTIMA_REVISIONE_PEF,
   DTA_SCADENZA_FIDO,
   DTA_ULTIMA_DELIBERA,
   FLG_FIDI_SCADUTI,
   DAT_ULTIMO_SCADUTO,
   COD_ULTIMO_ODE,
   COD_CTS_ULTIMO_ODE,
   COD_STRATEGIA_CRZ,
   COD_ODE,
   DTA_COMPLETAMENTO_PEF,
   VAL_LGD,
   DTA_LGD,
   VAL_EAD,
   DTA_EAD,
   VAL_PA,
   DTA_PA,
   VAL_PD,
   DTA_PD,
   VAL_IRIS_GE,
   VAL_IRIS_CLI,
   DTA_IRIS,
   LIV_RISCHIO_GE,
   LIV_RISCHIO_CLI,
   VAL_SCONFINO,
   COD_RAP,
   VAL_SCONFINO_RAP,
   FLG_ALLINEATO_SAG,
   COD_SAG,
   FLG_CONFERMA_SAG,
   DTA_CONFERMA_SAG,
   DTA_PD_ONLINE,
   VAL_RATING
)
AS
   SELECT /*+full(T)*/
         T.TODAY_FLG,
          T.COD_ABI_ISTITUTO,
          T.COD_ABI_CARTOLARIZZATO,
          T.COD_NDG,
          T.COD_SNDG,
          T.DESC_GRUPPO_ECONOMICO,
          T.DTA_RIF_PD_ONLINE,
          T.VAL_RATING_ONLINE,
          T.VAL_PD_ONLINE,
          T.SCSB_UTI_TOT,
          T.SCSB_ACC_TOT,
          T.SCSB_UTI_CASSA,
          T.SCSB_UTI_FIRMA,
          T.SCSB_ACC_CASSA,
          T.SCSB_ACC_FIRMA,
          T.GB_VAL_MAU,
          T.GEGB_ACC_CASSA,
          T.GEGB_ACC_FIRMA,
          T.GEGB_UTI_CASSA,
          T.GEGB_UTI_FIRMA,
          T.GLGB_ACC_CASSA,
          T.GLGB_ACC_FIRMA,
          T.GLGB_UTI_CASSA,
          T.GLGB_UTI_FIRMA,
          T.SCSB_ACC_SOSTITUZIONI,
          T.SCSB_UTI_SOSTITUZIONI,
          T.SCSB_UTI_CASSA_BT,
          T.SCSB_UTI_CASSA_MLT,
          T.SCSB_UTI_SMOBILIZZO,
          T.SCSB_ACC_CASSA_BT,
          T.SCSB_UTI_FIRMA_DT,
          T.SCSB_ACC_CASSA_MLT,
          T.SCSB_ACC_SMOBILIZZO,
          T.SCSB_ACC_FIRMA_DT,
          T.SCSB_TOT_GAR,
          T.SCSB_DTA_RIFERIMENTO,
          T.SCSB_ACC_CONSEGNE,
          T.SCSB_ACC_MASSIMALI,
          T.SCSB_ACC_RISCHI_INDIRETTI,
          T.SCSB_UTI_CONSEGNE,
          T.SCSB_UTI_MASSIMALI,
          T.SCSB_UTI_RISCHI_INDIRETTI,
          T.GESB_UTI_CASSA,
          T.GESB_UTI_FIRMA,
          T.GESB_ACC_CASSA,
          T.GESB_ACC_FIRMA,
          T.GESB_UTI_CASSA_BT,
          T.GESB_UTI_CASSA_MLT,
          T.GESB_UTI_SMOBILIZZO,
          T.GESB_UTI_FIRMA_DT,
          T.GESB_ACC_CASSA_BT,
          T.GESB_ACC_CASSA_MLT,
          T.GESB_ACC_SMOBILIZZO,
          T.GESB_ACC_FIRMA_DT,
          T.GESB_TOT_GAR,
          T.GESB_DTA_RIFERIMENTO,
          T.GESB_ACC_CONSEGNE,
          T.GESB_ACC_MASSIMALI,
          T.GESB_ACC_RISCHI_INDIRETTI,
          T.GESB_ACC_SOSTITUZIONI,
          T.GESB_UTI_CONSEGNE,
          T.GESB_UTI_MASSIMALI,
          T.GESB_UTI_RISCHI_INDIRETTI,
          T.GESB_UTI_SOSTITUZIONI,
          T.SCGB_UTI_CASSA,
          T.SCGB_UTI_FIRMA,
          T.SCGB_ACC_CASSA,
          T.SCGB_ACC_FIRMA,
          T.SCGB_UTI_CASSA_BT,
          T.SCGB_UTI_CASSA_MLT,
          T.SCGB_UTI_SMOBILIZZO,
          T.SCGB_UTI_FIRMA_DT,
          T.SCGB_ACC_CASSA_BT,
          T.SCGB_ACC_CASSA_MLT,
          T.SCGB_ACC_SMOBILIZZO,
          T.SCGB_ACC_FIRMA_DT,
          T.SCGB_TOT_GAR,
          T.SCGB_ACC_CONSEGNE,
          T.SCGB_ACC_MASSIMALI,
          T.SCGB_ACC_RISCHI_INDIRETTI,
          T.SCGB_ACC_SOSTITUZIONI,
          T.SCGB_UTI_CONSEGNE,
          T.SCGB_UTI_MASSIMALI,
          T.SCGB_UTI_RISCHI_INDIRETTI,
          T.SCGB_UTI_SOSTITUZIONI,
          T.GEGB_UTI_CASSA_BT,
          T.GEGB_UTI_CASSA_MLT,
          T.GEGB_UTI_SMOBILIZZO,
          T.GEGB_UTI_FIRMA_DT,
          T.GEGB_ACC_CASSA_BT,
          T.GEGB_ACC_CASSA_MLT,
          T.GEGB_ACC_SMOBILIZZO,
          T.GEGB_ACC_FIRMA_DT,
          T.GEGB_TOT_GAR,
          T.GEGB_ACC_CONSEGNE,
          T.GEGB_ACC_MASSIMALI,
          T.GEGB_ACC_RISCHI_INDIRETTI,
          T.GEGB_ACC_SOSTITUZIONI,
          T.GEGB_UTI_CONSEGNE,
          T.GEGB_UTI_MASSIMALI,
          T.GEGB_UTI_RISCHI_INDIRETTI,
          T.GEGB_UTI_SOSTITUZIONI,
          T.GLGB_UTI_CASSA_BT,
          T.GLGB_UTI_CASSA_MLT,
          T.GLGB_UTI_SMOBILIZZO,
          T.GLGB_UTI_FIRMA_DT,
          T.GLGB_ACC_CASSA_BT,
          T.GLGB_ACC_CASSA_MLT,
          T.GLGB_ACC_SMOBILIZZO,
          T.GLGB_ACC_FIRMA_DT,
          T.GLGB_TOT_GAR,
          T.GB_DTA_RIFERIMENTO,
          T.GLGB_ACC_CONSEGNE,
          T.GLGB_ACC_MASSIMALI,
          T.GLGB_ACC_RISCHI_INDIRETTI,
          T.GLGB_ACC_SOSTITUZIONI,
          T.GLGB_UTI_CONSEGNE,
          T.GLGB_UTI_MASSIMALI,
          T.GLGB_UTI_RISCHI_INDIRETTI,
          T.GLGB_UTI_SOSTITUZIONI,
          T.SCSB_ACC_CR,
          T.SCSB_UTI_CR,
          T.SCSB_GAR_CR,
          T.SCSB_SCO_CR,
          T.SCSB_QIS_ACC,
          T.SCSB_QIS_UTI,
          T.SCSB_DTA_CR,
          T.SCGB_ACC_CR,
          T.SCGB_ACC_SIS,
          T.SCGB_GAR_CR,
          T.SCGB_GAR_SIS,
          T.SCGB_SCO_CR,
          T.SCGB_SCO_SIS,
          T.SCGB_UTI_CR,
          T.SCGB_UTI_SIS,
          T.SCGB_QIS_ACC,
          T.SCGB_QIS_UTI,
          T.SCGB_DTA_RIF_CR,
          T.SCGB_DTA_STATO_SIS,
          T.SCGB_COD_STATO_SIS,
          T.GESB_ACC_CR,
          T.GESB_UTI_CR,
          T.GESB_GAR_CR,
          T.GESB_SCO_CR,
          T.GESB_QIS_ACC,
          T.GESB_QIS_UTI,
          T.GESB_DTA_CR,
          T.GEGB_ACC_CR,
          T.GEGB_ACC_SIS,
          T.GEGB_UTI_CR,
          T.GEGB_UTI_SIS,
          T.GEGB_GAR_CR,
          T.GEGB_GAR_SIS,
          T.GEGB_SCO_CR,
          T.GEGB_SCO_SIS,
          T.GEGB_QIS_ACC,
          T.GEGB_QIS_UTI,
          T.GEGB_DTA_RIF_CR,
          T.GLGB_ACC_CR,
          T.GLGB_UTI_CR,
          T.GLGB_SCO_CR,
          T.GLGB_GAR_CR,
          T.GLGB_ACC_SIS,
          T.GLGB_UTI_SIS,
          T.GLGB_SCO_SIS,
          T.GLGB_IMP_GAR_SIS,
          T.GLGB_QIS_ACC,
          T.GLGB_QIS_UTI,
          T.GLGB_DTA_RIF_CR,
          T.COD_PEF,
          T.COD_FASE_PEF,
          T.DTA_ULTIMA_REVISIONE_PEF,
          T.DTA_SCADENZA_FIDO,
          T.DTA_ULTIMA_DELIBERA,
          T.FLG_FIDI_SCADUTI,
          T.DAT_ULTIMO_SCADUTO,
          T.COD_ULTIMO_ODE,
          T.COD_CTS_ULTIMO_ODE,
          T.COD_STRATEGIA_CRZ,
          T.COD_ODE,
          T.DTA_COMPLETAMENTO_PEF,
          T.VAL_LGD,
          T.DTA_LGD,
          T.VAL_EAD,
          T.DTA_EAD,
          T.VAL_PA,
          T.DTA_PA,
          T.VAL_PD,
          T.DTA_PD,
          T.VAL_IRIS_GE,
          T.VAL_IRIS_CLI,
          T.DTA_IRIS,
          T.LIV_RISCHIO_GE,
          T.LIV_RISCHIO_CLI,
          T.VAL_SCONFINO,
          T.COD_RAP,
          T.VAL_SCONFINO_RAP,
          T.FLG_ALLINEATO_SAG,
          T.COD_SAG,
          T.FLG_CONFERMA_SAG,
          T.DTA_CONFERMA_SAG,
          T.DTA_PD_ONLINE,
          T.VAL_RATING
     FROM MCRE_OWN.T_MCRE0_DWH_DATA T
    WHERE NOT EXISTS
                 (SELECT /*+noparallel(FG)*/
                        1
                    FROM MCRE_OWN.T_MCRE0_DAY_FG FG
                   WHERE     fg.cod_abi_cartolarizzato =
                                t.cod_abi_cartolarizzato
                         AND fg.cod_ndg = t.cod_ndg);
