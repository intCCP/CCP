CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCREI_SVECCHIAMENTO" AS
/******************************************************************************
   NAME:       PKG_MCREI_SVECCHIAMENTO
   PURPOSE: Svecchiamento su tabelle History, Vincoli, Convert, Log e Audit
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        27/05/2013 I.Gueorguieva  Created this package
   1.1       26/06/2013 I.Gueorguieva   Aggiunti controlli da inviare per mail
******************************************************************************/
  FUNCTION TWS_LIVELLO1_G1 RETURN NUMBER IS

  V_APPARTENENZA T_MCREI_WRK_SVECCHIAMENTO.DESC_APPARTENENZA%TYPE:='INC';
  V_IS_A_TEST BOOLEAN:=FALSE;

 BEGIN
    SVECCHIA_ST(V_APPARTENENZA, V_IS_A_TEST);
    return C_OK;
  END;
  FUNCTION TWS_LIVELLO1_G2 RETURN NUMBER IS

  V_APPARTENENZA T_MCREI_WRK_SVECCHIAMENTO.DESC_APPARTENENZA%TYPE:='SOFF';
  V_IS_A_TEST BOOLEAN:=FALSE;

 BEGIN
    SVECCHIA_ST(V_APPARTENENZA, V_IS_A_TEST);
    return C_OK;
  END;
  FUNCTION TWS_LIVELLO1_G3 RETURN NUMBER IS

  V_APPARTENENZA T_MCREI_WRK_SVECCHIAMENTO.DESC_APPARTENENZA%TYPE:='INC';
  V_IS_A_TEST BOOLEAN:=FALSE;

  BEGIN
    SVECCHIA_VINCON(V_APPARTENENZA,V_IS_A_TEST);
    SVECCHIA_LOG(V_APPARTENENZA,V_IS_A_TEST);
    RETURN C_OK;
  END;
  FUNCTION TWS_LIVELLO1_G4 RETURN NUMBER IS

    V_APPARTENENZA T_MCREI_WRK_SVECCHIAMENTO.DESC_APPARTENENZA%TYPE:='SOFF';
    V_IS_A_TEST BOOLEAN:=FALSE;

  BEGIN
    SVECCHIA_VINCON(V_APPARTENENZA,V_IS_A_TEST);
    SVECCHIA_LOG(V_APPARTENENZA,V_IS_A_TEST);
    return C_OK;
  END;
  FUNCTION TWS_LIVELLO2_G1 RETURN NUMBER
  IS
  c_nome varchar2(60):=PKG_MCRE0_SVECCHIAMENTO.C_PACKAGE||'.'||'TWS_LIVELLO2_G1';
  BEGIN

  CONTROLLI;
        return C_OK;
  EXCEPTION WHEN OTHERS THEN
   pkg_mcrei_audit.log_caricamenti (9999, c_nome,pkg_mcrei_audit.c_error, SQLCODE,SQLERRM,'KO!!!');
        return C_OK;
  END;
PROCEDURE SVECCHIA_ST(P_DESC_APPARTENENZA IN T_MCREI_WRK_SVECCHIAMENTO.DESC_APPARTENENZA%TYPE, P_TEST BOOLEAN)  AS
C_NOME VARCHAR2(60):= PKG_MCRE0_SVECCHIAMENTO.C_PACKAGE||'.'||'SVECCHIA_ST_CONTIGUO';
V_PARTITION_ALTRI VARCHAR2(20);
V_PARTITION_PREFIX VARCHAR2(20);

CURSOR CTAB IS
 SELECT TIPO_TABELLA, NOME_TABELLA, NUM_PARTIZIONI_MANTENUTE, COD_FILE, FLG_ACTIVE, PARTITION_PREFIX, PARTITION_SUFFIX_FORMAT, DESC_APPARTENENZA
     FROM T_MCREI_WRK_SVECCHIAMENTO
 WHERE TIPO_TABELLA = 'ST_CONTIGUO'
   AND DESC_APPARTENENZA = P_DESC_APPARTENENZA
 AND FLG_ACTIVE = 1;

CURSOR CPART (VTABNAME VARCHAR2,  VALTRI VARCHAR2,VPERIOD NUMBER) IS
SELECT TABLE_NAME,TO_NUMBER(SUBSTR(PARTITION_NAME,LENGTH(V_PARTITION_PREFIX)+1)) AS PERIOD, PARTITION_NAME
  FROM T_TEMP_TAB_PARTITIONS
  WHERE PARTITION_NAME !=VALTRI
  AND TABLE_NAME =VTABNAME
MINUS
(
SELECT RRRR.TABLE_NAME, RRRR.PERIOD, RRRR.PARTITION_NAME
FROM 
(SELECT ROWNUM AS RNUM, RRR.TABLE_NAME, RRR.PERIOD, RRR.PARTITION_NAME
FROM 
(SELECT RR.TABLE_NAME, RR.PERIOD, RR.PARTITION_NAME
FROM
(SELECT TABLE_NAME,TO_NUMBER(SUBSTR(PARTITION_NAME,LENGTH(V_PARTITION_PREFIX)+1
)) AS PERIOD, PARTITION_NAME
  FROM T_TEMP_TAB_PARTITIONS
  WHERE PARTITION_NAME != VALTRI
  AND TABLE_NAME = VTABNAME
ORDER BY TO_NUMBER(SUBSTR(PARTITION_NAME,LENGTH(V_PARTITION_PREFIX)+1)) DESC)RR)RRR)RRRR
WHERE RRRR.RNUM <= VPERIOD
);

VDROPCMD VARCHAR2(400);

BEGIN

SELECT PARTITION_PREFIX, PARTITION_PREFIX||'ALTRI'
  INTO V_PARTITION_PREFIX,V_PARTITION_ALTRI
FROM T_MCREI_WRK_SVECCHIAMENTO
WHERE DESC_APPARTENENZA = P_DESC_APPARTENENZA
AND PARTITION_PREFIX IS NOT NULL
AND ROWNUM = 1;


    INSERT INTO T_TEMP_TAB_PARTITIONS
    SELECT TABLE_NAME, PARTITION_NAME
      FROM USER_TAB_PARTITIONS
    WHERE TABLE_NAME IN (
    SELECT NOME_TABELLA
           FROM T_MCREI_WRK_SVECCHIAMENTO
 WHERE TIPO_TABELLA = 'ST_CONTIGUO'
   AND  DESC_APPARTENENZA = P_DESC_APPARTENENZA);

 FOR RTAB IN CTAB LOOP
    FOR RPART IN CPART(RTAB.NOME_TABELLA,V_PARTITION_ALTRI, RTAB.NUM_PARTIZIONI_MANTENUTE) LOOP
        BEGIN
        VDROPCMD:='ALTER TABLE '|| RTAB.NOME_TABELLA||' DROP PARTITION ' ||RPART.PARTITION_NAME;

        IF P_TEST THEN  DBMS_OUTPUT.PUT_LINE(VDROPCMD);
        ELSE EXECUTE IMMEDIATE VDROPCMD;
        END IF;
        EXCEPTION WHEN OTHERS THEN
            pkg_mcrei_audit.log_caricamenti (9999, c_nome,pkg_mcrei_audit.c_error, SQLCODE,SQLERRM,'KO!!!');
        END;
    END LOOP;
 END LOOP;
 EXECUTE IMMEDIATE 'TRUNCATE TABLE T_TEMP_TAB_PARTITIONS';
EXCEPTION WHEN OTHERS THEN
 pkg_mcrei_audit.log_caricamenti (9999, c_nome,pkg_mcrei_audit.c_error, SQLCODE,SQLERRM,'KO!!!');
END SVECCHIA_ST;

PROCEDURE SVECCHIA_LOG (P_DESC_APPARTENENZA IN T_MCREI_WRK_SVECCHIAMENTO.DESC_APPARTENENZA%TYPE, P_TEST BOOLEAN)  AS
C_NOME VARCHAR2(60):= PKG_MCRE0_SVECCHIAMENTO.C_PACKAGE||'.'||'SVECCHIA_LOG';

CURSOR CTAB IS
 SELECT TIPO_TABELLA, NOME_TABELLA, NUM_PARTIZIONI_MANTENUTE, COD_FILE, FLG_ACTIVE,
 PARTITION_PREFIX, PARTITION_SUFFIX_FORMAT, DESC_APPARTENENZA,
 COL_NAME_LOG_DTA
     FROM T_MCREI_WRK_SVECCHIAMENTO
 WHERE TIPO_TABELLA = 'LOG'
 AND DESC_APPARTENENZA = P_DESC_APPARTENENZA
 AND FLG_ACTIVE = 1;
VCREATCMD VARCHAR2(4000);

BEGIN


    FOR RTAB IN CTAB LOOP
        BEGIN

        VCREATCMD:='DELETE FROM '||RTAB.NOME_TABELLA
        ||' WHERE '||RTAB.COL_NAME_LOG_DTA||' < TRUNC(SYSDATE-'||RTAB.NUM_PARTIZIONI_MANTENUTE||')';

        IF P_TEST THEN DBMS_OUTPUT.PUT_LINE(VCREATCMD);
        ELSE
            EXECUTE IMMEDIATE VCREATCMD;
            COMMIT;
        END IF;
        EXCEPTION WHEN OTHERS THEN
        pkg_mcrei_audit.log_caricamenti (9999, c_nome,pkg_mcrei_audit.c_error, SQLCODE,SQLERRM,'KO!!!');
        END;
    END LOOP;

EXCEPTION WHEN OTHERS THEN
 pkg_mcrei_audit.log_caricamenti (9999, c_nome,pkg_mcrei_audit.c_error, SQLCODE,SQLERRM,'KO!!!');
END SVECCHIA_LOG;


PROCEDURE SVECCHIA_VINCON(P_DESC_APPARTENENZA IN T_MCREI_WRK_SVECCHIAMENTO.DESC_APPARTENENZA%TYPE,P_TEST BOOLEAN)  AS
C_NOME VARCHAR2(60):= PKG_MCRE0_SVECCHIAMENTO.C_PACKAGE||'.'||'SVECCHIA_VINCON';

CURSOR CTAB IS
 SELECT TIPO_TABELLA, NOME_TABELLA, NUM_PARTIZIONI_MANTENUTE, COD_FILE, FLG_ACTIVE,
 PARTITION_PREFIX, PARTITION_SUFFIX_FORMAT, DESC_APPARTENENZA,
 COL_NAME_LOG_DTA, NOME_TABELLA2
     FROM T_MCREI_WRK_SVECCHIAMENTO
 WHERE TIPO_TABELLA = 'VINCON'
 AND DESC_APPARTENENZA = P_DESC_APPARTENENZA
 AND FLG_ACTIVE = 1;
VDELCMD VARCHAR2(4000);
VDELCMD2 VARCHAR2(4000);
V_DEL     NUMBER;

BEGIN

    FOR RTAB IN CTAB LOOP
        BEGIN

        BEGIN
            CASE
             WHEN P_DESC_APPARTENENZA = 'INC' THEN

             SELECT MIN(MIN_ID_FLUSSO) AS MIN_ID
                 INTO V_DEL
                FROM (
                SELECT MIN_ID_FLUSSO, ID_DPER
                FROM (
                select DISTINCT MIN(ID_FLUSSO) OVER (PARTITION BY ID_DPER) MIN_ID_FLUSSO, ID_DPER
                  from t_mcrei_wrk_acquisizione
                where cod_flusso = RTAB.COD_FILE
                  AND COD_STATO = 'CARICATO'
                  ORDER BY ID_DPER DESC)
                WHERE ROWNUM <= RTAB.NUM_PARTIZIONI_MANTENUTE);

            WHEN  P_DESC_APPARTENENZA = 'SOFF' THEN
              SELECT MIN(MIN_ID_FLUSSO) AS MIN_ID
                 INTO V_DEL
                FROM (
                SELECT MIN_ID_FLUSSO, ID_DPER
                FROM (
                select DISTINCT MIN(ID_FLUSSO) OVER (PARTITION BY ID_DPER) MIN_ID_FLUSSO, ID_DPER
                  from t_mcres_wrk_acquisizione
                where cod_flusso = RTAB.COD_FILE
                  AND COD_STATO = 'CARICATO'
                  ORDER BY ID_DPER DESC)
                WHERE ROWNUM <= RTAB.NUM_PARTIZIONI_MANTENUTE);
                ELSE V_DEL := 0;
             END CASE;
        EXCEPTION WHEN OTHERS THEN V_DEL:=0;
        END;



        VDELCMD:='DELETE FROM '||RTAB.NOME_TABELLA
        || ' WHERE '||RTAB.COL_NAME_LOG_DTA||' < '||v_del;

          VDELCMD2:='DELETE FROM '||RTAB.NOME_TABELLA2
        || ' WHERE '||RTAB.COL_NAME_LOG_DTA||' < '||v_del;

        IF P_TEST THEN
           IF RTAB.NOME_TABELLA IS NOT NULL AND V_DEL IS NOT NULL  THEN
            DBMS_OUTPUT.PUT_LINE(VDELCMD);
          END IF;

          IF RTAB.NOME_TABELLA2 IS NOT NULL AND V_DEL IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE(VDELCMD2);
          END IF;
        ELSE
           IF RTAB.NOME_TABELLA IS NOT NULL AND V_DEL IS NOT NULL  THEN
            EXECUTE IMMEDIATE VDELCMD;
            COMMIT;
          END IF;

           IF RTAB.NOME_TABELLA IS NOT NULL AND V_DEL IS NOT NULL  THEN
            EXECUTE IMMEDIATE VDELCMD2;
            COMMIT;
         END IF;
        END IF;
        EXCEPTION WHEN OTHERS THEN
         pkg_mcrei_audit.log_caricamenti (9999, c_nome,pkg_mcrei_audit.c_error, SQLCODE,SQLERRM,'KO!!!');
        END;

    END LOOP;

    EXCEPTION WHEN OTHERS THEN
        pkg_mcrei_audit.log_caricamenti (9999, c_nome,pkg_mcrei_audit.c_error, SQLCODE,SQLERRM,'KO!!!');
END SVECCHIA_VINCON;

PROCEDURE CONTROLLI AS
   V_FROM       VARCHAR2(80) ;
   CRLF         VARCHAR2(2)  := CHR(13)||CHR(10);
   MAILBODY VARCHAR2(2000);
   V_FILE_NAME VARCHAR2(4000) :='size_mcre_own_objects_'||TO_CHAR(SYSDATE,'DD_MM_YYYY')||'.xml';

    VPERC NUMBER;
    VUSED NUMBER;
    VFREE NUMBER;

    VINSFR BOOLEAN:=FALSE;

   CURSOR C_RECIPIENT IS
     SELECT NOTES
       FROM T_MCREI_WRK_MAIL_SVECCHIAMENTO
    WHERE DESCRIPTION='Recipient';

    V_RECIPIENT C_RECIPIENT%ROWTYPE;

    CURSOR C_COPY IS
    SELECT NOTES
    FROM T_MCREI_WRK_MAIL_SVECCHIAMENTO
    WHERE DESCRIPTION='Carbon Copy';

    V_COPY C_COPY%ROWTYPE;
    V_SUBJECT    VARCHAR2(80);
    V_MAIL_HOST  VARCHAR2(30) ;
    V_MAIL_CONN  UTL_SMTP.CONNECTION;


  CURSOR c_con IS
    SELECT TABLESPACE_NAME, ROUND(SIZE_BYTES/1024/1024,2) SIZE_MB, OBJECT_NAME,OBJECT_TYPE, ROUND(
    (SUM(SIZE_BYTES) OVER (PARTITION BY NULL))/1024/1024,2) TOTAL_MB
    FROM(
     SELECT DISTINCT TABLESPACE_NAME,SUM(BYTES) OVER (PARTITION BY SEGMENT_NAME) AS SIZE_BYTES,  SEGMENT_NAME as OBJECT_NAME, SEGMENT_TYPE as OBJECT_TYPE
        FROM USER_SEGMENTS)
    ORDER BY SIZE_MB DESC;
    v_con C_con%ROWTYPE;



   SDATE VARCHAR2(20);
    P_DOMAIN VARCHAR2(3);
    P_ID_DPER DATE;
    SEQ NUMBER;
    V_WROTE         NUMBER  := 0;
    V_SIZE          NUMBER;
    V_BUFFER_SIZE   NUMBER  := 32760;
    V_RAW           VARCHAR2(32760);
    OK NUMBER:=0;
    KO NUMBER:=1;
    V_SESS VARCHAR2(100);
          XMLBODY CLOB :=  '<?xml version="1.0"?>
        <?mso-application progid="Excel.Sheet"?>
        <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
         xmlns:o="urn:schemas-microsoft-com:office:office"
         xmlns:x="urn:schemas-microsoft-com:office:excel"
         xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
         xmlns:html="http://www.w3.org/TR/REC-html40">
         <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
          <Author>Reply</Author>
          <LastAuthor>Reply</LastAuthor>
          <Created>2013-01-01T12:00:00Z</Created>
          <Version>15.00</Version>
         </DocumentProperties>
         <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
          <AllowPNG/>
         </OfficeDocumentSettings>
         <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
          <WindowHeight>7755</WindowHeight>
          <WindowWidth>20490</WindowWidth>
          <WindowTopX>0</WindowTopX>
          <WindowTopY>0</WindowTopY>
          <ProtectStructure>False</ProtectStructure>
          <ProtectWindows>False</ProtectWindows>
         </ExcelWorkbook>
         <Styles>
          <Style ss:ID="Default" ss:Name="Normal">
           <Alignment ss:Vertical="Bottom"/>
           <Borders/>
           <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
           <Interior/>
           <NumberFormat/>
           <Protection/>
          </Style>
          <Style ss:ID="s62">
           <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
           </Borders>
           <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"
            ss:Bold="1"/>
           <Interior ss:Color="#5B9BD5" ss:Pattern="Solid"/>
          </Style>
          <Style ss:ID="s63">
           <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
           </Borders>
           <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"
            ss:Bold="1"/>
           <Interior ss:Color="#5B9BD5" ss:Pattern="Solid"/>
          </Style>
          <Style ss:ID="s64">
           <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
           </Borders>
           <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"
            ss:Bold="1"/>
           <Interior ss:Color="#5B9BD5" ss:Pattern="Solid"/>
          </Style>
          <Style ss:ID="s65">
           <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
           </Borders>
           <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
           <Interior ss:Color="#DDEBF7" ss:Pattern="Solid"/>
           <NumberFormat ss:Format="@"/>
          </Style>
          <Style ss:ID="s66">
           <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
           </Borders>
           <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
           <Interior ss:Color="#DDEBF7" ss:Pattern="Solid"/>
           <NumberFormat ss:Format="@"/>
          </Style>
          <Style ss:ID="s67">
           <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
           </Borders>
           <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
           <Interior ss:Color="#DDEBF7" ss:Pattern="Solid"/>
           <NumberFormat ss:Format="@"/>
          </Style>
          <Style ss:ID="s68">
           <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
           </Borders>
           <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
           <NumberFormat ss:Format="@"/>
          </Style>
          <Style ss:ID="s69">
           <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
           </Borders>
           <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
           <NumberFormat ss:Format="@"/>
          </Style>
          <Style ss:ID="s70">
           <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"
             ss:Color="#9BC2E6"/>
           </Borders>
           <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
           <NumberFormat ss:Format="@"/>
          </Style>
         </Styles>
         <Worksheet ss:Name="Oggetti MCRE0">
          <Table ss:ExpandedColumnCount="20" ss:ExpandedRowCount="4000" x:FullColumns="1"
           x:FullRows="1" ss:DefaultRowHeight="15">
           <Column ss:Index="7" ss:Width="97.5"/>
           <Row>
            <Cell ss:StyleID="s62"><Data ss:Type="String">TABLESPACE_NAME</Data></Cell>
            <Cell ss:StyleID="s63"><Data ss:Type="String">SIZE_MB</Data></Cell>
             <Cell ss:StyleID="s63"><Data ss:Type="String">OBJECT_NAME</Data></Cell>
            <Cell ss:StyleID="s63"><Data ss:Type="String">OBJECT_TYPE</Data></Cell>
            <Cell ss:StyleID="s63"><Data ss:Type="String">TOTAL_MB</Data></Cell>
           </Row>';

BEGIN

 V_SESS:='ALTER SESSION SET NLS_LANGUAGE= ''ITALIAN''';
 EXECUTE IMMEDIATE V_SESS;
 SELECT SEQ_MCR0_LOG_ETL.NEXTVAL INTO SEQ FROM DUAL;
 PKG_MCRE0_AUDIT.LOG_ETL (SEQ, 'P_MCRE0_SEND_MAIL', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, 'INIZIO', 'INIZIO');
 PKG_MCRE0_AUDIT.LOG_ETL (SEQ, 'P_MCRE0_SEND_MAIL', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, 'INIZIO', 'INIZIO-Invio mail');

 BEGIN
        SELECT PERC, FREE,USED
        INTO VPERC,VFREE, VUSED
        FROM(
            SELECT  SUBSTR(LOG, INSTR(LOG,'%',1,1)-2, 2) PERC,
            ROUND(TO_NUMBER(
            SUBSTR(LOG,INSTR(REPLACE(LOG, ' ','-'),'-',-1,10)+1, (
            INSTR(REPLACE(LOG, ' ','-'),'-',-1,9)-INSTR(REPLACE(LOG, ' ','-'),'-',-1,10)-1)))/(1024*1024))AS FREE,
            ROUND(TO_NUMBER(
            SUBSTR(LOG,INSTR(REPLACE(LOG, ' ','-'),'-',-1,11)+1, (
            INSTR(REPLACE(LOG, ' ','-'),'-',-1,10)-INSTR(REPLACE(LOG, ' ','-'),'-',-1,11)-1)))/(1024*1024))AS USED
            FROM
             (
            SELECT *
              FROM T_MCREI_WRK_EXTERNAL_LOG
            WHERE ID_DPER = 2
            ORDER BY DTA_INS DESC)
            WHERE ROWNUM <= 1);
    EXCEPTION WHEN OTHERS THEN
    VPERC:=-1;
    VFREE:=-1;
    VUSED:=-1;
    END;
MAILBODY:= 'In allegato il report dI occupazione spazio degli oggetti di MCRE0.'||CHR(10)||chr(10)
   ||'Filesystem mounted on /oradata/MCRE0/app: '||CHR(10)
   ||'capacity '||VPERC||'%, used approximately '||VUSED||' GB, free approximately '||VFREE ||' GB.'||cHR(10)||chr(10);



  SELECT NOTES
   INTO V_FROM
  FROM T_MCREI_WRK_MAIL_SVECCHIAMENTO
  WHERE DESCRIPTION='From';

  SELECT NOTES
   INTO V_MAIL_HOST
  FROM T_MCREI_WRK_MAIL_SVECCHIAMENTO
  WHERE DESCRIPTION='Mail host';


 SELECT NOTES
 INTO V_SUBJECT
  FROM T_MCREI_WRK_MAIL_SVECCHIAMENTO
  WHERE DESCRIPTION='Subject';

  OPEN C_CON;
  LOOP
  FETCH C_CON INTO V_CON;
  EXIT WHEN C_CON%NOTFOUND;
  IF NOT VINSFR THEN
         DBMS_LOB.APPEND(XMLBODY,
    '<Row>
        <Cell><Data ss:Type="String">' ||' '||'</Data></Cell>
        <Cell><Data ss:Type="String">' ||' ' ||'</Data></Cell>
        <Cell><Data ss:Type="String">'||' '||'</Data></Cell>
        <Cell><Data ss:Type="String">' ||' '||'</Data></Cell>
        <Cell><Data ss:Type="String">'||V_CON.TOTAL_MB||'</Data></Cell>
       </Row>
       ');
  VINSFR:=TRUE;
  END IF;
     DBMS_LOB.APPEND(XMLBODY,
    '<Row>
        <Cell><Data ss:Type="String">' ||V_CON.TABLESPACE_NAME||'</Data></Cell>
        <Cell><Data ss:Type="String">' ||V_CON.SIZE_MB ||'</Data></Cell>
        <Cell><Data ss:Type="String">'||V_CON.OBJECT_NAME||'</Data></Cell>
        <Cell><Data ss:Type="String">' ||V_CON.OBJECT_TYPE||'</Data></Cell>
        <Cell><Data ss:Type="String">'||' '||'</Data></Cell>
       </Row>
       ');
 END LOOP;
CLOSE C_CON;

  DBMS_LOB.APPEND(XMLBODY,
 ' </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <Selected/>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>');

   DBMS_LOB.APPEND(XMLBODY,'
  </Workbook>');
   V_SUBJECT:= V_SUBJECT || SDATE;

  V_MAIL_CONN := UTL_SMTP.OPEN_CONNECTION(V_MAIL_HOST, 25);

  UTL_SMTP.HELO(V_MAIL_CONN, V_MAIL_HOST);

  UTL_SMTP.MAIL(V_MAIL_CONN, V_FROM);

  OPEN C_RECIPIENT;
  LOOP
    FETCH C_RECIPIENT INTO V_RECIPIENT;
  EXIT WHEN C_RECIPIENT%NOTFOUND;

   UTL_SMTP.RCPT(V_MAIL_CONN, V_RECIPIENT.NOTES);

   END LOOP;
   CLOSE C_RECIPIENT;

  OPEN C_COPY;
  LOOP
    FETCH C_COPY INTO V_COPY;
  EXIT WHEN C_COPY%NOTFOUND;

   UTL_SMTP.RCPT(V_MAIL_CONN, V_COPY.NOTES);

   END LOOP;
   CLOSE C_COPY;

  UTL_SMTP.OPEN_DATA (V_MAIL_CONN);

  UTL_SMTP.WRITE_DATA(V_MAIL_CONN,
    'Date: '   || TO_CHAR(SYSDATE, 'Dy, DD Mon YYYY hh24:mi:ss') || CRLF ||
    'From: '   || V_FROM || CRLF ||
    'Subject: '|| V_SUBJECT || CRLF );
   OPEN C_RECIPIENT;
  LOOP
    FETCH C_RECIPIENT INTO V_RECIPIENT;
  EXIT WHEN C_RECIPIENT%NOTFOUND;

   UTL_SMTP.WRITE_DATA(V_MAIL_CONN,
     'To: '     || V_RECIPIENT.NOTES || CRLF );

   END LOOP;
   CLOSE C_RECIPIENT;

     OPEN C_COPY;
  LOOP
    FETCH C_COPY INTO V_COPY;
  EXIT WHEN C_COPY%NOTFOUND;
--
   UTL_SMTP.WRITE_DATA(V_MAIL_CONN,
     'Cc: '     || V_COPY.NOTES || CRLF );

   END LOOP;
   CLOSE C_COPY;

  UTL_SMTP.WRITE_DATA(V_MAIL_CONN,
    'MIME-Version: 1.0'|| CRLF ||
    'Content-Type: multipart/mixed;'|| CRLF ||
    ' boundary="-----SECBOUND"'|| CRLF ||
    CRLF ||'-------SECBOUND'|| CRLF ||
    'Content-Type: text/plain;'|| CRLF ||
    'Content-Transfer_Encoding: 7bit'|| CRLF ||
    CRLF || MAILBODY ||CRLF ||
    'Saluti,'|| CRLF ||
    'DBMCRE0' || CRLF ||
    '-------SECBOUND'|| crlf ||
    'Content-Type: text/plain;'|| crlf ||
    ' name="excel.xml"'|| crlf ||
    'Content-Transfer_Encoding: 8bit'|| crlf ||
    'Content-Disposition: attachment;'|| crlf ||
    ' filename="'||v_file_name||'"'|| CRLF ||CRLF);
   V_SIZE := DBMS_LOB.GETLENGTH(XMLBODY);
  WHILE V_SIZE > V_WROTE
    LOOP

        DBMS_LOB.READ(XMLBODY, V_BUFFER_SIZE, V_WROTE + 1, V_RAW);    --V_BUFFER_SIZE PARAMETRO INOUT
        UTL_SMTP.WRITE_DATA(V_MAIL_CONN, V_RAW);
        V_WROTE := V_WROTE + 32760;

    END LOOP;


  UTL_SMTP.WRITE_DATA(V_MAIL_CONN, CRLF || '-------SECBOUND--');
  UTL_SMTP.CLOSE_DATA (V_MAIL_CONN);
  UTL_SMTP.QUIT(V_MAIL_CONN);
DELETE t_mcre0_clob_content;
COMMIT;
insert into t_mcre0_clob_content(id_generazione,xml_text)
values (1,XMLBODY);
commit;

EXCEPTION
  WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
    RAISE_APPLICATION_ERROR(-20000, 'Unable to send mail: '||SQLERRM);
END;

END PKG_MCREI_SVECCHIAMENTO;
/


CREATE SYNONYM MCRE_APP.PKG_MCREI_SVECCHIAMENTO FOR MCRE_OWN.PKG_MCREI_SVECCHIAMENTO;


CREATE SYNONYM MCRE_USR.PKG_MCREI_SVECCHIAMENTO FOR MCRE_OWN.PKG_MCREI_SVECCHIAMENTO;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCREI_SVECCHIAMENTO TO MCRE_USR;

