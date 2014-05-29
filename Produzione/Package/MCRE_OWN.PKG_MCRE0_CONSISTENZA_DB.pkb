CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_CONSISTENZA_DB
IS
/******************************************************************************
   NAME:       PKG_MCRE0_CONSISTENZA_DB
   PURPOSE:    Eseguire un check sulla consistenza del database e fornire un resoconto sullo stesso.

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        05/06/2012 Luca Ferretti       Created this package.
   1.1        19/06/2012 Luca Ferretti       Aggiunta procedura di scrittura clob su file
   1.2        23/12/2012 Luca Ferretti       Modifica calcolo posizioni segnalate
   1.3        03/12/2012 Luca Ferretti       Aggiunta descrizione controllo nella insert
   1.4        04/12/2012 Luca Ferretti       Gestione soglia
******************************************************************************/

v_id_lotto      number default -1;
seq             number;
nome_package    varchar2(50)   := 'PKG_MCRE0_CONSISTENZA_DB';
v_count         number default 0;

FUNCTION FND_MCRE0_MASTER RETURN number IS
/*
 * La funzione cicla sulla tabella T_MCRE0_CL_CONSISTENZA_DB e invoca, per ogni record con flg_attiva=1,
 * la funzione il cui nome è salvato nell'attributo 'procedura'.
 */

    v_nome_procedura varchar2(50) := '.FND_MCRE0_MASTER';
    cursor c_procedure IS
    select  'DECLARE RetVal number; BEGIN RetVal:='||pkg||'.'||procedura||' (:p_id_lotto)'||'; COMMIT; END;' prc
        from    T_MCRE0_CL_CONSISTENZA_DB
        where   FLG_ATTIVA = 1
        order by ordine asc;

    rec_procedure c_procedure%rowtype;
    RetVal number;

    BEGIN
        select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
        select SEQ_CONSISTENZA_DB.nextval into v_id_lotto from dual;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione iniziata');
        open c_procedure;

        LOOP
           FETCH c_procedure INTO rec_procedure;
           EXIT WHEN c_procedure%NOTFOUND;
                PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Lancio procedura '||rec_procedure.prc);
                execute immediate rec_procedure.prc using v_id_lotto;

                PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Procedura '||rec_procedure.prc||' terminata');
        END LOOP;
        CLOSE c_procedure;

        RetVal := MCRE_OWN.PKG_MCRE0_CONSISTENZA_DB.FND_MCRE0_CREATE_FILE;

        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione terminata');

        return ret_ok;

    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm,null);
        return ret_ko;
    END;

FUNCTION FND_MCRE0_chiusura_pratiche (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN number IS

   v_nome_procedura varchar2(50) := '.FND_MCRE0_CHIUSURA_PRATICHE';
   v_clob   clob := null;
   v_soglia number;
   v_desc_controllo varchar2(500);
   esito    number;

   cursor   c_cursor is
    select rec||CHR(10) as rec
        from  V_MCRE0_POS_PRA_CONSISTENZA_DB
        order by rec asc;

    rec_cursor c_cursor%rowtype;

   BEGIN
        select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione iniziata');
        select count(*)-2 into v_count from V_MCRE0_POS_PRA_CONSISTENZA_DB;

        open c_cursor;

        LOOP
           FETCH c_cursor INTO rec_cursor;
           EXIT WHEN c_cursor%NOTFOUND;
           v_clob:=v_clob||rec_cursor.rec;
        END LOOP;
        CLOSE c_cursor;

        select  desc_controllo, soglia
        into    v_desc_controllo, v_soglia
        from    T_MCRE0_CL_CONSISTENZA_DB
        where   1=1
        and     upper('.'||procedura) = v_nome_procedura;

        if v_count < v_soglia
            then    esito := 0;
        else    esito := v_count;
        end if;

        insert into T_MCRE0_CHK_CONSISTENZA_DB
            (id_lotto, procedura, numero, csv, dta_ins, desc_controllo, esito)
            values (p_id_lotto, nome_package||v_nome_procedura, v_count, v_clob, sysdate, v_desc_controllo, esito);

        commit;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione terminata');

        return ret_ok;

   EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm,'v_count: '||v_count||', v_soglia: '||v_soglia);
        return ret_ko;
   END;

FUNCTION FND_MCRE0_chiusura_rapporti (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN number IS

   v_nome_procedura varchar2(50) := '.FND_MCRE0_CHIUSURA_RAPPORTI';
   v_clob   clob := null;
   v_soglia number;
   v_desc_controllo varchar2(500);
   esito    number;

   cursor   c_cursor is
    select rec||CHR(10) as rec
        from  V_MCRE0_POS_RAP_CONSISTENZA_DB
        order by rec asc;

    rec_cursor c_cursor%rowtype;

    BEGIN
        select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione iniziata');
        select count(*)-2 into v_count from V_MCRE0_POS_RAP_CONSISTENZA_DB;

        open c_cursor;
         LOOP
           FETCH c_cursor INTO rec_cursor;
           EXIT WHEN c_cursor%NOTFOUND;
           v_clob:=v_clob||rec_cursor.rec;
        END LOOP;
        CLOSE c_cursor;

        select  desc_controllo, soglia
        into    v_desc_controllo, v_soglia
        from    T_MCRE0_CL_CONSISTENZA_DB
        where   1=1
        and     upper('.'||procedura) = v_nome_procedura;

        if v_count < v_soglia
            then    esito := 0;
        else    esito := v_count;
        end if;

        insert into T_MCRE0_CHK_CONSISTENZA_DB
            (id_lotto, procedura, numero, csv, dta_ins, desc_controllo, esito)
            values (p_id_lotto, nome_package||v_nome_procedura, v_count, v_clob, sysdate, v_desc_controllo, esito);

        commit;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione terminata');

        return ret_ok;

    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm,'v_count: '||v_count||', v_soglia: '||v_soglia);
        return ret_ko;
    END;

FUNCTION FND_MCRE0_check_num_pratiche (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN number IS

   v_nome_procedura varchar2(50) := '.FND_MCRE0_CHECK_NUM_PRATICHE';
   v_clob   clob := null;
   v_soglia number;
   v_desc_controllo varchar2(500);
   esito    number;

   cursor   c_cursor is
    select rec||CHR(10) as rec
        from  V_MCRE0_POS_PL_CONSISTENZA_DB
        order by rec asc;

    rec_cursor c_cursor%rowtype;

    BEGIN
        select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione iniziata');
        select count(*)-2 into v_count from V_MCRE0_POS_PL_CONSISTENZA_DB;

        open c_cursor;
         LOOP
           FETCH c_cursor INTO rec_cursor;
           EXIT WHEN c_cursor%NOTFOUND;
           v_clob:=v_clob||rec_cursor.rec;
        END LOOP;
        CLOSE c_cursor;

        select  desc_controllo, soglia
        into    v_desc_controllo, v_soglia
        from    T_MCRE0_CL_CONSISTENZA_DB
        where   1=1
        and     upper('.'||procedura) = v_nome_procedura;

        if v_count < v_soglia
            then    esito := 0;
        else    esito := v_count;
        end if;

        insert into T_MCRE0_CHK_CONSISTENZA_DB
            (id_lotto, procedura, numero, csv, dta_ins, desc_controllo, esito)
            values (p_id_lotto, nome_package||v_nome_procedura, v_count, v_clob, sysdate, v_desc_controllo, esito);

        commit;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione terminata');

        return ret_ok;

    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm,'v_count: '||v_count||', v_soglia: '||v_soglia);
        return ret_ko;
    END;

FUNCTION FND_MCRE0_check_num_delibere (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN number IS

    v_nome_procedura varchar2(50) := '.FND_MCRE0_CHECK_NUM_DELIBERE';
    v_clob   clob := null;
    v_soglia number;
   v_desc_controllo varchar2(500);
   esito    number;

    cursor   c_cursor is
        select rec||CHR(10) as rec
        from  V_MCRE0_POS_PD_CONSISTENZA_DB

        order by rec asc;

    rec_cursor c_cursor%rowtype;

    BEGIN
        select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione iniziata');
        select count(*)-2 into v_count from V_MCRE0_POS_PD_CONSISTENZA_DB;

        open c_cursor;
         LOOP
           FETCH c_cursor INTO rec_cursor;
           EXIT WHEN c_cursor%NOTFOUND;
           v_clob:=v_clob||rec_cursor.rec;
        END LOOP;
        CLOSE c_cursor;

        select  desc_controllo, soglia
        into    v_desc_controllo, v_soglia
        from    T_MCRE0_CL_CONSISTENZA_DB
        where   1=1
        and     upper('.'||procedura) = v_nome_procedura;

        if v_count < v_soglia
            then    esito := 0;
        else    esito := v_count;
        end if;

        insert into T_MCRE0_CHK_CONSISTENZA_DB
            (id_lotto, procedura, numero, csv, dta_ins, desc_controllo, esito)
            values (p_id_lotto, nome_package||v_nome_procedura, v_count, v_clob, sysdate, v_desc_controllo, esito);

        commit;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione terminata');

        return ret_ok;

    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm,'v_count: '||v_count||', v_soglia: '||v_soglia);
        return ret_ko;
    END;

FUNCTION FND_MCRE0_stato_rischio (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN number IS

   v_nome_procedura varchar2(50) := '.FND_MCRE0_STATO_RISCHIO';
   v_clob   clob := null;
   v_soglia number;
   v_desc_controllo varchar2(500);
   esito    number;

   cursor   c_cursor is
    select rec||CHR(10) as rec
        from  V_MCRE0_STRIS_CONSISTENZA_DB
        order by rec asc;

    rec_cursor c_cursor%rowtype;

    BEGIN
        select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione iniziata');
        select count(*)-2 into v_count from V_MCRE0_STRIS_CONSISTENZA_DB;

        open c_cursor;
         LOOP
           FETCH c_cursor INTO rec_cursor;
           EXIT WHEN c_cursor%NOTFOUND;
           v_clob:=v_clob||rec_cursor.rec;
        END LOOP;
        CLOSE c_cursor;

        select  desc_controllo, soglia
        into    v_desc_controllo, v_soglia
        from    T_MCRE0_CL_CONSISTENZA_DB
        where   1=1
        and     upper('.'||procedura) = v_nome_procedura;

        if v_count < v_soglia
            then    esito := 0;
        else    esito := v_count;
        end if;

        insert into T_MCRE0_CHK_CONSISTENZA_DB
            (id_lotto, procedura, numero, csv, dta_ins, desc_controllo, esito)
            values (p_id_lotto, nome_package||v_nome_procedura, v_count, v_clob, sysdate, v_desc_controllo, esito);

        commit;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione terminata');

        return ret_ok;

    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm,'v_count: '||v_count||', v_soglia: '||v_soglia);
        return ret_ko;
    END;

FUNCTION FND_MCRE0_stato_mople_soff (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN number IS

   v_nome_procedura varchar2(50) := '.FND_MCRE0_STATO_MOPLE_SOFF';
   v_clob   clob := null;
   v_soglia number;
   v_desc_controllo varchar2(500);
   esito    number;

   cursor   c_cursor is
    select rec||CHR(10) as rec
        from  V_MCRE0_SOFCCP_CONSISTENZA_DB
        order by rec asc;

    rec_cursor c_cursor%rowtype;

    BEGIN
        select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione iniziata');
        select count(*)-2 into v_count from V_MCRE0_SOFCCP_CONSISTENZA_DB;

        open c_cursor;
         LOOP
           FETCH c_cursor INTO rec_cursor;
           EXIT WHEN c_cursor%NOTFOUND;
           v_clob:=v_clob||rec_cursor.rec;
        END LOOP;
        CLOSE c_cursor;

        select  desc_controllo, soglia
        into    v_desc_controllo, v_soglia
        from    T_MCRE0_CL_CONSISTENZA_DB
        where   1=1
        and     upper('.'||procedura) = v_nome_procedura;

        if v_count < v_soglia
            then    esito := 0;
        else    esito := v_count;
        end if;

        insert into T_MCRE0_CHK_CONSISTENZA_DB
            (id_lotto, procedura, numero, csv, dta_ins, desc_controllo, esito)
            values (p_id_lotto, nome_package||v_nome_procedura, v_count, v_clob, sysdate, v_desc_controllo, esito);

        commit;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione terminata');

        return ret_ok;

    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm,'v_count: '||v_count||', v_soglia: '||v_soglia);
        return ret_ko;
    END;

FUNCTION FND_MCRE0_stato_soff_mople (
      p_id_lotto   IN   T_MCRE0_CHK_CONSISTENZA_DB.id_lotto%TYPE
   ) RETURN number IS

   v_nome_procedura varchar2(50) := '.FND_MCRE0_STATO_SOFF_MOPLE';
   v_clob   clob := null;
   v_soglia number;
   v_desc_controllo varchar2(500);
   esito    number;

   cursor   c_cursor is
    select rec||CHR(10) as rec
        from  V_MCRE0_CCPSOFF_CONSISTENZA_DB
        order by rec asc;

    rec_cursor c_cursor%rowtype;

    BEGIN
        select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione iniziata');
        select count(*)-2 into v_count from V_MCRE0_CCPSOFF_CONSISTENZA_DB;

        open c_cursor;
         LOOP
           FETCH c_cursor INTO rec_cursor;
           EXIT WHEN c_cursor%NOTFOUND;
           v_clob:=v_clob||rec_cursor.rec;
        END LOOP;
        CLOSE c_cursor;

        select  desc_controllo, soglia
        into    v_desc_controllo, v_soglia
        from    T_MCRE0_CL_CONSISTENZA_DB
        where   1=1
        and     upper('.'||procedura) = v_nome_procedura;

        if v_count < v_soglia
            then    esito := 0;
        else    esito := v_count;
        end if;

        insert into T_MCRE0_CHK_CONSISTENZA_DB
            (id_lotto, procedura, numero, csv, dta_ins, desc_controllo, esito)
            values (p_id_lotto, nome_package||v_nome_procedura, v_count, v_clob, sysdate, v_desc_controllo, esito);

        commit;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione terminata');

        return ret_ok;

    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm,'v_count: '||v_count||', v_soglia: '||v_soglia);
        return ret_ko;
    END;


    PROCEDURE PRC_MCRE0_clob_to_file (
      p_dir        IN   varchar2,
      p_file       IN   varchar2,
      p_clob       IN   clob
   ) IS

    v_nome_procedura varchar2(50) := '.PRC_MCRE0_clob_to_file';
    l_output    utl_file.file_type;
    l_amt       number default 32000;
    l_offset    number default 1;
    l_length    number default nvl(dbms_lob.getlength(p_clob), 0);

    BEGIN
        select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione iniziata');
        l_output := utl_file.fopen(p_dir, p_file, 'a',  32760);

        while ( l_offset < l_length )
        loop
            utl_file.put(l_output, dbms_lob.substr(p_clob, l_amt, l_offset) );
            utl_file.fflush(l_output);
            l_offset := l_offset + l_amt;
        end loop;

        utl_file.new_line(l_output);
        utl_file.fclose(l_output);

        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione terminata');

    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm,null);
    END;


    FUNCTION FND_MCRE0_create_file
    RETURN NUMBER IS

        v_nome_procedura varchar2(50) := '.FND_MCRE0_create_file';
        P_DIR VARCHAR2(32767);
        P_FILE VARCHAR2(32767);
        P_CLOB CLOB;
        cursor c_cursor is
            select    CSV
            FROM    T_MCRE0_CHK_CONSISTENZA_DB
            WHERE   ID_LOTTO = (select max(id_lotto) from T_MCRE0_CHK_CONSISTENZA_DB);

        r_cursor c_cursor%rowtype;

    BEGIN
        select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione iniziata');
        select 'CONSISTENZA_DB_'||to_char(sysdate,'yyyymmddhh24miss')||'.csv'  into p_file from dual;
        P_DIR := 'D_MCRE0_WORK';

        open c_cursor;

        loop
            fetch c_cursor into r_cursor;
            exit when c_cursor%NOTFOUND;
            MCRE_OWN.PKG_MCRE0_CONSISTENZA_DB.PRC_MCRE0_CLOB_TO_FILE ( P_DIR, P_FILE, r_cursor.csv );
            COMMIT;
        end loop;

        update  T_MCRE0_WRK_SEND
        set     NOME_FILE_IN = p_file
        where   cod_file='CONSISTENZA_DB';
        commit;

        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, sqlerrm,'Esecuzione terminata');
        return ret_ok;

    EXCEPTION WHEN OTHERS THEN
        PKG_MCRE0_AUDIT.log_etl (seq, nome_package||v_nome_procedura, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, null);
        return ret_ko;
    END;

END;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CONSISTENZA_DB FOR MCRE_OWN.PKG_MCRE0_CONSISTENZA_DB;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CONSISTENZA_DB FOR MCRE_OWN.PKG_MCRE0_CONSISTENZA_DB;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CONSISTENZA_DB TO MCRE_USR;

