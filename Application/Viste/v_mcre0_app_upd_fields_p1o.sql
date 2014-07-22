/* Formatted on 21/07/2014 18:36:28 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_UPD_FIELDS_P1O
(
   TODAY_FLG,
   P_ROWID,
   U_ROWID,
   M_ROWID,
   GB_ROWID,
   A_ROWID,
   GE_ROWID,
   I_ROWID,
   G_ROWID,
   E_ROWID,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   DESC_BREVE,
   FLG_TARGET,
   FLG_CARTOLARIZZATO,
   DTA_ABI_ELAB,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_STRUTTURA_COMPETENTE,
   COD_COMPARTO,
   COD_COMPARTO_CALCOLATO,
   COD_COMPARTO_CALCOLATO_PRE,
   COD_COMPARTO_ASSEGNATO,
   COD_COMPARTO_PREASSEGNATO,
   COD_OPERATORE_INS_UPD,
   ID_UTENTE_PREASSEGNATO,
   COD_GRUPPO_LEGAME,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_SINGOLO,
   FLG_CONDIVISO,
   COD_SEZIONE_PREASSEGNATA,
   COD_MATR_ASSEGNATORE,
   ID_UTENTE_PRE,
   ID_UTENTE,
   NOME,
   COGNOME,
   COD_MATRICOLA,
   ID_REFERENTE,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   COD_COMPARTO_UTENTE,
   COD_COMPARTO_ASSEGN,
   COD_COMPARTO_APPART,
   DTA_UTENTE_ASSEGNATO,
   FLG_SOMMA,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_RAMO_CALCOLATO,
   DTA_LAST_RIPORTAF,
   FLG_RIPORTAFOGLIATO,
   FLG_GESTIONE_ESTERNA,
   COD_TIPO_PORTAFOGLIO,
   COD_SERVIZIO,
   DTA_SERVIZIO,
   COD_GRUPPO_SUPER,
   FLG_ACTIVE,
   COD_MACROSTATO,
   DTA_DEC_MACROSTATO,
   DTA_INTERCETTAMENTO,
   COD_STATO_PRECEDENTE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_DECORRENZA_STATO_PRE,
   DTA_SCADENZA_STATO,
   COD_PROCESSO_PRE,
   COD_PROCESSO,
   COD_PROCESSO_CALCOLATO,
   DTA_PROCESSO,
   COD_GESTORE_MKT,
   DESC_ANAG_GESTORE_MKT,
   COD_PERCORSO,
   COD_FILIALE,
   ID_DPER,
   ID_TRANSIZIONE,
   FLG_OUTSOURCING,
   COD_MACROSTATO_PROPOSTO,
   DTA_INS,
   DTA_UPD,
   DTA_STATO,
   DTA_INVIO,
   COD_COMPARTO_PROPOSTO,
   ID_OD,
   FLG_STATO,
   DESC_MOTIVO_ANNULLO,
   DESC_STRUTTURA_DISP,
   DTA_RIF_PD_ONLINE,
   VAL_RATING_ONLINE,
   VAL_PD_ONLINE,
   FLG_SOURCE,
   MARKER,
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
   GLGB_UTI_FIRMA
)
AS
   SELECT "TODAY_FLG",
          "P_ROWID",
          "U_ROWID",
          "M_ROWID",
          "GB_ROWID",
          "A_ROWID",
          "GE_ROWID",
          "I_ROWID",
          "G_ROWID",
          "E_ROWID",
          "COD_ABI_CARTOLARIZZATO",
          "COD_NDG",
          "COD_ABI_ISTITUTO",
          "DESC_ISTITUTO",
          "DESC_BREVE",
          "FLG_TARGET",
          "FLG_CARTOLARIZZATO",
          "DTA_ABI_ELAB",
          "COD_SNDG",
          "DESC_NOME_CONTROPARTE",
          "COD_STRUTTURA_COMPETENTE",
          "COD_COMPARTO",
          "COD_COMPARTO_CALCOLATO",
          "COD_COMPARTO_CALCOLATO_PRE",
          "COD_COMPARTO_ASSEGNATO",
          "COD_COMPARTO_PREASSEGNATO",
          "COD_OPERATORE_INS_UPD",
          "ID_UTENTE_PREASSEGNATO",
          "COD_GRUPPO_LEGAME",
          "FLG_GRUPPO_ECONOMICO",
          "FLG_GRUPPO_LEGAME",
          "FLG_SINGOLO",
          "FLG_CONDIVISO",
          "COD_SEZIONE_PREASSEGNATA",
          "COD_MATR_ASSEGNATORE",
          "ID_UTENTE_PRE",
          "ID_UTENTE",
          "NOME",
          "COGNOME",
          "COD_MATRICOLA",
          "ID_REFERENTE",
          "COD_PRIV",
          "FLG_GESTORE_ABILITATO",
          "COD_COMPARTO_UTENTE",
          "COD_COMPARTO_ASSEGN",
          "COD_COMPARTO_APPART",
          "DTA_UTENTE_ASSEGNATO",
          "FLG_SOMMA",
          "COD_GRUPPO_ECONOMICO",
          "DESC_GRUPPO_ECONOMICO",
          "COD_RAMO_CALCOLATO",
          "DTA_LAST_RIPORTAF",
          "FLG_RIPORTAFOGLIATO",
          "FLG_GESTIONE_ESTERNA",
          "COD_TIPO_PORTAFOGLIO",
          "COD_SERVIZIO",
          "DTA_SERVIZIO",
          "COD_GRUPPO_SUPER",
          "FLG_ACTIVE",
          "COD_MACROSTATO",
          "DTA_DEC_MACROSTATO",
          "DTA_INTERCETTAMENTO",
          "COD_STATO_PRECEDENTE",
          "COD_STATO",
          "DTA_DECORRENZA_STATO",
          "DTA_DECORRENZA_STATO_PRE",
          "DTA_SCADENZA_STATO",
          "COD_PROCESSO_PRE",
          "COD_PROCESSO",
          "COD_PROCESSO_CALCOLATO",
          "DTA_PROCESSO",
          "COD_GESTORE_MKT",
          "DESC_ANAG_GESTORE_MKT",
          "COD_PERCORSO",
          "COD_FILIALE",
          "ID_DPER",
          "ID_TRANSIZIONE",
          "FLG_OUTSOURCING",
          "COD_MACROSTATO_PROPOSTO",
          "DTA_INS",
          "DTA_UPD",
          "DTA_STATO",
          "DTA_INVIO",
          "COD_COMPARTO_PROPOSTO",
          "ID_OD",
          "FLG_STATO",
          "DESC_MOTIVO_ANNULLO",
          "DESC_STRUTTURA_DISP",
          "DTA_RIF_PD_ONLINE",
          "VAL_RATING_ONLINE",
          "VAL_PD_ONLINE",
          "FLG_SOURCE",
          "MARKER",
          "SCSB_UTI_TOT",
          "SCSB_ACC_TOT",
          "SCSB_UTI_CASSA",
          "SCSB_UTI_FIRMA",
          "SCSB_ACC_CASSA",
          "SCSB_ACC_FIRMA",
          "GB_VAL_MAU",
          "GEGB_ACC_CASSA",
          "GEGB_ACC_FIRMA",
          "GEGB_UTI_CASSA",
          "GEGB_UTI_FIRMA",
          "GLGB_ACC_CASSA",
          "GLGB_ACC_FIRMA",
          "GLGB_UTI_CASSA",
          "GLGB_UTI_FIRMA"
     FROM MV_MCRE0_APP_UPD_FIELDS PARTITION (CCP_P1);