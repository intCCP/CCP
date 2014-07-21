/* Formatted on 21/07/2014 18:36:17 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_STO_GESTORI_OLD
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   DTA_INI_UTENTE,
   DTA_FINE_VALIDITA,
   ID_UTENTE,
   UTENTE,
   COD_STATO,
   COD_STRUTTURA_COMPETENTE
)
AS
   SELECT                    --v111003: tolto comparto, aggiunta riga corrente
          --v111012: visualizzato comparto in Struttura, ripristinate righe senza gestore
          DISTINCT COD_ABI_CARTOLARIZZATO,
                   COD_NDG,
                   DTA_INI_UTENTE,
                   DTA_FINE_VALIDITA,
                   R.ID_UTENTE,
                   U.NOME || ' ' || U.COGNOME UTENTE,
                   COD_STATO,
                   COD_STRUTTURA_COMPETENTE
     FROM (SELECT COD_ABI_CARTOLARIZZATO,
                  COD_NDG,
                  CASE
                     WHEN NULLIF (E.ID_UTENTE, -1) IS NULL THEN NULL
                     ELSE E.DTA_INI_UTENTE
                  END
                     DTA_INI_UTENTE,
                  TRUNC (DTA_FINE_VALIDITA) DTA_FINE_VALIDITA,
                  NULLIF (E.ID_UTENTE, -1) ID_UTENTE,
                  NULLIF (COD_STATO, '-1') COD_STATO,
                  NVL (cod_comparto_assegnato, cod_comparto_calcolato)
                     AS COD_STRUTTURA_COMPETENTE
             FROM T_MCRE0_APP_STORICO_EVENTI E
            WHERE FLG_CAMBIO_GESTORE = '1'
           --                   AND NULLIF (E.ID_UTENTE, -1) IS NOT NULL
           UNION
           SELECT COD_ABI_CARTOLARIZZATO,
                  COD_NDG,
                  CASE
                     WHEN NULLIF (ID_UTENTE, -1) IS NULL THEN NULL
                     ELSE TRUNC (DTA_UTENTE_ASSEGNATO)
                  END
                     DTA_INI_UTENTE,
                  NULL DTA_FINE_VALIDITA,
                  NULLIF (ID_UTENTE, -1) ID_UTENTE,
                  NULLIF (COD_STATO, '-1') COD_STATO,
                  NVL (cod_comparto_assegnato, cod_comparto_calcolato)
                     AS COD_STRUTTURA_COMPETENTE
             FROM T_MCRE0_APP_ALL_DATA) R,
          T_MCRE0_APP_UTENTI U
    WHERE NVL (R.ID_UTENTE, -1) = U.ID_UTENTE;
