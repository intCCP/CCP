/* Formatted on 17/06/2014 17:59:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_PP
(
   COD_SRC,
   COD_ABI,
   ID_DPER,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_NDG,
   COD_SNDG,
   DTA_INIZIO_STATO,
   FLG_NDG,
   FLG_NUOVO_INGRESSO,
   VAL_GBV,
   VAL_NBV
)
AS
     SELECT 'PP' cod_src,
            P.COD_ABI,
            b.VAL_ANNOMESE id_dper,
            'S' cod_stato_rischio,
            'Sofferenze' des_stato_rischio,
            P.COD_NDG,
            R.COD_SNDG,
            P.DTA_PASSAGGIO_SOFF dta_inizio_stato,
            1 flg_ndg,
            1 flg_nuovo_ingresso,
            SUM (-R.VAL_IMP_GBV) VAL_GBV,
            SUM (-R.VAL_IMP_NBV) VAL_NBV
       FROM T_MCRES_APP_POSIZIONI P,
            T_MCRES_APP_RAPPORTI R,
            v_MCRES_ULTIMA_ACQ_BILANCIO B
      WHERE     P.DTA_PASSAGGIO_SOFF > b.DTA_DPER
            AND R.COD_ABI = P.COD_ABI
            AND R.COD_NDG = P.COD_NDG
            AND P.COD_ABI = B.COD_ABI
            AND P.FLG_ATTIVA = 1
   -- AND b.VAL_ANNOMESE = SYS_CONTEXT ('userenv', 'client_info')
   GROUP BY P.COD_ABI,
            b.VAL_ANNOMESE,
            P.COD_NDG,
            R.COD_SNDG,
            P.DTA_PASSAGGIO_SOFF;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.QZV_ST_MIS_PP TO MCRE_USR;
