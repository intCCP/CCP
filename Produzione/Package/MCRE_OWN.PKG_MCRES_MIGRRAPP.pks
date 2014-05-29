CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRES_MIGRRAPP AS
  /******************************************************************************
     NAME:       PKG_MCRES_ALIMENTAZIONE
     PURPOSE:

     REVISIONS:
     Ver        Date        Author             Description
     ---------  ----------      -----------------  ------------------------------------
     1.0      14/02/2012  V.Galli     Created this package.
     1.1      18/06/2012  V.Galli    Versione per shell con report
  ******************************************************************************/

  C_PACKAGE CONSTANT VARCHAR2(50) := 'PKG_MCRES_MIGRRAPP';
  OK NUMBER := 1;
  KO NUMBER := 0;

  PK_VIOLATA EXCEPTION;
  pragma exception_init(PK_VIOLATA, -1);

  -- Flusso fino a ST (0 errore, altrimenti id_lotto)
  FUNCTION FNC_MCRES_ALIMENTA_ST_MIGRRAPP(
    P_FLG_TIPO_MIGRRAPP T_MCRES_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type
  ) RETURN T_MCRES_ST_MIGRRAPP.id_lotto%type;

  -- Effettiva migrazione
  function FNC_MCRES_TBL_MIGRRAPP(
    P_ID_LOTTO T_MCRES_ST_MIGRRAPP.ID_LOTTO%TYPE,
    P_FLG_TIPO_MIGRRAPP T_MCRES_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type
  ) RETURN NUMBER;

  -- Effettiva migrazione senza APP
  function FNC_MCRES_TBL_MIGRRAPP_3(
    P_ID_LOTTO T_MCRES_ST_MIGRRAPP.ID_LOTTO%TYPE,
    P_FLG_TIPO_MIGRRAPP T_MCRES_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type
  ) RETURN NUMBER;

  -- Esecuzione generale
  procedure PRC_MCRES_EXE_MIGRRAPP(
    P_FLG_TIPO_MIGRRAPP T_MCRES_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type,
    p_esito out number
  );

  -- Esecuzione da TWS
  function FNC_MCRES_chk_MIGRRAPP(
    p_nome_file T_MCRES_WRK_MIGRRAPP_FILE.VAL_NOME_FILE%type
  )RETURN number;

    -- Creazione reports
  function FNC_MCRES_report_MIGRRAPP(
    P_ID_LOTTO T_MCRES_ST_MIGRRAPP.ID_LOTTO%TYPE,
    P_FLG_TIPO_MIGRRAPP T_MCRES_ST_MIGRRAPP.FLG_TIPO_MIGRRAPP%type,
    p_flg_ante number
  ) RETURN NUMBER;

END PKG_MCRES_MIGRRAPP;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_MIGRRAPP FOR MCRE_OWN.PKG_MCRES_MIGRRAPP;


CREATE SYNONYM MCRE_USR.PKG_MCRES_MIGRRAPP FOR MCRE_OWN.PKG_MCRES_MIGRRAPP;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_MIGRRAPP TO MCRE_USR;

