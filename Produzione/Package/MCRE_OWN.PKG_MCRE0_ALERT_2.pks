CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_ALERT_2 AS
/******************************************************************************
   NAME:     PKG_MCRE0_ALERT
   PURPOSE: Gestione alert ed evidenze

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        13/10/2010  Galli         Valeria      Created this package.
   1.1        19/11/2010  Galli         Valeria      Tabella CL_STATI cambiata in APP_STATI.
   2.0        02/12/2010  Galli         Valeria      Congelato.
   2.1        11/01/2011                M.Murro      resa autonoma la sessione per i commit..
   2.2        25/01/2011                M.Murro      spostato il commit sulla VerificaAlert
   2.3        08/02/2011  Galli         Valeria      colore indipendente da dta_ins
   2.4        06/04/2011  Galli         Valeria      filtri solo per pos flg_outsourcing=Y e flg_target=Y
   2.5        10/05/2011  Galli         Valeria      Sistemata chiamata per SNDG (per allinea stato)
   2.6        23/05/2011  Galli         Valeria      Elenco posizioni preso da UPD_FIELD
   2.7        26/05/2011  GAlli         Valeria      Nuova gestione LOG
   2.8        14/06/2011  GAlli         Valeria      distinct in qry spegnimento
   3.0        03/08/2011                M.Murro      Tuning: upd_fields
   3.1        17/10/2011  L.Ferretti    M.Murro      Funzione chiamata alert a blocchi (e clean alert)
   3.2                05/12/2011  Guzzi         Alberto      pkg2
******************************************************************************/


  ok number := 1;
  ko number := 0;
  
  -- Procedura per insert tappi su alert
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   --no COMMIT
  FUNCTION FNC_INSERT_ALERT_TAPPI(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  )RETURN NUMBER;


  -- Procedura per insert/update alert accesi
  -- INPUT :
  --    cod_abi
  --    cod_ndg
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_verifica_alert_accesi(
    p_cod_abi   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    p_cod_sndg  T_MCRE0_APP_ALL_DATA.COD_SNDG%type,
    P_ID_UTENTE T_MCRE0_APP_UTENTI.ID_UTENTE%TYPE,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  )
  RETURN NUMBER;

  -- Procedura per delete alert spenti
  -- INPUT :
  --    cod_abi
  --    cod_ndg
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_verifica_alert_spenti(
    p_cod_abi   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    p_cod_sndg  T_MCRE0_APP_ALL_DATA.COD_SNDG%type,
    P_ID_UTENTE T_MCRE0_APP_UTENTI.ID_UTENTE%TYPE,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  )
  RETURN NUMBER;

  -- Procedura per insert/update alert accesi
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION FNC_VERIFICA_ALERT(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  )RETURN NUMBER;

  -- Procedura per insert/update alert accesi
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   --COMMIT
  
  FUNCTION FNC_VERIFICA_ALERT_BLOCCO(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
    P_COD_BLOCCO T_MCRE0_APP_ALERT.COD_BLOCCO%TYPE
  )RETURN NUMBER;
  -- Procedura per insert/update alert accesi
  -- INPUT : 
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori   --COMMIT
  FUNCTION FNC_VERIFICA_ALERT_ID (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE default null,
    P_ID_ALERT T_MCRE0_APP_ALERT.ID_ALERT%TYPE DEFAULT NULL
  )RETURN NUMBER;

-- Procedura per insert/update alert accesi
  -- INPUT :
  --    cod_abi
  --    cod_ndg
  --    cod_sndg
  --    id_utente
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION FNC_VERIFICA_ALERT_NDG(
    p_cod_abi   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    p_cod_sndg  T_MCRE0_APP_ALL_DATA.COD_SNDG%type,
    P_ID_UTENTE T_MCRE0_APP_UTENTI.ID_UTENTE%TYPE,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE default null,
    P_ID_ALERT T_MCRE0_APP_ALERT.ID_ALERT%TYPE DEFAULT NULL
  )
  RETURN NUMBER;

  -- Procedura per insert/update alert accesi
  -- INPUT :
  --    p_cod_abi
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION FNC_VERIFICA_ALERT_ABI(
    P_COD_ABI   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%TYPE,
    p_id_utente T_MCRE0_APP_UTENTI.ID_UTENTE%type,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE DEFAULT NULL,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  )
  RETURN NUMBER;

  -- Procedura per insert/update alert accesi
  -- INPUT :
  --    p_cod_sndg
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION FNC_VERIFICA_ALERT_SNDG(
    P_COD_SNDG  T_MCRE0_APP_ALL_DATA.COD_SNDG%TYPE,
    P_ID_UTENTE T_MCRE0_APP_UTENTI.ID_UTENTE%TYPE,
    P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE DEFAULT NULL,
    p_id_alert T_MCRE0_APP_ALERT.id_alert%type default null
  )
  RETURN NUMBER ;

  -- Procedura per pulizia posizioni con tutti gli alert spenti
  -- INPUT :
  --
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_clean_alert(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  )RETURN NUMBER;
--  
--  FUNCTION fnc_clean_alert_blocco(
--    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
--    P_COD_BLOCCO T_MCRE0_APP_ALERT.COD_BLOCCO%TYPE
--  )RETURN NUMBER;


END PKG_MCRE0_ALERT_2;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ALERT_2 FOR MCRE_OWN.PKG_MCRE0_ALERT_2;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ALERT_2 FOR MCRE_OWN.PKG_MCRE0_ALERT_2;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ALERT_2 TO MCRE_USR;

