/* Formatted on 17/06/2014 18:01:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_GEST_GRAF
(
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_COMPARTO,
   COD_RAMO_CALCOLATO,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_DV,
   DESC_STRUTTURA_COMPETENTE_DV,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_PROCESSO,
   COD_MACROSTATO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   ID_REFERENTE,
   FLG_SG,
   VAL_LABEL,
   DTA_INSERIMENTO_AZIONE,
   COD_AZIONE,
   DESCRIZIONE_AZIONE,
   FLG_ESITO,
   FLG_STATUS,
   DTA_SCADENZA,
   NOTE,
   VAL_RAGGRUPPAMENTO,
   COD_LIVELLO
)
AS
   SELECT X.COD_SNDG,
          X.COD_ABI_CARTOLARIZZATO,
          X.COD_ABI_ISTITUTO,
          X.DESC_ISTITUTO,
          X.COD_NDG,
          X.COD_COMPARTO,
          X.COD_RAMO_CALCOLATO,
          X.DESC_NOME_CONTROPARTE,
          X.COD_GRUPPO_ECONOMICO,
          X.DESC_GRUPPO_ECONOMICO AS VAL_ANA_GRE,
          X.COD_STRUTTURA_COMPETENTE_DC,
          X.DESC_STRUTTURA_COMPETENTE_DC,
          X.COD_STRUTTURA_COMPETENTE_DV,
          X.DESC_STRUTTURA_COMPETENTE_DV,
          X.COD_STRUTTURA_COMPETENTE_RG,
          X.DESC_STRUTTURA_COMPETENTE_RG,
          X.COD_STRUTTURA_COMPETENTE_AR,
          X.DESC_STRUTTURA_COMPETENTE_AR,
          X.COD_STRUTTURA_COMPETENTE_FI,
          X.DESC_STRUTTURA_COMPETENTE_FI,
          X.COD_PROCESSO,
          X.COD_MACROSTATO,
          X.COD_STATO,
          X.DTA_DECORRENZA_STATO,
          X.DTA_SCADENZA_STATO,
          NULLIF (X.ID_UTENTE, -1) AS ID_UTENTE,
          X.DTA_UTENTE_ASSEGNATO,
          X.NOME AS DESC_NOME,
          X.COGNOME AS DESC_COGNOME,
          X.ID_REFERENTE,
          A.FLG_SG,
          A.VAL_LABEL,
          A.DTA_INSERIMENTO AS DTA_INSERIMENTO_AZIONE,
          A.COD_AZIONE,
          C.DESCRIZIONE_AZIONE,
          A.FLG_ESITO,
          A.FLG_STATUS,
          A.DTA_SCADENZA,
          A.NOTE,
          CP.DESCRIZIONE_AZIONE AS VAL_RAGGRUPPAMENTO,
          X.COD_LIVELLO
     FROM V_MCRE0_APP_UPD_FIELDS X,
          T_MCRE0_CL_RIO_AZIONI C,
          T_MCRE0_CL_RIO_AZIONI CP,
          (SELECT 'A' AS VAL_LABEL, GA.*
             FROM V_MCRE0_APP_GEST_GRAF_A GA
           UNION ALL
           SELECT 'B' AS VAL_LABEL, GB.*
             FROM V_MCRE0_APP_GEST_GRAF_B GB
           UNION ALL
           SELECT 'C' AS VAL_LABEL, GC.*
             FROM V_MCRE0_APP_GEST_GRAF_C GC
           UNION ALL
           SELECT 'D' AS VAL_LABEL, GD.*
             FROM V_MCRE0_APP_GEST_GRAF_D GD
           UNION ALL
           SELECT 'E' AS VAL_LABEL, GE.*
             FROM V_MCRE0_APP_GEST_GRAF_E GE
           UNION ALL
           SELECT GF.COD_AZIONE AS VAL_LABEL, GF.*
             FROM V_MCRE0_APP_GEST_GRAF_FASE GF) A
    WHERE     X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
          AND X.COD_NDG = A.COD_NDG
          AND X.COD_MACROSTATO = A.COD_MACROSTATO
          AND A.COD_AZIONE = C.COD_AZIONE(+)
          --AND A.COD_AZIONE is not null
          AND C.COD_AZIONE_PADRE = CP.COD_AZIONE(+)
          AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y';


GRANT SELECT ON MCRE_OWN.V_MCRE0_APP_GEST_GRAF TO MCRE_USR;
