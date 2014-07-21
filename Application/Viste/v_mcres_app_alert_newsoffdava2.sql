/* Formatted on 21/07/2014 18:41:25 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_NEWSOFFDAVA2
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
          (SELECT MIN (cod_stato_raccolta_doc)
             FROM t_mcres_app_raccolta_doc rr
            WHERE rr.cod_abi = aa.cod_abi AND rr.cod_ndg = aa.cod_ndg)
             cod_stato_raccolta_doc
     FROM (SELECT DISTINCT
                  3 id_alert,
                  p.cod_abi,
                  p.cod_ndg,
                  z.cod_sndg,
                  g.desc_nome_controparte,
                  p.cod_uo_pratica,
                  p.cod_pratica,
                  p.val_anno val_anno_pratica,
                  p.cod_matr_pratica,
                  p.dta_assegn_addet,
                  z.dta_passaggio_soff,
                  z.cod_filiale_principale,
                  p.flg_attiva,
                  --                  CASE
                  --                     WHEN ( (TRUNC (SYSDATE) - z.dta_passaggio_soff) BETWEEN 0
                  --                                                                         AND ga.val_current_green)
                  --                     THEN
                  --                        'V'
                  --                     WHEN ( (TRUNC (SYSDATE) - z.dta_passaggio_soff) BETWEEN ga.val_current_green
                  --                                                                             + 1
                  --                                                                         AND ga.val_current_orange)
                  --                     THEN
                  --                        'A'
                  --                     WHEN ( (TRUNC (SYSDATE) - z.dta_passaggio_soff) >
                  --                              ga.val_current_orange)
                  --                     THEN
                  --                        'R'
                  --                     ELSE
                  --                        'X'
                  --                  END
                  CASE
                     WHEN ( (TRUNC (SYSDATE) - p.dta_assegn_addet) BETWEEN 0
                                                                       AND ga.val_current_green)
                     THEN
                        'V'
                     WHEN ( (TRUNC (SYSDATE) - p.dta_assegn_addet) BETWEEN   ga.val_current_green
                                                                           + 1
                                                                       AND ga.val_current_orange)
                     THEN
                        'A'
                     WHEN ( (TRUNC (SYSDATE) - p.dta_assegn_addet) >
                              ga.val_current_orange)
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     alert,
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
                    WHERE     p.cod_abi = de.cod_abi
                          AND p.cod_ndg = de.cod_ndg
                          AND p.cod_pratica = de.cod_pratica
                          AND p.val_anno = de.val_anno_pratica)
                     delibere,
                  u.cognome,
                  u.nome
             FROM t_mcres_app_pratiche p,
                  t_mcres_app_posizioni z,
                  t_mcre0_app_anagrafica_gruppo g,
                  t_mcres_app_gestione_alert ga,
                  t_mcres_app_utenti u
            WHERE     0 = 0
                  AND ga.id_alert = 3
                  AND p.flg_attiva = 1
                  AND z.flg_attiva = 1
                  AND p.cod_abi = z.cod_abi
                  AND p.cod_ndg = z.cod_ndg
                  AND p.cod_matr_pratica IS NOT NULL
                  AND z.cod_sndg = g.cod_sndg(+)
                  AND p.cod_tipo_gestione = 'S'
                  AND p.cod_matr_pratica = u.cod_matricola(+)
                  AND NOT EXISTS
                             (SELECT DISTINCT 1
                                FROM t_mcres_app_delibere d
                               WHERE     d.cod_abi = p.cod_abi
                                     AND d.cod_ndg = p.cod_ndg
                                     AND d.cod_delibera IN ('NS', 'NZ', 'IS'))
                  AND NOT EXISTS
                             (SELECT DISTINCT 1
                                FROM (  SELECT cod_abi,
                                               cod_ndg,
                                               SUM (val_imp_gbv) val_imp_gbv
                                          FROM t_mcres_app_rapporti
                                      --  having sum (val_imp_gbv) < 250000
                                      GROUP BY cod_abi, cod_ndg) r,
                                     (SELECT CASE
                                                WHEN TO_CHAR (
                                                        TO_DATE (
                                                              '01'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MMYYYY'),
                                                           'DDMMYYYY'),
                                                        'D') = 1
                                                THEN
                                                   11
                                                WHEN TO_CHAR (
                                                        TO_DATE (
                                                              '01'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MMYYYY'),
                                                           'DDMMYYYY'),
                                                        'D') IN
                                                        (6, 7)
                                                THEN
                                                   11
                                                ELSE
                                                   9
                                             END
                                                val_day_lav
                                        FROM DUAL) l
                               WHERE     r.cod_abi = z.cod_abi
                                     AND r.cod_ndg = z.cod_ndg
                                     AND val_imp_gbv < 250000
                                     AND (   (    TO_NUMBER (
                                                     TO_CHAR (SYSDATE, 'DD')) >
                                                     l.val_day_lav
                                              AND z.dta_passaggio_soff >=
                                                     TO_DATE (
                                                           TO_CHAR (SYSDATE,
                                                                    'YYYYMM')
                                                        || '01',
                                                        'YYYYMMDD'))
                                          OR (    TO_NUMBER (
                                                     TO_CHAR (SYSDATE, 'DD')) <=
                                                     l.val_day_lav
                                              AND z.dta_passaggio_soff >=
                                                     ADD_MONTHS (
                                                        TO_DATE (
                                                              TO_CHAR (
                                                                 SYSDATE,
                                                                 'YYYYMM')
                                                           || '01',
                                                           'YYYYMMDD'),
                                                        -1))))
                  --          and not exists
                  --                     (  select decode( count(*) - sum ( case when flg_rapp_fondo_terzo = 's' then  1   else   0   end),0,0,1)
                  --                                    from t_mcres_app_rapporti x
                  --                                    where dta_chiusura_rapp > sysdate
                  --                                    and x.cod_abi = z.cod_abi
                  --                                    and x.cod_ndg = z.cod_ndg
                  --                                   having count (1) =sum ( case when flg_rapp_fondo_terzo = 's' then  1   else   0   end)
                  --                                   group by cod_abi, cod_ndg )
                  AND NOT EXISTS
                             (SELECT 1
                                FROM (  SELECT cod_abi, cod_ndg
                                          FROM t_mcres_app_rapporti
                                         WHERE dta_chiusura_rapp > SYSDATE
                                        HAVING COUNT (1) =
                                                  SUM (
                                                     CASE
                                                        WHEN flg_rapp_fondo_terzo =
                                                                'S'
                                                        THEN
                                                           1
                                                        ELSE
                                                           0
                                                     END)
                                      GROUP BY cod_abi, cod_ndg) x
                               WHERE     0 = 0
                                     AND x.cod_abi = z.cod_abi
                                     AND x.cod_ndg = z.cod_ndg)) aa;
