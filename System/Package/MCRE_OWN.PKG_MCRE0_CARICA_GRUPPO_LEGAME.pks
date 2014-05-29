CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_CARICA_GRUPPO_LEGAME" AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALIMENTAZIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        06/10/2010  Marco Murro        Created this package.
   1.1        24/11/2010  Marco Murro        Filtrato cursore legami con IDDPER
   1.2        01/03/2011  Marco Murro        Variata svecchia GE (evito doppi capogruppo)
   1.3        01/03/2011  Marco Murro        Variata svecchia GE (ripensato lo svecchiamento)
   1.4        01/03/2011  Marco Murro        Variata svecchia LEG (pulizia su File Guida)
   1.5        22/04/2011  Marco Murro        Variata svecchia GE (potenziato lo svecchiamento)
   1.6        27/03/2012  Paola Goitre       Aggiunta gestione dei flag flg_gruppo_economico e flg_gruppo_legame
******************************************************************************/

    c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_CARICA_GRUPPO_LEGAME';
    c_file_legame CONSTANT VARCHAR2(45) := 'LEGAME';
    c_file_ge CONSTANT VARCHAR2(45) := 'GRUPPO_ECONOMICO';
    c_file_guida CONSTANT VARCHAR2(45) := 'FILE_GUIDA';

    FUNCTION SVECCHIA_LEGAMI return number;

    FUNCTION SVECCHIA_GE  return number;

    FUNCTION LOAD_FULL_GRUPPO_LEGAME  return number;

--    PROCEDURE AGGIORNA_GRUPPO_LEGAME;

END PKG_MCRE0_CARICA_GRUPPO_LEGAME;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CARICA_GRUPPO_LEGAME FOR MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CARICA_GRUPPO_LEGAME FOR MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CARICA_GRUPPO_LEGAME TO MCRE_USR;

