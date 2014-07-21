/* Formatted on 21/07/2014 18:33:04 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALLINEA_STATO
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
   DTA_DECORRENZA_STATO,
   COD_PROCESSO,
   COD_PERCORSO,
   COD_STATO_PRECEDENTE,
   SCSB_ESPOSIZIONE,
   VAL_CNT_NON_ALL,
   COD_GRUPPO_SUPER
)
AS
   SELECT                    -- v1 06/05/2011   VG: WF in 3-4 x RIO e 4-5 x PT
          -- v2 10/05/2011 VG: Contatore ndg non allineati per sndg
          -- v3 17/05/2011 MM: nvl flg_abi_elaborato (non decode), flg_outsourcing da istituti
          -- v4 31/05/2011 VG: solo utilizzato
          -- v5 17/06/2011 VG: New PCR
          -- v6 29/06/2011 MM: aggiunta distinct internamente con count esterna
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
          DTA_DECORRENZA_STATO,
          COD_PROCESSO,
          COD_PERCORSO,
          COD_STATO_PRECEDENTE,
          SCSB_ESPOSIZIONE,
          SUM (DECODE (NVL (COD_STATO, 'BO'), STATO_POS, 0, 1))
             OVER (PARTITION BY COD_SNDG)
             VAL_CNT_NON_ALL,
          cod_gruppo_super
     FROM (SELECT DISTINCT
                  X.COD_ABI_CARTOLARIZZATO,
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
                        X.DTA_ABI_ELAB,
                        (SELECT MAX (X.DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
                           FROM T_MCRE0_APP_ABI_ELABORATI), '1',
                        '0'),
                     '0')
                     FLG_ABI_LAVORATO,
                  NVL (X.COD_STATO, 'BO') COD_STATO,
                  X.DTA_DECORRENZA_STATO,
                  X1.COD_STATO STATO_POS,
                  DECODE (X.TODAY_FLG, '1', X.COD_PROCESSO, NULL)
                     COD_PROCESSO,
                  DECODE (X.TODAY_FLG, '1', X.COD_PERCORSO, TO_NUMBER (NULL))
                     COD_PERCORSO,
                  DECODE (X.TODAY_FLG, '1', X.COD_STATO_PRECEDENTE, NULL)
                     COD_STATO_PRECEDENTE,
                  X.SCSB_UTI_TOT SCSB_ESPOSIZIONE,
                  X.COD_GRUPPO_SUPER
             FROM (SELECT COD_ABI_CARTOLARIZZATO, COD_NDG
                     FROM T_MCRE0_APP_PT_GESTIONE_TAVOLI
                    WHERE FLG_WORKFLOW IN (4, 5)
                   UNION
                   SELECT COD_ABI_CARTOLARIZZATO, COD_NDG
                     FROM T_MCRE0_APP_RIO_GESTIONE
                    WHERE FLG_WORKFLOW IN (3, 4)) P,
                  V_MCRE0_APP_UPD_FIELDS_P1 X1,
                  V_MCRE0_APP_UPD_FIELDS_ALL X
            WHERE     P.COD_ABI_CARTOLARIZZATO = X1.COD_ABI_CARTOLARIZZATO
                  AND P.COD_NDG = X1.COD_NDG
                  AND X.COD_SNDG = X1.COD_SNDG);
