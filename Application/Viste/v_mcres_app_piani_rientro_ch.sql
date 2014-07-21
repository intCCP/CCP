/* Formatted on 21/07/2014 18:42:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_PIANI_RIENTRO_CH
(
   COD_ABI,
   COD_NDG,
   COD_RAPPORTO,
   COD_PROTOCOLLO_DELIBERA,
   NUM_RATA,
   COD_SNDG,
   DTA_STIMA,
   DTA_SCADENZA_RATA,
   VAL_RATA,
   DTA_INS_PIANO,
   DTA_UPD_PIANO,
   COD_UTENTE,
   COD_FORMA_TECNICA,
   FLG_INVIO_DELIBERE_SISBA
)
AS
   SELECT             -- 20120928 AG  Inclusi piani extra (e rapporti leading)
         r.cod_abi,
          r.cod_ndg,
          r.cod_rapporto,
          p.cod_protocollo_delibera,
          p.num_rata,
          p.cod_sndg,
          p.dta_stima,
          p.dta_scadenza_rata,
          p.val_rata,
          p.dta_ins_piano,
          p.dta_upd_piano,
          p.cod_utente,
          p.cod_forma_tecnica,
          i.flg_invio_delibere_sisba
     FROM t_mcres_app_rapporti r,
          t_mcres_app_istituti i,
          (SELECT cod_abi,
                  cod_ndg,
                  cod_rapporto,
                  cod_protocollo_delibera,
                  num_rata,
                  cod_sndg,
                  dta_stima,
                  dta_scadenza_rata,
                  val_rata,
                  dta_ins_piano,
                  dta_upd_piano,
                  cod_utente,
                  cod_forma_tecnica
             FROM t_mcrei_app_piani_rientro
            WHERE 0 = 0 AND flg_attiva = '1' AND flg_annullato = 0
           UNION ALL
           SELECT cod_abi,
                  cod_ndg,
                  cod_rapporto,
                  cod_protocollo_delibera,
                  num_rata,
                  cod_sndg,
                  dta_stima,
                  dta_scadenza_rata,
                  val_rata,
                  dta_ins_piano,
                  dta_upd_piano,
                  cod_utente,
                  cod_forma_tecnica
             FROM t_mcrei_app_piani_rientro_extr
            WHERE 0 = 0 AND flg_attiva = '1') p
    WHERE     0 = 0
          AND r.cod_abi = i.cod_abi(+)
          AND r.cod_abi = p.cod_abi(+)
          AND r.cod_ndg = p.cod_ndg(+)
          AND r.cod_rapporto = p.cod_rapporto(+)
          AND r.dta_chiusura_rapp <= SYSDATE;
