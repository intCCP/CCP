CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_grant AS
/******************************************************************************
   NAME:     PKG_MCRE0_LOG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        20/04/2010  Andrea Bartolomei  Created this package.
   1.1        29/04/2011  MM                 Aggiunta GRANT_ALL e grant per TYPE.
   1.2        09/06/2011  MM                 Aggiunto grant ai LOG.
   1.3        25/11/2011  MM                 Grant per tutto mcre.
   1.4        02/04/2012  MM                 gestione eccezioni (per viste scompilate)
******************************************************************************/

    PROCEDURE own_GRANT_TABLE_SELECT is

-- CURSORE TABLES SCHEMA MCRE_OWN
CURSOR ALL_TAB01 IS
                SELECT object_name as table_name
                  FROM USER_objects
                 WHERE object_type = 'SEQUENCE'
                    or object_type = 'TABLE'
                   AND (object_name LIKE 'TE\_MCRE%' ESCAPE '\'
                        OR  object_name LIKE 'MV\_MCRE%' ESCAPE '\'
                        OR  object_name LIKE 'MLOG%\_MCRE%' ESCAPE '\');

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
    --DBMS_OUTPUT.PUT_LINE(R_TAB01.TABLE_NAME||' GRANTED');

    END LOOP;

 else  log_caricamenti('own_GRANT_TABLE_SELECT '||my_user||'->schema sbagliato!!!!', SQLCODE, SQLERRM);

end if;

EXCEPTION
    WHEN OTHERS
    THEN
      log_caricamenti('own_GRANT_TABLE_SELECT '||my_user, SQLCODE, SQLERRM);

    end;
    PROCEDURE own_GRANT_TABLE_S_I_U_D is


-- CURSORE TABLES SCHEMA MCRE_OWN
CURSOR ALL_TAB01 IS
                SELECT table_name
                  FROM USER_tables
                 WHERE
                       1=1
                   AND (table_name LIKE 'T\_MCRE%' ESCAPE '\');

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
    --DBMS_OUTPUT.PUT_LINE(R_TAB01.TABLE_NAME||' GRANTED');

    END LOOP;

 else  log_caricamenti('own_GRANT_TABLE_S_I_U_D '||my_user||'->schema sbagliato!!!!', SQLCODE, SQLERRM);

end if;

EXCEPTION
    WHEN OTHERS
    THEN
      log_caricamenti('own_GRANT_TABLE_S_I_U_D '||my_user, SQLCODE, SQLERRM);

    end;

    PROCEDURE own_GRANT_VIEW_SELECT is

-- CURSORE TABLES SCHEMA MCRE_OWN
CURSOR ALL_VIEW15 IS
                 SELECT VIEW_NAME
                 FROM USER_VIEWS
                 WHERE
                       1=1
                   AND (view_name LIKE '%MCRE%' ESCAPE '\'); --V\_MCRE0%

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

begin
    SQL_STM := 'GRANT SELECT ON '|| MY_USER||'.'||R_TAB01.VIEW_NAME||' TO '||'MCRE_APP, MCRE_USR';
    --DBMS_OUTPUT.PUT_LINE(SQL_STM);
    execute immediate SQL_STM;
   -- DBMS_OUTPUT.PUT_LINE(R_TAB01.VIEW_NAME||' GRANTED');
exception when others then
    DBMS_OUTPUT.PUT_LINE(R_TAB01.VIEW_NAME||' NOT GRANTED');
end;
    END LOOP;

 else  log_caricamenti('own_GRANT_VIEW_SELECT '||my_user||'->schema sbagliato!!!!', SQLCODE, SQLERRM);

end if;

EXCEPTION
    WHEN OTHERS
    THEN
      log_caricamenti('own_GRANT_VIEW_SELECT '||my_user, SQLCODE, SQLERRM);


    end;

    PROCEDURE own_GRANT_PKG_EXE is


CURSOR C1 IS
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE
FROM
ALL_OBJECTS
WHERE OWNER = 'MCRE_OWN';


SQL_STM  VARCHAR2(3200);

BEGIN


 FOR R1 IN C1
 LOOP

  IF R1.OBJECT_TYPE = 'FUNCTION' OR R1.OBJECT_TYPE = 'PACKAGE' OR R1.OBJECT_TYPE ='PROCEDURE' OR R1.OBJECT_TYPE ='TYPE'
  THEN
begin
    SQL_STM := ('GRANT EXECUTE ON '|| R1.OWNER||'.'||R1.OBJECT_NAME||' TO MCRE_APP, MCRE_USR');
    --DBMS_OUTPUT.PUT_LINE(SQL_STM);
    execute immediate SQL_STM;
    --DBMS_OUTPUT.PUT_LINE(R1.OBJECT_NAME||' GRANTED');
exception when others then
    DBMS_OUTPUT.PUT_LINE(R1.OBJECT_NAME||' NOT GRANTED');
end;
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


END PKG_MCRE0_grant;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_GRANT FOR MCRE_OWN.PKG_MCRE0_GRANT;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_GRANT FOR MCRE_OWN.PKG_MCRE0_GRANT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_GRANT TO MCRE_USR;

