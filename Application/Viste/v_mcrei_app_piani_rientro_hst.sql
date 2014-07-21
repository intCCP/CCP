/* Formatted on 21/07/2014 18:40:35 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_PIANI_RIENTRO_HST
(
   ID_DPER,
   COD_ABI,
   COD_SNDG,
   COD_NDG,
   COD_RAPPORTO,
   DTA_STIMA,
   NUM_RATA,
   DTA_SCADENZA_RATA,
   VAL_RATA,
   DTA_INS_PIANO,
   DTA_UPD_PIANO,
   COD_UTENTE,
   COD_PROTOCOLLO_DELIBERA,
   FLG_ATTIVA,
   DTA_INS,
   DTA_UPD,
   COD_OPERATORE_INS_UPD,
   COD_FORMA_TECNICA
)
AS
   SELECT id_dper,
          cod_abi,
          cod_sndg,
          cod_ndg,
          cod_rapporto,
          dta_stima,
          num_rata,
          dta_scadenza_rata,
          val_rata,
          dta_ins_piano,
          dta_upd_piano,
          cod_utente,
          cod_protocollo_delibera,
          flg_attiva,
          dta_ins,
          dta_upd,
          cod_operatore_ins_upd,
          cod_forma_tecnica                                        --24 aprile
     FROM t_mcrei_hst_piani_rientro;
