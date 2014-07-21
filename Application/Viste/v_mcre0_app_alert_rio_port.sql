/* Formatted on 21/07/2014 18:32:53 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_RIO_PORT
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
   ID_REFERENTE
)
AS
   SELECT /*+ordered no_parallel(a) */
         ALERT_12 VAL_ALERT,
          (SELECT DECODE (
                     ALERT_12,
                     'V', VAL_VERDE,
                     DECODE (ALERT_12,
                             'A', VAL_ARANCIO,
                             DECODE (ALERT_12, 'R', VAL_ROSSO, NULL)))
             FROM T_MCRE0_APP_ALERT
            WHERE ID_ALERT = 12)
             VAL_ORDINE_COLORE,
          DTA_INS_12 DTA_INS_ALERT,
          A.COD_SNDG,
          A.COD_ABI_CARTOLARIZZATO,
          A.COD_ABI_ISTITUTO,
          X.DESC_ISTITUTO,
          A.COD_NDG,
          X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
          --  NVL (u.cod_comparto_assegn, u.cod_comparto_appart)    cod_comparto_utente,
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
          X.ID_REFERENTE
     FROM V_MCRE0_APP_ALERT_POS A,            --  V_MCRE0_APP_UPD_FIELDS_ALL x
                                   -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
                                   V_MCRE0_APP_UPD_FIELDS X
    --  mv_mcre0_app_istituti i,
    --   t_mcre0_app_anagrafica_gruppo g,
    --   mv_mcre0_app_upd_field x,
    --   t_mcre0_app_anagr_gre ge,
    --   v_mcre0_denorm_str_org s,
    --   t_mcre0_app_utenti u
    WHERE     A.ALERT_12 IS NOT NULL
          --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
          AND X.FLG_OUTSOURCING = 'Y'
          -- AND I.FLG_TARGET = 'Y'
          AND X.FLG_TARGET = 'Y'
          AND X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
          AND X.COD_NDG = A.COD_NDG;
