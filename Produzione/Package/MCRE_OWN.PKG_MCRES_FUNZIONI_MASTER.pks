CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRES_FUNZIONI_MASTER AS
/******************************************************************************
   NAME:       PKG_MCRES_CONVERSIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------      -----------------  ------------------------------------
   1.0      01/07/2011  V.Galli       Created this package.
   2.0      10/02/2012  V.Galli       Aggiornamento stato acquisizione in  nuova tabella T_MCRES_WRK_last_ACQUISIZIONE
   2.1      12/03/2012   V.Galli      Aggiornamento fine secondo livello T_MCRES_WRK_last_ACQUISIZIONE
******************************************************************************/

    c_package CONSTANT VARCHAR2(50) := 'PKG_MCRES_FUNZIONI_MASTER';
    TYPE REC_FUNC_TYPE IS RECORD(
      FUNZIONE_SLAVE T_MCRES_WRK_ELABORAZIONE.FUNZIONE_SLAVE%TYPE,
      ORDINE_ALIMENTAZIONE T_MCRES_WRK_ELABORAZIONE.ORDINE_ALIMENTAZIONE%TYPE);
    TYPE cur_func_type IS REF CURSOR RETURN rec_func_type;

    FUNCTION FNC_MCRES_master(v_seq IN NUMBER, p_file IN VARCHAR2) RETURN NUMBER;
--    FUNCTION fnc_MCRES_get_cur_fnd_slv(v_seq IN NUMBER, p_file IN VARCHAR2, p_ext_table IN VARCHAR2) RETURN cur_func_type;

END PKG_MCRES_FUNZIONI_MASTER;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_FUNZIONI_MASTER FOR MCRE_OWN.PKG_MCRES_FUNZIONI_MASTER;


CREATE SYNONYM MCRE_USR.PKG_MCRES_FUNZIONI_MASTER FOR MCRE_OWN.PKG_MCRES_FUNZIONI_MASTER;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_FUNZIONI_MASTER TO MCRE_USR;

