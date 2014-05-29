CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_ASS_AUTOM" AS
/******************************************************************************
   NAME:       PKG_MCRE0_ASS_AUTOM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Chiara Giannangeli  Created this package.
   1.1        04/07/2010  M.Murro             sequence di log come parametro
   1.2        13/12/2012  Luca Ferretti       Eliminati i dbms_output
******************************************************************************/


    FUNCTION FND_MCRE0_popola_tmp(p_id NUMBER) RETURN number IS

        c_nome CONSTANT VARCHAR2(50) := c_package || '.1_popola_tmp';
        v_return number;



    BEGIN

    v_return := -1;

    execute immediate 'TRUNCATE TABLE T_MCRE0_TMP_ASSEGNA_AUTOM';

    insert into T_MCRE0_TMP_ASSEGNA_AUTOM

        select * from (
               WITH q1 AS
        (SELECT mpl.*,
                fg.cod_gruppo_super,
                CASE
                WHEN so.cod_comparto IS NOT NULL
                THEN so.cod_comparto

                ELSE
                    CASE
                    WHEN MPL.COD_UO_RISCHIO is not null
                    THEN 'COMPARTO NON CENSITO'
                    ELSE 'COD_UO_RISCHIO NULL'
                    END

                END comparto_da_ass
           FROM t_mcre0_app_mople24 mpl INNER JOIN t_mcre0_app_file_guida24 fg
                ON mpl.cod_abi_cartolarizzato = fg.cod_abi_cartolarizzato
                AND mpl.cod_ndg = fg.cod_ndg

         LEFT OUTER JOIN
                (SELECT
                CASE
                    WHEN c.flg_chk = '1'
                    THEN org.cod_comparto
                    ELSE
                   'NO DIR'
                 END cod_comparto,
                org.cod_struttura_competente,
                org.cod_abi_istituto

               FROM t_mcre0_app_struttura_org org LEFT OUTER JOIN t_mcre0_app_comparti c
               ON c.cod_comparto = org.cod_comparto
                ) so

              ON mpl.cod_uo_rischio = so.cod_struttura_competente
              AND mpl.cod_abi_istituto = so.cod_abi_istituto
          WHERE mpl.dta_decorrenza_stato >
                     (SYSDATE -7
                     )             --filtro  posizioni in incaglio da 7 giorni
            AND mpl.id_transizione = 'M'         --assegnazione stato: manuale
            AND mpl.cod_stato = 'IN'
            --filtro comparti di direzione
            AND fg.cod_comparto_calcolato = '011901'
            AND fg.cod_comparto_assegnato IS NULL),
        q2 AS
        (SELECT *
           FROM t_mcre0_app_utenti)


           SELECT COUNT (1) OVER (PARTITION BY f.cod_gruppo_super),
          f."COD_GRUPPO_SUPER",
          f.cod_uo_rischio,
          f.cod_matr_rischio,
          f."COMPARTO_DA_ASS",
          f."ID_UTENTE_DA_ASS",
          CASE
              WHEN
                  f.COMPARTO_DA_ASS <> 'NO DIR'
                  and  f.COMPARTO_DA_ASS <> 'COD_UO_RISCHIO NULL'
                  and f.ID_UTENTE_DA_ASS <> 'UTENTE NON CENSITO'
                  and f.COMPARTO_DA_ASS <> 'COMPARTO NON CENSITO'
                  and f.ID_UTENTE_DA_ASS <> 'COD_MATR_RISCHIO INCOERENTE'
              THEN
              1

              ELSE

              null

           END as warning_0

     FROM (SELECT DISTINCT d.cod_gruppo_super,
                           d.comparto_da_ass AS comparto_da_ass,
                           d.cod_uo_rischio,
                           d.cod_matr_rischio,
                           CASE

                              WHEN d.ut_cod_matr IS NULL THEN

                              CASE
                              WHEN d.cod_matr_rischio is not null
                              THEN 'UTENTE NON CENSITO'
                              ELSE 'COD_MATR_RISCHIO NULL'
                              END

                              ELSE

                              CASE
                              WHEN d.ut_cod_comparto=d.comparto_da_ass
                              THEN to_char(d.ut_cod_matr)
                              ELSE 'COD_MATR_RISCHIO INCOERENTE'

                            END

                           END ID_UTENTE_DA_ASS

                      FROM (SELECT q1.*,
                                   q2.ID_UTENTE AS ut_cod_matr,
                                   q2.cod_comparto_assegn AS ut_cod_comparto
                              FROM q1 LEFT JOIN q2
                                   ON 'U' || q1.cod_matr_rischio=q2.cod_matricola
                                   ) d

                                   ) f
           );
           commit;

        PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 3, 0, 'OK', 'OK');

         v_return := 1;
         RETURN v_return;

         EXCEPTION

        WHEN OTHERS THEN

        rollback;


      PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 1, SQLCODE, SQLERRM, 'KO');

        RETURN -1;

    end FND_MCRE0_popola_tmp;



      FUNCTION FND_MCRE0_update_file_guida(p_id NUMBER) RETURN number IS


        c_nome CONSTANT VARCHAR2(50) := c_package || '.2_update_file_guida';
        v_count1 number;
        v_count2 number;
         v_return number;


      begin
      v_return := -1;

               MERGE
               INTO  T_MCRE0_APP_FILE_GUIDA24 trg

               USING (select * from T_MCRE0_TMP_ASSEGNA_AUTOM
                where
                FLG_WARNING = '1'
                and COUNT_POS = 1
                ) src

            ON  (src.COD_GRUPPO_SUPER = trg.COD_GRUPPO_SUPER)

            WHEN MATCHED

            THEN

              UPDATE

              SET
              trg.ID_UTENTE=case when FND_MCRE0_IS_NUMERIC(src.ID_UTENTE_DA_ASS) = 1
                            then src.ID_UTENTE_DA_ASS
                            else NULL
                            end,

              trg.COD_COMPARTO_ASSEGNATO=src.COMPARTO_DA_ASS,
              trg.COD_OPERATORE_INS_UPD='ASS AUTOM IN'
              where trg.id_dper=(select max(id_dper) from T_MCRE0_APP_FILE_GUIDA24);

              v_count1 := sql%rowcount;

            insert into T_MCRE0_TMP_LISTA_STORICO(COD_ABI_CARTOLARIZZATO    ,
            COD_NDG    ,
            COD_SNDG    ,
            FLG_STATO    ,
            FLG_COMPARTO    ,
            FLG_GESTORE    ,
            FLG_MESE    ,
            DTA_INS    ,
            COD_MESE_HST
            )

            select
            COD_ABI_CARTOLARIZZATO,
            COD_NDG,
            COD_SNDG,
            0 as FLG_STATO,
            1 as FLG_COMPARTO,
            case when FND_MCRE0_IS_NUMERIC(src.ID_UTENTE_DA_ASS) = 1
            then 1
            else 0
            end FLG_GESTORE,
            0 as FLG_MESE,
            sysdate DTA_INS,
            null as COD_MESE_HST

             from T_MCRE0_APP_FILE_GUIDA24 trg
             inner join  (select * from T_MCRE0_TMP_ASSEGNA_AUTOM
                          where
                          FLG_WARNING = '1'
                          and COUNT_POS = 1
                          ) src

            ON  ( src.COD_GRUPPO_SUPER = trg.COD_GRUPPO_SUPER)
            where trg.id_dper=(select max(id_dper) from T_MCRE0_APP_FILE_GUIDA24);

              v_count2 := sql%rowcount;

             if (v_count1 = v_count2) then
             commit;
             
             PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 3, 0, 'OK', 'RECORD AGGIORNATI '||v_count2 );

             else
             PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 1, 0, 'KO', 'RECORD DA AGGIORNARE '||v_count1 ||' - RECORD DA STORICIZZARE '||v_count2 );
             rollback;
             v_return := -1;
             end if;

             select max(nvl(FLG_MESE, 0))
             into v_count2
             from T_MCRE0_TMP_LISTA_STORICO;

             if (v_count2=1) then

             update T_MCRE0_TMP_LISTA_STORICO
             set FLG_MESE=1,
             COD_MESE_HST=(select max(COD_MESE_HST)
                           from T_MCRE0_TMP_LISTA_STORICO);
             commit;

             end if;



        v_return := 1;
        RETURN v_return;

    EXCEPTION


        WHEN OTHERS THEN

        rollback;


     PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 1, SQLCODE, SQLERRM, 'KO');

        RETURN -1;

    END FND_MCRE0_update_file_guida;

    FUNCTION FND_MCRE0_log_warning(p_id NUMBER) RETURN number IS

    c_nome CONSTANT VARCHAR2(50) := c_package || '.3_log_warning';
    v_count number;
    v_warning varchar2 (70 byte);
     v_return number;
     v_count2  number;

    begin
        v_return := -1;
         v_count := 0;
         v_count2 := 0;



              SELECT DISTINCT
              case when count(*) = 0
              then
              0
              else
              count(*)
              end num_warning,

              case when count(*) = 0
              then
              'OK'
              else
              max(COMPARTO_DA_ASS)
              end note

              INTO v_count, v_warning

              from T_MCRE0_TMP_ASSEGNA_AUTOM
              WHERE  (COMPARTO_DA_ASS = 'COMPARTO NON CENSITO'
                     and ID_UTENTE_DA_ASS <> 'UTENTE NON CENSITO');

              if (v_count>0) then
              PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 1, 0, v_warning, 'RECORD SCARTATI: '||v_count );
              v_count2 := 1;
              end if;

              SELECT DISTINCT
              case when count(*) = 0
              then
              0
              else
              count(*)
              end num_warning,

              case when count(*) = 0
              then
              'OK'
              else
              max(COMPARTO_DA_ASS)
              end note

              INTO v_count, v_warning

              from T_MCRE0_TMP_ASSEGNA_AUTOM
              WHERE COMPARTO_DA_ASS = 'NO DIR';

              if (v_count>0) then
               PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 1, 0, v_warning, 'RECORD SCARTATI: '||v_count );
               v_count2 := 1;
              end if;



              SELECT DISTINCT
              case when count(*) = 0
              then
              0
              else
              count(*)
              end num_warning,

              case when count(*) = 0
              then
              'OK'
              else
              max(ID_UTENTE_DA_ASS)
              end note

              INTO v_count, v_warning

              from T_MCRE0_TMP_ASSEGNA_AUTOM
              WHERE  (ID_UTENTE_DA_ASS = 'UTENTE NON CENSITO'
                      and COMPARTO_DA_ASS <> 'COMPARTO NON CENSITO');

              if (v_count>0) then
              PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 1, 0, v_warning, 'RECORD SCARTATI: '||v_count );
              v_count2 := 1;
              end if;


              SELECT DISTINCT
              case when count(*) = 0
              then
              0
              else
              count(*)
              end num_warning,

              case when count(*) = 0
              then
              'OK'
              else
              max(COMPARTO_DA_ASS) ||' E ' || max(ID_UTENTE_DA_ASS)
              end note

              INTO v_count, v_warning

              from T_MCRE0_TMP_ASSEGNA_AUTOM
              WHERE  (ID_UTENTE_DA_ASS = 'UTENTE NON CENSITO'
                      and COMPARTO_DA_ASS = 'COMPARTO NON CENSITO');

              if (v_count>0) then
              PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 1, 0, v_warning, 'RECORD SCARTATI: '||v_count );
              v_count2 := 1;
              end if;


              SELECT DISTINCT
              case when count(*) = 0
              then
              0
              else
              count(*)
              end num_warning,

              case when count(*) = 0
              then
              'OK'
              else
              max(ID_UTENTE_DA_ASS)
              end note

              INTO v_count, v_warning

              from T_MCRE0_TMP_ASSEGNA_AUTOM
              WHERE  (ID_UTENTE_DA_ASS = 'COD_MATR_RISCHIO INCOERENTE'
                      and COMPARTO_DA_ASS <>'NO DIR'
                      and COMPARTO_DA_ASS <> 'COMPARTO NON CENSITO'
                      and COMPARTO_DA_ASS <> 'COD_UO_RISCHIO NULL');

              if (v_count>0) then
              PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 1, 0, v_warning, 'RECORD SCARTATI: '||v_count );
              v_count2 := 1;
              end if;


              SELECT DISTINCT
              case when count(*) = 0
              then
              0
              else
              count(*)
              end num_warning,

              case when count(*) = 0
              then
              'OK'
              else
              max(COMPARTO_DA_ASS)
              end note

              INTO v_count, v_warning

              from T_MCRE0_TMP_ASSEGNA_AUTOM
              WHERE COMPARTO_DA_ASS = 'COD_UO_RISCHIO NULL'
              and  ID_UTENTE_DA_ASS <> 'COD_MATR_RISCHIO NULL';

              if (v_count>0) then
              PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 1, 0, v_warning, 'RECORD SCARTATI: '||v_count );
              v_count2 := 1;
              end if;



              SELECT DISTINCT
              case when count(*) = 0
              then
              0
              else
              count(*)
              end num_warning,

              case when count(*) = 0
              then
              'OK'
              else
              'RECORD NON AGGREGABILI PER COD_GRUPPO_SUPER'
              end note

              INTO v_count, v_warning

              from T_MCRE0_TMP_ASSEGNA_AUTOM
              WHERE COUNT_POS > 1;

              if (v_count>0) then
              PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 1, 0, v_warning, 'RECORD SCARTATI: '||v_count );
              v_count2 := 1;
              end if;


           if (v_count2=0) then

             PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 3, 0, 'OK', 'ASSEGNAZIONE COMPLETATA SENZA SCARTI');

           end if;

              v_return := 1;
              return v_return;

         EXCEPTION

        WHEN OTHERS THEN


     PKG_MCRE0_AUDIT.log_etl (p_id, c_nome, 1, SQLCODE, SQLERRM, 'KO');

        RETURN -1;

    end FND_MCRE0_log_warning;

    FUNCTION FND_MCRE0_assegna(p_seq number) RETURN number IS
    v_id NUMBER;
    v_return number;

    begin
    v_id := p_seq;

     v_return := (PKG_MCRE0_ASS_AUTOM.FND_MCRE0_popola_tmp(v_id));

     if (v_return=1) then
     v_return := (PKG_MCRE0_ASS_AUTOM.FND_MCRE0_update_file_guida(v_id));
     end if;

     if (v_return=1) then
     v_return := (PKG_MCRE0_ASS_AUTOM.FND_MCRE0_log_warning(v_id));
     end if;

     RETURN v_return;



    end FND_MCRE0_assegna;


END PKG_MCRE0_ASS_AUTOM;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ASS_AUTOM FOR MCRE_OWN.PKG_MCRE0_ASS_AUTOM;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ASS_AUTOM FOR MCRE_OWN.PKG_MCRE0_ASS_AUTOM;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ASS_AUTOM TO MCRE_USR;

