/* Formatted on 21/07/2014 18:43:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SOSPESI_OLD
(
   COD_MATR_PRATICA,
   COD_PRATICA,
   COD_UO_PRATICA,
   VAL_ANNO,
   COD_NDG,
   DESC_AFAVORE,
   DESC_INTESTATARIO,
   COD_SPESA,
   VAL_NUMERO_FATTURA,
   COD_AUTORIZZAZIONE,
   DTA_AUTORIZZAZIONE,
   COD_ABI,
   COD_TIPO_AUTORIZZAZIONE,
   COD_STATO,
   STATO,
   DTA_INS_SPESA,
   VAL_IMPORTO,
   FLG_ART_498,
   COGNOME,
   NOME,
   COD_MATRICOLA,
   DESC_BREVE,
   DESC_ISTITUTO,
   DESC_NOME_CONTROPARTE,
   COD_ORGANO_AUTORIZZANTE
)
AS
   SELECT PR.COD_MATR_PRATICA,
          PR.COD_PRATICA,
          Pr.Cod_Uo_Pratica,
          Pr.Val_Anno,
          pr.cod_ndg,
          Sp.Desc_afavore,
          Sp.Desc_Intestatario,
             Sp.Val_Numero_Fattura
          || ' '
          || sp.cod_autorizzazione
          || ' '
          || Sp.Dta_Autorizzazione
             AS "COD_SPESA",
          Sp.Val_Numero_Fattura,
          Sp.Cod_Autorizzazione,
          Sp.Dta_Autorizzazione,
          Sp.Cod_Abi,
          Sp.Cod_Tipo_Autorizzazione,
          Sp.Cod_Stato,
          'Proposta' AS Stato,
          Sp.Dta_Ins_Spesa,
          Sp.Val_Importo_Valore AS Val_Importo,
          Pos.Flg_Art_498,
          Ute.Cognome,
          Ute.Nome,
          Ute.Cod_Matricola,
          IST.DESC_BREVE,
          IST.DESC_ISTITUTO,
          ANGR.DESC_NOME_CONTROPARTE,
          SP.COD_ORGANO_AUTORIZZANTE
     FROM T_Mcres_App_Sp_Spese Sp,
          T_Mcres_App_Pratiche Pr,
          T_Mcres_App_Posizioni Pos,
          T_Mcre0_App_Anagrafica_Gruppo Anc,
          T_MCRES_APP_UTENTI UTE,
          t_mcre0_app_istituti_all IST,
          t_mcre0_app_anagrafica_gruppo angr
    WHERE     Sp.Cod_Pratica = Pr.Cod_Pratica
          AND Sp.Cod_Abi = Pr.Cod_Abi
          AND TRIM (Sp.Val_Anno_Pratica) = Pr.Val_Anno
          AND Pos.Cod_Abi = Pr.Cod_Abi
          AND Pos.Cod_Ndg = Pr.Cod_Ndg
          AND Pos.Flg_Attiva = 1
          AND Pos.Cod_Sndg = Anc.Cod_Sndg(+)
          AND Pr.Cod_Matr_Pratica = Ute.Cod_Matricola(+)
          AND PR.COD_ABI = IST.COD_ABI(+)
          AND pos.cod_sndg = angr.cod_sndg(+)
          AND Sp.Cod_Stato = 'P';
