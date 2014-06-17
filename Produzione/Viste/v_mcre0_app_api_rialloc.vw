/* Formatted on 17/06/2014 18:01:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_API_RIALLOC
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_STATO,
   FLG_OUTSOURCING,
   COD_MATRICOLA,
   COD_STRUTTURA_COMPETENTE,
   RECORD_CHAR
)
AS
   SELECT fg.COD_ABI_ISTITUTO,
          fg.COD_ABI_CARTOLARIZZATO,
          fg.COD_NDG,
          DECODE (fg.COD_STATO, 'RS', 'IN', fg.COD_STATO) COD_STATO,
          fg.FLG_OUTSOURCING,
          UT.COD_MATRICOLA,
          O.COD_STRUTTURA_COMPETENTE,
          '                   ' AS record_char
     FROM (SELECT           --select che sostituisce la MV_MCRE0_APP_UPD_FIELD
                 COD_ABI_CARTOLARIZZATO,
                  COD_ABI_ISTITUTO,
                  COD_COMPARTO,
                  COD_NDG,
                  COD_STATO,
                  FLG_OUTSOURCING,
                  NULLIF (ID_UTENTE, -1) ID_UTENTE
             FROM (SELECT   --select che sostituisce la V_MCRE0_APP_UPD_FIELDS
                         COD_ABI_CARTOLARIZZATO,
                          COD_NDG,
                          COD_ABI_ISTITUTO,
                          NULLIF (P.COD_COMPARTO, '#') COD_COMPARTO,
                          P.ID_UTENTE,
                          NULLIF (COD_STATO, '-1') COD_STATO,
                          FLG_OUTSOURCING
                     FROM (SELECT --select sostitutiva della V_MCRE0_APP_UPD_FIELDS_P1
                                 TODAY_FLG,
                                  COD_ABI_CARTOLARIZZATO,
                                  COD_NDG,
                                  COD_ABI_ISTITUTO,
                                  NVL (COD_COMPARTO_ASSEGNATO,
                                       COD_COMPARTO_CALCOLATO)
                                     COD_COMPARTO,
                                  ID_UTENTE,
                                  CASE
                                     WHEN FLG_SOURCE = '0'
                                     THEN
                                        NVL (COD_STATO, '-1')
                                     ELSE
                                        'GB'
                                  END
                                     COD_STATO,
                                  COD_FILIALE,
                                  CASE
                                     WHEN FLG_SOURCE = '0'
                                     THEN
                                        FLG_OUTSOURCING
                                     ELSE
                                        CASE
                                           WHEN (COD_STATO = 'SO')
                                           THEN
                                              (SELECT I.FLG_OUTSOURCING
                                                 FROM T_MCRE0_APP_ISTITUTI I
                                                WHERE I.COD_ABI =
                                                         COD_ABI_CARTOLARIZZATO)
                                           ELSE
                                              FLG_OUTSOURCING
                                        END
                                  END
                                     FLG_OUTSOURCING
                             FROM T_MCRE0_APP_ALL_DATA_RIALLOC) P,
                          MV_MCRE0_DENORM_STR_ORG S,
                          T_MCRE0_APP_STATI I,
                          T_MCRE0_APP_UTENTI U,
                          T_MCRE0_APP_COMPARTI CO
                    WHERE     P.COD_FILIALE = S.COD_STRUTTURA_COMPETENTE_FI
                          AND P.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO_FI
                          AND P.COD_STATO = I.COD_MICROSTATO
                          AND P.ID_UTENTE = U.ID_UTENTE
                          AND P.COD_COMPARTO = CO.COD_COMPARTO)) fg
          INNER JOIN T_MCRE0_APP_ISTITUTI ist
             ON ist.COD_ABI = fg.COD_ABI_CARTOLARIZZATO
          LEFT JOIN
          T_MCRE0_APP_STRUTTURA_ORG O
             ON     SUBSTR (O.COD_COMPARTO, -5, 5) =
                       SUBSTR (fg.COD_COMPARTO, -5, 5)
                AND fg.COD_ABI_ISTITUTO = o.COD_ABI_ISTITUTO
          LEFT JOIN T_MCRE0_APP_UTENTI UT ON UT.ID_UTENTE = FG.ID_UTENTE
    WHERE     fg.COD_COMPARTO IS NOT NULL
          AND fg.COD_STATO IS NOT NULL
          AND ist.flg_outsourcing = 'Y'
          AND flg_cartolarizzato IS NULL
          AND flg_segregato IS NULL;


GRANT DELETE, INSERT, SELECT, UPDATE ON MCRE_OWN.V_MCRE0_APP_API_RIALLOC TO MCRE_USR;
