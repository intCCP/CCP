/* Formatted on 17/06/2014 18:02:39 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PT_POS_USCITE_AUT
(
   DESC_PERIODO,
   COD_Q,
   COD_COMPARTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   ID_UTENTE,
   ID_REFERENTE,
   COD_FILIALE,
   COD_ABI_ISTITUTO,
   IN_NUM_POS,
   SC_NUM_POS,
   BO_NUM_POS,
   SCSB_UTI_TOT,
   SCSB_UTI_CASSA,
   SCSB_UTI_FIRMA,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_DV,
   DESC_STRUTTURA_COMPETENTE_DV,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_LIVELLO,
   NUM_POS_RIPORTAFOGLIATI
)
AS
   SELECT DISTINCT Q.DESC_PERIODO,
                   Q.COD_Q,
                   COD_COMPARTO,
                   COD_ABI_CARTOLARIZZATO,
                   COD_NDG,
                   ID_UTENTE,
                   ID_REFERENTE,
                   COD_FILIALE,
                   COD_ABI_ISTITUTO,
                   DECODE (COD_MACROSTATO, 'IN', 1, 0) IN_NUM_POS,
                   DECODE (COD_MACROSTATO, 'SC', 1, 0) SC_NUM_POS,
                   DECODE (COD_MACROSTATO, 'BO', 1, 0) BO_NUM_POS,
                   SCSB_UTI_TOT,
                   SCSB_UTI_CASSA,
                   SCSB_UTI_FIRMA,
                   COD_STRUTTURA_COMPETENTE_DC,
                   DESC_STRUTTURA_COMPETENTE_DC,
                   COD_STRUTTURA_COMPETENTE_DV,
                   DESC_STRUTTURA_COMPETENTE_DV,
                   COD_STRUTTURA_COMPETENTE_AR,
                   DESC_STRUTTURA_COMPETENTE_AR,
                   COD_STRUTTURA_COMPETENTE_FI,
                   DESC_STRUTTURA_COMPETENTE_FI,
                   COD_STRUTTURA_COMPETENTE_RG,
                   DESC_STRUTTURA_COMPETENTE_RG,
                   V.COD_LIVELLO COD_LIVELLO,
                   0 NUM_POS_RIPORTAFOGLIATI
     FROM V_MCRE0_APP_PT_POS_USCITE_AUT1 V,
          (SELECT 'Trimestre attuale' DESC_PERIODO, 5 COD_Q FROM DUAL
           UNION ALL
           SELECT 'Trimestre-1' DESC_PERIODO, 4 COD_Q FROM DUAL
           UNION ALL
           SELECT 'Trimestre-2' DESC_PERIODO, 3 COD_Q FROM DUAL
           UNION ALL
           SELECT 'Trimestre-3' DESC_PERIODO, 2 COD_Q FROM DUAL
           UNION ALL
           SELECT 'Trimestre-4' DESC_PERIODO, 1 COD_Q FROM DUAL) Q
    WHERE Q.COD_Q = V.COD_Q
   UNION ALL
   SELECT 'Trimestre-4' DESC_PERIODO,
          1 COD_Q,
          NULL COD_COMPARTO,
          NULL COD_ABI_CARTOLARIZZATO,
          NULL COD_NDG,
          NULL ID_UTENTE,
          NULL ID_REFERENTE,
          NULL COD_FILIALE,
          NULL COD_ABI_ISTITUTO,
          0 IN_NUM_POS,
          0 SC_NUM_POS,
          0 BO_NUM_POS,
          0 SCSB_UTI_TOT,
          0 SCSB_UTI_CASSA,
          0 SCSB_UTI_FIRMA,
          NULL COD_STRUTTURA_COMPETENTE_DC,
          NULL DESC_STRUTTURA_COMPETENTE_DC,
          NULL COD_STRUTTURA_COMPETENTE_DV,
          NULL DESC_STRUTTURA_COMPETENTE_DV,
          NULL COD_STRUTTURA_COMPETENTE_AR,
          NULL DESC_STRUTTURA_COMPETENTE_AR,
          NULL COD_STRUTTURA_COMPETENTE_FI,
          NULL DESC_STRUTTURA_COMPETENTE_FI,
          NULL COD_STRUTTURA_COMPETENTE_RG,
          NULL DESC_STRUTTURA_COMPETENTE_RG,
          NULL COD_LIVELLO,
          0 NUM_POS_RIPORTAFOGLIATI
     FROM DUAL
   UNION ALL
   SELECT 'Trimestre-3' DESC_PERIODO,
          2 COD_Q,
          NULL COD_COMPARTO,
          NULL COD_ABI_CARTOLARIZZATO,
          NULL COD_NDG,
          NULL ID_UTENTE,
          NULL ID_REFERENTE,
          NULL COD_FILIALE,
          NULL COD_ABI_ISTITUTO,
          0 IN_NUM_POS,
          0 SC_NUM_POS,
          0 BO_NUM_POS,
          0 SCSB_UTI_TOT,
          0 SCSB_UTI_CASSA,
          0 SCSB_UTI_FIRMA,
          NULL COD_STRUTTURA_COMPETENTE_DC,
          NULL DESC_STRUTTURA_COMPETENTE_DC,
          NULL COD_STRUTTURA_COMPETENTE_DV,
          NULL DESC_STRUTTURA_COMPETENTE_DV,
          NULL COD_STRUTTURA_COMPETENTE_AR,
          NULL DESC_STRUTTURA_COMPETENTE_AR,
          NULL COD_STRUTTURA_COMPETENTE_FI,
          NULL DESC_STRUTTURA_COMPETENTE_FI,
          NULL COD_STRUTTURA_COMPETENTE_RG,
          NULL DESC_STRUTTURA_COMPETENTE_RG,
          NULL COD_LIVELLO,
          0 NUM_POS_RIPORTAFOGLIATI
     FROM DUAL
   UNION ALL
   SELECT 'Trimestre-2' DESC_PERIODO,
          3 COD_Q,
          NULL COD_COMPARTO,
          NULL COD_ABI_CARTOLARIZZATO,
          NULL COD_NDG,
          NULL ID_UTENTE,
          NULL ID_REFERENTE,
          NULL COD_FILIALE,
          NULL COD_ABI_ISTITUTO,
          0 IN_NUM_POS,
          0 SC_NUM_POS,
          0 BO_NUM_POS,
          0 SCSB_UTI_TOT,
          0 SCSB_UTI_CASSA,
          0 SCSB_UTI_FIRMA,
          NULL COD_STRUTTURA_COMPETENTE_DC,
          NULL DESC_STRUTTURA_COMPETENTE_DC,
          NULL COD_STRUTTURA_COMPETENTE_DV,
          NULL DESC_STRUTTURA_COMPETENTE_DV,
          NULL COD_STRUTTURA_COMPETENTE_AR,
          NULL DESC_STRUTTURA_COMPETENTE_AR,
          NULL COD_STRUTTURA_COMPETENTE_FI,
          NULL DESC_STRUTTURA_COMPETENTE_FI,
          NULL COD_STRUTTURA_COMPETENTE_RG,
          NULL DESC_STRUTTURA_COMPETENTE_RG,
          NULL COD_LIVELLO,
          0 NUM_POS_RIPORTAFOGLIATI
     FROM DUAL
   UNION ALL
   SELECT 'Trimestre-1' DESC_PERIODO,
          4 COD_Q,
          NULL COD_COMPARTO,
          NULL COD_ABI_CARTOLARIZZATO,
          NULL COD_NDG,
          NULL ID_UTENTE,
          NULL ID_REFERENTE,
          NULL COD_FILIALE,
          NULL COD_ABI_ISTITUTO,
          0 IN_NUM_POS,
          0 SC_NUM_POS,
          0 BO_NUM_POS,
          0 SCSB_UTI_TOT,
          0 SCSB_UTI_CASSA,
          0 SCSB_UTI_FIRMA,
          NULL COD_STRUTTURA_COMPETENTE_DC,
          NULL DESC_STRUTTURA_COMPETENTE_DC,
          NULL COD_STRUTTURA_COMPETENTE_DV,
          NULL DESC_STRUTTURA_COMPETENTE_DV,
          NULL COD_STRUTTURA_COMPETENTE_AR,
          NULL DESC_STRUTTURA_COMPETENTE_AR,
          NULL COD_STRUTTURA_COMPETENTE_FI,
          NULL DESC_STRUTTURA_COMPETENTE_FI,
          NULL COD_STRUTTURA_COMPETENTE_RG,
          NULL DESC_STRUTTURA_COMPETENTE_RG,
          NULL COD_LIVELLO,
          0 NUM_POS_RIPORTAFOGLIATI
     FROM DUAL
   UNION ALL
   SELECT 'Trimestre attuale' DESC_PERIODO,
          5 COD_Q,
          NULL COD_COMPARTO,
          NULL COD_ABI_CARTOLARIZZATO,
          NULL COD_NDG,
          NULL ID_UTENTE,
          NULL ID_REFERENTE,
          NULL COD_FILIALE,
          NULL COD_ABI_ISTITUTO,
          0 IN_NUM_POS,
          0 SC_NUM_POS,
          0 BO_NUM_POS,
          0 SCSB_UTI_TOT,
          0 SCSB_UTI_CASSA,
          0 SCSB_UTI_FIRMA,
          NULL COD_STRUTTURA_COMPETENTE_DC,
          NULL DESC_STRUTTURA_COMPETENTE_DC,
          NULL COD_STRUTTURA_COMPETENTE_DV,
          NULL DESC_STRUTTURA_COMPETENTE_DV,
          NULL COD_STRUTTURA_COMPETENTE_AR,
          NULL DESC_STRUTTURA_COMPETENTE_AR,
          NULL COD_STRUTTURA_COMPETENTE_FI,
          NULL DESC_STRUTTURA_COMPETENTE_FI,
          NULL COD_STRUTTURA_COMPETENTE_RG,
          NULL DESC_STRUTTURA_COMPETENTE_RG,
          NULL COD_LIVELLO,
          0 NUM_POS_RIPORTAFOGLIATI
     FROM DUAL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_APP_PT_POS_USCITE_AUT TO MCRE_USR;
