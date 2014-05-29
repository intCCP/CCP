CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_MIGRRAPP AS
  /******************************************************************************
     NAME:       PKG_MCRE0_ALIMENTAZIONE
     PURPOSE:

     REVISIONS:
     Ver        Date        Author             Description
     ---------  ----------      -----------------  ------------------------------------
     1.0      14/02/2012  V.Galli    Created this package.
     1.1      18/06/2012  V.Galli    Versione per shell con report
     1.2      12/07/2012  V.Galli    Conferimenti
  ******************************************************************************/

  FUNCTION FNC_MCRE0_ALIMENTA_ST_MIGRRAPP(
    P_FLG_TIPO_MIGRRAPP T_MCRE0_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type
  ) RETURN T_MCRE0_ST_MIGRRAPP.id_lotto%type
  IS

    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_UTENTE CONSTANT T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE:='MIGRRAPP';
    C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRE0_ALIMENTA_ST_MIGRRAPP';
    V_id_lotto_NUOVO T_MCRE0_ST_MIGRRAPP.id_lotto%type;

  BEGIN

    V_NOTE:='Calcolo progressivo migrazione';
    begin
      SELECT MAX(id_lotto)+1
      INTO V_id_lotto_NUOVO
      from T_MCRE0_ST_MIGRRAPP
      where FLG_TIPO_MIGRRAPP = P_FLG_TIPO_MIGRRAPP;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_id_lotto_NUOVO:=1;
      WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_app(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
        return ko;
    end;

    V_NOTE:='Insert ST migrazione TIPO_MIGRRAPP='||P_FLG_TIPO_MIGRRAPP;
    begin
      INSERT /*+ append */ INTO T_MCRE0_ST_MIGRRAPP
      (VAL_SOURCE,ID_LOTTO,ID_DPER,COD_ABI,COD_NDG,COD_RAPPORTO_OLD,COD_RAPPORTO_NEW,COD_FILIALE_ORIG,COD_FILIALE_DEST,FLG_TIPO_MIGRRAPP,DTA_INS)
      select VAL_SOURCE,NVL(V_ID_LOTTO_NUOVO,1) ID_LOTTO,ID_DPER,COD_ABI,COD_NDG,COD_RAPPORTO_OLD,COD_RAPPORTO_NEW,COD_FILIALE_orig,cod_filiale_dest,FLG_TIPO_MIGRRAPP,DTA_INS
      from V_MCRE0_MIGRRAPP E
      where E.FLG_TIPO_MIGRRAPP = P_FLG_TIPO_MIGRRAPP;
      commit;
    EXCEPTION
      WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_app(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
        RETURN KO;
    end;

    RETURN nvl(V_id_lotto_NUOVO,1);

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.log_app(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE,V_UTENTE);
      RETURN KO;
  END FNC_MCRE0_ALIMENTA_ST_MIGRRAPP;

  function FNC_MCRE0_TBL_MIGRRAPP(
    P_ID_LOTTO T_MCRE0_ST_MIGRRAPP.ID_LOTTO%TYPE,
    P_FLG_TIPO_MIGRRAPP T_MCRE0_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type
  ) RETURN NUMBER
  IS

    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_UTENTE CONSTANT T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE:='MIGRRAPP';
    C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRE0_TBL_MIGRRAPP';
    v_qry varchar2(3000);
    v_COLUMN_NAME ALL_CONS_COLUMNS.COLUMN_NAME%type;
    v_esito number(1):=ok;

    CURSOR C_LISTA_TBL IS
      SELECT *
      FROM T_MCRE0_WRK_MIGRRAPP
      where FLG_ATTIVA = 1
      and FLG_TIPO_MIGRRAPP= P_FLG_TIPO_MIGRRAPP
      order by val_ordine;

    CURSOR C_LISTA_RAPPORTI IS
      SELECT *
      FROM T_MCRE0_ST_MIGRRAPP
      where ID_LOTTO = P_ID_LOTTO
      and FLG_TIPO_MIGRRAPP= P_FLG_TIPO_MIGRRAPP
      order by cod_abi,cod_rapporto_old;

    cursor c_lista_rapporti_conf is
        SELECT r.*
        FROM T_MCRE0_APP_MIG_RECODE_NDG n,
                  T_MCRE0_APP_MIG_RECODE_RAPP r
        where N.COD_ABI_OLD = R.COD_ABI_OLD
        and N.COD_NDG_OLD = R.COD_NDG_OLD
        order by R.COD_ABI_OLD,R.COD_NDG_OLD;

  BEGIN

    FOR REC_LISTA_TBL IN C_LISTA_TBL
    LOOP

      PKG_MCRE0_AUDIT.LOG_APP(C_NOME,PKG_MCRE0_AUDIT.C_DEBUG,0,0,REC_LISTA_TBL.VAL_TABLE_NAME,V_UTENTE);
      v_esito:=OK;

      if (P_FLG_TIPO_MIGRRAPP=4) then
         /***********   CONFERIMENTI ***********/

        FOR REc_lista_rapporti_conf IN c_lista_rapporti_conf
        LOOP

            V_NOTE:='Update CONFERIMENTI obj='||REC_LISTA_TBL.VAL_TABLE_NAME||' - ABI='||REc_lista_rapporti_conf.COD_RAPPORTO_OLD||' - NDG='||REc_lista_rapporti_conf.COD_NDG_NEW||' RAPPORTO='||REc_lista_rapporti_conf.COD_RAPPORTO_OLD;
            BEGIN
               v_qry := '
                  update '|| REC_LISTA_TBL.VAL_TABLE_NAME ||
                ' set '|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = :1, '||
                          REC_LISTA_TBL.VAL_COLUMN_ABI ||' = :2 ';
                IF (nvl(REC_LISTA_TBL.FLG_NDG,0)=1) THEN
                V_QRY := V_QRY||' , COD_NDG = :3 ';
                END IF;
                V_QRY := V_QRY||' , dta_upd = sysdate '||
                ' where '||REC_LISTA_TBL.VAL_COLUMN_ABI||' = :4 ';
                IF (nvl(REC_LISTA_TBL.FLG_NDG,0)=1) THEN
                V_QRY := V_QRY||' AND COD_NDG = :5 ';
                END IF;
                V_QRY := V_QRY||' AND '|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = :6 ';

                IF (nvl(REC_LISTA_TBL.FLG_NDG,0)=1 )  THEN
                    execute immediate V_QRY using REc_lista_rapporti_conf.COD_RAPPORTO_NEW,REc_lista_rapporti_conf.COD_ABI_NEW,REc_lista_rapporti_conf.COD_NDG_NEW,REc_lista_rapporti_conf.COD_ABI_OLD,REc_lista_rapporti_conf.COD_NDG_OLD,REc_lista_rapporti_conf.COD_RAPPORTO_OLD;
                ELSE
                    execute immediate V_QRY using REc_lista_rapporti_conf.COD_RAPPORTO_NEW,REc_lista_rapporti_conf.COD_ABI_NEW,REc_lista_rapporti_conf.COD_ABI_OLD,REc_lista_rapporti_conf.COD_RAPPORTO_OLD;
                END IF;
                COMMIT;

            EXCEPTION
                  WHEN OTHERS THEN
                    PKG_MCRE0_AUDIT.LOG_APP(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'PK violata - '||V_NOTE,V_UTENTE);
                    rollback;
                    v_esito:=v_esito*ko;
            end;
        END LOOP;

      else
         /***********   MIGRAZIONI ***********/

          FOR REC_LISTA IN C_LISTA_RAPPORTI
          LOOP

            if (instr(REC_LISTA_TBL.val_source_list,','||REC_LISTA.val_source||',')>0) then

                V_NOTE:='Update obj='||REC_LISTA_TBL.VAL_TABLE_NAME;
                BEGIN
                  v_qry := '
                    update '|| REC_LISTA_TBL.VAL_TABLE_NAME ||'
                    set '|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = :1, ';
                  if (REC_LISTA_TBL.VAL_COLUMN_FILIALE is not null) then
                    V_QRY := V_QRY || REC_LISTA_TBL.VAL_COLUMN_FILIALE||' = :2 ,';
                  end if;
                  V_QRY := V_QRY || ' dta_upd = sysdate ';
                  V_QRY := V_QRY || ' where '||REC_LISTA_TBL.VAL_COLUMN_ABI||' = :3 ';
                  IF (nvl(REC_LISTA_TBL.FLG_NDG,0)=1) THEN
                    V_QRY := V_QRY||' AND COD_NDG = :4 ';
                  END IF;
                  V_QRY := V_QRY||' AND '|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = :5 ';

                  IF (nvl(REC_LISTA_TBL.FLG_NDG,0)=1 AND REC_LISTA_TBL.VAL_COLUMN_FILIALE IS NULL )  THEN
                    execute immediate V_QRY using REC_LISTA.COD_RAPPORTO_NEW,REC_LISTA.COD_ABI,REC_LISTA.COD_NDG,REC_LISTA.COD_RAPPORTO_OLD;
                  ELSIF (NVL(REC_LISTA_TBL.FLG_NDG,0)=1 and REC_LISTA_TBL.VAL_COLUMN_FILIALE is not null )  then
                    execute immediate V_QRY using REC_LISTA.COD_RAPPORTO_NEW,REC_LISTA.COD_FILIALE_DEST,REC_LISTA.COD_ABI,REC_LISTA.COD_NDG,REC_LISTA.COD_RAPPORTO_OLD;
                  ELSIF (NVL(REC_LISTA_TBL.FLG_NDG,0)=0 and REC_LISTA_TBL.VAL_COLUMN_FILIALE is not null )  then
                    execute immediate V_QRY using REC_LISTA.COD_RAPPORTO_NEW,REC_LISTA.COD_FILIALE_DEST,REC_LISTA.COD_ABI,REC_LISTA.COD_RAPPORTO_OLD;
                  ELSE
                    EXECUTE IMMEDIATE V_QRY USING REC_LISTA.COD_RAPPORTO_NEW,REC_LISTA.COD_ABI,REC_LISTA.COD_RAPPORTO_OLD;
                  end if;
                  commit;
                EXCEPTION
                  WHEN PK_VIOLATA THEN
                    PKG_MCRE0_AUDIT.LOG_APP(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'PK violata - '||V_NOTE,V_UTENTE);
                    rollback;
                    v_esito:=v_esito*ko;
                    begin
                      UPDATE T_MCRE0_ST_MIGRRAPP
                      SET TBL_PK_DUPLICATA = nvl(TBL_PK_DUPLICATA,',')||REC_LISTA_TBL.VAL_TABLE_NAME||','
                      WHERE ID_LOTTO = P_ID_LOTTO
                      and COD_ABI = REC_LISTA.COD_ABI
                      AND COD_NDG = REC_LISTA.COD_NDG
                      AND COD_RAPPORTO_OLD = REC_LISTA.COD_RAPPORTO_OLD;
                      COMMIT;
                    EXCEPTION
                      WHEN OTHERS THEN
                        PKG_MCRE0_AUDIT.LOG_APP(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'PK violata - TBL='||REC_LISTA_TBL.VAL_TABLE_NAME||' RAPP_OLD='||REC_LISTA.COD_RAPPORTO_OLD,V_UTENTE);
                    end;
                  WHEN OTHERS THEN
                    PKG_MCRE0_AUDIT.LOG_APP(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
                    v_esito:=v_esito*ko;
                END;
            end if;

          END LOOP;

       end IF;

       V_NOTE := 'Fine migrrapp '||P_FLG_TIPO_MIGRRAPP||' - Tabella='|| REC_LISTA_TBL.VAL_TABLE_NAME;
        update t_MCRE0_wrk_migrrapp
        set dta_esito = sysdate,
               flg_esito = v_esito
         where VAL_TABLE_NAME =  REC_LISTA_TBL.VAL_TABLE_NAME
         and flg_tipo_migrrapp = P_FLG_TIPO_MIGRRAPP
         and flg_attiva = 1;
         commit;
    end loop;

    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.log_app(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE,V_UTENTE);
      RETURN KO;
  END FNC_MCRE0_TBL_MIGRRAPP;

  procedure PRC_MCRE0_EXE_MIGRRAPP(
    P_FLG_TIPO_MIGRRAPP T_MCRE0_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type,
    p_esito out number
  )
  IS

    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_UTENTE CONSTANT T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE:='MIGRRAPP';
    C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.PRCC_MCRE0_EXE_MIGRRAPP';
    V_ID_LOTTO T_MCRE0_ST_MIGRRAPP.ID_LOTTO%TYPE;
    v_esito NUMBER := KO;

  BEGIN

    if(NVL(P_FLG_TIPO_MIGRRAPP,5) not in (1,2,3,4)) then
      p_esito := V_ESITO;
    END IF;


    IF(P_FLG_TIPO_MIGRRAPP=4)THEN
        V_ID_LOTTO:=ok;
    else
        V_NOTE:='Da TE in ST';
        V_ID_LOTTO:=PKG_MCRE0_MIGRRAPP.FNC_MCRE0_ALIMENTA_ST_MIGRRAPP(P_FLG_TIPO_MIGRRAPP);
    end if;

    if (V_ID_LOTTO!=KO)then

      v_esito:= FNC_MCRE0_report_MIGRRAPP(V_ID_LOTTO,P_FLG_TIPO_MIGRRAPP,1);
      --if(v_esito!=ko)then
      v_esito:=PKG_MCRE0_MIGRRAPP.FNC_MCRE0_TBL_MIGRRAPP(V_ID_LOTTO,P_FLG_TIPO_MIGRRAPP);
      --end if;
      v_esito:=v_esito *  FNC_MCRE0_report_MIGRRAPP(V_ID_LOTTO,P_FLG_TIPO_MIGRRAPP,0);

    END IF;

    p_esito := v_esito;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.log_app(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE,V_UTENTE);
      p_esito := ko;
  END prc_MCRE0_EXE_MIGRRAPP;


  -- Esecuzione da TWS
  function FNC_MCRE0_chk_MIGRRAPP(
    p_nome_file T_MCRE0_WRK_MIGRRAPP_FILE.VAL_NOME_FILE%type
  )RETURN number
  IS

    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_UTENTE CONSTANT T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE:='MIGRRAPP';
    C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRE0_CHK_MIGRRAPP';
    v_esito number(1):=ok;
    v_ok number;
    v_attivi number;
    v_qry varchar2(3000);
    v_flg_tipo_migrrapp T_MCRE0_WRK_MIGRRAPP_FILE.FLG_TIPO_MIGRRAPP%type;

    --- LOCK
      V_LOCK_RESULT NUMBER;
      V_LOCKHANDLE  VARCHAR2(200);

  BEGIN

    --- LOCK_INIZIO
    DBMS_LOCK.ALLOCATE_UNIQUE('t_MCRE0_wrk_migrrapp_file', V_LOCKHANDLE);
    V_LOCK_RESULT := DBMS_LOCK.REQUEST(V_LOCKHANDLE, DBMS_LOCK.X_MODE);
    PKG_MCRE0_AUDIT.log_app(C_NOME,PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'LOCK upd Request - '||p_nome_file||' - '||
        CASE
            WHEN v_LOCK_result=1 THEN 'Timeout'
            WHEN v_LOCK_result=2 THEN 'Deadlock'
            WHEN v_LOCK_result=3 THEN 'Parameter Error'
            WHEN V_LOCK_RESULT=4 THEN 'Already owned'
            WHEN v_LOCK_result=5 THEN 'Illegal Lock Handle'
        END ,V_UTENTE);
    --- LOCK_FINE

    V_NOTE := 'Arrivato FILE='||p_nome_file;
    update t_MCRE0_wrk_migrrapp_file
    set flg_arrivato = 1,
         dta_upd = sysdate
     where val_nome_file = p_nome_file;
     commit;

     --- LOCK_INIZIO
      V_LOCK_RESULT := DBMS_LOCK.RELEASE(V_LOCKHANDLE);
      PKG_MCRE0_AUDIT.log_app(C_NOME,PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'LOCK upd Relase - '||p_nome_file||' - '||
        CASE
            WHEN v_LOCK_result=1 THEN 'Timeout'
            WHEN v_LOCK_result=2 THEN 'Deadlock'
            WHEN v_LOCK_result=3 THEN 'Parameter Error'
            WHEN V_LOCK_RESULT=4 THEN 'Already owned'
            WHEN v_LOCK_result=5 THEN 'Illegal Lock Handle'
        END ,V_UTENTE);
      --- LOCK_FINE

     V_NOTE := 'Controllo tipo migrazione';
     select nvl(sum(flg_attivo) - sum(decode(flg_attivo,1,flg_arrivato,0)),0),
              nvl(sum(flg_attivo),0)
     into v_ok, v_attivi
     from t_MCRE0_wrk_migrrapp_file f
     where flg_tipo_migrrapp IN(
           select flg_tipo_migrrapp
           from t_MCRE0_wrk_migrrapp_file
           where val_nome_file = p_nome_file
           AND flg_attivo=1
     );



     if(v_ok=0 and v_attivi>0)then
        V_NOTE := 'Creazione script migrazione';
        select ' begin '||c.val_package||'('||c.flg_tipo_migrrapp||', :1 );  end; ', c.flg_tipo_migrrapp
        into v_qry, v_flg_tipo_migrrapp
        from t_MCRE0_wrk_migrrapp_file f,
                t_MCRE0_cl_migrrapp c
        where f.flg_tipo_migrrapp = c.flg_tipo_migrrapp
        and val_nome_file = p_nome_file ;

        --- LOCK_INIZIO
        DBMS_LOCK.ALLOCATE_UNIQUE('migrrapp_exe', V_LOCKHANDLE);
        V_LOCK_RESULT := DBMS_LOCK.REQUEST(V_LOCKHANDLE, DBMS_LOCK.X_MODE);
        PKG_MCRE0_AUDIT.log_app(C_NOME,PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'LOCK --> EXE Request - '||p_nome_file||' - '||
            CASE
                WHEN v_LOCK_result=1 THEN 'Timeout'
                WHEN v_LOCK_result=2 THEN 'Deadlock'
                WHEN v_LOCK_result=3 THEN 'Parameter Error'
                WHEN V_LOCK_RESULT=4 THEN 'Already owned'
                WHEN v_LOCK_result=5 THEN 'Illegal Lock Handle'
            END ,V_UTENTE);
        --- LOCK_FINE

        V_NOTE := 'INIZIO FILE='||p_nome_file;
        update t_MCRE0_wrk_migrrapp_file
        set dta_inizio = sysdate
         where flg_tipo_migrrapp = v_flg_tipo_migrrapp
         and flg_attivo = 1;
         commit;

        V_NOTE := 'Esecuzione migrazione - QRY= '||v_qry;
        execute immediate v_qry using out v_esito;

        V_NOTE := 'INIZIO FILE='||p_nome_file;
        update t_MCRE0_wrk_migrrapp_file
        set dta_fine = sysdate,
               flg_esito = v_esito,
               flg_attivo = 0
         where flg_tipo_migrrapp = v_flg_tipo_migrrapp
         and flg_attivo = 1;
         commit;

        --- LOCK_INIZIO
      V_LOCK_RESULT := DBMS_LOCK.RELEASE(V_LOCKHANDLE);
      PKG_MCRE0_AUDIT.log_app(C_NOME,PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'LOCK --> EXE Release - '||p_nome_file||' - '||
        CASE
            WHEN v_LOCK_result=1 THEN 'Timeout'
            WHEN v_LOCK_result=2 THEN 'Deadlock'
            WHEN v_LOCK_result=3 THEN 'Parameter Error'
            WHEN V_LOCK_RESULT=4 THEN 'Already owned'
            WHEN v_LOCK_result=5 THEN 'Illegal Lock Handle'
        END ,V_UTENTE);
      --- LOCK_FINE
     end if;

    return v_esito;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.log_app(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE,V_UTENTE);
      rollback;
        update t_MCRE0_wrk_migrrapp_file
        set dta_fine = sysdate,
               flg_esito = ko
         where flg_tipo_migrrapp = v_flg_tipo_migrrapp
         and flg_attivo = 1;
         commit;
      RETURN KO;
  END FNC_MCRE0_CHK_MIGRRAPP;

  -- Creazione reports
  function FNC_MCRE0_report_MIGRRAPP(
    P_ID_LOTTO T_MCRE0_ST_MIGRRAPP.ID_LOTTO%TYPE,
    P_FLG_TIPO_MIGRRAPP T_MCRE0_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type,
    p_flg_ante number
  ) RETURN NUMBER
  is

    V_NOTE T_MCRE0_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_UTENTE CONSTANT T_MCRE0_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE:='MIGRRAPP';
    C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRE0_CHK_MIGRRAPP';
    v_esito number(1):=ok;
    v_qry varchar2(3000);
    v_source T_MCRE0_CL_MIGRRAPP.VAL_SOURCE%type;
    v_cnt number;
    V_EXISTS NUMBER;

    CURSOR C_LISTA_TBL IS
      SELECT *
      FROM T_MCRE0_WRK_MIGRRAPP
      where FLG_ATTIVA = 1
      and FLG_TIPO_MIGRRAPP= P_FLG_TIPO_MIGRRAPP;

  begin

      FOR REC_LISTA_TBL IN C_LISTA_TBL
      LOOP

        begin

            if(p_flg_ante=1)then
                if(P_FLG_TIPO_MIGRRAPP=4)then

                    update  t_MCRE0_app_migrrapp_cnt
                    set ID_LOTTO = ID_LOTTO +1
                    where VAL_TABLE_NAME = REC_LISTA_TBL.VAL_TABLE_NAME
                    and FLG_TIPO_MIGRRAPP = P_FLG_TIPO_MIGRRAPP;
                    commit;

                    v_qry := '
                      insert into t_MCRE0_app_migrrapp_cnt
                       (    VAL_TABLE_NAME,
                            FLG_TIPO_MIGRRAPP    ,
                            VAL_SOURCE    ,
                            ID_LOTTO    ,
                            VAL_TOT_RECORD_ANTE,
                            DTA_INS
                        )
                        select '''|| REC_LISTA_TBL.VAL_TABLE_NAME||''' , '||P_FLG_TIPO_MIGRRAPP||',  ''CONFERIMENTI'',  0, count(*), sysdate
                        from ' || REC_LISTA_TBL.VAL_TABLE_NAME || ' m,
                                 T_MCRE0_APP_MIG_RECODE_NDG n,
                                  T_MCRE0_APP_MIG_RECODE_RAPP r
                        where N.COD_ABI_OLD = R.COD_ABI_OLD
                        and N.COD_NDG_OLD = R.COD_NDG_OLD
                        and m.'||REC_LISTA_TBL.VAL_COLUMN_ABI||' = r.cod_abi_old
                        and m.'|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = r.cod_rapporto_old ';
                        IF (nvl(REC_LISTA_TBL.FLG_NDG,0)=1) THEN
                            V_QRY := V_QRY||' and m.COD_NDG = r.cod_ndg_old ';
                        END IF;
                else
                    v_qry := '
                         insert into t_MCRE0_app_migrrapp_cnt
                           (    VAL_TABLE_NAME,
                                FLG_TIPO_MIGRRAPP    ,
                                VAL_SOURCE    ,
                                ID_LOTTO    ,
                                VAL_TOT_RECORD_ANTE,
                                DTA_INS
                            )
                        select '''|| REC_LISTA_TBL.VAL_TABLE_NAME||''' , '||P_FLG_TIPO_MIGRRAPP||',  r.val_source, '||
                                  P_ID_LOTTO||', count(*), sysdate
                        from ' || REC_LISTA_TBL.VAL_TABLE_NAME || ' m,
                               t_MCRE0_st_MIGRRAPP r
                        where R.FLG_TIPO_MIGRRAPP = ' ||P_FLG_TIPO_MIGRRAPP||'
                        and r.id_lotto = '||P_ID_LOTTO||'
                        and m.'||REC_LISTA_TBL.VAL_COLUMN_ABI||' = r.cod_abi
                        and m.'|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = r.cod_rapporto_old
                        and instr('''||REC_LISTA_TBL.val_source_list||''','',''||r.val_source||'','')>0
                        group by r.val_source ';
                   end if;

                       V_NOTE:='ANTE CNT - SELECT - QRY='||v_qry;
                       PKG_MCRE0_AUDIT.LOG_APP(C_NOME,PKG_MCRE0_AUDIT.c_debug,0,0,V_NOTE,V_UTENTE);
                       begin
                         V_NOTE:='ANTE CNT - INSERT - tbl='||REC_LISTA_TBL.VAL_TABLE_NAME||' migr='||P_FLG_TIPO_MIGRRAPP||' lotto='||P_ID_LOTTO;
                         execute immediate v_qry ;
                         commit;
                       exception
                         when no_data_found then
                           null;
                         when others then
                           PKG_MCRE0_AUDIT.LOG_APP(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
                       end;

            else
                        if(P_FLG_TIPO_MIGRRAPP=4)then
                            v_qry := '
                              update t_MCRE0_app_migrrapp_cnt c
                            set VAL_TOT_RECORD_post =   (
                                select  count(*)
                                from ' || REC_LISTA_TBL.VAL_TABLE_NAME || ' m,
                                         T_MCRE0_APP_MIG_RECODE_NDG n,
                                          T_MCRE0_APP_MIG_RECODE_RAPP r
                                where N.COD_ABI_OLD = R.COD_ABI_OLD
                                and N.COD_NDG_OLD = R.COD_NDG_OLD
                                and m.'||REC_LISTA_TBL.VAL_COLUMN_ABI||' = r.cod_abi_new
                                and m.'|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = r.cod_rapporto_new ';
                                IF (nvl(REC_LISTA_TBL.FLG_NDG,0)=1) THEN
                                    V_QRY := V_QRY||' and m.COD_NDG = r.cod_ndg_new ';
                                END IF;
                                V_QRY := V_QRY||' ),
                                 DTA_upd = sysdate
                            where VAL_TABLE_NAME = ''' || REC_LISTA_TBL.VAL_TABLE_NAME || '''
                            and FLG_TIPO_MIGRRAPP =  ' ||P_FLG_TIPO_MIGRRAPP||'
                            and ID_LOTTO =  0 ';
                        else
                             v_qry := '
                             update t_MCRE0_app_migrrapp_cnt c
                                set VAL_TOT_RECORD_post =
                                            ( select count(*)
                                            from ' || REC_LISTA_TBL.VAL_TABLE_NAME || '  m,
                                                    t_MCRE0_st_MIGRRAPP r
                                            where R.FLG_TIPO_MIGRRAPP =  c.FLG_TIPO_MIGRRAPP
                                            and r.id_lotto = c.id_lotto
                                            and r.val_source = c.val_source
                                            and m.'||REC_LISTA_TBL.VAL_COLUMN_ABI||' = r.cod_abi
                                            and m.'|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||'  = r.cod_rapporto_new
                                            and instr('''||REC_LISTA_TBL.val_source_list||''','',''||r.val_source||'','')>0
                                            group by r.val_source ),
                                     DTA_upd = sysdate
                                where VAL_TABLE_NAME = ''' || REC_LISTA_TBL.VAL_TABLE_NAME || '''
                                and FLG_TIPO_MIGRRAPP =  ' ||P_FLG_TIPO_MIGRRAPP||'
                                and ID_LOTTO =  '||P_ID_LOTTO;
                         end if;

                       V_NOTE:='POST CNT - SELECT - QRY='||v_qry;
                       PKG_MCRE0_AUDIT.LOG_APP(C_NOME,PKG_MCRE0_AUDIT.c_debug,0,0,V_NOTE,V_UTENTE);
                        begin
                            V_NOTE:='POST CNT - UPDATE - tbl='||REC_LISTA_TBL.VAL_TABLE_NAME||' migr='||P_FLG_TIPO_MIGRRAPP||' lotto='||P_ID_LOTTO;
                            execute immediate v_qry;
                            commit;
                        exception
                         when no_data_found then
                           null;
                         when others then
                           PKG_MCRE0_AUDIT.LOG_APP(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
                       end;

                      BEGIN
                            select DISTINCT 1
                            INTO V_EXISTS
                            from user_TAB_COLUMNS
                            where table_name = REC_LISTA_TBL.VAL_TABLE_NAME
                            AND COLUMN_NAME = 'COD_NDG';
                      EXCEPTION
                        WHEN OTHERS THEN
                          V_EXISTS :=0;
                      END;

                        IF (V_EXISTS=1 and P_FLG_TIPO_MIGRRAPP!=4) THEN
                            v_qry := '
                            insert into t_MCRE0_app_migrrapp_chk
                            (  VAL_TABLE_NAME,
                                flg_tipo_migrrapp,
                                VAL_SOURCE    ,
                                id_lotto ,
                                COD_ABI              ,
                                COD_NDG      ,
                                COD_RAPPORTO_OLD      ,
                                COD_RAPPORTO_new    ,
                                COD_NDG_atteso    ,
                                dta_ins )
                            select ''' ||REC_LISTA_TBL.VAL_TABLE_NAME ||''' ,
                                      '||P_FLG_TIPO_MIGRRAPP ||',
                                      r.val_source,
                                      '||P_ID_LOTTO||',
                                      m.'||REC_LISTA_TBL.VAL_COLUMN_ABI||' ,
                                      m.cod_ndg,
                                      r.cod_rapporto_old,
                                      r.cod_rapporto_new,
                                      r.cod_ndg cod_ndg_atteso,
                                      sysdate
                            from ' ||REC_LISTA_TBL.VAL_TABLE_NAME ||' m,
                                   t_MCRE0_st_MIGRRAPP r
                            where R.FLG_TIPO_MIGRRAPP = ' || P_FLG_TIPO_MIGRRAPP ||'
                            and r.id_lotto = '||P_ID_LOTTO||'
                            and m.'||REC_LISTA_TBL.VAL_COLUMN_ABI||' = r.cod_abi
                            and m.'|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = r.cod_rapporto_new
                            and instr('''||REC_LISTA_TBL.val_source_list||''','',''||r.val_source||'','')>0
                            and not exists (
                              select distinct 1
                              from V_MCRE0_MIGRRAPP s
                              where s.FLG_TIPO_MIGRRAPP = ' || P_FLG_TIPO_MIGRRAPP ||'
                                and m.'||REC_LISTA_TBL.VAL_COLUMN_ABI||'  = s.cod_abi
                                and m.cod_ndg = s.cod_ndg
                                and m.'|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = s.cod_rapporto_new
                                and r.val_source = s.val_source
                            )';


                           V_NOTE:='POST RAPP - QRY='||v_qry;
                           PKG_MCRE0_AUDIT.LOG_APP(C_NOME,PKG_MCRE0_AUDIT.c_debug,0,0,V_NOTE,V_UTENTE);
                           execute immediate v_qry ;
                           commit;
                       end if;
            end if;

        exception
            WHEN OTHERS THEN
                PKG_MCRE0_AUDIT.LOG_APP(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
                v_esito := v_esito*ko;
        END;
      end loop;

   return v_esito;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.log_app(C_NOME,PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE,V_UTENTE);
      RETURN KO;
  END FNC_MCRE0_report_MIGRRAPP;

END PKG_MCRE0_MIGRRAPP;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_MIGRRAPP FOR MCRE_OWN.PKG_MCRE0_MIGRRAPP;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_MIGRRAPP FOR MCRE_OWN.PKG_MCRE0_MIGRRAPP;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_MIGRRAPP TO MCRE_USR;

