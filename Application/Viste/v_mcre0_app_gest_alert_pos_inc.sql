/* Formatted on 21/07/2014 18:33:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_GEST_ALERT_POS_INC
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_MACROSTATO,
   DESC_ALERT,
   DESC_GRUPPO_RISCHIO,
   ID_ALERT,
   ID_GRUPPO,
   VAL_COLORE,
   VAL_COLORE_TOTALE,
   VAL_FATTORE_RISCHIO,
   VAL_ORDINE_GRUPPO_RISCHIO,
   VAL_ORDINE_RISCHIO,
   VAL_PESO,
   VAL_PESO_TOTALE
)
AS
   SELECT r.cod_abi_cartolarizzato,
          r.cod_ndg,
          r.cod_macrostato,
          r.desc_alert,
          desc_gruppo_rischio,
          id_alert,
          r.id_gruppo,
          r.val_colore,
          CASE
             WHEN SUM (
                       r.val_fattore_rischio
                     * DECODE (
                          val_colore,
                          'V', val_verde,
                          DECODE (val_colore,
                                  'A', val_arancio,
                                  DECODE (val_colore, 'R', val_rosso, NULL))))
                  OVER (
                     PARTITION BY cod_abi_cartolarizzato, cod_ndg, id_gruppo) <=
                     45
             THEN
                'V'
             WHEN SUM (
                       r.val_fattore_rischio
                     * DECODE (
                          val_colore,
                          'V', val_verde,
                          DECODE (val_colore,
                                  'A', val_arancio,
                                  DECODE (val_colore, 'R', val_rosso, NULL))))
                  OVER (
                     PARTITION BY cod_abi_cartolarizzato, cod_ndg, id_gruppo) BETWEEN 46
                                                                                  AND 69
             THEN
                'A'
             WHEN SUM (
                       r.val_fattore_rischio
                     * DECODE (
                          val_colore,
                          'V', val_verde,
                          DECODE (val_colore,
                                  'A', val_arancio,
                                  DECODE (val_colore, 'R', val_rosso, NULL))))
                  OVER (
                     PARTITION BY cod_abi_cartolarizzato, cod_ndg, id_gruppo) >=
                     70
             THEN
                'R'
             ELSE
                NULL
          END
             val_colore_totale,
          r.val_fattore_rischio,
          val_ordine_gruppo_rischio,
          val_ordine_rischio,
            r.val_fattore_rischio
          * DECODE (
               val_colore,
               'V', val_verde,
               DECODE (val_colore,
                       'A', val_arancio,
                       DECODE (val_colore, 'R', val_rosso, NULL)))
             val_peso,
          SUM (
               r.val_fattore_rischio
             * DECODE (
                  val_colore,
                  'V', val_verde,
                  DECODE (val_colore,
                          'A', val_arancio,
                          DECODE (val_colore, 'R', val_rosso, NULL))))
          OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg, id_gruppo)
             val_peso_totale
     FROM (SELECT DISTINCT
                  p.cod_abi_cartolarizzato,
                  p.cod_ndg,
                  a.id_alert,
                  --aggiunta distinct
                  a.desc_alert,
                  a.val_verde,
                  a.val_rosso,
                  a.val_arancio,
                  a.val_gruppo val_ordine_rischio,
                  SUBSTR (a.val_gruppo, 0, 1) val_ordine_gruppo_rischio,
                  a.desc_gruppo desc_gruppo_rischio,
                  DECODE (a.cod_privilegio,
                          'A', a.val_fattore_rischio_a,
                          a.val_fattore_rischio_e)
                     val_fattore_rischio,
                  a.id_gruppo,
                  x.cod_macrostato,
                  CASE
                     WHEN a.id_alert = 1 THEN p.alert_1
                     WHEN a.id_alert = 2 THEN p.alert_2
                     WHEN a.id_alert = 3 THEN p.alert_3
                     WHEN a.id_alert = 4 THEN p.alert_4
                     WHEN a.id_alert = 5 THEN p.alert_5
                     WHEN a.id_alert = 6 THEN p.alert_6
                     WHEN a.id_alert = 7 THEN p.alert_7
                     WHEN a.id_alert = 8 THEN p.alert_8
                     WHEN a.id_alert = 9 THEN p.alert_9
                     WHEN a.id_alert = 10 THEN p.alert_10
                     WHEN a.id_alert = 11 THEN p.alert_11
                     WHEN a.id_alert = 12 THEN p.alert_12
                     WHEN a.id_alert = 13 THEN p.alert_13
                     WHEN a.id_alert = 14 THEN p.alert_14
                     WHEN a.id_alert = 15 THEN p.alert_15
                     WHEN a.id_alert = 16 THEN p.alert_16
                     WHEN a.id_alert = 17 THEN p.alert_17
                     WHEN a.id_alert = 18 THEN p.alert_18
                     WHEN a.id_alert = 19 THEN p.alert_19
                     WHEN a.id_alert = 20 THEN p.alert_20
                     WHEN a.id_alert = 21 THEN p.alert_21
                     WHEN a.id_alert = 22 THEN p.alert_22
                     WHEN a.id_alert = 23 THEN p.alert_23
                     WHEN a.id_alert = 24 THEN p.alert_24
                     WHEN a.id_alert = 25 THEN p.alert_25
                     WHEN a.id_alert = 40 THEN p.alert_40
                     WHEN a.id_alert = 41 THEN p.alert_41
                     ELSE NULL
                  END
                     val_colore
             FROM t_mcre0_app_alert_pos p,
                  v_mcre0_app_upd_fields_p1 x,
                  (SELECT a.*, r.cod_privilegio, r.id_gruppo
                     FROM t_mcre0_app_alert a, t_mcre0_app_alert_ruoli r
                    WHERE     a.id_alert = r.id_alert(+)
                          AND a.flg_attivo = 'A'
                          AND a.flg_rio = 1
                          AND val_gruppo IS NOT NULL) a
            WHERE     p.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato
                  AND p.cod_ndg = x.cod_ndg
           --              AND x.cod_macrostato = 'RIO'
           UNION ALL
           SELECT p.cod_abi AS cod_abi_cartolarizzato,
                  p.cod_ndg,
                  a.id_alert_da_esporre AS id_alert,
                  a.desc_alert,
                  a.val_verde,
                  a.val_rosso,
                  a.val_arancio,
                  a.val_gruppo val_ordine_rischio,
                  SUBSTR (a.val_gruppo, 0, 1) val_ordine_gruppo_rischio,
                  a.desc_gruppo desc_gruppo_rischio,
                  DECODE (a.cod_privilegio,
                          'A', a.val_fattore_rischio_a,
                          a.val_fattore_rischio_e)
                     val_fattore_rischio,
                  a.id_gruppo,
                  p.cod_stato AS cod_macrostato,
                  p.alert AS val_colore
             FROM t_mcrei_app_alert_pos_wrk p,
                  v_mcre0_app_upd_fields_p1 x,
                  (SELECT a.*, r.cod_privilegio, r.id_gruppo
                     FROM t_mcrei_app_alert a, t_mcrei_app_alert_ruoli r
                    WHERE     a.id_alert = r.id_alert(+)
                          AND a.flg_attivo = 'A'
                          AND a.flg_in = 1
                          AND val_gruppo IS NOT NULL) a
            WHERE     p.id_alert = a.id_alert
                  AND p.cod_abi = x.cod_abi_cartolarizzato
                  AND p.cod_ndg = x.cod_ndg) r;
