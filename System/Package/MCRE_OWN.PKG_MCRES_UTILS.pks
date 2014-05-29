CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRES_UTILS AS


/******************************************************************************
   NAME:       PKG_MCRES_UTILS
   PURPOSE:

   REVISIONS:
   Ver        Date          Author              Description
   ---------  ----------       -----------------  ------------------------------------
   1.0        01/07/2011    V.Galli             Created this package.
   1.1        01/07/2011    L.Ferretti          Cambio parametro in id_flusso
   1.2        17/10/2011    A.Galliano          Procedure di drop pre-caricamento
   2.0      10/02/2012      V.Galli             Aggiornamento stato acquisizione in  nuova tabella T_MCRES_WRK_last_ACQUISIZIONE
   2.1      15/02/2012      A.Galliano          Gestione flussi per istituti non target
   2.2      10/02/2012      V.Galli             Aggiornamento stato acquisizione in  nuova tabella T_MCRES_WRK_last_ACQUISIZIONE solo se id_dper nuovo
   2.3      28/05/2012      A.Galliano          Gestione file vuoti
   2.3.1    29/05/2012      A.Galliano          Fix file vuoti
   2.4      15/10/2012      A.Galliano          Gestione multibanca su ckeck_periodo
   2.5      16/10/2012      A.Galliano          Gestione flussi XML (no external tables)
   2.5.1    05/11/2012      A.Galliano          Rimozione gestione XML da process_file
   2.6      19/02/2013      A.Galliano          Log di warning e gestione eccezione no data found per file vuoti
   2.7      22/02/2013      A.Galliano          Funzione allineamento soglie alert
   2.8      03/04/2013      A.Pilloni           Modifica process file per gestione multibanca
  2.9       03/07/2013      V.Galli             checkPeriodo aggiunto flg_daily T
******************************************************************************/


    c_package CONSTANT VARCHAR2(50) := 'PKG_MCRES_UTILS';

    TYPE REC_ABI_TYPE IS RECORD(ABI VARCHAR2(5 BYTE));
    TYPE CUR_ABI_TYPE IS REF CURSOR RETURN REC_ABI_TYPE;
    TYPE REC_FUNC_TYPE IS RECORD(
      FUNZIONE_SLAVE T_MCRES_WRK_ELABORAZIONE.FUNZIONE_SLAVE%TYPE,
      ORDINE_ALIMENTAZIONE T_MCRES_WRK_ELABORAZIONE.ORDINE_ALIMENTAZIONE%TYPE);
    TYPE cur_func_type IS REF CURSOR RETURN rec_func_type;
    TYPE rec_sic_fun_type IS RECORD(TAB_ESTERNA T_MCRES_WRK_ELABORAZIONE.TAB_SRC%TYPE,
                                    FUNZIONE_SLAVE T_MCRES_WRK_ELABORAZIONE.FUNZIONE_SLAVE%TYPE);
    TYPE cur_sic_fun_type IS REF CURSOR RETURN rec_sic_fun_type;

    val_ok  number := 1;
    val_ko  number := 0;

    FUNCTION fnc_MCRES_process_file(id_flusso IN NUMBER) RETURN NUMBER;
    FUNCTION FNc_MCRES_checkIn(seq IN NUMBER, p_file IN VARCHAR2) RETURN NUMBER;
--    function fnc_mcres_checkperiodo(seq in number, p_file in varchar2) return boolean;
    FUNCTION fnc_MCREs_checkPeriodo(seq IN NUMBER, p_file IN VARCHAR2, p_date OUT DATE) RETURN NUMBER;
    function fnc_mcres_string2date(seq in number, p_string in varchar2) return boolean;
    FUNCTION fnc_MCREs_string2date(seq IN NUMBER, p_string IN VARCHAR2, p_date OUT DATE) RETURN BOOLEAN;
    FUNCTION fnc_MCRES_get_slave_param(v_seq IN NUMBER, p_file IN VARCHAR2) RETURN f_slave_par_type;
    FUNCTION fnc_MCRES_get_slave_param_sic(v_seq IN NUMBER, p_file IN VARCHAR2) RETURN f_slave_par_type;
    FUNCTION fnc_MCRES_get_ext_table(v_seq IN NUMBER, p_file IN VARCHAR2) RETURN VARCHAR2;
--    FUNCTION fnc_MCRES_get_trg_table(v_seq IN NUMBER, p_file IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION fnc_MCRES_get_trg_table(v_seq IN NUMBER, p_ordine IN NUMBER) RETURN VARCHAR2; --, p_file IN VARCHAR2, p_ext_tab IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION fnc_MCRES_get_cur_fnd_slv(v_seq IN NUMBER, p_file IN VARCHAR2, p_ext_table IN VARCHAR2) RETURN cur_func_type;
    FUNCTION fnc_MCRES_get_cur_sic_fnd_slv(seq IN NUMBER, p_file IN VARCHAR2) RETURN cur_sic_fun_type;
    FUNCTION fnc_MCRES_esegui_slave(v_seq IN NUMBER, p_funzione IN VARCHAR2, p_ordine IN NUMBER, p_param IN f_slave_par_type) RETURN NUMBER;
    FUNCTION fnc_MCRES_execute(p_param1 IN VARCHAR2, p_param2 IN VARCHAR2, p_param3 IN VARCHAR2, p_param4 IN VARCHAR2) RETURN BOOLEAN;
    --v1.1
    FUNCTION fnc_MCRES_chiudi_portale return number;
    function fnc_MCRES_apri_portale return number;
    --v1.2
    function fnc_mcres_drop_parts(v_string IN VARCHAR2) return number;  --Per caricamento impianto. Parametro ingresso 'DROPALL'
    FUNCTION fnc_mcres_drop_subparts(v_string IN VARCHAR2) RETURN NUMBER; --Per caricamento impianto. Parametro ingresso 'DROPALL'

    -- v 2.5
    function fnc_mcres_checkin_xml( p_seq in number, p_file in varchar2) return number;

    -- v 2.6
    function fnc_alliena_soglie_alert return number;

END PKG_MCRES_UTILS;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_UTILS FOR MCRE_OWN.PKG_MCRES_UTILS;


CREATE SYNONYM MCRE_USR.PKG_MCRES_UTILS FOR MCRE_OWN.PKG_MCRES_UTILS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_UTILS TO MCRE_USR;

