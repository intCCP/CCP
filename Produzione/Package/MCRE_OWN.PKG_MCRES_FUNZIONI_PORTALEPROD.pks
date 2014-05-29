CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALEPROD
AS
  /******************************************************************************
  NAME:       PKG_MCRES_FUNZIONI_PORTALE
  PURPOSE:
  REVISIONS:
  Ver        Date        Author             Description
  ---------  ----------      -----------------  ------------------------------------
  1.0      14/10/2011  V.Galli       Created this package.
  1.1      29/11/2011  V.Galli       Aggiunta gestione Spese
  1.2      03/01/2012  M.Palladino   Modifica gestione spese
  1.3      19/01/2012  V.Galli       Gestori
  ******************************************************************************/
  C_PACKAGE CONSTANT VARCHAR2(50) := 'PKG_MCRES_FUNZIONI_PORTALEPROD';
  OK        NUMBER                := 1; -- Esito positivo
  ko        NUMBER                := 0; -- Esito negativo

  -- Funzione per il mantenimento dello storico dei Gestori delle Pratiche Legali
FUNCTION FNC_MCRES_ALIMENTA_GESTORI(
    P_REC IN F_SLAVE_PAR_TYPE)
  return number;
  
END PKG_MCRES_FUNZIONI_PORTALEPROD;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_FUNZIONI_PORTALEPROD FOR MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALEPROD;


CREATE SYNONYM MCRE_USR.PKG_MCRES_FUNZIONI_PORTALEPROD FOR MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALEPROD;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_FUNZIONI_PORTALEPROD TO MCRE_USR;

