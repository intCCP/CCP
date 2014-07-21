/* Formatted on 17/06/2014 18:15:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_ALERT_PREGIUDIZ
(
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   DTA_INS_ALERT,
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_ABI_ISTITUTO,
   COD_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
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
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   COD_COMPARTO_POSIZIONE,
   COD_RAMO_CALCOLATO,
   COD_COMPARTO_UTENTE,
   DESC_NOME_CONTROPARTE,
   DESC_ISTITUTO,
   COD_GRUPPO_SUPER,
   FLG_ABI_LAVORATO,
   NOTIZIE,
   DTA_ELABORAZIONE
)
AS
   SELECT alert_41 AS val_alert,
          (SELECT DECODE (
                     alert_41,
                     'V', val_verde,
                     DECODE (alert_41,
                             'A', val_arancio,
                             DECODE (alert_41, 'R', val_rosso, NULL)))
             FROM t_mcre0_app_alert
            WHERE id_alert = 41)
             AS val_ordine_colore,
          dta_ins_41 AS dta_ins_alert,
          a.cod_sndg AS cod_sndg,
          a.cod_abi_cartolarizzato AS cod_abi_cartolarizzato,
          a.cod_ndg AS cod_ndg,
          a.cod_abi_istituto AS cod_abi_istituto,
          x.cod_gruppo_economico AS cod_gruppo_economico,
          x.cod_macrostato AS cod_macrostato,
          x.desc_gruppo_economico AS val_ana_gre,
          x.cod_struttura_competente_dc AS cod_struttura_competente_dc,
          x.desc_struttura_competente_dc AS desc_struttura_competente_dc,
          x.cod_struttura_competente_rg AS cod_struttura_competente_rg,
          x.desc_struttura_competente_rg AS desc_struttura_competente_rg,
          x.cod_struttura_competente_ar AS cod_struttura_competente_ar,
          x.desc_struttura_competente_ar AS desc_struttura_competente_ar,
          x.cod_struttura_competente_fi AS cod_struttura_competente_fi,
          x.desc_struttura_competente_fi AS desc_struttura_competente_fi,
          x.cod_processo AS cod_processo,
          x.cod_stato AS cod_stato,
          x.dta_decorrenza_stato AS dta_decorrenza_stato,
          x.dta_scadenza_stato AS dta_scadenza_stato,
          x.id_utente AS id_utente,
          x.dta_utente_assegnato AS dta_utente_assegnato,
          x.nome AS desc_nome,
          x.cognome AS desc_cognome,
          x.cod_priv AS cod_priv,
          x.flg_gestore_abilitato AS flg_gestore_abilitato,
          x.id_referente AS id_referente,
          x.cod_comparto AS cod_comparto_posizione,
          x.cod_ramo_calcolato AS cod_ramo_calcolato,
          x.cod_comparto_utente AS cod_comparto_utente,
          x.desc_nome_controparte AS desc_nome_controparte,
          x.desc_istituto AS desc_istituto,
          x.cod_gruppo_super AS cod_gruppo_super,
          DECODE (
             dta_abi_elab,
             (SELECT MAX (dta_abi_elab) dta_abi_elab_max
                FROM t_mcre0_app_abi_elaborati), '1',
             '0')
             AS flg_abi_lavorato,
          (  SELECT RTRIM (                                        --20FEb2013
                       XMLAGG (XMLELEMENT (
                                  e,
                                     cod_tipo_notizia
                                  || '-'
                                  || desc_tipo_notizia
                                  || '; ') ORDER BY cod_tipo_notizia).EXTRACT (
                          '//text()'))
                       AS notizie
               FROM (SELECT DISTINCT
                            cod_sndg, cod_tipo_notizia, desc_tipo_notizia
                       FROM (SELECT cod_sndg,
                                    cod_tipo_notizia,
                                    desc_tipo_notizia,
                                    RANK ()
                                    OVER (PARTITION BY cod_sndg
                                          ORDER BY dta_elaborazione DESC)
                                       last_5
                               FROM t_mcre0_app_pregiudizievoli) a
                      WHERE last_5 < 6) t
              WHERE x.cod_sndg = t.cod_sndg
           GROUP BY cod_sndg)
             AS notizie,
          (  SELECT MAX (dta_elaborazione) AS dta_elaborazione
               FROM t_mcre0_app_pregiudizievoli t
              WHERE x.cod_sndg = t.cod_sndg
           GROUP BY cod_sndg)
             AS dta_elaborazione
     FROM t_mcre0_app_alert_pos a, vtmcre0_app_upd_fields x
    WHERE     alert_41 IS NOT NULL
          AND x.flg_outsourcing = 'Y'
          AND x.flg_target = 'Y'
          AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
          AND x.cod_ndg = a.cod_ndg;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_ALERT_PREGIUDIZ TO MCRE_USR;
