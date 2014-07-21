/* Formatted on 21/07/2014 18:44:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_PERFORMANCE
(
   COD_ABI,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   VAL_ANNOMESE,
   VAL_GBV_MEDIO,
   VAL_NBV_MEDIO,
   VAL_VANTATO_MEDIO,
   VAL_INCASSI,
   VAL_TMR_VANTATO,
   VAL_TMR_GBV,
   VAL_SOPRAVVENIENZE,
   VAL_VANTATO,
   VAL_GBV,
   NUM_MESI
)
AS
     SELECT S.COD_ABI,
            P.COD_UO_PRATICA,
            NVL (P.COD_MATR_PRATICA, -1) COD_MATR_PRATICA,
            S.VAL_ANNOMESE,
            SUM (S.VAL_GBV) / DECODE (NUM_MESI, 0, 1, NUM_MESI) VAL_GBV_MEDIO,
            SUM (S.VAL_NBV) / DECODE (NUM_MESI, 0, 1, NUM_MESI) VAL_NBV_MEDIO,
            SUM (S.VAL_VANTATO) / DECODE (NUM_MESI, 0, 1, NUM_MESI)
               VAL_VANTATO_MEDIO,
            SUM (M.VAL_INCASSI) VAL_INCASSI,
              SUM (VAL_SOPRAVVENIENZE + M.VAL_INCASSI)
            / (  DECODE (SUM (S.VAL_VANTATO), 0, 1, SUM (S.VAL_VANTATO))
               / DECODE (NUM_MESI, 0, 1, NUM_MESI))
               VAL_TMR_VANTATO,
              SUM (val_sopravvenienze + m.val_incassi)
            / (  DECODE (SUM (s.val_gbv), 0, 1, SUM (s.val_gbv))
               / DECODE (num_mesi, 0, 1, num_mesi))
               val_tmr_gbv,
            SUM (val_sopravvenienze) val_sopravvenienze,
            SUM (s.val_vantato) val_vantato,
            SUM (s.val_gbv) val_gbv,
            num_mesi
       FROM (  SELECT MOV.COD_ABI,
                      MOV.COD_NDG,
                      SUBSTR (id_dper, 1, 6) VAL_ANNOMESE,
                      SUM (
                         CASE
                            WHEN UPPER (MOV.DESC_MODULO) IN
                                    ('ALL.6 - SOFFERENZE ESTINTE',
                                     'ALL.7 - SOFFERENZE RIDOTTE')
                            THEN
                               MOV.VAL_CR_TOT
                            ELSE
                               0
                         END)
                         VAL_INCASSI
                 FROM T_MCRES_APP_MOVIMENTI_MOD_MOV MOV
             GROUP BY MOV.COD_ABI, mov.cod_ndg, SUBSTR (id_dper, 1, 6)) M,
            (  SELECT C.COD_ABI,
                      C.COD_NDG,
                      SUBSTR (c.id_dper, 1, 6) VAL_ANNOMESE,
                      SUBSTR (SUBSTR (c.id_dper, 1, 6), 5, 2) + 1 NUM_MESI,
                      SUM (C.VAL_UTI_RET) val_gbv,
                      SUM (C.VAL_ATT) val_nbv,
                      SUM (C.VAL_VANT) val_vantato,
                      SUM (c.VAL_SOPRAVVENIENZE) VAL_SOPRAVVENIENZE
                 FROM T_MCRES_APP_SISBA_CP C
                WHERE C.COD_STATO_RISCHIO = 'S'
             GROUP BY C.COD_ABI,
                      C.COD_NDG,
                      SUBSTR (c.id_dper, 1, 6),
                      SUBSTR (SUBSTR (c.id_dper, 1, 6), 5, 2) + 1) S,
            --T_MCRES_APP_GESTORI_PL P
            T_MCRES_APP_pratiche P
      WHERE     S.COD_ABI = M.COD_ABI
            AND S.COD_NDG = M.COD_NDG
            AND s.val_annomese = m.val_annomese
            AND s.COD_ABI = p.COD_ABI
            AND s.cod_ndg = p.cod_ndg
            --AND last_day(TO_DATE(s.VAL_ANNOMESE,'YYYYMM')) BETWEEN
            -- P.DTA_DECORRENZAINCARICO
            --  AND NVL(P.DTA_FINEDECORRENZAINCARICO,SYSDATE)
            AND P.FLG_ATTIVA = 1
   GROUP BY S.COD_ABI,
            P.COD_UO_PRATICA,
            COD_MATR_PRATICA,
            num_mesi,
            s.val_annomese;
