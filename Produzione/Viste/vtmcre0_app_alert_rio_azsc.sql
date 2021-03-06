/* Formatted on 17/06/2014 18:15:11 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_ALERT_RIO_AZSC
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
   DTA_SCADENZA_AZIONE,
   COD_AZIONE,
   DESC_AZIONE,
   ID_REFERENTE,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   FLG_ABI_LAVORATO
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(r)*/
                                           -- V1 ??/??/???? VG: prima versione
 -- V2 04/04/2011 MDM: Aggiunta ID_REFERENTE, COD_PRIV, FLG_GESTORE_ABILITATO per gestione visibilitÓ in base al profilo utente
                                         -- v3 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v4 06/05/2011 VG: COD_MACROSTATO
                                                 -- v5 24/05/2011 VG: MIN data
         ALERT_15 VAL_ALERT,
         (SELECT DECODE (
                    ALERT_15,
                    'V', VAL_VERDE,
                    DECODE (ALERT_15,
                            'A', VAL_ARANCIO,
                            DECODE (ALERT_15, 'R', VAL_ROSSO, NULL)))
            FROM T_MCRE0_APP_ALERT
           WHERE ID_ALERT = 15)
            VAL_ORDINE_COLORE,
         DTA_INS_15 DTA_INS_ALERT,
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
         X.ID_UTENTE,
         X.DTA_UTENTE_ASSEGNATO,
         X.NOME DESC_NOME,
         X.COGNOME DESC_COGNOME,
         T.DTA_SCADENZA DTA_SCADENZA_AZIONE,
         T.COD_AZIONE,
         R.DESCRIZIONE_AZIONE DESC_AZIONE,
         X.ID_REFERENTE,
         X.COD_PRIV,
         X.FLG_GESTORE_ABILITATO,
         --I.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO
    FROM T_MCRE0_APP_ALERT_POS A,
         (SELECT A.*,
                 MIN (DTA_SCADENZA)
                    OVER (PARTITION BY A.COD_ABI_CARTOLARIZZATO, COD_NDG)
                    DTA_SCADENZA_MIN
            FROM T_MCRE0_APP_RIO_AZIONI A
           WHERE     FLG_STATUS != 'C'
                 AND (DTA_SCADENZA - TRUNC (SYSDATE)) <= 30
                 AND (DTA_SCADENZA - TRUNC (SYSDATE)) >= 0) T,
         T_MCRE0_CL_RIO_AZIONI R,
         -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
         VTMCRE0_APP_UPD_FIELDS X
   WHERE     ALERT_15 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = A.COD_NDG
         --          AND x.cod_abi_istituto = i.cod_abi(+)
         --          AND x.cod_sndg = g.cod_sndg(+)
         --          AND x.cod_gruppo_economico = ge.cod_gre(+)
         --          AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
         --          AND x.cod_filiale = s.cod_struttura_competente_fi(+)
         --          AND x.id_utente = x.id_utente(+)
         AND X.COD_ABI_CARTOLARIZZATO = T.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = T.COD_NDG
         AND T.COD_AZIONE = R.COD_AZIONE(+)
         AND T.DTA_SCADENZA = T.DTA_SCADENZA_MIN;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_ALERT_RIO_AZSC TO MCRE_USR;
