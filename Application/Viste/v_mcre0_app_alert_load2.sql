/* Formatted on 21/07/2014 18:32:25 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_LOAD2
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   ALERT_1,
   COD_STATO_1,
   DTA_INS_1,
   DTA_UPD_1,
   FLG_WORSE_UPD_1,
   ALERT_2,
   COD_STATO_2,
   DTA_INS_2,
   DTA_UPD_2,
   FLG_WORSE_UPD_2,
   ALERT_3,
   COD_STATO_3,
   DTA_INS_3,
   DTA_UPD_3,
   FLG_WORSE_UPD_3,
   ALERT_4,
   COD_STATO_4,
   DTA_INS_4,
   DTA_UPD_4,
   FLG_WORSE_UPD_4,
   ALERT_5,
   COD_STATO_5,
   DTA_INS_5,
   DTA_UPD_5,
   FLG_WORSE_UPD_5,
   ALERT_6,
   COD_STATO_6,
   DTA_INS_6,
   DTA_UPD_6,
   FLG_WORSE_UPD_6,
   ALERT_7,
   COD_STATO_7,
   DTA_INS_7,
   DTA_UPD_7,
   FLG_WORSE_UPD_7,
   ALERT_8,
   COD_STATO_8,
   DTA_INS_8,
   DTA_UPD_8,
   FLG_WORSE_UPD_8,
   ALERT_11,
   COD_STATO_11,
   DTA_INS_11,
   DTA_UPD_11,
   FLG_WORSE_UPD_11,
   ALERT_12,
   COD_STATO_12,
   DTA_INS_12,
   DTA_UPD_12,
   FLG_WORSE_UPD_12,
   ALERT_13,
   COD_STATO_13,
   DTA_INS_13,
   DTA_UPD_13,
   FLG_WORSE_UPD_13,
   ALERT_14,
   COD_STATO_14,
   DTA_INS_14,
   DTA_UPD_14,
   FLG_WORSE_UPD_14,
   ALERT_15,
   COD_STATO_15,
   DTA_INS_15,
   DTA_UPD_15,
   FLG_WORSE_UPD_15,
   ALERT_16,
   COD_STATO_16,
   DTA_INS_16,
   DTA_UPD_16,
   FLG_WORSE_UPD_16,
   ALERT_17,
   COD_STATO_17,
   DTA_INS_17,
   DTA_UPD_17,
   FLG_WORSE_UPD_17,
   ALERT_18,
   COD_STATO_18,
   DTA_INS_18,
   DTA_UPD_18,
   FLG_WORSE_UPD_18,
   ALERT_19,
   COD_STATO_19,
   DTA_INS_19,
   DTA_UPD_19,
   FLG_WORSE_UPD_19,
   ALERT_20,
   COD_STATO_20,
   DTA_INS_20,
   DTA_UPD_20,
   FLG_WORSE_UPD_20,
   ALERT_21,
   COD_STATO_21,
   DTA_INS_21,
   DTA_UPD_21,
   FLG_WORSE_UPD_21,
   ALERT_22,
   COD_STATO_22,
   DTA_INS_22,
   DTA_UPD_22,
   FLG_WORSE_UPD_22,
   ALERT_23,
   COD_STATO_23,
   DTA_INS_23,
   DTA_UPD_23,
   FLG_WORSE_UPD_23,
   ALERT_25,
   COD_STATO_25,
   DTA_INS_25,
   DTA_UPD_25,
   FLG_WORSE_UPD_25,
   ALERT_40,
   COD_STATO_40,
   DTA_INS_40,
   DTA_UPD_40,
   FLG_WORSE_UPD_40,
   ALERT_41,
   COD_STATO_41,
   DTA_INS_41,
   DTA_UPD_41,
   FLG_WORSE_UPD_41,
   ALERT_49,
   COD_STATO_49,
   DTA_INS_49,
   DTA_UPD_49,
   FLG_WORSE_UPD_49
)
AS
     SELECT                                            -- VG 20140626 alert 49
           cod_abi_cartolarizzato,
            cod_abi_istituto,
            cod_ndg,
            cod_sndg,
            MAX (alert_1) alert_1,
            MAX (cod_stato_1) cod_stato_1,
            MAX (dta_ins_1) dta_ins_1,
            MAX (dta_upd_1) dta_upd_1,
            MAX (flg_worse_upd_1) flg_worse_upd_1,
            MAX (alert_2) alert_2,
            MAX (cod_stato_2) cod_stato_2,
            MAX (dta_ins_2) dta_ins_2,
            MAX (dta_upd_2) dta_upd_2,
            MAX (flg_worse_upd_2) flg_worse_upd_2,
            MAX (alert_3) alert_3,
            MAX (cod_stato_3) cod_stato_3,
            MAX (dta_ins_3) dta_ins_3,
            MAX (dta_upd_3) dta_upd_3,
            MAX (flg_worse_upd_3) flg_worse_upd_3,
            MAX (alert_4) alert_4,
            MAX (cod_stato_4) cod_stato_4,
            MAX (dta_ins_4) dta_ins_4,
            MAX (dta_upd_4) dta_upd_4,
            MAX (flg_worse_upd_4) flg_worse_upd_4,
            MAX (alert_5) alert_5,
            MAX (cod_stato_5) cod_stato_5,
            MAX (dta_ins_5) dta_ins_5,
            MAX (dta_upd_5) dta_upd_5,
            MAX (flg_worse_upd_5) flg_worse_upd_5,
            MAX (alert_6) alert_6,
            MAX (cod_stato_6) cod_stato_6,
            MAX (dta_ins_6) dta_ins_6,
            MAX (dta_upd_6) dta_upd_6,
            MAX (flg_worse_upd_6) flg_worse_upd_6,
            MAX (alert_7) alert_7,
            MAX (cod_stato_7) cod_stato_7,
            MAX (dta_ins_7) dta_ins_7,
            MAX (dta_upd_7) dta_upd_7,
            MAX (flg_worse_upd_7) flg_worse_upd_7,
            MAX (alert_8) alert_8,
            MAX (cod_stato_8) cod_stato_8,
            MAX (dta_ins_8) dta_ins_8,
            MAX (dta_upd_8) dta_upd_8,
            MAX (flg_worse_upd_8) flg_worse_upd_8,
            MAX (alert_11) alert_11,
            MAX (cod_stato_11) cod_stato_11,
            MAX (dta_ins_11) dta_ins_11,
            MAX (dta_upd_11) dta_upd_11,
            MAX (flg_worse_upd_11) flg_worse_upd_11,
            MAX (alert_12) alert_12,
            MAX (cod_stato_12) cod_stato_12,
            MAX (dta_ins_12) dta_ins_12,
            MAX (dta_upd_12) dta_upd_12,
            MAX (flg_worse_upd_12) flg_worse_upd_12,
            MAX (alert_13) alert_13,
            MAX (cod_stato_13) cod_stato_13,
            MAX (dta_ins_13) dta_ins_13,
            MAX (dta_upd_13) dta_upd_13,
            MAX (flg_worse_upd_13) flg_worse_upd_13,
            MAX (alert_14) alert_14,
            MAX (cod_stato_14) cod_stato_14,
            MAX (dta_ins_14) dta_ins_14,
            MAX (dta_upd_14) dta_upd_14,
            MAX (flg_worse_upd_14) flg_worse_upd_14,
            MAX (alert_15) alert_15,
            MAX (cod_stato_15) cod_stato_15,
            MAX (dta_ins_15) dta_ins_15,
            MAX (dta_upd_15) dta_upd_15,
            MAX (flg_worse_upd_15) flg_worse_upd_15,
            MAX (alert_16) alert_16,
            MAX (cod_stato_16) cod_stato_16,
            MAX (dta_ins_16) dta_ins_16,
            MAX (dta_upd_16) dta_upd_16,
            MAX (flg_worse_upd_16) flg_worse_upd_16,
            MAX (alert_17) alert_17,
            MAX (cod_stato_17) cod_stato_17,
            MAX (dta_ins_17) dta_ins_17,
            MAX (dta_upd_17) dta_upd_17,
            MAX (flg_worse_upd_17) flg_worse_upd_17,
            MAX (alert_18) alert_18,
            MAX (cod_stato_18) cod_stato_18,
            MAX (dta_ins_18) dta_ins_18,
            MAX (dta_upd_18) dta_upd_18,
            MAX (flg_worse_upd_18) flg_worse_upd_18,
            MAX (alert_19) alert_19,
            MAX (cod_stato_19) cod_stato_19,
            MAX (dta_ins_19) dta_ins_19,
            MAX (dta_upd_19) dta_upd_19,
            MAX (flg_worse_upd_19) flg_worse_upd_19,
            MAX (alert_20) alert_20,
            MAX (cod_stato_20) cod_stato_20,
            MAX (dta_ins_20) dta_ins_20,
            MAX (dta_upd_20) dta_upd_20,
            MAX (flg_worse_upd_20) flg_worse_upd_20,
            MAX (alert_21) alert_21,
            MAX (cod_stato_21) cod_stato_21,
            MAX (dta_ins_21) dta_ins_21,
            MAX (dta_upd_21) dta_upd_21,
            MAX (flg_worse_upd_21) flg_worse_upd_21,
            MAX (alert_22) alert_22,
            MAX (cod_stato_22) cod_stato_22,
            MAX (dta_ins_22) dta_ins_22,
            MAX (dta_upd_22) dta_upd_22,
            MAX (flg_worse_upd_22) flg_worse_upd_22,
            MAX (alert_23) alert_23,
            MAX (cod_stato_23) cod_stato_23,
            MAX (dta_ins_23) dta_ins_23,
            MAX (dta_upd_23) dta_upd_23,
            MAX (flg_worse_upd_23) flg_worse_upd_23,
            --            MAX (alert_24) alert_24,MAX (cod_stato_24) cod_stato_24, MAX (dta_ins_24) dta_ins_24,
            --            MAX (dta_upd_24) dta_upd_24,MAX (flg_worse_upd_24) flg_worse_upd_24,
            MAX (alert_25) alert_25,
            MAX (cod_stato_25) cod_stato_25,
            MAX (dta_ins_25) dta_ins_25,
            MAX (dta_upd_25) dta_upd_25,
            MAX (flg_worse_upd_25) flg_worse_upd_25,
            MAX (alert_40) alert_40,
            MAX (cod_stato_40) cod_stato_40,
            MAX (dta_ins_40) dta_ins_40,
            MAX (dta_upd_40) dta_upd_40,
            MAX (flg_worse_upd_40) flg_worse_upd_40,
            MAX (alert_41) alert_41,
            MAX (cod_stato_41) cod_stato_41,
            MAX (dta_ins_41) dta_ins_41,
            MAX (dta_upd_41) dta_upd_41,
            MAX (flg_worse_upd_41) flg_worse_upd_41,
            --            MAX (alert_45) alert_45,
            --            MAX (cod_stato_45) cod_stato_45, MAX (dta_ins_45) dta_ins_45,
            --            MAX (dta_upd_45) dta_upd_45,
            --            MAX (flg_worse_upd_45) flg_worse_upd_45
            MAX (alert_49) alert_49,
            MAX (cod_stato_49) cod_stato_49,
            MAX (dta_ins_49) dta_ins_49,
            MAX (dta_upd_49) dta_upd_49,
            MAX (flg_worse_upd_49) flg_worse_upd_49
       FROM t_mcre0_app_alert_pos_tmp
   GROUP BY cod_abi_cartolarizzato,
            cod_abi_istituto,
            cod_ndg,
            cod_sndg;
