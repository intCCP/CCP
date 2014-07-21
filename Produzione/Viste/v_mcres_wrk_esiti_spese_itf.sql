/* Formatted on 17/06/2014 18:13:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_ESITI_SPESE_ITF
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
   SELECT                                --  20121102    AG  Created this view
              --  20121105    AG  Gestione descrizione esito in caso di scarto
         'ITF' cod_source,
         TO_CHAR (SYSDATE - 1 / 3, 'yyyymmdd') id_dper,
         --
         CASE
            WHEN     0 = 0              -- Acquisita e confermata in autonomia
                 AND app.cod_autorizzazione IS NOT NULL
                 AND app.cod_stato = 'A'
                 AND cod_uo_proposto = cod_uo_calcolato
            THEN
               '00'
            WHEN     0 = 0 -- Acquisita e da confermare (RUI deve verificare se in facolta)
                 AND app.cod_autorizzazione IS NOT NULL
                 AND app.cod_stato = 'A'
                 AND cod_uo_proposto != cod_uo_calcolato
            THEN
               '10'
            WHEN     0 = 0 -- Acquisita e da confermare (espressamente non in facoltà)
                 AND app.cod_autorizzazione IS NOT NULL
                 AND app.cod_stato = 'P'
            THEN
               '10'
            WHEN 0 = 0                           -- Non acquisita per anomalie
                      AND sc.cod_autorizzazione IS NOT NULL
            THEN
               '20'
         END
            id_esito,
         --
         CASE
            --        when 0=0    -- Acquisita e confermata in autonomia
            --            and app.cod_autorizzazione is not null
            --            and app.cod_stato = 'A'
            --            and cod_uo_proposto = cod_uo_calcolato
            --                then 'Acquisita e confermata in autonomia'
            --        when 0=0    -- Acquisita e da confermare (RUI deve verificare se in facolta)
            --            and app.cod_autorizzazione is not null
            --            and app.cod_stato = 'A'
            --            and cod_uo_proposto != cod_uo_calcolato
            --                then 'Acquisita e da confermare'
            --        when 0=0    -- Acquisita e da confermare (espressamente non in facoltà)
            --            and app.cod_autorizzazione is not null
            --            and app.cod_stato = 'P'
            --                then 'Acquisita e da confermare'
            WHEN 0 = 0 AND app.cod_autorizzazione IS NOT NULL
            THEN
               'Acquisita e da confermare'
            WHEN 0 = 0                           -- Non acquisita per anomalie
                      AND sc.cod_autorizzazione IS NOT NULL
            THEN
               sc.desc_causa_scarto
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


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_WRK_ESITI_SPESE_ITF TO MCRE_USR;
