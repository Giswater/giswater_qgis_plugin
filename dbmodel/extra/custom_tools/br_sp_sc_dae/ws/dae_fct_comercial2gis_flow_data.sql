/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_comercial2gis_flowdata()
  RETURNS void AS
$BODY$
DECLARE

BEGIN

    SET search_path = "SCHEMA_NAME", public;


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
    >= CAST(current_date AS DATE) - CAST('250 days' AS INTERVAL)    
    AND concat(vw_daecom_consumo.ano_exercicio::text, '-', vw_daecom_consumo.mes_exercicio::text) NOT IN (Select cat_period_id from ext_rtc_hydrometer_x_data) 
    AND cod_dae::text IN (Select hydrometer_id from rtc_hydrometer);

-- DELETE OLD DATA FROM EXT_RTC_HYDROMETER_X_DATA

DELETE FROM SCHEMA_NAME.ext_rtc_hydrometer_x_data
        WHERE to_date(cat_period_id,'YYYY-MM')
    < CAST(current_date AS DATE) - CAST('250 days' AS INTERVAL)  ;   
    

    RETURN;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_comercial