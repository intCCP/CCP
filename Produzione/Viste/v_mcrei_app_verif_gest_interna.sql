/* Formatted on 17/06/2014 18:08:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_VERIF_GEST_INTERNA
(
   COD_SNDG_DA_CLASS,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   FLG_FONDO_TERZI,
   FLG_ART_498,
   COD_STRUTTURA_COMPETENTE,
   FLG_GESTIONE_ESTERNA,
   COD_STATO
)
AS
   SELECT                            /* + INDEX(f IX2_T_MCRE0_APP_ALL_DATA) */
          /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
                                      BEGIN dbms_application_info.set_client_info( cod_sndg_ricerca ); END;*/
          DISTINCT
          leg.cod_sndg_legame AS cod_sndg_da_class,
          f.cod_abi_cartolarizzato,
          f.cod_ndg,
          f.cod_sndg,
          NVL (r.flg_fondo_terzi, 'N') AS flg_fondo_terzi,
          DECODE (p.flg_art_498, 'S', 'Y', p.flg_art_498) flg_art_498,
          f.cod_struttura_competente,
          CASE
             WHEN f.cod_stato = 'SO'
             THEN
                DECODE (s.COD_LIVELLO,  'PL', 'Y',  'IP', 'Y',  'N')
             ELSE
                'N'
          END
             AS flg_gestione_esterna,
          NULLIF (f.cod_stato, '-1') COD_STATO
     FROM /*t_mcrei_app_pratiche a,
                                                                                                                                                                                                                                                                                                                                                                     */
         t_mcres_app_posizioni p,
          t_mcrei_app_rapporti r,
          t_mcre0_app_all_data f,
          t_mcre0_app_struttura_org s,
          ( (SELECT a.cod_sndg, a.cod_sndg_legame
               FROM t_mcre0_app_legame a
              WHERE cod_legame = 'TIT')
           UNION ALL
           (SELECT c.cod_sndg_legame, c.cod_sndg
              FROM t_mcre0_app_legame c
             WHERE cod_legame = 'TIT')
           UNION
           (SELECT SYS_CONTEXT ('userenv', 'client_info'),
                   SYS_CONTEXT ('userenv', 'client_info')
              FROM DUAL)) leg
    WHERE     f.cod_sndg = leg.cod_sndg
          AND f.id_dperfg = p.id_dper(+)
          AND f.cod_abi_cartolarizzato = s.cod_abi_istituto
          AND NVL (f.cod_struttura_competente, '-') =
                 s.cod_struttura_competente
          AND f.cod_abi_cartolarizzato = p.cod_abi(+)
          AND f.cod_ndg = p.cod_ndg(+)
          AND f.cod_abi_cartolarizzato = r.cod_abi(+)
          AND f.cod_ndg = r.cod_ndg(+)
          --AND a.flg_attiva(+) = '1'
          AND r.flg_attiva(+) = '1'
          AND p.flg_attiva(+) = '1';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_VERIF_GEST_INTERNA TO MCRE_USR;
