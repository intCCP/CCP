CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_GESTIONE_ALL_DATA" AS
/******************************************************************************
   NAME:       PKG_MCRE0_GESTIONE_ALL_DATA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        04/08/2011  Marco Murro        Created this package.
   1.1        31/08/2011  Marco Murro        Aggiunto update x Gb.
   1.2        04/11/2011  Marco Murro        Aggiunti campi di Sostituzione.
   1.3        25/10/2012  Marco Murro        Integrata gestione GB e RS in Insert
   1.4        08/11/2012  Luca Ferretti      Modifica ribaltamento file_guida con modifiche Bellani
   1.5        08/11/2012  Marco Murro        Variata pulizia cod/dta servizio
   1.51       10/01/2013  Marco Murro        Variato default sysdate su dta servizio non pi¿ PT
   2.0        25/06/2013  Marco Murro        Fix dta_servizio, cod_grup_sup_old per apertura rg
   2.1        01/07/2013  Tiziano Bernardi   Aggiunte procedure per gestione regioni
   2.2        15/07/2013  Irena Gueorguieva Aggiunte chiamate a ASSEGNA_GESTORI e SPALMA_GRUPPI in fondo a LOAD_ALL_DATA
   2.3        10/10/2013  Tiziano Bernardi   Fix gestione stato/stato_pre per RS
   2.4        10/02/2014  M.Murro   switch all_data --> all_data_old
******************************************************************************/

  c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_GESTIONE_ALL_DATA';

  ok number := 1;
  ko number := 0;

  -- Procedura per update cod_macrostato, dta_decorrenza_macrostato su ALL_DATA
  -- dopo cambio stato da portale/ws.
  -- NO COMMIT
  FUNCTION fnc_gestione_macrost_cambiost(
    p_cod_abi   T_MCRE0_APP_ALL_DATA.COD_ABI_CARTOLARIZZATO%type,
    p_cod_ndg   T_MCRE0_APP_ALL_DATA.COD_NDG%type,
    p_utente    T_MCRE0_APP_ALL_DATA.COD_OPERATORE_INS_UPD%type default '',
    seq         number
  )
  RETURN NUMBER;

  --truncate/insert della ALL_DATA
  FUNCTION LOAD_ALL_DATA(P_COD_LOG number) RETURN NUMBER;

  --inserisce eventuali tappi nelle anagrafiche
  FUNCTION ETL_GESTIONE_TAPPI(P_COD_LOG number) RETURN NUMBER;

  --ripristina riporta su FG gli aggiornamneti fatti su all_data
  FUNCTION ETL_RESTORE_FILE_GUIDA (P_COD_LOG number) return number;

  --ripristina riporta su Mople gli aggiornamneti fatti su all_data
  FUNCTION ETL_RESTORE_MOPLE (P_COD_LOG number) return number;

  --assegna in automatico un utente quando lo trova a -1 in base al cod_stato peggiore
  PROCEDURE ASSEGNA_REGIONI;

  --appittisce i gruppi super
  PROCEDURE SPALMA_GRUPPI;

end PKG_MCRE0_GESTIONE_ALL_DATA;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_GESTIONE_ALL_DATA FOR MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_GESTIONE_ALL_DATA FOR MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GESTIONE_ALL_DATA TO MCRE_USR;

