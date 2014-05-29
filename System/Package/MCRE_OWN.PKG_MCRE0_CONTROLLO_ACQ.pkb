CREATE OR REPLACE PACKAGE BODY MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ AS
/******************************************************************************
   NAME:       PKG_MCRE0_CONTROLLO_ACQ
   PURPOSE:

   REVISIONS:
   Ver        Date        Author             Description
   ---------  ----------  -----------------  ------------------------------------
   1.0        21/04/2010  Andrea Bartolomei  Created this package.
   2.0        08/06/2011  Luca Ferretti      Aggiunta procedura per controllo ETL secondo livello
   2.1        22/11/2011  Luca Ferretti      Rimozione di dbms_output
   2.2        25/11/2011  Luca Ferretti      Ordina inserimento in tabella per data desc
   2.3        13/12/2011  Luca Ferertti      Aggiunta procedura per tempistica blocchi TWS2
   2.4        04/10/2012  Luca Ferretti      Commentati controlli su primo livello
******************************************************************************/

       PROCEDURE SPO_MCRE0_CONTROLLO_ACQ(COD_FLUSSO IN VARCHAR2) IS

v_external varchar2(50);
v_st varchar2(50);
v_app varchar2(50);
v_partition varchar2(50);
v_id_dper number;
v_id_flusso number;
v_count_abi NUMBER;

BEGIN



select to_number(to_char(max(PERIODO_RIFERIMENTO), 'yyyymmdd'))
into v_id_dper
from T_MCRE0_WRK_ACQUISIZIONE
where  COD_FILE = COD_FLUSSO;

select
el.TAB_ESTERNA,
el.TAB_TRG,
replace(el.TAB_TRG, '_ST_', '_APP_'),
ACQ.ST_PARTITION,
ACQ.ID_FLUSSO

INTO v_external, v_st, v_app, v_partition, v_id_flusso
from
T_MCRE0_WRK_ELABORAZIONE el
inner join T_MCRE0_WRK_ACQUISIZIONE acq
on el.cod_file = ACQ.COD_FILE
where acq.COD_FILE = COD_FLUSSO
and ACQ.PERIODO_RIFERIMENTO = (select max(PERIODO_RIFERIMENTO) from T_MCRE0_WRK_ACQUISIZIONE where  COD_FILE = COD_FLUSSO)

group by
el.TAB_ESTERNA,
el.TAB_TRG,
replace(el.TAB_TRG, '_ST_', '_APP_'),
ACQ.ST_PARTITION,
ACQ.ID_FLUSSO;

execute immediate  '
declare
v_count1 number;
v_count2 number;
v_count3 number;
v_scarti1 number;
v_scarti2 number;
v_scarti3 number;
v_count_abi NUMBER;
BEGIN


SELECT SCARTI_EXTERNAL
into v_scarti1
from T_MCRE0_WRK_ACQUISIZIONE
where cod_file = '''|| COD_FLUSSO ||'''
and ST_PARTITION = '''|| v_partition ||''';

SELECT SCARTI_CONVERT
into v_scarti2
from T_MCRE0_WRK_ACQUISIZIONE
where cod_file = '''|| COD_FLUSSO ||'''
and ST_PARTITION = '''|| v_partition ||''';

SELECT SCARTI_VINCOLI
into v_scarti3
from T_MCRE0_WRK_ACQUISIZIONE
where cod_file = '''|| COD_FLUSSO ||'''
and ST_PARTITION = '''|| v_partition ||''';


    IF (v_scarti1 = 0) and (v_scarti2 = 0) and (v_scarti3 = 0)    then


select count(*)
into v_count1 from '|| v_external||';

select count(*)
into v_count2
from '|| v_st||' PARTITION(' || v_partition || ');

select count(*)
into v_count3 from '|| v_app||'
where ID_DPER = '|| v_id_dper||';

IF (v_count1 = v_count2) and (v_count2 = v_count3) THEN

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate, '''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''ESITO CARICAMENTO: OK''  FROM DUAL;
     commit;

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''RECORD INSERITI IN TABELLA _APP:  ''|| v_count3 FROM DUAL;
     commit;

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''-----------------------------------------------------'' FROM DUAL;
     commit;




ELSE

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''ESITO CARICAMENTO: ERROR''  FROM DUAL;
     commit;

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''RECORD IN TABELLA EXTERNAL:         ''|| v_count1 FROM DUAL;
     commit;


     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''RECORD INSERITI IN TABELLA _ST:    ''|| v_count2 FROM DUAL;
     commit;

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''RECORD INSERITI IN TABELLA _APP:  ''|| v_count3 FROM DUAL;
     commit;

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''-----------------------------------------------------''  FROM DUAL;
     commit;



END IF;


        else

        select count(*)
        into v_count2
        from '|| v_st||' PARTITION(' || v_partition || ');

        select count(*)
        into v_count3 from '|| v_app||'
        where ID_DPER = '|| v_id_dper||';

        IF  (v_count2 = v_count3) THEN

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''ESITO CARICAMENTO: OK (WARNING: RECORD SCARTATI)''  FROM DUAL;
     commit;

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''RECORD INSERITI IN TABELLA _APP:  ''|| v_count3 FROM DUAL;
     commit;

        ELSE

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''ESITO CARICAMENTO: ERROR (WARNING: RECORD SCARTATI)''  FROM DUAL;
     commit;

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''RECORD INSERITI IN TABELLA _ST:    ''|| v_count2  FROM DUAL;
     commit;

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''RECORD INSERITI IN TABELLA _APP:    ''|| v_count3 FROM DUAL;
     commit;

        END IF;

        IF v_scarti1 > 0 THEN

      INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''RECORD BAD IN TABELLA EXTERNAL:        ''|| v_scarti1 FROM DUAL;
     commit;

        END IF;

        IF v_scarti2 > 0 THEN

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''SCARTI DI CONVERSIONE:                 ''|| v_scarti2 FROM DUAL;
     commit;

        END IF;

        IF v_scarti3 > 0 THEN

     INSERT INTO T_MCRE0_CL_ACQ
     SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''RECORD SCARTATI IN CHIAVE DUPLICATA:   ''|| v_scarti3 FROM DUAL;
     commit;

        END IF;

      INSERT INTO T_MCRE0_CL_ACQ
      SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''-----------------------------------------------------''  FROM DUAL;
      commit;



    END IF;

IF ('''||COD_FLUSSO||''' = ''FILE_GUIDA'') THEN

SELECT COUNT(*)
INTO v_count_abi
FROM V_CK_ISTITUITI;

if (v_count_abi > 0) then

      INSERT INTO T_MCRE0_CL_ACQ
      SELECT sysdate , '''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''ABI NON CENSITI NELLA TABELLA APP_FILE_GUIDA: ''|| v_count_abi  FROM DUAL;
      commit;


     INSERT INTO T_MCRE0_CL_ACQ
      SELECT  sysdate , '''||
      COD_FLUSSO || ''', '
      || v_id_flusso ||', '
      || v_id_dper||', '||'
     ist.COD_ABI_CARTOLARIZZATO
     FROM DUAL, V_CK_ISTITUITI ist;
     commit;


 INSERT INTO T_MCRE0_CL_ACQ
      SELECT sysdate,'''|| COD_FLUSSO||''',
     '|| v_id_flusso||',
     '||v_id_dper||',
     ''-----------------------------------------------------''  FROM DUAL;
      commit;

end if;



END IF;

END;';




 END SPO_MCRE0_CONTROLLO_ACQ;

PROCEDURE SPO_MCRE0_CONTROLLO_ACQ_ALL
   IS
      CURSOR c_cur
      IS
         SELECT   'BEGIN PKG_MCRE0_CONTROLLO_ACQ.SPO_MCRE0_CONTROLLO_ACQ('''
                  || COD_FILE
                  || '''); END;'
           FROM   T_MCRE0_WRK_ACQUISIZIONE
          WHERE   PERIODO_RIFERIMENTO =
                     (SELECT   MAX (PERIODO_RIFERIMENTO)
                        FROM   T_MCRE0_WRK_ACQUISIZIONE);

      r_cur   VARCHAR2 (500 BYTE);
      v_sql   VARCHAR2 (500 BYTE);
      v_ret   NUMBER;
      v_seq   NUMBER;

   BEGIN
      SELECT   SEQ_MCR0_CL_CONTROLLI.NEXTVAL INTO v_seq FROM DUAL;
      EXECUTE IMMEDIATE 'TRUNCATE TABLE T_MCRE0_CL_ACQ';

--      OPEN c_cur;

--      LOOP
--         FETCH c_cur INTO   r_cur;
--            EXIT WHEN c_cur%NOTFOUND;
--            v_sql := r_cur;
--            EXECUTE IMMEDIATE v_sql;
--      END LOOP;

--      CLOSE c_cur;

   -- Eseguo i controlli sul secondo livello
    v_ret:=SPO_MCRE0_CONTROLLO_SEC_LIV;

   EXCEPTION WHEN OTHERS THEN
    PKG_MCRE0_AUDIT.LOG_ETL ( v_seq, 'SPO_MCRE0_CONTROLLO_ACQ_ALL', PKG_MCRE0_AUDIT.c_error, SQLCODE, sqlerrm, 'ECCEZIONE' );
   END SPO_MCRE0_CONTROLLO_ACQ_ALL;


FUNCTION SPO_MCRE0_CONTROLLO_SEC_LIV return number is
   cursor c1 is
    select  a.COD_FILE, a.NOME_FILE, a.TMS_FILE, a.PERIODO_RIFERIMENTO
    from    t_mcre0_wrk_acquisizione a
    where   a.PERIODO_RIFERIMENTO = (select max(periodo_riferimento) from t_mcre0_wrk_acquisizione)
    order by A.TMS_FILE asc;

    rec1    c1%ROWTYPE;

    cursor c1b is
        select primo.giorno giorno, min(primo.tms_file) inizio_caricamento, max(secondo.fine)fine_caricamento, round((max(secondo.fine)-min (primo.tms_file)) *1440,0) totmin
        from (
        select  a.COD_FILE, a.NOME_FILE, a.TMS_FILE, a.PERIODO_RIFERIMENTO, trunc(tms_file) giorno
        from    t_mcre0_wrk_acquisizione a
        where 1=1
        group by a.COD_FILE, a.NOME_FILE, a.TMS_FILE, a.PERIODO_RIFERIMENTO
        order by tms_file desc
        ) primo,
        (
        select trunc(dta_ins) giorno, min(dta_ins), max(dta_ins) fine, round((max(dta_ins)-min (dta_ins)) *1440,0) totmin
        from T_MCRE0_WRK_AUDIT_ETL
        where
         (
        procedura like '1%' or
        procedura like '2%' or
        procedura like '3%' or
        procedura like '4%' or
        procedura like '5%' or
        procedura like '6%' or
        procedura like '7%' or
        procedura like '8_1%' or
        procedura like '9%'
        )
        group by trunc(dta_ins)
        order by trunc(dta_ins) desc
        ) secondo
        where secondo.giorno = primo.giorno
        group by primo.giorno
        order by giorno desc;


    rec1b    c1b%ROWTYPE;

    cursor c2A is
    select  a.COD_ABI_CARTOLARIZZATO, b.COD_MACROSTATO,  a.COD_STATO, a.COD_PROCESSO ,count(*) conteggio
    from    V_MCRE0_APP_HP_EXCEL a, t_mcre0_app_stati b
    where   a.desc_COMPARTO like 'Ufficio%'
    and     a.COD_STATO = b.COD_MICROSTATO
    and     a.FLG_OUTSOURCING = 'Y'
    and     a.COD_PROCESSO in ('GF','GI','GR','GC','GL','GP','EG','CG')
    group by a.COD_STATO, a.COD_ABI_CARTOLARIZZATO, a.COD_PROCESSO,  b.COD_MACROSTATO
    order by 1, 2, 3, 4;

    rec2A    c2A%ROWTYPE;

    CURSOR C2B IS
    select a.COD_COMPARTO,b.COD_MACROSTATO, a.COD_STATO , a.COD_PROCESSO , count(*) conteggio
    from V_MCRE0_APP_HP_EXCEL a, t_mcre0_app_stati b
    where a.desc_COMPARTO like 'Ufficio%'
    and   a.COD_STATO = b.COD_MICROSTATO
    and a.FLG_OUTSOURCING = 'Y'
    and a.COD_PROCESSO in ('GF','GI','GR','GC','GL','GP','EG','CG')
    group by a.COD_STATO, a.COD_PROCESSO ,  a.COD_COMPARTO, b.COD_MACROSTATO
    order by 1, 2, 3, 4;

    REC2B C2B%ROWTYPE;

    CURSOR C3 IS
    select a.COD_GE, a.DESC_GE , b.COD_MACROSTATO ,a.COD_STATO ,count(*) conteggio
    from V_MCRE0_APP_HP_EXCEL a,  t_mcre0_app_stati b
    where a.desc_COMPARTO like 'Ufficio%'
    and a.COD_STATO = b.COD_MICROSTATO
    and a.FLG_OUTSOURCING = 'Y'
    and a.COD_PROCESSO in ('GF','GI','GR','GC','GL','GP','EG','CG')
    group by  a.COD_GE, a.DESC_GE ,a.COD_STATO, b.COD_MACROSTATO
    order by 1, 2, 3, 4;

    REC3 C3%ROWTYPE;

    quanti number;

    CURSOR C6 IS
    select  a.FLG_CAMBIO_STATO,
            min(DTA_FINE_VALIDITA) Prima_storicizzazione, max(DTA_FINE_VALIDITA) Ultima_storicizzazione,  count(distinct cod_sndg) quanti
    from    t_mcre0_app_Storico_eventi a
    where   a.DTA_FINE_VALIDITA >= (select  trunc(max(a.tms_file))
                                    from    T_MCRE0_WRK_ACQUISIZIONE a )
    group by a.FLG_CAMBIO_STATO
    order by a.flg_cambio_stato asc;

    REC6 C6%ROWTYPE;

    CURSOR C7 IS
    select
        trunc(a.DTA_FINE_VALIDITA) Data_Evento,
        a.COD_GRUPPO_super,
        count(distinct a.COD_ABI_CARTOLARIZZATO||COD_NDG) num_pos,
        sum( FLG_CAMBIO_STATO) CAMBIO_STATO,
        sum(a.FLG_CAMBIO_COMPARTO) CAMBIO_COMP,
        sum(a.FLG_CAMBIO_GESTORE) CAMBIO_GEST
    from MCRE_OWN.T_MCRE0_APP_STORICO_EVENTI a
    where
    trunc(a.DTA_FINE_VALIDITA) = (select  trunc(max(a.tms_file))
                                  from    T_MCRE0_WRK_ACQUISIZIONE a )
    group by a.COD_GRUPPO_super,trunc(a.DTA_FINE_VALIDITA)
    order by 2;

    REC7 C7%ROWTYPE;

    CURSOR C8 IS
    select  a.COD_STATO, count(*) conteggio
    from    V_MCRE0_APP_HP_EXCEL a
    where   a.COD_STATO <> 'SO'
    group by a.COD_STATO
    order by 1;

    REC8 C8%ROWTYPE;



    seq NUMBER;
    ord number:=0;

 begin
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'inizio controlli', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'Inizio');
    select SEQ_MCR0_LOG_ETL.nextval into seq from dual;

    execute immediate 'truncate table T_MCRE0_CL_PRIMO_LIV';
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'CHECK - T_MCRE0_CL_PRIMO_LIV', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'Inizio');
    open c1;
        LOOP
            FETCH c1 INTO rec1;
            EXIT WHEN c1%NOTFOUND;
                INSERT INTO T_MCRE0_CL_PRIMO_LIV (cod_file, nome_file, tms_file, periodo_riferimento) values (rec1.COD_FILE, rec1.NOME_FILE, rec1.TMS_FILE, rec1.PERIODO_RIFERIMENTO);
        END LOOP;
    close c1;
    commit;

    execute immediate 'truncate table T_MCRE0_CL_TEMPO';
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'CHECK - T_MCRE0_CL_tempo', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'Inizio');
    open c1b;
        LOOP
            FETCH c1b INTO rec1b;
            EXIT WHEN c1b%NOTFOUND;
                INSERT INTO T_MCRE0_CL_TEMPO (giorno, inizio_caricamento, fine_caricamento, tempo) VALUES(rec1b.GIORNO, rec1B.INIZIO_CARICAMENTO, rec1B.FINE_CARICAMENTO, rec1B.TOTMIN);
        END LOOP;
    close c1b;
    commit;

    execute immediate 'truncate table T_MCRE0_CL_ABI';
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'CHECK - T_MCRE0_CL_abi', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'Inizio');
    open c2A;
        LOOP
            FETCH c2A INTO rec2A;
            EXIT WHEN c2A%NOTFOUND;
                INSERT INTO T_MCRE0_CL_ABI (ABI, MACROSTATO, STATO, PROCESSO, CONTEGGIO) VALUES(REC2A.COD_ABI_CARTOLARIZZATO, REC2A.COD_MACROSTATO, REC2A.COD_STATO, REC2A.COD_PROCESSO, REC2A.conteggio );
        END LOOP;
    close c2A;
    commit;

    execute immediate 'truncate table T_MCRE0_CL_COMPARTO';
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'CHECK - T_MCRE0_CL_comparto', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'Inizio');
    open c2B;
        LOOP
            FETCH c2B INTO rec2B;
            EXIT WHEN c2B%NOTFOUND;
                INSERT INTO T_MCRE0_CL_COMPARTO (ABI, MACROSTATO, STATO, PROCESSO, CONTEGGIO) VALUES( REC2B.COD_COMPARTO, REC2B.COD_MACROSTATO, REC2B.COD_STATO, REC2B.COD_PROCESSO, REC2B.conteggio);
        END LOOP;

    close c2B;
    commit;

    execute immediate 'truncate table T_MCRE0_CL_GRUPPO_ECONOMICO';
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'CHECK - T_MCRE0_CL_GE', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'Inizio');
    open c3;
        LOOP
            FETCH c3 INTO rec3;
            EXIT WHEN c3%NOTFOUND;
                INSERT INTO T_MCRE0_CL_GRUPPO_ECONOMICO (COD_GE, GRUPPO_ECONOMICO, MACROSTATO, STATO, CONTEGGIO) VALUES( REC3.COD_GE, REC3.DESC_GE, REC3.COD_MACROSTATO, REC3.COD_STATO, REC3.conteggio );
        END LOOP;
    close c3;
    commit;

    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'CHECK - T_MCRE0_CL_SUPER_NULL', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'Inizio');
    select  count(*) conteggio into quanti
    from    t_mcre0_app_file_guida a
    where   a.ID_DPER=(select max(id_dper) from t_mcre0_app_file_guida)
    AND     A.COD_GRUPPO_SUPER IS NULL;

    INSERT INTO T_MCRE0_CL_SUPER_NULL (QUANTI) VALUES(QUANTI);

    commit;

    execute immediate 'truncate table T_MCRE0_CL_CAMBI_STATO';
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'CHECK - T_MCRE0_CL_cambi_stato', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'Inizio');
    open c6;
        LOOP
            FETCH C6 INTO rec6;
            EXIT WHEN c6%NOTFOUND;
                INSERT INTO T_MCRE0_CL_CAMBI_STATO (FLG_CAMBIO_STATO, PRIMA_STORICIZZAZIONE, ULTIMA_STORICIZZAZIONE, QUANTI) VALUES(REC6.FLG_CAMBIO_STATO, REC6.Prima_storicizzazione, REC6.Ultima_storicizzazione, REC6.quanti);
        END LOOP;
    close c6;
    commit;

    execute immediate 'truncate table T_MCRE0_CL_CAMBI';
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'CHECK - T_MCRE0_CL_cambi', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'Inizio');
    open c7;
        LOOP
            FETCH C7 INTO rec7;
            EXIT WHEN c7%NOTFOUND;
                INSERT INTO T_MCRE0_CL_CAMBI (DATA_EVENTO, COD_GRUPPO_SUPER, NUM_POS, CAMBIO_STATO, CAMBIO_COMPARTO, CAMBIO_GESTORE) VALUES( REC7.Data_Evento, REC7.COD_GRUPPO_super, REC7.num_pos, REC7.CAMBIO_STATO, REC7.CAMBIO_COMP, REC7.CAMBIO_GEST);
        END LOOP;
    close c7;
    commit;

    execute immediate 'truncate table T_MCRE0_CL_NUM_POS_STATO';
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'CHECK - T_MCRE0_CL_num_pos_stato', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'Inizio');
    open c8;
        LOOP
            FETCH C8 INTO rec8;
            EXIT WHEN c8%NOTFOUND;
                INSERT INTO T_MCRE0_CL_NUM_POS_STATO (STATO, CONTEGGIO) VALUES( REC8.COD_STATO, REC8.Conteggio);
        END LOOP;
    close c8;
    commit;

    RETURN 1;

 exception when others then
     PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'fnd_mcre0_controlli', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'ECCEZIONE' );
     return 0;
 end;


 PROCEDURE SPO_MCRE0_TEMPI_BLOCCHI IS

    giorno  varchar2(50 byte);
    v_qry   varchar2(200 byte);
    seq     NUMBER;

 BEGIN

    select SEQ_MCR0_LOG_ETL.nextval into seq from dual;
    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'Controlli - Tempi Blocchi', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'INIZIO');

    select to_char(sysdate, 'dd-mon') into giorno from dual;
    PKG_MCRE0_AUDIT.log_etl (seq,' ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, SQLERRM, 'Giorno analizzato: '||giorno);
    execute immediate 'alter table t_mcre0_cl_blocchi add ("'||giorno||'" number)';
    PKG_MCRE0_AUDIT.log_etl (seq,' ', PKG_MCRE0_AUDIT.C_DEBUG, sqlcode, SQLERRM, 'Aggiunta colonna '||giorno||' alla tabella t_mcre0_cl_blocchi');
    execute immediate 'truncate table t_mcre0_cl_blocchi_appo';
    insert into t_mcre0_cl_blocchi_appo
        select substr(procedura, 1, 3) livello, round((max(dta_ins)-min(dta_ins)) *1440,0) totmin
        from T_MCRE0_WRK_AUDIT_ETL
        where 1=1
        and trunc(dta_ins) = (select trunc(max(dta_ins)) from  T_MCRE0_WRK_AUDIT_ETL)
        and (
        procedura like '0%' or
        procedura like '1%' or
        procedura like '2%' or
        procedura like '3%' or
        procedura like '4%' or
        procedura like '5%' or
        procedura like '6%' or
        procedura like '7%' or
        procedura like '8%' or
        procedura like '9%'
        )
        group by substr(procedura, 1, 3)
        order by livello desc;

    v_qry := 'update t_mcre0_cl_blocchi a set "'|| giorno ||'"= (select oggi from t_mcre0_cl_blocchi_appo where Livello = A.LIVELLO)';
    execute immediate v_qry;
    PKG_MCRE0_AUDIT.log_etl (seq, 'Update eseguita', PKG_MCRE0_AUDIT.c_DEBUG, sqlcode, SQLERRM, v_qry);
    commit;

    PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'Controlli - Tempi Blocchi', PKG_MCRE0_AUDIT.C_DEBUG, SQLCODE, sqlerrm, 'FINE');

 EXCEPTION WHEN OTHERS THEN
     PKG_MCRE0_AUDIT.LOG_ETL ( seq, 'fnd_mcre0_controlli - TEMPI_BLOCCHI', PKG_MCRE0_AUDIT.C_ERROR, SQLCODE, sqlerrm, 'ECCEZIONE' );
 end;

END PKG_MCRE0_CONTROLLO_ACQ;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_CONTROLLO_ACQ FOR MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_CONTROLLO_ACQ FOR MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_CONTROLLO_ACQ TO MCRE_USR;

