/* Formatted on 17/06/2014 18:05:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_POS_MANCANTI
(
   TODAY_FLG,
   FLG_ACTIVE,
   FLG_SOURCE,
   FLG_BLOCCO,
   ID_DPERFG,
   ID_DPERMO,
   COD_NDG,
   COD_ABI_CARTOLARIZZATO,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   DESC_BREVE,
   FLG_TARGET,
   FLG_CARTOLARIZZATO,
   DTA_ABI_ELAB,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_GRUPPO_LEGAME,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_SINGOLO,
   FLG_CONDIVISO,
   FLG_SOMMA,
   FLG_OUTSOURCING,
   COD_FILIALE,
   COD_STRUTTURA_COMPETENTE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO_PRE,
   DTA_INTERCETTAMENTO,
   COD_TIPO_INGRESSO,
   COD_CAUSALE_INGRESSO,
   COD_PERCORSO,
   COD_PROCESSO,
   DTA_PROCESSO,
   COD_PROCESSO_PRE,
   COD_MACROSTATO,
   DTA_DEC_MACROSTATO,
   COD_RAMO_CALCOLATO,
   COD_COMPARTO_CALCOLATO,
   DTA_COMPARTO_CALCOLATO,
   COD_COMPARTO_CALCOLATO_PRE,
   COD_GRUPPO_SUPER,
   COD_GRUPPO_SUPER_OLD,
   FLG_RIPORTAFOGLIATO,
   DTA_LAST_RIPORTAF,
   DTA_UTENTE_ASSEGNATO,
   COD_COMPARTO_ASSEGNATO,
   ID_UTENTE,
   ID_UTENTE_PRE,
   COD_SERVIZIO,
   DTA_SERVIZIO,
   ID_STATO_POSIZIONE,
   COD_CLIENTE_ESTESO,
   ID_CLIENTE_ESTESO,
   DESC_ANAG_GESTORE_MKT,
   COD_GESTORE_MKT,
   COD_TIPO_PORTAFOGLIO,
   FLG_GESTIONE_ESTERNA,
   VAL_PERC_DECURTAZIONE,
   COD_COMPARTO_HOST,
   ID_TRANSIZIONE,
   COD_RAMO_HOST,
   COD_MATR_RISCHIO,
   COD_UO_RISCHIO,
   COD_DISP_RISCHIO,
   DTA_INS,
   DTA_UPD,
   COD_OPERATORE_INS_UPD,
   COD_MATR_ASSEGNATORE,
   COD_SEZIONE_PREASSEGNATA,
   ID_UTENTE_PREASSEGNATO,
   COD_COMPARTO_PREASSEGNATO,
   COD_PROCESSO_PREASSEGNATO,
   FLG_STATO_GB,
   COD_FILIALE_GB,
   COD_PROCESSO_CALCOLATO_GB,
   COD_MACROSTATO_PROPOSTO_GB,
   DTA_INS_GB,
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
   FLG_BLOCCO_ABI,
   FLG_BLOCCO_SNDG,
   FLG_BLOCCO_GRUPPO
)
AS
   SELECT f."TODAY_FLG",
          f."FLG_ACTIVE",
          f."FLG_SOURCE",
          f."FLG_BLOCCO",
          f."ID_DPERFG",
          f."ID_DPERMO",
          f."COD_NDG",
          f."COD_ABI_CARTOLARIZZATO",
          f."COD_SNDG",
          f."DESC_NOME_CONTROPARTE",
          f."COD_ABI_ISTITUTO",
          f."DESC_ISTITUTO",
          f."DESC_BREVE",
          f."FLG_TARGET",
          f."FLG_CARTOLARIZZATO",
          f."DTA_ABI_ELAB",
          f."COD_GRUPPO_ECONOMICO",
          f."DESC_GRUPPO_ECONOMICO",
          f."COD_GRUPPO_LEGAME",
          f."FLG_GRUPPO_ECONOMICO",
          f."FLG_GRUPPO_LEGAME",
          f."FLG_SINGOLO",
          f."FLG_CONDIVISO",
          f."FLG_SOMMA",
          f."FLG_OUTSOURCING",
          f."COD_FILIALE",
          f."COD_STRUTTURA_COMPETENTE",
          f."COD_STATO",
          f."DTA_DECORRENZA_STATO",
          f."DTA_SCADENZA_STATO",
          f."COD_STATO_PRECEDENTE",
          f."DTA_DECORRENZA_STATO_PRE",
          f."DTA_INTERCETTAMENTO",
          f."COD_TIPO_INGRESSO",
          f."COD_CAUSALE_INGRESSO",
          f."COD_PERCORSO",
          f."COD_PROCESSO",
          f."DTA_PROCESSO",
          f."COD_PROCESSO_PRE",
          f."COD_MACROSTATO",
          f."DTA_DEC_MACROSTATO",
          f."COD_RAMO_CALCOLATO",
          f."COD_COMPARTO_CALCOLATO",
          f."DTA_COMPARTO_CALCOLATO",
          f."COD_COMPARTO_CALCOLATO_PRE",
          f."COD_GRUPPO_SUPER",
          f."COD_GRUPPO_SUPER_OLD",
          f."FLG_RIPORTAFOGLIATO",
          f."DTA_LAST_RIPORTAF",
          f."DTA_UTENTE_ASSEGNATO",
          f."COD_COMPARTO_ASSEGNATO",
          f."ID_UTENTE",
          f."ID_UTENTE_PRE",
          f."COD_SERVIZIO",
          f."DTA_SERVIZIO",
          f."ID_STATO_POSIZIONE",
          f."COD_CLIENTE_ESTESO",
          f."ID_CLIENTE_ESTESO",
          f."DESC_ANAG_GESTORE_MKT",
          f."COD_GESTORE_MKT",
          f."COD_TIPO_PORTAFOGLIO",
          f."FLG_GESTIONE_ESTERNA",
          f."VAL_PERC_DECURTAZIONE",
          f."COD_COMPARTO_HOST",
          f."ID_TRANSIZIONE",
          f."COD_RAMO_HOST",
          f."COD_MATR_RISCHIO",
          f."COD_UO_RISCHIO",
          f."COD_DISP_RISCHIO",
          f."DTA_INS",
          f."DTA_UPD",
          f."COD_OPERATORE_INS_UPD",
          f."COD_MATR_ASSEGNATORE",
          f."COD_SEZIONE_PREASSEGNATA",
          f."ID_UTENTE_PREASSEGNATO",
          f."COD_COMPARTO_PREASSEGNATO",
          f."COD_PROCESSO_PREASSEGNATO",
          f."FLG_STATO_GB",
          f."COD_FILIALE_GB",
          f."COD_PROCESSO_CALCOLATO_GB",
          f."COD_MACROSTATO_PROPOSTO_GB",
          f."DTA_INS_GB",
          f."DTA_RIF_PD_ONLINE",
          f."VAL_RATING_ONLINE",
          f."VAL_PD_ONLINE",
          f."SCSB_UTI_TOT",
          f."SCSB_ACC_TOT",
          f."SCSB_UTI_CASSA",
          f."SCSB_UTI_FIRMA",
          f."SCSB_ACC_CASSA",
          f."SCSB_ACC_FIRMA",
          f."GB_VAL_MAU",
          f."GEGB_ACC_CASSA",
          f."GEGB_ACC_FIRMA",
          f."GEGB_UTI_CASSA",
          f."GEGB_UTI_FIRMA",
          f."GLGB_ACC_CASSA",
          f."GLGB_ACC_FIRMA",
          f."GLGB_UTI_CASSA",
          f."GLGB_UTI_FIRMA",
          f."SCSB_ACC_SOSTITUZIONI",
          f."SCSB_UTI_SOSTITUZIONI",
          '1' flg_blocco_abi,
          '1' flg_blocco_sndg,
          '1' flg_blocco_gruppo
     FROM t_mcre0_all_data f, v_mcre0_abi_mancanti a
    WHERE f.flg_active = '1' AND f.cod_abi_istituto = a.cod_abi_istituto;


GRANT SELECT ON MCRE_OWN.V_MCRE0_POS_MANCANTI TO MCRE_USR;