/* Formatted on 21/07/2014 18:44:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_SPL_PLOAD_JUS0_ITF
(
   LINE
)
AS
   SELECT                                --  20121122    AG  Createt this view
           --  20121128    AG  Decode su cod_abi per gestione cod_ai = '01025'
                                             --  20121218    AG  cod_ndg da 13
                                      --  20130318    AG  nvl(desc_esito, ' ')
                                               --  20130319    AG  fix cod_ndg
                                                                            --
            cod_source                                           -- cod_source
         || id_lotto                                               -- id lotto
         || NVL (id_dper, LPAD (' ', 8, ' ')) -- id_dper se nullo pad con spazi
         || id_esito                                               -- id esito
         || RPAD (NVL (desc_esito, ' '), 50, ' ')                -- desc_esito
         || RPAD (NVL (cod_autorizzazione, ' '), 20, ' ') -- cod_autorizzazione
         || RPAD (NVL (DECODE (cod_abi, '01025', '03069', cod_abi), ' '), 5, ' ') -- cod_abi
         || RPAD (NVL (SUBSTR (cod_ndg, 4), ' '), 13, ' ')          -- cod_ndg
         || RPAD (NVL (cod_autorizzazione_padre, ' '), 20, ' ') -- cod_autorizzazione_padre
         || RPAD (NVL (val_anno_pratica, '0'), 4, '0')     -- val_anno_pratica
         || RPAD (NVL (cod_pratica, ' '), 11, ' ')              -- cod_pratica
         || RPAD (NVL (cod_stato, ' '), 2, ' ')                   -- cod_stato
         || RPAD (NVL (val_numero_fattura, ' '), 50, ' ') -- val_numero_fattura
         || RPAD (NVL (TO_CHAR (dta_fattura, 'yyyymmdd'), ' '), 8, ' ') -- dta_fattura
            line
    FROM t_mcres_app_esiti_spese_itf
   WHERE 0 = 0 AND flg_inviato = 0 AND cod_source IN ('HST', 'INT');
