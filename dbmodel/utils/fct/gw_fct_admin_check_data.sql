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
{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{}}}$$)::text

-- fid: 195

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
rec_fields text;
v_field_array text[];

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	v_schemaname = 'SCHEMA_NAME';
	
	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	-- init variables
	v_count=0;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=195 AND cur_user=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, null, 4, concat('CHECK ADMIN CONFIGURATION'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, null, 3, 'CRITICAL ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, null, 3, '----------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, null, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, null, 1, '-------');


	--CHECK VALUES ON OBLIGATORY CAT_FEATURE_* FIELDS (303)

	--check if all features have value on field active
	SELECT count(*), string_agg(id,', ')  INTO v_count,v_feature_list FROM cat_feature WHERE active IS NULL;

	IF v_count > 0 THEN
		v_errortext=concat('ERROR-303: There is/are ',v_count,' features without value on field "active". Features - ',v_feature_list::text,'.');

		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 3, '303', v_errortext, v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1,'303', 'INFO: All features have value on field "active"', 0);
	END IF;

	--check if all features have value on field code_autofill (304)
	SELECT count(*), string_agg(id,', ')  INTO v_count,v_feature_list FROM cat_feature WHERE code_autofill IS NULL;

	IF v_count > 0 THEN
		v_errortext=concat('ERROR-304: There is/are ',v_count,' features without value on field "code_autofill". Features - ',v_feature_list::text,'.');

		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 3, '304', v_errortext, v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1, '304', 'INFO: All features have value on field "code_autofill"', 0);
	END IF;

	--check if all nodes have value on field num_arcs (305)
	SELECT count(*), string_agg(id,', ')  INTO v_count,v_feature_list FROM cat_feature_node WHERE num_arcs IS NULL;

	IF v_count > 0 THEN
		v_errortext=concat('ERROR-305: There is/are ',v_count,' nodes without value on field "num_arcs". Features - ',v_feature_list::text,'.');

		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 3, '305', v_errortext, v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1, '305', 'INFO: All nodes have value on field "num_arcs"', 0);
	END IF;

	--check if all nodes have value on field isarcdivide (306)
	SELECT count(*), string_agg(id,', ')  INTO v_count,v_feature_list FROM cat_feature_node WHERE isarcdivide IS NULL;

	IF v_count > 0 THEN
		v_errortext=concat('ERROR-306: There is/are ',v_count,' nodes without value on field "isarcdivide". Features - ',v_feature_list::text,'.');

		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 3, '306', v_errortext, v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1, '306', 'INFO: All nodes have value on field "isarcdivide"', 0);
	END IF;

	IF v_project_type = 'WS' THEN
		--check if all nodes have value on field graf_delimiter (307)
		SELECT count(*), string_agg(id,', ')  INTO v_count,v_feature_list FROM cat_feature_node WHERE graf_delimiter IS NULL;

		IF v_count > 0 THEN
			v_errortext=concat('ERROR-307: There is/are ',v_count,' nodes without value on field "graf_delimiter". Features - ',v_feature_list::text,'.');

			INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
			VALUES (195, 3, '307',v_errortext, v_count);
		ELSE
			INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
			VALUES (195, 1, '307','INFO: All nodes have value on field "graf_delimiter"', 0);
		END IF;
	END IF;

	IF v_project_type = 'UD' THEN
		--check if all nodes have value on field isexitupperintro (308)
		SELECT count(*), string_agg(id,', ')  INTO v_count,v_feature_list FROM cat_feature_node WHERE isexitupperintro IS NULL;

		IF v_count > 0 THEN
			v_errortext=concat('ERROR-308: There is/are ',v_count,' nodes without value on field "isexitupperintro". Features - ',v_feature_list::text,'.');

			INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
			VALUES (195, 3, '308', v_errortext, v_count);
		ELSE
			INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
			VALUES (195, 1, '308', 'INFO: All nodes have value on field "isexitupperintro"', 0);
		END IF;
	END IF;
	
	--check if all nodes have value on field choose_hemisphere (309)
	SELECT count(*), string_agg(id,', ')  INTO v_count,v_feature_list FROM cat_feature_node WHERE choose_hemisphere IS NULL;

	IF v_count > 0 THEN
		v_errortext=concat('ERROR-309: There is/are ',v_count,' nodes without value on field "choose_hemisphere". Features - ',v_feature_list::text,'.');

		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 3, '309', v_errortext, v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1, '309', 'INFO: All nodes have value on field "choose_hemisphere"', 0);
	END IF;

	--check if all nodes have value on field isprofilesurface (310)
	SELECT count(*), string_agg(id,', ')  INTO v_count,v_feature_list FROM cat_feature_node WHERE isprofilesurface IS NULL;

	IF v_count > 0 THEN
		v_errortext=concat('ERROR-310: There is/are ',v_count,' nodes without value on field "isprofilesurface". Features - ',v_feature_list::text,'.');

		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 3,'310', v_errortext, v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1, '310','INFO: All nodes have value on field "isprofilesurface"', 0);
	END IF;
	

	--CHECK CHILD VIEWS FOR ACTIVE FEATURES
	--list active cat_feature
	v_querytext = 'SELECT * FROM cat_feature WHERE active IS TRUE;';
	FOR rec IN EXECUTE v_querytext LOOP

	--check if all the views defined in cat_feature exist (313) :
		IF (SELECT EXISTS ( SELECT 1 FROM   information_schema.tables WHERE  table_schema = v_schemaname AND table_name = rec.child_layer)) IS TRUE THEN
			EXECUTE'SELECT pg_get_viewdef('''||v_schemaname||'.'||rec.child_layer||''', true);'
			INTO v_definition;

			--check if the view has well defined man_table (311)
			IF v_project_type = 'WS' OR (v_project_type = 'UD' AND rec.system_id!='GULLY' AND rec.system_id!='CONNEC') THEN
			
				IF position(concat('man_',lower(rec.system_id)) in v_definition) = 0 THEN

					v_errortext=concat('ERROR-311: View ',rec.child_layer,' has wrongly defined man_table');

					INSERT INTO audit_check_data (fid,  criticity,result_id, error_message)
					VALUES (195, 3, '311', v_errortext);
				END IF;
			END IF;

			--check if all active addfields are present on the view (312)
			IF (SELECT count(param_name) FROM sys_addfields WHERE cat_feature_id IS NULL OR cat_feature_id = rec.id) > 0 THEN
				
				SELECT count(*), string_agg(param_name,',') INTO v_count, v_param_list FROM sys_addfields 
				WHERE active IS TRUE AND (cat_feature_id IS NULL OR cat_feature_id = rec.id)	
				AND param_name NOT IN 
				(SELECT column_name FROM information_schema.columns WHERE  table_schema = v_schemaname AND table_name = rec.child_layer);

				IF v_count > 0 THEN
					v_errortext=concat('WARNING-312: There is/are ',v_count,' active addfields that may not be present on the view ',rec.child_layer,'. Addfields: ',v_param_list::text,'.');

					INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
					VALUES (195, 2, '312', v_errortext, v_count);

				END IF;
		
			END IF;

		ELSE 
			IF rec.child_layer is not null then
				v_errortext=concat('ERROR-313: View ',rec.child_layer,' is defined in cat_feature table but is not created in a DB');

				INSERT INTO audit_check_data (fid,  criticity, result_id, error_message)
				VALUES (195, 3, '313', v_errortext);
			END IF;
		END IF;

	END LOOP;

	--check if all active features have child view name in cat_feature table (314)
	SELECT count(*),string_agg(id,',')  INTO v_count,v_feature_list FROM cat_feature WHERE active IS TRUE AND child_layer IS NULL;

	IF v_count > 0 THEN
		v_errortext=concat('ERROR-314: There is/are ',v_count,' active features which views names are not present in cat_feature table. Features - ',v_feature_list::text,'.');

		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 3, '314', v_errortext, v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id,error_message, fcount)
		VALUES (195, 1,'314', 'INFO: All active features have child view name in cat_feature table', 0);
	END IF;

	--check if all views with active cat_feature have a definition in config_info_layer_x_type (315)
	SELECT count(id), string_agg(child_layer,',')  INTO v_count,v_view_list FROM cat_feature WHERE active IS TRUE AND
	child_layer not in (select tableinfo_id FROM config_info_layer_x_type);

	IF v_count > 0 THEN
		v_errortext=concat('ERROR-315: There is/are ',v_count,' active features which views are not defined in config_info_layer_x_type. Undefined views: ',v_view_list::text,'.');

		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 3, '315',  v_errortext, v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1, '315', 'INFO: All active features have child view defined in config_info_layer_x_type', 0);
	END IF;


	--check if all views with active cat_feature have a definition in config_form_fields (316)
	SELECT count(id), string_agg(child_layer,',')  INTO v_count,v_view_list FROM cat_feature WHERE active IS TRUE AND
	child_layer not in (select formname FROM config_form_fields);

	IF v_count > 0 THEN
		v_errortext = concat('ERRO-316: There is/are ',v_count,' active features which views are not defined in config_form_fields. Undefined views: ',v_view_list,'.');
		
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 3, '316', v_errortext, v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1, '316', 'INFO: All active features have child view defined in config_form_fields',0);
	END IF;

	--check if all ve_node_*,ve_arc_* etc views created in schema are related to any feature in cat_feature (317)
	FOR rec IN (SELECT table_schema, table_name from information_schema.views where table_schema=v_schemaname AND 
	(table_name ilike 've_node_%' OR table_name ilike 've_arc_%' OR table_name ilike 've_connec_%'OR table_name ilike 've_gully_%'))
	LOOP

	v_querytext = (select string_agg(child_layer,',') FROM cat_feature where child_layer IS NOT NULL);

		IF position(rec.table_name IN v_querytext) = 0 THEN
			v_errortext=concat('WARNING-317: View ',rec.table_name,' is defined in a DB but is not related to any feature in cat_feature.');
			INSERT INTO audit_check_data (fid,  criticity,result_id, error_message, fcount)
			VALUES (195, 2, '317',v_errortext);
		END IF;
	END LOOP;

	--CHECK CONFIG FORM FIELDS

	--check if all the fields has defined datatype (318)
	SELECT count(*), string_agg(concat(formname,'.',columnname),',') INTO v_count, v_view_list FROM config_form_fields WHERE datatype IS NULL AND formtype='feature';

	IF v_count > 0 THEN
		v_errortext =  concat('ERROR-318: There is/are ',v_count,' feature form fields in config_form_fields that don''t have data type. Fields: ',v_view_list,'.');
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 3,'318',v_errortext, v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1, '318', 'INFO: All feature form fields have defined data type.', 0);
	END IF;

	--check if all the fields has defined widgettype (319)
	SELECT count(*), string_agg(concat(formname,'.',columnname),',') INTO v_count, v_view_list FROM config_form_fields WHERE widgettype IS NULL AND formtype='feature';

	IF v_count > 0 THEN
		v_errortext = concat('ERROR-319: There is/are ',v_count,' feature form fields in config_form_fields that don''t have widget type. Fields: ',v_view_list,'.');
		INSERT INTO audit_check_data (fid,  criticity, result_id,error_message, fcount)
		VALUES (195, 3,'319', v_errortext, v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1, '319', 'INFO: All feature form fields have defined widget type.',0);
	END IF;

	--check if all the fields defined as combo or typeahead have dv_querytext defined (320)
	SELECT count(*), string_agg(concat(formname,'.',columnname),',') INTO v_count, v_view_list  FROM config_form_fields
	WHERE (widgettype = 'combo' or widgettype ='typeahead') and dv_querytext is null and columnname !='composer';

	IF v_count > 0 THEN
		v_errortext = concat('ERROR-320: There is/are ',v_count,' feature form fields in config_form_fields that are combo or typeahead but don''t have dv_querytext defined. Fields: ',v_view_list,'.');
		INSERT INTO audit_check_data (fid,  criticity,result_id, error_message, fcount)
		VALUES (195, 3, '320', v_errortext, v_count);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1, '320', 'INFO: All feature form fields with widget type combo or typeahead have dv_querytext defined.',0);
	END IF;

	--check if all addfields are defined in config_form_fields (321)
	SELECT count(*), string_agg(concat(child_layer,': ',param_name),',') INTO v_count, v_view_list FROM sys_addfields 
	JOIN cat_feature ON cat_feature.id=sys_addfields.cat_feature_id
	WHERE sys_addfields.active IS TRUE AND param_name not IN (SELECT columnname FROM config_form_fields JOIN cat_feature ON cat_feature.child_layer=formname);

	IF v_count > 0 THEN
		v_errortext=concat('ERROR-321: There is/are ',v_count,' addfields that are not defined in config_form_fields. Addfields: ',v_view_list,'.');
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message)
		VALUES (195, 3, '321',v_errortext);
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1, '321','INFO: All addfields are defined in config_form_fields.', 0);
	END IF;

	--check if definitions has duplicated layoutorder for different layouts (322)
	SELECT array_agg(a.list::text) into v_field_array FROM (SELECT concat('Formname: ',formname, ', layoutname: ',layoutname, ', layoutorder: ',layoutorder) as list
	FROM config_form_fields WHERE formtype = 'feature' AND hidden is false group by layoutorder,formname,layoutname having count(*)>1)a;

	IF v_field_array IS NOT NULL THEN
		v_errortext=concat('ERROR-322: There is/are form names with duplicated layout order defined in config_form_fields: ');
		INSERT INTO audit_check_data (fid,  criticity, result_id,error_message, fcount)
		VALUES (195, 3,'322', v_errortext, v_count);

		FOREACH rec_fields IN ARRAY(v_field_array)
		LOOP
			INSERT INTO audit_check_data (fid,  criticity, result_id, error_message)
		VALUES (195, 3, '322', rec_fields); --replace(replace(rec_fields::text,'("',''),'")',''));
		END LOOP;
	ELSE
		INSERT INTO audit_check_data (fid,  criticity, result_id, error_message, fcount)
		VALUES (195, 1, '322','INFO: All fields defined in config_form_fields have unduplicated order.', 0);
	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=195 order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, v_result_id, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, v_result_id, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, v_result_id, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, v_result_id, 1, '');
	
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
			 ',"body":{"form":{}'||
			 ',"data":{ "info":'||v_result_info||','||
				'"point":{"geometryType":"", "values":[]}'||','||
				'"line":{"geometryType":"", "values":[]}'||','||
				'"polygon":{"geometryType":"", "values":[]}'||
			   '}}'||
		'}')::json, 2776);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;