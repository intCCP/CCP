/* Formatted on 21/07/2014 18:40:28 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_MATRICE_ST_AM
(
   COD_STATO,
   AR_POSIZIONI,
   GL_POSIZIONI,
   ZN_POSIZIONI,
   VE_POSIZIONI,
   GR_POSIZIONI,
   RP_POSIZIONI,
   F2_POSIZIONI,
   EG_POSIZIONI,
   DR_POSIZIONI,
   IG_POSIZIONI,
   MA_POSIZIONI,
   RA_POSIZIONI,
   RF_POSIZIONI,
   RR_POSIZIONI,
   GF_POSIZIONI,
   AF_POSIZIONI,
   CC_POSIZIONI,
   I2_POSIZIONI,
   RG_POSIZIONI,
   C1_POSIZIONI,
   ID_POSIZIONI,
   CL_POSIZIONI,
   M2_POSIZIONI,
   GC_POSIZIONI,
   F1_POSIZIONI,
   R2_POSIZIONI,
   GI_POSIZIONI,
   MR_POSIZIONI,
   GP_POSIZIONI,
   DC_POSIZIONI,
   DF_POSIZIONI,
   I1_POSIZIONI,
   RZ_POSIZIONI,
   MD_POSIZIONI,
   PG_POSIZIONI,
   LD_POSIZIONI,
   VL_POSIZIONI,
   FF_POSIZIONI,
   R1_POSIZIONI,
   AI_POSIZIONI,
   MG_POSIZIONI,
   RD_POSIZIONI,
   C2_POSIZIONI,
   IR_POSIZIONI,
   MC_POSIZIONI,
   CD_POSIZIONI,
   VC_POSIZIONI,
   BF_POSIZIONI,
   M1_POSIZIONI,
   CI_POSIZIONI,
   DI_POSIZIONI,
   CP_POSIZIONI,
   CG_POSIZIONI,
   PD_POSIZIONI,
   TOT_POSIZIONI_PER_STATO,
   AR_UTILIZZO,
   GL_UTILIZZO,
   ZN_UTILIZZO,
   VE_UTILIZZO,
   GR_UTILIZZO,
   RP_UTILIZZO,
   F2_UTILIZZO,
   EG_UTILIZZO,
   DR_UTILIZZO,
   IG_UTILIZZO,
   MA_UTILIZZO,
   RA_UTILIZZO,
   RF_UTILIZZO,
   RR_UTILIZZO,
   GF_UTILIZZO,
   AF_UTILIZZO,
   CC_UTILIZZO,
   I2_UTILIZZO,
   RG_UTILIZZO,
   C1_UTILIZZO,
   ID_UTILIZZO,
   CL_UTILIZZO,
   M2_UTILIZZO,
   GC_UTILIZZO,
   F1_UTILIZZO,
   R2_UTILIZZO,
   GI_UTILIZZO,
   MR_UTILIZZO,
   GP_UTILIZZO,
   DC_UTILIZZO,
   DF_UTILIZZO,
   I1_UTILIZZO,
   RZ_UTILIZZO,
   MD_UTILIZZO,
   PG_UTILIZZO,
   LD_UTILIZZO,
   VL_UTILIZZO,
   FF_UTILIZZO,
   R1_UTILIZZO,
   AI_UTILIZZO,
   MG_UTILIZZO,
   RD_UTILIZZO,
   C2_UTILIZZO,
   IR_UTILIZZO,
   MC_UTILIZZO,
   CD_UTILIZZO,
   VC_UTILIZZO,
   BF_UTILIZZO,
   M1_UTILIZZO,
   CI_UTILIZZO,
   DI_UTILIZZO,
   CP_UTILIZZO,
   CG_UTILIZZO,
   PD_UTILIZZO,
   TOT_UTILIZZO_PER_STATO
)
AS
     SELECT NVL (TO_CHAR (cod_stato), 'TOT_PER_PROCESSO') AS cod_stato,
            --            SUM (nll_posizioni) AS nll_posizioni,    --09/01/13 non considero record con cod_processo a null
            SUM (ar_posizioni) AS ar_posizioni,
            SUM (gl_posizioni) AS gl_posizioni,
            SUM (zn_posizioni) AS zn_posizioni,
            SUM (ve_posizioni) AS ve_posizioni,
            SUM (gr_posizioni) AS gr_posizioni,
            SUM (rp_posizioni) AS rp_posizioni,
            SUM (f2_posizioni) AS f2_posizioni,
            SUM (eg_posizioni) AS eg_posizioni,
            SUM (dr_posizioni) AS dr_posizioni,
            SUM (ig_posizioni) AS ig_posizioni,
            SUM (ma_posizioni) AS ma_posizioni,
            SUM (ra_posizioni) AS ra_posizioni,
            SUM (rf_posizioni) AS rf_posizioni,
            SUM (rr_posizioni) AS rr_posizioni,
            SUM (gf_posizioni) AS gf_posizioni,
            SUM (af_posizioni) AS af_posizioni,
            SUM (cc_posizioni) AS cc_posizioni,
            SUM (i2_posizioni) AS i2_posizioni,
            SUM (rg_posizioni) AS rg_posizioni,
            SUM (c1_posizioni) AS c1_posizioni,
            SUM (id_posizioni) AS id_posizioni,
            SUM (cl_posizioni) AS cl_posizioni,
            SUM (m2_posizioni) AS m2_posizioni,
            SUM (gc_posizioni) AS gc_posizioni,
            SUM (f1_posizioni) AS f1_posizioni,
            SUM (r2_posizioni) AS r2_posizioni,
            SUM (gi_posizioni) AS gi_posizioni,
            SUM (mr_posizioni) AS mr_posizioni,
            SUM (gp_posizioni) AS gp_posizioni,
            SUM (dc_posizioni) AS dc_posizioni,
            SUM (df_posizioni) AS df_posizioni,
            SUM (i1_posizioni) AS i1_posizioni,
            SUM (rz_posizioni) AS rz_posizioni,
            SUM (md_posizioni) AS md_posizioni,
            SUM (pg_posizioni) AS pg_posizioni,
            SUM (ld_posizioni) AS ld_posizioni,
            SUM (vl_posizioni) AS vl_posizioni,
            SUM (ff_posizioni) AS ff_posizioni,
            SUM (r1_posizioni) AS r1_posizioni,
            SUM (ai_posizioni) AS ai_posizioni,
            SUM (mg_posizioni) AS mg_posizioni,
            SUM (rd_posizioni) AS rd_posizioni,
            SUM (c2_posizioni) AS c2_posizioni,
            SUM (ir_posizioni) AS ir_posizioni,
            SUM (mc_posizioni) AS mc_posizioni,
            SUM (cd_posizioni) AS cd_posizioni,
            SUM (vc_posizioni) AS vc_posizioni,
            SUM (bf_posizioni) AS bf_posizioni,
            SUM (m1_posizioni) AS m1_posizioni,
            SUM (ci_posizioni) AS ci_posizioni,
            SUM (di_posizioni) AS di_posizioni,
            SUM (cp_posizioni) AS cp_posizioni,
            SUM (cg_posizioni) AS cg_posizioni,
            SUM (pd_posizioni) AS pd_posizioni,
            SUM (tot_posizioni_per_stato) AS tot_posizioni_per_stato,
            --            SUM (nll_utilizzo) AS nll_utilizzo,    --09/01/13 non considero record con cod_processo a null
            SUM (ar_utilizzo) AS ar_utilizzo,
            SUM (gl_utilizzo) AS gl_utilizzo,
            SUM (zn_utilizzo) AS zn_utilizzo,
            SUM (ve_utilizzo) AS ve_utilizzo,
            SUM (gr_utilizzo) AS gr_utilizzo,
            SUM (rp_utilizzo) AS rp_utilizzo,
            SUM (f2_utilizzo) AS f2_utilizzo,
            SUM (eg_utilizzo) AS eg_utilizzo,
            SUM (dr_utilizzo) AS dr_utilizzo,
            SUM (ig_utilizzo) AS ig_utilizzo,
            SUM (ma_utilizzo) AS ma_utilizzo,
            SUM (ra_utilizzo) AS ra_utilizzo,
            SUM (rf_utilizzo) AS rf_utilizzo,
            SUM (rr_utilizzo) AS rr_utilizzo,
            SUM (gf_utilizzo) AS gf_utilizzo,
            SUM (af_utilizzo) AS af_utilizzo,
            SUM (cc_utilizzo) AS cc_utilizzo,
            SUM (i2_utilizzo) AS i2_utilizzo,
            SUM (rg_utilizzo) AS rg_utilizzo,
            SUM (c1_utilizzo) AS c1_utilizzo,
            SUM (id_utilizzo) AS id_utilizzo,
            SUM (cl_utilizzo) AS cl_utilizzo,
            SUM (m2_utilizzo) AS m2_utilizzo,
            SUM (gc_utilizzo) AS gc_utilizzo,
            SUM (f1_utilizzo) AS f1_utilizzo,
            SUM (r2_utilizzo) AS r2_utilizzo,
            SUM (gi_utilizzo) AS gi_utilizzo,
            SUM (mr_utilizzo) AS mr_utilizzo,
            SUM (gp_utilizzo) AS gp_utilizzo,
            SUM (dc_utilizzo) AS dc_utilizzo,
            SUM (df_utilizzo) AS df_utilizzo,
            SUM (i1_utilizzo) AS i1_utilizzo,
            SUM (rz_utilizzo) AS rz_utilizzo,
            SUM (md_utilizzo) AS md_utilizzo,
            SUM (pg_utilizzo) AS pg_utilizzo,
            SUM (ld_utilizzo) AS ld_utilizzo,
            SUM (vl_utilizzo) AS vl_utilizzo,
            SUM (ff_utilizzo) AS ff_utilizzo,
            SUM (r1_utilizzo) AS r1_utilizzo,
            SUM (ai_utilizzo) AS ai_utilizzo,
            SUM (mg_utilizzo) AS mg_utilizzo,
            SUM (rd_utilizzo) AS rd_utilizzo,
            SUM (c2_utilizzo) AS c2_utilizzo,
            SUM (ir_utilizzo) AS ir_utilizzo,
            SUM (mc_utilizzo) AS mc_utilizzo,
            SUM (cd_utilizzo) AS cd_utilizzo,
            SUM (vc_utilizzo) AS vc_utilizzo,
            SUM (bf_utilizzo) AS bf_utilizzo,
            SUM (m1_utilizzo) AS m1_utilizzo,
            SUM (ci_utilizzo) AS ci_utilizzo,
            SUM (di_utilizzo) AS di_utilizzo,
            SUM (cp_utilizzo) AS cp_utilizzo,
            SUM (cg_utilizzo) AS cg_utilizzo,
            SUM (pd_utilizzo) AS pd_utilizzo,
            SUM (tot_utilizzo_per_stato) AS tot_utilizzo_per_stato
       FROM (  SELECT cod_stato,
                      --                      SUM (nll_posizioni) AS nll_posizioni,  --09/01/13 non considero record con cod_processo a null
                      SUM (ar_posizioni) AS ar_posizioni,
                      SUM (gl_posizioni) AS gl_posizioni,
                      SUM (zn_posizioni) AS zn_posizioni,
                      SUM (ve_posizioni) AS ve_posizioni,
                      SUM (gr_posizioni) AS gr_posizioni,
                      SUM (rp_posizioni) AS rp_posizioni,
                      SUM (f2_posizioni) AS f2_posizioni,
                      SUM (eg_posizioni) AS eg_posizioni,
                      SUM (dr_posizioni) AS dr_posizioni,
                      SUM (ig_posizioni) AS ig_posizioni,
                      SUM (ma_posizioni) AS ma_posizioni,
                      SUM (ra_posizioni) AS ra_posizioni,
                      SUM (rf_posizioni) AS rf_posizioni,
                      SUM (rr_posizioni) AS rr_posizioni,
                      SUM (gf_posizioni) AS gf_posizioni,
                      SUM (af_posizioni) AS af_posizioni,
                      SUM (cc_posizioni) AS cc_posizioni,
                      SUM (i2_posizioni) AS i2_posizioni,
                      SUM (rg_posizioni) AS rg_posizioni,
                      SUM (c1_posizioni) AS c1_posizioni,
                      SUM (id_posizioni) AS id_posizioni,
                      SUM (cl_posizioni) AS cl_posizioni,
                      SUM (m2_posizioni) AS m2_posizioni,
                      SUM (gc_posizioni) AS gc_posizioni,
                      SUM (f1_posizioni) AS f1_posizioni,
                      SUM (r2_posizioni) AS r2_posizioni,
                      SUM (gi_posizioni) AS gi_posizioni,
                      SUM (mr_posizioni) AS mr_posizioni,
                      SUM (gp_posizioni) AS gp_posizioni,
                      SUM (dc_posizioni) AS dc_posizioni,
                      SUM (df_posizioni) AS df_posizioni,
                      SUM (i1_posizioni) AS i1_posizioni,
                      SUM (rz_posizioni) AS rz_posizioni,
                      SUM (md_posizioni) AS md_posizioni,
                      SUM (pg_posizioni) AS pg_posizioni,
                      SUM (ld_posizioni) AS ld_posizioni,
                      SUM (vl_posizioni) AS vl_posizioni,
                      SUM (ff_posizioni) AS ff_posizioni,
                      SUM (r1_posizioni) AS r1_posizioni,
                      SUM (ai_posizioni) AS ai_posizioni,
                      SUM (mg_posizioni) AS mg_posizioni,
                      SUM (rd_posizioni) AS rd_posizioni,
                      SUM (c2_posizioni) AS c2_posizioni,
                      SUM (ir_posizioni) AS ir_posizioni,
                      SUM (mc_posizioni) AS mc_posizioni,
                      SUM (cd_posizioni) AS cd_posizioni,
                      SUM (vc_posizioni) AS vc_posizioni,
                      SUM (bf_posizioni) AS bf_posizioni,
                      SUM (m1_posizioni) AS m1_posizioni,
                      SUM (ci_posizioni) AS ci_posizioni,
                      SUM (di_posizioni) AS di_posizioni,
                      SUM (cp_posizioni) AS cp_posizioni,
                      SUM (cg_posizioni) AS cg_posizioni,
                      SUM (pd_posizioni) AS pd_posizioni,
                      SUM (tot_posizioni_per_stato) AS tot_posizioni_per_stato,
                      --                      SUM (nll_utilizzo) AS nll_utilizzo,   --09/01/13 non considero record con cod_processo a null
                      SUM (ar_utilizzo) AS ar_utilizzo,
                      SUM (gl_utilizzo) AS gl_utilizzo,
                      SUM (zn_utilizzo) AS zn_utilizzo,
                      SUM (ve_utilizzo) AS ve_utilizzo,
                      SUM (gr_utilizzo) AS gr_utilizzo,
                      SUM (rp_utilizzo) AS rp_utilizzo,
                      SUM (f2_utilizzo) AS f2_utilizzo,
                      SUM (eg_utilizzo) AS eg_utilizzo,
                      SUM (dr_utilizzo) AS dr_utilizzo,
                      SUM (ig_utilizzo) AS ig_utilizzo,
                      SUM (ma_utilizzo) AS ma_utilizzo,
                      SUM (ra_utilizzo) AS ra_utilizzo,
                      SUM (rf_utilizzo) AS rf_utilizzo,
                      SUM (rr_utilizzo) AS rr_utilizzo,
                      SUM (gf_utilizzo) AS gf_utilizzo,
                      SUM (af_utilizzo) AS af_utilizzo,
                      SUM (cc_utilizzo) AS cc_utilizzo,
                      SUM (i2_utilizzo) AS i2_utilizzo,
                      SUM (rg_utilizzo) AS rg_utilizzo,
                      SUM (c1_utilizzo) AS c1_utilizzo,
                      SUM (id_utilizzo) AS id_utilizzo,
                      SUM (cl_utilizzo) AS cl_utilizzo,
                      SUM (m2_utilizzo) AS m2_utilizzo,
                      SUM (gc_utilizzo) AS gc_utilizzo,
                      SUM (f1_utilizzo) AS f1_utilizzo,
                      SUM (r2_utilizzo) AS r2_utilizzo,
                      SUM (gi_utilizzo) AS gi_utilizzo,
                      SUM (mr_utilizzo) AS mr_utilizzo,
                      SUM (gp_utilizzo) AS gp_utilizzo,
                      SUM (dc_utilizzo) AS dc_utilizzo,
                      SUM (df_utilizzo) AS df_utilizzo,
                      SUM (i1_utilizzo) AS i1_utilizzo,
                      SUM (rz_utilizzo) AS rz_utilizzo,
                      SUM (md_utilizzo) AS md_utilizzo,
                      SUM (pg_utilizzo) AS pg_utilizzo,
                      SUM (ld_utilizzo) AS ld_utilizzo,
                      SUM (vl_utilizzo) AS vl_utilizzo,
                      SUM (ff_utilizzo) AS ff_utilizzo,
                      SUM (r1_utilizzo) AS r1_utilizzo,
                      SUM (ai_utilizzo) AS ai_utilizzo,
                      SUM (mg_utilizzo) AS mg_utilizzo,
                      SUM (rd_utilizzo) AS rd_utilizzo,
                      SUM (c2_utilizzo) AS c2_utilizzo,
                      SUM (ir_utilizzo) AS ir_utilizzo,
                      SUM (mc_utilizzo) AS mc_utilizzo,
                      SUM (cd_utilizzo) AS cd_utilizzo,
                      SUM (vc_utilizzo) AS vc_utilizzo,
                      SUM (bf_utilizzo) AS bf_utilizzo,
                      SUM (m1_utilizzo) AS m1_utilizzo,
                      SUM (ci_utilizzo) AS ci_utilizzo,
                      SUM (di_utilizzo) AS di_utilizzo,
                      SUM (cp_utilizzo) AS cp_utilizzo,
                      SUM (cg_utilizzo) AS cg_utilizzo,
                      SUM (pd_utilizzo) AS pd_utilizzo,
                      SUM (tot_utilizzo_per_stato) AS tot_utilizzo_per_stato
                 FROM (SELECT cod_stato,
                              --                              DECODE (cod_processo, -- 09/01/13 non considero record con cod_processo a null
                              --                                      NULL, 1,
                              --                                      0
                              --                                     ) AS nll_posizioni,
                              DECODE (cod_processo, 'AF', 1, 0) AS af_posizioni,
                              DECODE (cod_processo, 'AI', 1, 0) AS ai_posizioni,
                              DECODE (cod_processo, 'AR', 1, 0) AS ar_posizioni,
                              DECODE (cod_processo, 'BF', 1, 0) AS bf_posizioni,
                              DECODE (cod_processo, 'C1', 1, 0) AS c1_posizioni,
                              DECODE (cod_processo, 'C2', 1, 0) AS c2_posizioni,
                              DECODE (cod_processo, 'CC', 1, 0) AS cc_posizioni,
                              DECODE (cod_processo, 'CD', 1, 0) AS cd_posizioni,
                              DECODE (cod_processo, 'CG', 1, 0) AS cg_posizioni,
                              DECODE (cod_processo, 'CI', 1, 0) AS ci_posizioni,
                              DECODE (cod_processo, 'CL', 1, 0) AS cl_posizioni,
                              DECODE (cod_processo, 'CP', 1, 0) AS cp_posizioni,
                              DECODE (cod_processo, 'DC', 1, 0) AS dc_posizioni,
                              DECODE (cod_processo, 'DF', 1, 0) AS df_posizioni,
                              DECODE (cod_processo, 'DI', 1, 0) AS di_posizioni,
                              DECODE (cod_processo, 'DR', 1, 0) AS dr_posizioni,
                              DECODE (cod_processo, 'EG', 1, 0) AS eg_posizioni,
                              DECODE (cod_processo, 'F1', 1, 0) AS f1_posizioni,
                              DECODE (cod_processo, 'F2', 1, 0) AS f2_posizioni,
                              DECODE (cod_processo, 'FF', 1, 0) AS ff_posizioni,
                              DECODE (cod_processo, 'GC', 1, 0) AS gc_posizioni,
                              DECODE (cod_processo, 'GF', 1, 0) AS gf_posizioni,
                              DECODE (cod_processo, 'GI', 1, 0) AS gi_posizioni,
                              DECODE (cod_processo, 'GL', 1, 0) AS gl_posizioni,
                              DECODE (cod_processo, 'GP', 1, 0) AS gp_posizioni,
                              DECODE (cod_processo, 'GR', 1, 0) AS gr_posizioni,
                              DECODE (cod_processo, 'I1', 1, 0) AS i1_posizioni,
                              DECODE (cod_processo, 'I2', 1, 0) AS i2_posizioni,
                              DECODE (cod_processo, 'ID', 1, 0) AS id_posizioni,
                              DECODE (cod_processo, 'IG', 1, 0) AS ig_posizioni,
                              DECODE (cod_processo, 'IR', 1, 0) AS ir_posizioni,
                              DECODE (cod_processo, 'LD', 1, 0) AS ld_posizioni,
                              DECODE (cod_processo, 'M1', 1, 0) AS m1_posizioni,
                              DECODE (cod_processo, 'M2', 1, 0) AS m2_posizioni,
                              DECODE (cod_processo, 'MA', 1, 0) AS ma_posizioni,
                              DECODE (cod_processo, 'MC', 1, 0) AS mc_posizioni,
                              DECODE (cod_processo, 'MD', 1, 0) AS md_posizioni,
                              DECODE (cod_processo, 'MG', 1, 0) AS mg_posizioni,
                              DECODE (cod_processo, 'MR', 1, 0) AS mr_posizioni,
                              DECODE (cod_processo, 'PD', 1, 0) AS pd_posizioni,
                              DECODE (cod_processo, 'PG', 1, 0) AS pg_posizioni,
                              DECODE (cod_processo, 'R1', 1, 0) AS r1_posizioni,
                              DECODE (cod_processo, 'R2', 1, 0) AS r2_posizioni,
                              DECODE (cod_processo, 'RA', 1, 0) AS ra_posizioni,
                              DECODE (cod_processo, 'RD', 1, 0) AS rd_posizioni,
                              DECODE (cod_processo, 'RF', 1, 0) AS rf_posizioni,
                              DECODE (cod_processo, 'RG', 1, 0) AS rg_posizioni,
                              DECODE (cod_processo, 'RP', 1, 0) AS rp_posizioni,
                              DECODE (cod_processo, 'RR', 1, 0) AS rr_posizioni,
                              DECODE (cod_processo, 'RZ', 1, 0) AS rz_posizioni,
                              DECODE (cod_processo, 'VC', 1, 0) AS vc_posizioni,
                              DECODE (cod_processo, 'VE', 1, 0) AS ve_posizioni,
                              DECODE (cod_processo, 'VL', 1, 0) AS vl_posizioni,
                              DECODE (cod_processo, 'ZN', 1, 0) AS zn_posizioni,
                              1 AS tot_posizioni_per_stato,
                              --                              DECODE (cod_processo,      --09/01/13 non considero record con cod_processo a null
                              --                                      NULL, NVL (utilizzo, 0),
                              --                                      0
                              --                                     ) AS nll_utilizzo,
                              DECODE (cod_processo, 'AF', NVL (utilizzo, 0), 0)
                                 AS af_utilizzo,
                              DECODE (cod_processo, 'AI', NVL (utilizzo, 0), 0)
                                 AS ai_utilizzo,
                              DECODE (cod_processo, 'AR', NVL (utilizzo, 0), 0)
                                 AS ar_utilizzo,
                              DECODE (cod_processo, 'BF', NVL (utilizzo, 0), 0)
                                 AS bf_utilizzo,
                              DECODE (cod_processo, 'C1', NVL (utilizzo, 0), 0)
                                 AS c1_utilizzo,
                              DECODE (cod_processo, 'C2', NVL (utilizzo, 0), 0)
                                 AS c2_utilizzo,
                              DECODE (cod_processo, 'CC', NVL (utilizzo, 0), 0)
                                 AS cc_utilizzo,
                              DECODE (cod_processo, 'CD', NVL (utilizzo, 0), 0)
                                 AS cd_utilizzo,
                              DECODE (cod_processo, 'CG', NVL (utilizzo, 0), 0)
                                 AS cg_utilizzo,
                              DECODE (cod_processo, 'CI', NVL (utilizzo, 0), 0)
                                 AS ci_utilizzo,
                              DECODE (cod_processo, 'CL', NVL (utilizzo, 0), 0)
                                 AS cl_utilizzo,
                              DECODE (cod_processo, 'CP', NVL (utilizzo, 0), 0)
                                 AS cp_utilizzo,
                              DECODE (cod_processo, 'DC', NVL (utilizzo, 0), 0)
                                 AS dc_utilizzo,
                              DECODE (cod_processo, 'DF', NVL (utilizzo, 0), 0)
                                 AS df_utilizzo,
                              DECODE (cod_processo, 'DI', NVL (utilizzo, 0), 0)
                                 AS di_utilizzo,
                              DECODE (cod_processo, 'DR', NVL (utilizzo, 0), 0)
                                 AS dr_utilizzo,
                              DECODE (cod_processo, 'EG', NVL (utilizzo, 0), 0)
                                 AS eg_utilizzo,
                              DECODE (cod_processo, 'F1', NVL (utilizzo, 0), 0)
                                 AS f1_utilizzo,
                              DECODE (cod_processo, 'F2', NVL (utilizzo, 0), 0)
                                 AS f2_utilizzo,
                              DECODE (cod_processo, 'FF', NVL (utilizzo, 0), 0)
                                 AS ff_utilizzo,
                              DECODE (cod_processo, 'GC', NVL (utilizzo, 0), 0)
                                 AS gc_utilizzo,
                              DECODE (cod_processo, 'GF', NVL (utilizzo, 0), 0)
                                 AS gf_utilizzo,
                              DECODE (cod_processo, 'GI', NVL (utilizzo, 0), 0)
                                 AS gi_utilizzo,
                              DECODE (cod_processo, 'GL', NVL (utilizzo, 0), 0)
                                 AS gl_utilizzo,
                              DECODE (cod_processo, 'GP', NVL (utilizzo, 0), 0)
                                 AS gp_utilizzo,
                              DECODE (cod_processo, 'GR', NVL (utilizzo, 0), 0)
                                 AS gr_utilizzo,
                              DECODE (cod_processo, 'I1', NVL (utilizzo, 0), 0)
                                 AS i1_utilizzo,
                              DECODE (cod_processo, 'I2', NVL (utilizzo, 0), 0)
                                 AS i2_utilizzo,
                              DECODE (cod_processo, 'ID', NVL (utilizzo, 0), 0)
                                 AS id_utilizzo,
                              DECODE (cod_processo, 'IG', NVL (utilizzo, 0), 0)
                                 AS ig_utilizzo,
                              DECODE (cod_processo, 'IR', NVL (utilizzo, 0), 0)
                                 AS ir_utilizzo,
                              DECODE (cod_processo, 'LD', NVL (utilizzo, 0), 0)
                                 AS ld_utilizzo,
                              DECODE (cod_processo, 'M1', NVL (utilizzo, 0), 0)
                                 AS m1_utilizzo,
                              DECODE (cod_processo, 'M2', NVL (utilizzo, 0), 0)
                                 AS m2_utilizzo,
                              DECODE (cod_processo, 'MA', NVL (utilizzo, 0), 0)
                                 AS ma_utilizzo,
                              DECODE (cod_processo, 'MC', NVL (utilizzo, 0), 0)
                                 AS mc_utilizzo,
                              DECODE (cod_processo, 'MD', NVL (utilizzo, 0), 0)
                                 AS md_utilizzo,
                              DECODE (cod_processo, 'MG', NVL (utilizzo, 0), 0)
                                 AS mg_utilizzo,
                              DECODE (cod_processo, 'MR', NVL (utilizzo, 0), 0)
                                 AS mr_utilizzo,
                              DECODE (cod_processo, 'PD', NVL (utilizzo, 0), 0)
                                 AS pd_utilizzo,
                              DECODE (cod_processo, 'PG', NVL (utilizzo, 0), 0)
                                 AS pg_utilizzo,
                              DECODE (cod_processo, 'R1', NVL (utilizzo, 0), 0)
                                 AS r1_utilizzo,
                              DECODE (cod_processo, 'R2', NVL (utilizzo, 0), 0)
                                 AS r2_utilizzo,
                              DECODE (cod_processo, 'RA', NVL (utilizzo, 0), 0)
                                 AS ra_utilizzo,
                              DECODE (cod_processo, 'RD', NVL (utilizzo, 0), 0)
                                 AS rd_utilizzo,
                              DECODE (cod_processo, 'RF', NVL (utilizzo, 0), 0)
                                 AS rf_utilizzo,
                              DECODE (cod_processo, 'RG', NVL (utilizzo, 0), 0)
                                 AS rg_utilizzo,
                              DECODE (cod_processo, 'RP', NVL (utilizzo, 0), 0)
                                 AS rp_utilizzo,
                              DECODE (cod_processo, 'RR', NVL (utilizzo, 0), 0)
                                 AS rr_utilizzo,
                              DECODE (cod_processo, 'RZ', NVL (utilizzo, 0), 0)
                                 AS rz_utilizzo,
                              DECODE (cod_processo, 'VC', NVL (utilizzo, 0), 0)
                                 AS vc_utilizzo,
                              DECODE (cod_processo, 'VE', NVL (utilizzo, 0), 0)
                                 AS ve_utilizzo,
                              DECODE (cod_processo, 'VL', NVL (utilizzo, 0), 0)
                                 AS vl_utilizzo,
                              DECODE (cod_processo, 'ZN', NVL (utilizzo, 0), 0)
                                 AS zn_utilizzo,
                              NVL (utilizzo, 0) AS tot_utilizzo_per_stato
                         FROM (SELECT ad.cod_stato,
                                      ad.cod_processo,
                                      rag.scsb_uti_tot AS utilizzo
                                 FROM v_mcre0_app_upd_fields ad,
                                      t_mcrei_app_pcr_rapp_aggr rag,
                                      t_mcre0_app_struttura_org sorg,
                                      mv_mcre0_denorm_str_org morg,
                                      t_mcre0_cl_processi pr
                                WHERE     ad.cod_abi_cartolarizzato =
                                             rag.cod_abi_cartolarizzato(+)
                                      AND ad.cod_ndg = rag.cod_ndg(+)
                                      AND ad.cod_abi_istituto =
                                             sorg.cod_abi_istituto
                                      AND ad.cod_abi_cartolarizzato =
                                             morg.cod_abi_istituto_fi
                                      AND ad.cod_struttura_competente_fi =
                                             morg.cod_struttura_competente_fi
                                      AND ad.cod_stato IS NOT NULL
                                      AND ad.cod_processo IS NOT NULL
                                      AND ad.cod_processo = pr.cod_processo
                                      AND ad.cod_abi_cartolarizzato = pr.cod_abi
                                      AND NVL (ad.cod_comparto_assegnato,
                                               ad.cod_comparto_calcolato) =
                                             sorg.cod_comparto
                                      AND ad.cod_abi_istituto =
                                             SUBSTR (
                                                (SYS_CONTEXT ('userenv',
                                                              'client_info')),
                                                1,
                                                5)
                                      --Filtro COD_TIPO_FILIALE --COD_DIV sulla struttura_org
                                      AND CASE SUBSTR (
                                                  (SYS_CONTEXT ('userenv',
                                                                'client_info')),
                                                  7,
                                                  5)
                                             WHEN 'xxxxx'
                                             THEN
                                                'xxxxx'
                                             ELSE
                                                sorg.cod_div
                                          END =
                                             CASE SUBSTR (
                                                     (SYS_CONTEXT ('userenv',
                                                                   'client_info')),
                                                     7,
                                                     5)
                                                WHEN 'xxxxx'
                                                THEN
                                                   'xxxxx'
                                                ELSE
                                                   SUBSTR (
                                                      (SYS_CONTEXT (
                                                          'userenv',
                                                          'client_info')),
                                                      7,
                                                      5)
                                             END
                                      -- COD_TIPO_DIVISIONE da inserire
                                      AND pr.tip_div =
                                             SUBSTR (
                                                (SYS_CONTEXT ('userenv',
                                                              'client_info')),
                                                13,
                                                1)
                                      --Filtro per AREA
                                      AND CASE SUBSTR (
                                                  (SYS_CONTEXT ('userenv',
                                                                'client_info')),
                                                  15,
                                                  5)
                                             WHEN 'xxxxx'
                                             THEN
                                                'xxxxx'
                                             ELSE
                                                morg.cod_struttura_competente_ar
                                          END =
                                             CASE SUBSTR (
                                                     (SYS_CONTEXT ('userenv',
                                                                   'client_info')),
                                                     15,
                                                     5)
                                                WHEN 'xxxxx'
                                                THEN
                                                   'xxxxx'
                                                ELSE
                                                   SUBSTR (
                                                      (SYS_CONTEXT (
                                                          'userenv',
                                                          'client_info')),
                                                      15,
                                                      5)
                                             END
                                      --Filtro per FILIALE
                                      AND CASE SUBSTR (
                                                  (SYS_CONTEXT ('userenv',
                                                                'client_info')),
                                                  21,
                                                  5)
                                             WHEN 'xxxxx'
                                             THEN
                                                'xxxxx'
                                             ELSE
                                                morg.cod_struttura_competente_fi
                                          END =
                                             CASE SUBSTR (
                                                     (SYS_CONTEXT ('userenv',
                                                                   'client_info')),
                                                     21,
                                                     5)
                                                WHEN 'xxxxx'
                                                THEN
                                                   'xxxxx'
                                                ELSE
                                                   SUBSTR (
                                                      (SYS_CONTEXT (
                                                          'userenv',
                                                          'client_info')),
                                                      21,
                                                      5)
                                             END
                                      --Filtro per GESTORE
                                      AND CASE SUBSTR (
                                                  (SYS_CONTEXT ('userenv',
                                                                'client_info')),
                                                  27,
                                                  7)
                                             WHEN 'xxxxxxx'
                                             THEN
                                                'xxxxxxx'
                                             ELSE
                                                ad.cod_matricola
                                          END =
                                             CASE SUBSTR (
                                                     (SYS_CONTEXT ('userenv',
                                                                   'client_info')),
                                                     27,
                                                     7)
                                                WHEN 'xxxxxxx'
                                                THEN
                                                   'xxxxxxx'
                                                ELSE
                                                   SUBSTR (
                                                      (SYS_CONTEXT (
                                                          'userenv',
                                                          'client_info')),
                                                      27,
                                                      7)
                                             END))
             GROUP BY cod_stato
             ORDER BY cod_stato)
   GROUP BY ROLLUP (cod_stato);
