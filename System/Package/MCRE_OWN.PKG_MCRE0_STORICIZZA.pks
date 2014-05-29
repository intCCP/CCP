CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_STORICIZZA" AS
/******************************************************************************
   NAME:       PKG_MCRE0_STORICIZZA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/10/2010          M.Murro. Created this package.
   2.0        23/11/2010          M.Murro. Uso MV, campio gestione flag
   2.1        08/02/2011          M.Murro. fix storicizza operatore_ins_upd
   2.2        21/02/2011          M.Murro. storicizza mese
   3.0        07/03/2011          M.Murro  Storico esteso da nuova ana_gen
   3.1        05/04/2011          M.Murro  Nuova gestione flg_stato 2, storico mensile non su 1900
   3.2        19/04/2011          M.Murro  Fix cursore variati su storico caricamenti
   3.3        22/04/2011          M.Murro  Fix storicizzazione con filtro su max(id_dper)
   3.4        04/05/2011          M.Murro  Aggiunta gestione CR e Servizio
   3.5        16/06/2011          M.Murro  Aggiunta cod_sag
   3.6        30/06/2011          M.Murro  sostituita Log_error!
   3.7        11/07/2011          M.Murro  integrati nuyovi campi PCR
   4.0        25/07/2011          M.Murro  TUNING.. campo fine_val_tr
******************************************************************************/

  c_package  CONSTANT VARCHAR2(50) := 'PKG_MCRE0_STORICIZZA';
  c_mese     CONSTANT VARCHAR2(1) := 'M';
  c_gestore  CONSTANT VARCHAR2(1) := 'G';
  c_comparto CONSTANT VARCHAR2(1) := 'C';
  c_stato    CONSTANT VARCHAR2(1) := 'S';

  ok number := 1;
  ko number := 0;

  --funzione per calcolare l'ultimo operatore che effettua un aggiornamento
--  function get_operatore_last_upd(p_abi_cart varchar2, p_ndg varchar2) return varchar2;

  -- salva lo stato generale per tutti i settoriali di un SNDG - no commit
  --v3.1 aggiunti par. ABI e NDG per gesstire fl a 1 o 2
  FUNCTION insert_storico_sndg(p_abi_cart IN varchar2, p_ndg IN varchar2, p_sndg IN varchar2, p_fl_comparto varchar2, p_fl_gestore varchar2, p_fl_stato varchar2, p_fl_mese varchar2) return number;

  -- salva lo stato generale per singolo abi/ndg - no commit
  FUNCTION insert_storico_ndg(p_abi_cart IN varchar2, p_ndg IN varchar2, p_fl_comparto varchar2, p_fl_gestore varchar2, p_fl_stato varchar2, p_fl_mese varchar2) return number;

  -- salva lo stato generale per singolo abi/ndg CON I DATI DELLA MV non aggiornati - no commit
  FUNCTION insert_storico_caricamenti_ndg(p_abi_cart IN varchar2, p_ndg IN varchar2, p_fl_comparto varchar2, p_fl_gestore varchar2, p_fl_stato varchar2, p_fl_mese varchar2, p_cod_mese_hst number, seq number) return number;

  --storicizzo le variazioni del mattino
  FUNCTION storicizza_caricamenti(seq number) return number;


   FUNCTION storicizza_mese(seq number) return boolean;


END PKG_MCRE0_STORICIZZA;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_STORICIZZA FOR MCRE_OWN.PKG_MCRE0_STORICIZZA;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_STORICIZZA FOR MCRE_OWN.PKG_MCRE0_STORICIZZA;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_STORICIZZA TO MCRE_USR;

