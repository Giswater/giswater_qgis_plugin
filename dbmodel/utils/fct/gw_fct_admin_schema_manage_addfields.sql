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
"data":{"action":"CREATE", "field":"source_3", "datatype":"text", "widgettype":"QLineEdit", "label":"source_3","isMandatory":"False",
"fieldLength":"50", "numDecimals" :null, "defaultValue":null, "orderby":"2", "active":"True"}}$$);

SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${
"client":{"lang":"ES"}, 
"feature":{"catFeature":"SOURCE"},
"data":{"action":"UPDATE", "field":"source_3", "datatype":"numeric", "widgettype":"QLineEdit", "label":"source_3","isMandatory":"False",
"fieldLength":"50", "numDecimals" :null, "defaultValue":"446", "active":"True" }}$$);

SELECT SCHEMA_NAME.gw_fct_admin_manage_addfields($${
"client":{"lang":"ES"}, 
"feature":{"catFeature":"PUMP"},
"data":{"action":"DELETE", "field":"source_3"}}$$)
*/


DECLARE 
	v_schemaname text;
	v_cat_feature text;
	v_viewname text;
	v_definition text;
	v_ismandatory boolean;
	v_datatype text;
	v_field_length integer;
	v_num_decimals integer;
	v_default_value text;
	v_label text;
	v_widgettype text;
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
	v_chk_multi_insert boolean;
	v_dv_querytext_filterc text;
	v_isreload boolean;
	v_widgetfunction text;
	v_widgetdim integer;
	v_isautoupdate boolean;
	v_listfilterparam json;
	v_action_function text;
	v_editability json;
	v_update_old_datatype text;

BEGIN

	
	-- search path
	SET search_path = "SCHEMA_NAME", public;

 
	-- get input parameters -,man_addfields
	v_schemaname = 'SCHEMA_NAME';
	v_id = (SELECT nextval('man_addfields_parameter_id_seq') +1);

	v_param_name = (((p_data ->>'data')::json->>'parameters')::json->>'column_id')::text; 
	v_cat_feature = ((p_data ->>'feature')::json->>'catFeature')::text;
	v_ismandatory = (((p_data ->>'data')::json->>'parameters')::json->>'ismandatory')::text;
	v_datatype = (((p_data ->>'data')::json->>'parameters')::json->>'datatype')::text;
	v_field_length = (((p_data ->>'data')::json->>'parameters')::json->>'field_length')::text;
	v_num_decimals = (((p_data ->>'data')::json->>'parameters')::json->>'num_decimals')::text;
	v_default_value = (((p_data ->>'data')::json->>'parameters')::json->>'defaultValue')::text;
	v_label = (((p_data ->>'data')::json->>'parameters')::json->>'label')::text;
	v_widgettype = (((p_data ->>'data')::json->>'parameters')::json->>'widgettype')::text;
	v_action = ((p_data ->>'data')::json->>'action')::text;
	v_active = (((p_data ->>'data')::json->>'parameters')::json->>'active')::text;
	v_orderby = (((p_data ->>'data')::json->>'parameters')::json->>'orderby')::text;
	v_iseditable = (((p_data ->>'data')::json->>'parameters')::json ->>'iseditable')::text;

-- get input parameters - config_api_form_fields
	v_formtype = (((p_data ->>'data')::json->>'parameters')::json ->>'formtype')::text;
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
	v_chk_multi_insert = (((p_data ->>'data')::json->>'parameters')::json ->>'chk_multi_insert')::text;
	v_dv_querytext_filterc = (((p_data ->>'data')::json->>'parameters')::json ->>'dv_querytext_filterc')::text;
	v_isreload = (((p_data ->>'data')::json->>'parameters')::json ->>'isreload')::text;
	v_widgetfunction = (((p_data ->>'data')::json->>'parameters')::json ->>'widgetfunction')::text;
	v_widgetdim = (((p_data ->>'data')::json->>'parameters')::json ->>'widgetdim')::integer;
	v_isautoupdate = (((p_data ->>'data')::json->>'parameters')::json ->>'isautoupdate')::text;
	v_listfilterparam = (((p_data ->>'data')::json->>'parameters')::json ->>'listfilterparam')::json;



	--Assign config widget types 
	IF v_widgettype = 'QComboBox' THEN
		v_config_widgettype = 'combo';
	ELSIF v_widgettype = 'QCheckBox' THEN
		v_config_widgettype = 'check';
	ELSIF v_widgettype='QDateTimeEdit' THEN
		v_config_widgettype = 'datepickertime';
	ELSIF v_widgettype='QDoubleSpinBox' or v_widgettype='QSpinBox' THEN
		v_config_widgettype = 'doubleSpinbox';
	ELSIF v_widgettype = 'QTextEdit' THEN
		v_config_widgettype = 'textarea';
	ELSE 
		v_config_widgettype = 'text';
	END IF;

raise notice 'v_chk_multi_insert,%',v_chk_multi_insert;

IF v_chk_multi_insert IS TRUE THEN

	IF v_action='UPDATE' THEN
		v_update_old_datatype = (SELECT datatype_id FROM man_addfields_parameter WHERE param_name=v_param_name);
	END IF;

	FOR rec IN (SELECT * FROM cat_feature WHERE active IS TRUE ORDER BY id) LOOP

		IF v_action='UPDATE' THEN
			UPDATE man_addfields_parameter SET datatype_id=v_update_old_datatype where param_name=v_param_name AND cat_feature_id IS NULL;
		END IF;
		-- get view definition
		IF (SELECT child_layer FROM cat_feature WHERE id=rec.id) IS NULL THEN
			UPDATE cat_feature SET child_layer=concat('ve_',type,'_',lower(id)) WHERE id=rec.id;
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
		v_feature_type = (SELECT type FROM cat_feature where id=rec.id);
		v_feature_system_id  = (SELECT lower(system_id) FROM cat_feature where id=rec.id);

	raise notice '1/rec.id,% ,%' , rec.id,v_feature_type;	
		--get old values of addfields
		IF (SELECT count(id) FROM man_addfields_parameter WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE) != 0 THEN
			IF v_action='CREATE' THEN
				SELECT string_agg(concat('a.',param_name),E',\n    ' order by orderby) as a_param,
				string_agg(concat('ct.',param_name),E',\n            ' order by orderby) as ct_param,
				string_agg(concat('(''''',id,''''')'),',' order by orderby) as id_param,
				string_agg(concat(param_name,' ', datatype_id),', ' order by orderby) as datatype
				INTO v_old_parameters
				FROM man_addfields_parameter WHERE  (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE and param_name!=v_param_name ;

			ELSE
				SELECT string_agg(concat('a.',param_name),E',\n    ' order by orderby) as a_param,
				string_agg(concat('ct.',param_name),E',\n            ' order by orderby) as ct_param,
				string_agg(concat('(''''',id,''''')'),',' order by orderby) as id_param,
				string_agg(concat(param_name,' ', datatype_id),', ' order by orderby) as datatype
				INTO v_old_parameters
				FROM man_addfields_parameter WHERE  (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE;
			END IF;
			raise notice '1/v_old_parameters,% ' , v_old_parameters;
		END IF;

	--modify the configuration of the parameters and fields in config_api_form_fields
	IF v_action = 'CREATE' AND v_param_name not in (select param_name FROM man_addfields_parameter WHERE cat_feature_id IS NULL) THEN

		IF (SELECT count(id) FROM man_addfields_parameter WHERE cat_feature_id IS NULL AND active IS TRUE) = 0 THEN
			v_orderby = 10000;
		ELSE 
			EXECUTE 'SELECT max(orderby) + 1 FROM man_addfields_parameter'
			INTO v_orderby;
		END IF;
	RAISE NOTICE 'v_orderby,%',v_orderby;
		INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, 
		default_value, form_label, widgettype_id, active, orderby)
		VALUES (v_param_name, NULL, v_ismandatory, v_datatype, v_field_length, v_num_decimals, 
		v_default_value, v_label, v_widgettype, v_active, v_orderby);
	
		raise notice '2/INSERT ADD';

	ELSIF v_action = 'UPDATE' THEN
		UPDATE man_addfields_parameter SET  is_mandatory=v_ismandatory, datatype_id=v_datatype,
		field_length=v_field_length, default_value=v_default_value, form_label=v_label, widgettype_id=v_widgettype,
		active=v_active, orderby=v_orderby, num_decimals=v_num_decimals WHERE param_name=v_param_name;

	ELSIF v_action = 'DELETE' THEN

		DELETE FROM config_api_form_fields WHERE formname=v_viewname AND column_id=v_param_name;

	END IF;

	IF v_action = 'CREATE' THEN
		raise notice '2/INSERT CONFIG';
		EXECUTE 'SELECT max(layout_order) + 1 FROM config_api_form_fields WHERE formname='''||v_viewname||'''
		AND layout_name = ''layout_data_1'';'
		INTO v_layout_order;

		EXECUTE 'SELECT max(id) + 1 FROM config_api_form_fields;'
		INTO v_form_fields_id;

		INSERT INTO config_api_form_fields (id, formname, formtype, column_id, layout_id, layout_order, isenabled, 
		datatype, widgettype, label,field_length, num_decimals, ismandatory, isparent, iseditable, 
		isautoupdate, isreload, layout_name, placeholder, stylesheet, typeahead, tooltip, widgetfunction, dv_isnullvalue, widgetdim,
		dv_parent_id, isnotupdate, dv_querytext_filterc, dv_querytext, listfilterparam,action_function,editability)
		VALUES (v_form_fields_id,v_viewname, v_formtype, v_param_name, 1,v_layout_order,v_isenabled, v_datatype, v_config_widgettype,
		v_label, v_field_length, v_num_decimals, v_ismandatory, v_isparent, v_iseditable, v_isautoupdate, v_isreload, 'layout_data_1',
		v_placeholder, v_stylesheet, v_typeahead, v_tooltip, v_widgetfunction, v_dv_isnullvalue, v_widgetdim,
		v_dv_parent_id, v_isnotupdate, v_dv_querytext_filterc, v_dv_querytext, v_listfilterparam, v_action_function, v_editability);
	END IF;
	
		--get new values of addfields
	IF v_action='DELETE' THEN
		SELECT string_agg(concat('a.',param_name),E',\n    '  order by orderby) as a_param,
		string_agg(concat('ct.',param_name),E',\n            ' order by orderby) as ct_param,
		string_agg(concat('(''''',id,''''')'),',' order by orderby) as id_param,
		string_agg(concat(param_name,' ', datatype_id),', ' order by orderby) as datatype
		INTO v_new_parameters
		FROM man_addfields_parameter WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE AND param_name!=v_param_name;
	ELSE
		SELECT string_agg(concat('a.',param_name),E',\n    '  order by orderby) as a_param,
		string_agg(concat('ct.',param_name),E',\n            ' order by orderby) as ct_param,
		string_agg(concat('(''''',id,''''')'),',' order by orderby) as id_param,
		string_agg(concat(param_name,' ', datatype_id),', ' order by orderby) as datatype
		INTO v_new_parameters
		FROM man_addfields_parameter WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE;
		
	END IF;
	raise notice '2/v_new_parameters,%',v_new_parameters;
raise notice '3/';
		--select columns from man_* table without repeating the identifier
		EXECUTE 'SELECT DISTINCT string_agg(concat(''man_'||v_feature_system_id||'.'',column_name)::text,'', '')
		FROM information_schema.columns where table_name=''man_'||v_feature_system_id||''' and table_schema='''||v_schemaname||''' 
		and column_name!='''||v_feature_type||'_id'''
		INTO v_man_fields;
		
raise notice '4/';
		--CREATE VIEW when the addfield is the 1st one for the  defined cat feature
	IF (SELECT count(id) FROM man_addfields_parameter WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) and active is true ) = 1 AND v_action = 'CREATE' THEN
	raise notice '4/addfields=1,v_man_fields,%',v_man_fields;		
		IF (v_feature_type='arc' OR v_feature_type='node') THEN
		
			raise notice '4/NODE/ARC';
			
			IF v_man_fields IS NULL THEN
				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
		
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_'||v_feature_type||'.*,
				a.'||v_param_name||'
				FROM '||v_schemaname||'.v_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_'||v_feature_type||'.'||v_feature_type||'_id
				LEFT JOIN (SELECT ct.feature_id, ct.'||v_param_name||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
				FROM '||v_schemaname||'.man_addfields_value JOIN '||v_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
				WHERE cat_feature_id='''''||rec.id||''''' ORDER BY 1,2''::text, 
				''VALUES ('''''||v_id||''''')''::text) ct(feature_id character varying,'||v_param_name||' '||v_datatype||' )) a 
				ON a.feature_id::text=v_'||v_feature_type||'.'||v_feature_type||'_id;';

			
			ELSE
				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_'||v_feature_type||'.*,
				'||v_man_fields||',
				a.'||v_param_name||'
				FROM '||v_schemaname||'.v_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
				ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_'||v_feature_type||'.'||v_feature_type||'_id
				LEFT JOIN (SELECT ct.feature_id, ct.'||v_param_name||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
				FROM '||v_schemaname||'.man_addfields_value JOIN '||v_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
				WHERE cat_feature_id='''''||rec.id||''''' ORDER BY 1,2''::text, 
				''VALUES ('''''||v_id||''''')''::text) ct(feature_id character varying,'||v_param_name||' '||v_datatype||' )) a 
				ON a.feature_id::text=v_'||v_feature_type||'.'||v_feature_type||'_id;';
			
			END IF;

		ELSE
			raise notice '4/CONNEC/GULLY';
			IF v_man_fields IS NULL THEN
				
				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
		
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_edit_'||v_feature_type||'.*,
				a.'||v_param_name||'
				FROM '||v_schemaname||'.v_edit_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_edit_'||v_feature_type||'.'||v_feature_type||'_id
				LEFT JOIN (SELECT ct.feature_id, ct.'||v_param_name||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
				FROM '||v_schemaname||'.man_addfields_value JOIN '||v_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
				WHERE cat_feature_id='''''||rec.id||''''' ORDER BY 1,2''::text, 
				''VALUES ('''''||v_id||''''')''::text) ct(feature_id character varying,'||v_param_name||' '||v_datatype||' )) a 
				ON a.feature_id::text=v_edit_'||v_feature_type||'.'||v_feature_type||'_id;';

			
			ELSE
				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_edit_'||v_feature_type||'.*,
				'||v_man_fields||',
				a.'||v_param_name||'
				FROM '||v_schemaname||'.v_edit_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
				ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_edit_'||v_feature_type||'.'||v_feature_type||'_id
				LEFT JOIN (SELECT ct.feature_id, ct.'||v_param_name||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
				FROM '||v_schemaname||'.man_addfields_value JOIN '||v_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
				WHERE cat_feature_id='''''||rec.id||''''' ORDER BY 1,2''::text, 
				''VALUES ('''''||v_id||''''')''::text) ct(feature_id character varying,'||v_param_name||' '||v_datatype||' )) a 
				ON a.feature_id::text=v_edit_'||v_feature_type||'.'||v_feature_type||'_id;';
			
			END IF;
		END IF;
	--CREATE VIEW when the addfields don't exist (after delete)
	ELSIF v_new_parameters is null THEN 
	raise notice '4/ADDFIELDS DONT EXIST';
		IF (v_feature_type='arc' OR v_feature_type='node') THEN
			IF v_man_fields IS NULL THEN
			
				EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_'||v_feature_type||'.*
				FROM '||v_schemaname||'.v_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
				ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_'||v_feature_type||'.'||v_feature_type||'_id;';

			ELSE
			
				EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_'||v_feature_type||'.*,
				'||v_man_fields||'
				FROM '||v_schemaname||'.v_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
				ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_'||v_feature_type||'.'||v_feature_type||'_id;';

			END IF;
		ELSE
				IF v_man_fields IS NULL THEN
			
				EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_edit_'||v_feature_type||'.*
				FROM '||v_schemaname||'.v_edit_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
				ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_edit_'||v_feature_type||'.'||v_feature_type||'_id;';

			ELSE
			
				EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_edit_'||v_feature_type||'.*,
				'||v_man_fields||'
				FROM '||v_schemaname||'.v_edit_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
				ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_edit_'||v_feature_type||'.'||v_feature_type||'_id;';

			END IF;
		END IF;
	ELSE	
		raise notice '4/REPLACE VIEW';
		IF (SELECT EXISTS ( SELECT 1 FROM   information_schema.tables WHERE  table_schema = v_schemaname AND table_name = v_viewname)) IS TRUE THEN
			EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
		END IF;
		raise notice '4/REPLACE VIEW2';
		--update the current view defintion
		v_definition = replace(v_definition,v_old_parameters.ct_param,v_new_parameters.ct_param);
		v_definition = replace(v_definition,v_old_parameters.a_param,v_new_parameters.a_param);
		v_definition = replace(v_definition,v_old_parameters.id_param,v_new_parameters.id_param);
		
		raise notice '4/REPLACE VIEW3,%,%',v_old_parameters.datatype,v_new_parameters.datatype;
		v_definition = replace(v_definition,v_old_parameters.datatype,v_new_parameters.datatype);

		
		--replace the existing view and create the trigger
		EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS '||v_definition||';';
		
	END IF;
	raise notice '5/';
	--create trigger on view 
	EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(rec.id, ' ','_'),'-','_'),'.','_'))||' ON '||v_schemaname||'.'||v_viewname||';';

	EXECUTE 'CREATE TRIGGER gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(rec.id, ' ','_'),'-','_'),'.','_'))||'
	INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_schemaname||'.'||v_viewname||'
	FOR EACH ROW EXECUTE PROCEDURE '||v_schemaname||'.gw_trg_edit_'||v_feature_type||'('''||rec.id||''');';

	END LOOP;

	IF v_action='DELETE' THEN
		EXECUTE 'DELETE FROM man_addfields_parameter WHERE param_name='''||v_param_name||''';';

	ELSIF v_action='UPDATE' THEN 
		UPDATE man_addfields_parameter SET  is_mandatory=v_ismandatory, datatype_id=v_datatype,
		field_length=v_field_length, default_value=v_default_value, form_label=v_label, widgettype_id=v_widgettype ,
		active=v_active, orderby=v_orderby, num_decimals=v_num_decimals WHERE param_name=v_param_name;
	
	raise notice '2/update ADD,%',v_datatype;		
	END IF;

--SIMPLE ADDFIELDS
ELSE

	--check if field order will overlap the existing field	
	IF v_orderby IN (SELECT orderby FROM man_addfields_parameter WHERE cat_feature_id=v_cat_feature) THEN
		PERFORM audit_function(2690,3016);
	END IF;

	-- get view definition
	IF (SELECT child_layer FROM cat_feature WHERE id=v_cat_feature) IS NULL THEN
		UPDATE cat_feature SET child_layer=concat('ve_',type,'_',lower(id)) WHERE id=v_cat_feature;
	END IF;

	--remove spaces and dashs from view name
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
	v_feature_type = (SELECT type FROM cat_feature where id=v_cat_feature);
	v_feature_system_id  = (SELECT lower(system_id) FROM cat_feature where id=v_cat_feature);

	--get old values of addfields
	IF (SELECT count(id) FROM man_addfields_parameter WHERE cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) != 0 THEN
		SELECT string_agg(concat('a.',param_name),E',\n    ' order by orderby) as a_param,
		string_agg(concat('ct.',param_name),E',\n            ' order by orderby) as ct_param,
		string_agg(concat('(''''',id,''''')'),',' order by orderby) as id_param,
		string_agg(concat(param_name,' ', datatype_id),', ' order by orderby) as datatype
		INTO v_old_parameters
		FROM man_addfields_parameter WHERE (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) AND active IS TRUE ;
	END IF;

	--modify the configuration of the parameters and fields in config_api_form_fields
	IF v_action = 'CREATE' THEN
		INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, 
		default_value, form_label, widgettype_id, active, orderby)
		VALUES (v_param_name, v_cat_feature, v_ismandatory, v_datatype, v_field_length, v_num_decimals, 
		v_default_value, v_label, v_widgettype, v_active, v_orderby);
	
		EXECUTE 'SELECT max(layout_order) + 1 FROM config_api_form_fields WHERE formname='''||v_viewname||'''
		AND layout_name = ''layout_data_1'';'
		INTO v_layout_order;

		EXECUTE 'SELECT max(id) + 1 FROM config_api_form_fields'
		INTO v_form_fields_id;

		INSERT INTO config_api_form_fields (id, formname, formtype, column_id, layout_id, layout_order, isenabled, 
		datatype, widgettype, label,field_length, num_decimals, ismandatory, isparent, iseditable, 
		isautoupdate, isreload, layout_name, placeholder, stylesheet, typeahead, tooltip, widgetfunction, dv_isnullvalue, widgetdim,
		dv_parent_id, isnotupdate, dv_querytext_filterc, dv_querytext, listfilterparam,action_function,editability)
		VALUES (v_form_fields_id,v_viewname, v_formtype, v_param_name, 1,v_layout_order,v_isenabled, v_datatype, v_config_widgettype,
		v_label, v_field_length, v_num_decimals, v_ismandatory, v_isparent, v_iseditable, v_isautoupdate, v_isreload, 'layout_data_1',
		v_placeholder, v_stylesheet, v_typeahead, v_tooltip, v_widgetfunction, v_dv_isnullvalue, v_widgetdim,
		v_dv_parent_id, v_isnotupdate, v_dv_querytext_filterc, v_dv_querytext, v_listfilterparam, v_action_function, v_editability);

	ELSIF v_action = 'UPDATE' THEN
		UPDATE man_addfields_parameter SET  is_mandatory=v_ismandatory, datatype_id=v_datatype,
		field_length=v_field_length, default_value=v_default_value, form_label=v_label, widgettype_id=v_widgettype ,
		active=v_active, orderby=v_orderby, num_decimals=v_num_decimals WHERE param_name=v_param_name AND cat_feature_id=v_cat_feature;
			
	ELSIF v_action = 'DELETE' THEN
		EXECUTE 'DELETE FROM man_addfields_parameter WHERE param_name='''||v_param_name||''' AND cat_feature_id='''||v_cat_feature||''';';

		DELETE FROM config_api_form_fields WHERE formname=v_viewname AND column_id=v_param_name;

	END IF;

		--get new values of addfields
		SELECT string_agg(concat('a.',param_name),E',\n    '  order by orderby) as a_param,
		string_agg(concat('ct.',param_name),E',\n            ' order by orderby) as ct_param,
		string_agg(concat('(''''',id,''''')'),',' order by orderby) as id_param,
		string_agg(concat(param_name,' ', datatype_id),', ' order by orderby) as datatype
		INTO v_new_parameters
		FROM man_addfields_parameter WHERE (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) AND active IS TRUE;
		

		--select columns from man_* table without repeating the identifier
		EXECUTE 'SELECT DISTINCT string_agg(concat(''man_'||v_feature_system_id||'.'',column_name)::text,'', '')
		FROM information_schema.columns where table_name=''man_'||v_feature_system_id||''' and table_schema='''||v_schemaname||''' 
		and column_name!='''||v_feature_type||'_id'''
		INTO v_man_fields;

		--CREATE VIEW when the addfield is the 1st one for the  defined cat feature
	IF (SELECT count(id) FROM man_addfields_parameter WHERE (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) and active is true ) = 1 AND v_action = 'CREATE' THEN
		IF (v_feature_type='arc' OR v_feature_type='node') THEN
			IF v_man_fields IS NULL THEN
				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_'||v_feature_type||'.*,
				a.'||v_param_name||'
				FROM '||v_schemaname||'.v_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_'||v_feature_type||'.'||v_feature_type||'_id
				LEFT JOIN (SELECT ct.feature_id, ct.'||v_param_name||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
				FROM '||v_schemaname||'.man_addfields_value JOIN '||v_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
				WHERE cat_feature_id='''''||v_cat_feature||''''' ORDER BY 1,2''::text, 
				''VALUES ('''''||v_id||''''')''::text) ct(feature_id character varying,'||v_param_name||' '||v_datatype||' )) a 
				ON a.feature_id::text=v_'||v_feature_type||'.'||v_feature_type||'_id;';
			
			ELSE
				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_'||v_feature_type||'.*,
				'||v_man_fields||',
				a.'||v_param_name||'
				FROM '||v_schemaname||'.v_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
				ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_'||v_feature_type||'.'||v_feature_type||'_id
				LEFT JOIN (SELECT ct.feature_id, ct.'||v_param_name||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
				FROM '||v_schemaname||'.man_addfields_value JOIN '||v_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
				WHERE cat_feature_id='''''||v_cat_feature||''''' ORDER BY 1,2''::text, 
				''VALUES ('''''||v_id||''''')''::text) ct(feature_id character varying,'||v_param_name||' '||v_datatype||' )) a 
				ON a.feature_id::text=v_'||v_feature_type||'.'||v_feature_type||'_id;';
			
			END IF;
		ELSE
			IF v_man_fields IS NULL THEN
				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_edit_'||v_feature_type||'.*,
				a.'||v_param_name||'
				FROM '||v_schemaname||'.v_edit_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_edit_'||v_feature_type||'.'||v_feature_type||'_id
				LEFT JOIN (SELECT ct.feature_id, ct.'||v_param_name||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
				FROM '||v_schemaname||'.man_addfields_value JOIN '||v_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
				WHERE cat_feature_id='''''||v_cat_feature||''''' ORDER BY 1,2''::text, 
				''VALUES ('''''||v_id||''''')''::text) ct(feature_id character varying,'||v_param_name||' '||v_datatype||' )) a 
				ON a.feature_id::text=v_edit_'||v_feature_type||'.'||v_feature_type||'_id;';
			
			ELSE
				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_edit_'||v_feature_type||'.*,
				'||v_man_fields||',
				a.'||v_param_name||'
				FROM '||v_schemaname||'.v_edit_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
				ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_edit_'||v_feature_type||'.'||v_feature_type||'_id
				LEFT JOIN (SELECT ct.feature_id, ct.'||v_param_name||' FROM crosstab (''SELECT feature_id, parameter_id, value_param
				FROM '||v_schemaname||'.man_addfields_value JOIN '||v_schemaname||'.man_addfields_parameter ON man_addfields_parameter.id=parameter_id
				WHERE cat_feature_id='''''||v_cat_feature||''''' ORDER BY 1,2''::text, 
				''VALUES ('''''||v_id||''''')''::text) ct(feature_id character varying,'||v_param_name||' '||v_datatype||' )) a 
				ON a.feature_id::text=v_edit_'||v_feature_type||'.'||v_feature_type||'_id;';
			
			END IF;
		END IF;
	--CREATE VIEW when the addfields don't exist (after delete)
	ELSIF v_new_parameters is null THEN 
		IF (v_feature_type='arc' OR v_feature_type='node') THEN
			IF v_man_fields IS NULL THEN
			
				EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_'||v_feature_type||'.*
				FROM '||v_schemaname||'.v_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
				ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_'||v_feature_type||'.'||v_feature_type||'_id;';

			ELSE
			
				EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
				SELECT v_'||v_feature_type||'.*,
				'||v_man_fields||'
				FROM '||v_schemaname||'.v_'||v_feature_type||'
				JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
				ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_'||v_feature_type||'.'||v_feature_type||'_id;';

			END IF;
		--connec & gully
		ELSE
				IF v_man_fields IS NULL THEN
			
					EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
					EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
					SELECT v_edit_'||v_feature_type||'.*
					FROM '||v_schemaname||'.v_edit_'||v_feature_type||'
					JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
					ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_edit_'||v_feature_type||'.'||v_feature_type||'_id;';

				ELSE
			
					EXECUTE  'DROP VIEW IF EXISTS '||v_schemaname||'.'||v_viewname||';';
					EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS
					SELECT v_edit_'||v_feature_type||'.*,
					'||v_man_fields||'
					FROM '||v_schemaname||'.v_edit_'||v_feature_type||'
					JOIN '||v_schemaname||'.man_'||v_feature_system_id||' 
					ON man_'||v_feature_system_id||'.'||v_feature_type||'_id = v_edit_'||v_feature_type||'.'||v_feature_type||'_id;';

				END IF;
		END IF;
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
	--    Control NULL's
	--v_message := COALESCE(v_message, '');
	
	-- Return
	--RETURN ('{"message":{"priority":"'||v_priority||'", "text":"'||v_message||'"}}');	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
