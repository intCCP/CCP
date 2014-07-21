/* Formatted on 17/06/2014 18:01:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_GEST_ADVISOR
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_MACROSTATO,
   ID_ADVISOR_CONSULENZA,
   ID_ADVISOR_GR_GESTIONE,
   ID_ADVISOR_GR_ISP,
   COD_ADVISOR,
   COD_STATO_RISCHIO,
   DTA_INS,
   DTA_UPD,
   FLG_DELETE,
   DTA_DELETE
)
AS
   SELECT cod_abi_cartolarizzato,
          cod_ndg,
          cod_sndg,
          cod_macrostato,
          id_advisor_consulenza,
          id_advisor_gr_gestione,
          id_advisor_gr_isp,
          cod_advisor,
          cod_stato_rischio,
          dta_ins,
          dta_upd,
          flg_delete,
          dta_delete
     FROM t_mcre0_app_gest_advisor;


GRANT SELECT ON MCRE_OWN.V_MCRE0_APP_GEST_ADVISOR TO MCRE_USR;
