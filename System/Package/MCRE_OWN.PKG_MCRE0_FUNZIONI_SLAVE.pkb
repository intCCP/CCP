CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_FUNZIONI_SLAVE AS


     FUNCTION FND_MCRE0_conformita(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_conformita';

        v_result NUMBER := 0;

    BEGIN

        IF(PKG_MCRE0_CONFORMITA.FND_MCRE0_VERIFICA_CONFORMITA(p_rec)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_conformita;


     FUNCTION FND_MCRE0_svecchiamento(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '(SLAVE).FND_MCRE0_svecchiamento';

        v_result NUMBER := 0;

    BEGIN

        IF(PKG_MCRE0_SVECCHIAMENTO.FND_MCRE0_svecchiamento(p_rec)) THEN

            v_result := 1;

        END IF;


        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_svecchiamento;


    FUNCTION FND_MCRE0_conversione_ABI_ELAB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_conversione_ABI_ELAB';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_conversione_ABI_ELAB');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_ABI_ELAB(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_conversione_ABI_ELAB');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_conversione_ABI_ELAB;


        FUNCTION FND_MCRE0_alimenta_ABI_ELAB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_ABI_ELAB';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_ABI_ELAB(p_rec)) THEN

            v_result := 1;

            RETURN v_result;

      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_ABI_ELAB;



    FUNCTION FND_MCRE0_convert_FILE_GUIDA(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_FILE_GUIDA';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_FILE_GUIDA');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_FILE_GUIDA(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_FILE_GUIDA');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_FILE_GUIDA;


        FUNCTION FND_MCRE0_alimenta_FILE_GUIDA(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_FILE_GUIDA';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_FILE_GUIDA(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_FILE_GUIDA;





    FUNCTION FND_MCRE0_convert_GRUPPO_ECO(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_GRUPPO_ECO';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_GRUPPO_ECO');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_GRUPPO_ECO(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_GRUPPO_ECO');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_GRUPPO_ECO;


        FUNCTION FND_MCRE0_alimenta_GRUPPO_ECO(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_GRUPPO_ECO';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_GRUPPO_ECO(p_rec)) THEN


           v_result := 1;

            RETURN v_result;



      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_GRUPPO_ECO;

    FUNCTION FND_MCRE0_convert_LEGAME(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_LEGAME';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_LEGAME');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_LEGAME(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_LEGAME');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_LEGAME;


        FUNCTION FND_MCRE0_alimenta_LEGAME(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_LEGAME';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_LEGAME(p_rec)) THEN

            v_result := 1;

            RETURN v_result;



      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_LEGAME;


    FUNCTION FND_MCRE0_convert_MOPLE(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_MOPLE';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_MOPLE');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_MOPLE(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_MOPLE');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_MOPLE;


        FUNCTION FND_MCRE0_alimenta_MOPLE(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_MOPLE';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_MOPLE(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_MOPLE;


    FUNCTION FND_MCRE0_convert_PCR_SC_SB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_PCR_SC_SB';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_PCR_SC_SB');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_PCR_SC_SB(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_PCR_SC_SB');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_PCR_SC_SB;


        FUNCTION FND_MCRE0_alimenta_PCR_SC_SB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PCR_SC_SB';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_PCR_SC_SB(p_rec)) THEN

            v_result := 1;

            RETURN v_result;



      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_PCR_SC_SB;

 FUNCTION FND_MCRE0_convert_PERCORSI(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_PERCORSI';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_PERCORSI');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_PERCORSI(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_PERCORSI');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_PERCORSI;


        FUNCTION FND_MCRE0_alimenta_PERCORSI(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PERCORSI';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_PERCORSI(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_PERCORSI;





    FUNCTION FND_MCRE0_convert_ANAGR_GRP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_ANAGR_GRP';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_ANAGR_GRP');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_ANAGR_GRP(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_ANAGR_GRP');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_ANAGR_GRP;


        FUNCTION FND_MCRE0_alimenta_ANAGR_GRP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_ANAGR_GRP';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_ANAGR_GRP(p_rec)) THEN

            v_result := 1;

            RETURN v_result;



      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_ANAGR_GRP;



    FUNCTION FND_MCRE0_convert_RATE_ARR(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_RATE_ARR';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_RATE_ARR');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_RATE_ARR(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_RATE_ARR');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_RATE_ARR;


        FUNCTION FND_MCRE0_alimenta_RATE_ARR(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_RATE_ARR';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_RATE_ARR(p_rec)) THEN

            v_result := 1;

            RETURN v_result;



      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_RATE_ARR;


 FUNCTION FND_MCRE0_convert_SAG(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_SAG';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_SAG');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_SAG(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_SAG');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_SAG;


        FUNCTION FND_MCRE0_alimenta_SAG(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_SAG';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_SAG(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_SAG;

FUNCTION FND_MCRE0_convert_SAB_XRA(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_SAB_XRA';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_SAB_XRA');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_SAB_XRA(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_SAB_XRA');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_SAB_XRA;


        FUNCTION FND_MCRE0_alimenta_SAB_XRA(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_SAB_XRA';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_SAB_XRA(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_SAB_XRA;



 FUNCTION FND_MCRE0_convert_ANAGR_GRE(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_ANAGR_GRE';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_ANAGR_GRE');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_ANAGR_GRE(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_ANAGR_GRE');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_ANAGR_GRE;


        FUNCTION FND_MCRE0_alimenta_ANAGR_GRE(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_ANAGR_GRE';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_ANAGR_GRE(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_ANAGR_GRE;

 FUNCTION FND_MCRE0_convert_PCR_GB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_PCR_GB';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_PCR_GB');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_PCR_GB(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_PCR_GB');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_PCR_GB;


        FUNCTION FND_MCRE0_alimenta_PCR_GB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PCR_GB';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_PCR_GB(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_PCR_GB;



    FUNCTION FND_MCRE0_convert_PCR_GE_SB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_PCR_GE_SB';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_PCR_GE_SB');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_PCR_GE_SB(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_PCR_GE_SB');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_PCR_GE_SB;
           FUNCTION FND_MCRE0_alimenta_PCR_GE_SB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PCR_GE_SB';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_PCR_GE_SB(p_rec)) THEN

            v_result := 1;

            RETURN v_result;

      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_PCR_GE_SB;

    FUNCTION FND_MCRE0_convert_RICH_MON(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_RICH_MON';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_RICH_MON');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_RICH_MON(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_RICH_MON');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_RICH_MON;
           FUNCTION FND_MCRE0_alimenta_RICH_MON(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_RICH_MON';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_RICH_MON(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_RICH_MON;

    /*FUNCTION FND_MCRE0_convert_CR(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_CR';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_CR');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_CR(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_CR');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_CR;

           FUNCTION FND_MCRE0_alimenta_CR(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR;

    FUNCTION FND_MCRE0_convert_CR_SNDG(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_CR_SNDG';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_CR_SNDG');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_CR_SNDG(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_CR_SNDG');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_CR_SNDG;

  FUNCTION FND_MCRE0_alimenta_CR_SNDG(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_SNDG';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_SNDG(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_SNDG;

        FUNCTION FND_MCRE0_convert_CR_SNDG_GE(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_CR_SNDG_GE';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_CR_SNDG_GE');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_CR_SNDG_GE(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_CR_SNDG_GE');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_CR_SNDG_GE;

  FUNCTION FND_MCRE0_alimenta_CR_SNDG_GE(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_SNDG_GE';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_SNDG_GE(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_SNDG_GE;

       FUNCTION FND_MCRE0_convert_CR_NDG_SETT(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_CR_NDG_SETT';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_CR_NDG_SETT');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_CR_NDG_SETT(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_CR_NDG_SETT');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_CR_NDG_SETT;

  FUNCTION FND_MCRE0_alimenta_CR_NDG_SETT(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_NDG_SETT';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_NDG_SETT(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_NDG_SETT;

 FUNCTION FND_MCRE0_conv_CR_NDG_SETT_GE(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_CR_NDG_SETT_GE';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_CR_NDG_SETT_GE');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONV_CR_NDG_SETT_GE(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_CR_NDG_SETT_GE');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_conv_CR_NDG_SETT_GE;

  FUNCTION FND_MCRE0_alim_CR_NDG_SETT_GE(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_NDG_SETT_GE';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alim_CR_NDG_SETT_GE(p_rec)) THEN

            v_result := 1;

            RETURN v_result;



      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alim_CR_NDG_SETT_GE;*/



 FUNCTION FND_MCRE0_alimenta_ABI_ELAB_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_ABI_ELAB_AP';

        v_result NUMBER := 0;

    BEGIN


        IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_ABI_ELAB_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alimenta_ABI_ELAB ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_ABI_ELAB_AP;


  FUNCTION FND_MCRE0_alim_FILE_GUIDA_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alim_FILE_GUIDA_AP';

        v_result NUMBER := 0;

   BEGIN

   IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alim_FILE_GUIDA_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_FILE_GUIDA ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

    end if;

      EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alim_FILE_GUIDA_AP;


   FUNCTION FND_MCRE0_alim_GRUPPO_ECO_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alim_GRUPPO_ECO_AP';

        v_result NUMBER := 0;

    BEGIN
        IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alim_GRUPPO_ECO_AP(p_rec)) THEN



           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_GRUPPO_ECO ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

        EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alim_GRUPPO_ECO_AP;

  FUNCTION FND_MCRE0_alimenta_LEGAME_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_LEGAME_AP';

        v_result NUMBER := 0;

        BEGIN
        IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_LEGAME_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_LEGAME ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

     EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_LEGAME_AP;

  FUNCTION FND_MCRE0_alimenta_MOPLE_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_MOPLE_AP';

        v_result NUMBER := 0;

  BEGIN


  IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_storicizza_MOPLE(p_rec)) THEN

    IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_MOPLE_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_MOPLE ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

       end if;


  ELSE

        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,'FND_MCRE0_alimenta_MOPLE_AP','ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

  END IF;


    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_MOPLE_AP;

 FUNCTION FND_MCRE0_alim_PCR_SC_SB_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alim_PCR_SC_SB_AP';

        v_result NUMBER := 0;

        BEGIN

     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alim_PCR_SC_SB_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_PCR_SC_SB ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

      end if;

        EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alim_PCR_SC_SB_AP;

 FUNCTION FND_MCRE0_alimenta_PERCORSI_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PERCORSI_AP';

        v_result NUMBER := 0;

 BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_PERCORSI_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_PERCORSI ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

        EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_PERCORSI_AP;

 FUNCTION FND_MCRE0_alim_ANAGR_GRP_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alim_ANAGR_GRP_AP';

        v_result NUMBER := 0;

 BEGIN

        IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alim_ANAGR_GRP_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_ANAGR_GRP ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

         end if;

     EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alim_ANAGR_GRP_AP;

  FUNCTION FND_MCRE0_alimenta_RATE_ARR_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_RATE_ARR_AP';

        v_result NUMBER := 0;


  BEGIN
     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_RATE_ARR_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_RATE_ARR ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

     end if;
       EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_RATE_ARR_AP;

 FUNCTION FND_MCRE0_alimenta_SAG_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_SAG_AP';

        v_result NUMBER := 0;

 BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_SAG_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_SAG ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

          EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_SAG_AP;

 FUNCTION FND_MCRE0_alimenta_SAB_XRA_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_SAB_XRA_AP';

        v_result NUMBER := 0;

 BEGIN
        IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_SAB_XRA_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_SAB_XRA ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

     EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_SAB_XRA_AP;

  FUNCTION FND_MCRE0_alim_ANAGR_GRE_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alim_ANAGR_GRE_AP';

        v_result NUMBER := 0;

   BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alim_ANAGR_GRE_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_ANAGR_GRE ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

      end if;

      EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alim_ANAGR_GRE_AP;

 FUNCTION FND_MCRE0_alimenta_PCR_GB_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PCR_GB_AP';

        v_result NUMBER := 0;

   BEGIN
        IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_PCR_GB_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_PCR_GB ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

           EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_PCR_GB_AP;

 FUNCTION FND_MCRE0_alim_PCR_GE_SB_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alim_PCR_GE_SB_AP';

        v_result NUMBER := 0;

 BEGIN

        IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alim_PCR_GE_SB_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_PCR_GE_SB ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

      end if;

    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alim_PCR_GE_SB_AP;

 FUNCTION FND_MCRE0_alim_RICH_MON_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alim_RICH_MON_AP';

        v_result NUMBER := 0;

 BEGIN

        IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alim_RICH_MON_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_RICH_MON ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

       end if;

      EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alim_RICH_MON_AP;

 /*FUNCTION FND_MCRE0_alimenta_CR_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_AP';

        v_result NUMBER := 0;

 BEGIN

       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_CR ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

      end if;

     EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_AP;

 FUNCTION FND_MCRE0_alimenta_CR_SNDG_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_SNDG_AP';

        v_result NUMBER := 0;

 BEGIN
      IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_SNDG_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_CR_SNDG ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

     end if;

     EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_SNDG_AP;

 FUNCTION FND_MCRE0_alim_CR_SNDG_GE_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alim_CR_SNDG_GE_AP';

        v_result NUMBER := 0;

 BEGIN
     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alim_CR_SNDG_GE_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_CR_SNDG_GE ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

      end if;

          EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alim_CR_SNDG_GE_AP;


 FUNCTION FND_MCRE0_alim_CR_NDG_SETT_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alim_CR_NDG_SETT_AP';

        v_result NUMBER := 0;

 BEGIN
        IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alim_CR_NDG_SETT_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_CR_NDG_SETT ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

       end if;


     EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alim_CR_NDG_SETT_AP;


 FUNCTION FND_MCRE0_alim_CR_NdgSetGe_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alim_CR_NdgSetGe_AP';

        v_result NUMBER := 0;

 BEGIN
      IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alim_CR_NdgSetGe_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_CR_NDG_SETT_GE ESEGUITA_AP - INIZIALIZZO v_result := 1');

         v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

       end if;

     EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alim_CR_NdgSetGe_AP;      */


 FUNCTION FND_MCRE0_convert_IRIS(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_conversione_IRIS';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_conversione_IRIS');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_convert_IRIS(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_IRIS');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_IRIS;



 FUNCTION FND_MCRE0_convert_PCR_LEGAME(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_PCR_LEGAME';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_PCR_LEGAME');

        IF(PKG_MCRE0_conversione.FND_MCRE0_convert_PCR_LEGAME(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_PCR_LEGAME');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_PCR_LEGAME;


 FUNCTION FND_MCRE0_convert_PEF(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_conversione_PEF';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_conversione_PEF');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_convert_PEF(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_PEF');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_PEF;

        FUNCTION FND_MCRE0_alimenta_PCR_LEGAME(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PCR_LEGAME';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_PCR_LEGAME(p_rec)) THEN

            v_result := 1;

            RETURN v_result;



      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_PCR_LEGAME;

        FUNCTION FND_MCRE0_alimenta_IRIS(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_IRIS';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_IRIS(p_rec)) THEN

            v_result := 1;

            RETURN v_result;



      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_IRIS;

 FUNCTION FND_MCRE0_alimenta_IRIS_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_IRIS_AP';

        v_result NUMBER := 0;

 BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_IRIS_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_IRIS ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

          EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_IRIS_AP;
--3.0
 FUNCTION FND_MCRE0_alimenta_IRIS_ap_st(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_IRIS_ap_st';

        v_result NUMBER := 0;

 BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_IRIS_ap_st(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_IRIS ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

          EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_IRIS_ap_st;
 FUNCTION FND_MCRE0_alim_PCR_LEGAME_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PCR_LEGAME_AP';

        v_result NUMBER := 0;

 BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alim_PCR_LEGAME_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_PCR_LEGAME ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

          EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alim_PCR_LEGAME_AP;

    FUNCTION FND_MCRE0_alimenta_PEF(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PEF';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_PEF(p_rec)) THEN

            v_result := 1;

            RETURN v_result;



      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_PEF;

    FUNCTION FND_MCRE0_alimenta_PEF_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PEF_AP';

        v_result NUMBER := 0;

 BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_PEF_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_PEF ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

          EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_PEF_AP;


------------------FUNZIONI CHE CHIAMANO IL PKG_MCRE0_ANALYZE_IR_NEW------------
-----------------------PER IL RICALCOLO DELLE STATISTICHE ------------------

   FUNCTION FND_MCRE0_analyze_table_APP (p_rec IN f_slave_par_type)
   RETURN NUMBER IS

          c_nome CONSTANT VARCHAR2(100) := c_package || 'FND_MCRE0_analyze_table_APP';
          v_result NUMBER := 0;
          pschema  T_MCRE0_WRK_STATISTICHE.table_owner%TYPE DEFAULT USER;
          ptable T_MCRE0_WRK_STATISTICHE.table_name%TYPE;


    BEGIN

    SELECT TABLE_OWNER, TABLE_NAME
    INTO pschema , ptable
    FROM T_MCRE0_WRK_STATISTICHE
    WHERE TABLE_TYPE = 'APP'
    AND COD_FILE IN (SELECT COD_FILE FROM T_MCRE0_WRK_ACQUISIZIONE WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO);


        IF(PKG_MCRE0_ANALYZE.FND_MCRE0_ANALYZE_TABLE_APP (PSCHEMA, PTABLE)) THEN

            v_result := 1;

        END IF;

        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO, c_nome,'OK', PTABLE || ' analizzata');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_analyze_table_APP;

     FUNCTION FND_MCRE0_analyze_table_FL (p_rec IN f_slave_par_type)
     RETURN NUMBER  IS

        c_nome CONSTANT VARCHAR2(100) := c_package || 'FND_MCRE0_analyze_table_FL';
        v_return BOOLEAN := FALSE;
        v_result NUMBER := 0;
          pschema T_MCRE0_WRK_STATISTICHE.table_owner%TYPE DEFAULT USER;
          ptable  T_MCRE0_WRK_STATISTICHE.table_name%TYPE;

    BEGIN

    SELECT TABLE_OWNER, TABLE_NAME
    INTO pschema , ptable
    FROM T_MCRE0_WRK_STATISTICHE
    WHERE TABLE_TYPE = 'FL'
    AND COD_FILE IN (SELECT COD_FILE FROM T_MCRE0_WRK_ACQUISIZIONE WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO);


        IF( PKG_MCRE0_ANALYZE.FND_MCRE0_ANALYZE_TABLE_FL ( PSCHEMA, PTABLE)) THEN

            v_result := 1;

        END IF;

        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO, c_nome,'OK', PTABLE || ' analizzata');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_analyze_table_FL;

   FUNCTION FND_MCRE0_analyze_table_ST (p_rec IN f_slave_par_type)
    RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || 'FND_MCRE0_analyze_table_ST';
        v_return BOOLEAN := FALSE;
        v_result NUMBER := 0;
        pschema T_MCRE0_WRK_STATISTICHE.table_owner%TYPE DEFAULT USER;
        ptable  T_MCRE0_WRK_STATISTICHE.table_name%TYPE;
        ppartition  VARCHAR2(20);


    BEGIN

    SELECT TABLE_OWNER, TABLE_NAME, PART_NAME
    INTO pschema , ptable, ppartition
    FROM T_MCRE0_WRK_STATISTICHE
    WHERE TABLE_TYPE = 'ST'
    AND COD_FILE IN (SELECT COD_FILE FROM T_MCRE0_WRK_ACQUISIZIONE WHERE ID_FLUSSO = p_rec.SEQ_FLUSSO);


        IF( PKG_MCRE0_ANALYZE.FND_MCRE0_ANALYZE_TABLE_ST ( PSCHEMA, PTABLE, ppartition)) THEN

            v_result := 1;

        END IF;

        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO, c_nome,'OK', PTABLE || ' analizzata');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_analyze_table_ST;


 FUNCTION FND_MCRE0_convert_CR_SC_SB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_CR_SC_SB';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_CR_SC_SB');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_CR_SC_SB(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_CR_SC_SB');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_CR_SC_SB;


        FUNCTION FND_MCRE0_alimenta_CR_SC_SB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_SC_SB';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_SC_SB(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_SC_SB;

 FUNCTION FND_MCRE0_alimenta_CR_SC_SB_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_SC_SB_AP';

        v_result NUMBER := 0;

 BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_SC_SB_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_CR_SC_SB ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

          EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_SC_SB_AP;

 FUNCTION FND_MCRE0_convert_CR_SC_GB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_CR_SC_GB';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_CR_SC_GB');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_CR_SC_GB(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_CR_SC_GB');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_CR_SC_GB;


        FUNCTION FND_MCRE0_alimenta_CR_SC_GB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_SC_GB';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_SC_GB(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_SC_GB;

 FUNCTION FND_MCRE0_alimenta_CR_SC_GB_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_SC_GB_AP';

        v_result NUMBER := 0;

 BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_SC_GB_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_CR_SC_GB ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

          EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_SC_GB_AP;

 FUNCTION FND_MCRE0_convert_CR_LG_GB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_CR_LG_GB';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_CR_LG_GB');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_CR_LG_GB(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_CR_LG_GB');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_CR_LG_GB;


        FUNCTION FND_MCRE0_alimenta_CR_LG_GB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_LG_GB';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_LG_GB(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_LG_GB;

 FUNCTION FND_MCRE0_alimenta_CR_LG_GB_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_LG_GB_AP';

        v_result NUMBER := 0;

 BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_LG_GB_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_CR_LG_GB ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

          EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_LG_GB_AP;

 FUNCTION FND_MCRE0_convert_CR_GE_SB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_CR_GE_SB';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_CR_GE_SB');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_CR_GE_SB(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_CR_GE_SB');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_CR_GE_SB;


        FUNCTION FND_MCRE0_alimenta_CR_GE_SB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_GE_SB';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_GE_SB(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_GE_SB;

 FUNCTION FND_MCRE0_alimenta_CR_GE_SB_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_GE_SB_AP';

        v_result NUMBER := 0;

 BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_GE_SB_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_CR_GE_SB ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

          EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_GE_SB_AP;

 FUNCTION FND_MCRE0_convert_CR_GE_GB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_CR_GE_GB';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_CR_GE_GB');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_CR_GE_GB(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_CR_GE_GB');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_CR_GE_GB;


        FUNCTION FND_MCRE0_alimenta_CR_GE_GB(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_GE_GB';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_GE_GB(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_GE_GB;

 FUNCTION FND_MCRE0_alimenta_CR_GE_GB_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_CR_GE_GB_AP';

        v_result NUMBER := 0;

 BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_CR_GE_GB_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_CR_GE_GB ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

          EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_CR_GE_GB_AP;

 FUNCTION FND_MCRE0_convert_ANADIP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_ANADIP';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_ANADIP');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_ANADIP(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_ANADIP');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_ANADIP;


        FUNCTION FND_MCRE0_alimenta_ANADIP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_ANADIP';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_ANADIP(p_rec)) THEN

            v_result := 1;

            RETURN v_result;


      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_ANADIP;

 FUNCTION FND_MCRE0_alimenta_ANADIP_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_ANADIP_AP';

        v_result NUMBER := 0;

 BEGIN
       IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_ANADIP_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_ANADIP ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

          EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_ANADIP_AP;

FUNCTION FND_MCRE0_convert_EMAIL(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_EMAIL';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_EMAIL');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_CONVERT_EMAIL(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_EMAIL');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_EMAIL;

      FUNCTION FND_MCRE0_alimenta_EMAIL(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_EMAIL';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_EMAIL(p_rec)) THEN

            v_result := 1;

            RETURN v_result;



      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_EMAIL;

    FUNCTION FND_MCRE0_alimenta_EMAIL_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_EMAIL_AP';

        v_result NUMBER := 0;

        BEGIN
        IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_EMAIL_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alim_EMAIL ESEGUITA_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

     EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_EMAIL_AP;
FUNCTION FND_MCRE0_convert_PREGIUDIZIEV(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_convert_PREGIUDIZIEV';

        v_result NUMBER := 0;

    BEGIN

       DBMS_OUTPUT.PUT_LINE('BEGIN FND_MCRE0_convert_PREGIUDIZIEV');

        IF(PKG_MCRE0_CONVERSIONE.FND_MCRE0_convert_PREGIUDIZIEV(p_rec.SEQ_FLUSSO)) THEN

            v_result := 1;

        END IF;

        --PKG_MCRE0_LOG.log_evento(c_nome,'OK');

        RETURN v_result;

    EXCEPTION

        WHEN OTHERS THEN

           DBMS_OUTPUT.PUT_LINE('ERRORE IN FND_MCRE0_convert_PREGIUDIZIEV');

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_convert_PREGIUDIZIEV;

      FUNCTION FND_MCRE0_alimenta_PREGIUDIZ(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PREGIUDIZ';

        v_result NUMBER := 0;

    BEGIN


     IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_PREGIUDIZ(p_rec)) THEN

            v_result := 1;

            RETURN v_result;



      else

       PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;


        END IF;



    EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_PREGIUDIZ;

    FUNCTION FND_MCRE0_alimenta_PREGIUD_AP(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(100) := c_package || '.FND_MCRE0_alimenta_PREGIUD_AP';

        v_result NUMBER := 0;

        BEGIN
        IF(PKG_MCRE0_ALIMENTAZIONE.FND_MCRE0_alimenta_PREGIUD_AP(p_rec)) THEN

           DBMS_OUTPUT.PUT_LINE('FND_MCRE0_alimenta_PREGIUD_AP - INIZIALIZZO v_result := 1');

            v_result := 1;

            RETURN v_result;


        else


        PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

        RETURN -1;

            end if;

     EXCEPTION

        WHEN OTHERS THEN

            PKG_MCRE0_LOG.SPO_MCRE0_log_evento(p_rec.SEQ_FLUSSO,c_nome,'ERRORE',SUBSTR(SQLERRM, 1, 255));

            RETURN -1;

    END FND_MCRE0_alimenta_PREGIUD_AP;

 END PKG_MCRE0_FUNZIONI_SLAVE;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_FUNZIONI_SLAVE FOR MCRE_OWN.PKG_MCRE0_FUNZIONI_SLAVE;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_FUNZIONI_SLAVE FOR MCRE_OWN.PKG_MCRE0_FUNZIONI_SLAVE;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_FUNZIONI_SLAVE TO MCRE_USR;

