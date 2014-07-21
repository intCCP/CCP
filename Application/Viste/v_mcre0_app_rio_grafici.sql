/* Formatted on 21/07/2014 18:35:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RIO_GRAFICI
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
   SELECT x.cod_sndg,
          x.cod_abi_cartolarizzato,
          x.cod_abi_istituto,
          x.desc_istituto,
          x.cod_ndg,
          x.cod_comparto,
          x.cod_ramo_calcolato,
          x.desc_nome_controparte,
          x.cod_gruppo_economico,
          x.desc_gruppo_economico val_ana_gre,
          x.cod_struttura_competente_dc,
          x.desc_struttura_competente_dc,
          x.cod_struttura_competente_dv,
          x.desc_struttura_competente_dv,
          x.cod_struttura_competente_rg,
          x.desc_struttura_competente_rg,
          x.cod_struttura_competente_ar,
          x.desc_struttura_competente_ar,
          x.cod_struttura_competente_fi,
          x.desc_struttura_competente_fi,
          x.cod_processo,
          x.cod_stato,
          x.dta_decorrenza_stato,
          x.dta_scadenza_stato,
          NULLIF (x.id_utente, -1) id_utente,
          x.dta_utente_assegnato,
          x.nome desc_nome,
          x.cognome desc_cognome,
          x.id_referente,
          flg_sg,
          a.val_label,
          a.dta_inserimento dta_inserimento_azione,
          a.cod_azione,
          c.descrizione_azione,
          a.flg_esito,
          a.flg_status,
          a.dta_scadenza,
          a.note,
          cp.descrizione_azione val_raggruppamento,
          x.cod_livello
     FROM (SELECT 'A' val_label, ga.*
             FROM v_mcre0_app_rio_grafico_a ga
           UNION ALL
           SELECT 'B' val_label, gb.*
             FROM v_mcre0_app_rio_grafico_b gb
           UNION ALL
           SELECT 'C' val_label, gc.*
             FROM v_mcre0_app_rio_grafico_c gc
           UNION ALL
           SELECT 'D' val_label, gd.*
             FROM v_mcre0_app_rio_grafico_d gd
           UNION ALL
           SELECT 'E' val_label, ge.*
             FROM v_mcre0_app_rio_grafico_e ge
           UNION ALL
           SELECT cod_azione val_label, fase.*
             FROM v_mcre0_app_rio_grafico_fase fase) a,
          v_mcre0_app_upd_fields x,
          t_mcre0_cl_rio_azioni c,
          t_mcre0_cl_rio_azioni cp
    WHERE     x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
          AND x.cod_ndg = a.cod_ndg
          AND a.cod_azione = c.cod_azione(+)
          AND c.cod_azione_padre = cp.cod_azione(+)
          AND NVL (x.flg_outsourcing, 'N') = 'Y';
