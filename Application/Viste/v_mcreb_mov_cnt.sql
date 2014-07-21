/* Formatted on 21/07/2014 18:38:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREB_MOV_CNT
(
   COD_STATO_RISCHIO,
   COD_ANNOMESE,
   COD_ABI,
   COD_NDG,
   VAL_MOV_AUM_A,
   VAL_MOV_DIM_A,
   VAL_MOV_INC_A,
   VAL_MOV_AUM_M,
   VAL_MOV_DIM_M,
   VAL_MOV_INC_M,
   VAL_MOV_AUM_T,
   VAL_MOV_DIM_T,
   VAL_MOV_INC_T
)
AS
     SELECT 'R' cod_stato_rischio,
            MIN (COD_ANNOMESE) COD_ANNOMESE,
            cod_abi,
            cod_ndg,
            SUM (CASE WHEN cod_flt_tmp = 'A' THEN val_var_aumento ELSE 0 END)
               VAL_MOV_AUM_A,
            SUM (
               CASE WHEN cod_flt_tmp = 'A' THEN val_var_diminuzione ELSE 0 END)
               VAL_MOV_DIM_A,
            SUM (CASE WHEN cod_flt_tmp = 'A' THEN val_incassi ELSE 0 END)
               VAL_MOV_INC_A,
            SUM (CASE WHEN cod_flt_tmp = 'M' THEN val_var_aumento ELSE 0 END)
               VAL_MOV_AUM_M,
            SUM (
               CASE WHEN cod_flt_tmp = 'M' THEN val_var_diminuzione ELSE 0 END)
               VAL_MOV_DIM_M,
            SUM (CASE WHEN cod_flt_tmp = 'M' THEN val_incassi ELSE 0 END)
               VAL_MOV_INC_M,
            SUM (CASE WHEN cod_flt_tmp = 'T' THEN val_var_aumento ELSE 0 END)
               VAL_MOV_AUM_T,
            SUM (
               CASE WHEN cod_flt_tmp = 'T' THEN val_var_diminuzione ELSE 0 END)
               VAL_MOV_DIM_T,
            SUM (CASE WHEN cod_flt_tmp = 'T' THEN val_incassi ELSE 0 END)
               VAL_MOV_INC_T
       FROM (  SELECT COD_ANNOMESE,
                      COD_FLT_TMP,
                      cod_abi,
                      cod_ndg,
                      COUNT (DISTINCT ee.id_dper) real_months,
                      MIN (m) total_month,
                      MIN (ee.id_dper) min_month,
                      MAX (ee.id_dper) max_month,
                      MIN (f.ID_DPER) ID_DPER,
                      MAX (f.ID_DPER_pre) ID_DPER_pre,
                      SUM (
                         CASE
                            WHEN desc_modulo IN
                                    ('ALL.1 - NUOVE SOFFERENZE DA INCAGLIO',
                                     'ALL.2 - NUOVE SOFFERENZE DA BONIS',
                                     'ALL.3 - ADDEBITI SU SOFFERENZE')
                            THEN
                               val_cr_tot
                            ELSE
                               0
                         END)
                         val_var_aumento,
                      SUM (
                         CASE
                            WHEN desc_modulo IN
                                    ('ALL.5 - SOFFERENZE TRASFERITE A BONIS',
                                     'ALL.6 - SOFFERENZE ESTINTE',
                                     'ALL.7 - SOFFERENZE RIDOTTE',
                                     'ALL.8 - STRALCI SU SOFFERENZE')
                            THEN
                               val_cr_tot
                            ELSE
                               0
                         END)
                         val_var_diminuzione,
                      SUM (
                         CASE
                            WHEN desc_modulo IN
                                    ('ALL.6 - SOFFERENZE ESTINTE',
                                     'ALL.7 - SOFFERENZE RIDOTTE')
                            THEN
                               val_cr_tot
                            ELSE
                               0
                         END)
                         val_incassi
                 FROM t_mcres_app_movimenti_mod_mov ee,
                      (SELECT F.ID_DPER COD_ANNOMESE,
                              COD_FLT_TMP,
                              ID_DPER_pre a,
                              ID_DPER b,
                              MONTHS_BETWEEN (TO_DATE (ID_DPER, 'yyyymm'),
                                              TO_DATE (ID_DPER_pre, 'yyyymm'))
                                 m,
                              TO_CHAR (
                                 LAST_DAY (
                                    ADD_MONTHS (TO_DATE (ID_DPER_pre, 'yyyymm'),
                                                1)),
                                 'yyyymmdd')
                                 ID_DPER_pre,
                              TO_CHAR (LAST_DAY (TO_DATE (ID_DPER, 'yyyymm')),
                                       'yyyymmdd')
                                 ID_DPER
                         FROM T_MCREB_DIM_MIS_FLT_PRD f
                        WHERE                            --COD_FLT_TMP='A' and
                             ORD_FLT_TMP = 1            --and F.ID_DPER=201112
                                            ) f
                WHERE ee.id_dper(+) BETWEEN f.ID_DPER_pre AND f.ID_DPER
             GROUP BY cod_abi,
                      cod_ndg,
                      COD_ANNOMESE,
                      COD_FLT_TMP)
   GROUP BY COD_ANNOMESE, cod_abi, cod_ndg;
