/* Formatted on 21/07/2014 18:45:09 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALERT_RIO_AZ_SNC
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
   COD_COMPARTO_UTENTE,
   COD_RAMO_CALCOLATO,
   DESC_NOME_CONTROPARTE,
   COD_MACROSTATO,
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
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   FLG_ABI_LAVORATO,
   DESC_NOME,
   DESC_COGNOME,
   FLG_GESTORE_ABILITATO,
   DTA_SCADENZA_AZIONE,
   COD_AZIONE,
   DESC_AZIONE_SCADUTA
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(r)*/
                                         -- v1 20/04/2011 VG: FLG_ABI_LAVORATO
                                    -- v2 21/04/2011 VG: FLG_GESTORE_ABILITATO
                              -- v3 02/05/2011 VG: Modificata scelta posizione
                                           -- v4 06/05/2011 VG: COD_MACROSTATO
         alert_6 val_alert,
         (SELECT DECODE (
                    alert_6,
                    'V', val_verde,
                    DECODE (alert_6,
                            'A', val_arancio,
                            DECODE (alert_6, 'R', val_rosso, NULL)))
            FROM t_mcre0_app_alert
           WHERE id_alert = 6)
            val_ordine_colore,
         dta_ins_6 dta_ins_alert,
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
         x.cod_processo,
         x.cod_stato,
         x.dta_decorrenza_stato,
         X.DTA_SCADENZA_STATO,
         X.ID_UTENTE,
         X.DTA_UTENTE_ASSEGNATO,
         --I.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO,
         x.nome desc_nome,
         x.cognome desc_cognome,
         x.FLG_GESTORE_ABILITATO,
         t.dta_scadenza dta_scadenza_azione,
         t.cod_azione,
         r.descrizione_azione desc_azione_scaduta
    FROM t_mcre0_app_alert_pos a,
         --          MV_MCRE0_app_istituti i,
         --          t_mcre0_app_anagrafica_gruppo g,
         --          MV_MCRE0_APP_UPD_field x,
         --          T_MCRE0_APP_ANAGR_GRE GE,
         --          MV_MCRE0_denorm_str_org s,
         --          t_mcre0_app_utenti u,
         --          -- t_mcre0_app_rio_azioni t,
         (SELECT a.*,
                 DENSE_RANK ()
                 OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg
                       ORDER BY dta_scadenza, DTA_inserimento)
                    val_ordine
            FROM t_mcre0_app_rio_azioni a
           WHERE FLG_STATUS != 'C' AND DTA_SCADENZA < TRUNC (SYSDATE)) t,
         t_mcre0_cl_rio_azioni r,
         -- V_MCRE0_APP_UPD_FIELDS_ALL x
         -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
         V_MCRE0_APP_UPD_FIELDS x
   WHERE     ALERT_6 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND t.val_ordine = 1
         AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
         AND x.cod_ndg = a.cod_ndg
         AND x.cod_abi_cartolarizzato = t.cod_abi_cartolarizzato
         AND x.cod_ndg = t.cod_ndg
         AND t.cod_azione = r.cod_azione(+)
--          AND x.cod_abi_istituto = i.cod_abi(+)
--          AND x.cod_sndg = g.cod_sndg(+)
--          AND x.cod_gruppo_economico = ge.cod_gre(+)
--          AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
--          AND x.cod_filiale = s.cod_struttura_competente_fi(+)
--          AND x.id_utente = u.id_utente(+)
;
