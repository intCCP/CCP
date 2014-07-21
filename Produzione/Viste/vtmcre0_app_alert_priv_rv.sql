/* Formatted on 17/06/2014 18:15:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_ALERT_PRIV_RV
(
   DTA_INS_ALERT,
   VAL_ALERT,
   COD_STRUTTURA_COMPETENTE,
   COD_SNDG,
   COD_ABI,
   COD_NDG,
   COD_NOME_CLIENTE,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_PROCESSO,
   COD_STATO,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_COMPARTO_POSIZIONE,
   COD_COMPARTO_UTENTE,
   COD_MACROSTATO,
   COD_MODAL_CLASS,
   COD_PRIV,
   COD_PROTOCOLLO_PACCHETTO,
   COD_RAMO_CALCOLATO,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_COGNOME,
   DESC_ISTITUTO,
   DESC_MOTIV_CLASS,
   DESC_NOME,
   DESC_NOME_CONTROPARTE,
   DESC_STRUTTURA_COMPETENTE_DC,
   DESC_TIPOL_GESTIONE,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   DTA_UTENTE_ASSEGNATO,
   FLG_ABI_LAVORATO,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   ID_UTENTE,
   VAL_ANA_GRE,
   VAL_ORDINE_COLORE
)
AS
   SELECT pa.dta_ins AS dta_ins_alert,
          DECODE (pa.alert, 'G', 'A', pa.alert) AS val_alert,
          ad.cod_struttura_competente,
          ad.cod_sndg,
          ad.cod_abi_cartolarizzato AS cod_abi,
          ad.cod_ndg,
          ad.desc_nome_controparte AS cod_nome_cliente,
          ad.cod_gruppo_economico AS cod_gruppo_economico,
          ad.desc_gruppo_economico AS desc_gruppo_economico,
          ad.cod_struttura_competente_rg,
          ad.desc_struttura_competente_rg,
          ad.cod_struttura_competente_ar,
          ad.desc_struttura_competente_ar,
          ad.cod_struttura_competente_fi,
          ad.desc_struttura_competente_fi,
          ad.cod_processo,
          ad.cod_stato AS cod_stato,
          ad.cod_abi_cartolarizzato,
          ad.cod_abi_istituto,
          ad.cod_comparto AS cod_comparto_posizione,
          ad.cod_comparto_utente,
          ad.cod_macrostato,
          DECODE (d1.cod_tipo_pacchetto,  'A', 'Automatico',  'M', 'Manuale')
             AS cod_modal_class,
          ad.cod_priv,
          TO_CHAR (NULL) AS cod_protocollo_pacchetto,
          ad.cod_ramo_calcolato,
          ad.cod_struttura_competente_dc,
          ad.cognome AS desc_cognome,
          ad.desc_istituto,
          TO_CHAR (NULL) AS desc_motiv_class,
          ad.nome AS desc_nome,
          ad.desc_nome_controparte,
          ad.desc_struttura_competente_dc,
          DECODE (d1.desc_tipo_gestione,
                  'B', 'FORFETTARIO IN SUPERO',
                  'E', 'ANALITICO',
                  '')
             AS desc_tipol_gestione,
          ad.dta_decorrenza_stato,
          ad.dta_scadenza_stato,
          ad.dta_utente_assegnato,
          1 AS flg_abi_lavorato,
          ad.flg_gestore_abilitato,
          ad.id_referente,
          ad.id_utente,
          ad.desc_gruppo_economico AS val_ana_gre,
          pa.val_ordine_colore
     FROM (SELECT cod_abi,
                  cod_ndg,
                  cod_tipo_pacchetto,
                  desc_tipo_gestione,
                  val_anno_proposta,
                  MAX (val_anno_proposta)
                     OVER (PARTITION BY cod_abi, cod_ndg)
                     AS max_val_anno_proposta,
                  val_progr_proposta,
                  MAX (val_progr_proposta)
                     OVER (PARTITION BY cod_abi, cod_ndg)
                     AS max_val_progr_proposta
             FROM t_mcrei_app_delibere
            WHERE     flg_attiva = '1'
                  AND cod_microtipologia_delib = 'CI'
                  AND flg_no_delibera = 0
                  AND cod_fase_delibera NOT IN ('AN', 'AM', 'VA')      --13dic
                  AND cod_fase_pacchetto NOT IN ('ANM', 'ANA')         --13dic
                  AND desc_tipo_gestione IN ('B', 'E')) d1,
          t_mcrei_app_alert_pos_wrk PARTITION (inc_p05) pa,
          vtmcre0_app_upd_fields ad
    WHERE     pa.cod_abi = d1.cod_abi
          AND pa.cod_ndg = d1.cod_ndg
          AND pa.cod_abi = ad.cod_abi_cartolarizzato
          AND pa.cod_ndg = ad.cod_ndg
          AND d1.val_anno_proposta = d1.max_val_anno_proposta
          AND d1.val_progr_proposta = d1.max_val_progr_proposta
          AND ad.id_utente <> -1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_ALERT_PRIV_RV TO MCRE_USR;
