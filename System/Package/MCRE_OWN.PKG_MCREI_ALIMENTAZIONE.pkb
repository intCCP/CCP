CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCREI_ALIMENTAZIONE"
AS
   /******************************************************************************
    NAME:       PKG_MCREI_ALIMENTAZIONE
    PURPOSE:

    REVISIONS:
    Ver        Date              Author             Description
    ---------  ----------      -----------------  ------------------------------------
    1.0        20/10/2011         E.Pellizzi         Created this package.
    1.1        07/03/2012         E.Pellizzi         Synchronizing sessions with DBMS_LOCK (ST)
    1.2        14/03/2012         E.Pellizzi         Synchronizing sessions with DBMS_LOCK (APP)
    1.3        23/03/2012         E.Pellizzi         Add function fnc_mcrei_alimenta_mpl
    1.4        07/05/2012         I.Gueorguieva      Add function fnc_mcrei_alimenta_st_stime
    1.5        09/05/2012         E.Pellizzi         Add called pkg_mcrei_gest_delibere.fnc_gest_classif_autom
    1.6        16/05/2012         E.Pellizzi         Optimized function fnc_mcrei_alimenta_st_batch
    1.7        11/06/2012         I.Guerguiva        Add procedura fnc_upd_del_flg_lavorati
    1.8        13/06/2012         E.Pellizzi         Add function fnc_mcrei_damp_abi
    1.9        03/07/2012         I.Gueorguieva      Modificata fnc_alimenta_st per PIANI
    1.10       04/01/2013         I.Gueorguieva      Gestione FLG_STORICO_CALCOLATO, aggiornamento a 1 alla fine del calcolo flg_attiva per abi
    2.0        28/01/2013         E.Pellizzi         Storicizzazione Delibere
   ******************************************************************************/
   FUNCTION fnc_mcrei_alimenta_fl (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      c_nome      CONSTANT VARCHAR2 (100)
                                     := c_package || '.FNC_MCREI_ALIMENTA_FL';
      v_esito              NUMBER;
      v_count              NUMBER;
      note                 t_mcrei_wrk_audit_caricamenti.note%TYPE
                                                                := 'GENERALE';
      v_cod_abi            t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_cod_file           t_mcrei_wrk_acquisizione.cod_file%TYPE;
      v_val_qry_fl         t_mcrei_wrk_alimentazione.val_qry_fl%TYPE;
      v_val_qry_convert    t_mcrei_wrk_alimentazione.val_qry_convert%TYPE;
      v_val_tab_fl         t_mcrei_wrk_alimentazione.val_tab_fl%TYPE;
      v_val_tab_convert    t_mcrei_wrk_alimentazione.val_tab_convert%TYPE;
      v_suffix_partition   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_seq                NUMBER                         := p_rec.seq_flusso;
      v_desc_flusso        t_mcrei_wrk_alimentazione.desc_flusso%TYPE;
      --- LOCK
      v_lock_result        NUMBER;
      v_lockhandle         VARCHAR2 (200);
      v_lock_wait          INTEGER                                   := 18000;
   BEGIN
      BEGIN
         SELECT cod_abi, cod_file
           INTO v_cod_abi, v_cod_file
           FROM t_mcrei_wrk_acquisizione
          WHERE id_flusso = p_rec.seq_flusso;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'COD_ABI=' || v_cod_abi
                                            );
      END;

      BEGIN
         SELECT val_qry_convert, val_qry_fl, val_tab_fl,
                val_tab_convert, desc_flusso
           INTO v_val_qry_convert, v_val_qry_fl, v_val_tab_fl,
                v_val_tab_convert, v_desc_flusso
           FROM t_mcrei_wrk_alimentazione
          WHERE cod_flusso =
                   CASE
                      WHEN desc_flusso = 'MULTI'
                         THEN v_cod_file
                      WHEN desc_flusso = 'BANCA'
                         THEN SUBSTR (v_cod_file, 0, LENGTH (v_cod_file) - 6)
                   END;

         DBMS_LOCK.allocate_unique (v_val_tab_fl, v_lockhandle);
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                             'Lock :  '
                                          || v_val_tab_fl
                                          || '_'
                                          || p_rec.seq_flusso
                                         );
         --    WHILE v_lock_result <> 0
         --    LOOP
         v_lock_result := DBMS_LOCK.request (v_lockhandle, DBMS_LOCK.x_mode);
      --    END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'Parametri alimentazione FL'
                                            );
      END;

      IF (v_desc_flusso = 'BANCA')
      THEN
         IF (v_val_tab_fl = 'T_MCREI_APP_RAPPORTI_ESTERO')
         THEN
            EXECUTE IMMEDIATE    'DELETE FROM  '
                              || v_val_tab_fl
                              || ' WHERE COD_ABI = '
                              || v_cod_abi;

            IF (v_val_qry_convert IS NOT NULL)
            THEN
               EXECUTE IMMEDIATE TO_CHAR (v_val_qry_convert)
                           USING v_seq,
                                 TO_NUMBER (TO_CHAR (p_rec.periodo,
                                                     'YYYYMMDD')
                                           ),
                                 v_cod_abi;

               COMMIT;
               note := 'eseguita QRY_CONVERT';
            END IF;

            EXECUTE IMMEDIATE TO_CHAR (v_val_qry_fl)
                        USING TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD')),
                              v_cod_abi;

            COMMIT;
            note := note||' eseguita QRY_FL';
            v_esito := 1;
         ELSE
--                  v_lock_log := ' ; Esito lock: '||v_lock_result||' ';
--
--                               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
--                                                c_nome ||'_BBBBB_',
--                                                pkg_mcrei_audit.c_debug,
--                                                SQLCODE,
--                                                SQLERRM,
--                                                v_lock_log);
--
            v_esito :=
               pkg_mcrei_gestione_partizioni.fnc_crea_partizione
                                                           (v_val_tab_fl,
                                                            v_cod_abi,
                                                            p_rec.seq_flusso,
                                                            v_desc_flusso
                                                           );

            ---- Controllo creazione sotto_partizioni da template
            IF (v_esito = 1)
            THEN
               v_esito :=
                  pkg_mcrei_gestione_partizioni.fnc_truncate_partition
                                                            (v_val_tab_fl,
                                                             v_cod_abi,
                                                             p_rec.seq_flusso
                                                            );
            END IF;

            IF (v_esito = 1)
            THEN
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                SQLERRM,
                                                v_val_qry_convert
                                               );
               v_suffix_partition :=
                  pkg_mcrei_gestione_partizioni.fnc_get_suffix_partition
                                                             (p_rec.seq_flusso);
               note :=note||' eseguita GESTIONE_PARTIZIONI';
               v_val_qry_fl :=
                  REPLACE (v_val_qry_fl,
                           'V_PARTITION',
                           v_suffix_partition || v_cod_abi
                          );
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                SQLERRM,
                                                v_val_qry_fl
                                               );

               IF (v_val_qry_convert IS NOT NULL)
               THEN
                  EXECUTE IMMEDIATE TO_CHAR (v_val_qry_convert)
                              USING v_seq, v_cod_abi;

                  COMMIT;
                  note := note||' eseguita QRY_CONVERT';
               END IF;

               EXECUTE IMMEDIATE TO_CHAR (v_val_qry_fl)
                           USING v_cod_abi;

               COMMIT;
               note := note||' eseguita QRY_FL';
            END IF;
         END IF;
      ELSE
         EXECUTE IMMEDIATE 'Truncate table ' || v_val_tab_fl;

         IF (v_val_qry_convert IS NOT NULL)
         THEN
            EXECUTE IMMEDIATE TO_CHAR (v_val_qry_convert)
                        USING v_seq,
                              TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

            COMMIT;
            note := note|| ' eseguita QRY_CONVERT';
         END IF;

         EXECUTE IMMEDIATE TO_CHAR (v_val_qry_fl)
                     USING TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

         COMMIT;
         note := note||' eseguita QRY_FL';
         v_esito := 1;
      END IF;

      v_lock_result := DBMS_LOCK.release (v_lockhandle);

      IF (v_esito = 1)
      THEN
         EXECUTE IMMEDIATE    'SELECT COUNT(*) FROM '
                           || v_val_tab_convert
                           || ' WHERE ID_FLUSSO = '
                           || p_rec.seq_flusso
                      INTO v_count;

         COMMIT;

         UPDATE t_mcrei_wrk_acquisizione
            SET val_scarti_convert = v_count
          WHERE id_flusso = p_rec.seq_flusso;

         COMMIT;
      END IF;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          note
                                         );
         RETURN ko;
   END fnc_mcrei_alimenta_fl;

   -- %PARAM P_COD_FLUSSO DEVE IDENTIFICARE UNIVOCAMENTE UN RECORD
   FUNCTION fnc_mcrei_alimenta_st_stime (
      p_id_flusso    IN   t_mcrei_wrk_acquisizione.id_flusso%TYPE,
      p_cod_abi      IN   t_mcrei_wrk_acquisizione.cod_abi%TYPE,
      p_cod_flusso   IN   t_mcrei_wrk_alimentazione.cod_flusso%TYPE,
      p_periodo           DATE
   )
      RETURN NUMBER
   IS
      c_nome     CONSTANT VARCHAR2 (100)
                               := c_package || '.FNC_MCREI_ALIMENTA_ST_STIME';
      v_esito             NUMBER;
      v_count             NUMBER;
      v_esito_analyze     NUMBER;
      v_cod_abi           t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_cod_file          t_mcrei_wrk_acquisizione.cod_file%TYPE;
      v_val_qry_app       t_mcrei_wrk_alimentazione.val_qry_app_attiva%TYPE;
      v_val_qry_st        t_mcrei_wrk_alimentazione.val_qry_st%TYPE;
      v_val_qry_vincoli   t_mcrei_wrk_alimentazione.val_qry_vincoli%TYPE;
      v_val_tab_app       t_mcrei_wrk_alimentazione.val_tab_app%TYPE;
      v_val_tab_st        t_mcrei_wrk_alimentazione.val_tab_st%TYPE;
      v_val_tab_vincoli   t_mcrei_wrk_alimentazione.val_tab_vincoli%TYPE;
      v_note              t_mcrei_wrk_audit_caricamenti.note%TYPE
                                                                := 'GENERALE';
      v_desc_flusso       t_mcrei_wrk_alimentazione.desc_flusso%TYPE;
      v_cod_flusso        t_mcrei_wrk_acquisizione.cod_flusso%TYPE;
      p_rec_st            f_slave_par_type;
      v_subpart_name      t_mcrei_wrk_acquisizione.val_st_partition%TYPE;
      --- LOCK
      v_lock_result       NUMBER;
      v_lockhandle        VARCHAR2 (200);
   BEGIN
      BEGIN
         SELECT val_qry_vincoli, val_qry_st, val_tab_st,
                val_tab_vincoli, val_tab_app, val_qry_app_attiva,
                desc_flusso
           INTO v_val_qry_vincoli, v_val_qry_st, v_val_tab_st,
                v_val_tab_vincoli, v_val_tab_app, v_val_qry_app,
                v_desc_flusso
           FROM t_mcrei_wrk_alimentazione
          WHERE cod_flusso = p_cod_flusso;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                                'Parametri alimentazione '
                                             || p_cod_flusso
                                            );
      END;

      DBMS_LOCK.allocate_unique (v_val_tab_st, v_lockhandle);
      pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                       c_nome,
                                       pkg_mcrei_audit.c_error,
                                       SQLCODE,
                                       SQLERRM,
                                          'Lock :  '
                                       || v_val_tab_st
                                       || '_'
                                       || p_id_flusso
                                      );
      v_lock_result := DBMS_LOCK.request (v_lockhandle, DBMS_LOCK.x_mode);
      v_esito :=
         pkg_mcrei_gestione_partizioni.fnc_crea_partizione
                                                         (v_val_tab_st,
                                                          TO_CHAR (p_periodo,
                                                                   'YYYYMMDD'
                                                                  ),
                                                          p_id_flusso,
                                                          v_desc_flusso
                                                         );
      v_note := v_note||' esito: ' || v_esito;

      IF (v_esito = 1 AND v_desc_flusso = 'BANCA')
      THEN
         v_esito :=
            pkg_mcrei_gestione_partizioni.fnc_crea_sottopartizione
                                                               (v_val_tab_st,
                                                                p_cod_abi,
                                                                p_id_flusso
                                                               );
         v_note := v_note||' Eseguita creazione subpartition con esito: ' || v_esito ||' '||v_val_tab_st;
      END IF;

---- Controllo creazione sotto_partizioni da template
------------------------------------------------------------------------------------------------
      IF (v_desc_flusso = 'BANCA')
      THEN
         IF (v_esito = 1)
         THEN
            v_note := v_note ||
                  ' Truncate sottopartizione '||v_val_tab_st||' periodo='
               || TO_CHAR (p_periodo, 'YYYYMMDD')
               || ' - ABI='
               || p_cod_abi;
            v_esito :=
               pkg_mcrei_gestione_partizioni.fnc_truncate_subpartition
                                            (v_val_tab_st,
                                                TO_NUMBER (TO_CHAR (p_periodo,
                                                                    'YYYYMMDD'
                                                                   )
                                                          )
                                             || '_'
                                             || p_cod_abi,
                                             p_id_flusso
                                            );
            v_note := v_note||' Eseguita truncate subpartition con esito: ' || v_esito;
         END IF;

         IF (v_esito = 1)
         THEN
            IF TO_CHAR (v_val_qry_vincoli) IS NOT NULL
            THEN
               EXECUTE IMMEDIATE TO_CHAR (v_val_qry_vincoli)
                           USING p_id_flusso,
                                  TO_NUMBER (TO_CHAR (p_periodo, 'YYYYMMDD')),
                                 p_cod_abi;

               v_note :=v_note ||'eseguita query vincoli' ||v_val_tab_st||chr(10);
               COMMIT;
            END IF;

            EXECUTE IMMEDIATE TO_CHAR (v_val_qry_st)
                        USING TO_NUMBER (TO_CHAR (p_periodo, 'YYYYMMDD')),
                              p_cod_abi;

            v_note :=v_note||' Eseguita query storico '||v_val_tab_st||chr(10);
            -- gather stats after partition creation and data insert
            p_rec_st :=
               f_slave_par_type (p_id_flusso,
                                 v_cod_flusso,
                                 p_periodo,
                                 NULL,
                                 v_val_tab_st,
                                 4
                                );
            v_esito_analyze :=
                      pkg_mcrei_analyze.fnc_analizza_partizione_bis (p_rec_st);
            -- chiamata a cascata di rebuild indexes inutile!!!
            v_note :=v_note||
                  'Eseguita analyze della partizione della tabella '
               || v_val_tab_st||chr(10);                                -- da rimuovere
            v_subpart_name :=
                 'INC_P' || TO_CHAR (p_periodo, 'YYYYMMDD') || '_'
                 || p_cod_abi;                         -- NOME SOTTOPARTIZIONE
            COMMIT;
         END IF;
-----------------------------------------------------------------------------------------------------
      ELSE                                                     -- MULTI FLUSSO
         IF (v_esito = 1)
         THEN
            v_note := v_note||' TRUNCATE periodo=' || TO_CHAR (p_periodo, 'YYYYMMDD')||chr(10);
            v_esito :=
               pkg_mcrei_gestione_partizioni.fnc_truncate_partition
                                             (v_val_tab_st,
                                              TO_NUMBER (TO_CHAR (p_periodo,
                                                                  'YYYYMMDD'
                                                                 )
                                                        ),
                                              p_id_flusso
                                             );
            v_note :=v_note||' Eseguita Truncate con esito: ' || v_esito ||' su '||v_val_tab_st||chr(10);
         END IF;

         IF (v_esito = 1)
         THEN
            IF TO_CHAR (v_val_qry_vincoli) IS NOT NULL
            THEN
               EXECUTE IMMEDIATE TO_CHAR (v_val_qry_vincoli)
                           USING p_id_flusso,
                                 TO_NUMBER (TO_CHAR (p_periodo, 'YYYYMMDD'));

               v_note := v_note||' Eseguita query vincoli su '||v_val_tab_st||chr(10);
               COMMIT;
            END IF;

            EXECUTE IMMEDIATE TO_CHAR (v_val_qry_st)
                        USING TO_NUMBER (TO_CHAR (p_periodo, 'YYYYMMDD'));

            v_note:=v_note||' Eseguita query storico su '||v_val_tab_st||chr(10);
            v_subpart_name := 'INC_P' || TO_CHAR (p_periodo, 'YYYYMMDD');
            COMMIT;
         END IF;
      END IF;

      v_note := v_note|| 'Eseguita query app '||v_val_qry_app||chr(10);

      IF TO_CHAR (v_val_qry_app) IS NOT NULL
      THEN
         EXECUTE IMMEDIATE TO_CHAR (v_val_qry_app)
                     USING TO_NUMBER (TO_CHAR (p_periodo, 'YYYYMMDD')),
                           p_cod_abi;
      END IF;

      COMMIT;
      v_lock_result := DBMS_LOCK.release (v_lockhandle);
      RETURN ok * v_esito;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_id_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'GENERALE ' || v_note
                                         );
         RETURN ko;
   END fnc_mcrei_alimenta_st_stime;

   FUNCTION fnc_mcrei_alimenta_st (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      c_nome     CONSTANT VARCHAR2 (100)
                                     := c_package || '.FNC_MCREI_ALIMENTA_ST';
      v_esito             NUMBER;
      v_count             NUMBER;
      v_esito_analyze     NUMBER;
      v_cod_abi           t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_cod_file          t_mcrei_wrk_acquisizione.cod_file%TYPE;
      v_val_qry_st        t_mcrei_wrk_alimentazione.val_qry_st%TYPE;
      v_val_qry_vincoli   t_mcrei_wrk_alimentazione.val_qry_vincoli%TYPE;
      v_val_tab_st        t_mcrei_wrk_alimentazione.val_tab_st%TYPE;
      v_val_tab_vincoli   t_mcrei_wrk_alimentazione.val_tab_vincoli%TYPE;
      v_note              t_mcrei_wrk_audit_caricamenti.note%TYPE
                                                                := 'GENERALE';
      v_desc_flusso       t_mcrei_wrk_alimentazione.desc_flusso%TYPE;
      v_cod_flusso        t_mcrei_wrk_acquisizione.cod_flusso%TYPE;
      p_rec_st            f_slave_par_type;
      v_subpart_name      t_mcrei_wrk_acquisizione.val_st_partition%TYPE;
      --- LOCK
      v_lock_result       NUMBER;
      v_lockhandle        VARCHAR2 (200);
   BEGIN
      BEGIN
         SELECT cod_abi, cod_file, cod_flusso
           INTO v_cod_abi, v_cod_file, v_cod_flusso
           FROM t_mcrei_wrk_acquisizione
          WHERE id_flusso = p_rec.seq_flusso;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'COD_ABI=' || v_cod_abi
                                            );
      END;

      BEGIN
         SELECT val_qry_vincoli, val_qry_st, val_tab_st,
                val_tab_vincoli, desc_flusso
           INTO v_val_qry_vincoli, v_val_qry_st, v_val_tab_st,
                v_val_tab_vincoli, v_desc_flusso
           FROM t_mcrei_wrk_alimentazione
          WHERE cod_flusso =
                   CASE
                      WHEN desc_flusso = 'MULTI'
                         THEN v_cod_file
                      WHEN desc_flusso = 'BANCA'
                         THEN SUBSTR (v_cod_file, 0, LENGTH (v_cod_file) - 6)
                   END;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'Parametri alimentazione ST'
                                            );
      END;

      DBMS_LOCK.allocate_unique (v_val_tab_st, v_lockhandle);
      pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                       c_nome,
                                       pkg_mcrei_audit.c_error,
                                       SQLCODE,
                                       SQLERRM,
                                          'Lock :  '
                                       || v_val_tab_st
                                       || '_'
                                       || p_rec.seq_flusso
                                      );
      v_lock_result := DBMS_LOCK.request (v_lockhandle, DBMS_LOCK.x_mode);
      v_esito :=
         pkg_mcrei_gestione_partizioni.fnc_crea_partizione
                                                     (v_val_tab_st,
                                                      TO_CHAR (p_rec.periodo,
                                                               'YYYYMMDD'
                                                              ),
                                                      p_rec.seq_flusso,
                                                      v_desc_flusso
                                                     );
      v_note := v_note||'Esito lock : ' || v_esito||' '||v_val_tab_st||chr(10);
      IF (v_esito = 1 AND v_desc_flusso = 'BANCA')
      THEN
         v_esito :=pkg_mcrei_gestione_partizioni.fnc_crea_sottopartizione (v_val_tab_st, v_cod_abi,p_rec.seq_flusso );
         v_note :=v_note|| 'Eseguita creazione subpartition con esito: ' || v_esito||' '||v_val_tab_st||chr(10);
      END IF;

---- Controllo creazione sotto_partizioni da template
------------------------------------------------------------------------------------------------
      IF (v_desc_flusso = 'BANCA')
      THEN
         IF (v_esito = 1)
         THEN
            v_note :=v_note||
                  ' Truncate sottopartizione periodo='
               || TO_CHAR (p_rec.periodo, 'YYYYMMDD')
               || ' - ABI='
               || v_cod_abi ||'  di '||v_val_tab_st||chr(10);
            v_esito :=
               pkg_mcrei_gestione_partizioni.fnc_truncate_subpartition
                                        (v_val_tab_st,
                                            TO_NUMBER (TO_CHAR (p_rec.periodo,
                                                                'YYYYMMDD'
                                                               )
                                                      )
                                         || '_'
                                         || v_cod_abi,
                                         p_rec.seq_flusso
                                        );
            v_note := v_note||'Eseguita truncate subpartition con esito: ' || v_esito||chr(10);
         END IF;

         IF (v_esito = 1)
         THEN
            EXECUTE IMMEDIATE TO_CHAR (v_val_qry_vincoli)
                        USING p_rec.seq_flusso,
                              TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD')),
                              v_cod_abi;

            v_note := v_note||' Eseguita query vincoli '||v_val_tab_vincoli||chr(10);
            COMMIT;

            EXECUTE IMMEDIATE TO_CHAR (v_val_qry_st)
                        USING TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD')),
                              v_cod_abi;

            v_note :=v_note|| 'Eseguita query storico '||v_val_tab_st||chr(10);
            -- gather stats after partition creation and data insert
            p_rec_st :=
               f_slave_par_type (p_rec.seq_flusso,
                                 v_cod_flusso,
                                 p_rec.periodo,
                                 p_rec.tab_ext,
                                 v_val_tab_st,
                                 4
                                );
            v_esito_analyze :=
                      pkg_mcrei_analyze.fnc_analizza_partizione_bis (p_rec_st);
            -- chiamata a cascata di rebuild indexes inutile!!!
            v_note :=v_note||
                  'Eseguita analyze della partizione della tabella '
               || v_val_tab_st;                                -- da rimuovere
            v_subpart_name :=
               'INC_P' || TO_CHAR (p_rec.periodo, 'YYYYMMDD') || '_'
               || v_cod_abi;                           -- NOME SOTTOPARTIZIONE
            COMMIT;
         END IF;
-----------------------------------------------------------------------------------------------------
      ELSE                                                     -- MULTI FLUSSO
         IF (v_esito = 1)
         THEN
            v_note :=v_note||
                  ' TRUNCATE periodo=' || TO_CHAR (p_rec.periodo, 'YYYYMMDD')||' tabella '||v_val_tab_st||chr(10);
            v_esito :=
               pkg_mcrei_gestione_partizioni.fnc_truncate_partition
                                         (v_val_tab_st,
                                          TO_NUMBER (TO_CHAR (p_rec.periodo,
                                                              'YYYYMMDD'
                                                             )
                                                    ),
                                          p_rec.seq_flusso
                                         );
            v_note := v_note||'Eseguita Truncate con esito: ' || v_esito||chr(10);
         END IF;

         IF (v_esito = 1)
         THEN
            EXECUTE IMMEDIATE TO_CHAR (v_val_qry_vincoli)
                        USING p_rec.seq_flusso,
                              TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

            v_note := v_note|| 'Eseguita query vincoli '||v_val_tab_vincoli||chr(10);
            COMMIT;

            EXECUTE IMMEDIATE TO_CHAR (v_val_qry_st)
                        USING TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

            v_note := v_note||' Eseguita query storico '||v_val_tab_st||chr(10);
            v_subpart_name := 'INC_P' || TO_CHAR (p_rec.periodo, 'YYYYMMDD');
            -- NOME PARTIZIONE
            COMMIT;
         END IF;
      END IF;

---------------------------------------------------------------------------------------------------------------
      IF (v_esito = 1)
      THEN
         EXECUTE IMMEDIATE    'DELETE from '
                           || v_val_tab_vincoli
                           || ' where id_flusso < '
                           || p_rec.seq_flusso
                           || ' - 2800';

         COMMIT;

         EXECUTE IMMEDIATE    'SELECT COUNT(*) FROM '
                           || v_val_tab_vincoli
                           || ' WHERE ID_FLUSSO = '
                           || p_rec.seq_flusso
                      INTO v_count;

         COMMIT;
         v_note := v_note||' Conteggio record tabella vincoli '||v_count||chr(10);

         UPDATE t_mcrei_wrk_acquisizione
            SET val_scarti_vincoli = v_count,
                val_st_partition = v_subpart_name
          WHERE id_flusso = p_rec.seq_flusso;

         COMMIT;
         v_note := v_note||' Aggiornata tabella acquisizione'||chr(10);
      END IF;

      UPDATE t_mcrei_wrk_qdc
         SET id_flusso = p_rec.seq_flusso,
             cod_stato = 'VALIDO',
             dta_upd = SYSDATE
       WHERE flusso = v_cod_flusso
         AND NVL (cod_abi, 0) = NVL (v_cod_abi, 0)
         AND id_dper = TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

      IF (SQL%ROWCOUNT = 0)
      THEN
         INSERT INTO t_mcrei_wrk_qdc
                     (id_flusso, flusso, cod_abi,
                      id_dper,
                      cod_stato, dta_ins
                     )
              VALUES (p_rec.seq_flusso, v_cod_flusso, v_cod_abi,
                      TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD')),
                      'VALIDO', SYSDATE
                     );
      END IF;

      COMMIT;
      v_lock_result := DBMS_LOCK.release (v_lockhandle);

      IF v_cod_flusso = 'STIME'
      THEN
         v_esito :=
            fnc_mcrei_alimenta_st_stime (p_rec.seq_flusso,
                                         v_cod_abi,
                                         'STIME_BATCH',
                                         p_rec.periodo
                                        );

         IF v_esito = 1
         THEN
            v_esito :=
               fnc_mcrei_alimenta_st_stime (p_rec.seq_flusso,
                                            v_cod_abi,
                                            'STIME_EXTRA',
                                            p_rec.periodo
                                           );
         END IF;
      END IF;

      IF v_cod_flusso = 'PIANI_RIENTRO'
      THEN
         v_esito :=
            fnc_mcrei_alimenta_st_stime (p_rec.seq_flusso,
                                         v_cod_abi,
                                         'PIANI_RIENTRO_EXTRA',
                                         p_rec.periodo
                                        );
      END IF;

      RETURN ok * v_esito;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'GENERALE ' || v_note
                                         );
         RETURN ko;
   END fnc_mcrei_alimenta_st;

   FUNCTION fnc_mcrei_alimenta_app (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      c_nome     CONSTANT VARCHAR2 (100)
                                    := c_package || '.fnc_mcrei_alimenta_app';
      v_esito             NUMBER                                         := 0;
      v_count             NUMBER                                         := 0;
      v_periodo           NUMBER;
      v_flusso            t_mcrei_wrk_qdc.flusso%TYPE;
      v_flusso_app        t_mcrei_wrk_alimentazione.cod_flusso%TYPE;
      note                t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
      v_cod_abi           t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_cod_file          t_mcrei_wrk_acquisizione.cod_file%TYPE;
      v_seq               NUMBER                          := p_rec.seq_flusso;
      v_desc_flusso       t_mcrei_wrk_alimentazione.desc_flusso%TYPE;
      p_rec_app           f_slave_par_type;
      v_val_qry_app       t_mcrei_wrk_alimentazione.val_qry_app_attiva%TYPE;
      v_val_qry_del_sto   t_mcrei_wrk_alimentazione.val_qry_app_attiva%TYPE;
      v_val_tab_app       t_mcrei_wrk_alimentazione.val_tab_app%TYPE;
      v_flg_daily         t_mcrei_wrk_alimentazione.flg_daily%TYPE;
      v_res               VARCHAR2 (100);
      v_tomorrow          DATE;
      --- LOCK
      v_lock_result       NUMBER;
      v_lockhandle        VARCHAR2 (200);
      V_iddper_sto        NUMBER;
      v_periodo_sto       date;

      CURSOR c_flusso (c_cod_file VARCHAR2)
      IS
         SELECT cod_flusso, dipendenze
           FROM t_mcrei_wrk_alimentazione
          WHERE dipendenze =
                   (SELECT DISTINCT dipendenze
                               FROM t_mcrei_wrk_alimentazione
                              WHERE cod_flusso =
                                       CASE
                                          WHEN desc_flusso = 'MULTI'
                                             THEN c_cod_file
                                          WHEN desc_flusso = 'BANCA'
                                             THEN SUBSTR (c_cod_file,
                                                          0,
                                                            LENGTH (c_cod_file)
                                                          - 6
                                                         )
                                       END);

      CURSOR c_app
      IS
         SELECT   val_qry_app_attiva, val_tab_app, flg_daily, desc_flusso,
                  ordine_elaborazione
             FROM t_mcrei_wrk_alimentazione
            WHERE cod_flusso = v_flusso_app
         ORDER BY ordine_elaborazione;
   BEGIN
      v_periodo := TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

      BEGIN
         SELECT cod_abi
           INTO v_cod_abi
           FROM t_mcrei_wrk_acquisizione
          WHERE id_flusso = p_rec.seq_flusso;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'COD_ABI=' || v_cod_abi
                                            );
      END;

      FOR r_flusso IN c_flusso (p_rec.nome_file)
      LOOP
         BEGIN
            v_flusso_app := r_flusso.dipendenze;
            v_count := v_count + 1;

            SELECT flusso, cod_abi
              INTO v_flusso, v_cod_abi
              FROM t_mcrei_wrk_qdc qdc
             WHERE qdc.flusso = r_flusso.cod_flusso
               AND NVL (qdc.cod_abi, 0) = NVL (v_cod_abi, 0)
               AND qdc.id_dper = v_periodo
               AND qdc.cod_stato = 'VALIDO';

            UPDATE t_mcrei_wrk_qdc qdc
               SET qdc.cod_stato = 'CARICATA APP',
                   qdc.dta_upd = SYSDATE
             WHERE qdc.flusso = r_flusso.cod_flusso
               AND NVL (qdc.cod_abi, 0) = NVL (v_cod_abi, 0)
               AND qdc.id_dper = v_periodo
               AND qdc.cod_stato = 'VALIDO';

            v_esito := v_esito + 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_error,
                                                SQLCODE,
                                                SQLERRM,
                                                   'FLUSSO '
                                                || r_flusso.cod_flusso
                                                || ' NON PRESENTE PER ABI '
                                                || v_cod_abi
                                               );
         END;
      END LOOP;

--      IF V_FLUSSO_APP IS NULL THEN
--        v_flusso_app := P_REC.NOME_FILE;
--      END IF;
      IF (v_esito = v_count)                         -- dipendenze soddisfatte
      THEN
         FOR r_app IN c_app
         LOOP
            IF r_app.val_qry_app_attiva IS NOT NULL
            THEN
               IF (r_app.desc_flusso = 'BANCA')
               THEN
                  note := note||' ERRORE SU QUERY: val_qry_app_attiva ordine_elaborazione '||r_app.ordine_elaborazione||' desc_flusso '||r_app.desc_flusso||chr(10);
                  DBMS_LOCK.allocate_unique (r_app.val_tab_app, v_lockhandle);
                  v_lock_result :=
                           DBMS_LOCK.request (v_lockhandle, DBMS_LOCK.x_mode);
                  pkg_mcrei_audit.log_caricamenti
                             (p_rec.seq_flusso,
                              c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                                 'LOCK_RESULT LOCKED - '
                              || CASE
                                    WHEN v_lock_result = 1
                                       THEN 'Timeout'
                                    WHEN v_lock_result = 2
                                       THEN 'Deadlock'
                                    WHEN v_lock_result = 3
                                       THEN 'Parameter Error'
                                    WHEN v_lock_result = 4
                                       THEN 'Already owned'
                                    WHEN v_lock_result = 5
                                       THEN 'Illegal Lock Handle'
                                 END
                             );
                  IF r_app.val_tab_app = 'T_MCREI_APP_PARERI'
                  THEN
                     note := note||' Esecuzione query app T_MCREI_APP_PARERI '||chr(10);
                     EXECUTE IMMEDIATE TO_CHAR (r_app.val_qry_app_attiva)
                                 USING v_periodo,
                                       v_cod_abi,
                                       v_periodo,
                                       v_cod_abi;
                  ELSE
                     note := note||' Esecuzione query app per ' || v_val_tab_app;
                     EXECUTE IMMEDIATE TO_CHAR (r_app.val_qry_app_attiva)
                                 USING v_periodo, v_cod_abi;
                     IF r_app.ordine_elaborazione = 102
                     THEN
                        note := note||
                           ' GESTIONE PROPOSTE -> DESC_ANAG_DELIBERANTE <> INCAGLIO AUTOMATICO'||chr(10);
                        v_res :=
                           pkg_mcrei_gest_delibere.fnc_gest_classif_autom
                                                                  (v_periodo,
                                                                   v_cod_abi,
                                                                   'E'
                                                                  );
                        pkg_mcrei_audit.log_caricamenti
                           (p_rec.seq_flusso,
                            c_nome,
                            pkg_mcrei_audit.c_debug,
                            SQLCODE,
                            note,
                            'ESEGUITA FUNZIONE PKG_MCREI_GEST_DELIBERE.FNC_GEST_CLASSIF_AUTOM'
                           );
                     END IF;
                  END IF;
               ELSE
                  CASE WHEN r_app.val_tab_app = 'T_MCREI_APP_PCR_RAPPORTI'
                  THEN
                     EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCREI_APP_PCR_RAPPORTI';
                  WHEN r_app.val_tab_app = 'T_MCRE0_APP_RATE_DAILY' THEN
                    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_APP_RATE_DAILY';
                  ELSE NULL;
                  END CASE;

                  EXECUTE IMMEDIATE TO_CHAR (r_app.val_qry_app_attiva)
                              USING v_periodo;
               END IF;
               note :=note||
                     'FLUSSO '
                  || v_flusso_app
                  || '.'
                  || v_cod_abi
                  || ' ESEGUITA QUERY CON TAB TARGET '
                  || r_app.val_tab_app||chr(10);
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                note,
                                                r_app.val_qry_app_attiva
                                               );
            END IF;

            v_lock_result := DBMS_LOCK.release (v_lockhandle);
         END LOOP;

-----------------------------------------------------------------------------------------
    --     2.0

--    Begin
--     --DELIBERE STORICO
--         IF v_flusso_app = 'APP_BANCA'
--         THEN
--          note :=  note ||' STORICIZZAZIONE DELIBERE'||chr(10);
--            SELECT CASE
--                      WHEN TO_CHAR (p_rec.periodo,
--                                    'D',
--                                    'NLS_DATE_LANGUAGE = ITALIAN'
--                                   ) = 1
--                         THEN (p_rec.periodo+1)
--                      WHEN TO_CHAR (p_rec.periodo,
--                                    'D',
--                                    'NLS_DATE_LANGUAGE = ITALIAN'
--                                   ) = 2
--                         THEN (p_rec.periodo + 1)
--                      WHEN TO_CHAR (p_rec.periodo,
--                                    'D',
--                                    'NLS_DATE_LANGUAGE = ITALIAN'
--                                   ) = 3
--                         THEN (p_rec.periodo + 1)
--                      WHEN TO_CHAR (p_rec.periodo,
--                                    'D',
--                                    'NLS_DATE_LANGUAGE = ITALIAN'
--                                   ) = 4
--                         THEN (p_rec.periodo + 1)
--                      WHEN TO_CHAR (p_rec.periodo,
--                                    'D',
--                                    'NLS_DATE_LANGUAGE = ITALIAN'
--                                   ) = 5
--                         THEN (p_rec.periodo + 3)
--                   ELSE (P_REC.PERIODO)
--                   END
--              INTO v_tomorrow
--              FROM DUAL;

--            IF TO_NUMBER(TO_CHAR (P_REC.PERIODO, 'YYYYMM')) <
--                    TO_NUMBER (TO_CHAR (v_tomorrow, 'YYYYMM'))
--            THEN
--               v_esito :=
--                  pkg_mcrei_gestione_partizioni.fnc_crea_partizione
--                                            ('T_MCREI_APP_DELIBERE_STORICO',
--                                             TO_CHAR (TRUNC (p_rec.periodo,'MM'),'YYYYMMDD'),
--                                             p_rec.seq_flusso,
--                                             'MULTI'
--                                            );

--               SELECT val_qry_app_attiva
--                 INTO v_val_qry_del_sto
--                 FROM t_mcrei_wrk_alimentazione
--                WHERE cod_flusso = 'DELIBERE_STORICO';
--
--                SELECT TO_NUMBER(TO_CHAR (TRUNC (p_rec.periodo,'MM'),'YYYYMMDD')),TRUNC (p_rec.periodo,'MM')
--                into V_iddper_sto, v_periodo_sto
--                from dual;
--
--                EXECUTE IMMEDIATE TO_CHAR ( v_val_qry_del_sto)
--                              USING  v_iddper_sto,
--                                     v_cod_abi ,
--                                     v_periodo_sto ;
--
--
--
--            END IF;
--         END IF;
--
--      EXCEPTION
--      WHEN OTHERS
--      THEN
--
--         pkg_mcrei_audit.log_caricamenti
--                                    (p_rec.seq_flusso,
--                                     c_nome,
--                                     pkg_mcrei_audit.c_error,
--                                     SQLCODE,
--                                     SQLERRM,
--                                     note
--                                    );
--      end;

----------------------------------------------------------------------------------------------
         COMMIT;
      ELSE                                       -- dipendenze non soddisfatte
         ROLLBACK;
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_warning,
                                          SQLCODE,
                                          SQLERRM,
                                             v_desc_flusso
                                          || '.'
                                          || v_cod_abi
                                          || ': DIPENDENZE NON SODDISFATTE'
                                         );
      END IF;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         v_lock_result := DBMS_LOCK.release (v_lockhandle);
         pkg_mcrei_audit.log_caricamenti
                                    (p_rec.seq_flusso,
                                     c_nome,
                                     pkg_mcrei_audit.c_error,
                                     SQLCODE,
                                     SQLERRM,
                                     note
                                    );
         RETURN ko;
   END fnc_mcrei_alimenta_app;

   FUNCTION fnc_mcrei_alimenta_hst (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      c_nome   CONSTANT VARCHAR2 (100)
                                    := c_package || '.fnc_mcrei_alimenta_hst';
      v_esito           NUMBER                                           := 0;
      v_count           NUMBER                                           := 0;
      v_periodo         NUMBER;
      v_flusso          t_mcrei_wrk_qdc.flusso%TYPE;
      v_flusso_app      t_mcrei_wrk_alimentazione.cod_flusso%TYPE;
      note              t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
      v_cod_abi         t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_cod_file        t_mcrei_wrk_acquisizione.cod_file%TYPE;
      v_seq             NUMBER                            := p_rec.seq_flusso;
      v_desc_flusso     t_mcrei_wrk_alimentazione.desc_flusso%TYPE;
      p_rec_app         f_slave_par_type;
      v_val_qry_app     t_mcrei_wrk_alimentazione.val_qry_app_attiva%TYPE;
      v_val_tab_app     t_mcrei_wrk_alimentazione.val_tab_app%TYPE;
      v_flg_daily       t_mcrei_wrk_alimentazione.flg_daily%TYPE;

      CURSOR c_flusso (c_cod_file VARCHAR2)
      IS
         SELECT cod_flusso, dipendenze
           FROM t_mcrei_wrk_alimentazione
          WHERE dipendenze =
                   (SELECT DISTINCT dipendenze
                               FROM t_mcrei_wrk_alimentazione
                              WHERE cod_flusso =
                                       CASE
                                          WHEN desc_flusso = 'MULTI'
                                             THEN c_cod_file
                                          WHEN desc_flusso = 'BANCA'
                                             THEN SUBSTR (c_cod_file,
                                                          0,
                                                            LENGTH (c_cod_file)
                                                          - 6
                                                         )
                                       END);

      CURSOR c_app
      IS
         SELECT   val_qry_app_storica, val_tab_app, flg_daily, desc_flusso,
                  ordine_elaborazione
             FROM t_mcrei_wrk_alimentazione
            WHERE cod_flusso = v_flusso_app AND flg_attiva = 1
         ORDER BY ordine_elaborazione;
   BEGIN
      v_periodo := TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

      BEGIN
         SELECT cod_abi
           INTO v_cod_abi
           FROM t_mcrei_wrk_acquisizione
          WHERE id_flusso = p_rec.seq_flusso;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'COD_ABI=' || v_cod_abi
                                            );
      END;

      FOR r_flusso IN c_flusso (p_rec.nome_file)
      LOOP
         BEGIN
            v_flusso_app := r_flusso.dipendenze;
            v_count := v_count + 1;

            SELECT flusso, cod_abi
              INTO v_flusso, v_cod_abi
              FROM t_mcrei_wrk_qdc qdc
             WHERE qdc.flusso = r_flusso.cod_flusso
               AND NVL (qdc.cod_abi, 0) = NVL (v_cod_abi, 0)
               AND qdc.id_dper = v_periodo
               AND qdc.cod_stato = 'VALIDO';

            UPDATE t_mcrei_wrk_qdc qdc
               SET qdc.cod_stato = 'CARICATA HST',
                   qdc.dta_upd = SYSDATE
             WHERE qdc.flusso = r_flusso.cod_flusso
               AND NVL (qdc.cod_abi, 0) = NVL (v_cod_abi, 0)
               AND qdc.id_dper = v_periodo
               AND qdc.cod_stato = 'VALIDO';

            v_esito := v_esito + 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_error,
                                                SQLCODE,
                                                SQLERRM,
                                                   'FLUSSO '
                                                || r_flusso.cod_flusso
                                                || ' NON PRESENTE PER ABI '
                                                || v_cod_abi
                                               );
         END;
      END LOOP;

      IF (v_esito = v_count)                         -- dipendenze soddisfatte
      THEN
         COMMIT;

         FOR r_app IN c_app
         LOOP
            IF (r_app.val_qry_app_storica IS NOT NULL)
            THEN
               IF (r_app.desc_flusso = 'BANCA')
               THEN
                  note := note||' ERRORE SU QUERY: val_qry_app_storica ordine_elaborazione '||r_app.ordine_elaborazione||' desc_flusso '||r_app.desc_flusso||chr(10);
                  EXECUTE IMMEDIATE TO_CHAR (r_app.val_qry_app_storica)
                              USING v_periodo, v_cod_abi;

                  COMMIT;
               ELSE
                  IF r_app.val_tab_app = 'T_MCREI_APP_PCR_RAPPORTI'
                  THEN
                     EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCREI_APP_PCR_RAPPORTI';
                  END IF;

                  EXECUTE IMMEDIATE TO_CHAR (r_app.val_qry_app_storica)
                              USING v_periodo;

                  COMMIT;
               END IF;

               note := note||
                     'FLUSSO '
                  || v_flusso_app
                  || '.'
                  || v_cod_abi
                  || ' ESEGUITA QUERY CON TAB TARGET '
                  || r_app.val_tab_app;
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                note,
                                                r_app.val_qry_app_storica
                                               );
            END IF;
         END LOOP;
      ELSE                                       -- dipendenze non soddisfatte
         ROLLBACK;
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_warning,
                                          SQLCODE,
                                          SQLERRM,
                                             v_desc_flusso
                                          || '.'
                                          || v_cod_abi
                                          || ': DIPENDENZE NON SODDISFATTE'
                                         );
      END IF;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_caricamenti
                                    (p_rec.seq_flusso,
                                     c_nome,
                                     pkg_mcrei_audit.c_error,
                                     SQLCODE,
                                     SQLERRM,
                                     'Errore funzione FNC_MCREI_ALIMENTA_HST'
                                    );
         RETURN ko;
   END fnc_mcrei_alimenta_hst;

   FUNCTION fnc_mcrei_calcola_flg (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      c_nome   CONSTANT VARCHAR2 (100)
                                     := c_package || '.fnc_mcrei_calcola_flg';
      v_esito           NUMBER                                           := 0;
      v_count           NUMBER                                           := 0;
      v_periodo         NUMBER;
      v_result          NUMBER;
      v_seq             NUMBER                            := p_rec.seq_flusso;
      v_flusso          t_mcrei_wrk_qdc.flusso%TYPE;
      v_flusso_app      t_mcrei_wrk_alimentazione.cod_flusso%TYPE;
      note              t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
      v_cod_abi         t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_cod_file        t_mcrei_wrk_acquisizione.cod_file%TYPE;
      v_desc_flusso     t_mcrei_wrk_alimentazione.desc_flusso%TYPE;
      p_rec_app         f_slave_par_type;
      p_rec_tab         f_slave_par_type;
      v_val_qry_app     t_mcrei_wrk_alimentazione.val_qry_app_attiva%TYPE;
      v_val_tab_app     t_mcrei_wrk_alimentazione.val_tab_app%TYPE;
      v_flg_daily       t_mcrei_wrk_alimentazione.flg_daily%TYPE;
      v_lock_result     NUMBER;
      v_lockhandle      VARCHAR2 (200);

      CURSOR c_flusso (c_cod_file VARCHAR2)
      IS
         SELECT cod_flusso, dipendenze
           FROM t_mcrei_wrk_alimentazione
          WHERE dipendenze =
                   (SELECT DISTINCT dipendenze
                               FROM t_mcrei_wrk_alimentazione
                              WHERE cod_flusso =
                                       CASE
                                          WHEN desc_flusso = 'MULTI'
                                             THEN c_cod_file
                                          WHEN desc_flusso = 'BANCA'
                                             THEN SUBSTR (c_cod_file,
                                                          0,
                                                            LENGTH (c_cod_file)
                                                          - 6
                                                         )
                                       END);

      CURSOR c_app
      IS
         SELECT   val_qry_calc_flg, val_tab_app, flg_daily, desc_flusso,
                  ordine_elaborazione
             FROM t_mcrei_wrk_alimentazione
            WHERE cod_flusso = v_flusso_app
         ORDER BY ordine_elaborazione;
   BEGIN
      v_periodo := TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

      BEGIN
         SELECT cod_abi
           INTO v_cod_abi
           FROM t_mcrei_wrk_acquisizione
          WHERE id_flusso = p_rec.seq_flusso;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'COD_ABI=' || v_cod_abi
                                            );
      END;

      FOR r_flusso IN c_flusso (p_rec.nome_file)
      LOOP
         BEGIN
            v_flusso_app := r_flusso.dipendenze;
            v_count := v_count + 1;

            SELECT flusso, cod_abi
              INTO v_flusso, v_cod_abi
              FROM t_mcrei_wrk_qdc qdc
             WHERE qdc.flusso = r_flusso.cod_flusso
               AND NVL (qdc.cod_abi, 0) = NVL (v_cod_abi, 0)
               AND qdc.id_dper = v_periodo
               AND qdc.cod_stato = 'CARICATA APP';

            UPDATE t_mcrei_wrk_qdc qdc
               SET qdc.cod_stato = 'APP CARICATA E FLG CALCOLATI',
                   qdc.dta_upd = SYSDATE
             WHERE qdc.flusso = r_flusso.cod_flusso
               AND NVL (qdc.cod_abi, 0) = NVL (v_cod_abi, 0)
               AND qdc.id_dper = v_periodo
               AND qdc.cod_stato = 'CARICATA APP';

            v_esito := v_esito + 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_error,
                                                SQLCODE,
                                                SQLERRM,
                                                   'FLUSSO '
                                                || r_flusso.cod_flusso
                                                || ' NON PRESENTE PER ABI '
                                                || v_cod_abi
                                               );
         END;
      END LOOP;

      IF (v_esito = v_count)                         -- dipendenze soddisfatte
      THEN
         FOR r_app IN c_app
         LOOP
            note := note||'QUERY: DESC_FLUSSO = ' ||R_APP.DESC_FLUSSO||' ORDINE_ELABORAZIONE = '||TO_CHAR(R_APP.ORDINE_ELABORAZIONE)||' val_qry_calc_flg'||CHR(10);
            DBMS_LOCK.allocate_unique (r_app.val_tab_app, v_lockhandle);
            v_lock_result :=
                           DBMS_LOCK.request (v_lockhandle, DBMS_LOCK.x_mode);
            pkg_mcrei_audit.log_caricamenti
                             (p_rec.seq_flusso,
                              c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                                 'LOCK_RESULT LOCKED - '
                              || CASE
                                    WHEN v_lock_result = 1
                                       THEN 'Timeout'
                                    WHEN v_lock_result = 2
                                       THEN 'Deadlock'
                                    WHEN v_lock_result = 3
                                       THEN 'Parameter Error'
                                    WHEN v_lock_result = 4
                                       THEN 'Already owned'
                                    WHEN v_lock_result = 5
                                       THEN 'Illegal Lock Handle'
                                 END
                             );

            IF (r_app.val_qry_calc_flg IS NOT NULL)
            THEN
               EXECUTE IMMEDIATE TO_CHAR (r_app.val_qry_calc_flg)
                           USING v_cod_abi;

               note := NOTE||
                     ' FLUSSO '
                  || v_flusso_app
                  || '.'
                  || v_cod_abi
                  || ' ESEGUITA QUERY CON TAB TARGET '
                  || r_app.val_tab_app||CHR(10);
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                note,
                                                r_app.val_qry_calc_flg
                                               );
            END IF;
            COMMIT;
            v_lock_result := DBMS_LOCK.release (v_lockhandle);
         END LOOP;

         IF v_flusso_app = 'APP_BANCA'
         THEN
            note :=note
               || ' Accensione flg_storico_calcolato per abi :'
               || v_cod_abi
               || CHR (10);

            UPDATE t_mcrei_wrk_abi_lavorati
               SET flg_storico_calcolato = 1,
                   dta_upd = SYSDATE
             WHERE cod_abi = v_cod_abi;

            COMMIT;
         END IF;
--         COMMIT;
      ELSE                                       -- dipendenze non soddisfatte
         ROLLBACK;
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_warning,
                                          SQLCODE,
                                          SQLERRM,
                                             v_desc_flusso
                                          || '.'
                                          || v_cod_abi
                                          || ': DIPENDENZE NON SODDISFATTE'
                                         );
      END IF;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_caricamenti
                                (p_rec.seq_flusso,
                                 c_nome,
                                 pkg_mcrei_audit.c_error,
                                 SQLCODE,
                                 SQLERRM,
                                    'Errore FUNZIONE FNC_MCREI_CALCOLA_FLG :'
                                 || note
                                );
         RETURN ko;
   END fnc_mcrei_calcola_flg;

   FUNCTION fnc_mcrei_archiviatore (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      c_nome   CONSTANT VARCHAR2 (100)
                                    := c_package || '.fnc_mcrei_archiviatore';
      v_esito           NUMBER                                           := 0;
      v_count           NUMBER                                           := 0;
      v_periodo         NUMBER;
      v_flusso          t_mcrei_wrk_qdc.flusso%TYPE;
      v_flusso_app      t_mcrei_wrk_alimentazione.cod_flusso%TYPE;
      note              t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
      v_cod_abi         t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_cod_file        t_mcrei_wrk_acquisizione.cod_file%TYPE;
      v_seq             NUMBER                            := p_rec.seq_flusso;
      v_desc_flusso     t_mcrei_wrk_alimentazione.desc_flusso%TYPE;
      p_rec_app         f_slave_par_type;
      p_rec_tab         f_slave_par_type;
      v_val_qry_app     t_mcrei_wrk_alimentazione.val_qry_app_attiva%TYPE;
      v_val_tab_app     t_mcrei_wrk_alimentazione.val_tab_app%TYPE;
      v_flg_daily       t_mcrei_wrk_alimentazione.flg_daily%TYPE;
      v_lock_result     NUMBER;
      v_lockhandle      VARCHAR2 (200);
      V_TOMORROW        DATE;

      CURSOR c_flusso (c_cod_file VARCHAR2)
      IS
         SELECT cod_flusso, dipendenze
           FROM t_mcrei_wrk_alimentazione
          WHERE dipendenze =
                   (SELECT DISTINCT dipendenze
                               FROM t_mcrei_wrk_alimentazione
                              WHERE cod_flusso =
                                       CASE
                                          WHEN desc_flusso = 'MULTI'
                                             THEN c_cod_file
                                          WHEN desc_flusso = 'BANCA'
                                             THEN SUBSTR (c_cod_file,
                                                          0,
                                                            LENGTH (c_cod_file)
                                                          - 6
                                                         )
                                       END);

      CURSOR c_app
      IS
         SELECT   val_qry_archiviatore, val_tab_app, flg_daily, desc_flusso,
                  ordine_elaborazione
             FROM t_mcrei_wrk_alimentazione
            WHERE cod_flusso = v_flusso_app
         ORDER BY ordine_elaborazione;
   BEGIN
      v_periodo := TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

      BEGIN
         SELECT cod_abi
           INTO v_cod_abi
           FROM t_mcrei_wrk_acquisizione
          WHERE id_flusso = p_rec.seq_flusso;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso, c_nome,pkg_mcrei_audit.c_error,
                                             SQLCODE,SQLERRM,'COD_ABI=' || v_cod_abi );
      END;

      FOR r_flusso IN c_flusso (p_rec.nome_file)
      LOOP
         BEGIN
            v_flusso_app := r_flusso.dipendenze;
            v_count := v_count + 1;

            SELECT flusso, cod_abi
              INTO v_flusso, v_cod_abi
              FROM t_mcrei_wrk_qdc qdc
             WHERE qdc.flusso = r_flusso.cod_flusso
               AND NVL (qdc.cod_abi, 0) = NVL (v_cod_abi, 0)
               AND qdc.id_dper = v_periodo
               AND qdc.cod_stato = 'APP CARICATA E FLG CALCOLATI';

            UPDATE t_mcrei_wrk_qdc qdc
               SET qdc.cod_stato = 'APP CARICATA E ARCHIVIATI FLG 0',
                   qdc.dta_upd = SYSDATE
             WHERE qdc.flusso = r_flusso.cod_flusso
               AND NVL (qdc.cod_abi, 0) = NVL (v_cod_abi, 0)
               AND qdc.id_dper = v_periodo
               AND qdc.cod_stato = 'APP CARICATA E FLG CALCOLATI';

            v_esito := v_esito + 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_error,
                                                SQLCODE,
                                                SQLERRM,
                                                   'FLUSSO '
                                                || r_flusso.cod_flusso
                                                || ' NON PRESENTE PER ABI '
                                                || v_cod_abi
                                               );
         END;
      END LOOP;

      IF (v_esito = v_count)                         -- dipendenze soddisfatte
      THEN
         FOR r_app IN c_app
         LOOP
            -- BEGIN LOCK
            DBMS_LOCK.allocate_unique (r_app.val_tab_app, v_lockhandle);
            v_lock_result :=
                           DBMS_LOCK.request (v_lockhandle, DBMS_LOCK.x_mode);
            pkg_mcrei_audit.log_caricamenti
                             (p_rec.seq_flusso,
                              c_nome,
                              pkg_mcrei_audit.c_debug,
                              SQLCODE,
                              SQLERRM,
                                 'LOCK_RESULT LOCKED - '
                              || CASE
                                    WHEN v_lock_result = 1
                                       THEN 'Timeout'
                                    WHEN v_lock_result = 2
                                       THEN 'Deadlock'
                                    WHEN v_lock_result = 3
                                       THEN 'Parameter Error'
                                    WHEN v_lock_result = 4
                                       THEN 'Already owned'
                                    WHEN v_lock_result = 5
                                       THEN 'Illegal Lock Handle'
                                 END
                             );                                   --19.06.2012

            IF (r_app.val_qry_archiviatore IS NOT NULL)
            THEN
            BEGIN
               EXECUTE IMMEDIATE TO_CHAR (r_app.val_qry_archiviatore)
                           USING v_cod_abi;

               note := NOTE||
                     'FLUSSO '
                  || v_flusso_app
                  || '.'
                  || v_cod_abi
                  || ' ESEGUITA QUERY CON TAB TARGET '
                  || r_app.val_tab_app;
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                SQLERRM,
                                                NOTE
                                               );
               note := NOTE||
                     'DELETE  DELLA PARTIZIONE STORICA DELL''APP :'
                  || r_app.val_tab_app
                  || ' E ABI '
                  || v_cod_abi;

               EXECUTE IMMEDIATE    'DELETE  '
                                 || r_app.val_tab_app
                                 || ' WHERE FLG_ATTIVA = 0 AND COD_ABI = '
                                 || v_cod_abi;

               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                SQLERRM,
                                                note
                                               );
            EXCEPTION WHEN OTHERS THEN
            ROLLBACK;
            NOTE:='ERRORE ARCHIVIATORE '|| r_app.val_tab_app ||' '||v_cod_abi;
             v_lock_result := DBMS_LOCK.release (v_lockhandle);
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                    c_nome,
                                    pkg_mcrei_audit.c_debug,
                                    SQLCODE,
                                    SQLERRM,
                                    note
                                   );
            END;
            END IF;

            COMMIT;
            v_lock_result := DBMS_LOCK.release (v_lockhandle);
         END LOOP;

         IF v_flusso_app = 'APP_BANCA'
         THEN
            note := NOTE|| ' Accensione abi :' || v_cod_abi||' FLUSSO '||p_rec.seq_flusso||CHR(10);

            UPDATE t_mcrei_wrk_abi_lavorati
               SET flg_abi_lavorato = 1,
                   dta_upd = SYSDATE
             WHERE cod_abi = v_cod_abi;

            COMMIT;
            note := NOTE|| 'refresh aggregate 1: pkg_mcrei_refresh_aggregate.fnc_mcrei_mv_posiz_inc_ri'||chr(10);
            v_esito :=
               pkg_mcrei_refresh_aggregate.fnc_mcrei_mv_posiz_inc_ri
                                                             (p_rec.seq_flusso);

            IF v_esito = 1
            THEN
              note := NOTE|| 'refresh aggregate 2: pkg_mcrei_refresh_aggregate.fnc_mcrei_mv_posiz_con_classif'||chr(10);
               v_esito :=
                  pkg_mcrei_refresh_aggregate.fnc_mcrei_mv_posiz_con_classif
                                                            (p_rec.seq_flusso);
            END IF;
         END IF;
      ELSE                                       -- dipendenze non soddisfatte
         ROLLBACK;
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_warning,
                                          SQLCODE,
                                          SQLERRM,
                                             v_desc_flusso
                                          || '.'
                                          || v_cod_abi
                                          || ': DIPENDENZE NON SODDISFATTE'
                                         );
      END IF;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_caricamenti
                               (p_rec.seq_flusso,
                                c_nome,
                                pkg_mcrei_audit.c_error,
                                SQLCODE,
                                SQLERRM,
                                   'Errore funzione FNC_MCREI_ARCHIVIATORE :'
                                || note
                               );
         RETURN ko;
   END fnc_mcrei_archiviatore;

   FUNCTION fnc_mcrei_estrattore (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      c_nome   CONSTANT VARCHAR2 (100)
                                      := c_package || '.fnc_mcrei_estrattore';
      v_esito           NUMBER                                           := 0;
      v_count           NUMBER                                           := 0;
      v_periodo         NUMBER;
      v_flusso          t_mcrei_wrk_qdc.flusso%TYPE;
      v_flusso_app      t_mcrei_wrk_alimentazione.cod_flusso%TYPE;
      note              t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
      v_cod_abi         t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_cod_file        t_mcrei_wrk_acquisizione.cod_file%TYPE;
      v_seq             NUMBER                            := p_rec.seq_flusso;
      v_desc_flusso     t_mcrei_wrk_alimentazione.desc_flusso%TYPE;
      p_rec_app         f_slave_par_type;
      v_val_qry_app     t_mcrei_wrk_alimentazione.val_qry_app_attiva%TYPE;
      v_val_tab_app     t_mcrei_wrk_alimentazione.val_tab_app%TYPE;
      v_flg_daily       t_mcrei_wrk_alimentazione.flg_daily%TYPE;

      CURSOR c_flusso (c_cod_file VARCHAR2)
      IS
         SELECT cod_flusso, dipendenze
           FROM t_mcrei_wrk_alimentazione
          WHERE dipendenze =
                   (SELECT DISTINCT dipendenze
                               FROM t_mcrei_wrk_alimentazione
                              WHERE cod_flusso =
                                       CASE
                                          WHEN desc_flusso = 'MULTI'
                                             THEN c_cod_file
                                          WHEN desc_flusso = 'BANCA'
                                             THEN SUBSTR (c_cod_file,
                                                          0,
                                                            LENGTH (c_cod_file)
                                                          - 6
                                                         )
                                       END);

      CURSOR c_app
      IS
         SELECT   val_qry_estrattore, val_tab_app, flg_daily, desc_flusso,
                  ordine_elaborazione
             FROM t_mcrei_wrk_alimentazione
            WHERE cod_flusso = v_flusso_app
         ORDER BY ordine_elaborazione;
   BEGIN
      v_periodo := TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));
      v_seq := p_rec.seq_flusso;

      BEGIN
         SELECT cod_abi
           INTO v_cod_abi
           FROM t_mcrei_wrk_acquisizione
          WHERE id_flusso = p_rec.seq_flusso;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'COD_ABI=' || v_cod_abi
                                            );
      END;

      FOR r_flusso IN c_flusso (p_rec.nome_file)
      LOOP
         BEGIN
            v_flusso_app := r_flusso.dipendenze;
            v_count := v_count + 1;

            SELECT flusso, cod_abi
              INTO v_flusso, v_cod_abi
              FROM t_mcrei_wrk_qdc qdc
             WHERE qdc.flusso = r_flusso.cod_flusso
               AND NVL (qdc.cod_abi, 0) = NVL (v_cod_abi, 0)
               AND qdc.id_dper = v_periodo
               AND qdc.cod_stato = 'CARICATA HST';

            UPDATE t_mcrei_wrk_qdc qdc
               SET qdc.cod_stato = 'HST CARICATA E ESTRATTI FLAG 1',
                   qdc.dta_upd = SYSDATE
             WHERE qdc.flusso = r_flusso.cod_flusso
               AND NVL (qdc.cod_abi, 0) = NVL (v_cod_abi, 0)
               AND qdc.id_dper = v_periodo
               AND qdc.cod_stato = 'CARICATA HST';

            v_esito := v_esito + 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_error,
                                                SQLCODE,
                                                SQLERRM,
                                                   'FLUSSO '
                                                || r_flusso.cod_flusso
                                                || ' NON PRESENTE PER ABI '
                                                || v_cod_abi
                                               );
         END;
      END LOOP;

      IF (v_esito = v_count)                         -- dipendenze soddisfatte
      THEN
         COMMIT;

         FOR r_app IN c_app
         LOOP
            note := 'ERRORE SU QUERY: ' || r_app.val_qry_estrattore;

            IF TO_CHAR (r_app.val_qry_estrattore) IS NOT NULL
            THEN
               IF r_app.val_tab_app = 'T_MCREI_APP_DELIBERE'
               THEN
                  aggancio_pratica_hst (v_esito, v_seq);
                  aggancio_pratica (v_esito, v_seq);
                  aggancio_pr_chius (v_esito, v_seq);
               END IF;

               IF r_app.val_tab_app = 'T_MCREI_APP_RAPPORTI_PROPOSTE'
               THEN
                  EXECUTE IMMEDIATE TO_CHAR (r_app.val_qry_estrattore)
                              USING v_periodo, v_cod_abi;
               ELSE
                  EXECUTE IMMEDIATE TO_CHAR (r_app.val_qry_estrattore);
               END IF;

               note :=
                     'FLUSSO '
                  || v_flusso_app
                  || '.'
                  || v_cod_abi
                  || ' ESEGUITA QUERY CON TAB TARGET '
                  || r_app.val_tab_app;
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                note,
                                                r_app.val_qry_estrattore
                                               );
            END IF;

            IF r_app.val_tab_app = 'T_MCREI_APP_DELIBERE'
            THEN
               note :=
                     'DELETE DEI RECORD CON FLG_ATTIVA A 0 DALLA APP: '
                  || r_app.val_tab_app;

               EXECUTE IMMEDIATE    'DELETE  '
                                 || r_app.val_tab_app
                                 || ' WHERE FLG_ATTIVA = 0';
            ELSIF r_app.val_tab_app = 'T_MCREI_APP_RAPPORTI_PROPOSTE'
            THEN
               note :=
                   'POPOLATA LA TABELLA RAPPORTI_PROPOSTE CON I FLG CORRETTI';
            ELSE
               note :=
                     'DELETE DEI RECORD CON FLG_ATTIVA A 1 DALLA HST: '
                  || r_app.val_tab_app;

               EXECUTE IMMEDIATE    'DELETE  '
                                 || r_app.val_tab_app
                                 || ' WHERE FLG_ATTIVA = 1';
            END IF;

            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_debug,
                                             SQLCODE,
                                             note,
                                             SQLERRM
                                            );
            COMMIT;
         END LOOP;

         IF v_flusso_app = 'APP_HST'
         THEN
            note := 'AGGIORNA TABELLA AGGREGATA';
            v_esito :=
               pkg_mcrei_refresh_aggregate.fnc_mcrei_mv_posiz_inc_ri
                                                            (p_rec.seq_flusso);

            IF v_esito = 1
            THEN
               v_esito :=
                  pkg_mcrei_refresh_aggregate.fnc_mcrei_mv_posiz_con_classif
                                                            (p_rec.seq_flusso);
            END IF;
         END IF;
      ELSE                                       -- dipendenze non soddisfatte
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_warning,
                                          SQLCODE,
                                          SQLERRM,
                                             v_desc_flusso
                                          || '.'
                                          || v_cod_abi
                                          || ': DIPENDENZE NON SODDISFATTE'
                                         );
      END IF;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_caricamenti
                                      (p_rec.seq_flusso,
                                       c_nome,
                                       pkg_mcrei_audit.c_error,
                                       SQLCODE,
                                       SQLERRM,
                                       'Errore funzione FNC_MCREI_ESTRATTORE'
                                      );
         RETURN ko;
   END fnc_mcrei_estrattore;

   --
   -- AGGANCIO_PRATICA  (Procedure)
   --
   FUNCTION fnc_mcrei_alimenta_mpl (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      c_nome        CONSTANT VARCHAR2 (100)
                                    := c_package || '.FNC_MCREI_ALIMENTA_MPL';
      v_esito                NUMBER;
      v_count                NUMBER;
      v_note                 t_mcrei_wrk_audit_caricamenti.note%TYPE
                                                                := 'GENERALE';
      v_cod_abi              t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_cod_file             t_mcrei_wrk_acquisizione.cod_file%TYPE;
      v_val_qry_st           t_mcrei_wrk_alimentazione.val_qry_st%TYPE;
      v_val_qry_vincoli      t_mcrei_wrk_alimentazione.val_qry_vincoli%TYPE;
      v_val_tab_st           t_mcrei_wrk_alimentazione.val_tab_st%TYPE;
      v_val_tab_vincoli      t_mcrei_wrk_alimentazione.val_tab_vincoli%TYPE;
      v_val_tab_app          t_mcrei_wrk_alimentazione.val_tab_app%TYPE;
      v_val_qry_app_attiva   t_mcrei_wrk_alimentazione.val_qry_app_attiva%TYPE;
      v_val_qry_delete       t_mcrei_wrk_alimentazione.val_qry_delete%TYPE;
      v_suffix_partition     t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_seq                  NUMBER                       := p_rec.seq_flusso;
      v_desc_flusso          t_mcrei_wrk_alimentazione.desc_flusso%TYPE;
      v_subpart_name         t_mcrei_wrk_acquisizione.val_st_partition%TYPE;
      v_cod_flusso           t_mcrei_wrk_acquisizione.cod_flusso%TYPE;
      --- LOCK
      v_lock_result          NUMBER;
      v_lockhandle           VARCHAR2 (200);
   BEGIN
      BEGIN
         SELECT cod_abi, cod_file, cod_flusso
           INTO v_cod_abi, v_cod_file, v_cod_flusso
           FROM t_mcrei_wrk_acquisizione
          WHERE id_flusso = p_rec.seq_flusso;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'COD_ABI=' || v_cod_abi
                                            );
      END;

      BEGIN
         SELECT val_qry_vincoli, val_qry_st, val_qry_app_attiva,
                val_qry_delete, val_tab_st, val_tab_vincoli,
                val_tab_app, desc_flusso
           INTO v_val_qry_vincoli, v_val_qry_st, v_val_qry_app_attiva,
                v_val_qry_delete, v_val_tab_st, v_val_tab_vincoli,
                v_val_tab_app, v_desc_flusso
           FROM t_mcrei_wrk_alimentazione
          WHERE cod_flusso =
                   CASE
                      WHEN desc_flusso = 'MULTI'
                         THEN v_cod_file
                      WHEN desc_flusso = 'BANCA'
                         THEN SUBSTR (v_cod_file, 0, LENGTH (v_cod_file) - 6)
                   END;
      EXCEPTION
         WHEN OTHERS
         THEN
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_error,
                                             SQLCODE,
                                             SQLERRM,
                                             'Parametri alimentazione FL'
                                            );
      END;

      DBMS_LOCK.allocate_unique (v_val_tab_st, v_lockhandle);
      pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                       c_nome,
                                       pkg_mcrei_audit.c_error,
                                       SQLCODE,
                                       SQLERRM,
                                          'Lock :  '
                                       || v_val_tab_st
                                       || '_'
                                       || p_rec.seq_flusso
                                      );
      v_lock_result := DBMS_LOCK.request (v_lockhandle, DBMS_LOCK.x_mode);
      v_esito :=
         pkg_mcrei_gestione_partizioni.fnc_crea_partizione
                                                     (v_val_tab_st,
                                                      TO_CHAR (p_rec.periodo,
                                                               'YYYYMMDD'
                                                              ),
                                                      p_rec.seq_flusso,
                                                      v_desc_flusso
                                                     );
      v_note := 'esito: ' || v_esito;

      IF (v_esito = 1)
      THEN
         v_note :=
                  ' TRUNCATE periodo=' || TO_CHAR (p_rec.periodo, 'YYYYMMDD');
         v_esito :=
            pkg_mcrei_gestione_partizioni.fnc_truncate_partition
                                         (v_val_tab_st,
                                          TO_NUMBER (TO_CHAR (p_rec.periodo,
                                                              'YYYYMMDD'
                                                             )
                                                    ),
                                          p_rec.seq_flusso
                                         );
         v_note := 'Eseguita Truncate con esito: ' || v_esito;
      END IF;

      IF (v_esito = 1)
      THEN
         v_note := 'eseguita query vincoli';

         EXECUTE IMMEDIATE TO_CHAR (v_val_qry_vincoli)
                     USING p_rec.seq_flusso,
                           TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));
         COMMIT;
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_debug,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE '
                                          || v_note
                                          || ' '
                                          || v_val_tab_vincoli
                                         );
         v_note := 'eseguita query st';

         EXECUTE IMMEDIATE TO_CHAR (v_val_qry_st)
                     USING TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

         v_note := 'eseguita query storico';
         v_subpart_name := 'INC_P' || TO_CHAR (p_rec.periodo, 'YYYYMMDD');
         -- NOME PARTIZIONE
         COMMIT;
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_debug,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE '
                                          || v_note
                                          || ' '
                                          || v_val_tab_st
                                         );
         v_note := 'eseguita query delete';

         EXECUTE IMMEDIATE TO_CHAR (v_val_qry_delete)
                     USING TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_debug,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE '
                                          || v_note
                                          || ' '
                                          || v_val_tab_app
                                         );
         COMMIT;
         v_note := 'eseguita query app';

         EXECUTE IMMEDIATE TO_CHAR (v_val_qry_app_attiva)
                     USING TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

         COMMIT;
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_debug,
                                          SQLCODE,
                                          SQLERRM,
                                             'GENERALE '
                                          || v_note
                                          || ' '
                                          || v_val_tab_app
                                         );
      END IF;

---------------------------------------------------------------------------------------------------------------
      IF (v_esito = 1)
      THEN
         EXECUTE IMMEDIATE    'SELECT COUNT(*) FROM '
                           || v_val_tab_vincoli
                           || ' WHERE ID_FLUSSO = '
                           || p_rec.seq_flusso
                      INTO v_count;

         COMMIT;
         v_note := 'contato dalla tabella vincoli';

         UPDATE t_mcrei_wrk_acquisizione
            SET val_scarti_vincoli = v_count,
                val_st_partition = v_subpart_name
          WHERE id_flusso = p_rec.seq_flusso;

         COMMIT;
         v_note := 'aggiornata tabella acquisizione';
      END IF;

      UPDATE t_mcrei_wrk_qdc
         SET id_flusso = p_rec.seq_flusso,
             cod_stato = 'VALIDO',
             dta_upd = SYSDATE
       WHERE flusso = v_cod_flusso
         AND NVL (cod_abi, 0) = NVL (v_cod_abi, 0)
         AND id_dper = TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));

      IF (SQL%ROWCOUNT = 0)
      THEN
         INSERT INTO t_mcrei_wrk_qdc
                     (id_flusso, flusso, cod_abi,
                      id_dper,
                      cod_stato, dta_ins
                     )
              VALUES (p_rec.seq_flusso, v_cod_flusso, v_cod_abi,
                      TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD')),
                      'VALIDO', SYSDATE
                     );
      END IF;

      COMMIT;
      v_lock_result := DBMS_LOCK.release (v_lockhandle);
      RETURN ok * v_esito;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'GENERALE ' || v_note
                                         );
         RETURN ko;
   END fnc_mcrei_alimenta_mpl;

   PROCEDURE aggancio_pratica (v_result OUT NUMBER, p_seq IN NUMBER)
   IS
   BEGIN
      /***********************************************************************************************
        Per tutte le coppie (ABI,NDG) prive di pratica legale,individuate nella tabella DELIBERE,
        (si tratta di delibere di classificazione a incaglio o sofferenza fatte almeno il giorno prima),
        recupera (se esistente) la pratica legale corrispondente.
      **************************************************************************************************/
      MERGE INTO t_mcrei_app_delibere d
         USING (SELECT *
                  FROM (SELECT p.cod_abi, p.cod_ndg,
                               p.cod_protocollo_delibera, t.cod_pratica,
                               t.val_anno_pratica, t.cod_uo_pratica,
                               dta_apertura,
                               RANK () OVER (PARTITION BY t.cod_abi, t.cod_ndg, dta_chiusura ORDER BY dta_apertura DESC)
                                                                        AS mm
                          FROM t_mcrei_app_delibere p, t_mcrei_app_pratiche t
                         WHERE p.cod_abi = t.cod_abi
                           AND p.cod_ndg = t.cod_ndg
                           AND p.flg_attiva = '1'
                           AND p.cod_pratica IS NULL
                           AND t.flg_attiva = '1'
                           --AND P.COD_NDG = '0000481437066000'
                           AND TRUNC (SYSDATE) BETWEEN dta_apertura
                                                   AND dta_chiusura) s
                 WHERE s.mm = 1) s
         ON (    s.cod_abi = d.cod_abi
             AND s.cod_ndg = d.cod_ndg
             AND s.cod_protocollo_delibera = d.cod_protocollo_delibera)
         WHEN MATCHED THEN
            UPDATE
               SET d.cod_pratica = s.cod_pratica,
                   d.val_anno_pratica = s.val_anno_pratica,
                   d.cod_uo_pratica = s.cod_uo_pratica
            ;
      COMMIT;
      v_result := ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_caricamenti (p_seq,
                                          'AGGANCIO_PRATICA',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'AGGANCIO_PRATICA'
                                         );
         v_result := ko;
   END aggancio_pratica;

   --
   -- AGGANCIO_PRATICA_HST  (Procedure)
   --
   PROCEDURE aggancio_pratica_hst (v_result OUT NUMBER, p_seq IN NUMBER)
   IS
   BEGIN
      /***********************************************************************************************
        Per tutte le coppie (ABI,NDG) prive di pratica legale,individuate nella tabella DELIBERE,
        (si tratta di delibere di classificazione a incaglio o sofferenza fatte almeno il giorno prima),
        recupera (se esistente) la pratica legale corrispondente.
      **************************************************************************************************/
      MERGE INTO mcre_own.t_mcrei_app_delibere d
         USING (SELECT del.cod_ndg, del.cod_abi, del.cod_protocollo_delibera,
                       del.val_anno_proposta, del.val_progr_proposta,
                       pra.cod_pratica, pra.val_anno_pratica,
                       pra.cod_uo_pratica
                  FROM (SELECT r.cod_ndg, r.cod_abi,
                               r.cod_protocollo_delibera, r.val_anno_proposta,
                               r.val_progr_proposta
                          FROM (SELECT p.cod_abi, p.cod_ndg,
                                       p.cod_protocollo_delibera,
                                       val_anno_proposta, val_progr_proposta,
                                       RANK () OVER (PARTITION BY p.cod_abi, p.cod_ndg, p.val_anno_proposta ORDER BY val_progr_proposta DESC)
                                                                        AS mm
                                  FROM t_mcrei_app_delibere p
                                 WHERE p.flg_attiva = '1'
                                   AND p.cod_pratica IS NULL) r
                         WHERE r.mm = 1) del,
                       (SELECT x.cod_ndg, x.cod_abi, x.cod_pratica,
                               x.val_anno_pratica, x.cod_uo_pratica
                          FROM (SELECT t.cod_abi, t.cod_ndg, t.cod_pratica,
                                       t.val_anno_pratica, t.cod_uo_pratica,
                                       RANK () OVER (PARTITION BY t.cod_abi, t.cod_ndg, t.val_anno_pratica ORDER BY t.cod_pratica DESC)
                                                                        AS nn
                                  FROM t_mcrei_hst_pratiche t
                                 WHERE t.flg_attiva = '0') x
                         WHERE x.nn = 1) pra
                 WHERE del.cod_abi = pra.cod_abi
                   AND del.cod_ndg = pra.cod_ndg
                   AND del.val_anno_proposta = pra.val_anno_pratica) s
         ON (    s.cod_abi = d.cod_abi
             AND s.cod_ndg = d.cod_ndg
             AND s.cod_protocollo_delibera = d.cod_protocollo_delibera
             AND d.val_anno_proposta = s.val_anno_pratica)
         WHEN MATCHED THEN
            UPDATE
               SET d.cod_pratica = s.cod_pratica,
                   d.val_anno_pratica = s.val_anno_pratica,
                   d.cod_uo_pratica = s.cod_uo_pratica, flg_attiva = '0'
            ;
      COMMIT;
      v_result := ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_caricamenti (p_seq,
                                          'AGGANCIO_PRATICA_HST',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'AGGANCIO_PRATICA_HST'
                                         );
         v_result := ko;
   END aggancio_pratica_hst;

   --
   -- AGGANCIO_PR_CHIUS  (Procedure)
   --
   PROCEDURE aggancio_pr_chius (v_result OUT NUMBER, p_seq IN NUMBER)
   IS
      tmpvar   NUMBER;
   /***********************************************************************************************
     Tutte le coppie (ABI,NDG) prive di pratica legale,individuate nella tabella DELIBERE,
     e per cui esite una coppia (ABI, NDG) con una o pi¿ pratiche chiuse nella tabella delle pratiche,
     vengono aggiornate come non attive (flg_attiva = 0)
   **************************************************************************************************/
   BEGIN
      UPDATE t_mcrei_app_delibere
         SET flg_attiva = '0'
       WHERE (cod_abi, cod_ndg, val_progr_proposta) IN (
                SELECT DISTINCT d.cod_abi, d.cod_ndg, d.val_progr_proposta
                           FROM t_mcrei_app_delibere d,
                                t_mcrei_hst_pratiche p
                          WHERE d.cod_abi = p.cod_abi
                            AND d.cod_ndg = p.cod_ndg
                            AND d.flg_attiva = '1'
                            AND d.cod_pratica IS NULL
                            AND p.dta_chiusura < TRUNC (SYSDATE));

      COMMIT;
      v_result := ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_caricamenti (p_seq,
                                          'AGGANCIO_PR_CHIUS',
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          'AGGANCIO_PR_CHIUS'
                                         );
   END;

   /**
              Azzera il flg_abi lavorato per tutti gli abi
              invocato da del_flg_abi.ksh
   **/
   PROCEDURE fnc_upd_del_flg_lavorati
   IS
      c_nome   CONSTANT VARCHAR2 (100)
                                  := c_package || '.fnc_upd_flg_abi_lavorato';
      note              t_mcrei_wrk_audit_caricamenti.note%TYPE;
   BEGIN
      note := 'Reset tabella T_MCREI_WRK_ABI_LAVORATI';

      UPDATE t_mcrei_wrk_abi_lavorati
         SET flg_abi_lavorato = 0,
             flg_storico_calcolato = 0,
             flg_alert_1_calcolato = 0,
             flg_alert_2_calcolato = 0,
             flg_alert_3_calcolato = 0,
             flg_alert_4_calcolato = 0,
             flg_alert_5_calcolato = 0,
             flg_alert_6_calcolato = 0,
             dta_upd = SYSDATE;

      COMMIT;
      pkg_mcrei_audit.log_caricamenti
                              (-3,
                               c_nome,
                               pkg_mcrei_audit.c_error,
                               SQLCODE,
                               SQLERRM,
                                  'Errore funzione fnc_upd_flg_abi_lavorato :'
                               || note
                              );
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         pkg_mcrei_audit.log_caricamenti
                             (-3,
                              c_nome,
                              pkg_mcrei_audit.c_error,
                              SQLCODE,
                              SQLERRM,
                                 'Errore funzione fnc_upd_flg_abi_lavorato :'
                              || note
                             );
         NULL;
   END;

   FUNCTION fnc_mcrei_damp_abi (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      c_nome   CONSTANT VARCHAR2 (100)  := c_package || '.fnc_mcrei_damp_abi';
      v_esito           NUMBER;
      v_count           NUMBER;
      note              t_mcrei_wrk_audit_caricamenti.note%TYPE := 'GENERALE';
      v_cod_abi         t_mcrei_wrk_acquisizione.cod_abi%TYPE;
      v_cod_file        t_mcrei_wrk_acquisizione.cod_file%TYPE;
      v_seq             NUMBER                            := p_rec.seq_flusso;
      v_desc_flusso     t_mcrei_wrk_alimentazione.desc_flusso%TYPE;
      v_lock_result     NUMBER;
      v_lockhandle      VARCHAR2 (200);
   BEGIN
      note := 'INIBITO ABI : ';

      SELECT cod_abi
        INTO v_cod_abi
        FROM t_mcrei_wrk_acquisizione
       WHERE id_flusso = p_rec.seq_flusso;

      DBMS_LOCK.allocate_unique (v_cod_abi, v_lockhandle);
      v_lock_result := DBMS_LOCK.request (v_lockhandle, DBMS_LOCK.x_mode);
      pkg_mcrei_audit.log_caricamenti
                              (p_rec.seq_flusso,
                               c_nome,
                               pkg_mcrei_audit.c_debug,
                               SQLCODE,
                               SQLERRM,
                                  'LOCK_RESULT LOCKED - '
                               || CASE
                                     WHEN v_lock_result = 1
                                        THEN 'Timeout'
                                     WHEN v_lock_result = 2
                                        THEN 'Deadlock'
                                     WHEN v_lock_result = 3
                                        THEN 'Parameter Error'
                                     WHEN v_lock_result = 4
                                        THEN 'Already owned'
                                     WHEN v_lock_result = 5
                                        THEN 'Illegal Lock Handle'
                                  END
                              );

      UPDATE t_mcrei_wrk_abi_lavorati
         SET flg_abi_lavorato = 0,
             flg_storico_calcolato = 0,
             flg_alert_1_calcolato = 0,
             flg_alert_2_calcolato = 0,
             flg_alert_3_calcolato = 0,
             flg_alert_4_calcolato = 0,
             flg_alert_5_calcolato = 0,
             flg_alert_6_calcolato = 0,
             dta_upd = SYSDATE,
             id_dper = TO_NUMBER (TO_CHAR (p_rec.periodo, 'yyyymmdd'))
       WHERE cod_abi = v_cod_abi;

      COMMIT;
      v_lock_result := DBMS_LOCK.release (v_lockhandle);
      pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                       c_nome,
                                       pkg_mcrei_audit.c_error,
                                       SQLCODE,
                                       SQLERRM,
                                       note || v_cod_abi
                                      );
      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti
                            (p_rec.seq_flusso,
                             c_nome,
                             pkg_mcrei_audit.c_error,
                             SQLCODE,
                             SQLERRM,
                                'Errore funzione fnc_mcrei_damp_abi COD_ABI='
                             || v_cod_abi
                            );
         RETURN ko;
         RETURN NULL;
   END;
END pkg_mcrei_alimentazione;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_ALIMENTAZIONE FOR MCRE_OWN.PKG_MCREI_ALIMENTAZIONE;


CREATE SYNONYM MCRE_USR.PKG_MCREI_ALIMENTAZIONE FOR MCRE_OWN.PKG_MCREI_ALIMENTAZIONE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_ALIMENTAZIONE TO MCRE_USR;

