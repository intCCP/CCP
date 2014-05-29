CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_PARTIZIONI AS
/******************************************************************************
   NAME:       PKG_MCRE0_PARTIZIONI
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Andrea Bartolomei  Created this package.
   2.0        24/05/2012  Valeria galli      Caricamento Email
   3.0        22/06/2012  Emiliano Pellizzi  Add function FND_MCRE0_add_part_storica
   3.1        15/10/2012  Luca Ferretti      Aggiunto log
   3.2        15/10/2012  Luca Ferretti      Estensione log
******************************************************************************/
    FUNCTION FND_MCRE0_find_part(seq IN NUMBER, p_table IN VARCHAR2, p_periodo IN DATE) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_find_part';
        v_count NUMBER;

    BEGIN
        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');

        SELECT COUNT(*) INTO v_count
        FROM ALL_TAB_PARTITIONS
        WHERE
            TABLE_OWNER = 'MCRE_OWN' AND
            TABLE_NAME = p_table AND
            PARTITION_NAME = 'CCP_P' || TO_CHAR(p_periodo,'YYYYMMDD');

        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'v_count PARTIZIONI = '||v_count, '');

        RETURN (v_count = 1);

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ECCEZIONE');
            RETURN FALSE;

    END FND_MCRE0_find_part;

 FUNCTION FND_MCRE0_find_part_M(seq IN NUMBER, p_table IN VARCHAR2, p_periodo IN DATE) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_find_part';

        v_count NUMBER;

    BEGIN
        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');

        SELECT COUNT(*) INTO v_count
        FROM ALL_TAB_PARTITIONS
        WHERE
            TABLE_OWNER = 'MCRE_OWN' AND
            TABLE_NAME = p_table AND
            PARTITION_NAME = 'CCP_P' || TO_CHAR(p_periodo,'YYYYMM');

        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'v_count PARTIZIONI = '||v_count, 'INIZIO');

        RETURN (v_count = 1);

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ECCEZIONE');
            RETURN FALSE;

    END FND_MCRE0_find_part_M;
    FUNCTION FND_MCRE0_find_next_part(seq IN NUMBER, p_table IN VARCHAR2, p_periodo IN DATE) RETURN ALL_TAB_PARTITIONS.PARTITION_NAME%TYPE IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_find_next_part';
        v_part_name ALL_TAB_PARTITIONS.PARTITION_NAME%TYPE;

    BEGIN
        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');

        SELECT MIN(PARTITION_NAME) INTO v_part_name
        FROM ALL_TAB_PARTITIONS
        WHERE
            TABLE_OWNER = 'MCRE_OWN' AND
            TABLE_NAME = p_table AND
            PARTITION_NAME > 'CCP_P' || TO_CHAR(p_periodo,'YYYYMMDD');

        RETURN v_part_name;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ECCEZIONE');
            RETURN NULL;

    END FND_MCRE0_find_next_part;

    FUNCTION FND_MCRE0_find_next_part_M(seq IN NUMBER, p_table IN VARCHAR2, p_periodo IN DATE) RETURN ALL_TAB_PARTITIONS.PARTITION_NAME%TYPE IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_find_next_part';
        v_part_name ALL_TAB_PARTITIONS.PARTITION_NAME%TYPE;

    BEGIN

        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');

        SELECT MIN(PARTITION_NAME) INTO v_part_name
        FROM ALL_TAB_PARTITIONS
        WHERE
            TABLE_OWNER = 'MCRE_OWN' AND
            TABLE_NAME = p_table AND
            PARTITION_NAME > 'CCP_P' || TO_CHAR(p_periodo,'YYYYMM');

        RETURN v_part_name;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ECCEZIONE');

            RETURN NULL;

    END FND_MCRE0_find_next_part_M;

    FUNCTION FND_MCRE0_drop_subpartition(seq IN NUMBER, p_table IN VARCHAR2, p_partition IN VARCHAR2) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_drop_subpartition';
        b_exc BOOLEAN := FALSE;
        v_rec PKG_MCRE0_UTILS.rec_abi_type;

        CURSOR cur IS
        SELECT SUBPARTITION_NAME
        FROM ALL_TAB_SUBPARTITIONS
        WHERE
            TABLE_OWNER = 'MCRE_OWN' AND
            TABLE_NAME = p_table AND
            PARTITION_NAME = p_partition
            AND SUBPARTITION_NAME NOT LIKE '%_00000%'
            AND SUBPARTITION_NAME NOT LIKE '%ALTRI%';

        v_subpartition ALL_TAB_SUBPARTITIONS.SUBPARTITION_NAME%TYPE;

    BEGIN

        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'drop subpartition..');
        EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table || ' DROP SUBPARTITION ' || p_partition || '_ALTRI';
        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'drop subpartition..');

        OPEN cur;

        FETCH cur INTO v_subpartition;

        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'add subpartition..');
        EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table || ' MODIFY PARTITION ' || p_partition ||
                        ' ADD SUBPARTITION ' || p_partition || '_00000 VALUES (''00000'')';
        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'add subpartition..');

          WHILE (cur%FOUND) LOOP
            PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'drop subpartition..'||v_subpartition);
            EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table || ' DROP SUBPARTITION ' || v_subpartition;
            PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'drop subpartition..'||v_subpartition);
            FETCH cur INTO v_subpartition;
        END LOOP;

        CLOSE cur;

        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');

        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ECCEZIONE');
            BEGIN
                IF(cur%ISOPEN) THEN
                    CLOSE cur;
                END IF;

            EXCEPTION
                WHEN OTHERS THEN
                PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ECCEZIONE - CLOSE CURSOR');
            END;

            RETURN FALSE;

    END FND_MCRE0_drop_subpartition;

    FUNCTION FND_MCRE0_rebuild_indexes(seq IN NUMBER, p_table IN VARCHAR2) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_rebuild_indexes';

        CURSOR cur IS
        SELECT 'ALTER INDEX ' || INDEX_NAME || ' REBUILD' COMMAND
        FROM ALL_INDEXES
        WHERE OWNER = 'MCRE_OWN' AND
        TABLE_NAME = p_table AND
        STATUS = 'UNUSABLE';


    BEGIN

        FOR rec IN cur LOOP

            EXECUTE IMMEDIATE rec.COMMAND;
--             DBMS_OUTPUT.PUT_LINE(rec.COMMAND || ' eseguito');
             PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, rec.COMMAND || ' eseguito', 'INIZIO');

        END LOOP;

        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ECCEZIONE');
            RETURN FALSE;

    END FND_MCRE0_rebuild_indexes;

    FUNCTION FND_MCRE0_add_subpartition(seq IN NUMBER, p_table IN VARCHAR2, p_partition IN VARCHAR2, p_cur IN PKG_MCRE0_UTILS.cur_abi_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_add_subpartition';

        b_exc BOOLEAN := FALSE;

        v_rec PKG_MCRE0_UTILS.rec_abi_type;

    BEGIN

        FETCH p_cur INTO v_rec;

        WHILE(p_cur%FOUND) LOOP

            BEGIN


              EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table || ' MODIFY PARTITION ' || p_partition ||
                                  ' ADD SUBPARTITION ' || p_partition || '_' || LPAD(v_rec.ABI,5,0) || ' VALUES (''' || LPAD(v_rec.ABI, 5,0) || ''')';

              PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'CREATA SOTTOPATIZIONE '||v_rec.ABI, 'INIZIO');

            EXCEPTION
                WHEN OTHERS THEN
                    PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ADD SUBPARTITION ' || p_partition || '_' || LPAD(v_rec.ABI,5,0));
                    RAISE;
            END;

            FETCH p_cur INTO v_rec;

        END LOOP;

        CLOSE p_cur;

        EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table || ' DROP SUBPARTITION ' || p_partition || '_00000';

        EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table || ' MODIFY PARTITION ' || p_partition ||
                         ' ADD SUBPARTITION ' || p_partition || '_ALTRI VALUES (DEFAULT)';

        PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');

        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ECCEZIONE');

        BEGIN
            IF(p_cur%ISOPEN) THEN
                CLOSE p_cur;
                 PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ECCEZIONE su CLOSE CURSOR - cursore aperto');
            END IF;

        EXCEPTION
            WHEN OTHERS THEN
                PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ERRORE su CLOSE CURSOR');
        END;

        RETURN FALSE;

    END FND_MCRE0_add_subpartition;

    FUNCTION FND_MCRE0_add_partition(seq IN NUMBER, p_table IN VARCHAR2, p_periodo IN DATE, p_cur IN PKG_MCRE0_UTILS.cur_abi_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_add_partition';

        v_sql VARCHAR2(1000);

        v_current VARCHAR2(10);

        v_next VARCHAR2(10);

        v_next_part ALL_TAB_PARTITIONS.PARTITION_NAME%TYPE;

        b_return BOOLEAN;

        v_risultato VARCHAR2(100);

        v_new_partition VARCHAR(30 BYTE);

    BEGIN
      b_return := FALSE;
      PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');

       UPDATE T_MCRE0_WRK_STATISTICHE
       SET PART_NAME = NULL
       WHERE TABLE_NAME = p_table;
       COMMIT;


        v_current := TO_CHAR(p_periodo,'YYYYMMDD');

        IF(FND_MCRE0_find_part(seq,p_table,p_periodo)) THEN

            EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table || ' DROP PARTITION CCP_P' || v_current;
            PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'DROP PARTITION CCP_P' || v_current|| ' ESEGUITA');

        END IF;

        v_next_part := FND_MCRE0_find_next_part(seq,p_table,p_periodo);

        PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'Partizione successiva esistente'|| v_next_part);

        v_next := TO_CHAR((p_periodo + 1),'YYYYMMDD');

        v_sql := 'ALTER TABLE ' || p_table || ' SPLIT PARTITION ' || v_next_part || ' AT (' || v_next || ')
                  INTO (PARTITION CCP_P' || v_current || ', PARTITION ' || v_next_part || ')';

        EXECUTE IMMEDIATE v_sql;
        v_new_partition := 'CCP_P' || v_current;

        UPDATE  T_MCRE0_WRK_STATISTICHE
        SET     PART_NAME = v_new_partition
        WHERE   TABLE_NAME = p_table;
        COMMIT;

        UPDATE  T_MCRE0_WRK_ACQUISIZIONE
        SET     ST_PARTITION = V_NEW_PARTITION
        WHERE   ID_FLUSSO = SEQ;
        COMMIT;

        PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'AGGIUNTA PARTIZIONE '|| v_new_partition);

        IF p_table not in (

        'T_MCRE0_ST_GRUPPO_ECONOMICO',
        'T_MCRE0_ST_LEGAME',
        'T_MCRE0_ST_ANAGRAFICA_GRUPPO',
        'T_MCRE0_ST_PCR_GB',
        'T_MCRE0_ST_SAG',
        'T_MCRE0_ST_ANAGR_GRE',
        'T_MCRE0_ST_RICH_MON',
        'T_MCRE0_ST_CR',
        'T_MCRE0_ST_CR_SNDG',
        'T_MCRE0_ST_CR_SNDG_GE',
        'T_MCRE0_ST_PCR_LEGAME',
        'T_MCRE0_ST_IRIS',
        'T_MCRE0_ST_CR_GE_GB',
        'T_MCRE0_ST_CR_LG_GB',
        'T_MCRE0_ST_CR_SC_GB',
        'T_MCRE0_ST_EMAIL',
        'T_MCRE0_ST_PREGIUDIZIEVOLI'


        ) THEN

        b_return := FND_MCRE0_drop_subpartition(seq,p_table,'CCP_P' || v_current);

         IF(b_return) THEN

            b_return := FND_MCRE0_add_subpartition(seq,p_table,'CCP_P' || v_current,p_cur);
            PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'ESEGUITA FND_MCRE0_add_subpartition');

            IF(b_return) THEN
                b_return := FND_MCRE0_rebuild_indexes(seq,p_table);
                PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'ESEGUITA FND_MCRE0_rebuild_indexes');
            END IF;

          END IF;

        ELSE
            b_return := FND_MCRE0_rebuild_indexes(seq,p_table);
            PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'ESEGUITA FND_MCRE0_rebuild_indexes');
        END IF;

        IF(b_return) THEN
            v_risultato := 'OK';
        ELSE
            v_risultato := 'ERRORE';
        END IF;

        PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'ESEGUITA FND_MCRE0_add_partition');
        RETURN b_return;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ECCEZIONE - FND_MCRE0_add_partition');
            RETURN FALSE;

    END FND_MCRE0_add_partition;


FUNCTION FND_MCRE0_add_partition_LOG(seq IN NUMBER, p_table IN VARCHAR2) RETURN BOOLEAN IS


        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_add_partition_LOG';
        v_sql VARCHAR2(1000);
        v_risultato VARCHAR2 (5 byte);
        b_return boolean;


    BEGIN
     b_return := FALSE;

     DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_add_partition_LOG');

      v_sql := 'ALTER TABLE ' || p_table ||
                 ' DROP
                  PARTITION CCP_PALTRI';
        DBMS_OUTPUT.PUT_LINE(v_sql);
        EXECUTE IMMEDIATE v_sql;
        DBMS_OUTPUT.PUT_LINE('OK');



      v_sql := 'ALTER TABLE ' || p_table ||
                 ' ADD
                  PARTITION CCP_P'|| seq || ' VALUES ('||seq||')';



        DBMS_OUTPUT.PUT_LINE(v_sql);
        EXECUTE IMMEDIATE v_sql;
        DBMS_OUTPUT.PUT_LINE('OK');





              v_sql := 'ALTER TABLE ' || p_table ||
                ' ADD
                  PARTITION CCP_PALTRI VALUES (DEFAULT)';

        DBMS_OUTPUT.PUT_LINE(v_sql);
        EXECUTE IMMEDIATE v_sql;
        DBMS_OUTPUT.PUT_LINE('OK');

        v_risultato := 'OK';

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,v_risultato);
        DBMS_OUTPUT.PUT_LINE('eseguita FND_MCRE0_add_partition_LOG');

         b_return := TRUE;

        RETURN b_return;

    EXCEPTION

        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_add_partition_LOG');

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_add_partition_LOG;

--3.0
  FUNCTION FND_MCRE0_add_part_storica(seq IN NUMBER, p_table IN VARCHAR2, p_periodo IN DATE) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_add_part_storica';

        v_sql VARCHAR2(1000);

        v_current VARCHAR2(10);

        v_next VARCHAR2(10);

        v_next_part ALL_TAB_PARTITIONS.PARTITION_NAME%TYPE;

        b_return BOOLEAN;

        v_risultato VARCHAR2(100);

        v_new_partition VARCHAR(30 BYTE);

    BEGIN
     b_return := FALSE;

     DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_add_partition');

     UPDATE T_MCRE0_WRK_STATISTICHE
     SET PART_NAME = NULL
     WHERE TABLE_NAME = p_table;
     COMMIT;


        v_current := TO_CHAR(p_periodo,'YYYYMM');

        IF(FND_MCRE0_find_part_M(seq,p_table,p_periodo) = false )  THEN

           -- EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table || ' DROP PARTITION CCP_P' || v_current;
           --  DBMS_OUTPUT.PUT_LINE(' DROP PARTITION CCP_P' || v_current|| ' ESEGUITA');
        v_next_part := FND_MCRE0_find_next_part_M(seq,p_table,p_periodo);

        DBMS_OUTPUT.PUT_LINE('Partizione successiva esistente'|| v_next_part);

        v_next := TO_CHAR((p_periodo),'YYYYMM')+1;
        DBMS_OUTPUT.PUT_LINE('Partizione successiva a quella da caricare '|| v_next);

        v_sql := 'ALTER TABLE ' || p_table || ' SPLIT PARTITION ' || v_next_part || ' AT (' || v_next || ')
                  INTO (PARTITION CCP_P' || v_current || ', PARTITION ' || v_next_part || ')';

        DBMS_OUTPUT.PUT_LINE(v_sql);

        EXECUTE IMMEDIATE v_sql;
        v_new_partition := 'CCP_P' || v_current;

        UPDATE
            T_MCRE0_WRK_STATISTICHE
        SET
            PART_NAME = v_new_partition
        WHERE
            TABLE_NAME = p_table;
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('AGGIUNTA PARTIZIONE '|| v_new_partition);





        END IF;

        b_return := FND_MCRE0_rebuild_indexes(seq,p_table);
        DBMS_OUTPUT.PUT_LINE('ESEGUITA FND_MCRE0_rebuild_indexes');
        IF(b_return) THEN

            v_risultato := 'OK';
             DBMS_OUTPUT.PUT_LINE('RISULTATO: '|| v_risultato);


        ELSE

            v_risultato := 'ERRORE';
            DBMS_OUTPUT.PUT_LINE('RISULTATO: '|| v_risultato);

        END IF;

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,v_risultato);
        DBMS_OUTPUT.PUT_LINE('eseguita FND_MCRE0_add_partition');

        RETURN b_return;

    EXCEPTION

        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_add_partition');

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_add_part_storica;
END PKG_MCRE0_PARTIZIONI;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_PARTIZIONI FOR MCRE_OWN.PKG_MCRE0_PARTIZIONI;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_PARTIZIONI FOR MCRE_OWN.PKG_MCRE0_PARTIZIONI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_PARTIZIONI TO MCRE_USR;

