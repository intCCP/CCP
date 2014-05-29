CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRES_grant AS
/******************************************************************************
   NAME:     PKG_MCRES_LOG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        20/04/2010  Andrea Bartolomei  Created this package.
   1.1        29/04/2011  MM                 Aggiunta GRANT_ALL e grant per TYPE.
   1.2        09/06/2011  MM                 Aggiunto grant ai LOG.
******************************************************************************/

    PROCEDURE own_GRANT_TABLE_SELECT is

-- CURSORE TABLES SCHEMA MCRE_OWN
CURSOR ALL_TAB01 IS
                SELECT table_name
                  FROM USER_tables
                 WHERE
                       1=1
                   AND (table_name LIKE 'TE\_MCRES%' ESCAPE '\'
                        OR  table_name LIKE 'MV\_MCRES%' ESCAPE '\'
                        OR  table_name LIKE 'MLOG%\_MCRES%' ESCAPE '\');

MY_USER  VARCHAR2(20);
SQL_STM  VARCHAR2(3200);


begin

/*   SELECT current_USER
     INTO MY_USER
     FROM DUAL;
*/
   SELECT sys_context('USERENV', 'CURRENT_USER')
     INTO MY_USER
     FROM dual;


IF my_user = 'MCRE_OWN'
   THEN
   FOR R_TAB01 IN ALL_TAB01
    LOOP

    SQL_STM := 'GRANT SELECT ON '|| MY_USER||'.'||R_TAB01.TABLE_NAME||' TO '||'MCRE_APP, MCRE_USR';
    --DBMS_OUTPUT.PUT_LINE(SQL_STM);
    execute immediate SQL_STM;
    DBMS_OUTPUT.PUT_LINE(R_TAB01.TABLE_NAME||' GRANTED');

    END LOOP;

 else  DBMS_OUTPUT.PUT_LINE(my_user||'->schema sbagliato!!!!');

end if;

EXCEPTION
    WHEN OTHERS
    THEN
      RAISE;

    end;
    PROCEDURE own_GRANT_TABLE_S_I_U_D is


-- CURSORE TABLES SCHEMA MCRE_OWN
CURSOR ALL_TAB01 IS
                SELECT table_name
                  FROM USER_tables
                 WHERE
                       1=1
                   AND (table_name LIKE 'T\_MCRES%' ESCAPE '\');

MY_USER  VARCHAR2(20);
SQL_STM  VARCHAR2(3200);


begin

/*   SELECT current_USER
     INTO MY_USER
     FROM DUAL;
*/
   SELECT sys_context('USERENV', 'CURRENT_USER')
     INTO MY_USER
     FROM dual;


IF my_user = 'MCRE_OWN'
   THEN
   FOR R_TAB01 IN ALL_TAB01
    LOOP

    SQL_STM := 'GRANT SELECT, INSERT, UPDATE, DELETE ON '|| MY_USER||'.'||R_TAB01.TABLE_NAME||' TO '||'MCRE_APP, MCRE_USR';
    --DBMS_OUTPUT.PUT_LINE(SQL_STM);
    execute immediate SQL_STM;
    DBMS_OUTPUT.PUT_LINE(R_TAB01.TABLE_NAME||' GRANTED');

    END LOOP;

 else  DBMS_OUTPUT.PUT_LINE('schema sbagliato!!!!');

end if;

EXCEPTION
    WHEN OTHERS
    THEN
      RAISE;

    end;

    PROCEDURE own_GRANT_VIEW_SELECT is

-- CURSORE TABLES SCHEMA MCRE_OWN
CURSOR ALL_VIEW15 IS
                 SELECT VIEW_NAME
                 FROM USER_VIEWS
                 WHERE
                       1=1
                   AND (view_name LIKE 'V\_MCRES%' ESCAPE '\');

MY_USER  VARCHAR2(20);
SQL_STM  VARCHAR2(3200);


begin

/*   SELECT current_USER
     INTO MY_USER
     FROM DUAL;
*/
   SELECT sys_context('USERENV', 'CURRENT_USER')
     INTO MY_USER
     FROM dual;


IF my_user = 'MCRE_OWN'
   THEN
   FOR R_TAB01 IN ALL_VIEW15
    LOOP

    SQL_STM := 'GRANT SELECT ON '|| MY_USER||'.'||R_TAB01.VIEW_NAME||' TO '||'MCRE_APP, MCRE_USR';
    DBMS_OUTPUT.PUT_LINE(SQL_STM);
    execute immediate SQL_STM;
    DBMS_OUTPUT.PUT_LINE(R_TAB01.VIEW_NAME||' GRANTED');

    END LOOP;

 else  DBMS_OUTPUT.PUT_LINE('schema sbagliato!!!!');

end if;

EXCEPTION
    WHEN OTHERS
    THEN
      RAISE;


    end;

    PROCEDURE own_GRANT_PKG_EXE is


CURSOR C1 IS
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE
FROM
ALL_OBJECTS
WHERE OWNER = 'MCRE_OWN';


SQL_STM  VARCHAR2(3200);

BEGIN


 DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------');
 DBMS_OUTPUT.PUT_LINE('---------------------     MCRE_OWN              ---------------------------------');
 DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------');
 FOR R1 IN C1
 LOOP

  IF R1.OBJECT_TYPE = 'FUNCTION' OR R1.OBJECT_TYPE = 'PACKAGE' OR R1.OBJECT_TYPE ='PROCEDURE' OR R1.OBJECT_TYPE ='TYPE'
  THEN

    SQL_STM := ('GRANT EXECUTE ON '|| R1.OWNER||'.'||R1.OBJECT_NAME||' TO MCRE_APP, MCRE_USR');
    --DBMS_OUTPUT.PUT_LINE(SQL_STM);
    execute immediate SQL_STM;
    DBMS_OUTPUT.PUT_LINE(R1.OBJECT_NAME||' GRANTED');

   END IF;
 END LOOP;

    end;

procedure own_GRANT_ALL as

BEGIN
DBMS_OUTPUT.PUT_LINE('GRANT ALL..');
  PKG_MCRE0_GRANT.OWN_GRANT_TABLE_SELECT;
  PKG_MCRE0_GRANT.own_GRANT_TABLE_S_I_U_D;
  PKG_MCRE0_GRANT.own_GRANT_VIEW_SELECT;
  PKG_MCRE0_GRANT.own_GRANT_PKG_EXE;
DBMS_OUTPUT.PUT_LINE('GRANTED ALL!!');
END;


END PKG_MCRES_grant;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_GRANT FOR MCRE_OWN.PKG_MCRES_GRANT;


CREATE SYNONYM MCRE_USR.PKG_MCRES_GRANT FOR MCRE_OWN.PKG_MCRES_GRANT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_GRANT TO MCRE_USR;

