/* Formatted on 21/07/2014 18:45:39 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_ANAGRAFICA_GENERALE
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
          mv."COD_ABI_ISTITUTO",
          mv."COD_ABI_CARTOLARIZZATO",
          mv."COD_NDG",
          mv."COD_SNDG",
          mv."DESC_NOME_CONTROPARTE",
          mv."COD_GRUPPO_LEGAME",
          mv."COD_GRUPPO_ECONOMICO",
          mv."COD_GRUPPO_SUPER",
          mv."DTA_INTERCETTAMENTO",
          mv."COD_FILIALE",
          mv."COD_STRUTTURA_COMPETENTE",
          mv."COD_COMPARTO_HOST",
          mv."COD_RAMO_HOST",
          mv."COD_COMPARTO_CALCOLATO_PRE",
          mv."COD_COMPARTO_CALCOLATO",
          mv."COD_COMPARTO_ASSEGNATO_OLD",
          mv."COD_PERCORSO",
          mv."COD_PROCESSO_OLD",
          mv."COD_STATO_OLD",
          mv."DTA_DECORRENZA_STATO_OLD",
          mv."DTA_SCADENZA_STATO_OLD",
          mv."COD_STATO_PRECEDENTE_OLD",
          mv."COD_TIPO_INGRESSO",
          mv."ID_TRANSIZIONE",
          mv."DTA_PROCESSO",
          mv."ID_REFERENTE_OLD",
          mv."ID_UTENTE_OLD",
          mv."ID_UTENTE_PRE_OLD",
          mv."DTA_UTENTE_ASSEGNATO_OLD",
          mv."FLG_SOMMA",
          mv."FLG_RIPORTAFOGLIATO",
          mv."FLG_GRUPPO_ECONOMICO",
          mv."FLG_GRUPPO_LEGAME",
          mv."FLG_SINGOLO",
          mv."FLG_CONDIVISO",
          mv."SCSB_UTI_CASSA",
          mv."SCSB_UTI_FIRMA",
          mv."SCSB_ACC_CASSA",
          mv."SCSB_ACC_FIRMA",
          mv."SCSB_UTI_CASSA_BT",
          mv."SCSB_UTI_CASSA_MLT",
          mv."SCSB_UTI_SMOBILIZZO",
          mv."SCSB_UTI_FIRMA_DT",
          mv."SCSB_ACC_CASSA_BT",
          mv."SCSB_ACC_CASSA_MLT",
          mv."SCSB_ACC_SMOBILIZZO",
          mv."SCSB_ACC_FIRMA_DT",
          mv."SCSB_TOT_GAR",
          mv."SCSB_UTI_TOT",
          mv."SCSB_ACC_TOT",
          mv."SCSB_DTA_RIFERIMENTO",
          mv."SCSB_ACC_CONSEGNE",
          mv."SCSB_ACC_MASSIMALI",
          mv."SCSB_ACC_RISCHI_INDIRETTI",
          mv."SCSB_ACC_SOSTITUZIONI",
          mv."SCSB_UTI_CONSEGNE",
          mv."SCSB_UTI_MASSIMALI",
          mv."SCSB_UTI_RISCHI_INDIRETTI",
          mv."SCSB_UTI_SOSTITUZIONI",
          mv."GESB_UTI_CASSA",
          mv."GESB_UTI_FIRMA",
          mv."GESB_ACC_CASSA",
          mv."GESB_ACC_FIRMA",
          mv."GESB_UTI_CASSA_BT",
          mv."GESB_UTI_CASSA_MLT",
          mv."GESB_UTI_SMOBILIZZO",
          mv."GESB_UTI_FIRMA_DT",
          mv."GESB_ACC_CASSA_BT",
          mv."GESB_ACC_CASSA_MLT",
          mv."GESB_ACC_SMOBILIZZO",
          mv."GESB_ACC_FIRMA_DT",
          mv."GESB_TOT_GAR",
          mv."GESB_DTA_RIFERIMENTO",
          mv."GESB_ACC_CONSEGNE",
          mv."GESB_ACC_MASSIMALI",
          mv."GESB_ACC_RISCHI_INDIRETTI",
          mv."GESB_ACC_SOSTITUZIONI",
          mv."GESB_UTI_CONSEGNE",
          mv."GESB_UTI_MASSIMALI",
          mv."GESB_UTI_RISCHI_INDIRETTI",
          mv."GESB_UTI_SOSTITUZIONI",
          mv."SCGB_UTI_CASSA",
          mv."SCGB_UTI_FIRMA",
          mv."SCGB_ACC_CASSA",
          mv."SCGB_ACC_FIRMA",
          mv."SCGB_UTI_CASSA_BT",
          mv."SCGB_UTI_CASSA_MLT",
          mv."SCGB_UTI_SMOBILIZZO",
          mv."SCGB_UTI_FIRMA_DT",
          mv."SCGB_ACC_CASSA_BT",
          mv."SCGB_ACC_CASSA_MLT",
          mv."SCGB_ACC_SMOBILIZZO",
          mv."SCGB_ACC_FIRMA_DT",
          mv."SCGB_TOT_GAR",
          mv."SCGB_ACC_CONSEGNE",
          mv."SCGB_ACC_MASSIMALI",
          mv."SCGB_ACC_RISCHI_INDIRETTI",
          mv."SCGB_ACC_SOSTITUZIONI",
          mv."SCGB_UTI_CONSEGNE",
          mv."SCGB_UTI_MASSIMALI",
          mv."SCGB_UTI_RISCHI_INDIRETTI",
          mv."SCGB_UTI_SOSTITUZIONI",
          mv."GEGB_UTI_CASSA",
          mv."GEGB_UTI_FIRMA",
          mv."GEGB_ACC_CASSA",
          mv."GEGB_ACC_FIRMA",
          mv."GEGB_UTI_CASSA_BT",
          mv."GEGB_UTI_CASSA_MLT",
          mv."GEGB_UTI_SMOBILIZZO",
          mv."GEGB_UTI_FIRMA_DT",
          mv."GEGB_ACC_CASSA_BT",
          mv."GEGB_ACC_CASSA_MLT",
          mv."GEGB_ACC_SMOBILIZZO",
          mv."GEGB_ACC_FIRMA_DT",
          mv."GEGB_TOT_GAR",
          mv."GLGB_UTI_CASSA",
          mv."GLGB_UTI_FIRMA",
          mv."GLGB_ACC_CASSA",
          mv."GEGB_ACC_CONSEGNE",
          mv."GEGB_ACC_MASSIMALI",
          mv."GEGB_ACC_RISCHI_INDIRETTI",
          mv."GEGB_ACC_SOSTITUZIONI",
          mv."GEGB_UTI_CONSEGNE",
          mv."GEGB_UTI_MASSIMALI",
          mv."GEGB_UTI_RISCHI_INDIRETTI",
          mv."GEGB_UTI_SOSTITUZIONI",
          mv."GLGB_ACC_FIRMA",
          mv."GLGB_UTI_CASSA_BT",
          mv."GLGB_UTI_CASSA_MLT",
          mv."GLGB_UTI_SMOBILIZZO",
          mv."GLGB_UTI_FIRMA_DT",
          mv."GLGB_ACC_CASSA_BT",
          mv."GLGB_ACC_CASSA_MLT",
          mv."GLGB_ACC_SMOBILIZZO",
          mv."GLGB_ACC_FIRMA_DT",
          mv."GLGB_TOT_GAR",
          mv."GB_DTA_RIFERIMENTO",
          mv."GLGB_ACC_CONSEGNE",
          mv."GLGB_ACC_MASSIMALI",
          mv."GLGB_ACC_RISCHI_INDIRETTI",
          mv."GLGB_ACC_SOSTITUZIONI",
          mv."GLGB_UTI_CONSEGNE",
          mv."GLGB_UTI_MASSIMALI",
          mv."GLGB_UTI_RISCHI_INDIRETTI",
          mv."GLGB_UTI_SOSTITUZIONI",
          mv."GB_VAL_MAU",
          mv."VAL_LGD",
          mv."DTA_LGD",
          mv."VAL_EAD",
          mv."DTA_EAD",
          mv."VAL_PA",
          mv."DTA_PA",
          mv."VAL_PD_ONLINE",
          mv."DTA_PD_ONLINE",
          mv."VAL_RATING_ONLINE",
          mv."VAL_PD",
          mv."DTA_PD",
          mv."VAL_RATING",
          mv."VAL_IRIS_GE",
          mv."VAL_IRIS_CLI",
          mv."DTA_IRIS",
          mv."LIV_RISCHIO_GE",
          mv."LIV_RISCHIO_CLI",
          mv."VAL_SCONFINO",
          mv."COD_RAP",
          mv."VAL_SCONFINO_RAP",
          mv."FLG_ALLINEATO_SAG",
          mv."COD_SAG",
          mv."FLG_CONFERMA_SAG",
          mv."DTA_CONFERMA_SAG",
          mv."ID_DPER_FG",
          mv."COD_PEF",
          mv."COD_FASE_PEF",
          mv."DTA_ULTIMA_REVISIONE_PEF",
          mv."DTA_SCADENZA_FIDO",
          mv."DTA_ULTIMA_DELIBERA",
          mv."FLG_FIDI_SCADUTI",
          mv."DAT_ULTIMO_SCADUTO",
          mv."COD_ULTIMO_ODE",
          mv."COD_CTS_ULTIMO_ODE",
          mv."COD_STRATEGIA_CRZ",
          mv."COD_ODE",
          mv."DTA_COMPLETAMENTO_PEF",
          mv."COD_SERVIZIO_OLD",
          mv."DTA_SERVIZIO_OLD",
          mv."SCSB_ACC_CR",
          mv."SCSB_UTI_CR",
          mv."SCSB_GAR_CR",
          mv."SCSB_SCO_CR",
          mv."SCSB_QIS_ACC",
          mv."SCSB_QIS_UTI",
          mv."SCSB_DTA_CR",
          mv."SCGB_ACC_CR",
          mv."SCGB_ACC_SIS",
          mv."SCGB_GAR_CR",
          mv."SCGB_GAR_SIS",
          mv."SCGB_SCO_CR",
          mv."SCGB_SCO_SIS",
          mv."SCGB_UTI_CR",
          mv."SCGB_UTI_SIS",
          mv."SCGB_QIS_ACC",
          mv."SCGB_QIS_UTI",
          mv."SCGB_DTA_RIF_CR",
          mv."SCGB_DTA_STATO_SIS",
          mv."SCGB_COD_STATO_SIS",
          mv."SCGB_ID_DPER",
          mv."GESB_ACC_CR",
          mv."GESB_UTI_CR",
          mv."GESB_GAR_CR",
          mv."GESB_SCO_CR",
          mv."GESB_QIS_ACC",
          mv."GESB_QIS_UTI",
          mv."GESB_DTA_CR",
          mv."GEGB_ACC_CR",
          mv."GEGB_ACC_SIS",
          mv."GEGB_UTI_CR",
          mv."GEGB_UTI_SIS",
          mv."GEGB_GAR_CR",
          mv."GEGB_GAR_SIS",
          mv."GEGB_SCO_CR",
          mv."GEGB_SCO_SIS",
          mv."GEGB_QIS_ACC",
          mv."GEGB_QIS_UTI",
          mv."GEGB_DTA_RIF_CR",
          mv."GLGB_ACC_CR",
          mv."GLGB_UTI_CR",
          mv."GLGB_SCO_CR",
          mv."GLGB_GAR_CR",
          mv."GLGB_ACC_SIS",
          mv."GLGB_UTI_SIS",
          mv."GLGB_SCO_SIS",
          mv."GLGB_IMP_GAR_SIS",
          mv."GLGB_QIS_ACC",
          mv."GLGB_QIS_UTI",
          mv."GLGB_DTA_RIF_CR",
          f.cod_comparto_assegnato,
          f.id_utente,
          f.id_utente_pre,
          u.id_referente,
          f.dta_utente_assegnato,
          f.cod_servizio,
          f.dta_servizio,
          m.cod_processo,
          m.cod_stato,
          m.cod_stato_precedente,
          m.dta_decorrenza_stato,
          m.dta_scadenza_stato,
          m.cod_macrostato,
          m.dta_dec_macrostato
     FROM mcre_own.mv_mcre0_anagrafica_generale mv,
          mcre_own.t_mcre0_app_file_guida f,
          mcre_own.t_mcre0_app_utenti u,
          mcre_own.t_mcre0_app_mople m
    WHERE     mv.cod_abi_cartolarizzato = f.cod_abi_cartolarizzato
          AND mv.cod_ndg = f.cod_ndg
          AND f.id_utente = u.id_utente(+)
          AND mv.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato(+)
          AND mv.cod_ndg = m.cod_ndg(+);
