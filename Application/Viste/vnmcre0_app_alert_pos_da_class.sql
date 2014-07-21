/* Formatted on 21/07/2014 18:45:04 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALERT_POS_DA_CLASS
(
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   DTA_INS_ALERT,
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   FLG_ABI_LAVORATO,
   COD_NDG,
   COD_COMPARTO_POSIZIONE,
   COD_COMPARTO_UTENTE,
   COD_RAMO_CALCOLATO,
   COD_MACROSTATO,
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
   COD_STATO_DESTINAZIONE,
   DTA_INS_STATO_PROPOSTO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   ID_REFERENTE,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   FLG_CLASSIFICA,
   FLG_MOPLE,
   FLG_ANNULLA_PROPOSTA
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(t) no_parallel(r)*/
                                           -- V1 ??/??/???? VG: prima versione
 -- V2 07/03/2011 ML: Aggiunta ID_REFERENTE, COD_PRIV, FLG_GESTORE_ABILITATO per gestione visibilità in base al profilo utente
                            -- V3 08/03/2011 VG: aggiunta tabella gestione_rio
                                         -- v4 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v5 06/05/2011 VG: COD_MACROSTATO
                                                       -- v6 24/05/2011 VG: GB
                    -- V7 20/06/2011 VG: se RIO e dta_dest null bottoni accesi
         ALERT_8 VAL_ALERT,
         (SELECT DECODE (
                    alert_8,
                    'V', val_verde,
                    DECODE (alert_8,
                            'A', val_arancio,
                            DECODE (alert_8, 'R', val_rosso, NULL)))
            FROM t_mcre0_app_alert
           WHERE id_alert = 8)
            val_ordine_colore,
         DTA_INS_8 DTA_INS_ALERT,
         x.COD_SNDG,
         x.COD_ABI_CARTOLARIZZATO,
         x.COD_ABI_ISTITUTO,
         x.DESC_ISTITUTO,
         --I.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO,
         x.COD_NDG,
         x.COD_COMPARTO COD_COMPARTO_POSIZIONE,
         --NVL (x.COD_COMPARTO_ASSEGN, x.COD_COMPARTO_APPART)              COD_COMPARTO_UTENTE,
         x.COD_COMPARTO_UTENTE,
         x.COD_RAMO_CALCOLATO,
         x.COD_MACROSTATO,
         x.DESC_NOME_CONTROPARTE,
         X.COD_GRUPPO_ECONOMICO,
         x.desc_GRUPPO_ECONOMICO VAL_ANA_GRE,
         x.COD_STRUTTURA_COMPETENTE_DC,
         x.DESC_STRUTTURA_COMPETENTE_DC,
         x.COD_STRUTTURA_COMPETENTE_RG,
         x.DESC_STRUTTURA_COMPETENTE_RG,
         x.COD_STRUTTURA_COMPETENTE_AR,
         x.DESC_STRUTTURA_COMPETENTE_AR,
         x.COD_STRUTTURA_COMPETENTE_FI,
         x.DESC_STRUTTURA_COMPETENTE_FI,
         X.COD_PROCESSO,
         X.COD_STATO,
         X.DTA_DECORRENZA_STATO,
         X.DTA_SCADENZA_STATO,
         DECODE (
            X.COD_MACROSTATO,
            'RIO', R.COD_MACROSTATO_DESTINAZIONE,
            DECODE (x.COD_MACROSTATO,
                    'PT', T.COD_MACROSTATO,
                    X.COD_MACROSTATO_PROPOSTO))
            COD_STATO_DESTINAZIONE,
         DECODE (X.COD_MACROSTATO,
                 'RIO', R.DTA_INS,
                 DECODE (x.COD_MACROSTATO, 'PT', T.DTA_INS, X.DTA_INS))
            DTA_INS_STATO_PROPOSTO,
         X.ID_UTENTE,
         X.DTA_UTENTE_ASSEGNATO,
         x.NOME DESC_NOME,
         x.COGNOME DESC_COGNOME,
         x.ID_REFERENTE,
         x.COD_PRIV,
         x.FLG_GESTORE_ABILITATO,
         CASE
            WHEN X.COD_MACROSTATO = 'PT' AND T.COD_MACROSTATO = 'GA'
            THEN
               1
            WHEN X.COD_MACROSTATO = 'PT' AND T.COD_MACROSTATO = 'RIO'
            THEN
               1
            WHEN     X.COD_MACROSTATO = 'RIO'
                 AND NVL (R.COD_MACROSTATO_DESTINAZIONE, 'BO') = 'BO'
            THEN
               1
            WHEN X.COD_MACROSTATO = 'RIO' AND R.COD_MACROSTATO_DESTINAZIONE = 'ES'
            THEN
               1
            WHEN X.COD_MACROSTATO = 'GB' AND X.COD_MACROSTATO_PROPOSTO = 'RIO'
            THEN
               1
            ELSE
               0
         END
            FLG_CLASSIFICA,
         CASE
            WHEN X.COD_MACROSTATO = 'PT' AND T.COD_MACROSTATO = 'IN'
            THEN
               1
            WHEN X.COD_MACROSTATO = 'PT' AND T.COD_MACROSTATO = 'SO'
            THEN
               1
            WHEN     X.COD_MACROSTATO = 'RIO'
                 AND NVL (R.COD_MACROSTATO_DESTINAZIONE, 'IN') = 'IN'
            THEN
               1
            WHEN X.COD_MACROSTATO = 'RIO' AND R.COD_MACROSTATO_DESTINAZIONE = 'SO'
            THEN
               1
            WHEN     X.COD_MACROSTATO = 'GB'
                 AND X.COD_MACROSTATO_PROPOSTO IN ('SO', 'IN')
            THEN
               1
            ELSE
               0
         END
            FLG_MOPLE,
         DECODE (X.COD_MACROSTATO, 'GB', 1, 0) FLG_ANNULLA_PROPOSTA
    FROM t_MCRE0_APP_ALERT_POS A,
         --  MV_MCRE0_APP_ISTITUTI I,
         --   T_MCRE0_APP_ANAGRAFICA_GRUPPO G,
         --   MV_MCRE0_APP_UPD_FIELD X,
         --    T_MCRE0_APP_ANAGR_GRE GE,
         --    MV_MCRE0_DENORM_STR_ORG S,
         --    T_MCRE0_APP_UTENTI U,
         T_MCRE0_APP_PT_GESTIONE_TAVOLI T,
         T_MCRE0_APP_RIO_GESTIONE R,
         -- V_MCRE0_APP_UPD_FIELDS_ALL x
         -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
         V_MCRE0_APP_UPD_FIELDS x
   WHERE     ALERT_8 IS NOT NULL
         AND X.COD_MACROSTATO IN ('PT', 'RIO', 'GB')
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = A.COD_NDG
         AND X.COD_ABI_CARTOLARIZZATO = T.COD_ABI_CARTOLARIZZATO(+)
         AND X.COD_NDG = T.COD_NDG(+)
         AND X.COD_ABI_CARTOLARIZZATO = R.COD_ABI_CARTOLARIZZATO(+)
         AND X.COD_NDG = R.COD_NDG(+)
--      AND X.COD_ABI_ISTITUTO = I.COD_ABI(+)
--      AND X.COD_SNDG = G.COD_SNDG(+)
---      AND X.COD_GRUPPO_ECONOMICO = GE.COD_GRE(+)
--     AND X.COD_ABI_ISTITUTO = x.COD_ABI_ISTITUTO_FI(+)
--     AND X.COD_FILIALE = x.COD_STRUTTURA_COMPETENTE_FI(+)
--     AND X.ID_UTENTE = x.ID_UTENTE(+)
;
