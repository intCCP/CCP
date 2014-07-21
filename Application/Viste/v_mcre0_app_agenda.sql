/* Formatted on 21/07/2014 18:31:34 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_AGENDA
(
   ID,
   ID_UTENTE,
   COD_NDG,
   COD_ABI_CARTOLARIZZATO,
   DTA_INIZIO_APPUNTAMENTO,
   DESCRIZIONE,
   DTA_FINE_APPUNTAMENTO,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE
)
AS
   SELECT                                                      /*-+ ORDERED */
         A.ID,
          A.ID_UTENTE,
          A.COD_NDG,
          A.COD_ABI_CARTOLARIZZATO,
          A.DTA_INIZIO_APPUNTAMENTO,
          A.DESCRIZIONE,
          A.DTA_FINE_APPUNTAMENTO,
          F.DESC_NOME_CONTROPARTE,
          F.COD_GRUPPO_ECONOMICO,
          F.DESC_GRUPPO_ECONOMICO VAL_ANA_GRE
     FROM T_MCRE0_APP_AGENDA A,               ---V_MCRE0_APP_UPD_FIELDS_ALL  F
                                -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
                                V_MCRE0_APP_UPD_FIELDS_ALL F
    WHERE     A.COD_ABI_CARTOLARIZZATO = F.COD_ABI_CARTOLARIZZATO(+)
          AND A.COD_NDG = F.COD_NDG(+);
