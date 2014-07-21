/* Formatted on 21/07/2014 18:39:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DELIBERE_ASSUNTE
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA,
   DESC_NOME_CONTROPARTE,
   GRUPPO_ECONOMICO,
   COD_FILIALE_DELIBERA,
   FILIALE_DELIBERA,
   COD_AREA_DELIBERA,
   AREA_DELIBERA,
   STATO_ATTUALE,
   DTA_DECORRENZA_STATO,
   TIPO_DELIBERA,
   FASE_DELIBERA,
   COD_ORGANO_DELIBERANTE,
   DTA_DELIBERA,
   DTA_SCADENZA,
   DATA_AGGIORNAMNETO,
   COD_MATRICOLA_INSERENTE,
   NOME_INSERENTE,
   NOTE,
   NOTE_DEL_ANNULLATE,
   NOTE_PROP_ANNULLATE,
   ESP_LORDA,
   ESP_LORDA_CAPITALE,
   ESP_LORDA_MORA,
   RDV_QC_ANTE_DELIB,
   ESP_NETTA_ANTE_DELIB,
   RDV_QC_DELIBERATA,
   RDV_QC_PROGRESSIVA,
   ESP_NETTA_POST_DELIB,
   PERC_RDV,
   PARTE_CORRELATA,
   PARTE_CORRELATA_IAS,
   ARTICOLO_136,
   SOGGETTO_COLLEGATO,
   DELIBERA_FORZATA,
   G_PERM_STATO,
   G_SCONF,
   SCONF_SOPRA_SOGLIA,
   LIVELLO_DI_RISCHIO,
   ULTIMA_TIP_PRATICA,
   ULTIMA_FASE_TEMP_INSERITA,
   DESC_INC_MAN_AUT,
   CAMPO_STERILIZZAZIONE,
   ADV_CLN_FIN,
   ADV_CLN_LEG,
   ADV_CLN_IND,
   ADV_BNC_FIN,
   ADV_BNC_LEG,
   ADV_BNC_IND,
   ADV_SIS_FIN,
   ADV_SIS_LEG,
   ADV_SIS_IND,
   ASSEVERATORE,
   TIPOLOGIA_GESTIONE,
   COD_TIP_RISTR
)
AS
     SELECT d.COD_ABI,
            P.COD_NDG,
            P.COD_SNDG,
            d.COD_PROTOCOLLO_DELIBERA,
            P.DESC_NOME_CONTROPARTE,
            P.VAL_ANA_GRE GRUPPO_ECONOMICO,
            DECODE (COD_FILIALE_DELIBERA, '00000', '-', COD_FILIALE_DELIBERA)
               COD_FILIALE_DELIBERA,
            p.DESC_STRUTTURA_COMPETENTE_FI FILIALE_DELIBERA,
            p.COD_STRUTTURA_COMPETENTE_AR COD_AREA_DELIBERA,
            p.DESC_STRUTTURA_COMPETENTE_AR AREA_DELIBERA,
            P.COD_STATO STATO_ATTUALE,
            P.DTA_DECORRENZA_STATO,
            d.COD_MICROTIPOLOGIA_DELIB TIPO_DELIBERA,
            COD_FASE_DELIBERA FASE_DELIBERA,
            COD_ORGANO_DELIBERANTE,
            DTA_DELIBERA,
            d.DTA_SCADENZA,
            DTA_LAST_UPD_DELIBERA AS DATA_AGGIORNAMNETO,
            d.COD_MATRICOLA_INSERENTE,
            DESC_DENOMINAZ_INS_DELIBERA NOME_INSERENTE,
            DESC_NOTE NOTE,
            DESC_NOTE_DELIBERE_ANNULLATE NOTE_DEL_ANNULLATE,
            DESC_NOTE_ANNULLO_PROP NOTE_PROP_ANNULLATE,
            VAL_ESP_LORDA ESP_LORDA,
            VAL_ESP_LORDA_CAPITALE ESP_LORDA_CAPITALE,
            VAL_ESP_LORDA_MORA ESP_LORDA_MORA,
            VAL_RDV_QC_ANTE_DELIB RDV_QC_ANTE_DELIB,
            VAL_ESP_NETTA_ANTE_DELIB ESP_NETTA_ANTE_DELIB,
            VAL_RDV_QC_DELIBERATA RDV_QC_DELIBERATA,
            VAL_RDV_QC_PROGRESSIVA RDV_QC_PROGRESSIVA,
            VAL_ESP_NETTA_POST_DELIB ESP_NETTA_POST_DELIB,
            VAL_PERC_RDV PERC_RDV,
            --campi aggiunti per REQ.29
            P.FLG_PARTI_CORRELATE AS PARTE_CORRELATA,                     --34
            DECODE (SUBSTR (pc_new.flg_rilevanza_normativa, 3, 1),
                    NULL, 'N',
                    'R', 'S',
                    'N')
               PARTE_CORRELATA_IAS,                                       --34
            P.FLG_ART_136 AS ARTICOLO_136,                                --34
            DECODE (pc_new.cod_abi, NULL, 'N', 'S') SOGGETTO_COLLEGATO,   --34
            DECODE (FLG_DELIB_FORZATA, 0, 'N', 'S') AS DELIBERA_FORZATA,
              --campi aggiunti per REQ. 34
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
               AS G_PERM_STATO,
            SAB.NUM_GIORNI_SCONFINO AS G_SCONF,
            SAB.FLG_SOGLIA AS SCONF_SOPRA_SOGLIA,
            NVL (IRIS.VAL_LIV_RISCHIO_CLI, 'ND') AS LIVELLO_DI_RISCHIO,
            az.TIPO_PRATICA AS ULTIMA_TIP_PRATICA,
            az.FASE AS ULTIMA_FASE_TEMP_INSERITA,
            CASE
               WHEN XX.cod_stato = 'IN'
               THEN
                  (SELECT DISTINCT desc_note
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
               AS DESC_INC_MAN_AUT,
            NULL AS CAMPO_STERILIZZAZIONE,
            NULL AS ADV_CLN_FIN,
            NULL AS ADV_CLN_LEG,
            NULL AS ADV_CLN_IND,
            NULL AS ADV_BNC_FIN,
            NULL AS ADV_BNC_LEG,
            NULL AS ADV_BNC_IND,
            NULL AS ADV_SIS_FIN,
            NULL AS ADV_SIS_LEG,
            NULL AS ADV_SIS_IND,
            NULL AS ASSEVERATORE,
            CASE
               WHEN xx.COD_MACROSTATO IN ('IN', 'RI')
               THEN
                  (SELECT pr.cod_tipo_gestione
                     FROM (SELECT cod_abi, cod_ndg, cod_tipo_gestione
                             FROM (SELECT p.cod_abi,
                                          p.cod_ndg,
                                          p.cod_tipo_gestione,
                                          RANK ()
                                          OVER (
                                             PARTITION BY cod_abi, cod_ndg
                                             ORDER BY
                                                val_anno_pratica || cod_pratica DESC)
                                             r
                                     FROM t_mcrei_app_pratiche p
                                    WHERE flg_attiva = 1)
                            WHERE r = 1) pr
                    WHERE     pr.cod_abi(+) = xx.cod_abi_cartolarizzato
                          AND pr.cod_ndg(+) = xx.cod_ndg)
               ELSE
                  NULL
            END
               TIPOLOGIA_GESTIONE,
            ris.flg_ristrutturato AS COD_TIP_RISTR
       FROM T_MCREI_APP_DELIBERE D,
            V_MCRE0_APP_SCHEDA_ANAG P,
            t_mcres_app_parti_corr pc_new,
            V_MCRE0_APP_UPD_FIELDS XX,
            (SELECT hris.*, clris.flg_ristrutturato, clris.stato_ristrutturato
               FROM T_MCREI_HST_RISTRUTTURAZIONI hris,
                    T_MCRE0_CL_TIPI_RISTR clris
              WHERE     hris.desc_intento_ristr = clris.desc_intento_ristr
                    AND hris.desc_tipo_ristr = clris.desc_tipo_ristr
                    AND hris.dta_chiusura_ristr IS NULL) ris,
            t_mcre0_app_sab_xra sab,
            t_mcre0_app_iris iris,
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
                    AND pf.ID_TIPOLOGIA_PRATICA = cl_f.COD_TIPO(+)) az
      WHERE     D.COD_TIPO_PACCHETTO = 'M'
            AND D.COD_FASE_DELIBERA = 'CO'
            AND D.COD_FASE_MICROTIPOLOGIA = 'CNF'
            --            AND TRUNC (D.DTA_CONFERMA_DELIBERA) >=
            --                   ADD_MONTHS (TRUNC (SYSDATE - 30, 'MM'), -1)
            --            AND TRUNC (D.DTA_CONFERMA_DELIBERA) <
            --                   ADD_MONTHS (TRUNC (SYSDATE, 'MM'), 1)
            AND D.COD_ABI = P.COD_ABI_CARTOLARIZZATO
            AND D.COD_NDG = P.COD_NDG
            AND D.FLG_NO_DELIBERA = '0'
            AND p.cod_abi_cartolarizzato = pc_new.cod_abi(+)
            AND p.cod_sndg = pc_new.cod_sndg_sogg_connesso(+)
            AND XX.COD_ABI_CARTOLARIZZATO = p.COD_ABI_CARTOLARIZZATO
            AND XX.COD_NDG = p.COD_NDG
            AND xx.cod_abi_cartolarizzato = ris.cod_abi(+)
            AND xx.cod_ndg = ris.cod_ndg(+)
            AND XX.cod_abi_cartolarizzato = sab.cod_abi_cartolarizzato(+)
            AND XX.cod_ndg = sab.cod_ndg(+)
            AND XX.COD_SNDG = IRIS.COD_SNDG(+)
            AND XX.cod_abi_cartolarizzato = az.cod_abi_cartolarizzato(+)
            AND XX.cod_ndg = az.cod_ndg(+)
            AND XX.cod_macrostato = az.cod_macrostato(+)
   ORDER BY D.COD_ABI, D.COD_NDG, D.VAL_NUM_PROGR_DELIBERA DESC;
