/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3256

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_mapzones_plan(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_mapzones_plan(p_data json)
RETURNS json AS
$BODY$

/*
SELECT gw_fct_graphanalytics_mapzones_plan('{"data":{"parameters":{"graphClass":"SECTOR", "exploitation": "15",
"updateFeature":"TRUE", "updateMapZone":1, "debug":"FALSE"}}}');

SELECT gw_fct_graphanalytics_mapzones_plan('{"data":{"parameters":{"graphClass":"DMA", "exploitation": "1",
"updateFeature":"TRUE", "updateMapZone":3}}}');

SELECT gw_fct_graphanalytics_mapzones_plan('{"data":{"parameters":{"graphClass":"DQA", "exploitation": "2",
"updateFeature":"TRUE", "updateMapZone":0}}}');

*/

DECLARE

v_class text;
v_expl text;
v_updatemapzone integer;
v_data json;
v_paramupdate float;
v_floodfromnode text;
v_forceclosed text;
v_forceopen text;
v_usepsector text;
v_valuefordisconnected integer;
v_floodonlymapzone text;
v_commitchanges text;
v_netscenario text;
v_mapzones_version integer;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_updatemapzone = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_paramupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');
	v_forceclosed = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'forceClosed');
	v_forceopen = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'forceOpen');
	v_usepsector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePlanPsector');
	v_floodonlymapzone = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'floodOnlyMapzone');
	v_commitchanges = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges');
	v_netscenario = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'netscenario');


	-- control of null values
	IF v_paramupdate IS NULL THEN v_paramupdate = 5; END IF;
	IF v_floodfromnode IS NULL THEN v_floodfromnode = ''; END IF;
	IF v_forceclosed IS NULL THEN v_forceclosed = ''; END IF;
	IF v_forceopen IS NULL THEN v_forceopen = ''; END IF;
	IF v_usepsector IS NULL THEN v_usepsector = FALSE ; END IF;
	IF v_updatemapzone IS NULL THEN v_updatemapzone = 1; END IF;
	IF v_valuefordisconnected IS NULL THEN v_valuefordisconnected = 0; END IF;
	IF v_floodonlymapzone IS NULL THEN v_floodonlymapzone = ''; END IF;
	IF v_commitchanges IS NULL THEN v_commitchanges = TRUE ; END IF;
	IF v_netscenario IS NULL THEN v_netscenario = '' ; END IF;
	SELECT netscenario_type INTO v_class FROM plan_netscenario WHERE netscenario_id::text = v_netscenario::TEXT;

	SELECT (value::json->>'version')::int2 INTO v_mapzones_version FROM config_param_system WHERE parameter='mapzones_config';

	v_data = concat ('{"data":{"parameters":{"graphClass":"',v_class,'", "exploitation":"',v_expl,'", "updateFeature":"TRUE",
	"updateMapZone":',v_updatemapzone,', "geomParamUpdate":',v_paramupdate, ', "forceOpen": [',v_forceopen,'], "forceClosed":[',v_forceclosed,'], "usePlanPsector": ',v_usepsector,', "debug":"FALSE", 
	"valueForDisconnected":',v_valuefordisconnected,', "floodOnlyMapzone":"',v_floodonlymapzone,'", "commitChanges":',v_commitchanges,', "netscenario":"',v_netscenario,'"}}}');

	IF v_mapzones_version = 1 THEN
		RETURN gw_fct_graphanalytics_mapzones_v1(v_data::jsonb);
	ELSE
		RETURN gw_fct_graphanalytics_mapzones(v_data);
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
