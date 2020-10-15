/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2760

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_update_elevation_from_dem(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setelevfromdem(p_data json)
  RETURNS json AS
$BODY$
/*
SELECT gw_fct_setelevfromdem($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
"feature":{"tableName":"v_edit_connec", "featureType":"CONNEC", "id":["3235", "3239", "3197"]}, 
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"exploitation":"1", "updateValues":"allValues"}}}$$)::text

SELECT SCHEMA_NAME.gw_fct_setelevfromdem($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
"feature":{"tableName":"node", "featureType":"NODE"}, 
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"exploitation":"524", "updateValues":"allValues"}}}$$)::text

-- fid: 168

*/

DECLARE

v_schemaname text;
v_id json;
v_array text;
v_worklayer text;
v_updatevalues text;
v_saveondatabase boolean;
v_elevation numeric;
v_exploitation integer;
v_query text;
rec record;
v_geom text;
v_check_null_elevation record;
v_version text;
v_project_type text;
v_feature_type text;
v_result json;
v_result_info json;
v_result_point json;

BEGIN
	
	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version order by 1 desc limit 1;

		-- get input parameters
	v_schemaname = 'SCHEMA_NAME';

	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_feature_type := lower(((p_data ->>'feature')::json->>'featureType'))::text;
	v_updatevalues :=  ((p_data ->>'data')::json->>'parameters')::json->>'updateValues'::text;
	v_exploitation := ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	DELETE FROM selector_expl WHERE cur_user = current_user;
	INSERT INTO selector_expl VALUES (v_exploitation, current_user);
	
	--Execute the process only if admin_raster_dem is true
	IF (SELECT value FROM config_param_system WHERE parameter='admin_raster_dem') = 'TRUE' THEN
		
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=168;
		DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=168;
				
		--Select nodes on which the process will be executed - all values or only nulls from selected exploitation
		IF v_updatevalues = 'allValues' THEN 
			IF v_project_type = 'WS' and v_feature_type='vnode' THEN
				v_query = 'SELECT '||v_feature_type||'_id as feature_id, elev as elevation, the_geom, state FROM '||v_worklayer||' WHERE expl_id = '||v_exploitation||'';

			ELSIF v_project_type = 'WS' THEN
				v_query = 'SELECT '||v_feature_type||'_id as feature_id, elevation, the_geom, state FROM '||v_worklayer||' WHERE expl_id = '||v_exploitation||'';

			ELSE
				v_query = 'SELECT '||v_feature_type||'_id as feature_id, top_elev as elevation, the_geom, state FROM '||v_worklayer||' WHERE expl_id = '||v_exploitation||'';
			END IF;
			
			--Filter features if there are only some selected
			IF v_array IS NOT NULL  THEN
				v_query = CONCAT(v_query, ' AND '||v_feature_type||'_id in ('||v_array||')');
			END IF;

		ELSIF v_updatevalues = 'nullValues' THEN 
			IF v_project_type = 'WS' and v_feature_type='vnode' THEN
				v_query = 'SELECT '||v_feature_type||'_id as feature_id, elev as elevation, the_geom, state FROM '||v_worklayer||' WHERE elev IS NULL AND expl_id = '||v_exploitation||'';

			ELSIF v_project_type = 'WS' and v_feature_type!='vnode' THEN
				v_query = 'SELECT '||v_feature_type||'_id as feature_id, elevation, the_geom, state FROM '||v_worklayer||' WHERE elevation IS NULL AND expl_id = '||v_exploitation||'';

			ELSE
				v_query = 'SELECT '||v_feature_type||'_id as feature_id, top_elev as elevation, the_geom, state FROM '||v_worklayer||' WHERE top_elev IS NULL AND expl_id = '||v_exploitation||'';
			
			END IF;

			--Filter features if there are only some selected
			IF v_array IS NOT NULL  THEN
				v_query = CONCAT(v_query, ' AND '||v_feature_type||'_id in ('||v_array||')');
			END IF;

			--check if there are nodes with null values 
			EXECUTE v_query INTO v_check_null_elevation;

			IF v_check_null_elevation IS NUll THEN
				INSERT INTO audit_check_data(fid,result_id, error_message)
				VALUES (168,'elevation from raster','THERE ARE NO FEATURES WITH ELEVATION NULL');
			END IF;

		END IF;

		--loop over selected nodes, intersect node with raster
		FOR rec IN EXECUTE v_query LOOP

			EXECUTE 'SELECT ST_Value(rast,1,$1,true) FROM v_ext_raster_dem WHERE id =
					(SELECT id FROM v_ext_raster_dem WHERE st_dwithin (envelope, $1, 1) LIMIT 1)'
				USING rec.the_geom
				INTO v_elevation;

			raise notice 'elevation %', v_elevation;
			
			--if node is out of raster, add warning, if it's inside update value of node layer
			IF v_elevation = -9999 OR v_elevation IS NULL THEN
				INSERT INTO audit_check_data(fid,result_id, error_message)
				VALUES (168,'elevation from raster',concat('WARNING: SELECTED FEATURE IS OUT OF RASTER: ', rec.feature_id));
			ELSE
				IF v_project_type = 'WS' AND v_feature_type='vnode' THEN 
					EXECUTE 'UPDATE vnode SET elev = '||v_elevation||'::numeric WHERE vnode_id = '||rec.feature_id||';';
				ELSIF v_project_type = 'UD' AND v_feature_type='vnode' THEN 
					EXECUTE 'UPDATE vnode SET top_elev = '||v_elevation||'::numeric WHERE vnode_id = '||rec.feature_id||';';
				
				ELSIF v_project_type = 'WS' AND v_feature_type!='vnode'  THEN 
					EXECUTE 'UPDATE '||v_worklayer||' SET elevation = '||v_elevation||'::numeric WHERE '||v_feature_type||'_id = '||rec.feature_id||'::text';
				ELSIF v_project_type = 'UD' AND v_feature_type!='vnode' THEN
					EXECUTE 'UPDATE '||v_worklayer||' SET top_elev = '||v_elevation||' ::numeric WHERE '||v_feature_type||'_id = '||rec.feature_id||'::text';
				END IF;

				--temporal insert values into anl_node to create layer with all updated points
				INSERT INTO anl_node (node_id, state,   expl_id, fid, the_geom, descript)
				VALUES (rec.feature_id::text, rec.state::integer, v_exploitation, 168,rec.the_geom, upper(v_feature_type));

				INSERT INTO audit_check_data(fid,result_id, error_message)
				VALUES (168,'elevation from raster',concat('ELEVATION UPDATED - FEATURE TYPE:',upper(v_feature_type),', ID: ', rec.feature_id));
			END IF;
			
		END LOOP;

		-- get results
		-- info
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
		FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=168 order by id) row;
		v_result := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

		--points
		v_result = null;
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
		FROM (SELECT id, node_id AS feature_id, state, expl_id, descript, the_geom FROM anl_node WHERE cur_user="current_user"() AND fid=168) row;
		v_result := COALESCE(v_result, '{}'); 
		v_result_point = concat ('{"geometryType":"Point", "values":',v_result, '}');

		--    Control nulls
		v_result_info := COALESCE(v_result_info, '{}'); 
		v_result_point := COALESCE(v_result_point, '{}'); 

		--  Return
		RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"This is a test message"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||','||
					'"point":'||v_result_point||
				'}}'||
		    '}')::json,2760);

	END IF;
	RETURN null;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


