/* Formatted on 21/07/2014 18:44:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_SPL_AZIONIGIUD_ITF
(
   LINE
)
AS
   SELECT                                                                  ---
                                          --- 20121128    AG  Crated this view
                                                                           ---
           LPAD (NVL (TO_CHAR (val_anno_pratica), '0'), 4, '0') -- val_anno_pratica
        || LPAD (NVL (cod_pratica, '0'), 11, '0')               -- cod_pratica
        || RPAD (cod_azione, 18, ' ')                            -- cod_azione
        || RPAD (NVL (desc_azione, ' '), 100, ' ')              -- desc_azione
        || NVL (TO_CHAR (dta_creazione_azione, 'DD/MM/YYYY HH24.mi.ss'),
                LPAD (' ', 19, ' '))                   -- dta_creazione_azione
        || NVL (TO_CHAR (dta_completamento_azione, 'DD/MM/YYYY HH24.mi.ss'),
                LPAD (' ', 19, ' '))               -- dta_completamento_azione
           --
           line
   FROM t_mcres_app_azioni_giudiziarie;
