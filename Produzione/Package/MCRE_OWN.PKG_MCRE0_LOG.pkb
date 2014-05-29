CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_LOG AS

    PROCEDURE SPO_MCRE0_log_evento_no_commit(p_id_flusso IN T_MCRE0_WRK_LOG_PROCESSI.ID_FLUSSO%TYPE,
                                   p_nome IN T_MCRE0_WRK_LOG_EVENTI.NOME_FUNZIONE%TYPE,
                                   p_esito IN T_MCRE0_WRK_LOG_EVENTI.ESITO%TYPE DEFAULT NULL,
                                   p_note IN T_MCRE0_WRK_LOG_EVENTI.NOTE%TYPE DEFAULT NULL) IS

    BEGIN

        INSERT INTO T_MCRE0_WRK_LOG_EVENTI(
            ID_FLUSSO,
            ID,
            TMS,
            NOME_FUNZIONE,
            ESITO,
            NOTE
        )VALUES(
            p_id_flusso,
            SEQ_MCRE0_LOG_EVENTI.NEXTVAL,
            SYSDATE,
            p_nome,
            p_esito,
            p_note
        );

    END;

    PROCEDURE SPO_MCRE0_log_evento(p_id_flusso IN T_MCRE0_WRK_LOG_PROCESSI.ID_FLUSSO%TYPE,
                         p_nome IN T_MCRE0_WRK_LOG_EVENTI.NOME_FUNZIONE%TYPE,
                         p_esito IN T_MCRE0_WRK_LOG_EVENTI.ESITO%TYPE DEFAULT NULL,
                         p_note IN T_MCRE0_WRK_LOG_EVENTI.NOTE%TYPE DEFAULT NULL) IS

    BEGIN

        SPO_MCRE0_log_evento_no_commit(p_id_flusso,p_nome,p_esito,p_note);

        COMMIT;

    END SPO_MCRE0_log_evento;

    PROCEDURE SPO_MCRE0_log_processo(p_id_flusso IN T_MCRE0_WRK_LOG_PROCESSI.ID_FLUSSO%TYPE,
                           p_cod_file IN T_MCRE0_WRK_LOG_PROCESSI.COD_FILE%TYPE,
                           p_tms_file IN T_MCRE0_WRK_LOG_PROCESSI.TMS_FILE%TYPE,
                           p_periodo IN T_MCRE0_WRK_LOG_PROCESSI.PERIODO%TYPE,
                           p_cod_abi IN T_MCRE0_WRK_LOG_PROCESSI.COD_ABI%TYPE,
                           p_tab_trg IN T_MCRE0_WRK_LOG_PROCESSI.TAB_TRG%TYPE,
                           p_cod_processo IN T_MCRE0_WRK_LOG_PROCESSI.COD_PROCESSO%TYPE,
                           p_esito IN T_MCRE0_WRK_LOG_PROCESSI.ESITO%TYPE,
                           p_funzione_master IN T_MCRE0_WRK_LOG_PROCESSI.FUNZIONE_MASTER%TYPE,
                           p_num_record IN T_MCRE0_WRK_LOG_PROCESSI.NUM_RECORD%TYPE,
                           p_inizio_elaborazione IN T_MCRE0_WRK_LOG_PROCESSI.INIZIO_ELABORAZIONE%TYPE,
                           p_fine_elaborazione IN T_MCRE0_WRK_LOG_PROCESSI.FINE_ELABORAZIONE%TYPE) IS

    BEGIN

        INSERT INTO T_MCRE0_WRK_LOG_PROCESSI(
            ID_FLUSSO,
            ID,
            COD_FILE,
            TMS_FILE,
            PERIODO,
            COD_ABI,
            TAB_TRG,
            COD_PROCESSO,
            ESITO,
            FUNZIONE_MASTER,
            NUM_RECORD,
            INIZIO_ELABORAZIONE,
            FINE_ELABORAZIONE
        )VALUES(
            p_id_flusso,
            SEQ_MCRE0_LOG_PROCESSI.NEXTVAL,
            p_cod_file,
            p_tms_file,
            p_periodo,
            p_cod_abi,
            p_tab_trg,
            p_cod_processo,
            p_esito,
            p_funzione_master,
            p_num_record,
            p_inizio_elaborazione,
            p_fine_elaborazione
        );

        COMMIT;

    END SPO_MCRE0_log_processo;

    PROCEDURE SPO_MCRE0_log_esito(seq IN NUMBER, p_nome IN VARCHAR2, p_flag IN BOOLEAN, p_note IN VARCHAR2) IS

    BEGIN

        IF(p_flag) THEN

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,p_nome,'OK');

        ELSE

            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,p_nome,'ERRORE','VINCOLI NON RISPETTATI: ' || p_note);

        END IF;

    END SPO_MCRE0_log_esito;

END PKG_MCRE0_LOG;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_LOG FOR MCRE_OWN.PKG_MCRE0_LOG;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_LOG FOR MCRE_OWN.PKG_MCRE0_LOG;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_LOG TO MCRE_USR;

