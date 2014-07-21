/* Formatted on 21/07/2014 18:35:09 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RIO_ADVISOR
(
   ID_ADVISOR,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   ID_ADVISOR_CONSULENZA,
   DESC_TIPO_CONSULENZA,
   ID_ADVISOR_GR_GESTIONE,
   DESC_TIPO_GESTIONE,
   ID_ADVISOR_GR_ISP,
   DESC_TIPO_GR_ISP,
   COD_STATO_RISCHIO
)
AS
   SELECT id_advisor,
          cod_abi_cartolarizzato,
          cod_ndg,
          cod_sndg,
          id_advisor_consulenza,
          b.desc_tipo desc_tipo_consulenza,
          id_advisor_gr_gestione,
          c.desc_tipo desc_tipo_gestione,
          id_advisor_gr_isp,
          d.desc_tipo desc_tipo_gr_isp,
          cod_stato_rischio
     FROM t_mcre0_app_rio_advisor a,
          t_mcre0_cl_rio b,
          t_mcre0_cl_rio c,
          t_mcre0_cl_rio d
    WHERE     a.id_advisor_consulenza = b.cod_tipo(+)
          AND b.val_utilizzo(+) = 'ADVISOR_CONSULENZA'
          AND a.id_advisor_gr_gestione = c.cod_tipo(+)
          AND c.val_utilizzo(+) = 'ADVISOR_GRUPPO_GESTIONE'
          AND a.id_advisor_gr_isp = d.cod_tipo(+)
          AND d.val_utilizzo(+) = 'ADVISOR_GRUPPO_ISP'
          AND a.flg_delete = 0;
