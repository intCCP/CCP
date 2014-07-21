/* Formatted on 21/07/2014 18:41:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_RAPPCMLT
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   DESC_ISTITUTO,
   DESC_INTESTAZIONE,
   VAL_ANNO_PRATICA,
   VAL_NUM_PRATICA,
   DTA_RICH_RISOL,
   COD_UO_COMPETENTE,
   COD_CAPOFILA,
   COD_PROD_RAPP,
   VAL_NUM_PROG_RAPP,
   FLG_ROUT,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   ALERT,
   DTA_AGGIORNAMENTO,
   FLG_GESTIONE,
   FLG_RAPP_FONDO_TERZO
)
AS
   SELECT '45' id_alert,
          RPPCMLT.COD_ABI,
          RPPCMLT.COD_NDG,
          IST.DESC_ISTITUTO,
          AG.DESC_NOME_CONTROPARTE DESC_INTESTAZIONE,
          RPPCMLT.VAL_ANNO_PRATICA,
          RPPCMLT.VAL_NUM_PRATICA,
          RPPCMLT.DTA_RICH_RISOL,
          PR.COD_UO_PRATICA COD_UO_COMPETENTE,
          POS.COD_FILIALE_PRINCIPALE COD_CAPOFILA,
          RPPCMLT.COD_PROD_RAPP,
          RPPCMLT.VAL_NUM_PROG_RAPP,
          RPPCMLT.FLG_ROUT,
          PR.COD_UO_PRATICA,
          PR.COD_MATR_PRATICA,
          CASE
             WHEN TRUNC (SYSDATE) - TRUNC (RPPCMLT.DTA_RICH_RISOL) <=
                     gest.val_current_green
             THEN
                'V'
             WHEN TRUNC (SYSDATE) - TRUNC (RPPCMLT.DTA_RICH_RISOL) BETWEEN   gest.val_current_green
                                                                           + 1
                                                                       AND gest.val_current_orange
             THEN
                'A'
             WHEN TRUNC (SYSDATE) - TRUNC (RPPCMLT.DTA_RICH_RISOL) >
                     gest.val_current_orange
             THEN
                'R'
             ELSE
                'X'
          END
             ALERT,
          RPPCMLT.DTA_UPD DTA_AGGIORNAMENTO,
          LP.VAL_TIPO_GESTIONE FLG_GESTIONE,
          RPP.FLG_RAPP_FONDO_TERZO
     FROM T_MCRES_APP_RAPPCMLT RPPCMLT
          JOIN
          T_MCRES_APP_PRATICHE PR
             ON     RPPCMLT.COD_ABI = PR.COD_ABI
                AND RPPCMLT.VAL_NUM_PRATICA = PR.COD_PRATICA
                AND RPPCMLT.VAL_ANNO_PRATICA = PR.VAL_ANNO
          LEFT JOIN T_MCRE0_APP_ANAGRAFICA_GRUPPO AG
             ON AG.COD_SNDG = PR.COD_SNDG
          JOIN T_MCRES_APP_GESTIONE_ALERT gest ON (gest.id_alert = 45)
          JOIN
          t_mcres_app_posizioni pos
             ON (    pos.cod_ndg = RPPCMLT.cod_ndg
                 AND pos.cod_abi = RPPCMLT.cod_abi)
          JOIN t_mcres_app_istituti ist ON (ist.cod_abi = RPPCMLT.cod_abi)
          LEFT JOIN v_mcres_app_lista_presidi lp
             ON (lp.cod_presidio = pr.cod_uo_pratica)
          JOIN
          T_MCRES_APP_RAPPORTI RPP
             ON (    RPP.COD_ABI = RPPCMLT.COD_ABI
                 AND RPP.COD_NDG = RPPCMLT.COD_NDG
                 AND RPP.COD_UO_RAPPORTO = RPPCMLT.COD_UO_RAPP)
    WHERE     1 = 1
          AND TRUNC (RPPCMLT.DTA_UPD) =
                 (SELECT TRUNC (MAX (DTA_UPD)) FROM T_MCRES_APP_RAPPCMLT);
