/* Formatted on 21/07/2014 18:31:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_CNT_2
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
   COD_PRIVILEGIO,
   COD_GRUPPO_COMPARTI
)
AS
   SELECT AL."ID_UTENTE",
          AL."ID_REFERENTE",
          AL."COD_COMPARTO_POSIZIONE",
          AL."COD_RAMO_CALCOLATO",
          AL."ID_ALERT",
          AL."DESC_ALERT",
          AL."VAL_ORDINE_A",
          AL."VAL_ORDINE_E",
          AL."GB_V",
          AL."GB_A",
          AL."GB_R",
          AL."PT_V",
          AL."PT_A",
          AL."PT_R",
          AL."RIO_V",
          AL."RIO_A",
          AL."RIO_R",
          AL."RS_V",
          AL."RS_A",
          AL."RS_R",
          AL."IN_V",
          AL."IN_A",
          AL."IN_R",
          AL."SC_V",
          AL."SC_A",
          AL."SC_R",
          R.ID_GRUPPO,
          R.COD_PRIVILEGIO,
          R.COD_GRUPPO_COMPARTI
     FROM (  SELECT -- v1.0 06/04/2011 V.Galli Nuova versione per migliore performance + privilegi e ordinamento
                 -- v1.1 22/04/2011 V.Galli Macrostato precedente per alert 16
                                     -- v1.2 27/04/2011 V.Galli Alert 22 23 24
                                           -- v1.3 09/05/2011 V.Galli Alert 25
                    -- v1.4 30/05/2011 V.Galli Outer Join per stato_precedente
      -- v2 26/07/2012 V.Galli aggiunti alert 36 e 37   e  COD_GRUPPO_COMPARTI
                    ID_UTENTE,
                    ID_REFERENTE,
                    COD_COMPARTO_POSIZIONE,
                    COD_RAMO_CALCOLATO,
                    ID_ALERT,
                    DESC_ALERT,
                    VAL_ORDINE_A,
                    VAL_ORDINE_E,
                    SUM (GB_V) GB_V,
                    SUM (GB_A) GB_A,
                    SUM (GB_R) GB_R,
                    SUM (PT_V) PT_V,
                    SUM (PT_A) PT_A,
                    SUM (PT_R) PT_R,
                    SUM (RIO_V) RIO_V,
                    SUM (RIO_A) RIO_A,
                    SUM (RIO_R) RIO_R,
                    SUM (RS_V) RS_V,
                    SUM (RS_A) RS_A,
                    SUM (RS_R) RS_R,
                    SUM (IN_V) IN_V,
                    SUM (IN_A) IN_A,
                    SUM (IN_R) IN_R,
                    SUM (SC_V) SC_V,
                    SUM (SC_A) SC_A,
                    SUM (SC_R) SC_R
               FROM (SELECT DISTINCT
                            ID_UTENTE,
                            ID_REFERENTE,
                            COD_COMPARTO_POSIZIONE,
                            COD_RAMO_CALCOLATO,
                            A.ID_ALERT,
                            DESC_ALERT,
                            VAL_ORDINE_A,
                            VAL_ORDINE_E,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'GB'
                                    AND ALERT_1 = 'V'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'GB'
                                    AND ALERT_2 = 'V'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'GB'
                                    AND ALERT_3 = 'V'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'GB'
                                    AND ALERT_4 = 'V'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'GB'
                                    AND ALERT_5 = 'V'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'GB'
                                    AND ALERT_6 = 'V'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'GB'
                                    AND ALERT_7 = 'V'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'GB'
                                    AND ALERT_8 = 'V'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'GB'
                                    AND ALERT_9 = 'V'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'GB'
                                    AND ALERT_10 = 'V'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'GB'
                                    AND ALERT_11 = 'V'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'GB'
                                    AND ALERT_12 = 'V'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'GB'
                                    AND ALERT_13 = 'V'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'GB'
                                    AND ALERT_14 = 'V'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'GB'
                                    AND ALERT_15 = 'V'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'GB'
                                    AND ALERT_16 = 'V'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'GB'
                                    AND ALERT_17 = 'V'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'GB'
                                    AND ALERT_18 = 'V'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'GB'
                                    AND ALERT_19 = 'V'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'GB'
                                    AND ALERT_20 = 'V'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'GB'
                                    AND ALERT_21 = 'V'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'GB'
                                    AND ALERT_22 = 'V'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'GB'
                                    AND ALERT_23 = 'V'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'GB'
                                    AND ALERT_24 = 'V'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'GB'
                                    AND ALERT_25 = 'V'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'GB'
                                    AND ALERT_36 = 'V'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'GB'
                                    AND ALERT_37 = 'V'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               GB_V,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'GB'
                                    AND ALERT_1 = 'R'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'GB'
                                    AND ALERT_2 = 'R'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'GB'
                                    AND ALERT_3 = 'R'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'GB'
                                    AND ALERT_4 = 'R'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'GB'
                                    AND ALERT_5 = 'R'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'GB'
                                    AND ALERT_6 = 'R'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'GB'
                                    AND ALERT_7 = 'R'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'GB'
                                    AND ALERT_8 = 'R'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'GB'
                                    AND ALERT_9 = 'R'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'GB'
                                    AND ALERT_10 = 'R'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'GB'
                                    AND ALERT_11 = 'R'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'GB'
                                    AND ALERT_12 = 'R'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'GB'
                                    AND ALERT_13 = 'R'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'GB'
                                    AND ALERT_14 = 'R'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'GB'
                                    AND ALERT_15 = 'R'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'GB'
                                    AND ALERT_16 = 'R'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'GB'
                                    AND ALERT_17 = 'R'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'GB'
                                    AND ALERT_18 = 'R'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'GB'
                                    AND ALERT_19 = 'R'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'GB'
                                    AND ALERT_20 = 'R'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'GB'
                                    AND ALERT_21 = 'R'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'GB'
                                    AND ALERT_22 = 'R'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'GB'
                                    AND ALERT_23 = 'R'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'GB'
                                    AND ALERT_24 = 'R'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'GB'
                                    AND ALERT_25 = 'R'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'GB'
                                    AND ALERT_36 = 'R'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'GB'
                                    AND ALERT_37 = 'R'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               GB_R,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'GB'
                                    AND ALERT_1 = 'A'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'GB'
                                    AND ALERT_2 = 'A'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'GB'
                                    AND ALERT_3 = 'A'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'GB'
                                    AND ALERT_4 = 'A'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'GB'
                                    AND ALERT_5 = 'A'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'GB'
                                    AND ALERT_6 = 'A'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'GB'
                                    AND ALERT_7 = 'A'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'GB'
                                    AND ALERT_8 = 'A'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'GB'
                                    AND ALERT_9 = 'A'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'GB'
                                    AND ALERT_10 = 'A'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'GB'
                                    AND ALERT_11 = 'A'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'GB'
                                    AND ALERT_12 = 'A'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'GB'
                                    AND ALERT_13 = 'A'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'GB'
                                    AND ALERT_14 = 'A'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'GB'
                                    AND ALERT_15 = 'A'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'GB'
                                    AND ALERT_16 = 'A'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'GB'
                                    AND ALERT_17 = 'A'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'GB'
                                    AND ALERT_18 = 'A'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'GB'
                                    AND ALERT_19 = 'A'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'GB'
                                    AND ALERT_20 = 'A'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'GB'
                                    AND ALERT_21 = 'A'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'GB'
                                    AND ALERT_22 = 'A'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'GB'
                                    AND ALERT_23 = 'A'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'GB'
                                    AND ALERT_24 = 'A'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'GB'
                                    AND ALERT_25 = 'A'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'GB'
                                    AND ALERT_36 = 'A'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'GB'
                                    AND ALERT_37 = 'A'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               GB_A,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'PT'
                                    AND ALERT_1 = 'V'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'PT'
                                    AND ALERT_2 = 'V'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'PT'
                                    AND ALERT_3 = 'V'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'PT'
                                    AND ALERT_4 = 'V'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'PT'
                                    AND ALERT_5 = 'V'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'PT'
                                    AND ALERT_6 = 'V'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'PT'
                                    AND ALERT_7 = 'V'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'PT'
                                    AND ALERT_8 = 'V'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'PT'
                                    AND ALERT_9 = 'V'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'PT'
                                    AND ALERT_10 = 'V'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'PT'
                                    AND ALERT_11 = 'V'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'PT'
                                    AND ALERT_12 = 'V'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'PT'
                                    AND ALERT_13 = 'V'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'PT'
                                    AND ALERT_14 = 'V'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'PT'
                                    AND ALERT_15 = 'V'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'PT'
                                    AND ALERT_16 = 'V'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'PT'
                                    AND ALERT_17 = 'V'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'PT'
                                    AND ALERT_18 = 'V'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'PT'
                                    AND ALERT_19 = 'V'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'PT'
                                    AND ALERT_20 = 'V'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'PT'
                                    AND ALERT_21 = 'V'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'PT'
                                    AND ALERT_22 = 'V'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'PT'
                                    AND ALERT_23 = 'V'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'PT'
                                    AND ALERT_24 = 'V'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'PT'
                                    AND ALERT_25 = 'V'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'PT'
                                    AND ALERT_36 = 'V'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'PT'
                                    AND ALERT_37 = 'V'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               PT_V,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'PT'
                                    AND ALERT_1 = 'R'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'PT'
                                    AND ALERT_2 = 'R'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'PT'
                                    AND ALERT_3 = 'R'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'PT'
                                    AND ALERT_4 = 'R'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'PT'
                                    AND ALERT_5 = 'R'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'PT'
                                    AND ALERT_6 = 'R'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'PT'
                                    AND ALERT_7 = 'R'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'PT'
                                    AND ALERT_8 = 'R'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'PT'
                                    AND ALERT_9 = 'R'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'PT'
                                    AND ALERT_10 = 'R'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'PT'
                                    AND ALERT_11 = 'R'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'PT'
                                    AND ALERT_12 = 'R'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'PT'
                                    AND ALERT_13 = 'R'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'PT'
                                    AND ALERT_14 = 'R'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'PT'
                                    AND ALERT_15 = 'R'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'PT'
                                    AND ALERT_16 = 'R'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'PT'
                                    AND ALERT_17 = 'R'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'PT'
                                    AND ALERT_18 = 'R'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'PT'
                                    AND ALERT_19 = 'R'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'PT'
                                    AND ALERT_20 = 'R'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'PT'
                                    AND ALERT_21 = 'R'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'PT'
                                    AND ALERT_22 = 'R'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'PT'
                                    AND ALERT_23 = 'R'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'PT'
                                    AND ALERT_24 = 'R'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'PT'
                                    AND ALERT_25 = 'R'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'PT'
                                    AND ALERT_36 = 'R'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'PT'
                                    AND ALERT_37 = 'R'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               PT_R,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'PT'
                                    AND ALERT_1 = 'A'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'PT'
                                    AND ALERT_2 = 'A'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'PT'
                                    AND ALERT_3 = 'A'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'PT'
                                    AND ALERT_4 = 'A'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'PT'
                                    AND ALERT_5 = 'A'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'PT'
                                    AND ALERT_6 = 'A'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'PT'
                                    AND ALERT_7 = 'A'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'PT'
                                    AND ALERT_8 = 'A'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'PT'
                                    AND ALERT_9 = 'A'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'PT'
                                    AND ALERT_10 = 'A'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'PT'
                                    AND ALERT_11 = 'A'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'PT'
                                    AND ALERT_12 = 'A'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'PT'
                                    AND ALERT_13 = 'A'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'PT'
                                    AND ALERT_14 = 'A'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'PT'
                                    AND ALERT_15 = 'A'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'PT'
                                    AND ALERT_16 = 'A'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'PT'
                                    AND ALERT_17 = 'A'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'PT'
                                    AND ALERT_18 = 'A'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'PT'
                                    AND ALERT_19 = 'A'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'PT'
                                    AND ALERT_20 = 'A'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'PT'
                                    AND ALERT_21 = 'A'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'PT'
                                    AND ALERT_22 = 'A'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'PT'
                                    AND ALERT_23 = 'A'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'PT'
                                    AND ALERT_24 = 'A'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'PT'
                                    AND ALERT_25 = 'A'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'PT'
                                    AND ALERT_36 = 'A'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'PT'
                                    AND ALERT_37 = 'A'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               PT_A,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_1 = 'V'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_2 = 'V'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_3 = 'V'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_4 = 'V'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_5 = 'V'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_6 = 'V'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_7 = 'V'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_8 = 'V'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_9 = 'V'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_10 = 'V'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_11 = 'V'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_12 = 'V'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_13 = 'V'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_14 = 'V'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_15 = 'V'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'RIO'
                                    AND ALERT_16 = 'V'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_17 = 'V'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_18 = 'V'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_19 = 'V'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_20 = 'V'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_21 = 'V'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_22 = 'V'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_23 = 'V'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_24 = 'V'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_25 = 'V'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_36 = 'V'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_37 = 'V'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               RIO_V,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_1 = 'R'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_2 = 'R'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_3 = 'R'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_4 = 'R'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_5 = 'R'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_6 = 'R'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_7 = 'R'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_8 = 'R'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_9 = 'R'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_10 = 'R'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_11 = 'R'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_12 = 'R'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_13 = 'R'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_14 = 'R'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_15 = 'R'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'RIO'
                                    AND ALERT_16 = 'R'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_17 = 'R'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_18 = 'R'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_19 = 'R'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_20 = 'R'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_21 = 'R'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_22 = 'R'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_23 = 'R'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_24 = 'R'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_25 = 'R'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_36 = 'R'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_37 = 'R'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               RIO_R,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_1 = 'A'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_2 = 'A'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_3 = 'A'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_4 = 'A'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_5 = 'A'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_6 = 'A'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_7 = 'A'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_8 = 'A'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_9 = 'A'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_10 = 'A'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_11 = 'A'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_12 = 'A'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_13 = 'A'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_14 = 'A'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_15 = 'A'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'RIO'
                                    AND ALERT_16 = 'A'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_17 = 'A'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_18 = 'A'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_19 = 'A'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_20 = 'A'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_21 = 'A'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_22 = 'A'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_23 = 'A'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_24 = 'A'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_25 = 'A'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_36 = 'A'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'RIO'
                                    AND ALERT_37 = 'A'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               RIO_A,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'SC'
                                    AND ALERT_1 = 'V'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'SC'
                                    AND ALERT_2 = 'V'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'SC'
                                    AND ALERT_3 = 'V'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'SC'
                                    AND ALERT_4 = 'V'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'SC'
                                    AND ALERT_5 = 'V'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'SC'
                                    AND ALERT_6 = 'V'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'SC'
                                    AND ALERT_7 = 'V'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'SC'
                                    AND ALERT_8 = 'V'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'SC'
                                    AND ALERT_9 = 'V'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'SC'
                                    AND ALERT_10 = 'V'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'SC'
                                    AND ALERT_11 = 'V'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'SC'
                                    AND ALERT_12 = 'V'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'SC'
                                    AND ALERT_13 = 'V'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'SC'
                                    AND ALERT_14 = 'V'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'SC'
                                    AND ALERT_15 = 'V'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'SC'
                                    AND ALERT_16 = 'V'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'SC'
                                    AND ALERT_17 = 'V'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'SC'
                                    AND ALERT_18 = 'V'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'SC'
                                    AND ALERT_19 = 'V'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'SC'
                                    AND ALERT_20 = 'V'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'SC'
                                    AND ALERT_21 = 'V'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'SC'
                                    AND ALERT_22 = 'V'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'SC'
                                    AND ALERT_23 = 'V'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'SC'
                                    AND ALERT_24 = 'V'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'SC'
                                    AND ALERT_25 = 'V'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'SC'
                                    AND ALERT_36 = 'V'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'SC'
                                    AND ALERT_37 = 'V'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               SC_V,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'SC'
                                    AND ALERT_1 = 'R'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'SC'
                                    AND ALERT_2 = 'R'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'SC'
                                    AND ALERT_3 = 'R'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'SC'
                                    AND ALERT_4 = 'R'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'SC'
                                    AND ALERT_5 = 'R'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'SC'
                                    AND ALERT_6 = 'R'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'SC'
                                    AND ALERT_7 = 'R'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'SC'
                                    AND ALERT_8 = 'R'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'SC'
                                    AND ALERT_9 = 'R'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'SC'
                                    AND ALERT_10 = 'R'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'SC'
                                    AND ALERT_11 = 'R'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'SC'
                                    AND ALERT_12 = 'R'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'SC'
                                    AND ALERT_13 = 'R'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'SC'
                                    AND ALERT_14 = 'R'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'SC'
                                    AND ALERT_15 = 'R'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'SC'
                                    AND ALERT_16 = 'R'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'SC'
                                    AND ALERT_17 = 'R'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'SC'
                                    AND ALERT_18 = 'R'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'SC'
                                    AND ALERT_19 = 'R'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'SC'
                                    AND ALERT_20 = 'R'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'SC'
                                    AND ALERT_21 = 'R'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'SC'
                                    AND ALERT_22 = 'R'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'SC'
                                    AND ALERT_23 = 'R'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'SC'
                                    AND ALERT_24 = 'R'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'SC'
                                    AND ALERT_25 = 'R'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'SC'
                                    AND ALERT_36 = 'R'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'SC'
                                    AND ALERT_37 = 'R'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               SC_R,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'SC'
                                    AND ALERT_1 = 'A'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'SC'
                                    AND ALERT_2 = 'A'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'SC'
                                    AND ALERT_3 = 'A'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'SC'
                                    AND ALERT_4 = 'A'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'SC'
                                    AND ALERT_5 = 'A'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'SC'
                                    AND ALERT_6 = 'A'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'SC'
                                    AND ALERT_7 = 'A'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'SC'
                                    AND ALERT_8 = 'A'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'SC'
                                    AND ALERT_9 = 'A'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'SC'
                                    AND ALERT_10 = 'A'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'SC'
                                    AND ALERT_11 = 'A'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'SC'
                                    AND ALERT_12 = 'A'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'SC'
                                    AND ALERT_13 = 'A'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'SC'
                                    AND ALERT_14 = 'A'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'SC'
                                    AND ALERT_15 = 'A'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'SC'
                                    AND ALERT_16 = 'A'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'SC'
                                    AND ALERT_17 = 'A'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'SC'
                                    AND ALERT_18 = 'A'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'SC'
                                    AND ALERT_19 = 'A'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'SC'
                                    AND ALERT_20 = 'A'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'SC'
                                    AND ALERT_21 = 'A'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'SC'
                                    AND ALERT_22 = 'A'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'SC'
                                    AND ALERT_23 = 'A'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'SC'
                                    AND ALERT_24 = 'A'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'SC'
                                    AND ALERT_25 = 'A'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'SC'
                                    AND ALERT_36 = 'A'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'SC'
                                    AND ALERT_37 = 'A'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               SC_A,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'IN'
                                    AND ALERT_1 = 'V'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'IN'
                                    AND ALERT_2 = 'V'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'IN'
                                    AND ALERT_3 = 'V'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'IN'
                                    AND ALERT_4 = 'V'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'IN'
                                    AND ALERT_5 = 'V'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'IN'
                                    AND ALERT_6 = 'V'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'IN'
                                    AND ALERT_7 = 'V'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'IN'
                                    AND ALERT_8 = 'V'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'IN'
                                    AND ALERT_9 = 'V'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'IN'
                                    AND ALERT_10 = 'V'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'IN'
                                    AND ALERT_11 = 'V'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'IN'
                                    AND ALERT_12 = 'V'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'IN'
                                    AND ALERT_13 = 'V'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'IN'
                                    AND ALERT_14 = 'V'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'IN'
                                    AND ALERT_15 = 'V'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'IN'
                                    AND ALERT_16 = 'V'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'IN'
                                    AND ALERT_17 = 'V'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'IN'
                                    AND ALERT_18 = 'V'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'IN'
                                    AND ALERT_19 = 'V'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'IN'
                                    AND ALERT_20 = 'V'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'IN'
                                    AND ALERT_21 = 'V'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'IN'
                                    AND ALERT_22 = 'V'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'IN'
                                    AND ALERT_23 = 'V'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'IN'
                                    AND ALERT_24 = 'V'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'IN'
                                    AND ALERT_25 = 'V'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'IN'
                                    AND ALERT_36 = 'V'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'IN'
                                    AND ALERT_37 = 'V'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               IN_V,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'IN'
                                    AND ALERT_1 = 'R'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'IN'
                                    AND ALERT_2 = 'R'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'IN'
                                    AND ALERT_3 = 'R'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'IN'
                                    AND ALERT_4 = 'R'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'IN'
                                    AND ALERT_5 = 'R'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'IN'
                                    AND ALERT_6 = 'R'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'IN'
                                    AND ALERT_7 = 'R'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'IN'
                                    AND ALERT_8 = 'R'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'IN'
                                    AND ALERT_9 = 'R'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'IN'
                                    AND ALERT_10 = 'R'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'IN'
                                    AND ALERT_11 = 'R'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'IN'
                                    AND ALERT_12 = 'R'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'IN'
                                    AND ALERT_13 = 'R'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'IN'
                                    AND ALERT_14 = 'R'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'IN'
                                    AND ALERT_15 = 'R'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'IN'
                                    AND ALERT_16 = 'R'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'IN'
                                    AND ALERT_17 = 'R'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'IN'
                                    AND ALERT_18 = 'R'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'IN'
                                    AND ALERT_19 = 'R'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'IN'
                                    AND ALERT_20 = 'R'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'IN'
                                    AND ALERT_21 = 'R'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'IN'
                                    AND ALERT_22 = 'R'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'IN'
                                    AND ALERT_23 = 'R'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'IN'
                                    AND ALERT_24 = 'R'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'IN'
                                    AND ALERT_25 = 'R'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'IN'
                                    AND ALERT_36 = 'R'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'IN'
                                    AND ALERT_37 = 'R'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               IN_R,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'IN'
                                    AND ALERT_1 = 'A'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'IN'
                                    AND ALERT_2 = 'A'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'IN'
                                    AND ALERT_3 = 'A'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'IN'
                                    AND ALERT_4 = 'A'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'IN'
                                    AND ALERT_5 = 'A'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'IN'
                                    AND ALERT_6 = 'A'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'IN'
                                    AND ALERT_7 = 'A'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'IN'
                                    AND ALERT_8 = 'A'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'IN'
                                    AND ALERT_9 = 'A'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'IN'
                                    AND ALERT_10 = 'A'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'IN'
                                    AND ALERT_11 = 'A'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'IN'
                                    AND ALERT_12 = 'A'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'IN'
                                    AND ALERT_13 = 'A'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'IN'
                                    AND ALERT_14 = 'A'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'IN'
                                    AND ALERT_15 = 'A'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'IN'
                                    AND ALERT_16 = 'A'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'IN'
                                    AND ALERT_17 = 'A'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'IN'
                                    AND ALERT_18 = 'A'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'IN'
                                    AND ALERT_19 = 'A'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'IN'
                                    AND ALERT_20 = 'A'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'IN'
                                    AND ALERT_21 = 'A'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'IN'
                                    AND ALERT_22 = 'A'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'IN'
                                    AND ALERT_23 = 'A'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'IN'
                                    AND ALERT_24 = 'A'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'IN'
                                    AND ALERT_25 = 'A'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'IN'
                                    AND ALERT_36 = 'A'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'IN'
                                    AND ALERT_37 = 'A'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               IN_A,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'RS'
                                    AND ALERT_1 = 'V'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'RS'
                                    AND ALERT_2 = 'V'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'RS'
                                    AND ALERT_3 = 'V'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'RS'
                                    AND ALERT_4 = 'V'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'RS'
                                    AND ALERT_5 = 'V'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'RS'
                                    AND ALERT_6 = 'V'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'RS'
                                    AND ALERT_7 = 'V'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'RS'
                                    AND ALERT_8 = 'V'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'RS'
                                    AND ALERT_9 = 'V'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'RS'
                                    AND ALERT_10 = 'V'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'RS'
                                    AND ALERT_11 = 'V'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'RS'
                                    AND ALERT_12 = 'V'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'RS'
                                    AND ALERT_13 = 'V'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'RS'
                                    AND ALERT_14 = 'V'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'RS'
                                    AND ALERT_15 = 'V'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'RS'
                                    AND ALERT_16 = 'V'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'RS'
                                    AND ALERT_17 = 'V'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'RS'
                                    AND ALERT_18 = 'V'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'RS'
                                    AND ALERT_19 = 'V'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'RS'
                                    AND ALERT_20 = 'V'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'RS'
                                    AND ALERT_21 = 'V'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'RS'
                                    AND ALERT_22 = 'V'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'RS'
                                    AND ALERT_23 = 'V'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'RS'
                                    AND ALERT_24 = 'V'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'RS'
                                    AND ALERT_25 = 'V'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'RS'
                                    AND ALERT_36 = 'V'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'RS'
                                    AND ALERT_37 = 'V'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               RS_V,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'RS'
                                    AND ALERT_1 = 'R'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'RS'
                                    AND ALERT_2 = 'R'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'RS'
                                    AND ALERT_3 = 'R'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'RS'
                                    AND ALERT_4 = 'R'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'RS'
                                    AND ALERT_5 = 'R'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'RS'
                                    AND ALERT_6 = 'R'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'RS'
                                    AND ALERT_7 = 'R'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'RS'
                                    AND ALERT_8 = 'R'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'RS'
                                    AND ALERT_9 = 'R'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'RS'
                                    AND ALERT_10 = 'R'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'RS'
                                    AND ALERT_11 = 'R'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'RS'
                                    AND ALERT_12 = 'R'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'RS'
                                    AND ALERT_13 = 'R'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'RS'
                                    AND ALERT_14 = 'R'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'RS'
                                    AND ALERT_15 = 'R'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'RS'
                                    AND ALERT_16 = 'R'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'RS'
                                    AND ALERT_17 = 'R'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'RS'
                                    AND ALERT_18 = 'R'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'RS'
                                    AND ALERT_19 = 'R'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'RS'
                                    AND ALERT_20 = 'R'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'RS'
                                    AND ALERT_21 = 'R'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'RS'
                                    AND ALERT_22 = 'R'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'RS'
                                    AND ALERT_23 = 'R'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'RS'
                                    AND ALERT_24 = 'R'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'RS'
                                    AND ALERT_25 = 'R'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'RS'
                                    AND ALERT_36 = 'R'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'RS'
                                    AND ALERT_37 = 'R'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               RS_R,
                            CASE
                               WHEN     A.ID_ALERT = 1
                                    AND COD_STATO = 'RS'
                                    AND ALERT_1 = 'A'
                               THEN
                                  CNT_1
                               WHEN     A.ID_ALERT = 2
                                    AND COD_STATO = 'RS'
                                    AND ALERT_2 = 'A'
                               THEN
                                  CNT_2
                               WHEN     A.ID_ALERT = 3
                                    AND COD_STATO = 'RS'
                                    AND ALERT_3 = 'A'
                               THEN
                                  CNT_3
                               WHEN     A.ID_ALERT = 4
                                    AND COD_STATO = 'RS'
                                    AND ALERT_4 = 'A'
                               THEN
                                  CNT_4
                               WHEN     A.ID_ALERT = 5
                                    AND COD_STATO = 'RS'
                                    AND ALERT_5 = 'A'
                               THEN
                                  CNT_5
                               WHEN     A.ID_ALERT = 6
                                    AND COD_STATO = 'RS'
                                    AND ALERT_6 = 'A'
                               THEN
                                  CNT_6
                               WHEN     A.ID_ALERT = 7
                                    AND COD_STATO = 'RS'
                                    AND ALERT_7 = 'A'
                               THEN
                                  CNT_7
                               WHEN     A.ID_ALERT = 8
                                    AND COD_STATO = 'RS'
                                    AND ALERT_8 = 'A'
                               THEN
                                  CNT_8
                               WHEN     A.ID_ALERT = 9
                                    AND COD_STATO = 'RS'
                                    AND ALERT_9 = 'A'
                               THEN
                                  CNT_9
                               WHEN     A.ID_ALERT = 10
                                    AND COD_STATO = 'RS'
                                    AND ALERT_10 = 'A'
                               THEN
                                  CNT_10
                               WHEN     A.ID_ALERT = 11
                                    AND COD_STATO = 'RS'
                                    AND ALERT_11 = 'A'
                               THEN
                                  CNT_11
                               WHEN     A.ID_ALERT = 12
                                    AND COD_STATO = 'RS'
                                    AND ALERT_12 = 'A'
                               THEN
                                  CNT_12
                               WHEN     A.ID_ALERT = 13
                                    AND COD_STATO = 'RS'
                                    AND ALERT_13 = 'A'
                               THEN
                                  CNT_13
                               WHEN     A.ID_ALERT = 14
                                    AND COD_STATO = 'RS'
                                    AND ALERT_14 = 'A'
                               THEN
                                  CNT_14
                               WHEN     A.ID_ALERT = 15
                                    AND COD_STATO = 'RS'
                                    AND ALERT_15 = 'A'
                               THEN
                                  CNT_15
                               WHEN     A.ID_ALERT = 16
                                    AND COD_STATO_PRECEDENTE = 'RS'
                                    AND ALERT_16 = 'A'
                               THEN
                                  CNT_16
                               WHEN     A.ID_ALERT = 17
                                    AND COD_STATO = 'RS'
                                    AND ALERT_17 = 'A'
                               THEN
                                  CNT_17
                               WHEN     A.ID_ALERT = 18
                                    AND COD_STATO = 'RS'
                                    AND ALERT_18 = 'A'
                               THEN
                                  CNT_18
                               WHEN     A.ID_ALERT = 19
                                    AND COD_STATO = 'RS'
                                    AND ALERT_19 = 'A'
                               THEN
                                  CNT_19
                               WHEN     A.ID_ALERT = 20
                                    AND COD_STATO = 'RS'
                                    AND ALERT_20 = 'A'
                               THEN
                                  CNT_20
                               WHEN     A.ID_ALERT = 21
                                    AND COD_STATO = 'RS'
                                    AND ALERT_21 = 'A'
                               THEN
                                  CNT_21
                               WHEN     A.ID_ALERT = 22
                                    AND COD_STATO = 'RS'
                                    AND ALERT_22 = 'A'
                               THEN
                                  CNT_22
                               WHEN     A.ID_ALERT = 23
                                    AND COD_STATO = 'RS'
                                    AND ALERT_23 = 'A'
                               THEN
                                  CNT_23
                               WHEN     A.ID_ALERT = 24
                                    AND COD_STATO = 'RS'
                                    AND ALERT_24 = 'A'
                               THEN
                                  CNT_24
                               WHEN     A.ID_ALERT = 25
                                    AND COD_STATO = 'RS'
                                    AND ALERT_25 = 'A'
                               THEN
                                  CNT_25
                               WHEN     A.ID_ALERT = 36
                                    AND COD_STATO = 'RS'
                                    AND ALERT_36 = 'A'
                               THEN
                                  36
                               WHEN     A.ID_ALERT = 37
                                    AND COD_STATO = 'RS'
                                    AND ALERT_37 = 'A'
                               THEN
                                  CNT_37
                               ELSE
                                  0
                            END
                               RS_A
                       FROM (SELECT /*+ ordered no_parallel(p) */
                                   DISTINCT
                                    X.ID_UTENTE,
                                    X.ID_REFERENTE,
                                    COD_COMPARTO COD_COMPARTO_POSIZIONE,
                                    COD_RAMO_CALCOLATO,
                                    X.COD_MACROSTATO COD_STATO,
                                    X.COD_MACROSTATO COD_STATO_PRECEDENTE,
                                    ALERT_1,
                                    DECODE (
                                       ALERT_1,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_1,
                                                       X.COD_MACROSTATO))
                                       CNT_1,
                                    ALERT_2,
                                    DECODE (
                                       ALERT_2,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_2,
                                                       X.COD_MACROSTATO))
                                       CNT_2,
                                    ALERT_3,
                                    DECODE (
                                       ALERT_3,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_3,
                                                       X.COD_MACROSTATO))
                                       CNT_3,
                                    ALERT_4,
                                    DECODE (
                                       ALERT_4,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_4,
                                                       X.COD_MACROSTATO))
                                       CNT_4,
                                    ALERT_5,
                                    DECODE (
                                       ALERT_5,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_5,
                                                       X.COD_MACROSTATO))
                                       CNT_5,
                                    ALERT_6,
                                    DECODE (
                                       ALERT_6,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_6,
                                                       X.COD_MACROSTATO))
                                       CNT_6,
                                    ALERT_7,
                                    DECODE (
                                       ALERT_7,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_7,
                                                       X.COD_MACROSTATO))
                                       CNT_7,
                                    ALERT_8,
                                    DECODE (
                                       ALERT_8,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_8,
                                                       X.COD_MACROSTATO))
                                       CNT_8,
                                    ALERT_9,
                                    DECODE (
                                       ALERT_9,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_9,
                                                       X.COD_MACROSTATO))
                                       CNT_9,
                                    ALERT_10,
                                    DECODE (
                                       ALERT_10,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_10,
                                                       X.COD_MACROSTATO))
                                       CNT_10,
                                    ALERT_11,
                                    DECODE (
                                       ALERT_11,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_11,
                                                       X.COD_MACROSTATO))
                                       CNT_11,
                                    ALERT_12,
                                    DECODE (
                                       ALERT_12,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_12,
                                                       X.COD_MACROSTATO))
                                       CNT_12,
                                    ALERT_13,
                                    DECODE (
                                       ALERT_13,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_13,
                                                       X.COD_MACROSTATO))
                                       CNT_13,
                                    ALERT_14,
                                    DECODE (
                                       ALERT_14,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_14,
                                                       X.COD_MACROSTATO))
                                       CNT_14,
                                    ALERT_15,
                                    DECODE (
                                       ALERT_15,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_15,
                                                       X.COD_MACROSTATO))
                                       CNT_15,
                                    ALERT_16,
                                    DECODE (
                                       ALERT_16,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_16,
                                                       X.COD_MACROSTATO))
                                       CNT_16,
                                    ALERT_17,
                                    DECODE (
                                       ALERT_17,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_17,
                                                       X.COD_MACROSTATO))
                                       CNT_17,
                                    ALERT_18,
                                    DECODE (
                                       ALERT_18,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_18,
                                                       X.COD_MACROSTATO))
                                       CNT_18,
                                    ALERT_19,
                                    DECODE (
                                       ALERT_19,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_19,
                                                       X.COD_MACROSTATO))
                                       CNT_19,
                                    ALERT_20,
                                    DECODE (
                                       ALERT_20,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
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
                                                       X.ID_REFERENTE,
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
                                                       X.ID_REFERENTE,
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
                                                       X.ID_REFERENTE,
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
                                                       X.ID_REFERENTE,
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
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_25,
                                                       X.COD_MACROSTATO))
                                       CNT_25,
                                    ALERT_36,
                                    DECODE (
                                       ALERT_36,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_36,
                                                       X.COD_MACROSTATO))
                                       CNT_36,
                                    ALERT_37,
                                    DECODE (
                                       ALERT_37,
                                       NULL, TO_NUMBER (NULL),
                                       COUNT (
                                          *)
                                       OVER (
                                          PARTITION BY X.ID_UTENTE,
                                                       X.ID_REFERENTE,
                                                       COD_COMPARTO,
                                                       COD_RAMO_CALCOLATO,
                                                       ALERT_37,
                                                       X.COD_MACROSTATO))
                                       CNT_37
                               FROM T_MCRE0_APP_ALERT_POS P, -----   V_MCRE0_APP_UPD_FIELDS_ALL x--,
                                    -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
                                    V_MCRE0_APP_UPD_FIELDS X
                              --,
                              -- MCRE_OWN.MV_MCRE0_APP_ISTITUTI I,
                              -- MCRE_OWN.T_MCRE0_APP_UTENTI U,
                              --  t_mcre0_app_stati s
                              WHERE     X.COD_ABI_CARTOLARIZZATO =
                                           P.COD_ABI_CARTOLARIZZATO
                                    AND X.COD_NDG = P.COD_NDG
                                    -- AND x.cod_stato_precedente =  s.COD_MICROSTATO(+)
                                    --  AND p.cod_abi_cartolarizzato = i.cod_abi(+)
                                    --  AND x.id_utente = u.id_utente(+)
                                    -- AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
                                    AND X.FLG_OUTSOURCING = 'Y'
                                    --   AND I.FLG_TARGET = 'Y'
                                    AND X.FLG_TARGET = 'Y') B,
                            T_MCRE0_APP_ALERT A
                      WHERE A.FLG_ATTIVO = 'A')
           GROUP BY ID_UTENTE,
                    ID_REFERENTE,
                    COD_COMPARTO_POSIZIONE,
                    COD_RAMO_CALCOLATO,
                    ID_ALERT,
                    DESC_ALERT,
                    VAL_ORDINE_A,
                    VAL_ORDINE_E) AL,
          T_MCRE0_APP_ALERT_RUOLI R
    WHERE AL.ID_ALERT = R.ID_ALERT;
