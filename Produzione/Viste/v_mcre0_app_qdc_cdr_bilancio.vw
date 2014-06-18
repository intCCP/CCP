/* Formatted on 17/06/2014 18:02:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_CDR_BILANCIO
(
   ID_DPER,
   ID_SOURCE,
   COD_ABI,
   COD_NDG,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   COD_STRUTTURA_COMPETENTE,
   COD_COMPARTO,
   COD_PROCESSO,
   VAL_RETT_LORDE_CASSA,
   VAL_RETT_LORDE_FIRMA,
   VAL_RETT_LORDE_TOT,
   VAL_RIPRESE_CASSA,
   VAL_RIPRESE_FIRMA,
   VAL_RIPRESE_TOT,
   VAL_RETT_NETTE_CASSA,
   VAL_RETT_NETTE_FIRMA,
   VAL_RETT_NETTE_TOT,
   VAL_ESPOS_LORDA_CASSA,
   VAL_ESPOS_LORDA_FIRMA,
   VAL_ESPOS_LORDA_DERIV,
   VAL_ESPOS_LORDA_TOT,
   VAL_ESPOS_NETTA_CASSA,
   VAL_ESPOS_NETTA_FIRMA,
   VAL_ESPOS_NETTA_TOT,
   VAL_PER_CE,
   VAL_RETT_SVAL,
   VAL_RETT_ATT,
   VAL_RIP_MORA,
   VAL_QUOTA_SVAL,
   VAL_QUOTA_ATT,
   VAL_RIP_SVAL,
   VAL_RIP_ATT,
   VAL_ATTUALIZZAZIONE,
   VAL_RDV_QC_PROGRESSIVA,
   VAL_RDV_PROGR_FI,
   VAL_UTILIZZO_0,
   VAL_UTILIZZO_1,
   VAL_UTILIZZO_2,
   VAL_UTILIZZO_3,
   VAL_UTILIZZO_TOT,
   VAL_RECUPERO_0,
   VAL_RECUPERO_1,
   VAL_RECUPERO_2,
   VAL_RECUPERO_3,
   VAL_RAPPORTO_0,
   VAL_RAPPORTO_1,
   VAL_RAPPORTO_2,
   VAL_RAPPORTO_3,
   VAL_SCSB_UTI_CASSA,
   VAL_SCSB_UTI_FIRMA,
   VAL_SCSB_UTI_DERIV,
   VAL_SCSB_UTI_TOT
)
AS
   SELECT                                          -- VG 20131009 MCRD causali
         SUBSTR (cp.id_dper, 1, 6) id_dper,
          'B' id_source,
          TRIM (cp.cod_abi) cod_abi,
          TRIM (cp.cod_ndg) cod_ndg,
          NVL (TRIM (cp.cod_stato), ' ') cod_stato,
          NVL (cp.dta_decorrenza_stato, ' ') dta_decorrenza_stato,
          NVL (TRIM (cp.cod_struttura_competente), ' ')
             cod_struttura_competente,
          ' ' cod_comparto,
          ' ' cod_processo,
          NVL (cp.val_rett_lorde_cassa, 0) val_rett_lorde_cassa,
          NVL (cp.val_rett_lorde_firma, 0) val_rett_lorde_firma,
          NVL (cp.val_rett_lorde_tot, 0) val_rett_lorde_tot,
          NVL (cp.val_riprese_cassa, 0) val_riprese_cassa,
          NVL (cp.val_riprese_firma, 0) val_riprese_firma,
          NVL (cp.val_riprese_tot, 0) val_riprese_tot,
          NVL (cp.val_rett_nette_cassa, 0) val_rett_nette_cassa,
          NVL (cp.val_rett_nette_firma, 0) val_rett_nette_firma,
          NVL (cp.val_rett_nette_tot, 0) val_rett_nette_tot,
          NVL (cp.val_espos_lorda_cassa, 0) val_espos_lorda_cassa,
          NVL (cp.val_espos_lorda_firma, 0) val_espos_lorda_firma,
          NVL (cp.val_espos_lorda_deriv, 0) val_espos_lorda_deriv,
          NVL (cp.val_espos_lorda_tot, 0) val_espos_lorda_tot,
          NVL (cp.val_espos_netta_cassa, 0) val_espos_netta_cassa,
          NVL (cp.val_espos_netta_firma, 0) val_espos_netta_firma,
          NVL (cp.val_espos_netta_tot, 0) val_espos_netta_tot,
          NVL (cp.val_per_ce, 0) val_per_ce,
          NVL (cp.val_rett_sval, 0) val_rett_sval,
          NVL (cp.val_rett_att, 0) val_rett_att,
          NVL (cp.val_rip_mora, 0) val_rip_mora,
          NVL (cp.val_quota_sval, 0) val_quota_sval,
          NVL (cp.val_quota_att, 0) val_quota_att,
          NVL (cp.val_rip_sval, 0) val_rip_sval,
          NVL (cp.val_rip_att, 0) val_rip_att,
          NVL (cp.val_attualizzazione, 0) val_attualizzazione,
          0 val_rdv_qc_progressiva,
          0 val_rdv_progr_fi,
          cp.val_utilizzo_0,
          cp.val_utilizzo_1,
          cp.val_utilizzo_2,
          cp.val_utilizzo_3,
          cp.val_utilizzo_tot,
          NVL (mm.val_recupero_0, 0) val_recupero_0,
          NVL (mm.val_recupero_1, 0) val_recupero_1,
          NVL (mm.val_recupero_2, 0) val_recupero_2,
          NVL (mm.val_recupero_3, 0) val_recupero_3,
          CASE
             WHEN cp.val_utilizzo_0 != 0 AND cp.val_utilizzo_tot != 0
             THEN
                  (NVL (mm.val_recupero_0, 0) / cp.val_utilizzo_0)
                / val_utilizzo_tot
             ELSE
                0
          END
             val_rapporto_0,
          CASE
             WHEN cp.val_utilizzo_1 != 0 AND cp.val_utilizzo_tot != 0
             THEN
                  (NVL (mm.val_recupero_1, 0) / cp.val_utilizzo_1)
                / val_utilizzo_tot
             ELSE
                0
          END
             val_rapporto_1,
          CASE
             WHEN cp.val_utilizzo_2 != 0 AND cp.val_utilizzo_tot != 0
             THEN
                  (NVL (mm.val_recupero_2, 0) / cp.val_utilizzo_2)
                / val_utilizzo_tot
             ELSE
                0
          END
             val_rapporto_2,
          CASE
             WHEN cp.val_utilizzo_3 != 0 AND cp.val_utilizzo_tot != 0
             THEN
                  (NVL (mm.val_recupero_3, 0) / cp.val_utilizzo_3)
                / val_utilizzo_tot
             ELSE
                0
          END
             val_rapporto_3,
          0 val_scsb_uti_cassa,
          0 val_scsb_uti_firma,
          0 val_scsb_uti_deriv,
          mese_precedente val_scsb_uti_tot                       --mod 03.2013
     FROM (  SELECT cp.id_dper,
                    cp.cod_abi,
                    cp.cod_ndg,
                    cp.cod_stato,
                    cp.dta_decorrenza_stato,
                    cp.cod_struttura_competente,
                    cp.val_espos_lorda_cassa,
                    cp.val_espos_lorda_firma,
                    cp.val_espos_lorda_deriv,
                    cp.val_espos_lorda_tot,
                    cp.val_espos_netta_cassa,
                    cp.val_espos_netta_firma,
                    cp.val_espos_netta_tot,
                    cp.mese_precedente,                          --mod 03.2013
                    NVL (ee.val_per_ce + ee.val_rett_sval + ee.val_rett_att, 0)
                       val_rett_lorde_cassa,
                    0 val_rett_lorde_firma,
                    NVL (ee.val_per_ce + ee.val_rett_sval + ee.val_rett_att, 0)
                       val_rett_lorde_tot,
                    NVL (
                         ee.val_rip_mora
                       + ee.val_quota_sval
                       + ee.val_quota_att
                       + ee.val_rip_sval
                       + ee.val_rip_att
                       + ee.val_attualizzazione,
                       0)
                       val_riprese_cassa,
                    0 val_riprese_firma,
                    NVL (
                         ee.val_rip_mora
                       + ee.val_quota_sval
                       + ee.val_quota_att
                       + ee.val_rip_sval
                       + ee.val_rip_att
                       + ee.val_attualizzazione,
                       0)
                       val_riprese_tot,
                    NVL (
                         (ee.val_per_ce + ee.val_rett_sval + ee.val_rett_att)
                       - (  ee.val_rip_mora
                          + ee.val_quota_sval
                          + ee.val_quota_att
                          + ee.val_rip_sval
                          + ee.val_rip_att
                          + ee.val_attualizzazione),
                       0)
                       val_rett_nette_cassa,
                    0 val_rett_nette_firma,
                    NVL (
                         (ee.val_per_ce + ee.val_rett_sval + ee.val_rett_att)
                       - (  ee.val_rip_mora
                          + ee.val_quota_sval
                          + ee.val_quota_att
                          + ee.val_rip_sval
                          + ee.val_rip_att
                          + ee.val_attualizzazione),
                       0)
                       val_rett_nette_tot,
                    NVL (ee.val_per_ce, 0) val_per_ce,
                    NVL (ee.val_rett_sval, 0) val_rett_sval,
                    NVL (ee.val_rett_att, 0) val_rett_att,
                    NVL (ee.val_rip_mora, 0) val_rip_mora,
                    NVL (ee.val_quota_sval, 0) val_quota_sval,
                    NVL (ee.val_quota_att, 0) val_quota_att,
                    NVL (ee.val_rip_sval, 0) val_rip_sval,
                    NVL (ee.val_rip_att, 0) val_rip_att,
                    NVL (ee.val_attualizzazione, 0) val_attualizzazione,
                    NVL (uti.val_utilizzo_0, 0) val_utilizzo_0,
                    NVL (uti.val_utilizzo_1, 0) val_utilizzo_1,
                    NVL (uti.val_utilizzo_2, 0) val_utilizzo_2,
                    NVL (uti.val_utilizzo_3, 0) val_utilizzo_3,
                    NVL (uti.val_utilizzo_tot, 0) val_utilizzo_tot
               FROM (  SELECT                                --mod 03.2013 INI
                             id_dper,
                              cod_abi,
                              cod_ndg,
                              MIN (cod_stato_rischio) cod_stato,
                              TO_CHAR (MIN (dta_decorrenza_stato), 'YYYYMMDD')
                                 dta_decorrenza_stato,
                              MIN (cod_filiale_area) cod_struttura_competente,
                              SUM (
                                 CASE
                                    WHEN UPPER (val_firma) = 'FIRMA' THEN 0
                                    ELSE NVL (val_uti_ret, 0)
                                 END)
                                 val_espos_lorda_cassa,
                              SUM (
                                 CASE
                                    WHEN UPPER (val_firma) = 'FIRMA'
                                    THEN
                                       NVL (val_uti_ret, 0)
                                    ELSE
                                       0
                                 END)
                                 val_espos_lorda_firma,
                              0 val_espos_lorda_deriv,
                              SUM (NVL (val_uti_ret, 0)) val_espos_lorda_tot,
                              SUM (
                                 CASE
                                    WHEN UPPER (val_firma) = 'FIRMA' THEN 0
                                    ELSE NVL (val_att, 0)
                                 END)
                                 val_espos_netta_cassa,
                              SUM (
                                 CASE
                                    WHEN UPPER (val_firma) = 'FIRMA'
                                    THEN
                                       NVL (val_att, 0)
                                    ELSE
                                       0
                                 END)
                                 val_espos_netta_firma,
                              SUM (NVL (val_att, 0)) val_espos_netta_tot,
                              0 mese_precedente
                         FROM mcre_own.t_mcres_app_sisba_cp
                        WHERE     id_dper =
                                     TO_CHAR (
                                        LAST_DAY (
                                           TO_DATE (
                                              SYS_CONTEXT ('userenv',
                                                           'client_info'),
                                              'yyyymm')),
                                        'yyyymmdd')
                              AND UPPER (cod_stato_rischio) IN ('I', 'PD', 'R')
                     GROUP BY id_dper, cod_abi, cod_ndg
                     UNION
                       SELECT TO_NUMBER (
                                 TO_CHAR (
                                    LAST_DAY (
                                       TO_DATE (
                                          SYS_CONTEXT ('userenv', 'client_info'),
                                          'yyyymm')),
                                    'yyyymmdd'))
                                 id_dper,
                              cp.cod_abi,
                              cp.cod_ndg,
                              MIN (cp.cod_stato_rischio) cod_stato,
                              TO_CHAR (MIN (cp.dta_decorrenza_stato), 'YYYYMMDD')
                                 dta_decorrenza_stato,
                              MIN (cp.cod_filiale_area) cod_struttura_competente,
                              SUM (
                                 CASE
                                    WHEN UPPER (cp.val_firma) = 'FIRMA' THEN 0
                                    ELSE NVL (cp.val_uti_ret, 0)
                                 END)
                                 val_espos_lorda_cassa,
                              SUM (
                                 CASE
                                    WHEN UPPER (cp.val_firma) = 'FIRMA'
                                    THEN
                                       NVL (cp.val_uti_ret, 0)
                                    ELSE
                                       0
                                 END)
                                 val_espos_lorda_firma,
                              0 val_espos_lorda_deriv,
                              SUM (NVL (cp.val_uti_ret, 0)) val_espos_lorda_tot,
                              SUM (
                                 CASE
                                    WHEN UPPER (cp.val_firma) = 'FIRMA' THEN 0
                                    ELSE NVL (cp.val_att, 0)
                                 END)
                                 val_espos_netta_cassa,
                              SUM (
                                 CASE
                                    WHEN UPPER (cp.val_firma) = 'FIRMA'
                                    THEN
                                       NVL (cp.val_att, 0)
                                    ELSE
                                       0
                                 END)
                                 val_espos_netta_firma,
                              SUM (NVL (cp.val_att, 0)) val_espos_netta_tot,
                              1 mese_precedente
                         FROM mcre_own.t_mcres_app_sisba_cp cp,
                              (  SELECT cp.cod_abi, cp.cod_ndg
                                   FROM mcre_own.t_mcres_app_sisba_cp cp,
                                        mcre_own.t_mcres_app_effetti_economici ee
                                  WHERE     cp.id_dper =
                                               TO_CHAR (
                                                  LAST_DAY (
                                                     ADD_MONTHS (
                                                        TO_DATE (
                                                           SYS_CONTEXT (
                                                              'userenv',
                                                              'client_info'),
                                                           'yyyymm'),
                                                        -1)),
                                                  'yyyymmdd')
                                        AND UPPER (cod_stato_rischio) IN
                                               ('I', 'PD', 'R')
                                        AND ee.id_dper =
                                               TO_CHAR (
                                                  LAST_DAY (
                                                     TO_DATE (
                                                        SYS_CONTEXT ('userenv',
                                                                     'client_info'),
                                                        'yyyymm')),
                                                  'yyyymmdd')
                                        AND cp.cod_abi = ee.cod_abi
                                        AND cp.cod_ndg = ee.cod_ndg
                               GROUP BY cp.cod_abi, cp.cod_ndg
                               MINUS
                                 SELECT cod_abi, cod_ndg
                                   FROM mcre_own.t_mcres_app_sisba_cp
                                  WHERE     id_dper =
                                               TO_CHAR (
                                                  LAST_DAY (
                                                     TO_DATE (
                                                        SYS_CONTEXT ('userenv',
                                                                     'client_info'),
                                                        'yyyymm')),
                                                  'yyyymmdd')
                                        AND UPPER (cod_stato_rischio) IN
                                               ('I', 'PD', 'R')
                               GROUP BY cod_abi, cod_ndg) pos
                        WHERE     cp.id_dper =
                                     TO_CHAR (
                                        LAST_DAY (
                                           ADD_MONTHS (
                                              TO_DATE (
                                                 SYS_CONTEXT ('userenv',
                                                              'client_info'),
                                                 'yyyymm'),
                                              -1)),
                                        'yyyymmdd')
                              AND cp.cod_abi = pos.cod_abi
                              AND cp.cod_ndg = pos.cod_ndg
                     GROUP BY cp.cod_abi, cp.cod_ndg) cp,    --mod 03.2013 FIN
                    (  SELECT cp.id_dper,
                              cp.cod_abi,
                              cp.cod_ndg,
                              SUM (
                                 CASE
                                    WHEN NVL (SUBSTR (uti.id_dper, 1, 4), 0) =
                                            SUBSTR (cp.id_dper, 1, 4)
                                    THEN
                                       NVL (uti.val_uti_ret, 0)
                                    ELSE
                                       0
                                 END)
                                 val_utilizzo_0,
                              SUM (
                                 CASE
                                    WHEN NVL (SUBSTR (uti.id_dper, 1, 4), 0) =
                                            SUBSTR (cp.id_dper, 1, 4) - 1
                                    THEN
                                       NVL (uti.val_uti_ret, 0)
                                    ELSE
                                       0
                                 END)
                                 val_utilizzo_1,
                              SUM (
                                 CASE
                                    WHEN NVL (SUBSTR (uti.id_dper, 1, 4), 0) =
                                            SUBSTR (cp.id_dper, 1, 4) - 2
                                    THEN
                                       NVL (uti.val_uti_ret, 0)
                                    ELSE
                                       0
                                 END)
                                 val_utilizzo_2,
                              SUM (
                                 CASE
                                    WHEN NVL (SUBSTR (uti.id_dper, 1, 4), 0) =
                                            SUBSTR (cp.id_dper, 1, 4) - 3
                                    THEN
                                       NVL (uti.val_uti_ret, 0)
                                    ELSE
                                       0
                                 END)
                                 val_utilizzo_3,
                              SUM (NVL (uti.val_uti_ret, 0)) val_utilizzo_tot
                         FROM mcre_own.t_mcres_app_sisba_cp cp,
                              mcre_own.t_mcres_app_sisba_cp uti
                        WHERE     cp.id_dper =
                                     TO_CHAR (
                                        LAST_DAY (
                                           TO_DATE (
                                              SYS_CONTEXT ('userenv',
                                                           'client_info'),
                                              'yyyymm')),
                                        'yyyymmdd')
                              AND (   uti.id_dper = cp.id_dper
                                   OR (uti.id_dper =
                                              (  SUBSTR (
                                                    SYS_CONTEXT ('userenv',
                                                                 'client_info'),
                                                    1,
                                                    4)
                                               - 1)
                                            * 10000
                                          + 1231)
                                   OR (uti.id_dper =
                                              (  SUBSTR (
                                                    SYS_CONTEXT ('userenv',
                                                                 'client_info'),
                                                    1,
                                                    4)
                                               - 2)
                                            * 10000
                                          + 1231)
                                   OR (uti.id_dper =
                                              (  SUBSTR (
                                                    SYS_CONTEXT ('userenv',
                                                                 'client_info'),
                                                    1,
                                                    4)
                                               - 3)
                                            * 10000
                                          + 1231))
                              AND UPPER (uti.cod_stato_rischio) = 'I'
                              AND uti.cod_abi = cp.cod_abi
                              AND uti.cod_ndg = cp.cod_ndg
                     GROUP BY cp.id_dper, cp.cod_abi, cp.cod_ndg) uti,
                    mcre_own.t_mcres_app_effetti_economici ee
              WHERE     uti.id_dper(+) = cp.id_dper
                    AND uti.cod_abi(+) = cp.cod_abi
                    AND uti.cod_ndg(+) = cp.cod_ndg
                    AND ee.id_dper(+) = cp.id_dper
                    AND ee.cod_abi(+) = cp.cod_abi
                    AND ee.cod_ndg(+) = cp.cod_ndg
           GROUP BY cp.id_dper,
                    cp.cod_abi,
                    cp.cod_ndg,
                    cp.cod_stato,
                    cp.dta_decorrenza_stato,
                    cp.cod_struttura_competente,
                    cp.val_espos_lorda_cassa,
                    cp.val_espos_lorda_firma,
                    cp.val_espos_lorda_deriv,
                    cp.val_espos_lorda_tot,
                    cp.val_espos_netta_cassa,
                    cp.val_espos_netta_firma,
                    cp.val_espos_netta_tot,
                    cp.mese_precedente,
                    ee.val_per_ce,
                    ee.val_rett_sval,
                    ee.val_rett_att,
                    ee.val_rip_mora,
                    ee.val_quota_sval,
                    ee.val_quota_att,
                    ee.val_rip_sval,
                    ee.val_rip_att,
                    ee.val_attualizzazione,
                    uti.val_utilizzo_0,
                    uti.val_utilizzo_1,
                    uti.val_utilizzo_2,
                    uti.val_utilizzo_3,
                    uti.val_utilizzo_tot) cp,
          (  SELECT cp.id_dper,
                    cp.cod_abi,
                    cp.cod_ndg,
                    SUM (
                       CASE
                          WHEN SUBSTR (mm.id_dper, 1, 4) =
                                  SUBSTR (cp.id_dper, 1, 4)
                          THEN
                             NVL (mm.val_cr_tot, 0)
                          ELSE
                             0
                       END)
                       val_recupero_0,
                    SUM (
                       CASE
                          WHEN SUBSTR (mm.id_dper, 1, 4) =
                                  SUBSTR (cp.id_dper, 1, 4) - 1
                          THEN
                             NVL (mm.val_cr_tot, 0)
                          ELSE
                             0
                       END)
                       val_recupero_1,
                    SUM (
                       CASE
                          WHEN SUBSTR (mm.id_dper, 1, 4) =
                                  SUBSTR (cp.id_dper, 1, 4) - 2
                          THEN
                             NVL (mm.val_cr_tot, 0)
                          ELSE
                             0
                       END)
                       val_recupero_2,
                    SUM (
                       CASE
                          WHEN SUBSTR (mm.id_dper, 1, 4) =
                                  SUBSTR (cp.id_dper, 1, 4) - 3
                          THEN
                             NVL (mm.val_cr_tot, 0)
                          ELSE
                             0
                       END)
                       val_recupero_3
               FROM mcre_own.t_mcres_app_sisba_cp cp,
                    mcre_own.t_mcres_app_movimenti_mod_mov mm
              WHERE     cp.id_dper =
                           TO_CHAR (
                              LAST_DAY (
                                 TO_DATE (
                                    SYS_CONTEXT ('userenv', 'client_info'),
                                    'yyyymm')),
                              'yyyymmdd')
                    AND UPPER (cp.cod_stato_rischio) IN ('I', 'PD', 'R')
                    AND cp.cod_abi = mm.cod_abi
                    AND cp.cod_ndg = mm.cod_ndg
                    AND mm.id_dper BETWEEN TO_CHAR (
                                              LAST_DAY (
                                                 TO_DATE (
                                                      SYS_CONTEXT (
                                                         'userenv',
                                                         'client_info')
                                                    - 300,
                                                    'yyyymm')),
                                              'yyyymmdd')
                                       AND cp.id_dper
                    AND (   mm.desc_modulo IN
                               ('ALL.7 - INCAGLIATE ESTINTE',
                                'ALL.8 - INCAGLIATE RIDOTTE')      -- Bilancio
                         OR mm.desc_modulo IN
                               (SELECT DISTINCT desc_modulo
                                  FROM t_mcres_cl_mcrdmodmov
                                 WHERE     val_source = 'MCRD'
                                       AND UPPER (val_sottotipologia) =
                                              'INCASSO')               -- MCRD
                                                        )
           GROUP BY cp.id_dper, cp.cod_abi, cp.cod_ndg) mm
    WHERE     cp.cod_abi = mm.cod_abi(+)
          AND cp.cod_ndg = mm.cod_ndg(+)
          AND cp.id_dper = mm.id_dper(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_QDC_CDR_BILANCIO TO MCRE_USR;
