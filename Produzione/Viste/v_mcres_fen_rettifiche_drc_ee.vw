/* Formatted on 17/06/2014 18:12:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETTIFICHE_DRC_EE
(
   ID_DPER,
   COD_ABI,
   COD_DIVISIONE,
   VAL_DI_CUI_DRC
)
AS
     SELECT                             --- 24/04/2012 ----mese delibere VG-AG
            --- 09/05/2012 ---fix duplicazione filiale AG
            id_dper,
            cod_abi,
            cod_divisione,
            SUM (val_di_cui_drc) val_di_cui_DRC
       FROM (  SELECT ee.id_dper,
                      ee.cod_abi,
                      ee.cod_ndg,
                      MAX (cp.dta_decorrenza_stato),
                      NVL (div.cod_divisione, 3) cod_divisione,
                      MAX (dta_aggiornamento_delibera),
                      CASE
                         WHEN    (MAX (cp.dta_decorrenza_stato) IS NULL)
                              OR (TO_DATE (ee.id_dper, 'yyyymmdd') >=
                                     ADD_MONTHS (
                                        LAST_DAY (MAX (cp.dta_decorrenza_stato)),
                                        3))
                              OR TO_CHAR (MAX (d.dta_aggiornamento_delibera),
                                          'YYYYMM') < SUBSTR (ee.id_dper, 1, 6)
                         THEN
                              (ee.val_per_ce + ee.val_rett_sval + ee.val_rett_att)
                            - (  ee.val_rip_mora
                               + ee.val_quota_sval
                               + ee.val_quota_att
                               + ee.val_rip_sval
                               + ee.val_rip_att
                               + ee.val_attualizzazione)
                         ELSE
                            0
                      END
                         val_di_cui_DRC
                 FROM t_mcres_app_effetti_economici ee,
                      t_mcres_app_sisba_cp cp,
                      t_mcres_app_delibere d,
                      (SELECT id_dper,
                              cod_abi,
                              cod_ndg,
                              CASE
                                 WHEN cod_div IN ('DIVRE', 'DIVCI', 'DIVPR')
                                 THEN
                                    1
                                 WHEN o.cod_div IN
                                         ('DIVCC', 'DIVLC', 'DIVFI', 'DIVES')
                                 THEN
                                    2
                                 ELSE
                                    3
                              END
                                 cod_divisione
                         FROM (  SELECT id_dper,
                                        cod_abi,
                                        cod_ndg,
                                        MAX (cod_filiale) cod_filiale
                                   FROM t_mcres_app_sisba_cp
                                  WHERE cod_stato_rischio = 'S'
                               GROUP BY id_dper, cod_abi, cod_ndg) cp,
                              t_mcre0_app_struttura_org o
                        WHERE     cod_abi = cod_abi_istituto(+)
                              AND cod_filiale = cod_struttura_competente(+)) div
                WHERE     0 = 0
                      AND (ee.cod_stato_ini = 'S') --cosidero solo le posizioni che a inizio mese sono a sofferenza (se stato_ini != 'S' e stato_fin= 'S' allora la posizione è entrata a sofferenza nel mese considerato e di_cui_drc = 0)
                      AND ee.cod_abi = cp.cod_abi(+)
                      AND ee.cod_ndg = cp.cod_ndg(+)
                      AND cp.id_dper(+) =
                             TO_NUMBER (
                                TO_CHAR (
                                   ADD_MONTHS (TO_DATE (ee.id_dper, 'yyyymmdd'),
                                               -1),
                                   'yyyymmdd'))
                      AND cp.cod_stato_rischio(+) = 'S'
                      AND ee.id_dper = div.id_dper(+)
                      AND ee.cod_abi = div.cod_abi(+)
                      AND ee.cod_ndg = div.cod_ndg(+)
                      AND ee.cod_abi = d.cod_abi(+)
                      AND ee.cod_ndg = d.cod_ndg(+)
                      AND d.cod_delibera(+) = 'NS'
                      AND d.cod_stato_delibera(+) = 'CO'
                      AND d.dta_aggiornamento_delibera(+) BETWEEN   ADD_MONTHS (
                                                                       ee.dta_effetti_economici,
                                                                       -3)
                                                                  + 1
                                                              AND ee.dta_effetti_economici
                      AND NOT EXISTS
                                 (SELECT 1
                                    FROM t_mcres_app_delibere d
                                   WHERE     0 = 0
                                         AND ee.cod_abi = d.cod_abi
                                         AND ee.cod_ndg = d.cod_ndg
                                         AND d.cod_delibera = 'NZ'
                                         AND d.cod_stato_delibera = 'CO'
                                         AND d.dta_aggiornamento_delibera <=
                                                TO_DATE (ee.id_dper, 'yyyymmdd'))
             GROUP BY ee.id_dper,
                      ee.cod_abi,
                      ee.cod_ndg,
                      ee.val_per_ce,
                      ee.val_rett_sval,
                      ee.val_rett_att,
                      ee.val_rip_mora,
                      ee.val_quota_sval,
                      ee.val_quota_att,
                      ee.val_rip_sval,
                      ee.val_rip_att,
                      ee.val_attualizzazione,
                      NVL (div.cod_divisione, 3))
   GROUP BY id_dper, cod_abi, cod_divisione;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_RETTIFICHE_DRC_EE TO MCRE_USR;
