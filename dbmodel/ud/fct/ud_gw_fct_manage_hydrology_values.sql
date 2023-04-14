/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3100

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_manage_hydrology_values(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_manage_hydrology_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"target":"2", "copyFrom":"1", "sector":"1", "action":"DELETE-COPY"}}}$$);
SELECT SCHEMA_NAME.gw_fct_manage_hydrology_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"target":"2", "copyFrom":"1", "sector":"1", "action":"KEEP-COPY"}}}$$);
SELECT SCHEMA_NAME.gw_fct_manage_hydrology_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"target":"2", "copyFrom":"1", "sector":"1", "action":"DELETE-ONLY"}}}$$);

-- fid: 398

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
v_fid integer = 398;
v_source_name text;
v_target_name text;
v_action text;
v_querytext text;
v_sectors integer;
v_sector integer;
v_sector_name text;
v_sector_list text[];
rec text;
BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- getting input data 	
	v_copyfrom :=  ((p_data ->>'data')::json->>'parameters')::json->>'copyFrom';
	v_target :=  ((p_data ->>'data')::json->>'parameters')::json->>'target';
	v_sectors :=  ((p_data ->>'data')::json->>'parameters')::json->>'sector';
	v_action :=  ((p_data ->>'data')::json->>'parameters')::json->>'action';
		
	-- getting scenario name
	v_source_name := (SELECT name FROM cat_hydrology WHERE hydrology_id = v_copyfrom);
	v_target_name := (SELECT name FROM cat_hydrology WHERE hydrology_id = v_target);

	IF v_sectors = -999 THEN
		SELECT array_agg(sector_id) INTO v_sector_list FROM  sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user;
	ELSE
		SELECT array_agg(sector_id) INTO v_sector_list FROM  sector WHERE sector_id = v_sectors;
	END IF;
		

-- Reset values
		DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;	
			
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, -1, 4, concat('MANAGE HYDROLOGY VALUES'));


	FOREACH rec IN ARRAY(v_sector_list) LOOP 

		v_sector = rec;

		v_sector_name := (SELECT name FROM sector WHERE sector_id = v_sector);
			
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 4, '------------------------------------------');
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 4, concat(''));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 4, concat('Target scenario: ',v_target_name));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 4, concat('Action: ',v_action));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 4, concat('Sector: ',v_sector_name));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 4, concat('Copy from scenario: ',v_source_name));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 4, concat(''));

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 3, 'ERRORS');
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 3, '--------');
			
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 2, 'WARNINGS');
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 2, '---------');

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 1, 'INFO');
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_sector, 1, '---------');
		 
		-- check controlmethod
		IF (SELECT infiltration FROM cat_hydrology WHERE hydrology_id = v_copyfrom) != (SELECT infiltration FROM cat_hydrology WHERE hydrology_id = v_target) THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_sector, 3, concat('PROCESS HAS FAILED......'));	
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_sector, 3, concat('ERROR-403: Infiltration method for (',v_source_name,') and (', v_target_name,') are not the same.'));

			
		ELSIF v_copyfrom = v_target AND v_action NOT IN ('INSERT-ONLY','DELETE-ONLY') THEN
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_sector, 3, concat('PROCESS HAS FAILED......'));	
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_sector, 3, concat('ERROR-403: Target and source are the same.'));
		ELSE
			IF v_action NOT IN ('INSERT-ONLY','DELETE-ONLY') THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_sector, 1, concat('INFO: Target and source have same infiltration method.'));
			END IF;

		FOR object_rec IN SELECT json_array_elements_text('["subcatchment", "loadings", "groundwater", "coverage"]'::json) as table,
			json_array_elements_text('["subc_id", "subc_id, poll_id", "subc_id", "subc_id, landus_id"]'::json) as pk,
			json_array_elements_text('[
			"subc_id, outlet_id, rg_id, area, imperv, width, slope, clength, snow_id, nimp, nperv, simp, sperv, zero, routeto, rted, maxrate, minrate, decay, drytime, maxinfil, suction, conduct, initdef, curveno, conduct_2, drytime_2, sector_id", 
			"poll_id, subc_id, ibuildup", 
			"subc_id,  aquif_id, node_id, surfel, a1, b1, a2, b2, a3, tw, h, fl_eq_lat, fl_eq_deep",
			"subc_id, landus_id, t.percent"]'::json) as column
				
			LOOP
				IF v_action = 'DELETE-COPY' THEN

					raise notice ' % %', object_rec.table, v_target;
					EXECUTE 'DELETE FROM inp_'||object_rec.table||' WHERE hydrology_id = '||v_target;

					-- get message
					GET DIAGNOSTICS v_count = row_count;
					IF v_count > 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_sector, 2, concat('WARNING: ',v_count,' row(s) have been removed from inp_',object_rec.table,' table.'));
					END IF;
				END IF;
						
				IF v_action = 'KEEP-COPY' OR  v_action = 'DELETE-COPY' THEN

					-- get message
					EXECUTE 'SELECT count(*) FROM inp_'||object_rec.table||' WHERE hydrology_id = '||v_target INTO v_count;
					IF v_count > 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_sector, 1, concat('INFO: ',v_count,' row(s) have been keep from inp_',object_rec.table,' table.'));
					END IF;	

					IF object_rec.table = 'subcatchment' THEN

						v_querytext = 'INSERT INTO inp_subcatchment SELECT '||object_rec.column||', '||v_target||',the_geom, descript FROM inp_subcatchment WHERE hydrology_id = '||v_copyfrom||' AND sector_id = '||v_sector||
						' ON CONFLICT (hydrology_id, subc_id) DO NOTHING';
						RAISE NOTICE 'v_querytext % % % % %', v_querytext, v_target,object_rec, v_copyfrom,v_sector ;
						EXECUTE v_querytext;	
					ELSE
						v_querytext = 'INSERT INTO inp_'||object_rec.table||' SELECT '||object_rec.column||', '||v_target||' FROM inp_'||object_rec.table||' t JOIN inp_subcatchment USING (subc_id, hydrology_id) 
						WHERE hydrology_id = '||v_copyfrom||' AND sector_id = '||v_sector||
						' ON CONFLICT (hydrology_id, '||object_rec.pk||') DO NOTHING';
											
						EXECUTE v_querytext;	
					END IF;			
					
					-- get message
					GET DIAGNOSTICS v_count2 = row_count;
					IF v_count > 0 AND v_count2 = 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_sector, 1, concat('INFO: No rows have been inserted on inp_',object_rec.table,' table.'));
					ELSIF v_count2 > 0 THEN
						INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
						VALUES (v_fid, v_sector, 1, concat('INFO: ',v_count2,' row(s) have been inserted on inp_',object_rec.table,' table.'));
					END IF;		
						
				ELSIF v_action = 'DELETE-ONLY' THEN
					IF object_rec.table = 'subcatchment' THEN
						IF (SELECT DISTINCT (hydrology_id) FROM v_edit_inp_subcatchment LIMIT 1) = v_target THEN
							INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
							VALUES (v_fid, v_sector, 3, concat('PROCESS HAS BEEN CANCELED......'));	
							INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
							VALUES (v_fid, v_sector, 3, concat('ERROR: Delete have been disabled because it is the current scenario.'));
							
					 ELSE
							EXECUTE 'DELETE FROM v_edit_inp_'||object_rec.table||' WHERE hydrology_id = '||v_target;

								-- get message
							GET DIAGNOSTICS v_count = row_count;
							INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
							VALUES (v_fid, v_sector, 1, concat('INFO: ',v_count,' row(s) have been removed from inp_',object_rec.table,' table.'));
						END IF;
					END IF;

					END IF;
			END LOOP;		

			-- set selector
			UPDATE config_param_user SET value = v_target WHERE parameter = 'inp_options_hydrology_scenario' AND cur_user = current_user;

		END IF;
	END LOOP;

	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat(''));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, concat(''));
		
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by result_id, criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||
				'}}'||
		    '}')::json, 3100, null, null, null); 

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

