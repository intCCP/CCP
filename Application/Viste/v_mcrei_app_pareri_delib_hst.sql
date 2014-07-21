/* Formatted on 21/07/2014 18:40:32 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_PARERI_DELIB_HST
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
   DTA_INS_PARERE
)
AS
   SELECT       -- 0215 outerjoin con delibere inc e soff per filtro tipologia
                                              -- 0404 tolta decode tipo pareri
         p.cod_abi,
         p.cod_ndg,
         p.cod_sndg,
         p.cod_protocollo_delibera,
         NULL flg_difforme,
         p.desc_parere,
         --   NVL (TO_CHAR (p.desc_parere_esteso), p.desc_parere) AS desc_parere_esteso,
         --NVL (p.desc_parere_esteso,
         --     TO_CLOB (p.desc_parere)
         --    )
         TO_CHAR (NULL) AS desc_parere_esteso,
         DECODE (cod_dominio, NULL, 'n.d.', DO.desc_dominio) desc_tipo_parere,
         p.cod_progr_parere,
         p.cod_tipo_par AS cod_tipo_par,
         p.id_parere,
         p.cod_uo,
         p.cod_utente,
         p.dta_ins_parere
    FROM t_mcrei_hst_pareri p,
         t_mcrei_cl_domini DO,
         t_mcrei_hst_delibere di,
         t_mcres_app_delibere ds
   WHERE     p.cod_tipo_par = DO.val_dominio(+)
         AND DO.cod_dominio(+) = 'TIPO_PARERE'
         --AND (p.flg_delete IS NULL OR p.flg_delete = 0)
         AND p.cod_abi = di.cod_abi(+)
         AND p.cod_ndg = di.cod_ndg(+)
         AND p.cod_protocollo_delibera = di.cod_protocollo_delibera(+)
         AND p.cod_abi = ds.cod_abi(+)
         AND p.cod_ndg = ds.cod_ndg(+)
         AND p.cod_protocollo_delibera = ds.cod_protocollo_delibera(+);
