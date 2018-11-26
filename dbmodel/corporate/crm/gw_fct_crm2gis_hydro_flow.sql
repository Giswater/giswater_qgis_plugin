/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "crm", public, pg_catalog;



-- ----------------------------
-- CRM FUNCTIONS
-- ----------------------------


CREATE OR REPLACE FUNCTION crm.gw_fct_crm2gis_hydro_flow()
  RETURNS void AS
$BODY$DECLARE


BEGIN

	-- Search path
	SET search_path = "ws", public;

	-- DELETE OLD DATA FROM EXT_RTC_HYDROMETER_X_DATA
	DELETE FROM ext_rtc_hydrometer_x_data;

	-- INSERT NEW DATA INTO EXT_RTC_HYDROMETER_X_DATA
	INSERT INTO ext_rtc_hydrometer_x_data (hydrometer_id, avg, sum, cat_period_id, value_date)
	SELECT 
	hydrometer_id,
	null,
	m3value,
	period_id,
	value_date
	FROM crm.hydrometer_x_data
	
   
RETURN;
            
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;