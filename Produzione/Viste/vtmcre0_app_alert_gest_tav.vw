/* Formatted on 17/06/2014 18:14:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_ALERT_GEST_TAV
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
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   ID_REFERENTE,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   DTA_SERVIZIO,
   DTA_LIMITE_PROROGA,
   FLG_ABI_LAVORATO
)
AS
   SELECT /*+ordered no_parallel(a)  */
                                           -- v1 06/05/2011 VG: COD_MACROSTATO
                                           -- v2 24/05/2011 VG: limite proroga
         ALERT_21 VAL_ALERT,
         (SELECT DECODE (
                    ALERT_21,
                    'V', VAL_VERDE,
                    DECODE (ALERT_21,
                            'A', VAL_ARANCIO,
                            DECODE (ALERT_21, 'R', VAL_ROSSO, NULL)))
            FROM T_MCRE0_APP_ALERT
           WHERE ID_ALERT = 21)
            VAL_ORDINE_COLORE,
         DTA_INS_21 DTA_INS_ALERT,
         A.COD_SNDG,
         A.COD_ABI_CARTOLARIZZATO,
         A.COD_ABI_ISTITUTO,
         X.DESC_ISTITUTO,
         A.COD_NDG,
         X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
         X.COD_MACROSTATO,
         -- NVL (u.cod_comparto_assegn, u.cod_comparto_appart) cod_comparto_utente
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
         X.ID_UTENTE,
         X.DTA_UTENTE_ASSEGNATO,
         X.NOME DESC_NOME,
         X.COGNOME DESC_COGNOME,
         X.ID_REFERENTE,
         X.COD_PRIV,
         X.FLG_GESTORE_ABILITATO,
         X.DTA_SERVIZIO,
         X.DTA_SERVIZIO + X.VAL_GG_PRIMA_PROROGA DTA_LIMITE_PROROGA,
         --x.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO
    FROM T_MCRE0_APP_ALERT_POS A,                  -- MV_MCRE0_app_istituti i,
                                  -- t_mcre0_app_anagrafica_gruppo g,
                                  --MV_MCRE0_APP_UPD_field x,
                                  -- t_mcre0_app_anagr_gre ge,
                                  -- MV_MCRE0_denorm_str_org s,
                                  -- t_mcre0_app_utenti u,
                                  -- t_mcre0_app_comparti c,
                                  --  V_MCRE0_APP_UPD_FIELDS_ALL x
                                  -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
                                  VTMCRE0_APP_UPD_FIELDS X
   WHERE     ALERT_21 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = A.COD_NDG;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_ALERT_GEST_TAV TO MCRE_USR;
