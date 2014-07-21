/* Formatted on 21/07/2014 18:45:04 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALERT_POS_CLDAAL
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
   COD_STATO_PRECEDENTE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   ID_REFERENTE,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   FLG_ABI_LAVORATO,
   COD_MACROSTATO_PRECEDENTE,
   COD_STATO_DESTINAZIONE,
   DTA_INS_STATO_DESTINAZIONE
)
AS
   SELECT            /*ordered no_parallel(T) no_parallel(r) no_parallel(st)*/
          -- V1 ??/??/???? VG: prima versione
          -- V2 28/03/2011 MDM: Aggiunte  colonne "COD_STATO_DESTINAZIONE" e "DTA_INS_STATO_DESTINAZIONE" per uniformità con AFU
          -- V3 28/03/2011 MDM: Aggiunte  colonne "ID_REFERENTE", "COD_PRIV" e "FLG_GESTORE_ABILITATO"  per gestione visibilità in base al profilo utente
          -- v4 20/04/2011 VG: FLG_ABI_LAVORATO
          -- V5 22/04/2011 VG: cod_stato_precedente
          -- v6 06/05/2011 VG: COD_MACROSTATO
          alert_16 val_alert,
          (SELECT DECODE (
                     alert_16,
                     'V', val_verde,
                     DECODE (alert_16,
                             'A', val_arancio,
                             DECODE (alert_16, 'R', val_rosso, NULL)))
             FROM t_mcre0_app_alert
            WHERE id_alert = 16)
             val_ordine_colore,
          dta_ins_16 dta_ins_alert,
          a.cod_sndg,
          a.COD_ABI_CARTOLARIZZATO,
          a.COD_ABI_ISTITUTO,
          x.DESC_ISTITUTO,
          a.COD_NDG,
          X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
          x.COD_MACROSTATO,
          NVL (x.cod_comparto_assegn, x.COD_COMPARTO_APPART)
             cod_comparto_utente,
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
          x.COD_STRUTTURA_COMPETENTE_FI,
          x.DESC_STRUTTURA_COMPETENTE_FI,
          x.cod_processo,
          X.COD_STATO_PRECEDENTE,
          x.cod_stato,
          x.dta_decorrenza_stato,
          x.dta_scadenza_stato,
          x.id_utente,
          x.dta_utente_assegnato,
          x.NOME DESC_NOME,
          x.COGNOME DESC_COGNOME,
          x.ID_REFERENTE,
          x.COD_PRIV,
          x.FLG_GESTORE_ABILITATO,
          -- I.FLG_ABI_LAVORATO,
          DECODE (
             DTA_ABI_ELAB,
             (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
                FROM T_MCRE0_APP_ABI_ELABORATI), '1',
             '0')
             FLG_ABI_LAVORATO,
          st.COD_MACROSTATO COD_MACROSTATO_precedente,
          DECODE (st.COD_MACROSTATO,
                  'RIO', R.COD_MACROSTATO_DESTINAZIONE,
                  T.COD_MACROSTATO)
             COD_STATO_DESTINAZIONE,
          DECODE (st.COD_MACROSTATO, 'RIO', R.DTA_INS, T.DTA_INS)
             DTA_INS_STATO_DESTINAZIONE
     FROM t_mcre0_app_alert_pos a,
          --  MV_MCRE0_app_istituti i,
          -- t_mcre0_app_anagrafica_gruppo g,
          --  MV_MCRE0_APP_UPD_field x,
          -- T_MCRE0_APP_ANAGR_GRE GE,
          --   MV_MCRE0_denorm_str_org s,
          --   t_mcre0_app_utenti u,
          T_MCRE0_APP_PT_GESTIONE_TAVOLI T,
          T_MCRE0_APP_RIO_GESTIONE R,
          T_MCRE0_APP_STATI st,
          -- V_MCRE0_APP_UPD_FIELDS_ALL x
          -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
          V_MCRE0_APP_UPD_FIELDS x
    WHERE     alert_16 IS NOT NULL
          --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
          AND X.FLG_OUTSOURCING = 'Y'
          -- AND I.FLG_TARGET = 'Y'
          AND X.FLG_TARGET = 'Y'
          AND x.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
          AND x.cod_ndg = a.cod_ndg
          --    AND x.cod_abi_istituto = i.cod_abi(+)
          --    AND x.cod_sndg = g.cod_sndg(+)
          --    AND x.cod_gruppo_economico = ge.cod_gre(+)
          --    AND x.cod_abi_istituto = x.cod_abi_istituto_fi(+)
          --    AND x.cod_filiale = x.cod_struttura_competente_fi(+)
          --    AND x.id_utente = x.id_utente(+)
          AND x.cod_abi_cartolarizzato = t.cod_abi_cartolarizzato(+)
          AND x.cod_ndg = t.cod_ndg(+)
          AND x.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
          AND X.COD_NDG = R.COD_NDG(+)
          AND st.cod_microstato = X.COD_STATO_PRECEDENTE(+);
