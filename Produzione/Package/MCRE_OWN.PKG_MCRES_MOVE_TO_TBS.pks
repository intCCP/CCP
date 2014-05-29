CREATE OR REPLACE PACKAGE MCRE_OWN.pkg_mcres_move_to_tbs as
/******************************************************************************
   NAME         pkg_mcres_move_to_tbs
   PURPOSE      moving mcres objects to their correct ablespaces
   ASSUMPTIONS
                1. all partitioned tables have no global indexes
                2. there are no LOB segments
                3. indexes tablespace name for data tablespace tsD_xxxx is tsI_xxx

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30/05/2012  Andrea Galliano  Created this package.
******************************************************************************/



--Public
--
function fnc_mcres_move_mcres_table(p_table_name in varchar2, p_rebuild_indexes in number default 1) return number;
--
procedure prc_mcres_move_all(p_rebuild_indexes in number default 1);
--
--
/***********************************************

Private
---



Constants

    c_pkg_name      constant varchar2(30)   := 'PKG_MCRES_MOVE_TO_TBS';
    c_debug         constant number(1)      := 3;
    c_warning       constant number(1)      := 2;
    c_error         constant number(1)      := 1;

    c_ok            constant number(1)      := 0;





Methods

procedure prc_log   (
                        p_procedura         in varchar2,
                        p_livello           in number,
                        p_tbs_dest          in varchar2,
                        p_table_name        in varchar2,
                        p_index_name        in varchar2 default null,
                        p_partition_name    in varchar2 default null,
                        p_subpartition_name in varchar2 default null,
                        p_sql_code          in number   default null,
                        p_sql_message       in varchar2 default null,
                        p_note              in varchar2 default null
                    );

function fnc_move_not_part_table(
                                    p_table_name    in varchar2,
                                    p_tbs_dest      in varchar2,
                                    p_reb_idxs      in number default 1
                                ) return number;

function fnc_move_part_table    (
                                    p_table_name    in varchar2,
                                    p_tbs_dest      in varchar2,
                                    p_reb_idxs      in number default 1
                                ) return number;

function fnc_move_subpart_table(
                                    p_table_name    in varchar2,
                                    p_tbs_dest      in varchar2,
                                    p_reb_idxs      in number   default 1
                                ) return number;

*******************************************************************/
end pkg_mcres_move_to_tbs;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_MOVE_TO_TBS FOR MCRE_OWN.PKG_MCRES_MOVE_TO_TBS;


CREATE SYNONYM MCRE_USR.PKG_MCRES_MOVE_TO_TBS FOR MCRE_OWN.PKG_MCRES_MOVE_TO_TBS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_MOVE_TO_TBS TO MCRE_USR;

