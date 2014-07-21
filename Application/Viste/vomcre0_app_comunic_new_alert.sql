/* Formatted on 21/07/2014 18:46:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_COMUNIC_NEW_ALERT
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
   ID_ALERT
)
AS
   SELECT                                             -- VG 14/03/2011Comparto
          -- VG 07/04/2011 id_alert
          -- VG 20/04/2011 RIFATTA!!!
          S.COD_ABI_CARTOLARIZZATO,
          F.COD_ABI_ISTITUTO,
          S.COD_NDG,
          GE.DESC_NOME_CONTROPARTE,
          G.VAL_ANA_GRE,
          F.COD_STATO,
          DTA_ALERT,
          DESC_ALERT,
          VAL_COLORE_ALERT,
          F.ID_UTENTE,
          U.ID_REFERENTE,
          F.COD_COMPARTO,
          S.ID_ALERT
     FROM (SELECT DISTINCT
                  P.COD_ABI_CARTOLARIZZATO,
                  P.COD_NDG,
                  P.COD_SNDG,
                  ID_ALERT,
                  DESC_ALERT,
                  CASE
                     WHEN ID_ALERT = 1 THEN ALERT_1
                     WHEN ID_ALERT = 2 THEN ALERT_2
                     WHEN ID_ALERT = 3 THEN ALERT_3
                     WHEN ID_ALERT = 4 THEN ALERT_4
                     WHEN ID_ALERT = 5 THEN ALERT_5
                     WHEN ID_ALERT = 6 THEN ALERT_6
                     WHEN ID_ALERT = 7 THEN ALERT_7
                     WHEN ID_ALERT = 8 THEN ALERT_8
                     WHEN ID_ALERT = 9 THEN ALERT_9
                     WHEN ID_ALERT = 10 THEN ALERT_10
                     WHEN ID_ALERT = 11 THEN ALERT_11
                     WHEN ID_ALERT = 12 THEN ALERT_12
                     WHEN ID_ALERT = 13 THEN ALERT_13
                     WHEN ID_ALERT = 14 THEN ALERT_14
                     WHEN ID_ALERT = 15 THEN ALERT_15
                     WHEN ID_ALERT = 16 THEN ALERT_16
                     WHEN ID_ALERT = 17 THEN ALERT_17
                     WHEN ID_ALERT = 18 THEN ALERT_18
                     WHEN ID_ALERT = 19 THEN ALERT_19
                     WHEN ID_ALERT = 20 THEN ALERT_20
                     WHEN ID_ALERT = 21 THEN ALERT_21
                  END
                     VAL_COLORE_ALERT,
                  CASE
                     WHEN ID_ALERT = 1
                     THEN
                        DECODE (TRUNC (DTA_INS_1) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_1),
                                TRUNC (DTA_UPD_1))
                     WHEN ID_ALERT = 2
                     THEN
                        DECODE (TRUNC (DTA_INS_2) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_2),
                                TRUNC (DTA_UPD_2))
                     WHEN ID_ALERT = 3
                     THEN
                        DECODE (TRUNC (DTA_INS_3) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_3),
                                TRUNC (DTA_UPD_3))
                     WHEN ID_ALERT = 4
                     THEN
                        DECODE (TRUNC (DTA_INS_4) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_4),
                                TRUNC (DTA_UPD_4))
                     WHEN ID_ALERT = 5
                     THEN
                        DECODE (TRUNC (DTA_INS_5) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_5),
                                TRUNC (DTA_UPD_5))
                     WHEN ID_ALERT = 6
                     THEN
                        DECODE (TRUNC (DTA_INS_6) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_6),
                                TRUNC (DTA_UPD_6))
                     WHEN ID_ALERT = 7
                     THEN
                        DECODE (TRUNC (DTA_INS_7) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_7),
                                TRUNC (DTA_UPD_7))
                     WHEN ID_ALERT = 8
                     THEN
                        DECODE (TRUNC (DTA_INS_8) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_8),
                                TRUNC (DTA_UPD_8))
                     WHEN ID_ALERT = 9
                     THEN
                        DECODE (TRUNC (DTA_INS_9) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_9),
                                TRUNC (DTA_UPD_9))
                     WHEN ID_ALERT = 10
                     THEN
                        DECODE (TRUNC (DTA_INS_10) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_10),
                                TRUNC (DTA_UPD_10))
                     WHEN ID_ALERT = 11
                     THEN
                        DECODE (TRUNC (DTA_INS_11) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_11),
                                TRUNC (DTA_UPD_11))
                     WHEN ID_ALERT = 12
                     THEN
                        DECODE (TRUNC (DTA_INS_12) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_12),
                                TRUNC (DTA_UPD_12))
                     WHEN ID_ALERT = 13
                     THEN
                        DECODE (TRUNC (DTA_INS_13) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_13),
                                TRUNC (DTA_UPD_13))
                     WHEN ID_ALERT = 14
                     THEN
                        DECODE (TRUNC (DTA_INS_14) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_14),
                                TRUNC (DTA_UPD_14))
                     WHEN ID_ALERT = 15
                     THEN
                        DECODE (TRUNC (DTA_INS_15) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_15),
                                TRUNC (DTA_UPD_15))
                     WHEN ID_ALERT = 16
                     THEN
                        DECODE (TRUNC (DTA_INS_16) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_16),
                                TRUNC (DTA_UPD_16))
                     WHEN ID_ALERT = 17
                     THEN
                        DECODE (TRUNC (DTA_INS_17) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_17),
                                TRUNC (DTA_UPD_17))
                     WHEN ID_ALERT = 18
                     THEN
                        DECODE (TRUNC (DTA_INS_18) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_18),
                                TRUNC (DTA_UPD_18))
                     WHEN ID_ALERT = 19
                     THEN
                        DECODE (TRUNC (DTA_INS_19) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_19),
                                TRUNC (DTA_UPD_19))
                     WHEN ID_ALERT = 20
                     THEN
                        DECODE (TRUNC (DTA_INS_20) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_20),
                                TRUNC (DTA_UPD_20))
                     WHEN ID_ALERT = 21
                     THEN
                        DECODE (TRUNC (DTA_INS_21) - TRUNC (SYSDATE),
                                0, TRUNC (DTA_INS_21),
                                TRUNC (DTA_UPD_21))
                  END
                     DTA_ALERT
             FROM T_MCRE0_APP_ALERT_POS P,
                  (SELECT A.ID_ALERT, A.DESC_ALERT
                     FROM T_MCRE0_APP_ALERT A, T_MCRE0_APP_ALERT_RUOLI R
                    WHERE     FLG_ATTIVO = 'A'
                          AND A.ID_ALERT = R.ID_ALERT
                          AND R.ID_GRUPPO = 30) --   and R.COD_PRIVILEGIO = 'A')
                                               ) S,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO GE,
          T_MCRE0_APP_ANAGR_GRE G,
          MV_MCRE0_APP_UPD_FIELD F,
          T_MCRE0_APP_UTENTI U,
          MV_MCRE0_APP_ISTITUTI I
    WHERE     F.ID_UTENTE = U.ID_UTENTE
          AND F.COD_SNDG = GE.COD_SNDG(+)
          AND F.COD_GRUPPO_ECONOMICO = G.COD_GRE(+)
          AND F.COD_ABI_CARTOLARIZZATO = S.COD_ABI_CARTOLARIZZATO
          AND F.COD_NDG = S.COD_NDG
          AND F.COD_ABI_ISTITUTO = I.COD_ABI(+)
          AND NVL (F.FLG_OUTSOURCING, 'N') = 'Y'
          AND I.FLG_TARGET = 'Y'
          AND F.ID_UTENTE IS NOT NULL
          AND S.DTA_ALERT >= TRUNC (SYSDATE)
          AND S.VAL_COLORE_ALERT IS NOT NULL;
