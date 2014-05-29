CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_ALERT_2 AS
/******************************************************************************
   NAME:     PKG_MCRE0_ALERT
   PURPOSE: Gestione alert ed evidenze

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        13/10/2010  Galli         Valeria      Created this package.
   1.1        19/11/2010  Galli         Valeria      Tabella CL_STATI cambiata in APP_STATI.
   2.0        02/12/2010  Galli         Valeria      Congelato.
   2.1        11/01/2011                M.Murro      resa autonoma la sessione per i commit..
   2.2        25/01/2011                M.Murro      spostato il commit sulla VerificaAlert
   2.3        08/02/2011  Galli         Valeria      colore indipendente da dta_ins
   2.4        06/04/2011  Galli         Valeria      filtri solo per pos flg_outsourcing=Y e flg_target=Y
   2.5        10/05/2011  Galli         Valeria      Sistemata chiamata per SNDG (per allinea stato)
   2.6        23/05/2011  Galli         Valeria      Elenco posizioni preso da UPD_FIELD
   2.7        26/05/2011  GAlli         Valeria      Nuova gestione LOG
   2.8        14/06/2011  GAlli         Valeria      distinct in qry spegnimento
   3.0        03/08/2011                M.Murro      Tuning: upd_fields
   3.1        17/10/2011  L.Ferretti    M.Murro      Funzione chiamata alert a blocchi (e clean alert)
   3.2                05/12/2011  Guzzi         Alberto      pkg2
******************************************************************************/

---------------------------------------------
  -- Procedura per insert tappi su alert
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   --no COMMIT
  FUNCTION FNC_INSERT_ALERT_TAPPI(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  )RETURN NUMBER  is

     V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
     V_RESULT NUMBER:=0;
     V_RESULT_CLEAN number:=0;
     V_TOT_ALERT number;

  BEGIN

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;
    
    /*INSERT DELLE POSIZIONI PER CUI PUO ESISTERE UN ALERT*/
        MERGE INTO T_MCRE0_APP_ALERT_POS b
        USING (
            SELECT 
                  xx.COD_ABI_CARTOLARIZZATO
                 ,xx.COD_NDG
                 ,xx.COD_SNDG
            FROM V_MCRE0_APP_UPD_FIELDS_P1 xx,
                      MCRE_OWN.MV_MCRE0_APP_ISTITUTI I,
                      T_MCRE0_APP_COMPARTI C,
                      T_MCRE0_APP_STATI s
            WHERE 
                        xx.COD_COMPARTO = C.COD_COMPARTO AND xx.COD_STATO = S.cod_microstato
                 AND (C.FLG_CHK = '1'
                      OR xx.DTA_LAST_RIPORTAF BETWEEN TRUNC (SYSDATE) - 30 AND TRUNC (SYSDATE + 1))
                 AND S.FLG_ALERT = '1'
                 AND xx.cod_abi_cartolarizzato = i.cod_abi
                 AND NVL (xx.flg_outsourcing, 'N') = 'Y'
                 AND I.FLG_TARGET = 'Y'
          minus
            select
              COD_ABI_CARTOLARIZZATO, COD_NDG , COD_SNDG
            from
                T_MCRE0_APP_ALERT_POS) e
        ON (b.cod_abi_cartolarizzato = e.cod_abi_cartolarizzato and b.cod_ndg=e.cod_ndg)
        WHEN MATCHED THEN
          UPDATE SET b.cod_sndg = e.cod_sndg
        WHEN NOT MATCHED THEN
          INSERT (b.cod_abi_cartolarizzato,b.cod_ndg,b.cod_sndg)
          VALUES (e.cod_abi_cartolarizzato,e.cod_ndg,e.cod_sndg)
        ;
  
  commit;


    RETURN ok;
    
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_INSERT_ALERT_TAPPI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Errore generale');
      return ko;
  end;

---------------------------------------------
  -- Procedura per insert/update alert accesi
  -- INPUT :
  --    cod_abi
  --    cod_ndg
  --    cod_sndg
  --    id_utente
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   --no COMMIT
  FUNCTION fnc_verifica_alert_accesi(
    p_cod_abi   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    P_COD_SNDG  T_MCRE0_APP_ALL_DATA.COD_SNDG%TYPE,
    P_ID_UTENTE T_MCRE0_APP_UTENTI.ID_UTENTE%TYPE,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  )
  RETURN NUMBER IS
  --pragma autonomous_transaction;

    v_qry   varchar2(32000);
    v_where_1 varchar2(32000);
    v_where_2 varchar2(32000);
    v_exist number;
    v_alert T_MCRE0_APP_ALERT_POS.ALERT_1%TYPE;
    v_dta_ins date; --varchar2(10);
    v_abi_istituto T_MCRE0_APP_ALL_DATA.cod_abi_istituto%type;
    V_COD_STATO T_MCRE0_APP_STATI.COD_MACROSTATO%TYPE;
    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    v_countupdate number;
    cursor c_alert is
      select *
      from   T_MCRE0_APP_ALERT a
      WHERE  A.FLG_ATTIVO = 'A'
      and id_alert = nvl(p_id_alert,id_alert)
      order by a.ID_ALERT;

  BEGIN

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    begin
      select nvl(s.COD_MACROSTATO,s.COD_MICROSTATO) cod_stato , m.COD_ABI_ISTITUTO
      into  v_cod_stato, v_abi_istituto
      from  T_MCRE0_APP_ALL_DATA m, --v3.0 mopl
            T_MCRE0_APP_STATI s
      where s.COD_MICROSTATO = m.COD_STATO
      and   m.COD_ABI_CARTOLARIZZATO = p_cod_abi
      and   m.COD_NDG = p_cod_ndg;
    exception
      when no_data_found then
         v_alert:=null;
      WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'SELECT macrostato - ABI='||p_cod_abi||' NDG='||p_cod_ndg,P_ID_UTENTE);
        return ko;
    end;

    for rec_alert in c_alert loop

      v_alert := null;
      v_exist := 0;
      v_dta_ins:=NULL;

      begin
        v_alert := null;
        V_QRY:= NULL;
        --v_qry:= v_qry || ' select 1,'||rec_alert.VAL_PLSQL_COLORE;
        --v_qry:= v_qry || ' from   T_MCRE0_APP_ALERT_POS';
        --v_qry:= v_qry || ' where cod_abi_cartolarizzato = '''||p_cod_abi||'''';
        --V_QRY:= V_QRY || ' and   cod_ndg = '''||P_COD_NDG||'''';

        v_qry:= v_qry || ' select 1,'||rec_alert.VAL_PLSQL_COLORE;
        v_qry:= v_qry || ' from   T_MCRE0_APP_ALERT_POS';
        v_qry:= v_qry || ' where cod_abi_cartolarizzato = :cod_abi_cartolarizzato';
        V_QRY:= V_QRY || ' and   cod_ndg = :cod_ndg';


        execute immediate V_QRY into v_exist, V_ALERT using p_cod_abi, P_COD_NDG;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_EXIST:=0;
          V_ALERT:=null;
        WHEN OTHERS THEN
          PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||rec_alert.id_alert||' - SELECT colore - QRY='||v_qry,P_ID_UTENTE);
          return ko;
      end;

     IF(V_EXIST=1) THEN
        if(V_ALERT is null) then
          V_QRY:= REPLACE(UPPER(REC_ALERT.VAL_PLSQL_COLORE),UPPER('DTA_INS_')||REC_ALERT.ID_ALERT,'sysdate');
          V_QRY:= REPLACE(UPPER(V_QRY),UPPER('when ALERT_')||REC_ALERT.ID_ALERT||UPPER(' is null then null'),' ');
          V_QRY:= REPLACE(V_QRY,'T_MCRE0_APP_ALERT_POS',rec_alert.val_table_name);
          v_qry:=  ' select  '||V_QRY;
          v_qry:= v_qry || ' from  '||rec_alert.val_list_table;
          if(rec_alert.VAL_PLSQL_JOIN is null)then
            v_qry:= v_qry || ' where 1=1';
          else
            v_qry:= v_qry || ' where '||rec_alert.VAL_PLSQL_JOIN;
          end if;
          if(rec_alert.tip_info='Settoriale')then
            v_where_1 := p_cod_abi;
            v_where_2 := p_cod_ndg;
            v_qry := v_qry || ' and '||rec_alert.val_table_name||'.COD_ABI_CARTOLARIZZATO = :where_1';
            v_qry := v_qry || ' and '||rec_alert.val_table_name||'.COD_NDG =:where_2';
            
          else
            v_where_1 := p_cod_sndg;
            v_where_2 := p_cod_sndg;
            v_qry := v_qry || ' and '||rec_alert.val_table_name||'.COD_SNDG = :where_1';
            v_qry := v_qry || ' and :where_2 is not null';
            
          end if;
          v_qry:= v_qry || ' and   '||rec_alert.val_plsql_where_a;

          begin
            if(instr(v_qry,':p_id_utente')>0)then
              execute immediate v_qry into v_alert using p_id_utente, v_where_1,v_where_2;
            else
              execute immediate v_qry into v_alert using v_where_1,v_where_2;
            end if;
          exception
            when no_data_found then
               v_alert:= null;
            WHEN OTHERS THEN
              PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||REC_ALERT.ID_ALERT||' - SELECT colore record - QRY='||V_QRY,P_ID_UTENTE);
              return ko;
          END;
        END iF;

        if(V_ALERT is not null) then
          begin
            v_qry:= null;
            --v_qry:= v_qry || ' update T_MCRE0_APP_ALERT_POS a ';
            --v_qry:= v_qry || ' set alert_'||rec_alert.id_alert||' = '''||v_alert||''',';
            --v_qry:= v_qry || '     cod_stato_'||rec_alert.id_alert||' = '''||v_cod_stato||''', ';
            --V_QRY:= V_QRY || '     dta_upd_'||REC_ALERT.ID_ALERT||' = sysdate,';
            --v_qry:= v_qry || '     dta_ins_'||REC_ALERT.ID_ALERT||' = nvl(dta_ins_'||REC_ALERT.ID_ALERT||',sysdate), ';
            --v_qry:= v_qry || '     a.flg_worse_upd_'||rec_alert.id_alert||' = decode(sign(decode(alert_'||rec_alert.id_alert||',''V'',1,''A'',2,''R'',3,4)-decode('''||v_alert||''',''V'',1,''A'',2,''R'',3,0)),-1,1,0)';
            --v_qry:= v_qry || ' where cod_abi_cartolarizzato = '''||p_cod_abi||'''';
            --v_qry:= v_qry || ' and   cod_ndg = '''||p_cod_ndg||'''';

            v_qry:= v_qry || ' update T_MCRE0_APP_ALERT_POS a ';
            v_qry:= v_qry || ' set alert_'||rec_alert.id_alert||' = '''||v_alert||''',';
            v_qry:= v_qry || '     cod_stato_'||rec_alert.id_alert||' = '''||v_cod_stato||''', ';
            V_QRY:= V_QRY || '     dta_upd_'||REC_ALERT.ID_ALERT||' = sysdate,';
            v_qry:= v_qry || '     dta_ins_'||REC_ALERT.ID_ALERT||' = nvl(dta_ins_'||REC_ALERT.ID_ALERT||',sysdate), ';
            v_qry:= v_qry || '     a.flg_worse_upd_'||rec_alert.id_alert||' = decode(sign(decode(alert_'||rec_alert.id_alert||',''V'',1,''A'',2,''R'',3,4)-decode('''||v_alert||''',''V'',1,''A'',2,''R'',3,0)),-1,1,0)';
            v_qry:= v_qry || ' where cod_abi_cartolarizzato = :cod_abi_cartolarizzato'; --||p_cod_abi||'''';
            v_qry:= v_qry || ' and   cod_ndg = :cod_ndg'; --||p_cod_ndg||'';

            execute immediate v_qry using p_cod_abi, p_cod_ndg;
          exception
            WHEN OTHERS THEN
              PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||REC_ALERT.ID_ALERT||' - UPDATE - QRY='||V_QRY,P_ID_UTENTE);
              return ko;
          END;
        end if;
      ELSE
        
        --RIMUOVERE IF
        NULL;

/*        V_QRY:= REPLACE(UPPER(REC_ALERT.VAL_PLSQL_COLORE),UPPER('DTA_INS_')||REC_ALERT.ID_ALERT,'sysdate');
        --V_QRY:= REPLACE(UPPER(V_QRY),UPPER('ALERT_')||REC_ALERT.ID_ALERT,'null');
        V_QRY:= REPLACE(UPPER(V_QRY),UPPER('when ALERT_')||REC_ALERT.ID_ALERT||UPPER(' is null then null'),' ');
        V_QRY:= REPLACE(V_QRY,'T_MCRE0_APP_ALERT_POS',rec_alert.val_table_name);
        v_qry:=  ' select  '||V_QRY;
        v_qry:= v_qry || ' from  '||rec_alert.val_list_table;
        if(rec_alert.VAL_PLSQL_JOIN is null)then
          v_qry:= v_qry || ' where 1=1';
        else
          v_qry:= v_qry || ' where '||rec_alert.VAL_PLSQL_JOIN;
        end if;
        if(rec_alert.tip_info='Settoriale')then
          v_qry:= v_qry || ' and '||rec_alert.val_table_name||'.COD_ABI_CARTOLARIZZATO = '''||p_cod_abi||'''';
          v_qry:= v_qry || ' and   '||rec_alert.val_table_name||'.COD_NDG = '''||p_cod_ndg||'''';
        else
          v_qry:= v_qry || ' and '||rec_alert.val_table_name||'.COD_SNDG = '''||p_cod_sndg||'''';
        end if;
        v_qry:= v_qry || ' and   '||rec_alert.val_plsql_where_a;

        begin
          if(instr(v_qry,':p_id_utente')>0)then
            execute immediate v_qry into v_alert using p_id_utente;
          else
            execute immediate v_qry into v_alert;
          end if;
        exception
          when no_data_found then
             v_alert:= null;
          WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||REC_ALERT.ID_ALERT||' - SELECT primo record - QRY='||V_QRY,P_ID_UTENTE);
            return ko;
        end;

        IF(V_ALERT IS NOT NULL) THEN
            begin
              v_qry:= null;
              v_qry:= v_qry || 'insert into T_MCRE0_APP_ALERT_POS ';
              v_qry:= v_qry || '( cod_abi_istituto, cod_abi_cartolarizzato, ';
              v_qry:= v_qry || '  cod_ndg, ';
              v_qry:= v_qry || '  cod_sndg, ';
              v_qry:= v_qry || '  alert_'||rec_alert.id_alert||', ';
              v_qry:= v_qry || '  cod_stato_'||rec_alert.id_alert||', ';
              v_qry:= v_qry || '  dta_ins_'||rec_alert.id_alert||', ';
              v_qry:= v_qry || '  flg_worse_upd_'||rec_alert.id_alert;
              v_qry:= v_qry || '  )values(';
              v_qry:= v_qry || ''''||v_abi_istituto||''',';
              v_qry:= v_qry || ''''||p_cod_abi||''',';
              v_qry:= v_qry || ''''||p_cod_ndg||''',';
              v_qry:= v_qry || ''''||p_cod_sndg||''',';
              v_qry:= v_qry || ''''||v_alert||''',';
              v_qry:= v_qry || ''''||v_cod_stato||''',';
              v_qry:= v_qry || '     sysdate,';
              v_qry:= v_qry || '    0 ';
              v_qry:= v_qry || '  )';
              execute immediate v_qry;
            exception
              WHEN OTHERS THEN
                PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||REC_ALERT.ID_ALERT||' - INSERT - QRY='||V_QRY,P_ID_UTENTE);
                return ko;
            end;
        end if;
*/
      end if;
      
      IF v_countupdate = 20 THEN
        commit;
        v_countupdate := 0;
      END IF ;
      v_countupdate := v_countupdate +1;
      
    end loop;
    
    commit;

    --commit;
    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - ABI='||p_cod_abi||' NDG='||p_cod_ndg,P_ID_UTENTE);
      return ko;
  END;


  -- Procedura per delete alert spenti
  -- INPUT :
  --    cod_abi
  --    cod_ndg
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   --no COMMIT
  FUNCTION fnc_verifica_alert_spenti(
    p_cod_abi   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    p_cod_sndg  T_MCRE0_APP_ALL_DATA.COD_SNDG%type,
    P_ID_UTENTE T_MCRE0_APP_UTENTI.ID_UTENTE%TYPE,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  )
  RETURN NUMBER IS
  --pragma autonomous_transaction;

    v_qry   varchar2(32000);
    v_where_1 varchar2(32000);
    v_where_2 varchar2(32000);
    v_exist number;
    V_SPENTO NUMBER(1);
    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    v_countupdate NUMBER;
    CURSOR C_ALERT IS
      select *
      FROM   T_MCRE0_APP_ALERT A
     -- where  a.flg_attivo = 'A'
      where id_alert = nvl(p_id_alert,id_alert)
      order by a.ID_ALERT;

  BEGIN

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    begin
      v_qry:= null;
      --v_qry:= v_qry || ' select 1 ';
      --v_qry:= v_qry || ' from   T_MCRE0_APP_ALERT_POS p ';
      --v_qry:= v_qry || ' where  p.cod_abi_cartolarizzato  = '''||p_cod_abi||'''';
      --v_qry:= v_qry || ' and    p.cod_ndg  = '''||p_cod_ndg||'''';
      
      v_qry:= v_qry || ' select 1 ';
      v_qry:= v_qry || ' from   T_MCRE0_APP_ALERT_POS p ';
      v_qry:= v_qry || ' where  p.cod_abi_cartolarizzato  = :cod_abi_cartolarizzato'; --||p_cod_abi||'''';
      v_qry:= v_qry || ' and    p.cod_ndg  = :cod_ndg'; --||p_cod_ndg||'''';
      
      execute immediate v_qry into v_exist using p_cod_abi, p_cod_ndg;
    exception
      when others then
        v_exist:=0;
    end;

    if(v_exist=1)then
      for rec_alert in c_alert loop
        V_SPENTO := 0;

        IF (NVL(REC_ALERT.FLG_ATTIVO,'S')='S')THEN
          V_SPENTO := 1;
        else

          V_QRY:= NULL;
          --v_qry:= v_qry || ' select distinct 1 ';
          --v_qry:= v_qry || ' from  '||rec_alert.val_list_table;
          --if(rec_alert.VAL_PLSQL_JOIN is null)then
          --  v_qry:= v_qry || ' where 1=1';
          --else
          --  v_qry:= v_qry || ' where '||rec_alert.VAL_PLSQL_JOIN;
          --end if;
          --if(rec_alert.tip_info='Settoriale')then
          --  v_qry:= v_qry || ' and '||rec_alert.val_table_name||'.COD_ABI_CARTOLARIZZATO = '''||p_cod_abi||'''';
          --  v_qry:= v_qry || ' and   '||rec_alert.val_table_name||'.COD_NDG = '''||p_cod_ndg||'''';
          --else
          --  v_qry:= v_qry || ' and '||rec_alert.val_table_name||'.COD_SNDG = '''||p_cod_sndg||'''';
          --end if;
          --v_qry:= v_qry || ' and   '||rec_alert.val_plsql_where_s;

          v_qry:= v_qry || ' select distinct 1 ';
          v_qry:= v_qry || ' from  '||rec_alert.val_list_table;
          if(rec_alert.VAL_PLSQL_JOIN is null)then
            v_qry:= v_qry || ' where 1=1';
          else
            v_qry:= v_qry || ' where '||rec_alert.VAL_PLSQL_JOIN;
          end if;
          if(rec_alert.tip_info='Settoriale')then
            v_where_1 := p_cod_abi;
            v_where_2 := p_cod_ndg;
            v_qry := v_qry || ' and '||rec_alert.val_table_name||'.COD_ABI_CARTOLARIZZATO = :where_1';
            v_qry := v_qry || ' and '||rec_alert.val_table_name||'.COD_NDG =:where_2';
            
          else
            v_where_1 := p_cod_sndg;
            v_where_2 := p_cod_sndg;
            v_qry := v_qry || ' and '||rec_alert.val_table_name||'.COD_SNDG = :where_1';
            v_qry := v_qry || ' and :where_2 is not null';
            
          end if;
          v_qry:= v_qry || ' and   '||rec_alert.val_plsql_where_s;

          begin
            if(instr(v_qry,':p_id_utente')>0)then
              execute immediate v_qry into v_spento using p_id_utente, v_where_1,v_where_2;
            else
              execute immediate v_qry into v_spento using v_where_1,v_where_2;
            end if;
          exception
            when no_data_found then
               v_spento:= 0;
            WHEN OTHERS THEN
              PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_SPENTI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||REC_ALERT.ID_ALERT||' - SELECT flg - QRY='||V_QRY,P_ID_UTENTE);
              return ko;
          end;

          if(v_spento = 0) then
            BEGIN
              v_qry:= null;
              V_QRY:= V_QRY || ' select 1 ';
              v_qry:= v_qry || ' from   V_MCRE0_APP_UPD_FIELDS_P1 x '; --v3.0
              v_qry:= v_qry || ' where  x.cod_abi_cartolarizzato  = :cod_abi_cartolarizzato'; --||p_cod_abi||'''';
              v_qry:= v_qry || ' and    x.cod_ndg  = :cod_ndg'; --||p_cod_ndg||'''';
              execute immediate v_qry into v_exist using p_cod_abi, p_cod_ndg;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_spento := 1;
              WHEN OTHERS THEN
                v_spento := 0;
            END;
          END IF;
        end if;

        if(v_spento = 1) then
          begin
            v_qry:= null;
            v_qry:= v_qry || ' update T_MCRE0_APP_ALERT_POS a ';
            v_qry:= v_qry || ' set alert_'||rec_alert.id_alert||' = null,';
            v_qry:= v_qry || '     cod_stato_'||rec_alert.id_alert||' = null, ';
            v_qry:= v_qry || '     dta_ins_'||rec_alert.id_alert||' = null, ';
            v_qry:= v_qry || '     dta_upd_'||rec_alert.id_alert||' = case when dta_ins_'||rec_alert.id_alert||' is NULL then NULL else sysdate end ,';
            v_qry:= v_qry || '     a.flg_worse_upd_'||rec_alert.id_alert||' = null ';
            v_qry:= v_qry || ' where cod_abi_cartolarizzato = :cod_abi_cartolarizzato'; --||p_cod_abi||'''';
            v_qry:= v_qry || ' and   cod_ndg = :cod_ndg'; --||p_cod_ndg||'''';
            execute immediate v_qry using p_cod_abi, p_cod_ndg;
          exception
            WHEN OTHERS THEN
              PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_SPENTI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||REC_ALERT.ID_ALERT||' - UPDATE - QRY='||V_QRY,P_ID_UTENTE);
              return ko;
          end;
        end if;
        
        IF v_countupdate = 20 THEN
          commit;
          v_countupdate := 0;
        END IF ;
        v_countupdate := v_countupdate +1;        
      end loop;
      
      COMMIT;
      
    end if;

    --commit;
    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_SPENTI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - ABI='||p_cod_abi||' NDG='||p_cod_ndg,P_ID_UTENTE);
      return ko;
  END;


  
  -- Procedura per insert/update alert accesi
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   --COMMIT
  FUNCTION FNC_VERIFICA_ALERT(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  )return number  is

     V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
     V_RESULT NUMBER:=0;
     V_RESULT_CLEAN number:=0;
     V_TOT_ALERT number;
     cursor C_ALERT is
       select ID_ALERT
       from T_MCRE0_APP_ALERT
       WHERE FLG_ATTIVO = 'A'
       order by id_alert;

  BEGIN

     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
     end if;

    FOR REC_ALERT IN C_ALERT LOOP
      V_RESULT:=V_RESULT+FNC_VERIFICA_ALERT_ID (v_cod_log,REC_ALERT.ID_ALERT);
    end LOOP;

    PKG_MCRE0_AUDIT.LOG_ETL(v_cod_log,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'Totale Alert OK='||V_RESULT);
    select COUNT(*)
    into V_TOT_ALERT
    from T_MCRE0_APP_ALERT
    where FLG_ATTIVO = 'A';

    V_RESULT_CLEAN := FNC_CLEAN_ALERT(v_cod_log);

    if(V_TOT_ALERT=V_RESULT) then
      return OK;
    else
      return KO;
    end if;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Errore generale');
      return ko;
  end;

  FUNCTION FNC_VERIFICA_ALERT_BLOCCO(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
    P_COD_BLOCCO T_MCRE0_APP_ALERT.COD_BLOCCO%TYPE
  )RETURN NUMBER  is

     V_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
     V_RESULT NUMBER:=0;
     V_RESULT_CLEAN number:=0;
     V_TOT_ALERT number;
     cursor C_ALERT is
       select ID_ALERT
       from T_MCRE0_APP_ALERT
       WHERE FLG_ATTIVO = 'A'
       AND   COD_BLOCCO = P_COD_BLOCCO  
       order by id_alert;

  BEGIN

     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
     end if;

    FOR REC_ALERT IN C_ALERT LOOP
      V_RESULT:=V_RESULT+FNC_VERIFICA_ALERT_ID (v_cod_log,REC_ALERT.ID_ALERT);
      PKG_MCRE0_AUDIT.LOG_ETL(v_cod_log,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_BLOCCO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,'Blocco '||P_COD_BLOCCO,'Calcolato Alert '||REC_ALERT.ID_ALERT);
    end LOOP;

    RETURN ok;
    
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Errore generale');
      return ko;
  end;

  -- Procedura per insert/update alert accesi
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   --COMMIT
  FUNCTION FNC_VERIFICA_ALERT_ID (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE default null,
    P_ID_ALERT T_MCRE0_APP_ALERT.ID_ALERT%TYPE DEFAULT NULL
  )RETURN NUMBER IS

    v_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
    v_id_utente T_MCRE0_APP_ALL_DATA.id_utente%type;
    v_result number;
    cursor C_POS is --v3.0
      select xx.COD_ABI_CARTOLARIZZATO, xx.COD_NDG, xx.COD_SNDG, xx.ID_UTENTE
      from   V_MCRE0_APP_UPD_FIELDS_P1 xx,
             MCRE_OWN.MV_MCRE0_APP_ISTITUTI I,
             T_MCRE0_APP_COMPARTI C,
             T_MCRE0_APP_STATI s
      where  xx.COD_COMPARTO = C.COD_COMPARTO
        and  xx.COD_STATO = S.cod_microstato
        and (C.FLG_CHK = '1'
             OR xx.DTA_LAST_RIPORTAF between trunc(sysdate)-30 and trunc(sysdate+1)
             )
        and  S.FLG_ALERT='1'             
      AND xx.cod_abi_cartolarizzato = i.cod_abi
      and  NVL (xx.flg_outsourcing, 'N') = 'Y'
      and I.FLG_TARGET = 'Y'
      order by xx.cod_abi_cartolarizzato, xx.cod_ndg;

      cursor c_pos_s is
        select p.COD_ABI_CARTOLARIZZATO, p.cod_ndg, p.cod_sndg, id_utente
        from   V_MCRE0_APP_ALERT_POS p;

  BEGIN
     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
     end if;

    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'Verifica ID_ALERT='||P_ID_ALERT);

    FOR REC_POS IN C_POS LOOP
      v_result := fnc_verifica_alert_accesi(rec_pos.cod_abi_cartolarizzato, rec_pos.cod_ndg, rec_pos.cod_sndg, rec_pos.id_utente,V_COD_LOG,P_ID_ALERT);
      IF(V_RESULT=KO)THEN
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'fnc_verifica_alert_accesi - cod_abi_cartolarizzato='||REC_POS.COD_ABI_CARTOLARIZZATO||' cod_ndg='||REC_POS.COD_NDG||' ID_ALERT='||P_ID_ALERT);
        return ko;
      END IF;
    end LOOP;

    for rec_pos_s in c_pos_s loop

      v_result := fnc_verifica_alert_spenti(rec_pos_s.cod_abi_cartolarizzato, rec_pos_s.cod_ndg, rec_pos_s.cod_sndg, rec_pos_s.id_utente,V_COD_LOG,P_ID_ALERT);
      IF(V_RESULT=KO)THEN
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'fnc_verifica_alert_spenti - cod_abi_cartolarizzato='||REC_POS_s.COD_ABI_CARTOLARIZZATO||' cod_ndg='||REC_POS_s.COD_NDG||' ID_ALERT='||P_ID_ALERT);
       return ko;
      END IF;
    end loop;

    commit;
    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - ID_ALERT='||P_ID_ALERT);
      rollback;
      return ko;
  END;

  
  
  -- Procedura per insert/update alert accesi
  -- INPUT :
  --    p_cod_abi
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   --COMMIT
  FUNCTION FNC_VERIFICA_ALERT_ABI(
    P_COD_ABI   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%TYPE,
    p_id_utente T_MCRE0_APP_UTENTI.ID_UTENTE%type,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE DEFAULT NULL,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  )
  RETURN NUMBER IS

    v_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    v_result_a number;
    v_result_s number;
    cursor C_POS is --v3.0
      select xx.COD_ABI_CARTOLARIZZATO, xx.COD_NDG, xx.COD_SNDG, xx.ID_UTENTE
      from   V_MCRE0_APP_UPD_FIELDS_P1 xx,
             MCRE_OWN.MV_MCRE0_APP_ISTITUTI I,
             T_MCRE0_APP_COMPARTI C,
             T_MCRE0_APP_STATI s
      where  xx.COD_COMPARTO = C.COD_COMPARTO
        and  xx.COD_STATO = S.cod_microstato
        and (C.FLG_CHK = '1'
             OR xx.DTA_LAST_RIPORTAF between trunc(sysdate)-30 and trunc(sysdate+1)
             )
        and  S.FLG_ALERT='1'             
      AND xx.cod_abi_cartolarizzato = i.cod_abi
      and  NVL (xx.flg_outsourcing, 'N') = 'Y'
      and I.FLG_TARGET = 'Y'
      and xx.cod_abi_cartolarizzato = p_cod_abi
      order by xx.cod_abi_cartolarizzato, xx.cod_ndg;

/*      select xx.COD_ABI_CARTOLARIZZATO, xx.COD_NDG, xx.COD_SNDG, xx.ID_UTENTE
      from   MV_MCRE0_APP_UPD_FIELD xx,
             mcre_own.mv_mcre0_app_istituti i
      where  (  xx.COD_COMPARTO in (
                      SELECT C.COD_COMPARTO FROM T_MCRE0_APP_COMPARTI C WHERE C.FLG_CHK = 1)
             OR
                (TRUNC(sysdate) - xx.DTA_LAST_RIPORTAF) <= 30
             )
      and   xx.COD_STATO in (
               select cod_microstato
               from   T_MCRE0_APP_STATI s
               where  S.FLG_ALERT=1
             )
      AND xx.cod_abi_cartolarizzato = i.cod_abi(+)
      and  NVL (xx.flg_outsourcing, 'N') = 'Y'
      and I.FLG_TARGET = 'Y'
      and xx.cod_abi_cartolarizzato = p_cod_abi
      order by XX.COD_ABI_CARTOLARIZZATO, XX.COD_NDG;*/
    /*  select a.cod_abi_cartolarizzato, a.cod_ndg, a.cod_sndg
      from   T_MCRE0_APP_MOPLE a,
             T_MCRE0_APP_FILE_GUIDA g
      where a.COD_ABI_CARTOLARIZZATO = g.COD_ABI_CARTOLARIZZATO
      and   a.COD_NDG = g.COD_NDG
      and   ( nvl(g.COD_COMPARTO_ASSEGNATO,g.COD_COMPARTO_CALCOLATO) in (
              select c.COD_COMPARTO from T_MCRE0_app_COMPARTI c where c.flg_chk = 1
              )OR g.COD_COMPARTO_CALCOLATO_PRE in (
              select c.COD_COMPARTO from T_MCRE0_app_COMPARTI c where c.flg_chk = 1
              )
            )
      and   a.COD_STATO in (
               select cod_microstato
               from   T_MCRE0_APP_STATI s
               where  s.flg_alert=1
             )
      and   a.cod_abi_cartolarizzato = p_cod_abi
      and a.ID_DPER = (
                select idper
                from   V_MCRE0_ULTIMA_ACQUISIZIONE
                where  COD_FILE ='MOPLE')
      order by a.cod_abi_cartolarizzato, a.cod_ndg ; */

      cursor c_pos_s is
        select p.COD_ABI_CARTOLARIZZATO, p.cod_ndg, p.cod_sndg, id_utente
        from   V_MCRE0_APP_ALERT_POS p
        where cod_abi_cartolarizzato = p_cod_abi;

  BEGIN

    IF( P_COD_LOG IS NULL) THEN
      SELECT SEQ_MCR0_LOG_APP.NEXTVAL
      INTO V_COD_LOG
      FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    FOR REC_POS IN C_POS LOOP
      v_result_a := fnc_verifica_alert_accesi(rec_pos.cod_abi_cartolarizzato, rec_pos.cod_ndg, rec_pos.cod_sndg, p_id_utente,V_COD_LOG,p_id_alert);
      if(v_result_a=ko)then
        return ko;
      end if;
    end loop;

    FOR REC_POS_S IN C_POS_S LOOP
      v_result_s := fnc_verifica_alert_spenti(rec_pos_s.cod_abi_cartolarizzato, rec_pos_s.cod_ndg, rec_pos_s.cod_sndg, p_id_utente,V_COD_LOG,p_id_alert);
      if(v_result_s=ko)then
        return ko;
      end if;
    end loop;

    commit;
    return ok;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_ABI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - ABI_CARTOLARIZZATO='||p_cod_abi,P_ID_UTENTE);
      rollback;
      return ko;
  END;

  -- Procedura per insert/update alert accesi
  -- INPUT :
  --    cod_abi
  --    cod_ndg
  --    cod_sndg
  --    id_utente
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   -- NO COMMIT
  FUNCTION FNC_VERIFICA_ALERT_NDG(
    p_cod_abi   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    p_cod_sndg  T_MCRE0_APP_ALL_DATA.COD_SNDG%type,
    P_ID_UTENTE T_MCRE0_APP_UTENTI.ID_UTENTE%TYPE,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  )
  RETURN NUMBER IS

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

    V_RESULT_A := FNC_VERIFICA_ALERT_ACCESI(P_COD_ABI, P_COD_NDG, P_COD_SNDG, P_ID_UTENTE,V_COD_LOG,P_ID_ALERT);
    v_result_s := fnc_verifica_alert_spenti(p_cod_abi, p_cod_ndg, p_cod_sndg, p_id_utente,V_COD_LOG,p_id_alert);
    if(v_result_a=ko OR v_result_s=ko)then
      return ko;
    end if;

    return ok;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_NDG',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - ABI='||p_cod_abi||' NDG='||p_cod_ndg,P_ID_UTENTE);
      return ko;
  END;

  -- Procedura per insert/update alert accesi
  -- INPUT :
  --    p_cod_sndg
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   --NO COMMIT
  FUNCTION FNC_VERIFICA_ALERT_SNDG(
    P_COD_SNDG  T_MCRE0_APP_ALL_DATA.COD_SNDG%TYPE,
    p_id_utente T_MCRE0_APP_UTENTI.ID_UTENTE%type,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE DEFAULT NULL,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  )
  RETURN NUMBER IS

    v_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    v_result_a number;
    v_result_s number;
    cursor C_POS is --v3.0
      select xx.COD_ABI_CARTOLARIZZATO, xx.COD_NDG, xx.COD_SNDG, xx.ID_UTENTE
      from   V_MCRE0_APP_UPD_FIELDS_P1 xx,
             MCRE_OWN.MV_MCRE0_APP_ISTITUTI I,
             T_MCRE0_APP_COMPARTI C,
             T_MCRE0_APP_STATI s
      where  xx.COD_COMPARTO = C.COD_COMPARTO
        and  xx.COD_STATO = S.cod_microstato
        and (C.FLG_CHK = '1'
             OR xx.DTA_LAST_RIPORTAF between trunc(sysdate)-30 and trunc(sysdate+1)
             )
        and  S.FLG_ALERT='1'             
      AND xx.cod_abi_cartolarizzato = i.cod_abi
      and  NVL (xx.flg_outsourcing, 'N') = 'Y'
      and I.FLG_TARGET = 'Y'
      and xx.COD_SNDG = P_COD_SNDG
      order by xx.cod_abi_cartolarizzato, xx.cod_ndg;

/*      select xx.COD_ABI_CARTOLARIZZATO, xx.COD_NDG, xx.COD_SNDG, xx.ID_UTENTE
      from   MV_MCRE0_APP_UPD_FIELD xx,
             mcre_own.mv_mcre0_app_istituti i
      where  (  xx.COD_COMPARTO in (
                      SELECT C.COD_COMPARTO FROM T_MCRE0_APP_COMPARTI C WHERE C.FLG_CHK = 1)
             OR
                (TRUNC(sysdate) - xx.DTA_LAST_RIPORTAF) <= 30
             )
      and   xx.COD_STATO in (
               select cod_microstato
               from   T_MCRE0_APP_STATI s
               where  S.FLG_ALERT=1
             )
      AND xx.cod_abi_cartolarizzato = i.cod_abi(+)
      and  NVL (xx.flg_outsourcing, 'N') = 'Y'
      and I.FLG_TARGET = 'Y'
      and xx.COD_SNDG = P_COD_SNDG
      order by XX.COD_ABI_CARTOLARIZZATO, XX.COD_NDG;*/
    /*  select a.cod_abi_cartolarizzato, a.cod_ndg, a.cod_sndg
      from   T_MCRE0_APP_MOPLE a,
             T_MCRE0_APP_FILE_GUIDA G,
             mcre_own.mv_mcre0_app_istituti i
      where a.COD_ABI_CARTOLARIZZATO = g.COD_ABI_CARTOLARIZZATO
      and   a.COD_NDG = g.COD_NDG
      and   ( nvl(g.COD_COMPARTO_ASSEGNATO,g.COD_COMPARTO_CALCOLATO) in (
              select c.COD_COMPARTO from T_MCRE0_app_COMPARTI c where c.flg_chk = 1
              )OR g.COD_COMPARTO_CALCOLATO_PRE in (
              select c.COD_COMPARTO from T_MCRE0_app_COMPARTI c where c.flg_chk = 1
              )
            )
      and   a.COD_STATO in (
               select cod_microstato
               from   T_MCRE0_APP_STATI s
               where  s.flg_alert=1
             )
      and   a.COD_SNDG = P_COD_SNDG
      AND g.cod_abi_cartolarizzato = i.cod_abi(+)
      and  NVL (a.FLG_OUTSOURCING, 'N') = 'Y'
      AND i.flg_target = 'Y'
      and   a.ID_DPER = (
                select idper
                from   V_MCRE0_ULTIMA_ACQUISIZIONE
                where  COD_FILE ='MOPLE')
      order by a.cod_abi_cartolarizzato, a.cod_ndg;  */

      cursor c_pos_s is
        select p.COD_ABI_CARTOLARIZZATO, p.cod_ndg, p.cod_sndg, id_utente
        from   V_MCRE0_APP_ALERT_POS p
        where cod_sndg = p_cod_sndg;

  BEGIN

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    FOR REC_POS IN C_POS LOOP
      v_result_a := fnc_verifica_alert_accesi(rec_pos.cod_abi_cartolarizzato, rec_pos.cod_ndg, rec_pos.cod_sndg, p_id_utente,V_COD_LOG,p_id_alert);
      IF(V_RESULT_A=KO)THEN
        PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_SNDG',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'fnc_verifica_alert_accesi - cod_abi_cartolarizzato='||REC_POS.COD_ABI_CARTOLARIZZATO||' cod_ndg='||REC_POS.COD_NDG,P_ID_UTENTE);
        return ko;
      end if;
    end loop;

    FOR REC_POS_S IN C_POS_S LOOP
      v_result_s := fnc_verifica_alert_spenti(rec_pos_s.cod_abi_cartolarizzato, rec_pos_s.cod_ndg, rec_pos_s.cod_sndg, p_id_utente,V_COD_LOG,p_id_alert);
      IF(V_RESULT_S=KO)THEN
        PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_SNDG',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'fnc_verifica_alert_spenti - cod_abi_cartolarizzato='||REC_POS_s.COD_ABI_CARTOLARIZZATO||' cod_ndg='||REC_POS_s.COD_NDG,P_ID_UTENTE);
        return ko;
      end if;
    end loop;

    return ok;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_VERIFICA_ALERT_SNDG',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE -SNDG='||p_cod_sndg,P_ID_UTENTE);
      return ko;
  END;

  -- Procedura per pulizia posizioni con tutti gli alert spenti
  -- INPUT :
  --
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   --COMMIT
  FUNCTION FNC_CLEAN_ALERT(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE default null
  )RETURN NUMBER IS

    v_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
     v_qry   varchar2(3000);
     cursor c_alert is
      select a.ID_ALERT
      from   T_MCRE0_APP_ALERT a
      where  a.flg_attivo = 'A'
      order by a.ID_ALERT;

  BEGIN

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
     end if;

    v_qry := v_qry || ' DELETE FROM T_MCRE0_APP_ALERT_POS ';
    v_qry := v_qry || ' WHERE  1=1 ';
    for rec_alert in c_alert loop
      v_qry := v_qry || ' AND ALERT_'||rec_alert.id_alert||' is null';
    end loop;

    begin
      execute immediate v_qry;
      commit;
    exception
      WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_CLEAN_ALERT',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - DELETE - QRY='||v_qry);
        return ko;
    end;

    return ok;

  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_CLEAN_ALERT',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE ');
      return ko;
  END;
  
--  FUNCTION FNC_CLEAN_ALERT_BLOCCO(
--    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
--    P_COD_BLOCCO T_MCRE0_APP_ALERT.COD_BLOCCO%TYPE
--  )RETURN NUMBER IS

--    v_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
--     v_qry   varchar2(3000);
--     cursor c_alert is
--      select a.ID_ALERT
--      from   T_MCRE0_APP_ALERT a
--      where  a.flg_attivo = 'A'
--      and    A.COD_BLOCCO = p_cod_blocco
--      order by a.ID_ALERT;

--  BEGIN

--    IF( P_COD_LOG IS NULL) THEN
--        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
--        INTO V_COD_LOG
--        FROM DUAL;
--    ELSE
--      V_COD_LOG := P_COD_LOG;
--     end if;

--    v_qry := v_qry || ' DELETE FROM T_MCRE0_APP_ALERT_POS ';
--    v_qry := v_qry || ' WHERE  1=1 ';
--    for rec_alert in c_alert loop
--      v_qry := v_qry || ' AND ALERT_'||rec_alert.id_alert||' is null';
--    end loop;

--    begin
--      execute immediate v_qry;
--      commit;
--    exception
--      WHEN OTHERS THEN
--        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_CLEAN_ALERT',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE [Blocco '||p_cod_blocco||'- DELETE - QRY='||v_qry);
--        return ko;
--    end;

--    return ok;

--  EXCEPTION
--    WHEN OTHERS THEN
--      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT.FNC_CLEAN_ALERT',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE ');
--      return ko;
--  END;

END PKG_MCRE0_ALERT_2;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ALERT_2 FOR MCRE_OWN.PKG_MCRE0_ALERT_2;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ALERT_2 FOR MCRE_OWN.PKG_MCRE0_ALERT_2;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ALERT_2 TO MCRE_USR;

