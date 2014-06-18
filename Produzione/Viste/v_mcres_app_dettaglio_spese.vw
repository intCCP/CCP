/* Formatted on 17/06/2014 18:10:10 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_DETTAGLIO_SPESE
(
   COD_ABI,
   COD_AUTORIZZAZIONE,
   COD_TIPO_AUTORIZZAZIONE,
   VAL_ANNO_PRATICA,
   COD_PRATICA,
   COD_STATO,
   VAL_NUMERO_FATTURA,
   DTA_FATTURA,
   COD_IMPORTO_DIVISA,
   VAL_IMPORTO_VALORE,
   COD_CAUSALE,
   COD_CAUSA_DIVISA,
   VAL_CAUSA_IMPORTO,
   COD_INTESTATARIO_TIPO,
   DESC_INTESTATARIO,
   VAL_INTESTATARIO_CODFISC,
   VAL_INTESTATARIO_PIVA,
   COD_AFAVORE_TIPO,
   DESC_AFAVORE,
   VAL_AFAVORE_CODFISC,
   VAL_AFAVORE_PIVA,
   FLG_CONVENZIONE,
   DESC_SPESA,
   FLG_SPESA_RIPETIBILE,
   VAL_ENTE_PAGATORE,
   COD_TIPO_PAGAMENTO,
   VAL_BON_DESTINATARIO,
   VAL_BON_COORDINATE,
   DTA_BON_VALUTA,
   VAL_CIRC_INTESTATARIO,
   VAL_CIRC_TRASFERIBILE,
   FLG_SPESA_RECUPERATA,
   COD_ORGANO_AUTORIZZANTE,
   VAL_NOTE,
   VAL_SPESA_NON_FATTURATA,
   COD_PUNTO_OPERATIVO,
   COD_PROTOCOLLO,
   DTA_GENERAZIONE_PROTOCOLLO,
   COD_INTESTATARIO_ABI,
   COD_INTESTATARIO_CAB,
   VAL_INTESTATARIO_CONTO,
   FLG_ANN_AUTORIZ,
   COD_AUTORIZZAZIONE_PADRE,
   DTA_UPD,
   COD_PRATICA_CEDUTA,
   FLG_CARICO_CESSIONARIO,
   COD_UO_PRATICA,
   COD_IBAN,
   VAL_FAX,
   VAL_RIFERIMENTO_NOMINATIVO,
   VAL_RAPPRESENTANTE,
   VAL_NOTE2,
   FLG_FM,
   VAL_IMPORTO_FM,
   COD_NDG,
   VAL_NOTE_FM,
   VAL_NUM_PROFORMA,
   DTA_PROFORMA_A_FATTURA,
   COD_CAUSALE_888,
   COD_MATRICOLA_AGG_STATO_Z,
   DTA_AUTORIZZAZIONE,
   COD_MATRICOLA,
   COD_UO,
   DTA_UPD_SPESA,
   DTA_INS_SPESA,
   VAL_PROF_COMUNE,
   VAL_PROF_FAX,
   VAL_PROF_INDIRIZZO,
   VAL_PROF_NCIVICO,
   VAL_PROF_PROVINCIA,
   VAL_PROF_CAP,
   DTA_STORNO_CONTABILE,
   COD_CONTROPARTITA,
   COD_DIVISA,
   COD_FILIALE,
   COD_TIPO,
   VAL_IMPORTO,
   COD_RIFERIMENTO,
   COD_OPERAZIONE_FATT,
   COD_PROGR_OPERAZIONE,
   DTA_SOLARE_OPERAZIONE,
   VAL_NUOVA_OPERAZIONE,
   COD_RAPPORTO,
   COD_FILIALE_COMPETENTE,
   FLG_TIPO_RAPPORTO,
   COD_UO_PRATICA_PR,
   COD_MATR_PRATICA,
   COD_SNDG,
   COD_STRUTTURA_COMPETENTE,
   DESC_STRUTTURA_COMPETENTE,
   COD_LIVELLO,
   DESC_NOME_CONTROPARTE,
   VAL_CAP_STRUTTURA,
   VAL_CITTA_STRUTTURA,
   VAL_EMAIL_STRUTTURA,
   VAL_FAX_STRUTTURA,
   VAL_INDIRIZZO_STRUTTURA,
   VAL_PROVINCIA_STRUTTURA,
   VAL_TELEFONO_STRUTTURA,
   DESC_ISTITUTO,
   VAL_PARTITA_IVA,
   VAL_STATO_PL,
   DTA_APERTURA,
   DESC_FILIALE_COMPETENTE,
   VAL_IMP_GBV,
   VAL_IMP_NBV,
   VAL_TOT_ESBORSI,
   COD_OD_CALCOLATO,
   COD_RAPPORTO_ORIG,
   REGIME_IVA,
   ALIQUOTA_IVA,
   ALIQUOTA_CPA,
   IMPORTO_CPA,
   IMPORTO_IVA,
   IMPORTO_RITENUTA,
   FLG_RITENUTA_APPLICABILE,
   FLG_FATTURA_DIGITALE,
   IMPORTO_VOCE,
   VAL_ALIQUOTA_RITENUTA,
   VAL_PERC_RITENUTA,
   VAL_WBS,
   DTA_INVIO_PAGAMENTO,
   DESC_MOT_ANNUL_SPESA,
   VAL_INDIRIZZO,
   VAL_COMUNE,
   VAL_PROV,
   VAL_CAP,
   VAL_TELEFONO,
   VAL_FAX_GESTORE,
   VAL_EMAIL,
   FLG_PREAUTORIZZATO,
   COD_REGISTRAZIONE_SAP,
   DTA_REGISTRAZIONE_SAP,
   VAL_TIPO_PAGAMENTO_SAP,
   DTA_PAGAMENTO_SAP,
   VAL_ID_PAGAMENTO_SAP,
   VAL_ESITO_PAGAMENTO,
   DTA_INVIO_SAP
)
AS
   SELECT                                                          -- 20130108
          -- VG - 20130226 : Gestori
          --20130321 Aggiunta decode per MOPLE cod_stato
          --20130328 Modificata decodifica MOPLE cod_stato
          --20131223 VG Importo_voce e regime_iva
          -- 20140219 VG VAL_TIPO_PAGAMENTO_SAP
          a.COD_ABI,
          a.COD_AUTORIZZAZIONE,
          a.COD_TIPO_AUTORIZZAZIONE,
          a.VAL_ANNO_PRATICA,
          a.COD_PRATICA,
          DECODE (a.COD_STATO,
                  'P', 'IM',
                  'A', 'CO',
                  'D', 'DE',
                  'X', 'AN',
                  a.COD_STATO)
             COD_STATO,
          a.VAL_NUMERO_FATTURA,
          a.DTA_FATTURA,
          a.COD_IMPORTO_DIVISA,
          a.VAL_IMPORTO_VALORE,
          a.COD_CAUSALE,
          a.COD_CAUSA_DIVISA,
          a.VAL_CAUSA_IMPORTO,
          a.COD_INTESTATARIO_TIPO,
          a.DESC_INTESTATARIO,
          a.VAL_INTESTATARIO_CODFISC,
          a.VAL_INTESTATARIO_PIVA,
          a.COD_AFAVORE_TIPO,
          a.DESC_AFAVORE,
          a.VAL_AFAVORE_CODFISC,
          a.VAL_AFAVORE_PIVA,
          a.FLG_CONVENZIONE,
          a.DESC_SPESA,
          a.FLG_SPESA_RIPETIBILE,
          a.VAL_ENTE_PAGATORE,
          a.COD_TIPO_PAGAMENTO,
          a.VAL_BON_DESTINATARIO,
          a.VAL_BON_COORDINATE,
          a.DTA_BON_VALUTA,
          a.VAL_CIRC_INTESTATARIO,
          a.VAL_CIRC_TRASFERIBILE,
          a.FLG_SPESA_RECUPERATA,
          a.COD_ORGANO_AUTORIZZANTE,
          a.VAL_NOTE,
          a.VAL_SPESA_NON_FATTURATA,
          a.COD_PUNTO_OPERATIVO,
          a.COD_PROTOCOLLO,
          a.DTA_GENERAZIONE_PROTOCOLLO,
          a.COD_INTESTATARIO_ABI,
          a.COD_INTESTATARIO_CAB,
          a.VAL_INTESTATARIO_CONTO,
          a.FLG_ANN_AUTORIZ,
          a.COD_AUTORIZZAZIONE_PADRE,
          a.DTA_UPD,
          a.COD_PRATICA_CEDUTA,
          a.FLG_CARICO_CESSIONARIO,
          a.COD_UO_PRATICA,
          a.COD_IBAN,
          a.VAL_FAX,
          a.VAL_RIFERIMENTO_NOMINATIVO,
          a.VAL_RAPPRESENTANTE,
          a.VAL_NOTE2,
          a.FLG_FM,
          a.VAL_IMPORTO_FM,
          a.COD_NDG,
          a.VAL_NOTE_FM,
          a.VAL_NUM_PROFORMA,
          a.DTA_PROFORMA_A_FATTURA,
          a.COD_CAUSALE_888,
          a.COD_MATRICOLA_AGG_STATO_Z,
          a.DTA_AUTORIZZAZIONE,
          a.COD_MATRICOLA,
          a.COD_UO,
          a.DTA_UPD_SPESA,
          a.DTA_INS_SPESA,
          a.VAL_PROF_COMUNE,
          a.VAL_PROF_FAX,
          a.VAL_PROF_INDIRIZZO,
          a.VAL_PROF_NCIVICO,
          a.VAL_PROF_PROVINCIA,
          a.VAL_PROF_CAP,
          a.DTA_STORNO_CONTABILE,
          a.COD_CONTROPARTITA,
          a.COD_DIVISA,
          a.COD_FILIALE,
          a.COD_TIPO,
          a.VAL_IMPORTO,
          a.COD_RIFERIMENTO,
          a.COD_OPERAZIONE_FATT,
          a.COD_PROGR_OPERAZIONE,
          a.DTA_SOLARE_OPERAZIONE,
          a.VAL_NUOVA_OPERAZIONE,
          a.COD_RAPPORTO,
          a.COD_FILIALE_COMPETENTE,
          a.FLG_TIPO_RAPPORTO,
          a.COD_UO_PRATICA_PR,
          a.COD_MATR_PRATICA,
          a.COD_SNDG,
          a.COD_STRUTTURA_COMPETENTE,
          a.DESC_STRUTTURA_COMPETENTE,
          a.COD_LIVELLO,
          a.DESC_NOME_CONTROPARTE,
          a.VAL_CAP_STRUTTURA,
          a.VAL_CITTA_STRUTTURA,
          a.VAL_EMAIL_STRUTTURA,
          a.VAL_FAX_STRUTTURA,
          a.VAL_INDIRIZZO_STRUTTURA,
          a.VAL_PROVINCIA_STRUTTURA,
          a.VAL_TELEFONO_STRUTTURA,
          a.DESC_ISTITUTO,
          a.VAL_PARTITA_IVA,
          a.VAL_STATO_PL,
          a.DTA_APERTURA,
          b.desc_struttura_competente desc_filiale_competente,
          -- AP - 13/09/2012
          (SELECT SUM (-val_imp_gbv)
             FROM t_mcres_app_rapporti
            WHERE cod_abi = a.cod_abi AND cod_ndg = a.cod_ndg)
             val_imp_gbv,
          (SELECT SUM (-val_imp_nbv)
             FROM t_mcres_app_rapporti
            WHERE cod_abi = a.cod_abi AND cod_ndg = a.cod_ndg)
             val_imp_nbv,
          a.VAL_TOT_ESBORSI,
          a.COD_OD_CALCOLATO,
          rpp.cod_rapporto_orig,
          a.REGIME_IVA,
          a.ALIQUOTA_IVA,
          a.ALIQUOTA_CPA,
          a.IMPORTO_CPA,
          a.IMPORTO_IVA,
          a.IMPORTO_RITENUTA,
          a.FLG_RITENUTA_APPLICABILE,
          a.FLG_FATTURA_DIGITALE,
          a.IMPORTO_VOCE,
          a.VAL_ALIQUOTA_RITENUTA,
          a.VAL_PERC_RITENUTA,
          a.val_wbs,
          a.dta_invio_pagamento,
          a.DESC_MOT_ANNUL_SPESA,
          a.VAL_INDIRIZZO,
          a.VAL_COMUNE,
          a.VAL_PROV,
          a.VAL_CAP,
          a.VAL_TELEFONO,
          a.val_fax_gestore,
          a.val_email,
          a.flg_preautorizzato,
          a.cod_registrazione_sap,
          a.dta_registrazione_sap,
          a.val_tipo_pagamento_sap,
          a.dta_pagamento_sap,
          a.val_id_pagamento_sap,
          a.val_esito_pagamento,
          a.dta_invio_sap
     FROM (SELECT sp.cod_abi,
                  sp.cod_autorizzazione,
                  sp.cod_tipo_autorizzazione,
                  sp.val_anno_pratica,
                  sp.cod_pratica,
                  sp.cod_stato,
                  sp.val_numero_fattura,
                  sp.dta_fattura,
                  sp.cod_importo_divisa,
                  sp.val_importo_valore,
                  sp.cod_causale,
                  sp.cod_causa_divisa,
                  sp.val_causa_importo,
                  sp.cod_intestatario_tipo,
                  sp.desc_intestatario,
                  sp.val_intestatario_codfisc,
                  sp.val_intestatario_piva,
                  sp.cod_afavore_tipo,
                  sp.desc_afavore,
                  sp.val_afavore_codfisc,
                  sp.val_afavore_piva,
                  sp.flg_convenzione,
                  sp.desc_spesa,
                  sp.flg_spesa_ripetibile,
                  sp.val_ente_pagatore,
                  sp.cod_tipo_pagamento,
                  sp.val_bon_destinatario,
                  sp.val_bon_coordinate,
                  sp.dta_bon_valuta,
                  sp.val_circ_intestatario,
                  sp.val_circ_trasferibile,
                  sp.flg_spesa_recuperata,
                  CASE
                     WHEN flg_source = 'MPL'
                     THEN
                        CASE
                           WHEN     sp.COD_ORGANO_AUTORIZZANTE = 'P'
                                AND stru.COD_LIVELLO IN ('IP', 'IC')
                           THEN
                              'PI'
                           ELSE
                              'RP'
                        END
                     ELSE
                        sp.cod_organo_autorizzante
                  END
                     cod_organo_autorizzante,
                  sp.val_note,
                  sp.val_spesa_non_fatturata,
                  sp.cod_punto_operativo,
                  sp.cod_protocollo,
                  sp.dta_generazione_protocollo,
                  sp.cod_intestatario_abi,
                  sp.cod_intestatario_cab,
                  sp.val_intestatario_conto,
                  sp.flg_ann_autoriz,
                  sp.cod_autorizzazione_padre,
                  sp.dta_upd,
                  sp.cod_pratica_ceduta,
                  sp.flg_carico_cessionario,
                  sp.cod_uo_pratica,
                  sp.cod_iban,
                  sp.val_fax,
                  sp.val_riferimento_nominativo,
                  sp.val_rappresentante,
                  sp.val_note2,
                  sp.flg_fm,
                  sp.val_importo_fm,
                  -- sp.cod_ndg,
                  pr.cod_ndg,
                  sp.val_note_fm,
                  sp.val_num_proforma,
                  sp.dta_proforma_a_fattura,
                  sp.cod_causale_888,
                  sp.cod_matricola_agg_stato_z,
                  sp.dta_autorizzazione,
                  sp.cod_matricola,
                  sp.cod_uo,
                  sp.dta_upd_spesa,
                  sp.dta_ins_spesa,
                  sp.val_prof_comune,
                  sp.val_prof_fax,
                  sp.val_prof_indirizzo,
                  sp.val_prof_ncivico,
                  sp.val_prof_provincia,
                  sp.val_prof_cap,
                  sp.dta_storno_contabile,
                  sp.DESC_MOT_ANNUL_SPESA,
                  cp.cod_contropartita,
                  cp.cod_divisa,
                  cp.cod_filiale,
                  cp.cod_tipo,
                  cp.val_importo,
                  cp.cod_riferimento,
                  cp.cod_operazione_fatt,
                  cp.cod_progr_operazione,
                  TO_CHAR (cp.dta_solare_operazione, 'yyyymmdd')
                     dta_solare_operazione,
                  cp.val_nuova_operazione,
                  ra.cod_rapporto,
                  ra.cod_filiale_competente,
                  ra.flg_tipo_rapporto,
                  pr.cod_uo_pratica cod_uo_pratica_pr,
                  pr.cod_matr_pratica,
                  pos.cod_sndg,
                  stru.cod_struttura_competente,
                  stru.desc_struttura_competente,
                  stru.cod_livello,
                  anag.desc_nome_controparte,
                  stru.val_cap_struttura,
                  stru.val_citta_struttura,
                  stru.val_email_struttura,
                  stru.val_fax_struttura,
                  stru.val_indirizzo_struttura,
                  stru.val_provincia_struttura,
                  stru.val_telefono_struttura,
                  --INTESTAZIONE PRATICA
                  i.desc_istituto,                          --ISTITUTO PRATICA
                  anag.val_partita_iva,                  --PARTITA IVA PRATICA
                  DECODE (pr.flg_attiva,  0, 'CHIUSA',  1, 'APERTA',  '-')
                     val_stato_pl,                          --STATO -- PRATICA
                  pr.dta_apertura,
                  -- AP - 13/09/2012
                  SUM (
                     CASE
                        WHEN sp.cod_Stato = 'CO' THEN sp.val_importo_valore
                        ELSE 0
                     END)
                  OVER (
                     PARTITION BY pr.val_anno,
                                  pr.cod_pratica,
                                  sp.cod_abi,
                                  sp.cod_ndg)
                     AS val_tot_esborsi,
                  sp.cod_od_calcolato,
                  -- AP 15/11/2012
                  --sp.REGIME_IVA,
                  CASE
                     WHEN sp.cod_tipo_autorizzazione = 5 THEN sp.regime_iva
                     ELSE fat.REGIME_IVA
                  END
                     regime_iva,
                  sp.ALIQUOTA_IVA,
                  sp.ALIQUOTA_CPA,
                  sp.IMPORTO_CPA,
                  sp.IMPORTO_IVA,
                  sp.IMPORTO_RITENUTA,
                  sp.FLG_RITENUTA_APPLICABILE,
                  sp.FLG_FATTURA_DIGITALE,
                  -- AP 15/11/2012
                  --sp.IMPORTO_VOCE,
                  CASE
                     WHEN sp.cod_tipo_autorizzazione = 5 THEN sp.IMPORTO_VOCE
                     ELSE fat.IMPORTO_VOCE
                  END
                     IMPORTO_VOCE,
                  sp.VAL_ALIQUOTA_RITENUTA,
                  sp.VAL_PERC_RITENUTA,
                  sp.val_wbs,
                  sp.dta_invio_pagamento,
                  g.VAL_INDIRIZZO,
                  g.VAL_COMUNE,
                  g.VAL_PROV,
                  g.VAL_CAP,
                  g.VAL_TELEFONO,
                  g.VAL_FAX val_fax_gestore,
                  g.val_email,
                  DECODE (itf.cod_stato, 'P', 1, 0) flg_preautorizzato,
                  sap.cod_registrazione_Fattura cod_registrazione_sap,
                  sap.dta_registrazione_Fattura dta_registrazione_sap,
                  CASE
                     WHEN     tpgs.val_tipo_pagamento IS NULL
                          AND sp.flg_source = 'ITF'
                          -- VG 20140219
                          AND sap.cod_autorizzazione IS NOT NULL
                     THEN
                        'PAGAMENTI MANUALI (UTILIZZATI ANCHE DAI BOLLETTINI POSTALI'
                     ELSE
                        tpgs.val_tipo_pagamento
                  END
                     AS val_tipo_pagamento_sap,
                  sap.dta_pagamento dta_pagamento_sap,
                  sap.val_id_pagamento val_id_pagamento_sap,
                  sap.val_esito_pagamento,
                  sp.dta_invio_pagamento dta_invio_sap
             FROM t_mcres_app_sp_spese sp,
                  t_mcres_app_sp_contropartita cp,
                  t_mcres_app_sp_rapporto ra,
                  t_mcres_app_pratiche pr,
                  t_mcre0_app_struttura_org stru,
                  t_mcre0_app_anagrafica_gruppo anag,
                  t_mcres_app_posizioni pos,
                  t_mcres_app_istituti i,
                  t_mcres_app_gestori g,
                  -- AP 15/11/2012
                  (SELECT REGIME_IVA, IMPORTO_VOCE, COD_AUTORIZZAZIONE
                     FROM (SELECT TO_CHAR (
                                     REPLACE (
                                        WM_CONCAT (
                                           COD_SAP_IVA)
                                        OVER (PARTITION BY COD_AUTORIZZAZIONE
                                              ORDER BY PROG_FATTURA),
                                        ',',
                                        ';'))
                                     REGIME_IVA,
                                  TO_CHAR (
                                     REPLACE (
                                        WM_CONCAT (
                                           VAL_IMPORTO_VOCE)
                                        OVER (PARTITION BY COD_AUTORIZZAZIONE
                                              ORDER BY PROG_FATTURA),
                                        ',',
                                        ';'))
                                     IMPORTO_VOCE,
                                  COD_AUTORIZZAZIONE,
                                  PROG_FATTURA,
                                  ROW_NUMBER ()
                                  OVER (PARTITION BY COD_AUTORIZZAZIONE
                                        ORDER BY PROG_FATTURA DESC)
                                     R
                             FROM T_MCRES_APP_SP_FATTURE)
                    WHERE R = 1) fat,
                  t_mcres_app_spese_itf itf,
                  (SELECT cod_autorizzazione,
                          cod_registrazione_Fattura,
                          dta_registrazione_Fattura,
                          cod_tipo_pagamento,
                          dta_pagamento,
                          val_id_pagamento,
                          val_esito_pagamento,
                          dta_invio_sap
                     FROM V_MCRES_APP_PAG_SAP) sap,
                  t_mcres_cl_tipo_pagamento_sap tpgs
            WHERE     sp.cod_pratica = pr.cod_pratica
                  AND sp.cod_abi = pr.cod_abi
                  AND sp.val_anno_pratica = pr.val_anno
                  AND sp.cod_autorizzazione = cp.cod_autorizzazione(+)
                  AND cp.cod_contropartita = ra.cod_contropartita(+)
                  AND sp.cod_uo = stru.cod_struttura_competente(+)
                  AND sp.cod_abi = stru.cod_abi_istituto(+)
                  AND pos.cod_abi = pr.cod_abi(+)
                  AND pos.cod_ndg = pr.cod_ndg(+)
                  AND pos.cod_sndg = anag.cod_sndg(+)
                  AND sp.cod_abi = i.cod_abi(+)
                  -- AP 15/11/2012
                  AND sp.cod_autorizzazione = fat.cod_autorizzazione(+)
                  AND PR.COD_MATR_PRATICA = g.cod_matricola(+)
                  AND sp.cod_autorizzazione = itf.cod_autorizzazione(+)
                  AND sp.cod_autorizzazione = sap.cod_autorizzazione(+)
                  AND sap.cod_tipo_pagamento = tpgs.cod_tipo_pagamento(+)
                  AND tpgs.flg_attivo(+) = 1) a,
          t_mcre0_app_struttura_org b,
          -- AP 13/09/2012
          t_mcres_app_rapporti rpp
    WHERE     a.cod_abi = b.cod_abi_istituto(+)
          AND a.cod_filiale_competente = b.cod_struttura_competente(+)
          -- AP 13/09/2012
          AND rpp.cod_abi(+) = a.cod_abi
          AND rpp.cod_ndg(+) = a.cod_ndg
          AND rpp.cod_rapporto(+) = a.cod_rapporto;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_DETTAGLIO_SPESE TO MCRE_USR;
