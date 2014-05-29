CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRES_CONFORMITA AS
/******************************************************************************
   NAME:       PKG_MCRES_CONFORMITA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        05/07/2011  Luca Ferertti      Created this package.
   1.1        11/09/2012  Antonio Pilloni    Commentate insert nel blocco if.
******************************************************************************/

    FUNCTION FNC_MCRES_verifica_conformita(p_rec IN f_slave_par_type) RETURN NUMBER IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.verifica_conformita';

        v_count NUMBER;
        v_periodo NUMBER;

    BEGIN

        v_periodo := TO_NUMBER(TO_CHAR(p_rec.PERIODO, 'YYYYMMDD'));

        PKG_MCRES_AUDIT.log_caricamenti(p_rec.SEQ_FLUSSO, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'BEGIN FND_MCRES_verifica_conformita ' );
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || p_rec.TAB_EXT INTO v_count;

        PKG_MCRES_AUDIT.log_caricamenti(p_rec.SEQ_FLUSSO, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'FND_MCRES_verifica_conformita ESEGUITA' );

        BEGIN

            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || p_rec.TAB_EXT || '_BAD' INTO v_count;

            IF v_count > 0 THEN

            UPDATE T_MCRES_WRK_ACQUISIZIONE
            SET VAL_SCARTI_EXTERNAL = v_count
            where ID_FLUSSO = p_rec.SEQ_FLUSSO;
            COMMIT;
            PKG_MCRES_AUDIT.log_caricamenti(p_rec.SEQ_FLUSSO, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'EXTERNAL TABLE CON SCARTI' );

            /* AP - 11/09/2012
            EXECUTE IMMEDIATE 'INSERT INTO T_MCRES_WRK_EXTERNAL_BAD SELECT ' || p_rec.SEQ_FLUSSO || ',' ||  V_PERIODO || ', BAD FROM '|| p_rec.TAB_EXT || '_BAD';
            COMMIT;
            PKG_MCRES_AUDIT.log_caricamenti(p_rec.SEQ_FLUSSO, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'SAVE BAD EXTERNAL TABLE' );

            EXECUTE IMMEDIATE 'INSERT INTO T_MCRES_WRK_EXTERNAL_LOG SELECT '|| p_rec.SEQ_FLUSSO || ',' ||  V_PERIODO || ', LOG FROM '|| p_rec.TAB_EXT || '_LOG';
            COMMIT;
            PKG_MCRES_AUDIT.log_caricamenti(p_rec.SEQ_FLUSSO, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'SAVE LOG EXTERNAL TABLE' );
            */
            END IF;

        EXCEPTION WHEN OTHERS THEN

            UPDATE T_MCRES_WRK_ACQUISIZIONE
            SET VAL_SCARTI_EXTERNAL = 0
            where ID_FLUSSO = p_rec.SEQ_FLUSSO;
            COMMIT;
            PKG_MCRES_AUDIT.log_caricamenti(p_rec.SEQ_FLUSSO, c_nome, PKG_MCRES_AUDIT.C_DEBUG, SQLCODE, SQLERRM, 'EXTERNAL TABLE SENZA SCARTI' );

            RETURN ok;

        END;

        RETURN ok;

    EXCEPTION

        WHEN OTHERS THEN
            PKG_MCRES_AUDIT.log_caricamenti(p_rec.SEQ_FLUSSO, c_nome, PKG_MCRES_AUDIT.C_ERROR, SQLCODE, SQLERRM, null );
            RETURN ko;

    END FNC_MCRES_verifica_conformita;

END PKG_MCRES_CONFORMITA;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_CONFORMITA FOR MCRE_OWN.PKG_MCRES_CONFORMITA;


CREATE SYNONYM MCRE_USR.PKG_MCRES_CONFORMITA FOR MCRE_OWN.PKG_MCRES_CONFORMITA;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_CONFORMITA TO MCRE_USR;

