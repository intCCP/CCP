/* Formatted on 17/06/2014 18:15:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_GEST_MONITORAGGIO
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DTA_CONTROLLO_AT,
   VAL_STRATEGIA_CREDITIZIA_AT,
   VAL_PD_ONLINE_AT,
   VAL_PD_MONIT_AT,
   DTA_PD_MONIT_AT,
   VAL_IRIS_CLI_AT,
   VAL_LGD_AT,
   VAL_EAD_AT,
   VAL_SB_ACC_TOT_AT,
   VAL_SB_UTI_TOT_AT,
   VAL_GB_ACC_TOT_AT,
   VAL_GB_UTI_TOT_AT,
   VAL_SB_ACC_CASSA_BT_AT,
   VAL_SB_UTI_CASSA_BT_AT,
   VAL_GB_ACC_CASSA_BT_AT,
   VAL_GB_UTI_CASSA_BT_AT,
   VAL_SB_SCONFINO_AT,
   VAL_SB_QIS_ACC_AT,
   VAL_SB_QIS_UTI_AT,
   VAL_GB_QIS_ACC_AT,
   VAL_GB_QIS_UTI_AT,
   VAL_PA_AT,
   COD_STATO_1,
   DTA_CONTROLLO_1,
   VAL_STRATEGIA_CREDITIZIA_1,
   VAL_PD_ONLINE_1,
   VAL_PD_MONIT_1,
   DTA_PD_MONIT_1,
   VAL_RATING_1,
   VAL_IRIS_CLI_1,
   VAL_LGD_1,
   VAL_EAD_1,
   VAL_SB_ACC_TOT_1,
   VAL_SB_UTI_TOT_1,
   VAL_GB_ACC_TOT_1,
   VAL_GB_UTI_TOT_1,
   VAL_SB_ACC_CASSA_BT_1,
   VAL_SB_UTI_CASSA_BT_1,
   VAL_GB_ACC_CASSA_BT_1,
   VAL_GB_UTI_CASSA_BT_1,
   VAL_SB_QIS_ACC_1,
   VAL_SB_QIS_UTI_1,
   VAL_GB_QIS_ACC_1,
   VAL_GB_QIS_UTI_1,
   VAL_SB_SCONFINO_1,
   VAL_PA_1,
   COD_STATO_2,
   DTA_CONTROLLO_2,
   VAL_STRATEGIA_CREDITIZIA_2,
   VAL_PD_ONLINE_2,
   VAL_PD_MONIT_2,
   DTA_PD_MONIT_2,
   VAL_RATING_2,
   VAL_IRIS_CLI_2,
   VAL_LGD_2,
   VAL_EAD_2,
   VAL_SB_ACC_TOT_2,
   VAL_SB_UTI_TOT_2,
   VAL_GB_ACC_TOT_2,
   VAL_GB_UTI_TOT_2,
   VAL_SB_ACC_CASSA_BT_2,
   VAL_SB_UTI_CASSA_BT_2,
   VAL_GB_ACC_CASSA_BT_2,
   VAL_GB_UTI_CASSA_BT_2,
   VAL_SB_QIS_ACC_2,
   VAL_SB_QIS_UTI_2,
   VAL_GB_QIS_ACC_2,
   VAL_GB_QIS_UTI_2,
   VAL_SB_SCONFINO_2,
   VAL_PA_2,
   COD_STATO_3,
   DTA_CONTROLLO_3,
   VAL_STRATEGIA_CREDITIZIA_3,
   VAL_PD_ONLINE_3,
   VAL_PD_MONIT_3,
   DTA_PD_MONIT_3,
   VAL_RATING_3,
   VAL_IRIS_CLI_3,
   VAL_LGD_3,
   VAL_EAD_3,
   VAL_SB_ACC_TOT_3,
   VAL_SB_UTI_TOT_3,
   VAL_GB_ACC_TOT_3,
   VAL_GB_UTI_TOT_3,
   VAL_SB_ACC_CASSA_BT_3,
   VAL_SB_UTI_CASSA_BT_3,
   VAL_GB_ACC_CASSA_BT_3,
   VAL_GB_UTI_CASSA_BT_3,
   VAL_SB_QIS_ACC_3,
   VAL_SB_QIS_UTI_3,
   VAL_GB_QIS_ACC_3,
   VAL_GB_QIS_UTI_3,
   VAL_SB_SCONFINO_3,
   VAL_PA_3,
   COD_STATO_4,
   DTA_CONTROLLO_4,
   VAL_STRATEGIA_CREDITIZIA_4,
   VAL_PD_ONLINE_4,
   VAL_PD_MONIT_4,
   DTA_PD_MONIT_4,
   VAL_RATING_4,
   VAL_IRIS_CLI_4,
   VAL_LGD_4,
   VAL_EAD_4,
   VAL_SB_ACC_TOT_4,
   VAL_SB_UTI_TOT_4,
   VAL_GB_ACC_TOT_4,
   VAL_GB_UTI_TOT_4,
   VAL_SB_ACC_CASSA_BT_4,
   VAL_SB_UTI_CASSA_BT_4,
   VAL_GB_ACC_CASSA_BT_4,
   VAL_GB_UTI_CASSA_BT_4,
   VAL_SB_QIS_ACC_4,
   VAL_SB_QIS_UTI_4,
   VAL_GB_QIS_ACC_4,
   VAL_GB_QIS_UTI_4,
   VAL_SB_SCONFINO_4,
   VAL_PA_4,
   COD_STATO_5,
   DTA_CONTROLLO_5,
   VAL_STRATEGIA_CREDITIZIA_5,
   VAL_PD_ONLINE_5,
   VAL_PD_MONIT_5,
   DTA_PD_MONIT_5,
   VAL_RATING_5,
   VAL_IRIS_CLI_5,
   VAL_LGD_5,
   VAL_EAD_5,
   VAL_SB_ACC_TOT_5,
   VAL_SB_UTI_TOT_5,
   VAL_GB_ACC_TOT_5,
   VAL_GB_UTI_TOT_5,
   VAL_SB_ACC_CASSA_BT_5,
   VAL_SB_UTI_CASSA_BT_5,
   VAL_GB_ACC_CASSA_BT_5,
   VAL_GB_UTI_CASSA_BT_5,
   VAL_SB_QIS_ACC_5,
   VAL_SB_QIS_UTI_5,
   VAL_GB_QIS_ACC_5,
   VAL_GB_QIS_UTI_5,
   VAL_SB_SCONFINO_5,
   VAL_PA_5,
   COD_STATO_6,
   DTA_CONTROLLO_6,
   VAL_STRATEGIA_CREDITIZIA_6,
   VAL_PD_ONLINE_6,
   VAL_PD_MONIT_6,
   DTA_PD_MONIT_6,
   VAL_RATING_6,
   VAL_IRIS_CLI_6,
   VAL_LGD_6,
   VAL_EAD_6,
   VAL_SB_ACC_TOT_6,
   VAL_SB_UTI_TOT_6,
   VAL_GB_ACC_TOT_6,
   VAL_GB_UTI_TOT_6,
   VAL_SB_ACC_CASSA_BT_6,
   VAL_SB_UTI_CASSA_BT_6,
   VAL_GB_ACC_CASSA_BT_6,
   VAL_GB_UTI_CASSA_BT_6,
   VAL_SB_QIS_ACC_6,
   VAL_SB_QIS_UTI_6,
   VAL_GB_QIS_ACC_6,
   VAL_GB_QIS_UTI_6,
   VAL_SB_SCONFINO_6,
   VAL_PA_6,
   COD_STATO_AT,
   DTA_CONTROLLO_PC,
   COD_STATO_PC,
   VAL_STRATEGIA_CREDITIZIA_PC,
   VAL_PD_ONLINE_PC,
   VAL_PD_MONIT_PC,
   DTA_PD_MONIT_PC,
   VAL_RATING_PC,
   VAL_IRIS_CLI_PC,
   VAL_LGD_PC,
   VAL_EAD_PC,
   VAL_SB_ACC_TOT_PC,
   VAL_SB_UTI_TOT_PC,
   VAL_GB_ACC_TOT_PC,
   VAL_GB_UTI_TOT_PC,
   VAL_SB_ACC_CASSA_BT_PC,
   VAL_SB_UTI_CASSA_BT_PC,
   VAL_GB_ACC_CASSA_BT_PC,
   VAL_GB_UTI_CASSA_BT_PC,
   VAL_SB_QIS_ACC_PC,
   VAL_SB_QIS_UTI_PC,
   VAL_GB_QIS_ACC_PC,
   VAL_GB_QIS_UTI_PC,
   VAL_SB_SCONFINO_PC,
   VAL_PA_PC,
   VAL_PA_VS_PC_AT,
   VAL_PA_VS_PC_1,
   VAL_PA_VS_PC_2,
   VAL_PA_VS_PC_3,
   VAL_PA_VS_PC_4,
   VAL_PA_VS_PC_5,
   VAL_DELTA_PA_VS_PC_AT,
   VAL_DELTA_PA_VS_PC_1,
   VAL_DELTA_PA_VS_PC_2,
   VAL_DELTA_PA_VS_PC_3,
   VAL_DELTA_PA_VS_PC_4,
   VAL_DELTA_PA_VS_PC_5,
   VAL_DELTA_AT_VS_PC1,
   VAL_DELTA_PC1_VS_PC2,
   VAL_DELTA_PC2_VS_PC3,
   VAL_DELTA_PC3_VS_PC4,
   VAL_DELTA_PC4_VS_PC5,
   VAL_DELTA_PC5_VS_PC6,
   VAL_GB_SCONFINO_PC,
   VAL_GB_SCONFINO_AT,
   VAL_GB_SCONFINO_1,
   VAL_GB_SCONFINO_2,
   VAL_GB_SCONFINO_3,
   VAL_GB_SCONFINO_4,
   VAL_GB_SCONFINO_5
)
AS
   SELECT d.cod_abi_cartolarizzato,
          d.cod_abi_istituto,
          d.desc_istituto,
          d.cod_ndg,
          d.cod_sndg,
          d.dta_controllo_at,
          d.val_strategia_creditizia_at,
          d.val_pd_online_at,
          d.val_pd_monit_at,
          d.dta_pd_monit_at,
          d.val_iris_cli_at,
          d.val_lgd_at,
          d.val_ead_at,
          d.scsb_acc_tot_at,
          d.scsb_uti_tot_at,
          d.scgb_acc_tot_at,
          d.scgb_uti_tot_at,
          d.scsb_acc_cassa_bt_at,
          d.scsb_uti_cassa_bt_at,
          d.scgb_acc_cassa_bt_at,
          d.scgb_uti_cassa_bt_at,
          d.scsb_qis_acc_at,
          d.scsb_qis_uti_at,
          d.scgb_qis_acc_at,
          d.scgb_qis_uti_at,
          d.scsb_sconfino_at,
          d.val_pa_at,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, NULL,
                  d.cod_stato_1)
             cod_stato_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_DATE (NULL),
                  d.dta_controllo_1)
             dta_controllo_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, NULL,
                  d.val_strategia_creditizia_1)
             val_strategia_creditizia_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.val_pd_online_1)
             val_pd_online_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.val_pd_monit_1)
             val_pd_monit_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_DATE (NULL),
                  d.dta_pd_monit_1)
             dta_pd_monit_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, NULL,
                  d.val_rating_1)
             val_rating_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (TO_NUMBER (NULL)),
                  d.val_iris_cli_1)
             val_iris_cli_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.val_lgd_1)
             val_lgd_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.val_ead_1)
             val_ead_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_tot_1)
             scsb_acc_tot_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_tot_1)
             scsb_uti_tot_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_tot_1)
             scgb_acc_tot_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_tot_1)
             scgb_uti_tot_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_bt_1)
             scsb_acc_cassa_bt_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_bt_1)
             scsb_uti_cassa_bt_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_bt_1)
             scgb_acc_cassa_bt_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_bt_1)
             scgb_uti_cassa_bt_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_acc_1)
             scsb_qis_acc_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_uti_1)
             scsb_qis_uti_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_acc_1)
             scgb_qis_acc_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_uti_1)
             scgb_qis_uti_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_sconfino_1)
             scsb_sconfino_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.val_pa_1)
             val_pa_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, NULL,
                  d.cod_stato_2)
             cod_stato_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_DATE (NULL),
                  d.dta_controllo_2)
             dta_controllo_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, NULL,
                  d.val_strategia_creditizia_2)
             val_strategia_creditizia_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.val_pd_online_2)
             val_pd_online_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.val_pd_monit_2)
             val_pd_monit_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_DATE (NULL),
                  d.dta_pd_monit_2)
             dta_pd_monit_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, NULL,
                  d.val_rating_2)
             val_rating_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.val_iris_cli_2)
             val_iris_cli_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.val_lgd_2)
             val_lgd_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.val_ead_2)
             val_ead_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_tot_2)
             scsb_acc_tot_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_tot_2)
             scsb_uti_tot_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_tot_2)
             scgb_acc_tot_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_tot_2)
             scgb_uti_tot_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_bt_2)
             scsb_acc_cassa_bt_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_bt_2)
             scsb_uti_cassa_bt_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_bt_2)
             scgb_acc_cassa_bt_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_bt_2)
             scgb_uti_cassa_bt_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_acc_2)
             scsb_qis_acc_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_uti_2)
             scsb_qis_uti_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_acc_2)
             scgb_qis_acc_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_uti_2)
             scgb_qis_uti_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_sconfino_2)
             scsb_sconfino_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.val_pa_2)
             val_pa_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, NULL,
                  d.cod_stato_3)
             cod_stato_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_DATE (NULL),
                  d.dta_controllo_3)
             dta_controllo_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, NULL,
                  d.val_strategia_creditizia_3)
             val_strategia_creditizia_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.val_pd_online_3)
             val_pd_online_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.val_pd_monit_3)
             val_pd_monit_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_DATE (NULL),
                  d.dta_pd_monit_3)
             dta_pd_monit_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, NULL,
                  d.val_rating_3)
             val_rating_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.val_iris_cli_3)
             val_iris_cli_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.val_lgd_3)
             val_lgd_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.val_ead_3)
             val_ead_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_tot_3)
             scsb_acc_tot_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_tot_3)
             scsb_uti_tot_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_tot_3)
             scgb_acc_tot_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_tot_3)
             scgb_uti_tot_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_bt_3)
             scsb_acc_cassa_bt_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_bt_3)
             scsb_uti_cassa_bt_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_bt_3)
             scgb_acc_cassa_bt_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_bt_3)
             scgb_uti_cassa_bt_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_acc_3)
             scsb_qis_acc_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_uti_3)
             scsb_qis_uti_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_acc_3)
             scgb_qis_acc_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_uti_3)
             scgb_qis_uti_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_sconfino_3)
             scsb_sconfino_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.val_pa_3)
             val_pa_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, NULL,
                  d.cod_stato_4)
             cod_stato_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_DATE (NULL),
                  d.dta_controllo_4)
             dta_controllo_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, NULL,
                  d.val_strategia_creditizia_4)
             val_strategia_creditizia_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.val_pd_online_4)
             val_pd_online_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.val_pd_monit_4)
             val_pd_monit_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_DATE (NULL),
                  d.dta_pd_monit_4)
             dta_pd_monit_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, NULL,
                  d.val_rating_4)
             val_rating_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.val_iris_cli_4)
             val_iris_cli_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.val_lgd_4)
             val_lgd_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.val_ead_4)
             val_ead_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_tot_4)
             scsb_acc_tot_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_tot_4)
             scsb_uti_tot_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_tot_4)
             scgb_acc_tot_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_tot_4)
             scgb_uti_tot_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_bt_4)
             scsb_acc_cassa_bt_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_bt_4)
             scsb_uti_cassa_bt_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_bt_4)
             scgb_acc_cassa_bt_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_bt_4)
             scgb_uti_cassa_bt_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_acc_4)
             scsb_qis_acc_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_uti_4)
             scsb_qis_uti_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_acc_4)
             scgb_qis_acc_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_uti_4)
             scgb_qis_uti_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_sconfino_4)
             scsb_sconfino_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.val_pa_4)
             val_pa_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, NULL,
                  d.cod_stato_5)
             cod_stato_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_DATE (NULL),
                  d.dta_controllo_5)
             dta_controllo_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, NULL,
                  d.val_strategia_creditizia_5)
             val_strategia_creditizia_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.val_pd_online_5)
             val_pd_online_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.val_pd_monit_5)
             val_pd_monit_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_DATE (NULL),
                  d.dta_pd_monit_5)
             dta_pd_monit_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, NULL,
                  d.val_rating_5)
             val_rating_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.val_iris_cli_5)
             val_iris_cli_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.val_lgd_5)
             val_lgd_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.val_ead_5)
             val_ead_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_tot_5)
             scsb_acc_tot_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_tot_5)
             scsb_uti_tot_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_tot_5)
             scgb_acc_tot_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_tot_5)
             scgb_uti_tot_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_bt_5)
             scsb_acc_cassa_bt_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_bt_5)
             scsb_uti_cassa_bt_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_bt_5)
             scgb_acc_cassa_bt_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_bt_5)
             scgb_uti_cassa_bt_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_acc_5)
             scsb_qis_acc_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_uti_5)
             scsb_qis_uti_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_acc_5)
             scgb_qis_acc_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_uti_5)
             scgb_qis_uti_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_sconfino_5)
             scsb_sconfino_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.val_pa_5)
             val_pa_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, NULL,
                  d.cod_stato_6)
             cod_stato_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_DATE (NULL),
                  d.dta_controllo_6)
             dta_controllo_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, NULL,
                  d.val_strategia_creditizia_6)
             val_strategia_creditizia_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.val_pd_online_6)
             val_pd_online_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.val_pd_monit_6)
             val_pd_monit_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_DATE (NULL),
                  d.dta_pd_monit_6)
             dta_pd_monit_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, NULL,
                  d.val_rating_6)
             val_rating_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.val_iris_cli_6)
             val_iris_cli_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.val_lgd_6)
             val_lgd_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.val_ead_6)
             val_ead_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_tot_6)
             scsb_acc_tot_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_tot_6)
             scsb_uti_tot_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_tot_6)
             scgb_acc_tot_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_tot_6)
             scgb_uti_tot_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_bt_6)
             scsb_acc_cassa_bt_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_bt_6)
             scsb_uti_cassa_bt_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_bt_6)
             scgb_acc_cassa_bt_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_bt_6)
             scgb_uti_cassa_bt_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_acc_6)
             scsb_qis_acc_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_uti_6)
             scsb_qis_uti_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_acc_6)
             scgb_qis_acc_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_uti_6)
             scgb_qis_uti_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_sconfino_6)
             scsb_sconfino_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.val_pa_6)
             val_pa_6,
          x.cod_stato cod_stato_at,
          f.dta_fine_validita_rc dta_controllo_pc,
          f.cod_stato cod_stato_pc,
          f.cod_strategia_crz val_strategia_creditizia_pc,
          f.val_pd_online val_pd_online_pc,
          f.val_pd val_pd_monit_pc,
          f.dta_pd dta_pd_monit_pc,
          f.val_rating val_rating_pc,
          f.val_iris_cli val_iris_cli_pc,
          f.val_lgd val_lgd_pc,
          f.val_ead val_ead_pc,
          f.scsb_acc_cassa + f.scsb_acc_firma scsb_acc_tot_pc,
          f.scsb_uti_cassa + f.scsb_uti_firma scsb_uti_tot_pc,
          f.scgb_acc_cassa + f.scgb_acc_firma scgb_acc_tot_pc,
          f.scgb_uti_cassa + f.scgb_uti_firma scgb_uti_tot_pc,
          f.scsb_acc_cassa_bt scsb_acc_cassa_bt_pc,
          f.scsb_uti_cassa_bt scsb_uti_cassa_bt_pc,
          f.scgb_acc_cassa_bt scgb_acc_cassa_bt_pc,
          f.scgb_uti_cassa_bt scgb_uti_cassa_bt_pc,
          TO_NUMBER (NULLIF (f.scsb_qis_acc, 'N.D.')) scsb_qis_acc_pc,
          TO_NUMBER (NULLIF (f.scsb_qis_uti, 'N.D.')) scsb_qis_uti_pc,
          TO_NUMBER (NULLIF (f.scgb_qis_acc, 'N.D.')) scgb_qis_acc_pc,
          TO_NUMBER (NULLIF (f.scgb_qis_uti, 'N.D.')) scgb_qis_uti_pc,
          f.val_sconfino scsb_sconfino_pc,
          f.val_pa val_pa_pc,
          DECODE (
             val_pa_at,
             0, 'ND',
             TO_CHAR (ROUND ( (f.val_pa / val_pa_at) * 100, 2),
                      99999999990.99))
             val_pa_vs_pc_at,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                     1, TO_NUMBER (NULL),
                     d.val_pa_1),
             0, 'ND',
             TO_CHAR (
                ROUND (
                     (  f.val_pa
                      / DECODE (
                           SIGN (f.dta_fine_validita - d.dta_controllo_1),
                           1, TO_NUMBER (NULL),
                           d.val_pa_1))
                   * 100,
                   2),
                99999999990.99))
             val_pa_vs_pc_1,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                     1, TO_NUMBER (NULL),
                     d.val_pa_2),
             0, 'ND',
             TO_CHAR (
                ROUND (
                     (  f.val_pa
                      / DECODE (
                           SIGN (f.dta_fine_validita - d.dta_controllo_2),
                           1, TO_NUMBER (NULL),
                           d.val_pa_2))
                   * 100,
                   2),
                99999999990.99))
             val_pa_vs_pc_2,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                     1, TO_NUMBER (NULL),
                     d.val_pa_3),
             0, 'ND',
             TO_CHAR (
                ROUND (
                     (  f.val_pa
                      / DECODE (
                           SIGN (f.dta_fine_validita - d.dta_controllo_3),
                           1, TO_NUMBER (NULL),
                           d.val_pa_3))
                   * 100,
                   2),
                99999999990.99))
             val_pa_vs_pc_3,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                     1, TO_NUMBER (NULL),
                     d.val_pa_4),
             0, 'ND',
             TO_CHAR (
                ROUND (
                     (  f.val_pa
                      / DECODE (
                           SIGN (f.dta_fine_validita - d.dta_controllo_4),
                           1, TO_NUMBER (NULL),
                           d.val_pa_4))
                   * 100,
                   2),
                99999999990.99))
             val_pa_vs_pc_4,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                     1, TO_NUMBER (NULL),
                     d.val_pa_5),
             0, 'ND',
             TO_CHAR (
                ROUND (
                     (  f.val_pa
                      / DECODE (
                           SIGN (f.dta_fine_validita - d.dta_controllo_5),
                           1, TO_NUMBER (NULL),
                           d.val_pa_5))
                   * 100,
                   2),
                99999999990.99))
             val_pa_vs_pc_5,
          DECODE (
             val_pa_at,
             0, 'ND',
             TO_CHAR (ROUND ( (100 - ( (f.val_pa / val_pa_at)) * 100), 2),
                      99999999990.99))
             val_delta_pa_vs_pc_at,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                     1, TO_NUMBER (NULL),
                     d.val_pa_1),
             0, 'ND',
             TO_CHAR (
                ROUND (
                   (  100
                    -   ( (  f.val_pa
                           / DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_1),
                                1, TO_NUMBER (NULL),
                                d.val_pa_1)))
                      * 100),
                   2),
                99999999990.99))
             val_delta_pa_vs_pc_1,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                     1, TO_NUMBER (NULL),
                     d.val_pa_2),
             0, 'ND',
             TO_CHAR (
                ROUND (
                   (  100
                    -   ( (  f.val_pa
                           / DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_2),
                                1, TO_NUMBER (NULL),
                                d.val_pa_2)))
                      * 100),
                   2),
                99999999990.99))
             val_delta_pa_vs_pc_2,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                     1, TO_NUMBER (NULL),
                     d.val_pa_3),
             0, 'ND',
             TO_CHAR (
                ROUND (
                   (  100
                    -   ( (  f.val_pa
                           / DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_3),
                                1, TO_NUMBER (NULL),
                                d.val_pa_3)))
                      * 100),
                   2),
                99999999990.99))
             val_delta_pa_vs_pc_3,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                     1, TO_NUMBER (NULL),
                     d.val_pa_4),
             0, 'ND',
             TO_CHAR (
                ROUND (
                   (  100
                    -   ( (  f.val_pa
                           / DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_4),
                                1, TO_NUMBER (NULL),
                                d.val_pa_4)))
                      * 100),
                   2),
                99999999990.99))
             val_delta_pa_vs_pc_4,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                     1, TO_NUMBER (NULL),
                     d.val_pa_5),
             0, 'ND',
             TO_CHAR (
                ROUND (
                   (  100
                    -   ( (  f.val_pa
                           / DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_5),
                                1, TO_NUMBER (NULL),
                                d.val_pa_5)))
                      * 100),
                   2),
                99999999990.99))
             val_delta_pa_vs_pc_5,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                     1, TO_NUMBER (NULL),
                     d.val_pa_1),
             0, 'ND',
             TO_CHAR (
                ROUND (
                   (  100
                    -   ( (  val_pa_at
                           / DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_1),
                                1, TO_NUMBER (NULL),
                                d.val_pa_1)))
                      * 100),
                   2),
                99999999990.99))
             val_delta_at_vs_pc1,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                     1, TO_NUMBER (NULL),
                     d.val_pa_2),
             0, 'ND',
             TO_CHAR (
                ROUND (
                   (  100
                    -   ( (  DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_1),
                                1, TO_NUMBER (NULL),
                                d.val_pa_1)
                           / DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_2),
                                1, TO_NUMBER (NULL),
                                d.val_pa_2)))
                      * 100),
                   2),
                99999999990.99))
             val_delta_pc1_vs_pc2,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                     1, TO_NUMBER (NULL),
                     d.val_pa_3),
             0, 'ND',
             TO_CHAR (
                ROUND (
                   (  100
                    -   ( (  DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_2),
                                1, TO_NUMBER (NULL),
                                d.val_pa_2)
                           / DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_3),
                                1, TO_NUMBER (NULL),
                                d.val_pa_3)))
                      * 100),
                   2),
                99999999990.99))
             val_delta_pc2_vs_pc3,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                     1, TO_NUMBER (NULL),
                     d.val_pa_4),
             0, 'ND',
             TO_CHAR (
                ROUND (
                   (  100
                    -   ( (  DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_3),
                                1, TO_NUMBER (NULL),
                                d.val_pa_3)
                           / DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_4),
                                1, TO_NUMBER (NULL),
                                d.val_pa_4)))
                      * 100),
                   2),
                99999999990.99))
             val_delta_pc3_vs_pc4,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                     1, TO_NUMBER (NULL),
                     d.val_pa_5),
             0, 'ND',
             TO_CHAR (
                ROUND (
                   (  100
                    -   ( (  DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_4),
                                1, TO_NUMBER (NULL),
                                d.val_pa_4)
                           / DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_5),
                                1, TO_NUMBER (NULL),
                                d.val_pa_5)))
                      * 100),
                   2),
                99999999990.99))
             val_delta_pc4_vs_pc5,
          DECODE (
             DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                     1, TO_NUMBER (NULL),
                     d.val_pa_6),
             0, 'ND',
             TO_CHAR (
                ROUND (
                   (  100
                    -   ( (  DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_5),
                                1, TO_NUMBER (NULL),
                                d.val_pa_5)
                           / DECODE (
                                SIGN (
                                   f.dta_fine_validita - d.dta_controllo_6),
                                1, TO_NUMBER (NULL),
                                d.val_pa_6)))
                      * 100),
                   2),
                99999999990.99))
             val_delta_pc5_vs_pc6,
          f.val_sconfino scsb_sconfino_pc,
          d.scsb_sconfino_at,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_sconfino_1)
             scsb_sconfino_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_sconfino_2)
             scsb_sconfino_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_sconfino_3)
             scsb_sconfino_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_sconfino_4)
             scsb_sconfino_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_sconfino_5)
             scsb_sconfino_5
     FROM mv_mcre0_app_gest_monitoraggio d,
          vtmcre0_app_upd_fields_p1 x,
          (SELECT *
             FROM (SELECT e1.*,
                          MAX (
                             e1.dta_fine_validita)
                          OVER (
                             PARTITION BY e1.cod_abi_cartolarizzato,
                                          e1.cod_ndg)
                             dta_fine_validita_rc
                     FROM t_mcre0_app_storico_eventi e1
                    WHERE e1.flg_cambio_gestore = '1') e2
            WHERE dta_fine_validita_rc = dta_fine_validita) f
    WHERE     d.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato(+)
          AND d.cod_ndg = x.cod_ndg(+)
          AND d.cod_abi_cartolarizzato = f.cod_abi_cartolarizzato(+)
          AND d.cod_ndg = f.cod_ndg(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_GEST_MONITORAGGIO TO MCRE_USR;
