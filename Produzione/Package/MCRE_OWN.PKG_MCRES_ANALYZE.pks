CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRES_ANALYZE
AUTHID CURRENT_USER
IS

/******************************************************************************
   NAME:       PKG_MCRES_ANALYZE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------      -----------------  ------------------------------------
   1.0     05/07/2011   V.Galli         Created this package.
******************************************************************************/

  ok NUMBER := 1;
  KO NUMBER := 0;
  C_PACKAGE VARCHAR2(30):='PKG_MCRES_ANALYZE';

   PKGNAME     CONSTANT VARCHAR2 (30) := 'PKG_MCRES_ANALYZE';
   defdegree   CONSTANT NUMBER        := 4;

   IN_USE EXCEPTION;
   pragma exception_init(in_use, -54);

  -- Analizza partizione
    FUNCTION FNC_ANALIZZA_PARTIZIONE(P_REC IN F_SLAVE_PAR_TYPE) RETURN NUMBER;

   -- Analizza tabella
    FUNCTION FNC_ANALIZZA_TABELLA(P_REC IN F_SLAVE_PAR_TYPE) return number;

  -- Analizza tabella FL
  FUNCTION fnc_analizza_part_e_tabella (P_REC IN F_SLAVE_PAR_TYPE)RETURN NUMBER;

  -- Rebuild Indexes
  FUNCTION FNC_REBUILD_INDEXES(P_REC IN F_SLAVE_PAR_TYPE) RETURN NUMBER;

END;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_ANALYZE FOR MCRE_OWN.PKG_MCRES_ANALYZE;


CREATE SYNONYM MCRE_USR.PKG_MCRES_ANALYZE FOR MCRE_OWN.PKG_MCRES_ANALYZE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_ANALYZE TO MCRE_USR;

