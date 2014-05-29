CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_TWS" AS
/******************************************************************************
   NAME:       PKG_MCR0_TWS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        30/03/2011  Luca Ferretti     Created this package.
   1.1        13/06/2011  Luca Ferretti     Aggiornamento funzione di log e ristruttuturazione chiamate
   1.2        21/06/2011  Luca Ferretti     Modifica valore di uscita
   1.3        07/07/2011  M.Murro           aggiunta gestione GB/AV
   1.4        24/08/2011  Luca Ferretti     Modifiche per attivit¿ tuning Goitre/Murro
   1.5        06/10/2011  Luca Ferretti     Inserimento progressivo per log
   1.6        14/10/2011  Luca Ferretti     Aggiornamento log
   1.7        14/10/2011  Luca Ferretti     Spalmamento Alert
   1.8        14/10/2011  Luca Ferretti     Aggiunta Clean Alert post-alert
   1.9        18/10/2011  Luca Ferretti     Correzione log e eliminazione doppio calcolo ALERT
   2.0        16/11/2011  Luca Ferretti     Aggiunta controlli dopo apertura portale
   2.1        21/11/2011  M.Murro           Accodato ex L5G1 L5G7 e L5G8 a L4G1 (AnaGen e uscite)
   2.2        22/11/2011  Luca Ferretti     Modifica controlli post apertura portale
   2.3        19/12/2011  Paola Goitre      PKG 2
   2.4        20/12/2011  Luca Ferretti     Rimesse in serie MOPLE e FILE_GUIDA
   2.5        17/01/2012  Luca Ferretti     Modifica ordine esecuzione per test in system di caricamento in parallelo (modifiche Paola).
   2.6        20/01/2012  Luca Ferretti     Aggiunta Refresh Aggregate per M.Murro
   2.7        13/02/2012  Paola Goitre      Spostato ini(alert da 1_4 a 4_1)
   2.8        16/02/2012  Luca Ferretti     Eliminazione Analyze PCR e CR in secondo livello
   2.9        23/03/2012  Luca Ferretti     Nuova PCR di Paola (PCR3)+PCR_RAPP_AGGR
   3.0        02/04/2012  Luca Ferretti     Aggiunto livello 3_12, 3_13 e 3_14 per PCR in parallelo (nuovo albero schedulazione)
                                            Aggiunto livello 3_22, 3_23, 3_24, 3_25, 3_26 per CR in parallelo (nuovo albero schedulazione)
                                            Aggiunto livello da 5_01 a 5_31 per livello ALERT in parallelo.
   3.1        26/06/2012  Luca Ferretti     Commentata invocazione a ESTENDI_MOPLE.UPD_GB_STATUS
   3.2        02/08/2012  Luca Ferretti     Aggiunta procedura per scrittura file con errore e passi da intraprendere
   3.3        20/08/2012  Luca Ferretti     Eliminata chiamata a package controlli
   3.4        26/09/2012  Luca Ferretti     Migliorata gestione eccezione
   3.5        08/10/2012  Luca Ferretti     Modifica gestione eccezioni su svecchiamento (tolto return errore e lasciata solo la segnalazione)
   3.6        06/11/2012  Valeria Galli     Aggiunto nuovo calcolo alert
   3.7        27/11/2012  Luca Ferretti     Rimosso controllo esito procedura PKG_MCREI_REFRESH_AGGREGATE.FNC_UPD_RATE_IMPAGATE (non bloccante)
   3.8        06/12/2012  Luca Ferretti     Aggiunta controllo POST_ETL
   3.9        10/12/2012  Valeria Galli     Nuova gestione alert
   3.10       12/12/2012  I.Gueorguieva     Gestione Alert MCREI
   3.11       17/12/2012  Luca Ferretti     Modifica log livello 1_3
   3.12       07/01/2013  Valeria Galli     Commentata nuova gestione alert post controlli
   3.13       09/01/2013  Federico Galletti Aggiunto la procedura per la copia della all_data e spostato l'apertura del portale al livello 5g_10
   3.14       09/01/2012  I.Gueorguieva     Commentata chiamata MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ.SPO_MCRE0_CONTROLLO_POST_ETL in attesa che venga portato il PKG
   3.15       15/01/2013  F.Galletti        Fix nella procedura copy all data
   3.16       05/02/2013   F. Galletti      Spostato la truncate del tmp_storico al livello 4g1 ed inserito le modifiche commentate per il nuovo albero di schedulatura
   3.17       11/04/2013   M.Murro          aggiunta fill-all_data_day chiamata in Apri_portale
   3.18       24/04/2013   M.Murro          aggiunta gestione soff nn in portafoglio chiamata in Apri_portale
   4.0        06/02/2014   M.Murro          -switch etl: non apre il portale
   4.1        10/02/2014   M.Murro          -switch etl: riapre il portale + insert esplicita all_data%
******************************************************************************/
    ko number := 1;
    ok number := 0;
    eccezione_interna EXCEPTION;
    PROCEDURE TWS_MCRE0_COPY_ALL_DATA;
    FUNCTION TWS_MCRE0_FILL_ALL_DATA_DAY return number;
    FUNCTION TWS_MCRE0_CHIUDI_PORTALE return number;
    FUNCTION TWS_MCRE0_APRI_PORTALE return number;
    FUNCTION TWS_MCRE0_CHECK_ABI_ELAB return number;
    FUNCTION TWS_MCRE0_LIVELLO1_G1 return number;
    FUNCTION TWS_MCRE0_LIVELLO1_G2 return number;
    FUNCTION TWS_MCRE0_LIVELLO1_G3 return number;
    FUNCTION TWS_MCRE0_LIVELLO1_G4 return number;
    FUNCTION TWS_MCRE0_LIVELLO2_G1 return number;
    FUNCTION TWS_MCRE0_LIVELLO3_G1 return number;
    FUNCTION TWS_MCRE0_LIVELLO3_G2 return number;
    FUNCTION TWS_MCRE0_LIVELLO3_G12 return number;
    FUNCTION TWS_MCRE0_LIVELLO3_G13 return number;
    FUNCTION TWS_MCRE0_LIVELLO3_G14 return number;
    FUNCTION TWS_MCRE0_LIVELLO3_G22 return number;
    FUNCTION TWS_MCRE0_LIVELLO3_G23 return number;
    FUNCTION TWS_MCRE0_LIVELLO3_G24 return number;
    FUNCTION TWS_MCRE0_LIVELLO3_G25 return number;
    FUNCTION TWS_MCRE0_LIVELLO3_G26 return number;
    FUNCTION TWS_MCRE0_LIVELLO4_G1 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G01 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G02 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G03 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G04 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G05 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G06 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G07 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G08 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G09 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G10 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G11 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G12 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G13 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G14 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G15 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G16 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G17 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G18 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G19 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G20 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G21 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G22 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G23 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G24 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G25 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G26 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G27 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G28 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G29 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G30 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G31 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G1 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G2 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G3 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G4 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G5 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G6 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G7 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G8 return number;
    FUNCTION TWS_MCRE0_LIVELLO5_G9 return number;
    FUNCTION TWS_MCRE0_LIVELLO6_G1 return number;
    FUNCTION TWS_MCRE0_LIVELLO8_G1 return number;

-------ALERT MCREI--------
    FUNCTION TWS_MCRE0_LIVELLO9_G0 return number;
    FUNCTION TWS_MCRE0_LIVELLO9_G1 return number;
    FUNCTION TWS_MCRE0_LIVELLO9_G2 return number;
    FUNCTION TWS_MCRE0_LIVELLO9_G3 return number;
    FUNCTION TWS_MCRE0_LIVELLO9_G4 return number;
    FUNCTION TWS_MCRE0_LIVELLO9_G5 return number;

    PROCEDURE MCRE0_WRITE_ERRORS (errore IN VARCHAR2, v_file IN VARCHAR2, sequenza IN NUMBER default -666);
END PKG_MCRE0_TWS;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_TWS FOR MCRE_OWN.PKG_MCRE0_TWS;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_TWS FOR MCRE_OWN.PKG_MCRE0_TWS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_TWS TO MCRE_USR;

