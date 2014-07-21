/* Formatted on 21/07/2014 18:46:15 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_POSIZIONI_STATO
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   FLG_OUTSOURCING,
   COD_COMPARTO,
   ID_UTENTE,
   COD_MACROSTATO,
   VAL_LABEL_MACROSTATO,
   VAL_ORDINE,
   NUM_POSIZIONI,
   TOT_UTI_CASSA,
   TOT_UTI_CASSA_GB,
   TOT_UTI_FIRMA,
   TOT_UTI_FIRMA_GB,
   DTA_VALIDITA,
   DESC_ISTITUTO,
   VAL_GRUPPO
)
AS
   SELECT S.COD_ABI_ISTITUTO,
          S.COD_ABI_CARTOLARIZZATO,
          NVL (S.FLG_OUTSOURCING, 'N') AS FLG_OUTSOURCING,
          S.COD_COMPARTO,
          S.ID_UTENTE,
          S.COD_MACROSTATO,
          ST.VAL_LABEL_MACROSTATO,
          ST.VAL_ORDINE,
          S.NUM_POSIZIONI,
          S.TOT_UTI_CASSA,
          S.TOT_UTI_CASSA_GB,
          S.TOT_UTI_FIRMA,
          S.TOT_UTI_FIRMA_GB,
          TRUNC (SYSDATE) DTA_VALIDITA,
          I.DESC_ISTITUTO,
          ST.VAL_GRUPPO
     FROM MV_MCRE0_APP_POSIZIONI_STATO S,
          (SELECT DISTINCT COD_MACROSTATO,
                           VAL_ORDINE,
                           VAL_LABEL_MACROSTATO,
                           VAL_GRUPPO
             FROM T_MCRE0_APP_STATI
            WHERE FLG_STATO_CHK = 1) ST,
          T_MCRE0_APP_ISTITUTI I
    WHERE     S.COD_MACROSTATO = ST.COD_MACROSTATO
          AND I.COD_ABI = S.COD_ABI_CARTOLARIZZATO;
