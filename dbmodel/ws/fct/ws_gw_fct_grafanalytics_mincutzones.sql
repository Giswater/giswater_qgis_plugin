/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)

--FUNCTION CODE: 2712

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_mincutzones(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_mincutzones(p_data json)
RETURNS json AS
$BODY$

/*
CONFIG
mincut -1 must exists

SELECT * from SCHEMA_NAME.arc where arc_id='2205'

TO EXECUTE
-- for any exploitation you want
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mincutzones('{"data":{"parameters":{"exploitation": "[1]", "checkData":true}}}');

TO SEE RESULTS ON LOG TABLE
SELECT log_message FROM SCHEMA_NAME.audit_log_data WHERE fid=149 AND cur_user=current_user
SELECT log_message FROM SCHEMA_NAME.audit_log_data WHERE fid=129 AND cur_user=current_user

TO SEE RESULTS ON SYSTEM TABLES (IN CASE OF "upsertAttributes":"TRUE")

--fid: 
125, 134
129 & 149 fid: are relationed
129 it is one row for mincut to resume data for each minsector
149 it is detailed data for each minsector

*/

DECLARE

v_count1 integer = 0;
v_expl json;
v_data json;
v_arc text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result text;
v_count	integer;
v_version text;
v_fid integer = 129;
v_input	json;
v_count2 integer;
v_error_context text;
v_checkdata boolean;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_checkdata = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'checkData');

	-- select config values
	SELECT giswater INTO v_version FROM sys_version order by 1 desc limit 1;

	-- data quality analysis
	IF v_checkdata THEN
		v_input = '{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{"selectionMode":"userSelectors"}}}'::json;
		PERFORM gw_fct_om_check_data(v_input);
	END IF;

	-- check criticity of data in order to continue or not
	SELECT count(*) INTO v_count FROM audit_check_data WHERE cur_user="current_user"() AND fid=125 AND criticity=3;
	IF v_count > 3 THEN
	
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
		FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=125 order by criticity desc, id asc) row;

		v_result := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

		-- Control nulls
		v_result_info := COALESCE(v_result_info, '{}'); 
		
		--  Return
		RETURN ('{"status":"Accepted", "message":{"level":3, "text":"Mapzones dynamic analysis canceled. Data is not ready to work with"}, "version":"'||v_version||'"'||
		',"body":{"form":{}, "data":{ "info":'||v_result_info||'}}}')::json;	
	END IF;
 
	-- reset previous data
	DELETE FROM audit_log_data WHERE cur_user=current_user AND fid IN (129,149);
	DELETE FROM audit_check_data WHERE cur_user=current_user AND fid =v_fid;

	-- Starting process
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('MASSIVE MINCUT ANALYSIS (fid 129 & 149)'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('----------------------------------------------------------------------'));

	
	INSERT INTO om_mincut VALUES (-1, 'Massive Mincut (system)') ON CONFLICT (id) DO nothing;

	-- reset selectors
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);
	DELETE FROM selector_psector WHERE cur_user=current_user;
		
	-- reset exploitation
	IF v_expl IS NOT NULL THEN
		DELETE FROM selector_expl WHERE cur_user=current_user;
		INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, current_user FROM exploitation where macroexpl_id IN 
		(SELECT distinct(macroexpl_id) FROM SCHEMA_NAME.exploitation JOIN (SELECT (json_array_elements_text(v_expl))::integer AS expl)a  ON expl=expl_id);
	END IF;

	INSERT INTO anl_arc (fid, arc_id, descript)	SELECT 134, arc_id, minsector_id FROM arc WHERE state = 1;

	SELECT count(*) into v_count1 FROM arc WHERE state = 1 AND minsector_id IS NOT NULL;
	SELECT count(*) into v_count2 FROM arc WHERE state = 1 AND minsector_id IS NULL;

	IF v_count1 = 0 THEN
		INSERT INTO audit_check_data (fid, error_message) VALUES
		(v_fid, concat('WARNING: All arcs (state=1) on the selected exploitation(s) have not minsector_id informed. Please check your data before continue'));
	ELSIF v_count2 > 0 THEN 
		INSERT INTO audit_check_data (fid, error_message) VALUES
		(v_fid, concat('WARNING: There are ',v_count2, ' arcs (state=1) on the selected exploitation(s) without minsector_id informed. Please check your data before continue'));
	ELSE 
		INSERT INTO audit_check_data (fid, error_message) VALUES (
		v_fid, concat('There are ',v_count1, ' arcs (state=1) on the selected exploitation(s) and all of them have minsector_id informed.'));

		v_count1 = 0;
	
		-- starting recursive process for all minsectors
		LOOP
			v_count1 = v_count1 + 1;
		
			-- get arc_id represented minsector (fid: 134)			
			v_arc = (SELECT descript FROM anl_arc WHERE result_id IS NULL AND fid=134 AND cur_user=current_user LIMIT 1);

			EXIT WHEN v_arc is null;
		
			-- set flag not don't take it in next loop
			UPDATE anl_arc SET result_id='flag' WHERE descript=v_arc AND fid=134 AND cur_user=current_user;

			--call engine function
			PERFORM gw_fct_mincut(v_arc, 'arc', -1);
		
			-- insert results into audit table
			INSERT INTO audit_log_data (fid, feature_id, log_message)
			SELECT 149, v_arc, concat('"minsector_id":"',v_arc,'","node_id":"',node_id,'"') FROM om_mincut_node WHERE result_id=-1;

			INSERT INTO audit_log_data (fid, feature_id, log_message)
			SELECT 149, v_arc, concat('"minsector_id":"',v_arc,'","arc_id":"',arc_id,'"') FROM om_mincut_arc WHERE result_id=-1;
		
			INSERT INTO audit_log_data (fid, feature_id, log_message)
			SELECT 149, v_arc, concat('"minsector_id":"',v_arc,'","connec_id":"',connec_id,'"') FROM om_mincut_connec WHERE result_id=-1;

			INSERT INTO audit_log_data (fid, feature_id, log_message)
			SELECT 149, v_arc, concat('"minsector_id":"',v_arc,'","valve_id":"',node_id,'"') FROM om_mincut_valve WHERE result_id=-1;
		
			INSERT INTO audit_log_data (fid, feature_id, log_message)
			SELECT 149, v_arc, concat('"minsector_id":"',v_arc,'","hydrometer_id":"',hydrometer_id,'"') FROM om_mincut_hydrometer WHERE result_id=-1;

		END LOOP;

		-- message
		INSERT INTO audit_check_data (fid, error_message)
		VALUES (v_fid, concat('Massive analysis have been done. ',v_count1, ' mincut''s have been triggered (one by each minsector all of them using the mincut_id = -1). To check results you can query:'));
		INSERT INTO audit_check_data (fid, error_message)
		VALUES (v_fid, concat('RESUME (fid : 129)'));
		INSERT INTO audit_check_data (fid, error_message)
		VALUES (v_fid, concat('SELECT log_message FROM SCHEMA_NAME.audit_log_data WHERE fid=129 AND cur_user=current_user'));
		INSERT INTO audit_check_data (fid, error_message)
		VALUES (v_fid, concat('DETAIL (fid : 149)'));
		INSERT INTO audit_check_data (fid, error_message)
		VALUES (v_fid, concat('SELECT log_message FROM SCHEMA_NAME.audit_log_data WHERE fid=149 AND cur_user=current_user'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, '');
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, 'RESUME');
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, '-------------------------------------------------');
		INSERT INTO audit_check_data (fid, error_message)
		SELECT 129, reverse(substring(reverse(substring(log_message,2,999)),2,999)) FROM audit_log_data 
		WHERE fid=129 AND cur_user=current_user ORDER BY (((log_message::json->>'connecs')::json->>'hydrometers')::json->>'total')::integer desc;
		
	END IF;
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by id) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}');
	
	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Mincut massive process done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||
				'}'||
		       '}'||
	    '}')::json;
	
	RETURN v_count1;

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
