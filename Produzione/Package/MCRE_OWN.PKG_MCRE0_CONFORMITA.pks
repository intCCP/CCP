CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_CONFORMITA AS
/******************************************************************************
   NAME:       PKG_MCR0_CONFORMITA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Andrea Bartolomei  Created this package.
******************************************************************************/

    c_package CONSTANT VARCHAR2(50) := 'PKG_MCR0_CONFORMITA';

    FUNCTION FND_MCRE0_verifica_conformita(p_rec IN f_slave_par_type) RETURN BOOLEAN;

END PKG_MCRE0_CONFORMITA;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CONFORMITA FOR MCRE_OWN.PKG_MCRE0_CONFORMITA;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CONFORMITA FOR MCRE_OWN.PKG_MCRE0_CONFORMITA;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CONFORMITA TO MCRE_USR;

