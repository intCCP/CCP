CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRES_MIGRRAPP AS
  /******************************************************************************
     NAME:       PKG_MCRES_ALIMENTAZIONE
     PURPOSE:

     REVISIONS:
     Ver        Date        Author             Description
     ---------  ----------      -----------------  ------------------------------------
     1.0      14/02/2012  V.Galli     Created this package.
     1.1      18/06/2012  V.Galli    Versione per shell con report
  ******************************************************************************/

  FUNCTION FNC_MCRES_ALIMENTA_ST_MIGRRAPP(
    P_FLG_TIPO_MIGRRAPP T_MCRES_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type
  ) RETURN T_MCRES_ST_MIGRRAPP.id_lotto%type
  IS

    V_NOTE T_MCRES_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_UTENTE CONSTANT T_MCRES_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE:='MIGRRAPP';
    C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_ALIMENTA_ST_MIGRRAPP';
    V_id_lotto_NUOVO T_MCRES_ST_MIGRRAPP.id_lotto%type;

  BEGIN

    V_NOTE:='Calcolo progressivo migrazione';
    begin
      SELECT MAX(id_lotto)+1
      INTO V_id_lotto_NUOVO
      from T_MCRES_ST_MIGRRAPP
      where FLG_TIPO_MIGRRAPP = P_FLG_TIPO_MIGRRAPP;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_id_lotto_NUOVO:=1;
      WHEN OTHERS THEN
        PKG_MCRES_AUDIT.log_app(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
        return ko;
    end;

    V_NOTE:='Insert ST migrazione TIPO_MIGRRAPP='||P_FLG_TIPO_MIGRRAPP;
    begin
      INSERT /*+ append */ INTO T_MCRES_ST_MIGRRAPP
      (VAL_SOURCE,ID_LOTTO,ID_DPER,COD_ABI,COD_NDG,COD_RAPPORTO_OLD,COD_RAPPORTO_NEW,COD_FILIALE_ORIG,COD_FILIALE_DEST,FLG_TIPO_MIGRRAPP,DTA_INS)
      select VAL_SOURCE,NVL(V_ID_LOTTO_NUOVO,1) ID_LOTTO,ID_DPER,COD_ABI,COD_NDG,COD_RAPPORTO_OLD,COD_RAPPORTO_NEW,COD_FILIALE_orig,cod_filiale_dest,FLG_TIPO_MIGRRAPP,DTA_INS
      from V_MCRES_MIGRRAPP E
      where E.FLG_TIPO_MIGRRAPP = P_FLG_TIPO_MIGRRAPP;
      commit;
    EXCEPTION
      WHEN OTHERS THEN
        PKG_MCRES_AUDIT.log_app(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
        RETURN KO;
    end;

    RETURN nvl(V_id_lotto_NUOVO,1);

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.log_app(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE,V_UTENTE);
      RETURN KO;
  END FNC_MCRES_ALIMENTA_ST_MIGRRAPP;

  function FNC_MCRES_TBL_MIGRRAPP(
    P_ID_LOTTO T_MCRES_ST_MIGRRAPP.ID_LOTTO%TYPE,
    P_FLG_TIPO_MIGRRAPP T_MCRES_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type
  ) RETURN NUMBER
  IS

    V_NOTE T_MCRES_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_UTENTE CONSTANT T_MCRES_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE:='MIGRRAPP';
    C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_TBL_MIGRRAPP';
    v_qry varchar2(3000);
    V_COD_RAPPORTO_OLD T_MCRES_ST_MIGRRAPP.COD_RAPPORTO_OLD%TYPE;
    V_FLG_RAPPORTO_ASSENTE T_MCRES_APP_MIGRRAPP.FLG_RAPPORTO_ASSENTE%TYPE;
    v_COLUMN_NAME ALL_CONS_COLUMNS.COLUMN_NAME%type;

    CURSOR C_LISTA_TBL IS
      SELECT *
      FROM T_MCRES_WRK_MIGRRAPP
      where FLG_ATTIVA = 1
      and FLG_TIPO_MIGRRAPP= P_FLG_TIPO_MIGRRAPP;

    CURSOR C_LISTA_RAPPORTI IS
      SELECT *
      FROM T_MCRES_ST_MIGRRAPP
      where ID_LOTTO = P_ID_LOTTO
      and FLG_TIPO_MIGRRAPP= P_FLG_TIPO_MIGRRAPP;

  BEGIN

    FOR REC_LISTA_TBL IN C_LISTA_TBL
    LOOP

      FOR REC_LISTA IN C_LISTA_RAPPORTI
      LOOP

        if (instr(REC_LISTA_TBL.val_source_list,','||REC_LISTA.val_source||',')>0) then
          V_NOTE:='Chk esistenza';
          BEGIN
            V_QRY := '
              select distinct '|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||'
              from '|| REC_LISTA_TBL.VAL_TABLE_NAME ||'
              where '|| nvl(REC_LISTA_TBL.VAL_WHERE_CONDITION,'1=1') ||'
              and '||REC_LISTA_TBL.VAL_COLUMN_ABI||' = :1 ';
            IF (nvl(REC_LISTA_TBL.FLG_NDG,0)=1) THEN
              V_QRY := V_QRY||' and cod_ndg = :2 ';
            END IF;
            V_QRY := V_QRY||' and '|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = :3 ';
            IF (nvl(REC_LISTA_TBL.FLG_NDG,0)=1) THEN
              EXECUTE IMMEDIATE V_QRY INTO V_COD_RAPPORTO_OLD USING REC_LISTA.COD_ABI, REC_LISTA.COD_NDG, REC_LISTA.COD_RAPPORTO_OLD ;
            ELSE
              EXECUTE IMMEDIATE V_QRY INTO V_COD_RAPPORTO_OLD USING REC_LISTA.COD_ABI, REC_LISTA.COD_RAPPORTO_OLD ;
            end if;
            v_FLG_RAPPORTO_ASSENTE:=0;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_FLG_RAPPORTO_ASSENTE:=1;
            WHEN OTHERS THEN
              PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
              v_FLG_RAPPORTO_ASSENTE:=-1;
          end;

          V_NOTE:='Insert tab APP_MIGR';
          BEGIN
            INSERT INTO T_MCRES_APP_MIGRRAPP P
            (VAL_SOURCE, VAL_OBJECT_NAME,ID_LOTTO,ID_DPER,COD_ABI,COD_NDG,COD_RAPPORTO_OLD,COD_RAPPORTO_NEW,COD_FILIALE_orig,cod_filiale_dest,FLG_RAPPORTO_ASSENTE,FLG_TIPO_MIGRRAPP,dta_ins)
            VALUES
            (REC_LISTA.VAL_SOURCE,REC_LISTA_TBL.VAL_TABLE_NAME,P_ID_LOTTO,REC_LISTA.ID_DPER,REC_LISTA.COD_ABI,REC_LISTA.COD_NDG,REC_LISTA.COD_RAPPORTO_old,REC_LISTA.COD_RAPPORTO_NEW,REC_LISTA.cod_filiale_orig,REC_LISTA.cod_filiale_dest,V_FLG_RAPPORTO_ASSENTE,P_FLG_TIPO_MIGRRAPP,sysdate);
            commit;
          EXCEPTION
            WHEN OTHERS THEN
              PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
          end;

          if(v_FLG_RAPPORTO_ASSENTE=0) then
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
                PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'PK violata - '||V_NOTE,V_UTENTE);
                rollback;
                begin
                  UPDATE T_MCRES_APP_MIGRRAPP
                  SET FLG_PK_DUPLICATA = 1
                  WHERE ID_LOTTO = P_ID_LOTTO
                  and VAL_OBJECT_NAME = REC_LISTA_TBL.VAL_TABLE_NAME
                  and COD_ABI = REC_LISTA.COD_ABI
                  AND COD_NDG = REC_LISTA.COD_NDG
                  AND COD_RAPPORTO_OLD = V_COD_RAPPORTO_OLD;
                  COMMIT;
                EXCEPTION
                  WHEN OTHERS THEN
                    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'PK violata - TBL='||REC_LISTA_TBL.VAL_TABLE_NAME||' RAPP_OLD='||V_COD_RAPPORTO_OLD,V_UTENTE);
                end;
              WHEN OTHERS THEN
                PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
            END;
          end if;
        end if;

      END LOOP;

    end loop;

    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.log_app(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE,V_UTENTE);
      RETURN KO;
  END FNC_MCRES_TBL_MIGRRAPP;

  function FNC_MCRES_TBL_MIGRRAPP_3(
    P_ID_LOTTO T_MCRES_ST_MIGRRAPP.ID_LOTTO%TYPE,
    P_FLG_TIPO_MIGRRAPP T_MCRES_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type
  ) RETURN NUMBER
  IS

    V_NOTE T_MCRES_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_UTENTE CONSTANT T_MCRES_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE:='MIGRRAPP';
    C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_TBL_MIGRRAPP_3';
    v_qry varchar2(3000);
    v_COLUMN_NAME ALL_CONS_COLUMNS.COLUMN_NAME%type;
    v_esito number(1):=ok;

    CURSOR C_LISTA_TBL IS
      SELECT *
      FROM T_MCRES_WRK_MIGRRAPP
      where FLG_ATTIVA = 1
      and FLG_TIPO_MIGRRAPP= P_FLG_TIPO_MIGRRAPP
      order by val_ordine;

    CURSOR C_LISTA_RAPPORTI IS
      SELECT *
      FROM T_MCRES_ST_MIGRRAPP
      where ID_LOTTO = P_ID_LOTTO
      and FLG_TIPO_MIGRRAPP= P_FLG_TIPO_MIGRRAPP
      order by cod_abi,cod_rapporto_old;

  BEGIN

    FOR REC_LISTA_TBL IN C_LISTA_TBL
    LOOP

      PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_DEBUG,0,0,REC_LISTA_TBL.VAL_TABLE_NAME,V_UTENTE);
      v_esito:=OK;

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
                PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'PK violata - '||V_NOTE,V_UTENTE);
                rollback;
                v_esito:=v_esito*ko;
                begin
                  UPDATE T_MCRES_ST_MIGRRAPP
                  SET TBL_PK_DUPLICATA = nvl(TBL_PK_DUPLICATA,',')||REC_LISTA_TBL.VAL_TABLE_NAME||','
                  WHERE ID_LOTTO = P_ID_LOTTO
                  and COD_ABI = REC_LISTA.COD_ABI
                  AND COD_NDG = REC_LISTA.COD_NDG
                  AND COD_RAPPORTO_OLD = REC_LISTA.COD_RAPPORTO_OLD;
                  COMMIT;
                EXCEPTION
                  WHEN OTHERS THEN
                    PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'PK violata - TBL='||REC_LISTA_TBL.VAL_TABLE_NAME||' RAPP_OLD='||REC_LISTA.COD_RAPPORTO_OLD,V_UTENTE);
                end;
              WHEN OTHERS THEN
                PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
                v_esito:=v_esito*ko;
            END;
        end if;

      END LOOP;

       V_NOTE := 'Fine migrrapp '||P_FLG_TIPO_MIGRRAPP||' - Tabella='|| REC_LISTA_TBL.VAL_TABLE_NAME;
        update t_mcres_wrk_migrrapp
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
      PKG_MCRES_AUDIT.log_app(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE,V_UTENTE);
      RETURN KO;
  END FNC_MCRES_TBL_MIGRRAPP_3;

  procedure PRC_MCRES_EXE_MIGRRAPP(
    P_FLG_TIPO_MIGRRAPP T_MCRES_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type,
    p_esito out number
  )
  IS

    V_NOTE T_MCRES_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_UTENTE CONSTANT T_MCRES_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE:='MIGRRAPP';
    C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.PRCC_MCRES_EXE_MIGRRAPP';
    V_ID_LOTTO T_MCRES_ST_MIGRRAPP.ID_LOTTO%TYPE;
    v_esito NUMBER := KO;

  BEGIN

    if(NVL(P_FLG_TIPO_MIGRRAPP,4) not in (1,2,3)) then
      p_esito := V_ESITO;
    END IF;

    V_NOTE:='Da TE in ST';
    V_ID_LOTTO:=PKG_MCRES_MIGRRAPP.FNC_MCRES_ALIMENTA_ST_MIGRRAPP(P_FLG_TIPO_MIGRRAPP);
    if (V_ID_LOTTO!=KO)then

      v_esito:= FNC_MCRES_report_MIGRRAPP(V_ID_LOTTO,P_FLG_TIPO_MIGRRAPP,1);
      --if(v_esito!=ko)then
        v_esito:=PKG_MCRES_MIGRRAPP.FNC_MCRES_TBL_MIGRRAPP_3(V_ID_LOTTO,P_FLG_TIPO_MIGRRAPP);
      --end if;
      v_esito:=v_esito *  FNC_MCRES_report_MIGRRAPP(V_ID_LOTTO,P_FLG_TIPO_MIGRRAPP,0);

    END IF;

    p_esito := v_esito;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.log_app(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE,V_UTENTE);
      p_esito := ko;
  END prc_MCRES_EXE_MIGRRAPP;


  -- Esecuzione da TWS
  function FNC_MCRES_chk_MIGRRAPP(
    p_nome_file T_MCRES_WRK_MIGRRAPP_FILE.VAL_NOME_FILE%type
  )RETURN number
  IS

    V_NOTE T_MCRES_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_UTENTE CONSTANT T_MCRES_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE:='MIGRRAPP';
    C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_CHK_MIGRRAPP';
    v_esito number(1):=ok;
    v_ok number;
    v_attivi number;
    v_qry varchar2(3000);
    v_flg_tipo_migrrapp T_MCRES_WRK_MIGRRAPP_FILE.FLG_TIPO_MIGRRAPP%type;

    --- LOCK
      V_LOCK_RESULT NUMBER;
      V_LOCKHANDLE  VARCHAR2(200);

  BEGIN

    --- LOCK_INIZIO
    DBMS_LOCK.ALLOCATE_UNIQUE('t_mcres_wrk_migrrapp_file', V_LOCKHANDLE);
    V_LOCK_RESULT := DBMS_LOCK.REQUEST(V_LOCKHANDLE, DBMS_LOCK.X_MODE);
    PKG_MCRES_AUDIT.log_app(C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'LOCK upd Request - '||p_nome_file||' - '||
        CASE
            WHEN v_LOCK_result=1 THEN 'Timeout'
            WHEN v_LOCK_result=2 THEN 'Deadlock'
            WHEN v_LOCK_result=3 THEN 'Parameter Error'
            WHEN V_LOCK_RESULT=4 THEN 'Already owned'
            WHEN v_LOCK_result=5 THEN 'Illegal Lock Handle'
        END ,V_UTENTE);
    --- LOCK_FINE

    V_NOTE := 'Arrivato FILE='||p_nome_file;
    update t_mcres_wrk_migrrapp_file
    set flg_arrivato = 1,
         dta_upd = sysdate
     where val_nome_file = p_nome_file;
     commit;

     --- LOCK_INIZIO
      V_LOCK_RESULT := DBMS_LOCK.RELEASE(V_LOCKHANDLE);
      PKG_MCRES_AUDIT.log_app(C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'LOCK upd Relase - '||p_nome_file||' - '||
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
     from t_mcres_wrk_migrrapp_file f
     where flg_tipo_migrrapp IN(
           select flg_tipo_migrrapp
           from t_mcres_wrk_migrrapp_file
           where val_nome_file = p_nome_file
           AND flg_attivo=1
     );



     if(v_ok=0 and v_attivi>0)then
        V_NOTE := 'Creazione script migrazione';
        select ' begin '||c.val_package||'('||c.flg_tipo_migrrapp||', :1 );  end; ', c.flg_tipo_migrrapp
        into v_qry, v_flg_tipo_migrrapp
        from t_mcres_wrk_migrrapp_file f,
                t_mcres_cl_migrrapp c
        where f.flg_tipo_migrrapp = c.flg_tipo_migrrapp
        and val_nome_file = p_nome_file ;

        --- LOCK_INIZIO
        DBMS_LOCK.ALLOCATE_UNIQUE('migrrapp_exe', V_LOCKHANDLE);
        V_LOCK_RESULT := DBMS_LOCK.REQUEST(V_LOCKHANDLE, DBMS_LOCK.X_MODE);
        PKG_MCRES_AUDIT.log_app(C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'LOCK --> EXE Request - '||p_nome_file||' - '||
            CASE
                WHEN v_LOCK_result=1 THEN 'Timeout'
                WHEN v_LOCK_result=2 THEN 'Deadlock'
                WHEN v_LOCK_result=3 THEN 'Parameter Error'
                WHEN V_LOCK_RESULT=4 THEN 'Already owned'
                WHEN v_LOCK_result=5 THEN 'Illegal Lock Handle'
            END ,V_UTENTE);
        --- LOCK_FINE

        V_NOTE := 'INIZIO FILE='||p_nome_file;
        update t_mcres_wrk_migrrapp_file
        set dta_inizio = sysdate
         where flg_tipo_migrrapp = v_flg_tipo_migrrapp
         and flg_attivo = 1;
         commit;

        V_NOTE := 'Esecuzione migrazione - QRY= '||v_qry;
        execute immediate v_qry using out v_esito;

        V_NOTE := 'INIZIO FILE='||p_nome_file;
        update t_mcres_wrk_migrrapp_file
        set dta_fine = sysdate,
               flg_esito = v_esito,
               flg_attivo = 0
         where flg_tipo_migrrapp = v_flg_tipo_migrrapp
         and flg_attivo = 1;
         commit;

        --- LOCK_INIZIO
      V_LOCK_RESULT := DBMS_LOCK.RELEASE(V_LOCKHANDLE);
      PKG_MCRES_AUDIT.log_app(C_NOME,PKG_MCRES_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'LOCK --> EXE Release - '||p_nome_file||' - '||
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
      PKG_MCRES_AUDIT.log_app(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE,V_UTENTE);
      rollback;
        update t_mcres_wrk_migrrapp_file
        set dta_fine = sysdate,
               flg_esito = ko
         where flg_tipo_migrrapp = v_flg_tipo_migrrapp
         and flg_attivo = 1;
         commit;
      RETURN KO;
  END FNC_MCRES_CHK_MIGRRAPP;

  -- Creazione reports
  function FNC_MCRES_report_MIGRRAPP(
    P_ID_LOTTO T_MCRES_ST_MIGRRAPP.ID_LOTTO%TYPE,
    P_FLG_TIPO_MIGRRAPP T_MCRES_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type,
    p_flg_ante number
  ) RETURN NUMBER
  is

    V_NOTE T_MCRES_WRK_AUDIT_APPLICATIVO.NOTE%TYPE;
    V_UTENTE CONSTANT T_MCRES_WRK_AUDIT_APPLICATIVO.UTENTE%TYPE:='MIGRRAPP';
    C_NOME  CONSTANT VARCHAR2(100) := C_PACKAGE || '.FNC_MCRES_CHK_MIGRRAPP';
    v_esito number(1):=ok;
    v_qry varchar2(3000);
    v_source T_MCRES_CL_MIGRRAPP.VAL_SOURCE%type;
    v_cnt number;
    V_EXISTS NUMBER;

    CURSOR C_LISTA_TBL IS
      SELECT *
      FROM T_MCRES_WRK_MIGRRAPP
      where FLG_ATTIVA = 1
      and FLG_TIPO_MIGRRAPP= P_FLG_TIPO_MIGRRAPP;

  begin

      FOR REC_LISTA_TBL IN C_LISTA_TBL
      LOOP

        begin

            if(p_flg_ante=1)then
                    v_qry := '
                         insert into t_mcres_app_migrrapp_cnt
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
                               t_MCRES_st_MIGRRAPP r
                        where R.FLG_TIPO_MIGRRAPP = ' ||P_FLG_TIPO_MIGRRAPP||'
                        and r.id_lotto = '||P_ID_LOTTO||'
                        and m.'||REC_LISTA_TBL.VAL_COLUMN_ABI||' = r.cod_abi
                        and m.'|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = r.cod_rapporto_old
                        and instr('''||REC_LISTA_TBL.val_source_list||''','',''||r.val_source||'','')>0
                        group by r.val_source ';

                       V_NOTE:='ANTE CNT - SELECT - QRY='||v_qry;
                       PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.c_debug,0,0,V_NOTE,V_UTENTE);
                       begin
                         V_NOTE:='ANTE CNT - INSERT - tbl='||REC_LISTA_TBL.VAL_TABLE_NAME||' migr='||P_FLG_TIPO_MIGRRAPP||' lotto='||P_ID_LOTTO;
                         execute immediate v_qry ;
                         commit;
                       exception
                         when no_data_found then
                           null;
                         when others then
                           PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
                       end;

                    else

                         v_qry := '
                         update t_mcres_app_migrrapp_cnt c
                            set VAL_TOT_RECORD_post =
                                        ( select count(*)
                                        from ' || REC_LISTA_TBL.VAL_TABLE_NAME || '  m,
                                                t_MCRES_st_MIGRRAPP r
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

                       V_NOTE:='POST CNT - SELECT - QRY='||v_qry;
                       PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.c_debug,0,0,V_NOTE,V_UTENTE);
                        begin
                            V_NOTE:='POST CNT - UPDATE - tbl='||REC_LISTA_TBL.VAL_TABLE_NAME||' migr='||P_FLG_TIPO_MIGRRAPP||' lotto='||P_ID_LOTTO;
                            execute immediate v_qry;
                            commit;
                        exception
                         when no_data_found then
                           null;
                         when others then
                           PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
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

                        IF (V_EXISTS=1) THEN
                            v_qry := '
                            insert into t_mcres_app_migrrapp_chk
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
                                   t_MCRES_st_MIGRRAPP r
                            where R.FLG_TIPO_MIGRRAPP = ' || P_FLG_TIPO_MIGRRAPP ||'
                            and r.id_lotto = '||P_ID_LOTTO||'
                            and m.'||REC_LISTA_TBL.VAL_COLUMN_ABI||' = r.cod_abi
                            and m.'|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = r.cod_rapporto_new
                            and instr('''||REC_LISTA_TBL.val_source_list||''','',''||r.val_source||'','')>0
                            and not exists (
                              select distinct 1
                              from V_MCRES_MIGRRAPP s
                              where s.FLG_TIPO_MIGRRAPP = ' || P_FLG_TIPO_MIGRRAPP ||'
                                and m.'||REC_LISTA_TBL.VAL_COLUMN_ABI||'  = s.cod_abi
                                and m.cod_ndg = s.cod_ndg
                                and m.'|| REC_LISTA_TBL.VAL_COLUMN_RAPPORTO ||' = s.cod_rapporto_new
                                and r.val_source = s.val_source
                            )';


                           V_NOTE:='POST RAPP - QRY='||v_qry;
                           PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.c_debug,0,0,V_NOTE,V_UTENTE);
                           execute immediate v_qry ;
                           commit;
                       end if;
                    end if;
            exception
            WHEN OTHERS THEN
                PKG_MCRES_AUDIT.LOG_APP(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,V_NOTE,V_UTENTE);
                v_esito := v_esito*ko;
            END;
      end loop;

   return v_esito;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRES_AUDIT.log_app(C_NOME,PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - '||V_NOTE,V_UTENTE);
      RETURN KO;
  END FNC_MCRES_report_MIGRRAPP;

END PKG_MCRES_MIGRRAPP;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_MIGRRAPP FOR MCRE_OWN.PKG_MCRES_MIGRRAPP;


CREATE SYNONYM MCRE_USR.PKG_MCRES_MIGRRAPP FOR MCRE_OWN.PKG_MCRES_MIGRRAPP;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_MIGRRAPP TO MCRE_USR;

