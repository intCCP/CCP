/* Formatted on 21/07/2014 18:32:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_PT_NO_VRB
(
   BANCA,
   NDG,
   SNDG,
   STR_COMP,
   STATO_ATT,
   STATO_PROV,
   DENOM,
   GESTORE,
   PERCORSO,
   PROC,
   DATA_ENTRATA,
   DATA_SCAD,
   GRUPPO,
   DESCRIZIONE,
   DATA_RILEV,
   VAL_ALERT
)
AS
   SELECT a.cod_abi_cartolarizzato AS BANCA,
          a.COD_NDG AS NDG,
          a.COD_SNDG AS SNDG,
          a.COD_COMPARTO_ASSEGNATO AS STR_COMP,
          a.cod_Stato AS STATO_ATT,
          a.cod_stato_precedente AS STATO_PROV,
          a.DESC_NOME_CONTROPARTE AS DENOM,
          a.ID_UTENTE AS GESTORE,
          a.cod_percorso AS PERCORSO,
          a.cod_processo AS PROC,
          a.dta_decorrenza_stato AS DATA_ENTRATA,
          a.dta_scadenza_stato AS DATA_SCAD,
          a.cod_gruppo_economico AS GRUPPO,
          a.desc_gruppo_economico AS DESCRIZIONE,
          w.dta_ins AS DATA_RILEV,
          v.VAL_ALERT
     FROM t_mcre0_app_all_data a,
          V_MCRE0_WRK_ALERT_PT_NO_VRB v,
          t_mcrei_app_alert_pos_wrk w
    WHERE     a.cod_abi_cartolarizzato = v.cod_abi
          AND a.cod_ndg = v.cod_ndg
          AND a.cod_abi_cartolarizzato = W.cod_abi
          AND a.cod_ndg = w.cod_ndg;
