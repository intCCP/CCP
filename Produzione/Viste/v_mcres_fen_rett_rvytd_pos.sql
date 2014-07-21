/* Formatted on 17/06/2014 18:12:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETT_RVYTD_POS
(
   COD_ABI,
   COD_NDG,
   VAL_RVYTD,
   COD_DIVISIONE,
   FLG_GAR_REALI_PERSONALI,
   FLG_GAR_REALI
)
AS
   WITH DIVISIONE
        AS (SELECT DISTINCT
                   CP.COD_ABI,
                   CP.COD_NDG,
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
        SISBA
        AS (  SELECT S.COD_ABI,
                     S.COD_NDG,
                     SUM (
                        CASE
                           WHEN S.COD_STATO_RISCHIO = 'S'
                           THEN
                                S.VAL_IMP_UTI_RETTIFICATO
                              - S.VAL_IMP_NPV_STIMA_RECUPERO
                           ELSE
                              0
                        END)
                        VAL_SISBA_ATTUALE,
                     SUM (
                        CASE
                           WHEN S.COD_STATO_RISCHIO = 'I'
                           THEN
                                S.VAL_IMP_UTI_RETTIFICATO
                              - S.VAL_IMP_NPV_STIMA_RECUPERO
                           ELSE
                              0
                        END)
                        VAL_SISBA_IN_ATTUALE,
                     SUM (S.VAL_IMP_GARANZIE_PERSONALI)
                        VAL_IMP_GARANZIE_PERSONALI,
                     SUM (S.VAL_IMP_GARANZIA_IPOTECARIA)
                        VAL_IMP_GARANZIA_IPOTECARIA,
                     SUM (s.val_imp_garanzie_pignoratizie)
                        val_imp_garanzie_pignoratizie
                FROM T_MCRES_APP_SISBA S, V_MCRES_APP_ULTIMO_ANNOMESEABI A
               WHERE     S.COD_ABI = A.COD_ABI
                     AND SUBSTR (S.ID_DPER, 1, 6) = A.VAL_ANNOMESE_ULTIMO_SISBA
                     AND S.COD_STATO_RISCHIO IN ('S', 'I')
            GROUP BY S.COD_ABI, S.COD_NDG),
        SISBA_CP
        AS (  SELECT S.COD_ABI,
                     S.COD_NDG,
                     SUM (S.VAL_UTI_RET - S.VAL_ATT) VAL_SISBA_CP_fine_anno,
                     DECODE (p.COD_STATO_RISCHIO, 'S', 0, 1) flg_gruppo_b
                FROM T_MCRES_APP_SISBA_CP S,
                     T_MCRES_APP_posizioni p,
                     V_MCRES_APP_ULTIMO_ANNOMESEABI A
               WHERE     S.COD_ABI = A.COD_ABI
                     AND SUBSTR (s.ID_DPER, 1, 6) =
                               (SUBSTR (VAL_ANNOMESE_ULTIMO_SISBA, 1, 4) - 1)
                            || '12'
                     AND S.COD_STATO_RISCHIO IN ('S', 'I')
                     AND S.COD_ABI = P.COD_ABI
                     AND S.COD_NDG = P.COD_NDG
            GROUP BY S.COD_ABI,
                     S.COD_NDG,
                     DECODE (P.COD_STATO_RISCHIO, 'S', 0, 1)),
        MOVIMENTI
        AS (  SELECT r.COD_ABI,
                     r.COD_NDG,
                     SUM (s.VAL_IMP_MOVIMENTO) VAL_movimenti
                FROM T_MCRES_APP_MOVIMENTI S,
                     T_MCRES_APP_RAPPORTI R,
                     V_MCRES_APP_ULTIMO_ANNOMESEABI A
               WHERE     s.COD_ABI = R.COD_ABI
                     AND s.COD_RAPPORTO = r.COD_RAPPORTO
                     AND S.COD_ABI = A.COD_ABI
                     AND TO_CHAR (S.DTA_CONTABILE_MOVIMENTO, 'YYYYMM') =
                            A.VAL_ANNOMESE_ULTIMO_SISBA
                     AND s.COD_CAUSALE_MOVIMENTO IN
                            ('006', '0I5', '0I6', '0I7')
            GROUP BY R.COD_ABI, R.COD_NDG),
        TOT_GRUPPI_A_B
        AS (  SELECT SISBA.COD_ABI,
                     sisba.cod_ndg,
                     NVL (COD_DIVISIONE, 3) COD_DIVISIONE,
                     SUM (
                        CASE
                           WHEN FLG_GRUPPO_B = 0
                           THEN
                                NVL (VAL_SISBA_ATTUALE, 0)
                              - NVL (VAL_SISBA_CP_fine_anno, 0)
                              + NVL (VAL_MOVIMENTI, 0)
                           ELSE
                              0
                        END)
                        VAL_DRC_A,
                     SUM (
                        CASE
                           WHEN FLG_GRUPPO_B = 1
                           THEN
                                NVL (VAL_SISBA_CP_fine_anno, 0)
                              - VAL_SISBA_IN_ATTUALE
                              + NVL (VAL_MOVIMENTI, 0)
                           ELSE
                              0
                        END)
                        VAL_DRC_B,
                     SUM (VAL_IMP_GARANZIE_PERSONALI)
                        VAL_IMP_GARANZIE_PERSONALI,
                     SUM (VAL_IMP_GARANZIA_IPOTECARIA)
                        VAL_IMP_GARANZIA_IPOTECARIA,
                     SUM (val_imp_garanzie_pignoratizie)
                        val_imp_garanzie_pignoratizie
                FROM SISBA,
                     SISBA_CP,
                     MOVIMENTI,
                     DIVISIONE
               WHERE     SISBA.COD_ABI = SISBA_CP.COD_ABI(+)
                     AND SISBA.COD_NDG = SISBA_CP.COD_NDG(+)
                     AND SISBA.COD_ABI = MOVIMENTI.COD_ABI(+)
                     AND SISBA.COD_NDG = MOVIMENTI.COD_NDG(+)
                     AND SISBA.COD_ABI = DIVISIONE.COD_ABI(+)
                     AND SISBA.COD_NDG = DIVISIONE.COD_NDG(+)
            GROUP BY SISBA.COD_ABI, SISBA.COD_NDG, NVL (COD_DIVISIONE, 3))
     SELECT COD_ABI,
            COD_NDG,
            SUM (VAL_DRC_A - VAL_DRC_b) VAL_rvytd,
            COD_DIVISIONE,
            0 FLG_GAR_REALI_PERSONALI,
            0 flg_gar_reali
       FROM TOT_GRUPPI_A_B
   GROUP BY COD_ABI, COD_NDG, COD_DIVISIONE
   UNION
     SELECT COD_ABI,
            COD_NDG,
            SUM (VAL_DRC_A - VAL_DRC_b) VAL_rvytd,
            COD_DIVISIONE,
            1 FLG_GAR_REALI_PERSONALI,
            1 flg_gar_reali
       FROM TOT_GRUPPI_A_B
      WHERE    NVL (val_imp_garanzie_personali, 0) > 0
            OR NVL (VAL_IMP_GARANZIA_IPOTECARIA, 0) > 0
            OR NVL (VAL_IMP_GARANZIE_PIGNORATIZIE, 0) > 0
   GROUP BY COD_ABI, COD_NDG, COD_DIVISIONE
   UNION
     SELECT COD_ABI,
            COD_NDG,
            SUM (VAL_DRC_A - VAL_DRC_b) VAL_rvytd,
            COD_DIVISIONE,
            0 FLG_GAR_REALI_PERSONALI,
            1 flg_gar_reali
       FROM TOT_GRUPPI_A_B
      WHERE    NVL (VAL_IMP_GARANZIE_PIGNORATIZIE, 0) > 0
            OR NVL (val_imp_garanzia_ipotecaria, 0) > 0
   GROUP BY COD_ABI, COD_NDG, COD_DIVISIONE;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_RETT_RVYTD_POS TO MCRE_USR;
