/* Formatted on 21/07/2014 18:34:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_HP_EXCEL
(
   COD_COMPARTO,
   DESC_COMPARTO,
   VAL_BANCA,
   VAL_DIVISIONE,
   COD_DIVISIONE,
   VAL_DIREZIONE,
   COD_DIREZIONE,
   VAL_REGIONE,
   COD_REGIONE,
   VAL_AEREA,
   COD_AREA,
   COD_FILIALE,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GE,
   DESC_GE,
   COD_PROCESSO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   DTA_DECORRENZA_STATO_RIS,
   VAL_TOT_UTILIZZO,
   VAL_TOT_ACCORDATO,
   VAL_TOT_UTI_CASSA,
   VAL_TOT_UTI_FIRMA,
   VAL_TOT_ACC_CASSA,
   VAL_TOT_ACC_FIRMA,
   VAL_MAU,
   COGNOME,
   NOME,
   DTA_UTENTE_ASSEGNATO,
   DTA_ESTRAZIONE,
   ID_UTENTE,
   ID_REFERENTE,
   FLG_OUTSOURCING,
   VAL_GG_PT,
   VAL_NUM_PROROGHE,
   COD_LIVELLO,
   COD_ABI,
   COD_STATO_RISTRUTTURATO,
   DESC_STATO_RISTRUTTURATO,
   DTA_SERVIZIO,
   DTA_SCADENZA_SERVIZIO,
   TIPO_PRATICA,
   FASE,
   STATO_FASE_ESSERE,
   STERILIZZAZIONE,
   GG_SCONFINO,
   SCONFINO_SOPRA_SOGLIA,
   LIV_RISCHIO_CLI,
   GG_PERMANENZA_STATO,
   SCSB_UTI_SOSTITUZIONI,
   SCSB_ACC_SOSTITUZIONI,
   COD_TIPO_GESTIONE
)
AS
   SELECT                                  -- vg   26/01/2011 Codice e desc ge
          -- mm 02/02/2011 dta_estrazione a sysdate, cod_ristrutt. a '-'
          -- vg  14/03/2011 GG di PT
          -- mm 120709 esposta dta-decorrenza_stato come in scheda anag per IN/SO
          -- lf 20120830 filtrata tabella delle proroghe, ora si prendeono le posizioni con max(dta_esito) e max(val_num_proroghe) per evitare record duplicati
          cod_comparto,
          desc_comparto,
          f.desc_istituto val_banca,
          desc_struttura_competente_dv val_divisione,
          cod_struttura_competente_dv cod_divisione,
          desc_struttura_competente_dc val_direzione,
          cod_struttura_competente_dc cod_direzione,
          desc_struttura_competente_rg val_regione,
          cod_struttura_competente_rg cod_regione,
          desc_struttura_competente_ar val_aerea,
          cod_struttura_competente_ar cod_area,
          f.cod_filiale,
          f.cod_abi_istituto,
          f.cod_abi_cartolarizzato,
          f.cod_ndg,
          f.cod_sndg,
          f.desc_nome_controparte,
          cod_gruppo_economico cod_ge,
          desc_gruppo_economico desc_ge,
          cod_processo,
          cod_stato,
          CASE
             WHEN f.cod_stato IN ('IN', 'SO')
             THEN
                (SELECT NVL (
                           CASE
                              WHEN f.cod_stato = 'IN'
                              THEN
                                 pr.dta_decorrenza_stato
                              WHEN f.cod_stato = 'SO'
                              THEN
                                 DECODE (
                                    pr.dta_fine_stato,
                                    TO_DATE ('31/12/9999', 'DD/MM/YYYY'), f.dta_decorrenza_stato,
                                    (pr.dta_fine_stato + 1))
                              ELSE
                                 f.dta_decorrenza_stato
                           END,
                           f.dta_decorrenza_stato)
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
                                              val_anno_pratica || cod_pratica DESC)
                                           r
                                   FROM t_mcrei_app_pratiche p
                                  WHERE flg_attiva = 1)
                          WHERE r = 1) pr
                  WHERE     pr.cod_abi(+) = f.cod_abi_cartolarizzato
                        AND pr.cod_ndg(+) = f.cod_ndg)
             ELSE
                f.dta_decorrenza_stato
          END
             AS dta_decorrenza_stato,
          dta_scadenza_stato,
          TO_DATE (NULL) dta_decorrenza_stato_ris,
          f.scsb_uti_tot val_tot_utilizzo,
          f.scsb_acc_tot val_tot_accordato,
          f.scsb_uti_cassa val_tot_uti_cassa,
          f.scsb_uti_firma val_tot_uti_firma,
          f.scsb_acc_cassa val_tot_acc_cassa,
          f.scsb_acc_firma val_tot_acc_firma,
          f.gb_val_mau val_mau,
          cognome,
          nome,
          dta_utente_assegnato,
          SYSDATE dta_estrazione,
          NULLIF (f.id_utente, -1) id_utente,
          id_referente,
          flg_outsourcing,
          DECODE (cod_stato,
                  'PT', TRUNC (SYSDATE) - TRUNC (f.dta_decorrenza_stato),
                  TO_NUMBER (NULL))
             val_gg_pt,
          r.val_num_proroghe,
          f.cod_livello,
          --Campi nuovi 11/2013
          f.cod_abi_cartolarizzato AS COD_ABI,
          ris.flg_ristrutturato AS COD_STATO_RISTRUTTURATO,
          ris.stato_ristrutturato AS DESC_STATO_RISTRUTTURATO,
          DECODE (f.COD_LIVELLO, 'DC', f.DTA_SERVIZIO, NULL) DTA_SERVIZIO,
          CASE
             WHEN     f.cod_macrostato IN ('RIO')
                  AND f.cod_comparto_calcolato = '011901'
             THEN
                (SELECT DECODE (
                           rio.dta_esito,
                           NULL, f.dta_servizio + f.val_gg_prima_proroga,
                           rio.dta_esito + f.val_gg_seconda_proroga)
                   FROM t_mcre0_app_rio_proroghe rio
                  WHERE     f.cod_abi_cartolarizzato =
                               rio.cod_abi_cartolarizzato(+)
                        AND f.cod_ndg = rio.cod_ndg(+)
                        AND rio.flg_storico(+) = '0'
                        AND rio.flg_esito(+) = '1')
             ELSE
                f.dta_servizio + f.val_gg_prima_proroga
          END
             dta_scadenza_servizio,
          az.TIPO_PRATICA AS TIPO_PRATICA,
          az.FASE AS FASE,
          az.flg_completata AS stato_fase_essere,
          NULL AS sterilizzazione,
          SAB.NUM_GIORNI_SCONFINO AS GG_SCONFINO,
          SAB.FLG_SOGLIA AS SCONFINO_SOPRA_SOGLIA,
          NVL (IRIS.VAL_LIV_RISCHIO_CLI, 'ND') liv_rischio_cli,
            TRUNC (SYSDATE)
          - CASE
               WHEN f.cod_stato IN ('IN', 'SO')
               THEN
                  (SELECT NVL (
                             CASE
                                WHEN f.cod_stato = 'IN'
                                THEN
                                   pr.dta_decorrenza_stato
                                WHEN f.cod_stato = 'SO'
                                THEN
                                   DECODE (
                                      pr.dta_fine_stato,
                                      TO_DATE ('31/12/9999', 'DD/MM/YYYY'), f.dta_decorrenza_stato,
                                      (pr.dta_fine_stato + 1))
                                ELSE
                                   f.dta_decorrenza_stato
                             END,
                             f.dta_decorrenza_stato)
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
                    WHERE     pr.cod_abi(+) = f.cod_abi_cartolarizzato
                          AND pr.cod_ndg(+) = f.cod_ndg)
               ELSE
                  f.dta_decorrenza_stato
            END
             gg_permanenza_stato,
          pcr.scsb_uti_sostituzioni,
          pcr.scsb_acc_sostituzioni,
          CASE
             WHEN f.COD_MACROSTATO IN ('IN', 'RI')
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
                  WHERE     pr.cod_abi(+) = f.cod_abi_cartolarizzato
                        AND pr.cod_ndg(+) = f.cod_ndg)
             ELSE
                NULL
          END
             cod_tipo_gestione
     FROM v_mcre0_app_upd_fields f,
          (  SELECT cod_abi_cartolarizzato,
                    cod_ndg,
                    flg_esito,
                    MAX (val_num_proroghe) val_num_proroghe,
                    MAX (dta_esito)
               FROM t_mcre0_app_rio_proroghe
           GROUP BY cod_abi_cartolarizzato, cod_ndg, flg_esito) r,
          t_mcre0_app_sab_xra sab,
          t_mcre0_app_iris iris,
          (SELECT hris.*, clris.flg_ristrutturato, clris.stato_ristrutturato
             FROM T_MCREI_HST_RISTRUTTURAZIONI hris,
                  T_MCRE0_CL_TIPI_RISTR clris
            WHERE     hris.desc_intento_ristr = clris.desc_intento_ristr
                  AND hris.desc_tipo_ristr = clris.desc_tipo_ristr
                  AND hris.dta_chiusura_ristr IS NULL) ris,
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
          T_MCRE0_APP_PCR pcr
    WHERE     flg_stato_chk = '1'
          AND f.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
          AND f.cod_ndg = r.cod_ndg(+)
          AND r.flg_esito(+) = 1
          AND f.cod_abi_cartolarizzato = sab.cod_abi_cartolarizzato(+)
          AND f.cod_ndg = sab.cod_ndg(+)
          AND F.COD_SNDG = IRIS.COD_SNDG(+)
          AND f.cod_abi_cartolarizzato = ris.cod_abi(+)
          AND f.cod_ndg = ris.cod_ndg(+)
          AND f.cod_abi_cartolarizzato = az.cod_abi_cartolarizzato(+)
          AND f.cod_ndg = az.cod_ndg(+)
          AND f.cod_macrostato = az.cod_macrostato(+)
          AND f.cod_abi_cartolarizzato = pcr.cod_abi_cartolarizzato(+)
          AND f.cod_ndg = pcr.cod_ndg(+)
          AND pcr.today_flg(+) = '1';
