/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
--FUNCTION CODE: 2312

--DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut_valve_unaccess(p_data);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_valve_unaccess(p_data json)

  RETURNS json AS
$BODY$

DECLARE

feature_id_aux integer;
feature_type_aux text;
v_flag boolean = false;
v_node_id integer;
v_result_id integer;
v_error_context text;
v_usepsectors boolean;

v_xcoord double precision;
v_ycoord double precision;
v_epsg integer;
v_client_epsg integer;
v_point public.geometry;

v_sensibility_f float;
v_sensibility float;
v_zoomratio float;
v_mincut_version integer;

BEGIN
	-- set search_path
    SET search_path= 'SCHEMA_NAME','public';

	-- get input parameters
	v_node_id := (p_data ->>'data')::json->>'nodeId';
	v_result_id := ((p_data ->>'data')::json->>'mincutId')::integer;
	v_usepsectors := ((p_data ->>'data')::json->>'usePsectors')::boolean;

	v_xcoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'xcoord';
	v_ycoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'ycoord';
	v_epsg := (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
	v_client_epsg := (p_data ->> 'client')::json->> 'epsg';
	v_zoomratio := ((p_data ->> 'data')::json->> 'coordinates')::json->>'zoomRatio';
	v_mincut_version := (SELECT value::json->>'version' FROM config_param_system WHERE parameter = 'om_mincut_config');

	IF v_client_epsg IS NULL THEN v_client_epsg = v_epsg; END IF;

	-- get node_id from coordinates
	IF v_node_id IS NULL AND v_xcoord IS NOT NULL THEN
		EXECUTE 'SELECT (value::json->>''web'')::float FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;
		v_sensibility = (v_zoomratio / 500 * v_sensibility_f);

		-- Make point
		SELECT ST_Transform(ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_client_epsg),v_epsg) INTO v_point;

		SELECT node_id INTO v_node_id FROM ve_node WHERE ST_DWithin(the_geom, v_point,v_sensibility) LIMIT 1;
	END IF;

	SELECT anl_feature_id INTO feature_id_aux FROM om_mincut WHERE id=v_result_id;
	SELECT anl_feature_type INTO feature_type_aux FROM om_mincut WHERE id=v_result_id;

	-- In case of variable valveStatusUnaccess on TRUE and valve closed status on TRUE) -> change status to open
	IF (SELECT json_extract_path_text(value::json,'valveStatusUnaccess')::boolean FROM config_param_system WHERE parameter='om_mincut_settings') IS TRUE AND (SELECT closed FROM man_valve WHERE node_id=v_node_id) IS TRUE THEN
		UPDATE man_valve SET closed=FALSE WHERE node_id=v_node_id;
		v_flag := true;

	-- The rest of cases. In case of closed valves without valveStatusUnaccess on true -> nothing
	ELSIF (SELECT closed FROM man_valve WHERE node_id=v_node_id) IS FALSE THEN

		-- Changing temporary status of accessibility
		IF (SELECT node_id FROM om_mincut_valve_unaccess WHERE node_id=v_node_id and result_id=v_result_id) IS NULL THEN
			INSERT INTO om_mincut_valve_unaccess (result_id, node_id) VALUES (v_result_id, v_node_id);
		ELSE
			DELETE FROM om_mincut_valve_unaccess WHERE result_id=v_result_id AND node_id=v_node_id;
		END IF;
	END IF;

	-- Recalculate the mincut
	IF v_mincut_version = 5 THEN
		PERFORM gw_fct_mincut_minsector(feature_id_aux, v_result_id, v_usepsectors);
	ELSE
		PERFORM gw_fct_mincut(feature_id_aux, 'arc'::text, v_result_id, v_usepsectors);
	END IF;

	-- In case of variable valveStatusUnaccess on TRUE and valve closed status on TRUE)
	IF v_flag IS TRUE THEN
		-- Modify result values
		INSERT INTO om_mincut_valve (result_id, node_id) VALUES (v_result_id, v_node_id) ON CONFLICT (result_id, node_id) DO NOTHING;
        UPDATE om_mincut_valve SET closed=TRUE, proposed=TRUE, broken=FALSE, unaccess=FALSE,
		the_geom=(SELECT the_geom FROM node WHERE node_id=v_node_id) WHERE node_id=v_node_id;

		--restore man_valve original values
		UPDATE man_valve SET closed=TRUE WHERE node_id=v_node_id;
	END IF;


	RETURN ('{"status":"Accepted", "message":{"level":3, "text":"Custom mincut executed successfully"}, "version":""'||
		',"body":{"form":{}'||
		',"data":{}'||
		'}}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

