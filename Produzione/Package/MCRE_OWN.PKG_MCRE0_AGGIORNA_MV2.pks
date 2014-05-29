CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_AGGIORNA_MV2" AS
/******************************************************************************
NAME:       PKG_MCRE0_AGGIORNA_MV2
PURPOSE:    aggiorna le diverse Materialized View

REVISIONS:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        29/11/2010          M.Murro. Created this package.
1.1        23/12/2010          N.Nurro  Aggiunte nuove MV V_
2.0        11/01/2011  V.Galli M.Murro  Aggiunta gestione MV FAST
2.1        13/01/2011          M.Murro  Aggiunta gestione mv_last_percorso
2.2        21/01/2011          V.Galli   First Fast
2.3        26/01/2011          V.Galli   Grant x LOG
2.4        01/02/2011          V.Galli   Aggiorna Istituti + log
2.5        07/02/2011          V.Galli   Aggiorna uscite man e aut
2.6        14/02/2011          V.Galli   Flg_outsourcing in Log Upd_Field
2.7        22/03/2011          V.Galli   Refresh MV RIO
2.8        27/04/2011          M.Murro   Rimosso drop e create log su istituti
2.9        03/05/2011          V.Galli   aggiorna_CR
2.9        06/05/2011          V.Galli   aggiorna_CR RI SC SO
3.0        18/05/2011          M.Murro   Variato Atomic_refresh su Ana_Gen
3.1        23/05/2011          V.Galli   Aggiunta creazione LOG per GB_GESTIONE
3.2        25/05/2011          V.Galli   Aggiunta refresh all CR per cambio mense
3.3        26/05/2011          V.Galli   Create/Drop log GB_GESTIONE
3.4        27/05/2011          V.Galli   Nuovo Log
3.5        31/05/2011          V.Galli   Nuovo gruppo Fast
3.5        08/06/2011          V.Galli   Nuovi Log MP-GB-ALL
3.6        08/06/2011          V.Galli   Cambiata logica LOG
3.7        15/06/2011          M.Murro   Nuova Ana_Gen
3.8        17/06/2011          V.Galli    Log new PCR con cartolarizzato
4.0        25/07/2011          M.Murro   TUNING - nuova struttura
4.1        26/08/2011          M.Murro   versione ponte con doppia AnaGen
4.2        06/10/2011          M.Murro   inibita calcolo CR_ALL
4.3        21/11/2011          M.Murro   Variato Atomic_refresh su RioEsp, Mon e Uscite
4.4        07/12/2011          P.Goitre  Introdotte aggiorna_RIO_ESP, aggiorna_RIO_ESP_ANN e aggiorna_USCITE
4.5        15/11/2012          M.Murro   Esteso aggiorna_USCITE
4.6        16/11/2012          V.Galli      Riscritta insert in aggiorna_USCITE
4.7        23/01/2013          I.Gueorguieva Aggiunto campo cod_livello nella insert di aggiorna_USCITE_AUT
******************************************************************************/

c_package  CONSTANT VARCHAR2(50) := 'PKG_MCRE0_AGGIORNA_MV2';
ok number := 1;
ko number := 0;

--4.1 rimane per la shell delle 23: chiama anche le Restore Guida e Mople
FUNCTION aggiorna_AnaGen(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--4.1 aggiorna la MV Anagrafica_Generale (originale, ex aggiorna_AnaGen)
FUNCTION aggiorna_AnaGenETL(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la MV_MCRE0_APP_PCR_GB_AGGR
FUNCTION aggiorna_PCR_GB(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la MV_MCRE0_APP_PCR_GE_SB_AGGR
FUNCTION aggiorna_PCR_GE(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la MV_MCRE0_APP_PCR_SC_SB_AGGR
Function Aggiorna_Pcr_Sc(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) Return Number;

--Aggiorna La Mv_Mcre0_App_Istituti
FUNCTION aggiorna_ISTITUTI(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la V_MCRE0_APP_ELENCO_POS
FUNCTION aggiorna_ELENCO_POS(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la V_MCRE0_APP_HP_EXCEL
FUNCTION aggiorna_HP_EXCEL(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la V_MCRE0_APP_POSIZIONI_STATO
FUNCTION aggiorna_POSIZIONI_STATO(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la V_MCRE0_APP_LAST_PERCORSO
FUNCTION aggiorna_LAST_PERCORSO(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--load delle tabelle MV_MCRE0_APP_PT_POS_USCITE_AUT e MV_MCRE0_APP_PT_POS_USCITE_MAN
FUNCTION aggiorna_USCITE(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la MV_MCRE0_APP_RIO_MONITORAGGIO
FUNCTION aggiorna_RIO_MONITORAGGIO(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la MV_MCRE0_APP_RIO_ESP_SC e MV_MCRE0_APP_RIO_ESP_GE
FUNCTION aggiorna_RIO_ESP(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la MV_MCRE0_APP_RIO_ESP_SC_ANN e MV_MCRE0_APP_RIO_ESP_GE_ANN
FUNCTION aggiorna_RIO_ESP_ANN(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la MV_MCRE0_DENORM_STR_ORG
function AGGIORNA_DENORM_STR_ORG(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la MV_MCRE0_APP_CR
function AGGIORNA_CR(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la MV_MCRE0_APP_CR_RI
FUNCTION aggiorna_CR_RI(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la MV_MCRE0_APP_CR_SC
FUNCTION aggiorna_CR_SC(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--aggiorna la MV_MCRE0_APP_CR_SO
FUNCTION AGGIORNA_CR_SO(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER;

--aggiorna tutte le MV di CR solo quando cambia il mese CR
FUNCTION AGGIORNA_CR_ALL(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) RETURN NUMBER;

--aggiorna la MV_MCRE0_APP_POS_STATO_ST
FUNCTION aggiorna_POS_STATO_ST(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

-- aggiornamento FAST -- da chiamare da portale
FUNCTION REFRESH_FAST_SNP(
P_COD_LOG T_MCRE0_WRK_AUDIT_APPLICATIVO.ID%TYPE DEFAULT NULL,
P_UTENTE  T_MCRE0_APP_UTENTI.COD_MATRICOLA%TYPE DEFAULT NULL
) return number;

-- aggiornamento FAST -- da Lancia_Tutto (ETL_Secondo_Livello)
FUNCTION refresh_first_fast_snp(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--refresh complete
FUNCTION refresh_complete_snp(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--cancella i log
FUNCTION drop_snp_log(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

--ricrea i log
FUNCTION create_snp_log(
P_COD_LOG T_MCRE0_WRK_AUDIT_ETL.ID%TYPE DEFAULT NULL
) return number;

END PKG_MCRE0_AGGIORNA_MV2;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_AGGIORNA_MV2 FOR MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_AGGIORNA_MV2 FOR MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_AGGIORNA_MV2 TO MCRE_USR;

