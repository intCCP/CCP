CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_ESTENDI_FILE_GUIDA2" AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALIMENTAZIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        11/10/2010  Marco Murro        Created this package.
   1.1        24/11/2010  Marco Murro        filtri per IDDPER attivo
   1.2        02/12/2010  Marco Murro        aggiornata update_file_guida x filtrare il primo caricamento
   1.3        13/12/2010  Marco Murro        Aggiunto gestione Ramo (al posto di comparto)
   1.4        09/02/2011  Marco Murro        fix gestione gl-ge-flg
   1.5        14/02/2011  Marco Murro        estesa fix a superGruppo
   1.6        15/02/2011  Marco Murro        aggiorna nuovi collegati --> check su dta_upd
   1.7        22/02/2011  M.Murro Gianna     aggiunta pulizia posizioni uscite
   1.8        01/03/2011  Marco Murro        fix rimuovi prenotazione - annulla anche sezione
   1.9        07/03/2011  Marco Murro        check riportafogliazione solo in uscita da tavoli
   2.0        24/03/2011  Marco Murro        fix check riportafogliazione e storico riport.
   2.1        12/04/2011  Marco Murro        variato nuovi collegati
   2.2        09/05/2011  Marco Murro        semplificata Riportafogliazione + inizializzazione servizio
   2.3        24/05/2011  Marco Murro        aggiunta pulizia comparto per stati non gestiti + GB (fix 06.06)
   2.4        14/06/2011  Marco Murro        migliorie per performance
   2.5        04/07/2011  Marco Murro        Assegnazione comparto x Avocazioni
   3.0        18/07/2011  Marco Murre        Nuove strutture per tuning
   3.11       22/09/2011  Marco Murre        fix gestione flag, cambio nuovi ingressi
   3.12       19/10/2011  Paola Goitre       modificate set_cod_ge_gl,calc_cod_collegamento,calc_comparto,aggiorna_nuovi_collegati
   3.13       19/10/2011  Marco Murro        ripristinata calc_comparto
   3.2        28/10/2011  Marco Murre        Fix uscite automatiche: check sui soli outsourcing
   3.3        16/11/2011  Marco Murre        Fix assegnaCompartiGB - distinct!
   3.4        27/03/2012  Paola Goitre       aggiunta condizione selettiva di Silvio Bellani su calc_cod_collegamento
   4.0        21/05/2012  Marco Murro        Trascinamenti configurabili
   4.1        21/05/2012  Valeria Galli      Commenti con label:   VG - CIB/BDT - INIZIO
   4.2        08/11/2012  Luca Ferretti      Modifica update_file_guida_pre update solo del today_flg
   4.3        08/11/2012  Luca Ferretti      Aggiornamento log
   4.4        12/11/2012  Marco Murro        Aggiornamento disassegna-non_gestiti x GB
   4.5        21/11/2012  Marco Murro        fix aggiorna nuovi collegati per utente più vecchio
   5.0        23/11/2012  Emiliano Pellizzi  modifica calc_comparto con aggiunta calcolo cod_gruppo_super di AR e RG
   5.1        26/06/2013  Marco Murro        fix disassegna + gruppo_super_old
   5.2        20/08/2013  Marco Murro        fix disassegna x SO
*******************************************************************************/

   c_package   CONSTANT VARCHAR2 (50) := 'PKG_MCRE0_ESTENDI_FILE_GUIDA2';
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

END PKG_MCRE0_ESTENDI_FILE_GUIDA2;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ESTENDI_FILE_GUIDA2 FOR MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA2;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ESTENDI_FILE_GUIDA2 FOR MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA2;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ESTENDI_FILE_GUIDA2 TO MCRE_USR;

