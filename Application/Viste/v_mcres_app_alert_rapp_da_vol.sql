/* Formatted on 21/07/2014 18:41:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_RAPP_DA_VOL
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   DESC_ISTITUTO,
   DESC_INTESTAZIONE,
   VAL_ADDETTO,
   VAL_ANNO_PRATICA,
   VAL_NUM_PRATICA,
   VAL_DTA_PASS_SOFF,
   COD_UO_COMPETENTE,
   COD_CAPOFILA,
   COD_PROD_RAPP,
   VAL_NUM_PROG_RAPP,
   FLG_ANOMALO,
   FLG_RAPP_ANOMALO,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   ALERT,
   DTA_AGGIORNAMENTO
)
AS
   SELECT '40' id_alert,
          RPDV.COD_ABI,
          RPDV.COD_NDG,
          IST.DESC_ISTITUTO,
          AG.DESC_NOME_CONTROPARTE DESC_INTESTAZIONE,
          RPDV.VAL_ADDETTO,
          RPDV.VAL_ANNO_PRATICA,
          RPDV.VAL_NUM_PRATICA,
          RPDV.DTA_PASS_SOFF VAL_DTA_PASS_SOFF,
          PR.COD_UO_PRATICA COD_UO_COMPETENTE,
          POS.COD_FILIALE_PRINCIPALE COD_CAPOFILA,
          RPDV.COD_PROD_RAPP,
          RPDV.VAL_NUM_PROG_RAPP,
          RPDV.FLG_ANOMALO,
          RPDV.FLG_RAPP_ANOMALO,
          PR.COD_UO_PRATICA,
          PR.COD_MATR_PRATICA,
          CASE
             WHEN TRUNC (SYSDATE) - TRUNC (RPDV.DTA_PASS_SOFF) <=
                     gest.val_current_green
             THEN
                'V'
             WHEN TRUNC (SYSDATE) - TRUNC (RPDV.DTA_PASS_SOFF) BETWEEN   gest.val_current_green
                                                                       + 1
                                                                   AND gest.val_current_orange
             THEN
                'A'
             WHEN TRUNC (SYSDATE) - TRUNC (RPDV.DTA_PASS_SOFF) >
                     gest.val_current_orange
             THEN
                'R'
             ELSE
                'X'
          END
             ALERT,
          RPDV.DTA_UPD DTA_AGGIORNAMENTO
     FROM T_MCRES_APP_RAPPDAVOLT RPDV
          JOIN
          T_MCRES_APP_PRATICHE PR
             ON     RPDV.COD_ABI = PR.COD_ABI
                AND RPDV.VAL_NUM_PRATICA = PR.COD_PRATICA
                AND RPDV.VAL_ANNO_PRATICA = PR.VAL_ANNO
          LEFT JOIN T_MCRE0_APP_ANAGRAFICA_GRUPPO AG
             ON AG.COD_SNDG = PR.COD_SNDG
          JOIN T_MCRES_APP_GESTIONE_ALERT gest ON (gest.id_alert = 40)
          JOIN t_mcres_app_posizioni pos
             ON (pos.cod_ndg = rpdv.cod_ndg AND pos.cod_abi = rpdv.cod_abi)
          JOIN t_mcres_app_istituti ist ON (ist.cod_abi = rpdv.cod_abi)
    WHERE     1 = 1
          AND TRUNC (RPDV.DTA_UPD) =
                 (SELECT TRUNC (MAX (DTA_UPD)) FROM T_MCRES_APP_RAPPDAVOLT);
