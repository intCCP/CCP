/* Formatted on 17/06/2014 18:04:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_CHECK_REPORT
(
   ID_PROCESSO,
   DTA_CONTROLLO,
   COD_CRUSCOTTO,
   DESC_CRUSCOTTO,
   COD_CONTROLLO,
   ID_DPER,
   DESC_BREVE_CONTROLLO,
   DESC_CONTROLLO,
   COD_TIPO_CONTROLLO,
   TIPO_CONTROLLO,
   BLOCCANTE,
   VALORE_RESTITUITO,
   VALORE_ATTESO,
   ESITO,
   NOTE,
   TABELLA_DETTAGLIO
)
AS
     SELECT B.PID AS ID_PROCESSO,
            B.DT_INS AS DTA_CONTROLLO,
            A.DOMAIN AS COD_CRUSCOTTO,
            X.DESCRIPTION AS DESC_CRUSCOTTO,
            A.COD_CHECK AS COD_CONTROLLO,
            B.ID_DPER AS ID_DPER,
            A.DESC_SHORT AS DESC_BREVE_CONTROLLO,
            A.DESCRIPTION AS DESC_CONTROLLO,
            Y.TYPE_CHECK AS COD_TIPO_CONTROLLO,
            Y.DESCRIPTION AS TIPO_CONTROLLO,
            DECODE (A.FLG_LOCK,  0, 'NO',  1, 'SI') AS BLOCCANTE,
            B.RET_VALUE AS VALORE_RESTITUITO,
            NVL (
               TO_CHAR (C.EXP_VALUE),
               CASE
                  WHEN (Y.TYPE_CHECK = 'CNS')
                  THEN
                     (SELECT    (SELECT EXP_VALUE
                                   FROM T_MCRE0_CHECK_ENGINE_THRESHOLD
                                  WHERE     COD_THRESHOLD = 'MIN'
                                        AND COD_CHECK = A.COD_CHECK)
                             || ' - '
                             || (SELECT EXP_VALUE
                                   FROM T_MCRE0_CHECK_ENGINE_THRESHOLD
                                  WHERE     COD_THRESHOLD = 'MAX'
                                        AND COD_CHECK = A.COD_CHECK)
                        FROM DUAL)
                  ELSE
                     NULL
               END)
               AS VALORE_ATTESO,
            B.RESULT AS ESITO,
            B.NOTES AS NOTE,
            A.DEF_TAB_DETAIL AS TABELLA_DETTAGLIO
       FROM T_MCRE0_CHECK_ENGINE_WORK A
            LEFT JOIN T_MCRE0_CHECK_ENGINE_RESULT B
               ON (A.COD_CHECK = B.COD_CHECK AND A.FLG_ENABLE = 1)
            LEFT JOIN T_MCRE0_CHECK_ENGINE_THRESHOLD C
               ON (A.COD_CHECK = C.COD_CHECK AND C.COD_THRESHOLD = 'EXP')
            JOIN T_MCRE0_CHECK_ENGINE_DOMAIN X ON (A.DOMAIN = X.DOMAIN)
            JOIN T_MCRE0_CHECK_ENGINE_TCHECK Y ON (A.TYPE_CHECK = Y.TYPE_CHECK)
   ORDER BY A.DOMAIN, B.DT_INS, A.POSITION;


GRANT SELECT ON MCRE_OWN.V_MCRE0_CHECK_REPORT TO MCRE_USR;
