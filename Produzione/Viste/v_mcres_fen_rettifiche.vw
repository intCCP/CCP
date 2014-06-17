/* Formatted on 17/06/2014 18:12:49 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETTIFICHE
(
   COD_ABI,
   VAL_ANNOMESE,
   VAL_ANNOMESE_DRC_DA_CONT,
   VAL_ANNOMESE_DRC_CONT,
   COD_DIVISIONE,
   VAL_RETTIFICA_NETTA,
   VAL_RETTIFICA_NETTA_TRIM,
   VAL_RV_MESE,
   VAL_RV_YTD,
   VAL_DRC_MESE_CONT,
   VAL_DRC_MESE_DA_CONT,
   VAL_DRC_TRIM,
   VAL_DRC_ANNO
)
AS
   WITH                                                  --AG: v2.4 23/09/2011
                                                         --AG: v2.5 10/10/2011
                                                         --AG: v2.6 19/10/2011
   DIVISIONE
   AS (SELECT DISTINCT
              CP.COD_ABI,
              CP.COD_NDG,
              CP.COD_FILIALE,
              CASE
                 WHEN O.COD_DIV IN ('DIVRE', 'DIVCI', 'DIVPR')
                 THEN
                    1
                 WHEN O.COD_DIV IN ('DIVCC', 'DIVLC', 'DIVFI', 'DIVES')
                 THEN
                    2
                 ELSE
                    3
              END
                 COD_DIVISIONE
         FROM T_MCRES_APP_SISBA_CP CP,
              V_MCRES_ULTIMA_ACQ_FILE F,
              T_MCRE0_APP_STRUTTURA_ORG O
        WHERE     CP.COD_ABI = F.COD_ABI
              AND CP.ID_DPER = F.ID_DPER
              AND F.COD_FLUSSO = 'SISBA_CP'
              AND CP.COD_ABI = O.COD_ABI_ISTITUTO
              AND CP.COD_FILIALE = O.COD_STRUTTURA_COMPETENTE),
   POSIZIONI
   AS (SELECT R.COD_ABI,
              R.COD_NDG,
              D.COD_DIVISIONE,
              CASE
                 WHEN M.COD_CAUSALE_MOVIMENTO IN ('006', '0I5', '0I6', '0I7')
                 THEN
                    M.VAL_IMP_MOVIMENTO
                 ELSE
                    0
              END
                 VAL_IMP_MOVIMENTO,
              R.VAL_IMP_GBV_INIZIALE - R.VAL_IMP_NBV_INIZIALE DIFF_INI,
              P.FLG_IN_MESE_DA_CONT,
              P.FLG_IN_MESE_CONT,
              P.FLG_IN_TRIM,
              P.FLG_IN_ANNO
         FROM T_MCRES_APP_RAPPORTI R,
              T_MCRES_APP_MOVIMENTI M,
              (SELECT DISTINCT
                      D.COD_ABI,
                      D.COD_NDG,
                      CASE
                         WHEN TO_CHAR (D.DTA_INSERIMENTO_DELIBERA, 'YYYYMM') =
                                 U.VAL_ANNOMESE_ULTIMO_SISBA
                         THEN
                            1
                         ELSE
                            0
                      END
                         FLG_IN_MESE_DA_CONT,
                      CASE
                         WHEN TO_CHAR (D.DTA_INSERIMENTO_DELIBERA, 'YYYYMM') =
                                 U.VAL_ANNOMESE_ULTIMO_SISBA_CP
                         THEN
                            1
                         ELSE
                            0
                      END
                         FLG_IN_MESE_CONT,
                      CASE
                         WHEN TO_CHAR (D.DTA_INSERIMENTO_DELIBERA, 'YYYYMM') BETWEEN U.VAL_ANNOMESE_START_LAST_Q_CONT
                                                                                 AND U.VAL_ANNOMESE_END_LAST_Q_CONT
                         THEN
                            1
                         ELSE
                            0
                      END
                         FLG_IN_TRIM,
                      CASE
                         WHEN TO_CHAR (D.DTA_INSERIMENTO_DELIBERA, 'YYYYMM') =
                                 u.val_annomese_ultimo_sisba_cp --non sysdate per problemi con lo storico
                         THEN
                            1
                         ELSE
                            0
                      END
                         FLG_IN_ANNO
                 FROM T_MCRES_APP_DELIBERE D,
                      V_MCRES_APP_ULTIMO_ANNOMESEABI U
                WHERE UPPER (COD_DELIBERA) = 'NS' AND D.COD_ABI = U.COD_ABI) P,
              V_MCRES_APP_ULTIMO_ANNOMESEABI U,
              DIVISIONE D
        WHERE     M.COD_ABI = R.COD_ABI
              AND R.COD_RAPPORTO = M.COD_RAPPORTO
              AND R.COD_ABI = P.COD_ABI(+)
              AND R.COD_NDG = P.COD_NDG(+)
              AND R.COD_ABI = D.COD_ABI
              AND R.COD_NDG = D.COD_NDG)
   SELECT B.COD_ABI,
          E.VAL_ANNOMESE,
          A.VAL_ANNOMESE_SISBA VAL_ANNOMESE_DRC_DA_CONT,
          B.VAL_ANNOMESE_SISBA_CP VAL_ANNOMESE_DRC_CONT,
          B.COD_DIVISIONE,
          --RV NETTE MESE BILANCIO: SOMMA DI TUTTE LE RETTIFICHE DI VALORE NELL'ULTIMO
          -- MESE DI BILANCIO
          E.VAL_RETTIFICA_NETTA,
          --RV TRIMESTRALE: SOMMA DI TUTTE LE RETTIFICHE DI VALORE NELL'ULTIMO
          -- TRIMESTRE DI BILANCIO
          E.VAL_RETTIFICA_NETTA_TRIM,
            -- RV NETTE MESE
            (A.DIFF_0_SOFF - B.DIFF_MESE_SOFF_INC + A.MOV_0_SOFF)
          - (B.DIFF_MESE_EX_SOFF - A.DIFF_0_INC + A.MOV_0_INC)
             VAL_RV_MESE,
            -- RV NETTA QUARTER TO DATE
            --    (A.DIFF_0_SOFF - B.DIFF_TRIM_SOFF_INC + A.MOV_0_SOFF )- (
            -- B.DIFF_TRIM_EX_SOFF -  A.DIFF_0_INC   + A.MOV_0_INC) VAL_RV_QTD,
            -- RV NETTA YEAR TO DATE
            (A.DIFF_0_SOFF - B.DIFF_ANNO_SOFF_INC + A.MOV_0_SOFF)
          - (B.DIFF_ANNO_EX_SOFF - A.DIFF_0_INC + A.MOV_0_INC)
             VAL_RV_YTD,
            -- DRC ULTIMO MESE CONTABILIZZATO
            (A.DIFF_0_SOFF - B.DIFF_MESE_SOFF_INC + A.MOV_0_SOFF)
          - (B.DIFF_MESE_EX_SOFF - A.DIFF_0_INC + A.MOV_0_INC)
          + (C.DIFF_INI_MESE_CONT - B.DIFF_PENULTIMO_CP_SOFF_INC)
             VAL_DRC_MESE_CONT,
          -- DRC ULTIMO MESE DA CONTABILIZZARE
          CASE
             WHEN A.VAL_ANNOMESE_SISBA = B.VAL_ANNOMESE_SISBA_CP
             THEN
                NULL
             ELSE
                  (A.DIFF_0_SOFF - B.DIFF_MESE_SOFF_INC + A.MOV_0_SOFF)
                - (B.DIFF_MESE_EX_SOFF - A.DIFF_0_INC + A.MOV_0_INC)
                + (C.DIFF_INI_MESE_DA_CONT - B.DIFF_PENULTIMO_SISBA_SOFF_INC)
          END
             VAL_DRC_MESE_DA_CONT,
            -- DRC ULTIMO TRIMESTRE CONTABILIZZATO
            E.VAL_RETTIFICA_NETTA_TRIM
          + (C.DIFF_INI_TRIM - B.DIFF_TRIM_SISBA_CP_SOFF_INC)
             VAL_DRC_TRIM,
            -- DRC ULTIMO ANNO CONTABILIZZATO
            (A.DIFF_0_SOFF - B.DIFF_ANNO_SOFF_INC + A.MOV_0_SOFF)
          - (B.DIFF_ANNO_EX_SOFF - A.DIFF_0_INC + A.MOV_0_INC)
          + (C.DIFF_INI_ANNO - B.DIFF_ANNO_SISBA_CP_SOFF_INC)
             VAL_DRC_ANNO
     FROM (  SELECT S.COD_ABI,
                    PER.VAL_ANNOMESE_SISBA,
                    D.COD_DIVISIONE,
                    SUM (
                       CASE
                          WHEN     S.COD_STATO_RISCHIO = 'S'
                               AND SUBSTR (S.ID_DPER, 1, 6) =
                                      PER.VAL_ANNOMESE_SISBA
                          THEN
                               S.VAL_IMP_UTI_RETTIFICATO
                             - S.VAL_IMP_NPV_STIMA_RECUPERO
                          ELSE
                             0
                       END)
                       DIFF_0_SOFF,               --PERIODO ATTUALE SOFFERENZA
                    SUM (
                       CASE
                          WHEN     S.COD_STATO_RISCHIO = 'I'
                               AND SUBSTR (S.ID_DPER, 1, 6) =
                                      PER.VAL_ANNOMESE_SISBA
                          THEN
                               S.VAL_IMP_UTI_RETTIFICATO
                             - S.VAL_IMP_NPV_STIMA_RECUPERO
                          ELSE
                             0
                       END)
                       DIFF_0_INC, --PERIODO ATTUALE INCAGLIO, 0 SE ASSENTE IN QUANTO
                    -- BONIS
                    SUM (
                       CASE
                          WHEN     COD_STATO_RISCHIO = 'S'
                               AND S.ID_DPER = PER.VAL_ANNOMESE_SISBA
                          THEN
                             POS.VAL_IMP_MOVIMENTO
                          ELSE
                             0
                       END)
                       MOV_0_SOFF, --MOVIMENTI CON CAUSALE '006', '0I5', '0I6', '0I7' PER
                    -- SOFFERENZA NEL PERIODO ATTUALE
                    SUM (
                       CASE
                          WHEN     COD_STATO_RISCHIO = 'I'
                               AND S.ID_DPER = PER.VAL_ANNOMESE_SISBA
                          THEN
                             POS.VAL_IMP_MOVIMENTO
                          ELSE
                             0
                       END)
                       MOV_0_INC --MOVIMENTI CON CAUSALE '006', '0I5', '0I6', '0I7' PER
               -- SOFFERENZA NEL PERIODO ATTUALE
               FROM T_MCRES_APP_SISBA S,
                    POSIZIONI POS,
                    V_MCRES_APP_ULTIMO_ANNOMESEABI PER,
                    DIVISIONE D
              WHERE     SUBSTR (S.ID_DPER, 1, 6) = PER.VAL_ANNOMESE_SISBA
                    AND S.COD_ABI = PER.COD_ABI
                    AND S.COD_ABI = POS.COD_ABI(+)
                    AND S.COD_NDG = POS.COD_NDG(+)
                    AND S.COD_ABI = D.COD_ABI
                    AND S.COD_NDG = D.COD_NDG(+)
           GROUP BY S.COD_ABI, PER.VAL_ANNOMESE_SISBA, D.COD_DIVISIONE) A,
          (  SELECT COD_ABI,
                    VAL_ANNOMESE_SISBA_CP,
                    COD_DIVISIONE,
                    SUM (DIFF_MESE_SOFF_INC) DIFF_MESE_SOFF_INC,
                    SUM (DIFF_TRIM_SOFF_INC) DIFF_TRIM_SOFF_INC,
                    SUM (DIFF_ANNO_SOFF_INC) DIFF_ANNO_SOFF_INC,
                    SUM (DIFF_MESE_EX_SOFF) DIFF_MESE_EX_SOFF,
                    SUM (DIFF_ANNO_EX_SOFF) DIFF_ANNO_EX_SOFF,
                    SUM (DIFF_PENULTIMO_CP_SOFF_INC) DIFF_PENULTIMO_CP_SOFF_INC,
                    SUM (DIFF_PENULTIMO_SISBA_SOFF_INC)
                       DIFF_PENULTIMO_SISBA_SOFF_INC,
                    SUM (DIFF_TRIM_SISBA_CP_SOFF_INC)
                       DIFF_TRIM_SISBA_CP_SOFF_INC,
                    SUM (DIFF_ANNO_SISBA_CP_SOFF_INC)
                       DIFF_ANNO_SISBA_CP_SOFF_INC
               FROM (SELECT CP.COD_ABI,
                            PER.VAL_ANNOMESE_SISBA_CP,
                            D.COD_DIVISIONE,
                            CASE
                               WHEN     COD_STATO_RISCHIO IN ('S', 'I')
                                    AND CP.ID_DPER = PER.VAL_ANNOMESE_SISBA_CP
                               THEN
                                  VAL_UTI_RET - VAL_ATT
                               ELSE
                                  0
                            END
                               DIFF_MESE_SOFF_INC, --MESE PRECEDENTE SOFFERENZA O INCAGLIO (DATI
                            -- DI BILANCIO)
                            CASE
                               WHEN     COD_STATO_RISCHIO IN ('S', 'I')
                                    AND SUBSTR (CP.ID_DPER, 1, 6) =
                                           PER.VAL_ANNOMESE_END_LAST_Q_CONT
                               THEN
                                  VAL_UTI_RET - VAL_ATT
                               ELSE
                                  0
                            END
                               DIFF_TRIM_SOFF_INC, --FINE TRIMESTRE PRECEDENTE SOFFERENZA O
                            -- INCAGLIO (DATI BILANCIO)
                            CASE
                               WHEN     COD_STATO_RISCHIO IN ('S', 'I')
                                    AND SUBSTR (CP.ID_DPER, 1, 6) =
                                           PER.VAL_ANNOMESE_FINE_ANNO
                               THEN
                                  VAL_UTI_RET - VAL_ATT
                               ELSE
                                  0
                            END
                               DIFF_ANNO_SOFF_INC, --FINE ANNO PRECEDENTE SOFFERENZA O INCAGLIO
                            -- (DATI BILANCIO)
                            CASE
                               WHEN     COD_STATO_RISCHIO != 'S'
                                    AND LAG (
                                           CP.COD_STATO_RISCHIO)
                                        OVER (
                                           PARTITION BY CP.COD_ABI, CP.COD_NDG
                                           ORDER BY CP.ID_DPER) = 'S'
                                    AND CP.ID_DPER = PER.VAL_ANNOMESE_SISBA_CP
                               THEN
                                  VAL_UTI_RET - VAL_ATT
                               ELSE
                                  0
                            END
                               DIFF_MESE_EX_SOFF, --MESE PRECEDENTE IN SOFFERENZA MA NON IN
                            -- SOFFERENZA NEL MESE ATTUALE
                            --              CASE
                            --                WHEN COD_STATO_RISCHIO != 'S'
                            --                     AND LAG(CP.COD_STATO_RISCHIO,
                            --                     --OFFSET LAG
                            --                     MONTHS_BETWEEN( TRUNC(TO_DATE(
                            -- PER.VAL_ANNOMESE_ULTIMO_SISBA_CP || 01, 'YYYYMMDD'), 'MM'),
                            -- TO_DATE(PER.VAL_ANNOMESE_END_LAST_Q_CONT || '01', 'YYYYMMDD')))
                            -- OVER(PARTITION BY CP.COD_ABI, CP.COD_NDG ORDER BY CP.ID_DPER) = 'S
                            -- '
                            --                     AND CP.ID_DPER = PER.VAL_ANNOMESE_SISBA_CP
                            --                THEN VAL_UTI_RET - VAL_ATT
                            --                ELSE 0
                            --              END DIFF_TRIM_EX_SOFF,                            --
                            -- FINE ULTIMO TRIMESTRE CONTABILIZZATO IN SOFFERENZA MA NON IN
                            -- SOFFERENZA NEL MESE ATTUALE
                            CASE
                               WHEN     COD_STATO_RISCHIO != 'S'
                                    AND FIRST_VALUE (
                                           CP.COD_STATO_RISCHIO)
                                        OVER (
                                           PARTITION BY CP.COD_ABI, CP.COD_NDG
                                           ORDER BY CP.ID_DPER) = 'S'
                                    AND SUBSTR (CP.ID_DPER, 1, 6) =
                                           PER.VAL_ANNOMESE_FINE_ANNO
                               THEN
                                  VAL_UTI_RET - VAL_ATT
                               ELSE
                                  0
                            END
                               DIFF_ANNO_EX_SOFF, --FINE ANNO A SOFFERENZA MA NON NEL PERIODO
                            -- ATTUALE,
                            CASE
                               WHEN     POS.FLG_IN_MESE_CONT = 1
                                    AND COD_STATO_RISCHIO IN ('S', 'I')
                                    AND SUBSTR (CP.ID_DPER, 1, 6) =
                                           PER.VAL_ANNOMESE_PENULTIMO_SISBA
                               THEN
                                  CP.VAL_UTI_RET - CP.VAL_ATT
                               ELSE
                                  0
                            END
                               DIFF_PENULTIMO_CP_SOFF_INC, --PENULTIMO MESE SISBA SOFFERENZA O
                            -- INCAGLIO (NUOVI INGRESSI)
                            CASE
                               WHEN     POS.FLG_IN_MESE_DA_CONT = 1
                                    AND COD_STATO_RISCHIO IN ('S', 'I')
                                    AND SUBSTR (CP.ID_DPER, 1, 6) =
                                           PER.VAL_ANNOMESE_PENULTIMO_SISBA
                               THEN
                                  CP.VAL_UTI_RET - CP.VAL_ATT
                               ELSE
                                  0
                            END
                               DIFF_PENULTIMO_SISBA_SOFF_INC, --PENULTIMO MESE SISBA_CP
                            -- SOFFERENZA O INCAGLIO (NUOVI INGRESSI)
                            CASE
                               WHEN     POS.FLG_IN_TRIM = 1
                                    AND COD_STATO_RISCHIO IN ('S', 'I')
                                    AND SUBSTR (CP.ID_DPER, 1, 6) =
                                           PER.VAL_ANNOMESE_END_LAST_Q_CONT
                               THEN
                                  CP.VAL_UTI_RET - CP.VAL_ATT
                               ELSE
                                  0
                            END
                               DIFF_TRIM_SISBA_CP_SOFF_INC, --FINE TRIMESTRE SISBA_CP SOFFERENZA
                            -- O INCAGLIO (NUOVI INGRESSI)
                            CASE
                               WHEN     POS.FLG_IN_MESE_DA_CONT = 1
                                    AND COD_STATO_RISCHIO IN ('S', 'I')
                                    AND SUBSTR (CP.ID_DPER, 1, 6) =
                                           PER.VAL_ANNOMESE_FINE_ANNO
                               THEN
                                  CP.VAL_UTI_RET - CP.VAL_ATT
                               ELSE
                                  0
                            END
                               DIFF_ANNO_SISBA_CP_SOFF_INC --FINE ANNO SISBA_CP SOFFERENZA O
                       -- INCAGLIO (NUOVI INGRESSI)
                       FROM T_MCRES_APP_SISBA_CP CP,
                            DIVISIONE D,
                            V_MCRES_APP_ULTIMO_ANNOMESEABI PER,
                            POSIZIONI POS
                      WHERE     SUBSTR (ID_DPER, 1, 6) >=
                                   PER.VAL_ANNOMESE_FINE_ANNO
                            --                                  IN (PER.VAL_ANNOMESE_SISBA_CP,
                            --                                    VAL_ANNOMESE_SISBA_CP_PREC,
                            --                                    PER.VAL_ANNOMESE_FINE_ANNO,
                            --
                            -- PER.VAL_ANNOMESE_END_LAST_Q_CONT,
                            --
                            -- PER.VAL_ANNOMESE_PENULTIMO_SISBA)
                            AND CP.COD_ABI = PER.COD_ABI
                            AND CP.COD_ABI = POS.COD_ABI(+)
                            AND CP.COD_NDG = POS.COD_NDG(+)
                            AND CP.COD_ABI = D.COD_ABI
                            AND CP.COD_NDG = D.COD_NDG
                            AND CP.VAL_FIRMA != 'FIRMA' --ESCLUSI I RAPPORTI FIRMA
                                                       )
           GROUP BY COD_ABI, VAL_ANNOMESE_SISBA_CP, COD_DIVISIONE) B,
          (  SELECT P.COD_ABI,
                    D.COD_DIVISIONE,
                    SUM (
                       CASE
                          WHEN P.FLG_IN_MESE_DA_CONT = 1 THEN DIFF_INI
                          ELSE 0
                       END)
                       DIFF_INI_MESE_DA_CONT,
                    SUM (
                       CASE
                          WHEN P.FLG_IN_MESE_CONT = 1 THEN DIFF_INI
                          ELSE 0
                       END)
                       DIFF_INI_MESE_CONT,
                    SUM (CASE WHEN FLG_IN_TRIM = 1 THEN DIFF_INI ELSE 0 END)
                       DIFF_INI_TRIM,
                    SUM (CASE WHEN P.FLG_IN_ANNO = 1 THEN DIFF_INI ELSE 0 END)
                       DIFF_INI_ANNO
               FROM POSIZIONI P, DIVISIONE D
              WHERE P.COD_ABI = D.COD_ABI AND P.COD_NDG = D.COD_NDG
           GROUP BY P.COD_ABI, D.COD_DIVISIONE) C,
          (  SELECT EE.COD_ABI,
                    F.VAL_ANNOMESE,
                    D.COD_DIVISIONE,
                    SUM (
                       CASE
                          WHEN SUBSTR (EE.ID_DPER, 1, 6) BETWEEN U.VAL_ANNOMESE_START_LAST_Q_CONT
                                                             AND U.VAL_ANNOMESE_END_LAST_Q_CONT
                          THEN
                             EE.VAL_PER_CE + EE.VAL_RETT_SVAL + EE.VAL_RETT_ATT
                          ELSE
                             0
                       END)
                       VAL_RETTIFICA_NETTA_TRIM,
                    SUM (
                       CASE
                          WHEN EE.ID_DPER = F.ID_DPER
                          THEN
                             EE.VAL_PER_CE + EE.VAL_RETT_SVAL + EE.VAL_RETT_ATT
                          ELSE
                             0
                       END)
                       VAL_RETTIFICA_NETTA
               FROM T_MCRES_APP_EFFETTI_ECONOMICI EE,
                    DIVISIONE D,
                    V_MCRES_ULTIMA_ACQ_FILE F,
                    V_MCRES_APP_ULTIMO_ANNOMESEABI U
              WHERE     SUBSTR (EE.ID_DPER, 1, 6) IN
                           (F.VAL_ANNOMESE,
                            U.VAL_ANNOMESE_START_LAST_Q_CONT,
                            U.VAL_ANNOMESE_START_LAST_Q_CONT + 1,
                            U.VAL_ANNOMESE_END_LAST_Q_CONT)
                    AND EE.COD_ABI = F.COD_ABI
                    AND F.COD_FLUSSO = 'EFFETTI_ECONOMICI'
                    AND EE.COD_ABI = D.COD_ABI
                    AND EE.COD_NDG = D.COD_NDG
           GROUP BY EE.COD_ABI, F.VAL_ANNOMESE, D.COD_DIVISIONE) E
    WHERE     E.COD_ABI = B.COD_ABI(+)
          AND E.COD_ABI = C.COD_ABI(+)
          AND E.COD_ABI = A.COD_ABI(+)
          AND E.COD_DIVISIONE = B.COD_DIVISIONE(+)
          AND E.COD_DIVISIONE = C.COD_DIVISIONE(+)
          AND e.COD_DIVISIONE = a.COD_DIVISIONE(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_RETTIFICHE TO MCRE_USR;
