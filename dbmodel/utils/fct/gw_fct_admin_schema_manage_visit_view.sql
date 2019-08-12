/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2690

--drop function SCHEMA_NAME.gw_fct_admin_manage_visit_view(json)
--CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_visit_view(p_data json)
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_visit_view(p_class_id integer,p_schemaname text,p_old_a_param text,
p_old_ct_param text, p_old_id_param text,p_old_datatype text,p_feature_system_id text,p_viewname text)
  RETURNS void AS
$BODY$


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
	v_old_a_param text;
	v_old_ct_param text;
	v_old_id_param text;
	v_old_datatype text;
BEGIN

SET search_path = "SCHEMA_NAME", public;
	--RAISE NOTICE 'p_data,%',p_data;
 	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;

	-- get input parameters
	
	v_schemaname = p_schemaname;
	v_class_id = p_class_id;
	v_old_a_param = p_old_a_param;
	v_old_ct_param = p_old_ct_param;
	v_old_ct_param = p_old_ct_param;
	v_old_id_param = p_old_id_param;
	v_old_datatype = p_old_datatype;
	v_feature_system_id = p_feature_system_id;
	v_viewname = p_viewname;

		--capture the definition of the view
		EXECUTE'SELECT pg_get_viewdef('''||v_schemaname||'.'||v_viewname||''', true);'
		INTO v_definition;

--capture new parameters related to the class
		SELECT string_agg(concat('a.',om_visit_parameter.id),E',\n    ' order by om_visit_parameter.id) as a_param,
		string_agg(concat('ct.',om_visit_parameter.id),E',\n            ' order by om_visit_parameter.id) as ct_param,
		string_agg(concat('(''''',om_visit_parameter.id,''''')'),',' order by om_visit_parameter.id) as id_param,
		string_agg(concat(om_visit_parameter.id,' ', lower(om_visit_parameter.data_type)),', ' order by om_visit_parameter.id) as datatype
		INTO v_new_parameters
		FROM om_visit_parameter JOIN om_visit_class_x_parameter ON om_visit_parameter.id=om_visit_class_x_parameter.parameter_id
		WHERE class_id=v_class_id;

		--replace old parameters in the view definition with the new ones
		v_definition = replace(v_definition,v_old_ct_param,v_new_parameters.ct_param);
		v_definition = replace(v_definition,v_old_a_param,v_new_parameters.a_param);
		v_definition = replace(v_definition,v_old_id_param,v_new_parameters.id_param);
		v_definition = replace(v_definition,v_old_datatype,v_new_parameters.datatype);
		
		RAISE NOTICE 'v_definition,%',v_definition;

		--replace the existing view and create the trigger
				
		EXECUTE 'DROP VIEW '||v_schemaname||'.'||v_viewname||';';
		EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||v_viewname||' AS '||v_definition||';';

		--create trigger on view 
		EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON '||v_schemaname||'.'||v_viewname||';';

		EXECUTE 'CREATE TRIGGER gw_trg_om_visit_multievent
		INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_schemaname||'.'||v_viewname||'
		FOR EACH ROW EXECUTE PROCEDURE '||v_schemaname||'.gw_trg_om_visit_multievent('||lower(v_feature_system_id)||');';


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;