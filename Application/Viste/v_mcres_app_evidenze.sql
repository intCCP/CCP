/* Formatted on 21/07/2014 18:42:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_EVIDENZE
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_LABEL,
   DESC_TIPO_EVIDENZA,
   COD_UO_PRATICA,
   DESC_UO_PRATICA,
   COD_MATR_PRATICA,
   DESC_NOME_GESTORE,
   DESC_BREVE,
   VAL_GBV,
   VAL_TIPO_GESTIONE,
   DTA_PASSAGGIO_SOFF,
   VAL_RETTIFICA_INC,
   VAL_PERC_DUBBIO_ESITO
)
AS
   SELECT S."COD_ABI",
          I.DESC_ISTITUTO,
          S."COD_NDG",
          S."COD_SNDG",
          A.DESC_NOME_CONTROPARTE,
          S.COD_LABEL,
          L.DESCRIZIONE desc_tipo_evidenza,
          S."COD_UO_PRATICA",
          STRU.DESC_STRUTTURA_COMPETENTE AS DESC_UO_PRATICA,
          S."COD_MATR_PRATICA",
          U.COGNOME || ' ' || U.Nome Desc_Nome_Gestore,
          desc_breve,
          val_gbv,
          VAL_TIPO_GESTIONE,
          DTA_PASSAGGIO_SOFF,
          VAL_RETTIFICA_INC,
          VAL_PERC_DUBBIO_ESITO
     FROM T_Mcres_Fen_Evidenze S,
          (SELECT *
             FROM T_mcres_cl_labels
            WHERE cod_utilizzo = 'EVIDENZE') L,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO a,
          T_Mcres_App_Istituti I,
          T_mcres_app_utenti u,
          t_mcre0_app_struttura_org stru
    WHERE     S.COD_SNDG = A.COD_SNDG(+)
          AND S.COD_ABI = I.COD_ABI(+)
          AND S.Cod_Label = L.Cod_Label(+)
          AND s.COD_MATR_PRATICA = U.COD_MATRICOLA(+)
          AND s.cod_uo_pratica = stru.cod_struttura_competente(+)
          AND s.cod_abi = stru.cod_abi_istituto(+);
