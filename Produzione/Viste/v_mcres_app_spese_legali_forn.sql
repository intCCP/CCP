/* Formatted on 17/06/2014 18:11:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SPESE_LEGALI_FORN
(
   DESC_INTESTATARIO,
   VAL_AFAVORE_CODFISC,
   VAL_AFAVORE_PIVA,
   DESC_AFAVORE,
   VAL_INTESTATARIO_CODFISC,
   VAL_INTESTATARIO_PIVA,
   VAL_TIPO_GESTIONE,
   COD_PRESIDIO,
   DESC_PRESIDIO,
   COD_PUNTO_OPERATIVO,
   COD_ABI,
   VAL_IMPORTO_VALORE,
   DESC_ISTITUTO,
   DTA_FATTURA,
   DTA_INS_SPESA,
   DTA_AUTORIZZAZIONE,
   ANNO,
   MESE,
   VAL_ANNO_PRATICA,
   COD_PROTOCOLLO
)
AS
   SELECT Sp.Desc_intestatario Desc_intestatario,
          Sp.Val_Afavore_Codfisc,
          Sp.Val_Afavore_Piva,
          Sp.Desc_afavore,
          Sp.Val_intestatario_Codfisc,
          Sp.Val_intestatario_Piva,
          Pre.Val_Tipo_Gestione,
          Pre.Cod_Presidio,
          Pre.Desc_Presidio,
          sp.cod_punto_operativo,
          Sp.Cod_Abi,
          Sp.Val_Importo_Valore,
          Ist.Desc_Istituto,
          Sp.Dta_Fattura,
          Sp.Dta_Ins_Spesa,
          Sp.Dta_Autorizzazione,
          TO_NUMBER (TO_CHAR (Sp.Dta_Fattura, 'yyyy')) anno,
          TO_CHAR (Sp.Dta_Fattura, 'mm') mese,
          sp.val_anno_pratica,
          sp.cod_protocollo
     FROM T_Mcres_App_Sp_Spese Sp,
          T_Mcres_App_Pratiche Pr,
          V_Mcres_App_Lista_Presidi Pre,
          t_mcres_app_istituti ist
    WHERE     Sp.Cod_Pratica = Pr.Cod_Pratica
          AND Sp.Cod_Abi = Pr.Cod_Abi
          AND TRIM (Sp.Val_Anno_Pratica) = Pr.Val_Anno
          AND Pre.Cod_Presidio = Pr.Cod_Uo_Pratica
          AND Ist.Cod_Abi = Sp.Cod_Abi;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_SPESE_LEGALI_FORN TO MCRE_USR;
