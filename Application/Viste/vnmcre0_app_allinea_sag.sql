/* Formatted on 21/07/2014 18:45:18 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALLINEA_SAG
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_SNDG,
   COD_NDG,
   DESC_ISTITUTO,
   DESC_BREVE,
   DESC_NOME_CONTROPARTE,
   FLG_TARGET,
   FLG_OUTSOURCING,
   FLG_ABI_LAVORATO,
   COD_STATO,
   COD_MACROSTATO,
   COD_PROCESSO,
   COD_PERCORSO,
   SCSB_ESPOSIZIONE,
   COD_STATO_PRECEDENTE,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_LEGAME,
   COD_GRUPPO_SUPER,
   COD_SAG,
   VAL_CNT
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(s) no_parallel(q)*/
                                           -- V1 27/05/2011 VG Solo utilizzato
                                                  -- v2 17/06/2011 VG: New PCR
         "COD_ABI_CARTOLARIZZATO",
         "COD_ABI_ISTITUTO",
         "COD_SNDG",
         "COD_NDG",
         "DESC_ISTITUTO",
         "DESC_BREVE",
         "DESC_NOME_CONTROPARTE",
         "FLG_TARGET",
         "FLG_OUTSOURCING",
         "FLG_ABI_LAVORATO",
         "COD_STATO",
         "COD_MACROSTATO",
         "COD_PROCESSO",
         "COD_PERCORSO",
         "SCSB_ESPOSIZIONE",
         "COD_STATO_PRECEDENTE",
         "COD_GRUPPO_ECONOMICO",
         "COD_GRUPPO_LEGAME",
         "COD_GRUPPO_SUPER",
         "COD_SAG",
         "VAL_CNT"
    FROM (SELECT x.COD_ABI_CARTOLARIZZATO,
                 x.COD_ABI_ISTITUTO,
                 x.COD_SNDG,
                 x.COD_NDG,
                 x.DESC_ISTITUTO,
                 x.DESC_BREVE,
                 x.DESC_NOME_CONTROPARTE,
                 DECODE (x.FLG_TARGET, 'Y', '1', '0') FLG_TARGET,
                 DECODE (x.FLG_OUTSOURCING, 'Y', '1', '0') FLG_OUTSOURCING,
                 NVL (
                    DECODE (
                       DTA_ABI_ELAB,
                       (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
                          FROM T_MCRE0_APP_ABI_ELABORATI), '1',
                       '0'),
                    '0')
                    FLG_ABI_LAVORATO,
                 NVL (X.COD_STATO, 'BO') COD_STATO,
                 NVL (X.COD_MACROSTATO, 'BO') COD_MACROSTATO,
                 X.COD_PROCESSO,
                 X.COD_PERCORSO,
                 x.SCSB_UTI_TOT SCSB_ESPOSIZIONE,
                 X.COD_STATO_PRECEDENTE,
                 x.COD_GRUPPO_ECONOMICO,
                 x.COD_GRUPPO_LEGAME,
                 x.COD_GRUPPO_SUPER,
                 S.COD_SAG,
                 COUNT (*) OVER (PARTITION BY x.COD_SNDG) VAL_CNT
            FROM --              (SELECT DISTINCT W.COD_GRUPPO_SUPER, W.COD_SNDG
 --                     FROM T_MCRE0_APP_ALERT_POS Q, T_MCRE0_APP_FILE_GUIDA W
                               --                    WHERE ALERT_2 IS NOT NULL
                    --                          AND Q.COD_ABI_CARTOLARIZZATO =
                   --                                 W.COD_ABI_CARTOLARIZZATO
                     --                          AND Q.COD_NDG = W.COD_NDG) G,
                                 --                  MV_MCRE0_APP_UPD_FIELD X,
                                  --                  MV_MCRE0_APP_ISTITUTI I,
                          --                  T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
                                      --                  T_MCRE0_APP_PCR PCR,
                                --                  T_MCRE0_APP_FILE_GUIDA G1,
                 T_MCRE0_APP_ALERT_POS Q,
                 T_MCRE0_APP_SAG S,
                 -- V_MCRE0_APP_UPD_FIELDS_ALL x
                 -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
                 V_MCRE0_APP_UPD_FIELDS x
           WHERE     q.ALERT_2 IS NOT NULL
                 AND Q.COD_ABI_CARTOLARIZZATO = x.COD_ABI_CARTOLARIZZATO
                 AND Q.COD_NDG = x.COD_NDG
                 AND x.COD_SNDG = S.COD_SNDG(+)
                 AND S.FLG_CONFERMA(+) = 'S')
   WHERE VAL_CNT > 1;
