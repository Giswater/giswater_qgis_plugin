/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



DROP FUNCTION gw_saa.gw_fct_comercial2gis_flow_data();

CREATE OR REPLACE FUNCTION gw_saa.gw_fct_comercial2gis_flow_data()
  RETURNS void AS
$BODY$
DECLARE

BEGIN

    SET search_path = "gw_saa", public;

-- DELETE OLD DATA FROM EXT_RTC_HYDROMETER_X_DATA
DELETE FROM gw_saa.ext_rtc_hydrometer_x_data;

-- INSERT NEW DATA INTO EXT_RTC_HYDROMETER_X_DATA

INSERT INTO ext_rtc_hydrometer_x_data (hydrometer_id, avg, sum, cat_period_id)
SELECT 
    vw_daecom_consumo.cod_dae,
    vw_daecom_consumo.mediaconsumo,
    vw_daecom_consumo.consumo,
    concat(vw_daecom_consumo.ano_exercicio::text, '-', vw_daecom_consumo.mes_exercicio::text) AS cat_period_id
    FROM vw_daecom_consumo
    JOIN rtc_hydrometer ON rtc_hydrometer.hydrometer_id::integer=vw_daecom_consumo.cod_dae
    WHERE to_date(concat(vw_daecom_consumo.ano_exercicio::text,'-',vw_daecom_consumo.mes_exercicio::text),'YYYY-MM')
    >= CAST(current_date AS DATE) - CAST('250 days' AS INTERVAL)    ;
   
   

    RETURN;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gw_saa.gw_fct_comercial2gis_flow_data()
  OWNER TO postgres;
GRANT EXECUTE ON FUNCTION gw_saa.gw_fct_comercial2gis_flow_data() TO postgres;
GRANT EXECUTE ON FUNCTION gw_saa.gw_fct_comercial2gis_flow_data() TO public;
GRANT EXECUTE ON FUNCTION gw_saa.gw_fct_comercial2gis_flow_data() TO rol_editor;
GRANT EXECUTE ON FUNCTION gw_saa.gw_fct_comercial2gis_flow_data() TO rol_editor_saa;
GRANT EXECUTE ON FUNCTION gw_saa.gw_fct_comercial2gis_flow_data() TO rol_supereditor;
GRANT EXECUTE ON FUNCTION gw_saa.gw_fct_comercial2gis_flow_data() TO rol_supereditor_saa;