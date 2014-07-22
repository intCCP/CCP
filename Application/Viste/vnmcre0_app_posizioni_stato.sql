/* Formatted on 21/07/2014 18:45:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_POSIZIONI_STATO
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   FLG_OUTSOURCING,
   COD_COMPARTO,
   ID_UTENTE,
   COD_MACROSTATO,
   DESC_ISTITUTO,
   VAL_LABEL_MACROSTATO,
   VAL_ORDINE,
   VAL_GRUPPO,
   DTA_VALIDITA,
   NUM_POSIZIONI,
   TOT_UTI_CASSA,
   TOT_UTI_FIRMA,
   TOT_UTI_CASSA_GB,
   TOT_UTI_FIRMA_GB
)
AS
     SELECT COD_ABI_ISTITUTO,
            COD_ABI_CARTOLARIZZATO,
            FLG_OUTSOURCING,
            COD_COMPARTO,
            ID_UTENTE,
            COD_MACROSTATO,
            MAX (DESC_ISTITUTO) DESC_ISTITUTO,
            MAX (VAL_LABEL_MACROSTATO) VAL_LABEL_MACROSTATO,
            MAX (VAL_ORDINE) VAL_ORDINE,
            MAX (VAL_GRUPPO) VAL_GRUPPO,
            TRUNC (SYSDATE) DTA_VALIDITA,
            COUNT (*) NUM_POSIZIONI,
            SUM (SCSB_UTI_CASSA) TOT_UTI_CASSA,
            SUM (SCSB_UTI_FIRMA) TOT_UTI_FIRMA,
            SUM (SCSB_UTI_CASSA * FLG_SOMMA) TOT_UTI_CASSA_GB,
            SUM (SCSB_UTI_FIRMA * FLG_SOMMA) TOT_UTI_FIRMA_GB
       FROM V_MCRE0_APP_UPD_FIELDS
      WHERE FLG_STATO_CHK = '1'
   GROUP BY COD_ABI_ISTITUTO,
            COD_ABI_CARTOLARIZZATO,
            FLG_OUTSOURCING,
            COD_COMPARTO,
            ID_UTENTE,
            COD_MACROSTATO;