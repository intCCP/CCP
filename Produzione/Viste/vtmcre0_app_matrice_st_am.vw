/* Formatted on 17/06/2014 18:16:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_MATRICE_ST_AM
(
   COD_STATO,
   COD_PROCESSO,
   VAL_NUM_POSIZIONI,
   VAL_UTILIZZI
)
AS
     SELECT cod_stato,
            cod_processo,
            COUNT (*) val_num_posizioni,
            SUM (utilizzo) val_utilizzi
       FROM (SELECT ad.cod_stato,
                    ad.cod_processo,
                    ad.cod_abi_cartolarizzato,
                    rag.scsb_uti_tot AS utilizzo
               FROM vtmcre0_app_upd_fields ad,
                    t_mcrei_app_pcr_rapp_aggr rag,
                    t_mcre0_cl_processi pr
              WHERE     ad.cod_abi_cartolarizzato = rag.cod_abi_cartolarizzato
                    AND ad.cod_ndg = rag.cod_ndg
                    AND ad.cod_stato IS NOT NULL
                    AND ad.cod_processo IS NOT NULL
                    AND ad.cod_processo = pr.cod_processo
                    AND ad.cod_abi_cartolarizzato = pr.cod_abi
                    AND ad.cod_abi_cartolarizzato =
                           SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                   1,
                                   5)
                    AND CASE SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                     7,
                                     5)
                           WHEN 'xxxxx'
                           THEN
                              'xxxxx'
                           ELSE
                              pr.cod_div
                        END =
                           CASE SUBSTR (
                                   (SYS_CONTEXT ('userenv', 'client_info')),
                                   7,
                                   5)
                              WHEN 'xxxxx'
                              THEN
                                 'xxxxx'
                              ELSE
                                 SUBSTR (
                                    (SYS_CONTEXT ('userenv', 'client_info')),
                                    7,
                                    5)
                           END
                    -- COD_TIPO_DIVISIONE da inserire
                    AND pr.tip_div =
                           SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                   13,
                                   1)
                    --Filtro per AREA
                    AND CASE SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                     15,
                                     5)
                           WHEN 'xxxxx'
                           THEN
                              'xxxxx'
                           ELSE
                              ad.cod_struttura_competente_ar
                        END =
                           CASE SUBSTR (
                                   (SYS_CONTEXT ('userenv', 'client_info')),
                                   15,
                                   5)
                              WHEN 'xxxxx'
                              THEN
                                 'xxxxx'
                              ELSE
                                 SUBSTR (
                                    (SYS_CONTEXT ('userenv', 'client_info')),
                                    15,
                                    5)
                           END
                    --Filtro per FILIALE
                    AND CASE SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                     21,
                                     5)
                           WHEN 'xxxxx'
                           THEN
                              'xxxxx'
                           ELSE
                              ad.cod_struttura_competente_fi
                        END =
                           CASE SUBSTR (
                                   (SYS_CONTEXT ('userenv', 'client_info')),
                                   21,
                                   5)
                              WHEN 'xxxxx'
                              THEN
                                 'xxxxx'
                              ELSE
                                 SUBSTR (
                                    (SYS_CONTEXT ('userenv', 'client_info')),
                                    21,
                                    5)
                           END
                    --Filtro per GESTORE
                    AND CASE SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                     27,
                                     7)
                           WHEN 'xxxxxxx'
                           THEN
                              'xxxxxxx'
                           ELSE
                              ad.cod_matricola
                        END =
                           CASE SUBSTR (
                                   (SYS_CONTEXT ('userenv', 'client_info')),
                                   27,
                                   7)
                              WHEN 'xxxxxxx'
                              THEN
                                 'xxxxxxx'
                              ELSE
                                 SUBSTR (
                                    (SYS_CONTEXT ('userenv', 'client_info')),
                                    27,
                                    7)
                           END)
   GROUP BY cod_stato, cod_processo;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_MATRICE_ST_AM TO MCRE_USR;
