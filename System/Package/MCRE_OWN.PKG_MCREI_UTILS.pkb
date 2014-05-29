CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcrei_utils
AS
   /******************************************************************************
    NAME:       PKG_MCREI_GESTIONE_PARTIZIONI
    PURPOSE:

    REVISIONS:
    Ver        Date              Author             Description
    ---------  ----------      -----------------  ------------------------------------
    1.0      20/10/2011         E.Pellizzi         Created this package.
    1.1      15/03/2012         E.Pellizzi         CheckPeriodo rapporti_estero
   ******************************************************************************/
   FUNCTION fnc_mcrei_esegui_slave (v_seq        IN NUMBER,
                                    p_funzione   IN VARCHAR2,
                                    p_ordine     IN NUMBER,
                                    p_param      IN f_slave_par_type)
      RETURN NUMBER
   IS
      v_result   NUMBER;
      c_nome     VARCHAR2 (50) := 'FNC_MCREI_esegui_slave';
      v_string   VARCHAR2 (2000);
      --        param   f_slave_par_type;
      p_param2   f_slave_par_type := p_param;
   BEGIN
      pkg_mcrei_audit.log_caricamenti (
         v_seq,
         c_nome,
         pkg_mcrei_audit.c_debug,
         SQLCODE,
         SQLERRM,
         'CALL ' || p_funzione || '(:param) INTO :v_result'
      );
      pkg_mcrei_audit.log_caricamenti (
         v_seq,
         c_nome,
         pkg_mcrei_audit.c_debug,
         SQLCODE,
         SQLERRM,
            p_param.seq_flusso
         || ', '
         || p_param.nome_file
         || ', '
         || p_param.periodo
         || ', '
         || p_param.tab_ext
         || ', '
         || p_param.tab_trg
      );
      p_param2.ordine_alimentazione := p_ordine;
      --        p_param.ordine_alimentazione := p_ordine;
      v_string := 'CALL ' || p_funzione || '(:p_param2) INTO :v_result';
      pkg_mcrei_audit.log_caricamenti (
         v_seq,
         c_nome,
         pkg_mcrei_audit.c_debug,
         SQLCODE,
         SQLERRM,
            'funzione eseguita: '
         || p_funzione
         || '  seq_flusso: '
         || p_param.seq_flusso
         || ' nome_file: '
         || p_param.nome_file
         || ' periodo: '
         || p_param.periodo
         || ' tab_ext: '
         || p_param.tab_ext
         || ' tab_trg: '
         || p_param.tab_trg
         || 'ordine: '
         || p_param.ordine_alimentazione
      );

      EXECUTE IMMEDIATE v_string USING IN p_param2, OUT v_result;

      RETURN v_result;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (v_seq,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'FNC_MCREI_esegui_slave');
         RAISE;
   END fnc_mcrei_esegui_slave;

   FUNCTION fnc_mcrei_get_cur_sic_fnd_slv (seq IN NUMBER, p_file IN VARCHAR2)
      RETURN cur_sic_fun_type
   IS
      c_nome CONSTANT VARCHAR2 (50)
            := c_package || '.FNC_MCREI_get_cur_sic_fnd_slv' ;
      v_stato_ok   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_cur        cur_sic_fun_type;
   BEGIN
      SELECT   valore_costante
        INTO   v_stato_ok
        FROM   t_mcrei_wrk_configurazione
       WHERE   nome_costante = 'STATO_OK';

      OPEN v_cur FOR
           SELECT   d.tab_src, d.funzione_slave
             FROM   t_mcrei_wrk_acquisizione c, t_mcrei_wrk_elaborazione d
            WHERE       c.cod_file = p_file
                    AND c.cod_stato = v_stato_ok
                    AND c.cod_file = c.cod_file
                    AND d.flg_attiva_funzione = 1
         ORDER BY   d.ordine_alimentazione;

      RETURN v_cur;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END fnc_mcrei_get_cur_sic_fnd_slv;

   FUNCTION fnc_mcrei_checkin (seq IN NUMBER, p_file IN VARCHAR2)
      RETURN NUMBER
   IS
      c_nome CONSTANT            VARCHAR2 (50) := c_package || '.FNC_MCREI_checkIn';
      v_stato_ok                 t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_stato_caricato           t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_stato_ko_periodo         t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_stato_periodo_prec       t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_stato_file_non_trovato   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_stato_periodo_lavorato   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_date                     DATE;
      v_count                    NUMBER := 0;
   BEGIN
      SELECT   valore_costante
        INTO   v_stato_ok
        FROM   t_mcrei_wrk_configurazione
       WHERE   nome_costante = 'STATO_OK';

      SELECT   valore_costante
        INTO   v_stato_caricato
        FROM   t_mcrei_wrk_configurazione
       WHERE   nome_costante = 'STATO_CARICATO';

      SELECT   valore_costante
        INTO   v_stato_ko_periodo
        FROM   t_mcrei_wrk_configurazione
       WHERE   nome_costante = 'STATO_KO_PERIODO';

      SELECT   valore_costante
        INTO   v_stato_periodo_prec
        FROM   t_mcrei_wrk_configurazione
       WHERE   nome_costante = 'STATO_PERIODO_PRECEDENTE';

      SELECT   valore_costante
        INTO   v_stato_file_non_trovato
        FROM   t_mcrei_wrk_configurazione
       WHERE   nome_costante = 'STATO_FILE_NON_TROVATO';

      SELECT   valore_costante
        INTO   v_stato_periodo_lavorato
        FROM   t_mcrei_wrk_configurazione
       WHERE   nome_costante = 'STATO_PERIODO_LAVORATO';

      UPDATE   t_mcrei_wrk_acquisizione a
         SET   val_tab_external =
                  (SELECT   DISTINCT tab_src
                     FROM   t_mcrei_wrk_elaborazione b,
                            t_mcrei_wrk_acquisizione c
                    WHERE       b.cod_flusso = UPPER (c.cod_flusso)
                            AND tab_src LIKE 'TE_MCREI_%'
                            AND c.id_flusso = seq)
       WHERE   a.id_flusso = seq;

      COMMIT;

      IF (fnc_mcrei_checkperiodo (seq, p_file, v_date) = 1)
      THEN
         SELECT   COUNT ( * )
           INTO   v_count
           FROM   t_mcrei_wrk_acquisizione
          WHERE       cod_file = p_file
                  AND id_dper = v_date
                  AND cod_stato = v_stato_caricato;

         IF (v_count = 0)
         THEN
            UPDATE   t_mcrei_wrk_acquisizione
               SET   id_dper = v_date,
                     cod_stato = v_stato_ok,
                     dta_inizio = SYSDATE
             WHERE   id_flusso = seq
                     AND (cod_stato IS NULL
                          OR cod_stato = v_stato_file_non_trovato);

            pkg_mcrei_audit.log_caricamenti (
               seq,
               'PKG_MCREI_UTILS.FNC_MCREI_checkIn',
               pkg_mcrei_audit.c_debug,
               SQLCODE,
               SQLERRM,
               'T_MCREI_WRK_ACQUISIZIONE aggiornata con PERIODO_RIFERIMENTO= '
               || v_date
               || ' STATO = '
               || v_stato_ok
            );
         ELSE
            UPDATE   t_mcrei_wrk_acquisizione
               SET   cod_stato = v_stato_periodo_lavorato,
                     dta_inizio = SYSDATE
             WHERE   id_flusso = seq AND cod_stato IS NULL;

            pkg_mcrei_audit.log_caricamenti (
               seq,
               'PKG_MCREI_UTILS.FNC_MCREI_checkIn',
               pkg_mcrei_audit.c_debug,
               SQLCODE,
               SQLERRM,
               'T_MCREI_WRK_ACQUISIZIONE aggiornata con '
               || v_stato_periodo_lavorato
            );
         END IF;
      ELSE
         UPDATE   t_mcrei_wrk_acquisizione
            SET   cod_stato = v_stato_ko_periodo, dta_inizio = SYSDATE
          WHERE   id_flusso = seq AND cod_stato IS NULL;

         pkg_mcrei_audit.log_caricamenti (
            seq,
            'PKG_MCREI_UTILS.FNC_MCREI_checkIn',
            pkg_mcrei_audit.c_debug,
            SQLCODE,
            SQLERRM,
            'T_MCREI_WRK_ACQUISIZIONE aggiornata con ' || v_stato_ko_periodo
         );
      END IF;

      COMMIT;

      -- setta lo stato a "periodo precedente" se il file non contiene l'ultimo periodo disponibile per la tabella di acquisizione --
      UPDATE   t_mcrei_wrk_acquisizione b
         SET   b.cod_stato = v_stato_periodo_prec
       WHERE   b.id_flusso = seq
               AND b.id_dper < (SELECT   MAX (c.id_dper)
                                  FROM   t_mcrei_wrk_acquisizione c
                                 WHERE   c.cod_file = b.cod_file);

      COMMIT;

      -- conto quanti caricamenti sono stati ìn corso per questo file.
      SELECT   COUNT ( * )
        INTO   v_count
        FROM   t_mcrei_wrk_acquisizione
       WHERE       cod_file = p_file
               AND id_dper = v_date
               AND cod_stato = v_stato_ok;

      pkg_mcrei_audit.log_caricamenti (
         seq,
         'PKG_MCREI_UTILS.FNC_MCREI_checkIn',
         pkg_mcrei_audit.c_debug,
         SQLCODE,
         SQLERRM,
         'numero record in T_MCREI_WRK_ACQUISIZIONE con stato VALIDO per questo caricamento: '
         || v_count
      );

      IF (v_count = 1)
      THEN
         RETURN val_ok;
      ELSE
         RETURN val_ko;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (
            seq,
            'PKG_MCREI_UTILS.FNC_MCREI_checkIn',
            pkg_mcrei_audit.c_error,
            SQLCODE,
            SQLERRM,
            NULL
         );
         RETURN val_ko;
   END fnc_mcrei_checkin;

   FUNCTION fnc_mcrei_string2date_format (seq        IN     NUMBER,
                                          p_string   IN     VARCHAR2,
                                          p_format   IN     VARCHAR2,
                                          p_date        OUT DATE)
      RETURN BOOLEAN
   IS
      c_nome CONSTANT VARCHAR2 (50)
            := c_package || '.FNC_MCREI_string2date_format' ;
   BEGIN
      p_date := TO_DATE (p_string, p_format);
      --PKG_MCREI_LOG.LOG_EVENTO(c_nome,'OK');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         --PKG_MCREI_LOG.SPO_MCREI_LOG_EVENTO(seq,c_nome,'ERRORE','''' || NVL(p_string,'(NULL)') || ''' - ' || SUBSTR(SQLERRM, 1, 255));
         RETURN FALSE;
   END fnc_mcrei_string2date_format;

   FUNCTION fnc_mcrei_string2date (seq        IN     NUMBER,
                                   p_string   IN     VARCHAR2,
                                   p_date        OUT DATE)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN fnc_mcrei_string2date_format (seq,
                                           p_string,
                                           'YYYYMMDD',
                                           p_date);
   END fnc_mcrei_string2date;

   FUNCTION fnc_mcrei_string2date (seq IN NUMBER, p_string IN VARCHAR2)
      RETURN BOOLEAN
   IS
      v_date   DATE;
   BEGIN
      RETURN fnc_mcrei_string2date (seq, p_string, v_date);
   END fnc_mcrei_string2date;

   FUNCTION fnc_mcrei_checkperiodo (seq      IN     NUMBER,
                                    p_file   IN     VARCHAR2,
                                    p_date      OUT DATE)
      RETURN NUMBER
   IS
      c_nome CONSTANT VARCHAR2 (50)
            := c_package || '.FNC_MCREI_checkPeriodo' ;
      v_work_dir      t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_ext_table     t_mcrei_wrk_acquisizione.val_tab_external%TYPE;
      v_sql           VARCHAR2 (255);
      v_periodo       VARCHAR2 (20);
      v_flag          BOOLEAN := FALSE;
      v_cod_flusso    t_mcrei_wrk_acquisizione.cod_flusso%TYPE;
      v_desc_flusso   t_mcrei_wrk_alimentazione.desc_flusso%TYPE;
      v_command       VARCHAR2 (4000 BYTE);
   BEGIN
      v_command :=
         '
        SELECT valore_costante
        INTO v_work_dir
        FROM t_mcrei_wrk_configurazione
       WHERE nome_costante = ''WORK_DIRECTORY''';

      SELECT   valore_costante
        INTO   v_work_dir
        FROM   t_mcrei_wrk_configurazione
       WHERE   nome_costante = 'WORK_DIRECTORY';

      v_command :=
         'SELECT cod_flusso
        INTO v_cod_flusso
        FROM t_mcrei_wrk_acquisizione
       WHERE id_flusso = seq';

      SELECT   cod_flusso
        INTO   v_cod_flusso
        FROM   t_mcrei_wrk_acquisizione
       WHERE   id_flusso = seq;

      v_command :=
         'SELECT   ALIM.DESC_FLUSSO
      INTO   v_desc_flusso
      FROM   T_MCREI_WRK_ALIMENTAZIONE ALIM, T_MCREI_WRK_ACQUISIZIONE ACQ
     WHERE   ALIM.COD_FLUSSO = ACQ.COD_FLUSSO AND ACQ.ID_FLUSSO = seq';

      SELECT   alim.desc_flusso
        INTO   v_desc_flusso
        FROM   t_mcrei_wrk_alimentazione alim, t_mcrei_wrk_acquisizione acq
       WHERE   alim.cod_flusso = acq.cod_flusso AND acq.id_flusso = seq;

      IF (v_desc_flusso = 'MULTI')
      THEN
         v_command :=
            'SELECT b.tab_aux_esterna
           INTO v_ext_table
           FROM t_mcrei_wrk_anagrafica b, t_mcrei_wrk_acquisizione c
          WHERE c.cod_file = p_file
            AND b.cod_file = c.cod_file
            AND c.id_flusso = seq';

         SELECT   b.tab_aux_esterna
           INTO   v_ext_table
           FROM   t_mcrei_wrk_anagrafica b, t_mcrei_wrk_acquisizione c
          WHERE       c.cod_file = p_file
                  AND b.cod_file = c.cod_file
                  AND c.id_flusso = seq;

         CASE
            WHEN p_file = 'BENI'
            THEN
               v_sql :=
                  'SELECT distinct to_number(to_char((to_date(TRIM(ID_DPER),''ddmmyyyy'')),''ddmmyyyy'')) FROM '
                  || v_ext_table
                  || ' WHERE  ROWNUM = 1';
            WHEN p_file = 'PERDATT'
            THEN
               v_sql :=
                  'SELECT distinct to_number(to_char((to_date(TRIM(ID_DPER),''ddmmyyyy'')),''YYYYMMDD'')) FROM '
                  || v_ext_table
                  || ' WHERE  ROWNUM = 1';
            WHEN p_file = 'RATE_DAILY'
            THEN
               v_sql :=
                  'SELECT distinct to_number(to_char((to_date(TRIM(ID_DPER),''DDMMYYYY'')),''YYYYMMDD'')) FROM '
                  || v_ext_table
                  || ' WHERE  ROWNUM = 1';
            WHEN p_file = 'LIFA'
            THEN
               v_sql :=
                  'SELECT distinct to_number(to_char((to_date(TRIM(ID_DPER),''YYYYMMDD'')),''YYYYMMDD'')) FROM '
                  || v_ext_table
                  || ' WHERE  ROWNUM = 1';
            WHEN p_file = 'ALLRATE'
            THEN
                 v_sql :=
                  'SELECT distinct to_number(to_char((to_date(TRIM(ID_DPER),''DDMMYYYY'')),''YYYYMMDD'')) FROM '
                  || v_ext_table
                  || ' WHERE  ROWNUM = 1';
            ELSE
               v_sql :=
                  'SELECT distinct to_number(to_char((to_date(TRIM(ID_DPER),''ddmmyyyy'')),''yyyymmdd'')) FROM '
                  || v_ext_table
                  || ' WHERE  ROWNUM = 1';
         END CASE;

         v_command := v_sql;
      ELSE
         v_command :=
            'SELECT c.val_tab_external
           INTO v_ext_table
           FROM t_mcrei_wrk_acquisizione c
          WHERE c.id_flusso = seq
         SELECT c.val_tab_external
           INTO v_ext_table
           FROM t_mcrei_wrk_acquisizione c
          WHERE c.id_flusso = seq';

         SELECT   c.val_tab_external
           INTO   v_ext_table
           FROM   t_mcrei_wrk_acquisizione c
          WHERE   c.id_flusso = seq;

         SELECT   c.val_tab_external
           INTO   v_ext_table
           FROM   t_mcrei_wrk_acquisizione c
          WHERE   c.id_flusso = seq;

         v_sql :=
            'SELECT distinct TRIM(ID_DPER) FROM ' || v_ext_table
            || '
          WHERE    COD_ABI = (SELECT COD_ABI FROM T_MCREI_WRK_ACQUISIZIONE WHERE ID_FLUSSO = '
            || seq
            || ')';
         v_command := v_sql;
      END IF;

      v_command := 'EXECUTE IMMEDIATE ' || v_sql || ' into ' || v_periodo;

      EXECUTE IMMEDIATE v_sql INTO   v_periodo;

      v_flag := fnc_mcrei_string2date (seq, v_periodo, p_date);
      pkg_mcrei_audit.log_caricamenti (
         seq,
         'PKG_MCREI_UTILS.CHECK_PERIODO',
         pkg_mcrei_audit.c_debug,
         SQLCODE,
         SQLERRM,
         'periodo riferimento: ' || p_date || '; ' || v_command
      );

      IF v_flag
      THEN
         RETURN val_ok;
      ELSE
         RETURN val_ko;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (
            seq,
            'PKG_MCREI_UTILS.CHECK_PERIODO',
            pkg_mcrei_audit.c_debug,
            SQLCODE,
            SQLERRM,
            'periodo riferimento: ' || p_date || '; ' || v_command
         );
         RETURN val_ko;
   END fnc_mcrei_checkperiodo;

   PROCEDURE spo_mcrei_clean_log_tables (p_seq IN NUMBER)
   IS
      c_nome CONSTANT VARCHAR2 (50)
            := c_package || '.svecchiamento_log_tables' ;
      v_stato_ok             t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_periodo              DATE;
      v_mesi_svecchiamento   NUMBER;
   BEGIN
      SELECT   valore_costante
        INTO   v_stato_ok
        FROM   t_mcrei_wrk_configurazione
       WHERE   nome_costante = 'STATO_OK';

      BEGIN
         SELECT   valore_costante
           INTO   v_mesi_svecchiamento
           FROM   t_mcrei_wrk_configurazione
          WHERE   nome_costante = 'MESI_SVECCHIAMENTO_EVENTI_PROCESSI_LOG';
      EXCEPTION
         WHEN OTHERS
         THEN
            v_mesi_svecchiamento := 0;
      END;

      IF (v_mesi_svecchiamento > 0)
      THEN
         SELECT   MAX (id_dper)
           INTO   v_periodo
           FROM   t_mcrei_wrk_acquisizione
          WHERE   cod_stato = v_stato_ok;

         COMMIT;
      END IF;
   END spo_mcrei_clean_log_tables;

   FUNCTION fnc_mcrei_process_file (id_flusso IN NUMBER)
      RETURN NUMBER
   IS
      c_nome CONSTANT     VARCHAR2 (50) := c_package || '.process_file';
      v_master_function   t_mcrei_wrk_acquisizione.cod_file%TYPE;
      v_result            NUMBER := -1;
      v_return            BOOLEAN;
      v_seq               NUMBER := id_flusso;
      v_count             NUMBER;
      p_file              t_mcrei_wrk_acquisizione.cod_file%TYPE;
   BEGIN
      pkg_mcrei_audit.log_caricamenti (v_seq,
                                       c_nome,
                                       pkg_mcrei_audit.c_debug,
                                       SQLCODE,
                                       SQLERRM,
                                       'inizio..: ' || v_seq);

      SELECT   cod_file
        INTO   p_file
        FROM   t_mcrei_wrk_acquisizione
       WHERE   id_flusso = v_seq;

      pkg_mcrei_audit.log_caricamenti (v_seq,
                                       c_nome,
                                       pkg_mcrei_audit.c_debug,
                                       SQLCODE,
                                       SQLERRM,
                                       'caricamento COD_FILE: ' || p_file);

      IF (fnc_mcrei_checkin (v_seq, p_file) = 1)
      THEN
         -- se i controlli sono andati a buon fine lancio il caricamento.
         v_result :=
            pkg_mcrei_funzioni_master.fnc_mcrei_master (v_seq, p_file);
         pkg_mcrei_audit.log_caricamenti (
            v_seq,
            c_nome,
            pkg_mcrei_audit.c_debug,
            SQLCODE,
            SQLERRM,
            'caricamento terminato con esito: ' || v_result
         );
      END IF;

      RETURN v_result;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (v_seq,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          NULL);
         RETURN -1;
   END fnc_mcrei_process_file;

   FUNCTION fnc_mcrei_get_ext_table (v_seq IN NUMBER, p_file IN VARCHAR2)
      RETURN VARCHAR2
   IS
      c_nome CONSTANT VARCHAR2 (50)
            := c_package || '.FNC_MCREI_get_ext_table' ;
      v_stato_ok    t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_ext_table   t_mcrei_wrk_elaborazione.tab_src%TYPE;
   BEGIN
      SELECT   valore_costante
        INTO   v_stato_ok
        FROM   t_mcrei_wrk_configurazione
       WHERE   nome_costante = 'STATO_OK';

      SELECT   val_tab_external
        INTO   v_ext_table
        FROM   t_mcrei_wrk_acquisizione
       WHERE   id_flusso = v_seq;

      RETURN v_ext_table;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (v_seq,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          NULL);
         RETURN NULL;
   END fnc_mcrei_get_ext_table;

   FUNCTION fnc_mcrei_get_slave_param (v_seq IN NUMBER, p_file IN VARCHAR2)
      RETURN f_slave_par_type
   IS
      c_nome CONSTANT VARCHAR2 (50)
            := c_package || '.FNC_MCREI_get_slave_param' ;
      v_slave_par   f_slave_par_type;
   BEGIN
      v_slave_par := fnc_mcrei_get_slave_param_sic (v_seq, p_file);
      v_slave_par.tab_ext :=
         pkg_mcrei_utils.fnc_mcrei_get_ext_table (v_slave_par.seq_flusso,
                                                  p_file);
      pkg_mcrei_audit.log_caricamenti (
         v_seq,
         c_nome,
         pkg_mcrei_audit.c_debug,
         SQLCODE,
         SQLERRM,
         'Tabella esterna: ' || v_slave_par.tab_ext
      );
      v_slave_par.tab_trg :=
         pkg_mcrei_utils.fnc_mcrei_get_trg_table (v_slave_par.seq_flusso,
                                                  NULL);
      pkg_mcrei_audit.log_caricamenti (
         v_seq,
         c_nome,
         pkg_mcrei_audit.c_debug,
         SQLCODE,
         SQLERRM,
         'Tabella target: ' || v_slave_par.tab_trg
      );
      RETURN v_slave_par;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (v_seq,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          NULL);
         RETURN NULL;
   END fnc_mcrei_get_slave_param;

   FUNCTION fnc_mcrei_get_cur_fnd_slv (v_seq         IN NUMBER,
                                       p_file        IN VARCHAR2,
                                       p_ext_table   IN VARCHAR2)
      RETURN cur_func_type
   IS
      c_nome CONSTANT VARCHAR2 (50)
            := c_package || '.FNC_MCREI_get_cur_fnd_slv' ;
      v_stato_ok   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_cur        cur_func_type;
   BEGIN
      SELECT   valore_costante
        INTO   v_stato_ok
        FROM   t_mcrei_wrk_configurazione
       WHERE   nome_costante = 'STATO_OK';

      pkg_mcrei_audit.log_caricamenti (
         v_seq,
         c_nome,
         pkg_mcrei_audit.c_debug,
         SQLCODE,
         SQLERRM,
            'p_file: '
         || p_file
         || ' - v_stato_ok: '
         || v_stato_ok
         || ' p_ext_table '
         || p_ext_table
      );

      OPEN v_cur FOR
           SELECT   d.funzione_slave, d.ordine_alimentazione
             FROM   t_mcrei_wrk_acquisizione c, t_mcrei_wrk_elaborazione d
            WHERE       c.id_flusso = v_seq
                    AND                  --            c.cod_file = p_file and
                                    --            c.cod_STATO = v_stato_ok AND
                    d.cod_flusso = c.cod_flusso
                    AND              --            d.TAB_SRC = p_ext_table AND
                       d.flg_attiva_funzione = 1
         ORDER BY   d.ordine_alimentazione;

      pkg_mcrei_audit.log_caricamenti (v_seq,
                                       c_nome,
                                       pkg_mcrei_audit.c_debug,
                                       SQLCODE,
                                       SQLERRM,
                                       'cursore aperto..');
      RETURN v_cur;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (v_seq,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          NULL);
         RETURN NULL;
   END fnc_mcrei_get_cur_fnd_slv;

   FUNCTION fnc_mcrei_get_trg_table (v_seq IN NUMBER, p_ordine IN NUMBER)
      RETURN VARCHAR2
   IS
      c_nome CONSTANT VARCHAR2 (50)
            := c_package || '.FNC_MCREI_get_trg_table' ;
      v_stato_ok    t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_trg_table   t_mcrei_wrk_elaborazione.tab_trg%TYPE;
      p_ord         NUMBER := 20;
   BEGIN
      pkg_mcrei_audit.log_caricamenti (
         v_seq,
         c_nome,
         pkg_mcrei_audit.c_debug,
         SQLCODE,
         SQLERRM,
         'v_seq: ' || v_seq || ', ordine_funzione: ' || p_ordine
      );

      SELECT   valore_costante
        INTO   v_stato_ok
        FROM   t_mcrei_wrk_configurazione
       WHERE   nome_costante = 'STATO_OK';

      SELECT   d.tab_trg
        INTO   v_trg_table
        FROM   t_mcrei_wrk_acquisizione c, t_mcrei_wrk_elaborazione d
       WHERE       c.id_flusso = v_seq
               AND c.cod_flusso = d.cod_flusso
               AND d.ordine_alimentazione = p_ord;

      RETURN v_trg_table;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (v_seq,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          NULL);
         RETURN NULL;
   END fnc_mcrei_get_trg_table;

   FUNCTION fnc_mcrei_get_slave_param_sic (v_seq    IN NUMBER,
                                           p_file   IN VARCHAR2)
      RETURN f_slave_par_type
   IS
      c_nome CONSTANT VARCHAR2 (50)
            := c_package || '.FNC_MCREI_get_slave_param_sic' ;
      v_slave_par f_slave_par_type
            := f_slave_par_type (v_seq,
                                 p_file,
                                 NULL,
                                 NULL,
                                 NULL,
                                 NULL) ;
   BEGIN
      SELECT   id_dper
        INTO   v_slave_par.periodo
        FROM   t_mcrei_wrk_acquisizione
       WHERE   id_flusso = v_seq;

      RETURN v_slave_par;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (v_seq,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          NULL);
         RETURN NULL;
   END fnc_mcrei_get_slave_param_sic;

   FUNCTION fnc_mcrei_execute (p_param1   IN VARCHAR2,
                               p_param2   IN VARCHAR2,
                               p_param3   IN VARCHAR2,
                               p_param4   IN VARCHAR2)
      RETURN BOOLEAN
   IS
      c_nome CONSTANT   VARCHAR2 (50) := c_package || '.FNC_MCREI_execute';
   BEGIN
      DBMS_OUTPUT.put_line (p_param1 || p_param2 || p_param3 || p_param4);

      EXECUTE IMMEDIATE p_param1 || p_param2 || p_param3 || p_param4;

      DBMS_OUTPUT.put_line ('OK');
      --PKG_MCREI_LOG.SPO_MCREI_LOG_EVENTO(0,c_nome,'OK', 'ESEGUITO');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         --PKG_MCREI_LOG.SPO_MCREI_LOG_EVENTO(0,c_nome,'ERRORE' ,SUBSTR(SQLERRM, 1, 255));
         DBMS_OUTPUT.put_line (SUBSTR (SQLERRM, 1, 255));
         RETURN FALSE;
   END fnc_mcrei_execute;
END pkg_mcrei_utils;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_UTILS FOR MCRE_OWN.PKG_MCREI_UTILS;


CREATE SYNONYM MCRE_USR.PKG_MCREI_UTILS FOR MCRE_OWN.PKG_MCREI_UTILS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_UTILS TO MCRE_USR;

