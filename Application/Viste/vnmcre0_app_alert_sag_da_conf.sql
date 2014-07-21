/* Formatted on 21/07/2014 18:45:15 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALERT_SAG_DA_CONF
(
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   DTA_INS_ALERT,
   COD_SNDG,
   COD_NDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_COMPARTO_POSIZIONE,
   COD_RAMO_CALCOLATO,
   COD_MACROSTATO,
   COD_COMPARTO_UTENTE,
   DESC_ISTITUTO,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   DESC_NOME_CONTROPARTE,
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
   DTA_CALCOLO_SAG,
   COD_SAG,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   FLG_ABI_LAVORATO
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(t)*/
                               -- v1 06/04/2011 VG: sistemate condizioni where
                                    -- v2 08/04/2011 VG Modificata da DeMattia
                                         -- v3 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v4 06/05/2011 VG: COD_MACROSTATO
         alert_1 val_alert,
         (SELECT DECODE (
                    alert_1,
                    'V', val_verde,
                    DECODE (alert_1,
                            'A', val_arancio,
                            DECODE (alert_1, 'R', val_rosso, NULL)))
            FROM t_mcre0_app_alert
           WHERE id_alert = 1)
            val_ordine_colore,
         dta_ins_1 dta_ins_alert,
         a.cod_sndg,
         a.cod_ndg,
         a.cod_abi_cartolarizzato,
         a.COD_ABI_ISTITUTO,
         X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
         X.COD_RAMO_CALCOLATO,
         x.COD_MACROSTATO,
         --  NVL (x.cod_comparto_assegn, x.cod_comparto_appart) cod_comparto_utente
         x.cod_comparto_utente,
         x.desc_istituto,
         x.cod_gruppo_economico,
         x.desc_gruppo_economico val_ana_gre,
         x.desc_nome_controparte,
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
         x.id_utente,
         x.dta_utente_assegnato,
         x.nome desc_nome,
         x.cognome desc_cognome,
         t.dta_calcolo_sag,
         t.cod_sag,
         x.cod_priv,
         x.FLG_GESTORE_ABILITATO,
         x.ID_REFERENTE,
         --i.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO
    FROM t_mcre0_app_alert_pos a,         --          MV_MCRE0_app_istituti i,
                                  --          t_mcre0_app_anagrafica_gruppo g,
                                         --          MV_MCRE0_APP_UPD_field x,
                                         --          T_MCRE0_APP_ANAGR_GRE GE,
                                        --          MV_MCRE0_denorm_str_org s,
                                             --          t_mcre0_app_utenti u,
                                               -- V_MCRE0_APP_UPD_FIELDS_ALL x
       -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
          V_MCRE0_APP_UPD_FIELDS x, t_mcre0_app_sag t
   WHERE     ALERT_1 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
         AND x.cod_ndg = a.cod_ndg
         AND x.cod_sndg = t.cod_sndg(+)
--          AND x.cod_abi_istituto = i.cod_abi(+)
--          AND x.cod_sndg = g.cod_sndg(+)
--          AND x.cod_gruppo_economico = ge.cod_gre(+)
--          AND x.cod_abi_istituto = x.cod_abi_istituto_fi(+)
--          AND x.cod_filiale = x.cod_struttura_competente_fi(+)
--          AND x.id_utente = u.id_utente(+)
;
