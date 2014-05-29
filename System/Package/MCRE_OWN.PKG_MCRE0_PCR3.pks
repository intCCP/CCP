CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_PCR3" AS
/******************************************************************************
NAME:     PKG_MCRE0_PCR3
PURPOSE: Gestione alert ed evidenze

REVISIONS:
Ver        Date        Author             Description
---------  ----------  -----------------  ------------------------------------ 
1.0 07/06/2011 Galli Valeria Created this package.
1.1 09/06/2011 Galli Valeria Tabella T_mcre0_app_PCR e LOG
2.0 08/08/2011 Marco Murro Aggiunta Gestioen today_flg - tuning!
2.1 02/09/2011 Marco Murro Fix Gestioen today_flg - tuning!
2.2 05/09/2011 Marco Murro Fix gb_merge per sndg variati
2.3 06/09/2011 Marco Murro Fix merge per sndg variati + gestione ko
2.4 18/10/2011 Luca Ferretti Modifiche Paola..
3.0 16/03/2012 Paola Goitre versione senza merge senza update e senza delete
3.1 02/04/2012 Paola Goitre variato e fixato calcolo MAU con derivati
******************************************************************************/

ok number := 1;
ko number := 0;


-- Procedura per calcolo pcr: MAIN
-- INPUT :
-- OUTPUT :
--    stato esecuzione 1 OK 0 Errori
FUNCTION fnc_load_pcr (
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
RETURN NUMBER;

-- Procedura per calcolo pcr scsb 
--    stato esecuzione 1 OK 0 Errori
FUNCTION fnc_load_pcr_scsb_merge (
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
RETURN NUMBER;

-- Procedura per calcolo pcr gesb 
--    stato esecuzione 1 OK 0 Errori
FUNCTION fnc_load_pcr_gesb_merge (
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
RETURN NUMBER;

-- Procedura per calcolo pcr gb 
--    stato esecuzione 1 OK 0 Errori
FUNCTION fnc_load_pcr_gb_merge (
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
RETURN NUMBER;

-- Procedura per load della tabella di working, che conterrà la PCR definitiva 
FUNCTION fnc_load_pcr_wrk (
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
RETURN NUMBER;  

-- Procedura per swap della tabella di working con PCR definitiva 
-- (rename)+ create index su PCR
--    drop index su WRK
FUNCTION fnc_swap_pcr_wrk (
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL )
RETURN NUMBER;  
 
END PKG_MCRE0_PCR3;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_PCR3 FOR MCRE_OWN.PKG_MCRE0_PCR3;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_PCR3 FOR MCRE_OWN.PKG_MCRE0_PCR3;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_PCR3 TO MCRE_USR;

