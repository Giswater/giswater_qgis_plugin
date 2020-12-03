/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2734

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_psector_duplicate(p_data json)
RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_psector_duplicate($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},"feature":{"type":"PSECTOR"},
"data":{"psector_id":"1","new_psector_name":"new_psector"}}$$);

-- fid: 153

*/

DECLARE

v_version text;
v_arc_id TEXT;
v_project_type text;
v_result_id text= 'duplicate psector';
v_result_info text;
v_result text;
v_connec_id text;
v_old_psector_id integer;
v_new_psector_id integer;
v_new_psector_name text;
v_field_id text;

rec record;
rec_type record;

v_insert_fields text;
v_type record;
v_connec_proximity json;
v_gully_proximity json;
v_sql text;
v_psector_vdefault text;
v_schemaname text;
v_feature_list text;
v_error_context text;
v_connecautolink text;
v_gullyautolink text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;
	-- get input parameters
	v_schemaname = 'SCHEMA_NAME';

	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version order by 1 desc limit 1;

	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
	INTO v_version;

	-- manage log (fid: 153)
	DELETE FROM audit_check_data WHERE fid=153 AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (153, v_result_id, concat('DUPLICATE PSECTOR'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (153, v_result_id, concat('------------------------------'));
		
	--capture current value and deactivate connec and gully proximity
	SELECT value::json into v_connec_proximity FROM config_param_system WHERE parameter='edit_connec_proximity';
	SELECT value::json into v_gully_proximity FROM config_param_system WHERE parameter='edit_gully_proximity';
	
	UPDATE  config_param_system SET value = gw_fct_json_object_set_key(v_connec_proximity::json, 'activated'::text, 'false'::text) WHERE parameter='edit_connec_proximity';
	UPDATE  config_param_system SET value = gw_fct_json_object_set_key(v_gully_proximity::json, 'activated'::text, 'false'::text) WHERE parameter='edit_gully_proximity';
	
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (153, v_result_id, concat('Deactivate topology control for connecs and gullies.' ));
	
	--capture current value and temporary deactivate automatic link creation
	SELECT value INTO v_connecautolink FROM config_param_user WHERE parameter='edit_connec_automatic_link' and cur_user=current_user;
	SELECT value INTO v_gullyautolink FROM config_param_user WHERE parameter='edit_gully_automatic_link' and cur_user=current_user;

	UPDATE config_param_user SET value=FALSE WHERE parameter='edit_connec_automatic_link' and cur_user=current_user;
	UPDATE config_param_user SET value=FALSE WHERE parameter='edit_gully_automatic_link' and cur_user=current_user;

	--capture input values
 	v_old_psector_id = ((p_data ->>'data')::json->>'psector_id')::text;
	v_new_psector_name = ((p_data ->>'data')::json->>'new_psector_name')::text;

	--copy psector definition, update plan selector and psector vdefault
 	INSERT INTO plan_psector (name, psector_type, descript, expl_id, priority, text1, text2, observ, rotation, scale, sector_id, atlas_id, gexpenses, 
 	vat, other, active, the_geom, enable_all, status, ext_code) SELECT v_new_psector_name, psector_type, descript, expl_id, priority, text1, text2, observ, rotation, scale, sector_id, atlas_id, gexpenses, 
 	vat, other, active, the_geom, enable_all, status, ext_code FROM plan_psector WHERE psector_id=v_old_psector_id RETURNING psector_id INTO v_new_psector_id;

 	INSERT INTO selector_plan_psector(psector_id,cur_user) VALUES (v_new_psector_id, current_user);
	
	INSERT INTO audit_check_data (fid, result_id, error_message)
	VALUES (153, v_result_id, concat('Copy psector ',v_old_psector_id,' as ',v_new_psector_name,'.' ));

	SELECT value INTO v_psector_vdefault FROM config_param_user where parameter = 'plan_psector_vdefault' and cur_user=current_user;
	
	IF v_psector_vdefault IS NULL THEN
		INSERT INTO config_param_user (parameter,value, cur_user) VALUES ('plan_psector_vdefault', v_new_psector_id, current_user);
	ELSE 
		UPDATE config_param_user SET value=v_new_psector_id, cur_user=current_user WHERE parameter='plan_psector_vdefault';
	END IF;
	
	INSERT INTO audit_check_data (fid, result_id, error_message)
	VALUES (153, v_result_id, concat('Set ',v_new_psector_name,' as current psector.' ));

	--copy arcs with state 0 inside plan_psector tables
	SELECT string_agg(arc_id,',') INTO v_feature_list FROM plan_psector_x_arc  WHERE psector_id=v_old_psector_id AND (state=0 OR (state=1 and doable = false));

	IF v_feature_list IS NOT NULL THEN
		INSERT INTO plan_psector_x_arc(arc_id, psector_id, state, doable, descript, addparam) 
		SELECT arc_id, v_new_psector_id, state, doable, descript, addparam FROM plan_psector_x_arc 
		WHERE psector_id=v_old_psector_id AND (state=0 OR (state=1 and doable = false));

		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (153, v_result_id, concat('Copied arcs with state 0: ', v_feature_list ));
	END IF;

	--copy nodes with state 0 inside plan_psector tables
	SELECT string_agg(node_id,',') INTO v_feature_list FROM plan_psector_x_node  WHERE psector_id=v_old_psector_id AND (state=0 OR (state=1 and doable = false));

	IF v_feature_list IS NOT NULL THEN
		INSERT INTO plan_psector_x_node(node_id, psector_id, state, doable, descript) 
		SELECT node_id, v_new_psector_id, state, doable, descript FROM plan_psector_x_node 
		WHERE psector_id=v_old_psector_id AND (state=0 OR (state=1 and doable = false));

		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (153, v_result_id, concat('Copied nodes with state 0: ', v_feature_list ));
	END IF;

	--copy connecs with state 0 inside plan_psector tables
	SELECT string_agg(connec_id,',') INTO v_feature_list FROM plan_psector_x_connec WHERE psector_id=v_old_psector_id AND (state=0 OR (state=1 and doable = false));

	IF v_feature_list IS NOT NULL THEN
		INSERT INTO plan_psector_x_connec(connec_id, psector_id, state, doable, descript,link_geom, vnode_geom) 
		SELECT connec_id, v_new_psector_id, state, doable, descript,link_geom, vnode_geom FROM plan_psector_x_connec 
		WHERE psector_id=v_old_psector_id AND (state=0 OR (state=1 and doable = false));

		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (153, v_result_id, concat('Copied connecs with state 0: ', v_feature_list ));
	END IF;

	--copy gullies with state 0 inside plan_psector tables
	IF v_project_type='UD' THEN
		SELECT string_agg(gully_id,',') INTO v_feature_list FROM plan_psector_x_gully WHERE psector_id=v_old_psector_id AND (state=0 OR (state=1 and doable = false));
		IF v_feature_list IS NOT NULL THEN
			INSERT INTO plan_psector_x_gully(gully_id, psector_id, state, doable, descript,link_geom, vnode_geom) 
			SELECT gully_id, v_new_psector_id, state, doable, descript,link_geom, vnode_geom FROM plan_psector_x_gully 
			WHERE psector_id=v_old_psector_id AND (state=0 OR (state=1 and doable = false));
	
			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (153, v_result_id, concat('Copied gullies with state 0: ', v_feature_list ));
		END IF;
	END IF;
	--copy featothers inside plan_psector tables
	SELECT string_agg(price_id,',') INTO v_feature_list FROM plan_psector_x_other WHERE psector_id=v_old_psector_id;	
	IF v_feature_list IS NOT NULL THEN
		INSERT INTO plan_psector_x_other(price_id, measurement, psector_id, descript)
		SELECT  price_id, measurement, psector_id, descript FROM plan_psector_x_other WHERE psector_id=v_old_psector_id;
		
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (153, v_result_id, concat('Copied other prices: ', v_feature_list ));
	END IF;

	--insert copy of the planified feature in the corresponding v_edit_* view and insert it into plan_psector_x_* table
	FOR rec_type IN (SELECT * FROM sys_feature_type WHERE classlevel=1 OR classlevel = 2 ORDER BY CASE
		WHEN id='NODE' THEN 1 
		WHEN id='ARC' THEN 2
		WHEN id='CONNEC' THEN 3 
		WHEN id='GULLY' THEN 4 END) LOOP

		EXECUTE 'SELECT DISTINCT string_agg(column_name::text,'' ,'')
		FROM information_schema.columns where table_name=''v_edit_'||lower(rec_type.id)||''' and table_schema='''||v_schemaname||'''
		and column_name IN (SELECT column_name FROM information_schema.columns where table_name='''||lower(rec_type.id)||''' and table_schema='''||v_schemaname||''') 
		AND column_name!='''||lower(rec_type.id)||'_id'' and column_name!=''state'' and column_name != ''node_1'' and  column_name != ''node_2'';'
		INTO v_insert_fields;

		FOR rec IN EXECUTE 'SELECT * FROM plan_psector_x_'||lower(rec_type.id)||' WHERE psector_id='||v_old_psector_id||' and state=1 AND doable = true' LOOP
			IF rec_type.id='ARC' THEN
				v_field_id=rec.arc_id;
			ELSIF rec_type.id='NODE' THEN
				v_field_id=rec.node_id;
			ELSIF rec_type.id='CONNEC' THEN
				v_field_id=rec.connec_id;
			ELSIF rec_type.id='GULLY' THEN
				v_field_id=rec.gully_id;
			END IF;

			--activate topocontrol for arc, deactivate for other features 
			if rec_type.id='arc' THEN
				UPDATE config_param_system SET value ='FALSE' WHERE parameter='edit_topocontrol_disable_error';
			ELSE
				UPDATE config_param_system SET value ='TRUE' WHERE parameter='edit_topocontrol_disable_error';
			END IF;
			
			EXECUTE 'INSERT INTO v_edit_'||lower(rec_type.id)||' ('||v_insert_fields||',state) SELECT '||v_insert_fields||',2 FROM '||lower(rec_type.id)||'
			WHERE '||lower(rec_type.id)||'_id='''||v_field_id||''';';
			
		END LOOP;

		EXECUTE 'SELECT string_agg('||lower(rec_type.id)||'_id,'','') FROM plan_psector_x_'||lower(rec_type.id)||' WHERE psector_id='||v_old_psector_id||' and state=1'
		into v_feature_list;
		
		IF v_feature_list IS NOT NULL THEN
			INSERT INTO audit_check_data (fid, result_id, error_message)
			VALUES (153, v_result_id, concat('New ',lower(rec_type.id),' inserted with state 1: ', v_feature_list));
		END IF;

	END LOOP;
	
	--activate the functions an set back the values of parameters
	UPDATE config_param_user SET value=v_connecautolink WHERE parameter='edit_connec_automatic_link' and cur_user=current_user;
	UPDATE config_param_user SET value=v_gullyautolink WHERE parameter='edit_gully_automatic_link' and cur_user=current_user;
	
	UPDATE config_param_system SET value = v_connec_proximity WHERE parameter='edit_connec_proximity';
	UPDATE config_param_system SET value = v_gully_proximity WHERE parameter='edit_gully_proximity';
	UPDATE config_param_system SET value ='FALSE' WHERE parameter='edit_topocontrol_disable_error';

	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (153, v_result_id, concat('Activate topology control.'));
	
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid=153) row;

	-- Control nulls
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_version := COALESCE(v_version, '[]');

	-- return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "version":'||v_version||
            ',"message":{"level":1, "text":""},"body":{"data": {"info":'||v_result_info||'}}}')::json, 2734);

	-- manage exceptions
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


