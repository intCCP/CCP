CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_ALERT AS
/******************************************************************************
   NAME:     PKG_MCRE0_ALERT
   PURPOSE: Gestione alert ed evidenze

   REVISIONS:
       Ver        Date        Author             Description
   ---------  ----------    -----------------  ------------------------------------
   1.0        22/10/2012  Galli Valeria      Created this package.
   2.0        05/11/2012  Galli Valeria      Calcolo per gruppi.
   2.1       07/11/2012  Galli Valeria      SOLO SYSTEM! - merge su alert_pos vera!
   2.2       19/11/2012  Galli Valeria      Tolto refresh MV
   2.3       05/12/2012  Michele Ceru'      Agiunto alert 45
   2.4      09/01/2013  Galli Valeria       Queue
   2.5      10/01/2013    Michele Ceru'     Commentati alert 22,23 e 24
   2.6      22/10/2013    Michele Ceru'     Scommentati alert 22 e 23, commentato alert 45
   3.0      22/05/2013    M.Murro           Aggiunta chiamata alert mcrei se utente valorizzato
******************************************************************************/


  FUNCTION fnc_verifica_alert_accesi(
    p_cod_abi_cartolarizzato   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    p_cod_sndg  T_MCRE0_APP_ALL_DATA.COD_SNDG%TYPE,
    P_ID_UTENTE T_MCRE0_APP_UTENTI.ID_UTENTE%TYPE,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER IS

    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:='GENERALE';
    v_flg_pos number(1):=1;
    v_batch_in_corso t_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type:=0;

  begin
    V_NOTE := 'Alert - Calcolo codide log - ABI='||p_cod_abi_cartolarizzato||' NDG='||p_cod_ndg||' SNDG='||P_COD_SNDG;
     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    V_NOTE := 'Alert - Controllo Batch attivo- ABI='||p_cod_abi_cartolarizzato||' NDG='||p_cod_ndg||' SNDG='||P_COD_SNDG;
   -- PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,c_package||'.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note,P_ID_UTENTE);

    begin
        select VALORE_COSTANTE
        into   v_batch_in_corso
        from t_MCRE0_WRK_CONFIGURAZIONE
        where NOME_COSTANTE = 'EXEC_ALERT_BATCH';
    exception
        when others then
            v_batch_in_corso := 0;
    end;

    if(v_batch_in_corso=1) then
        V_NOTE := 'Alert - QUEUE (Batch attivo) - ABI='||p_cod_abi_cartolarizzato||' NDG='||p_cod_ndg||' SNDG='||P_COD_SNDG;
        PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,c_package||'.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note,P_ID_UTENTE);
        begin
            insert into t_mcre0_app_alert_pos_queue
            (cod_abi_cartolarizzato,cod_ndg,cod_sndg,id_utente,COD_LOG)
            values(p_cod_abi_cartolarizzato,p_cod_ndg,p_cod_sndg,p_id_utente,p_COD_LOG);
            commit;
         exception
           when others then
                PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,c_package||'.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note,P_ID_UTENTE);
         end;
    else

            V_NOTE := 'Alert - Merge - ABI='||p_cod_abi_cartolarizzato||' NDG='||p_cod_ndg||' SNDG='||P_COD_SNDG;
            PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,c_package||'.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_DEBUG,0,0,'INIZIO '||v_note,P_ID_UTENTE);

            if(p_cod_abi_cartolarizzato is not null and p_cod_ndg is not null) then
              v_flg_pos := 1;
            elsif(p_cod_sndg is not null) then
              v_flg_pos := 0;
            end if;

            merge into t_mcre0_app_alert_pos d using (
                select *
                from v_mcre0_app_alert_load
                where (v_flg_pos = 1
                           and cod_abi_cartolarizzato = p_cod_abi_cartolarizzato
                           and cod_ndg = p_cod_ndg)
                      or (v_flg_pos = 0
                           and cod_sndg = p_cod_sndg )
                ) s
            on ( d.cod_abi_cartolarizzato = s.cod_abi_cartolarizzato
                   and d.cod_ndg = s.COD_ndg)
            when not matched then
            insert
            (
                    d.COD_ABI_CARTOLARIZZATO,
                    d.COD_ABI_istituto,
                    d.COD_NDG,
                    d.COD_SNDG,
                    d.ALERT_1,
                    d.COD_STATO_1,
                    d.DTA_INS_1,
                    d.DTA_UPD_1,
                    d.ALERT_2,
                    d.COD_STATO_2,
                    d.DTA_INS_2,
                    d.DTA_UPD_2,
                    d.ALERT_3,
                    d.COD_STATO_3,
                    d.DTA_INS_3,
                    d.DTA_UPD_3,
                    d.ALERT_4,
                    d.COD_STATO_4,
                    d.DTA_INS_4,
                    d.DTA_UPD_4,
                    d.ALERT_5,
                    d.COD_STATO_5,
                    d.DTA_INS_5,
                    d.DTA_UPD_5,
                    d.ALERT_6,
                    d.COD_STATO_6,
                    d.DTA_INS_6,
                    d.DTA_UPD_6,
                    d.ALERT_7,
                    d.COD_STATO_7,
                    d.DTA_INS_7,
                    d.DTA_UPD_7,
                    d.ALERT_8,
                    d.COD_STATO_8,
                    d.DTA_INS_8,
                    d.DTA_UPD_8,
                    d.ALERT_11,
                    d.COD_STATO_11,
                    d.DTA_INS_11,
                    d.DTA_UPD_11,
                    d.ALERT_12,
                    d.COD_STATO_12,
                    d.DTA_INS_12,
                    d.DTA_UPD_12,
                    d.ALERT_13,
                    d.COD_STATO_13,
                    d.DTA_INS_13,
                    d.DTA_UPD_13,
                    d.ALERT_14,
                    d.COD_STATO_14,
                    d.DTA_INS_14,
                    d.DTA_UPD_14,
                    d.ALERT_15,
                    d.COD_STATO_15,
                    d.DTA_INS_15,
                    d.DTA_UPD_15,
                    d.ALERT_16,
                    d.COD_STATO_16,
                    d.DTA_INS_16,
                    d.DTA_UPD_16,
                    d.ALERT_17,
                    d.COD_STATO_17,
                    d.DTA_INS_17,
                    d.DTA_UPD_17,
                    d.ALERT_18,
                    d.COD_STATO_18,
                    d.DTA_INS_18,
                    d.DTA_UPD_18,
                    d.ALERT_19,
                    d.COD_STATO_19,
                    d.DTA_INS_19,
                    d.DTA_UPD_19,
                    d.ALERT_20,
                    d.COD_STATO_20,
                    d.DTA_INS_20,
                    d.DTA_UPD_20,
                    d.ALERT_21,
                    d.COD_STATO_21,
                    d.DTA_INS_21,
                    d.DTA_UPD_21,
                    d.ALERT_22,
                    d.COD_STATO_22,
                    d.DTA_INS_22,
                    d.DTA_UPD_22,
                    d.ALERT_23,
                    d.COD_STATO_23,
                    d.DTA_INS_23,
                    d.DTA_UPD_23,
--                    d.ALERT_24,
--                    d.COD_STATO_24,
--                    d.DTA_INS_24,
--                    d.DTA_UPD_24,
                    d.ALERT_25,
                    d.DTA_INS_25,
                    d.DTA_UPD_25,
                    d.COD_STATO_25,
                    d.ALERT_40,
                    d.COD_STATO_40,
                    d.DTA_INS_40,
                    d.DTA_UPD_40,
                    d.ALERT_41,
                    d.COD_STATO_41,
                    d.DTA_INS_41,
                    d.DTA_UPD_41
            )
            values
            (
                    s.COD_ABI_CARTOLARIZZATO,
                    s.COD_ABI_ISTITUTO,
                    s.COD_NDG,
                    s.COD_SNDG,
                    s.ALERT_1,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_2,
                    s.COD_STATo,
                    sysdate,
                    sysdate,
                    s.ALERT_3,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_4,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_5,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_6,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_7,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_8,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_11,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_12,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_13,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_14,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_15,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_16,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_17,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_18,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_19,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_20,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_21,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_22,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
                    s.ALERT_23,
                    s.COD_STATO,
                    sysdate,
                    sysdate,
--                    s.ALERT_24,
--                    s.COD_STATO,
--                    sysdate,
--                    sysdate,
                    s.ALERT_25,
                    sysdate,
                    sysdate,
                    s.COD_STATO,
                    s.ALERT_40,
                    s.COD_STATo,
                    sysdate,
                    sysdate,
                    s.ALERT_41,
                    s.COD_STATO,
                    sysdate,
                    sysdate
            )
            when matched then update set
                d.ALERT_1    = s.ALERT_1,
                d.COD_STATO_1    = s.COD_STATO,
                d.DTA_UPD_1    = s.DTA_UPD_1,
                d.FLG_WORSE_UPD_1    = s.FLG_WORSE_UPD_1,
                d.ALERT_2    = s.ALERT_2,
                d.COD_STATO_2    = s.COD_STATO,
                d.DTA_UPD_2    = s.DTA_UPD_2,
                d.FLG_WORSE_UPD_2    = s.FLG_WORSE_UPD_2,
                d.ALERT_3    = s.ALERT_3,
                d.COD_STATO_3    = s.COD_STATO,
                d.DTA_UPD_3    = s.DTA_UPD_3,
                d.FLG_WORSE_UPD_3    = s.FLG_WORSE_UPD_3,
                d.ALERT_4    = s.ALERT_4,
                d.COD_STATO_4    = s.COD_STATO,
                d.DTA_UPD_4    = s.DTA_UPD_4,
                d.FLG_WORSE_UPD_4    = s.FLG_WORSE_UPD_4,
                d.ALERT_5    = s.ALERT_5,
                d.COD_STATO_5    = s.COD_STATO,
                d.DTA_UPD_5    = s.DTA_UPD_5,
                d.FLG_WORSE_UPD_5    = s.FLG_WORSE_UPD_5,
                d.ALERT_6    = s.ALERT_6,
                d.COD_STATO_6    = s.COD_STATO,
                d.DTA_UPD_6    = s.DTA_UPD_6,
                d.FLG_WORSE_UPD_6    = s.FLG_WORSE_UPD_6,
                d.ALERT_7    = s.ALERT_7,
                d.COD_STATO_7    = s.COD_STATO,
                d.DTA_UPD_7    = s.DTA_UPD_7,
                d.FLG_WORSE_UPD_7    = s.FLG_WORSE_UPD_7,
                d.ALERT_8    = s.ALERT_8,
                d.COD_STATO_8    = s.COD_STATO,
                d.DTA_UPD_8    = s.DTA_UPD_8,
                d.FLG_WORSE_UPD_8    = s.FLG_WORSE_UPD_8,
                d.ALERT_11    = s.ALERT_11,
                d.COD_STATO_11    = s.COD_STATO,
                d.DTA_UPD_11    = s.DTA_UPD_11,
                d.FLG_WORSE_UPD_11    = s.FLG_WORSE_UPD_11,
                d.ALERT_12    = s.ALERT_12,
                d.COD_STATO_12    = s.COD_STATO,
                d.DTA_UPD_12    = s.DTA_UPD_12,
                d.FLG_WORSE_UPD_12    = s.FLG_WORSE_UPD_12,
                d.ALERT_13    = s.ALERT_13,
                d.COD_STATO_13    = s.COD_STATO,
                d.DTA_UPD_13    = s.DTA_UPD_13,
                d.FLG_WORSE_UPD_13    = s.FLG_WORSE_UPD_13,
                d.ALERT_14    = s.ALERT_14,
                d.COD_STATO_14    = s.COD_STATO,
                d.DTA_UPD_14    = s.DTA_UPD_14,
                d.FLG_WORSE_UPD_14    = s.FLG_WORSE_UPD_14,
                d.ALERT_15    = s.ALERT_15,
                d.COD_STATO_15    = s.COD_STATO,
                d.DTA_UPD_15    = s.DTA_UPD_15,
                d.FLG_WORSE_UPD_15    = s.FLG_WORSE_UPD_15,
                d.ALERT_16    = s.ALERT_16,
                d.COD_STATO_16    = s.COD_STATO,
                d.DTA_UPD_16    = s.DTA_UPD_16,
                d.FLG_WORSE_UPD_16    = s.FLG_WORSE_UPD_16,
                d.ALERT_17    = s.ALERT_17,
                d.COD_STATO_17    = s.COD_STATO,
                d.DTA_UPD_17    = s.DTA_UPD_17,
                d.FLG_WORSE_UPD_17    = s.FLG_WORSE_UPD_17,
                d.ALERT_18    = s.ALERT_18,
                d.COD_STATO_18    = s.COD_STATO,
                d.DTA_UPD_18    = s.DTA_UPD_18,
                d.FLG_WORSE_UPD_18    = s.FLG_WORSE_UPD_18,
                d.ALERT_19    = s.ALERT_19,
                d.COD_STATO_19    = s.COD_STATO,
                d.DTA_UPD_19    = s.DTA_UPD_19,
                d.FLG_WORSE_UPD_19    = s.FLG_WORSE_UPD_19,
                d.ALERT_20    = s.ALERT_20,
                d.COD_STATO_20    = s.COD_STATO,
                d.DTA_UPD_20    = s.DTA_UPD_20,
                d.FLG_WORSE_UPD_20    = s.FLG_WORSE_UPD_20,
                d.ALERT_21    = s.ALERT_21,
                d.COD_STATO_21    = s.COD_STATO,
                d.DTA_UPD_21    = s.DTA_UPD_21,
                d.FLG_WORSE_UPD_21    = s.FLG_WORSE_UPD_21,
                d.ALERT_22    = s.ALERT_22,
                d.COD_STATO_22    = s.COD_STATO,
                d.DTA_UPD_22    = s.DTA_UPD_22,
                d.FLG_WORSE_UPD_22    = s.FLG_WORSE_UPD_22,
                d.ALERT_23    = s.ALERT_23,
                d.COD_STATO_23    = s.COD_STATO,
                d.DTA_UPD_23    = s.DTA_UPD_23,
                d.FLG_WORSE_UPD_23    = s.FLG_WORSE_UPD_23,
--                d.ALERT_24    = s.ALERT_24,
--                d.COD_STATO_24    = s.COD_STATO,
--                d.DTA_UPD_24    = s.DTA_UPD_24,
--                d.FLG_WORSE_UPD_24    = s.FLG_WORSE_UPD_24,
                d.ALERT_25    = s.ALERT_25,
                d.DTA_UPD_25    = s.DTA_UPD_25,
                d.COD_STATO_25    = s.COD_STATO,
                d.FLG_WORSE_UPD_25    = s.FLG_WORSE_UPD_25,
                d.ALERT_40    = s.ALERT_40,
                d.COD_STATO_40    = s.COD_STATO,
                d.DTA_UPD_40    = s.DTA_UPD_40,
                d.FLG_WORSE_UPD_40    = s.FLG_WORSE_UPD_40,
                d.ALERT_41    = s.ALERT_41,
                d.COD_STATO_41    = s.COD_STATO,
                d.DTA_UPD_41    = s.DTA_UPD_41,
                d.FLG_WORSE_UPD_41    = s.FLG_WORSE_UPD_41;PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,c_package||'.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_DEBUG,0,0,'FINE '||v_note,P_ID_UTENTE);
    end if;
    return ok;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,c_package||'.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note,P_ID_UTENTE);
     return ko;
  END;

   FUNCTION fnc_batch_alert_accesi(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER IS

    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:='GENERALE';
    v_esito number:=-1;

  begin
    V_NOTE := 'Alert BATCH - Calcolo codide log ';
     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    execute immediate 'ALTER SESSION ENABLE PARALLEL DML';

    V_NOTE := 'START - Alert BATCH - GENERALE ';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_accesi',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);

    -- Truncate tabella temporanea e refresh MV
    v_esito := fnc_batch_trunc_pos_tmp(V_COD_LOG);
    -- Gruppo1 (Alert 1-7)
    v_esito := v_esito * fnc_batch_alert_gruppo_1(V_COD_LOG);
    -- Gruppo2 (Alert 11-17)'
    v_esito := v_esito * fnc_batch_alert_gruppo_2(V_COD_LOG);
    -- Gruppo3 (Alert 18-21 e 8 e 40-41)
    v_esito := v_esito * fnc_batch_alert_gruppo_3(V_COD_LOG);
    -- Gruppo4 (Alert 22-25)
    v_esito := v_esito * fnc_batch_alert_gruppo_4(V_COD_LOG);
    -- Popolo alert_pos_new
    v_esito := v_esito * fnc_batch_load_alert_pos(V_COD_LOG);

    V_NOTE := 'END - Alert BATCH - GENERALE ';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_accesi',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);

    --return v_esito;
    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_accesi',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
      rollback;
     return OK;
  END;

  FUNCTION fnc_batch_load_alert_pos(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  ) RETURN NUMBER IS

    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:='GENERALE';

    cursor c_coda is
        select * from t_mcre0_app_alert_pos_queue;
    retVal number:=ko;

  begin
    V_NOTE := 'Alert BATCH - Calcolo codide log ';
     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    execute immediate 'ALTER SESSION ENABLE PARALLEL DML';

   V_NOTE := 'Alert BATCH - Truncate table T_MCRE0_APP_ALERT_POS ';
   execute immediate 'truncate table T_MCRE0_APP_ALERT_POS REUSE STORAGE';

   V_NOTE := 'START - Alert BATCH - Insert T_MCRE0_APP_ALERT_POS ';
   PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_load_alert_pos',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
   insert /*+ append */ into T_MCRE0_APP_ALERT_POS (
        COD_ABI_CARTOLARIZZATO    ,
        COD_ABI_ISTITUTO    ,
        COD_NDG    ,
        COD_SNDG    ,
        ALERT_1    ,
        COD_STATO_1    ,
        DTA_INS_1    ,
        DTA_UPD_1    ,
        FLG_WORSE_UPD_1    ,
        ALERT_2    ,
        COD_STATO_2    ,
        DTA_INS_2    ,
        DTA_UPD_2    ,
        FLG_WORSE_UPD_2    ,
        ALERT_3    ,
        COD_STATO_3    ,
        DTA_INS_3    ,
        DTA_UPD_3    ,
        FLG_WORSE_UPD_3    ,
        ALERT_4    ,
        COD_STATO_4    ,
        DTA_INS_4    ,
        DTA_UPD_4    ,
        FLG_WORSE_UPD_4    ,
        ALERT_5    ,
        COD_STATO_5    ,
        DTA_INS_5    ,
        DTA_UPD_5    ,
        FLG_WORSE_UPD_5    ,
        ALERT_6    ,
        COD_STATO_6    ,
        DTA_INS_6    ,
        DTA_UPD_6    ,
        FLG_WORSE_UPD_6    ,
        ALERT_7    ,
        COD_STATO_7    ,
        DTA_INS_7    ,
        DTA_UPD_7    ,
        FLG_WORSE_UPD_7    ,
        ALERT_8    ,
        COD_STATO_8    ,
        DTA_INS_8    ,
        DTA_UPD_8    ,
        FLG_WORSE_UPD_8    ,
        ALERT_11    ,
        COD_STATO_11    ,
        DTA_INS_11    ,
        DTA_UPD_11    ,
        FLG_WORSE_UPD_11    ,
        ALERT_12    ,
        COD_STATO_12    ,
        DTA_INS_12    ,
        DTA_UPD_12    ,
        FLG_WORSE_UPD_12    ,
        ALERT_13    ,
        COD_STATO_13    ,
        DTA_INS_13    ,
        DTA_UPD_13    ,
        FLG_WORSE_UPD_13    ,
        ALERT_14    ,
        COD_STATO_14    ,
        DTA_INS_14    ,
        DTA_UPD_14    ,
        FLG_WORSE_UPD_14    ,
        ALERT_15    ,
        COD_STATO_15    ,
        DTA_INS_15    ,
        DTA_UPD_15    ,
        FLG_WORSE_UPD_15    ,
        ALERT_16    ,
        COD_STATO_16    ,
        DTA_INS_16    ,
        DTA_UPD_16    ,
        FLG_WORSE_UPD_16    ,
        ALERT_17    ,
        COD_STATO_17    ,
        DTA_INS_17    ,
        DTA_UPD_17    ,
        FLG_WORSE_UPD_17    ,
        ALERT_18    ,
        COD_STATO_18    ,
        DTA_INS_18    ,
        DTA_UPD_18    ,
        FLG_WORSE_UPD_18    ,
        ALERT_19    ,
        COD_STATO_19    ,
        DTA_INS_19    ,
        DTA_UPD_19    ,
        FLG_WORSE_UPD_19    ,
        ALERT_20    ,
        COD_STATO_20    ,
        DTA_INS_20    ,
        DTA_UPD_20    ,
        FLG_WORSE_UPD_20    ,
        ALERT_21    ,
        COD_STATO_21    ,
        DTA_INS_21    ,
        DTA_UPD_21    ,
        FLG_WORSE_UPD_21    ,
        ALERT_22    ,
        COD_STATO_22    ,
        DTA_INS_22    ,
        DTA_UPD_22    ,
        FLG_WORSE_UPD_22    ,
        ALERT_23    ,
        COD_STATO_23    ,
        DTA_INS_23    ,
        DTA_UPD_23    ,
        FLG_WORSE_UPD_23    ,
--        ALERT_24    ,
--        COD_STATO_24    ,
--        DTA_INS_24    ,
--        DTA_UPD_24    ,
--        FLG_WORSE_UPD_24    ,
        ALERT_25    ,
        COD_STATO_25    ,
        DTA_INS_25    ,
        DTA_UPD_25    ,
        FLG_WORSE_UPD_25    ,
        ALERT_40    ,
        COD_STATO_40    ,
        DTA_INS_40    ,
        DTA_UPD_40    ,
        FLG_WORSE_UPD_40    ,
        ALERT_41    ,
        COD_STATO_41    ,
        DTA_INS_41    ,
        DTA_UPD_41    ,
        FLG_WORSE_UPD_41
--        ALERT_45    ,
--        COD_STATO_45    ,
--        DTA_INS_45    ,
--        DTA_UPD_45    ,
--        FLG_WORSE_UPD_45
        )
    select COD_ABI_CARTOLARIZZATO    ,
        COD_ABI_ISTITUTO    ,
        COD_NDG    ,
        COD_SNDG    ,
        ALERT_1    ,
        COD_STATO_1    ,
        DTA_INS_1    ,
        DTA_UPD_1    ,
        FLG_WORSE_UPD_1    ,
        ALERT_2    ,
        COD_STATO_2    ,
        DTA_INS_2    ,
        DTA_UPD_2    ,
        FLG_WORSE_UPD_2    ,
        ALERT_3    ,
        COD_STATO_3    ,
        DTA_INS_3    ,
        DTA_UPD_3    ,
        FLG_WORSE_UPD_3    ,
        ALERT_4    ,
        COD_STATO_4    ,
        DTA_INS_4    ,
        DTA_UPD_4    ,
        FLG_WORSE_UPD_4    ,
        ALERT_5    ,
        COD_STATO_5    ,
        DTA_INS_5    ,
        DTA_UPD_5    ,
        FLG_WORSE_UPD_5    ,
        ALERT_6    ,
        COD_STATO_6    ,
        DTA_INS_6    ,
        DTA_UPD_6    ,
        FLG_WORSE_UPD_6    ,
        ALERT_7    ,
        COD_STATO_7    ,
        DTA_INS_7    ,
        DTA_UPD_7    ,
        FLG_WORSE_UPD_7    ,
        ALERT_8    ,
        COD_STATO_8    ,
        DTA_INS_8    ,
        DTA_UPD_8    ,
        FLG_WORSE_UPD_8    ,
        ALERT_11    ,
        COD_STATO_11    ,
        DTA_INS_11    ,
        DTA_UPD_11    ,
        FLG_WORSE_UPD_11    ,
        ALERT_12    ,
        COD_STATO_12    ,
        DTA_INS_12    ,
        DTA_UPD_12    ,
        FLG_WORSE_UPD_12    ,
        ALERT_13    ,
        COD_STATO_13    ,
        DTA_INS_13    ,
        DTA_UPD_13    ,
        FLG_WORSE_UPD_13    ,
        ALERT_14    ,
        COD_STATO_14    ,
        DTA_INS_14    ,
        DTA_UPD_14    ,
        FLG_WORSE_UPD_14    ,
        ALERT_15    ,
        COD_STATO_15    ,
        DTA_INS_15    ,
        DTA_UPD_15    ,
        FLG_WORSE_UPD_15    ,
        ALERT_16    ,
        COD_STATO_16    ,
        DTA_INS_16    ,
        DTA_UPD_16    ,
        FLG_WORSE_UPD_16    ,
        ALERT_17    ,
        COD_STATO_17    ,
        DTA_INS_17    ,
        DTA_UPD_17    ,
        FLG_WORSE_UPD_17    ,
        ALERT_18    ,
        COD_STATO_18    ,
        DTA_INS_18    ,
        DTA_UPD_18    ,
        FLG_WORSE_UPD_18    ,
        ALERT_19    ,
        COD_STATO_19    ,
        DTA_INS_19    ,
        DTA_UPD_19    ,
        FLG_WORSE_UPD_19    ,
        ALERT_20    ,
        COD_STATO_20    ,
        DTA_INS_20    ,
        DTA_UPD_20    ,
        FLG_WORSE_UPD_20    ,
        ALERT_21    ,
        COD_STATO_21    ,
        DTA_INS_21    ,
        DTA_UPD_21    ,
        FLG_WORSE_UPD_21    ,
        ALERT_22    ,
        COD_STATO_22    ,
        DTA_INS_22    ,
        DTA_UPD_22    ,
        FLG_WORSE_UPD_22    ,
        ALERT_23    ,
        COD_STATO_23    ,
        DTA_INS_23    ,
        DTA_UPD_23    ,
        FLG_WORSE_UPD_23    ,
--        ALERT_24    ,
--        COD_STATO_24    ,
--        DTA_INS_24    ,
--        DTA_UPD_24    ,
--        FLG_WORSE_UPD_24    ,
        ALERT_25    ,
        COD_STATO_25    ,
        DTA_INS_25    ,
        DTA_UPD_25    ,
        FLG_WORSE_UPD_25    ,
        ALERT_40    ,
        COD_STATO_40    ,
        DTA_INS_40    ,
        DTA_UPD_40    ,
        FLG_WORSE_UPD_40    ,
        ALERT_41    ,
        COD_STATO_41    ,
        DTA_INS_41    ,
        DTA_UPD_41    ,
        FLG_WORSE_UPD_41
--        ALERT_45    ,
--        COD_STATO_45    ,
--        DTA_INS_45    ,
--        DTA_UPD_45    ,
--        FLG_WORSE_UPD_45
    from v_mcre0_app_alert_load2;
    commit;
   V_NOTE := 'END - Alert BATCH - Insert T_MCRE0_APP_ALERT_POS ';
   PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_load_alert_pos',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
V_NOTE := 'Alert BATCH - Set batch terminato ';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_load_alert_pos',PKG_MCRE0_AUDIT.C_DEBUG,0,0,'START - '||v_note);
    update t_MCRE0_WRK_CONFIGURAZIONE
    set VALORE_COSTANTE = to_char(sysdate,'YYYYMMDD')
    where NOME_COSTANTE = 'DTA_UPD_ALERT_BATCH';
    commit;
    update t_MCRE0_WRK_CONFIGURAZIONE
    set VALORE_COSTANTE = 0
    where NOME_COSTANTE = 'EXEC_ALERT_BATCH';
    commit;
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_load_alert_pos',PKG_MCRE0_AUDIT.C_DEBUG,0,0,'END - '||v_note);

    V_NOTE := 'Alert BATCH - Ricalcolo coda ';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_load_alert_pos',PKG_MCRE0_AUDIT.C_DEBUG,0,0,'START - '||v_note);
    for rec_coda in c_coda loop
        begin
               retVal := FNC_VERIFICA_ALERT_NDG(
                    rec_coda.COD_ABI_CARTOLARIZZATO,
                    rec_coda.COD_NDG,
                    rec_coda.COD_SNDG,
                    rec_coda.ID_UTENTE,
                    rec_coda.COD_LOG
                  );
                  commit;
         exception
           when others then
                 PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_load_alert_pos',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note||' - ABI='||rec_coda.COD_ABI_CARTOLARIZZATO||' - NDG='||rec_coda.cod_ndg);
         end;

         begin
              delete from t_mcre0_app_alert_pos_queue
              where COD_ABI_CARTOLARIZZATO = rec_coda.COD_ABI_CARTOLARIZZATO
              and cod_ndg = rec_coda.cod_ndg;
              commit;
          exception
            when others then
                PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_load_alert_pos',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note||' - Delete ABI='||rec_coda.COD_ABI_CARTOLARIZZATO||' - NDG='||rec_coda.cod_ndg);
          end;
    end loop;
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_load_alert_pos',PKG_MCRE0_AUDIT.C_DEBUG,0,0,'END - '||v_note);

   return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_load_alert_pos',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
      rollback;
     return OK;
  END;

  FUNCTION fnc_batch_trunc_pos_tmp(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER IS

    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:='GENERALE';
    v_esito number:=-1;

  begin
    V_NOTE := 'Alert BATCH - Calcolo codide log ';
     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    V_NOTE := 'Alert BATCH - Set batch in esecuzione ';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_trunc_pos_tmp',PKG_MCRE0_AUDIT.C_DEBUG,0,0,'START - '||v_note);
    update t_MCRE0_WRK_CONFIGURAZIONE
    set VALORE_COSTANTE = 1
    where NOME_COSTANTE = 'EXEC_ALERT_BATCH';
    commit;
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_trunc_pos_tmp',PKG_MCRE0_AUDIT.C_DEBUG,0,0,'END - '||v_note);

    V_NOTE := 'Alert BATCH - Truncate temporanea ';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_trunc_pos_tmp',PKG_MCRE0_AUDIT.C_DEBUG,0,0,'START - '||v_note);
    execute immediate 'truncate table T_MCRE0_APP_ALERT_POS_TMP';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_trunc_pos_tmp',PKG_MCRE0_AUDIT.C_DEBUG,0,0,'END - '||v_note);
    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_trunc_pos_tmp',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
      rollback;
     return OK;
  END;  FUNCTION fnc_batch_alert_gruppo_1(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER IS

    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:='GENERALE';

  begin
    V_NOTE := 'Alert BATCH - Calcolo codide log ';
     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    execute immediate 'ALTER SESSION ENABLE PARALLEL DML';

    V_NOTE := 'START - Alert BATCH - Gruppo1 (Alert 1-7)';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_gruppo_1',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
    insert  into T_MCRE0_APP_ALERT_POS_TMP
    (
            COD_ABI_CARTOLARIZZATO,
            COD_ABI_istituto,
            COD_NDG,
            COD_SNDG,
            ALERT_1    ,
            COD_STATO_1    ,
            DTA_INS_1    ,
            DTA_UPD_1    ,
            FLG_WORSE_UPD_1    ,
            ALERT_2    ,
            COD_STATO_2    ,
            DTA_INS_2    ,
            DTA_UPD_2    ,
            FLG_WORSE_UPD_2    ,
            ALERT_3    ,
            COD_STATO_3    ,
            DTA_INS_3    ,
            DTA_UPD_3    ,
            FLG_WORSE_UPD_3    ,
            ALERT_4    ,
            COD_STATO_4    ,
            DTA_INS_4    ,
            DTA_UPD_4    ,
            FLG_WORSE_UPD_4    ,
            ALERT_5    ,
            COD_STATO_5    ,
            DTA_INS_5    ,
            DTA_UPD_5    ,
            FLG_WORSE_UPD_5    ,
            ALERT_6    ,
            COD_STATO_6    ,
            DTA_INS_6    ,
            DTA_UPD_6    ,
            FLG_WORSE_UPD_6    ,
            ALERT_7    ,
            COD_STATO_7    ,
            DTA_INS_7    ,
            DTA_UPD_7    ,
            FLG_WORSE_UPD_7
)   select
            s.COD_ABI_CARTOLARIZZATO,
            s.COD_ABI_ISTITUTO,
            s.COD_NDG,
            s.COD_SNDG,
            ALERT_1    ,
            COD_STATO    ,
            DTA_INS_1    ,
            DTA_UPD_1    ,
            FLG_WORSE_UPD_1    ,
            ALERT_2    ,
            COD_STATO    ,
            DTA_INS_2    ,
            DTA_UPD_2    ,
            FLG_WORSE_UPD_2    ,
            ALERT_3    ,
            COD_STATO    ,
            DTA_INS_3    ,
            DTA_UPD_3    ,
            FLG_WORSE_UPD_3    ,
            ALERT_4    ,
            COD_STATO    ,
            DTA_INS_4    ,
            DTA_UPD_4    ,
            FLG_WORSE_UPD_4    ,
            ALERT_5    ,
            COD_STATO    ,
            DTA_INS_5    ,
            DTA_UPD_5    ,
            FLG_WORSE_UPD_5    ,
            ALERT_6    ,
            COD_STATO    ,
            DTA_INS_6    ,
            DTA_UPD_6    ,
            FLG_WORSE_UPD_6    ,
            ALERT_7    ,
            COD_STATO    ,
            DTA_INS_7    ,
            DTA_UPD_7    ,
            FLG_WORSE_UPD_7
    from v_mcre0_app_alert_load s;
    commit;

    V_NOTE := 'END - Alert BATCH - Gruppo1 (Alert 1-7)';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_gruppo_1',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_gruppo_1',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
      rollback;
     return OK;
  END;

  FUNCTION fnc_batch_alert_gruppo_2(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )
  RETURN NUMBER IS

    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:='GENERALE';
    v_esito number:=-1;

  begin
    V_NOTE := 'Alert BATCH - Calcolo codide log ';
     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    execute immediate 'ALTER SESSION ENABLE PARALLEL DML';

    V_NOTE := 'START - Alert BATCH - Gruppo2 (Alert 11-17)';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_gruppo_2',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
    insert into T_MCRE0_APP_ALERT_POS_TMP
    (
            COD_ABI_CARTOLARIZZATO,
            COD_ABI_istituto,
            COD_NDG,
            COD_SNDG,
            ALERT_11    ,
            COD_STATO_11    ,
            DTA_INS_11    ,
            DTA_UPD_11    ,
            FLG_WORSE_UPD_11    ,
            ALERT_12    ,
            COD_STATO_12    ,
            DTA_INS_12    ,
            DTA_UPD_12    ,
            FLG_WORSE_UPD_12    ,
            ALERT_13    ,
            COD_STATO_13    ,
            DTA_INS_13    ,
            DTA_UPD_13    ,
            FLG_WORSE_UPD_13    ,
            ALERT_14    ,
            COD_STATO_14    ,
            DTA_INS_14    ,
            DTA_UPD_14    ,
            FLG_WORSE_UPD_14    ,
            ALERT_15    ,
            COD_STATO_15    ,
            DTA_INS_15    ,
            DTA_UPD_15    ,
            FLG_WORSE_UPD_15    ,
            ALERT_16    ,
            COD_STATO_16    ,
            DTA_INS_16    ,
            DTA_UPD_16    ,
            FLG_WORSE_UPD_16    ,
            ALERT_17    ,
            COD_STATO_17    ,
            DTA_INS_17    ,
            DTA_UPD_17    ,
            FLG_WORSE_UPD_17
--            ALERT_45    ,
--            COD_STATO_45    ,
--            DTA_INS_45    ,
--            DTA_UPD_45    ,
--            FLG_WORSE_UPD_45

)   select
            s.COD_ABI_CARTOLARIZZATO,
            s.COD_ABI_ISTITUTO,
            s.COD_NDG,
            s.COD_SNDG,
            ALERT_11    ,
            COD_STATO   ,
            DTA_INS_11    ,
            DTA_UPD_11    ,
            FLG_WORSE_UPD_11    ,
            ALERT_12    ,
            COD_STATO  ,
            DTA_INS_12    ,
            DTA_UPD_12    ,
            FLG_WORSE_UPD_12    ,
            ALERT_13    ,
            COD_STATO   ,
            DTA_INS_13    ,
            DTA_UPD_13    ,
            FLG_WORSE_UPD_13    ,
            ALERT_14    ,
            COD_STATO    ,
            DTA_INS_14    ,
            DTA_UPD_14    ,
            FLG_WORSE_UPD_14    ,
            ALERT_15    ,
            COD_STATO    ,
            DTA_INS_15    ,
            DTA_UPD_15    ,
            FLG_WORSE_UPD_15    ,
            ALERT_16    ,
            COD_STATO   ,
            DTA_INS_16    ,
            DTA_UPD_16    ,
            FLG_WORSE_UPD_16    ,
            ALERT_17    ,
            COD_STATO   ,
            DTA_INS_17    ,
            DTA_UPD_17    ,
            FLG_WORSE_UPD_17
--            ALERT_45    ,
--            COD_STATO   ,
--            DTA_INS_45    ,
--            DTA_UPD_45    ,
--            FLG_WORSE_UPD_45
    from v_mcre0_app_alert_load s;
    commit;V_NOTE := 'END - Alert BATCH - Gruppo2 (Alert 11-17)';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_gruppo_2',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_gruppo_2',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
      rollback;
     return OK;
  END;

    FUNCTION fnc_batch_alert_gruppo_3(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )
  RETURN NUMBER IS

    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:='GENERALE';
    v_esito number:=-1;

  begin
    V_NOTE := 'Alert BATCH - Calcolo codide log ';
     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    execute immediate 'ALTER SESSION ENABLE PARALLEL DML';

    V_NOTE := 'START - Alert BATCH - Gruppo3 (Alert 18-21 e 8 e 40-41)';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_gruppo_3',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
        insert into T_MCRE0_APP_ALERT_POS_TMP
    (
            COD_ABI_CARTOLARIZZATO,
            COD_ABI_istituto,
            COD_NDG,
            COD_SNDG,
            ALERT_18    ,
            COD_STATO_18    ,
            DTA_INS_18    ,
            DTA_UPD_18    ,
            FLG_WORSE_UPD_18    ,
            ALERT_19    ,
            COD_STATO_19    ,
            DTA_INS_19    ,
            DTA_UPD_19    ,
            FLG_WORSE_UPD_19    ,
            ALERT_20    ,
            COD_STATO_20    ,
            DTA_INS_20    ,
            DTA_UPD_20    ,
            FLG_WORSE_UPD_20    ,
            ALERT_21    ,
            COD_STATO_21    ,
            DTA_INS_21    ,
            DTA_UPD_21    ,
            FLG_WORSE_UPD_21    ,
            ALERT_8,
            COD_STATO_8,
            DTA_INS_8,
            DTA_UPD_8,
            ALERT_40    ,
            COD_STATO_40    ,
            DTA_INS_40    ,
            DTA_UPD_40    ,
            FLG_WORSE_UPD_40   ,
            ALERT_41    ,
            COD_STATO_41    ,
            DTA_INS_41    ,
            DTA_UPD_41    ,
            FLG_WORSE_UPD_41
)   select
            s.COD_ABI_CARTOLARIZZATO,
            s.COD_ABI_ISTITUTO,
            s.COD_NDG,
            s.COD_SNDG,
            ALERT_18    ,
            COD_STATo    ,
            DTA_INS_18    ,
            DTA_UPD_18    ,
            FLG_WORSE_UPD_18    ,
            ALERT_19    ,
            COD_STATO   ,
            DTA_INS_19    ,
            DTA_UPD_19    ,
            FLG_WORSE_UPD_19    ,
            ALERT_20    ,
            COD_STATO   ,
            DTA_INS_20    ,
            DTA_UPD_20    ,
            FLG_WORSE_UPD_20    ,
            ALERT_21    ,
            COD_STATO   ,
            DTA_INS_21    ,
            DTA_UPD_21    ,
            FLG_WORSE_UPD_21  ,
           ALERT_8,
           COD_STATO,
            DTA_INS_8    ,
            DTA_UPD_8,
            ALERT_40    ,
            COD_STATO    ,
            DTA_INS_40    ,
            DTA_UPD_40    ,
            FLG_WORSE_UPD_40   ,
            ALERT_41    ,
            COD_STATO    ,
            DTA_INS_41    ,
            DTA_UPD_41    ,
            FLG_WORSE_UPD_41
    from v_mcre0_app_alert_load s;
    commit;

    V_NOTE := 'END - Alert BATCH - Gruppo3 (Alert 18-21 e 8 e 40-41)';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_gruppo_3',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_gruppo_3',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
      rollback;
     return OK;
  END;

  FUNCTION fnc_batch_alert_gruppo_4(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )
  RETURN NUMBER IS

    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:='GENERALE';
    v_esito number:=-1;

  begin
    V_NOTE := 'Alert BATCH - Calcolo codide log ';
     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    execute immediate 'ALTER SESSION ENABLE PARALLEL DML';

    V_NOTE := 'START - Alert BATCH - Gruppo4 (Alert 22-23 e 25)';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_gruppo_4',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
    insert  into T_MCRE0_APP_ALERT_POS_TMP
    (
            COD_ABI_CARTOLARIZZATO,
            COD_ABI_istituto,
            COD_NDG,
            COD_SNDG,
            ALERT_22    ,
            COD_STATO_22    ,
            DTA_INS_22    ,
            DTA_UPD_22    ,
            FLG_WORSE_UPD_22    ,
            alert_23,
            COD_STATO_23    ,
            DTA_INS_23    ,
            DTA_UPD_23    ,
            FLG_WORSE_UPD_23    ,
--            ALERT_24    ,
--            COD_STATO_24    ,
--            DTA_INS_24    ,
--            DTA_UPD_24    ,
--            FLG_WORSE_UPD_24    ,
            ALERT_25    ,
            DTA_INS_25    ,
            DTA_UPD_25    ,
            COD_STATO_25    ,
            FLG_WORSE_UPD_25
)   select
            s.COD_ABI_CARTOLARIZZATO,
            s.COD_ABI_ISTITUTO,
            s.COD_NDG,
            s.COD_SNDG,
            ALERT_22    ,
            COD_STATO   ,
            DTA_INS_22    ,
            DTA_UPD_22    ,
            FLG_WORSE_UPD_22  ,
            alert_23,
            COD_STATO    ,
            DTA_INS_23    ,
            DTA_UPD_23    ,
            FLG_WORSE_UPD_23    ,
--            ALERT_24    ,
--            COD_STATO    ,
--            DTA_INS_24    ,
--            DTA_UPD_24    ,
--            FLG_WORSE_UPD_24    ,
            ALERT_25    ,
            DTA_INS_25    ,
            DTA_UPD_25    ,
            COD_STATO   ,
            FLG_WORSE_UPD_25
    from v_mcre0_app_alert_load s;
    commit;

    V_NOTE := 'END - Alert BATCH - Gruppo4 (Alert 22-23 e 25)';
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_gruppo_4',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.fnc_batch_alert_gruppo_4',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
      rollback;
     return OK;
  END;

  FUNCTION FNC_VERIFICA_ALERT_NDG(
    p_cod_abi   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    p_cod_sndg  T_MCRE0_APP_ALL_DATA.COD_SNDG%type,
    P_ID_UTENTE T_MCRE0_APP_UTENTI.ID_UTENTE%TYPE,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  ) RETURN NUMBER IS
    v_result_a number;
    V_RESULT_S NUMBER;
    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
  BEGIN
    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    V_RESULT_A := pkg_mcre0_alert.fnc_verifica_alert_accesi(P_COD_ABI, P_COD_NDG, P_COD_SNDG, P_ID_UTENTE,V_COD_LOG);
    if(v_result_a=ko)then
      return ko;
    end if;

    --v3.0
    if nullif(P_ID_UTENTE,-1) is not null then
    v_result_a := PKG_MCREI_ALERT.FNC_MCREI_CALC_POS ( P_COD_ABI, P_COD_NDG );
    else
    v_result_a := ok;
    end if;
    if(v_result_a = ko) then
        PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'FNC_VERIFICA_ALERT_NDG - PKG_MCREI_ALERT.FNC_MCREI_CALC_POS',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,'alert inc','ABI='||p_cod_abi||' NDG='||p_cod_ndg,P_ID_UTENTE);
    end if;
    return ok;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_NDG',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - ABI='||p_cod_abi||' NDG='||p_cod_ndg,P_ID_UTENTE);
      return ko;
  END;

  FUNCTION FNC_VERIFICA_ALERT_SNDG(
    P_COD_SNDG  T_MCRE0_APP_ALL_DATA.COD_SNDG%TYPE,
    p_id_utente T_MCRE0_APP_UTENTI.ID_UTENTE%type,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE DEFAULT NULL,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  ) RETURN NUMBER IS

    v_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    v_result_a number;
    v_result_s number;

  BEGIN
    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    V_RESULT_A := pkg_mcre0_alert.fnc_verifica_alert_accesi(null, null, P_COD_SNDG, P_ID_UTENTE,V_COD_LOG);
    if(v_result_a=ko)then
      return ko;
    end if;

    return ok;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_SNDG',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE -SNDG='||p_cod_sndg,P_ID_UTENTE);
      return ko;
  END;

  FUNCTION fnc_verifica_alert_id(
    p_id_alert   T_MCRE0_APP_alert.id_alert%type,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER IS

    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:='GENERALE';
    v_batch_in_corso t_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type:=0;
    v_qry varchar2(30000);

  begin
    V_NOTE := 'Alert - Calcolo codide log - ALERT='||p_id_alert;
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    V_NOTE := 'Alert - Controllo Batch attivo- ALERT='||p_id_alert;
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);

    begin
        select VALORE_COSTANTE
        into   v_batch_in_corso
        from t_MCRE0_WRK_CONFIGURAZIONE
        where NOME_COSTANTE = 'EXEC_ALERT_BATCH';
    exception
        when others then
            v_batch_in_corso := 0;
    end;

    if(v_batch_in_corso=1) then
        V_NOTE := 'Alert - Nessun ricalcolo causa batch attivo - ALERT='||p_id_alert;
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_DEBUG,0,0,v_note);
    else

            V_NOTE := 'Alert - Merge - ALERT='||p_id_alert;
            PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_DEBUG,0,0,'INIZIO '||v_note);

            v_qry := '
                merge into t_mcre0_app_alert_pos d using (
                    select *
                    from v_mcre0_app_alert_load
                    where alert_'|| p_id_alert ||' is not null
                    ) s
                on ( d.cod_abi_cartolarizzato = s.cod_abi_cartolarizzato
                       and d.cod_ndg = s.COD_ndg)
                when not matched then
                insert
                (
                        d.COD_ABI_CARTOLARIZZATO,
                        d.COD_ABI_istituto,
                        d.COD_NDG,
                        d.COD_SNDG,
                        d.ALERT_'|| p_id_alert ||',
                        d.COD_STATO_'|| p_id_alert ||',
                        d.DTA_INS_'|| p_id_alert ||',
                        d.DTA_UPD_'|| p_id_alert ||'
                )
                values
                (
                        s.COD_ABI_CARTOLARIZZATO,
                        s.COD_ABI_ISTITUTO,
                        s.COD_NDG,
                        s.COD_SNDG,
                        s.ALERT_'|| p_id_alert ||',
                        s.COD_STATO,
                        sysdate,
                        sysdate
                )
                when matched then update set
                    d.ALERT_'|| p_id_alert ||'    = s.ALERT_'|| p_id_alert ||',
                    d.COD_STATO_'|| p_id_alert ||'    = s.COD_STATO,
                    d.DTA_UPD_'|| p_id_alert ||'    = s.DTA_UPD_'|| p_id_alert ||',
                    d.FLG_WORSE_UPD_'|| p_id_alert ||'    = s.FLG_WORSE_UPD_'|| p_id_alert ;
            execute immediate v_qry;
            commit;

           PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_DEBUG,0,0,'FINE '||v_note);
    end if;
    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,v_note);
     return ko;
  END;

END PKG_MCRE0_ALERT;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ALERT FOR MCRE_OWN.PKG_MCRE0_ALERT;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ALERT FOR MCRE_OWN.PKG_MCRE0_ALERT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ALERT TO MCRE_USR;

