CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRES_UTILS AS

/******************************************************************************
   NAME:       PKG_MCRES_UTILS
   PURPOSE:

   REVISIONS:
   Ver        Date          Author              Description
   ---------  ----------       -----------------  ------------------------------------
   1.0        01/07/2011    V.Galli             Created this package.
   1.1        01/07/2011    L.Ferretti          Cambio parametro in id_flusso
   1.2        17/10/2011    A.Galliano          Procedure di drop pre-caricamento
   2.0      10/02/2012      V.Galli             Aggiornamento stato acquisizione in  nuova tabella T_MCRES_WRK_last_ACQUISIZIONE
   2.1      15/02/2012      A.Galliano          Gestione flussi per istituti non target
   2.2      10/02/2012      V.Galli             Aggiornamento stato acquisizione in  nuova tabella T_MCRES_WRK_last_ACQUISIZIONE solo se id_dper nuovo
   2.3      28/05/2012      A.Galliano          Gestione file vuoti
   2.3.1    29/05/2012      A.Galliano          Fix file vuoti
   2.4      15/10/2012      A.Galliano          Gestione multibanca su ckeck_periodo
   2.5      16/10/2012      A.Galliano          Gestione flussi XML (no external tables)
   2.5.1    05/11/2012      A.Galliano          Rimozione gestione XML da process_file
   2.6      19/02/2013      A.Galliano          Log di warning e gestione eccezione no data found per file vuoti
   2.7      22/02/2013      A.Galliano          Funzione allineamento soglie alert
  2.8      03/04/2013      A.Pilloni           Modifica process file per gestione multibanca
  2.9       03/07/2013      V.Galli             checkPeriodo aggiunto flg_daily T
******************************************************************************/


    FUNCTION FNC_MCRES_esegui_slave(v_seq IN NUMBER, p_funzione IN VARCHAR2, p_ordine IN NUMBER, p_param IN f_slave_par_type) RETURN NUMBER IS

        v_result NUMBER;
        c_nome   VARCHAR2(50) := 'FNC_MCRES_esegui_slave';
        V_STRING VARCHAR2(2000);
--        param   f_slave_par_type;
        p_param2 f_slave_par_type := p_param;

    BEGIN

        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'CALL '|| p_funzione || '(:param) INTO :v_result');

        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, p_param.seq_flusso||', '||p_param.nome_file||', '||p_param.periodo||', '||p_param.tab_ext||', '||p_param.tab_trg);

--        SELECT p_ordine, p_param.seq_flusso, p_param.nome_file, p_param.periodo, p_param.tab_ext, p_param.tab_trg
--        INTO param.ordine_alimentazione, param.seq_flusso, param.nome_file, param.periodo, param.tab_ext, param.tab_trg
--        from dual;

        p_param2.ordine_alimentazione := p_ordine;

--        p_param.ordine_alimentazione := p_ordine;

        V_STRING := 'CALL ' || p_funzione || '(:p_param2) INTO :v_result';

        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'funzione eseguita: '||p_funzione||'  seq_flusso: '||p_param.seq_flusso||' nome_file: '||p_param.nome_file||' periodo: '||p_param.periodo||' tab_ext: '||p_param.tab_ext||' tab_trg: '||p_param.tab_trg||'ordine: '||p_param.ordine_alimentazione );

        EXECUTE IMMEDIATE V_STRING USING IN p_param2, OUT v_result;

        RETURN v_result;

    EXCEPTION
        when OTHERS then
            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_ERROR, SQLCODE, SQLERRM, 'FNC_MCRES_esegui_slave' );
        RAISE;


    END FNc_MCRES_esegui_slave;


FUNCTION FNc_MCRES_get_cur_sic_fnd_slv(seq IN NUMBER, p_file IN VARCHAR2) RETURN cur_sic_fun_type IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FNC_MCRES_get_cur_sic_fnd_slv';

        v_stato_ok T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_cur cur_sic_fun_type;

    BEGIN

        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

        OPEN v_cur FOR
        SELECT
            d.TAB_SRC,
            d.FUNZIONE_SLAVE
        FROM
            T_MCRES_WRK_ACQUISIZIONE c,
            T_MCRES_WRK_ELABORAZIONE d
        WHERE
            c.COD_file = p_file and
            c.COD_STATO = v_stato_ok AND
            c.COD_FILE = c.COD_FILE AND
            d.FLG_ATTIVA_FUNZIONE = 1
        ORDER BY
            d.ORDINE_ALIMENTAZIONE;


        RETURN v_cur;

    EXCEPTION

        WHEN OTHERS THEN

            RETURN NULL;

    END FNc_MCRES_get_cur_sic_fnd_slv;

    FUNCTION FNc_MCRES_checkIn(seq IN NUMBER, p_file IN VARCHAR2) RETURN number IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FNC_MCRES_checkIn';

        v_stato_ok T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_stato_ko_periodo T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_stato_periodo_prec T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_stato_file_non_trovato T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_flg_non_target T_MCRES_WRK_ALIMENTAZIONE.flg_daily%TYPE;

        v_date DATE;

        v_count NUMBER := 0;

    BEGIN

        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

        SELECT VALORE_COSTANTE INTO v_stato_ko_periodo FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_KO_PERIODO';

        SELECT VALORE_COSTANTE INTO v_stato_periodo_prec FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_PERIODO_PRECEDENTE';

        SELECT VALORE_COSTANTE INTO v_stato_file_non_trovato FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_FILE_NON_TROVATO';

        select flg_daily
        into v_flg_non_target
        from t_mcres_wrk_alimentazione
        where cod_flusso = (select cod_flusso from t_mcres_wrk_acquisizione where id_flusso = seq);

        UPDATE  T_MCRES_WRK_ACQUISIZIONE a
        SET     VAL_TAB_EXTERNAL = (SELECT DISTINCT TAB_SRC FROM T_MCRES_WRK_ELABORAZIONE b, t_mcres_wrk_acquisizione c
                                    WHERE   b.COD_FLUSSO = upper(c.COD_FLUSSO)
                                    AND     TAB_SRC LIKE 'TE_MCRES_%'
                                    and     c.ID_FLUSSO = seq)
        WHERE   A.ID_FLUSSO = seq;
        Commit;
--****************************modifiche 16-12-2011******************
        IF(FNc_MCRES_checkPeriodo(seq,p_file,v_date) = 1) THEN



            update t_mcres_wrk_acquisizione
            set id_dper = v_date,
                cod_stato = v_stato_ok,
                DTA_INIZIO = SYSDATE
            where
                ID_FLUSSO = seq
                AND
                (cod_stato IS NULL OR cod_stato = v_stato_file_non_trovato);

            Pkg_Mcres_Audit.Log_Caricamenti(Seq, 'PKG_MCRES_UTILS.FNC_MCRES_checkIn', Pkg_Mcres_Audit.C_Debug, Sqlcode, Sqlerrm, 'T_MCRES_WRK_ACQUISIZIONE aggiornata con PERIODO_RIFERIMENTO= '|| V_Date ||' STATO = '|| V_Stato_Ok  );
        ELSE
            UPDATE T_MCRES_WRK_ACQUISIZIONE
            SET cod_stato = v_stato_ko_periodo,
                DTA_INIZIO = SYSDATE
            WHERE
                ID_FLUSSO = seq AND
                cod_stato IS NULL;
            PKG_MCRES_AUDIT.log_caricamenti(seq, 'PKG_MCRES_UTILS.FNC_MCRES_checkIn', PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'T_MCRES_WRK_ACQUISIZIONE aggiornata con '||v_stato_ko_periodo );
        END IF;

        -- Si cancellano dalla WRK_ACQUISIZIONE i record relativi allo stesso caricamento in atto.
--        DELETE FROM  T_MCRES_WRK_ACQUISIZIONE b
--        where b.cod_file = (select cod_file from t_mcres_wrk_acquisizione where cod_file = p_file)
--        and b.id_dper = (select id_dper from t_mcres_wrk_acquisizione where cod_file = p_file)
--        and b.COD_STATO = 'CARICATO' ;
--        commit;

        -- setta lo stato a "periodo precedente" se il file non contiene l'ultimo periodo disponibile per la tabella di acquisizione --
    /*    update t_mcres_wrk_acquisizione b
        SET b.cod_STATO = v_stato_periodo_prec
        where
            b.ID_FLUSSO = seq and
            b.ID_DPER < (SELECT MAX(c.id_dper)
                                     FROM T_MCRES_WRK_ACQUISIZIONE c
                                     WHERE c.COD_FILE = b.COD_FILE);*/
        Commit;
--******************************************************************
        -- conto quanti caricamenti sono stati ìn corso per questo file.
        if(v_flg_non_target != 'N') then
            SELECT COUNT(*) INTO v_count
            FROM T_MCRES_WRK_ACQUISIZIONE
            WHERE
                cod_file  = p_file and
                id_dper   = v_date and
                cod_STATO = v_stato_ok;
        else
            SELECT COUNT(*) INTO v_count
            FROM T_MCRES_WRK_ACQUISIZIONE
            WHERE
                cod_file  = p_file and
                cod_STATO = v_stato_ok;
        end if;

        PKG_MCRES_AUDIT.log_caricamenti(seq, 'PKG_MCRES_UTILS.FNC_MCRES_checkIn', PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'numero record in T_MCRES_WRK_ACQUISIZIONE con stato VALIDO per questo caricamento: '||v_count );

        BEGIN
          DELETE FROM T_MCRES_WRK_LAST_ACQUISIZIONE
          WHERE (COD_FLUSSO,COD_ABI) = (
            select COD_FLUSSO,COD_ABI
            FROM T_MCRES_WRK_ACQUISIZIONE a
            where ID_FLUSSO = SEQ
            and not exists ( -------------- Non cancello se id_dper vecchio
                select distinct 1
                from T_MCRES_WRK_ACQUISIZIONE B
                where b.COD_ABI = a.COD_ABI
                and b.COD_FLUSSO = a.COD_FLUSSO
                and B.COD_STATO = 'CARICATO'
                and B.ID_DPER > a.ID_DPER
              )
          );

          insert into T_MCRES_WRK_LAST_ACQUISIZIONE
          (COD_ABI,COD_FILE,COD_FLUSSO,ID_FLUSSO,COD_STATO,ID_DPER,DTA_START )
          select COD_ABI,COD_FILE,COD_FLUSSO,ID_FLUSSO,COD_STATO,ID_DPER,dta_inizio
          FROM T_MCRES_WRK_ACQUISIZIONE a
          where ID_FLUSSO = SEQ
          and not exists ( -------------- Non inserisco se id_dper vecchio
                select distinct 1
                from T_MCRES_WRK_ACQUISIZIONE B
                where b.COD_ABI = a.COD_ABI
                and b.COD_FLUSSO = a.COD_FLUSSO
                and B.COD_STATO = 'CARICATO'
                and B.ID_DPER > a.ID_DPER
              );
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            PKG_MCRES_AUDIT.LOG_CARICAMENTI(SEQ, C_NOME, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'Delete/Insert in T_MCRES_wrk_last_acquisizione');
        end;

        If (V_Count = 1) Then
            RETURN val_ok;
        ELSE
            RETURN val_ko;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.log_caricamenti(seq, 'PKG_MCRES_UTILS.FNC_MCRES_checkIn', PKG_MCRES_AUDIT.C_ERROR, SQLCODE, SQLERRM, null );
            RETURN val_ko;

    END FNC_MCRES_checkIn;


    FUNCTION FNC_MCREs_string2date_format(seq IN NUMBER, p_string IN VARCHAR2, p_format IN VARCHAR2, p_date OUT DATE) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FNC_MCRES_string2date_format';

    BEGIN

        p_date := TO_DATE(p_string,p_format);

        --PKG_MCREs_LOG.LOG_EVENTO(c_nome,'OK');

        RETURN TRUE;

    EXCEPTION

        WHEN OTHERS THEN

            --PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE','''' || NVL(p_string,'(NULL)') || ''' - ' || SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FNC_MCREs_string2date_format;

   FUNCTION FNC_MCREs_string2date(seq IN NUMBER, p_string IN VARCHAR2, p_date OUT DATE) RETURN BOOLEAN IS

    BEGIN

        RETURN FNc_MCREs_string2date_format(seq,p_string,'YYYYMMDD',p_date);

    END FNC_MCREs_string2date;

    FUNCTION FNC_MCREs_string2date(seq IN NUMBER, p_string IN VARCHAR2) RETURN BOOLEAN IS

        v_date DATE;

    BEGIN

        RETURN FNc_MCREs_string2date(seq,p_string,v_date);

    END FNC_MCREs_string2date;

    FUNCTION FNC_MCRES_checkPeriodo(seq IN NUMBER, p_file IN VARCHAR2, p_date OUT DATE) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FNC_MCRES_checkPeriodo';
        v_work_dir T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_ext_table T_MCRES_WRK_ACQUISIZIONE.val_tab_external%TYPE;
        v_sql VARCHAR2(255);
        v_periodo VARCHAR2(20);
        v_flag BOOLEAN := FALSE;
        v_flg_daily T_MCRES_WRK_ALIMENTAZIONE.FLG_daily%TYPE;

    BEGIN

        SELECT VALORE_COSTANTE INTO v_work_dir FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'WORK_DIRECTORY';

        SELECT c.val_tab_external INTO v_ext_table
        FROM
            T_MCRES_WRK_ACQUISIZIONE c
        where c.ID_FLUSSO = seq;

        /*
        Gestione non target e multibanca
        */
        select b.flg_daily
        into v_flg_daily
        from t_mcres_wrk_acquisizione a, t_mcres_wrk_alimentazione b
        where a.cod_flusso = B.COD_FLUSSO  and a.id_flusso = seq;

        if(v_flg_daily = 'N') then
            v_flag  := true;

        else

            if v_flg_daily in ('X','T')
            then

                v_sql := 'select distinct trim(id_dper) from ' || v_ext_table;

            else

                v_sql := 'SELECT distinct TRIM(ID_DPER) FROM ' || v_ext_table || '
                WHERE   COD_ABI = (SELECT COD_ABI FROM T_MCRES_WRK_ACQUISIZIONE WHERE ID_FLUSSO = '||SEQ||')';

            end if;

            begin

                execute immediate v_sql into v_periodo;

            exception
            when no_data_found
            then

                pkg_mcres_audit.log_caricamenti(seq, c_nome, pkg_mcres_audit.c_warning, sqlcode, sqlerrm, 'File vuoto o nessun record valido su external: ' || v_ext_table );
--                raise;
                return val_ko;

            end;

            v_flag := FNC_MCRES_string2date(seq,v_periodo,p_date);

        end if;

        Pkg_Mcres_Audit.Log_Caricamenti(Seq, 'PKG_MCRES_UTILS.check_periodo', Pkg_Mcres_Audit.C_Debug, Sqlcode, Sqlerrm, 'periodo riferimento: '||P_Date );


        If V_Flag Then
           Return Val_Ok;
        Else
           Return Val_Ko;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.log_caricamenti(seq, 'PKG_MCRES_UTILS.FNC_MCRES_checkPeriodo', PKG_MCRES_AUDIT.C_ERROR, SQLCODE, SQLERRM, null );
            RETURN val_ko;

    END FNC_MCRES_checkPeriodo;

    PROCEDURE SPO_MCRES_clean_log_tables(p_seq IN NUMBER) IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.svecchiamento_log_tables';

        v_stato_ok T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_periodo DATE;

        v_mesi_svecchiamento NUMBER;

    BEGIN

        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

        BEGIN

            SELECT VALORE_COSTANTE INTO v_mesi_svecchiamento
            FROM T_MCRES_WRK_CONFIGURAZIONE
            WHERE NOME_COSTANTE = 'MESI_SVECCHIAMENTO_EVENTI_PROCESSI_LOG';

        EXCEPTION

            WHEN OTHERS THEN

                v_mesi_svecchiamento := 0;

                --PKG_MCRES_LOG.SPO_MCRES_LOG_EVENTO(p_seq,c_nome,'ATTENZIONE','Svecchiamento tabelle di log non eseguibile per problemi di rilevamento della costante ''MESI_SVECCHIAMENTO_EVENTI_PROCESSI_LOG'' nella tabella ''T_COLI_CT_CONFIGURAZIONE''');

        END;

        IF(v_mesi_svecchiamento > 0) THEN

            select max(id_dper) into v_periodo
            FROM T_MCRES_WRK_ACQUISIZIONE WHERE cod_STATO = v_stato_ok;

            --DELETE T_MCRES_WRK_LOG_EVENTI WHERE TO_CHAR(TMS,'YYYYMM') <= TO_CHAR(ADD_MONTHS(v_periodo,-v_mesi_svecchiamento),'YYYYMM');

            COMMIT;

        END IF;

    END SPO_MCRES_clean_log_tables;

       FUNCTION FNC_MCRES_process_file(ID_FLUSSO IN NUMBER) RETURN NUMBER IS

        c_nome constant varchar2(50) := c_package || '.process_file';
        v_master_FUNCTION T_MCRES_WRK_ACQUISIZIONE.cod_FILE%TYPE;
        v_result NUMBER := -1;
        v_return boolean;
        v_seq NUMBER := ID_FLUSSO;
        v_count NUMBER;
        v_file t_mcres_wrk_acquisizione.cod_file%type;
        v_external  t_mcres_wrk_acquisizione.val_tab_external%type;
        v_cod_abi         t_mcres_wrk_acquisizione.cod_abi%type;
        v_stmt  varchar2(32767);
        v_flg_daily         t_mcres_wrk_alimentazione.flg_daily%type;
        v_cod_flusso        t_mcres_wrk_acquisizione.cod_flusso%type;




    Begin

        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'inizio..: '||v_seq );

        SELECT  COD_FILE, cod_flusso
        INTO v_file, v_cod_flusso
        FROM    T_MCRES_WRK_ACQUISIZIONE
        WHERE   ID_FLUSSO = v_seq;

/*
        select flg_daily
        into v_flg_daily
        from t_mcres_wrk_alimentazione
        where cod_flusso = v_cod_flusso;
*/

        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'caricamento COD_FILE: '||v_file );

/*

        if v_flg_daily != 'Z'   --tutti i flussi non alimentati da file XML multibanca
        then
*/
            IF(FNc_MCRES_checkIn(v_seq,v_file) = 1) THEN
               -- se i controlli sono andati a buon fine lancio il caricamento.
               v_result :=  pkg_mcres_funzioni_master.FNC_MCRES_master(v_seq,v_file);
               PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'caricamento terminato con esito: '||v_result );
            else
            --Controllo se la chekIn è andata in errore a causa di file vuoto
            --e gestisco
                select val_tab_external
                into v_external
                from t_mcres_wrk_acquisizione
                where id_flusso = v_seq;

                select cod_abi
                into v_cod_abi
                from t_mcres_wrk_acquisizione
                where id_flusso = v_seq;

                -- AP 03/04/2013
                if v_cod_abi is not null then

                v_stmt := 'select count(*) from ' || v_external || ' where cod_abi = ' || v_cod_abi;

                else

                v_stmt := 'select count(*) from ' || v_external;

                end if;


                execute immediate v_stmt into v_count;

                if(v_count = 0)
                then

                    v_result := val_ok;

                    PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'File vuoto: '||v_result );

                end if;

            End If;
/*
        else
            -- gestione caricamento alimentati da XML multibanca

            pkg_mcres_audit.log_caricamenti(v_seq, c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'Chiamata fnc_mcres_checkin_xml' );

            v_result:=  fnc_mcres_checkin_xml(v_seq, v_file);

            pkg_mcres_audit.log_caricamenti(v_seq, c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'Eseguita fnc_mcres_checkin_xml' );

            if v_result = val_ok
            then

                pkg_mcres_audit.log_caricamenti(v_seq, c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'Chiamata pkg_mcres_funzioni_master.fnc_mcres_master' );

                v_result :=  pkg_mcres_funzioni_master.fnc_mcres_master(v_seq,v_file);

                pkg_mcres_audit.log_caricamenti(v_seq, c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'Eseguita pkg_mcres_funzioni_master.fnc_mcres_master' );

            end if;


        end if;
*/
        return v_result;

    EXCEPTION
    WHEN OTHERS THEN

            pkg_mcres_audit.log_caricamenti(v_seq, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, null );

            RETURN -1;

    END FNC_MCRES_process_file;


--      FUNCTION FNC_MCRES_get_cur_fnd_slv(v_seq IN NUMBER, p_file IN VARCHAR2, p_ext_table IN VARCHAR2) RETURN cur_func_type IS
--
--        c_nome CONSTANT VARCHAR2(50) := c_package || '.FNC_MCRES_get_cur_funzione_slave';
--
--        v_stato_ok T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
--
--        v_cur cur_func_type;
--
--    BEGIN
--
--        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';
--
--        OPEN v_cur FOR
--        SELECT d.FUNZIONE_SLAVE
--        FROM
--            T_MCRES_WRK_ACQUISIZIONE c,
--            T_MCRES_WRK_ELABORAZIONE d
--        where
--            c.cod_file = p_file and
--            c.cod_STATO = v_stato_ok AND
--            d.COD_FILE = c.COD_FILE AND
--            d.TAB_SRC = p_ext_table AND
--            d.FLG_ATTIVA_FUNZIONE = 1
--        ORDER BY
--            d.TAB_TRG,
--            d.ORDINE_FUNZIONE;

--        RETURN v_cur;
--
--    EXCEPTION
--        WHEN OTHERS THEN
--            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_ERROR, SQLCODE, SQLERRM, null );
--            RETURN NULL;
--
--    END FNC_MCRES_get_cur_fnd_slv;

   FUNCTION FNC_MCRES_get_ext_table(v_seq IN NUMBER, p_file IN VARCHAR2) RETURN VARCHAR2 IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FNC_MCRES_get_ext_table';
        v_stato_ok T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_ext_table T_MCRES_WRK_ELABORAZIONE.TAB_SRC%TYPE;

    BEGIN

        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

--        SELECT DISTINCT nvl(c.TAB_SRC, 'ERROR') INTO v_ext_table
--        FROM
--            T_MCRES_WRK_ACQUISIZIONE b,
--            T_MCRES_WRK_ELABORAZIONE c
--        WHERE
--            b.cod_file = p_file and
--            b.cod_STATO = v_stato_ok AND
--            b.COD_FILE = c.COD_FLUSSO;

        select  val_tab_external into v_ext_table
        from    T_MCRES_WRK_ACQUISIZIONE
        where   id_flusso = v_seq;

        RETURN v_ext_table;

    EXCEPTION

        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_ERROR, SQLCODE, SQLERRM, null );
            RETURN NULL;

    END FNC_MCRES_get_ext_table;

--    FUNCTION FNC_MCRES_get_trg_table(v_seq IN NUMBER, p_file IN VARCHAR2) RETURN VARCHAR2 IS
--
--        c_nome CONSTANT VARCHAR2(50) := c_package || '.FNC_MCRES_get_trg_table';
--        v_stato_ok T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
--        v_trg_table T_MCRES_WRK_ELABORAZIONE.TAB_TRG%TYPE;
--
--    BEGIN
--
--        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';
--
--        SELECT DISTINCT d.TAB_TRG INTO v_trg_table
--        FROM
--            T_MCRES_WRK_ACQUISIZIONE c,
--            T_MCRES_WRK_ELABORAZIONE d
--        WHERE
--            c.cod_file = p_file and
--            c.cod_STATO = v_stato_ok AND
--            d.COD_FLUSSO = c.COD_FLUSSO;
--
--        RETURN v_trg_table;
--
--    EXCEPTION
--        WHEN OTHERS THEN
--            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_ERROR, SQLCODE, SQLERRM, null );
--            RETURN NULL;
--
--    END FNC_MCRES_get_trg_table;

    FUNCTION FNC_MCRES_get_slave_param(v_seq IN NUMBER, p_file IN VARCHAR2) RETURN f_slave_par_type IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FNC_MCRES_get_slave_param';
        v_slave_par f_slave_par_type;

    BEGIN

        v_slave_par := FNc_MCRES_get_slave_param_sic(v_seq, p_file);
        v_slave_par.TAB_EXT := PKG_MCRES_UTILS.FNc_MCRES_GET_EXT_TABLE(v_slave_par.SEQ_FLUSSO,p_file);
        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'Tabella esterna: '||v_slave_par.TAB_EXT );

        v_slave_par.TAB_TRG := PKG_MCRES_UTILS.FNc_MCRES_get_trg_table(v_slave_par.SEQ_FLUSSO,null);
        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'Tabella target: '||v_slave_par.TAB_TRG );

        RETURN v_slave_par;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_ERROR, SQLCODE, SQLERRM, null );
            RETURN NULL;

    END FNC_MCRES_get_slave_param;

     FUNCTION FNC_MCRES_get_cur_fnd_slv(v_seq IN NUMBER, p_file IN VARCHAR2, p_ext_table IN VARCHAR2) RETURN cur_func_type IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FNC_MCRES_get_cur_fnd_slv';

        v_stato_ok T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_cur cur_func_type;

    BEGIN

        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';

        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'p_file: '||p_file||' - v_stato_ok: '||v_stato_ok||' p_ext_table '||p_ext_table );

        OPEN V_CUR FOR
        SELECT d.FUNZIONE_SLAVE, D.ORDINE_ALIMENTAZIONE
        FROM
            T_MCRES_WRK_ACQUISIZIONE c,
            T_MCRES_WRK_ELABORAZIONE d
        where
            c.ID_FLUSSO = v_seq and
--            c.cod_file = p_file and
--            c.cod_STATO = v_stato_ok AND
            d.COD_FLUSSO = c.COD_FLUSSO AND
--            d.TAB_SRC = p_ext_table AND
            d.FLG_ATTIVA_FUNZIONE = 1
            order by D.ORDINE_ALIMENTAZIONE;

            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'cursore aperto..' );

        RETURN v_cur;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_ERROR, SQLCODE, SQLERRM, null );
            RETURN NULL;

    END FNC_MCRES_get_cur_fnd_slv;

    FUNCTION FNC_MCRES_get_trg_table(v_seq IN NUMBER, p_ordine IN NUMBER) RETURN VARCHAR2 IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FNC_MCRES_get_trg_table';
        v_stato_ok T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_trg_table T_MCRES_WRK_ELABORAZIONE.TAB_TRG%TYPE;

        p_ord NUMBER := 2;

    BEGIN

        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'v_seq: '||v_seq||', ordine_funzione: '||p_ordine );

        SELECT VALORE_COSTANTE INTO v_stato_ok FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_OK';



        SELECT D.TAB_TRG
        INTO v_trg_table
        FROM T_MCRES_WRK_ACQUISIZIONE C,
              T_MCRES_WRK_ELABORAZIONE D
        WHERE C.ID_FLUSSO = v_seq
        AND C.COD_FLUSSO = D.COD_FLUSSO
        AND D.ORDINE_ALIMENTAZIONE = p_ord;

        RETURN v_trg_table;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_ERROR, SQLCODE, SQLERRM, null );
            RETURN NULL;

    END FNC_MCRES_get_trg_table;


    FUNCTION FNC_MCRES_get_slave_param_sic(v_seq IN NUMBER, p_file IN VARCHAR2) RETURN f_slave_par_type IS

        C_NOME CONSTANT VARCHAR2(50) := C_PACKAGE || '.FNC_MCRES_get_slave_param_sic';
        v_slave_par f_slave_par_type := f_slave_par_type(v_seq,p_file,NULL,NULL,NULL,NULL);

    BEGIN

        SELECT id_dper
        INTO v_slave_par.PERIODO
        from t_mcres_wrk_acquisizione
        WHERE id_flusso = v_seq;

        RETURN v_slave_par;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_ERROR, SQLCODE, SQLERRM, null );
            RETURN NULL;
    END FNC_MCRES_get_slave_param_sic;


    FUNCTION FNC_MCRES_execute(p_param1 IN VARCHAR2,
                                p_param2 IN VARCHAR2,
                                p_param3 IN VARCHAR2,
                                p_param4 IN VARCHAR2) RETURN BOOLEAN is

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FNC_MCRES_execute';

 begin

 DBMS_OUTPUT.PUT_LINE(p_param1 || p_param2 || p_param3 || p_param4);
 EXECUTE IMMEDIATE p_param1 || p_param2 || p_param3 || p_param4;
 DBMS_OUTPUT.PUT_LINE('OK');

 --PKG_MCRES_LOG.SPO_MCRES_LOG_EVENTO(0,c_nome,'OK', 'ESEGUITO');

 RETURN TRUE;


 EXCEPTION
 WHEN OTHERS THEN

  --PKG_MCRES_LOG.SPO_MCRES_LOG_EVENTO(0,c_nome,'ERRORE' ,SUBSTR(SQLERRM, 1, 255));
  DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 255));
  RETURN FALSE;

 end FNC_MCRES_execute;

 --v1,1
 FUNCTION fnC_MCRES_chiudi_portale return number is

 dta date;
 idper number;
 esito number := 0;
 seq number;

 begin

     select SEQ_MCR0_LOG_ETL.nextval into seq from dual;

     --disabilito funzioni dispositive
--     DELETE FROM T_MCRES_APP_PR_GRUPPI_FUNZIONI F
--     WHERE F.ID_FUNZIONE IN (20,30);

     --chiudo il portale web
     update T_MCRES_WRK_CONFIGURAZIONE
     set VALORE_COSTANTE = 0
     where NOME_COSTANTE = 'STATO_PORTALE';

--     --marco tutti gli abi come Non Elaborati
--     --1. inserisco riga fittizia in Abi Elaborati
--     select max(dta_elaborazione)+1, max(id_dper)
--     into dta, idper
--     from t_MCRES_app_abi_elaborati;
--
--     insert into MCRE_OWN.T_MCRES_APP_ABI_ELABORATI
--        (COD_ABI_ISTITUTO, DTA_ELABORAZIONE, TMS_ULTIMA_ELABORAZIONE, ID_DPER)
--     values( '99999', dta, sysdate, idper);
--     commit;
--
--     --2. aggiorno MV per marcare tutti gli abi non elaborati
--     esito := MCRE_OWN.PKG_MCRES_AGGIORNA_MV.AGGIORNA_ISTITUTI;
--
--     --3. rimuovo la riga fittizia
--     delete T_MCRES_APP_ABI_ELABORATI
--     where cod_abi_istituto = '99999';
     commit;

     PKG_MCRES_AUDIT.LOG_ETL ( seq, 'fnc_MCRES_chiudi_portale', 2, SQLCODE, 'portale chiuso', 'esito: '||esito );
     return esito;

 exception when others then
     PKG_MCRES_AUDIT.LOG_ETL ( seq, 'fnc_MCRES_chiudi_portale', 2, SQLCODE, sqlerrm, 'portale NON chiuso: esito: '||esito );
     return esito;

 end;

 FUNCTION fnc_MCRES_apri_portale return number is

 esito number := 1;
 seq number;

 begin

     select SEQ_MCR0_LOG_ETL.nextval into seq from dual;

     --riabilito funzioni dispositive
--     Insert into T_MCRES_APP_PR_GRUPPI_FUNZIONI (ID_GRUPPO,ID_FUNZIONE,ID_AREA_LAVORO)
--        select ID_GRUPPO,ID_FUNZIONE,ID_AREA_LAVORO
--        from T_MCRES_APP_PR_GRUPPI_FUNZIONI F
--        WHERE F.ID_FUNZIONE IN (20,30);

     --riapro il portale web
     update T_MCRES_WRK_CONFIGURAZIONE
     set VALORE_COSTANTE = 1
     where NOME_COSTANTE = 'STATO_PORTALE';

     commit;

--   esito := MCRE_OWN.PKG_MCRES_AGGIORNA_MV.AGGIORNA_ISTITUTI;

     PKG_MCRES_AUDIT.LOG_ETL ( seq, 'fnd_MCRES_apri_portale', 2, SQLCODE, 'portale aperto', 'esito: '||esito );
     return esito;

 exception when others then
     PKG_MCRES_AUDIT.LOG_ETL ( seq, 'fnd_MCRES_apri_portale', 2, SQLCODE, sqlerrm, 'portale NON chiuso: esito: '||esito );
     return 0;

 end;

FUNCTION fnc_mcres_drop_parts(v_string IN VARCHAR2) RETURN NUMBER IS

--Drop partizioni per le tabelle di staging
--Necessario passere il parametro 'DROPALL' per effettuare il drop

cursor c_part is
    select
        table_name v_tab,
        partition_name v_part
    from
        all_tab_partitions
    where
            table_name in       --Meno flessibile di table_name like 'T_MCRES_%' ma meno rischioso
                         (
                            'T_MCRES_FL_DELIBERE',
                            'T_MCRES_FL_EFFETTI_ECONOMICI',
                            'T_MCRES_FL_GARANZIE',
                            'T_MCRES_FL_MOVIMENTI',
                            'T_MCRES_FL_MOVIMENTI_MOD_MOV',
                            'T_MCRES_FL_NOTIZIE',
                            'T_MCRES_FL_OPERAZIONI',
                            'T_MCRES_FL_POSIZIONI',
                            'T_MCRES_FL_PRATICHE',
                            'T_MCRES_FL_RAPPORTI',
                            'T_MCRES_FL_SISBA',
                            'T_MCRES_FL_SISBA_CP',
                            'T_MCRES_FL_SPESE',
                            'T_MCRES_ST_DELIBERE',
                            'T_MCRES_ST_EFFETTI_ECONOMICI',
                            'T_MCRES_ST_GARANZIE',
                            'T_MCRES_ST_MOVIMENTI',
                            'T_MCRES_ST_MOVIMENTI_MOD_MOV',
                            'T_MCRES_ST_NOTIZIE',
                            'T_MCRES_ST_OPERAZIONI',
                            'T_MCRES_ST_POSIZIONI',
                            'T_MCRES_ST_PRATICHE',
                            'T_MCRES_ST_RAPPORTI',
                            'T_MCRES_ST_SISBA',
                            'T_MCRES_ST_SISBA_CP',
                            'T_MCRES_ST_SPESE',
                            'T_MCRES_APP_DELIBERE',
                            'T_MCRES_APP_EFFETTI_ECONOMICI',
                            'T_MCRES_APP_GARANZIE',
                            'T_MCRES_APP_MOVIMENTI',
                            'T_MCRES_APP_MOVIMENTI_MOD_MOV',
                            'T_MCRES_APP_NOTIZIE',
                            'T_MCRES_APP_OPERAZIONI',
                            'T_MCRES_APP_POSIZIONI',
                            'T_MCRES_APP_PRATICHE',
                            'T_MCRES_APP_RAPPORTI',
                            'T_MCRES_APP_SISBA',
                            'T_MCRES_APP_SISBA_CP',
                            'T_MCRES_APP_SPESE'
                            )
        and partition_name not in ('SOFF_PALTRI', 'SOFF_PATTIVE', 'SOFF_PSTORICHE')
        order by v_tab;


begin
if(v_string = 'DROPALL') then
    for rec in c_part loop
        DBMS_OUTPUT.PUT_LINE('Tabella: ' || rec.v_tab || ', Partizione: ' || rec.v_part);
        EXECUTE IMMEDIATE 'ALTER TABLE ' ||rec.v_tab|| ' DROP PARTITION ' || rec.v_part;
    end loop;

   return val_ok;
else
    return val_ko;
end if;

exception
    when others then
        return val_ko;
end;


FUNCTION fnc_mcres_drop_subparts(v_string IN VARCHAR2) RETURN NUMBER IS

--Drop sottopartizioni per le tabelle di staging
--Necessario passere il parametro 'DROPALL' per effettuare il drop

cursor c_part is
    select
        table_name v_tab,
        subpartition_name v_subpart
    from
        all_tab_subpartitions
    where
            table_name in       --Meno flessibile di table_name like 'T_MCRES_%' ma meno rischioso
                         (
                            'T_MCRES_FL_DELIBERE',
                            'T_MCRES_FL_EFFETTI_ECONOMICI',
                            'T_MCRES_FL_GARANZIE',
                            'T_MCRES_FL_MOVIMENTI',
                            'T_MCRES_FL_MOVIMENTI_MOD_MOV',
                            'T_MCRES_FL_NOTIZIE',
                            'T_MCRES_FL_OPERAZIONI',
                            'T_MCRES_FL_POSIZIONI',
                            'T_MCRES_FL_PRATICHE',
                            'T_MCRES_FL_RAPPORTI',
                            'T_MCRES_FL_SISBA',
                            'T_MCRES_FL_SISBA_CP',
                            'T_MCRES_FL_SPESE',
                            'T_MCRES_ST_DELIBERE',
                            'T_MCRES_ST_EFFETTI_ECONOMICI',
                            'T_MCRES_ST_GARANZIE',
                            'T_MCRES_ST_MOVIMENTI',
                            'T_MCRES_ST_MOVIMENTI_MOD_MOV',
                            'T_MCRES_ST_NOTIZIE',
                            'T_MCRES_ST_OPERAZIONI',
                            'T_MCRES_ST_POSIZIONI',
                            'T_MCRES_ST_PRATICHE',
                            'T_MCRES_ST_RAPPORTI',
                            'T_MCRES_ST_SISBA',
                            'T_MCRES_ST_SISBA_CP',
                            'T_MCRES_ST_SPESE',
                            'T_MCRES_APP_DELIBERE',
                            'T_MCRES_APP_EFFETTI_ECONOMICI',
                            'T_MCRES_APP_GARANZIE',
                            'T_MCRES_APP_MOVIMENTI',
                            'T_MCRES_APP_MOVIMENTI_MOD_MOV',
                            'T_MCRES_APP_NOTIZIE',
                            'T_MCRES_APP_OPERAZIONI',
                            'T_MCRES_APP_POSIZIONI',
                            'T_MCRES_APP_PRATICHE',
                            'T_MCRES_APP_RAPPORTI',
                            'T_MCRES_APP_SISBA',
                            'T_MCRES_APP_SISBA_CP',
                            'T_MCRES_APP_SPESE'
                            )
        and subpartition_name not in ('SOFF_PALTRI_ALTRI', 'SOFF_PATTIVE_ALTRI', 'SOFF_PSTORICHE_ALTRI')
        order by v_tab;


begin
if(v_string = 'DROPALL') then
    for rec in c_part loop
        DBMS_OUTPUT.PUT_LINE('Tabella: ' || rec.v_tab || ', Sottopartizione: ' || rec.v_subpart);
        EXECUTE IMMEDIATE 'ALTER TABLE ' ||rec.v_tab|| ' DROP SUBPARTITION ' || rec.v_subpart;
    end loop;

   return val_ok;
else
    return val_ko;
end if;

Exception
    when others then
        return val_ko;
end;


function fnc_mcres_checkin_xml
(
    p_seq in number,
    p_file in varchar2
)
return number is

    c_nome                      constant varchar2(50) := c_package || '.fnc_mcres_checkin_xml';
    v_stato_ok                  t_mcres_wrk_configurazione.valore_costante%type;
    v_stato_ko_periodo          t_mcres_wrk_configurazione.valore_costante%type;
    v_stato_periodo_prec        t_mcres_wrk_configurazione.valore_costante%type;
    v_stato_file_non_trovato    t_mcres_wrk_configurazione.valore_costante%type;
    v_cod_flusso                t_mcres_wrk_acquisizione.cod_flusso%type;
    v_flg_non_target            t_mcres_wrk_alimentazione.flg_daily%type;
    v_tab_external              t_mcres_wrk_acquisizione.val_tab_external%type;
    v_note                      t_mcres_wrk_audit_caricamenti.note%type;

    v_date  date;
    v_count number := 0;
    v_stmt  varchar2(32767);

begin

    v_note := 'recupero valori dalle tabelle di configurazione';

    select valore_costante
    into v_stato_ok
    from t_mcres_wrk_configurazione
    where nome_costante = 'STATO_OK';

    select valore_costante
    into v_stato_ko_periodo
    from t_mcres_wrk_configurazione
    where nome_costante = 'STATO_KO_PERIODO';

    select valore_costante
    into v_stato_periodo_prec
    from t_mcres_wrk_configurazione
    where nome_costante = 'STATO_PERIODO_PRECEDENTE';

    select valore_costante
    into v_stato_file_non_trovato
    from t_mcres_wrk_configurazione
    where nome_costante = 'STATO_FILE_NON_TROVATO';

    select cod_flusso
    into v_cod_flusso
    from t_mcres_wrk_acquisizione
    where id_flusso = p_seq;


    v_tab_external   := 'VE_MCRES_' || v_cod_flusso;

    v_note          :=    'Aggiornamento val_tab_external su T_MCRES_WRK_ACQUISIZIONE';

    update  t_mcres_wrk_acquisizione
    set     val_tab_external = v_tab_external
    where id_flusso = p_seq;

    commit;

    v_note  := 'controllo validità id_dper';

    begin

        v_stmt := 'select distinct to_date(trim(id_dper), ''yyyymmdd'') from  ' ||  v_tab_external;

        execute immediate v_stmt into v_date;

    exception
    when others
    then

        update t_mcres_wrk_acquisizione
        set
            dta_inizio = sysdate,
            cod_stato = v_stato_ko_periodo
        where id_flusso = p_seq;

        commit;

        pkg_mcres_audit.log_caricamenti(p_seq, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'T_MCRES_WRK_ACQUISIZIONE aggiornata con STATO = '|| v_stato_ko_periodo  );

        return val_ko;

    end;


    v_note :=  'aggiornamento T_MCRES_WRK_ACQUISIZIONE con stato valido, id_dper e dta_inizio';

    update t_mcres_wrk_acquisizione
    set
        id_dper = v_date,
        cod_stato = v_stato_ok,
        dta_inizio = sysdate
    where 0 = 0
        and id_flusso = p_seq
        and (cod_stato is null or cod_stato = v_stato_file_non_trovato);

    pkg_mcres_audit.log_caricamenti(p_seq, c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'T_MCRES_WRK_ACQUISIZIONE aggiornata con PERIODO_RIFERIMENTO= '|| v_date ||' STATO = '|| v_stato_ok  );


    commit;



    v_note := 'gestione T_MCRES_WRK_LAST_ACQUISIZIONE';
    begin

        delete t_mcres_wrk_last_acquisizione
        where id_flusso in
        (
            select
                l.id_flusso
            from
                t_mcres_wrk_last_acquisizione l,
                t_mcres_wrk_acquisizione a
            where 0=0
                and a.id_flusso = p_seq
                and a.cod_flusso = l.cod_flusso
                and (l.id_dper is null or l.id_dper <= v_date)
        );

        insert into t_mcres_wrk_last_acquisizione
        (
            cod_abi,
            cod_file,
            cod_flusso,
            id_flusso,
            cod_stato,
            id_dper,
            dta_start
        )
        select
            cod_abi,
            cod_file,
            cod_flusso,
            id_flusso,
            cod_stato,
            id_dper,
            dta_inizio
        from
            t_mcres_wrk_acquisizione a
        where 0=0
            and a.id_flusso = p_seq
            and not exists
                ( -------------- non inserisco se id_dper vecchio
                    select 1
                    from t_mcres_wrk_acquisizione b
                    where b.cod_abi = a.cod_abi
                    and b.cod_flusso = a.cod_flusso
                    and b.cod_stato = 'CARICATO'
                    and b.id_dper > a.id_dper
                );

        commit;

    exception
      when others then
        pkg_mcres_audit.log_caricamenti(p_seq, c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'ERRORE delete/insert in T_MCRES_WRK_LAST_ACQUISIZIONE');
    end;


    -- conto quanti caricamenti sono stati ìn corso per questo file.

    select count(*) into v_count
    from t_mcres_wrk_acquisizione
    where 0 = 0
        and cod_file  = p_file
        and cod_stato = v_stato_ok;

    pkg_mcres_audit.log_caricamenti(p_seq, c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'numero record in T_MCRES_WRK_ACQUISIZIONE con stato VALIDO per questo caricamento: '||v_count );

    if v_count > 1
    then

        pkg_mcres_audit.log_caricamenti(p_seq, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'In corso più di un caricamento' );

        return val_ko;

    end if;


    return val_ok;

exception
when others
then

        pkg_mcres_audit.log_caricamenti(p_seq, c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, 'ERRORE ' ||  v_note);

        return val_ko;

end;


function fnc_alliena_soglie_alert
return number
is
    c_nome                      constant varchar2(50) := c_package || '.FNC_ALLINEA_SOGLIE_ALERT';
    v_note                      t_mcres_wrk_audit_applicativo.note%type;

    v_id_alert                  t_mcres_app_gestione_alert.id_alert%type;
    v_cod_abi                   t_mcre0_app_istituti_all.cod_abi%type;
    v_del_stmt                  t_mcres_wrk_alimentazione_fen.val_del_qry%type;
    v_ins_stmt                  t_mcres_wrk_alimentazione_fen.val_ins_query%type;


    cursor c_alert
    is
        select id_alert
        from t_mcres_app_gestione_alert
        where val_current_green != val_next_green or val_current_orange != val_next_orange;

    cursor c_abi
    is

        select cod_abi
        from t_mcres_app_istituti
        where flg_target = 'Y';


begin

    pkg_mcres_audit.log_app(c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'INIZIO', null);

    for r_alert in c_alert
    loop

        begin

            v_id_alert := r_alert.id_alert;

            pkg_mcres_audit.log_app(c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'Inizio elaborazione alert ' || v_id_alert, null);


            v_note := 'Aggiornamento T_MCRES_APP_GESTIONE_ALERT - Alert ' || v_id_alert;

            update t_mcres_app_gestione_alert
            set
                val_current_green = val_next_green,
                val_current_orange = val_next_orange
            where id_alert = v_id_alert;


            v_note := 'Recupero dml per aggiornamento contatore - Alert ' || v_id_alert;


            --  non gestito con blocco anonimo in quanto
            --  se non trova dati voglio che vada in eccezzione, salti le istruzioni successive
            --  e continui con iterazione relatativa ad altro alert
            select val_del_qry, val_ins_query
            into v_del_stmt, v_ins_stmt
            from t_mcres_wrk_alimentazione_fen
            where 0=0
                and val_tbl_name = 'T_MCRES_FEN_ALERT'
                and replace (upper (flg_gruppo), ' ') = 'ID_ALERT=' || v_id_alert;



            v_note := 'Aggiornamento T_MCRES_FEN_ALERT - Alert ' || v_id_alert;

            for r_abi in c_abi
            loop

                v_cod_abi := r_abi.cod_abi;


                v_note := 'Delete relativa ad alert ' || v_id_alert || ' - COD_ABI = ' || v_cod_abi;

                execute immediate v_del_stmt using v_cod_abi;

                v_note := 'Insert relativa ad alert ' || v_id_alert || ' - COD_ABI = ' || v_cod_abi;

                execute immediate v_ins_stmt using v_cod_abi;


            end loop;

            commit;

            pkg_mcres_audit.log_app(c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'Fine elaborazione alert ' || v_id_alert, null);

        exception
        when others then

            pkg_mcres_audit.log_app(c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, v_note, null);

            rollback;

        end;

    end loop;

    pkg_mcres_audit.log_app(c_nome, pkg_mcres_audit.c_debug, sqlcode, sqlerrm, 'FINE', null);

    return val_ok;

exception
when others
then

        pkg_mcres_audit.log_app(c_nome, pkg_mcres_audit.c_error, sqlcode, sqlerrm, v_note, null);

        return val_ko;

end;


--
END PKG_MCRES_UTILS;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_UTILS FOR MCRE_OWN.PKG_MCRES_UTILS;


CREATE SYNONYM MCRE_USR.PKG_MCRES_UTILS FOR MCRE_OWN.PKG_MCRES_UTILS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_UTILS TO MCRE_USR;

