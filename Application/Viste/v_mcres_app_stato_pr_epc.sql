/* Formatted on 21/07/2014 18:43:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_STATO_PR_EPC
(
   COD_ABI,
   COD_NDG,
   COD_PROCEDURA,
   COD_TIPOPROCEDURA,
   VAL_DESC_TIPOPROCEDURA,
   COD_STATOPROCEDURA,
   DTA_AP_PROCEDURA,
   DTA_CH_PROCEDURA,
   COD_USER_ID,
   VAL_NOMINATIVO_LEGALE,
   COD_FASE,
   COD_TIPOFASE,
   VAL_DESC_TIPOFASE,
   COD_OPERATORE_INS_UPD
)
AS
   SELECT PR.COD_ABI,
          PR.COD_NDG,
          PR.COD_PROCEDURA,
          PR.COD_TIPOPROCEDURA,
          PR.VAL_DESC_TIPOPROCEDURA,
          PR.COD_STATOPROCEDURA,
          PR.DTA_AP_PROCEDURA,
          PR.DTA_CH_PROCEDURA,
          PR.COD_USER_ID,
          PR.VAL_NOMINATIVO_LEGALE,
          PR.COD_FASE,
          PR.COD_TIPOFASE,
          PR.VAL_DESC_TIPOFASE,
          PR.COD_OPERATORE_INS_UPD
     FROM T_MCRES_APP_STATO_PR_EPC PR
    WHERE 1 = 1;
