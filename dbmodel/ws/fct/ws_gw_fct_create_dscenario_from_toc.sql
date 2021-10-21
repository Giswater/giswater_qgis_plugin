/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3104

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_create_dscenario_from_toc(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE

-- fid: 404

*/


DECLARE

object_rec record;

v_version text;
v_result json;
v_result_info json;
v_copyfrom integer;
v_target integer;
v_error_context text;
v_count integer;
v_count2 integer;
v_projecttype text;
v_fid integer = 403;
v_action text;
v_querytext text;
v_result_id text = null;
v_name text;
v_type text;
v_id text;
v_selectionmode text;
v_scenarioid integer;
v_tablename text;
v_featuretype text;
v_table text;
v_columns text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- getting input data
	-- parameters of action CREATE
	v_name :=  ((p_data ->>'data')::json->>'parameters')::json->>'name';
	v_type :=  ((p_data ->>'data')::json->>'parameters')::json->>'type';
	v_id :=  ((p_data ->>'feature')::json->>'id');
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_tablename :=  ((p_data ->>'feature')::json->>'tableName')::text;
	v_featuretype :=  ((p_data ->>'feature')::json->>'featureType')::text;
	v_table = replace(v_tablename,'v_edit_inp','inp_dscenario');
	
	IF v_table = 'inp_dscenario_junction' THEN v_table  = 'inp_dscenario_demand'; END IF;

	v_id= replace(replace(replace(v_id,'[','('),']',')'),'"','');
	
	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CREATE DSCENARIO'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '------------------------------');

	-- inserting on catalog table
	INSERT INTO cat_dscenario (name, dscenario_type) VALUES (v_name, v_type) ON CONFLICT (name) DO NOTHING
	RETURNING dscenario_id INTO v_scenarioid ;

	IF v_scenarioid IS NULL THEN
		SELECT dscenario_id INTO v_scenarioid FROM cat_dscenario where name = v_name;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	VALUES (v_fid, null, 4, concat('ERROR: The dscenario ( ',v_scenarioid,' ) already exists with proposed name ',v_name ,'. Please try another one.'));
	ELSE 
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	VALUES (v_fid, null, 4, concat('INFO: Process done successfully.'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('INFO: New scenario type ',v_type,' with name ''',v_name, ''' and id ''',v_scenarioid,''' have been created.'));

		-- getting columns
		IF v_table  = 'inp_dscenario_demand' THEN
			v_columns = 'node_id, demand, pattern_id, NULL , '||v_scenarioid||', ''NODE''';
		ELSIF v_table  = 'inp_dscenario_valve' THEN
			v_columns = v_scenarioid||', node_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings';
		ELSIF v_table  = 'inp_dscenario_tank' THEN
			v_columns = v_scenarioid||', node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id';
		ELSIF v_table  = 'inp_dscenario_reservoir' THEN
			v_columns = v_scenarioid||', node_id, pattern_id, head';
		ELSIF v_table  = 'inp_dscenario_pump' THEN
			v_columns = v_scenarioid||', node_id, power, curve_id, speed, pattern, status';
		ELSIF v_table  = 'inp_dscenario_pipe' THEN
			v_columns = v_scenarioid||', arc_id, minorloss, status, custom_roughness, custom_dint';
		ELSIF v_table  = 'inp_dscenario_shortpipe' THEN
			v_columns = v_scenarioid||', node_id, minorloss, status';				
		END IF;

		-- inserting values on tables
		IF v_selectionmode = 'wholeSelection' THEN
			v_querytext = 'INSERT INTO '||quote_ident(v_table)||' SELECT '||v_columns||' FROM '||quote_ident(v_tablename);
			EXECUTE v_querytext;	
		ELSE
			v_querytext = 'INSERT INTO '||quote_ident(v_table)||' SELECT '||v_columns||' FROM '||quote_ident(v_tablename)||' WHERE '||lower(v_featuretype)||'_id::integer IN '||v_id;
			EXECUTE v_querytext;	
		END IF;

		GET DIAGNOSTICS v_count = row_count;
		
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, v_result_id, 1, concat(v_count, ' rows with features have been inserted on table ', v_table,'.'));
		
		-- set selector
		INSERT INTO selector_inp_dscenario (dscenario_id,cur_user) VALUES (v_scenarioid, current_user) ON CONFLICT (dscenario_id,cur_user) DO NOTHING ;

	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3042, null, null, null); 

	-- manage exceptions
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;