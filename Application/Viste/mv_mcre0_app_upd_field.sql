/* Formatted on 21/07/2014 18:30:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.MV_MCRE0_APP_UPD_FIELD
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_COMPARTO,
   COD_COMPARTO_CALCOLATO,
   COD_COMPARTO_CALCOLATO_PRE,
   COD_COMPARTO_PREASSEGNATO,
   COD_FILIALE,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_LEGAME,
   COD_GRUPPO_SUPER,
   COD_MACROSTATO,
   COD_MACROSTATO_PROPOSTO,
   COD_MATR_ASSEGNATORE,
   COD_NDG,
   COD_OPERATORE_INS_UPD,
   COD_PERCORSO,
   COD_PROCESSO,
   COD_PROCESSO_PRE,
   COD_RAMO_CALCOLATO,
   COD_SEZIONE_PREASSEGNATA,
   COD_SNDG,
   COD_STATO,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO,
   DTA_DECORRENZA_STATO_PRE,
   DTA_DEC_MACROSTATO,
   DTA_INS,
   DTA_LAST_RIPORTAF,
   DTA_PROCESSO,
   DTA_SCADENZA_STATO,
   DTA_SERVIZIO,
   DTA_UTENTE_ASSEGNATO,
   FLG_CONDIVISO,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_OUTSOURCING,
   FLG_RIPORTAFOGLIATO,
   FLG_SINGOLO,
   FLG_SOMMA,
   FLG_SOURCE,
   ID_DPER,
   ID_TRANSIZIONE,
   ID_UTENTE,
   ID_UTENTE_PRE,
   ID_UTENTE_PREASSEGNATO
)
AS
   SELECT COD_ABI_CARTOLARIZZATO,
          COD_ABI_ISTITUTO,
          COD_COMPARTO,
          COD_COMPARTO_CALCOLATO,
          COD_COMPARTO_CALCOLATO_PRE,
          COD_COMPARTO_PREASSEGNATO,
          COD_FILIALE,
          COD_GRUPPO_ECONOMICO,
          COD_GRUPPO_LEGAME,
          COD_GRUPPO_SUPER,
          COD_MACROSTATO,
          COD_MACROSTATO_PROPOSTO,
          COD_MATR_ASSEGNATORE,
          COD_NDG,
          COD_OPERATORE_INS_UPD,
          COD_PERCORSO,
          COD_PROCESSO,
          COD_PROCESSO_PRE,
          COD_RAMO_CALCOLATO,
          COD_SEZIONE_PREASSEGNATA,
          COD_SNDG,
          COD_STATO,
          COD_STATO_PRECEDENTE,
          DTA_DECORRENZA_STATO,
          DTA_DECORRENZA_STATO_PRE,
          DTA_DEC_MACROSTATO,
          DTA_INS,
          DTA_LAST_RIPORTAF,
          DTA_PROCESSO,
          DTA_SCADENZA_STATO,
          DTA_SERVIZIO,
          DTA_UTENTE_ASSEGNATO,
          FLG_CONDIVISO,
          FLG_GRUPPO_ECONOMICO,
          FLG_GRUPPO_LEGAME,
          FLG_OUTSOURCING,
          FLG_RIPORTAFOGLIATO,
          FLG_SINGOLO,
          FLG_SOMMA,
          FLG_SOURCE,
          ID_DPER,
          ID_TRANSIZIONE,
          NULLIF (ID_UTENTE, -1) ID_UTENTE,
          NULLIF (ID_UTENTE_PRE, -1) ID_UTENTE_PRE,
          ID_UTENTE_PREASSEGNATO
     FROM V_MCRE0_APP_UPD_FIELDS;
