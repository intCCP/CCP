/* Formatted on 21/07/2014 18:40:55 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_TEST_LISTA_PARERI
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA,
   DESC_CAUSA_CLASSIFICAZIONE,
   DESC_PROVVEDIMENTI_PRESI,
   DESC_PROVVEDIMENTI_ASSUNTI,
   DESC_PROVVEDIMENTI_LEGALI
)
AS
   SELECT AAAAAA.cod_abi,
          AAAAAA.cod_ndg,
          AAAAAA.cod_sndg,
          AAAAAA.cod_protocollo_delibera,
          AAAAAA.desc_causa_classificazione,
          AAAAAA.desc_PROVVEDIMENTI_PRESI,
          AAAAAA.DESC_PROVVEDIMENTI_ASSUNTI,
          AAAAAA.desc_provvedimenti_legali
     FROM (SELECT AAAAA.CHIAVE,
                  AAAAA.cod_abi,
                  AAAAA.cod_ndg,
                  AAAAA.cod_sndg,
                  AAAAA.cod_protocollo_delibera,
                  AAAAA.desc_causa_classificazione,
                  AAAAA.desc_PROVVEDIMENTI_PRESI,
                  AAAAA.DESC_PROVVEDIMENTI_ASSUNTI,
                  DDD.desc_provvedimenti_legali
             FROM (SELECT AAAA.CHIAVE,
                          AAAA.cod_abi,
                          AAAA.cod_ndg,
                          AAAA.cod_sndg,
                          AAAA.cod_protocollo_delibera,
                          AAAA.desc_causa_classificazione,
                          AAAA.desc_PROVVEDIMENTI_PRESI,
                          CCC.DESC_PROVVEDIMENTI_ASSUNTI
                     FROM (SELECT AAA.CHIAVE,
                                  AAA.cod_abi,
                                  AAA.cod_ndg,
                                  AAA.cod_sndg,
                                  AAA.cod_protocollo_delibera,
                                  AAA.desc_causa_classificazione,
                                  BBB.desc_PROVVEDIMENTI_PRESI -- ccc, cod_abi, ddd.cod_abi)
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_causa_classificazione
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F01'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_causa_classificazione,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F01')) aa
                                    WHERE aa.id_parere = aa.max_id_parere) aaa,
                                  (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_PROVVEDIMENTI_PRESI
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F02'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_PROVVEDIMENTI_PRESI,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F02')) bb
                                    WHERE id_parere = max_id_parere) bbb
                            WHERE AAA.CHIAVE = BBB.CHIAVE(+)
                           UNION
                           SELECT BBB.CHIAVE,
                                  BBB.cod_abi,
                                  BBB.cod_ndg,
                                  BBB.cod_sndg,
                                  BBB.cod_protocollo_delibera,
                                  AAA.desc_causa_classificazione,
                                  BBB.desc_PROVVEDIMENTI_PRESI -- ccc, cod_abi, ddd.cod_abi)
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_causa_classificazione
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F01'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_causa_classificazione,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F01')) aa
                                    WHERE aa.id_parere = aa.max_id_parere) aaa,
                                  (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_PROVVEDIMENTI_PRESI
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F02'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_PROVVEDIMENTI_PRESI,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F02')) bb
                                    WHERE id_parere = max_id_parere) bbb
                            WHERE AAA.CHIAVE(+) = BBB.CHIAVE) AAAA,
                          (SELECT cod_abi,
                                  cod_ndg,
                                  cod_sndg,
                                  cod_protocollo_delibera,
                                     cod_abi
                                  || cod_ndg
                                  || cod_sndg
                                  || cod_protocollo_delibera
                                     AS chiave,
                                  desc_PROVVEDIMENTI_ASSUNTI
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                          id_parere,
                                          CASE
                                             WHEN cod_tipo_par = 'A01'
                                             THEN
                                                desc_parere
                                             ELSE
                                                NULL
                                          END
                                             AS desc_PROVVEDIMENTI_ASSUNTI,
                                          MAX (
                                             id_parere)
                                          OVER (
                                             PARTITION BY cod_abi,
                                                          cod_ndg,
                                                          cod_sndg,
                                                          cod_protocollo_delibera)
                                             max_id_parere
                                     FROM t_mcrei_app_pareri
                                    WHERE cod_tipo_par IN ('A01')) cc
                            WHERE id_parere = max_id_parere) ccc
                    WHERE AAAA.CHIAVE = CCC.CHIAVE(+)
                   UNION
                   SELECT CCC.CHIAVE,
                          CCC.cod_abi,
                          CCC.cod_ndg,
                          CCC.cod_sndg,
                          CCC.cod_protocollo_delibera,
                          AAAA.desc_causa_classificazione,
                          AAAA.desc_PROVVEDIMENTI_PRESI,
                          CCC.DESC_PROVVEDIMENTI_ASSUNTI
                     FROM (SELECT AAA.CHIAVE,
                                  AAA.cod_abi,
                                  AAA.cod_ndg,
                                  AAA.cod_sndg,
                                  AAA.cod_protocollo_delibera,
                                  AAA.desc_causa_classificazione,
                                  BBB.desc_PROVVEDIMENTI_PRESI -- ccc, cod_abi, ddd.cod_abi)
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_causa_classificazione
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F01'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_causa_classificazione,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F01')) aa
                                    WHERE aa.id_parere = aa.max_id_parere) aaa,
                                  (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_PROVVEDIMENTI_PRESI
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F02'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_PROVVEDIMENTI_PRESI,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F02')) bb
                                    WHERE id_parere = max_id_parere) bbb
                            WHERE AAA.CHIAVE = BBB.CHIAVE(+)
                           UNION
                           SELECT BBB.CHIAVE,
                                  BBB.cod_abi,
                                  BBB.cod_ndg,
                                  BBB.cod_sndg,
                                  BBB.cod_protocollo_delibera,
                                  AAA.desc_causa_classificazione,
                                  BBB.desc_PROVVEDIMENTI_PRESI -- ccc, cod_abi, ddd.cod_abi)
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_causa_classificazione
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F01'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_causa_classificazione,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F01')) aa
                                    WHERE aa.id_parere = aa.max_id_parere) aaa,
                                  (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_PROVVEDIMENTI_PRESI
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F02'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_PROVVEDIMENTI_PRESI,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F02')) bb
                                    WHERE id_parere = max_id_parere) bbb
                            WHERE AAA.CHIAVE(+) = BBB.CHIAVE) AAAA,
                          (SELECT cod_abi,
                                  cod_ndg,
                                  cod_sndg,
                                  cod_protocollo_delibera,
                                     cod_abi
                                  || cod_ndg
                                  || cod_sndg
                                  || cod_protocollo_delibera
                                     AS chiave,
                                  desc_PROVVEDIMENTI_ASSUNTI
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                          id_parere,
                                          CASE
                                             WHEN cod_tipo_par = 'A01'
                                             THEN
                                                desc_parere
                                             ELSE
                                                NULL
                                          END
                                             AS desc_PROVVEDIMENTI_ASSUNTI,
                                          MAX (
                                             id_parere)
                                          OVER (
                                             PARTITION BY cod_abi,
                                                          cod_ndg,
                                                          cod_sndg,
                                                          cod_protocollo_delibera)
                                             max_id_parere
                                     FROM t_mcrei_app_pareri
                                    WHERE cod_tipo_par IN ('A01')) cc
                            WHERE id_parere = max_id_parere) ccc
                    WHERE AAAA.CHIAVE(+) = CCC.CHIAVE) AAAAA,
                  (SELECT cod_abi,
                          cod_ndg,
                          cod_sndg,
                          cod_protocollo_delibera,
                             cod_abi
                          || cod_ndg
                          || cod_sndg
                          || cod_protocollo_delibera
                             AS chiave,
                          desc_provvedimenti_legali
                     FROM (SELECT cod_abi,
                                  cod_ndg,
                                  cod_sndg,
                                  cod_protocollo_delibera,
                                  id_parere,
                                  CASE
                                     WHEN cod_tipo_par = 'A07'
                                     THEN
                                        desc_parere
                                     ELSE
                                        NULL
                                  END
                                     AS desc_provvedimenti_legali,
                                  MAX (
                                     id_parere)
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera)
                                     max_id_parere
                             FROM t_mcrei_app_pareri
                            WHERE cod_tipo_par IN ('A07')) dd
                    WHERE id_parere = max_id_parere) ddd
            WHERE AAAAA.CHIAVE = DDD.CHIAVE(+)
           UNION
           SELECT AAAAA.CHIAVE,
                  AAAAA.cod_abi,
                  AAAAA.cod_ndg,
                  AAAAA.cod_sndg,
                  AAAAA.cod_protocollo_delibera,
                  AAAAA.desc_causa_classificazione,
                  AAAAA.desc_PROVVEDIMENTI_PRESI,
                  AAAAA.DESC_PROVVEDIMENTI_ASSUNTI,
                  DDD.desc_provvedimenti_legali
             FROM (SELECT AAAA.CHIAVE,
                          AAAA.cod_abi,
                          AAAA.cod_ndg,
                          AAAA.cod_sndg,
                          AAAA.cod_protocollo_delibera,
                          AAAA.desc_causa_classificazione,
                          AAAA.desc_PROVVEDIMENTI_PRESI,
                          CCC.DESC_PROVVEDIMENTI_ASSUNTI
                     FROM (SELECT AAA.CHIAVE,
                                  AAA.cod_abi,
                                  AAA.cod_ndg,
                                  AAA.cod_sndg,
                                  AAA.cod_protocollo_delibera,
                                  AAA.desc_causa_classificazione,
                                  BBB.desc_PROVVEDIMENTI_PRESI -- ccc, cod_abi, ddd.cod_abi)
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_causa_classificazione
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F01'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_causa_classificazione,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F01')) aa
                                    WHERE aa.id_parere = aa.max_id_parere) aaa,
                                  (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_PROVVEDIMENTI_PRESI
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F02'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_PROVVEDIMENTI_PRESI,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F02')) bb
                                    WHERE id_parere = max_id_parere) bbb
                            WHERE AAA.CHIAVE = BBB.CHIAVE(+)
                           UNION
                           SELECT BBB.CHIAVE,
                                  BBB.cod_abi,
                                  BBB.cod_ndg,
                                  BBB.cod_sndg,
                                  BBB.cod_protocollo_delibera,
                                  AAA.desc_causa_classificazione,
                                  BBB.desc_PROVVEDIMENTI_PRESI -- ccc, cod_abi, ddd.cod_abi)
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_causa_classificazione
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F01'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_causa_classificazione,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F01')) aa
                                    WHERE aa.id_parere = aa.max_id_parere) aaa,
                                  (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_PROVVEDIMENTI_PRESI
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F02'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_PROVVEDIMENTI_PRESI,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F02')) bb
                                    WHERE id_parere = max_id_parere) bbb
                            WHERE AAA.CHIAVE(+) = BBB.CHIAVE) AAAA,
                          (SELECT cod_abi,
                                  cod_ndg,
                                  cod_sndg,
                                  cod_protocollo_delibera,
                                     cod_abi
                                  || cod_ndg
                                  || cod_sndg
                                  || cod_protocollo_delibera
                                     AS chiave,
                                  desc_PROVVEDIMENTI_ASSUNTI
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                          id_parere,
                                          CASE
                                             WHEN cod_tipo_par = 'A01'
                                             THEN
                                                desc_parere
                                             ELSE
                                                NULL
                                          END
                                             AS desc_PROVVEDIMENTI_ASSUNTI,
                                          MAX (
                                             id_parere)
                                          OVER (
                                             PARTITION BY cod_abi,
                                                          cod_ndg,
                                                          cod_sndg,
                                                          cod_protocollo_delibera)
                                             max_id_parere
                                     FROM t_mcrei_app_pareri
                                    WHERE cod_tipo_par IN ('A01')) cc
                            WHERE id_parere = max_id_parere) ccc
                    WHERE AAAA.CHIAVE = CCC.CHIAVE(+)
                   UNION
                   SELECT CCC.CHIAVE,
                          CCC.cod_abi,
                          CCC.cod_ndg,
                          CCC.cod_sndg,
                          CCC.cod_protocollo_delibera,
                          AAAA.desc_causa_classificazione,
                          AAAA.desc_PROVVEDIMENTI_PRESI,
                          CCC.DESC_PROVVEDIMENTI_ASSUNTI
                     FROM (SELECT AAA.CHIAVE,
                                  AAA.cod_abi,
                                  AAA.cod_ndg,
                                  AAA.cod_sndg,
                                  AAA.cod_protocollo_delibera,
                                  AAA.desc_causa_classificazione,
                                  BBB.desc_PROVVEDIMENTI_PRESI -- ccc, cod_abi, ddd.cod_abi)
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_causa_classificazione
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F01'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_causa_classificazione,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F01')) aa
                                    WHERE aa.id_parere = aa.max_id_parere) aaa,
                                  (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_PROVVEDIMENTI_PRESI
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F02'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_PROVVEDIMENTI_PRESI,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F02')) bb
                                    WHERE id_parere = max_id_parere) bbb
                            WHERE AAA.CHIAVE = BBB.CHIAVE(+)
                           UNION
                           SELECT BBB.CHIAVE,
                                  BBB.cod_abi,
                                  BBB.cod_ndg,
                                  BBB.cod_sndg,
                                  BBB.cod_protocollo_delibera,
                                  AAA.desc_causa_classificazione,
                                  BBB.desc_PROVVEDIMENTI_PRESI -- ccc, cod_abi, ddd.cod_abi)
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_causa_classificazione
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F01'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_causa_classificazione,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F01')) aa
                                    WHERE aa.id_parere = aa.max_id_parere) aaa,
                                  (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                             cod_abi
                                          || cod_ndg
                                          || cod_sndg
                                          || cod_protocollo_delibera
                                             AS chiave,
                                          desc_PROVVEDIMENTI_PRESI
                                     FROM (SELECT cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera,
                                                  id_parere,
                                                  CASE
                                                     WHEN cod_tipo_par =
                                                             'F02'
                                                     THEN
                                                        desc_parere
                                                     ELSE
                                                        NULL
                                                  END
                                                     AS desc_PROVVEDIMENTI_PRESI,
                                                  MAX (
                                                     id_parere)
                                                  OVER (
                                                     PARTITION BY cod_abi,
                                                                  cod_ndg,
                                                                  cod_sndg,
                                                                  cod_protocollo_delibera)
                                                     max_id_parere
                                             FROM t_mcrei_app_pareri
                                            WHERE cod_tipo_par IN ('F02')) bb
                                    WHERE id_parere = max_id_parere) bbb
                            WHERE AAA.CHIAVE(+) = BBB.CHIAVE) AAAA,
                          (SELECT cod_abi,
                                  cod_ndg,
                                  cod_sndg,
                                  cod_protocollo_delibera,
                                     cod_abi
                                  || cod_ndg
                                  || cod_sndg
                                  || cod_protocollo_delibera
                                     AS chiave,
                                  desc_PROVVEDIMENTI_ASSUNTI
                             FROM (SELECT cod_abi,
                                          cod_ndg,
                                          cod_sndg,
                                          cod_protocollo_delibera,
                                          id_parere,
                                          CASE
                                             WHEN cod_tipo_par = 'A01'
                                             THEN
                                                desc_parere
                                             ELSE
                                                NULL
                                          END
                                             AS desc_PROVVEDIMENTI_ASSUNTI,
                                          MAX (
                                             id_parere)
                                          OVER (
                                             PARTITION BY cod_abi,
                                                          cod_ndg,
                                                          cod_sndg,
                                                          cod_protocollo_delibera)
                                             max_id_parere
                                     FROM t_mcrei_app_pareri
                                    WHERE cod_tipo_par IN ('A01')) cc
                            WHERE id_parere = max_id_parere) ccc
                    WHERE AAAA.CHIAVE(+) = CCC.CHIAVE) AAAAA,
                  (SELECT cod_abi,
                          cod_ndg,
                          cod_sndg,
                          cod_protocollo_delibera,
                             cod_abi
                          || cod_ndg
                          || cod_sndg
                          || cod_protocollo_delibera
                             AS chiave,
                          desc_provvedimenti_legali
                     FROM (SELECT cod_abi,
                                  cod_ndg,
                                  cod_sndg,
                                  cod_protocollo_delibera,
                                  id_parere,
                                  CASE
                                     WHEN cod_tipo_par = 'A07'
                                     THEN
                                        desc_parere
                                     ELSE
                                        NULL
                                  END
                                     AS desc_provvedimenti_legali,
                                  MAX (
                                     id_parere)
                                  OVER (
                                     PARTITION BY cod_abi,
                                                  cod_ndg,
                                                  cod_sndg,
                                                  cod_protocollo_delibera)
                                     max_id_parere
                             FROM t_mcrei_app_pareri
                            WHERE cod_tipo_par IN ('A07')) dd
                    WHERE id_parere = max_id_parere) ddd
            WHERE AAAAA.CHIAVE(+) = DDD.CHIAVE) AAAAAA;
