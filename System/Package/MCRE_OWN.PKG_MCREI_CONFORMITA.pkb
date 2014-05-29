CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcrei_conformita
AS
/******************************************************************************
 NAME:       PKG_MCREI_GESTIONE_PARTIZIONI
 PURPOSE:

 REVISIONS:
 Ver        Date              Author             Description
 ---------  ----------      -----------------  ------------------------------------
 1.0      20/10/2011         E.Pellizzi         Created this package.
******************************************************************************/
   FUNCTION fnc_mcrei_verifica_conformita (p_rec IN f_slave_par_type)
      RETURN NUMBER
   IS
      c_nome   CONSTANT VARCHAR2 (50) := c_package || '.verifica_conformita';
      v_count           NUMBER;
      v_periodo         NUMBER;
      v_ext_bad         VARCHAR2 (32);
      v_ext_log         VARCHAR2 (32);
   BEGIN
      v_periodo := TO_NUMBER (TO_CHAR (p_rec.periodo, 'YYYYMMDD'));
      pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                       c_nome,
                                       pkg_mcrei_audit.c_debug,
                                       SQLCODE,
                                       SQLERRM,
                                       'BEGIN FND_MCREI_verifica_conformita '
                                      );

      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || p_rec.tab_ext
                   INTO v_count;

      pkg_mcrei_audit.log_caricamenti
                                     (p_rec.seq_flusso,
                                      c_nome,
                                      pkg_mcrei_audit.c_debug,
                                      SQLCODE,
                                      SQLERRM,
                                      'FND_MCREI_verifica_conformita ESEGUITA'
                                     );

      BEGIN
         IF (p_rec.tab_ext = 'TE_MCREI_ANAGR_GRUPPO_COINT')
         THEN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM TE_MCREI_ANAG_GR_COINTEST_BAD'
                         INTO v_count;

            IF v_count > 0
            THEN
               UPDATE t_mcrei_wrk_acquisizione
                  SET val_scarti_external = v_count
                WHERE id_flusso = p_rec.seq_flusso;

               COMMIT;
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                SQLERRM,
                                                'EXTERNAL TABLE CON SCARTI'
                                               );

            --   EXECUTE IMMEDIATE    'INSERT INTO T_MCREI_WRK_EXTERNAL_BAD SELECT '
            --                    || p_rec.seq_flusso
            --                     || ','
            --                     || v_periodo
            --                     || ', BAD FROM TE_MCREI_ANAG_GR_COINTEST_BAD';

               COMMIT;
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                SQLERRM,
                                                'SAVE BAD EXTERNAL TABLE'
                                               );

            --   EXECUTE IMMEDIATE    'INSERT INTO T_MCREI_WRK_EXTERNAL_LOG SELECT '
            --                    || p_rec.seq_flusso
            --                     || ','
            --                     || v_periodo
            --                     || ', LOG FROM
            --                  TE_MCREI_ANAG_GR_COINTEST_LOG';
            END IF;
         ELSE
            EXECUTE IMMEDIATE    'SELECT COUNT(*) FROM '
                              || p_rec.tab_ext
                              || '_BAD'
                         INTO v_count;

            IF v_count > 0
            THEN
               UPDATE t_mcrei_wrk_acquisizione
                  SET val_scarti_external = v_count
                WHERE id_flusso = p_rec.seq_flusso;

               COMMIT;
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                SQLERRM,
                                                'EXTERNAL TABLE CON SCARTI'
                                               );

            --   EXECUTE IMMEDIATE    'INSERT INTO T_MCREI_WRK_EXTERNAL_BAD SELECT '
            --                     || p_rec.seq_flusso
            --                     || ','
            --                     || v_periodo
            --                     || ', BAD FROM '
            --                     || p_rec.tab_ext
            --                     || '_BAD';

               COMMIT;
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                SQLERRM,
                                                'SAVE BAD EXTERNAL TABLE'
                                               );

            --   EXECUTE IMMEDIATE    'INSERT INTO T_MCREI_WRK_EXTERNAL_LOG SELECT '
            --                     || p_rec.seq_flusso
            --                    || ','
            --                     || v_periodo
            --                     || ', LOG FROM '
            --                     || p_rec.tab_ext
            --                     || '_LOG';

               COMMIT;
               pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                                c_nome,
                                                pkg_mcrei_audit.c_debug,
                                                SQLCODE,
                                                SQLERRM,
                                                'SAVE LOG EXTERNAL TABLE'
                                               );
            END IF;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            UPDATE t_mcrei_wrk_acquisizione
               SET val_scarti_external = 0
             WHERE id_flusso = p_rec.seq_flusso;

            COMMIT;
            pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                             c_nome,
                                             pkg_mcrei_audit.c_debug,
                                             SQLCODE,
                                             SQLERRM,
                                             'EXTERNAL TABLE SENZA SCARTI'
                                            );
            RETURN ok;
      END;

      RETURN ok;
   EXCEPTION
      WHEN OTHERS
      THEN
         pkg_mcrei_audit.log_caricamenti (p_rec.seq_flusso,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          NULL
                                         );
         RETURN ko;
   END fnc_mcrei_verifica_conformita;
END pkg_mcrei_conformita;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_CONFORMITA FOR MCRE_OWN.PKG_MCREI_CONFORMITA;


CREATE SYNONYM MCRE_USR.PKG_MCREI_CONFORMITA FOR MCRE_OWN.PKG_MCREI_CONFORMITA;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_CONFORMITA TO MCRE_USR;

