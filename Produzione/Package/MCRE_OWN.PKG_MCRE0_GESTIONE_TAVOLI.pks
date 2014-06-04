CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_GESTIONE_TAVOLI AS

  C_PACKAGE CONSTANT VARCHAR2(50) := 'PKG_MCRE0_GESTIONE_TAVOLI';

  FUNCTION SET_ESITO_KO_CONVOCAZ_AUTO (
    P_COD_ABI_CARTOLARIZZATO  IN T_MCRE0_APP_CONV_AUTO.COD_ABI_CARTOLARIZZATO%TYPE,
    P_COD_NDG                 IN T_MCRE0_APP_CONV_AUTO.COD_NDG%TYPE,
    P_COD_SNDG                IN T_MCRE0_APP_CONV_AUTO.COD_SNDG%TYPE,
    P_ID_UTENTE               IN T_MCRE0_APP_CONV_AUTO.ID_UTENTE%TYPE
  ) RETURN NUMBER;

  FUNCTION SET_ESITO_OK_CONVOCAZ_MAN (
    P_COD_ABI_CARTOLARIZZATO  IN T_MCRE0_APP_CONV_AUTO.COD_ABI_CARTOLARIZZATO%TYPE,
    P_COD_NDG                 IN T_MCRE0_APP_CONV_AUTO.COD_NDG%TYPE,
    P_COD_SNDG                IN T_MCRE0_APP_CONV_AUTO.COD_SNDG%TYPE,
    P_ID_UTENTE               IN T_MCRE0_APP_CONV_AUTO.ID_UTENTE%TYPE
  ) RETURN NUMBER;

  FUNCTION CLEAN_POS_NON_PT RETURN NUMBER;

END PKG_MCRE0_GESTIONE_TAVOLI;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_GESTIONE_TAVOLI FOR MCRE_OWN.PKG_MCRE0_GESTIONE_TAVOLI;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_GESTIONE_TAVOLI FOR MCRE_OWN.PKG_MCRE0_GESTIONE_TAVOLI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GESTIONE_TAVOLI TO MCRE_USR;
