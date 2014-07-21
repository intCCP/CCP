/* Formatted on 21/07/2014 18:41:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_CENTRI_COSTO
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_UO,
   VAL_CDC_BANCA,
   VAL_CDC_ITF,
   VAL_SPESA_RIP,
   VAL_SPESA_NON_RIP
)
AS
   SELECT                        -- 20130212 A. Galliano     Created this view
        -- 20130221 A. Galliano     Aggiunto filtro su t_mcres_cnf_fatture_sap
         f.cod_abi,
         i.desc_istituto,
         f.cod_uo,
         f.val_cdc_banca,
         f.val_cdc_itf,
         f.val_spesa_rip,
         f.val_spesa_non_rip
    FROM t_mcres_cnf_fatture_sap f, t_mcres_app_istituti i
   WHERE 0 = 0 AND f.cod_abi = i.cod_abi(+) AND f.flg_attivo = 1;
