/* Formatted on 17/06/2014 18:11:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SP_LEGALI_DIS_AGG
(
   ID_LEGALE,
   INTESTAZIONE_CAMPO,
   ARCHIVIO_SAP,
   CAMPO_CRUSCOTTO
)
AS
     SELECT ID_LEGALE,
            INTESTAZIONE_CAMPO,
            ARCHIVIO_SAP,
            CAMPO_CRUSCOTTO
       FROM (SELECT A.ID_LEGALE,
                    A.CAMPO_CRUSCOTTO AS ARCHIVIO_SAP,
                    B.CAMPO_CRUSCOTTO,
                    A.INTESTAZIONE_CAMPO,
                    B.DTA_MOV,
                    B.PROG_MOV,
                    RANK ()
                       OVER (PARTITION BY A.ID_LEGALE ORDER BY B.PROG_MOV DESC)
                       R
               FROM (SELECT COD_ID_LEGALE AS ID_LEGALE,
                            COD_ABI AS CAMPO_CRUSCOTTO,
                            'BANCA' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            COD_PRESIDIO AS CAMPO_CRUSCOTTO,
                            'PRESIDIO' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_COGNOME AS CAMPO_CRUSCOTTO,
                            'COGNOME' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_NOME AS CAMPO_CRUSCOTTO,
                            'NOME' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            (SELECT DESC_SPECIALIZZAZIONE
                               FROM T_MCRES_CL_SPECIALIZZAZIONE
                              WHERE A.COD_SPECIALIZZAZIONE =
                                       COD_SPECIALIZZAZIONE)
                               AS CAMPO_CRUSCOTTO,
                            'SPECIALIZZAZIONE' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI A
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_CODFISC AS CAMPO_CRUSCOTTO,
                            'CF' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_PIVA AS CAMPO_CRUSCOTTO,
                            'PIVA' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_INDIRIZZO AS CAMPO_CRUSCOTTO,
                            'INDIRIZZO' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_CITTA AS CAMPO_CRUSCOTTO,
                            'CITTA' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_PROV AS CAMPO_CRUSCOTTO,
                            'PROVINCIA' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_CAP AS CAMPO_CRUSCOTTO,
                            'CAP' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_TELEF AS CAMPO_CRUSCOTTO,
                            'TELEFONO' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_FAX AS CAMPO_CRUSCOTTO,
                            'FAX' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_EMAIL AS CAMPO_CRUSCOTTO,
                            'EMAIL' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN1 AS CAMPO_CRUSCOTTO,
                            'IBAN1' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN2 AS CAMPO_CRUSCOTTO,
                            'IBAN2' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN3 AS CAMPO_CRUSCOTTO,
                            'IBAN3' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN4 AS CAMPO_CRUSCOTTO,
                            'IBAN4' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN5 AS CAMPO_CRUSCOTTO,
                            'IBAN5' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN6 AS CAMPO_CRUSCOTTO,
                            'IBAN6' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN7 AS CAMPO_CRUSCOTTO,
                            'IBAN7' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN8 AS CAMPO_CRUSCOTTO,
                            'IBAN8' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN9 AS CAMPO_CRUSCOTTO,
                            'IBAN9' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN10 AS CAMPO_CRUSCOTTO,
                            'IBAN10' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            FLG_CONVENZ AS CAMPO_CRUSCOTTO,
                            'CONVENZIONE' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            FLG_ALBO AS CAMPO_CRUSCOTTO,
                            'ALBO' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_IND_PROC_GEN AS CAMPO_CRUSCOTTO,
                            'PROCURA_GENERALE' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_AUTORIZZAZIONE_CENS AS CAMPO_CRUSCOTTO,
                            'AUTORIZZAZIONE' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            TO_CHAR (DTA_AUTORIZZAZIONE_CENS, 'DD/MM/YYYY')
                               AS CAMPO_CRUSCOTTO,
                            'DATA_AUTORIZZAZIONE' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            COD_NUM_REPERTORIO_PG AS CAMPO_CRUSCOTTO,
                            'NUMERO_REPERTORIO' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_NOMINATIVO_NOTAIO AS CAMPO_CRUSCOTTO,
                            'NOTAIO' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_NOTE AS CAMPO_CRUSCOTTO,
                            'NOTE' AS INTESTAZIONE_CAMPO,
                            NULL AS DTA_MOV,
                            NULL PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI) A
                    JOIN
                    (SELECT COD_ID_LEGALE AS ID_LEGALE,
                            COD_ABI AS CAMPO_CRUSCOTTO,
                            'BANCA' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            COD_PRESIDIO AS CAMPO_CRUSCOTTO,
                            'PRESIDIO' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_COGNOME AS CAMPO_CRUSCOTTO,
                            'COGNOME' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_NOME AS CAMPO_CRUSCOTTO,
                            'NOME' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            (SELECT DESC_SPECIALIZZAZIONE
                               FROM T_MCRES_CL_SPECIALIZZAZIONE
                              WHERE A.COD_SPECIALIZZAZIONE =
                                       COD_SPECIALIZZAZIONE)
                               AS CAMPO_CRUSCOTTO,
                            'SPECIALIZZAZIONE' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV A
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_CODFISC AS CAMPO_CRUSCOTTO,
                            'CF' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_PIVA AS CAMPO_CRUSCOTTO,
                            'PIVA' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_INDIRIZZO AS CAMPO_CRUSCOTTO,
                            'INDIRIZZO' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_CITTA AS CAMPO_CRUSCOTTO,
                            'CITTA' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_PROV AS CAMPO_CRUSCOTTO,
                            'PROVINCIA' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_CAP AS CAMPO_CRUSCOTTO,
                            'CAP' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_TELEF AS CAMPO_CRUSCOTTO,
                            'TELEFONO' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_FAX AS CAMPO_CRUSCOTTO,
                            'FAX' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_EMAIL AS CAMPO_CRUSCOTTO,
                            'EMAIL' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN1 AS CAMPO_CRUSCOTTO,
                            'IBAN1' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN2 AS CAMPO_CRUSCOTTO,
                            'IBAN2' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN3 AS CAMPO_CRUSCOTTO,
                            'IBAN3' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN4 AS CAMPO_CRUSCOTTO,
                            'IBAN4' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN5 AS CAMPO_CRUSCOTTO,
                            'IBAN5' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN6 AS CAMPO_CRUSCOTTO,
                            'IBAN6' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN7 AS CAMPO_CRUSCOTTO,
                            'IBAN7' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN8 AS CAMPO_CRUSCOTTO,
                            'IBAN8' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN9 AS CAMPO_CRUSCOTTO,
                            'IBAN9' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_IBAN10 AS CAMPO_CRUSCOTTO,
                            'IBAN10' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            FLG_CONVENZ AS CAMPO_CRUSCOTTO,
                            'CONVENZIONE' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            FLG_ALBO AS CAMPO_CRUSCOTTO,
                            'ALBO' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_LEGALE_IND_PROC_GEN AS CAMPO_CRUSCOTTO,
                            'PROCURA_GENERALE' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_AUTORIZZAZIONE_CENS AS CAMPO_CRUSCOTTO,
                            'AUTORIZZAZIONE' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            TO_CHAR (DTA_AUTORIZZAZIONE_CENS, 'DD/MM/YYYY')
                               AS CAMPO_CRUSCOTTO,
                            'DATA_AUTORIZZAZIONE' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            COD_NUM_REPERTORIO_PG AS CAMPO_CRUSCOTTO,
                            'NUMERO_REPERTORIO' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_NOMINATIVO_NOTAIO AS CAMPO_CRUSCOTTO,
                            'NOTAIO' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV
                     UNION ALL
                     SELECT COD_ID_LEGALE AS ID_LEGALE,
                            VAL_NOTE AS CAMPO_CRUSCOTTO,
                            'NOTE' AS INTESTAZIONE_CAMPO,
                            DTA_MOV,
                            PROG_MOV
                       FROM T_MCRES_APP_LEGALI_ESTERNI_MOV) B
                       ON     A.ID_LEGALE = B.ID_LEGALE
                          AND A.INTESTAZIONE_CAMPO = B.INTESTAZIONE_CAMPO)
      WHERE R = 1
   ORDER BY ID_LEGALE, INTESTAZIONE_CAMPO;


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_SP_LEGALI_DIS_AGG TO MCRE_USR;
