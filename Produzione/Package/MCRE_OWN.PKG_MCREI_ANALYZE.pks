CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcrei_analyze AUTHID CURRENT_USER
IS
/************************************************************************************
   NAME:       PKG_MCREI_ANALYZE
   PURPOSE:

   REVISIONS:
   Ver        Date              Author                     Description
   ---------  ----------      -----------------  ------------------------------------
   1.0        07/11/2011      Emiliano Pellizzi         Created this package.
************************************************************************************/
   ok                   NUMBER        := 1;
   ko                   NUMBER        := 0;
   c_package            VARCHAR2 (30) := 'PKG_MCREI_ANALYZE';
   pkgname     CONSTANT VARCHAR2 (30) := 'PKG_MCREI_ANALYZE';
   defdegree   CONSTANT NUMBER        := 4;
   in_use               EXCEPTION;
   PRAGMA EXCEPTION_INIT (in_use, -54);

   -- Analizza partizione
   FUNCTION fnc_analizza_partizione (p_rec IN f_slave_par_type)
      RETURN NUMBER;

   -- Analizza tabella
   FUNCTION fnc_analizza_tabella (p_rec IN f_slave_par_type)
      RETURN NUMBER;

   -- Analizza tabella FL
   FUNCTION fnc_analizza_part_e_tabella (p_rec IN f_slave_par_type)
      RETURN NUMBER;

   -- Rebuild Indexes
   FUNCTION fnc_rebuild_indexes (p_rec IN f_slave_par_type)
      RETURN NUMBER;

   -- Analizza tabella di nome p_rec.TAB_TRG
   -- per adesso chiamata solo dalla archiviatore
   FUNCTION FNC_ANALIZZA_PARTIZIONE_BIS(P_REC IN F_SLAVE_PAR_TYPE)
   RETURN NUMBER;
END;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_ANALYZE FOR MCRE_OWN.PKG_MCREI_ANALYZE;


CREATE SYNONYM MCRE_USR.PKG_MCREI_ANALYZE FOR MCRE_OWN.PKG_MCREI_ANALYZE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_ANALYZE TO MCRE_USR;

