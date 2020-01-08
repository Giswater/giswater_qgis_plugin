/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2690

--drop function SCHEMA_NAME.gw_fct_admin_manage_addfields(json)
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_addfields(p_data json)
  RETURNS void AS
$BODY$


/*EXAMPLE


SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PUMP"},
"data":{"action":"CREATE", "multi_create":"true", "parameters":{"column_id":"addfield_all", "datatype":"string", "widgettype":"text", "label":"addfield_all","ismandatory":"False",
"fieldLength":"50", "numDecimals" :null,"active":"True", "iseditable":"True","v_isenabled":"True"}}}$$);

SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${"client":{"device":9, "infoType":100, "lang":"ES"}, 
"form":{}, 
"feature":{"catFeature":"PUMP"}, 
"data":{"filterFields":{}, "pageInfo":{}, "action":"CREATE", "multi_create":false, 
"parameters":{"label": "pump1", "field_length": null, "addfield_active": true, "iseditable": true, "ismandatory": false, "formtype": "feature", 
"datatype": "boolean", "num_decimals": null, "column_id": "pump1", "isenabled": true, "widgettype": "check", "dv_isnullvalue": false, 
"isautoupdate": false, "dv_parent_id": null, "tooltip": null, "dv_querytext": null, "widgetfunction": null, "placeholder": null, "reload_field": null, 
"isnotupdate": false, "isparent": false, "typeahead": null, "listfilterparam": null, "editability": null, "dv_querytext_filterc": null, "action_function": null, 
"stylesheet": null, "widgetdim": null}}}$$)::text

	SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${"client":{"device":9, "infoType":100, "lang":"ES"}, 
	"form":{}, 
	"feature":{"catFeature":"PUMP"}, 
	"data":{"filterFields":{}, "pageInfo":{}, "action":"UPDATE", "multi_create":false, 
	"parameters":{"label": "pump111", "field_length": null, "addfield_active": true, "iseditable": true, "ismandatory": false, "formtype": "feature", 
	"datatype": "integer", "num_decimals": null, "column_id": "pump1", "isenabled": true, "widgettype": "text", "dv_isnullvalue": false, 
	"isautoupdate": false, "dv_parent_id": null, "tooltip": null, "dv_querytext": null, "widgetfunction": null, "placeholder": null, "reload_field": null, 
	"isnotupdate": false, "isparent": false, "typeahead": null, "listfilterparam": null, "editability": null, "dv_querytext_filterc": null, "action_function": null, 
	"stylesheet": null, "widgetdim": null}}}$$)::text

SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${
"client":{"lang":"ES"}, 
"feature":{"catFeature":"PUMP"},
"data":{"action":"DELETE", "multi_create":"true", "parameters":{"column_id":"pump_test"}}}$$)
*/


DECLARE 
	v_schemaname text;
	v_cat_feature text;
	v_viewname text;
	v_definition text;
	v_ismandatory boolean;
	v_config_datatype text;
	v_field_length integer;
	v_num_decimals integer;
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
	v_layout_order integer;
	v_form_fields_id integer;
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
	v_typeahead json;
	v_isparent boolean;
	v_isenabled boolean;
	v_dv_parent_id text;
	v_dv_querytext text;
	v_isnotupdate boolean;
	v_dv_isnullvalue boolean;
	v_stylesheet json;
	v_multi_create boolean;
	v_dv_querytext_filterc text;
	v_reload_field json;
	v_widgetfunction text;
	v_widgetdim integer;
	v_isautoupdate boolean;
	v_listfilterparam json;
	v_action_function text;
	v_editability json;
	v_update_old_datatype text;
	v_project_type text;
	v_param_user_id integer;
	v_audit_datatype text;
	v_audit_widgettype text;
	v_active_feature text;
	v_created_addfields record;
	v_unaccent_id text;
BEGIN

	
	-- search path
	SET search_path = "SCHEMA_NAME", public;

 	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;

	-- get input parameters -,man_addfields
	v_schemaname = 'SCHEMA_NAME';
	v_id = (SELECT nextval('man_addfields_parameter_id_seq') +1);

	v_param_name = (((p_data ->>'data')::json->>'parameters')::json->>'column_id')::text; 
	v_cat_feature = ((p_data ->>'feature')::json->>'catFeature')::text;
	v_ismandatory = (((p_data ->>'data')::json->>'parameters')::json->>'ismandatory')::text;
	v_config_datatype = (((p_data ->>'data')::json->>'parameters')::json->>'datatype')::text;
	v_field_length = (((p_data ->>'data')::json->>'parameters')::json->>'field_length')::text;
	v_num_decimals = (((p_data ->>'data')::json->>'parameters')::json->>'num_decimals')::text;
	v_label = (((p_data ->>'data')::json->>'parameters')::json->>'label')::text;
	v_config_widgettype = (((p_data ->>'data')::json->>'parameters')::json->>'widgettype')::text;
	v_action = ((p_data ->>'data')::json->>'action')::text;
	v_active = (((p_data ->>'data')::json->>'parameters')::json->>'addfield_active')::text;
	v_iseditable = (((p_data ->>'data')::json->>'parameters')::json ->>'iseditable')::text;

-- get input parameters - config_api_form_fields
	v_formtype = 'feature';
	v_placeholder = (((p_data ->>'data')::json->>'parameters')::json->>'placeholder')::text;
	v_tooltip = (((p_data ->>'data')::json->>'parameters')::json ->>'tooltip')::text;
	v_typeahead = (((p_data ->>'data')::json->>'parameters')::json ->>'typeahead')::json;
	v_isparent = (((p_data ->>'data')::json->>'parameters')::json ->>'isparent')::text;
	v_isenabled = (((p_data ->>'data')::json->>'parameters')::json ->>'isenabled')::text;
	v_dv_parent_id = (((p_data ->>'data')::json->>'parameters')::json ->>'dv_parent_id')::text;
	v_dv_querytext = (((p_data ->>'data')::json->>'parameters')::json ->>'dv_querytext')::text;
	v_isnotupdate = (((p_data ->>'data')::json->>'parameters')::json ->>'isnotupdate')::text;
	v_dv_isnullvalue = (((p_data ->>'data')::json->>'parameters')::json ->>'dv_isnullvalue')::text;
	v_action_function = (((p_data ->>'data')::json->>'parameters')::json ->>'action_function')::text;
	v_editability = (((p_data ->>'data')::json->>'parameters')::json ->>'editability')::json;
	v_stylesheet = (((p_data ->>'data')::json->>'parameters')::json ->>'stylesheet')::json;
	v_multi_create = ((p_data ->>'data')::json->>'multi_create')::text;
	v_dv_querytext_filterc = (((p_data ->>'data')::json->>'parameters')::json ->>'dv_querytext_filterc')::text;
	v_reload_field = (((p_data ->>'data')::json->>'parameters')::json ->>'reload_field')::json;
	v_widgetfunction = (((p_data ->>'data')::json->>'parameters')::json ->>'widgetfunction')::text;
	v_widgetdim = (((p_data ->>'data')::json->>'parameters')::json ->>'widgetdim')::integer;
	v_isautoupdate = (((p_data ->>'data')::json->>'parameters')::json ->>'isautoupdate')::text;
	v_listfilterparam = (((p_data ->>'data')::json->>'parameters')::json ->>'listfilterparam')::json;



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

raise notice 'v_multi_create,%',v_multi_create;

PERFORM setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

--check if the new field doesnt have accents and fix it
IF v_action='CREATE' THEN
	v_unaccent_id = array_to_string(ts_lexize('unaccent',v_param_name),',','*');

	IF v_unaccent_id IS NOT NULL THEN
		v_param_name = v_unaccent_id;
	END IF;

	IF v_param_name ilike '%-%' OR v_param_name ilike '%.%' THEN
	 	v_param_name=replace(replace(replace(v_param_name, ' ','_'),'-','_'),'.','_');
	END IF;

END IF;

IF v_multi_create IS TRUE THEN
	
	IF v_action='UPDATE' THEN
		v_update_old_datatype = (SELECT datatype_id FROM man_addfields_parameter WHERE param_name=v_param_name);
	END IF;

	IF  v_project_type='WS' THEN
		v_active_feature = 'SELECT cat_feature.* FROM cat_feature JOIN (SELECT id,active FROM node_type 
															UNION SELECT id,active FROM arc_type 
															UNION SELECT id,active FROM connec_type) a USING (id) WHERE a.active IS TRUE ORDER BY id';
	ELSE 
		v_active_feature = 'SELECT cat_feature.* FROM cat_feature JOIN (SELECT id,active FROM node_type 
															UNION SELECT id,active FROM arc_type 
															UNION SELECT id,active FROM connec_type 
															UNION SELECT id,active FROM gully_type) a USING (id) WHERE a.active IS TRUE ORDER BY id';
	END IF;
	
	FOR rec IN EXECUTE v_active_feature LOOP

		IF v_action='UPDATE' THEN
			UPDATE man_addfields_parameter SET datatype_id=v_update_old_datatype where param_name=v_param_name AND cat_feature_id IS NULL;
		END IF;
		-- get view name
		IF (SELECT child_layer FROM cat_feature WHERE id=rec.id) IS NULL THEN
			UPDATE cat_feature SET child_layer=concat('ve_',lower(feature_type),'_',lower(id)) WHERE id=rec.id;
		END IF;

		--remove spaces and dashs from view name
		IF (SELECT child_layer FROM cat_feature WHERE id=rec.id AND (position('-' IN child_layer)>0 OR position(' ' IN child_layer)>0  
			OR position('.' IN child_layer)>0)) IS NOT NULL  THEN
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
		IF (SELECT count(id) FROM man_addfields_parameter WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE) != 0 THEN
			IF v_action='CREATE' THEN
				SELECT lower(string_agg(concat('a.',param_name),E',\n    ' order by orderby)) as a_param,
				lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
				lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
				lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
				INTO v_old_parameters
				FROM man_addfields_parameter WHERE  (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE and param_name!=v_param_name ;

			ELSE
				SELECT lower(string_agg(concat('a.',param_name),E',\n    ' order by orderby)) as a_param,
				lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
				lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
				lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
				INTO v_old_parameters
				FROM man_addfields_parameter WHERE  (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE;
			END IF;
		
		END IF;

	--modify the configuration of the parameters and fields in config_api_form_fields
	IF v_action = 'CREATE' AND v_param_name not in (select param_name FROM man_addfields_parameter WHERE cat_feature_id IS NULL) THEN

		IF (SELECT count(id) FROM man_addfields_parameter WHERE cat_feature_id IS NULL AND active IS TRUE) = 0 THEN
			v_orderby = 10000;
		ELSE 
			EXECUTE 'SELECT max(orderby) + 1 FROM man_addfields_parameter'
			INTO v_orderby;
		END IF;
		
		INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, 
		active, orderby, iseditable)
		VALUES (v_param_name, NULL, v_ismandatory, v_add_datatype, v_field_length, v_num_decimals, 
		v_active, v_orderby, v_iseditable);
		
		SELECT max(layout_order) + 1 INTO v_param_user_id FROM audit_cat_param_user WHERE layout_id=22;

		IF v_param_user_id IS NULL THEN
			v_param_user_id=1;
		END IF;

		IF concat(v_param_name,'_vdefault') NOT IN (SELECT id FROM audit_cat_param_user) THEN
			INSERT INTO audit_cat_param_user (id, formname, description, sys_role_id, label,  isenabled, layout_id, layout_order, 
	      	project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, isdeprecated, dv_querytext, dv_querytext_filterc,feature_field_id )
			VALUES (concat(v_param_name,'_vdefault'),'config', concat('Default value of addfield ',v_param_name), 'role_edit', v_param_name,
			v_isenabled, 22, v_param_user_id, lower(v_project_type), false, false, v_audit_datatype, v_audit_widgettype, false, false,
			v_dv_querytext, v_dv_querytext_filterc,v_param_name );
		
		END IF;

	ELSIF v_action = 'UPDATE' THEN
		UPDATE man_addfields_parameter SET  is_mandatory=v_ismandatory, datatype_id=v_add_datatype,
		field_length=v_field_length, active=v_active, orderby=v_orderby, num_decimals=v_num_decimals, iseditable=v_iseditable 
		WHERE param_name=v_param_name and cat_feature_id IS NULL;

		UPDATE audit_cat_param_user SET datatype = v_audit_datatype, widgettype=v_audit_widgettype, dv_querytext = v_dv_querytext,
		dv_querytext_filterc = v_dv_querytext_filterc WHERE id = concat(v_param_name,'_vdefault');

	ELSIF v_action = 'DELETE' THEN

		DELETE FROM config_api_form_fields WHERE formname=v_viewname AND column_id=v_param_name;

		DELETE FROM audit_cat_param_user WHERE id = concat(v_param_name,'_vdefault');

	END IF;

	IF v_action = 'CREATE' THEN

		EXECUTE 'SELECT max(layout_order) + 1 FROM config_api_form_fields WHERE formname='''||v_viewname||'''
		AND layout_name = ''layout_data_1'';'
		INTO v_layout_order;

		--EXECUTE 'SELECT max(id) + 1 FROM config_api_form_fields;'
		--INTO v_form_fields_id;

		INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, 
		datatype, widgettype, label,field_length, num_decimals, ismandatory, isparent, iseditable, 
		isautoupdate, reload_field, layout_name, placeholder, stylesheet, typeahead, tooltip, widgetfunction, dv_isnullvalue, widgetdim,
		dv_parent_id, isnotupdate, dv_querytext_filterc, dv_querytext, listfilterparam,action_function,editability)
		VALUES (v_viewname, v_formtype, v_param_name, 1,v_layout_order,v_isenabled, v_config_datatype, v_config_widgettype,
		v_label, v_field_length, v_num_decimals, v_ismandatory, v_isparent, v_iseditable, v_isautoupdate, v_reload_field, 'layout_data_1',
		v_placeholder, v_stylesheet, v_typeahead, v_tooltip, v_widgetfunction, v_dv_isnullvalue, v_widgetdim,
		v_dv_parent_id, v_isnotupdate, v_dv_querytext_filterc, v_dv_querytext, v_listfilterparam, v_action_function, v_editability);

	ELSIF v_action = 'UPDATE' THEN
		UPDATE config_api_form_fields SET isenabled=v_isenabled,datatype=v_config_datatype,
		widgettype=v_config_widgettype, label=v_label,field_length=v_field_length, num_decimals=v_num_decimals, 
		ismandatory=v_ismandatory, isparent=v_isparent, iseditable=v_iseditable, isautoupdate=v_isautoupdate, 
		reload_field=v_reload_field, placeholder=v_placeholder, stylesheet=v_stylesheet, typeahead=v_typeahead, tooltip=v_tooltip, 
		widgetfunction=v_widgetfunction, dv_isnullvalue=v_dv_isnullvalue, widgetdim=v_widgetdim,
		dv_parent_id=v_dv_parent_id, isnotupdate=v_isnotupdate, dv_querytext_filterc=v_dv_querytext_filterc, 
		dv_querytext=v_dv_querytext, listfilterparam=v_listfilterparam,action_function=v_action_function,editability=v_editability 
		WHERE column_id=v_param_name AND formname=v_viewname;

	END IF;
	
		--get new values of addfields
	IF v_action='DELETE' THEN
		SELECT lower(string_agg(concat('a.',param_name),E',\n    '  order by orderby)) as a_param,
		lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
		lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
		lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
		INTO v_new_parameters
		FROM man_addfields_parameter WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE AND param_name!=v_param_name;
	ELSE
		SELECT lower(string_agg(concat('a.',param_name),E',\n    '  order by orderby)) as a_param,
		lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
		lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
		lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
		INTO v_new_parameters
		FROM man_addfields_parameter WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE;
		
	END IF;

		--select columns from man_* table without repeating the identifier
		EXECUTE 'SELECT DISTINCT string_agg(concat(''man_'||v_feature_system_id||'.'',column_name)::text,'', '')
		FROM information_schema.columns where table_name=''man_'||v_feature_system_id||''' and table_schema='''||v_schemaname||''' 
		and column_name!='''||v_feature_type||'_id'''
		INTO v_man_fields;
		

		--CREATE VIEW when the addfield is the 1st one for the  defined cat feature
	IF (SELECT count(id) FROM man_addfields_parameter WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) and active is true ) = 1 AND v_action = 'CREATE' THEN

			SELECT lower(string_agg(concat('a.',param_name),',' order by orderby)) as a_param,
				lower(string_agg(concat('ct.',param_name),',' order by orderby)) as ct_param,
				lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
				lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
				INTO v_created_addfields
				FROM man_addfields_parameter WHERE  (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) AND active IS TRUE;	
				
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
		
	END IF;

	--create trigger on view 
	EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(rec.id, ' ','_'),'-','_'),'.','_'))||' ON '||v_schemaname||'.'||v_viewname||';';

	EXECUTE 'CREATE TRIGGER gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(rec.id, ' ','_'),'-','_'),'.','_'))||'
	INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_schemaname||'.'||v_viewname||'
	FOR EACH ROW EXECUTE PROCEDURE '||v_schemaname||'.gw_trg_edit_'||v_feature_type||'('''||rec.id||''');';

	END LOOP;

	IF v_action='DELETE' THEN
		EXECUTE 'DELETE FROM man_addfields_parameter WHERE param_name='''||v_param_name||''';';
		EXECUTE 'DELETE FROM config_api_form_fields WHERE column_id='''||v_param_name||'''and formtype=''feature'';' ;
	
	ELSIF v_action='UPDATE' THEN 
		UPDATE man_addfields_parameter SET  is_mandatory=v_ismandatory, datatype_id=v_add_datatype,
		field_length=v_field_length,active=v_active, orderby=v_orderby, num_decimals=v_num_decimals WHERE param_name=v_param_name;		
	END IF;

--SIMPLE ADDFIELDS
ELSE
	
	SELECT max(orderby) INTO v_orderby FROM man_addfields_parameter WHERE cat_feature_id=v_cat_feature;
	IF v_orderby IS NULL THEN
		v_orderby = 1;
	ELSE
		v_orderby = v_orderby + 1;
	END IF;

	--check if field order will overlap the existing field	
	IF v_orderby IN (SELECT orderby FROM man_addfields_parameter WHERE cat_feature_id = v_cat_feature AND param_name!=v_param_name) THEN
		PERFORM audit_function(3016,2690);
	END IF;

	-- get view definition
	IF (SELECT child_layer FROM cat_feature WHERE id=v_cat_feature) IS NULL THEN
		UPDATE cat_feature SET child_layer=concat('ve_',lower(feature_type),'_',lower(id)) WHERE id=v_cat_feature;
	END IF;

	--remove spaces and dashes from view name
	IF (SELECT child_layer FROM cat_feature WHERE id=v_cat_feature AND (position('-' IN child_layer)>0 OR position(' ' IN child_layer)>0  
		OR position('.' IN child_layer)>0)) IS NOT NULL  THEN
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
	IF (SELECT count(id) FROM man_addfields_parameter WHERE cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) != 0 THEN
		SELECT lower(string_agg(concat('a.',param_name),E',\n    '  order by orderby)) as a_param,
		lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
		lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
		lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
		INTO v_old_parameters
		FROM man_addfields_parameter WHERE (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) AND active IS TRUE ;
	END IF;

	--modify the configuration of the parameters and fields in config_api_form_fields
	IF v_action = 'CREATE' THEN
		INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, num_decimals,
		active, orderby, iseditable)
		VALUES (v_param_name, v_cat_feature, v_ismandatory, v_add_datatype, v_num_decimals,
		v_active, v_orderby, v_iseditable);
	
		EXECUTE 'SELECT max(layout_order) + 1 FROM config_api_form_fields WHERE formname='''||v_viewname||'''
		AND layout_name = ''layout_data_1'';'
		INTO v_layout_order;

		EXECUTE 'SELECT max(id) + 1 FROM config_api_form_fields'
		INTO v_form_fields_id;

		INSERT INTO config_api_form_fields (id, formname, formtype, column_id, layout_id, layout_order, isenabled, 
		datatype, widgettype, label,field_length, num_decimals, ismandatory, isparent, iseditable, 
		isautoupdate, reload_field, layout_name, placeholder, stylesheet, typeahead, tooltip, widgetfunction, dv_isnullvalue, widgetdim,
		dv_parent_id, isnotupdate, dv_querytext_filterc, dv_querytext, listfilterparam,action_function,editability)
		VALUES (v_form_fields_id,v_viewname, v_formtype, v_param_name, 1,v_layout_order,v_isenabled, v_config_datatype, v_config_widgettype,
		v_label, v_field_length, v_num_decimals, v_ismandatory, v_isparent, v_iseditable, v_isautoupdate, v_reload_field, 'layout_data_1',
		v_placeholder, v_stylesheet, v_typeahead, v_tooltip, v_widgetfunction, v_dv_isnullvalue, v_widgetdim,
		v_dv_parent_id, v_isnotupdate, v_dv_querytext_filterc, v_dv_querytext, v_listfilterparam, v_action_function, v_editability);


		SELECT max(layout_order) + 1 INTO v_param_user_id FROM audit_cat_param_user WHERE layout_id=22;
		
		IF v_param_user_id IS NULL THEN
			v_param_user_id=1;
		END IF;

		INSERT INTO audit_cat_param_user (id, formname, description, sys_role_id, label,  isenabled, layout_id, layout_order, 
      	project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, isdeprecated,dv_querytext, dv_querytext_filterc, feature_field_id)
		VALUES (concat(v_param_name,'_',lower(v_cat_feature),'_vdefault'),'config', 
		concat('Default value of addfield ',v_param_name, ' for ', v_cat_feature), 
		'role_edit', v_param_name, v_isenabled, 22, v_param_user_id, lower(v_project_type), false, false, v_audit_datatype, 
		v_audit_widgettype, false, false, v_dv_querytext, v_dv_querytext_filterc, v_param_name);

	ELSIF v_action = 'UPDATE' THEN
		UPDATE man_addfields_parameter SET  is_mandatory=v_ismandatory, datatype_id=v_add_datatype,
		field_length=v_field_length, active=v_active, orderby=v_orderby, num_decimals=v_num_decimals,iseditable=v_iseditable 
		WHERE param_name=v_param_name AND cat_feature_id=v_cat_feature;
		
		IF (SELECT cat_feature_id FROM man_addfields_parameter WHERE param_name=v_param_name) IS NOT NULL THEN
			UPDATE config_api_form_fields SET isenabled=v_isenabled,datatype=v_config_datatype,
			widgettype=v_config_widgettype, label=v_label,field_length=v_field_length, num_decimals=v_num_decimals, 
			ismandatory=v_ismandatory, isparent=v_isparent, iseditable=v_iseditable, isautoupdate=v_isautoupdate, 
			reload_field=v_reload_field, placeholder=v_placeholder, stylesheet=v_stylesheet, typeahead=v_typeahead, tooltip=v_tooltip, 
			widgetfunction=v_widgetfunction, dv_isnullvalue=v_dv_isnullvalue, widgetdim=v_widgetdim,
			dv_parent_id=v_dv_parent_id, isnotupdate=v_isnotupdate, dv_querytext_filterc=v_dv_querytext_filterc, 
			dv_querytext=v_dv_querytext, listfilterparam=v_listfilterparam,action_function=v_action_function,editability=v_editability 
			WHERE column_id=v_param_name AND formname=v_viewname;
		END IF;

		UPDATE audit_cat_param_user SET datatype = v_audit_datatype, widgettype=v_audit_widgettype, dv_querytext = v_dv_querytext,
		dv_querytext_filterc = v_dv_querytext_filterc WHERE id = concat(v_param_name,'_',lower(v_cat_feature),'_vdefault');

	ELSIF v_action = 'DELETE' THEN
		EXECUTE 'DELETE FROM man_addfields_parameter WHERE param_name='''||v_param_name||''' AND cat_feature_id='''||v_cat_feature||''';';

		DELETE FROM audit_cat_param_user WHERE id = concat(v_param_name,'_',lower(v_cat_feature),'_vdefault');

		DELETE FROM config_api_form_fields WHERE formname=v_viewname AND column_id=v_param_name;

	END IF;

		--get new values of addfields
		SELECT lower(string_agg(concat('a.',param_name),E',\n    '  order by orderby)) as a_param,
		lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
		lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
		lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
		INTO v_new_parameters
		FROM man_addfields_parameter WHERE (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) AND active IS TRUE;
		
		--select columns from man_* table without repeating the identifier
		EXECUTE 'SELECT DISTINCT string_agg(concat(''man_'||v_feature_system_id||'.'',column_name)::text,'', '')
		FROM information_schema.columns where table_name=''man_'||v_feature_system_id||''' and table_schema='''||v_schemaname||''' 
		and column_name!='''||v_feature_type||'_id'''
		INTO v_man_fields;

		--CREATE VIEW when the addfield is the 1st one for the  defined cat feature
	IF (SELECT count(id) FROM man_addfields_parameter WHERE (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) and active is true ) = 1 
	AND v_action = 'CREATE' THEN
			
			SELECT lower(string_agg(concat('a.',param_name),E',\n    ' order by orderby)) as a_param,
				lower(string_agg(concat('ct.',param_name),E',\n            ' order by orderby)) as ct_param,
				lower(string_agg(concat('(''''',id,''''')'),',' order by orderby)) as id_param,
				lower(string_agg(concat(param_name,' ', datatype_id),', ' order by orderby)) as datatype
				INTO v_created_addfields
				FROM man_addfields_parameter WHERE  (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) AND active IS TRUE;	

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

		RAISE NOTICE 'SIMPLE - VIEW TYPE  ,%', v_view_type;

		v_man_fields := COALESCE(v_man_fields, 'null');

		v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
		"feature_type":"'||v_feature_type||'","feature_system_id":"'||v_feature_system_id||'","featurecat":"'||v_cat_feature||'","view_type":"'||v_view_type||'",
		"man_fields":"'||v_man_fields||'","a_param":"'||v_created_addfields.a_param||'","ct_param":"'||v_created_addfields.ct_param||'",
		"id_param":"'||v_created_addfields.id_param||'","datatype":"'||v_created_addfields.datatype||'"}}';
			
		PERFORM gw_fct_admin_manage_child_views_view(v_data_view);

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
		
	END IF;

	--create trigger on view 
	EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(v_cat_feature, ' ','_'),'-','_'),'.','_'))||' ON '||v_schemaname||'.'||v_viewname||';';

	EXECUTE 'CREATE TRIGGER gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(v_cat_feature, ' ','_'),'-','_'),'.','_'))||'
	INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_schemaname||'.'||v_viewname||'
	FOR EACH ROW EXECUTE PROCEDURE '||v_schemaname||'.gw_trg_edit_'||v_feature_type||'('''||v_cat_feature||''');';

END IF;

PERFORM SCHEMA_NAME.gw_fct_admin_role_permissions();
	--    Control NULL's
	--v_message := COALESCE(v_message, '');
	
	-- Return
	--RETURN ('{"message":{"priority":"'||v_priority||'", "text":"'||v_message||'"}}');	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;