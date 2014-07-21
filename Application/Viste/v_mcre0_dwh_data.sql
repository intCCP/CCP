/* Formatted on 21/07/2014 18:36:55 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_DWH_DATA
(
   TODAY_FLG,
   FLG_ACTIVE,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DTA_RIF_PD_ONLINE,
   VAL_RATING_ONLINE,
   VAL_PD_ONLINE,
   DTA_PD_ONLINE,
   VAL_RATING,
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
   SCSB_UTI_FIRMA_DT,
   SCSB_ACC_CASSA_BT,
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
   SCGB_ID_DPER
)
AS
   SELECT /*+ full (F) */
                                                                  -- flg today
         NVL (
            (SELECT today_flg
               FROM v_mcre0_today_flg u
              WHERE     u.cod_abi_cartolarizzato = f.cod_abi_cartolarizzato
                    AND u.cod_ndg = f.cod_ndg),
            '0')
            AS TODAY_FLG,
         '1' AS flg_active,
         -- chiavi
         F.COD_ABI_ISTITUTO,
         F.COD_ABI_CARTOLARIZZATO,
         F.COD_NDG,
         F.COD_SNDG,
         A.DTA_RIF_PD_ONLINE,
         A.VAL_RATING_ONLINE,
         A.VAL_PD_ONLINE,
         A.DTA_RIF_PD_ONLINE AS DTA_PD_ONLINE,
         A.VAL_RATING_ONLINE AS VAL_RATING,
         --pef
         PE.COD_PEF,
         PE.COD_FASE_PEF,
         PE.DTA_ULTIMA_REVISIONE AS DTA_ULTIMA_REVISIONE_PEF,
         PE.DTA_SCADENZA_FIDO,
         PE.DTA_ULTIMA_DELIBERA,
         PE.FLG_FIDI_SCADUTI,
         PE.DAT_ULTIMO_SCADUTO,
         PE.COD_ULTIMO_ODE,
         PE.COD_CTS_ULTIMO_ODE,
         PE.COD_STRATEGIA_CRZ,
         PE.COD_ODE,
         PE.DTA_COMPLETAMENTO_PEF,
         --iris
         IRIS.VAL_LGD,
         IRIS.DTA_LGD,
         IRIS.VAL_EAD,
         IRIS.DTA_EAD,
         IRIS.VAL_PA,
         IRIS.DTA_PA,
         IRIS.VAL_PD_MONITORAGGIO AS VAL_PD,
         IRIS.DTA_PD_MONITORAGGIO AS DTA_PD,
         IRIS.VAL_IRIS_GRE AS VAL_IRIS_GE,
         IRIS.VAL_IRIS_CLI,
         IRIS.DTA_RIFERIMENTO AS DTA_IRIS,
         IRIS.VAL_LIV_RISCHIO_GRE AS LIV_RISCHIO_GE,
         IRIS.VAL_LIV_RISCHIO_CLI AS LIV_RISCHIO_CLI,
         --sab_xra
         X.NUM_GIORNI_SCONFINO AS VAL_SCONFINO,
         X.COD_RAP,
         X.NUM_GIORNI_SCONFINO_RAP VAL_SCONFINO_RAP,
         --sag
         S.FLG_ALLINEAMENTO AS FLG_ALLINEATO_SAG,
         S.COD_SAG,
         S.FLG_CONFERMA AS FLG_CONFERMA_SAG,
         S.DTA_CONFERMA AS DTA_CONFERMA_SAG,
         --PCR
         P.SCSB_UTI_TOT,
         P.SCSB_ACC_TOT,
         P.SCSB_UTI_CASSA,
         P.SCSB_UTI_FIRMA,
         P.SCSB_ACC_CASSA,
         P.SCSB_ACC_FIRMA,
         P.GB_VAL_MAU,
         P.GEGB_ACC_CASSA,
         P.GEGB_ACC_FIRMA,
         P.GEGB_UTI_CASSA,
         P.GEGB_UTI_FIRMA,
         P.GLGB_ACC_CASSA,
         P.GLGB_ACC_FIRMA,
         P.GLGB_UTI_CASSA,
         P.GLGB_UTI_FIRMA,
         P.SCSB_ACC_SOSTITUZIONI,
         P.SCSB_UTI_SOSTITUZIONI,
         P.SCSB_UTI_CASSA_BT,
         P.SCSB_UTI_CASSA_MLT,
         P.SCSB_UTI_SMOBILIZZO,
         P.SCSB_UTI_FIRMA_DT,
         P.SCSB_ACC_CASSA_BT,
         P.SCSB_ACC_CASSA_MLT,
         P.SCSB_ACC_SMOBILIZZO,
         P.SCSB_ACC_FIRMA_DT,
         P.SCSB_TOT_GAR,
         P.SCSB_DTA_RIFERIMENTO,
         P.SCSB_ACC_CONSEGNE,
         P.SCSB_ACC_MASSIMALI,
         P.SCSB_ACC_RISCHI_INDIRETTI,
         P.SCSB_UTI_CONSEGNE,
         P.SCSB_UTI_MASSIMALI,
         P.SCSB_UTI_RISCHI_INDIRETTI,
         P.GESB_UTI_CASSA,
         P.GESB_UTI_FIRMA,
         P.GESB_ACC_CASSA,
         P.GESB_ACC_FIRMA,
         P.GESB_UTI_CASSA_BT,
         P.GESB_UTI_CASSA_MLT,
         P.GESB_UTI_SMOBILIZZO,
         P.GESB_UTI_FIRMA_DT,
         P.GESB_ACC_CASSA_BT,
         P.GESB_ACC_CASSA_MLT,
         P.GESB_ACC_SMOBILIZZO,
         P.GESB_ACC_FIRMA_DT,
         P.GESB_TOT_GAR,
         P.GESB_DTA_RIFERIMENTO,
         P.GESB_ACC_CONSEGNE,
         P.GESB_ACC_MASSIMALI,
         P.GESB_ACC_RISCHI_INDIRETTI,
         P.GESB_ACC_SOSTITUZIONI,
         P.GESB_UTI_CONSEGNE,
         P.GESB_UTI_MASSIMALI,
         P.GESB_UTI_RISCHI_INDIRETTI,
         P.GESB_UTI_SOSTITUZIONI,
         P.SCGB_UTI_CASSA,
         P.SCGB_UTI_FIRMA,
         P.SCGB_ACC_CASSA,
         P.SCGB_ACC_FIRMA,
         P.SCGB_UTI_CASSA_BT,
         P.SCGB_UTI_CASSA_MLT,
         P.SCGB_UTI_SMOBILIZZO,
         P.SCGB_UTI_FIRMA_DT,
         P.SCGB_ACC_CASSA_BT,
         P.SCGB_ACC_CASSA_MLT,
         P.SCGB_ACC_SMOBILIZZO,
         P.SCGB_ACC_FIRMA_DT,
         P.SCGB_TOT_GAR,
         P.SCGB_ACC_CONSEGNE,
         P.SCGB_ACC_MASSIMALI,
         P.SCGB_ACC_RISCHI_INDIRETTI,
         P.SCGB_ACC_SOSTITUZIONI,
         P.SCGB_UTI_CONSEGNE,
         P.SCGB_UTI_MASSIMALI,
         P.SCGB_UTI_RISCHI_INDIRETTI,
         P.SCGB_UTI_SOSTITUZIONI,
         P.GEGB_UTI_CASSA_BT,
         P.GEGB_UTI_CASSA_MLT,
         P.GEGB_UTI_SMOBILIZZO,
         P.GEGB_UTI_FIRMA_DT,
         P.GEGB_ACC_CASSA_BT,
         P.GEGB_ACC_CASSA_MLT,
         P.GEGB_ACC_SMOBILIZZO,
         P.GEGB_ACC_FIRMA_DT,
         P.GEGB_TOT_GAR,
         P.GEGB_ACC_CONSEGNE,
         P.GEGB_ACC_MASSIMALI,
         P.GEGB_ACC_RISCHI_INDIRETTI,
         P.GEGB_ACC_SOSTITUZIONI,
         P.GEGB_UTI_CONSEGNE,
         P.GEGB_UTI_MASSIMALI,
         P.GEGB_UTI_RISCHI_INDIRETTI,
         P.GEGB_UTI_SOSTITUZIONI,
         P.GLGB_UTI_CASSA_BT,
         P.GLGB_UTI_CASSA_MLT,
         P.GLGB_UTI_SMOBILIZZO,
         P.GLGB_UTI_FIRMA_DT,
         P.GLGB_ACC_CASSA_BT,
         P.GLGB_ACC_CASSA_MLT,
         P.GLGB_ACC_SMOBILIZZO,
         P.GLGB_ACC_FIRMA_DT,
         P.GLGB_TOT_GAR,
         P.SCSB_DTA_RIFERIMENTO AS GB_DTA_RIFERIMENTO,
         P.GLGB_ACC_CONSEGNE,
         P.GLGB_ACC_MASSIMALI,
         P.GLGB_ACC_RISCHI_INDIRETTI,
         P.GLGB_ACC_SOSTITUZIONI,
         P.GLGB_UTI_CONSEGNE,
         P.GLGB_UTI_MASSIMALI,
         P.GLGB_UTI_RISCHI_INDIRETTI,
         P.GLGB_UTI_SOSTITUZIONI,
         --CR
         CR.SCSB_ACC_CR,
         CR.SCSB_UTI_CR,
         CR.SCSB_GAR_CR,
         CR.SCSB_SCO_CR,
         CR.QIS_SCSB_ACC AS SCSB_QIS_ACC,
         CR.QIS_SCSB_UTI AS SCSB_QIS_UTI,
         CR.SCSB_DTA_CR,
         CR.SCGB_ACC_CR,
         CR.SCGB_ACC_SIS,
         CR.SCGB_GAR_CR,
         CR.SCGB_GAR_SIS,
         CR.SCGB_SCO_CR,
         CR.SCGB_SCO_SIS,
         CR.SCGB_UTI_CR,
         CR.SCGB_UTI_SIS,
         CR.SCGB_QIS_ACC,
         CR.SCGB_QIS_UTI,
         CR.SCGB_DTA_RIF_CR,
         CR.SCGB_DTA_STATO_SIS,
         CR.SCGB_COD_STATO_SIS,
         CR.GESB_ACC_CR,
         CR.GESB_UTI_CR,
         CR.GESB_GAR_CR,
         CR.GESB_SCO_CR,
         CR.GESB_QIS_ACC,
         CR.GESB_QIS_UTI,
         CR.GESB_DTA_CR,
         CR.GEGB_ACC_CR,
         CR.GEGB_ACC_SIS,
         CR.GEGB_UTI_CR,
         CR.GEGB_UTI_SIS,
         CR.GEGB_GAR_CR,
         CR.GEGB_GAR_SIS,
         CR.GEGB_SCO_CR,
         CR.GEGB_SCO_SIS,
         CR.GEGB_QIS_ACC,
         CR.GEGB_QIS_UTI,
         CR.GEGB_DTA_RIF_CR,
         CR.GLGB_ACC_CR,
         CR.GLGB_UTI_CR,
         CR.GLGB_SCO_CR,
         CR.GLGB_GAR_CR,
         CR.GLGB_ACC_SIS,
         CR.GLGB_UTI_SIS,
         CR.GLGB_SCO_SIS,
         CR.GLGB_IMP_GAR_SIS,
         CR.GLGB_QIS_ACC,
         CR.GLGB_QIS_UTI,
         CR.GLGB_DTA_RIF_CR,
         SCGB_ID_DPER
    FROM T_MCRE0_DAY_FG F,
         (SELECT * FROM T_MCRE0_DAY_AGRU
          UNION
          SELECT * FROM T_MCRE0_MIS_AGRU) A,
         (SELECT * FROM T_MCRE0_DAY_PEF
          UNION
          SELECT * FROM T_MCRE0_MIS_PEF) PE,
         (SELECT * FROM T_MCRE0_DAY_IRIS
          UNION
          SELECT * FROM T_MCRE0_MIS_IRIS) IRIS,
         (SELECT * FROM T_MCRE0_DAY_XRA
          UNION
          SELECT * FROM T_MCRE0_MIS_XRA) X,
         (SELECT * FROM T_MCRE0_DAY_SAG
          UNION
          SELECT * FROM T_MCRE0_MIS_SAG) S,
         T_MCRE0_DWH_ALL_PCR P,
         T_MCRE0_DWH_ALL_CR CR
   WHERE     F.COD_SNDG = A.COD_SNDG
         AND F.COD_ABI_ISTITUTO = PE.COD_ABI_ISTITUTO(+)
         AND F.COD_NDG = PE.COD_NDG(+)
         AND F.COD_SNDG = IRIS.COD_SNDG(+)
         AND F.COD_ABI_CARTOLARIZZATO = X.COD_ABI_CARTOLARIZZATO(+)
         AND F.COD_NDG = X.COD_NDG(+)
         AND F.COD_SNDG = S.COD_SNDG(+)
         AND F.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO(+)
         AND F.COD_NDG = P.COD_NDG(+)
         AND F.COD_ABI_CARTOLARIZZATO = cr.COD_ABI_CARTOLARIZZATO(+)
         AND F.COD_NDG = cr.COD_NDG(+);
