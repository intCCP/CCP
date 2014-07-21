/* Formatted on 21/07/2014 18:44:49 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_TO_CALC_UO_SP_ITF
(
   COD_ABI,
   COD_AUTORIZZAZIONE,
   LINE
)
AS
   SELECT                                                                   --
          --  20121113    AG  Creazione vista
          --  20121114    AG  Aggiunto NVL su COD_ABI
          --  20121128    AG  Agginto NVL su es.val_tot
          --  20121218    AG  Aggiunto filtro su flg_docs_archiviati
          --  20130108    AG  Agginto filtro su causale per calcolo esborso posizione
          --  20130523    AP  aggiunto nuovo esborso al tracciato
          --  20130529    AP aggiunti campi cod_abi e cod_autorizzazione per flaggatura
          s.cod_abi,
          s.cod_autorizzazione,
             TO_CHAR (SYSDATE - 1 / 3, 'yyyymmdd')                  -- id_dper
          || NVL (s.cod_abi, '00000')                               -- cod_abi
          || SUBSTR (s.cod_ndg, 4)                                  -- cod_ndg
          || RPAD (NVL (p.cod_uo_pratica, ' '), 5, ' ') -- cod_uo_pratica = cod_uo_proponente
          || RPAD (s.cod_autorizzazione, 20, ' ')        -- cod_autorizzazione
          || RPAD (NVL (s.cod_autorizzazione_padre, ' '), 20, ' ') -- cod_autorizzazione_padre
          || TO_CHAR (SYSDATE, 'yyyymmdd')                    -- dta_contabile
          || TO_CHAR (SYSDATE, 'yyyymmdd')                       -- dta_valuta
          || RPAD (NVL (r.cod_rapporto, ' '), 17, '0')        -- cod_rapporto,
          || LPAD (NVL (c.val_importo * 100, 0), 15, '0') -- val_importo_contropartita
          || NVL (s.cod_causale, ' ')                           -- cod_causale
          || LPAD (NVL (s.val_importo_valore, 0) * 100, 15, '0') -- val_importo_spesa
          || LPAD (
                (NVL (es.val_tot, 0) + NVL (s.val_importo_valore, 0)) * 100,
                15,
                '0')                                 -- val_totale_esborsi_pos
          || NVL (p.flg_gestione, 'E')                        -- tipo gestione
          || NVL (s.cod_tipo_autorizzazione, ' ') --  cod_tipo_autorizzazione = tipologia spesa
          || RPAD (NVL (p.cod_matr_pratica, ' '), 7, ' ') -- matricola del gestore della pratica legale
          || LPAD (
                (NVL (es2.val_tot, 0) + NVL (s.val_importo_valore, 0)) * 100,
                15,
                '0')                                       -- val_totale_spese
             --
             line
     FROM t_mcres_app_spese_itf s,
          t_mcres_app_rapporti_itf r,
          t_mcres_app_pratiche p,
          t_mcres_app_contropartite_itf c,
          (                                        -- totale esborso posizione
           SELECT   cod_abi, cod_ndg, SUM (val_importo_valore) val_tot
               FROM t_mcres_app_sp_spese
              WHERE 0 = 0 AND cod_stato IN ('CO') AND cod_causale = 'A'
           GROUP BY cod_abi, cod_ndg) es,
          (                                        -- totale esborso posizione
           SELECT   cod_abi, cod_ndg, SUM (val_importo_valore) val_tot
               FROM t_mcres_app_sp_spese
              WHERE 0 = 0 AND cod_stato IN ('CO')
           GROUP BY cod_abi, cod_ndg) es2
    WHERE     0 = 0
          AND s.cod_autorizzazione = r.cod_autorizzazione(+)
          AND s.cod_abi = p.cod_abi
          AND s.cod_ndg = p.cod_ndg
          AND s.val_anno_pratica = p.val_anno
          AND s.cod_pratica = p.cod_pratica
          AND s.cod_abi = es.cod_abi(+)
          AND s.cod_ndg = es.cod_ndg(+)
          -- AP 23/05/2013
          AND s.cod_abi = es2.cod_abi(+)
          AND s.cod_ndg = es2.cod_ndg(+)
          --
          --and p.flg_attiva = 1
          AND s.cod_autorizzazione = c.cod_autorizzazione
          ---
          --AP 13/06/2013
          --and s.cod_tipo_autorizzazione != '5'
          AND flg_inviata_per_calc_uo_od = 0
          AND flg_docs_archiviati = 1
          AND flg_fornitore_non_censito = 0;
