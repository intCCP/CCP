/* Formatted on 21/07/2014 18:41:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_DEL_ENTE_CENTR_OLD
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COD_PROTOCOLLO_DELIBERA,
   DTA_INSERIMENTO_DELIBERA,
   COD_DELIBERA,
   DESC_DELIBERA,
   COD_STATO_DELIBERA,
   DESC_STATO_DELIBERA,
   COD_ORGANO_DELIBERANTE,
   COD_MATR_INSERENTE,
   COD_FILIALE_PRINCIPALE,
   DESC_ORGANO_DELIBERANTE,
   VAL_CATEGORIA,
   DESC_RESPONSABILE
)
AS
   SELECT a."COD_ABI",
          a."DESC_ISTITUTO",
          a."COD_NDG",
          a."COD_SNDG",
          a."DESC_NOME_CONTROPARTE",
          a."COD_UO_PRATICA",
          a."COD_MATR_PRATICA",
          a."COD_PROTOCOLLO_DELIBERA",
          a."DTA_INSERIMENTO_DELIBERA",
          a."COD_DELIBERA",
          a."DESC_DELIBERA",
          a."COD_STATO_DELIBERA",
          a."DESC_STATO_DELIBERA",
          a."COD_ORGANO_DELIBERANTE",
          a."COD_MATR_INSERENTE",
          a."COD_FILIALE_PRINCIPALE",
          OD.DESC_ORGANO_DELIBERANTE,
          OD.VAL_CATEGORIA,
          OD.DESC_RESPONSABILE
     FROM (SELECT P.COD_ABI,
                  I.DESC_ISTITUTO,
                  P.COD_NDG,
                  Z.COD_SNDG,
                  a.DESC_NOME_CONTROPARTE,
                  P.COD_UO_PRATICA,
                  P.COD_MATR_PRATICA,
                  S.COD_PROTOCOLLO_DELIBERA,
                  S.DTA_INSERIMENTO_DELIBERA,
                  S.COD_DELIBERA,
                  D.DESC_DELIBERA,
                  S.COD_STATO_DELIBERA,
                  T.DESC_STATO_DELIBERA,
                  S.COD_ORGANO_DELIBERANTE,
                  NULL COD_MATR_INSERENTE,
                  z.COD_FILIALE_PRINCIPALE
             FROM T_MCRES_APP_PRATICHE P,
                  T_MCRES_APP_POSIZIONI Z,
                  T_MCRES_APP_DELIBERE S,
                  T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
                  T_MCRES_APP_ISTITUTI I,
                  T_MCRES_CL_TIPO_DELIBERA D,
                  T_MCRES_CL_STATO_DELIBERA T
            WHERE     P.FLG_ATTIVA = 1
                  AND Z.FLG_ATTIVA = 1
                  AND P.COD_ABI = z.COD_ABI
                  AND P.COD_NDG = Z.COD_NDG
                  AND Z.COD_SNDG = A.COD_SNDG(+)
                  AND P.COD_ABI = I.COD_ABI
                  AND S.COD_DELIBERA = D.COD_DELIBERA(+)
                  AND s.cod_abi = d.cod_abi(+)
                  AND D.FLG_FORFETARIA(+) = 'S'
                  AND S.COD_STATO_DELIBERA = T.COD_STATO_DELIBERA(+)
                  AND P.COD_MATR_PRATICA IS NOT NULL
                  AND P.COD_ABI = S.COD_ABI
                  AND P.COD_NDG = S.COD_NDG
                  AND P.COD_PRATICA = S.COD_PRATICA
                  AND P.VAL_ANNO = S.VAL_ANNO_PRATICA
                  AND S.COD_STATO_DELIBERA = 'IT'
                  AND SUBSTR (S.COD_PROTOCOLLO_DELIBERA,
                              LENGTH (S.COD_PROTOCOLLO_DELIBERA) - 4,
                              5) = '02440') a,
          T_MCRES_CL_ORGANO_DELIBERANTE OD
    WHERE     a.COD_ORGANO_DELIBERANTE = OD.COD_ORGANO_DELIBERANTE(+)
          AND a.COD_ABI = OD.COD_ABI(+)
          AND A.COD_UO_PRATICA = OD.COD_UO(+)
          AND TO_DATE ('99991231', 'YYYYMMDD') = Od.DTA_SCADENZA(+);
