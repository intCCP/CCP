/* Formatted on 21/07/2014 18:34:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PM_DETT_PIANO
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_FILIALE,
   COD_PERCORSO,
   VAL_NUMERO_PIANO,
   DTA_PIANO,
   DTA_SCADENZA,
   DTA_VALIDAZIONE,
   DTA_PIANO_ANNULLATO,
   DTA_PIANO_COMPLETATO,
   COD_WORKFLOW,
   DESC_WORKFLOW,
   DTA_STATO_PROPOSTO,
   COD_STATO_PROPOSTO,
   DTA_DECORRENZA_STATO,
   VAL_GG_PM,
   VAL_CAUSE_INT,
   VAL_ANALISI_INT,
   VAL_ANALISI_COMPLESSIVA,
   VAL_VALUTAZIONE_QUANTITATIVA,
   VAL_NOTE_FILIALE,
   VAL_NOTE_OPERATIVE,
   VAL_PROPOSTA_FILIALE,
   COD_MATRICOLA_FILIALE,
   DESC_NOMINATIVO_FILIALE,
   ID_GESTORE,
   COD_MATRICOLA,
   NOME,
   COGNOME,
   DESC_STRUTTURA_VALIDANTE,
   COD_STATO_PRECEDENTE,
   COD_PROCESSO,
   FLG_PRESA_VISIONE_MODIFICA,
   COD_TIPO_PIANO,
   DTA_CONFERMA,
   COD_TIPO_INGRESSO
)
AS
   SELECT a.COD_ABI_ISTITUTO,
          a.COD_ABI_CARTOLARIZZATO,
          a.COD_NDG,
          a.COD_SNDG,
          A.COD_FILIALE,
          A.COD_PERCORSO,
          p.ID_PIANO VAL_NUMERO_PIANO,
          p.DTA_PIANO,
          P.DTA_SCADENZA,
          P.DTA_PIANO_VALIDATO DTA_VALIDAZIONE,
          P.DTA_PIANO_ANNULLATO,
          P.DTA_PIANO_COMPLETATO,
          W.COD_WORKFLOW,
          W.DESC_WORKFLOW,
          P.DTA_STATO_PROPOSTO,
          P.COD_STATO_PROPOSTO,
          P.DTA_DECORRENZA_STATO,
          TRUNC (SYSDATE) - p.dta_decorrenza_stato VAL_GG_PM,
          P.VAL_CAUSE_INT,
          P.VAL_ANALISI_INT,
          P.VAL_ANALISI_COMPLESSIVA,
          P.VAL_VALUTAZIONE_QUANTITATIVA,
          P.VAL_NOTE_FILIALE,
          P.VAL_NOTE_OPERATIVE,
          P.VAL_PROPOSTA_FILIALE,
          P.COD_MATRICOLA_FILIALE,
          P.DESC_NOMINATIVO_FILIALE,
          NVL (P.ID_UTENTE_VALIDAZIONE, P.ID_UTENTE_ANNULLO) AS id_gestore,
          U.COD_MATRICOLA,
          U.NOME,
          U.COGNOME,
          (SELECT desc_comparto
             FROM t_mcre0_app_comparti
            WHERE cod_comparto = u.cod_comparto_utente)
             DESC_STRUTTURA_VALIDANTE,
          a.COD_STATO_PRECEDENTE,
          a.COD_PROCESSO,
          p.FLG_PRESA_VISIONE_MODIFICA,
          COD_TIPO_PIANO,
          p.dta_conferma,
          a.COD_TIPO_INGRESSO
     FROM t_mcre0_app_all_data a,
          T_MCRE0_APP_GEST_PM p,
          T_MCRE0_CL_WORKFLOW_PM w,
          T_MCRE0_APP_UTENTI u
    WHERE     a.COD_ABI_CARTOLARIZZATO = p.COD_ABI_CARTOLARIZZATO
          AND a.COD_NDG = p.COD_NDG
          AND A.COD_STATO = 'PM'
          AND A.COD_PERCORSO = P.COD_PERCORSO
          --AND a.DTA_DECORRENZA_STATO = P.DTA_DECORRENZA_STATO
          --AND P.FLG_PIANO_ANNULLATO = 'N'
          AND P.ID_WORKFLOW = W.ID_WORKFLOW
          AND NVL (P.ID_UTENTE_VALIDAZIONE, P.ID_UTENTE_ANNULLO) =
                 U.ID_UTENTE(+);