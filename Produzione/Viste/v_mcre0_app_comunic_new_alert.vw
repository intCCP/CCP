/* Formatted on 17/06/2014 18:01:18 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_COMUNIC_NEW_ALERT
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   VAL_ANA_GRE,
   COD_STATO,
   DTA_ALERT,
   DESC_ALERT,
   VAL_COLORE_ALERT,
   ID_UTENTE,
   ID_REFERENTE,
   COD_COMPARTO,
   ID_ALERT,
   ID_GRUPPO,
   COD_GRUPPO_COMPARTI
)
AS
   SELECT                                           /*ordered noparallel(a) */
          -- VG 14/03/2011Comparto
          -- VG 07/04/2011 id_alert
          -- VG 20/04/2011 RIFATTA!!!
          s.cod_abi_cartolarizzato,
          s.cod_abi_istituto,
          s.cod_ndg,
          s.desc_nome_controparte,
          s.desc_gruppo_economico val_ana_gre,
          s.cod_stato,
          dta_alert,
          desc_alert,
          val_colore_alert,
          s.id_utente,
          s.id_referente,
          s.cod_comparto,
          s.id_alert,
          s.id_gruppo,
          s.cod_gruppo_comparti
     FROM (SELECT /*+ ORDERED */
                 DISTINCT
                  p.cod_abi_cartolarizzato,
                  p.cod_ndg,
                  p.cod_sndg,
                  f.cod_abi_istituto,
                  f.desc_nome_controparte,
                  f.desc_gruppo_economico,
                  f.cod_stato,
                  f.id_utente,
                  f.id_referente,
                  f.cod_comparto,
                  id_alert,
                  desc_alert,
                  CASE
                     WHEN id_alert = 1 THEN alert_1
                     WHEN id_alert = 2 THEN alert_2
                     WHEN id_alert = 3 THEN alert_3
                     WHEN id_alert = 4 THEN alert_4
                     WHEN id_alert = 5 THEN alert_5
                     WHEN id_alert = 6 THEN alert_6
                     WHEN id_alert = 7 THEN alert_7
                     WHEN id_alert = 8 THEN alert_8
                     WHEN id_alert = 9 THEN alert_9
                     WHEN id_alert = 10 THEN alert_10
                     WHEN id_alert = 11 THEN alert_11
                     WHEN id_alert = 12 THEN alert_12
                     WHEN id_alert = 13 THEN alert_13
                     WHEN id_alert = 14 THEN alert_14
                     WHEN id_alert = 15 THEN alert_15
                     WHEN id_alert = 16 THEN alert_16
                     WHEN id_alert = 17 THEN alert_17
                     WHEN id_alert = 18 THEN alert_18
                     WHEN id_alert = 19 THEN alert_19
                     WHEN id_alert = 20 THEN alert_20
                     WHEN id_alert = 21 THEN alert_21
                  END
                     val_colore_alert,
                  CASE
                     WHEN id_alert = 1
                     THEN
                        DECODE (TRUNC (dta_ins_1) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_1),
                                TRUNC (dta_upd_1))
                     WHEN id_alert = 2
                     THEN
                        DECODE (TRUNC (dta_ins_2) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_2),
                                TRUNC (dta_upd_2))
                     WHEN id_alert = 3
                     THEN
                        DECODE (TRUNC (dta_ins_3) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_3),
                                TRUNC (dta_upd_3))
                     WHEN id_alert = 4
                     THEN
                        DECODE (TRUNC (dta_ins_4) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_4),
                                TRUNC (dta_upd_4))
                     WHEN id_alert = 5
                     THEN
                        DECODE (TRUNC (dta_ins_5) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_5),
                                TRUNC (dta_upd_5))
                     WHEN id_alert = 6
                     THEN
                        DECODE (TRUNC (dta_ins_6) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_6),
                                TRUNC (dta_upd_6))
                     WHEN id_alert = 7
                     THEN
                        DECODE (TRUNC (dta_ins_7) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_7),
                                TRUNC (dta_upd_7))
                     WHEN id_alert = 8
                     THEN
                        DECODE (TRUNC (dta_ins_8) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_8),
                                TRUNC (dta_upd_8))
                     WHEN id_alert = 9
                     THEN
                        DECODE (TRUNC (dta_ins_9) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_9),
                                TRUNC (dta_upd_9))
                     WHEN id_alert = 10
                     THEN
                        DECODE (TRUNC (dta_ins_10) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_10),
                                TRUNC (dta_upd_10))
                     WHEN id_alert = 11
                     THEN
                        DECODE (TRUNC (dta_ins_11) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_11),
                                TRUNC (dta_upd_11))
                     WHEN id_alert = 12
                     THEN
                        DECODE (TRUNC (dta_ins_12) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_12),
                                TRUNC (dta_upd_12))
                     WHEN id_alert = 13
                     THEN
                        DECODE (TRUNC (dta_ins_13) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_13),
                                TRUNC (dta_upd_13))
                     WHEN id_alert = 14
                     THEN
                        DECODE (TRUNC (dta_ins_14) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_14),
                                TRUNC (dta_upd_14))
                     WHEN id_alert = 15
                     THEN
                        DECODE (TRUNC (dta_ins_15) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_15),
                                TRUNC (dta_upd_15))
                     WHEN id_alert = 16
                     THEN
                        DECODE (TRUNC (dta_ins_16) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_16),
                                TRUNC (dta_upd_16))
                     WHEN id_alert = 17
                     THEN
                        DECODE (TRUNC (dta_ins_17) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_17),
                                TRUNC (dta_upd_17))
                     WHEN id_alert = 18
                     THEN
                        DECODE (TRUNC (dta_ins_18) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_18),
                                TRUNC (dta_upd_18))
                     WHEN id_alert = 19
                     THEN
                        DECODE (TRUNC (dta_ins_19) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_19),
                                TRUNC (dta_upd_19))
                     WHEN id_alert = 20
                     THEN
                        DECODE (TRUNC (dta_ins_20) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_20),
                                TRUNC (dta_upd_20))
                     WHEN id_alert = 21
                     THEN
                        DECODE (TRUNC (dta_ins_21) - TRUNC (SYSDATE),
                                0, TRUNC (dta_ins_21),
                                TRUNC (dta_upd_21))
                  END
                     dta_alert,
                  ru.id_gruppo, --06/01/2013 campi aggiunti per poter filtrare
                  ru.cod_gruppo_comparti
             FROM v_mcre0_app_upd_fields f,
                  t_mcre0_app_alert_pos p,
                  (SELECT a.id_alert,
                          a.desc_alert,
                          r.id_gruppo,
                          r.cod_gruppo_comparti
                     FROM t_mcre0_app_alert a, t_mcre0_app_alert_ruoli r
                    WHERE flg_attivo = 'A' AND a.id_alert = r.id_alert --AND r.id_gruppo = 930  --06/01/2013 tolto filtro interno
                                                                      ) ru --   and R.COD_PRIVILEGIO = 'A')
            WHERE     p.cod_abi_cartolarizzato = f.cod_abi_cartolarizzato
                  AND p.cod_ndg = f.cod_ndg
                  AND f.flg_outsourcing = 'Y'
                  AND f.flg_target = 'Y'
                  AND f.id_utente <> -1
                  AND ru.cod_gruppo_comparti =
                         (SELECT cod_gruppo_comparti
                            FROM t_mcre0_app_comparti
                           WHERE cod_comparto = f.cod_comparto) -- T.B.: MODIFICA 23/04/2014
                                                               ) s
    --  v_mcre0_app_upd_fields f
    WHERE     1 = 1 --              f.cod_abi_cartolarizzato = s.cod_abi_cartolarizzato
 --          AND f.cod_ndg = s.cod_ndg   -- AND f.cod_abi_istituto = i.cod_abi(+)
                                                                            --
 --          AND f.flg_outsourcing = 'Y'                -- AND I.FLG_TARGET = 'Y'
 --          AND f.flg_target = 'Y'                -- AND f.id_utente IS NOT NULL
                                             --          AND f.id_utente <> -1
          AND s.dta_alert >= TRUNC (SYSDATE)
          AND s.val_colore_alert IS NOT NULL;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_COMUNIC_NEW_ALERT TO MCRE_USR;
