CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcrei_check_controlli
AS
/******************************************************************************
   NAME:       PKG_MCRES_CHECK_CONTROLLI
   PURPOSE:    Implementazione controlli automatici

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/12/2012  E.Pellizzi        Created this package.
******************************************************************************/
   PROCEDURE NUM_FLUSSI_GIORNALIERI (
      P_PID         IN       NUMBER,
      P_COD_CHECK   IN       VARCHAR2,
      P_ID_DPER              DATE,
      P_RET_VALUE   OUT      NUMBER,
      P_RESULT      OUT      VARCHAR2,
      P_NOTES       OUT      VARCHAR2,
      P_OK                   VARCHAR2,
      P_KO                   VARCHAR2
   );

   PROCEDURE NUM_FLUSSI_MENSILI_SISBA (
      P_PID         IN       NUMBER,
      P_COD_CHECK   IN       VARCHAR2,
      P_ID_DPER              DATE,
      P_RET_VALUE   OUT      NUMBER,
      P_RESULT      OUT      VARCHAR2,
      P_NOTES       OUT      VARCHAR2,
      P_OK                   VARCHAR2,
      P_KO                   VARCHAR2
   );

   PROCEDURE ABI_LAVORABILI (
      P_PID         IN       NUMBER,
      P_COD_CHECK   IN       VARCHAR2,
      P_ID_DPER              DATE,
      P_RET_VALUE   OUT      NUMBER,
      P_RESULT      OUT      VARCHAR2,
      P_NOTES       OUT      VARCHAR2,
      P_OK                   VARCHAR2,
      P_KO                   VARCHAR2
   );

   PROCEDURE FLUSSI_ELABORATI_ERRORE (
      P_PID         IN       NUMBER,
      P_COD_CHECK   IN       VARCHAR2,
      P_ID_DPER              DATE,
      P_RET_VALUE   OUT      NUMBER,
      P_RESULT      OUT      VARCHAR2,
      P_NOTES       OUT      VARCHAR2,
      P_OK                   VARCHAR2,
      P_KO                   VARCHAR2
   );

   PROCEDURE FLUSSI_ABI (
      P_PID         IN       NUMBER,
      P_COD_CHECK   IN       VARCHAR2,
      P_ID_DPER              DATE,
      P_RET_VALUE   OUT      NUMBER,
      P_RESULT      OUT      VARCHAR2,
      P_NOTES       OUT      VARCHAR2,
      P_OK                   VARCHAR2,
      P_KO                   VARCHAR2
   );

   PROCEDURE CONSISTENZA_DB (
      P_PID         IN       NUMBER,
      P_COD_CHECK   IN       VARCHAR2,
      P_ID_DPER              DATE,
      P_RET_VALUE   OUT      NUMBER,
      P_RESULT      OUT      VARCHAR2,
      P_NOTES       OUT      VARCHAR2,
      P_OK                   VARCHAR2,
      P_KO                   VARCHAR2,
      P_VIEW                 VARCHAR2
   );
END pkg_mcrei_check_controlli;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_CHECK_CONTROLLI FOR MCRE_OWN.PKG_MCREI_CHECK_CONTROLLI;


CREATE SYNONYM MCRE_USR.PKG_MCREI_CHECK_CONTROLLI FOR MCRE_OWN.PKG_MCREI_CHECK_CONTROLLI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_CHECK_CONTROLLI TO MCRE_USR;

