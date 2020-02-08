/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2768

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_mapzones_advanced(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_mapzones_advanced(p_data json)
RETURNS json AS
$BODY$

/*
SELECT gw_fct_grafanalytics_mapzones_advanced('{"data":{"parameters":{"grafClass":"SECTOR", "exploitation": "[15]", 
"updateFeature":"TRUE", "updateMapZone":1,"geomParamUpdate":0.85, "debug":"FALSE"}}}');

SELECT gw_fct_grafanalytics_mapzones_advanced('{"data":{"parameters":{"grafClass":"DMA", "exploitation": "[1]", 
"updateFeature":"TRUE", "updateMapZone":3,"geomParamUpdate":10}}}');
ELECT dma_id, count(dma_id) from v_edit_arc  group by dma_id order by 1;

SELECT gw_fct_grafanalytics_mapzones_advanced('{"data":{"parameters":{"grafClass":"DQA", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":0}}}');

SELECT gw_fct_grafanalytics_mapzones_advanced('{"data":{"parameters":{"grafClass":"PRESSZONE","exploitation":"[1,2]",
"updateFeature":"TRUE","updateMapZone":2","geomParamUpdate":10}}}');
*/

DECLARE


BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;


	RETURN gw_fct_grafanalytics_mapzones(p_data);
	

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;