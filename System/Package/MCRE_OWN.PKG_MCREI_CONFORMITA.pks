CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcrei_conformita
AS
/******************************************************************************
 NAME:       PKG_MCREI_GESTIONE_PARTIZIONI
 PURPOSE:

 REVISIONS:
 Ver        Date              Author             Description
 ---------  ----------      -----------------  ------------------------------------
 1.0      20/10/2011         E.Pellizzi         Created this package.
******************************************************************************/
   c_package   CONSTANT VARCHAR2 (50) := 'PKG_MCREI_CONFORMITA';
   ok                   NUMBER        := 1;
   ko                   NUMBER        := 0;

   FUNCTION fnc_mcrei_verifica_conformita (p_rec IN f_slave_par_type)
      RETURN NUMBER;
END pkg_mcrei_conformita;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_CONFORMITA FOR MCRE_OWN.PKG_MCREI_CONFORMITA;


CREATE SYNONYM MCRE_USR.PKG_MCREI_CONFORMITA FOR MCRE_OWN.PKG_MCREI_CONFORMITA;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_CONFORMITA TO MCRE_USR;

