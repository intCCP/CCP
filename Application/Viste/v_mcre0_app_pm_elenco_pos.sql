/* Formatted on 21/07/2014 18:34:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PM_ELENCO_POS
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_ISTITUTO,
   DESC_NOME_CONTROPARTE,
   ID_UTENTE,
   ID_REFERENTE,
   COD_COMPARTO,
   COD_FILIALE,
   COD_PERCORSO,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   DTA_UTENTE_ASSEGNATO,
   COD_STATO_PRECEDENTE,
   COD_PROCESSO,
   SCSB_ACC_TOT,
   SCSB_UTI_TOT,
   MAU,
   VAL_NUMERO_PIANO,
   DTA_PIANO,
   DTA_SCADENZA,
   DTA_VALIDAZIONE,
   DESC_WORKFLOW,
   FLG_PRESENZA_PIANO,
   DTA_STATO_PROPOSTO,
   COD_STATO_PROPOSTO,
   VAL_GG_PM,
   FLG_PRESA_VISIONE_MODIFICA,
   COD_TIPO_PIANO,
   COD_MATRICOLA_FILIALE
)
AS
   SELECT a.COD_ABI_ISTITUTO,
          a.COD_ABI_CARTOLARIZZATO,
          a.COD_NDG,
          a.COD_SNDG,
          a.DESC_ISTITUTO,
          a.DESC_NOME_CONTROPARTE,
          a.ID_UTENTE,
          a.ID_REFERENTE,
          a.COD_COMPARTO,
          A.COD_FILIALE,
          a.cod_percorso,
          a.COD_GRUPPO_ECONOMICO,
          a.DESC_GRUPPO_ECONOMICO,
          a.COD_STRUTTURA_COMPETENTE_RG,
          a.DESC_STRUTTURA_COMPETENTE_RG,
          a.COD_STRUTTURA_COMPETENTE_AR,
          a.DESC_STRUTTURA_COMPETENTE_AR,
          a.COD_STRUTTURA_COMPETENTE_FI,
          a.DESC_STRUTTURA_COMPETENTE_FI,
          a.COD_STRUTTURA_COMPETENTE,
          a.DTA_DECORRENZA_STATO,
          a.DTA_SCADENZA_STATO,
          a.DTA_UTENTE_ASSEGNATO,
          a.COD_STATO_PRECEDENTE,
          a.COD_PROCESSO,
          a.SCSB_ACC_TOT,
          a.SCSB_UTI_TOT,
          A.GB_VAL_MAU MAU,
          p.ID_PIANO VAL_NUMERO_PIANO,
          p.DTA_PIANO,
          P.DTA_SCADENZA,
          P.DTA_PIANO_VALIDATO DTA_VALIDAZIONE,
          W.DESC_WORKFLOW,
          DECODE (P.ID_PIANO, NULL, 'N', 'S') flg_presenza_piano,
          P.DTA_STATO_PROPOSTO,
          P.COD_STATO_PROPOSTO,
          TRUNC (SYSDATE) - a.dta_decorrenza_stato VAL_GG_PM,
          P.FLG_PRESA_VISIONE_MODIFICA,
          NVL (
             P.COD_TIPO_PIANO,
             (SELECT cod_tipo_piano
                FROM V_MCRE0_APP_PM_TIPO_PIANO t
               WHERE     T.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
                     AND T.COD_NDG = A.COD_NDG))
             cod_tipo_piano,
          p.COD_MATRICOLA_FILIALE
     FROM V_MCRE0_APP_UPD_FIELDS a,
          T_MCRE0_APP_GEST_PM p,
          T_MCRE0_CL_WORKFLOW_PM w
    WHERE     a.COD_ABI_CARTOLARIZZATO = p.COD_ABI_CARTOLARIZZATO(+)
          AND a.COD_NDG = p.COD_NDG(+)
          AND A.COD_STATO = 'PM'
          AND A.COD_PERCORSO = P.COD_PERCORSO(+)
          AND P.FLG_PIANO_ANNULLATO(+) = 'N'
          AND P.ID_WORKFLOW = W.ID_WORKFLOW(+);
