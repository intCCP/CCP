/* Formatted on 17/06/2014 18:13:44 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_TO_HOST_SPESE_ITF
(
   LINE
)
AS
   SELECT                                  --  20121024    AG  Creazione vista
                            --  20121105    AG  Adattamento al nuovo tracciato
                                             --  20121107    AG  Rimossi segni
            TO_CHAR (SYSDATE - 1 / 3, 'yyyymmdd')                   -- id_dper
         || s.cod_abi                                               -- cod_abi
         || SUBSTR (s.cod_ndg, 4)                                   -- cod_ndg
         || RPAD (NVL (p.cod_uo_pratica, ' '), 5, ' ') -- cod_uo_pratica = cod_uo_proponente
         || RPAD (s.cod_autorizzazione, 20, ' ')         -- cod_autorizzazione
         || RPAD (NVL (s.cod_autorizzazione_padre, ' '), 20, ' ') -- cod_autorizzazione_padre
         || TO_CHAR (SYSDATE, 'yyyymmdd')                     -- dta_contabile
         || TO_CHAR (SYSDATE, 'yyyymmdd')                        -- dta_valuta
         || RPAD (NVL (r.cod_rapporto, ' '), 17, '0')         -- cod_rapporto,
         --    ||  case when c.val_importo < 0 then '-' else '+' end                       -- segno val_importo_contropartita
         || LPAD (NVL (c.val_importo * 100, 0), 15, '0') -- val_importo_contropartita
         || NVL (s.cod_causale, ' ')                            -- cod_causale
         --    ||  case when s.val_importo_valore < 0 then '-' else '+' end                -- segno val_importo_contropartita
         || LPAD (NVL (s.val_importo_valore, 0) * 100, 15, '0') -- val_importo_spesa
         --    ||  case when es.val_tot + s.val_importo_valore < 0 then '-' else '+' end   -- segno val_totale_esborsi_posizioni
         || LPAD (NVL (es.val_tot + s.val_importo_valore, 0) * 100, 15, '0') -- val_totale_esborsi_pos
         || NVL (p.flg_gestione, ' ')                         -- tipo gestione
         || NVL (s.cod_tipo_autorizzazione, ' ') --  cod_tipo_autorizzazione = tipologia spesa
         || RPAD (NVL (p.cod_matr_pratica, ' '), 7, ' ') -- matricola del gestore della pratica legale
            --
            line
    FROM t_mcres_app_spese_itf s,
         t_mcres_app_rapporti_itf r,
         t_mcres_app_pratiche p,
         t_mcres_app_contropartite_itf c,
         (                                         -- totale esborso posizione
          SELECT   cod_abi, cod_ndg, SUM (val_importo_valore) val_tot
              FROM t_mcres_app_sp_spese
             WHERE 0 = 0 AND cod_stato IN ('CO')
          GROUP BY cod_abi, cod_ndg) es
   WHERE     0 = 0
         AND s.cod_autorizzazione = r.cod_autorizzazione(+)
         --
         -- da sostituire preferibilmente con quella sopra
         --    and r.cod_contropartita = c.cod_contropartita
         --
         AND s.cod_abi = p.cod_abi
         AND s.cod_ndg = p.cod_ndg
         AND s.val_anno_pratica = p.val_anno
         AND s.cod_pratica = p.cod_pratica
         AND s.cod_abi = es.cod_abi(+)
         AND s.cod_ndg = es.cod_ndg(+)
         AND p.flg_attiva = 1
         AND s.cod_autorizzazione = c.cod_autorizzazione
         AND flg_inviata_per_contabil = 0
         AND flg_fornitore_non_censito = 0;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_WRK_TO_HOST_SPESE_ITF TO MCRE_USR;
