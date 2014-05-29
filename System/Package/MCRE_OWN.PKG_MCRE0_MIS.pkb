CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_MIS" AS
/*****************************************************************************************************
NAME:     PKG_MCRE0_MIS
PURPOSE:  delivers MIS (Monitoraggio Incagli Sofferenze) data to QdC

REVISIONS:
Ver        Date        Author             Description
---------  ----------  -----------------  ------------------------------------
1.0        11/04/2011   Paola Goitre       Created this package.
1.1        15/05/2012   Andrea Galliano    Added procedures pPrepareDailyImage pPrepareMonthlyImage pPrepareCurrentImage
1.2        17/05/2012   Andrea Galliano    Added procedure pTruncateDest
1.3        11/07/2012   Andrea Galliano    Added new pPrepareCurrentImage pPrepareMonthlyImage
**********************************************************************************************************/

PROCEDURE pLog(p_id_dper in number,p_cod_src in varchar2,p_cod_err in number default 0,p_des_err in varchar2 default NULL)
IS
begin
insert into mcre_own.qzt_st_mis_log values (sysdate,p_id_dper,p_cod_src,p_cod_err,p_des_err);
commit;
end;
--
PROCEDURE pDeQueue(p_id_dper in number,p_cod_src in varchar2)
IS
p_cod_err number;
p_des_err varchar2(2000);
begin
     execute immediate 'delete mcre_own.qzt_st_mis_run where id_dper=:p1 and cod_src=:p2' using p_id_dper,p_cod_src;
    commit;
EXCEPTION
WHEN OTHERS THEN
p_cod_err:=SQLCODE;
p_des_err:=SQLERRM;
pLog(p_id_dper,p_cod_src,p_cod_err,p_des_err);
end;

--
PROCEDURE pEnQueue(p_id_dper in number,p_cod_src in varchar2)
IS
p_cod_err number;
p_des_err varchar2(2000);
begin
     execute immediate 'insert into mcre_own.qzt_st_mis_run(id_dper,cod_src) values (:p1,:p2)' using p_id_dper,p_cod_src;
    commit;
EXCEPTION
WHEN OTHERS THEN
p_cod_err:=SQLCODE;
p_des_err:=SQLERRM;
pLog(p_id_dper,p_cod_src,p_cod_err,p_des_err);
end;
--
PROCEDURE pPrepareMonthlyImage( p_id_dper number)
IS
p_cod_err number;
p_des_err varchar2(2000);
v_dper number(8) := p_id_dper;

--cursor c
--is
--    select val_parameter v_dper
--    from mcre_own.qzt_st_mis_param
--    where des_parameter = 'id_dper';


--begin


--    for r in c
--    loop
--
--        MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE(r.v_dper,'BM');
--        MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE(r.v_dper,'BD');
--        MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE(r.v_dper,'RM');
--        MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE(r.v_dper,'RT');
--        MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE(r.v_dper,'RA');
--        MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE(r.v_dper,'MM');
--        MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE(r.v_dper,'MT');
--        MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE(r.v_dper,'MA');
--        MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE(r.v_dper,'PM');
--
--    end loop;
--
--
--    MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE(v_dper,'BP');
--    MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE(v_dper,'RP');
--

/*
    cursor c_periodo
    is
        select val_parameter id_dper
        from qzt_st_mis_param
        where upper(des_parameter) = 'ID_DPER';
*/
    cursor c_src
    is
        select distinct cod_src
        from qzt_st_mis_cfg
        where flg_ignore = 0 and flg_reload = 0;

begin

--    for p in c_periodo
--    loop

        for r in c_src
        loop
--            v_dper := p.id_dper;
            MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE( v_dper, r.cod_src);

        end loop;

--    end loop;


EXCEPTION
WHEN OTHERS THEN
p_cod_err:=SQLCODE;
p_des_err:=SQLERRM;
pLog(v_dper,null,p_cod_err,p_des_err);
end;
--
PROCEDURE pPrepareDailyImage
IS
p_cod_err number;
p_des_err varchar2(2000);
v_dper varchar2(8);


    cursor c_src
    is
        select distinct cod_src
        from qzt_st_mis_cfg
        where flg_ignore = 0 and flg_reload = 1;

begin

    select max(val_parameter)
    into v_dper
    from qzt_st_mis_param
    where upper(des_parameter) = 'ID_DPER';


    for r in c_src
    loop

        MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE(v_dper, r.cod_src);

    end loop;


EXCEPTION
WHEN OTHERS THEN
p_cod_err:=SQLCODE;
p_des_err:=SQLERRM;
pLog(v_dper,null,p_cod_err,p_des_err);
end;
--
/*
PROCEDURE pPrepareCurrentImage
is
    p_cod_err number;
    p_des_err varchar2(2000);
    v_check number(1);

begin

    select min(flg_to_spool)
    into v_check
    from t_mcres_wrk_anagrafica_bilanci
    where flg_ignore <> 1;

    if (v_check = 1)    --tutti i nuovi file di bilancio sono disponibili
    then
        pPrepareMonthlyImage;
        update t_mcres_wrk_anagrafica_bilanci
        set flg_to_spool = 0;
        commit;
    else
        pPrepareDailyImage;
    end if;

EXCEPTION
WHEN OTHERS THEN
p_cod_err:=SQLCODE;
p_des_err:=SQLERRM;
pLog(null,null,p_cod_err,p_des_err);
end;
*/
--
PROCEDURE pPrepareCurrentImage
is

    cursor c_src
    is
        select distinct cod_src, flg_reload
        from qzt_st_mis_cfg
        where flg_ignore = 0;

    p_cod_err   number;
    p_des_err   varchar2(2000);
    v_dper      number(8);
    v_count     number;

begin

    select max(val_parameter)
    into v_dper
    from qzt_st_mis_param
    where des_parameter = 'ID_DPER';

    select count(*)
    into v_count
    from
    (
        select cod_flusso, cod_abi
        from t_mcres_wrk_anagrafica_bilanci
        where flg_ignore = 0
        ---
        minus
        ---
        select cod_flusso, cod_abi
        from v_mcres_ultima_acq_file
        where 0=0
        and cod_flusso in ('SISBA_CP', 'EFFETTI_ECONOMICI', 'MOVIMENTI_MOD_MOV')    --flussi di bilancio
        and id_dper = v_dper
    );

    if (v_count = 0)    --tutti i nuovi file di bilancio sono disponibili
    then

        for r in c_src
        loop

            MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE( v_dper, r.cod_src);

        end loop;

        --Avanzamento periodo atteso per il caricamento dei mensili
        update  qzt_st_mis_param
        set val_parameter = to_char( add_months( to_date( val_parameter, 'yyyymmdd'), 1), 'yyyymmdd')
        where des_parameter = 'ID_DPER';

        commit;

    else

        for r in c_src
        loop

            if (r.flg_reload= 1)
            then

                MCRE_OWN.PKG_MCRE0_MIS.PENQUEUE( v_dper, r.cod_src);

            end if;

        end loop;


    end if;



EXCEPTION
WHEN OTHERS THEN
p_cod_err:=SQLCODE;
p_des_err:=SQLERRM;
pLog(null,null,p_cod_err,p_des_err);
end;
--
PROCEDURE pLoadCurrentImage
IS
p_id_dper number;
p_cod_src varchar2(2);
p_cod_err number;
p_des_err varchar2(2000);

cursor c_st is

    select DISTINCT
           seq,
           id_dper,
           c.cod_src,
           flg_reload,
           'insert /*+append*/ into '||dest||'('||cols||') select '||cols||' from '||src my_sqlcommand
    from mcre_own.qzt_st_mis_cfg c,
         mcre_own.qzt_st_mis_run r
    where c.cod_src=r.cod_src and c.flg_ignore = 0
    order by seq,c.cod_src,id_dper;

begin

    --Preparazione tabelle in cui inserire i dati per estrazione
    for r in (select distinct dest from mcre_own.qzt_st_mis_cfg where flg_ignore = 0)
    loop

        execute immediate 'truncate table ' || r.dest;

    end loop;

    --insert dati per estrazione
    for v_st in c_st loop

        p_id_dper:=v_st.id_dper;
        p_cod_src:=v_st.cod_src;

        execute immediate 'begin dbms_application_info.set_client_info(:p); end;' using p_id_dper;
        execute immediate v_st.my_sqlcommand;
        commit;

        pLog(p_id_dper,p_cod_src);
        pDeQueue( p_id_dper,p_cod_src);

        commit;

    end loop;


EXCEPTION
WHEN OTHERS THEN
p_cod_err:=SQLCODE;
p_des_err:=SQLERRM;
pLog(p_id_dper,p_cod_src,p_cod_err,p_des_err);
end;

END PKG_MCRE0_MIS;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_MIS FOR MCRE_OWN.PKG_MCRE0_MIS;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_MIS FOR MCRE_OWN.PKG_MCRE0_MIS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_MIS TO MCRE_USR;

