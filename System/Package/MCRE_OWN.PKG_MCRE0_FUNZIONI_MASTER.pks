CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_FUNZIONI_MASTER AS
/******************************************************************************
   NAME:       PKG_MCRE0_CONVERSIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Andrea Bartolomei  Created this package.
******************************************************************************/

    c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_FUNZIONI_MASTER';

    FUNCTION FND_MCRE0_master(seq IN NUMBER, p_file IN VARCHAR2) RETURN NUMBER;


END PKG_MCRE0_FUNZIONI_MASTER;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_FUNZIONI_MASTER FOR MCRE_OWN.PKG_MCRE0_FUNZIONI_MASTER;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_FUNZIONI_MASTER FOR MCRE_OWN.PKG_MCRE0_FUNZIONI_MASTER;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_FUNZIONI_MASTER TO MCRE_USR;

