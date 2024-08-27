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
v_arclist json;
v_count integer;
v_node_id text;
v_selection_mode text;
v_id text;
v_querytext TEXT;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data   
	v_expl :=  ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';
	v_buffer := ((p_data ->>'data')::json->>'parameters')::json->>'nodeTolerance';
	v_insertnode := ((p_data ->>'data')::json->>'parameters')::json->>'insertIntoNode';

	v_workcat := ((p_data ->>'data')::json->>'parameters')::json->>'workcatId'::text;
	v_state_type := ((p_data ->>'data')::json->>'parameters')::json->>'stateType'::text;
	v_builtdate := ((p_data ->>'data')::json->>'parameters')::json->>'builtdate'::text;
	v_nodetype_id := ((p_data ->>'data')::json->>'parameters')::json->>'nodeType'::text;
	v_nodecat_id := ((p_data ->>'data')::json->>'parameters')::json->>'nodeCat'::text;
	v_selection_mode := (p_data ->>'data')::json->>'selectionMode'::text;
	v_id := (p_data ->>'feature')::json->>'id'::text;

	

	select replace(replace(replace(v_id, '[', ''), ']', ''), '"', '''') into v_id;

	if v_selection_mode = 'previousSelection' then

		v_querytext = ' AND arc_id in ('||v_id||')';

	else
	
		v_querytext = '';
		
	end if;


	select state into v_state from value_state_type where id=v_state_type;
	
	--  Reset values
	DELETE FROM temp_table WHERE cur_user=current_user AND fid = 116;
	DELETE FROM anl_node WHERE cur_user=current_user AND fid = 116;
	DELETE FROM audit_check_data WHERE cur_user=current_user AND fid = 116;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (116, null, 4, concat('BUILT MISSING NODES USING START/END VERTICES'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (116, null, 4, '-------------------------------------------------------------');

	-- inserting all extrem nodes on temp_node
	INSERT INTO temp_table (fid, text_column, geom_point)
	SELECT 	116, arc_id, ST_StartPoint(the_geom) AS the_geom FROM v_edit_arc WHERE expl_id=v_expl and (state=1 or state=2)
	UNION 
	SELECT 	116, arc_id, ST_EndPoint(the_geom) AS the_geom FROM v_edit_arc WHERE expl_id=v_expl and (state=1 or state=2);

		
	-- inserting into node table
	if v_insertnode then
	
		INSERT INTO v_edit_node (expl_id, workcat_id, state, state_type, builtdate, node_type, the_geom, nodecat_id, annotation) 
		select distinct v_expl, v_workcat, v_state, v_state_type, v_builtdate, v_nodetype_id, t.geom_point, v_nodecat_id, 'flag_gw_nodefromarc'
		from temp_table t, node n 
		where t.cur_user = current_user and t.fid = 116 and not st_dwithin(t.geom_point, n.the_geom, v_buffer);

		INSERT INTO anl_node (node_id, the_geom, state, fid, expl_id, nodecat_id) 
		select node_id, the_geom, state, 116, expl_id, nodecat_id 
		from node where annotation = 'flag_gw_nodefromarc';

	end if;

	-- repair arcs
	IF v_insertnode THEN
	
		-- set isarcdivide of chosed nodetype on falsea
		SELECT isarcdivide INTO v_isarcdivide FROM cat_feature_node WHERE id=v_nodetype_id;
		UPDATE cat_feature_node SET isarcdivide=FALSE WHERE id=v_nodetype_id;	

		EXECUTE 'SELECT distinct array_to_json(array_agg(arc_id::text)) 
		FROM arc where node_1 in (select node_id from node where annotation = ''flag_gw_nodefromarc'') 
		or node_2 in (select node_id from node where annotation = ''flag_gw_nodefromarc'')
		' INTO v_arclist;

		-- execute function
		EXECUTE 'SELECT gw_fct_arc_repair($${"client":{"device":4, "infoType":1,"lang":"ES"},"feature":{"id":'||v_arclist||'},
		"data":{}}$$);';

		-- restore isarcdivide to previous value
		UPDATE cat_feature_node SET isarcdivide=v_isarcdivide WHERE id=v_nodetype_id;	
		
	END IF;	

	update node set annotation = null where annotation = 'flag_gw_nodefromarc';

	-- get log
	SELECT count(*) INTO v_count FROM anl_node WHERE cur_user=current_user AND fid=116;

	IF v_count=0 THEN
		INSERT INTO audit_check_data(fid,  error_message, fcount)
		VALUES (116,  'There are no nodes to be repaired.', 0);
	ELSE
			INSERT INTO audit_check_data(fid,  error_message, fcount)
			VALUES (116,  concat (v_count,' nodes have been created to repair topology'), v_count);

			INSERT INTO audit_check_data(fid,  error_message, fcount)
			SELECT 116,  concat ('Node_id: ',string_agg(node_id, ', '), '.' ), v_count 
			FROM anl_node WHERE cur_user=current_user AND fid=116;
	END IF;
	
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid = 116) row;
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
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||	
				'"point":'||v_result_point||'}}'||
	    '}')::json, 2118, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 