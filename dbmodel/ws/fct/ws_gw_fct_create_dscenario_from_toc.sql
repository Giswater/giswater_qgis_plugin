/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3108

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_create_dscenario_from_toc(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE

-- fid: 403
SELECT SCHEMA_NAME.gw_fct_create_dscenario_from_toc($${"client":{}, "form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, 
"data":{"selectionMode":"wholeSelection","parameters":{"name":"test", "descript":null, "type":"DEMAND"}}}$$);

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
v_descript text;
v_id text;
v_selectionmode text;
v_scenarioid integer;
v_tablename text;
v_featuretype text;
v_table text;
v_columns text;
v_finish boolean = false;
v_expl integer;
v_where text;
_key   text;
_value text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- getting input data
	-- parameters of action CREATE
	v_name :=  ((p_data ->>'data')::json->>'parameters')::json->>'name';
	v_descript :=  ((p_data ->>'data')::json->>'parameters')::json->>'descript';
	v_type :=  ((p_data ->>'data')::json->>'parameters')::json->>'type';
	v_expl :=  ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';

	v_id :=  ((p_data ->>'feature')::json->>'id');
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_tablename :=  ((p_data ->>'feature')::json->>'tableName')::text;
	v_featuretype :=  ((p_data ->>'feature')::json->>'featureType')::text;
	
	v_table = replace(v_tablename,'v_edit_inp','inp_dscenario');
	IF v_selectionmode = 'wholeSelection' THEN v_id= replace(replace(replace(v_id,'[','('),']',')'),'"','');END IF;

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
	VALUES ( v_name, v_descript, v_type, v_expl, concat('Insert by ',current_user,' on ', substring(now()::text,0,20))) ON CONFLICT (name) DO NOTHING
	RETURNING dscenario_id INTO v_scenarioid;

	IF v_scenarioid IS NULL THEN
		SELECT dscenario_id INTO v_scenarioid FROM cat_dscenario where name = v_name;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, null, 3, concat('ERROR: The dscenario ( ',v_scenarioid,' ) already exists with proposed name ',v_name ,'. Please try another one.'));
	ELSE 
	
		-- getting columns
		IF v_table  = 'inp_dscenario_junction' THEN
			v_columns = v_scenarioid||', node_id, demand, pattern_id';
		ELSIF v_table  = 'inp_dscenario_connec' THEN
			v_columns = v_scenarioid||', connec_id, demand, pattern_id';
		ELSIF v_table  = 'inp_dscenario_valve' THEN
			v_columns = v_scenarioid||', node_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings';
		ELSIF v_table  = 'inp_dscenario_tank' THEN
			v_columns = v_scenarioid||', node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, overflow';
		ELSIF v_table  = 'inp_dscenario_reservoir' THEN
			v_columns = v_scenarioid||', node_id, pattern_id, head';
		ELSIF v_table  = 'inp_dscenario_inlet' THEN
			v_columns = v_scenarioid||', node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, overflow, pattern_id, head';
		ELSIF v_table  = 'inp_dscenario_pump' THEN
			v_columns = v_scenarioid||', node_id, power, curve_id, speed, pattern, status';
		ELSIF v_table  = 'inp_dscenario_pipe' THEN
			v_columns = v_scenarioid||', arc_id, minorloss, status, custom_roughness, custom_dint';
		ELSIF v_table  = 'inp_dscenario_shortpipe' THEN
			v_columns = v_scenarioid||', node_id, minorloss, status';
		ELSE 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
			VALUES (v_fid, null, 3, concat('ERROR: The table choosed does not fit with any epa dscenario. Please try another one.'));
			v_finish = true;
		END IF;

		IF v_finish IS NOT TRUE THEN

			-- log
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	VALUES (v_fid, null, 1, concat('INFO: Process done successfully.'));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) 
			VALUES (v_fid, null, 4, concat('New scenario ',v_name,' have been created with id:',v_scenarioid,'.'));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Exploitation: ',v_expl));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Selection mode: ',v_selectionmode));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '');
			
			-- inserting values on tables
			IF v_selectionmode = 'wholeSelection' THEN
				v_querytext = 'INSERT INTO '||quote_ident(v_table)||' SELECT '||v_columns||' FROM '||quote_ident(v_tablename);
			ELSIF  v_selectionmode = 'previousSelection' THEN
				v_where = ' WHERE ';
				FOR _key, _value IN
			       SELECT * FROM jsonb_each(v_id)
			    LOOP
					_value = replace(replace(replace(_value, '"', ''''), '[', ''), ']', '');
					v_where = concat(v_where, _key, ' IN (', _value, ') AND ');
				END LOOP;
				v_where = substr(v_where, 1, length(v_where) - 5);
				v_querytext = 'INSERT INTO '||quote_ident(v_table)||' SELECT '||v_columns||' FROM '||quote_ident(v_tablename)|| v_where;
			END IF;

			EXECUTE v_querytext;	
			GET DIAGNOSTICS v_count = row_count;
			
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
			VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count, ' features have been inserted on table ', v_table,'.'));
			
			-- set selector
			INSERT INTO selector_inp_dscenario (dscenario_id,cur_user) VALUES (v_scenarioid, current_user) ON CONFLICT (dscenario_id,cur_user) DO NOTHING ;
			
		END IF;
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