CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_CR" AS
/******************************************************************************
   NAME:     PKG_MCRE0_CR

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        25/10/2011  Luca Ferretti      Created this package.
   1.1        10/05/2011  Luca Ferretti      Modifica fnc_clean_cr
   1.2        19/05/2011  Luca Ferretti      Aggiunta controllo presenza flussi nuovi
   1.3        20/05/2011  Luca Ferretti      Parametrizzazione valori di uscita (ok=0, ko=1)
   1.4        08/07/2011  Luca Ferretti      Modificate funzion clean_cr (1, 3 e 4)
   2.0        11/07/2011  Luca Ferretti      Aggiornamento logica sbiancamento
   2.1        11/07/2011  Marco Murro        Se ok, return 1!
   2.2        08/09/2011  Marco Murro        fix ge_gb: calcolo per sndg e QIS numerico
   2.3        27/09/2011  Marco Murro        fix sndg, return, clean..
   2.4        08/10/2012  Luca Ferretti      Modifica parametro di ritorno per file già caricati
   2.5        18/12/2012  Marco Murro        fix logica aggiornamneto app_cr - commentata clean
   2.6        02/04/2013  Marco Murro        rimosso controllo iniziale caricamneto app_cr 
******************************************************************************/

  FUNCTION FNC_LOAD_CR(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL) RETURN NUMBER;

  FUNCTION FNC_CLEAN_CR (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
    p_id_dper t_mcre0_app_cr_sc_sb24.id_dper%type default null)
  RETURN NUMBER;

  FUNCTION FNC_LOAD_CR_SC_SB (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
    p_id_dper T_MCRE0_APP_CR_SC_SB24.id_dper%type default null)  RETURN NUMBER;

  FUNCTION FNC_LOAD_CR_SC_GB (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
    p_id_dper T_MCRE0_APP_CR_SC_GB24.id_dper%type default null)  RETURN NUMBER;

  FUNCTION FNC_LOAD_CR_GE_GB (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
    p_id_dper T_MCRE0_APP_CR_GE_GB24.id_dper%type default null)  RETURN NUMBER;

  FUNCTION FNC_LOAD_CR_GE_SB (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
    p_id_dper T_MCRE0_APP_CR_GE_SB24.id_dper%type default null)  RETURN NUMBER;

  FUNCTION FNC_LOAD_CR_LG_GB (
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL,
    p_id_dper T_MCRE0_APP_CR_LG_GB24.id_dper%type default null)  RETURN NUMBER;


END PKG_MCRE0_CR;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CR FOR MCRE_OWN.PKG_MCRE0_CR;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CR FOR MCRE_OWN.PKG_MCRE0_CR;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CR TO MCRE_USR;

