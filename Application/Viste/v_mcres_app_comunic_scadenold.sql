/* Formatted on 21/07/2014 18:41:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_COMUNIC_SCADENOLD
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_PRESIDIO,
   DESC_PRESIDIO,
   COD_LIVELLO,
   DTA_SCADENZA,
   DESC_SCADENZA,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   VAL_GG_SCADENZA,
   COD_TIPO_SCADENZA,
   FLG_LINK
)
AS
   SELECT a.COD_ABI,
          I.DESC_ISTITUTO,
          a.COD_NDG,
          a.COD_SNDG,
          G.DESC_NOME_CONTROPARTE,
          P.COD_PRESIDIO,
          P.DESC_PRESIDIO,
          P.COD_LIVELLO,
          a.DTA_SCADENZA,
          a.DESC_SCADENZA,
          z.COD_UO_PRATICA,
          z.COD_MATR_PRATICA,
          a.VAL_GG_SCADENZA,
          COD_TIPO_SCADENZA,
          flg_link
     FROM (SELECT DISTINCT
                  G.COD_ABI,
                  g.cod_ndg,
                  G.COD_SNDG,
                  S.DESC_SCADENZA,
                  ADD_MONTHS (G.DTA_SCADENZA_GARANZIA, 240) DTA_SCADENZA,
                  ADD_MONTHS (G.DTA_SCADENZA_GARANZIA, 240) - TRUNC (SYSDATE)
                     VAL_GG_SCADENZA,
                  COD_TIPO_SCADENZA,
                  0 flg_link
             FROM T_MCRES_APP_GARANZIE G, T_MCRES_APP_SCADENZARIO S
            WHERE     S.COD_TIPO_SCADENZA = 1
                  AND (ADD_MONTHS (G.DTA_SCADENZA_GARANZIA, 240) BETWEEN   TRUNC (
                                                                              SYSDATE)
                                                                         - S.VAL_GG_PREC
                                                                     AND   TRUNC (
                                                                              SYSDATE)
                                                                         + S.VAL_GG_SUCC --          add_months(G.DTA_SCADENZA_GARANZIA,240) BETWEEN TRUNC(sysdate) AND
 --          TRUNC(sysdate)                                                 +S.VAL_GG_SUCC
  --        OR add_months(G.DTA_SCADENZA_GARANZIA,240) BETWEEN TRUNC(sysdate)-
                                  --          S.VAL_GG_PREC AND TRUNC(sysdate)
                      )
                  AND G.COD_FORMA_TECNICA = '08070'
           UNION ALL
           SELECT DISTINCT
                  r.COD_ABI,
                  r.cod_ndg,
                  r.COD_SNDG,
                  S.DESC_SCADENZA,
                  ADD_MONTHS (r.dta_nbv, 6) DTA_SCADENZA,
                  ADD_MONTHS (r.dta_nbv, 6) - TRUNC (SYSDATE) VAL_GG_SCADENZA,
                  COD_TIPO_SCADENZA,
                  CASE
                     WHEN ADD_MONTHS (r.dta_nbv, 6) >= TRUNC (SYSDATE) THEN 1
                     ELSE 0
                  END
                     flg_link
             FROM T_MCRES_APP_rapporti r, T_MCRES_APP_SCADENZARIO S
            WHERE     S.COD_TIPO_SCADENZA = 2
                  AND ADD_MONTHS (r.DTA_NBV, 6) BETWEEN   TRUNC (SYSDATE)
                                                        - S.VAL_GG_PREC
                                                    AND   TRUNC (SYSDATE)
                                                        + S.VAL_GG_SUCC
                  AND NOT EXISTS
                             (SELECT DISTINCT 1
                                FROM t_mcres_app_delibere d
                               WHERE     d.cod_abi = r.cod_abi
                                     AND d.cod_ndg = r.cod_ndg
                                     AND d.cod_delibera = 'RW'
                                     AND D.COD_STATO_DELIBERA = 'CO')) a,
          t_mcres_app_pratiche z,
          T_Mcres_App_Istituti I,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO G,
          (SELECT *
             FROM V_MCRES_APP_LISTA_PRESIDI
            WHERE cod_tipo = 'P') P
    WHERE     z.flg_attiva = 1
          AND a.COD_ABI = Z.COD_ABI
          AND a.COD_NDG = Z.COD_NDG
          AND a.COD_ABI = I.COD_ABI
          AND Z.COD_UO_PRATICA = P.COD_PRESIDIO(+)
          AND a.COD_SNDG = g.COD_SNDG;
