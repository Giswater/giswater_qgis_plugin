/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2970

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_mapzones_config(p_data json)
RETURNS json
AS $BODY$

/*

SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones_config($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"parameters":{"grafClass":"PRESSZONE" }}}$$);


Mains:
1) This function works with v_edit_arc and v_edit_node. WARNING with selectors of state, exploitation and psector
2) Main issue is that takes header from mapconfig. If it is a false header we recommend to change the node_type
3) It takes value from arc_id two arcs from header in order to act after arcdivide

WARNING: Using this function config_form_fields is modified hidden mapzone_id and visibilize mapzone_name, also setting key of system variable 'utils_grafanalytics_status' as true

*/

DECLARE 
rec record;
v_mapzonefield text;
v_graf_class text;
v_graf_class_list text;
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
v_hide_form boolean;
v_flag boolean = false;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	v_graf_class = (((p_data ->>'data')::json->>'parameters')::json->>'grafClass')::text;

	IF v_graf_class = 'PRESSZONE' THEN
		v_graf_class_list = '(''PRESSZONE'', ''SECTOR'')';
		v_mapzonefield = 'presszone_id';
	ELSIF v_graf_class = 'DMA' THEN
		v_graf_class_list = '(''DMA'', ''SECTOR'')';
		v_mapzonefield = 'dma_id';
	ELSIF v_graf_class = 'SECTOR' THEN 
		v_graf_class_list =  '(''SECTOR'')';
		v_mapzonefield = 'sector_id';
	END IF;
	
	-- select version
	SELECT giswater INTO v_version FROM sys_version order by 1 desc limit 1;

	-- Configure system to work with dynamic mapzone
	
	/*
	-- put hidden mapzone_id name
	EXECUTE 'UPDATE config_form_fields SET hidden = true WHERE columnname = '''||lower(v_graf_class)||'_id'' and (formname like ''%_node%'' or formname like ''%_arc%'' or formname like ''%_connec%'')';
	-- put visible mapzone_name field
	EXECUTE 'UPDATE config_form_fields SET hidden = false WHERE columnname = '''||lower(v_graf_class)||'_name'' and (formname like ''%_node%'' or formname like ''%_arc%'' or formname like ''%_connec%'')';
	-- set system variable
	EXECUTE 'UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json,'''||upper(v_graf_class)||''',''true''::boolean) WHERE parameter = ''utils_grafanalytics_status''';
	*/

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=249 AND cur_user=current_user;

	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 4, 'CONFIGURE MAPZONES');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, null, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, null, 1, '-------');

	--find delimiter node types
	EXECUTE 'SELECT string_agg(quote_literal(id), '','') FROM cat_feature_node WHERE graf_delimiter IN '||v_graf_class_list||''
	INTO v_mapzone_nodetype;
	
	INSERT INTO audit_check_data (fid,  criticity, error_message)
	VALUES (249, 1, concat('Delimitier node type: ', v_mapzone_nodetype,'.'));

	FOR rec IN EXECUTE '(SELECT node_id::text FROM v_edit_node WHERE nodetype_id IN (SELECT id FROM cat_feature_node WHERE graf_delimiter IN '||v_graf_class_list||'))' 
	LOOP	
		--find defined sector value of node
		EXECUTE 'SELECT '||v_mapzonefield||' FROM node WHERE node_id = '||rec.node_id||'::text'
		INTO v_node_mapzoneval;

		IF v_node_mapzoneval IS NOT NULL THEN 

			--check first direction
			IF v_node_mapzoneval IS NOT NULL AND v_node_mapzoneval != '' THEN
			
				EXECUTE 'SELECT arc_id FROM v_edit_arc WHERE node_1 = '||rec.node_id||'::text 
				AND '||v_mapzonefield||'::text = '||quote_literal(v_node_mapzoneval)||'::text'
				into v_arc_id1;
				
			ELSIF v_node_mapzoneval = '' THEN 
				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (249, 2, concat('There is no mapzone defined for delimiter: ', rec.node_id,'.'));
				
			END IF;	

			IF v_arc_id1 IS NOT NULL THEN
			
				--find final node of the first arc
				EXECUTE 'SELECT node_2 FROM v_edit_arc WHERE arc_id ='||v_arc_id1||'::text'
				INTO v_final_node_id;
				
				--find arc_id of the next arc (it is mandatory to search next arc looking for case when header is done by arcdivide process where both arcs (up and down will has the same mapzone)
				EXECUTE 'SELECT arc_id FROM v_edit_arc WHERE node_1 ='||v_final_node_id||'::text OR node_2 ='||v_final_node_id||'::text
				AND arc_id != '''||v_arc_id1||''''
				INTO v_next_arc_id;

				IF v_next_arc_id IS NOT NULL THEN
				
					--find mapzone value of the next arc
					EXECUTE 'SELECT '||v_mapzonefield||' FROM arc WHERE arc_id = '||v_next_arc_id||'::text'
					INTO v_arc_1_mapzone;

					--configure mapzone if next arc mapzone is the same as delimiter mapzone
					IF v_node_mapzoneval = v_arc_1_mapzone THEN
						v_json = concat('{"use":[{"nodeParent":"',rec.node_id,'", "toArc":[',v_arc_id1,']}], "ignore":[]}'); 

						EXECUTE 'UPDATE '||v_graf_class||' SET grafconfig= '''||v_json||''' 
						WHERE '||v_graf_class||'_id::text = '||quote_literal(v_node_mapzoneval)||'::text;';
						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (249, 1, concat('Configuration done for mapzone: ', v_node_mapzoneval,'.'));

						v_flag = true;
					END IF;
				END IF;
			END IF;

			--check second direction
			IF v_flag IS NOT TRUE THEN
			
				v_flag = FALSE;

				EXECUTE 'SELECT arc_id FROM v_edit_arc WHERE node_2 = '||rec.node_id||'::text 
				AND '||v_mapzonefield||'::text = '||quote_literal(v_node_mapzoneval)||'::text'
				into v_arc_id2;

				IF v_arc_id2 IS NOT NULL THEN
			
					--find final node of the first arc
					EXECUTE 'SELECT node_1 FROM v_edit_arc WHERE arc_id ='||v_arc_id2||'::text'
					INTO v_final_node_id;		
					
					--find arc_id of the next arc (it is mandatory to search next arc looking for case when header is done by arcdivide process where both arcs (up and down will has the same mapzone)
					EXECUTE 'SELECT arc_id FROM v_edit_arc WHERE node_1 ='||v_final_node_id||'::text OR node_2 ='||v_final_node_id||'::text
					AND arc_id != '''||v_arc_id2||''''
					INTO v_next_arc_id;

					IF v_next_arc_id IS NOT NULL THEN
					
						--find mapzone value of the next arc
						EXECUTE 'SELECT '||v_mapzonefield||' FROM arc WHERE arc_id = '||v_next_arc_id||'::text'
						INTO v_arc_2_mapzone;

						--configure mapzone if next arc mapzone is the same as delimiter mapzone
						IF v_node_mapzoneval = v_arc_2_mapzone THEN
							v_json = concat('{"use":[{"nodeParent":"',rec.node_id,'", "toArc":[',v_arc_id2,']}], "ignore":[]}'); 

							EXECUTE 'UPDATE '||v_graf_class||' SET grafconfig= '''||v_json||''' 
							WHERE '||v_graf_class||'_id::text = '||quote_literal(v_node_mapzoneval)||'::text;';
							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (249, 1, concat('Configuration done for mapzone: ', v_node_mapzoneval,'.'));
						END IF;
					END IF;
				END IF;
			END IF;

			RAISE NOTICE 'rec % v_next_arc_id  % arc1 % arc2 % flag %', rec, v_next_arc_id, v_arc_id1,v_arc_id2, v_flag;
			v_arc_id1 = null;
			v_arc_id2 = null;
			v_flag = null;
		END IF;
	END LOOP;

	FOR rec IN  EXECUTE 'SELECT '||v_graf_class||'_id as undone_mapzone_id, name as undone_mapzone_name 
	FROM v_edit_'||v_graf_class||' WHERE grafconfig IS NULL;'
	LOOP
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (249, 2, concat('Mapzone not configured for : ', rec.undone_mapzone_id,' - ',rec.undone_mapzone_name,'.'));
	END LOOP;

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data 
	WHERE cur_user="current_user"() AND fid=249 ORDER BY criticity desc, id asc) row;
	
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
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

	v_status := COALESCE(v_status, '{}'); 
	v_level := COALESCE(v_level, '0'); 
	v_message := COALESCE(v_message, '{}'); 
	v_hide_form := COALESCE(v_hide_form, true); 


	v_result_point = '{"geometryType":"", "features":[]}';
	v_result_line = '{"geometryType":"", "features":[]}';
	v_result_polygon = '{"geometryType":"", "features":[]}';

    	--  Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
				', "actions":{"hideForm":' || v_hide_form || '}'||
		       '}'||
	    '}')::json, 2970);

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

