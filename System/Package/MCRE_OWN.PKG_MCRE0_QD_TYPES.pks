CREATE OR REPLACE PACKAGE MCRE_OWN.PKG_MCRE0_QD_TYPES
IS
-- MOD 01 :
-- Modifica: FASE e AREA sono stati modificati
--           da CHAR(4) a VARCHAR2(4)
-- Autore: guimei Sun
-- data:  11/10/2006

   -- MOD 02 :
-- aggiunti: MACROAREA e SISTEMA
-- Autore: Lanotte Mario
-- data:  15/12/2006
   SUBTYPE data_inizio_validita IS DATE;

   SUBTYPE data_fine_validita IS DATE;

   --TYPE dyncursor IS REF CURSOR;

   SUBTYPE DATA IS DATE;

   --SUBTYPE app_tipo_record IS CHAR (1);

   SUBTYPE lotto IS NUMBER (7, 0);
   --subtype  TIPO_LOTTO is QZT_ETL_LOTTO.APPLICAZIONE%type;

   SUBTYPE righe IS NUMBER;

   SUBTYPE nome_tabella IS VARCHAR2 (30);

   SUBTYPE nome_procedura IS VARCHAR2 (30);

   SUBTYPE nome_package IS VARCHAR2 (30);

   SUBTYPE chiamata IS VARCHAR2 (61);

   SUBTYPE fase IS VARCHAR2 (10);

   SUBTYPE area IS VARCHAR2 (10);

   SUBTYPE flag IS CHAR (1);

   SUBTYPE nome_check IS VARCHAR2 (30);

   SUBTYPE abi IS NUMBER (5, 0);

   SUBTYPE macroarea IS VARCHAR2 (20);

   SUBTYPE sistema IS VARCHAR2 (20);
END;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_QD_TYPES FOR MCRE_OWN.PKG_MCRE0_QD_TYPES;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_QD_TYPES FOR MCRE_OWN.PKG_MCRE0_QD_TYPES;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_QD_TYPES TO MCRE_USR;

