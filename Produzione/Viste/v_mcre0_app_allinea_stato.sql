/* Formatted on 17/06/2014 18:01:02 (QP5 v5.227.12220.39754) */
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
   SELECT /******************************************************************************
          -- v1 06/05/2011   VG: WF in 3-4 x RIO e 4-5 x PT
          -- v2 10/05/2011 VG: Contatore ndg non allineati per sndg
          -- v3 17/05/2011 MM: nvl flg_abi_elaborato (non decode), flg_outsourcing da istituti
          -- v4 31/05/2011 VG: solo utilizzato
          -- v5 17/06/2011 VG: New PCR
          -- v6 29/06/2011 MM: aggiunta distinct internamente con count esterna

          Data di creazione:
          Autore:

          mod    : 001
          data   : 22.04.2014
          desc   : Variazione Perimetro DR: aggiunta campo COD_GRUPPO_SUPER
          Autore : Reply - S. De Cesaris

          mod    :
          data   :
          desc   :
          autore :
          *****************************************************************************/
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
          dta_decorrenza_stato,
          cod_processo,
          cod_percorso,
          cod_stato_precedente,
          scsb_esposizione,
          SUM (DECODE (NVL (cod_stato, 'BO'), stato_pos, 0, 1))
             OVER (PARTITION BY cod_sndg)
             val_cnt_non_all,
          -- mod.001
          cod_gruppo_super
     FROM (SELECT DISTINCT
                  x.cod_abi_cartolarizzato,
                  x.cod_abi_istituto,
                  x.cod_sndg,
                  x.cod_ndg,
                  x.desc_istituto,
                  x.desc_breve,
                  x.desc_nome_controparte,
                  DECODE (x.flg_target, 'Y', '1', '0') flg_target,
                  DECODE (x.flg_outsourcing, 'Y', '1', '0') flg_outsourcing,
                  NVL (
                     DECODE (
                        x.dta_abi_elab,
                        (SELECT MAX (x.dta_abi_elab) dta_abi_elab_max
                           FROM t_mcre0_app_abi_elaborati), '1',
                        '0'),
                     '0')
                     flg_abi_lavorato,
                  NVL (x.cod_stato, 'BO') cod_stato,
                  x.dta_decorrenza_stato,
                  x1.cod_stato stato_pos,
                  DECODE (x.today_flg, '1', x.cod_processo, NULL)
                     cod_processo,
                  DECODE (x.today_flg, '1', x.cod_percorso, TO_NUMBER (NULL))
                     cod_percorso,
                  DECODE (x.today_flg, '1', x.cod_stato_precedente, NULL)
                     cod_stato_precedente,
                  x.scsb_uti_tot scsb_esposizione,
                  -- mod.001
                  x.cod_gruppo_super
             FROM (SELECT cod_abi_cartolarizzato, cod_ndg
                     FROM t_mcre0_app_pt_gestione_tavoli
                    WHERE flg_workflow IN (4, 5)
                   UNION
                   SELECT cod_abi_cartolarizzato, cod_ndg
                     FROM t_mcre0_app_rio_gestione
                    WHERE flg_workflow IN (3, 4)) p,
                  v_mcre0_app_upd_fields_p1 x1,
                  v_mcre0_app_upd_fields_all x
            WHERE     p.cod_abi_cartolarizzato = x1.cod_abi_cartolarizzato
                  AND p.cod_ndg = x1.cod_ndg
                  AND x.cod_sndg = x1.cod_sndg);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_ALLINEA_STATO TO MCRE_USR;
