CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRES_GEST_CONFERIMENTI AS
  /******************************************************************************
  NAME:       PKG_MCRES_GEST_CONFERIMENTI
  PURPOSE:

  REVISIONS:
  Ver        Date        Author           Description
  ---------  ----------  ---------------  ------------------------------------
  1.0        14/01/2013  M.Murro          Created this package body.
  1.1        23/07/2013  T.Bernardi       Aggiunte procedure archiviazione.
  ******************************************************************************/

  c_package CONSTANT VARCHAR2(50) := 'PKG_MCRES_GEST_CONFERIMENTI';
  ok NUMBER := 1;
  ko NUMBER := 0;

  --giorni di ritardo per gestione diagnostico
  -- 6 giorni di alimentazioni corrispondono fino a 10gg su id_dper
  days number := 10;

  function archiviatore return number;


  --archivia le pratiche che non vengono aggiornate da almeno 6 giorni
  PROCEDURE ARCHIVIA_PRATICHE;

  --archivia i rapporti che non vengono aggiornate da almeno 6 giorni
  PROCEDURE ARCHIVIA_RAPPORTI;

  --archivia le garanzie che non vengono aggiornate da almeno 6 giorni
  PROCEDURE ARCHIVIA_GARANZIE;

  --archivia le posizioni che non vengono aggiornate da almeno 6 giorni
  PROCEDURE ARCHIVIA_POSIZIONI;


END pkg_mcres_gest_conferimenti;
/


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_GEST_CONFERIMENTI TO MCRE_USR;

