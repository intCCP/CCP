/* Formatted on 21/07/2014 18:39:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_CR_SC_GB
(
   COD_SNDG,
   VAL_ACC_SYS_BRT,
   VAL_ACC_SYS_MLT,
   VAL_ACC_SYS_FIR,
   VAL_ACC_SYS_TOT,
   VAL_UTI_SYS_BRT,
   VAL_UTI_SYS_MLT,
   VAL_UTI_SYS_FIR,
   VAL_UTI_SYS_TOT,
   VAL_SCONFINO_SYS_TOT,
   VAL_ACC_GB_BRT,
   VAL_ACC_GB_MLT,
   VAL_ACC_GB_FIR,
   VAL_ACC_GB_TOT,
   VAL_UTI_GB_BRT,
   VAL_UTI_GB_MLT,
   VAL_UTI_GB_FIR,
   VAL_UTI_GB_TOT,
   VAL_SCONFINO_GB_TOT
)
AS
   SELECT COD_SNDG,
          VAL_ACC_SIS_SC_BRT AS VAL_ACC_SYS_BRT, -- Accordato di Sistema Cassa Breve Termine
          VAL_ACC_SIS_SC_MLT AS VAL_ACC_SYS_MLT, -- Accordato di Sistema Cassa Medio-Lungo Termine
          VAL_ACC_SIS_SC_FIR AS VAL_ACC_SYS_FIR, -- Accordato di Sistema Firma
          VAL_ACC_SIS_SC AS VAL_ACC_SYS_TOT, -- Accordato di Sistema Sub-totale
          VAL_UTI_SIS_SC_BRT AS VAL_UTI_SYS_BRT, -- Utilizzato di Sistema Cassa Breve Termine
          VAL_UTI_SIS_SC_MLT AS VAL_UTI_SYS_MLT, -- Utilizzato di Sistema Cassa Medio-Lungo Termine
          VAL_UTI_SIS_SC_FIR AS VAL_UTI_SYS_FIR, -- Utilizzato di Sistema Firma
          VAL_UTI_SIS_SC AS VAL_UTI_SYS_TOT, -- Utilizzato di Sistema Sub-totale
          VAL_SCO_SIS_SC AS VAL_SCONFINO_SYS_TOT, -- Sconfino di Sistema Sub-totale
          VAL_ACC_CR_SC_BRT AS VAL_ACC_GB_BRT, -- Accordato Gruppo Bancario Cassa Breve Termine
          VAL_ACC_CR_SC_MLT AS VAL_ACC_GB_MLT, -- Accordato Gruppo Bancario Medio-Lungo Termine
          VAL_ACC_CR_SC_FIR AS VAL_ACC_GB_FIR,       -- Accordato Gruppo Firma
          VAL_ACC_CR_SC AS VAL_ACC_GB_TOT, -- Accordato Gruppo Bancario Sub-totale
          VAL_UTI_CR_SC_BRT AS VAL_UTI_GB_BRT, -- Utilizzato Gruppo Bancario Cassa Breve Termine
          VAL_UTI_CR_SC_MLT AS VAL_UTI_GB_MLT, -- Utilizzato Gruppo Bancario Medio-Lungo Termine
          VAL_UTI_CR_SC_FIR AS VAL_UTI_GB_FIR,      -- Utilizzato Gruppo Firma
          VAL_UTI_CR_SC AS VAL_UTI_GB_TOT, -- Utilizzato Gruppo Bancario Sub-totale
          VAL_SCO_CR_SC AS VAL_SCONFINO_GB_TOT -- Sconfino Gruppo Bancario Sub-totale
     FROM T_MCRE0_APP_CR_SC_GB;

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_ACC_SYS_MLT IS 'Accordato di Sistema Cassa Medio-Lungo Termine ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_ACC_SYS_FIR IS 'Accordato di Sistema Firma                     ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_ACC_SYS_TOT IS 'Accordato di Sistema Sub-totale                ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_UTI_SYS_BRT IS 'Utilizzato di Sistema Cassa Breve Termine      ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_UTI_SYS_MLT IS 'Utilizzato di Sistema Cassa Medio-Lungo Termine';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_UTI_SYS_FIR IS 'Utilizzato di Sistema Firma                    ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_UTI_SYS_TOT IS 'Utilizzato di Sistema Sub-totale               ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_SCONFINO_SYS_TOT IS 'Sconfino di Sistema Sub-totale                 ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_ACC_GB_BRT IS 'Accordato Gruppo Bancario Cassa Breve Termine  ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_ACC_GB_MLT IS 'Accordato Gruppo Bancario Medio-Lungo Termine  ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_ACC_GB_FIR IS 'Accordato Gruppo Firma                         ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_ACC_GB_TOT IS 'Accordato Gruppo Bancario Sub-totale           ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_UTI_GB_BRT IS 'Utilizzato Gruppo Bancario Cassa Breve Termine ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_UTI_GB_MLT IS 'Utilizzato Gruppo Bancario Medio-Lungo Termine ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_UTI_GB_FIR IS 'Utilizzato Gruppo Firma                        ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_UTI_GB_TOT IS 'Utilizzato Gruppo Bancario Sub-totale          ';

COMMENT ON COLUMN MCRE_OWN.V_MCREI_APP_CR_SC_GB.VAL_SCONFINO_GB_TOT IS 'Sconfino Gruppo Bancario Sub-totale            ';
