CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_ALERT_NEW AS
/******************************************************************************
   NAME:     PKG_MCRE0_ALERT
   PURPOSE: Gestione alert ed evidenze

   REVISIONS:
       Ver        Date        Author             Description
   ---------  ----------    -----------------  ------------------------------------
   1.0        22/10/2012  Galli Valeria      Created this package.
   2.0        05/11/2012  Galli Valeria      Calcolo per gruppi.
   2.1       07/11/2012  Galli Valeria      SOLO SYSTEM! - merge su alert_pos vera!
******************************************************************************/

  c_package  CONSTANT VARCHAR2(50) := 'PKG_MCRE0_ALERT_NEW';
  ok number := 1;
  ko number := 0;

FUNCTION fnc_verifica_alert_accesi(
    p_cod_abi_cartolarizzato   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    P_COD_SNDG  T_MCRE0_APP_ALL_DATA.COD_SNDG%TYPE,
    P_ID_UTENTE T_MCRE0_APP_UTENTI.ID_UTENTE%TYPE,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )
  RETURN NUMBER;

   FUNCTION fnc_batch_alert_accesi(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )
  RETURN NUMBER;

  FUNCTION fnc_batch_trunc_pos_tmp(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER;

  FUNCTION fnc_batch_load_alert_pos(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  ) RETURN NUMBER;

  FUNCTION fnc_batch_alert_gruppo_1(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER;

  FUNCTION fnc_batch_alert_gruppo_2(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER;

  FUNCTION fnc_batch_alert_gruppo_3(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER;

  FUNCTION fnc_batch_alert_gruppo_4(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER;

  FUNCTION AGGIORNA_SCHEDA_ANAG_SCPC2(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER ;

  FUNCTION AGGIORNA_CR_NEW(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  ) RETURN NUMBER;

END PKG_MCRE0_ALERT_NEW;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ALERT_NEW FOR MCRE_OWN.PKG_MCRE0_ALERT_NEW;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ALERT_NEW FOR MCRE_OWN.PKG_MCRE0_ALERT_NEW;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ALERT_NEW TO MCRE_USR;

