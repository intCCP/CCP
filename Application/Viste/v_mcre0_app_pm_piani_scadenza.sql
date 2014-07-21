/* Formatted on 21/07/2014 18:34:28 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PM_PIANI_SCADENZA
(
   ID_UTENTE,
   ID_REFERENTE,
   COD_COMPARTO,
   COD_FILIALE,
   COD_SNDG,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_PERCORSO,
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
   COD_PROCESSO,
   DTA_SCADENZA_GENERALE,
   ID_PIANO,
   FLG_PRESA_VISIONE,
   DTA_PRESA_VISIONE,
   COD_TIPO_PIANO
)
AS
   SELECT a.ID_UTENTE,
          a.ID_REFERENTE,
          a.COD_COMPARTO,
          a.COD_FILIALE,
          a.COD_SNDG,
          a.COD_NDG,
          a.DESC_NOME_CONTROPARTE,
          a.COD_GRUPPO_ECONOMICO,
          a.DESC_GRUPPO_ECONOMICO,
          a.COD_ABI_ISTITUTO,
          a.COD_ABI_CARTOLARIZZATO,
          a.DESC_ISTITUTO,
          a.cod_percorso,
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
          a.COD_PROCESSO,
          dta_scadenza_generale,
          id_piano,
          flg_presa_visione,
          dta_presa_visione,
          COD_TIPO_PIANO
     FROM V_MCRE0_APP_UPD_FIELDS a,
          (SELECT DISTINCT
                  COD_ABI_CARTOLARIZZATO,
                  COD_NDG,
                  id_piano,
                  COD_TIPO_PIANO,
                  FLG_PRESA_VISIONE_MODIFICA flg_presa_visione,
                  dta_presa_visione_modifica dta_presa_visione,
                  CASE WHEN dta_scadenza < SYSDATE + 15 THEN 1 ELSE 0 END
                     flg_scadenza,
                  dta_scadenza dta_scadenza_generale
             FROM T_MCRE0_APP_GEST_PM
            WHERE     NVL (FLG_PIANO_ANNULLATO, 'N') = 'N'
                  AND ID_WORKFLOW NOT IN (30, 40)) b
    WHERE     b.flg_scadenza = 1
          AND a.COD_ABI_CARTOLARIZZATO = b.COD_ABI_CARTOLARIZZATO
          AND a.COD_NDG = b.COD_NDG
          AND A.COD_STATO = 'PM';
