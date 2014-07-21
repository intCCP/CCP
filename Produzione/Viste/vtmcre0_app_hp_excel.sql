/* Formatted on 17/06/2014 18:16:04 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_HP_EXCEL
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
   COD_STATO_RISTRUTTURATO,
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
   COD_LIVELLO
)
AS
   SELECT                                  -- vg   26/01/2011 Codice e desc ge
          -- mm 02/02/2011 dta_estrazione a sysdate, cod_ristrutt. a '-'
          -- vg  14/03/2011 GG di PT
          -- mm 120709 esposta dta-decorrenza_stato come in scheda anag per IN/SO
          -- lf 20120830 filtrata tabella delle proroghe, ora si prendeono le posizioni con max(dta_esito) e max(val_num_proroghe) per evitare record duplicati
          cod_comparto,
          desc_comparto,
          desc_istituto val_banca,
          desc_struttura_competente_dv val_divisione,
          cod_struttura_competente_dv cod_divisione,
          desc_struttura_competente_dc val_direzione,
          cod_struttura_competente_dc cod_direzione,
          desc_struttura_competente_rg val_regione,
          cod_struttura_competente_rg cod_regione,
          desc_struttura_competente_ar val_aerea,
          cod_struttura_competente_ar cod_area,
          cod_filiale,
          cod_abi_istituto,
          f.cod_abi_cartolarizzato,
          f.cod_ndg,
          cod_sndg,
          desc_nome_controparte,
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
                                    TO_DATE ('31/12/9999', 'DD/MM/YYYY'), pr.dta_decorrenza_stato,
                                    (pr.dta_fine_stato + 1))
                              ELSE
                                 f.dta_decorrenza_stato
                           END,
                           f.dta_decorrenza_stato)
                   -- dta_apertura
                   FROM (  SELECT pr.cod_abi,
                                  pr.cod_ndg,
                                  MIN (pr.dta_decorrenza_stato)
                                     dta_decorrenza_stato,
                                  MIN (pr.dta_fine_stato) dta_fine_stato
                             FROM (  SELECT pr.cod_abi,
                                            pr.cod_ndg,
                                            MAX (pr.dta_decorrenza_stato)
                                               dta_decorrenza_stato,
                                            NULL dta_fine_stato
                                       FROM t_mcrei_app_pratiche pr
                                      WHERE dta_fine_stato =
                                               TO_DATE ('31/12/9999',
                                                        'DD/MM/YYYY')
                                   GROUP BY cod_abi, cod_ndg
                                   UNION ALL
                                     SELECT pr.cod_abi,
                                            pr.cod_ndg,
                                            NULL dta_decorrenza_stato,
                                            MAX (pr.dta_fine_stato)
                                               dta_fine_stato
                                       FROM t_mcrei_app_pratiche pr
                                      WHERE dta_fine_stato !=
                                               TO_DATE ('31/12/9999',
                                                        'DD/MM/YYYY')
                                   GROUP BY cod_abi, cod_ndg) pr
                         GROUP BY pr.cod_abi, pr.cod_ndg) pr
                  WHERE     pr.cod_abi(+) = f.cod_abi_cartolarizzato
                        AND pr.cod_ndg(+) = f.cod_ndg)
             ELSE
                f.dta_decorrenza_stato
          END
             AS dta_decorrenza_stato,
          dta_scadenza_stato,
          '-' cod_stato_ristrutturato,
          TO_DATE (NULL) dta_decorrenza_stato_ris,
          scsb_uti_tot val_tot_utilizzo,
          scsb_acc_tot val_tot_accordato,
          scsb_uti_cassa val_tot_uti_cassa,
          scsb_uti_firma val_tot_uti_firma,
          scsb_acc_cassa val_tot_acc_cassa,
          scsb_acc_firma val_tot_acc_firma,
          gb_val_mau val_mau,
          cognome,
          nome,
          dta_utente_assegnato,
          SYSDATE dta_estrazione,
          NULLIF (f.id_utente, -1) id_utente,
          id_referente,
          flg_outsourcing,
          DECODE (cod_stato,
                  'PT', TRUNC (SYSDATE) - TRUNC (dta_decorrenza_stato),
                  TO_NUMBER (NULL))
             val_gg_pt,
          r.val_num_proroghe,
          f.cod_livello
     FROM vtmcre0_app_upd_fields f,
          (  SELECT cod_abi_cartolarizzato,
                    cod_ndg,
                    flg_esito,
                    MAX (val_num_proroghe) val_num_proroghe,
                    MAX (dta_esito)
               FROM t_mcre0_app_rio_proroghe
           GROUP BY cod_abi_cartolarizzato, cod_ndg, flg_esito) r
    --, t_mcre0_app_rio_proroghe r
    WHERE     flg_stato_chk = '1'
          AND f.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
          AND f.cod_ndg = r.cod_ndg(+)
          AND NVL (r.flg_esito, 1) = 1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_HP_EXCEL TO MCRE_USR;
