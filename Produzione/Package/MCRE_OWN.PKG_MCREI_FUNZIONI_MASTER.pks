CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcrei_funzioni_master
AS
/******************************************************************************
 NAME:       PKG_MCREI_GESTIONE_PARTIZIONI
 PURPOSE:

 REVISIONS:
 Ver        Date              Author             Description
 ---------  ----------      -----------------  ------------------------------------
 1.0      20/10/2011         E.Pellizzi         Created this package.
******************************************************************************/
   c_package   CONSTANT VARCHAR2 (50) := 'PKG_MCREI_FUNZIONI_MASTER';

   TYPE rec_func_type IS RECORD (
      funzione_slave         t_mcrei_wrk_elaborazione.funzione_slave%TYPE,
      ordine_alimentazione   t_mcrei_wrk_elaborazione.ordine_alimentazione%TYPE
   );

   TYPE cur_func_type IS REF CURSOR
      RETURN rec_func_type;

   FUNCTION fnc_mcrei_master (v_seq IN NUMBER, p_file IN VARCHAR2)
      RETURN NUMBER;

END pkg_mcrei_funzioni_master;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_FUNZIONI_MASTER FOR MCRE_OWN.PKG_MCREI_FUNZIONI_MASTER;


CREATE SYNONYM MCRE_USR.PKG_MCREI_FUNZIONI_MASTER FOR MCRE_OWN.PKG_MCREI_FUNZIONI_MASTER;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_FUNZIONI_MASTER TO MCRE_USR;

