CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcrei_funzioni_master
AS
/******************************************************************************
 NAME:       PKG_MCREI_GESTIONE_PARTIZIONI
 PURPOSE:

 REVISIONS:
 Ver        Date              Author             Description
 ---------  ----------      -----------------  ------------------------------------
 1.0      20/10/2011         E.Pellizzi         Created this package.
******************************************************************************/
   FUNCTION fnc_mcrei_master (v_seq IN NUMBER, p_file IN VARCHAR2)
      RETURN NUMBER
   IS
      c_master        CONSTANT VARCHAR2 (50)            := 'FND_MCREI_master';
      v_stato_ko_caricamento   t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_stato_caricato         t_mcrei_wrk_configurazione.valore_costante%TYPE;
      v_work_dir               t_mcrei_wrk_configurazione.valore_costante%TYPE;
      c_nome          CONSTANT VARCHAR2 (50)  := c_package || '.' || c_master;
      v_result                 NUMBER                                    := 1;
      v_cur                    pkg_mcrei_utils.cur_func_type;
      v_rec                    pkg_mcrei_utils.rec_func_type;
      v_cod_file               t_mcrei_wrk_acquisizione.cod_file%TYPE;
      v_tms_file               t_mcrei_wrk_acquisizione.dta_inizio%TYPE;
      v_periodo                t_mcrei_wrk_acquisizione.id_dper%TYPE;
      v_risultato              VARCHAR2 (255)                     := 'ERRORE';
      v_stato_acq              t_mcrei_wrk_acquisizione.cod_stato%TYPE
                                                    := v_stato_ko_caricamento;
      v_slave_par              f_slave_par_type;
   BEGIN
      pkg_mcrei_audit.log_caricamenti (v_seq,
                                       c_nome,
                                       pkg_mcrei_audit.c_debug,
                                       SQLCODE,
                                       SQLERRM,
                                       'inizio ' || c_nome
                                      );

      SELECT valore_costante
        INTO v_stato_ko_caricamento
        FROM t_mcrei_wrk_configurazione
       WHERE nome_costante = 'STATO_KO_CARICAMENTO';

      SELECT valore_costante
        INTO v_stato_caricato
        FROM t_mcrei_wrk_configurazione
       WHERE nome_costante = 'STATO_CARICATO';

      SELECT valore_costante
        INTO v_work_dir
        FROM t_mcrei_wrk_configurazione
       WHERE nome_costante = 'WORK_DIRECTORY';

      v_slave_par := pkg_mcrei_utils.fnc_mcrei_get_slave_param (v_seq, p_file);

      SELECT cod_file, dta_inizio, id_dper
        INTO v_cod_file, v_tms_file, v_periodo
        FROM t_mcrei_wrk_acquisizione
       WHERE id_flusso = v_seq;

      v_slave_par.periodo := v_periodo;
      pkg_mcrei_audit.log_caricamenti (v_seq,
                                       c_nome,
                                       pkg_mcrei_audit.c_debug,
                                       SQLCODE,
                                       SQLERRM,
                                          'v_cod_file: '
                                       || v_cod_file
                                       || ' v_tms_file: '
                                       || v_tms_file
                                       || ' v_periodo: '
                                       || v_periodo
                                      );
      v_cur :=
         pkg_mcrei_utils.fnc_mcrei_get_cur_fnd_slv (v_slave_par.seq_flusso,
                                                    p_file,
                                                    v_slave_par.tab_ext
                                                   );
      pkg_mcrei_audit.log_caricamenti (v_seq,
                                       c_nome,
                                       pkg_mcrei_audit.c_debug,
                                       SQLCODE,
                                       SQLERRM,
                                       'Prima di fetchare il cursore..'
                                      );

      FETCH v_cur
       INTO v_rec;

      pkg_mcrei_audit.log_caricamenti
                (v_seq,
                 c_nome,
                 pkg_mcrei_audit.c_debug,
                 SQLCODE,
                 SQLERRM,
                    'FND_MCREI_esegui_master: GET_CUR_FND_SLV inizializzato: '
                 || v_rec.funzione_slave
                 || ', '
                 || v_rec.ordine_alimentazione
                );

      WHILE (v_result = 1 AND v_cur%FOUND)
      LOOP
         pkg_mcrei_audit.log_caricamenti
            (v_seq,
             c_nome,
             pkg_mcrei_audit.c_debug,
             SQLCODE,
             SQLERRM,
                'FND_MCREI_esegui_master - ESEGUI: PKG_MCREI_FUNZIONI_SLAVE.'
             || v_rec.funzione_slave
            );
         pkg_mcrei_audit.log_caricamenti
                                  (v_seq,
                                   c_nome,
                                   pkg_mcrei_audit.c_debug,
                                   SQLCODE,
                                   SQLERRM,
                                      'FND_MCREI_esegui_master - PARAM_TYPE: '
                                   || v_slave_par.seq_flusso
                                   || ' - '
                                   || v_slave_par.nome_file
                                   || ' - '
                                   || v_slave_par.periodo
                                   || ' - '
                                   || v_slave_par.tab_ext
                                   || ' - '
                                   || v_slave_par.tab_trg
                                   || ' - '
                                   || v_slave_par.ordine_alimentazione
                                  );
         v_result :=
            pkg_mcrei_utils.fnc_mcrei_esegui_slave
                                                  (v_slave_par.seq_flusso,
                                                   v_rec.funzione_slave,
                                                   v_rec.ordine_alimentazione,
                                                   v_slave_par
                                                  );
         pkg_mcrei_audit.log_caricamenti (v_seq,
                                          c_nome,
                                          pkg_mcrei_audit.c_debug,
                                          SQLCODE,
                                          SQLERRM,
                                             'FND_MCREI_esegui_master:'
                                          || v_rec.funzione_slave
                                          || ' eseguita'
                                         );

         FETCH v_cur
          INTO v_rec;
      END LOOP;

      CLOSE v_cur;

      IF (v_result = 1)
      THEN
         v_risultato := 'OK';
         v_stato_acq := v_stato_caricato;
      END IF;

      UPDATE t_mcrei_wrk_acquisizione
         SET cod_stato = v_stato_acq,
             dta_fine = SYSDATE
       Where Id_Flusso = V_Seq;

      COMMIT;
      pkg_mcrei_audit.log_caricamenti (v_seq,
                                       c_nome,
                                       pkg_mcrei_audit.c_debug,
                                       SQLCODE,
                                       SQLERRM,
                                          'Aggiornato stato acquisizione con '
                                       || v_stato_acq
                                      );
      RETURN v_result;
   Exception

      WHEN OTHERS
      Then

         pkg_mcrei_audit.log_caricamenti (v_seq,
                                          c_nome,
                                          pkg_mcrei_audit.c_error,
                                          SQLCODE,
                                          SQLERRM,
                                          NULL
                                         );

         UPDATE t_mcrei_wrk_acquisizione
            SET cod_stato = v_stato_ko_caricamento
          WHERE id_flusso = v_seq;

         COMMIT;
         pkg_mcrei_audit.log_caricamenti
                                      (v_seq,
                                       c_nome,
                                       pkg_mcrei_audit.c_error,
                                       SQLCODE,
                                       SQLERRM,
                                          'Aggiornato stato acquisizione con '
                                       || v_stato_acq
                                      );

         BEGIN
            IF (v_cur%ISOPEN)
            THEN
               CLOSE v_cur;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               pkg_mcrei_audit.log_caricamenti
                      (v_seq,
                       c_nome,
                       pkg_mcrei_audit.c_error,
                       SQLCODE,
                       SQLERRM,
                       'ERRORE IN FND_MCREI_esegui_master - CHIUSURA CURSORE'
                      );
         END;

         RETURN -1;
   END fnc_mcrei_master;

END pkg_mcrei_funzioni_master;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_FUNZIONI_MASTER FOR MCRE_OWN.PKG_MCREI_FUNZIONI_MASTER;


CREATE SYNONYM MCRE_USR.PKG_MCREI_FUNZIONI_MASTER FOR MCRE_OWN.PKG_MCREI_FUNZIONI_MASTER;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_FUNZIONI_MASTER TO MCRE_USR;

