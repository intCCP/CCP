/* Formatted on 21/07/2014 18:43:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_INDICI_COPERTURA
(
   COD_ABI,
   ID_DPER,
   VAL_ANNOMESE,
   VAL_GESTIONE,
   FLG_GAR_REALI_PERSONALI,
   FLG_GAR_REALI,
   VAL_NBV,
   VAL_GBV
)
AS
     SELECT COD_ABI,
            id_dper,
            VAL_ANNOMESE,
            VAL_GESTIONE,
            0 flg_gar_reali_personali,
            0 flg_gar_reali,
            SUM (VAL_NBV) VAL_NBV,
            SUM (Val_Gbv) Val_Gbv
       FROM (  SELECT c.COD_ABI,
                      c.id_dper,
                      COD_SNDG,
                      SUBSTR (c.id_dper, 1, 6) val_annomese,
                      CASE
                         WHEN O.COD_LIVELLO IN ('PL', 'RC') THEN 'I'
                         ELSE 'A'
                      END
                         val_gestione,
                      SUM (VAL_ATT) VAL_NBV,
                      SUM (VAL_UTI_RET) VAL_GBV,
                      SUM (S.VAL_IMP_GARANZIE_PERSONALI)
                         VAL_IMP_GARANZIE_PERSONALI,
                      SUM (S.VAL_IMP_GARANZIA_IPOTECARIA)
                         VAL_IMP_GARANZIA_IPOTECARIA,
                      SUM (s.val_imp_garanzie_pignoratizie)
                         val_imp_garanzie_pignoratizie
                 FROM T_MCRES_APP_SISBA_CP C,
                      T_MCRES_APP_SISBA s,
                      T_MCRE0_APP_STRUTTURA_ORG O
                WHERE     C.COD_ABI = S.COD_ABI(+)
                      AND C.COD_NDG = S.COD_NDG(+)
                      AND C.ID_DPER = S.ID_DPER(+)
                      AND C.COD_RAPPORTO = S.COD_RAPPORTO_SISBA(+)
                      AND C.COD_SPORTELLO = S.COD_FILIALE_RAPPORTO(+)
                      AND C.COD_FILIALE_AREA = O.COD_STRUTTURA_COMPETENTE(+)
                      AND C.COD_ABI = O.COD_ABI_ISTITUTO(+)
                      AND C.COD_STATO_RISCHIO = 'S'
             GROUP BY c.COD_ABI,
                      c.id_dper,
                      COD_SNDG,
                      SUBSTR (c.id_dper, 1, 6),
                      CASE
                         WHEN O.COD_LIVELLO IN ('PL', 'RC') THEN 'I'
                         ELSE 'A'
                      END) TMP
   GROUP BY COD_ABI,
            id_dper,
            VAL_ANNOMESE,
            VAL_GESTIONE
   UNION ALL
     SELECT COD_ABI,
            id_dper,
            VAL_ANNOMESE,
            VAL_GESTIONE,
            1 flg_gar_reali_personali,
            1 flg_gar_reali,
            SUM (VAL_NBV) VAL_NBV,
            SUM (Val_Gbv) Val_Gbv
       FROM (  SELECT c.COD_ABI,
                      c.id_dper,
                      COD_SNDG,
                      SUBSTR (c.id_dper, 1, 6) val_annomese,
                      CASE
                         WHEN O.COD_LIVELLO IN ('PL', 'RC') THEN 'I'
                         ELSE 'A'
                      END
                         val_gestione,
                      SUM (VAL_ATT) VAL_NBV,
                      SUM (VAL_UTI_RET) VAL_GBV,
                      SUM (S.VAL_IMP_GARANZIE_PERSONALI)
                         VAL_IMP_GARANZIE_PERSONALI,
                      SUM (S.VAL_IMP_GARANZIA_IPOTECARIA)
                         VAL_IMP_GARANZIA_IPOTECARIA,
                      SUM (s.val_imp_garanzie_pignoratizie)
                         val_imp_garanzie_pignoratizie
                 FROM T_MCRES_APP_SISBA_CP C,
                      T_MCRES_APP_SISBA s,
                      T_MCRE0_APP_STRUTTURA_ORG O
                WHERE     C.COD_ABI = S.COD_ABI(+)
                      AND C.COD_NDG = S.COD_NDG(+)
                      AND C.ID_DPER = S.ID_DPER(+)
                      AND C.COD_RAPPORTO = S.COD_RAPPORTO_SISBA(+)
                      AND C.COD_SPORTELLO = S.COD_FILIALE_RAPPORTO(+)
                      AND C.COD_FILIALE_AREA = O.COD_STRUTTURA_COMPETENTE(+)
                      AND C.COD_ABI = O.COD_ABI_ISTITUTO(+)
             GROUP BY c.COD_ABI,
                      c.id_dper,
                      COD_SNDG,
                      SUBSTR (c.id_dper, 1, 6),
                      CASE
                         WHEN O.COD_LIVELLO IN ('PL', 'RC') THEN 'I'
                         ELSE 'A'
                      END) TMP
      WHERE    NVL (val_imp_garanzie_personali, 0) > 0
            OR NVL (val_imp_garanzia_ipotecaria, 0) > 0
            OR NVL (val_imp_garanzie_pignoratizie, 0) > 0
   GROUP BY COD_ABI,
            id_dper,
            VAL_ANNOMESE,
            VAL_GESTIONE
   UNION ALL
     SELECT COD_ABI,
            id_dper,
            VAL_ANNOMESE,
            VAL_GESTIONE,
            0 flg_gar_reali_personali,
            1 flg_gar_reali,
            SUM (VAL_NBV) VAL_NBV,
            SUM (Val_Gbv) Val_Gbv
       FROM (  SELECT c.COD_ABI,
                      c.id_dper,
                      COD_SNDG,
                      SUBSTR (c.id_dper, 1, 6) val_annomese,
                      CASE
                         WHEN O.COD_LIVELLO IN ('PL', 'RC') THEN 'I'
                         ELSE 'A'
                      END
                         val_gestione,
                      SUM (VAL_ATT) VAL_NBV,
                      SUM (VAL_UTI_RET) VAL_GBV,
                      SUM (S.VAL_IMP_GARANZIE_PERSONALI)
                         VAL_IMP_GARANZIE_PERSONALI,
                      SUM (S.VAL_IMP_GARANZIA_IPOTECARIA)
                         VAL_IMP_GARANZIA_IPOTECARIA,
                      SUM (s.val_imp_garanzie_pignoratizie)
                         val_imp_garanzie_pignoratizie
                 FROM T_MCRES_APP_SISBA_CP C,
                      T_MCRES_APP_SISBA s,
                      T_MCRE0_APP_STRUTTURA_ORG O
                WHERE     C.COD_ABI = S.COD_ABI(+)
                      AND C.COD_NDG = S.COD_NDG(+)
                      AND C.ID_DPER = S.ID_DPER(+)
                      AND C.COD_RAPPORTO = S.COD_RAPPORTO_SISBA(+)
                      AND C.COD_SPORTELLO = S.COD_FILIALE_RAPPORTO(+)
                      AND C.COD_FILIALE_AREA = O.COD_STRUTTURA_COMPETENTE(+)
                      AND C.COD_ABI = O.COD_ABI_ISTITUTO(+)
                      AND C.COD_STATO_RISCHIO = 'S'
             GROUP BY c.COD_ABI,
                      c.id_dper,
                      COD_SNDG,
                      SUBSTR (c.id_dper, 1, 6),
                      CASE
                         WHEN O.COD_LIVELLO IN ('PL', 'RC') THEN 'I'
                         ELSE 'A'
                      END) TMP
      WHERE    NVL (val_imp_garanzie_pignoratizie, 0) > 0
            OR NVL (val_imp_garanzia_ipotecaria, 0) > 0
   GROUP BY COD_ABI,
            id_dper,
            VAL_ANNOMESE,
            VAL_GESTIONE;
