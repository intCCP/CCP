/* Formatted on 21/07/2014 18:32:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_LOAD_PRO14F
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   COD_COMPARTO,
   COD_GRUPPO_SUPER,
   COD_STATO,
   ALERT_1,
   ALERT_2,
   ALERT_3,
   ALERT_4,
   ALERT_5,
   ALERT_6,
   ALERT_7,
   ALERT_8,
   ALERT_11,
   ALERT_12,
   ALERT_13,
   ALERT_14,
   ALERT_15,
   ALERT_16,
   ALERT_17,
   ALERT_18,
   ALERT_19,
   ALERT_20,
   ALERT_21,
   ALERT_22,
   ALERT_23,
   ALERT_25,
   ALERT_40,
   ALERT_41,
   ALERT_1_OLD,
   ALERT_2_OLD,
   ALERT_3_OLD,
   ALERT_4_OLD,
   ALERT_5_OLD,
   ALERT_6_OLD,
   ALERT_7_OLD,
   ALERT_8_OLD,
   ALERT_11_OLD,
   ALERT_12_OLD,
   ALERT_13_OLD,
   ALERT_14_OLD,
   ALERT_15_OLD,
   ALERT_16_OLD,
   ALERT_17_OLD,
   ALERT_18_OLD,
   ALERT_19_OLD,
   ALERT_20_OLD,
   ALERT_21_OLD,
   ALERT_22_OLD,
   ALERT_23_OLD,
   ALERT_25_OLD,
   ALERT_40_OLD,
   ALERT_41_OLD,
   DTA_INS_1,
   DTA_INS_2,
   DTA_INS_3,
   DTA_INS_4,
   DTA_INS_5,
   DTA_INS_6,
   DTA_INS_7,
   DTA_INS_8,
   DTA_INS_11,
   DTA_INS_12,
   DTA_INS_13,
   DTA_INS_14,
   DTA_INS_15,
   DTA_INS_16,
   DTA_INS_17,
   DTA_INS_18,
   DTA_INS_19,
   DTA_INS_20,
   DTA_INS_21,
   DTA_INS_22,
   DTA_INS_23,
   DTA_INS_25,
   DTA_INS_40,
   DTA_INS_41,
   DTA_UPD_1,
   DTA_UPD_2,
   DTA_UPD_3,
   DTA_UPD_4,
   DTA_UPD_5,
   DTA_UPD_6,
   DTA_UPD_7,
   DTA_UPD_8,
   DTA_UPD_11,
   DTA_UPD_12,
   DTA_UPD_13,
   DTA_UPD_14,
   DTA_UPD_15,
   DTA_UPD_16,
   DTA_UPD_17,
   DTA_UPD_18,
   DTA_UPD_19,
   DTA_UPD_20,
   DTA_UPD_21,
   DTA_UPD_22,
   DTA_UPD_23,
   DTA_UPD_25,
   DTA_UPD_40,
   DTA_UPD_41,
   FLG_WORSE_UPD_1,
   FLG_WORSE_UPD_2,
   FLG_WORSE_UPD_3,
   FLG_WORSE_UPD_4,
   FLG_WORSE_UPD_5,
   FLG_WORSE_UPD_6,
   FLG_WORSE_UPD_7,
   FLG_WORSE_UPD_8,
   FLG_WORSE_UPD_11,
   FLG_WORSE_UPD_12,
   FLG_WORSE_UPD_13,
   FLG_WORSE_UPD_14,
   FLG_WORSE_UPD_15,
   FLG_WORSE_UPD_16,
   FLG_WORSE_UPD_17,
   FLG_WORSE_UPD_18,
   FLG_WORSE_UPD_19,
   FLG_WORSE_UPD_20,
   FLG_WORSE_UPD_21,
   FLG_WORSE_UPD_22,
   FLG_WORSE_UPD_23,
   FLG_WORSE_UPD_25,
   FLG_WORSE_UPD_40,
   FLG_WORSE_UPD_41
)
AS
   SELECT h."COD_ABI_CARTOLARIZZATO",
          h."COD_ABI_ISTITUTO",
          h."COD_NDG",
          h."COD_SNDG",
          h."COD_COMPARTO",
          h."COD_GRUPPO_SUPER",
          h."COD_STATO",
          h."ALERT_1",
          h."ALERT_2",
          h."ALERT_3",
          h."ALERT_4",
          h."ALERT_5",
          h."ALERT_6",
          h."ALERT_7",
          h."ALERT_8",
          h."ALERT_11",
          h."ALERT_12",
          h."ALERT_13",
          h."ALERT_14",
          h."ALERT_15",
          h."ALERT_16",
          h."ALERT_17",
          h."ALERT_18",
          h."ALERT_19",
          h."ALERT_20",
          h."ALERT_21",
          h."ALERT_22",
          h."ALERT_23",
          --          h."ALERT_24",
          h."ALERT_25",
          h."ALERT_40",
          h."ALERT_41",
          --                       h."ALERT_45",
          h.alert_1_old,
          h.alert_2_old,
          h.alert_3_old,
          h.alert_4_old,
          h.alert_5_old,
          h.alert_6_old,
          h.alert_7_old,
          h.alert_8_old,
          h.alert_11_old,
          h.alert_12_old,
          h.alert_13_old,
          h.alert_14_old,
          h.alert_15_old,
          h.alert_16_old,
          h.alert_17_old,
          h.alert_18_old,
          h.alert_19_old,
          h.alert_20_old,
          h.alert_21_old,
          h.alert_22_old,
          h.alert_23_old,
          --          h.alert_24_old,
          h.alert_25_old,
          h.alert_40_old,
          h.alert_41_old,
          --          h.alert_45_old,
          DECODE (h.alert_1, NULL, NULL, h.dta_ins_1) dta_ins_1,
          DECODE (h.alert_2, NULL, NULL, h.dta_ins_2) dta_ins_2,
          DECODE (h.alert_3, NULL, NULL, h.dta_ins_3) dta_ins_3,
          DECODE (h.alert_4, NULL, NULL, h.dta_ins_4) dta_ins_4,
          DECODE (h.alert_5, NULL, NULL, h.dta_ins_5) dta_ins_5,
          DECODE (h.alert_6, NULL, NULL, h.dta_ins_6) dta_ins_6,
          DECODE (h.alert_7, NULL, NULL, h.dta_ins_7) dta_ins_7,
          DECODE (h.alert_8, NULL, NULL, h.dta_ins_8) dta_ins_8,
          DECODE (h.alert_11, NULL, NULL, h.dta_ins_11) dta_ins_11,
          DECODE (h.alert_12, NULL, NULL, h.dta_ins_12) dta_ins_12,
          DECODE (h.alert_13, NULL, NULL, h.dta_ins_13) dta_ins_13,
          DECODE (h.alert_14, NULL, NULL, h.dta_ins_14) dta_ins_14,
          DECODE (h.alert_15, NULL, NULL, h.dta_ins_15) dta_ins_15,
          DECODE (h.alert_16, NULL, NULL, h.dta_ins_16) dta_ins_16,
          DECODE (h.alert_17, NULL, NULL, h.dta_ins_17) dta_ins_17,
          DECODE (h.alert_18, NULL, NULL, h.dta_ins_18) dta_ins_18,
          DECODE (h.alert_19, NULL, NULL, h.dta_ins_19) dta_ins_19,
          DECODE (h.alert_20, NULL, NULL, h.dta_ins_20) dta_ins_20,
          DECODE (h.alert_21, NULL, NULL, h.dta_ins_21) dta_ins_21,
          DECODE (h.alert_22, NULL, NULL, h.dta_ins_22) dta_ins_22,
          DECODE (h.alert_23, NULL, NULL, h.dta_ins_23) dta_ins_23,
          --          DECODE (h.alert_24, NULL, NULL, h.dta_ins_24) dta_ins_24,
          DECODE (h.alert_25, NULL, NULL, h.dta_ins_25) dta_ins_25,
          DECODE (h.alert_40, NULL, NULL, h.dta_ins_40) dta_ins_40,
          DECODE (h.alert_41, NULL, NULL, h.dta_ins_41) dta_ins_41,
          --          DECODE (h.alert_45, NULL, NULL, h.dta_ins_45) dta_ins_45,
          h.dta_upd_1,
          h.dta_upd_2,
          h.dta_upd_3,
          h.dta_upd_4,
          h.dta_upd_5,
          h.dta_upd_6,
          h.dta_upd_7,
          h.dta_upd_8,
          h.dta_upd_11,
          h.dta_upd_12,
          h.dta_upd_13,
          h.dta_upd_14,
          h.dta_upd_15,
          h.dta_upd_16,
          h.dta_upd_17,
          h.dta_upd_18,
          h.dta_upd_19,
          h.dta_upd_20,
          h.dta_upd_21,
          h.dta_upd_22,
          h.dta_upd_23,
          --          h.dta_upd_24,
          h.dta_upd_25,
          h.dta_upd_40,
          h.dta_upd_41,
          --          h.dta_upd_45,

          /***
** Calcolo  FLG_WORSE_UPD
***/
          DECODE (
             SIGN (
                  DECODE (alert_1_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_1,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_1,
          DECODE (
             SIGN (
                  DECODE (alert_2_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_2,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_2,
          DECODE (
             SIGN (
                  DECODE (alert_3_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_3,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_3,
          DECODE (
             SIGN (
                  DECODE (alert_4_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_4,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_4,
          DECODE (
             SIGN (
                  DECODE (alert_5_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_5,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_5,
          DECODE (
             SIGN (
                  DECODE (alert_6_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_6,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_6,
          DECODE (
             SIGN (
                  DECODE (alert_7_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_7,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_7,
          DECODE (
             SIGN (
                  DECODE (alert_8_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_8,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_8,
          DECODE (
             SIGN (
                  DECODE (alert_11_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_11,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_11,
          DECODE (
             SIGN (
                  DECODE (alert_12_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_12,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_12,
          DECODE (
             SIGN (
                  DECODE (alert_13_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_13,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_13,
          DECODE (
             SIGN (
                  DECODE (alert_14_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_14,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_14,
          DECODE (
             SIGN (
                  DECODE (alert_15_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_15,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_15,
          DECODE (
             SIGN (
                  DECODE (alert_16_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_16,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_16,
          DECODE (
             SIGN (
                  DECODE (alert_17_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_17,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_17,
          DECODE (
             SIGN (
                  DECODE (alert_18_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_18,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_18,
          DECODE (
             SIGN (
                  DECODE (alert_19_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_19,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_19,
          DECODE (
             SIGN (
                  DECODE (alert_20_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_20,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_20,
          DECODE (
             SIGN (
                  DECODE (alert_21_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_21,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_21,
          DECODE (
             SIGN (
                  DECODE (alert_22_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_22,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_22,
          DECODE (
             SIGN (
                  DECODE (alert_23_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_23,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_23,
          --          DECODE (SIGN (  DECODE (alert_24_old, 'V', 1, 'A', 2, 'R', 3, 4)
          --                        - DECODE (alert_24, 'V', 1, 'A', 2, 'R', 3, 0)
          --                       ),
          --                  -1, 1,
          --                  0
          --                 ) flg_worse_upd_24,
          DECODE (
             SIGN (
                  DECODE (alert_25_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_25,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_25,
          DECODE (
             SIGN (
                  DECODE (alert_40_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_40,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_40,
          DECODE (
             SIGN (
                  DECODE (alert_41_old,  'V', 1,  'A', 2,  'R', 3,  4)
                - DECODE (alert_41,  'V', 1,  'A', 2,  'R', 3,  0)),
             -1, 1,
             0)
             flg_worse_upd_41
     --          DECODE (SIGN (  DECODE (alert_45_old, 'V', 1, 'A', 2, 'R', 3, 4)
     --                        - DECODE (alert_45, 'V', 1, 'A', 2, 'R', 3, 0)
     --                       ),
     --                  -1, 1,
     --                  0
     --                 ) flg_worse_upd_45
     FROM (SELECT m.cod_abi_cartolarizzato,
                  m.cod_abi_istituto,
                  m.cod_ndg,
                  m.cod_sndg,
                  m.cod_comparto,
                  m.cod_gruppo_super,
                  m.cod_stato,
                  /***
                  ** Caloclo  COLORE
                  ***/
                  ------------------ ALERT_1 ---------------------
                  CASE
                     WHEN m.alert_1 = 1
                     THEN
                        CASE
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_1, SYSDATE)) BETWEEN 0
                                                                        AND 6)
                           THEN
                              'V'
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_1, SYSDATE)) BETWEEN 7
                                                                        AND 14)
                           THEN
                              'A'
                           WHEN ( (  TRUNC (SYSDATE)
                                   - TRUNC (NVL (dta_ins_1, SYSDATE))) >= 15)
                           THEN
                              'R'
                           ELSE
                              NULL
                        END
                     ELSE
                        NULL
                  END
                     alert_1,
                  ------------------ ALERT_2 ---------------------
                  CASE
                     WHEN m.alert_2 = 1
                     THEN
                        CASE
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_2, SYSDATE)) BETWEEN 0
                                                                        AND 7)
                           THEN
                              'V'
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_2, SYSDATE)) BETWEEN 8
                                                                        AND 15)
                           THEN
                              'A'
                           WHEN ( (  TRUNC (SYSDATE)
                                   - TRUNC (NVL (dta_ins_2, SYSDATE))) > 15)
                           THEN
                              'R'
                           ELSE
                              NULL
                        END
                     ELSE
                        NULL
                  END
                     alert_2,
                  ------------------ ALERT_3 ---------------------
                  CASE
                     WHEN m.alert_3 = 1
                     THEN
                        CASE
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_3, SYSDATE)) < 30)
                           THEN
                              'V'
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_3, SYSDATE)) BETWEEN 30
                                                                        AND 59)
                           THEN
                              'A'
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_3, SYSDATE)) > 60)
                           THEN
                              'R'
                           ELSE
                              NULL
                        END
                     ELSE
                        NULL
                  END
                     alert_3,
                  ------------------ ALERT_4 ---------------------
                  CASE
                     WHEN m.alert_4 = 1
                     THEN
                        CASE
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_4, SYSDATE)) BETWEEN 0
                                                                        AND 7)
                           THEN
                              'V'
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_4, SYSDATE)) BETWEEN 8
                                                                        AND 15)
                           THEN
                              'A'
                           WHEN ( (  TRUNC (SYSDATE)
                                   - TRUNC (NVL (dta_ins_4, SYSDATE))) > 15)
                           THEN
                              'R'
                           ELSE
                              NULL
                        END
                     ELSE
                        NULL
                  END
                     alert_4,
                  ------------------ ALERT_5 ---------------------
                  CASE
                     WHEN m.alert_5 = 1
                     THEN
                        CASE
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_5, SYSDATE)) BETWEEN 0
                                                                        AND 6)
                           THEN
                              'V'
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_5, SYSDATE)) BETWEEN 7
                                                                        AND 14)
                           THEN
                              'A'
                           WHEN ( (  TRUNC (SYSDATE)
                                   - TRUNC (NVL (dta_ins_5, SYSDATE))) >= 15)
                           THEN
                              'R'
                           ELSE
                              NULL
                        END
                     ELSE
                        NULL
                  END
                     alert_5,
                  ------------------ ALERT_6 ---------------------
                  CASE
                     WHEN m.alert_6 = 1
                     THEN
                        (SELECT CASE
                                   WHEN (  TRUNC (SYSDATE)
                                         - x.dta_scadenza_azione_max BETWEEN 0
                                                                         AND 6)
                                   THEN
                                      'V'
                                   WHEN (  TRUNC (SYSDATE)
                                         - x.dta_scadenza_azione_max BETWEEN 7
                                                                         AND 14)
                                   THEN
                                      'A'
                                   WHEN (  TRUNC (SYSDATE)
                                         - x.dta_scadenza_azione_max > 14)
                                   THEN
                                      'R'
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM (  SELECT cod_abi_cartolarizzato,
                                          cod_ndg,
                                          MAX (dta_scadenza_azione_max)
                                             dta_scadenza_azione_max
                                     FROM (SELECT z.*,
                                                  FIRST_VALUE (
                                                     dta_scadenza)
                                                  OVER (
                                                     PARTITION BY cod_abi_cartolarizzato,
                                                                  cod_ndg
                                                     ORDER BY dta_scadenza DESC)
                                                     dta_scadenza_azione_max
                                             FROM t_mcre0_app_rio_azioni z
                                            WHERE dta_scadenza <
                                                     TRUNC (SYSDATE)) zz
                                    WHERE dta_scadenza =
                                             dta_scadenza_azione_max
                                 GROUP BY cod_abi_cartolarizzato, cod_ndg) x
                          WHERE     x.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND x.cod_ndg = m.cod_ndg)
                     ELSE
                        NULL
                  END
                     alert_6,
                  ------------------ ALERT_7 ---------------------
                  CASE
                     WHEN m.alert_7 = 1
                     THEN
                        CASE
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_7, SYSDATE)) BETWEEN 0
                                                                        AND 7)
                           THEN
                              'V'
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_7, SYSDATE)) BETWEEN 8
                                                                        AND 15)
                           THEN
                              'A'
                           WHEN ( (  TRUNC (SYSDATE)
                                   - TRUNC (NVL (dta_ins_7, SYSDATE))) > 15)
                           THEN
                              'R'
                           ELSE
                              NULL
                        END
                     ELSE
                        NULL
                  END
                     alert_7,
                  ------------------ ALERT_8 ---------------------
                  CASE
                     WHEN m.alert_8 = 1
                     THEN
                        CASE
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_8, SYSDATE)) BETWEEN 0
                                                                        AND 2)
                           THEN
                              'V'
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_8, SYSDATE)) BETWEEN 3
                                                                        AND 4)
                           THEN
                              'A'
                           WHEN ( (  TRUNC (SYSDATE)
                                   - TRUNC (NVL (dta_ins_8, SYSDATE))) > 4)
                           THEN
                              'R'
                           ELSE
                              NULL
                        END
                     ELSE
                        NULL
                  END
                     alert_8,
                  ------------------ ALERT_11 ---------------------
                  CASE
                     WHEN m.alert_11 = 1
                     THEN
                        CASE
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_11, SYSDATE)) BETWEEN 0
                                                                         AND 10)
                           THEN
                              'V'
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_11, SYSDATE)) BETWEEN 11
                                                                         AND 20)
                           THEN
                              'A'
                           WHEN ( (  TRUNC (SYSDATE)
                                   - TRUNC (NVL (dta_ins_11, SYSDATE))) > 20)
                           THEN
                              'R'
                           ELSE
                              NULL
                        END
                     ELSE
                        NULL
                  END
                     alert_11,
                  ------------------ ALERT_12 ---------------------
                  CASE
                     WHEN m.alert_12 = 1
                     THEN
                        CASE
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_12, SYSDATE)) < 60)
                           THEN
                              'V'
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_12, SYSDATE)) BETWEEN 60
                                                                         AND 120)
                           THEN
                              'A'
                           WHEN (  TRUNC (SYSDATE)
                                 - TRUNC (NVL (dta_ins_12, SYSDATE)) > 120)
                           THEN
                              'R'
                        END
                     ELSE
                        NULL
                  END
                     alert_12,
                  ------------------ ALERT_13 ---------------------
                  CASE
                     WHEN m.alert_13 = 1
                     THEN
                        (SELECT CASE
                                   WHEN (  TRUNC (SYSDATE)
                                         - x.dta_decorrenza_stato BETWEEN 30
                                                                      AND 44)
                                   THEN
                                      'V'
                                   WHEN (  TRUNC (SYSDATE)
                                         - x.dta_decorrenza_stato BETWEEN 45
                                                                      AND 60)
                                   THEN
                                      'A'
                                   WHEN (  TRUNC (SYSDATE)
                                         - x.dta_decorrenza_stato > 60)
                                   THEN
                                      'R'
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM mv_mcre0_app_upd_field x
                          WHERE     x.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND x.cod_ndg = m.cod_ndg)
                     ELSE
                        NULL
                  END
                     alert_13,
                  ------------------ ALERT_14 ---------------------
                  CASE
                     WHEN m.alert_14 = 1
                     THEN
                        (SELECT CASE
                                   WHEN i.perdita_attesa BETWEEN (  pc.val_pa
                                                                  * 1.01)
                                                             AND (  pc.val_pa
                                                                  * 1.05)
                                   THEN
                                      'V'
                                   WHEN i.perdita_attesa BETWEEN (  pc.val_pa
                                                                  * 1.05)
                                                             AND (  pc.val_pa
                                                                  * 1.1)
                                   THEN
                                      'A'
                                   WHEN i.perdita_attesa > (pc.val_pa * 1.1)
                                   THEN
                                      'R'
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM mv_mcre0_app_scheda_anag_scpc2 pc,
                                t_mcre0_app_perdita_attesa i
                          --t_mcre0_app_iris i
                          WHERE     pc.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND pc.cod_ndg = m.cod_ndg
                                AND pc.cod_ndg = i.cod_ndg
                                AND pc.cod_abi_cartolarizzato = i.cod_abi)
                     ELSE
                        NULL
                  END
                     alert_14,
                  ------------------ ALERT_15 ---------------------
                  CASE
                     WHEN m.alert_15 = 1
                     THEN
                        (SELECT DISTINCT
                                CASE
                                   WHEN (a.dta_scadenza - TRUNC (SYSDATE) BETWEEN 15
                                                                              AND 30)
                                   THEN
                                      'V'
                                   WHEN (a.dta_scadenza - TRUNC (SYSDATE) BETWEEN 7
                                                                              AND 14)
                                   THEN
                                      'A'
                                   WHEN (a.dta_scadenza - TRUNC (SYSDATE) < 7)
                                   THEN
                                      'R'
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM (SELECT cod_abi_cartolarizzato,
                                        cod_ndg,
                                        dta_scadenza,
                                        MIN (
                                           dta_scadenza)
                                        OVER (
                                           PARTITION BY cod_abi_cartolarizzato,
                                                        cod_ndg)
                                           dta_scadenza_min
                                   FROM t_mcre0_app_rio_azioni
                                  WHERE flg_status != 'C') a
                          WHERE     a.dta_scadenza = a.dta_scadenza_min
                                AND a.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND a.cod_ndg = m.cod_ndg)
                     ELSE
                        NULL
                  END
                     alert_15,
                  ------------------ ALERT_16 ---------------------
                  CASE WHEN m.alert_16 = 1 THEN 'R' ELSE NULL END alert_16,
                  ------------------ ALERT_17 ---------------------
                  CASE
                     WHEN m.alert_17 = 1
                     THEN
                        (SELECT CASE
                                   WHEN (x.num_giorni_sconfino_rap BETWEEN 120
                                                                       AND 150)
                                   THEN
                                      'V'
                                   WHEN (x.num_giorni_sconfino_rap BETWEEN 151
                                                                       AND 180)
                                   THEN
                                      'A'
                                   WHEN (x.num_giorni_sconfino_rap > 180)
                                   THEN
                                      'R'
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM t_mcre0_app_sab_xra x
                          WHERE     x.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND x.cod_ndg = m.cod_ndg)
                     ELSE
                        NULL
                  END
                     alert_17,
                  ------------------ ALERT_18 ---------------------
                  CASE
                     WHEN m.alert_18 = 1
                     THEN
                        (SELECT CASE
                                   WHEN c.val_livello = 'DIREZIONE'
                                   THEN
                                      CASE
                                         WHEN (  DECODE (
                                                    DECODE (p.flg_esito,
                                                            0, NULL,
                                                            p.dta_esito),
                                                    NULL, x.dta_servizio + c.val_gg_prima_proroga,
                                                    p.dta_esito + c.val_gg_seconda_proroga)
                                               - TRUNC (SYSDATE) >= 15)
                                         THEN
                                            'V'
                                         WHEN (  DECODE (
                                                    DECODE (p.flg_esito,
                                                            0, NULL,
                                                            p.dta_esito),
                                                    NULL,   x.dta_servizio
                                                          + c.val_gg_prima_proroga,
                                                      p.dta_esito
                                                    + c.val_gg_seconda_proroga)
                                               - TRUNC (SYSDATE) BETWEEN 7
                                                                     AND 14)
                                         THEN
                                            'A'
                                         WHEN (  DECODE (
                                                    DECODE (p.flg_esito,
                                                            0, NULL,
                                                            p.dta_esito),
                                                    NULL,   x.dta_servizio
                                                          + c.val_gg_prima_proroga,
                                                      p.dta_esito
                                                    + c.val_gg_seconda_proroga)
                                               - TRUNC (SYSDATE) < 7)
                                         THEN
                                            'R'
                                      END
                                   WHEN c.val_livello = 'DIVISIONE' --                                        IN ('DIVISIONE', 'REGIONE',
 --                                                'AREA') --10/01/13 commento per escludere l'estensione a aree e regioni
                                         AND x.cod_stato = 'OC'
                                   THEN
                                      CASE
                                         WHEN (  x.dta_scadenza_stato
                                               - TRUNC (SYSDATE) >= 15)
                                         THEN
                                            'V'
                                         WHEN (  x.dta_scadenza_stato
                                               - TRUNC (SYSDATE) BETWEEN 7
                                                                     AND 14)
                                         THEN
                                            'A'
                                         WHEN (  x.dta_scadenza_stato
                                               - TRUNC (SYSDATE) < 7)
                                         THEN
                                            'R'
                                      END
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM mv_mcre0_app_upd_field x,
                                (SELECT *
                                   FROM t_mcre0_app_rio_proroghe
                                  WHERE flg_esito = 1 AND flg_storico = 0) p,
                                t_mcre0_app_comparti c
                          WHERE     x.cod_abi_cartolarizzato =
                                       p.cod_abi_cartolarizzato(+)
                                AND x.cod_ndg = p.cod_ndg(+)
                                AND x.cod_comparto = c.cod_comparto
                                AND x.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND x.cod_ndg = m.cod_ndg)
                     ELSE
                        NULL
                  END
                     alert_18,
                  ------------------ ALERT_19 ---------------------
                  CASE
                     WHEN m.alert_19 = 1
                     THEN
                        (SELECT CASE
                                   WHEN c.val_livello = 'DIREZIONE'
                                   THEN
                                      CASE
                                         WHEN (  DECODE (
                                                    p.dta_esito,
                                                    NULL, x.dta_servizio + c.val_gg_prima_proroga,
                                                    p.dta_esito + c.val_gg_seconda_proroga)
                                               - TRUNC (SYSDATE) >= 15)
                                         THEN
                                            'V'
                                         WHEN (  DECODE (
                                                    p.dta_esito,
                                                    NULL,   x.dta_servizio
                                                          + c.val_gg_prima_proroga,
                                                      p.dta_esito
                                                    + c.val_gg_seconda_proroga)
                                               - TRUNC (SYSDATE) BETWEEN 7
                                                                     AND 14)
                                         THEN
                                            'A'
                                         WHEN (  DECODE (
                                                    p.dta_esito,
                                                    NULL,   x.dta_servizio
                                                          + c.val_gg_prima_proroga,
                                                      p.dta_esito
                                                    + c.val_gg_seconda_proroga)
                                               - TRUNC (SYSDATE) < 7)
                                         THEN
                                            'R'
                                      END
                                   WHEN c.val_livello = 'DIVISIONE' --                                        IN ('DIVISIONE', 'REGIONE',
 --                                                'AREA') --10/01/13 commento per escludere l'estensione a aree e regioni
                                         AND x.cod_stato = 'OC'
                                   THEN
                                      CASE
                                         WHEN (  x.dta_scadenza_stato
                                               - TRUNC (SYSDATE) >= 15)
                                         THEN
                                            'V'
                                         WHEN (  x.dta_scadenza_stato
                                               - TRUNC (SYSDATE) BETWEEN 7
                                                                     AND 14)
                                         THEN
                                            'A'
                                         WHEN (  x.dta_scadenza_stato
                                               - TRUNC (SYSDATE) < 7)
                                         THEN
                                            'R'
                                      END
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM mv_mcre0_app_upd_field x,
                                (SELECT *
                                   FROM t_mcre0_app_rio_proroghe
                                  WHERE flg_esito = 1 AND flg_storico = 0) p,
                                t_mcre0_app_comparti c
                          WHERE     x.cod_abi_cartolarizzato =
                                       p.cod_abi_cartolarizzato(+)
                                AND x.cod_ndg = p.cod_ndg(+)
                                AND x.cod_comparto = c.cod_comparto
                                AND x.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND x.cod_ndg = m.cod_ndg)
                     ELSE
                        NULL
                  END
                     alert_19,
                  ------------------ ALERT_20---------------------
                  CASE
                     WHEN m.alert_20 = 1
                     THEN
                        (SELECT CASE
                                   WHEN (  DECODE (
                                              t_mcre0_app_rio_proroghe.dta_esito,
                                              NULL,   x.dta_servizio
                                                    + t_mcre0_app_comparti.val_gg_prima_proroga,
                                                t_mcre0_app_rio_proroghe.dta_esito
                                              + t_mcre0_app_comparti.val_gg_seconda_proroga)
                                         - TRUNC (SYSDATE) >= 15)
                                   THEN
                                      'V'
                                   WHEN (  DECODE (
                                              t_mcre0_app_rio_proroghe.dta_esito,
                                              NULL,   x.dta_servizio
                                                    + t_mcre0_app_comparti.val_gg_prima_proroga,
                                                t_mcre0_app_rio_proroghe.dta_esito
                                              + t_mcre0_app_comparti.val_gg_seconda_proroga)
                                         - TRUNC (SYSDATE) BETWEEN 7
                                                               AND 14)
                                   THEN
                                      'A'
                                   WHEN (  DECODE (
                                              t_mcre0_app_rio_proroghe.dta_esito,
                                              NULL,   x.dta_servizio
                                                    + t_mcre0_app_comparti.val_gg_prima_proroga,
                                                t_mcre0_app_rio_proroghe.dta_esito
                                              + t_mcre0_app_comparti.val_gg_seconda_proroga)
                                         - TRUNC (SYSDATE) < 7)
                                   THEN
                                      'R'
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM mv_mcre0_app_upd_field x,
                                (SELECT *
                                   FROM t_mcre0_app_rio_proroghe
                                  WHERE flg_esito = 1 AND flg_storico = 0) t_mcre0_app_rio_proroghe,
                                t_mcre0_app_comparti
                          WHERE     x.cod_abi_cartolarizzato =
                                       t_mcre0_app_rio_proroghe.cod_abi_cartolarizzato(+)
                                AND x.cod_ndg =
                                       t_mcre0_app_rio_proroghe.cod_ndg(+)
                                AND x.cod_comparto =
                                       t_mcre0_app_comparti.cod_comparto
                                AND x.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND x.cod_ndg = m.cod_ndg)
                     ELSE
                        NULL
                  END
                     alert_20,
                  ------------------ ALERT_21 ---------------------
                  CASE
                     WHEN m.alert_21 = 1
                     THEN
                        (SELECT CASE
                                   WHEN (  (TRUNC (x.dta_servizio) + c.val_gg_prima_proroga)
                                         - TRUNC (SYSDATE) > 14)
                                   THEN
                                      'V'
                                   WHEN (  (  TRUNC (x.dta_servizio)
                                            + c.val_gg_prima_proroga)
                                         - TRUNC (SYSDATE) BETWEEN 7
                                                               AND 14)
                                   THEN
                                      'A'
                                   WHEN (  (  TRUNC (x.dta_servizio)
                                            + c.val_gg_prima_proroga)
                                         - TRUNC (SYSDATE) < 7)
                                   THEN
                                      'R'
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM mv_mcre0_app_upd_field x,
                                t_mcre0_app_comparti c
                          WHERE     x.cod_comparto = c.cod_comparto
                                AND x.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND x.cod_ndg = m.cod_ndg)
                     ELSE
                        NULL
                  END
                     alert_21,
                  ------------------ ALERT_22---------------------
                  CASE
                     WHEN m.alert_22 = 1
                     THEN
                        (SELECT DISTINCT
                                CASE
                                   WHEN val_ordine_min_null = -1
                                   THEN
                                      'R'
                                   WHEN val_ordine_min BETWEEN 1 AND 6
                                   THEN
                                      'A'
                                   WHEN val_ordine_min BETWEEN 7 AND 24
                                   THEN
                                      'V'
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM mv_mcre0_app_cr_new c
                          WHERE     cod_stato_sis = 'SO'
                                AND c.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND c.cod_ndg = m.cod_ndg)
                     ELSE
                        NULL
                  END
                     alert_22,
                  ------------------ ALERT_23---------------------
                  CASE
                     WHEN m.alert_23 = 1
                     THEN
                        (SELECT DISTINCT
                                CASE
                                   WHEN val_ordine_min_null = -1
                                   THEN
                                      'R'
                                   WHEN val_ordine_min BETWEEN 1 AND 6
                                   THEN
                                      'A'
                                   WHEN val_ordine_min BETWEEN 7 AND 24
                                   THEN
                                      'V'
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM mv_mcre0_app_cr_new c
                          WHERE     cod_stato_sis = 'RI'
                                AND c.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND c.cod_ndg = m.cod_ndg)
                     ELSE
                        NULL
                  END
                     alert_23,
                  --
                  --                  ------------------ ALERT_24 ---------------------
                  --                  CASE
                  --                     WHEN m.alert_24 = 1
                  --                        THEN (SELECT MAX
                  --                                        (CASE
                  --                                            WHEN val_ordine_min_null = -1
                  --                                            AND cod_stato_sis_prev NOT IN
                  --                                                                ('180', '90')
                  --                                               THEN 'R'
                  --                                            WHEN tot_mesi = 6
                  --                                               THEN 'A'
                  --                                            WHEN val_ordine_min BETWEEN 7 AND 24
                  --                                               THEN CASE
                  --                                                      WHEN val_ordine_min_null =
                  --                                                                            -1
                  --                                                      AND cod_stato_sis_prev NOT IN
                  --                                                                ('180', '90')
                  --                                                         THEN NULL
                  --                                                      ELSE 'V'
                  --                                                   END
                  --                                            ELSE NULL
                  --                                         END
                  --                                        ) alert
                  --                                FROM mv_mcre0_app_cr_new c
                  --                               WHERE cod_stato_sis IN ('180', '90')
                  --                                 AND c.cod_abi_cartolarizzato =
                  --                                                      m.cod_abi_cartolarizzato
                  --                                 AND c.cod_ndg = m.cod_ndg)
                  --                     ELSE NULL
                  --                  END alert_24,
                  --
                  ------------------ ALERT_25 ---------------------
                  CASE
                     WHEN m.alert_25 = 1
                     THEN
                        (SELECT CASE
                                   WHEN (  TO_NUMBER (c.scgb_qis_uti)
                                         - TO_NUMBER (p.scgb_qis_uti)) BETWEEN 1
                                                                           AND 2
                                   THEN
                                      'V'
                                   WHEN (  TO_NUMBER (c.scgb_qis_uti)
                                         - TO_NUMBER (p.scgb_qis_uti)) BETWEEN 3
                                                                           AND 10
                                   THEN
                                      'A'
                                   WHEN (  TO_NUMBER (c.scgb_qis_uti)
                                         - TO_NUMBER (p.scgb_qis_uti)) > 10
                                   THEN
                                      'R'
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM t_mcre0_app_cr c,
                                mv_mcre0_app_scheda_anag_scpc2 p
                          WHERE     c.cod_abi_cartolarizzato =
                                       p.cod_abi_cartolarizzato
                                AND c.cod_ndg = p.cod_ndg
                                AND c.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND c.cod_ndg = m.cod_ndg
                                AND fnd_mcre0_is_numeric (c.scgb_qis_uti) = 1
                                AND fnd_mcre0_is_numeric (p.scgb_qis_uti) = 1)
                     ELSE
                        NULL
                  END
                     alert_25,
                  ------------------ ALERT_40 ---------------------
                  CASE
                     WHEN m.alert_40 = 1
                     THEN
                        (SELECT CASE
                                   WHEN (    t_mcre0_app_comparti.val_livello =
                                                'DIVISIONE'
                                         --                                        IN ('DIVISIONE', 'REGIONE',
                                         --                                                      'AREA') --10/01/13 commento per escludere l'estensione a aree e regioni
                                         AND x.cod_stato = 'OC'
                                         AND (  x.dta_scadenza_stato
                                              - TRUNC (SYSDATE)) >= 15)
                                   THEN
                                      'V'
                                   WHEN (    t_mcre0_app_comparti.val_livello =
                                                'DIVISIONE'
                                         --                                        IN ('DIVISIONE', 'REGIONE',
                                         --                                                      'AREA') --10/01/13 commento per escludere l'estensione a aree e regioni
                                         AND x.cod_stato = 'OC'
                                         AND (  x.dta_scadenza_stato
                                              - TRUNC (SYSDATE)) BETWEEN 7
                                                                     AND 14)
                                   THEN
                                      'A'
                                   WHEN (    t_mcre0_app_comparti.val_livello =
                                                'DIVISIONE'
                                         --                                        IN ('DIVISIONE', 'REGIONE',
                                         --                                                      'AREA')--10/01/13 commento per escludere l'estensione a aree e regioni
                                         AND x.cod_stato = 'OC'
                                         AND (  x.dta_scadenza_stato
                                              - TRUNC (SYSDATE)) < 7)
                                   THEN
                                      'R'
                                   ELSE
                                      NULL
                                END
                                   alert
                           FROM mv_mcre0_app_upd_field x,
                                (SELECT *
                                   FROM t_mcre0_app_rio_proroghe
                                  WHERE flg_esito = 1 AND flg_storico = 0) t_mcre0_app_rio_proroghe,
                                t_mcre0_app_comparti
                          WHERE     x.cod_abi_cartolarizzato =
                                       t_mcre0_app_rio_proroghe.cod_abi_cartolarizzato(+)
                                AND x.cod_ndg =
                                       t_mcre0_app_rio_proroghe.cod_ndg(+)
                                AND x.cod_comparto =
                                       t_mcre0_app_comparti.cod_comparto
                                AND x.cod_abi_cartolarizzato =
                                       m.cod_abi_cartolarizzato
                                AND x.cod_ndg = m.cod_ndg)
                     ELSE
                        NULL
                  END
                     alert_40,
                  ------------------ ALERT_41---------------------
                  CASE WHEN m.alert_41 = 1 THEN 'R' ELSE NULL END alert_41,
                  tmp.alert_1 alert_1_old,
                  -------------------- ALERT_45 ---------------------
                  --                  CASE
                  --                     WHEN m.alert_45 = 1
                  --                        THEN CASE
                  --                               WHEN (  TRUNC (SYSDATE)
                  --                                     - TRUNC (NVL (dta_ins_45, SYSDATE))
                  --                                        BETWEEN 0
                  --                                            AND 7
                  --                                    )
                  --                                  THEN 'V'
                  --                               WHEN (  TRUNC (SYSDATE)
                  --                                     - TRUNC (NVL (dta_ins_45, SYSDATE))
                  --                                        BETWEEN 8
                  --                                            AND 15
                  --                                    )
                  --                                  THEN 'A'
                  --                               WHEN (  TRUNC (SYSDATE)
                  --                                     - TRUNC (NVL (dta_ins_45, SYSDATE)) > 15
                  --                                    )
                  --                                  THEN 'R'
                  --                            END
                  --                     ELSE NULL
                  --                  END alert_45,
                  NVL (dta_ins_1, SYSDATE) dta_ins_1,
                  SYSDATE dta_upd_1,
                  tmp.alert_2 alert_2_old,
                  NVL (dta_ins_2, SYSDATE) dta_ins_2,
                  SYSDATE dta_upd_2,
                  tmp.alert_3 alert_3_old,
                  NVL (dta_ins_3, SYSDATE) dta_ins_3,
                  SYSDATE dta_upd_3,
                  tmp.alert_4 alert_4_old,
                  NVL (dta_ins_4, SYSDATE) dta_ins_4,
                  SYSDATE dta_upd_4,
                  tmp.alert_5 alert_5_old,
                  NVL (dta_ins_5, SYSDATE) dta_ins_5,
                  SYSDATE dta_upd_5,
                  tmp.alert_6 alert_6_old,
                  NVL (dta_ins_6, SYSDATE) dta_ins_6,
                  SYSDATE dta_upd_6,
                  tmp.alert_7 alert_7_old,
                  NVL (dta_ins_7, SYSDATE) dta_ins_7,
                  SYSDATE dta_upd_7,
                  tmp.alert_8 alert_8_old,
                  NVL (dta_ins_8, SYSDATE) dta_ins_8,
                  SYSDATE dta_upd_8,
                  tmp.alert_11 alert_11_old,
                  NVL (dta_ins_11, SYSDATE) dta_ins_11,
                  SYSDATE dta_upd_11,
                  tmp.alert_12 alert_12_old,
                  NVL (dta_ins_12, SYSDATE) dta_ins_12,
                  SYSDATE dta_upd_12,
                  tmp.alert_13 alert_13_old,
                  NVL (dta_ins_13, SYSDATE) dta_ins_13,
                  SYSDATE dta_upd_13,
                  tmp.alert_14 alert_14_old,
                  NVL (dta_ins_14, SYSDATE) dta_ins_14,
                  SYSDATE dta_upd_14,
                  tmp.alert_15 alert_15_old,
                  NVL (dta_ins_15, SYSDATE) dta_ins_15,
                  SYSDATE dta_upd_15,
                  tmp.alert_16 alert_16_old,
                  NVL (dta_ins_16, SYSDATE) dta_ins_16,
                  SYSDATE dta_upd_16,
                  tmp.alert_17 alert_17_old,
                  NVL (dta_ins_17, SYSDATE) dta_ins_17,
                  SYSDATE dta_upd_17,
                  tmp.alert_18 alert_18_old,
                  NVL (dta_ins_18, SYSDATE) dta_ins_18,
                  SYSDATE dta_upd_18,
                  tmp.alert_19 alert_19_old,
                  NVL (dta_ins_19, SYSDATE) dta_ins_19,
                  SYSDATE dta_upd_19,
                  tmp.alert_20 alert_20_old,
                  NVL (dta_ins_20, SYSDATE) dta_ins_20,
                  SYSDATE dta_upd_20,
                  tmp.alert_21 alert_21_old,
                  NVL (dta_ins_21, SYSDATE) dta_ins_21,
                  SYSDATE dta_upd_21,
                  tmp.alert_22 alert_22_old,
                  NVL (dta_ins_22, SYSDATE) dta_ins_22,
                  SYSDATE dta_upd_22,
                  tmp.alert_23 alert_23_old,
                  NVL (dta_ins_23, SYSDATE) dta_ins_23,
                  SYSDATE dta_upd_23,
                  --                  tmp.alert_24 alert_24_old,
                  --                  NVL (dta_ins_24, SYSDATE) dta_ins_24, SYSDATE dta_upd_24,
                  tmp.alert_25 alert_25_old,
                  NVL (dta_ins_25, SYSDATE) dta_ins_25,
                  SYSDATE dta_upd_25,
                  tmp.alert_40 alert_40_old,
                  NVL (dta_ins_40, SYSDATE) dta_ins_40,
                  SYSDATE dta_upd_40,
                  tmp.alert_41 alert_41_old,
                  NVL (dta_ins_41, SYSDATE) dta_ins_41,
                  SYSDATE dta_upd_41
             --                  tmp.alert_45 alert_45_old,
             --                  NVL (dta_ins_45, SYSDATE) dta_ins_45, SYSDATE dta_upd_45
             FROM (SELECT a.cod_abi_cartolarizzato,
                          a.cod_abi_istituto,
                          a.cod_ndg,
                          a.cod_sndg,
                          a.cod_comparto,
                          a.cod_gruppo_super,
                          NVL (a.cod_macrostato, a.cod_stato) cod_stato,
                          /***
                          ** Caloclo  ALERT - REGOLE
                          ***/
                          ------------------ ALERT_1 ---------------------
                          NVL (
                             (SELECT DISTINCT 1
                                FROM t_mcre0_app_sag s
                               WHERE     s.cod_sndg = a.cod_sndg
                                     AND NVL (s.flg_conferma, 'N') = 'N'),
                             0)
                             alert_1,
                          ------------------ ALERT_2 ---------------------
                          NVL (
                             (SELECT DISTINCT 1
                                FROM t_mcre0_app_sag s
                               WHERE     s.cod_sndg = a.cod_sndg
                                     AND NVL (s.flg_conferma, 'N') = 'S'
                                     AND NVL (s.flg_allineamento, 'N') = 'N'
                                     AND s.cod_sag NOT IN
                                            (SELECT cod_sag
                                               FROM t_mcre0_cl_sag
                                              WHERE t_mcre0_cl_sag.default_microstato
                                                       IS NULL)
                                     AND a.cod_macrostato NOT IN
                                            (SELECT cod_macrostato
                                               FROM t_mcre0_cl_sag
                                              WHERE t_mcre0_cl_sag.cod_sag =
                                                       s.cod_sag)),
                             0)
                             alert_2,
                          ------------------ ALERT_3 ---------------------
                          NVL (
                             (SELECT DISTINCT 1
                                FROM t_mcre0_app_pef p
                               WHERE     a.cod_abi_istituto =
                                            p.cod_abi_istituto(+)
                                     AND a.cod_ndg = p.cod_ndg(+)
                                     AND NVL (cod_fase_pef, 0) = 321),
                             0)
                             alert_3,
                          ------------------ ALERT_4 ---------------------
                          (CASE
                              WHEN     a.cod_stato NOT IN
                                          (SELECT cod_microstato
                                             FROM t_mcre0_app_gestori_stati_comp
                                            WHERE id_utente = a.id_utente)
                                   AND (  a.flg_gruppo_economico
                                        + a.flg_gruppo_legame) = 0
                                   AND a.id_utente != -1
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_4,
                          ------------------ ALERT_5 ---------------------
                          (CASE
                              WHEN     NVL (a.id_utente, -1) = -1
                                   AND NVL (a.flg_riportafogliato, 0) = 0
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_5,
                          ------------------ ALERT_6 ---------------------
                          (CASE
                              WHEN     a.cod_macrostato = 'RIO'
                                   AND EXISTS
                                          (SELECT DISTINCT 1
                                             FROM t_mcre0_app_rio_azioni z
                                            WHERE     z.cod_abi_cartolarizzato =
                                                         a.cod_abi_cartolarizzato
                                                  AND z.cod_ndg = a.cod_ndg
                                                  AND z.dta_scadenza <
                                                         TRUNC (SYSDATE)
                                                  AND z.flg_status != 'C'
                                                  AND z.flg_delete = 0)
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_6,
                          ------------------ ALERT_7 ---------------------
                          (CASE
                              WHEN     a.cod_macrostato IN ('RIO')
                                   --IN('RIO', 'IN', 'RS', 'SC')-- 14/01/13 estensione a IN, RS e SC commentata
                                   AND NOT EXISTS
                                              (SELECT DISTINCT 1
                                                 FROM v_mcre0_app_rio_azioni v
                                                WHERE (   (    NVL (
                                                                  a.cod_gruppo_economico,
                                                                  -1) != -1
                                                           AND v.cod_gruppo_economico =
                                                                  a.cod_gruppo_economico)
                                                       OR (    NVL (
                                                                  a.cod_gruppo_economico,
                                                                  -1) = -1
                                                           AND v.cod_abi_cartolarizzato =
                                                                  a.cod_abi_cartolarizzato
                                                           AND v.cod_ndg =
                                                                  a.cod_ndg)) --AND v.cod_tipologia_pratica IS NOT NULL
                                                                             --18/10: commentata modifica per lo sdoppiamento dell'alert
                                           )
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_7,
                          ------------------ ALERT_8 ---------------------
                          (CASE
                              WHEN (   (a.cod_stato = 'GB')
                                    OR (    a.cod_stato = 'PT'
                                        AND EXISTS
                                               (SELECT 1
                                                  FROM t_mcre0_app_pt_gestione_tavoli t
                                                 WHERE     t.cod_abi_cartolarizzato =
                                                              a.cod_abi_cartolarizzato
                                                       AND t.cod_ndg =
                                                              a.cod_ndg
                                                       AND t.flg_workflow = 4))
                                    OR (    a.cod_macrostato = 'RIO'
                                        AND (   EXISTS
                                                   (SELECT 1
                                                      FROM t_mcre0_app_rio_gestione g
                                                     WHERE     g.cod_abi_cartolarizzato =
                                                                  a.cod_abi_cartolarizzato
                                                           AND g.cod_ndg =
                                                                  a.cod_ndg
                                                           AND g.flg_workflow =
                                                                  3
                                                           --escludo eventuali destinazioni RIO non sbiancate o cancellate
                                                           AND NVL (
                                                                  flg_delete,
                                                                  0) = 0
                                                           AND NULLIF (
                                                                  g.cod_macrostato_destinazione,
                                                                  'RIO')
                                                                  IS NOT NULL)
                                             OR EXISTS
                                                   (SELECT 1
                                                      FROM t_mcrei_app_delibere d
                                                     WHERE     d.cod_abi =
                                                                  a.cod_abi_cartolarizzato
                                                           AND d.cod_ndg =
                                                                  a.cod_ndg
                                                           AND d.cod_microtipologia_delib IN
                                                                  ('CI', 'CS')
                                                           AND d.cod_tipo_pacchetto !=
                                                                  'A'
                                                           AND d.cod_fase_delibera NOT IN
                                                                  ('AN', 'VA')
                                                           AND d.flg_no_delibera =
                                                                  0
                                                           AND d.flg_attiva =
                                                                  '1'  --15/01
                                                                     )))
                                    OR (    a.cod_macrostato IN ('SC')
                                        AND EXISTS
                                               (SELECT 1
                                                  FROM t_mcrei_app_delibere d
                                                 WHERE     d.cod_abi =
                                                              a.cod_abi_cartolarizzato
                                                       AND d.cod_ndg =
                                                              a.cod_ndg
                                                       AND d.cod_microtipologia_delib IN
                                                              ('CI', 'CS')
                                                       AND d.cod_tipo_pacchetto !=
                                                              'A'
                                                       AND d.cod_fase_delibera NOT IN
                                                              ('AN', 'VA')
                                                       AND d.flg_no_delibera =
                                                              0
                                                       AND d.flg_attiva = '1' --15/01
                                                                             ))
                                    OR (    a.cod_stato IN ('IN', 'RS')
                                        AND EXISTS
                                               (SELECT 1
                                                  FROM t_mcrei_app_delibere d
                                                 WHERE     d.cod_abi =
                                                              a.cod_abi_cartolarizzato
                                                       AND d.cod_ndg =
                                                              a.cod_ndg
                                                       AND d.cod_microtipologia_delib =
                                                              'CS'
                                                       AND d.cod_tipo_pacchetto !=
                                                              'A'
                                                       AND d.cod_fase_delibera NOT IN
                                                              ('AN', 'VA')
                                                       AND d.flg_no_delibera =
                                                              0
                                                       AND d.flg_attiva = '1')))
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_8,
                          ------------------ ALERT_11 ---------------------
                          (CASE
                              WHEN (   (    b.val_livello = 'DIREZIONE'
                                        AND a.cod_macrostato IN
                                               ('RIO', 'IN', 'RS')
                                        AND EXISTS
                                               (SELECT DISTINCT 1
                                                  FROM t_mcre0_app_rio_proroghe p
                                                 WHERE     p.cod_abi_cartolarizzato =
                                                              a.cod_abi_cartolarizzato
                                                       AND p.cod_ndg =
                                                              a.cod_ndg
                                                       AND flg_storico = 0
                                                       AND flg_esito = 1
                                                       AND p.id_ruolo_resp <
                                                              b.val_od_seconda_proroga
                                                       AND p.dta_presavisione
                                                              IS NULL
                                                       AND p.val_num_proroghe >
                                                              1))
                                    OR (    b.val_livello = 'DIVISIONE'
                                        AND a.cod_stato = 'OC'
                                        AND NOT EXISTS
                                                   (SELECT DISTINCT
                                                           CASE
                                                              WHEN val_liv_rischio_cli IN
                                                                      ('M',
                                                                       'MB',
                                                                       'B',
                                                                       'BB')
                                                              THEN
                                                                 0
                                                              ELSE
                                                                 1
                                                           END
                                                      FROM t_mcre0_app_iris i
                                                     WHERE i.cod_sndg =
                                                              a.cod_sndg)
                                        AND EXISTS
                                               (SELECT DISTINCT 1
                                                  FROM t_mcre0_app_rio_proroghe p
                                                 WHERE     p.cod_abi_cartolarizzato =
                                                              a.cod_abi_cartolarizzato
                                                       AND p.cod_ndg =
                                                              a.cod_ndg
                                                       AND flg_storico = 0
                                                       AND flg_esito = 1
                                                       AND p.id_ruolo_resp <
                                                              b.val_od_seconda_proroga
                                                       AND p.dta_presavisione
                                                              IS NULL
                                                       AND p.val_num_proroghe >
                                                              1)))
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_11,
                          ------------------ ALERT_12 ---------------------
                          (CASE
                              WHEN EXISTS
                                      (SELECT DISTINCT 1
                                         FROM t_mcre0_app_pef p
                                        WHERE     a.cod_abi_istituto =
                                                     p.cod_abi_istituto
                                              AND a.cod_ndg = p.cod_ndg
                                              AND NVL (dta_ultima_revisione,
                                                       SYSDATE + 1) <
                                                     TRUNC (SYSDATE))
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_12,
                          ------------------ ALERT_13 ---------------------
                          (CASE
                              WHEN     a.cod_macrostato = 'PT'
                                   AND NVL (a.id_utente, -1) != -1
                                   AND   TRUNC (SYSDATE)
                                       - a.dta_decorrenza_stato > 30
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_13,
                          ------------------ ALERT_14 ---------------------
                          (CASE
                              WHEN     a.id_utente != -1
                                   AND NVL (dta_utente_assegnato,
                                            TRUNC (SYSDATE) - 1) <
                                          TRUNC (SYSDATE)
                                   AND (SELECT DISTINCT perdita_attesa
                                          FROM t_mcre0_app_perdita_attesa i
                                         WHERE     a.cod_ndg = i.cod_ndg
                                               AND a.cod_abi_cartolarizzato =
                                                      i.cod_abi) >
                                          (SELECT DISTINCT val_pa * 1.01
                                             FROM mv_mcre0_app_scheda_anag_scpc2 s
                                            WHERE     a.cod_abi_cartolarizzato =
                                                         s.cod_abi_cartolarizzato
                                                  AND a.cod_ndg = s.cod_ndg)
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_14,
                          ------------------ ALERT_15 ---------------------
                          (CASE
                              WHEN     a.cod_macrostato = 'RIO'
                                   AND EXISTS
                                          (SELECT DISTINCT 1
                                             FROM t_mcre0_app_rio_azioni z
                                            WHERE     z.cod_abi_cartolarizzato =
                                                         a.cod_abi_cartolarizzato
                                                  AND z.cod_ndg = a.cod_ndg
                                                  AND (  z.dta_scadenza
                                                       - TRUNC (SYSDATE)) <=
                                                         30
                                                  AND (  dta_scadenza
                                                       - TRUNC (SYSDATE)) >=
                                                         0
                                                  AND z.flg_status != 'C')
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_15,
                          ------------------ ALERT_16 ---------------------
                          (CASE
                              WHEN     (   (    a.cod_stato_precedente = 'PT'
                                            AND EXISTS
                                                   (SELECT 1
                                                      FROM t_mcre0_app_pt_gestione_tavoli g
                                                     WHERE     g.cod_abi_cartolarizzato =
                                                                  a.cod_abi_cartolarizzato
                                                           AND g.cod_ndg =
                                                                  a.cod_ndg
                                                           AND g.flg_workflow =
                                                                  5))
                                        OR (    a.cod_stato_precedente IN
                                                   (SELECT cod_microstato
                                                      FROM t_mcre0_app_stati
                                                     WHERE cod_macrostato =
                                                              'RIO')
                                            AND EXISTS
                                                   (SELECT 1
                                                      FROM t_mcre0_app_rio_gestione g
                                                     WHERE     g.cod_abi_cartolarizzato =
                                                                  a.cod_abi_cartolarizzato
                                                           AND g.cod_ndg =
                                                                  a.cod_ndg
                                                           AND g.flg_workflow =
                                                                  4)))
                                   AND EXISTS
                                          (SELECT DISTINCT 1
                                             FROM mv_mcre0_app_upd_field xx
                                            WHERE     xx.cod_sndg =
                                                         a.cod_sndg
                                                  AND xx.cod_stato !=
                                                         a.cod_stato
                                                  AND xx.cod_stato IN
                                                         (SELECT cod_microstato
                                                            FROM t_mcre0_app_stati s
                                                           WHERE s.flg_alert =
                                                                    1))
                                   AND (a.dta_decorrenza_stato >=
                                           TRUNC (SYSDATE) - 1)
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_16,
                          ------------------ ALERT_17 ---------------------
                          (CASE
                              WHEN     a.cod_macrostato = 'RIO'
                                   AND EXISTS
                                          (SELECT 1
                                             FROM t_mcre0_app_sab_xra x
                                            WHERE     x.cod_abi_cartolarizzato =
                                                         a.cod_abi_cartolarizzato
                                                  AND x.cod_ndg = a.cod_ndg
                                                  AND x.num_giorni_sconfino_rap >=
                                                         120)
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_17,
                          ------------------ ALERT_18 ---------------------
                          (CASE
                              WHEN     (   (    b.val_livello = 'DIREZIONE'
                                            AND a.cod_macrostato IN
                                                   ('IN', 'RIO', 'RS')
                                            AND dta_servizio IS NOT NULL
                                            AND b.cod_comparto != '011901'
                                            AND   NVL (
                                                     (SELECT   TRUNC (
                                                                  dta_esito)
                                                             + b.val_gg_seconda_proroga
                                                        FROM t_mcre0_app_rio_proroghe g
                                                       WHERE     g.cod_abi_cartolarizzato =
                                                                    a.cod_abi_cartolarizzato
                                                             AND g.cod_ndg =
                                                                    a.cod_ndg
                                                             AND g.flg_storico =
                                                                    0
                                                             AND g.flg_esito =
                                                                    1),
                                                       a.dta_servizio
                                                     + b.val_gg_prima_proroga)
                                                - TRUNC (SYSDATE) < 30)
                                        OR (b.val_livello = 'DIVISIONE' --                                    IN ('DIVISIONE', 'REGIONE',
 --                                                'AREA') --10/01/13 commento per escludere le estensioni a aree e regioni
                                             AND a.cod_stato = 'OC'))
                                   AND NOT EXISTS
                                              (SELECT DISTINCT 1
                                                 FROM t_mcre0_app_rio_proroghe g
                                                WHERE     g.cod_abi_cartolarizzato =
                                                             a.cod_abi_cartolarizzato
                                                      AND g.cod_ndg =
                                                             a.cod_ndg
                                                      AND g.dta_richiesta
                                                             IS NOT NULL
                                                      AND g.flg_esito IS NULL
                                                      AND g.flg_storico = 0)
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_18,
                          ------------------ ALERT_19 ---------------------
                          (CASE
                              WHEN (   (    b.val_livello = 'DIREZIONE'
                                        AND a.cod_macrostato IN
                                               ('IN', 'RIO', 'RS')
                                        AND EXISTS
                                               (SELECT DISTINCT 1
                                                  FROM t_mcre0_app_rio_proroghe g
                                                 WHERE     g.cod_abi_cartolarizzato =
                                                              a.cod_abi_cartolarizzato
                                                       AND g.cod_ndg =
                                                              a.cod_ndg
                                                       AND g.dta_richiesta
                                                              IS NOT NULL
                                                       AND g.flg_esito
                                                              IS NULL
                                                       AND g.flg_storico = 0))
                                    OR (    b.val_livello = 'DIVISIONE' --                                    IN ('DIVISIONE', 'AREA',
                                        --                                                'REGIONE') --10/01/13 commento per escludere l'estensione a aree e regioni
                                        AND cod_stato = 'OC'
                                        AND 1 =
                                               (SELECT DISTINCT
                                                       CASE
                                                          WHEN val_liv_rischio_cli IN
                                                                  ('M',
                                                                   'MB',
                                                                   'B',
                                                                   'BB')
                                                          THEN
                                                             0
                                                          ELSE
                                                             1
                                                       END
                                                  FROM t_mcre0_app_iris i
                                                 WHERE i.cod_sndg =
                                                          a.cod_sndg)
                                        AND EXISTS
                                               (SELECT DISTINCT 1
                                                  FROM t_mcre0_app_rio_proroghe g
                                                 WHERE     g.cod_abi_cartolarizzato =
                                                              a.cod_abi_cartolarizzato
                                                       AND g.cod_ndg =
                                                              a.cod_ndg
                                                       AND g.dta_richiesta
                                                              IS NOT NULL
                                                       AND g.flg_esito
                                                              IS NULL
                                                       AND g.flg_storico = 0
                                                       AND NVL (
                                                              g.val_num_proroghe,
                                                              0) > 0)))
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_19,
                          ------------------ ALERT_20 ---------------------
                          (CASE
                              WHEN     a.cod_macrostato IN
                                          ('IN', 'RIO', 'RS')
                                   AND EXISTS
                                          (SELECT DISTINCT 1
                                             FROM t_mcre0_app_rio_proroghe g
                                            WHERE     g.cod_abi_cartolarizzato =
                                                         a.cod_abi_cartolarizzato
                                                  AND g.cod_ndg = a.cod_ndg
                                                  AND g.flg_esito = 0
                                                  AND g.flg_storico = 0)
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_20,
                          ------------------ ALERT_21 ---------------------
                          (CASE
                              WHEN     a.cod_macrostato IN
                                          ('RIO', 'IN', 'SC', 'RS')
                                   AND a.cod_comparto = '011901'
                                   AND (  TRUNC (SYSDATE)
                                        - TRUNC (dta_servizio)) >
                                          b.val_gg_prima_proroga - 30
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_21,
                          ------------------ ALERT_22 ---------------------
                          (CASE
                              WHEN EXISTS
                                      (SELECT DISTINCT 1
                                         FROM mv_mcre0_app_cr_new s
                                        WHERE     s.cod_abi_cartolarizzato =
                                                     a.cod_abi_cartolarizzato
                                              AND s.cod_ndg = a.cod_ndg
                                              AND cod_stato_sis = 'SO')
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_22,
                          ------------------ ALERT_23 ---------------------
                          (CASE
                              WHEN EXISTS
                                      (SELECT DISTINCT 1
                                         FROM mv_mcre0_app_cr_new s
                                        WHERE     s.cod_abi_cartolarizzato =
                                                     a.cod_abi_cartolarizzato
                                              AND s.cod_ndg = a.cod_ndg
                                              AND cod_stato_sis = 'RI')
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_23,
                          --                          ------------------ ALERT_24 ---------------------
                          --                          (CASE
                          --                              WHEN EXISTS (
                          --                                     SELECT DISTINCT 1
                          --                                                FROM mv_mcre0_app_cr_new s
                          --                                               WHERE s.cod_abi_cartolarizzato =
                          --                                                        a.cod_abi_cartolarizzato
                          --                                                 AND s.cod_ndg = a.cod_ndg
                          --                                                 AND cod_stato_sis IN
                          --                                                                ('180', '90'))
                          --                                 THEN 1
                          --                              ELSE 0
                          --                           END
                          --                          ) alert_24,

                          ------------------ ALERT_25 ---------------------
                          (CASE
                              WHEN     a.id_utente != -1
                                   AND NVL (a.dta_utente_assegnato,
                                            TRUNC (SYSDATE) - 1) <
                                          TRUNC (SYSDATE)
                                   AND (SELECT DISTINCT
                                               TO_NUMBER (scgb_qis_uti)
                                          FROM t_mcre0_app_cr c
                                         WHERE     fnd_mcre0_is_numeric (
                                                      scgb_qis_uti) = 1
                                               AND a.cod_abi_cartolarizzato =
                                                      c.cod_abi_cartolarizzato
                                               AND a.cod_ndg = c.cod_ndg) >
                                          (SELECT DISTINCT
                                                  TO_NUMBER (scgb_qis_uti)
                                             FROM mv_mcre0_app_scheda_anag_scpc2 s
                                            WHERE     fnd_mcre0_is_numeric (
                                                         scgb_qis_uti) = 1
                                                  AND a.cod_abi_cartolarizzato =
                                                         s.cod_abi_cartolarizzato
                                                  AND a.cod_ndg = s.cod_ndg)
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_25,
                          ------------------ ALERT_40 ---------------------
                          (CASE
                              WHEN ( (    b.val_livello = 'DIVISIONE'
                                      --                              IN ('DIVISIONE', 'AREA', 'REGIONE')--10/01/13 commento per escludere l'estensione a aree e regioni
                                      AND a.id_utente IS NOT NULL
                                      AND a.cod_stato = 'OC'
                                      AND EXISTS
                                             (SELECT DISTINCT 1
                                                FROM t_mcre0_app_rio_proroghe g
                                               WHERE     g.cod_abi_cartolarizzato =
                                                            a.cod_abi_cartolarizzato
                                                     AND g.cod_ndg =
                                                            a.cod_ndg
                                                     AND g.dta_richiesta
                                                            IS NOT NULL
                                                     AND g.flg_esito IS NULL
                                                     AND g.flg_storico = 0
                                                     --                                                     AND g.id_utente =  --14/02 Commentata condizione di join sull'utente. Da ripristinare.
                                                     --                                                            a.id_utente
                                                     AND (   NVL (
                                                                g.val_num_proroghe,
                                                                0) = 0
                                                          OR (    NVL (
                                                                     g.val_num_proroghe,
                                                                     0) > 0
                                                              AND EXISTS
                                                                     (SELECT DISTINCT
                                                                             1
                                                                        FROM t_mcre0_app_iris i
                                                                       WHERE     i.cod_sndg =
                                                                                    a.cod_sndg
                                                                             AND val_liv_rischio_cli IN
                                                                                    ('M',
                                                                                     'MB',
                                                                                     'B',
                                                                                     'BB')))))))
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_40,
                          ------------------ ALERT_41 ---------------------
                          (CASE
                              WHEN EXISTS
                                      (SELECT DISTINCT 1
                                         FROM t_mcre0_app_pregiudizievoli p
                                        WHERE     p.cod_sndg = a.cod_sndg
                                              AND id_dper =
                                                     (SELECT idper
                                                        FROM v_mcre0_ultima_acquisizione
                                                       WHERE cod_file =
                                                                'PREGIUDIZIEVOLI'))
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                             alert_41
                     -------------------- ALERT_45 ---------------------
                     --                          (CASE
                     --                              WHEN a.cod_macrostato IN ('RIO')
                     ----IN('RIO', 'IN', 'RS', 'SC')-- 14/01/13 estensione a IN, RS e SC commentata
                     --                              AND NOT EXISTS (
                     --                                     SELECT DISTINCT 1
                     --                                                FROM v_mcre0_app_rio_azioni v
                     --                                               WHERE (   (    NVL
                     --                                                                 (a.cod_gruppo_economico,
                     --                                                                  -1
                     --                                                                 ) != -1
                     --                                                          AND v.cod_gruppo_economico =
                     --                                                                 a.cod_gruppo_economico
                     --                                                         )
                     --                                                      OR (    NVL
                     --                                                                 (a.cod_gruppo_economico,
                     --                                                                  -1
                     --                                                                 ) = -1
                     --                                                          AND v.cod_abi_cartolarizzato =
                     --                                                                 a.cod_abi_cartolarizzato
                     --                                                          AND v.cod_ndg =
                     --                                                                     a.cod_ndg
                     --                                                         )
                     --                                                     )
                     --                                                 AND v.cod_azione IS NOT NULL)
                     --                                 THEN 1
                     --                              ELSE 0
                     --                           END
                     --                          ) alert_45
                     FROM v_mcre0_app_upd_fields_p1 a,
                          t_mcre0_app_comparti b,
                          mv_mcre0_app_istituti c,
                          t_mcre0_app_stati d
                    WHERE     a.cod_comparto = b.cod_comparto
                          AND a.cod_stato = d.cod_microstato
                          AND (   b.flg_chk = '1'
                               OR a.dta_last_riportaf BETWEEN   TRUNC (
                                                                   SYSDATE)
                                                              - 30
                                                          AND TRUNC (
                                                                 SYSDATE + 1))
                          AND d.flg_alert = '1'
                          AND a.cod_abi_cartolarizzato = c.cod_abi
                          AND NVL (a.flg_outsourcing, 'N') = 'Y'
                          AND c.flg_target = 'Y') m,
                  t_mcre0_app_alert_pos tmp
            WHERE     m.cod_abi_cartolarizzato =
                         tmp.cod_abi_cartolarizzato(+)
                  AND m.cod_ndg = tmp.cod_ndg(+)) h;
