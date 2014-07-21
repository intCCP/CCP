/* Formatted on 21/07/2014 18:47:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.Z_MCRES_APP_ALERT_NEWSOFFDAVAL
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
   COD_STATO_RACCOLTA_DOC
)
AS
   SELECT aa."ID_ALERT",
          aa."COD_ABI",
          aa."COD_NDG",
          aa."COD_SNDG",
          aa."DESC_NOME_CONTROPARTE",
          aa."COD_UO_PRATICA",
          aa."COD_PRATICA",
          aa."VAL_ANNO_PRATICA",
          aa."COD_MATR_PRATICA",
          aa."DTA_ASSEGN_ADDET",
          aa."DTA_PASSAGGIO_SOFF",
          aa."COD_FILIALE_PRINCIPALE",
          aa."FLG_ATTIVA",
          aa."ALERT",
          aa."DELIBERE",
          SUBSTR (delibere,
                  1,
                    INSTR (delibere,
                           '***',
                           1,
                           1)
                  - 1)
             COD_PROPOSTA,
          SUBSTR (delibere,
                    INSTR (delibere,
                           '***',
                           1,
                           1)
                  + 3,
                  4)
             VAL_ANNO_PROPOSTA,
          SUBSTR (delibere,
                    INSTR (delibere,
                           '***',
                           1,
                           2)
                  + 3,
                  LENGTH (delibere))
             COD_DOC_CLASSIFICAZIONE,
          NULL COD_STATO_RACCOLTA_DOC
     FROM (SELECT DISTINCT
                  3 id_alert,
                  p.cod_abi,
                  P.COD_NDG,
                  Z.COD_SNDG,
                  G.DESC_NOME_CONTROPARTE,
                  P.COD_UO_PRATICA,
                  P.COD_PRATICA,
                  P.VAL_ANNO VAL_ANNO_PRATICA,
                  P.COD_MATR_PRATICA,
                  P.DTA_ASSEGN_ADDET,
                  Z.DTA_PASSAGGIO_SOFF,
                  Z.COD_FILIALE_PRINCIPALE,
                  P.FLG_ATTIVA,
                  CASE
                     WHEN ( (TRUNC (SYSDATE) - Z.DTA_PASSAGGIO_SOFF) BETWEEN 0
                                                                         AND 7)
                     THEN
                        'V'
                     WHEN ( (TRUNC (SYSDATE) - Z.DTA_PASSAGGIO_SOFF) BETWEEN 8
                                                                         AND 30)
                     THEN
                        'A'
                     WHEN ( (TRUNC (SYSDATE) - Z.DTA_PASSAGGIO_SOFF) > 30)
                     THEN
                        'R'
                     ELSE
                        NULL
                  END
                     ALERT,
                  (SELECT    COD_PROPOSTA
                          || '***'
                          || VAL_ANNO_PROPOSTA
                          || '***'
                          || COD_DOC_CLASSIFICAZIONE
                             delibere
                     FROM (SELECT *
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          d.cod_protocollo_delibera
                                             COD_PROPOSTA,
                                          dta_delibera,
                                          dta_conferma_delibera,
                                          VAL_ANNO_PROPOSTA,
                                          D.COD_PRATICA,
                                          D.VAL_ANNO_PRATICA,
                                          --max(dta_delibera) over (partition by  cod_abi,cod_ndg, COD_MICROTIPOLOGIA_DELIB) dta_delibera_last,
                                          MAX (
                                             dta_conferma_delibera)
                                          OVER (
                                             PARTITION BY cod_abi,
                                                          cod_ndg,
                                                          COD_MICROTIPOLOGIA_DELIB)
                                             dta_conferma_delibera_last,
                                          cod_doc_classificazione
                                     FROM t_mcrei_app_delibere d
                                    WHERE     D.COD_MICROTIPOLOGIA_DELIB IN
                                                 ('CS', 'CZ')
                                          AND FLG_NO_DELIBERA = 0
                                          AND COD_FASE_DELIBERA = 'CO') --where dta_delibera = dta_delibera_last
                            WHERE DTA_CONFERMA_DELIBERA =
                                     dta_conferma_delibera_last) de
                    WHERE     P.COD_ABI = DE.COD_ABI
                          AND P.COD_NDG = DE.COD_NDG
                          AND P.COD_PRATICA = DE.COD_PRATICA
                          AND P.VAL_ANNO = DE.VAL_ANNO_PRATICA)
                     delibere
             FROM T_MCRES_APP_PRATICHE P,
                  T_MCRES_APP_POSIZIONI Z,
                  t_MCRE0_APP_ANAGRAFICA_GRUPPO G
            WHERE     P.FLG_ATTIVA = 1
                  AND Z.FLG_ATTIVA = 1
                  AND P.COD_ABI = Z.COD_ABI
                  AND P.COD_NDG = Z.COD_NDG
                  AND P.COD_MATR_PRATICA IS NOT NULL
                  AND z.COD_SNDG = g.COD_SNDG(+)
                  AND p.COD_TIPO_GESTIONE != 'S'
                  AND NOT EXISTS
                             (SELECT DISTINCT 1
                                FROM T_MCRES_APP_DELIBERE D
                               WHERE     D.COD_ABI = P.COD_ABI
                                     AND d.cod_ndg = p.cod_ndg
                                     AND D.COD_DELIBERA IN ('NS', 'NZ', 'IS'))
                  AND NOT EXISTS
                             (SELECT DISTINCT 1
                                FROM (  SELECT COD_ABI,
                                               COD_NDG,
                                               SUM (VAL_IMP_GBV) VAL_IMP_GBV
                                          FROM t_mcres_app_RAPPORTI
                                      --  having SUM (VAL_IMP_GBV) < 250000
                                      GROUP BY COD_ABI, COD_NDG) r,
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
                                                VAL_DAY_LAV
                                        FROM DUAL) L
                               WHERE     r.COD_ABI = Z.COD_ABI
                                     AND R.COD_NDG = Z.COD_NDG
                                     AND VAL_IMP_GBV < 250000
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
                                                     L.VAL_DAY_LAV
                                              AND Z.DTA_PASSAGGIO_SOFF >=
                                                     ADD_MONTHS (
                                                        TO_DATE (
                                                              TO_CHAR (
                                                                 SYSDATE,
                                                                 'YYYYMM')
                                                           || '01',
                                                           'YYYYMMDD'),
                                                        -1))))
                  --          AND NOT EXISTS
                  --                     (  SELECT decode( count(*) - SUM ( CASE WHEN flg_rapp_fondo_terzo = 'S' THEN  1   ELSE   0   END),0,0,1)
                  --                                    FROM t_mcres_app_rapporti x
                  --                                    WHERE dta_chiusura_rapp > SYSDATE
                  --                                    and x.cod_abi = z.cod_abi
                  --                                    AND x.cod_ndg = z.cod_ndg
                  --                                   HAVING COUNT (1) =SUM ( CASE WHEN flg_rapp_fondo_terzo = 'S' THEN  1   ELSE   0   END)
                  --                                   GROUP BY cod_abi, cod_ndg )
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
