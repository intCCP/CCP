/* Formatted on 21/07/2014 18:45:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALERT_RIO_RIFPRORG
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
   DTA_RICHIESTA,
   DTA_RIFIUTO_PROROGA,
   DESC_MOTIVO_RIFIUTO,
   DESC_MOTIVO_RICHIESTA,
   DESC_OD,
   FLG_GESTORE_ABILITATO,
   COD_PRIV,
   FLG_ABI_LAVORATO
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(t)*/
                                                    -- v1 20/04/2011 VG: Nuova
                                           -- v2 06/05/2011 VG: COD_MACROSTATO
         ALERT_20 VAL_ALERT,
         (SELECT DECODE (
                    ALERT_20,
                    'V', VAL_VERDE,
                    DECODE (ALERT_20,
                            'A', VAL_ARANCIO,
                            DECODE (ALERT_20, 'R', VAL_ROSSO, NULL)))
            FROM T_MCRE0_APP_ALERT
           WHERE ID_ALERT = 20)
            VAL_ORDINE_COLORE,
         dta_ins_20 dta_ins_alert,
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
         x.NOME DESC_NOME,
         x.COGNOME DESC_COGNOME,
         X.DTA_SERVIZIO,
         T.DTA_ESITO DTA_ULTIMA_PROROGA,
         DECODE (T.DTA_ESITO,
                 NULL, DTA_SERVIZIO + x.VAL_GG_PRIMA_PROROGA,
                 T.DTA_ESITO + x.VAL_GG_SECONDA_PROROGA)
            DTA_LIMITE_PROROGA,
         DECODE (T.DTA_ESITO,
                 NULL, x.VAL_OD_PRIMA_PROROGA,
                 x.VAL_OD_SECONDA_PROROGA)
            COD_OD,
         R.DTA_RICHIESTA,
         R.DTA_ESITO DTA_RIFIUTO_PROROGA,
         R.VAL_MOTIVO_ESITO DESC_MOTIVO_RIFIUTO,
         R.VAL_MOTIVO_RICHIESTA DESC_MOTIVO_RICHIESTA,
         (SELECT NOME_GRUPPO
            FROM T_MCRE0_APP_PR_LOV_GRUPPI
           WHERE ID_GRUPPO =
                    DECODE (T.DTA_ESITO,
                            NULL, x.VAL_OD_PRIMA_PROROGA,
                            x.VAL_OD_SECONDA_PROROGA))
            DESC_OD,
         x.FLG_GESTORE_ABILITATO,
         x.COD_PRIV,
         --x.FLG_ABI_LAVORATO,
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
         (SELECT P.*,
                 FIRST_VALUE (
                    p.cod_sequence)
                 OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg
                       ORDER BY cod_sequence DESC)
                    cod_sequence_max
            FROM T_MCRE0_APP_RIO_PROROGHE P
           WHERE P.FLG_STORICO = 1) T,
         T_MCRE0_APP_RIO_PROROGHE R,
         --  t_mcre0_app_comparti c
         -- V_MCRE0_APP_UPD_FIELDS_ALL x
         -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
         V_MCRE0_APP_UPD_FIELDS x
   WHERE     ALERT_20 IS NOT NULL
         AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND x.FLG_TARGET = 'Y'
         AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
         AND X.COD_NDG = a.COD_NDG
         AND X.COD_ABI_CARTOLARIZZATO = T.COD_ABI_CARTOLARIZZATO(+)
         AND X.COD_NDG = T.COD_NDG(+)
         AND NVL (T.COD_SEQUENCE, r.COD_SEQUENCE) =
                NVL (T.COD_SEQUENCE_MAX, r.COD_SEQUENCE)
         AND X.COD_ABI_CARTOLARIZZATO = r.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = R.COD_NDG
         AND R.FLG_ESITO = 0
         AND r.flg_storico = 0
--          AND x.cod_abi_istituto = x.cod_abi(+)
--          AND x.cod_sndg = g.cod_sndg(+)
--          AND x.cod_gruppo_economico = ge.cod_gre(+)
--          AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
--          AND x.cod_filiale = s.cod_struttura_competente_fi(+)
--          AND X.ID_UTENTE = U.ID_UTENTE(+)
--          AND X.COD_COMPARTO = x.COD_COMPARTO
;
