CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_ALIMENTAZIONE" AS
/******************************************************************************
   NAME:       PKG_MCRE0_ALIMENTAZIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Andrea Bartolomei  Created this package.
   2.0        24/02/2010  Chiara Giannangeli Storico mensile.
   3.0        25/05/2011  Luca Ferretti      Aggiunta caricamento ANADIP
   3.0.1      19/12/2011  Andrea Galliano    Aggiunta caricamento DTA_NASCITA su Anagrafica di gruppo
   4.0        24/05/2012  Valeria galli      Caricamento Email
   4.0.1      19/06/2012  Emiliano Pellizzi  Evolutiva Caricamento Email
   5.0        19/06/2012  Emiliano Pellizzi  Evolutiva Caricamento Iris
   5.1        22/06/2012  Emiliano Pellizzi  Add function FND_MCRE0_alimenta_IRIS_ap_st
   6.0        17/07/2012  Emiliano Pellizzi  Caricamento Pregiudizievoli
   6.1        08/11/2012  Luca Ferretti      Modifica Merge sul file_guida
   6.2        18/03/2012  M.murro            rimossa l'indicazione del cambio mese su storicizza_mople
   6.3        14/10/2013  T.Bernardi         Aggiunto FLG_FATAL al flusso IRIS
******************************************************************************/

    c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_ALIMENTAZIONE';
    FUNCTION FND_MCRE0_alimenta_PREGIUDIZ(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_PREGIUD_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_EMAIL(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_EMAIL_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_ABI_ELAB(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_ABI_ELAB_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_FILE_GUIDA(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alim_FILE_GUIDA_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_GRUPPO_ECO(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alim_GRUPPO_ECO_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_LEGAME(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_LEGAME_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_MOPLE(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_MOPLE_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_PCR_SC_SB(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alim_PCR_SC_SB_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_PERCORSI(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_PERCORSI_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_ANAGR_GRP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alim_ANAGR_GRP_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_RATE_ARR(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_RATE_ARR_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_SAG(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_SAG_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_SAB_XRA(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_SAB_XRA_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_ANAGR_GRE(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alim_ANAGR_GRE_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_PCR_GB(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_PCR_GB_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_PCR_GE_SB(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alim_PCR_GE_SB_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_RICH_MON(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alim_RICH_MON_AP(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_PCR_LEGAME(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alim_PCR_LEGAME_ap(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_IRIS(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_IRIS_ap(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_IRIS_ap_st(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_PEF(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_alimenta_PEF_ap(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_storicizza_MOPLE(p_rec IN f_slave_par_type) RETURN BOOLEAN;



-- FLUSSI CR
    FUNCTION FND_MCRE0_ALIMENTA_CR_SC_GB (p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_ALIMENTA_CR_GE_GB(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_ALIMENTA_CR_LG_GB(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_ALIMENTA_CR_GE_SB(p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_ALIMENTA_CR_SC_SB(p_rec IN f_slave_par_type) RETURN BOOLEAN;

   FUNCTION FND_MCRE0_ALIMENTA_CR_SC_GB_AP (p_rec IN f_slave_par_type) RETURN BOOLEAN;
   FUNCTION FND_MCRE0_ALIMENTA_CR_GE_GB_AP (p_rec IN f_slave_par_type) RETURN BOOLEAN;
   FUNCTION FND_MCRE0_ALIMENTA_CR_LG_GB_AP (p_rec IN f_slave_par_type) RETURN BOOLEAN;
   FUNCTION FND_MCRE0_ALIMENTA_CR_GE_SB_AP (p_rec IN f_slave_par_type) RETURN BOOLEAN;
   FUNCTION FND_MCRE0_ALIMENTA_CR_SC_SB_AP (p_rec IN f_slave_par_type) RETURN BOOLEAN;

-- FLUSSO ANADIP
    FUNCTION FND_MCRE0_ALIMENTA_ANADIP (p_rec IN f_slave_par_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_ALIMENTA_ANADIP_AP (p_rec IN f_slave_par_type) RETURN BOOLEAN;


END PKG_MCRE0_ALIMENTAZIONE;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ALIMENTAZIONE FOR MCRE_OWN.PKG_MCRE0_ALIMENTAZIONE;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ALIMENTAZIONE FOR MCRE_OWN.PKG_MCRE0_ALIMENTAZIONE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ALIMENTAZIONE TO MCRE_USR;

