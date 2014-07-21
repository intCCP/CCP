/* Formatted on 21/07/2014 18:43:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_STOCK_POS
(
   VAL_ANNOMESE,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   VAL_VANTATO,
   VAL_GBV,
   VAL_NBV,
   VAL_IMP_GAR_REALI_PERSONALI,
   VAL_IMP_GAR_REALI,
   FLG_GAR_REALI_PERSONALI,
   FLG_GAR_REALI,
   COD_PRESIDIO,
   VAL_ORDINE,
   DESC_PRESIDIO
)
AS
   SELECT "VAL_ANNOMESE",
          "COD_ABI",
          "COD_NDG",
          p.cod_sndg,
          g.desc_nome_controparte,
          "VAL_VANTATO",
          "VAL_GBV",
          "VAL_NBV",
          "VAL_IMP_GAR_REALI_PERSONALI",
          "VAL_IMP_GAR_REALI",
          "FLG_GAR_REALI_PERSONALI",
          "FLG_GAR_REALI",
          PRE.COD_PRESIDIO,
          "VAL_ORDINE",
          Pre.Desc_Presidio
     FROM t_mcres_fen_stock_pos p,
          T_Mcre0_App_Anagrafica_Gruppo G,
          V_MCRES_APP_LISTA_PRESIDI PRE
    WHERE P.Cod_Sndg = G.Cod_Sndg(+) AND Pre.Cod_PRESIDIO = P.Cod_Presidio;
