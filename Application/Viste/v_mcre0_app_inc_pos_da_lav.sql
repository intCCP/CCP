/* Formatted on 21/07/2014 18:34:11 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_INC_POS_DA_LAV
(
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_COMPARTO,
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
   COD_STATO_PRECEDENTE,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   SCSB_ACC_TOT,
   SCSB_UTI_TOT,
   ID_REFERENTE,
   FLG_ABI_LAVORATO,
   COD_ISTITUTO_SOA
)
AS
   SELECT                               -- created by Spataro F. on 07-09-2011
         X.COD_SNDG,
          X.COD_ABI_CARTOLARIZZATO,
          X.COD_ABI_ISTITUTO,
          X.DESC_ISTITUTO,
          X.COD_NDG,
          X.COD_COMPARTO,
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
          X.COD_STATO_PRECEDENTE,
          NULLIF (X.ID_UTENTE, -1) ID_UTENTE,
          X.DTA_UTENTE_ASSEGNATO,
          X.NOME DESC_NOME,
          X.COGNOME DESC_COGNOME,
          X.SCSB_ACC_TOT,
          X.SCSB_UTI_TOT,
          X.ID_REFERENTE,
          I.FLG_ABI_LAVORATO,
          I.COD_ISTITUTO_SOA
     FROM                                   --T_MCRE0_APP_ANAGRAFICA_GRUPPO G,
         V_MCRE0_APP_UPD_FIELDS X, MV_MCRE0_APP_ISTITUTI I
    --T_MCRE0_APP_ANAGR_GRE GE,
    --MV_MCRE0_DENORM_STR_ORG S,
    --T_MCRE0_APP_UTENTI U,
    --T_MCRE0_APP_PCR R
    WHERE     X.COD_MACROSTATO = 'IN'
          AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
          AND X.COD_ABI_CARTOLARIZZATO = I.COD_ABI;
