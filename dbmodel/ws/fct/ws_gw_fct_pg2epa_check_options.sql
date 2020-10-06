/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2850

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_options(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_options($${"data":{"parameters":{"resultId":"gw_check_project","fid":227}}}$$) --when is called from go2epa_main from toolbox

-- fid:227 (passed by input parameters)
*/

DECLARE

v_fid integer;
v_version text;
v_project_type text;
v_count	integer;
v_result_id text;
v_networkmode integer;
v_patternmethod integer;
v_error_context text;
v_return text = '{"status":"accepted"}';

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_result_id := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid';

	-- select system values
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version order by 1 desc limit 1 ;
	
	-- get user values
	SELECT value INTO v_networkmode FROM config_param_user WHERE parameter = 'inp_options_networkmode' AND cur_user=current_user;
	SELECT value INTO v_patternmethod FROM config_param_user WHERE parameter = 'inp_options_patternmethod' AND cur_user=current_user;

	RAISE NOTICE 'v_networkmode % v_patternmethod %',v_networkmode , v_patternmethod ;
			
	-- check if pattern method is compatible
	IF v_networkmode IN (1,2) THEN
	
		IF v_patternmethod IN (21,22,23,33,34,43,44,53,54) THEN 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR: The pattern method used, it is incompatible with the export network mode used'));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, 'Change the pattern method using some of the (PJOINT) method avaliable or change export network USING some of TRIMED ARCS method avaliable.');
			v_return = '{"status":"Failed", "message":{"level":1, "text":"Pattern method and network mode are incompatibles. The process is aborted...."},"body":{"data":{}}}';
		END IF;

	ELSIF v_networkmode IN (3,4) THEN

		IF v_patternmethod IN (11,12,13,31,32,41,42,51,52) THEN 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR: The pattern method used, it is incompatible with the export network mode used'));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, 'Change the pattern method using some of the (NODE) method avaliable or change export network USING some of NOT TRIMED ARCS method avaliable.');
			v_return = '{"status":"Failed", "message":{"level":1, "text":"Pattern method and network mode are incompatibles. The process is aborted...."},"body":{"data":{}}}'; 
		END IF;
	END IF;

	-- check demand scenario compatibility
	IF (SELECT count(*) FROM selector_inp_demand WHERE cur_user = current_user) > 0 THEN

		-- check not allowed pattern method
		IF v_patternmethod IN (32,34,42,44,52,54) THEN 
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, concat('ERROR: The pattern method used, it is incompatible with use demand scenario.'));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result_id, 3, 'Unselect all your demand scenarios to work with this pattern method.');
			v_return = '{"status":"Failed", "message":{"level":1, "text":"Pattern method is incompatible to work with demand scenarios. The process is aborted...."},"body":{"data":{}}}'; 
		END IF;

		-- check inconsistency on demand scenario: More than one connec with same link and different pattern on inp_demand table
		IF v_patternmethod IN (21,22,23) THEN
			v_count = (SELECT sum(count) FROM 
			(SELECT count(*),exit_id FROM (SELECT exit_id, count(*) as times , pattern_id FROM vi_demands JOIN v_edit_link USING (feature_id) GROUP BY exit_id, pattern_id HAVING count(*) > 1 order by 1 desc) a GROUP by exit_id)b
			WHERE count > 1);
		
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, concat('WARNING: There are ',v_count,' vnodes with more than one connec with same link and different pattern on inp_demand table'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 2, 'Unselect all your demand scenarios to work with this pattern method.');
			END IF;
		END IF;
	END IF;

	--  Return
	RETURN gw_fct_json_create_return(v_return, 2850);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
	
