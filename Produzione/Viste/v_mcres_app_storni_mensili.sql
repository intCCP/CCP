/* Formatted on 17/06/2014 18:11:49 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_STORNI_MENSILI
(
   COD_MATR_PRATICA,
   COD_PRATICA,
   COD_TIPO_AUTORIZZAZIONE,
   VAL_ANNO_PRATICA,
   COD_ABI,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_PRESIDIO,
   DESC_PRESIDIO,
   COD_PUNTO_OPERATIVO,
   COD_AUTORIZZAZIONE,
   DTA_INS_SPESA,
   DTA_AUTORIZZAZIONE,
   DESC_INTESTATARIO,
   DESC_AFAVORE,
   VAL_AFAVORE_CODFISC,
   VAL_AFAVORE_PIVA,
   VAL_INTESTATARIO_CODFISC,
   VAL_INTESTATARIO_PIVA,
   FLG_CONVENZIONE,
   VAL_IMPORTO_VALORE,
   FLG_SPESA_RIPETIBILE,
   COD_STATO,
   COD_ORGANO_AUTORIZZANTE,
   DTA_STORNO_CONTABILE
)
AS
   SELECT Pr.Cod_Matr_Pratica,
          Pr.Cod_Pratica,
          Sp.Cod_Tipo_Autorizzazione,
          Sp.Val_Anno_Pratica,
          Sp.Cod_Abi,
          Sp.Cod_Ndg,
          Anc.Desc_Nome_Controparte,
          Pre.Cod_Presidio,
          Pre.Desc_Presidio,
          Sp.COD_PUNTO_OPERATIVO,
          Sp.Cod_Autorizzazione,
          Sp.Dta_Ins_Spesa,
          Sp.Dta_Autorizzazione,
          Sp.Desc_intestatario,
          Sp.Desc_afavore,
          Sp.Val_Afavore_Codfisc,
          Sp.Val_Afavore_Piva,
          Sp.Val_intestatario_Codfisc,
          Sp.Val_Intestatario_Piva,
          Sp.Flg_Convenzione,
          Sp.Val_Importo_Valore,
          Sp.Flg_Spesa_Ripetibile,
          Sp.Cod_Stato,
          Sp.Cod_Organo_Autorizzante,
          Sp.Dta_Storno_Contabile
     FROM T_Mcres_App_Sp_Spese Sp,
          T_Mcres_App_Pratiche Pr,
          T_Mcres_App_Posizioni Pos,
          T_Mcre0_App_Anagrafica_Gruppo Anc,
          V_Mcres_App_Lista_Presidi pre
    WHERE     Sp.Cod_Pratica = Pr.Cod_Pratica
          AND Sp.Cod_Abi = Pr.Cod_Abi
          AND Sp.Val_Anno_Pratica = Pr.Val_Anno
          AND Pos.Cod_Abi = Pr.Cod_Abi
          AND Pos.Cod_Ndg = Pr.Cod_Ndg
          AND Pos.Flg_Attiva = 1
          AND Pos.Cod_Sndg = Anc.Cod_Sndg(+)
          AND Pre.Cod_Presidio = Pr.Cod_Uo_Pratica;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_STORNI_MENSILI TO MCRE_USR;
