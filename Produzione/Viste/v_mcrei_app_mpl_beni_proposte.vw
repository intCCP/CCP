/* Formatted on 17/06/2014 18:08:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_MPL_BENI_PROPOSTE
(
   COD_ABI,
   COD_NDG,
   VAL_ANNO_PROPOSTA,
   VAL_PROGR_PROPOSTA,
   DESC_INTESTATARIO,
   DESC_COMUNE,
   COD_TIPO_BENE,
   DESC_COD_TIPO_BENE,
   COD_FOGL_MAP_SUB,
   FOGLIO,
   MAPPALE,
   SUBALTERNO,
   COD_DIRITTO,
   DESC_DIRITTO,
   VAL_QUOTA_DIR,
   DTA_VISURA
)
AS
   SELECT                                                   --id_logical_bene,
         p.cod_abi,
          p.cod_ndg,
          -- cod_sndg,
          --cod_protocollo_delibera,
          --cod_protocollo_pacchetto,
          p.val_anno_proposta,
          p.val_progr_proposta,
          p.desc_intestazione AS desc_intestatario,
          p.desc_comune,
          p.cod_tipo_bene,
          t.desc_cod_tipo_bene,
          p.COD_FOGLIO || ' ' || p.COD_MAPPALE || ' ' || p.COD_SUBALTERNO
             AS cod_fogl_map_sub,
          p.COD_FOGLIO AS foglio,
          p.COD_MAPPALE AS mappale,
          p.COD_SUBALTERNO AS subalterno,
          p.cod_diritto,
          desc_dominio AS desc_diritto,
          p.VAL_QUO_DIRITTO AS val_quota_dir,
          --flg_manuale,
          --flg_tipo_dato,
          SYSDATE AS dta_visura
     FROM t_mcrei_app_mpl_beni p, t_mcrei_cl_domini d, t_mcrei_cl_tipo_bene t
    WHERE     TRIM (p.cod_tipo_bene) = TRIM (t.cod_tipo_bene(+))
          AND TRIM (d.cod_dominio(+)) = 'COD_DIRITTO'
          AND TRIM (p.cod_diritto) = TRIM (d.val_dominio(+));


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_MPL_BENI_PROPOSTE TO MCRE_USR;
