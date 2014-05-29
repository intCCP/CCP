CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_PARTIZIONI AS
/******************************************************************************
   NAME:       PKG_MCRE0_PARTIZIONI
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Andrea Bartolomei  Created this package.
   2.0        24/05/2012  Valeria galli      Caricamento Email
   3.0        22/06/2012  Emiliano Pellizzi  Add function FND_MCRE0_add_part_storica
   3.1        15/10/2012  Luca Ferretti      Aggiunto log
   3.2        15/10/2012  Luca Ferretti      Estensione log
******************************************************************************/

    c_package CONSTANT VARCHAR2(50) := 'PKG_MCRE0_PARTIZIONI';


    FUNCTION FND_MCRE0_add_partition(seq IN NUMBER, p_table IN VARCHAR2, p_periodo IN DATE, p_cur IN PKG_MCRE0_UTILS.cur_abi_type) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_add_partition_LOG(seq IN NUMBER, p_table IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION FND_MCRE0_add_part_storica(seq IN NUMBER, p_table IN VARCHAR2, p_periodo IN DATE) RETURN BOOLEAN;

END PKG_MCRE0_PARTIZIONI;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_PARTIZIONI FOR MCRE_OWN.PKG_MCRE0_PARTIZIONI;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_PARTIZIONI FOR MCRE_OWN.PKG_MCRE0_PARTIZIONI;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_PARTIZIONI TO MCRE_USR;

