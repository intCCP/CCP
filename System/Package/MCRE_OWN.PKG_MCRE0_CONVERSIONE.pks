CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_CONVERSIONE AS
/******************************************************************************
   NAME:       PKG_MCRE0_CONVERSIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/10/2010  Chiara Giannangeli  Created this package.
   1.1        25/02/2011  Chiara Giannangeli  Archivi CR
   1.2        24/05/2011  Luca Ferretti       Archivio ANADIP
   1.3        17/01/2012  Andrea_Galliano     Aggiunta caricamento DTA_NASCITA su Anagrafica di gruppo
******************************************************************************/

    c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_CONVERSIONE';


    FUNCTION FND_MCRE0_CONVERT_ABI_ELAB(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_FILE_GUIDA(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_GRUPPO_ECO(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_LEGAME(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_MOPLE(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_PCR_SC_SB(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_PERCORSI(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_ANAGR_GRP(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_RATE_ARR(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_SAG (seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_SAB_XRA (seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_ANAGR_GRE (seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_PCR_GB (seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_PCR_GE_SB (seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_RICH_MON(seq IN NUMBER) RETURN BOOLEAN;

    FUNCTION FND_MCRE0_CONVERT_IRIS(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_PCR_LEGAME(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_PEF(seq IN NUMBER) RETURN BOOLEAN;

    --ARCHIVI CR
    FUNCTION FND_MCRE0_CONVERT_CR_SC_GB (seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_CR_GE_GB(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_CR_LG_GB(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_CR_GE_SB(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_CR_SC_SB(seq IN NUMBER) RETURN BOOLEAN;

    --ARCHIVIO ANADIP
    FUNCTION FND_MCRE0_CONVERT_ANADIP(seq IN NUMBER) RETURN BOOLEAN;

    FUNCTION FND_MCRE0_CONVERT_PREGIUDIZIEV(seq IN NUMBER) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_CONVERT_EMAIL(seq IN NUMBER) RETURN BOOLEAN;
END PKG_MCRE0_CONVERSIONE;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CONVERSIONE FOR MCRE_OWN.PKG_MCRE0_CONVERSIONE;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CONVERSIONE FOR MCRE_OWN.PKG_MCRE0_CONVERSIONE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CONVERSIONE TO MCRE_USR;

