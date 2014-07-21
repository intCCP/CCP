/* Formatted on 21/07/2014 18:43:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_TIPO_DEL_VALIDE0
(
   COD_ABI,
   COD_DELIBERA,
   DESC_DELIBERA,
   VAL_ORDINE
)
AS
   SELECT cod_abi,
          COD_DELIBERA,
          DESC_DELIBERA,
          val_ordine
     FROM (SELECT a.*,
                  SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 4)
                     val_anno_pratica,
                  SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 5, 11)
                     COD_PRATICA
             FROM T_MCRES_CL_TIPO_DELIBERA a) TIPO
    WHERE     (   (    tipo.cod_delibera = 'NS'
                   AND NOT EXISTS
                              (SELECT DISTINCT 1
                                 FROM V_MCRES_APP_ELENCO_DELIBERE EL
                                WHERE     el.cod_pratica = tipo.cod_pratica
                                      AND EL.VAL_ANNO_PRATICA =
                                             tipo.val_anno_pratica
                                      AND el.cod_delibera = tipo.cod_delibera
                                      AND EL.COD_STATO_DELIBERA <> 'AN'))
               OR (    tipo.cod_delibera IN ('RV', 'AS')
                   AND EXISTS
                          (SELECT DISTINCT 1
                             FROM v_mcres_app_elenco_delibere el
                            WHERE     el.cod_pratica = tipo.cod_pratica
                                  AND EL.VAL_ANNO_PRATICA =
                                         tipo.val_anno_pratica
                                  AND el.cod_delibera IN ('NS', 'IS')
                                  AND el.cod_stato_delibera = 'CO')
                   AND NOT EXISTS
                              (SELECT DISTINCT 1
                                 FROM v_mcres_app_elenco_delibere el
                                WHERE     el.cod_pratica = tipo.cod_pratica
                                      AND EL.VAL_ANNO_PRATICA =
                                             tipo.val_anno_pratica
                                      AND (   el.cod_delibera = 'NZ'
                                           OR (    el.cod_delibera IN
                                                      ('AS', 'RV')
                                               AND el.cod_stato_delibera IN
                                                      ('IN', 'IT')))))
               OR (    tipo.cod_delibera IN ('TS', 'TT', 'SN')
                   AND EXISTS
                          (SELECT DISTINCT 1
                             FROM v_mcres_app_elenco_delibere el
                            WHERE     el.cod_pratica = tipo.cod_pratica
                                  AND EL.VAL_ANNO_PRATICA =
                                         tipo.val_anno_pratica
                                  AND el.cod_delibera IN ('NS', 'IS')
                                  AND el.cod_stato_delibera = 'CO')
                   AND NOT EXISTS
                              (SELECT DISTINCT 1
                                 FROM v_mcres_app_elenco_delibere el
                                WHERE     el.cod_pratica = tipo.cod_pratica
                                      AND EL.VAL_ANNO_PRATICA =
                                             tipo.val_anno_pratica
                                      AND el.cod_stato_delibera IN
                                             ('IN', 'IT')))
               OR (    tipo.cod_delibera IN ('RE', 'ES')
                   AND NOT EXISTS
                              (SELECT DISTINCT 1
                                 FROM v_mcres_app_elenco_delibere el
                                WHERE     el.cod_pratica = tipo.cod_pratica
                                      AND EL.VAL_ANNO_PRATICA =
                                             tipo.val_anno_pratica
                                      AND el.cod_delibera = 'NZ')
                   AND EXISTS
                          (SELECT DISTINCT 1
                             FROM v_mcres_app_elenco_delibere el
                            WHERE     el.cod_pratica = tipo.cod_pratica
                                  AND EL.VAL_ANNO_PRATICA =
                                         tipo.val_anno_pratica
                                  AND el.cod_delibera IN ('NS', 'IS')
                                  AND el.cod_stato_delibera = 'CO'))
               OR (    TIPO.COD_DELIBERA = 'TP'
                   AND EXISTS
                          (SELECT DISTINCT 1
                             FROM v_mcres_app_elenco_delibere el
                            WHERE     el.cod_pratica = tipo.cod_pratica
                                  AND EL.VAL_ANNO_PRATICA =
                                         tipo.val_anno_pratica
                                  AND el.cod_delibera IN ('NS', 'IS')
                                  AND el.cod_stato_delibera = 'CO')
                   AND NOT EXISTS
                              (SELECT DISTINCT 1
                                 FROM v_mcres_app_elenco_delibere el
                                WHERE     el.cod_pratica = tipo.cod_pratica
                                      AND EL.VAL_ANNO_PRATICA =
                                             tipo.val_anno_pratica
                                      AND el.cod_delibera != 'TP'
                                      AND el.cod_stato_delibera IN
                                             ('IN', 'IT'))))
          AND SYSDATE BETWEEN TIPO.DTA_INIZIO AND TIPO.DTA_SCADENZA
          AND tipo.flg_forfetaria = 'S';
