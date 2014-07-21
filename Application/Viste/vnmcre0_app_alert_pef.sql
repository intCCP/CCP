/* Formatted on 21/07/2014 18:45:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALERT_PEF
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
   DTA_SCADENZA_REV_FIDI,
   COD_OD_PROPOSTO,
   COD_ULTIMO_OD,
   DTA_COMPLETAMENTO_FILIALE,
   DTA_REVISIONE_FIDI
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(p)*/
                                                    -- v1 26/04/2011 VG: Nuova
                                           -- v2 06/05/2011 VG: COD_MACROSTATO
         ALERT_3 VAL_ALERT,
         (SELECT DECODE (
                    alert_3,
                    'V', val_verde,
                    DECODE (alert_3,
                            'A', val_arancio,
                            DECODE (alert_3, 'R', val_rosso, NULL)))
            FROM t_mcre0_app_alert
           WHERE id_alert = 3)
            val_ordine_colore,
         dta_ins_3 dta_ins_alert,
         a.cod_sndg,
         a.COD_ABI_CARTOLARIZZATO,
         a.COD_ABI_ISTITUTO,
         x.DESC_ISTITUTO,
         a.cod_ndg,
         x.cod_comparto cod_comparto_posizione,
         x.COD_MACROSTATO,
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
         X.COD_PROCESSO,
         X.COD_STATO,
         X.DTA_DECORRENZA_STATO,
         x.dta_scadenza_stato,
         --i.FLG_ABI_LAVORATO,
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
         P.DTA_SCADENZA_FIDO DTA_SCADENZA_REV_FIDI,
         P.COD_ODE COD_OD_PROPOSTO,
         P.COD_CTS_ULTIMO_ODE COD_ULTIMO_OD,
         P.DTA_COMPLETAMENTO_PEF dta_completamento_filiale,
         P.DTA_ULTIMA_REVISIONE dta_revisione_fidi
    FROM t_mcre0_app_alert_pos a,                  -- MV_MCRE0_app_istituti i,
                                  -- t_mcre0_app_anagrafica_gruppo g,
                                  -- MV_MCRE0_APP_UPD_field x,
                                  --  T_MCRE0_APP_ANAGR_GRE GE,
                                  --  MV_MCRE0_denorm_str_org s,
                                  -- T_MCRE0_APP_UTENTI U,
                                  t_mcre0_app_pef p, --   V_MCRE0_APP_UPD_FIELDS_ALL x
       -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
          V_MCRE0_APP_UPD_FIELDS x
   WHERE     ALERT_3 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
         AND X.COD_NDG = A.COD_NDG
         AND a.COD_ABI_istituto = p.COD_ABI_istituto
         AND a.cod_ndg = p.cod_ndg
--AND x.cod_abi_istituto = i.cod_abi(+)
--AND x.cod_sndg = g.cod_sndg(+)
--AND x.cod_gruppo_economico = ge.cod_gre(+)
--AND x.cod_abi_istituto = x.cod_abi_istituto_fi(+)
--AND x.cod_filiale = x.cod_struttura_competente_fi(+)
--AND x.id_utente = u.id_utente(+)
;
