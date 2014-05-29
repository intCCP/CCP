CREATE OR REPLACE PACKAGE MCRE_OWN."PKG_MCRE0_ETL" AS
/******************************************************************************
  NAME:       PKG_MCRE0_ETL
  PURPOSE:

  REVISIONS:
  Ver        Date        Author               Description
  ---------  ----------  -------------------  --------------------------------
  1.0        22/03/2013  Paola Goitre         Created this package
******************************************************************************/

  c_package CONSTANT VARCHAR2 (50) := 'pkg_mcre0_etl';

  function close return number;
  function open return number;
  procedure log(p_etl_level        number,
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
                );
  procedure log_proc(p_proc varchar2,err_cod number default null,msg varchar2 default null, d_start date default null,p_proc_rows number default null) ;
  function load_data(p_etllevel number,p_twslevel number,p_option  varchar2) return number;
  function purge_work return number;
END PKG_MCRE0_ETL;
/


CREATE SYNONYM MCRE_APP.PKG_MCRE0_ETL FOR MCRE_OWN.PKG_MCRE0_ETL;


CREATE SYNONYM MCRE_USR.PKG_MCRE0_ETL FOR MCRE_OWN.PKG_MCRE0_ETL;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRE0_ETL TO MCRE_USR;

