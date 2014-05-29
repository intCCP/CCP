CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_MIG_NDG_RAP AS
/******************************************************************************
   NAME:       PKG_MCRE0_MIG_NDG_RAP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        22/06/2012  1.I.Gueorguieva  Created this package body.
******************************************************************************/


  -- %author
  -- %version 0.1
  -- %usage  function che TESTA l'esistenza di una partizione sulla tabella passata per argomento
  -- %d La function testa l'esistenza di una partizione di nome INC_P||ID_dper
  -- %return 1 --> esiste partizione, 0 altrimenti
  -- %cd 25 GIU 2012
FUNCTION FNC_ESISTE_PARTIZIONE(ID_DPER IN NUMBER,
                               P_TAB_NAME IN VARCHAR2 ) RETURN NUMBER IS
  c_nome CONSTANT VARCHAR2(100) := c_package ||'.FNC_ESISTE_PARTIZIONE';
  c_note          VARCHAR2(4000);
  V_SQL           VARCHAR2(4000);
  V_ESISTE        NUMBER := KO;
BEGIN
  BEGIN

  c_note:= 'Controllo esistenza partizione INC_P'||TO_CHAR(ID_DPER);
  SELECT 1
   into v_esiste
   FROM ALL_TAB_PARTITIONS
  WHERE TABLE_OWNER = 'MCRE_OWN'
   AND  TABLE_NAME = P_TAB_NAME
   AND PARTITION_NAME = 'INC_P'||TO_CHAR(ID_DPER);

  EXCEPTION WHEN NO_DATA_FOUND THEN
    V_ESISTE:= KO;
    pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);

  END;

  RETURN V_ESISTE;
  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
      RETURN V_ESISTE;
  END FNC_ESISTE_PARTIZIONE;

  -- %author
  -- %version 0.1
  -- %usage  function che tenta di CREARE una nuova partizione sulla tabella passata per argomento
  -- %d La function tenta di creare una partizione di nome INC_P||ID_dper
  -- %return 1 --> successo creazione, 0 altrimenti
  -- %cd 25 GIU 2012
  FUNCTION FNC_ADD_PARTITION(
                             id_dper IN NUMBER,
                             P_TAB_NAME IN VARCHAR2 ) RETURN NUMBER IS

  c_nome CONSTANT VARCHAR2(100) := c_package ||'.FNC_ADD_PARTITION';
  c_note          VARCHAR2(4000);
  V_SQL           VARCHAR2(4000);
  BEGIN

  C_NOTE:= 'Creazione nuova partizione INC_P';
  V_SQL:= 'ALTER TABLE '||
  P_TAB_NAME||' SPLIT PARTITION INC_PALTRI AT
 ('||
 TO_CHAR(ID_DPER+1)
 ||')
 INTO (PARTITION
 INC_P'||
 TO_CHAR(id_dper)
 ||'
 TABLESPACE TSD_MCRE_OWN,
 PARTITION INC_PALTRI)';

  EXECUTE IMMEDIATE V_SQL;
  RETURN OK;

  EXCEPTION
    WHEN OTHERS THEN
      pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
      RETURN ko;
  END fnc_add_partition;

  -- %author
  -- %version 0.1
  -- %usage  function che carica i dati provenianti dai file AFTABRAC  nelle tabelle APP
  -- %d La function carica i dati nella ST corrispondenente a seconda dell'id_flusso passato.
  -- %d Sulla tabella T_MCRE0_MIG_ACQUISIZIONE deve essere presente un record con
  -- %d ID_FLUSSO = V_ID_FLUSSO. Il caricamento parte solo se
  -- %d T_MCRE0_MIG_ACQUISIZIONE.COD_FILE = T_MCRE0_WRK_MIG_NDG_RAP.COD_FLUSSO
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %param V_ID_DPER data trasformata in formato numerico YYYYMMDD inserita nella colonna ID_DPER della tabella ST
  -- %return 1 --> successo caricamento, 0 altrimenti
  -- %cd 27 GIU 2012   FUNCTION FNC_LOAD_APP(V_ID_FLUSSO IN NUMBER,
FUNCTION FNC_LOAD_ST(V_ID_FLUSSO IN NUMBER,
                    V_ID_DPER IN NUMBER) RETURN NUMBER IS


  c_nome CONSTANT VARCHAR2(100) := c_package ||'.FNC_LOAD_ST';
  c_note          T_MCREI_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:= 'Generale';
  V_ESISTE_CARICAMENTO  NUMBER;
  V_SQL             VARCHAR2(4000);
  V_VAL_TAB_ST      VARCHAR2(30 BYTE);
  V_VAL_QRY_ST      T_MCRE0_WRK_MIG_NDG_RAP.VAL_QRY_ST%TYPE;
  V_VAL_QRY_VINCOLI T_MCRE0_WRK_MIG_NDG_RAP.VAL_QRY_ST%TYPE;
  V_COD_FILE        T_MCRE0_MIG_ACQUISIZIONE.COD_FILE%TYPE;
  V_ESITO           NUMBER;
  V_CREATA_PAR      NUMBER;

BEGIN

    BEGIN

    SELECT COD_FILE
     INTO V_COD_FILE
     FROM T_MCRE0_MIG_ACQUISIZIONE
    WHERE ID_FLUSSO = V_ID_FLUSSO;

    EXCEPTION WHEN NO_DATA_FOUND THEN
        C_NOTE:= 'ID_FLUSSO = '||V_ID_FLUSSO||' Non trovato su T_MCRE0_MIG_ACQUISIZIONE';
        pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
      RETURN ko;
    END;

    UPDATE T_MCRE0_MIG_ACQUISIZIONE
      SET DTA_INIZIO = SYSDATE,
      COD_STATO = C_INIZIO_CARICAMENTO
     WHERE ID_FLUSSO = V_ID_FLUSSO;
     COMMIT;

    C_NOTE:= 'Recupero query vincoli e ST per il flusso: '||V_COD_FILE;
    SELECT VAL_QRY_VINCOLI,VAL_QRY_ST, VAL_TAB_ST
      INTO V_VAL_QRY_VINCOLI, V_VAL_QRY_ST, V_VAL_TAB_ST
      FROM T_MCRE0_WRK_MIG_NDG_RAP
      WHERE COD_FLUSSO = V_COD_FILE
        AND FLG_ATTIVA = 1;

    V_ESITO:= FNC_ESISTE_PARTIZIONE(V_ID_DPER, V_VAL_TAB_ST);
    IF V_ESITO = KO THEN
       V_CREATA_PAR:= FNC_ADD_PARTITION(v_id_dper,V_VAL_TAB_ST);
    END IF;

    IF V_VAL_QRY_VINCOLI IS NOT NULL THEN
        EXECUTE IMMEDIATE  TO_CHAR(V_VAL_QRY_VINCOLI) USING V_ID_FLUSSO, V_ID_DPER;
        COMMIT;

    ELSE
        C_NOTE:= 'Query vincoli IS NULL per il flusso '||V_COD_FILE;
    END IF;

    IF V_VAL_QRY_ST IS NOT NULL THEN
        V_SQL:= 'DELETE '||V_VAL_TAB_ST||
        ' WHERE '||'ID_DPER = '||V_ID_DPER;
        EXECUTE IMMEDIATE V_SQL;
        EXECUTE IMMEDIATE TO_CHAR(V_VAL_QRY_ST) USING V_ID_DPER;
    ELSE
       C_NOTE:= 'Query st IS NULL per il flusso '||V_COD_FILE;

    END IF;
    COMMIT;
    -- ST CARICATA: COD_STATO = 1
    UPDATE T_MCRE0_MIG_ACQUISIZIONE
      SET COD_STATO = c_caricata_st
     WHERE ID_FLUSSO = V_ID_FLUSSO;
     COMMIT;

    pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
    return ok;

EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
      RETURN ko;
END FNC_LOAD_ST;

  -- %author
  -- %version 0.1
  -- %usage  function che carica i dati provenianti dai file AFTABRAC  nelle tabelle APP
  -- %d Logica analoga a quella di FNC_LOAD_ST
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %param V_ID_DPER data trasformata in formato numerico YYYYMMDD inserita nella colonna ID_DPER della tabella APP
  -- %return 1 --> successo caricamento, 0 altrimenti
  -- %cd 27 GIU 2012
FUNCTION FNC_LOAD_APP(V_ID_FLUSSO IN NUMBER,
                      V_ID_DPER IN NUMBER) RETURN NUMBER IS


  c_nome CONSTANT VARCHAR2(100) := c_package ||'.FNC_LOAD_APP';
  c_note                T_MCREI_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:= 'Generale';
  V_ESISTE_CARICAMENTO  NUMBER;
  V_SQL                 VARCHAR2(4000);
  V_VAL_TAB_APP         VARCHAR2(30 BYTE);
  V_VAL_QRY_APP         T_MCRE0_WRK_MIG_NDG_RAP.VAL_QRY_APP%TYPE;
  V_VAL_QRY_VINCOLI     T_MCRE0_WRK_MIG_NDG_RAP.VAL_QRY_APP%TYPE;
  V_COD_FILE            T_MCRE0_MIG_ACQUISIZIONE.COD_FILE%TYPE;
  V_ESITO               NUMBER;

BEGIN

    BEGIN

    SELECT COD_FILE
     INTO V_COD_FILE
     FROM T_MCRE0_MIG_ACQUISIZIONE
    WHERE ID_FLUSSO = V_ID_FLUSSO;

    EXCEPTION WHEN NO_DATA_FOUND THEN
        C_NOTE:= 'ID_FLUSSO = '||V_ID_FLUSSO||' Non trovato su T_MCRE0_MIG_ACQUISIZIONE';
        pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
      RETURN ko;
    END;


    C_NOTE:= 'Recupero query APP per il flusso: '||V_COD_FILE;
    SELECT VAL_QRY_APP, VAL_TAB_APP
      INTO  V_VAL_QRY_APP, V_VAL_TAB_APP
      FROM T_MCRE0_WRK_MIG_NDG_RAP
      WHERE COD_FLUSSO = V_COD_FILE
      AND FLG_ATTIVA = 1;


    IF V_VAL_QRY_APP IS NOT NULL THEN
        V_SQL:= 'DELETE '||V_VAL_TAB_APP;
        EXECUTE IMMEDIATE V_SQL;
        COMMIT;
        EXECUTE IMMEDIATE TO_CHAR(V_VAL_QRY_APP) USING V_ID_DPER;
    ELSE
       C_NOTE:= 'Query st IS NULL per il flusso '||V_COD_FILE;

    END IF;
    COMMIT;
    -- APP CARICATA: COD_STATO =
    UPDATE T_MCRE0_MIG_ACQUISIZIONE
      SET COD_STATO = C_CARICATA_APP
     WHERE ID_FLUSSO = V_ID_FLUSSO;
     COMMIT;

    pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
    return ok;

EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
      RETURN ko;
END FNC_LOAD_APP;

  -- %author
  -- %version 0.1
  -- %usage  function che calcola il FLG_PRES_CRUSCOTTO SU T_MCRE0_APP_MIG_RECODE_NDG
  -- %d FLG_CRUSCOTTO = 1, se sulla tabella delle delibere e' presente almeno
  -- %d delibera, che non e' di classificazione ed il e' manuale.
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %return 1 --> successo calcolo, 0 altrimenti
  -- %cd 28 GIU 2012
FUNCTION FNC_CALCOLA_FLG_CRUSCOTTO(V_ID_FLUSSO IN NUMBER) RETURN NUMBER IS
  c_nome CONSTANT VARCHAR2(100) := c_package ||'.FNC_CALCOLA_FLG_CRUSCOTTO';
  c_note          T_MCREI_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:= 'Generale';
  v_cod_stato         T_MCRE0_MIG_ACQUISIZIONE.COD_STATO%TYPE;
  v_cod_file      T_MCRE0_MIG_ACQUISIZIONE.COD_FILE%TYPE;


BEGIN

    SELECT COD_FILE, COD_STATO
      INTO V_COD_FILE, V_COD_STATO
      FROM T_MCRE0_MIG_ACQUISIZIONE
    WHERE ID_FLUSSO = V_ID_FLUSSO;

    IF V_COD_STATO = C_CARICATA_APP AND V_COD_FILE = 'AFTABRAC_NDG'
    THEN
           MERGE INTO T_MCRE0_APP_MIG_RECODE_NDG T
            USING(
            SELECT DISTINCT  COD_ABI, COD_NDG
              FROM T_MCREI_APP_DELIBERE
              WHERE COD_TIPO_PACCHETTO = 'M'
                AND COD_MICROTIPOLOGIA_DELIB NOT IN ('CI', 'CS')
                AND COD_FASE_DELIBERA NOT IN ('AN','AM')
                AND COD_FASE_DELIBERA IN ('AD', 'CO', 'CT', 'NA', 'NR', 'CT')
                AND DTA_CONFERMA_DELIBERA IS NOT NULL
                AND FLG_ATTIVA = 1
                )S
            ON (S.COD_ABI = T.COD_ABI_OLD
                AND S.COD_NDG = T.COD_NDG_OLD)
            WHEN MATCHED THEN UPDATE
              SET
                    T.FLG_PRES_CRUSCOTTO = 1,
                    T.DTA_UPD = SYSDATE;
           COMMIT;
    ELSE
        C_NOTE:= 'T_MCRE0_APP_MIG_RECODE_NDG non caricata';
    END IF;


    pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
    return ok;
EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
   RETURN KO;
END FNC_CALCOLA_FLG_CRUSCOTTO;

  -- %author
  -- %version 0.1
  -- %usage  function che calcola il FLG_PARZIALE SU T_MCRE0_APP_MIG_RECODE_NDG
  -- %d FLG_PARZIALE = 1, se sul file guida e presente un NDG che coincide con NDG_NEW
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %return 1 --> successo calcolo, 0 altrimenti
  -- %cd 28 GIU 2012
FUNCTION FNC_CALCOLA_FLG_CONDIVISO(V_ID_FLUSSO IN NUMBER) RETURN NUMBER IS
  c_nome CONSTANT VARCHAR2(100) := c_package ||'.FNC_CALCOLA_FLG_CONDIVISO';
  c_note          T_MCREI_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:= 'Generale';
  v_cod_stato         T_MCRE0_MIG_ACQUISIZIONE.COD_STATO%TYPE;
  v_cod_file      T_MCRE0_MIG_ACQUISIZIONE.COD_FILE%TYPE;

    BEGIN

        SELECT COD_FILE, COD_STATO
          INTO V_COD_FILE, V_COD_STATO
          FROM T_MCRE0_MIG_ACQUISIZIONE
        WHERE ID_FLUSSO = V_ID_FLUSSO;

        IF V_COD_STATO = C_CARICATA_APP AND V_COD_FILE = 'AFTABRAC_NDG' THEN

            MERGE INTO   T_MCRE0_APP_MIG_RECODE_NDG T
                 USING   (SELECT   DISTINCT COD_ABI_CARTOLARIZZATO, COD_NDG
                            FROM   T_MCRE0_APP_ALL_DATA
                           WHERE   FLG_ACTIVE = '1' ) S           -- DA VEDERE SE SI PUO' RESTRINGERE A TODAY_FLG = 1
                    ON   (S.COD_ABI_CARTOLARIZZATO = T.COD_ABI_NEW
                          AND S.COD_NDG = T.COD_NDG_NEW)
            WHEN MATCHED
            THEN UPDATE SET
                    T.FLG_CONDIVISO = 1,
                    T.DTA_UPD = SYSDATE;
        COMMIT;
        ELSE
            C_NOTE:= 'T_MCRE0_APP_MIG_RECODE_NDG non caricata';
        END IF;
            pkg_mcrei_audit.log_app(c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
        return ok;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
    RETURN KO;
    END FNC_CALCOLA_FLG_CONDIVISO;

  -- %author
  -- %version 0.1
  -- %usage  function che calcola il FLG_PARZIALE SU T_MCRE0_APP_MIG_RECODE_NDG
  -- %d FLG_PARZIALE= 1, se non tutti i rapporti presenti sulla banca cedente
  -- %d verrranno rinumerati, ovvero se non esiste una coppia ABI_NEW, RAPPORTO_NEW
  -- %d per ogni rapporto di una certa posizione presente sulla banca cedente
  -- %d FLG_PARZIALE= 0, altrimenti
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %return 1 --> successo calcolo, 0 altrimenti
  -- %cd 28 GIU 2012
FUNCTION FNC_CALCOLA_FLG_PARZIALE(V_ID_FLUSSO IN NUMBER) RETURN NUMBER IS
  c_nome CONSTANT VARCHAR2(100) := c_package ||'.FNC_CALCOLA_FLG_PARZIALE';
  c_note          T_MCREI_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:= 'Generale';
  v_cod_stato         T_MCRE0_MIG_ACQUISIZIONE.COD_STATO%TYPE;
  v_cod_file      T_MCRE0_MIG_ACQUISIZIONE.COD_FILE%TYPE;

    BEGIN

        SELECT COD_FILE, COD_STATO
          INTO V_COD_FILE, V_COD_STATO
          FROM T_MCRE0_MIG_ACQUISIZIONE
        WHERE ID_FLUSSO = V_ID_FLUSSO;

        IF V_COD_STATO = C_CARICATA_APP AND V_COD_FILE = 'AFTABRAC_NDG' THEN

        MERGE INTO T_MCRE0_APP_MIG_RECODE_NDG T
        USING(
        SELECT DISTINCT COD_ABI, COD_NDG
        FROM (
        SELECT DISTINCT COD_ABI, COD_NDG, COD_RAPPORTO
          FROM T_MCREI_APP_PCR_RAPPORTI
        -- WHERE COD_ABI = '01025'
        --  AND COD_NDG = '0000018632181000'
        MINUS
        SELECT DISTINCT COD_ABI, COD_NDG, COD_RAPPORTO
          FROM T_MCRE0_APP_MIG_RECODE_RAPP R, T_MCREI_APP_PCR_RAPPORTI PCR
          WHERE PCR.COD_ABI = R.COD_ABI_OLD
            AND PCR.COD_RAPPORTO = R.COD_RAPPORTO_OLD
        --    AND COD_ABI = '01025'
        --    AND COD_NDG = '0000018632181000'
        )) S
        ON (S.COD_ABI = T.COD_ABI_OLD
        AND S.COD_NDG = T.COD_NDG_OLD)
        WHEN MATCHED THEN UPDATE
           SET FLG_PARZIALE = 1,
                DTA_UPD = SYSDATE;
        COMMIT;

               -- CARICAMENTO TERMINATO

        UPDATE T_MCRE0_MIG_ACQUISIZIONE
          SET COD_STATO = C_CALCOLATI_FLG,
              DTA_FINE = SYSDATE
        WHERE ID_FLUSSO = V_ID_FLUSSO;
        COMMIT;
        ELSE
            C_NOTE:= 'T_MCRE0_APP_MIG_RECODE_NDG non caricata';
        END IF;

    UPDATE T_MCRE0_MIG_ACQUISIZIONE
      SET
           DTA_FINE = SYSDATE
    WHERE ID_FLUSSO = V_ID_FLUSSO;
    COMMIT;

            pkg_mcrei_audit.log_app(c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
        return ok;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
    RETURN KO;
    END FNC_CALCOLA_FLG_PARZIALE;

  -- %author
  -- %version 0.1
  -- %usage  function che inserisce un record in T_MCRE0_MIG_ACQUISIZIONE
  -- %d il record avrò popolati i campi ID_FLUSSO, COD_FILE, ID_DPER
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %param NDG_OR_RAPP valori possibili: AFTABRAC_NDG  oppure AFTABRAC_RAPP
  -- %return ID_DPER --> successo INSERIMENTO, 0 altrimenti
  -- %cd 28 GIU 2012
FUNCTION FNC_INIT_CARICAMENTO(V_ID_FLUSSO IN NUMBER,NDG_OR_RAPP IN VARCHAR2
                             ) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||'.FNC_INIT_CARICAMENTO';
    c_note          T_MCREI_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:= 'Generale';
    v_cod_stato         T_MCRE0_MIG_ACQUISIZIONE.COD_STATO%TYPE;
    V_ID_DPER       VARCHAR2(8);
    BEGIN


--        SELECT DISTINCT ID_DPER
--          INTO V_ID_DPER
--        FROM TE_MCRE0_MIG_RECODE_NDG;  ---> RIATTIVARE QUANDO SI E' SICURI CHE NON CI SONO VALORI NULLI
                                         ---> PER L'ID_DPER NELLA TABELLA ESTERNA
                                         ---> IN QUESTO MODO QUESTO DIVENTERA' ANCHE UN
                                         ---> CONTROLLO CHE CI SIA SOLO UN ID_DPER NELL'EXTERNAL,
                                         ---> CIOE' CHE TUTTI I FILE SONO ARRIVATI

    IF NDG_OR_RAPP = 'AFTABRAC_NDG' THEN
       SELECT ID_DPER
          INTO V_ID_DPER
        FROM TE_MCRE0_MIG_RECODE_NDG
        WHERE ROWNUM = 1;
    ELSE
    SELECT ID_DPER
      INTO V_ID_DPER
      FROM TE_MCRE0_MIG_RECODE_RAPP
     WHERE ROWNUM = 1;
    END IF;

        INSERT INTO T_MCRE0_MIG_ACQUISIZIONE(ID_FLUSSO, ID_DPER, COD_FILE)
        VALUES(V_ID_FLUSSO, TO_NUMBER(V_ID_DPER), NDG_OR_RAPP);
        COMMIT;


            pkg_mcrei_audit.log_app(c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
        return V_ID_DPER;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
    RETURN KO;

    END FNC_INIT_CARICAMENTO;

    FUNCTION FNC_DELETE_FLG_NDG RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||'.FNC_DELETE_FLG_NDG';
    c_note          T_MCREI_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:= 'Generale';
    BEGIN

           UPDATE T_MCRE0_APP_MIG_RECODE_NDG
              SET FLG_PRES_CRUSCOTTO = 0,
                  FLG_CONDIVISO= 0,
                  FLG_PARZIALE = 0,
                  DTA_UPD = SYSDATE;
           COMMIT;

           pkg_mcrei_audit.log_app(c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
        return OK;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
    RETURN KO;
    END FNC_DELETE_FLG_NDG;

    FUNCTION FNC_EXE_LOAD(V_ID_FLUSSO IN NUMBER,NDG_OR_RAPP IN VARCHAR2) RETURN NUMBER IS
    c_nome CONSTANT VARCHAR2(100) := c_package ||'.FNC_EXE_LOAD';
    c_note          T_MCREI_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:= 'Generale';
    V_RET_ST        NUMBER;
    V_RET_APP       NUMBER;
    V_RET_FLG_CRUSC NUMBER;
    V_RET_CONDIV    NUMBER;
    V_RET_PARZ      NUMBER;
--    V_RET_DEL_FLG   NUMBER;
    V_ID_DPER       NUMBER;
    V_RET           NUMBER:=-1;
    V_COUNT         NUMBER:=0;

    BEGIN

    V_ID_DPER:= FNC_INIT_CARICAMENTO(V_ID_FLUSSO,NDG_OR_RAPP);
        IF V_ID_DPER != KO THEN
            V_RET_ST:= FNC_LOAD_ST(V_ID_FLUSSO, V_ID_DPER);
            IF V_RET_ST = OK THEN
                V_RET_APP:= FNC_LOAD_APP(V_ID_FLUSSO, V_ID_DPER);
                -- CONTROLLARE SE è CARICATO L'ALTRO FLUSSO
                IF V_RET_APP = OK THEN

                 V_RET_FLG_CRUSC:= FNC_CALCOLA_FLG_CRUSCOTTO(V_ID_FLUSSO);

                 IF V_RET_FLG_CRUSC = OK THEN
                    V_RET_CONDIV:= FNC_CALCOLA_FLG_CONDIVISO(V_ID_FLUSSO);

                    IF V_RET_CONDIV = OK THEN
                        V_RET_PARZ:= FNC_CALCOLA_FLG_PARZIALE(V_ID_FLUSSO);
                    ELSE
                      V_RET:= KO;
                    END IF;
                 ELSE
                    V_RET:= KO;
                 END IF;
                ELSE
                    V_RET:= KO;
                END IF;
            ELSE
                V_RET:=KO;
            END IF;
        ELSE
            V_RET:=KO;
        END IF;

        IF V_RET = -1 THEN
            RETURN V_RET_PARZ;
        ELSE RETURN V_RET;
        END IF;

    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
    RETURN KO;
    END FNC_EXE_LOAD;
  -- %author
  -- %version 0.1
  -- %usage  function che calcola il FLG_SOFFERENZA SU T_MCRE0_APP_MIG_RECODE_NDG
  -- %d FLG_SOFFERENZA= 1, se la posizione RICEVENTE è in stato SOFFERENZA sul file guida
  -- %d FLG_SOFFERENZA = 0, altrimenti
  -- %d La funzione va chiamata dopo che il file guida è stato rinumerato
  -- %param V_ID_FLUSSO numero unico identificativo del caricamento
  -- %return 1 --> successo calcolo, 0 altrimenti
  -- %cd 29 GIU 2012
FUNCTION FNC_CALCOLA_FLG_SOFFERENZA(V_ID_FLUSSO IN NUMBER, NDG_OR_RAPP IN VARCHAR2) RETURN NUMBER IS
  c_nome CONSTANT VARCHAR2(100) := c_package ||'.FNC_CALCOLA_FLG_SOFFERENZA';
  c_note          T_MCREI_WRK_AUDIT_APPLICATIVO.NOTE%TYPE:= 'Generale';
  v_cod_stato         T_MCRE0_MIG_ACQUISIZIONE.COD_STATO%TYPE;
  v_cod_file      T_MCRE0_MIG_ACQUISIZIONE.COD_FILE%TYPE;

    BEGIN

        SELECT COD_FILE, COD_STATO
          INTO V_COD_FILE, V_COD_STATO
          FROM T_MCRE0_MIG_ACQUISIZIONE
        WHERE ID_FLUSSO = V_ID_FLUSSO;

        IF V_COD_STATO = C_CARICATA_APP AND V_COD_FILE = 'AFTABRAC_NDG' THEN
        -- DA RIVEDERE
            MERGE INTO T_MCRE0_APP_MIG_RECODE_NDG T
            USING(
            SELECT AD.COD_ABI_CARTOLARIZZATO AS COD_ABI, AD.COD_NDG
              FROM T_MCRE0_APP_ALL_DATA AD
            WHERE  AD.FLG_ACTIVE = '1'           -- DA VEDERE SE SI PUO' RESTRINGERE A TODAY_FLG = 1
              AND  AD.COD_STATO = 'SO')S
            ON(     T.COD_ABI_NEW = S.COD_ABI
              AND   T.COD_NDG_NEW = S.COD_NDG)
            WHEN MATCHED THEN UPDATE
               SET FLG_SOFFERENZA = 1,
               DTA_UPD = SYSDATE;

        COMMIT;

               -- CARICAMENTO TERMINATO

        ELSE
            C_NOTE:= 'T_MCRE0_APP_MIG_RECODE_NDG non caricata';
        END IF;
            pkg_mcrei_audit.log_app(c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
        return ok;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        pkg_mcrei_audit.log_app(c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                              c_note,
                              NULL);
    RETURN KO;
END FNC_CALCOLA_FLG_SOFFERENZA;

 END;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_MIG_NDG_RAP FOR MCRE_OWN.PKG_MCRE0_MIG_NDG_RAP;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_MIG_NDG_RAP FOR MCRE_OWN.PKG_MCRE0_MIG_NDG_RAP;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_MIG_NDG_RAP TO MCRE_USR;

