/* Formatted on 21/07/2014 18:41:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_COMUNIC_SCADEN
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   DESC_SCADENZA,
   DTA_SCADENZA,
   VAL_GG_SCADENZA,
   COD_TIPO_SCADENZA,
   FLG_LINK,
   DESC_ISTITUTO,
   DESC_NOME_CONTROPARTE,
   COD_PRESIDIO,
   DESC_PRESIDIO,
   COD_LIVELLO,
   COD_UO_PRATICA,
   COD_MATR_PRATICA
)
AS
   SELECT DISTINCT
          -- Scadenza ipoteca
          -- 20130218 AG  parametrizzazione di val_limite_scadenza
          g.cod_abi,
          g.cod_ndg,
          g.cod_sndg,
          s.desc_scadenza,
          ADD_MONTHS (g.dta_scadenza_garanzia, s.val_limite_scadenza)
             dta_scadenza,
            ADD_MONTHS (g.dta_scadenza_garanzia, s.val_limite_scadenza)
          - TRUNC (SYSDATE)
             val_gg_scadenza,
          s.cod_tipo_scadenza,
          0 flg_link,
          i.desc_istituto,
          gg.desc_nome_controparte,
          p.cod_presidio,
          p.desc_presidio,
          p.cod_livello,
          z.cod_uo_pratica,
          z.cod_matr_pratica
     FROM t_mcres_app_garanzie g,
          t_mcres_app_scadenzario s,
          t_mcres_app_pratiche z,
          t_mcres_app_istituti i,
          t_mcre0_app_anagrafica_gruppo gg,
          (SELECT *
             FROM v_mcres_app_lista_presidi
            WHERE cod_tipo = 'P') p
    WHERE     z.flg_attiva = 1
          AND g.cod_abi = z.cod_abi
          AND g.cod_ndg = z.cod_ndg
          AND g.cod_abi = i.cod_abi
          AND g.cod_sndg = gg.cod_sndg
          AND z.cod_uo_pratica = p.cod_presidio(+)
          AND s.cod_tipo_scadenza = 1
          AND (ADD_MONTHS (g.dta_scadenza_garanzia, s.val_limite_scadenza) BETWEEN   TRUNC (
                                                                                        SYSDATE)
                                                                                   - s.val_gg_prec
                                                                               AND   TRUNC (
                                                                                        SYSDATE)
                                                                                   + s.val_gg_succ --          add_months(g.dta_scadenza_garanzia,240) between trunc(sysdate) and
                                                                                                  --          trunc(sysdate)                                                 +s.val_gg_succ
                                                                                                  --        or add_months(g.dta_scadenza_garanzia,240) between trunc(sysdate)-
                                                                                                  --          s.val_gg_prec and trunc(sysdate)
              )
          AND g.cod_forma_tecnica = '08070'
   ---------------------
   UNION ALL
   ---------------------
   --valutazione rapporto
   --   SELECT DISTINCT
   --          r.cod_abi,
   --          r.cod_ndg,
   --          r.cod_sndg,
   --          s.desc_scadenza,
   --          ADD_MONTHS (r.dta_nbv, s.val_limite_scadenza) dta_scadenza,
   --          ADD_MONTHS (r.dta_nbv, s.val_limite_scadenza) - TRUNC (SYSDATE)
   --             val_gg_scadenza,
   --          cod_tipo_scadenza,
   --          CASE
   --             WHEN ADD_MONTHS (r.dta_nbv, s.val_limite_scadenza) >=
   --                     TRUNC (SYSDATE)
   --             THEN
   --                1
   --             ELSE
   --                0
   --          END
   --             flg_link,
   --          i.desc_istituto,
   --          g.desc_nome_controparte,
   --          p.cod_presidio,
   --          p.desc_presidio,
   --          p.cod_livello,
   --          z.cod_uo_pratica,
   --          z.cod_matr_pratica
   --     FROM t_mcres_app_rapporti r,
   --          t_mcres_app_scadenzario s,
   --          t_mcres_app_pratiche z,
   --          t_mcres_app_istituti i,
   --          t_mcre0_app_anagrafica_gruppo g,
   --          (SELECT *
   --             FROM v_mcres_app_lista_presidi
   --            WHERE cod_tipo = 'P') p
   --    WHERE     z.flg_attiva = 1
   --          AND z.cod_abi = r.cod_abi
   --          AND z.cod_ndg = r.cod_ndg
   --          AND z.cod_abi = i.cod_abi
   --          AND z.cod_sndg = g.cod_sndg
   --          AND z.cod_uo_pratica = p.cod_presidio(+)
   --          AND s.cod_tipo_scadenza = 2
   --          AND r.dta_nbv BETWEEN ADD_MONTHS (TRUNC (SYSDATE) - s.val_gg_prec,-s.val_limite_scadenza) AND ADD_MONTHS (TRUNC (SYSDATE) + s.val_gg_succ, -s.val_limite_scadenza)
   --          AND NOT EXISTS
   --                     (SELECT DISTINCT 1
   --                        FROM t_mcres_app_delibere d
   --                       WHERE     d.cod_abi = r.cod_abi
   --                             AND d.cod_ndg = r.cod_ndg
   --                             AND d.cod_delibera = 'RW'
   --                             AND d.cod_stato_delibera = 'CO')
   SELECT a.cod_abi,
          a.cod_ndg,
          a.cod_sndg,
          s.desc_scadenza,
          ADD_MONTHS (NVL (a.DTA_CONFERMA, a.DTA_AGGIORNAMENTO_DELIBERA),
                      s.val_limite_scadenza)
             dta_scadenza,
            ADD_MONTHS (NVL (a.DTA_CONFERMA, a.DTA_AGGIORNAMENTO_DELIBERA),
                        s.val_limite_scadenza)
          - TRUNC (SYSDATE)
             val_gg_scadenza,
          cod_tipo_scadenza,
          CASE
             WHEN ADD_MONTHS (
                     NVL (a.DTA_CONFERMA, a.DTA_AGGIORNAMENTO_DELIBERA),
                     s.val_limite_scadenza) >= TRUNC (SYSDATE)
             THEN
                1
             ELSE
                0
          END
             flg_link,
          i.desc_istituto,
          g.desc_nome_controparte,
          p.cod_presidio,
          p.desc_presidio,
          p.cod_livello,
          z.cod_uo_pratica,
          z.cod_matr_pratica
     FROM (  SELECT cod_abi,
                    cod_ndg,
                    cod_sndg,
                    MAX (DTA_CONFERMA) DTA_CONFERMA,
                    MAX (DTA_AGGIORNAMENTO_DELIBERA) DTA_AGGIORNAMENTO_DELIBERA,
                    MAX (DTA_INSERIMENTO_DELIBERA) DTA_INSERIMENTO_DELIBERA
               FROM t_mcres_app_delibere
              WHERE     cod_delibera IN ('NS', 'RV', 'AS', 'RW')
                    AND cod_stato_delibera = 'CO'
           GROUP BY cod_abi, cod_ndg, cod_sndg) a,
          t_mcres_app_scadenzario s,
          t_mcres_app_pratiche z,
          t_mcres_app_istituti i,
          t_mcre0_app_anagrafica_gruppo g,
          (SELECT *
             FROM v_mcres_app_lista_presidi
            WHERE cod_tipo = 'P') p
    WHERE     1 = 1
          AND z.flg_attiva = 1
          AND a.cod_abi = z.cod_abi
          AND a.cod_ndg = z.cod_ndg
          AND a.cod_abi = i.cod_abi
          AND z.cod_sndg = g.cod_sndg
          AND z.cod_uo_pratica = p.cod_presidio(+)
          AND s.cod_tipo_scadenza = 2
          AND 1 =
                 NVL (
                    (SELECT DISTINCT
                            CASE
                               WHEN COD_STATO_DELIBERA != 'CO'
                               THEN
                                  0
                               WHEN COD_STATO_DELIBERA = 'CO'
                               THEN
                                  CASE
                                     WHEN cod_delibera = 'SN'
                                     THEN
                                        0
                                     WHEN     cod_delibera IN ('TP', 'TT')
                                          AND DTA_AGGIORNAMENTO_DELIBERA >
                                                 SYSDATE
                                     THEN
                                        1
                                     WHEN     cod_delibera = 'TS'
                                          AND DTA_CONFERMA <
                                                 ADD_MONTHS (
                                                    SYSDATE,
                                                    -VAL_LIMITE_SCADENZA)
                                     THEN
                                        1
                                     ELSE
                                        0
                                  END
                               WHEN COD_STATO_DELIBERA = 'AD'
                               THEN
                                  CASE
                                     WHEN cod_delibera = 'TT'
                                     THEN
                                        0
                                     WHEN     cod_delibera IN ('TP', 'TS')
                                          AND DTA_AGGIORNAMENTO_DELIBERA <
                                                 ADD_MONTHS (
                                                    SYSDATE,
                                                    -VAL_LIMITE_SCADENZA)
                                     THEN
                                        1
                                     ELSE
                                        0
                                  END
                               WHEN COD_STATO_DELIBERA = 'NA'
                               THEN
                                  CASE
                                     WHEN DTA_CONFERMA <
                                             ADD_MONTHS (
                                                SYSDATE,
                                                -VAL_LIMITE_SCADENZA)
                                     THEN
                                        1
                                     ELSE
                                        0
                                  END
                               ELSE
                                  0
                            END
                       FROM t_mcres_app_delibere b
                      WHERE     b.cod_abi = a.cod_abi
                            AND b.cod_ndg = a.cod_ndg
                            AND b.cod_delibera IN ('TT', 'TS', 'TP', 'SN')
                            AND b.DTA_INSERIMENTO_DELIBERA >=
                                   a.DTA_INSERIMENTO_DELIBERA
                            AND b.DTA_INSERIMENTO_DELIBERA >=
                                   ADD_MONTHS (SYSDATE, -VAL_LIMITE_SCADENZA)),
                    1);
