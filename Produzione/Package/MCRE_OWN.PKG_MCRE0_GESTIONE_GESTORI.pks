CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_GESTIONE_GESTORI AS 
 /******************************************************************************
    NAME:       PKG_MCRE0_GESTIONE_GESTORI
    PURPOSE:
    REVISIONS:
    Ver        Date        Author           Description
    ---------  ----------  ---------------  ------------------------------------
    1.0        25/10/2013  T.Bernardi        Created this package.
    
 ******************************************************************************/
 C_PACKAGE CONSTANT VARCHAR2(50) := 'PKG_MCRE0_GESTIONE_GESTORI';
 OK NUMBER := 0;
 KO NUMBER := 1;
  
  
  PROCEDURE STORICIZZA_GEST_ONLINE(P_ABI IN VARCHAR2,
                                   P_NDG IN VARCHAR2,
                                   P_UTENTE  VARCHAR2 DEFAULT NULL
                                   );
 
 
 
 
  PROCEDURE STORICIZZA_GESTORI;
 
  FUNCTION GEST_GEST RETURN NUMBER;
  
  PROCEDURE STORICIZZA_GESTORI_SO;
  
  FUNCTION IMPORTA_GESTORI RETURN NUMBER;
 
END PKG_MCRE0_GESTIONE_GESTORI;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_GESTIONE_GESTORI FOR MCRE_OWN.PKG_MCRE0_GESTIONE_GESTORI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GESTIONE_GESTORI TO MCRE_USR;

