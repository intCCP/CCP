/* Formatted on 17/06/2014 18:00:56 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_SO_SISTEMA
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
   ID_REFERENTE,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   FLG_GESTORE_ABILITATO,
   COD_STATO_SIS,
   DTA_RIFERIMENTO_CR,
   VAL_UTI_TOT
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(cr)*/
                                                    -- v1 26/04/2011 VG: Nuova
                                           -- v2 06/05/2011 VG: COD_MACROSTATO
         ALERT_22 VAL_ALERT,
         (SELECT DECODE (
                    ALERT_22,
                    'V', VAL_VERDE,
                    DECODE (ALERT_22,
                            'A', VAL_ARANCIO,
                            DECODE (ALERT_22, 'R', VAL_ROSSO, NULL)))
            FROM T_MCRE0_APP_ALERT
           WHERE ID_ALERT = 22)
            VAL_ORDINE_COLORE,
         DTA_INS_22 DTA_INS_ALERT,
         A.COD_SNDG,
         A.COD_ABI_CARTOLARIZZATO,
         A.COD_ABI_ISTITUTO,
         X.DESC_ISTITUTO,
         A.COD_NDG,
         X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
         X.COD_MACROSTATO,
         --  NVL (x.cod_comparto_assegn, x.cod_comparto_appart) cod_comparto_utente
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
         --i.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO,
         X.ID_REFERENTE,
         X.ID_UTENTE,
         X.DTA_UTENTE_ASSEGNATO,
         X.NOME DESC_NOME,
         X.COGNOME DESC_COGNOME,
         X.FLG_GESTORE_ABILITATO,
         CR.SCGB_COD_STATO_SIS COD_STATO_SIS,
         CR.SCGB_DTA_RIF_CR DTA_RIFERIMENTO_CR,
         X.SCSB_UTI_TOT VAL_UTI_TOT
    FROM T_MCRE0_APP_ALERT_POS A,        --           MV_MCRE0_app_istituti i,
                                  --            t_mcre0_app_anagrafica_gruppo g,
                                  --            MV_MCRE0_APP_UPD_field x,
                                  --            T_MCRE0_APP_ANAGR_GRE GE,
                                  --            MV_MCRE0_denorm_str_org s,
                                  --            T_MCRE0_APP_UTENTI U,
                                  -- V_MCRE0_APP_UPD_FIELDS_ALL x
                                  -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
                                  V_MCRE0_APP_UPD_FIELDS X, T_MCRE0_APP_CR CR
   WHERE     ALERT_22 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = A.COD_NDG
         AND A.COD_ABI_CARTOLARIZZATO = CR.COD_ABI_CARTOLARIZZATO
         AND A.COD_NDG = CR.COD_NDG;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_ALERT_SO_SISTEMA TO MCRE_USR;
