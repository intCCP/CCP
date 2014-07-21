/* Formatted on 17/06/2014 18:13:25 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_BODY_SAP_ITF
(
   COD_SAP_SOCIETA,
   VAL_ORDINE_TIPO_RECORD,
   VAL_PROGRESSIVO,
   LINE
)
AS
   WITH spese
        AS (SELECT --+ materialize
                  ROW_NUMBER () OVER (ORDER BY cod_autorizzazione)
                      val_progressivo,
                   s.*
              FROM t_mcres_app_spese_itf s
             WHERE     0 = 0
                   AND s.cod_abi = SYS_CONTEXT ('userenv', 'client_info')
                   AND s.flg_inviata_sap = 0
                   -- escludo INVIO SPESE SU MEDIO CREDITO ABI 10637
                   AND s.cod_abi != '10637'
                   AND s.cod_tipo_autorizzazione IN ('1', '6')
                   AND s.cod_autorizzazione_padre IS NULL
                   --AND s.flg_spesa_recuperata = 0
                   AND EXISTS
                          (SELECT 1
                             FROM t_mcres_app_sp_spese sp,
                                  t_mcres_app_contropartite_itf c
                            WHERE     0 = 0
                                  AND sp.cod_autorizzazione =
                                         s.cod_autorizzazione
                                  AND c.cod_autorizzazione =
                                         sp.cod_autorizzazione
                                  AND sp.flg_contabilizzata = 1
                                  AND sp.cod_stato = 'CO'
                                  AND sp.flg_source = 'ITF'
                                  AND c.cod_tipo = '1'
                           UNION
                           SELECT 1
                             FROM t_mcres_app_sp_spese sp,
                                  t_mcres_app_contropartite_itf c
                            WHERE     0 = 0
                                  AND sp.cod_autorizzazione =
                                         s.cod_autorizzazione
                                  AND c.cod_autorizzazione =
                                         sp.cod_autorizzazione
                                  AND sp.cod_stato = 'CO'
                                  AND sp.flg_source = 'ITF'
                                  AND c.cod_tipo != '1')
                   AND NOT EXISTS -- esclude spese con addebito su posizioni cartolarizzate
                              (SELECT 1
                                 FROM t_mcres_app_contropartite_itf c
                                WHERE     c.cod_autorizzazione =
                                             s.cod_autorizzazione
                                      AND c.cod_tipo IN ('7', '8')))
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
   ---
   /*************************************
   ***
   *** 1 - DOCUMENTO
   ***
   /*************************************/
   ---
   UNION ALL
   ---
   SELECT SUBSTR (s.cod_autorizzazione, 1, 4) cod_sap_societa,
          1 val_ordine_tipo_record,
          s.val_progressivo,
             --------
             ' FO'                                              -- tipo record
          || LPAD (s.val_progressivo, 5, 0)                     -- progressivo
          || RPAD (COALESCE (s.desc_cfpiva_legale, s.val_afavore_piva, ' '),
                   18,
                   ' ')                                         -- partita iva
          || RPAD (
                COALESCE (s.val_afavore_codfisc, s.desc_cfpiva_legale, ' '),
                18,
                ' ')                                         -- codice fiscale
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
          s.val_progressivo,
             --------
             ' DO'                                              -- tipo record
          || LPAD (s.val_progressivo, 5, 0)                     -- progressivo
          || 'A'                                       -- modalitÿ?ÿ  invio
          || RPAD (s.val_numero_fattura, 35, ' ')           -- nmero documento
          || TO_CHAR (s.dta_fattura, 'yyyymmdd')             -- data emissione
          || RPAD (' ', 8, ' ')                              -- data ricezione
          || RPAD (s.desc_file_fatt, 36, ' ')         -- fielname pdf allegato
          || LPAD (s.val_pag_fatt, 2, '0')       -- numero pagine pdf allegato
          || ' '                                            -- flg riemissione
          --|| case when s.flg_spesa_recuperata = 1 then 'FATL' when s.val_imp_ritacc > 0 then 'FRIT' else 'FATD' end     -- tipo flusso MCT
          || pkg_mcres_interfaccia_itf_sap.fnc_calcolo_mct (
                val_afavore_codfisc,
                val_afavore_piva)                     -- nuovo tipo flusso MCT
          || 'N'                                            -- nota di credito
          || s.cod_autorizzazione                            -- codice a barre
          || ' '                                             -- prioritÿ?ÿ 
          || NVL (TO_CHAR (s.dta_fattura, 'yyyy'), LPAD (' ', 4, ' ')) -- anno competenza
          || DECODE (s.flg_digitale, 0, 'X', ' ')           -- segue originale
          || RPAD (s.val_matr_autoriz, 10, ' ')          -- utente approvatore
          || RPAD (' ', 144, ' ')                                    -- filler
             line
     FROM spese s
    WHERE 0 = 0
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
          s.val_progressivo,
             --------
             ' DI'                                              -- tipo record
          || LPAD (s.val_progressivo, 5, 0)                     -- progressivo
          || RPAD (' ', 5, ' ')                          -- progressivo indice
          || RPAD (' ', 10, ' ')                              -- numero ordine
          || RPAD (c.val_cdc_itf, 10, ' ')                  -- centro di costo
          || RPAD (
                DECODE (s.flg_spesa_ripetibile,
                        '1', c.val_spesa_rip,
                        '0', c.val_spesa_non_rip,
                        ' '),
                10,
                ' ')                                             -- conto GOGE
          || RPAD (' ', 24, ' ')                               -- elemento WBS
          || LPAD (f.val_imponibile_iva * 100, 13, '0')      -- imponibile IVA
          || RPAD (NVL (f.cod_sap_iva, ' '), 2, ' ')         -- codice SAP IVA
          || LPAD (f.val_aliquota_iva * 100, 8, '0')           -- aliquota IVA
          || LPAD (f.val_importo_iva * 100, 13, '0')            -- importo IVA
          || LPAD (f.val_importo_pos * 100, 13, '0')      -- importo posizione
          || RPAD ('0', 13, '0')                             -- quantitÿ?ÿ 
          || RPAD ('0', 13, '0')                               -- prezzo netto
          || RPAD (' ', 13, ' ')                                  -- numero EM
          || RPAD (' ', 99, ' ')                                     -- filler
             line
     FROM spese s, t_mcres_app_fatture_itf f, t_mcres_cnf_fatture_sap c
    WHERE     0 = 0
          AND s.cod_autorizzazione = f.cod_autorizzazione
          -- AP 31/01/2014 aggiunto filtro imponibile != 0
          AND f.val_imponibile_iva <> 0
          -- AP 11/02/2014 aggiunto filtro cod_sap_iva != 0
          AND f.cod_sap_iva <> '0'
          AND s.cod_abi = c.cod_abi
          AND c.val_cdc_itf IS NOT NULL
          AND c.cod_uo IS NULL
          AND c.flg_attivo = 1
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
          s.val_progressivo,
             --------
             ' AL'                                              -- tipo record
          || LPAD (s.val_progressivo, 5, 0)                     -- progressivo
          || LPAD (1, 5, '0')                          -- progressivo allegato
          || RPAD (' ', 8, ' ')                              -- data ricezione
          || RPAD (s.desc_file_nosta, 36, ' ')        -- filename pdf allegato
          || LPAD (s.val_pag_nosta, 2, '0')      -- numero pagine pdf allegato
          || ' '                                            -- flg riemissione
          || TO_CHAR (s.dta_nosta, ' yyyymmdd')              -- data emissione
          || RPAD (' ', 212, ' ')                                    -- filler
             line
     FROM spese s
    WHERE 0 = 0
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
          s.val_progressivo,
             --------
             ' TD'                                              -- tipo record
          || LPAD (s.val_progressivo, 5, 0)                     -- progressivo
          || LPAD (NVL (s.val_importo_valore * 100, '0'), 20, '0') -- totale lordo fattura
          || RPAD (NVL (s.cod_causa_divisa, ' '), 3, ' ')            -- divisa
          || LPAD (NVL (s.val_tot_imp * 100, '0'), 20, '0') -- totale imponibile
          || LPAD (NVL (s.val_tot_iva * 100, '0'), 20, '0')      -- totale IVA
          || LPAD (NVL (s.val_aliq_contrprev * 100, '0'), 20, '0') -- aliquota CPA
          || LPAD (NVL (s.val_imp_contrprev * 100, '0'), 20, '0') -- importo CPA
          || LPAD (NVL (s.val_aliq_ritacc * 100, '0'), 20, '0') -- aliquota RA
          || LPAD (NVL (s.val_imp_ritacc * 100, '0'), 20, '0')   -- importo RA
          || LPAD (NVL (s.val_tot_netdaliq * 100, '0'), 20, '0') -- netto da liquidare
          || LPAD ('0', 20, '0')                             -- aliquota CPA 2
          || LPAD ('0', 20, '0')                              -- importo CPA 2
          || RPAD (' ', 69, ' ')                                     -- filler
             line
     FROM spese s
    WHERE 0 = 0
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
          s.val_progressivo,
             --------
             ' PR'                                              -- tipo record
          || LPAD (s.val_progressivo, 5, 0)                     -- progressivo
          || s.cod_autorizzazione                        -- numero prot arrivo
          || RPAD (' ', 16, ' ')               -- numero prot arrivo sotituito
          || RPAD (' ', 13, ' ')                                 -- id scatola
          || SUBSTR (s.cod_autorizzazione, 1, 4)       -- codice societÿ?ÿ 
          || RPAD (' ', 10, ' ')                 -- numero documento contabile
          || RPAD (' ', 4, ' ')                                   -- esercizio
          || RPAD (' ', 209, ' ')                                    -- filler
             line
     FROM spese s
    WHERE 0 = 0;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_WRK_BODY_SAP_ITF TO MCRE_USR;
