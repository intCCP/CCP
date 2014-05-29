CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCREs_FUNZIONI_MASTER AS
/******************************************************************************
   NAME:       PKG_MCRE0_CONVERSIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------      -----------------  ------------------------------------
   1.0      01/07/2011  V.Galli       Created this package.
   2.0      10/02/2012  V.Galli       Aggiornamento stato acquisizione in  nuova tabella T_MCRES_WRK_last_ACQUISIZIONE
   2.1      12/03/2012   V.Galli      Aggiornamento fine secondo livello T_MCRES_WRK_last_ACQUISIZIONE
******************************************************************************/

FUNCTION  FNC_MCRES_master(v_seq IN NUMBER, p_file IN VARCHAR2) RETURN NUMBER IS

        c_master CONSTANT VARCHAR2(50) := 'FND_MCRES_master';

        v_stato_ko_caricamento T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_stato_caricato T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;
        v_work_dir T_MCRES_WRK_CONFIGURAZIONE.VALORE_COSTANTE%TYPE;

        c_nome CONSTANT VARCHAR2(50) := c_package || '.' || c_master;

        v_result NUMBER := 1;

        v_cur PKG_MCRES_UTILS.cur_func_type;
        v_rec PKG_MCRES_UTILS.rec_func_type;

        v_cod_file T_MCRES_WRK_ACQUISIZIONE.COD_FILE%TYPE;
        V_TMS_FILE T_MCRES_WRK_ACQUISIZIONE.DTA_INIZIO%TYPE;
        V_PERIODO T_MCRES_WRK_ACQUISIZIONE.ID_DPER%TYPE;

        v_risultato VARCHAR2(255) := 'ERRORE';

        V_STATO_ACQ T_MCRES_WRK_ACQUISIZIONE.COD_STATO%TYPE := V_STATO_KO_CARICAMENTO;

        V_SLAVE_PAR F_SLAVE_PAR_TYPE;

    Begin
        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'inizio '||c_nome);

        SELECT VALORE_COSTANTE INTO v_stato_ko_caricamento FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_KO_CARICAMENTO';

        SELECT VALORE_COSTANTE INTO v_stato_caricato FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'STATO_CARICATO';

        SELECT VALORE_COSTANTE INTO v_work_dir FROM T_MCRES_WRK_CONFIGURAZIONE WHERE NOME_COSTANTE = 'WORK_DIRECTORY';

        v_slave_par := PKG_MCRES_UTILS.FNC_MCRES_get_slave_param(v_seq,p_file);

        SELECT COD_FILE, DTA_INIZIO, ID_DPER
        INTO v_cod_file, v_tms_file, v_periodo
        FROM T_MCRES_WRK_ACQUISIZIONE
        WHERE ID_FLUSSO = V_SEQ;

        v_slave_par.periodo := v_periodo;

        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'v_cod_file: ' || v_cod_file || ' v_tms_file: ' || v_tms_file || ' v_periodo: '|| v_periodo );

        v_cur := PKG_MCRES_UTILS.FNC_MCRES_GET_CUR_FND_SLV(v_slave_par.SEQ_FLUSSO,p_file,v_slave_par.TAB_EXT);

        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'Prima di fetchare il cursore..');

        FETCH v_cur into v_rec;
            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'FND_MCRES_esegui_master: GET_CUR_FND_SLV inizializzato: '|| v_rec.FUNZIONE_SLAVE||', '||v_rec.ordine_alimentazione);


        WHILE(v_result = 1 AND v_cur%FOUND) LOOP

            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'FND_MCRES_esegui_master - ESEGUI: PKG_MCRES_FUNZIONI_SLAVE.'|| v_rec.FUNZIONE_SLAVE );
            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'FND_MCRES_esegui_master - PARAM_TYPE: '|| v_slave_par.seq_flusso||' - '||v_slave_par.nome_file||' - '||v_slave_par.periodo||' - '||v_slave_par.tab_ext||' - '||v_slave_par.tab_trg||' - '||v_slave_par.ordine_alimentazione );
            v_result := PKG_MCRES_UTILS.FNC_MCRES_ESEGUI_SLAVE(v_slave_par.SEQ_FLUSSO,v_rec.FUNZIONE_SLAVE, v_rec.ordine_alimentazione, v_slave_par);
            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'FND_MCRES_esegui_master:'|| v_rec.FUNZIONE_SLAVE || ' eseguita');

            FETCH v_cur into v_rec;

        END LOOP;

        CLOSE v_cur;

        IF (v_result = 1) THEN
            v_risultato := 'OK';
            v_stato_acq := v_stato_caricato;
        END IF;

        update  t_mcres_wrk_acquisizione
        set     cod_stato = v_stato_acq,
                dta_fine  = sysdate
        WHERE   id_flusso = v_seq;
        COMMIT;

        PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'Aggiornato stato acquisizione con '||v_stato_acq);

        BEGIN
          update T_MCRES_WRK_LAST_ACQUISIZIONE
          set COD_STATO = V_STATO_ACQ,
              DTA_END_SECONDO_LIVELLO = sysdate
          WHERE   ID_FLUSSO = V_SEQ;
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'Aggiornato stato in T_MCRES_wrk_last_acquisizione: '||v_stato_acq);
        end;

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_ERROR , SQLCODE, SQLERRM, null);

            update t_mcres_wrk_acquisizione
            set cod_stato = v_stato_ko_caricamento
            Where Id_Flusso = V_Seq;

            COMMIT;
            PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_ERROR , SQLCODE, SQLERRM, 'Aggiornato stato acquisizione con '|| v_stato_ko_caricamento);

             BEGIN
                UPDATE T_MCRES_wrk_last_acquisizione
                SET COD_STATO = v_stato_ko_caricamento
                WHERE   ID_FLUSSO = V_SEQ;
                COMMIT;
              EXCEPTION
                WHEN OTHERS THEN
                  PKG_MCRES_AUDIT.LOG_CARICAMENTI(V_SEQ, C_NOME, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'Aggiornato stato in T_MCRES_wrk_last_acquisizione: '||v_stato_ko_caricamento);
              end;

            BEGIN
                IF(v_cur%ISOPEN) THEN
                    CLOSE v_cur;
                END IF;

            EXCEPTION
                WHEN OTHERS THEN
                    PKG_MCRES_AUDIT.log_caricamenti(v_seq, c_nome, PKG_MCRES_AUDIT.C_ERROR ,SQLCODE, SQLERRM, 'ERRORE IN FND_MCRES_esegui_master - CHIUSURA CURSORE');

            END;

            RETURN -1;

    END  FNC_MCRES_master;


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


END PKG_MCRES_FUNZIONI_MASTER;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_FUNZIONI_MASTER FOR MCRE_OWN.PKG_MCRES_FUNZIONI_MASTER;


CREATE SYNONYM MCRE_USR.PKG_MCRES_FUNZIONI_MASTER FOR MCRE_OWN.PKG_MCRES_FUNZIONI_MASTER;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_FUNZIONI_MASTER TO MCRE_USR;

