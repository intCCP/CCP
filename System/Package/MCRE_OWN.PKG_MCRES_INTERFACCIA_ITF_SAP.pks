CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcres_interfaccia_itf_sap
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
   0.42         26/04/2013      Antonio Pilloni    61.  Funzione valorizza flag invio
   0.43        29/04/2013      Antonio Pilloni     62  Aggiunta gestione per evitare generazione scarto su contropartita di tipo 3
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



-- costanti

    c_package   constant        varchar2(30)    :=  'PKG_MCRES_INTERFACCIA_ITF_SAP';
    c_ok        constant        number(1)       :=  1;
    c_ko        constant        number(1)       :=  0;
    c_warning   constant        number(1)       := -1;


--
-- Per popolamento T_MCRES_WRK_SC_ETL_SPESE_ITF
function fnc_popola_scarti_spese_itf
(
    p_rec in f_slave_par_type
)
return number;


--
function fnc_popola_scarti_controp_itf
(
    p_rec in f_slave_par_type
)
return number;


--
function fnc_popola_scarti_rapp_itf
(
    p_rec in f_slave_par_type
)
return number;


--
function fnc_popola_scarti_azioni_itf
(
    p_rec in f_slave_par_type
)
return number;


--
function fnc_popola_scarti_fatture_itf
(
    p_rec in f_slave_par_type
)
return number;


--
--Gestione caricamento
--
function fnc_prepara_wrk_tables
return number;


--
function fnc_insert_wrk_xml
(
    p_val_file_name     in  t_mcres_wrk_xml_itf.val_file_name%type,
    v_file_ok           out boolean
)
return number;


--
function fnc_popola_wrk_tables
return number;


--
function fnc_carica_flusso
(
    p_cod_flusso in t_mcres_wrk_alimentazione.cod_flusso%type
)
return number;


-- rimuove dai flussi AZIONI, CONTROPARTITE, RAPPORTI, FATTURE record validi ma relativi a spese scartate
function fnc_rimuovi_scarti
(
    p_rec f_slave_par_type
)
return number;


--
function fnc_load
return number;




--
--Fasi post-caricamento XML
--
function fnc_set_cod_uo_od_calcolato
(
   p_cod_autorizzazione in  t_mcres_app_spese_itf.cod_autorizzazione%type,
   p_cod_uo_proposto    in  t_mcres_app_spese_itf.cod_uo_proposto%type,
   p_cod_uo_calcolato   in  t_mcres_app_spese_itf.cod_uo_calcolato%type,
   p_cod_od_calcolato   in  t_mcres_app_spese_itf.cod_od_calcolato%type,
   p_cod_utente         in  t_mcres_wrk_audit_applicativo.utente%type       default null
)
return number;

-- aggiorna flg_calcolato_u_od su t_mcres_app_spese_itf
-- inserisce in t_mcres_app_sp_spese
-- spese confermate da jous0 e quelle da confermare da RUI
function fnc_post_load_jus0_spese_itf
(
    p_rec   in  f_slave_par_type
)
return number;



-- aggiorna flg_calcolato_u_od su t_mcres_app_spese_itf
-- inserisce in t_mcres_app_sp_spese
-- spese confermate da jous0 e quelle da confermare da RUI
function fnc_post_load_host_spese_itf
(
    p_rec   in  f_slave_par_type
)
return number;




--Richiama PKG_MCRES_FUNZIONI_PORTALE.FNC_MCRES_POPOLA_DOCUMENTI
--
-- deve essere allineata a quella presente nel pacakge funzione portale
-- una volta stabile
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
return number;


--aggionna flg e data caricamento su T_MCRES_APP_SPESE_ITF
function fnc_aggiorna_pdf_caricati
return number;


-- popola tabelle esiti per generazione flusso verso ITF
function fnc_popola_esiti_caricamento
(
    p_rec   in f_slave_par_type default null
)
return number;


-- ricarica i contatori dell'alert fornitori non censiti
function fnc_reload_alert_forntori
(
    p_rec   in f_slave_par_type default null
)
return number;


--inserisce i pdf letti da documentum in tabella di lavoro (per generazione pacchetto SAP)
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
return number;


--genera file leggendo da vista
function fnc_genera_file
(
    p_view      in varchar2,
    p_file_name in varchar2,
    p_dir       in varchar2 default 'D_MCRES_WORK'
)
return number;


function fnc_avvia_QUARTZ
return number;


--
function fnc_spegni_QUARTZ
return number;


--
function fnc_can_QUARTZ_run
return number;


--
function fnc_abilita_LAST_STEP
return number;


--
function fnc_aggiorna_fornitori_sp_itf
(
    p_rec f_slave_par_type
)
return number;



--
function fnc_genera_flusso_calcolo_uo
return number;



--
function fnc_genera_flusso_postLoad_itf
--(
--    p_id_lotto  in  t_mcres_app_esiti_spese_itf.id_lotto%type
--)
return number;

function fnc_genera_flusso_pLoad_jus0
return number;



function fnc_genera_flussi_per_host
return number;



function fnc_last_step
return number;



function fnc_genera_flusso_esiti2
return number;


function fnc_write_blob_into_dir
(
    p_name      varchar2,
    p_blob      blob,
    p_dir       varchar2
)
return number;


function fnc_genera_pdf_per_sap
return number;


function fnc_genera_txt_per_sap
return number;


-------------
-- per operazioni dopo QUARTZ
--
function fnc_post_load
return number;

-------------
-- per vista v_mcres_wrk_body_sap_sof
--
function fnc_get_cdc_banca
(
    p_cod_abi   in  t_mcres_cnf_fatture_sap.cod_abi%type,
    p_cod_uo    in  t_mcres_cnf_fatture_sap.cod_uo%type
)
return t_mcres_cnf_fatture_sap.val_cdc_banca%type;


function fnc_get_conto_coge
(
    p_cod_abi           in  t_mcres_cnf_fatture_sap.cod_abi%type,
    p_cod_uo            in  t_mcres_cnf_fatture_sap.cod_uo%type,
    p_flg_spesa_rip     in  varchar2
)
return t_mcres_cnf_fatture_sap.val_spesa_rip%type;


function fnc_check_fatture_duplicate
(
    p_cod_autorizzazione        in  t_mcres_fl_spese_itf.cod_autorizzazione%type,
    p_cod_tipo_autorizzazione   in  t_mcres_fl_spese_itf.cod_tipo_autorizzazione%type,
    p_val_numero_fattura        in  t_mcres_fl_spese_itf.val_numero_fattura%type,
    p_dta_fattura               in  t_mcres_fl_spese_itf.dta_fattura%type,
    p_desc_cfpiva_legale        in  t_mcres_fl_spese_itf.desc_cfpiva_legale%type
)
return number;


function fnc_controagg_proforma
(
    p_rec f_slave_par_type
)
return number;



function fnc_reload_alert_spese
(
    p_rec f_slave_par_type
)
return number;


function fnc_insert_blob_into_tab
(
    p_file_name varchar2,
    p_dir varchar2
)
return number;
--

function fnc_set_flg_sent
(
    p_target varchar2,
    p_cod_abi varchar2 DEFAULT NULL
)
return number;

function fnc_popola_sent
(
    p_view varchar2,
    p_flusso varchar2
)
return number;


function fnc_calcolo_mct
(
    p_cf varchar2,
    p_piva varchar2
)
return varchar2;

function fnc_delete_spese (
    p_cod_livello number default -1,
    p_id_flusso in t_mcres_wrk_acquisizione.id_flusso%type,
    p_id_dper t_mcres_app_sp_spese.id_dper%type default null,
    p_cod_autorizzazione t_mcres_app_sp_spese.cod_autorizzazione%type default null
)return number;

function fnc_check_xml_no_data
return number;

function fnc_delete_context_caricamento (p_id_flusso in t_mcres_wrk_acquisizione.id_flusso%type, p_cod_flusso in t_mcres_wrk_alimentazione.cod_flusso%type)
return number;

end;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_INTERFACCIA_ITF_SAP FOR MCRE_OWN.PKG_MCRES_INTERFACCIA_ITF_SAP;


CREATE SYNONYM MCRE_USR.PKG_MCRES_INTERFACCIA_ITF_SAP FOR MCRE_OWN.PKG_MCRES_INTERFACCIA_ITF_SAP;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_INTERFACCIA_ITF_SAP TO MCRE_USR;

