/* Formatted on 17/06/2014 18:13:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_PT_GESTIONE_TAVOLI
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   DTA_DEADLINE_INS_PIANO,
   DTA_DEADLINE_INS_PARERE_AREA,
   DTA_PIANO_CONFERMA_AREA,
   VAL_CAUSE_INTERCETTAMENTO,
   DTA_CONVOCAZIONE,
   DTA_SOLLECITO,
   DTA_TAVOLO,
   DTA_TAVOLO_ORIG,
   VAL_ANALISI_INTERCETTAMENTO,
   VAL_ANALISI_COMPLESSIVA,
   VAL_VALUTAZIONE_QUANTITATIVA,
   COD_MACROSTATO_PROPOSTO,
   VAL_MOTIVAZIONI,
   VAL_STRATEGIA_CREDITIZIA,
   VAL_PARERE_AREA,
   DTA_PIANO,
   VAL_NOMINATIVO_FIRMA,
   COD_MATRICOLA_FIRMA,
   VAL_NOMINATIVO_PARERE,
   COD_MATRICOLA_PARERE,
   FLG_PIANO,
   VAL_PARTECIPANTI,
   COD_MACROSTATO,
   VAL_DURATA_STATO,
   VAL_STRATEGIA_CREDITIZIA_ASS,
   VAL_LINEE_GUIDA,
   VAL_COMMENTO,
   DTA_VERBALE,
   COD_OD_CALCOLATO,
   COD_OD,
   FLG_WORKFLOW,
   ID_UTENTE,
   DTA_INS,
   COD_ABI_ISTITUTO,
   FLG_VERBALE,
   VAL_OD,
   VAL_OD_CALCOLATO,
   COD_MATRICOLA_PRESAVISIONE,
   DTA_PRESAVISIONE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   COD_STATO_PRECEDENTE,
   COD_PERCORSO,
   COD_PROCESSO,
   COD_FILIALE,
   COD_SNDG,
   COD_COMPARTO,
   COD_GRUPPO_ECONOMICO
)
AS
   SELECT                    --v1.1 07.02.11 MM -- upd_field al posto di mople
         T."COD_ABI_CARTOLARIZZATO",
          T."COD_NDG",
          T."DTA_DEADLINE_INS_PIANO",
          T."DTA_DEADLINE_INS_PARERE_AREA",
          T.DTA_PIANO_CONFERMA_AREA,
          T."VAL_CAUSE_INTERCETTAMENTO",
          T."DTA_CONVOCAZIONE",
          T."DTA_SOLLECITO",
          T."DTA_TAVOLO",
          T."DTA_TAVOLO_ORIG",
          T."VAL_ANALISI_INTERCETTAMENTO",
          T."VAL_ANALISI_COMPLESSIVA",
          T."VAL_VALUTAZIONE_QUANTITATIVA",
          T."COD_MACROSTATO_PROPOSTO",
          T."VAL_MOTIVAZIONI",
          T."VAL_STRATEGIA_CREDITIZIA",
          T."VAL_PARERE_AREA",
          T."DTA_PIANO",
          T."VAL_NOMINATIVO_FIRMA",
          T."COD_MATRICOLA_FIRMA",
          T."VAL_NOMINATIVO_PARERE",
          T."COD_MATRICOLA_PARERE",
          T."FLG_PIANO",
          T."VAL_PARTECIPANTI",
          T."COD_MACROSTATO",
          T."VAL_DURATA_STATO",
          T."VAL_STRATEGIA_CREDITIZIA_ASS",
          T."VAL_LINEE_GUIDA",
          T."VAL_COMMENTO",
          T."DTA_VERBALE",
          T."COD_OD_CALCOLATO",
          T."COD_OD",
          T."FLG_WORKFLOW",
          M.ID_UTENTE,
          T."DTA_INS",
          M.COD_ABI_ISTITUTO,
          T.FLG_VERBALE,
          T.VAL_OD,
          T.VAL_OD_CALCOLATO,
          T.COD_MATRICOLA_PRESAVISIONE,
          T.DTA_PRESAVISIONE,
          M.COD_STATO,
          M.DTA_DECORRENZA_STATO,
          M.DTA_SCADENZA_STATO,
          M.COD_STATO_PRECEDENTE,
          M.COD_PERCORSO,
          M.COD_PROCESSO,
          M.COD_FILIALE,
          M.COD_SNDG,
          M.COD_COMPARTO,
          M.COD_GRUPPO_ECONOMICO
     FROM T_MCRE0_APP_PT_GESTIONE_TAVOLI T, MV_MCRE0_APP_UPD_FIELD M
    WHERE     T.COD_ABI_CARTOLARIZZATO = M.COD_ABI_CARTOLARIZZATO
          AND T.COD_NDG = M.COD_NDG
          AND NVL (M.FLG_OUTSOURCING, 'N') = 'Y'
          AND M.COD_STATO = 'PT';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.VOMCRE0_APP_PT_GESTIONE_TAVOLI TO MCRE_USR;