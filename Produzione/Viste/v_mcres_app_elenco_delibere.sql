/* Formatted on 17/06/2014 18:10:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ELENCO_DELIBERE
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   DESC_NOME_GRUPPO_ECONOMICO,
   COD_PRATICA,
   COD_UO_PRATICA,
   DESC_PRESIDIO,
   VAL_ANNO_PRATICA,
   DTA_PASSAGGIO_SOFF,
   COD_PROTOCOLLO_DELIBERA,
   COD_STATO_DELIBERA,
   COD_ORGANO_DELIBERANTE,
   DTA_INSERIMENTO_DELIBERA,
   DTA_AGGIORNAMENTO_DELIBERA,
   COD_DELIBERA,
   DESC_DELIBERA,
   DESC_STATO_DELIBERA,
   DESC_ORGANO_DELIBERANTE,
   DTA_DELIBERA,
   COD_MATR_INSERENTE,
   COD_PROPOSTA,
   VAL_ESPOSIZIONE_LORDA_CAP,
   VAL_ESPOSIZIONE_NETTA_POST_DEL,
   VAL_IMPORTO_OFFERTO,
   VAL_RETTIFICA_VALORE_PROP,
   VAL_ACCANT_ANTE_DEL,
   VAL_ESPOSIZIONE_NETTA_ANTE_DEL,
   SCGB_DTA_RIF_CR,
   VAL_MESE_CR,
   VAL_ANNO_CR,
   SCGB_UTI_SIS,
   SCSB_UTI_CR,
   VAL_PERC_SISTEMA,
   DTA_DEC_STATO_INCAGLI,
   DESC_MOTIVAZIONE_FORZATURA,
   VAL_INDICATORE_ACCANTONAMENTO,
   VAL_UTENTE_AZIONE,
   DTA_NOTIFICA_ATTO,
   VAL_AUTORITA_GIUDIZIARIA,
   VAL_OGGETTO_DOMANDA,
   VAL_IMP_DOMANDA,
   VAL_ACCANT_RISCHI_ONERI,
   VAL_NEW_ACCANT_RISCHI_ONERI,
   DTA_PREVEDIBILE_ESBORSO,
   FLG_CONTENZIOSO_PASSIVO,
   VAL_ESBORSO,
   VAL_EFF_CONTO_ECONOMICO,
   DTA_ESBORSO,
   FLG_STRALCIO,
   VAL_ESPOSIZIONE_LORDA,
   VAL_ESPOSIZIONE_NETTA,
   VAL_IMP_STRALCIO,
   DTA_SICLI,
   VAL_UTI,
   VAL_UTI_CAPITALE,
   VAL_UTI_MORA,
   VAL_VANTATO,
   VAL_VANTATO_RATEO,
   VAL_VANTATO_STRALCI,
   VAL_ESP_LORDA_CAPITALE,
   VAL_ESP_LORDA_MORA,
   VAL_RETT_DA_INCAGLIO,
   VAL_RETT_DA_INC_STRALCI,
   VAL_RETT_VAL_ANTE_DEL,
   VAL_RETT_VAL_ANTE_DEL_FUORI,
   VAL_RETT_VAL_ANTE_DEL_RDV,
   VAL_RETT_VAL_ANTE_DEL_INTER,
   VAL_RETT_VAL_ANTE_DEL_SPESE,
   VAL_RETT_VAL_IN_DEL,
   VAL_ESPOSIZIONE_LORDA_STRALCIO,
   VAL_ESPOSIZIONE_NETTA_STRALCIO,
   DESC_FLG_CONT_PASSIVO,
   VAL_NOTE,
   VAL_NOTE_ANNULLAMENTO,
   FLG_STAMPA,
   COD_STATO_SOFF,
   VAL_CATEGORIA,
   DESC_RESPONSABILE,
   DTA_INOLTRO,
   DTA_TRASFERIMENTO,
   COD_OPERATORE_INS_UPD,
   VAL_IMP_RILEVANTE,
   VAL_IMP_RILEVANTE_DC_ISP,
   VAL_RDV_QC_DA_INCAGLIO,
   DTA_CONFERMA,
   VAL_MOTIVAZIONE_DEL_RW,
   COD_CAUSALE_CHIUSURA,
   COD_FILIALE_CLASS,
   DESC_FILIALE_CLASS,
   DESC_ADDETTO,
   COD_MATR_PRATICA,
   COD_SEGMENTO,
   DTA_PASS_STATO_RISC,
   COD_STATO_RISCHIO,
   DTA_INCAGLIO,
   COD_STATO_PC,
   DTA_STATO_GIUR,
   VAL_CODICE_CR,
   COD_RAMO,
   COD_SETTORE,
   DESC_RAMO,
   DESC_SETTORE,
   COD_PARTITA_IVA,
   VAL_ESPOS_LORDA_TOT,
   VAL_IMPORTO_SACRIFICIO,
   VAL_NOTE_FLUSSO,
   COD_TIPO_TRANSAZIONE,
   VAL_VANTATO_NOCONT,
   COD_FISCALE,
   COD_TIPO_STRALCIO,
   FLG_IND_GARANTI,
   VAL_NOTE_DESC_ANN,
   DTA_AGG_SISBA,
   VAL_VANTATO_SISBA,
   VAL_MORA_SISBA,
   VAL_STRALCI_FISC_SOFF,
   VAL_UTILIZZO_SISBA,
   VAL_ACCTI_SISBA,
   VAL_ATTUALIZ_SISBA,
   VAL_STRAL_QT_CAP_SISBA,
   VAL_STRAL_QT_MORA_SISBA,
   VAL_CAPITALE_SISBA,
   VAL_UTILIZZO_SICLI,
   VAL_CAPITALE_SICLI,
   VAL_MORA_SICLI,
   DTA_AGG_SICLI,
   VAL_ESPOS_LORDA_QT_MORA,
   VAL_PERC_RETT_VAL,
   DTA_SCADENZA,
   DTA_DEL_ESTERA,
   DTA_SCAD_DEL_ESTERA,
   VAL_PERC_DUBBIO_ESITO_EST,
   VAL_RETT_QT_CAP_ANTE98,
   VAL_RETT_QT_CAP_PROGR,
   VAL_INTERES_CORR,
   VAL_SPESE_LEGALI,
   VAL_ESPOS_LORDA_CAP_MORA,
   VAL_ACCTI_DELIB,
   DTA_STAMPA,
   DTA_SCADENZA_TRANSAZIONE,
   DTA_INIZIO_RELAZIONE,
   COD_PROTOCOLLO_DELIBERA_COLL,
   DESC_STRUTTURA_COMPETENTE,
   DESC_STATO_GIURIDICO,
   COD_UO,
   FLG_STEP5_ACTIVE,
   VAL_CAUSALE,
   ID_OBJECT_AL_TR,
   ID_OBJECT_AL_CO,
   ID_OBJECT_AL_AN,
   ID_OBJECT_DO,
   DTA_LASTUPD_STIMA,
   VAL_PERC_DUBBIO_ESITO
)
AS
   SELECT                                                     -- AP 09/11/2012
          -- VG 13/11/2012
          -- AG 26/11/2012 rimossa forzature per delibere RE e ES
          -- AG 20/02/2013 join su cod_od per recupero descizione organo deliberante
          -- AG 26/02/2013 esposizione t_mcres_app_delibere.cod_uo
          -- VG 28/05/2013  flg_step5_act ive
          -- VG 25/06/2013  dta_lastupd_stima, val_perc_dubbio_esito
          -- VG 29/07/2013 dati non reperiti da flusso
          -- VG 05/08/2013 val_causale
          -- VG 11/09/2013 val_note_annullamento
          -- VG 04/10/2013 sistemato accesso percorsi
          -- VG 20131028 Anomalia 202 Addetto, struttura competente e intestazione
          -- VG 20140314 escluse delibera va
          A.*,
          c.id_object AS id_object_al_tr,
          d.id_object AS id_object_al_co,
          e.id_object AS id_object_al_an,
          b.id_object AS id_object_do,
          (SELECT MAX (dta_stima)
             FROM v_mcres_app_stime s
            WHERE     s.cod_abi = a.cod_abi
                  AND s.cod_ndg = a.cod_ndg
                  AND s.cod_protocollo_delibera = a.cod_protocollo_delibera)
             dta_lastupd_stima,
          (SELECT val_perc_dubbio_esito
             FROM (SELECT cod_abi,
                          cod_ndg,
                          s.val_perc_dubbio_esito,
                          DTA_LAST_UPD_DELIBERA,
                          MAX (DTA_LAST_UPD_DELIBERA)
                             OVER (PARTITION BY cod_abi, cod_ndg)
                             last_UPD_DELIBERA
                     FROM t_mcrei_app_delibere s
                    --and s.cod_protocollo_delibera = a.cod_protocollo_delibera
                    WHERE s.COD_MICROTIPOLOGIA_DELIB IN ('CS', 'CZ')) ss
            WHERE     ss.cod_abi = a.cod_abi
                  AND ss.cod_ndg = a.cod_ndg
                  AND DTA_LAST_UPD_DELIBERA = LAST_UPD_DELIBERA)
             val_perc_dubbio_esito
     FROM (SELECT T.COD_ABI,
                  i.DESC_ISTITUTO,
                  T.COD_NDG,
                  t.COD_SNDG,
                  NVL (val_nominativo, a.DESC_NOME_CONTROPARTE)
                     DESC_NOME_CONTROPARTE,
                  cod_gruppo_economico,
                  NVL (val_gruppo, val_ana_gre) desc_nome_gruppo_economico,
                  T.COD_PRATICA,
                  T.COD_UO_PRATICA,
                  p.DESC_PRESIDIO,
                  T.VAL_ANNO_PRATICA,
                  DTA_PASSAGGIO_SOFF,
                  t.cod_protocollo_delibera,
                  t.cod_stato_delibera,
                  t.cod_organo_deliberante,
                  t.dta_inserimento_delibera,
                  t.dta_aggiornamento_delibera,
                  t.cod_delibera cod_delibera,
                  td.desc_delibera,
                  sd.desc_stato_delibera,
                  od.desc_organo_deliberante,
                  dta_delibera,
                  COD_MATR_INS COD_MATR_INSERENTE,
                  COD_PROPOSTA,
                  VAL_ESPOSIZIONE_LORDA_CAP,
                  VAL_ESPOSIZIONE_NETTA_POST_DEL,
                  VAL_IMPORTO_OFFERTO,
                  VAL_RETTIFICA_VALORE_PROP,
                  VAL_ACCANT_ANTE_DEL,
                  VAL_ESPOSIZIONE_NETTA_ANTE_DEL,
                  SCGB_DTA_RIF_CR,
                  TO_CHAR (SCGB_DTA_RIF_CR, 'Month') VAL_MESE_CR,
                  TO_CHAR (SCGB_DTA_RIF_CR, 'YYYY') VAL_ANNO_CR,
                  SCGB_UTI_SIS,
                  SCSB_UTI_CR,
                    100
                  * (  SCSB_UTI_CR
                     / DECODE (NVL (SCGB_UTI_SIS, 0), 0, 1, SCGB_UTI_SIS))
                     VAL_PERC_SISTEMA,
                  DTA_DEC_STATO_INCAGLI,
                  DESC_MOTIVAZIONE_FORZATURA,
                  VAL_INDICATORE_ACCANTONAMENTO,
                  VAL_UTENTE_AZIONE,
                  DTA_NOTIFICA_ATTO,
                  VAL_AUTORITA_GIUDIZIARIA,
                  VAL_OGGETTO_DOMANDA,
                  VAL_IMP_DOMANDA,
                  VAL_ACCANT_RISCHI_ONERI,
                  VAL_NEW_ACCANT_RISCHI_ONERI,
                  DTA_PREVEDIBILE_ESBORSO,
                  FLG_CONTENZIOSO_PASSIVO,
                  VAL_ESBORSO,
                  VAL_EFF_CONTO_ECONOMICO,
                  DTA_ESBORSO,
                  FLG_STRALCIO,
                  VAL_ESPOSIZIONE_LORDA,
                  VAL_ESPOSIZIONE_NETTA,
                  VAL_IMP_STRALCIO,
                  DTA_SICLI,
                  VAL_UTI,
                  VAL_UTI_CAPITALE,
                  VAL_UTI_MORA,
                  VAL_VANTATO,
                  VAL_VANTATO_RATEO,
                  VAL_VANTATO_STRALCI,
                  VAL_ESP_LORDA_CAPITALE,
                  VAL_ESP_LORDA_MORA,
                  VAL_RETT_DA_INCAGLIO,
                  VAL_RETT_DA_INC_STRALCI,
                  VAL_RETT_VAL_ANTE_DEL,
                  VAL_RETT_VAL_ANTE_DEL_FUORI,
                  VAL_RETT_VAL_ANTE_DEL_RDV,
                  VAL_RETT_VAL_ANTE_DEL_INTER,
                  VAL_RETT_VAL_ANTE_DEL_SPESE,
                  VAL_RETT_VAL_IN_DEL,
                  VAL_ESPOSIZIONE_LORDA_STRALCIO,
                  VAL_ESPOSIZIONE_NETTA_STRALCIO,
                  L.DESCRIZIONE DESC_FLG_CONT_PASSIVO,
                  T.VAL_NOTE,
                  CASE
                     WHEN t.cod_delibera IN ('NZ', 'FZ')
                     THEN
                        NVL (T.VAL_NOTE_ANNULLAMENTO, t.val_note_desc_ann)
                     ELSE
                        T.VAL_NOTE_ANNULLAMENTO
                  END
                     VAL_NOTE_ANNULLAMENTO,
                  T.FLG_STAMPA,
                  COD_STATO_SOFF,
                  OD.VAL_CATEGORIA,
                  OD.DESC_RESPONSABILE,
                  dta_inoltro,
                  dta_trasferimento,
                  t.cod_operatore_ins_upd,
                  val_imp_rilevante,
                  val_imp_rilevante_dc_isp,
                  val_rdv_qc_da_Incaglio,
                  dta_conferma,
                  val_motivazione_del_rw,
                  cod_CAUSALE_CHIUSURA,
                  COD_FILIALE_CLASS,
                  DESC_FILIALE_CLASS,
                  DESC_ADDETTO,
                  NVL (cod_matr_prat_del, COD_MATR_PRATICA) COD_MATR_PRATICA,
                  cod_SEGMENTO,
                  DTA_PASS_STATO_RISC,
                  cod_STATO_RISCHIO,
                  DTA_INCAGLIO,
                  cod_STATO_PC,
                  DTA_STATO_GIUR,
                  val_CODICE_CR,
                  t.cod_RAMO,
                  cod_SETTORE,
                  DESC_RAMO,
                  DESC_SETTORE,
                  a.val_partita_iva COD_PARTITA_IVA,
                  val_ESPOS_LORDA_TOT,
                  val_IMPORTO_SACRIFICIO,
                  val_NOTE_flusso,
                  cod_TIPO_TRANSAZIONE,
                  val_VANTATO_NOCONT,
                  a.val_partita_iva COD_FISCALE,
                  cod_TIPO_STRALCIO,
                  FLG_IND_GARANTI,
                  val_NOTE_DESC_ANN,
                  DTA_AGG_SISBA,
                  val_VANTATO_SISBA,
                  val_MORA_SISBA,
                  val_STRALCI_FISC_SOFF,
                  val_UTILIZZO_SISBA,
                  val_ACCTI_SISBA,
                  val_ATTUALIZ_SISBA,
                  val_STRAL_QT_CAP_SISBA,
                  val_STRAL_QT_MORA_SISBA,
                  val_CAPITALE_SISBA,
                  val_UTILIZZO_SICLI,
                  val_CAPITALE_SICLI,
                  val_MORA_SICLI,
                  DTA_AGG_SICLI,
                  val_ESPOS_LORDA_QT_MORA,
                  val_PERC_RETT_VAL,
                  t.DTA_SCADENZA,
                  DTA_DEL_ESTERA,
                  DTA_SCAD_DEL_ESTERA,
                  t.val_PERC_DUBBIO_ESITO_EST,
                  val_RETT_QT_CAP_ANTE98,
                  val_RETT_QT_CAP_PROGR,
                  t.val_INTERES_CORR,
                  val_SPESE_LEGALI,
                  val_ESPOS_LORDA_CAP_MORA,
                  val_ACCTI_DELIB,
                  DTA_STAMPA,
                  DTA_SCADENZA_TRANSAZIONE,
                  a.DTA_INIZIO_RELAZIONE,
                  COD_PROTOCOLLO_DELIBERA_COLL,
                  NVL (VAL_AREA, o.DESC_STRUTTURA_COMPETENTE)
                     DESC_STRUTTURA_COMPETENTE,
                  g.desc_STATO_GIURIDICO,
                  t.cod_uo,
                  flg_step5_active,
                  val_causale
             FROM (SELECT d.cod_abi,
                          D.COD_NDG,
                          Z.COD_SNDG,
                          Z.DTA_PASSAGGIO_SOFF,
                          d.cod_protocollo_delibera,
                          d.cod_stato_delibera,
                          d.cod_organo_deliberante,
                          d.dta_inserimento_delibera,
                          d.dta_aggiornamento_delibera,
                          d.cod_delibera,
                          d.val_anno_pratica,
                          D.COD_PRATICA,
                          P.COD_UO_PRATICA,
                          D.COD_PROPOSTA,
                          D.VAL_ESPOSIZIONE_LORDA_CAP,
                          D.VAL_ESPOSIZIONE_NETTA_POST_DEL,
                          D.VAL_IMPORTO_OFFERTO,
                          D.VAL_RETTIFICA_VALORE_PROP,
                          D.VAL_ACCANT_ANTE_DEL,
                          D.VAL_ESPOSIZIONE_NETTA_ANTE_DEL,
                          C.SCGB_DTA_RIF_CR,
                          C.SCGB_UTI_SIS,
                          C.SCSB_UTI_CR,
                          NVL (I.DTA_DECORRENZA_STATO,
                               H.DTA_DECORRENZA_STATO)
                             DTA_DEC_STATO_INCAGLI,
                          DESC_MOTIVAZIONE_FORZATURA,
                          VAL_INDICATORE_ACCANTONAMENTO,
                          VAL_UTENTE_AZIONE,
                          DTA_NOTIFICA_ATTO,
                          VAL_AUTORITA_GIUDIZIARIA,
                          VAL_OGGETTO_DOMANDA,
                          VAL_IMP_DOMANDA,
                          VAL_ACCANT_RISCHI_ONERI,
                          VAL_NEW_ACCANT_RISCHI_ONERI,
                          DTA_PREVEDIBILE_ESBORSO,
                          FLG_CONTENZIOSO_PASSIVO,
                          VAL_ESBORSO,
                          VAL_EFF_CONTO_ECONOMICO,
                          DTA_ESBORSO,
                          FLG_STRALCIO,
                          --  VG 20130724 VAL_ESPOSIZIONE_LORDA,
                          DECODE (flg_step5_active,
                                  1, VAL_ESPOSIZIONE_LORDA,
                                  VAL_ESPOS_LORDA_CAP_MORA)
                             VAL_ESPOSIZIONE_LORDA,
                          VAL_ESPOSIZIONE_NETTA,
                          --  VG 20130724 VAL_IMP_STRALCIO,
                          DECODE (flg_step5_active,
                                  1, VAL_IMP_STRALCIO,
                                  VAL_IMPORTO_SACRIFICIO)
                             VAL_IMP_STRALCIO,
                          DTA_SICLI,
                          --  VG 20130724 VAL_UTI,
                          DECODE (flg_step5_active,
                                  1, VAL_UTI,
                                  VAL_UTILIZZO_SISBA)
                             VAL_UTI,
                          --  VG 20130724 VAL_UTI_CAPITALE,
                          DECODE (flg_step5_active,
                                  1, VAL_UTI_CAPITALE,
                                  VAL_CAPITALE_SISBA)
                             VAL_UTI_CAPITALE,
                          --  VG 20130724 VAL_UTI_MORA,
                          DECODE (flg_step5_active,
                                  1, VAL_UTI_MORA,
                                  VAL_MORA_SISBA)
                             VAL_UTI_MORA,
                          VAL_VANTATO,
                          VAL_VANTATO_RATEO,
                          VAL_VANTATO_STRALCI,
                          --  VG 20130724 VAL_ESP_LORDA_CAPITALE,
                          DECODE (flg_step5_active,
                                  1, VAL_ESP_LORDA_CAPITALE,
                                  VAL_ESPOSIZIONE_LORDA_CAP)
                             VAL_ESP_LORDA_CAPITALE,
                          -- VG 20130724 VAL_ESP_LORDA_MORA,
                          DECODE (flg_step5_active,
                                  1, VAL_ESP_LORDA_MORA,
                                  VAL_ESPOS_LORDA_QT_MORA)
                             VAL_ESP_LORDA_MORA,
                          VAL_RETT_DA_INCAGLIO,
                          VAL_RETT_DA_INC_STRALCI,
                          --  VG 20130724 VAL_RETT_VAL_ANTE_DEL,
                          DECODE (flg_step5_active,
                                  1, VAL_RETT_VAL_ANTE_DEL,
                                  VAL_ACCANT_ANTE_DEL)
                             VAL_RETT_VAL_ANTE_DEL,
                          --  VG 20130724 VAL_RETT_VAL_ANTE_DEL_FUORI,
                          DECODE (flg_step5_active,
                                  1, VAL_RETT_VAL_ANTE_DEL_FUORI,
                                  VAL_RETT_QT_CAP_ANTE98)
                             VAL_RETT_VAL_ANTE_DEL_FUORI,
                          VAL_RETT_VAL_ANTE_DEL_RDV,
                          VAL_RETT_VAL_ANTE_DEL_INTER,
                          --  VG 20130724 VAL_RETT_VAL_ANTE_DEL_SPESE,
                          DECODE (flg_step5_active,
                                  1, VAL_RETT_VAL_ANTE_DEL_SPESE,
                                  VAL_SPESE_LEGALI)
                             VAL_RETT_VAL_ANTE_DEL_SPESE,
                          -- VG 20130724  VAL_RETT_VAL_IN_DEL,
                          DECODE (flg_step5_active,
                                  1, VAL_RETT_VAL_IN_DEL,
                                  VAL_RETTIFICA_VALORE_PROP)
                             VAL_RETT_VAL_IN_DEL,
                          D.VAL_ESPOSIZIONE_LORDA_STRALCIO,
                          D.VAL_ESPOSIZIONE_NETTA_STRALCIO,
                          -- VG 20130724  D.VAL_NOTE,
                          DECODE (flg_step5_active,
                                  1, VAL_NOTE,
                                  VAL_NOTE_FLUSSO)
                             VAL_NOTE,
                          D.VAL_NOTE_ANNULLAMENTO,
                          D.FLG_STAMPA,
                          D.COD_STATO_SOFF,
                          d.COD_MATR_INS,
                          d.dta_delibera,
                          dta_inoltro,
                          dta_trasferimento,
                          d.cod_operatore_ins_upd,
                          --                  di.val_rdv_qc_da_Incaglio,
                          CASE
                             WHEN cod_delibera = 'NS'
                             THEN
                                d.VAL_RETTIFICA_VALORE_PROP
                             WHEN     Z.DTA_PASSAGGIO_SOFF >
                                         TO_DATE ('31-12-2009', 'DD-MM-YYYY')
                                  AND cod_delibera IN ('RV', 'AS')
                             THEN
                                  VAL_RETT_VAL_ANTE_DEL
                                - d.val_rdv_qc_da_Incaglio
                                - VAL_RETT_VAL_ANTE_DEL_SPESE
                                - VAL_RETT_VAL_ANTE_DEL_INTER
                                + VAL_RETTIFICA_VALORE_PROP
                             WHEN     Z.DTA_PASSAGGIO_SOFF <=
                                         TO_DATE ('31-12-2009', 'DD-MM-YYYY')
                                  AND cod_delibera IN ('RV', 'AS')
                             THEN
                                  VAL_RETT_VAL_ANTE_DEL
                                - VAL_RETT_VAL_ANTE_DEL_FUORI
                                - VAL_RETT_VAL_ANTE_DEL_SPESE
                                - VAL_RETT_VAL_ANTE_DEL_INTER
                                + VAL_RETTIFICA_VALORE_PROP
                          END
                             val_imp_rilevante,
                          CASE
                             WHEN cod_delibera = 'NS'
                             THEN
                                d.VAL_RETTIFICA_VALORE_PROP
                             WHEN cod_delibera IN ('RV', 'AS')
                             THEN
                                  VAL_RETT_VAL_ANTE_DEL
                                - d.val_rdv_qc_da_Incaglio
                                - VAL_RETT_VAL_ANTE_DEL_SPESE
                                - VAL_RETT_VAL_ANTE_DEL_INTER
                                + VAL_RETTIFICA_VALORE_PROP
                          END
                             val_imp_rilevante_dc_isp,
                          dta_conferma,
                          CASE
                             WHEN cod_delibera = 'RW'
                             THEN
                                (SELECT MAX (desc_causa_prev_recupero)
                                   FROM t_mcrei_app_stime i
                                  WHERE     i.cod_abi = d.cod_abi
                                        AND i.cod_ndg = d.cod_ndg
                                        AND i.cod_protocollo_delibera =
                                               d.cod_protocollo_delibera
                                        AND UPPER (
                                               i.desc_causa_prev_recupero) =
                                               'SENZA EFFETTO ECONOMICO')
                             ELSE
                                NULL
                          END
                             val_motivazione_del_rw,
                          d.cod_CAUSALE_CHIUSURA,
                          COD_FILIALE_CLASS,
                          DESC_FILIALE_CLASS,
                          NVL (
                             (SELECT cognome || ' ' || nome
                                FROM t_mcres_app_utenti u
                               WHERE u.cod_matricola = p.COD_MATR_PRATICA),
                             p.COD_MATR_PRATICA)
                             DESC_ADDETTO,
                          d.COD_MATR_PRATICA,
                          cod_SEGMENTO,
                          DTA_PASS_STATO_RISC,
                          d.cod_STATO_RISCHIO,
                          (SELECT MAX (dta_decorrenza_stato)
                             FROM t_mcre0_app_percorsi p
                            WHERE     p.cod_abi_cartolarizzato = d.cod_abi
                                  AND p.cod_ndg = d.cod_ndg
                                  AND p.cod_stato = 'IN')
                             DTA_INCAGLIO,
                          cod_STATO_PC,
                          DTA_STATO_GIUR,
                          val_CODICE_CR,
                          cod_RAMO,
                          cod_SETTORE,
                          DESC_RAMO,
                          DESC_SETTORE,
                          COD_PARTITA_IVA,
                          val_ESPOS_LORDA_TOT,
                          val_IMPORTO_SACRIFICIO,
                          val_NOTE_flusso,
                          cod_TIPO_TRANSAZIONE,
                          val_VANTATO_NOCONT,
                          COD_FISCALE,
                          cod_TIPO_STRALCIO,
                          FLG_IND_GARANTI,
                          val_NOTE_DESC_ANN,
                          DTA_AGG_SISBA,
                          val_VANTATO_SISBA,
                          val_MORA_SISBA,
                          val_STRALCI_FISC_SOFF,
                          val_UTILIZZO_SISBA,
                          val_ACCTI_SISBA,
                          val_ATTUALIZ_SISBA,
                          val_STRAL_QT_CAP_SISBA,
                          val_STRAL_QT_MORA_SISBA,
                          val_CAPITALE_SISBA,
                          val_UTILIZZO_SICLI,
                          val_CAPITALE_SICLI,
                          val_MORA_SICLI,
                          DTA_AGG_SICLI,
                          val_ESPOS_LORDA_QT_MORA,
                          d.val_RDV_QC_DA_INCAGLIO,
                          val_PERC_RETT_VAL,
                          DTA_SCADENZA,
                          DTA_DEL_ESTERA,
                          DTA_SCAD_DEL_ESTERA,
                          d.val_PERC_DUBBIO_ESITO_EST,
                          val_RETT_QT_CAP_ANTE98,
                          val_RETT_QT_CAP_PROGR,
                          val_INTERES_CORR,
                          val_SPESE_LEGALI,
                          val_ESPOS_LORDA_CAP_MORA,
                          val_ACCTI_DELIB,
                          DTA_STAMPA,
                          D.DTA_SCADENZA_TRANSAZIONE,
                          COD_PROTOCOLLO_DELIBERA_COLL,
                          val_gruppo,
                          d.cod_uo,
                          d.flg_step5_active,
                          d.val_causale,
                          d.VAL_NOMINATIVO,
                          d.VAL_AREA,
                          d.COD_MATR_PRATICA cod_matr_prat_del
                     FROM T_MCRES_APP_DELIBERE D,
                          T_MCRES_APP_PRATICHE P,
                          T_MCRES_APP_POSIZIONI Z,
                          T_MCRE0_APP_CR C,
                          T_MCREI_APP_PRATICHE I,
                          t_mcrei_hst_pratiche h                           --,
                    --                  (select cod_abi,
                    --                            cod_ndg,
                    --                            val_rdv_qc_progressiva val_rdv_qc_da_Incaglio,
                    --                            dta_conferma_delibera
                    --                        from
                    --                        (select row_number() over (partition by cod_abi, cod_ndg order by dta_conferma_delibera desc nulls last) rn,d.*
                    --                            from t_mcrei_app_delibere d
                    --                            where 0=0
                    --                                and cod_fase_delibera = 'CO'
                    --                                and cod_microtipologia_delib in ('RV', 'T4', 'A0', 'IM')
                    --                                and dta_conferma_delibera is not null
                    --                                and val_rdv_qc_progressiva is not null
                    --                                and flg_attiva = '1'
                    --                        )where rn = 1
                    --                    ) di
                    WHERE     d.cod_delibera != 'VA'
                          AND d.cod_abi = p.cod_abi(+)
                          AND d.cod_ndg = p.cod_ndg(+)
                          AND d.cod_pratica = p.cod_pratica(+)
                          AND D.VAL_ANNO_PRATICA = P.VAL_ANNO(+)
                          AND D.COD_ABI = z.COD_ABI(+)
                          AND D.COD_NDG = Z.COD_NDG(+)
                          AND NVL (D.DTA_INSERIMENTO_DELIBERA,
                                   D.DTA_AGGIORNAMENTO_DELIBERA) BETWEEN Z.DTA_PASSAGGIO_SOFF
                                                                     AND Z.DTA_CHIUSURA
                          AND D.COD_ABI = C.COD_ABI_CARTOLARIZZATO(+)
                          AND D.COD_NDG = C.COD_NDG(+)
                          AND d.cod_abi = i.cod_abi(+)
                          AND d.cod_ndg = i.cod_ndg(+)
                          AND D.COD_PRATICA = I.COD_PRATICA(+)
                          AND D.VAL_ANNO_PRATICA = I.VAL_ANNO_PRATICA(+)
                          AND d.cod_abi = h.cod_abi(+)
                          AND d.cod_ndg = h.cod_ndg(+)
                          AND D.COD_PRATICA = h.COD_PRATICA(+)
                          AND D.VAL_ANNO_PRATICA = h.VAL_ANNO_PRATICA(+)
                          --                  AND D.COD_ABI = di.COD_ABI(+)
                          --                  AND D.COD_NDG = di.COD_NDG(+)
                          --and  nvl(d.dta_delibera,sysdate) >= Z.DTA_PASSAGGIO_SOFF
                          --AP 11/01/2013
                          AND COALESCE (D.DTA_INSERIMENTO_DELIBERA,
                                        D.DTA_DELIBERA,
                                        D.DTA_AGGIORNAMENTO_DELIBERA) >=
                                 Z.DTA_PASSAGGIO_SOFF
                          AND d.COD_STATO_RISCHIO = 'S') t,
                  t_mcres_cl_tipo_delibera td,
                  T_MCRES_CL_STATO_DELIBERA SD,
                  ((SELECT *
                      FROM (SELECT a.*,
                                   MAX (
                                      DTA_SCADENZA)
                                   OVER (
                                      PARTITION BY COD_ORGANO_DELIBERANTE,
                                                   cod_uo,
                                                   COD_ABI)
                                      DTA_SCADENZA_max
                              FROM T_MCRES_CL_ORGANO_DELIBERANTE a)
                     WHERE DTA_SCADENZA = DTA_SCADENZA_max)) OD,
                  T_MCRE0_APP_ANAGRAFICA_GRUPPO a,
                  T_MCRES_CL_LABELS L,
                  T_MCRES_APP_ISTITUTI I,
                  v_mcres_app_lista_presidi p,
                  t_mcre0_app_gruppo_economico ge,
                  t_mcre0_app_anagr_gre ag,
                  T_MCRE0_APP_STRUTTURA_ORG o,
                  T_MCRES_CL_STATO_GIURIDICO g
            WHERE     0 = 0
                  AND t.cod_sndg = ge.cod_sndg(+)
                  AND ge.cod_gruppo_economico = ag.cod_gre(+)
                  AND t.cod_delibera = td.cod_delibera(+)
                  AND T.COD_ABI = TD.COD_ABI(+)
                  AND t.cod_uo_pratica = p.cod_presidio(+)
                  AND T.COD_ABI = i.cod_abi(+)
                  AND td.flg_forfetaria(+) = 'S'
                  AND t.cod_stato_delibera = sd.cod_stato_delibera(+)
                  AND T.COD_ABI = OD.COD_ABI(+)
                  --          AND DECODE (
                  --                 t.cod_delibera,
                  --                 'ES', '02440',
                  --                 DECODE (t.cod_delibera, 'RE', '02440', substr(t.cod_protocollo_delibera,length(t.cod_protocollo_delibera)-4,5))) =
                  --                 OD.COD_UO(+)
                  AND t.cod_uo = od.cod_uo(+)     --  20130220 Andrea Galliano
                  AND T.COD_ORGANO_DELIBERANTE = OD.COD_ORGANO_DELIBERANTE(+)
                  --          AND TO_DATE ('99991231', 'YYYYMMDD') = OD.DTA_SCADENZA(+)      20130517 VG
                  AND T.COD_SNDG = a.cod_sndg(+)
                  AND T.FLG_CONTENZIOSO_PASSIVO = L.COD_LABEL(+)
                  AND 1 = L.COD_GRUPPO(+)
                  AND 'COD_UTILIZZO' = L.COD_UTILIZZO(+)
                  AND t.COD_UO_PRATICA = o.cod_struttura_competente(+)
                  AND t.cod_abi = o.COD_ABI_ISTITUTO(+)
                  AND t.COD_STATO_PC = g.COD_STATO_GIURIDICO(+)) A
          --AP 16/11/2012
          LEFT JOIN
          t_mcres_app_delibere coll_tr
             ON (    coll_tr.cod_abi = a.cod_abi
                 AND coll_tr.cod_protocollo_delibera_coll =
                        a.cod_protocollo_delibera
                 AND coll_tr.cod_stato_Delibera = 'TR')
          LEFT JOIN
          t_mcres_app_documenti C
             ON (    CASE
                        WHEN (coll_tr.cod_protocollo_delibera IS NOT NULL)
                        THEN
                           coll_tr.cod_protocollo_delibera
                        ELSE
                           a.cod_protocollo_delibera
                     END = c.cod_Aut_protoc
                 AND c.cod_tipo_documento = 'AL'
                 AND c.cod_stato = 'TR')
          LEFT JOIN
          t_mcres_app_documenti D
             ON (    a.cod_protocollo_delibera = d.cod_Aut_protoc
                 AND d.cod_tipo_documento = 'AL'
                 AND d.cod_stato = 'CO')
          LEFT JOIN
          t_mcres_app_documenti E
             ON (    a.cod_protocollo_delibera = e.cod_Aut_protoc
                 AND e.cod_tipo_documento = 'AL'
                 AND e.cod_stato = 'AN')
          LEFT JOIN
          t_mcres_app_documenti b
             ON (    a.cod_protocollo_delibera = b.cod_Aut_protoc
                 AND b.cod_tipo_documento = 'DO');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ELENCO_DELIBERE TO MCRE_USR;
