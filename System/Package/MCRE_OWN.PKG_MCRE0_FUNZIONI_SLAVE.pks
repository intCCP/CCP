CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_FUNZIONI_SLAVE AS
/******************************************************************************
   NAME:       PKG_MCRE0_CONVERSIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Andrea Bartolomei  Created this package.
   1.1        15/05/2011  Luca Ferretti      Aggiunte funzioni per flusso ANADIP
   2.0       24/05/2012  Valeria galli       Caricamento Email
   3.0       22/06/2012  Emiliano Pellizzi   Add function FND_MCRE0_alimenta_IRIS_ap_st
   4.0       18/07/2012  Emiliano pellizzi   Caricamento Pregiudizievoli
******************************************************************************/

    c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_FUNZIONI_SLAVE';


    FUNCTION FND_MCRE0_conformita(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_svecchiamento(p_rec IN f_slave_par_type) RETURN NUMBER;


    FUNCTION FND_MCRE0_conversione_ABI_ELAB(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_ABI_ELAB(p_rec IN f_slave_par_type) RETURN NUMBER;


    FUNCTION FND_MCRE0_convert_FILE_GUIDA(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_FILE_GUIDA(p_rec IN f_slave_par_type) RETURN NUMBER;



    FUNCTION FND_MCRE0_convert_GRUPPO_ECO(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_GRUPPO_ECO(p_rec IN f_slave_par_type) RETURN NUMBER;




    FUNCTION FND_MCRE0_convert_LEGAME(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_LEGAME(p_rec IN f_slave_par_type) RETURN NUMBER;



    FUNCTION FND_MCRE0_convert_MOPLE(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_MOPLE(p_rec IN f_slave_par_type) RETURN NUMBER;


    FUNCTION FND_MCRE0_convert_PCR_SC_SB(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_PCR_SC_SB(p_rec IN f_slave_par_type) RETURN NUMBER;



    FUNCTION FND_MCRE0_convert_PERCORSI(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_PERCORSI(p_rec IN f_slave_par_type) RETURN NUMBER;



    FUNCTION FND_MCRE0_convert_ANAGR_GRP(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_ANAGR_GRP(p_rec IN f_slave_par_type) RETURN NUMBER;



    FUNCTION FND_MCRE0_convert_RATE_ARR(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_RATE_ARR(p_rec IN f_slave_par_type) RETURN NUMBER;


    FUNCTION FND_MCRE0_convert_SAG(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_SAG(p_rec IN f_slave_par_type) RETURN NUMBER;



    FUNCTION FND_MCRE0_convert_SAB_XRA(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_SAB_XRA(p_rec IN f_slave_par_type) RETURN NUMBER;


    FUNCTION FND_MCRE0_convert_ANAGR_GRE(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_ANAGR_GRE(p_rec IN f_slave_par_type) RETURN NUMBER;


    FUNCTION FND_MCRE0_convert_PCR_GB(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_PCR_GB(p_rec IN f_slave_par_type) RETURN NUMBER;


    FUNCTION FND_MCRE0_convert_PCR_GE_SB(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_PCR_GE_SB(p_rec IN f_slave_par_type) RETURN NUMBER;


    FUNCTION FND_MCRE0_convert_RICH_MON(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_RICH_MON(p_rec IN f_slave_par_type) RETURN NUMBER;


    FUNCTION FND_MCRE0_convert_IRIS(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_convert_PCR_LEGAME(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_convert_PEF(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_alimenta_IRIS(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_alimenta_PCR_LEGAME(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_alimenta_PEF(p_rec IN f_slave_par_type) RETURN NUMBER;


-- FLUSSI CR
    FUNCTION FND_MCRE0_CONVERT_CR_SC_GB (p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_CONVERT_CR_GE_GB(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_CONVERT_CR_LG_GB(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_CONVERT_CR_GE_SB(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_CONVERT_CR_SC_SB(p_rec IN f_slave_par_type) RETURN NUMBER;
   FUNCTION FND_MCRE0_ALIMENTA_CR_SC_GB (p_rec IN f_slave_par_type) RETURN NUMBER;
   FUNCTION FND_MCRE0_ALIMENTA_CR_GE_GB (p_rec IN f_slave_par_type) RETURN NUMBER;
   FUNCTION FND_MCRE0_ALIMENTA_CR_LG_GB (p_rec IN f_slave_par_type) RETURN NUMBER;
   FUNCTION FND_MCRE0_ALIMENTA_CR_GE_SB (p_rec IN f_slave_par_type) RETURN NUMBER;
   FUNCTION FND_MCRE0_ALIMENTA_CR_SC_SB (p_rec IN f_slave_par_type) RETURN NUMBER;

-- FLUSSO ANADIP
    FUNCTION FND_MCRE0_CONVERT_ANADIP  (p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_ALIMENTA_ANADIP (p_rec IN f_slave_par_type) RETURN NUMBER;

-------------ALIMENTAZIONE DELLE TABELLE APP
FUNCTION FND_MCRE0_alimenta_ABI_ELAB_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alim_FILE_GUIDA_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alim_GRUPPO_ECO_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alimenta_LEGAME_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alimenta_MOPLE_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alim_PCR_SC_SB_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alimenta_PERCORSI_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alim_ANAGR_GRP_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alimenta_RATE_ARR_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alimenta_SAG_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alimenta_SAB_XRA_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alim_ANAGR_GRE_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alimenta_PCR_GB_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alim_PCR_GE_SB_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alim_RICH_MON_AP(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alimenta_IRIS_ap(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alimenta_IRIS_ap_st(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alim_PCR_LEGAME_ap(p_rec IN f_slave_par_type) RETURN NUMBER;
FUNCTION FND_MCRE0_alimenta_PEF_ap(p_rec IN f_slave_par_type) RETURN NUMBER;

    --FLUSSI CR

   FUNCTION FND_MCRE0_ALIMENTA_CR_SC_GB_AP (p_rec IN f_slave_par_type) RETURN NUMBER;
   FUNCTION FND_MCRE0_ALIMENTA_CR_GE_GB_AP (p_rec IN f_slave_par_type) RETURN NUMBER;
   FUNCTION FND_MCRE0_ALIMENTA_CR_LG_GB_AP (p_rec IN f_slave_par_type) RETURN NUMBER;
   FUNCTION FND_MCRE0_ALIMENTA_CR_GE_SB_AP (p_rec IN f_slave_par_type) RETURN NUMBER;
   FUNCTION FND_MCRE0_ALIMENTA_CR_SC_SB_AP (p_rec IN f_slave_par_type) RETURN NUMBER;

   -- FLUSSO ANADIP
    FUNCTION FND_MCRE0_ALIMENTA_ANADIP_AP (p_rec IN f_slave_par_type) RETURN NUMBER;

------------------FUNZIONI CHE CHIAMANO IL PKG_MCRE0_ANALYZE_IR_NEW------------
-----------------------PER IL RICALCOLO DELLE STATISTICHE ------------------

    FUNCTION FND_MCRE0_analyze_table_FL(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_analyze_table_ST  (p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_analyze_table_APP(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_convert_EMAIL(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_alimenta_EMAIL(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_alimenta_EMAIL_AP(p_rec IN f_slave_par_type) RETURN NUMBER;

    FUNCTION FND_MCRE0_convert_PREGIUDIZIEV(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_alimenta_PREGIUDIZ(p_rec IN f_slave_par_type) RETURN NUMBER;
    FUNCTION FND_MCRE0_alimenta_PREGIUD_AP(p_rec IN f_slave_par_type) RETURN NUMBER;

END PKG_MCRE0_FUNZIONI_SLAVE;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_FUNZIONI_SLAVE FOR MCRE_OWN.PKG_MCRE0_FUNZIONI_SLAVE;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_FUNZIONI_SLAVE FOR MCRE_OWN.PKG_MCRE0_FUNZIONI_SLAVE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_FUNZIONI_SLAVE TO MCRE_USR;

