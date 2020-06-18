/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2970



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_mapzones_config(p_data json)
  RETURNS json AS
$BODY$
/*


SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones_config($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"parameters":{"mapzoneAddfield":"c_sector", "grafClass":"DMA" }}}$$);


*/
DECLARE 
rec record;
v_mapzone_addfield text;
v_graf_class text;
v_mapzone_nodetype text;
v_arc_layers text;
v_arc_id1 text;
v_arc_1_mapzone text;
v_arc_id2 text;
v_arc_2_mapzone text;
v_next_arc_id text;
v_node_delimiter_mapzone text;
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


BEGIN

    SET search_path = "SCHEMA_NAME", public;

    v_mapzone_addfield = (((p_data ->>'data')::json->>'parameters')::json ->>'mapzoneAddfield')::text;
    v_graf_class = (((p_data ->>'data')::json->>'parameters')::json->>'grafClass')::text;

    -- select version
	SELECT giswater INTO v_version FROM sys_version order by 1 desc limit 1;


	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=249 AND cur_user=current_user;

	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 4, 'CONFIGURE MAPZONES');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (249, null, 4, '-------------------------------------------------------------');


    --find delimiter node types
    SELECT string_agg(quote_literal(id), ',') INTO v_mapzone_nodetype FROM node_type WHERE graf_delimiter = v_graf_class;

    INSERT INTO audit_check_data (fid,  criticity, error_message)
	VALUES (249, 1, concat('Delimitier node type: ', v_mapzone_nodetype,'.'));


    SELECT string_agg(child_layer, ','), string_agg(quote_literal(cat_feature.id), ',') INTO v_arc_layers, v_cat_feature_arc  
    FROM cat_feature JOIN man_addfields_parameter ON cat_feature.id = cat_feature_id
    WHERE feature_type = 'ARC' AND param_name =  v_mapzone_addfield;

    FOR rec IN (SELECT node_id::text FROM v_edit_node WHERE node_type IN 
    	(SELECT id FROM node_type WHERE graf_delimiter = v_graf_class)) LOOP
	
		--find defined sector value of node
		EXECUTE 'SELECT value_param FROM man_addfields_value 
		JOIN man_addfields_parameter on parameter_id = man_addfields_parameter.id
		WHERE feature_id = '||rec.node_id||'::text and param_name = '||quote_literal(v_mapzone_addfield)||''
		INTO v_node_delimiter_mapzone;

		--check first direction
		IF v_node_delimiter_mapzone IS NOT NULL AND v_node_delimiter_mapzone != '' THEN
		
			EXECUTE 'SELECT arc_id FROM '||v_arc_layers||' WHERE node_1 = '||rec.node_id||'::text 
			AND '||v_mapzone_addfield||' = '||v_node_delimiter_mapzone||'::text'
			into v_arc_id1;
			
			
		ELSIF v_node_delimiter_mapzone = '' THEN 
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (249, 1, concat('There is no mapzone defined for delimiter: ', rec.node_id,'.'));
		END IF;	

		IF v_arc_id1 IS NOT NULL THEN
			--find final node of the first arc
			EXECUTE 'SELECT node_2 FROM '||v_arc_layers||' WHERE arc_id ='||v_arc_id1||'::text'
			INTO v_final_node_id;
			
			--find arc_id of the next arc
			EXECUTE 'SELECT arc_id FROM '||v_arc_layers||' WHERE node_1 ='||v_final_node_id||'::text OR node_2 ='||v_final_node_id||'::text
			AND arc_id != '''||v_arc_id1||''''
			INTO v_next_arc_id;

			
			IF v_next_arc_id IS NOT NULL THEN
				--find mapzone value of the next arc
				EXECUTE 'SELECT value_param FROM man_addfields_value 
				JOIN man_addfields_parameter on parameter_id = man_addfields_parameter.id
				WHERE feature_id = '||v_next_arc_id||'::text and param_name = '||quote_literal(v_mapzone_addfield)||''
				INTO v_arc_1_mapzone;

				--configure mapzone if next arc mapzone is the same as delimiter mapzone
				IF v_node_delimiter_mapzone = v_arc_1_mapzone THEN
					v_json = concat('{"use":[{"nodeParent":"',rec.node_id,'", "toArc":[',v_arc_id1,']}], "ignore":[]}'); 

					EXECUTE 'UPDATE '||v_graf_class||' SET grafconfig= '''||v_json||''' 
					WHERE '||v_graf_class||'_id = '||v_node_delimiter_mapzone||';';
					INSERT INTO audit_check_data (fid,  criticity, error_message)
					VALUES (249, 1, concat('Configuration done for mapzone: ', v_node_delimiter_mapzone,'.'));

				END IF;
			END IF;
		END IF;

		IF (v_arc_id1 IS NULL OR v_node_delimiter_mapzone != v_arc_1_mapzone )AND v_node_delimiter_mapzone !=''THEN

			--check second direction direction
			EXECUTE 'SELECT arc_id FROM '||v_arc_layers||' WHERE node_2 = '||rec.node_id||'::text 
			AND '||v_mapzone_addfield||' = '||v_node_delimiter_mapzone||'::text'
			into v_arc_id2;

			IF v_arc_id2 IS NOT NULL THEN
				--find final node of the first arc
				EXECUTE 'SELECT node_1 FROM '||v_arc_layers||' WHERE arc_id ='||v_arc_id2||'::text'
				INTO v_final_node_id;

				--find arc_id of the next arc
				EXECUTE 'SELECT arc_id FROM '||v_arc_layers||' WHERE node_1 ='||v_final_node_id||'::text OR node_2 ='||v_final_node_id||'::text
				AND arc_id != '''||v_arc_id2||''''
				INTO v_next_arc_id;
			
				IF v_next_arc_id IS NOT NULL THEN
					--find mapzone value of the next arc
					EXECUTE 'SELECT value_param FROM man_addfields_value 
					JOIN man_addfields_parameter on parameter_id = man_addfields_parameter.id
					WHERE feature_id = '||v_next_arc_id||'::text and param_name = '||quote_literal(v_mapzone_addfield)||''
					INTO v_arc_2_mapzone;

					IF v_node_delimiter_mapzone = v_arc_2_mapzone THEN
						--configure mapzone if next arc mapzone is the same as delimiter mapzone
						v_json = concat('{"use":[{"nodeParent":"',rec.node_id,'", "toArc":[',v_arc_id2,']}], "ignore":[]}'); 

						EXECUTE 'UPDATE '||v_graf_class||' SET grafconfig= '''||v_json||''' 
						WHERE '||v_graf_class||'_id = '||v_node_delimiter_mapzone||';';

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (249, 1, concat('Configuration done for mapzone: ', v_node_delimiter_mapzone,'.'));

					END IF;
				END IF;
			END IF;
	END IF;
    END LOOP;

    FOR rec IN  EXECUTE 'SELECT '||v_graf_class||'_id as undone_mapzone_id, name as undone_mapzone_name 
    FROM v_edit_'||v_graf_class||' WHERE grafconfig IS NULL AND '||v_graf_class||'_id!= expl_id ;'
    LOOP
   
	    INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (249, 1, concat('Mapzone not configured for : ', rec.undone_mapzone_id,' - ',rec.undone_mapzone_name,'.'));
	END LOOp;

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
	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
		     	'"setVisibleLayers":[]'||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
				', "actions":{"hideForm":' || v_hide_form || '}'||
		       '}'||
	    '}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



