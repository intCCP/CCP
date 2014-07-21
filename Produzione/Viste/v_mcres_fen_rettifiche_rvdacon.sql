/* Formatted on 17/06/2014 18:12:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETTIFICHE_RVDACON
(
   COD_ABI,
   VAL_RVNETTE_ULTIMO_MESE_DACONT
)
AS
     SELECT s.cod_abi,
              SUM (
                 CASE
                    WHEN s.cod_stato_rischio = 'S'
                    THEN
                         NVL (s.delta_sisba, 0)
                       - NVL (cp.delta_precedente, 0)
                       + NVL (m.movimenti, 0)
                    ELSE
                       0
                 END)
            - SUM (
                 CASE
                    WHEN     s.cod_stato_rischio = 'E'
                         AND cp.cod_stato_rischio = 'S'
                    THEN
                         NVL (cp.delta_precedente, 0)
                       - NVL (s.delta_sisba, 0)
                       + NVL (m.movimenti, 0)
                    ELSE
                       0
                 END)
               val_rvnette_ultimo_mese_dacont
       FROM (  SELECT t.cod_abi,
                      t.cod_ndg,
                      t.cod_stato_rischio,
                      SUM (
                         t.val_imp_uti_rettificato - t.val_imp_npv_stima_recupero)
                         delta_sisba
                 FROM t_mcres_app_sisba t, v_mcres_app_ultimo_annomeseabi v
                WHERE     t.cod_abi = v.cod_abi
                      AND SUBSTR (t.id_dper, 1, 6) = v.val_annomese_sisba
                      AND t.cod_stato_rischio IN ('S', 'E')
             GROUP BY t.cod_abi, t.cod_ndg, t.cod_stato_rischio) s,
            (  SELECT scp.cod_abi,
                      scp.cod_ndg,
                      scp.cod_stato_rischio,
                      SUM (scp.val_uti_ret - val_att) delta_precedente
                 FROM t_mcres_app_sisba_cp scp, v_mcres_app_ultimo_annomeseabi v
                WHERE     scp.cod_abi = v.cod_abi
                      AND SUBSTR (scp.id_dper, 1, 6) =
                             v.val_annomese_sisba_cp_prec
                      AND scp.val_firma != 'FIRMA'
                      AND scp.cod_stato_rischio IN ('S', 'I')
             GROUP BY scp.cod_abi, scp.cod_ndg, scp.cod_stato_rischio) cp,
            (  SELECT r.cod_abi, r.cod_ndg, SUM (mov.val_imp_movimento) movimenti
                 FROM t_mcres_app_movimenti mov,
                      t_mcres_app_rapporti r,
                      v_mcres_app_ultimo_annomeseabi v
                WHERE     r.cod_abi = mov.cod_abi
                      AND r.cod_rapporto = mov.cod_rapporto
                      AND r.cod_abi = v.cod_abi
                      AND TO_CHAR (mov.dta_contabile_movimento, 'YYYYMM') =
                             v.val_annomese_sisba
                      AND mov.cod_causale_movimento IN
                             ('006', '0I5', '0I6', '0I7')
             GROUP BY r.cod_abi, r.cod_ndg) m
      WHERE     s.cod_abi = cp.cod_abi(+)
            AND s.cod_ndg = cp.cod_ndg(+)
            AND s.cod_abi = m.cod_abi(+)
            AND s.cod_ndg = m.cod_ndg(+)
   GROUP BY s.cod_abi;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_RETTIFICHE_RVDACON TO MCRE_USR;
