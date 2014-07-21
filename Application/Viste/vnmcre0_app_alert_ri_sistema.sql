/* Formatted on 21/07/2014 18:45:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALERT_RI_SISTEMA
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
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   FLG_GESTORE_ABILITATO,
   COD_STATO_SIS,
   DTA_RIFERIMENTO_CR
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(cr)*/
                                                    -- v1 26/04/2011 VG: Nuova
                                           -- v2 06/05/2011 VG: COD_MACROSTATO
         ALERT_23 VAL_ALERT,
         (SELECT DECODE (
                    alert_23,
                    'V', val_verde,
                    DECODE (alert_23,
                            'A', val_arancio,
                            DECODE (alert_23, 'R', val_rosso, NULL)))
            FROM t_mcre0_app_alert
           WHERE id_alert = 23)
            val_ordine_colore,
         dta_ins_23 dta_ins_alert,
         a.cod_sndg,
         a.COD_ABI_CARTOLARIZZATO,
         a.COD_ABI_ISTITUTO,
         x.DESC_ISTITUTO,
         a.cod_ndg,
         x.cod_comparto cod_comparto_posizione,
         x.COD_MACROSTATO,
         --  NVL (x.cod_comparto_assegn, x.cod_comparto_appart) cod_comparto_utente
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
         X.COD_PROCESSO,
         X.COD_STATO,
         X.DTA_DECORRENZA_STATO,
         x.dta_scadenza_stato,
         --x.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO,
         x.id_utente,
         X.DTA_UTENTE_ASSEGNATO,
         x.NOME DESC_NOME,
         x.COGNOME DESC_COGNOME,
         x.FLG_GESTORE_ABILITATO,
         CR.SCGB_COD_STATO_SIS COD_STATO_SIS,
         CR.SCGB_DTA_RIF_CR DTA_RIFERIMENTO_CR
    FROM t_mcre0_app_alert_pos a,              -- V_MCRE0_APP_UPD_FIELDS_ALL x
       -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
          V_MCRE0_APP_UPD_FIELDS x,       --          MV_MCRE0_app_istituti i,
                                  --          t_mcre0_app_anagrafica_gruppo g,
                                         --          MV_MCRE0_APP_UPD_field x,
                                         --          T_MCRE0_APP_ANAGR_GRE GE,
                                        --          MV_MCRE0_denorm_str_org s,
                                             --          T_MCRE0_APP_UTENTI U,
          t_mcre0_app_cr cr
   WHERE     ALERT_23 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
         AND X.COD_NDG = a.COD_NDG
         AND a.cod_abi_cartolarizzato = cr.cod_abi_cartolarizzato
         AND a.cod_ndg = cr.cod_ndg
--          AND x.cod_abi_istituto = i.cod_abi(+)
--          AND x.cod_sndg = g.cod_sndg(+)
--          AND x.cod_gruppo_economico = ge.cod_gre(+)
--          AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
--          AND x.cod_filiale = s.cod_struttura_competente_fi(+)
--          AND x.id_utente = u.id_utente(+)
;
