/* Formatted on 17/06/2014 18:00:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_RIO_GE_NDEF
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
   COD_MACROSTATO,
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
   FLG_ABI_LAVORATO,
   COD_STATO_DESTINAZIONE,
   DTA_INS_STATO_PROPOSTO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   FLG_CLASSIFICA,
   FLG_MOPLE,
   FLG_ANNULLA_PROPOSTA
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(p)*/
                                 -- VG1 08/04/2011: outer join su RIO_gestione
                                         -- v2 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v3 06/05/2011 VG: COD_MACROSTATO
         alert_45 val_alert,
         (SELECT DECODE (
                    alert_45,
                    'V', val_verde,
                    DECODE (alert_45,
                            'A', val_arancio,
                            DECODE (alert_45, 'R', val_rosso, NULL)))
            FROM t_mcre0_app_alert
           WHERE id_alert = 45)
            val_ordine_colore,
         dta_ins_45 dta_ins_alert,
         a.cod_sndg,
         a.cod_abi_cartolarizzato,
         a.cod_abi_istituto,
         x.desc_istituto,
         a.cod_ndg,
         x.cod_comparto cod_comparto_posizione,
         x.cod_macrostato,
         --  NVL (u.cod_comparto_assegn, u.cod_comparto_appart)    cod_comparto_utente,
         x.cod_comparto_utente,
         x.cod_ramo_calcolato,
         x.desc_nome_controparte,
         x.cod_gruppo_economico,
         x.desc_gruppo_economico val_ana_gre,
         x.cod_struttura_competente_dc,
         x.desc_struttura_competente_dc,
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
         --x.FLG_ABI_LAVORATO,
         DECODE (
            dta_abi_elab,
            (SELECT MAX (dta_abi_elab) dta_abi_elab_max
               FROM t_mcre0_app_abi_elaborati), '1',
            '0')
            flg_abi_lavorato,
         t.cod_macrostato_destinazione cod_stato_destinazione,
         t.dta_ins dta_ins_stato_proposto,
         x.id_utente,
         x.dta_utente_assegnato,
         x.nome desc_nome,
         x.cognome desc_cognome,
         x.flg_gestore_abilitato,
         x.id_referente,
         DECODE (
            t.cod_macrostato_destinazione,
            'PT', 1,
            DECODE (
               t.cod_macrostato_destinazione,
               'BO', 1,
               DECODE (t.cod_macrostato_destinazione,
                       'ES', 1,
                       DECODE (t.cod_macrostato_destinazione, 'RIO', 1, 0))))
            flg_classifica,
         DECODE (t.cod_macrostato_destinazione,
                 'IN', 1,
                 DECODE (t.cod_macrostato_destinazione, 'SO', 1, 0))
            flg_mople,
         0 flg_annulla_proposta
    FROM t_mcre0_app_alert_pos a,
         v_mcre0_app_upd_fields x,
         t_mcre0_app_rio_gestione t
   WHERE     alert_45 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND x.flg_outsourcing = 'Y'
         AND x.flg_target = 'Y'
         AND x.flg_target = 'Y'
         AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
         AND x.cod_ndg = a.cod_ndg
         AND x.cod_abi_cartolarizzato = t.cod_abi_cartolarizzato(+)
         AND x.cod_ndg = t.cod_ndg(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_ALERT_RIO_GE_NDEF TO MCRE_USR;
