/* Formatted on 17/06/2014 18:04:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RIO_POS_DA_LAV
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
   COD_STATO_PRECEDENTE,
   VAL_GG_IN_MACROSTATO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   SCSB_ACC_TOT,
   SCSB_UTI_TOT,
   ID_REFERENTE,
   FLG_ABI_LAVORATO,
   COD_ISTITUTO_SOA,
   COD_LIVELLO,
   COD_GRUPPO_SUPER
)
AS
   SELECT                                    -- VG 11-03-2011 COD_ISTITUTO_SOA
          -- v1 17/06/2011 VG: New PCR
          x.cod_sndg,
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
          x.cod_stato_precedente,
          TRUNC (SYSDATE) - TRUNC (x.dta_dec_macrostato) val_gg_in_macrostato,
          NULLIF (x.id_utente, -1) id_utente,
          x.dta_utente_assegnato,
          x.nome desc_nome,
          x.cognome desc_cognome,
          x.scsb_acc_tot,
          x.scsb_uti_tot,
          x.id_referente,
          i.flg_abi_lavorato,
          I.COD_ISTITUTO_SOA,
          X.COD_LIVELLO,
          X.COD_GRUPPO_SUPER
     FROM                                   --T_MCRE0_APP_ANAGRAFICA_GRUPPO G,
         v_mcre0_app_upd_fields x, mv_mcre0_app_istituti i
    --T_MCRE0_APP_ANAGR_GRE GE,
    --MV_MCRE0_DENORM_STR_ORG S,
    --T_MCRE0_APP_UTENTI U,
    --T_MCRE0_APP_PCR R
    WHERE     x.cod_macrostato = 'RIO'
          AND NVL (x.flg_outsourcing, 'N') = 'Y'
          AND x.cod_abi_cartolarizzato = i.cod_abi;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_RIO_POS_DA_LAV TO MCRE_USR;
