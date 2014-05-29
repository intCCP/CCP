CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_AGGIORNA_MV" AS
/******************************************************************************
   NAME:       PKG_MCRE0_AGGIORNA_MV
   PURPOSE:    aggiorna le diverse Materialized View

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29/11/2010          M.Murro. Created this package.
   1.1        23/12/2010          M.Nurro  Aggiunte nuove MV V_
   2.0        11/01/2011  V.Galli M.Murro  Aggiunta gestione MV FAST
   2.1        13/01/2011          M.Murro  Aggiunta gestione mv_last_percorso
   2.2        21/01/2011          V.Galli   First Fast
   2.3        26/01/2011          V.Galli   Grant x LOG
   2.4        01/02/2011          V.Galli   Aggiorna Istituti + log
   2.5        07/02/2011          V.Galli   Aggiorna uscite man e aut
   2.6        14/02/2011          V.Galli   Flg_outsourcing in Log Upd_Field
   2.7        22/03/2011          V.Galli   Refresh MV RIO
   2.8        27/04/2011          M.Murro   Rimosso drop e create log su istituti
   2.9        03/05/2011          V.Galli   aggiorna_CR
   2.9        06/05/2011          V.Galli   aggiorna_CR RI SC SO
   3.0        18/05/2011          M.Murro   Variato Atomic_refresh su Ana_Gen
   3.1        23/05/2011          V.Galli   Aggiunta creazione LOG per GB_GESTIONE
   3.2        25/05/2011          V.Galli   Aggiunta refresh all CR per cambio mense
   3.3        26/05/2011          V.Galli   Create/Drop log GB_GESTIONE
   3.4        27/05/2011          V.Galli   Nuovo Log GB
   3.5        31/05/2011          V.Galli   Nuovo gruppo Fast
   3.5        08/06/2011          V.Galli   Nuovi Log MP-GB-ALL
   3.6        08/06/2011          V.Galli   Cambiata logica LOG
   3.7        15/06/2011          M.Murro   Nuova Ana_Gen
   3.8        17/06/2011          V.Galli   Log new PCR con cartolarizzato
   4.0        25/07/2011          M.Murro   TUNING - nuova struttura
   4.1        26/08/2011          M.Murro   versione ponte con doppia AnaGen
   4.2        06/10/2011          M.Murro   inibita calcolo CR_ALL
   4.3        21/11/2011          M.Murro   Variato Atomic_refresh su RioEsp, Mon e Uscite
   5.0        19/11/2012           V.Galli     Aggiunte MV CR_NEW e SCHEDA_ANAG_SCPC2 e refresh serale in aggiorna_AnaGen
   5.1        23/01/2013          I.Gueorguieva Aggiunto campo cod_livello nella insert di aggiorna_USCITE_AUT
******************************************************************************/

  --4.1 aggiorna la MV Anagrafica_Generale (originale, ex aggiorna_AnaGen)
  FUNCTION aggiorna_AnaGenETL(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN number IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_ANAGRAFICA_GENERALE'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       ,ATOMIC_REFRESH       => FALSE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    EXCEPTION WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    end;


    FUNCTION aggiorna_AnaGen_prova(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN varchar2 IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
    RetVal number :=0;
    esito number := ok;
    /**** VG - MV per nuova gestione alert ****/
    V_NOTE T_MCRE0_WRK_AUDIT_ETL.NOTE%TYPE:='GENERALE';
    v_esito number:=-1;
    v_flg_refresh_mv_cr number(1):= 0;
    v_flg_refresh_mv_pc number(1):= 0;
  begin


    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    --chiamo AnaGen originale
--    RetVal := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_AnaGenETL(V_COD_LOG);

    --restore Mople
--    RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_MOPLE(V_COD_LOG);
    IF RetVal = KO THEN
     PKG_MCRE0_AUDIT.log_etl (V_COD_LOG,'PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_MOPLE', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito '||RetVal, 'Restore Mople Terminato con errore ');
     esito := ko;
     --andrebbe bloccato l'intero caricamento notturno.. 1o livello
    END IF;
    PKG_MCRE0_AUDIT.log_etl (V_COD_LOG,'PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_MOPLE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Restore Mople');

--    RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_FILE_GUIDA(V_COD_LOG);
    IF RetVal = KO THEN
     PKG_MCRE0_AUDIT.log_etl (V_COD_LOG,'PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_FILE_GUIDA', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito '||RetVal, 'Restore FGuida Terminato con errore ');
     esito := ko;
     --andrebbe bloccato l'intero caricamento notturno.. 1o livello
    END IF;
    PKG_MCRE0_AUDIT.log_etl (V_COD_LOG,'PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_FILE_GUIDA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito FGuida Mople');

   /**** VG - MV per nuova gestione alert ****/
--    begin
--        select a.valore_costante,b.valore_costante
--        into v_flg_refresh_mv_cr, v_flg_refresh_mv_pc
--        from
--            (select valore_costante
--            from T_MCRE0_WRK_CONFIGURAZIONE c
--            where C.NOME_COSTANTE = 'REFRESH_MV_CR_NEW') a,
--            (select valore_costante
--            from T_MCRE0_WRK_CONFIGURAZIONE c
--            where C.NOME_COSTANTE = 'REFRESH_MV_SCHEDA_ANAG_SCPC2') b;
--    exception
--      when others then
--        v_flg_refresh_mv_cr := 0;
--        v_flg_refresh_mv_pc := 0;
--    end;
--
--    if(v_flg_refresh_mv_pc=1)then
--        V_NOTE := 'Alert BATCH - Refresh MV SCHEDA_ANAG_SCPC2 ';
--        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
--        v_esito := AGGIORNA_SCHEDA_ANAG_SCPC2(V_COD_LOG);
--    end if;
--
--    if(v_flg_refresh_mv_cr=1)then
--        V_NOTE := 'Alert BATCH - Refresh MV CR_NEW ';
--        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
--        v_esito := AGGIORNA_CR_NEW(V_COD_LOG);
--    end if;
--
--    if esito = ok then
--      return ok;
--      --andrebbe bloccato l'intero caricamento notturno.. 1o livello
--    else
--      return ko;
--    end if;

--    return SUBSTR(sqlerrm, 1, INSTR(sqlerrm, ':' )-1);

    return SUBSTR(sqlerrm, 1, INSTR(sqlerrm, ':' )-1);

    EXCEPTION WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Errore!!!');
        return SUBSTR(sqlerrm, 1, INSTR(sqlerrm, ':' )-1);
--         return ko;

    end;

  --4.1 rimane per la shell delle 23: chiama anche le Restore Guida e Mople
  FUNCTION aggiorna_AnaGen(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
    RetVal number :=0;
    esito number := ok;
    /**** VG - MV per nuova gestione alert ****/
    V_NOTE T_MCRE0_WRK_AUDIT_ETL.NOTE%TYPE:='GENERALE';
    v_esito number:=-1;
    v_flg_refresh_mv_cr number(1):= 0;
    v_flg_refresh_mv_pc number(1):= 0;
  begin


    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    --chiamo AnaGen originale
    RetVal := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.aggiorna_AnaGenETL(V_COD_LOG);

    --restore Mople
    RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_MOPLE(V_COD_LOG);
    IF RetVal = KO THEN
     PKG_MCRE0_AUDIT.log_etl (V_COD_LOG,'PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_MOPLE', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito '||RetVal, 'Restore Mople Terminato con errore ');
     esito := ko;
     --andrebbe bloccato l'intero caricamento notturno.. 1o livello
    END IF;
    PKG_MCRE0_AUDIT.log_etl (V_COD_LOG,'PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_MOPLE', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito Restore Mople');

    RetVal := MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_FILE_GUIDA(V_COD_LOG);
    IF RetVal = KO THEN
     PKG_MCRE0_AUDIT.log_etl (V_COD_LOG,'PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_FILE_GUIDA', PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'Esito '||RetVal, 'Restore FGuida Terminato con errore ');
     esito := ko;
     --andrebbe bloccato l'intero caricamento notturno.. 1o livello
    END IF;
    PKG_MCRE0_AUDIT.log_etl (V_COD_LOG,'PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_FILE_GUIDA', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Esito '||RetVal, 'eseguito FGuida Mople');

   /**** VG - MV per nuova gestione alert ****/
    begin
        select a.valore_costante,b.valore_costante
        into v_flg_refresh_mv_cr, v_flg_refresh_mv_pc
        from
            (select valore_costante
            from T_MCRE0_WRK_CONFIGURAZIONE c
            where C.NOME_COSTANTE = 'REFRESH_MV_CR_NEW') a,
            (select valore_costante
            from T_MCRE0_WRK_CONFIGURAZIONE c
            where C.NOME_COSTANTE = 'REFRESH_MV_SCHEDA_ANAG_SCPC2') b;
    exception
      when others then
        v_flg_refresh_mv_cr := 0;
        v_flg_refresh_mv_pc := 0;
    end;

    if(v_flg_refresh_mv_pc=1)then
        V_NOTE := 'Alert BATCH - Refresh MV SCHEDA_ANAG_SCPC2 ';
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
        v_esito := AGGIORNA_SCHEDA_ANAG_SCPC2(V_COD_LOG);
    end if;

    if(v_flg_refresh_mv_cr=1)then
        V_NOTE := 'Alert BATCH - Refresh MV CR_NEW ';
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
        v_esito := AGGIORNA_CR_NEW(V_COD_LOG);
    end if;

    if esito = ok then
      return ok;
      --andrebbe bloccato l'intero caricamento notturno.. 1o livello
    else
      return ko;
    end if;

--    return SUBSTR(sqlerrm, 1, INSTR(sqlerrm, ':' )-1);

    EXCEPTION WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_AnaGen',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Errore!!!');
--        return SUBSTR(sqlerrm, 1, INSTR(sqlerrm, ':' )-1);
         return ko;

    end;

  --aggiorna la MV_MCRE0_APP_PCR_GB_AGGR
  FUNCTION aggiorna_PCR_GB(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

       PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_GB',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_PCR_GB_AGGR'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

       PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_GB',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    EXCEPTION WHEN OTHERS THEN
         PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_GB',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    end;

  --aggiorna la MV_MCRE0_APP_PCR_GE_SB_AGGR
  FUNCTION aggiorna_PCR_GE(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

      IF( P_COD_LOG IS NULL) THEN
          SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
          INTO V_COD_LOG
          from dual;
      ELSE
        V_COD_LOG := P_COD_LOG;
      end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_GE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_PCR_GE_SB_AGGR'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_GE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_GE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    end;

  --aggiorna la MV_MCRE0_APP_PCR_SC_SB_AGGR
  FUNCTION aggiorna_PCR_SC(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
   V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_SC',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_PCR_SC_SB_AGGR'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_SC',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_PCR_SC',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;
    end;

  --aggiorna la V_MCRE0_APP_ELENCO_POS
  FUNCTION aggiorna_ELENCO_POS(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_ELENCO_POS',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.V_MCRE0_APP_ELENCO_POS'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_ELENCO_POS',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_ELENCO_POS',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;
    end;

  --aggiorna la V_MCRE0_APP_HP_EXCEL
  FUNCTION aggiorna_HP_EXCEL(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_HP_EXCEL',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.V_MCRE0_APP_HP_EXCEL'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_HP_EXCEL',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_HP_EXCEL',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    end;

  --aggiorna la MV_MCRE0_APP_ISTITUTI
  FUNCTION aggiorna_ISTITUTI(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_ISTITUTI',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      Dbms_Mview.Refresh(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_ISTITUTI'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_ISTITUTI',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_ISTITUTI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    end;

  --aggiorna la V_MCRE0_APP_POSIZIONI_STATO
  FUNCTION aggiorna_POSIZIONI_STATO(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
   V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_POSIZIONI_STATO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.V_MCRE0_APP_POSIZIONI_STATO'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_POSIZIONI_STATO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_POSIZIONI_STATO',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;
    end;

  --aggiorna la V_MCRE0_APP_SCHEDA_ANAG_MOV
  FUNCTION aggiorna_LAST_PERCORSO(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_LAST_PERCORSO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_LAST_PERCORSO'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_LAST_PERCORSO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_LAST_PERCORSO',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    end;

  --aggiorna la MV_MCRE0_APP_PT_POS_USCITE_AUT
  FUNCTION aggiorna_USCITE_AUT(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_USCITE_AUT',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_PT_POS_USCITE_AUT'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       ,ATOMIC_REFRESH       => FALSE --v4.3
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_USCITE_AUT',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_USCITE_AUT',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    end;

  --aggiorna la MV_MCRE0_APP_PT_POS_USCITE_MAN
  FUNCTION aggiorna_USCITE_MAN(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_USCITE_MAN',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_PT_POS_USCITE_MAN'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       ,ATOMIC_REFRESH       => FALSE --v4.3
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_USCITE_MAN',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_USCITE_MAN',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;
    end;

  --aggiorna la MV_MCRE0_APP_RIO_MONITORAGGIO
  FUNCTION aggiorna_RIO_MONITORAGGIO(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_Monitoraggio',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_RIO_MONITORAGGIO'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       ,ATOMIC_REFRESH       => FALSE --v4.3
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_Monitoraggio',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_Monitoraggio',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    end;

  --aggiorna la MV_MCRE0_APP_RIO_ESP_SC
  FUNCTION aggiorna_RIO_ESP_SC(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
   V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_SC',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_RIO_ESP_SC'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       ,ATOMIC_REFRESH       => FALSE --v4.3
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_SC',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_SC',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;
    end;

  --aggiorna la MV_MCRE0_APP_RIO_ESP_SC_ANN
  FUNCTION aggiorna_RIO_ESP_SC_ANN(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_SC_ANN',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_RIO_ESP_SC_ANN'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       ,ATOMIC_REFRESH       => FALSE --v4.3
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_SC_ANN',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_SC_ANN',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    end;


    --aggiorna la MV_MCRE0_APP_RIO_ESP_GE
  FUNCTION aggiorna_RIO_ESP_GE(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_GE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_RIO_ESP_GE'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       ,ATOMIC_REFRESH       => FALSE --v4.3
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_GE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_GE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;
    end;

    --aggiorna la MV_MCRE0_APP_RIO_ESP_GE_ANN
  FUNCTION aggiorna_RIO_ESP_GE_ANN(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_GE_ANN',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_RIO_ESP_GE_ANN'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       ,ATOMIC_REFRESH       => FALSE --v4.3
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_GE_ANN',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_RIO_ESP_GE_ANN',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    end;

      --aggiorna la MV_MCRE0_DENORM_STR_ORG
  FUNCTION aggiorna_DENORM_STR_ORG(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
   V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

     PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_DENORM_STR_ORG',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_DENORM_STR_ORG'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,HEAP_SIZE            => 3
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_DENORM_STR_ORG',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_DENORM_STR_ORG',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;
    END;

  --aggiorna la MV_MCRE0_APP_CR
  FUNCTION aggiorna_CR(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_CR'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    END;

     --aggiorna la MV_MCRE0_APP_CR_RI
  FUNCTION aggiorna_CR_RI(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_RI',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.refresh(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_CR_RI'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_RI',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    EXCEPTION when OTHERS then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_RI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    END;

  --aggiorna la MV_MCRE0_APP_CR_SC
  FUNCTION aggiorna_CR_SC(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_SC',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.refresh(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_CR_SC'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_SC',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_SC',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    END;

  --aggiorna la MV_MCRE0_APP_CR_SO
  FUNCTION aggiorna_CR_SO(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_SO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.refresh(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_CR_SO'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_SO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    EXCEPTION when OTHERS then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_SO',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    END;

   --aggiorna tutte le MV di CR solo quando cambia il mese CR
  FUNCTION AGGIORNA_CR_ALL(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
   V_ESITO NUMBER:=KO;
   V_EXISTS NUMBER:=0;
   V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  BEGIN

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_ALL',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');
--      begin
--        SELECT 1
--        into v_exists
--        FROM
--          (SELECT MAX(C.dta_fine_mese) DTA_RIF
--          FROM mv_MCRE0_APP_CR C) A,
--          (SELECT MAX(C.DTA_RIFERIMENTO_CR) dta_rif
--          FROM T_MCRE0_APP_CR_SC_GB C) B
--        WHERE A.DTA_RIF=B.DTA_RIF;
--      EXCEPTION
--        WHEN NO_DATA_FOUND THEN
--          V_EXISTS := 0;
--        WHEN OTHERS THEN
--          V_EXISTS := 0;
--      END;
--      IF(V_EXISTS=0)THEN
--        V_ESITO:=V_ESITO*AGGIORNA_CR(V_COD_LOG);
--        V_ESITO:=V_ESITO*AGGIORNA_CR_RI(V_COD_LOG);
--        V_ESITO:=V_ESITO*AGGIORNA_CR_SC(V_COD_LOG);
--        V_ESITO:=V_ESITO*AGGIORNA_CR_SO(V_COD_LOG);
--      END IF;
      v_esito := ok;
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_ALL',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,'Dati gi¿ caricati','END');
      return v_esito;

    EXCEPTION
      when OTHERS then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_CR_ALL',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;

    END;

    FUNCTION  aggiorna_POS_STATO_ST(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
      begin

       IF( P_COD_LOG IS NULL) THEN
          SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
          INTO V_COD_LOG
          from dual;
      ELSE
        V_COD_LOG := P_COD_LOG;
      end if;

          PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_POS_STATO_ST',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

          DBMS_MVIEW.REFRESH(
            LIST                 => 'MCRE_OWN.MV_MCRE0_APP_POS_STATO_ST'
           ,METHOD               => 'C'
           ,PURGE_OPTION         => 1
           ,PARALLELISM          => 4
           --,ATOMIC_REFRESH       => TRUE
           ,NESTED               => FALSE);

          PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_POS_STATO_ST',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
          return ok;

        exception when others then
            PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,C_PACKAGE||'.aggiorna_POS_STATO_ST',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
            return ko;

        END;

  --cancella i log
  FUNCTION drop_snp_log(P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL) RETURN NUMBER IS

    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;

    cursor c is
    select distinct 'drop materialized view log on '|| a.MASTER mysql
    from user_snapshot_logs a;

  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.drop_snp_log',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');


    begin
    for v in c
    loop
        execute immediate v.mysql;
    end loop;

    end;


    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.drop_snp_log',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');

    return ok;

  end;

  --ricrea i log
  FUNCTION create_snp_log(P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL) RETURN NUMBER IS

    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;


    TYPE mytables IS TABLE OF VARCHAR2(255);
    p_tables mytables:=mytables(
                                'T_MCRE0_APP_FILE_GUIDA24',
                                'T_MCRE0_APP_MOPLE24',
                                'T_MCRE0_APP_PCR24',
                                'T_MCRE0_APP_ANAGR_GRE24',
                                'T_MCRE0_APP_ABI_ELABORATI24',
                                'T_MCRE0_APP_ANAGRAFICA_GRUPPO2',
                                'T_MCRE0_APP_GB_GESTIONE',
                                'T_MCRE0_APP_ISTITUTI_ALL',
                                'T_MCRE0_APP_UTENTI');
    i integer;

    cursor c is
    select distinct 'GRANT select on  '|| a.LOG_TABLE||' to mcre_app' mysql
    from user_snapshot_logs a
    union
    select distinct 'GRANT select on  '|| a.LOG_TABLE||' to mcre_usr' mysql
    from user_snapshot_logs a  ;


  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.create_snp_log',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

    begin

    for i IN p_tables.FIRST .. p_tables.LAST
    loop
    execute immediate 'create materialized view log on '||p_tables(i) ||
                      ' TABLESPACE TSD_MCRE_OWN NOCACHE NOLOGGING '||
                       case when i<4 then 'parallel(degree 2 instances 1) ' else 'NOPARALLEL  ' end ||
                      'WITH ROWID '||
                      case when i<4 then 'INCLUDING NEW VALUES' else '' end;
--    execute immediate 'create materialized view log on '||p_tables(i) ||
--                      ' TABLESPACE TSD_MCRE_OWN NOCACHE NOLOGGING '||
--                       case when i<4 then 'parallel(degree 2 instances 1) ' else 'NOPARALLEL  ' end ||
--                      'WITH ROWID INCLUDING NEW VALUES' ;

    end loop;

    end;

    begin
    for v in c
    loop
        execute immediate v.mysql;
    end loop;

    exception
     WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,C_PACKAGE||'.create_snp_log',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GRANT LOG');
    end;

    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.create_snp_log',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');

    return ok;

  end;

  -- aggiornamento FAST -- da chiamare da portale
  FUNCTION REFRESH_FAST_SNP(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE DEFAULT NULL,
    P_UTENTE  T_MCRE0_APP_UTENTI.COD_MATRICOLA%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
  begin
    return ok;

  EXCEPTION WHEN OTHERS THEN
   PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,C_PACKAGE||'.REFRESH_FAST_SNP',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'REFRESH FAST MV',P_UTENTE);
   return ko;

  end;

   -- aggiornamento FAST -- da Lancia_Tutto (ETL_Secondo_Livello)
  FUNCTION refresh_first_fast_snp(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin
    return ok;

  EXCEPTION WHEN OTHERS THEN
   PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,C_PACKAGE||'.refresh_first_fast_snp',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'REFRESH FAST - FIRST');
   return ko;

  end;

  --refresh complete
  FUNCTION refresh_complete_snp(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
    V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin
    return ok;
  EXCEPTION WHEN OTHERS THEN
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,C_PACKAGE||'.refresh_complete_snp',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'REFRESH COMPLETE');
    return ko;
  end;

  FUNCTION AGGIORNA_SCHEDA_ANAG_SCPC2(
        P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
         V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_scheda_anag_scpc2',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_SCHEDA_ANAG_SCPC2'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_scheda_anag_scpc2',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_scheda_anag_scpc2',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;
    END;

  FUNCTION AGGIORNA_CR_NEW(
        P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER IS
         V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_cr_new',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

      DBMS_MVIEW.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_CR_NEW'
       ,METHOD               => 'C'
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 4
       --,ATOMIC_REFRESH       => TRUE
       ,NESTED               => FALSE);

      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_cr_new',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'END');
      return ok;

    exception when others then
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.aggiorna_cr_new',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
        return ko;
    END;

end PKG_MCRE0_AGGIORNA_MV;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_AGGIORNA_MV FOR MCRE_OWN.PKG_MCRE0_AGGIORNA_MV;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_AGGIORNA_MV FOR MCRE_OWN.PKG_MCRE0_AGGIORNA_MV;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_AGGIORNA_MV TO MCRE_USR;

