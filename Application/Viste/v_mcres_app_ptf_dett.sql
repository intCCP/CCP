/* Formatted on 21/07/2014 18:42:39 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_PTF_DETT
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   DTA_PASSAGGIO_SOFF,
   COD_FILIALE,
   VAL_ANNOMESE,
   FLG_GRUPPO,
   VAL_GBV,
   VAL_NBV,
   DTA_DELIBERA,
   COD_STATO_RISCHIO,
   VAL_UTILIZZO,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   VAL_TIPO_GESTIONE,
   DTA_NASCITA
)
AS
   SELECT s."COD_ABI",
          I.DESC_ISTITUTO,
          s.COD_NDG,
          A.DESC_NOME_CONTROPARTE,
          S.COD_SNDG,
          "DTA_PASSASAGGIO_SOFF" DTA_PASSAGGIO_SOFF,
          cod_filiale,
          "VAL_ANNOMESE",
          "FLG_GRUPPO",
          "VAL_GBV",
          "VAL_NBV",
          CASE
             WHEN s.dta_delibera != TO_DATE ('99991231', 'YYYYMMDD')
             THEN
                s.dta_delibera
             ELSE
                NULL
          END
             dta_delibera,
          CASE
             WHEN cod_stato_rischio = 'B' THEN 'Bonis'
             WHEN cod_stato_rischio = 'S' THEN 'Sofferenza'
             WHEN cod_stato_rischio = 'E' THEN 'Incaglio'
             ELSE cod_stato_rischio
          END
             "COD_STATO_RISCHIO",
          "VAL_UTILIZZO",
          "COD_UO_PRATICA",
          "COD_MATR_PRATICA",
          val_tipo_gestione,
          TO_DATE (NULL, 'YYYYMMDD') dta_nascita
     FROM T_MCRES_FEN_PTF_dett s,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
          T_MCRES_APP_ISTITUTI I
    WHERE S.COD_SNDG = A.COD_SNDG(+) AND s.cod_abi = i.cod_abi(+);
