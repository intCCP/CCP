CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_CHECK_CONTROLLI AS

   /******************************************************************************
      NAME:       PKG_MCRE0_CONTROLLI
      PURPOSE:    Implementazione controlli automatici

      REVISIONS:
      Ver        Date        Author           Description
      --------  ----------  ---------------  ------------------------------------
      1.0       23/11/2012  Luca Ferretti   Created this package.
      1.1       28/11/2012  Luca Ferretti   Aggiunto calcolo media aggiornato.
      1.2       28/11/2012  Luca Ferretti   Aggiunta procedura CONTROLLO_POS_MACROSTATO
      1.3       29/11/2012  Luca Ferretti   Aggiunta procedura CONTROLLO_POS_STATO
      1.4       05/12/2012  Luca Ferretti   Aggiunto calcolo per controlli singoli
      1.5       10/12/2012  Luca Ferretti   Gestione caso in cui non arrivi un'informazione (ABI, COMPARTO, etc). Si setta -1 in fase di pulizia
   ******************************************************************************/

  v_primo_lotto     number := 1;

  PROCEDURE CONTROLLO_POS_ISTITUTO (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2);
  PROCEDURE CONTROLLO_POS_MACROSTATO (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2);
  PROCEDURE CONTROLLO_POS_STATO (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2);
  PROCEDURE CONTROLLO_POS_PROCESSO (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2);
  PROCEDURE CONTROLLO_POS_COMPARTO (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2);
  PROCEDURE CONTROLLO_POS_EXACT (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2);
  PROCEDURE CONTROLLO_POS_ALERT (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2);
  PROCEDURE CONTROLLO_LOG_ETL (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2);
  PROCEDURE CONTROLLO_UTENTE (P_PID IN NUMBER, P_COD_CHECK IN VARCHAR2, P_ID_DPER DATE, P_RET_VALUE OUT NUMBER, P_RESULT OUT VARCHAR2, P_NOTES OUT VARCHAR2, P_OK VARCHAR2, P_KO VARCHAR2);




END PKG_MCRE0_CHECK_CONTROLLI;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CHECK_CONTROLLI FOR MCRE_OWN.PKG_MCRE0_CHECK_CONTROLLI;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CHECK_CONTROLLI FOR MCRE_OWN.PKG_MCRE0_CHECK_CONTROLLI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CHECK_CONTROLLI TO MCRE_USR;
