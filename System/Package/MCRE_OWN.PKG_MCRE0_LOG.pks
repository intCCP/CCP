CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_LOG AS
/******************************************************************************
   NAME:     PKG_MCRE0_LOG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        20/04/2010  Andrea Bartolomei  Created this package.
******************************************************************************/

    PROCEDURE SPO_MCRE0_log_evento_no_commit(p_id_flusso IN T_MCRE0_WRK_LOG_PROCESSI.ID_FLUSSO%TYPE,
                                   p_nome IN T_MCRE0_WRK_LOG_EVENTI.NOME_FUNZIONE%TYPE,
                                   p_esito IN T_MCRE0_WRK_LOG_EVENTI.ESITO%TYPE DEFAULT NULL,
                                   p_note IN T_MCRE0_WRK_LOG_EVENTI.NOTE%TYPE DEFAULT NULL);


    PROCEDURE SPO_MCRE0_log_evento(p_id_flusso IN T_MCRE0_WRK_LOG_PROCESSI.ID_FLUSSO%TYPE,
                         p_nome IN T_MCRE0_WRK_LOG_EVENTI.NOME_FUNZIONE%TYPE,
                         p_esito IN T_MCRE0_WRK_LOG_EVENTI.ESITO%TYPE DEFAULT NULL,
                         p_note IN T_MCRE0_WRK_LOG_EVENTI.NOTE%TYPE DEFAULT NULL);

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
                           p_fine_elaborazione IN T_MCRE0_WRK_LOG_PROCESSI.FINE_ELABORAZIONE%TYPE);

    PROCEDURE SPO_MCRE0_log_esito(seq IN NUMBER, p_nome IN VARCHAR2, p_flag IN BOOLEAN, p_note IN VARCHAR2);

END PKG_MCRE0_LOG;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_LOG FOR MCRE_OWN.PKG_MCRE0_LOG;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_LOG FOR MCRE_OWN.PKG_MCRE0_LOG;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_LOG TO MCRE_USR;

