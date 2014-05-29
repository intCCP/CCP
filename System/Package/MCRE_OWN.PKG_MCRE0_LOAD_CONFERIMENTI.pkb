CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcre0_LOAD_conferimenti
AS
   /******************************************************************************
   NAME:       PKG_MCRE0_MIG_NDG_RAP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        22/06/2012  1.I.Gueorguieva  Created this package body.
   1.1        24/09/2012  1.I.Gueorguieva  Inserito controllo id_dper caricamento t_mcre0_app_mig_recode_ndg
   1.2        05/10/2012  1.I.Gueorguieva Inserito controllo su id_dper su tutti i flussi; truncate se l'id_dper
                                           è superiore all'ultimo caricato per il flusso
   1.3        08/10/2012  M.Murro         filtro pres-cruscotto su no delibera = 0
    1.4        09/10/2012  I.Gueorguieva Cancellazione AFTABRAC per abi ricevente

   ******************************************************************************/
   -- %author
   -- %version 0.1
   -- %usage  function che TESTA l'esistenza di una partizione sulla tabella passata per argomento
   -- %d La function verifica se esiste una partizione di nome INC_P||ID_dper
   -- %return 1 --> esiste partizione, 0 altrimenti
   -- %cd 25 GIU 2012
   FUNCTION fnc_esiste_partizione (id_dper IN NUMBER, p_tab_name IN VARCHAR2)
      RETURN NUMBER
   IS
      c_nome CONSTANT VARCHAR2 (100)
            := c_package || '.FNC_ESISTE_PARTIZIONE' ;
      c_note     VARCHAR2 (4000);
      v_sql      VARCHAR2 (4000);
      v_esiste   NUMBER := ko;
   BEGIN
      BEGIN
         c_note := 'Controllo esistenza partizione INC_P' || TO_CHAR (id_dper);

         SELECT   1
           INTO   v_esiste
           FROM   all_tab_partitions
          WHERE       table_owner = 'MCRE_OWN'
                  AND table_name = p_tab_name
                  AND partition_name = 'INC_P' || TO_CHAR (id_dper);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_esiste := ko;
            pkg_mcrei_audit.log_app (c_nome,
                                     pkg_mcrei_audit.c_error,
                                     SQLCODE,
                                     SQLERRM,
                                     c_note,
                                     NULL);
      END;

      RETURN v_esiste;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
         RETURN v_esiste;
   END fnc_esiste_partizione;

   -- %author
   -- %version 0.1
   -- %usage  function che tenta di CREARE una nuova partizione sulla tabella passata per argomento
   -- %d La function tenta di creare una partizione di nome INC_P||ID_dper
   -- %return 1 --> successo creazione, 0 altrimenti
   -- %cd 25 GIU 2012
   FUNCTION fnc_add_partition (id_dper IN NUMBER, p_tab_name IN VARCHAR2)
      RETURN NUMBER
   IS
      c_nome CONSTANT   VARCHAR2 (100) := c_package || '.FNC_ADD_PARTITION';
      c_note            VARCHAR2 (4000);
      v_sql             VARCHAR2 (4000);
   BEGIN
      c_note :=
            'Creazione nuova partizione INC_P'
         || id_dper
         || ' tabella '
         || p_tab_name;
      v_sql :=
            'ALTER TABLE '
         || p_tab_name
         || ' SPLIT PARTITION INC_PALTRI AT
('
         || TO_CHAR (id_dper + 1)
         || ')
INTO (PARTITION
INC_P'
         || TO_CHAR (id_dper)
         || '
TABLESPACE TSD_MCRE_OWN,
PARTITION INC_PALTRI)';

      EXECUTE IMMEDIATE v_sql;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
         RETURN ko;
   END fnc_add_partition;

   FUNCTION fnc_esiste_sottopartizione (V_id_dper    IN NUMBER,
                                        p_tab_name   IN VARCHAR2,
                                        v_cod_abi    IN VARCHAR2)
      RETURN NUMBER
   IS
      v_exists       NUMBER;
      c_nome CONSTANT VARCHAR2 (100)
            := c_package || '.FNC_ESISTE_SOTTOPARTIZIONE' ;
      c_note         VARCHAR2 (4000);
      p_partizione   VARCHAR2 (50);
   BEGIN
      p_partizione := 'INC_P' || TO_CHAR (V_ID_DPER) || '_' || v_cod_abi;

      SELECT   DECODE (COUNT ( * ), 0, 0, 1)
        INTO   v_exists
        FROM   user_tab_subpartitions
       WHERE   table_name = UPPER (p_tab_name)
               AND subpartition_name = p_partizione;

      RETURN v_exists;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
         RETURN ko;
   END fnc_esiste_sottopartizione;

   FUNCTION fnc_add_subpartition (v_id_dper    IN NUMBER,
                                  p_tab_name   IN VARCHAR2,
                                  v_cod_abi    IN VARCHAR2)
      RETURN NUMBER
   IS
      c_nome CONSTANT VARCHAR2 (100)
            := c_package || '.FNC_ADD_SUBPARTITION' ;
      c_note   VARCHAR2 (4000);
      v_sql    VARCHAR2 (4000);
   BEGIN
      c_note :=
            'Creazione nuova sottopartizione INC_P'
         || v_id_dper
         || '_'
         || v_cod_abi
         || ' tabella '
         || p_tab_name;

      v_sql :=
            'ALTER TABLE '
         || p_tab_name
         || ' SPLIT SUBPARTITION INC_P'
         || TO_CHAR (V_ID_DPER)
         || '_ALTRI'
         || ' VALUES('''
         || V_COD_ABI
         || ''') INTO(
SUBPARTITION INC_P'
         || TO_CHAR (V_ID_DPER)
         || '_'
         || V_COD_ABI
         || ' TABLESPACE TSD_MCRE_OWN,'
         || 'SUBPARTITION INC_P'
         || TO_CHAR (V_ID_DPER)
         || '_ALTRI)';

      EXECUTE IMMEDIATE v_sql;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
         RETURN ko;
   END fnc_add_subpartition;

   -- %author
   -- %version 0.1
   -- %usage  function che carica i dati provenienti dai file AFTABRAC  nelle tabelle ST
   -- %d La function carica i dati nella ST corrispondenente a seconda dell'id_flusso passato
   -- %d Sulla tabella T_MCRE0_MIG_ACQUISIZIONE deve essere presente un record con
   -- %d ID_FLUSSO = V_ID_FLUSSO. Il caricamento parte solo se
   -- %d T_MCRE0_MIG_ACQUISIZIONE.COD_FILE = T_MCRE0_WRK_MIG_NDG_RAP.COD_FLUSSO
   -- %param V_ID_FLUSSO numero unico identificativo del caricamento
   -- %param V_ID_DPER data trasformata in formato numerico YYYYMMDD inserita nella colonna ID_DPER della tabella ST
   -- %return 1 --> successo caricamento, 0 altrimenti
   -- %cd 27 GIU 2012
   FUNCTION fnc_load_st (v_id_flusso IN NUMBER, v_id_dper IN NUMBER)
      RETURN NUMBER
   IS
      c_nome CONSTANT        VARCHAR2 (100) := c_package || '.FNC_LOAD_ST';
      c_note                 t_mcrei_wrk_audit_applicativo.note%TYPE := 'Generale';
      v_esiste_caricamento   NUMBER;
      v_sql                  VARCHAR2 (4000);
      v_val_tab_st           VARCHAR2 (30 BYTE);
      v_val_qry_st           t_mcre0_wrk_mig_ndg_rap.val_qry_st%TYPE;
      v_val_qry_vincoli      t_mcre0_wrk_mig_ndg_rap.val_qry_st%TYPE;
      v_cod_file             t_mcre0_mig_acquisizione.cod_file%TYPE;
      v_esito                NUMBER;
      v_creata_par           NUMBER;
      v_creata_sottopar      NUMBER;
      V_COD_ABI              VARCHAR2 (5);
      v_lock_result          NUMBER;
      v_lockhandle           VARCHAR2 (200);
   BEGIN
      BEGIN
         SELECT   cod_file, COD_ABI
           INTO   v_cod_file, V_COD_ABI
           FROM   t_mcre0_mig_acquisizione
          WHERE   id_flusso = v_id_flusso;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            c_note :=
                  'ID_FLUSSO = '
               || v_id_flusso
               || ' Non trovato su T_MCRE0_MIG_ACQUISIZIONE';
            pkg_mcrei_audit.log_app (c_nome,
                                     pkg_mcrei_audit.c_error,
                                     SQLCODE,
                                     SQLERRM,
                                     c_note,
                                     NULL);
            RETURN ko;
      END;

      c_note := 'Recupero query vincoli e ST per il flusso: ' || v_cod_file;

      SELECT   val_qry_vincoli, val_qry_st, val_tab_st
        INTO   v_val_qry_vincoli, v_val_qry_st, v_val_tab_st
        FROM   t_mcre0_wrk_mig_ndg_rap
       WHERE   cod_flusso = v_cod_file AND flg_attiva = 1;

      DBMS_LOCK.allocate_unique (v_val_tab_st, v_lockhandle);
      v_lock_result := DBMS_LOCK.request (v_lockhandle, DBMS_LOCK.x_mode);

      SELECT   'LOCK_RESULT LOCKED - '
               || CASE
                     WHEN v_lock_result = 1 THEN 'Timeout'
                     WHEN v_lock_result = 2 THEN 'Deadlock'
                     WHEN v_lock_result = 3 THEN 'Parameter Error'
                     WHEN v_lock_result = 4 THEN 'Already owned'
                     WHEN v_lock_result = 5 THEN 'Illegal Lock Handle'
                  END
        INTO   C_NOTE
        FROM   DUAL;

      pkg_mcrei_audit.log_app (c_nome,
                               pkg_mcrei_audit.c_debug,
                               SQLCODE,
                               SQLERRM,
                               C_NOTE,
                               NULL);

      UPDATE   t_mcre0_mig_acquisizione
         SET   dta_inizio = SYSDATE, cod_stato = c_inizio_caricamento
       WHERE   id_flusso = v_id_flusso;

      COMMIT;

      v_esito := fnc_esiste_partizione (v_id_dper, v_val_tab_st);

      IF v_esito = ko
      THEN
         v_creata_par := fnc_add_partition (v_id_dper, v_val_tab_st);
      ELSE
         v_creata_par := ok;
      END IF;

      v_esito :=
         fnc_esiste_sottopartizione (v_id_dper, v_val_tab_st, v_cod_abi);

      IF v_esito = ko
      THEN
         v_creata_sottopar :=
            fnc_add_subpartition (v_id_dper, v_val_tab_st, v_cod_abi);
      ELSE
         v_creata_sottopar := ok;
      END IF;

      IF v_creata_sottopar = OK AND v_creata_par = OK
      THEN
         IF v_val_qry_vincoli IS NOT NULL
         THEN
            EXECUTE IMMEDIATE TO_CHAR (v_val_qry_vincoli)
               USING v_id_flusso, v_id_dper, v_cod_abi;

            COMMIT;
         ELSE
            c_note := 'Query vincoli IS NULL per il flusso ' || v_cod_file;
         END IF;

         IF v_val_qry_st IS NOT NULL
         THEN
            v_sql :=
                  'DELETE '
               || v_val_tab_st
               || ' WHERE '
               || 'ID_DPER = '
               || v_id_dper
               || ' AND COD_ABI_NEW='''
               || V_COD_ABI
               || '''';

            IF v_cod_file = 'AFH18'
            THEN
               v_sql :=
                     'DELETE '
                  || v_val_tab_st
                  || ' WHERE '
                  || 'ID_DPER = '
                  || v_id_dper
                  || ' AND COD_ABI_OLD='''
                  || V_COD_ABI
                  || '''';
            END IF;

            EXECUTE IMMEDIATE v_sql;

            COMMIT;

            EXECUTE IMMEDIATE TO_CHAR (v_val_qry_st)
               USING v_id_dper, v_cod_abi;
         ELSE
            c_note := 'Query st IS NULL per il flusso ' || v_cod_file;
         END IF;

         COMMIT;       -- ST CARICATA: COD_STATO = 1
         UPDATE   t_mcre0_mig_acquisizione
            SET   cod_stato = c_caricata_st
          WHERE   id_flusso = v_id_flusso;

         COMMIT;
      END IF;

      v_lock_result := DBMS_LOCK.release (v_lockhandle);
      C_NOTE := 'LOCK RELEASED';
      pkg_mcrei_audit.log_app (c_nome,
                               pkg_mcrei_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                               c_note,
                               NULL);
      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
         RETURN ko;
   END fnc_load_st;

   -- %author
   -- %version 0.1
   -- %usage  function che carica i dati provenienti dai file AFTABRAC  nelle tabelle APP
   -- %d Logica analoga a quella di FNC_LOAD_ST
   -- %param V_ID_FLUSSO numero unico identificativo del caricamento
   -- %param V_ID_DPER data trasformata in formato numerico YYYYMMDD inserita nella colonna ID_DPER della tabella APP
   -- %return 1 --> successo caricamento, 0 altrimenti
   -- %cd 27 GIU 2012
   FUNCTION fnc_load_app (v_id_flusso IN NUMBER, v_id_dper IN NUMBER)
      RETURN NUMBER
   IS
      c_nome CONSTANT        VARCHAR2 (100) := c_package || '.FNC_LOAD_APP';
      c_note                 t_mcrei_wrk_audit_applicativo.note%TYPE := 'Generale';
      v_sql                  VARCHAR2 (4000):=NULL;
      v_val_tab_app          VARCHAR2 (30 BYTE);
      v_val_qry_app          t_mcre0_wrk_mig_ndg_rap.val_qry_app%TYPE;
      v_val_qry_vincoli      t_mcre0_wrk_mig_ndg_rap.val_qry_app%TYPE;
      v_cod_file             t_mcre0_mig_acquisizione.cod_file%TYPE;
      v_esito                NUMBER;
      v_cod_abi              VARCHAR2 (5);
      v_lock_result          NUMBER;
      v_lockhandle           VARCHAR2 (200);
      V_ID_DPER_OLD          NUMBER;
      V_ID_DPER_OLD_ABI      NUMBER;
      V_STATO                VARCHAR2(45);
   BEGIN

      BEGIN
         SELECT   cod_file, COD_ABI
           INTO   v_cod_file, V_COD_ABI
           FROM   t_mcre0_mig_acquisizione
          WHERE   id_flusso = v_id_flusso;

      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            c_note :=
                  'ID_FLUSSO = '
               || v_id_flusso
               || ' Non trovato su T_MCRE0_MIG_ACQUISIZIONE';
            pkg_mcrei_audit.log_app (c_nome,
                                     pkg_mcrei_audit.c_error,
                                     SQLCODE,
                                     SQLERRM,
                                     c_note,
                                     NULL);
            RETURN ko;
      END;
       c_note := 'Recupero query APP per il flusso: ' || v_cod_file;
      SELECT   val_qry_app, val_tab_app
        INTO   v_val_qry_app, v_val_tab_app
        FROM   t_mcre0_wrk_mig_ndg_rap
       WHERE   cod_flusso = v_cod_file AND flg_attiva = 1;

      DBMS_LOCK.allocate_unique (v_val_tab_app, v_lockhandle);
      v_lock_result := DBMS_LOCK.request (v_lockhandle, DBMS_LOCK.x_mode);

      SELECT   'LOCK_RESULT LOCKED - '
               || CASE
                     WHEN v_lock_result = 1 THEN 'Timeout'
                     WHEN v_lock_result = 2 THEN 'Deadlock'
                     WHEN v_lock_result = 3 THEN 'Parameter Error'
                     WHEN v_lock_result = 4 THEN 'Already owned'
                     WHEN v_lock_result = 5 THEN 'Illegal Lock Handle'
                  END
        INTO   C_NOTE
        FROM   DUAL;
      pkg_mcrei_audit.log_app (c_nome,
                               pkg_mcrei_audit.c_debug,
                               SQLCODE,
                               SQLERRM,
                               C_NOTE,
                               NULL);
       BEGIN
            SELECT NVL(MAX(ID_DPER),0)
              INTO  v_id_dper_old
              FROM T_MCRE0_MIG_ACQUISIZIONE
            WHERE COD_FILE = V_COD_FILE
             AND ID_FLUSSO <> V_ID_FLUSSO;

          EXCEPTION WHEN NO_DATA_FOUND THEN
            V_ID_DPER_OLD:=0;
          END;

       BEGIN
            SELECT NVL(MAX(ID_DPER),0)
              INTO  V_ID_DPER_OLD_ABI
              FROM T_MCRE0_MIG_ACQUISIZIONE
            WHERE COD_FILE = V_COD_FILE
              AND COD_ABI = V_COD_ABI
              AND ID_FLUSSO <> V_ID_FLUSSO;

          EXCEPTION WHEN NO_DATA_FOUND THEN
            V_ID_DPER_OLD_ABI:=0;
       END;

      IF v_val_qry_app IS NOT NULL THEN
         IF V_ID_DPER > V_ID_DPER_OLD THEN -- controllo ultimo id_dper caricato per il flusso
         IF V_COD_FILE = 'AFH18' THEN
            V_SQL:= 'TRUNCATE TABLE '||v_val_tab_app;
         ELSE
          V_SQL:= 'DELETE '||v_val_tab_app||' WHERE COD_ABI_NEW = '||V_COD_ABI ;
         END IF;
            --T_MCRE0_APP_MIG_RECODE_NDG
            EXECUTE IMMEDIATE V_SQL;
            COMMIT;
            c_note := 'Delete  table ' || v_cod_file||' eseguita '||';';
         ELSE
             V_STATO:=c_periodo_caricato;

         END IF;

         IF V_ID_DPER > V_ID_DPER_OLD_ABI THEN
             C_NOTE:=C_NOTE||' Caricamento flusso '||v_cod_file||' id_dper: '||v_id_dper||' v_cod_abi '||v_cod_abi||';';
             EXECUTE IMMEDIATE TO_CHAR (v_val_qry_app) USING v_id_dper, v_cod_abi;
             V_STATO:= c_caricata_app;
             c_note := c_note||' Caricati dati per '||v_cod_abi||' in '||v_val_tab_app||';';
         ELSE
            V_STATO:=C_PERIODO_CARICATO_ABI;
         END IF;
         UPDATE   t_mcre0_mig_acquisizione
            SET   cod_stato = V_STATO,
                   id_dper = DECODE(V_STATO,c_caricata_app, v_id_dper,id_dper),
                    dta_fine = SYSDATE
           WHERE   id_flusso = v_id_flusso;
         COMMIT;
      ELSE
         C_NOTE:=' Qry app di t_mcre0_wrk_mig_ndg_rap a NULL '||v_cod_file||' id_dper: '||v_id_dper||' v_cod_abi '||v_cod_abi;
      END IF;
      v_lock_result := DBMS_LOCK.release (v_lockhandle);
      C_NOTE := c_note||' LOCK RELEASED ';
      pkg_mcrei_audit.log_app (c_nome,
                               pkg_mcrei_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                               c_note,
                               NULL);

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
         v_lock_result := DBMS_LOCK.release (v_lockhandle);
         RETURN ko;
   END fnc_load_app;

   -- %author
   -- %version 0.1
   -- %usage  function che calcola il FLG_CRUSCOTTO SU T_MCRE0_APP_MIG_RECODE_NDG
   -- %d FLG_CRUSCOTTO = 1, se sulla tabella delle delibere e' presente almeno
   -- %d delibera, che non e' di classificazione ed il e' manuale.
   -- %param V_ID_FLUSSO numero unico identificativo del caricamento
   -- %return 1 --> successo calcolo, 0 altrimenti
   -- %cd 28 GIU 2012
   FUNCTION fnc_calcola_flg_cruscotto (v_id_flusso IN NUMBER)
      RETURN NUMBER
   IS
      c_nome CONSTANT VARCHAR2 (100)
            := c_package || '.FNC_CALCOLA_FLG_CRUSCOTTO' ;
      c_note        t_mcrei_wrk_audit_applicativo.note%TYPE := 'Generale';
      v_cod_stato   t_mcre0_mig_acquisizione.cod_stato%TYPE;
      v_cod_file    t_mcre0_mig_acquisizione.cod_file%TYPE;
   BEGIN
      --SELECT cod_file,
      --cod_stato
      --INTO v_cod_file,
      --v_cod_stato
      --FROM t_mcre0_mig_acquisizione
      --WHERE id_flusso = v_id_flusso;

      MERGE INTO   t_mcre0_app_mig_recode_ndg t
           USING   (SELECT   DISTINCT d.cod_abi, d.cod_ndg
                      FROM   t_mcrei_app_delibere d, t_mcre0_app_all_data a
                     WHERE    d.cod_abi = a.cod_abi_cartolarizzato
                             AND d.cod_ndg = a.cod_ndg
                             AND a.today_flg = '1'
                             AND a.cod_stato in ('IN','RS')
                             AND cod_tipo_pacchetto = 'M'
                             AND cod_microtipologia_delib NOT IN ('CI', 'CS')
                             AND cod_fase_delibera NOT IN ('AN', 'AM', 'IM')
                             --                AND cod_fase_delibera NOT IN
                             --                    ('AD', 'CO', 'CT', 'NA', 'NR', 'CT')
                             AND dta_conferma_delibera IS NOT NULL
                             AND flg_no_delibera = '0' --1.3
                             AND d.flg_attiva = 1) s
              ON   (s.cod_abi = t.cod_abi_old AND s.cod_ndg = t.cod_ndg_old
                    and t.flg_presa_visione = 0)
      WHEN MATCHED
      THEN
         UPDATE SET t.flg_pres_cruscotto = 1, t.dta_upd = SYSDATE;

      COMMIT;

      pkg_mcrei_audit.log_app (c_nome,
                               pkg_mcrei_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                               c_note,
                               NULL);
      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
         RETURN ko;
   END fnc_calcola_flg_cruscotto;

   -- %author
   -- %version 0.1
   -- %usage  function che calcola il FLG_PARZIALE SU T_MCRE0_APP_MIG_RECODE_NDG
   -- %d FLG_PARZIALE = 1, se sul file guida e presente un NDG che coincide con NDG_NEW
   -- %param V_ID_FLUSSO numero unico identificativo del caricamento
   -- %return 1 --> successo calcolo, 0 altrimenti
   -- %cd 28 GIU 2012
   FUNCTION fnc_calcola_flg_condiviso (v_id_flusso IN NUMBER)
      RETURN NUMBER
   IS
      c_nome CONSTANT VARCHAR2 (100)
            := c_package || '.FNC_CALCOLA_FLG_CONDIVISO' ;
      c_note        t_mcrei_wrk_audit_applicativo.note%TYPE := 'Generale';
      v_cod_stato   t_mcre0_mig_acquisizione.cod_stato%TYPE;
      v_cod_file    t_mcre0_mig_acquisizione.cod_file%TYPE;
   BEGIN
      --SELECT cod_file,
      --cod_stato
      --INTO v_cod_file,
      --v_cod_stato
      --FROM t_mcre0_mig_acquisizione
      --WHERE id_flusso = v_id_flusso;


      MERGE INTO   t_mcre0_app_mig_recode_ndg t
           USING   (SELECT   DISTINCT cod_abi_cartolarizzato, cod_ndg
                      FROM   t_mcre0_app_all_data
                     WHERE   flg_active = '1') s -- DA VEDERE SE SI PUO' RESTRINGERE A TODAY_FLG = 1
              ON   (s.cod_abi_cartolarizzato = t.cod_abi_new
                    AND s.cod_ndg = t.cod_ndg_new
                    and t.flg_presa_visione = 0)
      WHEN MATCHED
      THEN
         UPDATE SET t.flg_condiviso = 1, t.dta_upd = SYSDATE;

      --         MERGE INTO   T_MCRE0_APP_MIG_RECODE_NDG T
      --                 USING   (
      --                         SELECT      RE.COD_ABI_NEW, RE.COD_NDG_NEW,RE.COD_ABI_OLD, RE.COD_NDG_OLD,
      --                                   0 AS FLG_AGGANCIATO
      --                            FROM   T_MCRE0_APP_ALL_DATA ad, T_MCRE0_APP_MIG_RECODE_NDG re
      --                          WHERE  RE.COD_ABI_NEW = AD.COD_ABI_CARTOLARIZZATO(+)
      --                            AND  RE.COD_NDG_NEW = AD.COD_NDG(+)
      --                            AND  AD.FLG_ACTIVE(+) = '1'
      --                            AND  AD.COD_NDG IS NULL
      --                            UNION
      --                         SELECT     RE.COD_ABI_NEW, RE.COD_NDG_NEW,RE.COD_ABI_OLD, RE.COD_NDG_OLD,
      --                                   1 AS FLG_AGGANCIATO
      --                            FROM   T_MCRE0_APP_ALL_DATA ad, T_MCRE0_APP_MIG_RECODE_NDG re
      --                          WHERE  RE.COD_ABI_NEW = AD.COD_ABI_CARTOLARIZZATO(+)
      --                            AND  RE.COD_NDG_NEW = AD.COD_NDG(+)
      --                            AND  AD.FLG_ACTIVE(+) = '1'
      --                            AND  AD.COD_NDG IS NOT NULL
      --                           ) S           -- DA VEDERE SE SI PUO' RESTRINGERE A TODAY_FLG = 1
      --                    ON   (S.COD_ABI_OLD = T.COD_ABI_OLD
      --                          AND S.COD_NDG_OLD = T.COD_NDG_OLD
      --                          AND S.COD_ABI_NEW = T.COD_ABI_NEW
      --                          AND S.COD_NDG_NEW = T.COD_NDG_NEW)
      --            WHEN MATCHED
      --            THEN UPDATE SET
      --                    T.FLG_CONDIVISO = S.FLG_AGGANCIATO,
      --                    T.DTA_UPD = SYSDATE;
      --
      COMMIT;
      pkg_mcrei_audit.log_app (c_nome,
                               pkg_mcrei_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                               c_note,
                               NULL);
      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
         RETURN ko;
   END fnc_calcola_flg_condiviso;

   -- %author
   -- %version 0.1
   -- %usage  function che calcola il FLG_PARZIALE SU T_MCRE0_APP_MIG_RECODE_NDG
   -- %d FLG_PARZIALE= 1, se non tutti i rapporti presenti sulla banca cedente
   -- %d verrranno rinumerati, ovvero se non esiste una coppia ABI_NEW, RAPPORTO_NEW
   -- %d per ogni rapporto di una certa posizione presente sulla banca cedente
   -- %d FLG_PARZIALE= 0, altrimenti
   -- %d Viene poi eseguito un ulteriore controllo sulle posizioni ottenute in tal modo, verificando
   -- %d che per ognune di esse esistano una pratica a vecchio ed una a nuovo: questo confermer¿ la parzialit¿ dellaa migrazione
   -- %param V_ID_FLUSSO numero unico identificativo del caricamento
   -- %return 1 --> successo calcolo, 0 altrimenti
   -- %cd 28 GIU 2012
   FUNCTION fnc_calcola_flg_parziale (v_id_flusso IN NUMBER)
      RETURN NUMBER
   IS
      c_nome CONSTANT VARCHAR2 (100)
            := c_package || '.FNC_CALCOLA_FLG_PARZIALE' ;
      c_note        t_mcrei_wrk_audit_applicativo.note%TYPE := 'Generale';
      v_cod_stato   t_mcre0_mig_acquisizione.cod_stato%TYPE;
      v_cod_file    t_mcre0_mig_acquisizione.cod_file%TYPE;
   BEGIN
      --SELECT cod_file,
      --cod_stato
      --INTO v_cod_file,
      --v_cod_stato
      --FROM t_mcre0_mig_acquisizione
      --WHERE id_flusso = v_id_flusso;


      --   MERGE INTO T_MCRE0_APP_MIG_RECODE_NDG T
      --   USING(
      --        SELECT DISTINCT COD_ABI, COD_NDG
      --        FROM (
      --        SELECT DISTINCT COD_ABI, COD_NDG, COD_RAPPORTO --  recupero rapporti da tabella delle STIME
      --         FROM T_MCREI_APP_STIME ST, T_MCRE0_APP_MIG_RECODE_NDG DA_MIG
      --         WHERE ST.COD_ABI = DA_MIG.COD_ABI_OLD
      --          AND ST.COD_NDG = DA_MIG.COD_NDG_OLD
      --          AND ST.FLG_ATTIVA = '1'
      --        MINUS
      --        SELECT DISTINCT COD_ABI, COD_NDG, COD_RAPPORTO
      --          FROM T_MCRE0_APP_MIG_RECODE_RAPP R, T_MCREI_APP_STIME ST
      --          WHERE ST.COD_ABI = R.COD_ABI_OLD
      --            AND ST.COD_NDG = R.COD_NDG_OLD
      --            AND ST.COD_RAPPORTO = R.COD_RAPPORTO_OLD
      --            AND ST.FLG_ATTIVA = '1'
      --        )) S
      --        ON (S.COD_ABI = T.COD_ABI_OLD
      --        AND S.COD_NDG = T.COD_NDG_OLD)
      --        WHEN MATCHED THEN UPDATE
      --           SET FLG_PARZIALE = 1,
      --                DTA_UPD = SYSDATE;

      MERGE INTO   t_mcre0_app_mig_recode_ndg t
           USING   (SELECT   DISTINCT ---posizioni con pratica sia sul cedente che sul ricevente
                             r.cod_abi_old AS cod_abi,
                             r.cod_ndg_old AS cod_ndg
                      FROM   t_mcre0_app_mig_recode_ndg r,
                             t_mcrei_app_pratiche p1,
                             t_mcrei_app_pratiche p2
                     WHERE       r.cod_abi_old = p1.cod_abi
                             AND r.cod_ndg_old = p1.cod_ndg
                             AND p1.flg_attiva = '1'
                             AND r.cod_abi_new = p2.cod_abi
                             AND r.cod_ndg_new = p2.cod_ndg
                             AND p2.flg_attiva = '1') s
              ON   (s.cod_abi = t.cod_abi_old AND s.cod_ndg = t.cod_ndg_old
                    and t.flg_presa_visione = 0)
      WHEN MATCHED
      THEN
         UPDATE SET flg_parziale = 1, dta_upd = SYSDATE;COMMIT;

      pkg_mcrei_audit.log_app (c_nome,
                               pkg_mcrei_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                               c_note,
                               NULL);
      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
         RETURN ko;
   END fnc_calcola_flg_parziale;

   -- %author
   -- %version 0.1
   -- %usage  function che inserisce un record in T_MCRE0_MIG_ACQUISIZIONE
   -- %d il record avr¿ popolati i campi ID_FLUSSO, COD_FILE, ID_DPER
   -- %param V_ID_FLUSSO numero unico identificativo del caricamento
   -- %param NDG_OR_RAPP valori possibili: AFTABRAC_NDG  oppure AFTABRAC_RAPP
   -- %return ID_DPER --> successo INSERIMENTO, 0 altrimenti
   -- %cd 28 GIU 2012
   FUNCTION fnc_init_caricamento (v_id_flusso   IN NUMBER,
                                  ndg_or_rapp   IN VARCHAR2,
                                  v_cod_abi     IN VARCHAR2)
      RETURN NUMBER
   IS
      c_nome CONSTANT VARCHAR2 (100)
            := c_package || '.FNC_INIT_CARICAMENTO' ;
      c_note                    t_mcrei_wrk_audit_applicativo.note%TYPE := 'Generale';
      v_cod_stato               t_mcre0_mig_acquisizione.cod_stato%TYPE;
      v_id_dper                 VARCHAR2 (8);
      V_ID_DPER_NUM             NUMBER;
      V_ID_DPER_OLD             NUMBER;
      V_FLG_ATTIVA              T_MCRE0_WRK_MIG_NDG_RAP.FLG_ATTIVA%TYPE;
      V_COD_CONTESTO_BANCA_NEW  TE_MCRE0_MIG_RECODE_NDG.COD_CONTESTO_BANCA_NEW%TYPE; -- USATO PER AFTABTAC_NDG E AFTABRAC_RAPP


   BEGIN
      SELECT   FLG_ATTIVA
        INTO   V_FLG_ATTIVA
        FROM   T_MCRE0_WRK_MIG_NDG_RAP
       WHERE   COD_FLUSSO = ndg_or_rapp;

     SELECT  LPAD(COD_ISTITUTO,3,'0')
      into  V_COD_CONTESTO_BANCA_NEW
      FROM T_MCRE0_APP_ISTITUTI_ALL
     WHERE COD_ABI = v_cod_abi;

      IF V_FLG_ATTIVA = 1
      THEN
         CASE
            WHEN ndg_or_rapp = 'AFTABRAC_NDG'
            THEN
               SELECT   id_dper
                 INTO   v_id_dper
                 FROM   te_mcre0_mig_recode_ndg
                WHERE   cod_contesto_banca_new = V_COD_CONTESTO_BANCA_NEW
                  AND ROWNUM = 1;
            WHEN ndg_or_rapp = 'AFTABRAC_RAPP'
            THEN
               SELECT   id_dper
                 INTO   v_id_dper
                 FROM   te_mcre0_mig_recode_rapp
                WHERE    cod_contesto_banca_new = V_COD_CONTESTO_BANCA_NEW
                  AND ROWNUM = 1;
            ELSE --afh18 te_mcre0_mig_recode_pilota
               SELECT   TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMMDD')) AS ID_DPER
                 INTO   v_id_dper
                 FROM   DUAL;
         END CASE;

         v_id_dper_num := TO_NUMBER (v_id_dper);
        BEGIN
         SELECT ID_DPER
           INTO V_ID_DPER_OLD
         FROM (
           SELECT ID_DPER
             FROM T_MCRE0_MIG_ACQUISIZIONE
            WHERE COD_FILE = ndg_or_rapp
              and cod_abi = v_cod_abi
         ORDER BY ID_FLUSSO DESC)
        WHERE ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            -- NON è PRESENTE UN CARICAMENTO PER QUEL FLUSSO
            V_ID_DPER_OLD:=0;
        END;

        IF V_ID_DPER_NUM <= V_ID_DPER_OLD THEN -- ID_DPER CARICATO
          c_note := 'Peirodo gia cariccato';
          INSERT INTO t_mcre0_mig_acquisizione (id_flusso,
                                               id_dper,
                                               cod_file,
                                               cod_abi,
                                               COD_STATO)
           VALUES   (v_id_flusso,
                     v_id_dper_num,
                     ndg_or_rapp,
                     v_cod_abi,
                     c_periodo_caricato);
           V_ID_DPER:= KO; -- INIBISCE IL CARICAMENTO
        ELSE
          c_note := 'Inizializzazione caricamento';
          INSERT INTO t_mcre0_mig_acquisizione (id_flusso,
                                               id_dper,
                                               cod_file,
                                               cod_abi)
           VALUES   (v_id_flusso,
                     v_id_dper_num,
                     ndg_or_rapp,
                     v_cod_abi);
        END IF;
        COMMIT;
      ELSE
         V_ID_DPER := KO;
      END IF;

      pkg_mcrei_audit.log_app (c_nome,
                               pkg_mcrei_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                               c_note,
                               NULL);
      RETURN v_id_dper;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
         RETURN ko;
   END fnc_init_caricamento;

   FUNCTION fnc_delete_flg_ndg
      RETURN NUMBER
   IS
      c_nome CONSTANT   VARCHAR2 (100) := c_package || '.FNC_DELETE_FLG_NDG';
      c_note            t_mcrei_wrk_audit_applicativo.note%TYPE := 'Generale';
   BEGIN
      UPDATE   t_mcre0_app_mig_recode_ndg
         SET   flg_pres_cruscotto = NULL,
               flg_condiviso = NULL,
               flg_parziale = NULL,
               dta_upd = SYSDATE;

      COMMIT;

      pkg_mcrei_audit.log_app (c_nome,
                               pkg_mcrei_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                               c_note,
                               NULL);
      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
         RETURN ko;
   END fnc_delete_flg_ndg;

   -- %author
   -- %version 0.1
   -- %usage  Function che lancia il caricamnto e il calcolo flag
   -- %param V_ID_FLUSSO numero unico identificativo del caricamento
   -- %param NDG_OR_RAPP valori possibili: AFTABRAC_NDG  oppure AFTABRAC_RAPP
   -- %return ID_DPER --> successo CARICAMRNTO, 0 altrimenti
   -- %cd 29 GIU 2012
   -- %author
   -- %version 0.1
   -- %usage  function che calcola il FLG_SOFFERENZA SU T_MCRE0_APP_MIG_RECODE_NDG
   -- %d FLG_SOFFERENZA= 1, se la posizione ¿ in stato SOFFERENZA sul file guida
   -- %d FLG_SOFFERENZA = 0, altrimenti
   -- %d La funzione va chiamata dopo che il file guida ¿ stato rinumerato
   -- %param V_ID_FLUSSO numero unico identificativo del caricamento
   -- %return 1 --> successo calcolo, 0 altrimenti
   -- %cd 29 GIU 2012
   FUNCTION fnc_calcola_flg_sofferenza (v_id_flusso   IN NUMBER,
                                        ndg_or_rapp   IN VARCHAR2)
      RETURN NUMBER
   IS
      c_nome CONSTANT VARCHAR2 (100)
            := c_package || '.FNC_CALCOLA_FLG_SOFFERENZA' ;
      c_note        t_mcrei_wrk_audit_applicativo.note%TYPE := 'Generale';
      v_cod_stato   t_mcre0_mig_acquisizione.cod_stato%TYPE;
      v_cod_file    t_mcre0_mig_acquisizione.cod_file%TYPE;
   BEGIN
      MERGE INTO   t_mcre0_app_mig_recode_ndg t
           USING   (SELECT   ad.cod_abi_cartolarizzato AS cod_abi, ad.cod_ndg
                      FROM   t_mcre0_app_all_data ad
                     WHERE   ad.flg_active = '1' -- DA VEDERE SE SI PUO' RESTRINGERE A TODAY_FLG = 1
                       AND   ad.cod_stato = 'SO') s
              ON   (t.cod_abi_new = s.cod_abi AND t.cod_ndg_new = s.cod_ndg
                    and t.flg_presa_visione = 0)
      WHEN MATCHED
      THEN
         UPDATE SET flg_sofferenza = 1, dta_upd = SYSDATE;

      COMMIT;
      pkg_mcrei_audit.log_app (c_nome,
                               pkg_mcrei_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                               c_note,
                               NULL);
      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  c_note,
                                  NULL);
         RETURN ko;
   END fnc_calcola_flg_sofferenza;

   -- %author
   -- %version 0.1
   -- %usage  function che controlla  che tutti i file attesi siano arrivati
   -- %d
   -- %d
   -- %d
   -- %param
   -- %return
   -- %cd 29 GIU 2012
   FUNCTION fnc_chk_mig_file (
      p_nome_file    t_mcre0_wrk_mig_recode_file.val_nome_file%TYPE
   )
      RETURN NUMBER
   IS
      v_note                t_mcrei_wrk_audit_applicativo.note%TYPE;
      c_nome CONSTANT VARCHAR2 (100)
            := c_package || '.FNC_MCRE0_CHK_MIG_FILE' ;
      v_esito               NUMBER (1) := ok;
      v_ok                  NUMBER;
      v_attivi              NUMBER;
      v_qry                 VARCHAR2 (3000);
      v_flg_tipo_migrrapp   t_mcre0_wrk_mig_recode_file.flg_tipo_migrrapp%TYPE;
      v_utente t_mcrei_wrk_audit_applicativo.utente%TYPE
            := 'MIG_RECODE' ;
      v_cod_file            t_mcre0_wrk_mig_recode_file.cod_file%TYPE;

      --- LOCK
      v_lock_result         NUMBER;
      v_lockhandle          VARCHAR2 (200);
   BEGIN
      --- LOCK_INIZIO
      DBMS_LOCK.allocate_unique ('T_MCRE0_WRK_MIG_RECODE_FILE', v_lockhandle);
      v_lock_result := DBMS_LOCK.request (v_lockhandle, DBMS_LOCK.x_mode);
      pkg_mcrei_audit.log_app (
         c_nome,
         pkg_mcrei_audit.c_debug,
         SQLCODE,
         SQLERRM,
            'LOCK upd Request - '
         || p_nome_file
         || ' - '
         || CASE
               WHEN v_lock_result = 1 THEN 'Timeout'
               WHEN v_lock_result = 2 THEN 'Deadlock'
               WHEN v_lock_result = 3 THEN 'Parameter Error'
               WHEN v_lock_result = 4 THEN 'Already owned'
               WHEN v_lock_result = 5 THEN 'Illegal Lock Handle'
            END,
         v_utente
      );
      --- LOCK_FINE

      v_note := 'Arrivato FILE=' || p_nome_file;UPDATE   t_mcre0_wrk_mig_recode_file
         SET   flg_arrivato = 1, dta_upd = SYSDATE
       WHERE   val_nome_file = p_nome_file;

      COMMIT;

      --- LOCK_INIZIO
      v_lock_result := DBMS_LOCK.release (v_lockhandle);
      pkg_mcrei_audit.log_app (
         c_nome,
         pkg_mcrei_audit.c_debug,
         SQLCODE,
         SQLERRM,
            'LOCK upd Relase - '
         || p_nome_file
         || ' - '
         || CASE
               WHEN v_lock_result = 1 THEN 'Timeout'
               WHEN v_lock_result = 2 THEN 'Deadlock'
               WHEN v_lock_result = 3 THEN 'Parameter Error'
               WHEN v_lock_result = 4 THEN 'Already owned'
               WHEN v_lock_result = 5 THEN 'Illegal Lock Handle'
            END,
         v_utente
      );
      --- LOCK_FINE

      v_note := 'Controllo tipo migrazione';

      SELECT   NVL (
                  SUM (flg_attivo)
                  - SUM (DECODE (flg_attivo, 1, flg_arrivato, 0)),
                  0
               ),
               NVL (SUM (flg_attivo), 0),
               cod_file
        INTO   v_ok, v_attivi, v_cod_file
        FROM   t_mcre0_wrk_mig_recode_file f
       WHERE   flg_tipo_migrrapp IN
                     (SELECT   flg_tipo_migrrapp
                        FROM   t_mcre0_wrk_mig_recode_file
                       WHERE   val_nome_file = p_nome_file AND flg_attivo = 1);

      IF (v_ok = 0 AND v_attivi > 0)
      THEN
         v_note := 'Creazione script migrazione';
         --esegui funzione di
         DBMS_OUTPUT.put_line (
            'File arrivato ' || p_nome_file || '; controlli superati'
         );
         --- LOCK_INIZIO
         DBMS_LOCK.allocate_unique ('mig_recode_exe', v_lockhandle);
         v_lock_result := DBMS_LOCK.request (v_lockhandle, DBMS_LOCK.x_mode);
         pkg_mcrei_audit.log_app (
            c_nome,
            pkg_mcrei_audit.c_debug,
            SQLCODE,
            SQLERRM,
               'LOCK --> EXE Request - '
            || p_nome_file
            || ' - '
            || CASE
                  WHEN v_lock_result = 1 THEN 'Timeout'
                  WHEN v_lock_result = 2 THEN 'Deadlock'
                  WHEN v_lock_result = 3 THEN 'Parameter Error'
                  WHEN v_lock_result = 4 THEN 'Already owned'
                  WHEN v_lock_result = 5 THEN 'Illegal Lock Handle'
               END,
            v_utente
         );
         --- LOCK_FINE

         v_note := 'INIZIO FILE=' || p_nome_file;

         UPDATE   t_mcre0_wrk_mig_recode_file
            SET   dta_inizio = SYSDATE
          WHERE   flg_tipo_migrrapp = v_flg_tipo_migrrapp AND flg_attivo = 1;

         COMMIT;

         v_note := 'Esecuzione migrazione - QRY= ' || v_qry;

         EXECUTE IMMEDIATE v_qry USING OUT v_esito;

         v_note := 'INIZIO FILE=' || p_nome_file;

         UPDATE   t_mcre0_wrk_mig_recode_file
            SET   dta_fine = SYSDATE, flg_esito = v_esito, flg_attivo = 0
          WHERE   flg_tipo_migrrapp = v_flg_tipo_migrrapp AND flg_attivo = 1;

         COMMIT;

         --- LOCK_INIZIO
         v_lock_result := DBMS_LOCK.release (v_lockhandle);
         pkg_mcrei_audit.log_app (
            c_nome,
            pkg_mcrei_audit.c_debug,
            SQLCODE,
            SQLERRM,
               'LOCK --> EXE Release - '
            || p_nome_file
            || ' - '
            || CASE
                  WHEN v_lock_result = 1 THEN 'Timeout'
                  WHEN v_lock_result = 2 THEN 'Deadlock'
                  WHEN v_lock_result = 3 THEN 'Parameter Error'
                  WHEN v_lock_result = 4 THEN 'Already owned'
                  WHEN v_lock_result = 5 THEN 'Illegal Lock Handle'
               END,
            v_utente
         );
      --- LOCK_FINE
      END IF;

      RETURN v_esito;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_app (c_nome,
                                  pkg_mcrei_audit.c_error,
                                  SQLCODE,
                                  SQLERRM,
                                  'GENERALE - ' || v_note,
                                  v_utente);
         ROLLBACK;

         UPDATE   t_mcre0_wrk_mig_recode_file
            SET   dta_fine = SYSDATE, flg_esito = ko
          WHERE   flg_tipo_migrrapp = v_flg_tipo_migrrapp AND flg_attivo = 1;

         COMMIT;
         RETURN ko;
   END fnc_chk_mig_file;
END PKG_MCRE0_LOAD_CONFERIMENTI;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_LOAD_CONFERIMENTI FOR MCRE_OWN.PKG_MCRE0_LOAD_CONFERIMENTI;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_LOAD_CONFERIMENTI FOR MCRE_OWN.PKG_MCRE0_LOAD_CONFERIMENTI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_LOAD_CONFERIMENTI TO MCRE_USR;

