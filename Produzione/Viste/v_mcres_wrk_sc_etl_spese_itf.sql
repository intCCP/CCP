/* Formatted on 17/06/2014 18:13:35 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_SC_ETL_SPESE_ITF
(
   COD_AUTORIZZAZIONE,
   COD_CAUSA_SCARTO,
   DESC_CAUSA_SCARTO
)
AS
   SELECT                                --  20121102    AG  Created this view
                         --  20121105    AG  Aggiunta descrizione causa scarto
                        --  20121122    AG  Aggiunto flg_tipo_rapp_flg_invalid
                                     --  20121126    AG  Fix descrizione esito
                                    --  20120515    AP  Aggiunti Codici Scarto
        cod_autorizzazione,
        CASE
           WHEN flg_no_id_dper_spesa = 1 THEN '2001'
           WHEN flg_no_cod_aut_spesa = 1 THEN '2002'
           WHEN flg_rec_doppio_spese = 1 THEN '2003'
           WHEN flg_pratica_disattiva = 1 THEN '2074'
           WHEN flg_assenza_pratica = 1 THEN '2004'
           WHEN flg_no_pdf_fatt = 1 THEN '2005'
           WHEN flg_no_pdf_nosta = 1 THEN '2006'
           WHEN flg_spesa_presente_su_sp = 1 THEN '2007'
           WHEN flg_spesa_presente_su_app = 1 THEN '2008'
           WHEN flg_cod_aut_padre_null = 1 THEN '2009'
           WHEN flg_spesa_orfana = 1 THEN '2010'
           WHEN flg_cod_tipo_aut_non_ammesso = 1 THEN '2011'
           WHEN flg_cod_stato_non_ammesso = 1 THEN '2012'
           WHEN flg_cod_causale_non_ammesso = 1 THEN '2013'
           WHEN flg_spesa_ripetib_flg_invalid = 1 THEN '2014'
           WHEN flg_cod_organ_aut_non_ammesso = 1 THEN '2015'
           WHEN flg_digitale_flg_invalid = 1 THEN '2016'
           WHEN flg_mod_invio_flg_invalid = 1 THEN '2017'
           WHEN flg_causale_non_ammessa = 1 THEN '2018'
           WHEN flg_spesa_ripet_incoerente = 1 THEN '2019'
           WHEN flg_no_iban = 1 THEN '2020'
           WHEN flg_no_rappresentante = 1 THEN '2021'
           WHEN flg_no_prof_cap = 1 THEN '2022'
           WHEN flg_no_prof_comune = 1 THEN '2023'
           WHEN flg_no_prof_fax = 1 THEN '2024'
           WHEN flg_no_prof_indirizzo = 1 THEN '2025'
           WHEN flg_no_prof_ncivico = 1 THEN '2026'
           WHEN flg_no_prof_provincia = 1 THEN '2027'
           WHEN flg_no_autorizzatore = 1 THEN '2028'
           WHEN flg_no_matr_autoriz = 1 THEN '2029'
           WHEN flg_no_causale_888 = 1 THEN '2030'
           WHEN flg_tipo_pagamento_non_valido = 1 THEN '2031'
           WHEN flg_no_cod_controp = 1 THEN '2032'
           WHEN flg_no_id_dper_controp = 1 THEN '2033'
           WHEN flg_controp_caricata = 1 THEN '2034'
           WHEN flg_rec_doppio_controp = 1 THEN '2035'
           WHEN flg_controp_no_spesa = 1 THEN '2036'
           WHEN flg_tipo_controp_non_valido = 1 THEN '2037'
           WHEN flg_no_id_dper_rapp = 1 THEN '2038'
           WHEN flg_no_cod_controp_rapp = 1 THEN '2039'
           WHEN flg_no_cod_rapp = 1 THEN '2040'
           WHEN flg_rapp_caricato_app = 1 THEN '2041'
           WHEN flg_rec_doppio_rapp = 1 THEN '2042'
           WHEN flg_rapp_no_spesa = 1 THEN '2043'
           WHEN flg_no_rapporto = 1 THEN '2044'
           WHEN flg_out_rapporto = 1 THEN '2045'
           WHEN flg_manca_rapporto = 1 THEN '2046'
           WHEN flg_rapp_no_controp = 1 THEN '2047'
           WHEN flg_tipo_rapp_flg_invalid = 1 THEN '2048'
           WHEN flg_rapp_tipol_errata = 1 THEN '2049'
           WHEN flg_no_id_dper_azione = 1 THEN '2050'
           WHEN flg_no_cod_aut_azione = 1 THEN '2051'
           WHEN flg_no_cod_azione = 1 THEN '2052'
           WHEN flg_azione_caricata_app = 1 THEN '2053'
           WHEN flg_rec_doppio_azioni = 1 THEN '2054'
           WHEN flg_azione_no_spesa = 1 THEN '2055'
           WHEN flg_cod_azione_non_valido = 1 THEN '2056'
           WHEN flg_no_id_dper_fattura = 1 THEN '2057'
           WHEN flg_no_cod_aut_fattura = 1 THEN '2058'
           WHEN flg_fattura_caricata_app = 1 THEN '2059'
           WHEN flg_rec_doppio_fatture = 1 THEN '2060'
           WHEN flg_cod_sap_iva_non_censito = 1 THEN '2061'
           WHEN flg_societa_sap_non_censita = 1 THEN '2062'
           WHEN flg_squadra_imp_pos_fattura = 1 THEN '2063'
           WHEN flg_squadra_tot_imponibile_iva = 1 THEN '2064'
           WHEN flg_squadra_importo_spesa = 1 THEN '2065'
           WHEN flg_squadra_netdaliq = 1 THEN '2066'
           WHEN flg_fattura_duplicata = 1 THEN '2067'
           WHEN flg_manca_fattura = 1 THEN '2068'
           WHEN flg_scarto_formale_spesa = 1 THEN '2069'
           WHEN flg_scarto_formale_controp = 1 THEN '2070'
           WHEN flg_scarto_formale_rap = 1 THEN '2071'
           WHEN flg_scarto_formale_azioni = 1 THEN '2072'
           WHEN flg_scarto_formale_fatture = 1 THEN '2073'
           WHEN flg_proforma_non_def = 1 THEN '2075'
        END
           cod_causa_scarto,
        CASE
           WHEN flg_no_id_dper_spesa = 1
           THEN
              'ID_DPER null su SPESE'
           WHEN flg_no_cod_aut_spesa = 1
           THEN
              'Spesa avente codice autorizzazione null'
           WHEN flg_rec_doppio_spese = 1
           THEN
              'Spesa presente piu volte nel flusso '
           WHEN flg_pratica_disattiva = 1
           THEN
              'Pratica legale chiusa'
           WHEN flg_assenza_pratica = 1
           THEN
              'Assenza pratica legale'
           WHEN flg_no_pdf_fatt = 1
           THEN
              'Assenza PDF fattura'
           WHEN flg_no_pdf_nosta = 1
           THEN
              'Assenza PDF nulla osta'
           WHEN flg_spesa_presente_su_sp = 1
           THEN
              'Spesa gia caricata su SP'
           WHEN flg_spesa_presente_su_app = 1
           THEN
              'Spesa gia caricata su APP'
           WHEN flg_cod_aut_padre_null = 1
           THEN
              'Codice autorizzazione padre null'
           WHEN flg_spesa_orfana = 1
           THEN
              'Assenza spesa padre'
           WHEN flg_cod_tipo_aut_non_ammesso = 1
           THEN
              'Codice tipo autorizzazione non valido'
           WHEN flg_cod_stato_non_ammesso = 1
           THEN
              'Codice stato non valido'
           WHEN flg_cod_causale_non_ammesso = 1
           THEN
              'Codice causale non valido'
           WHEN flg_spesa_ripetib_flg_invalid = 1
           THEN
              'Flag spesa ripetibile non valido'
           WHEN flg_cod_organ_aut_non_ammesso = 1
           THEN
              'Codice organo auotorizzante non valido'
           WHEN flg_digitale_flg_invalid = 1
           THEN
              'Flag digitale non valido'
           WHEN flg_mod_invio_flg_invalid = 1
           THEN
              'Flag mod invio non valido'
           WHEN flg_causale_non_ammessa = 1
           THEN
              'Causale non valida'
           WHEN flg_spesa_ripet_incoerente = 1
           THEN
              'Spesa ripetibile incoerente'
           WHEN flg_no_iban = 1
           THEN
              'Assenza IBAN'
           WHEN flg_no_rappresentante = 1
           THEN
              'Assenza rappresentante'
           WHEN flg_no_prof_cap = 1
           THEN
              'Assenza prof CAP'
           WHEN flg_no_prof_comune = 1
           THEN
              'Assenza prof comune'
           WHEN flg_no_prof_fax = 1
           THEN
              'Assenza prof fax'
           WHEN flg_no_prof_indirizzo = 1
           THEN
              'Assenza prof indirizzo'
           WHEN flg_no_prof_ncivico = 1
           THEN
              'Assenza prof civico'
           WHEN flg_no_prof_provincia = 1
           THEN
              'Assenza prof provincia'
           WHEN flg_no_autorizzatore = 1
           THEN
              'Assenza autorizzatore'
           WHEN flg_no_matr_autoriz = 1
           THEN
              'Assenza matricola autorizzante '
           WHEN flg_no_causale_888 = 1
           THEN
              'Assenza casusale 888'
           WHEN flg_tipo_pagamento_non_valido = 1
           THEN
              'Codice tipo pagamento non valido'
           WHEN flg_no_cod_controp = 1
           THEN
              'Codice contropartita nullo su CONTROPARTITE'
           WHEN flg_no_id_dper_controp = 1
           THEN
              'ID_DPER null su CONTROPARTITE'
           WHEN flg_controp_caricata = 1
           THEN
              'Contropartita gia caricata'
           WHEN flg_rec_doppio_controp = 1
           THEN
              'Contropartita presente piu volte nel flusso'
           WHEN flg_controp_no_spesa = 1
           THEN
              'Assenza spesa legata alla contropartita'
           WHEN flg_tipo_controp_non_valido = 1
           THEN
              'Tipo contropartita non valido'
           WHEN flg_no_id_dper_rapp = 1
           THEN
              'ID_DPER null su RAPPORTI'
           WHEN flg_no_cod_controp_rapp = 1
           THEN
              'Codice contropartita null su RAPPORTI'
           WHEN flg_no_cod_rapp = 1
           THEN
              'Codice rapporto null su RAPPORTI'
           WHEN flg_rapp_caricato_app = 1
           THEN
              'Rapporto gia caricato'
           WHEN flg_rec_doppio_rapp = 1
           THEN
              'Rapporto presente piu volte nel flusso'
           WHEN flg_rapp_no_spesa = 1
           THEN
              'Assenza spesa legata al rapporto'
           WHEN flg_no_rapporto = 1
           THEN
              'Assenza rapporto sulla MCRES_APP_RAPPORTI'
           WHEN flg_out_rapporto = 1
           /*then 'Data fattura fuori range validita rapporto'*/
           THEN
              'Spesa collegata a rapporto chiuso'
           WHEN flg_manca_rapporto = 1
           THEN
              'Mancanza rapporto nel tag RAPPORTI'
           WHEN flg_rapp_no_controp = 1
           THEN
              'Rapporto privo di contropartita'
           WHEN flg_tipo_rapp_flg_invalid = 1
           THEN
              'Tipologia rapporto non valida'
           WHEN flg_rapp_tipol_errata = 1
           THEN
              'Tipologia rapporto errata'
           WHEN flg_no_id_dper_azione = 1
           THEN
              'ID_DPER null su AZIONI'
           WHEN flg_no_cod_aut_azione = 1
           THEN
              'Codice autorizzazione null su AZIONI'
           WHEN flg_no_cod_azione = 1
           THEN
              'Codice azione null su AZIONI'
           WHEN flg_azione_caricata_app = 1
           THEN
              'Azione gia presente'
           WHEN flg_rec_doppio_azioni = 1
           THEN
              'Azione presente piu volte nel flusso'
           WHEN flg_azione_no_spesa = 1
           THEN
              'Assenza spesa legata a AZIONE'
           WHEN flg_cod_azione_non_valido = 1
           THEN
              'Codice azione non valido'
           WHEN flg_no_id_dper_fattura = 1
           THEN
              'ID_DPER null su FATTURE'
           WHEN flg_no_cod_aut_fattura = 1
           THEN
              'Codice autorizzazione null su FATTURE'
           WHEN flg_fattura_caricata_app = 1
           THEN
              'Fattura gia caricata'
           WHEN flg_rec_doppio_fatture = 1
           THEN
              'Fattura presente piu volte nel flusso'
           WHEN flg_cod_sap_iva_non_censito = 1
           THEN
              'Codice iva non valido'
           WHEN flg_societa_sap_non_censita = 1
           THEN
              'Societa SAP non valida'
           WHEN flg_squadra_imp_pos_fattura = 1
           THEN
              'Importo posizione errato su FATTURE'
           WHEN flg_squadra_tot_imponibile_iva = 1
           THEN
              'Totale imponibile iva non corretto'
           WHEN flg_squadra_importo_spesa = 1
           THEN
              'Importo spesa non corretto'
           WHEN flg_squadra_netdaliq = 1
           THEN
              'Importo da liquidare non corretto'
           WHEN flg_fattura_duplicata = 1
           THEN
              'Fattura duplicata su stesso fornitore'
           WHEN flg_manca_fattura = 1
           THEN
              'Anomalia su tag fattura'
           WHEN flg_scarto_formale_spesa = 1
           THEN
              'Fallito controllo formale su SPESE'
           WHEN flg_scarto_formale_controp = 1
           THEN
              'Fallito controllo formale su CONTROPARTITE'
           WHEN flg_scarto_formale_rap = 1
           THEN
              'Fallito controllo formale su RAPPORTO'
           WHEN flg_scarto_formale_azioni = 1
           THEN
              'Fallito controllo formale su AZIONI'
           WHEN flg_scarto_formale_fatture = 1
           THEN
              'Fallito controllo formale su FATTURE'
           WHEN flg_proforma_non_def = 1
           THEN
              'Presenza proforma in stato non DE su stesso fornit'
        END
           desc_causa_scarto
   FROM (  SELECT cod_autorizzazione,
                  MAX (w.flg_scarto_formale_spesa) flg_scarto_formale_spesa,
                  MAX (w.flg_scarto_formale_controp) flg_scarto_formale_controp,
                  MAX (w.flg_scarto_formale_rap) flg_scarto_formale_rap,
                  MAX (w.flg_scarto_formale_azioni) flg_scarto_formale_azioni,
                  MAX (w.flg_scarto_formale_fatture) flg_scarto_formale_fatture,
                  MAX (w.flg_no_id_dper_spesa) flg_no_id_dper_spesa,
                  MAX (w.flg_no_cod_aut_spesa) flg_no_cod_aut_spesa,
                  MAX (w.flg_rec_doppio_spese) flg_rec_doppio_spese,
                  MAX (w.flg_assenza_pratica) flg_assenza_pratica,
                  MAX (w.flg_no_pdf_fatt) flg_no_pdf_fatt,
                  MAX (w.flg_no_pdf_nosta) flg_no_pdf_nosta,
                  MAX (w.flg_spesa_presente_su_sp) flg_spesa_presente_su_sp,
                  MAX (w.flg_spesa_presente_su_app) flg_spesa_presente_su_app,
                  MAX (w.flg_cod_aut_padre_null) flg_cod_aut_padre_null,
                  MAX (w.flg_spesa_orfana) flg_spesa_orfana,
                  MAX (w.flg_cod_tipo_aut_non_ammesso)
                     flg_cod_tipo_aut_non_ammesso,
                  MAX (w.flg_cod_stato_non_ammesso) flg_cod_stato_non_ammesso,
                  MAX (w.flg_cod_causale_non_ammesso)
                     flg_cod_causale_non_ammesso,
                  MAX (w.flg_spesa_ripetib_flg_invalid)
                     flg_spesa_ripetib_flg_invalid,
                  MAX (w.flg_cod_organ_aut_non_ammesso)
                     flg_cod_organ_aut_non_ammesso,
                  MAX (w.flg_digitale_flg_invalid) flg_digitale_flg_invalid,
                  MAX (w.flg_mod_invio_flg_invalid) flg_mod_invio_flg_invalid,
                  MAX (w.flg_causale_non_ammessa) flg_causale_non_ammessa,
                  MAX (w.flg_spesa_ripet_incoerente) flg_spesa_ripet_incoerente,
                  MAX (w.flg_no_iban) flg_no_iban,
                  MAX (w.flg_no_rappresentante) flg_no_rappresentante,
                  MAX (w.flg_no_prof_cap) flg_no_prof_cap,
                  MAX (w.flg_no_prof_comune) flg_no_prof_comune,
                  MAX (w.flg_no_prof_fax) flg_no_prof_fax,
                  MAX (w.flg_no_prof_indirizzo) flg_no_prof_indirizzo,
                  MAX (w.flg_no_prof_ncivico) flg_no_prof_ncivico,
                  MAX (w.flg_no_prof_provincia) flg_no_prof_provincia,
                  MAX (w.flg_no_autorizzatore) flg_no_autorizzatore,
                  MAX (w.flg_no_matr_autoriz) flg_no_matr_autoriz,
                  MAX (w.flg_no_causale_888) flg_no_causale_888,
                  MAX (w.flg_tipo_pagamento_non_valido)
                     flg_tipo_pagamento_non_valido,
                  MAX (w.flg_squadra_tot_imponibile_iva)
                     flg_squadra_tot_imponibile_iva,
                  MAX (w.flg_squadra_importo_spesa) flg_squadra_importo_spesa,
                  MAX (w.flg_squadra_netdaliq) flg_squadra_netdaliq,
                  MAX (w.flg_no_cod_controp) flg_no_cod_controp,
                  MAX (w.flg_no_id_dper_controp) flg_no_id_dper_controp,
                  MAX (w.flg_controp_caricata) flg_controp_caricata,
                  MAX (w.flg_rec_doppio_controp) flg_rec_doppio_controp,
                  MAX (w.flg_controp_no_spesa) flg_controp_no_spesa,
                  MAX (w.flg_tipo_controp_non_valido)
                     flg_tipo_controp_non_valido,
                  MAX (w.flg_no_id_dper_rapp) flg_no_id_dper_rapp,
                  MAX (w.flg_no_cod_controp_rapp) flg_no_cod_controp_rapp,
                  MAX (w.flg_no_cod_rapp) flg_no_cod_rapp,
                  MAX (w.flg_rapp_caricato_app) flg_rapp_caricato_app,
                  MAX (w.flg_rec_doppio_rapp) flg_rec_doppio_rapp,
                  MAX (w.flg_rapp_no_spesa) flg_rapp_no_spesa,
                  MAX (w.flg_no_rapporto) flg_no_rapporto,
                  MAX (w.flg_rapp_no_controp) flg_rapp_no_controp,
                  MAX (w.flg_rapp_tipol_errata) flg_rapp_tipol_errata,
                  MAX (w.flg_tipo_rapp_flg_invalid) flg_tipo_rapp_flg_invalid,
                  MAX (w.flg_no_id_dper_azione) flg_no_id_dper_azione,
                  MAX (w.flg_no_cod_aut_azione) flg_no_cod_aut_azione,
                  MAX (w.flg_no_cod_azione) flg_no_cod_azione,
                  MAX (w.flg_azione_caricata_app) flg_azione_caricata_app,
                  MAX (w.flg_rec_doppio_azioni) flg_rec_doppio_azioni,
                  MAX (w.flg_azione_no_spesa) flg_azione_no_spesa,
                  MAX (w.flg_cod_azione_non_valido) flg_cod_azione_non_valido,
                  MAX (w.flg_no_id_dper_fattura) flg_no_id_dper_fattura,
                  MAX (w.flg_no_cod_aut_fattura) flg_no_cod_aut_fattura,
                  MAX (w.flg_fattura_caricata_app) flg_fattura_caricata_app,
                  MAX (w.flg_rec_doppio_fatture) flg_rec_doppio_fatture,
                  MAX (w.flg_squadra_imp_pos_fattura)
                     flg_squadra_imp_pos_fattura,
                  MAX (w.flg_cod_sap_iva_non_censito)
                     flg_cod_sap_iva_non_censito,
                  MAX (w.flg_societa_sap_non_censita)
                     flg_societa_sap_non_censita,
                  MAX (w.flg_fattura_duplicata) flg_fattura_duplicata,
                  MAX (w.flg_manca_fattura) flg_manca_fattura,
                  MAX (w.flg_manca_rapporto) flg_manca_rapporto,
                  MAX (w.flg_out_rapporto) flg_out_rapporto,
                  MAX (w.flg_pratica_disattiva) flg_pratica_disattiva,
                  MAX (w.flg_proforma_non_def) flg_proforma_non_def
             FROM t_mcres_wrk_sc_etl_spese_itf w
            WHERE 0 = 0
         GROUP BY w.cod_autorizzazione);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_WRK_SC_ETL_SPESE_ITF TO MCRE_USR;
