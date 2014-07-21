/* Formatted on 21/07/2014 18:38:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_ALERT_FLG_PR_VIS
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   ALERT,
   COD_STATO,
   DTA_INS,
   DTA_UPD,
   FLG_WORSE_UPD,
   VAL_CNT_RAPPORTI,
   VAL_CNT_DELIBERE,
   VAL_ORDINE_COLORE,
   ID_ALERT_DA_ESPORRE,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT "ID_ALERT",
          "COD_ABI",
          "COD_NDG",
          "COD_SNDG",
          "COD_ABI_CARTOLARIZZATO",
          "COD_ABI_ISTITUTO",
          "ALERT",
          "COD_STATO",
          "DTA_INS",
          "DTA_UPD",
          "FLG_WORSE_UPD",
          "VAL_CNT_RAPPORTI",
          "VAL_CNT_DELIBERE",
          "VAL_ORDINE_COLORE",
          "ID_ALERT_DA_ESPORRE",
          "COD_PROTOCOLLO_DELIBERA"
     FROM T_MCREI_APP_ALERT_POS_WRK W
    WHERE W.ID_ALERT != 48
   UNION
   SELECT W."ID_ALERT",
          W."COD_ABI",
          W."COD_NDG",
          W."COD_SNDG",
          W."COD_ABI_CARTOLARIZZATO",
          W."COD_ABI_ISTITUTO",
          W."ALERT",
          W."COD_STATO",
          W."DTA_INS",
          W."DTA_UPD",
          W."FLG_WORSE_UPD",
          W."VAL_CNT_RAPPORTI",
          W."VAL_CNT_DELIBERE",
          W."VAL_ORDINE_COLORE",
          W."ID_ALERT_DA_ESPORRE",
          W."COD_PROTOCOLLO_DELIBERA"
     FROM T_MCREI_APP_ALERT_POS_WRK W, T_MCREI_APP_ALERT_FLG_PR_VIS PV
    WHERE     W.COD_ABI = PV.COD_ABI(+)
          AND W.COD_NDG = PV.COD_NDG(+)
          AND W.ID_ALERT = pv.id_Alert(+)
          AND W.ID_ALERT = 48
          AND TRUNC (NVL (PV.DTA_PR_VIS, TO_DATE ('01011000', 'DDMMYYYY'))) <=
                 TRUNC (W.DTA_INS);
