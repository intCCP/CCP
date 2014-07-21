/* Formatted on 21/07/2014 18:46:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_ALLINEA_STATO
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
          cod_abi_cartolarizzato,
          cod_abi_istituto,
          cod_sndg,
          cod_ndg,
          desc_istituto,
          desc_breve,
          desc_nome_controparte,
          flg_target,
          flg_outsourcing,
          flg_abi_lavorato,
          cod_stato,
          cod_processo,
          cod_percorso,
          scsb_esposizione,
          cod_stato_precedente,
          SUM (DECODE (NVL (cod_stato, 'BO'), stato_pos, 0, 1))
             OVER (PARTITION BY cod_sndg)
             val_cnt_non_all
     FROM (SELECT DISTINCT
                  g.cod_abi_cartolarizzato,
                  g.cod_abi_istituto,
                  g.cod_sndg,
                  g.cod_ndg,
                  i.desc_istituto,
                  i.desc_breve,
                  a.desc_nome_controparte,
                  DECODE (i.flg_target, 'Y', '1', '0') flg_target,
                  DECODE (i.flg_outsourcing, 'Y', '1', '0') flg_outsourcing,
                  NVL (i.flg_abi_lavorato, '0') flg_abi_lavorato,
                  NVL (x.cod_stato, 'BO') cod_stato,
                  x1.cod_stato stato_pos,
                  x.cod_processo,
                  x.cod_percorso,
                  pcr.scsb_uti_tot scsb_esposizione,
                  x.cod_stato_precedente
             FROM mv_mcre0_app_upd_field x,
                  mv_mcre0_app_istituti i,
                  t_mcre0_app_anagrafica_gruppo a,
                  t_mcre0_app_pcr pcr,
                  (SELECT gg.*, 'BO' cod_stato
                     FROM t_mcre0_app_file_guida gg) g,
                  (SELECT cod_abi_cartolarizzato, cod_ndg
                     FROM t_mcre0_app_pt_gestione_tavoli
                    WHERE flg_workflow IN (4, 5)
                   UNION
                   SELECT cod_abi_cartolarizzato, cod_ndg
                     FROM t_mcre0_app_rio_gestione
                    WHERE flg_workflow IN (3, 4)) p,
                  mv_mcre0_app_upd_field x1
            WHERE     p.cod_abi_cartolarizzato = x1.cod_abi_cartolarizzato
                  AND p.cod_ndg = x1.cod_ndg
                  AND g.cod_sndg = x1.cod_sndg
                  AND g.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato(+)
                  AND g.cod_ndg = x.cod_ndg(+)
                  AND g.cod_abi_istituto = i.cod_abi(+)
                  AND g.cod_sndg = a.cod_sndg(+)
                  AND g.cod_abi_cartolarizzato =
                         pcr.cod_abi_cartolarizzato(+)
                  AND g.cod_ndg = pcr.cod_ndg(+));
