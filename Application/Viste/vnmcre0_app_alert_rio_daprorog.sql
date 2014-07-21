/* Formatted on 21/07/2014 18:45:10 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALERT_RIO_DAPROROG
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
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   DTA_SERVIZIO,
   DTA_ULTIMA_PROROGA,
   DTA_LIMITE_PROROGA,
   COD_OD,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   VAL_MOTIVO_RICHIESTA,
   DESC_OD,
   FLG_ABI_LAVORATO
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(t)*/
                                         -- v1 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v2 06/05/2011 VG: COD_MACROSTATO
         ALERT_18 VAL_ALERT,
         (SELECT DECODE (
                    alert_18,
                    'V', val_verde,
                    DECODE (alert_18,
                            'A', val_arancio,
                            DECODE (alert_18, 'R', val_rosso, NULL)))
            FROM t_mcre0_app_alert
           WHERE id_alert = 18)
            val_ordine_colore,
         dta_ins_18 dta_ins_alert,
         a.cod_sndg,
         a.cod_abi_cartolarizzato,
         a.cod_abi_istituto,
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
         x.NOME DESC_NOME,
         x.COGNOME DESC_COGNOME,
         X.DTA_SERVIZIO,
         T.DTA_ESITO DTA_ULTIMA_PROROGA,
         DECODE (DTA_ESITO,
                 NULL, DTA_SERVIZIO + x.VAL_GG_PRIMA_PROROGA,
                 DTA_ESITO + x.VAL_GG_SECONDA_PROROGA)
            DTA_LIMITE_PROROGA,
         DECODE (DTA_ESITO,
                 NULL, x.VAL_OD_PRIMA_PROROGA,
                 x.VAL_OD_SECONDA_PROROGA)
            cod_od,
         x.COD_PRIV,
         x.FLG_GESTORE_ABILITATO,
         T.VAL_MOTIVO_RICHIESTA,
         (SELECT NOME_GRUPPO
            FROM T_MCRE0_APP_PR_LOV_GRUPPI
           WHERE ID_GRUPPO =
                    DECODE (DTA_ESITO,
                            NULL, x.VAL_OD_PRIMA_PROROGA,
                            x.VAL_OD_SECONDA_PROROGA))
            DESC_OD,
         --I.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO
    FROM t_mcre0_app_alert_pos a,
         --          MV_MCRE0_app_istituti i,
         --          t_mcre0_app_anagrafica_gruppo g,
         --          MV_MCRE0_APP_UPD_field x,
         --          T_MCRE0_APP_ANAGR_GRE GE,
         --          MV_MCRE0_denorm_str_org s,
         --          T_MCRE0_APP_UTENTI U,
         T_MCRE0_APP_RIO_PROROGHE T,
         --       T_MCRE0_APP_COMPARTI C,
         -- V_MCRE0_APP_UPD_FIELDS_ALL x
         -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
         V_MCRE0_APP_UPD_FIELDS x
   WHERE     ALERT_18 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND t.FLG_STORICO = 0
         AND t.FLG_ESITO = 1
         AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
         AND X.COD_NDG = a.COD_NDG
         AND X.COD_ABI_CARTOLARIZZATO = T.COD_ABI_CARTOLARIZZATO(+)
         AND X.COD_NDG = T.COD_NDG(+)
--          AND x.cod_abi_istituto = i.cod_abi(+)
--          AND x.cod_sndg = g.cod_sndg(+)
--          AND x.cod_gruppo_economico = ge.cod_gre(+)
--          AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
--          AND x.cod_filiale = s.cod_struttura_competente_fi(+)
--          AND X.ID_UTENTE = U.ID_UTENTE(+)
--          AND X.COD_COMPARTO = x.COD_COMPARTO
;
