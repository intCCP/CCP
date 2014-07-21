/* Formatted on 21/07/2014 18:35:10 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RIO_ALERT_POS
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   ID_ALERT,
   DESC_ALERT,
   VAL_COLORE,
   VAL_ORDINE_RISCHIO,
   VAL_ORDINE_GRUPPO_RISCHIO,
   DESC_GRUPPO_RISCHIO,
   VAL_FATTORE_RISCHIO,
   ID_GRUPPO,
   VAL_PESO,
   VAL_PESO_TOTALE,
   VAL_COLORE_TOTALE
)
AS
   SELECT                                    -- v1 ???????? VG: prima versione
 -- v2 30/03/2011 MDM: modificata vista valorizzando val_ordine_rischio con il val_ordine_gestore estratto da t_mcre0_app_alert
                                       -- v3 04/04/2011 VG: val_ordine_rischio
                   -- V4 06/05/2011 VG: modiicato calcolo e aggiunto id_gruppo
        R.COD_ABI_CARTOLARIZZATO,
        R.COD_NDG,
        ID_ALERT,
        R.DESC_ALERT,
        R.VAL_COLORE,
        VAL_ORDINE_RISCHIO,
        VAL_ORDINE_GRUPPO_RISCHIO,
        DESC_GRUPPO_RISCHIO,
        R.VAL_FATTORE_RISCHIO,
        R.ID_GRUPPO,
          R.VAL_FATTORE_RISCHIO
        * DECODE (
             VAL_COLORE,
             'V', VAL_VERDE,
             DECODE (VAL_COLORE,
                     'A', VAL_ARANCIO,
                     DECODE (VAL_COLORE, 'R', VAL_ROSSO, NULL)))
           VAL_PESO,
        SUM (
             R.VAL_FATTORE_RISCHIO
           * DECODE (
                VAL_COLORE,
                'V', VAL_VERDE,
                DECODE (VAL_COLORE,
                        'A', VAL_ARANCIO,
                        DECODE (VAL_COLORE, 'R', VAL_ROSSO, NULL))))
        OVER (PARTITION BY COD_ABI_CARTOLARIZZATO, COD_NDG, ID_GRUPPO)
           VAL_PESO_TOTALE,
        CASE
           WHEN SUM (
                     R.VAL_FATTORE_RISCHIO
                   * DECODE (
                        VAL_COLORE,
                        'V', VAL_VERDE,
                        DECODE (VAL_COLORE,
                                'A', VAL_ARANCIO,
                                DECODE (VAL_COLORE, 'R', VAL_ROSSO, NULL))))
                OVER (PARTITION BY COD_ABI_CARTOLARIZZATO, COD_NDG, ID_GRUPPO) <=
                   45
           THEN
              'V'
           WHEN SUM (
                     R.VAL_FATTORE_RISCHIO
                   * DECODE (
                        VAL_COLORE,
                        'V', VAL_VERDE,
                        DECODE (VAL_COLORE,
                                'A', VAL_ARANCIO,
                                DECODE (VAL_COLORE, 'R', VAL_ROSSO, NULL))))
                OVER (PARTITION BY COD_ABI_CARTOLARIZZATO, COD_NDG, ID_GRUPPO) BETWEEN 46
                                                                                   AND 69
           THEN
              'A'
           WHEN SUM (
                     R.VAL_FATTORE_RISCHIO
                   * DECODE (
                        VAL_COLORE,
                        'V', VAL_VERDE,
                        DECODE (VAL_COLORE,
                                'A', VAL_ARANCIO,
                                DECODE (VAL_COLORE, 'R', VAL_ROSSO, NULL))))
                OVER (PARTITION BY COD_ABI_CARTOLARIZZATO, COD_NDG, ID_GRUPPO) >=
                   70
           THEN
              'R'
           ELSE
              NULL
        END
           VAL_COLORE_TOTALE
   FROM (SELECT P.COD_ABI_CARTOLARIZZATO,
                P.COD_NDG,
                A.ID_ALERT,
                A.DESC_ALERT,
                A.VAL_VERDE,
                A.VAL_ROSSO,
                A.VAL_ARANCIO,
                A.VAL_GRUPPO VAL_ORDINE_RISCHIO,
                SUBSTR (A.VAL_GRUPPO, 0, 1) VAL_ORDINE_GRUPPO_RISCHIO,
                A.DESC_GRUPPO DESC_GRUPPO_RISCHIO,
                DECODE (A.COD_PRIVILEGIO,
                        'A', A.VAL_FATTORE_RISCHIO_A,
                        A.VAL_FATTORE_RISCHIO_E)
                   VAL_FATTORE_RISCHIO,
                A.ID_GRUPPO,
                CASE
                   WHEN A.ID_ALERT = 1 THEN P.ALERT_1
                   WHEN A.ID_ALERT = 2 THEN P.ALERT_2
                   WHEN A.ID_ALERT = 3 THEN P.ALERT_3
                   WHEN A.ID_ALERT = 4 THEN P.ALERT_4
                   WHEN A.ID_ALERT = 5 THEN P.ALERT_5
                   WHEN A.ID_ALERT = 6 THEN P.ALERT_6
                   WHEN A.ID_ALERT = 7 THEN P.ALERT_7
                   WHEN A.ID_ALERT = 8 THEN P.ALERT_8
                   WHEN A.ID_ALERT = 9 THEN P.ALERT_9
                   WHEN A.ID_ALERT = 10 THEN P.ALERT_10
                   WHEN A.ID_ALERT = 11 THEN P.ALERT_11
                   WHEN A.ID_ALERT = 12 THEN P.ALERT_12
                   WHEN A.ID_ALERT = 13 THEN P.ALERT_13
                   WHEN A.ID_ALERT = 14 THEN P.ALERT_14
                   WHEN A.ID_ALERT = 15 THEN P.ALERT_15
                   WHEN A.ID_ALERT = 16 THEN P.ALERT_16
                   WHEN A.ID_ALERT = 17 THEN P.ALERT_17
                   WHEN A.ID_ALERT = 18 THEN P.ALERT_18
                   WHEN A.ID_ALERT = 19 THEN P.ALERT_19
                   WHEN A.ID_ALERT = 20 THEN P.ALERT_20
                   WHEN A.ID_ALERT = 21 THEN P.ALERT_21
                   WHEN A.ID_ALERT = 22 THEN P.ALERT_22
                   WHEN A.ID_ALERT = 23 THEN P.ALERT_23
                   WHEN A.ID_ALERT = 24 THEN P.ALERT_24
                   WHEN A.ID_ALERT = 25 THEN P.ALERT_25
                   ELSE NULL
                END
                   VAL_COLORE
           FROM T_MCRE0_APP_ALERT_POS P,
                V_MCRE0_APP_UPD_FIELDS_P1 X,
                (SELECT A.*, R.COD_PRIVILEGIO, R.ID_GRUPPO
                   FROM T_MCRE0_APP_ALERT A, T_MCRE0_APP_ALERT_RUOLI R
                  WHERE     A.ID_ALERT = R.ID_ALERT(+)
                        AND A.FLG_ATTIVO = 'A'
                        AND A.FLG_RIO = 1
                        AND VAL_GRUPPO IS NOT NULL) A
          WHERE     P.COD_ABI_CARTOLARIZZATO = X.COD_ABI_CARTOLARIZZATO
                AND P.COD_NDG = X.COD_NDG
                AND X.COD_MACROSTATO = 'RIO') R;
