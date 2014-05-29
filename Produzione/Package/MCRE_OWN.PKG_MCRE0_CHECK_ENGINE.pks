CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_CHECK_ENGINE AS

/******************************************************************************
   NAME:       PKG_MCRE0_CHECK_ENGINE
   PURPOSE:    Engine controlli automatici

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        22/11/2012  A.Pilloni        Created this package.
   2.0        04/12/2012  A.Pilloni        Change request.
   2.1        13/02/2013  A.Pilloni        Funzionalitą controllo allineamento alert.
   2.2        15/02/2013  A.Pilloni        Funzionalitą esecuzione singolo controllo.
   2.3        25/02/2013  A.Pilloni        Funzionalitą esecuzione controllo per tipologia di controllo.
   2.4        26/02/2013  A.Pilloni        Funzionalitą esecuzione controllo di test.
******************************************************************************/

  c_package        CONSTANT VARCHAR2(50) := 'PKG_MCRE0_CHECK_ENGINE';

  c_result_ok      CONSTANT VARCHAR2(2)  := 'OK';
  c_result_warning CONSTANT VARCHAR2(2)  := 'WA';
  c_result_ko      CONSTANT VARCHAR2(2)  := 'KO';

  c_log_debug      CONSTANT NUMBER := 3;
  c_log_warning    CONSTANT NUMBER := 2;
  c_log_error      CONSTANT NUMBER := 1;

  FUNCTION START_PROCESS (P_DOMAIN T_MCRE0_CHECK_ENGINE_PROCESS.DOMAIN%TYPE) RETURN NUMBER;

  FUNCTION END_PROCESS (P_PID T_MCRE0_CHECK_ENGINE_PROCESS.ID%TYPE) RETURN NUMBER;

  FUNCTION GET_EXP_VALUE_THRESHOLD (P_COD_CHECK T_MCRE0_CHECK_ENGINE_THRESHOLD.COD_CHECK%TYPE, P_COD_THRESHOLD T_MCRE0_CHECK_ENGINE_THRESHOLD.COD_THRESHOLD%TYPE, P_VALUE NUMBER DEFAULT NULL) RETURN NUMBER;

  PROCEDURE WRITE_LOG (P_PID T_MCRE0_CHECK_ENGINE_LOG.PID%TYPE, P_NAME_PROCEDURE T_MCRE0_CHECK_ENGINE_LOG.NAME_PROCEDURE%TYPE, P_LEVEL_LOG T_MCRE0_CHECK_ENGINE_LOG.LEVEL_LOG%TYPE, P_MESSAGE T_MCRE0_CHECK_ENGINE_LOG.MESSAGE%TYPE, P_SQL_CODE T_MCRE0_CHECK_ENGINE_LOG.SQL_CODE%TYPE, P_SQL_MESSAGE T_MCRE0_CHECK_ENGINE_LOG.SQL_MESSAGE%TYPE);

  PROCEDURE WRITE_RESULT (P_PID T_MCRE0_CHECK_ENGINE_RESULT.PID%TYPE, P_DOMAIN T_MCRE0_CHECK_ENGINE_RESULT.DOMAIN%TYPE, P_COD_CHECK T_MCRE0_CHECK_ENGINE_RESULT.COD_CHECK%TYPE, P_ID_DPER T_MCRE0_CHECK_ENGINE_RESULT.ID_DPER%TYPE, P_RET_VALUE T_MCRE0_CHECK_ENGINE_RESULT.RET_VALUE%TYPE, P_RESULT T_MCRE0_CHECK_ENGINE_RESULT.RESULT%TYPE, P_NOTES T_MCRE0_CHECK_ENGINE_RESULT.NOTES%TYPE, P_MOD_WRT_RES T_MCRE0_CHECK_ENGINE_WORK.MOD_WRT_RES%TYPE);

  PROCEDURE MASTER_CHECK (P_PID T_MCRE0_CHECK_ENGINE_PROCESS.ID%TYPE, P_DOMAIN T_MCRE0_CHECK_ENGINE_DOMAIN.DOMAIN%TYPE, P_ID_DPER T_MCRE0_CHECK_ENGINE_RESULT.ID_DPER%TYPE, P_COD_CHECK T_MCRE0_CHECK_ENGINE_WORK.COD_CHECK%TYPE, P_TYPE_CHECK T_MCRE0_CHECK_ENGINE_WORK.TYPE_CHECK%TYPE, P_MOD_WRT_RES T_MCRE0_CHECK_ENGINE_WORK.MOD_WRT_RES%TYPE);

  PROCEDURE START_CHECK (P_DOMAIN T_MCRE0_CHECK_ENGINE_DOMAIN.DOMAIN%TYPE, P_ID_DPER T_MCRE0_CHECK_ENGINE_RESULT.ID_DPER%TYPE DEFAULT NULL, P_COD_CHECK T_MCRE0_CHECK_ENGINE_WORK.COD_CHECK%TYPE DEFAULT NULL, P_TYPE_CHECK T_MCRE0_CHECK_ENGINE_WORK.TYPE_CHECK%TYPE DEFAULT NULL, P_MOD_WRT_RES T_MCRE0_CHECK_ENGINE_WORK.MOD_WRT_RES%TYPE DEFAULT NULL);

END PKG_MCRE0_CHECK_ENGINE;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CHECK_ENGINE FOR MCRE_OWN.PKG_MCRE0_CHECK_ENGINE;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CHECK_ENGINE FOR MCRE_OWN.PKG_MCRE0_CHECK_ENGINE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CHECK_ENGINE TO MCRE_USR;

