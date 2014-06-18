/* Formatted on 17/06/2014 18:07:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_RETT_DISAL
(
   VAL_ALERT,
   COD_SNDG,
   COD_ABI,
   COD_NDG,
   COD_STATO,
   COD_PROTOCOLLO_DELIBERA,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI
)
AS
   SELECT                             --28.03 aggiuinto partition by dta_stima
         DISTINCT 'R' val_alert,
                  -- verde 1 mese se sono state riviste e confermate le valutazioni, rosso 1 mese se le valutazioni non sono state riviste e confermatePP
                  b.cod_sndg,
                  b.cod_abi,
                  b.cod_ndg,
                  ad.cod_stato,
                  b.cod_protocollo_delibera,
                  1 val_cnt_delibere,
                  1 val_cnt_rapporti
     FROM t_mcrei_app_delibere d,
          (SELECT DISTINCT
                  sB.cod_abi,
                  sB.cod_sndg,
                  sB.cod_ndg,
                  -- SB.flg_tipo_dato,
                  sB.cod_protocollo_delibera,
                  SB.cod_classe_ft,
                  sb.dta_stima,
                  SUM (
                     CASE
                        WHEN SB.COD_TIPO_PACCHETTO IN ('A', 'M')
                        THEN
                           DECODE (SB.COD_CLASSE_FT,
                                   'CA', SB.VAL_RDV_TOT,
                                   TO_CHAR (NULL), SB.VAL_RDV_TOT,
                                   0)
                        ELSE
                           0
                     END)
                  OVER (
                     PARTITION BY sB.cod_abi,
                                  sB.cod_ndg,
                                  sB.cod_protocollo_delibera,
                                  sB.dta_stima,
                                  SB.cod_classe_ft)
                     rdv_stime_ca,
                  SUM (
                     CASE
                        WHEN SB.COD_TIPO_PACCHETTO IN ('M', 'A')
                        THEN
                           DECODE (SB.cod_classe_ft, 'FI', SB.val_rdv_tot, 0)
                        ELSE
                           0
                     END)
                  OVER (
                     PARTITION BY sB.cod_abi,
                                  sB.cod_ndg,
                                  sB.cod_protocollo_delibera,
                                  sB.dta_stima,
                                  SB.cod_classe_ft)
                     rdv_stime_fi,
                  MAX (SB.dta_stima)
                     OVER (PARTITION BY sB.cod_abi, sB.cod_ndg)
                     AS max_stima
             FROM (SELECT s.cod_abi,
                          s.cod_sndg,
                          s.cod_ndg,
                          dta_stima,
                          -- flg_tipo_dato,
                          s.cod_protocollo_delibera,
                          COD_TIPO_PACCHETTO,
                          cod_classe_ft,
                          VAL_RDV_TOT,
                          VAL_PREV_RECUPERO
                     FROM T_MCREI_APP_DELIBERE D,
                          t_mcre0_app_all_data ad,
                          T_MCREI_APP_STIME S
                    WHERE     1 = 1
                          AND d.cod_abi = ad.cod_abi_cartolarizzato
                          AND d.cod_ndg = ad.cod_ndg
                          AND D.cod_fase_delibera = 'CO'
                          AND D.flg_no_delibera = '0'
                          AND D.flg_attiva = '1'
                          AND d.cod_tipo_pacchetto IN ('A', 'M')
                          AND d.cod_microtipologia_delib IN
                                 ('RV', 'A0', 'T4', 'IM', 'IF')
                          AND ad.flg_target = 'Y'
                          AND ad.today_flg = '1'
                          AND ad.flg_outsourcing = 'Y'
                          AND ad.cod_stato IN ('IN', 'RS')
                          AND cod_classe_ft IN ('CA', 'FI')
                          AND d.cod_abi = s.cod_abi
                          AND d.cod_ndg = s.cod_ndg
                          AND d.cod_protocollo_delibera =
                                 s.cod_protocollo_delibera) SB) S,
          (SELECT DISTINCT
                  sB.cod_abi,
                  sB.cod_sndg,
                  sB.cod_ndg,
                  --  SB.flg_tipo_dato,
                  sB.cod_protocollo_delibera,
                  SB.cod_classe_ft,
                  sb.dta_stima,
                  SUM (
                     CASE
                        WHEN SB.COD_TIPO_PACCHETTO IN ('M', 'A')
                        THEN
                           DECODE (SB.COD_CLASSE_FT,
                                   'CA', SB.VAL_RDV_TOT,
                                   TO_CHAR (NULL), SB.VAL_RDV_TOT,
                                   0)
                        ELSE
                           0
                     END)
                  OVER (
                     PARTITION BY sB.cod_abi,
                                  sB.cod_ndg,
                                  sB.cod_protocollo_delibera,
                                  sB.dta_stima,
                                  SB.cod_classe_ft)
                     rdv_stime_batch_ca,
                  SUM (
                     CASE
                        WHEN SB.COD_TIPO_PACCHETTO IN ('M', 'A')
                        THEN
                           DECODE (SB.cod_classe_ft, 'FI', SB.val_rdv_tot, 0)
                        ELSE
                           0
                     END)
                  OVER (
                     PARTITION BY sB.cod_abi,
                                  sB.cod_ndg,
                                  sB.cod_protocollo_delibera,
                                  sB.dta_stima,
                                  SB.cod_classe_ft)
                     rdv_stime_batch_fi,
                  MAX (SB.dta_stima)
                     OVER (PARTITION BY sB.cod_abi, sB.cod_ndg)
                     AS max_stima_batch
             FROM (SELECT s.cod_abi,
                          s.cod_sndg,
                          s.cod_ndg,
                          dta_stima,
                          --  flg_tipo_dato,
                          s.cod_protocollo_delibera,
                          COD_TIPO_PACCHETTO,
                          cod_classe_ft,
                          VAL_RDV_TOT,
                          VAL_PREV_RECUPERO
                     FROM T_MCREI_APP_DELIBERE D,
                          t_mcre0_app_all_data ad,
                          T_MCREI_APP_STIME_BATCH S
                    WHERE     1 = 1
                          AND d.cod_abi = ad.cod_abi_cartolarizzato
                          AND d.cod_ndg = ad.cod_ndg
                          AND D.cod_fase_delibera = 'CO'
                          AND D.flg_no_delibera = '0'
                          AND D.flg_attiva = '1'
                          AND d.cod_tipo_pacchetto IN ('A', 'M')
                          AND d.cod_microtipologia_delib IN
                                 ('RV', 'A0', 'T4', 'IM', 'IF')
                          AND ad.flg_target = 'Y'
                          AND ad.today_flg = '1'
                          AND ad.flg_outsourcing = 'Y'
                          AND ad.cod_stato IN ('IN', 'RS')
                          AND cod_classe_ft IN ('CA', 'FI')
                          AND d.cod_abi = s.cod_abi
                          AND d.cod_ndg = s.cod_ndg
                          AND d.cod_protocollo_delibera =
                                 s.cod_protocollo_delibera) SB) B,
          V_MCRE0_APP_UPD_FIELDS ad,
          T_MCRE0_APP_COMPARTI COMP
    WHERE     1 = 1
          AND d.cod_abi = s.cod_abi
          AND d.cod_ndg = s.cod_ndg
          AND d.cod_protocollo_delibera = s.cod_protocollo_delibera
          AND d.cod_abi = b.cod_abi
          AND d.cod_ndg = b.cod_ndg
          AND d.cod_protocollo_delibera = b.cod_protocollo_delibera
          AND d.cod_abi = ad.cod_abi_cartolarizzato
          AND d.cod_ndg = ad.cod_ndg
          AND COMP.COD_COMPARTO =
                 NVL (COD_COMPARTO_ASSEGNATO, COD_COMPARTO_CALCOLATO)
          AND D.cod_fase_delibera NOT IN ('AN', 'AM', 'VA')
          AND D.flg_no_delibera = '0'
          AND D.flg_attiva = '1'
          AND d.cod_tipo_pacchetto IN ('A', 'M')
          AND d.cod_microtipologia_delib IN ('RV', 'A0', 'T4', 'IM', 'IF')
          AND ad.flg_target = 'Y'
          AND ad.today_flg = '1'
          AND ad.flg_outsourcing = 'Y'
          AND ad.cod_stato IN ('IN', 'RS')
          AND ad.id_utente != -1
          AND s.cod_abi = b.cod_abi
          AND s.cod_ndg = b.cod_ndg
          --AND s.flg_tipo_dato = b.flg_tipo_dato
          AND s.dta_stima = s.max_stima
          AND b.dta_stima = b.max_stima_batch
          AND b.max_stima_batch > s.max_stima
          AND s.cod_classe_ft = b.cod_classe_ft
          AND (  ABS (S.RDV_STIME_CA + S.rdv_stime_fi)
               - (B.RDV_STIME_BATCH_CA + B.RDV_STIME_BATCH_FI)) > 0;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_WRK_ALERT_RETT_DISAL TO MCRE_USR;
