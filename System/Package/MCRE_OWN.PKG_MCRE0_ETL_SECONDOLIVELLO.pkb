CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_ETL_SECONDOLIVELLO AS
/******************************************************************************
   NAME:       PKG_MCRE0_ETL_SECONDOLIVELLO
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        06/10/2010  Marco Murro        Created this package.
   1.1        26/11/2010  Valeria Galli      Pkg generalizzato
   1.2        14/12/2010  Marco Murro        scrittura esito per TWS
   1.3        17/12/2010  Valeria Galli      Aggiunto calcolo dta_dec_stato_pre
   1.4        13/01/2011  VMarco Murro       rimossa scheda_anag_mov, aggiunto last_percorso
   1.5        21/01/2011  Valeria Galli      MV LOG create e fast refresh e cambio controllo
   1.6        01/02/2011  Valeria Galli      Aggiorna Istituti
   1.7        07/02/2011  Valeria Galli      Aggiorna Uscite Man/Aut+ commentato last_percorsi
   1.8        14/02/2011  Marco Murro        Aggiunto check su Abi_elaborati
   1.9        14/02/2011  M.Murro Gianna     Aggiunta chiamata a USCITA_CCP e storicizzazione mensile
   2.0        23/03/2011  C.Giannangeli      Aggiunta inizializzazione tabella T_MCRE0_WRK_SENDING_FILES
   2.1        31/03/2011  M.Murro            Aggiunta chiamata refresh MV Rio
   2.2        06/04/2011  V.Galli             Delete PT e RIO
   2.3        19/04/2011  C.Giannangeli      Aggiunta chiamata a PKG_MCRE0_ASS_AUTOM
   2.4        26/04/2011  M.Murro            Calcolo statistiche su FG e Mople + nuovo audit
   2.5        06/05/2011  M.Murro            Aggiunta riapertura portale + CR
   2.6        24/05/2011  M.Murro            Aggiunta Gestione Bonis
   2.7        25/05/2011  V.Galli            AGGIORNA_CR_ALL
   2.8        27/05/2011  V.Galli            nuovo log
   2.9        16/06/2011  M.Murro            abilitata GB
   3.0        07/07/2011  M.Murro            procedure unica per assegna comparto GB e AVocazione
   3.1        25/07/2011  M.Murro            variata gestione estendi Mople e FGuida
   4.0        05/08/2011  M.Murro            versione post Tuning
   4.1        26/08/2011  M.Murro            rimossa fase restore (anticipata) e anticipata ana_gen su RIO_esp
   4.2        30/08/2011  M.Murro            ana_genETL...
******************************************************************************/

  -- Procedura per controllo fine caricamenti
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_check_end_loading(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  )return number IS

    v_idper V_MCRE0_ULTIMA_ACQUISIZIONE.IDPER%type;
    OK_LOADING NUMBER:=0;
    SEQ NUMBER;

  BEGIN

     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO SEQ
        from dual;
    ELSE
      SEQ := P_COD_LOG;
    end if;

    begin
      select max(idper)
      into v_idper
      from V_MCRE0_ULTIMA_ACQUISIZIONE;
    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (SEQ,'ETL2 - check_end_loading', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, SQLERRM, 'CALCOLO MAX IDPER');
        return ko;
    end;

    begin
        SELECT count(*)
        into ok_loading
        FROM  mcre_own.t_mcre0_wrk_acquisizione w
        WHERE STATO = 'CARICATO'
        and TO_CHAR (periodo_riferimento, 'YYYYMMDD') = v_idper
        and w.flg_ETL_2 = -1
        and  cod_file in (
            'SAB_XRA',
            'SAG',
            'PCR_GE_SB',
            'PCR_GB',
            'FILE_GUIDA',
            'LEGAME',
            'ANAGR_GRE',
            'ANAGRAFICA_GRUPPO',
            'ABIELAB', --14.02
            'GRUPPO_ECONOMICO',
            'MOPLE',
            'PCR_SC_SB',
            'PERCORSI') ;
    exception
      when others then
        OK_LOADING:=0;
        PKG_MCRE0_AUDIT.log_etl (SEQ,'ETL2 - check_end_loading', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, SQLERRM, 'CHECK END LOADING');
        return ko;
    end;

    if(ok_loading=13) then
      return ok;
    else
      return ko;
    end if;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.log_etl (SEQ,'ETL2 - check_end_loading', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, SQLERRM, 'GENERALE');
      return ko;
  END;

  -- Procedura esecuzione ETL secondo livello
  -- INPUT :
  --    p_storico 0 giornaliero, 1 storico
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori -1 caricamenti non ancora terminati
  FUNCTION FNC_LANCIA_TUTTO(
    p_storico number default 0
  ) return number IS

    esito  number := 0;
    RetVal number := 0;
    cnt_fnc number:= 0;
    SEQ NUMBER;

  BEGIN

    SELECT SEQ_MCR0_LOG_ETL.NEXTVAL INTO SEQ from dual;

    --log_caricamenti('fnc_lancia_tutto',-1,'START - Lancia tutto');

    IF(FNC_CHECK_END_LOADING(SEQ)=KO)THEN
      PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - in attesa', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'return '||in_attesa, 'In attesa di terminare il caricamento dei flussi');
      return in_attesa;
    end if;

    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - CARICAMENTO', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'START - SEQ='||seq, 'Iniziato Secondo Livello');
    --start --> update FLG_ETL_2 a 0
    update MCRE_OWN.T_MCRE0_WRK_ACQUISIZIONE
    set FLG_ETL_2 = 0
    where PERIODO_RIFERIMENTO = (select to_date(max(idper), 'YYYYMMDD') from V_MCRE0_ULTIMA_ACQUISIZIONE);
    commit;

    /********************
    * Riallineo Mople e FGuida - 09.08
    ********************/
    --v4.1 rimosso... attaccati all'AnaGen notturna...

--    RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_MOPLE(seq);
--    IF RetVal = KO THEN
--    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - Restore original Tables', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito '||RetVal, 'Restore Mople Terminato con errore ');
--     return ko;
--    END IF;
--    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - Restore original Tables', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Restore Mople');
--      esito := esito+RetVal;
--      cnt_fnc := cnt_fnc + 1;

--    RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_FILE_GUIDA(seq);
--    IF RetVal = KO THEN
--    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - Restore original Tables', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito '||RetVal, 'Restore FGuida Terminato con errore ');
--     return ko;
--    END IF;
--    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - Restore original Tables', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito FGuida Mople');
--      esito := esito+RetVal;
--      cnt_fnc := cnt_fnc + 1;

    /********************
    * CHECK ABI ELABORATI - 14.02
    ********************/

    RetVal := PKG_MCRE0_GESTIONE_ABI_ELAB.CHECK_ABI_ELAB;
    IF RetVal = KO THEN
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito '||RetVal, 'Terminato con errore ');
     return ko;
    END IF;
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - CHECK_ABI_ELAB', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'ok');
      esito := esito+RetVal;
      cnt_fnc := cnt_fnc + 1;

    /*******************
    *** TAPPI -v4.0
    *******************/
    RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.ETL_GESTIONE_TAPPI(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - GESTIONE TAPPI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Inserimento Tappi');
      esito := esito+RetVal;
      cnt_fnc := cnt_fnc + 1;

    /*******************
    *** GRUPPI
    *******************/
      --svecchio GE
      RetVal := MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME.SVECCHIA_GE;
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - GESTIONE GRUPPI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Svecchiamento GE');
      esito := esito+RetVal;
      cnt_fnc := cnt_fnc + 1;

      --svecchio GL
      RetVal := MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME.SVECCHIA_LEGAMI;
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - GESTIONE GRUPPI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Svecchiamento GL');
      esito := esito+RetVal;
      cnt_fnc := cnt_fnc + 1;

    --gruppo legame
    RetVal := MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME.LOAD_FULL_GRUPPO_LEGAME;
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - GESTIONE GRUPPI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Ricalcolo tabella Gruppo_Legame');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    /*******************
    *** MOPLE
    *******************/

    --v2.6: aggiorno GB
    RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.UPD_GB_STATUS;
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - ESTENDI_MOPLE', 3, sqlcode, 'Esito '||RetVal, 'eseguito Aggiornamento GB');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    --v3.1, anticipa e sosstituisce la pk_today
    RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.FNC_SET_TODAY_FLG;
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - ESTENDI_MOPLE', 3, sqlcode, 'Esito '||RetVal, 'eseguito Set TODAY_FLG');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    --comparto
    RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.SET_COMPARTO_HOST;
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - ESTENDI_MOPLE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Calcolo comparto');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    --macrostato
    RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.FNC_GESTIONE_MACROSTATO;
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - ESTENDI_MOPLE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Calcolo macrostato');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    --processo_pre
    RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.FNC_GESTIONE_PROCESSO_PRE;
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - ESTENDI_MOPLE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Calcolo processo precedente');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    --dta_decorrenza_stato_pre
    RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.FNC_GESTIONE_DTA_STATO_PRE;
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - ESTENDI_MOPLE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Calcolo data decorrenza stato precedente');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    --aggiorno MOPLE_PK_TODAY -->sostituito da FNC_SET_TODAY_FLG
--    RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE.FNC_FILL_MOPLE_PK_TODAY;
--    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - ESTENDI_MOPLE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Caricamento MOPLE_PK_TODAY');
--    esito := esito+RetVal;
--    cnt_fnc := cnt_fnc + 1;

    /*******************
    *** FILE GUIDA
    *******************/

    -- Aggiornamento File Guida
    RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA.UPDATE_FILE_GUIDA(p_storico);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - ESTENDI_FILE_GUIDA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Aggiornamento File Guida');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    -- assegnazione comparti per GB
    RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA.assegna_comparto_GB_AV(seq); --v 3.0
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - ESTENDI_FILE_GUIDA', 3, sqlcode, 'Esito '||RetVal, 'eseguito assegna_comparto_GB_AV');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    -- gestione Gestori/Comparti su gruppi usciti da mople
    RetVal := MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA.update_uscita_CCP; --v 1.9
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - ESTENDI_FILE_GUIDA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito update_uscita_CCP');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    /*******************
    *** Statistiche su File Guida e Mople aggiornati  - v2.4
    *******************/
/*  --commentate in v4.0... ok?
    if( MCRE_OWN.PKG_MCRE0_ANALYZE.FND_MCRE0_ANALYZE_TABLE_APP ( 'MCRE_OWN', 'T_MCRE0_APP_FILE_GUIDA' ) )then
     esito := esito+1;
     PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - STATISTICHE 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'eseguito Calcolo Statistiche su FileGuida');
    else
     PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - STATISTICHE 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 0', 'impossibile eseguire Calcolo Statistiche su FileGuida');
    end if;
     cnt_fnc := cnt_fnc + 1;

    if( MCRE_OWN.PKG_MCRE0_ANALYZE.FND_MCRE0_ANALYZE_TABLE_APP ( 'MCRE_OWN', 'T_MCRE0_APP_MOPLE' ) )then
     esito := esito+1;
     PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - STATISTICHE 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'eseguito Calcolo Statistiche su Mople');
    else
     PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - STATISTICHE 1', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 0', 'impossibile eseguire Calcolo Statistiche su Mople');
    end if;
     cnt_fnc := cnt_fnc + 1;
*/

    /*******************
    *** ASSEGNAZIONE AUTOMATICA SU INCAGLI
    *******************/

     RETVAL := MCRE_OWN.PKG_MCRE0_ASS_AUTOM.FND_MCRE0_ASSEGNA(seq);  --v.2.3
     PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - ASSEGNAZIONE AUTOMATICA SU INCAGLI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguita assegnazione automatica');
     esito := esito+RetVal;
     cnt_fnc := cnt_fnc + 1;

    /*******************
    *** Storico
    *******************/

     RETVAL := MCRE_OWN.PKG_MCRE0_STORICIZZA.STORICIZZA_CARICAMENTI(seq);
     PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - STORICIZZA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguita storicizzazione a seguito dei caricamenti');
     esito := esito+RetVal;
     cnt_fnc := cnt_fnc + 1;

    /*******************
    *** Varie
    *******************/

    --riempio prima la tabellona PCR
    RetVal := MCRE_OWN.PKG_MCRE0_PCR.FNC_LOAD_PCR(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - PCR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Calcolo PCR');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    begin
     if( MCRE_OWN.PKG_MCRE0_ANALYZE.FND_MCRE0_ANALYZE_TABLE_APP ( 'MCRE_OWN', 'T_MCRE0_APP_PCR' ) )then
         esito := esito+1;
         PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - PCR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'eseguito Analyze PCR');
     else
         PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - PCR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 0', 'impossibile eseguire Analyze PCR');
     end if;
    EXCEPTION WHEN OTHERS THEN
     PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - PCR ', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito 0 '||SQLERRM, 'impossibile eseguire Analyze PCR');
    end;
    cnt_fnc := cnt_fnc + 1;

    --riempo la tabellona CR
    RetVal := MCRE_OWN.PKG_MCRE0_CR.FNC_LOAD_CR(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - CR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Calcolo CR');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    begin
     if( MCRE_OWN.PKG_MCRE0_ANALYZE.FND_MCRE0_ANALYZE_TABLE_APP ( 'MCRE_OWN', 'T_MCRE0_APP_CR' ) )then
         esito := esito+1;
         PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - CR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 1', 'eseguito Analyze CR');
     else
         PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - CR ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito 0', 'impossibile eseguire Analyze CR');
     end if;
    EXCEPTION WHEN OTHERS THEN
     PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - CR ', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito 0 '||SQLERRM, 'impossibile eseguire Analyze CR');
    end;
    cnt_fnc := cnt_fnc + 1;

    /*******************
    *** MV
    *******************/
    --v4.0 - anticipo istituti e struttorg
    --v4.1 - anticipo anche AnaGen!
     -- Istituti
    Retval := Mcre_Own.Pkg_Mcre0_Aggiorna_Mv.Aggiorna_Istituti(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Aggiorna Istituti');
    Esito := Esito+Retval;
    cnt_fnc := cnt_fnc + 1;

     -- Strutt_ORG
    Retval := Mcre_Own.Pkg_Mcre0_Aggiorna_Mv.aggiorna_DENORM_STR_ORG(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Aggiorna Strutt_ORG');
    ESITO := ESITO+RETVAL;
    cnt_fnc := cnt_fnc + 1;

    ---TABELLONE al posto della UPD_FIELDS v4.0
    RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.LOAD_ALL_DATA(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - AGGIORNA ALL_DATA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Ricarico All_Data');
    ESITO := ESITO+RETVAL;
    cnt_fnc := cnt_fnc + 1;

    -- Vistone
    RetVal := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_AnaGenETL(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Aggiorna AnaGen');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    --MV RIO - v2.1.
    RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_MONITORAGGIO(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Aggiorna Rio Monit.');
    ESITO := ESITO+RETVAL;
    cnt_fnc := cnt_fnc + 1;

    RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_ESP_SC(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Aggiorna Rio ESP SC');
    ESITO := ESITO+RETVAL;
    cnt_fnc := cnt_fnc + 1;

    RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_ESP_SC_ANN(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Aggiorna Rio ESP SC Ann');
    ESITO := ESITO+RETVAL;
    cnt_fnc := cnt_fnc + 1;

    RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_ESP_GE(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Aggiorna Rio ESP GE');
    ESITO := ESITO+RETVAL;
    cnt_fnc := cnt_fnc + 1;

    RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_RIO_ESP_GE_ANN(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Aggiorna Rio ESP GE Ann');
    ESITO := ESITO+RETVAL;
    cnt_fnc := cnt_fnc + 1;

     -- USCITE AUT
    RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_USCITE_AUT(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Aggiorna Uscite Aut');
    ESITO := ESITO+RETVAL;
    cnt_fnc := cnt_fnc + 1;

    -- USCITE MAN
    RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_USCITE_MAN(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Aggiorna Uscite Man');
    ESITO := ESITO+RETVAL;
    cnt_fnc := cnt_fnc + 1;

    -- MV CR
    RETVAL := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_CR_ALL(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - AGGIORNA MV', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Aggiorna CR ALL.');
    ESITO := ESITO+RETVAL;
    CNT_FNC := CNT_FNC + 1;

    /*******************
    *** CLEAN PT-RIO-GB
    *******************/

    -- PT
    RetVal := pkg_mcre0_portale_gest_stati.fnc_delete_pt(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - CLEAN STATI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Delete PT');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    -- RIO
    RetVal := pkg_mcre0_portale_gest_stati.fnc_delete_rio(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - CLEAN STATI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Delete RIO');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    -- GB -4.0
    RetVal := pkg_mcre0_portale_gest_stati.fnc_delete_gb(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - CLEAN STATI', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Delete GB');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    /*******************
    *** ALERT
    *******************/

    -- Verifica alert
    RetVal := MCRE_OWN.PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT(seq);
    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - ALERT', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Verifica ALERT');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;


    --riapertura automatica del portale --v2.9 anticipata qui!
    update T_MCRE0_WRK_CONFIGURAZIONE
    set VALORE_COSTANTE = 1
    where NOME_COSTANTE = 'STATO_PORTALE';
    commit;
--    PKG_MCRE0_AUDIT.log_etl (seq, 'ETL2 - Apertura Portale', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'v2.9', 'anticipata apertura portale');


    /*******************
    *** Sveccchia LOG
    *******************/

    RetVal := PKG_MCRE0_AUDIT.SVECCHIA_LOG_APP;
    PKG_MCRE0_AUDIT.log_etl (seq, 'ETL2 - Sveccchia Log', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Svecchiamento log APP');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;

    RetVal := PKG_MCRE0_AUDIT.SVECCHIA_LOG_ETL;
    PKG_MCRE0_AUDIT.log_etl (seq, 'ETL2 - Sveccchia Log', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Svecchiamento log ETL');
    esito := esito+RetVal;
    cnt_fnc := cnt_fnc + 1;


    --Ver 2.0 inizializzazione T_MCRE0_WRK_SENDING_FILES per estrazione flussi per host
    update MCRE_OWN.T_MCRE0_WRK_SENDING_FILES
    set DTA_EXPORT = sysdate,
    ID_DPER=NULL,
    ESITO=-1,
    RECORD_EXP=NULL,
    RECORD_SC=NULL,
    COMPARTO_NULL=NULL;
    commit;

    --end --> update FLG_ETL_2 a esito
    update MCRE_OWN.T_MCRE0_WRK_ACQUISIZIONE
    set FLG_ETL_2 = esito
    where PERIODO_RIFERIMENTO = (select to_date(max(idper), 'YYYYMMDD') from V_MCRE0_ULTIMA_ACQUISIZIONE);
    commit;


    PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - CARICAMENTO', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'END  - Esito '||esito, 'Terminato ETL2: '||cnt_fnc||' proc lanciate di cui '||(cnt_fnc-esito)||' in errore' );

    return esito;


    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq,'ETL2 - CARICAMENTO', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'Errore in ETL2: '||cnt_fnc||' proc lanciate ' );
        return ko;
    end;



end PKG_MCRE0_ETL_SECONDOLIVELLO;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ETL_SECONDOLIVELLO FOR MCRE_OWN.PKG_MCRE0_ETL_SECONDOLIVELLO;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ETL_SECONDOLIVELLO FOR MCRE_OWN.PKG_MCRE0_ETL_SECONDOLIVELLO;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ETL_SECONDOLIVELLO TO MCRE_USR;

