/* Formatted on 21/07/2014 18:44:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALERT_CNT
(
   ID_UTENTE,
   ID_REFERENTE,
   COD_COMPARTO_POSIZIONE,
   COD_RAMO_CALCOLATO,
   ID_ALERT,
   DESC_ALERT,
   VAL_ORDINE_A,
   VAL_ORDINE_E,
   GB_V,
   GB_A,
   GB_R,
   PT_V,
   PT_A,
   PT_R,
   RIO_V,
   RIO_A,
   RIO_R,
   RS_V,
   RS_A,
   RS_R,
   IN_V,
   IN_A,
   IN_R,
   SC_V,
   SC_A,
   SC_R,
   ID_GRUPPO,
   COD_PRIVILEGIO
)
AS
   SELECT AL."ID_UTENTE",
          AL."ID_REFERENTE",
          AL."COD_COMPARTO_POSIZIONE",
          al."COD_RAMO_CALCOLATO",
          al."ID_ALERT",
          al."DESC_ALERT",
          al."VAL_ORDINE_A",
          al."VAL_ORDINE_E",
          al."GB_V",
          al."GB_A",
          al."GB_R",
          al."PT_V",
          al."PT_A",
          al."PT_R",
          al."RIO_V",
          al."RIO_A",
          al."RIO_R",
          al."RS_V",
          al."RS_A",
          al."RS_R",
          al."IN_V",
          al."IN_A",
          al."IN_R",
          al."SC_V",
          al."SC_A",
          al."SC_R",
          r.id_gruppo,
          r.cod_privilegio
     FROM (  SELECT -- v1.0 06/04/2011 V.Galli Nuova versione per migliore performance + privilegi e ordinamento
                 -- v1.1 22/04/2011 V.Galli Macrostato precedente per alert 16
                                     -- v1.2 27/04/2011 V.Galli Alert 22 23 24
                                           -- v1.3 09/05/2011 V.Galli Alert 25
                    -- v1.4 30/05/2011 V.Galli Outer Join per stato_precedente
                    id_utente,
                    id_referente,
                    cod_comparto_posizione,
                    cod_ramo_calcolato,
                    id_alert,
                    desc_alert,
                    val_ordine_a,
                    val_ordine_e,
                    SUM (gb_v) gb_v,
                    SUM (gb_a) gb_a,
                    SUM (gb_r) gb_r,
                    SUM (pt_v) pt_v,
                    SUM (pt_a) pt_a,
                    SUM (pt_r) pt_r,
                    SUM (rio_v) rio_v,
                    SUM (rio_a) rio_a,
                    SUM (rio_r) rio_r,
                    SUM (rs_v) rs_v,
                    SUM (rs_a) rs_a,
                    SUM (rs_r) rs_r,
                    SUM (in_v) in_v,
                    SUM (in_a) in_a,
                    SUM (in_r) in_r,
                    SUM (sc_v) sc_v,
                    SUM (sc_a) sc_a,
                    SUM (sc_r) sc_r
               FROM (SELECT DISTINCT
                            id_utente,
                            id_referente,
                            cod_comparto_posizione,
                            cod_ramo_calcolato,
                            a.id_alert,
                            desc_alert,
                            val_ordine_a,
                            val_ordine_e,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'GB'
                                    AND alert_1 = 'V'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'GB'
                                    AND alert_2 = 'V'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'GB'
                                    AND alert_3 = 'V'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'GB'
                                    AND alert_4 = 'V'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'GB'
                                    AND alert_5 = 'V'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'GB'
                                    AND alert_6 = 'V'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'GB'
                                    AND alert_7 = 'V'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'GB'
                                    AND alert_8 = 'V'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'GB'
                                    AND alert_9 = 'V'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'GB'
                                    AND alert_10 = 'V'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'GB'
                                    AND alert_11 = 'V'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'GB'
                                    AND alert_12 = 'V'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'GB'
                                    AND alert_13 = 'V'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'GB'
                                    AND alert_14 = 'V'
                               THEN
                                  cnt_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'GB'
                                    AND ALERT_15 = 'V'
                               THEN
                                  CNT_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'GB'
                                    AND alert_16 = 'V'
                               THEN
                                  cnt_16
                               WHEN     a.ID_ALERT = 17
                                    AND COD_STATO = 'GB'
                                    AND ALERT_17 = 'V'
                               THEN
                                  CNT_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'GB'
                                    AND ALERT_18 = 'V'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'GB'
                                    AND ALERT_19 = 'V'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'GB'
                                    AND ALERT_20 = 'V'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'GB'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'GB'
                                    AND ALERT_22 = 'V'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'GB'
                                    AND ALERT_23 = 'V'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'GB'
                                    AND ALERT_24 = 'V'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'GB'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               GB_v,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'GB'
                                    AND alert_1 = 'R'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'GB'
                                    AND alert_2 = 'R'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'GB'
                                    AND alert_3 = 'R'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'GB'
                                    AND alert_4 = 'R'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'GB'
                                    AND alert_5 = 'R'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'GB'
                                    AND alert_6 = 'R'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'GB'
                                    AND alert_7 = 'R'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'GB'
                                    AND alert_8 = 'R'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'GB'
                                    AND alert_9 = 'R'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'GB'
                                    AND alert_10 = 'R'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'GB'
                                    AND alert_11 = 'R'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'GB'
                                    AND alert_12 = 'R'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'GB'
                                    AND alert_13 = 'R'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'GB'
                                    AND alert_14 = 'R'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'GB'
                                    AND alert_15 = 'R'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'GB'
                                    AND alert_16 = 'R'
                               THEN
                                  cnt_16
                               WHEN     a.ID_ALERT = 17
                                    AND COD_STATO = 'GB'
                                    AND ALERT_17 = 'R'
                               THEN
                                  CNT_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'GB'
                                    AND ALERT_18 = 'R'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'GB'
                                    AND ALERT_19 = 'R'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'GB'
                                    AND ALERT_20 = 'R'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'GB'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'GB'
                                    AND ALERT_22 = 'R'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'GB'
                                    AND ALERT_23 = 'R'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'GB'
                                    AND ALERT_24 = 'R'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'GB'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               GB_r,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'GB'
                                    AND alert_1 = 'A'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'GB'
                                    AND alert_2 = 'A'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'GB'
                                    AND alert_3 = 'A'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'GB'
                                    AND alert_4 = 'A'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'GB'
                                    AND alert_5 = 'A'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'GB'
                                    AND alert_6 = 'A'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'GB'
                                    AND alert_7 = 'A'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'GB'
                                    AND alert_8 = 'A'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'GB'
                                    AND alert_9 = 'A'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'GB'
                                    AND alert_10 = 'A'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'GB'
                                    AND alert_11 = 'A'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'GB'
                                    AND alert_12 = 'A'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'GB'
                                    AND alert_13 = 'A'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'GB'
                                    AND alert_14 = 'A'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'GB'
                                    AND alert_15 = 'A'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'GB'
                                    AND alert_16 = 'A'
                               THEN
                                  cnt_16
                               WHEN     a.ID_ALERT = 17
                                    AND COD_STATO = 'GB'
                                    AND ALERT_17 = 'A'
                               THEN
                                  CNT_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'GB'
                                    AND ALERT_18 = 'A'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'GB'
                                    AND ALERT_19 = 'A'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'GB'
                                    AND ALERT_20 = 'A'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'GB'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'GB'
                                    AND ALERT_22 = 'A'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'GB'
                                    AND ALERT_23 = 'A'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'GB'
                                    AND ALERT_24 = 'A'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'GB'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               GB_a,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'PT'
                                    AND alert_1 = 'V'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'PT'
                                    AND alert_2 = 'V'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'PT'
                                    AND alert_3 = 'V'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'PT'
                                    AND alert_4 = 'V'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'PT'
                                    AND alert_5 = 'V'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'PT'
                                    AND alert_6 = 'V'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'PT'
                                    AND alert_7 = 'V'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'PT'
                                    AND alert_8 = 'V'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'PT'
                                    AND alert_9 = 'V'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'PT'
                                    AND alert_10 = 'V'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'PT'
                                    AND alert_11 = 'V'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'PT'
                                    AND alert_12 = 'V'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'PT'
                                    AND alert_13 = 'V'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'PT'
                                    AND alert_14 = 'V'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'PT'
                                    AND alert_15 = 'V'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'PT'
                                    AND alert_16 = 'V'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'PT'
                                    AND alert_17 = 'V'
                               THEN
                                  cnt_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'PT'
                                    AND ALERT_18 = 'V'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'PT'
                                    AND ALERT_19 = 'V'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'PT'
                                    AND ALERT_20 = 'V'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'PT'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'PT'
                                    AND ALERT_22 = 'V'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'PT'
                                    AND ALERT_23 = 'V'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'PT'
                                    AND ALERT_24 = 'V'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'PT'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               PT_v,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'PT'
                                    AND alert_1 = 'R'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'PT'
                                    AND alert_2 = 'R'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'PT'
                                    AND alert_3 = 'R'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'PT'
                                    AND alert_4 = 'R'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'PT'
                                    AND alert_5 = 'R'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'PT'
                                    AND alert_6 = 'R'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'PT'
                                    AND alert_7 = 'R'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'PT'
                                    AND alert_8 = 'R'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'PT'
                                    AND alert_9 = 'R'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'PT'
                                    AND alert_10 = 'R'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'PT'
                                    AND alert_11 = 'R'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'PT'
                                    AND alert_12 = 'R'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'PT'
                                    AND alert_13 = 'R'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'PT'
                                    AND alert_14 = 'R'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'PT'
                                    AND alert_15 = 'R'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'PT'
                                    AND alert_16 = 'R'
                               THEN
                                  cnt_16
                               WHEN     a.ID_ALERT = 17
                                    AND COD_STATO = 'PT'
                                    AND ALERT_17 = 'R'
                               THEN
                                  CNT_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'PT'
                                    AND ALERT_18 = 'R'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'PT'
                                    AND ALERT_19 = 'R'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'PT'
                                    AND ALERT_20 = 'R'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'PT'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'PT'
                                    AND ALERT_22 = 'R'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'PT'
                                    AND ALERT_23 = 'R'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'PT'
                                    AND ALERT_24 = 'R'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'PT'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               PT_r,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'PT'
                                    AND alert_1 = 'A'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'PT'
                                    AND alert_2 = 'A'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'PT'
                                    AND alert_3 = 'A'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'PT'
                                    AND alert_4 = 'A'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'PT'
                                    AND alert_5 = 'A'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'PT'
                                    AND alert_6 = 'A'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'PT'
                                    AND alert_7 = 'A'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'PT'
                                    AND alert_8 = 'A'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'PT'
                                    AND alert_9 = 'A'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'PT'
                                    AND alert_10 = 'A'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'PT'
                                    AND alert_11 = 'A'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'PT'
                                    AND alert_12 = 'A'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'PT'
                                    AND alert_13 = 'A'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'PT'
                                    AND alert_14 = 'A'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'PT'
                                    AND alert_15 = 'A'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'PT'
                                    AND alert_16 = 'A'
                               THEN
                                  cnt_16
                               WHEN     a.ID_ALERT = 17
                                    AND COD_STATO = 'PT'
                                    AND ALERT_17 = 'A'
                               THEN
                                  CNT_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'PT'
                                    AND ALERT_18 = 'A'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'PT'
                                    AND ALERT_19 = 'A'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'PT'
                                    AND ALERT_20 = 'A'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'PT'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'PT'
                                    AND ALERT_22 = 'A'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'PT'
                                    AND ALERT_23 = 'A'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'PT'
                                    AND ALERT_24 = 'A'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'PT'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               PT_a,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'RIO'
                                    AND alert_1 = 'V'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'RIO'
                                    AND alert_2 = 'V'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'RIO'
                                    AND alert_3 = 'V'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'RIO'
                                    AND alert_4 = 'V'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'RIO'
                                    AND alert_5 = 'V'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'RIO'
                                    AND alert_6 = 'V'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'RIO'
                                    AND alert_7 = 'V'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'RIO'
                                    AND alert_8 = 'V'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'RIO'
                                    AND alert_9 = 'V'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'RIO'
                                    AND alert_10 = 'V'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'RIO'
                                    AND alert_11 = 'V'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'RIO'
                                    AND alert_12 = 'V'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'RIO'
                                    AND alert_13 = 'V'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'RIO'
                                    AND alert_14 = 'V'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'RIO'
                                    AND alert_15 = 'V'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'RIO'
                                    AND alert_16 = 'V'
                               THEN
                                  cnt_16
                               WHEN     a.ID_ALERT = 17
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_17 = 'V'
                               THEN
                                  CNT_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_18 = 'V'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_19 = 'V'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_20 = 'V'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RIO'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_22 = 'V'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_23 = 'V'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_24 = 'V'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RIO'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               rio_v,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'RIO'
                                    AND alert_1 = 'R'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'RIO'
                                    AND alert_2 = 'R'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'RIO'
                                    AND alert_3 = 'R'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'RIO'
                                    AND alert_4 = 'R'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'RIO'
                                    AND alert_5 = 'R'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'RIO'
                                    AND alert_6 = 'R'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'RIO'
                                    AND alert_7 = 'R'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'RIO'
                                    AND alert_8 = 'R'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'RIO'
                                    AND alert_9 = 'R'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'RIO'
                                    AND alert_10 = 'R'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'RIO'
                                    AND alert_11 = 'R'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'RIO'
                                    AND alert_12 = 'R'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'RIO'
                                    AND alert_13 = 'R'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'RIO'
                                    AND alert_14 = 'R'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'RIO'
                                    AND alert_15 = 'R'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'RIO'
                                    AND alert_16 = 'R'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'RIO'
                                    AND alert_17 = 'R'
                               THEN
                                  cnt_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_18 = 'R'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_19 = 'R'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_20 = 'R'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RIO'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_22 = 'R'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_23 = 'R'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_24 = 'R'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RIO'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               rio_r,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'RIO'
                                    AND alert_1 = 'A'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'RIO'
                                    AND alert_2 = 'A'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'RIO'
                                    AND alert_3 = 'A'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'RIO'
                                    AND alert_4 = 'A'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'RIO'
                                    AND alert_5 = 'A'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'RIO'
                                    AND alert_6 = 'A'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'RIO'
                                    AND alert_7 = 'A'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'RIO'
                                    AND alert_8 = 'A'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'RIO'
                                    AND alert_9 = 'A'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'RIO'
                                    AND alert_10 = 'A'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'RIO'
                                    AND alert_11 = 'A'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'RIO'
                                    AND alert_12 = 'A'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'RIO'
                                    AND alert_13 = 'A'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'RIO'
                                    AND alert_14 = 'A'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'RIO'
                                    AND alert_15 = 'A'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'RIO'
                                    AND alert_16 = 'A'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'RIO'
                                    AND alert_17 = 'A'
                               THEN
                                  cnt_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_18 = 'A'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_19 = 'A'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_20 = 'A'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RIO'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_22 = 'A'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_23 = 'A'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_24 = 'A'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RIO'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               rio_a,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'SC'
                                    AND alert_1 = 'V'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'SC'
                                    AND alert_2 = 'V'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'SC'
                                    AND alert_3 = 'V'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'SC'
                                    AND alert_4 = 'V'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'SC'
                                    AND alert_5 = 'V'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'SC'
                                    AND alert_6 = 'V'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'SC'
                                    AND alert_7 = 'V'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'SC'
                                    AND alert_8 = 'V'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'SC'
                                    AND alert_9 = 'V'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'SC'
                                    AND alert_10 = 'V'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'SC'
                                    AND alert_11 = 'V'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'SC'
                                    AND alert_12 = 'V'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'SC'
                                    AND alert_13 = 'V'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'SC'
                                    AND alert_14 = 'V'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'SC'
                                    AND alert_15 = 'V'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'SC'
                                    AND alert_16 = 'V'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'SC'
                                    AND alert_17 = 'V'
                               THEN
                                  cnt_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'SC'
                                    AND ALERT_18 = 'V'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'SC'
                                    AND ALERT_19 = 'V'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'SC'
                                    AND ALERT_20 = 'V'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'SC'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'SC'
                                    AND ALERT_22 = 'V'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'SC'
                                    AND ALERT_23 = 'V'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'SC'
                                    AND ALERT_24 = 'V'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'SC'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               SC_v,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'SC'
                                    AND alert_1 = 'R'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'SC'
                                    AND alert_2 = 'R'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'SC'
                                    AND alert_3 = 'R'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'SC'
                                    AND alert_4 = 'R'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'SC'
                                    AND alert_5 = 'R'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'SC'
                                    AND alert_6 = 'R'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'SC'
                                    AND alert_7 = 'R'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'SC'
                                    AND alert_8 = 'R'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'SC'
                                    AND alert_9 = 'R'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'SC'
                                    AND alert_10 = 'R'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'SC'
                                    AND alert_11 = 'R'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'SC'
                                    AND alert_12 = 'R'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'SC'
                                    AND alert_13 = 'R'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'SC'
                                    AND alert_14 = 'R'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'SC'
                                    AND alert_15 = 'R'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'SC'
                                    AND alert_16 = 'R'
                               THEN
                                  cnt_16
                               WHEN     a.ID_ALERT = 17
                                    AND COD_STATO = 'SC'
                                    AND ALERT_17 = 'R'
                               THEN
                                  CNT_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'SC'
                                    AND ALERT_18 = 'R'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'SC'
                                    AND ALERT_19 = 'R'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'SC'
                                    AND ALERT_20 = 'R'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'SC'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'SC'
                                    AND ALERT_22 = 'R'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'SC'
                                    AND ALERT_23 = 'R'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'SC'
                                    AND ALERT_24 = 'R'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'SC'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               SC_r,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'SC'
                                    AND alert_1 = 'A'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'SC'
                                    AND alert_2 = 'A'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'SC'
                                    AND alert_3 = 'A'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'SC'
                                    AND alert_4 = 'A'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'SC'
                                    AND alert_5 = 'A'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'SC'
                                    AND alert_6 = 'A'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'SC'
                                    AND alert_7 = 'A'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'SC'
                                    AND alert_8 = 'A'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'SC'
                                    AND alert_9 = 'A'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'SC'
                                    AND alert_10 = 'A'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'SC'
                                    AND alert_11 = 'A'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'SC'
                                    AND alert_12 = 'A'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'SC'
                                    AND alert_13 = 'A'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'SC'
                                    AND alert_14 = 'A'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'SC'
                                    AND alert_15 = 'A'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'SC'
                                    AND alert_16 = 'A'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'SC'
                                    AND alert_17 = 'A'
                               THEN
                                  cnt_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'SC'
                                    AND ALERT_18 = 'A'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'SC'
                                    AND ALERT_19 = 'A'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'SC'
                                    AND ALERT_20 = 'A'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'SC'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'SC'
                                    AND ALERT_22 = 'A'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'SC'
                                    AND ALERT_23 = 'A'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'SC'
                                    AND ALERT_24 = 'A'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'SC'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               SC_a,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'IN'
                                    AND alert_1 = 'V'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'IN'
                                    AND alert_2 = 'V'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'IN'
                                    AND alert_3 = 'V'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'IN'
                                    AND alert_4 = 'V'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'IN'
                                    AND alert_5 = 'V'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'IN'
                                    AND alert_6 = 'V'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'IN'
                                    AND alert_7 = 'V'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'IN'
                                    AND alert_8 = 'V'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'IN'
                                    AND alert_9 = 'V'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'IN'
                                    AND alert_10 = 'V'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'IN'
                                    AND alert_11 = 'V'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'IN'
                                    AND alert_12 = 'V'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'IN'
                                    AND alert_13 = 'V'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'IN'
                                    AND alert_14 = 'V'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'IN'
                                    AND alert_15 = 'V'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'IN'
                                    AND alert_16 = 'V'
                               THEN
                                  cnt_16
                               WHEN     a.ID_ALERT = 17
                                    AND COD_STATO = 'IN'
                                    AND ALERT_17 = 'V'
                               THEN
                                  CNT_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'IN'
                                    AND ALERT_18 = 'V'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'IN'
                                    AND ALERT_19 = 'V'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'IN'
                                    AND ALERT_20 = 'V'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'IN'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'IN'
                                    AND ALERT_22 = 'V'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'IN'
                                    AND ALERT_23 = 'V'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'IN'
                                    AND ALERT_24 = 'V'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'IN'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               in_v,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'IN'
                                    AND alert_1 = 'R'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'IN'
                                    AND alert_2 = 'R'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'IN'
                                    AND alert_3 = 'R'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'IN'
                                    AND alert_4 = 'R'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'IN'
                                    AND alert_5 = 'R'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'IN'
                                    AND alert_6 = 'R'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'IN'
                                    AND alert_7 = 'R'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'IN'
                                    AND alert_8 = 'R'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'IN'
                                    AND alert_9 = 'R'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'IN'
                                    AND alert_10 = 'R'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'IN'
                                    AND alert_11 = 'R'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'IN'
                                    AND alert_12 = 'R'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'IN'
                                    AND alert_13 = 'R'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'IN'
                                    AND alert_14 = 'R'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'IN'
                                    AND alert_15 = 'R'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'IN'
                                    AND alert_16 = 'R'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'IN'
                                    AND alert_17 = 'R'
                               THEN
                                  cnt_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'IN'
                                    AND ALERT_18 = 'R'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'IN'
                                    AND ALERT_19 = 'R'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'IN'
                                    AND ALERT_20 = 'R'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'IN'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'IN'
                                    AND ALERT_22 = 'R'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'IN'
                                    AND ALERT_23 = 'R'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'IN'
                                    AND ALERT_24 = 'R'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'IN'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               in_r,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'IN'
                                    AND alert_1 = 'A'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'IN'
                                    AND alert_2 = 'A'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'IN'
                                    AND alert_3 = 'A'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'IN'
                                    AND alert_4 = 'A'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'IN'
                                    AND alert_5 = 'A'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'IN'
                                    AND alert_6 = 'A'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'IN'
                                    AND alert_7 = 'A'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'IN'
                                    AND alert_8 = 'A'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'IN'
                                    AND alert_9 = 'A'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'IN'
                                    AND alert_10 = 'A'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'IN'
                                    AND alert_11 = 'A'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'IN'
                                    AND alert_12 = 'A'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'IN'
                                    AND alert_13 = 'A'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'IN'
                                    AND alert_14 = 'A'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'IN'
                                    AND alert_15 = 'A'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'IN'
                                    AND alert_16 = 'A'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'IN'
                                    AND alert_17 = 'A'
                               THEN
                                  cnt_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'IN'
                                    AND ALERT_18 = 'A'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'IN'
                                    AND ALERT_19 = 'A'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'IN'
                                    AND ALERT_20 = 'A'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'IN'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'IN'
                                    AND ALERT_22 = 'A'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'IN'
                                    AND ALERT_23 = 'A'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'IN'
                                    AND ALERT_24 = 'A'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'IN'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               in_a,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'RS'
                                    AND alert_1 = 'V'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'RS'
                                    AND alert_2 = 'V'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'RS'
                                    AND alert_3 = 'V'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'RS'
                                    AND alert_4 = 'V'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'RS'
                                    AND alert_5 = 'V'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'RS'
                                    AND alert_6 = 'V'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'RS'
                                    AND alert_7 = 'V'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'RS'
                                    AND alert_8 = 'V'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'RS'
                                    AND alert_9 = 'V'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'RS'
                                    AND alert_10 = 'V'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'RS'
                                    AND alert_11 = 'V'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'RS'
                                    AND alert_12 = 'V'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'RS'
                                    AND alert_13 = 'V'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'RS'
                                    AND alert_14 = 'V'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'RS'
                                    AND alert_15 = 'V'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'RS'
                                    AND alert_16 = 'V'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'RS'
                                    AND alert_17 = 'V'
                               THEN
                                  cnt_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'RS'
                                    AND ALERT_18 = 'V'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'RS'
                                    AND ALERT_19 = 'V'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'RS'
                                    AND ALERT_20 = 'V'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RS'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'RS'
                                    AND ALERT_22 = 'V'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'RS'
                                    AND ALERT_23 = 'V'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'RS'
                                    AND ALERT_24 = 'V'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RS'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               RS_v,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'RS'
                                    AND alert_1 = 'R'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'RS'
                                    AND alert_2 = 'R'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'RS'
                                    AND alert_3 = 'R'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'RS'
                                    AND alert_4 = 'R'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'RS'
                                    AND alert_5 = 'R'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'RS'
                                    AND alert_6 = 'R'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'RS'
                                    AND alert_7 = 'R'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'RS'
                                    AND alert_8 = 'R'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'RS'
                                    AND alert_9 = 'R'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'RS'
                                    AND alert_10 = 'R'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'RS'
                                    AND alert_11 = 'R'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'RS'
                                    AND alert_12 = 'R'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'RS'
                                    AND alert_13 = 'R'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'RS'
                                    AND alert_14 = 'R'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'RS'
                                    AND alert_15 = 'R'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'RS'
                                    AND alert_16 = 'R'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'RS'
                                    AND alert_17 = 'R'
                               THEN
                                  cnt_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'RS'
                                    AND ALERT_18 = 'R'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'RS'
                                    AND ALERT_19 = 'R'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'RS'
                                    AND ALERT_20 = 'R'
                               THEN
                                  CNT_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RS'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'RS'
                                    AND ALERT_22 = 'R'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'RS'
                                    AND ALERT_23 = 'R'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'RS'
                                    AND ALERT_24 = 'R'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RS'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               RS_r,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'RS'
                                    AND alert_1 = 'A'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'RS'
                                    AND alert_2 = 'A'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'RS'
                                    AND alert_3 = 'A'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'RS'
                                    AND alert_4 = 'A'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'RS'
                                    AND alert_5 = 'A'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'RS'
                                    AND alert_6 = 'A'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'RS'
                                    AND alert_7 = 'A'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'RS'
                                    AND alert_8 = 'A'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'RS'
                                    AND alert_9 = 'A'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'RS'
                                    AND alert_10 = 'A'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'RS'
                                    AND alert_11 = 'A'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'RS'
                                    AND alert_12 = 'A'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'RS'
                                    AND alert_13 = 'A'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'RS'
                                    AND alert_14 = 'A'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'RS'
                                    AND alert_15 = 'A'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'RS'
                                    AND alert_16 = 'A'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'RS'
                                    AND alert_17 = 'A'
                               THEN
                                  cnt_17
                               WHEN     a.ID_ALERT = 18
                                    AND COD_STATO = 'RS'
                                    AND ALERT_18 = 'A'
                               THEN
                                  CNT_18
                               WHEN     a.ID_ALERT = 19
                                    AND COD_STATO = 'RS'
                                    AND ALERT_19 = 'A'
                               THEN
                                  CNT_19
                               WHEN     a.ID_ALERT = 20
                                    AND COD_STATO = 'RS'
                                    AND ALERT_20 = 'A'
                               THEN
                                  CNT_20
                               WHEN     a.ID_ALERT = 21
                                    AND COD_STATO = 'RS'
                                    AND ALERT_21 = 'A'
                               THEN
                                  CNT_21
                               WHEN     a.ID_ALERT = 22
                                    AND COD_STATO = 'RS'
                                    AND ALERT_22 = 'A'
                               THEN
                                  CNT_22
                               WHEN     a.ID_ALERT = 23
                                    AND COD_STATO = 'RS'
                                    AND ALERT_23 = 'A'
                               THEN
                                  CNT_23
                               WHEN     a.ID_ALERT = 24
                                    AND COD_STATO = 'RS'
                                    AND ALERT_24 = 'A'
                               THEN
                                  CNT_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RS'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               ELSE
                                  0
                            END
                               RS_a
                       FROM (SELECT /*+ ordered no_parallel(p) */
                                   DISTINCT
                                    X.ID_UTENTE,
                                    x.ID_REFERENTE,
                                    COD_COMPARTO COD_COMPARTO_POSIZIONE,
                                    COD_RAMO_CALCOLATO,
                                    x.cod_macrostato cod_stato,
                                    x.cod_macrostato cod_stato_precedente,
                                    alert_1,
                                    DECODE (
                                       alert_1,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_1,
                                                       x.cod_macrostato))
                                       cnt_1,
                                    alert_2,
                                    DECODE (
                                       alert_2,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_2,
                                                       x.cod_macrostato))
                                       cnt_2,
                                    alert_3,
                                    DECODE (
                                       alert_3,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_3,
                                                       x.cod_macrostato))
                                       cnt_3,
                                    alert_4,
                                    DECODE (
                                       alert_4,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_4,
                                                       x.cod_macrostato))
                                       cnt_4,
                                    alert_5,
                                    DECODE (
                                       alert_5,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_5,
                                                       x.cod_macrostato))
                                       cnt_5,
                                    alert_6,
                                    DECODE (
                                       alert_6,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_6,
                                                       x.cod_macrostato))
                                       cnt_6,
                                    alert_7,
                                    DECODE (
                                       alert_7,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_7,
                                                       x.cod_macrostato))
                                       cnt_7,
                                    alert_8,
                                    DECODE (
                                       alert_8,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_8,
                                                       x.cod_macrostato))
                                       cnt_8,
                                    alert_9,
                                    DECODE (
                                       alert_9,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_9,
                                                       x.cod_macrostato))
                                       cnt_9,
                                    alert_10,
                                    DECODE (
                                       alert_10,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_10,
                                                       x.cod_macrostato))
                                       cnt_10,
                                    alert_11,
                                    DECODE (
                                       alert_11,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_11,
                                                       x.cod_macrostato))
                                       cnt_11,
                                    alert_12,
                                    DECODE (
                                       alert_12,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_12,
                                                       x.cod_macrostato))
                                       cnt_12,
                                    alert_13,
                                    DECODE (
                                       alert_13,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_13,
                                                       x.cod_macrostato))
                                       cnt_13,
                                    alert_14,
                                    DECODE (
                                       alert_14,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_14,
                                                       x.cod_macrostato))
                                       cnt_14,
                                    alert_15,
                                    DECODE (
                                       alert_15,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.ID_REFERENTE,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_15,
                                                       x.cod_macrostato))
                                       cnt_15,
                                    ALERT_16,
                                    DECODE (
                                       ALERT_16,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       x.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_16,
                                                       x.cod_macrostato))
                                       CNT_16,
                                    ALERT_17,
                                    DECODE (
                                       ALERT_17,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       x.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_17,
                                                       x.cod_macrostato))
                                       CNT_17,
                                    ALERT_18,
                                    DECODE (
                                       ALERT_18,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       x.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_18,
                                                       x.cod_macrostato))
                                       CNT_18,
                                    ALERT_19,
                                    DECODE (
                                       ALERT_19,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       x.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_19,
                                                       x.cod_macrostato))
                                       CNT_19,
                                    ALERT_20,
                                    DECODE (
                                       ALERT_20,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       x.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_20,
                                                       X.COD_MACROSTATO))
                                       CNT_20,
                                    ALERT_21,
                                    DECODE (
                                       ALERT_21,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       x.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_21,
                                                       X.COD_MACROSTATO))
                                       CNT_21,
                                    ALERT_22,
                                    DECODE (
                                       ALERT_22,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       x.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_22,
                                                       X.COD_MACROSTATO))
                                       CNT_22,
                                    ALERT_23,
                                    DECODE (
                                       ALERT_23,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       x.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_23,
                                                       X.COD_MACROSTATO))
                                       CNT_23,
                                    ALERT_24,
                                    DECODE (
                                       ALERT_24,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       x.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_24,
                                                       X.COD_MACROSTATO))
                                       CNT_24,
                                    ALERT_25,
                                    DECODE (
                                       ALERT_25,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       x.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_25,
                                                       X.COD_MACROSTATO))
                                       CNT_25
                               FROM t_mcre0_app_alert_pos p,
                                    -----    V_MCRE0_APP_UPD_FIELDS_ALL x--,
                                    -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
                                    V_MCRE0_APP_UPD_FIELDS x               --,
                              -- MCRE_OWN.MV_MCRE0_APP_ISTITUTI I,
                              -- MCRE_OWN.T_MCRE0_APP_UTENTI U,
                              --  t_mcre0_app_stati s
                              WHERE     x.cod_abi_cartolarizzato =
                                           p.cod_abi_cartolarizzato
                                    AND X.COD_NDG = P.COD_NDG
                                    --  AND x.cod_stato_precedente =  s.COD_MICROSTATO(+)
                                    --    AND p.cod_abi_cartolarizzato = i.cod_abi(+)
                                    --    AND x.id_utente = u.id_utente(+)
                                    --   AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
                                    AND X.FLG_OUTSOURCING = 'Y'
                                    --     AND I.FLG_TARGET = 'Y'
                                    AND x.FLG_TARGET = 'Y') b,
                            t_mcre0_app_alert a
                      WHERE a.flg_attivo = 'A')
           GROUP BY id_utente,
                    id_referente,
                    cod_comparto_posizione,
                    cod_ramo_calcolato,
                    id_alert,
                    desc_alert,
                    val_ordine_a,
                    val_ordine_e) al,
          t_mcre0_app_alert_ruoli r
    WHERE al.id_alert = r.id_alert;
