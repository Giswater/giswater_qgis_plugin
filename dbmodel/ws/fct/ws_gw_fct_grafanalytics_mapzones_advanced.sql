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
SELECT gw_fct_grafanalytics_mapzones_advanced('{"data":{"parameters":{"grafClass":"SECTOR", "exploitation": "15", 
"updateFeature":"TRUE", "updateMapZone":1, "debug":"FALSE"}}}');

SELECT gw_fct_grafanalytics_mapzones_advanced('{"data":{"parameters":{"grafClass":"DMA", "exploitation": "1", 
"updateFeature":"TRUE", "updateMapZone":3}}}');

SELECT gw_fct_grafanalytics_mapzones_advanced('{"data":{"parameters":{"grafClass":"DQA", "exploitation": "2", 
"updateFeature":"TRUE", "updateMapZone":0}}}');

*/

DECLARE

v_class text;
v_expl integer;
v_updatemapzone integer;
v_data json;
v_paramupdate float;
v_floodfromnode text;
v_forceclosed text;
v_forceopen text;
v_usepsector text;


BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	
	v_class = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'grafClass');
	v_updatemapzone = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_paramupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');
	v_floodfromnode = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'floodFromNode');
	v_forceclosed = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'forceClosed');
	v_forceopen = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'forceOpen');
	v_usepsector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePlanPsector');

	-- control of null values
	IF v_paramupdate IS NULL THEN v_paramupdate = 5; END IF;
	IF v_floodfromnode IS NULL THEN v_floodfromnode = ''; END IF;
	IF v_forceclosed IS NULL THEN v_forceclosed = ''; END IF;
	IF v_forceopen IS NULL THEN v_forceopen = ''; END IF;
	IF v_usepsector IS NULL THEN v_usepsector = FALSE ; END IF;
	IF v_updatemapzone IS NULL THEN v_updatemapzone = 1; END IF;

	v_data = concat ('{"data":{"parameters":{"grafClass":"',v_class,'", "exploitation": [',v_expl,'], "updateFeature":"TRUE",
	"updateMapZone":',v_updatemapzone,', "geomParamUpdate":',v_paramupdate, ',"floodFromNode":"',v_floodfromnode,'", "forceOpen": [',v_forceopen,'], "forceClosed":[',v_forceclosed,'], "usePlanPsector": ',v_usepsector,', "debug":"FALSE"}}}');

	RETURN gw_fct_grafanalytics_mapzones(v_data);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;