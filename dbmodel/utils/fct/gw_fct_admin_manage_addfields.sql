/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2690

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_manage_addfields(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_addfields(p_data json)
  RETURNS json AS
$BODY$


/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PUMP"},
"data":{"action":"CREATE", "multi_create":"true", "parameters":{"columnname":"addfield_all", "datatype":"string", "widgettype":"text", "label":"addfield_all","ismandatory":"False",
"fieldLength":"50", "numDecimals" :null,"active":"True", "iseditable":"True","v_isenabled":"True"}}}$$);

SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{}, 
"feature":{"catFeature":"PUMP"}, 
"data":{"filterFields":{}, "pageInfo":{}, "action":"CREATE", "multi_create":false, 
"parameters":{"label": "pump1", "field_length": null, "addfield_active": true, "iseditable": true, "ismandatory": false, "formtype": "feature", 
"datatype": "boolean", "num_decimals": null, "columnname": "pump1", "isenabled": true, "widgettype": "check", "dv_isnullvalue": false,
"isautoupdate": false, "dv_parent_id": null, "tooltip": null, "dv_querytext": null, "widgetfunction": null, "placeholder": null, "reload_field": null, 
"isparent": false,  "listfilterparam": null, "editability": null, "dv_querytext_filterc": null, "linkedaction": null, 
"stylesheet": null, "widgetdim": null}}}$$)::text

	SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${"client":{"device":4, "infoType":1, "lang":"ES"},
	"form":{}, 
	"feature":{"catFeature":"PUMP"}, 
	"data":{"filterFields":{}, "pageInfo":{}, "action":"UPDATE", "multi_create":false, 
	"parameters":{"label": "pump111", "field_length": null, "addfield_active": true, "iseditable": true, "ismandatory": false, "formtype": "feature", 
	"datatype": "integer", "num_decimals": null, "columnname": "pump1", "isenabled": true, "widgettype": "text", "dv_isnullvalue": false,
	"isautoupdate": false, "dv_parent_id": null, "tooltip": null, "dv_querytext": null, "widgetfunction": null, "placeholder": null, "reload_field": null, 
	"isparent": false, "listfilterparam": null, "editability": null, "dv_querytext_filterc": null, "linkedaction": null, 
	"stylesheet": null, "widgetdim": null}}}$$)::text

SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${
"client":{"lang":"ES"}, 
"feature":{"catFeature":"PUMP"},
"data":{"action":"DELETE", "multi_create":"true", "parameters":{"columnname":"pump_test"}}}$$)

-- fid: 218

*/

DECLARE 

v_schemaname text;
v_cat_feature text;
v_viewname text;
v_definition text;
v_ismandatory boolean;
v_config_datatype text;
v_label text;
v_config_widgettype text;
v_param_name text;
v_feature_type text;
v_id integer;
v_old_parameters record;
v_new_parameters record;
v_active boolean;
v_orderby integer;
v_action text;
v_layoutorder integer;
v_feature_system_id text;
v_man_fields text;

rec record;

v_iseditable boolean;
v_add_datatype text;
v_view_type integer;
v_data_view json;

v_formtype text;
v_placeholder text;
v_tooltip text;
v_isparent boolean;
v_dv_parent_id text;
v_dv_querytext text;
v_dv_isnullvalue boolean;
v_stylesheet json;
v_multi_create boolean;
v_dv_querytext_filterc text;
v_widgetfunction text;
v_widgetdim integer;
v_isautoupdate boolean;
v_listfilterparam json;
v_linkedaction text;
v_update_old_datatype text;
v_project_type text;
v_param_user_id integer;
v_audit_datatype text;
v_audit_widgettype text;
v_active_feature text;
v_created_addfields record;
v_unaccent_id text;
v_hidden boolean;

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
v_version text;	
v_idaddparam integer;

BEGIN
	
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

 	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version LIMIT 1;

 	--set current process as users parameter
	DELETE FROM config_param_user  WHERE  parameter = 'utils_cur_trans' AND cur_user =current_user;

	INSERT INTO config_param_user (value, parameter, cur_user)
	VALUES (txid_current(),'utils_cur_trans',current_user );
    
	SELECT value::boolean INTO v_hide_form FROM config_param_user where parameter='qgis_form_log_hidden' AND cur_user=current_user;

	-- get input parameters -,man_addfields
	v_id = (SELECT nextval('SCHEMA_NAME.sys_addfields_id_seq') +1);

	v_param_name = (((p_data ->>'data')::json->>'parameters')::json->>'columnname')::text;
	v_cat_feature = ((p_data ->>'feature')::json->>'catFeature')::text;
	v_ismandatory = (((p_data ->>'data')::json->>'parameters')::json->>'ismandatory')::text;
	v_config_datatype = (((p_data ->>'data')::json->>'parameters')::json->>'datatype')::text;
	v_label = (((p_data ->>'data')::json->>'parameters')::json->>'label')::text;
	v_config_widgettype = (((p_data ->>'data')::json->>'parameters')::json->>'widgettype')::text;
	v_action = ((p_data ->>'data')::json->>'action')::text;
	v_active = (((p_data ->>'data')::json->>'parameters')::json->>'addfield_active')::text;
	v_iseditable = (((p_data ->>'data')::json->>'parameters')::json ->>'iseditable')::text;

	--set new addfield as active if it wasnt defined
	IF v_active IS NULL THEN
		v_active = TRUE;
	END IF;
	
	-- get input parameters - config_form_fields
	v_formtype = 'form_feature';
	v_placeholder = (((p_data ->>'data')::json->>'parameters')::json->>'placeholder')::text;
	v_tooltip = (((p_data ->>'data')::json->>'parameters')::json ->>'tooltip')::text;
	v_isparent = (((p_data ->>'data')::json->>'parameters')::json ->>'isparent')::text;
	v_dv_parent_id = (((p_data ->>'data')::json->>'parameters')::json ->>'dv_parent_id')::text;
	v_dv_querytext = (((p_data ->>'data')::json->>'parameters')::json ->>'dv_querytext')::text;
	v_dv_isnullvalue = (((p_data ->>'data')::json->>'parameters')::json ->>'dv_isnullvalue')::text;
	v_linkedaction = (((p_data ->>'data')::json->>'parameters')::json ->>'linkedaction')::text;
	v_hidden = (((p_data ->>'data')::json->>'parameters')::json ->>'hidden')::json;
	v_stylesheet = (((p_data ->>'data')::json->>'parameters')::json ->>'stylesheet')::json;
	v_multi_create = ((p_data ->>'data')::json->>'multi_create')::text;
	v_dv_querytext_filterc = (((p_data ->>'data')::json->>'parameters')::json ->>'dv_querytext_filterc')::text;
	v_widgetfunction = (((p_data ->>'data')::json->>'parameters')::json ->>'widgetfunction')::text;
	v_widgetdim = (((p_data ->>'data')::json->>'parameters')::json ->>'widgetdim')::integer;
	v_isautoupdate = (((p_data ->>'data')::json->>'parameters')::json ->>'isautoupdate')::text;
	v_listfilterparam = (((p_data ->>'data')::json->>'parameters')::json ->>'listfilterparam')::json;
	v_hidden = COALESCE(v_hidden, FALSE);

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=218 AND cur_user=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (218, null, 4, 'CREATE ADDFIELDS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (218, null, 4, '-------------------------------------------------------------');
	

	--Assign config widget types 
	IF v_config_datatype='string' THEN
		v_add_datatype = 'text';
	ELSE 
		v_add_datatype = v_config_datatype;
	END IF;

	IF v_config_datatype='numeric' THEN
		v_audit_datatype = 'double';
	ELSE
		v_audit_datatype=v_config_datatype;
	END IF; 

	IF v_config_datatype='double' THEN
		v_audit_datatype=v_config_datatype;
		v_config_datatype = 'numeric';
		v_add_datatype = 'numeric';
	END IF;
	
	IF v_config_widgettype='doubleSpinbox' THEN
		v_audit_widgettype = 'spinbox';
	ELSE
		v_audit_widgettype = v_config_widgettype;
	END IF;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
	VALUES (218, null, 4, concat('Create addfield ',v_param_name,'.'));

	--check if the new field doesnt have accents and fix it
	IF v_action='CREATE' THEN
		v_unaccent_id = array_to_string(ts_lexize('unaccent',v_param_name),',','*');

		IF v_unaccent_id IS NOT NULL THEN
			v_param_name = v_unaccent_id;
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, 'Remove accents from addfield name.');

		END IF;

		IF v_param_name ilike '%-%' OR v_param_name ilike '%.%' THEN
			v_param_name=replace(replace(replace(v_param_name, ' ','_'),'-','_'),'.','_');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, 'Remove unwanted characters from addfield name.');
		END IF;

	END IF;

	IF v_multi_create IS TRUE THEN
	
		IF v_action='UPDATE' THEN
			v_update_old_datatype = (SELECT datatype_id FROM sys_addfields WHERE param_name=v_param_name);
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, 'Update old parameter name.');
		END IF;

		v_active_feature = 'SELECT cat_feature.* FROM cat_feature WHERE active IS TRUE ORDER BY id';

		FOR rec IN EXECUTE v_active_feature LOOP

			IF v_action='UPDATE' THEN
				UPDATE sys_addfields SET datatype_id=v_update_old_datatype where param_name=v_param_name AND cat_feature_id IS NULL;
			END IF;
		
			-- get view name
			IF (SELECT child_layer FROM cat_feature WHERE id=rec.id) IS NULL THEN
				UPDATE cat_feature SET child_layer=concat('ve_',lower(feature_type),'_',lower(id)) WHERE id=rec.id;
			END IF;

			--remove spaces and dashs from view name
			IF (SELECT child_layer FROM cat_feature WHERE id=rec.id AND (position('-' IN child_layer)>0 OR position(' ' IN child_layer)>0  
				OR position('.' IN child_layer)>0)) IS NOT NULL  THEN
			
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (218, null, 4, concat('Remove unwanted characters from child view name: ',rec.id));

				UPDATE cat_feature SET child_layer=replace(replace(replace(child_layer, ' ','_'),'-','_'),'.','_') WHERE id=rec.id;
			
			END IF;
	
			v_viewname = (SELECT child_layer FROM cat_feature WHERE id=rec.id);

			--get the current definition of the custom view if it exists
			IF (SELECT EXISTS ( SELECT 1 FROM   information_schema.tables WHERE  table_schema = v_schemaname AND table_name = v_viewname)) IS TRUE THEN
				EXECUTE'SELECT pg_get_viewdef('''||v_schemaname||'.'||v_viewname||''', true);'
				INTO v_definition;
			END IF;
		
			--get the system type and system_id of the feature
			v_feature_type = (SELECT lower(feature_type) FROM cat_feature where id=rec.id);
			v_feature_system_id  = (SELECT lower(system_id) FROM cat_feature where id=rec.id);

			--get old values of addfields
			IF (SELECT count(id) FROM sys_addfields WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE) != 0 THEN
				IF v_action='CREATE' THEN
					SELECT lower(string_agg(concat('a.',param_name),E',\n    ' order by orderby)) as a_param,
					lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
					lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
					lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
					INTO v_old_parameters
					FROM sys_addfields WHERE  (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE and param_name!=v_param_name ;
	
				ELSE
					SELECT lower(string_agg(concat('a.',param_name),E',\n    ' order by orderby)) as a_param,
					lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
					lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
					lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
					INTO v_old_parameters
					FROM sys_addfields WHERE  (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE;
				END IF;
			END IF;

			--modify the configuration of the parameters and fields in config_form_fields
			IF v_action = 'CREATE' AND v_param_name not in (select param_name FROM sys_addfields WHERE cat_feature_id IS NULL) THEN

				IF (SELECT count(id) FROM sys_addfields WHERE cat_feature_id IS NULL AND active IS TRUE) = 0 THEN
					v_orderby = 10000;
				ELSE 
					EXECUTE 'SELECT max(orderby) + 1 FROM sys_addfields'
					INTO v_orderby;
				END IF;
			
				INSERT INTO sys_addfields (param_name, cat_feature_id, is_mandatory, datatype_id, 
				active, orderby, iseditable)
				VALUES (v_param_name, NULL, v_ismandatory, v_add_datatype, v_active, v_orderby, v_iseditable)
				RETURNING id INTO v_idaddparam;
			
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (218, null, 4, 'Insert parameter definition into sys_addfields.');

				SELECT max(layoutorder) + 1 INTO v_param_user_id FROM sys_param_user WHERE layoutname='lyt_addfields';

				IF v_param_user_id IS NULL THEN
					v_param_user_id=1;
				END IF;

				IF concat('edit_addfield_p', v_idaddparam,'_vdefault') NOT IN (SELECT id FROM sys_param_user) THEN
					INSERT INTO sys_param_user (id, formname, descript, sys_role, label,  layoutname, layoutorder,
					project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, dv_querytext, dv_querytext_filterc,feature_field_id, isenabled)
					VALUES (concat('edit_addfield_p', v_idaddparam,'_vdefault'),'config', concat('Default value of addfield ',v_param_name), 'role_edit', v_param_name,
					'lyt_addfields', v_param_user_id, lower(v_project_type), false, false, v_audit_datatype, v_audit_widgettype, false,
					v_dv_querytext, v_dv_querytext_filterc,v_param_name, true);
		
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (218, null, 4, concat('Create new vdefault: ', concat('edit_addfield_p', v_idaddparam,'_vdefault')));
			
				END IF;

			ELSIF v_action = 'UPDATE' THEN
				UPDATE sys_addfields SET  is_mandatory=v_ismandatory, datatype_id=v_add_datatype,
				active=v_active, orderby=v_orderby, iseditable=v_iseditable 
				WHERE param_name=v_param_name and cat_feature_id IS NULL;

				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (218, null, 4, 'Update parameter definition in sys_addfields.');

				UPDATE sys_param_user SET datatype = v_audit_datatype, widgettype=v_audit_widgettype, dv_querytext = v_dv_querytext,
				dv_querytext_filterc = v_dv_querytext_filterc WHERE id = concat('edit_addfield_p', v_idaddparam,'_vdefault');

			
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (218, null, 4, concat('Update definition of vdefault: ', concat('edit_addfield_p', v_idaddparam,'_vdefault')));

			ELSIF v_action = 'DELETE' THEN

				DELETE FROM config_form_fields WHERE formname=v_viewname AND columnname=v_param_name;

				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (218, null, 4, 'Delete values from config_form_fields related to parameter.');

				DELETE FROM sys_param_user WHERE id = concat('edit_addfield_p', v_idaddparam,'_vdefault');

				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (218, null, 4, concat('Delete definition of vdefault: ', concat('edit_addfield_p', v_idaddparam,'_vdefault')));

			END IF;

			IF v_action = 'CREATE' THEN

				EXECUTE 'SELECT max(layoutorder) + 1 FROM config_form_fields WHERE formname='''||v_viewname||''' AND layoutname = ''lyt_data_1'';'
				INTO v_layoutorder;

				IF v_layoutorder IS NULL THEN
					v_layoutorder = 1;
				END IF;

				INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype,
				label, ismandatory, isparent, iseditable, isautoupdate, layoutname, 
				placeholder, stylesheet, tooltip, widgetfunction, dv_isnullvalue, widgetdim,
				dv_parent_id, dv_querytext_filterc, dv_querytext, listfilterparam, linkedaction, hidden)	
				VALUES (v_viewname, v_formtype, v_param_name, v_layoutorder, v_config_datatype, v_config_widgettype,
				v_label, v_ismandatory,v_isparent, v_iseditable, v_isautoupdate, 'lyt_data_1',
				v_placeholder, v_stylesheet, v_tooltip, v_widgetfunction, v_dv_isnullvalue, v_widgetdim,
				v_dv_parent_id, v_dv_querytext_filterc, v_dv_querytext, v_listfilterparam, v_linkedaction, v_hidden);

				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (218, null, 4, 'Insert parameter into config_form_fields.');

			ELSIF v_action = 'UPDATE' THEN
				UPDATE config_form_fields SET datatype=v_config_datatype,
				widgettype=v_config_widgettype, label=v_label,
				ismandatory=v_ismandatory, isparent=v_isparent, iseditable=v_iseditable, isautoupdate=v_isautoupdate, 
				placeholder=v_placeholder, stylesheet=v_stylesheet, tooltip=v_tooltip, 
				widgetfunction=v_widgetfunction, dv_isnullvalue=v_dv_isnullvalue, widgetdim=v_widgetdim,
				dv_parent_id=v_dv_parent_id, dv_querytext_filterc=v_dv_querytext_filterc, 
				dv_querytext=v_dv_querytext, listfilterparam=v_listfilterparam,linkedaction=v_linkedaction, hidden = v_hidden
				WHERE columnname=v_param_name AND formname=v_viewname;

				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (218, null, 4, 'Update parameter in config_form_fields.');
			END IF;
			
			--get new values of addfields
			IF v_action='DELETE' THEN
				SELECT lower(string_agg(concat('a.',param_name),E',\n    '  order by orderby)) as a_param,
				lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
				lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
				lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
				INTO v_new_parameters
				FROM sys_addfields WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE AND param_name!=v_param_name;
			ELSE
				SELECT lower(string_agg(concat('a.',param_name),E',\n    '  order by orderby)) as a_param,
				lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
				lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
				lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
				INTO v_new_parameters
				FROM sys_addfields WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE;
				
			END IF;

				--select columns from man_* table without repeating the identifier
				EXECUTE 'SELECT DISTINCT string_agg(concat(''man_'||v_feature_system_id||'.'',column_name)::text,'', '')
				FROM information_schema.columns where table_name=''man_'||v_feature_system_id||''' and table_schema='''||v_schemaname||''' 
				and column_name!='''||v_feature_type||'_id'''
				INTO v_man_fields;
				

			--CREATE VIEW when the addfield is the 1st one for the  defined cat feature
			IF (SELECT count(id) FROM sys_addfields WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) and active is true ) = 1 AND v_action = 'CREATE' THEN

					SELECT lower(string_agg(concat('a.',param_name),',' order by orderby)) as a_param,
						lower(string_agg(concat('ct.',param_name),',' order by orderby)) as ct_param,
						lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
						lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
						INTO v_created_addfields
						FROM sys_addfields WHERE  (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) AND active IS TRUE;	
						
					IF (v_man_fields IS NULL AND v_project_type='WS') OR (v_man_fields IS NULL AND v_project_type='UD' AND 
						( v_feature_type='arc' OR v_feature_type='node')) THEN
					
					EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
					v_view_type = 4;

				ELSIF (v_man_fields IS NULL AND v_project_type='UD' AND (v_feature_type='connec' OR v_feature_type='gully')) THEN

					EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
					v_view_type = 5;
				ELSE
					EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
					v_view_type = 6;

				END IF;

				RAISE NOTICE 'MULTI - VIEW TYPE  ,%', v_view_type;

				v_man_fields := COALESCE(v_man_fields, 'null');

				v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
				"feature_type":"'||v_feature_type||'","feature_system_id":"'||v_feature_system_id||'","featurecat":"'||rec.id||'","view_type":"'||v_view_type||'",
				"man_fields":"'||v_man_fields||'","a_param":"'||v_created_addfields.a_param||'","ct_param":"'||v_created_addfields.ct_param||'",
				"id_param":"'||v_created_addfields.id_param||'","datatype":"'||v_created_addfields.datatype||'"}}';
					
				PERFORM gw_fct_admin_manage_child_views_view(v_data_view);

				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (218, null, 4, concat('Recreate child view for ',rec.id,'.'));
				
			--CREATE VIEW when the addfields don't exist (after delete)
			ELSIF v_new_parameters is null THEN 

				IF (v_man_fields IS NULL AND v_project_type='WS') OR (v_man_fields IS NULL AND v_project_type='UD' AND 
					( v_feature_type='arc' OR v_feature_type='node')) THEN
					
					EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
					v_view_type = 1;

				ELSIF (v_man_fields IS NULL AND v_project_type='UD' AND (v_feature_type='connec' OR v_feature_type='gully')) THEN
					
					EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
					v_view_type = 2;

				ELSE
				
					EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
					v_view_type = 3;

				END IF;

				RAISE NOTICE 'MULTI - VIEW TYPE  ,%', v_view_type;

				v_man_fields := COALESCE(v_man_fields, 'null');

				v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
				"feature_type":"'||v_feature_type||'","feature_system_id":"'||v_feature_system_id||'","featurecat":"'||rec.id||'","view_type":"'||v_view_type||'",
				"man_fields":"'||v_man_fields||'","a_param":null,"ct_param":null,
				"id_param":null,"datatype":null}}';
					
				PERFORM gw_fct_admin_manage_child_views_view(v_data_view);
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (218, null, 4, concat('Recreate child view for ',rec.id,'.'));

			ELSE	

				IF (SELECT EXISTS ( SELECT 1 FROM   information_schema.tables WHERE  table_schema = v_schemaname AND table_name = v_viewname)) IS TRUE THEN
					EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				END IF;

				--update the current view defintion
				v_definition = replace(v_definition,v_old_parameters.ct_param,v_new_parameters.ct_param);
				v_definition = replace(v_definition,v_old_parameters.a_param,v_new_parameters.a_param);
				v_definition = replace(v_definition,v_old_parameters.id_param,v_new_parameters.id_param);
				v_definition = replace(v_definition,v_old_parameters.datatype,v_new_parameters.datatype);

				--replace the existing view
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS '||v_definition||';';
				
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (218, null, 4, concat('Recreate child view for ',rec.id,'.'));	
			END IF;

			--create trigger on view 
			EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(rec.id, ' ','_'),'-','_'),'.','_'))||' ON '||v_schemaname||'.'||v_viewname||';';

			EXECUTE 'CREATE TRIGGER gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(rec.id, ' ','_'),'-','_'),'.','_'))||'
			INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_schemaname||'.'||v_viewname||'
			FOR EACH ROW EXECUTE PROCEDURE '||v_schemaname||'.gw_trg_edit_'||v_feature_type||'('''||rec.id||''');';

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, concat('Recreate edition trigger for view ',rec.child_layer,'.'));

		END LOOP;

		IF v_action='DELETE' THEN
			EXECUTE 'DELETE FROM sys_addfields WHERE param_name='''||v_param_name||''';';

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, 'Delete values from sys_addfields related to parameter.');

			EXECUTE 'DELETE FROM config_form_fields WHERE columnname='''||v_param_name||'''and formtype=''form_feature'';' ;

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, 'Delete values from config_form_fields related to parameter.');

		ELSIF v_action='UPDATE' THEN 
			UPDATE sys_addfields SET  is_mandatory=v_ismandatory, datatype_id=v_add_datatype,
			active=v_active, orderby=v_orderby WHERE param_name=v_param_name;		

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, 'Update values of sys_addfields related to parameter.');
		END IF;

	--SIMPLE ADDFIELDS
	ELSE
	
		SELECT max(orderby) INTO v_orderby FROM sys_addfields WHERE cat_feature_id=v_cat_feature;
		IF v_orderby IS NULL THEN
			v_orderby = 1;
		ELSE
			v_orderby = v_orderby + 1;
		END IF;

		--check if field order will overlap the existing field	
		IF v_orderby IN (SELECT orderby FROM sys_addfields WHERE cat_feature_id = v_cat_feature AND param_name!=v_param_name) THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3016", "function":"2690","debug_msg":null}}$$);' INTO v_audit_result;
		END IF;

		-- get view definition
		IF (SELECT child_layer FROM cat_feature WHERE id=v_cat_feature) IS NULL THEN
			UPDATE cat_feature SET child_layer=concat('ve_',lower(feature_type),'_',lower(id)) WHERE id=v_cat_feature;
		END IF;

		--remove spaces and dashes from view name
		IF (SELECT child_layer FROM cat_feature WHERE id=v_cat_feature AND (position('-' IN child_layer)>0 OR position(' ' IN child_layer)>0  
			OR position('.' IN child_layer)>0)) IS NOT NULL  THEN

			v_viewname = (SELECT child_layer FROM cat_feature WHERE id=v_cat_feature);
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, concat('Remove unwanted characters from child view name: ',v_viewname, '.'));

			UPDATE cat_feature SET child_layer=replace(replace(replace(child_layer, ' ','_'),'-','_'),'.','_') WHERE id=v_cat_feature;
			
		END IF;
		
		v_viewname = (SELECT child_layer FROM cat_feature WHERE id=v_cat_feature);

		--get the current definition of the custom view if it exists
		IF (SELECT EXISTS ( SELECT 1 FROM   information_schema.tables WHERE  table_schema = v_schemaname AND table_name = v_viewname)) IS TRUE THEN
			EXECUTE'SELECT pg_get_viewdef('''||v_schemaname||'.'||v_viewname||''', true);'
			INTO v_definition;
		END IF;

		--get the system type and system_id of the feature
		v_feature_type = (SELECT lower(feature_type) FROM cat_feature where id=v_cat_feature);
		v_feature_system_id  = (SELECT lower(system_id) FROM cat_feature where id=v_cat_feature);

		--get old values of addfields
		IF (SELECT count(id) FROM sys_addfields WHERE cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) != 0 THEN
			SELECT lower(string_agg(concat('a.',param_name),E',\n    '  order by orderby)) as a_param,
			lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
			lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
			lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
			INTO v_old_parameters
			FROM sys_addfields WHERE (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) AND active IS TRUE ;
		END IF;

		--modify the configuration of the parameters and fields in config_form_fields
		IF v_action = 'CREATE' THEN
			INSERT INTO sys_addfields (param_name, cat_feature_id, is_mandatory, datatype_id,
			active, orderby, iseditable)
			VALUES (v_param_name, v_cat_feature, v_ismandatory, v_add_datatype,
			v_active, v_orderby, v_iseditable) RETURNING id INTO v_idaddparam;
			
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, 'Insert parameter definition into sys_addfields.');

			EXECUTE 'SELECT max(layoutorder) + 1 FROM config_form_fields WHERE formname='''||v_viewname||''' AND layoutname = ''lyt_data_1'';'
			INTO v_layoutorder;

			IF v_layoutorder IS NULL THEN
				v_layoutorder = 1;
			END IF;

			INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,
			datatype, widgettype, label, ismandatory, isparent, iseditable, 
			layoutname, placeholder, stylesheet, tooltip, widgetfunction, dv_isnullvalue, widgetdim,
			dv_parent_id, dv_querytext_filterc, dv_querytext, listfilterparam, linkedaction, hidden)
			VALUES (v_viewname, v_formtype, v_param_name, v_layoutorder,v_config_datatype, v_config_widgettype,
			v_label, v_ismandatory, v_isparent, v_iseditable, 'lyt_data_1',
			v_placeholder, v_stylesheet, v_tooltip, v_widgetfunction, v_dv_isnullvalue, v_widgetdim,
			v_dv_parent_id, v_dv_querytext_filterc, v_dv_querytext, v_listfilterparam, v_linkedaction, v_hidden);

			
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, 'Insert parameter definition into config_form_fields.');

			SELECT max(layoutorder) + 1 INTO v_param_user_id FROM sys_param_user WHERE layoutname='lyt_addfields';
			
			IF v_param_user_id IS NULL THEN
				v_param_user_id=1;
			END IF;

			INSERT INTO sys_param_user (id, formname, descript, sys_role, label,  layoutname, layoutorder,
			project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, dv_querytext, dv_querytext_filterc, feature_field_id, isenabled)
			VALUES (concat('edit_addfield_p', v_idaddparam,'_vdefault'),'config', 
			concat('Default value of addfield ',v_param_name, ' for ', v_cat_feature), 
			'role_edit', v_param_name, 'lyt_addfields', v_param_user_id, lower(v_project_type), false, false, v_audit_datatype, 
			v_audit_widgettype, false, v_dv_querytext, v_dv_querytext_filterc, v_param_name, true);
			
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, concat('Create new vdefault: ', concat('edit_addfield_p', v_idaddparam,'_vdefault'),'.'));
			

		ELSIF v_action = 'UPDATE' THEN
			UPDATE sys_addfields SET  is_mandatory=v_ismandatory, datatype_id=v_add_datatype,
			active=v_active, orderby=v_orderby,iseditable=v_iseditable 
			WHERE param_name=v_param_name AND cat_feature_id=v_cat_feature;

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, 'Update parameter definition in sys_addfields.');
			
			IF (SELECT cat_feature_id FROM sys_addfields WHERE param_name=v_param_name) IS NOT NULL THEN
				UPDATE config_form_fields SET datatype=v_config_datatype,
				widgettype=v_config_widgettype, label=v_label,
				ismandatory=v_ismandatory, isparent=v_isparent, iseditable=v_iseditable, isautoupdate=v_isautoupdate, 
				placeholder=v_placeholder, stylesheet=v_stylesheet, tooltip=v_tooltip, 
				widgetfunction=v_widgetfunction, dv_isnullvalue=v_dv_isnullvalue, widgetdim=v_widgetdim,
				dv_parent_id=v_dv_parent_id, dv_querytext_filterc=v_dv_querytext_filterc, 
				dv_querytext=v_dv_querytext, listfilterparam=v_listfilterparam,linkedaction=v_linkedaction,
				hidden = v_hidden
				WHERE columnname=v_param_name AND formname=v_viewname;
		
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (218, null, 4, 'Update parameter definition in config_form_fields.');

			END IF;

			UPDATE sys_param_user SET datatype = v_audit_datatype, widgettype=v_audit_widgettype, dv_querytext = v_dv_querytext,
			dv_querytext_filterc = v_dv_querytext_filterc WHERE id = concat('edit_addfield_p', v_idaddparam,'_vdefault');

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, concat('Update definition of vdefault: ', concat('edit_addfield_p', v_idaddparam,'_vdefault'),'.'));

		ELSIF v_action = 'DELETE' THEN
			EXECUTE 'DELETE FROM sys_addfields WHERE param_name='''||v_param_name||''' AND cat_feature_id='''||v_cat_feature||''';';

			DELETE FROM sys_param_user WHERE id = concat('edit_addfield_p', v_idaddparam,'_vdefault');

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, 'Delete values from config_form_fields related to parameter.');

			DELETE FROM config_form_fields WHERE formname=v_viewname AND columnname=v_param_name;

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, concat('Delete definition of vdefault: ', concat('edit_addfield_p', v_idaddparam,'_vdefault')));

		END IF;

			--get new values of addfields
			SELECT lower(string_agg(concat('a.',param_name),E',\n    '  order by orderby)) as a_param,
			lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
			lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
			lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
			INTO v_new_parameters
			FROM sys_addfields WHERE (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) AND active IS TRUE;
			
			--select columns from man_* table without repeating the identifier
			EXECUTE 'SELECT DISTINCT string_agg(concat(''man_'||v_feature_system_id||'.'',column_name)::text,'', '')
			FROM information_schema.columns where table_name=''man_'||v_feature_system_id||''' and table_schema='''||v_schemaname||''' 
			and column_name!='''||v_feature_type||'_id'''
			INTO v_man_fields;

			--CREATE VIEW when the addfield is the 1st one for the  defined cat feature
		IF (SELECT count(id) FROM sys_addfields WHERE (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) and active is true ) = 1 
		AND v_action = 'CREATE' THEN
				
				SELECT lower(string_agg(concat('a.',param_name),E',\n    ' order by orderby)) as a_param,
					lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
					lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
					lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
					INTO v_created_addfields
					FROM sys_addfields WHERE  (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) AND active IS TRUE;	

			IF (v_man_fields IS NULL AND v_project_type='WS') OR (v_man_fields IS NULL AND v_project_type='UD' AND 
				( v_feature_type='arc' OR v_feature_type='node')) THEN

				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				v_view_type = 4;

			ELSIF (v_man_fields IS NULL AND v_project_type='UD' AND (v_feature_type='connec' OR v_feature_type='gully')) THEN			
		
				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				v_view_type = 5;

			ELSE
				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				v_view_type = 6;

			END IF;


			v_man_fields := COALESCE(v_man_fields, 'null');

			v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
			"feature_type":"'||v_feature_type||'","feature_system_id":"'||v_feature_system_id||'","featurecat":"'||v_cat_feature||'","view_type":"'||v_view_type||'",
			"man_fields":"'||v_man_fields||'","a_param":"'||v_created_addfields.a_param||'","ct_param":"'||v_created_addfields.ct_param||'",
			"id_param":"'||v_created_addfields.id_param||'","datatype":"'||v_created_addfields.datatype||'"}}';
				
			PERFORM gw_fct_admin_manage_child_views_view(v_data_view);

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, concat('Recreate child view for ',v_cat_feature,'.'));	

		--CREATE VIEW when the addfields don't exist (after delete)
		ELSIF v_new_parameters is null THEN 
		
			IF (v_man_fields IS NULL AND v_project_type='WS') OR (v_man_fields IS NULL AND v_project_type='UD' AND 
				( v_feature_type='arc' OR v_feature_type='node')) THEN
				
				EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				v_view_type = 1;

			ELSIF (v_man_fields IS NULL AND v_project_type='UD' AND (v_feature_type='connec' OR v_feature_type='gully')) THEN	
				
				EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				v_view_type = 2;

			ELSE
				
				EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				v_view_type = 3;

			END IF;
			
			RAISE NOTICE 'SIMPLE - VIEW TYPE  ,%', v_view_type;

			v_man_fields := COALESCE(v_man_fields, 'null');
			
			v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
			"feature_type":"'||v_feature_type||'","feature_system_id":"'||v_feature_system_id||'","featurecat":"'||v_cat_feature||'","view_type":"'||v_view_type||'",
			"man_fields":"'||v_man_fields||'","a_param":null,"ct_param":null,
			"id_param":null,"datatype":null}}';
				
			PERFORM gw_fct_admin_manage_child_views_view(v_data_view);

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, concat('Recreate child view for ',v_cat_feature,'.'));
		ELSE	
			IF (SELECT EXISTS ( SELECT 1 FROM   information_schema.tables WHERE  table_schema = v_schemaname AND table_name = v_viewname)) IS TRUE THEN
				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
			END IF;
			
			--update the current view defintion
			v_definition = replace(v_definition,v_old_parameters.ct_param,v_new_parameters.ct_param);
			v_definition = replace(v_definition,v_old_parameters.a_param,v_new_parameters.a_param);
			v_definition = replace(v_definition,v_old_parameters.id_param,v_new_parameters.id_param);
			v_definition = replace(v_definition,v_old_parameters.datatype,v_new_parameters.datatype);

			--replace the existing view and create the trigger
			EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS '||v_definition||';';
			
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (218, null, 4, concat('Recreate child view for ',v_cat_feature,'.'));	
		END IF;

		--create trigger on view 
		EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(v_cat_feature, ' ','_'),'-','_'),'.','_'))||' ON '||v_schemaname||'.'||v_viewname||';';

		EXECUTE 'CREATE TRIGGER gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(v_cat_feature, ' ','_'),'-','_'),'.','_'))||'
		INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_schemaname||'.'||v_viewname||'
		FOR EACH ROW EXECUTE PROCEDURE '||v_schemaname||'.gw_trg_edit_'||v_feature_type||'('''||v_cat_feature||''');';

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (218, null, 4, concat('Recreate edition trigger for view ',v_viewname,'.'));

	END IF;

	PERFORM gw_fct_admin_role_permissions();

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
	VALUES (218, null, 4, 'Set role permissions.');

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data 
	WHERE cur_user="current_user"() AND fid=218 ORDER BY criticity desc, id asc) row;
	
	IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message = 'Process done successfully';
    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;

	v_result_info := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

	v_result_point = '{"geometryType":"", "features":[]}';
	v_result_line = '{"geometryType":"", "features":[]}';
	v_result_polygon = '{"geometryType":"", "features":[]}';

	-- Control NULL's
	v_hide_form := COALESCE(v_hide_form, FALSE); 
	
	--  Return
	RETURN gw_fct_json_create_return( ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
				', "actions":{"hideForm":' || v_hide_form || '}'||
		       '}'||
	    '}')::json, 2690);


	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;