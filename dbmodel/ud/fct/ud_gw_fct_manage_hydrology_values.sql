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
SELECT SCHEMA_NAME.gw_fct_manage_hydrology_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"source":"1", "target":"2", "sector":"1", "currentValues":"DELETE"}}}$$);
-- fid: 398

*/


DECLARE

object_rec record;
v_version text;
v_result json;
v_result_info json;
v_source_id integer;
v_target_id integer;
v_error_context text;
v_count integer;
v_count2 integer;
v_projecttype text;
v_fid integer = 398;
v_source_name text;
v_target_name text;
v_current_values text;
v_querytext text;
v_sector integer;
v_result_id text = null;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- getting input data 	
	v_source_id :=  ((p_data ->>'data')::json->>'parameters')::json->>'source';
	v_target_id :=  ((p_data ->>'data')::json->>'parameters')::json->>'target';
	v_sector :=  ((p_data ->>'data')::json->>'parameters')::json->>'sector';
	v_current_values :=  ((p_data ->>'data')::json->>'parameters')::json->>'currentValues';
	
	-- getting scenario name
	v_source_name := (SELECT name FROM cat_hydrology WHERE hydrology_id = v_source_id);
	v_target_name := (SELECT name FROM cat_hydrology WHERE hydrology_id = v_target_id);
	
	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('MANAGE HYDROLOGY VALUES FROM ', v_source_name, ' TO ', v_target_name));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '---------------------------------------------------------------------------------------');
 
	-- check controlmethod
	IF (SELECT infiltration FROM cat_hydrology WHERE hydrology_id = v_source_id) != (SELECT infiltration FROM cat_hydrology WHERE hydrology_id = v_target_id) THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 3, concat('ERROR-403: Infiltration method for (',v_source_name,') and (', v_target_name,') are not the same.'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 4, concat('Process has failed.'));
		
	ELSIF v_source_id = v_target_id THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 3, concat('ERROR-403: Target and source are the same.'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 4, concat('Process has failed.'));	

	ELSE
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('INFO: (',v_source_name,') and (', v_target_name,') have same infiltration method.'));

		FOR object_rec IN SELECT json_array_elements_text('["subcatchment", "lid_usage", "loadings_pol_x_subc", "groundwater", "coverage_land_x_subc"]'::json) as table,
		json_array_elements_text('["subc_id", "subc_id, lidco_id", "subc_id, poll_id", "subc_id", "subc_id, landus_id"]'::json) as pk,
		json_array_elements_text('[
		"subc_id, outlet_id, rg_id, area, imperv, width, slope, clength, snow_id, nimp, nperv, simp, sperv, zero, routeto, rted, maxrate, minrate, decay, drytime, maxinfil, suction, conduct, initdef, curveno, conduct_2, drytime_2, sector_id", 
		"subc_id, lidco_id, number, t.area, t.width, initsat, fromimp, toperv, rptfile, t.descript",
		"poll_id, subc_id, ibuildup", 
		"subc_id,  aquif_id, node_id, surfel, a1, b1, a2, b2, a3, tw, h, fl_eq_lat, fl_eq_deep",
		"subc_id, landus_id, t.percent"]'::json) as column
		
		LOOP
			IF v_current_values = 'DELETE' THEN

				EXECUTE 'DELETE FROM inp_'||object_rec.table||' WHERE hydrology_id = '||v_target_id;

				-- get message
				GET DIAGNOSTICS v_count = row_count;
				IF v_count > 0 THEN
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been removed from inp_',object_rec.table,' table.'));
				END IF;
			END IF;
				
			IF v_current_values = 'KEEP' OR  v_current_values = 'DELETE' THEN

				-- get message
				EXECUTE 'SELECT count(*) FROM inp_'||object_rec.table||' WHERE hydrology_id = '||v_target_id INTO v_count;
				IF v_count > 0 THEN
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been keep from inp_',object_rec.table,' table.'));
				END IF;	

				IF object_rec.table = 'subcatchment' THEN

					v_querytext = 'INSERT INTO inp_subcatchment SELECT '||object_rec.column||', '||v_target_id||',the_geom, descript FROM inp_subcatchment WHERE hydrology_id = '||v_source_id||' AND sector_id = '||v_sector||
					' ON CONFLICT (hydrology_id, subc_id) DO NOTHING';
					RAISE NOTICE 'v_querytext % % % % %', v_querytext, v_target_id,object_rec, v_source_id,v_sector ;
					EXECUTE v_querytext;	
				ELSE
					v_querytext = 'INSERT INTO inp_'||object_rec.table||' SELECT '||object_rec.column||', '||v_target_id||' FROM inp_'||object_rec.table||' t JOIN inp_subcatchment USING (subc_id, hydrology_id) 
					WHERE hydrology_id = '||v_source_id||' AND sector_id = '||v_sector||
					' ON CONFLICT (hydrology_id, '||object_rec.pk||') DO NOTHING';
					RAISE NOTICE 'v_querytext %', v_querytext;
					EXECUTE v_querytext;	
				END IF;			
			
				-- get message
				GET DIAGNOSTICS v_count2 = row_count;
				IF v_count > 0 AND v_count2 = 0 THEN
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 1, concat('INFO: No rows have been inserted on inp_',object_rec.table,' table.'));
				ELSIF v_count2 > 0 THEN
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count2,' row(s) have been inserted on inp_',object_rec.table,' table.'));
				END IF;		
				
			ELSIF v_current_values = 'DELONLY' THEN

				EXECUTE 'DELETE FROM inp_'||object_rec.table||' WHERE hydrology_id = '||v_target_id;

				-- get message
				GET DIAGNOSTICS v_count = row_count;
				IF v_count > 0 THEN
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been removed from inp_',object_rec.table,' table.'));
				END IF;
			END IF;
		END LOOP;		

		-- set selector
		UPDATE config_param_user SET value = v_target_id WHERE parameter = 'inp_options_hydrology_scenario' AND cur_user = current_user;

	END IF;
	
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
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