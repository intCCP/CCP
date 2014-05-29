CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_CALENDAR_UTILS AS
/******************************************************************************
   NAME:       PKG_CALENDAR_UTILS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02/09/2012  i.gueorguieva           1. Created this package.
******************************************************************************/


-- Prende IN INPUT UN ID_DPER IN FORMATO  YYYYMMDD
-- E RESTITUISCE DATA EQUIVALENTE A ID_DPER-2,
-- SALTANDO SABATI E DOMENICHE, MA NON LE FESTIVITA'
FUNCTION FNC_GET_PCR_MENO_2(P_ID_DPER IN NUMBER) RETURN DATE IS
V_GIORNO    VARCHAR2(9);
V_DIFF      NUMBER;
V_DAY       DATE;
BEGIN
    V_DAY:=(TO_DATE(TO_CHAR(P_ID_DPER), 'YYYYMMDD')-2);
    V_DIFF:=FNC_IS_SAB_DOM(V_DAY);
    RETURN (((TO_DATE(P_ID_DPER, 'YYYYMMDD')-2))-V_DIFF);
END FNC_GET_PCR_MENO_2;

FUNCTION FNC_IS_SAB_DOM(V_DAY IN DATE) RETURN NUMBER IS
V_GIORNO    VARCHAR2(9);
    V_RET       NUMBER:=0;
    V_FEST      DATE;
    V_NOTA      T_MCREI_WRK_GIORNI_LAVORATIVI.NOTA%TYPE;

    BEGIN

    SELECT TRIM(to_char(V_DAY,'DAY','nls_date_language=english'))
      INTO V_GIORNO
    FROM DUAL;

    IF V_GIORNO = 'SATURDAY' OR V_GIORNO = 'SUNDAY' THEN
       V_RET:=2;
    -- NESSUN CONTROLLO CHE SIA FESTIVO
    END IF;
        RETURN V_RET;

END FNC_IS_SAB_DOM;

-- %return 0: non festivo; 1: festivo da MAR a VEN; 2 SAB o DOM; 3 festivo LUN;
FUNCTION FNC_IS_FESTIVO(V_DAY IN DATE) RETURN NUMBER IS

    V_GIORNO    VARCHAR2(9);
    V_RET       NUMBER:=0;
    V_FEST      DATE;
    V_NOTA      T_MCREI_WRK_GIORNI_LAVORATIVI.NOTA%TYPE;

    BEGIN

    SELECT TRIM(to_char(V_DAY,'DAY','nls_date_language=english'))
      INTO V_GIORNO
    FROM DUAL;

    IF V_GIORNO = 'SATURDAY' OR V_GIORNO = 'SUNDAY' THEN
       V_RET:=2;
    ELSE -- CONTROLLO CHE SIA FESTIVO
        BEGIN
            SELECT NOTA
              INTO V_NOTA
              FROM  T_MCREI_WRK_GIORNI_LAVORATIVI
            WHERE DATACALNL = TRUNC(V_DAY);
            IF V_GIORNO = 'MONDAY' THEN -- QUI CONTROLLO PASQUA --T_MCRE0_APP_ALL_DATA
                V_RET:=3;
            ELSE
                V_RET:=1;
            END IF;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            IF V_GIORNO = 'MONDAY' THEN
                    V_FEST:=FNC_GET_PASQUA_LUN(V_DAY);
                IF V_DAY = V_FEST   THEN
                   V_RET:=3;
                END IF;
            END IF;
        END;
    END IF;
        RETURN V_RET;
    END FNC_IS_FESTIVO;


FUNCTION FNC_GET_PASQUA_LUN(V_ANNO IN DATE) RETURN DATE IS
   a        DECIMAL;
   b        DECIMAL;
   c        DECIMAL;
   d        DECIMAL;
   e        DECIMAL;
   m        DECIMAL;
   n        DECIMAL;
   giorno   DECIMAL;
   mese     DECIMAL;
   y        NUMBER;
   pasqua   DATE;
BEGIN

    SELECT  TO_NUMBER(to_char(V_ANNO,'YYYY'))
      INTO Y
     FROM DUAL;

   IF ( y <= 2099 ) THEN
      m    := 24;
      n    := 5;
   ELSIF( y <= 2199 ) THEN
      m    := 24;
      n    := 6;
   ELSIF( y <= 2299 ) THEN
      m    := 25;
      n    := 0;
   ELSIF( y <= 2399 ) THEN
      m    := 26;
      n    := 1;
   ELSIF( y <= 2499 ) THEN
      m    := 25;
      n    := 1;
   END IF;

   a         := MOD( y, 19 );
   b         := MOD( y, 4 );
   c         := MOD( y, 7 );
   d         := MOD(  (  ( 19 * a ) + m ), 30 );
   e         := MOD(  (  ( 2 * b ) +( 4 * c ) +( 6 * d ) + n ), 7 );

   IF (  ( d + e ) < 10 ) THEN
      giorno    := d + e + 22;
      mese      := 3;
   ELSE
      giorno    := d + e - 9;
      mese      := 4;
   END IF;

   IF (     giorno = 26
        AND mese = 4 ) THEN
      giorno    := 19;
      mese      := 4;
   END IF;

   IF (     giorno = 25
        AND mese = 4
        AND d = 28
        AND e = 6
        AND a > 10 ) THEN
      giorno    := 18;
      mese      := 4;
   END IF;

   pasqua:= TO_DATE( giorno || '/' || mese || '/' || y, 'dd/mm/rrrr' );
   return pasqua+1;
END FNC_GET_PASQUA_lun;

END PKG_CALENDAR_UTILS;
/


CREATE SYNONYM MCRE_APP.PKG_CALENDAR_UTILS FOR MCRE_OWN.PKG_CALENDAR_UTILS;


CREATE SYNONYM MCRE_USR.PKG_CALENDAR_UTILS FOR MCRE_OWN.PKG_CALENDAR_UTILS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_CALENDAR_UTILS TO MCRE_USR;

