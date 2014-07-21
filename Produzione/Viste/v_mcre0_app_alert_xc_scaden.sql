/* Formatted on 17/06/2014 18:01:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_XC_SCADEN
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_COMPARTO_POSIZIONE,
   COD_COMPARTO_UTENTE,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
   COD_NDG,
   COD_PRIV,
   COD_PROCESSO,
   COD_RAMO_CALCOLATO,
   COD_SNDG,
   COD_STATO,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   DESC_COGNOME,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   DESC_NOME,
   DESC_NOME_CONTROPARTE,
   DESC_ISTITUTO,
   DTA_INS_ALERT,
   DTA_UTENTE_ASSEGNATO,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   ID_UTENTE,
   FLG_ABI_LAVORATO,
   VAL_ANA_GRE,
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   VAL_UTI_TOT,
   COD_GRUPPO_SUPER
)
AS
   SELECT                                   -- DECODE COLORE GIALLO AD arancio
         d.cod_abi_cartolarizzato,
          d.cod_abi_istituto,
          d.cod_comparto cod_comparto_posizione,
          d.cod_comparto_utente,
          d.cod_gruppo_economico,
          d.desc_gruppo_economico,
          d.cod_macrostato,
          d.cod_ndg,
          d.cod_priv,
          d.cod_processo,
          d.cod_ramo_calcolato,
          d.cod_sndg,
          d.cod_stato,
          d.cod_struttura_competente_ar,
          d.desc_struttura_competente_ar,
          d.cod_struttura_competente_rg,
          d.desc_struttura_competente_rg,
          d.cod_struttura_competente_fi,
          d.desc_struttura_competente_fi,
          d.cod_struttura_competente_dc,
          d.desc_struttura_competente_dc,
          d.cognome desc_cognome,
          d.dta_decorrenza_stato,
          d.dta_scadenza_stato,
          d.nome desc_nome,
          d.desc_nome_controparte,
          d.desc_istituto,
          pw.dta_ins dta_ins_alert,
          d.dta_utente_assegnato,
          d.flg_gestore_abilitato,
          d.id_referente,
          d.id_utente,
          (SELECT flg_lavorabile
             FROM v_mcrei_posizioni_lavorabili pl
            WHERE     pl.cod_abi = d.cod_abi_cartolarizzato
                  AND pl.cod_ndg = d.cod_ndg
                  AND pl.cod_sndg = d.cod_sndg)
             AS flg_abi_lavorato,
          d.desc_gruppo_economico val_ana_gre,
          DECODE (pw.alert, 'G', 'A', pw.alert) AS val_alert,
          CASE
             WHEN pw.alert = 'R' THEN 3
             WHEN pw.alert = 'G' OR pw.alert = 'A' THEN 2
             WHEN pw.alert = 'V' THEN 1
          END
             VAL_ORDINE_COLORE,
          D.SCSB_UTI_TOT VAL_UTI_TOT,
          d.cod_gruppo_super
     FROM t_mcrei_app_alert_pos_wrk PARTITION (inc_p04) pw,
          v_mcre0_app_upd_fields d
    WHERE     pw.cod_abi = d.cod_abi_cartolarizzato
          AND pw.cod_ndg = d.cod_ndg
          AND d.cod_stato = 'XC'                        --0320 solo XC, non XS
          AND d.flg_outsourcing = 'Y'
          AND d.flg_target = 'Y';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_ALERT_XC_SCADEN TO MCRE_USR;
