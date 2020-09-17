/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2784

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_insert_importdxf(p_data json)
RETURNS json AS
$BODY$

-- fid: 206

DECLARE 

v_incorrect_arc text[];
v_count integer;
v_errortext text;
v_start_point public.geometry(Point,SRID_VALUE);
v_end_point public.geometry(Point,SRID_VALUE);
v_query text;
v_result json;
v_result_info json;
v_result_point json;
v_result_polygon json;
v_result_line json;
v_missing_cat_node text;
v_missing_cat_arc text;

v_project_type text;
v_version text;
v_cat_feature text;
rec text;
v_error_context text;

v_topocontrol boolean;
v_workcat text;
v_state integer;
v_state_type integer;
v_builtdate date;
v_arc_type text;
v_node_type text;
v_current_psector text;


BEGIN 

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input data 	
	v_workcat := ((p_data ->>'data')::json->>'parameters')::json->>'workcat_id'::text;
	v_topocontrol := ((p_data ->>'data')::json->>'parameters')::json->>'topocontrol'::text;
	v_state_type := ((p_data ->>'data')::json->>'parameters')::json->>'state_type'::text;
	v_builtdate := ((p_data ->>'data')::json->>'parameters')::json->>'builtdate'::text;
	v_node_type := ((p_data ->>'data')::json->>'parameters')::json->>'node_type'::text;
	v_arc_type := ((p_data ->>'data')::json->>'parameters')::json->>'arc_type'::text;

	select state into v_state from value_state_type where id=v_state_type;

	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=206 AND cur_user=current_user;

	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 4, concat('IMPORT DXF'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 3, 'CRITICAL ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 3, '----------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 1, '-------');

	--insert missing catalogs
	IF v_project_type = 'WS' THEN
		--insert missing values of arc catalog 
		INSERT INTO cat_arc (id,arctype_id)
		SELECT DISTINCT (text_column::json)->>'Layer',v_arc_type FROM temp_table 
		WHERE fid=206 and geom_line IS NOT NULL AND (text_column::json)->>'Layer' not in (SELECT id FROM cat_arc);

		--insert missing values of node catalog 
		INSERT INTO cat_node(id,nodetype_id)
		SELECT DISTINCT (text_column::json)->>'Layer', v_node_type FROM temp_table 
		WHERE fid=206 and geom_point IS NOT NULL AND
		(text_column::json)->>'Layer' not in (SELECT id FROM cat_node);

	ELSIF v_project_type = 'UD' THEN
		INSERT INTO cat_arc (id)
		SELECT DISTINCT (text_column::json)->>'Layer' FROM temp_table 
		WHERE fid=206 and geom_line IS NOT NULL AND
		(text_column::json)->>'Layer' not in (SELECT id FROM cat_arc);

		INSERT INTO cat_node(id)
		SELECT DISTINCT (text_column::json)->>'Layer' FROM temp_table 
		WHERE fid=206 and geom_point IS NOT NULL AND
		(text_column::json)->>'Layer' not in (SELECT id FROM cat_node);
	END IF;

	INSERT INTO audit_check_data (fid,  criticity, error_message)
	VALUES (206, 2, concat('Insert missing values into cat_arc for arc_type ',v_arc_type,'.'));

	INSERT INTO audit_check_data (fid,  criticity, error_message)
	VALUES (206, 2, concat('Insert missing values into cat_node for node_type ',v_node_type,'.'));

	--inform about psector if elements are planified
	IF v_state = 2 THEN
		select name into v_current_psector from config_param_user  
		JOIN plan_psector on plan_psector.psector_id=config_param_user.value::integer
		where parameter='plan_psector_vdefault' and cur_user=current_user;

		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 2, concat('Features are assigned to psector: ',v_current_psector,'.'));
	END IF;

	--deactivate topocontrol
	ALTER TABLE arc DISABLE TRIGGER gw_trg_topocontrol_arc;

	--insert nodes from dxf
	IF v_project_type = 'WS' THEN	
		INSERT INTO v_edit_node (nodecat_id,state,state_type,the_geom, workcat_id, builtdate)
		SELECT (text_column::json)->>'Layer'::text, v_state, v_state_type, geom_point, v_workcat, v_builtdate
		FROM temp_table WHERE fid=206 and geom_point IS NOT NULL
		AND geom_point NOT IN (SELECT the_geom FROM anl_node WHERE fid=206 AND descript='DUPLICATED') ;

	ELSIF v_project_type = 'UD' THEN
		INSERT INTO v_edit_node (nodecat_id, node_type, state,state_type,the_geom, workcat_id, builtdate)
		SELECT (text_column::json)->>'Layer'::text, v_node_type, v_state, v_state_type, geom_point, v_workcat, v_builtdate
		FROM temp_table WHERE fid=206 and geom_point IS NOT NULL
		AND geom_point NOT IN (SELECT the_geom FROM anl_node WHERE fid=206 AND descript='DUPLICATED') ;
	END IF;

	INSERT INTO audit_check_data (fid,  criticity, error_message)
	VALUES (206, 1, 'INFO:Insert nodes from dxf.');

	--insert missing final nodes
	IF v_project_type = 'WS' THEN	
		INSERT INTO v_edit_node (nodecat_id,state,state_type,the_geom)
		SELECT nodecat_id, v_state, v_state_type, the_geom FROM anl_node 
		WHERE fid=206 AND descript='NEW';
	ELSIF v_project_type = 'UD' THEN
		INSERT INTO v_edit_node (nodecat_id,node_type,state,state_type,the_geom)
		SELECT nodecat_id,'DXF_JUN', v_state, v_state_type, the_geom FROM anl_node 
		WHERE fid=206 AND descript='NEW';
	END IF;

	INSERT INTO audit_check_data (fid,  criticity, error_message)
	VALUES (206, 1, 'INFO:Insert missing final nodes.');

	--insert arcs from dxf
	IF v_project_type = 'WS' THEN
		INSERT INTO v_edit_arc (arccat_id,state,state_type,the_geom, workcat_id, builtdate)
		SELECT DISTINCT ON (geom_line) (text_column::json)->>'Layer', v_state, v_state_type, geom_line, v_workcat, v_builtdate
		FROM temp_table WHERE fid=206 and geom_line IS NOT NULL;

	ELSIF v_project_type = 'UD' THEN
		INSERT INTO v_edit_arc (arccat_id,arc_type, state,state_type,the_geom, workcat_id, builtdate)
		SELECT DISTINCT ON (geom_line) (text_column::json)->>'Layer',v_arc_type, v_state, v_state_type, geom_line, v_workcat, v_builtdate
		FROM temp_table WHERE fid=206 and geom_line IS NOT NULL;
	END IF;

	INSERT INTO audit_check_data (fid,  criticity, error_message)
	VALUES (206, 1, 'INFO:Insert arcs from dxf.');

	--activate topocontrol
	IF v_topocontrol is true THEN
		ALTER TABLE arc ENABLE TRIGGER gw_trg_topocontrol_arc;
	END IF;

		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 2, 'Topocontrol is deactivated.');
	
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 1, concat('INFO: Features inserted with state: ',v_state,' and state type: ',v_state_type,'.'));	
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 1, concat('INFO: Features inserted with workcat_id: ',v_workcat,'.'));	
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 1, concat('INFO: Features inserted with builtdate: ',v_builtdate,'.'));	
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 1, concat('INFO: Nodes from dxf inserted with node_type: ',v_node_type,'.'));	
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 1, 'INFO: New nodes inserted with nodecat_id: DXF_JUN_CAT, node_type: DXF_JUN.');	
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 1, concat('INFO: Arcs from dxf inserted with arc_type: ',v_arc_type,'.'));

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data 
	WHERE cur_user="current_user"() AND fid=206 ORDER BY criticity desc, id asc) row;
	
	v_result_info := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

	--geometry
	v_result_line = '{"geometryType":"", "features":[]}';
	v_result_polygon = '{"geometryType":"", "features":[]}';
	v_result_point = '{"geometryType":"", "features":[]}';

	-- Return
    RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Insert import dxf done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json, 2784);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

