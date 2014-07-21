/* Formatted on 21/07/2014 18:30:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.TMP_ANDREA
(
   VAL_IMPORTO_VALORE,
   CONVERTED
)
AS
              SELECT val_importo_valore,
                     TO_NUMBER (val_importo_valore,
                                '9999999999999D99',
                                'NLS_NUMERIC_CHARACTERS = '', .')
                        converted
                FROM XMLTABLE (
                        '/SPESE/SPESA'
                        PASSING xmltype (
                                   BFILENAME ('D_MCRES_WORK',
                                              'MOPLE_20120917_03069.FLUSSOSPESE.xml'),
                                   NLS_CHARSET_ID ('AL16UTF16LE'))
                        COLUMNS id_documento VARCHAR (255) PATH 'IdDocumento',
                                id_dper VARCHAR (255) PATH 'id_dper',
                                cod_abi VARCHAR (255) PATH 'Cod_Abi',
                                cod_ndg VARCHAR (255) PATH 'NDG',
                                cod_autorizzazione VARCHAR (255)
                                      PATH 'Cod_Autorizzazione',
                                cod_autorizzazione_padre VARCHAR (255)
                                      PATH 'Cod_Autorizzazione_Padre',
                                cod_tipo_autorizzazione VARCHAR (255)
                                      PATH 'Cod_TipoAutorizzazione',
                                documenttypemopledescr VARCHAR (255)
                                      PATH 'DocumentTypeMopleDescr',
                                val_anno_pratica VARCHAR (255) PATH 'Val_Anno_Pratica',
                                cod_stato VARCHAR (255) PATH 'Cod_Stato',
                                val_numerofattura VARCHAR (255) PATH 'Val_NumeroFattura',
                                dtafattura VARCHAR (255) PATH 'DtaFattura',
                                cod_importo_divisa VARCHAR (255)
                                      PATH 'Cod_Importo_Divisa',
                                val_importo_valore VARCHAR (255)
                                      PATH 'Val_Importo_Valore',
                                cod_causale VARCHAR (255) PATH 'Cod_Causale',
                                cod_causa_divisa VARCHAR (255) PATH 'Cod_Causa_Divisa',
                                descrcausaledocumentomople VARCHAR (255)
                                      PATH 'DescrCausaleDocumentoMOPLE',
                                val_causa_importo VARCHAR (255) PATH 'Val_Causa_Importo',
                                desc_cfpiva_legale VARCHAR (255)
                                      PATH 'Desc_CFPIVA_Legale',
                                desc_afavore VARCHAR (255) PATH 'Desc_Afavore',
                                val_afavore_piva VARCHAR (255) PATH 'Val_Afavore_PIVA',
                                val_afavore_codfisc VARCHAR (255)
                                      PATH 'Val_Afavore_CodFisc',
                                cod_iban VARCHAR (255) PATH 'Cod_IBAN',
                                flg_spesa_ripetibile VARCHAR (255)
                                      PATH 'FLG_Spesa_Ripetibile',
                                descrnaturaspesamople VARCHAR (255)
                                      PATH 'DescrNaturaSpesaMople',
                                flg_spesa_recuperata VARCHAR (255)
                                      PATH 'FLG_Spesa_Recuperata',
                                descrrecuperspesamople VARCHAR (255)
                                      PATH 'DescrRecuperSpesaMople',
                                desc_spesa VARCHAR (255) PATH 'Desc_Spesa',
                                val_note VARCHAR (255) PATH 'Val_Note',
                                cod_organo_autorizzante VARCHAR (255)
                                      PATH 'Cod_Organo_Autorizzante',
                                cod_causale_888 VARCHAR (255) PATH 'Cod_Causale_888',
                                idstatolavorazione VARCHAR (255)
                                      PATH 'IdStatoLavorazione',
                                statolavorazione VARCHAR (255) PATH 'StatoLavorazione',
                                val_ente_pagatore VARCHAR (255) PATH 'Val_Ente_Pagatore',
                                val_fax VARCHAR (255) PATH 'Val_Fax',
                                val_riferimento_nominativo VARCHAR (255)
                                      PATH 'Val_Riferimento_Nominativo',
                                val_rappresentante VARCHAR (255)
                                      PATH 'Val_Rappresentante',
                                val_prof_cap VARCHAR (255) PATH 'Val_Prof_Cap',
                                val_prof_comune VARCHAR (255) PATH 'Val_Prof_Comune',
                                val_prof_fax VARCHAR (255) PATH 'Val_Prof_Fax',
                                val_prof_indirizzo VARCHAR (255)
                                      PATH 'Val_Prof_Indirizzo',
                                val_prof_ncivico VARCHAR (255) PATH 'Val_Prof_Ncivico',
                                val_prof_provincia VARCHAR (255)
                                      PATH 'Val_Prof_Provincia',
                                val_num_proforma VARCHAR (255) PATH 'Val_Num_Proforma',
                                cod_punto_operativo VARCHAR (255)
                                      PATH 'Cod_Punto_Operativo',
                                cod_tipo_pagamento VARCHAR (255)
                                      PATH 'Cod_Tipo_Pagamento',
                                dta_bon_valuta VARCHAR (255) PATH 'Dta_Bon_valuta',
                                val_circ_intestatario VARCHAR (255)
                                      PATH 'Val_Circ_Intestatario',
                                val_circ_trasferibile VARCHAR (255)
                                      PATH 'Val_Circ_Trasferibile',
                                desc_autorizzatore VARCHAR (255)
                                      PATH 'Desc_Autorizzatore',
                                val_matr_autoriz VARCHAR (255) PATH 'Val_Matr_Autoriz',
                                dt_ric_fattura VARCHAR (255) PATH 'DT_Ric_Fattura',
                                dt_nosta VARCHAR (255) PATH 'DT_Nosta',
                                val_pag_fatt VARCHAR (255) PATH 'Val_Pag_Fatt',
                                desc_file_fatt VARCHAR (255) PATH 'Desc_File_Fatt',
                                flg_mod_invio VARCHAR (255) PATH 'Flg_Mod_Invio',
                                itfflg_digitale VARCHAR (255) PATH 'ITFFLG_Digitale',
                                val_pag_nosta VARCHAR (255) PATH 'Val_Pag_Nosta',
                                desc_file_nosta VARCHAR (255) PATH 'Desc_File_Nosta',
                                val_tot_imp VARCHAR (255) PATH 'Val_Tot_Imp',
                                val_tot_iva VARCHAR (255) PATH 'Val_Tot_Iva',
                                val_tot_netdaliq VARCHAR (255) PATH 'Val_Tot_NetDaLiq',
                                val_aliq_contrprev VARCHAR (255)
                                      PATH 'Val_Aliq_Contrprev',
                                val_imp_contrprev VARCHAR (255) PATH 'Val_Imp_Contrprev',
                                val_aliq_ritacc VARCHAR (255) PATH 'Val_Aliq_Ritacc',
                                val_imp_ritacc VARCHAR (255) PATH 'Val_Imp_Ritacc',
                                val_wbs VARCHAR (255) PATH 'Val_Wbs');
