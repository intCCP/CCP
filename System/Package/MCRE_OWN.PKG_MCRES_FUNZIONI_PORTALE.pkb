CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALE
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
    2.62    15/05/2013    V.Galli       Nuovo flg per step 5 ---------->>> NON PORTARE IN PRODUZIONE!!!!!
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
    3.8  09/01/2014     V.Galli       flg_inviato_itf = 9  se flg_source !=ITF
    3.9  13/01/2014      V.Galli      fnc_gestione_ftecniche - fnc_gestione_prodotti - fnc_gestione_ftec_prodotti
    3.9  17/01/2014     A.Pilloni     modifica cancellazione accensione soff MO01 cancellazione logica correlata di MO02
    3.10  23/01/2014    A.Pilloni     modifica insert update spese per inserimento proforma
    3.11  12/03/2014    V.Galli    to_date dta_solare_operazione in  fnc_insert_contropartita
    3.12 29/03/2014     V.Galli    valutazioni
    3.13 08/04/2014     V.Galli    flg_tipo_rapporto
	3.14 05/05/2014     A.Pilloni  fix inserimento spese anche se annullate da mople
    3.15 07/05/2014    A.Pilloni  aggiunta parametro flg_urgente in fnc_gestione_raccolta_doc
******************************************************************************/
-- Funzione aggiornamento alert
/*
function fnc_reload_alert
(
    p_cod_abi t_mcres_app_pratiche.cod_abi%type,
    p_cod_flusso t_mcres_wrk_acquisizione.cod_flusso%type,
    p_cod_matr_pratica t_mcres_app_pratiche.cod_matr_pratica%type,
    p_cod_ndg t_mcres_app_pratiche.cod_ndg%type default null
)  return number
is


    c_nome constant varchar2(100) := c_package || '.FNC_RELOAD_ALERT';
    v_note varchar2(1000)           :='GENERALE';

    cursor c_list is
    select val_ins_query, val_del_qry, val_note
    from t_mcres_wrk_alimentazione_fen
    where val_tbl_name = 'T_MCRES_FEN_ALERT'
    and flg_attiva = 1
    and instr(val_lista_flussi,upper(p_cod_flusso))>0;

begin

  for rec_list in c_list
  loop

    begin

      v_note := 'Delete '|| rec_list.val_note || ' ABI= ' || p_cod_abi || ' and NDG='||p_cod_ndg;
      execute immediate rec_list.val_del_qry using p_cod_abi;

      v_note := 'Insert ' || rec_list.val_note || ' ABI= ' || p_cod_abi;
      execute immediate rec_list.val_ins_query using p_cod_abi;

      pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,'Aggiornato alert avente ' || rec_list.val_note || ' per COD_ABI = ' ||  p_cod_abi || ' and NDG='||p_cod_ndg, p_cod_matr_pratica);

--      commit ;

    exception
      when others then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_matr_pratica);
        return ko;
    end;

  end loop;

  return ok;

exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_matr_pratica);
    return ko;
end fnc_reload_alert;
*/

-- Funzione aggiornamento alert
function fnc_reload_alert
(
    p_cod_abi t_mcres_app_pratiche.cod_abi%type,
    p_cod_flusso t_mcres_wrk_acquisizione.cod_flusso%type,
    p_cod_matr_pratica t_mcres_app_pratiche.cod_matr_pratica%type,
    p_cod_ndg t_mcres_app_pratiche.cod_ndg%type default null
)  return number
is


    c_nome constant varchar2(100) := c_package || '.FNC_RELOAD_ALERT';
    v_note varchar2(1000)           :='GENERALE';

    cursor c_list is
    select val_ins_query, val_del_qry, val_note
    from t_mcres_wrk_alimentazione_fen
    where val_tbl_name = decode(p_cod_ndg,null,'T_MCRES_FEN_ALERT','T_MCRES_FEN_ALERT_POS')
    and flg_attiva = 1
    and instr(val_lista_flussi,upper(p_cod_flusso))>0;

begin

  for rec_list in c_list
  loop

    begin

      v_note := 'Delete '|| rec_list.val_note || ' ABI= ' || p_cod_abi || ' and NDG='||p_cod_ndg;
      if(p_cod_ndg is null) then
        execute immediate rec_list.val_del_qry using p_cod_abi;
      else
        execute immediate rec_list.val_del_qry||' and cod_ndg='''||p_cod_ndg||'''' using p_cod_abi;
      end if;

      v_note := 'Insert ' || rec_list.val_note || ' ABI= ' || p_cod_abi;
      if(p_cod_ndg is null) then
        execute immediate rec_list.val_ins_query using p_cod_abi;
      else
        execute immediate replace(rec_list.val_ins_query,' and 1=1',' and cod_ndg='''||p_cod_ndg||'''') using p_cod_abi;
      end if;

      pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,'Aggiornato alert avente ' || rec_list.val_note || ' per COD_ABI = ' ||  p_cod_abi || ' and NDG='||p_cod_ndg, p_cod_matr_pratica);

--      commit ;

    exception
      when others then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_matr_pratica);
        return ko;
    end;

  end loop;

  return ok;

exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_matr_pratica);
    return ko;
end fnc_reload_alert;


-- Funzione set flag stampa report delibere
function FNC_SET_DEL_STAMPA (
  P_COD_ABI T_MCRES_APP_DELIBERE.COD_ABI%type,
  P_COD_NDG T_MCRES_APP_DELIBERE.COD_NDG%type,
  P_COD_PROTOCOLLO_DELIBERA T_MCRES_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA%type,
  P_COD_MATR_PRATICA T_MCRES_APP_GRUPPI_NOTE.COD_MATR_PRATICA%type,
  P_FLG_STAMPA T_MCRES_APP_DELIBERE.FLG_STAMPA%type
)  RETURN NUMBER
IS
  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_SET_DEL_STAMPA';
  V_NOTE VARCHAR2(1000)           :='GENERALE';
  V_COD_PROTOCOLLO T_MCRES_APP_DEL_PROSPETTO.COD_PROTOCOLLO%type;
begin

  V_NOTE:='Stampa report delibere COD_PROTOCOLLO_DELIBERA='||P_COD_PROTOCOLLO_DELIBERA||' ABI='||P_COD_ABI||' NDG='||P_COD_NDG||' FLG_STAMPA='||P_FLG_STAMPA;
  update T_MCRES_APP_DELIBERE
  set FLG_STAMPA = P_FLG_STAMPA
  where COD_ABI = P_COD_ABI
  and COD_NDG = P_COD_NDG
  and COD_PROTOCOLLO_DELIBERA = p_COD_PROTOCOLLO_DELIBERA;

  return OK;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_COD_MATR_PRATICA);
    return KO;
end FNC_SET_DEL_STAMPA;

-- Funzione modifica presa visione DELIBERE
function FNC_SET_DEL_PRESA_VISIONE (
  P_COD_ABI T_MCRES_APP_DELIBERE.COD_ABI%type,
  P_COD_NDG T_MCRES_APP_DELIBERE.COD_NDG%type,
  P_COD_PROTOCOLLO_DELIBERA T_MCRES_APP_DELIBERE.COD_PROTOCOLLO_DELIBERA%type,
  P_TIPO_UTENTE varchar2,
  P_COD_MATR_PRATICA T_MCRES_APP_GRUPPI_NOTE.COD_MATR_PRATICA%type
)  RETURN NUMBER
IS
  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_SET_DEL_PRESA_VISIONE';
  V_NOTE VARCHAR2(1000)           :='GENERALE';
  V_COD_PROTOCOLLO T_MCRES_APP_DEL_PROSPETTO.COD_PROTOCOLLO%type;
begin

  V_NOTE:='Presa visione delibere COD_PROTOCOLLO_DELIBERA='||P_COD_PROTOCOLLO_DELIBERA||' ABI='||P_COD_ABI||' NDG='||P_COD_NDG;
  update T_MCRES_APP_DELIBERE
  set FLG_PVISIONE_GESTORE = DECODE(P_TIPO_UTENTE,'G','S',FLG_PVISIONE_GESTORE),
      FLG_PVISIONE_PRESIDIO = DECODE(P_TIPO_UTENTE,'P','S',FLG_PVISIONE_PRESIDIO),
      FLG_PVISIONE_ENTE_CENTR = DECODE(P_TIPO_UTENTE,'E','S',FLG_PVISIONE_ENTE_CENTR)
  where COD_ABI = P_COD_ABI
  and COD_NDG = P_COD_NDG
  and COD_PROTOCOLLO_DELIBERA = p_COD_PROTOCOLLO_DELIBERA;

  return OK;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_COD_MATR_PRATICA);
    return KO;
end FNC_SET_DEL_PRESA_VISIONE;


-- Funzione per la generazione del protocollo pe reportb delibere per rendicontazione outsourcing
FUNCTION FNC_GET_PROTOCOLLO_DEL_PROSP (
  P_COD_ABI T_MCRES_APP_DEL_PROSPETTO.COD_ABI%TYPE,
  P_VAL_ANNOMESE T_MCRES_APP_DEL_PROSPETTO.VAL_ANNOMESE%TYPE,
  P_COD_MATR_PRATICA T_MCRES_APP_PRATICHE.COD_MATR_PRATICA%type
)  RETURN NUMBER
IS
  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_GET_PROTOCOLLO_DEL_PROSP';
  V_NOTE VARCHAR2(1000)           :='GENERALE';
  v_COD_PROTOCOLLO T_MCRES_APP_DEL_PROSPETTO.COD_PROTOCOLLO%type;
BEGIN
  BEGIN
    V_NOTE:='Calcolo codice protocollo';
    SELECT MAX(COD_PROTOCOLLO)+1
    INTO V_COD_PROTOCOLLO
    from T_MCRES_APP_DEL_PROSPETTO
    where COD_ABI = P_COD_ABI
    and VAL_ANNOMESE=P_VAL_ANNOMESE ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_COD_PROTOCOLLO:=1;
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_COD_MATR_PRATICA);
      RETURN KO;
  end;

  BEGIN
    V_NOTE:='Inserisco codice protocollo';
    INSERT INTO T_MCRES_APP_DEL_PROSPETTO
    (COD_ABI,VAL_ANNOMESE,COD_PROTOCOLLO,COD_MATR_PRATICA,DTA_INS)
    VALUES
    (P_COD_ABI,P_VAL_ANNOMESE,nvl(V_COD_PROTOCOLLO,1),P_COD_MATR_PRATICA,SYSDATE);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
        PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_COD_MATR_PRATICA);
        RETURN KO;
  end;

  return nvl(V_COD_PROTOCOLLO,1);

EXCEPTION
WHEN OTHERS THEN
  PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_COD_MATR_PRATICA);
  RETURN KO;
end FNC_GET_PROTOCOLLO_DEL_PROSP;

  -- Funzione per il mantenimento dello storico dei Gestori delle Pratiche Legali
FUNCTION FNC_MCRES_ALIMENTA_GESTORI(
    P_REC IN F_SLAVE_PAR_TYPE)
  RETURN NUMBER
IS
  c_nome constant varchar2(100) := c_package || '.FNC_MCRES_ALIMENTA_GESTORI';
  v_note varchar2(1000)           :='GENERALE';
  V_COD_ABI T_MCRES_WRK_ACQUISIZIONE.COD_ABI%TYPE;

  CURSOR C_LISTA_GESTORI(P_COD_ABI t_mcres_app_pratiche.cod_abi%type)
  IS
    SELECT --- Nuova riga
      P.COD_ABI,
      P.COD_NDG,
      P.COD_PRATICA,
      P.COD_UO_PRATICA,
      P.DTA_APERTURA,
      P.DTA_CHIUSURA,
      p.val_anno,
      substr(p.cod_matr_pratica,2,length(p.cod_matr_pratica)) cod_matr_pratica,
      p.dta_assegn_addet,
      P.FLG_ATTIVA,
      --- Vecchia Riga
      g.cod_matr_pratica cod_matr_pratica_old,
      g.dta_decorrenzaincarico dta_decorrenzaincarico_old
    from t_mcres_app_pratiche p,
           ( select * from (
                select l.cod_abi,l.cod_ndg,l.cod_pratica,l.val_anno_apertura_pl,l.dta_decorrenzaincarico,l.cod_matr_pratica,l.dta_finedecorrenzaincarico,
                      lag(l.dta_decorrenzaincarico) over (partition by l.cod_abi,l.cod_ndg,l.cod_pratica,l.val_anno_apertura_pl order by dta_decorrenzaincarico desc, dta_ins desc ) dta_dec_precedente
                from t_mcres_app_gestori_pl l
                where l.cod_tipo_storico            = 'G'
                --order by l.cod_abi,l.cod_ndg,l.cod_pratica,l.val_anno_apertura_pl, dta_decorrenzaincarico desc
                ) where dta_dec_precedente is null ) g
    WHERE P.COD_ABI                   = G.COD_ABI
    AND P.COD_NDG                     = G.COD_NDG
    and p.cod_pratica                 = g.cod_pratica
    and p.val_anno = g.val_anno_apertura_pl
    and substr(p.cod_matr_pratica,2,length(p.cod_matr_pratica))  != g.cod_matr_pratica
    and nvl(P.COD_MATR_PRATICA,'U-') != 'U-'
    and g.dta_finedecorrenzaincarico is null
    and p.cod_abi=P_COD_ABI;

  CURSOR C_LISTA_NUOVE_PRATICHE(P_COD_ABI t_mcres_app_pratiche.cod_abi%type)
  IS
    SELECT P.COD_ABI,
      P.COD_NDG,
      P.COD_PRATICA,
      P.COD_UO_PRATICA,
      P.DTA_APERTURA,
      P.DTA_CHIUSURA,
      p.val_anno,
      substr(p.cod_matr_pratica,2,length(p.cod_matr_pratica)) cod_matr_pratica,
      p.dta_assegn_addet,
      P.FLG_ATTIVA
    FROM T_MCRES_APP_PRATICHE p
    WHERE NOT EXISTS
      ( SELECT DISTINCT 1
      FROM T_MCRES_APP_GESTORI_PL G
      WHERE g.COD_ABI        = p.COD_ABI
      AND g.COD_NDG          = p.COD_NDG
      and g.cod_pratica      = p.cod_pratica
      and g.val_anno_apertura_pl = p.val_anno
      AND G.COD_TIPO_STORICO = 'G'
      )
    and nvl(P.COD_MATR_PRATICA,'U-') != 'U-'
    and p.cod_abi=P_COD_ABI;

begin

   BEGIN
    SELECT COD_ABI
    INTO V_COD_ABI
    FROM T_MCRES_WRK_ACQUISIZIONE
    WHERE ID_FLUSSO = P_REC.SEQ_FLUSSO;
  exception
  WHEN OTHERS THEN
    pkg_mcres_audit.log_caricamenti(p_rec.seq_flusso,c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'COD_ABI='||v_cod_abi);
  END;

  FOR REC_LISTA_GESTORI IN C_LISTA_GESTORI(V_COD_ABI)
  loop

    begin
      v_note := ' Set FINE - Pratica='||rec_lista_gestori.cod_pratica||' ABI='||rec_lista_gestori.cod_abi||' NDG='||rec_lista_gestori.cod_ndg;
      UPDATE T_MCRES_APP_GESTORI_PL
      SET DTA_FINEDECORRENZAINCARICO  = SYSDATE,
        DTA_UPD                       = SYSDATE
      where cod_pratica               = rec_lista_gestori.cod_pratica
      and val_anno_apertura_pl               = rec_lista_gestori.val_anno
      and cod_abi               = rec_lista_gestori.cod_abi
      and dta_decorrenzaincarico = rec_lista_gestori.dta_decorrenzaincarico_old
      AND DTA_FINEDECORRENZAINCARICO IS NULL
      and cod_matr_pratica            = rec_lista_gestori.cod_matr_pratica_old;

      v_note  := ' InsGES - Pratica='||rec_lista_gestori.cod_pratica||' ABI='||rec_lista_gestori.cod_abi||' NDG='||rec_lista_gestori.cod_ndg;
      INSERT
      INTO T_MCRES_APP_GESTORI_PL
        (
          COD_ABI,
          COD_NDG,
          COD_PRATICA,
          COD_UO_PRATICA,
          DTA_APERTURA_PL,
          DTA_CHIUSURA_PL,
          VAL_ANNO_APERTURA_PL,
          COD_MATR_PRATICA,
          DTA_DECORRENZAINCARICO,
          DTA_FINEDECORRENZAINCARICO,
          COD_TIPO_STORICO,
          FLG_ATTIVA,
          DTA_INS
        )
        VALUES
        (
          REC_LISTA_GESTORI.COD_ABI,
          REC_LISTA_GESTORI.COD_NDG,
          REC_LISTA_GESTORI.COD_PRATICA,
          REC_LISTA_GESTORI.COD_UO_PRATICA,
          REC_LISTA_GESTORI.DTA_APERTURA,
          REC_LISTA_GESTORI.DTA_CHIUSURA,
          REC_LISTA_GESTORI.VAL_ANNO,
          rec_lista_gestori.cod_matr_pratica,
          REC_LISTA_GESTORI.dta_assegn_addet, -- DTA_DECORRENZAINCARICO
          NULL,    -- DTA_FINEDECORRENZAINCARICO
          'G',     -- COD_TIPO_STORICO
          REC_LISTA_GESTORI.FLG_ATTIVA,
          SYSDATE  --DTA_INS
        );
      commit;

    EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
      RETURN KO;
    END;
  end loop;

  for rec_lista_nuove_pratiche in c_lista_nuove_pratiche(v_cod_abi)
  loop
    begin
      v_note := ' InsPr - Pratica='||rec_lista_nuove_pratiche.cod_pratica||' ABI='||rec_lista_nuove_pratiche.cod_abi||' NDG='||rec_lista_nuove_pratiche.cod_ndg;
      INSERT
      INTO T_MCRES_APP_GESTORI_PL
        (
          COD_ABI,
          COD_NDG,
          COD_PRATICA,
          COD_UO_PRATICA,
          DTA_APERTURA_PL,
          DTA_CHIUSURA_PL,
          VAL_ANNO_APERTURA_PL,
          COD_MATR_PRATICA,
          DTA_DECORRENZAINCARICO,
          DTA_FINEDECORRENZAINCARICO,
          COD_TIPO_STORICO,
          FLG_ATTIVA,
          DTA_INS
        )
        VALUES
        (
          REC_LISTA_NUOVE_PRATICHE.COD_ABI,
          REC_LISTA_NUOVE_PRATICHE.COD_NDG,
          REC_LISTA_NUOVE_PRATICHE.COD_PRATICA,
          REC_LISTA_NUOVE_PRATICHE.COD_UO_PRATICA,
          REC_LISTA_NUOVE_PRATICHE.DTA_APERTURA,
          REC_LISTA_NUOVE_PRATICHE.DTA_CHIUSURA,
          REC_LISTA_NUOVE_PRATICHE.VAL_ANNO,
          rec_lista_nuove_pratiche.cod_matr_pratica,
          REC_LISTA_NUOVE_PRATICHE.dta_assegn_addet, -- DTA_DECORRENZAINCARICO
          NULL,    -- DTA_FINEDECORRENZAINCARICO
          'G',     -- COD_TIPO_STORICO
          REC_LISTA_NUOVE_PRATICHE.FLG_ATTIVA,
          SYSDATE  --DTA_INS
        );
      COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
      RETURN KO;
    END;
  END LOOP;
  RETURN ok;
EXCEPTION
WHEN OTHERS THEN
  PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_rec.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE);
  RETURN KO;
END FNC_MCRES_ALIMENTA_GESTORI;

-- Funzione per l'inserimento delle note relativhe ai gruppi - Sezione: Monitoraggio Gruppi Top30
FUNCTION FNC_MCRES_NOTE_GRUPPI
  (
    P_DESC_NOTA T_MCRES_APP_GRUPPI_NOTE.DESC_NOTA%TYPE,
    P_COD_MATR_PRATICA T_MCRES_APP_GRUPPI_NOTE.COD_MATR_PRATICA%TYPE,
    P_VAL_ANNOMESE T_MCRES_APP_GRUPPI_NOTE.VAL_ANNOMESE%TYPE,
    P_COD_SNDG T_MCRES_APP_GRUPPI_NOTE.COD_SNDG%TYPE,
    P_COD_GRUPPO_ECONOMICO T_MCRES_APP_GRUPPI_NOTE.COD_GRUPPO_ECONOMICO%TYPE
  )
  RETURN NUMBER
IS
  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_NOTE_GRUPPI';
  V_NOTE VARCHAR2(50)           :='GENERALE';
  V_SEQ  NUMBER;
BEGIN
  SELECT SEQ_MCR0_LOG_APP.NEXTVAL INTO v_seq FROM dual;
  INSERT
  INTO T_MCRES_APP_GRUPPI_NOTE
    (
      ID_NOTA,
      DESC_NOTA,
      VAL_ANNOMESE,
      COD_MATR_PRATICA,
      COD_SNDG,
      COD_GRUPPO_ECONOMICO,
      DTA_INS
    )
    VALUES
    (
      V_SEQ,
      P_DESC_NOTA,
      P_VAL_ANNOMESE,
      P_COD_MATR_PRATICA,
      P_COD_SNDG,
      P_COD_GRUPPO_ECONOMICO,
      SYSDATE
    );
  COMMIT;
  RETURN ok;
EXCEPTION
WHEN OTHERS THEN
  PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_COD_MATR_PRATICA);
  RETURN KO;
end FNC_MCRES_NOTE_GRUPPI;

-- Inserimento, Modifica e cancellazione pareri
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
return number is
   C_NOME CONSTANT varchar2(100) := C_PACKAGE || '.FNC_MCRES_POPOLA_PARERI';
   v_NOTE           T_MCRES_WRK_AUDIT_APPLICATIVO.NOTE%type;

   V_id_PARERE T_MCREI_APP_PARERI.ID_PARERE%type;

begin

   if (P_ID_PARERE is null) then
     V_NOTE := 'Generazione id parere ';
     begin
       select to_number('8' || lpad(seq_mcrei_pareri.nextval, 10, '0'))
       into V_ID_PARERE
       from dual;
     EXCEPTION
       WHEN OTHERS THEN
         PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE||' - '||P_COD_ABI||' - '||P_COD_NDG||' - '||P_COD_PROTOCOLLO_DELIBERA,P_COD_UTENTE);
         RETURN KO;
     end;

     V_NOTE := 'Insert parere ';
     begin
       INSERT into t_mcrei_app_pareri
         (id_dper,
          cod_abi,
          id_parere,
          cod_protocollo_delibera,
          cod_progr_parere,
          desc_parere,
          cod_tipo_par,
          dta_ins_parere,
          COD_NDG,
          flg_attiva,
          dta_ins,
          dta_upd,
          COD_SNDG,
          DESC_PARERE_ESTESO,
          FLG_DELETE,
          COD_UO,
          cod_utente
          )
       VALUES
         (TO_NUMBER(TO_CHAR(TRUNC(sysdate), 'yyyymmdd')),
          p_cod_abi,
          V_ID_PARERE,
          p_cod_protocollo_delibera,
          1,
          p_desc_parere,
          p_cod_tipo_par,
          sysdate,
          p_cod_ndg,
          1,
          SYSDATE,
          sysdate,
          p_COD_SNDG,
          P_DESC_PARERE_ESTESO,
          0,
          P_COD_UO,
          p_cod_utente);
      EXCEPTION
       WHEN OTHERS THEN
         PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE||' - '||P_COD_ABI||' - '||P_COD_NDG||' - '||p_cod_protocollo_delibera,P_COD_UTENTE);
         RETURN KO;
     end;
  else
    V_ID_PARERE := P_ID_PARERE;

    if (P_FLG_DELETE = 0) then
      V_NOTE := 'Update parere ';
      begin
        UPDATE t_mcrei_app_pareri t
            SET t.desc_parere        = p_desc_parere,
                T.DTA_UPD            = sysdate,
                T.DESC_PARERE_ESTESO = P_DESC_PARERE_ESTESO,
                COD_UO = P_COD_UO,
                cod_utente = P_COD_UTENTE
        where COD_ABI = p_COD_ABI
         AND   COD_NDG = P_COD_NDG
         and   COD_PROTOCOLLO_DELIBERA = p_COD_PROTOCOLLO_DELIBERA
          and  ID_PARERE = v_ID_PARERE;
      EXCEPTION
        WHEN OTHERS THEN
          PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE||' - '||P_COD_ABI||' - '||P_COD_NDG||' - '||P_COD_PROTOCOLLO_DELIBERA,P_COD_UTENTE);
          RETURN KO;
      end;
    else
      V_NOTE := 'Delete parere ';
      begin
        update T_MCREI_APP_PARERI T
            SET t.flg_delete = 1
        where COD_ABI = p_COD_ABI
         AND   COD_NDG = P_COD_NDG
         and   COD_PROTOCOLLO_DELIBERA = p_COD_PROTOCOLLO_DELIBERA
          and id_parere = v_ID_PARERE;
      EXCEPTION
        WHEN OTHERS THEN
          PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE||' - '||P_COD_ABI||' - '||P_COD_NDG||' - '||P_COD_PROTOCOLLO_DELIBERA,P_COD_UTENTE);
          RETURN KO;
      end;
    end if;
  end if;

  P_ID_PARERE := V_ID_PARERE;


  return OK;

EXCEPTION
   WHEN OTHERS THEN
     PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE||' - '||P_COD_ABI||' - '||P_COD_NDG||' - '||P_COD_PROTOCOLLO_DELIBERA,P_COD_UTENTE);
     RETURN KO;
 END FNC_MCRES_POPOLA_PARERI;

-- Funzione per l'inserimento e la modifica delle Spese
/*FUNCTION fnc_mcres_ins_upd_spese_old
  (
    p_spesa typ_sp_spese,
    p_contropartita typ_sp_contropartita,
    p_rapporto typ_sp_rapporto,
    p_azioni typ_sp_azioni
  )
  RETURN NUMBER
IS
  c_nome     CONSTANT VARCHAR2(100) := c_package || '.FNC_MCRES_INS_UPD_SPESE';
  v_note     VARCHAR2(50)           :='GENERALE';
  idxs       NUMBER;
  idxc       NUMBER;
  idxr       NUMBER;
  idxa       NUMBER;
  v_exists   NUMBER;
  v_exists_2 NUMBER;
BEGIN
  FOR idxs IN p_spesa.FIRST .. p_spesa.LAST
  LOOP
    v_exists:=0;
    BEGIN
      SELECT 1
      INTO v_exists
      FROM t_mcres_app_sp_spese
      WHERE cod_autorizzazione = p_spesa(idxs).cod_autorizzazione;
    EXCEPTION
    WHEN no_data_found THEN
      v_exists:=0;
    WHEN OTHERS THEN
      EXIT;
    END;
    IF (v_exists=0) THEN
      NULL; -- sequence e insert spesa
    ELSE
      NULL; -- update spesa
    END IF;
    FOR idxc IN p_contropartita.first .. p_contropartita.last
    LOOP
      v_exists_2                                :=0;
      IF(p_contropartita(idxc).cod_autorizzazione=p_spesa(idxs).cod_autorizzazione) THEN
        IF (v_exists                             =0) THEN
          NULL; -- insert contropartite
        ELSE
          BEGIN
            SELECT 1
            INTO v_exists_2
            FROM t_mcres_app_sp_contropartita
            WHERE cod_autorizzazione = p_contropartita(idxc).cod_autorizzazione
            AND cod_contropartita    = p_contropartita(idxc).cod_contropartita;
          EXCEPTION
          WHEN no_data_found THEN
            v_exists_2:=0;
          WHEN OTHERS THEN
            EXIT;
          END;
          IF(v_exists_2=0)THEN
            NULL; -- insert contropartite
          ELSE
            NULL; -- update contropartite
          END IF;
        END IF;
      END IF;
      FOR idxr IN p_rapporto.first .. p_rapporto.last
      LOOP
        v_exists_2                          :=0;
        IF(p_rapporto(idxc).cod_contropartita=p_contropartita(idxs).cod_contropartita) THEN
          IF (v_exists                       =0) THEN
            NULL; -- insert rapporti
          ELSE
            BEGIN
              SELECT 1
              INTO v_exists_2
              FROM t_mcres_app_sp_rapporto
              WHERE cod_rapporto    = p_rapporto(idxc).cod_rapporto
              AND cod_contropartita = p_rapporto(idxc).cod_contropartita;
            EXCEPTION
            WHEN no_data_found THEN
              v_exists_2:=0;
            WHEN OTHERS THEN
              EXIT;
            END;
            IF(v_exists_2=0)THEN
              NULL; -- insert rapporto
            ELSE
              NULL; -- update rapporto
            END IF;
          END IF;
        END IF;
      END LOOP;
    END LOOP;
    FOR idxa IN p_azioni.first .. p_azioni.last
    LOOP
      v_exists_2                         :=0;
      IF(p_azioni(idxc).cod_autorizzazione=p_spesa(idxs).cod_autorizzazione) THEN
        IF (v_exists                      =0) THEN
          NULL; -- insert azioni
        ELSE
          BEGIN
            SELECT 1
            INTO v_exists_2
            FROM t_mcres_app_sp_azioni
            WHERE cod_autorizzazione = p_azioni(idxs).cod_autorizzazione
            AND cod_azione           = p_azioni(idxs).cod_azione;
          EXCEPTION
          WHEN no_data_found THEN
            v_exists_2:=0;
          WHEN OTHERS THEN
            EXIT;
          END;
          IF(v_exists_2=0)THEN
            NULL; -- insert azioni
          ELSE
            NULL; -- update azioni
          END IF;
        END IF;
      END IF;
    END LOOP;
  END LOOP;
  COMMIT;
  RETURN ok;
EXCEPTION
WHEN OTHERS THEN
  pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,SQLCODE,sqlerrm,v_note,'UO='||p_spesa(1).cod_uo||' - MATR='||p_spesa(1).cod_matricola);
  RETURN Ko;
end FNC_MCRES_INS_UPD_SPESE_OLD;*/

-- Funzione per il cambio stato delle Spese
/*FUNCTION fnc_mcres_cambio_stato_spese_o(
    p_cod_autorizzazione typ_cod_autorizzazione,
    p_cod_stato t_mcres_app_sp_spese.cod_stato%type,
    p_cod_uo t_mcres_app_sp_spese.cod_uo%type,
    p_cod_matricola t_mcres_app_sp_spese.cod_matricola%type )
  RETURN NUMBER
IS
  c_nome CONSTANT VARCHAR2(100) := c_package || '.FNC_MCRES_CAMBIO_STATO_SPESE';
  v_note VARCHAR2(50)           :='GENERALE';
  idx    NUMBER;
BEGIN
  FOR idx IN p_cod_autorizzazione.first .. p_cod_autorizzazione.last
  LOOP
    UPDATE t_mcres_app_sp_spese
    SET cod_stato            = p_cod_stato,
      cod_uo                 = p_cod_uo,
      cod_matricola          = p_cod_matricola
    WHERE cod_autorizzazione = p_cod_autorizzazione(idx);
  END LOOP;
  -- Commit da Java
  RETURN ok;
EXCEPTION
WHEN OTHERS THEN
  pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,SQLCODE,sqlerrm,v_note,'UO='||p_cod_uo||' - MATR='||p_cod_matricola);
  RETURN Ko;
end FNC_MCRES_CAMBIO_STATO_SPESE_O;*/

FUNCTION Fnc_Insert_Azione(
    L_Cod_Autorizzazione IN OUT VARCHAR2,
    L_Cod_Azione VARCHAR2,
    L_Dta_Ins DATE,
    Utente VARCHAR2)
  RETURN VARCHAR2
IS
  l_esito VARCHAR2(2);
BEGIN
  BEGIN
    INSERT
    INTO T_Mcres_App_Sp_Azioni
      (
        Cod_Autorizzazione,
        Cod_Azione,
        Dta_Ins
      )
      VALUES
      (
        L_Cod_Autorizzazione,
        L_Cod_Azione,
        L_Dta_Ins
      );
    Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.Fnc_Insert_Azione','1',SQLCODE,Sqlerrm,'inserimento azione riuscito',Utente);
    l_esito:='OK';
  EXCEPTION
  WHEN OTHERS THEN
    Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.Fnc_Insert_Azione','2',SQLCODE,Sqlerrm,'inserimento azione non riuscito',Utente);
    L_Esito:='KO';
  END;
  RETURN L_ESITO;
end FNC_INSERT_AZIONE;

/**************************************************************************************************
******************************************************************************************************/


FUNCTION fnc_aggiorna_stato_spesa(
    p_cod_autorizzazione T_Mcres_App_Sp_Spese.COD_AUTORIZZAZIONE%type,
    p_cod_stato      T_Mcres_App_Sp_Spese.COD_STATO%type,
    p_cod_utente       VARCHAR2,
    p_desc_mot_annul_spesa T_Mcres_App_Sp_Spese.DESC_MOT_ANNUL_SPESA%type DEFAULT NULL,
    p_cod_uo T_Mcres_App_Sp_Spese.COD_UO%type DEFAULT NULL)
  RETURN NUMBER
    IS


    c_nome   CONSTANT VARCHAR2 (100) := c_package || '.FNC_AGGIORNA_STATO_SPESA';
    v_note   t_mcres_wrk_audit_applicativo.note%TYPE;
    v_flg_source VARCHAR2(3);

    BEGIN

    v_note := 'ControlloÂ  parametri input per stato AN';
    if (p_cod_autorizzazione is null and p_desc_mot_annul_spesa is null)
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi. I parametri p_cod_autorizzazione e p_desc_mot_annul_spesa non possono essere nulli. COD_AUTORIZZAZIONE = '
                                                                                || p_cod_autorizzazione || ', DESC_MOT_ANNUL_SPESA = '
                                                                                || p_desc_mot_annul_spesa, p_cod_utente);
        return ko;
    end if;

    SELECT FLG_SOURCE
      INTO v_flg_source
      FROM T_MCRES_APP_SP_SPESE
      WHERE COD_AUTORIZZAZIONE = p_cod_autorizzazione;

        UPDATE
        T_Mcres_App_Sp_Spese
        SET
        Dta_Autorizzazione = CASE WHEN p_cod_stato = 'CO' THEN SYSDATE ELSE Dta_Autorizzazione END,
        flg_contabilizzata = CASE WHEN p_cod_stato = 'CO' THEN 1 ELSE flg_contabilizzata END,
        Dta_Storno_Contabile = CASE WHEN p_cod_stato = 'AN' THEN SYSDATE ELSE Dta_Storno_Contabile END,
        flg_ann_autoriz = CASE WHEN p_cod_stato = 'AN' THEN 'S' ELSE flg_ann_autoriz END,
        desc_mot_annul_spesa = CASE WHEN p_cod_stato = 'AN' THEN p_desc_mot_annul_spesa ELSE desc_mot_annul_spesa END,
        dta_annullamento = CASE WHEN p_cod_stato = 'AN' THEN SYSDATE ELSE dta_annullamento END,
        Dta_inoltro_Spesa = CASE WHEN p_cod_stato = 'IT' THEN SYSDATE ELSE Dta_inoltro_Spesa END,
        Dta_trasf_Spesa = CASE WHEN p_cod_stato = 'TR' THEN SYSDATE ELSE Dta_trasf_Spesa END,
        Dta_ins_Spesa = CASE WHEN p_cod_stato = 'IN' THEN SYSDATE ELSE Dta_ins_Spesa END,
--        Dta_Upd_Spesa = CASE WHEN p_cod_stato IN ('CO','AN','IT','TR','IN') THEN SYSDATE ELSE Dta_Upd_Spesa END,
--        Cod_operatore_ins_upd = CASE WHEN p_cod_stato IN ('CO','AN','IT','TR','IN') THEN p_cod_utente ELSE Cod_operatore_ins_upd END,
--        Cod_stato = CASE WHEN p_cod_stato IN ('CO','AN','IT','TR','IN') THEN p_cod_stato ELSE Cod_stato END
        Dta_trasf_Spesa_rdrc = CASE WHEN p_cod_stato = 'TX' THEN SYSDATE ELSE Dta_trasf_Spesa_rdrc END,
        Dta_Upd_Spesa = SYSDATE,
        Cod_operatore_ins_upd = p_cod_utente,
        Cod_stato = p_cod_stato,
        cod_uo = NVL(p_cod_uo, cod_uo)
        WHERE
        Cod_Autorizzazione = p_Cod_Autorizzazione;

        --AP 13/11/2013

        IF (v_flg_source = 'ITF' and p_cod_stato = 'AN') THEN

        UPDATE t_mcres_app_spese_itf
           SET cod_stato = p_cod_stato,
               dta_upd = SYSDATE,
               cod_operatore_ins_upd = p_cod_utente
         WHERE cod_autorizzazione = p_cod_autorizzazione;


        END IF;

    RETURN ok;

EXCEPTION
   WHEN OTHERS
   THEN
      pkg_mcres_audit.log_app (c_nome,
                               pkg_mcres_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                               v_note,
                               p_cod_utente
                              );
      RETURN ko;

end;

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
  RETURN VARCHAR2
IS
  l_esito VARCHAR2(2);
BEGIN
  BEGIN
    INSERT
    INTO T_Mcres_App_Sp_contropartita
      (
        COD_CONTROPARTITA ,
        COD_TIPO ,
        COD_DIVISA ,
        VAL_IMPORTO ,
        COD_FILIALE ,
        COD_AUTORIZZAZIONE ,
        DTA_INS ,
        VAL_NUOVA_OPERAZIONE ,
        COD_OPERAZIONE_FATT ,
        COD_PROGR_OPERAZIONE ,
        DTA_SOLARE_OPERAZIONE ,
        COD_RIFERIMENTO
      )
      VALUES
      (
        L_COD_CONTROPARTITA ,
        L_COD_TIPO ,
        L_COD_DIVISA ,
        L_VAL_IMPORTO ,
        L_COD_FILIALE ,
        L_COD_AUTORIZZAZIONE ,
        L_DTA_INS ,
        L_VAL_NUOVA_OPERAZIONE ,
        L_COD_OPERAZIONE_FATT ,
        L_COD_PROGR_OPERAZIONE ,
        to_date(L_DTA_SOLARE_OPERAZIONE, 'yyyymmdd') ,
        L_COD_RIFERIMENTO
      );
    INSERT
    INTO T_Mcres_App_Sp_Rapporto
      (
        COD_CONTROPARTITA ,
        COD_FILIALE_COMPETENTE ,
        COD_PRODOTTO ,
        COD_RAPPORTO ,
        Dta_Ins ,
        Flg_Tipo_Rapporto
      )
      VALUES
      (
        L_cod_contropartita,
        L_COD_FILIALE_COMPETENTE ,
        L_COD_PRODOTTO ,
        L_COD_RAPPORTO ,
        L_Dta_Ins ,
        L_Flg_Tipo_Rapporto
      );
    L_Esito:='OK';
    Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.fnc_insert_rapporto_spesa','1',SQLCODE,Sqlerrm,'inserimento rapporto spesa e contropartita  riuscito',Utente);
  EXCEPTION
  WHEN OTHERS THEN
    L_Esito:='KO';
    Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.fnc_insert_rapporto_spesa','2',SQLCODE,Sqlerrm,'inserimento rapporto spesa e contropartita non riuscito',Utente);
  END;
  RETURN L_Esito;
end FNC_INSERT_RAPPORTO_SPESA_CON;

/************************************************************************************
*****************************************************************************************/

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
  RETURN NUMBER
IS

c_nome   CONSTANT VARCHAR2 (100)
                               := c_package || '.FNC_INSERISCI_RAPPORTO';
   v_note            t_mcres_wrk_audit_applicativo.note%TYPE;
   v_exists          NUMBER (1);
   utente VARCHAR2(255);

BEGIN
BEGIN
  utente := p_cod_operatore_ins_upd;

    INSERT
    INTO t_mcres_app_rapporti
      (
        COD_ABI ,
        COD_ABI_CARTOLARIZZANTE ,
        COD_DIVISA ,
        COD_FORMA_TECNICA ,
        COD_NDG ,
        COD_OPERATORE_INS_UPD ,
        COD_RAPPORTO ,
        COD_SNDG ,
        COD_SSA ,
        COD_TIPO_FONDO_TERZO ,
        COD_UO_RAPPORTO ,
        DESC_FORMA_TECNICA ,
        DTA_APERTURA_RAPP ,
        DTA_CHIUSURA_RAPP ,
        DTA_INS ,
        DTA_NBV ,
        DTA_UPD ,
        FLG_RAPP_CARTOLARIZZATO ,
        FLG_RAPP_ESTERO ,
        FLG_RAPP_FONDO_TERZO ,
        ID_DPER ,
        VAL_IMP_GBV ,
        VAL_IMP_GBV_INIZIALE ,
        VAL_IMP_NBV ,
        VAL_IMP_NBV_INIZIALE ,
        VAL_IMP_TOT_INCASSI ,
        Val_Imp_Vantato ,
        VAL_SOCIETA_CARTOLARIZZAZIONE,
        COD_RAPPORTO_ORIG
      )
      VALUES
      (
        P_COD_ABI ,
        P_COD_ABI_CARTOLARIZZANTE ,
        --AP 12/10/2012 CABLATO COD_DIVISA A 'EUR' PERCHÃ¿ I RAPPORTI INSERITI DA CRUSSOTTO HANNO SEMPRE COD_DIVISA = EUR
        'EUR', --P_COD_DIVISA
        P_COD_FORMA_TECNICA ,
        P_COD_NDG ,
        P_COD_OPERATORE_INS_UPD ,
        P_COD_RAPPORTO ,
        P_COD_SNDG ,
        --AP 12/10/2012 CABLATO COD_SSA A MO PERCHÃ¿ I RAPPORTI INSERITI DA CRUSSOTTO HANNO SEMPRE COD_SSA = MO
        'MO', --P_COD_SSA
        P_COD_TIPO_FONDO_TERZO ,
        P_COD_UO_RAPPORTO ,
        P_DESC_FORMA_TECNICA ,
        P_DTA_APERTURA_RAPP ,
        --AP 12/10/2012 VALORIZZATA SEMPRE LA DATA DI CHIUSURA A 31/12/9999
        TO_DATE('31/12/9999','DD/MM/YYYY'), --P_DTA_CHIUSURA_RAPP
        SYSDATE,
        P_DTA_NBV ,
        SYSDATE,
        P_FLG_RAPP_CARTOLARIZZATO ,
        P_FLG_RAPP_ESTERO ,
        P_FLG_RAPP_FONDO_TERZO ,
        P_ID_DPER ,
        P_VAL_IMP_GBV ,
        P_VAL_IMP_GBV_INIZIALE ,
        P_VAL_IMP_NBV ,
        P_VAL_IMP_NBV_INIZIALE ,
        P_VAL_IMP_TOT_INCASSI ,
        P_Val_Imp_Vantato ,
        P_VAL_SOCIETA_CARTOLARIZZAZIo,
        P_COD_RAPPORTO_ORIG
      );

    Pkg_Mcres_Audit.Log_App(c_nome,pkg_mcres_audit.c_debug,SQLCODE,Sqlerrm,'inserimento rapporto   riuscito',Utente);
   return ok;

  EXCEPTION
  WHEN OTHERS THEN

    Pkg_Mcres_Audit.Log_App(c_nome,pkg_mcres_audit.c_error,SQLCODE,Sqlerrm,'inserimento rapporto non riuscito',Utente);
    return ko;
  END;
end FNC_INSERISCI_RAPPORTO;

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
P_val_gruppo t_mcres_app_delibere.val_gruppo%type default null,
P_cod_uo t_mcres_app_delibere.cod_uo%type default null,
p_val_causale t_mcres_app_delibere.val_causale%type default null
  )
  RETURN number
is
  C_NOME CONSTANT varchar2(100) := C_PACKAGE || '.FNC_INSERT_DELIBERE';
  v_NOTE           T_MCREs_WRK_AUDIT_APPLICATIVO.NOTE%type:='GENERALE';
  v_cont_delibere number;
  V_COD_UO_pratica  varchar2(5);
  v_flg_step5_active T_MCRES_app_delibere.flg_step5_active%type;
BEGIN

    begin
      select decode(VALORE_COSTANTE,null,0,1)
      INTO v_flg_step5_active
      from T_MCRES_WRK_CONFIGURAZIONE
      where nome_costante = 'ATTIVAZIONE_STEP_5';
    EXCEPTION
      When no_data_found Then
        v_flg_step5_active:=0;
    end;

    begin
      select COUNT(*)
      INTO v_Cont_Delibere
      from T_MCRES_APP_DELIBERE
      where COD_ABI              = P_COD_ABI
      and COD_NDG                = P_COD_NDG
      And Cod_Protocollo_Delibera = P_Cod_Protocollo_Delibera;
    EXCEPTION
      When no_data_found Then
        v_Cont_Delibere:=0;
    end;

    if (V_CONT_DELIBERE =0) then

      V_NOTE:='Set UO - ABI='||p_cod_abi||' NDG='||p_cod_ndg||' Protocollo='||P_Cod_Protocollo_Delibera;
      if (p_COD_UO_pratica is null) then
        begin
          SELECT cod_uo_pratica
          INTO v_cod_uo_pratica
          FROM t_mcres_app_pratiche
          WHERE val_anno            = P_val_anno_pratica
          AND cod_pratica           = P_cod_pratica
          and COD_ABI               = P_COD_ABI;
        EXCEPTION
          when OTHERS then
            PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE||' - Pratica'||p_cod_pratica||' Anno='||p_val_anno_pratica,p_UTENTE);
            return KO;
        end;
      else
        v_cod_uo_pratica := p_COD_UO_pratica;
      end if;

        V_NOTE:='Get Protocollo Delibera - ABI='||P_COD_ABI||' NDG='||P_COD_NDG||' Protocollo='||P_COD_PROTOCOLLO_DELIBERA;
        if(p_cod_delibera='VA')then
             p_Cod_Protocollo_Delibera:=fnc_mcres_protocollo_delibera(v_Cod_Uo_pratica,p_Utente);
        else
            p_Cod_Protocollo_Delibera:=Pkg_Mcrei_Gest_Delibere.Fnc_Mcrei_Protocollo_Delibera(v_Cod_Uo_pratica,p_Utente);
        end if;

        V_NOTE:='Insert Delibera - ABI='||p_cod_abi||' NDG='||p_cod_ndg||' Protocollo='||P_Cod_Protocollo_Delibera;
        insert into t_mcres_app_delibere
        (
            id_dper,
            cod_abi,
            cod_ndg,
            cod_sndg,
            cod_protocollo_delibera,
            dta_inserimento_delibera,
            dta_aggiornamento_delibera,
            cod_delibera,
            cod_stato_delibera,
            cod_organo_deliberante,
            flg_presa_visione,
            val_anno_pratica,
            cod_pratica,
            val_anno_proposta,
            cod_proposta,
            cod_protocollo_delibera_coll,
            dta_ins,
            dta_upd,
            cod_operatore_ins_upd,
            desc_motivazione_forzatura,
            val_indicatore_accantonamento,
            val_utente_azione,
            val_autorita_giudiziaria,
            val_oggetto_domanda,
            val_imp_domanda,
            val_accant_rischi_oneri,
            val_new_accant_rischi_oneri,
            dta_prevedibile_esborso,
            flg_contenzioso_passivo,
            val_eff_conto_economico,
            dta_esborso,
            flg_stralcio,
            val_esposizione_lorda,
            val_esposizione_netta,
            val_imp_stralcio,
            dta_notifica_atto,
            val_esborso,
            dta_sicli,
            val_uti,
            val_uti_capitale,
            val_uti_mora,
            val_vantato,
            val_vantato_rateo,
            val_vantato_stralci,
            val_esp_lorda_capitale,
            val_esp_lorda_mora,
            val_rett_da_incaglio,
            val_rett_da_inc_stralci,
            val_rett_val_ante_del,
            val_rett_val_ante_del_fuori,
            val_rett_val_ante_del_rdv,
            val_rett_val_ante_del_inter,
            val_rett_val_ante_del_spese,
            val_rett_val_in_del,
            val_esposizione_lorda_stralcio,
            val_esposizione_netta_stralcio,
            val_note,
            dta_delibera,
            cod_matr_ins,
            val_esposizione_lorda_cap,
            val_accant_ante_del,
            val_esposizione_netta_ante_del,
            val_rettifica_valore_prop,
            val_esposizione_netta_post_del,
            val_importo_offerto,
            flg_pvisione_gestore,
            flg_pvisione_presidio,
            cod_stato_soff,
            ----------Campi nuovi
            cod_CAUSALE_CHIUSURA      ,
            COD_FILIALE_CLASS         ,
            DESC_FILIALE_CLASS        ,
            DESC_ADDETTO              ,
            COD_MATR_PRATICA          ,
            cod_SEGMENTO              ,
            DTA_PASS_STATO_RISC       ,
            cod_STATO_RISCHIO         ,
            DTA_INCAGLIO              ,
            cod_STATO_PC              ,
            DTA_STATO_GIUR            ,
            val_CODICE_CR             ,
            cod_RAMO                  ,
            cod_SETTORE               ,
            DESC_RAMO                 ,
            DESC_SETTORE              ,
            COD_PARTITA_IVA           ,
            val_ESPOS_LORDA_TOT       ,
            val_IMPORTO_SACRIFICIO    ,
            val_NOTE_flusso           ,
            cod_TIPO_TRANSAZIONE      ,
            val_VANTATO_NOCONT        ,
            COD_FISCALE               ,
            cod_TIPO_STRALCIO         ,
            FLG_IND_GARANTI           ,
            val_NOTE_DESC_ANN         ,
            DTA_AGG_SISBA             ,
            val_VANTATO_SISBA         ,
            val_MORA_SISBA            ,
            val_STRALCI_FISC_SOFF     ,
            val_UTILIZZO_SISBA        ,
            val_ACCTI_SISBA           ,
            val_ATTUALIZ_SISBA        ,
            val_STRAL_QT_CAP_SISBA    ,
            val_STRAL_QT_MORA_SISBA   ,
            val_CAPITALE_SISBA        ,
            val_UTILIZZO_SICLI        ,
            val_CAPITALE_SICLI        ,
            val_MORA_SICLI            ,
            DTA_AGG_SICLI             ,
            val_ESPOS_LORDA_QT_MORA   ,
            val_RDV_QC_DA_INCAGLIO    ,
            val_PERC_RETT_VAL         ,
            DTA_SCADENZA              ,
            DTA_DEL_ESTERA            ,
            DTA_SCAD_DEL_ESTERA       ,
            val_PERC_DUBBIO_ESITO_EST ,
            val_RETT_QT_CAP_ANTE98    ,
            val_RETT_QT_CAP_PROGR     ,
            val_INTERES_CORR          ,
            val_SPESE_LEGALI          ,
            val_ESPOS_LORDA_CAP_MORA  ,
            val_ACCTI_DELIB           ,
            DTA_STAMPA                ,
            DTA_SCADENZA_TRANSAZIONE  ,
            val_gruppo,
            cod_uo,
            cod_uo_pratica,
            flg_step5_active,
            val_causale
        )
        values
        (
            TO_CHAR (SYSDATE, 'YYYYMMDD'),
            p_cod_abi,
            p_cod_ndg,
            p_cod_sndg,
            p_cod_protocollo_delibera,
            p_dta_inserimento_delibera,
            p_dta_aggiornamento_delibera,
            p_cod_delibera,
            p_cod_stato_delibera,
            p_cod_organo_deliberante,
            p_flg_presa_visione,
            p_val_anno_pratica,
            p_cod_pratica,
            p_val_anno_proposta,
            p_cod_proposta,
            p_cod_protocollo_delibera_coll,
            p_dta_ins,
            p_dta_upd,
            p_cod_operatore_ins_upd,
            p_desc_motivazione_forzatura,
            p_val_indicatore_accanton,
            p_val_utente_azione,
            p_val_autorita_giudiziaria,
            p_val_oggetto_domanda,
            p_val_imp_domanda,
            p_val_accant_rischi_oneri,
            p_val_new_accant_rischi_oneri,
            p_dta_prevedibile_esborso,
            p_flg_contenzioso_passivo,
            p_val_eff_conto_economico,
            p_dta_esborso,
            p_flg_stralcio,
            p_val_esposizione_lorda,
            p_val_esposizione_netta,
            p_val_imp_stralcio,
            p_dta_notifica_atto,
            p_val_esborso,
            p_dta_sicli,
            p_val_uti,
            p_val_uti_capitale,
            p_val_uti_mora,
            p_val_vantato,
            p_val_vantato_rateo,
            p_val_vantato_stralci,
            p_val_esp_lorda_capitale,
            p_val_esp_lorda_mora,
            p_val_rett_da_incaglio,
            p_val_rett_da_inc_stralci,
            p_val_rett_val_ante_del,
            p_val_rett_val_ante_del_fuori,
            p_val_rett_val_ante_del_rdv,
            p_val_rett_val_ante_del_inter,
            p_val_rett_val_ante_del_spese,
            p_val_rett_val_in_del,
            p_val_esp_lorda_stralcio,
            p_val_esp_netta_stralcio,
            p_val_note,
            p_dta_delibera,
            SUBSTR (p_cod_operatore_ins_upd, 2, 6),                                                                                                                                                                                                                                            --P_COD_MATR_INS,
            p_val_esposizione_lorda_cap,
            p_val_accant_ante_del,
            p_val_esp_netta_ante_del,
            p_val_rettifica_valore_prop,
            p_val_esp_netta_post_del,
            p_val_importo_offerto,
            'N',
            'N',
            p_cod_stato_soff,
            ----- Campi nuovi
            P_cod_CAUSALE_CHIUSURA      ,
            P_COD_FILIALE_CLASS         ,
            P_DESC_FILIALE_CLASS        ,
            P_DESC_ADDETTO              ,
            P_COD_MATR_PRATICA          ,
            P_cod_SEGMENTO              ,
            P_DTA_PASS_STATO_RISC       ,
            nvl(P_cod_STATO_RISCHIO,'S')         ,
            P_DTA_INCAGLIO              ,
            P_cod_STATO_PC              ,
            P_DTA_STATO_GIUR            ,
            P_val_CODICE_CR             ,
            P_cod_RAMO                  ,
            P_cod_SETTORE               ,
            P_DESC_RAMO                 ,
            P_DESC_SETTORE              ,
            P_COD_PARTITA_IVA           ,
            P_val_ESPOS_LORDA_TOT       ,
            P_val_IMPORTO_SACRIFICIO    ,
            P_val_NOTE_flusso           ,
            P_cod_TIPO_TRANSAZIONE      ,
            P_val_VANTATO_NOCONT        ,
            P_COD_FISCALE               ,
            P_cod_TIPO_STRALCIO         ,
            P_FLG_IND_GARANTI           ,
            P_val_NOTE_DESC_ANN         ,
            P_DTA_AGG_SISBA             ,
            P_val_VANTATO_SISBA         ,
            P_val_MORA_SISBA            ,
            P_val_STRALCI_FISC_SOFF     ,
            P_val_UTILIZZO_SISBA        ,
            P_val_ACCTI_SISBA           ,
            P_val_ATTUALIZ_SISBA        ,
            P_val_STRAL_QT_CAP_SISBA    ,
            P_val_STRAL_QT_MORA_SISBA   ,
            P_val_CAPITALE_SISBA        ,
            P_val_UTILIZZO_SICLI        ,
            P_val_CAPITALE_SICLI        ,
            P_val_MORA_SICLI            ,
            P_DTA_AGG_SICLI             ,
            P_val_ESPOS_LORDA_QT_MORA   ,
            P_val_RDV_QC_DA_INCAGLIO    ,
            P_val_PERC_RETT_VAL         ,
            P_DTA_SCADENZA              ,
            P_DTA_DEL_ESTERA            ,
            P_DTA_SCAD_DEL_ESTERA       ,
            P_val_PERC_DUBBIO_ESITO_EST ,
            P_val_RETT_QT_CAP_ANTE98    ,
            P_val_RETT_QT_CAP_PROGR     ,
            P_val_INTERES_CORR          ,
            P_val_SPESE_LEGALI          ,
            P_val_ESPOS_LORDA_CAP_MORA  ,
            P_val_ACCTI_DELIB           ,
            P_DTA_STAMPA                ,
            P_DTA_SCADENZA_TRANSAZIONE  ,
            p_val_gruppo,
            nvl(p_cod_uo, v_cod_uo_pratica), -- AG 20130225
            p_cod_uo_pratica,
            v_flg_step5_active,
            p_val_causale
        );
    else

        v_note:='Update Delibera - ABI='||p_cod_abi||' NDG='||p_cod_ndg||' Protocollo='||p_cod_protocollo_delibera;

        update t_mcres_app_delibere
        set id_dper                          = TO_CHAR (SYSDATE, 'YYYYMMDD'),
            dta_inserimento_delibera         = NVL (dta_inserimento_delibera, p_dta_inserimento_delibera),                                                                                                                                                                          -- se valorizzata non si aggiorna
            dta_aggiornamento_delibera       = p_dta_aggiornamento_delibera,
            cod_delibera                     = p_cod_delibera,
            cod_stato_delibera               = p_cod_stato_delibera,
            cod_organo_deliberante           = p_cod_organo_deliberante,
            flg_presa_visione                = p_flg_presa_visione,
            val_anno_pratica                 = p_val_anno_pratica,
            cod_pratica                      = p_cod_pratica,
            val_anno_proposta                = p_val_anno_proposta,
            cod_proposta                     = p_cod_proposta,
            cod_protocollo_delibera_coll     = p_cod_protocollo_delibera_coll,
            dta_ins                          = p_dta_ins,
            dta_upd                          = p_dta_upd,
            cod_operatore_ins_upd            = p_cod_operatore_ins_upd,
            desc_motivazione_forzatura       = NVL (p_desc_motivazione_forzatura, desc_motivazione_forzatura),
            val_indicatore_accantonamento    = NVL (p_val_indicatore_accanton, val_indicatore_accantonamento),
            val_utente_azione                = NVL (p_val_utente_azione, val_utente_azione),
            val_autorita_giudiziaria         = NVL (p_val_autorita_giudiziaria, val_autorita_giudiziaria),
            val_oggetto_domanda              = NVL (p_val_oggetto_domanda, val_oggetto_domanda),
            val_imp_domanda                  = p_val_imp_domanda,
            val_accant_rischi_oneri          = NVL (p_val_accant_rischi_oneri, val_accant_rischi_oneri),
            val_new_accant_rischi_oneri      = NVL (p_val_new_accant_rischi_oneri, val_new_accant_rischi_oneri),
            dta_prevedibile_esborso          = NVL (p_dta_prevedibile_esborso, dta_prevedibile_esborso),
            flg_contenzioso_passivo          = NVL (p_flg_contenzioso_passivo, flg_contenzioso_passivo),
            val_eff_conto_economico          = NVL (p_val_eff_conto_economico, val_eff_conto_economico),
            dta_esborso                      = NVL (p_dta_esborso, dta_esborso),
            flg_stralcio                     = NVL (p_flg_stralcio, flg_stralcio),
            val_esposizione_lorda            = NVL (p_val_esposizione_lorda, val_esposizione_lorda),
            val_esposizione_netta            = NVL (p_val_esposizione_netta, val_esposizione_netta),
            val_imp_stralcio                 = NVL (p_val_imp_stralcio, val_imp_stralcio),
            dta_notifica_atto                = NVL (p_dta_notifica_atto, dta_notifica_atto),
            val_esborso                      = NVL (p_val_esborso, val_esborso),
            dta_sicli                        = NVL (p_dta_sicli, dta_sicli),
            val_uti                          = NVL (p_val_uti, val_uti),
            val_uti_capitale                 = NVL (p_val_uti_capitale, val_uti_capitale),
            val_uti_mora                     = NVL (p_val_uti_mora, val_uti_mora),
            val_vantato                      = NVL (p_val_vantato, val_vantato),
            val_vantato_rateo                = NVL (p_val_vantato_rateo, val_vantato_rateo),
            val_vantato_stralci              = NVL (p_val_vantato_stralci, val_vantato_stralci),
            val_esp_lorda_capitale           = NVL (p_val_esp_lorda_capitale, val_esp_lorda_capitale),
            val_esp_lorda_mora               = NVL (p_val_esp_lorda_mora, val_esp_lorda_mora),
            val_rett_da_incaglio             = NVL (p_val_rett_da_incaglio, val_rett_da_incaglio),
            val_rett_da_inc_stralci          = NVL (p_val_rett_da_inc_stralci, val_rett_da_inc_stralci),
            val_rett_val_ante_del            = NVL (p_val_rett_val_ante_del, val_rett_val_ante_del),
            val_rett_val_ante_del_fuori      = NVL (p_val_rett_val_ante_del_fuori, val_rett_val_ante_del_fuori),
            val_rett_val_ante_del_rdv        = NVL (p_val_rett_val_ante_del_rdv, val_rett_val_ante_del_rdv),
            val_rett_val_ante_del_inter      = NVL (p_val_rett_val_ante_del_inter, val_rett_val_ante_del_inter),
            val_rett_val_ante_del_spese      = NVL (p_val_rett_val_ante_del_spese, val_rett_val_ante_del_spese),
            val_rett_val_in_del              = NVL (p_val_rett_val_in_del, val_rett_val_in_del),
            val_esposizione_lorda_stralcio   = NVL (p_val_esp_lorda_stralcio, val_esposizione_lorda_stralcio),
            val_esposizione_netta_stralcio   = NVL (p_val_esp_netta_stralcio, val_esposizione_netta_stralcio),
            val_note                         = NVL (p_val_note, val_note),
            dta_delibera                     = NVL (p_dta_delibera, dta_delibera),
            cod_matr_ins                     = NVL (p_cod_matr_ins, cod_matr_ins),
            val_esposizione_lorda_cap        = NVL (p_val_esposizione_lorda_cap, val_esposizione_lorda_cap),
            val_accant_ante_del              = NVL (p_val_accant_ante_del, val_accant_ante_del),
            val_esposizione_netta_ante_del   = NVL (p_val_esp_netta_ante_del, val_esposizione_netta_ante_del),
            val_rettifica_valore_prop        = NVL (p_val_rettifica_valore_prop, val_rettifica_valore_prop),
            val_esposizione_netta_post_del   = NVL (p_val_esp_netta_post_del, val_esposizione_netta_post_del),
            val_importo_offerto              = NVL (p_val_importo_offerto, val_importo_offerto),
            cod_stato_soff                   = NVL (p_cod_stato_soff, cod_stato_soff),
            ---- Nuovi campi
            cod_CAUSALE_CHIUSURA       = nvl(p_cod_CAUSALE_CHIUSURA     ,cod_CAUSALE_CHIUSURA     ),
            COD_FILIALE_CLASS          = nvl(p_COD_FILIALE_CLASS        ,COD_FILIALE_CLASS        ),
            DESC_FILIALE_CLASS         = nvl(p_DESC_FILIALE_CLASS       ,DESC_FILIALE_CLASS       ),
            DESC_ADDETTO               = nvl(p_DESC_ADDETTO             ,DESC_ADDETTO             ),
            COD_MATR_PRATICA           = nvl(p_COD_MATR_PRATICA         ,COD_MATR_PRATICA         ),
            cod_SEGMENTO               = nvl(p_cod_SEGMENTO             ,cod_SEGMENTO             ),
            DTA_PASS_STATO_RISC        = nvl(p_DTA_PASS_STATO_RISC      ,DTA_PASS_STATO_RISC      ),
            cod_STATO_RISCHIO          = nvl(p_cod_STATO_RISCHIO        ,cod_STATO_RISCHIO        ),
            DTA_INCAGLIO               = nvl(p_DTA_INCAGLIO             ,DTA_INCAGLIO             ),
            cod_STATO_PC               = nvl(p_cod_STATO_PC             ,cod_STATO_PC             ),
            DTA_STATO_GIUR             = nvl(p_DTA_STATO_GIUR           ,DTA_STATO_GIUR           ),
            val_CODICE_CR              = nvl(p_val_CODICE_CR            ,val_CODICE_CR            ),
            cod_RAMO                   = nvl(p_cod_RAMO                 ,cod_RAMO                 ),
            cod_SETTORE                = nvl(p_cod_SETTORE              ,cod_SETTORE              ),
            DESC_RAMO                  = nvl(p_DESC_RAMO                ,DESC_RAMO                ),
            DESC_SETTORE               = nvl(p_DESC_SETTORE             ,DESC_SETTORE             ),
            COD_PARTITA_IVA            = nvl(p_COD_PARTITA_IVA          ,COD_PARTITA_IVA          ),
            val_ESPOS_LORDA_TOT        = nvl(p_val_ESPOS_LORDA_TOT      ,val_ESPOS_LORDA_TOT      ),
            val_IMPORTO_SACRIFICIO     = nvl(p_val_IMPORTO_SACRIFICIO   ,val_IMPORTO_SACRIFICIO   ),
            val_NOTE_flusso            = nvl(p_val_NOTE_flusso          ,val_NOTE_flusso          ),
            cod_TIPO_TRANSAZIONE       = nvl(p_cod_TIPO_TRANSAZIONE     ,cod_TIPO_TRANSAZIONE     ),
            val_VANTATO_NOCONT         = nvl(p_val_VANTATO_NOCONT       ,val_VANTATO_NOCONT       ),
            COD_FISCALE                = nvl(p_COD_FISCALE              ,COD_FISCALE              ),
            cod_TIPO_STRALCIO          = nvl(p_cod_TIPO_STRALCIO        ,cod_TIPO_STRALCIO        ),
            FLG_IND_GARANTI            = nvl(p_FLG_IND_GARANTI          ,FLG_IND_GARANTI          ),
            val_NOTE_DESC_ANN          = nvl(p_val_NOTE_DESC_ANN        ,val_NOTE_DESC_ANN        ),
            DTA_AGG_SISBA              = nvl(p_DTA_AGG_SISBA            ,DTA_AGG_SISBA            ),
            val_VANTATO_SISBA          = nvl(p_val_VANTATO_SISBA        ,val_VANTATO_SISBA        ),
            val_MORA_SISBA             = nvl(p_val_MORA_SISBA           ,val_MORA_SISBA           ),
            val_STRALCI_FISC_SOFF      = nvl(p_val_STRALCI_FISC_SOFF    ,val_STRALCI_FISC_SOFF    ),
            val_UTILIZZO_SISBA         = nvl(p_val_UTILIZZO_SISBA       ,val_UTILIZZO_SISBA       ),
            val_ACCTI_SISBA            = nvl(p_val_ACCTI_SISBA          ,val_ACCTI_SISBA          ),
            val_ATTUALIZ_SISBA         = nvl(p_val_ATTUALIZ_SISBA       ,val_ATTUALIZ_SISBA       ),
            val_STRAL_QT_CAP_SISBA     = nvl(p_val_STRAL_QT_CAP_SISBA   ,val_STRAL_QT_CAP_SISBA   ),
            val_STRAL_QT_MORA_SISBA    = nvl(p_val_STRAL_QT_MORA_SISBA  ,val_STRAL_QT_MORA_SISBA  ),
            val_CAPITALE_SISBA         = nvl(p_val_CAPITALE_SISBA       ,val_CAPITALE_SISBA       ),
            val_UTILIZZO_SICLI         = nvl(p_val_UTILIZZO_SICLI       ,val_UTILIZZO_SICLI       ),
            val_CAPITALE_SICLI         = nvl(p_val_CAPITALE_SICLI       ,val_CAPITALE_SICLI       ),
            val_MORA_SICLI             = nvl(p_val_MORA_SICLI           ,val_MORA_SICLI           ),
            DTA_AGG_SICLI              = nvl(p_DTA_AGG_SICLI            ,DTA_AGG_SICLI            ),
            val_ESPOS_LORDA_QT_MORA    = nvl(p_val_ESPOS_LORDA_QT_MORA  ,val_ESPOS_LORDA_QT_MORA  ),
            val_RDV_QC_DA_INCAGLIO     = nvl(p_val_RDV_QC_DA_INCAGLIO   ,val_RDV_QC_DA_INCAGLIO   ),
            val_PERC_RETT_VAL          = nvl(p_val_PERC_RETT_VAL        ,val_PERC_RETT_VAL        ),
            DTA_SCADENZA               = nvl(p_DTA_SCADENZA             ,DTA_SCADENZA             ),
            DTA_DEL_ESTERA             = nvl(p_DTA_DEL_ESTERA           ,DTA_DEL_ESTERA           ),
            DTA_SCAD_DEL_ESTERA        = nvl(p_DTA_SCAD_DEL_ESTERA      ,DTA_SCAD_DEL_ESTERA      ),
            val_PERC_DUBBIO_ESITO_EST  = nvl(p_val_PERC_DUBBIO_ESITO_EST,val_PERC_DUBBIO_ESITO_EST),
            val_RETT_QT_CAP_ANTE98     = nvl(p_val_RETT_QT_CAP_ANTE98   ,val_RETT_QT_CAP_ANTE98   ),
            val_RETT_QT_CAP_PROGR      = nvl(p_val_RETT_QT_CAP_PROGR    ,val_RETT_QT_CAP_PROGR    ),
            val_INTERES_CORR           = nvl(p_val_INTERES_CORR         ,val_INTERES_CORR         ),
            val_SPESE_LEGALI           = nvl(p_val_SPESE_LEGALI         ,val_SPESE_LEGALI         ),
            val_ESPOS_LORDA_CAP_MORA   = nvl(p_val_ESPOS_LORDA_CAP_MORA ,val_ESPOS_LORDA_CAP_MORA ),
            val_ACCTI_DELIB            = nvl(p_val_ACCTI_DELIB          ,val_ACCTI_DELIB          ),
            DTA_STAMPA                 = nvl(p_DTA_STAMPA               ,DTA_STAMPA               ),
            DTA_SCADENZA_TRANSAZIONE   = nvl(p_DTA_SCADENZA_TRANSAZIONE ,DTA_SCADENZA_TRANSAZIONE ),
            val_gruppo = nvl(p_val_gruppo,val_gruppo),
            cod_uo = nvl(p_cod_uo, cod_uo),
            val_causale = nvl(p_val_causale,val_causale)
        where     cod_abi = p_cod_abi
              and cod_ndg = p_cod_ndg
              and cod_protocollo_delibera = p_cod_protocollo_delibera;
    end if;

    v_note := 'Aggiornamento data inoltro';
    if P_COD_STATO_DELIBERA = 'IT'
    then

        update t_mcres_app_delibere
        set dta_inoltro = trunc(sysdate)
        where cod_abi = p_cod_abi
        and cod_ndg = p_cod_ndg
        and cod_protocollo_delibera = p_cod_protocollo_delibera
        and dta_inoltro is null;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Aggiornata data inoltro delibera ABI - NDG - PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera, p_utente);

    end if;

    v_note := 'Aggiornamento data trasferimento';

    if P_COD_STATO_DELIBERA  = 'TR'
    then

            update t_mcres_app_delibere
            set dta_trasferimento = trunc(sysdate)
            where cod_Abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_protocollo_delibera = p_cod_protocollo_delibera
            and dta_trasferimento is null;

         pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Aggiornata data trasferimento delibera ABI - NDG - PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera, p_utente);

    end if;


    return OK;

EXCEPTION
  when OTHERS then
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_UTENTE);
    return ko;
end FNC_INSERT_DELIBERE;

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
    l_dta_ins DATE,
    Utente VARCHAR2 )
  RETURN VARCHAR2
IS
  l_ritorno VARCHAR2(2);
BEGIN
  <<Inserimento_Contropartita>>
  BEGIN
    SELECT LPAD(inserimento_contropartite.nextval,20,0)
    INTO L_COD_CONTROPARTITA
    FROM DUAL;
    INSERT
    INTO T_Mcres_App_Sp_contropartita
      (
        COD_CONTROPARTITA ,
        COD_TIPO ,
        COD_DIVISA ,
        VAL_IMPORTO ,
        COD_FILIALE ,
        COD_AUTORIZZAZIONE ,
        DTA_INS ,
        VAL_NUOVA_OPERAZIONE ,
        COD_OPERAZIONE_FATT ,
        COD_PROGR_OPERAZIONE ,
        DTA_SOLARE_OPERAZIONE ,
        COD_RIFERIMENTO
      )
      VALUES
      (
        L_COD_CONTROPARTITA ,
        L_COD_TIPO ,
        L_COD_DIVISA ,
        L_VAL_IMPORTO ,
        L_COD_FILIALE ,
        L_COD_AUTORIZZAZIONE ,
        L_DTA_INS ,
        L_VAL_NUOVA_OPERAZIONE ,
        L_COD_OPERAZIONE_FATT ,
        L_COD_PROGR_OPERAZIONE ,
         to_date(L_DTA_SOLARE_OPERAZIONE, 'yyyymmdd')  ,
        L_Cod_Riferimento
      );
    L_Ritorno:='OK';
    Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.FNC_INSERT_CONTROPARTITA',pkg_mcres_audit.c_debug,SQLCODE,Sqlerrm,'inserimento contropartita  riuscito',Utente);
  EXCEPTION
  WHEN OTHERS THEN
    Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.FNC_INSERT_CONTROPARTITA',pkg_mcres_audit.c_error,SQLCODE,Sqlerrm,'inserimento contropartita non riuscito',Utente);
    L_Ritorno:='KO';
  END Inserimento_Contropartita;
  RETURN l_ritorno;
end FNC_INSERT_CONTROPARTITA;

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
  RETURN VARCHAR2
is
  C_NOME CONSTANT varchar2(100) := C_PACKAGE || '.FNC_INSERT_RAPPORTO_SPESA';
  v_NOTE           T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%type:='GENERALE';
  --v_COD_autorizzazione      T_MCRES_APP_SP_spese.COD_autorizzazione%type;
begin
    /*v_NOTE:='GET cod_autorizzazione - CONTROPARTITA='||P_COD_CONTROPARTITA ||' COD_RAPPORTO='||p_COD_RAPPORTO;
    select distinct COD_autorizzazione
    into v_COD_autorizzazione
    from t_mcres_app_sp_contropartita
    where COD_contropartita = p_COD_contropartita;*/

    v_NOTE:='Inserimento rapporto COD_RAPPORTO='||p_COD_RAPPORTO;
    INSERT INTO t_mcres_app_sp_rapporto
      (
       -- COD_autorizzazione,
        COD_RAPPORTO ,
        COD_CONTROPARTITA ,
        COD_FILIALE_COMPETENTE ,
        DTA_INS ,
        Flg_Tipo_Rapporto ,
        COD_PRODOTTO
      )
      VALUES
      (
    --    v_COD_autorizzazione,
        p_COD_RAPPORTO ,
        p_COD_CONTROPARTITA ,
        p_COD_FILIALE_COMPETENTE ,
        p_DTA_INS ,
        p_FLG_TIPO_RAPPORTO ,
        p_COD_PRODOTTO
      );

    return 'OK';

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_UTENTE);
    RETURN 'KO';
end FNC_INSERT_RAPPORTO_SPESA;

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
    l_cod_id_legale              in t_mcres_app_sp_spese.cod_id_legale%type default null,
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
  RETURN VARCHAR2
IS
  L_Ritorno VARCHAR2(2);
  v_note    t_mcres_wrk_audit_applicativo.note%type;
  v_exists  pls_integer;

BEGIN

    v_note := 'Controllo esistenza fattura duplicata';

    if      l_val_numero_fattura is not null
        and l_dta_fattura is not null
        and l_cod_tipo_autorizzazione in ('1', '5', '6')
        and l_cod_autorizzazione_padre is null  -- non effettuo il controllo sulle spese figlie
    then

        if l_cod_tipo_autorizzazione = '5' -- proforma qualsiasi
        or l_cod_autorizzazione is null    -- inserimento di fattura o fattura multipla (padre)
        then

            select count(*)
            into v_exists
            from t_mcres_app_sp_spese
            where 0=0
                and cod_autorizzazione_padre is null
                and val_numero_fattura = l_val_numero_fattura
                and trunc(dta_fattura, 'Y') = trunc(l_dta_fattura, 'Y')
                and val_intestatario_codfisc = l_val_intestatario_codfisc
                --AP 05/05/2014 AGGIUNTA ESCLUSIONE ANNULLATE MOPLE
                and cod_stato NOT IN ('AN','X')
                --and cod_stato != 'AN'
                and rownum <= 1;

        else -- aggiornamento fattura o fattura multipla

            select count(*)
            into v_exists
            from t_mcres_app_sp_spese
            where 0=0
                and cod_autorizzazione_padre is null                    -- non cerco tra le spese figlie
                and cod_autorizzazione != l_cod_autorizzazione          -- diversa da quella che sto inserendo
                and val_numero_fattura = l_val_numero_fattura
                and trunc(dta_fattura, 'Y') = trunc(l_dta_fattura, 'Y')
                and val_intestatario_codfisc = l_val_intestatario_codfisc
                --AP 05/05/2014 AGGIUNTA ESCLUSIONE ANNULLATE MOPLE
                and cod_stato NOT IN ('AN','X')
                --and cod_stato != 'AN'
                and rownum <= 1;

        end if;


        if v_exists > 0
        then
            v_controllo_fattura := ko;

            pkg_mcres_audit.log_app('PKG_MCRES_FUNZIONI_PORTALE.FNC_MCRES_INS_UPD_SPESE',pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
                                    'controllo fattura duplicata fallito. COD_AUTORIZZAZ = ' || l_cod_autorizzazione
                                    || ' VAL_NUMERO_FATTURA = ' || l_val_numero_fattura ,utente);

            return 'OK';

        else
            v_controllo_fattura := ok;
        end if;

    else

        v_controllo_fattura := ok;

    end if;


  IF (L_COD_autorizzazione IS NOT NULL AND L_COD_AUTORIZZAZIONE_PADRE IS NULL) THEN
    BEGIN

      --
      --Aggiornamento spesa (principale) esistente
      --
      --Elimino le azioni (sia della spesa padre che delle eventuali figlie)
      DELETE
      FROM T_Mcres_App_Sp_Azioni
      WHERE Cod_Autorizzazione = L_Cod_Autorizzazione
      OR Cod_Autorizzazione   IN
        (SELECT cod_autorizzazione
        FROM T_Mcres_App_Sp_Spese
        WHERE cod_autorizzazione_padre = L_COD_autorizzazione
        );
      --Elimino i rapporti (sia della spesa padre che delle eventuali figlie)
      DELETE
      FROM T_Mcres_App_Sp_Rapporto
      WHERE Cod_Contropartita IN
        (SELECT Cod_Contropartita
        FROM T_Mcres_App_Sp_Contropartita
        WHERE Cod_Autorizzazione = L_Cod_Autorizzazione
        OR Cod_Autorizzazione   IN
          (SELECT cod_autorizzazione
          FROM T_Mcres_App_Sp_Spese
          WHERE cod_autorizzazione_padre = l_cod_autorizzazione
          )
        );
      --Elimino le contropartite (sia della spesa padre che delle eventuali figlie)
      DELETE
      FROM T_Mcres_App_Sp_Contropartita
      WHERE Cod_Autorizzazione = L_Cod_Autorizzazione
      OR Cod_Autorizzazione   IN
        (SELECT cod_autorizzazione
        FROM T_Mcres_App_Sp_Spese
        WHERE cod_autorizzazione_padre = l_cod_autorizzazione
        );
      --Elimino le spese figlie
      DELETE
      FROM T_Mcres_App_Sp_Spese
      WHERE Cod_Autorizzazione_Padre = L_Cod_Autorizzazione;
      L_Ritorno                     := 'OK';
      Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.fnc_mcres_ins_upd_spese',pkg_mcres_audit.c_debug,SQLCODE,Sqlerrm,'cancellazione spese riuscito COD_AUTORIZZAZ = ' || L_COD_AUTORIZZAZIONE,Utente);
      --Aggiornamento dati
      UPDATE mcre_own.t_mcres_app_sp_spese
      SET COD_ABI                  =L_COD_ABI ,
        COD_AFAVORE_TIPO           =L_COD_AFAVORE_TIPO ,
        Cod_Autorizzazione         =L_Cod_Autorizzazione ,
        COD_AUTORIZZAZIONE_PADRE   =NULL ,
        COD_CAUSA_DIVISA           =L_COD_CAUSA_DIVISA ,
        COD_CAUSALE                =L_COD_CAUSALE ,
        COD_CAUSALE_888            =L_COD_CAUSALE_888 ,
        COD_IBAN                   =L_COD_IBAN ,
        COD_IMPORTO_DIVISA         =L_COD_IMPORTO_DIVISA ,
        COD_INTESTATARIO_ABI       =L_COD_INTESTATARIO_ABI ,
        COD_INTESTATARIO_CAB       =L_COD_INTESTATARIO_CAB ,
        COD_INTESTATARIO_TIPO      =L_COD_INTESTATARIO_TIPO ,
        COD_MATRICOLA              =L_COD_MATRICOLA ,
        COD_MATRICOLA_AGG_STATO_Z  =L_COD_MATRICOLA_AGG_STATO_Z ,
        COD_NDG                    =L_COD_NDG ,
        COD_ORGANO_AUTORIZZANTE    =L_COD_ORGANO_AUTORIZZANTE ,
        COD_PRATICA                =L_COD_PRATICA ,
        COD_PRATICA_CEDUTA         =L_COD_PRATICA_CEDUTA ,
        COD_PROTOCOLLO             =L_COD_PROTOCOLLO ,
        COD_PUNTO_OPERATIVO        =L_COD_PUNTO_OPERATIVO ,
        COD_STATO                  =L_COD_STATO ,
        COD_TIPO_AUTORIZZAZIONE    =L_COD_TIPO_AUTORIZZAZIONE ,
        COD_TIPO_PAGAMENTO         =L_COD_TIPO_PAGAMENTO ,
        COD_UO                     =L_COD_UO ,
        COD_UO_PRATICA             =L_COD_UO_PRATICA ,
        DESC_AFAVORE               =L_DESC_AFAVORE ,
        DESC_INTESTATARIO          =L_DESC_INTESTATARIO ,
        DESC_SPESA                 =L_DESC_SPESA ,
        DTA_AUTORIZZAZIONE         =L_DTA_AUTORIZZAZIONE ,
        DTA_BON_VALUTA             =L_DTA_BON_VALUTA ,
        DTA_FATTURA                =L_DTA_FATTURA ,
        DTA_GENERAZIONE_PROTOCOLLO =L_DTA_GENERAZIONE_PROTOCOLLO ,
        DTA_INS_SPESA              =L_DTA_INS_SPESA ,
        DTA_PROFORMA_A_FATTURA     =L_DTA_PROFORMA_A_FATTURA ,
        DTA_STORNO_CONTABILE       =L_DTA_STORNO_CONTABILE ,
        DTA_UPD                    =L_DTA_UPD ,
        DTA_UPD_SPESA              =L_DTA_UPD_SPESA ,
        FLG_ANN_AUTORIZ            =L_FLG_ANN_AUTORIZ ,
        FLG_CARICO_CESSIONARIO     =L_FLG_CARICO_CESSIONARIO ,
        FLG_CONVENZIONE            =L_FLG_CONVENZIONE ,
        FLG_FM                     =L_FLG_FM ,
        FLG_SPESA_RECUPERATA       =L_FLG_SPESA_RECUPERATA ,
        FLG_SPESA_RIPETIBILE       =L_FLG_SPESA_RIPETIBILE ,
        VAL_AFAVORE_CODFISC        =L_VAL_AFAVORE_CODFISC ,
        VAL_AFAVORE_PIVA           =L_VAL_AFAVORE_PIVA ,
        VAL_ANNO_PRATICA           =L_VAL_ANNO_PRATICA ,
        VAL_BON_COORDINATE         =L_VAL_BON_COORDINATE ,
        VAL_BON_DESTINATARIO       =L_VAL_BON_DESTINATARIO ,
        VAL_CAUSA_IMPORTO          =L_VAL_CAUSA_IMPORTO ,
        VAL_CIRC_INTESTATARIO      =L_VAL_CIRC_INTESTATARIO ,
        VAL_CIRC_TRASFERIBILE      =L_VAL_CIRC_TRASFERIBILE ,
        VAL_ENTE_PAGATORE          =L_VAL_ENTE_PAGATORE ,
        VAL_FAX                    =L_VAL_FAX ,
        VAL_IMPORTO_FM             =L_VAL_IMPORTO_FM ,
        VAL_IMPORTO_VALORE         =L_VAL_IMPORTO_VALORE ,
        VAL_INTESTATARIO_CODFISC   =L_VAL_INTESTATARIO_CODFISC ,
        VAL_INTESTATARIO_CONTO     =L_VAL_INTESTATARIO_CONTO ,
        VAL_INTESTATARIO_PIVA      =L_VAL_INTESTATARIO_PIVA ,
        VAL_NOTE                   =L_VAL_NOTE ,
        VAL_NOTE_FM                =L_VAL_NOTE_FM ,
        VAL_NOTE2                  =L_VAL_NOTE2 ,
        VAL_NUMERO_FATTURA         =L_VAL_NUMERO_FATTURA ,
        VAL_NUM_PROFORMA           =L_VAL_NUM_PROFORMA ,
        VAL_PROF_CAP               =L_VAL_PROF_CAP ,
        VAL_PROF_COMUNE            =L_VAL_PROF_COMUNE ,
        VAL_PROF_FAX               =L_VAL_PROF_FAX ,
        VAL_PROF_INDIRIZZO         =L_VAL_PROF_INDIRIZZO ,
        VAL_PROF_NCIVICO           =L_VAL_PROF_NCIVICO,
        VAL_PROF_PROVINCIA         = L_VAL_PROF_PROVINCIA,
        COD_ID_LEGALE = L_COD_ID_LEGALE,
        Val_Riferimento_Nominativo = L_Val_Riferimento_Nominativo,
        REGIME_IVA  = L_REGIME_IVA ,
        ALIQUOTA_CPA = L_ALIQUOTA_CPA   ,
        IMPORTO_CPA  = L_IMPORTO_CPA  ,
        IMPORTO_IVA  = L_IMPORTO_IVA ,
        IMPORTO_RITENUTA = L_IMPORTO_RITENUTA         ,
        FLG_RITENUTA_APPLICABILE = L_FLG_RITENUTA_APPLICABILE  ,
        FLG_FATTURA_DIGITALE = L_FLG_FATTURA_DIGITALE  ,
        IMPORTO_VOCE = L_IMPORTO_VOCE,
        VAL_ALIQUOTA_RITENUTA = L_VAL_ALIQUOTA_RITENUTA,
        VAL_PERC_RITENUTA = L_VAL_PERC_RITENUTA,
        val_wbs = l_val_wbs,
        val_rappresentante = L_VAL_RAPPRESENTANTE
      WHERE Cod_Autorizzazione     = L_Cod_Autorizzazione;
      L_Ritorno                   := 'OK';
      Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.fnc_mcres_ins_upd_spese',pkg_mcres_audit.c_debug,SQLCODE,Sqlerrm,'aggiornamento spesa riuscito COD_AUTORIZZAZ = ' || L_COD_AUTORIZZAZIONE,Utente);
    EXCEPTION
    WHEN OTHERS THEN
    Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.fnc_mcres_ins_upd_spese',pkg_mcres_audit.c_error,SQLCODE,Sqlerrm,'aggiornamento spesa fallito COD_AUTORIZZAZ = ' || L_COD_AUTORIZZAZIONE,Utente);
    L_Ritorno:='KO';
    END;

  ELSE

  BEGIN
  --
      --Inserimento nuova spesa
      --
      --Determino nuova chiave
      /*****************
      ** VG :: Nuova generazione codice
      ******************/
      --SELECT LPAD(inserimento_spese.nextval,20,0)
      --INTO L_cod_autorizzazione
      --FROM DUAL;
      IF (L_COD_autorizzazione IS NULL) THEN

      --AP 13112013 commentato perchè ho aggiunto chiamata funzione generazione cod_Autorizzazione
        /*SELECT cod_societa||9||to_char(sysdate,'YYYY')||lpad(SEQ_MCRES_SPESE.nextval,7,'0')
        INTO L_cod_autorizzazione
         FROM t_mcres_cl_sap
         where cod_abi = L_COD_ABI;*/

         L_cod_autorizzazione := fnc_genera_cod_autorizzazione(l_cod_abi, utente);

      END IF;

      INSERT
      INTO mcre_own.t_mcres_app_sp_spese
        (
          COD_ABI ,
          COD_AFAVORE_TIPO ,
          COD_AUTORIZZAZIONE ,
          COD_AUTORIZZAZIONE_PADRE ,
          COD_CAUSA_DIVISA ,
          COD_CAUSALE ,
          COD_CAUSALE_888 ,
          COD_IBAN ,
          COD_IMPORTO_DIVISA ,
          COD_INTESTATARIO_ABI ,
          COD_INTESTATARIO_CAB ,
          COD_INTESTATARIO_TIPO ,
          COD_MATRICOLA ,
          COD_MATRICOLA_AGG_STATO_Z ,
          COD_NDG ,
          COD_ORGANO_AUTORIZZANTE ,
          COD_PRATICA ,
          COD_PRATICA_CEDUTA ,
          COD_PROTOCOLLO ,
          COD_PUNTO_OPERATIVO ,
          COD_STATO ,
          COD_TIPO_AUTORIZZAZIONE ,
          COD_TIPO_PAGAMENTO ,
          COD_UO ,
          COD_UO_PRATICA ,
          DESC_AFAVORE ,
          DESC_INTESTATARIO ,
          DESC_SPESA ,
          DTA_AUTORIZZAZIONE ,
          DTA_BON_VALUTA ,
          DTA_FATTURA ,
          DTA_GENERAZIONE_PROTOCOLLO ,
          DTA_INS_SPESA ,
          DTA_PROFORMA_A_FATTURA ,
          DTA_STORNO_CONTABILE ,
          DTA_UPD ,
          DTA_UPD_SPESA ,
          FLG_ANN_AUTORIZ ,
          FLG_CARICO_CESSIONARIO ,
          FLG_CONVENZIONE ,
          FLG_FM ,
          FLG_SPESA_RECUPERATA ,
          FLG_SPESA_RIPETIBILE ,
          VAL_AFAVORE_CODFISC ,
          VAL_AFAVORE_PIVA ,
          VAL_ANNO_PRATICA ,
          VAL_BON_COORDINATE ,
          VAL_BON_DESTINATARIO ,
          VAL_CAUSA_IMPORTO ,
          VAL_CIRC_INTESTATARIO ,
          VAL_CIRC_TRASFERIBILE ,
          VAL_ENTE_PAGATORE ,
          VAL_FAX ,
          VAL_IMPORTO_FM ,
          VAL_IMPORTO_VALORE ,
          VAL_INTESTATARIO_CODFISC ,
          VAL_INTESTATARIO_CONTO ,
          VAL_INTESTATARIO_PIVA ,
          VAL_NOTE ,
          VAL_NOTE_FM ,
          VAL_NOTE2 ,
          VAL_NUMERO_FATTURA ,
          VAL_NUM_PROFORMA ,
          VAL_PROF_CAP ,
          VAL_PROF_COMUNE ,
          VAL_PROF_FAX ,
          VAL_PROF_INDIRIZZO ,
          VAL_PROF_NCIVICO,
          VAL_PROF_PROVINCIA,
          COD_ID_LEGALE,
          Val_Riferimento_Nominativo,
          FLG_SOURCE,
        REGIME_IVA,
        ALIQUOTA_CPA,
        IMPORTO_CPA ,
        IMPORTO_IVA ,
        IMPORTO_RITENUTA,
        FLG_RITENUTA_APPLICABILE,
        FLG_FATTURA_DIGITALE ,
        IMPORTO_VOCE,
        VAL_ALIQUOTA_RITENUTA,
        VAL_PERC_RITENUTA,
        val_wbs,
        val_rappresentante
        )
        VALUES
        (
          L_COD_ABI ,
          L_COD_AFAVORE_TIPO ,
          L_COD_AUTORIZZAZIONE ,
          L_COD_AUTORIZZAZIONE_PADRE ,
          L_COD_CAUSA_DIVISA ,
          L_COD_CAUSALE ,
          L_COD_CAUSALE_888 ,
          L_COD_IBAN ,
          L_COD_IMPORTO_DIVISA ,
          L_COD_INTESTATARIO_ABI ,
          L_COD_INTESTATARIO_CAB ,
          L_COD_INTESTATARIO_TIPO ,
          L_COD_MATRICOLA ,
          L_COD_MATRICOLA_AGG_STATO_Z ,
          L_COD_NDG ,
          L_COD_ORGANO_AUTORIZZANTE ,
          L_COD_PRATICA ,
          L_COD_PRATICA_CEDUTA ,
          L_COD_PROTOCOLLO ,
          L_COD_PUNTO_OPERATIVO ,
          L_COD_STATO ,
          L_COD_TIPO_AUTORIZZAZIONE ,
          L_COD_TIPO_PAGAMENTO ,
          L_COD_UO ,
          L_COD_UO_PRATICA ,
          L_DESC_AFAVORE ,
          L_DESC_INTESTATARIO ,
          L_DESC_SPESA ,
          L_DTA_AUTORIZZAZIONE ,
          L_DTA_BON_VALUTA ,
          L_DTA_FATTURA ,
          L_DTA_GENERAZIONE_PROTOCOLLO ,
          L_DTA_INS_SPESA ,
          L_DTA_PROFORMA_A_FATTURA ,
          L_DTA_STORNO_CONTABILE ,
          L_DTA_UPD ,
          L_DTA_UPD_SPESA ,
          L_FLG_ANN_AUTORIZ ,
          L_FLG_CARICO_CESSIONARIO ,
          L_FLG_CONVENZIONE ,
          L_FLG_FM ,
          L_FLG_SPESA_RECUPERATA ,
          L_FLG_SPESA_RIPETIBILE ,
          L_VAL_AFAVORE_CODFISC ,
          L_VAL_AFAVORE_PIVA ,
          L_VAL_ANNO_PRATICA ,
          L_VAL_BON_COORDINATE ,
          L_VAL_BON_DESTINATARIO ,
          L_VAL_CAUSA_IMPORTO ,
          L_VAL_CIRC_INTESTATARIO ,
          L_VAL_CIRC_TRASFERIBILE ,
          L_VAL_ENTE_PAGATORE ,
          L_VAL_FAX ,
          L_VAL_IMPORTO_FM ,
          L_VAL_IMPORTO_VALORE ,
          L_VAL_INTESTATARIO_CODFISC ,
          L_VAL_INTESTATARIO_CONTO ,
          L_VAL_INTESTATARIO_PIVA ,
          L_VAL_NOTE ,
          L_VAL_NOTE_FM ,
          L_VAL_NOTE2 ,
          L_VAL_NUMERO_FATTURA ,
          L_VAL_NUM_PROFORMA ,
          L_VAL_PROF_CAP ,
          L_VAL_PROF_COMUNE ,
          L_VAL_PROF_FAX ,
          L_VAL_PROF_INDIRIZZO ,
          L_VAL_PROF_NCIVICO,
          L_VAL_PROF_PROVINCIA,
          L_COD_ID_LEGALE,
          L_Val_Riferimento_Nominativo,
          'SOF',
          L_REGIME_IVA,
          L_ALIQUOTA_CPA,
          L_IMPORTO_CPA ,
          L_IMPORTO_IVA ,
          L_IMPORTO_RITENUTA,
          L_FLG_RITENUTA_APPLICABILE,
          L_FLG_FATTURA_DIGITALE,
          L_IMPORTO_VOCE,
          L_VAL_ALIQUOTA_RITENUTA,
          L_VAL_PERC_RITENUTA,
          l_val_wbs,
          l_val_rappresentante
        );


      L_Ritorno:='OK';
      Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.fnc_mcres_ins_upd_spese',pkg_mcres_audit.c_debug,SQLCODE,Sqlerrm,'inserimento spesa riuscito COD_AUTORIZZAZ = ' || L_COD_AUTORIZZAZIONE,Utente);
        EXCEPTION
        WHEN OTHERS THEN
        Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.fnc_mcres_ins_upd_spese',pkg_mcres_audit.c_error,SQLCODE,Sqlerrm,'inserimento spesa non riuscito COD_AUTORIZZAZ = ' || L_COD_AUTORIZZAZIONE,Utente);
        return 'KO';
        END;

  END IF;


    --15/11/2012 AP - POPOLO TABELLA FATTURE
    IF L_COD_TIPO_AUTORIZZAZIONE IN ('1','5','6') AND L_COD_AUTORIZZAZIONE_PADRE IS NULL THEN

    BEGIN

    DELETE FROM T_Mcres_App_Sp_fatture
    WHERE cod_autorizzazione = L_COD_AUTORIZZAZIONE;

    INSERT INTO T_MCRES_APP_SP_FATTURE (COD_AUTORIZZAZIONE, COD_TIPO_AUTORIZZAZIONE, VAL_IMPORTO_VOCE, COD_SAP_IVA, PROG_FATTURA, DTA_INS)
    SELECT A.COD_AUTORIZZAZIONE,
           A.COD_TIPO_AUTORIZZAZIONE,
           TO_NUMBER(REGEXP_SUBSTR (L_IMPORTO_VOCE,'[^;]+', 1, LEVEL),  '9999999999999D99999', 'NLS_NUMERIC_CHARACTERS = ''.,''') AS VAL_IMPORTO_VOCE,
           REGEXP_SUBSTR (L_REGIME_IVA,'[^;]+', 1, LEVEL) AS COD_SAP_IVA,
           ROWNUM PROG_FATTURA,
           SYSDATE DTA_INS
      FROM
           (SELECT * FROM T_MCRES_APP_SP_SPESE
           WHERE COD_AUTORIZZAZIONE = L_COD_AUTORIZZAZIONE) A
           CONNECT BY REGEXP_SUBSTR (L_IMPORTO_VOCE,'[^;]+', 1, LEVEL) IS NOT NULL
           AND REGEXP_SUBSTR (L_REGIME_IVA,'[^;]+', 1, LEVEL) IS NOT NULL;


    ---AP 2013/02/11
MERGE INTO t_mcres_app_sp_fatture t
   USING (SELECT cod_autorizzazione, prog_fattura,
                 val_importo_voce val_imponibile_iva,
                 cl.val_perc_iva val_aliquota_iva,
                 ROUND (val_importo_voce * val_perc_iva / 100,
                        2
                       ) val_importo_iva,
                   val_importo_voce
                 + ROUND (val_importo_voce * val_perc_iva / 100, 2)
                                                              val_importo_pos
            FROM t_mcres_app_sp_fatture f, t_mcres_cl_codiva cl
           WHERE 0 = 0 AND f.cod_sap_iva = cl.cod_iva AND cl.flg_attivo = 1
             AND f.cod_autorizzazione = L_COD_AUTORIZZAZIONE) s
   ON (    t.cod_autorizzazione = s.cod_autorizzazione
       AND t.prog_fattura = s.prog_fattura)
   WHEN MATCHED THEN
      UPDATE
         SET t.val_imponibile_iva = s.val_imponibile_iva,
             t.val_aliquota_iva = s.val_aliquota_iva,
             t.val_importo_iva = s.val_importo_iva,
             t.val_importo_pos = s.val_importo_pos
       WHERE t.cod_autorizzazione = L_COD_AUTORIZZAZIONE;

    L_Ritorno                   := 'OK';
    Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.fnc_mcres_ins_upd_spese',pkg_mcres_audit.c_debug,SQLCODE,Sqlerrm,'inserimento fattura riuscito COD_AUTORIZZAZ = ' || L_COD_AUTORIZZAZIONE,Utente);
    EXCEPTION
    WHEN OTHERS THEN
    Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.fnc_mcres_ins_upd_spese',pkg_mcres_audit.c_error,SQLCODE,Sqlerrm,'inserimento fattura fallito COD_AUTORIZZAZ = ' || L_COD_AUTORIZZAZIONE,Utente);
    return 'KO';
    END;
    END IF;


  RETURN 'OK';
end FNC_MCRES_INS_UPD_SPESE;




-- funzione aggiornamento stato delibere
function fnc_mcres_update_stato_deliber(
    p_cod_abi                 t_mcres_app_delibere.cod_abi%type,
    p_cod_ndg                 t_mcres_app_delibere.cod_ndg%type,
    p_cod_protocollo_delibera t_mcres_app_delibere.cod_protocollo_delibera%type,
    p_cod_stato_delibera      t_mcres_app_delibere.cod_stato_delibera%type,
    p_utente                  t_mcres_app_pratiche.cod_matr_pratica%type,
    p_note_annullamento       t_mcres_app_delibere.val_note_annullamento%type default null,
    p_cod_uo                  t_mcres_app_delibere.cod_uo%type default null,
    p_dta_retrocessione   t_mcres_app_delibere.dta_retrocessione%type default null
    )
return varchar2
is

  c_nome constant       varchar2(100) := c_package || '.FNC_MCRES_UPDATE_STATO_DELIBER';
  v_note                t_mcre0_wrk_audit_applicativo.note%type := 'GENERALE';
  v_cod_stato_delibera  t_mcres_app_delibere.cod_stato_delibera%type;
  v_dta_delibera     t_mcres_app_delibere.dta_delibera%type;
  v_cod_delibera     t_mcres_app_delibere.cod_delibera%type;
  v_cod_protocollo_delibera_va t_mcres_app_delibere.cod_protocollo_delibera%type;

begin

    v_note := 'controllo se parametri input sono validi';
    if
        p_cod_abi is null or
        p_cod_ndg is null or
        p_cod_protocollo_delibera is null
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: campo chiave nullo' ,p_utente);
        return ko;
    end if;


    v_note := 'Controllo esistenza delibera';
    begin

        select cod_stato_delibera, dta_delibera, cod_delibera
        into v_cod_stato_delibera, v_dta_delibera, v_cod_delibera
        from t_mcres_app_delibere
        where cod_abi = p_cod_abi
        and cod_ndg = p_cod_ndg
        and cod_protocollo_delibera = p_cod_protocollo_delibera;
/*
    AG 20120803
        if v_cod_stato_delibera = 'CO'
        then
            pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Impossibile variare lo stato. Delibera giÃ¿Â  confermata' ,p_utente);
            return ko;
        end if;
*/
    exception
    when no_data_found
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Delibera non presente sul DB' ,p_utente);
        return ko;
    end;


    v_note := 'Aggiornamento delibera '||p_cod_protocollo_delibera||', ABI = '||p_cod_abi||', NDG = '||p_cod_ndg || ' con stato (' || p_cod_stato_delibera || ')';
    update t_mcres_app_delibere
    set
        val_note_annullamento  = case
                                                    when cod_stato_delibera ='AN' and p_cod_stato_delibera = 'IN' then null
                                                    else nvl(p_note_annullamento, val_note_annullamento)
                                               end ,
        VAL_RETT_VAL_IN_DEL   = case
                                                    when cod_stato_delibera ='AN' and p_cod_stato_delibera = 'IN' then null
                                                    else VAL_RETT_VAL_IN_DEL
                                               end ,
        cod_stato_delibera          = p_cod_stato_delibera,
        dta_aggiornamento_delibera  = trunc(sysdate),
        dta_upd = sysdate,
        cod_operatore_ins_upd = p_utente,
        dta_conferma = decode(p_cod_stato_delibera,'CO',trunc(sysdate),null),
        --AP 04/02/2013
        dta_annullamento_delibera = decode(p_cod_Stato_delibera, 'AN', SYSDATE, dta_annullamento_delibera),
        --AG 21/02/2013
        cod_uo = nvl(p_cod_uo, cod_uo),
        COD_ORGANO_DELIBERANTE = decode(p_cod_Stato_delibera, 'AN', null, COD_ORGANO_DELIBERANTE),
        dta_retrocessione = p_dta_retrocessione,
        FLG_PRESA_VISIONE = decode(p_dta_retrocessione,null,FLG_PRESA_VISIONE,'N'),
        FLG_PVISIONE_ENTE_CENTR = decode(p_dta_retrocessione,null,FLG_PVISIONE_ENTE_CENTR,'N'),
        FLG_PVISIONE_GESTORE = decode(p_dta_retrocessione,null,FLG_PVISIONE_GESTORE,'N'),
        FLG_PVISIONE_PRESIDIO = decode(p_dta_retrocessione,null,FLG_PVISIONE_GESTORE,'N'),
        flg_step5_active = decode(p_dta_retrocessione,null,flg_step5_active,1)
    where 0=0
        and cod_abi = p_cod_abi
        and cod_ndg = p_cod_ndg
        and cod_protocollo_delibera = p_cod_protocollo_delibera;

    if(p_dta_retrocessione is not null ) then

        v_note := 'Retrocessione cancellazione documenti';
        delete from T_MCRES_APP_DOCUMENTI
        where cod_Aut_protoc = p_cod_protocollo_delibera
        and cod_stato = 'CO';

        if(v_cod_delibera in ('TT','TP') and v_cod_stato_delibera ='PR')then
            v_note := 'Retrocessione cancellazione proroghe';
            delete from T_MCRES_APP_PROROGHE
            where cod_protocollo = p_cod_protocollo_delibera;
        end if;

        if(v_cod_delibera in ('TT','TP','TS') and v_cod_stato_delibera ='AD')then
            v_note := 'Retrocessione cancellazione rapporti delibere';
            delete from T_MCRES_APP_RAPPORTI_DELIBERE
            where cod_protocollo = p_cod_protocollo_delibera;
        end if;

    end if;

    if(v_cod_stato_delibera='AN' and p_cod_stato_delibera='IN') then
         v_note := 'Riabilitazione pareri';

        update t_mcrei_app_pareri
        set
            flg_annullato = 0,
            dta_upd = sysdate,
            cod_operatore_ins_upd = p_utente
        where 0=0
            and cod_abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_protocollo_delibera = p_cod_protocollo_delibera;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Riabilitati pareri delibera ABI-NDG-COD_PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera, p_utente);

         v_note := 'Cancello piani di rientro annullati';

        delete t_mcrei_app_piani_rientro
        where flg_annullato = 1
            and cod_abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_protocollo_delibera = p_cod_protocollo_delibera;

         pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Cancellati piani di rientro annullati. Delibera ABI-NDG-COD_PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera, p_utente);

        v_note := 'Cancello stime di recupero annullate';

        delete t_mcrei_app_stime
        where flg_annullata = 1
            and cod_abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_protocollo_delibera = p_cod_protocollo_delibera;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Cancellate stime di recupero annullate. Delibera ABI-NDG-COD_PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera, p_utente);

    end if;

    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Aggiornato stato delibera ABI-NDG-COD_PROTOCOLLO_DELIBERA-STATO = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera || ' - ' || p_cod_stato_delibera, p_utente);


    v_note := 'Aggiornamento data inoltro / trasferimento';
    if p_cod_stato_delibera = 'IT'
    then

            update t_mcres_app_delibere
            set dta_inoltro = trunc(sysdate)
            where cod_Abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_protocollo_delibera = p_cod_protocollo_delibera;

             pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Aggiornata data inoltro delibera ABI-NDG-COD_PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera, p_utente);

    end if;

    if p_cod_stato_delibera  IN ( 'TR', 'TX')
    then

            update t_mcres_app_delibere
            set dta_trasferimento = trunc(sysdate)
            where cod_Abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_protocollo_delibera = p_cod_protocollo_delibera;

             pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
            'Aggiornata data trasferimento delibera ABI-NDG-COD_PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera, p_utente);

    end if;

    v_note := 'Azzeramento dati per delibere annullate';
    if p_cod_stato_delibera = 'AN'
    then

        v_note := 'Annullamento piani di rientro';

        update t_mcrei_app_piani_rientro
        set
            flg_annullato = 1,
            dta_upd = sysdate,
            cod_operatore_ins_upd = p_utente
        where 0=0
            and cod_abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_protocollo_delibera = p_cod_protocollo_delibera;

         pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Annullati piani di rientro delibera ABI-NDG-COD_PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera, p_utente);



        v_note := 'Annullamento stime di recupero';

        update t_mcrei_app_stime
        set
            flg_annullata = 1,
            dta_upd = sysdate,
            cod_operatore_ins_upd = p_utente
        where 0=0
            and cod_abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_protocollo_delibera = p_cod_protocollo_delibera;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Annullate stime di recupero delibera ABI-NDG-COD_PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera, p_utente);


        v_note := 'Annullamento pareri';

        update t_mcrei_app_pareri
        set
            flg_annullato = 1,
            dta_upd = sysdate,
            cod_operatore_ins_upd = p_utente
        where 0=0
            and cod_abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_protocollo_delibera = p_cod_protocollo_delibera;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Annullati pareri delibera ABI-NDG-COD_PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera, p_utente);


    end if;

    if p_cod_stato_delibera  = 'CO' then

        update t_mcrei_app_stime
        set
            dta_stima = trunc(sysdate),
            dta_upd = sysdate,
            cod_operatore_ins_upd = p_utente,
            flg_tipo_rapporto = case when v_cod_delibera in ('NS','RV','AS') and flg_tipo_rapporto='P' then 'D' else flg_tipo_rapporto end
        where 0=0
            and cod_abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_protocollo_delibera = p_cod_protocollo_delibera;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Aggiornata data stima x conferma - delibera ABI-NDG-COD_PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera, p_utente);

        update t_mcrei_app_piani_rientro
        set
            dta_stima = trunc(sysdate),
            dta_upd = sysdate,
            cod_operatore_ins_upd = p_utente
        where 0=0
            and cod_abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_protocollo_delibera = p_cod_protocollo_delibera;

       pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Aggiornata data stima piani x conferma - delibera ABI-NDG-COD_PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera, p_utente);

        if v_cod_delibera in ('RW','NS','RV','AS') then

            begin
                select cod_protocollo_delibera
                into v_cod_protocollo_delibera_va
                from t_mcres_app_delibere
                where cod_abi = p_cod_abi
                    and cod_ndg = p_cod_ndg
                    and cod_delibera = 'VA';
             exception
                when others then
                    v_cod_protocollo_delibera_va:= null;
             end;

            if (v_cod_protocollo_delibera_va is not null)then

                pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
                            'Aggiornata data stima valutazione - delibera ABI-NDG-COD_PROTOCOLLO_DELIBERA = ' || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || v_cod_protocollo_delibera_va, p_utente);

                update t_mcrei_app_stime
                set
                    dta_upd = sysdate,
                    cod_operatore_ins_upd = p_utente,
                    FLG_ANNULLATA =  1
                where 0=0
                    and cod_abi = p_cod_abi
                    and cod_ndg = p_cod_ndg
                    and cod_protocollo_delibera = v_cod_protocollo_delibera_va;

                update t_mcres_app_delibere
                set cod_stato_delibera = 'AN',
                    DTA_ANNULLAMENTO_DELIBERA = sysdate,
                    dta_upd = sysdate,
                    cod_operatore_ins_upd = p_utente
                where cod_Abi = p_cod_abi
                and cod_ndg = p_cod_ndg
                and cod_protocollo_delibera = v_cod_protocollo_delibera_va;
             end if;

        end if;

    end if;

------------ VG 16/05/2013 step5
--    if p_cod_stato_delibera  in ('TR' , 'CO') then
--
--        v_note := 'Aggiornamento Note Stime';
--        update t_mcrei_app_stime
--        set desc_causa_prev_recupero = (
--                    'DELIBERA '||substr(p_cod_protocollo_delibera,length(p_cod_protocollo_delibera)-4,5)||'/'
--                    ||substr(p_cod_protocollo_delibera,length(p_cod_protocollo_delibera)-8,4)||'/'||
--                    substr(p_cod_protocollo_delibera,1,length(p_cod_protocollo_delibera)-9)||' del '||to_char(v_dta_delibera,'DD.MM.YYYY')
--        where cod_abi = p_cod_abi
--        and cod_ndg = p_cod_ndg
--        and cod_protocollo_delibera = p_cod_protocollo_delibera
--        and desc_causa_prev_recupero is null;
--
--    end if;

  return 'OK';

exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_utente);
    return 'KO';
end fnc_mcres_update_stato_deliber;

function FNC_MCRES_COD_PROTOCOLLO_NULLA(
    P_COD_AUTORIZZAZIONE T_MCRES_APP_CODICI_PROTOCOLLO.COD_AUTORIZZAZIONE%type,
    P_COD_CONTROPARTITA  T_MCRES_APP_CODICI_PROTOCOLLO.COD_CONTROPARTITA%type,
    P_DTA_INS        in OUT T_MCRES_APP_CODICI_PROTOCOLLO.DTA_INS%type,
    P_COD_PROTOCOLLO in OUT T_MCRES_APP_CODICI_PROTOCOLLO.COD_PROTOCOLLO%type,
    P_COD_MATR_PRATICA T_MCRES_APP_PRATICHE.COD_MATR_PRATICA%type)
  RETURN VARCHAR2
is
  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_COD_PROTOCOLLO_NULLA';
  V_NOTE varchar2(1000)           :='GENERALE';
  V_COD_PROTOCOLLO  T_MCRES_APP_CODICI_PROTOCOLLO.COD_PROTOCOLLO%type;
  v_DTA_INS         T_MCRES_APP_CODICI_PROTOCOLLO.DTA_INS%type;
begin

  V_NOTE := ' Select Protocollo - AUT='||P_COD_AUTORIZZAZIONE||' - CPART='||p_cod_contropartita;
  begin
    SELECT Cod_Protocollo, Dta_Ins
    into v_COD_PROTOCOLLO,v_dta_ins
    FROM T_MCRES_APP_CODICI_PROTOCOLLO
    WHERE COD_AUTORIZZAZIONE = P_COD_AUTORIZZAZIONE;
    --AND nvl(cod_contropartita,-1)   = nvl(p_cod_contropartita,nvl(cod_contropartita,-1));
  EXCEPTION
    when NO_DATA_FOUND then
     V_COD_PROTOCOLLO := null;
     v_dta_ins := null;
    when OTHERS then
      PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_COD_MATR_PRATICA);
      RETURN 'KO';
  end;

  if(V_COD_PROTOCOLLO is null) then

    V_NOTE := ' Select MAX - AUT='||P_COD_AUTORIZZAZIONE||' - CPART='||P_COD_CONTROPARTITA;
    select max(to_number(COD_PROTOCOLLO))+1,sysdate
    INTO v_COD_PROTOCOLLO,v_dta_ins
    from T_MCRES_APP_CODICI_PROTOCOLLO;

    V_NOTE := ' Insert new Protocollo - AUT='||P_COD_AUTORIZZAZIONE||' - CPART='||p_cod_contropartita;
    INSERT INTO T_Mcres_App_Codici_Protocollo
      (
        Cod_Autorizzazione,
        Cod_Contropartita,
        Cod_Protocollo,
        Dta_Ins
      )
      VALUES
      (
        p_Cod_Autorizzazione,
        P_COD_CONTROPARTITA,
        NVL(V_COD_PROTOCOLLO,1),
        nvl(v_Dta_Ins,sysdate)
      );
  end if;

  p_Cod_Protocollo:=NVL(V_COD_PROTOCOLLO,1);
  P_DTA_INS:=nvl(v_Dta_Ins,sysdate);
  return 'OK';

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_COD_MATR_PRATICA);
    return 'KO';
end FNC_MCRES_COD_PROTOCOLLO_NULLA;

FUNCTION FNC_AGGIORNA_MOVIMENTO_KEY
      (
        L_Cod_Contropartita VARCHAR2,
        L_Cod_Operazione_Fatt VARCHAR2,
        L_Dta_Solare_Operazione VARCHAR2,
        L_Cod_Progr_Operazione NUMBER,
        L_Val_Nuova_Operazione VARCHAR2,
        Utente VARCHAR2
      )
      RETURN VARCHAR2
    IS
      l_esito VARCHAR2(2);
    BEGIN
      BEGIN

        UPDATE
        T_Mcres_App_Sp_contropartita
        SET
        COD_OPERAZIONE_FATT = L_Cod_Operazione_Fatt,
        DTA_SOLARE_OPERAZIONE = to_date(L_Dta_Solare_Operazione, 'yyyymmdd'),
        COD_PROGR_OPERAZIONE = L_Cod_Progr_Operazione,
        VAL_NUOVA_OPERAZIONE = L_Val_Nuova_Operazione
        WHERE
        COD_CONTROPARTITA = L_Cod_Contropartita;

        Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.FNC_AGGIORNA_MOVIMENTO_KEY',PKG_MCRES_AUDIT.c_debug,SQLCODE,Sqlerrm,'aggiornamento chiave movimento spesa riuscito',Utente);
        L_Esito:='OK';

      EXCEPTION
      WHEN OTHERS THEN
        L_Esito:='KO';
        Pkg_Mcres_Audit.Log_App('PKG_MCRES_FUNZIONI_PORTALE.FNC_AGGIORNA_MOVIMENTO_KEY',PKG_MCRES_AUDIT.c_error,SQLCODE,Sqlerrm,'aggiornamento chiave movimento spesa non riuscito',Utente);
      END;
      Return L_Esito;
end FNC_AGGIORNA_MOVIMENTO_KEY;



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
return number
is

  c_nome constant       varchar2(100) := c_package || '.FNC_MCRES_POPOLA_STIME';
  v_note                t_mcres_wrk_audit_applicativo.note%type;
  v_exists              number(1);
  --v_cod_stato_delibera  t_mcres_app_delibere.cod_stato_delibera%type;
  v_flg_delibera_RW number:= 0;
  v_dta_delibera t_mcres_app_delibere.dta_delibera%type;

begin

    v_note := 'controllo validitaÂ  parametri input';
    if
        p_cod_abi is null or
        p_cod_ndg is null or
        p_cod_rapporto is null or
        p_flg_tipo_dato is null or
        p_cod_protocollo_delibera is null
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: campo chiave nullo. COD_ABI = '|| p_cod_abi ||
                                ' COD_NDG = ' || p_cod_ndg || ' COD_RAPPORTO = ' || p_cod_rapporto || ' FLG_TIPO_DATO = ' || p_flg_tipo_dato
                                || ' COD_PROTOCOLLO_DELIBERA = ' || p_cod_protocollo_delibera , p_cod_utente);
        return ko;
    end if;

    v_note := 'Controllo delibera RW in stato CO';
    begin
      select decode(cod_delibera,'RW',decode(cod_stato_delibera,'CO',1,0),0), dta_delibera
      into v_flg_delibera_RW, v_dta_delibera
      from t_mcres_app_delibere
      where cod_protocollo_delibera = p_cod_protocollo_delibera
      and cod_abi = p_cod_abi
      and cod_ndg = p_cod_ndg;
    exception
        when others then
            v_flg_delibera_RW := 0;
            pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note || ' COD_ABI = '|| p_cod_abi ||
                                ' COD_NDG = ' || p_cod_ndg || ' COD_PROTOCOLLO_DELIBERA = ' || p_cod_protocollo_delibera , p_cod_utente);
    end;

    v_note := 'Controllo esistenza stima';

    select count(*)
    into v_exists
    from t_mcrei_app_stime
    where cod_abi = p_cod_abi
    and cod_ndg = p_cod_ndg
    and cod_rapporto = p_cod_rapporto
    and cod_protocollo_delibera = p_cod_protocollo_delibera
    and flg_tipo_dato = p_flg_tipo_dato;

    if v_exists > 0
    then
        ------------ VG 16/05/2013 step5
        update t_mcrei_app_stime
        set
            cod_sndg                        = NVL (p_cod_sndg, cod_sndg),
            dta_stima                       = NVL (p_dta_stima, dta_stima),
            desc_causa_prev_recupero   = nvl(p_desc_causa_prev_recupero,desc_causa_prev_recupero),
--                                    case
--                                        when p_desc_causa_prev_recupero is not null then p_desc_causa_prev_recupero
--                                        when desc_causa_prev_recupero is not null and instr(desc_causa_prev_recupero,'DELIBERA')=1 then
--                                                      substr(desc_causa_prev_recupero,1,29)||to_char(v_dta_delibera,'DD.MM.YYYY')
--                                        when desc_causa_prev_recupero is not null and instr(desc_causa_prev_recupero,'DELIBERA')!=1 then desc_causa_prev_recupero
--                                        else
--                                             case when v_flg_delibera_rw = 1 then
--                                                                'DELIBERA '||substr(p_cod_protocollo_delibera,length(p_cod_protocollo_delibera)-4,5)||'/'
--                                                                ||substr(p_cod_protocollo_delibera,length(p_cod_protocollo_delibera)-8,4)||'/'
--                                                                ||substr(p_cod_protocollo_delibera,1,length(p_cod_protocollo_delibera)-9)||' del '
--                                                                ||to_char(v_dta_delibera,'DD.MM.YYYY')
--                                                else null
--                                             end
--                                   end,
--                    NVL (p_desc_causa_prev_recupero,
--                                nvl(desc_causa_prev_recupero,
--                                        case when v_flg_delibera_rw = 1 then
--                                                                'DELIBERA '||substr(p_cod_protocollo_delibera,length(p_cod_protocollo_delibera)-4,5)||'/'
--                                                                ||substr(p_cod_protocollo_delibera,length(p_cod_protocollo_delibera)-8,4)||'/'
--                                                                ||substr(p_cod_protocollo_delibera,1,length(p_cod_protocollo_delibera)-9)||'-'
--                                                                ||to_char(sysdate,'DD.MM.YYYY')
--                                                else null
--                                        end )),
            flg_recupero_tot                = NVL (p_flg_recupero_tot, flg_recupero_tot),
            cod_uo_stima                    = NVL (p_cod_uo_stima, cod_uo_stima),
            val_imp_prev_pregr              = NVL (p_val_imp_prev_pregr, val_imp_prev_pregr),
            val_imp_prev_att                = NVL (p_val_imp_prev_att, val_imp_prev_att),
            val_prev_recupero               = NVL (p_val_prev_recupero, val_prev_recupero),
            val_esposizione                 = NVL (p_val_esposizione, val_esposizione),
            val_rdv_tot                     = NVL (p_val_rdv_tot, val_rdv_tot),
            val_imp_rettifica_pregr         = NVL (p_val_imp_rettifica_pregr, val_imp_rettifica_pregr),
            val_imp_rettifica_att           = NVL (p_val_imp_rettifica_att, val_imp_rettifica_att),
            cod_utente                      = NVL (p_cod_utente, cod_utente),
            val_attualizzato                = NVL (p_val_attualizzato, val_attualizzato),
            flg_pres_piano                  = NVL (p_flg_pres_piano, flg_pres_piano),
            cod_tipo_rapporto               = NVL (p_cod_tipo_rapporto, cod_tipo_rapporto),
            dta_upd                         = sysdate,
            cod_operatore_ins_upd           = p_cod_utente,
            cod_classe_ft                   = NVL (p_cod_classe_ft, cod_classe_ft),
            flg_ristrutturato               = NVL (p_flg_ristrutturato, flg_ristrutturato),
            val_utilizzato_netto            = NVL (p_val_utilizzato_netto, val_utilizzato_netto),
            val_utilizzato_mora             = NVL (p_val_utilizzato_mora, val_utilizzato_mora),
            val_perc_rett_rapporto          = NVL (p_val_perc_rett_rapporto, val_perc_rett_rapporto),
            val_accordato                   = NVL (p_val_accordato, val_accordato),
            cod_microtipologia_delibera     = NVL (p_cod_microtipologia_delibera, cod_microtipologia_delibera),
            cod_npe                         = NVL (p_cod_npe, cod_npe),
            flg_tipo_rapporto               = NVL (p_flg_tipo_rapporto, flg_tipo_rapporto),
            cod_forma_tecnica               = NVL (p_cod_forma_tecnica, cod_forma_tecnica),
            dta_inizio_segnalazione_ristr   = NVL (p_dta_iniz_segnalazione_ristr, dta_inizio_segnalazione_ristr),
            dta_fine_segnalazione_ristr     = NVL (p_dta_fine_segnalazione_ristr, dta_fine_segnalazione_ristr),
            dta_decorrenza_stato            = NVL (p_dta_decorrenza_stato, dta_decorrenza_stato)
        where     0 = 0
              and cod_abi = p_cod_abi
              and cod_ndg = p_cod_ndg
              and cod_rapporto = p_cod_rapporto
              and flg_tipo_dato = p_flg_tipo_dato
              and cod_protocollo_delibera = p_cod_protocollo_delibera;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Aggiornata stima ABI - NDG - COD_PROTOCOLLO_DELIBERA - COD_RAPPORTO - FLG_TIPO_DATO = '
        || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera || ' - ' || p_cod_rapporto || ' - ' || p_flg_tipo_dato, p_cod_utente);


    else

        insert into t_mcrei_app_stime
        (
            id_dper,
            cod_abi,
            cod_sndg,
            cod_ndg,
            cod_rapporto,
            dta_stima,
            desc_causa_prev_recupero,
            flg_recupero_tot,
            cod_uo_stima,
            val_imp_prev_pregr,
            val_imp_prev_att,
            val_prev_recupero,
            val_esposizione,
            val_rdv_tot,
            val_imp_rettifica_pregr,
            val_imp_rettifica_att,
            flg_tipo_dato,
            cod_utente,
            val_attualizzato,
            flg_pres_piano,
            cod_tipo_rapporto,
            cod_protocollo_delibera,
            dta_ins,
            dta_upd,
            cod_operatore_ins_upd,
            cod_classe_ft,
            flg_ristrutturato,
            val_utilizzato_netto,
            val_utilizzato_mora,
            val_perc_rett_rapporto,
            val_accordato,
            cod_microtipologia_delibera,
            cod_npe,
            flg_tipo_rapporto,
            cod_forma_tecnica,
            dta_inizio_segnalazione_ristr,
            dta_fine_segnalazione_ristr,
            dta_decorrenza_stato,
            flg_attiva
        )
        values
        (
            to_char(sysdate, 'yyyymmdd'),
            p_cod_abi,
            p_cod_sndg,
            p_cod_ndg,
            p_cod_rapporto,
            p_dta_stima,
            p_desc_causa_prev_recupero,
--            NVL (p_desc_causa_prev_recupero,
--                    case when v_flg_delibera_rw = 1 then
--                                            'DELIBERA '||substr(p_cod_protocollo_delibera,length(p_cod_protocollo_delibera)-4,5)||'/'
--                                            ||substr(p_cod_protocollo_delibera,length(p_cod_protocollo_delibera)-8,4)||'/'
--                                            ||substr(p_cod_protocollo_delibera,1,length(p_cod_protocollo_delibera)-9)||' del '
--                                            ||to_char(v_dta_delibera,'DD.MM.YYYY')
--                            else null
--                    end ),
            p_flg_recupero_tot,
            p_cod_uo_stima,
            p_val_imp_prev_pregr,
            p_val_imp_prev_att,
            p_val_prev_recupero,
            p_val_esposizione,
            p_val_rdv_tot,
            p_val_imp_rettifica_pregr,
            p_val_imp_rettifica_att,
            p_flg_tipo_dato,
            p_cod_utente,
            p_val_attualizzato,
            p_flg_pres_piano,
            p_cod_tipo_rapporto,
            p_cod_protocollo_delibera,
            sysdate,
            sysdate,
            p_cod_utente,
            p_cod_classe_ft,
            p_flg_ristrutturato,
            p_val_utilizzato_netto,
            p_val_utilizzato_mora,
            p_val_perc_rett_rapporto,
            p_val_accordato,
            p_cod_microtipologia_delibera,
            p_cod_npe,
            p_flg_tipo_rapporto,
            p_cod_forma_tecnica,
            p_dta_iniz_segnalazione_ristr,
            p_dta_fine_segnalazione_ristr,
            p_dta_decorrenza_stato,
            1
        );

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,
        'Inserita stima ABI - NDG - COD_PROTOCOLLO_DELIBERA - COD_RAPPORTO - FLG_TIPO_DATO = '
        || p_cod_abi || ' - ' || p_cod_ndg || ' - ' || p_cod_protocollo_delibera || ' - ' || p_cod_rapporto || ' - ' || p_flg_tipo_dato, p_cod_utente);


    end if;

    return ok;

exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_utente);
    return ko;
end;



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
return number
is

  c_nome constant       varchar2(100) := c_package || '.FNC_MCRES_POPOLA_PIANI';
  v_note                t_mcres_wrk_audit_applicativo.note%type;
  v_exists              number(1);
  --v_cod_stato_delibera  t_mcres_app_delibere.cod_stato_delibera%type;


begin

    v_note := 'Controllo validitÃ¿Â  parametri input';
    if
        p_cod_abi is null or
        p_cod_ndg is null or
        p_cod_rapporto is null or
        p_cod_protocollo_delibera is null or
        p_num_rata is null
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: campo chiave nullo. COD_ABI = '|| p_cod_abi ||
                                ' COD_NDG = ' || p_cod_ndg || ' COD_RAPPORTO = ' || p_cod_rapporto || ' COD_PROTOCOLLO_DELIBERA = ' || p_cod_protocollo_delibera
                                || 'NUM_RATA = ' || p_num_rata, p_cod_utente);
        return ko;
    end if;

    v_note := 'Controllo esistenza piano di rientro';

    select count(*)
    into v_exists
    from t_mcrei_app_piani_rientro
    where cod_abi = p_cod_abi
    and cod_ndg = p_cod_ndg
    and cod_rapporto = p_cod_rapporto
    and cod_protocollo_delibera = p_cod_protocollo_delibera
    and num_rata = p_num_rata;


    if v_exists > 0
    then

        update t_mcrei_app_piani_rientro
        set
            cod_abi                   = NVL (p_cod_abi, cod_abi),
            cod_sndg                  = NVL (p_cod_sndg, cod_sndg),
            cod_ndg                   = NVL (p_cod_ndg, cod_ndg),
            cod_rapporto              = NVL (p_cod_rapporto, cod_rapporto),
            dta_stima                 = NVL (p_dta_stima, dta_stima),
            num_rata                  = NVL (p_num_rata, num_rata),
            dta_scadenza_rata         = NVL (p_dta_scadenza_rata, dta_scadenza_rata),
            val_rata                  = NVL (p_val_rata, val_rata),
            dta_ins_piano             = NVL (p_dta_ins_piano, dta_ins_piano),
            dta_upd_piano             = NVL (p_dta_upd_piano, dta_upd_piano),
            cod_utente                = NVL (p_cod_utente, cod_utente),
            dta_upd                   = sysdate,
            cod_operatore_ins_upd     = p_cod_utente,
            cod_forma_tecnica         = NVL (p_cod_forma_tecnica, cod_forma_tecnica),
            flg_annullato             = NVL (p_flg_annullato, flg_annullato)
        where     0 = 0
            and cod_abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_rapporto = p_cod_rapporto
            and cod_protocollo_delibera = p_cod_protocollo_delibera
            and num_rata = p_num_rata;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,'Aggiornato piano di rientro. COD_ABI = '|| p_cod_abi ||
                                ' COD_NDG = ' || p_cod_ndg || ' COD_RAPPORTO = ' || p_cod_rapporto || ' COD_PROTOCOLLO_DELIBERA = ' || p_cod_protocollo_delibera
                                || 'NUM_RATA = ' || p_num_rata, p_cod_utente);

    else

        insert into t_mcrei_app_piani_rientro
        (
            id_dper,
            cod_abi,
            cod_sndg,
            cod_ndg,
            cod_rapporto,
            dta_stima,
            num_rata,
            dta_scadenza_rata,
            val_rata,
            dta_ins_piano,
            dta_upd_piano,
            cod_utente,
            cod_protocollo_delibera,
            dta_ins,
            dta_upd,
            cod_operatore_ins_upd,
            cod_forma_tecnica,
            flg_annullato,
            flg_attiva
        )
        values
        (
            to_char(sysdate, 'yyyymmdd'),
            p_cod_abi,
            p_cod_sndg,
            p_cod_ndg,
            p_cod_rapporto,
            p_dta_stima,
            p_num_rata,
            p_dta_scadenza_rata,
            p_val_rata,
            p_dta_ins_piano,
            p_dta_upd_piano,
            p_cod_utente,
            p_cod_protocollo_delibera,
            sysdate,
            sysdate,
            p_cod_utente,
            p_cod_forma_tecnica,
            p_flg_annullato,
            '1'
        );

    end if;

    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,'Inserito piano di rientro. COD_ABI = '|| p_cod_abi ||
                                ' COD_NDG = ' || p_cod_ndg || ' COD_RAPPORTO = ' || p_cod_rapporto || ' COD_PROTOCOLLO_DELIBERA = ' || p_cod_protocollo_delibera
                                || 'NUM_RATA = ' || p_num_rata, p_cod_utente);

    return ok;

exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_utente);
    return ko;
end;


function fnc_mcres_set_cod_od_calcolato
(
    p_cod_abi                   in  t_mcres_app_delibere.cod_abi%type,
    p_cod_ndg                   in  t_mcres_app_delibere.cod_ndg%type,
    p_cod_protocollo_delibera   in  t_mcres_app_delibere.cod_protocollo_delibera%type,
    p_cod_od_calcolato          in  t_mcres_app_delibere.cod_od_calcolato%type,
    p_cod_utente                in  t_mcres_app_delibere.cod_operatore_ins_upd%type,
    p_FLG_STEP5_ACTIVE          in  t_mcres_app_delibere.FLG_STEP5_ACTIVE%type default null
)
return number is


  c_nome constant       varchar2(100) := c_package || '.FNC_MCRES_SET_OD_CALCOLATO';
  v_note                t_mcres_wrk_audit_applicativo.note%type;
  v_exists              number(1);


begin

    v_note := 'controllo validitÃ¿Â  parametri input';
    if
        p_cod_abi is null or
        p_cod_ndg is null or
        p_cod_protocollo_delibera is null
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: campo chiave nullo. COD_ABI = '|| p_cod_abi ||
                                ' COD_NDG = ' || p_cod_ndg || ' COD_PROTOCOLLO_DELIBERA = ' || p_cod_protocollo_delibera
                                || 'COD_OD_CALCOLATO = ' || p_cod_od_calcolato, p_cod_utente);
        return ko;
    end if;


    select count(*)
    into v_exists
    from t_mcres_app_delibere
    where cod_abi = p_cod_abi
    and cod_ndg = p_cod_ndg
    and cod_protocollo_delibera = p_cod_protocollo_delibera;

    if v_exists = 1
    then

        update t_mcres_app_delibere
        set
            cod_od_calcolato = p_cod_od_calcolato,
            dta_upd = sysdate,
            cod_operatore_ins_upd = p_cod_utente,
            FLG_STEP5_ACTIVE = nvl(p_FLG_STEP5_ACTIVE,FLG_STEP5_ACTIVE)
        where 0=0
            and cod_abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_protocollo_delibera = p_cod_protocollo_delibera;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,'Aggiornato organo deliberate calcolato. COD_ABI = '|| p_cod_abi ||
                            ' COD_NDG = ' || p_cod_ndg || ' COD_PROTOCOLLO_DELIBERA = ' || p_cod_protocollo_delibera
                            || 'COD_OD_CALCOLATO = ' || p_cod_od_calcolato, p_cod_utente);

    else

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Delibera non presente. COD_ABI = '|| p_cod_abi ||
                            ' COD_NDG = ' || p_cod_ndg || ' COD_PROTOCOLLO_DELIBERA = ' || p_cod_protocollo_delibera
                            || 'COD_OD_CALCOLATO = ' || p_cod_od_calcolato, p_cod_utente);

        return ko;


    end if;


    return ok;

exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_utente);
    return ko;
end;

/*******************************************************************************************************
******************************************************************************************************/

--FUNZIONE DI CHIUSURA RAPPORTO
FUNCTION fnc_mcres_chiusura_rapporto (
   p_cod_abi        IN   t_mcres_app_rapporti.cod_abi%TYPE,
   p_cod_ndg        IN   t_mcres_app_rapporti.cod_ndg%TYPE,
   p_cod_rapporto   IN   t_mcres_app_rapporti.cod_rapporto%TYPE,
   p_cod_utente     IN   VARCHAR2
)
   RETURN NUMBER
IS
   c_nome   CONSTANT VARCHAR2 (100)
                               := c_package || '.FNC_MCRES_CHIUSURA_RAPPORTO';
   v_note            t_mcres_wrk_audit_applicativo.note%TYPE;
   v_exists          NUMBER (1);
BEGIN
   v_note := 'Controllo validita parametri di input';

   IF (p_cod_abi IS NULL OR p_cod_ndg IS NULL OR p_cod_rapporto IS NULL)
   THEN
      pkg_mcres_audit.log_app
         (c_nome,
          pkg_mcres_audit.c_error,
          SQLCODE,
          SQLERRM,
             'Parametri di input non validi: campo chiave nullo. P_COD_ABI = '
          || p_cod_abi
          || ' P_COD_NDG = '
          || p_cod_ndg
          || ' P_COD_RAPPORTO = '
          || p_cod_rapporto,
          p_cod_utente
         );
      RETURN ko;
   END IF;

   SELECT COUNT (*)
     INTO v_exists
     FROM t_mcres_app_rapporti
    WHERE cod_abi = p_cod_abi
      AND cod_ndg = p_cod_ndg
      AND cod_rapporto = p_cod_rapporto;

   IF v_exists = 1
   THEN
      --CHIUSURA RAPPORTO
      UPDATE t_mcres_app_rapporti
         SET dta_chiusura_rapp = TRUNC (SYSDATE),
             dta_upd = SYSDATE,
             cod_operatore_ins_upd = p_cod_utente
       WHERE cod_abi = p_cod_abi
         AND cod_ndg = p_cod_ndg
         AND cod_rapporto = p_cod_rapporto;
   ELSE
      pkg_mcres_audit.log_app (c_nome,
                               pkg_mcres_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                                  'Rapporto non presente. COD_ABI = '
                               || p_cod_abi
                               || ' COD_NDG = '
                               || p_cod_ndg
                               || ' COD_RAPPORTO = '
                               || p_cod_rapporto,
                               p_cod_utente
                              );
      RETURN ko;
   END IF;

   pkg_mcres_audit.log_app (c_nome,
                            pkg_mcres_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                                 'Rapporto chiuso. COD_ABI = '
                               || p_cod_abi
                               || ' COD_NDG = '
                               || p_cod_ndg
                               || ' COD_RAPPORTO = '
                               || p_cod_rapporto,
                            p_cod_utente
                           );
   RETURN ok;
EXCEPTION
   WHEN OTHERS
   THEN
      pkg_mcres_audit.log_app (c_nome,
                               pkg_mcres_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                               v_note,
                               p_cod_utente
                              );
      RETURN ko;
END;

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
   RETURN NUMBER
IS

   c_nome   CONSTANT VARCHAR2 (100) := c_package || '.FNC_MCRES_GESTIONE_LEGALI';
   v_note   t_mcres_wrk_audit_applicativo.note%TYPE;

   v_exists NUMBER;
   v_cod_sap_fornitore VARCHAR2(10);
   v_seq NUMBER;
   v_prog NUMBER;

   v_hash_rec NUMBER;
   v_hash_str NUMBER;

   v_id_legale NUMBER;

   v_rec_ac_mov t_mcres_app_legali_alb_cnv_mov%ROWTYPE;
   v_flg_albo VARCHAR2(1);
   v_flg_conv VARCHAR2(1);
   v_dta_fine_albo DATE;
   v_dta_fine_conv DATE;

BEGIN

   v_note := 'Controllo validita parametri di input';

 SELECT COUNT (*)
  INTO v_exists
  FROM t_mcres_app_legali_esterni
 WHERE cod_sap_fornitore = p_cod_sap_fornitore
   AND cod_abi = p_cod_abi;


IF (p_cod_sap_fornitore IS NULL AND p_cod_abi IS NULL AND p_flg_opz IN ('D','DF'))
   THEN

      IF p_flg_opz != 'DF'
      THEN

      pkg_mcres_audit.log_app
         (c_nome,
          pkg_mcres_audit.c_error,
          SQLCODE,
          SQLERRM,
             'Parametri di input non validi: campo chiave nullo. P_COD_SAP_FORNITORE = '
          || p_cod_sap_fornitore
          || ', P_COD_ABI = '
          || p_cod_abi
          || ', P_FLG_OPZ = '
          || p_flg_opz,
          p_cod_utente
         );

       END IF;

      RETURN ko;

   END IF;


 IF (v_exists = 0) THEN

                            --CREAZIONE CODICE SAP FORNITORE FITTIZIO
                            SELECT CASE
                                      WHEN (SELECT COUNT (*)
                                              FROM t_mcres_app_legali_esterni
                                             WHERE SUBSTR (cod_sap_fornitore, 0, 1) = 'S') > 0
                                         THEN (SELECT    'S'
                                                      || LPAD (SUBSTR (MAX (cod_sap_fornitore), 2) + 1,
                                                               9,
                                                               0
                                                              )
                                                 FROM t_mcres_app_legali_esterni
                                                WHERE SUBSTR (cod_sap_fornitore, 0, 1) = 'S')
                                      ELSE 'S000000001'
                                   END
                              INTO v_cod_sap_fornitore
                            FROM   DUAL;

 ELSE v_cod_sap_fornitore := p_cod_sap_fornitore;

 END IF;


   IF (p_flg_opz IN ('M','AC','MF') AND (v_exists = 1 OR p_cod_sap_fornitore IS NULL))
   THEN

   --STORICIZZAZIONE
   IF p_cod_sap_fornitore IS NOT NULL and p_cod_abi IS NOT NULL AND p_flg_opz = 'MF' THEN

   --HASH DATI FILTRATO PER COD_SAP_FORNITORE
   SELECT ORA_HASH (   p_rec.val_legale_cognome || '|'
                    || p_rec.val_legale_nome || '|'
                    || p_rec.val_legale_codfisc || '|'
                    || p_rec.val_legale_piva || '|'
                    || p_rec.val_legale_piva_ue || '|'
                    || p_rec.val_legale_piva_extra_ue || '|'
                    || p_rec.val_legale_indirizzo || '|'
                    || p_rec.val_legale_citta || '|'
                    || p_rec.val_legale_prov|| '|'
                    || p_rec.val_legale_cap || '|'
                    || p_rec.val_iban1 || '|'
                    || p_rec.val_iban2 || '|'
                    || p_rec.val_iban3 || '|'
                    || p_rec.val_iban4 || '|'
                    || p_rec.val_iban5 || '|'
                    || p_rec.val_iban6 || '|'
                    || p_rec.val_iban7 || '|'
                    || p_rec.val_iban8 || '|'
                    || p_rec.val_iban9 || '|'
                    || p_rec.val_iban10), p_rec.cod_id_legale
     INTO v_hash_rec, v_id_legale
      FROM t_mcres_app_legali_esterni p_rec
      WHERE p_rec.cod_sap_fornitore = p_cod_sap_fornitore
        AND p_rec.cod_abi = p_cod_abi;


      --HASH DEI PARAMETRI DI INPUT
      SELECT ORA_HASH(p_val_legale_cognome || '|'
                    || p_val_legale_nome || '|'
                    || p_val_legale_codfisc || '|'
                    || p_val_legale_piva || '|'
                    || p_val_legale_piva_ue || '|'
                    || p_val_legale_piva_extra_ue || '|'
                    || p_val_legale_indirizzo || '|'
                    || p_val_legale_citta || '|'
                    || p_val_legale_prov || '|'
                    || p_val_legale_cap || '|'
                    || p_val_iban1 || '|'
                    || p_val_iban2 || '|'
                    || p_val_iban3 || '|'
                    || p_val_iban4 || '|'
                    || p_val_iban5 || '|'
                    || p_val_iban6 || '|'
                    || p_val_iban7 || '|'
                    || p_val_iban8 || '|'
                    || p_val_iban9 || '|'
                    || p_val_iban10)
                    INTO v_hash_str
                    FROM DUAL;


   IF (v_hash_rec IS NOT NULL AND v_hash_rec != v_hash_str)
   THEN

      --ASSEGNO PROGRESSIVO
      SELECT NVL (MAX (prog_mov) + 1, 1)
        INTO v_prog
        FROM t_mcres_app_legali_esterni_mov
       WHERE cod_id_legale = v_id_legale;

      INSERT INTO t_mcres_app_legali_esterni_mov
      SELECT p_rec.cod_id_legale, p_rec.cod_sap_fornitore,
                   p_rec.cod_abi, p_rec.cod_presidio,
                   p_rec.val_legale_cognome, p_rec.val_legale_nome,
                   p_rec.val_legale_codfisc, p_rec.val_legale_piva,
                   p_rec.val_legale_piva_ue, p_rec.val_legale_piva_extra_ue,
                   p_rec.val_legale_indirizzo, p_rec.val_legale_citta,
                   p_rec.val_legale_prov, p_rec.val_legale_cap,
                   p_rec.val_legale_telef, p_rec.val_legale_fax,
                   p_rec.val_legale_email, p_rec.val_legale_abi,
                   p_rec.val_legale_cab, p_rec.val_legale_conto,
                   p_rec.val_legale_cin, p_rec.cod_specializzazione,
                   p_rec.val_legale_ind_proc_gen, p_rec.dta_procura_gen,
                   p_rec.cod_num_repertorio_pg, p_rec.val_nominativo_notaio,
                   p_rec.val_note, p_rec.dta_cancellazione,
                   p_rec.flg_obbligo_autoriz, p_rec.flg_visualizza,
                   p_rec.cod_citta, p_rec.val_iban1, p_rec.val_iban2,
                   p_rec.val_iban3, p_rec.val_iban4, p_rec.val_iban5,
                   p_rec.val_iban6, p_rec.val_iban7, p_rec.val_iban8,
                   p_rec.val_iban9, p_rec.val_iban10, p_rec.flg_active,
                   p_rec.flg_albo, p_rec.dta_inizio_albo, p_rec.dta_fine_albo,
                   p_rec.flg_convenz, p_rec.dta_inizio_convenz,
                   p_rec.dta_fine_convenz, p_rec.cod_operatore_ins_upd,
                   p_rec.dta_ins, p_rec.dta_upd, v_prog, SYSDATE, p_rec.val_autorizzazione_cens, p_rec.dta_autorizzazione_cens
                   FROM t_mcres_app_legali_esterni p_rec
                   WHERE p_rec.cod_id_legale = v_id_legale;

   END IF;
   END IF;


   --CREAZIONE SEQUENCE
     SELECT NVL(MAX (cod_id_legale) + 1, 1)
     INTO v_seq
    FROM t_mcres_app_legali_esterni;

--RECUPERO FLAGS PRECEDENTI E DATE FINE ALBO CONV
  IF (p_cod_sap_fornitore IS NOT NULL AND p_cod_abi IS NOT NULL AND p_flg_opz IN('M','AC')) THEN
  SELECT p_rec.flg_albo, p_rec.flg_convenz, p_rec.dta_fine_albo, p_rec.dta_fine_convenz
  INTO v_flg_albo, v_flg_conv, v_dta_fine_albo, v_dta_fine_conv
  FROM t_mcres_app_legali_esterni p_rec
 WHERE p_rec.cod_sap_fornitore = p_cod_sap_fornitore
   AND p_rec.cod_abi = p_cod_abi;
  END IF;

   --INSERIMENTO/AGGIORNAMENTO
   MERGE INTO t_mcres_app_legali_esterni t
         USING (
   SELECT
   v_cod_sap_fornitore AS cod_sap_fornitore,
   p_cod_abi AS cod_abi,
   p_cod_presidio AS cod_presidio,
   p_val_legale_cognome AS val_legale_cognome,
   p_val_legale_nome AS val_legale_nome,
   p_val_legale_codfisc AS val_legale_codfisc,
   p_val_legale_piva AS val_legale_piva,
   p_val_legale_piva_ue AS val_legale_piva_ue,
   p_val_legale_piva_extra_ue AS val_legale_piva_extra_ue,
   p_val_legale_indirizzo AS val_legale_indirizzo,
   p_val_legale_citta AS val_legale_citta,
   p_val_legale_prov AS val_legale_prov,
   p_val_legale_cap AS val_legale_cap,
   p_val_legale_telef AS val_legale_telef,
   p_val_legale_fax AS val_legale_fax,
   p_val_legale_email AS val_legale_email,
   p_val_legale_abi AS val_legale_abi,
   p_val_legale_cab AS val_legale_cab,
   p_val_legale_conto AS val_legale_conto,
   p_val_legale_cin AS val_legale_cin,
   p_cod_specializzazione AS cod_specializzazione,
   p_val_legale_ind_proc_gen AS val_legale_ind_proc_gen,
   p_dta_procura_gen AS dta_procura_gen,
   p_cod_num_repertorio_pg AS cod_num_repertorio_pg,
   p_val_nominativo_notaio AS val_nominativo_notaio,
   p_val_note AS val_note,
   p_flg_obbligo_autoriz AS flg_obbligo_autoriz,
   p_flg_visualizza AS flg_visualizza,
   p_cod_citta AS cod_citta,
   p_val_iban1 AS val_iban1,
   p_val_iban2 AS val_iban2,
   p_val_iban3 AS val_iban3,
   p_val_iban4 AS val_iban4,
   p_val_iban5 AS val_iban5,
   p_val_iban6 AS val_iban6,
   p_val_iban7 AS val_iban7,
   p_val_iban8 AS val_iban8,
   p_val_iban9 AS val_iban9,
   p_val_iban10 AS val_iban10,
   p_flg_albo AS flg_albo,
   p_flg_convenz AS flg_convenz,
   p_val_autorizzazione_cens AS val_autorizzazione_cens,
   p_dta_autorizzazione_cens AS dta_autorizzazione_cens,
   p_val_note_albo_conv AS val_note_albo_conv,
   p_dta_inizio_albo AS dta_inizio_albo,
   p_dta_inizio_convenz AS dta_inizio_convenz,
   p_dta_fine_albo AS dta_fine_albo,
   p_dta_fine_convenz AS dta_fine_convenz,
   P_COD_ID_CONTRATTO AS COD_ID_CONTRATTO,
   P_DTA_CONTRATTO AS DTA_CONTRATTO,
   P_DTA_SCAD_CONTRATTO AS DTA_SCAD_CONTRATTO,
   P_COD_ID_CONVENZIONE AS COD_ID_CONVENZIONE,
   P_DTA_SCAD_CONVENZIONE AS DTA_SCAD_CONVENZIONE,
   P_VAL_FORO1 AS VAL_FORO1,
   P_VAL_FORO2 AS VAL_FORO2,
   P_VAL_FORO3 AS VAL_FORO3,
   P_VAL_FORO4 AS VAL_FORO4,
   P_COD_USER_ID AS COD_USER_ID
   FROM DUAL) s
         ON (t.cod_sap_fornitore = s.cod_sap_fornitore
         AND t.cod_abi = s.cod_abi
         --AGGIUNTO FLG_ATTIVO AP 16102012
         --RIMOSSO FLG_ATTIVO AP 17012013
         /*AND t.flg_active = 1*/)
         WHEN MATCHED THEN
            UPDATE SET
   t.cod_presidio = CASE WHEN p_flg_opz = 'MF' then NVL(s.cod_presidio, t.cod_presidio) else s.cod_presidio END,
   t.val_legale_cognome = s.val_legale_cognome,
   t.val_legale_nome = s.val_legale_nome,
   t.val_legale_codfisc = s.val_legale_codfisc,
   t.val_legale_piva = s.val_legale_piva,
   -- AP 16102012
   t.val_legale_piva_ue = s.val_legale_piva_ue,
   t.val_legale_piva_extra_ue = s.val_legale_piva_extra_ue,
   ----
   t.val_legale_indirizzo = s.val_legale_indirizzo,
   t.val_legale_citta = s.val_legale_citta,
   t.val_legale_prov = s.val_legale_prov,
   t.val_legale_cap = s.val_legale_cap,
   t.val_legale_telef = CASE WHEN p_flg_opz = 'MF' then NVL(s.val_legale_telef, t.val_legale_telef) else s.val_legale_telef END,
   t.val_legale_fax = CASE WHEN p_flg_opz = 'MF' then NVL(s.val_legale_fax, t.val_legale_fax) else s.val_legale_fax END,
   t.val_legale_email = CASE WHEN p_flg_opz = 'MF' then NVL(s.val_legale_email, t.val_legale_email) else s.val_legale_email END,
   t.val_legale_abi = CASE WHEN p_flg_opz = 'MF' then NVL(s.val_legale_abi, t.val_legale_abi) else s.val_legale_abi END,
   t.val_legale_cab = CASE WHEN p_flg_opz = 'MF' then NVL(s.val_legale_cab, t.val_legale_cab) else s.val_legale_cab END,
   t.val_legale_conto = CASE WHEN p_flg_opz = 'MF' then NVL(s.val_legale_conto, t.val_legale_conto) else s.val_legale_conto END,
   t.val_legale_cin = CASE WHEN p_flg_opz = 'MF' then NVL(s.val_legale_cin, t.val_legale_cin) else s.val_legale_cin END,
   t.cod_specializzazione = CASE WHEN p_flg_opz = 'MF' then NVL(s.cod_specializzazione, t.cod_specializzazione) else s.cod_specializzazione END,
   t.val_legale_ind_proc_gen = CASE WHEN p_flg_opz = 'MF' then NVL(s.val_legale_ind_proc_gen, t.val_legale_ind_proc_gen) else s.val_legale_ind_proc_gen END,
   t.dta_procura_gen = CASE WHEN p_flg_opz = 'MF' then NVL(s.dta_procura_gen, t.dta_procura_gen) else s.dta_procura_gen END,
   t.cod_num_repertorio_pg = CASE WHEN p_flg_opz = 'MF' then NVL(s.cod_num_repertorio_pg, t.cod_num_repertorio_pg) else s.cod_num_repertorio_pg END,
   t.val_nominativo_notaio = CASE WHEN p_flg_opz = 'MF' then NVL(s.val_nominativo_notaio, t.val_nominativo_notaio) else s.val_nominativo_notaio END,
   t.val_note = CASE WHEN p_flg_opz = 'MF' then NVL(s.val_note, t.val_note) else s.val_note END,
   t.flg_obbligo_autoriz = CASE WHEN p_flg_opz = 'MF' then NVL(s.flg_obbligo_autoriz, t.flg_obbligo_autoriz) else s.flg_obbligo_autoriz END,
   t.flg_visualizza = CASE WHEN p_flg_opz = 'MF' then NVL(s.flg_visualizza, t.flg_visualizza) else s.flg_visualizza END,
   t.cod_citta = CASE WHEN p_flg_opz = 'MF' then NVL(s.cod_citta, t.cod_citta) else s.cod_citta END,
   t.val_iban1 = s.val_iban1,
   t.val_iban2 = s.val_iban2,
   t.val_iban3 = s.val_iban3,
   t.val_iban4 = s.val_iban4,
   t.val_iban5 = s.val_iban5,
   t.val_iban6 = s.val_iban6,
   t.val_iban7 = s.val_iban7,
   t.val_iban8 = s.val_iban8,
   t.val_iban9 = s.val_iban9,
   t.val_iban10 = s.val_iban10,
   t.flg_albo = CASE WHEN s.flg_albo IN ('S','N') THEN s.flg_albo ELSE t.flg_albo END,
   t.dta_inizio_albo = NVL(s.dta_inizio_albo, CASE WHEN (s.flg_albo = 'S' AND p_flg_opz = 'M' AND t.flg_albo != 'S') THEN SYSDATE ELSE DECODE(p_flg_opz, 'M', t.dta_inizio_albo, 'MF', t.dta_inizio_albo, s.dta_inizio_albo) END),
   t.dta_fine_albo = NVL(s.dta_fine_albo, CASE WHEN (s.flg_albo = 'S' AND t.dta_inizio_albo IS NOT NULL AND p_flg_opz = 'M' AND t.flg_albo != 'S') THEN TO_DATE('31/12/9999','DD/MM/YYYY')
                                               WHEN (s.flg_albo = 'N' AND t.dta_inizio_albo IS NOT NULL AND p_flg_opz = 'M' AND t.flg_albo != 'N') THEN SYSDATE ELSE DECODE(p_flg_opz, 'M', t.dta_fine_albo, 'MF', t.dta_fine_albo, s.dta_fine_albo) END),
   t.flg_convenz = CASE WHEN s.flg_convenz IN ('S','N') THEN s.flg_convenz ELSE t.flg_convenz END,
   t.dta_inizio_convenz = NVL(s.dta_inizio_convenz, CASE WHEN (s.flg_convenz = 'S' AND p_flg_opz = 'M' AND t.flg_convenz != 'S') THEN SYSDATE ELSE DECODE(p_flg_opz, 'M', t.dta_inizio_convenz, 'MF', t.dta_inizio_convenz, s.dta_inizio_convenz) END),
   t.dta_fine_convenz = NVL(s.dta_fine_convenz, CASE WHEN (s.flg_convenz = 'S' AND t.dta_inizio_convenz IS NOT NULL AND p_flg_opz = 'M' AND t.flg_convenz != 'S') THEN TO_DATE('31/12/9999','DD/MM/YYYY')
                                                     WHEN (s.flg_convenz = 'N' AND t.dta_inizio_convenz IS NOT NULL AND p_flg_opz = 'M' AND t.flg_convenz != 'N') THEN SYSDATE ELSE DECODE(p_flg_opz, 'M', t.dta_fine_convenz, 'MF', t.dta_fine_convenz, s.dta_fine_convenz) END),
   t.cod_operatore_ins_upd = NVL(p_cod_utente, t.cod_operatore_ins_upd),
   t.dta_upd = CASE WHEN p_flg_opz IN ('M','AC') THEN SYSDATE ELSE t.dta_upd END,
   t.dta_upd_btch = CASE WHEN p_flg_opz = 'MF' THEN SYSDATE ELSE t.dta_upd_btch END,
   t.val_autorizzazione_cens = CASE WHEN p_flg_opz = 'MF' then NVL(s.val_autorizzazione_cens, t.val_autorizzazione_cens) else s.val_autorizzazione_cens END,
   t.dta_autorizzazione_cens = CASE WHEN p_flg_opz = 'MF' then NVL(s.dta_autorizzazione_cens, t.dta_autorizzazione_cens) else s.dta_autorizzazione_cens END,
   --AGGIUNTO AP 17012013
   t.flg_active = CASE WHEN p_flg_opz = 'M' THEN 1 ELSE t.flg_active END,
   --t.val_note_albo_conv = NVL(s.val_note_albo_conv, t.val_note_albo_conv)
   --AP 18/11/2013
   t.val_note_albo_conv = NVL(s.val_note_albo_conv, DECODE(p_flg_opz, 'M', t.val_note_albo_conv, 'MF', t.val_note_albo_conv, s.val_note_albo_conv)),
   t.COD_ID_CONTRATTO = CASE WHEN p_flg_opz = 'MF' then NVL(s.COD_ID_CONTRATTO, t.COD_ID_CONTRATTO) else s.COD_ID_CONTRATTO END,
   t.DTA_CONTRATTO = CASE WHEN p_flg_opz = 'MF' then NVL(s.DTA_CONTRATTO, t.DTA_CONTRATTO) else s.DTA_CONTRATTO END,
   t.DTA_SCAD_CONTRATTO = CASE WHEN p_flg_opz = 'MF' then NVL(s.DTA_SCAD_CONTRATTO, t.DTA_SCAD_CONTRATTO) else s.DTA_SCAD_CONTRATTO END,
   t.COD_ID_CONVENZIONE = CASE WHEN p_flg_opz = 'MF' then NVL(s.COD_ID_CONVENZIONE, t.COD_ID_CONVENZIONE) else s.COD_ID_CONVENZIONE END,
   t.DTA_SCAD_CONVENZIONE = CASE WHEN p_flg_opz = 'MF' then NVL(s.DTA_SCAD_CONVENZIONE, t.DTA_SCAD_CONVENZIONE) else s.DTA_SCAD_CONVENZIONE END,
   t.VAL_FORO1 = CASE WHEN p_flg_opz = 'MF' then NVL(s.VAL_FORO1, t.VAL_FORO1) else s.VAL_FORO1 END,
   t.VAL_FORO2 = CASE WHEN p_flg_opz = 'MF' then NVL(s.VAL_FORO2, t.VAL_FORO2) else s.VAL_FORO2 END,
   t.VAL_FORO3 = CASE WHEN p_flg_opz = 'MF' then NVL(s.VAL_FORO3, t.VAL_FORO3) else s.VAL_FORO3 END,
   t.VAL_FORO4 = CASE WHEN p_flg_opz = 'MF' then NVL(s.VAL_FORO4, t.VAL_FORO4) else s.VAL_FORO4 END,
   t.COD_USER_ID = CASE WHEN p_flg_opz = 'MF' then NVL(s.COD_USER_ID, t.COD_USER_ID) else s.COD_USER_ID END
         WHEN NOT MATCHED THEN
            INSERT (
            t.cod_id_legale,
   t.cod_sap_fornitore,
   t.cod_abi,
   t.cod_presidio,
   t.val_legale_cognome,
   t.val_legale_nome,
   t.val_legale_codfisc,
   t.val_legale_piva,
   t.val_legale_piva_ue,
   t.val_legale_piva_extra_ue,
   t.val_legale_indirizzo,
   t.val_legale_citta,
   t.val_legale_prov,
   t.val_legale_cap,
   t.val_legale_telef,
   t.val_legale_fax,
   t.val_legale_email,
   t.val_legale_abi,
   t.val_legale_cab,
   t.val_legale_conto,
   t.val_legale_cin,
   t.cod_specializzazione,
   t.val_legale_ind_proc_gen,
   t.dta_procura_gen,
   t.cod_num_repertorio_pg,
   t.val_nominativo_notaio,
   t.val_note,
   t.flg_obbligo_autoriz,
   t.flg_visualizza,
   t.cod_citta,
   t.val_iban1,
   t.val_iban2,
   t.val_iban3,
   t.val_iban4,
   t.val_iban5,
   t.val_iban6,
   t.val_iban7,
   t.val_iban8,
   t.val_iban9,
   t.val_iban10,
   t.dta_inizio_albo,
   t.dta_fine_albo,
   t.flg_albo,
   t.dta_inizio_convenz,
   t.dta_fine_convenz,
   t.flg_convenz,
   t.cod_operatore_ins_upd,
   t.dta_ins,
   t.dta_upd,
   t.val_autorizzazione_cens,
   t.dta_autorizzazione_cens,
   t.val_note_albo_conv,
   t.COD_ID_CONTRATTO,
   t.DTA_CONTRATTO,
   t.DTA_SCAD_CONTRATTO,
   t.COD_ID_CONVENZIONE,
   t.DTA_SCAD_CONVENZIONE,
   t.VAL_FORO1,
   t.VAL_FORO2,
   t.VAL_FORO3,
   t.VAL_FORO4,
   t.COD_USER_ID)
            VALUES (
            v_seq,
   s.cod_sap_fornitore,
   s.cod_abi,
   s.cod_presidio,
   s.val_legale_cognome,
   s.val_legale_nome,
   s.val_legale_codfisc,
   s.val_legale_piva,
   s.val_legale_piva_ue,
   s.val_legale_piva_extra_ue,
   s.val_legale_indirizzo,
   s.val_legale_citta,
   s.val_legale_prov,
   s.val_legale_cap,
   s.val_legale_telef,
   s.val_legale_fax,
   s.val_legale_email,
   s.val_legale_abi,
   s.val_legale_cab,
   s.val_legale_conto,
   s.val_legale_cin,
   s.cod_specializzazione,
   s.val_legale_ind_proc_gen,
   s.dta_procura_gen,
   s.cod_num_repertorio_pg,
   s.val_nominativo_notaio,
   s.val_note,
   s.flg_obbligo_autoriz,
   s.flg_visualizza,
   s.cod_citta,
   s.val_iban1,
   s.val_iban2,
   s.val_iban3,
   s.val_iban4,
   s.val_iban5,
   s.val_iban6,
   s.val_iban7,
   s.val_iban8,
   s.val_iban9,
   s.val_iban10,
   CASE WHEN s.flg_albo = 'S' THEN SYSDATE END,
   CASE WHEN s.flg_albo = 'S' THEN TO_DATE('31/12/9999','DD/MM/YYYY') END,
   CASE WHEN s.flg_albo IN ('S','N') THEN s.flg_albo ELSE 'N' END,
   CASE WHEN s.flg_convenz = 'S' THEN SYSDATE END,
   CASE WHEN s.flg_convenz = 'S' THEN TO_DATE('31/12/9999','DD/MM/YYYY') END,
   CASE WHEN s.flg_convenz IN ('S','N') THEN s.flg_convenz ELSE 'N' END,
   p_cod_utente,
   SYSDATE,
   SYSDATE,
   s.val_autorizzazione_cens,
   S.dta_autorizzazione_cens,
   s.val_note_albo_conv,
   s.COD_ID_CONTRATTO,
   s.DTA_CONTRATTO,
   s.DTA_SCAD_CONTRATTO,
   s.COD_ID_CONVENZIONE,
   s.DTA_SCAD_CONVENZIONE,
   s.VAL_FORO1,
   s.VAL_FORO2,
   s.VAL_FORO3,
   s.VAL_FORO4,
   s.COD_USER_ID);

   --STORICIZZAZIONE ALBO - CONVENZIONE
   IF p_cod_sap_fornitore IS NOT NULL and p_cod_abi IS NOT NULL AND p_flg_opz IN('M','AC') THEN

SELECT p_rec.cod_id_legale,
       p_rec.dta_inizio_albo,
       p_rec.dta_inizio_convenz,
       p_rec.dta_fine_albo,
       p_rec.dta_fine_convenz,
       p_rec.val_note_albo_conv,
       (SELECT NVL (MAX (A.prog_mov) + 1, 1) FROM T_MCRES_APP_LEGALI_ALB_CNV_MOV A),
       SYSDATE
  INTO v_rec_ac_mov
  FROM t_mcres_app_legali_esterni p_rec
 WHERE p_rec.cod_sap_fornitore = p_cod_sap_fornitore
   AND p_rec.cod_abi = p_cod_abi;

      IF ((v_rec_ac_mov.dta_inizio_albo IS NOT NULL AND v_rec_ac_mov.dta_inizio_convenz IS NOT NULL) AND
          (TRUNC(NVL(v_dta_fine_albo, TO_DATE('31/12/9999', 'DD/MM/YYYY'))) = TO_DATE('31/12/9999', 'DD/MM/YYYY') OR
           TRUNC(NVL(v_dta_fine_conv, TO_DATE('31/12/9999', 'DD/MM/YYYY'))) = TO_DATE('31/12/9999', 'DD/MM/YYYY')) AND
          (p_flg_albo = 'N' AND p_flg_convenz = 'N') AND (v_flg_albo != 'N' OR v_flg_conv != 'N'))
      THEN

      INSERT INTO T_MCRES_APP_LEGALI_ALB_CNV_MOV
      SELECT v_rec_ac_mov.id_legale,
             v_rec_ac_mov.dta_inizio_albo,
             v_rec_ac_mov.dta_inizio_convenz,
             v_rec_ac_mov.dta_fine_albo,
             v_rec_ac_mov.dta_fine_convenz,
             v_rec_ac_mov.val_note_albo_conv,
             v_rec_ac_mov.prog_mov,
             v_rec_ac_mov.dta_mov
       FROM DUAL;

      END IF;
   END IF;

   IF p_flg_opz != 'MF' THEN
      pkg_mcres_audit.log_app (c_nome,
                               pkg_mcres_audit.c_debug,
                               SQLCODE,
                               SQLERRM,
                                'Record con chiave COD_SAP_FORNITORE = '
                               || v_cod_sap_fornitore
                               || ', COD_ABI = '
                               || p_cod_abi
                               || ' mergiato.',
                               p_cod_utente
                              )   ;

                              END IF;

          ELSIF (p_flg_opz IN ('D','DF') AND v_exists = 1) THEN

      --CANCELLAZIONE LOGICA
      UPDATE t_mcres_app_legali_esterni
         SET dta_cancellazione = TRUNC(SYSDATE),
             flg_active = 0,
             dta_upd = CASE WHEN p_cod_utente IS NOT NULL THEN SYSDATE ELSE dta_upd END,
             cod_operatore_ins_upd = NVL(p_cod_utente, cod_operatore_ins_upd),
             dta_upd_btch = CASE WHEN p_cod_utente IS NULL THEN SYSDATE ELSE dta_upd_btch END
       WHERE cod_sap_fornitore = p_cod_sap_fornitore
         AND cod_abi = p_cod_abi;

      IF p_flg_opz != 'DF'
      THEN
      pkg_mcres_audit.log_app (c_nome,
                               pkg_mcres_audit.c_debug,
                               SQLCODE,
                               SQLERRM,
                                  'Record con chiave COD_SAP_FORNITORE = '
                               || p_cod_sap_fornitore
                               || ', COD_ABI = '
                               || p_cod_abi
                               || ' cancellato logicamente.',
                               p_cod_utente
                              );

                              END IF;

                            ELSE

                            IF p_flg_opz NOT IN ('MF','DF') THEN

                            pkg_mcres_audit.log_app (c_nome,
                               pkg_mcres_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                                 'Record con chiave COD_SAP_FORNITORE = '
                               || p_cod_sap_fornitore
                               || ', COD_ABI = '
                               || p_cod_abi
                               || ' non presente.',
                               p_cod_utente
                              );

                              END IF;

                              RETURN ko;

   END IF;




   RETURN ok;

EXCEPTION
   WHEN OTHERS
   THEN
      pkg_mcres_audit.log_app (c_nome,
                               pkg_mcres_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                               v_note,
                               p_cod_utente
                              );
      RETURN ko;

END;


FUNCTION fnc_mcres_fornitori_legali (P_REC IN F_SLAVE_PAR_TYPE)
   RETURN NUMBER
IS
   ret        NUMBER;
   v_exists   NUMBER;
   v_rec      t_mcres_app_fornitori%ROWTYPE;
   no_data    NUMBER;

BEGIN

--ASSEGNAZIONE ULTIMO COD_SAP_FORNITORE AI LEGALI
   MERGE INTO t_mcres_app_legali_esterni t
      USING (SELECT *
  FROM (SELECT x.*,
               ROW_NUMBER () OVER (PARTITION BY x.val_codice_fiscale ORDER BY x.cod_sap_fornitore DESC)
                                                                            r
          FROM (SELECT fornitori.cod_sap_fornitore, fornitori.cod_abi,
                       fornitori.val_codice_fiscale
                  FROM (SELECT a.cod_sap_fornitore, b.cod_abi,
                               a.val_codice_fiscale
                          FROM t_mcres_app_fornitori a JOIN t_mcres_cl_sap b
                               ON (a.cod_societa = b.cod_societa)
                               ) fornitori
                       JOIN
                       t_mcres_app_legali_esterni legali
                       ON (    fornitori.cod_abi = legali.cod_abi
                           AND fornitori.val_codice_fiscale =
                                                     legali.val_legale_codfisc
                           AND legali.flg_active = 1
                          )
                       ) x) WHERE r = 1) src
      ON (t.cod_abi = src.cod_abi AND t.val_legale_codfisc = src.val_codice_fiscale and t.flg_active = 1)
      WHEN MATCHED THEN
         UPDATE
            SET t.cod_sap_fornitore = src.cod_sap_fornitore;


   FOR I IN (SELECT *
               FROM t_mcres_app_legali_esterni
               WHERE flg_active = 1)
   LOOP
      BEGIN
         BEGIN

         no_data := 0;

--15/01/2013   A.Pilloni
SELECT cod_sap_fornitore,
       val_ragione_sociale1,
       val_ragione_sociale2,
       val_partita_iva,
       val_codice_fiscale,
       val_partita_iva_ue,
       val_partita_iva_extra_ue,
       val_indirizzo,
       val_cap,
       val_localita,
       val_paese,
       val_regione,
       dta_censimento,
       cod_societa,
       val_perc_ritenuta,
       val_aliquota_ritenuta,
       val_aliquota_cpa,
       val_aliquota_cpa2,
       val_iban1,
       val_iban2,
       val_iban3,
       val_iban4,
       val_iban5,
       val_iban6,
       val_iban7,
       val_iban8,
       val_iban9,
       val_iban10,
       cod_operatore_ins_upd,
       dta_ins,
       dta_upd
  INTO v_rec
  FROM (SELECT a.*,
               ROW_NUMBER () OVER (PARTITION BY a.cod_sap_fornitore, b.cod_abi ORDER BY b.cod_societa DESC)
                                                                            r
          FROM t_mcres_app_fornitori a JOIN t_mcres_cl_sap b
               ON (a.cod_societa = b.cod_societa)
         WHERE cod_sap_fornitore = i.cod_sap_fornitore
           AND b.cod_abi = i.cod_abi)
 WHERE r = 1;

         EXCEPTION
         WHEN NO_DATA_FOUND THEN

         no_data := 1;
         END;


         IF (no_data = 0)
         THEN


            ret := fnc_mcres_gestione_legali ('MF',
                                       NULL,
                                       v_rec.cod_sap_fornitore,
                                       I.cod_abi /*cod_abi*/,
                                       NULL /*v_rec.cod_presidio*/,
                                       v_rec.val_ragione_sociale1,
                                       v_rec.val_ragione_sociale2,
                                       v_rec.val_codice_fiscale,
                                       v_rec.val_partita_iva,
                                       v_rec.val_partita_iva_ue,
                                       v_rec.val_partita_iva_extra_ue,
                                       v_rec.val_indirizzo,
                                       v_rec.val_localita,
                                       v_rec.val_regione,
                                       v_rec.val_cap,
                                       NULL /*v_rec.val_legale_telef*/,
                                       NULL /*v_rec.val_legale_fax*/,
                                       NULL /*v_rec.val_legale_email*/,
                                       NULL /*v_rec.val_legale_abi*/,
                                       NULL /*v_rec.val_legale_cab*/,
                                       NULL /*v_rec.val_legale_conto*/,
                                       NULL /*v_rec.val_legale_cin*/,
                                       NULL /*v_rec.cod_specializzazione*/,
                                       NULL /*v_rec.val_legale_ind_proc_gen*/,
                                       NULL /*v_rec.dta_procura_gen*/,
                                       NULL /*v_rec.cod_num_repertorio_pg*/,
                                       NULL /*v_rec.val_nominativo_notaio*/,
                                       NULL /*v_rec.val_note*/,
                                       NULL /*v_rec.flg_obbligo_autoriz*/,
                                       NULL /*v_rec.flg_visualizza*/,
                                       NULL /*v_rec.cod_citta*/,
                                       v_rec.val_iban1,
                                       v_rec.val_iban2,
                                       v_rec.val_iban3,
                                       v_rec.val_iban4,
                                       v_rec.val_iban5,
                                       v_rec.val_iban6,
                                       v_rec.val_iban7,
                                       v_rec.val_iban8,
                                       v_rec.val_iban9,
                                       v_rec.val_iban10
                                      );

         ELSIF (no_data = 1 AND SUBSTR(I.COD_SAP_FORNITORE, 0, 1) != 'S')
         THEN

            ret :=
               fnc_mcres_gestione_legali ('DF',
                                          NULL,
                                          I.cod_sap_fornitore,
                                          I.cod_abi
                                         );
         END IF;

      END;
   END LOOP;

   RETURN ok;

END;


/*************************************************************************************
*************************************************************************************/

FUNCTION FNC_SET_SP_PRESA_VISIONE(
    p_cod_autorizzazione T_Mcres_App_Sp_Spese.COD_AUTORIZZAZIONE%type,
    p_cod_utente       VARCHAR2,
    p_cod_tipo_utente  VARCHAR2)
  RETURN NUMBER

  IS


    c_nome   CONSTANT VARCHAR2 (100) := c_package || '.FNC_SET_SP_PRESA_VISIONE';
   v_note   t_mcres_wrk_audit_applicativo.note%TYPE;

    BEGIN

        UPDATE
        T_Mcres_App_Sp_Spese
        SET flg_presa_vis = DECODE(p_cod_tipo_utente, 'G', 1, flg_presa_vis),
            flg_presa_vis_presidio = DECODE(p_cod_tipo_utente, 'P', 1, flg_presa_vis_presidio),
            flg_presa_vis_ente_centr = DECODE(p_cod_tipo_utente, 'E', 1, flg_presa_vis_ente_centr),
        dta_presa_vis = SYSDATE
        WHERE
        Cod_Autorizzazione = p_Cod_Autorizzazione;

    RETURN ok;

EXCEPTION
   WHEN OTHERS
   THEN
      pkg_mcres_audit.log_app (c_nome,
                               pkg_mcres_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                               v_note,
                               p_cod_utente
                              );
      RETURN ko;

end;


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
return number
is

    c_nome      constant varchar2(61)                       :=  c_package || '.FNC_MCRES_POPOLA_DOCUMENTI';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;

    v_count     number;

begin

    v_note := 'Controllo validitï¿¿arametri di input';

    if      p_cod_abi   is null
        or  p_cod_ndg   is null
        or  p_id_object is null
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      =>      'Parametri di input non validi.COD_ABI = ' || p_cod_abi
                                                    ||  ', COD_NDG = ' || p_cod_ndg || ', ID_OBJECT = ' || p_id_object,
                                    p_utente    => p_cod_utente
                                );
        return ko;

    end if;


    v_note := 'Check chiave primaria';

    select count(*)
    into v_count
    from t_mcres_app_documenti
    where 0=0
        and cod_abi = p_cod_abi
        and cod_ndg = p_cod_ndg
        and id_object = p_id_object;


    if v_count <> 0
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      =>      'Impossibile inserire. Violazione chiave primaria.COD_ABI = ' || p_cod_abi
                                                    ||  ', COD_NDG = ' || p_cod_ndg || ', ID_OBJECT = ' || p_id_object,
                                    p_utente    => p_cod_utente
                                );
        return ko;

    end if;



    if p_cod_tipo_documento = 'DO'  -- controllo che non sia presente un altro DO sulla stessa spesa o delibera
    then

        v_note := 'Check per cod_tipo_documento DO';

        select count(*)
        into v_count
        from t_mcres_app_documenti
        where 0=0
            and cod_abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_aut_protoc = p_cod_aut_protoc
            and cod_tipo_documento = 'DO';


        if v_count <> 0
        then

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Impossibile inserire. Documento di tipo DO presente. COD_ABI= ' || p_cod_abi|| ' COD_NDG = ' || p_cod_ndg || ' COD_AUT_PROTOC = ' || p_cod_aut_protoc,
                                        p_utente    => p_cod_utente
                                    );
            return ko;

        end if;

    end if;



    if p_cod_tipo_documento = 'AL'
    then


        v_note := 'Check per cod_tipo_documento AL e cod_stato CO';

        -- controllo se presente in stato confermato

        select count(*)
        into v_count
        from t_mcres_app_documenti
        where 0=0
            and cod_abi = p_cod_abi
            and cod_ndg = p_cod_ndg
            and cod_aut_protoc = p_cod_aut_protoc
            and cod_progressivo = p_cod_progressivo
            and cod_stato = 'CO'
            and cod_tipo_documento = 'AL';

        if v_count > 0 and p_cod_stato != 'AN'
        then

            pkg_mcres_audit.log_app (
                                        p_proc      => c_nome,
                                        p_livello   => pkg_mcres_audit.c_error,
                                        p_sqlcode   => SQLCODE,
                                        p_mssg      => SQLERRM,
                                        p_note      => 'Allegato presente in stato confermato. COD_ABI = ' || p_cod_abi || ' COD_NDG = ' || p_cod_ndg || ' COD_AUT_PROC = ' || p_cod_aut_protoc
                                                        || ', COD_TIPO_DOCUMENTO = ' || p_cod_tipo_documento
                                                        || ', COD_STATO = ' || p_cod_stato,
                                        p_utente    => p_cod_utente
                                    );

            return ko;

        end if;


        if p_cod_stato = 'TR' and p_cod_stato != 'AN'   -- e non presente in stato confermato
        then


            -- controllo che non ci sia presente in stato trasferito

            select count(*)
            into v_count
            from t_mcres_app_documenti
            where 0=0
                and cod_abi = p_cod_abi
                and cod_ndg = p_cod_ndg
                and cod_aut_protoc = p_cod_aut_protoc
                and cod_progressivo = p_cod_progressivo
                and cod_stato = 'TR'
                and cod_tipo_documento = 'AL';

            if v_count > 0
            then


                pkg_mcres_audit.log_app (
                                            p_proc      => c_nome,
                                            p_livello   => pkg_mcres_audit.c_error,
                                            p_sqlcode   => SQLCODE,
                                            p_mssg      => SQLERRM,
                                            p_note      => 'Allegato presente in stato trasferito. COD_ABI = ' || p_cod_abi || ' COD_NDG = ' || p_cod_ndg || ' COD_AUT_PROC = ' || p_cod_aut_protoc
                                                            || ', COD_TIPO_DOCUMENTO = ' || p_cod_tipo_documento
                                                            || ', COD_STATO = ' || p_cod_stato,
                                            p_utente    => p_cod_utente
                                        );

                return ko;

            end if;


        end if;



    end if;



    v_note := 'Controlli superati. Insert';


    insert into t_mcres_app_documenti
    (
        id_object,
        cod_abi,
        cod_ndg,
        cod_pratica,
        val_anno_pratica,
        cod_aut_protoc,
        cod_identificativo,
        cod_tipo_del_spesa,
        cod_tipo_documento,
        cod_progressivo,
        cod_stato,
        cod_origine,
        val_doc_name,
        dta_ins
    )
    values
    (
        p_id_object,
        p_cod_abi,
        p_cod_ndg,
        p_cod_pratica,
        p_val_anno_pratica,
        p_cod_aut_protoc,
        p_cod_identificativo,
        p_cod_tipo_del_spesa,
        p_cod_tipo_documento,
        p_cod_progressivo,
        p_cod_stato,
        p_cod_origine,
        p_val_doc_name,
        sysdate
    );


    return ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Generale ' || v_note,
                                    p_utente    => p_cod_utente
                                );

        return ko;

end;


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
return number
is

    c_nome      constant varchar2(61)                       :=  c_package || '.FNC_MCRES_POPOLA_TOP_30_NT';
    v_note      t_mcres_wrk_audit_caricamenti.note%type;

    v_count     number;

begin

    v_note := 'Controllo validitï¿¿arametri di input';

    if      p_id_dper                   is null
        or  p_cod_abi                   is null
        or  nvl(p_cod_gruppo_economico, p_cod_sndg) is null
        or  p_cod_stato_rischio         is null
    then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      =>      'Parametri di input non validi.ID_DPER = ' || p_id_dper
                                                    ||  ', COD_GRUPPO_ECONOMICO = ' || p_cod_gruppo_economico
                                                    ||  ', COD_SNDG = ' || p_cod_sndg
                                                    || ', COD_STATO_RISCHIO = ' || p_cod_stato_rischio,
                                    p_utente    => p_cod_utente
                                );
        return ko;

    end if;


    v_note := 'Check chiave primaria';

    select count(*)
    into v_count
    from t_mcres_app_top_30_nt_web
    where 0=0
        and id_dper = p_id_dper
        and cod_sndg = nvl(p_cod_sndg, p_cod_gruppo_economico);


    if v_count = 0
    then

        v_note := 'Insert';

        insert into t_mcres_app_top_30_nt_web
        (
            id_dper,
            cod_abi,
            cod_cli_ge,
            desc_cli_ge,
            cod_gruppo_economico,
            desc_gruppo_economico,
            cod_sndg,
            desc_cliente,
            cod_stato_rischio,
            dta_decorrenza_stato,
            val_gbv,
            val_nbv,
            val_vantato,
            val_garanzie_reali,
            val_garanzie_personali,
            cod_stato_giudirico_prev,
            dta_ins,
            dta_upd,
            cod_operatore_ins_upd

        )
        values
        (
            p_id_dper,
            p_cod_abi,
            nvl(p_cod_gruppo_economico, p_cod_sndg),
            nvl(p_desc_gruppo_economico, p_desc_cliente),
            p_cod_gruppo_economico,
            p_desc_gruppo_economico,
            nvl(p_cod_sndg, p_cod_gruppo_economico),
            p_desc_cliente,
            p_cod_stato_rischio,
            p_dta_decorrenza_stato,
            p_val_gbv,
            p_val_nbv,
            p_val_vantato,
            p_val_garanzie_reali,
            p_val_garanzie_personali,
            p_cod_stato_giudirico_prev,
            sysdate,
            sysdate,
            p_cod_utente
        );

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_debug,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      =>      'Inserito record.ID_DPER = ' || p_id_dper
                                                    ||  ', COD_GRUPPO_ECONOMICO = ' || p_cod_gruppo_economico
                                                    ||  ', COD_SNDG = ' || p_cod_sndg
                                                    ||  ', COD_STATO_RISCHIO = ' || p_cod_stato_rischio,
                                    p_utente    => p_cod_utente
                                );

    else

        v_note := 'Esiste';

--        update t_mcres_app_top_30_nt
--        set
--            val_gbv                     = nvl(p_val_gbv, val_gbv),
--            val_nbv                     = nvl(p_val_nbv, val_nbv),
--            val_vantato                 = nvl(p_val_vantato, val_vantato),
--            desc_nome_gruppo_cliente    = nvl(desc_nome_gruppo_cliente, p_desc_nome_gruppo_cliente),
--            val_garanzie_reali          = nvl( p_val_garanzie_reali, val_garanzie_reali),
--            val_garanzie_personali      = nvl( p_val_garanzie_personali, val_garanzie_personali),
--            dta_upd                     = sysdate,
--            cod_operatore_ins_upd       = nvl(p_cod_utente, cod_operatore_ins_upd)
--        where 0=0
--            and id_dper                 = p_id_dper
--            and cod_sndg_gruppo_cliente = p_cod_sndg_gruppo_cliente
--            and cod_stato_rischio       = p_cod_stato_rischio;

    update t_mcres_app_top_30_nt_web
    set
        cod_abi                  = nvl(p_cod_abi, cod_abi),
        cod_cli_ge               = coalesce(p_cod_gruppo_economico, cod_gruppo_economico, p_cod_sndg, p_cod_sndg, cod_cli_ge),
        desc_cli_ge              = coalesce(p_desc_gruppo_economico, desc_gruppo_economico, p_desc_cliente, desc_cliente, desc_cli_ge),
        cod_gruppo_economico     = nvl(p_cod_gruppo_economico, cod_gruppo_economico),
        desc_gruppo_economico    = nvl(p_desc_gruppo_economico, desc_gruppo_economico),
        desc_cliente             = nvl(p_desc_cliente, desc_cliente),
        cod_stato_rischio        = nvl(p_cod_stato_rischio, cod_stato_rischio),
        dta_decorrenza_stato     = nvl(p_dta_decorrenza_stato, dta_decorrenza_stato),
        val_gbv                  = nvl(p_val_gbv, val_gbv),
        val_nbv                  = nvl(p_val_nbv, val_nbv),
        val_vantato              = nvl(p_val_vantato, val_vantato),
        val_garanzie_reali       = nvl(p_val_garanzie_reali, val_garanzie_reali),
        val_garanzie_personali   = nvl(p_val_garanzie_personali, val_garanzie_personali),
        cod_stato_giudirico_prev = nvl(p_cod_stato_giudirico_prev, cod_stato_giudirico_prev),
        dta_upd                  = sysdate,
        cod_operatore_ins_upd    = nvl(p_cod_utente, cod_operatore_ins_upd),
        flg_inviato_QdC          = 0,
        dta_invio_QdC            = null
    where 0=0
        and id_dper = p_id_dper
        and cod_sndg = p_cod_sndg;


        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      =>      'Dato presente.ID_DPER = ' || p_id_dper
                                                    ||  ', COD_GRUPPO_ECONOMICO = ' || p_cod_gruppo_economico
                                                    ||  ', COD_SNDG = ' || p_cod_sndg
                                                    ||  ', COD_STATO_RISCHIO = ' || p_cod_stato_rischio,
                                    p_utente    => p_cod_utente
                                );

    end if;


    v_note := 'Gestione invio modifiche a QdC';

    select count(*)
    into v_count
    from qzt_st_mis_run
    where 0=0
        and id_dper = p_id_dper
        and cod_src = 'BD';

    if v_count = 0
    then

        insert into qzt_st_mis_run(id_dper, cod_src)
        values (p_id_dper, 'BD');

    end if;


    return ok;

exception
when others
then

        pkg_mcres_audit.log_app (
                                    p_proc      => c_nome,
                                    p_livello   => pkg_mcres_audit.c_error,
                                    p_sqlcode   => SQLCODE,
                                    p_mssg      => SQLERRM,
                                    p_note      => 'Generale ' || v_note,
                                    p_utente    => p_cod_utente
                                );

        return ko;

end;


function FNC_MCRES_UPDATE_DELIBERE_NS (
    P_REC IN F_SLAVE_PAR_TYPE
)return number
is

  c_nome constant       varchar2(100) := c_package || '.FNC_MCRES_UPDATE_DELIBERE_NS';
  v_note                t_mcre0_wrk_audit_applicativo.note%type := 'GENERALE';

begin
    v_note := 'Annullo automatico delibere NS';
    update  t_mcres_app_delibere b
    set cod_stato_delibera = 'AN',
         DTA_UPD = sysdate
    where cod_delibera = 'NS'
    and exists (
      select distinct 1
      from t_mcres_app_delibere a
      where cod_delibera in ('NZ','FZ')
      and A.COD_ABI = b.cod_abi
      and a.cod_ndg = b.cod_ndg
      and a.cod_protocollo_delibera = b.cod_protocollo_delibera
      and A.DTA_INSERIMENTO_DELIBERA >= A.DTA_INSERIMENTO_DELIBERA
    );
    commit;
    return ok;
exception
  when others then
      PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_REC.SEQ_FLUSSO,C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
     return ko;
end;


function fnc_set_od_calcolato_sp_spese
(
    p_cod_autorizzazione        in  t_mcres_app_sp_spese.cod_autorizzazione%type,
    p_cod_od_calcolato          in  t_mcres_app_sp_spese.cod_od_calcolato%type,
    p_cod_utente                in  t_mcres_app_sp_spese.cod_operatore_ins_upd%type
)
return number is


  c_nome constant       varchar2(100) := c_package || '.FNC_SET_OD_CALCOLATO_SP_SPESE';
  v_note                t_mcres_wrk_audit_applicativo.note%type;
  v_exists              number(1);


begin

    v_note := 'ControlloÂ  parametri input';
    if p_cod_autorizzazione is null
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: campo chiave nullo. COD_AUTORIZZAZIONE = '
                                                                                || p_cod_autorizzazione || 'COD_OD_CALCOLATO = '
                                                                                || p_cod_od_calcolato, p_cod_utente);
        return ko;
    end if;


    select count(*)
    into v_exists
    from t_mcres_app_sp_spese
    where cod_autorizzazione = p_cod_autorizzazione;

    if v_exists = 1
    then

        update t_mcres_app_sp_spese
        set
            cod_od_calcolato = p_cod_od_calcolato,
            dta_upd = sysdate,
            cod_operatore_ins_upd = p_cod_utente
        where 0=0
            and cod_autorizzazione = p_cod_autorizzazione;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,'Aggiornato organo deliberate calcolato. COD_AUTORIZZAZIONE = ' || p_cod_autorizzazione
                            || 'COD_OD_CALCOLATO = ' || p_cod_od_calcolato, p_cod_utente);

    else

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Delibera non presente. COD_AUTORIZZAZIONE = ' || p_cod_autorizzazione
                            || ' COD_OD_CALCOLATO = ' || p_cod_od_calcolato, p_cod_utente);

        return ko;


    end if;


    return ok;

exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_utente);
    return ko;
end;

function fnc_aggiorna_parametri_alert
(
    p_id_alert              in t_mcres_app_gestione_alert.id_alert%type,
    p_val_soglia_verde      in t_mcres_app_gestione_alert.val_next_green%type,
    p_val_soglia_arancio    in t_mcres_app_gestione_alert.val_next_orange%type,
    p_cod_utente            in t_mcres_wrk_audit_applicativo.utente%type,
    p_desc_alert            in t_mcres_app_alert_ruoli.desc_alert%type                  default null
)
return number is


  c_nome constant       varchar2(100) := c_package || '.FNC_AGGIORNA_PARAMETRI_ALERT';
  v_note                t_mcres_wrk_audit_applicativo.note%type;
  v_exists              number(1);


begin

    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'INIZIO', p_cod_utente);

    v_note := 'ControlloÂ valorizzazione id_alert input';

    if p_id_alert is null
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: ID_ALERT nullo.', p_cod_utente);
        return ko;
    end if;


    v_note := 'Controllo esistenza alert';

    select count(*)
    into v_exists
    from t_mcres_app_gestione_alert
    where id_alert = p_id_alert;

    if v_exists  = 0
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: ID_ALERT ' || p_id_alert || ' non censito.', p_cod_utente);
        return ko;
    end if;


    v_note := 'Controllo valorizzazione soglie';

    if nvl(p_val_soglia_verde, 0) = 0 or nvl(p_val_soglia_arancio, 0) = 0 or p_val_soglia_verde >= p_val_soglia_arancio
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: soglie non valorizzate correttamente. P_VAL_SOGLIA_VERDE = '
        || p_val_soglia_verde ||', P_VAL_SOGLIA_ARANCIO = ' || p_val_soglia_arancio, p_cod_utente);
        return ko;
    end if;


    v_note := 'Aggiornamento tabella di gestione';

    update t_mcres_app_gestione_alert
    set
        val_next_green          = p_val_soglia_verde,
        val_next_orange         = p_val_soglia_arancio,
        dta_upd                 = sysdate,
        cod_operatore_ins_upd   = p_cod_utente
    where id_alert = p_id_alert;

    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,'Aggiornamento soglie alert avvvenuto correttamente. ID_ALERT = ' || p_id_alert ,p_cod_utente);


    v_note := 'Aggiornamento tabella alert ruoli per modificare la descrizione dell''alert';

    if p_desc_alert is not null
    then

        update t_mcres_app_alert_ruoli
        set
            desc_alert = p_desc_alert
        where id_alert = p_id_alert;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,'Aggiornamento descizione alert avvvenuto correttamente',p_cod_utente);

    end if;

    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'FINE', p_cod_utente);

    return ok;

exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_utente);
    return ko;
end;


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
return number is


  c_nome constant       varchar2(100) := c_package || '.FNC_AGGIORNA_ISTITUTI';
  v_note                t_mcres_wrk_audit_applicativo.note%type;
  v_exists              number(1);


begin

    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'INIZIO', p_cod_utente);

    v_note := 'Controllo valorizzazione cod_abi input';

    if p_cod_abi is null
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: COD_ABI nullo.', p_cod_utente);
        return ko;
    end if;

    v_note := 'Controllo esistenza istituto';

    select count(*)
    into v_exists
    from t_mcres_app_istituti   -- considero solo gli istituti visibili all'applicativo
    where cod_abi = p_cod_abi;

    if v_exists = 0
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: Istituto ' || p_cod_abi || ' non censito', p_cod_utente);
        return ko;
    end if;


    v_note := 'Aggiornanamento tabella istituti';

    update t_mcre0_app_istituti_all
    set
        flg_outsourcing_drc     =  nvl(p_flg_outsourcing_drc,flg_outsourcing_drc),
        flg_servicing_itf       =  nvl(p_flg_servicing_itf,flg_servicing_itf),
        flg_cessione_rout       =  nvl(p_flg_cessione_rout,flg_cessione_rout),
        flg_tipo_abi            =  nvl(p_flg_tipo_abi,flg_tipo_abi),
        val_ordine              =  nvl(p_val_ordine,val_ordine),
        val_ind_struttura       =  nvl(p_val_ind_struttura,val_ind_struttura),
        val_struttura_cap       =  nvl(p_val_struttura_cap,val_struttura_cap),
        val_struttura_citta     =  nvl(p_val_struttura_citta,val_struttura_citta),
        val_struttura_provincia =  nvl(p_val_struttura_provincia,val_struttura_provincia),
        val_ind_sede_legale     =  nvl(p_val_ind_sede_legale,val_ind_sede_legale),
        val_sede_l_cap          =  nvl(p_val_sede_l_cap,val_sede_l_cap),
        val_sede_l_citta        =  nvl(p_val_sede_l_citta,val_sede_l_citta),
        val_sede_l_provincia    =  nvl(p_val_sede_l_provincia,val_sede_l_provincia)
    where 0=0
        and cod_abi = p_cod_abi;

    if p_flg_tipo_abi is not null
    then

        merge into t_mcre0_app_istituti_all t
        using t_mcres_cl_tipo_abi s
        on (t.cod_abi = p_cod_abi and s.cod_tipo_abi = t.flg_tipo_abi)
        when matched then update
        set
            t.desc_tipo_abi = s.desc_tipo_abi,
            t.val_ordine_tipo_abi = s.val_ordine_tipo_abi;

    end if;


    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,'Aggiornamento dati istituto avvenuto correttamente. COD_ABI = ' || p_cod_abi ||
                                ', FLG_OUTSOURCING_DRC     = ' || p_flg_outsourcing_drc    ||
                                ', FLG_CESSIONE_ROUT       = ' || p_flg_cessione_rout      ||
                                ', FLG_TIPO_ABI            = ' || p_flg_tipo_abi           ||
                                ', VAL_ORDINE              = ' || p_val_ordine             ||
                                ', VAL_IND_STRUTTURA       = ' || p_val_ind_struttura      ||
                                ', VAL_STRUTTURA_CAP       = ' || p_val_struttura_cap      ||
                                ', VAL_STRUTTURA_CITTA     = ' || p_val_struttura_citta    ||
                                ', VAL_STRUTTURA_PROVINCIA = ' || p_val_struttura_provincia||
                                ', VAL_IND_SEDE_LEGALE     = ' || p_val_ind_sede_legale    ||
                                ', VAL_SEDE_L_CAP          = ' || p_val_sede_l_cap         ||
                                ', VAL_SEDE_L_CITTA        = ' || p_val_sede_l_citta       ||
                                ', VAL_SEDE_L_PROVINCIA    = ' || p_val_sede_l_provincia   ||
                                ', FLG_SERVICING_ITF       = ' || p_flg_servicing_itf
                                , p_cod_utente);


    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'FINE', p_cod_utente);

    return ok;

exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_utente);
    return ko;
end;




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
return number is


  c_nome constant       varchar2(100) := c_package || '.FNC_POPOLA_CENTRI_COSTO';
  v_note                t_mcres_wrk_audit_applicativo.note%type;
  v_exists              number(1);


begin

    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'INIZIO', p_cod_utente);

    v_note := 'Controllo valorizzazione parametri input';

    if      p_cod_abi is null
        or p_val_spesa_rip is null
        or p_val_spesa_non_rip is null
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: COD_ABI = ' || p_cod_abi
                                ||', VAL_SPESA_RIP = ' || p_val_spesa_rip ||', VAL_SPESA_NON_RIP = ' || p_val_spesa_non_rip
                                || ', COD_UO = ' || nvl(p_cod_uo,'NULL') || ', FLG_ATTIVO = ' || p_flg_attivo,
                                p_cod_utente);
        return ko;
    end if;


    if p_cod_uo = 'ALL'
    then

        v_note := 'Aggiornamento centro costo, parametro cod_uo = ALL';

        update t_mcres_cnf_fatture_sap
        set
            val_spesa_rip       = p_val_spesa_rip,
            val_spesa_non_rip   = p_val_spesa_non_rip,
            val_cdc_banca       = p_val_cdc_banca,
            val_cdc_itf         = p_val_cdc_itf,
            flg_attivo          = p_flg_attivo
        where cod_abi = p_cod_abi;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Aggiornato centro costo: COD_ABI = ' || p_cod_abi
                                ||', VAL_SPESA_RIP = ' || p_val_spesa_rip ||', VAL_SPESA_NON_RIP = ' || p_val_spesa_non_rip
                                || ', COD_UO = ' || nvl(p_cod_uo,'NULL') || ', FLG_ATTIVO = ' || p_flg_attivo,
                                p_cod_utente);
    else

        v_note := 'Controllo esistenza centro costo';

        select count(*)
        into v_exists
        from t_mcres_cnf_fatture_sap
        where 0=0
            and cod_abi = p_cod_abi
            and nvl(cod_uo, 'DEFAULT') = nvl(p_cod_uo, 'DEFAULT');


        if v_exists = 0
        then

             v_note := 'Inseriemento centro costo singola UO';

            insert into t_mcres_cnf_fatture_sap
            (
                cod_abi,
                cod_uo,
                val_spesa_rip,
                val_spesa_non_rip,
                val_cdc_banca,
                val_cdc_itf,
                flg_attivo
            )
            values
            (
                p_cod_abi,
                p_cod_uo,
                p_val_spesa_rip,
                p_val_spesa_non_rip,
                p_val_cdc_banca,
                p_val_cdc_itf,
                nvl(p_flg_attivo, 1)
            );

            pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Inserito centro costo: COD_ABI = ' || p_cod_abi
                                    ||', VAL_SPESA_RIP = ' || p_val_spesa_rip ||', VAL_SPESA_NON_RIP = ' || p_val_spesa_non_rip
                                    || ', COD_UO = ' || nvl(p_cod_uo,'NULL') || ', FLG_ATTIVO = ' || p_flg_attivo,
                                    p_cod_utente);

        else

            v_note := 'Aggiornamento centro costo singola UO';

            update t_mcres_cnf_fatture_sap
            set
                val_spesa_rip       = p_val_spesa_rip,
                val_spesa_non_rip   = p_val_spesa_non_rip,
                val_cdc_banca       = p_val_cdc_banca,
                val_cdc_itf         = p_val_cdc_itf,
                flg_attivo          = nvl(p_flg_attivo, flg_attivo)
            where 0=0
                and cod_abi = p_cod_abi
                and nvl(cod_uo, 'DEFAULT') = nvl(p_cod_uo, 'DEFAULT');

            pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Aggiornato centro costo: COD_ABI = ' || p_cod_abi
                                    ||', VAL_SPESA_RIP = ' || p_val_spesa_rip ||', VAL_SPESA_NON_RIP = ' || p_val_spesa_non_rip
                                    || ', COD_UO = ' || nvl(p_cod_uo,'NULL') || ', FLG_ATTIVO = ' || p_flg_attivo,
                                    p_cod_utente);


        end if;


    end if;

    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'FINE', p_cod_utente);

    return ok;


exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_utente);
    return ko;
end;

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
return number is


  c_nome constant       varchar2(100) := c_package || '.FNC_POPOLA_ORGANI_DELIBERANTI';
  v_note                t_mcres_wrk_audit_applicativo.note%type;
  v_exists              number(1);


begin

    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'INIZIO', p_cod_utente);

    v_note := 'Controllo valorizzazione parametri input';

    if     p_cod_abi is null
        or p_cod_uo is null
        or p_cod_od is null
        or p_dta_inizio is null
        or p_dta_scadenza is null
        or p_dta_inizio > p_dta_scadenza
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi. COD_ABI = ' || p_cod_abi
                                ||', COD_UO = ' || p_cod_uo ||', COD_OD = ' || p_cod_od ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd')
                                ||', DTA_SCADENZA = ' || to_char(p_dta_inizio_upd, 'yyyymmdd'),p_cod_utente);
        return ko;
    end if;



    v_note := 'Gestione operazioni';

    case p_cod_operazione
    when 'I' then


        v_note := 'Controllo esistenza organo deliberante - Insert';

        select count(*)
        into v_exists
        from t_mcres_cl_organo_deliberante
        where 0=0
            and cod_abi = p_cod_abi
            and cod_uo = p_cod_uo
            and cod_organo_deliberante = p_cod_od
            and dta_inizio = p_dta_inizio;

        if v_exists = 0
        then


            v_note := 'Controllo intervallo date - Insert';

            select count(*)
            into v_exists
            from
            (
                select
                    dta_inizio,
                    dta_scadenza,
                    lead(dta_inizio) over(order by dta_inizio) dta_lead --per ultima riga null ma l'ultima riga non deve essere controllata
                from
                    (
                        select
                            trunc(dta_inizio) dta_inizio,
                            trunc(dta_scadenza) dta_scadenza
                        from
                            t_mcres_cl_organo_deliberante
                        where 0=0
                            and cod_abi = p_cod_abi
                            and cod_uo = p_cod_uo
                            and cod_organo_deliberante = p_cod_od
                        union all
                        select
                            trunc(p_dta_inizio) dta_inizio,
                            trunc(p_dta_scadenza) dta_scadenza
                        from dual
                    )
            )
            where dta_scadenza > dta_lead;

            if v_exists > 0
            then

                pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Errore in fasi di inserimento. Intervallo date non valido. COD_ABI = ' || p_cod_abi
                                        ||', COD_UO = ' || p_cod_uo ||', COD_OD = ' || p_cod_od ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd')
                                        ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd') ||', DESC_ORGANO_DELIBERANTE = '
                                        || p_desc_od || ', DESC_RESPONSABILE = ' || p_desc_responsabile,
                                        p_cod_utente);

                return ko;

            end if;


            v_note := 'Inserimento organo deliberante';

            insert into t_mcres_cl_organo_deliberante
            (
                cod_abi,
                cod_istituto,
                cod_uo,
                cod_organo_deliberante,
                desc_organo_deliberante,
                dta_inizio,
                dta_scadenza,
                desc_responsabile
            )
            values
            (
                p_cod_abi,
                p_cod_istituto,
                p_cod_uo,
                p_cod_od,
                p_desc_od,
                p_dta_inizio,
                p_dta_scadenza,
                p_desc_responsabile
            );

            pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Inserito oragano deliberante. COD_ABI = ' || p_cod_abi
                                    ||', COD_UO = ' || p_cod_uo ||', COD_OD = ' || p_cod_od ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd')
                                    ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd') ||', DESC_ORGANO_DELIBERANTE = '
                                    || p_desc_od || ', DESC_RESPONSABILE = ' || p_desc_responsabile,
                                    p_cod_utente);
        else

            pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Inserimento non riuscito per violazione di chiave primaria. COD_ABI = ' || p_cod_abi
                                    ||', COD_UO = ' || p_cod_uo ||', COD_OD = ' || p_cod_od ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd')
                                    ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd') ||', DESC_ORGANO_DELIBERANTE = '
                                    || p_desc_od || ', DESC_RESPONSABILE = ' || p_desc_responsabile,
                                    p_cod_utente);

            return ko;

        end if;

    when 'U' then

        v_note := 'Controllo parametri input - update';

        if p_dta_inizio_upd is null -- gli altri campi sono stati controllati in testa
        then
            pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi. COD_ABI = ' || p_cod_abi
                                    ||', COD_UO = ' || p_cod_uo ||', COD_OD = ' || p_cod_od ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd')
                                    ||', DTA_INIZIO_UPD = ' || to_char(p_dta_inizio_upd, 'yyyymmdd'),p_cod_utente);
            return ko;
        end if;


        v_note := 'Controllo esistenza oragano deliberante - update';

        select count(*)
        into v_exists
        from t_mcres_cl_organo_deliberante
        where 0=0
            and cod_abi = p_cod_abi
            and cod_uo = p_cod_uo
            and cod_organo_deliberante = p_cod_od
            and dta_inizio = p_dta_inizio;

        if v_exists = 0
        then
            pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Organo deliberante da aggiornare non esitente. COD_ABI = ' || p_cod_abi
                                    ||', COD_UO = ' || p_cod_uo ||', COD_OD = ' || p_cod_od ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd')
                                    ||', DTA_INIZIO_UPD = ' || to_char(p_dta_inizio_upd, 'yyyymmdd'),p_cod_utente);
            return ko;

        end if;


        v_note := 'Controllo intervallo date - update';

        select count(*)
        into v_exists
        from
        (
            select
                dta_inizio,
                dta_scadenza,
                lead(dta_inizio) over(order by dta_inizio) dta_lead
            from
                (
                    select
                        trunc(dta_inizio) dta_inizio,
                        trunc(dta_scadenza) dta_scadenza
                    from
                        t_mcres_cl_organo_deliberante
                    where 0=0
                        and cod_abi = p_cod_abi
                        and cod_uo = p_cod_uo
                        and cod_organo_deliberante = p_cod_od
                        and dta_inizio != p_dta_inizio      -- non cosidero il vecchio record nella nuova configurazione
                    union all
                    select
                        trunc(p_dta_inizio_upd) dta_inizio, -- nuova data inizio
                        trunc(p_dta_scadenza) dta_scadenza
                    from dual
                )
        )
        where dta_scadenza > dta_lead;

        if v_exists > 0
        then

            pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Errore in fasi di inserimento. Intervallo date non valido. COD_ABI = ' || p_cod_abi
                                    ||', COD_UO = ' || p_cod_uo ||', COD_OD = ' || p_cod_od ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd')
                                    ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd') ||', DESC_ORGANO_DELIBERANTE = '
                                    || p_desc_od || ', DESC_RESPONSABILE = ' || p_desc_responsabile,
                                    p_cod_utente);

            return ko;

        end if;

        v_note := 'Update';

        update t_mcres_cl_organo_deliberante
        set
            cod_istituto = nvl(p_cod_istituto, cod_istituto),
            desc_organo_deliberante = nvl(p_desc_od, desc_organo_deliberante),
            dta_inizio = p_dta_inizio_upd,
            dta_scadenza = p_dta_scadenza,
            desc_responsabile = p_desc_responsabile
        where 0=0
            and cod_abi = p_cod_abi
            and cod_uo = p_cod_uo
            and cod_organo_deliberante = p_cod_od
            and dta_inizio = p_dta_inizio;

        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Aggiornato oragano deliberante. COD_ABI = ' || p_cod_abi
                                ||', COD_UO = ' || p_cod_uo ||', COD_OD = ' || p_cod_od ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd')
                                ||', DTA_INIZIO = ' || to_char(p_dta_inizio, 'yyyymmdd') ||', DESC_ORGANO_DELIBERANTE = '
                                || p_desc_od || ', DESC_RESPONSABILE = ' || p_desc_responsabile,
                                p_cod_utente);


    else

        pkg_mcres_audit.log_app(c_nome, pkg_mcres_audit.c_error, sqlcode,sqlerrm, 'Codice operazione non valido: ' || p_cod_operazione, p_cod_utente);

    end case;


    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'FINE', p_cod_utente);

    return ok;


exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_utente);
    return ko;
end;


function fnc_gestione_scadenzario
(
    p_cod_tipo_scadenza         in t_mcres_app_scadenzario.cod_tipo_scadenza%type,
    p_val_gg_succ_new           in t_mcres_app_scadenzario.val_gg_succ_new%type,
    p_val_gg_prec_new           in t_mcres_app_scadenzario.val_gg_prec_new%type,
    p_val_limite_scadenza_new   in t_mcres_app_scadenzario.val_limite_scadenza_new%type,
    p_cod_utente                in t_mcres_wrk_audit_applicativo.utente%type
)
return number is


  c_nome constant       varchar2(100) := c_package || '.FNC_GESTIONE_SCADENZARIO';
  v_note                t_mcres_wrk_audit_applicativo.note%type;
  v_exists              number(1);


begin

    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'INIZIO', p_cod_utente);

    v_note := 'Controllo valorizzazione cod_tipo_scadenza input';

    if p_cod_tipo_scadenza is null
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: COD_TIPO_SCADENZA nullo.', p_cod_utente);
        return ko;
    end if;


    v_note := 'Controllo valorizzazione parametri input';

    if  p_val_gg_prec_new is null or p_val_gg_succ_new is null or p_val_limite_scadenza_new is null
        or p_val_gg_prec_new = 0 or p_val_gg_succ_new = 0 or p_val_limite_scadenza_new = 0
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi. COD_TIPO_SCADENZA = ' || p_cod_tipo_scadenza ||
                            ', VAL_GG_SUCC_NEW              = ' || p_val_gg_succ_new    ||
                            ', VAL_GG_PREC_NEW              = ' || p_val_gg_prec_new    ||
                            ', VAL_LIMITE_SCADENZA_NEW      = ' || p_val_limite_scadenza_new
                            , p_cod_utente);
        return ko;
    end if;

    v_note := 'Controllo esistenza voce scadenzario';

    select count(*)
    into v_exists
    from t_mcres_app_scadenzario   -- considero solo gli istituti visibili all'applicativo
    where cod_tipo_scadenza = p_cod_tipo_scadenza;

    if v_exists = 0
    then
        pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'Parametri di input non validi: cod_tipo_scadenza ' || p_cod_tipo_scadenza || ' non censito', p_cod_utente);
        return ko;
    end if;


    v_note := 'Aggiornanamento tabella istituti';

    update t_mcres_app_scadenzario
    set
        val_gg_succ_new         = nvl(p_val_gg_succ_new, val_gg_succ_new),
        val_gg_prec_new         = nvl(p_val_gg_prec_new, val_gg_prec_new),
        val_limite_scadenza_new = nvl(p_val_limite_scadenza_new, val_limite_scadenza_new),
        dta_upd                 = sysdate,
        cod_operatore_ins_upd   = p_cod_utente
    where 0=0
        and cod_tipo_scadenza = p_cod_tipo_scadenza;


    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_debug,sqlcode,sqlerrm,'Aggiornamento dati scadenzario avvenuto correttamente. COD_TIPO_SCADENZA = ' || p_cod_tipo_scadenza ||
                                ', VAL_GG_SUCC_NEW              = ' || p_val_gg_succ_new    ||
                                ', VAL_GG_PREC_NEW              = ' || p_val_gg_prec_new    ||
                                ', VAL_LIMITE_SCADENZA_NEW      = ' || p_val_limite_scadenza_new
                                , p_cod_utente);


    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,'FINE', p_cod_utente);

    return ok;

exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_utente);
    return ko;
end;


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
)
return number is


  c_nome constant       varchar2(100) := c_package || '.FNC_GESTIONE_PROROGHE';
  v_note                t_mcres_wrk_audit_applicativo.note%type;
  v_exists              number(1);


begin

    v_note := 'Controllo esistenza proroga - ABI='||p_cod_abi||' PROTOCOLLO='||p_cod_protocollo||' DTA_ISRT='||p_dta_isrt_proroga;
    select count(*)
    into v_exists
    from t_mcres_app_proroghe
    where cod_abi = p_cod_abi
    and cod_protocollo = p_cod_protocollo
    and dta_isrt_proroga = p_dta_isrt_proroga;

    if v_exists = 0  then
        v_note := 'Insert proroga - ABI='||p_cod_abi||' PROTOCOLLO='||p_cod_protocollo||' DTA_ISRT='||p_dta_isrt_proroga;
        insert into t_mcres_app_proroghe
        (
            COD_ABI,
            COD_PROTOCOLLO,
            DTA_ISRT_PROROGA,
            DTA_PROROGA,
            COD_STATO_PROROGA,
            VAL_NOTE_PROROGA,
            COD_ORG_DELIB_PROROGA,
            DTA_AGGIORN,
            VAL_TIMESTAMP_AGG_TAB,
            COD_OPERATORE_INS_UPD,
            DTA_INS,
            VAL_COMM_ESTESO
        )values(
            p_COD_ABI,
            p_COD_PROTOCOLLO,
            p_DTA_ISRT_PROROGA,
            p_DTA_PROROGA,
            p_COD_STATO_PROROGA,
            p_VAL_NOTE_PROROGA,
            p_COD_ORG_DELIB_PROROGA,
            p_DTA_AGGIORN,
            p_VAL_TIMESTAMP_AGG_TAB,
            p_cod_utente,
            sysdate,
            p_commento_esteso
        );
    else
        v_note := 'Update proroga - ABI='||p_cod_abi||' PROTOCOLLO='||p_cod_protocollo||' DTA_ISRT='||p_dta_isrt_proroga;
        update  t_mcres_app_proroghe
        set
            DTA_PROROGA =p_DTA_PROROGA,
            COD_STATO_PROROGA = p_COD_STATO_PROROGA,
            VAL_NOTE_PROROGA = p_VAL_NOTE_PROROGA,
            COD_ORG_DELIB_PROROGA = p_VAL_NOTE_PROROGA,
            DTA_AGGIORN = p_DTA_AGGIORN,
            VAL_TIMESTAMP_AGG_TAB = p_VAL_TIMESTAMP_AGG_TAB,
            COD_OPERATORE_INS_UPD = p_cod_utente,
            DTA_upd = sysdate,
            VAL_COMM_ESTESO = p_commento_esteso
        where COD_ABI = p_COD_ABI
        and    COD_PROTOCOLLO = p_COD_PROTOCOLLO
        and    DTA_ISRT_PROROGA = p_DTA_ISRT_PROROGA;
    end if;

    return ok;

exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_utente);
    return ko;
end;

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
return number is


  c_nome constant       varchar2(100) := c_package || '.FNC_GESTIONE_RAPP_DELIBERE';
  v_note                t_mcres_wrk_audit_applicativo.note%type;
  v_exists              number(1);


begin

    v_note := 'Controllo esistenza rapporto delibera - ABI='||p_cod_abi||' PROTOCOLLO='||p_cod_protocollo||' UO_CNTRT='||p_cod_uo_cntrt||' PROD_CNTRT='||p_cod_prod_cntrt;
    select count(*)
    into v_exists
    from t_mcres_app_rapporti_delibere
    where cod_abi = p_cod_abi
    and cod_protocollo = p_cod_protocollo
    and cod_uo_cntrt = p_cod_uo_cntrt
    and cod_prod_cntrt = p_cod_prod_cntrt
    and val_num_id_cntrt = p_val_num_id_cntrt;

    if v_exists = 0  then
        v_note := 'Insert rapporto delibera - ABI='||p_cod_abi||' PROTOCOLLO='||p_cod_protocollo||' UO_CNTRT='||p_cod_uo_cntrt||' PROD_CNTRT='||p_cod_prod_cntrt;
        insert into t_mcres_app_rapporti_delibere
        (
            COD_ABI,
            COD_PROTOCOLLO,
            cod_uo_cntrt            ,
            cod_prod_cntrt         ,
            val_num_id_cntrt       ,
            flg_ins_man            ,
            dta_agg_rapp           ,
            val_imp_utiliz         ,
            val_imp_esp_qc         ,
            val_imp_int_mora       ,
            val_debito_res         ,
            val_qc_sisba           ,
            val_imp_vantato        ,
            val_imp_utiliz_mod     ,
            val_imp_vantato_mod    ,
            val_imp_operaz         ,
            val_imp_qc_operaz      ,
            val_ind_contabil       ,
            cod_filiale_pv         ,
            flg_selez               ,
            val_STR_FISCQTA_CAP  ,
            val_STR_FISCQTA_INT   ,
            val_QT_INT_MOR_ANRIS  ,
            val_CUI_RATEO_MORA  ,
            val_ATTUALIZ   ,
            cod_NSG_CART_SISBA ,
            DESC_CART_SISBA ,
            cod_ABI_CART_SISBA ,
            cod_ndg ,
            COD_OPERATORE_INS_UPD,
            DTA_INS
        )values(
            p_COD_ABI,
            p_COD_PROTOCOLLO,
              p_cod_uo_cntrt                        ,
           p_cod_prod_cntrt         ,
           p_val_num_id_cntrt       ,
           p_flg_ins_man            ,
           p_dta_agg_rapp           ,
           p_val_imp_utiliz         ,
           p_val_imp_esp_qc         ,
           p_val_imp_int_mora       ,
           p_val_debito_res         ,
           p_val_qc_sisba           ,
           p_val_imp_vantato        ,
           p_val_imp_utiliz_mod     ,
           p_val_imp_vantato_mod    ,
           p_val_imp_operaz         ,
           p_val_imp_qc_operaz      ,
           p_val_ind_contabil       ,
           p_cod_filiale_pv         ,
           p_flg_selez               ,
            p_val_STR_FISCQTA_CAP  ,
            p_val_STR_FISCQTA_INT   ,
            p_val_QT_INT_MOR_ANRIS  ,
            p_val_CUI_RATEO_MORA  ,
            p_val_ATTUALIZ   ,
            p_cod_NSG_CART_SISBA ,
            p_DESC_CART_SISBA ,
            p_cod_ABI_CART_SISBA ,
            p_cod_ndg ,
            p_cod_utente,
            sysdate
        );
    else
        v_note := 'Update rapporto delibera - ABI='||p_cod_abi||' PROTOCOLLO='||p_cod_protocollo||' UO_CNTRT='||p_cod_uo_cntrt||' PROD_CNTRT='||p_cod_prod_cntrt;
        update  t_mcres_app_rapporti_delibere
        set
              cod_uo_cntrt                         =        p_cod_uo_cntrt                        ,
              cod_prod_cntrt            =        p_cod_prod_cntrt         ,
              val_num_id_cntrt          =        p_val_num_id_cntrt       ,
              flg_ins_man               =        p_flg_ins_man            ,
              dta_agg_rapp              =        p_dta_agg_rapp           ,
              val_imp_utiliz            =        p_val_imp_utiliz         ,
              val_imp_esp_qc            =        p_val_imp_esp_qc         ,
              val_imp_int_mora          =        p_val_imp_int_mora       ,
              val_debito_res            =        p_val_debito_res         ,
              val_qc_sisba              =        p_val_qc_sisba           ,
              val_imp_vantato           =        p_val_imp_vantato        ,
              val_imp_utiliz_mod        =        p_val_imp_utiliz_mod     ,
              val_imp_vantato_mod       =        p_val_imp_vantato_mod    ,
              val_imp_operaz            =        p_val_imp_operaz         ,
              val_imp_qc_operaz         =        p_val_imp_qc_operaz      ,
              val_ind_contabil          =        p_val_ind_contabil       ,
              cod_filiale_pv            =        p_cod_filiale_pv         ,
              flg_selez                 =        p_flg_selez                ,
              val_STR_FISCQTA_CAP  =                    p_val_STR_FISCQTA_CAP  ,
            val_STR_FISCQTA_INT   =         p_val_STR_FISCQTA_INT   ,
            val_QT_INT_MOR_ANRIS  =         p_val_QT_INT_MOR_ANRIS  ,
            val_CUI_RATEO_MORA  =           p_val_CUI_RATEO_MORA  ,
            val_ATTUALIZ   =                p_val_ATTUALIZ   ,
            cod_NSG_CART_SISBA =            p_cod_NSG_CART_SISBA ,
            DESC_CART_SISBA =               p_DESC_CART_SISBA ,
            cod_ABI_CART_SISBA =            p_cod_ABI_CART_SISBA ,
            cod_ndg =                       p_cod_ndg ,
            COD_OPERATORE_INS_UPD = p_cod_utente,
            DTA_upd = sysdate
        where cod_abi = p_cod_abi
        and cod_protocollo = p_cod_protocollo
        and cod_uo_cntrt = p_cod_uo_cntrt
        and cod_prod_cntrt = p_cod_prod_cntrt
        and val_num_id_cntrt = p_val_num_id_cntrt;
    end if;

    return ok;

exception
  when others then
    pkg_mcres_audit.log_app(c_nome,pkg_mcres_audit.c_error,sqlcode,sqlerrm,v_note,p_cod_utente);
    return ko;
end;

function FNC_SET_DTA_ATTESA_ITF (
  P_COD_ABI T_MCRES_APP_SPESE_ITF.COD_ABI%type,
  P_COD_FISCALE T_MCRES_APP_SPESE_ITF.VAL_AFAVORE_CODFISC%type,
  P_PIVA T_MCRES_APP_SPESE_ITF.VAL_AFAVORE_PIVA%type,
  P_COD_UTENTE T_MCRES_APP_SPESE_ITF.COD_OPERATORE_INS_UPD%type,
  P_MOD VARCHAR2)  RETURN NUMBER
IS
  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_SET_DTA_ATTESA_ITF';
  V_NOTE VARCHAR2(1000)           :='GENERALE';

begin

  V_NOTE:='Valorizzazione DTA_ATTESA in T_MCRES_APP_SPESE_ITF per COD_ABI ' || P_COD_ABI || 'e COD_FISC/PIVA ' || P_COD_FISCALE || '/' || P_PIVA;

  update T_MCRES_APP_SPESE_ITF A
  set A.DTA_ATTESA = CASE WHEN P_MOD = 'A' THEN SYSDATE
                          WHEN P_MOD = 'R' THEN NULL
                          ELSE TO_DATE('01/01/1900','DD/MM/YYYY') END,
      A.COD_OPERATORE_INS_UPD = P_COD_UTENTE
  where 1 = 1
  and A.FLG_FORNITORE_NON_CENSITO != 0
  and exists (select 1 from dual
                        where P_COD_ABI = A.COD_ABI
                          AND P_COD_FISCALE = A.VAL_AFAVORE_CODFISC
                          AND P_COD_FISCALE IS NOT NULL
                          AND A.VAL_AFAVORE_CODFISC IS NOT NULL
                        UNION
              select 1 from dual
                        where P_COD_ABI = A.COD_ABI
                          AND P_PIVA = A.VAL_AFAVORE_PIVA
                          AND P_PIVA IS NOT NULL
                          AND A.VAL_AFAVORE_PIVA IS NOT NULL);

  return OK;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_COD_UTENTE);
    return KO;
end FNC_SET_DTA_ATTESA_ITF;

function fnc_chk_interf_sap(
    p_id_regola t_mcres_app_chk_interf_sap.id_regola%type,
    p_cod_autorizzazione t_mcres_app_sp_spese.cod_autorizzazione%type
)return number IS
  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_CHK_INTERF_SAP';
  V_NOTE VARCHAR2(1000)           :='GENERALE';
  v_esito number(1):=0;
  v_qry t_mcres_app_chk_interf_sap.val_qry%type;

begin

  V_NOTE:='Esistenza regola ' || p_id_regola || ' - SPESA ' || p_cod_autorizzazione;

  begin
      select val_qry
      into v_qry
      from t_mcres_app_chk_interf_sap a
      where id_regola = p_id_regola
      and flg_attiva = 1;
   exception
    when no_data_found then
       v_qry:= null;
    when others then
        PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,'INTERF_SAP');
  end;

  if(v_qry is not null)then
      V_NOTE:='Esecuzione regola ' || p_id_regola || ' - SPESA ' || p_cod_autorizzazione;
      execute immediate v_qry into v_esito using p_cod_autorizzazione ;
  end if;

return v_esito;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,'INTERF_SAP');
    v_esito:=0;
    return v_esito;
end fnc_chk_interf_sap;

function fnc_pag_sap_inviato_itf return number IS
  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_PAG_SAP_INVIATO_ITF';
  V_NOTE VARCHAR2(1000)           :='GENERALE';

begin

  V_NOTE:='Update flg spese pag_sap inviate ITF ';

  update t_mcres_app_pag_sap
  set flg_inviato_itf = 1,
        dta_inviato_itf = sysdate
  where cod_autorizzazione in (
        select cod_autorizzazione
        from V_MCRES_APP_PAG_SAP_FILE f);
   commit;

   update t_mcres_app_pag_sap a
   set flg_inviato_itf = 9,
        dta_inviato_itf = sysdate
   where  EXISTS
                 (SELECT DISTINCT 1
                    FROM t_mcres_app_sp_spese s
                   WHERE s.cod_autorizzazione = a.cod_autorizzazione
                         AND flg_source != 'ITF');
    commit;



return OK;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,'SAP_ITF');
   return KO;
end fnc_pag_sap_inviato_itf;

function fnc_esiti_sap_inviato_itf return number IS
  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_ESITI_SAP_INVIATO_ITF';
  V_NOTE VARCHAR2(1000)           :='GENERALE';

begin

  V_NOTE:='Update flg spese esiti_sap inviate ITF ';

  update t_mcres_app_esiti_sap
  set flg_inviato_itf = 1,
        dta_inviato_itf = sysdate
  where cod_autorizzazione in (
        select cod_autorizzazione
        from V_MCRES_APP_esiti_SAP_FILE f);
   commit;

   update t_mcres_app_esiti_sap a
   set flg_inviato_itf = 9,
        dta_inviato_itf = sysdate
   where  EXISTS
                 (SELECT DISTINCT 1
                    FROM t_mcres_app_sp_spese s
                   WHERE s.cod_autorizzazione = a.cod_autorizzazione
                         AND flg_source != 'ITF');
    commit;

return OK;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,'ESITI_SAP_ITF');
   return KO;
end fnc_esiti_sap_inviato_itf;

function fnc_statowi_sap_inviato_itf return number IS
  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_STATOWI_SAP_INVIATO_ITF';
  V_NOTE VARCHAR2(1000)           :='GENERALE';

begin

  V_NOTE:='Update flg spese statowi_sap inviate ITF ';

  update t_mcres_app_statowi_sap
  set flg_inviato_itf = 1,
        dta_inviato_itf = sysdate
  where cod_autorizzazione in (
        select cod_autorizzazione
        from V_MCRES_APP_statowi_SAP_FILE f);
   commit;

  update t_mcres_app_statowi_sap a
   set flg_inviato_itf = 9,
        dta_inviato_itf = sysdate
   where  EXISTS
                 (SELECT DISTINCT 1
                    FROM t_mcres_app_sp_spese s
                   WHERE s.cod_autorizzazione = a.cod_autorizzazione
                         AND flg_source != 'ITF');
    commit;

return OK;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,'STATOWI_SAP_ITF');
   return KO;
end fnc_statowi_sap_inviato_itf;
--


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
) return number is

  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_ACCENSIONE_SOFF';
  V_NOTE VARCHAR2(1000) := 'GENERALE';

begin

IF (P_FLG_OPERAZ = 'ADD') THEN

INSERT INTO T_MCRES_APP_ACC_SOFF (
  ID,
  COD_ABI,
  COD_NDG,
  COD_FILIALE,
  COD_RAPPORTO_ORIG,
  COD_TIPO_SOFF,
  VAL_NUMERO_SOFF,
  FLG_AGEVOLATO,
  COD_TIPO_CONTROPART,
  FLG_EX_REVOC,
  VAL_TASSO_MORA,
  VAL_SPREAD,
  VAL_VALORE_AT,
  VAL_TASSO_ATTUALIZZAZIONE,
  VAL_IMPORTO_CAPITALE,
  DTA_VALUTA_CAPITALE,
  VAL_INTERESSI_ORIGINARI,
  DTA_VALUTA_INTERESSI,
  MATR_INS,
  COD_FILIALE_OPER)
VALUES (
  P_ID,
  P_COD_ABI,
  P_COD_NDG,
  P_COD_FILIALE,
  P_COD_RAPPORTO_ORIG,
  P_COD_TIPO_SOFF,
  P_VAL_NUMERO_SOFF,
  P_FLG_AGEVOLATO,
  P_COD_TIPO_CONTROPART,
  P_FLG_EX_REVOC,
  P_VAL_TASSO_MORA,
  P_VAL_SPREAD,
  P_VAL_VALORE_AT,
  P_VAL_TASSO_ATTUALIZZAZIONE,
  P_VAL_IMPORTO_CAPITALE,
  P_DTA_VALUTA_CAPITALE,
  P_VAL_INTERESSI_ORIGINARI,
  P_DTA_VALUTA_INTERESSI,
  P_MATRICOLA,
  P_COD_FILIALE_OPER
);

V_NOTE:='Inserito rapporto id: ' || P_ID || ', cod_abi: ' || P_COD_ABI || ', cod_ndg: ' || P_COD_NDG || ', cod_rapporto_orig: ' || P_COD_RAPPORTO_ORIG;
PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);

return ok;

END IF;

IF (P_FLG_OPERAZ = 'CANC') THEN

UPDATE T_MCRES_APP_ACC_SOFF
SET FLG_CANCEL = 1,
DTA_CANCEL = SYSDATE,
MATR_CANC = P_MATRICOLA
WHERE ID = P_ID;

UPDATE T_MCRES_APP_GIRO_INT_ORIG
SET FLG_CANCEL = 1,
DTA_CANCEL = SYSDATE,
MATR_CANC = P_MATRICOLA
WHERE ID = (SELECT VAL_KEYMO02 FROM T_MCRES_APP_ACC_SOFF WHERE ID = P_ID);

V_NOTE:='Annullato rapporto id: ' || P_ID || ', cod_abi: ' || P_COD_ABI || ', cod_ndg: ' || P_COD_NDG || ', cod_rapporto_orig: ' || P_COD_RAPPORTO_ORIG;
PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);

return ok;

END IF;

V_NOTE:='Flag operazione non corretto';
PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);

return ko;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);
return ko;

end fnc_accensione_soff;

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
) return number is

  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MOVIMENTO_DA_VOLTURARE';
  V_NOTE VARCHAR2(1000) := 'GENERALE';
  v_keymo02 T_MCRES_APP_ACC_SOFF.VAL_KEYMO02%type;

begin

IF (P_FLG_OPERAZ = 'ADD') THEN

BEGIN

SELECT VAL_KEYMO02
INTO v_keymo02
FROM T_MCRES_APP_ACC_SOFF
WHERE VAL_NUMERO_SOFF = P_VAL_NUMERO_SOFF
AND FLG_CANCEL = 0;

EXCEPTION
    WHEN NO_DATA_FOUND THEN

    V_NOTE:='Val numero soff NON TROVATO in T_MCRES_APP_ACC_SOFF';
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_WARNING,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);

END;

INSERT INTO T_MCRES_APP_GIRO_INT_ORIG (
  ID,
  COD_ABI,
  COD_NDG,
  COD_FILIALE,
  COD_RAPPORTO_ORIG,
  COD_TIPO_SOFF,
  VAL_NUMERO_SOFF,
  FLG_AGEVOLATO,
  COD_TIPO_CONTROPART,
  FLG_EX_REVOC,
  VAL_TASSO_MORA,
  VAL_SPREAD,
  VAL_VALORE_AT,
  VAL_TASSO_ATTUALIZZAZIONE,
  VAL_IMPORTO_CAPITALE,
  DTA_VALUTA_CAPITALE,
  VAL_INTERESSI_ORIGINARI,
  DTA_VALUTA_INTERESSI,
  MATR_INS,
  COD_FILIALE_OPER)
VALUES (
  P_ID,
  P_COD_ABI,
  P_COD_NDG,
  P_COD_FILIALE,
  P_COD_RAPPORTO_ORIG,
  P_COD_TIPO_SOFF,
  P_VAL_NUMERO_SOFF,
  P_FLG_AGEVOLATO,
  P_COD_TIPO_CONTROPART,
  P_FLG_EX_REVOC,
  P_VAL_TASSO_MORA,
  P_VAL_SPREAD,
  P_VAL_VALORE_AT,
  P_VAL_TASSO_ATTUALIZZAZIONE,
  P_VAL_IMPORTO_CAPITALE,
  P_DTA_VALUTA_CAPITALE,
  P_VAL_INTERESSI_ORIGINARI,
  P_DTA_VALUTA_INTERESSI,
  P_MATRICOLA,
  P_COD_FILIALE_OPER
);

IF (NVL(LENGTH(TRIM(v_keymo02)), 0) = 0) THEN

UPDATE T_MCRES_APP_ACC_SOFF
SET VAL_KEYMO02 = P_ID,
VAL_INTERESSI_ORIGINARI = P_VAL_INTERESSI_ORIGINARI
WHERE VAL_NUMERO_SOFF = P_VAL_NUMERO_SOFF;

V_NOTE:= 'Aggiornata val_keyMO02 di accensione soff n. ' || P_VAL_NUMERO_SOFF || ' a ID: ' || P_ID;
PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);

END IF;

V_NOTE:='Inserito movimento id: ' || P_ID || ', cod_abi: ' || P_COD_ABI || ', cod_ndg: ' || P_COD_NDG || ', cod_rapporto_orig: ' || P_COD_RAPPORTO_ORIG;
PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);

return ok;

END IF;

IF (P_FLG_OPERAZ = 'CANC') THEN

UPDATE T_MCRES_APP_GIRO_INT_ORIG
SET FLG_CANCEL = 1,
DTA_CANCEL = SYSDATE,
MATR_CANC = P_MATRICOLA
WHERE ID = P_ID;

UPDATE T_MCRES_APP_ACC_SOFF
SET VAL_KEYMO02 = NULL
WHERE VAL_KEYMO02 = P_ID;

V_NOTE:='Annullato movimento id: ' || P_ID || ', cod_abi: ' || P_COD_ABI || ', cod_ndg: ' || P_COD_NDG || ', cod_rapporto_orig: ' || P_COD_RAPPORTO_ORIG;
PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);

return ok;

END IF;

V_NOTE:='Flag operazione non corretto';
PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);

return ko;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);
return ko;

end fnc_movimento_da_volturare;

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
) return number is

  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MOVIMENTO_PROPOSTO';
  V_NOTE VARCHAR2(1000) := 'GENERALE';

begin

IF (P_FLG_OPERAZ = 'ADD') THEN

INSERT INTO T_MCRES_APP_MOV_PROPOS (
  ID,
  COD_ABI,
  COD_NDG,
  VAL_DENOMINAZIONE_CLI,
  COD_FILIALE,
  COD_CAUSALE,
  VAL_DESC_CAUSALE,
  COD_TIPO_CONTROPART,
  VAL_IMPORTO,
  DTA_VALUTA,
  VAL_ORDINANTE,
  VAL_MOTIVAZIONE,
  MATR_INS,
  COD_FILIALE_OPER)
VALUES (
  P_ID,
  P_COD_ABI,
  P_COD_NDG,
  P_VAL_DENOMINAZIONE_CLI,
  P_COD_FILIALE,
  P_COD_CAUSALE,
  P_VAL_DESC_CAUSALE,
  P_COD_TIPO_CONTROPART,
  P_VAL_IMPORTO,
  P_DTA_VALUTA,
  P_VAL_ORDINANTE,
  P_VAL_MOTIVAZIONE,
  P_MATRICOLA,
  P_COD_FILIALE_OPER
);

V_NOTE:='Inserito movimento id: ' || P_ID || ', cod_abi: ' || P_COD_ABI || ', cod_ndg: ' || P_COD_NDG || ', cod_causale: ' || P_COD_CAUSALE;
PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);

return ok;

END IF;

IF (P_FLG_OPERAZ = 'CANC') THEN

UPDATE T_MCRES_APP_MOV_PROPOS
SET FLG_CANCEL = 1,
DTA_CANCEL = SYSDATE,
MATR_CANC = P_MATRICOLA
WHERE ID = P_ID;

V_NOTE:='Annullato movimento id: ' || P_ID || ', cod_abi: ' || P_COD_ABI || ', cod_ndg: ' || P_COD_NDG || ', cod_causale: ' || P_COD_CAUSALE;
PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);

return ok;

END IF;

V_NOTE:='Flag operazione non corretto';
PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);

return ko;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);
return ko;

end fnc_movimento_proposto;


function fnc_gestione_criteri(
     p_id_criterio t_mcres_app_criteri.id_criterio%type default 0,
     p_desc_criterio t_mcres_app_criteri.desc_criterio%type,
     p_desc_criterio2 t_mcres_app_criteri.desc_criterio2%type,
     p_val_priorita t_mcres_app_criteri.val_priorita%type,
     p_cod_presidio t_mcres_app_criteri.cod_presidio%type,
     p_cod_matr_pratica t_mcres_app_criteri.cod_matr_pratica%type,
     p_cod_tipo_operazione t_mcres_app_criteri.cod_tipo_operazione%type default 'I'
) return number is

  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_GESTIONE_CRITERI';
  V_NOTE VARCHAR2(1000) := 'GENERALE';

  v_id_criterio  t_mcres_app_criteri.id_criterio%type;

begin

    if(p_cod_tipo_operazione!='D')then
        V_NOTE := 'Nuovo ID per criterio '||p_id_criterio;
        select SEQ_MCRES_CRITERI.nextval
        into v_id_criterio
        from dual;
    end if;

    V_NOTE := 'Criterio spento '||p_id_criterio;
    update t_mcres_app_criteri
    set dta_fine = sysdate,
         id_criterio_nuovo = v_id_criterio
    where id_criterio = p_id_criterio;

    if(p_COD_TIPO_OPERAZIONE!='D') then
        V_NOTE := 'Nuovo criterio '||v_id_criterio||' per criterio '||p_id_criterio;
        insert into t_mcres_app_criteri (
            id_criterio,
            FLG_CRITERIO,
            DESC_CRITERIO,
            DESC_CRITERIO2,
            VAL_PRIORITA,
            COD_PRESIDIO,
            DTA_INIZIO,
            DTA_FINE,
            COD_MATR_PRATICA,
            COD_TIPO_OPERAZIONE
         ) values (
            v_id_criterio,
            nvl2(p_desc_criterio2,'R','C'),
            p_DESC_CRITERIO,
            p_DESC_CRITERIO2,
            p_VAL_PRIORITA,
            p_COD_PRESIDIO,
            sysdate,
            null,
            p_COD_MATR_PRATICA,
            nvl(p_COD_TIPO_OPERAZIONE,'I')
         );
    end if;

    return ok;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,p_COD_MATR_PRATICA);
    return ko;

end fnc_gestione_criteri;

function fnc_gestione_raccolta_doc(
    p_cod_abi t_mcres_app_raccolta_doc.cod_abi%type,
    p_cod_ndg t_mcres_app_raccolta_doc.cod_ndg%type,
    p_cod_uo_rapporto t_mcres_app_raccolta_doc.cod_uo_rapporto%type,
    p_cod_stato_raccolta_doc t_mcres_app_raccolta_doc.cod_stato_raccolta_doc%type,
    p_cod_matr_pratica t_mcres_app_raccolta_doc.cod_matr_pratica%type,
    p_flg_urgente  t_mcres_app_raccolta_doc.flg_urgente%type
) return number is

  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_GESTIONE_RACCOLTA_DOC';
  V_NOTE VARCHAR2(1000) := 'GENERALE';

  v_exist number(1);

begin

    V_NOTE := 'Controllo esistenza workflow documenti - ABI='||p_cod_abi||', NDG='||p_cod_ndg||', UO='||p_cod_uo_rapporto;
    select count(distinct 1)
    into v_exist
    from t_mcres_app_raccolta_doc
    where COD_ABI = p_cod_abi
    and COD_NDG = p_cod_ndg
    and COD_UO_RAPPORTO = p_cod_uo_rapporto;

    if (v_exist =0) then
        V_NOTE := 'Insert workflow documenti - ABI='||p_cod_abi||', NDG='||p_cod_ndg||', UO='||p_cod_uo_rapporto;
         insert into t_mcres_app_raccolta_doc (
            cod_abi,
            cod_ndg,
            cod_uo_rapporto,
            cod_stato_raccolta_doc,
            dta_ins,
            dta_upd,
            cod_matr_pratica,
            flg_urgente
         ) values (
            p_cod_abi,
            p_cod_ndg,
            p_cod_uo_rapporto,
            p_cod_stato_raccolta_doc,
            sysdate,
            sysdate,
            p_cod_matr_pratica,
            p_flg_urgente
         );
    else
       if(p_cod_matr_pratica != 'BATCH') then
            V_NOTE := 'Update workflow documenti - ABI='||p_cod_abi||', NDG='||p_cod_ndg||', UO='||p_cod_uo_rapporto;
            update    t_mcres_app_raccolta_doc
            set cod_stato_raccolta_doc = p_cod_stato_raccolta_doc,
                dta_upd = sysdate,
                cod_matr_pratica = p_cod_matr_pratica,
                flg_urgente = NVL(p_flg_urgente, flg_urgente)
            where COD_ABI = p_cod_abi
            and COD_NDG = p_cod_ndg
            and COD_UO_RAPPORTO = p_cod_uo_rapporto;
       end if;
    end if;

    return ok;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,p_COD_MATR_PRATICA);
    return ko;

end fnc_gestione_raccolta_doc;

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
) return number is

  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_GESTIONE_SCHEDA_DOC';
  V_NOTE VARCHAR2(1000) := 'GENERALE';

  v_exist number(1);

begin

    V_NOTE := 'Controllo esistenza workflow documenti - ABI='||p_cod_abi||', NDG='||p_cod_ndg||', UO='||p_cod_uo_rapporto;
    select count(distinct 1)
    into v_exist
    from t_mcres_app_scheda_doc
    where COD_ABI = p_cod_abi
    and COD_NDG = p_cod_ndg
    and COD_UO_RAPPORTO = p_cod_uo_rapporto
    and id_documento = p_id_documento;

    if (v_exist =0) then
        V_NOTE := 'Insert scheda documentale - ABI='||p_cod_abi||', NDG='||p_cod_ndg||', UO='||p_cod_uo_rapporto||', id_doc='||p_id_documento;
                 insert into t_mcres_app_scheda_doc (
                    cod_abi,
                    cod_ndg,
                    cod_uo_rapporto,
                    id_documento,
                    val_note_filiale,
                    flg_conforme,
                    flg_disponibile,
                    val_note_presidio,
                    dta_completamento,
                    cod_matr_pratica,
                    dta_ins,
                    dta_upd
                 ) values (
                    p_cod_abi,
                    p_cod_ndg,
                    p_cod_uo_rapporto,
                    p_id_documento,
                    p_val_note_filiale,
                    p_flg_conforme,
                    p_flg_disponibile,
                    p_val_note_presidio,
                    p_dta_completamento,
                    p_cod_matr_pratica,
                    sysdate,
                    sysdate
                 );
    else
        V_NOTE := 'Update scheda documentale - ABI='||p_cod_abi||', NDG='||p_cod_ndg||', UO='||p_cod_uo_rapporto||', id_doc='||p_id_documento;
        if(p_cod_matr_pratica!='BATCH')then
                     update    t_mcres_app_scheda_doc
                    set id_documento = p_id_documento,
                        val_note_filiale = p_val_note_filiale,
                        flg_conforme = p_flg_conforme,
                        flg_disponibile = p_flg_disponibile,
                        val_note_presidio = p_val_note_presidio,
                        dta_completamento = p_dta_completamento,
                        dta_upd = sysdate,
                        cod_matr_pratica = p_cod_matr_pratica
                    where COD_ABI = p_cod_abi
                    and COD_NDG = p_cod_ndg
                    and COD_UO_RAPPORTO = p_cod_uo_rapporto
                   and id_documento = p_id_documento;
         end if;
    end if;

    return ok;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,p_COD_MATR_PRATICA);
    return ko;

end fnc_gestione_scheda_doc;


function fnc_genera_cod_autorizzazione(p_cod_abi t_mcres_cl_sap.cod_abi%type, p_matricola varchar2) return varchar2 is


  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_GENERA_COD_AUTORIZZAZIONE';
  V_NOTE VARCHAR2(1000) := 'GENERALE';

v_cod_autorizzazione varchar2(100);
begin

 SELECT cod_societa||9||to_char(sysdate,'YYYY')||lpad(SEQ_MCRES_SPESE.nextval,7,'0')
        INTO v_cod_autorizzazione
         FROM t_mcres_cl_sap
         where cod_abi = p_cod_abi;

         V_NOTE:='Generato codice autorizzazione: ' || v_cod_autorizzazione;
         PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,P_MATRICOLA);

return v_cod_autorizzazione;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,p_matricola);
    return null;

end fnc_genera_cod_autorizzazione;

function fnc_gestione_cessione_rout(
    p_cod_abi T_MCRES_app_CEDUTE_ROUT.cod_abi%type,
    p_cod_ndg_cessionaria T_MCRES_app_CEDUTE_ROUT.cod_ndg_cessionaria%type)
return number is

  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_GESTIONE_CESSIONE_ROUT';
  V_NOTE VARCHAR2(1000) := 'GENERALE';

begin

    update T_MCRES_app_CEDUTE_ROUT
    set flg_invio = 1,
         dta_invio = sysdate
    where cod_abi = p_cod_abi
    and cod_ndg_cessionaria = p_cod_ndg_cessionaria;

    return ok;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,null);
    return ko;
end fnc_gestione_cessione_rout;

function fnc_gestione_ftecniche(
    p_COD_FORMA_TECNICA  T_MCRES_cl_forme_tecniche.cod_forma_tecnica%type,
    p_VAL_DESC_FORMA_TECNICA T_MCRES_cl_forme_tecniche.VAL_DESC_FORMA_TECNICA%type,
    p_MATRICOLA_INS T_MCRES_cl_forme_tecniche.MATRICOLA_INS%type,
    p_flg_active T_MCRES_cl_forme_tecniche.flg_active%type)
return number is

  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_GESTIONE_FTECNICHE';
  V_NOTE VARCHAR2(1000) := 'GENERALE';
  v_exists number(1):=0;

begin

    V_NOTE := 'FTecnica: '||p_cod_forma_tecnica||' - '||p_VAL_DESC_FORMA_TECNICA||' - '||p_MATRICOLA_INS||' - '||p_flg_active;

     select distinct 1
     into v_exists
     from T_MCRES_cl_forme_tecniche
     where cod_forma_tecnica = p_cod_forma_tecnica;

    if(v_exists=1)then
            update T_MCRES_cl_forme_tecniche
            set VAL_DESC_FORMA_TECNICA= p_VAL_DESC_FORMA_TECNICA,
                    MATRICOLA_INS = p_MATRICOLA_INS,
                    DTA_DELETE = decode(p_flg_active,0,sysdate,DTA_DELETE),
                    FLG_ACTIVE =  p_flg_active,
                    DTA_UPDATE = sysdate
            where cod_forma_tecnica = p_cod_forma_tecnica;
    else
        insert into T_MCRES_cl_forme_tecniche (
            COD_FORMA_TECNICA,
            VAL_DESC_FORMA_TECNICA,
            DTA_INS,
            MATRICOLA_INS,
            FLG_ACTIVE,
            DTA_UPDATE
        ) values (
            p_COD_FORMA_TECNICA,
            p_VAL_DESC_FORMA_TECNICA,
            sysdate,
            p_MATRICOLA_INS,
            1,
            sysdate
        );
    end if;

    return ok;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,null);
    return ko;
end fnc_gestione_ftecniche;

function fnc_gestione_prodotti(
    p_COD_TIPO_SOFF T_MCRES_cl_prodotti_soff.COD_TIPO_SOFF%type,
    p_VAL_DESC_TIPO_SOFF T_MCRES_cl_prodotti_soff.VAL_DESC_TIPO_SOFF%type,
    p_FLG_FILIALE T_MCRES_cl_prodotti_soff.FLG_FILIALE%type,
    p_FLG_PRESIDIO T_MCRES_cl_prodotti_soff.flg_presidio%type,
    p_FLG_AUTOMATICA T_MCRES_cl_prodotti_soff.FLG_AUTOMATICA%type,
    p_FLG_DISMESSA T_MCRES_cl_prodotti_soff.FLG_DISMESSA%type,
    p_MATRICOLA_INS T_MCRES_cl_prodotti_soff.MATRICOLA_INS%type,
    p_flg_active T_MCRES_cl_prodotti_soff.flg_active%type)
return number is

  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_GESTIONE_PRODOTTI';
  V_NOTE VARCHAR2(1000) := 'GENERALE';
  v_exists number(1):=0;

begin

    V_NOTE := 'Prodotto: '||p_COD_TIPO_SOFF||' - '||p_VAL_DESC_TIPO_SOFF||' - '||p_FLG_FILIALE||' - '||p_FLG_PRESIDIO||' - '||p_FLG_AUTOMATICA||' - '||p_FLG_DISMESSA||' - '||p_MATRICOLA_INS||' - '||p_flg_active;

     select distinct 1
     into v_exists
     from T_MCRES_cl_prodotti_soff
     where COD_TIPO_SOFF = p_COD_TIPO_SOFF;

    if(v_exists=1)then
            update T_MCRES_cl_prodotti_soff
            set VAL_DESC_TIPO_SOFF = p_VAL_DESC_TIPO_SOFF,
                    FLG_FILIALE = p_FLG_FILIALE,
                    FLG_PRESIDIO = p_FLG_PRESIDIO,
                    FLG_AUTOMATICA = p_FLG_AUTOMATICA,
                    FLG_DISMESSA = p_FLG_DISMESSA,
                    MATRICOLA_INS = p_MATRICOLA_INS,
                    DTA_DELETE = decode(p_flg_active,0,sysdate,DTA_DELETE),
                    FLG_ACTIVE =  p_flg_active,
                    DTA_UPDATE = sysdate
            where COD_TIPO_SOFF = p_COD_TIPO_SOFF;
    else
        insert into T_MCRES_cl_prodotti_soff (
            COD_TIPO_SOFF,
            VAL_DESC_TIPO_SOFF,
            FLG_FILIALE,
            FLG_PRESIDIO,
            FLG_AUTOMATICA,
            FLG_DISMESSA,
            DTA_INS,
            MATRICOLA_INS,
            FLG_ACTIVE,
            DTA_UPDATE
        ) values (
            p_COD_TIPO_SOFF,
            p_VAL_DESC_TIPO_SOFF,
            p_FLG_FILIALE,
            p_FLG_PRESIDIO,
            p_FLG_AUTOMATICA,
            p_FLG_DISMESSA,
            sysdate,
            p_MATRICOLA_INS,
            1,
            sysdate
        );
    end if;

    return ok;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,null);
    return ko;
end fnc_gestione_prodotti;


function fnc_gestione_ftec_prodotti(
    p_COD_FORMA_TECNICA  T_MCRES_cl_raccordo_prod.cod_forma_tecnica%type,
    p_COD_TIPO_SOFFERENZA T_MCRES_cl_raccordo_prod.COD_TIPO_SOFFERENZA%type,
    p_MATRICOLA_INS T_MCRES_cl_raccordo_prod.MATRICOLA_INS%type,
    p_flg_active T_MCRES_cl_raccordo_prod.flg_active%type)
return number is

  C_NOME CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_GESTIONE_FTEC_PRODOTTI';
  V_NOTE VARCHAR2(1000) := 'GENERALE';
  v_exists number(1):=0;

begin

    V_NOTE := 'FTecnica: '||p_cod_forma_tecnica||' - '||p_COD_TIPO_SOFFERENZA||' - '||p_MATRICOLA_INS||' - '||p_flg_active;

     select distinct 1
     into v_exists
     from T_MCRES_cl_raccordo_prod
     where cod_forma_tecnica = p_cod_forma_tecnica
     and COD_TIPO_SOFFERENZA = p_COD_TIPO_SOFFERENZA;

    if(v_exists=1)then
            update T_MCRES_cl_raccordo_prod
            set     MATRICOLA_INS = p_MATRICOLA_INS,
                    DTA_DELETE = decode(p_flg_active,0,sysdate,DTA_DELETE),
                    FLG_ACTIVE =  p_flg_active,
                    DTA_UPDATE = sysdate
            where cod_forma_tecnica = p_cod_forma_tecnica
            and COD_TIPO_SOFFERENZA = p_COD_TIPO_SOFFERENZA;
    else
        insert into T_MCRES_cl_raccordo_prod (
            COD_FORMA_TECNICA,
            COD_TIPO_SOFFERENZA,
            DTA_INS,
            MATRICOLA_INS,
            FLG_ACTIVE,
            DTA_UPDATE
        ) values (
            p_COD_FORMA_TECNICA,
            p_COD_TIPO_SOFFERENZA,
            sysdate,
            p_MATRICOLA_INS,
            1,
            sysdate
        );
    end if;

    return ok;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,null);
    return ko;
end fnc_gestione_ftec_prodotti;

FUNCTION fnc_mcres_protocollo_delibera(cod_uo IN VARCHAR2,
                                         utente IN VARCHAR2 DEFAULT NULL,
                                         p_abi  IN VARCHAR2 DEFAULT NULL,
                                         p_ndg  IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2 IS
    c_nome                  VARCHAR2(50)  := 'FNC_MCRES_PROTOCOLLO_DELIBERA';
    ko                      VARCHAR2(6) := 'ERRORE';
    progressivo_attuale     VARCHAR(9) := '8999999';
    cod_protocollo_delibera VARCHAR2(17);
    quante_uo               NUMBER;
    anno_attuale            VARCHAR2(4);
    v_uo                    VARCHAR2(5);
  BEGIN
    v_uo := cod_uo;

    -- se uo pratica nullo, la ricavo dalla posizione stessa, se anche abi ndg nulli.. exit
    IF cod_uo IS NULL
    THEN
      IF (p_abi IS NULL AND p_ndg IS NULL)
      THEN
        pkg_mcres_audit.log_app(c_package || c_nome,
                                pkg_mcres_audit.c_error,
                                SQLCODE,
                                SQLERRM,
                                'parametri nulli.. raise',
                                utente);
        raise_application_error(-20666, 'Null parameter');
      ELSE
        BEGIN
          SELECT nvl(s.cod_struttura_competente, a.cod_struttura_competente)
            INTO v_uo
            FROM t_mcre0_app_all_data      a,
                 t_mcre0_app_struttura_org s
           WHERE a.cod_abi_cartolarizzato = p_abi
             AND a.cod_ndg = p_ndg
             AND a.cod_abi_cartolarizzato = s.cod_abi_istituto(+)
             AND nvl(nvl(a.cod_comparto_assegnato, a.cod_comparto_calcolato),
                     a.cod_struttura_competente) = s.cod_comparto(+);

          IF v_uo IS NULL
          THEN
            RETURN - 1;
          END IF;
        EXCEPTION
          WHEN no_data_found THEN

            RETURN - 1;
        END;
      END IF;
    END IF;

    /*
    * Per COD_UO e ANNO devo cercare nella tabella T_MCRES_APP_ANAG_UO.
    * Se esiste gi? la coppia allora prendo il progressivo e lo incremento.
    * Se la coppia esiste ma l'anno S vecchio allora riazzero il progressivo e aggiorno l'anno.
    * Se la coppia non esiste allora inserisco il cod_uo e l'anno e inizializzo anche il progressivo al valore minore previsto.
    */
    SELECT to_char(SYSDATE, 'YYYY') INTO anno_attuale FROM dual;

    SELECT COUNT(*)
      INTO quante_uo
      FROM t_mcres_app_anag_uo
     WHERE cod_uo_pratica = v_uo;

    -- AND anno = anno_attuale;

    /*
    *  Se quante_uo = 0 allora devo inserire anche una riga nella tabella di anagrafica delle UO
    *  Altrimenti procedo all'aggiornamento. Praticamente implemento una merge
    */
    IF (quante_uo = 0)
    THEN
      INSERT INTO t_mcres_app_anag_uo
        (cod_uo_pratica,
         anno,
         progressivo)
      VALUES
        (v_uo,
         to_char(SYSDATE, 'yyyy'),
         progressivo_attuale + 1);
    END IF;

    --  prendo, per l'anno maggiore, il progressivo massimo
    SELECT MAX(CASE
                 WHEN anno = anno_attuale THEN
                  to_char(progressivo + 1)
                 WHEN anno < anno_attuale THEN
                  '9000000'
                 ELSE
                  '9999999'
               END) progressivo
      INTO progressivo_attuale
      FROM t_mcres_app_anag_uo
     WHERE cod_uo_pratica = v_uo
    --       AND anno = anno_attuale
     GROUP BY anno;

    UPDATE t_mcres_app_anag_uo
       SET progressivo = progressivo_attuale,
           anno        = anno_attuale
     WHERE cod_uo_pratica = v_uo;

    cod_protocollo_delibera := 'X'||progressivo_attuale || anno_attuale || v_uo;
    pkg_mcres_audit.log_app(c_package || c_nome,
                            pkg_mcres_audit.c_debug,
                            SQLCODE,
                            SQLERRM,
                            'cod_protocollo_delibera= ' ||
                            cod_protocollo_delibera,
                            utente);
    RETURN cod_protocollo_delibera;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcres_audit.log_app(c_package || c_nome,
                              pkg_mcres_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              'COD_UO= ' || cod_uo || 'abi= ' || p_abi ||
                              ' ndg= ' || p_ndg || ' v_uo: ' || v_uo,
                              utente);
      raise_application_error(-20666, 'Null parameter');
      RETURN ko;
  END fnc_mcres_protocollo_delibera;

end pkg_mcres_funzioni_portale;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_FUNZIONI_PORTALE FOR MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALE;


CREATE SYNONYM MCRE_USR.PKG_MCRES_FUNZIONI_PORTALE FOR MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALE TO MCRE_USR;

