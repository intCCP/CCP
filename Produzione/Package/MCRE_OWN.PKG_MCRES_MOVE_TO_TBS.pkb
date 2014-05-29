CREATE OR REPLACE PACKAGE BODY MCRE_OWN.pkg_mcres_move_to_tbs as
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
--
--
--Constants

    c_pkg_name      constant varchar2(30)   := 'PKG_MCRES_MOVE_TO_TBS';
    c_debug         constant number(1)      := 3;
    c_warning       constant number(1)      := 2;
    c_error         constant number(1)      := 1;

    c_ok            constant number(1)      := 0;

--
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
                    )
is

begin

    insert into t_mcres_wrk_audit_move_to_tbs
    (
        id_log,
        procedura,
        livello,
        tbs_dest,
        table_name,
        index_name,
        partition_name,
        subpartition_name,
        sql_code,
        sql_message,
        note,
        dta_ins
    )
    values
    (
        SEQ_MCRES_MOVE_TO_TBS.nextval,
        p_procedura,
        p_livello,
        p_tbs_dest,
        p_table_name,
        p_index_name,
        p_partition_name,
        p_subpartition_name,
        p_sql_code,
        p_sql_message,
        p_note,
        sysdate
    );

    commit;

exception
when others
then
    raise;
end;
--
function fnc_move_not_part_table(
                                    p_table_name    in varchar2,
                                    p_tbs_dest      in varchar2,
                                    p_reb_idxs      in number   default 1
                                ) return number
is
--
--General
    c_procedura       constant  varchar2(30)    :=  'FNC_MOVE_NOT_PART_TABLE';
    v_table_name                varchar2(30)    :=  p_table_name;
    v_tbs_dest                  varchar2(30)    :=  p_tbs_dest;
    v_index_name                varchar2(30);
    v_partition_name            varchar2(30);
    v_subpartition_name         varchar2(30);
    v_note                      varchar2(4000);
    v_stmt                      varchar2(32767);
--

cursor cur_idx( cp_tab varchar2)
is
    select index_name
    from user_indexes
    where 0=0
    and table_name = cp_tab
    and index_type != 'IOT - TOP' --Le Index Organized Tables non necessitano di spostamento della chiave primaria
    and dropped = 'NO';

begin

    v_note := 'move table';
    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_debug,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );

    v_stmt :=   'alter table ' || v_table_name || ' move tablespace ' || v_tbs_dest;

    execute immediate v_stmt;


    if(p_reb_idxs = 1)
    then

        v_tbs_dest  := replace(v_tbs_dest, 'TSD', 'TSI');

        v_note      := 'start rebuilding indexes';
        prc_log (
                    p_procedura         => c_procedura,
                    p_livello           => c_debug,
                    p_tbs_dest          => v_tbs_dest,
                    p_table_name        => v_table_name,
                    p_index_name        => v_index_name,
                    p_partition_name    => v_partition_name,
                    p_subpartition_name => v_subpartition_name,
                    p_sql_code          => sqlcode,
                    p_sql_message       => sqlerrm,
                    p_note              => v_note
                );

        for r in cur_idx (v_table_name)
        loop

            v_index_name    := r.index_name;

            v_note          := 'rebuild index';
            prc_log (
                        p_procedura         => c_procedura,
                        p_livello           => c_debug,
                        p_tbs_dest          => v_tbs_dest,
                        p_table_name        => v_table_name,
                        p_index_name        => v_index_name,
                        p_partition_name    => v_partition_name,
                        p_subpartition_name => v_subpartition_name,
                        p_sql_code          => sqlcode,
                        p_sql_message       => sqlerrm,
                        p_note              => v_note
                    );

            v_stmt := 'alter index ' ||  v_index_name || ' rebuild tablespace ' || v_tbs_dest;

            execute immediate v_stmt;


        end loop;

        v_note      := 'end rebuilding indexes';
        prc_log (
                    p_procedura         => c_procedura,
                    p_livello           => c_debug,
                    p_tbs_dest          => v_tbs_dest,
                    p_table_name        => v_table_name,
                    p_index_name        => v_index_name,
                    p_partition_name    => v_partition_name,
                    p_subpartition_name => v_subpartition_name,
                    p_sql_code          => sqlcode,
                    p_sql_message       => sqlerrm,
                    p_note              => v_note
                );

    end if;

    return c_ok;


exception
when others
then

    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_error,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );
     return sqlcode;

end;
--
function fnc_move_part_table(
                                p_table_name    in varchar2,
                                p_tbs_dest      in varchar2,
                                p_reb_idxs      in number   default 1
                            ) return number
is
--
--General
    c_procedura       constant  varchar2(30)    := 'FNC_MOVE_PART_TABLE';
    v_table_name                varchar2(30)    :=  p_table_name;
    v_tbs_dest                  varchar2(30)    :=  p_tbs_dest;
    v_index_name                varchar2(30);
    v_partition_name            varchar2(30);
    v_subpartition_name         varchar2(30);
    v_note                      varchar2(4000);
    v_stmt                      varchar2(32767);
--

cursor cur_part( cp_tab varchar2)
is
    select partition_name
    from user_tab_partitions
    where table_name = cp_tab;

cursor cur_idx( cp_tab varchar2)
is
    select index_name
    from user_indexes
    where 0=0
    and table_name = cp_tab;

cursor cur_idx_part(cp_idx varchar2)
is
    select partition_name
    from user_ind_partitions
    where 0=0
    and index_name = cp_idx;


begin


    v_note := 'move table';
    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_debug,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );


    v_note      := 'start moving partitions';
    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_debug,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );

    v_note  := 'move partition';
    for r in cur_part (v_table_name)
    loop

        v_partition_name    := r.partition_name;
        prc_log (
                    p_procedura         => c_procedura,
                    p_livello           => c_debug,
                    p_tbs_dest          => v_tbs_dest,
                    p_table_name        => v_table_name,
                    p_index_name        => v_index_name,
                    p_partition_name    => v_partition_name,
                    p_subpartition_name => v_subpartition_name,
                    p_sql_code          => sqlcode,
                    p_sql_message       => sqlerrm,
                    p_note              => v_note
                );

        v_stmt := 'alter table ' ||  v_table_name || ' move partition  ' || v_partition_name || ' tablespace ' || v_tbs_dest;

        execute immediate v_stmt;



    end loop;

    v_partition_name    := null;
    v_note              := 'end moving partitions';
    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_debug,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );

    v_note  := 'modify default attributes for table';
    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_debug,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );
    v_stmt :=   'alter table ' || v_table_name || ' modify default attributes tablespace ' || v_tbs_dest;

    execute immediate v_stmt;


    if(p_reb_idxs = 1)
    then

        v_tbs_dest  := replace(v_tbs_dest, 'TSD', 'TSI');
        v_note      := 'start rebuilding indexes';
        prc_log (
                    p_procedura         => c_procedura,
                    p_livello           => c_debug,
                    p_tbs_dest          => v_tbs_dest,
                    p_table_name        => v_table_name,
                    p_index_name        => v_index_name,
                    p_partition_name    => v_partition_name,
                    p_subpartition_name => v_subpartition_name,
                    p_sql_code          => sqlcode,
                    p_sql_message       => sqlerrm,
                    p_note              => v_note
                );



        for r in cur_idx (v_table_name)
        loop

            v_index_name        := r.index_name;

            v_note      := 'start rebuilding index partitons';
            prc_log (
                        p_procedura         => c_procedura,
                        p_livello           => c_debug,
                        p_tbs_dest          => v_tbs_dest,
                        p_table_name        => v_table_name,
                        p_index_name        => v_index_name,
                        p_partition_name    => v_partition_name,
                        p_subpartition_name => v_subpartition_name,
                        p_sql_code          => sqlcode,
                        p_sql_message       => sqlerrm,
                        p_note              => v_note
                    );

            v_note  := 'move index partitions';
            for s in cur_idx_part(v_index_name)
            loop

                v_partition_name    := s.partition_name;
                prc_log (
                            p_procedura         => c_procedura,
                            p_livello           => c_debug,
                            p_tbs_dest          => v_tbs_dest,
                            p_table_name        => v_table_name,
                            p_index_name        => v_index_name,
                            p_partition_name    => v_partition_name,
                            p_subpartition_name => v_subpartition_name,
                            p_sql_code          => sqlcode,
                            p_sql_message       => sqlerrm,
                            p_note              => v_note
                        );

                v_stmt := 'alter index ' ||  v_index_name || ' rebuild partition ' || v_partition_name || ' tablespace '|| v_tbs_dest;

                execute immediate v_stmt;

            end loop;

            v_partition_name    := null;

            v_note              := 'end rebuilding index partitions';
            prc_log (
                        p_procedura         => c_procedura,
                        p_livello           => c_debug,
                        p_tbs_dest          => v_tbs_dest,
                        p_table_name        => v_table_name,
                        p_index_name        => v_index_name,
                        p_partition_name    => v_partition_name,
                        p_subpartition_name => v_subpartition_name,
                        p_sql_code          => sqlcode,
                        p_sql_message       => sqlerrm,
                        p_note              => v_note
                    );

            v_note  := 'modify default index attributes';
            prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_debug,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );

            v_stmt  := 'alter index ' || v_index_name || ' modify default attributes tablespace ' || v_tbs_dest;

            execute immediate v_stmt;

        end loop;

        v_index_name    := null;

        v_note          := 'end rebuilding indexes';
        prc_log (
                    p_procedura         => c_procedura,
                    p_livello           => c_debug,
                    p_tbs_dest          => v_tbs_dest,
                    p_table_name        => v_table_name,
                    p_index_name        => v_index_name,
                    p_partition_name    => v_partition_name,
                    p_subpartition_name => v_subpartition_name,
                    p_sql_code          => sqlcode,
                    p_sql_message       => sqlerrm,
                    p_note              => v_note
                );

    end if;

    return c_ok;


exception
when others
then

    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_error,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );
     return sqlcode;

end;
--

function fnc_move_subpart_table(
                                    p_table_name    in varchar2,
                                    p_tbs_dest      in varchar2,
                                    p_reb_idxs      in number   default 1
                                ) return number
is
--
--General
    c_procedura       constant  varchar2(30)    :=  'FNC_MOVE_SUBPART_TABLE';
    v_table_name                varchar2(30)    :=  p_table_name;
    v_tbs_dest                  varchar2(30)    :=  p_tbs_dest;
    v_index_name                varchar2(30);
    v_partition_name            varchar2(30);
    v_subpartition_name         varchar2(30);
    v_note                      varchar2(4000);
    v_stmt                      varchar2(32767);
--

cursor cur_part( cp_tab varchar2)
is
    select partition_name
    from user_tab_partitions
    where table_name = cp_tab;


cursor cur_subpart( cp_tab varchar2, cp_part varchar2 )
is
    select subpartition_name
    from user_tab_subpartitions
    where 0=0
    and table_name = cp_tab
    and partition_name = cp_part;

cursor cur_idx( cp_tab varchar2)
is
    select index_name
    from user_indexes
    where table_name = cp_tab;

cursor cur_idx_part (cp_idx varchar2)
is
    select partition_name
    from user_ind_partitions
    where index_name = cp_idx;

cursor cur_idx_subpart (cp_idx varchar2, cp_idx_part varchar2)
is
    select subpartition_name
    from user_ind_subpartitions
    where 0=0
    and index_name = cp_idx
    and partition_name = cp_idx_part;



begin



    v_note := 'move table';
    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_debug,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );



    for r in cur_part (v_table_name)
    loop

        v_partition_name    := r.partition_name;

        v_note := 'start moving partition';
        prc_log (
                    p_procedura         => c_procedura,
                    p_livello           => c_debug,
                    p_tbs_dest          => v_tbs_dest,
                    p_table_name        => v_table_name,
                    p_index_name        => v_index_name,
                    p_partition_name    => v_partition_name,
                    p_subpartition_name => v_subpartition_name,
                    p_sql_code          => sqlcode,
                    p_sql_message       => sqlerrm,
                    p_note              => v_note
                );

        v_note  := 'move subpartition';
        for s in cur_subpart(v_table_name, v_partition_name)
        loop

            v_subpartition_name := s.subpartition_name;

            prc_log (
                    p_procedura         => c_procedura,
                    p_livello           => c_debug,
                    p_tbs_dest          => v_tbs_dest,
                    p_table_name        => v_table_name,
                    p_index_name        => v_index_name,
                    p_partition_name    => v_partition_name,
                    p_subpartition_name => v_subpartition_name,
                    p_sql_code          => sqlcode,
                    p_sql_message       => sqlerrm,
                    p_note              => v_note
                );

            v_stmt := 'alter table ' ||  v_table_name || ' move subpartition  ' || v_subpartition_name || ' tablespace ' || v_tbs_dest;

            execute immediate v_stmt;



        end loop;

        v_subpartition_name := null;

        v_note  := 'modify default partition attributes';
        prc_log (
            p_procedura         => c_procedura,
            p_livello           => c_debug,
            p_tbs_dest          => v_tbs_dest,
            p_table_name        => v_table_name,
            p_index_name        => v_index_name,
            p_partition_name    => v_partition_name,
            p_subpartition_name => v_subpartition_name,
            p_sql_code          => sqlcode,
            p_sql_message       => sqlerrm,
            p_note              => v_note
        );

        v_stmt := 'alter table ' || v_table_name || ' modify default attributes for partition ' || v_partition_name || ' tablespace ' || v_tbs_dest;

        execute immediate v_stmt;


    end loop;

    v_partition_name    := null;

    v_note  := 'modify default attributes for table';
    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_debug,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );
    v_stmt :=   'alter table ' || v_table_name || ' modify default attributes tablespace ' || v_tbs_dest;

    execute immediate v_stmt;



    if(p_reb_idxs = 1)
    then

        v_tbs_dest  := replace(v_tbs_dest, 'TSD', 'TSI');

        for r in cur_idx (v_table_name)
        loop

            v_index_name    := r.index_name;

            v_note          := 'start rebuild indexes';
            prc_log (
                        p_procedura         => c_procedura,
                        p_livello           => c_debug,
                        p_tbs_dest          => v_tbs_dest,
                        p_table_name        => v_table_name,
                        p_index_name        => v_index_name,
                        p_partition_name    => v_partition_name,
                        p_subpartition_name => v_subpartition_name,
                        p_sql_code          => sqlcode,
                        p_sql_message       => sqlerrm,
                        p_note              => v_note
                    );




            for s1 in cur_idx_part(v_index_name)
            loop

                v_partition_name := s1.partition_name;

                v_note := 'start rebuilding  index partitions';
                prc_log (
                        p_procedura         => c_procedura,
                        p_livello           => c_debug,
                        p_tbs_dest          => v_tbs_dest,
                        p_table_name        => v_table_name,
                        p_index_name        => v_index_name,
                        p_partition_name    => v_partition_name,
                        p_subpartition_name => v_subpartition_name,
                        p_sql_code          => sqlcode,
                        p_sql_message       => sqlerrm,
                        p_note              => v_note
                    );


                v_note  := 'move index subpartition';

                for s2 in cur_idx_subpart(v_index_name, v_partition_name)
                loop

                    v_subpartition_name := s2.subpartition_name;

                    prc_log (
                            p_procedura         => c_procedura,
                            p_livello           => c_debug,
                            p_tbs_dest          => v_tbs_dest,
                            p_table_name        => v_table_name,
                            p_index_name        => v_index_name,
                            p_partition_name    => v_partition_name,
                            p_subpartition_name => v_subpartition_name,
                            p_sql_code          => sqlcode,
                            p_sql_message       => sqlerrm,
                            p_note              => v_note
                        );

                    v_stmt := 'alter index ' ||  v_index_name || ' rebuild subpartition  ' || v_subpartition_name || ' tablespace ' || v_tbs_dest;

                    execute immediate v_stmt;

                end loop;

                v_subpartition_name := null;

                v_note  := 'modify default attributes for index partition';
                prc_log (
                        p_procedura         => c_procedura,
                        p_livello           => c_debug,
                        p_tbs_dest          => v_tbs_dest,
                        p_table_name        => v_table_name,
                        p_index_name        => v_index_name,
                        p_partition_name    => v_partition_name,
                        p_subpartition_name => v_subpartition_name,
                        p_sql_code          => sqlcode,
                        p_sql_message       => sqlerrm,
                        p_note              => v_note
                    );


                v_stmt := 'alter index ' || v_index_name || ' modify default attributes for partition ' || v_partition_name || ' tablespace ' || v_tbs_dest;

                execute immediate v_stmt;

            end loop;

            v_partition_name := null;

            v_note := 'end rebuilding index partitions';
            prc_log (
                    p_procedura         => c_procedura,
                    p_livello           => c_debug,
                    p_tbs_dest          => v_tbs_dest,
                    p_table_name        => v_table_name,
                    p_index_name        => v_index_name,
                    p_partition_name    => v_partition_name,
                    p_subpartition_name => v_subpartition_name,
                    p_sql_code          => sqlcode,
                    p_sql_message       => sqlerrm,
                    p_note              => v_note
                );

            v_note  := 'modifying default attributes for index';
            prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_debug,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );

            v_stmt  := 'alter index ' || v_index_name || ' modify default attributes tablespace ' || v_tbs_dest;

            execute immediate v_stmt;

        end loop;

        v_index_name    := null;

        v_note          := 'end rebuilding indexes';
        prc_log (
                    p_procedura         => c_procedura,
                    p_livello           => c_debug,
                    p_tbs_dest          => v_tbs_dest,
                    p_table_name        => v_table_name,
                    p_index_name        => v_index_name,
                    p_partition_name    => v_partition_name,
                    p_subpartition_name => v_subpartition_name,
                    p_sql_code          => sqlcode,
                    p_sql_message       => sqlerrm,
                    p_note              => v_note
                );



    end if;


    return c_ok;


exception
when others
then

    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_error,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );
     return sqlcode;

end;
--

function fnc_mcres_move_mcres_table(
                                p_table_name        in varchar2,
                                p_rebuild_indexes   in number   default 1
                             ) return number
is
--
--General
    c_procedura       constant  varchar2(30)    :=  'FNC_MOVE_TABLE';
    v_table_name                varchar2(30)    :=  p_table_name;
    v_tbs_dest                  varchar2(30);
    v_index_name                varchar2(30);
    v_partition_name            varchar2(30);
    v_subpartition_name         varchar2(30);
    v_note                      varchar2(4000);
    v_stmt                      varchar2(32767);
--

    v_exists                    number(1)       := 0;


begin

    --controllo se la tabella è sottopartizionata
    select count(*)
    into v_exists
    from user_part_tables
    where 0=0
    and subpartitioning_type != 'NONE'
    and table_name = v_table_name;




    if (v_exists = 1)
    then    --tabella sottopartizionata

        if( instr( v_table_name, 'T_MCRES_ST') = 1 )
        then    --tabella sottopartizionata di tipo ST

            v_tbs_dest := 'TSD_MCRES_ST_OWN';

            return fnc_move_subpart_table(v_table_name, v_tbs_dest, p_rebuild_indexes);

         else   --tabella sottopartizionata di tipo non ST

            v_tbs_dest := 'TSD_MCRES_OWN';

            return fnc_move_subpart_table(v_table_name, v_tbs_dest, p_rebuild_indexes);

        end if;

    else --tabella non sottopartizionata

        --controllo se la tabella è partizionata
        select count(*)
        into v_exists
        from user_part_tables
        where 0=0
        and subpartitioning_type = 'NONE'
        and table_name = v_table_name;

        if( v_exists = 1)
        then    --tabella partizionata

            if(instr( v_table_name, 'T_MCRES_ST') = 1)
            then    --tabella partizionata di tipo ST

                v_tbs_dest := 'TSD_MCRES_ST_OWN';

                return fnc_move_part_table(v_table_name, v_tbs_dest, p_rebuild_indexes);

            else   --tabella partizionata di tipo non ST

                v_tbs_dest := 'TSD_MCRES_OWN';

                return fnc_move_part_table(v_table_name, v_tbs_dest, p_rebuild_indexes);

            end if;

        else    --tabella non partizionata

            select count(*)
            into v_exists
            from
            (
                select table_name
                from user_tables
                minus
                select table_name
                from user_external_tables
             )
             where table_name = v_table_name;


             if( v_exists = 1)
             then

                if(instr( v_table_name, 'T_MCRES_ST') = 1 )
                then    --tabella partizionata di tipo ST

                    v_tbs_dest := 'TSD_MCRES_ST_OWN';

                    return fnc_move_not_part_table(v_table_name, v_tbs_dest, p_rebuild_indexes);

                else   --tabella partizionata di tipo non ST

                    v_tbs_dest := 'TSD_MCRES_OWN';

                    return fnc_move_not_part_table(v_table_name, v_tbs_dest, p_rebuild_indexes);

                end if;

             end if;

        end if;

    end if;

    v_note := 'unable to move table ' || v_table_name;
    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_debug,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );

    return c_warning;


exception
when others
then

    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_error,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );
     return sqlcode;

end;

--
procedure prc_mcres_move_all(p_rebuild_indexes in number default 1)
is
--
--General
    c_procedura       constant  varchar2(30)    :=  'PRC_MCRES_MOVE_ALL';
    v_table_name                varchar2(30);
    v_tbs_dest                  varchar2(30);
    v_index_name                varchar2(30);
    v_partition_name            varchar2(30);
    v_subpartition_name         varchar2(30);
    v_note                      varchar2(4000);
    v_stmt                      varchar2(32767);
--
    v_ret   number  := 0;

cursor c_tab
is

   select table_name
   from user_tables
   where table_name like '%MCRES%'
   minus
   select table_name
   from user_external_tables;



begin

    for r in c_tab
    loop

        v_table_name    := r.table_name;

        v_ret           := fnc_mcres_move_mcres_table(v_table_name, p_rebuild_indexes);

        if(v_ret = c_ok)
        then

            v_note := 'table successfully moved';
            prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_debug,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );

        else

            v_note := 'table moving failed';
            prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_warning,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => v_ret,
                p_sql_message       => null,
                p_note              => v_note
            );

        end if;

    end loop;


exception
when others
then

    prc_log (
                p_procedura         => c_procedura,
                p_livello           => c_error,
                p_tbs_dest          => v_tbs_dest,
                p_table_name        => v_table_name,
                p_index_name        => v_index_name,
                p_partition_name    => v_partition_name,
                p_subpartition_name => v_subpartition_name,
                p_sql_code          => sqlcode,
                p_sql_message       => sqlerrm,
                p_note              => v_note
            );

end;

end pkg_mcres_move_to_tbs;
/


CREATE SYNONYM MCRE_APP.PKG_MCRES_MOVE_TO_TBS FOR MCRE_OWN.PKG_MCRES_MOVE_TO_TBS;


CREATE SYNONYM MCRE_USR.PKG_MCRES_MOVE_TO_TBS FOR MCRE_OWN.PKG_MCRES_MOVE_TO_TBS;


GRANT EXECUTE, DEBUG ON MCRE_OWN.PKG_MCRES_MOVE_TO_TBS TO MCRE_USR;

