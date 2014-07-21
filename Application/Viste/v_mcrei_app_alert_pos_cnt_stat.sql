/* Formatted on 21/07/2014 18:39:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_ALERT_POS_CNT_STAT
(
   ID_UTENTE,
   ID_REFERENTE,
   COD_COMPARTO_POSIZIONE,
   COD_RAMO_CALCOLATO,
   ID_ALERT,
   DESC_ALERT,
   VAL_ORDINE_A,
   VAL_ORDINE_E,
   BO_R,
   BO_A,
   BO_V,
   PT_R,
   PT_A,
   PT_V,
   RIO_R,
   RIO_A,
   RIO_V,
   XS_R,
   XS_A,
   XS_V,
   IN_R,
   IN_A,
   IN_V,
   RI_R,
   RI_A,
   RI_V,
   ID_GRUPPO,
   COD_PRIVILEGIO
)
AS
     SELECT ID_UTENTE,
            ID_REFERENTE,
            COD_COMPARTO AS COD_COMPARTO_POSIZIONE,
            COD_RAMO_CALCOLATO,
            CNT.ID_ALERT AS ID_ALERT,
            al.DESC_ALERT,
            VAL_ORDINE_A,
            VAL_ORDINE_E,
            --
            SUM (cnt_GB_R) AS BO_R,
            --              'G' giallo,
            SUM (cnt_GB_g) AS BO_A,
            --              'V' verde,
            SUM (cnt_GB_v) AS BO_V,
            --
            SUM (cnt_PT_R) AS PT_R,
            --              'G' giallo,
            SUM (cnt_PT_g) AS PT_A,
            --              'V' verde,
            SUM (cnt_PT_v) AS PT_V,
            --
            SUM (cnt_RIO_R) AS RIO_R,
            --              'G' giallo,
            SUM (cnt_RIO_g) AS RIO_A,
            --              'V' verde,
            SUM (cnt_RIO_v) AS RIO_V,
            --
            SUM (cnt_XS_R) AS XS_R,
            --              'G' giallo,
            SUM (cnt_XS_g) AS XS_A,
            --              'V' verde,
            SUM (cnt_XS_v) AS XS_V,
            --              'R' rosso,
            SUM (cnt_IN_R) AS IN_R,
            --              'G' giallo,
            SUM (cnt_IN_g) AS IN_A,
            --              'V' verde,
            SUM (cnt_IN_v) AS IN_V,
            SUM (cnt_RI_R) AS RI_R,
            --              'G' giallo,
            SUM (cnt_RI_g) AS RI_A,
            --              'V' verde,
            SUM (cnt_RI_v) AS RI_V,
            TO_NUMBER (NULL) AS ID_GRUPPO,
            'A' AS COD_PRIVILEGIO
       FROM (  SELECT id_alert,
                      p.COD_STATO,
                      X.ID_UTENTE,
                      X.ID_REFERENTE,
                      X.COD_COMPARTO,
                      X.COD_RAMO_CALCOLATO,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND P.COD_STATO = 'GB'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_GB_R,
                      -- giallo,
                      SUM (
                         CASE
                            WHEN alert = 'G' AND P.COD_STATO = 'GB'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_GB_G,
                      -- verde,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND P.COD_STATO = 'GB'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_GB_V,
                      -- giallo,
                      SUM (
                         CASE
                            WHEN alert = 'G' AND P.COD_STATO = 'PT'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_PT_G,
                      -- verde,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND P.COD_STATO = 'PT'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_PT_V,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND P.COD_STATO = 'PT'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_PT_R,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND P.COD_STATO = 'RIO'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_RIO_R,
                      -- giallo,
                      SUM (
                         CASE
                            WHEN alert = 'G' AND P.COD_STATO = 'RIO'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_RIO_G,
                      -- verde,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND P.COD_STATO = 'RIO'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_RIO_V,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND P.COD_STATO = 'XS'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_XS_R,
                      -- giallo,
                      SUM (
                         CASE
                            WHEN alert = 'G' AND P.COD_STATO = 'XS'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_XS_G,
                      -- verde,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND P.COD_STATO = 'XS'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_XS_V,
                      -- rosso,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND P.COD_STATO = 'IN'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_IN_R,
                      -- giallo,
                      SUM (
                         CASE
                            WHEN alert = 'G' AND P.COD_STATO = 'IN'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_IN_G,
                      -- verde,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND P.COD_STATO = 'IN'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_IN_V,
                      -- rosso,
                      SUM (
                         CASE
                            WHEN alert = 'R' AND P.COD_STATO = 'RI'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_RI_R,
                      -- giallo,
                      SUM (
                         CASE
                            WHEN alert = 'G' AND P.COD_STATO = 'RI'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_RI_G,
                      -- verde,
                      SUM (
                         CASE
                            WHEN alert = 'V' AND P.COD_STATO = 'RI'
                            THEN
                               VAL_CNT_RAPPORTI
                            ELSE
                               0
                         END)
                         CNT_RI_V
                 -- rosso,
                 FROM t_mcrei_app_alert_pos_wrk p, V_MCRE0_APP_UPD_FIELDS X
                WHERE     X.COD_ABI_CARTOLARIZZATO = P.COD_ABI
                      AND X.COD_NDG = P.COD_NDG
                      AND X.FLG_OUTSOURCING = 'Y'
                      AND X.FLG_TARGET = 'Y'
             GROUP BY id_alert,
                      p.COD_STATO,
                      X.ID_UTENTE,
                      X.ID_REFERENTE,
                      X.COD_COMPARTO,
                      X.COD_RAMO_CALCOLATO) cnt,
            t_mcrei_app_alert al
      WHERE cnt.id_alert = al.id_alert
   GROUP BY ID_UTENTE,
            ID_REFERENTE,
            COD_COMPARTO,
            COD_RAMO_CALCOLATO,
            CNT.ID_ALERT,
            al.DESC_ALERT,
            VAL_ORDINE_A,
            VAL_ORDINE_E
   ORDER BY cnt.id_alert, al.DESC_ALERT;
