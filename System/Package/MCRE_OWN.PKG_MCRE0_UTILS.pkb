CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_UTILS" AS
/******************************************************************************
   NAME:       PKG_MCRE0_UTILS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        20/04/2010  Andrea Bartolomei  Created this package.
   1.1        20/04/2011  M.Murro            Aggiunte funzioni Apri/Chiudi portale
   1.2        03/11/2011  L.Ferretti         Aggiunta funzione per controlli mattutini
   1.3        16/11/2011  L.Ferretti         Modifica insert per controlli.
   1.4        17/11/2011  L.Ferretti         Nuova gestione dei controlli.
   1.5        15/02/2012  L.Ferretti         Aggiunta funzione chiamata analyze settimanale
   1.6        16/03/2012  L.Ferretti         Aggiornamento log (scrittura in tabella)
   1.7        02/07/2012  L.Ferretti         Aggiunta, nella analyze settimanale, della chiamata alla refresh delle CR.
   1.8        30/10/2012  L.Ferretti         Aggiunta, nella analyze settimanale, della chiamata allo svecchiamento settimanale.
   1.9        10/12/2012  V.Galli             Commentato refresh CR
   1.10      28/01/2013  F. Galletti         Commentati tutti i dbms_output per evitare errori nelle applicazioni TWS 
******************************************************************************/


    FUNCTION FND_MCRE0_esegui_slave(seq IN NUMBER, funzione IN VARCHAR2, p_param IN f_slave_par_type) RETURN NUMBER IS

        v_result NUMBER;
        V_STRING VARCHAR2(2000);
        v_function VARCHAR2(255) := 'PKG_MCRE0_FUNZIONI_SLAVE.' || funzione;

    BEGIN
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, v_function, 'INIZIO');
        V_STRING := 'CALL ' || v_function || '(:p_param) INTO :v_result';
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, v_function, V_STRING);
        EXECUTE IMMEDIATE V_STRING USING IN p_param, OUT v_result;
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, v_function, 'FINE');
        RETURN v_result;

        EXCEPTION
        WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, v_function, SQLERRM);
        RAISE;

    END FND_MCRE0_esegui_slave;


  FUNCTION FND_MCRE0_string2number(seq IN NUMBER, p_string IN VARCHAR2, p_number OUT NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.string2number';

    BEGIN
        p_number := TO_NUMBER(p_string);
        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'FND_MCRE0_string2number', SQLERRM);
            RETURN FALSE;
            
    END FND_MCRE0_string2number;

    FUNCTION FND_MCRE0_string2number(seq IN NUMBER, p_string IN VARCHAR2) RETURN BOOLEAN IS

        v_number NUMBER;

    BEGIN
        RETURN FND_MCRE0_string2number(seq,p_string,v_number);
        
    EXCEPTION
    WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, 'FND_MCRE0_string2number', SQLERRM);
        RETURN FALSE;    

    END FND_MCRE0_string2number;

FUNCTION FND_MCRE0_get_cur_sic_fnd_slv(seq IN NUMBER, p_file IN VARCHAR2) RETURN cur_sic_fun_type IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_get_cur_sic_fnd_slv';
        v_stato_ok T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_cur cur_sic_fun_type;

    BEGIN
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'INIZIO');
        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

        OPEN v_cur FOR
        SELECT
            d.TAB_ESTERNA,
            d.FUNZIONE_SLAVE
        FROM
            T_MCRE0_WRK_ANAGRAFICA b,
            T_MCRE0_WRK_ACQUISIZIONE c,
            T_MCRE0_WRK_ELABORAZIONE d
        WHERE
            c.NOME_FILE = p_file AND
            c.STATO = v_stato_ok AND
            b.COD_FILE = c.COD_FILE AND
            b.COD_FILE = d.COD_FILE AND
            d.FLG_ATTIVA_FUNZIONE = 1 AND
            c.TMS_FILE BETWEEN b.DATA_INIZIO_VALIDITA AND b.DATA_FINE_VALIDITA AND
            c.TMS_FILE BETWEEN d.DATA_INIZIO_VALIDITA AND d.DATA_FINE_VALIDITA
        ORDER BY
            d.ORDINE_FUNZIONE,
            d.ORDINE_ALIMENTAZIONE;

        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'FINE');

        RETURN v_cur;

    EXCEPTION

        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, c_nome, SQLERRM);
            RETURN NULL;

    END FND_MCRE0_get_cur_sic_fnd_slv;

    FUNCTION FND_MCRE0_string2date_format(seq IN NUMBER, p_string IN VARCHAR2, p_format IN VARCHAR2, p_date OUT DATE) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_string2date_format';

    BEGIN
        p_date := TO_DATE(p_string,p_format);
        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, c_nome, SQLERRM);
            RETURN FALSE;

    END FND_MCRE0_string2date_format;

    FUNCTION FND_MCRE0_alterTable(seq IN NUMBER, p_ext_table IN VARCHAR2, p_dir IN VARCHAR2, p_file IN VARCHAR2) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.alterTable';
        c_sql CONSTANT VARCHAR2(255) := 'ALTER TABLE ' || p_ext_table || ' LOCATION (' || p_dir || ':'''  || p_file || ''')' ;

    BEGIN
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'INIZIO');
        EXECUTE IMMEDIATE c_sql;
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'FINE');
        RETURN TRUE;

    EXCEPTION

        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, c_nome, SQLERRM);
            RETURN FALSE;

    END FND_MCRE0_alterTable;

    FUNCTION FND_MCRE0_string2date(seq IN NUMBER, p_string IN VARCHAR2, p_date OUT DATE) RETURN BOOLEAN IS

    BEGIN

        RETURN FND_MCRE0_string2date_format(seq,p_string,'DDMMYYYY',p_date);

    END FND_MCRE0_string2date;
    FUNCTION FND_MCRE0_string2date(seq IN NUMBER, p_string IN VARCHAR2) RETURN BOOLEAN IS

        v_date DATE;

    BEGIN

        RETURN FND_MCRE0_string2date(seq,p_string,v_date);

    END FND_MCRE0_string2date;

    FUNCTION FND_MCRE0_checkIn(seq IN NUMBER, p_file IN VARCHAR2) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_checkIn';

        v_stato_ok T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_stato_ko_periodo T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_stato_periodo_prec T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_stato_file_non_trovato T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_date DATE;
        v_count NUMBER := 0;

    BEGIN
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'INIZIO');
        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';
        SELECT VALORE_COSTANTE INTO v_stato_ko_periodo FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_KO_PERIODO';
        SELECT VALORE_COSTANTE INTO v_stato_periodo_prec FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_PERIODO_PRECEDENTE';
        SELECT VALORE_COSTANTE INTO v_stato_file_non_trovato FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_FILE_NON_TROVATO';

        IF(FND_MCRE0_checkPeriodo(seq,p_file,v_date)) THEN

            UPDATE T_MCRE0_WRK_ACQUISIZIONE
            SET PERIODO_RIFERIMENTO = v_date,
                STATO = v_stato_ok,
                TMS_STATO = SYSDATE
            WHERE
                NOME_FILE = p_file AND
                (STATO IS NULL OR STATO = v_stato_file_non_trovato);
                PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'T_MCRE0_WRK_ACQUISIZIONE aggiornata con PERIODO_RIFERIMENTO= '|| v_date ||' STATO = '|| v_stato_ok );
        ELSE

            UPDATE T_MCRE0_WRK_ACQUISIZIONE
            SET STATO = v_stato_ko_periodo,
                TMS_STATO = SYSDATE
            WHERE
                NOME_FILE = p_file AND
                STATO IS NULL;
                PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'T_MCRE0_WRK_ACQUISIZIONE aggiornata con v_stato_ko_periodo');
        END IF;

        DELETE FROM  T_MCRE0_WRK_ACQUISIZIONE b
        WHERE b.COD_FILE = (SELECT COD_FILE FROM T_MCRE0_WRK_ACQUISIZIONE WHERE NOME_FILE = p_file)
        AND b.PERIODO_RIFERIMENTO = (SELECT PERIODO_RIFERIMENTO FROM T_MCRE0_WRK_ACQUISIZIONE WHERE NOME_FILE = p_file)
        and b.STATO = 'CARICATO' ;
        commit;

        UPDATE T_MCRE0_WRK_ACQUISIZIONE b
        SET b.STATO = v_stato_periodo_prec
        WHERE
            b.NOME_FILE = p_file AND
            b.PERIODO_RIFERIMENTO < (SELECT MAX(c.PERIODO_RIFERIMENTO)
                                     FROM T_MCRE0_WRK_ACQUISIZIONE c
                                     WHERE c.COD_FILE = b.COD_FILE);
        COMMIT;

        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'T_MCRE0_WRK_ACQUISIZIONE aggiornata con '|| v_stato_periodo_prec);
        SELECT COUNT(*) INTO v_count
        FROM T_MCRE0_WRK_ACQUISIZIONE
        WHERE
            NOME_FILE = p_file AND
            STATO = v_stato_ok;

        if (v_count = 1) then
            PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'OK - '||'v_count = '|| v_count);
        else
            PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'ERRORE PERIODO_RIF - v_count = '|| v_count);
        end if;
        
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'FINE');
        
        RETURN (v_count = 1);

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, c_nome, SQLERRM);
            ROLLBACK;
            RETURN FALSE;

    END FND_MCRE0_checkIn;   

    FUNCTION FND_MCRE0_checkPeriodo(seq IN NUMBER, p_file IN VARCHAR2, p_date OUT DATE) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_checkPeriodo';
        v_work_dir T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_ext_table T_MCRE0_WRK_ANAGRAFICA.TAB_AUX_ESTERNA%TYPE;
        v_sql VARCHAR2(255);
        v_periodo VARCHAR2(20);
        v_flag BOOLEAN := FALSE;

    BEGIN
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'INIZIO');
        SELECT VALORE_COSTANTE INTO v_work_dir FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'WORK_DIRECTORY';

        SELECT b.TAB_AUX_ESTERNA INTO v_ext_table
        FROM
            T_MCRE0_WRK_ANAGRAFICA b,
            T_MCRE0_WRK_ACQUISIZIONE c
        WHERE
            c.NOME_FILE = p_file AND
            b.COD_FILE = c.COD_FILE AND
            c.TMS_FILE BETWEEN b.DATA_INIZIO_VALIDITA AND b.DATA_FINE_VALIDITA;


        v_sql := 'SELECT TRIM(PERIODO_RIF) FROM ' || v_ext_table || ' WHERE ROWNUM = 1';

        IF(FND_MCRE0_alterTable(seq,v_ext_table,v_work_dir,p_file)) THEN
            EXECUTE IMMEDIATE v_sql INTO v_periodo;
            PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'v_periodo '|| v_periodo);
            v_flag := FND_MCRE0_string2date(seq,v_periodo,p_date);
        END IF;

        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'END');
        RETURN v_flag;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, c_nome, SQLERRM);
            RETURN FALSE;

    END FND_MCRE0_checkPeriodo;
    
    FUNCTION FND_MCRE0_checkPeriodo(seq IN NUMBER, p_file IN VARCHAR2) RETURN BOOLEAN IS

        v_date DATE;

    BEGIN
        RETURN FND_MCRE0_checkPeriodo(seq,p_file,v_date);
    END FND_MCRE0_checkPeriodo;

    FUNCTION FND_MCRE0_get_master_function(seq IN NUMBER, p_file IN VARCHAR2) RETURN VARCHAR2 IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.get_master_function';
        v_stato_ok T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_master_FUNCTION T_MCRE0_WRK_ANAGRAFICA.FUNZIONE_MASTER%TYPE;

    BEGIN
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'INIZIO');
        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

        SELECT b.FUNZIONE_MASTER INTO v_master_function
        FROM
            T_MCRE0_WRK_ANAGRAFICA b,
            T_MCRE0_WRK_ACQUISIZIONE c
        WHERE
            c.NOME_FILE = p_file AND
            c.STATO = v_stato_ok AND
            b.COD_FILE = c.COD_FILE AND
            c.TMS_FILE BETWEEN b.DATA_INIZIO_VALIDITA AND b.DATA_FINE_VALIDITA;

        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'FINE');

        RETURN v_master_function;

    EXCEPTION

        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, c_nome, SQLERRM);            
            RETURN NULL;

    END FND_MCRE0_get_master_function;

    FUNCTION FND_MCRE0_esegui_master(seq IN NUMBER, funzione IN VARCHAR2, p_file IN VARCHAR2) RETURN NUMBER IS

        v_result NUMBER;
        v_FUNCTION VARCHAR2(255) := 'PKG_MCRE0_FUNZIONI_MASTER.' || funzione;

    BEGIN
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, v_FUNCTION, 'INIZIO');
        EXECUTE IMMEDIATE 'CALL ' || v_FUNCTION || '(:seq , :p_file) INTO :v_result' USING IN seq, p_file, OUT v_result;
        PKG_MCRE0_AUDIT.log_etl (seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, v_FUNCTION, 'FINE');
        RETURN v_result;

    END FND_MCRE0_esegui_master;

    PROCEDURE SPO_MCRE0_clean_log_tables(p_seq IN NUMBER) IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.svecchiamento_log_tables';
        v_stato_ok T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_periodo DATE;
        v_mesi_svecchiamento NUMBER;

    BEGIN

        PKG_MCRE0_AUDIT.log_etl (p_seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'INIZIO');
        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

        BEGIN
            SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
            FROM T_MCRE0_WRK_CONFIGURAZIONE
            WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_EVENTI_PROCESSI_LOG';

        EXCEPTION
            WHEN OTHERS THEN
                v_mesi_svecchiamento := 0;
                                
        END;

        IF(v_mesi_svecchiamento > 0) THEN

            SELECT MAX(PERIODO_RIFERIMENTO) INTO v_periodo
            FROM T_MCRE0_WRK_ACQUISIZIONE WHERE STATO = v_stato_ok;

            DELETE T_MCRE0_WRK_LOG_EVENTI WHERE TO_CHAR(TMS,'YYYYMM') <= TO_CHAR(ADD_MONTHS(v_periodo,-v_mesi_svecchiamento),'YYYYMM');

            COMMIT;

        END IF;

        PKG_MCRE0_AUDIT.log_etl (p_seq, c_package, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, c_nome, 'FINE');

    END SPO_MCRE0_clean_log_tables;

    FUNCTION FND_MCRE0_process_file(p_file IN VARCHAR2) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.process_file';
        v_master_FUNCTION T_MCRE0_WRK_ACQUISIZIONE.NOME_FILE%TYPE;
        v_result NUMBER := -1;
        v_return boolean;
        v_seq NUMBER;
        v_count NUMBER;


    BEGIN

        SELECT SEQ_MCRE0_FLUSSO.NEXTVAL INTO v_seq FROM DUAL;


        UPDATE
                T_MCRE0_WRK_ACQUISIZIONE
        SET
                ID_FLUSSO = v_seq
        WHERE   NOME_FILE = p_file;
        COMMIT;

        IF(FND_MCRE0_checkIn(v_seq,p_file)) THEN


            select count(*)
            into v_count
            from T_MCRE0_WRK_ACQUISIZIONE
            where
            PERIODO_RIFERIMENTO = (SELECT PERIODO_RIFERIMENTO
                                    FROM T_MCRE0_WRK_ACQUISIZIONE
                                    WHERE ID_FLUSSO = v_seq)
            and STATO= 'CARICATO';


--            IF v_count = 0 then

--            v_count:=PKG_MCRE0_AGGIORNA_MV.drop_snp_log;

--            --chiudo il portale web
--             update T_MCRE0_WRK_CONFIGURAZIONE
--             set VALORE_COSTANTE = 0
--             where NOME_COSTANTE = 'STATO_PORTALE';

--            end if;


                v_master_FUNCTION := FND_MCRE0_get_master_function(v_seq,p_file);
               --DBMS_OUTPUT.PUT_LINE('FND_MCRE0_get_master_function ESEGUITA: '|| v_master_FUNCTION);


                v_result := FND_MCRE0_esegui_master(v_seq,v_master_FUNCTION,p_file);
               --DBMS_OUTPUT.PUT_LINE('FND_MCRE0_esegui_master ESEGUITA: '|| v_result);



        END IF;


         RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

            --DBMS_OUTPUT.PUT_LINE('ERRORE in FND_MCRE0_process_file');

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(v_seq,c_nome, 'ERRORE nella chiamata alla funzione '''|| NVL(v_master_function,'NULL') || '''' ,SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_process_file;


      FUNCTION FND_MCRE0_get_cur_fnd_slv(seq IN NUMBER, p_file IN VARCHAR2, p_ext_table IN VARCHAR2) RETURN cur_func_type IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_get_cur_funzione_slave';

        v_stato_ok T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_cur cur_func_type;

    BEGIN

        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

        OPEN v_cur FOR
        SELECT d.FUNZIONE_SLAVE
        FROM
            T_MCRE0_WRK_ANAGRAFICA b,
            T_MCRE0_WRK_ACQUISIZIONE c,
            T_MCRE0_WRK_ELABORAZIONE d
        WHERE
            c.NOME_FILE = p_file AND
            c.STATO = v_stato_ok AND
            b.COD_FILE = c.COD_FILE AND
            b.COD_FILE = d.COD_FILE AND
            d.TAB_ESTERNA = p_ext_table AND
            d.FLG_ATTIVA_FUNZIONE = 1 AND
            c.TMS_FILE BETWEEN b.DATA_INIZIO_VALIDITA AND b.DATA_FINE_VALIDITA AND
            c.TMS_FILE BETWEEN d.DATA_INIZIO_VALIDITA AND d.DATA_FINE_VALIDITA
        ORDER BY
            d.TAB_TRG,
            d.ORDINE_FUNZIONE;

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'OK');

        RETURN v_cur;

    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN NULL;

    END FND_MCRE0_get_cur_fnd_slv;

   FUNCTION FND_MCRE0_get_ext_table(seq IN NUMBER, p_file IN VARCHAR2) RETURN VARCHAR2 IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_get_ext_table';

        v_stato_ok T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_ext_table T_MCRE0_WRK_ELABORAZIONE.TAB_ESTERNA%TYPE;

    BEGIN

        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

        SELECT DISTINCT nvl(c.TAB_ESTERNA, 'ERROR') INTO v_ext_table
        FROM
            T_MCRE0_WRK_ACQUISIZIONE b,
            T_MCRE0_WRK_ELABORAZIONE c
        WHERE
            b.NOME_FILE = p_file AND
            b.STATO = v_stato_ok AND
            b.COD_FILE = c.COD_FILE AND
            b.TMS_FILE BETWEEN c.DATA_INIZIO_VALIDITA AND c.DATA_FINE_VALIDITA;

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'OK p_file: '||p_file);

        RETURN v_ext_table;

    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE. p_file: '||p_file,SUBSTR(SQLERRM, 1, 255));

            RETURN NULL;

    END FND_MCRE0_get_ext_table;


FUNCTION FND_MCRE0_get_trg_table(seq IN NUMBER, p_file IN VARCHAR2) RETURN VARCHAR2 IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_get_trg_table';

        v_stato_ok T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_trg_table T_MCRE0_WRK_ELABORAZIONE.TAB_TRG%TYPE;

    BEGIN

        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

        SELECT DISTINCT d.TAB_TRG INTO v_trg_table
        FROM
            T_MCRE0_WRK_ANAGRAFICA b,
            T_MCRE0_WRK_ACQUISIZIONE c,
            T_MCRE0_WRK_ELABORAZIONE d
        WHERE
            c.NOME_FILE = p_file AND
            c.STATO = v_stato_ok AND
            b.COD_FILE = c.COD_FILE AND
            b.COD_FILE = d.COD_FILE AND
            c.TMS_FILE BETWEEN b.DATA_INIZIO_VALIDITA AND b.DATA_FINE_VALIDITA AND
            c.TMS_FILE BETWEEN d.DATA_INIZIO_VALIDITA AND d.DATA_FINE_VALIDITA;

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'OK');

        RETURN v_trg_table;

    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN NULL;

    END FND_MCRE0_get_trg_table;

       


 FUNCTION FND_MCRE0_get_slave_param(seq IN NUMBER, p_file IN VARCHAR2) RETURN f_slave_par_type IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_get_slave_param';

        v_slave_par f_slave_par_type;

    BEGIN

        v_slave_par := FND_MCRE0_get_slave_param_sic(seq, p_file);

        v_slave_par.TAB_EXT := PKG_MCRE0_UTILS.FND_MCRE0_GET_EXT_TABLE(v_slave_par.SEQ_FLUSSO,p_file);
         --DBMS_OUTPUT.PUT_LINE('FND_MCRE0_GET_EXT_TABLE ESEGUITA: '|| v_slave_par.TAB_EXT);

        v_slave_par.TAB_TRG := PKG_MCRE0_UTILS.FND_MCRE0_get_trg_table(v_slave_par.SEQ_FLUSSO,p_file,v_slave_par.TAB_EXT);
          --DBMS_OUTPUT.PUT_LINE('FND_MCRE0_GET_TRG_TABLE ESEGUITA: '|| v_slave_par.TAB_TRG);

      --   v_slave_par.TAB_APP := PKG_MCRE0_UTILS.FND_MCRE0_get_app_table(v_slave_par.SEQ_FLUSSO,p_file,v_slave_par.TAB_EXT);
          --   DBMS_OUTPUT.PUT_LINE('FND_MCRE0_GET_APP_TABLE ESEGUITA: '|| v_slave_par.TAB_APP);

        RETURN v_slave_par;

    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE' ,SUBSTR(SQLERRM, 1, 255));

            RETURN NULL;

    END FND_MCRE0_get_slave_param;



        FUNCTION FND_MCRE0_get_trg_table(seq IN NUMBER, p_file IN VARCHAR2, p_ext_tab IN VARCHAR2) RETURN VARCHAR2 IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_get_trg_table';

        v_stato_ok T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_trg_table T_MCRE0_WRK_ELABORAZIONE.TAB_TRG%TYPE;

    BEGIN

        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

        SELECT DISTINCT d.TAB_TRG INTO v_trg_table
        FROM
            T_MCRE0_WRK_ANAGRAFICA b,
            T_MCRE0_WRK_ACQUISIZIONE c,
            T_MCRE0_WRK_ELABORAZIONE d
        WHERE
            c.NOME_FILE = p_file AND
            c.STATO = v_stato_ok AND
            b.COD_FILE = c.COD_FILE AND
            b.COD_FILE = d.COD_FILE AND
            d.TAB_ESTERNA = p_ext_tab AND
            c.TMS_FILE BETWEEN b.DATA_INIZIO_VALIDITA AND b.DATA_FINE_VALIDITA AND
            c.TMS_FILE BETWEEN d.DATA_INIZIO_VALIDITA AND d.DATA_FINE_VALIDITA;

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'OK');

        RETURN v_trg_table;

    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN NULL;

    END FND_MCRE0_get_trg_table;


        FUNCTION FND_MCRE0_get_slave_param_sic(seq IN NUMBER, p_file IN VARCHAR2) RETURN f_slave_par_type IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_get_slave_param_sic';

        v_slave_par f_slave_par_type := f_slave_par_type(seq,p_file,NULL,NULL,NULL,NULL);

    BEGIN

        SELECT PERIODO_RIFERIMENTO
        INTO v_slave_par.PERIODO
        FROM T_MCRE0_WRK_ACQUISIZIONE
        WHERE NOME_FILE = p_file;

        RETURN v_slave_par;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE' ,SUBSTR(SQLERRM, 1, 255));

            RETURN NULL;

    END FND_MCRE0_get_slave_param_sic;



/* FUNCTION FND_MCRE0_get_app_table(seq IN NUMBER, p_file IN VARCHAR2, p_ext_tab IN VARCHAR2) RETURN VARCHAR2 IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_get_app_table';

        v_stato_ok T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_app_table T_MCRE0_WRK_ELABORAZIONE.TAB_APP%TYPE;

    BEGIN

        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

        SELECT DISTINCT d.TAB_APP INTO v_app_table
        FROM
            T_MCRE0_WRK_ANAGRAFICA b,
            T_MCRE0_WRK_ACQUISIZIONE c,
            T_MCRE0_WRK_ELABORAZIONE d
        WHERE
            c.NOME_FILE = p_file AND
            c.STATO = v_stato_ok AND
            b.COD_FILE = c.COD_FILE AND
            b.COD_FILE = d.COD_FILE AND
            d.TAB_ESTERNA = p_ext_tab AND
            c.TMS_FILE BETWEEN b.DATA_INIZIO_VALIDITA AND b.DATA_FINE_VALIDITA AND
            c.TMS_FILE BETWEEN d.DATA_INIZIO_VALIDITA AND d.DATA_FINE_VALIDITA;

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'OK');

        RETURN v_app_table;

    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN NULL;

    END FND_MCRE0_get_app_table;*/


    FUNCTION FND_MCRE0_execute(p_param1 IN VARCHAR2,
                                p_param2 IN VARCHAR2,
                                p_param3 IN VARCHAR2,
                                p_param4 IN VARCHAR2) RETURN BOOLEAN is

        c_nome CONSTANT VARCHAR2(50) := c_package || '.SPO_MCRE0_execute';

 begin

 --DBMS_OUTPUT.PUT_LINE(p_param1 || p_param2 || p_param3 || p_param4);
 EXECUTE IMMEDIATE p_param1 || p_param2 || p_param3 || p_param4;
 --DBMS_OUTPUT.PUT_LINE('OK');

 PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(0,c_nome,'OK', 'ESEGUITO');

 RETURN TRUE;


 EXCEPTION
 WHEN OTHERS THEN

  PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(0,c_nome,'ERRORE' ,SUBSTR(SQLERRM, 1, 255));
 -- DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
  RETURN FALSE;

 end FND_MCRE0_execute;

 --v1,1
 FUNCTION fnd_mcre0_chiudi_portale return number is

 dta date;
 idper number;
 esito number := 0;
 seq number;

 begin

     select SEQ_MCR0_LOG_ETL.nextval into seq from dual;

     --disabilito funzioni dispositive
--     DELETE FROM T_MCRE0_APP_PR_GRUPPI_FUNZIONI F
--     WHERE F.ID_FUNZIONE IN (20,30);

     --chiudo il portale web
     update T_MCRE0_WRK_CONFIGURAZIONE
     set VALORE_COSTANTE = 0
     where NOME_COSTANTE = 'STATO_PORTALE';

--     --marco tutti gli abi come Non Elaborati
--     --1. inserisco riga fittizia in Abi Elaborati
--     select max(dta_elaborazione)+1, max(id_dper)
--     into dta, idper
--     from t_mcre0_app_abi_elaborati;
--
--     insert into MCRE_OWN.T_MCRE0_APP_ABI_ELABORATI
--        (COD_ABI_ISTITUTO, DTA_ELABORAZIONE, TMS_ULTIMA_ELABORAZIONE, ID_DPER)
--     values( '99999', dta, sysdate, idper);
--     commit;
--
--     --2. aggiorno MV per marcare tutti gli abi non elaborati
--     esito := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_ISTITUTI;
--
--     --3. rimuovo la riga fittizia
--     delete T_MCRE0_APP_ABI_ELABORATI
--     where cod_abi_istituto = '99999';
     commit;

     PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'fnd_mcre0_chiudi_portale', 2, SQLCODE, 'portale chiuso', 'esito: '||esito );
     return esito;

 exception when others then
     PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'fnd_mcre0_chiudi_portale', 2, SQLCODE, sqlerrm, 'portale NON chiuso: esito: '||esito );
     return esito;

 end;

 FUNCTION fnd_mcre0_apri_portale return number is

 esito number := 1;
 seq number;

 begin

     select SEQ_MCR0_LOG_ETL.nextval into seq from dual;

     --riabilito funzioni dispositive
--     Insert into T_MCRE0_APP_PR_GRUPPI_FUNZIONI (ID_GRUPPO,ID_FUNZIONE,ID_AREA_LAVORO)
--        select ID_GRUPPO,ID_FUNZIONE,ID_AREA_LAVORO
--        from T_MCRE0_APP_PR_GRUPPI_FUNZIONI F
--        WHERE F.ID_FUNZIONE IN (20,30);

     --riapro il portale web
     update T_MCRE0_WRK_CONFIGURAZIONE
     set VALORE_COSTANTE = 1
     where NOME_COSTANTE = 'STATO_PORTALE';

     commit;

--   esito := MCRE_OWN.PKG_MCRE0_AGGIORNA_MV.AGGIORNA_ISTITUTI;

     PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'fnd_mcre0_apri_portale', 2, SQLCODE, 'portale aperto', 'esito: '||esito );
     return esito;

 exception when others then
     PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'fnd_mcre0_apri_portale', 2, SQLCODE, sqlerrm, 'portale NON chiuso: esito: '||esito );
     return 0;

 end;

 FUNCTION fnd_mcre0_controlli return number is
 
--    cursor c1 is
--    select  a.COD_FILE, a.NOME_FILE, a.TMS_FILE, a.PERIODO_RIFERIMENTO
--    from    t_mcre0_wrk_acquisizione a
--    where   a.PERIODO_RIFERIMENTO = (select max(periodo_riferimento) from t_mcre0_wrk_acquisizione);

--    rec1    c1%ROWTYPE;

--    cursor c1b is
--    select trunc(dta_ins)-1 periodo_riferimento, min(dta_ins) partenza, max(dta_ins) fine, round((max(dta_ins)-min (dta_ins)) *1440,0) totmin
--    from T_MCRE0_WRK_AUDIT_ETL
--    where
--     (        
--        procedura like '1%' or
--        procedura like '2%' or
--        procedura like '3%' or
--        procedura like '4%' or
--        procedura like '5%' or
--        procedura like '6%' or
--        procedura like '7%' or
--        procedura like '8%' or
--        procedura like '9%'
--    )
--    group by trunc(dta_ins)
--    order by trunc(dta_ins) desc;

--    rec1b    c1b%ROWTYPE;

--    cursor c2A is 
--    select  a.COD_ABI_CARTOLARIZZATO, b.COD_MACROSTATO,  a.COD_STATO, a.COD_PROCESSO ,count(*) conteggio
--    from    V_MCRE0_APP_HP_EXCEL a, t_mcre0_app_stati b
--    where   a.desc_COMPARTO like 'Ufficio%'
--    and     a.COD_STATO = b.COD_MICROSTATO
--    and     a.FLG_OUTSOURCING = 'Y'
--    and     a.COD_PROCESSO in ('GF','GI','GR','GC','GL','GP','EG','CG')
--    group by a.COD_STATO, a.COD_ABI_CARTOLARIZZATO, a.COD_PROCESSO,  b.COD_MACROSTATO
--    order by 1, 2, 3, 4;

--    rec2A    c2A%ROWTYPE;

--    CURSOR C2B IS
--    select a.COD_COMPARTO,b.COD_MACROSTATO, a.COD_STATO , a.COD_PROCESSO , count(*) conteggio
--    from V_MCRE0_APP_HP_EXCEL a, t_mcre0_app_stati b
--    where a.desc_COMPARTO like 'Ufficio%'
--    and   a.COD_STATO = b.COD_MICROSTATO
--    and a.FLG_OUTSOURCING = 'Y'
--    and a.COD_PROCESSO in ('GF','GI','GR','GC','GL','GP','EG','CG')
--    group by a.COD_STATO, a.COD_PROCESSO ,  a.COD_COMPARTO, b.COD_MACROSTATO
--    order by 1, 2, 3, 4;

--    REC2B C2B%ROWTYPE;

--    CURSOR C3 IS
--    select a.COD_GE, a.DESC_GE , b.COD_MACROSTATO ,a.COD_STATO ,count(*) conteggio
--    from V_MCRE0_APP_HP_EXCEL a,  t_mcre0_app_stati b
--    where a.desc_COMPARTO like 'Ufficio%'
--    and a.COD_STATO = b.COD_MICROSTATO
--    and a.FLG_OUTSOURCING = 'Y'
--    and a.COD_PROCESSO in ('GF','GI','GR','GC','GL','GP','EG','CG')
--    group by  a.COD_GE, a.DESC_GE ,a.COD_STATO, b.COD_MACROSTATO 
--    order by 1, 2, 3, 4;

--    REC3 C3%ROWTYPE;

--    quanti number;

--    CURSOR C6 IS
--    select  a.FLG_CAMBIO_STATO, 
--            min(DTA_FINE_VALIDITA) Prima_storicizzazione, max(DTA_FINE_VALIDITA) Ultima_storicizzazione,  count(distinct cod_sndg) quanti
--    from    t_mcre0_app_Storico_eventi a
--    where   a.DTA_FINE_VALIDITA >= (select  trunc(max(a.tms_file))
--                                    from    T_MCRE0_WRK_ACQUISIZIONE a )
--    group by a.FLG_CAMBIO_STATO;

--    REC6 C6%ROWTYPE;

--    CURSOR C7 IS
--    select 
--        trunc(a.DTA_FINE_VALIDITA) Data_Evento, 
--        a.COD_GRUPPO_super,
--        count(distinct a.COD_ABI_CARTOLARIZZATO||COD_NDG) num_pos,
--        sum( FLG_CAMBIO_STATO) CAMBIO_STATO,
--        sum(a.FLG_CAMBIO_COMPARTO) CAMBIO_COMP, 
--        sum(a.FLG_CAMBIO_GESTORE) CAMBIO_GEST
--    from MCRE_OWN.T_MCRE0_APP_STORICO_EVENTI a
--    where
--    trunc(a.DTA_FINE_VALIDITA) = (select  trunc(max(a.tms_file))
--                                  from    T_MCRE0_WRK_ACQUISIZIONE a )
--    group by a.COD_GRUPPO_super,trunc(a.DTA_FINE_VALIDITA)
--    order by 2;

--    REC7 C7%ROWTYPE;

--    CURSOR C8 IS
--    select  a.COD_STATO, count(*) conteggio
--    from    V_MCRE0_APP_HP_EXCEL a
--    where   a.COD_STATO <> 'SO'
--    group by a.COD_STATO
--    order by 1;

--    REC8 C8%ROWTYPE;
-- 
--    CURSOR C9 IS
--    select distinct cod_comparto_assegnato, nullif(cod_stato, '-1') stato, flg_outsourcing
--    from t_mcre0_app_all_data
--    where cod_comparto_assegnato in ('12207', '12208')
--    and flg_outsourcing = 'Y'
--    order by 1,3,2;
--    
--    REC9 C9%ROWTYPE;
 
    seq NUMBER;
    ord number:=0;
 
 begin
 
--    execute immediate 'truncate table T_MCRE0_WRK_CONTROLLI';
    
    select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
    
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord,'Punto 1: Tempi ETL primo livello:');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord,'COD_FILE;NOME_FILE;TMS_FILE;PERIODO_RIFERIMENTO');
--    ord:=ord+1;
--    open c1;
--        LOOP
--            FETCH c1 INTO rec1;
--            EXIT WHEN c1%NOTFOUND;                
--                INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, rec1.COD_FILE||';'||rec1.NOME_FILE||';'||to_char(rec1.TMS_FILE, 'dd/mm/yyyy hh:mi:ss')||';'||rec1.PERIODO_RIFERIMENTO);
--        END LOOP;        
--    close c1;
--    commit;
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Punto 1b: Tempi ETL secondo livello:');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Giorno;Orario inizio;Orario fine;Tempo totale');
--    ord:=ord+1;
--    open c1b;
--        LOOP
--            FETCH c1b INTO rec1b;
--            EXIT WHEN c1b%NOTFOUND;                
--                INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, rec1b.periodo_riferimento||';'||to_char(rec1B.partenza, 'dd/mm/yyyy hh:mi:ss')||';'||to_char(rec1B.fine, 'dd/mm/yyyy hh:mi:ss')||';'||rec1B.TOTMIN);
--        END LOOP;        
--    close c1b;
--    commit;
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Punto 2: Controllo quante posizioni ci sono per stato (per ABI):');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'ABI;Macrostato;Stato;Processo;Conteggio');
--    ord:=ord+1;
--    open c2A;    
--        LOOP 
--            FETCH c2A INTO rec2A;
--            EXIT WHEN c2A%NOTFOUND;
--                INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, REC2A.COD_ABI_CARTOLARIZZATO||';'||REC2A.COD_MACROSTATO||';'||REC2A.COD_STATO||';'||REC2A.COD_PROCESSO||';'||REC2A.conteggio );           
--        END LOOP;    
--    close c2A;
--    commit;
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Punto 2: Controllo quante posizioni ci sono per stato (per COMPARTO):');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Comparto;Macrostato;Stato;Processo;Conteggio');
--    ord:=ord+1;
--    open c2B;    
--        LOOP 
--            FETCH c2B INTO rec2B;
--            EXIT WHEN c2B%NOTFOUND;
--                INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, REC2B.COD_COMPARTO||';'||REC2B.COD_MACROSTATO||';'||REC2B.COD_STATO||';'||REC2B.COD_PROCESSO||';'||REC2B.conteggio);           

--        END LOOP;
--    
--    close c2B;
--    commit;
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Punto 3: Controllo quanti gruppi ci sono per stato:');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Cod_GE;Gruppo_economico;Macrostato;Stato;Conteggio');
--    ord:=ord+1;
--    open c3;    
--        LOOP 
--            FETCH c3 INTO rec3;
--            EXIT WHEN c3%NOTFOUND;        
--                INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, REC3.COD_GE||';'||REC3.DESC_GE||';'||REC3.COD_MACROSTATO||';'||REC3.COD_STATO||';'||REC3.conteggio );           
--        END LOOP;   
--    close c3;
--    commit;
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Punto 4: Controllo se esistono Gruppi super a null:');
--    ord:=ord+1;
--    select  count(*) conteggio into quanti
--    from    t_mcre0_app_file_guida a
--    where   a.ID_DPER=(select max(id_dper) from t_mcre0_app_file_guida)
--    AND        A.COD_GRUPPO_SUPER IS NULL;
--    
--    if quanti = 0 then
--        INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Nessun Gruppo Super a null');
--    else
--        INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Ci sono '||quanti||' record con Gruppo Super null');
--    end if;
--    commit;
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Punto 6: Controllo numero cambi stato automatici:');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'FLG_CAMBIO_STATO;Prima_storicizzazione;Ultima_storicizzazione;quanti');
--    ord:=ord+1;
--    open c6;    
--        LOOP 
--            FETCH C6 INTO rec6;
--            EXIT WHEN c6%NOTFOUND;        
--                INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, REC6.FLG_CAMBIO_STATO||';'||REC6.Prima_storicizzazione||';'||REC6.Ultima_storicizzazione||';'||REC6.quanti);         
--        END LOOP;            
--    close c6;
--    commit;
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Punto 7: Controlliamo il numero di posizioni che hanno cambiato stato, comparto o gestore (per gruppo super) ieri:');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Data_Evento;COD_GRUPPO_super;num_pos;CAMBIO_STATO;CAMBIO_COMP;CAMBIO_GEST');
--    ord:=ord+1;
--    open c7;            
--        LOOP 
--            FETCH C7 INTO rec7;
--            EXIT WHEN c7%NOTFOUND;        
--                INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, REC7.Data_Evento||';'||REC7.COD_GRUPPO_super||';'||REC7.num_pos||';'||REC7.CAMBIO_STATO||';'||REC7.CAMBIO_COMP||';'||REC7.CAMBIO_GEST);         
--        END LOOP;            
--    close c7;
--    commit;
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Punto 8: Controlliamo il numero di posizioni per stato');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'STATO;Conteggio');
--    ord:=ord+1;
--    open c8;    
--        LOOP 
--            FETCH C8 INTO rec8;
--            EXIT WHEN c8%NOTFOUND;        
--                INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, REC8.COD_STATO||';'||REC8.Conteggio);         
--        END LOOP;    
--    close c8;
--    commit;
--    
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Punto 9: elenco stati sui due comparti, per pos in outsoucing');
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'COD_COMPARTO_ASSEGNATO;Stato;Flg_outsourcing');
--    ord:=ord+1;
--    open c9;    
--        LOOP 
--            FETCH C9 INTO rec9;
--            EXIT WHEN c9%NOTFOUND;        
--                INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, REC9.cod_comparto_assegnato||';'||REC9.Stato||';'||REC9.flg_outsourcing);         
--        END LOOP;    
--    close c9;
--    commit;
--    
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' '); 
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');   
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Punto 10: eventuali incagli sui comparti di divisione, in outsourcing:');
--    ord:=ord+1;
--    
--    select count(*) into quanti
--    from t_mcre0_app_all_data  
--    where cod_comparto_assegnato in ('12207', '12208') 
--    and cod_stato = 'IN' and flg_outsourcing = 'Y';
--        
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Ci sono '||quanti||' incagli sui comparti di divisione, in outsourcing'); 
--    commit;
--        
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');    
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Punto 11: eventuali pos di direzione trascinate sulla divisione:');
--    ord:=ord+1;
--    
--    select count(*) into quanti
--    from t_mcre0_app_all_data 
--    where cod_comparto_calcolato = '011901' 
--    and cod_comparto_assegnato in ('12207', '12208');
--        
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Ci sono '||quanti||' pos di direzione trascinate sulla divisione'); 
--    commit;
--    
--           
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' ');   
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, ' '); 
--    ord:=ord+1;
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Punto 12: posizioni passate da gestore di direzione a gestore di divisione:');
--    ord:=ord+1;
--    
--    select count(*) into quanti
--    from t_mcre0_app_all_data d, t_mcre0_app_utenti u
--    where cod_comparto_assegnato in ('12207','12208') 
--    and id_utente_pre = u.id_utente
--    and u.cod_comparto_utente not  in  ('12207','12208') ;
--        
--    INSERT INTO T_MCRE0_WRK_CONTROLLI (ORDINE, RIGA) VALUES( ord, 'Ci sono '||quanti||' posizioni passate da gestore di direzione a gestore di divisione'); 
--    commit;
    
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'fnd_mcre0_controlli - INI - controllo acquisizione flussi', 3, SQLCODE, sqlerrm, 'Inizio - controllo acquisizione flussi' );
    MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ.SPO_MCRE0_CONTROLLO_ACQ_ALL;
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'fnd_mcre0_controlli - END - controllo acquisizione flussi', 3, SQLCODE, sqlerrm, 'Fine - controllo acquisizione flussi' );
    RETURN 1;
 
 exception when others then
     PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'fnd_mcre0_controlli', 2, SQLCODE, sqlerrm, 'ECCEZIONE' );
     return 0;
 
 end;

FUNCTION fnd_mcre0_controlli2 return number is
 
    seq NUMBER;
    ord number:=0;
 
 begin
    
    select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'inizio controlli', 3, SQLCODE, sqlerrm, 'Inizio');
    
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'fnd_mcre0_controlli - INI - controllo acquisizione flussi', 3, SQLCODE, sqlerrm, 'Inizio - controllo acquisizione flussi' );
    MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ.SPO_MCRE0_CONTROLLO_ACQ_ALL;
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'fnd_mcre0_controlli - END - controllo acquisizione flussi', 3, SQLCODE, sqlerrm, 'Fine - controllo acquisizione flussi' );
    RETURN 1;
 
 exception when others then
     PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'fnd_mcre0_controlli', 2, SQLCODE, sqlerrm, 'ECCEZIONE' );
     return 0;
 
 end;

    FUNCTION fnd_mcre0_analyzeWeekly return number is
    
    v_function varchar2(50) := 'fnd_mcre0_analyzeWeekly';
    seq number;
    ok number := 0;       --usare sempre  0 per ok e 1 per ko 
    ko number := 1;
    V_ESITO number := 0; -- variabile per calcolo CR...
    
    cursor c_tab is
        select  table_name
        from    T_MCRE0_WRK_STATISTICHE
        WHERE   WEEKEND='1'
        order   by week_ordine asc, table_type asc;
    
--    r_tab       c_tab%ROWTYPE;
    RetVal      BOOLEAN;
    PSCHEMA     VARCHAR2(30) := 'MCRE_OWN';
    PTABLE      VARCHAR2(30);
    PPARTITION  VARCHAR2(100);   
    
    begin        
        select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
        PKG_MCRE0_AUDIT.LOG_ETL ( seq, v_function, PKG_MCRE0_AUDIT.C_DEBUG , SQLCODE, sqlerrm, 'INIZIO' );
        
        open c_tab;
                
        LOOP
           FETCH c_tab INTO ptable;
           EXIT WHEN c_tab%NOTFOUND;    
           PKG_MCRE0_AUDIT.LOG_ETL ( seq, v_function, PKG_MCRE0_AUDIT.C_DEBUG , SQLCODE, sqlerrm, 'analizzo la tabella: '||ptable );
              select  PART_NAME into PPARTITION
              from    T_MCRE0_WRK_STATISTICHE
              where   table_name = ptable;
                           
              RetVal := MCRE_OWN.PKG_MCRE0_ANALYZE.FND_MCRE0_ANALYZE_TABLE_WEEKLY ( PSCHEMA, ptable, PPARTITION);
              COMMIT; 
            PKG_MCRE0_AUDIT.LOG_ETL ( seq, v_function, PKG_MCRE0_AUDIT.C_DEBUG , SQLCODE, sqlerrm, 'Analizzata tabella: '||ptable||' - partition: '||ppartition );                  
        END LOOP;
    CLOSE c_tab;
    
        
    -- calcolo CR...
--        begin
--                PKG_MCRE0_AUDIT.log_etl (seq, 'FNC_LOAD_CR', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'aggiorno le mv_cr', NULL);
--                V_ESITO:=V_ESITO*PKG_MCRE0_AGGIORNA_MV.AGGIORNA_CR(seq);
--                V_ESITO:=V_ESITO*PKG_MCRE0_AGGIORNA_MV.AGGIORNA_CR_RI(seq);
--                V_ESITO:=V_ESITO*PKG_MCRE0_AGGIORNA_MV.AGGIORNA_CR_SC(seq);
--                V_ESITO:=V_ESITO*PKG_MCRE0_AGGIORNA_MV.AGGIORNA_CR_SO(seq);
--                PKG_MCRE0_AUDIT.LOG_ETL(seq,'aggiorna_CR_ALL',PKG_MCRE0_AUDIT.C_DEBUG,SQLCODE,'Aggiornate MV CR','END');
--        exception when others then
--            PKG_MCRE0_AUDIT.LOG_ETL(seq,'aggiorna_CR_ALL',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'Refresh');
--        end;    
    -- fine calcolo CR....
             
        begin
            RetVal := MCRE_OWN.PKG_MCRE0_SVECCHIAMENTO.FND_MCRE0_SVECCHIAMENTO_WEEKLY;
            COMMIT; 
        exception when others then
            PKG_MCRE0_AUDIT.LOG_ETL(seq,'Svecchiamento settimanale',PKG_MCRE0_AUDIT.C_ERROR,SQLCODE,SQLERRM,'SVECCHIAMENTO');
        end;
    
    return ok;
        
    exception when others then
     PKG_MCRE0_AUDIT.LOG_ETL ( seq, v_function, PKG_MCRE0_AUDIT.C_ERROR, SQLCODE, sqlerrm, 'ECCEZIONE' );
     return ko;
 end;

END PKG_MCRE0_UTILS;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_UTILS FOR MCRE_OWN.PKG_MCRE0_UTILS;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_UTILS FOR MCRE_OWN.PKG_MCRE0_UTILS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_UTILS TO MCRE_USR;

