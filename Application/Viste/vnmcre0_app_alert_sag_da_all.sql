/* Formatted on 21/07/2014 18:45:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALERT_SAG_DA_ALL
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
   DTA_CONFERMA,
   COD_SAG,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   COD_COMPARTO_POSIZIONE,
   COD_RAMO_CALCOLATO,
   COD_COMPARTO_UTENTE,
   DESC_NOME_CONTROPARTE,
   DESC_ISTITUTO,
   COD_GRUPPO_SUPER,
   FLG_ABI_LAVORATO
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(t)*/
                                -- v1 06/04/2011 VG sistemate condizioni where
                                    -- v2 08/04/2011 VG Modificata da DeMattia
                    -- v3 12/04/2011 LF Aggiunto COD_GRUPPO_SUPER da UPD_FIELD
                                         -- v4 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v5 06/05/2011 VG: COD_MACROSTATO
         ALERT_2 VAL_ALERT,
         (SELECT DECODE (
                    alert_2,
                    'V', val_verde,
                    DECODE (alert_2,
                            'A', val_arancio,
                            DECODE (alert_2, 'R', val_rosso, NULL)))
            FROM t_mcre0_app_alert
           WHERE id_alert = 2)
            val_ordine_colore,
         DTA_INS_2 DTA_INS_ALERT,
         a.COD_SNDG,
         a.COD_ABI_CARTOLARIZZATO,
         a.cod_ndg,
         a.cod_abi_istituto,
         x.cod_gruppo_economico,
         x.COD_MACROSTATO,
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
         x.id_utente,
         x.dta_utente_assegnato,
         x.nome desc_nome,
         x.cognome desc_cognome,
         T.DTA_CONFERMA,
         T.COD_SAG,
         x.COD_PRIV,
         x.FLG_GESTORE_ABILITATO,
         x.ID_REFERENTE,
         X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
         X.COD_RAMO_CALCOLATO,
         --  NVL (x.cod_comparto_assegn, x.cod_comparto_appart) cod_comparto_utente
         x.cod_comparto_utente,
         x.DESC_NOME_CONTROPARTE,
         x.desc_istituto,
         x.COD_GRUPPO_SUPER,
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
          t_mcre0_app_sag t,                   -- V_MCRE0_APP_UPD_FIELDS_ALL x
       -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
          V_MCRE0_APP_UPD_FIELDS x
   WHERE     alert_2 IS NOT NULL
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
--          AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
--          AND x.cod_filiale = s.cod_struttura_competente_fi(+)
--          AND x.id_utente = u.id_utente(+)
;
