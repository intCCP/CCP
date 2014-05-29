CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcrei_web_cr_inc
AS
   /******************************************************************************
    NAME:       pkg_mcrei_web_cr_inc
    PURPOSE:

    REVISIONS:
    Ver        Date              Author             Description
    ---------  ----------      -----------------  ------------------------------------
    1.0        17/12/2012        E.Pellizzi         Created this package.
   ******************************************************************************/
   c_package   CONSTANT VARCHAR2 (50) := 'PKG_MCREI_WEB_CR_INC';
   ok                   NUMBER        := 1;
   ko                   NUMBER        := 0;
   pk_violata           EXCEPTION;
   PRAGMA EXCEPTION_INIT (pk_violata, -1);

     FUNCTION salva_nota (
      p_cod_abi              IN   VARCHAR2,
      p_cod_ndg              IN   VARCHAR2,
      p_cod_numero_pratica   IN   VARCHAR2,
      p_val_anno             IN   NUMERIC,
      p_val_nota             IN   VARCHAR2,
      p_cod_motivo           IN   VARCHAR2,
      p_utente               IN   VARCHAR2
   )
      RETURN NUMBER;
END pkg_mcrei_web_cr_inc;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_WEB_CR_INC FOR MCRE_OWN.PKG_MCREI_WEB_CR_INC;


CREATE SYNONYM MCRE_USR.PKG_MCREI_WEB_CR_INC FOR MCRE_OWN.PKG_MCREI_WEB_CR_INC;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_WEB_CR_INC TO MCRE_USR;

