
  CREATE MATERIALIZED VIEW "MCRE_OWN"."MV_MCRE0_DENORM_STR_ORG" ("COD_ABI_ISTITUTO_FI", "COD_STRUTTURA_COMPETENTE_FI", "COD_LIVELLO_FI", "COD_STR_ORG_SUP_FI", "DESC_STRUTTURA_COMPETENTE_FI", "COD_ABI_ISTITUTO_AR", "COD_STRUTTURA_COMPETENTE_AR", "COD_LIVELLO_AR", "COD_STR_ORG_SUP_AR", "DESC_STRUTTURA_COMPETENTE_AR", "COD_ABI_ISTITUTO_RG", "COD_STRUTTURA_COMPETENTE_RG", "COD_LIVELLO_RG", "COD_STR_ORG_SUP_RG", "DESC_STRUTTURA_COMPETENTE_RG", "COD_ABI_ISTITUTO_DV", "COD_STRUTTURA_COMPETENTE_DV", "COD_LIVELLO_DV", "COD_STR_ORG_SUP_DV", "DESC_STRUTTURA_COMPETENTE_DV", "COD_ABI_ISTITUTO_DC", "COD_STRUTTURA_COMPETENTE_DC", "COD_LIVELLO_DC", "COD_STR_ORG_SUP_DC", "DESC_STRUTTURA_COMPETENTE_DC")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TSD_MCRE_MW_OWN" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE QUERY REWRITE
  AS SELECT                                                -- V1 17/02/2011 VG: NEW
       -- v2 08/07/2011 MM: aggiunta gerarchia FI-AR-DV-DC, FI-AR, FI, altri
       -- v3  04/02/2012 MC: aggiunte gerarchie FI-AR-RG-DC, FI-DC e RG.
       o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       o1.cod_abi_istituto cod_abi_istituto_ar,
       o1.cod_struttura_competente cod_struttura_competente_ar,
       o1.cod_livello cod_livello_ar,
       o1.cod_str_org_sup cod_str_org_sup_ar,
       o1.desc_struttura_competente desc_struttura_competente_ar,
       o2.cod_abi_istituto cod_abi_istituto_rg,
       o2.cod_struttura_competente cod_struttura_competente_rg,
       o2.cod_livello cod_livello_rg,
       o2.cod_str_org_sup cod_str_org_sup_rg,
       o2.desc_struttura_competente desc_struttura_competente_rg,
       o3.cod_abi_istituto cod_abi_istituto_dv,
       o3.cod_struttura_competente cod_struttura_competente_dv,
       o3.cod_livello cod_livello_dv,
       o3.cod_str_org_sup cod_str_org_sup_dv,
       o3.desc_struttura_competente desc_struttura_competente_dv,
       o4.cod_abi_istituto cod_abi_istituto_dc,
       o4.cod_struttura_competente cod_struttura_competente_dc,
       o4.cod_livello cod_livello_dc,
       o4.cod_str_org_sup cod_str_org_sup_dc,
       o4.desc_struttura_competente desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o,
       t_mcre0_app_struttura_org o1,
       t_mcre0_app_struttura_org o2,
       t_mcre0_app_struttura_org o3,
       t_mcre0_app_struttura_org o4
 WHERE     o.cod_abi_istituto = o1.cod_abi_istituto
       AND o.cod_str_org_sup = o1.cod_struttura_competente
       AND o1.cod_abi_istituto = o2.cod_abi_istituto
       AND o1.cod_str_org_sup = o2.cod_struttura_competente
       AND o2.cod_abi_istituto = o3.cod_abi_istituto
       AND o2.cod_str_org_sup = o3.cod_struttura_competente
       AND o3.cod_abi_istituto = o4.cod_abi_istituto
       AND o3.cod_str_org_sup = o4.cod_struttura_competente
       AND o.cod_livello = 'FI'
       AND o1.cod_livello = 'AR'
       AND o2.cod_livello = 'RG'
       AND o3.cod_livello = 'DV'
       AND o4.cod_livello in ('DC','MC')--= 'DC'
--filiali->regione
UNION
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       NULL cod_abi_istituto_ar,
       NULL cod_struttura_competente_ar,
       NULL cod_livello_ar,
       NULL cod_str_org_sup_ar,
       NULL desc_struttura_competente_ar,
       o2.cod_abi_istituto cod_abi_istituto_rg,
       o2.cod_struttura_competente cod_struttura_competente_rg,
       o2.cod_livello cod_livello_rg,
       o2.cod_str_org_sup cod_str_org_sup_rg,
       o2.desc_struttura_competente desc_struttura_competente_rg,
       NULL cod_abi_istituto_dv,
       NULL cod_struttura_competente_dv,
       NULL cod_livello_dv,
       NULL cod_str_org_sup_dv,
       NULL desc_struttura_competente_dv,
       o4.cod_abi_istituto cod_abi_istituto_dc,
       o4.cod_struttura_competente cod_struttura_competente_dc,
       o4.cod_livello cod_livello_dc,
       o4.cod_str_org_sup cod_str_org_sup_dc,
       o4.desc_struttura_competente desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o,
       -- t_mcre0_app_struttura_org o1,
       t_mcre0_app_struttura_org o2,
       t_mcre0_app_struttura_org o4
 WHERE     o.cod_abi_istituto = o2.cod_abi_istituto
       AND o.cod_str_org_sup = o2.cod_struttura_competente
       AND o2.cod_abi_istituto = o4.cod_abi_istituto
       AND o2.cod_str_org_sup = o4.cod_struttura_competente
       AND o.cod_livello = 'FI'
       --AND o1.cod_livello = 'AR'
       AND o2.cod_livello = 'RG'
       AND o4.cod_livello  in ('DC','MC')--= 'DC'
--UNION
--SELECT
--         O.COD_ABI_ISTITUTO COD_ABI_ISTITUTO_FI,
--         O.COD_STRUTTURA_COMPETENTE COD_STRUTTURA_COMPETENTE_FI,
--         O.COD_LIVELLO COD_LIVELLO_FI, O.COD_STR_ORG_SUP COD_STR_ORG_SUP_FI,
--         O.DESC_STRUTTURA_COMPETENTE DESC_STRUTTURA_COMPETENTE_FI,
--         O.COD_ABI_ISTITUTO COD_ABI_ISTITUTO_AR,
--         O.COD_STRUTTURA_COMPETENTE COD_STRUTTURA_COMPETENTE_AR,
--         O.COD_LIVELLO COD_LIVELLO_AR, O.COD_STR_ORG_SUP COD_STR_ORG_SUP_AR,
--         O.DESC_STRUTTURA_COMPETENTE DESC_STRUTTURA_COMPETENTE_AR,
--         O2.COD_ABI_ISTITUTO COD_ABI_ISTITUTO_RG,
--         O2.COD_STRUTTURA_COMPETENTE COD_STRUTTURA_COMPETENTE_RG,
--         O2.COD_LIVELLO COD_LIVELLO_RG, O2.COD_STR_ORG_SUP COD_STR_ORG_SUP_RG,
--         O2.DESC_STRUTTURA_COMPETENTE DESC_STRUTTURA_COMPETENTE_RG,
--         O3.COD_ABI_ISTITUTO COD_ABI_ISTITUTO_DV,
--         O3.COD_STRUTTURA_COMPETENTE COD_STRUTTURA_COMPETENTE_DV,
--         O3.COD_LIVELLO COD_LIVELLO_DV, O3.COD_STR_ORG_SUP COD_STR_ORG_SUP_DV,
--         O3.DESC_STRUTTURA_COMPETENTE DESC_STRUTTURA_COMPETENTE_DV,
--         O4.COD_ABI_ISTITUTO COD_ABI_ISTITUTO_DC,
--         O4.COD_STRUTTURA_COMPETENTE COD_STRUTTURA_COMPETENTE_DC,
--         O4.COD_LIVELLO COD_LIVELLO_DC, O4.COD_STR_ORG_SUP COD_STR_ORG_SUP_DC,
--         O4.DESC_STRUTTURA_COMPETENTE DESC_STRUTTURA_COMPETENTE_DC
--  FROM T_MCRE0_APP_STRUTTURA_ORG O,
--         --T_MCRE0_APP_STRUTTURA_ORG O1,
--         T_MCRE0_APP_STRUTTURA_ORG O2,
--         T_MCRE0_APP_STRUTTURA_ORG O3,
--         T_MCRE0_APP_STRUTTURA_ORG O4
-- WHERE O.COD_ABI_ISTITUTO = O2.COD_ABI_ISTITUTO
--   AND O.COD_STR_ORG_SUP = O2.COD_STRUTTURA_COMPETENTE
--   AND O2.COD_ABI_ISTITUTO = O3.COD_ABI_ISTITUTO
--   AND O2.COD_STR_ORG_SUP = O3.COD_STRUTTURA_COMPETENTE
--   AND O3.COD_ABI_ISTITUTO = O4.COD_ABI_ISTITUTO
--   AND O3.COD_STR_ORG_SUP = O4.COD_STRUTTURA_COMPETENTE
--   --AND O.COD_LIVELLO = 'FI'
--   AND O.COD_LIVELLO = 'AR'
--   AND O2.COD_LIVELLO = 'RG'
--   AND O3.COD_LIVELLO = 'DV'
--   AND O4.COD_LIVELLO = 'DC'
UNION
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       o1.cod_abi_istituto cod_abi_istituto_ar,
       o1.cod_struttura_competente cod_struttura_competente_ar,
       o1.cod_livello cod_livello_ar,
       o1.cod_str_org_sup cod_str_org_sup_ar,
       o1.desc_struttura_competente desc_struttura_competente_ar,
       NULL cod_abi_istituto_rg,
       NULL cod_struttura_competente_rg,
       NULL cod_livello_rg,
       NULL cod_str_org_sup_rg,
       NULL desc_struttura_competente_rg,
       o3.cod_abi_istituto cod_abi_istituto_dv,
       o3.cod_struttura_competente cod_struttura_competente_dv,
       o3.cod_livello cod_livello_dv,
       o3.cod_str_org_sup cod_str_org_sup_dv,
       o3.desc_struttura_competente desc_struttura_competente_dv,
       o4.cod_abi_istituto cod_abi_istituto_dc,
       o4.cod_struttura_competente cod_struttura_competente_dc,
       o4.cod_livello cod_livello_dc,
       o4.cod_str_org_sup cod_str_org_sup_dc,
       o4.desc_struttura_competente desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o,
       t_mcre0_app_struttura_org o1,
       t_mcre0_app_struttura_org o3,
       t_mcre0_app_struttura_org o4
 WHERE     o.cod_abi_istituto = o1.cod_abi_istituto
       AND o.cod_str_org_sup = o1.cod_struttura_competente
       AND o1.cod_abi_istituto = o3.cod_abi_istituto
       AND o1.cod_str_org_sup = o3.cod_struttura_competente
       AND o3.cod_abi_istituto = o4.cod_abi_istituto
       AND o3.cod_str_org_sup = o4.cod_struttura_competente
       AND o.cod_livello = 'FI'
       AND o1.cod_livello = 'AR'
       AND o3.cod_livello = 'DV'
       AND o4.cod_livello  in ('DC','MC')--= 'DC'
UNION
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       NULL cod_abi_istituto_ar,
       NULL cod_struttura_competente_ar,
       NULL cod_livello_ar,
       NULL cod_str_org_sup_ar,
       NULL desc_struttura_competente_ar,
       o1.cod_abi_istituto cod_abi_istituto_rg,
       o1.cod_struttura_competente cod_struttura_competente_rg,
       o1.cod_livello cod_livello_rg,
       o1.cod_str_org_sup cod_str_org_sup_rg,
       o1.desc_struttura_competente desc_struttura_competente_rg,
       o3.cod_abi_istituto cod_abi_istituto_dv,
       o3.cod_struttura_competente cod_struttura_competente_dv,
       o3.cod_livello cod_livello_dv,
       o3.cod_str_org_sup cod_str_org_sup_dv,
       o3.desc_struttura_competente desc_struttura_competente_dv,
       o4.cod_abi_istituto cod_abi_istituto_dc,
       o4.cod_struttura_competente cod_struttura_competente_dc,
       o4.cod_livello cod_livello_dc,
       o4.cod_str_org_sup cod_str_org_sup_dc,
       o4.desc_struttura_competente desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o,
       t_mcre0_app_struttura_org o1,
       t_mcre0_app_struttura_org o3,
       t_mcre0_app_struttura_org o4
 WHERE     o.cod_abi_istituto = o1.cod_abi_istituto
       AND o.cod_str_org_sup = o1.cod_struttura_competente
       AND o1.cod_abi_istituto = o3.cod_abi_istituto
       AND o1.cod_str_org_sup = o3.cod_struttura_competente
       AND o3.cod_abi_istituto = o4.cod_abi_istituto
       AND o3.cod_str_org_sup = o4.cod_struttura_competente
       AND o.cod_livello = 'FI'
       AND o1.cod_livello = 'RG'
       AND o3.cod_livello = 'DV'
       AND o4.cod_livello  in ('DC','MC')--= 'DC'
UNION
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       o1.cod_abi_istituto cod_abi_istituto_ar,
       o1.cod_struttura_competente cod_struttura_competente_ar,
       o1.cod_livello cod_livello_ar,
       o1.cod_str_org_sup cod_str_org_sup_ar,
       o1.desc_struttura_competente desc_struttura_competente_ar,
       NULL cod_abi_istituto_rg,
       NULL cod_struttura_competente_rg,
       NULL cod_livello_rg,
       NULL cod_str_org_sup_rg,
       NULL desc_struttura_competente_rg,
       NULL cod_abi_istituto_dv,
       NULL cod_struttura_competente_dv,
       NULL cod_livello_dv,
       NULL cod_str_org_sup_dv,
       NULL desc_struttura_competente_dv,
       o4.cod_abi_istituto cod_abi_istituto_dc,
       o4.cod_struttura_competente cod_struttura_competente_dc,
       o4.cod_livello cod_livello_dc,
       o4.cod_str_org_sup cod_str_org_sup_dc,
       o4.desc_struttura_competente desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o,
       t_mcre0_app_struttura_org o1,
       t_mcre0_app_struttura_org o4
 WHERE     o.cod_abi_istituto = o1.cod_abi_istituto
       AND o.cod_str_org_sup = o1.cod_struttura_competente
       AND o1.cod_abi_istituto = o4.cod_abi_istituto
       AND o1.cod_str_org_sup = o4.cod_struttura_competente
       AND o.cod_livello = 'FI'
       AND o1.cod_livello = 'AR'
       AND o4.cod_livello  in ('DC','MC')--= 'DC'
UNION
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       NULL cod_abi_istituto_ar,
       NULL cod_struttura_competente_ar,
       NULL cod_livello_ar,
       NULL cod_str_org_sup_ar,
       NULL desc_struttura_competente_ar,
       NULL cod_abi_istituto_rg,
       NULL cod_struttura_competente_rg,
       NULL cod_livello_rg,
       NULL cod_str_org_sup_rg,
       NULL desc_struttura_competente_rg,
       o3.cod_abi_istituto cod_abi_istituto_dv,
       o3.cod_struttura_competente cod_struttura_competente_dv,
       o3.cod_livello cod_livello_dv,
       o3.cod_str_org_sup cod_str_org_sup_dv,
       o3.desc_struttura_competente desc_struttura_competente_dv,
       o4.cod_abi_istituto cod_abi_istituto_dc,
       o4.cod_struttura_competente cod_struttura_competente_dc,
       o4.cod_livello cod_livello_dc,
       o4.cod_str_org_sup cod_str_org_sup_dc,
       o4.desc_struttura_competente desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o,
       t_mcre0_app_struttura_org o3,
       t_mcre0_app_struttura_org o4
 WHERE     o.cod_abi_istituto = o3.cod_abi_istituto
       AND o.cod_str_org_sup = o3.cod_struttura_competente
       AND o3.cod_abi_istituto = o4.cod_abi_istituto
       AND o3.cod_str_org_sup = o4.cod_struttura_competente
       AND o.cod_livello = 'FI'
       AND o3.cod_livello = 'DV'
       AND o4.cod_livello  in ('DC','MC')--= 'DC'
UNION
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       o1.cod_abi_istituto cod_abi_istituto_ar,
       o1.cod_struttura_competente cod_struttura_competente_ar,
       o1.cod_livello cod_livello_ar,
       o1.cod_str_org_sup cod_str_org_sup_ar,
       o1.desc_struttura_competente desc_struttura_competente_ar,
       NULL cod_abi_istituto_rg,
       NULL cod_struttura_competente_rg,
       NULL cod_livello_rg,
       NULL cod_str_org_sup_rg,
       NULL desc_struttura_competente_rg,
       NULL cod_abi_istituto_dv,
       NULL cod_struttura_competente_dv,
       NULL cod_livello_dv,
       NULL cod_str_org_sup_dv,
       NULL desc_struttura_competente_dv,
       NULL cod_abi_istituto_dc,
       NULL cod_struttura_competente_dc,
       NULL,
       NULL cod_str_org_sup_dc,
       NULL desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o, t_mcre0_app_struttura_org o1
 WHERE     o.cod_abi_istituto = o1.cod_abi_istituto
       AND o.cod_str_org_sup = o1.cod_struttura_competente
       AND o1.cod_str_org_sup = '99999'
       AND o.cod_livello = 'FI'
       AND o1.cod_livello = 'AR'
UNION
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       NULL cod_abi_istituto_ar,
       NULL cod_struttura_competente_ar,
       NULL cod_livello_ar,
       NULL cod_str_org_sup_ar,
       NULL desc_struttura_competente_ar,
       NULL cod_abi_istituto_rg,
       NULL cod_struttura_competente_rg,
       NULL cod_livello_rg,
       NULL cod_str_org_sup_rg,
       NULL desc_struttura_competente_rg,
       NULL cod_abi_istituto_dv,
       NULL cod_struttura_competente_dv,
       NULL cod_livello_dv,
       NULL cod_str_org_sup_dv,
       NULL desc_struttura_competente_dv,
       NULL cod_abi_istituto_dc,
       NULL cod_struttura_competente_dc,
       NULL,
       NULL cod_str_org_sup_dc,
       NULL desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o
 WHERE o.cod_livello = 'FI' AND o.cod_str_org_sup = '-1'
UNION
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       NULL cod_abi_istituto_ar,
       NULL cod_struttura_competente_ar,
       NULL cod_livello_ar,
       NULL cod_str_org_sup_ar,
       NULL desc_struttura_competente_ar,
       NULL cod_abi_istituto_rg,
       NULL cod_struttura_competente_rg,
       NULL cod_livello_rg,
       NULL cod_str_org_sup_rg,
       NULL desc_struttura_competente_rg,
       NULL cod_abi_istituto_dv,
       NULL cod_struttura_competente_dv,
       NULL cod_livello_dv,
       NULL cod_str_org_sup_dv,
       NULL desc_struttura_competente_dv,
       NULL cod_abi_istituto_dc,
       NULL cod_struttura_competente_dc,
       NULL,
       NULL cod_str_org_sup_dc,
       NULL desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o
 WHERE o.cod_livello NOT IN ('FI', 'AR', 'RG', 'DV', 'DC','MC') -----!!!!
UNION
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       o.cod_abi_istituto cod_abi_istituto_ar,
       o.cod_struttura_competente cod_struttura_competente_ar,
       o.cod_livello cod_livello_ar,
       o.cod_str_org_sup cod_str_org_sup_ar,
       o.desc_struttura_competente desc_struttura_competente_ar,
       NULL cod_abi_istituto_rg,
       NULL cod_struttura_competente_rg,
       NULL cod_livello_rg,
       NULL cod_str_org_sup_rg,
       NULL desc_struttura_competente_rg,
       NULL cod_abi_istituto_dv,
       NULL cod_struttura_competente_dv,
       NULL cod_livello_dv,
       NULL cod_str_org_sup_dv,
       NULL desc_struttura_competente_dv,
       NULL cod_abi_istituto_dc,
       NULL cod_struttura_competente_dc,
       NULL,
       NULL cod_str_org_sup_dc,
       NULL desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o
 WHERE o.cod_livello = 'AR'
UNION
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       NULL cod_abi_istituto_ar,
       NULL cod_struttura_competente_ar,
       NULL cod_livello_ar,
       NULL cod_str_org_sup_ar,
       NULL desc_struttura_competente_ar,
       NULL cod_abi_istituto_rg,
       NULL cod_struttura_competente_rg,
       NULL cod_livello_rg,
       NULL cod_str_org_sup_rg,
       NULL desc_struttura_competente_rg,
       o.cod_abi_istituto cod_abi_istituto_dv,
       o.cod_struttura_competente cod_struttura_competente_dv,
       o.cod_livello cod_livello_dv,
       o.cod_str_org_sup cod_str_org_sup_dv,
       o.desc_struttura_competente desc_struttura_competente_dv,
       NULL cod_abi_istituto_dc,
       NULL cod_struttura_competente_dc,
       NULL,
       NULL cod_str_org_sup_dc,
       NULL desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o
 WHERE o.cod_livello = 'DV'
UNION
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       NULL cod_abi_istituto_ar,
       NULL cod_struttura_competente_ar,
       NULL cod_livello_ar,
       NULL cod_str_org_sup_ar,
       NULL desc_struttura_competente_ar,
       NULL cod_abi_istituto_rg,
       NULL cod_struttura_competente_rg,
       NULL cod_livello_rg,
       NULL cod_str_org_sup_rg,
       NULL desc_struttura_competente_rg,
       NULL cod_abi_istituto_dv,
       NULL cod_struttura_competente_dv,
       NULL cod_livello_dv,
       NULL cod_str_org_sup_dv,
       NULL desc_struttura_competente_dv,
       o.cod_abi_istituto cod_abi_istituto_dc,
       o.cod_struttura_competente cod_struttura_competente_dc,
       o.cod_livello cod_livello_dc,
       o.cod_str_org_sup cod_str_org_sup_dc,
       o.desc_struttura_competente desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o
 WHERE o.cod_livello  in ('DC','MC')--= 'DC'
UNION
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       o1.cod_abi_istituto cod_abi_istituto_ar,
       o1.cod_struttura_competente cod_struttura_competente_ar,
       o1.cod_livello cod_livello_ar,
       o1.cod_str_org_sup cod_str_org_sup_ar,
       o1.desc_struttura_competente desc_struttura_competente_ar,
       o2.cod_abi_istituto cod_abi_istituto_rg,
       o2.cod_struttura_competente cod_struttura_competente_rg,
       o2.cod_livello cod_livello_rg,
       o2.cod_str_org_sup cod_str_org_sup_rg,
       o2.desc_struttura_competente desc_struttura_competente_rg,
       o3.cod_abi_istituto cod_abi_istituto_dv,
       o3.cod_struttura_competente cod_struttura_competente_dv,
       o3.cod_livello cod_livello_dv,
       o3.cod_str_org_sup cod_str_org_sup_dv,
       o3.desc_struttura_competente desc_struttura_competente_dv,
       NULL cod_abi_istituto_dc,
       NULL cod_struttura_competente_dc,
       NULL cod_livello_dc,
       NULL cod_str_org_sup_dc,
       NULL desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o,
       t_mcre0_app_struttura_org o1,
       t_mcre0_app_struttura_org o2,
       t_mcre0_app_struttura_org o3,
       t_mcre0_app_struttura_org o4
 WHERE     o.cod_abi_istituto = o1.cod_abi_istituto
       AND o.cod_str_org_sup = o1.cod_struttura_competente
       AND o1.cod_abi_istituto = o2.cod_abi_istituto
       AND o1.cod_str_org_sup = o2.cod_struttura_competente
       AND o2.cod_abi_istituto = o3.cod_abi_istituto
       AND o2.cod_str_org_sup = o3.cod_struttura_competente
       AND o3.cod_abi_istituto = o4.cod_abi_istituto
       AND o3.cod_str_org_sup = o4.cod_struttura_competente
       AND o.cod_livello = 'FI'
       AND o1.cod_livello = 'AR'
       AND o2.cod_livello = 'RG'
       AND o3.cod_livello = 'DV'
       AND o4.cod_livello = 'DV'
UNION
--8806 FI-AR-RG_DC
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       o1.cod_abi_istituto cod_abi_istituto_ar,
       o1.cod_struttura_competente cod_struttura_competente_ar,
       o1.cod_livello cod_livello_ar,
       o1.cod_str_org_sup cod_str_org_sup_ar,
       o1.desc_struttura_competente desc_struttura_competente_ar,
       o2.cod_abi_istituto cod_abi_istituto_rg,
       o2.cod_struttura_competente cod_struttura_competente_rg,
       o2.cod_livello cod_livello_rg,
       o2.cod_str_org_sup cod_str_org_sup_rg,
       o2.desc_struttura_competente desc_struttura_competente_rg,
       NULL cod_abi_istituto_dv,
       NULL cod_struttura_competente_dv,
       NULL cod_livello_dv,
       NULL cod_str_org_sup_dv,
       NULL desc_struttura_competente_dv,
       o4.cod_abi_istituto cod_abi_istituto_dc,
       o4.cod_struttura_competente cod_struttura_competente_dc,
       o4.cod_livello cod_livello_dc,
       o4.cod_str_org_sup cod_str_org_sup_dc,
       o4.desc_struttura_competente desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o,
       t_mcre0_app_struttura_org o1,
       t_mcre0_app_struttura_org o2,
       t_mcre0_app_struttura_org o4
 WHERE     o.cod_abi_istituto = o1.cod_abi_istituto
       AND o.cod_str_org_sup = o1.cod_struttura_competente
       AND o1.cod_abi_istituto = o2.cod_abi_istituto
       AND o1.cod_str_org_sup = o2.cod_struttura_competente
       AND o2.cod_abi_istituto = o4.cod_abi_istituto
       AND o2.cod_str_org_sup = o4.cod_struttura_competente
       AND o.cod_livello = 'FI'
       AND o1.cod_livello = 'AR'
       AND o2.cod_livello = 'RG'
       AND o4.cod_livello  in ('DC','MC')--= 'DC'
UNION                     --FI-DC --5 filiali direttamente sotto una direzione
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       NULL cod_abi_istituto_ar,
       NULL cod_struttura_competente_ar,
       NULL cod_livello_ar,
       NULL cod_str_org_sup_ar,
       NULL desc_struttura_competente_ar,
       NULL cod_abi_istituto_rg,
       NULL cod_struttura_competente_rg,
       NULL cod_livello_rg,
       NULL cod_str_org_sup_rg,
       NULL desc_struttura_competente_rg,
       NULL cod_abi_istituto_dv,
       NULL cod_struttura_competente_dv,
       NULL cod_livello_dv,
       NULL cod_str_org_sup_dv,
       NULL desc_struttura_competente_dv,
       o4.cod_abi_istituto cod_abi_istituto_dc,
       o4.cod_struttura_competente cod_struttura_competente_dc,
       o4.cod_livello cod_livello_dc,
       o4.cod_str_org_sup cod_str_org_sup_dc,
       o4.desc_struttura_competente desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o, t_mcre0_app_struttura_org o4
 WHERE     o.cod_abi_istituto = o4.cod_abi_istituto
       AND o.cod_str_org_sup = o4.cod_struttura_competente
       AND o.cod_livello = 'FI'
       AND o4.cod_livello in ('DC','MC') --= 'DC'
UNION                      --90 Regioni senza strutture superiori o inferiori:
SELECT o.cod_abi_istituto cod_abi_istituto_fi,
       o.cod_struttura_competente cod_struttura_competente_fi,
       o.cod_livello cod_livello_fi,
       o.cod_str_org_sup cod_str_org_sup_fi,
       o.desc_struttura_competente desc_struttura_competente_fi,
       NULL cod_abi_istituto_ar,
       NULL cod_struttura_competente_ar,
       NULL cod_livello_ar,
       NULL cod_str_org_sup_ar,
       NULL desc_struttura_competente_ar,
       o.cod_abi_istituto cod_abi_istituto_rg,
       o.cod_struttura_competente cod_struttura_competente_rg,
       o.cod_livello cod_livello_rg,
       o.cod_str_org_sup cod_str_org_sup_rg,
       o.desc_struttura_competente desc_struttura_competente_rg,
       NULL cod_abi_istituto_dv,
       NULL cod_struttura_competente_dv,
       NULL cod_livello_dv,
       NULL cod_str_org_sup_dv,
       NULL desc_struttura_competente_dv,
       NULL cod_abi_istituto_dc,
       NULL cod_struttura_competente_dc,
       NULL,
       NULL cod_str_org_sup_dc,
       NULL desc_struttura_competente_dc
  FROM t_mcre0_app_struttura_org o
 WHERE o.cod_str_org_sup = '99999' AND o.cod_livello = 'RG';

  CREATE UNIQUE INDEX "MCRE_OWN"."PK_MV_MCRE0_DSTR_ORG" ON "MCRE_OWN"."MV_MCRE0_DENORM_STR_ORG" ("COD_ABI_ISTITUTO_FI", "COD_STRUTTURA_COMPETENTE_FI") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TSI_MCRE_MW_OWN" ;

   COMMENT ON MATERIALIZED VIEW "MCRE_OWN"."MV_MCRE0_DENORM_STR_ORG"  IS 'snapshot table for snapshot MCRE_OWN.MV_MCRE0_DENORM_STR_ORG';
