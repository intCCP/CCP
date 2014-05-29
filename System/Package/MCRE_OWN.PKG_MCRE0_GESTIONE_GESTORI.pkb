CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_GESTIONE_GESTORI AS
/******************************************************************************
    NAME:       PKG_MCRE0_GESTIONE_GESTORI
    PURPOSE:
    REVISIONS:
    Ver        Date        Author           Description
    ---------  ----------  ---------------  ------------------------------------
    1.0        25/10/2013  T.Bernardi        Created this package.
    
 ******************************************************************************/
 
--select *
--from t_mcre0_wrk_audit_applicativo
--order by dta_ins desc;

--select *
--from t_mcre0_wrk_audit_etl
--order by dta_ins desc;
 
 PROCEDURE STORICIZZA_GEST_ONLINE(P_ABI IN VARCHAR2,
                                  P_NDG IN VARCHAR2,
                                  P_UTENTE  VARCHAR2 DEFAULT NULL
                                   ) IS
                                   

  BEGIN
  
  UPDATE T_MCRE0_APP_STORICO_GESTORI SET  DTA_FINE_VALIDITA = TRUNC(SYSDATE),
                                          FLG_ATTIVO = '0'
  WHERE COD_ABI_CARTOLARIZZATO = P_ABI
  AND   COD_NDG = P_NDG
  AND   FLG_ATTIVO = '1'
  ;
  
  PKG_MCRE0_AUDIT.LOG_APP(C_PACKAGE||'.STORICIZZA_GEST_ONLINE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' update sulla posizione con ABI: '||P_ABI||' e NDG: '||P_NDG,'END',P_UTENTE);
                                          
  INSERT INTO T_MCRE0_APP_STORICO_GESTORI SELECT 
                                                COD_ABI_CARTOLARIZZATO,
                                                COD_NDG, 
                                                nvl(trunc(DTA_UTENTE_ASSEGNATO),trunc(sysdate)) as DTA_INI_UTENTE,   --DTA_INI_UTENTE        
                                                NULL as DTA_FINE_VALIDITA,                   --DTA_FINE_VALIDITA      
                                                NULLIF (ID_UTENTE, -1) as ID_UTENTE, --ID_UTENTE    
                                                NULL as UTENTE,                  --UTENTE 
                                                COD_STATO , 
                                                COD_COMPARTO_CALCOLATO as , --COD_STRUTTURA_COMPETENTE  
                                                '1' as FLG_ATTIVO,                     --FLG_ATTIVO
                                                'V' as FLG_PROV
                                                FROM T_MCRE0_APP_ALL_DATA 
                                                WHERE COD_ABI_CARTOLARIZZATO = P_ABI
                                                AND COD_NDG = P_NDG
                                                ;
  
  
   PKG_MCRE0_AUDIT.LOG_APP(C_PACKAGE||'.STORICIZZA_GEST_ONLINE',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' insert sulla posizione con ABI: '||P_ABI||' e NDG: '||P_NDG,'END',P_UTENTE);
  
  
      EXCEPTION WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_APP(C_PACKAGE||'.STORICIZZA_GEST_ONLINE',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ERRORE NELLA STORICIZZA_GEST_ONLINE CON ABI: '||P_ABI||' e NDG: '||P_NDG,P_UTENTE);
      ROLLBACK;
        
  COMMIT;
  
  END STORICIZZA_GEST_ONLINE;
   
 
  PROCEDURE STORICIZZA_GESTORI
  IS
  
  BEGIN
   
   
  INSERT INTO TEMP_STORICO_GESTORI SELECT 
                                        COD_ABI_CARTOLARIZZATO,
                                        COD_NDG,      
                                        nullif(ID_UTENTE,-1),                                                          
                                        NVL(COD_COMPARTO_ASSEGNATO,COD_COMPARTO_CALCOLATO)  as cod_comparto            
                                        FROM T_MCRE0_APP_ALL_DATA 
                                        where today_flg = '1'
                                        MINUS
                                        SELECT 
                                        COD_ABI_CARTOLARIZZATO,
                                        COD_NDG, 
                                        ID_UTENTE,                                                          
                                        COD_STRUTTURA_COMPETENTE                                        
                                        FROM T_MCRE0_APP_STORICO_GESTORI 
                                        WHERE FLG_ATTIVO ='1'
                                        ;
  
  
  UPDATE T_MCRE0_APP_STORICO_GESTORI SET DTA_FINE_VALIDITA = TRUNC(SYSDATE),
                                         FLG_ATTIVO = '0'
  WHERE (COD_ABI_CARTOLARIZZATO, COD_NDG ) IN (SELECT COD_ABI_CARTOLARIZZATO,COD_NDG FROM TEMP_STORICO_GESTORI)
  AND FLG_ATTIVO = '1'
  ;
 
 PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.STORICIZZA_GESTORI',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' update su '||SQL%ROWCOUNT||' posizioni','END'); 
  
  INSERT /*+ append */ INTO T_MCRE0_APP_STORICO_GESTORI SELECT 
                                                              A.COD_ABI_CARTOLARIZZATO,
                                                              A.COD_NDG, 
                                                              nvl(TRUNC(A.DTA_UTENTE_ASSEGNATO),trunc(SYSDATE)), 
                                                              null,
                                                              A.ID_UTENTE,  
                                                              null,
                                                              A.COD_STATO , 
                                                              NVL(A.COD_COMPARTO_ASSEGNATO,A.COD_COMPARTO_CALCOLATO),
                                                              '1',
                                                              'V' as FLG_PROV
                                                              FROM T_MCRE0_APP_ALL_DATA A ,TEMP_STORICO_GESTORI P
                                                              WHERE A.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO
                                                              AND A.COD_NDG = P.COD_NDG
                                                              ;
  
  PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.STORICIZZA_GESTORI',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' insert su '||SQL%ROWCOUNT||' posizioni','END');
  
  
      EXCEPTION WHEN OTHERS THEN
      PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.STORICIZZA_GESTORI',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ERRORE NELLA STORICIZZA_GESTORI');
      ROLLBACK;
        
  COMMIT;
  
   
  END STORICIZZA_GESTORI;

  FUNCTION  GEST_GEST  RETURN NUMBER
  IS
  
  V_COUNT INTEGER;
  
  BEGIN
  
  SELECT count(DISTINCT U.ID_UTENTE) INTO V_COUNT
      FROM T_MCRE0_APP_UTENTI U,T_MCRE0_APP_ALL_DATA A
      WHERE  A.ID_UTENTE = U.ID_UTENTE
      AND NVL(U.COD_VARIAZIONE_GESTORE,'-') IN ('MD_SPT','MD_CMP') ;
  
  IF ( V_COUNT = 0)
      THEN 
        UPDATE T_MCRE0_APP_UTENTI SET COD_VARIAZIONE_GESTORE = NULL 
        WHERE COD_VARIAZIONE_GESTORE IN ('MD_SPT','MD_CMP');
  end if ;   
 
 IF(SQL%ROWCOUNT <> 0) then
 PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.GEST_GEST',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' sbiancate '||SQL%ROWCOUNT||' posizioni','END');
 end if;
 
--legenda campo cod_variazione_gestore:
--MD_CMP utente con modifica a comparto ma con posizioni su all_data
--INS nuovo utente
--UPD utente modificato
--MD_SPT utente che va spento ma ha posizioni assegnate su all_data
--SPT utente spento


--segno gli utenti da modificare ma che hanno posizioni sull'all_data
UPDATE T_MCRE0_APP_UTENTI U
SET COD_VARIAZIONE_GESTORE = 'MD_CMP'
WHERE U.ID_UTENTE IN
                      (
SELECT DISTINCT A.ID_UTENTE
                          from t_mcre0_app_all_Data a,(SELECT DECODE(lpad(U.ID_UTENTE,6,0),NULL,SUBSTR(G.USER_ID,2),lpad(U.ID_UTENTE,6,0)) AS ID_UTENTE
                                                        FROM FL_MCRE0_ANAGRAFICA_GESTORI G, T_MCRE0_APP_COMPARTI C, T_MCRE0_APP_UTENTI U
                                                        WHERE G.uo_ass = C.COD_COMPARTO
                                                          AND C.FLG_CHK = '1'
                                                          AND G.UO_ASS != U.COD_COMPARTO_UTENTE 
                                                          AND G.USER_ID  = U.COD_MATRICOLA
                                                          and nvl(U.COD_VARIAZIONE_GESTORE,'-') <>'MD_CMP'
                                                      ) P
                      WHERE A.ID_UTENTE = P.ID_UTENTE)
;       
IF(SQL%ROWCOUNT <> 0) THEN
 PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.GEST_GEST',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' utenti da modificare con posizioni associate: '||SQL%ROWCOUNT,'END');
 end if;

--------------

--segno gli utenti da spegnere ma che hanno posizioni sull'all_Data
UPDATE T_MCRE0_APP_UTENTI U
SET COD_VARIAZIONE_GESTORE = 'MD_SPT'
WHERE U.ID_UTENTE IN
                      (
                        SELECT DISTINCT A.ID_UTENTE
                            FROM T_MCRE0_APP_ALL_DATA A,
                            (
                            SELECT DISTINCT A.USER_ID AS COD_MATRICOLA, 
                            CASE WHEN REGEXP_LIKE(SUBSTR(a.USER_ID,2), '^[0-9]+$') 
                                  THEN SUBSTR(a.USER_ID,2)
                                ELSE 
                                  NULL
                                END ID_UTENTE
                            FROM FL_MCRE0_ANAGRAFICA_GESTORI A
                            minus
                            SELECT U.COD_MATRICOLA,
                            SUBSTR(u.COD_MATRICOLA,2) as id_utente
                            FROM T_MCRE0_APP_UTENTI U
                            WHERE U.FLG_GESTORE_ABILITATO ='1'
                            AND U.COD_MATRICOLA NOT LIKE ('GAW%')
                            AND U.COD_MATRICOLA NOT LIKE ('U0000%')
                            AND U.COD_MATRICOLA NOT LIKE ('U999%')
                            AND U.COD_MATRICOLA NOT LIKE ('U0G%')
                            and nvl(U.COD_VARIAZIONE_GESTORE,'-') <>'MD_SPT'
                            )P
WHERE A.ID_UTENTE = P.ID_UTENTE
)
;
IF(SQL%ROWCOUNT <> 0) THEN
 PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.GEST_GEST',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' utenti da spegnere con posizioni associate: '||SQL%ROWCOUNT,'END');
 end if;

--------------

--spengo gli utenti
UPDATE MCRE_OWN.T_MCRE0_APP_UTENTI SET   FLG_GESTORE_ABILITATO = '0',
                                         COD_VARIAZIONE_GESTORE = 'SPT'
                                             WHERE COD_MATRICOLA IN (
                                                                  SELECT U.COD_MATRICOLA
                                                                  FROM T_MCRE0_APP_UTENTI U
                                                                  WHERE U.FLG_GESTORE_ABILITATO ='1'
                                                                  AND U.COD_MATRICOLA NOT LIKE ('GAW%')
                                                                  AND U.COD_MATRICOLA NOT LIKE ('U0000%')
                                                                  AND U.COD_MATRICOLA NOT LIKE ('U999%')
                                                                  AND U.COD_MATRICOLA NOT LIKE ('U0G%')
                                                                  AND nvl(U.COD_VARIAZIONE_GESTORE,'-') <>'MD_SPT'
                                                                  MINUS
                                                                  SELECT a.USER_ID as COD_MATRICOLA
                                                                  FROM FL_MCRE0_ANAGRAFICA_GESTORI A
                                                                     )
 ;
IF(SQL%ROWCOUNT <> 0) THEN
 PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.GEST_GEST',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' spenti '||SQL%ROWCOUNT||' utenti','END');
 end if;
--------------


--inserisco i nuovi utentie modifico quelli esistenti
MERGE INTO T_MCRE0_APP_UTENTI TGT USING (
          SELECT P.*
     from t_mcre0_app_utenti x, (SELECT distinct G.USER_ID as COD_MATRICOLA,
                 DECODE(LPAD(U.ID_UTENTE,6,0),NULL,SUBSTR(G.USER_ID,2),LPAD(U.ID_UTENTE,6,0)) AS ID_UTENTE ,
                 TRIM(UPPER(G.COGNOME)) AS COGNOME,
                 TRIM(UPPER(G.NOME))AS NOME,
                 g.uo_Ass as COD_PUNTO_OPERATIVO
          FROM FL_MCRE0_ANAGRAFICA_GESTORI G
          , T_MCRE0_APP_COMPARTI C
          , T_MCRE0_APP_UTENTI U
          WHERE G.UO_ASS = C.COD_COMPARTO
            AND C.FLG_CHK = '1'
            AND G.UO_ASS != U.COD_COMPARTO_UTENTE(+)
            AND G.USER_ID = U.COD_MATRICOLA(+)
          )P
          WHERE X.COD_MATRICOLA(+) = P.COD_MATRICOLA
          AND NVL(X.COD_VARIAZIONE_GESTORE,'-') <>'MD_CMP'
            ) SRG
  ON(SRG.COD_MATRICOLA = TGT.COD_MATRICOLA )
  WHEN MATCHED THEN
    UPDATE SET           
              TGT.COD_COMPARTO_APPART    = SRG.COD_PUNTO_OPERATIVO,  
              TGT.COD_COMPARTO_ASSEGN    = SRG.COD_PUNTO_OPERATIVO,  
              TGT.FLG_GESTORE_ABILITATO  = '1',
              TGT.COD_COMPARTO_UTENTE    = SRG.COD_PUNTO_OPERATIVO,
              tgt.cod_variazione_gestore = 'UPD'--NULL
  WHEN NOT MATCHED THEN
    INSERT    (
              TGT.ID_UTENTE, 
              TGT.COD_MATRICOLA,           
              TGT.COD_FISCALE,            
              TGT.COGNOME,               
              TGT.NOME,                  
              TGT.COD_COMPARTO_APPART,     
              TGT.COD_COMPARTO_ASSEGN,     
              TGT.ID_REFERENTE,                 
              TGT.DATA_ASSEGNAZIONE_REF,          
              TGT.FLG_GESTORE_ABILITATO,   
              TGT.COD_PRIV,             
              TGT.COD_COMPARTO_UTENTE,   
              TGT.FLG_REFERENTE,
              TGT.COD_VARIAZIONE_GESTORE
              )
              VALUES
              (
              SRG.ID_UTENTE, 
              SRG.COD_MATRICOLA,           
              'AUTO',                   --COD_FISCALE      
              SRG.COGNOME,               
              SRG.NOME,                  
              SRG.COD_PUNTO_OPERATIVO,     
              SRG.COD_PUNTO_OPERATIVO,     
              NULL,                   --ID_REFERENTE         
              NULL,                   --DATA_ASSEGNAZIONE_REF
              '1',                    --FLG_GESTORE_ABILITATO
              NULL,                   --COD_PRIV        
              SRG.COD_PUNTO_OPERATIVO,   
              NULL,
              'INS'                   --NULL cod_variazione_gestore
              )
;
IF(SQL%ROWCOUNT <> 0) THEN
 PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.GEST_GEST',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,' inseriti\modificati '||SQL%ROWCOUNT||' utenti','END');
 end if;

COMMIT;
    return ok;
    exception when others then 
    rollback;
    return ko;
    
 END GEST_GEST;
 
  PROCEDURE STORICIZZA_GESTORI_SO
  is
  
  cursor c_mod 
    is
      select 
                  p.cod_abi as COD_ABI_CARTOLARIZZATO,
                  p.cod_ndg,
                  p.dta_apertura as dta_ini_utente,
                  p.dta_chiusura as dta_fine_validita,
                  substr(p.cod_matr_pratica,2) as id_utente,
                  concat(concat(u.nome,' '),u.cognome) as utente,
                  (select d.cod_stato from t_mcre0_app_all_data d where d.cod_abi_cartolarizzato = p.cod_abi and d.cod_ndg = p.cod_ndg) as cod_stato,
                  p.cod_uo_pratica as cod_struttura_competente ,
                  p.flg_Attiva as flg_attivo,
                  p.id_dper
                  from t_mcres_st_pratiche p, t_mcres_app_utenti u
                  where p.id_dper = to_number(to_char(trunc(sysdate-1),'yyyymmdd')) 
                    and p.dta_chiusura between (sysdate-5) and (sysdate -1)
                    and p.cod_matr_pratica = u.cod_matricola
                    and p.flg_attiva ='0'
                    ;
                    
  r_mod c_mod%ROWTYPE;
  
  v_cod_comp  t_mcre0_app_storico_gestori.cod_struttura_competente%TYPE;
  v_cod_abi   t_mcre0_app_storico_gestori.cod_abi_cartolarizzato%TYPE;
  v_dta_fn    t_mcre0_app_storico_gestori.dta_fine_validita%TYPE;
  v_utente    t_mcre0_app_storico_gestori.id_utente%TYPE;
  v_cod_ndg   t_mcre0_app_storico_gestori.cod_ndg%TYPE;
  
  insnew number;
  insmod number;
  updmod number;
  
  begin
  
  OPEN c_mod;
  
  
  LOOP
  
      FETCH c_mod into r_mod;
      EXIT WHEN c_mod%NOTFOUND;
  
        select cod_abi_cartolarizzato,cod_ndg,id_utente,cod_struttura_competente,dta_fine_validita
        into v_cod_abi,v_cod_ndg,v_utente,v_cod_comp,v_dta_fn
        from t_mcre0_app_storico_gestori ;
        
        --il record non esite.
        IF (v_cod_abi!= r_mod.cod_abi_cartolarizzato and v_cod_ndg != r_mod.cod_ndg)
           THEN
           INSERT INTO t_mcre0_app_storico_gestori
                  VALUES
                        (
                        r_mod.COD_ABI_CARTOLARIZZATO, 
                        r_mod.COD_NDG, 
                        r_mod.DTA_INI_UTENTE, 
                        r_mod.DTA_FINE_VALIDITA, 
                        r_mod.ID_UTENTE, 
                        r_mod.UTENTE, 
                        r_mod.COD_STATO, 
                        r_mod.COD_STRUTTURA_COMPETENTE,
                        r_mod.FLG_ATTIVO,
                        'V'
                        );
        
        insnew := SQL%ROWCOUNT;
        --end if;
        
        --il record esiste ma cambia id_utente o comparto
        --quindi lo reinserisco.
        ELSIF(v_cod_abi = r_mod.cod_abi_cartolarizzato and v_cod_ndg = r_mod.cod_ndg 
              AND(r_mod.id_utente != v_utente or r_mod.COD_STRUTTURA_COMPETENTE != v_cod_comp))
          THEN
          INSERT INTO t_mcre0_app_storico_gestori
                  VALUES
                        (
                        r_mod.COD_ABI_CARTOLARIZZATO, 
                        r_mod.COD_NDG, 
                        r_mod.DTA_INI_UTENTE, 
                        r_mod.DTA_FINE_VALIDITA, 
                        r_mod.ID_UTENTE, 
                        r_mod.UTENTE, 
                        r_mod.COD_STATO, 
                        r_mod.COD_STRUTTURA_COMPETENTE,
                        r_mod.FLG_ATTIVO,
                        'V'
                        );
                        
        insmod := SQL%ROWCOUNT;
        --end if;
        
        --il record viene chiuso.
        ELSIF(v_cod_abi = r_mod.cod_abi_cartolarizzato and v_cod_ndg = r_mod.cod_ndg 
              AND v_dta_fn != r_mod.DTA_FINE_VALIDITA)
          THEN
          UPDATE t_mcre0_app_storico_gestori
                SET
                  DTA_FINE_VALIDITA = r_mod.DTA_FINE_VALIDITA,
                  FLG_ATTIVO = r_mod.FLG_ATTIVO
                  ;
                  
        updmod := SQL%ROWCOUNT; 
                  
         end if;
         
  end loop;
  
  IF(insnew <> 0 or insmod <> 0 or updmod <>0) THEN
  PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.STORICIZZA_GESTORI_SO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,'Inseriti '||insnew|| ' nuovi record,sono state aggiornate con un nuovo record '||insmod|| ' posizioni e chiuse '||updmod|| ' posizioni','END');
  else 
  PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.STORICIZZA_GESTORI_SO',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,'zero record modificati/inseriti','END');
  end if;
 
  CLOSE c_mod;
  
    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.LOG_ETL(C_PACKAGE||'.STORICIZZA_GESTORI_SO',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'ERRORE NELLA STORICIZZA_GESTORI_SO',NULL);
        ROLLBACK;
    COMMIT;
    
  
  end STORICIZZA_GESTORI_SO;
   
  FUNCTION IMPORTA_GESTORI RETURN NUMBER
  IS
  
  BEGIN
  
    EXECUTE IMMEDIATE 'TRUNCATE TABLE FL_MCRE0_ANAGRAFICA_GESTORI';


    INSERT into FL_MCRE0_ANAGRAFICA_GESTORI  
    select 
    USER_ID     , 
    substr( NOME||',', 1, instr(NOME,',')-1 ) as NOME,
    replace(substr( NOME||',,', instr( NOME||',,', ',') +1, 
    instr( NOME||',,', ',', 1, 2 )-instr(NOME||',,',',')-1 ), CHR(10),'F') as COGNOME,
    --COGNOME            , 
    CLONE_UOASS        ,  
    DESC_CLONE_UOASS   , 
    UO_ASS             , 
    DESCR_UO           , 
    FIGURA_PROFESS     ,  
    PROFILO            ,  
    DESC_PROFILO       ,
    ABILITAZIONE       ,  
    DESC_ABILITAZIONE  ,
    CLONE_UOABIL       , 
    DESC_CLONE_UOABIL  ,
    UO_ABIL            , 
    UO_DESCR_ABIL      , 
    CODICE_FISCALE     
    FROM TE_MCRE0_ANAGRAFICA_GESTORI;

    COMMIT;
    return ok;
    exception when others then 
    rollback;
    return ko;
       
  END IMPORTA_GESTORI;
  
END PKG_MCRE0_GESTIONE_GESTORI;
/


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GESTIONE_GESTORI TO MCRE_USR;

