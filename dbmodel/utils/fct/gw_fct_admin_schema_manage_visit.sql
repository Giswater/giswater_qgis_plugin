/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2746

--drop function SCHEMA_NAME.gw_fct_admin_manage_visit(json)
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_visit(p_data json)
  RETURNS void AS
$BODY$

/*EXAMPLE

SINGLE EVENT
SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"NODE"},
"data":{"action":"CREATE", "action_type":"class", "parameters":{"class_name":"LEAK_NODE67","parameter_id":"param_leak_node67", "active":"True","ismultifeature":"false","ismultievent":"False",
"visit_type":1,  "parameter_type":"INSPECTION", "data_type":"text", "code":"123", 
"v_param_options":null, "form_type":"event_standard","vdefault":null, "short_descript":null, "viewname":"aaa_ve_node_leak67"}}}$$);

		SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"NODE"},
		"data":{"action":"CREATE", "action_type":"parameter", "parameters":{"class_name":"LEAK_NODE67","parameter_id":"param_leak_node67", "active":"True","ismultifeature":"false","ismultievent":"False",
		"visit_type":1,  "parameter_type":"INSPECTION", "data_type":"integer", "code":"123", 
		"v_param_options":null, "form_type":"event_standard","vdefault":1, "short_descript":null, "viewname":"aaa_ve_node_leak67","isenabled":"True",
		"widgettype":"text", "isenabled":"True", "iseditable":"True", "ismandatory":"True", "dv_querytext":null}}}$$);

-------------


SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"NODE"},
"data":{"action":"CREATE", "action_type":"class", "parameters":{"class_name":"LEAK_NODE","parameter_id":"param_leak_node", "active":"True","ismultifeature":"false","ismultievent":"True",
"visit_type":1,  "parameter_type":"INSPECTION", "data_type":"text", "code":"123", 
"v_param_options":null, "form_type":"event_standard","vdefault":null, "short_descript":null, "viewname":"aaa_ve_node_leak"}}}$$);

		SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"NODE"},
		"data":{"action":"CREATE", "action_type":"parameter", "parameters":{"class_name":"LEAK_NODE","parameter_id":"param_leak_node28", "active":"True","ismultifeature":"false","ismultievent":"True",
		"visit_type":1,  "parameter_type":"INSPECTION", "data_type":"text", "code":"123", 
		"v_param_options":null, "form_type":"event_standard","vdefault":1, "short_descript":null, "viewname":"aaa_ve_node_leak","isenabled":"True",
		"widgettype":"text", "isenabled":"True", "iseditable":"True", "ismandatory":"True", "dv_querytext":null}}}$$);

SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"NODE"},
"data":{"action":"UPDATE", "action_type":"parameter", "parameters":{"class_name":"LEAK_NODE","parameter_id":"param_leak_node3", "active":"True","ismultifeature":"false","ismultievent":"True",
"visit_type":1,  "parameter_type":"INSPECTION", "data_type":"text", "code":"aaa", 
"v_param_options":null, "form_type":"event_standard","vdefault":null, "short_descript":"true", "viewname":"aaa_ve_node_leak","widgettype":"combo",
"isenabled":"True", "iseditable":"True", "ismandatory":"True", "dv_querytext":"SELECT muni_id as id, name as idval FROM ext_municipality"}}}$$);


SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"NODE"},
"data":{"action":"UPDATE", "action_type":"class", "parameters":{"class_id":"20","class_name":"LEAK_NODE","parameter_id":"param_leak_node", "active":"True","ismultifeature":"false","ismultievent":"True",
"visit_type":1,  "parameter_type":"INSPECTION", "data_type":"text", "code":"777", 
"v_param_options":null, "form_type":"event_standard","vdefault":null, "short_descript":"true", "viewname":"aaa_ve_node_leak","widgettype":"combo",
"isenabled":"True", "iseditable":"True", "ismandatory":"True", "dv_querytext":"SELECT muni_id as id, name as idval FROM ext_municipality"}}}$$);


SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"NODE"},
"data":{"action":"DELETE", "action_type":"class", "parameters":{"class_id":"9"}}}$$);

SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"NODE"},
"data":{"action":"DELETE", "action_type":"parameter","parameters":{"class_id":"9","class_name":"LEAK_NODE","parameter_id":"param_leak_node4",
"viewname":"aaa_ve_node_leak","ismultievent":"true"}}}$$);


SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"NODE"},
"data":{"action":"CONFIGURATION", "action_type":"null","parameters":{"class_id":"16", "viewname":"ve_visit_node_test"}}}$$);

*/

DECLARE 
	v_schemaname text;
	v_project_type text;

	v_feature_system_id text;
	v_class_name text;
	v_active boolean;
	v_visit_type integer;
	v_ismultievent boolean;
	v_ismultifeature boolean;
	v_data_type text;
	v_config_data_type text;
	v_parameter_type text;
	v_descript text;
	v_form_type text;
	v_vdefault text;
	v_short_descript text;
	v_action text;
	v_param_options json;
	v_class_id integer;
	v_action_type text;
	v_param_name text;
	v_code text;
	v_widgettype text;
	v_data_view json;
	
	v_om_visit_x_feature_fields text;
	v_om_visit_fields text;
	v_old_parameters record;
	v_new_parameters record;
	v_viewname text;
	v_definition text;
	v_old_viewname text;
	v_config_fields text;
	rec record;
	v_layout_order integer;
	v_isenabled boolean;
	v_dv_querytext text;
	v_ismandatory boolean;
	v_iseditable boolean;
	
BEGIN

	
	-- search path
	SET search_path = "SCHEMA_NAME", public;

 	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;

	-- get input parameters -,man_addfields
	v_schemaname = 'SCHEMA_NAME';
	--v_id = (SELECT nextval('man_addfields_parameter_id_seq') +1);

	v_action = ((p_data ->>'data')::json->>'action')::text;
	v_action_type = ((p_data ->>'data')::json->>'action_type')::text;

	v_viewname = (((p_data ->>'data')::json->>'parameters')::json->>'viewname')::text; 
	v_class_id = (((p_data ->>'data')::json->>'parameters')::json->>'class_id')::integer; 
	v_class_name = (((p_data ->>'data')::json->>'parameters')::json->>'class_name')::text; 
	v_feature_system_id = lower(((p_data ->>'feature')::json->>'feature_type')::text);
	v_active = (((p_data ->>'data')::json->>'parameters')::json->>'active')::text;
	v_visit_type = (((p_data ->>'data')::json->>'parameters')::json->>'visit_type')::text;
	v_ismultievent = (((p_data ->>'data')::json->>'parameters')::json->>'ismultievent')::boolean;
	v_ismultifeature = (((p_data ->>'data')::json->>'parameters')::json->>'ismultifeature')::text;
	v_param_name = (((p_data ->>'data')::json->>'parameters')::json->>'parameter_id')::text; 

	v_data_type = (((p_data ->>'data')::json->>'parameters')::json->>'data_type')::text; 
	v_parameter_type = (((p_data ->>'data')::json->>'parameters')::json->>'parameter_type')::text;
	v_code = (((p_data ->>'data')::json->>'parameters')::json->>'code')::text;
	v_descript = (((p_data ->>'data')::json->>'parameters')::json->>'descript')::text;
	v_form_type = (((p_data ->>'data')::json->>'parameters')::json->>'form_type')::text;
	v_vdefault = (((p_data ->>'data')::json->>'parameters')::json->>'default')::text;
	v_short_descript = (((p_data ->>'data')::json->>'parameters')::json->>'short_descript')::text;
	v_param_options = (((p_data ->>'data')::json->>'parameters')::json->>'v_param_options')::json;
	v_widgettype = (((p_data ->>'data')::json->>'parameters')::json->>'widgettype')::text;
	v_isenabled = (((p_data ->>'data')::json->>'parameters')::json->>'isenabled')::boolean;

	v_ismandatory = (((p_data ->>'data')::json->>'parameters')::json->>'ismandatory')::boolean;
	v_iseditable = (((p_data ->>'data')::json->>'parameters')::json->>'iseditable')::text;
	v_dv_querytext = (((p_data ->>'data')::json->>'parameters')::json->>'dv_querytext')::text;

	IF v_data_type = 'text' THEN 
		v_config_data_type = 'string';
	END IF;
	
	--capture the id of the class
	IF v_class_id IS NULL AND  v_action_type = 'parameter' THEN
		SELECT id INTO v_class_id FROM om_visit_class WHERE idval = v_class_name;
	END IF;
	
	--capture current parameters related to the class
	SELECT string_agg(concat('a.',om_visit_parameter.id),',' order by om_visit_parameter.id) as a_param,
	string_agg(concat('ct.',om_visit_parameter.id),',' order by om_visit_parameter.id) as ct_param,
	string_agg(concat('(''''',om_visit_parameter.id,''''')'),',' order by om_visit_parameter.id) as id_param,
	string_agg(concat(om_visit_parameter.id,' ', lower(om_visit_parameter.data_type)),', ' order by om_visit_parameter.id) as datatype
	INTO v_old_parameters
	FROM om_visit_parameter JOIN om_visit_class_x_parameter ON om_visit_parameter.id=om_visit_class_x_parameter.parameter_id
	WHERE class_id=v_class_id;

	raise notice 'v_old_parameters,%,%',v_old_parameters,v_class_id;

	--reset the value of sequence for tables where data will be inserted
	PERFORM setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);
	PERFORM setval('SCHEMA_NAME.om_visit_class_id_seq', (SELECT max(id) FROM om_visit_class), true);
--	PERFORM setval('SCHEMA_NAME.config_api_visit_id_seq', (SELECT max(id) FROM config_api_visit), true);
	PERFORM setval('SCHEMA_NAME.om_visit_class_x_parameter_id_seq', (SELECT max(id) FROM om_visit_class_x_parameter), true);

IF v_action = 'CREATE' THEN
	--insert new class and parameter
	IF v_action_type = 'class' THEN
		INSERT INTO om_visit_class (idval, descript, active, ismultifeature, ismultievent, feature_type, sys_role_id, visit_type, param_options)
		VALUES (v_class_name, v_descript, v_active, v_ismultifeature, v_ismultievent,upper(v_feature_system_id), 'role_om', v_visit_type, v_param_options::json)
		RETURNING id INTO v_class_id;

		--insert values into api config
		IF (SELECT visitclass_id FROM config_api_visit WHERE visitclass_id = v_class_id) IS NULL THEN
			IF v_ismultievent = TRUE THEN
				INSERT INTO config_api_visit (visitclass_id, formname, tablename) VALUES (v_class_id, v_viewname, v_viewname);
			ELSE
				INSERT INTO config_api_visit (visitclass_id, formname, tablename) 
				VALUES (v_class_id, v_viewname, concat('ve_visit_',v_feature_system_id,'_singlevent'));
			END IF;
		END IF;
		
		IF (SELECT visitclass_id FROM config_api_visit_x_featuretable WHERE visitclass_id = v_class_id) IS NULL THEN
			INSERT INTO config_api_visit_x_featuretable (visitclass_id, tablename) VALUES (v_class_id, concat('v_edit_',v_feature_system_id));	
		END IF;
		
		IF (SELECT formname FROM config_api_form_fields WHERE formname = v_viewname) IS NULL THEN
			
			--capture common fields names that need to be copied for the specific visit form
			EXECUTE 'SELECT DISTINCT string_agg(column_name::text,'' ,'')
			FROM information_schema.columns WHERE table_name=''config_api_form_fields'' and table_schema='''||v_schemaname||'''
			AND column_name!=''id'' AND column_name!=''formname'';'
			INTO v_config_fields;
			
			RAISE NOTICE 'v_config_fields,%',v_config_fields;

			--insert common fields for the new formname (view)
			IF v_ismultievent = TRUE THEN
				FOR rec IN (SELECT * FROM config_api_form_fields WHERE formname='visit_multievent')
				LOOP
					EXECUTE 'INSERT INTO config_api_form_fields(formname,'||v_config_fields||')
					SELECT '''||v_viewname||''','||v_config_fields||' FROM config_api_form_fields WHERE id='''||rec.id||''';';
				END LOOP;
			ELSE
				FOR rec IN (SELECT * FROM config_api_form_fields WHERE formname='visit_singlevent')
				LOOP
					EXECUTE 'INSERT INTO config_api_form_fields(formname,'||v_config_fields||')
					SELECT '''||v_viewname||''','||v_config_fields||' FROM config_api_form_fields WHERE id='''||rec.id||''';';
				END LOOP;
			END IF;

			UPDATE config_api_form_fields SET column_id = concat(v_feature_system_id,'_id'), label = concat(initcap(v_feature_system_id),'_id') 
			WHERE column_id = 'feature_id' and formname = v_viewname;

			--rename dv_querytext for class_id in order to look for defined feature_type
			IF v_feature_system_id = 'connec' THEN
				UPDATE config_api_form_fields SET dv_querytext= 'SELECT id, idval FROM om_visit_class WHERE feature_type=''CONNEC'' AND 
				active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))'
				WHERE formname=v_viewname AND column_id='class_id';
			ELSIF v_feature_system_id = 'node' THEN
				UPDATE config_api_form_fields SET dv_querytext= 'SELECT id, idval FROM om_visit_class WHERE feature_type=''NODE'' AND 
				active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))'
				WHERE formname=v_viewname AND column_id='class_id';
			ELSIF v_feature_system_id = 'gully' THEN
				UPDATE config_api_form_fields SET dv_querytext= 'SELECT id, idval FROM om_visit_class WHERE feature_type=''GULLY'' AND 
				active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))'
				WHERE formname=v_viewname AND column_id='class_id';
			END IF;
		END IF;
		
	ELSIF v_action_type = 'parameter' THEN
		
		IF v_viewname NOT IN (SELECT id FROM audit_cat_table) AND v_ismultievent iS TRUE THEN
			INSERT INTO audit_cat_table (id, context, description, sys_role_id, sys_criticity, qgis_criticity, isdeprecated)
			VALUES (v_viewname, 'O&M', 'Editable view that saves visits', 'role_om', 0, 0, false);
		END IF;

		--insert new parameter
		INSERT INTO om_visit_parameter(id, code, parameter_type, feature_type, data_type, descript, form_type, vdefault, ismultifeature, short_descript)
  	 	VALUES (v_param_name, v_code, v_parameter_type, upper(v_feature_system_id),v_data_type, v_descript, v_form_type, v_vdefault,
		v_ismultifeature, v_short_descript);

		--relate new parameters with new class
		INSERT INTO om_visit_class_x_parameter (class_id, parameter_id)
		VALUES (v_class_id, v_param_name);
	    
	    --add configuration of new parameters to config_api_form_fields
		IF v_ismultievent = TRUE THEN
			EXECUTE 'SELECT max(layout_order) + 1 FROM config_api_form_fields WHERE formname='''||v_viewname||'''
			AND layout_name = ''data_1'';'
			INTO v_layout_order;

			INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, layout_name,
			iseditable, ismandatory, dv_querytext)
			VALUES (v_viewname, 'visit', v_param_name,1,v_layout_order, true, v_data_type, v_widgettype, v_param_name, 'data_1',
			v_iseditable, v_ismandatory, v_dv_querytext);
		END IF;

    END IF;	

				
    --check if th visit is multievent
	IF v_ismultievent = TRUE and v_action_type = 'parameter' THEN

			--check if the view for this visit already exists if not create one
		
			IF (SELECT EXISTS ( SELECT 1 FROM   information_schema.tables WHERE  table_schema = v_schemaname AND table_name = v_viewname)) IS FALSE THEN
				v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
				"feature_system_id":"'||v_feature_system_id||'","class_id":"'||v_class_id||'","old_a_param":"null", "old_ct_param":"null",
				"old_id_param":"null","old_datatype":"null"}}';
				raise notice 'v_data_view,%',v_data_view;
				PERFORM gw_fct_admin_manage_visit_view(v_data_view);			

			ELSE

				--if the view doesn't exist and there are parameters defined for the class or add new parameter to the class
				v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
				"feature_system_id":"'||v_feature_system_id||'","class_id":"'||v_class_id||'","old_a_param":"'||v_old_parameters.a_param||'", 
				"old_ct_param":"'||v_old_parameters.ct_param||'", "old_id_param":"'||v_old_parameters.id_param||'","old_datatype":"'||v_old_parameters.datatype||'"}}';

				PERFORM gw_fct_admin_manage_visit_view(v_data_view);	

			END IF;

	END IF;
END IF;

IF v_action = 'UPDATE' AND v_action_type = 'class' THEN

	
	UPDATE om_visit_class
   	SET idval=v_class_name, descript=v_descript, active=v_active, visit_type=v_visit_type, param_options=v_param_options
 	WHERE id = v_class_id;

 	SELECT tablename INTO v_old_viewname FROM config_api_visit WHERE visitclass_id = v_class_id;

	RAISE NOTICE 'v_old_viewname,v_viewname,%,%',v_old_viewname, v_viewname;
	
 	IF v_old_viewname != v_viewname THEN
 		
 		UPDATE config_api_visit SET tablename = v_viewname, formname = v_viewname WHERE visitclass_id = v_class_id;
 		
 		UPDATE config_api_form_fields SET formname = v_viewname WHERE formname = v_old_viewname;

 		EXECUTE 'ALTER VIEW '||v_old_viewname||' RENAME TO '||v_viewname||';';

 		UPDATE audit_cat_table SET id = v_viewname WHERE id = v_old_viewname;

 	
 	END IF;

END IF;

IF (v_action = 'UPDATE' OR v_action = 'DELETE') AND v_action_type = 'parameter' THEN
		--capture old parameters related to the class
		SELECT string_agg(concat('a.',om_visit_parameter.id),',' order by om_visit_parameter.id) as a_param,
		string_agg(concat('ct.',om_visit_parameter.id),',' order by om_visit_parameter.id) as ct_param,
		string_agg(concat('(''''',om_visit_parameter.id,''''')'),',' order by om_visit_parameter.id) as id_param,
		string_agg(concat(om_visit_parameter.id,' ', lower(om_visit_parameter.data_type)),', ' order by om_visit_parameter.id) as datatype
		INTO v_old_parameters
		FROM om_visit_parameter JOIN om_visit_class_x_parameter ON om_visit_parameter.id=om_visit_class_x_parameter.parameter_id
		WHERE class_id=v_class_id;

END IF;

IF v_action = 'UPDATE' AND v_action_type = 'parameter' THEN

		UPDATE om_visit_parameter SET code = v_code, parameter_type = v_parameter_type, feature_type = upper(v_feature_system_id), data_type = v_data_type, 
  	 	descript = v_descript, form_type = v_form_type, vdefault = v_vdefault, short_descript = v_short_descript
  	 	WHERE id = v_param_name;
		
		IF v_ismultievent = TRUE THEN
			
			v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
			"feature_system_id":"'||v_feature_system_id||'","class_id":"'||v_class_id||'","old_a_param":"'||v_old_parameters.a_param||'", 
			"old_ct_param":"'||v_old_parameters.ct_param||'", "old_id_param":"'||v_old_parameters.id_param||'","old_datatype":"'||v_old_parameters.datatype||'"}}';

			PERFORM gw_fct_admin_manage_visit_view(v_data_view);
			
		END IF;

		UPDATE config_api_form_fields SET formname = v_viewname, layout_order = v_layout_order, isenabled = v_isenabled, 
		datatype = v_data_type, widgettype = v_widgettype, label = v_param_name, iseditable = v_iseditable, ismandatory = v_ismandatory,
		dv_querytext = v_dv_querytext 
		WHERE formname = v_viewname and formtype='visit' and column_id = v_param_name;

ELSIF v_action = 'DELETE' AND v_action_type = 'parameter' THEN
	
		IF (SELECT count(id) FROM om_visit_event WHERE parameter_id = v_param_name) = 0 THEN

			DELETE FROM om_visit_class_x_parameter WHERE parameter_id = v_param_name;
			DELETE FROM om_visit_parameter WHERE id = v_param_name;


			IF v_ismultievent = TRUE THEN
			raise notice 'multi_delete';
				v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
				"feature_system_id":"'||v_feature_system_id||'","class_id":"'||v_class_id||'","old_a_param":"'||v_old_parameters.a_param||'", 
				"old_ct_param":"'||v_old_parameters.ct_param||'", "old_id_param":"'||v_old_parameters.id_param||'","old_datatype":"'||v_old_parameters.datatype||'"}}';

				PERFORM gw_fct_admin_manage_visit_view(v_data_view);

			END IF;

		ELSE
			 PERFORM audit_function(3024,2746);
		END IF;

ELSIF v_action = 'DELETE' AND v_action_type = 'class' THEN
		raise notice 'delete class - class_id,%',v_class_id;

		v_viewname = (SELECT tablename FROM config_api_visit WHERE visitclass_id = v_class_id);

		IF (SELECT count(id) FROM om_visit WHERE class_id = v_class_id) = 0 THEN
			RAISE NOTICE 'DELETE ALL';
			DELETE FROM config_api_visit_x_featuretable WHERE visitclass_id = v_class_id;
			DELETE FROM config_api_form_fields WHERE formtype='visit' and formname IN (SELECT formname FROM config_api_visit WHERE visitclass_id = v_class_id);
			DELETE FROM config_api_visit WHERE visitclass_id = v_class_id;
			DELETE FROM om_visit_class_x_parameter WHERE class_id = v_class_id;
			DELETE FROM om_visit_parameter WHERE id IN (SELECT parameter_id FROM om_visit_class_x_parameter WHERE class_id = v_class_id);
			DELETE FROM om_visit_class WHERE id = v_class_id;
			DELETE FROM audit_cat_table WHERE id = v_viewname;			
			
		ELSE
			UPDATE om_visit_class SET active = FALSE WHERE id = v_class_id;
			
			PERFORM audit_function(3026,2746);
		END IF;

		EXECUTE 'DROP VIEW IF EXISTS '||v_viewname||';';

ELSIF v_action = 'CONFIGURATION' THEN
	
		v_ismultievent = (SELECT ismultievent FROM om_visit_class WHERE id=v_class_id);
		v_feature_system_id = (SELECT lower(feature_type) FROM om_visit_class WHERE id=v_class_id);

		--create configuration and views for the alread defined classes and parameters
		IF  v_ismultievent = TRUE THEN
			INSERT INTO config_api_visit (visitclass_id, formname, tablename) VALUES (v_class_id, v_viewname, v_viewname);

			IF v_viewname NOT IN (SELECT id FROM audit_cat_table) AND v_ismultievent iS TRUE THEN
				INSERT INTO audit_cat_table (id, context, description, sys_role_id, sys_criticity, qgis_criticity, isdeprecated)
				VALUES (v_viewname, 'O&M', 'Editable view that saves visits', 'role_om', 0, 0, false);
				raise notice 'multi -  audit_cat_table';
			END IF;

		ELSE 
			INSERT INTO config_api_visit (visitclass_id, formname, tablename) VALUES (v_class_id, v_viewname, concat('ve_visit_',v_feature_system_id,'_singlevent'));
		END IF;

		INSERT INTO config_api_visit_x_featuretable (visitclass_id, tablename) VALUES (v_class_id, concat('v_edit_',v_feature_system_id));	
	
		IF (SELECT formname FROM config_api_form_fields WHERE formname = v_viewname) IS NULL THEN
			--capture common fields names that need to be copied for the specific visit form
			EXECUTE 'SELECT DISTINCT string_agg(column_name::text,'' ,'')
			FROM information_schema.columns WHERE table_name=''config_api_form_fields'' and table_schema='''||v_schemaname||'''
			AND column_name!=''id'' AND column_name!=''formname'';'
			INTO v_config_fields;

			--insert common fields for the new formname (view)
			IF v_ismultievent = TRUE THEN
				FOR rec IN (SELECT * FROM config_api_form_fields WHERE formname='visit_multievent')
				LOOP
					EXECUTE 'INSERT INTO config_api_form_fields(formname,'||v_config_fields||')
					SELECT '''||v_viewname||''','||v_config_fields||' FROM config_api_form_fields WHERE id='''||rec.id||''';';
					raise notice 'multi -  config_api_form_fields';
				END LOOP;
			ELSE
				FOR rec IN (SELECT * FROM config_api_form_fields WHERE formname='visit_singlevent')
				LOOP
					EXECUTE 'INSERT INTO config_api_form_fields(formname,'||v_config_fields||')
					SELECT '''||v_viewname||''','||v_config_fields||' FROM config_api_form_fields WHERE id='''||rec.id||''';';
				END LOOP;
			END IF;

			UPDATE config_api_form_fields SET column_id = concat(v_feature_system_id,'_id'), label = concat(initcap(v_feature_system_id),'_id') 
			WHERE column_id = 'feature_id' and formname = v_viewname;
			
			--rename dv_querytext for class_id in order to look for defined feature_type
			IF v_feature_system_id = 'connec' THEN
				UPDATE config_api_form_fields SET dv_querytext= 'SELECT id, idval FROM om_visit_class WHERE feature_type=''CONNEC'' AND 
				active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))'
				WHERE formname=v_viewname AND column_id='class_id';
			ELSIF v_feature_system_id = 'node' THEN
				UPDATE config_api_form_fields SET dv_querytext= 'SELECT id, idval FROM om_visit_class WHERE feature_type=''NODE'' AND 
				active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))'
				WHERE formname=v_viewname AND column_id='class_id';
			ELSIF v_feature_system_id = 'gully' THEN
				UPDATE config_api_form_fields SET dv_querytext= 'SELECT id, idval FROM om_visit_class WHERE feature_type=''GULLY'' AND 
				active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))'
				WHERE formname=v_viewname AND column_id='class_id';
			END IF;
		END IF;

		--add configuration of parameters related to the class to config_api_form_fields
		IF v_ismultievent = TRUE THEN

			FOR rec IN 
			(SELECT class_id, parameter_id, data_type  FROM om_visit_class_x_parameter JOIN om_visit_parameter ON om_visit_parameter.id = om_visit_class_x_parameter.parameter_id
			WHERE class_id = v_class_id ) LOOP

				EXECUTE 'SELECT max(layout_order) + 1 FROM config_api_form_fields WHERE formname='''||v_viewname||'''
				AND layout_name = ''data_1'';'
				INTO v_layout_order;
				
				IF lower(rec.data_type) = 'text' THEN
					v_data_type = 'string';
					v_widgettype = 'text';
				ELSIF lower(rec.data_type) = 'boolean' THEN
					v_widgettype = 'check';
				ELSE
					v_data_type=lower(rec.data_type);
					v_widgettype = 'text';
				END IF;
				
				INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, layout_name,
				iseditable, ismandatory)
				VALUES (v_viewname, 'visit', rec.parameter_id,1,v_layout_order, true, v_data_type, v_widgettype, rec.parameter_id, 'data_1',
				true, false);
			END LOOP;
			
			--create a new class view
			v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
			"feature_system_id":"'||v_feature_system_id||'","class_id":"'||v_class_id||'","old_a_param":"null", "old_ct_param":"null",
			"old_id_param":"null","old_datatype":"null"}}';
			
			PERFORM gw_fct_admin_manage_visit_view(v_data_view);	
		
		END IF;

END IF;

PERFORM gw_fct_admin_role_permissions();


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;