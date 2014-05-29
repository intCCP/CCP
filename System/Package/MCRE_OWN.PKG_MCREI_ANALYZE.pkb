CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcrei_analyze
AS
/************************************************************************************
   NAME:       PKG_MCREI_ANALYZE
   PURPOSE:

   REVISIONS:
   Ver        Date              Author                     Description
   ---------  ----------      -----------------  ------------------------------------
   1.0        07/11/2011      Emiliano Pellizzi         Created this package.
************************************************************************************/
   CURSOR c_params (p_table IN VARCHAR2)
   IS
      SELECT block_sample, CASCADE, DEGREE, estimate_percent, granularity,
             method_option, table_owner, tipo_partizione
        FROM t_mcrei_wrk_statistiche
       WHERE table_name = p_table;

   FUNCTION fnc_analizza_partizione (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      v_suffix_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_block_sample       BOOLEAN                                   := FALSE;
      v_cascade            BOOLEAN                                   := FALSE;
      v_esiste             NUMBER                                        := 0;
      v_cod_abi            t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_tbl                t_mcrei_wrk_elaborazione.tab_src%TYPE;
      v_partition          VARCHAR2 (30);
      v_esiste_part        NUMBER (1);
      v_esito              NUMBER (1)                                   := ko;
   BEGIN
      BEGIN
         SELECT a.cod_abi, e.tab_src
           INTO v_cod_abi, v_tbl
           FROM t_mcrei_wrk_acquisizione a, t_mcrei_wrk_elaborazione e
          WHERE a.id_flusso = p_rec.seq_flusso
            AND a.cod_flusso = e.cod_flusso
            AND e.ordine_alimentazione = p_rec.ordine_alimentazione;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_package
                                             || '.fnc_analizza_partizione',
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'COD_ABI=' || v_cod_abi
                                            );
      END;

      v_suffix_partition :=
         pkg_mcrei_gestione_partizioni.fnc_get_suffix_partition
                                                             (p_rec.seq_flusso);

      FOR rec_params IN c_params (v_tbl)
      LOOP
         IF (rec_params.tipo_partizione = 'ABI')
         THEN
            v_partition := v_cod_abi;
         ELSIF (rec_params.tipo_partizione = 'ID_DPER')
         THEN
            v_partition :=
                       TO_CHAR (p_rec.periodo, 'YYYYMMDD') || '_'
                       || v_cod_abi;
         ELSE
            v_partition := 'ATTIVE' ;
         END IF;

         IF (rec_params.granularity = 'SUBPARTITION')
         THEN
            v_esiste_part :=
               pkg_mcrei_gestione_partizioni.fnc_esiste_sottopartizione
                                                      (v_tbl,
                                                          v_suffix_partition
                                                       || v_partition,
                                                       p_rec.seq_flusso
                                                      );
         ELSE
            v_esiste_part :=
               pkg_mcrei_gestione_partizioni.fnc_esiste_partizione
                                                      (v_tbl,
                                                          v_suffix_partition
                                                       || v_partition,
                                                       p_rec.seq_flusso
                                                      );
         END IF;

         IF v_esiste_part = 1
         THEN
            BEGIN
               v_esiste := 1;

               IF (rec_params.block_sample = 0)
               THEN
                  v_block_sample := FALSE;
               ELSE
                  v_block_sample := TRUE;
               END IF;

               IF (rec_params.CASCADE = 0)
               THEN
                  v_cascade := FALSE;
               ELSE
                  v_cascade := TRUE;
               END IF;

               DBMS_STATS.gather_table_stats
                             (ownname               => rec_params.table_owner,
                              tabname               => v_tbl,
                              partname              =>    v_suffix_partition
                                                       || v_partition,
                              estimate_percent      => rec_params.estimate_percent,
                              block_sample          => v_block_sample,
                              method_opt            => rec_params.method_option,
                              granularity           => rec_params.granularity,
                              CASCADE               => v_cascade
                             );
            END;
         END IF;

         IF (v_partition = 'ATTIVE')
         THEN
            v_partition := 'STORICHE' ;

            IF pkg_mcrei_gestione_partizioni.fnc_esiste_sottopartizione
                                                      (v_tbl,
                                                          v_suffix_partition
                                                       || v_partition,
                                                       p_rec.seq_flusso
                                                      ) = 1
            THEN
               BEGIN
                  DBMS_STATS.gather_table_stats
                            (ownname               => rec_params.table_owner,
                             tabname               => v_tbl,
                             partname              =>    v_suffix_partition
                                                      || v_partition,
                             estimate_percent      => rec_params.estimate_percent,
                             block_sample          => v_block_sample,
                             method_opt            => rec_params.method_option,
                             granularity           => rec_params.granularity,
                             CASCADE               => v_cascade
                            );
               END;
            END IF;
         END IF;
      END LOOP;

      IF (v_esiste = 0)
      THEN
         pkg_mcrei_audit.log_caricamenti
                  (p_rec.seq_flusso,
                   c_package || '.fnc_analizza_partizione',
                   pkg_mcrei_audit.c_warning,
                   SQLCODE,
                   SQLERRM,
                      'TABELLA NON CENSITA IN T_MCREI_WRK_STATISTICHE - TAB='
                   || v_tbl
                   || ' - PART='
                   || v_suffix_partition
                   || v_partition
                  );
      END IF;

      v_esito := fnc_rebuild_indexes (p_rec);
      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_package
                                          || '.fnc_analizza_partizione',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE - TAB='
                                          || v_tbl
                                          || ' - PART='
                                          || v_suffix_partition
                                          || v_cod_abi
                                         );
         RETURN ko;
   END fnc_analizza_partizione;

   FUNCTION fnc_analizza_tabella (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      v_block_sample   BOOLEAN                                 := FALSE;
      v_cascade        BOOLEAN                                 := FALSE;
      v_esiste         NUMBER                                  := 0;
      v_cod_abi        t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_tbl            t_mcrei_wrk_elaborazione.tab_src%TYPE;
   BEGIN
      BEGIN
         SELECT cod_abi, e.tab_src
           INTO v_cod_abi, v_tbl
           FROM t_mcrei_wrk_acquisizione a, t_mcrei_wrk_elaborazione e
          WHERE a.id_flusso = p_rec.seq_flusso
            AND a.cod_flusso = e.cod_flusso
            AND e.ordine_alimentazione = p_rec.ordine_alimentazione;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_package
                                             || '.fnc_analizza_partizione',
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'COD_ABI=' || v_cod_abi
                                            );
      END;

      FOR rec_params IN c_params (v_tbl)
      LOOP
         v_esiste := 1;

         BEGIN
            IF (rec_params.block_sample = 0)
            THEN
               v_block_sample := FALSE;
            ELSE
               v_block_sample := TRUE;
            END IF;

            IF (rec_params.CASCADE = 0)
            THEN
               v_cascade := FALSE;
            ELSE
               v_cascade := TRUE;
            END IF;

            DBMS_STATS.gather_table_stats
                             (ownname               => rec_params.table_owner,
                              tabname               => v_tbl,
                              partname              => NULL,
                              estimate_percent      => rec_params.estimate_percent,
                              block_sample          => v_block_sample,
                              method_opt            => rec_params.method_option,
                              granularity           => 'GLOBAL',
                              CASCADE               => v_cascade
                             );
         END;
      END LOOP;

      IF (v_esiste = 0)
      THEN
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_package || '.fnc_analizza_tabella',
                                          pkg_mcrei_audit.c_warning,
                                          SQLCODE,
                                          SQLERRM,
                                          'TABELLA NON CENSITA - TAB='
                                          || v_tbl
                                         );
      END IF;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_package || '.fnc_analizza_tabella',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'GENERALE - TAB=' || v_tbl
                                         );
         RETURN ko;
   END fnc_analizza_tabella;

   FUNCTION fnc_analizza_part_e_tabella (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      v_esito     NUMBER;
      v_cod_abi   t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_tbl       t_mcrei_wrk_elaborazione.tab_src%TYPE;
   BEGIN
      BEGIN
         SELECT a.cod_abi, e.tab_src
           INTO v_cod_abi, v_tbl
           FROM t_mcrei_wrk_acquisizione a, t_mcrei_wrk_elaborazione e
          WHERE a.id_flusso = p_rec.seq_flusso
            AND a.cod_flusso = e.cod_flusso
            AND e.ordine_alimentazione = p_rec.ordine_alimentazione;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_package
                                             || '.fnc_analizza_partizione',
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'COD_ABI=' || v_cod_abi
                                            );
      END;

      v_esito := fnc_analizza_partizione (p_rec);

      IF (v_esito = ok)
      THEN
         v_esito := fnc_analizza_tabella (p_rec);
      END IF;

      RETURN v_esito;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_package
                                          || '.fnc_analizza_part_e_tabella',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE - TAB='
                                          || v_tbl
                                          || ' PART='
                                          || v_cod_abi
                                         );
         RETURN ko;
   END;

   FUNCTION fnc_rebuild_indexes (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      v_cod_abi            t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_tbl                t_mcrei_wrk_elaborazione.tab_src%TYPE;
      v_partition          VARCHAR2 (30);
      v_esiste_part        NUMBER (1);
      v_note               VARCHAR2 (200);
      v_esiste             NUMBER (1)                                    := 0;
      v_suffix_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;

      CURSOR cur_p (p_table VARCHAR2)
      IS
         SELECT 'ALTER INDEX ' || index_name || ' REBUILD '
                                                                     command
           FROM all_indexes i
          WHERE i.owner = 'MCRE_OWN' AND i.table_name = p_table;

      CURSOR cur_sp (p_table VARCHAR2)
      IS
         SELECT    'ALTER INDEX '
                || index_name
                || ' REBUILD SUBPARTITION ' command
           FROM all_indexes i
          WHERE i.owner = 'MCRE_OWN' AND i.table_name = p_table;
   BEGIN
      BEGIN
         SELECT a.cod_abi, e.tab_src
           INTO v_cod_abi, v_tbl
           FROM t_mcrei_wrk_acquisizione a, t_mcrei_wrk_elaborazione e
          WHERE a.id_flusso = p_rec.seq_flusso
            AND a.cod_flusso = e.cod_flusso
            AND e.ordine_alimentazione = p_rec.ordine_alimentazione;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_package
                                             || '.fnc_rebuild_indexes',
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'COD_ABI=' || v_cod_abi
                                            );
      END;

      v_note := 'GET Suffisso';
      v_suffix_partition :=
         pkg_mcrei_gestione_partizioni.fnc_get_suffix_partition
                                                             (p_rec.seq_flusso);
      v_note := 'GET nome partizione';

      FOR rec_params IN c_params (v_tbl)
      LOOP
         IF (rec_params.tipo_partizione = 'ABI')
         THEN
            v_partition := v_suffix_partition || v_cod_abi;
         ELSIF (rec_params.tipo_partizione = 'ID_DPER')
         THEN
            v_partition :=
                  v_suffix_partition
               || TO_CHAR (p_rec.periodo, 'YYYYMMDD')
               || '_'
               || v_cod_abi;
         ELSE
            v_partition :=  v_suffix_partition||'ATTIVE' ;
         END IF;

         IF (rec_params.tipo_partizione = 'ABI'
            OR rec_params.tipo_partizione = 'FLG_ATTIVA'
      )
         THEN
            v_esiste_part :=
               pkg_mcrei_gestione_partizioni.fnc_esiste_partizione
                                                            (v_tbl,
                                                             v_partition,
                                                             p_rec.seq_flusso
                                                            );

            IF (v_esiste_part = 1)
            THEN
               FOR rec IN cur_p (v_tbl)
               LOOP
                  v_note :=
                     'Rebuild partition indexes' || rec.command;

                  WHILE TRUE
                  LOOP
                     BEGIN
                        EXECUTE IMMEDIATE rec.command ;

                        EXIT;
                     EXCEPTION
                        WHEN in_use
                        THEN
                           NULL;
                     END;
                  END LOOP;
               END LOOP;
            END IF;
         ELSE
            v_esiste_part :=
               pkg_mcrei_gestione_partizioni.fnc_esiste_sottopartizione
                                                            (v_tbl,
                                                             v_partition,
                                                             p_rec.seq_flusso
                                                            );

            IF (v_esiste_part = 1)
            THEN
               FOR rec IN cur_sp (v_tbl)
               LOOP
                  v_note :=
                        'Rebuild subpartition indexes '
                     || rec.command
                     || v_partition;

                  WHILE TRUE
                  LOOP
                     BEGIN
                        EXECUTE IMMEDIATE rec.command|| v_partition;

                        EXIT;
                     EXCEPTION
                        WHEN in_use
                        THEN
                           NULL;
                     END;
                  END LOOP;

--                  IF (v_partition = 'ATTIVE' )
--                  THEN
--                     WHILE TRUE
--                     LOOP
--                        BEGIN
--                           EXECUTE IMMEDIATE    rec.command
--                                             || REPLACE (v_partition,
--                                                         'ATTIVE',
--                                                         'STORICHE'
--                                                        );

--                           EXIT;
--                        EXCEPTION
--                           WHEN in_use
--                           THEN
--                              NULL;
--                        END;
--                     END LOOP;
--                  END IF;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_package || '.fnc_rebuild_indexes',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'TABLE=' || v_tbl || ' - ' || v_note
                                         );
         RETURN ko;
   END fnc_rebuild_indexes;

 FUNCTION fnc_analizza_partizione_bis (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      v_suffix_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_block_sample       BOOLEAN                                   := FALSE;
      v_cascade            BOOLEAN                                   := FALSE;
      v_esiste             NUMBER                                        := 0;
      v_cod_abi            t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_tbl                t_mcrei_wrk_elaborazione.tab_src%TYPE;
      v_partition          VARCHAR2 (30);
      v_esiste_part        NUMBER (1);
      v_esito              NUMBER (1);
   BEGIN
      BEGIN
         SELECT cod_abi
           INTO v_cod_abi
           FROM t_mcrei_wrk_qdc
          WHERE id_flusso = p_rec.seq_flusso;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_package
                                             || '.fnc_analizza_partizione',
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'COD_ABI=' || v_cod_abi
                                            );
      END;
      v_suffix_partition :=
         pkg_mcrei_gestione_partizioni.fnc_get_suffix_partition
                                                             (p_rec.seq_flusso);
      v_tbl := p_rec.tab_trg;
      FOR rec_params IN c_params (v_tbl)
      LOOP
         IF (rec_params.tipo_partizione = 'ABI')
         THEN
            v_partition := v_cod_abi;
         ELSIF (rec_params.tipo_partizione = 'ID_DPER')
         THEN
            v_partition :=
                       TO_CHAR (p_rec.periodo, 'YYYYMMDD') || '_'
                       || v_cod_abi;
         ELSE
            v_partition := 'ATTIVE' ;
         END IF;

         IF (rec_params.granularity = 'SUBPARTITION')
         THEN
            v_esiste_part :=
               pkg_mcrei_gestione_partizioni.fnc_esiste_sottopartizione
                                                      (v_tbl,
                                                          v_suffix_partition
                                                       || v_partition,
                                                       p_rec.seq_flusso
                                                      );
         ELSE
            v_esiste_part :=
               pkg_mcrei_gestione_partizioni.fnc_esiste_partizione
                                                      (v_tbl,
                                                          v_suffix_partition
                                                       || v_partition,
                                                       p_rec.seq_flusso
                                                      );
         END IF;

         IF v_esiste_part = 1
         THEN
            BEGIN
               v_esiste := 1;

               IF (rec_params.block_sample = 0)
               THEN
                  v_block_sample := FALSE;
               ELSE
                  v_block_sample := TRUE;
               END IF;

               IF (rec_params.CASCADE = 0)
               THEN
                  v_cascade := FALSE;
               ELSE
                  v_cascade := TRUE;
               END IF;

               DBMS_STATS.gather_table_stats
                             (ownname               => rec_params.table_owner,
                              tabname               => v_tbl,
                              partname              =>    v_suffix_partition
                                                       || v_partition,
                              estimate_percent      => rec_params.estimate_percent,
                              block_sample          => v_block_sample,
                              method_opt            => rec_params.method_option,
                              granularity           => rec_params.granularity,
                              CASCADE               => v_cascade
                             );
            END;
         END IF;

         IF (v_partition = 'ATTIVE')
         THEN
            v_partition := 'STORICHE' ;
            IF (rec_params.granularity = 'SUBPARTITION')
                THEN
                    v_esiste_part :=
                        pkg_mcrei_gestione_partizioni.fnc_esiste_sottopartizione
                                                      (v_tbl,
                                                          v_suffix_partition
                                                       || v_partition,
                                                       p_rec.seq_flusso
                                                      );
             ELSE
                    v_esiste_part :=
                        pkg_mcrei_gestione_partizioni.fnc_esiste_partizione
                                                      (v_tbl,
                                                          v_suffix_partition
                                                       || v_partition,
                                                       p_rec.seq_flusso
                                                      );
            END IF;

            IF v_esiste_part = 1
            THEN
               BEGIN
                  DBMS_STATS.gather_table_stats
                            (ownname               => rec_params.table_owner,
                             tabname               => v_tbl,
                             partname              =>    v_suffix_partition
                                                      || v_partition,
                             estimate_percent      => rec_params.estimate_percent,
                             block_sample          => v_block_sample,
                             method_opt            => rec_params.method_option,
                             granularity           => rec_params.granularity,
                             CASCADE               => v_cascade
                            );
               END;
            END IF;
         END IF;
      END LOOP;

      IF (v_esiste = 0)
      THEN
         pkg_mcrei_audit.log_caricamenti
                  (p_rec.seq_flusso,
                   c_package || '.fnc_analizza_partizione',
                   pkg_mcrei_audit.c_warning,
                   SQLCODE,
                   SQLERRM,
                      'TABELLA NON CENSITA IN T_MCREI_WRK_STATISTICHE - TAB='
                   || v_tbl
                   || ' - PART='
                   || v_suffix_partition
                   || v_partition
                  );
      END IF;

      v_esito := fnc_rebuild_indexes (p_rec);
      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_package
                                          || '.fnc_analizza_partizione_bis',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE - TAB='
                                          || v_tbl
                                          || ' - PART='
                                          || v_suffix_partition
                                          || v_cod_abi
                                         );
         RETURN ko;
   END fnc_analizza_partizione_bis;

END;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_ANALYZE FOR MCRE_OWN.PKG_MCREI_ANALYZE;


CREATE SYNONYM MCRE_USR.PKG_MCREI_ANALYZE FOR MCRE_OWN.PKG_MCREI_ANALYZE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_ANALYZE TO MCRE_USR;

