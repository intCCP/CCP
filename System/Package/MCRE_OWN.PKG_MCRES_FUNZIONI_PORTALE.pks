CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcres_funzioni_portale
AS
  /******************************************************************************
  NAME:       PKG_MCRES_FUNZIONI_PORTALE
  PURPOSE:
  REVISIONS:
  Ver        Date        Author             Description
  --------- ---------   ---------       ------------------------------------
    1.0     14/10/2011    V.Galli       Created this package.
    1.1     29/11/2011    V.Galli       Aggiunta gestione Spese
    1.2     04/01/2012    M.Palladino   creazione funzioni contesto spese(under test)
    1.3     19/01/2012    V.Galli       Gestori
    1.4     02/02/2012    V.Galli       Proposte
    1.5     24/02/2012    V.Galli       Protocollo delibere
    1.6     01/03/2012    A.Galliano    Modifica id_dper inserimento delibera
    1.7     05/03/2012    V.Galli       Aggiornata fnc update stato del
    1.8     05/03/2012    V.Galli       Inserimento rapporto spesa + reload alert
    1.9     24/04/2012    V.Galli       Flg stampa
    2.0     08/05/2012    V.Galli       Commit Alert
    2.1     18/05/2012    V.Galli       Cod_sndg in Insert_delibere
    2.2     30/07/2012    A.Galliano    nuova versione  FNC_MCRES_UPDATE_STATO_DELIBER
    2.3     01/08/2012    A.Galliano    gestione data inotro / traseferimento in FNC_INSERT_DELIBERE, FNC_MCRES_POPOLA_STIME
    2.3.1   04/09/2012    A.Galliano    Gestione annullamento piani in fnc_mcres_popola_piani
    2.4     13/09/2012    A.Galliano    Modifica fnc_mcres_popola_stime per inserimento in T_MCRES_APP_STIME e
                                        fnc_mcres_popola_piani per inserimento in T_MCRES_APP_PIANI_RIENTRO
    2.5     17/09/2012    A.Pilloni     Funzione chiusura rapporto
    2.6     21/09/2012    A.Pilloni     Funzione gestione legali
    2.6.1   21/09/2012    A.Pilloni     Riscrittura funzione aggiornamento stato spesa
    2.6.2   24/09/2012    A.Pilloni     Modifica funzione fnc_inserisci_rapporto (aggiunto campo cod_rapporto_orig).
    2.7     03/10/2012    A.Pilloni     Funzione aggiornamento legali a partire dai fornitori (fnc_mcres_fornitori_legali).
    2.8     10/10/2012    A.Pilloni     Modifica funzione fnc_ins_upd_spese, aggiunto controllo se cod_autorizzazione padre
    2.9     12/10/2012    A.Pilloni     Modifica funzione fnc_inserisci_rapporto.
    2.10    17/10/2012    A.Galliano    Modifica funzione popolamento stime
    2.11    17/10/2012    V.Galli       Modifica funzione fnc_inserisci_rapporto per cod_autorizzazione (commentato)
    2.12    24/10/2012    A.Pilloni     Modifica funzione FNC_MCRES_INS_UPD_SPESE, aggiunta nell'insert valorizzazione flg_sou
    2.13    25/10/2012    A.Pilloni     Sviluppo funzione presa visione spese FNC_SET_SP_PRESA_VISIONE
    2.14    30/10/2012    A.Galliano    Funzione per popolamento t_mcres_app_documenti
    2.15    31/10/2012    A.Galliano    Fix funzione FNC_INSERT_DELIBERE
    2.16    02/11/2012    A.Pilloni     Aggiunta parametri in funzione ins_ipd_spese per ITALFONDIARIO
    2.17    05/11/2012    A.Pilloni     Modifica Funzione per popolamento t_mcres_app_documenti per vincoli su cod_tipo_docu
    2.18    06/11/2012    A.Galliano    funzione popolamento top_30_nt
    2.19    08/11/2012    V.Galli       Al cambio stato delibera aggiorno le note delle stime se nulle.
    2.20    08/11/2012    A.Galliano    nuova versione funzione popolamento top_30_nt
    2.21    09/11/2012    A.Galliano    gestione update in  funzione popolamento top_30_nt
    2.22    13/11/2012    V.Galli       Annullamneto delibere NS
    2.23    15/11/2012    A.Pilloni     inserimento dettaglio fattura (t_mcres_app_sp_fatture) in NC_MCRES_INS_UPD_SPESE
    2.24    17/11/2012    A.Galliano    to_date dta_solare_operazione in  fnc_insert_rapporto_spesa_con
    2.25    21/11/2012    A.Galliano    creata funzione fnc_set_uo_calcolato_sp_spese
    2.27    07/01/2013    A.Galliano    gestione invio dati QdC in FNC_MCRES_POPOLA_TOP_30_NT
    2.28    07/01/2013    A.Galliano    aggiunto parametro l_val_wbs in funzione fnc_mcres_ins_upd_spese e controllo su fatt
    2.29    08/01/2013    A.            modifica funzione fnc_aggiorna_stato_spesa per annullamento spesa
    2.30    09/01/2013    A.Galliano    modificata fnc_reload_alert e aggiunto controllo sui pro forma in fnc_mcres_ins_upd_
    2.31    14/01/2013    A.Pilloni     modifica gestione legali aggiunta autorizzazione censimento e data
    2.32    15/01/2013    A.Pilloni     modifica funzione aggiornamento legali fnc_mcres_fornitori_legali
    2.33    18/01/2013    A.Galliano    aggiunta chiamata a funzion di log su reload alert
    2.34    18/01/2013    A.Galliano    fix dta_inserimento_deliera in caso di aggiornamento
    2.35    21/01/2013    A.Pilloni     aggiunta campo val_note_albo_con in gestione legali
    2.36    21/01/2013    V.Galli       aggiornamento motivo stime in inserimento delibera RW
    2.37    22/01/2013    A.Galliano    modificata fnc_mcres_popola_documenti per fix su gestione fatture multiple
    2.38    24/01/2013    A.Pilloni     aggiunti parametri date albo e convenzone in gestione legali
    2.39    28/01/2013    A.Pilloni     aggiunta stocizzazione albo convenzione in gestione legali
    2.40    30/01/2013    V.Galli       aggiunta gestione nuovi campi delibere
    2.41    30/01/2013    A.Pilloni     aggiornamento spesa aggiunto campo data annullamento spesa in update
    2.42    01/02/2013    V.Galli       aggiurnata fnc upd_stato_del per nuovo stato TX
    2.43    22/01/2013    A.Galliano    fix FNC_AGGIORNA_MOVIMENTO_KEY
    2.44    01/02/2013    V.Galli       delibere val_gruppo
    2.45    04/02/2013    A.Pilloni     aggiunta data_annullamento su aggiornamento delibera
    2.46    07/02/2013    A.Galliano    aggiunta funzione di aggiornamento tabella gestione alert e istituti all
    2.47    07/02/2013    V.Galli       motivo stime delibere - aggiornamento data
    2.48    08/02/2013    A.Galliano    fix controllo fatture duplicate in funzione di inserimento spese
    2.49    11/02/2013    A.Pilloni     aggiunto parametro codice uo di competenza per inserimento aggiornamento delibere
    2.50    11/02/2013    A.Pilloni     aggiunti calcoli per fattura su inserimento spese
    2.51    12/02/2012    A.Galliano    creata funzione per gestione centri costo
    2.52    13/02/2013    A.Galliano    creazione funzione fnc_popola_organi_deliberanti
    2.53    18/02/2013    A.Galliano    creazione funzione gestione scadenzario
    2.24    21/02/2013    A.Galliano    aggiunto parametro cod_uo alla fnc_mcres_update_stato_deliber
    2.25    01/03/2013    A.Pilloni     gestione presa visione delibere per ente centrale
    2.55    05/03/2013    A.Pilloni     modifica presa visione spese
    2.56    06/03/2013    V.Galli       Gestione proroghe e rapporti_delibere
    2.57    06/03/2013    A.Pilloni     modifica aggiorna stato delibera per trasferimento a RDRC
    2.56    08/03/2013    V.Galli       Gestione rapporti_delibere + nuovi campi
    2.57    08/03/2013    A.Galliano    Fix fnc_popola_documetni per tipo docuento DO
    2.58    12/03/2013    V.Galli        Gestione alert con NDG non utilizzato
    2.59    25/03/2013    V.Galli        Modificato motivo stime con data delibera
    2.60    08/04/2013    A.Pilloni     Modifica aggiorna stato spesa flag contabilizzata
    2.61    13/05/2013    A.Pilloni     Modifica aggionamento stato spesa cruscotto
    2.62    15/05/2013    V.Galli       Nuovo flg per step 5  ---------->>> NON PORTARE IN PRODUZIONE!!!!!
    2.63    27/06/2013    A.Pilloni     Nuova funzione per aggiornamento data attesa spese_itf FNC_SET_DTA_ATTESA_ITF
    2.64    03/07/2013    A.Pilloni     Mofifica funzione per aggiornamento data attesa spese_itf FNC_SET_DTA_ATTESA_ITF
    2.65    05/07/2013    V.Galli       fnc_chk_interf_sap
    2.66    22/07/2013    V.Galli       fnc_pag_sap_inviato_itf
    2.67    23/07/2013    V.Galli      Annullamento OD se del in AN
    2.68    29/07/2013    A.Pilloni    Aggiunto campo clob commento esteso in gestione proroghe
    2.69    29/07/2013     V.Galli      dta_retrocessione
    2.70   02/08/2013     V.Galli      gestione retrocessione
    2.71   05/08/2013     V.Galli      val_causale in insert_delibere
    2.72  03/09/2013     V.Galli       controllo spese AN in inserimento
    2.73  11/09/2013     V.Galli       flg_step5 in calcolo OD
    2.74  27/09/2013     V.Galli       Popola pareri per PK
    2.75  11/10/2013     A.Pilloni     Modifica popola DOCUMENTI bypass contolli stato co e tr per allegato quanto stato = AN
    3.0   22/10/2013     A.Pilloni     Nuova funzione REQF-FU6 Movimento proposto fnc_movimento_proposto
    3.1  25/10/2013     A.Pilloni     Nuova funzione REQF-FU2 Accensione sofferenza fnc_accensione_soff
    3.2  28/10/2013     A.Pilloni     Nuova funzione REQF-FU5 Movimenti da volturare fnc_movimento_da_volturare
    3.3  06/11/2013     V.Galli       Nuova funzione gestione_criteri, fnc_gestione_raccolta_doc, fnc_gestione_scheda_doc, fnc_ges_raccolta_doc_step0
    3.4  13/11/2013     A.Pilloni     Modifica funzione aggiorna stato spesa per cambiar stato ad annullato anche alle spese Italfondiario.
    3.5  13/11/2013     A.Pilloni     Creazione funzione generazione codice autorizzazione spesa
    3.6  18/11/2013     A.Pilloni     Ampliamento funzione gestione legali per EPC
    3.7  22/11/2013     V.Galli       fnc_gestione_cessione_rout
    3.8  09/01/2013     V.Galli       flg_inviato_itf = 9  se flg_source !=ITF
    3.9  17/01/2014     A.Pilloni     modifica cancellazione accensione soff MO01 cancellazione logica correlata di MO02
    3.10  23/01/2014    A.Pilloni     modifica insert update spese per inserimento proforma
    3.11  12/03/2014    V.Galli    to_date dta_solare_operazione in  fnc_insert_contropartita
    3.12 29/03/2014     V.Galli    valutazioni
    3.13 08/04/2014     V.Galli    flg_tipo_rapporto
	3.14 05/05/2014     A.Pilloni  fix inserimento spese anche se annullate da mople
    3.15 07/05/2014    A.Pilloni  aggiunta parametro flg_urgente in fnc_gestione_raccolta_doc
******************************************************************************/


  C_PACKAGE CONSTANT VARCHAR2(50) := 'PKG_MCRES_FUNZIONI_PORTALE';
  OK        NUMBER                := 1; -- Esito positivo
  ko        NUMBER                := 0; -- Esito negativo

type typ_sp_spese
IS
  TABLE OF t_mcres_app_sp_spese%rowtype INDEX BY binary_integer;
type typ_sp_contropartita
IS
  TABLE OF t_mcres_app_sp_contropartita%rowtype INDEX BY binary_integer;
type typ_sp_rapporto
IS
  TABLE OF t_mcres_app_sp_rapporto%rowtype INDEX BY binary_integer;
type typ_sp_azioni
IS
  TABLE OF t_mcres_app_sp_azioni%rowtype INDEX BY binary_integer;
type typ_cod_autorizzazione
IS
  table of T_MCRES_APP_SP_AZIONI.COD_AUTORIZZAZIONE%type;

-- Funzione aggiornamento alert
function FNC_RELOAD_ALERT (
  P_COD_ABI T_MCRES_APP_pratiche.COD_ABI%type,
  P_cod_flusso T_MCRES_WRK_ACQUISIZIONE.COD_FLUSSO%type,
  P_COD_MATR_PRATICA T_MCRES_APP_PRATICHE.COD_MATR_PRATICA%type,
  p_cod_ndg t_mcres_app_pratiche.cod_ndg%type default null
)  return number;

-- Funzione set flag stampa report delibere
function FNC_SET_DEL_STAMPA (
  P_COD_ABI T_MCRES_APP_DELIBERE.COD_ABI%type,
  P_COD_NDG T_MCRES_APP_DELIBERE.COD_NDG%type,
  P_COD_PROTOCOLLO_DELIBERA T_MCRES_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA%type,
  P_COD_MATR_PRATICA T_MCRES_APP_GRUPPI_NOTE.COD_MATR_PRATICA%type,
  P_FLG_STAMPA T_MCRES_APP_DELIBERE.FLG_STAMPA%type
)  RETURN NUMBER;

-- Funzione modifica presa visione DELIBERE
function FNC_SET_DEL_PRESA_VISIONE (
  P_COD_ABI T_MCRES_APP_DELIBERE.COD_ABI%type,
  P_COD_NDG T_MCRES_APP_DELIBERE.COD_NDG%type,
  P_COD_PROTOCOLLO_DELIBERA T_MCRES_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA%type,
  P_TIPO_UTENTE varchar2,
  P_COD_MATR_PRATICA T_MCRES_APP_GRUPPI_NOTE.COD_MATR_PRATICA%type
)  RETURN NUMBER;

-- Funzione per la generazione del protocollo pe reportb delibere per rendicontazione outsourcing
FUNCTION FNC_GET_PROTOCOLLO_DEL_PROSP (
  P_COD_ABI T_MCRES_APP_DEL_PROSPETTO.COD_ABI%TYPE,
  P_VAL_ANNOMESE T_MCRES_APP_DEL_PROSPETTO.VAL_ANNOMESE%TYPE,
  P_COD_MATR_PRATICA T_MCRES_APP_PRATICHE.COD_MATR_PRATICA%type
)  RETURN NUMBER;

-- Funzione per il mantenimento dello storico dei Gestori delle Pratiche Legali
FUNCTION FNC_MCRES_ALIMENTA_GESTORI(
    P_REC IN F_SLAVE_PAR_TYPE)
  return number;

  -- Funzione per l'inserimento delle note relativhe ai gruppi - Sezione: Monitoraggio Gruppi Top30
FUNCTION FNC_MCRES_NOTE_GRUPPI(
    P_DESC_NOTA T_MCRES_APP_GRUPPI_NOTE.DESC_NOTA%TYPE,
    P_COD_MATR_PRATICA T_MCRES_APP_GRUPPI_NOTE.COD_MATR_PRATICA%TYPE,
    P_VAL_ANNOMESE T_MCRES_APP_GRUPPI_NOTE.VAL_ANNOMESE%TYPE,
    P_COD_SNDG T_MCRES_APP_GRUPPI_NOTE.COD_SNDG%TYPE,
    P_COD_GRUPPO_ECONOMICO T_MCRES_APP_GRUPPI_NOTE.COD_GRUPPO_ECONOMICO%TYPE )
  return number;

-- Funzione per inserimento, Modifica e cancellazione pareri
FUNCTION fnc_mcres_popola_pareri(p_cod_abi             IN t_mcrei_app_pareri.cod_abi%TYPE,
                               P_COD_NDG                 in T_MCREI_APP_PARERI.COD_NDG%type,
                               P_COD_sNDG                 in T_MCREI_APP_PARERI.COD_sNDG%type,
                               p_cod_protocollo_delibera   IN t_mcrei_app_pareri.cod_protocollo_delibera%TYPE,
                               p_cod_tipo_par             IN t_mcrei_app_pareri.cod_tipo_par%TYPE,
                               P_DESC_PARERE              in T_MCREI_APP_PARERI.DESC_PARERE%type,
                               P_DESC_PARERE_ESTESO       in T_MCREI_APP_PARERI.DESC_PARERE_ESTESO%type,
                               P_COD_UO in T_MCREI_APP_PARERI.COD_UO%type,
                               P_COD_UTENTE in T_MCREI_APP_PARERI.COD_UTENTE%type,
                               P_FLG_DELETE in T_MCREI_APP_PARERI.FLG_DELETE%type,
                               P_ID_PARERE  IN OUT T_MCREI_APP_PARERI.ID_PARERE%TYPE)
return number;

  -- Funzione per l'inserimento e la modifica delle Spese
--FUNCTION fnc_mcres_ins_upd_spese_old(
--    p_spesa typ_sp_spese,
--    p_contropartita typ_sp_contropartita,
--    p_rapporto typ_sp_rapporto,
--    p_azioni typ_sp_azioni )
--  return number;

  -- Funzione per il cambio stato delle Spese
--FUNCTION fnc_mcres_cambio_stato_spese_o(
--    p_cod_autorizzazione typ_cod_autorizzazione,
--    p_cod_stato t_mcres_app_sp_spese.cod_stato%type,
--    p_cod_uo t_mcres_app_sp_spese.cod_uo%type,
--    p_cod_matricola t_mcres_app_sp_spese.cod_matricola%type )
--  return number;

FUNCTION fnc_mcres_ins_upd_spese
  (
    L_COD_ABI                   IN VARCHAR2 ,
    L_COD_AFAVORE_TIPO          IN VARCHAR2 ,
    L_COD_AUTORIZZAZIONE        IN OUT VARCHAR2 ,
    L_COD_AUTORIZZAZIONE_PADRE  IN VARCHAR2 ,
    L_COD_CAUSA_DIVISA          IN VARCHAR2 ,
    L_COD_CAUSALE               IN VARCHAR2 ,
    L_COD_CAUSALE_888           IN VARCHAR2 ,
    L_COD_IBAN                  IN VARCHAR2 ,
    L_COD_IMPORTO_DIVISA        IN VARCHAR2 ,
    L_COD_INTESTATARIO_ABI      IN VARCHAR2 ,
    L_COD_INTESTATARIO_CAB      IN VARCHAR2 ,
    L_COD_INTESTATARIO_TIPO     IN VARCHAR2 ,
    L_COD_MATRICOLA             IN VARCHAR2 ,
    L_COD_MATRICOLA_AGG_STATO_Z IN VARCHAR2 ,
    L_COD_NDG                   IN VARCHAR2 ,
    L_COD_ORGANO_AUTORIZZANTE   IN CHAR ,
    L_COD_PRATICA               IN VARCHAR2 ,
    L_COD_PRATICA_CEDUTA        IN VARCHAR2 ,
    L_COD_PROTOCOLLO            IN NUMBER ,
    L_COD_PUNTO_OPERATIVO       IN VARCHAR2 ,
    L_COD_STATO                 IN VARCHAR2 ,
    L_COD_TIPO_AUTORIZZAZIONE   IN CHAR ,
    L_COD_TIPO_PAGAMENTO        IN CHAR ,
    L_COD_UO                    IN VARCHAR2 ,
    L_COD_UO_PRATICA            IN VARCHAR2 ,
    L_DESC_AFAVORE              IN VARCHAR2 ,
    L_DESC_INTESTATARIO         IN VARCHAR2 ,
    L_DESC_SPESA                IN VARCHAR2 ,
    L_DTA_AUTORIZZAZIONE DATE ,
    L_DTA_BON_VALUTA DATE ,
    L_DTA_FATTURA DATE ,
    L_DTA_GENERAZIONE_PROTOCOLLO DATE ,
    L_DTA_INS_SPESA DATE ,
    L_DTA_PROFORMA_A_FATTURA DATE ,
    L_DTA_STORNO_CONTABILE DATE ,
    L_DTA_UPD DATE ,
    L_DTA_UPD_SPESA DATE ,
    L_FLG_ANN_AUTORIZ            IN VARCHAR2 ,
    L_FLG_CARICO_CESSIONARIO     IN VARCHAR2 ,
    L_FLG_CONVENZIONE            IN VARCHAR2 ,
    L_FLG_FM                     IN VARCHAR2 ,
    L_FLG_SPESA_RECUPERATA       IN VARCHAR2 ,
    L_FLG_SPESA_RIPETIBILE       IN VARCHAR2 ,
    L_VAL_AFAVORE_CODFISC        IN VARCHAR2 ,
    L_VAL_AFAVORE_PIVA           IN VARCHAR2 ,
    L_VAL_ANNO_PRATICA           IN VARCHAR2 ,
    L_VAL_BON_COORDINATE         IN VARCHAR2 ,
    L_VAL_BON_DESTINATARIO       IN VARCHAR2 ,
    L_VAL_CAUSA_IMPORTO          IN NUMBER ,
    L_VAL_CIRC_INTESTATARIO      IN VARCHAR2 ,
    L_VAL_CIRC_TRASFERIBILE      IN CHAR ,
    L_VAL_ENTE_PAGATORE          IN VARCHAR2 ,
    L_VAL_FAX                    IN VARCHAR2 ,
    L_VAL_IMPORTO_FM             IN NUMBER ,
    L_VAL_IMPORTO_VALORE         IN NUMBER ,
    L_VAL_INTESTATARIO_CODFISC   IN VARCHAR2 ,
    L_VAL_INTESTATARIO_CONTO     IN VARCHAR2 ,
    L_VAL_INTESTATARIO_PIVA      IN VARCHAR2 ,
    L_VAL_NOTE                   IN VARCHAR2 ,
    L_VAL_NOTE_FM                IN VARCHAR2 ,
    L_VAL_NOTE2                  IN VARCHAR2 ,
    L_VAL_NUMERO_FATTURA         IN VARCHAR2 ,
    L_VAL_NUM_PROFORMA           IN VARCHAR2 ,
    L_VAL_PROF_CAP               IN VARCHAR2 ,
    L_VAL_PROF_COMUNE            IN VARCHAR2 ,
    L_VAL_PROF_FAX               IN VARCHAR2 ,
    L_VAL_PROF_INDIRIZZO         IN VARCHAR2 ,
    L_VAL_PROF_NCIVICO           IN VARCHAR2 ,
    L_VAL_PROF_PROVINCIA         IN VARCHAR2 ,
    L_VAL_RAPPRESENTANTE         IN VARCHAR2 ,
    L_Val_Riferimento_Nominativo IN VARCHAR2 ,
    L_VAL_SPESA_NON_FATTURATA    in varchar2 ,
    UTENTE                       in varchar2,
    l_cod_id_legale in t_mcres_app_sp_spese.cod_id_legale%type default null,
    L_REGIME_IVA                 IN VARCHAR2,
    L_ALIQUOTA_CPA               IN NUMBER,
    L_IMPORTO_CPA                IN NUMBER,
    L_IMPORTO_IVA                IN NUMBER,
    L_IMPORTO_RITENUTA           IN NUMBER,
    L_FLG_RITENUTA_APPLICABILE   IN VARCHAR2,
    L_FLG_FATTURA_DIGITALE       IN VARCHAR2,
    L_IMPORTO_VOCE               IN VARCHAR2,
    L_VAL_ALIQUOTA_RITENUTA      IN NUMBER,
    L_VAL_PERC_RITENUTA          IN NUMBER,
    l_val_wbs                    in t_mcres_app_sp_spese.val_wbs%type default null,
    v_controllo_fattura          out number
  )
  RETURN VARCHAR2;

FUNCTION Fnc_Insert_Azione(
    L_Cod_Autorizzazione IN OUT VARCHAR2,
    L_Cod_Azione VARCHAR2,
    L_Dta_Ins DATE,
    Utente VARCHAR2)
  return varchar2;

    /**************************************************************************************************
******************************************************************************************************/

FUNCTION fnc_aggiorna_stato_spesa(
    p_cod_autorizzazione T_Mcres_App_Sp_Spese.COD_AUTORIZZAZIONE%type,
    p_cod_stato      T_Mcres_App_Sp_Spese.COD_STATO%type,
    p_cod_utente       VARCHAR2,
    p_desc_mot_annul_spesa T_Mcres_App_Sp_Spese.DESC_MOT_ANNUL_SPESA%type DEFAULT NULL,
    p_cod_uo T_Mcres_App_Sp_Spese.COD_UO%type DEFAULT NULL)
  RETURN NUMBER;

/**************************************************************************************************
******************************************************************************************************/

FUNCTION Fnc_Insert_Rapporto_Spesa_con(
    L_COD_CONTROPARTITA      VARCHAR2,
    L_COD_TIPO               VARCHAR2,
    L_COD_DIVISA             VARCHAR2,
    L_VAL_IMPORTO            NUMBER,
    L_COD_FILIALE            VARCHAR2,
    L_COD_AUTORIZZAZIONE     VARCHAR2,
    L_VAL_NUOVA_OPERAZIONE   VARCHAR2,
    L_COD_OPERAZIONE_FATT    VARCHAR2,
    L_COD_PROGR_OPERAZIONE   NUMBER,
    L_DTA_SOLARE_OPERAZIONE  VARCHAR2,
    L_COD_RIFERIMENTO        VARCHAR2,
    L_COD_FILIALE_COMPETENTE VARCHAR2 ,
    L_COD_PRODOTTO           VARCHAR2 ,
    L_COD_RAPPORTO           VARCHAR2 ,
    L_DTA_INS DATE ,
    L_Flg_Tipo_Rapporto VARCHAR2,
    Utente              VARCHAR2)
  return varchar2;

 /********************************************************************************
**********************************************************************************/

FUNCTION fnc_inserisci_rapporto
  (
  P_ID_DPER  t_mcres_app_rapporti.ID_DPER%TYPE,
    P_COD_ABI      t_mcres_app_rapporti.COD_ABI%TYPE,
    P_COD_NDG      t_mcres_app_rapporti.COD_NDG%TYPE,
    P_COD_RAPPORTO t_mcres_app_rapporti.COD_RAPPORTO%TYPE,
    P_COD_SSA      t_mcres_app_rapporti.COD_SSA%TYPE,
    P_DTA_APERTURA_RAPP t_mcres_app_rapporti.DTA_APERTURA_RAPP%TYPE,
    P_DTA_CHIUSURA_RAPP t_mcres_app_rapporti.DTA_CHIUSURA_RAPP%TYPE,
    P_COD_DIVISA  t_mcres_app_rapporti.COD_DIVISA%TYPE,
    P_VAL_IMP_GBV t_mcres_app_rapporti.VAL_IMP_GBV%TYPE,
    P_VAL_IMP_NBV t_mcres_app_rapporti.VAL_IMP_NBV%TYPE,
    P_DTA_NBV t_mcres_app_rapporti.DTA_NBV%TYPE,
    P_VAL_IMP_VANTATO             t_mcres_app_rapporti.VAL_IMP_VANTATO%TYPE,
    P_VAL_IMP_GBV_INIZIALE        t_mcres_app_rapporti.VAL_IMP_GBV_INIZIALE%TYPE,
    P_VAL_IMP_NBV_INIZIALE        t_mcres_app_rapporti.VAL_IMP_NBV_INIZIALE%TYPE,
    P_VAL_IMP_TOT_INCASSI         t_mcres_app_rapporti.VAL_IMP_TOT_INCASSI%TYPE,
    P_FLG_RAPP_FONDO_TERZO        t_mcres_app_rapporti.FLG_RAPP_FONDO_TERZO%TYPE,
    P_FLG_RAPP_CARTOLARIZZATO     t_mcres_app_rapporti.FLG_RAPP_CARTOLARIZZATO%TYPE,
    P_FLG_RAPP_ESTERO            t_mcres_app_rapporti.FLG_RAPP_ESTERO%TYPE,
    P_COD_TIPO_FONDO_TERZO        t_mcres_app_rapporti.COD_TIPO_FONDO_TERZO%TYPE,
    P_VAL_SOCIETA_CARTOLARIZZAZIO t_mcres_app_rapporti.VAL_SOCIETA_CARTOLARIZZAZIONE%TYPE,
    P_COD_ABI_CARTOLARIZZANTE     t_mcres_app_rapporti.COD_ABI_CARTOLARIZZANTE%TYPE,
    P_COD_FORMA_TECNICA          t_mcres_app_rapporti.COD_FORMA_TECNICA%TYPE,
    P_DESC_FORMA_TECNICA          t_mcres_app_rapporti.DESC_FORMA_TECNICA%TYPE,
    P_COD_UO_RAPPORTO             t_mcres_app_rapporti.COD_UO_RAPPORTO%TYPE,
    P_COD_SNDG                    t_mcres_app_rapporti.COD_SNDG%TYPE,
    P_COD_OPERATORE_INS_UPD t_mcres_app_rapporti.COD_OPERATORE_INS_UPD%TYPE,
    P_COD_RAPPORTO_ORIG    t_mcres_app_rapporti.COD_RAPPORTO_ORIG%TYPE
  )
  RETURN NUMBER;

  /********************************************************************************
**********************************************************************************/


FUNCTION FNC_INSERT_DELIBERE
  (
    P_COD_SNDG T_MCRES_APP_DELIBERE.COD_SNDG%type,
    P_ID_DPER t_mcres_app_delibere.id_dper%type,    ---non si usa ma inserito per non modificare codice JAVA
    P_COD_ABI t_mcres_app_delibere.cod_abi%type,
    P_COD_NDG T_MCRES_APP_DELIBERE.COD_NDG%type,
    P_COD_PROTOCOLLO_DELIBERA IN OUT T_MCRES_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA%type,
    P_DTA_INSERIMENTO_DELIBERA T_MCRES_APP_DELIBERE.DTA_INSERIMENTO_DELIBERA%type,
    P_DTA_AGGIORNAMENTO_DELIBERA T_MCRES_APP_DELIBERE.DTA_AGGIORNAMENTO_DELIBERA%type,
    P_COD_DELIBERA                 T_MCRES_APP_DELIBERE.COD_DELIBERA%type,
    P_COD_STATO_DELIBERA           T_MCRES_APP_DELIBERE.COD_STATO_DELIBERA%type,
    P_COD_ORGANO_DELIBERANTE       T_MCRES_APP_DELIBERE.COD_ORGANO_DELIBERANTE%type,
    P_FLG_PRESA_VISIONE            T_MCRES_APP_DELIBERE.FLG_PRESA_VISIONE%type,
    P_VAL_ANNO_PRATICA             T_MCRES_APP_DELIBERE.VAL_ANNO_PRATICA%type,
    P_COD_PRATICA                  T_MCRES_APP_DELIBERE.COD_PRATICA%type,
    P_VAL_ANNO_PROPOSTA            T_MCRES_APP_DELIBERE.VAL_ANNO_PROPOSTA%type,
    P_COD_PROPOSTA                 T_MCRES_APP_DELIBERE.COD_PROPOSTA%type,
    P_COD_PROTOCOLLO_DELIBERA_COLL T_MCRES_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA_COLL%type,
    P_DTA_INS T_MCRES_APP_DELIBERE.DTA_INS%type,
    P_Dta_Upd T_MCRES_APP_DELIBERE.DTA_UPD%type,
    P_COD_OPERATORE_INS_UPD T_MCRES_APP_DELIBERE.COD_OPERATORE_INS_UPD%type,
    P_COD_UO_PRATICA T_MCRES_APP_PRATICHE.COD_UO_PRATICA%type,
    P_UTENTE  T_MCRES_APP_PRATICHE.COD_MATR_PRATICA%type,
    P_DESC_MOTIVAZIONE_FORZATURA                t_mcres_app_delibere.DESC_MOTIVAZIONE_FORZATURA%type default null,
    P_VAL_INDICATORE_ACCANTON     t_mcres_app_delibere.VAL_INDICATORE_ACCANTONAMENTO%type default null,
    P_VAL_UTENTE_AZIONE                 t_mcres_app_delibere.VAL_UTENTE_AZIONE%type default null,
    P_VAL_AUTORITA_GIUDIZIARIA          t_mcres_app_delibere.VAL_AUTORITA_GIUDIZIARIA%type default null,
    P_VAL_OGGETTO_DOMANDA               t_mcres_app_delibere.VAL_OGGETTO_DOMANDA%type default null,
    P_VAL_IMP_DOMANDA                   t_mcres_app_delibere.VAL_IMP_DOMANDA%type default null,
    P_VAL_ACCANT_RISCHI_ONERI           t_mcres_app_delibere.VAL_ACCANT_RISCHI_ONERI%type default null,
    P_VAL_NEW_ACCANT_RISCHI_ONERI       t_mcres_app_delibere.VAL_NEW_ACCANT_RISCHI_ONERI%type default null,
    P_DTA_PREVEDIBILE_ESBORSO           t_mcres_app_delibere.DTA_PREVEDIBILE_ESBORSO%type default null,
    P_FLG_CONTENZIOSO_PASSIVO           t_mcres_app_delibere.FLG_CONTENZIOSO_PASSIVO%type default null,
    P_VAL_EFF_CONTO_ECONOMICO           t_mcres_app_delibere.VAL_EFF_CONTO_ECONOMICO%type default null,
    P_DTA_ESBORSO                       t_mcres_app_delibere.DTA_ESBORSO%type default null,
    P_FLG_STRALCIO                      t_mcres_app_delibere.FLG_STRALCIO%type default null,
    P_VAL_ESPOSIZIONE_LORDA             t_mcres_app_delibere.VAL_ESPOSIZIONE_LORDA%type default null,
    P_VAL_ESPOSIZIONE_NETTA             t_mcres_app_delibere.VAL_ESPOSIZIONE_NETTA%type default null,
    P_VAL_IMP_STRALCIO                  t_mcres_app_delibere.VAL_IMP_STRALCIO%type default null,
    P_DTA_NOTIFICA_ATTO                 t_mcres_app_delibere.DTA_NOTIFICA_ATTO%type default null,
    P_VAL_ESBORSO                       t_mcres_app_delibere.VAL_ESBORSO%type default null,
    P_DTA_SICLI                         t_mcres_app_delibere.DTA_SICLI%type default null,
    P_VAL_UTI                           t_mcres_app_delibere.VAL_UTI%type default null,
    P_VAL_UTI_CAPITALE                  t_mcres_app_delibere.VAL_UTI_CAPITALE%type default null,
    P_VAL_UTI_MORA                      t_mcres_app_delibere.VAL_UTI_MORA%type default null,
    P_VAL_VANTATO                       t_mcres_app_delibere.VAL_VANTATO%type default null,
    P_VAL_VANTATO_RATEO                 t_mcres_app_delibere.VAL_VANTATO_RATEO%type default null,
    P_VAL_VANTATO_STRALCI               t_mcres_app_delibere.VAL_VANTATO_STRALCI%type default null,
    P_VAL_ESP_LORDA_CAPITALE            t_mcres_app_delibere.VAL_ESP_LORDA_CAPITALE%type default null,
    P_VAL_ESP_LORDA_MORA                t_mcres_app_delibere.VAL_ESP_LORDA_MORA%type default null,
    P_VAL_RETT_DA_INCAGLIO              t_mcres_app_delibere.VAL_RETT_DA_INCAGLIO%type default null,
    P_VAL_RETT_DA_INC_STRALCI           t_mcres_app_delibere.VAL_RETT_DA_INC_STRALCI%type default null,
    P_VAL_RETT_VAL_ANTE_DEL             t_mcres_app_delibere.VAL_RETT_VAL_ANTE_DEL%type default null,
    P_VAL_RETT_VAL_ANTE_DEL_FUORI       t_mcres_app_delibere.VAL_RETT_VAL_ANTE_DEL_FUORI%type default null,
    P_VAL_RETT_VAL_ANTE_DEL_RDV         t_mcres_app_delibere.VAL_RETT_VAL_ANTE_DEL_RDV%type default null,
    P_VAL_RETT_VAL_ANTE_DEL_INTER       t_mcres_app_delibere.VAL_RETT_VAL_ANTE_DEL_INTER%type default null,
    P_VAL_RETT_VAL_ANTE_DEL_SPESE       T_MCRES_APP_DELIBERE.VAL_RETT_VAL_ANTE_DEL_SPESE%type default null,
    P_VAL_RETT_VAL_IN_DEL               T_MCRES_APP_DELIBERE.VAL_RETT_VAL_IN_DEL%type default null,
    P_VAL_ESP_LORDA_STRALCIO T_MCRES_APP_DELIBERE.VAL_ESPOSIZIONE_LORDA_STRALCIO%type default null,
    P_VAL_ESP_NETTA_STRALCIO T_MCRES_APP_DELIBERE.VAL_ESPOSIZIONE_NETTA_STRALCIO%type default null,
    P_VAL_NOTE T_MCRES_APP_DELIBERE.VAL_NOTE%type default null,
    P_VAL_ESP_NETTA_ANTE_DEL T_MCRES_APP_DELIBERE.VAL_ESPOSIZIONE_NETTA_ANTE_DEL%type default null,
    P_VAL_ESP_NETTA_POST_DEL T_MCRES_APP_DELIBERE.VAL_ESPOSIZIONE_NETTA_ANTE_DEL%type default null,
    P_DTA_DELIBERA T_MCRES_APP_DELIBERE.DTA_DELIBERA%type default null,
    P_COD_MATR_INS T_MCRES_APP_DELIBERE.COD_MATR_INS%type default null,
    P_VAL_ESPOSIZIONE_LORDA_CAP T_MCRES_APP_DELIBERE.VAL_ESPOSIZIONE_LORDA_CAP%type default null,
    P_VAL_ACCANT_ANTE_DEL T_MCRES_APP_DELIBERE.VAL_ACCANT_ANTE_DEL%type default null,
    P_VAL_RETTIFICA_VALORE_PROP T_MCRES_APP_DELIBERE.VAL_RETTIFICA_VALORE_PROP%type default null,
    P_VAL_IMPORTO_OFFERTO T_MCRES_APP_DELIBERE.VAL_IMPORTO_OFFERTO%type default null,
    P_cod_stato_soff T_MCRES_APP_DELIBERE.COD_STATO_SOFF%type default null,
P_cod_CAUSALE_CHIUSURA         t_mcres_app_delibere.cod_CAUSALE_CHIUSURA%type default null,
P_COD_FILIALE_CLASS            t_mcres_app_delibere.COD_FILIALE_CLASS%type default null,
P_DESC_FILIALE_CLASS           t_mcres_app_delibere.DESC_FILIALE_CLASS%type default null,
P_DESC_ADDETTO                 t_mcres_app_delibere.DESC_ADDETTO%type default null,
P_COD_MATR_PRATICA             t_mcres_app_delibere.COD_MATR_PRATICA%type default null,
P_cod_SEGMENTO                 t_mcres_app_delibere.cod_SEGMENTO%type default null,
P_DTA_PASS_STATO_RISC          t_mcres_app_delibere.DTA_PASS_STATO_RISC%type default null,
P_cod_STATO_RISCHIO            t_mcres_app_delibere.cod_STATO_RISCHIO%type default null,
P_DTA_INCAGLIO                 t_mcres_app_delibere.DTA_INCAGLIO%type default null,
P_cod_STATO_PC                 t_mcres_app_delibere.cod_STATO_PC%type default null,
P_DTA_STATO_GIUR               t_mcres_app_delibere.DTA_STATO_GIUR%type default null,
P_val_CODICE_CR                t_mcres_app_delibere.val_CODICE_CR%type default null,
P_cod_RAMO                     t_mcres_app_delibere.cod_RAMO%type default null,
P_cod_SETTORE                  t_mcres_app_delibere.cod_SETTORE%type default null,
P_DESC_RAMO                    t_mcres_app_delibere.DESC_RAMO%type default null,
P_DESC_SETTORE                 t_mcres_app_delibere.DESC_SETTORE%type default null,
P_COD_PARTITA_IVA              t_mcres_app_delibere.COD_PARTITA_IVA%type default null,
P_val_ESPOS_LORDA_TOT          t_mcres_app_delibere.val_ESPOS_LORDA_TOT%type default null,
P_val_IMPORTO_SACRIFICIO       t_mcres_app_delibere.val_IMPORTO_SACRIFICIO%type default null,
P_val_NOTE_flusso              t_mcres_app_delibere.val_NOTE_flusso%type default null,
P_cod_TIPO_TRANSAZIONE         t_mcres_app_delibere.cod_TIPO_TRANSAZIONE%type default null,
P_val_VANTATO_NOCONT           t_mcres_app_delibere.val_VANTATO_NOCONT%type default null,
P_COD_FISCALE                  t_mcres_app_delibere.COD_FISCALE%type default null,
P_cod_TIPO_STRALCIO            t_mcres_app_delibere.cod_TIPO_STRALCIO%type default null,
P_FLG_IND_GARANTI              t_mcres_app_delibere.FLG_IND_GARANTI%type default null,
P_val_NOTE_DESC_ANN            t_mcres_app_delibere.val_NOTE_DESC_ANN%type default null,
P_DTA_AGG_SISBA                t_mcres_app_delibere.DTA_AGG_SISBA%type default null,
P_val_VANTATO_SISBA            t_mcres_app_delibere.val_VANTATO_SISBA%type default null,
P_val_MORA_SISBA               t_mcres_app_delibere.val_MORA_SISBA%type default null,
P_val_STRALCI_FISC_SOFF        t_mcres_app_delibere.val_STRALCI_FISC_SOFF%type default null,
P_val_UTILIZZO_SISBA           t_mcres_app_delibere.val_UTILIZZO_SISBA%type default null,
P_val_ACCTI_SISBA              t_mcres_app_delibere.val_ACCTI_SISBA%type default null,
P_val_ATTUALIZ_SISBA           t_mcres_app_delibere.val_ATTUALIZ_SISBA%type default null,
P_val_STRAL_QT_CAP_SISBA       t_mcres_app_delibere.val_STRAL_QT_CAP_SISBA%type default null,
P_val_STRAL_QT_MORA_SISBA      t_mcres_app_delibere.val_STRAL_QT_MORA_SISBA%type default null,
P_val_CAPITALE_SISBA           t_mcres_app_delibere.val_CAPITALE_SISBA%type default null,
P_val_UTILIZZO_SICLI           t_mcres_app_delibere.val_UTILIZZO_SICLI%type default null,
P_val_CAPITALE_SICLI           t_mcres_app_delibere.val_CAPITALE_SICLI%type default null,
P_val_MORA_SICLI               t_mcres_app_delibere.val_MORA_SICLI%type default null,
P_DTA_AGG_SICLI                t_mcres_app_delibere.DTA_AGG_SICLI%type default null,
P_val_ESPOS_LORDA_QT_MORA      t_mcres_app_delibere.val_ESPOS_LORDA_QT_MORA%type default null,
P_val_RDV_QC_DA_INCAGLIO       t_mcres_app_delibere.val_RDV_QC_DA_INCAGLIO%type default null,
P_val_PERC_RETT_VAL            t_mcres_app_delibere.val_PERC_RETT_VAL%type default null,
P_DTA_SCADENZA                 t_mcres_app_delibere.DTA_SCADENZA%type default null,
P_DTA_DEL_ESTERA               t_mcres_app_delibere.DTA_DEL_ESTERA%type default null,
P_DTA_SCAD_DEL_ESTERA          t_mcres_app_delibere.DTA_SCAD_DEL_ESTERA%type default null,
P_val_PERC_DUBBIO_ESITO_EST    t_mcres_app_delibere.val_PERC_DUBBIO_ESITO_EST%type default null,
P_val_RETT_QT_CAP_ANTE98       t_mcres_app_delibere.val_RETT_QT_CAP_ANTE98%type default null,
P_val_RETT_QT_CAP_PROGR        t_mcres_app_delibere.val_RETT_QT_CAP_PROGR%type default null,
P_val_INTERES_CORR             t_mcres_app_delibere.val_INTERES_CORR%type default null,
P_val_SPESE_LEGALI             t_mcres_app_delibere.val_SPESE_LEGALI%type default null,
P_val_ESPOS_LORDA_CAP_MORA     t_mcres_app_delibere.val_ESPOS_LORDA_CAP_MORA%type default null,
P_val_ACCTI_DELIB              t_mcres_app_delibere.val_ACCTI_DELIB%type default null,
P_DTA_STAMPA                   t_mcres_app_delibere.DTA_STAMPA%type default null,
P_DTA_SCADENZA_TRANSAZIONE     t_mcres_app_delibere.DTA_SCADENZA_TRANSAZIONE%type default null,
p_val_gruppo t_mcres_app_delibere.val_gruppo%type default null,
p_cod_uo t_mcres_app_delibere.cod_uo%type default null,
p_val_causale t_mcres_app_delibere.val_causale%type default null
  )
  RETURN number;

FUNCTION fnc_insert_contropartita(
    L_COD_CONTROPARTITA IN OUT VARCHAR2,
    L_COD_TIPO              VARCHAR2,
    L_COD_DIVISA            VARCHAR2,
    L_VAL_IMPORTO           NUMBER,
    L_COD_FILIALE           VARCHAR2,
    L_COD_AUTORIZZAZIONE    VARCHAR2,
    L_VAL_NUOVA_OPERAZIONE  VARCHAR2,
    L_COD_OPERAZIONE_FATT   VARCHAR2,
    L_COD_PROGR_OPERAZIONE  NUMBER,
    L_Dta_Solare_Operazione VARCHAR2,
    L_Cod_Riferimento       VARCHAR2,
    L_Dta_Ins DATE,
    Utente VARCHAR2)
  return varchar2;

-- Funzione inserimento rapporto spesa
FUNCTION Fnc_Insert_Rapporto_Spesa
  (
    P_COD_RAPPORTO           T_MCRES_APP_SP_RAPPORTO.COD_RAPPORTO%type,
    P_COD_CONTROPARTITA      T_MCRES_APP_SP_RAPPORTO.COD_CONTROPARTITA%type,
    P_COD_FILIALE_COMPETENTE T_MCRES_APP_SP_RAPPORTO.COD_FILIALE_COMPETENTE%type,
    P_DTA_INS T_MCRES_APP_SP_RAPPORTO.DTA_INS%type,
    P_FLG_TIPO_RAPPORTO T_MCRES_APP_SP_RAPPORTO.FLG_TIPO_RAPPORTO%type,
    P_COD_PRODOTTO      T_MCRES_APP_SP_RAPPORTO.COD_PRODOTTO%type,
    p_utente              T_MCRES_APP_PRATICHE.COD_MATR_PRATICA%type
  )
  RETURN VARCHAR2;

-- funzione aggiornamento stato delibere
function FNC_MCRES_UPDATE_STATO_DELIBER(
    P_COD_ABI                   T_MCRES_APP_DELIBERE.COD_ABI%type,
    P_COD_NDG                   T_MCRES_APP_DELIBERE.COD_NDG%type,
    P_COD_PROTOCOLLO_DELIBERA   T_MCRES_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA%type,
    P_COD_STATO_DELIBERA        T_MCRES_APP_DELIBERE.COD_STATO_DELIBERA%type,
    P_UTENTE                    T_MCRES_APP_PRATICHE.COD_MATR_PRATICA%type,
    P_NOTE_ANNULLAMENTO         T_MCRES_APP_DELIBERE.VAL_NOTE_ANNULLAMENTO%type default null,
    p_cod_uo                    T_MCRES_APP_DELIBERE.COD_UO%type default null,
    p_dta_retrocessione   t_mcres_app_delibere.dta_retrocessione%type default null)
  RETURN VARCHAR2;

function FNC_MCRES_COD_PROTOCOLLO_NULLA(
    P_COD_AUTORIZZAZIONE T_MCRES_APP_CODICI_PROTOCOLLO.COD_AUTORIZZAZIONE%type,
    P_COD_CONTROPARTITA  T_MCRES_APP_CODICI_PROTOCOLLO.COD_CONTROPARTITA%type,
    P_DTA_INS        in OUT T_MCRES_APP_CODICI_PROTOCOLLO.DTA_INS%type,
    P_COD_PROTOCOLLO in OUT T_MCRES_APP_CODICI_PROTOCOLLO.COD_PROTOCOLLO%type,
    P_COD_MATR_PRATICA T_MCRES_APP_PRATICHE.COD_MATR_PRATICA%type)
  RETURN VARCHAR2;

FUNCTION FNC_AGGIORNA_MOVIMENTO_KEY(
    L_Cod_Contropartita     VARCHAR2,
    L_Cod_Operazione_Fatt   VARCHAR2,
    L_Dta_Solare_Operazione VARCHAR2,
    L_Cod_Progr_Operazione  NUMBER,
    L_Val_Nuova_Operazione  VARCHAR2,
    Utente                  VARCHAR2 )
  return varchar2;

function fnc_mcres_popola_stime
(
   p_cod_abi                         in t_mcrei_app_stime.cod_abi%type,
   p_cod_sndg                        in t_mcrei_app_stime.cod_sndg%type,
   p_cod_ndg                         in t_mcrei_app_stime.cod_ndg%type,
   p_cod_rapporto                    in t_mcrei_app_stime.cod_rapporto%type,
   p_dta_stima                       in t_mcrei_app_stime.dta_stima%type,
   p_desc_causa_prev_recupero        in t_mcrei_app_stime.desc_causa_prev_recupero%type,
   p_flg_recupero_tot                in t_mcrei_app_stime.flg_recupero_tot%type,
   p_cod_uo_stima                    in t_mcrei_app_stime.cod_uo_stima%type,
   p_val_imp_prev_pregr              in t_mcrei_app_stime.val_imp_prev_pregr%type,
   p_val_imp_prev_att                in t_mcrei_app_stime.val_imp_prev_att%type,
   p_val_prev_recupero               in t_mcrei_app_stime.val_prev_recupero%type,
   p_val_esposizione                 in t_mcrei_app_stime.val_esposizione%type,
   p_val_rdv_tot                     in t_mcrei_app_stime.val_rdv_tot%type,
   p_val_imp_rettifica_pregr         in t_mcrei_app_stime.val_imp_rettifica_pregr%type,
   p_val_imp_rettifica_att           in t_mcrei_app_stime.val_imp_rettifica_att%type,
   p_flg_tipo_dato                   in t_mcrei_app_stime.flg_tipo_dato%type,
   p_cod_utente                      in t_mcrei_app_stime.cod_utente%type,
   p_val_attualizzato                in t_mcrei_app_stime.val_attualizzato%type,
   p_flg_pres_piano                  in t_mcrei_app_stime.flg_pres_piano%type,
   p_cod_tipo_rapporto               in t_mcrei_app_stime.cod_tipo_rapporto%type,
   p_cod_protocollo_delibera         in t_mcrei_app_stime.cod_protocollo_delibera%type,
   p_cod_classe_ft                   in t_mcrei_app_stime.cod_classe_ft%type,
   p_flg_ristrutturato               in t_mcrei_app_stime.flg_ristrutturato%type,
   p_val_utilizzato_netto            in t_mcrei_app_stime.val_utilizzato_netto%type,
   p_val_utilizzato_mora             in t_mcrei_app_stime.val_utilizzato_mora%type,
   p_val_perc_rett_rapporto          in t_mcrei_app_stime.val_perc_rett_rapporto%type,
   p_val_accordato                   in t_mcrei_app_stime.val_accordato%type,
   p_cod_microtipologia_delibera     in t_mcrei_app_stime.cod_microtipologia_delibera%type,
   p_cod_npe                         in t_mcrei_app_stime.cod_npe%type,
   p_flg_tipo_rapporto               in t_mcrei_app_stime.flg_tipo_rapporto%type,
   p_cod_forma_tecnica               in t_mcrei_app_stime.cod_forma_tecnica%type,
   p_dta_iniz_segnalazione_ristr     in t_mcrei_app_stime.dta_inizio_segnalazione_ristr%type,
   p_dta_fine_segnalazione_ristr     in t_mcrei_app_stime.dta_fine_segnalazione_ristr%type,
   p_dta_decorrenza_stato            in t_mcrei_app_stime.dta_decorrenza_stato%type,
   p_dta_rettifica_incaglio          in date,
   p_flg_asterisco                   in varchar2
)
return number;

function fnc_mcres_popola_piani (
    p_cod_abi                   in t_mcrei_app_piani_rientro.cod_abi%type,
    p_cod_sndg                  in t_mcrei_app_piani_rientro.cod_sndg%type,
    p_cod_ndg                   in t_mcrei_app_piani_rientro.cod_ndg%type,
    p_cod_rapporto              in t_mcrei_app_piani_rientro.cod_rapporto%type,
    p_dta_stima                 in t_mcrei_app_piani_rientro.dta_stima%type,
    p_num_rata                  in t_mcrei_app_piani_rientro.num_rata%type,
    p_dta_scadenza_rata         in t_mcrei_app_piani_rientro.dta_scadenza_rata%type,
    p_val_rata                  in t_mcrei_app_piani_rientro.val_rata%type,
    p_dta_ins_piano             in t_mcrei_app_piani_rientro.dta_ins_piano%type,
    p_dta_upd_piano             in t_mcrei_app_piani_rientro.dta_upd_piano%type,
    p_cod_utente                in t_mcrei_app_piani_rientro.cod_utente%type,
    p_cod_protocollo_delibera   in t_mcrei_app_piani_rientro.cod_protocollo_delibera%type,
    p_cod_forma_tecnica         in t_mcrei_app_piani_rientro.cod_forma_tecnica%type,
    p_flg_annullato             in t_mcrei_app_piani_rientro.flg_annullato% type default 0
)
return number;

function fnc_mcres_set_cod_od_calcolato
(
    p_cod_abi                   in  t_mcres_app_delibere.cod_abi%type,
    p_cod_ndg                   in  t_mcres_app_delibere.cod_ndg%type,
    p_cod_protocollo_delibera   in  t_mcres_app_delibere.cod_protocollo_delibera%type,
    p_cod_od_calcolato          in  t_mcres_app_delibere.cod_od_calcolato%type,
    p_cod_utente                in  t_mcres_app_delibere.cod_operatore_ins_upd%type,
    p_FLG_STEP5_ACTIVE          in  t_mcres_app_delibere.FLG_STEP5_ACTIVE%type default null
)
return number;

/********************************************************************************
**********************************************************************************/

FUNCTION fnc_mcres_chiusura_rapporto (
   p_cod_abi        IN   t_mcres_app_rapporti.cod_abi%TYPE,
   p_cod_ndg        IN   t_mcres_app_rapporti.cod_ndg%TYPE,
   p_cod_rapporto   IN   t_mcres_app_rapporti.cod_rapporto%TYPE,
   p_cod_utente     IN   VARCHAR2
)
   RETURN NUMBER;

FUNCTION fnc_mcres_gestione_legali (
   p_flg_opz                   IN   VARCHAR2,
   p_cod_utente                IN   t_mcres_app_legali_esterni.cod_operatore_ins_upd%TYPE,
   p_cod_sap_fornitore         IN   t_mcres_app_legali_esterni.cod_sap_fornitore%TYPE,
   p_cod_abi                   IN   t_mcres_app_legali_esterni.cod_abi%TYPE,
   p_cod_presidio              IN   t_mcres_app_legali_esterni.cod_presidio%TYPE DEFAULT NULL,
   p_val_legale_cognome        IN   t_mcres_app_legali_esterni.val_legale_cognome%TYPE DEFAULT NULL,
   p_val_legale_nome           IN   t_mcres_app_legali_esterni.val_legale_nome%TYPE DEFAULT NULL,
   p_val_legale_codfisc        IN   t_mcres_app_legali_esterni.val_legale_codfisc%TYPE DEFAULT NULL,
   p_val_legale_piva           IN   t_mcres_app_legali_esterni.val_legale_piva%TYPE DEFAULT NULL,
   p_val_legale_piva_ue        IN   t_mcres_app_legali_esterni.val_legale_piva_ue%TYPE DEFAULT NULL,
   p_val_legale_piva_extra_ue  IN   t_mcres_app_legali_esterni.val_legale_piva_extra_ue%TYPE DEFAULT NULL,
   p_val_legale_indirizzo      IN   t_mcres_app_legali_esterni.val_legale_indirizzo%TYPE DEFAULT NULL,
   p_val_legale_citta          IN   t_mcres_app_legali_esterni.val_legale_citta%TYPE DEFAULT NULL,
   p_val_legale_prov           IN   t_mcres_app_legali_esterni.val_legale_prov%TYPE DEFAULT NULL,
   p_val_legale_cap            IN   t_mcres_app_legali_esterni.val_legale_cap%TYPE DEFAULT NULL,
   p_val_legale_telef          IN   t_mcres_app_legali_esterni.val_legale_telef%TYPE DEFAULT NULL,
   p_val_legale_fax            IN   t_mcres_app_legali_esterni.val_legale_fax%TYPE DEFAULT NULL,
   p_val_legale_email          IN   t_mcres_app_legali_esterni.val_legale_email%TYPE DEFAULT NULL,
   p_val_legale_abi            IN   t_mcres_app_legali_esterni.val_legale_abi%TYPE DEFAULT NULL,
   p_val_legale_cab            IN   t_mcres_app_legali_esterni.val_legale_cab%TYPE DEFAULT NULL,
   p_val_legale_conto          IN   t_mcres_app_legali_esterni.val_legale_conto%TYPE DEFAULT NULL,
   p_val_legale_cin            IN   t_mcres_app_legali_esterni.val_legale_cin%TYPE DEFAULT NULL,
   p_cod_specializzazione      IN   t_mcres_app_legali_esterni.cod_specializzazione%TYPE DEFAULT NULL,
   p_val_legale_ind_proc_gen   IN   t_mcres_app_legali_esterni.val_legale_ind_proc_gen%TYPE DEFAULT NULL,
   p_dta_procura_gen           IN   t_mcres_app_legali_esterni.dta_procura_gen%TYPE DEFAULT NULL,
   p_cod_num_repertorio_pg     IN   t_mcres_app_legali_esterni.cod_num_repertorio_pg%TYPE DEFAULT NULL,
   p_val_nominativo_notaio     IN   t_mcres_app_legali_esterni.val_nominativo_notaio%TYPE DEFAULT NULL,
   p_val_note                  IN   t_mcres_app_legali_esterni.val_note%TYPE DEFAULT NULL,
   p_flg_obbligo_autoriz       IN   t_mcres_app_legali_esterni.flg_obbligo_autoriz%TYPE DEFAULT NULL,
   p_flg_visualizza            IN   t_mcres_app_legali_esterni.flg_visualizza%TYPE DEFAULT NULL,
   p_cod_citta                 IN   t_mcres_app_legali_esterni.cod_citta%TYPE DEFAULT NULL,
   p_val_iban1                 IN   t_mcres_app_legali_esterni.val_iban1%TYPE DEFAULT NULL,
   p_val_iban2                 IN   t_mcres_app_legali_esterni.val_iban2%TYPE DEFAULT NULL,
   p_val_iban3                 IN   t_mcres_app_legali_esterni.val_iban3%TYPE DEFAULT NULL,
   p_val_iban4                 IN   t_mcres_app_legali_esterni.val_iban4%TYPE DEFAULT NULL,
   p_val_iban5                 IN   t_mcres_app_legali_esterni.val_iban5%TYPE DEFAULT NULL,
   p_val_iban6                 IN   t_mcres_app_legali_esterni.val_iban6%TYPE DEFAULT NULL,
   p_val_iban7                 IN   t_mcres_app_legali_esterni.val_iban7%TYPE DEFAULT NULL,
   p_val_iban8                 IN   t_mcres_app_legali_esterni.val_iban8%TYPE DEFAULT NULL,
   p_val_iban9                 IN   t_mcres_app_legali_esterni.val_iban9%TYPE DEFAULT NULL,
   p_val_iban10                IN   t_mcres_app_legali_esterni.val_iban10%TYPE DEFAULT NULL,
   p_flg_albo                  IN   t_mcres_app_legali_esterni.flg_albo%TYPE DEFAULT NULL,
   p_flg_convenz               IN   t_mcres_app_legali_esterni.flg_convenz%TYPE DEFAULT NULL,
   p_val_autorizzazione_cens   IN   t_mcres_app_legali_esterni.val_autorizzazione_cens%TYPE DEFAULT NULL,
   p_dta_autorizzazione_cens   IN   t_mcres_app_legali_esterni.dta_autorizzazione_cens%TYPE DEFAULT NULL,
   p_val_note_albo_conv        IN   t_mcres_app_legali_esterni.val_note_albo_conv%TYPE DEFAULT NULL,
   p_dta_inizio_albo           IN   t_mcres_app_legali_esterni.dta_inizio_albo%TYPE DEFAULT NULL,
   p_dta_inizio_convenz        IN   t_mcres_app_legali_esterni.dta_inizio_convenz%TYPE DEFAULT NULL,
   p_dta_fine_albo             IN   t_mcres_app_legali_esterni.dta_fine_albo%TYPE DEFAULT NULL,
   p_dta_fine_convenz          IN   t_mcres_app_legali_esterni.dta_fine_convenz%TYPE DEFAULT NULL,
   P_COD_ID_CONTRATTO          IN   t_mcres_app_legali_esterni.COD_ID_CONTRATTO%TYPE DEFAULT NULL,
   P_DTA_CONTRATTO             IN   t_mcres_app_legali_esterni.DTA_CONTRATTO%TYPE DEFAULT NULL,
   P_DTA_SCAD_CONTRATTO        IN   t_mcres_app_legali_esterni.DTA_SCAD_CONTRATTO%TYPE DEFAULT NULL,
   P_COD_ID_CONVENZIONE        IN   t_mcres_app_legali_esterni.COD_ID_CONVENZIONE%TYPE DEFAULT NULL,
   P_DTA_SCAD_CONVENZIONE      IN   t_mcres_app_legali_esterni.DTA_SCAD_CONVENZIONE%TYPE DEFAULT NULL,
   P_VAL_FORO1                 IN   t_mcres_app_legali_esterni.VAL_FORO1%TYPE DEFAULT NULL,
   P_VAL_FORO2                 IN   t_mcres_app_legali_esterni.VAL_FORO2%TYPE DEFAULT NULL,
   P_VAL_FORO3                 IN   t_mcres_app_legali_esterni.VAL_FORO3%TYPE DEFAULT NULL,
   P_VAL_FORO4                 IN   t_mcres_app_legali_esterni.VAL_FORO4%TYPE DEFAULT NULL,
   P_COD_USER_ID               IN   t_mcres_app_legali_esterni.COD_USER_ID%TYPE DEFAULT NULL
)
   RETURN NUMBER;

   FUNCTION fnc_mcres_fornitori_legali (P_REC IN F_SLAVE_PAR_TYPE)
   RETURN NUMBER;

      /**************************************************************************************************
******************************************************************************************************/

FUNCTION FNC_SET_SP_PRESA_VISIONE(
    p_cod_autorizzazione T_Mcres_App_Sp_Spese.COD_AUTORIZZAZIONE%type,
    p_cod_utente       VARCHAR2,
    p_cod_tipo_utente  VARCHAR2)
  RETURN NUMBER;

/**************************************************************************************************
******************************************************************************************************/


-- 20121030 Andrea Galliano
function fnc_mcres_popola_documenti
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

--
function fnc_mcres_popola_top_30_nt
(
    p_id_dper                   in t_mcres_app_top_30_nt_web.id_dper%type,
    p_cod_abi                   in t_mcres_app_top_30_nt_web.cod_abi%type,
    p_cod_gruppo_economico      in t_mcres_app_top_30_nt_web.cod_gruppo_economico%type,
    p_desc_gruppo_economico     in t_mcres_app_top_30_nt_web.desc_gruppo_economico%type,
    p_cod_sndg                  in t_mcres_app_top_30_nt_web.cod_sndg%type,
    p_desc_cliente              in t_mcres_app_top_30_nt_web.desc_cliente%type,
    p_cod_stato_rischio         in t_mcres_app_top_30_nt_web.cod_stato_rischio%type,
    p_dta_decorrenza_stato      in t_mcres_app_top_30_nt_web.dta_decorrenza_stato%type,
    p_val_gbv                   in t_mcres_app_top_30_nt_web.val_gbv%type,
    p_val_nbv                   in t_mcres_app_top_30_nt_web.val_nbv%type,
    p_val_vantato               in t_mcres_app_top_30_nt_web.val_vantato%type,
    p_val_garanzie_reali        in t_mcres_app_top_30_nt_web.val_garanzie_reali%type,
    p_val_garanzie_personali    in t_mcres_app_top_30_nt_web.val_garanzie_personali%type,
    p_cod_stato_giudirico_prev  in t_mcres_app_top_30_nt_web.cod_stato_giudirico_prev%type,
    p_cod_utente                in t_mcres_app_top_30_nt_web.cod_operatore_ins_upd%type
)
return number;

function fnc_set_od_calcolato_sp_spese
(
    p_cod_autorizzazione        in  t_mcres_app_sp_spese.cod_autorizzazione%type,
    p_cod_od_calcolato          in  t_mcres_app_sp_spese.cod_od_calcolato%type,
    p_cod_utente                in  t_mcres_app_sp_spese.cod_operatore_ins_upd%type
)
return number;


function FNC_MCRES_UPDATE_DELIBERE_NS (
    P_REC IN F_SLAVE_PAR_TYPE
)return number;


function fnc_aggiorna_parametri_alert
(
    p_id_alert              in t_mcres_app_gestione_alert.id_alert%type,
    p_val_soglia_verde      in t_mcres_app_gestione_alert.val_next_green%type,
    p_val_soglia_arancio    in t_mcres_app_gestione_alert.val_next_orange%type,
    p_cod_utente            in t_mcres_wrk_audit_applicativo.utente%type,
    p_desc_alert            in t_mcres_app_alert_ruoli.desc_alert%type                  default null
)
return number;


function fnc_aggiorna_istituti
(
    p_cod_abi                   in t_mcre0_app_istituti_all.cod_abi%type,
    p_flg_outsourcing_drc       in t_mcre0_app_istituti_all.flg_outsourcing_drc%type,
    p_flg_cessione_rout         in t_mcre0_app_istituti_all.flg_cessione_rout%type,
    p_flg_tipo_abi              in t_mcre0_app_istituti_all.flg_tipo_abi%type,
    p_val_ordine                in t_mcre0_app_istituti_all.val_ordine%type,
    p_val_ind_struttura         in t_mcre0_app_istituti_all.val_ind_struttura%type,
    p_val_struttura_cap         in t_mcre0_app_istituti_all.val_struttura_cap%type,
    p_val_struttura_citta       in t_mcre0_app_istituti_all.val_struttura_citta%type,
    p_val_struttura_provincia   in t_mcre0_app_istituti_all.val_struttura_provincia%type,
    p_val_ind_sede_legale       in t_mcre0_app_istituti_all.val_ind_sede_legale%type,
    p_val_sede_l_cap            in t_mcre0_app_istituti_all.val_sede_l_cap%type,
    p_val_sede_l_citta          in t_mcre0_app_istituti_all.val_sede_l_citta%type,
    p_val_sede_l_provincia      in t_mcre0_app_istituti_all.val_sede_l_provincia%type,
    p_flg_servicing_itf         in t_mcre0_app_istituti_all.flg_servicing_itf%type,
    p_cod_utente                in t_mcres_wrk_audit_applicativo.utente%type
)
return number;


function fnc_popola_centri_costo
(
    p_cod_abi               in t_mcres_cnf_fatture_sap.cod_abi%type,
    p_val_spesa_rip         in t_mcres_cnf_fatture_sap.val_spesa_rip%type,
    p_val_spesa_non_rip     in t_mcres_cnf_fatture_sap.val_spesa_non_rip%type,
    p_cod_uo                in t_mcres_cnf_fatture_sap.cod_uo%type,
    p_val_cdc_banca         in t_mcres_cnf_fatture_sap.val_cdc_banca%type,
    p_val_ce_contropartita  in t_mcres_cnf_fatture_sap.val_ce_contropartita%type,
    p_val_ente_dc_am        in t_mcres_cnf_fatture_sap.val_ente_dc_am%type,
    p_val_cdc_itf           in t_mcres_cnf_fatture_sap.val_cdc_itf%type,
    p_cod_utente            in t_mcres_wrk_audit_applicativo.utente%type,
    p_flg_attivo            in t_mcres_cnf_fatture_sap.flg_attivo%type default 1
)
return number;


function fnc_popola_organi_deliberanti
(
    p_cod_operazione        in varchar2,    -- I insert, U Update
    p_cod_abi               in t_mcres_cl_organo_deliberante.cod_abi%type,
    p_cod_istituto          in t_mcres_cl_organo_deliberante.cod_istituto%type,
    p_cod_uo                in t_mcres_cl_organo_deliberante.cod_uo%type,
    p_cod_od                in t_mcres_cl_organo_deliberante.cod_organo_deliberante%type,
    p_dta_inizio            in t_mcres_cl_organo_deliberante.dta_inizio%type,   -- serve per controllo su chiave primaria
    p_dta_scadenza          in t_mcres_cl_organo_deliberante.dta_scadenza%type,
    p_desc_od               in t_mcres_cl_organo_deliberante.desc_organo_deliberante%type,
    p_desc_responsabile     in t_mcres_cl_organo_deliberante.desc_responsabile%type,
    p_cod_utente            in t_mcres_wrk_audit_applicativo.utente%type,
    p_dta_inizio_upd        in t_mcres_cl_organo_deliberante.dta_inizio%type default null   -- per aggiornamemnto campo chiave
)
return number;


function fnc_gestione_scadenzario
(
    p_cod_tipo_scadenza         in t_mcres_app_scadenzario.cod_tipo_scadenza%type,
    p_val_gg_succ_new           in t_mcres_app_scadenzario.val_gg_succ_new%type,
    p_val_gg_prec_new           in t_mcres_app_scadenzario.val_gg_prec_new%type,
    p_val_limite_scadenza_new   in t_mcres_app_scadenzario.val_limite_scadenza_new%type,
    p_cod_utente                in t_mcres_wrk_audit_applicativo.utente%type
)
return number;

function fnc_gestione_proroghe
(
    p_cod_abi t_mcres_app_proroghe.cod_abi%type,
    p_cod_protocollo t_mcres_app_proroghe.cod_protocollo%type,
    p_dta_isrt_proroga t_mcres_app_proroghe.dta_isrt_proroga%type,
    p_dta_proroga t_mcres_app_proroghe.dta_proroga%type,
    p_cod_stato_proroga t_mcres_app_proroghe.cod_stato_proroga%type,
    p_val_note_proroga t_mcres_app_proroghe.val_note_proroga%type,
    p_cod_org_delib_proroga t_mcres_app_proroghe.cod_org_delib_proroga%type,
    p_dta_aggiorn t_mcres_app_proroghe.dta_aggiorn%type,
    p_val_timestamp_agg_tab t_mcres_app_proroghe.val_timestamp_agg_tab%type,
    p_cod_utente                in t_mcres_wrk_audit_applicativo.utente%type,
    p_commento_esteso t_mcres_app_proroghe.val_comm_esteso%type
)return number;

function fnc_gestione_rapp_delibere
(
    p_cod_abi t_mcres_app_rapporti_delibere.cod_abi%type,
    p_cod_protocollo t_mcres_app_rapporti_delibere.cod_protocollo%type,
    p_cod_uo_cntrt                              t_mcres_app_rapporti_delibere.cod_uo_cntrt%type         ,
   p_cod_prod_cntrt              t_mcres_app_rapporti_delibere.cod_prod_cntrt%type       ,
   p_val_num_id_cntrt            t_mcres_app_rapporti_delibere.val_num_id_cntrt%type     ,
   p_flg_ins_man                 t_mcres_app_rapporti_delibere.flg_ins_man%type          ,
   p_dta_agg_rapp                t_mcres_app_rapporti_delibere.dta_agg_rapp%type         ,
   p_val_imp_utiliz              t_mcres_app_rapporti_delibere.val_imp_utiliz%type       ,
   p_val_imp_esp_qc              t_mcres_app_rapporti_delibere.val_imp_esp_qc%type       ,
   p_val_imp_int_mora            t_mcres_app_rapporti_delibere.val_imp_int_mora%type     ,
   p_val_debito_res              t_mcres_app_rapporti_delibere.val_debito_res%type       ,
   p_val_qc_sisba                t_mcres_app_rapporti_delibere.val_qc_sisba%type         ,
   p_val_imp_vantato             t_mcres_app_rapporti_delibere.val_imp_vantato%type      ,
   p_val_imp_utiliz_mod          t_mcres_app_rapporti_delibere.val_imp_utiliz_mod%type   ,
   p_val_imp_vantato_mod         t_mcres_app_rapporti_delibere.val_imp_vantato_mod%type  ,
   p_val_imp_operaz              t_mcres_app_rapporti_delibere.val_imp_operaz%type       ,
   p_val_imp_qc_operaz           t_mcres_app_rapporti_delibere.val_imp_qc_operaz%type    ,
   p_val_ind_contabil            t_mcres_app_rapporti_delibere.val_ind_contabil%type     ,
   p_cod_filiale_pv              t_mcres_app_rapporti_delibere.cod_filiale_pv%type       ,
   p_flg_selez                   t_mcres_app_rapporti_delibere.flg_selez%type            ,
   p_val_STR_FISCQTA_CAP   t_mcres_app_rapporti_delibere.val_STR_FISCQTA_CAP%type,
    p_val_STR_FISCQTA_INT   t_mcres_app_rapporti_delibere.val_STR_FISCQTA_INT%type,
    p_val_QT_INT_MOR_ANRIS   t_mcres_app_rapporti_delibere.val_QT_INT_MOR_ANRIS%type,
    p_val_CUI_RATEO_MORA   t_mcres_app_rapporti_delibere.val_CUI_RATEO_MORA%type,
    p_val_ATTUALIZ   t_mcres_app_rapporti_delibere.val_ATTUALIZ%type,
    p_cod_NSG_CART_SISBA t_mcres_app_rapporti_delibere.cod_NSG_CART_SISBA%type,
    p_DESC_CART_SISBA t_mcres_app_rapporti_delibere.DESC_CART_SISBA%type,
    p_cod_ABI_CART_SISBA t_mcres_app_rapporti_delibere.cod_ABI_CART_SISBA%type,
    p_cod_ndg  t_mcres_app_rapporti_delibere.cod_ndg%type,
    p_cod_utente                in t_mcres_wrk_audit_applicativo.utente%type
)
return number;


function FNC_SET_DTA_ATTESA_ITF (
  P_COD_ABI T_MCRES_APP_SPESE_ITF.COD_ABI%type,
  P_COD_FISCALE T_MCRES_APP_SPESE_ITF.VAL_AFAVORE_CODFISC%type,
  P_PIVA T_MCRES_APP_SPESE_ITF.VAL_AFAVORE_PIVA%type,
  P_COD_UTENTE T_MCRES_APP_SPESE_ITF.COD_OPERATORE_INS_UPD%type,
  P_MOD VARCHAR2
)  RETURN NUMBER;

function fnc_chk_interf_sap(
    p_id_regola t_mcres_app_chk_interf_sap.id_regola%type,
    p_cod_autorizzazione t_mcres_app_sp_spese.cod_autorizzazione%type
)return number;

function fnc_pag_sap_inviato_itf return number;
function fnc_esiti_sap_inviato_itf return number;
function fnc_statowi_sap_inviato_itf return number;

function fnc_accensione_soff(
  P_FLG_OPERAZ IN VARCHAR2,
  P_ID T_MCRES_APP_ACC_SOFF.ID%type,
  P_MATRICOLA T_MCRES_APP_ACC_SOFF.MATR_INS%type,
  P_COD_ABI T_MCRES_APP_ACC_SOFF.COD_ABI%type DEFAULT NULL,
  P_COD_NDG T_MCRES_APP_ACC_SOFF.COD_NDG%type DEFAULT NULL,
  P_COD_FILIALE T_MCRES_APP_ACC_SOFF.COD_FILIALE%type DEFAULT NULL,
  P_COD_RAPPORTO_ORIG T_MCRES_APP_ACC_SOFF.COD_RAPPORTO_ORIG%type DEFAULT NULL,
  P_COD_TIPO_SOFF T_MCRES_APP_ACC_SOFF.COD_TIPO_SOFF%type DEFAULT NULL,
  P_VAL_NUMERO_SOFF T_MCRES_APP_ACC_SOFF.VAL_NUMERO_SOFF%type DEFAULT NULL,
  P_FLG_AGEVOLATO T_MCRES_APP_ACC_SOFF.FLG_AGEVOLATO%type DEFAULT NULL,
  P_COD_TIPO_CONTROPART T_MCRES_APP_ACC_SOFF.COD_TIPO_CONTROPART%type DEFAULT NULL,
  P_FLG_EX_REVOC T_MCRES_APP_ACC_SOFF.FLG_EX_REVOC%type DEFAULT NULL,
  P_VAL_TASSO_MORA T_MCRES_APP_ACC_SOFF.VAL_TASSO_MORA%type DEFAULT NULL,
  P_VAL_SPREAD T_MCRES_APP_ACC_SOFF.VAL_SPREAD%type DEFAULT NULL,
  P_VAL_VALORE_AT T_MCRES_APP_ACC_SOFF.VAL_VALORE_AT%type DEFAULT NULL,
  P_VAL_TASSO_ATTUALIZZAZIONE T_MCRES_APP_ACC_SOFF.VAL_TASSO_ATTUALIZZAZIONE%type DEFAULT NULL,
  P_VAL_IMPORTO_CAPITALE T_MCRES_APP_ACC_SOFF.VAL_IMPORTO_CAPITALE%type DEFAULT NULL,
  P_DTA_VALUTA_CAPITALE T_MCRES_APP_ACC_SOFF.DTA_VALUTA_CAPITALE%type DEFAULT NULL,
  P_VAL_INTERESSI_ORIGINARI T_MCRES_APP_ACC_SOFF.VAL_INTERESSI_ORIGINARI%type DEFAULT NULL,
  P_DTA_VALUTA_INTERESSI T_MCRES_APP_ACC_SOFF.DTA_VALUTA_INTERESSI%type DEFAULT NULL,
  P_COD_FILIALE_OPER T_MCRES_APP_ACC_SOFF.COD_FILIALE_OPER%type DEFAULT NULL
) return number;

function fnc_movimento_da_volturare(
  P_FLG_OPERAZ IN VARCHAR2,
  P_ID T_MCRES_APP_GIRO_INT_ORIG.ID%type,
  P_MATRICOLA T_MCRES_APP_GIRO_INT_ORIG.MATR_INS%type,
  P_COD_ABI T_MCRES_APP_GIRO_INT_ORIG.COD_ABI%type DEFAULT NULL,
  P_COD_NDG T_MCRES_APP_GIRO_INT_ORIG.COD_NDG%type DEFAULT NULL,
  P_COD_FILIALE T_MCRES_APP_GIRO_INT_ORIG.COD_FILIALE%type DEFAULT NULL,
  P_COD_RAPPORTO_ORIG T_MCRES_APP_GIRO_INT_ORIG.COD_RAPPORTO_ORIG%type DEFAULT NULL,
  P_COD_TIPO_SOFF T_MCRES_APP_GIRO_INT_ORIG.COD_TIPO_SOFF%type DEFAULT NULL,
  P_VAL_NUMERO_SOFF T_MCRES_APP_GIRO_INT_ORIG.VAL_NUMERO_SOFF%type DEFAULT NULL,
  P_FLG_AGEVOLATO T_MCRES_APP_GIRO_INT_ORIG.FLG_AGEVOLATO%type DEFAULT NULL,
  P_COD_TIPO_CONTROPART T_MCRES_APP_GIRO_INT_ORIG.COD_TIPO_CONTROPART%type DEFAULT NULL,
  P_FLG_EX_REVOC T_MCRES_APP_GIRO_INT_ORIG.FLG_EX_REVOC%type DEFAULT NULL,
  P_VAL_TASSO_MORA T_MCRES_APP_GIRO_INT_ORIG.VAL_TASSO_MORA%type DEFAULT NULL,
  P_VAL_SPREAD T_MCRES_APP_GIRO_INT_ORIG.VAL_SPREAD%type DEFAULT NULL,
  P_VAL_VALORE_AT T_MCRES_APP_GIRO_INT_ORIG.VAL_VALORE_AT%type DEFAULT NULL,
  P_VAL_TASSO_ATTUALIZZAZIONE T_MCRES_APP_GIRO_INT_ORIG.VAL_TASSO_ATTUALIZZAZIONE%type DEFAULT NULL,
  P_VAL_IMPORTO_CAPITALE T_MCRES_APP_GIRO_INT_ORIG.VAL_IMPORTO_CAPITALE%type DEFAULT NULL,
  P_DTA_VALUTA_CAPITALE T_MCRES_APP_GIRO_INT_ORIG.DTA_VALUTA_CAPITALE%type DEFAULT NULL,
  P_VAL_INTERESSI_ORIGINARI T_MCRES_APP_GIRO_INT_ORIG.VAL_INTERESSI_ORIGINARI%type DEFAULT NULL,
  P_DTA_VALUTA_INTERESSI T_MCRES_APP_GIRO_INT_ORIG.DTA_VALUTA_INTERESSI%type DEFAULT NULL,
  P_COD_FILIALE_OPER T_MCRES_APP_GIRO_INT_ORIG.COD_FILIALE_OPER%type DEFAULT NULL
) return number;

function fnc_movimento_proposto(
  P_FLG_OPERAZ IN VARCHAR2,
  P_ID T_MCRES_APP_MOV_PROPOS.ID%type,
  P_MATRICOLA T_MCRES_APP_MOV_PROPOS.MATR_INS%type,
  P_COD_ABI T_MCRES_APP_MOV_PROPOS.COD_ABI%type DEFAULT NULL,
  P_COD_NDG T_MCRES_APP_MOV_PROPOS.COD_NDG%type DEFAULT NULL,
  P_COD_CAUSALE T_MCRES_APP_MOV_PROPOS.COD_CAUSALE%type DEFAULT NULL,
  P_COD_FILIALE T_MCRES_APP_MOV_PROPOS.COD_FILIALE%type DEFAULT NULL,
  P_VAL_DENOMINAZIONE_CLI T_MCRES_APP_MOV_PROPOS.VAL_DENOMINAZIONE_CLI%type DEFAULT NULL,
  P_VAL_DESC_CAUSALE T_MCRES_APP_MOV_PROPOS.VAL_DESC_CAUSALE%type DEFAULT NULL,
  P_COD_TIPO_CONTROPART T_MCRES_APP_MOV_PROPOS.COD_TIPO_CONTROPART%type DEFAULT NULL,
  P_VAL_IMPORTO T_MCRES_APP_MOV_PROPOS.VAL_IMPORTO%type DEFAULT NULL,
  P_DTA_VALUTA T_MCRES_APP_MOV_PROPOS.DTA_VALUTA%type DEFAULT NULL,
  P_VAL_ORDINANTE T_MCRES_APP_MOV_PROPOS.VAL_ORDINANTE%type DEFAULT NULL,
  P_VAL_MOTIVAZIONE T_MCRES_APP_MOV_PROPOS.VAL_MOTIVAZIONE%type DEFAULT NULL,
  P_COD_FILIALE_OPER T_MCRES_APP_MOV_PROPOS.COD_FILIALE_OPER%type DEFAULT NULL
) return number;

    function fnc_gestione_criteri(
         p_id_criterio t_mcres_app_criteri.id_criterio%type default 0,
         p_desc_criterio t_mcres_app_criteri.desc_criterio%type,
         p_desc_criterio2 t_mcres_app_criteri.desc_criterio2%type,
         p_val_priorita t_mcres_app_criteri.val_priorita%type,
         p_cod_presidio t_mcres_app_criteri.cod_presidio%type,
         p_cod_matr_pratica t_mcres_app_criteri.cod_matr_pratica%type,
         p_cod_tipo_operazione t_mcres_app_criteri.cod_tipo_operazione%type default 'I'
    ) return number;

    function fnc_gestione_raccolta_doc(
        p_cod_abi t_mcres_app_raccolta_doc.cod_abi%type,
        p_cod_ndg t_mcres_app_raccolta_doc.cod_ndg%type,
        p_cod_uo_rapporto t_mcres_app_raccolta_doc.cod_uo_rapporto%type,
        p_cod_stato_raccolta_doc t_mcres_app_raccolta_doc.cod_stato_raccolta_doc%type,
        p_cod_matr_pratica t_mcres_app_raccolta_doc.cod_matr_pratica%type,
        p_flg_urgente  t_mcres_app_raccolta_doc.flg_urgente%type
    ) return number;

    function fnc_gestione_scheda_doc(
        p_cod_abi t_mcres_app_scheda_doc.cod_abi%type,
        p_cod_ndg t_mcres_app_scheda_doc.cod_ndg%type,
        p_cod_uo_rapporto t_mcres_app_scheda_doc.cod_uo_rapporto%type,
        p_id_documento t_mcres_app_scheda_doc.id_documento%type,
        p_val_note_filiale t_mcres_app_scheda_doc.val_note_filiale%type,
        p_flg_conforme t_mcres_app_scheda_doc.flg_conforme%type,
        p_flg_disponibile t_mcres_app_scheda_doc.flg_disponibile%type,
        p_val_note_presidio t_mcres_app_scheda_doc.val_note_presidio%type,
        p_dta_completamento t_mcres_app_scheda_doc.dta_completamento%type,
        p_cod_matr_pratica t_mcres_app_scheda_doc.cod_matr_pratica%type
    ) return number;

    function fnc_genera_cod_autorizzazione(p_cod_abi t_mcres_cl_sap.cod_abi%type, p_matricola varchar2) return varchar2;

    function fnc_gestione_cessione_rout(
        p_cod_abi T_MCRES_app_CEDUTE_ROUT.cod_abi%type,
        p_cod_ndg_cessionaria T_MCRES_app_CEDUTE_ROUT.cod_ndg_cessionaria%type)
    return number;

    function fnc_gestione_ftecniche(
        p_COD_FORMA_TECNICA  T_MCRES_cl_forme_tecniche.cod_forma_tecnica%type,
        p_VAL_DESC_FORMA_TECNICA T_MCRES_cl_forme_tecniche.VAL_DESC_FORMA_TECNICA%type,
        p_MATRICOLA_INS T_MCRES_cl_forme_tecniche.MATRICOLA_INS%type,
        p_flg_active T_MCRES_cl_forme_tecniche.flg_active%type)
    return number;

    function fnc_gestione_prodotti(
        p_COD_TIPO_SOFF T_MCRES_cl_prodotti_soff.COD_TIPO_SOFF%type,
        p_VAL_DESC_TIPO_SOFF T_MCRES_cl_prodotti_soff.VAL_DESC_TIPO_SOFF%type,
        p_FLG_FILIALE T_MCRES_cl_prodotti_soff.FLG_FILIALE%type,
        p_FLG_PRESIDIO T_MCRES_cl_prodotti_soff.flg_presidio%type,
        p_FLG_AUTOMATICA T_MCRES_cl_prodotti_soff.FLG_AUTOMATICA%type,
        p_FLG_DISMESSA T_MCRES_cl_prodotti_soff.FLG_DISMESSA%type,
        p_MATRICOLA_INS T_MCRES_cl_prodotti_soff.MATRICOLA_INS%type,
        p_flg_active T_MCRES_cl_prodotti_soff.flg_active%type)
    return number;

    function fnc_gestione_ftec_prodotti(
        p_COD_FORMA_TECNICA  T_MCRES_cl_raccordo_prod.cod_forma_tecnica%type,
        p_COD_TIPO_SOFFERENZA T_MCRES_cl_raccordo_prod.COD_TIPO_SOFFERENZA%type,
        p_MATRICOLA_INS T_MCRES_cl_raccordo_prod.MATRICOLA_INS%type,
        p_flg_active T_MCRES_cl_raccordo_prod.flg_active%type)
    return number ;

    FUNCTION fnc_mcres_protocollo_delibera(
        cod_uo IN VARCHAR2,
        utente IN VARCHAR2 DEFAULT NULL,
        p_abi  IN VARCHAR2 DEFAULT NULL,
        p_ndg  IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2;

END PKG_MCRES_FUNZIONI_PORTALE;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_FUNZIONI_PORTALE FOR MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALE;


CREATE SYNONYM MCRE_USR.PKG_MCRES_FUNZIONI_PORTALE FOR MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALE TO MCRE_USR;

