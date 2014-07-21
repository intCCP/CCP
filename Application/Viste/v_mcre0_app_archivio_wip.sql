/* Formatted on 21/07/2014 18:33:18 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ARCHIVIO_WIP
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
   VAL_OD_ULTIMA_DELIBERA_NOTE,
   GG_PERMANENZA_STATO,
   GG_SCONFINO,
   SCONFINO_SOPRA_SOGLIA,
   LIV_RISCHIO_CLI,
   TIPO_PRATICA,
   FASE,
   DESC_INCAGLIO_AUTOMATICO,
   PARTE_CORRELATA,
   PARTE_CORRELATA_IAS,
   ARTICOLO_136,
   SOGGETTO_COLLEGATO
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
          NULL VAL_OD_ULTIMA_DELIBERA_NOTE,
            --03/12/13 CAMPI NUOVI per BRB 3-28
            --          CASE
            --             WHEN XX.cod_macrostato IN ('RIO')
            --                  AND XX.cod_comparto_calcolato = '011901'
            --             THEN
            --                (SELECT DECODE (
            --                           rio.dta_esito,
            --                           NULL, XX.dta_servizio + XX.val_gg_prima_proroga,
            --                           rio.dta_esito + XX.val_gg_seconda_proroga)
            --                   FROM t_mcre0_app_rio_proroghe rio
            --                  WHERE XX.cod_abi_cartolarizzato =
            --                           rio.cod_abi_cartolarizzato(+)
            --                        AND XX.cod_ndg = rio.cod_ndg(+)
            --                        AND rio.flg_storico(+) = '0'
            --                        AND rio.flg_esito(+) = '1')
            --             ELSE
            --                XX.dta_servizio + XX.val_gg_prima_proroga
            --          END
            --             dta_scadenza_servizio,
            TRUNC (SYSDATE)
          - CASE
               WHEN XX.cod_stato IN ('IN', 'SO')
               THEN
                  (SELECT NVL (
                             CASE
                                WHEN XX.cod_stato = 'IN'
                                THEN
                                   pr.dta_decorrenza_stato
                                WHEN XX.cod_stato = 'SO'
                                THEN
                                   DECODE (
                                      pr.dta_fine_stato,
                                      TO_DATE ('31/12/9999', 'DD/MM/YYYY'), XX.dta_decorrenza_stato,
                                      (pr.dta_fine_stato + 1))
                                ELSE
                                   XX.dta_decorrenza_stato
                             END,
                             XX.dta_decorrenza_stato)
                     -- dta_apertura
                     FROM (SELECT cod_abi,
                                  cod_ndg,
                                  dta_fine_stato,
                                  dta_decorrenza_stato
                             FROM (SELECT p.cod_abi,
                                          p.cod_ndg,
                                          dta_fine_stato,
                                          dta_decorrenza_stato,
                                          RANK ()
                                          OVER (
                                             PARTITION BY cod_abi, cod_ndg
                                             ORDER BY
                                                   val_anno_pratica
                                                || cod_pratica DESC)
                                             r
                                     FROM t_mcrei_app_pratiche p
                                    WHERE flg_attiva = 1)
                            WHERE r = 1) pr
                    WHERE     pr.cod_abi(+) = XX.cod_abi_cartolarizzato
                          AND pr.cod_ndg(+) = XX.cod_ndg)
               ELSE
                  XX.dta_decorrenza_stato
            END
             gg_permanenza_stato,
          SAB.NUM_GIORNI_SCONFINO AS GG_SCONFINO,
          SAB.FLG_SOGLIA AS SCONFINO_SOPRA_SOGLIA,
          NVL (IRIS.VAL_LIV_RISCHIO_CLI, 'ND') liv_rischio_cli,
          az.TIPO_PRATICA AS TIPO_PRATICA,
          az.FASE AS FASE,
          CASE
             WHEN XX.cod_stato = 'IN'
             THEN
                (SELECT desc_note
                   FROM (SELECT cod_abi,
                                cod_ndg,
                                desc_note,
                                RANK ()
                                OVER (
                                   PARTITION BY cod_abi, cod_ndg
                                   ORDER BY dta_ins, dta_upd DESC NULLS LAST)
                                   r
                           FROM t_mcrei_app_delibere
                          WHERE     flg_attiva = '1'
                                AND cod_fase_delibera <> 'AN'
                                AND cod_microtipologia_delib = 'CI') d
                  WHERE     d.r = 1
                        AND XX.cod_abi_cartolarizzato = d.cod_abi
                        AND XX.cod_ndg = d.cod_ndg)
             ELSE
                NULL
          END
             AS DESC_INCAGLIO_AUTOMATICO,
          DECODE (pc_new.cod_abi, NULL, 'N', 'S') PARTE_CORRELATA,
          DECODE (SUBSTR (pc_new.flg_rilevanza_normativa, 3, 1),
                  NULL, 'N',
                  'R', 'S',
                  'N')
             PARTE_CORRELATA_IAS,
          a.flg_art_136 AS ARTICOLO_136,
          DECODE (pc_new.cod_abi, NULL, 'N', 'S') SOGGETTO_COLLEGATO --duplicata logica PARTE_CORRELATA
     FROM T_MCRE0_APP_TIPI_PORTAFOGLIO T,
          V_MCRE0_APP_UPD_FIELDS XX,
          MV_MCRE0_ANAGRAFICA_GENERALE G,
          T_MCRE0_APP_STORICO_EVENTI E,
          ex2,
          t_mcre0_app_sab_xra sab,
          t_mcre0_app_iris iris,
          t_mcres_app_parti_corr pc_new,
          (SELECT pf.*, cl_p.desc_tipo TIPO_PRATICA, cl_f.desc_tipo FASE
             FROM (SELECT *
                     FROM (SELECT pf.*,
                                  RANK ()
                                  OVER (
                                     PARTITION BY cod_abi_cartolarizzato,
                                                  cod_ndg
                                     ORDER BY dta_ins DESC)
                                     r
                             FROM t_MCRE0_APP_GEST_PRATICA_FASI pf
                            WHERE pf.flg_delete = 'N')
                    WHERE r = 1) pf,
                  (SELECT *
                     FROM T_MCRE0_CL_GEST
                    WHERE val_utilizzo = 'TIPOLOGIA_PRATICA') cl_p,
                  (SELECT *
                     FROM T_MCRE0_CL_GEST
                    WHERE val_utilizzo = 'FASE') cl_f
            WHERE     pf.ID_TIPOLOGIA_PRATICA = cl_p.COD_TIPO(+)
                  AND pf.ID_TIPOLOGIA_PRATICA = cl_f.COD_TIPO(+)) az,
          t_mcre0_app_anagrafica_gruppo a
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
          AND XX.cod_abi_cartolarizzato = sab.cod_abi_cartolarizzato(+)
          AND XX.cod_ndg = sab.cod_ndg(+)
          AND XX.COD_SNDG = IRIS.COD_SNDG(+)
          AND XX.cod_abi_cartolarizzato = az.cod_abi_cartolarizzato(+)
          AND XX.cod_ndg = az.cod_ndg(+)
          AND XX.cod_macrostato = az.cod_macrostato(+)
          AND XX.cod_sndg = a.cod_sndg
          AND xx.cod_abi_istituto = pc_new.cod_abi(+)
          AND xx.cod_sndg = pc_new.cod_sndg_sogg_connesso(+)
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
          xx.DTA_DECORRENZA_STATO,
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
          NULL VAL_OD_ULTIMA_DELIBERA_NOTE,
            --03/12/13 CAMPI NUOVI per BRB 3-28
            --          CASE
            --             WHEN XX.cod_macrostato IN ('RIO')
            --                  AND XX.cod_comparto_calcolato = '011901'
            --             THEN
            --                (SELECT DECODE (
            --                           rio.dta_esito,
            --                           NULL, XX.dta_servizio + XX.val_gg_prima_proroga,
            --                           rio.dta_esito + XX.val_gg_seconda_proroga)
            --                   FROM t_mcre0_app_rio_proroghe rio
            --                  WHERE XX.cod_abi_cartolarizzato =
            --                           rio.cod_abi_cartolarizzato(+)
            --                        AND XX.cod_ndg = rio.cod_ndg(+)
            --                        AND rio.flg_storico(+) = '0'
            --                        AND rio.flg_esito(+) = '1')
            --             ELSE
            --                XX.dta_servizio + XX.val_gg_prima_proroga
            --          END
            --             dta_scadenza_servizio,
            TRUNC (SYSDATE)
          - CASE
               WHEN XX.cod_stato IN ('IN', 'SO')
               THEN
                  (SELECT NVL (
                             CASE
                                WHEN XX.cod_stato = 'IN'
                                THEN
                                   pr.dta_decorrenza_stato
                                WHEN XX.cod_stato = 'SO'
                                THEN
                                   DECODE (
                                      pr.dta_fine_stato,
                                      TO_DATE ('31/12/9999', 'DD/MM/YYYY'), XX.dta_decorrenza_stato,
                                      (pr.dta_fine_stato + 1))
                                ELSE
                                   XX.dta_decorrenza_stato
                             END,
                             XX.dta_decorrenza_stato)
                     -- dta_apertura
                     FROM (SELECT cod_abi,
                                  cod_ndg,
                                  dta_fine_stato,
                                  dta_decorrenza_stato
                             FROM (SELECT p.cod_abi,
                                          p.cod_ndg,
                                          dta_fine_stato,
                                          dta_decorrenza_stato,
                                          RANK ()
                                          OVER (
                                             PARTITION BY cod_abi, cod_ndg
                                             ORDER BY
                                                   val_anno_pratica
                                                || cod_pratica DESC)
                                             r
                                     FROM t_mcrei_app_pratiche p
                                    WHERE flg_attiva = 1)
                            WHERE r = 1) pr
                    WHERE     pr.cod_abi(+) = XX.cod_abi_cartolarizzato
                          AND pr.cod_ndg(+) = XX.cod_ndg)
               ELSE
                  XX.dta_decorrenza_stato
            END
             gg_permanenza_stato,
          SAB.NUM_GIORNI_SCONFINO AS GG_SCONFINO,
          SAB.FLG_SOGLIA AS SCONFINO_SOPRA_SOGLIA,
          NVL (IRIS.VAL_LIV_RISCHIO_CLI, 'ND') liv_rischio_cli,
          az.TIPO_PRATICA AS TIPO_PRATICA,
          az.FASE AS FASE,
          CASE
             WHEN XX.cod_stato = 'IN'
             THEN
                (SELECT desc_note
                   FROM (SELECT cod_abi,
                                cod_ndg,
                                desc_note,
                                RANK ()
                                OVER (
                                   PARTITION BY cod_abi, cod_ndg
                                   ORDER BY dta_ins, dta_upd DESC NULLS LAST)
                                   r
                           FROM t_mcrei_app_delibere
                          WHERE     flg_attiva = '1'
                                AND cod_fase_delibera <> 'AN'
                                AND cod_microtipologia_delib = 'CI') d
                  WHERE     d.r = 1
                        AND XX.cod_abi_cartolarizzato = d.cod_abi
                        AND XX.cod_ndg = d.cod_ndg)
             ELSE
                NULL
          END
             AS DESC_INCAGLIO_AUTOMATICO,
          DECODE (pc_new.cod_abi, NULL, 'N', 'S') PARTE_CORRELATA,
          DECODE (SUBSTR (pc_new.flg_rilevanza_normativa, 3, 1),
                  NULL, 'N',
                  'R', 'S',
                  'N')
             PARTE_CORRELATA_IAS,
          a.flg_art_136 AS ARTICOLO_136,
          DECODE (pc_new.cod_abi, NULL, 'N', 'S') SOGGETTO_COLLEGATO --duplicata logica PARTE_CORRELATA
     FROM T_MCRE0_APP_TIPI_PORTAFOGLIO T,
          V_MCRE0_APP_UPD_FIELDS XX,
          MV_MCRE0_ANAGRAFICA_GENERALE G,
          T_MCRE0_APP_STORICO_EVENTI E,
          (SELECT cod_microstato
             FROM t_mcre0_app_stati s
            WHERE s.cod_microstato NOT IN ('IN', 'SO')) ex,
          t_mcre0_app_sab_xra sab,
          t_mcre0_app_iris iris,
          t_mcres_app_parti_corr pc_new,
          (SELECT pf.*, cl_p.desc_tipo TIPO_PRATICA, cl_f.desc_tipo FASE
             FROM (SELECT *
                     FROM (SELECT pf.*,
                                  RANK ()
                                  OVER (
                                     PARTITION BY cod_abi_cartolarizzato,
                                                  cod_ndg
                                     ORDER BY dta_ins DESC)
                                     r
                             FROM t_MCRE0_APP_GEST_PRATICA_FASI pf
                            WHERE pf.flg_delete = 'N')
                    WHERE r = 1) pf,
                  (SELECT *
                     FROM T_MCRE0_CL_GEST
                    WHERE val_utilizzo = 'TIPOLOGIA_PRATICA') cl_p,
                  (SELECT *
                     FROM T_MCRE0_CL_GEST
                    WHERE val_utilizzo = 'FASE') cl_f
            WHERE     pf.ID_TIPOLOGIA_PRATICA = cl_p.COD_TIPO(+)
                  AND pf.ID_TIPOLOGIA_PRATICA = cl_f.COD_TIPO(+)) az,
          t_mcre0_app_anagrafica_gruppo a
    WHERE     SUBSTR (E.COD_MESE_HST(+), 1, 6) =
                 TO_CHAR (ADD_MONTHS (TO_DATE (xx.id_dper, 'YYYYMMDD'), -1),
                          'YYYYMM')
          AND E.FLG_CAMBIO_MESE(+) = '1'
          AND XX.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
          AND XX.COD_NDG = G.COD_NDG
          AND XX.COD_TIPO_PORTAFOGLIO = T.COD_TIPO_PORT(+)
          AND XX.COD_ABI_CARTOLARIZZATO = E.COD_ABI_CARTOLARIZZATO(+)
          AND XX.COD_NDG = E.COD_NDG(+)
          AND xx.cod_stato = ex.cod_microstato
          AND XX.cod_abi_cartolarizzato = sab.cod_abi_cartolarizzato(+)
          AND XX.cod_ndg = sab.cod_ndg(+)
          AND XX.COD_SNDG = IRIS.COD_SNDG(+)
          AND XX.cod_abi_cartolarizzato = az.cod_abi_cartolarizzato(+)
          AND XX.cod_ndg = az.cod_ndg(+)
          AND XX.cod_macrostato = az.cod_macrostato(+)
          AND XX.cod_sndg = a.cod_sndg
          AND xx.cod_abi_istituto = pc_new.cod_abi(+)
          AND xx.cod_sndg = pc_new.cod_sndg_sogg_connesso(+);
