/* Formatted on 21/07/2014 18:31:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_CNT
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
   SO_V,
   SO_A,
   SO_R,
   PM_V,
   PM_A,
   PM_R,
   RM_V,
   RM_A,
   RM_R,
   ID_GRUPPO,
   COD_PRIVILEGIO,
   COD_GRUPPO_COMPARTI
)
AS
   SELECT al."ID_UTENTE",
          al."ID_REFERENTE",
          al."COD_COMPARTO_POSIZIONE",
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
          al."SO_V",
          al."SO_A",
          al."SO_R",
          al."PM_V",
          al."PM_A",
          al."PM_R",
          al."RM_V",
          al."RM_A",
          AL."RM_R",
          r.id_gruppo,
          r.cod_privilegio,
          r.cod_gruppo_comparti
     FROM (  SELECT -- v1.0 06/04/2011 V.Galli Nuova versione per migliore performance + privilegi e ordinamento
                 -- v1.1 22/04/2011 V.Galli Macrostato precedente per alert 16
                                     -- v1.2 27/04/2011 V.Galli Alert 22 23 24
                                           -- v1.3 09/05/2011 V.Galli Alert 25
                    -- v1.4 30/05/2011 V.Galli Outer Join per stato_precedente
      -- v2 26/07/2012 V.Galli aggiunti alert 40 e 41   e  COD_GRUPPO_COMPARTI
 -- v3 12/10/2012 I.Gueorguieva Alert incagli (seconda union): raggruppamento per macrostati
 -- v4.4 17/10/2012 M.Ceru' Alert 45 aggiungere le colonne per il nuovo allert nella t_mcre0_app_alert_pos
                               -- attualmente esposti: GB, PT, RIO, RS, IN, SC
                           -- v5 16/11/2012 M.Murro ripristinata presa visione
 -- v6 09/06/2014 L.Guatteo aggiuti segnaposto nelle tre select per stati PM ed RM
                                  -- v7 01/07/2014 VG logiche PM RM e alert 49
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
                    SUM (sc_r) sc_r,
                    SUM (so_v) so_v,
                    SUM (so_a) so_a,
                    SUM (so_r) so_r,
                    SUM (pm_v) pm_v,
                    SUM (pm_a) pm_a,
                    SUM (pm_r) pm_r,
                    SUM (rm_v) Rm_v,
                    SUM (rm_a) Rm_a,
                    SUM (rm_r) Rm_r
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
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'GB'
                                    AND alert_15 = 'V'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'GB'
                                    AND alert_16 = 'V'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'GB'
                                    AND alert_17 = 'V'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'GB'
                                    AND alert_18 = 'V'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'GB'
                                    AND alert_19 = 'V'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'GB'
                                    AND alert_20 = 'V'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'GB'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'GB'
                                    AND alert_22 = 'V'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'GB'
                                    AND alert_23 = 'V'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'GB'
                                    AND alert_24 = 'V'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'GB'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'GB'
                                    AND alert_40 = 'V'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'GB'
                                    AND alert_41 = 'V'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'GB'
                                    AND alert_45 = 'V'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'GB'
                                    AND alert_49 = 'V'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               gb_v,
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
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'GB'
                                    AND alert_17 = 'R'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'GB'
                                    AND alert_18 = 'R'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'GB'
                                    AND alert_19 = 'R'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'GB'
                                    AND alert_20 = 'R'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'GB'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'GB'
                                    AND alert_22 = 'R'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'GB'
                                    AND alert_23 = 'R'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'GB'
                                    AND alert_24 = 'R'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'GB'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'GB'
                                    AND alert_40 = 'R'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'GB'
                                    AND alert_41 = 'R'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'GB'
                                    AND alert_41 = 'R'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'GB'
                                    AND alert_49 = 'R'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               gb_r,
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
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'GB'
                                    AND alert_17 = 'A'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'GB'
                                    AND alert_18 = 'A'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'GB'
                                    AND alert_19 = 'A'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'GB'
                                    AND alert_20 = 'A'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'GB'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'GB'
                                    AND alert_22 = 'A'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'GB'
                                    AND alert_23 = 'A'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'GB'
                                    AND alert_24 = 'A'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'GB'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'GB'
                                    AND alert_40 = 'A'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'GB'
                                    AND alert_41 = 'A'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'GB'
                                    AND alert_45 = 'A'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'GB'
                                    AND alert_49 = 'A'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               gb_a,
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
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'PT'
                                    AND alert_18 = 'V'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'PT'
                                    AND alert_19 = 'V'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'PT'
                                    AND alert_20 = 'V'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'PT'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'PT'
                                    AND alert_22 = 'V'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'PT'
                                    AND alert_23 = 'V'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'PT'
                                    AND alert_24 = 'V'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'PT'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'PT'
                                    AND alert_40 = 'V'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'PT'
                                    AND alert_41 = 'V'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'PT'
                                    AND alert_45 = 'V'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'PT'
                                    AND alert_49 = 'V'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               pt_v,
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
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'PT'
                                    AND alert_17 = 'R'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'PT'
                                    AND alert_18 = 'R'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'PT'
                                    AND alert_19 = 'R'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'PT'
                                    AND alert_20 = 'R'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'PT'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'PT'
                                    AND alert_22 = 'R'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'PT'
                                    AND alert_23 = 'R'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'PT'
                                    AND alert_24 = 'R'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'PT'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'PT'
                                    AND alert_40 = 'R'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'PT'
                                    AND alert_41 = 'R'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'PT'
                                    AND alert_45 = 'R'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'PT'
                                    AND alert_49 = 'R'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               pt_r,
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
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'PT'
                                    AND alert_17 = 'A'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'PT'
                                    AND alert_18 = 'A'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'PT'
                                    AND alert_19 = 'A'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'PT'
                                    AND alert_20 = 'A'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'PT'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'PT'
                                    AND alert_22 = 'A'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'PT'
                                    AND alert_23 = 'A'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'PT'
                                    AND alert_24 = 'A'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'PT'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'PT'
                                    AND alert_40 = 'A'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'PT'
                                    AND alert_41 = 'A'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'PT'
                                    AND alert_45 = 'A'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'PT'
                                    AND alert_49 = 'A'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               pt_a,
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
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'RIO'
                                    AND alert_17 = 'V'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'RIO'
                                    AND alert_18 = 'V'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'RIO'
                                    AND alert_19 = 'V'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'RIO'
                                    AND alert_20 = 'V'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RIO'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'RIO'
                                    AND alert_22 = 'V'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'RIO'
                                    AND alert_23 = 'V'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'RIO'
                                    AND alert_24 = 'V'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RIO'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'RIO'
                                    AND alert_40 = 'V'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'RIO'
                                    AND alert_41 = 'V'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'RIO'
                                    AND alert_45 = 'V'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'RIO'
                                    AND alert_49 = 'V'
                               THEN
                                  cnt_49
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
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'RIO'
                                    AND alert_18 = 'R'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'RIO'
                                    AND alert_19 = 'R'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'RIO'
                                    AND alert_20 = 'R'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RIO'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'RIO'
                                    AND alert_22 = 'R'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'RIO'
                                    AND alert_23 = 'R'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'RIO'
                                    AND alert_24 = 'R'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RIO'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'RIO'
                                    AND alert_40 = 'R'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'RIO'
                                    AND alert_41 = 'R'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'RIO'
                                    AND alert_45 = 'R'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'RIO'
                                    AND alert_49 = 'R'
                               THEN
                                  cnt_49
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
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'RIO'
                                    AND alert_18 = 'A'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'RIO'
                                    AND alert_19 = 'A'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'RIO'
                                    AND alert_20 = 'A'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RIO'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'RIO'
                                    AND alert_22 = 'A'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'RIO'
                                    AND alert_23 = 'A'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'RIO'
                                    AND alert_24 = 'A'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RIO'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'RIO'
                                    AND alert_40 = 'A'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'RIO'
                                    AND alert_41 = 'A'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'RIO'
                                    AND alert_45 = 'A'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'RIO'
                                    AND alert_49 = 'A'
                               THEN
                                  cnt_49
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
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'SC'
                                    AND alert_18 = 'V'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'SC'
                                    AND alert_19 = 'V'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'SC'
                                    AND alert_20 = 'V'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'SC'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'SC'
                                    AND alert_22 = 'V'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'SC'
                                    AND alert_23 = 'V'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'SC'
                                    AND alert_24 = 'V'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'SC'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'SC'
                                    AND alert_40 = 'V'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'SC'
                                    AND alert_41 = 'V'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'SC'
                                    AND alert_45 = 'V'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'SC'
                                    AND alert_49 = 'V'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               sc_v,
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
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'SC'
                                    AND alert_17 = 'R'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'SC'
                                    AND alert_18 = 'R'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'SC'
                                    AND alert_19 = 'R'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'SC'
                                    AND alert_20 = 'R'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'SC'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'SC'
                                    AND alert_22 = 'R'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'SC'
                                    AND alert_23 = 'R'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'SC'
                                    AND alert_24 = 'R'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'SC'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'SC'
                                    AND alert_40 = 'R'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'SC'
                                    AND alert_41 = 'R'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'SC'
                                    AND alert_45 = 'R'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'SC'
                                    AND alert_49 = 'R'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               sc_r,
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
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'SC'
                                    AND alert_18 = 'A'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'SC'
                                    AND alert_19 = 'A'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'SC'
                                    AND alert_20 = 'A'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'SC'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'SC'
                                    AND alert_22 = 'A'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'SC'
                                    AND alert_23 = 'A'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'SC'
                                    AND alert_24 = 'A'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'SC'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'SC'
                                    AND alert_40 = 'A'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'SC'
                                    AND alert_41 = 'A'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'SC'
                                    AND alert_45 = 'A'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'SC'
                                    AND alert_49 = 'A'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               sc_a,
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
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'IN'
                                    AND alert_17 = 'V'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'IN'
                                    AND alert_18 = 'V'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'IN'
                                    AND alert_19 = 'V'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'IN'
                                    AND alert_20 = 'V'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'IN'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'IN'
                                    AND alert_22 = 'V'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'IN'
                                    AND alert_23 = 'V'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'IN'
                                    AND alert_24 = 'V'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'IN'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'IN'
                                    AND alert_40 = 'V'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'IN'
                                    AND alert_41 = 'V'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'IN'
                                    AND alert_45 = 'V'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'IN'
                                    AND alert_49 = 'V'
                               THEN
                                  cnt_49
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
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'IN'
                                    AND alert_18 = 'R'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'IN'
                                    AND alert_19 = 'R'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'IN'
                                    AND alert_20 = 'R'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'IN'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'IN'
                                    AND alert_22 = 'R'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'IN'
                                    AND alert_23 = 'R'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'IN'
                                    AND alert_24 = 'R'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'IN'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'IN'
                                    AND alert_40 = 'R'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'IN'
                                    AND alert_41 = 'R'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'IN'
                                    AND alert_45 = 'R'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'IN'
                                    AND alert_49 = 'R'
                               THEN
                                  cnt_49
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
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'IN'
                                    AND alert_18 = 'A'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'IN'
                                    AND alert_19 = 'A'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'IN'
                                    AND alert_20 = 'A'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'IN'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'IN'
                                    AND alert_22 = 'A'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'IN'
                                    AND alert_23 = 'A'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'IN'
                                    AND alert_24 = 'A'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'IN'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'IN'
                                    AND alert_40 = 'A'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'IN'
                                    AND alert_41 = 'A'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'IN'
                                    AND alert_45 = 'A'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'IN'
                                    AND alert_49 = 'A'
                               THEN
                                  cnt_49
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
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'RS'
                                    AND alert_18 = 'V'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'RS'
                                    AND alert_19 = 'V'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'RS'
                                    AND alert_20 = 'V'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RS'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'RS'
                                    AND alert_22 = 'V'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'RS'
                                    AND alert_23 = 'V'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'RS'
                                    AND alert_24 = 'V'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RS'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'RS'
                                    AND alert_40 = 'V'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'RS'
                                    AND alert_41 = 'V'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'RS'
                                    AND alert_45 = 'V'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'RS'
                                    AND alert_49 = 'V'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               rs_v,
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
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'RS'
                                    AND alert_18 = 'R'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'RS'
                                    AND alert_19 = 'R'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'RS'
                                    AND alert_20 = 'R'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RS'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'RS'
                                    AND alert_22 = 'R'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'RS'
                                    AND alert_23 = 'R'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'RS'
                                    AND alert_24 = 'R'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RS'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'RS'
                                    AND alert_40 = 'R'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'RS'
                                    AND alert_41 = 'R'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'RS'
                                    AND alert_45 = 'R'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'RS'
                                    AND alert_49 = 'R'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               rs_r,
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
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'RS'
                                    AND alert_18 = 'A'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'RS'
                                    AND alert_19 = 'A'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'RS'
                                    AND alert_20 = 'A'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RS'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'RS'
                                    AND alert_22 = 'A'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'RS'
                                    AND alert_23 = 'A'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'RS'
                                    AND alert_24 = 'A'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RS'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'RS'
                                    AND alert_40 = 'A'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'RS'
                                    AND alert_41 = 'A'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'RS'
                                    AND alert_45 = 'A'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'RS'
                                    AND alert_49 = 'A'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               rs_a,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'SO'
                                    AND alert_1 = 'V'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'SO'
                                    AND alert_2 = 'V'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'SO'
                                    AND alert_3 = 'V'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'SO'
                                    AND alert_4 = 'V'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'SO'
                                    AND alert_5 = 'V'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'SO'
                                    AND alert_6 = 'V'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'SO'
                                    AND alert_7 = 'V'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'SO'
                                    AND alert_8 = 'V'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'SO'
                                    AND alert_9 = 'V'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'SO'
                                    AND alert_10 = 'V'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'SO'
                                    AND alert_11 = 'V'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'SO'
                                    AND alert_12 = 'V'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'SO'
                                    AND alert_13 = 'V'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'SO'
                                    AND alert_14 = 'V'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'SO'
                                    AND alert_15 = 'V'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'SO'
                                    AND alert_16 = 'V'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'SO'
                                    AND alert_17 = 'V'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'SO'
                                    AND alert_18 = 'V'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'SO'
                                    AND alert_19 = 'V'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'SO'
                                    AND alert_20 = 'V'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'SO'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'SO'
                                    AND alert_22 = 'V'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'SO'
                                    AND alert_23 = 'V'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'SO'
                                    AND alert_24 = 'V'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'SO'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'SO'
                                    AND alert_40 = 'V'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'SO'
                                    AND alert_41 = 'V'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'SO'
                                    AND alert_45 = 'V'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'SO'
                                    AND alert_49 = 'V'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               SO_v,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'SO'
                                    AND alert_1 = 'R'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'SO'
                                    AND alert_2 = 'R'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'SO'
                                    AND alert_3 = 'R'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'SO'
                                    AND alert_4 = 'R'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'SO'
                                    AND alert_5 = 'R'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'SO'
                                    AND alert_6 = 'R'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'SO'
                                    AND alert_7 = 'R'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'SO'
                                    AND alert_8 = 'R'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'SO'
                                    AND alert_9 = 'R'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'SO'
                                    AND alert_10 = 'R'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'SO'
                                    AND alert_11 = 'R'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'SO'
                                    AND alert_12 = 'R'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'SO'
                                    AND alert_13 = 'R'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'SO'
                                    AND alert_14 = 'R'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'SO'
                                    AND alert_15 = 'R'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'SO'
                                    AND alert_16 = 'R'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'SO'
                                    AND alert_17 = 'R'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'SO'
                                    AND alert_18 = 'R'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'SO'
                                    AND alert_19 = 'R'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'SO'
                                    AND alert_20 = 'R'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'SO'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'SO'
                                    AND alert_22 = 'R'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'SO'
                                    AND alert_23 = 'R'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'SO'
                                    AND alert_24 = 'R'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'SO'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'SO'
                                    AND alert_40 = 'R'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'SO'
                                    AND alert_41 = 'R'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'SO'
                                    AND alert_45 = 'R'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'SO'
                                    AND alert_49 = 'R'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               SO_r,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'SO'
                                    AND alert_1 = 'A'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'SO'
                                    AND alert_2 = 'A'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'SO'
                                    AND alert_3 = 'A'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'SO'
                                    AND alert_4 = 'A'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'SO'
                                    AND alert_5 = 'A'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'SO'
                                    AND alert_6 = 'A'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'SO'
                                    AND alert_7 = 'A'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'SO'
                                    AND alert_8 = 'A'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'SO'
                                    AND alert_9 = 'A'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'SO'
                                    AND alert_10 = 'A'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'SO'
                                    AND alert_11 = 'A'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'SO'
                                    AND alert_12 = 'A'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'SO'
                                    AND alert_13 = 'A'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'SO'
                                    AND alert_14 = 'A'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'SO'
                                    AND alert_15 = 'A'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'SO'
                                    AND alert_16 = 'A'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'SO'
                                    AND alert_17 = 'A'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'SO'
                                    AND alert_18 = 'A'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'SO'
                                    AND alert_19 = 'A'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'SO'
                                    AND alert_20 = 'A'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'SO'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'SO'
                                    AND alert_22 = 'A'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'SO'
                                    AND alert_23 = 'A'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'SO'
                                    AND alert_24 = 'A'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'SO'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'SO'
                                    AND alert_40 = 'A'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'SO'
                                    AND alert_41 = 'A'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'SO'
                                    AND alert_45 = 'A'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'SO'
                                    AND alert_49 = 'A'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               SO_a,
                            ------ VG 20140626 PM ----
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'PM'
                                    AND alert_1 = 'V'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'PM'
                                    AND alert_2 = 'V'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'PM'
                                    AND alert_3 = 'V'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'PM'
                                    AND alert_4 = 'V'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'PM'
                                    AND alert_5 = 'V'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'PM'
                                    AND alert_6 = 'V'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'PM'
                                    AND alert_7 = 'V'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'PM'
                                    AND alert_8 = 'V'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'PM'
                                    AND alert_9 = 'V'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'PM'
                                    AND alert_10 = 'V'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'PM'
                                    AND alert_11 = 'V'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'PM'
                                    AND alert_12 = 'V'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'PM'
                                    AND alert_13 = 'V'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'PM'
                                    AND alert_14 = 'V'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'PM'
                                    AND alert_15 = 'V'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'PM'
                                    AND alert_16 = 'V'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'PM'
                                    AND alert_17 = 'V'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'PM'
                                    AND alert_18 = 'V'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'PM'
                                    AND alert_19 = 'V'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'PM'
                                    AND alert_20 = 'V'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'PM'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'PM'
                                    AND alert_22 = 'V'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'PM'
                                    AND alert_23 = 'V'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'PM'
                                    AND alert_24 = 'V'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'PM'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'PM'
                                    AND alert_40 = 'V'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'PM'
                                    AND alert_41 = 'V'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'PM'
                                    AND alert_45 = 'V'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'PM'
                                    AND alert_49 = 'V'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               PM_v,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'PM'
                                    AND alert_1 = 'R'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'PM'
                                    AND alert_2 = 'R'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'PM'
                                    AND alert_3 = 'R'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'PM'
                                    AND alert_4 = 'R'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'PM'
                                    AND alert_5 = 'R'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'PM'
                                    AND alert_6 = 'R'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'PM'
                                    AND alert_7 = 'R'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'PM'
                                    AND alert_8 = 'R'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'PM'
                                    AND alert_9 = 'R'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'PM'
                                    AND alert_10 = 'R'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'PM'
                                    AND alert_11 = 'R'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'PM'
                                    AND alert_12 = 'R'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'PM'
                                    AND alert_13 = 'R'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'PM'
                                    AND alert_14 = 'R'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'PM'
                                    AND alert_15 = 'R'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'PM'
                                    AND alert_16 = 'R'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'PM'
                                    AND alert_17 = 'R'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'PM'
                                    AND alert_18 = 'R'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'PM'
                                    AND alert_19 = 'R'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'PM'
                                    AND alert_20 = 'R'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'PM'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'PM'
                                    AND alert_22 = 'R'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'PM'
                                    AND alert_23 = 'R'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'PM'
                                    AND alert_24 = 'R'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'PM'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'PM'
                                    AND alert_40 = 'R'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'PM'
                                    AND alert_41 = 'R'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'PM'
                                    AND alert_45 = 'R'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'PM'
                                    AND alert_49 = 'R'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               PM_r,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'PM'
                                    AND alert_1 = 'A'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'PM'
                                    AND alert_2 = 'A'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'PM'
                                    AND alert_3 = 'A'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'PM'
                                    AND alert_4 = 'A'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'PM'
                                    AND alert_5 = 'A'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'PM'
                                    AND alert_6 = 'A'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'PM'
                                    AND alert_7 = 'A'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'PM'
                                    AND alert_8 = 'A'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'PM'
                                    AND alert_9 = 'A'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'PM'
                                    AND alert_10 = 'A'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'PM'
                                    AND alert_11 = 'A'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'PM'
                                    AND alert_12 = 'A'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'PM'
                                    AND alert_13 = 'A'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'PM'
                                    AND alert_14 = 'A'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'PM'
                                    AND alert_15 = 'A'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'PM'
                                    AND alert_16 = 'A'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'PM'
                                    AND alert_17 = 'A'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'PM'
                                    AND alert_18 = 'A'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'PM'
                                    AND alert_19 = 'A'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'PM'
                                    AND alert_20 = 'A'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'PM'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'PM'
                                    AND alert_22 = 'A'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'PM'
                                    AND alert_23 = 'A'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'PM'
                                    AND alert_24 = 'A'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'PM'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'PM'
                                    AND alert_40 = 'A'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'PM'
                                    AND alert_41 = 'A'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'PM'
                                    AND alert_45 = 'A'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'PM'
                                    AND alert_49 = 'A'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               PM_a,
                            ------ VG 20140626 RM ----
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'RM'
                                    AND alert_1 = 'V'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'RM'
                                    AND alert_2 = 'V'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'RM'
                                    AND alert_3 = 'V'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'RM'
                                    AND alert_4 = 'V'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'RM'
                                    AND alert_5 = 'V'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'RM'
                                    AND alert_6 = 'V'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'RM'
                                    AND alert_7 = 'V'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'RM'
                                    AND alert_8 = 'V'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'RM'
                                    AND alert_9 = 'V'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'RM'
                                    AND alert_10 = 'V'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'RM'
                                    AND alert_11 = 'V'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'RM'
                                    AND alert_12 = 'V'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'RM'
                                    AND alert_13 = 'V'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'RM'
                                    AND alert_14 = 'V'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'RM'
                                    AND alert_15 = 'V'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'RM'
                                    AND alert_16 = 'V'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'RM'
                                    AND alert_17 = 'V'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'RM'
                                    AND alert_18 = 'V'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'RM'
                                    AND alert_19 = 'V'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'RM'
                                    AND alert_20 = 'V'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RM'
                                    AND alert_21 = 'V'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'RM'
                                    AND alert_22 = 'V'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'RM'
                                    AND alert_23 = 'V'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'RM'
                                    AND alert_24 = 'V'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RM'
                                    AND alert_25 = 'V'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'RM'
                                    AND alert_40 = 'V'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'RM'
                                    AND alert_41 = 'V'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'RM'
                                    AND alert_45 = 'V'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'RM'
                                    AND alert_49 = 'V'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               RM_v,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'RM'
                                    AND alert_1 = 'R'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'RM'
                                    AND alert_2 = 'R'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'RM'
                                    AND alert_3 = 'R'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'RM'
                                    AND alert_4 = 'R'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'RM'
                                    AND alert_5 = 'R'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'RM'
                                    AND alert_6 = 'R'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'RM'
                                    AND alert_7 = 'R'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'RM'
                                    AND alert_8 = 'R'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'RM'
                                    AND alert_9 = 'R'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'RM'
                                    AND alert_10 = 'R'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'RM'
                                    AND alert_11 = 'R'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'RM'
                                    AND alert_12 = 'R'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'RM'
                                    AND alert_13 = 'R'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'RM'
                                    AND alert_14 = 'R'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'RM'
                                    AND alert_15 = 'R'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'RM'
                                    AND alert_16 = 'R'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'RM'
                                    AND alert_17 = 'R'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'RM'
                                    AND alert_18 = 'R'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'RM'
                                    AND alert_19 = 'R'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'RM'
                                    AND alert_20 = 'R'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RM'
                                    AND alert_21 = 'R'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'RM'
                                    AND alert_22 = 'R'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'RM'
                                    AND alert_23 = 'R'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'RM'
                                    AND alert_24 = 'R'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RM'
                                    AND alert_25 = 'R'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'RM'
                                    AND alert_40 = 'R'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'RM'
                                    AND alert_41 = 'R'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'RM'
                                    AND alert_45 = 'R'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'RM'
                                    AND alert_49 = 'R'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               RM_r,
                            CASE
                               WHEN     a.id_alert = 1
                                    AND cod_stato = 'RM'
                                    AND alert_1 = 'A'
                               THEN
                                  cnt_1
                               WHEN     a.id_alert = 2
                                    AND cod_stato = 'RM'
                                    AND alert_2 = 'A'
                               THEN
                                  cnt_2
                               WHEN     a.id_alert = 3
                                    AND cod_stato = 'RM'
                                    AND alert_3 = 'A'
                               THEN
                                  cnt_3
                               WHEN     a.id_alert = 4
                                    AND cod_stato = 'RM'
                                    AND alert_4 = 'A'
                               THEN
                                  cnt_4
                               WHEN     a.id_alert = 5
                                    AND cod_stato = 'RM'
                                    AND alert_5 = 'A'
                               THEN
                                  cnt_5
                               WHEN     a.id_alert = 6
                                    AND cod_stato = 'RM'
                                    AND alert_6 = 'A'
                               THEN
                                  cnt_6
                               WHEN     a.id_alert = 7
                                    AND cod_stato = 'RM'
                                    AND alert_7 = 'A'
                               THEN
                                  cnt_7
                               WHEN     a.id_alert = 8
                                    AND cod_stato = 'RM'
                                    AND alert_8 = 'A'
                               THEN
                                  cnt_8
                               WHEN     a.id_alert = 9
                                    AND cod_stato = 'RM'
                                    AND alert_9 = 'A'
                               THEN
                                  cnt_9
                               WHEN     a.id_alert = 10
                                    AND cod_stato = 'RM'
                                    AND alert_10 = 'A'
                               THEN
                                  cnt_10
                               WHEN     a.id_alert = 11
                                    AND cod_stato = 'RM'
                                    AND alert_11 = 'A'
                               THEN
                                  cnt_11
                               WHEN     a.id_alert = 12
                                    AND cod_stato = 'RM'
                                    AND alert_12 = 'A'
                               THEN
                                  cnt_12
                               WHEN     a.id_alert = 13
                                    AND cod_stato = 'RM'
                                    AND alert_13 = 'A'
                               THEN
                                  cnt_13
                               WHEN     a.id_alert = 14
                                    AND cod_stato = 'RM'
                                    AND alert_14 = 'A'
                               THEN
                                  cnt_14
                               WHEN     a.id_alert = 15
                                    AND cod_stato = 'RM'
                                    AND alert_15 = 'A'
                               THEN
                                  cnt_15
                               WHEN     a.id_alert = 16
                                    AND cod_stato_precedente = 'RM'
                                    AND alert_16 = 'A'
                               THEN
                                  cnt_16
                               WHEN     a.id_alert = 17
                                    AND cod_stato = 'RM'
                                    AND alert_17 = 'A'
                               THEN
                                  cnt_17
                               WHEN     a.id_alert = 18
                                    AND cod_stato = 'RM'
                                    AND alert_18 = 'A'
                               THEN
                                  cnt_18
                               WHEN     a.id_alert = 19
                                    AND cod_stato = 'RM'
                                    AND alert_19 = 'A'
                               THEN
                                  cnt_19
                               WHEN     a.id_alert = 20
                                    AND cod_stato = 'RM'
                                    AND alert_20 = 'A'
                               THEN
                                  cnt_20
                               WHEN     a.id_alert = 21
                                    AND cod_stato = 'RM'
                                    AND alert_21 = 'A'
                               THEN
                                  cnt_21
                               WHEN     a.id_alert = 22
                                    AND cod_stato = 'RM'
                                    AND alert_22 = 'A'
                               THEN
                                  cnt_22
                               WHEN     a.id_alert = 23
                                    AND cod_stato = 'RM'
                                    AND alert_23 = 'A'
                               THEN
                                  cnt_23
                               WHEN     a.id_alert = 24
                                    AND cod_stato = 'RM'
                                    AND alert_24 = 'A'
                               THEN
                                  cnt_24
                               WHEN     a.id_alert = 25
                                    AND cod_stato = 'RM'
                                    AND alert_25 = 'A'
                               THEN
                                  cnt_25
                               WHEN     a.id_alert = 40
                                    AND cod_stato = 'RM'
                                    AND alert_40 = 'A'
                               THEN
                                  cnt_40
                               WHEN     a.id_alert = 41
                                    AND cod_stato = 'RM'
                                    AND alert_41 = 'A'
                               THEN
                                  cnt_41
                               WHEN     a.id_alert = 45
                                    AND cod_stato = 'RM'
                                    AND alert_45 = 'A'
                               THEN
                                  cnt_45
                               WHEN     a.id_alert = 49
                                    AND cod_stato = 'RM'
                                    AND alert_49 = 'A'
                               THEN
                                  cnt_49
                               ELSE
                                  0
                            END
                               RM_a
                       FROM (SELECT /*+ ordered no_parallel(p) */
                                   DISTINCT
                                    x.id_utente,
                                    x.id_referente,
                                    cod_comparto cod_comparto_posizione,
                                    cod_ramo_calcolato,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
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
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_15,
                                                       x.cod_macrostato))
                                       cnt_15,
                                    alert_16,
                                    DECODE (
                                       alert_16,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_16,
                                                       x.cod_macrostato))
                                       cnt_16,
                                    alert_17,
                                    DECODE (
                                       alert_17,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_17,
                                                       x.cod_macrostato))
                                       cnt_17,
                                    alert_18,
                                    DECODE (
                                       alert_18,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_18,
                                                       x.cod_macrostato))
                                       cnt_18,
                                    alert_19,
                                    DECODE (
                                       alert_19,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_19,
                                                       x.cod_macrostato))
                                       cnt_19,
                                    alert_20,
                                    DECODE (
                                       alert_20,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_20,
                                                       x.cod_macrostato))
                                       cnt_20,
                                    alert_21,
                                    DECODE (
                                       alert_21,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_21,
                                                       x.cod_macrostato))
                                       cnt_21,
                                    alert_22,
                                    DECODE (
                                       alert_22,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_22,
                                                       x.cod_macrostato))
                                       cnt_22,
                                    alert_23,
                                    DECODE (
                                       alert_23,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_23,
                                                       x.cod_macrostato))
                                       cnt_23,
                                    alert_24,
                                    DECODE (
                                       alert_24,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_24,
                                                       x.cod_macrostato))
                                       cnt_24,
                                    alert_25,
                                    DECODE (
                                       alert_25,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_25,
                                                       x.cod_macrostato))
                                       cnt_25,
                                    alert_40,
                                    DECODE (
                                       alert_40,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_40,
                                                       x.cod_macrostato))
                                       cnt_40,
                                    alert_41,
                                    DECODE (
                                       alert_41,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_41,
                                                       x.cod_macrostato))
                                       cnt_41,
                                    alert_45,
                                    DECODE (
                                       alert_45,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_45,
                                                       x.cod_macrostato))
                                       cnt_45,
                                    alert_49,
                                    DECODE (
                                       alert_49,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY x.id_utente,
                                                       x.id_referente,
                                                       cod_comparto,
                                                       cod_ramo_calcolato,
                                                       alert_49,
                                                       x.cod_macrostato))
                                       cnt_49
                               FROM t_mcre0_app_alert_pos p,
                                    v_mcre0_app_upd_fields x
                              WHERE     x.cod_abi_cartolarizzato =
                                           p.cod_abi_cartolarizzato
                                    AND x.cod_ndg = p.cod_ndg
                                    AND x.flg_outsourcing = 'Y'
                                    AND x.flg_target = 'Y') b,
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
    WHERE al.id_alert = r.id_alert
   UNION
     SELECT id_utente,
            id_referente,
            cod_comparto AS cod_comparto_posizione,
            cod_ramo_calcolato,
            al.id_alert_da_esporre AS id_alert,
            al.desc_alert,
            val_ordine_a,
            val_ordine_e,
            NVL (SUM (cnt_gb_v), 0) AS gb_v,
            NVL (SUM (cnt_gb_g), 0) AS gb_a,
            NVL (SUM (cnt_gb_r), 0) AS gb_r,
            NVL (SUM (cnt_pt_v), 0) AS pt_v,
            NVL (SUM (cnt_pt_g), 0) AS pt_a,
            NVL (SUM (cnt_pt_r), 0) AS pt_r,
            NVL (SUM (cnt_rio_v), 0) AS rio_v,
            NVL (SUM (cnt_rio_g), 0) AS rio_a,
            NVL (SUM (cnt_rio_r), 0) AS rio_r,
            NVL (SUM (cnt_rs_v), 0) AS rs_v,
            NVL (SUM (cnt_rs_g), 0) AS rs_a,
            NVL (SUM (cnt_rs_r), 0) AS rs_r,
            NVL (SUM (cnt_in_v), 0) AS in_v,
            NVL (SUM (cnt_in_g), 0) AS in_a,
            NVL (SUM (cnt_in_r), 0) AS in_r,
            NVL (SUM (cnt_sc_v), 0) AS sc_v,
            NVL (SUM (cnt_sc_g), 0) AS sc_a,
            NVL (SUM (cnt_sc_r), 0) AS sc_r,
            NVL (SUM (cnt_so_v), 0) AS so_v,
            NVL (SUM (cnt_so_g), 0) AS so_a,
            NVL (SUM (cnt_so_r), 0) AS so_r,
            NVL (SUM (cnt_pm_v), 0) AS pm_v,
            NVL (SUM (cnt_pm_g), 0) AS pm_a,
            NVL (SUM (cnt_pm_r), 0) AS pm_r,
            NVL (SUM (cnt_rm_v), 0) AS rm_v,
            NVL (SUM (cnt_rm_g), 0) AS rm_a,
            NVL (SUM (cnt_rm_r), 0) AS rm_r,
            r.id_gruppo AS id_gruppo,
            r.cod_privilegio AS cod_privilegio,
            r.cod_gruppo_comparti AS cod_gruppo_comparti
       FROM (  SELECT id_alert_da_esporre,
                      id_alert,
                      x.cod_macrostato,
                      x.id_utente,
                      x.id_referente,
                      x.cod_comparto,
                      x.cod_ramo_calcolato,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'GB' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_gb_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'GB' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_gb_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'GB' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_gb_v,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'PT' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_pt_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'PT' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_pt_v,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'PT' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_pt_r,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'RIO' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_rio_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'RIO' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_rio_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'RIO' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_rio_v,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'RS' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_rs_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'RS' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_rs_g,
                      -- VERDE,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'RS' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_rs_v,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'IN' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_in_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'IN' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_in_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'IN' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_in_v,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'SC' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_sc_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'SC' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_sc_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'SC' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_sc_v,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'SO' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_SO_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'SO' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_SO_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'SO' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         CNT_SO_V,
                      --- 20140626 VG PM
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'PM' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_pm_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'PM' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_pm_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'PM' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         CNT_pm_V,
                      --- 20140626 VG RM
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'RM' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_Rm_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'RM' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_Rm_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'RM' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         CNT_Rm_V
                 FROM V_MCREI_ALERT_FLG_PR_VIS p, --T_MCREI_APP_ALERT_POS_WRK P,
                                                 v_mcre0_app_upd_fields x
                WHERE     x.cod_abi_cartolarizzato = p.cod_abi
                      AND x.cod_ndg = p.cod_ndg
                      AND x.flg_outsourcing = 'Y'
                      AND x.flg_target = 'Y'
             GROUP BY id_alert_da_esporre,
                      id_alert,
                      x.cod_macrostato,
                      x.id_utente,
                      x.id_referente,
                      x.cod_comparto,
                      x.cod_ramo_calcolato) cnt,
            t_mcrei_app_alert al,
            t_mcrei_app_alert_ruoli r
      WHERE     al.id_alert = cnt.id_alert(+)
            AND al.id_alert = r.id_alert
            AND al.flg_attivo = 'A'
   GROUP BY id_utente,
            id_referente,
            cod_comparto,
            cod_ramo_calcolato,
            al.id_alert_da_esporre,
            al.desc_alert,
            val_ordine_a,
            val_ordine_e,
            r.id_gruppo,
            r.cod_privilegio,
            r.cod_gruppo_comparti
   UNION
     SELECT id_utente,
            id_referente,
            cod_comparto AS cod_comparto_posizione,
            cod_ramo_calcolato,
            al.id_alert_da_esporre AS id_alert,
            al.desc_alert,
            val_ordine_a,
            val_ordine_e,
            NVL (MAX (cnt_gb_v), 0) AS gb_v,
            NVL (MAX (cnt_gb_g), 0) AS gb_a,
            NVL (MAX (cnt_gb_r), 0) AS gb_r,
            NVL (MAX (cnt_pt_v), 0) AS pt_v,
            --    'A' GIALLO,
            NVL (MAX (cnt_pt_g), 0) AS pt_a,
            --    'V' VERDE,
            NVL (MAX (cnt_pt_r), 0) AS pt_r,
            --
            NVL (MAX (cnt_rio_v), 0) AS rio_v,
            --    'A' GIALLO,
            NVL (MAX (cnt_rio_g), 0) AS rio_a,
            --    'V' VERDE,
            NVL (MAX (cnt_rio_r), 0) AS rio_r,
            NVL (MAX (cnt_rs_v), 0) AS rs_v,
            --    'A' GIALLO,
            NVL (MAX (cnt_rs_g), 0) AS rs_a,
            --    'V' VERDE,
            NVL (MAX (cnt_rs_r), 0) AS rs_r,
            NVL (MAX (cnt_in_v), 0) AS in_v,
            --    'A' GIALLO,
            NVL (MAX (cnt_in_g), 0) AS in_a,
            --    'V' VERDE,
            NVL (MAX (cnt_in_r), 0) AS in_r,
            NVL (MAX (cnt_sc_v), 0) AS sc_v,
            --    'A' GIALLO,
            NVL (MAX (cnt_sc_g), 0) AS sc_a,
            --    'V' VERDE,
            NVL (MAX (cnt_sc_r), 0) AS sc_r,
            NVL (MAX (cnt_so_v), 0) AS so_v,
            --    'A' GIALLO,
            NVL (MAX (cnt_so_g), 0) AS so_a,
            --    'V' VERDE,
            NVL (MAX (cnt_so_r), 0) AS so_r,
            NVL (MAX (cnt_pm_v), 0) AS pm_v,
            NVL (MAX (cnt_pm_g), 0) AS pm_a,
            NVL (MAX (cnt_pm_r), 0) AS pm_r,
            NVL (MAX (cnt_Rm_v), 0) AS Rm_v,
            NVL (MAX (cnt_Rm_g), 0) AS Rm_a,
            NVL (MAX (cnt_Rm_r), 0) AS Rm_r,
            r.id_gruppo AS id_gruppo,
            r.cod_privilegio AS cod_privilegio,
            r.cod_gruppo_comparti AS cod_gruppo_comparti
       FROM (  SELECT id_alert_da_esporre,
                      id_alert,
                      x.cod_macrostato,
                      x.id_utente,
                      x.id_referente,
                      x.cod_comparto,
                      x.cod_ramo_calcolato,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'GB' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_gb_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'GB' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_gb_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'GB' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_gb_v,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'PT' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_pt_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'PT' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_pt_v,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'PT' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_pt_r,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'RIO' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_rio_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'RIO' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_rio_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'RIO' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_rio_v,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'RS' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_rs_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'RS' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_rs_g,
                      -- VERDE,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'RS' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_rs_v,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'IN' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_in_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'IN' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_in_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'IN' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_in_v,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'SC' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_sc_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'SC' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_sc_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'SC' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_sc_v,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'SO' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_SO_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'SO' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_SO_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'SO' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_SO_v,
                      ------ 20140626 VG PM
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'PM' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_pm_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'PM' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_pm_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'PM' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_pm_v,
                      ------ 20140626 VG RM
                      SUM (
                         CASE
                            WHEN alert = 'R' AND x.cod_macrostato = 'RM' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_Rm_r,
                      SUM (
                         CASE
                            WHEN alert = 'A' AND x.cod_macrostato = 'RM' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_Rm_g,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND x.cod_macrostato = 'RM' THEN 1 --VAL_CNT_RAPPORTI
                            ELSE 0
                         END)
                         cnt_Rm_v
                 -- ROSSO,
                 FROM v_mcrei_app_alert_mig_visione p, v_mcre0_app_upd_fields x
                WHERE     x.cod_abi_cartolarizzato = p.cod_abi
                      AND x.cod_ndg = p.cod_ndg
                      AND x.flg_outsourcing = 'Y'
                      AND x.flg_target = 'Y'
             GROUP BY id_alert_da_esporre,
                      id_alert,
                      x.cod_macrostato,
                      x.id_utente,
                      x.id_referente,
                      x.cod_comparto,
                      x.cod_ramo_calcolato) cnt,
            t_mcrei_app_alert al,
            t_mcrei_app_alert_ruoli r
      WHERE     cnt.id_alert(+) = al.id_alert
            AND al.id_alert = r.id_alert
            AND al.flg_attivo(+) = 'A'
            AND al.id_alert_da_esporre = 33
   GROUP BY id_utente,
            id_referente,
            cod_comparto,
            cod_ramo_calcolato,
            al.id_alert_da_esporre,
            al.desc_alert,
            val_ordine_a,
            val_ordine_e,
            r.id_gruppo,
            R.Cod_Privilegio,
            r.cod_gruppo_comparti;
