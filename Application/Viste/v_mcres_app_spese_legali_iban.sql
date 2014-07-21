/* Formatted on 21/07/2014 18:43:09 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SPESE_LEGALI_IBAN
(
   COD_MATR_PRATICA,
   COD_PRATICA,
   VAL_ANNO,
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
   VAL_AFAVORE_CODFISC,
   VAL_AFAVORE_PIVA,
   FLG_CONVENZIONE,
   VAL_IMPORTO_VALORE,
   FLG_SPESA_RIPETIBILE,
   COD_STATO,
   COD_ORGANO_AUTORIZZANTE,
   COD_IBAN,
   DTA_STORNO_CONTABILE,
   VAL_INTESTATARIO_CODFISC,
   VAL_INTESTATARIO_PIVA,
   COD_IBAN_LEG_ESTERNI1,
   COD_IBAN_LEG_ESTERNI2,
   COD_IBAN_LEG_ESTERNI3,
   COD_IBAN_LEG_ESTERNI4,
   COD_IBAN_LEG_ESTERNI5,
   COD_IBAN_LEG_ESTERNI6,
   COD_IBAN_LEG_ESTERNI7,
   COD_IBAN_LEG_ESTERNI8,
   COD_IBAN_LEG_ESTERNI9,
   COD_IBAN_LEG_ESTERNI10,
   COD_PROTOCOLLO
)
AS
   SELECT Pr.Cod_Matr_Pratica,
          Pr.Cod_Pratica,
          Pr.Val_Anno,
          Sp.Cod_Tipo_Autorizzazione,
          Sp.Val_Anno_Pratica,
          Sp.Cod_Abi,
          Sp.Cod_Ndg,
          anc.Desc_nome_controparte,
          Pre.Cod_Presidio,
          Pre.Desc_Presidio,
          sp.cod_punto_operativo,
          Sp.Cod_Autorizzazione,
          Sp.Dta_Ins_Spesa,
          Sp.Dta_Autorizzazione,
          Sp.Desc_intestatario,
          Sp.Val_Afavore_Codfisc,
          Sp.Val_Afavore_Piva,
          Sp.Flg_Convenzione,
          Sp.Val_Importo_Valore,
          Sp.Flg_Spesa_Ripetibile,
          Sp.Cod_Stato,
          Sp.Cod_Organo_Autorizzante,
          Sp.Cod_Iban,
          Sp.Dta_Storno_Contabile,
          SP.VAL_INTESTATARIO_CODFISC,
          SP.VAL_INTESTATARIO_PIVA,
          --AP 02/10/2012
          --L.VAL_IBAN cod_iban_leg_esterni
          L.VAL_IBAN1 cod_iban_leg_esterni1,
          L.VAL_IBAN2 cod_iban_leg_esterni2,
          L.VAL_IBAN3 cod_iban_leg_esterni3,
          L.VAL_IBAN4 cod_iban_leg_esterni4,
          L.VAL_IBAN5 cod_iban_leg_esterni5,
          L.VAL_IBAN6 cod_iban_leg_esterni6,
          L.VAL_IBAN7 cod_iban_leg_esterni7,
          L.VAL_IBAN8 cod_iban_leg_esterni8,
          L.VAL_IBAN9 cod_iban_leg_esterni9,
          L.VAL_IBAN10 cod_iban_leg_esterni10,
          sp.COD_PROTOCOLLO
     FROM T_Mcres_App_Sp_Spese Sp,
          T_Mcres_App_Pratiche Pr,
          T_Mcres_App_Posizioni Pos,
          T_Mcre0_App_Anagrafica_Gruppo Anc,
          V_MCRES_APP_LISTA_PRESIDI PRE,
          T_MCRES_APP_LEGALI_ESTERNI l
    WHERE     Sp.Cod_Pratica = Pr.Cod_Pratica
          AND Sp.Cod_Abi = Pr.Cod_Abi
          AND TRIM (Sp.Val_Anno_Pratica) = Pr.Val_Anno
          AND Pos.Cod_Abi = Pr.Cod_Abi
          AND Pos.Cod_Ndg = Pr.Cod_Ndg
          AND Pos.Flg_Attiva = 1
          AND POS.COD_SNDG = ANC.COD_SNDG(+)
          AND PRE.COD_PRESIDIO = PR.COD_UO_PRATICA
          AND SP.COD_id_LEGALE = L.COD_id_LEGALE(+);
