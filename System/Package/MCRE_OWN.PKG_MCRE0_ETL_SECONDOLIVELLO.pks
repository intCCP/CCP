CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_ETL_SECONDOLIVELLO AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALIMENTAZIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        24/11/2010  Marco Murro        Created this package.
   1.1        26/11/2010  Valeria Galli      Pkg generalizzato
   1.3        17/12/2010  Valeria Galli      Aggiunto calcolo dta_dec_stato_pre
   1.4        13/01/2011  VMarco Murro       rimossa scheda_anag_mov, aggiunto last_percorso
   1.5        21/01/2011  Valeria Galli      MV LOG create e fast refresh e cambio controllo
   1.6        01/02/2011  Valeria Galli      Aggiorna Istituti
   1.7        07/02/2011  Valeria Galli      Aggiorna Uscite Man/Aut+ commentato last_percorsi
   1.8        14/02/2011  Marco Murro        Aggiunto check su Abi_elaborati
   1.9        14/02/2011  M.Murro Gianna     Aggiunta chiamata a USCITA_CCP e storicizzazione mensile
   2.0        23/03/2011  C.Giannangeli      Aggiunta inizializzazione tabella T_MCRE0_WRK_SENDING_FILES
   2.1        31/03/2011  M.Murro            Aggiunta chiamata refresh MV Rio
   2.2        06/04/2011  V.Galli             Delete PT e RIO
   2.3        19/04/2011  C.Giannangeli      Aggiunta chiamata a PKG_MCRE0_ASS_AUTOM
   2.4        26/04/2011  M.Murro            Calcolo statistiche su FG e Mople + nuovo audit
   2.5        06/05/2011  M.Murro            Aggiunta riapertura portale + CR
   2.6        24/05/2011  M.Murro            Aggiunta Gestione Bonis
   2.7        25/05/2011  V.Galli            AGGIORNA_CR_ALL
   2.8        27/05/2011  V.Galli            nuovo log
   2.9        16/06/2011  M.Murro            abilitata GB
   3.0        07/07/2011  M.Murro            procedure unica per assegna comparto GB e AVocazione
   3.1        25/07/2011  M.Murro            variata gestione estendi Mople e FGuida
   4.0        05/08/2011  M.Murro            versione post Tuning
   4.1        26/08/2011  M.Murro            rimossa fase restore (anticipata) e anticipata ana_gen su RIO_esp
   4.2        30/08/2011  M.Murro            ana_genETL...
******************************************************************************/

  c_package CONSTANT VARCHAR2(50) := 'pkg_mcre0_etl_secondolivello';

  ok number := 1;
  ko number := 0;
  in_attesa number := -1;

  -- Procedura per controllo fine caricamenti
  -- INPUT :
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori
  FUNCTION FNC_CHECK_END_LOADING(
    P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
  )return number ;

  -- Procedura esecuzione ETL secondo livello
  -- INPUT :
  --    p_storico 0 giornaliero, 1 storico
  -- OUTPUT :
  --    stato esecuzione 1 OK 0 Errori -1 caricamenti non ancora terminati
  FUNCTION FNC_LANCIA_TUTTO(
    P_STORICO NUMBER DEFAULT 0
  ) return number;


END PKG_MCRE0_ETL_SECONDOLIVELLO;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ETL_SECONDOLIVELLO FOR MCRE_OWN.PKG_MCRE0_ETL_SECONDOLIVELLO;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ETL_SECONDOLIVELLO FOR MCRE_OWN.PKG_MCRE0_ETL_SECONDOLIVELLO;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ETL_SECONDOLIVELLO TO MCRE_USR;

