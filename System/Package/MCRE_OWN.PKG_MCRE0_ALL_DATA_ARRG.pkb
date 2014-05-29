CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_ALL_DATA_ARRG AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALL_DATA_ARRG1
   PURPOSE:    Simulazione caricamento dati sulla tabella "copia" T_MCRE0_APP_ALL_DATA_ARRG 
               con gruppo super per area e regione 

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/04/2013  1.I.Gueorguieva  Created this package.
   
   L'ordine delle azioni è il seguente, ciascuna può essere disabilitata 
   mediante T_MCRE0_WRK_FILEGUID_ARRG.FLG_ATTIVA, controllando 
   T_MCRE0_WRK_FILEGUID_ARRG.DESC_OPERAZIONE
   
   1) FNC_COPY_APP_FILE_GUIDA
   Copia in T_MCRE0_APP_FILE_GUIDA_ARRG i dati da T_MCRE0_APP_FILE_GUIDA,
   aggiorna il T_MCRE0_WRK_FILEGUID_ARRG.FLG_ATTIVA = 0, di regola viene
   eseguito una tantum
   
   2)FNC_ETL_RIBALTA_FILE_GUIDA
   Funzione analoga a PKG_MCRE0_GESTIONE_ALL_DATA.ETL_RESTORE_FILE_GUIDA.
   Alla prima esecuzione ribalta integralmente i dati dalla tabella T_MCRE0_APP_ALL_DATA.
   Successivamente distingue i casi.
   Se il comparto è di area o regione ribalta dalla T_MCRE0_APP_ALL_DATA_ARRG
   altrimenti ribalta da T_MCRE0_APP_ALL_DATA
   
   3) FNC_FILE_GUIDA_APP
   Simula il caricamento di primo livello del FILE GUIDA dalla ST alla APP,
   come nel package PKG_MCRE0_ALIMENTAZIONE
   
   4) FNC_UPDATE_FILE_GUIDA_PRE; FNC_UPDATE_FILE_GUIDA
   Simula il comportamento del package PKG_MCRE0_ESTENDI_FILE_GUIDA2
   usando T_MCRE0_APP_FILE_GUIDA_ARRG
   
   5) FNC_LOAD_ALL_DATA_ARRG
   LOAD SU T_MCRE0_APP_ALL_DATA_RG
   
   6) FNG_GRUPPO_UTENTE_COMPART
   MERGE AGGIUNTIVA GRUPPO E COMPARTO
******************************************************************************/

  FUNCTION FNC_COPY_APP_FILE_GUIDA RETURN NUMBER IS 
  P_ID_FLUSSO NUMBER:=9876;
  c_nome T_MCREI_WRK_AUDIT_CARICAMENTI.PROCEDURA%TYPE:='FNC_COPY_APP_FILE_GUIDA';
  CURSOR C_QRY IS 
  SELECT QRY
    FROM T_MCRE0_WRK_FILEGUID_ARRG
  WHERE ID_OPERAZIONE = 1
    AND FLG_ATTIVA = 1;
 
  BEGIN 
   FOR R_QRY IN C_QRY LOOP
    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_APP_FILE_GUIDA_ARRG REUSE STORAGE';
        EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    EXECUTE IMMEDIATE TO_CHAR(R_QRY.QRY);
    COMMIT;
  END LOOP;
  UPDATE T_MCRE0_WRK_FILEGUID_ARRG
  SET FLG_ATTIVA = 0
  WHERE ID_OPERAZIONE = 1;
  COMMIT;
  RETURN 1;
  EXCEPTION WHEN OTHERS THEN 
           ROLLBACK;
           pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'ERRORE FNC_COPY_APP_FILE_GUIDA'
                                         );
          RETURN 0;
  END ;
  
  -- INIT FLG_ATTIVA = 1 WHERE ID_OPERAZIONE = 2
  -- FLG_ATTIVA = WHERE ID_OPERAZIONE IN (3,4)
  -- (2,3,4) --> (1,0,0)
  -- A REGIME 
  -- (2,3,4) --> (0,1,1)
 FUNCTION FNC_ETL_RIBALTA_FILE_GUIDA RETURN NUMBER IS
  P_ID_FLUSSO NUMBER:=9876;
  c_nome T_MCREI_WRK_AUDIT_CARICAMENTI.PROCEDURA%TYPE:='FNC_ETL_RIBALTA_FILE_GUIDA';
  CURSOR C_QRY IS 
  SELECT QRY, ID_OPERAZIONE
    FROM T_MCRE0_WRK_FILEGUID_ARRG
  WHERE ID_OPERAZIONE IN (2,3,4)
    AND FLG_ATTIVA = 1
  ORDER BY ID_OPERAZIONE ASC;
 
  BEGIN 
   FOR R_QRY IN C_QRY LOOP
   IF R_QRY.ID_OPERAZIONE = 2 THEN 
           UPDATE T_MCRE0_WRK_FILEGUID_ARRG
             SET FLG_ATTIVA =  (CASE 
             WHEN ID_OPERAZIONE = 2 AND FLG_ATTIVA = 1
                THEN   0 
             WHEN ID_OPERAZIONE = 2 AND FLG_ATTIVA = 0
                THEN 0
              WHEN ID_OPERAZIONE IN (3,4) AND FLG_ATTIVA = 0 
                 THEN  1
              ELSE 0
              END)
        WHERE ID_OPERAZIONE IN (2,3,4);
    COMMIT;
   END IF;
       EXECUTE IMMEDIATE TO_CHAR(R_QRY.QRY);
    COMMIT;
  END LOOP;
  RETURN 1;
  EXCEPTION WHEN OTHERS THEN 
           ROLLBACK;
           pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'ERRORE FNC_ETL_RIBALTA_FILE_GUIDA'
                                         );
     RETURN 0;
  END ;

-- INIT FLG_ATTIVA = 1 WHERE ID_OPERAZIONE = 2
FUNCTION FNC_FILE_GUIDA_APP (p_partition number) RETURN NUMBER IS
  P_ID_FLUSSO NUMBER:=9876;
  c_nome T_MCREI_WRK_AUDIT_CARICAMENTI.PROCEDURA%TYPE:='FNC_FILE_GUIDA_APP';
  CURSOR C_QRY IS 
  SELECT QRY
    FROM T_MCRE0_WRK_FILEGUID_ARRG
  WHERE ID_OPERAZIONE  = 5
    AND FLG_ATTIVA = 1;
 
  BEGIN 
   FOR R_QRY IN C_QRY LOOP
    EXECUTE IMMEDIATE TO_CHAR(R_QRY.QRY) USING P_PARTITION;
    COMMIT;
  END LOOP;
  RETURN 1;
  EXCEPTION WHEN OTHERS THEN 
           ROLLBACK;
           pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'ERRORE FNC_FILE_GUIDA_APP'
                                         );
     RETURN 0;
  END ;
  
 FUNCTION  FNC_UPDATE_FILE_GUIDA_EXT RETURN NUMBER IS
  P_ID_FLUSSO NUMBER:=9876;
  c_nome T_MCREI_WRK_AUDIT_CARICAMENTI.PROCEDURA%TYPE:='FNC_UPDATE_FILE_GUIDA_EXT';
 RETVAL NUMBER;
  BEGIN 
  RetVal := MCRE_OWN.PKG_MCRE0_EST_FILE_GUIDA_ARRG.UPDATE_FILE_GUIDA_PRE ( 0 );
  RetVal := MCRE_OWN.PKG_MCRE0_EST_FILE_GUIDA_ARRG.UPDATE_FILE_GUIDA( 0 );
  COMMIT;
  RETURN 1;
  EXCEPTION WHEN OTHERS THEN 
           ROLLBACK;
           pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'ERRORE FNC_UPDATE_FILE_GUIDA_EXT'
                                         );
     RETURN 0;
  END ;
  
  FUNCTION FNC_LOAD_ALL_DATA_ARRG RETURN NUMBER IS 
  P_ID_FLUSSO NUMBER:=9876;
  c_nome T_MCREI_WRK_AUDIT_CARICAMENTI.PROCEDURA%TYPE:='FNC_LOAD_ALL_DATA_ARRG';
  CURSOR C_QRY IS 
  SELECT QRY
    FROM T_MCRE0_WRK_FILEGUID_ARRG
  WHERE ID_OPERAZIONE = 6
    AND FLG_ATTIVA = 1;
 
  BEGIN 
   FOR R_QRY IN C_QRY LOOP
    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_APP_ALL_DATA_ARRG REUSE STORAGE';
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    EXECUTE IMMEDIATE TO_CHAR(R_QRY.QRY);
    COMMIT;
  END LOOP;
  UPDATE T_MCRE0_WRK_FILEGUID_ARRG
  SET FLG_ATTIVA = 0
  WHERE ID_OPERAZIONE = 1;
  COMMIT;
  RETURN 1;
  EXCEPTION WHEN OTHERS THEN 
           ROLLBACK;
           pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'ERRORE FNC_LOAD_ALL_DATA_ARRG'
                                         );
          RETURN 0;
  END ;

-- MANCA LA QUERY
FUNCTION FNG_GRUPPO_UTENTE_COMPARTO RETURN NUMBER IS 
  P_ID_FLUSSO NUMBER:=9876;
  c_nome T_MCREI_WRK_AUDIT_CARICAMENTI.PROCEDURA%TYPE:='FNG_GRUPPO_UTENTE_COMPARTO';
  CURSOR C_QRY IS 
  SELECT QRY
    FROM T_MCRE0_WRK_FILEGUID_ARRG
  WHERE ID_OPERAZIONE = 7
    AND FLG_ATTIVA = 1;
 
  BEGIN 
   FOR R_QRY IN C_QRY LOOP
    EXECUTE IMMEDIATE TO_CHAR(R_QRY.QRY);
    COMMIT;
  END LOOP;
  UPDATE T_MCRE0_WRK_FILEGUID_ARRG
  SET FLG_ATTIVA = 0
  WHERE ID_OPERAZIONE = 1;
  COMMIT;
  RETURN 1;
  EXCEPTION WHEN OTHERS THEN 
           ROLLBACK;
           pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'ERRORE FNG_GRUPPO_UTENTE_COMPARTO'
                                         );
          RETURN 0;
  END ;
  
  PROCEDURE INIT_TAB_WRK
   IS
   BEGIN 
       UPDATE T_MCRE0_WRK_FILEGUID_ARRG
             SET FLG_ATTIVA =  (CASE 
             WHEN ID_OPERAZIONE = 1 
                THEN   1
             WHEN ID_OPERAZIONE = 2
                THEN 1
              WHEN ID_OPERAZIONE IN (3,4) AND FLG_ATTIVA = 0 
                 THEN  0
              ELSE 1
              END);
              COMMIT;
   END;
   
  PROCEDURE  ESTRAI_WRK_SU_STDOUT IS 
   CURSOR C
  IS SELECT ID_OPERAZIONE, DESC_OPERAZIONE, QRY, ID_DPER, FLG_ATTIVA 
  FROM T_MCRE0_WRK_FILEGUID_ARRG
  ORDER BY ID_OPERAZIONE;
  V_QRY CLOB;
  V_OUT_1 VARCHAR2(32767);
  
  BEGIN 
   FOR R IN C LOOP
   V_OUT_1:='
   DECLARE
    V_ID_OPERAZIONE NUMBER:='||R.ID_OPERAZIONE||';
    V_DESC_OPERAZIONE VARCHAR2(4000):='''||R.DESC_OPERAZIONE||''';
    V_QRY CLOB;
    V_ID_DPER NUMBER:='||NVL(R.ID_DPER,0)||';
    V_FLG_ATTIVA NUMBER:='||R.FLG_ATTIVA||';
    
    BEGIN
     V_QRY:='||''''||
    REPLACE(R.QRY,'''','''''')
     ||'''' ||';
     INSERT INTO T_MCRE0_WRK_FILEGUID_ARRG(ID_OPERAZIONE, DESC_OPERAZIONE, QRY, ID_DPER, FLG_ATTIVA )
     VALUES(V_ID_OPERAZIONE,V_DESC_OPERAZIONE, V_QRY, V_ID_DPER, V_FLG_ATTIVA);
    END;
   /
   ';
   DBMS_OUTPUT.PUT_LINE(V_OUT_1);
   END LOOP;
  END;
  
  PROCEDURE PRC_CALL_ALL IS
    P_ID_FLUSSO NUMBER:=9876;
    V_RET NUMBER;
    V_PARTITION NUMBER;
    
    
  BEGIN
    
    BEGIN
      SELECT MAX(TO_NUMBER(TO_CHAR(PERIODO_RIFERIMENTO,'YYYYMMDD'))) ID_DPER
        INTO V_PARTITION 
     FROM T_MCRE0_WRK_ACQUISIZIONE
      WHERE COD_FILE = 'FILE_GUIDA';
    EXCEPTION WHEN OTHERS THEN 
    
    SELECT TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD'))
      INTO V_PARTITION 
      FROM DUAL;   
    END;
    V_RET:=FNC_COPY_APP_FILE_GUIDA;
    V_RET:=FNC_ETL_RIBALTA_FILE_GUIDA;
    V_RET:=FNC_FILE_GUIDA_APP (V_PARTITION);
    V_RET:=FNC_UPDATE_FILE_GUIDA_EXT;
    V_RET:=FNC_LOAD_ALL_DATA_ARRG;
    V_RET:=FNG_GRUPPO_UTENTE_COMPARTO;
  END ;
END PKG_MCRE0_ALL_DATA_ARRG;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ALL_DATA_ARRG FOR MCRE_OWN.PKG_MCRE0_ALL_DATA_ARRG;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ALL_DATA_ARRG TO MCRE_USR;

