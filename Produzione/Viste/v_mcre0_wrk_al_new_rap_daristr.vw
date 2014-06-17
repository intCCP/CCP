/* Formatted on 17/06/2014 18:07:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_AL_NEW_RAP_DARISTR
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA,
   DTA_INS,
   COD_STATO,
   VAL_ALERT,
   VAL_CNT_RAPPORTI,
   VAL_CNT_DELIBERE
)
AS
   SELECT -- 22/10/2012 INCLUSI I RAPPORTI ESTERO PER CUI ESISTE UN RAPPORTO CON LO STESSO NPE STIMATO SU T_MCREI_HST_RISTRUTTURAZIIONI
         DISTINCT
          RNE.COD_ABI,
          RNE.COD_NDG,
          RNE.COD_SNDG,
          RNE.COD_PROTOCOLLO_DELIBERA,
          SYSDATE DTA_INS,
          'RS' COD_STATO,
          CASE
             WHEN (SYSDATE - RNE.PCR_INS) < 15 THEN 'A'
             WHEN (SYSDATE - RNE.PCR_INS) >= 15 THEN 'R'
          END
             VAL_ALERT,
          COUNT (*) OVER (PARTITION BY RNE.COD_ABI, RNE.COD_NDG)
             AS VAL_CNT_RAPPORTI,
          1 VAL_CNT_DELIBERE
     FROM (SELECT POS.COD_ABI,
                  POS.COD_NDG,
                  POS.COD_PROTOCOLLO_DELIBERA,
                  RST.COD_RAPPORTO,
                  RST.COD_NPE
             FROM (SELECT cod_abi,
                          cod_ndg,
                          DESC_TIPO_RISTR,
                          COD_PROTOCOLLO_DELIBERA,
                          MAX (val_ordinale)
                             OVER (PARTITION BY cod_abi, cod_ndg)
                             AS max_val
                     FROM T_MCREI_HST_RISTRUTTURAZIONI) pos, -- recupero il max_ordinale e il protocollo_delibera assocciato
                  t_mcrei_hst_rapp_ristr rst
            WHERE     rst.cod_abi = pos.cod_abi
                  AND rst.cod_ndg = pos.cod_ndg
                  AND rst.val_ordinale = pos.max_val
                  AND POS.DESC_TIPO_RISTR = 'P') HR, -- HR LIVELLO 2 RAPPORTI RISTRUTTURATI STIMATI
          (SELECT PCR.COD_ABI,
                  PCR.COD_NDG,
                  PCR.COD_SNDG,
                  PCR.COD_RAPPORTO,
                  POS.COD_PROTOCOLLO_DELIBERA,
                  MAX (
                     PCR.DTA_INS)
                  OVER (
                     PARTITION BY PCR.COD_ABI, PCR.COD_NDG, PCR.COD_RAPPORTO)
                     AS PCR_INS
             FROM T_MCREI_APP_PCR_RAPPORTI PCR,
                  (SELECT RI.COD_ABI,
                          RI.COD_NDG,
                          RI.VAL_ORDINALE,
                          RI.COD_PROTOCOLLO_DELIBERA,
                          RANK ()
                          OVER (PARTITION BY RI.COD_ABI, RI.COD_NDG
                                ORDER BY RI.VAL_ORDINALE DESC)
                             RN
                     FROM T_MCREI_HST_RISTRUTTURAZIONI RI
                    WHERE DESC_TIPO_RISTR = 'P') POS,
                  (SELECT DISTINCT re.cod_abi,
                                   re.cod_ndg,
                                   re.cod_rapporto_estero,
                                   RR.val_ordinale
                     FROM t_mcrei_app_rapporti_estero re,
                          t_mcrei_hst_rapp_ristr rr
                    WHERE     re.cod_abi = rr.cod_abi
                          AND re.cod_ndg = rr.cod_ndg
                          AND re.cod_npe = rr.cod_npe
                          AND rr.cod_npe IS NOT NULL) en -- rapporti estero per cui esiste un NPE su T_MCREI_HST_RAPP_RISTR TOLGO SOLO QUELLI
            WHERE     POS.COD_ABI = PCR.COD_ABI
                  AND POS.COD_NDG = PCR.COD_NDG
                  AND POS.RN = 1
                  AND PCR.COD_ABI = EN.COD_ABI(+)
                  AND PCR.COD_NDG = EN.COD_NDG(+)
                  AND PCR.COD_RAPPORTO = EN.COD_RAPPORTO_ESTERO(+)
                  AND EN.COD_RAPPORTO_ESTERO IS NULL) RNE -- RNE LIVELLO 2 RAPPORTI NON ESTERI (O ESTERI PERR CUI NON ESISTE UNA VALUT. PER LO STESSO NPE)
    WHERE     RNE.COD_ABI = HR.COD_ABI(+)
          AND RNE.COD_NDG = HR.COD_NDG(+)
          AND RNE.COD_RAPPORTO = HR.COD_RAPPORTO(+)
          AND HR.COD_RAPPORTO IS NULL;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_WRK_AL_NEW_RAP_DARISTR TO MCRE_USR;
