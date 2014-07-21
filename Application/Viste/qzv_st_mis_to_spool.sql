/* Formatted on 21/07/2014 18:30:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_TO_SPOOL
(
   LINE
)
AS
   SELECT /************************************************************************************
             PURPOSE      vista dalla quale fare lo spool per la produzione del flusso
                          QZmcreMCREGRMONINCSOFF.TXT da inviare al QdC per alimentare
                          l'area MIS (Monitoraggio Incagli, Sofferenze, Ristruturati)
                          con flusso giornaliero


             REVISIONS
             Ver        Date              Author                     Description
             ---------  ----------      -----------------  ------------------------------------
             1.0        15/05/2012      Andrea Galliano         Created this view
             1.1    05/03/2013   Daniela Manni     Modificata select per QZE_FL_MIS_ABI
          ************************************************************************************/
                                                                            --
                                                     -- QZE_FL_MIS_MON_INC_SOF
                                                                            --
           '000'
        || '~'
        || cod_src
        || '~'
        || id_dper
        || '~'
        || dta_competenza
        || '~'
        || cod_stato_rischio
        || '~'
        || des_stato_rischio
        || '~'
        || TO_CHAR (dta_inizio_stato, 'yyyymmdd')
        || '~'
        || TO_CHAR (dta_fine_stato, 'yyyymmdd')
        || '~'
        || cod_abi
        || '~'
        || cod_ndg
        || '~'
        || cod_cli_ge
        || '~'
        || cod_sndg
        || '~'
        || cod_gruppo_economico
        || '~'
        || cod_filiale
        || '~'
        || cod_presidio
        || '~'
        || cod_gestione
        || '~'
        || cod_area_business
        || '~'
        || cod_stato_giuridico
        || '~'
        || cod_forma_tecnica
        || '~'
        || cod_firma
        || '~'
        || cod_segm_irb
        || '~'
        || val_vant
        || '~'
        || val_gbv
        || '~'
        || val_nbv
        || '~'
        || val_tot_incassi
        || '~'
        || val_garanzie_reali_personali
        || '~'
        || val_garanzie_reali
        || '~'
        || val_garanzie_ipotecarie
        || '~'
        || val_garanzie_pignoratizie
        || '~'
        || val_garanzie_personali
        || '~'
        || val_garanzie_altre_altri
        || '~'
        || val_garanzie_altre
        || '~'
        || val_garanzie_altri
        || '~'
        || val_rip_mora
        || '~'
        || val_per_ce
        || '~'
        || val_quota_sval
        || '~'
        || val_quota_att
        || '~'
        || val_rett_sval
        || '~'
        || val_rip_sval
        || '~'
        || val_rett_att
        || '~'
        || val_rip_att
        || '~'
        || val_attualizzazione
        || '~'
        || val_mov_cnt
        || '~'
        || des_mov_cnt
        || '~'
        || flg_ndg
        || '~'
        || flg_nuovo_ingresso
        || '~'
        || flg_portafoglio
        || '~'
        || flg_cessione_routinaria
        || '~'
        || flg_chiusura
        || '~'
        || flg_garanzie_reali_personali
        || '~'
        || flg_garanzie_reali
        || '~'
        || flg_garanzie_ipotecarie
        || '~'
        || flg_garanzie_pignoratizie
        || '~'
        || flg_garanzie_personali
        || '~'
        || flg_garanzie_altre_altri
        || '~'
        || flg_garanzie_altre
        || '~'
        || flg_garanzie_altri
        || '~'
        || flg_cmp_drc
        || '~'
        || flg_firma
           line
   FROM mcre_own.qzt_ft_mis_mon_inc_sof
   UNION ALL
   --
   -- QZE_FL_MIS_ABI_NDG
   --
   SELECT '001' || '~' || cod_abi || '~' || cod_ndg
     FROM (SELECT DISTINCT cod_abi, cod_ndg
             FROM mcre_own.qzt_ft_mis_mon_inc_sof
            WHERE cod_ndg != '#')
   UNION ALL
   --
   -- QZE_FL_MIS_ABI
   --
   SELECT    '002'
          || '~'
          || cod_abi
          || '~'
          || ord_abi
          || '~'
          || des_istituto
          || '~'
          || des_breve
          || '~'
          || ord_tipo_abi
          || '~'
          || des_tipo_abi
          || '~'
          || flg_outsourcing
          || '~'
          || flg_outsourcing_drc
          || '~'
          || flg_target
     FROM mcre_own.qzt_st_mis_abi
   UNION ALL
   --
   -- QZE_FL_MIS_CLI
   --
   SELECT '003' || '~' || cod_cli_ge || '~' || des_cli_ge
     FROM mcre_own.qzt_st_mis_cli
   UNION ALL
   --
   -- QZE_FL_MIS_GES
   --
   SELECT    '004'
          || '~'
          || cod_gestione
          || '~'
          || ord_gestione
          || '~'
          || des_gestione
          || '~'
          || tipo_gestione
          || '~'
          || cod_abi
          || '~'
          || cod_presidio
          || '~'
          || des_presidio
          || '~'
          || tipo_presidio
          || '~'
          || cod_tipo
          || '~'
          || cod_macrogestione
     FROM mcre_own.qzt_st_mis_gst
   UNION ALL
   --
   -- QZE_FL_MIS_GES
   --
   SELECT    '005'
          || '~'
          || cod_stato_giuridico
          || '~'
          || ord_stato_giuridico
          || '~'
          || des_stato_giuridico
          || '~'
          || des_short_stato_giuridico
     FROM mcre_own.qzt_st_mis_stg;
