/* Formatted on 21/07/2014 18:33:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ARCHIVIO_MAT
(
   DTA_UPD,
   COD_RAMO_CALCOLATO,
   COD_DIVISIONE,
   COD_COMPARTO,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   COD_PROCESSO,
   COD_PROCESSO_MESE_PRE,
   SCGB_COD_STATO_SIS,
   COD_STATO_SIS_MESE_PRE,
   COD_STATO,
   COD_STATO_PRE,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   NUM_GG_SERVIZIO,
   NUM_GG_SCONFINO,
   COD_TIPO_PORTAFOGLIO,
   DESC_TIPO_PORT,
   SCSB_ACC_CASSA,
   SCSB_ACC_FIRMA,
   SCSB_ACC_SOSTITUZIONI,
   SCSB_ACC_TOT,
   SCSB_UTI_CASSA,
   SCSB_UTI_FIRMA,
   SCSB_UTI_SOSTITUZIONI,
   SCSB_UTI_TOT,
   SCGB_ACC_TOT,
   SCGB_UTI_TOT,
   GEB_ACC_TOT,
   GEGB_UTI_TOT,
   GB_VAL_MAU,
   COD_MATRICOLA,
   COGNOME,
   DTA_UTENTE_ASSEGNATO,
   COD_RAE,
   COD_SAE,
   COD_SEGMENTO_REGOLAMENTARE,
   VAL_UTI_CASSA_SISBA,
   VAL_UTI_FIRMA_SISBA,
   VAL_TOT_MORA_SISBA,
   VAL_TOT_RATEO_SISBA,
   VAL_TOT_UTI_SISBA,
   VAL_DUBBIO_ESITO_CASSA_SISBA,
   VAL_DUBBIO_ESITO_FIRMA_SISBA,
   VAL_DUBBIO_ATT_SISBA,
   VAL_DUBBIO_ESITO_DERIVATI,
   VAL_TOT_DUBBIO_ESITO_NT_ATT,
   DTA_ULTIMA_REVISIONE_PEF,
   COD_ULTIMO_ODE,
   DTA_ULTIMA_DELIBERA,
   VAL_TIPO_DELIBERA,
   VAL_RETTIFICA_DELIBERA,
   VAL_OD_ULTIMA_DELIBERA,
   VAL_OD_ULTIMA_DELIBERA_NOTE
)
AS
   WITH ex2
        AS (SELECT /*+ NOPARALLEL(d) */
                  d.cod_abi_Cartolarizzato,
                   d.cod_ndg,
                   NVL (
                      CASE
                         WHEN cod_stato = 'IN'
                         THEN
                            NVL (pr.dta_decorrenza_stato,
                                 d.dta_decorrenza_stato)
                         WHEN cod_stato = 'SO'
                         THEN
                            NVL (
                               DECODE (
                                  pr.dta_fine_stato,
                                  TO_DATE ('31/12/9999', 'DD/MM/YYYY'), pr.dta_decorrenza_stato,
                                  (pr.dta_fine_stato + 1)),
                               d.dta_decorrenza_stato)
                         ELSE
                            d.dta_decorrenza_stato
                      END,
                      d.dta_decorrenza_stato)
                      dta_decorrenza_stato
              -- dta_apertura
              FROM (  SELECT pr.cod_abi,
                             pr.cod_ndg,
                             MIN (pr.dta_decorrenza_stato) dta_decorrenza_stato,
                             MIN (pr.dta_fine_stato) dta_fine_stato
                        FROM (  SELECT pr.cod_abi,
                                       pr.cod_ndg,
                                       MAX (pr.dta_decorrenza_stato)
                                          dta_decorrenza_stato,
                                       NULL dta_fine_stato
                                  FROM t_mcrei_app_pratiche pr
                                 WHERE dta_fine_stato =
                                          TO_DATE ('31/12/9999', 'DD/MM/YYYY')
                              GROUP BY cod_abi, cod_ndg
                              UNION ALL
                                SELECT pr.cod_abi,
                                       pr.cod_ndg,
                                       NULL dta_decorrenza_stato,
                                       MAX (pr.dta_fine_stato) dta_fine_stato
                                  FROM t_mcrei_app_pratiche pr
                                 WHERE dta_fine_stato !=
                                          TO_DATE ('31/12/9999', 'DD/MM/YYYY')
                              GROUP BY cod_abi, cod_ndg) pr
                    GROUP BY pr.cod_abi, pr.cod_ndg) pr,
                   t_mcre0_app_all_data PARTITION (ccp_p1) d
             WHERE     pr.cod_abi(+) = d.cod_abi_cartolarizzato
                   AND pr.cod_ndg(+) = d.cod_ndg
                   AND today_flg = '1'
                   AND d.cod_stato IN ('IN', 'SO')
                   AND flg_outsourcing IN ('Y', 'N'))
   SELECT /*+ NOPARALLEL(xx) */
         TO_CHAR (SYSDATE, 'DDMMYY') DTA_UPD,
          XX.COD_RAMO_CALCOLATO,
          DECODE (XX.COD_RAMO_CALCOLATO,
                  '000001', 'CIB',
                  '000002', 'Bdt',
                  NULL)
             COD_DIVISIONE,
          XX.COD_COMPARTO,
          XX.COD_ABI_CARTOLARIZZATO,
          XX.COD_ABI_ISTITUTO,
          XX.COD_STRUTTURA_COMPETENTE_DC,
          XX.COD_STRUTTURA_COMPETENTE_RG,
          XX.COD_STRUTTURA_COMPETENTE_AR,
          XX.COD_STRUTTURA_COMPETENTE_FI,
          XX.COD_NDG,
          G.DESC_NOME_CONTROPARTE,
          XX.COD_SNDG,
          XX.COD_GRUPPO_ECONOMICO,
          XX.DESC_GRUPPO_ECONOMICO VAL_ANA_GRE,
          XX.COD_PROCESSO,
          E.COD_PROCESSO COD_PROCESSO_MESE_PRE,
          -- Processo fine mese precedente
          G.SCGB_COD_STATO_SIS,
          --MACROSTATO RISCHIO ATTUALE
          E.SCGB_COD_STATO_SIS COD_STATO_SIS_MESE_PRE,
          --Macrostato rischio mese precedente
          XX.COD_STATO,
          E.COD_STATO COD_STATO_PRE,
          ex2.DTA_DECORRENZA_STATO,
          XX.DTA_SCADENZA_STATO,
          TRUNC (SYSDATE) - TRUNC (XX.DTA_SERVIZIO) NUM_GG_SERVIZIO,
          G.VAL_SCONFINO NUM_GG_SCONFINO,
          XX.COD_TIPO_PORTAFOGLIO,
          T.DESC_TIPO_PORT,
          G.SCSB_ACC_CASSA,
          G.SCSB_ACC_FIRMA,
          NULL SCSB_ACC_SOSTITUZIONI,
          G.SCSB_ACC_TOT,
          G.SCSB_UTI_CASSA,
          G.SCSB_UTI_FIRMA,
          NULL SCSB_UTI_SOSTITUZIONI,
          G.SCSB_UTI_TOT,
          G.SCGB_ACC_CASSA + G.SCGB_ACC_FIRMA SCGB_ACC_TOT,
          G.SCGB_UTI_CASSA + G.SCGB_UTI_FIRMA SCGB_UTI_TOT,
          G.GEGB_ACC_CASSA + G.GEGB_ACC_FIRMA GEB_ACC_TOT,
          G.GEGB_UTI_CASSA + G.GEGB_UTI_FIRMA GEGB_UTI_TOT,
          G.GB_VAL_MAU,
          --????
          XX.COD_MATRICOLA,
          XX.COGNOME,
          XX.DTA_UTENTE_ASSEGNATO,
          NULL COD_RAE,
          NULL COD_SAE,
          NULL COD_SEGMENTO_REGOLAMENTARE,
          NULL VAL_UTI_CASSA_SISBA,
          NULL VAL_UTI_FIRMA_SISBA,
          NULL VAL_TOT_MORA_SISBA,
          NULL VAL_TOT_RATEO_SISBA,
          NULL VAL_TOT_UTI_SISBA,
          NULL VAL_DUBBIO_ESITO_CASSA_SISBA,
          NULL VAL_DUBBIO_ESITO_FIRMA_SISBA,
          NULL VAL_DUBBIO_ATT_SISBA,
          NULL VAL_DUBBIO_ESITO_DERIVATI,
          NULL VAL_TOT_DUBBIO_ESITO_NT_ATT,
          G.DTA_ULTIMA_REVISIONE_PEF,
          G.COD_ULTIMO_ODE,
          NULL DTA_ULTIMA_DELIBERA,
          NULL VAL_TIPO_DELIBERA,
          NULL VAL_RETTIFICA_DELIBERA,
          NULL VAL_OD_ULTIMA_DELIBERA,
          NULL VAL_OD_ULTIMA_DELIBERA_NOTE
     FROM T_MCRE0_APP_TIPI_PORTAFOGLIO T,
          V_MCRE0_APP_UPD_FIELDS XX,
          MV_MCRE0_ANAGRAFICA_GENERALE G,
          T_MCRE0_APP_STORICO_EVENTI E,
          ex2
    WHERE     SUBSTR (E.COD_MESE_HST(+), 1, 6) =
                 TO_CHAR (ADD_MONTHS (TO_DATE (xx.id_dper, 'YYYYMMDD'), -1),
                          'YYYYMM')
          AND E.FLG_CAMBIO_MESE(+) = '1'
          AND XX.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
          AND XX.COD_NDG = G.COD_NDG
          AND XX.COD_TIPO_PORTAFOGLIO = T.COD_TIPO_PORT(+)
          AND XX.COD_ABI_CARTOLARIZZATO = E.COD_ABI_CARTOLARIZZATO(+)
          AND XX.COD_NDG = E.COD_NDG(+)
          AND xx.cod_ndg = ex2.cod_ndg
          AND xx.cod_abi_cartolarizzato = ex2.cod_abi_Cartolarizzato
   UNION ALL
   SELECT /*+ NOPARALLEL(XX) */
         TO_CHAR (SYSDATE, 'DDMMYY') DTA_UPD,
          XX.COD_RAMO_CALCOLATO,
          DECODE (XX.COD_RAMO_CALCOLATO,
                  '000001', 'CIB',
                  '000002', 'Bdt',
                  NULL)
             COD_DIVISIONE,
          XX.COD_COMPARTO,
          XX.COD_ABI_CARTOLARIZZATO,
          XX.COD_ABI_ISTITUTO,
          XX.COD_STRUTTURA_COMPETENTE_DC,
          XX.COD_STRUTTURA_COMPETENTE_RG,
          XX.COD_STRUTTURA_COMPETENTE_AR,
          XX.COD_STRUTTURA_COMPETENTE_FI,
          XX.COD_NDG,
          G.DESC_NOME_CONTROPARTE,
          XX.COD_SNDG,
          XX.COD_GRUPPO_ECONOMICO,
          XX.DESC_GRUPPO_ECONOMICO VAL_ANA_GRE,
          XX.COD_PROCESSO,
          E.COD_PROCESSO COD_PROCESSO_MESE_PRE,
          -- Processo fine mese precedente
          G.SCGB_COD_STATO_SIS,
          --MACROSTATO RISCHIO ATTUALE
          E.SCGB_COD_STATO_SIS COD_STATO_SIS_MESE_PRE,
          --Macrostato rischio mese precedente
          XX.COD_STATO,
          E.COD_STATO COD_STATO_PRE,
          ex.DTA_DECORRENZA_STATO,
          XX.DTA_SCADENZA_STATO,
          TRUNC (SYSDATE) - TRUNC (XX.DTA_SERVIZIO) NUM_GG_SERVIZIO,
          G.VAL_SCONFINO NUM_GG_SCONFINO,
          XX.COD_TIPO_PORTAFOGLIO,
          T.DESC_TIPO_PORT,
          G.SCSB_ACC_CASSA,
          G.SCSB_ACC_FIRMA,
          NULL SCSB_ACC_SOSTITUZIONI,
          G.SCSB_ACC_TOT,
          G.SCSB_UTI_CASSA,
          G.SCSB_UTI_FIRMA,
          NULL SCSB_UTI_SOSTITUZIONI,
          G.SCSB_UTI_TOT,
          G.SCGB_ACC_CASSA + G.SCGB_ACC_FIRMA SCGB_ACC_TOT,
          G.SCGB_UTI_CASSA + G.SCGB_UTI_FIRMA SCGB_UTI_TOT,
          G.GEGB_ACC_CASSA + G.GEGB_ACC_FIRMA GEB_ACC_TOT,
          G.GEGB_UTI_CASSA + G.GEGB_UTI_FIRMA GEGB_UTI_TOT,
          G.GB_VAL_MAU,
          --????
          XX.COD_MATRICOLA,
          XX.COGNOME,
          XX.DTA_UTENTE_ASSEGNATO,
          NULL COD_RAE,
          NULL COD_SAE,
          NULL COD_SEGMENTO_REGOLAMENTARE,
          NULL VAL_UTI_CASSA_SISBA,
          NULL VAL_UTI_FIRMA_SISBA,
          NULL VAL_TOT_MORA_SISBA,
          NULL VAL_TOT_RATEO_SISBA,
          NULL VAL_TOT_UTI_SISBA,
          NULL VAL_DUBBIO_ESITO_CASSA_SISBA,
          NULL VAL_DUBBIO_ESITO_FIRMA_SISBA,
          NULL VAL_DUBBIO_ATT_SISBA,
          NULL VAL_DUBBIO_ESITO_DERIVATI,
          NULL VAL_TOT_DUBBIO_ESITO_NT_ATT,
          G.DTA_ULTIMA_REVISIONE_PEF,
          G.COD_ULTIMO_ODE,
          NULL DTA_ULTIMA_DELIBERA,
          NULL VAL_TIPO_DELIBERA,
          NULL VAL_RETTIFICA_DELIBERA,
          NULL VAL_OD_ULTIMA_DELIBERA,
          NULL VAL_OD_ULTIMA_DELIBERA_NOTE
     FROM T_MCRE0_APP_TIPI_PORTAFOGLIO T,
          V_MCRE0_APP_UPD_FIELDS XX,
          MV_MCRE0_ANAGRAFICA_GENERALE G,
          T_MCRE0_APP_STORICO_EVENTI E,
          (SELECT /*+ NOPARALLEL(d) */
                 d.cod_abi_Cartolarizzato, d.cod_ndg, d.dta_decorrenza_stato
             -- dta_apertura
             FROM t_mcre0_app_all_data PARTITION (ccp_p1) d
            WHERE today_flg = '1' AND d.cod_stato NOT IN ('IN', 'SO')) ex
    WHERE     SUBSTR (E.COD_MESE_HST(+), 1, 6) =
                 TO_CHAR (ADD_MONTHS (TO_DATE (xx.id_dper, 'YYYYMMDD'), -1),
                          'YYYYMM')
          AND E.FLG_CAMBIO_MESE(+) = '1'
          AND XX.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
          AND XX.COD_NDG = G.COD_NDG
          AND XX.COD_TIPO_PORTAFOGLIO = T.COD_TIPO_PORT(+)
          AND XX.COD_ABI_CARTOLARIZZATO = E.COD_ABI_CARTOLARIZZATO(+)
          AND XX.COD_NDG = E.COD_NDG(+)
          AND xx.cod_ndg = ex.cod_ndg
          AND xx.cod_abi_cartolarizzato = ex.cod_abi_Cartolarizzato;
