/* Formatted on 17/06/2014 17:59:53 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ALL_DATA_INACTIVE
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
   SCSB_UTI_SOSTITUZIONI
)
AS
   SELECT '0' TODAY_FLG,
          '0' FLG_ACTIVE,
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
          SCSB_UTI_SOSTITUZIONI
     FROM T_MCRE0_ALL_DATA_INACTIVE;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ALL_DATA_INACTIVE TO MCRE_USR;
