/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2638
  
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_update_dma_hydroval()
 RETURNS integer AS
$BODY$

/* example
SELECT SCHEMA_NAME.gw_fct_utils_update_dma_hydroval()
*/

DECLARE

	
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	UPDATE ext_rtc_scada_dma_period SET m3_total_period=b.sum, m3_total_period_hydro=b.sum, effc=1 
	FROM (	SELECT cat_period_id, dma_id, sum(sum) FROM ext_rtc_hydrometer_x_data a
			JOIN rtc_hydrometer_x_connec b on b.hydrometer_id=a.hydrometer_id
			JOIN connec c ON b.connec_id=c.connec_id
			group by cat_period_id, dma_id
			order by 1, 2) b
		WHERE ext_rtc_scada_dma_period.cat_period_id=b.cat_period_id AND ext_rtc_scada_dma_period.dma_id::integer=b.dma_id;

	RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

