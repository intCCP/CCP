/* Formatted on 21/07/2014 18:45:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ALLINEA_STATO
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
   COD_PROCESSO,
   COD_PERCORSO,
   SCSB_ESPOSIZIONE,
   COD_STATO_PRECEDENTE,
   VAL_CNT_NON_ALL
)
AS
   SELECT                     -- v1 06/05/2011  VG: WF in 3-4 x RIO e 4-5 x PT
          -- v2 10/05/2011  VG: Contatore ndg non allineati per sndg
          -- v3 17/05/2011  MM: nvl flg_abi_elaborato (non decode), flg_outsourcing da istituti
          -- v4 31/05/2011  VG: solo utilizzato
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
          COD_PROCESSO,
          COD_PERCORSO,
          SCSB_ESPOSIZIONE,
          COD_STATO_PRECEDENTE,
          SUM (DECODE (NVL (COD_STATO, 'BO'), STATO_POS, 0, 1))
             OVER (PARTITION BY COD_SNDG)
             VAL_CNT_NON_ALL
     FROM (SELECT DISTINCT
                  x.COD_ABI_CARTOLARIZZATO,
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
                        x.DTA_ABI_ELAB,
                        (SELECT MAX (x.DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
                           FROM T_MCRE0_APP_ABI_ELABORATI), '1',
                        '0'),
                     '0')
                     FLG_ABI_LAVORATO,
                  NVL (X.COD_STATO, 'BO') COD_STATO,
                  X1.COD_STATO STATO_POS,
                  X.COD_PROCESSO,
                  X.COD_PERCORSO,
                  x.SCSB_UTI_TOT SCSB_ESPOSIZIONE,
                  X.COD_STATO_PRECEDENTE
             FROM                              --     MV_MCRE0_APP_ISTITUTI I,
                                      --      T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
                                                  --      T_MCRE0_APP_PCR PCR,
                                         --       (SELECT GG.*, 'BO' COD_STATO
                                --          FROM T_MCRE0_APP_FILE_GUIDA GG) G,
                  (SELECT COD_ABI_CARTOLARIZZATO, COD_NDG
                     FROM T_MCRE0_APP_PT_GESTIONE_TAVOLI
                    WHERE FLG_WORKFLOW IN (4, 5)
                   UNION
                   SELECT COD_ABI_CARTOLARIZZATO, COD_NDG
                     FROM T_MCRE0_APP_RIO_GESTIONE
                    WHERE FLG_WORKFLOW IN (3, 4)) P,
                  -- MV_MCRE0_APP_UPD_FIELD X1
                  V_MCRE0_APP_UPD_FIELDS_P1 x1,
                  --MV_MCRE0_APP_UPD_FIELD X,
                  V_MCRE0_APP_UPD_FIELDS_all x
            WHERE     P.COD_ABI_CARTOLARIZZATO = X1.COD_ABI_CARTOLARIZZATO
                  AND P.COD_NDG = X1.COD_NDG
                  AND x.COD_SNDG = X1.COD_SNDG --     AND G.COD_ABI_CARTOLARIZZATO = X.COD_ABI_CARTOLARIZZATO(+)
                                            --    AND G.COD_NDG = X.COD_NDG(+)
                                  --     AND G.COD_ABI_ISTITUTO = I.COD_ABI(+)
                                        --      AND G.COD_SNDG = A.COD_SNDG(+)
 --      AND G.COD_ABI_CARTOLARIZZATO =                         PCR.COD_ABI_CARTOLARIZZATO(+)
                                     --         AND G.COD_NDG = PCR.COD_NDG(+)
          );
