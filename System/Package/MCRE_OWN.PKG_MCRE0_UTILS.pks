CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_UTILS" AS
/******************************************************************************
   NAME:       PKG_MCRE0_UTILS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        20/04/2010  Andrea Bartolomei  Created this package.
   1.1        20/04/2011  M.Murro            Aggiunte funzioni Apri/Chiudi portale
   1.2        03/11/2011  L.Ferretti         Aggiunta funzione per controlli mattutini
   1.3        16/11/2011  L.Ferretti         Modifica insert per controlli.
   1.4        17/11/2011  L.Ferretti         Nuova gestione dei controlli.
   1.5        15/02/2012  L.Ferretti         Aggiunta funzione chiamata analyze settimanale
   1.6        16/03/2012  L.Ferretti         Aggiornamento log (scrittura in tabella)
   1.7        02/07/2012  L.Ferretti         Aggiunta, nella analyze settimanale, della chiamata alla refresh delle CR.
   1.8        30/10/2012  L.Ferretti         Aggiunta, nella analyze settimanale, della chiamata allo svecchiamento settimanale.
   1.9        10/12/2012  V.Galli             Commentato refresh CR
  1.10      28/01/2013  F. Galletti         Commentati tutti i dbms_output per evitare errori nelle applicazioni TWS 
******************************************************************************/

    c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_UTILS';

    TYPE rec_abi_type IS RECORD(ABI varchar2(5 byte));
    TYPE cur_abi_type IS REF CURSOR RETURN rec_abi_type;
    TYPE rec_func_type IS RECORD(FUNZIONE_SLAVE T_MCRE0_WRK_ELABORAZIONE.FUNZIONE_SLAVE%TYPE);
    TYPE cur_func_type IS REF CURSOR RETURN rec_func_type;
    TYPE rec_sic_fun_type IS RECORD(TAB_ESTERNA T_MCRE0_WRK_ELABORAZIONE.TAB_ESTERNA%TYPE,
                                    FUNZIONE_SLAVE T_MCRE0_WRK_ELABORAZIONE.FUNZIONE_SLAVE%TYPE);
    TYPE cur_sic_fun_type IS REF CURSOR RETURN rec_sic_fun_type;

    FUNCTION FND_MCRE0_process_file(p_file IN VARCHAR2) RETURN NUMBER;
    FUNCTION FND_MCRE0_checkPeriodo(seq IN NUMBER, p_file IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_checkPeriodo(seq IN NUMBER, p_file IN VARCHAR2, p_date OUT DATE) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_string2date(seq IN NUMBER, p_string IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_string2date(seq IN NUMBER, p_string IN VARCHAR2, p_date OUT DATE) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_string2number(seq IN NUMBER, p_string IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_string2number(seq IN NUMBER, p_string IN VARCHAR2, p_number OUT NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_get_slave_param(seq IN NUMBER, p_file IN VARCHAR2) RETURN f_slave_par_type;
    FUNCTION FND_MCRE0_get_slave_param_sic(seq IN NUMBER, p_file IN VARCHAR2) RETURN f_slave_par_type;
 --   FUNCTION FND_MCRE0_get_app_table(seq IN NUMBER, p_file IN VARCHAR2, p_ext_tab IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION FND_MCRE0_get_ext_table(seq IN NUMBER, p_file IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION FND_MCRE0_get_trg_table(seq IN NUMBER, p_file IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION FND_MCRE0_get_trg_table(seq IN NUMBER, p_file IN VARCHAR2, p_ext_tab IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION FND_MCRE0_get_cur_fnd_slv(seq IN NUMBER, p_file IN VARCHAR2, p_ext_table IN VARCHAR2) RETURN cur_func_type;
    FUNCTION FND_MCRE0_get_cur_sic_fnd_slv(seq IN NUMBER, p_file IN VARCHAR2) RETURN cur_sic_fun_type;
    FUNCTION FND_MCRE0_esegui_slave(seq IN NUMBER, funzione IN VARCHAR2, p_param IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_alterTable(seq IN NUMBER, p_ext_table IN VARCHAR2, p_dir IN VARCHAR2, p_file IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_execute(p_param1 IN VARCHAR2, p_param2 IN VARCHAR2, p_param3 IN VARCHAR2, p_param4 IN VARCHAR2) RETURN BOOLEAN;
    --v1.1
    FUNCTION fnd_mcre0_chiudi_portale return number;
    FUNCTION fnd_mcre0_apri_portale return number;
    --v1.2
    FUNCTION fnd_mcre0_controlli return number;
    FUNCTION fnd_mcre0_controlli2 return number;
    --v.15
    FUNCTION fnd_mcre0_analyzeWeekly return number;
    
    
END PKG_MCRE0_UTILS;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_UTILS FOR MCRE_OWN.PKG_MCRE0_UTILS;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_UTILS FOR MCRE_OWN.PKG_MCRE0_UTILS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_UTILS TO MCRE_USR;

