CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCREI_ALIMENTA_STORICO_DEL AS
/******************************************************************************
   NAME:       PKG_MCREI_ALIMENTA_STORICO_DEL
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/03/2013   I.Gueorguieva   1. Created this package.
******************************************************************************/
   c_package   CONSTANT VARCHAR2 (50) := 'PKG_MCREI_ALIMENTA_STORICO_DEL';
   ok                   NUMBER        := 1;
   ko                   NUMBER        := 0;
  FUNCTION FNC_ALIMENTA_STORICO RETURN NUMBER;

  FUNCTION FNC_STORICIZZA_DELIB_DAILY RETURN NUMBER;


END PKG_MCREI_ALIMENTA_STORICO_DEL;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_ALIMENTA_STORICO_DEL FOR MCRE_OWN.PKG_MCREI_ALIMENTA_STORICO_DEL;


CREATE SYNONYM MCRE_USR.PKG_MCREI_ALIMENTA_STORICO_DEL FOR MCRE_OWN.PKG_MCREI_ALIMENTA_STORICO_DEL;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_ALIMENTA_STORICO_DEL TO MCRE_USR;

