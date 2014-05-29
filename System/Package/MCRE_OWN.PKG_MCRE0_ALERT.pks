CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_ALERT AS
/******************************************************************************
   NAME:     PKG_MCRE0_ALERT
   PURPOSE: Gestione alert ed evidenze

   REVISIONS:
       Ver        Date        Author             Description
   ---------  ----------    -----------------  ------------------------------------
   1.0        22/10/2012  Galli Valeria      Created this package.
   2.0        05/11/2012  Galli Valeria      Calcolo per gruppi.
   2.1       07/11/2012  Galli Valeria      SOLO SYSTEM! - merge su alert_pos vera!
   2.2       19/11/2012  Galli Valeria      Tolto refresh MV
   2.3       05/12/2012  Michele Ceru'      Agiunto alert 45
   2.4      09/01/2013  Galli Valeria       Queue
   2.5      10/01/2013    Michele Ceru'     Commentati alert 22,23 e 24
   2.6      22/01/2013    Michele Ceru'     Scommentati alert 22 e 23, commentato alert 45
   3.0      22/05/2013    M.Murro           Aggiunta chiamata alert mcrei se utente valorizzato
******************************************************************************/

  c_package  CONSTANT VARCHAR2(50) := 'PKG_MCRE0_ALERT';
  ok number := 1;
  ko number := 0;

FUNCTION fnc_verifica_alert_accesi(
    p_cod_abi_cartolarizzato   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    P_COD_SNDG  T_MCRE0_APP_ALL_DATA.COD_SNDG%TYPE,
    P_ID_UTENTE T_MCRE0_APP_UTENTI.ID_UTENTE%TYPE,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER;

   FUNCTION fnc_batch_alert_accesi(
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER;

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

  FUNCTION FNC_VERIFICA_ALERT_NDG(
    p_cod_abi   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    p_cod_sndg  T_MCRE0_APP_ALL_DATA.COD_SNDG%type,
    P_ID_UTENTE T_MCRE0_APP_UTENTI.ID_UTENTE%TYPE,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  ) RETURN NUMBER;

  FUNCTION FNC_VERIFICA_ALERT_SNDG(
    P_COD_SNDG  T_MCRE0_APP_ALL_DATA.COD_SNDG%TYPE,
    p_id_utente T_MCRE0_APP_UTENTI.ID_UTENTE%type,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE DEFAULT NULL,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  ) RETURN NUMBER;

  FUNCTION fnc_verifica_alert_id(
    p_id_alert   T_MCRE0_APP_alert.id_alert%type,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null
  )RETURN NUMBER;

END PKG_MCRE0_ALERT;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ALERT FOR MCRE_OWN.PKG_MCRE0_ALERT;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ALERT FOR MCRE_OWN.PKG_MCRE0_ALERT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ALERT TO MCRE_USR;

