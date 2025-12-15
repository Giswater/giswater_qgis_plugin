/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3248


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_node_interpolate_massive(p_data json)
RETURNS json AS

$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_node_interpolate_massive ($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"parameters":{"queryFilter":"WHERE custom_top_elev IS NULL AND custom_elev IS NULL"}}}$$);

fid = 496

*/

DECLARE

p_x float;
p_y float;
p_node1 text;
p_node2 text;
v_version text;
v_project text;

v_node record;
v_node1 text;
v_node2 text;
v_x float;
v_y float;
v_querytext text;
v_queryfilter text;

v_result text;
v_result_info json;
v_result_point json;
v_result_polygon json;
v_result_line json;
v_result_fields text;
v_result_ymax text;
v_result_top text;
v_result_elev text;
v_error_context text;
v_fid integer = 496;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get system variables
	SELECT  giswater, upper(project_type) INTO v_version, v_project FROM sys_version order by id desc limit 1;
	v_queryfilter = ((p_data->>'data')::json->>'parameters')::json->>'queryFilter';

	v_querytext = 'SELECT * FROM ve_node '||v_queryfilter;

	DELETE FROM anl_node WHERE fid = v_fid and cur_user = current_user;

	FOR v_node IN EXECUTE v_querytext
	LOOP
		v_x = st_x(v_node.the_geom);
		v_y = st_y(v_node.the_geom);

		-- getting for node_1
		SELECT node_1 INTO v_node1 FROM ve_arc JOIN ve_node ON node_2 = node_id WHERE node_2 = v_node.node_id AND node_1 IS NOT NULL AND sys_elev IS NOT NULL
		AND sys_top_elev IS NOT NULL ORDER BY sys_elev asc limit 1;
		IF v_node1 IS NULL THEN
			SELECT node_1 INTO v_node1 FROM ve_arc JOIN ve_node ON node_2 = node_id WHERE node_2 = v_node.node_id AND node_1 IS NOT NULL ORDER BY sys_elev asc limit 1;
			IF v_node1 IS NOT NULL THEN
				SELECT node_1 INTO v_node1 FROM ve_arc JOIN ve_node ON node_2 = node_id WHERE node_2 = v_node1 AND node_1 IS NOT NULL AND sys_elev IS NOT NULL
				AND sys_top_elev IS NOT NULL ORDER BY sys_elev asc limit 1;
			END IF;
		END IF;

		-- getting for node_2
		SELECT node_2 INTO v_node2 FROM ve_arc JOIN ve_node ON node_1 = node_id WHERE node_1 = v_node.node_id AND node_2 IS NOT NULL ORDER BY sys_elev asc limit 1;
		IF v_node2 IS NULL THEN
			SELECT node_1 INTO v_node2  FROM ve_arc JOIN ve_node ON node_1 = node_id WHERE node_1 = v_node.node_id AND node_2 IS NOT NULL ORDER BY sys_elev asc limit 1;
			IF v_node2 IS NOT NULL THEN
				SELECT node_2 INTO v_node2 FROM ve_arc JOIN ve_node ON node_1 = node_id WHERE node_1 = v_node2 AND node_2 IS NOT NULL AND sys_elev IS NOT NULL
				AND sys_top_elev IS NOT NULL ORDER BY sys_elev asc limit 1;
			END IF;
		END IF;

		IF v_node1 IS NOT NULL AND v_node2 IS NOT NULL THEN
			v_querytext = 'SELECT gw_fct_node_interpolate (''{"data":{"parameters":{"action":"MASSIVE-INTERPOLATE", "x":'||v_x||', "y":'||v_y||', "node1":"'||v_node1||'", "node2":"'||v_node2||'"}}}'')';
			EXECUTE v_querytext;
		END IF;

		-- inserting log
		INSERT INTO anl_node (node_id, fid, the_geom, descript, cur_user) VALUES (v_node.node_id, v_fid, v_node.the_geom, 'Node massively interpolated', current_user);

	END LOOP;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by
	criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result,'}');

	--points
	v_result = null;
	SELECT jsonb_build_object(
	    'type', 'FeatureCollection',
	    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
	FROM (
	SELECT jsonb_build_object(
	'type',       'Feature',
	'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	'properties', to_jsonb(row) - 'the_geom'
	) AS feature
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript,fid, ST_Transform(the_geom, 4326) as the_geom
	FROM  anl_node WHERE cur_user="current_user"() AND fid=v_fid) row) features;

	v_result_point = v_result;

	-- Control NULL's
	v_version:=COALESCE(v_version,'{}');
	v_result_info:=COALESCE(v_result_info,'{}');
	v_result_point:=COALESCE(v_result_point,'{}');

	--return definition for v_audit_check_result
	RETURN  ('{"status":"Accepted", "message":{"level":1, "text":"Node interpolation done successfully"}, "version":"'||v_version||'"'||
		     ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||','||
					'"point":'||v_result_point||'}'||
			      '}}');

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
