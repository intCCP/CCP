/* Formatted on 21/07/2014 18:46:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_ALLINEA_SAG
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
   SELECT                                  -- V1 27/05/2011 VG Solo utilizzato
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
     FROM (SELECT G1.COD_ABI_CARTOLARIZZATO,
                  G1.COD_ABI_ISTITUTO,
                  G1.COD_SNDG,
                  G1.COD_NDG,
                  I.DESC_ISTITUTO,
                  I.DESC_BREVE,
                  A.DESC_NOME_CONTROPARTE,
                  DECODE (I.FLG_TARGET, 'Y', '1', '0') FLG_TARGET,
                  DECODE (I.FLG_OUTSOURCING, 'Y', '1', '0') FLG_OUTSOURCING,
                  NVL (I.FLG_ABI_LAVORATO, '0') FLG_ABI_LAVORATO,
                  NVL (X.COD_STATO, 'BO') COD_STATO,
                  NVL (X.COD_MACROSTATO, 'BO') COD_MACROSTATO,
                  X.COD_PROCESSO,
                  X.COD_PERCORSO,
                  PCR.SCSB_UTI_TOT SCSB_ESPOSIZIONE,
                  X.COD_STATO_PRECEDENTE,
                  G1.COD_GRUPPO_ECONOMICO,
                  G1.COD_GRUPPO_LEGAME,
                  G1.COD_GRUPPO_SUPER,
                  S.COD_SAG,
                  COUNT (*) OVER (PARTITION BY G1.COD_SNDG) VAL_CNT
             FROM (SELECT DISTINCT W.COD_GRUPPO_SUPER, W.COD_SNDG
                     FROM T_MCRE0_APP_ALERT_POS Q, T_MCRE0_APP_FILE_GUIDA W
                    WHERE     ALERT_2 IS NOT NULL
                          AND Q.COD_ABI_CARTOLARIZZATO =
                                 W.COD_ABI_CARTOLARIZZATO
                          AND Q.COD_NDG = W.COD_NDG) G,
                  MV_MCRE0_APP_UPD_FIELD X,
                  MV_MCRE0_APP_ISTITUTI I,
                  T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
                  T_MCRE0_APP_PCR PCR,
                  T_MCRE0_APP_FILE_GUIDA G1,
                  T_MCRE0_APP_SAG S
            WHERE     G1.COD_GRUPPO_SUPER = G.COD_GRUPPO_SUPER
                  AND G1.COD_ABI_CARTOLARIZZATO = X.COD_ABI_CARTOLARIZZATO(+)
                  AND G1.COD_NDG = X.COD_NDG(+)
                  AND G1.COD_ABI_ISTITUTO = I.COD_ABI(+)
                  AND G1.COD_SNDG = A.COD_SNDG(+)
                  AND G1.COD_ABI_CARTOLARIZZATO =
                         PCR.COD_ABI_CARTOLARIZZATO(+)
                  AND G1.COD_NDG = PCR.COD_NDG(+)
                  AND G1.COD_SNDG = S.COD_SNDG(+)
                  AND S.FLG_CONFERMA = 'S')
    WHERE VAL_CNT > 1;
