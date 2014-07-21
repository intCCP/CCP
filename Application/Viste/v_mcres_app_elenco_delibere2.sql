/* Formatted on 21/07/2014 18:42:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ELENCO_DELIBERE2
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
   ID_OBJECT_AL_TR,
   ID_OBJECT_AL_CO
)
AS
   SELECT                                                     -- AP 09/11/2012
                                                              -- VG 13/11/2012
                       -- AG 26/11/2012 rimossa forzature per delibere RE e ES
        A."COD_ABI",
        A."DESC_ISTITUTO",
        A."COD_NDG",
        A."COD_SNDG",
        A."DESC_NOME_CONTROPARTE",
        A."COD_GRUPPO_ECONOMICO",
        A."DESC_NOME_GRUPPO_ECONOMICO",
        A."COD_PRATICA",
        A."COD_UO_PRATICA",
        A."DESC_PRESIDIO",
        A."VAL_ANNO_PRATICA",
        A."DTA_PASSAGGIO_SOFF",
        A."COD_PROTOCOLLO_DELIBERA",
        A."COD_STATO_DELIBERA",
        A."COD_ORGANO_DELIBERANTE",
        A."DTA_INSERIMENTO_DELIBERA",
        A."DTA_AGGIORNAMENTO_DELIBERA",
        A."COD_DELIBERA",
        A."DESC_DELIBERA",
        A."DESC_STATO_DELIBERA",
        A."DESC_ORGANO_DELIBERANTE",
        A."DTA_DELIBERA",
        A."COD_MATR_INSERENTE",
        A."COD_PROPOSTA",
        A."VAL_ESPOSIZIONE_LORDA_CAP",
        A."VAL_ESPOSIZIONE_NETTA_POST_DEL",
        A."VAL_IMPORTO_OFFERTO",
        A."VAL_RETTIFICA_VALORE_PROP",
        A."VAL_ACCANT_ANTE_DEL",
        A."VAL_ESPOSIZIONE_NETTA_ANTE_DEL",
        A."SCGB_DTA_RIF_CR",
        A."VAL_MESE_CR",
        A."VAL_ANNO_CR",
        A."SCGB_UTI_SIS",
        A."SCSB_UTI_CR",
        A."VAL_PERC_SISTEMA",
        A."DTA_DEC_STATO_INCAGLI",
        A."DESC_MOTIVAZIONE_FORZATURA",
        A."VAL_INDICATORE_ACCANTONAMENTO",
        A."VAL_UTENTE_AZIONE",
        A."DTA_NOTIFICA_ATTO",
        A."VAL_AUTORITA_GIUDIZIARIA",
        A."VAL_OGGETTO_DOMANDA",
        A."VAL_IMP_DOMANDA",
        A."VAL_ACCANT_RISCHI_ONERI",
        A."VAL_NEW_ACCANT_RISCHI_ONERI",
        A."DTA_PREVEDIBILE_ESBORSO",
        A."FLG_CONTENZIOSO_PASSIVO",
        A."VAL_ESBORSO",
        A."VAL_EFF_CONTO_ECONOMICO",
        A."DTA_ESBORSO",
        A."FLG_STRALCIO",
        A."VAL_ESPOSIZIONE_LORDA",
        A."VAL_ESPOSIZIONE_NETTA",
        A."VAL_IMP_STRALCIO",
        A."DTA_SICLI",
        A."VAL_UTI",
        A."VAL_UTI_CAPITALE",
        A."VAL_UTI_MORA",
        A."VAL_VANTATO",
        A."VAL_VANTATO_RATEO",
        A."VAL_VANTATO_STRALCI",
        A."VAL_ESP_LORDA_CAPITALE",
        A."VAL_ESP_LORDA_MORA",
        A."VAL_RETT_DA_INCAGLIO",
        A."VAL_RETT_DA_INC_STRALCI",
        A."VAL_RETT_VAL_ANTE_DEL",
        A."VAL_RETT_VAL_ANTE_DEL_FUORI",
        A."VAL_RETT_VAL_ANTE_DEL_RDV",
        A."VAL_RETT_VAL_ANTE_DEL_INTER",
        A."VAL_RETT_VAL_ANTE_DEL_SPESE",
        A."VAL_RETT_VAL_IN_DEL",
        A."VAL_ESPOSIZIONE_LORDA_STRALCIO",
        A."VAL_ESPOSIZIONE_NETTA_STRALCIO",
        A."DESC_FLG_CONT_PASSIVO",
        A."VAL_NOTE",
        A."VAL_NOTE_ANNULLAMENTO",
        A."FLG_STAMPA",
        A."COD_STATO_SOFF",
        A."VAL_CATEGORIA",
        A."DESC_RESPONSABILE",
        A."DTA_INOLTRO",
        A."DTA_TRASFERIMENTO",
        A."COD_OPERATORE_INS_UPD",
        A."VAL_IMP_RILEVANTE",
        A."VAL_IMP_RILEVANTE_DC_ISP",
        A."VAL_RDV_QC_DA_INCAGLIO",
        A."DTA_CONFERMA",
        A."VAL_MOTIVAZIONE_DEL_RW",
        A."COD_CAUSALE_CHIUSURA",
        A."COD_FILIALE_CLASS",
        A."DESC_FILIALE_CLASS",
        A."DESC_ADDETTO",
        A."COD_MATR_PRATICA",
        A."COD_SEGMENTO",
        A."DTA_PASS_STATO_RISC",
        A."COD_STATO_RISCHIO",
        A."DTA_INCAGLIO",
        A."COD_STATO_PC",
        A."DTA_STATO_GIUR",
        A."VAL_CODICE_CR",
        A."COD_RAMO",
        A."COD_SETTORE",
        A."DESC_RAMO",
        A."DESC_SETTORE",
        A."COD_PARTITA_IVA",
        A."VAL_ESPOS_LORDA_TOT",
        A."VAL_IMPORTO_SACRIFICIO",
        A."VAL_NOTE_FLUSSO",
        A."COD_TIPO_TRANSAZIONE",
        A."VAL_VANTATO_NOCONT",
        A."COD_FISCALE",
        A."COD_TIPO_STRALCIO",
        A."FLG_IND_GARANTI",
        A."VAL_NOTE_DESC_ANN",
        A."DTA_AGG_SISBA",
        A."VAL_VANTATO_SISBA",
        A."VAL_MORA_SISBA",
        A."VAL_STRALCI_FISC_SOFF",
        A."VAL_UTILIZZO_SISBA",
        A."VAL_ACCTI_SISBA",
        A."VAL_ATTUALIZ_SISBA",
        A."VAL_STRAL_QT_CAP_SISBA",
        A."VAL_STRAL_QT_MORA_SISBA",
        A."VAL_CAPITALE_SISBA",
        A."VAL_UTILIZZO_SICLI",
        A."VAL_CAPITALE_SICLI",
        A."VAL_MORA_SICLI",
        A."DTA_AGG_SICLI",
        A."VAL_ESPOS_LORDA_QT_MORA",
        A."VAL_PERC_RETT_VAL",
        A."DTA_SCADENZA",
        A."DTA_DEL_ESTERA",
        A."DTA_SCAD_DEL_ESTERA",
        A."VAL_PERC_DUBBIO_ESITO_EST",
        A."VAL_RETT_QT_CAP_ANTE98",
        A."VAL_RETT_QT_CAP_PROGR",
        A."VAL_INTERES_CORR",
        A."VAL_SPESE_LEGALI",
        A."VAL_ESPOS_LORDA_CAP_MORA",
        A."VAL_ACCTI_DELIB",
        A."DTA_STAMPA",
        A."DTA_SCADENZA_TRANSAZIONE",
        A."DTA_INIZIO_RELAZIONE",
        A."COD_PROTOCOLLO_DELIBERA_COLL",
        A."DESC_STRUTTURA_COMPETENTE",
        A."DESC_STATO_GIURIDICO",
        c.id_object AS id_object_al_tr,
        d.id_object AS id_object_al_co
   FROM (SELECT T.COD_ABI,
                i.DESC_ISTITUTO,
                T.COD_NDG,
                t.COD_SNDG,
                a.DESC_NOME_CONTROPARTE,
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
                T.VAL_NOTE_ANNULLAMENTO,
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
                COD_MATR_PRATICA,
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
                o.DESC_STRUTTURA_COMPETENTE,
                g.desc_STATO_GIURIDICO
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
                        NVL (I.DTA_DECORRENZA_STATO, H.DTA_DECORRENZA_STATO)
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
                        D.VAL_ESPOSIZIONE_LORDA_STRALCIO,
                        D.VAL_ESPOSIZIONE_NETTA_STRALCIO,
                        D.VAL_NOTE,
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
                                      AND UPPER (i.desc_causa_prev_recupero) =
                                             'SENZA EFFETTO ECONOMICO')
                           ELSE
                              NULL
                        END
                           val_motivazione_del_rw,
                        d.cod_CAUSALE_CHIUSURA,
                        COD_FILIALE_CLASS,
                        DESC_FILIALE_CLASS,
                        DESC_ADDETTO,
                        d.COD_MATR_PRATICA,
                        cod_SEGMENTO,
                        DTA_PASS_STATO_RISC,
                        d.cod_STATO_RISCHIO,
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
                        cod_uo
                   FROM T_MCRES_APP_DELIBERE D,
                        T_MCRES_APP_PRATICHE P,
                        T_MCRES_APP_POSIZIONI Z,
                        T_MCRE0_APP_CR C,
                        T_MCREI_APP_PRATICHE I,
                        t_mcrei_hst_pratiche h                             --,
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
                  WHERE     0 = 0
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
                T_MCRES_CL_ORGANO_DELIBERANTE OD,
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
                AND t.cod_uo = od.cod_uo(+)
                AND T.COD_ORGANO_DELIBERANTE = OD.COD_ORGANO_DELIBERANTE(+)
                AND TO_DATE ('99991231', 'YYYYMMDD') = OD.DTA_SCADENZA(+)
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
               AND d.cod_stato = 'CO');
