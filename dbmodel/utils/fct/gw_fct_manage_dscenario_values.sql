/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3042

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_copy_dscenario_values(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_copy_dscenario_values($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"parameters":{"copyFrom":1, "target":2, "action":"DELETE-COPY"}}}$$)
SELECT SCHEMA_NAME.gw_fct_copy_dscenario_values($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"parameters":{"copyFrom":1, "target":2, "action":"KEEP-COPY"}}}$$)
SELECT SCHEMA_NAME.gw_fct_copy_dscenario_values($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"parameters":{"copyFrom":1, "target":2, "action":"DELETE-ONLY}}}$$)


-- fid: 403

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
v_source_name text;
v_target_name text;
v_action text;
v_querytext text;
v_result_id text = null;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- getting input data 	
	v_copyfrom :=  ((p_data ->>'data')::json->>'parameters')::json->>'copyFrom';
	v_target :=  ((p_data ->>'data')::json->>'parameters')::json->>'target';
	v_action :=  ((p_data ->>'data')::json->>'parameters')::json->>'action';
	
	-- getting scenario name
	v_source_name := (SELECT name FROM cat_dscenario WHERE dscenario_id = v_copyfrom);
	v_target_name := (SELECT name FROM cat_dscenario WHERE dscenario_id = v_target);
	
	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('MANAGE DSCENARIO VALUES FROM (', v_source_name, ') TO (', v_target_name,')'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '---------------------------------------------------------------------------------------');

	-- check dscenario type
	IF (SELECT dscenario_type FROM cat_dscenario WHERE dscenario_id = v_copyfrom) != (SELECT dscenario_type FROM cat_dscenario WHERE dscenario_id = v_target) THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 2, concat('WARNING-403: Dscenario type for (',v_source_name,') and (', v_target_name,') are not the same.'));
	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: (',v_source_name,') and (', v_target_name,') have same dscenario_type.'));
	END IF;

	IF v_copyfrom = v_target THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 3, concat('ERROR-403: Target and source are the same.'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 4, concat('Process has failed.'));	
	ELSE

		-- Computing process
		IF v_projecttype = 'UD' THEN

			FOR object_rec IN SELECT json_array_elements_text('["conduit", "junction", "raingage"]'::json) as table,
						json_array_elements_text('["arc_id", "node_id", "rg_id"'::json) as pk,
						json_array_elements_text('["arc_id, barrels, culvert, kentry, kexit, kavg, flap, q0, qmax, seepage, custom_n", 
									   "node_id, y0, ysur, apond, outfallparam",
									   "rg_id, form_type, intvl, scf, rgage_type, timser_id, fname, sta, units"]'::json) as column
			LOOP
				IF v_action = 'DELETE-COPY' THEN
					EXECUTE 'DELETE FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_target;

					-- get message
					GET DIAGNOSTICS v_count = row_count;
					IF v_count > 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been removed from inp_dscenario_',object_rec.table,' table.'));
					END IF;
				END IF;
				
				IF v_action = 'KEEP-COPY' OR  v_action = 'DELETE-COPY' THEN

					-- get message
					EXECUTE 'SELECT count(*) FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_target INTO v_count;
					IF v_count > 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been keep from inp_dscenario_',object_rec.table,' table.'));
					END IF;		

					v_querytext = 'INSERT INTO inp_dscenario_'||object_rec.table||' SELECT '||v_target||','||object_rec.column||' FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_copyfrom||
					'ON CONFLICT (dscenario_id, '||object_rec.pk||') DO NOTHING';
					RAISE NOTICE 'v_querytext %', v_querytext;
					EXECUTE v_querytext;	
				
					-- get message
					GET DIAGNOSTICS v_count2 = row_count;
					IF v_count > 0 AND v_count2 = 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_result_id, 1, concat('INFO: No rows have been inserted on inp_dscenario_',object_rec.table,' table.'));
					ELSIF v_count2 > 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been inserted on inp_dscenario_',object_rec.table,' table.'));
					END IF;
						
				ELSIF v_action = 'DELETE-ONLY' THEN

					EXECUTE 'DELETE FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_target;

					-- get message
					GET DIAGNOSTICS v_count = row_count;
					IF v_count > 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been removed from inp_',object_rec.table,' table.'));
					END IF;
				END IF;				
			END LOOP;		
				
		ELSIF v_projecttype = 'WS' THEN

			FOR object_rec IN SELECT json_array_elements_text('["demand", "shortpipe", "tank", "reservoir", "pipe", "pump", "valve"]'::json) as table,
						json_array_elements_text('["", "node_id", "node_id", "node_id", "arc_id", "node_id", "node_id"]'::json) as pk,
						json_array_elements_text('["", "node_id, minorloss, status", "node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id", 
						 "node_id, pattern_id, head", "arc_id, minorloss, status, roughness, dint", "node_id, power, curve_id, speed, pattern, status", 
						 "node_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings"]'::json) as column
			LOOP
				IF v_action = 'DELETE-COPY' THEN
				
					EXECUTE 'DELETE FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_target;

					-- get message
					GET DIAGNOSTICS v_count = row_count;
					IF v_count > 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been removed from inp_dscenario_',object_rec.table,' table.'));
					END IF;
				END IF;

				IF v_action = 'KEEP-COPY' OR  v_action = 'DELETE-COPY' THEN

					-- get message
					EXECUTE 'SELECT count(*) FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_target INTO v_count;
					IF v_count > 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been keep from inp_dscenario_',object_rec.table,' table.'));
					END IF;		

					IF object_rec.table = 'demand' THEN -- it is not possible to parametrize due table structure (dscenario_id is not first column)
						INSERT INTO inp_dscenario_demand SELECT feature_id, demand, pattern_id, demand_type, v_target, feature_type 
						FROM inp_dscenario_demand WHERE dscenario_id = v_copyfrom ON CONFLICT (dscenario_id, feature_id) DO NOTHING;
					ELSE
						v_querytext = 'INSERT INTO inp_dscenario_'||object_rec.table||' SELECT '||v_target||','||object_rec.column||' FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_copyfrom||
						'ON CONFLICT (dscenario_id, '||object_rec.pk||') DO NOTHING';
						RAISE NOTICE 'v_querytext %', v_querytext;
						EXECUTE v_querytext;	
					END IF;			

					-- get message
					GET DIAGNOSTICS v_count2 = row_count;
					IF v_count > 0 AND v_count2 = 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_result_id, 1, concat('INFO: No rows have been inserted on inp_dscenario_',object_rec.table,' table.'));
					ELSIF v_count2 > 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been inserted on inp_dscenario_',object_rec.table,' table.'));
					END IF;	

				ELSIF v_action = 'DELETE-ONLY' THEN

					EXECUTE 'DELETE FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_target;

					-- get message
					GET DIAGNOSTICS v_count = row_count;
					IF v_count > 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been removed from inp_',object_rec.table,' table.'));
					END IF;
				END IF;	
			END LOOP;		
		END IF;

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: Process done successfully.'));
	
		-- set selector
		INSERT INTO selector_inp_dscenario (dscenario_id,cur_user) VALUES (v_target, current_user) ON CONFLICT (dscenario_id,cur_user) DO NOTHING ;

	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
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