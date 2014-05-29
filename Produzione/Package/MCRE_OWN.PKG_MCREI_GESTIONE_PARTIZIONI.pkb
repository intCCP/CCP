CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcrei_gestione_partizioni
AS
/******************************************************************************
 NAME:       PKG_MCREI_GESTIONE_PARTIZIONI
 PURPOSE:

 REVISIONS:
 Ver        Date              Author             Description
 ---------  ----------      -----------------  ------------------------------------
 1.0      20/10/2011         E.Pellizzi         Created this package.
******************************************************************************/
   FUNCTION fnc_truncate_subpartition (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER
   IS
      v_suffix_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;
   BEGIN
      v_suffix_partition := fnc_get_suffix_partition (p_id_flusso);

      IF (fnc_esiste_sottopartizione (p_tabella,
                                      v_suffix_partition || p_partizione,
                                      p_id_flusso
                                     ) = 1
         )
      THEN
         EXECUTE IMMEDIATE    'ALTER TABLE '
                           || p_tabella
                           || ' TRUNCATE SUBPARTITION '
                           || v_suffix_partition
                           || p_partizione;
      END IF;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_truncate_subpartition',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE'
                                          || p_tabella
                                          || ' partizione='
                                          || v_suffix_partition
                                          || p_partizione
                                         );
         RETURN ko;
   END fnc_truncate_subpartition;

   FUNCTION fnc_truncate_partition (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER
   IS
      v_suffix_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;
   BEGIN
      v_suffix_partition := fnc_get_suffix_partition (p_id_flusso);

      IF (fnc_esiste_partizione (p_tabella,
                                 v_suffix_partition || p_partizione,
                                 p_id_flusso
                                ) = 1
         )
      THEN
         EXECUTE IMMEDIATE    'ALTER TABLE '
                           || p_tabella
                           || ' TRUNCATE PARTITION '
                           || v_suffix_partition
                           || p_partizione;
      END IF;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_truncate_partition',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE - '
                                          || p_tabella
                                          || ' partizione='
                                          || v_suffix_partition
                                          || p_partizione
                                         );
         RETURN ko;
   END fnc_truncate_partition;

/*  function fnc_exchange_partition(
     P_ID_FLUSSO T_MCREI_WRK_AUDIT_CARICAMENTI.ID_FLUSSO%TYPE)
   RETURN NUMBER
   is
     V_TAB_TMP T_MCREI_WRK_ACQUISIZIONE.VAL_TAB_TMP%TYPE;
     V_TAB_APP T_MCREI_WRK_ACQUISIZIONE.VAL_TAB_APP%TYPE;
     V_COD_ABI T_MCREI_WRK_ACQUISIZIONE.COD_ABI%TYPE;
     V_SUFFIX_PARTITION T_MCREI_WRK_CONFIGURAZIONE.VALORE_COSTANTE%type;
   BEGIN
     BEGIN
       SELECT VAL_TAB_TMP, VAL_TAB_APP, COD_ABI
       into V_TAB_TMP, V_TAB_APP, V_COD_ABI
       FROM T_MCREI_WRK_ACQUISIZIONE
       WHERE ID_FLUSSO = P_ID_FLUSSO;
     EXCEPTION
       WHEN OTHERS THEN
         PKG_MCREI_AUDIT.LOG_CARICAMENTI(P_ID_FLUSSO, C_PACKAGE || '.fnc_exchange_partition', PKG_MCREI_AUDIT.C_ERROR,SQLCODE,SQLERRM, 'ID_FLUSSO non censito' );
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
           PKG_MCREI_AUDIT.LOG_CARICAMENTI(P_ID_FLUSSO, C_PACKAGE || '.fnc_exchange_partition', PKG_MCREI_AUDIT.C_ERROR,SQLCODE,SQLERRM, 'GENERALE' );
           RETURN KO;
     end fnc_exchange_partition;*/
   FUNCTION fnc_set_subpart_template (
      p_table       IN   VARCHAR2,
      p_id_flusso        t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER
   IS
      v_str                 VARCHAR2 (30000);
      v_suffix_partition    t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_default_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_esito               NUMBER                                      := ok;

      CURSOR c_part_list
      IS
         SELECT cod_abi
           FROM t_mcre0_app_istituti;
   BEGIN
      v_suffix_partition := fnc_get_suffix_partition (p_id_flusso);
      v_default_partition := fnc_get_default_partition (p_id_flusso);
      v_str :=
         v_str || ' alter table ' || p_table
         || ' set subpartition template (';

      FOR rec_part_list IN c_part_list
      LOOP
         v_str :=
               v_str
            || ' SUBPARTITION '
            || v_suffix_partition
            || rec_part_list.cod_abi
            || ' VALUES ('''
            || rec_part_list.cod_abi
            || '''), ';
      END LOOP;

      v_str :=
            v_str
         || ' SUBPARTITION '
         || v_default_partition
         || ' VALUES ( DEFAULT ) ';
      v_str := v_str || ' ) ';

      EXECUTE IMMEDIATE v_str;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_set_subpart_template',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'TABLE=' || p_table
                                         );
         RETURN ko;
   END fnc_set_subpart_template;

   FUNCTION fnc_rebuild_indexes (
      p_table       IN   VARCHAR2,
      p_id_flusso        t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER
   IS
      v_note     VARCHAR2 (200);
      v_esiste   NUMBER (1)     := 0;

      CURSOR cur_p
      IS
         SELECT    'ALTER INDEX '
                || index_name
                || ' REBUILD PARTITION '
                || p.partition_name command
           FROM all_indexes i, user_tab_partitions p
          WHERE i.owner = 'MCRE_OWN'
            AND i.table_name = p_table
            AND i.table_name = p.table_name;

      CURSOR cur_sp
      IS
         SELECT    'ALTER INDEX '
                || index_name
                || ' REBUILD SUBPARTITION '
                || p.subpartition_name command
           FROM all_indexes i, user_tab_subpartitions p
          WHERE i.owner = 'MCRE_OWN'
            AND i.table_name = p_table
            AND i.table_name = p.table_name;
   BEGIN
      v_note := 'Rebuild subpartition indexes';

      FOR rec IN cur_sp
      LOOP
         EXECUTE IMMEDIATE rec.command;

         v_esiste := 1;
      END LOOP;

      IF (v_esiste = 0)
      THEN
         v_note := 'Rebuild partition indexes';

         FOR rec IN cur_p
         LOOP
            EXECUTE IMMEDIATE rec.command;
         END LOOP;
      END IF;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_MCREI_rebuild_indexes',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'TABLE=' || p_table || ' - '
                                          || v_note
                                         );
         RETURN ko;
   END fnc_rebuild_indexes;

   FUNCTION fnc_update_partition_list (
      p_tabella      VARCHAR2 DEFAULT NULL,
      p_type_table   VARCHAR2 DEFAULT NULL,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER
   IS
      v_suffix_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_esito              NUMBER                                       := ok;

      CURSOR c_tab_list
      IS
         SELECT table_name
           FROM user_tables u
          WHERE table_name LIKE 'T_MCREI_' || UPPER (p_type_table) || '%'
            AND table_name = NVL (UPPER (p_tabella), table_name)
            AND EXISTS (
                   SELECT DISTINCT 1
                              FROM user_tab_partitions
                             WHERE table_name = u.table_name
                               AND partition_name NOT IN
                                           ('INC_PATTIVE', 'INC_PSTORICHE'));

      CURSOR c_new_part_list (
         p_table              user_tables.table_name%TYPE,
         p_suffix_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE
      )
      IS
         SELECT cod_abi
           FROM t_mcre0_app_istituti
          WHERE NOT EXISTS (
                   SELECT 1
                     FROM user_tab_partitions
                    WHERE table_name = UPPER (p_table)
                      AND partition_name = p_suffix_partition || cod_abi);
   BEGIN
      v_suffix_partition := fnc_get_suffix_partition (p_id_flusso);

      FOR rec_tab_list IN c_tab_list
      LOOP
         FOR rec_new_part_list IN c_new_part_list (rec_tab_list.table_name,
                                                   v_suffix_partition
                                                  )
         LOOP
            v_esito :=
                 v_esito
               * pkg_mcrei_gestione_partizioni.fnc_crea_partizione
                                                   (rec_tab_list.table_name,
                                                    rec_new_part_list.cod_abi,
                                                    p_id_flusso,
                                                    NULL
                                                   );

            IF (v_esito = 0)
            THEN
               RETURN v_esito;
            END IF;
         END LOOP;
      END LOOP;

      RETURN v_esito;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_update_partition_list',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'GENERALE'
                                         );
         RETURN ko;
   END fnc_update_partition_list;

   FUNCTION fnc_update_subpartition_list (
      p_tabella      VARCHAR2 DEFAULT NULL,
      p_type_table   VARCHAR2 DEFAULT NULL,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER
   IS
      v_suffix_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_esito              NUMBER                                       := ok;

      CURSOR c_tab_list
      IS
         SELECT table_name
           FROM user_tables
          WHERE table_name LIKE 'T_MCREI_' || UPPER (p_type_table) || '%'
            AND table_name = NVL (UPPER (p_tabella), table_name);

      CURSOR c_part_list
      IS
         SELECT cod_abi
           FROM t_mcre0_app_istituti;
   BEGIN
      v_suffix_partition := fnc_get_suffix_partition (p_id_flusso);

      FOR rec_tab_list IN c_tab_list
      LOOP
         v_esito :=
              v_esito
            * pkg_mcrei_gestione_partizioni.fnc_set_subpart_template
                                                     (rec_tab_list.table_name,
                                                      p_id_flusso
                                                     );

         FOR rec_part_list IN c_part_list
         LOOP
            v_esito :=
                 v_esito
               * pkg_mcrei_gestione_partizioni.fnc_crea_sottopartizione
                                                     (rec_tab_list.table_name,
                                                      rec_part_list.cod_abi,
                                                      p_id_flusso
                                                     );

            IF (v_esito = 0)
            THEN
               RETURN v_esito;
            END IF;
         END LOOP;
      END LOOP;

      RETURN v_esito;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_update_subpartition_list',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'GENERALE'
                                         );
         RETURN ko;
   END fnc_update_subpartition_list;

   FUNCTION fnc_get_suffix_partition (
      p_id_flusso   t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN t_mcrei_wrk_configurazione.valore_costante%TYPE
   IS
      v_costante   t_mcrei_wrk_configurazione.valore_costante%TYPE;
   BEGIN
      SELECT valore_costante
        INTO v_costante
        FROM t_mcrei_wrk_configurazione
       WHERE nome_costante = 'PARTITION_SUFFIX';

      RETURN v_costante;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_get_suffix_partition',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'GENERALE'
                                         );
         RETURN ko;
   END fnc_get_suffix_partition;

   FUNCTION fnc_get_default_partition (
      p_id_flusso   t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN t_mcrei_wrk_configurazione.valore_costante%TYPE
   IS
      v_costante   t_mcrei_wrk_configurazione.valore_costante%TYPE;
   BEGIN
      SELECT valore_costante
        INTO v_costante
        FROM t_mcrei_wrk_configurazione
       WHERE nome_costante = 'PARTITION_DEFAULT';

      RETURN v_costante;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_get_default_partition',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'GENERALE'
                                         );
         RETURN ko;
   END fnc_get_default_partition;

   FUNCTION fnc_esiste_partizione (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER
   IS
      v_exists   NUMBER;
   BEGIN
      SELECT DECODE (COUNT (*), 0, 0, 1)
        INTO v_exists
        FROM user_tab_partitions
       WHERE table_name = UPPER (p_tabella) AND partition_name = p_partizione;

      RETURN v_exists;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                          c_package
                                          || '.fnc_esiste_partizione',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE - TAB='
                                          || p_tabella
                                          || ' - PART='
                                          || p_partizione
                                         );
         RETURN ko;
   END fnc_esiste_partizione;

   FUNCTION fnc_esiste_sottopartizione (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER
   IS
      v_exists   NUMBER;
   BEGIN
      SELECT DECODE (COUNT (*), 0, 0, 1)
        INTO v_exists
        FROM user_tab_subpartitions
       WHERE table_name = UPPER (p_tabella)
         AND subpartition_name = p_partizione;

      RETURN v_exists;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                          c_package
                                          || '.fnc_esiste_partizione',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE - TAB='
                                          || p_tabella
                                          || ' - PART='
                                          || p_partizione
                                         );
         RETURN ko;
   END fnc_esiste_sottopartizione;

   FUNCTION fnc_crea_partizione (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE,
      p_desc_flusso  t_mcrei_wrk_alimentazione.DESC_FLUSSO%TYPE
   )
      RETURN NUMBER
   IS
      v_suffix_partition    t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_default_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_exists              NUMBER;
      p_partizione_limite   NUMBER;
   BEGIN
      SELECT DECODE (COUNT (*), 0, 0, 1)
        INTO v_exists
        FROM user_tab_subpartitions
       WHERE table_name = UPPER (p_tabella);

      v_suffix_partition := fnc_get_suffix_partition (p_id_flusso);
      v_default_partition := fnc_get_default_partition (p_id_flusso);

      WHILE TRUE
      LOOP
         BEGIN
            IF fnc_esiste_partizione (p_tabella,
                                      v_suffix_partition || p_partizione,
                                      p_id_flusso
                                     ) = 0
            THEN
              IF (v_exists = 0 AND p_desc_flusso = 'BANCA')
                THEN


                  EXECUTE IMMEDIATE    'ALTER TABLE '
                                    || p_tabella
                                    || ' SPLIT PARTITION '
                                    || v_default_partition
                                    || ' values ('''
                                    || p_partizione
                                    || ''') INTO ( PARTITION '
                                    || v_suffix_partition
                                    || p_partizione
                                    || ',PARTITION '
                                    || v_default_partition
                                    || ')';
               ELSE
                  p_partizione_limite := TO_NUMBER (p_partizione) + 1;

                  EXECUTE IMMEDIATE    'ALTER TABLE '
                                    || p_tabella
                                    || ' SPLIT PARTITION '
                                    || v_default_partition
                                    || ' at ('
                                    || p_partizione_limite
                                    || ') INTO ( PARTITION '
                                    || v_suffix_partition
                                    || p_partizione
                                    || ',PARTITION '
                                    || v_default_partition
                                    || ')';
               END IF;

               EXIT;
            ELSE
               EXIT;
            END IF;
         EXCEPTION
            WHEN in_use
            THEN
               NULL;
         END;
      --DBMS_LOCK.SLEEP(0.01);
      END LOOP;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                          c_package || '.fnc_crea_partizione',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE - TAB='
                                          || p_tabella
                                          || ' - PART='
                                          || v_suffix_partition
                                          || p_partizione
                                         );
         RETURN ko;
   END fnc_crea_partizione;

   FUNCTION fnc_crea_sottopartizione (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2, -- ABI
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER
   IS
      v_suffix_partition    t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_default_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_partition           varchar2(20);
      V_ABI                 T_MCREI_WRK_ACQUISIZIONE.COD_ABI%TYPE;
      V_SUBPART             VARCHAR2(30);
      CURSOR c_part_list
      IS
         SELECT partition_name, high_value
           FROM user_tab_partitions
          WHERE table_name = UPPER (p_tabella)
            AND PARTITION_NAME = v_partition;
   BEGIN
      v_suffix_partition := fnc_get_suffix_partition (p_id_flusso);
      v_default_partition := fnc_get_default_partition (p_id_flusso);
      SELECT COD_ABI,v_suffix_partition||TO_CHAR(ID_DPER,'YYYYMMDD')
        INTO V_ABI, v_partition
        FROM T_MCREI_WRK_ACQUISIZIONE
      WHERE ID_FLUSSO = p_id_flusso;

      V_SUBPART:=v_partition||'_'||V_ABI;

      FOR rec_part_list IN c_part_list
      LOOP
         WHILE TRUE
         LOOP
            BEGIN
               IF fnc_esiste_sottopartizione
                                            (p_tabella,
                                                rec_part_list.partition_name
                                             || '_'
                                             || p_partizione,
                                             p_id_flusso
                                            ) = 0
               THEN
                  EXECUTE IMMEDIATE    'ALTER TABLE '
                                    || p_tabella
                                    || ' SPLIT SUBPARTITION '
                                    || rec_part_list.partition_name
                                    || '_ALTRI values ('''
                                    || p_partizione
                                    || ''') INTO ( SUBPARTITION '
                                    || rec_part_list.partition_name
                                    || '_'
                                    || p_partizione
                                    || ', SUBPARTITION '
                                    || rec_part_list.partition_name
                                    || '_ALTRI)';

                  EXIT;
               ELSE
                  EXIT;
               END IF;
            EXCEPTION
               WHEN in_use
               THEN
                  NULL;
            END;
         END LOOP;
      END LOOP;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_crea_sottopartizione',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE - TAB='
                                          || p_tabella
                                          || ' - SUBPART='
                                          || v_suffix_partition
                                          || p_partizione
                                         );
         RETURN ko;
   END fnc_crea_sottopartizione;

   FUNCTION fnc_elimina_partizione (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER
   IS
      v_suffix_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;
   BEGIN
      v_suffix_partition := fnc_get_suffix_partition (p_id_flusso);

      IF fnc_esiste_partizione (p_tabella,
                                v_suffix_partition || p_partizione,
                                p_id_flusso
                               ) = 1
      THEN
         EXECUTE IMMEDIATE    'ALTER TABLE '
                           || p_tabella
                           || ' DROP PARTITION '
                           || v_suffix_partition
                           || p_partizione;
      END IF;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_elimina_partizione',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE - TAB='
                                          || p_tabella
                                          || ' - PART='
                                          || p_partizione
                                         );
         RETURN ko;
   END fnc_elimina_partizione;

   FUNCTION fnc_elimina_sottopartizione (
      p_tabella      VARCHAR2,
      p_partizione   VARCHAR2,
      p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE
   )
      RETURN NUMBER
   IS
      v_suffix_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;
   BEGIN
      IF fnc_esiste_sottopartizione (p_tabella, p_partizione, p_id_flusso) =
                                                                            1
      THEN
         EXECUTE IMMEDIATE    'ALTER TABLE '
                           || p_tabella
                           || ' DROP SUBPARTITION '
                           || p_partizione;
      END IF;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_elimina_sottopartizione',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE - TAB='
                                          || p_tabella
                                          || ' - SUBPART='
                                          || p_partizione
                                         );
         RETURN ko;
   END fnc_elimina_sottopartizione;

-- Ricostruisce tutte le partizioni attualmente
-- esistenti di tutti gli indici della tabella
-- passata per argomento;
-- gli indici devono essere partizionati,
-- ma non sottopartizionati
FUNCTION fnc_rebuild_all_index_parts(
   p_tabella VARCHAR2,
   p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE)
    RETURN NUMBER
   IS
  CURSOR c_partition_names
    IS
        SELECT partition_name
        FROM user_tab_partitions
        WHERE table_name = p_tabella;
   CURSOR c_index_names
    IS
        SELECT index_name
        FROM user_indexes
        WHERE table_name = p_tabella;
   BEGIN
    FOR r_index_names IN c_index_names LOOP
        FOR r_partition_names IN c_partition_names LOOP
            BEGIN

                EXECUTE IMMEDIATE 'ALTER INDEX '
                ||r_index_names.index_name
                ||' REBUILD PARTITION '
                ||r_partition_names.partition_name;

            EXCEPTION
            WHEN OTHERS
            THEN
            pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_rebuild_all_index_parts',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'Impossibile ricostriure sottopartizione dell''indice '
                                           ||r_index_names.index_name||' della tabella '|| p_tabella);
            END;
        END LOOP;
    END LOOP;
    return ok;
    EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_rebuild_all_index_parts',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE - TAB='
                                          || p_tabella);
         RETURN ko;
   END fnc_rebuild_all_index_parts;

-- Ricostruisce tutte le sottopartizioni attualmente
-- esistenti di tutti gli indici della tabella passata
-- per argomento;
-- gli indici devono essere sottopartizionati
   FUNCTION fnc_rebuild_all_index_subparts(
   p_tabella VARCHAR2,                                              -- nome tabella
   p_id_flusso    t_mcrei_wrk_audit_caricamenti.id_flusso%TYPE)     -- necessario solo per il log
    RETURN NUMBER
   IS
   CURSOR c_partition_names
    IS
        SELECT subpartition_name
        FROM user_tab_subpartitions
        WHERE table_name = p_tabella;
   CURSOR c_index_names
    IS
        SELECT index_name
        FROM user_indexes
        WHERE table_name = p_tabella;
   BEGIN
    FOR r_index_names IN c_index_names LOOP
        FOR r_partition_names IN c_partition_names LOOP
            BEGIN

                EXECUTE IMMEDIATE 'ALTER INDEX '
                ||r_index_names.index_name
                ||' REBUILD SUBPARTITION '
                ||r_partition_names.subpartition_name;

            EXCEPTION
            WHEN OTHERS
            THEN
            pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_rebuild_all_index_subparts',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'Impossibile ricostriure sottopartizione dell''indice '
                                           ||r_index_names.index_name||' della tabella '|| p_tabella);
            END;
        END LOOP;
    END LOOP;
    return ok;
    EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_package
                                          || '.fnc_rebuild_all_index_subparts',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE - TAB='
                                          || p_tabella);
         RETURN ko;
   END fnc_rebuild_all_index_subparts;
END pkg_mcrei_gestione_partizioni;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_GESTIONE_PARTIZIONI FOR MCRE_OWN.PKG_MCREI_GESTIONE_PARTIZIONI;


CREATE SYNONYM MCRE_USR.PKG_MCREI_GESTIONE_PARTIZIONI FOR MCRE_OWN.PKG_MCREI_GESTIONE_PARTIZIONI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_GESTIONE_PARTIZIONI TO MCRE_USR;

