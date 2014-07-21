/* Formatted on 21/07/2014 18:41:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_MAX_STIME_BIS
(
   COD_ABI,
   COD_NDG,
   COD_RAPPORTO,
   DTA_STIMA,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT s3.cod_abi,
          s3.cod_ndg,
          s3.cod_rapporto,
          s3.dta_stima,
          s3.cod_protocollo_delibera
     FROM (SELECT s2.cod_abi,
                  s2.cod_ndg,
                  s2.cod_rapporto,
                  s2.cod_protocollo_delibera,
                  s2.max_dta,
                  s2.flg_last_rdv_confermata
             FROM (SELECT DISTINCT
                          s11.cod_abi,
                          s11.cod_ndg,
                          s11.cod_rapporto,
                          s11.cod_protocollo_delibera,
                          MAX (s11.dta_stima)
                             OVER (PARTITION BY s11.cod_abi, s11.cod_ndg)
                             AS max_dta,
                          DECODE (
                             cod_tipo_pacchetto,
                             'A',                                   --5 LUGLIO
                                  (CASE
                                      ---FLG CHE ABILITA GESTIONE VALUTAZIONI SOLO SULL'ULTIMA RV CONFERMATA PER SNDG
                                      WHEN (    dta_last_upd_delibera =
                                                   (SELECT MAX (
                                                              dta_last_upd_delibera)
                                                      FROM t_mcrei_app_delibere r
                                                     WHERE     r.cod_abi =
                                                                  d.cod_abi
                                                           AND r.cod_ndg =
                                                                  d.cod_ndg
                                                           AND r.cod_microtipologia_delib IN
                                                                  ('RV',
                                                                   'T4',
                                                                   'A0',
                                                                   'IM',
                                                                   'IF')
                                                           AND r.cod_fase_delibera =
                                                                  'CO'
                                                           AND r.flg_no_delibera =
                                                                  0
                                                           AND dta_conferma_delibera
                                                                  IS NOT NULL)
                                            AND val_num_progr_delibera =
                                                   (SELECT MAX (
                                                              val_num_progr_delibera)
                                                      FROM t_mcrei_app_delibere r
                                                     WHERE     r.cod_abi =
                                                                  d.cod_abi
                                                           AND r.cod_ndg =
                                                                  d.cod_ndg
                                                           AND r.cod_fase_delibera =
                                                                  'CO'
                                                           AND r.flg_no_delibera =
                                                                  0
                                                           AND (   r.cod_microtipologia_delib IN
                                                                      ('RV',
                                                                       'T4',
                                                                       'A0',
                                                                       'IM',
                                                                       'IF')
                                                                OR cod_macrotipologia_delib =
                                                                      'TP') --26 LUGLIO
                                                                           )) --0629 controllo spostato qui da web.modificabile
                                      THEN
                                         'Y'
                                      ELSE
                                         'N'
                                   END),
                             (CASE
                                 WHEN (    dta_conferma_delibera =
                                              (SELECT MAX (
                                                         dta_conferma_delibera)
                                                 FROM t_mcrei_app_delibere r
                                                WHERE     r.cod_abi =
                                                             d.cod_abi
                                                      AND r.cod_ndg =
                                                             d.cod_ndg
                                                      AND r.cod_microtipologia_delib IN
                                                             ('RV',
                                                              'T4',
                                                              'A0',
                                                              'IM',
                                                              'IF')
                                                      AND r.cod_fase_delibera =
                                                             'CO'
                                                      AND r.flg_no_delibera =
                                                             0
                                                      AND dta_conferma_delibera
                                                             IS NOT NULL)
                                       AND val_num_progr_delibera =
                                              (SELECT MAX (
                                                         val_num_progr_delibera)
                                                 FROM t_mcrei_app_delibere r
                                                WHERE     r.cod_abi =
                                                             d.cod_abi
                                                      AND r.cod_ndg =
                                                             d.cod_ndg
                                                      AND r.cod_fase_delibera =
                                                             'CO'
                                                      AND r.flg_no_delibera =
                                                             0
                                                      AND (r.cod_microtipologia_delib IN
                                                              ('RV',
                                                               'T4',
                                                               'A0',
                                                               'IM',
                                                               'IF')) --26 LUGLIO
                                                                     )) --0629 controllo spostato qui da web.modificabile
                                 THEN
                                    'Y'
                                 ELSE
                                    'N'
                              END))
                             AS flg_last_rdv_confermata
                     FROM t_mcrei_app_stime s11, t_mcrei_app_delibere d
                    WHERE     s11.cod_abi = d.cod_abi
                          AND s11.cod_ndg = d.cod_ndg
                          AND s11.cod_protocollo_delibera =
                                 d.cod_protocollo_delibera
                          AND d.cod_fase_delibera = 'CO'
                          AND d.flg_no_delibera = 0
                          AND d.flg_attiva = '1'
                          AND d.cod_microtipologia_delib IN
                                 ('A0', 'T4', 'RV', 'IM')
                          AND (   (    d.cod_fase_pacchetto NOT IN
                                          ('ANA', 'ANM')          --13Dicembre
                                   AND d.cod_fase_delibera NOT IN
                                          ('AN', 'VA')            --13Dicembre
                                                      )
                               OR d.flg_to_copy = '9') --07Gennaio2014: condizione per visualizzare le delibere annullate con flg_to_copi='9'
                          AND d.flg_no_delibera = 0
                          AND d.cod_tipo_pacchetto IN ('M', 'I')) s2) max_st2,
          ---- (2.1) STIME E STIME EXTRA CON MAX_DTA
          t_mcrei_app_stime s3
    ---- (2.1) STIME E STIME EXTRA
    WHERE     max_st2.cod_abi = s3.cod_abi
          AND max_st2.cod_ndg = s3.cod_ndg
          AND max_st2.cod_rapporto = s3.cod_rapporto
          AND max_st2.max_dta = s3.dta_stima
          AND max_st2.cod_protocollo_delibera = s3.cod_protocollo_delibera
          AND flg_last_rdv_confermata = 'Y';
