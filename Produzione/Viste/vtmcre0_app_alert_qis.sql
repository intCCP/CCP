/* Formatted on 17/06/2014 18:15:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_ALERT_QIS
(
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   DTA_INS_ALERT,
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_COMPARTO_POSIZIONE,
   COD_MACROSTATO,
   COD_COMPARTO_UTENTE,
   COD_RAMO_CALCOLATO,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_PROCESSO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   FLG_ABI_LAVORATO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   ID_REFERENTE,
   FLG_GESTORE_ABILITATO,
   VAL_QIS_ATTUALE,
   VAL_QIS_PC,
   DTA_RIFERIMENTO_CR_LAST
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(p)*/
                                                    -- v1 28/04/2011 VG: Nuova
                                           -- v2 06/05/2011 VG: COD_MACROSTATO
                                             -- v3 24/06/2011 VG: SCGB_QIS_UTI
                                           -- 111104 MM: aggiunto id_referente
         ALERT_25 VAL_ALERT,
         (SELECT DECODE (
                    ALERT_25,
                    'V', VAL_VERDE,
                    DECODE (ALERT_25,
                            'A', VAL_ARANCIO,
                            DECODE (ALERT_25, 'R', VAL_ROSSO, NULL)))
            FROM T_MCRE0_APP_ALERT
           WHERE ID_ALERT = 25)
            VAL_ORDINE_COLORE,
         DTA_INS_25 DTA_INS_ALERT,
         A.COD_SNDG,
         A.COD_ABI_CARTOLARIZZATO,
         A.COD_ABI_ISTITUTO,
         X.DESC_ISTITUTO,
         A.COD_NDG,
         X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
         X.COD_MACROSTATO,
         X.COD_COMPARTO_UTENTE,
         X.COD_RAMO_CALCOLATO,
         X.DESC_NOME_CONTROPARTE,
         X.COD_GRUPPO_ECONOMICO,
         X.DESC_GRUPPO_ECONOMICO VAL_ANA_GRE,
         X.COD_STRUTTURA_COMPETENTE_DC,
         X.DESC_STRUTTURA_COMPETENTE_DC,
         X.COD_STRUTTURA_COMPETENTE_RG,
         X.DESC_STRUTTURA_COMPETENTE_RG,
         X.COD_STRUTTURA_COMPETENTE_AR,
         X.DESC_STRUTTURA_COMPETENTE_AR,
         X.COD_STRUTTURA_COMPETENTE_FI,
         X.DESC_STRUTTURA_COMPETENTE_FI,
         X.COD_PROCESSO,
         X.COD_STATO,
         X.DTA_DECORRENZA_STATO,
         X.DTA_SCADENZA_STATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO,
         X.ID_UTENTE,
         X.DTA_UTENTE_ASSEGNATO,
         X.NOME DESC_NOME,
         X.COGNOME DESC_COGNOME,
         X.ID_REFERENTE,
         X.FLG_GESTORE_ABILITATO,
         P.SCGB_QIS_UTI VAL_QIS_ATTUALE,
         C.SCGB_QIS_UTI VAL_QIS_PC,
         P.SCGB_DTA_RIF_CR DTA_RIFERIMENTO_CR_LAST
    FROM T_MCRE0_APP_ALERT_POS A,
         VTMCRE0_APP_UPD_FIELDS X,
         T_MCRE0_APP_CR P,
         V_MCRE0_APP_SCHEDA_ANAG_SC_PC C
   WHERE     ALERT_25 IS NOT NULL
         AND X.FLG_OUTSOURCING = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = A.COD_NDG
         AND A.COD_ABI_CARTOLARIZZATO = C.COD_ABI_CARTOLARIZZATO
         AND A.COD_NDG = C.COD_NDG
         AND A.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO
         AND A.COD_NDG = P.COD_NDG;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_ALERT_QIS TO MCRE_USR;
