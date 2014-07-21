/* Formatted on 21/07/2014 18:36:18 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_STOR_GESTORI_OLD
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
     SELECT                  --v111003: tolto comparto, aggiunta riga corrente
            --v111012: visualizzato comparto in Struttura, ripristinate righe senza gestore
            -- lf 17/009/2012 modifica inserendo nuova where sulla query sulla storico eventi.
            -- mm0110 appiattisco su dati ini/fine..
            DISTINCT
            COD_ABI_CARTOLARIZZATO,
            COD_NDG,
            -- DTA_INI_UTENTE,
            MIN (
               DTA_INI_UTENTE)
            OVER (
               PARTITION BY COD_ABI_CARTOLARIZZATO,
                            COD_NDG,
                            R.ID_UTENTE,
                            COD_STRUTTURA_COMPETENTE)
               DTA_INI_UTENTE,
            --  DTA_FINE_VALIDITA,
            NULLIF (
               MAX (
                  TRUNC (DTA_FINE_VALIDITA))
               OVER (
                  PARTITION BY COD_ABI_CARTOLARIZZATO,
                               COD_NDG,
                               R.ID_UTENTE,
                               COD_STRUTTURA_COMPETENTE),
               TRUNC (SYSDATE + 1))
               DTA_FINE_VALIDITA,
            R.ID_UTENTE,
            U.NOME || ' ' || U.COGNOME UTENTE,
            MIN (
               COD_STATO)
            OVER (
               PARTITION BY COD_ABI_CARTOLARIZZATO,
                            COD_NDG,
                            R.ID_UTENTE,
                            COD_STRUTTURA_COMPETENTE)
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
              WHERE (FLG_CAMBIO_GESTORE = '1' OR FLG_CAMBIO_COMPARTO = '1')
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
      WHERE NVL (R.ID_UTENTE, -1) = U.ID_UTENTE
   ORDER BY DTA_FINE_VALIDITA DESC;
