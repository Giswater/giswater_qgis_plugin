/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2690

--drop function SCHEMA_NAME.gw_fct_admin_manage_visit(json)
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_visit(p_data json)
  RETURNS void AS
$BODY$

/*EXAMPLE


SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"ARC"},
"data":{"action":"CREATE", "action_type":"class", "parameters":{"class_name":"LEAK_ARC5","parameter_id":"param_leak3", "active":"True","ismultifeature":"false","ismultievent":"True",
"visit_type":1,  "parameter_type":"INSPECTION", "data_type":"text", "code":"123", 
"v_param_options":null, "form_type":"event_standard","vdefault":null, "short_descript":null}}}$$);

	SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"ARC"},
	"data":{"action":"CREATE", "action_type":"parameter", "parameters":{"class_name":"LEAK_ARC5","parameter_id":"param_leak88", "active":"True","ismultifeature":"false","ismultievent":"True",
	"visit_type":1,  "parameter_type":"INSPECTION", "data_type":"text", "code":"123", 
	"v_param_options":null, "form_type":"event_standard","vdefault":null, "short_descript":null}}}$$);

SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"ARC"},
"data":{"action":"UPDATE", "action_type":"parameter", "parameters":{"class_id":"11","class_name":"LEAK_ARC5","parameter_id":"param_leak88", "active":"True","ismultifeature":"false","ismultievent":"True",
"visit_type":1,  "parameter_type":"INSPECTION", "data_type":"integer", "code":"777", 
"v_param_options":null, "form_type":"event_standard","vdefault":null, "short_descript":"777"}}}$$);


SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"ARC"},
"data":{"action":"DELETE", "action_type":"class"}}$$);

SELECT SCHEMA_NAME.gw_fct_admin_manage_visit($${"client":{"lang":"ES"}, "feature":{"feature_type":"ARC"},
"data":{"action":"DELETE", "action_type":"parameter","parameters":{"class_id":"11","class_name":"LEAK_ARC5","parameter_id":"param_leak88"}}}$$);
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
	v_parameter_type text;
	v_descript text;
	v_form_type text;
	v_vdefault text;
	v_short_descript text;
	v_action text;
	v_param_options text;
	v_class_id integer;
	v_action_type text;
	v_param_name text;
	v_code text;


	v_om_visit_x_feature_fields text;
	v_om_visit_fields text;
	v_old_parameters record;
	v_new_parameters record;
	v_viewname text;
	v_definition text;
	v_old_viewname text;

BEGIN

	
	-- search path
	SET search_path = "SCHEMA_NAME", public;

 	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;

	-- get input parameters -,man_addfields
	v_schemaname = 'SCHEMA_NAME';
	--v_id = (SELECT nextval('man_addfields_parameter_id_seq') +1);

	v_action = ((p_data ->>'data')::json->>'action')::text;
	v_action_type = ((p_data ->>'data')::json->>'action_type')::text;

	v_class_id = (((p_data ->>'data')::json->>'parameters')::json->>'class_id')::integer; 
	v_class_name = (((p_data ->>'data')::json->>'parameters')::json->>'class_name')::text; 
	v_feature_system_id = ((p_data ->>'feature')::json->>'feature_type')::text;
	v_active = (((p_data ->>'data')::json->>'parameters')::json->>'active')::text;
	v_visit_type = (((p_data ->>'data')::json->>'parameters')::json->>'visit_type')::text;
	v_ismultievent = (((p_data ->>'data')::json->>'parameters')::json->>'ismultievent')::boolean;
	v_ismultifeature = (((p_data ->>'data')::json->>'parameters')::json->>'ismultifeature')::text;
	v_param_name = (((p_data ->>'data')::json->>'parameters')::json->>'parameter_id')::text; 
	raise notice 'v_param_name,%',v_param_name;
	v_data_type = (((p_data ->>'data')::json->>'parameters')::json->>'data_type')::text; 
	v_parameter_type = (((p_data ->>'data')::json->>'parameters')::json->>'parameter_type')::text;
	v_code = (((p_data ->>'data')::json->>'parameters')::json->>'code')::text;
	v_descript = (((p_data ->>'data')::json->>'parameters')::json->>'descript')::text;
	v_form_type = (((p_data ->>'data')::json->>'parameters')::json->>'form_type')::text;
	v_vdefault = (((p_data ->>'data')::json->>'parameters')::json->>'default')::text;
	v_short_descript = (((p_data ->>'data')::json->>'parameters')::json->>'short_descript')::text;
	v_param_options = (((p_data ->>'data')::json->>'parameters')::json->>'v_param_options')::json;


	
	--capture current parameters related to the class
	SELECT string_agg(concat('a.',om_visit_parameter.id),E',\n    ' order by om_visit_parameter.id) as a_param,
	string_agg(concat('ct.',om_visit_parameter.id),E',\n            ' order by om_visit_parameter.id) as ct_param,
	string_agg(concat('(''''',om_visit_parameter.id,''''')'),',' order by om_visit_parameter.id) as id_param,
	string_agg(concat(om_visit_parameter.id,' ', lower(om_visit_parameter.data_type)),', ' order by om_visit_parameter.id) as datatype
	INTO v_old_parameters
	FROM om_visit_parameter JOIN om_visit_class_x_parameter ON om_visit_parameter.id=om_visit_class_x_parameter.parameter_id
	WHERE class_id=v_class_id;

	--set the view name
	v_viewname = concat('aaa_v_om_visit_',lower(v_feature_system_id),'_',lower(v_class_name));
	
IF v_action = 'CREATE' THEN
	--insert new class and parameter
	IF v_action_type = 'class' THEN
		INSERT INTO om_visit_class (idval, descript, active, ismultifeature, ismultievent, feature_type, sys_role_id, visit_type, param_options)
		VALUES (v_class_name, v_descript, v_active, v_ismultifeature, v_ismultievent, v_feature_system_id, 'role_om', v_visit_type, v_param_options::json);

	ELSIF v_action_type = 'parameter' THEN
		--capture the id of the class
		SELECT id INTO v_class_id FROM om_visit_class WHERE idval = v_class_name;
		

		--insert new parameter
		INSERT INTO om_visit_parameter(id, code, parameter_type, feature_type, data_type, descript, form_type, vdefault, ismultifeature, short_descript)
  	 	VALUES (v_param_name, v_code, v_parameter_type,v_feature_system_id,v_data_type, v_descript, v_form_type, v_vdefault,
		v_ismultifeature, v_short_descript);

		--relate new parameters with new class
		INSERT INTO om_visit_class_x_parameter (class_id, parameter_id)
		VALUES (v_class_id, v_param_name);
	    
		--capture new parameters related to the class
		SELECT string_agg(concat('a.',om_visit_parameter.id),E',\n    ' order by om_visit_parameter.id) as a_param,
		string_agg(concat('ct.',om_visit_parameter.id),E',\n            ' order by om_visit_parameter.id) as ct_param,
		string_agg(concat('(''''',om_visit_parameter.id,''''')'),',' order by om_visit_parameter.id) as id_param,
		string_agg(concat(om_visit_parameter.id,' ', lower(om_visit_parameter.data_type)),', ' order by om_visit_parameter.id) as datatype
		INTO v_new_parameters
		FROM om_visit_parameter JOIN om_visit_class_x_parameter ON om_visit_parameter.id=om_visit_class_x_parameter.parameter_id
		WHERE class_id=v_class_id;


	--RAISE NOTICE 'v_new_parameters,%',v_new_parameters;

    END IF;	

				
    --check if th visit is multievent
	IF v_ismultievent = TRUE and v_action_type = 'parameter' THEN

		--check if the view for this visit already exists if not create one
		
			IF (SELECT EXISTS ( SELECT 1 FROM   information_schema.tables WHERE  table_schema = v_schemaname AND table_name = v_viewname)) IS FALSE THEN

				EXECUTE 'SELECT DISTINCT string_agg(concat(''om_visit_x_'||lower(v_feature_system_id)||'.'',column_name)::text,'', '')
				FROM information_schema.columns where table_name=''om_visit_x_'||lower(v_feature_system_id)||''' and table_schema='''||v_schemaname||''' 
				and column_name!=''is_last'''
				INTO v_om_visit_x_feature_fields;
			    		    
				EXECUTE 'SELECT DISTINCT string_agg(concat(''om_visit.'',column_name)::text,'', '')
				FROM information_schema.columns where table_name=''om_visit'' and table_schema='''||v_schemaname||''' and column_name!=''publish'' and column_name!=''id'''
				INTO v_om_visit_fields;
		

				EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.aaa_v_om_visit_'||lower(v_feature_system_id)||'_'||lower(v_class_name)||' AS
					SELECT '||v_om_visit_x_feature_fields||',
					'||v_om_visit_fields||',
					'||v_new_parameters.a_param||'
					FROM om_visit
					JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
					JOIN om_visit_x_'||lower(v_feature_system_id)||' ON om_visit.id = om_visit_x_'||lower(v_feature_system_id)||'.visit_id
					LEFT JOIN ( SELECT ct.visit_id,
		            '||v_new_parameters.ct_param||'
		           FROM crosstab(''SELECT visit_id, om_visit_event.parameter_id, value 
				      FROM '||v_schemaname||'.om_visit 
				      JOIN '||v_schemaname||'.om_visit_event ON om_visit.id= om_visit_event.visit_id 
				      JOIN '||v_schemaname||'.om_visit_class on om_visit_class.id=om_visit.class_id
				      JOIN '||v_schemaname||'.om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id 
				      where om_visit_class.ismultievent = TRUE ORDER  BY 1,2''::text, '' VALUES ('''''||v_new_parameters.id_param||''''')''::text) 
				      ct(visit_id integer, '||v_new_parameters.datatype||')) a ON a.visit_id = om_visit.id
				  WHERE om_visit_class.ismultievent = true AND om_visit_class.id='||v_class_id||';';
			ELSE

			--if the view doesnt exist and there are parameters defined for the class
			PERFORM gw_fct_admin_manage_visit_view(v_class_id,v_schemaname,v_old_parameters.a_param,v_old_parameters.ct_param,v_old_parameters.id_param,
			v_old_parameters.datatype,v_feature_system_id,v_viewname);

			END IF;

		END IF;
	END IF;


IF (v_action = 'UPDATE' OR v_action = 'DELETE') AND v_action_type = 'parameter' THEN
		--capture old parameters related to the class
		SELECT string_agg(concat('a.',om_visit_parameter.id),E',\n    ' order by om_visit_parameter.id) as a_param,
		string_agg(concat('ct.',om_visit_parameter.id),E',\n            ' order by om_visit_parameter.id) as ct_param,
		string_agg(concat('(''''',om_visit_parameter.id,''''')'),',' order by om_visit_parameter.id) as id_param,
		string_agg(concat(om_visit_parameter.id,' ', lower(om_visit_parameter.data_type)),', ' order by om_visit_parameter.id) as datatype
		INTO v_old_parameters
		FROM om_visit_parameter JOIN om_visit_class_x_parameter ON om_visit_parameter.id=om_visit_class_x_parameter.parameter_id
		WHERE class_id=v_class_id;

END IF;

IF v_action = 'UPDATE' AND v_action_type = 'parameter' THEN

		UPDATE om_visit_parameter SET code = v_code, parameter_type = v_parameter_type, feature_type = v_feature_system_id, data_type = v_data_type, 
  	 	descript = v_descript, form_type = v_form_type, vdefault = v_vdefault, short_descript = v_short_descript
  	 	WHERE id = v_param_name;
		
		PERFORM gw_fct_admin_manage_visit_view(v_class_id,v_schemaname,v_old_parameters.a_param,v_old_parameters.ct_param,v_old_parameters.id_param,
		v_old_parameters.datatype,v_feature_system_id,v_viewname);

ELSIF v_action = 'DELETE' AND v_action_type = 'parameter' THEN

		DELETE FROM om_visit_class_x_parameter WHERE parameter_id = v_param_name;
		DELETE FROM om_visit_parameter WHERE id = v_param_name;

		PERFORM gw_fct_admin_manage_visit_view(v_class_id,v_schemaname,v_old_parameters.a_param,v_old_parameters.ct_param,v_old_parameters.id_param,
		v_old_parameters.datatype,v_feature_system_id,v_viewname);
		
ELSIF v_action = 'DELETE' AND v_action_type = 'class' THEN

		DELETE FROM om_visit_class_x_parameter WHERE class_id = v_class_id;
		DELETE FROM om_visit_class WHERE id = v_class_id;

		
END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;