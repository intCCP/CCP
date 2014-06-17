/* Formatted on 17/06/2014 18:10:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ESISTI_SPESE_ITF
(
   LINE
)
AS
   SELECT                                --  20121105    AG  Created this view
         cod_source                                              -- cod_source
          || id_lotto                                              -- id lotto
          || NVL (id_dper, LPAD (' ', 8, ' ')) -- id_dper se nullo pad con spazi
          || id_esito                                              -- id esito
          || RPAD (desc_esito, 50, ' ')                          -- desc_esito
          || RPAD (NVL (cod_autorizzazione, ' '), 20, ' ') -- cod_autorizzazione
          || RPAD (NVL (cod_abi, ' '), 5, ' ')                      -- cod_abi
          || RPAD (NVL (cod_ndg, ' '), 13, ' ')                     -- cod_ndg
          || RPAD (NVL (cod_autorizzazione_padre, ' '), 20, ' ') -- cod_autorizzazione_padre
          || RPAD (NVL (val_anno_pratica, ' '), 4, ' ')    -- val_anno_pratica
          || RPAD (NVL (cod_pratica, ' '), 11, ' ')             -- cod_pratica
          || RPAD (NVL (cod_stato, ' '), 2, ' ')                  -- cod_stato
          || RPAD (NVL (val_numero_fattura, ' '), 50, ' ') -- val_numero_fattura
          || RPAD (NVL (TO_CHAR (dta_fattura, 'yyyymmdd'), ' '), 8, ' ')
             line
     FROM t_mcres_app_esiti_spese_itf;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ESISTI_SPESE_ITF TO MCRE_USR;
