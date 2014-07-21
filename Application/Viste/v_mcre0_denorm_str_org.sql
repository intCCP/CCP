/* Formatted on 21/07/2014 18:36:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_DENORM_STR_ORG
(
   COD_ABI_ISTITUTO_FI,
   COD_STRUTTURA_COMPETENTE_FI,
   COD_LIVELLO_FI,
   COD_STR_ORG_SUP_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_ABI_ISTITUTO_AR,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_LIVELLO_AR,
   COD_STR_ORG_SUP_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_ABI_ISTITUTO_RG,
   COD_STRUTTURA_COMPETENTE_RG,
   COD_LIVELLO_RG,
   COD_STR_ORG_SUP_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_ABI_ISTITUTO_DV,
   COD_STRUTTURA_COMPETENTE_DV,
   COD_LIVELLO_DV,
   COD_STR_ORG_SUP_DV,
   DESC_STRUTTURA_COMPETENTE_DV,
   COD_ABI_ISTITUTO_DC,
   COD_STRUTTURA_COMPETENTE_DC,
   COD_LIVELLO_DC,
   COD_STR_ORG_SUP_DC,
   DESC_STRUTTURA_COMPETENTE_DC
)
AS
   SELECT                                       -- V1 02/12/2010 VG: Congelata
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
          AND o4.cod_livello = 'DC'
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
          AND o4.cod_livello = 'DC'
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
          AND o4.cod_livello = 'DV';
