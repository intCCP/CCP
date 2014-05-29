CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_EST_FILE_GUIDA_ARRG AS
/******************************************************************************
   NAME:       PKG_MCRE0_EST_FILE_GUIDA_ARRG
   PURPOSE: Copia di PKG_MCRE0_ESTENDI_FILE_GUIDA2 per test caricamento file guida e all_data per aree e regioni 
   T_MCRE0_TMP_LISTA_STORICO VIENE USATA SOLO QUI?
******************************************************************************/

   c_package   CONSTANT VARCHAR2 (50) := 'PKG_MCRE0_EST_FILE_GUIDA_ARRG';
   c_file_guida CONSTANT VARCHAR2(45) := 'FILE_GUIDA';
   c_tavoli     CONSTANT VARCHAR2(6)  := '011901';

   --prerequisito
   FUNCTION update_file_guida_pre(p_storico number default 0) return number;

   --lancia in sequesnza le procedure seguenti
   FUNCTION update_file_guida(p_storico number default 0) return number;

   --annulla i campi 'prenotati' eventualmente rimasti senza conferma
   PROCEDURE rimuovi_prenotazioni(activ_id number);

   -- valorizzo i campi codice Gruppo Economico e Gruppo Legame
   PROCEDURE set_cod_ge_gl(activ_id number);

   -- determino il codice collegamento
   PROCEDURE calc_cod_collegamento(activ_id number);

   -- calcolo il comparto
   PROCEDURE calc_comparto(activ_id number);

   --aggiorna i dati di riportafogliazione
   PROCEDURE check_riportafogliazione(activ_id number);

   --inserisce i record riportafogliati nella tabella temporanea per lo storico mattutino
   PROCEDURE storicizza_riportafogliati(activ_id number);

   --aggiorno gestore e comparto assegnato per i nuovi collegati arrivati in giornata
   procedure aggiorna_nuovi_collegati (p_data DATE, activ_id number);

   --ripulisce gestore e COMPARTO da ogni gruppo senza più posizioni in mople
   FUNCTION update_uscita_CCP RETURN NUMBER;

   --v2.3: ripulisce comparto e gestore se le uniche posizioni in mople non sono in stati gestiti
   PROCEDURE disassegna_stati_non_gestiti(activ_id number);

   --v2.3: Forza il comparto Assegnato ai collegati a Bonis non gestiti..
   --Function  assegna_comparto_GB(seq number)  return number;

   --v2.5: Forza il comparto Assegnato alle posizioni Avocate e collegati a Bonis non gestiti
   Function  assegna_comparto_GB_AV(seq number)  return number;

END PKG_MCRE0_EST_FILE_GUIDA_ARRG;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_EST_FILE_GUIDA_ARRG FOR MCRE_OWN.PKG_MCRE0_EST_FILE_GUIDA_ARRG;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_EST_FILE_GUIDA_ARRG FOR MCRE_OWN.PKG_MCRE0_EST_FILE_GUIDA_ARRG;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_EST_FILE_GUIDA_ARRG TO MCRE_USR;

