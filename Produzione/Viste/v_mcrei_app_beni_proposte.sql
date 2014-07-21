/* Formatted on 17/06/2014 18:07:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_BENI_PROPOSTE
(
   ID_LOGICAL_BENE,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA,
   COD_PROTOCOLLO_PACCHETTO,
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
   FLG_MANUALE,
   FLG_TIPO_DATO,
   DTA_VISURA
)
AS
   SELECT p.id_logical_bene,
          p.cod_abi,
          p.cod_ndg,
          p.cod_sndg,
          p.cod_protocollo_delibera,
          p.cod_protocollo_pacchetto,
          p.val_anno_proposta,
          p.val_progr_proposta,
          NVL (p.desc_intestatario, s.desc_intestazione) AS desc_intestatario,
          p.desc_comune,
          NVL (p.cod_tipo_bene, s.cod_tipo_bene) AS cod_tipo_bene,
          NVL (t.desc_cod_tipo_bene, s.desc_tipo_bene) AS desc_cod_tipo_bene,
          NVL (
             p.cod_fogl_map_sub,
             s.cod_foglio || ' ' || s.cod_mappale || ' ' || s.cod_subalterno)
             AS cod_fogl_map_sub,
          NVL (SUBSTR (p.cod_fogl_map_sub, 1, 7), s.cod_foglio) AS foglio,
          NVL (SUBSTR (p.cod_fogl_map_sub, 8, 8), s.cod_mappale) AS mappale,
          NVL (SUBSTR (p.cod_fogl_map_sub, 16, 10), s.cod_subalterno)
             AS subalterno,
          NVL (p.cod_diritto, s.cod_diritto) AS cod_diritto,
          d.desc_dominio AS desc_diritto,
          NVL (p.val_quota, s.val_quo_diritto) AS val_quota_dir,
          p.flg_manuale,
          p.flg_tipo_dato,
          DTA_VISURA
     FROM t_mcrei_app_beni_proposte p,
          t_mcrei_cl_domini d,
          t_mcrei_cl_tipo_bene t,
          (SELECT a.cod_sndg, b.*
             FROM t_mcre0_app_all_data a, t_mcrei_app_mpl_beni b
            WHERE a.cod_abi_istituto = b.cod_abi AND a.cod_ndg = b.cod_ndg) s
    WHERE     TRIM (p.cod_tipo_bene) = TRIM (t.cod_tipo_bene(+))
          AND TRIM (d.cod_dominio(+)) = 'COD_DIRITTO'
          AND TRIM (p.cod_diritto) = TRIM (d.val_dominio(+))
          AND p.cod_sndg = s.cod_sndg(+)
          AND p.cod_protocollo_delibera = s.cod_protocollo_delibera(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_BENI_PROPOSTE TO MCRE_USR;
