/* Formatted on 17/06/2014 18:10:51 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_PERFORMANCE
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_PRESIDIO,
   DESC_PRESIDIO,
   COD_MATR_PRATICA,
   VAL_ANNOMESE,
   VAL_GBV_MEDIO,
   VAL_NBV_MEDIO,
   VAL_VANTATO_MEDIO,
   VAL_INCASSI,
   VAL_TMR_VANTATO,
   VAL_TMR_GBV,
   VAL_SOPRAVVENIENZE_ATTIVE,
   VAL_SPESE
)
AS
   SELECT p.COD_ABI,
          I.DESC_ISTITUTO,
          "COD_UO_PRATICA" COD_PRESIDIO,
          R.DESC_PRESIDIO,
          DECODE (COD_MATR_PRATICA, '-1', NULL, COD_MATR_PRATICA)
             COD_MATR_PRATICA,
          "VAL_ANNOMESE",
          "VAL_GBV_MEDIO",
          "VAL_NBV_MEDIO",
          "VAL_VANTATO_MEDIO",
          "VAL_INCASSI",
          "VAL_TMR_VANTATO",
          "VAL_TMR_GBV",
          TO_NUMBER (NULL) VAL_SOPRAVVENIENZE_ATTIVE,
          TO_NUMBER (NULL) val_spese
     FROM T_MCRES_FEN_PERFORMANCE P,
          T_MCRES_APP_ISTITUTI I,
          (SELECT *
             FROM v_MCRES_APP_lista_presidi
            WHERE cod_tipo = 'P') r
    WHERE P.COD_ABI = I.COD_ABI AND P.COD_UO_PRATICA = r.cod_presidio;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_PERFORMANCE TO MCRE_USR;
