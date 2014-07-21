/* Formatted on 17/06/2014 18:08:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_PIANI_STORICO_RV
(
   COD_ABI,
   COD_NDG,
   COD_RAPPORTO,
   DTA_STIMA,
   NUM_RATA,
   DTA_SCADENZA_RATA,
   VAL_RATA,
   COD_FORMA_TECNICA,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT p.cod_abi,
          p.cod_ndg,
          p.cod_rapporto AS cod_rapporto,
          p.dta_stima AS dta_stima,
          p.num_rata AS num_rata,
          p.dta_scadenza_rata AS dta_scadenza_rata,
          p.val_rata AS val_rata,
          p.cod_forma_tecnica,
          p.cod_sndg,
          p.cod_protocollo_delibera
     FROM t_mcrei_hst_piani_rivalutati p
   UNION
   SELECT p.cod_abi,
          p.cod_ndg,
          p.cod_rapporto AS cod_rapporto,
          p.dta_stima AS dta_stima,
          p.num_rata AS num_rata,
          p.dta_scadenza_rata AS dta_scadenza_rata,
          p.val_rata AS val_rata,
          p.cod_forma_tecnica,
          p.cod_sndg,
          p.cod_protocollo_delibera
     FROM t_mcrei_app_piani_rientro p
    WHERE flg_Attiva = '1';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_PIANI_STORICO_RV TO MCRE_USR;
