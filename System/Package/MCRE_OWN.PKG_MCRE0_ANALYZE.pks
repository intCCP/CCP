CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_ANALYZE
IS
/******************************************************************************
   NAME:       PKG_MCRE0_ANALYZE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        ??/??/2010  ??                Created this package.
   1.1        02/02/2012  L.Ferretti        Aggiornato cursore
   1.2        14/02/2012  L.Ferretti        Aggiunta funzione per statistiche nel weekend.
******************************************************************************/

   FUNCTION FND_MCRE0_analyze_table_FL (
      pschema   IN   T_MCRE0_WRK_STATISTICHE.table_owner%TYPE DEFAULT USER,
      ptable    IN   T_MCRE0_WRK_STATISTICHE.table_name%TYPE

   ) RETURN BOOLEAN;

   FUNCTION FND_MCRE0_analyze_table_ST (
      pschema      IN   T_MCRE0_WRK_STATISTICHE.table_owner%TYPE DEFAULT USER,
      ptable       IN   T_MCRE0_WRK_STATISTICHE.table_name%TYPE,
      ppartition   IN   VARCHAR2 default NULL

   )RETURN BOOLEAN;

   FUNCTION FND_MCRE0_analyze_table_APP (
      pschema   IN   T_MCRE0_WRK_STATISTICHE.table_owner%TYPE DEFAULT USER,
      ptable    IN   T_MCRE0_WRK_STATISTICHE.table_name%TYPE

   ) RETURN BOOLEAN;

   FUNCTION FND_MCRE0_analyze_table_WEEKLY (
      pschema   IN   T_MCRE0_WRK_STATISTICHE.table_owner%TYPE DEFAULT USER,
      ptable    IN   T_MCRE0_WRK_STATISTICHE.table_name%TYPE,
      ppartition   IN   VARCHAR2 default NULL

   ) RETURN BOOLEAN;


END;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ANALYZE FOR MCRE_OWN.PKG_MCRE0_ANALYZE;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ANALYZE FOR MCRE_OWN.PKG_MCRE0_ANALYZE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ANALYZE TO MCRE_USR;

