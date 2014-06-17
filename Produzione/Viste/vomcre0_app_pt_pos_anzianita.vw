/* Formatted on 17/06/2014 18:13:55 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_PT_POS_ANZIANITA
(
   COD_COMPARTO,
   COD_ABI_CARTOLARIZZATO,
   ID_UTENTE,
   ID_REFERENTE,
   VAL_ORDINE,
   DESC_PERIODO,
   VAL_NUM_POS,
   SCSB_UTI_TOT,
   SCSB_UTI_CASSA,
   SCSB_UTI_FIRMA,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG
)
AS
     SELECT                                       -- v1 17/06/2011 VG: New PCR
           COD_COMPARTO,
            COD_ABI_CARTOLARIZZATO,
            ID_UTENTE,
            ID_REFERENTE,
            VAL_ORDINE,
            DESC_PERIODO,
            SUM (VAL_NUM_POS) VAL_NUM_POS,
            SUM (SCSB_UTI_TOT) SCSB_UTI_TOT,
            SUM (SCSB_UTI_CASSA) SCSB_UTI_CASSA,
            SUM (SCSB_UTI_FIRMA) SCSB_UTI_FIRMA,
            COD_STRUTTURA_COMPETENTE_DC,
            DESC_STRUTTURA_COMPETENTE_DC,
            COD_STRUTTURA_COMPETENTE_AR,
            DESC_STRUTTURA_COMPETENTE_AR,
            COD_STRUTTURA_COMPETENTE_FI,
            DESC_STRUTTURA_COMPETENTE_FI,
            COD_STRUTTURA_COMPETENTE_RG,
            DESC_STRUTTURA_COMPETENTE_RG
       FROM (  SELECT COD_COMPARTO,
                      COD_ABI_CARTOLARIZZATO,
                      ID_UTENTE,
                      ID_REFERENTE,
                      VAL_ORDINE,
                      DECODE (VAL_ORDINE,
                              1, '<=30 giorni',
                              2, '31-60 giorni',
                              3, '61-90 giorni',
                              '>90 giorni')
                         DESC_PERIODO,
                      COUNT (*) VAL_NUM_POS,
                      SUM (SCSB_UTI_TOT) SCSB_UTI_TOT,
                      SUM (SCSB_UTI_CASSA) SCSB_UTI_CASSA,
                      SUM (SCSB_UTI_FIRMA) SCSB_UTI_FIRMA,
                      COD_STRUTTURA_COMPETENTE_DC,
                      DESC_STRUTTURA_COMPETENTE_DC,
                      COD_STRUTTURA_COMPETENTE_AR,
                      DESC_STRUTTURA_COMPETENTE_AR,
                      COD_STRUTTURA_COMPETENTE_FI,
                      DESC_STRUTTURA_COMPETENTE_FI,
                      COD_STRUTTURA_COMPETENTE_RG,
                      DESC_STRUTTURA_COMPETENTE_RG
                 FROM (SELECT X.COD_COMPARTO,
                              X.ID_UTENTE,
                              U.ID_REFERENTE,
                              X.COD_ABI_CARTOLARIZZATO,
                              X.COD_NDG,
                              DECODE (
                                 SIGN (
                                    TRUNC (SYSDATE) - X.DTA_DECORRENZA_STATO - 31),
                                 -1, 1,
                                 DECODE (
                                    SIGN (
                                         TRUNC (SYSDATE)
                                       - X.DTA_DECORRENZA_STATO
                                       - 61),
                                    -1, 2,
                                    DECODE (
                                       SIGN (
                                            TRUNC (SYSDATE)
                                          - X.DTA_DECORRENZA_STATO
                                          - 91),
                                       -1, 3,
                                       4)))
                                 VAL_ORDINE,
                              P.SCSB_UTI_TOT,
                              P.SCSB_UTI_CASSA,
                              P.SCSB_UTI_FIRMA,
                              S.COD_STRUTTURA_COMPETENTE_DC,
                              S.DESC_STRUTTURA_COMPETENTE_DC,
                              S.COD_STRUTTURA_COMPETENTE_AR,
                              S.DESC_STRUTTURA_COMPETENTE_AR,
                              S.COD_STRUTTURA_COMPETENTE_FI,
                              S.DESC_STRUTTURA_COMPETENTE_FI,
                              COD_STRUTTURA_COMPETENTE_RG,
                              DESC_STRUTTURA_COMPETENTE_RG
                         FROM MV_MCRE0_APP_UPD_FIELD X,
                              T_MCRE0_APP_UTENTI U,
                              T_MCRE0_APP_PCR P,
                              MV_MCRE0_DENORM_STR_ORG S
                        WHERE     X.COD_STATO = 'PT'
                              AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
                              AND X.COD_ABI_CARTOLARIZZATO =
                                     P.COD_ABI_CARTOLARIZZATO(+)
                              AND X.COD_NDG = P.COD_NDG(+)
                              AND X.ID_UTENTE = U.ID_UTENTE(+)
                              AND X.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO_FI(+)
                              AND X.COD_FILIALE =
                                     S.COD_STRUTTURA_COMPETENTE_FI(+))
             GROUP BY COD_COMPARTO,
                      COD_ABI_CARTOLARIZZATO,
                      ID_UTENTE,
                      ID_REFERENTE,
                      VAL_ORDINE,
                      COD_STRUTTURA_COMPETENTE_DC,
                      DESC_STRUTTURA_COMPETENTE_DC,
                      COD_STRUTTURA_COMPETENTE_AR,
                      DESC_STRUTTURA_COMPETENTE_AR,
                      COD_STRUTTURA_COMPETENTE_FI,
                      DESC_STRUTTURA_COMPETENTE_FI,
                      COD_STRUTTURA_COMPETENTE_RG,
                      DESC_STRUTTURA_COMPETENTE_RG
             UNION ALL
             SELECT NULL COD_COMPARTO,
                    NULL COD_ABI_CARTOLARIZZATO,
                    NULL ID_UTENTE,
                    NULL ID_REFERENTE,
                    1 VAL_ORDINE,
                    '<=30 giorni' DESC_PERIODO,
                    0 VAL_NUM_POS,
                    0 SCSB_UTI_TOT,
                    0 SCSB_UTI_CASSA,
                    0 SCSB_UTI_FIRMA,
                    NULL COD_STRUTTURA_COMPETENTE_DC,
                    NULL DESC_STRUTTURA_COMPETENTE_DC,
                    NULL COD_STRUTTURA_COMPETENTE_AR,
                    NULL DESC_STRUTTURA_COMPETENTE_AR,
                    NULL COD_STRUTTURA_COMPETENTE_FI,
                    NULL DESC_STRUTTURA_COMPETENTE_FI,
                    NULL COD_STRUTTURA_COMPETENTE_RG,
                    NULL DESC_STRUTTURA_COMPETENTE_RG
               FROM DUAL
             UNION ALL
             SELECT NULL COD_COMPARTO,
                    NULL COD_ABI_CARTOLARIZZATO,
                    NULL ID_UTENTE,
                    NULL ID_REFERENTE,
                    2 VAL_ORDINE,
                    '31-60 giorni' DESC_PERIODO,
                    0 VAL_NUM_POS,
                    0 SCSB_UTI_TOT,
                    0 SCSB_UTI_CASSA,
                    0 SCSB_UTI_FIRMA,
                    NULL COD_STRUTTURA_COMPETENTE_DC,
                    NULL DESC_STRUTTURA_COMPETENTE_DC,
                    NULL COD_STRUTTURA_COMPETENTE_AR,
                    NULL DESC_STRUTTURA_COMPETENTE_AR,
                    NULL COD_STRUTTURA_COMPETENTE_FI,
                    NULL DESC_STRUTTURA_COMPETENTE_FI,
                    NULL COD_STRUTTURA_COMPETENTE_RG,
                    NULL DESC_STRUTTURA_COMPETENTE_RG
               FROM DUAL
             UNION ALL
             SELECT NULL COD_COMPARTO,
                    NULL COD_ABI_CARTOLARIZZATO,
                    NULL ID_UTENTE,
                    NULL ID_REFERENTE,
                    3 VAL_ORDINE,
                    '61-90 giorni' DESC_PERIODO,
                    0 VAL_NUM_POS,
                    0 SCSB_UTI_TOT,
                    0 SCSB_UTI_CASSA,
                    0 SCSB_UTI_FIRMA,
                    NULL COD_STRUTTURA_COMPETENTE_DC,
                    NULL DESC_STRUTTURA_COMPETENTE_DC,
                    NULL COD_STRUTTURA_COMPETENTE_AR,
                    NULL DESC_STRUTTURA_COMPETENTE_AR,
                    NULL COD_STRUTTURA_COMPETENTE_FI,
                    NULL DESC_STRUTTURA_COMPETENTE_FI,
                    NULL COD_STRUTTURA_COMPETENTE_RG,
                    NULL DESC_STRUTTURA_COMPETENTE_RG
               FROM DUAL
             UNION ALL
             SELECT NULL COD_COMPARTO,
                    NULL COD_ABI_CARTOLARIZZATO,
                    NULL ID_UTENTE,
                    NULL ID_REFERENTE,
                    4 VAL_ORDINE,
                    '>90 giorni' DESC_PERIODO,
                    0 VAL_NUM_POS,
                    0 SCSB_UTI_TOT,
                    0 SCSB_UTI_CASSA,
                    0 SCSB_UTI_FIRMA,
                    NULL COD_STRUTTURA_COMPETENTE_DC,
                    NULL DESC_STRUTTURA_COMPETENTE_DC,
                    NULL COD_STRUTTURA_COMPETENTE_AR,
                    NULL DESC_STRUTTURA_COMPETENTE_AR,
                    NULL COD_STRUTTURA_COMPETENTE_FI,
                    NULL DESC_STRUTTURA_COMPETENTE_FI,
                    NULL COD_STRUTTURA_COMPETENTE_RG,
                    NULL DESC_STRUTTURA_COMPETENTE_RG
               FROM DUAL)
   GROUP BY COD_COMPARTO,
            COD_ABI_CARTOLARIZZATO,
            ID_UTENTE,
            ID_REFERENTE,
            VAL_ORDINE,
            DESC_PERIODO,
            COD_STRUTTURA_COMPETENTE_DC,
            DESC_STRUTTURA_COMPETENTE_DC,
            COD_STRUTTURA_COMPETENTE_AR,
            DESC_STRUTTURA_COMPETENTE_AR,
            COD_STRUTTURA_COMPETENTE_FI,
            DESC_STRUTTURA_COMPETENTE_FI,
            COD_STRUTTURA_COMPETENTE_RG,
            DESC_STRUTTURA_COMPETENTE_RG;


GRANT SELECT ON MCRE_OWN.VOMCRE0_APP_PT_POS_ANZIANITA TO MCRE_USR;
