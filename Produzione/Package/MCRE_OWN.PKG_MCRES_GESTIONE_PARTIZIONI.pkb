CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRES_GESTIONE_PARTIZIONI AS

/******************************************************************************
   NAME:       PKG_MCRES_GESTIONE_PARTIZIONI 
   PURPOSE:

   REVISIONS:
   Ver          Date            Author              Description
   ---------    ----------      -----------------   ------------------------------------
   1.0          04/07/2011      V.Galli             Created this package.
   1.1          15/10/2012      A.Galliano          Aggiunta funzione fnc_add_partition e fnc_truncate_partition
                                                    per tabelle partizionate by list
    1.2          07/01/2013     F. Galletti         Modificao il cursore nella funzione crea sottopartizione                                                  
******************************************************************************/

  function fnc_truncate_subpartition(
     p_tabella VARCHAR2, 
     P_PARTIZIONE VARCHAR2,
     P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) 
   RETURN NUMBER 
   is
     V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
   BEGIN
   
     V_SUFFIX_PARTITION := FNC_GET_SUFFIX_PARTITION(P_ID_FLUSSO);
     
     IF(FNC_ESISTE_SOTTOPARTIZIONE(P_TABELLA,V_SUFFIX_PARTITION||P_PARTIZIONE,P_ID_FLUSSO)=1)THEN
        EXECUTE IMMEDIATE 'ALTER TABLE '||P_TABELLA||' TRUNCATE SUBPARTITION '||V_SUFFIX_PARTITION||P_PARTIZIONE;
     END IF;
     return ok;
     
   EXCEPTION
       WHEN OTHERS THEN
         PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_ID_FLUSSO, C_PACKAGE || '.fnc_truncate_subpartition', PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM, 'GENERALE'||p_tabella||' partizione='||V_SUFFIX_PARTITION||P_PARTIZIONE );
         RETURN KO;
   end fnc_truncate_subpartition;

  function fnc_truncate_partition(
     p_tabella VARCHAR2, 
     P_PARTIZIONE VARCHAR2,
     P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) 
   RETURN NUMBER 
   is
     V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
   BEGIN
   
     V_SUFFIX_PARTITION := FNC_GET_SUFFIX_PARTITION(P_ID_FLUSSO);
     
     if(FNC_ESISTE_PARTIZIONE(P_TABELLA,V_SUFFIX_PARTITION||P_PARTIZIONE,P_ID_FLUSSO)=1)then
        EXECUTE IMMEDIATE 'ALTER TABLE '||P_TABELLA||' TRUNCATE PARTITION '||V_SUFFIX_PARTITION||P_PARTIZIONE;
     END IF;
     return ok;
     
   EXCEPTION
       WHEN OTHERS THEN
         PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_ID_FLUSSO, C_PACKAGE || '.fnc_truncate_partition', PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM, 'GENERALE - '||p_tabella||' partizione='||V_SUFFIX_PARTITION||P_PARTIZIONE );
         return KO;
   end fnc_truncate_partition;

/*  function fnc_exchange_partition(
     P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) 
   RETURN NUMBER 
   is
     V_TAB_TMP T_MCRES_WRK_ACQUISIZIONE.VAL_TAB_TMP%TYPE; 
     V_TAB_APP T_MCRES_WRK_ACQUISIZIONE.VAL_TAB_APP%TYPE;
     V_COD_ABI T_MCRES_WRK_ACQUISIZIONE.COD_ABI%TYPE;
     V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
   BEGIN
     BEGIN
       SELECT VAL_TAB_TMP, VAL_TAB_APP, COD_ABI
       into V_TAB_TMP, V_TAB_APP, V_COD_ABI
       FROM T_MCRES_WRK_ACQUISIZIONE
       WHERE ID_FLUSSO = P_ID_FLUSSO;
     EXCEPTION
       WHEN OTHERS THEN
         PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_ID_FLUSSO, C_PACKAGE || '.fnc_exchange_partition', PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM, 'ID_FLUSSO non censito' );
         return KO;
     END;
     
     V_SUFFIX_PARTITION := FNC_GET_SUFFIX_PARTITION(P_ID_FLUSSO);
     
     EXECUTE IMMEDIATE 'ALTER TABLE '||V_TAB_APP||' EXCHANGE PARTITION '||V_SUFFIX_PARTITION||V_COD_ABI||' WITH TABLE '||V_TAB_TMP||' INCLUDING INDEXES WITH VALIDATION';
     
     /*******
      ALTER TABLE <table_name> destination_table APP
      EXCHANGE PARTITION <partition_name>
      WITH TABLE <new_table_name> source_table TMP
      <including | excluding> INDEXES
      <with | without> VALIDATION
      EXCEPTIONS INTO <schema.table_name>;
    ****/
     
 /*  EXCEPTION
       WHEN OTHERS THEN
         PKG_MCRES_AUDIT.LOG_CARICAMENTI(P_ID_FLUSSO, C_PACKAGE || '.fnc_exchange_partition', PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM, 'GENERALE' );
         RETURN KO;
   end fnc_exchange_partition;*/

  function FNC_SET_SUBPART_TEMPLATE(
     P_TABLE in varchar2,
     P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%type) 
   RETURN NUMBER 
   is
     V_STR varchar2(30000);
     V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
     V_default_partition T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
     V_ESITO NUMBER:=ok;
        
    CURSOR C_PART_LIST IS
      select COD_ABI
      FROM T_MCREs_APP_ISTITUTI;
   
   begin
    V_SUFFIX_PARTITION := FNC_GET_SUFFIX_PARTITION(P_ID_FLUSSO);
    V_default_partition := fnc_get_default_partition(p_id_flusso);
    
    V_STR := V_STR || ' alter table '|| P_TABLE ||' set subpartition template (';
    for REC_PART_LIST in C_PART_LIST LOOP
     V_STR := V_STR || ' SUBPARTITION '|| V_SUFFIX_PARTITION||REC_PART_LIST.COD_ABI ||' VALUES (''' || REC_PART_LIST.COD_ABI ||'''), ';
    end LOOP;
    V_STR := V_STR || ' SUBPARTITION '|| V_default_partition ||' VALUES ( DEFAULT ) ';
    V_STR := V_STR || ' ) ';
    
    execute immediate V_STR;
    
    return ok;
   
   EXCEPTION
      when OTHERS then
          PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_id_flusso, c_package || '.fnc_set_subpart_template', PKG_MCRES_AUDIT.C_ERROR,sqlcode,SQLERRM, 'TABLE='||p_table );
          return KO;
  END fnc_set_subpart_template;

   FUNCTION FNC_REBUILD_INDEXES(
     P_TABLE IN VARCHAR2,
     P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) 
   RETURN NUMBER 
   IS
   
      V_NOTE VARCHAR2(200);
      v_esiste number(1):=0;
      
      CURSOR cur_P IS
        SELECT 'ALTER INDEX ' || INDEX_NAME || ' REBUILD PARTITION ' || P.PARTITION_NAME COMMAND
        FROM ALL_INDEXES I, USER_TAB_PARTITIONS P
        WHERE I.OWNER = 'MCRE_OWN' 
        AND I.TABLE_NAME = P_TABLE
        AND I.TABLE_NAME = P.TABLE_NAME;
     
     CURSOR cur_sP IS   
        SELECT 'ALTER INDEX ' || INDEX_NAME || ' REBUILD SUBPARTITION ' || P.SUBPARTITION_NAME COMMAND
        FROM ALL_INDEXES I, USER_TAB_SUBPARTITIONS P
        WHERE I.OWNER = 'MCRE_OWN' 
        AND I.TABLE_NAME = P_TABLE
        AND I.TABLE_NAME = P.TABLE_NAME;
  BEGIN
  
      V_NOTE := 'Rebuild subpartition indexes';
      FOR REC IN CUR_SP LOOP
          EXECUTE IMMEDIATE REC.COMMAND;
          v_esiste:=1;
      END LOOP;
      
      if(v_esiste=0)then
        V_NOTE := 'Rebuild partition indexes';
        FOR rec IN cur_P LOOP
            EXECUTE IMMEDIATE rec.COMMAND;
        END LOOP;
      end if;
      
      RETURN ok;
  
  EXCEPTION
      WHEN OTHERS THEN
          PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_id_flusso, c_package || '.fnc_mcres_rebuild_indexes', PKG_MCRES_AUDIT.C_ERROR,sqlcode,SQLERRM, 'TABLE='||p_table||' - '||V_NOTE );
          RETURN ko;
  END FNC_rebuild_indexes;

  FUNCTION FNC_UPDATE_PARTITION_LIST(
    P_TABELLA VARCHAR2 DEFAULT NULL, 
    p_type_table varchar2 DEFAULT NULL,
    P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE)
  RETURN number
  
  IS
    V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
    V_ESITO NUMBER:=ok;
    
    CURSOR C_TAB_LIST IS
      select TABLE_NAME 
      FROM USER_TABLES U
      WHERE TABLE_NAME LIKE 'T_MCRES_'||upper(p_type_table)||'%'
      and TABLE_NAME = NVL(UPPER(P_TABELLA),TABLE_NAME)
      and exists (
        SELECT DISTINCT 1 
        from USER_TAB_PARTITIONS
        where TABLE_NAME = U.TABLE_NAME
        and PARTITION_NAME NOT in ('SOFF_PATTIVE','SOFF_PSTORICHE') );
        
    CURSOR C_NEW_PART_LIST(
      p_table USER_TABLES.TABLE_NAME%type,
      P_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE
    ) IS
      SELECT COD_ABI
      FROM T_MCRES_APP_ISTITUTI
      WHERE NOT EXISTS (
        SELECT 1 
        FROM USER_TAB_PARTITIONS
        WHERE TABLE_NAME = UPPER(p_table)
        and PARTITION_NAME =P_SUFFIX_PARTITION||COD_ABI);
BEGIN
    
    V_SUFFIX_PARTITION := FNC_GET_SUFFIX_PARTITION(p_id_flusso);
    
    FOR REC_TAB_LIST IN C_TAB_LIST LOOP
    
      FOR REC_NEW_PART_LIST IN C_NEW_PART_LIST(REC_TAB_LIST.table_name,V_SUFFIX_PARTITION) LOOP
        V_ESITO:=V_ESITO*PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_PARTIZIONE(REC_TAB_LIST.TABLE_NAME, REC_NEW_PART_LIST.COD_ABI,P_ID_FLUSSO) ;
        if(V_ESITO=0)then return V_ESITO; end if;
      end loop;
    
    end loop;

    RETURN V_ESITO;
    
EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_id_flusso,C_PACKAGE||'.fnc_update_partition_list',PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE');
    RETURN KO;
end FNC_UPDATE_PARTITION_LIST;  

  FUNCTION FNC_UPDATE_SUBPARTITION_LIST(
    P_TABELLA VARCHAR2 DEFAULT NULL, 
    p_type_table varchar2 DEFAULT NULL,
    P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE)
  RETURN number
  IS
    V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
    V_ESITO NUMBER:=ok;
    
    CURSOR C_TAB_LIST IS
      SELECT TABLE_NAME 
      FROM USER_TABLES 
      WHERE TABLE_NAME LIKE 'T_MCRES_'||upper(p_type_table)||'%'
      and TABLE_NAME = nvl(upper(p_tabella),TABLE_NAME);
      
    cursor C_PART_LIST is
      select COD_ABI
      from T_MCRES_APP_ISTITUTI;
    
BEGIN
    
    V_SUFFIX_PARTITION := FNC_GET_SUFFIX_PARTITION(p_id_flusso);
    
    FOR REC_TAB_LIST IN C_TAB_LIST LOOP
    
      V_ESITO:=V_ESITO*PKG_MCRES_GESTIONE_PARTIZIONI.FNC_SET_SUBPART_TEMPLATE(REC_TAB_LIST.TABLE_NAME, P_ID_FLUSSO) ;
      FOR REC_PART_LIST IN C_PART_LIST LOOP
        V_ESITO:=V_ESITO*PKG_MCRES_GESTIONE_PARTIZIONI.FNC_CREA_SOTTOPARTIZIONE(REC_TAB_LIST.TABLE_NAME,REC_PART_LIST.COD_ABI, P_ID_FLUSSO) ;
        if(V_ESITO=0)then return V_ESITO; end if;
      END LOOP;
      
    end loop;

    RETURN V_ESITO;
    
EXCEPTION
  when OTHERS then
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_id_flusso,C_PACKAGE||'.fnc_update_subpartition_list',PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE');
    return KO;
end FNC_UPDATE_SUBPARTITION_LIST;  
  

FUNCTION fnc_get_suffix_partition(
    P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE)
  RETURN T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type
  
IS
    V_costante T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
BEGIN

    SELECT VALORE_COSTANTE
    INTO V_costante
    FROM T_MCRES_WRK_CONFIGURAZIONE
    WHERE nome_costante = 'PARTITION_SUFFIX';

    RETURN V_costante;
    
EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_id_flusso,C_PACKAGE||'.fnc_get_suffix_partition',PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE');
    RETURN KO;
end fnc_get_suffix_partition;  

FUNCTION fnc_get_default_partition(
    P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE)
  RETURN T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type
  
IS
    V_costante T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
BEGIN

    SELECT VALORE_COSTANTE
    INTO V_costante
    FROM T_MCRES_WRK_CONFIGURAZIONE
    WHERE nome_costante = 'PARTITION_DEFAULT';

    RETURN V_costante;
    
EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_id_flusso,C_PACKAGE||'.fnc_get_default_partition',PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE');
    RETURN KO;
end fnc_get_default_partition;  

FUNCTION fnc_esiste_partizione(
  p_tabella VARCHAR2,
  P_PARTIZIONE VARCHAR2,
  P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) return number
IS
    v_exists NUMBER;
BEGIN

    SELECT decode(COUNT(*),0,0,1)
    INTO v_exists
    from USER_TAB_PARTITIONS
    WHERE TABLE_NAME = upper(p_tabella)
    AND PARTITION_NAME = p_partizione;

    RETURN V_EXISTS;
    
EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_id_flusso,C_PACKAGE||'.fnc_esiste_partizione',PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - TAB='||p_tabella||' - PART='||p_partizione);
    return ko;
end fnc_esiste_partizione;

FUNCTION fnc_esiste_sottopartizione(
  p_tabella VARCHAR2,
  P_PARTIZIONE VARCHAR2,
  P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) return number
IS
    v_exists NUMBER;
BEGIN

    SELECT decode(COUNT(*),0,0,1)
    INTO V_EXISTS
    from USER_TAB_SUBPARTITIONS
    WHERE TABLE_NAME = UPPER(P_TABELLA)
    AND SUBPARTITION_NAME = p_partizione;

    RETURN V_EXISTS;
    
EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_id_flusso,C_PACKAGE||'.fnc_esiste_partizione',PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - TAB='||p_tabella||' - PART='||p_partizione);
    RETURN KO;
end fnc_esiste_sottopartizione;

FUNCTION FNC_CREA_PARTIZIONE(
  p_tabella VARCHAR2, 
  p_partizione VARCHAR2,
  P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) RETURN NUMBER
IS
    V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
    V_DEFAULT_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
    V_EXISTS number;
    p_partizione_LIMITE NUMBER;
Begin
  SELECT decode(COUNT(*),0,0,1)
  INTO V_EXISTS
  from USER_TAB_SUBPARTITIONS
  Where Table_Name = Upper(P_Tabella);
  V_SUFFIX_PARTITION := FNC_GET_SUFFIX_PARTITION(p_id_flusso);
  V_Default_Partition := Fnc_Get_Default_Partition(P_Id_Flusso);
    WHILE TRUE LOOP
      BEGIN
        IF FNC_ESISTE_PARTIZIONE(P_TABELLA,V_SUFFIX_PARTITION||P_PARTIZIONE,P_ID_FLUSSO)=0 THEN
          IF(V_EXISTS=0)THEN
            IF( length(P_PARTIZIONE) = 6 and FNC_MCRES_IS_DATE(P_PARTIZIONE,'YYYYMM') = 1) THEN
              P_PARTIZIONE_LIMITE:=TO_NUMBER(P_PARTIZIONE+1);
              Execute Immediate 'ALTER TABLE '||P_Tabella||' SPLIT PARTITION '||V_Default_Partition||' at ('''||P_Partizione_Limite||''') INTO ( PARTITION '||V_Suffix_Partition||P_Partizione||',PARTITION '||V_Default_Partition||')';
            else
              EXECUTE IMMEDIATE 'ALTER TABLE '||P_TABELLA||' SPLIT PARTITION '||V_DEFAULT_PARTITION||' values ('''||P_PARTIZIONE||''') INTO ( PARTITION '||V_SUFFIX_PARTITION||P_PARTIZIONE||',PARTITION '||V_DEFAULT_PARTITION||')';
            end if;
          Else
            P_PARTIZIONE_LIMITE:=TO_NUMBER(P_PARTIZIONE+1);
            Execute Immediate 'ALTER TABLE '||P_Tabella||' SPLIT PARTITION '||V_Default_Partition||' at ('''||P_Partizione_Limite||''') INTO ( PARTITION '||V_Suffix_Partition||P_Partizione||',PARTITION '||V_Default_Partition||')';
          END IF;
          EXIT;
        ELSE 
          EXIT;
        END IF;
      exception
        WHEN IN_USE THEN 
          NULL;
      END;
      --DBMS_LOCK.SLEEP(0.01);
    End Loop;
  return ok;

EXCEPTION
  WHEN OTHERS THEN
    Pkg_Mcres_Audit.Log_Caricamenti(P_Id_Flusso,C_Package||'.fnc_crea_partizione',Pkg_Mcres_Audit.C_Error,Sqlcode,Sqlerrm,'GENERALE - TAB='||P_Tabella||' - PART='||V_Suffix_Partition||P_Partizione);
    Dbms_Output.Put_Line(SQLERRM);   
    return ko;
end FNC_CREA_PARTIZIONE;

FUNCTION FNC_CREA_SOTTOPARTIZIONE(
  p_tabella VARCHAR2, 
  p_partizione VARCHAR2,
  P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) RETURN NUMBER
IS
    V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
    V_default_partition T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
    
    CURSOR C_PART_LIST IS
      SELECT partition_name, high_value
      FROM USER_TAB_PARTITIONS
      WHERE TABLE_NAME = UPPER(P_TABELLA)
      AND PARTITION_NAME = p_partizione; 
BEGIN
 
  V_SUFFIX_PARTITION := FNC_GET_SUFFIX_PARTITION(p_id_flusso);
  V_DEFAULT_PARTITION := FNC_GET_DEFAULT_PARTITION(P_ID_FLUSSO);

  FOR REC_PART_LIST IN C_PART_LIST LOOP
    WHILE TRUE LOOP
      BEGIN
         IF FNC_ESISTE_SOTTOPARTIZIONE(P_TABELLA,REC_PART_LIST.PARTITION_NAME||'_'||P_PARTIZIONE,P_ID_FLUSSO)=0 THEN
           EXECUTE IMMEDIATE 'ALTER TABLE '||P_TABELLA||' SPLIT SUBPARTITION '||REC_PART_LIST.PARTITION_NAME||'_ALTRI values ('''||P_PARTIZIONE||''') INTO ( SUBPARTITION '||REC_PART_LIST.PARTITION_NAME||'_'||P_PARTIZIONE||', SUBPARTITION '||REC_PART_LIST.PARTITION_NAME||'_ALTRI)';
           EXIT;
         ELSE
           EXIT;
        end if;
      EXCEPTION
        WHEN IN_USE THEN 
          NULL;
      END;
    end loop;
  end loop;
  
  return ok;

EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_id_flusso,C_PACKAGE||'.fnc_crea_sottopartizione',PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - TAB='||p_tabella||' - SUBPART='||V_SUFFIX_PARTITION||p_partizione);
    RETURN KO;
end FNC_CREA_SOTTOPARTIZIONE;

FUNCTION FNC_ELIMINA_PARTIZIONE(
  p_tabella VARCHAR2,
  p_partizione VARCHAR2,
  P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) RETURN NUMBER
IS
   V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
begin
  
  V_SUFFIX_PARTITION := FNC_GET_SUFFIX_PARTITION(p_id_flusso);

  IF FNC_ESISTE_PARTIZIONE(P_TABELLA,V_SUFFIX_PARTITION||P_PARTIZIONE,p_id_flusso)=1 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_tabella||' DROP PARTITION '||V_SUFFIX_PARTITION||p_partizione;
  END IF;
  
  return ok;
  
EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_id_flusso,C_PACKAGE||'.fnc_elimina_partizione',PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - TAB='||p_tabella||' - PART='||p_partizione);
    return ko;
end FNC_ELIMINA_PARTIZIONE;

FUNCTION FNC_ELIMINA_SOTTOPARTIZIONE(
  p_tabella VARCHAR2,
  p_partizione VARCHAR2,
  P_ID_FLUSSO T_MCRES_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE) RETURN NUMBER
IS
   V_SUFFIX_PARTITION T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
BEGIN
  
  IF FNC_ESISTE_sottoPARTIZIONE(P_TABELLA,P_PARTIZIONE,P_ID_FLUSSO)=1 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_tabella||' DROP SUBPARTITION '||p_partizione;
  END IF;
  
  return ok;
  
EXCEPTION
  WHEN OTHERS THEN
    PKG_MCRES_AUDIT.LOG_CARICAMENTI(p_id_flusso,C_PACKAGE||'.fnc_elimina_sottopartizione',PKG_MCRES_AUDIT.C_ERROR,SQLCODE,SQLERRM,'GENERALE - TAB='||p_tabella||' - SUBPART='||p_partizione);
    RETURN KO;
end FNC_ELIMINA_SOTTOPARTIZIONE;




function fnc_add_partition
( 
    p_tabella       in varchar2,
    p_id_flusso     in number
)
return number is
/*

    Esegue add partion per tabelle st partizionale by list su id_dper
*/
    c_function constant varchar2(30)    := 'FNC_ADD_PARTITION';
    v_prefix            t_mcres_wrk_configurazione.valore_costante%type;
    v_partition_name    varchar2(30);
    v_note              t_mcres_wrk_audit_caricamenti.note%type;
    v_id_dper           varchar2(8);
    v_stmt              varchar2(32767);
    v_exists            number(1);
    

begin

    v_note  := 'Recupero prefisso nome partizione';
    
    select valore_costante
    into v_prefix
    from t_mcres_wrk_configurazione
    where nome_costante = 'PARTITION_SUFFIX';
    
    v_note  := 'Recupero id_dper da T_MCRES_WRK_ACQUISIZIONE';
    
    select to_char(id_dper, 'yyyymmdd')
    into v_id_dper
    from t_mcres_wrk_acquisizione
    where id_flusso = p_id_flusso;
    
    v_note  :=  'costruzione nome partizione';
    
    v_partition_name := v_prefix || v_id_dper;
    
    v_note  := 'Controllo esistenza partizione';
    
    select count(*)
    into v_exists
    from user_tab_partitions
    where table_name = p_tabella 
    and partition_name = v_partition_name;
    
    if v_exists = 1 
    then 
            
        pkg_mcres_audit.log_caricamenti(p_id_flusso, c_package || c_function, pkg_mcres_audit.c_error,sqlcode,sqlerrm, v_note || '- TABLE='||p_tabella);
                
        return ko;
        
    else 

        v_note  := 'Add partizione ' || v_partition_name;
                
        v_stmt    := 'alter table ' || p_tabella || ' add partition '|| v_partition_name || ' values( ' || v_id_dper || ')';
                
        execute immediate v_stmt;
        
        pkg_mcres_audit.log_caricamenti(p_id_flusso, c_package || c_function, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, v_note ); 
     
    end if;  
    
    return ok;

exception
when others then

    pkg_mcres_audit.log_caricamenti(p_id_flusso, c_package || c_function, pkg_mcres_audit.c_error, sqlcode, sqlerrm, v_note ); 
    
    return ko;

end;     



END PKG_MCRES_GESTIONE_PARTIZIONI;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_GESTIONE_PARTIZIONI FOR MCRE_OWN.PKG_MCRES_GESTIONE_PARTIZIONI;


CREATE SYNONYM MCRE_USR.PKG_MCRES_GESTIONE_PARTIZIONI FOR MCRE_OWN.PKG_MCRES_GESTIONE_PARTIZIONI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_GESTIONE_PARTIZIONI TO MCRE_USR;

