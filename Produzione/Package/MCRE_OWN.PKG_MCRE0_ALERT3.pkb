CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_ALERT3" AS
/******************************************************************************
   NAME:     PKG_MCRE0_ALERT3
   PURPOSE: Gestione alert ed evidenze */
   
 -- load della working table T_MCRE0_APP_ALERT_POS_WRK a partire da T_MCRE0_APP_ALERT_POS
 FUNCTION FNC_TO_WORKING_TABLE 
  RETURN NUMBER IS
  V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
   --alert di lavoro
   cursor C_ALERT is
       select ID_ALERT,'P_'||lpad(id_alert,2,'0') part
       from T_MCRE0_APP_ALERT
       WHERE FLG_ATTIVO = 'A'
       order by id_alert; 
   begin
            
      SELECT SEQ_MCR0_LOG_APP.NEXTVAL
      INTO V_COD_LOG
      FROM DUAL; 
      dbms_output.enable(1000000);
      
      --  load delle posizioni di T_MCRE0_APP_ALERT_POS nella tabella di lavoro T_MCRE0_APP_ALERT_POS_WRK
      for v in c_alert loop
      
          begin      
        execute immediate 'alter table T_MCRE0_APP_ALERT_POS_WRK truncate partition '||v.part||' reuse storage';
        execute immediate 'begin insert into T_MCRE0_APP_ALERT_POS_WRK partition ('||v.part||') '||
        '  select '||v.ID_ALERT||' as ID_ALERT, COD_ABI_CARTOLARIZZATO, COD_NDG , COD_SNDG ,COD_ABI_ISTITUTO,'||
        '  ALERT_'||v.ID_ALERT||' ,'||
        '  COD_STATO_'||v.ID_ALERT||' ,'||
        '  DTA_INS_'||v.ID_ALERT||' ,'||
        '  DTA_UPD_'||v.ID_ALERT||' ,'||
        '  FLG_WORSE_UPD_'||v.ID_ALERT ||
        '  from T_MCRE0_APP_ALERT_POS; commit; end;';  
        
        EXCEPTION
                WHEN OTHERS
                THEN
                  --log_caricamenti ('fnc_to_working_table', SQLCODE,  SQLERRM);                                      
                PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_TO_WORKING_TABLE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'panel check attivi',null);
                return ko;
                end;
                
        begin
        --panel check  attivi
        execute immediate 'alter table T_MCRE0_APP_ALERT_POS_A truncate partition '||v.part||' reuse storage';         
        execute immediate 'begin insert into T_MCRE0_APP_ALERT_POS_A partition ('||v.part||') '||
        'select '||v.ID_ALERT||' as ID_ALERT,xx.COD_ABI_CARTOLARIZZATO, xx.COD_NDG, xx.COD_SNDG, xx.ID_UTENTE '||
        'from   V_MCRE0_APP_UPD_FIELDS_P1 xx, '||
        'MCRE_OWN.MV_MCRE0_APP_ISTITUTI I, '||
        'T_MCRE0_APP_COMPARTI C, '||
        'T_MCRE0_APP_STATI s '||
        'where  xx.COD_COMPARTO = C.COD_COMPARTO '||
        'and  xx.COD_STATO = S.cod_microstato '||
        'and (C.FLG_CHK = ''1'' OR xx.DTA_LAST_RIPORTAF between trunc(sysdate)-30 and trunc(sysdate+1)) '||
        'and  S.FLG_ALERT=''1'' '||
        'AND xx.cod_abi_cartolarizzato = i.cod_abi '||
        'and  NVL (xx.flg_outsourcing, ''N'') = ''Y'' '||
        'and I.FLG_TARGET = ''Y'' ; commit; end;';   
        EXCEPTION
                WHEN OTHERS
                THEN
                  --log_caricamenti ('fnc_to_working_table', SQLCODE,  SQLERRM);                                      
                PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_TO_WORKING_TABLE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'panel check attivi',null);
                return ko;
                end;
                        
        begin
        --panel check spenti
        execute immediate 'alter table T_MCRE0_APP_ALERT_POS_S truncate partition '||v.part||' reuse storage';
        execute immediate 'begin insert into T_MCRE0_APP_ALERT_POS_S partition ('||v.part||') '||
        'select  '||v.ID_ALERT||' as ID_ALERT,p.COD_ABI_CARTOLARIZZATO, p.cod_ndg, p.cod_sndg, id_utente '||
        'from   V_MCRE0_APP_ALERT_POS p; commit; end;';    
                EXCEPTION
                WHEN OTHERS
                THEN
                  --log_caricamenti ('fnc_to_working_table', SQLCODE,  SQLERRM);                                      
                PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_TO_WORKING_TABLE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'panel check spenti',null);
                return ko;
                end; 
    end loop;  
     
      begin
          DBMS_SNAPSHOT.REFRESH(
        LIST                 => 'MCRE_OWN.MV_MCRE0_APP_SCHEDA_ANAG_SC_PC'
       ,METHOD               => 'C'
       ,PUSH_DEFERRED_RPC    => FALSE
       ,REFRESH_AFTER_ERRORS => FALSE
       ,PURGE_OPTION         => 1
       ,PARALLELISM          => 0
       ,ATOMIC_REFRESH       => FALSE
       ,NESTED               => FALSE);
   
        EXCEPTION
        WHEN OTHERS
        THEN
        --log_caricamenti ('fnc_to_working_table', SQLCODE,  SQLERRM);                                      
        PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_TO_WORKING_TABLE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'err MV_MCRE0_APP_SCHEDA_ANAG_SC_PC',null);
        return ko;
        end;
    return ok;
    -- redundant
    EXCEPTION
     WHEN OTHERS
     THEN
        --log_caricamenti ('fnc_to_working_table', SQLCODE,  SQLERRM);                                      
    PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_TO_WORKING_TABLE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'LOAD partition',null);
                                 
    return ko;
    end;     
-- load di T_MCRE0_APP_ALERT_POS a partire dalla working table T_MCRE0_APP_ALERT_POS_WRK
 FUNCTION fnc_from_working_table 
  RETURN NUMBER IS
      V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
   cursor C_ALERT is
       select COD_ABI_CARTOLARIZZATO, COD_NDG,s_alert,COD_SNDG,COD_ABI_ISTITUTO,
                'insert into T_MCRE0_APP_ALERT_POS (COD_ABI_CARTOLARIZZATO,COD_NDG,COD_SNDG,COD_ABI_ISTITUTO,'||
                replace(s_cols,'#',',')||
                ') values (:p1,:p2,:p3,:p4,'||
                replace(s_vals,'#',',')||')' s_sql
        from
        (
        SELECT COD_ABI_CARTOLARIZZATO, COD_NDG,COD_SNDG,COD_ABI_ISTITUTO,
               sum(s_alert)  AS s_alert,
               LTRIM(MAX(SYS_CONNECT_BY_PATH(s_cols, '#'))   KEEP (DENSE_RANK LAST ORDER BY curr),'#') AS s_cols,
               LTRIM(MAX(SYS_CONNECT_BY_PATH(s_vals, '#'))   KEEP (DENSE_RANK LAST ORDER BY curr),'#') AS s_vals
        FROM   
        (
               select 
               COD_ABI_CARTOLARIZZATO,COD_NDG,COD_SNDG,COD_ABI_ISTITUTO, 
               ALERT s_alert, curr, prev,
               f_alert||','||f_cod_stato||','||f_dta_ins||','||f_dta_upd||','||f_flg_worse_upd s_cols,
               replace(v_alert||','||v_cod_stato||','||v_dta_ins||','||v_dta_upd||','||v_flg_worse_upd,'''NULL''','NULL') s_vals
               from
               (
                select COD_ABI_CARTOLARIZZATO,COD_NDG,COD_SNDG,COD_ABI_ISTITUTO,ID_ALERT,
                case when alert is null then 0 else 1 end  ALERT,
                'ALERT_'||ID_ALERT f_alert,  ''''||nvl(ALERT,'NULL')||'''' v_ALERT,
                COD_STATO,'COD_STATO_'||ID_ALERT f_cod_stato,''''||nvl(COD_STATO,'NULL')||'''' v_COD_STATO,
                DTA_INS,'DTA_INS_'||ID_ALERT f_dta_ins,case when DTA_INS is not null then 'to_date('''||to_char(DTA_INS,'YYYYMMDD HH24:MI:SS')||''',''YYYYMMDD HH24:MI:SS'')' else '''NULL''' end v_DTA_INS,
                DTA_UPD,'DTA_UPD_'||ID_ALERT f_dta_upd,case when DTA_UPD is not null then 'to_date('''||to_char(DTA_UPD,'YYYYMMDD HH24:MI:SS')||''',''YYYYMMDD HH24:MI:SS'')' else '''NULL''' end v_DTA_UPD,
                'FLG_WORSE_UPD_'||ID_ALERT f_flg_worse_upd,case when FLG_WORSE_UPD is not null then ''''||FLG_WORSE_UPD||'''' else '''NULL''' end v_FLG_WORSE_UPD,
                ROW_NUMBER() OVER (PARTITION BY COD_ABI_CARTOLARIZZATO, COD_NDG,COD_SNDG ORDER BY ID_ALERT) AS curr,
                ROW_NUMBER() OVER (PARTITION BY COD_ABI_CARTOLARIZZATO, COD_NDG,COD_SNDG ORDER BY ID_ALERT) -1 AS prev 
                from mcre_own.T_MCRE0_APP_ALERT_POS_WRK   
                order by COD_ABI_CARTOLARIZZATO,COD_NDG,ID_ALERT
                )  
        )         
        GROUP BY COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG,COD_ABI_ISTITUTO
        CONNECT BY prev = PRIOR curr AND COD_ABI_CARTOLARIZZATO = PRIOR COD_ABI_CARTOLARIZZATO AND COD_NDG = PRIOR COD_NDG --AND COD_SNDG = PRIOR COD_SNDG
        START WITH curr = 1 
        )        
        where s_alert !=0;--escludo il caso in cui tutti i campi alert sono null
        
    begin
        
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL; 
    --dbms_output.enable(1000000);
        
    execute immediate 'truncate table T_MCRE0_APP_ALERT_POS reuse storage';
    for v in c_alert loop
           --dbms_output.put_line('part '||v.part);
        execute immediate  v.s_sql USING v.cod_abi_cartolarizzato,v.cod_ndg, v.cod_sndg, v.cod_abi_istituto;        
    end loop;  
    commit;         
    return ok;
    EXCEPTION
         WHEN OTHERS
         THEN
            --log_caricamenti ('fnc_from_working_table', SQLCODE,  SQLERRM);                                      
            PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_FROM_WORKING_TABLE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'LOAD T_MCRE0_APP_ALERT_POS',null);
         return ko;                                 
    end;                
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
    p_alert T_MCRE0_APP_ALERT.id_alert%type  --default null
  )
  RETURN NUMBER IS
  --pragma autonomous_transaction;
    v_where_1 varchar2(32000);
    v_where_2 varchar2(32000);
    v_qry   varchar2(3000);
    v_exist number;
    v_alert T_MCRE0_APP_ALERT_POS.ALERT_1%TYPE;
    v_dta_ins date; --varchar2(10);
    v_abi_istituto T_MCRE0_APP_ALL_DATA.cod_abi_istituto%type;
    V_COD_STATO T_MCRE0_APP_STATI.COD_MACROSTATO%TYPE;
    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    cursor c_alert is 
     SELECT  id_alert,
             replace(replace(REPLACE (val_plsql_colore, '_' || id_alert, ''),'T_MCRE0_APP_ALERT_POS','T_MCRE0_APP_ALERT_POS_WRK'),'V_MCRE0_APP_SCHEDA_ANAG_SC_PC','MV_MCRE0_APP_SCHEDA_ANAG_SC_PC') val_plsql_colore,
             val_list_table, val_table_name, val_plsql_join, 
             val_plsql_where_a,val_plsql_where_s,
             tip_info,FLG_ATTIVO
        FROM t_mcre0_app_alert a
       WHERE  a.flg_attivo = 'A' and
             --and id_alert = nvl(p_alert,id_alert)
             id_alert = p_alert
    ORDER BY a.id_alert;
  BEGIN
    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_APP.NEXTVAL
        INTO V_COD_LOG
        FROM DUAL;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;
    begin
      select nvl(s.COD_MACROSTATO,s.COD_MICROSTATO) cod_stato, m.COD_ABI_ISTITUTO
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
        PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'SELECT macrostato - ABI='||p_cod_abi||' NDG='||p_cod_ndg,P_ID_UTENTE);
        return ko;
    end;
    for rec_alert in c_alert loop
      v_alert := null;
      v_exist := 0;
      v_dta_ins:=NULL;
      begin
        v_alert := null;
        V_QRY:= NULL;
       -- v_qry:= v_qry || ' select 1,'||rec_alert.VAL_PLSQL_COLORE;
       -- v_qry:= v_qry || ' from   T_MCRE0_APP_ALERT_POS';
       -- v_qry:= v_qry || ' where cod_abi_cartolarizzato = '''||p_cod_abi||'''';
       --V_QRY:= V_QRY || ' and   cod_ndg = '''||P_COD_NDG||'''';
       --execute immediate V_QRY into v_exist;
        v_qry:= v_qry || ' select distinct 1,'||rec_alert.VAL_PLSQL_COLORE;
        v_qry:= v_qry || ' from T_MCRE0_APP_ALERT_POS_WRK';
        v_qry:= v_qry || ' where cod_abi_cartolarizzato = :cod_abi_cartolarizzato';
        V_QRY:= V_QRY || ' and   cod_ndg = :cod_ndg';
        v_qry:= v_qry || ' and   id_alert =:p_alert';-- partiz
        execute immediate V_QRY into v_exist, V_ALERT  using p_cod_abi, p_cod_ndg,p_alert;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_EXIST:=0;
          V_ALERT:=null;
        WHEN OTHERS THEN
          PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||rec_alert.id_alert||' - SELECT colore - QRY='||v_qry,P_ID_UTENTE);
          return ko;
      end;
     IF(V_EXIST=1) THEN
        if(V_ALERT is null) then
          --V_QRY:= REPLACE(UPPER(REC_ALERT.VAL_PLSQL_COLORE),UPPER('DTA_INS_')||REC_ALERT.ID_ALERT,'sysdate');
          --V_QRY:= REPLACE(UPPER(V_QRY),UPPER('when ALERT_')||REC_ALERT.ID_ALERT||UPPER(' is null then null'),' ');
          --V_QRY:= REPLACE(V_QRY,'T_MCRE0_APP_ALERT_POS',rec_alert.val_table_name);
          V_QRY:= REPLACE(UPPER(REC_ALERT.VAL_PLSQL_COLORE),UPPER('DTA_INS'),'sysdate');
          V_QRY:= REPLACE(UPPER(V_QRY),UPPER('when ALERT')||UPPER(' is null then null'),' ');
          V_QRY:= REPLACE(V_QRY,'T_MCRE0_APP_ALERT_POS_WRK',rec_alert.val_table_name);
          V_QRY:= REPLACE(V_QRY,rec_alert.val_table_name||'.SYSDATE','sysdate');
          v_qry:=  ' select  '||V_QRY;
          v_qry:= v_qry || ' from  '||rec_alert.val_list_table;
          --todo inserire partiz
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
              PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||REC_ALERT.ID_ALERT||' - SELECT colore record - QRY='||V_QRY,P_ID_UTENTE);
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
            v_qry:= v_qry || ' update T_MCRE0_APP_ALERT_POS_WRK a ';
            v_qry:= v_qry || ' set alert = :p_alert,';
            v_qry:= v_qry || '     cod_stato = :p_cod_stato, ';
            V_QRY:= V_QRY || '     dta_upd = :p_dta_upd,';
            v_qry:= v_qry || '     dta_ins = nvl(dta_ins,:p_dta_ins), ';
            v_qry:= v_qry || '     a.flg_worse_upd = decode(sign(decode(alert,''V'',1,''A'',2,''R'',3,4)-decode(:p_alert,''V'',1,''A'',2,''R'',3,0)),-1,1,0)';
            v_qry:= v_qry || ' where cod_abi_cartolarizzato = :p_cod_abi';
            v_qry:= v_qry || ' and   cod_ndg =:p_cod_ndg';
            v_qry:= v_qry || ' and   id_alert =:p_alert';-- partiz
            execute immediate v_qry using v_alert,v_cod_stato,sysdate,sysdate,v_alert,p_cod_abi,p_cod_ndg,REC_ALERT.ID_ALERT;
          exception
            WHEN OTHERS THEN
              PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||REC_ALERT.ID_ALERT||' - UPDATE - QRY='||V_QRY,P_ID_UTENTE);
              return ko;
          END;
        end if;
      ELSE 
        V_QRY:= REPLACE(UPPER(REC_ALERT.VAL_PLSQL_COLORE),UPPER('DTA_INS'),'sysdate');
        --V_QRY:= REPLACE(UPPER(V_QRY),UPPER('ALERT_')||REC_ALERT.ID_ALERT,'null');
        V_QRY:= REPLACE(UPPER(V_QRY),UPPER('when ALERT')||UPPER(' is null then null'),' ');
        V_QRY:= REPLACE(V_QRY,'T_MCRE0_APP_ALERT_POS_WRK',rec_alert.val_table_name);
        V_QRY:= REPLACE(V_QRY,rec_alert.val_table_name||'.SYSDATE','sysdate');
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
          --todo inserire partiz
        v_qry:= v_qry || ' and   '||rec_alert.val_plsql_where_a;
        begin
          if(instr(v_qry,':p_id_utente')>0)then
            execute immediate v_qry into v_alert using p_id_utente,v_where_1,v_where_2;
          else
            execute immediate v_qry into v_alert using v_where_1,v_where_2;
          end if;
        exception
          when no_data_found then
             v_alert:= null;
          WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||REC_ALERT.ID_ALERT||' - SELECT primo record - QRY='||V_QRY,P_ID_UTENTE);
            return ko;
        end;
        IF(V_ALERT IS NOT NULL) THEN
            begin
              v_qry:= null;
--              v_qry:= v_qry || 'insert into T_MCRE0_APP_ALERT_POS ';
--              v_qry:= v_qry || '( cod_abi_istituto, cod_abi_cartolarizzato, ';
--              v_qry:= v_qry || '  cod_ndg, ';
--              v_qry:= v_qry || '  cod_sndg, ';
--              v_qry:= v_qry || '  alert_'||rec_alert.id_alert||', ';
--              v_qry:= v_qry || '  cod_stato_'||rec_alert.id_alert||', ';
--              v_qry:= v_qry || '  dta_ins_'||rec_alert.id_alert||', ';
--              v_qry:= v_qry || '  flg_worse_upd_'||rec_alert.id_alert;
--              v_qry:= v_qry || '  )values(';
--              v_qry:= v_qry || ''''||v_abi_istituto||''',';
--              v_qry:= v_qry || ''''||p_cod_abi||''',';
--              v_qry:= v_qry || ''''||p_cod_ndg||''',';
--              v_qry:= v_qry || ''''||p_cod_sndg||''',';
--              v_qry:= v_qry || ''''||v_alert||''',';
--              v_qry:= v_qry || ''''||v_cod_stato||''',';
--              v_qry:= v_qry || '     sysdate,';
--              v_qry:= v_qry || '    0 ';
--              v_qry:= v_qry || '  )';
              v_qry:= v_qry || 'insert into T_MCRE0_APP_ALERT_POS_WRK ';
              v_qry:= v_qry || '( ID_ALERT,cod_abi_istituto, cod_abi_cartolarizzato, ';
              v_qry:= v_qry || '  cod_ndg, cod_sndg, ';
              v_qry:= v_qry || '  alert, cod_stato, dta_ins, flg_worse_upd';
              v_qry:= v_qry || ' )values(';
              v_qry:= v_qry || ':p_idalert,:p_abi_istituto,';
              v_qry:= v_qry || ':p_cod_abi,';
              v_qry:= v_qry || ':p_cod_ndg,';
              v_qry:= v_qry || ':p_cod_sndg,';
              v_qry:= v_qry || ':p_alert,';
              v_qry:= v_qry || ':p_cod_stato,';
              v_qry:= v_qry || ':p_sysdate,';
              v_qry:= v_qry || ':p_0 ';
              v_qry:= v_qry || ' )';
              execute immediate v_qry using REC_ALERT.ID_ALERT,v_abi_istituto,p_cod_abi,p_cod_ndg,p_cod_sndg,v_alert,v_cod_stato,sysdate,0;
            exception
              WHEN OTHERS THEN
                PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||REC_ALERT.ID_ALERT||' - INSERT - QRY='||V_QRY,P_ID_UTENTE);
                return ko;
            end;
        end if;
      end if;
    end loop;
    --commit;
    return ok;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ACCESI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - ABI='||p_cod_abi||' NDG='||p_cod_ndg,P_ID_UTENTE);
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
    p_alert T_MCRE0_APP_ALERT.id_alert%type -- default null
  )
  RETURN NUMBER IS
  --pragma autonomous_transaction;
    v_where_1 varchar2(32000);
    v_where_2 varchar2(32000);
    v_qry   varchar2(3000);
    v_exist number;
    V_SPENTO NUMBER(1);
    V_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE;
    
    CURSOR C_ALERT IS
     SELECT   id_alert,
             replace(replace(REPLACE (val_plsql_colore, '_' || id_alert, ''),'T_MCRE0_APP_ALERT_POS','T_MCRE0_APP_ALERT_POS_WRK'),'V_MCRE0_APP_SCHEDA_ANAG_SC_PC','MV_MCRE0_APP_SCHEDA_ANAG_SC_PC') val_plsql_colore,
             val_list_table, val_table_name, val_plsql_join, 
             val_plsql_where_a,val_plsql_where_s,
             tip_info,FLG_ATTIVO
        FROM t_mcre0_app_alert a
       WHERE --a.flg_attivo = 'A'
             --and id_alert = nvl(p_alert,id_alert)
             id_alert = p_alert
    ORDER BY a.id_alert;
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
--      v_qry:= v_qry || ' select 1 ';
--      v_qry:= v_qry || ' from   T_MCRE0_APP_ALERT_POS p ';
--      v_qry:= v_qry || ' where  p.cod_abi_cartolarizzato  = '''||p_cod_abi||'''';
--      v_qry:= v_qry || ' and    p.cod_ndg  = '''||p_cod_ndg||'''';
--      execute immediate v_qry into v_exist; 
        v_qry:= v_qry || ' select distinct 1 ';
        v_qry:= v_qry || ' from T_MCRE0_APP_ALERT_POS_WRK';
        v_qry:= v_qry || ' where cod_abi_cartolarizzato = :cod_abi_cartolarizzato';
        v_qry:= v_qry || ' and   cod_ndg = :cod_ndg';        
        v_qry:= v_qry || ' and   id_alert =:p_alert';-- partiz
        execute immediate v_qry into v_exist using p_cod_abi, P_COD_NDG,p_alert;      
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
            if(instr(lower(v_qry),':p_id_utente')>0)then
              execute immediate v_qry into v_spento using p_id_utente, v_where_1,v_where_2;
            else
              execute immediate v_qry into v_spento using v_where_1,v_where_2;
            end if;
          exception
            when no_data_found then
               v_spento:= 0;
            WHEN OTHERS THEN
              PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_SPENTI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||REC_ALERT.ID_ALERT||' - SELECT flg - QRY='||V_QRY,P_ID_UTENTE);
              return ko;
          end;
          if(v_spento = 0) then
            BEGIN
              v_qry:= null;
              v_where_1 := p_cod_abi;
              v_where_2 := p_cod_ndg;
              V_QRY:= V_QRY || ' select 1 ';
              v_qry:= v_qry || ' from   V_MCRE0_APP_UPD_FIELDS_P1 x ';  
              v_qry:= v_qry || ' where  x.COD_ABI_CARTOLARIZZATO = :where_1';
              v_qry:= v_qry || ' and    x.COD_NDG =:where_2';
              
              execute immediate v_qry into v_exist using v_where_1,v_where_2;
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
--            v_qry:= v_qry || ' update T_MCRE0_APP_ALERT_POS a ';
--            v_qry:= v_qry || ' set alert_'||rec_alert.id_alert||' = null,';
--            v_qry:= v_qry || '     cod_stato_'||rec_alert.id_alert||' = null, ';
--            v_qry:= v_qry || '     dta_ins_'||rec_alert.id_alert||' = null, ';
--            v_qry:= v_qry || '     dta_upd_'||rec_alert.id_alert||' = case when dta_ins_'||rec_alert.id_alert||' is NULL then NULL else sysdate end ,';
--            v_qry:= v_qry || '     a.flg_worse_upd_'||rec_alert.id_alert||' = null ';
--            v_qry:= v_qry || ' where cod_abi_cartolarizzato = '''||p_cod_abi||'''';
--            v_qry:= v_qry || ' and   cod_ndg = '''||p_cod_ndg||'''';
--            execute immediate v_qry;
            v_qry:= v_qry || ' update T_MCRE0_APP_ALERT_POS_WRK a ';
            v_qry:= v_qry || ' set alert = null,';
            v_qry:= v_qry || '     cod_stato = null, ';
            v_qry:= v_qry || '     dta_ins = null, ';
            v_qry:= v_qry || '     dta_upd= case when dta_ins is NULL then NULL else sysdate end,';
            v_qry:= v_qry || '     a.flg_worse_upd = null ';
            v_qry:= v_qry || ' where cod_abi_cartolarizzato = :p_cod_abi';
            v_qry:= v_qry || ' and   cod_ndg = :p_cod_ndg';            
            v_qry:= v_qry || ' and   id_alert =:p_alert';-- partiz
            execute immediate v_qry using p_cod_abi,p_cod_ndg,p_alert;
          exception
            WHEN OTHERS THEN
              PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_SPENTI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ID_ALERT='||REC_ALERT.ID_ALERT||' - UPDATE - QRY='||V_QRY,P_ID_UTENTE);
              return ko;
          end;
        end if;
      end loop;
    end if;
    --commit;
    return ok;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_SPENTI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - ABI='||p_cod_abi||' NDG='||p_cod_ndg,P_ID_UTENTE);
      return ko;
  END; 
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
      PKG_MCRE0_AUDIT.LOG_ETL(v_cod_log,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_BLOCCO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,'Blocco '||P_COD_BLOCCO,'Calcolato Alert '||REC_ALERT.ID_ALERT);
    end LOOP;
    RETURN ok; 
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Errore generale');
      return ko;
  end;
  -- Procedura per insert/update alert accesi
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   --COMMIT
  FUNCTION FNC_VERIFICA_ALERT_ID (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE default null,
    p_alert T_MCRE0_APP_ALERT.ID_ALERT%TYPE  --default null
  )RETURN NUMBER IS
    v_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE;
    v_id_utente T_MCRE0_APP_ALL_DATA.id_utente%type;
    v_result number;
    
    cursor C_POS_a is --v3.0
      select  COD_ABI_CARTOLARIZZATO, cod_ndg,  cod_sndg, id_utente
      from   T_MCRE0_APP_ALERT_POS_A where id_alert=p_alert;
     cursor c_pos_s is
      select  COD_ABI_CARTOLARIZZATO, cod_ndg,  cod_sndg, id_utente
      from   T_MCRE0_APP_ALERT_POS_S where id_alert=p_alert;
  BEGIN
     IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
     end if;
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'Verifica ID_ALERT='||p_alert);
    FOR REC_POS_a IN C_POS_a LOOP
     -- PKG_MCRE0_AUDIT.LOG_APP(V_COD_LOG,'PKG_MCRE0_ALERT3.PIPPO',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'fnc_verifica_alert_accesi - cod_abi_cartolarizzato='||REC_POS.COD_ABI_CARTOLARIZZATO||' cod_ndg='||REC_POS.COD_NDG||' ID_ALERT='||p_alert);
      v_result := fnc_verifica_alert_accesi(rec_pos_a.cod_abi_cartolarizzato, rec_pos_a.cod_ndg, rec_pos_a.cod_sndg, rec_pos_a.id_utente,V_COD_LOG,p_alert);
      IF(V_RESULT=KO)THEN
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'fnc_verifica_alert_accesi - cod_abi_cartolarizzato='||REC_POS_a.COD_ABI_CARTOLARIZZATO||' cod_ndg='||REC_POS_a.COD_NDG||' ID_ALERT='||p_alert);
        return ko;
      END IF;
    end LOOP;
    for rec_pos_s in c_pos_s loop
      v_result := fnc_verifica_alert_spenti(rec_pos_s.cod_abi_cartolarizzato, rec_pos_s.cod_ndg, rec_pos_s.cod_sndg, rec_pos_s.id_utente,V_COD_LOG,p_alert);
      IF(V_RESULT=KO)THEN
        PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'fnc_verifica_alert_spenti - cod_abi_cartolarizzato='||REC_POS_s.COD_ABI_CARTOLARIZZATO||' cod_ndg='||REC_POS_s.COD_NDG||' ID_ALERT='||p_alert);
       return ko;
      END IF;
    end loop;
    commit;
    return ok;
  EXCEPTION
    WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,'PKG_MCRE0_ALERT3.FNC_VERIFICA_ALERT_ID',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - ID_ALERT='||p_alert);
      rollback;
      return ko;
  END;
 
END PKG_MCRE0_ALERT3;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ALERT3 FOR MCRE_OWN.PKG_MCRE0_ALERT3;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ALERT3 FOR MCRE_OWN.PKG_MCRE0_ALERT3;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ALERT3 TO MCRE_USR;

