/* Formatted on 21/07/2014 18:46:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.X_MCRES_APP_ALERT_NEWSOFFDAVAL
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_UO_PRATICA,
   COD_PRATICA,
   VAL_ANNO_PRATICA,
   COD_MATR_PRATICA,
   DTA_ASSEGN_ADDET,
   DTA_PASSAGGIO_SOFF,
   COD_FILIALE_PRINCIPALE,
   FLG_ATTIVA,
   ALERT,
   DELIBERE,
   FLG_GESTIONE,
   COD_PROPOSTA,
   VAL_ANNO_PROPOSTA,
   COD_DOC_CLASSIFICAZIONE,
   NOME,
   COGNOME,
   COD_STATO_RACCOLTA_DOC
)
AS
   SELECT -- 20131106 VG modificata regola su alert da data pass soff a data ass gestore e campo cod_stato_raccolta_doc
         aa.id_alert,
          aa.cod_abi,
          aa.cod_ndg,
          aa.cod_sndg,
          aa.desc_nome_controparte,
          aa.cod_uo_pratica,
          aa.cod_pratica,
          aa.val_anno_pratica,
          aa.cod_matr_pratica,
          aa.dta_assegn_addet,
          aa.dta_passaggio_soff,
          aa.cod_filiale_principale,
          aa.flg_attiva,
          aa.alert,
          aa.delibere,
          aa.flg_gestione,
          SUBSTR (delibere,
                  1,
                    INSTR (delibere,
                           '***',
                           1,
                           1)
                  - 1)
             cod_proposta,
          SUBSTR (delibere,
                    INSTR (delibere,
                           '***',
                           1,
                           1)
                  + 3,
                  4)
             val_anno_proposta,
          SUBSTR (delibere,
                    INSTR (delibere,
                           '***',
                           1,
                           2)
                  + 3,
                  LENGTH (delibere))
             cod_doc_classificazione,
          nome,
          cognome,
          CASE
             WHEN flg_gestione IN ('I', 'R')
             THEN
                NVL (
                   (SELECT MIN (cod_stato_raccolta_doc)
                      FROM t_mcres_app_raccolta_doc rr
                     WHERE     rr.cod_abi = aa.cod_abi
                           AND rr.cod_ndg = aa.cod_ndg),
                   1)
             ELSE
                NULL
          END
             cod_stato_raccolta_doc
     FROM (SELECT zz.*,
                  --CASE
                  --   WHEN ( (TRUNC (SYSDATE) - dta_assegn_addet) BETWEEN 0
                  --                                                   AND ga.val_current_green)
                  --   THEN
                  --      'V'
                  --   WHEN ( (TRUNC (SYSDATE) - dta_assegn_addet) BETWEEN ga.val_current_green
                  --                                                       + 1
                  --                                                   AND ga.val_current_orange)
                  --   THEN
                  --      'A'
                  --   WHEN ( (TRUNC (SYSDATE) - dta_assegn_addet) >
                  --            ga.val_current_orange)
                  --   THEN
                  --      'R'
                  --   ELSE
                  --      'X'
                  --END
                  --   alert,
                  CASE
                     WHEN ( (TRUNC (SYSDATE) - DTA_PASSAGGIO_SOFF) BETWEEN 0
                                                                       AND 7)
                     THEN
                        'V'
                     WHEN ( (TRUNC (SYSDATE) - DTA_PASSAGGIO_SOFF) BETWEEN 8
                                                                       AND 30)
                     THEN
                        'A'
                     WHEN ( (TRUNC (SYSDATE) - DTA_PASSAGGIO_SOFF) > 30)
                     THEN
                        'R'
                     ELSE
                        NULL
                  END
                     ALERT,
                  (SELECT    cod_proposta
                          || '***'
                          || val_anno_proposta
                          || '***'
                          || cod_doc_classificazione
                             delibere
                     FROM (SELECT *
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          d.cod_protocollo_delibera
                                             cod_proposta,
                                          dta_delibera,
                                          dta_conferma_delibera,
                                          val_anno_proposta,
                                          d.cod_pratica,
                                          d.val_anno_pratica,
                                          --max(dta_delibera) over (partition by  cod_abi,cod_ndg, cod_microtipologia_delib) dta_delibera_last,
                                          MAX (
                                             dta_conferma_delibera)
                                          OVER (
                                             PARTITION BY cod_abi,
                                                          cod_ndg,
                                                          cod_microtipologia_delib)
                                             dta_conferma_delibera_last,
                                          cod_doc_classificazione
                                     FROM t_mcrei_app_delibere d
                                    WHERE     d.cod_microtipologia_delib IN
                                                 ('CS', 'CZ')
                                          AND flg_no_delibera = 0
                                          AND cod_fase_delibera = 'CO') --where dta_delibera = dta_delibera_last
                            WHERE dta_conferma_delibera =
                                     dta_conferma_delibera_last) de
                    WHERE     zz.cod_abi = de.cod_abi
                          AND zz.cod_ndg = de.cod_ndg
                          AND zz.cod_pratica = de.cod_pratica
                          AND zz.val_anno_pratica = de.val_anno_pratica)
                     delibere,
                  u.cognome,
                  u.nome,
                  g.desc_nome_controparte
             FROM (SELECT DISTINCT
                          3 id_alert,
                          p.cod_abi,
                          p.cod_ndg,
                          z.cod_sndg,
                          p.cod_matr_pratica,
                          dta_passaggio_soff,
                          dta_assegn_addet,
                          p.cod_pratica,
                          p.VAL_ANNO val_anno_pratica,
                          p.cod_uo_pratica,
                          z.cod_filiale_principale,
                          p.flg_attiva,
                          NVL (
                             (SELECT DISTINCT 1
                                FROM t_mcres_app_rapporti x
                               WHERE     x.cod_abi = z.cod_abi
                                     AND x.cod_ndg = z.cod_ndg
                                     AND dta_chiusura_rapp > SYSDATE
                              HAVING COUNT (1) =
                                        SUM (
                                           CASE
                                              WHEN flg_rapp_fondo_terzo = 'S'
                                              THEN
                                                 1
                                              ELSE
                                                 0
                                           END)),
                             0)
                             val_cnt_fondoterzo,
                          NVL (
                             (SELECT DISTINCT 1
                                FROM t_mcres_app_delibere d
                               WHERE     d.cod_abi = p.cod_abi
                                     AND d.cod_ndg = p.cod_ndg
                                     AND d.cod_delibera IN ('NS', 'NZ', 'IS')),
                             0)
                             val_cnt_delibere,
                          (SELECT CASE
                                     WHEN TO_CHAR (
                                             TO_DATE (
                                                   '01'
                                                || TO_CHAR (SYSDATE,
                                                            'MMYYYY'),
                                                'DDMMYYYY'),
                                             'D') = 1
                                     THEN
                                        11
                                     WHEN TO_CHAR (
                                             TO_DATE (
                                                   '01'
                                                || TO_CHAR (SYSDATE,
                                                            'MMYYYY'),
                                                'DDMMYYYY'),
                                             'D') IN
                                             (6, 7)
                                     THEN
                                        11
                                     ELSE
                                        9
                                  END
                             FROM DUAL)
                             val_day_lav,
                          p.flg_gestione
                     FROM t_mcres_app_pratiche p, t_mcres_app_posizioni z
                    WHERE     0 = 0
                          AND p.flg_attiva = 1
                          AND z.flg_attiva = 1
                          AND p.cod_abi = z.cod_abi
                          AND p.cod_ndg = z.cod_ndg
                          AND p.cod_matr_pratica IS NOT NULL
                          AND p.cod_tipo_gestione = 'S') zz,
                  t_mcre0_app_anagrafica_gruppo g,
                  t_mcres_app_gestione_alert ga,
                  t_mcres_app_utenti u
            WHERE     ga.id_alert = 3
                  AND zz.cod_matr_pratica = u.cod_matricola(+)
                  AND zz.cod_sndg = g.cod_sndg(+)
                  AND val_cnt_fondoterzo = 0
                  AND val_cnt_delibere = 0
                  AND 0 =
                         NVL (
                            (SELECT CASE
                                       WHEN (    SUM (val_imp_gbv) < 250000
                                             AND (   (    TO_NUMBER (
                                                             TO_CHAR (
                                                                SYSDATE,
                                                                'DD')) >
                                                             val_day_lav
                                                      AND zz.dta_passaggio_soff >=
                                                             TO_DATE (
                                                                   TO_CHAR (
                                                                      SYSDATE,
                                                                      'YYYYMM')
                                                                || '01',
                                                                'YYYYMMDD'))
                                                  OR (    TO_NUMBER (
                                                             TO_CHAR (
                                                                SYSDATE,
                                                                'DD')) <=
                                                             val_day_lav
                                                      AND zz.dta_passaggio_soff >=
                                                             ADD_MONTHS (
                                                                TO_DATE (
                                                                      TO_CHAR (
                                                                         SYSDATE,
                                                                         'YYYYMM')
                                                                   || '01',
                                                                   'YYYYMMDD'),
                                                                -1))))
                                       THEN
                                          1
                                       ELSE
                                          0
                                    END
                                       ris
                               FROM t_mcres_app_rapporti r
                              WHERE     r.cod_abi = zz.cod_abi
                                    AND r.cod_ndg = zz.cod_ndg),
                            0)) aa;
