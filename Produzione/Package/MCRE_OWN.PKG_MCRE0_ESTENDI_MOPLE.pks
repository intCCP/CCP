CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE AS
/******************************************************************************
   NAME:       PKG_MCRE0_STORICIZZA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/10/2010   M.Murro.          Created this package.
   1.1        19/11/2010  Galli Valeria      Tabella CL_STATI cambiata in APP_STATI.
   1.2        24/11/2010  Marco Murro        gestito filtro per IDDPER per gli update
   1.3        25/11/2010  Galli Valeria      Aggiunto calcolo processo PRE
   1.4        13/12/2010  Marco Murro        Aggiunto gestione Ramo (al posto di comparto_host)
   1.5        17/12/2010  Galli Valeria      Tolto controllo comparti + data_decorrenza_stato_precedente
   2.0        11/01/2011  Marco  Murro       Aggiunta gestione MOPLE_PK_TODAY
   2.1        31/03/2011  Marco  Murro       Varato calcolo decorrenza macrostato su stati uscita
   2.2        27/04/2011  Marco  Murro       Varato calcolo decorrenza macrostato su SO
   2.3        11/05/2011  Marco  Murro       Varato calcolo decorrenza macrostato su SO (= dta_dec.Stato)
   2.4        24/05/2011  Marco  Murro       Gestione GB
   2.5        06/06/2011  Marco  Murro       Fix Gestione GB
   3.0        18/07/2011  Marco Murre        Nuove strutture per tuning
   3.1        30/08/2011  Marco Murre        commit intermedio in set_today_flag
   3.2        19/10/2011  Paola Goitre       noparallel mople sui cursori e cambiata fnc_set_today_flg
******************************************************************************/

  c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_ESTENDI_MOPLE';
  c_file_mople CONSTANT VARCHAR2(45) := 'MOPLE';
  ok number := 1;
  ko number := 0;

  cib      MCRE_OWN.T_MCRE0_APP_COMPARTI.COD_COMPARTO%TYPE := '000001';
  bdt      MCRE_OWN.T_MCRE0_APP_COMPARTI.COD_COMPARTO%TYPE := '000002';

  --v2.4: setta stato a 2 su GB gestione se classificato da mople
  FUNCTION UPD_GB_STATUS RETURN NUMBER;

  --v3.0 sostituisce la pk_today!
  FUNCTION FNC_SET_TODAY_FLG RETURN NUMBER;

  FUNCTION SET_COMPARTO_HOST RETURN NUMBER;

  -- Procedura per update cod_processo_precedente in MOPLE
  -- INPUT :
  --
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_gestione_processo_pre
  RETURN NUMBER;

  -- Procedura per update cod_processo_precedente in MOPLE
  -- INPUT :
  --    p_cod_abi
  --    p_cod_ndg
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_gestione_processo_pre_ndg(
    p_cod_abi   T_MCRE0_APP_MOPLE.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_MOPLE.COD_NDG%type
  )
  RETURN NUMBER;

  -- Procedura per update cod_macrostato, dta_decorrenza_macrostato in MOPLE
  -- INPUT :
  --
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_gestione_macrostato
  RETURN NUMBER ;

--v3.0 --spostata in gestione_all_data!
  -- Procedura per update cod_macrostato, dta_decorrenza_macrostato in MOPLE
  -- dopo cambio stato.
  -- INPUT :
  --    p_cod_abi
  --    p_cod_ndg
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
--  FUNCTION fnc_gestione_macrost_cambiost(
--    p_cod_abi   T_MCRE0_APP_MOPLE.COD_ABI_CARTOLARIZZATO%type,
--    p_cod_ndg   T_MCRE0_APP_MOPLE.COD_NDG%type
--  )
--  RETURN NUMBER;

  -- Procedura per update dta_stato_precedente in MOPLE
  -- INPUT :
  --
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_gestione_dta_stato_pre
  RETURN NUMBER;

  -- Procedura per update dta_stato_precedente in MOPLE
  -- INPUT :
  --    p_cod_abi
  --    p_cod_ndg
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_gestione_dta_stato_pre_ndg(
    p_cod_abi   T_MCRE0_APP_MOPLE.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_MOPLE.COD_NDG%type
  )
  RETURN NUMBER;

  -- Procedura per popolare la tabella delle chiavi mople aggiornate giornalmente
  -- INPUT :
  --
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION fnc_fill_mople_pk_today
  RETURN NUMBER;

END PKG_MCRE0_ESTENDI_MOPLE;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ESTENDI_MOPLE FOR MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ESTENDI_MOPLE FOR MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE;


GRANT EXECUTE ON MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE TO MCRE_USR WITH GRANT OPTION;
GRANT DEBUG ON MCRE_OWN.PKG_MCRE0_ESTENDI_MOPLE TO MCRE_USR;

