CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCREI_UTILS
AS
/******************************************************************************
 NAME:       PKG_MCREI_GESTIONE_PARTIZIONI
 PURPOSE:

 REVISIONS:
 Ver        Date              Author             Description
 ---------  ----------      -----------------  ------------------------------------
 1.0      20/10/2011         E.Pellizzi         Created this package.
 1.1      15/03/2012         E.Pellizzi         CheckPeriodo rapporti_estero
******************************************************************************/
   c_package   CONSTANT VARCHAR2 (50) := 'PKG_MCREI_UTILS';

   TYPE rec_abi_type IS RECORD (
      abi   VARCHAR2 (5 BYTE)
   );

   TYPE cur_abi_type IS REF CURSOR
      RETURN rec_abi_type;

   TYPE rec_func_type IS RECORD (
      funzione_slave         t_mcrei_wrk_elaborazione.funzione_slave%TYPE,
      ordine_alimentazione   t_mcrei_wrk_elaborazione.ordine_alimentazione%TYPE
   );

   TYPE cur_func_type IS REF CURSOR
      RETURN rec_func_type;

   TYPE rec_sic_fun_type IS RECORD (
      tab_esterna      t_mcrei_wrk_elaborazione.tab_src%TYPE,
      funzione_slave   t_mcrei_wrk_elaborazione.funzione_slave%TYPE
   );

   TYPE cur_sic_fun_type IS REF CURSOR
      RETURN rec_sic_fun_type;

   val_ok               NUMBER        := 1;
   val_ko               NUMBER        := 0;

   FUNCTION fnc_mcrei_process_file (id_flusso IN NUMBER)
      RETURN NUMBER;

   FUNCTION fnc_mcrei_checkin (seq IN NUMBER, p_file IN VARCHAR2)
      RETURN NUMBER;

--    function fnc_MCREI_checkperiodo(seq in number, p_file in varchar2) return boolean;
   FUNCTION fnc_mcrei_checkperiodo (
      seq      IN       NUMBER,
      p_file   IN       VARCHAR2,
      p_date   OUT      DATE
   )
      RETURN NUMBER;

   FUNCTION fnc_mcrei_string2date (seq IN NUMBER, p_string IN VARCHAR2)
      RETURN BOOLEAN;

   FUNCTION fnc_mcrei_string2date (
      seq        IN       NUMBER,
      p_string   IN       VARCHAR2,
      p_date     OUT      DATE
   )
      RETURN BOOLEAN;

   FUNCTION fnc_mcrei_get_slave_param (v_seq IN NUMBER, p_file IN VARCHAR2)
      RETURN f_slave_par_type;

   FUNCTION fnc_mcrei_get_slave_param_sic (v_seq IN NUMBER, p_file IN VARCHAR2)
      RETURN f_slave_par_type;

   FUNCTION fnc_mcrei_get_ext_table (v_seq IN NUMBER, p_file IN VARCHAR2)
      RETURN VARCHAR2;

--    FUNCTION fnc_MCREI_get_trg_table(v_seq IN NUMBER, p_file IN VARCHAR2) RETURN VARCHAR2;
   FUNCTION fnc_mcrei_get_trg_table (v_seq IN NUMBER, p_ordine IN NUMBER)
      RETURN VARCHAR2;
               --, p_file IN VARCHAR2, p_ext_tab IN VARCHAR2) RETURN VARCHAR2;

   FUNCTION fnc_mcrei_get_cur_fnd_slv (
      v_seq         IN   NUMBER,
      p_file        IN   VARCHAR2,
      p_ext_table   IN   VARCHAR2
   )
      RETURN cur_func_type;

   FUNCTION fnc_mcrei_get_cur_sic_fnd_slv (seq IN NUMBER, p_file IN VARCHAR2)
      RETURN cur_sic_fun_type;

   FUNCTION fnc_mcrei_esegui_slave (
      v_seq        IN   NUMBER,
      p_funzione   IN   VARCHAR2,
      p_ordine     IN   NUMBER,
      p_param      IN   f_slave_par_type
   )
      RETURN NUMBER;

   FUNCTION fnc_mcrei_execute (
      p_param1   IN   VARCHAR2,
      p_param2   IN   VARCHAR2,
      p_param3   IN   VARCHAR2,
      p_param4   IN   VARCHAR2
   )
      RETURN BOOLEAN;

   --v1.1
--   FUNCTION fnc_mcrei_chiudi_portale
--      RETURN NUMBER;

--   FUNCTION fnc_mcrei_apri_portale
--      RETURN NUMBER;

   --v1.2
--   FUNCTION fnc_mcrei_drop_parts (v_string IN VARCHAR2)
--      RETURN NUMBER;  --Per caricamento impianto. Parametro ingresso 'DROPALL'

--   FUNCTION fnc_mcrei_drop_subparts (v_string IN VARCHAR2)
--      RETURN NUMBER;  --Per caricamento impianto. Parametro ingresso 'DROPALL'
END pkg_mcrei_utils;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_UTILS FOR MCRE_OWN.PKG_MCREI_UTILS;


CREATE SYNONYM MCRE_USR.PKG_MCREI_UTILS FOR MCRE_OWN.PKG_MCREI_UTILS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_UTILS TO MCRE_USR;

