/* Formatted on 21/07/2014 18:30:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_RA
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_ABI,
   COD_NDG,
   FLG_NDG,
   VAL_RIP_MORA,
   VAL_PER_CE,
   VAL_QUOTA_SVAL,
   VAL_QUOTA_ATT,
   VAL_RETT_SVAL,
   VAL_RIP_SVAL,
   VAL_RETT_ATT,
   VAL_RIP_ATT,
   VAL_ATTUALIZZAZIONE
)
AS
     SELECT 'RA' COD_SRC,
            ID_DPER,
            DTA_COMPETENZA,
            COD_STATO_RISCHIO,
            des_stato_rischio,
            COD_ABI,
            COD_NDG,
            1 flg_ndg,
            SUM (VAL_RIP_MORA) VAL_RIP_MORA,
            SUM (VAL_PER_CE) VAL_PER_CE,
            SUM (VAL_QUOTA_SVAL) VAL_QUOTA_SVAL,
            SUM (VAL_QUOTA_ATT) VAL_QUOTA_ATT,
            SUM (VAL_RETT_SVAL) VAL_RETT_SVAL,
            SUM (VAL_RIP_SVAL) VAL_RIP_SVAL,
            SUM (VAL_RETT_ATT) VAL_RETT_ATT,
            SUM (VAL_RIP_ATT) VAL_RIP_ATT,
            SUM (VAL_ATTUALIZZAZIONE) VAL_ATTUALIZZAZIONE
       FROM mcre_own.QZT_FT_MIS_MON_INC_SOF x
      WHERE     cod_src = 'RM'
            AND x.id_dper BETWEEN SUBSTR (ID_DPER, 1, 4) || '01' AND id_dper
   GROUP BY ID_DPER,
            DTA_COMPETENZA,
            COD_STATO_RISCHIO,
            des_stato_rischio,
            COD_ABI,
            COD_NDG;
