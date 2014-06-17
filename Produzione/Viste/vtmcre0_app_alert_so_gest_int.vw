/* Formatted on 17/06/2014 18:15:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_ALERT_SO_GEST_INT
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_COMPARTO_POSIZIONE,
   COD_COMPARTO_UTENTE,
   COD_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
   COD_NDG,
   COD_PRIV,
   COD_PROCESSO,
   COD_RAMO_CALCOLATO,
   COD_SNDG,
   COD_STATO,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_COGNOME,
   DESC_ISTITUTO,
   DESC_NOME,
   DESC_NOME_CONTROPARTE,
   DESC_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_RG,
   DTA_DECORRENZA_STATO,
   DTA_INS_ALERT,
   DTA_SCADENZA_STATO,
   DTA_UTENTE_ASSEGNATO,
   FLG_ABI_LAVORATO,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   ID_UTENTE,
   VAL_ALERT,
   VAL_ANA_GRE,
   VAL_ORDINE_COLORE,
   COD_STRUTTURA_COMPETENTE
)
AS
   SELECT ad.cod_abi_cartolarizzato,
          ad.cod_abi_istituto,
          ad.cod_comparto cod_comparto_posizione,
          ad.cod_comparto_utente,
          ad.cod_gruppo_economico,
          ad.cod_macrostato,
          ad.cod_ndg,
          ad.cod_priv,
          ad.cod_processo,
          ad.cod_ramo_calcolato,
          ad.cod_sndg,
          'SO' AS cod_stato,
          ad.cod_struttura_competente_ar,
          ad.cod_struttura_competente_dc,
          ad.cod_struttura_competente_fi,
          ad.cod_struttura_competente_rg,
          ad.cognome desc_cognome,
          ad.desc_istituto,
          ad.nome desc_nome,
          ad.desc_nome_controparte,
          ad.desc_struttura_competente_ar,
          ad.desc_struttura_competente_dc,
          ad.desc_struttura_competente_fi,
          ad.desc_struttura_competente_rg,
          ad.dta_decorrenza_stato,
          pos.dta_ins dta_ins_alert,
          ad.dta_scadenza_stato,
          ad.dta_utente_assegnato,
          '1' flg_abi_lavorato,
          ad.flg_gestore_abilitato,
          ad.id_referente,
          ad.id_utente,
          CASE
             WHEN (SYSDATE - pos.dta_ins) <= 2
             THEN
                'V'
             WHEN     (SYSDATE - pos.dta_ins) <= 5
                  AND (SYSDATE - pos.dta_ins) > 2
             THEN
                'A'
             WHEN (SYSDATE - pos.dta_ins) > 5
             THEN
                'R'
          END
             val_alert,
          ad.desc_gruppo_economico AS val_ana_gre,
          pos.val_ordine_colore,
          ad.cod_struttura_competente
     FROM t_mcrei_app_alert_pos_wrk PARTITION (inc_p42) pos,
          vtmcre0_app_upd_fields ad
    WHERE     pos.cod_abi = ad.cod_abi_cartolarizzato
          AND pos.cod_ndg = ad.cod_ndg;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_ALERT_SO_GEST_INT TO MCRE_USR;
