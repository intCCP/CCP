/* Formatted on 17/06/2014 18:00:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_RUOLI
(
   DESC_ALERT,
   ID_ALERT,
   VAL_ORDINE_A,
   VAL_ORDINE_E,
   COD_PRIVILEGIO,
   ID_GRUPPO,
   COD_GRUPPO_COMPARTI,
   GB_V,
   GB_R,
   GB_A,
   IN_V,
   IN_R,
   IN_A,
   RIO_V,
   RIO_R,
   RIO_A,
   SC_V,
   SC_R,
   SC_A,
   PT_V,
   PT_R,
   PT_A,
   RS_V,
   RS_R,
   RS_A
)
AS
   SELECT DESC_ALERT,
          a.ID_ALERT,
          VAL_ORDINE_A,
          VAL_ORDINE_E,
          COD_PRIVILEGIO,
          id_gruppo,
          cod_gruppo_comparti,
          0 GB_V,
          0 GB_R,
          0 GB_A,
          0 IN_V,
          0 IN_R,
          0 IN_A,
          0 RIO_V,
          0 RIO_R,
          0 RIO_A,
          0 SC_V,
          0 SC_R,
          0 SC_A,
          0 PT_V,
          0 PT_R,
          0 PT_A,
          0 RS_V,
          0 RS_R,
          0 RS_A
     FROM T_MCRE0_APP_ALERT a, t_mcre0_app_alert_ruoli r
    WHERE FLG_ATTIVO = 'A' AND a.ID_ALERT = R.ID_ALERT
   UNION
   SELECT DESC_ALERT,
          a.ID_ALERT_da_esporre ID_ALERT,
          VAL_ORDINE_A,
          VAL_ORDINE_E,
          COD_PRIVILEGIO,
          id_gruppo,
          cod_gruppo_comparti,
          0 GB_V,
          0 GB_R,
          0 GB_A,
          0 IN_V,
          0 IN_R,
          0 IN_A,
          0 RIO_V,
          0 RIO_R,
          0 RIO_A,
          0 SC_V,
          0 SC_R,
          0 SC_A,
          0 PT_V,
          0 PT_R,
          0 PT_A,
          0 RS_V,
          0 RS_R,
          0 RS_A
     FROM T_MCREi_APP_ALERT a, t_mcrei_app_alert_ruoli r
    WHERE FLG_ATTIVO = 'A' AND a.ID_ALERT = R.ID_ALERT;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_ALERT_RUOLI TO MCRE_USR;
