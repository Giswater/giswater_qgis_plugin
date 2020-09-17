/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2766

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_mapzones_basic(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_mapzones_basic(p_data json)
RETURNS json AS
$BODY$

/*

SELECT gw_fct_grafanalytics_mapzones_basic('{"data":{"parameters":{"grafClass":"SECTOR", "exploitation": "15", "updateFeature":"TRUE"}}}');

SELECT gw_fct_grafanalytics_mapzones_basic('{"data":{"parameters":{"grafClass":"DMA", "exploitation": "15", "updateFeature":"TRUE"}}}');

SELECT gw_fct_grafanalytics_mapzones_basic('{"data":{"parameters":{"grafClass":"DQA", "exploitation": "15", "updateFeature":"TRUE"}}}');

SELECT gw_fct_grafanalytics_mapzones_basic('{"data":{"parameters":{"grafClass":"PRESSZONE", "exploitation": "15", "updateFeature":"TRUE"}}}');

*/

DECLARE

v_class	text;
v_expl integer;
v_updatetattributes boolean;
v_data json;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	
	v_class = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'grafClass');
	v_updatetattributes = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateFeature');
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	
	v_data = concat ('{"data":{"parameters":{"grafClass":"',v_class,'", "exploitation": "[',v_expl,']", "updateFeature":"FALSE", "updateMapZone":"0", "debug":"FALSE"}}}');

	RETURN gw_fct_grafanalytics_mapzones(v_data);
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;