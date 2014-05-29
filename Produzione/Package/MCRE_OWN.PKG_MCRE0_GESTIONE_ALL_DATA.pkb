CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_GESTIONE_ALL_DATA" AS
/******************************************************************************
   NAME:       PKG_MCRE0_GESTIONE_ALL_DATA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        04/08/2011  Marco Murro        Created this package.
   1.1        31/08/2011  Marco Murro        Aggiunto update x Gb.
   1.2        04/11/2011  Marco Murro        Aggiunti campi di Sostituzione.
   1.3        25/10/2012  Marco Murro        Integrata gestione GB e RS in Insert
   1.4        08/11/2012  Luca Ferretti      Modifica ribaltamento file_guida con modifiche Bellani
   1.5        08/11/2012  Marco Murro        Variata pulizia cod/dta servizio
   1.51       10/01/2013  Marco Murro        Variato default sysdate su dta servizio non pi¿ PT
   2.0        25/06/2013  Marco Murro        Fix dta_servizio, cod_grup_sup_old per apertura rg
   2.1        01/07/2013  Tiziano Bernardi   Aggiunte procedure per gestione regioni
   2.2        15/07/2013  Irena Gueorguieva Aggiunte chiamate a ASSEGNA_GESTORI e SPALMA_GRUPPI in fondo a LOAD_ALL_DATA
   2.3        10/10/2013  Tiziano Bernardi   Fix gestione stato/stato_pre per RS
   2.4        10/02/2014  M.Murro   switch all_data --> all_data_old
******************************************************************************/

  -- Procedura per update cod_macrostato, dta_decorrenza_macrostato su ALL_DATA
  -- dopo cambio stato da portale/ws.
  -- NO COMMIT
  FUNCTION fnc_gestione_macrost_cambiost(
    p_cod_abi   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    p_utente    T_MCRE0_APP_ALL_DATA.COD_OPERATORE_INS_UPD%type default '',
    seq         number
  )
  RETURN NUMBER IS

    v_dta_dec_macrostato T_MCRE0_APP_ALL_DATA.DTA_DEC_MACROSTATO%type;
    v_cod_percorso       T_MCRE0_APP_ALL_DATA.COD_PERCORSO%type;
    v_cod_macrostato     T_MCRE0_APP_ALL_DATA.COD_MACROSTATO%type;

  begin

    begin
      select decode(s.cod_macrostato,m.COD_MACROSTATO,m.DTA_DEC_MACROSTATO,null),
             m.COD_PERCORSO,m.COD_MACROSTATO
      into   v_dta_dec_macrostato , v_cod_percorso, v_cod_macrostato
      from   V_MCRE0_APP_UPD_FIELDS_P1 M ,
             T_MCRE0_APP_STATI s
      where m.COD_ABI_CARTOLARIZZATO = p_cod_abi
      and   m.COD_NDG = p_cod_ndg
      and   m.today_flg = '1'
      and   s.cod_microstato = m.cod_stato ;
    exception
      when others then
      PKG_MCRE0_AUDIT.LOG_APP ( seq, c_package||'.fnc_gestione_macrost_cambiost DTA MACROSTATO', 1,
                                SQLCODE, SQLERRM, 'abi: '||p_cod_abi||' ndg: '||p_cod_ndg, p_utente);
      return ko;
    end;

    if(v_dta_dec_macrostato is null)then
      begin
        select min(p.DTA_DECORRENZA_STATO) dta_dec_macrostato
        into  v_dta_dec_macrostato
        from  t_mcre0_app_percorsi24 p,
              t_mcre0_app_stati s2
        where p.cod_stato = s2.cod_microstato
        AND   cod_abi_cartolarizzato= p_cod_abi
        and   cod_ndg = p_cod_ndg
        AND   cod_percorso = v_cod_percorso
        and   s2.COD_MACROSTATO = v_cod_macrostato;
      exception
        when others then
        PKG_MCRE0_AUDIT.LOG_APP ( seq, c_package||'.fnc_gestione_macrost_cambiost MIN DTA MACROSTATO', 1,
                                SQLCODE, SQLERRM, 'abi: '||p_cod_abi||' ndg: '||p_cod_ndg, p_utente);
        return ko;
      end;
    end if;

    begin
      update t_mcre0_app_all_data m --switch 10/2
      --update t_mcre0_app_all_data_old m
      set    dta_dec_macrostato = v_dta_dec_macrostato
      where  m.cod_abi_cartolarizzato = p_cod_abi
      and    m.cod_ndg = p_cod_ndg
      and    m.today_flg = '1';
      --commit;
    exception
      when others then
        PKG_MCRE0_AUDIT.LOG_APP ( seq, c_package||'.fnc_gestione_macrost_cambiost UPDATE DTA MACROSTATO', 1,
                                SQLCODE, SQLERRM, 'abi: '||p_cod_abi||' ndg: '||p_cod_ndg, p_utente);
        return ko;
    end;

    begin
      update T_MCRE0_APP_ALL_DATA m --switch 10/2
      --update T_MCRE0_APP_ALL_DATA_OLD m
      set m.cod_macrostato = (
        select cod_macrostato
        from   T_MCRE0_APP_STATI s
        where  s.cod_microstato = m.cod_stato)
      where m.COD_ABI_CARTOLARIZZATO = p_cod_abi
      and   m.COD_NDG = p_cod_ndg
      and   m.today_flg = '1';
      --commit;
    exception
      when others then
        PKG_MCRE0_AUDIT.LOG_APP ( seq, c_package||'.fnc_gestione_macrost_cambiost UPDATE MACROSTATO', 1,
                                SQLCODE, SQLERRM, 'abi: '||p_cod_abi||' ndg: '||p_cod_ndg, p_utente);
        return ko;
    end;

    return ok;

  exception
    when others then
    PKG_MCRE0_AUDIT.LOG_APP ( seq, c_package||'.fnc_gestione_macrost_cambiost - generale', 1,
                            SQLCODE, SQLERRM, 'abi: '||p_cod_abi||' ndg: '||p_cod_ndg, p_utente);
    return ko;
  end;

  --truncate/insert della ALL_DATA
  FUNCTION LOAD_ALL_DATA (P_COD_LOG number) RETURN NUMBER is

  V_COD_LOG number;
  n number := -1;

  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;


    PKG_MCRE0_AUDIT.LOG_ETL ( V_COD_LOG, c_package||'.LOAD_ALL_DATA', 3, SQLCODE, 'START', '');

    --execute immediate 'TRUNCATE TABLE T_MCRE0_APP_ALL_DATA REUSE STORAGE';--v1.2 aggiunto REUSE STORAGE!
    execute immediate 'TRUNCATE TABLE T_MCRE0_APP_ALL_DATA_OLD REUSE STORAGE';--post Switch del 10/2
    execute immediate 'ALTER SESSION ENABLE PARALLEL DML';

   --v1.3 aggiunta decode diretta per gestione GB su today_flg e case per gestione RS

   --INSERT /*+ APPEND */ INTO T_MCRE0_APP_ALL_DATA ( --post switch 10/2
   INSERT /*+ APPEND */ INTO T_MCRE0_APP_ALL_DATA_OLD (
       TODAY_FLG, COD_ABI_ISTITUTO, COD_ABI_CARTOLARIZZATO, COD_NDG, COD_SNDG,
       COD_COMPARTO_CALCOLATO_PRE, COD_COMPARTO_CALCOLATO, COD_COMPARTO_ASSEGNATO,
       FLG_GRUPPO_ECONOMICO, FLG_GRUPPO_LEGAME, FLG_SINGOLO, FLG_CONDIVISO,
       COD_GRUPPO_LEGAME, COD_GRUPPO_ECONOMICO, COD_GRUPPO_SUPER, DTA_COMPARTO_CALCOLATO,
       ID_UTENTE, ID_UTENTE_PRE, COD_OPERATORE_INS_UPD, DTA_INS, DTA_UPD, ID_DPERFG,
       DTA_UTENTE_ASSEGNATO, FLG_SOMMA, FLG_RIPORTAFOGLIATO, DTA_LAST_RIPORTAF,
       COD_MATR_ASSEGNATORE, COD_COMPARTO_PREASSEGNATO, ID_UTENTE_PREASSEGNATO,
       COD_PROCESSO_PREASSEGNATO, COD_SEZIONE_PREASSEGNATA, COD_RAMO_CALCOLATO,
       COD_SERVIZIO, DTA_SERVIZIO, FLG_SOURCE, FLG_ACTIVE, DTA_INTERCETTAMENTO,
       COD_FILIALE, COD_STRUTTURA_COMPETENTE, COD_TIPO_INGRESSO, COD_CAUSALE_INGRESSO,
       COD_PERCORSO, COD_PROCESSO, COD_STATO, DTA_DECORRENZA_STATO, DTA_SCADENZA_STATO,
       COD_STATO_PRECEDENTE, DTA_DECORRENZA_STATO_PRE, DTA_PROCESSO, COD_PROCESSO_PRE,
       COD_MACROSTATO, DTA_DEC_MACROSTATO, COD_COMPARTO_HOST, COD_RAMO_HOST,
       ID_STATO_POSIZIONE, COD_CLIENTE_ESTESO, ID_CLIENTE_ESTESO, DESC_ANAG_GESTORE_MKT,
       COD_GESTORE_MKT, COD_TIPO_PORTAFOGLIO, FLG_GESTIONE_ESTERNA, VAL_PERC_DECURTAZIONE,
       ID_DPERMO, ID_TRANSIZIONE, FLG_OUTSOURCING, COD_MATR_RISCHIO, COD_UO_RISCHIO,
       COD_DISP_RISCHIO, DESC_ISTITUTO, DESC_BREVE, FLG_TARGET, FLG_CARTOLARIZZATO,
       DTA_ABI_ELAB, DESC_NOME_CONTROPARTE, DESC_GRUPPO_ECONOMICO, DTA_RIF_PD_ONLINE,
       VAL_RATING_ONLINE, VAL_PD_ONLINE, SCSB_UTI_TOT, SCSB_ACC_TOT, SCSB_UTI_CASSA,
       SCSB_UTI_FIRMA, SCSB_ACC_CASSA, SCSB_ACC_FIRMA, GB_VAL_MAU, GEGB_ACC_CASSA,
       GEGB_ACC_FIRMA, GEGB_UTI_CASSA, GEGB_UTI_FIRMA, GLGB_ACC_CASSA, GLGB_ACC_FIRMA,
       GLGB_UTI_CASSA, GLGB_UTI_FIRMA,
       SCSB_ACC_SOSTITUZIONI, SCSB_UTI_SOSTITUZIONI,--v1.2 sostituzioni
       COD_FILIALE_GB, COD_PROCESSO_CALCOLATO_GB,
       COD_MACROSTATO_PROPOSTO_GB, DTA_INS_GB, FLG_STATO_GB, COD_GRUPPO_SUPER_OLD --v2.0
       )
   SELECT --v1.3 MM decode GB
          decode(GB.FLG_STATO,'1','1', F.TODAY_FLG) TODAY_FLG,
          F.COD_ABI_ISTITUTO, F.COD_ABI_CARTOLARIZZATO,
          F.COD_NDG, F.COD_SNDG, nvl(COD_COMPARTO_CALCOLATO_PRE,'#'),
          nvl(COD_COMPARTO_CALCOLATO,'#'), COD_COMPARTO_ASSEGNATO,
          FLG_GRUPPO_ECONOMICO, FLG_GRUPPO_LEGAME, FLG_SINGOLO, FLG_CONDIVISO,
          COD_GRUPPO_LEGAME, nvl(COD_GRUPPO_ECONOMICO,-1), COD_GRUPPO_SUPER,
          DTA_COMPARTO_CALCOLATO, nvl(ID_UTENTE,-1),
         --------------------   VG - CIB/BDT - INIZIO --------------------
         ----nvl(ID_UTENTE_PRE,-1),
          nvl(nullif(ID_UTENTE_PRE,id_utente),-1),
          --------------------   VG - CIB/BDT - FINE --------------------
          F.COD_OPERATORE_INS_UPD, F.DTA_INS, F.DTA_UPD, F.ID_DPER ID_DPERFG,
          --------------------   VG - CIB/BDT - INIZIO --------------------
          ----DTA_UTENTE_ASSEGNATO,
          case when id_utente is null then null else DTA_UTENTE_ASSEGNATO end DTA_UTENTE_ASSEGNATO,
          --------------------   VG - CIB/BDT - FINE --------------------
          FLG_SOMMA, FLG_RIPORTAFOGLIATO,
          DTA_LAST_RIPORTAF, COD_MATR_ASSEGNATORE, COD_COMPARTO_PREASSEGNATO,
          ID_UTENTE_PREASSEGNATO, COD_PROCESSO_PREASSEGNATO,
          COD_SEZIONE_PREASSEGNATA, COD_RAMO_CALCOLATO,
          --v1.5 INI -- M.M.: sbianco servizio e dta servizio per <= PT, uniformo per sndg se > PT
          --COD_SERVIZIO, DTA_SERVIZIO,
          case when m.cod_macrostato in ('PT','RIO', 'IN', 'SC', 'RS', 'SO') then
            f.COD_SERVIZIO
          else null
          end  as COD_SERVIZIO,
          case --V2.0 dta_servizio solo se cod_servizio valorizzato!
           when m.cod_macrostato in ('IN', 'RS') and f.COD_SERVIZIO is not null then
           --v1.51 aggiunti NVL per gestire il passaggio da PT (null) ad altri stati (sysdate)
           NVL( min( case when m.cod_stato in ('IN', 'RS') and F.TODAY_FLG = '1'
                 then f.dta_servizio else null end ) over (partition by f.cod_sndg) , SYSDATE)
            when m.cod_macrostato in ('RIO', 'SC', 'SO') then NVL( f.dta_servizio  , SYSDATE)
          else null
          end  as DTA_SERVIZIO,
          --v1.5 FINE --
          FLG_SOURCE, FLG_ACTIVE,
--MOPLE + RS
          DTA_INTERCETTAMENTO,
          nvl(M.COD_FILIALE,'-'), COD_STRUTTURA_COMPETENTE, COD_TIPO_INGRESSO,
          COD_CAUSALE_INGRESSO, M.COD_PERCORSO, M.COD_PROCESSO,
          case when COD_STATO = 'IN' and R.DTA_DECORRENZA_STATO is not null and DTA_CHIUSURA_STATO is null
            then 'RS' else nvl(COD_STATO,'-1')
          END COD_STATO ,
         -- R.DTA_DECORRENZA_STATO,
           ------------------------------
          CASE WHEN COD_STATO = 'IN' AND R.DTA_DECORRENZA_STATO IS NOT NULL AND DTA_CHIUSURA_STATO IS NULL
            THEN TRUNC(R.DTA_DECORRENZA_STATO)
            ELSE --maggiore tra le 2 M.DTA_DECORRENZA_STATO
              CASE WHEN (TRUNC(R.DTA_CHIUSURA_STATO) - M.DTA_DECORRENZA_STATO)< 0
                THEN M.DTA_DECORRENZA_STATO
              WHEN (TRUNC(R.DTA_CHIUSURA_STATO) - M.DTA_DECORRENZA_STATO)> 0
                THEN TRUNC(R.DTA_CHIUSURA_STATO)
              WHEN (TRUNC(R.DTA_CHIUSURA_STATO) - M.DTA_DECORRENZA_STATO)= 0
                THEN M.DTA_DECORRENZA_STATO
              ELSE   M.DTA_DECORRENZA_STATO
                END
          END DTA_DECORRENZA_STATO,
          -----------------------------
          DTA_SCADENZA_STATO,
          --nvl(COD_STATO_PRECEDENTE,'-1'),

          CASE
              WHEN M.COD_STATO in ('IN','SO') AND R.DTA_DECORRENZA_STATO IS NOT NULL AND DTA_CHIUSURA_STATO IS NOT NULL
              THEN (
              SELECT COD_STATO_PRECEDENTE FROM (
                SELECT X.COD_STATO_PRECEDENTE ,X.COD_ABI_CARTOLARIZZATO, X.COD_NDG,X.TMS,
                      MAX(X.TMS) OVER (PARTITION BY X.COD_ABI_CARTOLARIZZATO, X.COD_NDG) MAX_TMS
                FROM T_MCRE0_APP_PERCORSI24 X)GR
                WHERE gr.TMS= gr.MAX_TMS
                  AND F.COD_ABI_CARTOLARIZZATO = GR.COD_ABI_CARTOLARIZZATO(+)
                  AND F.COD_NDG = GR.COD_NDG(+)
                )
              ELSE NVL(COD_STATO_PRECEDENTE,'-1')
          END COD_STATO_PRECEDENTE,
          DTA_DECORRENZA_STATO_PRE,
          DTA_PROCESSO, COD_PROCESSO_PRE,
          --m.COD_MACROSTATO, DTA_DEC_MACROSTATO,
          case when COD_STATO = 'IN' and R.DTA_DECORRENZA_STATO is not null and DTA_CHIUSURA_STATO is null
            then 'RS' else m.COD_MACROSTATO
          end COD_MACROSTATO  ,
          case when COD_STATO = 'IN' and R.DTA_DECORRENZA_STATO is not null and DTA_CHIUSURA_STATO is null
            then trunc(R.DTA_DECORRENZA_STATO) else DTA_DEC_MACROSTATO
          end DTA_DEC_MACROSTATO,
          COD_COMPARTO_HOST,
          COD_RAMO_HOST, ID_STATO_POSIZIONE, COD_CLIENTE_ESTESO,
          ID_CLIENTE_ESTESO, DESC_ANAG_GESTORE_MKT, COD_GESTORE_MKT,
          COD_TIPO_PORTAFOGLIO, FLG_GESTIONE_ESTERNA, VAL_PERC_DECURTAZIONE,
          M.ID_DPER ID_DPERMO, ID_TRANSIZIONE,
          NVL (M.FLG_OUTSOURCING, I.FLG_OUTSOURCING) FLG_OUTSOURCING,
          COD_MATR_RISCHIO, COD_UO_RISCHIO, COD_DISP_RISCHIO,
--istituti
          DESC_ISTITUTO,
          DESC_BREVE, FLG_TARGET, FLG_CARTOLARIZZATO, DTA_ABI_ELAB,

--anagrafiche
          A.DESC_NOME_CONTROPARTE, GE.VAL_ANA_GRE DESC_GRUPPO_ECONOMICO,
          DTA_RIF_PD_ONLINE, VAL_RATING_ONLINE, VAL_PD_ONLINE,
--PCR
          SCSB_UTI_TOT,
          SCSB_ACC_TOT, SCSB_UTI_CASSA, SCSB_UTI_FIRMA, SCSB_ACC_CASSA,
          SCSB_ACC_FIRMA, GB_VAL_MAU, GEGB_ACC_CASSA, GEGB_ACC_FIRMA,
          GEGB_UTI_CASSA, GEGB_UTI_FIRMA, GLGB_ACC_CASSA, GLGB_ACC_FIRMA,
          GLGB_UTI_CASSA, GLGB_UTI_FIRMA,
          SCSB_ACC_SOSTITUZIONI, SCSB_UTI_SOSTITUZIONI,--v1.2
--GB
          GB.COD_FILIALE COD_FILIALE_GB,
          COD_PROCESSO_CALCOLATO COD_PROCESSO_CALCOLATO_GB,
          GB.COD_MACROSTATO_PROPOSTO COD_MACROSTATO_PROPOSTO_GB,
          GB.DTA_INS DTA_INS_GB, FLG_STATO FLG_STATO_GB,
          F.COD_GRUPPO_SUPER_OLD --V2.0
     FROM T_MCRE0_APP_FILE_GUIDA24 F,
          T_MCRE0_APP_MOPLE24 M,
          T_MCRE0_APP_GB_GESTIONE GB,
          T_MCRE0_APP_PCR24 P,
          T_MCRE0_APP_ANAGR_GRE24 GE,
          MV_MCRE0_APP_ISTITUTI I,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO2 A,
          (select * from (
                select r.* , max(tms_ini) over (partition by cod_abi_cartolarizzato, cod_ndg) max_tms
                from T_MCRE0_APP_RS_POSIZIONI r
                )
                where tms_ini = max_tms) r --v1.3
   WHERE
          F.COD_ABI_CARTOLARIZZATO = M.COD_ABI_CARTOLARIZZATO(+)
      AND F.COD_NDG = M.COD_NDG(+)
      AND F.TODAY_FLG = M.TODAY_FLG(+)
      AND F.COD_ABI_CARTOLARIZZATO = GB.COD_ABI_CARTOLARIZZATO(+)
      AND F.COD_NDG = GB.COD_NDG(+)
      AND GB.FLG_STATO(+) = 1
      AND F.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO(+)
      AND F.COD_NDG = P.COD_NDG(+)
      AND F.TODAY_FLG = P.TODAY_FLG(+)
      AND nvl(F.COD_GRUPPO_ECONOMICO,'-1') = GE.COD_GRE
      AND F.COD_ABI_ISTITUTO = I.COD_ABI
      AND F.COD_SNDG = A.COD_SNDG

      and F.COD_ABI_CARTOLARIZZATO = R.COD_ABI_CARTOLARIZZATO(+)
      AND F.COD_NDG = R.COD_NDG(+)
   ;


    n := sql%rowcount;
    COMMIT;

    --v1.1 riaggiorno today_flg per GB a 1
--    UPDATE t_mcre0_app_all_data a
--    set today_flg = '1'
--    where (cod_abi_cartolarizzato, cod_ndg) in (
--    select cod_abi_cartolarizzato, cod_ndg from v_mcre0_app_gb_gestione
--    where FLG_STATO = 1);
--    n := sql%rowcount;
--    commit;

-- 14.07.2013
       ASSEGNA_REGIONI;
       SPALMA_GRUPPI;
    PKG_MCRE0_AUDIT.LOG_ETL ( V_COD_LOG, c_package||'.LOAD_ALL_DATA', 3, SQLCODE, 'END', 'ripristinati '||n||' record');
    return ok;

  exception when others then
    PKG_MCRE0_AUDIT.LOG_ETL ( V_COD_LOG, c_package||'.LOAD_ALL_DATA', 1, SQLCODE, SQLERRM, '');
    return ko;
  end;


  --inserisce eventuali tappi nelle anagrafiche
  FUNCTION ETL_GESTIONE_TAPPI(P_COD_LOG number) RETURN NUMBER is

  seq number;
  num number:= 0;

  BEGIN

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO seq
        from dual;
    ELSE
      seq := P_COD_LOG;
    end if;

    --tappo filiali...
    insert into t_mcre0_app_struttura_org (COD_ABI_ISTITUTO, COD_STRUTTURA_COMPETENTE, DESC_STRUTTURA_COMPETENTE, COD_LIVELLO,COD_STR_ORG_SUP )
    select cod_abi_istituto, cod_filiale, '','FI',-1 from (
    select cod_abi_istituto, cod_filiale from t_mcre0_app_mople24 m
    minus
    select cod_abi_istituto , cod_struttura_competente  from t_mcre0_app_struttura_org)
    where cod_filiale is not null;
    num:=sql%rowcount;
--    PKG_MCRE0_AUDIT.LOG_ETL ( seq, c_package||'.ETL_GESTIONE_TAPPI', 3, SQLCODE, 'Filiali', num||' inserimenti');

    insert into t_mcre0_app_struttura_org (COD_ABI_ISTITUTO, COD_STRUTTURA_COMPETENTE, DESC_STRUTTURA_COMPETENTE, COD_LIVELLO, COD_STR_ORG_SUP )
    select cod_abi_istituto, cod_struttura_competente, '','FI',-1 from (
    select cod_abi_istituto, cod_struttura_competente from t_mcre0_app_mople24 m
    minus
    select cod_abi_istituto , cod_struttura_competente  from t_mcre0_app_struttura_org
    ) where cod_struttura_competente is not null;
    num:=num+sql%rowcount;
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, c_package||'.ETL_GESTIONE_TAPPI', 3, SQLCODE, 'Filiali', num||' inserimenti');

    --GE senza anagrafica
    insert into T_MCRE0_APP_ANAGR_GRE24 (COD_GRE, VAL_ANA_GRE, DTA_INS, DTA_UPD)
    select cod_gruppo_economico, ' - ', trunc(sysdate), trunc(sysdate) from t_mcre0_app_file_guida24
    where cod_gruppo_economico is not null
    minus
    select COD_GRE, ' - ', trunc(sysdate), trunc(sysdate) from T_MCRE0_APP_ANAGR_GRE24;
    num:=sql%rowcount;
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, c_package||'.ETL_GESTIONE_TAPPI', 3, SQLCODE, 'Anag GRE', num||' inserimenti');

    --SNDG senza anagrafica
    insert into T_MCRE0_APP_ANAGRAFICA_GRUPPO2 (COD_SNDG, DESC_NOME_CONTROPARTE, DTA_INS, DTA_UPD)
    select distinct cod_sndg, '',trunc(sysdate), trunc(sysdate) from t_mcre0_app_file_guida24
    where cod_sndg is not null
    minus
    select cod_sndg, '',trunc(sysdate), trunc(sysdate) from t_mcre0_app_anagrafica_gruppo2;
    num:=sql%rowcount;
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, c_package||'.ETL_GESTIONE_TAPPI', 3, SQLCODE, 'Anagrafica', num||' inserimenti');

    --nuovi abi
    insert into MCRE_OWN.T_MCRE0_APP_ISTITUTI_ALL (COD_ISTITUTO, COD_ABI, COD_ABI_VISUALIZZATO, COD_ABI_ISTITUTO, DESC_BREVE, FLG_CCP)
    select 'XX', cod_abi_cartolarizzato, cod_abi_cartolarizzato, cod_abi_cartolarizzato, 'N.D.', 1 from t_mcre0_app_file_guida24
    minus
    select 'XX', cod_abi, cod_abi, cod_abi, 'N.D.', 1 from t_mcre0_app_istituti;
    num:=sql%rowcount;
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, c_package||'.ETL_GESTIONE_TAPPI', 3, SQLCODE, 'Abi', num||' inserimenti');

    --nuovi comparti
    insert into T_MCRE0_APP_COMPARTI (COD_COMPARTO, DESC_COMPARTO, cod_livello)
    select distinct COD_COMPARTO, DESC_COMPARTO, cod_livello from T_MCRE0_APP_STRUTTURA_ORG
    where cod_comparto not in (select cod_comparto from T_MCRE0_APP_COMPARTI)
    and cod_comparto not in ('011903','011904');
    num:=sql%rowcount;
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, c_package||'.ETL_GESTIONE_TAPPI', 3, SQLCODE, 'Comparti', num||' inserimenti');
    commit;
    return ok;

  exception     when others then
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, c_package||'.ETL_GESTIONE_TAPPI', 1, SQLCODE, SQLERRM, 'errore inserimento tappi');
    return ko;

  END;

--ripristina riporta su FG gli aggiornamneti fatti su all_data
FUNCTION ETL_RESTORE_FILE_GUIDA (P_COD_LOG number) return number is

V_COD_LOG number;

  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.ETL_RESTORE_FILE_GUIDA',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

  --ripristino i dati variaabili dal tabellone al file guida originario
  --passo 0 dell'ETL II


    -- merge modifica 1.4
    MERGE /*+ parallel (f 4) */ INTO T_MCRE0_APP_FILE_GUIDA24 F
         USING (SELECT * FROM T_MCRE0_APP_ALL_DATA
                WHERE FLG_ACTIVE = '1') D
            ON (    F.COD_ABI_CARTOLARIZZATO = D.COD_ABI_CARTOLARIZZATO
                AND F.COD_NDG = D.COD_NDG)
    WHEN MATCHED THEN
        UPDATE
           SET  F.COD_COMPARTO_ASSEGNATO = D.COD_COMPARTO_ASSEGNATO,
                F.ID_UTENTE              = NULLIF(D.ID_UTENTE,-1),
                F.ID_UTENTE_PRE          = NULLIF(D.ID_UTENTE_PRE,-1),
                F.DTA_UTENTE_ASSEGNATO   = D.DTA_UTENTE_ASSEGNATO,
                F.COD_OPERATORE_INS_UPD  = D.COD_OPERATORE_INS_UPD,
                F.DTA_UPD                = D.DTA_UPD,
                F.ID_DPER                = D.ID_DPERFG,
                F.DTA_SERVIZIO           = D.DTA_SERVIZIO,
                F.COD_SERVIZIO           = D.COD_SERVIZIO,
                F.FLG_SOURCE             = '0',
                F.FLG_ACTIVE             = '0',
                F.COD_MATR_ASSEGNATORE = null,
                F.COD_COMPARTO_PREASSEGNATO = null,
                F.ID_UTENTE_PREASSEGNATO = null,
                F.COD_PROCESSO_PREASSEGNATO = null,
                F.COD_SEZIONE_PREASSEGNATA = null;

--    MERGE /*+ parallel (f 4) */ INTO T_MCRE0_APP_FILE_GUIDA F
--         USING (SELECT * FROM T_MCRE0_APP_ALL_DATA
--                WHERE FLG_ACTIVE = '1') D
--            ON (    F.COD_ABI_CARTOLARIZZATO = D.COD_ABI_CARTOLARIZZATO
--                AND F.COD_NDG = D.COD_NDG)
--    WHEN MATCHED THEN
--        UPDATE
--           SET  F.COD_COMPARTO_ASSEGNATO = D.COD_COMPARTO_ASSEGNATO,
--                F.ID_UTENTE              = NULLIF(D.ID_UTENTE,-1),
--                F.ID_UTENTE_PRE          = NULLIF(D.ID_UTENTE_PRE,-1),
--                F.DTA_UTENTE_ASSEGNATO   = D.DTA_UTENTE_ASSEGNATO,
--                F.COD_OPERATORE_INS_UPD  = D.COD_OPERATORE_INS_UPD,
--                F.DTA_UPD                = D.DTA_UPD,
--                F.ID_DPER                = D.ID_DPERFG,
--                F.DTA_SERVIZIO           = D.DTA_SERVIZIO,
--                F.COD_SERVIZIO           = D.COD_SERVIZIO,
--                F.FLG_SOURCE             = D.FLG_SOURCE,
--                F.FLG_ACTIVE             = D.FLG_ACTIVE   ;

    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.ETL_RESTORE_FILE_GUIDA',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' merge su '||sql%rowcount||'posizioni','END');

    commit;
    return ok;

  exception when others then
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.ETL_RESTORE_FILE_GUIDA',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Errore bloccante: ETL BLOCCATO');
    return ko;
  end;

--ripristina riporta su Mople gli aggiornamneti fatti su all_data
FUNCTION ETL_RESTORE_MOPLE (P_COD_LOG number) return number is

V_COD_LOG number;

  begin

    IF( P_COD_LOG IS NULL) THEN
        SELECT SEQ_MCR0_LOG_ETL.NEXTVAL
        INTO V_COD_LOG
        from dual;
    ELSE
      V_COD_LOG := P_COD_LOG;
    end if;

    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.ETL_RESTORE_MOPLE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,SQLERRM,'START');

  --ripristino i dati variaabili dal tabellone al file guida originario
  --passo 0 dell'ETL II

  --v1.3 - aggiunta decode per mascherare gli RS..

    MERGE /*+ parallel (f 4) */ INTO T_MCRE0_APP_MOPLE24 F
         USING (SELECT * FROM T_MCRE0_APP_ALL_DATA
                WHERE TODAY_FLG = '1') D
            ON (    F.COD_ABI_CARTOLARIZZATO = D.COD_ABI_CARTOLARIZZATO
                AND F.COD_NDG = D.COD_NDG)
    WHEN MATCHED THEN
        UPDATE
           SET  F.COD_PERCORSO              = D.COD_PERCORSO,
                F.COD_PROCESSO              = D.COD_PROCESSO,
                F.COD_STATO                 = decode(D.COD_STATO,'RS','IN',D.COD_STATO), --v1.3
                F.DTA_DECORRENZA_STATO      = D.DTA_DECORRENZA_STATO,
                F.DTA_SCADENZA_STATO        = D.DTA_SCADENZA_STATO,
                F.COD_STATO_PRECEDENTE      = D.COD_STATO_PRECEDENTE,
                F.DTA_UPD                   = D.DTA_UPD,
                F.ID_DPER                   = D.ID_DPERMO,
                F.COD_MACROSTATO            = D.COD_MACROSTATO,
                F.DTA_DEC_MACROSTATO        = D.DTA_DEC_MACROSTATO,
                F.DTA_PROCESSO              = D.DTA_PROCESSO,
                F.COD_PROCESSO_PRE          = D.COD_PROCESSO_PRE,
                F.DTA_DECORRENZA_STATO_PRE  = D.DTA_DECORRENZA_STATO_PRE;

    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.ETL_RESTORE_MOPLE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' merge su '||sql%rowcount||'posizioni','END');

    commit;
    return ok;

  exception when others then
    PKG_MCRE0_AUDIT.LOG_ETL(V_COD_LOG,c_package||'.ETL_RESTORE_MOPLE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Errore bloccante: ETL BLOCCATO');
    return ko;
  end;

--assegna in automatico un utente quando lo trova a -1 in base al cod_stato peggiore
PROCEDURE ASSEGNA_REGIONI
AS

  FLG NUMBER(1);

  BEGIN

  SELECT VALORE_COSTANTE INTO FLG
  FROM T_MCRE0_WRK_CONFIGURAZIONE
  WHERE NOME_COSTANTE = 'FLG_ATTIVA_REGIONI';

      IF (FLG =1)
      THEN
      BEGIN

--      MERGE INTO T_MCRE0_APP_ALL_DATA TGT --switch 10/2
      MERGE INTO T_MCRE0_APP_ALL_DATA_OLD TGT
    USING (
              SELECT
                      MAX (V.VAL_DEC) OVER (PARTITION BY COD_GRUPPO_SUPER) AS MX ,
                      V.ID_UTENTE_ASSEGNATO,
                      V.ID_UTENTE_ASSEGNATO_PT,
                      V.COD_GRUPPO_SUPER,
                      V.COD_COMPARTO_CALCOLATO,
                      V.ID_UTENTE,
                      V.COD_ABI_CARTOLARIZZATO,
                      V.COD_NDG,
                      V.COD_FILIALE,
                      V.COD_STATO,
                      V.VAL_DEC,
                      CASE
                      --    WHEN V.VAL_DEC = MAX (V.VAL_DEC) OVER (PARTITION BY COD_GRUPPO_SUPER) --old
                      --mm 05/07 variato test
                          WHEN MAX (V.VAL_DEC) OVER (PARTITION BY COD_GRUPPO_SUPER) > 1
                      THEN
                          V.ID_UTENTE_ASSEGNATO
                          ELSE V.ID_UTENTE_ASSEGNATO_PT
                      END ID_CORR
FROM (
      SELECT X.ID_UTENTE_ASSEGNATO,
             X.ID_UTENTE_ASSEGNATO_PT,
             X.COD_STRUTTURA_COMPETENTE_FI,
             X.COD_ABI_ISTITUTO,
             P_MERGE.COD_GRUPPO_SUPER,
             P_MERGE.COD_COMPARTO_CALCOLATO,
             P_MERGE.ID_UTENTE,
             P_MERGE.COD_ABI_CARTOLARIZZATO,
             P_MERGE.COD_NDG,
             P_MERGE.COD_FILIALE,
             P_MERGE.COD_STATO,
             P_MERGE.VAL_ORDINE,
             P_MERGE.FLG_ACTIVE,
             P_MERGE.VAL_DEC
             FROM T_MCRE0_APP_ASSOCIA_GESTORI_UO X , (SELECT A.COD_GRUPPO_SUPER,
                                                                           A.COD_COMPARTO_CALCOLATO,
                                                                           A.ID_UTENTE,
                                                                           A.COD_ABI_CARTOLARIZZATO,
                                                                           A.COD_NDG,
                                                                           A.COD_FILIALE,
                                                                           A.COD_STATO,
                                                                           S.VAL_ORDINE,
                                                                           A.FLG_ACTIVE,
                                                                           DECODE(NVL(S.VAL_ORDINE,'0'),10,1,0,1,2) AS VAL_DEC
                                                                   -- FROM MCRE_OWN.T_MCRE0_APP_ALL_DATA A, T_MCRE0_APP_STATI S
                                                                    FROM MCRE_OWN.T_MCRE0_APP_ALL_DATA_OLD A, T_MCRE0_APP_STATI S
                                                                    WHERE
                                                                        A.ID_UTENTE = -1
                                                                        AND A.FLG_ACTIVE = '1'
                                                                        AND S.COD_MICROSTATO = A.COD_STATO
                                                                        --DA TESTARE!!!
                                                                        and S.FLG_STATO_CHK = '1'
                                                                        and A.FLG_OUTSOURCING = 'Y'
                                                                        --
                                                                        AND MCRE_OWN.FNC_MCREI_IS_NUMERIC (COD_GRUPPO_SUPER) =1
                                                       )P_MERGE
              WHERE X.COD_ABI_ISTITUTO = P_MERGE.COD_ABI_CARTOLARIZZATO
                  AND X.COD_STRUTTURA_COMPETENTE_FI = P_MERGE.COD_FILIALE
                  AND X.COD_COMPARTO_ASSEGNATARIO = P_MERGE.COD_COMPARTO_CALCOLATO
                  AND X.FLG_ATTIVO = '1') V ) SRC
    ON (TGT.COD_NDG = SRC.COD_NDG AND TGT.COD_ABI_CARTOLARIZZATO = SRC.COD_ABI_CARTOLARIZZATO )
    WHEN MATCHED THEN UPDATE
          SET TGT.ID_UTENTE = SRC.ID_CORR,
              TGT.COD_COMPARTO_ASSEGNATO = SRC.COD_COMPARTO_CALCOLATO,
              TGT.DTA_UTENTE_ASSEGNATO = SYSDATE
              ;


    PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.ETL_ASSEGNA_REGIONI',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' merge su '||SQL%ROWCOUNT||'posizioni','END');
    COMMIT;

    EXCEPTION WHEN OTHERS THEN
    PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.ETL_ASSEGNA_REGIONI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Errore assegnazione regioni');
    ROLLBACK;
    END;


    ELSE NULL;
    END IF;

  END ASSEGNA_REGIONI;

--appittisce i gruppi super
PROCEDURE SPALMA_GRUPPI
AS
  FLAG NUMBER(1);

  BEGIN

  SELECT VALORE_COSTANTE INTO FLAG
  FROM T_MCRE0_WRK_CONFIGURAZIONE
  WHERE NOME_COSTANTE = 'FLG_SPALMA_RECORD';

      IF (FLAG =1)
      THEN
      begin

MERGE /*+no_parallel(fg)*/
--INTO MCRE_OWN.T_MCRE0_APP_ALL_DATA FG swirch 10/2
INTO MCRE_OWN.T_MCRE0_APP_ALL_DATA_OLD FG
   USING (SELECT *
   from
    (
    SELECT           DISTINCT    (COD_GRUPPO_SUPER),
                                  ID_UTENTE ,
                                  DTA_UTENTE_ASSEGNATO,
                                  COD_COMPARTO_ASSEGNATO,
                                  MIN_DTA_UTENTE_ASSEGNATO,
                                  MIN_COD_COMPARTO_ASSEGNATO,
                                 -- MIN_COD_SERVIZIO,
                                 -- MIN_COD_RAMO,
                                  MIN_ID_UTENTE_1,
/* AGGIUNTA IO */                 MIN_ID_UTENTE,
/* AGGIUNTA IO */                 MAX_ID_UTENTE,
/* AGGIUNTA IO */                 ID_UTENTE_DATA_MIN,
                                  NUM_UTENTI_1,
                                  NUM_COMP_ASSEGNATI_1,
                                  NUM_SERVIZI_1,
                                  NUM_RAMI_1,
                                  MIN_ID_UTENTE_CON_DATA,
                                  MIN_ID_UTENTE_CON_COMPARTO,
                                  CASE
                                     WHEN NUM_UTENTI_1 > 1
                                     AND MIN_DTA_UTENTE_ASSEGNATO IS NOT NULL
                                     AND NUM_COMP_ASSEGNATI_1 = 1
                                        THEN CASE
                                               WHEN DTA_UTENTE_ASSEGNATO =
                                                      MIN_DTA_UTENTE_ASSEGNATO
                                               AND ID_UTENTE = ID_UTENTE_DATA_MIN
                                                 THEN 1
                                               ELSE 0
                                            END
                                     WHEN NUM_UTENTI_1 > 1
                                     AND MIN_DTA_UTENTE_ASSEGNATO IS NULL
                                     AND NUM_COMP_ASSEGNATI_1 = 1
                                        THEN CASE
                                               WHEN ID_UTENTE =
                                                      MIN_ID_UTENTE_CON_COMPARTO
                                               AND COD_COMPARTO_ASSEGNATO =
                                                      MIN_COD_COMPARTO_ASSEGNATO
                                                  THEN 1
                                               ELSE 0
                                            END
                                     WHEN NUM_UTENTI_1 > 1
                                     AND MIN_DTA_UTENTE_ASSEGNATO IS NOT NULL
                                     AND NUM_COMP_ASSEGNATI_1 > 1
                                        THEN CASE
                                        WHEN ID_UTENTE =  MIN_ID_UTENTE
                                            AND DTA_UTENTE_ASSEGNATO =
                                                      MIN_DTA_UTENTE_ASSEGNATO
                                                  THEN DECODE
                                                         (COD_COMPARTO_ASSEGNATO,(SELECT U.COD_COMPARTO_UTENTE
                                                                                  FROM T_MCRE0_APP_UTENTI U
                                                                                  WHERE U.ID_UTENTE =
                                                                                  MIN_ID_UTENTE_CON_COMPARTO),1,0)
                                                       ---comparto dell'utente
                                               ELSE 0
                                            END
                                     WHEN NUM_UTENTI_1 > 1
                                     AND MIN_DTA_UTENTE_ASSEGNATO IS NULL
                                     AND NUM_COMP_ASSEGNATI_1 > 1
                                        THEN CASE
                                               WHEN ID_UTENTE =
                                                      MIN_ID_UTENTE_CON_COMPARTO
                                                  THEN DECODE
                                                         (COD_COMPARTO_ASSEGNATO,
                                                          (SELECT U.COD_COMPARTO_UTENTE
                                                             FROM T_MCRE0_APP_UTENTI U
                                                            WHERE U.ID_UTENTE =
                                                                     MIN_ID_UTENTE_CON_COMPARTO), 1,
                                                          0
                                                         )
                                                       ---comparto dell'utente
                                               ELSE 0
                                            END
                                     WHEN NUM_UTENTI_1 = 1
                                     AND MIN_ID_UTENTE_1 != -1
                                     AND NUM_COMP_ASSEGNATI_1 > 1
                                        THEN DECODE
                                               (COD_COMPARTO_ASSEGNATO,
                                                (SELECT U.COD_COMPARTO_UTENTE
                                                   FROM T_MCRE0_APP_UTENTI U
                                                  WHERE U.ID_UTENTE =
                                                                 MIN_ID_UTENTE), 1,
                                                0
                                               )       ---comparto dell'utente
                                     WHEN NUM_UTENTI_1 = 1
                                     AND MIN_ID_UTENTE_1 = -1
                                     AND NUM_COMP_ASSEGNATI_1 > 1
                                        THEN DECODE
                                               (COD_RAMO,
                                                MIN_COD_RAMO_CON_COMPARTO, DECODE
                                                      (COD_COMPARTO_ASSEGNATO,
                                                       NULL, 0,
                                                       1
                                                      ),
                                                0
                                               )
                                     ELSE 0
                                  END FLG_RIGA_GIUSTA
                             FROM (SELECT /*+index(t IDX_MCRE0_APP_FILE_GUIDA_FA)*/
                                          COD_GRUPPO_SUPER,ID_UTENTE,
                                          DTA_UTENTE_ASSEGNATO,
                                          COD_COMPARTO_ASSEGNATO,
                                          COD_SERVIZIO,
                                          COD_RAMO_CALCOLATO COD_RAMO,
                                          MIN
                                             (DTA_UTENTE_ASSEGNATO
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                     MIN_DTA_UTENTE_ASSEGNATO,
                                          MIN
                                             (NVL (COD_COMPARTO_ASSEGNATO, -1)
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                 MIN_COD_COMPARTO_ASSEGNATO_1,
                                          MIN
                                             (NVL (COD_SERVIZIO, -1)
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                           MIN_COD_SERVIZIO_1,
                                          MIN
                                             (NVL (COD_RAMO_CALCOLATO, -1)
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                               MIN_COD_RAMO_1,
                                          MIN
                                              (ID_UTENTE)
                                              OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                              MIN_ID_UTENTE_1,
/* AGGIUNTA IO */                         MAX
                                              (ID_UTENTE)
                                              OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                              MAX_ID_UTENTE,

                                          MIN
                                             (COD_COMPARTO_ASSEGNATO
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                   MIN_COD_COMPARTO_ASSEGNATO,
                                          MIN (COD_SERVIZIO) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                             MIN_COD_SERVIZIO,
                                          MIN
                                             (COD_RAMO_CALCOLATO) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                                 MIN_COD_RAMO,
                                          MIN (NULLIF(ID_UTENTE,-1)) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                                 MIN_ID_UTENTE,

                                          MIN
                                             (DECODE (DTA_UTENTE_ASSEGNATO,
                                                      NULL, to_number(NULL),
                                                      ID_UTENTE
                                                     )
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                       MIN_ID_UTENTE_CON_DATA,
/* AGGIUNTA IO */                         FIRST_VALUE (ID_UTENTE
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER
                                                     ORDER BY DTA_UTENTE_ASSEGNATO)
                                                       ID_UTENTE_DATA_MIN,
                                          MIN
                                             (DECODE (COD_COMPARTO_ASSEGNATO,
                                                      NULL, to_number(NULL),
                                                      ID_UTENTE
                                                     )
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                   MIN_ID_UTENTE_CON_COMPARTO,
                                          MIN
                                             (DECODE (COD_COMPARTO_ASSEGNATO,
                                                      NULL, NULL,
                                                      DTA_UTENTE_ASSEGNATO
                                                     )
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                  MIN_DTA_UTENTE_CON_COMPARTO,
                                          MIN
                                             (DECODE (COD_COMPARTO_ASSEGNATO,
                                                      NULL, NULL,
                                                      COD_RAMO_CALCOLATO
                                                     )
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                    MIN_COD_RAMO_CON_COMPARTO,
                                          COUNT
                                             (DISTINCT NVL
                                                      (COD_COMPARTO_ASSEGNATO,
                                                       -1
                                                      )
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                         NUM_COMP_ASSEGNATI_1,
                                          COUNT
                                             (DISTINCT NVL (COD_SERVIZIO, -1)
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                                NUM_SERVIZI_1,
                                          COUNT
                                             (DISTINCT NVL
                                                          (COD_RAMO_CALCOLATO,
                                                           -1
                                                          )
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                                   NUM_RAMI_1,
                                          COUNT
                                             (DISTINCT NVL (ID_UTENTE, -1)
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                                 NUM_UTENTI_1,
                                          COUNT
                                             (DISTINCT COD_COMPARTO_ASSEGNATO
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                           NUM_COMP_ASSEGNATI,
                                          COUNT
                                             (DISTINCT COD_SERVIZIO
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                                  NUM_SERVIZI,
                                          COUNT
                                             (DISTINCT COD_RAMO_CALCOLATO
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                                     NUM_RAMI,
                                          COUNT
                                               (DISTINCT ID_UTENTE
                                               ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                                   NUM_UTENTI,
                                          COUNT
                                             (DISTINCT DTA_UTENTE_ASSEGNATO
                                             ) OVER (PARTITION BY COD_GRUPPO_SUPER)
                                                     NUM_DTA_UTENTE_ASSEGNATO
                                     --FROM T_MCRE0_APP_ALL_DATA T switch 10/2
                                     FROM T_MCRE0_APP_ALL_DATA_OLD T
                                    WHERE COD_GRUPPO_SUPER IN (
                                             SELECT  COD_GRUPPO_SUPER
                                               -- FROM MCRE_OWN.T_MCRE0_APP_ALL_DATA TT switch 10/2
                                                FROM MCRE_OWN.T_MCRE0_APP_ALL_DATA_OLD TT
                                                WHERE TT.COD_GRUPPO_SUPER IS NOT NULL
                                                AND TT.FLG_ACTIVE = '1'
                                                AND MCRE_OWN.FNC_MCREI_IS_NUMERIC (COD_GRUPPO_SUPER) =1
                                                GROUP BY COD_GRUPPO_SUPER
                                      HAVING COUNT (distinct (ID_UTENTE)) > 1)
                                      AND T.COD_GRUPPO_SUPER IS NOT NULL
                                      AND T.FLG_ACTIVE = '1'
                                      )
                                      WHERE NUM_UTENTI_1 > 1 OR NUM_COMP_ASSEGNATI_1 > 1
                                      )
                              WHERE FLG_RIGA_GIUSTA = 1) CALC
   ON (FG.COD_GRUPPO_SUPER = CALC.COD_GRUPPO_SUPER AND FG.FLG_ACTIVE = '1')
                                                                       --14.02
   WHEN MATCHED THEN
      UPDATE
         SET FG.ID_UTENTE = CALC.ID_UTENTE,
             FG.DTA_UTENTE_ASSEGNATO = CALC.DTA_UTENTE_ASSEGNATO,
             FG.COD_COMPARTO_ASSEGNATO = CALC.COD_COMPARTO_ASSEGNATO
             ;

       PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.ETL_SPALMA_GRUPPI',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' merge su '||SQL%ROWCOUNT||'posizioni','END');
       COMMIT;

      EXCEPTION WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.ETL_SPALMA_GRUPPI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Errore spalma gruppi');
      ROLLBACK;
      END;

    ELSE NULL;
    END IF;

END SPALMA_GRUPPI;

END PKG_MCRE0_GESTIONE_ALL_DATA;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_GESTIONE_ALL_DATA FOR MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_GESTIONE_ALL_DATA FOR MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA TO MCRE_USR;

