/* Formatted on 17/06/2014 18:12:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETT_POS
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_FILIALE_AREA,
   VAL_ANNOMESE,
   FLG_GAR_REALI_PERSONALI,
   FLG_GAR_REALI,
   VAL_RETTIFICA_MESE,
   VAL_EFF_VALUTAZIONI,
   VAL_EFF_TRANSAZIONI
)
AS
   WITH sisba_cp
        AS (  SELECT S.COD_ABI,
                     S.COD_NDG,
                     S.COD_SNDG,
                     S.COD_FILIALE_AREA,
                     id_dper
                FROM T_MCRES_APP_SISBA_CP S
               WHERE s.COD_STATO_RISCHIO = 'S'
            GROUP BY S.COD_ABI,
                     S.COD_NDG,
                     S.COD_SNDG,
                     S.COD_FILIALE_AREA,
                     id_dper),
        sisba
        AS (  SELECT S.COD_ABI,
                     s.cod_ndg,
                     id_dper,
                     SUM (S.VAL_IMP_GARANZIE_PERSONALI)
                        VAL_IMP_GARANZIE_PERSONALI,
                     SUM (S.VAL_IMP_GARANZIA_IPOTECARIA)
                        VAL_IMP_GARANZIA_IPOTECARIA,
                     SUM (s.val_imp_garanzie_pignoratizie)
                        val_imp_garanzie_pignoratizie
                FROM T_MCRES_APP_SISBA S
            GROUP BY COD_ABI, s.cod_ndg, id_dper),
        effe_eco
        AS (  SELECT EE.COD_ABI,
                     EE.COD_NDG,
                     SISBA_CP.COD_SNDG,
                     SISBA_CP.COD_FILIALE_AREA,
                     SUBSTR (EE.ID_DPER, 1, 6) VAL_ANNOMESE,
                     SUM (EE.VAL_PER_CE + EE.VAL_RETT_SVAL + EE.VAL_RETT_ATT)
                        VAL_RETTIFICA_MESE,
                     SUM (
                          (EE.VAL_RETT_SVAL - VAL_RIP_SVAL)
                        + (VAL_RETT_ATT - VAL_RIP_ATT))
                        VAL_EFF_VALUTAZIONI,
                     SUM (
                          EE.VAL_PER_CE
                        - VAL_RIP_MORA
                        - VAL_QUOTA_SVAL
                        - VAL_QUOTA_ATT)
                        VAL_EFF_transazioni,
                     SUM (VAL_IMP_GARANZIE_PERSONALI)
                        VAL_IMP_GARANZIE_PERSONALI,
                     SUM (VAL_IMP_GARANZIA_IPOTECARIA)
                        VAL_IMP_GARANZIA_IPOTECARIA,
                     SUM (val_imp_garanzie_pignoratizie)
                        val_imp_garanzie_pignoratizie
                FROM T_MCRES_APP_EFFETTI_ECONOMICI EE, SISBA, sisba_cp
               WHERE     EE.COD_ABI = SISBA.COD_ABI(+)
                     AND EE.COD_NDG = SISBA.COD_NDG(+)
                     AND EE.ID_DPER = SISBA.ID_DPER(+)
                     AND EE.COD_ABI = sisba_cp.COD_ABI(+)
                     AND EE.COD_NDG = sisba_cp.COD_NDG(+)
                     AND EE.ID_DPER = sisba_cp.id_dper(+)
            GROUP BY EE.COD_ABI,
                     ee.cod_ndg,
                     SISBA_CP.COD_SNDG,
                     SISBA_CP.COD_FILIALE_AREA,
                     SUBSTR (ee.id_dper, 1, 6))
     SELECT COD_ABI,
            COD_NDG,
            COD_SNDG,
            COD_FILIALE_AREA,
            val_annomese,
            0 flg_gar_reali_personali,
            0 FLG_GAR_REALI,
            SUM (VAL_RETTIFICA_MESE) VAL_RETTIFICA_MESE,
            SUM (VAL_EFF_VALUTAZIONI) VAL_EFF_VALUTAZIONI,
            SUM (VAL_EFF_transazioni) VAL_EFF_transazioni
       FROM effe_eco
   GROUP BY COD_ABI,
            cod_ndg,
            COD_SNDG,
            COD_FILIALE_AREA,
            val_annomese
   UNION ALL
     SELECT COD_ABI,
            cod_ndg,
            COD_SNDG,
            COD_FILIALE_AREA,
            val_annomese,
            1 flg_gar_reali_personali,
            1 flg_gar_reali,
            SUM (VAL_RETTIFICA_MESE) VAL_RETTIFICA_MESE,
            SUM (VAL_EFF_VALUTAZIONI) VAL_EFF_VALUTAZIONI,
            SUM (VAL_EFF_transazioni) VAL_EFF_transazioni
       FROM effe_eco
      WHERE    NVL (val_imp_garanzie_personali, 0) > 0
            OR NVL (val_imp_garanzia_ipotecaria, 0) > 0
            OR NVL (val_imp_garanzie_pignoratizie, 0) > 0
   GROUP BY COD_ABI,
            cod_ndg,
            COD_SNDG,
            COD_FILIALE_AREA,
            val_annomese
   UNION ALL
     SELECT COD_ABI,
            cod_ndg,
            COD_SNDG,
            COD_FILIALE_AREA,
            val_annomese,
            0 flg_gar_reali_personali,
            1 flg_gar_reali,
            SUM (VAL_RETTIFICA_MESE) VAL_RETTIFICA_MESE,
            SUM (VAL_EFF_VALUTAZIONI) VAL_EFF_VALUTAZIONI,
            SUM (VAL_EFF_transazioni) VAL_EFF_transazioni
       FROM effe_eco
      WHERE    NVL (val_imp_garanzie_pignoratizie, 0) > 0
            OR NVL (val_imp_garanzia_ipotecaria, 0) > 0
   GROUP BY COD_ABI,
            COD_NDG,
            COD_SNDG,
            COD_FILIALE_AREA,
            val_annomese;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_RETT_POS TO MCRE_USR;
