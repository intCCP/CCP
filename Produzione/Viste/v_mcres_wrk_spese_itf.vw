/* Formatted on 17/06/2014 18:13:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_SPESE_ITF
(
   ID_DOCUMENTO,
   ID_DPER,
   COD_ABI,
   COD_NDG,
   COD_AUTORIZZAZIONE,
   COD_AUTORIZZAZIONE_PADRE,
   COD_TIPO_AUTORIZZAZIONE,
   DESC_DOCUMENT_TYPE_MOPLE,
   VAL_ANNO_PRATICA,
   COD_PRATICA,
   COD_STATO,
   VAL_NUMERO_FATTURA,
   DTA_FATTURA,
   COD_IMPORTO_DIVISA,
   VAL_IMPORTO_VALORE,
   COD_CAUSALE,
   COD_CAUSA_DIVISA,
   DESC_CAUSALE_DOCUMENTO_MOPLE,
   VAL_CAUSA_IMPORTO,
   DESC_CFPIVA_LEGALE,
   DESC_AFAVORE,
   VAL_AFAVORE_PIVA,
   VAL_AFAVORE_CODFISC,
   COD_IBAN,
   FLG_SPESA_RIPETIBILE,
   DESC_NATURA_SPESA_MOPLE,
   FLG_SPESA_RECUPERATA,
   DESC_RECUPERO_SPESA_MOPLE,
   DESC_SPESA,
   VAL_NOTE,
   COD_ORGANO_AUTORIZZANTE,
   COD_CAUSALE_888,
   COD_STATO_LAVORAZIONE,
   DESC_STATO_LAVORAZIONE,
   VAL_ENTE_PAGATORE,
   VAL_FAX,
   VAL_RIFERIMENTO_NOMINATIVO,
   VAL_RAPPRESENTANTE,
   VAL_PROF_CAP,
   VAL_PROF_COMUNE,
   VAL_PROF_FAX,
   VAL_PROF_INDIRIZZO,
   VAL_PROF_NCIVICO,
   VAL_PROF_PROVINCIA,
   VAL_NUM_PROFORMA,
   COD_PUNTO_OPERATIVO,
   COD_TIPO_PAGAMENTO,
   DTA_BON_VALUTA,
   VAL_CIRC_INTESTATARIO,
   VAL_CIRC_TRASFERIBILE,
   DESC_AUTORIZZATORE,
   VAL_MATR_AUTORIZ,
   DTA_RIC_FATTURA,
   DTA_NOSTA,
   VAL_PAG_FATT,
   DESC_FILE_FATT,
   FLG_MOD_INVIO,
   FLG_DIGITALE,
   VAL_PAG_NOSTA,
   DESC_FILE_NOSTA,
   VAL_TOT_IMP,
   VAL_TOT_IVA,
   VAL_TOT_NETDALIQ,
   VAL_ALIQ_CONTRPREV,
   VAL_IMP_CONTRPREV,
   VAL_ALIQ_RITACC,
   VAL_IMP_RITACC,
   VAL_WBS
)
AS
             SELECT                      --  20121105    AG  Created this view
                   id_documento,
                    id_dper,
                    DECODE (cod_abi, '3069', '01025', cod_abi) cod_abi,
                    cod_ndg,
                    cod_autorizzazione,
                    cod_autorizzazione_padre,
                    cod_tipo_autorizzazione,
                    desc_document_type_mople,
                    val_anno_pratica,
                    cod_pratica,
                    cod_stato,
                    val_numero_fattura,
                    dta_fattura,
                    cod_importo_divisa,
                    val_importo_valore,
                    cod_causale,
                    cod_causa_divisa,
                    desc_causale_documento_mople,
                    val_causa_importo,
                    desc_cfpiva_legale,
                    desc_afavore,
                    val_afavore_piva,
                    val_afavore_codfisc,
                    cod_iban,
                    flg_spesa_ripetibile,
                    desc_natura_spesa_mople,
                    flg_spesa_recuperata,
                    desc_recupero_spesa_mople,
                    desc_spesa,
                    val_note,
                    cod_organo_autorizzante,
                    cod_causale_888,
                    cod_stato_lavorazione,
                    desc_stato_lavorazione,
                    val_ente_pagatore,
                    val_fax,
                    val_riferimento_nominativo,
                    val_rappresentante,
                    val_prof_cap,
                    val_prof_comune,
                    val_prof_fax,
                    val_prof_indirizzo,
                    val_prof_ncivico,
                    val_prof_provincia,
                    val_num_proforma,
                    cod_punto_operativo,
                    cod_tipo_pagamento,
                    dta_bon_valuta,
                    val_circ_intestatario,
                    val_circ_trasferibile,
                    desc_autorizzatore,
                    val_matr_autoriz,
                    dta_ric_fattura,
                    dta_nosta,
                    val_pag_fatt,
                    desc_file_fatt,
                    flg_mod_invio,
                    flg_digitale,
                    val_pag_nosta,
                    desc_file_nosta,
                    val_tot_imp,
                    val_tot_iva,
                    val_tot_netdaliq,
                    val_aliq_contrprev,
                    val_imp_contrprev,
                    val_aliq_ritacc,
                    val_imp_ritacc,
                    val_wbs
               FROM t_mcres_wrk_xml_itf,
                    XMLTABLE (
                       '/SPESE/SPESA'
                       PASSING t_mcres_wrk_xml_itf.xml_content
                       COLUMNS id_documento VARCHAR2 (255) PATH 'IdDocumento',
                               id_dper VARCHAR2 (512) PATH 'id_dper',
                               cod_abi VARCHAR2 (512) PATH 'Cod_Abi',
                               cod_ndg VARCHAR2 (512) PATH 'NDG',
                               cod_autorizzazione VARCHAR2 (512)
                                     PATH 'Cod_Autorizzazione',
                               cod_autorizzazione_padre VARCHAR2 (512)
                                     PATH 'Cod_Autorizzazione_Padre',
                               cod_tipo_autorizzazione VARCHAR2 (512)
                                     PATH 'Cod_TipoAutorizzazione',
                               desc_document_type_mople VARCHAR2 (512)
                                     PATH 'DocumentTypeMopleDescr',
                               val_anno_pratica VARCHAR2 (512) PATH 'Val_Anno_Pratica',
                               cod_pratica VARCHAR2 (512) PATH 'Cod_Pratica',
                               cod_stato VARCHAR2 (512) PATH 'Cod_Stato',
                               val_numero_fattura VARCHAR2 (512)
                                     PATH 'Val_NumeroFattura',
                               dta_fattura VARCHAR2 (512) PATH 'DtaFattura',
                               cod_importo_divisa VARCHAR2 (512)
                                     PATH 'Cod_Importo_Divisa',
                               val_importo_valore VARCHAR2 (512)
                                     PATH 'Val_Importo_Valore',
                               cod_causale VARCHAR2 (512) PATH 'Cod_Causale',
                               cod_causa_divisa VARCHAR2 (512) PATH 'Cod_Causa_Divisa',
                               desc_causale_documento_mople VARCHAR2 (512)
                                     PATH 'DescrCausaleDocumentoMOPLE',
                               val_causa_importo VARCHAR2 (512)
                                     PATH 'Val_Causa_Importo',
                               desc_cfpiva_legale VARCHAR2 (512)
                                     PATH 'Desc_CFPIVA_Legale',
                               desc_afavore VARCHAR2 (512) PATH 'Desc_Afavore',
                               val_afavore_piva VARCHAR2 (512) PATH 'Val_Afavore_PIVA',
                               val_afavore_codfisc VARCHAR2 (512)
                                     PATH 'Val_Afavore_CodFisc',
                               cod_iban VARCHAR2 (512) PATH 'Cod_IBAN',
                               flg_spesa_ripetibile VARCHAR2 (512)
                                     PATH 'FLG_Spesa_Ripetibile',
                               desc_natura_spesa_mople VARCHAR2 (512)
                                     PATH 'DescrNaturaSpesaMople',
                               flg_spesa_recuperata VARCHAR2 (512)
                                     PATH 'FLG_Spesa_Recuperata',
                               desc_recupero_spesa_mople VARCHAR2 (512)
                                     PATH 'DescrRecuperSpesaMople',
                               desc_spesa VARCHAR2 (512) PATH 'Desc_Spesa',
                               val_note VARCHAR2 (512) PATH 'Val_Note',
                               cod_organo_autorizzante VARCHAR2 (512)
                                     PATH 'Cod_Organo_Autorizzante',
                               cod_causale_888 VARCHAR2 (512) PATH 'Cod_Causale_888',
                               cod_stato_lavorazione VARCHAR2 (512)
                                     PATH 'IdStatoLavorazione',
                               desc_stato_lavorazione VARCHAR2 (512)
                                     PATH 'StatoLavorazione',
                               val_ente_pagatore VARCHAR2 (512)
                                     PATH 'Val_Ente_Pagatore',
                               val_fax VARCHAR2 (512) PATH 'Val_Fax',
                               val_riferimento_nominativo VARCHAR2 (512)
                                     PATH 'Val_Riferimento_Nominativo',
                               val_rappresentante VARCHAR2 (512)
                                     PATH 'Val_Rappresentante',
                               val_prof_cap VARCHAR2 (512) PATH 'Val_Prof_Cap',
                               val_prof_comune VARCHAR2 (512) PATH 'Val_Prof_Comune',
                               val_prof_fax VARCHAR2 (512) PATH 'Val_Prof_Fax',
                               val_prof_indirizzo VARCHAR2 (512)
                                     PATH 'Val_Prof_Indirizzo',
                               val_prof_ncivico VARCHAR2 (512) PATH 'Val_Prof_Ncivico',
                               val_prof_provincia VARCHAR2 (512)
                                     PATH 'Val_Prof_Provincia',
                               val_num_proforma VARCHAR2 (512) PATH 'Val_Num_Proforma',
                               cod_punto_operativo VARCHAR2 (512)
                                     PATH 'Cod_Punto_Operativo',
                               cod_tipo_pagamento VARCHAR2 (512)
                                     PATH 'Cod_Tipo_Pagamento',
                               dta_bon_valuta VARCHAR2 (512) PATH 'Dta_Bon_valuta',
                               val_circ_intestatario VARCHAR2 (512)
                                     PATH 'Val_Circ_Intestatario',
                               val_circ_trasferibile VARCHAR2 (512)
                                     PATH 'Val_Circ_Trasferibile',
                               desc_autorizzatore VARCHAR2 (512)
                                     PATH 'Desc_Autorizzatore',
                               val_matr_autoriz VARCHAR2 (512) PATH 'Val_Matr_Autoriz',
                               dta_ric_fattura VARCHAR2 (512) PATH 'DT_Ric_Fattura',
                               dta_nosta VARCHAR2 (512) PATH 'DT_Nosta',
                               val_pag_fatt VARCHAR2 (512) PATH 'Val_Pag_Fatt',
                               desc_file_fatt VARCHAR2 (512) PATH 'Desc_File_Fatt',
                               flg_mod_invio VARCHAR2 (512) PATH 'Flg_Mod_Invio',
                               flg_digitale VARCHAR2 (512) PATH 'ITFFLG_Digitale',
                               val_pag_nosta VARCHAR2 (512) PATH 'Val_Pag_Nosta',
                               desc_file_nosta VARCHAR2 (512) PATH 'Desc_File_Nosta',
                               val_tot_imp VARCHAR2 (512) PATH 'Val_Tot_Imp',
                               val_tot_iva VARCHAR2 (512) PATH 'Val_Tot_Iva',
                               val_tot_netdaliq VARCHAR2 (512) PATH 'Val_Tot_NetDaLiq',
                               val_aliq_contrprev VARCHAR2 (512)
                                     PATH 'Val_Aliq_Contrprev',
                               val_imp_contrprev VARCHAR2 (512)
                                     PATH 'Val_Imp_Contrprev',
                               val_aliq_ritacc VARCHAR2 (512) PATH 'Val_Aliq_Ritacc',
                               val_imp_ritacc VARCHAR2 (512) PATH 'Val_Imp_Ritacc',
                               val_wbs VARCHAR2 (512) PATH 'Val_Wbs');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_WRK_SPESE_ITF TO MCRE_USR;
