CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRES_ALIMENTAZIONE AS
  /******************************************************************************
  NAME:       PKG_MCRES_ALIMENTAZIONE
  PURPOSE:
  REVISIONS:
  Ver        Date        Author             Description
  ---------  ----------      -----------------  ------------------------------------
  1.0      08/07/2011  V.Galli       Created this package.
  1.1      28/07/2011  L.Ferretti    Aggiunta funzione alimenta_FL
  1.2      09/09/2011  V.Galli       Controllo Mensili/Giornaliere in caricamento FEN
  1.3      31/10/2011  V.Galli      Id_dper in FEN
  1.4      07/11/2011  V.Galli      Gestione LOCK
  1.5      09/11/2011  A.Galliano   Gestione val_annomese
  2.0      10/02/2012  V.Galli      Aggiornamento stato acquisizione in  nuova tabella T_MCRES_WRK_last_ACQUISIZIONE
                                    Aggiunta gestione partizionamento in tabelle FEN
                                    Aggiunto Lock a ST e truncate subpart invece di delete
  2.1      16/02/2012   A.Galliano  Funzioni per caricamento istituti non target
  2.2      29/02/2012   A.Galliano  Alimentazione St e APP per non target
  2.3      12/03/2012   V.Galli      APP mensili con partizione periodo
  2.4      12/03/2012   V.Galli      Aggiornamento fine primo livello T_MCRES_WRK_last_ACQUISIZIONE
  2.5      18/05/2012   A.Galliano   Aggiornamento fine primo livello T_MCRES_WRK_ANAGRAFICA_BILANCI
  2.5      18/05/2012   A.Galliano   Rimossa gestione T_MCRES_WRK_ANAGRAFICA_BILANCI
  2.6      25/09/2012   A.Galliano  Creata fnc_mcres_alimenta_app_inc
  2.7      15/10/2012   A.Galliano  Gestione flussi multibanca
  2.7.1    18/10/2012   A.Galliano  Fix gestione flussi multibanca
  2.7.2    23/10/2012   A.Galliano  Modifica v_note in alimenta_app_multi
  2.8       12/12/2012  V.Galli Alimenta_fl se qry_convert nulla allora 2 bind_var in execute qry_fl
  2.9       19/12/2012 V.Galli  Spool_file
  3.0       23/01/2013 V.Galli substr della qry nel log FL
  3.1       03/07/2013 V.Galli alimenta_app/st_multi aggiunto flg_daily T
  3.2       18/07/2013 V.Galli alimenta_fl_nt truncate per nome tabella fl
  3.4       03/10/2013 V.Galli copia mcrd in bilancio e sopravve
  3.5       15/01/2014 A.Pilloni merge spese EPC in app sp spese, app documenti ed sp_fatture
  3.6       07/02/2014 A. Pilloni modifica per epc rilanciabile su fatture e documenti (aggiunte delete)
  3.7       24/02/2014 A.Pilloni modifica per epc impostazione aliquota dinamica
  3.8       12/03/2014 A.Pilloni modifica per epc per aggiunta voce spese non imponibili
  3.9       13/03/2014 V.Galli gestione partizioni in copy_mcrd
  3.10     19/03/2014 V.Galli fun annullamneto del forfettarie
  3.11    27/05/2014 A.Pilloni aggiunte funzioni reload alert 40 fnc_reload_alert_rapp_da_volt, 41 fnc_reload_alert_delibere_ft,
             45 fnc_reload_alert_rapp_cmlt NB. (da richiamare come work around nel caso non funzionasse la chiamata in step elaborazione
             di ALIMENTA_FEN del package alimentazione)
  ******************************************************************************/

    C_PACKAGE CONSTANT VARCHAR2(50) := 'PKG_MCRES_ALIMENTAZIONE';
    OK NUMBER := 1;
    KO NUMBER := 0;

    PK_VIOLATA EXCEPTION;
    pragma exception_init(PK_VIOLATA, -1);

    FUNCTION FNC_MCRES_ALIMENTA_FL(P_REC IN F_SLAVE_PAR_TYPE) RETURN NUMBER;

    FUNCTION FNC_MCRES_ALIMENTA_ST(P_REC IN F_SLAVE_PAR_TYPE) RETURN NUMBER;

    FUNCTION FNC_MCRES_ALIMENTA_APP(P_REC IN F_SLAVE_PAR_TYPE) RETURN NUMBER;

    FUNCTION FNC_MCRES_ALIMENTA_TAPPI(P_REC IN F_SLAVE_PAR_TYPE) RETURN NUMBER;

    FUNCTION FNC_MCRES_ALIMENTA_FEN(P_REC IN F_SLAVE_PAR_TYPE) RETURN NUMBER;

    FUNCTION FNC_MCRES_ALIMENTA_FEN_PERIODI(
        P_COD_ABI T_MCRES_APP_SISBA_CP.COD_ABI%TYPE DEFAULT NULL,
        P_ID_DPER T_MCRES_APP_SISBA_CP.ID_DPER%TYPE default null
    ) RETURN NUMBER;

    FUNCTION FNC_MCRES_ALIMENTA_FEN_STORICO(P_REC IN F_SLAVE_PAR_TYPE) RETURN NUMBER;

--Gestione flussi istituti non target
    FUNCTION FNC_MCRES_ALIMENTA_FL_NT(P_REC IN F_SLAVE_PAR_TYPE) RETURN NUMBER;

    FUNCTION FNC_MCRES_ALIMENTA_ST_NT( P_REC IN F_SLAVE_PAR_TYPE) RETURN NUMBER;

    FUNCTION FNC_MCRES_ALIMENTA_APP_NT(P_REC IN F_SLAVE_PAR_TYPE) RETURN NUMBER;

--Per flussi comuni a incagli e sofferenze
    function fnc_mcres_alimenta_app_inc(p_rec IN  f_slave_par_type) return number;

--Gestione flussi multibanca
    function fnc_mcres_alimenta_fl_multi(p_rec in f_slave_par_type) return number;

    function fnc_mcres_alimenta_st_multi(p_rec in f_slave_par_type) return number;

    function fnc_mcres_alimenta_app_multi(p_rec in f_slave_par_type) return number;

    function fnc_mcres_spool_to_file (P_REC IN F_SLAVE_PAR_TYPE)return number;

    function fnc_mcres_copy_mcrd (P_REC IN F_SLAVE_PAR_TYPE)return number;

    function fnc_mcres_sopravve (P_REC IN F_SLAVE_PAR_TYPE)return number;

    function fnc_mcres_spese_epc (P_REC IN F_SLAVE_PAR_TYPE)return number;

    function fnc_annullamento_delibere( P_REC IN F_SLAVE_PAR_TYPE)return number;

    function fnc_reload_alert_rapp_da_volt( P_REC IN F_SLAVE_PAR_TYPE)return number;

    function fnc_reload_alert_delibere_ft( P_REC IN F_SLAVE_PAR_TYPE)return number;

    function fnc_reload_alert_rapp_cmlt( P_REC IN F_SLAVE_PAR_TYPE)return number;

--   function fnc_ges_raccolta_doc_step0 ( P_REC IN F_SLAVE_PAR_TYPE)return number;


END PKG_MCRES_ALIMENTAZIONE;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_ALIMENTAZIONE FOR MCRE_OWN.PKG_MCRES_ALIMENTAZIONE;


CREATE SYNONYM MCRE_USR.PKG_MCRES_ALIMENTAZIONE FOR MCRE_OWN.PKG_MCRES_ALIMENTAZIONE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_ALIMENTAZIONE TO MCRE_USR;

