/* Formatted on 17/06/2014 18:12:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETT_UCPCONT_POS
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_FILIALE_AREA,
   FLG_GAR_REALI_PERSONALI,
   FLG_GAR_REALI,
   VAL_DRC_ULTIMO_MESE_CONT
)
AS
   WITH                                                   --- VG 08/11/2011 -1
       sisba_cp
        AS (  SELECT S.COD_ABI,
                     S.COD_NDG,
                     S.COD_SNDG,
                     S.COD_FILIALE_AREA,
                     ID_DPER,
                     a.VAL_ANNOMESE_ULTIMO_SISBA_CP
                FROM T_MCRES_APP_SISBA_CP S, V_MCRES_APP_ULTIMO_ANNOMESEABI A
               WHERE     s.COD_ABI = A.COD_ABI
                     AND SUBSTR (S.ID_DPER, 1, 6) =
                            A.VAL_ANNOMESE_ULTIMO_SISBA_CP
                     AND s.COD_STATO_RISCHIO = 'S'
            GROUP BY S.COD_ABI,
                     S.COD_NDG,
                     S.COD_SNDG,
                     S.COD_FILIALE_AREA,
                     s.ID_DPER,
                     a.VAL_ANNOMESE_ULTIMO_SISBA_CP),
        sisba
        AS (  SELECT S.COD_ABI,
                     S.COD_NDG,
                     s.id_dper,
                     SUM (S.VAL_IMP_GARANZIE_PERSONALI)
                        VAL_IMP_GARANZIE_PERSONALI,
                     SUM (S.VAL_IMP_GARANZIA_IPOTECARIA)
                        VAL_IMP_GARANZIA_IPOTECARIA,
                     SUM (s.val_imp_garanzie_pignoratizie)
                        val_imp_garanzie_pignoratizie
                FROM T_MCRES_APP_SISBA S, V_MCRES_APP_ULTIMO_ANNOMESEABI A
               WHERE SUBSTR (s.ID_DPER, 1, 6) = A.VAL_ANNOMESE_ULTIMO_SISBA_CP
            GROUP BY s.COD_ABI, S.COD_NDG, s.ID_DPER),
        POSIZIONI
        AS (SELECT DISTINCT d.COD_ABI, D.COD_NDG, 1 val_esiste
              FROM T_MCRES_APP_DELIBERE D, sisba_cp C
             WHERE     D.COD_DELIBERA = 'NS'
                   AND d.COD_ABI = c.COD_ABI
                   AND D.COD_NDG = C.COD_NDG
                   AND TO_CHAR (DTA_INSERIMENTO_DELIBERA, 'YYYYMM') =
                          c.VAL_ANNOMESE_ULTIMO_SISBA_CP),
        EFF_ECO
        AS (  SELECT E.COD_ABI,
                     E.COD_NDG,
                     SISBA_CP.COD_SNDG,
                     sisba_cp.cod_filiale_area,
                     SUM (E.VAL_PER_CE + E.VAL_RETT_SVAL + E.VAL_RETT_ATT)
                        VAL_RETTIFICA_MESE,
                     NVL (val_esiste, 0) flg_gruppo_a
                FROM T_MCRES_APP_EFFETTI_ECONOMICI E, POSIZIONI P, SISBA_CP
               WHERE     E.COD_ABI = P.COD_ABI(+)
                     AND E.COD_NDG = P.COD_NDG(+)
                     AND E.COD_ABI = SISBA_CP.COD_ABI
                     AND E.COD_NDG = SISBA_CP.COD_NDG
                     AND SUBSTR (E.ID_DPER, 1, 6) =
                            SISBA_CP.VAL_ANNOMESE_ULTIMO_SISBA_CP
            GROUP BY e.cod_abi,
                     e.cod_ndg,
                     SISBA_CP.COD_SNDG,
                     sisba_cp.cod_filiale_area,
                     NVL (val_esiste, 0)),
        RAPPORTI
        AS (  SELECT P.COD_ABI,
                     P.COD_NDG,
                     SUM (
                          (-1 * R.VAL_IMP_GBV_INIZIALE)
                        - (-1 * R.VAL_IMP_NBV_INIZIALE))
                        val_rapporti_iniziale
                FROM T_MCRES_APP_RAPPORTI R, POSIZIONI P
               WHERE P.COD_ABI = R.COD_ABI AND P.COD_NDG = R.COD_NDG
            GROUP BY P.COD_ABI, P.COD_NDG),
        PENULTIMO_SISBA_CP
        AS (  SELECT c.COD_ABI,
                     c.COD_NDG,
                     SUM (C.VAL_UTI_RET - C.VAL_ATT) val_penultimo_cp
                FROM T_MCRES_APP_SISBA_CP C, V_MCRES_APP_ULTIMO_ANNOMESEabi A
               WHERE     SUBSTR (C.ID_DPER, 1, 6) = A.VAL_ANNOMESE_PENULTIMO_CP
                     AND C.COD_STATO_RISCHIO IN ('S', 'I')
                     AND C.VAL_FIRMA != 'FIRMA'
            GROUP BY c.COD_ABI, C.COD_NDG),
        tot
        AS (  SELECT e.COD_ABI,
                     e.COD_NDG,
                     e.COD_SNDG,
                     e.cod_filiale_area,
                     SUM (
                        CASE
                           WHEN flg_gruppo_a = 1
                           THEN
                                NVL (E.VAL_RETTIFICA_MESE, 0)
                              - NVL (R.VAL_RAPPORTI_INIZIALE, 0)
                              - NVL (C.VAL_PENULTIMO_CP, 0)
                           ELSE
                              NVL (E.VAL_RETTIFICA_MESE, 0)
                        END)
                        VAL_DRC_ULTIMO_MESE_CONT,
                     SUM (S.VAL_IMP_GARANZIE_PERSONALI)
                        VAL_IMP_GARANZIE_PERSONALI,
                     SUM (S.VAL_IMP_GARANZIA_IPOTECARIA)
                        VAL_IMP_GARANZIA_IPOTECARIA,
                     SUM (s.val_imp_garanzie_pignoratizie)
                        val_imp_garanzie_pignoratizie
                FROM RAPPORTI R,
                     PENULTIMO_SISBA_CP C,
                     EFF_ECO E,
                     sisba s
               WHERE     e.COD_ABI = r.COD_ABI(+)
                     AND e.cod_ndg = r.cod_ndg(+)
                     AND e.COD_ABI = C.COD_ABI(+)
                     AND E.COD_NDG = C.COD_NDG(+)
                     AND E.COD_ABI = s.COD_ABI(+)
                     AND e.COD_NDG = s.COD_NDG(+)
            GROUP BY E.COD_ABI,
                     E.COD_NDG,
                     E.COD_SNDG,
                     e.cod_filiale_area)
     SELECT COD_ABI,
            cod_ndg,
            COD_SNDG,
            cod_filiale_area,
            0 flg_gar_reali_personali,
            0 flg_gar_reali,
            SUM (VAL_DRC_ULTIMO_MESE_CONT) VAL_DRC_ULTIMO_MESE_CONT
       FROM tot
   GROUP BY COD_ABI,
            cod_ndg,
            COD_SNDG,
            cod_filiale_area
   UNION ALL
     SELECT COD_ABI,
            cod_ndg,
            COD_SNDG,
            cod_filiale_area,
            1 flg_gar_reali_personali,
            1 flg_gar_reali,
            SUM (VAL_DRC_ULTIMO_MESE_CONT) VAL_DRC_ULTIMO_MESE_CONT
       FROM tot
      WHERE    NVL (val_imp_garanzie_personali, 0) > 0
            OR NVL (val_imp_garanzia_ipotecaria, 0) > 0
            OR NVL (val_imp_garanzie_pignoratizie, 0) > 0
   GROUP BY COD_ABI,
            cod_ndg,
            COD_SNDG,
            cod_filiale_area
   UNION ALL
     SELECT COD_ABI,
            cod_ndg,
            COD_SNDG,
            cod_filiale_area,
            0 flg_gar_reali_personali,
            1 flg_gar_reali,
            SUM (VAL_DRC_ULTIMO_MESE_CONT) VAL_DRC_ULTIMO_MESE_CONT
       FROM tot
      WHERE    NVL (val_imp_garanzie_pignoratizie, 0) > 0
            OR NVL (val_imp_garanzia_ipotecaria, 0) > 0
   GROUP BY COD_ABI,
            COD_NDG,
            COD_SNDG,
            cod_filiale_area;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_RETT_UCPCONT_POS TO MCRE_USR;
