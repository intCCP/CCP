/* Formatted on 21/07/2014 18:41:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_CARICHI_LAV
(
   COD_ABI,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   DESC_NOME_GESTORE,
   VAL_NUM_PRATICHE,
   VAL_GARANTITO_GBV,
   VAL_GARANTITO,
   VAL_GBV_MEDIO,
   VAL_NBV_MEDIO
)
AS
     SELECT COD_ABI,
            COD_UO_PRATICA,
            COD_MATR_PRATICA,
            MAX (desc_nome_gestore) desc_nome_gestore,
            COUNT (COD_PRATICA) VAL_NUM_PRATICHE,
            ROUND (SUM (VAL_GARANTITO / VAL_imp_GBV), 2) VAL_GARANTITO_GBV,
            SUM (VAL_GARANTITO) VAL_GARANTITO,
            SUM (VAL_GBV_MEDIO) VAL_GBV_MEDIO,
            SUM (VAL_NBV_MEDIO) VAL_NBV_MEDIO
       FROM (SELECT P.COD_ABI,
                    P.COD_NDG,
                    P.COD_UO_PRATICA,
                    P.COD_MATR_PRATICA,
                    P.COD_PRATICA,
                    U.COGNOME || ' ' || U.NOME desc_nome_gestore,
                    (SELECT SUM (
                                 S.VAL_IMP_GARANZIA_IPOTECARIA
                               + S.VAL_IMP_GARANZIE_ALTRE
                               + S.VAL_IMP_GARANZIE_ALTRI
                               + S.VAL_IMP_GARANZIE_PERSONALI
                               + S.VAL_IMP_GARANZIE_PIGNORATIZIE)
                               VAL_GARANTITO
                       FROM T_MCRES_APP_SISBA S
                      WHERE     S.ID_DPER =
                                   (SELECT MAX (TO_CHAR (ID_DPER, 'YYYYMMDD'))
                                              ID_DPER
                                      FROM mcre_own.T_MCRES_WRK_last_ACQUISIZIONE A
                                     WHERE     A.COD_FLUSSO = 'SISBA'
                                           AND COD_STATO IN
                                                  ('CARICATO', 'CARICATO_APP'))
                            AND S.COD_STATO_RISCHIO = 'S'
                            AND S.COD_ABI = P.COD_ABI
                            AND S.COD_NDG = P.COD_NDG)
                       VAL_GARANTITO,
                    (SELECT ROUND (
                                 SUM (-1 * Z.VAL_IMP_GBV)
                               / DECODE (COUNT (DISTINCT Z.COD_RAPPORTO),
                                         0, 1,
                                         COUNT (DISTINCT Z.COD_RAPPORTO)),
                               2)
                               VAL_GBV_MEDIO
                       FROM T_MCRES_APP_RAPPORTI Z
                      WHERE     1 = 1
                            AND Z.COD_ABI = P.COD_ABI
                            AND Z.COD_NDG = P.COD_NDG)
                       VAL_GBV_MEDIO,
                    (SELECT ROUND (
                                 SUM (-1 * Z.VAL_IMP_NBV)
                               / DECODE (COUNT (DISTINCT Z.COD_RAPPORTO),
                                         0, 1,
                                         COUNT (DISTINCT Z.COD_RAPPORTO)),
                               2)
                               VAL_NBV_MEDIO
                       FROM T_MCRES_APP_RAPPORTI Z
                      WHERE     1 = 1
                            AND Z.COD_ABI = P.COD_ABI
                            AND Z.COD_NDG = P.COD_NDG)
                       VAL_NBV_MEDIO,
                    (SELECT DECODE (SUM (-1 * Z.VAL_IMP_GBV),
                                    0, 1,
                                    SUM (-1 * Z.VAL_IMP_GBV))
                               VAL_imp_GBV
                       FROM T_MCRES_APP_RAPPORTI Z
                      WHERE     1 = 1
                            AND Z.COD_ABI = P.COD_ABI
                            AND Z.COD_NDG = P.COD_NDG)
                       VAL_imp_GBV
               FROM T_MCRES_APP_PRATICHE P,
                    T_MCRES_APP_POSIZIONI Z,
                    T_MCRES_APP_UTENTI U
              WHERE     1 = 1
                    AND P.COD_ABI = Z.COD_ABI
                    AND P.COD_NDG = Z.COD_NDG
                    AND P.FLG_ATTIVA = 1
                    AND Z.FLG_ATTIVA = 1
                    AND P.COD_MATR_PRATICA IS NOT NULL
                    AND P.COD_MATR_PRATICA = U.COD_MATRICOLA(+)) A
   GROUP BY COD_ABI, COD_UO_PRATICA, COD_MATR_PRATICA;
