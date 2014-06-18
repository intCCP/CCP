/* Formatted on 17/06/2014 18:14:55 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_ALERT_PA
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
   ID_REFERENTE,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   FLG_GESTORE_ABILITATO,
   VAL_PA,
   VAL_PA_PC
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(ir)*/
                                                    -- v1 26/04/2011 VG: Nuova
                                           -- v2 06/05/2011 VG: COD_MACROSTATO
                                                        -- v3 prova rilev diff
         alert_14 val_alert,
         (SELECT DECODE (
                    alert_14,
                    'V', val_verde,
                    DECODE (alert_14,
                            'A', val_arancio,
                            DECODE (alert_14, 'R', val_rosso, NULL)))
            FROM t_mcre0_app_alert
           WHERE id_alert = 14)
            val_ordine_colore,
         dta_ins_14 dta_ins_alert,
         a.cod_sndg,
         a.cod_abi_cartolarizzato,
         a.cod_abi_istituto,
         x.desc_istituto,
         a.cod_ndg,
         x.cod_comparto cod_comparto_posizione,
         x.cod_macrostato,
         --NVL (u.cod_comparto_assegn, u.cod_comparto_appart) cod_comparto_utente
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
         DECODE (
            dta_abi_elab,
            (SELECT MAX (dta_abi_elab) dta_abi_elab_max
               FROM t_mcre0_app_abi_elaborati), '1',
            '0')
            flg_abi_lavorato,
         x.id_referente,
         x.id_utente,
         x.dta_utente_assegnato,
         x.nome desc_nome,
         x.cognome desc_cognome,
         x.flg_gestore_abilitato,
         pa.perdita_attesa val_pa,
         pc.val_pa val_pa_pc
    FROM t_mcre0_app_alert_pos a,
         vtmcre0_app_upd_fields x,
         t_mcre0_app_perdita_attesa pa,
         v_mcre0_app_scheda_anag_sc_pc pc
   WHERE     alert_14 IS NOT NULL
         AND x.flg_outsourcing = 'Y'
         AND x.flg_target = 'Y'
         AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
         AND x.cod_ndg = a.cod_ndg
         AND x.cod_abi_cartolarizzato = pc.cod_abi_cartolarizzato
         AND x.cod_ndg = pc.cod_ndg
         AND x.cod_sndg = pa.cod_sndg;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_ALERT_PA TO MCRE_USR;
