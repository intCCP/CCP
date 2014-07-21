/* Formatted on 21/07/2014 18:33:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_AV_GESTIONE
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_ISTITUTO,
   COD_PROCESSO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE,
   COD_COMPARTO,
   DESC_COMPARTO,
   FLG_STATO,
   DESC_STATO,
   DESC_ESITO,
   DTA_STATO,
   ID_UTENTE,
   DESC_GESTORE,
   COD_COMPARTO_RICHIEDENTE,
   DESC_COMPARTO_RICHIEDENTE,
   COD_MATRICOLA,
   DTA_INS
)
AS
   SELECT                                                -- MM v0.1 01.07.2011
          -- MM v0.2 13.07 - aggiunta Strutura Competente da Mople
          -- MM 110930 - desc_esito
          AV.COD_ABI_CARTOLARIZZATO,
          X.COD_ABI_ISTITUTO,
          AV.COD_NDG,
          X.COD_SNDG,
          I.DESC_ISTITUTO,
          X.COD_PROCESSO,
          X.COD_STATO,
          X.DTA_DECORRENZA_STATO,
          X.DESC_NOME_CONTROPARTE,
          X.COD_GRUPPO_ECONOMICO,
          X.DESC_GRUPPO_ECONOMICO,
          X.COD_STRUTTURA_COMPETENTE_DC,
          X.DESC_STRUTTURA_COMPETENTE_DC,
          X.COD_STRUTTURA_COMPETENTE_RG,
          X.DESC_STRUTTURA_COMPETENTE_RG,
          X.COD_STRUTTURA_COMPETENTE_AR,
          X.DESC_STRUTTURA_COMPETENTE_AR,
          X.COD_FILIALE COD_STRUTTURA_COMPETENTE_FI,
          X.DESC_STRUTTURA_COMPETENTE_FI,
          X.COD_STRUTTURA_COMPETENTE,
          X.COD_COMPARTO,
          X.DESC_COMPARTO,
          AV.FLG_STATO,
          CL.DESC_STATO,
          AV.DESC_ESITO,
          AV.DTA_STATO,
          X.ID_UTENTE,
          X.COGNOME || ' ' || X.NOME DESC_GESTORE,
          AV.COD_COMPARTO_AV COD_COMPARTO_RICHIEDENTE,
          C1.DESC_COMPARTO DESC_COMPARTO_RICHIEDENTE,
          AV.COD_MATRICOLA,
          AV.DTA_INS
     FROM                                        -- mv_mcre0_denorm_str_org s,
         T_MCRE0_APP_AV_GESTIONE AV,
          T_MCRE0_CL_AV_STATI CL,
          T_MCRE0_APP_COMPARTI C1,
          MV_MCRE0_APP_ISTITUTI I,
          -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
          V_MCRE0_APP_UPD_FIELDS X
    WHERE     X.COD_ABI_CARTOLARIZZATO = AV.COD_ABI_CARTOLARIZZATO
          AND X.COD_NDG = AV.COD_NDG
          AND AV.COD_COMPARTO_AV = C1.COD_COMPARTO                       --(+)
          AND AV.COD_ABI_CARTOLARIZZATO = I.COD_ABI                      --(+)
          AND AV.FLG_STATO = CL.COD_STATO;
