/* Formatted on 21/07/2014 18:43:10 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SPESE_LEGALI_INES
(
   VAL_ANNO_PRATICA,
   FLG_CONVENZIONE,
   COD_TIPO_AUTORIZZAZIONE,
   DTA_INS_SPESA,
   COD_ABI,
   COD_NDG,
   DESC_INTESTATARIO,
   COD_PRESIDIO,
   DESC_PRESIDIO,
   VAL_TIPO_GESTIONE,
   COD_AUTORIZZAZIONE,
   DTA_FATTURA,
   DTA_AUTORIZZAZIONE,
   VAL_AFAVORE_CODFISC,
   VAL_AFAVORE_PIVA,
   VAL_INTESTATARIO_CODFISC,
   VAL_INTESTATARIO_PIVA,
   DESC_AFAVORE,
   VAL_IMPORTO_VALORE,
   FLG_SPESA_RIPETIBILE,
   COD_STATO,
   COD_ORGANO_AUTORIZZANTE,
   DTA_STORNO_CONTABILE,
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   COD_PROTOCOLLO,
   COD_MATR_PRATICA,
   COGNOME,
   NOME,
   COD_TIPOLOGIA_FORNITORE
)
AS
   SELECT sp.val_anno_pratica,
          Sp.Flg_Convenzione,
          Sp.Cod_Tipo_Autorizzazione,
          Sp.Dta_Ins_Spesa,
          Sp.Cod_Abi,
          Sp.Cod_Ndg,
          SP.DESC_INTESTATARIO,
          PRE.COD_PRESIDIO,
          PRE.DESC_PRESIDIO,
          Pre.Val_Tipo_Gestione,
          Sp.Cod_Autorizzazione,
          Sp.Dta_Fattura,
          Sp.Dta_Autorizzazione,
          Sp.Val_Afavore_Codfisc,
          Sp.Val_Afavore_Piva,
          Sp.Val_intestatario_Codfisc,
          Sp.Val_intestatario_Piva,
          Sp.Desc_Afavore,
          Sp.Val_Importo_Valore,
          Sp.Flg_Spesa_Ripetibile,
          --Sp.Cod_Stato,
          DECODE (sp.COD_STATO,
                  'P', 'IM',
                  'A', 'CO',
                  'D', 'DE',
                  'X', 'AN',
                  sp.COD_STATO)
             COD_STATO,
          --SP.COD_ORGANO_AUTORIZZANTE,
          CASE
             WHEN     sp.COD_ORGANO_AUTORIZZANTE = 'P'
                  AND stru.COD_LIVELLO IN ('IP', 'IC')
             THEN
                'PI'
             ELSE
                'RP'
          END
             cod_organo_autorizzante,
          SP.DTA_STORNO_CONTABILE,
          ANC.DESC_NOME_CONTROPARTE,
          Anc.Cod_Sndg,
          --AP 02/10/2012
          Sp.cod_protocollo,
          pr.COD_MATR_PRATICA,
          u.cognome,
          u.nome,
          sp.cod_intestatario_tipo cod_tipologia_fornitore
     FROM T_Mcres_App_Sp_Spese Sp,
          T_MCRES_APP_PRATICHE PR,
          T_MCRES_APP_POSIZIONI POS,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO ANC,
          V_Mcres_App_Lista_Presidi pre,
          t_mcre0_app_struttura_org stru,
          t_mcres_app_utenti u
    WHERE     Sp.Cod_Pratica = Pr.Cod_Pratica
          AND SP.COD_ABI = PR.COD_ABI
          AND TRIM (Sp.Val_Anno_Pratica) = Pr.Val_Anno
          AND pr.cod_matr_pratica = u.cod_matricola(+)
          AND Pos.Cod_Abi = Pr.Cod_Abi
          AND Pos.Cod_Ndg = Pr.Cod_Ndg
          AND POS.FLG_ATTIVA = 1
          AND POS.COD_SNDG = ANC.COD_SNDG(+)
          AND Pre.Cod_Presidio = Pr.Cod_Uo_Pratica
          AND sp.cod_uo = stru.cod_struttura_competente(+)
          AND sp.cod_abi = stru.cod_abi_istituto(+);
