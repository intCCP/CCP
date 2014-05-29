CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCREI_ALERT_2" 
AS
   /******************************************************************************
    NAME:       pkg_mcrei_alert_2
    PURPOSE:

    REVISIONS:
    Ver        Date              Author             Description
    ---------  ----------      -----------------  ------------------------------------
    1.0        31/05/2012         E.Pellizzi         Created this package.
    1.1        27/08/2012         M.Murro            Procedura per Abi con lock
    1.2        24/10/2012         I.Gueorguieva      Procedura generazione query merge
    1.3        25/10/2012         i:gueorguieva      Query separate per calcolo posizione ed abi
    1.4        20/11/2012         I.Gueorguieva      Truncate(Delete per pos)/Insert per alert 1 e 32
    1.5        9/12/2012         i.gueorguieva       Chiamata calcola alert per abi agganciabile all'alimentazione MCREI  con log parlante per calcolo tempi
    1.6        12/12/2012         I.Gueorguieva      Aggiunta funzione calcolo ABI per blocchi
    1.7        04/01/2012         I.Gueorguieva      Modifica funzione calcolo Blocco per ABI con controllo sugli ABI arrivati
    1.8        15/05/2013        I.Gueorguieva      No Truncate per le partizioni/sottopartizioni per l'alert 1, 7, 32; calcola in tabella temporanea e merge 
    1.9        25/03/2014       M.Ceru               gestione automatica dei nuovi rapporti da valutare operativi: PCR_STIMA_AUTOM_RAP_OP ;PCR_STIMA_AUTOM_RAP_AL
 ******************************************************************************/
   c_package   CONSTANT VARCHAR2 (50) := 'pkg_mcrei_alert_2';
   ok                   NUMBER        := 1;
   ko                   NUMBER        := 0;
   c_liv_alert      NUMBER        := -5;
   pk_violata           EXCEPTION;
   PRAGMA EXCEPTION_INIT (pk_violata, -1);

   FUNCTION fnc_mcrei_calcola_all RETURN NUMBER;
   FUNCTION fnc_mcrei_calcolo_blocco(p_id_blocco IN NUMBER) RETURN NUMBER;
   FUNCTION fnc_mcrei_calcolo_id(p_id_alert IN NUMBER)RETURN NUMBER;
   FUNCTION fnc_mcrei_calcolo_id_pos ( p_id_alert   IN   NUMBER,p_cod_abi    IN   VARCHAR2,p_cod_ndg    IN   VARCHAR2
   )RETURN NUMBER;
   FUNCTION fnc_mcrei_calc_pos (p_cod_abi IN VARCHAR2, p_cod_ndg IN VARCHAR2)  RETURN NUMBER;
   FUNCTION fnc_mcrei_calc_abi (p_rec IN f_slave_par_type)  RETURN NUMBER;
   FUNCTION FNC_MCREI_CALC_ID_ABI(p_id_alert IN NUMBER, P_COD_ABI IN VARCHAR2) RETURN NUMBER;
   PROCEDURE PRC_MCREI_GEN_QUERY( P_ID_ALERT IN NUMBER,P_ABI IN VARCHAR2 DEFAULT NULL,P_NDG IN VARCHAR2 DEFAULT NULL,P_QRY OUT VARCHAR2);
   PROCEDURE PRC_GEN_QUERY_IN_TAB;
   
   PROCEDURE PCR_STIMA_AUTOM_RAP_OP;
   
   PROCEDURE PCR_STIMA_AUTOM_RAP_AL;
   
END pkg_mcrei_alert_2;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_ALERT_2 FOR MCRE_OWN.PKG_MCREI_ALERT_2;


CREATE SYNONYM MCRE_USR.PKG_MCREI_ALERT_2 FOR MCRE_OWN.PKG_MCREI_ALERT_2;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_ALERT_2 TO MCRE_USR;

