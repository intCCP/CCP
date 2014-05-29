CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_MIGRRAPP AS
  /******************************************************************************
     NAME:       PKG_MCRE0_ALIMENTAZIONE
     PURPOSE:

     REVISIONS:
     Ver        Date        Author             Description
     ---------  ----------      -----------------  ------------------------------------
     1.0      14/02/2012  V.Galli    Created this package.
     1.1      18/06/2012  V.Galli    Versione per shell con report
     1.2      12/07/2012  V.Galli    Conferimenti
  ******************************************************************************/

  C_PACKAGE CONSTANT VARCHAR2(50) := 'PKG_MCRE0_MIGRRAPP';
  OK NUMBER := 1;
  KO NUMBER := 0;

  PK_VIOLATA EXCEPTION;
  pragma exception_init(PK_VIOLATA, -1);

  -- Flusso fino a ST (0 errore, altrimenti id_lotto)
  FUNCTION FNC_MCRE0_ALIMENTA_ST_MIGRRAPP(
    P_FLG_TIPO_MIGRRAPP T_MCRE0_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type
  ) RETURN T_MCRE0_ST_MIGRRAPP.id_lotto%type;

  -- Effettiva migrazione senza APP
  function FNC_MCRE0_TBL_MIGRRAPP(
    P_ID_LOTTO T_MCRE0_ST_MIGRRAPP.ID_LOTTO%TYPE,
    P_FLG_TIPO_MIGRRAPP T_MCRE0_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type
  ) RETURN NUMBER;

  -- Esecuzione generale
  procedure PRC_MCRE0_EXE_MIGRRAPP(
    P_FLG_TIPO_MIGRRAPP T_MCRE0_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type,
    p_esito out number
  );

  -- Esecuzione da TWS
  function FNC_MCRE0_chk_MIGRRAPP(
    p_nome_file T_MCRE0_WRK_MIGRRAPP_FILE.VAL_NOME_FILE%type
  )RETURN number;

    -- Creazione reports
  function FNC_MCRE0_report_MIGRRAPP(
    P_ID_LOTTO T_MCRE0_ST_MIGRRAPP.ID_LOTTO%TYPE,
    P_FLG_TIPO_MIGRRAPP T_MCRE0_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type,
    p_flg_ante number
  ) RETURN NUMBER;

END PKG_MCRE0_MIGRRAPP;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_MIGRRAPP FOR MCRE_OWN.PKG_MCRE0_MIGRRAPP;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_MIGRRAPP FOR MCRE_OWN.PKG_MCRE0_MIGRRAPP;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_MIGRRAPP TO MCRE_USR;

