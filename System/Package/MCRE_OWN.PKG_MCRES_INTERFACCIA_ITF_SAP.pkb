CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcres_interfaccia_itf_sap
as

/***********************************************************************************************************
   NAME:       pkg_mcres_interfaccia_itf_sap
   PURPOSE:    Gestione inferfacciamento con Italfondiario e SAP per
               acquiszione spese ITF e
               invio a SAP spese lavorate su cruscotto e provenienti da ITF

   REVISIONS:
   Ver          Date            Author              Description
   ---------    ----------      ---------------     ------------------------------------
   0.0          29/10/2012      Andrea Galliano     1. Created this package.
   0.1          29/10/2012      Andrea Galliano     2. Funzioni per popolamento tabella scarti ETL ITF
   0.2          29/10/2012      Andrea Galliano     3. Funzioni di utiitÿ  per caricamento fase 1
   0.3          02/11/2012      Andrea Galliano     4. Sostituzione merge con insert in funzioni di popolamento tabella scarti ETL ITF
   0.4          05/11/2012      Andrea Galliano     5. Gestione flusso di ritorno verso ITF con esito caricamento
   0.5          06/11/2012      Andrea Galliano     6. Popolamento tabella wrk xml con parse XML e controllo abi e periodo
   0.6          07/11/2012      Andrea Galliano     7. Nuova versione funzione fnc_carica e fnc_load
   0.7          07/11/2012      Andrea Galliano     8. Funzione per il reload alert fornitori non censiti
   0.7.1        09/11/2012      Andrea Galliano     9. Modifica sorgenti tabele wrk
   0.8          13/11/2012      Andrea Galliano    10. Creata funzione per salvare PDF estrattti da SAP tu tabella di lavoro
   0.9          13/11/2012      Andrea Galliano    11. Creata funzione per generazione file di spool
   0.9.1        13/11/2012      Andrea Galliano    12. Modificati parametri del reload alert
   0.9.2        13/11/2012      Andrea Galliano    13. Create funzioni per gestire avvio job QUARTZ
   0.9.3        13/11/2012      Andrea Galliano    14. Creata funzione fnc_aggiorna_fornitori_sp_itf per refresh post caricamento flusso FORNITORI
   0.10         14/11/2012      Andrea Galliano    15. Creata funzione per rimoszione record collegati a spese scartate
   0.10.1       14/11/2012      Andrea Galliano    16. Allineata funzione di inserimento con nuove versione di PKG_MCRES_FUNZIONI_PORTALE
   0.10.2       14/11/2012      Andrea Galliano    17. Modificata funzione di popolamento esiti caricamento
   0.10.3       14/11/2012      Andrea Galliano    18. Creata fnc_genera_flusso_postLoad_itf
   0.10.4       14/11/2012      Andrea Galliano    19. Arricchita funzione di load con generazione flusso verso ITF e HOST per calcolo UO - OD
   0.10.5       15/11/2012      Andrea Galliano    20. Creata funzione per determinare se QUARTZ puÿ² essere avviato
   0.10.6       15/11/2012      Andrea Galliano    21. Rimosso set del contesto nella funzione di generazione flusso ESITI verso ITF
   0.10.7       15/11/2012      Andrea Galliano    22. Aggiunta delete in fnc_popola_esiti_caricamento per gestione ricarichi
   0.11         15/11/2012      Andrea Galliano    23. Gestione XML multi FATTURA
   0.12         20/11/2012      Andrea Galliano    24. Creata funzione fnc_post_load_jus0_spese_itf da usare post caricamento flusso JUS0_SPESEITF
   0.12.1       22/11/2012      Andrea Galliano    25. Fix popola scarti RAPPORTI
   0.13         22/11/2012      Andrea Galliano    26. Creata funzione fnc_genera_flusso_pLoad_jus0
   0.13.1       23/11/2012      Andrea Galliano    27. Aggiunto controllo numerositÿ  XML validi in fnc_popola_wrk_tables
                                                       Se non presenti XML validi si salta la fase di caricamento
   0.14         27/11/2012      Andrea Galliano    28. Creata funzione per generare flussi da inviare a HOST per contabilizzazione
   0.15         28/12/2012      Andrea Galliano    29. Creata funzione fnc_post_load_host_spese_itf da usare post caricamento flusso HOST_SPESEITF
   0.16         03/12/2012      Andrea Galliano    30. Creata funzione fnc_last_step da lanciare da shell durante le fasi mattutine
   0.17         03/12/2012      Andrea Galliano    31. Modificata condizione di controllo caricamento PDF su fnc_aggiorna_pdf_caricati per spese in stato P
   0.17.1       03/12/2012      Andrea Galliano    32. Intregrazione inserimento flussi di controrno
   0.17.2       17/12/2012      Andrea Galliano    33. Parametrizzazione direcory in fnc_insert_wrk_xml
   0.17.3       17/12/2012      Andrea Galliano    34. Aggiornata fnc_post_load_host_spese_itf per valorizzare flg_contabilizzata su SP_SPESE
   0.18         17/12/2012      Andrea Galliano    35. Implementata fnc_last_step per creazione flussi HOST_SPESEITF, AZIONI_GIUDIZIARIE, ESITI2_SPESEITF
   0.19         19/12/2012      Andrea Galliano    36. Implementata fnc_write_blob_into_dir per scrivere PDF sul dbserver
   0.19.1       19/12/2012      Andrea Galliano    37. Implementata fnc_genera_pdf_per_sap per scrivere sul dbserver i file estratti da Documentum
   0.20         10/01/2013      Andrea Galliano    38. Implementata gestione dta_invio_pagamento su T_MCRES_APP_SP_SPESE
   0.21         22/01/2013      Andrea Galliano    39. Nuove gestione fornitori non censiti
   0.22         30/01/2013      Andrea Galliano    40. Fix Naming convenction txt SAP
   0.23         14/02/2013      Andrea Galliano    41. Modifica charset per lettura XML
   0.24         15/02/2013      Andrea Galliano    42. Create funzioni per recupero centro costo e conto COGE
   0.25         20/02/2013      Andrea Galliano    43. Filtro su flg_annullato = 0 su t_mcres_cnf_fatture_sap
   0.26         04/03/2013      Andrea Galliano    44. Modifica mappatura e decodifica campi nell'inserimento in T_MCRES_APP_SP_SPESE
   0.27         06/03/2013      Andrea Galliano    45. Valorizzazione importo voce in fase di inserimento in T_MCRES_APP_SP_FATTURE
   0.28         08/03/2013      Andrea Galliano    45. Creata fnc_abilita_LAST_STEP
   0.29         08/03/2013      Andrea Galliano    46. Aggiornamento cod_stato su T_MCRES_APP_DOCUMENTI
   0.30         12/03/2013      Andrea Galliano    47. Creata fnc_check_fatture_duplicate
   0.31         13/03/2013      Andrea Galliano    48. Modificati controlli per pdf caricati in fnc_aggiorna_pdf_caricati
   0.32         14/03/2013      Andrea Galliano    49. Modificata valorizzazione di cod_organo_autorizzante in fase di inserimento in T_MCRES_APP_SP_SPESE
   0.33         18/03/2013      Andrea Galliano    50. Esclusione dei file non contenenti dati significativi per invio sap
   0.34         19/03/2013      Andrea Galliano    51. Modificata descrizione esito  su T_MCRES_APP_ESITI_SPESE_ITF in seguito di risposta da JUS0
   0.35         21/03/2013      Andrea Galliano    52. Gestione controaggiornamento proforma definitivi
   0.36         22/03/2013      Andrea Galliano    53. Gestione concorrenza in avvio QUARTZ
   0.36.1       25/03/2013      Andrea Galliano    54. Fix gestione concorrenza in avvio QUARTZ
   0.36.2       25/03/2013      Andrea Galliano    55. Workaround parallelismo QUARTZ
   0.37         27/03/2013      Andrea Galliano    56. Valorizzazione della data trasferimento spesa
   0.38         27/03/2013      Andrea Galliano    57. Creata fnc_reload_alert_spese
   0.39         10/04/2013      Andrea Galliano    58. Modificata gestione lettura pdf e aggiunta fnc_insert_blob_into_tab
   0.40         11/04/2013      Andrea Galliano    59. Valorizzata dta_autorizzazione in fase di insert in T_MCRES_APP_SP_SPESE
   0.41         24/04/2013      Antonio Pilloni    60.  Modifica flag invio sap in genera txt
   0.42         24/04/2013      Antonio Pilloni    61.  Funzione valorizza flag invio (in fase di sviluppo)
   0.43        29/04/2013       Antonio Pilloni    62  Aggiunta gestione per evitare generazione scarto su contropartita di tipo 3
   0.44        06/05/2013       Antonio Pilloni    63  Modifica ricalcolo alert per nuova gestione
   0.45        07/05/2013       Antonio Pilloni    64  Modifica valorizzazione flag fornitore non censito
   0.46        09/05/2013       Antonio Pilloni    65  Modifica controaggiornamento proforma e insert proforma in sp spese post jus
   0.47        14/05/2013       Antonio Pilloni    66  Funzione calcolo MCT
   0.48        17/05/2013       Antonio Pilloni    67  Modifica scarti rapporti itf. Aggiunto flag out rapporto
   0.49        17/05/2013       Antonio Pilloni    68  MOdifica flaggatura invio a jus aggiunto filtro per doc_archiviati (MANCANTE)
   0.50        22/05/2013       Antonio Pilloni    69  Modifica cod_uo jus bug fix
   0.51        27/05/2013       Antonio Pilloni    70  Modifica annullamento controllo flag pratica attiva per invio spese a JUS
   0.52       29/05/2013       Antonio Pilloni     71  Aggiunta funzione popola spese da spedire fnc_popola_sent
   0.53       30/05/2013       Antonio Pilloni     72 Modifica inserimento in sp spese per default COD_INTESTARIO_TI a 'S'
   0.54       31/05/2013       Antonio Pilloni     73  Aggiunto controllo pratica chiusa spese
   0.55       13/06/2013       Antonio Pilloni     74  Invio dei proforma a JUS0
   0.56      13/06/2013       Antonio Pilloni     75 Aggiunto controllo proforma non definitivo
     0.57      10/07/2013       Antonio Pilloni     76 Modifica aggiornamento fornitori per dta_attesa
   0.6        31/07/2013       Valeria Galli       fnc_delete_spese
   0.61       02/09/2013      Antonio Pilloni      78 aggiunta modifica per esito2 intermedio TR RI
   0.62        05/09/2013      Antonio Pilloni       79 modificata funzione carica flusso per rendere ok nel periodo non trovato. (XML TUTTI VUOTI)
   0.63       09/09/2013       Antonio Pilloni        80 aggiunta funzione per il controllo no data found sui flussi acquisizione spese (XML VUOTI)
  0.64      10/09/2013       Antonio Pilloni        81 Rispristinato il carica flusso per far rendere warning quando gli iddper son nulli
0.65      10/09/2013       Antonio Pilloni        82 Aggiunta cancellazione automatica spese in carica_flusso esclusivamente quando il caricamento non va a buon fine
 0.66       10/09/2013      Antonio pIlloni        83 Aggiunta funzione cancella contesto caricamento spese itf che richiama la delete spese.
 0.67       13/11/2013      Antonio Pilloni        84 Modifica check fatture duplicate per poter inserire nuovamente fattura se spesa annullata.
 0.68      23/01/2014       Antonio Pilloni        85 Modifica inserimento spese dopo risposta jis per mappatura data proforma.
  0.69      12/03/2014       Antonio Pilloni        86 Modifica reload alert spese (ESCLUSO ALERT 18)
************************************************************************************************************/


--
function fnc_popola_scarti_spese_itf (p_rec in f_slave_par_type)
return number
is

    c_nome      constant varchar2(61)   :=  c_package || '.FNC_POPOLA_SCARTI_SPESE_ITF';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;

    v_id_flusso number;



begin

    v_id_flusso := p_rec.seq_flusso;

    v_note := 'Popolamento scarti convert';
/*
    merge into t_mcres_wrk_sc_etl_spese_itf t
    using
    (
        select
            cod_autorizzazione,
            id_dper,
            cod_abi,
            cod_ndg,
            cod_autorizzazione_padre,
            cod_tipo_autorizzazione,
            val_anno_pratica,
            cod_pratica,
            cod_stato,
            val_numero_fattura,
            dta_fattura
        from
            t_mcres_sc_convert_spese_itf
        where id_flusso = v_id_flusso
    ) s
    on ( s.cod_autorizzazione = t.cod_autorizzazione)
    when not matched then insert
    (
        t.cod_autorizzazione,
        t.id_dper,
        t.cod_abi,
        t.cod_ndg,
        t.cod_autorizzazione_padre,
        t.cod_tipo_autorizzazione,
        t.val_anno_pratica,
        t.cod_pratica,
        t.cod_stato,
        t.val_numero_fattura,
        t.dta_fattura,
        t.flg_scarto_formale_spesa
    )
    values
    (
        s.cod_autorizzazione,
        s.id_dper,
        s.cod_abi,
        s.cod_ndg,
        s.cod_autorizzazione_padre,
        s.cod_tipo_autorizzazione,
        s.val_anno_pratica,
        s.cod_pratica,
        s.cod_stato,
        s.val_numero_fattura,
        s.dta_fattura,
        1
    )
    when matched then update set
        t.id_dper                  = s.id_dper,
        t.cod_abi                  = s.cod_abi,
        t.cod_ndg                  = s.cod_ndg,
        t.cod_autorizzazione_padre = s.cod_autorizzazione_padre,
        t.cod_tipo_autorizzazione  = s.cod_tipo_autorizzazione,
        t.val_anno_pratica         = s.val_anno_pratica,
        t.cod_pratica              = s.cod_pratica,
        t.cod_stato                = s.cod_stato,
        t.val_numero_fattura       = s.val_numero_fattura,
        t.dta_fattura              = s.dta_fattura,
        t.flg_scarto_formale_spesa = 1;
*/

    insert into t_mcres_wrk_sc_etl_spese_itf
    (
        cod_autorizzazione,
--        id_dper,
--        cod_abi,
--        cod_ndg,
--        cod_autorizzazione_padre,
--        cod_tipo_autorizzazione,
--        val_anno_pratica,
--        cod_pratica,
--        cod_stato,
--        val_numero_fattura,
--        dta_fattura,
        dta_ins,
        flg_scarto_formale_spesa
    )
    select
        cod_autorizzazione,
--        id_dper,
--        cod_abi,
--        cod_ndg,
--        cod_autorizzazione_padre,
--        cod_tipo_autorizzazione,
--        val_anno_pratica,
--        cod_pratica,
--        cod_stato,
--        val_numero_fattura,
--        dta_fattura,
        sysdate,
        1
    from
        t_mcres_sc_convert_spese_itf
    where id_flusso = v_id_flusso;

    commit;


    v_note := 'Popolamento scarti vincoli';
/*
    merge into t_mcres_wrk_sc_etl_spese_itf t
    using
    (
        select
            cod_autorizzazione,
            id_dper,
            cod_abi,
            cod_ndg,
            cod_autorizzazione_padre,
            cod_tipo_autorizzazione,
            val_anno_pratica,
            cod_pratica,
            cod_stato,
            val_numero_fattura,
            dta_fattura,
            flg_record_doppio,
            flg_assenza_pratica,
            flg_spesa_orfana,
            flg_spesa_ripet_incoerente,
            flg_spesa_presente_su_sp,
            flg_spesa_presente_su_app,
            flg_no_pdf_fatt,
            flg_no_pdf_nosta,
            flg_causale_non_ammessa,
            flg_no_iban,
            flg_no_rappresentante,
            flg_no_prof_cap,
            flg_no_prof_comune,
            flg_no_prof_fax,
            flg_no_prof_indirizzo,
            flg_no_prof_ncivico,
            flg_no_prof_provincia,
            flg_no_autorizzatore,
            flg_no_matr_autoriz,
            flg_no_causale_888
        from t_mcres_sc_vincoli_spese_itf
        where id_flusso = v_id_flusso
    ) s
    on ( s.cod_autorizzazione = t.cod_autorizzazione)
    when not matched then insert
    (
        t.cod_autorizzazione,
        t.id_dper,
        t.cod_abi,
        t.cod_ndg,
        t.cod_autorizzazione_padre,
        t.cod_tipo_autorizzazione,
        t.val_anno_pratica,
        t.cod_pratica,
        t.cod_stato,
        t.val_numero_fattura,
        t.dta_fattura,
        t.flg_rec_doppio_spese,
        t.flg_assenza_pratica,
        t.flg_spesa_orfana,
        t.flg_spesa_ripet_incoerente,
        t.flg_spesa_presente_su_sp,
        t.flg_spesa_presente_su_app,
        t.flg_no_pdf_fatt,
        t.flg_no_pdf_nosta,
        t.flg_causale_non_ammessa,
        t.flg_no_iban,
        t.flg_no_rappresentante,
        t.flg_no_prof_cap,
        t.flg_no_prof_comune,
        t.flg_no_prof_fax,
        t.flg_no_prof_indirizzo,
        t.flg_no_prof_ncivico,
        t.flg_no_prof_provincia,
        t.flg_no_autorizzatore,
        t.flg_no_matr_autoriz,
        t.flg_no_causale_888,
        t.dta_ins,
        t.dta_upd
    )
    values
    (
        s.cod_autorizzazione,
        s.id_dper,
        s.cod_abi,
        s.cod_ndg,
        s.cod_autorizzazione_padre,
        s.cod_tipo_autorizzazione,
        s.val_anno_pratica,
        s.cod_pratica,
        s.cod_stato,
        s.val_numero_fattura,
        s.dta_fattura,
        s.flg_record_doppio,
        s.flg_assenza_pratica,
        s.flg_spesa_orfana,
        s.flg_spesa_ripet_incoerente,
        s.flg_spesa_presente_su_sp,
        s.flg_spesa_presente_su_app,
        s.flg_no_pdf_fatt,
        s.flg_no_pdf_nosta,
        s.flg_causale_non_ammessa,
        s.flg_no_iban,
        s.flg_no_rappresentante,
        s.flg_no_prof_cap,
        s.flg_no_prof_comune,
        s.flg_no_prof_fax,
        s.flg_no_prof_indirizzo,
        s.flg_no_prof_ncivico,
        s.flg_no_prof_provincia,
        s.flg_no_autorizzatore,
        s.flg_no_matr_autoriz,
        s.flg_no_causale_888,
        sysdate,
        sysdate
    )
    when matched then update set
        t.id_dper                       = s.id_dper,
        t.cod_abi                       = s.cod_abi,
        t.cod_ndg                       = s.cod_ndg,
        t.cod_autorizzazione_padre      = s.cod_autorizzazione_padre,
        t.cod_tipo_autorizzazione       = s.cod_tipo_autorizzazione,
        t.val_anno_pratica              = s.val_anno_pratica,
        t.cod_pratica                   = s.cod_pratica,
        t.cod_stato                     = s.cod_stato,
        t.val_numero_fattura            = s.val_numero_fattura,
        t.dta_fattura                   = s.dta_fattura,
        t.flg_rec_doppio_spese          = s.flg_record_doppio,
        t.flg_assenza_pratica           = s.flg_assenza_pratica,
        t.flg_spesa_orfana              = s.flg_spesa_orfana,
        t.flg_spesa_ripet_incoerente    = s.flg_spesa_ripet_incoerente,
        t.flg_spesa_presente_su_sp      = s.flg_spesa_presente_su_sp,
        t.flg_spesa_presente_su_app     = s.flg_spesa_presente_su_app,
        t.flg_no_pdf_fatt               = s.flg_no_pdf_fatt,
        t.flg_no_pdf_nosta              = s.flg_no_pdf_nosta,
        t.flg_causale_non_ammessa       = s.flg_causale_non_ammessa,
        t.flg_no_iban                   = s.flg_no_iban,
        t.flg_no_rappresentante         = s.flg_no_rappresentante,
        t.flg_no_prof_cap               = s.flg_no_prof_cap,
        t.flg_no_prof_comune            = s.flg_no_prof_comune,
        t.flg_no_prof_fax               = s.flg_no_prof_fax,
        t.flg_no_prof_indirizzo         = s.flg_no_prof_indirizzo,
        t.flg_no_prof_ncivico           = s.flg_no_prof_ncivico,
        t.flg_no_prof_provincia         = s.flg_no_prof_provincia,
        t.flg_no_autorizzatore          = s.flg_no_autorizzatore,
        t.flg_no_matr_autoriz           = s.flg_no_matr_autoriz,
        t.flg_no_causale_888            = s.flg_no_causale_888,
        t.dta_upd                      = sysdate;
*/

    insert into t_mcres_wrk_sc_etl_spese_itf
    (
        cod_autorizzazione,
--        id_dper,
--        cod_abi,
--        cod_ndg,
--        cod_autorizzazione_padre,
--        cod_tipo_autorizzazione,
--        val_anno_pratica,
--        cod_pratica,
--        cod_stato,
--        val_numero_fattura,
--        dta_fattura,
        flg_no_id_dper_spesa,
        flg_no_cod_aut_spesa,
        flg_rec_doppio_spese,
        flg_assenza_pratica,
        flg_no_pdf_fatt,
        flg_no_pdf_nosta,
        flg_spesa_presente_su_sp,
        flg_spesa_presente_su_app,
        flg_cod_aut_padre_null,
        flg_spesa_orfana,
        flg_cod_tipo_aut_non_ammesso,
        flg_cod_stato_non_ammesso,
        flg_cod_causale_non_ammesso,
        flg_spesa_ripetib_flg_invalid,
        flg_cod_organ_aut_non_ammesso,
        flg_digitale_flg_invalid,
        flg_mod_invio_flg_invalid,
        flg_causale_non_ammessa,
        flg_spesa_ripet_incoerente,
        flg_no_iban,
        flg_no_rappresentante,
        flg_no_prof_cap,
        flg_no_prof_comune,
        flg_no_prof_fax,
        flg_no_prof_indirizzo,
        flg_no_prof_ncivico,
        flg_no_prof_provincia,
        flg_no_autorizzatore,
        flg_no_matr_autoriz,
        flg_no_causale_888,
        flg_tipo_pagamento_non_valido,
        flg_squadra_tot_imponibile_iva,
        flg_squadra_importo_spesa,
        flg_squadra_netdaliq,
        flg_fattura_duplicata,
        flg_manca_fattura,
        flg_manca_rapporto,
        flg_pratica_disattiva,
        flg_proforma_non_def
    )
    select
        cod_autorizzazione,
--        id_dper,
--        cod_abi,
--        cod_ndg,
--        cod_autorizzazione_padre,
--        cod_tipo_autorizzazione,
--        val_anno_pratica,
--        cod_pratica,
--        cod_stato,
--        val_numero_fattura,
--        dta_fattura,
        flg_id_dper_null,
        flg_cod_aut_null,
        flg_record_doppio,
        flg_assenza_pratica,
        flg_no_pdf_fatt,
        flg_no_pdf_nosta,
        flg_spesa_presente_su_sp,
        flg_spesa_presente_su_app,
        flg_cod_aut_padre_null,
        flg_spesa_orfana,
        flg_cod_tipo_aut_non_ammesso,
        flg_cod_stato_non_ammesso,
        flg_cod_causale_non_ammesso,
        flg_spesa_ripetib_flg_invalid,
        flg_cod_organ_aut_non_ammesso,
        flg_digitale_flg_invalid,
        flg_mod_invio_flg_invalid,
        flg_causale_non_ammessa,
        flg_spesa_ripet_incoerente,
        flg_no_iban,
        flg_no_rappresentante,
        flg_no_prof_cap,
        flg_no_prof_comune,
        flg_no_prof_fax,
        flg_no_prof_indirizzo,
        flg_no_prof_ncivico,
        flg_no_prof_provincia,
        flg_no_autorizzatore,
        flg_no_matr_autoriz,
        flg_no_causale_888,
        flg_tipo_pagamento_non_valido,
        flg_squadra_tot_imponibile_iva,
        flg_squadra_importo_spesa,
        flg_squadra_netdaliq,
        flg_fattura_duplicata,
        flg_manca_fattura,
        flg_manca_rapporto,
        flg_pratica_disattiva,
        flg_proforma_non_def
    from t_mcres_sc_vincoli_spese_itf
    where id_flusso = v_id_flusso;

    commit;

    return c_ok;

exception
when others
then

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'GENERALE: ' || v_note
                                    );

    rollback;

    return c_ko;

end;



function fnc_popola_scarti_controp_itf (p_rec in f_slave_par_type)
return number
is

    c_nome      constant varchar2(61)   :=  c_package || '.FNC_POPOLA_SCARTI_CONTROP_ITF';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;

    v_id_flusso number;



begin

    v_id_flusso := p_rec.seq_flusso;

    v_note := 'Popolamento scarti convert';
/*
    merge into t_mcres_wrk_sc_etl_spese_itf t
    using
    (
        select cod_autorizzazione
        from t_mcres_sc_convert_controp_itf
        where id_flusso = v_id_flusso
    ) s
    on ( s.cod_autorizzazione = t.cod_autorizzazione)
    when not matched then insert
    (
        t.cod_autorizzazione,
        t.flg_scarto_formale_controp
    )
    values
    (
        s.cod_autorizzazione,
        1
    )
    when matched then update set
        t.flg_scarto_formale_controp = 1;
*/

    insert into t_mcres_wrk_sc_etl_spese_itf
    (
        cod_autorizzazione,
        flg_scarto_formale_controp,
        dta_ins
    )
    select
        cod_autorizzazione,
        1,
        sysdate
    from
        t_mcres_sc_convert_controp_itf
    where 0=0
        and id_flusso = v_id_flusso;

    commit;


    v_note := 'Popolamento scarti vincoli';
/*
    merge into t_mcres_wrk_sc_etl_spese_itf t
    using
    (
        select
            cod_autorizzazione,
            flg_record_doppio,
            flg_no_spesa
        from t_mcres_sc_vincoli_controp_itf
        where id_flusso = v_id_flusso
    ) s
    on ( s.cod_autorizzazione = t.cod_autorizzazione)
    when not matched then insert
    (
        t.cod_autorizzazione,
        t.flg_rec_doppio_controp,
        t.flg_controp_no_spesa,
        t.dta_ins,
        t.dta_upd
    )
    values
    (
        s.cod_autorizzazione,
        s.flg_record_doppio,
        s.flg_no_spesa,
        sysdate,
        sysdate
    )
    when matched then update set
        t.flg_rec_doppio_controp    = s.flg_record_doppio,
        t.flg_controp_no_spesa      = s.flg_no_spesa,
        t.dta_upd                   = sysdate;
*/

    insert into t_mcres_wrk_sc_etl_spese_itf
    (
        cod_autorizzazione,
        flg_no_cod_controp,
        flg_no_id_dper_controp,
        flg_controp_caricata,
        flg_rec_doppio_controp,
        flg_controp_no_spesa,
        flg_tipo_controp_non_valido
    )
    select
        cod_autorizzazione,
        flg_null_cod_controp,
        flg_null_id_dper,
        flg_caricata_app,
        flg_record_doppio,
        flg_no_spesa,
        flg_tipo_controp_non_ammesso
    from
        t_mcres_sc_vincoli_controp_itf
    where 0=0
        and id_flusso = v_id_flusso;

    commit;

    return c_ok;

exception
when others
then

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'GENERALE: ' || v_note
                                    );

    rollback;

    return c_ko;

end;


function fnc_popola_scarti_rapp_itf (p_rec in f_slave_par_type)
return number
is

    c_nome      constant varchar2(61)   :=  c_package || '.FNC_POPOLA_SCARTI_RAPP_ITF';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;

    v_id_flusso number;



begin

    v_id_flusso := p_rec.seq_flusso;

    v_note := 'Popolamento scarti convert';
/*
    merge into t_mcres_wrk_sc_etl_spese_itf t
    using
    (
        select cod_autorizzazione
        from t_mcres_sc_convert_rapp_itf
        where id_flusso = v_id_flusso
    ) s
    on ( s.cod_autorizzazione = t.cod_autorizzazione)
    when not matched then insert
    (
        t.cod_autorizzazione,
        t.flg_scarto_formale_rap
    )
    values
    (
        s.cod_autorizzazione,
        1
    )
    when matched then update set
        t.flg_scarto_formale_rap = 1;
*/

    insert into t_mcres_wrk_sc_etl_spese_itf
    (
        cod_autorizzazione,
        flg_scarto_formale_rap,
        dta_ins
    )
    select
        a.cod_autorizzazione,
        1,
        sysdate
    from
        t_mcres_sc_convert_rapp_itf a
 left join t_mcres_app_contropartite_itf b on (a.cod_autorizzazione = b.cod_autorizzazione)
    where 0=0
        and a.id_flusso = v_id_flusso
        and b.cod_tipo NOT IN ('3','4','5','8');

    commit;


    v_note := 'Popolamento scarti vincoli';

/*
    merge into t_mcres_wrk_sc_etl_spese_itf t
    using
    (
        select
            cod_autorizzazione,
            flg_record_doppio,
            flg_no_rapporto,
            flg_no_contropartita,
            flg_tipologia_errata
        from t_mcres_sc_vincoli_rapp_itf
        where id_flusso = v_id_flusso
    ) s
    on ( s.cod_autorizzazione = t.cod_autorizzazione)
    when not matched then insert
    (
        t.cod_autorizzazione,
        t.flg_rec_doppio_rapp,
        t.flg_no_rapporto,
        t.flg_rapp_no_controp,
        t.flg_rapp_tipol_errata,
        t.dta_ins,
        t.dta_upd
    )
    values
    (
        s.cod_autorizzazione,
        s.flg_record_doppio,
        s.flg_no_rapporto,
        s.flg_no_contropartita,
        s.flg_tipologia_errata,
        sysdate,
        sysdate
    )
    when matched then update set
        t.flg_rec_doppio_rapp           = s.flg_record_doppio,
        t.flg_no_rapporto               = s.flg_no_rapporto,
        t.flg_rapp_no_controp           = s.flg_no_contropartita,
        t.flg_rapp_tipol_errata         = s.flg_tipologia_errata,
        t.dta_upd                       = sysdate;
*/

    insert into t_mcres_wrk_sc_etl_spese_itf
    (
        cod_autorizzazione,
        flg_no_id_dper_rapp,
        flg_no_cod_controp_rapp,
        flg_no_cod_rapp,
        flg_rapp_caricato_app,
        flg_rec_doppio_rapp,
        flg_no_rapporto,
        flg_rapp_no_controp,
        flg_tipo_rapp_flg_invalid,
        flg_rapp_tipol_errata,
        flg_out_rapporto
    )
    select
        a.cod_autorizzazione,
        a.flg_id_dper_null,
        a.flg_no_contropartita,
        a.flg_cod_rapp_null,
        a.flg_caricato_app,
        a.flg_record_doppio,
        a.flg_no_rapporto,
        a.flg_no_contropartita,
        a.flg_tipo_rapp_flg_invalid,
        a.flg_tipologia_errata,
        a.flg_out_rapporto
    from t_mcres_sc_vincoli_rapp_itf a
 left join t_mcres_app_contropartite_itf b on (a.cod_autorizzazione = b.cod_autorizzazione)
    where id_flusso = v_id_flusso
      and b.cod_tipo NOT IN ('3','4','5','8');

    commit;

    return c_ok;

exception
when others
then

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'GENERALE: ' || v_note
                                    );

    rollback;

    return c_ko;

end;


function fnc_popola_scarti_azioni_itf (p_rec in f_slave_par_type)
return number
is

    c_nome      constant varchar2(61)   :=  c_package || '.FNC_POPOLA_SCARTI_AZIONI_ITF';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;

    v_id_flusso number;



begin

    v_id_flusso := p_rec.seq_flusso;

    v_note := 'Popolamento scarti convert';
/*
    merge into t_mcres_wrk_sc_etl_spese_itf t
        using
        (
            select cod_autorizzazione
            from t_mcres_sc_convert_azioni_itf
            where id_flusso = v_id_flusso
        ) s
        on ( s.cod_autorizzazione = t.cod_autorizzazione)
        when not matched then insert
        (
            t.cod_autorizzazione,
            t.flg_scarto_formale_azioni
        )
        values
        (
            s.cod_autorizzazione,
            1
        )
        when matched then update set
            t.flg_scarto_formale_azioni = 1;
*/

    insert into t_mcres_wrk_sc_etl_spese_itf
    (
        cod_autorizzazione,
        flg_scarto_formale_azioni,
        dta_ins
    )
    select
        cod_autorizzazione,
        1,
        sysdate
    from
        t_mcres_sc_convert_azioni_itf
    where 0=0
        and id_flusso = v_id_flusso;

    commit;


    v_note := 'Popolamento scarti vincoli';
/*
    merge into t_mcres_wrk_sc_etl_spese_itf t
    using
    (
        select
            cod_autorizzazione,
            flg_record_doppio,
            flg_no_spesa,
            flg_cod_azione_non_valido
        from t_mcres_sc_vincoli_azioni_itf
        where id_flusso = v_id_flusso
    ) s
    on ( s.cod_autorizzazione = t.cod_autorizzazione)
    when not matched then insert
    (
        t.cod_autorizzazione,
        t.flg_rec_doppio_azioni,
        t.flg_azione_no_spesa,
        t.flg_cod_azione_non_valido,
        t.dta_ins,
        t.dta_upd
    )
    values
    (
        s.cod_autorizzazione,
        s.flg_record_doppio,
        s.flg_no_spesa,
        s.flg_cod_azione_non_valido,
        sysdate,
        sysdate
    )
    when matched then update set
        t.flg_rec_doppio_azioni         = s.flg_record_doppio,
        t.flg_azione_no_spesa           = s.flg_no_spesa,
        t.flg_cod_azione_non_valido     = s.flg_cod_azione_non_valido,
        t.dta_upd                       = sysdate;
*/

    insert into t_mcres_wrk_sc_etl_spese_itf
    (
        cod_autorizzazione,
        flg_no_id_dper_azione,
        flg_no_cod_aut_azione,
        flg_no_cod_azione,
        flg_azione_caricata_app,
        flg_rec_doppio_azioni,
        flg_azione_no_spesa,
        flg_cod_azione_non_valido
    )
    select
        cod_autorizzazione,
        flg_id_dper_null,
        flg_cod_aut_null,
        flg_cod_azione_null,
        flg_caricata_app,
        flg_record_doppio,
        flg_no_spesa,
        flg_cod_azione_non_valido
    from
        t_mcres_sc_vincoli_azioni_itf
    where 0=0
        and id_flusso = v_id_flusso;

    commit;

    return c_ok;

exception
when others
then

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'GENERALE: ' || v_note
                                    );

    rollback;

    return c_ko;

end;


function fnc_popola_scarti_fatture_itf (p_rec in f_slave_par_type)
return number
is

    c_nome      constant varchar2(61)   :=  c_package || '.FNC_POPOLA_SCARTI_FATTURE_ITF';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;

    v_id_flusso number;



begin

    v_id_flusso := p_rec.seq_flusso;

    v_note := 'Popolamento scarti convert';
/*
    merge into t_mcres_wrk_sc_etl_spese_itf t
        using
        (
            select cod_autorizzazione
            from t_mcres_sc_convert_fatture_itf
            where id_flusso = v_id_flusso
        ) s
        on ( s.cod_autorizzazione = t.cod_autorizzazione)
        when not matched then insert
        (
            t.cod_autorizzazione,
            t.flg_scarto_formale_fatture
        )
        values
        (
            s.cod_autorizzazione,
            1
        )
        when matched then update set
            t.flg_scarto_formale_fatture = 1;
*/

    insert into t_mcres_wrk_sc_etl_spese_itf
    (
        cod_autorizzazione,
        flg_scarto_formale_fatture,
        dta_ins
    )
    select
        cod_autorizzazione,
        1,
        sysdate
    from
        t_mcres_sc_convert_fatture_itf
    where 0=0
        and id_flusso = v_id_flusso;

    commit;


    v_note := 'Popolamento scarti vincoli';
/*
    merge into t_mcres_wrk_sc_etl_spese_itf t
    using
    (
        select
            cod_autorizzazione,
            flg_record_doppio,
            flg_cod_sap_iva_non_censito,
            flg_societa_sap_non_censita
        from t_mcres_sc_vincoli_fatture_itf
        where id_flusso = v_id_flusso
    ) s
    on ( s.cod_autorizzazione = t.cod_autorizzazione)
    when not matched then insert
    (
        t.cod_autorizzazione,
        t.flg_rec_doppio_fatture,
        t.flg_cod_sap_iva_non_censito,
        t.flg_societa_sap_non_censita,
        t.dta_ins,
        t.dta_upd
    )
    values
    (
        s.cod_autorizzazione,
        s.flg_record_doppio,
        s.flg_cod_sap_iva_non_censito,
        s.flg_societa_sap_non_censita,
        sysdate,
        sysdate
    )
    when matched then update set
        t.flg_rec_doppio_azioni         = s.flg_record_doppio,
        t.flg_cod_sap_iva_non_censito   = s.flg_cod_sap_iva_non_censito,
        t.flg_societa_sap_non_censita   = s.flg_societa_sap_non_censita,
        t.dta_upd                       = sysdate;
*/

    insert into t_mcres_wrk_sc_etl_spese_itf
    (
        cod_autorizzazione,
        flg_no_id_dper_fattura,
        flg_no_cod_aut_fattura,
        flg_fattura_caricata_app,
        flg_rec_doppio_fatture,
        flg_squadra_imp_pos_fattura,
        flg_cod_sap_iva_non_censito,
        flg_societa_sap_non_censita
    )
    select
        cod_autorizzazione,
        flg_id_dper_null,
        flg_cod_aut_null,
        flg_caricata_app,
        flg_record_doppio,
        flg_squadra_imp_pos,
        flg_cod_sap_iva_non_censito,
        flg_societa_sap_non_censita

    from
        t_mcres_sc_vincoli_fatture_itf
    where 0=0
        and id_flusso = v_id_flusso;

    commit;

    return c_ok;

exception
when others
then

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'GENERALE: ' || v_note
                                    );

    rollback;

    return c_ko;

end;



-- Inserisce nalla t_mcres_wrk_xml_itf effettuando il parse del file xml
-- e controllandovaliditÿ  di periodo e abi (sostituisce ckeckperioso e checkin)
function fnc_insert_wrk_xml
(
    p_val_file_name     in  t_mcres_wrk_xml_itf.val_file_name%type,
    v_file_ok           out boolean
)
return number
is

    c_nome              constant varchar2(61)   :=  c_package || '.FNC_INSERT_WRK_XML';
    v_note              t_mcres_wrk_audit_caricamenti.note%type;

    v_stmt              varchar2(32767);
    v_cod_abi           varchar2(5);
    v_id_dper           varchar2(8);    --volutamente varchar2
    v_count             number(1);
    v_dir               t_mcres_wrk_configurazione.valore_costante%type;


--    parse_ko            exception;
--    pragma              exception_init(parse_ko, -31011);


begin

    v_note  := 'Estazione abi e periodo da nome file';

    v_id_dper := substr( p_val_file_name, 7, 8);
    v_cod_abi := substr( p_val_file_name, 16, 5);


    v_note  := 'Recupero nome dalla directory Oracle dalla quale leggere il file';

    select valore_costante
    into v_dir
    from t_mcres_wrk_configurazione
    where nome_costante = 'DIR_XML_ITF';

    v_note := 'Controllo periodo abi del file XML';


--        v_stmt := 'select count(*)
--        from
--        (
--                select
--                id_dper_spese,
--                id_dper_azioni,
--                id_dper_contropartite,
--                id_dper_fatture,
--                lpad(cod_abi_spese, 5, ''0''),
--                lpad(cod_abi_azioni, 5, ''0''),
--                lpad(cod_abi_contropartite, 5, ''0''),
--                lpad(cod_abi_rapporti, 5, ''0'')
--            from xmltable
--            (
--                ''SPESE/SPESA''
--                passing xmltype(bfilename(''D_MCRES_WORK'',''' || p_val_file_name ||'''),nls_charset_id(''WE8ISO8859P15'') )
--                columns
--                            id_dper_spese               varchar2(512) path ''id_dper'',
--                            id_dper_azioni              varchar2(512) path ''AZIONI/AZIONE/id_dper'',
--                            id_dper_contropartite       varchar2(512) path ''CONTROPARTITE/CONTROPARTITA/id_dper'',
--                            id_dper_fatture             varchar2(512) path ''FATTURE/FATTURA/id_dper'',
--                            cod_abi_spese               varchar2(512) path ''Cod_Abi'',
--                            cod_abi_azioni              varchar2(512) path ''AZIONI/AZIONE/Cod_Abi'',
--                            cod_abi_contropartite       varchar2(512) path ''CONTROPARTITE/CONTROPARTITA/COD_Abi'',
--                            cod_abi_rapporti            varchar2(512) path ''RAPPORTI/RAPPORTO/COD_Abi''
--             )
--            minus
--            select
--                ''' || v_id_dper || ''',
--                ''' || v_id_dper || ''',
--                ''' || v_id_dper || ''',
--                ''' || v_id_dper || ''',
--                ''' || v_cod_abi || ''',
--                ''' || v_cod_abi || ''',
--                ''' || v_cod_abi || ''',
--                ''' || v_cod_abi || '''
--            from
--                dual
--        )';


    begin

--        v_stmt := 'select count(*) n
--        from
--        (
--            select
--                id_dper,
--                lpad(cod_abi, 5, ''0'') cod_abi
--            from
--            (
--                select
--                    id_dper,
--                    cod_abi
--                from xmltable
--                (
--                    ''SPESE/SPESA''
--                    passing xmltype(bfilename(''' || v_dir || ''',''' || p_val_file_name ||'''),nls_charset_id(''WE8ISO8859P15'') )
--                    columns
--                        id_dper     varchar2(512) path ''id_dper'',
--                        cod_abi     varchar2(512) path ''Cod_Abi''
--                )
--                union all
--                select
--                    id_dper,
--                    cod_abi
--                from xmltable
--                (
--                    ''SPESE/SPESA/AZIONI/AZIONE''
--                    passing xmltype(bfilename(''D_MCRES_WORK'',''' || p_val_file_name ||'''),nls_charset_id(''WE8ISO8859P15'') )
--                    columns
--                        id_dper     varchar2(512) path ''id_dper'',
--                        cod_abi     varchar2(512) path ''Cod_Abi''
--                )
--                union all
--                select
--                    id_dper,
--                    cod_abi
--                from xmltable
--                (
--                    ''SPESE/SPESA/CONTROPARTITE/CONTROPARTITA''
--                    passing xmltype(bfilename(''D_MCRES_WORK'',''' || p_val_file_name ||'''),nls_charset_id(''WE8ISO8859P15'') )
--                    columns
--                        id_dper     varchar2(512) path ''id_dper'',
--                        cod_abi     varchar2(512) path ''COD_Abi''
--                )
--                union all
--                select
--                    ''' || v_id_dper || ''' id_dper,
--                    cod_abi
--                from xmltable
--                (
--                    ''SPESE/SPESA/RAPPORTI/RAPPORTO''
--                    passing xmltype(bfilename(''D_MCRES_WORK'',''' || p_val_file_name ||'''),nls_charset_id(''WE8ISO8859P15'') )
--                    columns
--                        cod_abi     varchar2(512) path ''COD_Abi''
--                )
--                union all
--                select
--                    id_dper,
--                    ''' || v_cod_abi || ''' cod_abi
--                from xmltable
--                (
--                    ''SPESE/SPESA/FATTURE/FATTURA''
--                    passing xmltype(bfilename(''D_MCRES_WORK'',''' || p_val_file_name ||'''),nls_charset_id(''WE8ISO8859P15'') )
--                    columns
--                        id_dper     varchar2(512) path ''id_dper''
--                )
--            )
--            minus
--            select
--                ''' || v_id_dper || ''' id_dper,
--                ''' || v_cod_abi || ''' cod_abi
--            from dual
--        )';

    v_stmt := 'select count(*) n
        from
        (
            select
                id_dper,
                lpad(cod_abi, 5, ''0'') cod_abi
            from
            (
                select
                    id_dper,
                    cod_abi
                from xmltable
                (
                    ''SPESE/SPESA''
                    passing xmltype(bfilename(''' || v_dir || ''',''' || p_val_file_name ||'''), nls_charset_id(''WE8ISO8859P15'') )
                    columns
                        id_dper     varchar2(512) path ''id_dper'',
                        cod_abi     varchar2(512) path ''Cod_Abi''
                )
                union all
                select
                    id_dper,
                    cod_abi
                from xmltable
                (
                    ''SPESE/SPESA/AZIONI/AZIONE''
                    passing xmltype(bfilename(''' || v_dir || ''',''' || p_val_file_name ||'''), nls_charset_id(''WE8ISO8859P15'') )
                    columns
                        id_dper     varchar2(512) path ''id_dper'',
                        cod_abi     varchar2(512) path ''Cod_Abi''
                )
                union all
                select
                    id_dper,
                    cod_abi
                from xmltable
                (
                    ''SPESE/SPESA/CONTROPARTITE/CONTROPARTITA''
                    passing xmltype(bfilename(''' || v_dir || ''',''' || p_val_file_name ||'''), nls_charset_id(''WE8ISO8859P15'') )
                    columns
                        id_dper     varchar2(512) path ''id_dper'',
                        cod_abi     varchar2(512) path ''COD_Abi''
                )
                union all
                select
                    ''' || v_id_dper || ''' id_dper,
                    cod_abi
                from xmltable
                (
                    ''SPESE/SPESA/RAPPORTI/RAPPORTO''
                    passing xmltype(bfilename(''' || v_dir || ''',''' || p_val_file_name ||'''), nls_charset_id(''WE8ISO8859P15'') )
                    columns
                        cod_abi     varchar2(512) path ''COD_Abi''
                )
                union all
                select
                    id_dper,
                    ''' || v_cod_abi || ''' cod_abi
                from xmltable
                (
                    ''SPESE/SPESA/FATTURE/FATTURA''
                    passing xmltype(bfilename(''' || v_dir || ''',''' || p_val_file_name ||'''), nls_charset_id(''WE8ISO8859P15'') )
                    columns
                        id_dper     varchar2(512) path ''id_dper''
                )
            )
            minus
            select
                ''' || v_id_dper || ''' id_dper,
                ''' || v_cod_abi || ''' cod_abi
            from dual
        )';


        execute immediate v_stmt into v_count;


    exception
    when others
    then


        v_file_ok := false;

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_warning,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'PARSE KO. File: ' || p_val_file_name,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ok;

    end;

    if v_count > 0
    then

        v_file_ok := false;

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_warning,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'FILE KO: ' || p_val_file_name,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ok;


    end if;

    v_note := 'Inserimento file ' || p_val_file_name;


    v_stmt := 'insert into t_mcres_wrk_xml_itf (val_file_name, xml_content)
               values ( ''' || p_val_file_name || ''', xmltype(bfilename(''' || v_dir || ''',''' || p_val_file_name ||'''),nls_charset_id(''WE8ISO8859P15'')))';

    execute immediate v_stmt;

    commit;

    v_file_ok := true;

    return c_ok;


exception
--when parse_ko
--then

--    v_file_ok := false;

--    pkg_mcres_audit.log_app (
--                                p_proc      => c_nome,
--                                p_livello   => pkg_mcres_audit.c_warning,
--                                p_sqlcode   => SQLCODE,
--                                p_mssg      => SQLERRM,
--                                p_note      => 'PARSE KO. File: ' || p_val_file_name,
--                                p_utente    => 'JOB_SP_ITF'
--                            );

--    return c_ok;

when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;



--
--function fnc_check_xml( p_cod_flusso in t_mcres_wrk_alimentazione.cod_flusso%type )
--return number
--is

--    c_nome      constant varchar2(61)   :=  c_package || '.FNC_CHECK_XML';
--    v_note      t_mcres_wrk_audit_caricamenti.note%type;
--
--    v_stmt      varchar2(255);
--    v_count     number;


--begin

--    v_stmt  :=  'select count(*) from ve_mcres_' || p_cod_flusso || ' where rownum <= 1';
--
--    execute immediate v_stmt into v_count;
--
--    return c_ok;
--
--
--exception
--when others
--then

--        pkg_mcres_audit.log_app (
--                                    p_proc      => c_nome,
--                                    p_livello   => pkg_mcres_audit.c_error,
--                                    p_sqlcode   => SQLCODE,
--                                    p_mssg      => SQLERRM,
--                                    p_note      => 'GENERALE: ' || v_note,
--                                    p_utente    => 'JOB_SP_ITF'
--                                );
--
--        return c_ko;
--
--end;


--
function fnc_prepara_wrk_tables
return number
is

    c_nome      constant varchar2(61)   :=  c_package || '.FNC_PREPARA_WRK_TABLES';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;


begin

    v_note := 'Tronca T_MCRES_WRK_COD_AUT_SPESE_ITF';

    execute immediate 'truncate table T_MCRES_WRK_COD_AUT_SPESE_ITF';



    v_note := 'Tronca T_MCRES_WRK_PDF_SPESE_ITF';

    execute immediate 'truncate table T_MCRES_WRK_PDF_SPESE_ITF drop storage';


    v_note := 'Tronca T_MCRES_WRK_XML_ITF reuse storage';

    execute immediate 'truncate table T_MCRES_WRK_XML_ITF';


    v_note := 'Tronca T_MCRES_WRK_SC_ETL_SPESE_ITF';

    execute immediate 'truncate table T_MCRES_WRK_SC_ETL_SPESE_ITF';

    v_note := 'Tronca T_MCRES_WRK_PDF_FROM_DOC';

    execute immediate 'truncate table T_MCRES_WRK_PDF_FROM_DOC';


    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

end;


--
function fnc_popola_wrk_tables
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_POPOLA_WRK_TABLES';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_stmt          varchar2(1024);
    v_file_name     t_mcres_wrk_xml_itf.val_file_name%type;
    v_ret           number;
    v_file_ok       boolean;
    v_count         number;

    cursor c
    is
    --
        select distinct val_file_name
        from te_mcres_lista_xml_itf;
    --

begin

--    v_note := 'Popolamento T_MCRES_WRK_LISTA_PDF_ITF';

--    insert into t_mcres_wrk_lista_pdf_itf
--    (
--        val_file_name
--    )
--    select distinct val_pdf_filename
--    from te_mcres_pdf_spese_itf;

--    commit;

    v_note := 'Popolamento T_MCRES_WRK_PDF_SPESE_ITF';

    for r in (select distinct val_pdf_filename from te_mcres_lista_pdf_itf)
    loop

        v_ret:= fnc_insert_blob_into_tab(r.val_pdf_filename, 'D_MCRES_ITF');

        if v_ret <> c_ok
        then


            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_warning,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Errore nel caricamento del file ' || r.val_pdf_filename,
                                        p_utente    => 'JOB_SP_ITF'
                                    );

        end if;

    end loop;


    v_note := 'Popolamento T_MCRES_WRK_LISTA_XML_ITF';

    v_count := 0;

    for r in c
    loop

        v_file_name := r.val_file_name;

        v_ret := fnc_insert_wrk_xml( v_file_name, v_file_ok);

        if v_ret = c_ko
        then

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'ERRORE nel popolamento di T_MCRES_WRK_LISTA_PDF_ITF. File ' || v_file_name,
                                        p_utente    => 'JOB_SP_ITF'
                                    );
            return c_ko;

        else

            if v_file_ok
            then

                v_count := v_count + 1;

                pkg_mcres_audit.log_app (
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_debug,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'Inserito file ' || v_file_name || ' in T_MCRES_WRK_XML_ITF',
                                            p_utente    => 'JOB_SP_ITF'
                                        );

            else

                pkg_mcres_audit.log_app (
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_warning,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'Controlli non superati. File ' || v_file_name,
                                            p_utente    => 'JOB_SP_ITF'
                                        );

                insert into t_mcres_app_esiti_spese_itf
                (
                    cod_source,
                    id_lotto,
                    id_dper,
                    id_esito,
                    desc_esito,
                    cod_autorizzazione,
                    cod_abi
                )
                values
                (
                    'ITF',
                    substr( v_file_name, 7, 8),
                    to_char( sysdate - 1/3, 'yyyymmdd'),
                    '2080',
                    'Falliti controlli di conformita su file XML     ',
                    lpad( substr( v_file_name, 7, 14), 16, 'X'),
                    substr( v_file_name, 16, 5)
                );

                commit;

            end if;

        end if;


    end loop;

    commit;

    v_note := 'Popolamento T_MCRES_WRK_COD_AUT_SPESE_ITF';

    if v_count = 0
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_warning,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Nessun XML valido',
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_warning;

    else

        insert into t_mcres_wrk_cod_aut_spese_itf
        (
            cod_autorizzazione
        )
        select distinct cod_autorizzazione
        from v_mcres_wrk_spese_itf;

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Popolata T_MCRES_WRK_COD_AUT_SPESE_ITF',
                                    p_utente    => 'JOB_SP_ITF'
                                );

        commit;

    end if;


    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;



--
function fnc_carica_flusso( p_cod_flusso in t_mcres_wrk_alimentazione.cod_flusso%type)
return number
is

    c_nome              constant varchar2(61)   :=  c_package || '.FNC_CARICA_FLUSSO';
    v_note              t_mcres_wrk_audit_caricamenti.note%type;

    v_id_flusso         number;
    v_return            number;
    v_stmt              varchar2(32767);
    v_id_dper           varchar2(8);
    v_periodo           date;
    v_ko_periodo        t_mcres_wrk_configurazione.valore_costante%type;
    v_stato_ok          t_mcres_wrk_configurazione.valore_costante%type;

     v_ret number;



begin

    v_note := 'Recupero valori costanti da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_ko_periodo
    from t_mcres_wrk_configurazione
    where nome_costante = 'STATO_KO_PERIODO';

    select valore_costante
    into v_stato_ok
    from t_mcres_wrk_configurazione
    where nome_costante = 'STATO_OK';



    v_note := 'Stacco nextval da SEQ_MCRES_FLUSSO';

    select seq_mcres_flusso.nextval
    into v_id_flusso
    from dual;


    v_note := 'Insert T_MCRES_WRK_ACQUISIZIONE';

    insert into t_mcres_wrk_acquisizione
    (
        id_flusso,
        cod_file,
        cod_flusso,
        parametro_itt_1,
        val_tab_external,
        val_scarti_external
    )
    values
    (
        v_id_flusso,
        p_cod_flusso,
        p_cod_flusso,
        p_cod_flusso,
        'V_MCRES_WRK_' || p_cod_flusso,
        -1
    );

    commit;

    v_note := 'Controllo validita periodo';

    begin

        v_stmt := 'select distinct id_dper from V_MCRES_WRK_' || p_cod_flusso;

        execute immediate v_stmt into v_id_dper;


        v_note := 'Controllo periodo sia data valida';

        if fnc_mcres_is_date(v_id_dper, 'yyyymmdd') = 0
        then

            pkg_mcres_audit.log_caricamenti (
                                                p_id_flusso => v_id_flusso,
                                                p_proc      => c_nome,
                                                p_livello   => pkg_mcres_audit.c_warning,
                                                p_sqlcode   => SQLCODE,
                                                p_mssg      => SQLERRM,
                                                p_note      => 'Fallita conversione in data di ID_DPER. Flusso : ' || p_cod_flusso
                                            );

            update t_mcres_wrk_acquisizione
            set cod_stato = v_ko_periodo
            where id_flusso = v_id_flusso;

            commit;

            -- AP 10/09/2013 CANCELLAZIONE CONTESTO
            v_ret := fnc_delete_context_caricamento (v_id_flusso, p_cod_flusso);

            return c_warning;

        else

            v_periodo := to_date(v_id_dper, 'yyyymmdd');

            update t_mcres_wrk_acquisizione
            set
                id_dper = v_periodo,
                cod_stato = v_stato_ok
            where id_flusso = v_id_flusso;

            commit;

            pkg_mcres_audit.log_caricamenti (
                                                p_id_flusso => v_id_flusso,
                                                p_proc      => c_nome,
                                                p_livello   => pkg_mcres_audit.c_debug,
                                                p_sqlcode   => SQLCODE,
                                                p_mssg      => SQLERRM,
                                                p_note      =>'ID_DPER valido: ' || v_id_dper || '. Flusso : ' || p_cod_flusso
                                            );


        end if;


    exception
    when too_many_rows
    then

        pkg_mcres_audit.log_caricamenti (
                                            p_id_flusso => v_id_flusso,
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_warning,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'Fallito controllo ID_DPER. Piu periodi individuati. Flusso : ' || p_cod_flusso
                                        );

        update t_mcres_wrk_acquisizione
        set cod_stato = v_ko_periodo
        where id_flusso = v_id_flusso;

        commit;

        -- AP 10/09/2013 CANCELLAZIONE CONTESTO
        v_ret := fnc_delete_context_caricamento (v_id_flusso, p_cod_flusso);

        return c_warning;

    when no_data_found
    then

        pkg_mcres_audit.log_caricamenti (
                                            p_id_flusso => v_id_flusso,
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_warning,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'Fallito controllo ID_DPER: periodo nullo. Flusso : ' || p_cod_flusso
                                        );

        update t_mcres_wrk_acquisizione
        set cod_stato = v_ko_periodo
        where id_flusso = v_id_flusso;

        commit;

        -- AP 10/09/2013 CANCELLAZIONE CONTESTO
        v_ret := fnc_delete_context_caricamento (v_id_flusso, p_cod_flusso);

        return c_warning;

    when others
    then

        pkg_mcres_audit.log_caricamenti (
                                            p_id_flusso => v_id_flusso,
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_error,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'GENERALE: ' || v_note
                                        );

        rollback;

        -- AP 10/09/2013 CANCELLAZIONE CONTESTO
        v_ret := fnc_delete_context_caricamento (v_id_flusso, p_cod_flusso);

        return c_ko;

    end;


    v_note := 'Call FNC_MCRES_FUNZIONI_MASTER';

    v_return := pkg_mcres_funzioni_master.fnc_mcres_master( v_id_flusso, p_cod_flusso);  -- cod_flusso = cod_file

    if v_return <> c_ok
    then

        pkg_mcres_audit.log_caricamenti (
                                            p_id_flusso => v_id_flusso,
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_warning,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'GENERALE: ' || v_note
                                        );

        -- AP 10/09/2013 CANCELLAZIONE CONTESTO
        v_ret := fnc_delete_context_caricamento (v_id_flusso, p_cod_flusso);

        return c_warning;

    end if;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Caricamento completato correttamente. Flusso: ' || p_cod_flusso
                                    );

    return c_ok;

exception
when others
then

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'GENERALE: ' || v_note
                                    );

    rollback;

    -- AP 10/09/2013 CANCELLAZIONE CONTESTO
    v_ret := fnc_delete_context_caricamento (v_id_flusso, p_cod_flusso);

    return c_ko;

end;


--
function fnc_load
return number
is

    c_nome      constant varchar2(61)   :=  c_package || '.FNC_LOAD';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;

    v_return    number;
    v_carica    boolean;



begin

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'INIZIO - FNC_LOAD',
                                p_utente    => 'JOB_SP_ITF'
                            );


    v_note := 'Preparazione tabelle WRK';

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'INIZIO - FNC_PREPARA_WRK_TABLES',
                                p_utente    => 'JOB_SP_ITF'
                            );

    -- call
    v_return := fnc_prepara_wrk_tables;

    if v_return <> c_ok
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore funzione FNC_PREPARA_WRK_TABLES',
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    else

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'FINE - FNC_PREPARA_WRK_TABLES eseguita correttamente',
                                    p_utente    => 'JOB_SP_ITF'
                                );

    end if;


    v_note := 'Popolamento tabelle WRK';


    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'INIZIO - FNC_POPOLA_WRK_TABLES',
                                p_utente    => 'JOB_SP_ITF'
                            );

    -- call
    v_return := fnc_popola_wrk_tables;


    if v_return = c_ok
    then

        v_carica := true;

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'FINE - FNC_POPOLA_WRK_TABLES eseguita correttamente',
                                    p_utente    => 'JOB_SP_ITF'
                                );

    elsif v_return = c_warning
    then

        v_carica := false;

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_warning,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'FINE - FNC_POPOLA_WRK_TABLES eseguita con WARNING',
                                    p_utente    => 'JOB_SP_ITF'
                                );

    else

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore funzione FNC_POPOLA_WRK_TABLES',
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    end if;


    if v_carica = true
    then

        v_note := 'Caricamento flusso CONTROPARTITE_ITF';

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'INIZIO - ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        -- call
        v_return := fnc_carica_flusso('CONTROPARTITE_ITF');

        if v_return <> c_ok -- anche in caso di warning
        then

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Errore ' || v_note,
                                        p_utente    => 'JOB_SP_ITF'
                                    );

            --

            return c_ko;

        else

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'FINE - ' || v_note,
                                        p_utente    => 'JOB_SP_ITF'
                                    );

        end if;


        v_note := 'Caricamento flusso RAPPORTI_ITF';

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'INIZIO - ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        -- call
        v_return := fnc_carica_flusso('RAPPORTI_ITF');

        if v_return <> c_ok -- anche in caso di warning
        then

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Errore ' || v_note,
                                        p_utente    => 'JOB_SP_ITF'
                                    );

            return c_ko;

        else

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'FINE - ' || v_note,
                                        p_utente    => 'JOB_SP_ITF'
                                    );

        end if;


        v_note := 'Caricamento flusso AZIONI_ITF';

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'INIZIO - ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        -- call
        v_return := fnc_carica_flusso('AZIONI_ITF');

        if v_return <> c_ok -- anche in caso di warning
        then

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Errore ' || v_note,
                                        p_utente    => 'JOB_SP_ITF'
                                    );

            return c_ko;

        else

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'FINE - ' || v_note,
                                        p_utente    => 'JOB_SP_ITF'
                                    );

        end if;



        v_note := 'Caricamento flusso FATTURE_ITF';

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'INIZIO - ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        -- call
        v_return := fnc_carica_flusso('FATTURE_ITF');

        if v_return <> c_ok -- anche in caso di warning
        then

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Errore ' || v_note,
                                        p_utente    => 'JOB_SP_ITF'
                                    );

            return c_ko;

        else

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'FINE - ' || v_note,
                                        p_utente    => 'JOB_SP_ITF'
                                    );

        end if;


        v_note := 'Caricamento flusso SPESE_ITF';

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'INIZIO - ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        -- call
        v_return := fnc_carica_flusso('SPESE_ITF');

        if v_return <> c_ok -- anche in caso di warning
        then

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Errore ' || v_note,
                                        p_utente    => 'JOB_SP_ITF'
                                    );

            return c_ko;

        else

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'FINE - ' || v_note,
                                        p_utente    => 'JOB_SP_ITF'
                                    );

        end if;

    end if;

    v_note := 'Genera flusso di ritorno ad ITF contentente esiti caricamento - call fnc_genera_flusso_post_load_itf';

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'INIZIO - ' || v_note,
                                p_utente    => 'JOB_SP_ITF'
                            );

    -- call
    v_return := fnc_genera_flusso_postLoad_itf;

    if v_return <> c_ok -- anche in caso di warning
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    else

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'FINE - ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

    end if;



--    v_note := 'Genera flusso da inviare a HOST per calcolo UO e OD - call fnc_genera_flusso_calcolo_uo';
--
--    pkg_mcres_audit.log_app (
--                                p_proc      => c_nome,
--                                p_livello   => pkg_mcres_audit.c_debug,
--                                p_sqlcode   => SQLCODE,
--                                p_mssg      => SQLERRM,
--                                p_note      => 'INIZIO - ' || v_note,
--                                p_utente    => 'JOB_SP_ITF'
--                            );
--
--    -- call
--    v_return := fnc_genera_flusso_calcolo_uo;
--
--    if v_return <> c_ok -- anche in caso di warning
--    then

--        pkg_mcres_audit.log_app (
--                                    p_proc      => c_nome,
--                                    p_livello   => pkg_mcres_audit.c_error,
--                                    p_sqlcode   => SQLCODE,
--                                    p_mssg      => SQLERRM,
--                                    p_note      => 'Errore ' || v_note,
--                                    p_utente    => 'JOB_SP_ITF'
--                                );

--        return c_ko;
--
--    else
--
--        pkg_mcres_audit.log_app (
--                                    p_proc      => c_nome,
--                                    p_livello   => pkg_mcres_audit.c_debug,
--                                    p_sqlcode   => SQLCODE,
--                                    p_mssg      => SQLERRM,
--                                    p_note      => 'FINE - ' || v_note,
--                                    p_utente    => 'JOB_SP_ITF'
--                                );

--    end if;


    v_note := 'Abilita esecuzione QUARTZ';

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'INIZIO - ' || v_note,
                                p_utente    => 'JOB_SP_ITF'
                            );

    -- call
    v_return := fnc_avvia_QUARTZ;

    if v_return <> c_ok -- anche in caso di warning
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    else

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'FINE - ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

    end if;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'FINE - FNC_LOAD',
                                p_utente    => 'JOB_SP_ITF'
                            );


    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

end;




---
function fnc_set_cod_uo_od_calcolato
(
   p_cod_autorizzazione in  t_mcres_app_spese_itf.cod_autorizzazione%type,
   p_cod_uo_proposto    in  t_mcres_app_spese_itf.cod_uo_proposto%type,
   p_cod_uo_calcolato   in  t_mcres_app_spese_itf.cod_uo_calcolato%type,
   p_cod_od_calcolato   in  t_mcres_app_spese_itf.cod_od_calcolato%type,
   p_cod_utente         in  t_mcres_wrk_audit_applicativo.utente%type       default null
)
return number
is

    c_nome      constant varchar2(61)   :=  c_package || '.FNC_SET_COD_UO_OD_CALCOLATO';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;

    v_count     number;



begin

    v_note := 'Controllo validitÿ  parametri di input';

    if      p_cod_autorizzazione    is null
        or  p_cod_uo_proposto       is null
        or  p_cod_uo_calcolato      is null
        or  p_cod_od_calcolato      is null
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Parametri di input non validi.COD_AUTORIZZAZIONE = ' || p_cod_autorizzazione
                                                    ||  ', COD_UO_PROPOSTO = ' || p_cod_uo_proposto || ', COD_UO_CALCOLATO = ' || p_cod_uo_calcolato
                                                    ||  ', COD_OD_CALCOLATO = ' || p_cod_od_calcolato,
                                    p_utente    => nvl(p_cod_utente, 'JOB_SP_ITF')
                                );
        return c_ko;

    end if;



    v_note := 'Controllo esistenza spesa';

    select count(*)
    into v_count
    from t_mcres_app_spese_itf
    where cod_autorizzazione = p_cod_autorizzazione;

    if v_count = 0
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Spesa non presente. COD_AUTORIZZAZIONE = ' || p_cod_autorizzazione,
                                    p_utente    => nvl(p_cod_utente, 'JOB_SP_ITF')
                                );


        return c_ko;


    end if;


    update t_mcres_app_spese_itf
    set
        cod_uo_proposto      = p_cod_uo_proposto,
        cod_uo_calcolato     = p_cod_uo_calcolato,
        cod_od_calcolato     = p_cod_od_calcolato,
        flg_calcolato_uo_od  = 1,
        dta_calcolo_uo_od    = sysdate
    where cod_autorizzazione = p_cod_autorizzazione;

    commit;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Calcolati UO, OD.COD_AUTORIZZAZIONE = ' || p_cod_autorizzazione
                                                ||  ', COD_UO_PROPOSTO = ' || p_cod_uo_proposto || ', COD_UO_CALCOLATO = ' || p_cod_uo_calcolato
                                                ||  ', COD_OD_CALCOLATO = ' || p_cod_od_calcolato,
                                p_utente    => nvl(p_cod_utente, 'JOB_SP_ITF')
                            );

    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => nvl(p_cod_utente, 'JOB_SP_ITF')
                                );


        rollback;

        return c_ko;

end;



function fnc_post_load_jus0_spese_itf
(
    p_rec in f_slave_par_type
)
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_POST_LOAD_JUS0_SPESE_ITF';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_count         number;
    v_id_dper       varchar2(8);
    v_id_flusso     number;



begin

    v_id_flusso := p_rec.seq_flusso;
    v_id_dper   := to_char(p_rec.periodo, 'yyyymmdd');

    v_note := ' Insert T_MCRES_APP_SP_CONTROPARTITA';

    insert into t_mcres_app_sp_contropartita
    (
        id_dper,
        cod_autorizzazione,
        cod_contropartita,
        cod_tipo,
        cod_divisa,
        val_importo,
        cod_filiale,
        dta_ins,
        dta_upd
    )
    select
        c.id_dper,
        c.cod_autorizzazione,
        c.cod_contropartita,
        c.cod_tipo,
        c.cod_divisa,
        c.val_importo,
        c.cod_filiale,
        sysdate,
        sysdate
    from
        t_mcres_app_contropartite_itf c
    where 0=0
        and exists
        (
            select 1
            from
                t_mcres_app_spese_itf s,
                t_mcres_app_jus0_speseitf j
            where 0=0
                and c.cod_autorizzazione = j.cod_autorizzazione
                and s.cod_autorizzazione = j.cod_autorizzazione
                and s.flg_inserita_sp_spese = 0
                and s.flg_calcolato_uo_od = 0
                and s.flg_docs_archiviati = 1
                and s.flg_fornitore_non_censito = 0
                and j.id_dper = v_id_dper
                and j.cod_esito = '00'
            /*union all
            select 1
            from t_mcres_app_spese_itf s
            where 0=0
                and c.cod_autorizzazione = s.cod_autorizzazione
                --AP 13/06/2013
                --and s.cod_tipo_autorizzazione = '5'
                and s.flg_inserita_sp_spese = 0
                and s.flg_docs_archiviati = 1
                and s.flg_fornitore_non_censito = 0*/

        );

    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Inseriti ' || v_count || ' record in T_MCRES_APP_SP_CONTROPARTITA'
                                    );

   v_note := ' Insert T_MCRES_APP_SP_RAPPORTO';

       insert into  t_mcres_app_sp_rapporto
    (
        id_dper,
        cod_autorizzazione,
        cod_contropartita,
        cod_rapporto,
        cod_filiale_competente,
        flg_tipo_rapporto,
        cod_prodotto,
        dta_ins,
        dta_upd
    )
    select
        r.id_dper,
        r.cod_autorizzazione,
        r.cod_contropartita,
        r.cod_rapporto,
        r.cod_filiale_competente,
        r.flg_tipo_rapporto,
        r.cod_prodotto,
        sysdate,
        sysdate
    from
        t_mcres_app_rapporti_itf r
    where 0=0
        and exists
        (
            select 1
            from
                t_mcres_app_spese_itf s,
                t_mcres_app_jus0_speseitf j
            where 0=0
                and r.cod_autorizzazione = j.cod_autorizzazione
                and s.cod_autorizzazione = j.cod_autorizzazione
                and s.flg_inserita_sp_spese = 0
                and s.flg_calcolato_uo_od = 0
                and s.flg_docs_archiviati = 1
                and s.flg_fornitore_non_censito = 0
                and j.id_dper = v_id_dper
                and j.cod_esito = '00'
            /*union all
            select 1
            from t_mcres_app_spese_itf s
            where 0=0
                and r.cod_autorizzazione = s.cod_autorizzazione
                --AP 13/06/2013
                --and s.cod_tipo_autorizzazione = '5'
                and s.flg_inserita_sp_spese = 0
                and s.flg_docs_archiviati = 1
                and s.flg_fornitore_non_censito = 0*/
        );

    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Inseriti ' || v_count || ' record in T_MCRES_APP_SP_RAPPORTO'
                                    );


    v_note := ' Insert T_MCRES_APP_SP_AZIONI';

    insert into t_mcres_app_sp_azioni
    (
        id_dper,
        cod_autorizzazione,
        cod_azione,
        dta_ins,
        dta_upd
    )
  select
        a.id_dper,
        a.cod_autorizzazione,
        a.cod_azione,
        sysdate,
        sysdate
    from
        t_mcres_app_azioni_itf a
    where 0=0
        and exists
        (
            select 1
            from
                t_mcres_app_spese_itf s,
                t_mcres_app_jus0_speseitf j
            where 0=0
                and a.cod_autorizzazione = j.cod_autorizzazione
                and s.cod_autorizzazione = j.cod_autorizzazione
                and s.flg_inserita_sp_spese = 0
                and s.flg_calcolato_uo_od = 0
                and s.flg_docs_archiviati = 1
                and s.flg_fornitore_non_censito = 0
                and j.id_dper = v_id_dper
                and j.cod_esito = '00'
            /*union all
            select 1
            from t_mcres_app_spese_itf s
            where 0=0
                and a.cod_autorizzazione = s.cod_autorizzazione
                --AP 13/06/2013
                --and s.cod_tipo_Autorizzazione = '5'
                and s.flg_inserita_sp_spese = 0
                and s.flg_docs_archiviati = 1
                and s.flg_fornitore_non_censito = 0*/
        );

    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Inseriti ' || v_count || ' record in T_MCRES_APP_SP_AZIONI'
                                    );


    v_note := ' Insert T_MCRES_APP_SP_FATTURE';

    insert into t_mcres_app_sp_fatture
    (
        cod_autorizzazione,
        cod_tipo_autorizzazione,
        val_imponibile_iva,
        val_aliquota_iva,
        val_importo_pos,
        cod_sap_iva,
        val_importo_voce,
        prog_fattura,
        dta_ins,
        dta_upd
    )
    select
        f.cod_autorizzazione,
        s.cod_tipo_autorizzazione,
        f.val_imponibile_iva,
        f.val_aliquota_iva,
        f.val_importo_pos,
        f.cod_sap_iva,
        f.val_imponibile_iva,
        row_number() over (partition by f.cod_autorizzazione order by cod_sap_iva),
        sysdate,
        sysdate
    from
        t_mcres_app_fatture_itf f,
        t_mcres_app_spese_itf s
    where 0=0
        and s.cod_autorizzazione = f.cod_autorizzazione
        and exists
        (
            select 1
            from
                t_mcres_app_jus0_speseitf j
            where 0=0
                and f.cod_autorizzazione = j.cod_autorizzazione
                and s.flg_inserita_sp_spese = 0
                and s.flg_calcolato_uo_od = 0
                and s.flg_docs_archiviati = 1
                and s.flg_fornitore_non_censito = 0
                and j.id_dper = v_id_dper
                and j.cod_esito = '00'
            /*union all
            select 1
            from t_mcres_app_spese_itf sp
            where 0=0
                and f.cod_autorizzazione = sp.cod_autorizzazione
                --AP 13/06/2013
                --and sp.cod_tipo_Autorizzazione = '5'
                and sp.flg_inserita_sp_spese = 0
                and s.flg_docs_archiviati = 1
                and s.flg_fornitore_non_censito = 0*/
        );

    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Inseriti ' || v_count || ' record in T_MCRES_APP_SP_FATTURE'
                                    );



    v_note := ' Insert T_MCRES_APP_SP_SPESE';

    insert into t_mcres_app_sp_spese
    (
        cod_abi,
        cod_autorizzazione,
        cod_autorizzazione_padre,
        cod_causa_divisa,
        cod_causale,
        cod_causale_888,
        cod_iban,
        cod_importo_divisa,
        cod_matricola,
        cod_ndg,
        cod_organo_autorizzante,
        cod_pratica,
        cod_punto_operativo,
        cod_stato,
        cod_tipo_autorizzazione,
        cod_tipo_pagamento,
        --desc_afavore,
        desc_intestatario,
        desc_spesa,
        dta_bon_valuta,
        dta_fattura,
        flg_spesa_recuperata,
        flg_spesa_ripetibile,
        id_dper,
        --val_afavore_codfisc,
        val_intestatario_codfisc,
        --val_afavore_piva,
        val_intestatario_piva,
        val_anno_pratica,
        val_causa_importo,
        val_circ_intestatario,
        val_circ_trasferibile,
        val_ente_pagatore,
        val_fax,
        val_importo_valore,
        val_note,
        val_num_proforma,
        val_numero_fattura,
        val_prof_cap,
        val_prof_comune,
        val_prof_fax,
        val_prof_indirizzo,
        val_prof_ncivico,
        val_prof_provincia,
        val_rappresentante,
        val_riferimento_nominativo,
        dta_ins,
        dta_upd,
        flg_source,
        cod_od_calcolato,
        cod_uo,
        cod_uo_pratica,
        dta_trasf_spesa,
        dta_autorizzazione,
        cod_intestatario_tipo,
        dta_proforma_a_fattura
    )
    select
        s.cod_abi,
        s.cod_autorizzazione,
        s.cod_autorizzazione_padre,
        s.cod_causa_divisa,
        s.cod_causale,
        s.cod_causale_888,
        s.cod_iban,
        s.cod_importo_divisa,
        s.val_matr_autoriz,
        s.cod_ndg,
        --s.cod_organo_autorizzante,
        case
            when j.cod_uo_calcolato in ('12001', '12012')
                then 'PI'
            else null
        end cod_organo_autorizzante,
        s.cod_pratica,
        s.cod_punto_operativo,
        --
        case
            when j.cod_uo_calcolato in ('12001', '12012')
                then 'CO'
            when j.cod_uo_calcolato = '06472'
                then 'TR'
        end cod_stato,
        --
        s.cod_tipo_autorizzazione,
        s.cod_tipo_pagamento,
        s.desc_afavore,
        nullif(s.desc_spesa,'0'),
        s.dta_bon_valuta,
        --AP 23/01/2014 al posto di s.dta_fattura secco
        CASE WHEN s.cod_tipo_autorizzazione != '5' THEN s.dta_fattura ELSE null END,
        decode(s.flg_spesa_recuperata, '1', 'S', '0', 'N'),
        decode(s.flg_spesa_ripetibile, '1', 'S', '0', 'N'),
        s.id_dper,
        s.val_afavore_codfisc,
        s.val_afavore_piva,
        s.val_anno_pratica,
        s.val_causa_importo,
        s.val_circ_intestatario,
        s.val_circ_trasferibile,
        s.val_ente_pagatore,
        s.val_fax,
        s.val_importo_valore,
        s.val_note,
        s.val_num_proforma,
        s.val_numero_fattura,
        s.val_prof_cap,
        s.val_prof_comune,
        s.val_prof_fax,
        s.val_prof_indirizzo,
        s.val_prof_ncivico,
        s.val_prof_provincia,
        s.val_rappresentante,
        s.val_riferimento_nominativo,
        sysdate,
        sysdate,
        'ITF',
        j.cod_od_calcolato,
        j.cod_uo_calcolato,
        pr.cod_uo_pratica,
        case    -- per data trasferimento
            when  j.cod_uo_calcolato = '06472'
                then trunc(sysdate)
        end,
        case    -- per data autorizzazione
            when j.cod_uo_calcolato in ('12001', '12012')
                then trunc(sysdate)
        end,
        'S' cod_intestatario_tipo,
        --AP 23/01/2014
        CASE WHEN s.cod_tipo_autorizzazione = '5' THEN s.dta_fattura ELSE null END
    from
        t_mcres_app_spese_itf s,
        t_mcres_app_jus0_speseitf j,
        t_mcres_app_pratiche pr
    where 0=0
        and s.cod_autorizzazione = j.cod_autorizzazione
        and s.cod_abi = pr.cod_abi(+)
        and s.cod_ndg = pr.cod_ndg(+)
        and s.cod_pratica = pr.cod_pratica(+)
        and s.val_anno_pratica = pr.val_anno(+)
        and s.flg_inserita_sp_spese = 0
        and s.flg_calcolato_uo_od = 0
        and s.flg_docs_archiviati = 1
        and s.flg_fornitore_non_censito = 0
        and j.id_dper = v_id_dper
        and j.cod_esito = '00'
        -- clausola inserita per sicurezza ma ridondante in quanto sul flusso JUS0 non ci sono i record
        -- di controaggiornamento dei proforma
        and case when s.cod_tipo_autorizzazione = '1' then val_num_proforma else null end is null;
        -- esclusi i proforma
        --AP 13/06/2013
        --and s.cod_tipo_autorizzazione  != '5';


    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Inseriti ' || v_count || ' record in T_MCRES_APP_SP_SPESE - no proforma'
                                    );

    --AP 13/06/2013
    /*v_note := ' Insert T_MCRES_APP_SP_SPESE - proforma';

    insert into t_mcres_app_sp_spese
    (
        cod_abi,
        cod_autorizzazione,
        cod_autorizzazione_padre,
        cod_causa_divisa,
        cod_causale,
        cod_causale_888,
        cod_iban,
        cod_importo_divisa,
        cod_matricola,
        cod_ndg,
        cod_organo_autorizzante,
        cod_pratica,
        cod_punto_operativo,
        cod_stato,
        cod_tipo_autorizzazione,
        cod_tipo_pagamento,
        --desc_afavore,
        desc_intestatario,
        desc_spesa,
        dta_bon_valuta,
        dta_fattura,
        flg_spesa_recuperata,
        flg_spesa_ripetibile,
        id_dper,
        --val_afavore_codfisc,
        val_intestatario_codfisc,
        --val_afavore_piva,
        val_intestatario_piva,
        val_anno_pratica,
        val_causa_importo,
        val_circ_intestatario,
        val_circ_trasferibile,
        val_ente_pagatore,
        val_fax,
        val_importo_valore,
        val_note,
        val_num_proforma,
        val_numero_fattura,
        val_prof_cap,
        val_prof_comune,
        val_prof_fax,
        val_prof_indirizzo,
        val_prof_ncivico,
        val_prof_provincia,
        val_rappresentante,
        val_riferimento_nominativo,
        dta_ins,
        dta_upd,
        flg_source,
        cod_od_calcolato,
        cod_uo,
        cod_uo_pratica,
        dta_trasf_spesa,
        cod_intestatario_tipo
    )
    select
        s.cod_abi,
        s.cod_autorizzazione,
        s.cod_autorizzazione_padre,
        s.cod_causa_divisa,
        s.cod_causale,
        s.cod_causale_888,
        s.cod_iban,
        s.cod_importo_divisa,
        s.val_matr_autoriz,
        s.cod_ndg,
        --s.cod_organo_autorizzante,
        'RI' cod_organo_autorizzante,
        s.cod_pratica,
        s.cod_punto_operativo,
        --
        'TR' cod_stato,
        --
        s.cod_tipo_autorizzazione,
        s.cod_tipo_pagamento,
        s.desc_afavore,
        nullif(s.desc_spesa,'0'),
        s.dta_bon_valuta,
        s.dta_fattura,
        decode(s.flg_spesa_recuperata, '1', 'S', '0', 'N'),
        decode(s.flg_spesa_ripetibile, '1', 'S', '0', 'N'),
        s.id_dper,
        s.val_afavore_codfisc,
        s.val_afavore_piva,
        s.val_anno_pratica,
        s.val_causa_importo,
        s.val_circ_intestatario,
        s.val_circ_trasferibile,
        s.val_ente_pagatore,
        s.val_fax,
        s.val_importo_valore,
        s.val_note,
        s.val_num_proforma,
        s.val_numero_fattura,
        s.val_prof_cap,
        s.val_prof_comune,
        s.val_prof_fax,
        s.val_prof_indirizzo,
        s.val_prof_ncivico,
        s.val_prof_provincia,
        s.val_rappresentante,
        s.val_riferimento_nominativo,
        sysdate,
        sysdate,
        'ITF',
        'RI' cod_od_calcolato,
        '06472' cod_uo,
        pr.cod_uo_pratica,
        trunc(sysdate),
        'S' cod_intestatario_tipo
    from
        t_mcres_app_spese_itf s,
        t_mcres_app_pratiche pr
    where 0=0
        and s.cod_abi = pr.cod_abi(+)
        and s.cod_ndg = pr.cod_ndg(+)
        and s.cod_pratica = pr.cod_pratica(+)
        and s.val_anno_pratica = pr.val_anno(+)
        and s.flg_inserita_sp_spese = 0
        and s.flg_docs_archiviati = 1
        and s.flg_fornitore_non_censito = 0
        and s.cod_tipo_autorizzazione = '5';


    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Inseriti ' || v_count || ' record in T_MCRES_APP_SP_SPESE - proforma'
                                    );*/


    v_note := 'Aggiornamento stato su T_MCRES_APP_DOCUMENTI';

    merge into t_mcres_app_documenti t
    using
    (
        select
            s.cod_abi,
            s.cod_ndg,
            s.cod_autorizzazione,
            case
                when j.cod_uo_calcolato in ('12001', '12012')
                    then 'CO'
                when j.cod_uo_calcolato = '06472'
                    then 'TR'
            end cod_stato
        from
            t_mcres_app_spese_itf s,
            t_mcres_app_jus0_speseitf j
        where 0=0
            and s.cod_autorizzazione = j.cod_autorizzazione
            and s.flg_inserita_sp_spese = 0
            and s.flg_calcolato_uo_od = 0
            and s.flg_docs_archiviati = 1
            and s.flg_fornitore_non_censito = 0
            and j.id_dper = v_id_dper
            and j.cod_esito = '00'
            --AP 13/06/2013
            --and s.cod_tipo_autorizzazione != '5'    -- i proform sono in stato trasferito e tali rimangono
    ) s
    on
    (
            s.cod_abi = t.cod_abi
        and s.cod_ndg = t.cod_ndg
        and s.cod_autorizzazione = t.cod_aut_protoc
    )
    when matched then
    update set
        t.cod_stato = s.cod_stato;

--    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Aggiornata T_MCRES_APP_DOCUMENTI'
                                    );

    v_note := 'Insert spese scartate in T_MCRES_APP_ESITI_SPESE_ITF';

    insert
    into t_mcres_app_esiti_spese_itf
    (
        id_lotto,
        cod_source,
        id_dper,
        id_esito,
        desc_esito,
        cod_autorizzazione,
        cod_abi,
        cod_ndg,
        cod_autorizzazione_padre,
        val_anno_pratica,
        cod_pratica,
        cod_stato,
        val_numero_fattura,
        dta_fattura
    )
    select
        a.id_dper id_lotto,
        'HST' cod_source,
        to_char(sysdate, 'yyyymmdd') id_dper,
        '02' id_esito,
        'Risposta host non valida' desc_esito,
        a.cod_autorizzazione,
        a.cod_abi,
        substr(a.cod_ndg, 4) cod_ndg,
        a.cod_autorizzazione_padre,
        a.val_anno_pratica,
        a.cod_pratica,
        a.cod_stato,
        a.val_numero_fattura,
        a.dta_fattura
    from t_mcres_app_spese_itf a
    where 0=0
    and exists
        (
           select 1
            from
            (
                select cod_autorizzazione
                from t_mcres_sc_convert_jus0_sp_itf
                where id_flusso = v_id_flusso
                union all
                select cod_autorizzazione
                from t_mcres_sc_vincoli_jus0_sp_itf
                where id_flusso = v_id_flusso
            ) x
            where x.cod_autorizzazione = a.cod_autorizzazione
        );

    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Inserite ' || v_count || ' spese scartate in T_MCRES_APP_ESITI_SPESE_ITF'
                                    );



    v_note := ' Insert spese non scartate in fase di caricamento in T_MCRES_APP_ESITI_SPESE_ITF';

    insert
    into t_mcres_app_esiti_spese_itf
    (
        id_lotto,
        cod_source,
        id_dper,
        id_esito,
        desc_esito,
        cod_autorizzazione,
        cod_abi,
        cod_ndg,
        cod_autorizzazione_padre,
        val_anno_pratica,
        cod_pratica,
        cod_stato,
        val_numero_fattura,
        dta_fattura
    )
    select
        s.id_dper id_lotto,
        'HST' cod_source,
        to_char(sysdate, 'yyyymmdd') id_dper,
        --
        case
            when j.cod_esito = '00' and j.cod_uo_calcolato in ('12001', '12012')
                then '00'
            when j.cod_esito = '00' and j.cod_uo_calcolato = '06472'
                then '10'
            when j.cod_esito = '99' or j.cod_esito is null
                then '02'
        end id_esito,
        --
        case
            when j.cod_esito = '00' and j.cod_uo_calcolato in ('12001', '12012')
                then 'Acquisita e confermata in autonomia'
            when j.cod_esito = '00' and j.cod_uo_calcolato = '06472'
                then 'Acquisita e da confermare da RI'
            when j.cod_esito = '99' or j.cod_esito is null
                then substr(j.desc_esito, 1, 50)
        end desc_esito,
        --
        s.cod_autorizzazione,
        s.cod_abi,
        s.cod_ndg,
        s.cod_autorizzazione_padre,
        s.val_anno_pratica,
        s.cod_pratica,
        s.cod_stato,
        s.val_numero_fattura,
        s.dta_fattura
        from
            t_mcres_app_spese_itf s,
            t_mcres_app_jus0_speseitf j
        where 0=0
            and s.cod_autorizzazione = j.cod_autorizzazione
            and s.flg_inserita_sp_spese = 0
            and s.flg_calcolato_uo_od = 0
            and s.flg_docs_archiviati = 1
            and s.flg_fornitore_non_censito = 0
            and j.id_dper = v_id_dper
            and
            (
                (j.cod_esito = '00' and j.cod_uo_calcolato in ('12001', '12012', '06472') )
                or nvl(j.cod_esito, '99') = '99'
            );


    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Inserite ' || v_count || ' spese non scartate in T_MCRES_APP_ESITI_SPESE_ITF'
                                    );


    v_note := 'Merge T_MCRES_APP_SPESE_ITF per record validi';

    merge into t_mcres_app_spese_itf t
    using
    (
     select
            id_dper,
            cod_autorizzazione,
            cod_esito,
            cod_uo_proponente,
            cod_uo_calcolato,
            cod_od_calcolato,
            to_date(id_dper, 'yyyymmdd') dta_calcolo_uo_od
        from
            t_mcres_app_jus0_speseitf
        where 0=0
            and id_dper = v_id_dper
    ) s
    on
    (
        s.cod_autorizzazione = t.cod_autorizzazione
    )
    when matched then
    update set
        t.cod_uo_proposto = s.cod_uo_proponente,
        t.cod_uo_calcolato = s.cod_uo_calcolato,
        t.cod_od_calcolato = s.cod_od_calcolato,
        t.dta_calcolo_uo_od = s.dta_calcolo_uo_od,
        t.flg_calcolato_uo_od = decode(s.cod_esito, '00', 1, -1),
        t.flg_inserita_sp_spese = decode(s.cod_esito, '00', 1, -1),
        t.dta_inserimento_sp_spese = sysdate,
        t.dta_upd = sysdate
    where 0=0
        and t.flg_calcolato_uo_od = 0
        and t.cod_autorizzazione = s.cod_autorizzazione;


/*AP 13/06/2013
    v_note := 'Update T_MCRES_APP_SPESE_ITF per record validi - proforma';

    update t_mcres_app_spese_itf s
    set
        s.flg_inserita_sp_spese = 1,
        s.dta_inserimento_sp_spese = sysdate
        where 0=0
            and s.flg_inserita_sp_spese = 0
            and s.flg_docs_archiviati = 1
            and s.flg_fornitore_non_censito = 0
            and s.cod_tipo_autorizzazione = '5';*/



    v_note := 'Update T_MCRES_APP_SPESE_ITF per record non validi';

    update t_mcres_app_spese_itf t
    set
        t.flg_calcolato_uo_od = -1
    where 0=0
        and t.flg_calcolato_uo_od = 0
        and exists
        (
            select 1
            from
            (
                select cod_autorizzazione
                from t_mcres_sc_vincoli_jus0_sp_itf
                where id_flusso = v_id_flusso
                union all
                select cod_autorizzazione
                from t_mcres_sc_convert_jus0_sp_itf
                where id_flusso = v_id_flusso
            ) u
            where t.cod_autorizzazione = u.cod_autorizzazione
        );

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Aggiornata T_MCRES_APP_SPESE_ITF'
                                    );

    commit;

    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_caricamenti (
                                            p_id_flusso => v_id_flusso,
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_error,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'GENERALE: ' || v_note
                                        );

        rollback;

        return c_ko;

end;



function fnc_post_load_host_spese_itf
(
    p_rec in f_slave_par_type
)
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_POST_LOAD_HOST_SPESE_ITF';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_count         number;
    v_id_dper       varchar2(8);
    v_id_flusso     number;
    v_cod_abi       t_mcres_wrk_acquisizione.cod_abi%type;



begin

    v_id_flusso := p_rec.seq_flusso;
    v_id_dper   := to_char(p_rec.periodo, 'yyyymmdd');


    v_note := 'Recupero COD_ABI da T_MCRES_WRK_ACQUISIZIONE';

    select cod_abi
    into v_cod_abi
    from t_mcres_wrk_acquisizione
    where id_flusso = v_id_flusso;


    v_note := ' Update flg_contabilizzata su T_MCRES_APP_SP_SPESE';

    update t_mcres_app_sp_spese s
    set
        flg_contabilizzata = 1,
        dta_upd = sysdate
    where 0=0
    and flg_source = 'ITF'
    and exists
    (
        select 1
        from
            t_mcres_app_host_speseitf h
        where 0=0
            and h.cod_autorizzazione = s.cod_autorizzazione
            and h.cod_abi = v_cod_abi
            and h.id_dper = v_id_dper
            and h.cod_esito = '00'
    );


    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Aggiornata ' || v_count || ' T_MCRES_APP_SP_SPESE con spese contabilizzate'
                                    );


    v_note := ' MERGE T_MCRES_APP_SP_CONTROPARTITA';

    merge into t_mcres_app_sp_contropartita t
    using
    (
        select
            cod_autorizzazione,
            cod_risorsa_ope,
            dta_solar_ope,
            cod_ope_fattib,
            cod_progr_oper
        from
            t_mcres_app_host_speseitf
        where 0=0
            and cod_abi = v_cod_abi
            and id_dper = v_id_dper
        and cod_esito = '00'
    ) s
    on
    (
        s.cod_autorizzazione = t.cod_autorizzazione
    )
    when matched then update
    set
        t.val_nuova_operazione  = s.cod_risorsa_ope,
        t.dta_solare_operazione = s.dta_solar_ope,
        t.cod_operazione_fatt   = s.cod_ope_fattib,
        t.cod_progr_operazione  = s.cod_progr_oper,
        t.dta_upd = sysdate;


    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Aggiornata ' || v_count || ' T_MCRES_APP_SP_SPESE con spese contabilizzate'
                                    );



    v_note := 'Merge T_MCRES_APP_SPESE_ITF per record HOST validi';

    merge into t_mcres_app_spese_itf t
    using
    (
     select
            id_dper,
            cod_abi,
            cod_autorizzazione,
            cod_esito
        from
            t_mcres_app_host_speseitf
        where 0=0
            and id_dper = v_id_dper
            and cod_abi = v_cod_abi
    ) s
    on
    (
        s.cod_autorizzazione = t.cod_autorizzazione
    )
    when matched then
    update set
        t.flg_ricevuto_esito_contabil = decode(s.cod_esito, '00', 1, -1),
        t.dta_ricezione_esito_contabil = sysdate,
        t.dta_upd = sysdate
    where 0=0
        and t.flg_inviata_per_contabil = 1
        and t.flg_ricevuto_esito_contabil = 0
        and t.cod_autorizzazione = s.cod_autorizzazione --per sfruttare pk di t_mcres_app_spese_itf
        and t.cod_abi = s.cod_abi;



    v_note := 'Update T_MCRES_APP_SPESE_ITF per record non validi';

    update t_mcres_app_spese_itf t
    set
        t.flg_ricevuto_esito_contabil   = -1,
        t.dta_ricezione_esito_contabil  = sysdate,
        t.dta_upd = sysdate
    where 0=0
        and flg_inviata_per_contabil = 1
        and flg_ricevuto_esito_contabil = 0
        and exists
        (
            select 1
            from
            (
                select cod_autorizzazione
                from t_mcres_sc_vincoli_host_sp_itf
                where id_flusso = v_id_flusso
                union all
                select cod_autorizzazione
                from t_mcres_sc_convert_host_sp_itf
                where id_flusso = v_id_flusso
            ) u
            where t.cod_autorizzazione = u.cod_autorizzazione
        );

        pkg_mcres_audit.log_caricamenti (
                                            p_id_flusso => v_id_flusso,
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_debug,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'Aggiornata ' || v_count || ' T_MCRES_APP_SPESE_ITF con flusso di ritorno da HOST'
                                        );

    commit;

    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_caricamenti (
                                            p_id_flusso => v_id_flusso,
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_error,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'GENERALE: ' || v_note
                                        );

        rollback;

        return c_ko;

end;



function fnc_popola_documenti
(
    p_id_object          in t_mcres_app_documenti.id_object%type,
    p_cod_abi            in t_mcres_app_documenti.cod_abi%type,
    p_cod_ndg            in t_mcres_app_documenti.cod_ndg%type,
    p_cod_pratica        in t_mcres_app_documenti.cod_pratica%type,
    p_val_anno_pratica   in t_mcres_app_documenti.val_anno_pratica%type,
    p_cod_aut_protoc     in t_mcres_app_documenti.cod_aut_protoc%type,
    p_cod_identificativo in t_mcres_app_documenti.cod_identificativo%type,
    p_cod_tipo_del_spesa in t_mcres_app_documenti.cod_tipo_del_spesa%type,
    p_cod_tipo_documento in t_mcres_app_documenti.cod_tipo_documento%type,
    p_cod_progressivo    in t_mcres_app_documenti.cod_progressivo%type,
    p_cod_stato          in t_mcres_app_documenti.cod_stato%type,
    p_cod_origine        in t_mcres_app_documenti.cod_origine%type,
    p_val_doc_name       in t_mcres_app_documenti.val_doc_name%type,
    p_cod_utente         in t_mcres_wrk_audit_applicativo.utente%type       default null
)
return number
is
pragma autonomous_transaction;

    c_nome      constant varchar2(61)   :=  c_package || '.FNC_POPOLA_DOCUMENTI';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;

    v_return    number;



begin

    v_note := 'Call PKG_MCRES_FUNZIONI_PORTALE.FNC_MCRES_POPOLA_DOCUMENTI';

    v_return := PKG_MCRES_FUNZIONI_PORTALE.FNC_MCRES_POPOLA_DOCUMENTI(
                                                                        p_id_object          => p_id_object,
                                                                        p_cod_abi            => p_cod_abi,
                                                                        p_cod_ndg            => p_cod_ndg,
                                                                        p_cod_pratica        => p_cod_pratica,
                                                                        p_val_anno_pratica   => p_val_anno_pratica,
                                                                        p_cod_aut_protoc     => p_cod_aut_protoc,
                                                                        p_cod_identificativo => p_cod_identificativo,
                                                                        p_cod_tipo_del_spesa => p_cod_tipo_del_spesa,
                                                                        p_cod_tipo_documento => p_cod_tipo_documento,
                                                                        p_cod_progressivo    => p_cod_progressivo,
                                                                        p_cod_stato          => p_cod_stato,
                                                                        p_cod_origine        => p_cod_origine,
                                                                        p_val_doc_name       => p_val_doc_name,
                                                                        p_cod_utente         => p_cod_utente
                                                                    );

    if v_return <> c_ok
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore PKG_MCRES_FUNZIONI_PORTALE.FNC_MCRES_POPOLA_DOCUMENTI',
                                    p_utente    => nvl(p_cod_utente, 'JOB_SP_ITF')
                                );


        rollback;

        return c_ko;


    end if;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Inserito documento COD_ABI = ' || p_cod_abi || ', COD_NDG = ' || p_cod_ndg || ', ID_OBJECT = ' || p_id_object,
                                p_utente    => nvl(p_cod_utente, 'JOB_SP_ITF')
                            );

    commit;

    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => nvl(p_cod_utente, 'JOB_SP_ITF')
                                );

        rollback;

        return c_ko;

end;


--aggionna flg e data caricamento su T_MCRES_APP_SPESE_ITF
function fnc_aggiorna_pdf_caricati
return number
is

    c_nome      constant varchar2(61)   :=  c_package || '.FNC_AGGIORNA_PDF_CARICATI';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;

    v_count     number;



begin

    v_note := 'Update T_MCRES_APP_SPESE_ITF per aggiornamento flag e data caricamento PDF';

    update t_mcres_app_spese_itf t
    set
        t.flg_docs_archiviati = 1,
        t.dta_archiviazione_docs = sysdate
    where 0=0
        and t.flg_docs_archiviati = 0   -- teoricamente pleonastico
        and cod_autorizzazione in
        (
            select
                app.cod_autorizzazione
            from
                t_mcres_app_spese_itf app
            where 0=0
                and exists  --controllo esistenza pdf fattura
                (
                    select 1
                    from t_mcres_app_documenti d1
                    where 0=0
                        and d1.cod_aut_protoc =  app.cod_autorizzazione
                        and d1.cod_abi = app.cod_abi
                        and d1.cod_ndg = app.cod_ndg
                        and d1.cod_tipo_documento = 'DO'
                )
                and exists --controllo esistenza pdf nulla osta
                (
                    select 1    -- se stato = 'P' il nulla osta deve essere presente
                    from t_mcres_app_documenti d2
                    where 0=0
                        and d2.cod_aut_protoc = app.cod_autorizzazione
                        and d2.cod_abi = app.cod_abi
                        and d2.cod_ndg = app.cod_ndg
                        and d2.cod_tipo_documento = 'AL'
                        and app.cod_stato != 'P'
                    union all
                    select 1    -- se stato =! 'P' il nulla osta non deve necessariamente essere presente
                    from dual
                    where app.cod_stato = 'P'
                )
    );

    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Aggiornata T_MCRES_APP_SPESE_ITF. Processate ' || v_count || ' righe',
                                p_utente    => 'JOB_SP_ITF'
                            );

    commit;

    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;

function fnc_popola_esiti_caricamento
(
    p_rec in f_slave_par_type
)
return number
is

    c_nome      constant varchar2(61)   :=  c_package || '.FNC_POPOLA_ESITI_CARICAMENTO';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;

    v_count     number;
    v_id_lotto  varchar2(8);



begin

    v_note := 'Valorizzazione ID_LOTTO';

    v_id_lotto  := to_char(p_rec.periodo, 'yyyymmdd');


    v_note := 'Delete T_MCRES_APP_ESITI_SPESE_ITF'; -- in caso di rilancio elimina le spese precedenemente caricate

    delete t_mcres_app_esiti_spese_itf e
    where 0=0
        and cod_source = 'ITF'
        and id_lotto = v_id_lotto
        and exists
        (
            select 1
            from t_mcres_wrk_cod_aut_spese_itf w
            where w.cod_autorizzazione = e.cod_autorizzazione
        );


    v_note := 'Insert T_MCRES_APP_ESITI_SPESE_ITF';

    insert
    into t_mcres_app_esiti_spese_itf
    (
        id_lotto,
        cod_source,
        id_dper,
        id_esito,
        desc_esito,
        cod_autorizzazione,
        cod_abi,
        cod_ndg,
        cod_autorizzazione_padre,
        val_anno_pratica,
        cod_pratica,
        cod_stato,
        val_numero_fattura,
        dta_fattura
    )
    select
        v_id_lotto,
        cod_source,
        id_dper,
        id_esito,
        desc_esito,
        cod_autorizzazione,
        cod_abi,
        cod_ndg,
        cod_autorizzazione_padre,
        val_anno_pratica,
        cod_pratica,
        cod_stato,
        val_numero_fattura,
        dta_fattura
    from
        v_mcres_wrk_esiti_load_sp_itf;


    commit;

    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;

function fnc_reload_alert_forntori
(
    p_rec   in f_slave_par_type default null
)
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_RELOAD_ALERT_FORNTORI';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_flg_attiva    t_mcres_wrk_alimentazione_fen.flg_attiva%type;
    v_delete        t_mcres_wrk_alimentazione_fen.val_del_qry%type;
    v_insert        t_mcres_wrk_alimentazione_fen.val_ins_query%type;

    v_dummy         varchar2(1);
    v_id_alert      varchar2(3);



begin

    v_note := 'Recupero insert da T_MCRES_WRK_ALIMENTAZIONE_FEN';

    select
        flg_attiva,
        val_del_qry,
        val_ins_query
    into
        v_flg_attiva,
        v_delete,
        v_insert
    from t_mcres_wrk_alimentazione_fen
    where 0=0
        and replace(upper(flg_gruppo), ' ', '') like '%ALERT=23%'
        and val_tbl_name = 'T_MCRES_FEN_ALERT_POS';

    if v_flg_attiva = 1
    then

        v_note := 'Esecuzione delete';

        execute immediate v_delete using v_dummy;


        v_note := 'Esecuzione insert';

        execute immediate v_insert using v_dummy;

        commit;

    else

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_warning,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Alert non attivo',
                                    p_utente    => 'JOB_SP_ITF'
                                );

    end if;

    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;



--
function fnc_insert_wrk_pdf
(
    p_cod_societa_sap          in t_mcres_wrk_pdf_from_doc.cod_societa_sap%type,
    p_cod_abi                  in t_mcres_wrk_pdf_from_doc.cod_abi%type,
    p_cod_ndg                  in t_mcres_wrk_pdf_from_doc.cod_ndg%type,
    p_cod_autorizzazione       in t_mcres_wrk_pdf_from_doc.cod_autorizzazione%type,
    p_cod_autorizzazione_padre in t_mcres_wrk_pdf_from_doc.cod_autorizzazione_padre%type,
    p_cod_progressivo          in t_mcres_wrk_pdf_from_doc.cod_progressivo%type,
    p_id_object                in t_mcres_wrk_pdf_from_doc.id_object%type,
    p_val_doc_name             in t_mcres_wrk_pdf_from_doc.val_doc_name%type,
    p_doc_content              in t_mcres_wrk_pdf_from_doc.doc_content%type,
    p_cod_utente               in t_mcres_wrk_audit_applicativo.utente%type default null
)
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_INSERT_WRK_PDF';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_dummy         varchar2(1);

begin

    v_note := 'Inserimento documento avente ID_OBJECT = ' || p_id_object;

    insert into t_mcres_wrk_pdf_from_doc
    (
        cod_societa_sap,
        cod_abi,
        cod_ndg,
        cod_autorizzazione,
        cod_autorizzazione_padre,
        cod_progressivo,
        id_object,
        val_doc_name,
        doc_content
    )
    values
    (
        p_cod_societa_sap,
        p_cod_abi,
        p_cod_ndg,
        p_cod_autorizzazione,
        p_cod_autorizzazione_padre,
        p_cod_progressivo,
        p_id_object,
        p_val_doc_name,
        p_doc_content
    );

    commit;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Inserito documento avente ID_OBJECT = ' || p_id_object,
                                p_utente    => nvl(p_cod_utente, 'JOB_SP_ITF')
                            );


    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;


---genera file leggendo da vista
/*
   INPUT:
                p_view          vista da cui leggere il record _l_i_n_e_ per creare il file
                p_file_name     nome del file
                p_dir           nome della directory Oracle in cui depoistare il file
*/
function fnc_genera_file
(
    p_view      in varchar2,
    p_file_name in varchar2,
    p_dir       in varchar2 default 'D_MCRES_WORK'
)
return number
is

    pragma autonomous_transaction;

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_GENERA_FILE';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_stmt          varchar2(32767);

begin

    v_note := 'Genera file' || p_file_name;

    v_stmt := '
    declare
        v_outfile       utl_file.file_type;
    begin
        v_outfile   := utl_file.fopen (''' || upper(p_dir) || ''', ''' || p_file_name || ''', ''w'');
        for r in (select line from ' || upper(p_view) || ')
        loop
            utl_file.put_line (v_outfile, r.line, false);
            utl_file.fflush (v_outfile);
        end loop;

        utl_file.fclose (v_outfile);
    end;';

    execute immediate v_stmt;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Generato file ' || p_file_name,
                                p_utente    => 'JOB_SP_ITF'
                            );
    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );


        return c_ko;

end;


function fnc_avvia_QUARTZ
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_AVVIA_QUARTZ';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;


begin

    v_note := 'Aggiornamento T_MCRES_WRK_CONFIGURAZIONE';

   update t_mcres_wrk_configurazione
   set valore_costante = 1
   where upper(nome_costante) = 'STATO_QUARTZ';

   commit;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Aggiornata T_MCRES_WRK_CONFIGURAZIONE con STATO_QUARTZ = 1' ,
                                p_utente    => 'JOB_SP_ITF'
                            );
    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;



function fnc_spegni_QUARTZ
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_SPEGNI_QUARTZ';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;


begin

    v_note := 'Aggiornamento T_MCRES_WRK_CONFIGURAZIONE';

   update t_mcres_wrk_configurazione
   set valore_costante = 0
   where upper(nome_costante) = 'STATO_QUARTZ';

   commit;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Aggiornata T_MCRES_WRK_CONFIGURAZIONE con STATO_QUARTZ = 0' ,
                                p_utente    => 'JOB_SP_ITF'
                            );
    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;



---
function fnc_can_QUARTZ_run
return number
is
pragma autonomous_transaction;

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_QUARTZ_CAN_RUN';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_valore        t_mcres_wrk_configurazione.valore_costante%type;



begin

    v_note := 'Lock riga corrispondete al gestore del semaforo su T_MCRES_WRK_CONFIGURAZIONE';

    update t_mcres_wrk_configurazione
    set valore_costante = valore_costante
    where nome_costante = 'DUMMY_QUARTZ';

    v_note := 'Recupero valore del semaforo';

    select valore_costante
    into v_valore
    from t_mcres_wrk_configurazione
    where nome_costante = 'STATO_QUARTZ';


    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Interrogato stato QUARTZ. Ottenuto: ' || v_valore,
                                p_utente    => 'JOB_SP_ITF'
                            );

    if v_valore = 1
    then

        v_note := 'Aggiornamento valore da T_MCRES_WRK_CONFIGURAZIONE';

        update t_mcres_wrk_configurazione
        set valore_costante = '0'
        where nome_costante = 'STATO_QUARTZ';

        commit;

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Aggiornata T_MCRES_WRK_CONFIGURAZIONE con STATO_QUARTZ = 0',
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ok;

    else

        commit;

        return c_ko;    -- NON vuol dire errore ma solo che non si deve avviare il job

    end if;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

end;
--


--
function fnc_abilita_LAST_STEP
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_ABILITA_LAST_STEP';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;


begin

    v_note := 'Aggiornamento T_MCRES_WRK_CONFIGURAZIONE';

    update t_mcres_wrk_configurazione
    set valore_costante = 1
    where upper(nome_costante) = 'STATO_SEND_TO_SAP';

    commit;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Aggiornata T_MCRES_WRK_CONFIGURAZIONE con STATO_SEND_TO_SAP = 1' ,
                                p_utente    => 'JOB_SP_ITF'
                            );
    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;



--
function fnc_aggiorna_fornitori_sp_itf
(
    p_rec f_slave_par_type
)
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_AGGIORNA_FORNITORI_SP_ITF';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_id_flusso     number;
    v_count         number;

begin

    v_id_flusso := p_rec.seq_flusso;


    v_note := 'Aggiornamento T_MCRES_APP_SPESE_ITF';

    update t_mcres_app_spese_itf s
    set
        flg_fornitore_non_censito = 0,
        -- AP 10072013
        dta_attesa = null,
        --
        dta_upd = sysdate
    where 0=0
        and flg_fornitore_non_censito != 0
        /*and exists
        (
            select 1
            from
                t_mcres_app_fornitori f,
                t_mcres_cl_sap cl
            where 0=0
                and f.cod_societa = cl.cod_societa
                and nvl(f.val_partita_iva, f.val_codice_fiscale) = s.desc_cfpiva_legale
                and s.cod_abi = cl.cod_abi  -- fornitore deve esssre censito per il dato istituto
        )*/
        and exists
        (
            select 1
            from
                t_mcres_app_fornitori f,
                t_mcres_cl_sap cl
            where 0=0
                and f.cod_societa = cl.cod_societa
                and f.val_partita_iva = s.val_afavore_piva
                and s.cod_abi = cl.cod_abi  -- fornitore deve esssre censito per il dato istituto
                and f.val_partita_iva is not null
                and s.val_afavore_piva is not null
             UNION
            select 1
            from
                t_mcres_app_fornitori f,
                t_mcres_cl_sap cl
            where 0=0
                and f.cod_societa = cl.cod_societa
                and f.val_codice_fiscale = s.val_afavore_codfisc
                and s.cod_abi = cl.cod_abi  -- fornitore deve esssre censito per il dato istituto
                and f.val_codice_fiscale is not null
                and s.val_afavore_codfisc is not null
        );

    v_count := SQL%ROWCOUNT;

    commit;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Aggiornate ' || v_count || ' spese sulla T_MCRES_APP_SPESE_ITF'
                                    );

    return c_ok;


exception
when others
then

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'GENERALE: ' || v_note
                                    );

    rollback;

    return c_ko;

end;


-- rimuove dai flussi AZIONI, CONTROPARTITE, RAPPORTI, FATTURE record validi ma relativi a spese scartate
function fnc_rimuovi_scarti
(
    p_rec f_slave_par_type
)
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_RIMUOVI_SCARTI';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_id_flusso     number;
    v_id_dper       number(8);
    v_count         number;

begin

    v_id_flusso := p_rec.seq_flusso;
    v_id_dper   := to_char(p_rec.periodo, 'yyyymmdd');


    v_note := 'Aggiornamento T_MCRES_APP_AZIONI_ITF';


    delete t_mcres_app_azioni_itf t
    where 0=0
    and id_dper = v_id_dper
    and exists
    (
        select 1
        from t_mcres_wrk_sc_etl_spese_itf w
        where t.cod_autorizzazione = w.cod_autorizzazione
    );

    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Eliminati ' || v_count || ' record sulla T_MCRES_APP_AZIONI_ITF'
                                    );



    v_note := 'Aggiornamento T_MCRES_APP_CONTROPARTITE_ITF';


    delete t_mcres_app_contropartite_itf t
    where 0=0
    and id_dper = v_id_dper
    and exists
    (
        select 1
        from t_mcres_wrk_sc_etl_spese_itf w
        where t.cod_autorizzazione = w.cod_autorizzazione
    );

    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Eliminati ' || v_count || ' record sulla T_MCRES_APP_CONTROPARTITE_ITF'
                                    );


    v_note := 'Aggiornamento T_MCRES_APP_RAPPORTI_ITF';


    delete t_mcres_app_rapporti_itf t
    where 0=0
    and id_dper = v_id_dper
    and exists
    (
        select 1
        from t_mcres_wrk_sc_etl_spese_itf w
        where t.cod_autorizzazione = w.cod_autorizzazione
    );

    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Eliminati ' || v_count || ' record sulla T_MCRES_APP_RAPPORTI_ITF'
                                    );



    v_note := 'Aggiornamento T_MCRES_APP_FATTURE_ITF';


    delete t_mcres_app_fatture_itf t
    where 0=0
    and id_dper = v_id_dper
    and exists
    (
        select 1
        from t_mcres_wrk_sc_etl_spese_itf w
        where t.cod_autorizzazione = w.cod_autorizzazione
    );

    v_count := SQL%ROWCOUNT;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Eliminati ' || v_count || ' record sulla T_MCRES_APP_FATTURE_ITF'
                                    );

    commit;

    return c_ok;


exception
when others
then

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'GENERALE: ' || v_note
                                    );

    rollback;

    return c_ko;

end;



function fnc_genera_flusso_calcolo_uo
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_GENERA_FLUSSO_CALCOLO_UO';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_nome_file     t_mcres_wrk_configurazione.valore_costante%type;
    v_esito         number;
    v_count         number;

begin

    v_note  := 'Recupero nome file da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_nome_file
    from t_mcres_wrk_configurazione
    where nome_costante = 'FILE_CALCOLO_UO_SP_ITF';


    v_note  := 'CALL funzione di creazione flusso';

    v_esito := fnc_genera_file( 'V_MCRES_WRK_TO_CALC_UO_SP_ITF' , v_nome_file);

    if v_esito = c_ko
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'ERRORE nella generazione del file ' || v_nome_file,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    end if;



     --AP 29/05/2013 COMMENTATA FLAGGATURA INVIATO E AGGIUNTA NUOVA CHIAMATA POPOLA SENT

    v_note  := 'SET spese da inviare';

    v_esito := fnc_popola_sent('V_MCRES_WRK_TO_CALC_UO_SP_ITF','TO_JUS0_SPESEITF');


    /*v_note  := 'Aggiornamento flg_inviata_per_calc_uo_od su T_MCRES_APP_SPESE_ITF';

    update t_mcres_app_spese_itf app
    set
        flg_inviata_per_calc_uo_od  = 1,
        dta_invio_per_calc_uo_od    = sysdate,
        dta_upd                     = sysdate
    where exists
        (
            select 1
            from    --stesse condizioni della vista V_MCRES_WRK_TO_CALC_UO_SP_ITF (a meno della outer join)
                t_mcres_app_spese_itf s,
                t_mcres_app_rapporti_itf r,
                t_mcres_app_pratiche p,
                t_mcres_app_contropartite_itf c
            where 0=0
                and app.cod_autorizzazione = s.cod_autorizzazione
                -- condizioni di join della vista
                and s.cod_autorizzazione = r.cod_autorizzazione(+)
                and s.cod_abi = p.cod_abi
                and s.cod_ndg = p.cod_ndg
                and s.val_anno_pratica = p.val_anno
                and s.cod_pratica = p.cod_pratica
                --and p.flg_attiva = 1
                and s.cod_autorizzazione = c.cod_autorizzazione
                ---
                and flg_inviata_per_calc_uo_od= 0
                and flg_fornitore_non_censito = 0
                -- AP 17/05/2013
                and flg_docs_archiviati = 1
                --filtro di sicurezza
                and s.cod_tipo_autorizzazione != '5'
        );

    v_count := SQL%ROWCOUNT;

    commit;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Aggiornati ' || v_count || ' record su T_MCRES_APP_SPESE_ITF. Impostato FLG_INVIATA_PER_CALC_UO_OD = 1',
                                p_utente    => 'JOB_SP_ITF'
                            );*/
    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;



---
function fnc_genera_flusso_postLoad_itf
--(
--    p_id_lotto  in  t_mcres_app_esiti_spese_itf.id_lotto%type
--)
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_GENERA_FLUSSO_POSTLOAD_ITF';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_nome_file     t_mcres_wrk_configurazione.valore_costante%type;
    v_dir           t_mcres_wrk_configurazione.valore_costante%type;
    v_esito         number;
    v_count         number;

begin

    v_note  := 'Recupero nome file da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_nome_file
    from t_mcres_wrk_configurazione
    where nome_costante = 'FILE_ESITI_PL_SP_ITF';

    v_note  := 'Recupero nome file da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_dir
    from t_mcres_wrk_configurazione
    where nome_costante = 'DIRECTORY_ESITI_SPESEITF';


    v_note  := 'CALL funzione di creazione flusso';

--    dbms_application_info.set_client_info( p_id_lotto );

    -- call
    v_esito := fnc_genera_file( 'V_MCRES_WRK_SPL_PLOAD_SP_ITF' , v_nome_file, v_dir);

    if v_esito = c_ko
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'ERRORE nella generazione del file ' || v_nome_file,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    end if;


    v_note  := 'Aggiornamento flg_inviata_per_calc_uo_od su T_MCRES_APP_SPESE_ITF';

    update t_mcres_app_spese_itf app
    set
        flg_inviata_itf_post_load   = 1,
        dta_invio_itf_post_load     = sysdate,
        dta_upd                     = sysdate
    where 0=0
        and flg_inviata_itf_post_load   = 0
        and exists
        (
            select 1
            from t_mcres_app_esiti_spese_itf e
            where 0=0
                and e.cod_autorizzazione = app.cod_autorizzazione
                and flg_inviato = 0
                and cod_source = 'ITF'
--                and id_lotto = p_id_lotto
        );

    v_count := SQL%ROWCOUNT;

    commit;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Aggiornati ' || v_count || ' record su T_MCRES_APP_SPESE_ITF. Impostato FLG_INVIATA_PER_CALC_UO_OD = 1',
                                p_utente    => 'JOB_SP_ITF'
                            );




    v_note  := 'Aggiornamento flg_inviato su T_MCRES_APP_ESITI_SPESE_ITF';

    update t_mcres_app_esiti_spese_itf
    set
        flg_inviato = 1,
        dta_invio   = sysdate,
        dta_upd     = sysdate
    where 0=0
        and flg_inviato = 0
        and cod_source = 'ITF';
--        and id_lotto = p_id_lotto;

    v_count :=SQL%ROWCOUNT;

    commit;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Aggiornati ' || v_count || ' record su T_MCRES_APP_ESITI_SPESE_ITF. Impostato FLG_INVIATO = 1',
                                p_utente    => 'JOB_SP_ITF'
                            );


    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;


function fnc_genera_flusso_pLoad_jus0
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_GENERA_FLUSSO_PLOAD_JUS0';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_nome_file     t_mcres_wrk_configurazione.valore_costante%type;
    v_esito         number;
    v_count         number;

begin

    v_note  := 'Recupero nome file da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_nome_file
    from t_mcres_wrk_configurazione
    where nome_costante = 'FILE_ESITI_POST_JUS0_SPESEITF';


    v_note  := 'CALL funzione di creazione flusso';

    v_esito := fnc_genera_file( 'V_MCRES_WRK_SPL_PLOAD_JUS0_ITF' , v_nome_file);

    if v_esito = c_ko
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'ERRORE nella generazione del file ' || v_nome_file,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    end if;


    v_note  := 'Aggiornamento FLG_INVIO_DEFINIT_ITF su T_MCRES_APP_SPESE_ITF';

    update t_mcres_app_spese_itf app
    set
        flg_invio_definit_itf       = 1,
        dta_invio_definit_itf       = sysdate,
        dta_upd                     = sysdate
    where 0=0
        and flg_invio_definit_itf   = 0
        and exists
        (
            select 1
            from t_mcres_app_esiti_spese_itf e
            where 0=0
                and e.cod_autorizzazione = app.cod_autorizzazione
                and flg_inviato = 0
                and cod_source in ('HST', 'INT')
        );

    v_count := SQL%ROWCOUNT;

    commit;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Aggiornati ' || v_count || ' record su T_MCRES_APP_SPESE_ITF. Impostato FLG_INVIO_DEFINIT_ITF = 1',
                                p_utente    => 'JOB_SP_ITF'
                            );




    v_note  := 'Aggiornamento flg_inviato su T_MCRES_APP_ESITI_SPESE_ITF';

    update t_mcres_app_esiti_spese_itf
    set
        flg_inviato = 1,
        dta_invio   = sysdate,
        dta_upd     = sysdate
    where 0=0
        and flg_inviato = 0
        and cod_source in ('HST', 'INT');

    v_count :=SQL%ROWCOUNT;

    commit;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Aggiornati ' || v_count || ' record su T_MCRES_APP_ESITI_SPESE_ITF. Impostato FLG_INVIO_DEFINIT_ITF = 1',
                                p_utente    => 'JOB_SP_ITF'
                            );


    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;



---
function fnc_genera_flussi_per_host
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_GENERA_FLUSSI_PER_HOST';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_nome_file     t_mcres_wrk_configurazione.valore_costante%type;
    v_return        number;
    v_count         number;
    v_dir           varchar2(50);

    cursor c_abi
    is
        select cod_abi
        from t_mcres_app_istituti
        where flg_target = 'Y';

begin

    v_note  := 'Recupero nome file da T_MCRES_WRK_CONFIGURAZIONE';


    select valore_costante
    into v_nome_file
    from t_mcres_wrk_configurazione
    where nome_costante = 'FILE_CONTABILIZZAZIONE_SP_ITF';

    v_note  := 'Recupero directory da T_MCRES_WRK_CONFIGURAZIONE';


    select valore_costante
    into v_dir
    from t_mcres_wrk_configurazione
    where nome_costante = 'TO_HOST_DIRECTORY';


    v_count := 0;

    for r in c_abi
    loop

        v_note  := 'Creazione del  file ' || v_nome_file || '.' ||  r.cod_abi;

        dbms_application_info.set_client_info(r.cod_abi);

        v_return := fnc_genera_file( 'V_MCRES_WRK_TO_CONT_SP_ITF', v_nome_file || '.' ||  r.cod_abi, v_dir);

        if v_return = c_ok
        then

            v_count := v_count + 1;

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Generato file ' || v_nome_file || '.' ||  r.cod_abi,
                                        p_utente    => 'JOB_SP_ITF'
                                    );

        --AP 29/05/2013 COMMENTATA FLAGGATURA INVIATO E AGGIUNTA NUOVA CHIAMATA POPOLA SENT

        v_note  := 'SET spese da inviare';

        v_return := fnc_popola_sent('V_MCRES_WRK_TO_CONT_SP_ITF','TO_HOST_SPESEITF');

           /* update t_mcres_app_spese_itf s
            set
                s.flg_inviata_per_contabil = 1,
                s.dta_invio_per_contabil = sysdate
            where 0=0
                and s.cod_abi = r.cod_abi
                and s.flg_inviata_per_contabil = 0
                and s.flg_fornitore_non_censito = 0
                and s.flg_inviata_per_calc_uo_od = 1
                and s.flg_calcolato_uo_od = 1
                and s.flg_docs_archiviati = 1
                and s.flg_inviata_itf_post_load = 1
                and s.flg_inserita_sp_spese = 1;

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Aggiornata  T_MCRES_APP_SPESE_ITF per ABI = ' ||  r.cod_abi,
                                        p_utente    => 'JOB_SP_ITF'
                                    );*/


        end if;

    end loop;

    commit;


    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Numero file elaborati: ' || v_count,
                                p_utente    => 'JOB_SP_ITF'
                            );


    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;



function fnc_last_step
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_LAST_STEP';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_file_name     t_mcres_wrk_configurazione.valore_costante%type;
    v_dir           t_mcres_wrk_configurazione.valore_costante%type;
    v_return        number;



begin

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'INIZIO - FNC_LAST_STEP',
                                p_utente    => 'JOB_SP_ITF'
                            );


    v_note := 'Creazione flusso ESITI2_SPESEITF';


    --call
    v_return := fnc_genera_flusso_esiti2;

    if v_return <> c_ok
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore nella funzione FNC_GENERA_FLUSSO_ESITI2',
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    else

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Generato file ESITI2',
                                    p_utente    => 'JOB_SP_ITF'
                                );

    end if;

-- Inizio Azioni Giudiziarie

    v_note := 'Recupero nome file azioni giudiziarie da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_file_name
    from t_mcres_wrk_configurazione
    where nome_costante = 'FILE_AZIONI_GIUDIZIARIE';


    v_note := 'Recupero nome directory in cui depositare le azioni giudiziarie da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_dir
    from t_mcres_wrk_configurazione
    where nome_costante = 'DIRECTORY_AZIONI_GIUDIZIARIE';



    v_note := 'Creazione flusso AZIONI GIUDIZIARIE';


    --call
    v_return := fnc_genera_file('V_MCRES_WRK_SPL_AZIONIGIUD_ITF', v_file_name, v_dir);

    if v_return <> c_ok
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore nella generazione del file ' || v_file_name,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

    else

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Generato file ' || v_file_name,
                                    p_utente    => 'JOB_SP_ITF'
                                );

    end if;

-- Fine Azioni Giudiziarie

    v_note := 'Creazione flussi TO_HOST';


    --call
    v_return := fnc_genera_flussi_per_host;

    if v_return <> c_ok
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore nella funzione FNC_GENERA_FLUSSI_PER_HOST',
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

    else

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Generati i file TO_HOST_SPESEITF',
                                    p_utente    => 'JOB_SP_ITF'
                                );

    end if;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'FINE - FNC_LAST_STEP',
                                p_utente    => 'JOB_SP_ITF'
                            );

    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

end;


function fnc_genera_flusso_esiti2
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_GENERA_ESITI2';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_file_name     t_mcres_wrk_configurazione.valore_costante%type;
    v_dir           t_mcres_wrk_configurazione.valore_costante%type;
    v_return        number;



begin

    v_note := 'Recupero costanti da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_file_name
    from t_mcres_wrk_configurazione
    where nome_costante = 'FILE_CONFERMA_SPESE_ITF';

    select valore_costante
    into v_dir
    from t_mcres_wrk_configurazione
    where nome_costante = 'DIRECTORY_CONFERMA_SPESE_ITF';



    v_note := 'Inserimento in T_MCRES_APP_ESITI_SPESE_ITF';

    insert into t_mcres_app_esiti_spese_itf
    (
        id_lotto,
        cod_source,
        id_dper,
        id_esito,
        desc_esito,
        cod_autorizzazione,
        cod_abi,
        cod_ndg,
        cod_autorizzazione_padre,
        val_anno_pratica,
        cod_pratica,
        cod_stato,
        val_numero_fattura,
        dta_fattura
    )
    select
        s.id_dper id_lotto,
        'INT' cod_source,
        to_char(sysdate, 'yyyymmdd') id_dper,
        decode(sp.cod_stato, 'CO', '01', 'AN', '03') id_esito,
        decode(sp.cod_stato, 'CO', 'Acquisita e confermata da UffInterfaccia', 'AN', 'Acquisita e rifiutata da UffInterfaccia') desc_esito,
        s.cod_autorizzazione,
        s.cod_abi,
        s.cod_ndg,
        s.cod_autorizzazione_padre,
        s.val_anno_pratica,
        s.cod_pratica,
        s.cod_stato,
        s.val_numero_fattura,
        s.dta_fattura
    from
        t_mcres_app_spese_itf s,
        t_mcres_app_sp_spese sp
    where 0=0
        and s.cod_autorizzazione = sp.cod_autorizzazione
        and s.flg_inserita_sp_spese = 1
        and s.flg_invio_definit_itf = 0
        and sp.flg_source = 'ITF'
        and sp.cod_stato in ('AN','CO')
        and s.cod_uo_calcolato = '06472';

    commit;

    v_note := 'Creazione file esiti2 ITF';

    --call
    v_return := fnc_genera_file('V_MCRES_WRK_SPL_PLOAD_JUS0_ITF', v_file_name, v_dir);

    -- se la generazione del file non va a buon fine elimino i record inseriti (per poter rilanciare l'applicazione)
    if v_return <> c_ok
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore nella generazione del file ' || v_file_name,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        delete t_mcres_app_esiti_spese_itf e
        where 0=0
            and cod_source = 'INT'
            and exists
            (
                select 1
                from
                    t_mcres_app_spese_itf s,
                    t_mcres_app_sp_spese sp
                where 0=0
                    and s.cod_autorizzazione = e.cod_autorizzazione
                    and s.cod_autorizzazione = sp.cod_autorizzazione
                    and s.flg_inserita_sp_spese = 1
                    and s.flg_invio_definit_itf = 0
                    and sp.flg_source = 'ITF'
                    and sp.cod_stato in ('AN','CO')
                    and s.cod_uo_calcolato = '06472'
            );


        commit;

        return c_ko;

    else

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Generato file ' || v_file_name,
                                    p_utente    => 'JOB_SP_ITF'
                                );

    end if;


    v_note := 'Aggiornamento T_MCRES_APP_SPESE_ITF per record inviati a ITF nel flusso ESITI2';

    update t_mcres_app_spese_itf app
    set
        app.flg_invio_definit_itf = 1,
        app.dta_invio_definit_itf = sysdate,
        app.dta_upd = sysdate
    where 0=0
        and flg_invio_definit_itf = 0
        and exists
        (
            select 1
            from t_mcres_app_esiti_spese_itf e
            where 0=0
                and e.cod_autorizzazione = app.cod_autorizzazione
                and cod_source in ('HST', 'INT')
                and flg_inviato = 0
        )
        --AP 2013/09/02 -- Fa in modo che non metta le TR a esito2 definitivo
        and not exists
        (select 1
            from t_mcres_app_sp_spese sp
            join t_mcres_app_spese_itf itf on sp.cod_autorizzazione = itf.cod_autorizzazione
            where 0 = 0
            and app.cod_autorizzazione = sp.cod_autorizzazione
            and sp.cod_stato = 'TR'
            and itf.cod_uo_calcolato = '06472');


    v_note := 'Aggiornamento T_MCRES_APP_ESITI_SPESE_ITF per record inviati a ITF nel flusso ESITI2';

    update t_mcres_app_esiti_spese_itf
    set
        flg_inviato = 1,
        dta_invio = sysdate,
        dta_upd = sysdate
    where 0=0
        and cod_source in ('HST', 'INT')
        and flg_inviato = 0;


    commit;

    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;




function fnc_write_blob_into_dir
(
    p_name      varchar2,
    p_blob      blob,
    p_dir       varchar2
)
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_WRITE_BLOB_INTO_DIR';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_wrote         number  := 0;
    v_size          number;
    v_buffer_size   number  := 32760;
    v_raw           raw(32760);
    v_file          utl_file.file_type;



begin

    v_file := utl_file.fopen(p_dir, p_name, 'wb', 32760);

    v_size := dbms_lob.getlength(p_blob);

    while v_size > v_wrote
    loop



        dbms_lob.read(p_blob, v_buffer_size, v_wrote + 1, v_raw);    --v_buffer_size parametro inout

        utl_file.put_raw(v_file, v_raw);

        utl_file.fflush(v_file);

        v_wrote := v_wrote + 32760;


    end loop;


    utl_file.fclose(v_file);


    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Generato file ' || p_name || ' nella directory Oracle ' || p_dir,
                                p_utente    => 'JOB_SP_ITF'
                            );

    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );


        return c_ko;

end;



function fnc_genera_pdf_per_sap
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_WRITE_BLOB_INTO_DIR';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_return        number;

    v_name          t_mcres_wrk_pdf_from_doc.val_doc_name%type;
    v_dir           t_mcres_wrk_configurazione.valore_costante%type;
    v_blob          blob;

    cursor c
    is
        select val_doc_name, doc_content
        from t_mcres_wrk_pdf_from_doc;

begin

    v_note := 'Recurero nome directory da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_dir
    from t_mcres_wrk_configurazione
    where nome_costante = 'TO_SAP_DIRECTORY';


    v_note := 'Creazione dei file PDF';

    for r in c
    loop

        v_name  := r.val_doc_name;
        v_blob  := r.doc_content;

        v_return := fnc_write_blob_into_dir(v_name, v_blob, v_dir);

        if v_return <> c_ok
        then

            pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_error,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Errore nella creazione del file ' || v_name,
                                p_utente    => 'JOB_SP_ITF'
                            );

            return c_ko;

        end if;


    end loop;


    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );


        return c_ko;

end;



function fnc_genera_txt_per_sap
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_GENERA_TXT_PER_SAP';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_dir           t_mcres_wrk_configurazione.valore_costante%type;
    v_itf_pref      t_mcres_wrk_configurazione.valore_costante%type;
    v_soff_pref     t_mcres_wrk_configurazione.valore_costante%type;
    v_suffix        t_mcres_wrk_configurazione.valore_costante%type;
    v_cod_sap       t_mcres_cl_sap.cod_societa%type;
    v_nome_file     varchar2(255);
    v_return        number;
    v_count         number;
    v_num_recs      pls_integer;

    cursor c_abi
    is
        select a.cod_abi, b.cod_societa
        from t_mcres_app_istituti a, t_mcres_cl_sap b
        where a.cod_abi = b.cod_abi
        and a.flg_target = 'Y';

begin

    v_note  := 'Recupero directory da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_dir
    from t_mcres_wrk_configurazione
    where nome_costante = 'TO_SAP_DIRECTORY';



    v_note  := 'Recupero prefisso file spese cruscotto da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_soff_pref
    from t_mcres_wrk_configurazione
    where nome_costante = 'PREFISSO_TXT_SAP_SPESE_CRUSCOTTO';


    v_note  := 'Recupero prefisso file spese Italfondiario da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_itf_pref
    from t_mcres_wrk_configurazione
    where nome_costante = 'PREFISSO_TXT_SAP_SPESE_ITF';

    v_note  := 'Recupero suffisso file spese da T_MCRES_WRK_CONFIGURAZIONE';

    select valore_costante
    into v_suffix
    from t_mcres_wrk_configurazione
    where nome_costante = 'SUFFISSO_TXT_SAP';


    v_count := 0;

    for r in c_abi
    loop

        dbms_application_info.set_client_info(r.cod_abi);   -- il contensto si usa nelle due viste V_MCRES_WRK_SAP_ITF e V_MCRES_WRK_SAP_SOF

        v_note := 'Conteggio record in V_MCRES_WRK_SAP_SOF per cod_abi ' || sys_context('userenv', 'client_info');

       select count(*)
       into v_num_recs
       from v_mcres_wrk_sap_sof;

        if v_num_recs > 2
        then

            v_nome_file := v_soff_pref || r.cod_societa || v_suffix;

            v_note  := 'Creazione file ' || v_nome_file;

            v_return := fnc_genera_file( 'V_MCRES_WRK_SAP_SOF', v_nome_file, v_dir);

            if v_return = c_ok
            then

                v_count := v_count + 1;

                pkg_mcres_audit.log_app (
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_debug,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'Generato file ' || v_nome_file,
                                            p_utente    => 'JOB_SP_ITF'
                                        );

                 --AP 29/05/2013 COMMENTATA FLAGGATURA INVIATO E AGGIUNTA NUOVA CHIAMATA POPOLA SENT

                 v_note  := 'SET spese da inviare';

                 v_return := fnc_popola_sent('V_MCRES_WRK_SENT_SAP_SOF','TO_SAP_SPESE');

                /*update t_mcres_app_sp_spese s
                set
                    s.flg_invio_sap = 1,
                    s.dta_invio_pagamento = sysdate,
                    s.dta_upd = sysdate
                where 0=0
                    and s.cod_abi = sys_context('userenv', 'client_info')
                    and cod_stato = 'CO'
                    and flg_invio_sap = 0
                    and flg_source = 'SOF'
                    -- escludo INVIO SPESE SU MEDIO CREDITO ABI 10637
                    and s.cod_abi != '10637'
                    and s.cod_tipo_autorizzazione in ('1', '6')
                    and s.cod_autorizzazione_padre is null
                    and s.flg_spesa_recuperata = 'N'
                    and not exists  -- esclude spese con addebito su posizioni cartolarizzate
                    (
                        select 1
                        from t_mcres_app_sp_contropartita c
                        where c.cod_autorizzazione = s.cod_autorizzazione
                        and c.cod_tipo IN ('7','8')
                    );*/


                pkg_mcres_audit.log_app (
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_debug,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'Aggiornata  T_MCRES_APP_SP_SPESE per ABI = ' ||  r.cod_abi,
                                            p_utente    => 'JOB_SP_ITF'
                                        );


            end if;

        end if;


        v_note := 'Conteggio record in V_MCRES_WRK_SAP_ITF per cod_abi ' || sys_context('userenv', 'client_info');

        select count(*)
        into v_num_recs
        from v_mcres_wrk_sap_itf;


        if v_num_recs > 2
        then

            v_nome_file := v_itf_pref || r.cod_societa || v_suffix;

            v_note  := 'Creazione file ' || v_nome_file;

            v_return := fnc_genera_file( 'V_MCRES_WRK_SAP_ITF', v_nome_file, v_dir);

            if v_return = c_ok
            then

                v_count := v_count + 1;

                pkg_mcres_audit.log_app (
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_debug,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'Generato file ' || v_nome_file,
                                            p_utente    => 'JOB_SP_ITF'
                                        );

                --AP 29/05/2013 COMMENTATA FLAGGATURA INVIATO E AGGIUNTA NUOVA CHIAMATA POPOLA SENT

                 v_note  := 'SET spese da inviare';

                 v_return := fnc_popola_sent('V_MCRES_WRK_SENT_SAP_ITF','TO_SAP_SPESE');


                /*update t_mcres_app_sp_spese t
                set
                    t.flg_invio_sap = 1,
                    t.dta_invio_pagamento = sysdate,
                    t.dta_upd = sysdate
                where 0=0
                    and t.flg_source = 'ITF'
                    -- escludo INVIO SPESE SU MEDIO CREDITO ABI 10637
                    and t.cod_abi != '10637'
                    and t.flg_invio_sap = 0
                    and exists
                    (
                        select 1
                        from t_mcres_app_spese_itf s
                        where 0=0
                            and t.cod_autorizzazione = s.cod_autorizzazione
                            and s.cod_abi = sys_context('userenv', 'client_info')
                            and s.flg_inviata_sap = 0
                            and s.cod_tipo_autorizzazione in ('1', '6')
                            and s.cod_autorizzazione_padre is null
                            and s.flg_spesa_recuperata = 0
                            and exists
                            (
                                select 1
                                from t_mcres_app_sp_spese sp, t_mcres_app_contropartite_itf c
                                where 0=0
                                    and sp.cod_autorizzazione = s.cod_autorizzazione
                                    and c.cod_autorizzazione = sp.cod_autorizzazione
                                    and sp.flg_contabilizzata = 1
                                    and sp.cod_stato = 'CO'
                                    and sp.flg_source = 'ITF'
                                    and c.cod_tipo = '1'
                                UNION
                                select 1
                                from t_mcres_app_sp_spese sp, t_mcres_app_contropartite_itf c
                                where 0=0
                                    and sp.cod_autorizzazione = s.cod_autorizzazione
                                    and c.cod_autorizzazione = sp.cod_autorizzazione
                                    and sp.cod_stato = 'CO'
                                    and sp.flg_source = 'ITF'
                                    and c.cod_tipo != '1'
                            )
                            and not exists  -- esclude spese con addebito su posizioni cartolarizzate
                            (
                                select 1
                                from t_mcres_app_contropartite_itf c
                                where c.cod_autorizzazione = s.cod_autorizzazione
                                and c.cod_tipo IN ('7','8')
                            )
                    );*/

                pkg_mcres_audit.log_app (
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_debug,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'Aggiornata  T_MCRES_APP_SP_SPESE per ABI = ' ||  r.cod_abi,
                                            p_utente    => 'JOB_SP_ITF'
                                        );

                /*update t_mcres_app_spese_itf s
                set
                    s.flg_inviata_sap = 1,
                    s.dta_invio_sap = sysdate,
                    s.dta_upd = sysdate
                where 0=0
                    and s.cod_abi = sys_context('userenv', 'client_info')
                    -- escludo INVIO SPESE SU MEDIO CREDITO ABI 10637
                    and s.cod_abi != '10637'
                    and s.flg_inviata_sap = 0
                    and s.cod_tipo_autorizzazione in ('1', '6')
                    and s.cod_autorizzazione_padre is null
                    and s.flg_spesa_recuperata = 0
                    and exists
                    (
                        select 1
                        from t_mcres_app_sp_spese sp, t_mcres_app_contropartite_itf c
                        where 0=0
                            and sp.cod_autorizzazione = s.cod_autorizzazione
                            and c.cod_autorizzazione = sp.cod_autorizzazione
                            and sp.flg_contabilizzata = 1
                            and sp.cod_stato = 'CO'
                            and sp.flg_source = 'ITF'
                            and c.cod_tipo = '1'
                        UNION
                        select 1
                        from t_mcres_app_sp_spese sp, t_mcres_app_contropartite_itf c
                                where 0=0
                            and sp.cod_autorizzazione = s.cod_autorizzazione
                            and c.cod_autorizzazione = sp.cod_autorizzazione
                            and sp.cod_stato = 'CO'
                            and sp.flg_source = 'ITF'
                            and c.cod_tipo != '1'
                    )
                    and not exists  -- esclude spese con addebito su posizioni cartolarizzate
                    (
                        select 1
                        from t_mcres_app_contropartite_itf c
                        where c.cod_autorizzazione = s.cod_autorizzazione
                        and c.cod_tipo IN ('7','8')
                    );*/


                pkg_mcres_audit.log_app (
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_debug,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'Aggiornata  T_MCRES_APP_SPESE_ITF per ABI = ' ||  r.cod_abi,
                                            p_utente    => 'JOB_SP_ITF'
                                        );


            end if;

        end if;

    end loop;

    commit;


    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Numero file elaborati: ' || v_count,
                                p_utente    => 'JOB_SP_ITF'
                            );


    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;

function fnc_post_load
return number
is
pragma autonomous_transaction;

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_POST_LOAD';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    v_return        number;
    v_exists        pls_integer;



begin

---- work around 20130325

    v_note := 'Controllo se esite una altra esecuzione negli ultimi 10 minuti';

    select count(*)
    into v_exists
    from t_mcres_wrk_audit_applicativo
    where 0=0
    and dta_ins > sysdate  - 10/(24*60)
    and utente = 'JOB_SP_ITF'
    and note like 'INIZIO - FNC_POST_LOAD';

    if v_exists > 0
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Non fa nulla in quanto eseguta negli ultimi 10 minuti',
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ok;

    end if;



---- end work around 20130325


    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'INIZIO - FNC_POST_LOAD',
                                p_utente    => 'JOB_SP_ITF'
                            );



    v_note := 'Aggiornamento flag docs_archiviati su T_MCRES_APP_SPESE_ITF';

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'INIZIO - FNC_AGGIORNA_PDF_CARICATI',
                                p_utente    => 'JOB_SP_ITF'
                            );

    --call
    v_return := pkg_mcres_interfaccia_itf_sap.fnc_aggiorna_pdf_caricati;

    if v_return != c_ok
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore in FNC_AGGIORNA_PDF_CARICATI',
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    end if;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'FINE - FNC_AGGIORNA_PDF_CARICATI',
                                p_utente    => 'JOB_SP_ITF'
                            );


    v_note := 'Creazione flusso da inviare a JUS0 per calcolo UO e OD - call fnc_genera_flusso_calcolo_uo';

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'INIZIO - FNC_GENERA_FLUSSO_CALCOLO_UO',
                                p_utente    => 'JOB_SP_ITF'
                            );

    -- call
    v_return := fnc_genera_flusso_calcolo_uo;

    if v_return <> c_ok -- anche in caso di warning
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    else

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'FINE - ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

    end if;


    v_note := 'Creazione file PDF per SAP';

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'INIZIO - FNC_GENERA_PDF_PER_SAP',
                                p_utente    => 'JOB_SP_ITF'
                            );

    --call
    v_return := pkg_mcres_interfaccia_itf_sap.fnc_genera_pdf_per_sap;

    if v_return != c_ok
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore in FNC_GENERA_PDF_PER_SAP',
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    end if;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'FINE - FNC_GENERA_PDF_PER_SAP',
                                p_utente    => 'JOB_SP_ITF'
                            );



    v_note := 'Creazione flussi TXT per SAP';

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'INIZIO - FNC_GENERA_TXT_PER_SAP',
                                p_utente    => 'JOB_SP_ITF'
                            );

    --call
    v_return := pkg_mcres_interfaccia_itf_sap.fnc_genera_txt_per_sap;

    if v_return != c_ok
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore in FNC_GENERA_TXT_PER_SAP',
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    end if;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'FINE - FNC_GENERA_TXT_PER_SAP',
                                p_utente    => 'JOB_SP_ITF'
                            );


    v_note := 'Abilitazione last_step';

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'INIZIO - FNC_ABILITA_LAST_STEP',
                                p_utente    => 'JOB_SP_ITF'
                            );

    --call
    v_return := pkg_mcres_interfaccia_itf_sap.fnc_spegni_quartz;

    if v_return != c_ok
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Errore in FNC_ABILITA_LAST_STEP',
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

    end if;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'FINE - FNC_ABILITA_LAST_STEP',
                                p_utente    => 'JOB_SP_ITF'
                            );

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'FINE - FNC_POST_LOAD',
                                p_utente    => 'JOB_SP_ITF'
                            );

    return c_ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

end;

function fnc_get_cdc_banca
(
    p_cod_abi   in  t_mcres_cnf_fatture_sap.cod_abi%type,
    p_cod_uo    in  t_mcres_cnf_fatture_sap.cod_uo%type
)
return t_mcres_cnf_fatture_sap.val_cdc_banca%type
is

    v_val_cdc_banca     t_mcres_cnf_fatture_sap.val_cdc_banca%type;

begin

    begin

        select val_cdc_banca
        into v_val_cdc_banca
        from t_mcres_cnf_fatture_sap
        where 0=0
            and flg_attivo = 1
            and cod_abi = p_cod_abi
            and cod_uo = p_cod_uo;

    exception
    when no_data_found
    then

        begin

            select val_cdc_banca
            into v_val_cdc_banca
            from t_mcres_cnf_fatture_sap
            where 0=0
                and flg_attivo = 1
                and cod_abi = p_cod_abi
                and cod_uo is null;

        exception
        when no_data_found
        then

            v_val_cdc_banca := null;
        end;

    end;


    return v_val_cdc_banca;

end;



function fnc_get_conto_coge
(
    p_cod_abi           in  t_mcres_cnf_fatture_sap.cod_abi%type,
    p_cod_uo            in  t_mcres_cnf_fatture_sap.cod_uo%type,
    p_flg_spesa_rip     in  varchar2
)
return t_mcres_cnf_fatture_sap.val_spesa_rip%type
is

    v_val_conto_coge t_mcres_cnf_fatture_sap.val_spesa_rip%type;

begin

    case p_flg_spesa_rip
    when 'S' then

        begin

            select val_spesa_rip
            into v_val_conto_coge
            from t_mcres_cnf_fatture_sap
            where 0=0
                and flg_attivo = 1
                and cod_abi = p_cod_abi
                and cod_uo = p_cod_uo;

        exception
        when no_data_found
        then

            begin

                select val_spesa_rip
                into v_val_conto_coge
                from t_mcres_cnf_fatture_sap
                where 0=0
                    and flg_attivo = 1
                    and cod_abi = p_cod_abi
                    and cod_uo is null;

            exception
            when no_data_found
            then

                v_val_conto_coge := null;
            end;

        end;

    when 'N' then

        begin

            select val_spesa_non_rip
            into v_val_conto_coge
            from t_mcres_cnf_fatture_sap
            where 0=0
                and flg_attivo = 1
                and cod_abi = p_cod_abi
                and cod_uo = p_cod_uo;

        exception
        when no_data_found
        then

            begin

                select val_spesa_non_rip
                into v_val_conto_coge
                from t_mcres_cnf_fatture_sap
                where 0=0
                    and flg_attivo = 1
                    and cod_abi = p_cod_abi
                    and cod_uo is null;

            exception
            when no_data_found
            then

                v_val_conto_coge := null;
            end;

        end;

    else

        v_val_conto_coge := null;

    end case;

    return v_val_conto_coge;

end;



--
function fnc_check_fatture_duplicate
(
    p_cod_autorizzazione        in  t_mcres_fl_spese_itf.cod_autorizzazione%type,
    p_cod_tipo_autorizzazione   in  t_mcres_fl_spese_itf.cod_tipo_autorizzazione%type,
    p_val_numero_fattura        in  t_mcres_fl_spese_itf.val_numero_fattura%type,
    p_dta_fattura               in  t_mcres_fl_spese_itf.dta_fattura%type,
    p_desc_cfpiva_legale        in  t_mcres_fl_spese_itf.desc_cfpiva_legale%type
)
return number
is
/*
valori di ritorno
    0   controllo superato
    1   presente fattura duplicata

*/

    v_exists    number(1);

begin

    if p_cod_tipo_autorizzazione not in ('1','5')
    then

        return 0;   --se non si tratta di fatture o proforma il controllo viene superato di default

    end if;


    select count(*)
    into v_exists
    from
    (
        select
            cod_autorizzazione,
            val_numero_fattura,
            dta_fattura,
            nvl(val_intestatario_piva,val_intestatario_codfisc) desc_cfpiva_legale,
            cod_stato
        from t_mcres_app_sp_spese
        union all
        select
            cod_autorizzazione,
            val_numero_fattura,
            dta_fattura,
            desc_cfpiva_legale,
            cod_stato
        from t_mcres_app_spese_itf
        union all
        select
            cod_autorizzazione,
            val_numero_fattura,
            dta_fattura,
            desc_cfpiva_legale,
            cod_stato
        from t_mcres_fl_spese_itf
    )
    where 0=0
        and cod_autorizzazione != p_cod_autorizzazione
        and val_numero_fattura = p_val_numero_fattura
        and trunc(dta_fattura, 'Y') = trunc(p_dta_fattura, 'Y')
        and desc_cfpiva_legale  = p_desc_cfpiva_legale
        and cod_stato != 'AN'
        and rownum <= 1;

    if v_exists = 0
    then
        return 0;
    else
        return 1;
    end if;

end;

function fnc_controagg_proforma
(
    p_rec f_slave_par_type
)
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_CONTROAGG_PROFORMA';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

    cursor c_daAgg(p_id_dper number)
    is
        select
            cod_autorizzazione,
            val_num_proforma,
            val_numero_fattura,
            dta_fattura
        from t_mcres_app_spese_itf
        where 0=0
            and id_dper = p_id_dper
            and cod_tipo_autorizzazione = '1'
            and val_num_proforma is not null;


    v_id_flusso     t_mcres_wrk_acquisizione.id_flusso%type;
    v_id_dper       t_mcres_app_spese_itf.id_dper%type;
    v_count         pls_integer;


begin

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'INIZIO'
                                    );

    v_id_flusso := p_rec.seq_flusso;

    v_note := 'Recupero id_dper da T_MCRES_WRK_ACQUISIZIONE';

    select to_char(id_dper, 'yyyymmdd')
    into v_id_dper
    from t_mcres_wrk_acquisizione
    where id_flusso = v_id_flusso;


    v_note := 'Aggiornamento T_MCRES_APP_SPESE_ITF';


    for r in c_daAgg(v_id_dper)
    loop

        update t_mcres_app_sp_spese sp
        set
            val_numero_fattura = r.val_numero_fattura,
            dta_fattura = r.dta_fattura,
            cod_stato = 'DE',
            dta_upd = sysdate
        where 0=0
            and cod_autorizzazione = r.val_num_proforma
            --tipologia proforma (controllo inserito per maggior sicurezza)
            and cod_tipo_autorizzazione = '5'
            and cod_stato = 'CO';

        v_count := SQL%ROWCOUNT;

        if v_count = 0
        then

            pkg_mcres_audit.log_caricamenti (
                                                p_id_flusso => v_id_flusso,
                                                p_proc      => c_nome,
                                                p_livello   => pkg_mcres_audit.c_warning,
                                                p_sqlcode   => SQLCODE,
                                                p_mssg      => SQLERRM,
                                                p_note      => 'Nessun proforma trovato per controaggiornamento richiesto da record con cod_autorizzazione = ' || r.cod_autorizzazione
                                            );

        else

                pkg_mcres_audit.log_caricamenti (
                                            p_id_flusso => v_id_flusso,
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_debug,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'Controaggiornamento proforma ' || r.val_num_proforma || ' con dati del record con cod_autorizzazione = ' || r.cod_autorizzazione
                                        );
        end if;

    end loop;


    commit;

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'FINE - Aggioramento proforma definitivi correttamente completato'
                                    );

    return c_ok;


exception
when others
then

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'GENERALE: ' || v_note
                                    );

    rollback;

    return c_ko;

end;


function fnc_reload_alert_spese
(
    p_rec f_slave_par_type
)
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_RELOAD_ALERT_SPESE';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;


    cursor c_alert is
        select val_ins_query, val_del_qry, val_note
        from t_mcres_wrk_alimentazione_fen
        where 0=0
            and flg_attiva = 1
            and val_tbl_name = 'T_MCRES_FEN_ALERT_POS'
            and instr(val_lista_flussi, 'SPESE') > 0
            --AP 12/03/2014
            and instr(val_note, 'ID_ALERT = 18') = 0;

    cursor c_abi is

        select cod_abi
        from t_mcres_app_istituti
        where flg_target = 'Y';

        v_id_flusso     t_mcres_wrk_acquisizione.id_flusso%type;

begin

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'INIZIO'
                                    );

    v_id_flusso := p_rec.seq_flusso;


    for r_alert in c_alert
    loop

        for r_abi in c_abi
        loop

            execute immediate r_alert.val_del_qry using r_abi.cod_abi;

            execute immediate r_alert.val_ins_query using r_abi.cod_abi;


        end loop;


        pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Effettuato reload alert ' || r_alert.val_note
                                    );

        commit;


    end loop;


    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_debug,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'FINE'
                                    );

    return c_ok;


exception
when others
then

    pkg_mcres_audit.log_caricamenti (
                                        p_id_flusso => v_id_flusso,
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'GENERALE: ' || v_note
                                    );

    rollback;

    return c_ko;

end;

function fnc_insert_blob_into_tab
(
    p_file_name varchar2,
    p_dir varchar2
)
return number
is

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_INSERT_BLOB_INTO_TAB';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

   v_file_loc       bfile;

   v_pdf_loc        blob;
   v_pdf_size       integer;


begin

    v_file_loc := bfilename(p_dir, p_file_name);

    v_pdf_size := dbms_lob.getlength(v_file_loc);

    insert into t_mcres_wrk_pdf_spese_itf
    (val_pdf_filename, blob_pdf_content)
    values ( p_file_name, empty_blob )
    returning blob_pdf_content into v_pdf_loc;

    dbms_lob.fileopen(v_file_loc);

    dbms_lob.loadfromfile(v_pdf_loc, v_file_loc, v_pdf_size);

    dbms_lob.fileclose(v_file_loc);

    commit;

    pkg_mcres_audit.log_app (
                                p_proc      => c_nome,
                                p_livello   => pkg_mcres_audit.c_debug,
                                p_sqlcode   => SQLCODE,
                                p_mssg      => SQLERRM,
                                p_note      => 'Inserito PDF ' || p_file_name || ' in tabella di lavoro',
                                p_utente    => 'JOB_SP_ITF'
                            );

    return c_ok;


exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        return c_ko;

end;


function fnc_set_flg_sent (p_target varchar2, p_cod_abi varchar2 DEFAULT NULL)
return number
is
pragma autonomous_transaction;
    c_nome          constant varchar2(61)   :=  c_package || '.FNC_SET_FLG_SENT';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

begin

   v_note := 'Verifica target FLG SENT';

   -- JUS MULTIBANCA --
   IF (p_target = 'TO_JUS0_SPESEITF') THEN

    UPDATE T_MCRES_APP_SPESE_ITF APP
    SET
        FLG_INVIATA_PER_CALC_UO_OD  = 1,
        DTA_INVIO_PER_CALC_UO_OD    = SYSDATE,
        DTA_UPD                     = SYSDATE
    WHERE EXISTS
        (
            SELECT 1
            FROM T_MCRES_WRK_SENT_ITF SENT
            WHERE 0=0
                AND SENT.COD_ABI = APP.COD_ABI
                AND SENT.COD_AUTORIZZAZIONE = APP.COD_AUTORIZZAZIONE
                AND SENT.COD_FLUSSO = p_target
                AND SENT.DTA_SENT IS NULL
        );

    UPDATE T_MCRES_WRK_SENT_ITF SENT
       SET SENT.DTA_SENT = SYSDATE
     WHERE SENT.COD_FLUSSO = p_target
       AND SENT.DTA_SENT IS NULL;

   END IF;

    -- HOST CLONE --
    IF (p_target = 'TO_HOST_SPESEITF') THEN

    UPDATE T_MCRES_APP_SPESE_ITF APP
    SET
         APP.FLG_INVIATA_PER_CONTABIL = 1,
         APP.DTA_INVIO_PER_CONTABIL = SYSDATE
    WHERE EXISTS
        (
            SELECT 1
            FROM T_MCRES_WRK_SENT_ITF SENT
            WHERE 0=0
                AND SENT.COD_ABI = APP.COD_ABI
                AND SENT.COD_AUTORIZZAZIONE = APP.COD_AUTORIZZAZIONE
                AND SENT.COD_FLUSSO = p_target
                AND SENT.COD_ABI = p_cod_abi
                AND SENT.DTA_SENT IS NULL
        );

    UPDATE T_MCRES_WRK_SENT_ITF SENT
       SET SENT.DTA_SENT = SYSDATE
     WHERE SENT.COD_FLUSSO = p_target
       AND SENT.COD_ABI = p_cod_abi
       AND SENT.DTA_SENT IS NULL;

   END IF;

   -- SAP CLONE --
    IF (p_target = 'TO_SAP_SPESE') THEN


    UPDATE T_MCRES_APP_SP_SPESE APP
    SET
         APP.FLG_INVIO_SAP = 1,
         APP.DTA_INVIO_PAGAMENTO = SYSDATE,
         APP.DTA_UPD = SYSDATE
    WHERE EXISTS
        (
            SELECT 1
            FROM T_MCRES_WRK_SENT_ITF SENT
            WHERE 0=0
                AND SENT.COD_ABI = APP.COD_ABI
                AND SENT.COD_AUTORIZZAZIONE = APP.COD_AUTORIZZAZIONE
                AND SENT.COD_FLUSSO = p_target
                AND SENT.DTA_SENT IS NULL
        );

    UPDATE T_MCRES_APP_SPESE_ITF APP
    SET
        FLG_INVIATA_SAP = 1,
        DTA_INVIO_SAP = SYSDATE,
        DTA_UPD = SYSDATE
    WHERE EXISTS
        (
            SELECT 1
            FROM T_MCRES_WRK_SENT_ITF SENT
            WHERE 0=0
                AND SENT.COD_ABI = APP.COD_ABI
                AND SENT.COD_AUTORIZZAZIONE = APP.COD_AUTORIZZAZIONE
                AND SENT.COD_FLUSSO = p_target
                AND SENT.DTA_SENT IS NULL
        );

    UPDATE T_MCRES_WRK_SENT_ITF SENT
       SET SENT.DTA_SENT = SYSDATE
     WHERE SENT.COD_FLUSSO = p_target
       AND SENT.DTA_SENT IS NULL;

   END IF;

   COMMIT;

   return c_ok;

    exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;


end;

function fnc_popola_sent (p_view varchar2, p_flusso varchar2)
return number
is
pragma autonomous_transaction;

    c_nome          constant varchar2(61)   :=  c_package || '.FNC_POPOLA_SENT';
    v_note          t_mcres_wrk_audit_caricamenti.note%type;

begin

     v_note := 'MERGE T_MCRES_WRK_SENT_ITF per flusso ' || p_flusso;

    EXECUTE IMMEDIATE 'MERGE INTO T_MCRES_WRK_SENT_ITF TRG USING
    (SELECT COD_ABI, COD_AUTORIZZAZIONE FROM ' || p_view || ') SRC
     ON (TRG.COD_ABI = SRC.COD_ABI AND
         TRG.COD_AUTORIZZAZIONE = SRC.COD_AUTORIZZAZIONE AND
         TRG.COD_FLUSSO = ''' || p_flusso || ''')
     WHEN NOT MATCHED THEN
     INSERT (COD_FLUSSO, COD_ABI, COD_AUTORIZZAZIONE)
     VALUES (''' || p_flusso || ''', SRC.COD_ABI, SRC.COD_AUTORIZZAZIONE)';

     COMMIT;

     return c_ok;

     exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'GENERALE: ' || v_note,
                                    p_utente    => 'JOB_SP_ITF'
                                );

        rollback;

        return c_ko;

end;



function fnc_calcolo_mct
(
    p_cf varchar2,
    p_piva varchar2
)
return varchar2 is

ret varchar2(4);


begin

select nvl((select distinct 'FRIT'
from (
select val_codice_fiscale,
             cod_sap_fornitore,
             ROW_NUMBER () OVER (PARTITION BY val_codice_fiscale ORDER BY dta_upd DESC) r
       from t_mcres_app_fornitori
       )
where 1 = 1
and val_codice_fiscale = p_cf
and cod_sap_fornitore >= '0001100000' and cod_sap_fornitore < '0001300000'
and r = 1), 'FATD') into ret from dual;

IF (ret = 'FATD') THEN

select nvl((select distinct 'FRIT'
from (
select val_partita_iva,
             cod_sap_fornitore,
             ROW_NUMBER () OVER (PARTITION BY val_partita_iva ORDER BY dta_upd DESC) r
       from t_mcres_app_fornitori
       )
where 1 = 1
and val_partita_iva = p_piva
and cod_sap_fornitore >= '0001100000' and cod_sap_fornitore < '0001300000'
and r = 1), 'FATD') into ret from dual;

END IF;

return ret;

end;

function fnc_delete_spese (
    p_cod_livello number default -1,
    p_id_flusso in t_mcres_wrk_acquisizione.id_flusso%type,
    p_id_dper t_mcres_app_sp_spese.id_dper%type default null,
    p_cod_autorizzazione t_mcres_app_sp_spese.cod_autorizzazione%type default null
)return number is

    cursor spese_c is
        select   COD_AUTORIZZAZIONE
        FROM T_MCRES_app_SPESE_ITF
        WHERE ID_DPER = p_id_dper
        --WHERE ID_DPER = nvl(p_id_dper,id_dper)
        --and cod_autorizzazione = nvl(p_cod_autorizzazione,cod_autorizzazione)
        union
        select   COD_AUTORIZZAZIONE
        FROM T_MCRES_app_contropartite_ITF
        WHERE ID_DPER = p_id_dper
        --WHERE ID_DPER = nvl(p_id_dper,id_dper)
        --and cod_autorizzazione = nvl(p_cod_autorizzazione,cod_autorizzazione)
        union
        select   COD_AUTORIZZAZIONE
        FROM T_MCRES_app_rapporti_ITF
        WHERE ID_DPER = p_id_dper
        --WHERE ID_DPER = nvl(p_id_dper,id_dper)
        --and cod_autorizzazione = nvl(p_cod_autorizzazione,cod_autorizzazione)
        union
        select   COD_AUTORIZZAZIONE
        FROM T_MCRES_app_azioni_ITF
        WHERE ID_DPER = p_id_dper
        --WHERE ID_DPER = nvl(p_id_dper,id_dper)
        --and cod_autorizzazione = nvl(p_cod_autorizzazione,cod_autorizzazione)
        union
        select   COD_AUTORIZZAZIONE
        FROM T_MCRES_app_fatture_ITF
        WHERE ID_DPER = p_id_dper;
        --WHERE ID_DPER = nvl(p_id_dper,id_dper)
        --and cod_autorizzazione = nvl(p_cod_autorizzazione,cod_autorizzazione);

     c_nome      constant varchar2(61)   :=  c_package || '.FNC_DELETE_SPESE';
     v_COD_AUTORIZZAZIONE T_MCRES_app_SPESE_ITF.COD_AUTORIZZAZIONE%type;
     c_livello_nodelete constant number(1):=-1;
     c_livello_alldelete constant number(1):=0;
     c_livello_contropart  constant number(1):=1;
     c_livello_rapporti constant number(1):=2;
     c_livello_azioni constant number(1):=3;
     c_livello_fatture constant number(1):=4;
     c_livello_spese constant number(1):=5;

begin
        /*if((p_cod_autorizzazione is null and p_id_dper is null) or p_cod_livello = c_livello_nodelete) then
            return c_ko;
        end if;*/

        if(p_id_dper is null or p_cod_livello = c_livello_nodelete) then
            return c_ko;
        end if;

        for rec_spese in spese_c loop

        begin

            v_COD_AUTORIZZAZIONE := rec_spese.COD_AUTORIZZAZIONE;


            --Contropartite ITF
            if(c_livello_contropart between c_livello_alldelete and p_cod_livello) then
                delete t_mcres_sc_convert_controp_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_sc_vincoli_controp_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_st_contropartite_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_app_contropartite_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;
             end if;


            --Rapporti ITF
            if(c_livello_rapporti between c_livello_alldelete and p_cod_livello) then
                delete t_mcres_sc_convert_rapp_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_sc_vincoli_rapp_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_st_rapporti_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_app_rapporti_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;
            end if;

            --Azioni ITF
            if(c_livello_azioni between c_livello_alldelete and p_cod_livello) then
                delete t_mcres_sc_convert_azioni_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_sc_vincoli_azioni_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_st_azioni_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_app_azioni_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;
            end if;

            --Fatture ITF
            if(c_livello_fatture between c_livello_alldelete and p_cod_livello) then
                delete t_mcres_sc_convert_fatture_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_sc_vincoli_fatture_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_st_fatture_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_app_fatture_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;
            end if;

            --Spese ITF
            if(c_livello_spese between c_livello_alldelete and p_cod_livello) then
                delete t_mcres_sc_convert_spese_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_sc_vincoli_spese_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_st_spese_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_app_spese_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;
            end if;

            --tabelle SP
            if(p_cod_livello = c_livello_alldelete) then
                delete t_mcres_app_sp_spese
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_app_sp_azioni
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_app_sp_contropartita
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_app_sp_rapporto
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_app_sp_fatture
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                --tabella ESITI
                delete t_mcres_app_esiti_spese_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                --tabella documenti
                delete t_mcres_app_documenti
                where cod_identificativo = v_COD_AUTORIZZAZIONE;

                -- tabelle staging JUS0
                delete t_mcres_sc_convert_jus0_sp_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_sc_vincoli_jus0_sp_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_fl_jus0_speseitf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_st_jus0_speseitf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_app_jus0_speseitf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                -- tabelle staging HOST
                delete t_mcres_sc_convert_host_sp_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_sc_vincoli_host_sp_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_fl_host_speseitf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_st_host_speseitf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                delete t_mcres_app_host_speseitf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

                -- tabelle di SENT
                delete t_mcres_wrk_sent_itf
                where cod_autorizzazione = v_COD_AUTORIZZAZIONE;

            end if;

        exception
            when others then
                pkg_mcres_audit.log_caricamenti (p_id_flusso,c_nome, pkg_mcres_audit.c_error,SQLCODE,SQLERRM, 'Spesa: ' || v_cod_autorizzazione || ' - Flusso : ' || p_id_flusso);
                rollback;
                return c_ko;
      end;
    end loop;

    commit;

    return c_ok;

exception
  when others then
        pkg_mcres_audit.log_caricamenti (p_id_flusso,c_nome, pkg_mcres_audit.c_error,SQLCODE,SQLERRM, 'GENERALE - Flusso : ' || p_id_flusso);
        rollback;
        return c_ko;
end;


function fnc_check_xml_no_data return number is

ret number;

begin

SELECT COUNT (*)
  INTO RET
  FROM    T_MCRES_WRK_ACQUISIZIONE A
       JOIN
          T_MCRES_WRK_AUDIT_CARICAMENTI B
       ON A.ID_FLUSSO = B.ID_FLUSSO
 WHERE A.COD_FLUSSO IN
          ('SPESE_ITF',
           'FATTURE_ITF',
           'AZIONI_ITF',
           'RAPPORTI_ITF',
           'CONTROPARTITE_ITF')
       AND TRUNC (A.DTA_INIZIO) = trunc(sysdate)
       AND B.MESSAGE = 'O'||'RA-01403: no data found';

       if (ret > 0) then

       return c_ko;

       end if;

       return c_ok;

end;

function fnc_delete_context_caricamento (p_id_flusso in t_mcres_wrk_acquisizione.id_flusso%type, p_cod_flusso in t_mcres_wrk_alimentazione.cod_flusso%type)
return number is

     c_livello_contropart  constant number(1):=1;
     c_livello_rapporti constant number(1):=2;
     c_livello_azioni constant number(1):=3;
     c_livello_fatture constant number(1):=4;
     c_livello_spese constant number(1):=5;

     v_ret number;


begin

            IF (p_cod_flusso = 'CONTROPARTITE_ITF') THEN

            v_ret := fnc_delete_spese (c_livello_contropart, p_id_flusso, to_char(sysdate, 'YYYYMMDD'));

            End if;

            IF (p_cod_flusso = 'RAPPORTI_ITF') THEN

            v_ret := fnc_delete_spese (c_livello_rapporti, p_id_flusso, to_char(sysdate, 'YYYYMMDD'));

            End if;

            IF (p_cod_flusso = 'AZIONI_ITF') THEN

            v_ret := fnc_delete_spese (c_livello_azioni, p_id_flusso, to_char(sysdate, 'YYYYMMDD'));

            End if;

            IF (p_cod_flusso = 'FATTURE_ITF') THEN

            v_ret := fnc_delete_spese (c_livello_fatture, p_id_flusso, to_char(sysdate, 'YYYYMMDD'));

            End if;

            IF (p_cod_flusso = 'SPESE_ITF') THEN

            v_ret := fnc_delete_spese (c_livello_spese, p_id_flusso, to_char(sysdate, 'YYYYMMDD'));

            End if;

return v_ret;

end;
---
end;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_INTERFACCIA_ITF_SAP FOR MCRE_OWN.PKG_MCRES_INTERFACCIA_ITF_SAP;


CREATE SYNONYM MCRE_USR.PKG_MCRES_INTERFACCIA_ITF_SAP FOR MCRE_OWN.PKG_MCRES_INTERFACCIA_ITF_SAP;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_INTERFACCIA_ITF_SAP TO MCRE_USR;

