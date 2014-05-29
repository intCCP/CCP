CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCREI_grant AS
/******************************************************************************
   NAME:     PKG_MCREI_LOG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        20/04/2010  Andrea Bartolomei  Created this package.
   1.1        29/04/2011  MM                 Aggiunta GRANT_ALL e grant per TYPE.
   1.2        09/06/2011  MM                 Aggiunto grant ai LOG.
   1.3        09/01/2012  i.gueorguieva      Aggiunta gestione eccezione generale nei loop
******************************************************************************/
   
    PROCEDURE own_GRANT_TABLE_SELECT is

-- CURSORE TABLES SCHEMA MCRE_OWN
CURSOR ALL_TAB01 IS              
                SELECT table_name
                  FROM USER_tables
                 WHERE 
                       1=1
                   AND (table_name LIKE 'TE\_MCREI%' ESCAPE '\'
                        OR  table_name LIKE 'MV\_MCREI%' ESCAPE '\'
                        OR  table_name LIKE 'MLOG%\_MCREI%' ESCAPE '\');

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
    
    begin
    SQL_STM := 'GRANT SELECT ON '|| MY_USER||'.'||R_TAB01.TABLE_NAME||' TO '||'MCRE_APP, MCRE_USR';
    --DBMS_OUTPUT.PUT_LINE(SQL_STM);
    execute immediate SQL_STM;
    --DBMS_OUTPUT.PUT_LINE(R_TAB01.TABLE_NAME||' GRANTED');
       EXCEPTION WHEN OTHERS 
       THEN NULL;
    end;
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
                   AND (table_name LIKE 'T\_MCREI%' ESCAPE '\');

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
    begin
    SQL_STM := 'GRANT SELECT, INSERT, UPDATE, DELETE ON '|| MY_USER||'.'||R_TAB01.TABLE_NAME||' TO '||'MCRE_APP, MCRE_USR';
    --DBMS_OUTPUT.PUT_LINE(SQL_STM);
    execute immediate SQL_STM;
    DBMS_OUTPUT.PUT_LINE(R_TAB01.TABLE_NAME||' GRANTED');
       EXCEPTION WHEN OTHERS 
       THEN NULL;
    end;
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
                   AND (view_name LIKE 'V\_MCREI%' ESCAPE '\');

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
    DBMS_OUTPUT.PUT_LINE(SQL_STM);
    execute immediate SQL_STM;
    DBMS_OUTPUT.PUT_LINE(R_TAB01.VIEW_NAME||' GRANTED');
           EXCEPTION WHEN OTHERS 
            THEN NULL;
    end;
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


 --DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------');
 --DBMS_OUTPUT.PUT_LINE('---------------------     MCRE_OWN              ---------------------------------');
 --DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------');
 FOR R1 IN C1
 LOOP
 begin
  IF R1.OBJECT_TYPE = 'FUNCTION' OR R1.OBJECT_TYPE = 'PACKAGE' OR R1.OBJECT_TYPE ='PROCEDURE' OR R1.OBJECT_TYPE ='TYPE'
  THEN 
  
    SQL_STM := ('GRANT EXECUTE ON '|| R1.OWNER||'.'||R1.OBJECT_NAME||' TO MCRE_APP, MCRE_USR');
    DBMS_OUTPUT.PUT_LINE(SQL_STM);
    execute immediate SQL_STM;
    DBMS_OUTPUT.PUT_LINE(R1.OBJECT_NAME||' GRANTED');

   END IF;
   EXCEPTION WHEN OTHERS 
   THEN NULL;
   end;
 END LOOP;
    end;
    
procedure own_GRANT_ALL as
    
BEGIN 
--DBMS_OUTPUT.PUT_LINE('GRANT ALL..');
  PKG_MCREI_GRANT.OWN_GRANT_TABLE_SELECT;
  PKG_MCREI_GRANT.own_GRANT_TABLE_S_I_U_D;
  PKG_MCREI_GRANT.own_GRANT_VIEW_SELECT;
  PKG_MCREI_GRANT.own_GRANT_PKG_EXE;
--DBMS_OUTPUT.PUT_LINE('GRANTED ALL!!');
END; 

PROCEDURE OWN_GRANT_ALL_REAL IS 
 CURSOR C1 IS
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE
FROM
ALL_OBJECTS
WHERE OWNER = 'MCRE_OWN';
SQL_STM  VARCHAR2(3200);
BEGIN
 FOR R1 IN C1
 LOOP
 begin
  IF R1.OBJECT_TYPE = 'FUNCTION' OR R1.OBJECT_TYPE = 'PACKAGE' OR R1.OBJECT_TYPE ='PROCEDURE' OR R1.OBJECT_TYPE ='TYPE'
  OR R1.OBJECT_TYPE ='TABLE' OR R1.OBJECT_TYPE = 'VIEW' 
  THEN 
  
    SQL_STM := ('GRANT  ALL ON '|| R1.OWNER||'.'||R1.OBJECT_NAME||' TO MCRE_APP, MCRE_USR');
    DBMS_OUTPUT.PUT_LINE(SQL_STM);
    execute immediate SQL_STM;
    DBMS_OUTPUT.PUT_LINE(R1.OBJECT_NAME||' GRANTED');

   END IF;
   EXCEPTION WHEN OTHERS 
   THEN NULL;
   end;
 END LOOP;
END;
END PKG_MCREI_grant;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_GRANT FOR MCRE_OWN.PKG_MCREI_GRANT;


CREATE SYNONYM MCRE_USR.PKG_MCREI_GRANT FOR MCRE_OWN.PKG_MCREI_GRANT;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_GRANT TO MCRE_USR;

