/* Formatted on 17/06/2014 18:11:28 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SP_LEGALI_ALB_CNV
(
   ID_LEGALE,
   DTA_INIZIO_ALBO,
   DTA_INIZIO_CONVENZ,
   DTA_FINE_ALBO,
   DTA_FINE_CONVENZ,
   VAL_NOTE_ALBO_CONV,
   PROG_MOV
)
AS
   SELECT cod_id_legale AS id_legale,
          dta_inizio_albo,
          dta_inizio_convenz,
          dta_fine_albo,
          dta_fine_convenz,
          val_note_albo_conv,
          0 prog_mov
     FROM t_mcres_app_legali_esterni a
    WHERE    dta_fine_albo IS NOT NULL
          OR dta_inizio_albo IS NOT NULL
          OR dta_fine_convenz IS NOT NULL
          OR dta_inizio_convenz IS NOT NULL
   UNION ALL
   SELECT ID_LEGALE,
          DTA_INIZIO_ALBO,
          DTA_INIZIO_CONVENZ,
          DTA_FINE_ALBO,
          DTA_FINE_CONVENZ,
          VAL_NOTE_ALBO_CONV,
          prog_mov
     FROM T_MCRES_APP_LEGALI_ALB_CNV_MOV b
   ORDER BY id_legale, prog_mov;


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_SP_LEGALI_ALB_CNV TO MCRE_USR;
