/* Formatted on 21/07/2014 18:44:56 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_ANAGRAFICA_GENERALE
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_LEGAME,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_SUPER,
   DTA_INTERCETTAMENTO,
   COD_FILIALE,
   COD_STRUTTURA_COMPETENTE,
   COD_COMPARTO_HOST,
   COD_RAMO_HOST,
   COD_COMPARTO_CALCOLATO_PRE,
   COD_COMPARTO_CALCOLATO,
   COD_COMPARTO_ASSEGNATO_OLD,
   COD_PERCORSO,
   COD_PROCESSO_OLD,
   COD_STATO_OLD,
   DTA_DECORRENZA_STATO_OLD,
   DTA_SCADENZA_STATO_OLD,
   COD_STATO_PRECEDENTE_OLD,
   COD_TIPO_INGRESSO,
   ID_TRANSIZIONE,
   DTA_PROCESSO,
   ID_REFERENTE_OLD,
   ID_UTENTE_OLD,
   ID_UTENTE_PRE_OLD,
   DTA_UTENTE_ASSEGNATO_OLD,
   FLG_SOMMA,
   FLG_RIPORTAFOGLIATO,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_SINGOLO,
   FLG_CONDIVISO,
   SCSB_UTI_CASSA,
   SCSB_UTI_FIRMA,
   SCSB_ACC_CASSA,
   SCSB_ACC_FIRMA,
   SCSB_UTI_CASSA_BT,
   SCSB_UTI_CASSA_MLT,
   SCSB_UTI_SMOBILIZZO,
   SCSB_UTI_FIRMA_DT,
   SCSB_ACC_CASSA_BT,
   SCSB_ACC_CASSA_MLT,
   SCSB_ACC_SMOBILIZZO,
   SCSB_ACC_FIRMA_DT,
   SCSB_TOT_GAR,
   SCSB_UTI_TOT,
   SCSB_ACC_TOT,
   SCSB_DTA_RIFERIMENTO,
   SCSB_ACC_CONSEGNE,
   SCSB_ACC_MASSIMALI,
   SCSB_ACC_RISCHI_INDIRETTI,
   SCSB_ACC_SOSTITUZIONI,
   SCSB_UTI_CONSEGNE,
   SCSB_UTI_MASSIMALI,
   SCSB_UTI_RISCHI_INDIRETTI,
   SCSB_UTI_SOSTITUZIONI,
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
   GEGB_UTI_CASSA,
   GEGB_UTI_FIRMA,
   GEGB_ACC_CASSA,
   GEGB_ACC_FIRMA,
   GEGB_UTI_CASSA_BT,
   GEGB_UTI_CASSA_MLT,
   GEGB_UTI_SMOBILIZZO,
   GEGB_UTI_FIRMA_DT,
   GEGB_ACC_CASSA_BT,
   GEGB_ACC_CASSA_MLT,
   GEGB_ACC_SMOBILIZZO,
   GEGB_ACC_FIRMA_DT,
   GEGB_TOT_GAR,
   GLGB_UTI_CASSA,
   GLGB_UTI_FIRMA,
   GLGB_ACC_CASSA,
   GEGB_ACC_CONSEGNE,
   GEGB_ACC_MASSIMALI,
   GEGB_ACC_RISCHI_INDIRETTI,
   GEGB_ACC_SOSTITUZIONI,
   GEGB_UTI_CONSEGNE,
   GEGB_UTI_MASSIMALI,
   GEGB_UTI_RISCHI_INDIRETTI,
   GEGB_UTI_SOSTITUZIONI,
   GLGB_ACC_FIRMA,
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
   GB_VAL_MAU,
   VAL_LGD,
   DTA_LGD,
   VAL_EAD,
   DTA_EAD,
   VAL_PA,
   DTA_PA,
   VAL_PD_ONLINE,
   DTA_PD_ONLINE,
   VAL_RATING_ONLINE,
   VAL_PD,
   DTA_PD,
   VAL_RATING,
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
   ID_DPER_FG,
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
   COD_SERVIZIO_OLD,
   DTA_SERVIZIO_OLD,
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
   SCGB_ID_DPER,
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
   COD_COMPARTO_ASSEGNATO,
   ID_UTENTE,
   ID_UTENTE_PRE,
   ID_REFERENTE,
   DTA_UTENTE_ASSEGNATO,
   COD_SERVIZIO,
   DTA_SERVIZIO,
   COD_PROCESSO,
   COD_STATO,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   COD_MACROSTATO,
   DTA_DEC_MACROSTATO
)
AS
   SELECT                                       -- V1 02/12/2010 VG: Congelata
          -- v1.1 15/12/2010 MM - aggiunto RAMO_HOST
          -- v2.0 07/03/2011 MM -- nuovaa ana_gen estesa
          -- v2.1 04/05/2011 MM -- estesa con CR e servizio
          -- v2.2 16/06/2011 MM -- aggiunto cod_sag
          -- v2.3 21/06/2011 VG -- aggiunti nuovi campi PCR
          MV."COD_ABI_ISTITUTO",
          MV."COD_ABI_CARTOLARIZZATO",
          MV."COD_NDG",
          MV."COD_SNDG",
          MV."DESC_NOME_CONTROPARTE",
          MV."COD_GRUPPO_LEGAME",
          MV."COD_GRUPPO_ECONOMICO",
          MV."COD_GRUPPO_SUPER",
          MV."DTA_INTERCETTAMENTO",
          MV."COD_FILIALE",
          MV."COD_STRUTTURA_COMPETENTE",
          MV."COD_COMPARTO_HOST",
          MV."COD_RAMO_HOST",
          MV."COD_COMPARTO_CALCOLATO_PRE",
          MV."COD_COMPARTO_CALCOLATO",
          MV."COD_COMPARTO_ASSEGNATO_OLD",
          MV."COD_PERCORSO",
          MV."COD_PROCESSO_OLD",
          MV."COD_STATO_OLD",
          MV."DTA_DECORRENZA_STATO_OLD",
          MV."DTA_SCADENZA_STATO_OLD",
          MV."COD_STATO_PRECEDENTE_OLD",
          MV."COD_TIPO_INGRESSO",
          MV."ID_TRANSIZIONE",
          MV."DTA_PROCESSO",
          MV."ID_REFERENTE_OLD",
          MV."ID_UTENTE_OLD",
          MV."ID_UTENTE_PRE_OLD",
          MV."DTA_UTENTE_ASSEGNATO_OLD",
          MV."FLG_SOMMA",
          MV."FLG_RIPORTAFOGLIATO",
          MV."FLG_GRUPPO_ECONOMICO",
          MV."FLG_GRUPPO_LEGAME",
          MV."FLG_SINGOLO",
          MV."FLG_CONDIVISO",
          MV."SCSB_UTI_CASSA",
          MV."SCSB_UTI_FIRMA",
          MV."SCSB_ACC_CASSA",
          MV."SCSB_ACC_FIRMA",
          MV."SCSB_UTI_CASSA_BT",
          MV."SCSB_UTI_CASSA_MLT",
          MV."SCSB_UTI_SMOBILIZZO",
          MV."SCSB_UTI_FIRMA_DT",
          MV."SCSB_ACC_CASSA_BT",
          MV."SCSB_ACC_CASSA_MLT",
          MV."SCSB_ACC_SMOBILIZZO",
          MV."SCSB_ACC_FIRMA_DT",
          MV."SCSB_TOT_GAR",
          MV."SCSB_UTI_TOT",
          MV."SCSB_ACC_TOT",
          MV."SCSB_DTA_RIFERIMENTO",
          MV."SCSB_ACC_CONSEGNE",
          MV."SCSB_ACC_MASSIMALI",
          MV."SCSB_ACC_RISCHI_INDIRETTI",
          MV."SCSB_ACC_SOSTITUZIONI",
          MV."SCSB_UTI_CONSEGNE",
          MV."SCSB_UTI_MASSIMALI",
          MV."SCSB_UTI_RISCHI_INDIRETTI",
          MV."SCSB_UTI_SOSTITUZIONI",
          MV."GESB_UTI_CASSA",
          MV."GESB_UTI_FIRMA",
          MV."GESB_ACC_CASSA",
          MV."GESB_ACC_FIRMA",
          MV."GESB_UTI_CASSA_BT",
          MV."GESB_UTI_CASSA_MLT",
          MV."GESB_UTI_SMOBILIZZO",
          MV."GESB_UTI_FIRMA_DT",
          MV."GESB_ACC_CASSA_BT",
          MV."GESB_ACC_CASSA_MLT",
          MV."GESB_ACC_SMOBILIZZO",
          MV."GESB_ACC_FIRMA_DT",
          MV."GESB_TOT_GAR",
          MV."GESB_DTA_RIFERIMENTO",
          MV."GESB_ACC_CONSEGNE",
          MV."GESB_ACC_MASSIMALI",
          MV."GESB_ACC_RISCHI_INDIRETTI",
          MV."GESB_ACC_SOSTITUZIONI",
          MV."GESB_UTI_CONSEGNE",
          MV."GESB_UTI_MASSIMALI",
          MV."GESB_UTI_RISCHI_INDIRETTI",
          MV."GESB_UTI_SOSTITUZIONI",
          MV."SCGB_UTI_CASSA",
          MV."SCGB_UTI_FIRMA",
          MV."SCGB_ACC_CASSA",
          MV."SCGB_ACC_FIRMA",
          MV."SCGB_UTI_CASSA_BT",
          MV."SCGB_UTI_CASSA_MLT",
          MV."SCGB_UTI_SMOBILIZZO",
          MV."SCGB_UTI_FIRMA_DT",
          MV."SCGB_ACC_CASSA_BT",
          MV."SCGB_ACC_CASSA_MLT",
          MV."SCGB_ACC_SMOBILIZZO",
          MV."SCGB_ACC_FIRMA_DT",
          MV."SCGB_TOT_GAR",
          MV."SCGB_ACC_CONSEGNE",
          MV."SCGB_ACC_MASSIMALI",
          MV."SCGB_ACC_RISCHI_INDIRETTI",
          MV."SCGB_ACC_SOSTITUZIONI",
          MV."SCGB_UTI_CONSEGNE",
          MV."SCGB_UTI_MASSIMALI",
          MV."SCGB_UTI_RISCHI_INDIRETTI",
          MV."SCGB_UTI_SOSTITUZIONI",
          MV."GEGB_UTI_CASSA",
          MV."GEGB_UTI_FIRMA",
          MV."GEGB_ACC_CASSA",
          MV."GEGB_ACC_FIRMA",
          MV."GEGB_UTI_CASSA_BT",
          MV."GEGB_UTI_CASSA_MLT",
          MV."GEGB_UTI_SMOBILIZZO",
          MV."GEGB_UTI_FIRMA_DT",
          MV."GEGB_ACC_CASSA_BT",
          MV."GEGB_ACC_CASSA_MLT",
          MV."GEGB_ACC_SMOBILIZZO",
          MV."GEGB_ACC_FIRMA_DT",
          MV."GEGB_TOT_GAR",
          MV."GLGB_UTI_CASSA",
          MV."GLGB_UTI_FIRMA",
          MV."GLGB_ACC_CASSA",
          MV."GEGB_ACC_CONSEGNE",
          MV."GEGB_ACC_MASSIMALI",
          MV."GEGB_ACC_RISCHI_INDIRETTI",
          MV."GEGB_ACC_SOSTITUZIONI",
          MV."GEGB_UTI_CONSEGNE",
          MV."GEGB_UTI_MASSIMALI",
          MV."GEGB_UTI_RISCHI_INDIRETTI",
          MV."GEGB_UTI_SOSTITUZIONI",
          MV."GLGB_ACC_FIRMA",
          MV."GLGB_UTI_CASSA_BT",
          MV."GLGB_UTI_CASSA_MLT",
          MV."GLGB_UTI_SMOBILIZZO",
          MV."GLGB_UTI_FIRMA_DT",
          MV."GLGB_ACC_CASSA_BT",
          MV."GLGB_ACC_CASSA_MLT",
          MV."GLGB_ACC_SMOBILIZZO",
          MV."GLGB_ACC_FIRMA_DT",
          MV."GLGB_TOT_GAR",
          MV."GB_DTA_RIFERIMENTO",
          MV."GLGB_ACC_CONSEGNE",
          MV."GLGB_ACC_MASSIMALI",
          MV."GLGB_ACC_RISCHI_INDIRETTI",
          MV."GLGB_ACC_SOSTITUZIONI",
          MV."GLGB_UTI_CONSEGNE",
          MV."GLGB_UTI_MASSIMALI",
          MV."GLGB_UTI_RISCHI_INDIRETTI",
          MV."GLGB_UTI_SOSTITUZIONI",
          MV."GB_VAL_MAU",
          MV."VAL_LGD",
          MV."DTA_LGD",
          MV."VAL_EAD",
          MV."DTA_EAD",
          MV."VAL_PA",
          MV."DTA_PA",
          MV."VAL_PD_ONLINE",
          MV."DTA_PD_ONLINE",
          MV."VAL_RATING_ONLINE",
          MV."VAL_PD",
          MV."DTA_PD",
          MV."VAL_RATING",
          MV."VAL_IRIS_GE",
          MV."VAL_IRIS_CLI",
          MV."DTA_IRIS",
          MV."LIV_RISCHIO_GE",
          MV."LIV_RISCHIO_CLI",
          MV."VAL_SCONFINO",
          MV."COD_RAP",
          MV."VAL_SCONFINO_RAP",
          MV."FLG_ALLINEATO_SAG",
          MV."COD_SAG",
          MV."FLG_CONFERMA_SAG",
          MV."DTA_CONFERMA_SAG",
          MV."ID_DPER_FG",
          MV."COD_PEF",
          MV."COD_FASE_PEF",
          MV."DTA_ULTIMA_REVISIONE_PEF",
          MV."DTA_SCADENZA_FIDO",
          MV."DTA_ULTIMA_DELIBERA",
          MV."FLG_FIDI_SCADUTI",
          MV."DAT_ULTIMO_SCADUTO",
          MV."COD_ULTIMO_ODE",
          MV."COD_CTS_ULTIMO_ODE",
          MV."COD_STRATEGIA_CRZ",
          MV."COD_ODE",
          MV."DTA_COMPLETAMENTO_PEF",
          MV."COD_SERVIZIO_OLD",
          MV."DTA_SERVIZIO_OLD",
          MV."SCSB_ACC_CR",
          MV."SCSB_UTI_CR",
          MV."SCSB_GAR_CR",
          MV."SCSB_SCO_CR",
          MV."SCSB_QIS_ACC",
          MV."SCSB_QIS_UTI",
          MV."SCSB_DTA_CR",
          MV."SCGB_ACC_CR",
          MV."SCGB_ACC_SIS",
          MV."SCGB_GAR_CR",
          MV."SCGB_GAR_SIS",
          MV."SCGB_SCO_CR",
          MV."SCGB_SCO_SIS",
          MV."SCGB_UTI_CR",
          MV."SCGB_UTI_SIS",
          MV."SCGB_QIS_ACC",
          MV."SCGB_QIS_UTI",
          MV."SCGB_DTA_RIF_CR",
          MV."SCGB_DTA_STATO_SIS",
          MV."SCGB_COD_STATO_SIS",
          MV."SCGB_ID_DPER",
          MV."GESB_ACC_CR",
          MV."GESB_UTI_CR",
          MV."GESB_GAR_CR",
          MV."GESB_SCO_CR",
          MV."GESB_QIS_ACC",
          MV."GESB_QIS_UTI",
          MV."GESB_DTA_CR",
          MV."GEGB_ACC_CR",
          MV."GEGB_ACC_SIS",
          MV."GEGB_UTI_CR",
          MV."GEGB_UTI_SIS",
          MV."GEGB_GAR_CR",
          MV."GEGB_GAR_SIS",
          MV."GEGB_SCO_CR",
          MV."GEGB_SCO_SIS",
          MV."GEGB_QIS_ACC",
          MV."GEGB_QIS_UTI",
          MV."GEGB_DTA_RIF_CR",
          MV."GLGB_ACC_CR",
          MV."GLGB_UTI_CR",
          MV."GLGB_SCO_CR",
          MV."GLGB_GAR_CR",
          MV."GLGB_ACC_SIS",
          MV."GLGB_UTI_SIS",
          MV."GLGB_SCO_SIS",
          MV."GLGB_IMP_GAR_SIS",
          MV."GLGB_QIS_ACC",
          MV."GLGB_QIS_UTI",
          MV."GLGB_DTA_RIF_CR",
          M.COD_COMPARTO_ASSEGNATO,
          M.ID_UTENTE,
          M.ID_UTENTE_PRE,
          M.ID_REFERENTE,
          M.DTA_UTENTE_ASSEGNATO,
          M.COD_SERVIZIO,
          M.DTA_SERVIZIO,
          M.COD_PROCESSO,
          M.COD_STATO,
          M.COD_STATO_PRECEDENTE,
          M.DTA_DECORRENZA_STATO,
          M.DTA_SCADENZA_STATO,
          M.COD_MACROSTATO,
          M.DTA_DEC_MACROSTATO
     FROM MCRE_OWN.MV_MCRE0_ANAGRAFICA_GENERALE MV,
          V_MCRE0_APP_UPD_FIELDS_ALL m
    -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
    --V_MCRE0_APP_UPD_FIELDS M
    -- MCRE_OWN.T_MCRE0_APP_FILE_GUIDA F,
    --MCRE_OWN.T_MCRE0_APP_UTENTI U,
    --MCRE_OWN.T_MCRE0_APP_MOPLE M
    WHERE                              -- OUTER JOIN?  VERIFICARE codici tappo
         MV   .COD_ABI_CARTOLARIZZATO = M.COD_ABI_CARTOLARIZZATO
          AND MV.COD_NDG = M.COD_NDG;
