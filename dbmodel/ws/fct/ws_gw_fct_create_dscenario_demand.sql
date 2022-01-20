/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3112

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_create_dscenario_demand(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE

-- fid: 403
SELECT SCHEMA_NAME.gw_fct_create_dscenario_demand($${"client":{}, "form":{}, "feature":{"tableName":"v_edit_inp_connec", "featureType":"CONNEC", "id":[]}, "data":{"selectionMode":"wholeSelection","parameters":{"name":"1test", "descript":""}}}$$);
SELECT SCHEMA_NAME.gw_fct_create_dscenario_demand($${"client":{}, "form":{}, "feature":{"tableName":"v_edit_inp_connec", "featureType":"CONNEC", "id":[]}, "data":{"selectionMode":"wholeSelection","parameters":{"name":"uuuu", "descript":""}}}$$);
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
v_descript text;
v_id text;
v_selectionmode text;
v_scenarioid integer;
v_tablename text;
v_featuretype text;
v_table text;
v_columns text;
v_queryfilter text;
v_expl integer;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- getting input data
	-- parameters of action CREATE
	v_name :=  ((p_data ->>'data')::json->>'parameters')::json->>'name';
	v_descript :=  ((p_data ->>'data')::json->>'parameters')::json->>'descript';
	v_expl :=  ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';
	
	v_id :=  ((p_data ->>'feature')::json->>'id');
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_tablename :=  ((p_data ->>'feature')::json->>'tableName')::text;
	v_featuretype := ((p_data ->>'feature')::json->>'featureType')::text;

	v_id= replace(replace(replace(v_id,'[','('),']',')'),'"','');

	IF v_id IS NULL THEN v_id = '()';END IF;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	-- create log
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CREATE DSCENARIO'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, 'ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, '--------');
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, '---------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, '---------');

	-- inserting on catalog table
	PERFORM setval('SCHEMA_NAME.cat_dscenario_dscenario_id_seq'::regclass,(SELECT max(dscenario_id) FROM cat_dscenario) ,true);

	INSERT INTO cat_dscenario ( name, descript, dscenario_type, expl_id, log) 
	VALUES ( v_name, v_descript, 'DEMAND', v_expl, concat('Insert by ',current_user,' on ', substring(now()::text,0,20))) ON CONFLICT (name) DO NOTHING
	RETURNING dscenario_id INTO v_scenarioid;

	IF v_scenarioid IS NULL THEN
		SELECT dscenario_id INTO v_scenarioid FROM cat_dscenario where name = v_name;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, null, 3, concat('ERROR: The dscenario ( ',v_scenarioid,' ) already exists with proposed name ',v_name ,'. Please try another one.'));
	ELSE 

		-- insert process
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('New scenario ',v_name,' have been created with id:',v_scenarioid,'.'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Feature type: ',v_featuretype));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Exploitation: ',v_expl));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Selection mode: ',v_selectionmode));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	VALUES (v_fid, null, 1, concat('INFO: Process done successfully.'));
		
		-- queryfilter
		IF v_selectionmode = 'previousSelection' THEN
			v_queryfilter = ' WHERE '||lower(v_featuretype)||'_id::integer IN '||v_id||' AND demand is not null';
		ELSE
			v_queryfilter = ' WHERE demand is not null';
		END IF;	

		IF v_tablename = 'v_edit_inp_junction' THEN
			v_querytext =  'INSERT INTO inp_dscenario_demand (dscenario_id, feature_id, feature_type, demand, pattern_id, source) 
					SELECT '|| v_scenarioid||', node_id, ''NODE'', demand, pattern_id, concat(''NODE '',node_id) FROM v_edit_inp_junction '||v_queryfilter;

		ELSIF v_tablename = 'v_edit_inp_connec' THEN		
			v_querytext = 'INSERT INTO inp_dscenario_demand (dscenario_id, feature_id, feature_type, demand, pattern_id, source) 
					SELECT '|| v_scenarioid||', connec_id, ''CONNEC'', demand, pattern_id, concat(''CONNEC '',connec_id) FROM v_edit_inp_connec '||v_queryfilter;
		ELSE 
			v_querytext ='';
		END IF;	

		EXECUTE v_querytext;	

		-- log
		GET DIAGNOSTICS v_count = row_count;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count, ' rows with features have been inserted on table ', v_table,'.'));
		
		-- set selector
		INSERT INTO selector_inp_dscenario (dscenario_id,cur_user) VALUES (v_scenarioid, current_user) ON CONFLICT (dscenario_id,cur_user) DO NOTHING ;

	END IF;

	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat(''));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, concat(''));
	
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