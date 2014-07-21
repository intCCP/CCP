/* Formatted on 17/06/2014 17:59:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ALL_DATA
(
   TODAY_FLG,
   FLG_ACTIVE,
   FLG_SOURCE,
   FLG_BLOCCO,
   ID_DPERFG,
   ID_DPERMO,
   COD_NDG,
   COD_ABI_CARTOLARIZZATO,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   DESC_BREVE,
   FLG_TARGET,
   FLG_CARTOLARIZZATO,
   DTA_ABI_ELAB,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_GRUPPO_LEGAME,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_SINGOLO,
   FLG_CONDIVISO,
   FLG_SOMMA,
   FLG_OUTSOURCING,
   COD_FILIALE,
   COD_STRUTTURA_COMPETENTE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO_PRE,
   DTA_INTERCETTAMENTO,
   COD_TIPO_INGRESSO,
   COD_CAUSALE_INGRESSO,
   COD_PERCORSO,
   COD_PROCESSO,
   DTA_PROCESSO,
   COD_PROCESSO_PRE,
   COD_MACROSTATO,
   DTA_DEC_MACROSTATO,
   COD_RAMO_CALCOLATO,
   COD_COMPARTO_CALCOLATO,
   DTA_COMPARTO_CALCOLATO,
   COD_COMPARTO_CALCOLATO_PRE,
   COD_GRUPPO_SUPER,
   COD_GRUPPO_SUPER_OLD,
   FLG_RIPORTAFOGLIATO,
   DTA_LAST_RIPORTAF,
   DTA_UTENTE_ASSEGNATO,
   COD_COMPARTO_ASSEGNATO,
   ID_UTENTE,
   ID_UTENTE_PRE,
   COD_SERVIZIO,
   DTA_SERVIZIO,
   ID_STATO_POSIZIONE,
   COD_CLIENTE_ESTESO,
   ID_CLIENTE_ESTESO,
   DESC_ANAG_GESTORE_MKT,
   COD_GESTORE_MKT,
   COD_TIPO_PORTAFOGLIO,
   FLG_GESTIONE_ESTERNA,
   VAL_PERC_DECURTAZIONE,
   COD_COMPARTO_HOST,
   ID_TRANSIZIONE,
   COD_RAMO_HOST,
   COD_MATR_RISCHIO,
   COD_UO_RISCHIO,
   COD_DISP_RISCHIO,
   DTA_INS,
   DTA_UPD,
   COD_OPERATORE_INS_UPD,
   COD_MATR_ASSEGNATORE,
   COD_SEZIONE_PREASSEGNATA,
   ID_UTENTE_PREASSEGNATO,
   COD_COMPARTO_PREASSEGNATO,
   COD_PROCESSO_PREASSEGNATO,
   FLG_STATO_GB,
   COD_FILIALE_GB,
   COD_PROCESSO_CALCOLATO_GB,
   COD_MACROSTATO_PROPOSTO_GB,
   DTA_INS_GB,
   DTA_RIF_PD_ONLINE,
   VAL_RATING_ONLINE,
   VAL_PD_ONLINE,
   SCSB_UTI_TOT,
   SCSB_ACC_TOT,
   SCSB_UTI_CASSA,
   SCSB_UTI_FIRMA,
   SCSB_ACC_CASSA,
   SCSB_ACC_FIRMA,
   GB_VAL_MAU,
   GEGB_ACC_CASSA,
   GEGB_ACC_FIRMA,
   GEGB_UTI_CASSA,
   GEGB_UTI_FIRMA,
   GLGB_ACC_CASSA,
   GLGB_ACC_FIRMA,
   GLGB_UTI_CASSA,
   GLGB_UTI_FIRMA,
   SCSB_ACC_SOSTITUZIONI,
   SCSB_UTI_SOSTITUZIONI
)
AS
   WITH n
        AS (SELECT                                         --v1.3 MM decode GB
                  DECODE (GB.FLG_STATO, '1', '1', w.TODAY_FLG) TODAY_FLG,
                   CASE
                      WHEN GB.FLG_STATO = '1'
                      THEN
                         CASE WHEN w.TODAY_FLG = '1' THEN '1' ELSE '2' END
                      ELSE
                         '0'
                   END
                      flg_source,
                   w.COD_ABI_ISTITUTO,
                   w.COD_ABI_CARTOLARIZZATO,
                   w.COD_NDG,
                   w.COD_SNDG,
                   NVL (COD_COMPARTO_CALCOLATO_PRE, '#')
                      COD_COMPARTO_CALCOLATO_PRE,
                   NVL (COD_COMPARTO_CALCOLATO, '#') COD_COMPARTO_CALCOLATO,
                   COD_COMPARTO_ASSEGNATO,
                   FLG_GRUPPO_ECONOMICO,
                   FLG_GRUPPO_LEGAME,
                   FLG_SINGOLO,
                   FLG_CONDIVISO,
                   COD_GRUPPO_LEGAME,
                   NVL (COD_GRUPPO_ECONOMICO, -1) COD_GRUPPO_ECONOMICO,
                   COD_GRUPPO_SUPER,
                   DTA_COMPARTO_CALCOLATO,
                   NVL (ID_UTENTE, -1) ID_UTENTE,
                   --------------------   VG - CIB/BDT - INIZIO --------------------
                   ----nvl(ID_UTENTE_PRE,-1),
                   NVL (NULLIF (ID_UTENTE_PRE, id_utente), -1) ID_UTENTE_PRE,
                   --------------------   VG - CIB/BDT - FINE --------------------
                   NULL AS COD_OPERATORE_INS_UPD,
                   w.DTA_INS,
                   w.DTA_UPD,
                   w.ID_DPERFG,
                   --------------------   VG - CIB/BDT - INIZIO --------------------
                   ----DTA_UTENTE_ASSEGNATO,
                   CASE
                      WHEN NVL (id_utente, -1) = -1                  --IS NULL
                                                   THEN NULL
                      ELSE DTA_UTENTE_ASSEGNATO
                   END
                      DTA_UTENTE_ASSEGNATO,
                   --------------------   VG - CIB/BDT - FINE --------------------
                   FLG_SOMMA,
                   FLG_RIPORTAFOGLIATO,
                   DTA_LAST_RIPORTAF,
                   NULL AS COD_MATR_ASSEGNATORE,
                   NULL AS COD_COMPARTO_PREASSEGNATO,
                   NULL AS ID_UTENTE_PREASSEGNATO,
                   NULL AS COD_PROCESSO_PREASSEGNATO,
                   NULL AS COD_SEZIONE_PREASSEGNATA,
                   COD_RAMO_CALCOLATO,
                   --v1.5 INI -- w.w.: sbianco servizio e dta servizio per <= PT, uniformo per sndg se > PT
                   --COD_SERVIZIO, DTA_SERVIZIO,
                   CASE
                      WHEN w.cod_macrostato IN
                              ('PT', 'RIO', 'IN', 'SC', 'RS', 'SO')
                      THEN
                         w.COD_SERVIZIO
                      ELSE
                         NULL
                   END
                      AS COD_SERVIZIO,
                   CASE  --V2.0 dta_servizio solo se cod_servizio valorizzato!
                      WHEN     w.cod_macrostato IN ('IN', 'RS')
                           AND w.COD_SERVIZIO IS NOT NULL
                      THEN
                         --v1.51 aggiunti NVL per gestire il passaggio da PT (null) ad altri stati (sysdate)
                         NVL (
                            MIN (
                               CASE
                                  WHEN     w.cod_stato IN ('IN', 'RS')
                                       AND w.TODAY_FLG = '1'
                                  THEN
                                     w.dta_servizio
                                  ELSE
                                     NULL
                               END)
                            OVER (PARTITION BY w.cod_sndg),
                            SYSDATE)
                      WHEN w.cod_macrostato IN ('RIO', 'SC', 'SO')
                      THEN
                         NVL (w.dta_servizio, SYSDATE)
                      ELSE
                         NULL
                   END
                      AS DTA_SERVIZIO,
                   --v1.5 FINE --
                   FLG_ACTIVE,
                   0 AS flg_blocco,
                   --MOPLE + RS
                   DTA_INTERCETTAMENTO,
                   NVL (w.COD_FILIALE, '-') COD_FILIALE,
                   COD_STRUTTURA_COMPETENTE,
                   COD_TIPO_INGRESSO,
                   COD_CAUSALE_INGRESSO,
                   w.COD_PERCORSO,
                   w.COD_PROCESSO,
                   CASE
                      WHEN     COD_STATO = 'IN'
                           AND R.DTA_DECORRENZA_STATO IS NOT NULL
                           AND DTA_CHIUSURA_STATO IS NULL
                      THEN
                         'RS'
                      ELSE
                         NVL (COD_STATO, '-1')
                   END
                      COD_STATO,
                   -- R.DTA_DECORRENZA_STATO,
                   ------------------------------
                   CASE
                      WHEN     COD_STATO = 'IN'
                           AND R.DTA_DECORRENZA_STATO IS NOT NULL
                           AND DTA_CHIUSURA_STATO IS NULL
                      THEN
                         TRUNC (R.DTA_DECORRENZA_STATO)
                      ELSE          --maggiore tra le 2 w.DTA_DECORRENZA_STATO
                         CASE
                            WHEN (TRUNC (R.DTA_CHIUSURA_STATO) - w.DTA_DECORRENZA_STATO) <
                                    0
                            THEN
                               w.DTA_DECORRENZA_STATO
                            WHEN (  TRUNC (R.DTA_CHIUSURA_STATO)
                                  - w.DTA_DECORRENZA_STATO) > 0
                            THEN
                               TRUNC (R.DTA_CHIUSURA_STATO)
                            WHEN (  TRUNC (R.DTA_CHIUSURA_STATO)
                                  - w.DTA_DECORRENZA_STATO) = 0
                            THEN
                               w.DTA_DECORRENZA_STATO
                            ELSE
                               w.DTA_DECORRENZA_STATO
                         END
                   END
                      DTA_DECORRENZA_STATO,
                   -----------------------------
                   DTA_SCADENZA_STATO,
                   --nvl(COD_STATO_PRECEDENTE,'-1'),
                   CASE
                      WHEN     w.COD_STATO IN ('IN', 'SO')
                           AND R.DTA_DECORRENZA_STATO IS NOT NULL
                           AND DTA_CHIUSURA_STATO IS NOT NULL
                      THEN
                         (SELECT COD_STATO_PRECEDENTE
                            FROM (SELECT X.COD_STATO_PRECEDENTE,
                                         X.COD_ABI_CARTOLARIZZATO,
                                         X.COD_NDG,
                                         X.TMS,
                                         MAX (
                                            X.TMS)
                                         OVER (
                                            PARTITION BY X.COD_ABI_CARTOLARIZZATO,
                                                         X.COD_NDG)
                                            MAX_TMS
                                    FROM T_MCRE0_APP_PERCORSI X) GR
                           WHERE     gr.TMS = gr.MAX_TMS
                                 AND w.COD_ABI_CARTOLARIZZATO =
                                        GR.COD_ABI_CARTOLARIZZATO(+)
                                 AND w.COD_NDG = GR.COD_NDG(+))
                      ELSE
                         NVL (COD_STATO_PRECEDENTE, '-1')
                   END
                      COD_STATO_PRECEDENTE,
                   DTA_DECORRENZA_STATO_PRE,
                   DTA_PROCESSO,
                   COD_PROCESSO_PRE,
                   --w.COD_MACROSTATO, DTA_DEC_MACROSTATO,
                   CASE
                      WHEN     COD_STATO = 'IN'
                           AND R.DTA_DECORRENZA_STATO IS NOT NULL
                           AND DTA_CHIUSURA_STATO IS NULL
                      THEN
                         'RS'
                      ELSE
                         w.COD_MACROSTATO
                   END
                      COD_MACROSTATO,
                   CASE
                      WHEN     COD_STATO = 'IN'
                           AND R.DTA_DECORRENZA_STATO IS NOT NULL
                           AND DTA_CHIUSURA_STATO IS NULL
                      THEN
                         TRUNC (R.DTA_DECORRENZA_STATO)
                      ELSE
                         DTA_DEC_MACROSTATO
                   END
                      DTA_DEC_MACROSTATO,
                   COD_COMPARTO_HOST,
                   COD_RAMO_HOST,
                   ID_STATO_POSIZIONE,
                   COD_CLIENTE_ESTESO,
                   ID_CLIENTE_ESTESO,
                   DESC_ANAG_GESTORE_MKT,
                   COD_GESTORE_MKT,
                   COD_TIPO_PORTAFOGLIO,
                   FLG_GESTIONE_ESTERNA,
                   VAL_PERC_DECURTAZIONE,
                   w.ID_DPERMO,
                   ID_TRANSIZIONE,
                   NVL (w.FLG_OUTSOURCING, I.FLG_OUTSOURCING) FLG_OUTSOURCING,
                   COD_MATR_RISCHIO,
                   COD_UO_RISCHIO,
                   COD_DISP_RISCHIO,
                   --istituti
                   i.DESC_ISTITUTO,
                   i.DESC_BREVE,
                   i.FLG_TARGET,
                   i.FLG_CARTOLARIZZATO,
                   i.DTA_ABI_ELAB,
                   --anagrafiche
                   A.DESC_NOME_CONTROPARTE,
                   GE.VAL_ANA_GRE DESC_GRUPPO_ECONOMICO,
                   DTA_RIF_PD_ONLINE,
                   VAL_RATING_ONLINE,
                   VAL_PD_ONLINE,
                   --PCR
                   SCSB_UTI_TOT,
                   SCSB_ACC_TOT,
                   SCSB_UTI_CASSA,
                   SCSB_UTI_FIRMA,
                   SCSB_ACC_CASSA,
                   SCSB_ACC_FIRMA,
                   GB_VAL_MAU,
                   GEGB_ACC_CASSA,
                   GEGB_ACC_FIRMA,
                   GEGB_UTI_CASSA,
                   GEGB_UTI_FIRMA,
                   GLGB_ACC_CASSA,
                   GLGB_ACC_FIRMA,
                   GLGB_UTI_CASSA,
                   GLGB_UTI_FIRMA,
                   SCSB_ACC_SOSTITUZIONI,
                   SCSB_UTI_SOSTITUZIONI,                               --v1.2
                   --GB
                   GB.COD_FILIALE COD_FILIALE_GB,
                   COD_PROCESSO_CALCOLATO COD_PROCESSO_CALCOLATO_GB,
                   GB.COD_MACROSTATO_PROPOSTO COD_MACROSTATO_PROPOSTO_GB,
                   GB.DTA_INS DTA_INS_GB,
                   FLG_STATO FLG_STATO_GB,
                   w.COD_GRUPPO_SUPER_OLD                               --V2.0
              FROM t_mcre0_web_data w,
                   mcre_own.T_MCRE0_DWH_PCR P,
                   T_MCRE0_DWH_AGRE GE,
                   MV_MCRE0_APP_ISTITUTI I,
                   T_MCRE0_DWH_AGRU A,
                   T_MCRE0_APP_GB_GESTIONE GB,
                   (SELECT *
                      FROM (SELECT r.*,
                                   MAX (
                                      tms_ini)
                                   OVER (
                                      PARTITION BY cod_abi_cartolarizzato,
                                                   cod_ndg)
                                      max_tms
                              FROM T_MCRE0_APP_RS_POSIZIONI r)
                     WHERE tms_ini = max_tms) r
             WHERE     w.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO(+)
                   AND w.COD_NDG = P.COD_NDG(+)
                   AND NVL (w.COD_GRUPPO_ECONOMICO, '-1') = GE.COD_GRE
                   AND w.COD_ABI_ISTITUTO = I.COD_ABI
                   AND w.COD_SNDG = A.COD_SNDG
                   AND w.COD_ABI_CARTOLARIZZATO =
                          GB.COD_ABI_CARTOLARIZZATO(+)
                   AND w.COD_NDG = GB.COD_NDG(+)
                   AND GB.FLG_STATO(+) = 1
                   AND w.COD_ABI_CARTOLARIZZATO = R.COD_ABI_CARTOLARIZZATO(+)
                   AND w.COD_NDG = R.COD_NDG(+))
   SELECT n.TODAY_FLG,
          n.FLG_ACTIVE,
          n.FLG_SOURCE,
          n.FLG_BLOCCO,
          n.ID_DPERFG,
          n.ID_DPERMO,
          n.COD_NDG,
          n.COD_ABI_CARTOLARIZZATO,
          n.COD_SNDG,
          n.DESC_NOME_CONTROPARTE,
          n.COD_ABI_ISTITUTO,
          n.DESC_ISTITUTO,
          n.DESC_BREVE,
          n.FLG_TARGET,
          n.FLG_CARTOLARIZZATO,
          n.DTA_ABI_ELAB,
          n.COD_GRUPPO_ECONOMICO,
          n.DESC_GRUPPO_ECONOMICO,
          n.COD_GRUPPO_LEGAME,
          n.FLG_GRUPPO_ECONOMICO,
          n.FLG_GRUPPO_LEGAME,
          n.FLG_SINGOLO,
          n.FLG_CONDIVISO,
          n.FLG_SOMMA,
          n.FLG_OUTSOURCING,
          n.COD_FILIALE,
          n.COD_STRUTTURA_COMPETENTE,
          n.COD_STATO,
          n.DTA_DECORRENZA_STATO,
          n.DTA_SCADENZA_STATO,
          n.COD_STATO_PRECEDENTE,
          n.DTA_DECORRENZA_STATO_PRE,
          n.DTA_INTERCETTAMENTO,
          n.COD_TIPO_INGRESSO,
          n.COD_CAUSALE_INGRESSO,
          n.COD_PERCORSO,
          n.COD_PROCESSO,
          n.DTA_PROCESSO,
          n.COD_PROCESSO_PRE,
          n.COD_MACROSTATO,
          n.DTA_DEC_MACROSTATO,
          n.COD_RAMO_CALCOLATO,
          n.COD_COMPARTO_CALCOLATO,
          n.DTA_COMPARTO_CALCOLATO,
          n.COD_COMPARTO_CALCOLATO_PRE,
          n.COD_GRUPPO_SUPER,
          n.COD_GRUPPO_SUPER_OLD,
          n.FLG_RIPORTAFOGLIATO,
          n.DTA_LAST_RIPORTAF,
          n.DTA_UTENTE_ASSEGNATO,
          n.COD_COMPARTO_ASSEGNATO,
          n.ID_UTENTE,
          n.ID_UTENTE_PRE,
          n.COD_SERVIZIO,
          n.DTA_SERVIZIO,
          n.ID_STATO_POSIZIONE,
          n.COD_CLIENTE_ESTESO,
          n.ID_CLIENTE_ESTESO,
          n.DESC_ANAG_GESTORE_MKT,
          n.COD_GESTORE_MKT,
          n.COD_TIPO_PORTAFOGLIO,
          n.FLG_GESTIONE_ESTERNA,
          n.VAL_PERC_DECURTAZIONE,
          n.COD_COMPARTO_HOST,
          n.ID_TRANSIZIONE,
          n.COD_RAMO_HOST,
          n.COD_MATR_RISCHIO,
          n.COD_UO_RISCHIO,
          n.COD_DISP_RISCHIO,
          n.DTA_INS,
          n.DTA_UPD,
          n.COD_OPERATORE_INS_UPD,
          n.COD_MATR_ASSEGNATORE,
          n.COD_SEZIONE_PREASSEGNATA,
          n.ID_UTENTE_PREASSEGNATO,
          n.COD_COMPARTO_PREASSEGNATO,
          n.COD_PROCESSO_PREASSEGNATO,
          n.FLG_STATO_GB,
          n.COD_FILIALE_GB,
          n.COD_PROCESSO_CALCOLATO_GB,
          n.COD_MACROSTATO_PROPOSTO_GB,
          n.DTA_INS_GB,
          n.DTA_RIF_PD_ONLINE,
          n.VAL_RATING_ONLINE,
          n.VAL_PD_ONLINE,
          n.SCSB_UTI_TOT,
          n.SCSB_ACC_TOT,
          n.SCSB_UTI_CASSA,
          n.SCSB_UTI_FIRMA,
          n.SCSB_ACC_CASSA,
          n.SCSB_ACC_FIRMA,
          n.GB_VAL_MAU,
          n.GEGB_ACC_CASSA,
          n.GEGB_ACC_FIRMA,
          n.GEGB_UTI_CASSA,
          n.GEGB_UTI_FIRMA,
          n.GLGB_ACC_CASSA,
          n.GLGB_ACC_FIRMA,
          n.GLGB_UTI_CASSA,
          n.GLGB_UTI_FIRMA,
          n.SCSB_ACC_SOSTITUZIONI,
          n.SCSB_UTI_SOSTITUZIONI
     FROM n;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ALL_DATA TO MCRE_USR;
