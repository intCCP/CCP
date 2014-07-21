/* Formatted on 21/07/2014 18:42:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_PARERI_DELIBERE
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_PROTOCOLLO_DELIBERA,
   FLG_DIFFORME,
   DESC_PARERE,
   DESC_PARERE_ESTESO,
   DESC_TIPO_PARERE,
   COD_PROGR_PARERE,
   COD_TIPO_PAR,
   ID_PARERE,
   COD_UO,
   COD_UTENTE,
   DTA_INS_PARERE,
   COD_ORDINALE,
   COD_LABEL_WEB,
   DTA_UPD
)
AS
   SELECT       -- 0215 outerjoin con delibere inc e soff per filtro tipologia
          -- 0404 tolta decode tipo pareri
          -- VG 20140616 dta_upd aggiunta
          P.cod_abi,
          P.cod_ndg,
          P.cod_sndg,
          P.cod_protocollo_delibera,
          flg_difforme,
          p.desc_parere,
          --   NVL (TO_CHAR (p.desc_parere_esteso), p.desc_parere) AS desc_parere_esteso,
          NVL (p.desc_parere_esteso, TO_CLOB (p.desc_parere))
             AS desc_parere_esteso,
          DECODE (cod_dominio, NULL, 'n.d.', do.desc_dominio)
             desc_tipo_parere,
          p.cod_progr_parere,
          p.cod_tipo_par AS cod_tipo_par,
          p.id_parere,
          p.cod_uo,
          p.cod_utente,
          p.dta_ins_parere,
          do.cod_ordinale,
          do.cod_label_web,
          p.dta_upd
     FROM t_mcrei_app_pareri p,
          (SELECT *
             FROM t_mcrei_cl_domini
            WHERE cod_dominio = 'TIPO_PARERE_SOFF') DO,
          t_mcrei_app_delibere di
    WHERE     p.cod_tipo_par = do.val_dominio
          AND p.flg_attiva = '1'
          AND (p.flg_delete IS NULL OR p.flg_delete = 0)
          AND p.cod_abi = di.cod_abi(+)
          AND p.cod_ndg = di.cod_ndg(+)
          AND P.cod_protocollo_delibera = di.cod_protocollo_delibera(+);
