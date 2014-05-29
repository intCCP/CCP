CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_SVECCHIAMENTO AS
/******************************************************************************
   NAME:       PKG_MCR0_CONFORMITA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Andrea Bartolomei  Created this package.
   1.1        15/10/2012  Luca Ferretti      Aggiunto log corretto
   1.2        18/10/2012  Luca Ferretti      Aggiunta funzione per svecchiamento settimanale
   1.3        26/10/2012  Luca Ferretti      Aggiunto vincolo su cod_flusso nell'update
   1.4        30/10/2012  Luca Ferretti      Aggiunto log su drop partizione
   1.5        05/11/2012  Luca Ferretti      Aggiunto vincolo su cursore partizioni.
   1.6        12/11/2012  Luca Ferretti      Eliminato svecchiamento tabella di log.
   2.0        20/02/2013  M.Murro            ricerca dellìultimo flusso del mese scorso (ora gira weekly)
******************************************************************************/

    FUNCTION FND_MCRE0_svecchiamento(p_rec IN f_slave_par_type) RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_svecchiamento';
        v_count NUMBER;
        v_svecchia_st number;
        v_cod_file varchar2(20);
        v_current_month NUMBER;
        v_last_month NUMBER;
        v_last_period DATE;
        v_last_seq number;
        v_table_st varchar2 (45 byte);

       cursor c_partition  is
                            select ST_PARTITION, ID_FLUSSO
                            FROM T_MCRE0_WRK_ACQUISIZIONE
                            WHERE FLG_HST = 0
                            AND     ST_PARTITION is not null  -- aggiunta 1.5
                            AND COD_FILE = (select COD_FILE FROM T_MCRE0_WRK_ACQUISIZIONE
                                            where ID_FLUSSO = p_rec.SEQ_FLUSSO);
--       cursor c_logtable  is
--                            select NOME_TABELLA
--                            FROM T_MCRE0_WRK_SVECCHIAMENTO
--                            WHERE
--                            TIPO_TABELLA = 'LOG';

        r_partition c_partition%ROWTYPE;
--        r_logtable varchar2 (45 byte);

    BEGIN

        PKG_MCRE0_AUDIT.log_etl (p_rec.SEQ_FLUSSO, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');
        PKG_MCRE0_AUDIT.log_etl (p_rec.SEQ_FLUSSO, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'p_rec: seq_flusso: '||p_rec.seq_flusso||
                                                                               ' nome_file: '||p_rec.nome_file||
                                                                               ' periodo: '||p_rec.periodo||
                                                                               ' TAB_EXT: '||p_rec.TAB_EXT||
                                                                               ' TAB_TRG: '||p_rec.TAB_TRG||
                                                                               ' ORDINE_ALIMENTAZIONE: '||p_rec.ORDINE_ALIMENTAZIONE);
        select COD_FILE
            into v_cod_file
        FROM T_MCRE0_WRK_ACQUISIZIONE
        where ID_FLUSSO = p_rec.SEQ_FLUSSO;

        select P_SVECCHIA, NOME_TABELLA
            into v_svecchia_st, v_table_st
        from T_MCRE0_WRK_SVECCHIAMENTO
        WHERE TIPO_TABELLA = v_cod_file;

         v_current_month := extract(month from p_rec.PERIODO);
         PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'Mese estratto: '||v_current_month, '' );

         SELECT extract (month from PERIODO_RIFERIMENTO), PERIODO_RIFERIMENTO, ID_FLUSSO
            INTO v_last_month, v_last_period, v_last_seq
         FROM T_MCRE0_WRK_ACQUISIZIONE
             WHERE COD_FILE = v_cod_file
             AND ID_FLUSSO <> p_rec.SEQ_FLUSSO
             and STATO = 'CARICATO'
             AND PERIODO_RIFERIMENTO = (SELECT MAX(PERIODO_RIFERIMENTO) FROM T_MCRE0_WRK_ACQUISIZIONE
                 WHERE COD_FILE = v_cod_file
                 AND ID_FLUSSO <> p_rec.SEQ_FLUSSO
                 --v2.0 ricerco sempre l'ultimo flusso del mese scorso
                 and to_char(PERIODO_RIFERIMENTO, 'yyyymm') != to_char(sysdate, 'yyyymm')
                 and STATO = 'CARICATO');

         UPDATE T_MCRE0_WRK_ACQUISIZIONE
             SET    ST_PARTITION = 'CCP_P'|| TO_CHAR(p_rec.PERIODO, 'YYYYMMDD')
             WHERE  1=1
             AND    ID_FLUSSO = p_rec.SEQ_FLUSSO
             AND    ST_PARTITION != 'CCP_P'|| TO_CHAR(p_rec.PERIODO, 'YYYYMMDD');
         COMMIT;

         UPDATE T_MCRE0_WRK_ACQUISIZIONE
             SET FLG_HST = 0
             WHERE FLG_HST NOT IN  (-1, 2)
             AND PERIODO_RIFERIMENTO <= (p_rec.PERIODO - v_svecchia_st)
             AND STATO = 'CARICATO'
             AND COD_FILE = v_cod_file; -- 1.3 aggiunto vincolo
         COMMIT;

        if v_last_month <> v_current_month then
            UPDATE T_MCRE0_WRK_ACQUISIZIONE
                SET FLG_HST = 2
                WHERE ID_FLUSSO = v_last_seq;
            COMMIT;
        end if;

            OPEN c_partition;

            PKG_MCRE0_AUDIT.log_etl (p_rec.SEQ_FLUSSO, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'inizio loop drop partition', 'INIZIO');

            LOOP
                FETCH c_partition INTO r_partition;
                EXIT WHEN c_partition%NOTFOUND;

                    EXECUTE IMMEDIATE 'ALTER TABLE ' || v_table_st || ' DROP PARTITION ' || r_partition.ST_PARTITION;

                    PKG_MCRE0_AUDIT.log_etl (p_rec.SEQ_FLUSSO, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'droppata partizione: '||v_table_st||'.'||r_partition.ST_PARTITION, 'FINE');

                    UPDATE T_MCRE0_WRK_ACQUISIZIONE
                        SET FLG_HST = -1
                        WHERE ST_PARTITION = r_partition.ST_PARTITION
                        AND COD_FILE = v_cod_file;
                     COMMIT;

--                OPEN c_logtable;

--                LOOP
--                FETCH c_logtable INTO r_logtable;
--                EXIT WHEN c_logtable%NOTFOUND;

--                 EXECUTE IMMEDIATE 'DELETE FROM ' || r_logtable || ' WHERE ID_FLUSSO =' ||  r_partition.ID_FLUSSO;
--                END LOOP;

--                CLOSE c_logtable;

            END LOOP;

            PKG_MCRE0_AUDIT.log_etl (p_rec.SEQ_FLUSSO, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'finito loop drop partition', 'FINE');
            CLOSE c_partition;
            PKG_MCRE0_AUDIT.log_etl (p_rec.SEQ_FLUSSO, c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');

            RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (p_rec.SEQ_FLUSSO, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ECCEZIONE '||'p_rec: seq_flusso: '||p_rec.seq_flusso||
                                                                               ' nome_file: '||p_rec.nome_file||
                                                                               ' periodo: '||p_rec.periodo||
                                                                               ' TAB_EXT: '||p_rec.TAB_EXT||
                                                                               ' TAB_TRG: '||p_rec.TAB_TRG||
                                                                               ' ORDINE_ALIMENTAZIONE: '||p_rec.ORDINE_ALIMENTAZIONE);
            CLOSE c_partition;

            RETURN FALSE;
    END FND_MCRE0_svecchiamento;



    FUNCTION FND_MCRE0_svecchiamento_weekly RETURN BOOLEAN IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.FND_MCRE0_svecch_weekly';
        v_count NUMBER;
        v_svecchia_st number;
        v_cod_file varchar2(20);
        v_current_month NUMBER;
        v_last_month NUMBER;
        v_last_period DATE;
        v_last_seq number;
        v_table_st varchar2 (45 byte);
        v_riferimento T_MCRE0_WRK_ACQUISIZIONE%ROWTYPE;

        cursor c_nome_file is
                            select b.nome_file, b.cod_file, b.id_flusso from(
                                select  a.cod_file, max(a.id_flusso) as id_flusso
                                        from    T_MCRE0_WRK_ACQUISIZIONE a, v_mcre0_ultima_acquisizione b
                                        WHERE   1=1
                                        AND     ST_PARTITION IS NOT NULL
                                        AND     b.cod_file = a.cod_file
                                        AND     b.idper = (select max(idper) from v_mcre0_ultima_acquisizione)
                                group by a.cod_file
                                ) a, t_mcre0_wrk_acquisizione b, t_mcre0_wrk_svecchiamento c
                                where   1=1
                                and     a.id_flusso = b.id_flusso
                                and     c.tipo_tabella = a.cod_file;

        r_nome_file c_nome_file%ROWTYPE;
        v_slave_par f_slave_par_type;
        esito boolean;

    BEGIN

        PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'INIZIO', 'INIZIO');

        open c_nome_file;

        loop
            FETCH c_nome_file INTO r_nome_file;
            EXIT WHEN c_nome_file%NOTFOUND;

            v_slave_par := PKG_MCRE0_UTILS.FND_MCRE0_get_slave_param(r_nome_file.id_flusso,r_nome_file.nome_file);
            PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'v_slave_par:',
                                                                               ' seq_flusso: '||v_slave_par.seq_flusso||
                                                                               ' nome_file: '||v_slave_par.nome_file||
                                                                               ' periodo: '||v_slave_par.periodo||
                                                                               ' TAB_EXT: '||v_slave_par.TAB_EXT||
                                                                               ' TAB_TRG: '||v_slave_par.TAB_TRG||
                                                                               ' ORDINE_ALIMENTAZIONE: '||v_slave_par.ORDINE_ALIMENTAZIONE
                                                                               );
            esito := FND_MCRE0_svecchiamento(v_slave_par);
        end loop;

        close c_nome_file;

        PKG_MCRE0_AUDIT.log_etl (c_nome, PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, 'FINE', 'FINE');

        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            PKG_MCRE0_AUDIT.log_etl (v_slave_par.SEQ_FLUSSO, c_nome, PKG_MCRE0_AUDIT.C_ERROR, sqlcode, sqlerrm, 'ECCEZIONE - '||v_slave_par.seq_flusso);
            CLOSE c_nome_file;

            RETURN FALSE;
    END FND_MCRE0_svecchiamento_weekly;

END PKG_MCRE0_SVECCHIAMENTO;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_SVECCHIAMENTO FOR MCRE_OWN.PKG_MCRE0_SVECCHIAMENTO;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_SVECCHIAMENTO FOR MCRE_OWN.PKG_MCRE0_SVECCHIAMENTO;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_SVECCHIAMENTO TO MCRE_USR;

