CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_FUNZIONI_MASTER AS
/******************************************************************************
   NAME:       PKG_MCRE0_CONVERSIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Andrea Bartolomei  Created this package.
******************************************************************************/


    /*FUNCTION FND_MCRE0_master_ABI_ELABORATI(seq IN NUMBER, p_file IN VARCHAR2) RETURN NUMBER IS

    NUM NUMBER;

    BEGIN

    RETURN NUM;

    END;*/

FUNCTION  FND_MCRE0_master(seq IN NUMBER, p_file IN VARCHAR2) RETURN NUMBER IS

        c_master CONSTANT VARCHAR2(50) := 'FND_MCRE0_master';

        v_stato_ko_caricamento T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_stato_caricato T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        v_work_dir T_MCRE0_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        c_nome CONSTANT VARCHAR2(50) := c_package || '.' || c_master;

        v_result NUMBER := 1;

        v_cur PKG_MCRE0_UTILS.cur_func_type;

        v_rec PKG_MCRE0_UTILS.rec_func_type;

        v_cod_file T_MCRE0_WRK_ACQUISIZIONE.COD_FILE%TYPE;

        v_tms_file T_MCRE0_WRK_ACQUISIZIONE.TMS_FILE%TYPE;

        v_periodo T_MCRE0_WRK_ACQUISIZIONE.PERIODO_RIFERIMENTO%TYPE;

        --v_num_record T_MCRE0_WRK_LOG_PROCESSI.NUM_RECORD%TYPE;

        --v_esito T_MCRE0_WRK_LOG_PROCESSI.ESITO%TYPE := '-> NEGATIVO <-';

        v_risultato VARCHAR2(255) := 'ERRORE';

        v_stato_acq T_MCRE0_WRK_ACQUISIZIONE.STATO%TYPE := v_stato_ko_caricamento;

        --v_inizio_elaborazione T_MCRE0_WRK_LOG_PROCESSI.INIZIO_ELABORAZIONE%TYPE;

        --v_fine_elaborazione T_MCRE0_WRK_LOG_PROCESSI.FINE_ELABORAZIONE%TYPE;

        v_cod_processo T_MCRE0_WRK_ANAGRAFICA.COD_PROCESSO%TYPE;

        v_slave_par f_slave_par_type;


    BEGIN

        SELECT VALORE_COSTANTE INTO v_stato_ko_caricamento FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_KO_CARICAMENTO';

        SELECT VALORE_COSTANTE INTO v_stato_caricato FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_CARICATO';

        SELECT VALORE_COSTANTE INTO v_work_dir FROM T_MCRE0_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'WORK_DIRECTORY';

        v_slave_par := PKG_MCRE0_UTILS.FND_MCRE0_get_slave_param(seq,p_file);

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(v_slave_par.SEQ_FLUSSO,c_nome,'INIZIO ','''' || p_file || '''');

        --v_inizio_elaborazione := SYSDATE;

        SELECT COD_FILE, TMS_FILE, PERIODO_RIFERIMENTO
        INTO v_cod_file, v_tms_file, v_periodo
        FROM T_MCRE0_WRK_ACQUISIZIONE
        WHERE NOME_FILE = p_file;
        DBMS_OUTPUT.PUT_LINE('v_cod_file: ' || v_cod_file || ' v_tms_file: ' || v_tms_file || ' v_periodo: '|| v_periodo);

        SELECT COD_PROCESSO INTO v_cod_processo
        FROM T_MCRE0_WRK_ANAGRAFICA
        WHERE COD_FILE = v_cod_file AND
              v_periodo BETWEEN DATA_INIZIO_VALIDITA AND DATA_FINE_VALIDITA;
              DBMS_OUTPUT.PUT_LINE('v_cod_processo: ' || v_cod_processo);

        IF(v_slave_par.TAB_TRG IS NULL) THEN

            v_result := 0;
             DBMS_OUTPUT.PUT_LINE('Variabili inizializzate - v_slave_par.TAB_TRG IS NULL');

        ELSE

            IF(PKG_MCRE0_UTILS.FND_MCRE0_alterTable(seq,v_slave_par.TAB_EXT,v_work_dir,p_file)) THEN

               DBMS_OUTPUT.PUT_LINE('FND_MCRE0_esegui_master: inizializzo GET_CUR_FND_SLV');

                v_cur := PKG_MCRE0_UTILS.FND_MCRE0_GET_CUR_FND_SLV(v_slave_par.SEQ_FLUSSO,p_file,v_slave_par.TAB_EXT);

                FETCH v_cur into v_rec;


                DBMS_OUTPUT.PUT_LINE('FND_MCRE0_esegui_master: GET_CUR_FND_SLV inizializzato');

            ELSE

                v_result := 0;

            END IF;

        END IF;

        WHILE(v_result = 1 AND v_cur%FOUND) LOOP

             DBMS_OUTPUT.PUT_LINE('FND_MCRE0_esegui_master - ESEGUI: PKG_MCRE0_FUNZIONI_SLAVE.'|| v_rec.FUNZIONE_SLAVE);

            v_result := PKG_MCRE0_UTILS.FND_MCRE0_ESEGUI_SLAVE(v_slave_par.SEQ_FLUSSO,v_rec.FUNZIONE_SLAVE,v_slave_par);
            DBMS_OUTPUT.PUT_LINE('FND_MCRE0_esegui_master:'|| v_rec.FUNZIONE_SLAVE || ' eseguita');
            FETCH v_cur into v_rec;

        END LOOP;

        CLOSE v_cur;

          IF (v_result = 1) THEN

            --v_esito := 'POSITIVO';

            v_risultato := 'OK';

            v_stato_acq := v_stato_caricato;

            --DBMS_OUTPUT.PUT_LINE('ESITO '||v_esito);

        END IF;

        PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(v_slave_par.SEQ_FLUSSO,c_nome,v_risultato,'''' || p_file || '''');

        --v_fine_elaborazione := SYSDATE;


        UPDATE T_MCRE0_WRK_ACQUISIZIONE
        SET STATO = v_stato_acq
        WHERE NOME_FILE = p_file;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Aggiornato stato acquisizione con '||v_stato_acq);

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_esegui_master');

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(v_slave_par.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));


            UPDATE T_MCRE0_WRK_ACQUISIZIONE
            SET STATO = v_stato_ko_caricamento
            WHERE NOME_FILE = p_file;

            COMMIT;

            DBMS_OUTPUT.PUT_LINE('Aggiornato stato acquisizione con '|| v_stato_acq);

            BEGIN

                IF(v_cur%ISOPEN) THEN

                    CLOSE v_cur;

                END IF;

            EXCEPTION

                WHEN OTHERS THEN

                DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_esegui_master - CHIUSURA CURSORE');

                    PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(v_slave_par.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            END;

            RETURN -1;

    END  FND_MCRE0_master;



END PKG_MCRE0_FUNZIONI_MASTER;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_FUNZIONI_MASTER FOR MCRE_OWN.PKG_MCRE0_FUNZIONI_MASTER;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_FUNZIONI_MASTER FOR MCRE_OWN.PKG_MCRE0_FUNZIONI_MASTER;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_FUNZIONI_MASTER TO MCRE_USR;

