/* Formatted on 17/06/2014 18:06:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_ANADIP
(
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_STRUTTURA_COMPETENTE,
   DESC_STRUTTURA_COMPETENTE,
   COD_FASC,
   COD_STR_ORG_SUP,
   COD_LIVELLO,
   COD_DIV,
   FREE_AREA,
   COD_UTRUM,
   DAT_UPD,
   LIVELLO
)
AS
   WITH T_MCRE0_FL_ANADIP
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_ADIP_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   LPAD (RECANADIP_CODABI, 5, 0) AS COD_ABI_ISTITUTO,
                   LPAD (RECANADIP_CODFIL, 5, 0) AS COD_STRUTTURA_COMPETENTE,
                   RECANADIP_DESCFIL AS DESC_STRUTTURA_COMPETENTE,
                   RECANADIP_CODFASC AS COD_FASC,
                   LPAD (RECANADIP_CODFILSUP, 5, 0) AS COD_STR_ORG_SUP,
                   RECANADIP_IDNTIPFIL AS COD_LIVELLO,
                   RECANADIP_CODDIV AS COD_DIV,
                   RECANADIP_FREEAREA AS FREE_AREA,
                   RECANADIP_CODUTRM AS COD_UTRUM,
                   TO_DATE (SUBSTR (RECANADIP_DATULTAGGN, 1, 10),
                            'YYYY-MM-DD')
                      AS DAT_UPD,
                   RECANADIP_LIVELLO AS LIVELLO
              FROM TE_MCRE0_ADIP_INC
             WHERE FND_MCRE0_is_date (
                      TO_CHAR (
                         TO_DATE (SUBSTR (RECANADIP_DATULTAGGN, 1, 10),
                                  'YYYY-MM-DD'),
                         'ddmmyyyy')) = 1)
   SELECT "ID_DPER",
          "COD_ABI_ISTITUTO",
          "COD_STRUTTURA_COMPETENTE",
          "DESC_STRUTTURA_COMPETENTE",
          "COD_FASC",
          "COD_STR_ORG_SUP",
          "COD_LIVELLO",
          "COD_DIV",
          "FREE_AREA",
          "COD_UTRUM",
          "DAT_UPD",
          "LIVELLO"
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY ID_DPER,
                                  COD_ABI_ISTITUTO,
                                  COD_STRUTTURA_COMPETENTE)
                     NUM_RECS,
                  ID_DPER,
                  COD_ABI_ISTITUTO,
                  COD_STRUTTURA_COMPETENTE,
                  DESC_STRUTTURA_COMPETENTE,
                  COD_FASC,
                  COD_STR_ORG_SUP,
                  COD_LIVELLO,
                  COD_DIV,
                  FREE_AREA,
                  COD_UTRUM,
                  DAT_UPD,
                  LIVELLO
             FROM T_MCRE0_FL_ANADIP) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_STRUTTURA_COMPETENTE)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_ANADIP TO MCRE_USR;
