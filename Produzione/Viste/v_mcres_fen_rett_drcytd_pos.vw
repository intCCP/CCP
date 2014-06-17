/* Formatted on 17/06/2014 18:12:44 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETT_DRCYTD_POS
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_FILIALE_AREA,
   COD_DIVISIONE,
   VAL_DRC_YTD,
   FLG_GAR_REALI,
   FLG_GAR_REALI_PERSONALI
)
AS
   WITH                                                   --- VG 08/11/2011 -1
       DIVISIONE
        AS (SELECT DISTINCT
                   CP.COD_ABI,
                   CP.COD_NDG,
                   CP.COD_SNDG,
                   CP.COD_FILIALE_AREA,
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
        AS (  SELECT DISTINCT d.COD_ABI,
                              d.COD_NDG,
                              1 val_esiste,
                              SUM (C.VAL_UTI_RET - C.VAL_ATT) val_anno_cp
                FROM T_MCRES_APP_DELIBERE D,
                     T_MCRES_APP_SISBA_CP C,
                     V_MCRES_APP_ULTIMO_ANNOMESEabi a
               WHERE     D.COD_DELIBERA = 'NS'
                     AND d.COD_ABI = c.COD_ABI
                     AND D.COD_NDG = C.COD_NDG
                     AND D.COD_ABI = A.COD_ABI
                     AND SUBSTR (C.ID_DPER, 1, 6) =
                                 SUBSTR (A.VAL_ANNOMESE_ULTIMO_SISBA_CP, 1, 4)
                               - 1
                            || 12
                     AND TO_CHAR (DTA_INSERIMENTO_DELIBERA, 'YYYY') =
                            SUBSTR (A.VAL_ANNOMESE_ULTIMO_SISBA_CP, 1, 4)
                     AND C.COD_STATO_RISCHIO = 'S'
            GROUP BY d.COD_ABI, d.COD_NDG),
        RAPPORTI
        AS (  SELECT P.COD_ABI,
                     P.COD_NDG,
                     SUM (
                          (-1 * R.VAL_IMP_GBV_INIZIALE)
                        - (-1 * R.VAL_IMP_NBV_INIZIALE))
                        val_rapporti_iniziale,
                     SUM (val_anno_cp) val_anno_cp
                FROM T_MCRES_APP_RAPPORTI R, POSIZIONI P
               WHERE P.COD_ABI = R.COD_ABI AND P.COD_NDG = R.COD_NDG
            GROUP BY P.COD_ABI, P.COD_NDG),
        RV_YTD
        AS (  SELECT E.COD_ABI,
                     E.COD_NDG,
                     SUM (E.VAL_rvytd) VAL_RETTIFICA_anno,
                     NVL (VAL_ESISTE, 0) FLG_GRUPPO_A,
                     E.FLG_GAR_REALI,
                     E.FLG_GAR_REALI_PERSONALI
                FROM v_mcres_fen_rett_rvytd_pos E, POSIZIONI p
               WHERE E.COD_ABI = P.COD_ABI(+) AND E.COD_NDG = P.COD_NDG(+)
            GROUP BY E.COD_ABI,
                     E.COD_NDG,
                     NVL (VAL_ESISTE, 0),
                     E.FLG_GAR_REALI,
                     E.FLG_GAR_REALI_PERSONALI)
     SELECT E.COD_ABI,
            E.COD_NDG,
            COD_SNDG,
            cod_filiale_area,
            NVL (COD_DIVISIONE, 3) COD_DIVISIONE,
            SUM (
               CASE
                  WHEN flg_gruppo_a = 1
                  THEN
                       NVL (E.VAL_RETTIFICA_anno, 0)
                     - NVL (R.VAL_RAPPORTI_INIZIALE, 0)
                     - NVL (r.val_anno_cp, 0)
                  ELSE
                     NVL (E.VAL_RETTIFICA_ANNO, 0)
               END)
               VAL_DRC_ytd,
            FLG_GAR_REALI,
            FLG_GAR_REALI_PERSONALI
       FROM RAPPORTI R, RV_YTD E, DIVISIONE d
      WHERE     e.COD_ABI = r.COD_ABI(+)
            AND E.COD_NDG = R.COD_NDG(+)
            AND e.COD_ABI = d.COD_ABI(+)
            AND E.COD_NDG = D.COD_NDG(+)
   GROUP BY E.COD_ABI,
            E.COD_NDG,
            NVL (COD_DIVISIONE, 3),
            COD_SNDG,
            cod_filiale_area,
            FLG_GAR_REALI,
            FLG_GAR_REALI_PERSONALI;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_RETT_DRCYTD_POS TO MCRE_USR;
