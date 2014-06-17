/* Formatted on 17/06/2014 18:08:15 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_ELENCO_PARERI
(
   FLG_DIFFORME,
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
   SELECT --02.14 aggiunta join delibere per limitare a pareri di classificazione
                                    -- 0217 variato cast parere estesto a CLOB
         flg_difforme,
         PARER.cod_abi,
         PARER.cod_ndg,
         PARER.cod_sndg,
         PARER.cod_protocollo_delibera,
         desc_causa_classificazione,
         desc_provvedimenti_presi,
         desc_provvedimenti_assunti,
         desc_provvedimenti_legali
    FROM (SELECT elenco.flg_difforme,
                 elenco.cod_abi,
                 elenco.cod_ndg,
                 elenco.cod_sndg,
                 elenco.cod_protocollo_delibera,
                 elenco.desc_causa_classificazione,
                 elenco.desc_provvedimenti_presi,
                 elenco.desc_provvedimenti_assunti,
                 elenco.desc_provvedimenti_legali
            FROM (SELECT fa121.flg_difforme,
                         fa121.cod_abi,
                         fa121.cod_ndg,
                         fa121.cod_sndg,
                         fa121.cod_protocollo_delibera,
                         fa121.chiave,
                         fa121.desc_causa_classificazione,
                         fa121.desc_provvedimenti_presi,
                         fa121.desc_provvedimenti_assunti,
                         a07.desc_provvedimenti_legali
                    FROM (SELECT f12.flg_difforme,
                                 f12.cod_abi,
                                 f12.cod_ndg,
                                 f12.cod_sndg,
                                 f12.cod_protocollo_delibera,
                                 f12.chiave,
                                 f12.desc_causa_classificazione,
                                 f12.desc_provvedimenti_presi,
                                 a01.desc_provvedimenti_assunti
                            FROM (SELECT f01.flg_difforme,
                                         f01.cod_abi,
                                         f01.cod_ndg,
                                         f01.cod_sndg,
                                         f01.cod_protocollo_delibera,
                                         f01.chiave,
                                         f01.desc_causa_classificazione,
                                         f02.desc_provvedimenti_presi
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_causa_classificazione
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_causa_classificazione,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
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
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F01')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f01,
                                         (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_provvedimenti_presi
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_provvedimenti_presi,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
                                                                 CASE
                                                                    WHEN cod_tipo_par =
                                                                            'F02'
                                                                    THEN
                                                                       desc_parere
                                                                    ELSE
                                                                       NULL
                                                                 END
                                                                    AS desc_provvedimenti_presi,
                                                                 MAX (
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F02')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f02
                                   WHERE f01.chiave = f02.chiave(+)
                                  UNION
                                  SELECT f02.flg_difforme,
                                         f02.cod_abi,
                                         f02.cod_ndg,
                                         f02.cod_sndg,
                                         f02.cod_protocollo_delibera,
                                         f02.chiave,
                                         f01.desc_causa_classificazione,
                                         f02.desc_provvedimenti_presi
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_causa_classificazione
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_causa_classificazione,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
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
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F01')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f01,
                                         (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_provvedimenti_presi
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_provvedimenti_presi,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
                                                                 CASE
                                                                    WHEN cod_tipo_par =
                                                                            'F02'
                                                                    THEN
                                                                       desc_parere
                                                                    ELSE
                                                                       NULL
                                                                 END
                                                                    AS desc_provvedimenti_presi,
                                                                 MAX (
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F02')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f02
                                   WHERE f01.chiave(+) = f02.chiave) f12,
                                 (SELECT flg_difforme,
                                         cod_abi,
                                         cod_ndg,
                                         cod_sndg,
                                         cod_protocollo_delibera,
                                         chiave,
                                         desc_provvedimenti_assunti
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                    cod_abi
                                                 || cod_ndg
                                                 || cod_sndg
                                                 || cod_protocollo_delibera
                                                    AS chiave,
                                                 desc_provvedimenti_assunti,
                                                 id_parere,
                                                 MIN (
                                                    id_parere)
                                                 OVER (
                                                    PARTITION BY flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera)
                                                    min_id_parere
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                         id_parere,
                                                         id_dper,
                                                         CASE
                                                            WHEN cod_tipo_par =
                                                                    'A01'
                                                            THEN
                                                               desc_parere
                                                            ELSE
                                                               NULL
                                                         END
                                                            AS desc_provvedimenti_assunti,
                                                         MAX (
                                                            id_dper)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            max_id_dper
                                                    FROM t_mcrei_app_pareri
                                                   WHERE cod_tipo_par IN
                                                            ('A01')) aa
                                           WHERE aa.id_dper = aa.max_id_dper) aaa
                                   WHERE id_parere = min_id_parere) a01
                           WHERE f12.chiave = a01.chiave(+)
                          UNION
                          SELECT a01.flg_difforme,
                                 a01.cod_abi,
                                 a01.cod_ndg,
                                 a01.cod_sndg,
                                 a01.cod_protocollo_delibera,
                                 a01.chiave,
                                 f12.desc_causa_classificazione,
                                 f12.desc_provvedimenti_presi,
                                 a01.desc_provvedimenti_assunti
                            FROM (SELECT f01.flg_difforme,
                                         f01.cod_abi,
                                         f01.cod_ndg,
                                         f01.cod_sndg,
                                         f01.cod_protocollo_delibera,
                                         f01.chiave,
                                         f01.desc_causa_classificazione,
                                         f02.desc_provvedimenti_presi
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_causa_classificazione
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_causa_classificazione,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
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
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F01')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f01,
                                         (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_provvedimenti_presi
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_provvedimenti_presi,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
                                                                 CASE
                                                                    WHEN cod_tipo_par =
                                                                            'F02'
                                                                    THEN
                                                                       desc_parere
                                                                    ELSE
                                                                       NULL
                                                                 END
                                                                    AS desc_provvedimenti_presi,
                                                                 MAX (
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F02')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f02
                                   WHERE f01.chiave = f02.chiave(+)
                                  UNION
                                  SELECT f02.flg_difforme,
                                         f02.cod_abi,
                                         f02.cod_ndg,
                                         f02.cod_sndg,
                                         f02.cod_protocollo_delibera,
                                         f02.chiave,
                                         f01.desc_causa_classificazione,
                                         f02.desc_provvedimenti_presi
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_causa_classificazione
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_causa_classificazione,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
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
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F01')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f01,
                                         (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_provvedimenti_presi
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_provvedimenti_presi,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
                                                                 CASE
                                                                    WHEN cod_tipo_par =
                                                                            'F02'
                                                                    THEN
                                                                       desc_parere
                                                                    ELSE
                                                                       NULL
                                                                 END
                                                                    AS desc_provvedimenti_presi,
                                                                 MAX (
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F02')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f02
                                   WHERE f01.chiave(+) = f02.chiave) f12,
                                 (SELECT flg_difforme,
                                         cod_abi,
                                         cod_ndg,
                                         cod_sndg,
                                         cod_protocollo_delibera,
                                         chiave,
                                         desc_provvedimenti_assunti
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                    cod_abi
                                                 || cod_ndg
                                                 || cod_sndg
                                                 || cod_protocollo_delibera
                                                    AS chiave,
                                                 desc_provvedimenti_assunti,
                                                 id_parere,
                                                 MIN (
                                                    id_parere)
                                                 OVER (
                                                    PARTITION BY flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera)
                                                    min_id_parere
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                         id_parere,
                                                         id_dper,
                                                         CASE
                                                            WHEN cod_tipo_par =
                                                                    'A01'
                                                            THEN
                                                               desc_parere
                                                            ELSE
                                                               NULL
                                                         END
                                                            AS desc_provvedimenti_assunti,
                                                         MAX (
                                                            id_dper)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            max_id_dper
                                                    FROM t_mcrei_app_pareri
                                                   WHERE cod_tipo_par IN
                                                            ('A01')) aa
                                           WHERE aa.id_dper = aa.max_id_dper) aaa
                                   WHERE id_parere = min_id_parere) a01
                           WHERE f12.chiave(+) = a01.chiave) fa121,
                         (SELECT flg_difforme,
                                 cod_abi,
                                 cod_ndg,
                                 cod_sndg,
                                 cod_protocollo_delibera,
                                 chiave,
                                 desc_provvedimenti_legali
                            FROM (SELECT flg_difforme,
                                         cod_abi,
                                         cod_ndg,
                                         cod_sndg,
                                         cod_protocollo_delibera,
                                            cod_abi
                                         || cod_ndg
                                         || cod_sndg
                                         || cod_protocollo_delibera
                                            AS chiave,
                                         desc_provvedimenti_legali,
                                         id_parere,
                                         MIN (
                                            id_parere)
                                         OVER (
                                            PARTITION BY flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera)
                                            min_id_parere
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 id_parere,
                                                 id_dper,
                                                 CASE
                                                    WHEN cod_tipo_par = 'A07'
                                                    THEN
                                                       desc_parere
                                                    ELSE
                                                       NULL
                                                 END
                                                    AS desc_provvedimenti_legali,
                                                 MAX (
                                                    id_dper)
                                                 OVER (
                                                    PARTITION BY flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera)
                                                    max_id_dper
                                            FROM t_mcrei_app_pareri
                                           WHERE cod_tipo_par IN ('A07')) aa
                                   WHERE aa.id_dper = aa.max_id_dper) aaa
                           WHERE id_parere = min_id_parere) a07
                   WHERE fa121.chiave = a07.chiave(+)
                  UNION
                  SELECT a07.flg_difforme,
                         a07.cod_abi,
                         a07.cod_ndg,
                         a07.cod_sndg,
                         a07.cod_protocollo_delibera,
                         a07.chiave,
                         fa121.desc_causa_classificazione,
                         fa121.desc_provvedimenti_presi,
                         fa121.desc_provvedimenti_assunti,
                         a07.desc_provvedimenti_legali
                    FROM (SELECT f12.flg_difforme,
                                 f12.cod_abi,
                                 f12.cod_ndg,
                                 f12.cod_sndg,
                                 f12.cod_protocollo_delibera,
                                 f12.chiave,
                                 f12.desc_causa_classificazione,
                                 f12.desc_provvedimenti_presi,
                                 a01.desc_provvedimenti_assunti
                            FROM (SELECT f01.flg_difforme,
                                         f01.cod_abi,
                                         f01.cod_ndg,
                                         f01.cod_sndg,
                                         f01.cod_protocollo_delibera,
                                         f01.chiave,
                                         f01.desc_causa_classificazione,
                                         f02.desc_provvedimenti_presi
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_causa_classificazione
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_causa_classificazione,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
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
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F01')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f01,
                                         (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_provvedimenti_presi
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_provvedimenti_presi,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
                                                                 CASE
                                                                    WHEN cod_tipo_par =
                                                                            'F02'
                                                                    THEN
                                                                       desc_parere
                                                                    ELSE
                                                                       NULL
                                                                 END
                                                                    AS desc_provvedimenti_presi,
                                                                 MAX (
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F02')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f02
                                   WHERE f01.chiave = f02.chiave(+)
                                  UNION
                                  SELECT f02.flg_difforme,
                                         f02.cod_abi,
                                         f02.cod_ndg,
                                         f02.cod_sndg,
                                         f02.cod_protocollo_delibera,
                                         f02.chiave,
                                         f01.desc_causa_classificazione,
                                         f02.desc_provvedimenti_presi
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_causa_classificazione
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_causa_classificazione,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
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
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F01')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f01,
                                         (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_provvedimenti_presi
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_provvedimenti_presi,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
                                                                 CASE
                                                                    WHEN cod_tipo_par =
                                                                            'F02'
                                                                    THEN
                                                                       desc_parere
                                                                    ELSE
                                                                       NULL
                                                                 END
                                                                    AS desc_provvedimenti_presi,
                                                                 MAX (
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F02')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f02
                                   WHERE f01.chiave(+) = f02.chiave) f12,
                                 (SELECT flg_difforme,
                                         cod_abi,
                                         cod_ndg,
                                         cod_sndg,
                                         cod_protocollo_delibera,
                                         chiave,
                                         desc_provvedimenti_assunti
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                    cod_abi
                                                 || cod_ndg
                                                 || cod_sndg
                                                 || cod_protocollo_delibera
                                                    AS chiave,
                                                 desc_provvedimenti_assunti,
                                                 id_parere,
                                                 MIN (
                                                    id_parere)
                                                 OVER (
                                                    PARTITION BY flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera)
                                                    min_id_parere
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                         id_parere,
                                                         id_dper,
                                                         CASE
                                                            WHEN cod_tipo_par =
                                                                    'A01'
                                                            THEN
                                                               desc_parere
                                                            ELSE
                                                               NULL
                                                         END
                                                            AS desc_provvedimenti_assunti,
                                                         MAX (
                                                            id_dper)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            max_id_dper
                                                    FROM t_mcrei_app_pareri
                                                   WHERE cod_tipo_par IN
                                                            ('A01')) aa
                                           WHERE aa.id_dper = aa.max_id_dper) aaa
                                   WHERE id_parere = min_id_parere) a01
                           WHERE f12.chiave = a01.chiave(+)
                          UNION
                          SELECT a01.flg_difforme,
                                 a01.cod_abi,
                                 a01.cod_ndg,
                                 a01.cod_sndg,
                                 a01.cod_protocollo_delibera,
                                 a01.chiave,
                                 f12.desc_causa_classificazione,
                                 f12.desc_provvedimenti_presi,
                                 a01.desc_provvedimenti_assunti
                            FROM (SELECT f01.flg_difforme,
                                         f01.cod_abi,
                                         f01.cod_ndg,
                                         f01.cod_sndg,
                                         f01.cod_protocollo_delibera,
                                         f01.chiave,
                                         f01.desc_causa_classificazione,
                                         f02.desc_provvedimenti_presi
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_causa_classificazione
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_causa_classificazione,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
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
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F01')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f01,
                                         (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_provvedimenti_presi
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_provvedimenti_presi,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
                                                                 CASE
                                                                    WHEN cod_tipo_par =
                                                                            'F02'
                                                                    THEN
                                                                       desc_parere
                                                                    ELSE
                                                                       NULL
                                                                 END
                                                                    AS desc_provvedimenti_presi,
                                                                 MAX (
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F02')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f02
                                   WHERE f01.chiave = f02.chiave(+)
                                  UNION
                                  SELECT f02.flg_difforme,
                                         f02.cod_abi,
                                         f02.cod_ndg,
                                         f02.cod_sndg,
                                         f02.cod_protocollo_delibera,
                                         f02.chiave,
                                         f01.desc_causa_classificazione,
                                         f02.desc_provvedimenti_presi
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_causa_classificazione
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_causa_classificazione,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
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
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F01')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f01,
                                         (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 chiave,
                                                 desc_provvedimenti_presi
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                            cod_abi
                                                         || cod_ndg
                                                         || cod_sndg
                                                         || cod_protocollo_delibera
                                                            AS chiave,
                                                         desc_provvedimenti_presi,
                                                         id_parere,
                                                         MIN (
                                                            id_parere)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            min_id_parere
                                                    FROM (SELECT flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera,
                                                                 id_parere,
                                                                 id_dper,
                                                                 CASE
                                                                    WHEN cod_tipo_par =
                                                                            'F02'
                                                                    THEN
                                                                       desc_parere
                                                                    ELSE
                                                                       NULL
                                                                 END
                                                                    AS desc_provvedimenti_presi,
                                                                 MAX (
                                                                    id_dper)
                                                                 OVER (
                                                                    PARTITION BY flg_difforme,
                                                                                 cod_abi,
                                                                                 cod_ndg,
                                                                                 cod_sndg,
                                                                                 cod_protocollo_delibera)
                                                                    max_id_dper
                                                            FROM t_mcrei_app_pareri
                                                           WHERE cod_tipo_par IN
                                                                    ('F02')) aa
                                                   WHERE aa.id_dper =
                                                            aa.max_id_dper) aaa
                                           WHERE id_parere = min_id_parere) f02
                                   WHERE f01.chiave(+) = f02.chiave) f12,
                                 (SELECT flg_difforme,
                                         cod_abi,
                                         cod_ndg,
                                         cod_sndg,
                                         cod_protocollo_delibera,
                                         chiave,
                                         desc_provvedimenti_assunti
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                    cod_abi
                                                 || cod_ndg
                                                 || cod_sndg
                                                 || cod_protocollo_delibera
                                                    AS chiave,
                                                 desc_provvedimenti_assunti,
                                                 id_parere,
                                                 MIN (
                                                    id_parere)
                                                 OVER (
                                                    PARTITION BY flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera)
                                                    min_id_parere
                                            FROM (SELECT flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera,
                                                         id_parere,
                                                         id_dper,
                                                         CASE
                                                            WHEN cod_tipo_par =
                                                                    'A01'
                                                            THEN
                                                               desc_parere
                                                            ELSE
                                                               NULL
                                                         END
                                                            AS desc_provvedimenti_assunti,
                                                         MAX (
                                                            id_dper)
                                                         OVER (
                                                            PARTITION BY flg_difforme,
                                                                         cod_abi,
                                                                         cod_ndg,
                                                                         cod_sndg,
                                                                         cod_protocollo_delibera)
                                                            max_id_dper
                                                    FROM t_mcrei_app_pareri
                                                   WHERE cod_tipo_par IN
                                                            ('A01')) aa
                                           WHERE aa.id_dper = aa.max_id_dper) aaa
                                   WHERE id_parere = min_id_parere) a01
                           WHERE f12.chiave(+) = a01.chiave) fa121,
                         (SELECT flg_difforme,
                                 cod_abi,
                                 cod_ndg,
                                 cod_sndg,
                                 cod_protocollo_delibera,
                                 chiave,
                                 desc_provvedimenti_legali
                            FROM (SELECT flg_difforme,
                                         cod_abi,
                                         cod_ndg,
                                         cod_sndg,
                                         cod_protocollo_delibera,
                                            cod_abi
                                         || cod_ndg
                                         || cod_sndg
                                         || cod_protocollo_delibera
                                            AS chiave,
                                         desc_provvedimenti_legali,
                                         id_parere,
                                         MIN (
                                            id_parere)
                                         OVER (
                                            PARTITION BY flg_difforme,
                                                         cod_abi,
                                                         cod_ndg,
                                                         cod_sndg,
                                                         cod_protocollo_delibera)
                                            min_id_parere
                                    FROM (SELECT flg_difforme,
                                                 cod_abi,
                                                 cod_ndg,
                                                 cod_sndg,
                                                 cod_protocollo_delibera,
                                                 id_parere,
                                                 id_dper,
                                                 CASE
                                                    WHEN cod_tipo_par = 'A07'
                                                    THEN
                                                       desc_parere
                                                    ELSE
                                                       NULL
                                                 END
                                                    AS desc_provvedimenti_legali,
                                                 MAX (
                                                    id_dper)
                                                 OVER (
                                                    PARTITION BY flg_difforme,
                                                                 cod_abi,
                                                                 cod_ndg,
                                                                 cod_sndg,
                                                                 cod_protocollo_delibera)
                                                    max_id_dper
                                            FROM t_mcrei_app_pareri
                                           WHERE cod_tipo_par IN ('A07')) aa
                                   WHERE aa.id_dper = aa.max_id_dper) aaa
                           WHERE id_parere = min_id_parere) a07
                   WHERE fa121.chiave = a07.chiave(+)) elenco) parer,
         t_mcrei_app_Delibere d
   WHERE     PARER.COD_ABI = D.COD_ABI
         AND PARER.COD_NDG = D.COD_NDG
         AND parer.cod_protocollo_delibera = d.cod_protocollo_Delibera
         AND d.cod_microtipologia_delib IN ('CI', 'CS');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_ELENCO_PARERI TO MCRE_USR;
