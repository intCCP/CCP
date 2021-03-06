/* Formatted on 21/07/2014 18:36:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_UPD_FIELDS_P0_OLD
(
   TODAY_FLG,
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
   COD_COMPARTO_CALCOLATO_PRE,
   COD_COMPARTO_CALCOLATO,
   COD_COMPARTO_ASSEGNATO,
   COD_COMPARTO,
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
   DTA_INS,
   DTA_UPD,
   COD_MACROSTATO_PROPOSTO,
   DTA_RIF_PD_ONLINE,
   VAL_RATING_ONLINE,
   VAL_PD_ONLINE,
   FLG_SOURCE,
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
   SELECT TODAY_FLG,
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
          COD_COMPARTO_CALCOLATO_PRE,
          COD_COMPARTO_CALCOLATO,
          COD_COMPARTO_ASSEGNATO,
          NVL (COD_COMPARTO_ASSEGNATO, COD_COMPARTO_CALCOLATO) COD_COMPARTO,
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
          CASE WHEN FLG_SOURCE = '0' THEN COD_MACROSTATO ELSE 'GB' END
             COD_MACROSTATO,
          CASE
             WHEN FLG_SOURCE = '0' THEN DTA_DEC_MACROSTATO
             ELSE DTA_INS_GB
          END
             DTA_DEC_MACROSTATO,
          DTA_INTERCETTAMENTO,
          CASE
             WHEN FLG_SOURCE = '0' THEN COD_STATO_PRECEDENTE
             ELSE COD_STATO
          END
             COD_STATO_PRECEDENTE,
          CASE WHEN FLG_SOURCE = '0' THEN NVL (COD_STATO, '-1') ELSE 'GB' END
             COD_STATO,
          CASE
             WHEN FLG_SOURCE = '0' THEN DTA_DECORRENZA_STATO
             ELSE DTA_INS_GB
          END
             DTA_DECORRENZA_STATO,
          CASE
             WHEN FLG_SOURCE = '0' THEN DTA_DECORRENZA_STATO_PRE
             ELSE DTA_DECORRENZA_STATO
          END
             DTA_DECORRENZA_STATO_PRE,
          CASE
             WHEN FLG_SOURCE = '0' THEN DTA_SCADENZA_STATO
             ELSE TO_DATE ('31/12/9999', 'DD/MM/YYYY')
          END
             DTA_SCADENZA_STATO,
          CASE
             WHEN FLG_SOURCE = '0' THEN COD_PROCESSO_PRE
             ELSE COD_PROCESSO
          END
             COD_PROCESSO_PRE,
          CASE
             WHEN FLG_SOURCE = '0' THEN COD_PROCESSO
             ELSE COD_PROCESSO_CALCOLATO_GB
          END
             COD_PROCESSO,
          COD_PROCESSO_CALCOLATO_GB COD_PROCESSO_CALCOLATO,
          CASE WHEN FLG_SOURCE = '0' THEN DTA_PROCESSO ELSE DTA_INS_GB END
             DTA_PROCESSO,
          COD_GESTORE_MKT,
          DESC_ANAG_GESTORE_MKT,
          COD_PERCORSO,
          CASE
             WHEN FLG_SOURCE = '0' THEN NVL (COD_FILIALE, '-')
             ELSE COD_FILIALE_GB
          END
             COD_FILIALE,
          ID_DPERFG ID_DPER,
          ID_TRANSIZIONE,
          FLG_OUTSOURCING,
          CASE WHEN FLG_SOURCE = '0' THEN DTA_INS ELSE DTA_INS_GB END DTA_INS,
          DTA_UPD,
          COD_MACROSTATO_PROPOSTO_GB COD_MACROSTATO_PROPOSTO,
          DTA_RIF_PD_ONLINE,
          VAL_RATING_ONLINE,
          VAL_PD_ONLINE,
          FLG_SOURCE,
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
     FROM T_MCRE0_APP_ALL_DATA PARTITION (CCP_P0);
