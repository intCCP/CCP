/* Formatted on 17/06/2014 18:09:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_MPL_RAPPORTI_PROPOSTE
(
   COD_ABI_CARTOLARIZZATO,
   COD_RAPPORTO,
   COD_FORMA_TECNICA,
   DESC_FORMA_TECNICA,
   COD_TIPO_FIDO,
   COD_NATURA,
   VAL_ACCORDATO,
   VAL_UTILIZZATO,
   VAL_DI_CUI_CAPITALE,
   VAL_DI_CUI_MORA,
   VAL_NUM_RATE_IMPAGATE,
   VAL_IMP_RATE_IMPAGATE,
   VAL_DEBITO_RESIDUO,
   COD_PERIODICITA_RATE
)
AS
   SELECT d.cod_abi AS cod_abi_cartolarizzato,
          NULL AS cod_rapporto,
          NULL AS cod_forma_tecnica,
          d.desc_ft AS desc_forma_tecnica,
          d.COD_TIPO_RAPP AS cod_tipo_fido,
          NULL AS cod_natura,
          d.VAL_IMP_ACCORDATO AS val_accordato,
          d.VAL_IMP_UTILIZZATO AS val_utilizzato,
          d.VAL_ESPOSIZIONE_QC AS val_di_cui_capitale,     --> di cui capitale
          d.VAL_INTERESSI_MORA AS val_di_cui_mora,             --> di cui mora
          d.NUM_RATE_IMPAGATE AS val_num_rate_impagate, --> numero rate impagate
          d.VAL_QC_RATE_IMP AS val_imp_rate_impagate, --> totale rate impagate
          d.VAL_DEBITO_RESIDUO AS val_debito_residuo,
          d.DESC_PERIODO AS cod_periodicita_rate          --> periodicità rate
     FROM t_mcrei_app_mpl_rapporti d;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_MPL_RAPPORTI_PROPOSTE TO MCRE_USR;
