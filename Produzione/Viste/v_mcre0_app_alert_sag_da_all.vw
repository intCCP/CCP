/* Formatted on 17/06/2014 18:00:51 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_SAG_DA_ALL
(
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   DTA_INS_ALERT,
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_ABI_ISTITUTO,
   COD_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
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
   DTA_CONFERMA,
   COD_SAG,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   COD_COMPARTO_POSIZIONE,
   COD_RAMO_CALCOLATO,
   COD_COMPARTO_UTENTE,
   DESC_NOME_CONTROPARTE,
   DESC_ISTITUTO,
   COD_GRUPPO_SUPER,
   FLG_ABI_LAVORATO,
   VAL_UTI_TOT
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(t)*/
                                -- v1 06/04/2011 VG sistemate condizioni where
                                    -- v2 08/04/2011 VG Modificata da DeMattia
                    -- v3 12/04/2011 LF Aggiunto COD_GRUPPO_SUPER da UPD_FIELD
                                         -- v4 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v5 06/05/2011 VG: COD_MACROSTATO
         ALERT_2 VAL_ALERT,
         (SELECT DECODE (
                    ALERT_2,
                    'V', VAL_VERDE,
                    DECODE (ALERT_2,
                            'A', VAL_ARANCIO,
                            DECODE (ALERT_2, 'R', VAL_ROSSO, NULL)))
            FROM T_MCRE0_APP_ALERT
           WHERE ID_ALERT = 2)
            VAL_ORDINE_COLORE,
         DTA_INS_2 DTA_INS_ALERT,
         A.COD_SNDG,
         A.COD_ABI_CARTOLARIZZATO,
         A.COD_NDG,
         A.COD_ABI_ISTITUTO,
         X.COD_GRUPPO_ECONOMICO,
         X.COD_MACROSTATO,
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
         T.DTA_CONFERMA,
         T.COD_SAG,
         X.COD_PRIV,
         X.FLG_GESTORE_ABILITATO,
         X.ID_REFERENTE,
         X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
         X.COD_RAMO_CALCOLATO,
         --  NVL (x.cod_comparto_assegn, x.cod_comparto_appart) cod_comparto_utente
         X.COD_COMPARTO_UTENTE,
         X.DESC_NOME_CONTROPARTE,
         X.DESC_ISTITUTO,
         NVL (X.COD_GRUPPO_SUPER_OLD, X.COD_GRUPPO_SUPER) COD_GRUPPO_SUPER, -- 08/04/14 modificato campo
         --i.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO,
         X.SCSB_UTI_TOT VAL_UTI_TOT
    FROM T_MCRE0_APP_ALERT_POS A,              --     MV_MCRE0_app_istituti i,
                                  --   t_mcre0_app_anagrafica_gruppo g,
                                  --   MV_MCRE0_APP_UPD_field x,
                                  --   T_MCRE0_APP_ANAGR_GRE GE,
                                  --   MV_MCRE0_denorm_str_org s,
                                  --   t_mcre0_app_utenti u,
                                  T_MCRE0_APP_SAG T, -- V_MCRE0_APP_UPD_FIELDS_ALL x
       -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
          V_MCRE0_APP_UPD_FIELDS X
   WHERE     ALERT_2 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = A.COD_NDG
         AND X.COD_SNDG = T.COD_SNDG(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_ALERT_SAG_DA_ALL TO MCRE_USR;
