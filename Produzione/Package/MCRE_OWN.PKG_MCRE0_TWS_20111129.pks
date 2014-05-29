CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_TWS_20111129 AS
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
   1.4        24/08/2011  Luca Ferretti     Modifiche per attività tuning Goitre/Murro   
   1.5        06/10/2011  Luca Ferretti     Inserimento progressivo per log
   1.6        14/10/2011  Luca Ferretti     Aggiornamento log
   1.7        14/10/2011  Luca Ferretti     Spalmamento Alert
   1.8        14/10/2011  Luca Ferretti     Aggiunta Clean Alert post-alert
   1.9        18/10/2011  Luca Ferretti     Correzione log e eliminazione doppio calcolo ALERT
   2.0        16/11/2011  Luca Ferretti     Aggiunta controlli dopo apertura portale
   2.1        21/11/2011  M.Murro           Accodato ex L5G1 L5G7 e L5G8 a L4G1 (AnaGen e uscite)
   2.2        22/11/2011  Luca Ferretti     Modifica controlli post apertura portale
******************************************************************************/

    ko number := 1;
    ok number := 0;
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
    FUNCTION TWS_MCRE0_LIVELLO4_G1 return number;
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
END PKG_MCRE0_TWS_20111129;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_TWS_20111129 FOR MCRE_OWN.PKG_MCRE0_TWS_20111129;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_TWS_20111129 FOR MCRE_OWN.PKG_MCRE0_TWS_20111129;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_TWS_20111129 TO MCRE_USR;

