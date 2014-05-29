CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcres_conformita
AS
/******************************************************************************
   NAME:       PKG_mcrei_CONFORMITA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        20/07/2011  Luca Feretti        Created this package.
   1.1        11/09/2012  Antonio Pilloni    Commentate insert nel blocco if.
******************************************************************************/
   c_package   CONSTANT VARCHAR2 (50) := 'PKG_MCRES_CONFORMITA';
   ok                   NUMBER        := 1;
   ko                   NUMBER        := 0;

   FUNCTION fnc_mcres_verifica_conformita (p_rec IN f_slave_par_type)
      RETURN NUMBER;
END pkg_mcres_conformita;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_CONFORMITA FOR MCRE_OWN.PKG_MCRES_CONFORMITA;


CREATE SYNONYM MCRE_USR.PKG_MCRES_CONFORMITA FOR MCRE_OWN.PKG_MCRES_CONFORMITA;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_CONFORMITA TO MCRE_USR;

