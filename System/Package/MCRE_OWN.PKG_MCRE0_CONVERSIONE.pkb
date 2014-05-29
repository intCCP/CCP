CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_CONVERSIONE AS
/******************************************************************************
   NAME:       PKG_MCRE0_CONVERSIONE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/10/2010  Chiara Giannangeli  Created this package.
   1.1        25/02/2011  Chiara Giannangeli  Archivi CR
   1.2        24/05/2011  Luca Ferretti       Archivio ANADIP
   1.3        19/12/2011  Andrea Galliano     Aggiunta caricamento DTA_NASCITA su Anagrafica di gruppo
   2.0        24/05/2012  Valeria Galli       Caricamento Email
   2.1        19/06/2012  Emiliano Pellizzi   Evolutiva caricamento Email
   3.0        17/07/2012  Emiliano Pellizzi   Caricamento Pregiudizievoli
******************************************************************************/


        FUNCTION FND_MCRE0_CONVERT_ABI_ELAB(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_ABI_ELAB';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_ABI_ELABORATI';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_ABI_ELABORATI_DT
    WHERE ROWNUM = 1;


    insert
     when
      FND_MCRE0_is_numeric(FA0_ABI_IST) = 0 OR
      FND_MCRE0_is_date(FA0_DAT_ELA) = 0

        then
        into T_MCRE0_SC_CONVERT_ABI_ELAB  (
            ID_SEQ    ,
            ID_DPER    ,
            FA0_ABI_IST    ,
            FA0_DAT_ELA    ,
            FA0_ULT_TMS    ,
            FILLER

            ) values (  seq,
                    v_period,
                    FA0_ABI_IST,
                    FA0_DAT_ELA,
                    FA0_ULT_TMS,
                    FILLER )

           when

            FND_MCRE0_is_numeric(FA0_ABI_IST) = 1 AND
            FND_MCRE0_is_date(FA0_DAT_ELA) = 1

        then
        into   T_MCRE0_FL_ABI_ELABORATI
            (ID_DPER,
            COD_ABI_ISTITUTO,
            DTA_ELABORAZIONE,
            TMS_ULTIMA_ELABORAZIONE)

            values (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
              LPAD(FA0_ABI_IST,5,0),
              TO_DATE(FA0_DAT_ELA, 'DDMMYYYY'),
              FA0_ULT_TMS)



            select  FA0_ABI_IST,
                    FA0_DAT_ELA,
                    FA0_ULT_TMS,
                    FILLER
                    from  TE_MCRE0_ABI_ELABORATI;
              commit;

            INSERT INTO T_MCRE0_SC_CONVERT_ABI_ELAB
            (ID_SEQ    ,
            ID_DPER    ,
            FA0_ABI_IST    ,
            FA0_DAT_ELA    ,
            FA0_ULT_TMS    ,
            FILLER
            )
            SELECT  seq,
                    v_period,
                    te.FA0_ABI_IST,
                    te.FA0_DAT_ELA,
                    te.FA0_ULT_TMS,
                    te.FILLER
            FROM TE_MCRE0_ABI_ELABORATI te
            WHERE  FND_MCRE0_is_numeric(FA0_ABI_IST) = 0 OR
            FND_MCRE0_is_date(FA0_DAT_ELA) = 0;
            commit;

             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_ABI_ELAB SC
             WHERE SC.ID_SEQ = seq;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_CONVERT = v_count
          WHERE ID_FLUSSO = seq;
          commit;


        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_ABI_ELABORATI: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_ABI_ELABORATI: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_ABI_ELABORATI: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;





         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_ABI_ELAB ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);




    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_ABI_ELAB');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_ABI_ELAB;



      FUNCTION FND_MCRE0_CONVERT_FILE_GUIDA(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_FILE_GUIDA';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_FILE_GUIDA';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_FILE_GUIDA_DT
    WHERE ROWNUM = 1;

        insert

         when
            FND_MCRE0_is_numeric(FA1_ABI_IST) = 0 OR
            FND_MCRE0_is_numeric(FA1_ABI_ELA) = 0 OR
            FND_MCRE0_is_numeric(FA1_NDG_SET) = 0 OR
            FND_MCRE0_is_numeric(FA1_NDG_GRP) = 0

        then
       INTO T_MCRE0_SC_CONVERT_FILE_GUIDA
            (ID_SEQ    ,
            ID_DPER    ,
            FA1_ABI_IST    ,
            FA1_ABI_ELA    ,
            FA1_NDG_SET    ,
            FA1_NDG_GRP    ,
            FILLER
            )
            VALUES(  seq,
                    v_period,
                    FA1_ABI_IST,
                    FA1_ABI_ELA,
                    FA1_NDG_SET,
                    FA1_NDG_GRP,
                    FILLER)

           when

            FND_MCRE0_is_numeric(FA1_ABI_IST) = 1 AND
            FND_MCRE0_is_numeric(FA1_ABI_ELA) = 1 AND
            FND_MCRE0_is_numeric(FA1_NDG_SET) = 1 AND
            FND_MCRE0_is_numeric(FA1_NDG_GRP) = 1


        then

        INTO T_MCRE0_FL_FILE_GUIDA
                        (ID_DPER    ,
                        COD_ABI_ISTITUTO    ,
                        COD_ABI_CARTOLARIZZATO    ,
                        COD_NDG    ,
                        COD_SNDG)

            VALUES         (
                          TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                          LPAD(FA1_ABI_IST,5,0),
                          LPAD(FA1_ABI_ELA,5,0),
                          RPAD(FA1_NDG_SET, 16, 0),
                          RPAD(FA1_NDG_GRP, 16, 0)
                          )


            select  FA1_ABI_IST,
                    FA1_ABI_ELA,
                    FA1_NDG_SET,
                    FA1_NDG_GRP,
                    FILLER

                    from  TE_MCRE0_FILE_GUIDA ;
              commit;



             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_FILE_GUIDA SC
             WHERE SC.ID_SEQ = seq;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_CONVERT = v_count
          WHERE ID_FLUSSO = seq;
          commit;


        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_FILE_GUIDA: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_FILE_GUIDA: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_FILE_GUIDA: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;




         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_FILE_GUIDA ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);




    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_FILE_GUIDA');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_FILE_GUIDA;

   FUNCTION FND_MCRE0_CONVERT_GRUPPO_ECO(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_GRUPPO_ECO';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_GRUPPO_ECONOMICO';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_GRUPPO_ECONOMICO_DT
    WHERE ROWNUM = 1;


    insert
     when
            FND_MCRE0_is_numeric(FA3_NDG_GRP) = 0 OR
            FND_MCRE0_is_numeric(FA3_COD_GRE) = 0

        then
        INTO T_MCRE0_SC_CONVERT_GRUPPO_ECO
            (ID_SEQ    ,
            ID_DPER    ,
            FA3_NDG_GRP    ,
            FA3_COD_GRE    ,
            FA3_FLG_CPG    ,
            FILLER

            )
            VALUES (  seq,
                    v_period,
                    FA3_NDG_GRP,
                    FA3_COD_GRE,
                    FA3_FLG_CPG,
                    FILLER )

           when

            FND_MCRE0_is_numeric(FA3_NDG_GRP) = 1 AND
            FND_MCRE0_is_numeric(FA3_COD_GRE) = 1

        then
            INTO T_MCRE0_FL_GRUPPO_ECONOMICO

            (ID_DPER    ,
             COD_SNDG    ,
             COD_GRUPPO_ECONOMICO    ,
             FLG_CAPOGRUPPO
            )

            VALUES (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
              RPAD(FA3_NDG_GRP,16,0),
              FA3_COD_GRE,
              FA3_FLG_CPG )



              select

                    FA3_NDG_GRP,
                    FA3_COD_GRE,
                    FA3_FLG_CPG,
                    FILLER

              from  TE_MCRE0_GRUPPO_ECONOMICO;
              commit;



             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_GRUPPO_ECO  SC
             WHERE SC.ID_SEQ = seq;


          UPDATE T_MCRE0_WRK_ACQUISIZIONE
          SET SCARTI_CONVERT = v_count
          WHERE ID_FLUSSO = seq;
          commit;


        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_GRUPPO_ECO: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_GRUPPO_ECO: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_GRUPPO_ECO: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;



         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_GRUPPO_ECO ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_GRUPPO_ECO');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_GRUPPO_ECO;



 FUNCTION FND_MCRE0_CONVERT_LEGAME(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_LEGAME';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_LEGAME';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_LEGAME_DT
    WHERE ROWNUM = 1;




    insert
     when
            FND_MCRE0_is_numeric(FA2_NDG_GRP) = 0 OR
            FND_MCRE0_is_numeric(FA2_NDG_GRP_LEG) = 0

        then
        INTO T_MCRE0_SC_CONVERT_LEGAME
            (ID_SEQ    ,
            ID_DPER    ,
            FA2_NDG_GRP    ,
            FA2_NDG_GRP_LEG    ,
            FA2_COD_LEG    ,
            FILLER
            )
            VALUES (  seq,
                    v_period,
                    FA2_NDG_GRP    ,
                    FA2_NDG_GRP_LEG    ,
                    FA2_COD_LEG    ,
                    FILLER    )

           when

            FND_MCRE0_is_numeric(FA2_NDG_GRP) = 1 AND
            FND_MCRE0_is_numeric(FA2_NDG_GRP_LEG) = 1

        then
        INTO T_MCRE0_FL_LEGAME

            (ID_DPER    ,
            COD_SNDG    ,
            COD_SNDG_LEGAME    ,
            COD_LEGAME
            )

            values (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
              RPAD(FA2_NDG_GRP,16,0),
              RPAD(FA2_NDG_GRP_LEG,16,0),
              trim(FA2_COD_LEG))


              select

                    FA2_NDG_GRP    ,
                    FA2_NDG_GRP_LEG    ,
                    FA2_COD_LEG    ,
                    FILLER

              from  TE_MCRE0_LEGAME;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_LEGAME  SC
             WHERE SC.ID_SEQ = seq;


              UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;




        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_LEGAME: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_LEGAME: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_LEGAME: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_LEGAME ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_LEGAME');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_LEGAME;


 FUNCTION FND_MCRE0_CONVERT_MOPLE(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_MOPLE';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_MOPLE';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_MOPLE_DT
    WHERE ROWNUM = 1;


    insert
     when
      FND_MCRE0_is_numeric(FA4_ABI_IST) = 0 or
                FND_MCRE0_is_numeric(FA4_ABI_ELA) = 0 or
                FND_MCRE0_is_numeric(FA4_NDG_SET) = 0 or
                FND_MCRE0_is_numeric(FA4_NDG_GRP) = 0 or
                FND_MCRE0_is_date(FA4_DAT_INT) = 0 or
                FND_MCRE0_is_numeric(FA4_COD_FIL) = 0 or
                FND_MCRE0_is_numeric(FA4_COD_UOP) = 0 or
                FND_MCRE0_is_numeric(FA4_NUM_PRG_PRO) = 0 or
                FND_MCRE0_is_date(FA4_DAT_DEC_STA) = 0 or
                FND_MCRE0_is_date(FA4_DAT_SCA_STA) = 0 or
                FND_MCRE0_is_numeric(FA4_PERC_DEC) = 0 or
                FND_MCRE0_is_date(FA4_DAT_PRO) = 0

        then
        into T_MCRE0_SC_CONVERT_MOPLE  (
            ID_SEQ    ,
            ID_DPER   ,
            FA4_ABI_IST    ,
            FA4_ABI_ELA    ,
            FA4_NDG_SET    ,
            FA4_NDG_GRP    ,
            FA4_DAT_INT    ,
            FA4_COD_FIL    ,
            FA4_COD_UOP    ,
            FA4_TIP_ING    ,
            FA4_CAU_ING    ,
            FA4_NUM_PRG_PRO    ,
            FA4_COD_PRO    ,
            FA4_COD_STA    ,
            FA4_DAT_DEC_STA    ,
            FA4_DAT_SCA_STA    ,
            FA4_COD_STA_PRE    ,
            FA4_IDN_SIT_POS    ,
            FA4_COD_EST    ,
            FA4_IND_EST    ,
            FA4_ANA_GES_MKT    ,
            FA4_COD_GES_MKT    ,
            FA4_COD_TIP_POR    ,
            FA4_FLG_GES_EST    ,
            FA4_PERC_DEC    ,
            FILLER,
            FA4_IDN_TRN,
            FA4_DAT_PRO ,
            FA4_MAT_CON    ,
            FA4_COD_ARE    ,
            FA4_COD_DIS

            )
            values (  seq,
                    v_period,
                    FA4_ABI_IST,
                    FA4_ABI_ELA,
                    FA4_NDG_SET,
                    FA4_NDG_GRP,
                    FA4_DAT_INT,
                    FA4_COD_FIL,
                    FA4_COD_UOP,
                    FA4_TIP_ING,
                    FA4_CAU_ING,
                    FA4_NUM_PRG_PRO,
                    FA4_COD_PRO,
                    FA4_COD_STA,
                    FA4_DAT_DEC_STA,
                    FA4_DAT_SCA_STA,
                    FA4_COD_STA_PRE,
                    FA4_IDN_SIT_POS,
                    FA4_COD_EST,
                    FA4_IND_EST,
                    FA4_ANA_GES_MKT,
                    FA4_COD_GES_MKT,
                    FA4_COD_TIP_POR,
                    FA4_FLG_GES_EST,
                    FA4_PERC_DEC,
                    FILLER,
                    FA4_IDN_TRN,
                    FA4_DAT_PRO  ,
                    FA4_MAT_CON    ,
                    FA4_COD_ARE    ,
                    FA4_COD_DIS     )

           when

                    FND_MCRE0_is_numeric(FA4_ABI_IST) = 1 and
                    FND_MCRE0_is_numeric(FA4_ABI_ELA) = 1 and
                    FND_MCRE0_is_numeric(FA4_NDG_SET) = 1 and
                    FND_MCRE0_is_numeric(FA4_NDG_GRP) = 1 and
                    FND_MCRE0_is_date(FA4_DAT_INT) = 1 and
                    FND_MCRE0_is_numeric(FA4_COD_FIL) = 1 and
                    FND_MCRE0_is_numeric(FA4_COD_UOP) = 1 and
                    FND_MCRE0_is_numeric(FA4_NUM_PRG_PRO) = 1 and
                    FND_MCRE0_is_date(FA4_DAT_DEC_STA) = 1 and
                    FND_MCRE0_is_date(FA4_DAT_SCA_STA) = 1 and
                    FND_MCRE0_is_numeric(FA4_PERC_DEC) = 1 and
                    FND_MCRE0_is_date(FA4_DAT_PRO) = 1

        then
        into T_MCRE0_FL_MOPLE (ID_DPER    ,
                                COD_ABI_ISTITUTO    ,
                                COD_ABI_CARTOLARIZZATO    ,
                                COD_NDG    ,
                                COD_SNDG    ,
                                DTA_INTERCETTAMENTO    ,
                                COD_FILIALE    ,
                                COD_STRUTTURA_COMPETENTE    ,
                                COD_TIPO_INGRESSO    ,
                                COD_CAUSALE_INGRESSO    ,
                                COD_PERCORSO    ,
                                COD_PROCESSO    ,
                                COD_STATO    ,
                                DTA_DECORRENZA_STATO    ,
                                DTA_SCADENZA_STATO    ,
                                COD_STATO_PRECEDENTE    ,
                                ID_STATO_POSIZIONE    ,
                                COD_CLIENTE_ESTESO    ,
                                ID_CLIENTE_ESTESO    ,
                                DESC_ANAG_GESTORE_MKT    ,
                                COD_GESTORE_MKT    ,
                                COD_TIPO_PORTAFOGLIO    ,
                                FLG_GESTIONE_ESTERNA    ,
                                VAL_PERC_DECURTAZIONE    ,
                                ID_TRANSIZIONE  ,
                                DTA_PROCESSO ,
                                COD_MATR_RISCHIO    ,
                                COD_UO_RISCHIO    ,
                                COD_DISP_RISCHIO
                                )

                values ( to_number(to_char(v_period, 'yyyymmdd')),
                            LPAD(FA4_ABI_IST, 5, 0),
                            LPAD(FA4_ABI_ELA, 5, 0),
                            RPAD(FA4_NDG_SET,16,0),
                            RPAD(FA4_NDG_GRP,16,0),
                            to_date(FA4_DAT_INT, 'ddmmyyyy'),
                            SUBSTR(FA4_COD_FIL,2,5),
                            SUBSTR(FA4_COD_UOP,2,5),
                            FA4_TIP_ING,
                            FA4_CAU_ING,
                            to_number(FA4_NUM_PRG_PRO),
                            FA4_COD_PRO,
                            FA4_COD_STA,
                            to_date(FA4_DAT_DEC_STA, 'ddmmyyyy'),
                            to_date(FA4_DAT_SCA_STA, 'ddmmyyyy'),
                            FA4_COD_STA_PRE,
                            FA4_IDN_SIT_POS,
                            FA4_COD_EST,
                            FA4_IND_EST,
                            FA4_ANA_GES_MKT,
                            FA4_COD_GES_MKT,
                            FA4_COD_TIP_POR,
                            FA4_FLG_GES_EST,
                            to_number(FA4_PERC_DEC),
                            FA4_IDN_TRN,
                            to_date(FA4_DAT_PRO, 'ddmmyyyy'),
                            FA4_MAT_CON    ,
                            FA4_COD_ARE    ,
                            FA4_COD_DIS
                            )

            select  FA4_ABI_IST,
                    FA4_ABI_ELA,
                    FA4_NDG_SET,
                    FA4_NDG_GRP,
                    FA4_DAT_INT,
                    FA4_COD_FIL,
                    FA4_COD_UOP,
                    FA4_TIP_ING,
                    FA4_CAU_ING,
                    FA4_NUM_PRG_PRO,
                    FA4_COD_PRO,
                    FA4_COD_STA,
                    FA4_DAT_DEC_STA,
                    FA4_DAT_SCA_STA,
                    FA4_COD_STA_PRE,
                    FA4_IDN_SIT_POS,
                    FA4_COD_EST,
                    FA4_IND_EST,
                    FA4_ANA_GES_MKT,
                    FA4_COD_GES_MKT,
                    FA4_COD_TIP_POR,
                    FA4_FLG_GES_EST,
                    FA4_PERC_DEC,
                    FILLER,
                    FA4_IDN_TRN,
                    FA4_DAT_PRO ,
                    FA4_MAT_CON    ,
                    FA4_COD_ARE    ,
                    FA4_COD_DIS
                    from TE_MCRE0_MOPLE;

              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_MOPLE SC
             WHERE SC.ID_SEQ = seq;

              UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;



        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_MOPLE: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_MOPLE: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_MOPLE: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_MOPLE ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);




    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_MOPLE');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_MOPLE;


 FUNCTION FND_MCRE0_CONVERT_PCR_SC_SB(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_PCR_SC_SB';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_PCR_SC_SB';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_PCR_SC_SB_DT
    WHERE ROWNUM = 1;




    insert
     when
            FND_MCRE0_is_numeric(    FA9_ABI_IST    ) = 0 or
            FND_MCRE0_is_numeric(    FA9_NDG_SET    ) = 0 or
            FND_MCRE0_is_numeric(    FA9_IMP_UTI_CLI    ) = 0 or
            FND_MCRE0_is_numeric(    FA9_IMP_ACC_CLI    ) = 0 or
            FND_MCRE0_is_date(    FA9_DAT_RIF    ) = 0 or
            FND_MCRE0_is_numeric(    FA9_IMP_GAR_TOT    ) = 0 or
            FND_MCRE0_is_date(    FA9_DAT_SCA_LDC    ) = 0

        then
        INTO T_MCRE0_SC_CONVERT_PCR_SC_SB
            (ID_SEQ    ,
            ID_DPER    ,
            FA9_ABI_IST    ,
            FA9_NDG_SET    ,
            FA9_COD_FTE    ,
            FA9_IMP_UTI_CLI    ,
            FA9_IMP_ACC_CLI    ,
            FA9_DAT_RIF    ,
            FA9_COD_NAT    ,
            FA9_IMP_GAR_TOT    ,
            FILLER    ,
            FA9_DAT_SCA_LDC

            )
            VALUES (  seq,
                    v_period,
                    FA9_ABI_IST    ,
                    FA9_NDG_SET    ,
                    FA9_COD_FTE    ,
                    FA9_IMP_UTI_CLI    ,
                    FA9_IMP_ACC_CLI    ,
                    FA9_DAT_RIF    ,
                    FA9_COD_NAT    ,
                    FA9_IMP_GAR_TOT    ,
                    FILLER   ,
                    FA9_DAT_SCA_LDC    )

           when

            FND_MCRE0_is_numeric(FA9_ABI_IST) = 1 and
            FND_MCRE0_is_numeric(FA9_NDG_SET) = 1 and
            FND_MCRE0_is_numeric(FA9_IMP_UTI_CLI) = 1 and
            FND_MCRE0_is_numeric(FA9_IMP_ACC_CLI) = 1 and
            FND_MCRE0_is_date(FA9_DAT_RIF) = 1 and
            FND_MCRE0_is_numeric(FA9_IMP_GAR_TOT) = 1 and
            FND_MCRE0_is_date(FA9_DAT_SCA_LDC) = 1

        then
        INTO T_MCRE0_FL_PCR_SC_SB

            (ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_NDG    ,
            COD_FORMA_TECNICA    ,
            VAL_IMP_UTI_CLI    ,
            VAL_IMP_ACC_CLI    ,
            DTA_RIFERIMENTO    ,
            COD_NATURA    ,
            VAL_IMP_GAR_TOT    ,
            DTA_SCADENZA_LDC
            )

            values ( TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                LPAD(FA9_ABI_IST, 5, 0),
                RPAD(FA9_NDG_SET, 16, 0),
                FA9_COD_FTE,
                TO_NUMBER (FA9_IMP_UTI_CLI),
                TO_NUMBER (FA9_IMP_ACC_CLI),
                TO_DATE ( FA9_DAT_RIF, 'DDMMYYYY'),
                FA9_COD_NAT,
                TO_NUMBER (FA9_IMP_GAR_TOT),
                TO_DATE ( FA9_DAT_SCA_LDC, 'DDMMYYYY')
                )


              select

                    FA9_ABI_IST    ,
                    FA9_NDG_SET    ,
                    FA9_COD_FTE    ,
                    FA9_IMP_UTI_CLI    ,
                    FA9_IMP_ACC_CLI    ,
                    FA9_DAT_RIF    ,
                    FA9_COD_NAT    ,
                    FA9_IMP_GAR_TOT    ,
                    FILLER ,
                    FA9_DAT_SCA_LDC

              from  TE_MCRE0_PCR_SC_SB;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_PCR_SC_SB  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;




        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_PCR_SC_SB: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_PCR_SC_SB: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_PCR_SC_SB: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_PCR_SC_SB ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_PCR_SC_SB');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_PCR_SC_SB;


 FUNCTION FND_MCRE0_CONVERT_PERCORSI(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_PERCORSI';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_PERCORSI';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_PERCORSI_DT
    WHERE ROWNUM = 1;


    insert
     when

            FND_MCRE0_is_numeric(FA5_ABI_IST) = 0 or
            FND_MCRE0_is_numeric(FA5_ABI_ELA) = 0 or
            FND_MCRE0_is_numeric(FA6_NDG_SET) = 0 or
            FND_MCRE0_is_date(FA5_DAT_DEC_STA) = 0 or
            FND_MCRE0_is_date(FA5_DAT_SCA_STA) = 0 or
            FND_MCRE0_is_date(FA5_DAT_USC_STA) = 0 or
            FND_MCRE0_is_numeric(FA5_NUM_PRG_PRO) = 0 or
            FND_MCRE0_is_date(FA5_DAT_PRO) = 0


        then
        INTO T_MCRE0_SC_CONVERT_PERCORSI
            (ID_SEQ    ,
            ID_DPER    ,
            FA5_ABI_IST    ,
            FA5_ABI_ELA    ,
            FA6_NDG_SET    ,
            FA5_COD_STA_PRE    ,
            FA5_COD_STA    ,
            FA5_DAT_DEC_STA    ,
            FA5_DAT_SCA_STA    ,
            FA5_DAT_USC_STA    ,
            FA5_NUM_PRG_PRO    ,
            FA5_TMS    ,
            FA5_FLG_ANN    ,
            FA5_COD_UTR    ,
            FA5_COD_PRO    ,
            FA5_IMP_ACC_CAS    ,
            FA5_IMP_UTI_CAS    ,
            FA5_IMP_ACC_FIR    ,
            FA5_IMP_UTI_FIR    ,
            FILLER  ,
            FA5_DAT_PRO   ,
            FA5_IDN_TIP_VAR ,
            FA5_FLG_FAT
            )

            VALUES (  seq,
                    v_period,
                    FA5_ABI_IST    ,
                    FA5_ABI_ELA    ,
                    FA6_NDG_SET    ,
                    FA5_COD_STA_PRE    ,
                    FA5_COD_STA    ,
                    FA5_DAT_DEC_STA    ,
                    FA5_DAT_SCA_STA    ,
                    FA5_DAT_USC_STA    ,
                    FA5_NUM_PRG_PRO    ,
                    FA5_TMS    ,
                    FA5_FLG_ANN    ,
                    FA5_COD_UTR    ,
                    FA5_COD_PRO    ,
                    FA5_IMP_ACC_CAS    ,
                    FA5_IMP_UTI_CAS    ,
                    FA5_IMP_ACC_FIR    ,
                    FA5_IMP_UTI_FIR    ,
                    FILLER  ,
                    FA5_DAT_PRO   ,
                    FA5_IDN_TIP_VAR ,
                    FA5_FLG_FAT   )

           when

                FND_MCRE0_is_numeric(FA5_ABI_IST) = 1 and
                FND_MCRE0_is_numeric(FA5_ABI_ELA) = 1 and
                FND_MCRE0_is_numeric(FA6_NDG_SET) = 1 and
                FND_MCRE0_is_date(FA5_DAT_DEC_STA) = 1 and
                FND_MCRE0_is_date(FA5_DAT_SCA_STA) = 1 and
                FND_MCRE0_is_date(FA5_DAT_USC_STA) = 1 and
                FND_MCRE0_is_numeric(FA5_NUM_PRG_PRO) = 1 and
                FND_MCRE0_is_date(FA5_DAT_PRO) = 1

        then
        INTO T_MCRE0_FL_PERCORSI

            (   ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_ABI_CARTOLARIZZATO    ,
                COD_NDG    ,
                COD_STATO_PRECEDENTE    ,
                COD_STATO    ,
                DTA_DECORRENZA_STATO    ,
                DTA_SCADENZA_STATO    ,
                DTA_USCITA_STATO    ,
                COD_PERCORSO    ,
                TMS    ,
                FLG_ANNULLO    ,
                COD_CODUTRM    ,
                COD_PROCESSO    ,
                VAL_IMP_ACC_CASSA    ,
                VAL_IMP_UTI_CASSA    ,
                VAL_IMP_ACC_FIRMA    ,
                VAL_IMP_UTI_FIRMA    ,
                DTA_PROCESSO    ,
                COD_TIPO_VARIAZIONE    ,
                FLG_FATAL

            )

            values (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                LPAD(FA5_ABI_IST, 5 , 0),
                LPAD(FA5_ABI_ELA, 5 , 0),
                RPAD(FA6_NDG_SET,16, 0),
                trim(FA5_COD_STA_PRE),
                trim(FA5_COD_STA),
                to_date (FA5_DAT_DEC_STA,'ddmmyyyy'),
                to_date (FA5_DAT_SCA_STA,'ddmmyyyy'),
                to_date (FA5_DAT_USC_STA, 'ddmmyyyy'),
                to_number(FA5_NUM_PRG_PRO),
                trim(FA5_TMS),
                trim(FA5_FLG_ANN),
                trim(FA5_COD_UTR),
                trim(FA5_COD_PRO),
                trim(FA5_IMP_ACC_CAS),
                trim(FA5_IMP_UTI_CAS),
                trim(FA5_IMP_ACC_FIR),
                trim(FA5_IMP_UTI_FIR),
                to_date (FA5_DAT_PRO, 'ddmmyyyy'),
                trim(FA5_IDN_TIP_VAR),
                trim(FA5_FLG_FAT) )



              select
                    FA5_ABI_IST    ,
                    FA5_ABI_ELA    ,
                    FA6_NDG_SET    ,
                    FA5_COD_STA_PRE    ,
                    FA5_COD_STA    ,
                    FA5_DAT_DEC_STA    ,
                    FA5_DAT_SCA_STA    ,
                    FA5_DAT_USC_STA    ,
                    FA5_NUM_PRG_PRO    ,
                    FA5_TMS    ,
                    FA5_FLG_ANN    ,
                    FA5_COD_UTR    ,
                    FA5_COD_PRO    ,
                    FA5_IMP_ACC_CAS    ,
                    FA5_IMP_UTI_CAS    ,
                    FA5_IMP_ACC_FIR    ,
                    FA5_IMP_UTI_FIR    ,
                    FILLER  ,
                    FA5_DAT_PRO   ,
                    FA5_IDN_TIP_VAR ,
                    FA5_FLG_FAT


              from  TE_MCRE0_PERCORSI;
           ---   where rownum < 100 ;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_PERCORSI  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;




        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_PERCORSI: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_PERCORSI: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_PERCORSI: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_PERCORSI ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_PERCORSI');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_PERCORSI;

 FUNCTION FND_MCRE0_CONVERT_ANAGR_GRP(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_ANAGR_GRP';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_ANAGRAFICA_GRUPPO';

    SELECT
        TO_DATE(TRIM(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_ANAGRAFICA_GRUPPO_DT
    WHERE ROWNUM = 1;

    insert
     when
            FND_MCRE0_is_numeric(FA7_SAE) = 0 or
            FND_MCRE0_is_numeric(FA7_RAE) = 0 or
            FND_MCRE0_is_date(FA7_DAT_SEG_REG) = 0 or
            FND_MCRE0_is_date(FA7_DAT_RIF_PDO) = 0 or
            FND_MCRE0_is_date(FA7_DAT_INI_REL) = 0 or
            fnd_mcre0_is_date(FA7_DTA_NASC_COST) = 0

        then
        INTO T_MCRE0_SC_CONVERT_ANAGR_GRP
            (ID_SEQ    ,
            ID_DPER    ,
            FA7_NDG_GRP    ,
            FA7_INT    ,
            FA7_PAR_IVA    ,
            FA7_SAE    ,
            FA7_RAE    ,
            FA7_ART_136    ,
            FA7_SOG_COI    ,
            FA7_SEG_REG    ,
            FA7_DAT_SEG_REG    ,
            FA7_PDO    ,
            FA7_DAT_RIF_PDO    ,
            FA7_DAT_INI_REL    ,
            FILLER    ,
            FA7_RAT_PDO,
            FA7_DTA_NASC_COST
            )

            VALUES (  seq,
                    v_period,
                    FA7_NDG_GRP    ,
                    FA7_INT    ,
                    FA7_PAR_IVA    ,
                    FA7_SAE    ,
                    FA7_RAE    ,
                    FA7_ART_136    ,
                    FA7_SOG_COI    ,
                    FA7_SEG_REG    ,
                    FA7_DAT_SEG_REG    ,
                    FA7_PDO    ,
                    FA7_DAT_RIF_PDO    ,
                    FA7_DAT_INI_REL    ,
                    FILLER    ,
                    FA7_RAT_PDO,
                    FA7_DTA_NASC_COST
                       )

           when
            FND_MCRE0_is_numeric(FA7_SAE) = 1 and
            FND_MCRE0_is_numeric(FA7_RAE) = 1 and
            FND_MCRE0_is_date(FA7_DAT_SEG_REG) = 1 and
            FND_MCRE0_is_date(FA7_DAT_RIF_PDO) = 1 and
            FND_MCRE0_is_date(FA7_DAT_INI_REL) = 1 and
            fnd_mcre0_is_date(FA7_DTA_NASC_COST) = 1

        then
        INTO T_MCRE0_FL_ANAGRAFICA_GRUPPO

            (   ID_DPER    ,
                COD_SNDG    ,
                DESC_NOME_CONTROPARTE    ,
                VAL_PARTITA_IVA    ,
                VAL_SETTORE_ECONOMICO    ,
                VAL_RAMO_ECONOMICO    ,
                FLG_ART_136    ,
                COD_SNDG_SOGGETTO    ,
                VAL_SEGMENTO_REGOLAMENTARE    ,
                DTA_SEGMENTO_REGOLAMENTARE    ,
                VAL_PD_ONLINE    ,
                DTA_RIF_PD_ONLINE    ,
                DTA_INIZIO_RELAZIONE    ,
                VAL_RATING_ONLINE,
                dta_nascita_costituzione
                            )
            values (
                    to_number(TO_CHAR(v_period, 'yyyymmdd')) ,
                    RPAD(FA7_NDG_GRP, 16,0),
                    trim(FA7_INT),
                    trim(FA7_PAR_IVA),
                    TO_NUMBER(FA7_SAE),
                    TO_NUMBER(FA7_RAE),
                    trim(FA7_ART_136),
                    RPAD(FA7_SOG_COI, 16, 0),
                    trim(FA7_SEG_REG),
                    TO_DATE(FA7_DAT_SEG_REG, 'ddmmyyyy'),
                    trim(FA7_PDO),
                    TO_DATE(FA7_DAT_RIF_PDO, 'ddmmyyyy'),
                    TO_DATE(FA7_DAT_INI_REL, 'ddmmyyyy')   ,
                    trim(FA7_RAT_PDO),
                    to_date(FA7_DTA_NASC_COST, 'ddmmyyyy')
                   )

              select

                FA7_NDG_GRP    ,
                FA7_INT    ,
                FA7_PAR_IVA    ,
                FA7_SAE    ,
                FA7_RAE    ,
                FA7_ART_136    ,
                FA7_SOG_COI    ,
                FA7_SEG_REG    ,
                FA7_DAT_SEG_REG    ,
                FA7_PDO    ,
                FA7_DAT_RIF_PDO    ,
                FA7_DAT_INI_REL    ,
                FILLER,
                FA7_RAT_PDO,
                FA7_DTA_NASC_COST

              from  TE_MCRE0_ANAGRAFICA_GRUPPO;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_ANAGR_GRP  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;




        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_ANAGR_GRP: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_ANAGR_GRP: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_ANAGR_GRP: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_ANAGR_GRP ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_ANAGR_GRP');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_ANAGR_GRP;



 FUNCTION FND_MCRE0_CONVERT_RATE_ARR(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_RATE_ARR';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_RATE_ARRETRATE';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_RATE_ARRETRATE_DT
    WHERE ROWNUM = 1;


    insert
     when
            FND_MCRE0_is_numeric(FA6_ABI_IST) = 0 or
            FND_MCRE0_is_numeric(FA6_ABI_ELA) = 0 or
            FND_MCRE0_is_numeric(FA6_NDG_SET) = 0 or
            FND_MCRE0_is_date(FA6_DAT_SCA) = 0 or
            FND_MCRE0_is_numeric(FA6_NUM_PRG_PRO) = 0

        then
        INTO T_MCRE0_SC_CONVERT_RATE_ARR
            (ID_SEQ    ,
            ID_DPER    ,
            FA6_ABI_IST    ,
            FA6_ABI_ELA    ,
            FA6_NDG_SET    ,
            FA6_TMS    ,
            FA6_COD_RAP    ,
            FA6_COE_RAT    ,
            FA6_PER_RAT    ,
            FA6_DAT_SCA    ,
            FA6_IMP_ARR    ,
            FA6_IMP_MRA    ,
            FA6_IMP_RAT    ,
            FA6_IMP_RES    ,
            FILLER  ,
            FA6_NUM_PRG_PRO

            )
            VALUES (  seq,
                    v_period,
                    FA6_ABI_IST    ,
                    FA6_ABI_ELA    ,
                    FA6_NDG_SET    ,
                    FA6_TMS    ,
                    FA6_COD_RAP    ,
                    FA6_COE_RAT    ,
                    FA6_PER_RAT    ,
                    FA6_DAT_SCA    ,
                    FA6_IMP_ARR    ,
                    FA6_IMP_MRA    ,
                    FA6_IMP_RAT    ,
                    FA6_IMP_RES    ,
                    FILLER,
                    FA6_NUM_PRG_PRO     )


           when

                FND_MCRE0_is_numeric(FA6_ABI_IST) = 1 and
                FND_MCRE0_is_numeric(FA6_ABI_ELA) = 1 and
                FND_MCRE0_is_numeric(FA6_NDG_SET) = 1 and
                FND_MCRE0_is_date(FA6_DAT_SCA) = 1 and
                FND_MCRE0_is_numeric(FA6_NUM_PRG_PRO) = 1


        then
        INTO T_MCRE0_FL_RATE_ARRETRATE

            (ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_ABI_CARTOLARIZZATO    ,
            COD_NDG    ,
            TMS    ,
            COD_RAPPORTO    ,
            VAL_COEFF_RATE_ARRETRATE    ,
            COD_PERIODO    ,
            DTA_SCADENZA    ,
            VAL_IMP_ARRETRATO    ,
            VAL_IMP_MORA    ,
            VAL_IMP_ULTIMA_RATA    ,
            VAL_IMP_DEBITO_RESIDUO  ,
            COD_PERCORSO
            )

            values (
                TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                LPAD(FA6_ABI_IST, 5, 0),
                LPAD(FA6_ABI_ELA, 5, 0),
                RPAD(FA6_NDG_SET, 16, 0),
                trim(FA6_TMS),
                trim(FA6_COD_RAP),
                FA6_COE_RAT,
                trim(FA6_PER_RAT),
                TO_DATE(FA6_DAT_SCA, 'DDMMYYYY'),
                FA6_IMP_ARR,
                FA6_IMP_MRA,
                FA6_IMP_RAT,
                FA6_IMP_RES,
                TO_NUMBER(FA6_NUM_PRG_PRO)
                )


              select

            FA6_ABI_IST    ,
            FA6_ABI_ELA    ,
            FA6_NDG_SET    ,
            FA6_TMS    ,
            FA6_COD_RAP    ,
            FA6_COE_RAT    ,
            FA6_PER_RAT    ,
            FA6_DAT_SCA    ,
            FA6_IMP_ARR    ,
            FA6_IMP_MRA    ,
            FA6_IMP_RAT    ,
            FA6_IMP_RES    ,
            FILLER    ,
            FA6_NUM_PRG_PRO

            FROM TE_MCRE0_RATE_ARRETRATE;




             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_RATE_ARR  SC
             WHERE SC.ID_SEQ = seq;

              UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;





        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_RATE_ARR: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_RATE_ARR: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_RATE_ARR: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_RATE_ARR ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_RATE_ARR');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_RATE_ARR;

 FUNCTION FND_MCRE0_CONVERT_SAG(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_SAG';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_SAG';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_SAG_DT
    WHERE ROWNUM = 1;




    insert
     when
            FND_MCRE0_is_numeric(FAE_NDG_GRP) = 0 OR
            FND_MCRE0_is_date(FAE_DAT_SAG) = 0 OR
            FND_MCRE0_is_date(FAE_DAT_CNF) = 0

        then
        INTO T_MCRE0_SC_CONVERT_SAG
            (ID_SEQ    ,
            ID_DPER    ,
            FAE_NDG_GRP    ,
            FAE_COD_SAG    ,
            FAE_DAT_SAG    ,
            FAE_FLG_ALL    ,
            FAE_FLG_CNF    ,
            FAE_DAT_CNF    ,
            FILLER
            )

            VALUES (  seq,
                    v_period,
                    FAE_NDG_GRP    ,
                    FAE_COD_SAG    ,
                    FAE_DAT_SAG    ,
                    FAE_FLG_ALL    ,
                    FAE_FLG_CNF    ,
                    FAE_DAT_CNF    ,
                    FILLER  )

           when
            FND_MCRE0_is_numeric(FAE_NDG_GRP) = 1 and
            FND_MCRE0_is_date(FAE_DAT_SAG) = 1 and
            FND_MCRE0_is_date(FAE_DAT_CNF) = 1

        then
        INTO T_MCRE0_FL_SAG

            (
            ID_DPER    ,
            COD_SNDG    ,
            COD_SAG    ,
            DTA_CALCOLO_SAG    ,
            FLG_ALLINEAMENTO    ,
            FLG_CONFERMA    ,
            DTA_CONFERMA
            )

            values (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
              RPAD(FAE_NDG_GRP,16,0),
              trim(FAE_COD_SAG)    ,
              to_date(FAE_DAT_SAG, 'ddmmyyyy')    ,
              trim(FAE_FLG_ALL)    ,
              trim(FAE_FLG_CNF)    ,
              to_date(FAE_DAT_CNF, 'ddmmyyyy')
              )


              select
                FAE_NDG_GRP    ,
                FAE_COD_SAG    ,
                FAE_DAT_SAG    ,
                FAE_FLG_ALL    ,
                FAE_FLG_CNF    ,
                FAE_DAT_CNF    ,
                FILLER


              from  TE_MCRE0_SAG;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_SAG  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;




        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_SAG: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_SAG: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_SAG: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_SAG ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_SAG');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_SAG;

 FUNCTION FND_MCRE0_CONVERT_SAB_XRA(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_SAB_XRA';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_SAB_XRA';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_SAB_XRA_DT
    WHERE ROWNUM = 1;




    insert
     when
            FND_MCRE0_is_numeric(FAF_ABI_IST) = 0 OR
            FND_MCRE0_is_numeric(FAF_ABI_ELA) = 0 OR
            FND_MCRE0_is_numeric(FAF_NDG_SET) = 0 OR
            FND_MCRE0_is_numeric(FAF_GIO_SCF) = 0 OR
            FND_MCRE0_is_numeric(FAF_GIO_SCF_RAP) = 0 or
            FND_MCRE0_is_numeric(FAF_IMP_SCO_NDG) = 0

        then
        INTO T_MCRE0_SC_CONVERT_SAB_XRA
            (ID_SEQ    ,
            ID_DPER    ,
            FAF_ABI_IST    ,
            FAF_ABI_ELA    ,
            FAF_NDG_SET    ,
            FAF_COD_SAB    ,
            FAF_FLG_SGL    ,
            FAF_GIO_SCF    ,
            FAF_COD_RAP    ,
            FAF_GIO_SCF_RAP    ,
            FILLER  ,
            FAF_IMP_SCO_NDG

            )

            VALUES (  seq,
                    v_period,
                    FAF_ABI_IST    ,
                    FAF_ABI_ELA    ,
                    FAF_NDG_SET    ,
                    FAF_COD_SAB    ,
                    FAF_FLG_SGL    ,
                    FAF_GIO_SCF    ,
                    FAF_COD_RAP    ,
                    FAF_GIO_SCF_RAP    ,
                    FILLER    ,
                    FAF_IMP_SCO_NDG
                     )

           when
            FND_MCRE0_is_numeric(FAF_ABI_IST) = 1 AND
            FND_MCRE0_is_numeric(FAF_ABI_ELA) = 1 AND
            FND_MCRE0_is_numeric(FAF_NDG_SET) = 1 AND
            FND_MCRE0_is_numeric(FAF_GIO_SCF) = 1 AND
            FND_MCRE0_is_numeric(FAF_GIO_SCF_RAP) = 1 AND
            FND_MCRE0_is_numeric(FAF_IMP_SCO_NDG) = 1


        then
        INTO T_MCRE0_FL_SAB_XRA

            (
            ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_ABI_CARTOLARIZZATO    ,
            COD_NDG    ,
            COD_SAB    ,
            FLG_SOGLIA    ,
            NUM_GIORNI_SCONFINO    ,
            COD_RAP    ,
            NUM_GIORNI_SCONFINO_RAP   ,
            VAL_IMP_SCONFINO
            )

            values (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
              LPAD(FAF_ABI_IST,5,0),
              LPAD(FAF_ABI_ELA,5,0),
              RPAD(FAF_NDG_SET,16,0),
              trim(FAF_COD_SAB)    ,
              trim(FAF_FLG_SGL)    ,
              to_NUMBER(FAF_GIO_SCF)    ,
              trim(FAF_COD_RAP)    ,
              to_NUMBER(FAF_GIO_SCF_RAP),
              to_NUMBER(FAF_IMP_SCO_NDG)
              )


              select
                    FAF_ABI_IST    ,
                    FAF_ABI_ELA    ,
                    FAF_NDG_SET    ,
                    FAF_COD_SAB    ,
                    FAF_FLG_SGL    ,
                    FAF_GIO_SCF    ,
                    FAF_COD_RAP    ,
                    FAF_GIO_SCF_RAP    ,
                    FAF_IMP_SCO_NDG ,
                    FILLER



              from  TE_MCRE0_SAB_XRA;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_SAB_XRA  SC
             WHERE SC.ID_SEQ = seq;



             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;




        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_SAB_XRA: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_SAB_XRA: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_SAB_XRA: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_SAB_XRA ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_SAB_XRA');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_SAB_XRA;


 FUNCTION FND_MCRE0_CONVERT_ANAGR_GRE(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_ANAGR_GRE';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_ANAGRAFICA_GRE';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_ANAGR_GRE_DT
    WHERE ROWNUM = 1;




    insert
     when
            FND_MCRE0_is_numeric(FAM_COD_GRE) = 0

        then
        INTO T_MCRE0_SC_CONVERT_ANAGR_GRE

            (ID_SEQ    ,
            ID_DPER    ,
            FAM_COD_GRE    ,
            FAM_ANA_GRE    ,
            FILLER

            )
            VALUES (  seq,
                    v_period,
                    FAM_COD_GRE    ,
                    FAM_ANA_GRE    ,
                    FILLER     )

           when

            FND_MCRE0_is_numeric(FAM_COD_GRE) = 1

        then
        INTO T_MCRE0_FL_ANAGRAFICA_GRE


            (
            ID_DPER    ,
            COD_GRUPPO_ECO    ,
            DESC_GRUPPO_ECO
            )

            values (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
              TRIM(FAM_COD_GRE),
              TRIM(FAM_ANA_GRE)
              )


              select

                    FAM_COD_GRE    ,
                    FAM_ANA_GRE    ,
                    FILLER


              from  TE_MCRE0_ANAGRAFICA_GRE;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_ANAGR_GRE  SC
             WHERE SC.ID_SEQ = seq;


             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;



        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_ANAGR_GRE: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_ANAGR_GRE: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_ANAGR_GRE: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_ANAGR_GRE ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_ANAGR_GRE');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_ANAGR_GRE;

 FUNCTION FND_MCRE0_CONVERT_PCR_GB(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_PCR_GB';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_PCR_GB';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_PCR_GB_DT
    WHERE ROWNUM = 1;



    insert
     when
             FND_MCRE0_is_numeric(FAB_IMP_UTI_CLI) = 0 or
             FND_MCRE0_is_numeric(FAB_IMP_ACC_CLI) = 0 or
             FND_MCRE0_is_numeric(FAB_IMP_UTI_GRE) = 0 or
             FND_MCRE0_is_numeric(FAB_IMP_ACC_GRE) = 0 or
             FND_MCRE0_is_numeric(FAB_IMP_UTI_LEG) = 0 or
             FND_MCRE0_is_numeric(FAB_IMP_ACC_LEG) = 0 or
             FND_MCRE0_is_date(FAB_DAT_RIF) = 0 or
             FND_MCRE0_is_numeric(FAB_MAU_GRP) = 0 or
             FND_MCRE0_is_numeric(FAB_MAU_CLI)= 0 or

             FND_MCRE0_is_numeric(FAB_IMP_GAR_CLI) = 0 or
             FND_MCRE0_is_date(FAB_DAT_LDC_CLI) = 0 or
             FND_MCRE0_is_numeric(FAB_IMP_GAR_GRE    ) = 0 or
             FND_MCRE0_is_date(FAB_DAT_LDC_GRE) = 0 or
             FND_MCRE0_is_numeric(FAB_IMP_GAR_LEG) = 0 or
             FND_MCRE0_is_date(FAB_DAT_LDC_LEG) = 0 or
             FND_MCRE0_is_numeric(FAB_MAU_LEG) = 0


        then
        INTO T_MCRE0_SC_CONVERT_PCR_GB

            (ID_SEQ    ,
            ID_DPER    ,
            FAB_NDG_GRP    ,
            FAB_COD_FTE    ,
            FAB_IMP_UTI_CLI    ,
            FAB_IMP_ACC_CLI    ,
            FAB_IMP_UTI_GRE    ,
            FAB_IMP_ACC_GRE    ,
            FAB_IMP_UTI_LEG    ,
            FAB_IMP_ACC_LEG    ,
            FAB_COD_NAT    ,
            FAB_DAT_RIF    ,
            FAB_MAU_GRP    ,
            FAB_MAU_CLI    ,
            FILLER    ,
            FAB_IMP_GAR_CLI    ,
            FAB_DAT_LDC_CLI    ,
            FAB_IMP_GAR_GRE    ,
            FAB_DAT_LDC_GRE    ,
            FAB_IMP_GAR_LEG    ,
            FAB_DAT_LDC_LEG    ,
            FAB_MAU_LEG

            )
            VALUES (  seq,
                    v_period,
                    FAB_NDG_GRP    ,
                    FAB_COD_FTE    ,
                    FAB_IMP_UTI_CLI    ,
                    FAB_IMP_ACC_CLI    ,
                    FAB_IMP_UTI_GRE    ,
                    FAB_IMP_ACC_GRE    ,
                    FAB_IMP_UTI_LEG    ,
                    FAB_IMP_ACC_LEG    ,
                    FAB_COD_NAT    ,
                    FAB_DAT_RIF    ,
                    FAB_MAU_GRP    ,
                    FAB_MAU_CLI    ,
                    FILLER    ,
                    FAB_IMP_GAR_CLI    ,
                    FAB_DAT_LDC_CLI    ,
                    FAB_IMP_GAR_GRE    ,
                    FAB_DAT_LDC_GRE    ,
                    FAB_IMP_GAR_LEG    ,
                    FAB_DAT_LDC_LEG    ,
                    FAB_MAU_LEG
  )

           when

             FND_MCRE0_is_numeric(FAB_IMP_UTI_CLI) = 1 and
             FND_MCRE0_is_numeric(FAB_IMP_ACC_CLI) = 1 and
             FND_MCRE0_is_numeric(FAB_IMP_UTI_GRE) = 1 and
             FND_MCRE0_is_numeric(FAB_IMP_ACC_GRE) = 1 and
             FND_MCRE0_is_numeric(FAB_IMP_UTI_LEG) = 1 and
             FND_MCRE0_is_numeric(FAB_IMP_ACC_LEG) = 1 and
             FND_MCRE0_is_date(FAB_DAT_RIF) = 1 and
             FND_MCRE0_is_numeric(FAB_MAU_GRP) = 1 and
             FND_MCRE0_is_numeric(FAB_MAU_CLI)= 1 and
             FND_MCRE0_is_numeric(FAB_IMP_GAR_CLI) = 1 and
             FND_MCRE0_is_date(FAB_DAT_LDC_CLI) = 1 and
             FND_MCRE0_is_numeric(FAB_IMP_GAR_GRE    ) = 1 and
             FND_MCRE0_is_date(FAB_DAT_LDC_GRE) = 1 and
             FND_MCRE0_is_numeric(FAB_IMP_GAR_LEG) = 1 and
             FND_MCRE0_is_date(FAB_DAT_LDC_LEG) = 1 and
             FND_MCRE0_is_numeric(FAB_MAU_LEG) = 1


        then
        INTO T_MCRE0_FL_PCR_GB

            (ID_DPER    ,
            COD_SNDG    ,
            COD_FORMA_TECNICA    ,
            VAL_IMP_UTI_CLI    ,
            VAL_IMP_ACC_CLI    ,
            VAL_IMP_UTI_GRE    ,
            VAL_IMP_ACC_GRE    ,
            VAL_IMP_UTI_LEG    ,
            VAL_IMP_ACC_LEG    ,
            COD_NATURA    ,
            DTA_RIFERIMENTO    ,
            MAU_GRP    ,
            MAU_CLI    ,
            VAL_IMP_GAR_CLI    ,
            DTA_SCADENZA_LDC_CLI    ,
            VAL_IMP_GAR_GRE    ,
            DTA_SCADENZA_LDC_GRE    ,
            VAL_IMP_GAR_LEG    ,
            DTA_SCADENZA_LDC_LEG    ,
            MAU_LEG

            )

            values (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                RPAD(FAB_NDG_GRP, 16, 0) ,
                TRIM(FAB_COD_FTE) ,
                TO_NUMBER(FAB_IMP_UTI_CLI) ,
                TO_NUMBER(FAB_IMP_ACC_CLI) ,
                TO_NUMBER(FAB_IMP_UTI_GRE) ,
                TO_NUMBER(FAB_IMP_ACC_GRE) ,
                TO_NUMBER(FAB_IMP_UTI_LEG) ,
                TO_NUMBER(FAB_IMP_ACC_LEG) ,
                TRIM(FAB_COD_NAT) ,
                TO_DATE(FAB_DAT_RIF, 'DDMMYYYY') ,
                TO_NUMBER(FAB_MAU_GRP) ,
                TO_NUMBER(FAB_MAU_CLI),
                TO_NUMBER(FAB_IMP_GAR_CLI) ,
                TO_DATE(FAB_DAT_LDC_CLI    , 'DDMMYYYY') ,
                TO_NUMBER(FAB_IMP_GAR_GRE) ,
                TO_DATE(FAB_DAT_LDC_GRE    , 'DDMMYYYY') ,
                TO_NUMBER(FAB_IMP_GAR_LEG) ,
                TO_DATE(FAB_DAT_LDC_LEG    , 'DDMMYYYY') ,
                TO_NUMBER(FAB_MAU_LEG)
                )


              select

                FAB_NDG_GRP    ,
                FAB_COD_FTE    ,
                FAB_IMP_UTI_CLI    ,
                FAB_IMP_ACC_CLI    ,
                FAB_IMP_UTI_GRE    ,
                FAB_IMP_ACC_GRE    ,
                FAB_IMP_UTI_LEG    ,
                FAB_IMP_ACC_LEG    ,
                FAB_COD_NAT    ,
                FAB_DAT_RIF    ,
                FAB_MAU_GRP    ,
                FAB_MAU_CLI    ,
                FILLER,
                FAB_IMP_GAR_CLI    ,
                FAB_DAT_LDC_CLI    ,
                FAB_IMP_GAR_GRE    ,
                FAB_DAT_LDC_GRE    ,
                FAB_IMP_GAR_LEG    ,
                FAB_DAT_LDC_LEG    ,
                FAB_MAU_LEG



              from  TE_MCRE0_PCR_GB;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_PCR_GB  SC
             WHERE SC.ID_SEQ = seq;

              UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;



        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_PCR_GB: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_PCR_GB: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_PCR_GB: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_PCR_GB ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_PCR_GB');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_PCR_GB;


FUNCTION FND_MCRE0_CONVERT_PCR_GE_SB(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_PCR_GE_SB';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_PCR_GE_SB';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_PCR_GE_SB_DT
    WHERE ROWNUM = 1;




    insert
     when   FND_MCRE0_is_numeric(FAA_ABI_IST)= 0 or
            FND_MCRE0_is_numeric(FAA_NDG_CPG)= 0 or
            FND_MCRE0_is_numeric(FAA_IMP_GAR_GRE)= 0 or
            FND_MCRE0_is_numeric(FAA_IMP_UTI_GRE)= 0 or
            FND_MCRE0_is_numeric(FAA_IMP_ACC_GRE)= 0 or
            FND_MCRE0_is_date(FAA_DAT_RIF)= 0 or
            FND_MCRE0_is_date(    FAA_DAT_SCA_LDC    ) = 0

        then
        INTO T_MCRE0_SC_CONVERT_PCR_GE_SB
            (ID_SEQ    ,
            ID_DPER    ,
            FAA_ABI_IST    ,
            FAA_NDG_CPG    ,
            FAA_COD_FTE ,
            FAA_IMP_GAR_GRE    ,
            FAA_IMP_UTI_GRE    ,
            FAA_IMP_ACC_GRE    ,
            FAA_DAT_RIF    ,
            FAA_COD_NAT    ,
            FILLER    ,
            FAA_DAT_SCA_LDC

            )
            VALUES (    seq,
                        v_period,
                        FAA_ABI_IST    ,
                        FAA_NDG_CPG    ,
                        FAA_COD_FTE ,
                        FAA_IMP_GAR_GRE    ,
                        FAA_IMP_UTI_GRE    ,
                        FAA_IMP_ACC_GRE    ,
                        FAA_DAT_RIF    ,
                        FAA_COD_NAT    ,
                        FILLER    ,
                        FAA_DAT_SCA_LDC
                           )

           when
                FND_MCRE0_is_numeric(FAA_ABI_IST)= 1 and
                FND_MCRE0_is_numeric(FAA_NDG_CPG)= 1 and
                FND_MCRE0_is_numeric(FAA_IMP_GAR_GRE)= 1 and
                FND_MCRE0_is_numeric(FAA_IMP_UTI_GRE)= 1 and
                FND_MCRE0_is_numeric(FAA_IMP_ACC_GRE)= 1 and
                FND_MCRE0_is_date(FAA_DAT_RIF)= 1 and
                FND_MCRE0_is_date(FAA_DAT_SCA_LDC)= 1


        then
        INTO T_MCRE0_FL_PCR_GE_SB

            (ID_DPER    ,
            COD_ABI_ISTITUTO    ,
            COD_SNDG    ,
            COD_FORMA_TECN,
            VAL_IMP_GAR_GRE    ,
            VAL_IMP_UTI_GRE    ,
            VAL_IMP_ACC_GRE    ,
            DTA_RIFERIMENTO    ,
            COD_NATURA    ,
            DTA_SCADENZA_LDC

            )

            values (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
            LPAD(FAA_ABI_IST, 5, 0)    ,
            RPAD(FAA_NDG_CPG, 16, 0),
            TRIM(FAA_COD_FTE),
            TO_NUMBER(FAA_IMP_GAR_GRE)    ,
            TO_NUMBER(FAA_IMP_UTI_GRE)    ,
            TO_NUMBER(FAA_IMP_ACC_GRE)    ,
            to_date(FAA_DAT_RIF, 'ddmmyyyy')    ,
            trim(FAA_COD_NAT),
            to_date(FAA_DAT_SCA_LDC, 'ddmmyyyy')
            )


              select

                    FAA_ABI_IST    ,
                    FAA_NDG_CPG    ,
                    FAA_COD_FTE ,
                    FAA_IMP_GAR_GRE    ,
                    FAA_IMP_UTI_GRE    ,
                    FAA_IMP_ACC_GRE    ,
                    FAA_DAT_RIF    ,
                    FAA_COD_NAT    ,
                    FILLER   ,
                    FAA_DAT_SCA_LDC


              from  TE_MCRE0_PCR_GE_SB;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_PCR_GE_SB  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;




        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_PCR_GE_SB: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_PCR_GE_SB: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_PCR_GE_SB: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_PCR_GE_SB ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_PCR_GE_SB');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_PCR_GE_SB;


FUNCTION FND_MCRE0_CONVERT_RICH_MON(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_RICH_MON';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_RICH_MON';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_RICH_MON_DT
    WHERE ROWNUM = 1;




    insert
     when
            FND_MCRE0_is_numeric(FA8_NDG_GRP) = 0

        then
        INTO T_MCRE0_SC_CONVERT_RICH_MON
            (ID_SEQ    ,
            ID_DPER    ,
            FA8_NDG_GRP   ,
            FILLER
            )
            VALUES (  seq,
                    v_period,
                    FA8_NDG_GRP   ,
                    FILLER
                    )

           when

            FND_MCRE0_is_numeric(FA8_NDG_GRP) = 1

        then
        INTO T_MCRE0_FL_RICH_MON

            (ID_DPER    ,
            COD_SNDG
            )

            values (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
              RPAD(FA8_NDG_GRP,16,0)
              )



              select

                    FA8_NDG_GRP    ,
                    FILLER

              from  TE_MCRE0_RICH_MON;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_RICH_MON  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;




        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_RICH_MON: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_RICH_MON: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_RICH_MON: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_RICH_MON ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_RICH_MON');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_RICH_MON;

FUNCTION FND_MCRE0_CONVERT_CR_SC_GB(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_CR_SC_GB';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_CR_SC_GB';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_CR_SC_GB_DT
    WHERE ROWNUM = 1;


    insert
     when

        FND_MCRE0_is_date(FAH_DAT_RIF_CR) = 0 or
        FND_MCRE0_is_date(FAH_DAT_SIS) = 0 or
        FND_MCRE0_is_numeric(FAH_IMP_ACC_CLI) = 0 or
        FND_MCRE0_is_numeric(FAH_IMP_ACC_SIS) = 0 or
        FND_MCRE0_is_numeric(FAH_IMP_GAR_CLI) = 0 or
        FND_MCRE0_is_numeric(FAH_IMP_GAR_SIS) = 0 or
        FND_MCRE0_is_numeric(FAH_IMP_SCO_CLI) = 0 or
        FND_MCRE0_is_numeric(FAH_IMP_SCO_SIS) = 0 or
        FND_MCRE0_is_numeric(FAH_IMP_UTI_CLI) = 0 or
        FND_MCRE0_is_numeric(FAH_IMP_UTI_SIS) = 0


        then
        INTO T_MCRE0_SC_CONVERT_CR_SC_GB
            (   ID_SEQ    ,
                ID_DPER ,
                FAH_DAT_RIF_CR    ,
                FAH_DAT_SIS    ,
                FAH_IMP_ACC_CLI    ,
                FAH_IMP_ACC_SIS    ,
                FAH_IMP_GAR_CLI    ,
                FAH_IMP_GAR_SIS    ,
                FAH_IMP_SCO_CLI    ,
                FAH_IMP_SCO_SIS    ,
                FAH_IMP_UTI_CLI    ,
                FAH_IMP_UTI_SIS    ,
                FAH_NDG_GRP    ,
                FAH_STA_SIS    ,
                FILLER
            )
            VALUES (seq,
                    v_period,
                    FAH_DAT_RIF_CR    ,
                    FAH_DAT_SIS    ,
                    FAH_IMP_ACC_CLI    ,
                    FAH_IMP_ACC_SIS    ,
                    FAH_IMP_GAR_CLI    ,
                    FAH_IMP_GAR_SIS    ,
                    FAH_IMP_SCO_CLI    ,
                    FAH_IMP_SCO_SIS    ,
                    FAH_IMP_UTI_CLI    ,
                    FAH_IMP_UTI_SIS    ,
                    FAH_NDG_GRP    ,
                    FAH_STA_SIS    ,
                    FILLER
                            )

           when

            FND_MCRE0_is_date(FAH_DAT_RIF_CR) = 1 and
            FND_MCRE0_is_date(FAH_DAT_SIS) = 1 and
            FND_MCRE0_is_numeric(FAH_IMP_ACC_CLI) = 1 and
            FND_MCRE0_is_numeric(FAH_IMP_ACC_SIS) = 1 and
            FND_MCRE0_is_numeric(FAH_IMP_GAR_CLI) = 1 and
            FND_MCRE0_is_numeric(FAH_IMP_GAR_SIS) = 1 and
            FND_MCRE0_is_numeric(FAH_IMP_SCO_CLI) = 1 and
            FND_MCRE0_is_numeric(FAH_IMP_SCO_SIS) = 1 and
            FND_MCRE0_is_numeric(FAH_IMP_UTI_CLI) = 1 and
            FND_MCRE0_is_numeric(FAH_IMP_UTI_SIS) = 1

        then
        INTO T_MCRE0_FL_CR_SC_GB

            (   ID_DPER ,
                DTA_RIFERIMENTO_CR    ,
                DTA_STATO_SIS    ,
                VAL_ACC_CR_SC    ,
                VAL_ACC_SIS_SC    ,
                VAL_GAR_CR_SC    ,
                VAL_GAR_SIS_SC    ,
                VAL_SCO_CR_SC    ,
                VAL_SCO_SIS_SC    ,
                VAL_UTI_CR_SC    ,
                VAL_UTI_SIS_SC    ,
                COD_SNDG    ,
                COD_STATO_SIS

            )

            values (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                        to_date(FAH_DAT_RIF_CR, 'ddmmyyyy'),
                        to_date(FAH_DAT_SIS, 'ddmmyyyy'),
                        to_number(FAH_IMP_ACC_CLI)    ,
                        to_number(FAH_IMP_ACC_SIS)    ,
                        to_number(FAH_IMP_GAR_CLI)    ,
                        to_number(FAH_IMP_GAR_SIS)    ,
                        to_number(FAH_IMP_SCO_CLI)    ,
                        to_number(FAH_IMP_SCO_SIS)    ,
                        to_number(FAH_IMP_UTI_CLI)    ,
                        to_number(FAH_IMP_UTI_SIS)    ,
                        RPAD(FAH_NDG_GRP,16,0) ,
                        trim(FAH_STA_SIS)
                    )



              select
               FAH_DAT_RIF_CR,
                FAH_DAT_SIS    ,
                FAH_IMP_ACC_CLI    ,
                FAH_IMP_ACC_SIS    ,
                FAH_IMP_GAR_CLI    ,
                FAH_IMP_GAR_SIS    ,
                FAH_IMP_SCO_CLI    ,
                FAH_IMP_SCO_SIS    ,
                FAH_IMP_UTI_CLI    ,
                FAH_IMP_UTI_SIS    ,
                FAH_NDG_GRP    ,
                FAH_STA_SIS    ,
                FILLER

              from  TE_MCRE0_CR_SC_GB;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_CR_SC_GB  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;


        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_CR_SC_GB: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_CR_SC_GB: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_CR_SC_GB: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_CR_SC_GB ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_CR_SC_GB');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_CR_SC_GB;


FUNCTION FND_MCRE0_CONVERT_CR_GE_GB(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_CR';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_CR_GE_GB';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_CR_GE_GB_DT
    WHERE ROWNUM = 1;


    insert
     when

        FND_MCRE0_is_date(FAI_DAT_RIF_CR) = 0 or
        FND_MCRE0_is_numeric(FAI_IMP_ACC_GRE) = 0 or
        FND_MCRE0_is_numeric(FAI_IMP_ACC_SIS) = 0 or
        FND_MCRE0_is_numeric(FAI_IMP_GAR_GRE) = 0 or
        FND_MCRE0_is_numeric(FAI_IMP_GAR_SIS) = 0 or
        FND_MCRE0_is_numeric(FAI_IMP_SCO_GRE) = 0 or
        FND_MCRE0_is_numeric(FAI_IMP_SCO_SIS) = 0 or
        FND_MCRE0_is_numeric(FAI_IMP_UTI_GRE) = 0 or
        FND_MCRE0_is_numeric(FAI_IMP_UTI_SIS) = 0


        then
        INTO T_MCRE0_SC_CONVERT_CR_GE_GB
            (   ID_SEQ    ,
                ID_DPER ,
                FAI_DAT_RIF_CR    ,
                FAI_IMP_ACC_GRE    ,
                FAI_IMP_ACC_SIS    ,
                FAI_IMP_GAR_GRE    ,
                FAI_IMP_GAR_SIS    ,
                FAI_IMP_SCO_GRE    ,
                FAI_IMP_SCO_SIS    ,
                FAI_IMP_UTI_GRE    ,
                FAI_IMP_UTI_SIS    ,
                FAI_NDG_CPG    ,
                FILLER
            )
            VALUES (seq,
                    v_period,
                    FAI_DAT_RIF_CR    ,
                    FAI_IMP_ACC_GRE    ,
                    FAI_IMP_ACC_SIS    ,
                    FAI_IMP_GAR_GRE    ,
                    FAI_IMP_GAR_SIS    ,
                    FAI_IMP_SCO_GRE    ,
                    FAI_IMP_SCO_SIS    ,
                    FAI_IMP_UTI_GRE    ,
                    FAI_IMP_UTI_SIS    ,
                    FAI_NDG_CPG    ,
                    FILLER
                            )

           when

            FND_MCRE0_is_date(FAI_DAT_RIF_CR) = 1 and
            FND_MCRE0_is_numeric(FAI_IMP_ACC_GRE) = 1 and
            FND_MCRE0_is_numeric(FAI_IMP_ACC_SIS) = 1 and
            FND_MCRE0_is_numeric(FAI_IMP_GAR_GRE) = 1 and
            FND_MCRE0_is_numeric(FAI_IMP_GAR_SIS) = 1 and
            FND_MCRE0_is_numeric(FAI_IMP_SCO_GRE) = 1 and
            FND_MCRE0_is_numeric(FAI_IMP_SCO_SIS) = 1 and
            FND_MCRE0_is_numeric(FAI_IMP_UTI_GRE) = 1 and
            FND_MCRE0_is_numeric(FAI_IMP_UTI_SIS) = 1

        then
        INTO T_MCRE0_FL_CR_GE_GB

            (   ID_DPER ,
                DTA_RIFERIMENTO_CR    ,
                VAL_ACC_CR_GE    ,
                VAL_ACC_SIS_GE    ,
                VAL_GAR_CR_GE    ,
                VAL_GAR_SIS_GE    ,
                VAL_SCO_CR_GE    ,
                VAL_SCO_SIS_GE    ,
                VAL_UTI_CR_GE    ,
                VAL_UTI_SIS_GE    ,
                COD_SNDG_GE


            )

            values (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                        TO_DATE(FAI_DAT_RIF_CR, 'ddmmyyyy'),
                        TO_NUMBER(FAI_IMP_ACC_GRE),
                        TO_NUMBER(FAI_IMP_ACC_SIS),
                        TO_NUMBER(FAI_IMP_GAR_GRE),
                        TO_NUMBER(FAI_IMP_GAR_SIS),
                        TO_NUMBER(FAI_IMP_SCO_GRE),
                        TO_NUMBER(FAI_IMP_SCO_SIS),
                        TO_NUMBER(FAI_IMP_UTI_GRE),
                        TO_NUMBER(FAI_IMP_UTI_SIS),
                        RPAD(FAI_NDG_CPG,16,0)
                    )



              select
                FAI_DAT_RIF_CR    ,
                FAI_IMP_ACC_GRE    ,
                FAI_IMP_ACC_SIS    ,
                FAI_IMP_GAR_GRE    ,
                FAI_IMP_GAR_SIS    ,
                FAI_IMP_SCO_GRE    ,
                FAI_IMP_SCO_SIS    ,
                FAI_IMP_UTI_GRE    ,
                FAI_IMP_UTI_SIS    ,
                FAI_NDG_CPG    ,
                FILLER

              from  TE_MCRE0_CR_GE_GB;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_CR_GE_GB  SC
             WHERE SC.ID_SEQ = seq;



              UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;



        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_CR_GE_GB: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_CR_GE_GB: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_CR_GE_GB: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_CR_GE_GB ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_CR_GE_GB');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_CR_GE_GB;

FUNCTION FND_MCRE0_CONVERT_CR_LG_GB(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_CR';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_CR_LG_GB';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_CR_LG_GB_DT
    WHERE ROWNUM = 1;


    insert
     when

            FND_MCRE0_is_numeric(FAO_IMP_ACC_GBA) = 0 or
            FND_MCRE0_is_numeric(FAO_IMP_UTI_GBA) = 0 or
            FND_MCRE0_is_numeric(FAO_IMP_SCO_GBA) = 0 or
            FND_MCRE0_is_numeric(FAO_IMP_GAR_GBA) = 0 or
            FND_MCRE0_is_numeric(FAO_IMP_ACC_SIS) = 0 or
            FND_MCRE0_is_numeric(FAO_IMP_UTI_SIS) = 0 or
            FND_MCRE0_is_numeric(FAO_IMP_SCO_SIS) = 0 or
            FND_MCRE0_is_numeric(FAO_IMP_GAR_SIS) = 0 or
            FND_MCRE0_is_date(FAO_DAT_RIF) = 0


        then
        INTO T_MCRE0_SC_CONVERT_CR_LG_GB
            (   ID_SEQ    ,
                ID_DPER ,
                FAO_NDG_CPG    ,
                FAO_IMP_ACC_GBA    ,
                FAO_IMP_UTI_GBA    ,
                FAO_IMP_SCO_GBA    ,
                FAO_IMP_GAR_GBA    ,
                FAO_IMP_ACC_SIS    ,
                FAO_IMP_UTI_SIS    ,
                FAO_IMP_SCO_SIS    ,
                FAO_IMP_GAR_SIS    ,
                FAO_DAT_RIF    ,
                FILLER

            )
            VALUES (seq,
                    v_period,
                    FAO_NDG_CPG    ,
                    FAO_IMP_ACC_GBA    ,
                    FAO_IMP_UTI_GBA    ,
                    FAO_IMP_SCO_GBA    ,
                    FAO_IMP_GAR_GBA    ,
                    FAO_IMP_ACC_SIS    ,
                    FAO_IMP_UTI_SIS    ,
                    FAO_IMP_SCO_SIS    ,
                    FAO_IMP_GAR_SIS    ,
                    FAO_DAT_RIF    ,
                    FILLER

                            )

           when

            FND_MCRE0_is_numeric(FAO_IMP_ACC_GBA) = 1 and
            FND_MCRE0_is_numeric(FAO_IMP_UTI_GBA) = 1 and
            FND_MCRE0_is_numeric(FAO_IMP_SCO_GBA) = 1 and
            FND_MCRE0_is_numeric(FAO_IMP_GAR_GBA) = 1 and
            FND_MCRE0_is_numeric(FAO_IMP_ACC_SIS) = 1 and
            FND_MCRE0_is_numeric(FAO_IMP_UTI_SIS) = 1 and
            FND_MCRE0_is_numeric(FAO_IMP_SCO_SIS) = 1 and
            FND_MCRE0_is_numeric(FAO_IMP_GAR_SIS) = 1 and
            FND_MCRE0_is_date(FAO_DAT_RIF) = 1

        then
        INTO T_MCRE0_FL_CR_LG_GB

            (   ID_DPER ,
                COD_SNDG_LG    ,
                VAL_ACC_LGGB    ,
                VAL_UTI_LGGB    ,
                VAL_SCO_LGGB    ,
                VAL_GAR_LGGB    ,
                VAL_ACC_SIS_LG    ,
                VAL_UTI_SIS_LG    ,
                VAL_SCO_SIS_LG    ,
                VAL_IMP_GAR_SIS_LG    ,
                DTA_RIFERIMENTO_CR

            )

            values (
                TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                RPAD(FAO_NDG_CPG,16,0)  ,
                to_number(FAO_IMP_ACC_GBA),
                to_number(FAO_IMP_UTI_GBA),
                to_number(FAO_IMP_SCO_GBA),
                to_number(FAO_IMP_GAR_GBA),
                to_number(FAO_IMP_ACC_SIS),
                to_number(FAO_IMP_UTI_SIS),
                to_number(FAO_IMP_SCO_SIS),
                to_number(FAO_IMP_GAR_SIS),
                to_date(FAO_DAT_RIF, 'ddmmyyyy')


                    )



              select
                    FAO_NDG_CPG    ,
                    FAO_IMP_ACC_GBA    ,
                    FAO_IMP_UTI_GBA    ,
                    FAO_IMP_SCO_GBA    ,
                    FAO_IMP_GAR_GBA    ,
                    FAO_IMP_ACC_SIS    ,
                    FAO_IMP_UTI_SIS    ,
                    FAO_IMP_SCO_SIS    ,
                    FAO_IMP_GAR_SIS    ,
                    FAO_DAT_RIF    ,
                    FILLER



              from  TE_MCRE0_CR_LG_GB;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_CR_LG_GB  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;


        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_CR_LG_GB: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_CR_LG_GB: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_CR_LG_GB: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_CR_LG_GB ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_CR_LG_GB');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_CR_LG_GB;

FUNCTION FND_MCRE0_CONVERT_CR_GE_SB(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_CR';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_CR_GE_SB';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_CR_GE_SB_DT
    WHERE ROWNUM = 1;


    insert
     when
         FND_MCRE0_is_date(FAK_DAT_RIF_GRE) = 0 or
         FND_MCRE0_is_numeric(FAK_IMP_ACC_GRE) = 0 or
         FND_MCRE0_is_numeric(FAK_IMP_GAR_GRE) = 0 or
         FND_MCRE0_is_numeric(FAK_IMP_SCO_GRE) = 0 or
         FND_MCRE0_is_numeric(FAK_IMP_UTI_GRE) = 0


        then
        INTO T_MCRE0_SC_CONVERT_CR_GE_SB
            (   ID_SEQ    ,
                ID_DPER ,
                FAK_ABI_ELA    ,
                FAK_DAT_RIF_GRE    ,
                FAK_IMP_ACC_GRE    ,
                FAK_IMP_GAR_GRE    ,
                FAK_IMP_SCO_GRE    ,
                FAK_IMP_UTI_GRE    ,
                FAK_NDG_CPG    ,
                FILLER

            )
            VALUES (seq,
                    v_period,
                    FAK_ABI_ELA    ,
                    FAK_DAT_RIF_GRE    ,
                    FAK_IMP_ACC_GRE    ,
                    FAK_IMP_GAR_GRE    ,
                    FAK_IMP_SCO_GRE    ,
                    FAK_IMP_UTI_GRE    ,
                    FAK_NDG_CPG    ,
                    FILLER
                            )

           when
             FND_MCRE0_is_date(    FAK_DAT_RIF_GRE    ) = 1 and
             FND_MCRE0_is_numeric(FAK_IMP_ACC_GRE) = 1 and
             FND_MCRE0_is_numeric(FAK_IMP_GAR_GRE) = 1 and
             FND_MCRE0_is_numeric(FAK_IMP_SCO_GRE) = 1 and
             FND_MCRE0_is_numeric(FAK_IMP_UTI_GRE) = 1

        then
        INTO T_MCRE0_FL_CR_GE_SB

            (   ID_DPER ,
                COD_ABI_CARTOLARIZZATO    ,
                DTA_CR_GESB    ,
                VAL_ACC_CR_GESB    ,
                VAL_GAR_CR_GESB    ,
                VAL_SCO_CR_GESB    ,
                VAL_UTI_CR_GESB    ,
                COD_SNDG_GE
            )

            values (
                TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                LPAD(FAK_ABI_ELA,5,0) ,
                to_date(FAK_DAT_RIF_GRE, 'ddmmyyyy'),
                to_number(FAK_IMP_ACC_GRE),
                to_number(FAK_IMP_GAR_GRE),
                to_number(FAK_IMP_SCO_GRE),
                to_number(FAK_IMP_UTI_GRE),
                RPAD(FAK_NDG_CPG,16,0)
                )



              select
                FAK_ABI_ELA    ,
                FAK_DAT_RIF_GRE    ,
                FAK_IMP_ACC_GRE    ,
                FAK_IMP_GAR_GRE    ,
                FAK_IMP_SCO_GRE    ,
                FAK_IMP_UTI_GRE    ,
                FAK_NDG_CPG    ,
                FILLER



              from  TE_MCRE0_CR_GE_SB;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_CR_GE_SB  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;


        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_CR_GE_SB: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_CR_GE_SB: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_CR_GE_SB: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_CR_GE_SB ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_CR_GE_SB');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_CR_GE_SB;

    FUNCTION FND_MCRE0_CONVERT_CR_SC_SB(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_CR';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_CR_SC_SB';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_CR_SC_SB_DT
    WHERE ROWNUM = 1;


    insert
     when

                FND_MCRE0_is_date(FAJ_DAT_RIF_CLI) = 0 or
                FND_MCRE0_is_numeric(FAJ_IMP_ACC_CLI) = 0 or
                FND_MCRE0_is_numeric(FAJ_IMP_GAR_CLI) = 0 or
                FND_MCRE0_is_numeric(FAJ_IMP_SCO_CLI) = 0 or
                FND_MCRE0_is_numeric(FAJ_IMP_UTI_CLI) = 0

        then
        INTO T_MCRE0_SC_CONVERT_CR_SC_SB
            (   ID_SEQ    ,
                ID_DPER ,
                FAJ_ABI_ELA    ,
                FAJ_DAT_RIF_CLI    ,
                FAJ_IMP_ACC_CLI    ,
                FAJ_IMP_GAR_CLI    ,
                FAJ_IMP_SCO_CLI    ,
                FAJ_IMP_UTI_CLI    ,
                FAJ_NDG_SET    ,
                FILLER


            )
            VALUES (seq,
                    v_period,
                    FAJ_ABI_ELA    ,
                    FAJ_DAT_RIF_CLI    ,
                    FAJ_IMP_ACC_CLI    ,
                    FAJ_IMP_GAR_CLI    ,
                    FAJ_IMP_SCO_CLI    ,
                    FAJ_IMP_UTI_CLI    ,
                    FAJ_NDG_SET    ,
                    FILLER
                            )

           when
                FND_MCRE0_is_date(FAJ_DAT_RIF_CLI) = 1 and
                FND_MCRE0_is_numeric(FAJ_IMP_ACC_CLI) = 1 and
                FND_MCRE0_is_numeric(FAJ_IMP_GAR_CLI) = 1 and
                FND_MCRE0_is_numeric(FAJ_IMP_SCO_CLI) = 1 and
                FND_MCRE0_is_numeric(FAJ_IMP_UTI_CLI) = 1


        then
        INTO T_MCRE0_FL_CR_SC_SB

            (   ID_DPER ,
                COD_ABI_CARTOLARIZZATO    ,
                DTA_CR_SCSB    ,
                VAL_ACC_CR_SCSB    ,
                VAL_GAR_CR_SCSB    ,
                VAL_SCO_CR_SCSB    ,
                VAL_UTI_CR_SCSB    ,
                COD_NDG
            )

            values (
                TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                LPAD(FAJ_ABI_ELA,5,0) ,
                to_date(FAJ_DAT_RIF_CLI, 'ddmmyyyy'),
                to_number(FAJ_IMP_ACC_CLI),
                to_number(FAJ_IMP_GAR_CLI),
                to_number(FAJ_IMP_SCO_CLI),
                to_number(FAJ_IMP_UTI_CLI),
                RPAD(FAJ_NDG_SET,16,0)
                )


              select
                    FAJ_ABI_ELA    ,
                    FAJ_DAT_RIF_CLI    ,
                    FAJ_IMP_ACC_CLI    ,
                    FAJ_IMP_GAR_CLI    ,
                    FAJ_IMP_SCO_CLI    ,
                    FAJ_IMP_UTI_CLI    ,
                    FAJ_NDG_SET    ,
                    FILLER



              from  TE_MCRE0_CR_SC_SB;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_CR_SC_SB  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;


        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_CR_SC_SB: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_CR_SC_SB: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_CR_SC_SB: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_CR_SC_SB ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_CR_SC_SB');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_CR_SC_SB;

FUNCTION FND_MCRE0_CONVERT_PCR_LEGAME(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_PCR_LEGAME';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_PCR_LEGAME';

    SELECT
        TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_PCR_LEGAME_DT
    WHERE ROWNUM = 1;




    insert
     when
            FND_MCRE0_is_numeric(FAN_NDG_GRP_LTO) = 0 or
            FND_MCRE0_is_numeric(FAN_IMP_UTI_LEG) = 0 or
            FND_MCRE0_is_numeric(FAN_IMP_ACC_LEG) = 0 or
            FND_MCRE0_is_numeric(FAN_NDG_GRP_LTE) = 0 or
            FND_MCRE0_is_date(FAN_DAT_RIF) = 0 or
            FND_MCRE0_is_numeric(FAN_IMP_GAR_LEG) = 0 or
            FND_MCRE0_is_date(FAN_DAT_SCA_LDC) = 0

        then
        INTO T_MCRE0_SC_CONVERT_PCR_LEGAME
            (   ID_SEQ    ,
                ID_DPER    ,
                FAN_NDG_GRP_LTO    ,
                FAN_COD_FTE    ,
                FAN_IMP_UTI_LEG    ,
                FAN_IMP_ACC_LEG    ,
                FAN_NDG_GRP_LTE    ,
                FAN_COD_LEG    ,
                FAN_DAT_RIF    ,
                FAN_COD_NAT    ,
                FAN_IMP_GAR_LEG    ,
                FAN_DAT_SCA_LDC    ,
                FILLER

            )
            VALUES (  seq,
                    v_period,
                    FAN_NDG_GRP_LTO    ,
                    FAN_COD_FTE    ,
                    FAN_IMP_UTI_LEG    ,
                    FAN_IMP_ACC_LEG    ,
                    FAN_NDG_GRP_LTE    ,
                    FAN_COD_LEG    ,
                    FAN_DAT_RIF    ,
                    FAN_COD_NAT    ,
                    FAN_IMP_GAR_LEG    ,
                    FAN_DAT_SCA_LDC    ,
                    FILLER

                    )

           when

            FND_MCRE0_is_numeric(    FAN_NDG_GRP_LTO    ) = 1 and
            FND_MCRE0_is_numeric(    FAN_IMP_UTI_LEG    ) = 1 and
            FND_MCRE0_is_numeric(    FAN_IMP_ACC_LEG    ) = 1 and
            FND_MCRE0_is_numeric(    FAN_NDG_GRP_LTE    ) = 1 and
            FND_MCRE0_is_date(    FAN_DAT_RIF    ) = 1 and
            FND_MCRE0_is_numeric(    FAN_IMP_GAR_LEG    ) = 1 and
            FND_MCRE0_is_date(    FAN_DAT_SCA_LDC    ) = 1


        then
        INTO T_MCRE0_FL_PCR_LEGAME

            (   ID_DPER    ,
                COD_SNDG    ,
                COD_FORMA_TECNICA    ,
                VAL_UTI_LEG    ,
                VAL_ACC_LEG    ,
                COD_SNDG_LEGANTE    ,
                COD_LEGAME    ,
                DTA_RIFERIMENTO    ,
                COD_NATURA    ,
                VAL_IMP_GAR_LEG    ,
                DTA_SCADENZA_LDC
            )

            values (
              TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                RPAD(FAN_NDG_GRP_LTO, 16, 0),
                trim(FAN_COD_FTE),
                to_number(FAN_IMP_UTI_LEG),
                to_number(FAN_IMP_ACC_LEG),
                RPAD(FAN_NDG_GRP_LTE, 16, 0),
                trim(FAN_COD_LEG),
                to_date(FAN_DAT_RIF, 'DDMMYYYY'),
                trim(FAN_COD_NAT),
                to_number(FAN_IMP_GAR_LEG),
                to_date(FAN_DAT_SCA_LDC, 'DDMMYYYY')
              )



              select
                    FAN_NDG_GRP_LTO    ,
                    FAN_COD_FTE    ,
                    FAN_IMP_UTI_LEG    ,
                    FAN_IMP_ACC_LEG    ,
                    FAN_NDG_GRP_LTE    ,
                    FAN_COD_LEG    ,
                    FAN_DAT_RIF    ,
                    FAN_COD_NAT    ,
                    FAN_IMP_GAR_LEG    ,
                    FAN_DAT_SCA_LDC    ,
                    FILLER


              from  TE_MCRE0_PCR_LEGAME;
              commit;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_PCR_LEGAME  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              commit;




        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_PCR_LEGAME: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_PCR_LEGAME: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_PCR_LEGAME: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_PCR_LEGAME ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_PCR_LEGAME');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_PCR_LEGAME;


FUNCTION FND_MCRE0_CONVERT_IRIS(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_IRIS';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_IRIS';

    SELECT
        TO_DATE(TRIM(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_IRIS_DT
    WHERE ROWNUM = 1;




    INSERT
     WHEN
            FND_MCRE0_is_numeric(FAD_NDG_GRP) = 0 OR
            FND_MCRE0_is_date('01'||FAD_DAT_RIF) = 0 OR
            FND_MCRE0_is_numeric(FAD_IRS_GRP_ECO) = 0 OR
            FND_MCRE0_is_numeric(FAD_IRS_CLI_GRP) = 0 OR
            FND_MCRE0_is_numeric(FAD_LGD) = 0 OR
            FND_MCRE0_is_date(FAD_DAT_RIF_LGD) = 0 OR
            FND_MCRE0_is_numeric(FAD_EAD) = 0 OR
            FND_MCRE0_is_date(FAD_DAT_RIF_EAD) = 0 OR
            FND_MCRE0_is_numeric(FAD_PA) = 0 OR
            FND_MCRE0_is_date(FAD_DAT_RIF_PA) = 0 OR
            FND_MCRE0_is_numeric(FAD_PDM) = 0 OR
            FND_MCRE0_is_date(FAD_DAT_RIF_PDM) = 0 OR
            FND_MCRE0_is_numeric(FAD_IND_UTL_INT ) = 0 OR
            FND_MCRE0_is_numeric(FAD_IND_UTL_EST) = 0 OR
            FND_MCRE0_is_numeric(FAD_IND_UTL_CPL) = 0 OR
            FND_MCRE0_is_numeric(FAD_IND_RAT) = 0 OR
            FND_MCRE0_is_numeric(FAD_IND_RTZ) = 0 OR
            FND_MCRE0_is_numeric(FAD_IND_IDB) = 0 OR
            FND_MCRE0_is_numeric(FAD_IND_INS_POR) = 0 OR
            FND_MCRE0_is_numeric(FAD_FLG_FAT)=0
        THEN
        INTO T_MCRE0_SC_CONVERT_IRIS
            (
                ID_SEQ    ,
                ID_DPER    ,
                FAD_NDG_GRP    ,
                FAD_DAT_RIF    ,
                FAD_IRS_GRP_ECO    ,
                FAD_IRS_CLI_GRP    ,
                FAD_LRI_GRP_ECO    ,
                FAD_LRI_CLI    ,
                FAD_LGD    ,
                FAD_DAT_RIF_LGD    ,
                FAD_EAD    ,
                FAD_DAT_RIF_EAD    ,
                FAD_PA    ,
                FAD_DAT_RIF_PA    ,
                FAD_PDM    ,
                FAD_DAT_RIF_PDM    ,
                FAD_RAT_MON    ,
                FAD_FLG_FAT,
                --3.0
                FAD_IRS_GRP_ECO_SGN, FAD_IRS_CLI_GRP_SGN, FAD_IND_UTL_INT_SGN, FAD_IND_UTL_INT,
                FAD_IND_UTL_EST_SGN, FAD_IND_UTL_EST, FAD_IND_UTL_CPL_SGN, FAD_IND_UTL_CPL,
                FAD_IND_RAT_SGN, FAD_IND_RAT, FAD_IND_RTZ_SGN, FAD_IND_RTZ, FAD_IND_IDB_SGN,
                FAD_IND_IDB, FAD_IND_INS_POR_SGN, FAD_IND_INS_POR
                --
            )
            VALUES (  seq,
                    v_period,
                    FAD_NDG_GRP    ,
                    FAD_DAT_RIF    ,
                    FAD_IRS_GRP_ECO    ,
                    FAD_IRS_CLI_GRP    ,
                    FAD_LRI_GRP_ECO    ,
                    FAD_LRI_CLI    ,
                    FAD_LGD    ,
                    FAD_DAT_RIF_LGD    ,
                    FAD_EAD    ,
                    FAD_DAT_RIF_EAD    ,
                    FAD_PA    ,
                    FAD_DAT_RIF_PA    ,
                    FAD_PDM    ,
                    FAD_DAT_RIF_PDM    ,
                    FAD_RAT_MON    ,
                    FAD_FLG_FAT,
                --3.0
                FAD_IRS_GRP_ECO_SGN, FAD_IRS_CLI_GRP_SGN, FAD_IND_UTL_INT_SGN, FAD_IND_UTL_INT,
                FAD_IND_UTL_EST_SGN, FAD_IND_UTL_EST, FAD_IND_UTL_CPL_SGN, FAD_IND_UTL_CPL,
                FAD_IND_RAT_SGN, FAD_IND_RAT, FAD_IND_RTZ_SGN, FAD_IND_RTZ, FAD_IND_IDB_SGN,
                FAD_IND_IDB, FAD_IND_INS_POR_SGN, FAD_IND_INS_POR
                --
                    )
           WHEN
                FND_MCRE0_is_numeric(FAD_NDG_GRP) = 1 AND
                FND_MCRE0_is_date('01'||FAD_DAT_RIF) = 1 AND
                FND_MCRE0_is_numeric(FAD_IRS_GRP_ECO) = 1 AND
                FND_MCRE0_is_numeric(FAD_IRS_CLI_GRP) = 1 AND
                FND_MCRE0_is_numeric(FAD_LGD) = 1 AND
                FND_MCRE0_is_date(FAD_DAT_RIF_LGD) = 1 AND
                FND_MCRE0_is_numeric(FAD_EAD) = 1 AND
                FND_MCRE0_is_date(FAD_DAT_RIF_EAD) = 1 AND
                FND_MCRE0_is_numeric(FAD_PA) = 1 AND
                FND_MCRE0_is_date(FAD_DAT_RIF_PA) = 1 AND
                FND_MCRE0_is_numeric(FAD_PDM) = 1 AND
                FND_MCRE0_is_date(FAD_DAT_RIF_PDM) = 1 AND
                --3.0
                FND_MCRE0_is_numeric(FAD_IND_UTL_INT ) = 1 AND
                FND_MCRE0_is_numeric(FAD_IND_UTL_EST) = 1 AND
                FND_MCRE0_is_numeric(FAD_IND_UTL_CPL) = 1 AND
                FND_MCRE0_is_numeric(FAD_IND_RAT) = 1 AND
                FND_MCRE0_is_numeric(FAD_IND_RTZ) = 1 AND
                FND_MCRE0_is_numeric(FAD_IND_IDB) = 1 AND
                FND_MCRE0_is_numeric(FAD_IND_INS_POR) = 1  AND
                FND_MCRE0_is_numeric(FAD_FLG_FAT)=1
        THEN
        INTO T_MCRE0_FL_IRIS
            (   ID_DPER    ,
                COD_SNDG    ,
                DTA_RIFERIMENTO    ,
                VAL_IRIS_GRE    ,
                VAL_IRIS_CLI    ,
                VAL_LIV_RISCHIO_GRE    ,
                VAL_LIV_RISCHIO_CLI    ,
                VAL_LGD    ,
                DTA_LGD    ,
                VAL_EAD    ,
                DTA_EAD    ,
                VAL_PA    ,
                DTA_PA    ,
                VAL_PD_MONITORAGGIO    ,
                DTA_PD_MONITORAGGIO    ,
                VAL_RATING_MONITORAGGIO,
                --3.0
                VAL_IND_UTL_INTERNO, VAL_IND_UTL_ESTERNO, VAL_IND_UTL_COMPLESSIVO,
                VAL_IND_RATA, VAL_IND_ROTAZIONE, VAL_IND_INDEBITAMENTO, VAL_IND_INSOL_PORTAF,
                --
                FLG_FATAL
            )
            VALUES (
                TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                RPAD(FAD_NDG_GRP,16,0),
                TO_DATE(FAD_DAT_RIF, 'MMYYYY'),
                TO_NUMBER(FAD_IRS_GRP_ECO) * DECODE(FAD_IRS_GRP_ECO_SGN,'-',-1,'+',1,0),
                TO_NUMBER(FAD_IRS_CLI_GRP)* DECODE(FAD_IRS_CLI_GRP_SGN,'-',-1,'+',1,0),
                TRIM(FAD_LRI_GRP_ECO),
                TRIM(FAD_LRI_CLI),
                TO_NUMBER(FAD_LGD),
                TO_DATE(FAD_DAT_RIF_LGD, 'DDMMYYYY'),
                TO_NUMBER(FAD_EAD),
                TO_DATE(FAD_DAT_RIF_EAD, 'DDMMYYYY'),
                TO_NUMBER(FAD_PA),
                TO_DATE(FAD_DAT_RIF_PA, 'DDMMYYYY'),
                TO_NUMBER(FAD_PDM),
                TO_DATE(FAD_DAT_RIF_PDM, 'DDMMYYYY'),
                TRIM(FAD_RAT_MON),
                --3.0
                TO_NUMBER(FAD_IND_UTL_INT) * DECODE(FAD_IND_UTL_INT_SGN,'-',-1,'+',1,0),
                TO_NUMBER(FAD_IND_UTL_EST) * DECODE(FAD_IND_UTL_EST_SGN,'-',-1,'+',1,0),
                TO_NUMBER(FAD_IND_UTL_CPL) * DECODE(FAD_IND_UTL_CPL_SGN,'-',-1,'+',1,0),
                TO_NUMBER(FAD_IND_RAT) * DECODE(FAD_IND_RAT_SGN,'-',-1,'+',1,0),
                TO_NUMBER(FAD_IND_RTZ) * DECODE(FAD_IND_RTZ_SGN,'-',-1,'+',1,0),
                TO_NUMBER(FAD_IND_IDB) * DECODE(FAD_IND_IDB_SGN,'-',-1,'+',1,0),
                TO_NUMBER(FAD_IND_INS_POR) * DECODE(FAD_IND_INS_POR_SGN,'-',-1,'+',1,0),
                --
                TO_NUMBER(FAD_FLG_FAT)
              )
              SELECT
                    FAD_NDG_GRP    ,
                    FAD_DAT_RIF    ,
                    FAD_IRS_GRP_ECO    ,
                    FAD_IRS_CLI_GRP    ,
                    FAD_LRI_GRP_ECO    ,
                    FAD_LRI_CLI    ,
                    FAD_LGD    ,
                    FAD_DAT_RIF_LGD    ,
                    FAD_EAD    ,
                    FAD_DAT_RIF_EAD    ,
                    FAD_PA    ,
                    FAD_DAT_RIF_PA    ,
                    FAD_PDM    ,
                    FAD_DAT_RIF_PDM    ,
                    FAD_RAT_MON    ,
                    FAD_FLG_FAT,
                    -- 3.0
                    FAD_IRS_GRP_ECO_SGN,
                    FAD_IRS_CLI_GRP_SGN,
                    FAD_IND_UTL_INT_SGN,FAD_IND_UTL_INT,
                    FAD_IND_UTL_EST_SGN,FAD_IND_UTL_EST,
                    FAD_IND_UTL_CPL_SGN,FAD_IND_UTL_CPL,
                    FAD_IND_RAT_SGN,FAD_IND_RAT,
                    FAD_IND_RTZ_SGN,FAD_IND_RTZ,
                    FAD_IND_IDB_SGN,FAD_IND_IDB,
                    FAD_IND_INS_POR_SGN,FAD_IND_INS_POR
                    --
              FROM  TE_MCRE0_IRIS;
              COMMIT;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_IRIS  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              COMMIT;




        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_IRIS: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_IRIS: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_IRIS: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_IRIS ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_IRIS');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_IRIS;

FUNCTION FND_MCRE0_CONVERT_PEF(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_PEF';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_PEF';

    SELECT
        TO_DATE(TRIM(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_PEF_DT
    WHERE ROWNUM = 1;




    INSERT
     WHEN

            FND_MCRE0_is_date(FAC_DAT_ULT_REV)=0
            OR FND_MCRE0_is_date(FAC_DAT_SCA_FID)=0
            OR FND_MCRE0_is_date(FAC_DAT_ULT_DEL)=0
            OR FND_MCRE0_is_date(FAC_DAT_ULT_SCA)=0
            OR FND_MCRE0_is_date(FAC_DAT_CMP_PEF)=0
            or FND_MCRE0_is_date(DTA_SCA_REV_PEF)=0



        THEN
        INTO T_MCRE0_SC_CONVERT_PEF
            (
                ID_SEQ,
                ID_DPER,
                FAC_ABI_IST,
                FAC_NDG_SET,
                FAC_COD_PEF,
                FAC_FSE_PEF,
                FAC_DAT_ULT_REV,
                FAC_DAT_SCA_FID,
                FAC_DAT_ULT_DEL,
                FAC_FLG_FID_SCA,
                FAC_DAT_ULT_SCA,
                FAC_COD_ULT_ODE,
                FAC_CTS_ULT_ODE,
                FAC_COD_STR_CRZ,
                FAC_COD_ODE,
                FAC_DAT_CMP_PEF,
                DTA_SCA_REV_PEF,
                FILLER


            )
            VALUES (  seq,
                    v_period,
                    FAC_ABI_IST,
                    FAC_NDG_SET,
                    FAC_COD_PEF,
                    FAC_FSE_PEF,
                    FAC_DAT_ULT_REV,
                    FAC_DAT_SCA_FID,
                    FAC_DAT_ULT_DEL,
                    FAC_FLG_FID_SCA,
                    FAC_DAT_ULT_SCA,
                    FAC_COD_ULT_ODE,
                    FAC_CTS_ULT_ODE,
                    FAC_COD_STR_CRZ,
                    FAC_COD_ODE,
                    FAC_DAT_CMP_PEF,
                    DTA_SCA_REV_PEF,
                    FILLER
                                        )

           WHEN

                FND_MCRE0_is_date(FAC_DAT_ULT_REV)=1
                AND FND_MCRE0_is_date(FAC_DAT_SCA_FID)=1
                AND FND_MCRE0_is_date(FAC_DAT_ULT_DEL)=1
                AND FND_MCRE0_is_date(FAC_DAT_ULT_SCA)=1
                AND FND_MCRE0_is_date(FAC_DAT_CMP_PEF)=1
                AND FND_MCRE0_is_date(DTA_SCA_REV_PEF)=1

        THEN
        INTO T_MCRE0_FL_PEF

            (   ID_DPER    ,
                COD_ABI_ISTITUTO    ,
                COD_NDG    ,
                COD_PEF    ,
                COD_FASE_PEF    ,
                DTA_ULTIMA_REVISIONE    ,
                DTA_SCADENZA_FIDO    ,
                DTA_ULTIMA_DELIBERA    ,
                FLG_FIDI_SCADUTI    ,
                DAT_ULTIMO_SCADUTO    ,
                COD_ULTIMO_ODE    ,
                COD_CTS_ULTIMO_ODE    ,
                COD_STRATEGIA_CRZ    ,
                COD_ODE    ,
                DTA_COMPLETAMENTO_PEF,
                DTA_SCA_REV_PEF

                )

            VALUES (
                TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                LPAD(FAC_ABI_IST,5,0),
                RPAD(FAC_NDG_SET,16,0),
                TRIM(FAC_COD_PEF),
                TRIM(FAC_FSE_PEF),
                TO_DATE(FAC_DAT_ULT_REV, 'DDMMYYYY'),
                TO_DATE(FAC_DAT_SCA_FID, 'DDMMYYYY'),
                TO_DATE(FAC_DAT_ULT_DEL, 'DDMMYYYY'),
                TRIM(FAC_FLG_FID_SCA),
                TO_DATE(FAC_DAT_ULT_SCA, 'DDMMYYYY'),
                TRIM(FAC_COD_ULT_ODE),
                TRIM(FAC_CTS_ULT_ODE),
                TRIM(FAC_COD_STR_CRZ),
                TRIM(FAC_COD_ODE),
                TO_DATE(FAC_DAT_CMP_PEF, 'DDMMYYYY'),
                TO_DATE(DTA_SCA_REV_PEF, 'DDMMYYYY')
              )



              SELECT
                    FAC_ABI_IST,
                    FAC_NDG_SET,
                    FAC_COD_PEF,
                    FAC_FSE_PEF,
                    FAC_DAT_ULT_REV,
                    FAC_DAT_SCA_FID,
                    FAC_DAT_ULT_DEL,
                    FAC_FLG_FID_SCA,
                    FAC_DAT_ULT_SCA,
                    FAC_COD_ULT_ODE,
                    FAC_CTS_ULT_ODE,
                    FAC_COD_STR_CRZ,
                    FAC_COD_ODE,
                    FAC_DAT_CMP_PEF,
                    DTA_SCA_REV_PEF,
                    FILLER



              FROM  TE_MCRE0_PEF;
              COMMIT;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_PEF  SC
             WHERE SC.ID_SEQ = seq;

             UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              COMMIT;




        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_PEF: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_PEF: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_PEF: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_PEF ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);


    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_PEF');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_PEF;

     FUNCTION FND_MCRE0_CONVERT_ANADIP(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_ANADIP';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;

        BEGIN

            dbms_output.PUT_LINE('seq passata in parametro '||seq);

            EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_ANADIP';

            SELECT
            --to_date(SUBSTR(PERIODO_RIF, 97, 10), 'YYYY-MM-DD') INTO v_period
            TO_DATE(trim(PERIODO_RIF), 'DDMMYYYY') INTO v_period
            FROM TE_MCRE0_ANADIP_DT
            WHERE ROWNUM = 1;

            insert
                when
                FND_MCRE0_is_date(to_char(to_date(SUBSTR(RECANADIP_DATULTAGGN, 1, 10), 'YYYY-MM-DD'), 'ddmmyyyy'))=0
                then
                into t_mcre0_sc_convert_anadip
                    (
                            ID_SEQ                  ,
                            ID_DPER                 ,
                            RECANADIP_CODABI        ,
                            RECANADIP_CODFIL        ,
                            RECANADIP_DESCFIL       ,
                            RECANADIP_CODFASC       ,
                            RECANADIP_CODFILSUP     ,
                            RECANADIP_IDNTIPFIL     ,
                            RECANADIP_CODDIV        ,
                            RECANADIP_FREEAREA      ,
                            RECANADIP_CODUTRM       ,
                            RECANADIP_DATULTAGGN    ,
                            RECANADIP_LIVELLO
                    )
                    values
                        (
                            seq,
                            v_period,
                            RECANADIP_CODABI        ,
                            RECANADIP_CODFIL        ,
                            RECANADIP_DESCFIL       ,
                            RECANADIP_CODFASC       ,
                            RECANADIP_CODFILSUP     ,
                            RECANADIP_IDNTIPFIL     ,
                            RECANADIP_CODDIV        ,
                            RECANADIP_FREEAREA      ,
                            RECANADIP_CODUTRM       ,
                            RECANADIP_DATULTAGGN    ,
                            RECANADIP_LIVELLO
                        )
                when
                    FND_MCRE0_is_date(to_char(to_date(SUBSTR(RECANADIP_DATULTAGGN, 1, 10), 'YYYY-MM-DD'), 'ddmmyyyy'))=1
                    then
                    into T_MCRE0_FL_ANADIP
                        (
                           ID_DPER
                          ,COD_ABI_ISTITUTO
                          ,COD_STRUTTURA_COMPETENTE
                          ,DESC_STRUTTURA_COMPETENTE
                          ,COD_FASC
                          ,COD_STR_ORG_SUP
                          ,COD_LIVELLO
                          ,COD_DIV
                          ,FREE_AREA
                          ,COD_UTRUM
                          ,DAT_UPD
                          ,LIVELLO
                        )
                    values
                        (
                            TO_NUMBER(TO_CHAR(v_period, 'YYYYMMDD')),
                            LPAD(RECANADIP_CODABI,5,0),
                            LPAD(RECANADIP_CODFIL,5,0),
                            RECANADIP_DESCFIL       ,
                            RECANADIP_CODFASC       ,
                            LPAD(RECANADIP_CODFILSUP,5,0),
                            RECANADIP_IDNTIPFIL     ,
                            RECANADIP_CODDIV        ,
                            RECANADIP_FREEAREA      ,
                            RECANADIP_CODUTRM       ,
                            to_date(SUBSTR(RECANADIP_DATULTAGGN, 1, 10), 'YYYY-MM-DD')    ,
                            RECANADIP_LIVELLO
                        )
                select
                        RECANADIP_CODABI        ,
                        RECANADIP_CODFIL        ,
                        RECANADIP_DESCFIL       ,
                        RECANADIP_CODFASC       ,
                        RECANADIP_CODFILSUP     ,
                        RECANADIP_IDNTIPFIL     ,
                        RECANADIP_CODDIV        ,
                        RECANADIP_FREEAREA      ,
                        RECANADIP_CODUTRM       ,
                        RECANADIP_DATULTAGGN    ,
                        RECANADIP_LIVELLO
                from    TE_MCRE0_ANADIP;
                COMMIT;


            SELECT  COUNT(*) INTO v_count
            FROM    T_MCRE0_SC_CONVERT_ANADIP SC
            WHERE   SC.ID_SEQ = seq;

            UPDATE      T_MCRE0_WRK_ACQUISIZIONE
                SET     SCARTI_CONVERT = v_count
                WHERE   ID_FLUSSO = seq;
            COMMIT;

            IF(v_count > 0) THEN
                DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_ANADIP: DATI NON CONVERTIBILI');
                v_note := 'T_MCRE0_FL_ANADIP: '|| v_count || ' RECORD NON CONVERTIBILI';
                PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);
            ELSE
               v_note := 'T_MCRE0_FL_ANADIP: '|| v_count || ' RECORD NON CONVERTIBILI';
               PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);
            END IF;

            DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_ANADIP ESEGUITA');
            v_count := 0;
            RETURN (v_count=0);

        EXCEPTION
            WHEN OTHERS THEN

             DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_ANADIP');
             ROLLBACK;
             PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));
             RETURN FALSE;

        END FND_MCRE0_CONVERT_ANADIP;


FUNCTION FND_MCRE0_CONVERT_PREGIUDIZIEV(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_PREGIUDIZ';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;

    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_PREGIUDIZIEVOLI';

    SELECT
        TO_DATE(TRIM(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_PREGIUDIZIEVOLI_DT
    WHERE ROWNUM = 1;

        INSERT
           WHEN    fnd_mcre0_is_date (DTA_ELABORAZIONE) = 0
           THEN
          INTO T_MCRE0_SC_CONVERT_PREG
               (ID_SEQ, ID_DPER, COD_SNDG, COD_TIPO_NOTIZIA, DESC_TIPO_NOTIZIA, DTA_ELABORAZIONE
               )
        VALUES (SEQ,TO_NUMBER (TO_CHAR (v_period, 'yyyymmdd')),
                COD_SNDG, COD_TIPO_NOTIZIA, DESC_TIPO_NOTIZIA, DTA_ELABORAZIONE
               )
           WHEN   fnd_mcre0_is_date (DTA_ELABORAZIONE)  = 1

        THEN
          INTO T_MCRE0_FL_PREGIUDIZIEVOLI
               (ID_DPER, COD_SNDG, COD_TIPO_NOTIZIA, DESC_TIPO_NOTIZIA, DTA_ELABORAZIONE
               )
        VALUES (TO_NUMBER (TO_CHAR (v_period, 'yyyymmdd')), COD_SNDG, COD_TIPO_NOTIZIA, DESC_TIPO_NOTIZIA,
                TO_DATE (DTA_ELABORAZIONE, 'ddmmyyyy')
               )
           SELECT COD_SNDG, COD_TIPO_NOTIZIA, DESC_TIPO_NOTIZIA, DTA_ELABORAZIONE
             FROM te_mcre0_PREGIUDIZIEVOLI;

              COMMIT;

             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_PREG SC
             WHERE SC.ID_SEQ = seq;

              UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              COMMIT;

        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_PREGIUDIZIEVOLI: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_PREGIUDIZIEVOLI: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_PREGIUDIZIEVOLI: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_PREGIUDIZIEV ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);

    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_PREGIUDIZIEV');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_PREGIUDIZIEV;

 FUNCTION FND_MCRE0_CONVERT_EMAIL(seq IN NUMBER) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_CONVERT_EMAIL';
        v_count NUMBER;
        v_note VARCHAR2(2000);
        v_period DATE;


    BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_FL_EMAIL';

    SELECT
        TO_DATE(TRIM(PERIODO_RIF), 'DDMMYYYY')
    INTO
        v_period
    FROM
        TE_MCRE0_EMAIL_DT
    WHERE ROWNUM = 1;


        INSERT
           WHEN    fnc_mcrei_is_date (dta_prfsini) = 0
                OR fnd_mcre0_is_date (dta_prfsfin) = 0
                OR fnd_mcre0_is_date (dta_sostini) = 0
                OR fnd_mcre0_is_date (dta_sostfin) = 0
                OR fnd_mcre0_is_date (dta_assini) = 0
                OR fnd_mcre0_is_date (dta_assfin) = 0
                OR fnd_mcre0_is_date (dta_poinass) = 0
                OR fnd_mcre0_is_date (dta_pofiass) = 0
                OR fnd_mcre0_is_date (dta_disini) = 0
                OR fnd_mcre0_is_date (dta_disfin) = 0
                OR fnd_mcre0_is_date (dta_poindis) = 0
                OR fnd_mcre0_is_date (dta_pofidis) = 0
                OR fnc_mcrei_is_date (dta_assunz,'yyyymmdd') = 0
                OR fnd_mcre0_is_date (dta_cessaz) = 0
                OR fnd_mcre0_is_date (dta_grado) = 0
           THEN
          INTO t_mcre0_sc_convert_email
               (id_seq, id_dper, cod_tipo_rec,
                desc_rec, ts_aggiorn, cod_soc_gdr, desc_soc_gdr, cod_tip_dip,
                cod_utenza, cod_matric, val_cognome, val_nome, cod_pos_org,
                desc_pos_org, cod_prf_sic, desc_prf_sic, dta_prfsini, dta_prfsfin,
                cod_matr_ps, cod_tipuops, cod_socpspo, cod_uo_pspo, desc_uo_pspo,
                cod_lopuops, cod_socw2k, cod_uow2k, id_sn_w2k, cod_socpss1,
                cod_uo_pss1, desc_uo_pss1, cod_socpss2, cod_uo_pss2, desc_uo_pss2,
                cod_socpss3, cod_uo_pss3, desc_uo_pss3, cod_socpss4, cod_uo_pss4,
                cod_socpss5, cod_uo_pss5, cod_socpss6, cod_uo_pss6, cod_socpss7,
                cod_uo_pss7, cod_socsost, cod_uo_sost, desc_uo_sost, cod_po_sost,
                cod_ps_sost, desc_ps_sost, dta_sostini, dta_sostfin, cod_socass,
                cod_uo_ass, desc_uo_ass, dta_assini, dta_assfin, cod_po_ass,
                dta_poinass, dta_pofiass, cod_socodis, cod_uo_dis, desc_uo_dis,
                dta_disini, dta_disfin, cod_po_dis, dta_poindis, dta_pofidis,
                cod_tip_pal, cod_socpal, cod_uo_pal, desc_uo_pal, indirizzo, citta,
                cap, provincia, cod_nazione, id_sesso, cod_fiscale, dta_assunz,
                dta_cessaz, cod_grado, dta_grado, cod_ufficio, cod_ruolo,
                val_tel_uff, val_tel_cel, val_fax, an_stanzat, cod_app_gr1,
                cod_app_gr2, cod_app_gr3, cod_app_gr4, cod_dg_old, cod_dg_new,
                val_email, cod_psigap, desc_po_ass, desc_po_dis, fl_respon, flagd,
                cod_inc, cod_uoinc, cod_gruppo, cod_azienda, cod_matr_10, fl_eml_sic
               )
        VALUES (seq,TO_NUMBER (TO_CHAR (v_period, 'yyyymmdd')), cod_tipo_rec,
                desc_rec, ts_aggiorn, cod_soc_gdr, desc_soc_gdr, cod_tip_dip,
                cod_utenza, cod_matric, val_cognome, val_nome, cod_pos_org,
                desc_pos_org, cod_prf_sic, desc_prf_sic, dta_prfsini, dta_prfsfin,
                cod_matr_ps, cod_tipuops, cod_socpspo, cod_uo_pspo, desc_uo_pspo,
                cod_lopuops, cod_socw2k, cod_uow2k, id_sn_w2k, cod_socpss1,
                cod_uo_pss1, desc_uo_pss1, cod_socpss2, cod_uo_pss2, desc_uo_pss2,
                cod_socpss3, cod_uo_pss3, desc_uo_pss3, cod_socpss4, cod_uo_pss4,
                cod_socpss5, cod_uo_pss5, cod_socpss6, cod_uo_pss6, cod_socpss7,
                cod_uo_pss7, cod_socsost, cod_uo_sost, desc_uo_sost, cod_po_sost,
                cod_ps_sost, desc_ps_sost, dta_sostini, dta_sostfin, cod_socass,
                cod_uo_ass, desc_uo_ass, dta_assini, dta_assfin, cod_po_ass,
                dta_poinass, dta_pofiass, cod_socodis, cod_uo_dis, desc_uo_dis,
                dta_disini, dta_disfin, cod_po_dis, dta_poindis, dta_pofidis,
                cod_tip_pal, cod_socpal, cod_uo_pal, desc_uo_pal, indirizzo, citta,
                cap, provincia, cod_nazione, id_sesso, cod_fiscale, dta_assunz,
                dta_cessaz, cod_grado, dta_grado, cod_ufficio, cod_ruolo,
                val_tel_uff, val_tel_cel, val_fax, an_stanzat, cod_app_gr1,
                cod_app_gr2, cod_app_gr3, cod_app_gr4, cod_dg_old, cod_dg_new,
                val_email, cod_psigap, desc_po_ass, desc_po_dis, fl_respon, flagd,
                cod_inc, cod_uoinc, cod_gruppo, cod_azienda, cod_matr_10, fl_eml_sic
               )
           WHEN     fnd_mcre0_is_date (dta_prfsini) = 1
                AND fnd_mcre0_is_date (dta_prfsfin) = 1
                AND fnd_mcre0_is_date (dta_sostini) = 1
                AND fnd_mcre0_is_date (dta_sostfin) = 1
                AND fnd_mcre0_is_date (dta_assini) = 1
                AND fnd_mcre0_is_date (dta_assfin) = 1
                AND fnd_mcre0_is_date (dta_poinass) = 1
                AND fnd_mcre0_is_date (dta_pofiass) = 1
                AND fnd_mcre0_is_date (dta_disini) = 1
                AND fnd_mcre0_is_date (dta_disfin) = 1
                AND fnd_mcre0_is_date (dta_poindis) = 1
                AND fnd_mcre0_is_date (dta_pofidis) = 1
                AND fnc_mcrei_is_date (dta_assunz,'yyyymmdd') = 1
                AND fnd_mcre0_is_date (dta_cessaz) = 1
                AND fnd_mcre0_is_date (dta_grado) = 1
           --FND_MCRE0_IS_NUMERIC
        THEN
          INTO t_mcre0_fl_email
               (id_dper, cod_tipo_rec, desc_rec,
                ts_aggiorn, cod_soc_gdr, desc_soc_gdr, cod_tip_dip,
                cod_matric, val_cognome, val_nome, cod_pos_org, desc_pos_org,
                cod_prf_sic, desc_prf_sic, dta_prfsini,
                dta_prfsfin, cod_matr_ps, cod_tipuops,
                cod_socpspo, cod_uo_pspo, desc_uo_pspo, cod_lopuops, cod_socw2k,
                cod_uow2k, id_sn_w2k, cod_socpss1, cod_uo_pss1, desc_uo_pss1,
                cod_socpss2, cod_uo_pss2, desc_uo_pss2, cod_socpss3, cod_uo_pss3,
                desc_uo_pss3, cod_socpss4, cod_uo_pss4, cod_socpss5, cod_uo_pss5,
                cod_socpss6, cod_uo_pss6, cod_socpss7, cod_uo_pss7, cod_socsost,
                cod_uo_sost, desc_uo_sost, cod_po_sost, cod_ps_sost, desc_ps_sost,
                dta_sostini, dta_sostfin,
                cod_socass, cod_uo_ass, desc_uo_ass,
                dta_assini, dta_assfin,
                cod_po_ass, dta_poinass,
                dta_pofiass, cod_socodis, cod_uo_dis,
                desc_uo_dis, dta_disini,
                dta_disfin, cod_po_dis,
                dta_poindis, dta_pofidis,
                cod_tip_pal, cod_socpal, cod_uo_pal, desc_uo_pal, indirizzo, citta,
                cap, provincia, cod_nazione, id_sesso, cod_fiscale,
                dta_assunz, dta_cessaz,
                cod_grado, dta_grado, cod_ufficio, cod_ruolo,
                val_tel_uff, val_tel_cel, val_fax, an_stanzat, cod_app_gr1,
                cod_app_gr2, cod_app_gr3, cod_app_gr4, cod_dg_old, cod_dg_new,
                val_email, cod_psigap, desc_po_ass, desc_po_dis, fl_respon, flagd,
                cod_inc, cod_uoinc, cod_gruppo, cod_azienda, cod_matr_10, fl_eml_sic
               )
        VALUES (TO_NUMBER (TO_CHAR (v_period, 'yyyymmdd')), cod_tipo_rec, desc_rec,
                ts_aggiorn, cod_soc_gdr, desc_soc_gdr, cod_tip_dip, cod_utenza|| cod_matric,
                val_cognome, val_nome, cod_pos_org, desc_pos_org,
                cod_prf_sic, desc_prf_sic, TO_DATE (dta_prfsini, 'yyyymmdd'),
                TO_DATE (dta_prfsfin, 'yyyymmdd'), cod_matr_ps, cod_tipuops,
                cod_socpspo, cod_uo_pspo, desc_uo_pspo, cod_lopuops, cod_socw2k,
                cod_uow2k, id_sn_w2k, cod_socpss1, cod_uo_pss1, desc_uo_pss1,
                cod_socpss2, cod_uo_pss2, desc_uo_pss2, cod_socpss3, cod_uo_pss3,
                desc_uo_pss3, cod_socpss4, cod_uo_pss4, cod_socpss5, cod_uo_pss5,
                cod_socpss6, cod_uo_pss6, cod_socpss7, cod_uo_pss7, cod_socsost,
                cod_uo_sost, desc_uo_sost, cod_po_sost, cod_ps_sost, desc_ps_sost,
                TO_DATE (dta_sostini, 'yyyymmdd'), TO_DATE (dta_sostfin, 'yyyymmdd'),
                cod_socass, cod_uo_ass, desc_uo_ass,
                TO_DATE (dta_assini, 'yyyymmdd'), TO_DATE (dta_assfin, 'yyyymmdd'),
                cod_po_ass, TO_DATE (dta_poinass, 'yyyymmdd'),
                TO_DATE (dta_pofiass, 'yyyymmdd'), cod_socodis, cod_uo_dis,
                desc_uo_dis, TO_DATE (dta_disini, 'yyyymmdd'),
                TO_DATE (dta_disfin, 'yyyymmdd'), cod_po_dis,
                TO_DATE (dta_poindis, 'yyyymmdd'), TO_DATE (dta_pofidis, 'yyyymmdd'),
                cod_tip_pal, cod_socpal, cod_uo_pal, desc_uo_pal, indirizzo, citta,
                cap, provincia, cod_nazione, id_sesso, cod_fiscale,
                TO_DATE (dta_assunz, 'yyyymmdd'), TO_DATE (dta_cessaz, 'yyyymmdd'),
                cod_grado, TO_DATE (dta_grado, 'yyyymmdd'), cod_ufficio, cod_ruolo,
                val_tel_uff, val_tel_cel, val_fax, an_stanzat, cod_app_gr1,
                cod_app_gr2, cod_app_gr3, cod_app_gr4, cod_dg_old, cod_dg_new,
                val_email, cod_psigap, desc_po_ass, desc_po_dis, fl_respon, flagd,
                cod_inc, cod_uoinc, cod_gruppo, cod_azienda, cod_matr_10, fl_eml_sic
               )
           SELECT cod_tipo_rec, desc_rec, ts_aggiorn, cod_soc_gdr, desc_soc_gdr,
                  cod_tip_dip, cod_utenza, cod_matric, val_cognome, val_nome,
                  cod_pos_org, desc_pos_org, cod_prf_sic, desc_prf_sic, dta_prfsini,
                  dta_prfsfin, cod_matr_ps, cod_tipuops, cod_socpspo, cod_uo_pspo,
                  desc_uo_pspo, cod_lopuops, cod_socw2k, cod_uow2k, id_sn_w2k,
                  cod_socpss1, cod_uo_pss1, desc_uo_pss1, cod_socpss2, cod_uo_pss2,
                  desc_uo_pss2, cod_socpss3, cod_uo_pss3, desc_uo_pss3, cod_socpss4,
                  cod_uo_pss4, cod_socpss5, cod_uo_pss5, cod_socpss6, cod_uo_pss6,
                  cod_socpss7, cod_uo_pss7, cod_socsost, cod_uo_sost, desc_uo_sost,
                  cod_po_sost, cod_ps_sost, desc_ps_sost, dta_sostini, dta_sostfin,
                  cod_socass, cod_uo_ass, desc_uo_ass, dta_assini, dta_assfin,
                  cod_po_ass, dta_poinass, dta_pofiass, cod_socodis, cod_uo_dis,
                  desc_uo_dis, dta_disini, dta_disfin, cod_po_dis, dta_poindis,
                  dta_pofidis, cod_tip_pal, cod_socpal, cod_uo_pal, desc_uo_pal,
                  indirizzo, citta, cap, provincia, cod_nazione, id_sesso,
                  cod_fiscale, dta_assunz, dta_cessaz, cod_grado, dta_grado,
                  cod_ufficio, cod_ruolo, val_tel_uff, val_tel_cel, val_fax,
                  an_stanzat, cod_app_gr1, cod_app_gr2, cod_app_gr3, cod_app_gr4,
                  cod_dg_old, cod_dg_new, val_email, cod_psigap, desc_po_ass,
                  desc_po_dis, fl_respon, flagd, cod_inc, cod_uoinc, cod_gruppo,
                  cod_azienda, cod_matr_10, fl_eml_sic
             FROM te_mcre0_email;


              COMMIT;


             SELECT COUNT(*)
             INTO v_count
             FROM T_MCRE0_SC_CONVERT_EMAIL SC
             WHERE SC.ID_SEQ = seq;

              UPDATE T_MCRE0_WRK_ACQUISIZIONE
              SET SCARTI_CONVERT = v_count
              WHERE ID_FLUSSO = seq;
              COMMIT;



        IF(v_count > 0) THEN

            DBMS_OUTPUT.PUT_LINE('T_MCRE0_FL_EMAIL: DATI NON CONVERTIBILI');

            v_note := 'T_MCRE0_FL_EMAIL: '|| v_count || ' RECORD NON CONVERTIBILI';
            PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

           ELSE

           v_note := 'T_MCRE0_FL_EMAIL: '|| v_count || ' RECORD NON CONVERTIBILI';
           PKG_MCRE0_LOG.SPO_MCRE0_log_esito(seq,c_nome,v_count = 0,v_note);

       END IF;


         DBMS_OUTPUT.PUT_LINE('FND_MCRE0_CONVERT_EMAIL ESEGUITA');

       v_count := 0;


        RETURN (v_count = 0);




    EXCEPTION

        WHEN OTHERS THEN

         DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_CONVERT_EMAIL');

         ROLLBACK;


            PKG_MCRE0_LOG.SPO_MCRE0_LOG_EVENTO(seq,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN FALSE;

    END FND_MCRE0_CONVERT_EMAIL;
END PKG_MCRE0_CONVERSIONE;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CONVERSIONE FOR MCRE_OWN.PKG_MCRE0_CONVERSIONE;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CONVERSIONE FOR MCRE_OWN.PKG_MCRE0_CONVERSIONE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CONVERSIONE TO MCRE_USR;

