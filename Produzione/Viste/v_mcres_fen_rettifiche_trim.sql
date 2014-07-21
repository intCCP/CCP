/* Formatted on 17/06/2014 18:13:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETTIFICHE_TRIM
(
   COD_ABI,
   COD_DIVISIONE,
   VAL_RETTIFICA_MESE_TRIM,
   VAL_DRC_TRIM
)
AS
     SELECT ee.cod_abi,
            NVL (div.cod_divisione, 3) cod_divisione,
            SUM (ee.val_per_ce + ee.val_rett_sval + ee.val_rett_att)
               val_rettifica_mese_trim,
            SUM (
                 ee.val_per_ce
               + ee.val_rett_sval
               + ee.val_rett_att
               - NVL (delta, 0))
               val_drc_trim
       FROM t_mcres_app_effetti_economici ee,
            v_mcres_app_ultimo_annomeseabi am,
            (SELECT p.cod_abi, p.cod_ndg, r.delta_iniziale - cp.delta_cp delta
               FROM ( --soffrenze stimate per la prma volta nell'ultimo trimestre contabilizzato
                     SELECT DISTINCT d.cod_abi, d.cod_ndg
                       FROM t_mcres_app_delibere d,
                            v_mcres_app_ultimo_annomeseabi v
                      WHERE     d.cod_abi = v.cod_abi
                            AND d.cod_delibera = 'NS'
                            AND TO_CHAR (d.dta_inserimento_delibera, 'YYYYMM') BETWEEN v.val_annomese_start_last_q_cont
                                                                                   AND v.val_annomese_end_last_q_cont) p,
                    (  SELECT r.cod_abi,
                              r.cod_ndg,
                              SUM (
                                   -R.VAL_IMP_GBV_INIZIALE
                                 - (-R.VAL_IMP_NBV_INIZIALE))
                                 delta_iniziale
                         FROM t_mcres_app_rapporti r
                     GROUP BY r.cod_abi, r.cod_ndg) r,
                    (  SELECT scp.cod_abi,
                              scp.cod_ndg,
                              SUM (scp.val_uti_ret) delta_cp
                         FROM t_mcres_app_sisba_cp scp,
                              v_mcres_app_ultimo_annomeseabi v
                        WHERE     scp.id_dper =
                                     TO_CHAR (
                                          TO_DATE (
                                             v.val_annomese_start_last_q_cont,
                                             'YYYYMM')
                                        - 1,
                                        'YYYYMMDD')
                              AND scp.cod_stato_rischio IN ('S', 'I')
                     GROUP BY scp.cod_abi, scp.cod_ndg) cp
              WHERE     p.cod_abi = r.cod_abi
                    AND p.cod_ndg = r.cod_ndg
                    AND p.cod_abi = cp.cod_abi
                    AND p.cod_ndg = cp.cod_ndg) n,
            (SELECT DISTINCT
                    cp.cod_abi,
                    cp.cod_ndg,
                    CASE
                       WHEN o.cod_div IN ('DIVRE', 'DIVCI', 'DIVPR')
                       THEN
                          1
                       WHEN o.cod_div IN ('DIVCC', 'DIVLC', 'DIVFI', 'DIVES')
                       THEN
                          2
                       ELSE
                          3
                    END
                       cod_divisione
               FROM t_mcres_app_sisba_cp cp,
                    v_mcres_app_ultimo_annomeseabi v,
                    t_mcre0_app_struttura_org o
              WHERE     cp.cod_abi = v.cod_abi
                    AND SUBSTR (cp.id_dper, 1, 6) =
                           v.val_annomese_ultimo_sisba_cp
                    AND cp.cod_abi = o.cod_abi_istituto(+)
                    AND cp.cod_filiale = o.cod_struttura_competente(+)) div
      WHERE     ee.cod_abi = am.cod_abi
            AND ee.cod_abi = n.cod_abi(+)
            AND ee.cod_ndg = n.cod_ndg(+)
            AND ee.cod_abi = div.cod_abi(+)
            AND ee.cod_ndg = div.cod_ndg(+)
            AND SUBSTR (ee.id_dper, 1, 6) BETWEEN am.val_annomese_start_last_q_cont
                                              AND am.val_annomese_end_last_q_cont
   GROUP BY ee.cod_abi, NVL (div.cod_divisione, 3);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_RETTIFICHE_TRIM TO MCRE_USR;
