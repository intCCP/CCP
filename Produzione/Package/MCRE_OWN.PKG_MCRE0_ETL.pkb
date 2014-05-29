CREATE OR REPLACE PACKAGE BODY MCRE_OWN."PKG_MCRE0_ETL" AS
/******************************************************************************
  NAME:       PKG_MCRE0_ETL
  PURPOSE:

  REVISIONS:
  Ver        Date        Author             Description
  ---------  ----------  -----------------  ------------------------------------
  1.0        22/03/2013  Paola Goitre         Created this package
  1.1        23/05/2013  A. Gigante           Added competence_date handling
*******************************************************************************/
  function close return number IS
  begin
    update T_MCRE0_WRK_CONFIGURAZIONE set VALORE_COSTANTE = 0 where NOME_COSTANTE = 'STATO_PORTALE';
    commit;
    return 0;
    EXCEPTION
           WHEN OTHERS THEN
           return SQLCODE;
  END close;
  function open return number IS
  begin
    update T_MCRE0_WRK_CONFIGURAZIONE set VALORE_COSTANTE = 1 where NOME_COSTANTE = 'STATO_PORTALE';
    commit;
    return 0;
    EXCEPTION
           WHEN OTHERS THEN
           return SQLCODE;
  END open;
  PROCEDURE log(p_etl_level        number,
                p_tws_level        number,
                p_tws_sublevel     number,
                p_area             varchar2,
                p_step             varchar2,
                p_caller           varchar2,
                p_sql_ord          number,
                p_start_date       date,
                p_end_date         date,
                p_proc_rows        number,
                p_filename        varchar2 default null,
                p_err_cod          number default null,
                p_err_msg          varchar2 default null,
                p_invocation_id    number,
                p_competence_date  date default null
                )
  IS

    p_log_id number;
    BEGIN

    select seq_mcre0_etl_log.nextval
           into p_log_id from dual;
    insert into t_mcre0_etl_log ( log_id          ,
                                  etl_level       ,
                                  tws_level       ,
                                  tws_sublevel    ,
                                  area            ,
                                  step            ,
                                  caller          ,
                                  sql_ord         ,
                                  start_date      ,
                                  end_date        ,
                                  processed_rows  ,
                                  file_name       ,
                                  err_cod         ,
                                  err_msg         ,
                                  invocation_id   ,
                                  competence_date
                                 ) values (
                                  p_log_id        ,
                                  p_etl_level     ,
                                  p_tws_level     ,
                                  p_tws_sublevel  ,
                                  p_area          ,
                                  p_step          ,
                                  p_caller        ,
                                  p_sql_ord       ,
                                  p_start_date    ,
                                  p_end_date      ,
                                  p_proc_rows     ,
                                  p_filename     ,
                                  p_err_cod       ,
                                  p_err_msg       ,
                                  p_invocation_id ,
                                  p_competence_date
                                  );
    commit;

  END log;

  PROCEDURE log_proc(p_proc varchar2,err_cod number default null,msg varchar2 default null, d_start date default null,p_proc_rows number default null) IS
  p_etl_level          number(2);
  p_tws_level         number(2);
  p_tws_sublevel    number(2);
  p_area                varchar2(255);
  p_step                varchar2(255);
  p_caller              varchar2(255);
  p_sql_ord            number(2);
  p_invocation_id    number(14);
  p_sqltext             varchar2(32000);
  p_filename          varchar2(255);
  p_twssublevel       number(2);
  p_ext_table          varchar2(30);
  p_periodo_rif        varchar2(255);
  d_competence_date    date;

  begin

    for v in (select  c.etl_level, c.tws_level, c.tws_sublevel, c.area, c.caller,
                e.step,e.sql_ord,e.sql_text
                from t_mcre0_etl_cfg c, t_mcre0_etl_caller e
                where upper(sql_text) like '%'||upper(p_proc)||'%'
                and c.caller=e.caller -- and e.flg_exec=1
                and rownum=1
             )
  loop
      begin
          exit when sqlcode <> 0;
          p_etl_level:=v.etl_level;
          p_tws_level:=v.tws_level;
          p_tws_sublevel:=v.tws_sublevel;
          p_area:=v.area;
          p_step:=v.step;
          p_caller:=v.caller;
          p_sql_ord:=v.sql_ord;
          p_sqltext:=v.sql_text;

          log(p_etl_level     ,
              p_tws_level     ,
              p_tws_sublevel  ,
              p_area          ,
              p_step          ,
              p_caller        ,
              p_sql_ord       ,
              d_start         ,
              sysdate         ,
              p_proc_rows     ,
              null     ,
              nvl(err_cod,0),
              substr(p_sqltext||'-'||msg,1,500),
              to_number(to_char(d_start,'yyyymmddhhmiss')),
              null
              );

end;
end loop;
end log_proc;

function load_data(p_etllevel number,p_twslevel number,p_option  varchar2) return number IS

  d_start              date:=sysdate;
  s_caller             varchar2(255):=c_package||'.load_data';
  p_etl_level          number(2);
  p_tws_level          number(2);
  p_tws_sublevel       number(2);
  p_area               varchar2(255);
  p_step               varchar2(255);
  p_proc_rows          number:=0;
  p_caller             varchar2(255);
  p_sql_ord            number(2);
  p_invocation_id      number(14);
  p_sqltext            varchar2(32000);
  p_filename         varchar2(255);
  p_twssublevel       number(2);
  p_ext_table          varchar2(30);
  p_periodo_rif        varchar2(255);
  d_competence_date    date;
  p_query              varchar2(1000);
  --
   ex    BOOLEAN;
 flen  NUMBER;
 bsize NUMBER;
--
p_file_name_old varchar2(255);
p_file_name_inc varchar2(255);
p_directory_name_old varchar2(255);
p_directory_name_inc varchar2(255);
p_ext_table_name_dta_inc varchar2(255);
  BEGIN
  select to_number(to_char(sysdate,'yyyymmddhhmiss')) ,
    case when p_etllevel=1 then p_option else null end,
    case when p_etllevel=2 then p_option else null end
    into p_invocation_id,p_filename,p_twssublevel
    from dual;

  for v in (
        select etl_level, tws_level, tws_sublevel,
               area, caller, step, sql_ord, sql_text--, ext_table_name, ext_table_name_dta, file_name,directory_name
        from v_mcre0_etl_cfg
        where
            etl_level=p_etllevel
        and tws_level=p_twslevel
        --and (file_name=p_filename or p_filename is null)
       -- and (p_filename like cod_file||'%' or p_filename is null)
        and (p_filename = cod_file or p_filename is null)
        and (tws_sublevel=p_twssublevel or p_twssublevel is null)
             )
  loop

      begin
          exit when sqlcode <> 0;
          p_etl_level:=v.etl_level;
          p_tws_level:=v.tws_level;
          p_tws_sublevel:=v.tws_sublevel;
          p_area:=v.area;
          p_step:=v.step;
          p_caller:=v.caller;
          p_sql_ord:=v.sql_ord;
          d_start := sysdate;

          --copio file da WORK se non c'Ú in ITT : 1 o nessuno
         for v in (select file_name, directory_name, file_name_inc, directory_name_inc ,ext_table_name_dta_inc
                      from v_mcre0_etl_file
                      where cod_file=p_area
                      and (select valore_costante from t_mcre0_wrk_configurazione where nome_costante='DOPPIO_ETL')=1)
        loop
                  p_file_name_old:=v.file_name;
                  p_directory_name_old:=v.directory_name;
                  p_file_name_inc:=v.file_name_inc;
                  p_directory_name_inc:=v.directory_name_inc;
                  p_ext_table_name_dta_inc:=v.ext_table_name_dta_inc;
                  --utl_file.fgetattr(p_directory_name_inc,p_file_name_inc, ex, flen, bsize);
                  ---if not ex then
                   fcopy(p_directory_name_old,p_file_name_old, p_directory_name_inc,p_file_name_inc);
                   --end if;

                  -- Retrieving competence date from external table XX_DT
                  p_sqltext:='select periodo_rif,to_date(periodo_rif,''ddmmyyyy'') '||
                                    'from '||p_ext_table_name_dta_inc||' where rownum = 1';
                  execute immediate p_sqltext
                     into p_periodo_rif,d_competence_date;
             end loop;



          -- Executing step
          p_sqltext:=v.sql_text;
          execute immediate p_sqltext;
          p_proc_rows:=sql%rowcount;
          commit;
          log(p_etl_level     ,
              p_tws_level     ,
              p_tws_sublevel  ,
              p_area          ,
              p_step          ,
              p_caller        ,
              p_sql_ord       ,
              d_start         ,
              sysdate         ,
              p_proc_rows     ,
              p_filename     ,
              0,
              substr(p_sqltext,1,500),
              p_invocation_id,
              d_competence_date
              );

          EXCEPTION
           WHEN OTHERS THEN
            log(p_etl_level     ,
                p_tws_level     ,
                p_tws_sublevel  ,
                p_area          ,
                p_step          ,
                p_caller        ,
                p_sql_ord       ,
                d_start         ,
                sysdate         ,
                p_proc_rows     ,
                p_filename     ,
                SQLCODE         ,
                substr(SQLERRM,1,500),
                p_invocation_id,
                d_competence_date
                );
          -- raise;
          return 1; --return SQLCODE;
      end;
  end loop;

  return 0;
  EXCEPTION
   WHEN OTHERS THEN
    log(p_etl_level     ,
        p_tws_level     ,
        p_tws_sublevel  ,
        p_area          ,
        p_step          ,
        s_caller        ,
        p_sql_ord       ,
        d_start         ,
        sysdate         ,
        p_proc_rows     ,
        p_filename     ,
        SQLCODE         ,
        substr(SQLERRM,1,500),
        p_invocation_id,
        d_competence_date
        );

      -- return SQLCODE;
      return 1;
  END load_data;

  /* backup staging data and truncate working tables*/
  function purge_work return number is

  d_start              date:=sysdate;
  s_caller             varchar2(255):=c_package||'.purge_work';
  p_etl_level          number(2);
  p_tws_level          number(2);
  p_tws_sublevel       number(2);
  p_area               varchar2(255);
  p_step               varchar2(255);
  p_proc_rows          number:=0;
  p_caller             varchar2(255);
  p_sql_ord            number(2);
  p_invocation_id      number(14);
  p_sqltext            varchar2(32000);
  p_filename           varchar2(255);
  p_twssublevel        number(2);

  BEGIN
  select to_number(to_char(sysdate,'yyyymmddhhmiss'))
    into p_invocation_id
    from dual;

  /* ARCHIVE previous staging data + truncate all working tables */
    for v in (select etl_level, tws_level, tws_sublevel,
                area, caller, case when flg_arc=1 then 'ARC' else 'TRU' end step, sql_ord, sql_text --,case when flg_arc=1 then 0 else 1 end myrnk
                from v_mcre0_etl_cfg where flg_trunc=1 or flg_arc=1
                order by etl_level, tws_level, tws_sublevel,
                area, caller,
                case when flg_arc=1 then 0 else 1 end,
                sql_ord)
 loop

      begin
          exit when sqlcode <> 0;
          p_etl_level:=v.etl_level;
          p_tws_level:=v.tws_level;
          p_tws_sublevel:=v.tws_sublevel;
          p_area:=v.area;
          p_step:=v.step;
          p_caller:=v.caller;
          p_sql_ord:=v.sql_ord;
          p_sqltext:=v.sql_text;
          d_start := sysdate;

          execute immediate p_sqltext;
          p_proc_rows:=sql%rowcount;
          log(p_etl_level     ,
              p_tws_level     ,
              p_tws_sublevel  ,
              p_area          ,
              p_step          ,
              p_caller        ,
              p_sql_ord       ,
              d_start         ,
              sysdate         ,
              p_proc_rows     ,
              p_filename     ,
              0,
              substr(p_sqltext,1,500),
              p_invocation_id
              );

          EXCEPTION
           WHEN OTHERS THEN
            log(p_etl_level     ,
                p_tws_level     ,
                p_tws_sublevel  ,
                p_area          ,
                p_step          ,
                p_caller        ,
                p_sql_ord       ,
                d_start         ,
                sysdate         ,
                p_proc_rows     ,
                p_filename     ,
                SQLCODE         ,
                substr(SQLERRM,1,500),
                p_invocation_id);
          -- raise;
          return SQLCODE;
      end;
  end loop;

  return 0;
  EXCEPTION
   WHEN OTHERS THEN
    log(p_etl_level     ,
        p_tws_level     ,
        p_tws_sublevel  ,
        p_area          ,
        p_step          ,
        s_caller        ,
        p_sql_ord       ,
        d_start         ,
        sysdate         ,
        p_proc_rows     ,
        p_filename     ,
        SQLCODE         ,
        substr(SQLERRM,1,500),
        p_invocation_id);
        return SQLCODE;
  END purge_work;
END PKG_MCRE0_ETL;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ETL FOR MCRE_OWN.PKG_MCRE0_ETL;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ETL FOR MCRE_OWN.PKG_MCRE0_ETL;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ETL TO MCRE_USR;

