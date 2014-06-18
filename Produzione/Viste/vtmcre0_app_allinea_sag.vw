/* Formatted on 17/06/2014 18:15:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_ALLINEA_SAG
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
   COD_STATO_PRECEDENTE,
   SCSB_ESPOSIZIONE,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_LEGAME,
   COD_GRUPPO_SUPER,
   COD_SAG,
   VAL_CNT
)
AS
   SELECT /*+ordered no_parallel(s) no_parallel(q)*/
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
         "COD_STATO_PRECEDENTE",
         "SCSB_ESPOSIZIONE",
         "COD_GRUPPO_ECONOMICO",
         "COD_GRUPPO_LEGAME",
         "COD_GRUPPO_SUPER",
         "COD_SAG",
         "VAL_CNT"
    FROM (SELECT X.COD_ABI_CARTOLARIZZATO,
                 X.COD_ABI_ISTITUTO,
                 X.COD_SNDG,
                 X.COD_NDG,
                 X.DESC_ISTITUTO,
                 X.DESC_BREVE,
                 X.DESC_NOME_CONTROPARTE,
                 DECODE (X.FLG_TARGET, 'Y', '1', '0') FLG_TARGET,
                 DECODE (X.FLG_OUTSOURCING, 'Y', '1', '0') FLG_OUTSOURCING,
                 NVL (
                    DECODE (
                       P.DTA_ABI_ELAB,
                       (SELECT MAX (P.DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
                          FROM T_MCRE0_APP_ABI_ELABORATI), '1',
                       '0'),
                    '0')
                    FLG_ABI_LAVORATO,
                 NVL (X.COD_STATO, 'BO') COD_STATO,
                 NVL (X.COD_MACROSTATO, 'BO') COD_MACROSTATO,
                 DECODE (X.TODAY_FLG, '1', X.COD_PROCESSO, NULL) COD_PROCESSO,
                 DECODE (X.TODAY_FLG, '1', X.COD_PERCORSO, TO_NUMBER (NULL))
                    COD_PERCORSO,
                 DECODE (X.TODAY_FLG, '1', X.COD_STATO_PRECEDENTE, NULL)
                    COD_STATO_PRECEDENTE,
                 X.SCSB_UTI_TOT SCSB_ESPOSIZIONE,
                 X.COD_GRUPPO_ECONOMICO,
                 X.COD_GRUPPO_LEGAME,
                 X.COD_GRUPPO_SUPER,
                 S.COD_SAG,
                 COUNT (*) OVER (PARTITION BY X.COD_SNDG) VAL_CNT
            FROM T_MCRE0_APP_ALERT_POS Q,
                 T_MCRE0_APP_SAG S,
                 VTMCRE0_APP_UPD_FIELDS_P1 P,
                 -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
                 VTMCRE0_APP_UPD_FIELDS_ALL X
           WHERE     Q.ALERT_2 IS NOT NULL
                 AND Q.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO
                 AND Q.COD_NDG = P.COD_NDG
                 AND P.COD_GRUPPO_SUPER = X.COD_GRUPPO_SUPER
                 AND X.COD_SNDG = S.COD_SNDG(+)
                 AND S.FLG_CONFERMA(+) = 'S')
   WHERE VAL_CNT > 1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_ALLINEA_SAG TO MCRE_USR;
