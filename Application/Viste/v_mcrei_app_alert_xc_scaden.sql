/* Formatted on 21/07/2014 18:39:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_ALERT_XC_SCADEN
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
   COD_STRUTTURA_COMPETENTE,
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
   VAL_ORDINE_COLORE
)
AS
     SELECT d.cod_abi_cartolarizzato,
            d.cod_abi_istituto,
            TO_CHAR (NULL) cod_comparto_posizione,
            u.cod_comparto_utente,
            d.cod_gruppo_economico,
            d.desc_gruppo_economico,
            d.cod_macrostato,
            d.cod_ndg,
            u.cod_priv,
            d.cod_processo,
            d.cod_ramo_calcolato,
            d.cod_sndg,
            d.cod_stato,
            o.cod_struttura_competente_ar,
            o.desc_struttura_competente_ar,
            o.cod_struttura_competente_rg,
            o.desc_struttura_competente_rg,
            o.cod_struttura_competente_fi,
            o.desc_struttura_competente_fi,
            d.cod_struttura_competente,
            u.cognome desc_cognome,
            d.dta_decorrenza_stato,
            d.dta_scadenza_stato,
            u.nome desc_nome,
            d.desc_nome_controparte,
            d.desc_istituto,
            SYSDATE dta_ins_alert,
            d.dta_utente_assegnato,
            u.FLG_GESTORE_ABILITATO,
            u.ID_REFERENTE,
            d.id_utente,
            TO_CHAR (NULL) flg_abi_lavorato,
            TO_CHAR (NULL) val_ana_gre,
            CASE
               WHEN     d.dta_scadenza_stato - TRUNC (SYSDATE) < 30
                    AND d.dta_scadenza_stato - TRUNC (SYSDATE) >= 15
               THEN
                  'V'
               WHEN     d.dta_scadenza_stato - TRUNC (SYSDATE) < 15
                    AND d.dta_scadenza_stato - TRUNC (SYSDATE) >= 5
               THEN
                  'G'
               WHEN d.dta_scadenza_stato - TRUNC (SYSDATE) < 5
               THEN
                  'R'
            END
               val_alert,
            CASE
               WHEN     d.dta_scadenza_stato - TRUNC (SYSDATE) < 30
                    AND d.dta_scadenza_stato - TRUNC (SYSDATE) >= 15
               THEN
                  3
               WHEN     d.dta_scadenza_stato - TRUNC (SYSDATE) < 15
                    AND d.dta_scadenza_stato - TRUNC (SYSDATE) >= 5
               THEN
                  2
               WHEN d.dta_scadenza_stato - TRUNC (SYSDATE) < 5
               THEN
                  1
            END
               val_ordine_colore
       FROM t_mcre0_app_all_data d,
            v_mcre0_denorm_str_org o,
            t_mcre0_app_utenti u
      WHERE     o.cod_abi_istituto_fi(+) = d.cod_abi_cartolarizzato
            AND o.cod_struttura_competente_fi(+) = d.cod_filiale
            AND d.cod_stato = 'XC'
            AND d.ID_UTENTE = u.ID_UTENTE(+)
   ORDER BY val_ordine_colore;
