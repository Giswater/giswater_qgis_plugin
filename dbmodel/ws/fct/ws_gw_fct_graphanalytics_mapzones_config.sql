/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2970

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_mapzones_config(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_mapzones_config(p_data json)
RETURNS json
AS $BODY$

/*

SELECT SCHEMA_NAME.gw_fct_graphanalytics_mapzones_config($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"parameters":{"graphClass":"PRESSZONE" }}}$$);


Mains:
1) This function works with ve_arc and ve_node. WARNING with selectors of state, exploitation and psector
2) Main issue is that takes header from mapconfig. If it is a false header we recommend to change the node_type
3) It takes value from arc_id two arcs from header in order to act after arcdivide

WARNING: Using this function config_form_fields is modified hidden mapzone_id and visibilize mapzone_name, also setting key of system variable 'utils_graphanalytics_status' as true

*/

DECLARE 
rec record;
v_mapzonefield text;
v_graph_class text;
v_graph_class_list text;
v_mapzone_nodetype record;
v_arc_layers text;
v_arc_id1 text;
v_arc_1_mapzone text;
v_arc_id2 text;
v_arc_2_mapzone text;
v_next_arc_id text;
v_node_mapzoneval text;
v_cat_feature_arc text;
v_final_node_id text;
v_json text;
v_version text;


v_result text;
v_result_info text;
v_result_point text;
v_result_line text;
v_result_polygon text;
v_error_context text;
v_audit_result text;
v_level integer;
v_status text;
v_message text;
v_flag boolean = false;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	v_graph_class = (((p_data ->>'data')::json->>'parameters')::json->>'graphClass')::text;

	IF v_graph_class = 'PRESSZONE' THEN
		v_graph_class_list = '(''PRESSZONE'', ''SECTOR'')';
		v_mapzonefield = 'presszone_id';
	ELSIF v_graph_class = 'DMA' THEN
		v_graph_class_list = '(''DMA'', ''SECTOR'')';
		v_mapzonefield = 'dma_id';
	ELSIF v_graph_class = 'SECTOR' THEN 
		v_graph_class_list =  '(''SECTOR'')';
		v_mapzonefield = 'sector_id';
	END IF;
	
	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Configure system to work with dynamic mapzone
	
	/*
	-- put hidden mapzone_id name
	EXECUTE 'UPDATE config_form_fields SET hidden = true WHERE columnname = '''||lower(v_graph_class)||'_id'' and (formname like ''%_node%'' or formname like ''%_arc%'' or formname like ''%_connec%'')';
	-- put visible mapzone_name field
	EXECUTE 'UPDATE config_form_fields SET hidden = false WHERE columnname = '''||lower(v_graph_class)||'_name'' and (formname like ''%_node%'' or formname like ''%_arc%'' or formname like ''%_connec%'')';
	-- set system variable
	EXECUTE 'UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json,'''||upper(v_graph_class)||''',''true''::boolean) WHERE parameter = ''utils_graphanalytics_status''';
	*/

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=249 AND cur_user=current_user;

	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 4, 'CONFIGURE MAPZONES');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 1, '-------');

	--find delimiter node types
	EXECUTE 'SELECT string_agg(quote_literal(id), '','') FROM cat_feature_node WHERE graph_delimiter IN '||v_graph_class_list||''
	INTO v_mapzone_nodetype;
	
	INSERT INTO audit_check_data (fid,  criticity, error_message)
	VALUES (249, 1, concat('Delimitier node type: ', v_mapzone_nodetype,'.'));


	FOR rec IN EXECUTE '(SELECT node_id::text, expl_id FROM ve_node WHERE node_type IN (SELECT id FROM cat_feature_node WHERE graph_delimiter IN '||v_graph_class_list||'))' 
	LOOP	
		--find defined sector value of node
		EXECUTE 'SELECT '||v_mapzonefield||' FROM node WHERE node_id = '||rec.node_id||'::text'
		INTO v_node_mapzoneval;

		IF v_node_mapzoneval IS NOT NULL THEN 

			--check first direction
			IF v_node_mapzoneval IS NOT NULL AND v_node_mapzoneval != '' THEN
			
				EXECUTE 'SELECT arc_id FROM ve_arc WHERE node_1 = '||rec.node_id||'::text 
				AND '||v_mapzonefield||'::text = '||quote_literal(v_node_mapzoneval)||'::text'
				into v_arc_id1;
				
			ELSIF v_node_mapzoneval = '' THEN 
				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (249, 2, concat('There is no mapzone defined for delimiter: ', rec.node_id,'.'));
				
			END IF;	

			IF v_arc_id1 IS NOT NULL THEN
			
				--find final node of the first arc
				EXECUTE 'SELECT node_2 FROM ve_arc WHERE arc_id ='||v_arc_id1||'::text'
				INTO v_final_node_id;
				
				--find arc_id of the next arc (it is mandatory to search next arc looking for case when header is done by arcdivide process where both arcs (up and down will has the same mapzone)
				EXECUTE 'SELECT arc_id FROM ve_arc WHERE node_1 ='||v_final_node_id||'::text OR node_2 ='||v_final_node_id||'::text
				AND arc_id != '''||v_arc_id1||''''
				INTO v_next_arc_id;

				IF v_next_arc_id IS NOT NULL THEN
				
					--find mapzone value of the next arc
					EXECUTE 'SELECT '||v_mapzonefield||' FROM arc WHERE arc_id = '||v_next_arc_id||'::text'
					INTO v_arc_1_mapzone;

					--configure mapzone if next arc mapzone is the same as delimiter mapzone
					IF v_node_mapzoneval = v_arc_1_mapzone THEN
						v_json = concat('{"use":[{"nodeParent":"',rec.node_id,'", "toArc":[',v_arc_id1,']}], "ignore":[]}'); 

						EXECUTE 'UPDATE '||v_graph_class||' SET graphconfig= '''||v_json||''' 
						WHERE '||v_graph_class||'_id::text = '||quote_literal(v_node_mapzoneval)||'::text;';
						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (249, 1, concat('Configuration done for mapzone: ', v_node_mapzoneval,'.'));

						v_flag = true;
					END IF;
				END IF;
			END IF;

			--check second direction
			IF v_flag IS NOT TRUE THEN
			
				v_flag = FALSE;

				EXECUTE 'SELECT arc_id FROM ve_arc WHERE node_2 = '||rec.node_id||'::text 
				AND '||v_mapzonefield||'::text = '||quote_literal(v_node_mapzoneval)||'::text'
				into v_arc_id2;

				IF v_arc_id2 IS NOT NULL THEN
			
					--find final node of the first arc
					EXECUTE 'SELECT node_1 FROM ve_arc WHERE arc_id ='||v_arc_id2||'::text'
					INTO v_final_node_id;		
					
					--find arc_id of the next arc (it is mandatory to search next arc looking for case when header is done by arcdivide process where both arcs (up and down will has the same mapzone)
					EXECUTE 'SELECT arc_id FROM ve_arc WHERE node_1 ='||v_final_node_id||'::text OR node_2 ='||v_final_node_id||'::text
					AND arc_id != '''||v_arc_id2||''''
					INTO v_next_arc_id;

					IF v_next_arc_id IS NOT NULL THEN
					
						--find mapzone value of the next arc
						EXECUTE 'SELECT '||v_mapzonefield||' FROM arc WHERE arc_id = '||v_next_arc_id||'::text'
						INTO v_arc_2_mapzone;

						--configure mapzone if next arc mapzone is the same as delimiter mapzone
						IF v_node_mapzoneval = v_arc_2_mapzone THEN
							v_json = concat('{"use":[{"nodeParent":"',rec.node_id,'", "toArc":[',v_arc_id2,']}], "ignore":[]}'); 

							EXECUTE 'UPDATE '||v_graph_class||' SET graphconfig= '''||v_json||''' 
							WHERE '||v_graph_class||'_id::text = '||quote_literal(v_node_mapzoneval)||'::text;';
							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (249, 1, concat('Configuration done for mapzone: ', v_node_mapzoneval,'.'));
						END IF;
					END IF;
				END IF;
			END IF;

			v_arc_id1 = null;
			v_arc_id2 = null;
			v_flag = null;
		END IF;
	END LOOP;

	FOR rec IN  EXECUTE 'SELECT '||v_graph_class||'_id as undone_mapzone_id, name as undone_mapzone_name 
	FROM ve_'||v_graph_class||' WHERE graphconfig IS NULL AND '||v_graph_class||'_id NOT IN (''0'', ''-1'');'
	LOOP
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (249, 2, concat('Mapzone not configured for header: ', rec.undone_mapzone_id,'. Closest arcs do not have good values.'));
	END LOOP;

	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 1, '');
	

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT * FROM (SELECT DISTINCT ON (error_message, criticity) id, criticity, error_message as message FROM audit_check_data 
	WHERE cur_user="current_user"() AND fid=249 GROUP BY id, message)b
	ORDER BY criticity desc, id asc) row;

	EXECUTE 'UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json,'||quote_literal(v_graph_class)||', true) WHERE parameter = ''utils_graphanalytics_status''';
	
	IF v_audit_result is null THEN
		v_status = 'Accepted';
		v_level = 3;
		v_message = 'Mapzone config done successfully';
	ELSE
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;
	END IF;

	v_result_info := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"values":',v_result_info, '}');

	v_status := COALESCE(v_status, '{}'); 
	v_level := COALESCE(v_level, '0'); 
	v_message := COALESCE(v_message, '{}'); 

	v_result_point = '{}';
	v_result_line = '{}';
	v_result_polygon = '{}';

    	--  Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json, 2970, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
