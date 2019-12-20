/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2734

--DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_duplicate_psector(json);


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_duplicate_psector(p_data json)
RETURNS json AS
/*
SELECT SCHEMA_NAME.gw_fct_duplicate_psector($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},"feature":{"type":"PSECTOR"},
"data":{"psector_id":"1","new_psector_name":"new_psector"}}$$);

*/

$BODY$
DECLARE
api_version json;
v_arc_id TEXT;
v_project_type text;
v_version text;
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
v_connect2network text;
v_psector_vdefault text;
v_schemaname text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;
	-- get input parameters
	v_schemaname = 'SCHEMA_NAME';

	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1;

	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
	INTO api_version;

	-- manage log (fprocesscat = 51)
	DELETE FROM audit_check_data WHERE fprocesscat_id=53 AND user_name=current_user;
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (53, v_result_id, concat('DUPLICATE PSECTOR'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (53, v_result_id, concat('------------------------------'));
		
	--capture current value and deactivate connec and gully proximity
	SELECT value::json into v_connec_proximity FROM config_param_system WHERE parameter='connec_proximity';
	SELECT value::json into v_gully_proximity FROM config_param_system WHERE parameter='gully_proximity';
	
	UPDATE  config_param_system SET value = gw_fct_json_object_set_key(v_connec_proximity::json, 'activated'::text, 'false'::text) WHERE parameter='connec_proximity';
	UPDATE  config_param_system SET value = gw_fct_json_object_set_key(v_gully_proximity::json, 'activated'::text, 'false'::text) WHERE parameter='gully_proximity';
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (53, v_result_id, concat('Deactivate topology control -> Done' ));
	
	--capture current value and deactivate automatic link creation
	SELECT value INTO v_connect2network FROM config_param_user WHERE parameter='edit_connect_force_automatic_connect2network' and cur_user=current_user;
	
	IF v_connect2network is not null then
		update config_param_user SET value=FALSE WHERE parameter='edit_connect_force_automatic_connect2network' and cur_user=current_user;
	else 
		INSERT INTO config_param_user (parameter,value, cur_user) VALUES ('"edit_connect_force_automatic_connect2network"', FALSE, current_user);
	END IF;
	
	--capture input values
 	v_old_psector_id = ((p_data ->>'data')::json->>'psector_id')::text;
	v_new_psector_name = ((p_data ->>'data')::json->>'new_psector_name')::text;

	--copy psector definition, update plan selector and psector vdefault
 	INSERT INTO plan_psector (name, psector_type, descript, expl_id, priority, text1, text2, observ, rotation, scale, sector_id, atlas_id, gexpenses, 
 	vat, other, active, the_geom, enable_all, status, ext_code) SELECT v_new_psector_name, psector_type, descript, expl_id, priority, text1, text2, observ, rotation, scale, sector_id, atlas_id, gexpenses, 
 	vat, other, active, the_geom, enable_all, status, ext_code FROM plan_psector WHERE psector_id=v_old_psector_id RETURNING psector_id INTO v_new_psector_id;

 	INSERT INTO plan_psector_selector(psector_id,cur_user) VALUES (v_new_psector_id, current_user);
	
	SELECT value INTO v_psector_vdefault FROM config_param_user where parameter = 'psector_vdefault' and cur_user=current_user;
	
	IF v_psector_vdefault IS NULL THEN
		INSERT INTO config_param_user (parameter,value, cur_user) VALUES ('psector_vdefault', v_new_psector_id, current_user);
	ELSE 
		UPDATE config_param_user SET value=v_new_psector_id, cur_user=current_user WHERE parameter='psector_vdefault';
	END IF;
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
	VALUES (53, v_result_id, concat('Copy psector ',v_old_psector_id,' as ',v_new_psector_name,' -> Done' ));

	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) 
	VALUES (53, v_result_id, concat('Set ',v_new_psector_name,' as current psector -> Done' ));

	--copy features with state 0 inside plan_psector tables
	INSERT INTO plan_psector_x_arc(arc_id, psector_id, state, doable, descript) 
	SELECT arc_id, v_new_psector_id, state, doable, descript FROM plan_psector_x_arc WHERE psector_id=v_old_psector_id and state=0;

	INSERT INTO plan_psector_x_node(node_id, psector_id, state, doable, descript) 
	SELECT node_id, v_new_psector_id, state, doable, descript FROM plan_psector_x_node WHERE psector_id=v_old_psector_id and state=0;

	INSERT INTO plan_psector_x_connec(connec_id, psector_id, state, doable, descript,link_geom, vnode_geom) 
	SELECT connec_id, v_new_psector_id, state, doable, descript,link_geom, vnode_geom FROM plan_psector_x_connec WHERE psector_id=v_old_psector_id and state=0;
	
	INSERT INTO plan_psector_x_other(price_id, measurement, psector_id, descript)
	SELECT  price_id, measurement, psector_id, descript FROM plan_psector_x_other WHERE psector_id=v_old_psector_id;

	IF v_project_type='UD' THEN
		INSERT INTO plan_psector_x_gully(gully_id, psector_id, state, doable, descript,link_geom, vnode_geom) 
		SELECT gully_id, v_new_psector_id, state, doable, descript,link_geom, vnode_geom FROM plan_psector_x_gully WHERE psector_id=v_old_psector_id and state=0;
	END IF;

	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (53, v_result_id, concat('Copy features with state 0 -> Done' ));

	--insert copy of the planified feature in the corresponding v_edit_* view and insert it into plan_psector_x_* table
	FOR rec_type IN (SELECT * FROM sys_feature_type WHERE net_category=1 ORDER BY CASE 
		WHEN id='NODE' THEN 1 
		WHEN id='ARC' THEN 2
		WHEN id='CONNEC' THEN 3 
		WHEN id='GULLY' THEN 4 END) LOOP

		EXECUTE 'SELECT DISTINCT string_agg(column_name::text,'' ,'')
		FROM information_schema.columns where table_name=''v_edit_'||lower(rec_type.id)||''' and table_schema='''||v_schemaname||'''
		and column_name IN (SELECT column_name FROM information_schema.columns where table_name='''||lower(rec_type.id)||''' and table_schema='''||v_schemaname||''') 
		AND column_name!='''||lower(rec_type.id)||'_id'' and column_name!=''state'' and column_name != ''node_1'' and  column_name != ''node_2'';'
		INTO v_insert_fields;

		FOR rec IN EXECUTE 'SELECT * FROM plan_psector_x_'||lower(rec_type.id)||' WHERE psector_id='||v_old_psector_id||' and state=1' LOOP
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
				UPDATE config_param_system SET value ='FALSE' WHERE parameter='edit_topocontrol_dsbl_error';
			ELSE
				UPDATE config_param_system SET value ='TRUE' WHERE parameter='edit_topocontrol_dsbl_error';
			END IF;
			
			EXECUTE 'INSERT INTO v_edit_'||lower(rec_type.id)||' ('||v_insert_fields||',state) SELECT '||v_insert_fields||',2 FROM '||lower(rec_type.id)||'
			WHERE '||lower(rec_type.id)||'_id='''||v_field_id||''';';
			
				
		END LOOP;
	END LOOP;
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (53, v_result_id, concat('Copy features with state 1 -> Done' ));

	
	--activate the functions an set back the values of parameters
	IF v_connect2network is not null then
		update config_param_user SET value=v_connect2network WHERE parameter='edit_connect_force_automatic_connect2network' and cur_user=current_user;
	END IF;
	UPDATE config_param_system SET value = v_connec_proximity WHERE parameter='connec_proximity';     
	UPDATE config_param_system SET value = v_gully_proximity WHERE parameter='gully_proximity';     
	UPDATE config_param_system SET value ='FALSE' WHERE parameter='edit_topocontrol_dsbl_error';

	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (53, v_result_id, concat('Activate topology control -> Done' ));
	
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=53) row; 

	-- Control nulls
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	v_result_info := COALESCE(v_result_info, '{}'); 
	api_version := COALESCE(api_version, '[]');

RETURN ('{"status":"Accepted", "apiVersion":'||api_version||
            ',"message":{"priority":1, "text":""},"body":{"data": {"info":'||v_result_info||'}}}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


