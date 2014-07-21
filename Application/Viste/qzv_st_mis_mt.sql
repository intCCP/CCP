/* Formatted on 21/07/2014 18:30:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_MT
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_ABI,
   COD_NDG,
   FLG_NDG,
   VAL_MOV_CNT,
   DES_MOV_CNT
)
AS
     SELECT 'MT' COD_SRC,
            f.ID_DPER,
            TO_CHAR (LAST_DAY (TO_DATE (id_dper_Pre, 'yyyymm')), 'yyyymmdd')
               DTA_COMPETENZA,
            COD_STATO_RISCHIO,
            des_stato_rischio,
            COD_ABI,
            COD_NDG,
            1 flg_ndg,
            SUM (VAL_MOV_CNT) VAL_MOV_CNT,
            DES_MOV_CNT
       FROM mcre_own.QZT_FT_MIS_MON_INC_SOF x,
            (SELECT F.ID_DPER COD_ANNOMESE,
                    TO_CHAR (LAST_DAY (TO_DATE (f.ID_DPER, 'yyyymm')),
                             'yyyymmdd')
                       COD_ANNOMESEGIORNO,
                    COD_FLT_TMP,
                    ID_DPER_pre,
                    ID_DPER --a,ID_DPER b,months_between(to_date(ID_DPER,'yyyymm'),to_date(ID_DPER_pre,'yyyymm')) m,
               --to_CHAR(last_day(add_months(to_date(ID_DPER_pre,'yyyymm'),1)),'yyyymmdd') ID_DPER_pre, to_CHAR(last_day(to_date(ID_DPER,'yyyymm')),'yyyymmdd') ID_DPER
               FROM mcre_own.QZT_FL_MIS_FLT_PRD f
              WHERE COD_FLT_TMP = 'T' AND ORD_FLT_TMP = 1 AND cod_src = 'MM' --AND f.id_dper = substr(SYS_CONTEXT ('userenv', 'client_info'),1,6)
                                                                            ) f
      WHERE cod_src = 'MM' AND x.id_dper(+) BETWEEN f.ID_DPER_pre AND f.ID_DPER
   GROUP BY f.id_dper,
            TO_CHAR (LAST_DAY (TO_DATE (id_dper_Pre, 'yyyymm')), 'yyyymmdd'),
            DES_MOV_CNT,
            COD_STATO_RISCHIO,
            des_stato_rischio,
            COD_ABI,
            COD_NDG;
