/* Formatted on 21/07/2014 18:44:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_BODY_SAP_SOF_OLD
(
   COD_SAP_SOCIETA,
   VAL_ORDINE_TIPO_RECORD,
   VAL_PROGRESSIVO,
   LINE
)
AS
   WITH spese
        AS (SELECT s.*
              FROM t_mcres_app_sp_spese s
             WHERE     0 = 0
                   AND s.cod_abi = SYS_CONTEXT ('userenv', 'client_info')
                   AND cod_stato = 'CO'
                   AND flg_invio_sap = 0
                   AND flg_source = 'SOF'
                   AND s.cod_tipo_autorizzazione IN ('1', '6')
                   AND s.cod_autorizzazione_padre IS NULL
                   AND NOT EXISTS -- esclude spese con addebito su posizioni cartolarizzate
                              (SELECT 1
                                 FROM t_mcres_app_sp_contropartita c
                                WHERE     c.cod_autorizzazione =
                                             s.cod_autorizzazione
                                      AND c.cod_tipo = '7'))
   SELECT s.cod_societa cod_sap_societa,
          0 val_ordine_tipo_record,
          0 val_progressivo,
             --------
             ' SL'                                              -- tipo record
          || SUBSTR (s.cod_societa, 1, 4)                       -- cod_sap_soc
          || TO_CHAR (SYSDATE, 'yyyymmdd')                    -- dta_creazione
          || TO_CHAR (SYSDATE, 'hh24miss')                     -- ora crazione
          || '*MCT*'                                  -- identificativo flusso
          || RPAD (' ', 254, ' ')                                    -- filler
             line
     FROM t_mcres_cl_sap s
    WHERE 0 = 0 AND s.cod_abi = SYS_CONTEXT ('userenv', 'client_info')
   /*************************************
   ***
   *** 1 - FORNITORE
   ***
   /*************************************/
   ---
   UNION ALL
   ---
   SELECT SUBSTR (s.cod_autorizzazione, 1, 4) cod_sap_societa,
          1 val_ordine_tipo_record,
          ROW_NUMBER () OVER (ORDER BY s.cod_autorizzazione) val_progressivo,
             --------
             ' FO'                                              -- tipo record
          || LPAD (ROW_NUMBER () OVER (ORDER BY s.cod_autorizzazione), 5, 0) -- progressivo
          || RPAD (COALESCE (s.val_intestatario_piva, ' '), 18, ' ') -- partita iva
          || RPAD (COALESCE (s.val_intestatario_codfisc, ' '), 18, ' ') -- codice fiscale
          || 'N'                                       -- flg_fornitore_estero
          || RPAD (NVL (s.cod_iban, ' '), 27, '0')              -- codice iban
          || RPAD (NVL (s.desc_afavore, ' '), 67, ' ')      -- ragione sociale
          || RPAD (' ', 20, ' ')                             -- partita iva UE
          || RPAD (' ', 18, ' ')                       -- partita iva extra UE
          || 'N'                                     -- flg fornitore extra UE
          || RPAD (' ', 11, ' ')                               -- codice SWIFT
          || RPAD ('IT', 2, ' ')                               -- codice paese
          || RPAD (' ', 90, ' ')                                     -- filler
             line
     FROM spese s
    WHERE 0 = 0
   ---
   /*************************************
   ***
   *** 2 - DOCUMENTO
   ***
   /*************************************/
   ---
   UNION ALL
   ---
   SELECT SUBSTR (s.cod_autorizzazione, 1, 4) cod_sap_societa,
          2 val_ordine_tipo_record,
          DENSE_RANK () OVER (ORDER BY s.cod_autorizzazione) val_progressivo,
             --------
             ' DO'                                              -- tipo record
          || LPAD (DENSE_RANK () OVER (ORDER BY s.cod_autorizzazione), 5, 0) -- progressivo
          || '9'                                             -- modalità invio
          || RPAD (s.val_numero_fattura, 35, ' ')           -- nmero documento
          || TO_CHAR (s.dta_fattura, 'yyyymmdd')             -- data emissione
          || RPAD (' ', 8, ' ')                              -- data ricezione
          || RPAD (d.val_doc_name, 36, ' ')           -- fielname pdf allegato
          || LPAD (1, 2, '0')                    -- numero pagine pdf allegato
          || ' '                                            -- flg riemissione
          || CASE
                WHEN s.flg_spesa_recuperata IN ('Y', 'S') THEN 'FATL'
                WHEN s.importo_ritenuta > 0 THEN 'FRIT'
                ELSE 'FATD'
             END                                            -- tipo flusso MCT
          || 'N'                                            -- nota di credito
          || s.cod_autorizzazione                            -- codice a barre
          || ' '                                                   -- priorità
          || NVL (TO_CHAR (s.dta_fattura, 'yyyy'), LPAD (' ', 4, ' ')) -- anno competenza
          || DECODE (s.flg_fattura_digitale, 'N', 'X', ' ') -- segue originale
          || RPAD (s.cod_matricola, 10, ' ')             -- utente approvatore
          || RPAD (' ', 144, ' ')                                    -- filler
             line
     FROM spese s, t_mcres_app_documenti d
    WHERE     0 = 0
          AND s.cod_abi = d.cod_abi
          AND s.cod_ndg = d.cod_ndg
          AND NVL (s.cod_autorizzazione_padre, s.cod_autorizzazione) =
                 d.cod_identificativo
          AND d.cod_tipo_documento = 'DO'
   ---
   /*************************************
   ***
   *** 3 - INDICE DOCUMENTO
   ***
   /*************************************/
   ---
   UNION ALL
   ---
   SELECT SUBSTR (s.cod_autorizzazione, 1, 4) cod_sap_societa,
          3 val_ordine_tipo_record,
          DENSE_RANK () OVER (ORDER BY s.cod_autorizzazione) val_progressivo,
             --------
             ' DI'                                              -- tipo record
          || LPAD (DENSE_RANK () OVER (ORDER BY s.cod_autorizzazione), 5, 0) -- progressivo
          || RPAD (' ', 5, ' ')                          -- progressivo indice
          || RPAD (' ', 10, ' ')                              -- numero ordine
          || RPAD (c.val_cdc_banca, 10, ' ')                -- centro di costo
          || RPAD (
                DECODE (s.flg_spesa_ripetibile,
                        'S', c.val_spesa_rip,
                        'N', c.val_spesa_non_rip,
                        ' '),
                10,
                ' ')                                             -- conto GOGE
          || RPAD (' ', 24, ' ')                               -- elemento WBS
          || LPAD (NVL (f.val_imponibile_iva * 100, 0), 13, '0') -- imponibile IVA
          || RPAD (NVL (f.cod_sap_iva, ' '), 2, ' ')         -- codice SAP IVA
          || LPAD (NVL (f.val_aliquota_iva * 100, 0), 8, '0')  -- aliquota IVA
          || LPAD (NVL (f.val_importo_iva * 100, 0), 13, '0')   -- importo IVA
          || LPAD (NVL (f.val_importo_pos * 100, 0), 13, '0') -- importo posizione
          || RPAD ('0', 13, '0')                                   -- quantità
          || RPAD ('0', 13, '0')                               -- prezzo netto
          || RPAD (' ', 13, ' ')                                  -- numero EM
          || RPAD (' ', 99, ' ')                                     -- filler
             line
     FROM spese s, t_mcres_app_sp_fatture f, t_mcres_cnf_fatture_sap c
    WHERE     0 = 0
          AND s.cod_autorizzazione = f.cod_autorizzazione
          AND s.cod_abi = c.cod_abi
          AND s.cod_uo = c.cod_uo
   ---
   /*************************************
   ***
   ***  4 - ALLEGATO
   ***
   /*************************************/
   ---
   UNION ALL
   ---
   SELECT SUBSTR (s.cod_autorizzazione, 1, 4) cod_sap_societa,
          4 val_ordine_tipo_record,
          DENSE_RANK () OVER (ORDER BY s.cod_autorizzazione) val_progressivo,
             --------
             ' AL'                                              -- tipo record
          || LPAD (COUNT (1) OVER (ORDER BY s.cod_autorizzazione), 5, 0) -- progressivo
          || LPAD (1, 5, '0')                          -- progressivo allegato
          || RPAD (' ', 8, ' ')                              -- data ricezione
          || RPAD (d.val_doc_name, 36, ' ')           -- filename pdf allegato
          || LPAD (1, 2, '0')                    -- numero pagine pdf allegato
          || ' '                                            -- flg riemissione
          || TO_CHAR (s.dta_fattura, ' yyyymmdd')            -- data emissione
          || RPAD (' ', 212, ' ')                                    -- filler
             line
     FROM spese s, t_mcres_app_documenti d
    WHERE     0 = 0
          AND s.cod_abi = d.cod_abi(+)
          AND s.cod_ndg = d.cod_ndg(+)
          AND s.cod_autorizzazione = d.cod_aut_protoc(+)
          AND d.cod_tipo_documento(+) = 'AL'
          AND d.cod_stato(+) IN ('CO', 'TR')
          AND NOT EXISTS -- scarto l'allegato in stato TR se ne esiste uno in stato CO
                     (SELECT 1
                        FROM t_mcres_app_documenti dd
                       WHERE     0 = 0
                             AND dd.cod_abi = d.cod_abi
                             AND dd.cod_ndg = d.cod_ndg
                             AND dd.cod_identificativo = d.cod_identificativo
                             AND dd.cod_tipo_documento = 'AL'
                             AND dd.cod_stato = 'CO'
                             AND dd.id_object != d.id_object)
   ---
   /*************************************
   ***
   ***  5 - TOTALE DOCUMENTO
   ***
   /*************************************/
   ---
   UNION ALL
   ---
   SELECT SUBSTR (s.cod_autorizzazione, 1, 4) cod_sap_societa,
          5 val_ordine_tipo_record,
          DENSE_RANK () OVER (ORDER BY s.cod_autorizzazione) val_progressivo,
             --------
             ' TD'                                              -- tipo record
          || LPAD (DENSE_RANK () OVER (ORDER BY s.cod_autorizzazione), 5, 0) -- progressivo
          || LPAD (NVL (s.val_importo_valore * 100, '0'), 20, '0') -- totale lordo fattura
          || RPAD (NVL (s.cod_importo_divisa, ' '), 3, ' ')          -- divisa
          || LPAD (NVL (f.val_totale_imponibile * 100, '0'), 20, '0') -- totale imponibile
          || LPAD (NVL (s.importo_iva * 100, '0'), 20, '0')      -- totale IVA
          || LPAD (NVL (s.aliquota_cpa * 100, '0'), 20, '0')   -- aliquota CPA
          || LPAD (NVL (s.importo_cpa * 100, '0'), 20, '0')     -- importo CPA
          || LPAD (NVL (s.val_aliquota_ritenuta * 100, '0'), 20, '0') -- aliquota RA
          || LPAD (NVL (s.importo_ritenuta * 100, '0'), 20, '0') -- importo RA
          || LPAD (
                NVL (
                     (  f.val_totale_imponibile
                      + s.importo_iva
                      + s.importo_cpa
                      - s.importo_ritenuta)
                   * 100,
                   '0'),
                20,
                '0')                                     -- netto da liquidare
          || LPAD ('0', 20, '0')                             -- aliquota CPA 2
          || LPAD ('0', 20, '0')                              -- importo CPA 2
          || RPAD (' ', 69, ' ')                                     -- filler
             line
     FROM spese s,
          (  SELECT cod_autorizzazione,
                    --                sum(case when f.cod_sap_iva in ('IA', 'I2', 'SM') then  f.val_importo_voce else 0 end) val_imponibile_cpa,
                    --                sum(case when f.cod_sap_iva in ('IA', 'I2') then f.val_importo_voce else 0 end) val_parziale_iva,   --per il totale imponibile IVA sommare l'importo CPA
                    SUM (f.val_importo_voce) val_totale_imponibile
               FROM t_mcres_app_sp_fatture f
           GROUP BY cod_autorizzazione) f
    WHERE 0 = 0 AND s.cod_autorizzazione = f.cod_autorizzazione
   ---
   /*************************************
   ***
   ***  6- PROTOCOLLI
   ***
   /*************************************/
   ---
   UNION ALL
   ---
   SELECT SUBSTR (s.cod_autorizzazione, 1, 4) cod_sap_societa,
          6 val_ordine_tipo_record,
          ROW_NUMBER () OVER (ORDER BY s.cod_autorizzazione) val_progressivo,
             --------
             ' PR'                                              -- tipo record
          || LPAD (DENSE_RANK () OVER (ORDER BY s.cod_autorizzazione), 5, 0) -- progressivo
          || s.cod_autorizzazione                        -- numero prot arrivo
          || RPAD (' ', 16, ' ')               -- numero prot arrivo sotituito
          || RPAD (' ', 13, ' ')                                 -- id scatola
          || SUBSTR (s.cod_autorizzazione, 1, 4)             -- codice società
          || RPAD (' ', 10, ' ')                 -- numero documento contabile
          || RPAD (' ', 4, ' ')                                   -- esercizio
          || RPAD (' ', 209, ' ')                                    -- filler
             line
     FROM spese s
    WHERE 0 = 0;
