/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2776

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_check_data(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT gw_fct_admin_check_data($${"client":
{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, 
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{}}}$$)::text
*/

DECLARE

v_schemaname text;
v_count	integer;
v_project_type text;
v_version text;
v_view_list text;
v_errortext text;
v_result text;
v_result_info json;
v_definition text;
rec record;
v_result_id text;
v_querytext text;
v_feature_list text;
v_param_list text;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	v_schemaname = 'SCHEMA_NAME';
	
	-- select config values
	SELECT wsoftware, giswater INTO v_project_type, v_version FROM version order by id desc limit 1;

	-- init variables
	v_count=0;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id=95 AND user_name=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (95, null, 4, concat('CHECK API CONFIGURATION'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (95, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (95, null, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (95, null, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (95, null, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (95, null, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (95, null, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (95, null, 1, '-------');


--CHECK CHILD VIEWS FOR ACTIVE FEATURES
--list active cat_feature
IF v_project_type ='WS' THEN
	v_querytext = 'SELECT * FROM cat_feature JOIN (SELECT id,active FROM node_type 
    UNION SELECT id,active FROM arc_type UNION SELECT id,active FROM connec_type) a USING (id) WHERE a.active IS TRUE;';

ELSIF v_project_type ='UD' THEN

	v_querytext = 'SELECT * FROM cat_feature JOIN (SELECT id,active FROM node_type 
	UNION SELECT id,active FROM arc_type UNION SELECT id,active FROM connec_type UNION SELECT id,active FROM gully_type) a USING (id) WHERE a.active IS TRUE;';

END IF;


	FOR rec IN EXECUTE v_querytext LOOP
	--check if all the views defined in cat_feature exist:
		IF (SELECT EXISTS ( SELECT 1 FROM   information_schema.tables WHERE  table_schema = v_schemaname AND table_name = rec.child_layer)) IS TRUE THEN
			EXECUTE'SELECT pg_get_viewdef('''||v_schemaname||'.'||rec.child_layer||''', true);'
			INTO v_definition;

			--check if the view has well defined man_table
			IF position(concat('man_',lower(rec.system_id)) in v_definition) = 0 THEN

				v_errortext=concat('ERROR: View ',rec.child_layer,' has wrongly defined man_table');

				INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
				VALUES (95, 3, v_errortext);
			END IF;

			--check if all active addfields are present on the view
			IF (SELECT count(param_name) FROM man_addfields_parameter WHERE cat_feature_id IS NULL OR cat_feature_id = rec.id) > 0 THEN
				
				SELECT count(*), string_agg(param_name,',') INTO v_count, v_param_list FROM man_addfields_parameter 
				WHERE active IS TRUE AND (cat_feature_id IS NULL OR cat_feature_id = rec.id)	
				AND param_name NOT IN 
				(SELECT column_name FROM information_schema.columns WHERE  table_schema = v_schemaname AND table_name = rec.child_layer);

				IF v_count > 0 THEN
					v_errortext=concat('WARNING: There is/are ',v_count,' active addfields that may not be present on the view ',rec.child_layer,'. Addfields: ',v_param_list::text,'.');

					INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
					VALUES (95, 2, v_errortext);

				END IF;
		
			END IF;

		ELSE 
			v_errortext=concat('ERROR: View ',rec.child_layer,' is defined in cat_feature table but is not created');

			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (95, 3, v_errortext);
		END IF;

	END LOOP;

	--check if all active features have child view name in cat_feature table
	IF v_project_type ='WS' THEN
		SELECT count(*),string_agg(id,',')  INTO v_count,v_feature_list FROM cat_feature JOIN (SELECT id,active FROM node_type 
	    UNION SELECT id,active FROM arc_type UNION SELECT id,active FROM connec_type) a USING (id) WHERE a.active IS TRUE AND child_layer IS NULL;

	ELSIF v_project_type ='UD' THEN

		SELECT count(*),string_agg(id,',')  INTO v_count,v_feature_list FROM cat_feature JOIN (SELECT id,active FROM node_type 
		UNION SELECT id,active FROM arc_type UNION SELECT id,active FROM connec_type UNION SELECT id,active FROM gully_type) a USING (id) WHERE a.active IS TRUE AND child_layer IS NULL;

	END IF;

	IF v_count > 0 THEN
		v_errortext=concat('ERROR: There is/are ',v_count,' active features which views names are not present in cat_feature table. Features: ',v_feature_list::text,'.');

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 3, v_errortext);
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 1, 'INFO: All active features have child view name in cat_feature table');
	END IF;


	--check if all views with active cat_feature have a definition in config_api_tableinfo_x_infotype

	IF v_project_type ='WS' THEN
	   SELECT count(id), string_agg(child_layer,',')  INTO v_count,v_view_list FROM cat_feature JOIN (SELECT id,active FROM node_type 
	   UNION SELECT id,active FROM arc_type UNION SELECT id,active FROM connec_type) a USING (id) WHERE a.active IS TRUE AND 
	   child_layer not in (select tableinfo_id FROM config_api_tableinfo_x_infotype);

	ELSIF v_project_type ='UD' THEN

		SELECT count(id), string_agg(child_layer,',')  INTO v_count, v_view_list FROM cat_feature JOIN (SELECT id,active FROM node_type 
		UNION SELECT id,active FROM arc_type UNION SELECT id,active FROM connec_type UNION SELECT id,active FROM gully_type) a USING (id) WHERE a.active IS TRUE AND 
		child_layer not in (select tableinfo_id FROM config_api_tableinfo_x_infotype);

	END IF;

	IF v_count > 0 THEN
		v_errortext=concat('ERROR: There is/are ',v_count,' active features which views are not defined in config_api_tableinfo_x_infotype. Undefined views: ',v_view_list::text,'.');

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 3, v_errortext);
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 1, 'INFO: All active features have child view defined in config_api_tableinfo_x_infotype');
	END IF;


	--check if all views with active cat_feature have a definition in config_api_form_fields
	IF v_project_type ='WS' THEN
	   SELECT count(id), string_agg(child_layer,',')  INTO v_count,v_view_list FROM cat_feature JOIN (SELECT id,active FROM node_type 
	   UNION SELECT id,active FROM arc_type UNION SELECT id,active FROM connec_type) a USING (id) WHERE a.active IS TRUE AND 
	   child_layer not in (select formname FROM config_api_form_fields);

	ELSIF v_project_type ='UD' THEN

		SELECT count(id), string_agg(child_layer,',')  INTO v_count, v_view_list FROM cat_feature JOIN (SELECT id,active FROM node_type 
		UNION SELECT id,active FROM arc_type UNION SELECT id,active FROM connec_type UNION SELECT id,active FROM gully_type) a USING (id) WHERE a.active IS TRUE AND 
		child_layer not in (select formname FROM config_api_form_fields);

	END IF;

	IF v_count > 0 THEN
		v_errortext = concat('ERROR: There is/are ',v_count,' active features which views are not defined in config_api_form_fields. Undefined views: ',v_view_list,'.');
		
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 3,v_errortext );
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 1, 'INFO: All active features have child view defined in config_api_form_fields');
	END IF;


	--CHECK CONFIG API FORM FIELDS

	--check if all the fields has defined datatype
	SELECT count(*), string_agg(concat(formname,'.',column_id),',') INTO v_count, v_view_list FROM config_api_form_fields WHERE datatype IS NULL AND formtype='feature';

	IF v_count > 0 THEN
		v_errortext =  concat('ERROR: There is/are ',v_count,' feature form fields in config_api_form_fields that don''t have data type. Fields: ',v_view_list,'.');
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 3,v_errortext);
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 1, 'INFO: All feature form fields have defined data type.');
	END IF;

	--check if all the fields has defined widgettype 
	SELECT count(*), string_agg(concat(formname,'.',column_id),',') INTO v_count, v_view_list FROM config_api_form_fields WHERE widgettype IS NULL AND formtype='feature';

	IF v_count > 0 THEN
		v_errortext = concat('ERROR: There is/are ',v_count,' feature form fields in config_api_form_fields that don''t have widget type. Fields: ',v_view_list,'.');
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 3,v_errortext);
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 1, 'INFO: All feature form fields have defined widget type.');
	END IF;

	--check if all the fields defined as combo or typeahead have dv_querytext defined
	SELECT count(*), string_agg(concat(formname,'.',column_id),',') INTO v_count, v_view_list  FROM config_api_form_fields 
	WHERE (widgettype = 'combo' or widgettype ='typeahead') and dv_querytext is null AND formtype='feature';

	IF v_count > 0 THEN
		v_errortext = concat('ERROR: There is/are ',v_count,' feature form fields in config_api_form_fields that are combo or typeahead but don''t have dv_querytext defined. 
		Fields: ',v_view_list,'.');
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 3, v_errortext);
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 1, 'INFO: All feature form fields with widget type combo or typeahead have dv_querytext defined.');
	END IF;

	--check if all the fields defined as  typeahead have field typeahead defined
	SELECT count(*), string_agg(concat(formname,'.',column_id),',') INTO v_count, v_view_list  FROM config_api_form_fields 
	WHERE widgettype ='typeahead' and typeahead is null AND formtype='feature';

	IF v_count > 0 THEN
		v_errortext=concat('ERROR: There is/are ',v_count,'feature form fields in config_api_form_fields that are typeahead but don''t have typeahead defined. 
		Fields: ',v_view_list,'.');
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 3, v_errortext);
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 1, 'INFO: All feature form fields with widget type typeahead have typeahead defined.');
	END IF;

	--check if all addfields are defined in config_api_form_fields
	SELECT count(*), string_agg(concat(child_layer,': ',param_name),',') INTO v_count, v_view_list FROM man_addfields_parameter 
	JOIN cat_feature ON cat_feature.id=man_addfields_parameter.cat_feature_id
	WHERE active IS TRUE AND param_name not IN (SELECT column_id FROM config_api_form_fields JOIN cat_feature ON cat_feature.child_layer=formname);

	IF v_count > 0 THEN
		v_errortext=concat('ERROR: There is/are ',v_count,'addfields that are not defined in config_api_form_fields. Addfields: ',v_view_list,'.');
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 3, v_errortext);
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (95, 1, 'INFO: All addfields are defined in config_api_form_fields.');
	END IF;

-- get results
	-- info

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=95 order by criticity desc, id asc) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (95, v_result_id, 4, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (95, v_result_id, 3, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (95, v_result_id, 2, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (95, v_result_id, 1, '');
	
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

--  Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":{"geometryType":"", "values":[]}'||','||
				'"line":{"geometryType":"", "values":[]}'||','||
				'"polygon":{"geometryType":"", "values":[]}'||
		       '}}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;