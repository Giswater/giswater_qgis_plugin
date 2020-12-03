/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2118

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_built_nodefromarc();
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_built_nodefromarc(json);
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_node_builtfromarc(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setnodefromarc(p_data json) RETURNS json AS
$BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_setnodefromarc (2118)($${"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
"parameters":{"exploitation":"1", "inserIntoNode":"true", "nodeTolerance":"0.01", "saveOnDatabase":"true"}}}$$)::text

-- fid: 116
*/

DECLARE

rec_arc record;
rec_table record;

numnodes integer;
v_version text;
v_saveondatabase boolean = true;
v_result json;
v_result_info json;
v_result_point json;
v_node_proximity double precision;
v_buffer double precision;
v_nodetype text;
v_expl integer;
v_insertnode boolean;
v_projecttype text;
rec record;
v_nodecat text;
v_nodetype_id text;
v_isarcdivide boolean;

v_workcat text;
v_state integer;
v_state_type integer;
v_builtdate date;
v_nodecat_id text;

BEGIN

	-- Search path
	SET search_path = SCHEMA_NAME, public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version order by 1 desc limit 1;

	-- getting input data   
	v_expl :=  ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';
	v_buffer := ((p_data ->>'data')::json->>'parameters')::json->>'nodeTolerance';
	v_insertnode := ((p_data ->>'data')::json->>'parameters')::json->>'insertIntoNode';

	v_workcat := ((p_data ->>'data')::json->>'parameters')::json->>'workcatId'::text;
	v_state_type := ((p_data ->>'data')::json->>'parameters')::json->>'stateType'::text;
	v_builtdate := ((p_data ->>'data')::json->>'parameters')::json->>'builtdate'::text;
	v_nodetype_id := ((p_data ->>'data')::json->>'parameters')::json->>'nodeType'::text;
	v_nodecat_id := ((p_data ->>'data')::json->>'parameters')::json->>'nodeCat'::text;

	select state into v_state from value_state_type where id=v_state_type;
	
	--  Reset values
	DELETE FROM temp_table WHERE cur_user=current_user AND fid = 116;
	DELETE FROM anl_node WHERE cur_user=current_user AND fid = 116;

	-- inserting all extrem nodes on temp_node
	INSERT INTO temp_table (fid, geom_point)
	SELECT 	116, ST_StartPoint(the_geom) AS the_geom FROM arc WHERE expl_id=v_expl and (state=1 or state=2)
	UNION 
	SELECT 	116, ST_EndPoint(the_geom) AS the_geom FROM arc WHERE expl_id=v_expl and (state=1 or state=2);
		
	-- inserting into node table
	FOR rec_table IN SELECT * FROM temp_table WHERE cur_user=current_user AND fid = 116
	LOOP
	        -- Check existing nodes  
	        numNodes:= 0;
		numNodes:= (SELECT COUNT(*) FROM node WHERE st_dwithin(node.the_geom, rec_table.geom_point, v_buffer));
		IF numNodes = 0 THEN
			IF v_insertnode THEN
				INSERT INTO v_edit_node (expl_id, workcat_id, state, state_type, builtdate, node_type, the_geom, nodecat_id) 
				VALUES (v_expl, v_workcat, v_state, v_state_type, v_builtdate, v_nodetype_id, rec_table.geom_point, v_nodecat_id);

				INSERT INTO anl_node (the_geom, state, fid, expl_id, nodecat_id) 
				VALUES (rec_table.geom_point, v_state, 116, v_expl, v_nodecat_id);

			ELSE 
				INSERT INTO anl_node (the_geom, state, fid, expl_id, nodecat_id) 
				VALUES (rec_table.geom_point, v_state, 116,v_expl, v_nodecat_id);
			END IF;
		ELSE

		END IF;
	END LOOP;
		
	-- repair arcs
	IF v_insertnode THEN
	
		-- set isarcdivide of chosed nodetype on falsea
		SELECT isarcdivide INTO v_isarcdivide FROM cat_feature_node WHERE id=v_nodetype_id;
		UPDATE cat_feature_node SET isarcdivide=FALSE WHERE id=v_nodetype_id;	
	
		-- execute function
		EXECUTE 'SELECT gw_fct_arc_repair($${"client":{"device":4, "infoType":1,"lang":"ES"},"feature":{"id":
		"SELECT array_to_json(array_agg(arc_id::text)) FROM arc WHERE expl_id='||v_expl||' AND (node_1 IS NULL OR node_2 IS NULL)"},
		"data":{}}$$);';

		-- restore isarcdivide to previous value
		UPDATE cat_feature_node SET isarcdivide=v_isarcdivide WHERE id=v_nodetype_id;	
		
	END IF;	

	-- get log
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT * FROM audit_check_data WHERE cur_user="current_user"() AND fid = 116) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--points
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript,fid, the_geom
  	FROM  anl_node WHERE cur_user="current_user"() AND fid=116) row) features;

  	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}'); 

  	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=116;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fid=116 AND cur_user=current_user;
		INSERT INTO selector_audit (fid,cur_user) VALUES (116, current_user);
	END IF;
		
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"This is a test message"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||	
				'"point":'||v_result_point||'}}'||
	    '}')::json, 2118);
	
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
    RETURN ('{"status":"Failed","message":' || (to_json(SQLERRM)) || ', "version":'|| v_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
