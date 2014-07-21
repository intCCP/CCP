/* Formatted on 21/07/2014 18:44:39 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_ESITI_LOAD_SP_ITF
(
   COD_SOURCE,
   ID_DPER,
   ID_ESITO,
   DESC_ESITO,
   COD_AUTORIZZAZIONE,
   COD_ABI,
   COD_NDG,
   COD_AUTORIZZAZIONE_PADRE,
   COD_TIPO_AUTORIZZAZIONE,
   VAL_ANNO_PRATICA,
   COD_PRATICA,
   COD_STATO,
   VAL_NUMERO_FATTURA,
   DTA_FATTURA
)
AS
   SELECT                                --  20121122    AG  Created this view
         'ITF' cod_source,
          TO_CHAR (SYSDATE - 1 / 3, 'yyyymmdd') id_dper,
          --
          CASE
             WHEN 0 = 0                          -- Non acquisita per anomalie
                       AND sc.cod_autorizzazione IS NOT NULL
             --then '20'
             THEN
                sc.cod_causa_scarto
             /*when 0=0    -- Acquisita e da confermare (Inviata per calcolo UO e OD)
                 and app.cod_autorizzazione is not null
                     then '10'*/
             WHEN     0 = 0
                  AND app.cod_autorizzazione IS NOT NULL
                  AND app.flg_fornitore_non_censito = 0
             THEN
                '1000'
             WHEN     0 = 0
                  AND app.cod_autorizzazione IS NOT NULL
                  AND app.flg_fornitore_non_censito = 1
             THEN
                '1001'
             WHEN     0 = 0
                  AND app.cod_autorizzazione IS NOT NULL
                  AND app.flg_fornitore_non_censito = 2
             THEN
                '1002'
          END
             id_esito,
          --
          CASE
             WHEN 0 = 0                          -- Non acquisita per anomalie
                       AND sc.cod_autorizzazione IS NOT NULL
             THEN
                sc.desc_causa_scarto
             WHEN     0 = 0
                  AND app.cod_autorizzazione IS NOT NULL
                  AND app.flg_fornitore_non_censito = 0
             THEN
                'Acquisita e da confermare'
             WHEN     0 = 0
                  AND app.cod_autorizzazione IS NOT NULL
                  AND app.flg_fornitore_non_censito = 1
             THEN
                'Acquisita con fornitore non censito'
             WHEN     0 = 0
                  AND app.cod_autorizzazione IS NOT NULL
                  AND app.flg_fornitore_non_censito = 2
             THEN
                'Acquisita con fornitore non attivo'
          END
             desc_esito,
          --
          SUBSTR (l.cod_autorizzazione, 1, 20) cod_autorizzazione,
          app.cod_abi,
          SUBSTR (app.cod_ndg, -13) cod_ndg,
          app.cod_autorizzazione_padre,
          app.cod_tipo_autorizzazione,
          app.val_anno_pratica,
          app.cod_pratica,
          app.cod_stato,
          app.val_numero_fattura,
          app.dta_fattura
     FROM t_mcres_wrk_cod_aut_spese_itf l,
          v_mcres_wrk_sc_etl_spese_itf sc,
          t_mcres_app_spese_itf app
    WHERE     0 = 0
          AND l.cod_autorizzazione = sc.cod_autorizzazione(+)
          AND l.cod_autorizzazione = app.cod_autorizzazione(+);
