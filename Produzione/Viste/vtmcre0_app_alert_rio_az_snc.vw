/* Formatted on 17/06/2014 18:15:10 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_ALERT_RIO_AZ_SNC
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
   COD_COMPARTO_UTENTE,
   COD_RAMO_CALCOLATO,
   DESC_NOME_CONTROPARTE,
   COD_MACROSTATO,
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
   ID_REFERENTE,
   FLG_ABI_LAVORATO,
   DESC_NOME,
   DESC_COGNOME,
   FLG_GESTORE_ABILITATO,
   DTA_SCADENZA_AZIONE,
   COD_AZIONE,
   DESC_AZIONE_SCADUTA
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(r)*/
                                         -- v1 20/04/2011 VG: FLG_ABI_LAVORATO
                                    -- v2 21/04/2011 VG: FLG_GESTORE_ABILITATO
                              -- v3 02/05/2011 VG: Modificata scelta posizione
                                           -- v4 06/05/2011 VG: COD_MACROSTATO
         ALERT_6 VAL_ALERT,
         (SELECT DECODE (
                    ALERT_6,
                    'V', VAL_VERDE,
                    DECODE (ALERT_6,
                            'A', VAL_ARANCIO,
                            DECODE (ALERT_6, 'R', VAL_ROSSO, NULL)))
            FROM T_MCRE0_APP_ALERT
           WHERE ID_ALERT = 6)
            VAL_ORDINE_COLORE,
         DTA_INS_6 DTA_INS_ALERT,
         A.COD_SNDG,
         A.COD_ABI_CARTOLARIZZATO,
         A.COD_ABI_ISTITUTO,
         X.DESC_ISTITUTO,
         A.COD_NDG,
         X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
         --  NVL (x.cod_comparto_assegn, x.cod_comparto_appart) cod_comparto_utente
         X.COD_COMPARTO_UTENTE,
         X.COD_RAMO_CALCOLATO,
         X.DESC_NOME_CONTROPARTE,
         X.COD_MACROSTATO,
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
         X.ID_REFERENTE,
         --I.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO,
         X.NOME DESC_NOME,
         X.COGNOME DESC_COGNOME,
         X.FLG_GESTORE_ABILITATO,
         T.DTA_SCADENZA DTA_SCADENZA_AZIONE,
         T.COD_AZIONE,
         R.DESCRIZIONE_AZIONE DESC_AZIONE_SCADUTA
    FROM T_MCRE0_APP_ALERT_POS A,
         (SELECT A.*,
                 DENSE_RANK ()
                 OVER (PARTITION BY COD_ABI_CARTOLARIZZATO, COD_NDG
                       ORDER BY DTA_SCADENZA, DTA_INSERIMENTO)
                    VAL_ORDINE
            FROM T_MCRE0_APP_RIO_AZIONI A
           WHERE FLG_STATUS != 'C' AND DTA_SCADENZA < TRUNC (SYSDATE)) T,
         T_MCRE0_CL_RIO_AZIONI R,
         -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
         VTMCRE0_APP_UPD_FIELDS X
   WHERE     ALERT_6 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND T.VAL_ORDINE = 1
         AND X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = A.COD_NDG
         AND X.COD_ABI_CARTOLARIZZATO = T.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = T.COD_NDG
         AND T.COD_AZIONE = R.COD_AZIONE(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_ALERT_RIO_AZ_SNC TO MCRE_USR;