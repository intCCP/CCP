/* Formatted on 21/07/2014 18:36:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_CL_MAPPA_SWOTTEST_PM
(
   COD_RIGA,
   COD_COLONNA,
   COD_LIVELLO_1,
   DESC_LIVELLO_1,
   COD_LIVELLO_2,
   DESC_LIVELLO_2,
   COD_LIVELLO_3,
   DESC_LIVELLO_3,
   COD_LIVELLO_4,
   DESC_LIVELLO_4,
   VAL_ORDINE_RIGA,
   VAL_ORDINE_COLONNA,
   DESC_CELLA
)
AS
   SELECT cella.cod_riga,
          cella.cod_colonna,
          cella.cod_livello_1,
          desc_livello_1.desc_livello desc_livello_1,
          cella.cod_livello_2,
          desc_livello_2.desc_livello desc_livello_2,
          cella.cod_livello_3,
          desc_livello_3.desc_livello desc_livello_3,
          cella.cod_livello_4,
          desc_livello_4.desc_livello desc_livello_4,
          cella.val_ordine_riga,
          cella.val_ordine_colonna,
          cella.desc_cella
     FROM T_MCRE0_CL_CELLA_SWOTTEST_PM cella
          LEFT JOIN T_MCRE0_CL_LIVELLI_SWOTTEST_PM desc_livello_1
             ON cella.cod_livello_1 = desc_livello_1.cod_livello
          LEFT JOIN T_MCRE0_CL_LIVELLI_SWOTTEST_PM desc_livello_2
             ON cella.cod_livello_2 = desc_livello_2.cod_livello
          LEFT JOIN T_MCRE0_CL_LIVELLI_SWOTTEST_PM desc_livello_3
             ON cella.cod_livello_3 = desc_livello_3.cod_livello
          LEFT JOIN T_MCRE0_CL_LIVELLI_SWOTTEST_PM desc_livello_4
             ON cella.cod_livello_4 = desc_livello_4.cod_livello;
