/* Formatted on 17/06/2014 18:13:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_POS_DA_RIASS
(
   ID_ALERT,
   VAL_ORDINE_COLORE,
   DESC_ALERT,
   VAL_ALERT,
   DTA_INS_ALERT,
   COD_COMPARTO,
   COD_RAMO_CALCOLATO,
   DESC_COMPARTO,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_SUPER,
   VAL_ANA_GRE,
   COD_LEGAME,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_SINGOLO,
   FLG_CONDIVISO,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_PROCESSO_PRE,
   COD_PROCESSO,
   COD_STATO_PRECEDENTE,
   COD_STATO,
   COD_MACROSTATO,
   DTA_DECORRENZA_STATO,
   DESC_ISTITUTO,
   FLG_OUTSOURCING,
   ID_UTENTE,
   ID_REFERENTE,
   DESC_COGNOME,
   COD_MATR_ASSEGNATORE,
   ID_UTENTE_PREASSEGNATO,
   DESC_COGNOME_PREASS,
   DESC_NOME_PREASS,
   COD_COMPARTO_PREASSEGNATO,
   DESC_COMPARTO_PREASS,
   COD_SEZIONE_PREASSEGNATA,
   FLG_ABI_LAVORATO
)
AS
   SELECT                                -- v1 08/06/2011 VG: Tolta file_guida
         DISTINCT
          4 ID_ALERT,
          (SELECT DECODE (
                     ALERT_4,
                     'V', VAL_VERDE,
                     DECODE (ALERT_4,
                             'A', VAL_ARANCIO,
                             DECODE (ALERT_4, 'R', VAL_ROSSO, NULL)))
             FROM T_MCRE0_APP_ALERT
            WHERE ID_ALERT = 4)
             VAL_ORDINE_COLORE,
          (SELECT R.DESC_ALERT
             FROM T_MCRE0_APP_ALERT R
            WHERE R.ID_ALERT = 4)
             DESC_ALERT,
          P.ALERT_4 VAL_ALERT,
          P.DTA_INS_4 DTA_INS_ALERT,
          X.COD_COMPARTO,
          X.COD_RAMO_CALCOLATO,
          CO.DESC_COMPARTO,
          X.COD_ABI_ISTITUTO,
          X.COD_ABI_CARTOLARIZZATO,
          X.COD_NDG,
          X.COD_SNDG,
          A.DESC_NOME_CONTROPARTE,
          X.COD_GRUPPO_ECONOMICO,
          X.COD_GRUPPO_SUPER,
          GE.VAL_ANA_GRE,
          LE.COD_LEGAME,
          X.FLG_GRUPPO_ECONOMICO,
          X.FLG_GRUPPO_LEGAME,
          X.FLG_SINGOLO,
          X.FLG_CONDIVISO,
          S.COD_STRUTTURA_COMPETENTE_DC,
          S.DESC_STRUTTURA_COMPETENTE_DC,
          S.COD_STRUTTURA_COMPETENTE_RG,
          S.DESC_STRUTTURA_COMPETENTE_RG,
          S.COD_STRUTTURA_COMPETENTE_AR,
          S.DESC_STRUTTURA_COMPETENTE_AR,
          S.COD_STRUTTURA_COMPETENTE_FI,
          S.DESC_STRUTTURA_COMPETENTE_FI,
          X.COD_PROCESSO_PRE,
          X.COD_PROCESSO,
          X.COD_STATO_PRECEDENTE,
          X.COD_STATO,
          X.COD_MACROSTATO,
          X.DTA_DECORRENZA_STATO,
          I.DESC_ISTITUTO,
          I.FLG_OUTSOURCING,
          X.ID_UTENTE,
          P.ID_REFERENTE,
          U.COGNOME DESC_COGNOME,
          X.COD_MATR_ASSEGNATORE,
          X.ID_UTENTE_PREASSEGNATO,
          U2.COGNOME DESC_COGNOME_PREASS,
          U2.NOME DESC_NOME_PREASS,
          X.COD_COMPARTO_PREASSEGNATO,
          CO2.DESC_COMPARTO DESC_COMPARTO_PREASS,
          X.COD_SEZIONE_PREASSEGNATA,
          I.FLG_ABI_LAVORATO
     FROM MCRE_OWN.MV_MCRE0_APP_UPD_FIELD X,
          MCRE_OWN.T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
          MCRE_OWN.MV_MCRE0_DENORM_STR_ORG S,
          MCRE_OWN.MV_MCRE0_APP_ISTITUTI I,
          MCRE_OWN.T_MCRE0_APP_COMPARTI CO,
          MCRE_OWN.T_MCRE0_APP_COMPARTI CO2,
          MCRE_OWN.V_MCRE0_APP_ALERT_POS P,
          MCRE_OWN.T_MCRE0_APP_ANAGR_GRE GE,
          MCRE_OWN.T_MCRE0_APP_GRUPPO_LEGAME LE,
          MCRE_OWN.T_MCRE0_APP_UTENTI U,
          MCRE_OWN.T_MCRE0_APP_UTENTI U2
    WHERE     CO.COD_COMPARTO = X.COD_COMPARTO
          AND CO.FLG_CHK = 1
          AND X.COD_COMPARTO_PREASSEGNATO = CO2.COD_COMPARTO(+)
          AND P.ALERT_4 IS NOT NULL
          AND X.COD_ABI_CARTOLARIZZATO = X.COD_ABI_CARTOLARIZZATO
          AND X.COD_NDG = X.COD_NDG
          AND X.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO
          AND X.COD_NDG = P.COD_NDG
          AND X.ID_UTENTE = U.ID_UTENTE(+)
          AND X.ID_UTENTE_PREASSEGNATO = U2.ID_UTENTE(+)
          AND X.COD_SNDG = A.COD_SNDG(+)
          AND X.COD_GRUPPO_ECONOMICO = GE.COD_GRE(+)
          AND X.COD_SNDG = LE.COD_SNDG(+)
          AND X.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO_FI(+)
          AND X.COD_FILIALE = S.COD_STRUTTURA_COMPETENTE_FI(+)
          AND X.COD_ABI_CARTOLARIZZATO = I.COD_ABI(+)
          AND X.COD_STATO IN (SELECT COD_MICROSTATO
                                FROM T_MCRE0_APP_STATI S
                               WHERE S.FLG_STATO_CHK = 1);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.VOMCRE0_APP_POS_DA_RIASS TO MCRE_USR;
