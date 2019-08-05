/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)

--FUNCTION CODE: 2710

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_mincutzones(p_data json)
RETURNS integer AS
$BODY$

/*
CONFIG
mincut -1 must exists

SELECT * from SCHEMA_NAME.arc where arc_id='2205'

TO EXECUTE
-- for any exploitation you want
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mincutzones('{"data":{"parameters":{"exploitation": "[1]"}}}');

29 & 49 fprocesscat are relationed
29 it is one row for mincut to resume data for each minsector
49 it is detailed data for each minsector

TO SEE RESULTS ON LOG TABLE
SELECT log_message FROM SCHEMA_NAME.audit_log_data WHERE fprocesscat_id=49 AND user_name=current_user
SELECT log_message FROM SCHEMA_NAME.audit_log_data WHERE fprocesscat_id=29 AND user_name=current_user


TO SEE RESULTS ON SYSTEM TABLES (IN CASE OF "upsertAttributes":"TRUE")

*/

DECLARE
v_count1 integer = 0;
v_expl json;
v_data json;
v_arc text;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');

	INSERT INTO anl_mincut_result_cat VALUES (-1) ON CONFLICT (id) DO nothing;

	-- reset selectors
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);
	DELETE FROM selector_psector WHERE cur_user=current_user;

	-- reset previous data
	DELETE FROM audit_log_data WHERE user_name=current_user AND fprocesscat_id IN (29,49,34);
		
	-- reset exploitation
	IF v_expl IS NOT NULL THEN
		DELETE FROM selector_expl WHERE cur_user=current_user;
		INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, current_user FROM exploitation where macroexpl_id IN 
		(SELECT distinct(macroexpl_id) FROM SCHEMA_NAME.exploitation JOIN (SELECT (json_array_elements_text(v_expl))::integer AS expl)a  ON expl=expl_id);
	END IF;

	--call previous minsector function
	v_data = '{"data":{"upsertFeatureAttrib":"TRUE", "exploitation":"'||v_expl||'"}}';
	RAISE NOTICE 'v_data %', v_data;
	PERFORM gw_fct_grafanalytics_minsector(v_data);
	
	-- starting recursive process for all minsectors
	LOOP
		v_count1 = v_count1 + 1;

		--RAISE NOTICE 'MIN SECTOR %', v_arc;
		
		-- get arc_id represented minsector (fprocesscat = 34)			
		v_arc = (SELECT log_message FROM audit_log_data WHERE enabled IS NULL AND fprocesscat_id=34 AND user_name=current_user LIMIT 1);

		EXIT WHEN v_arc is null;
		
		-- set flag not don't take it in next loop
		UPDATE audit_log_data SET enabled=true WHERE log_message=v_arc AND fprocesscat_id=34 AND user_name=current_user;

		--call engine function
		PERFORM gw_fct_mincut(v_arc, 'arc', -1);
		
		-- insert results into audit table
		INSERT INTO audit_log_data (fprocesscat_id, feature_id, log_message)
		SELECT 49, v_arc, concat('"minsector_id":"',v_arc,'","node_id":"',node_id,'"') FROM anl_mincut_result_node WHERE result_id=-1;

		INSERT INTO audit_log_data (fprocesscat_id, feature_id, log_message)
		SELECT 49, v_arc, concat('"minsector_id":"',v_arc,'","arc_id":"',arc_id,'"') FROM anl_mincut_result_arc WHERE result_id=-1;
		
		INSERT INTO audit_log_data (fprocesscat_id, feature_id, log_message)
		SELECT 49, v_arc, concat('"minsector_id":"',v_arc,'","connec_id":"',connec_id,'"') FROM anl_mincut_result_connec WHERE result_id=-1;

		INSERT INTO audit_log_data (fprocesscat_id, feature_id, log_message)
		SELECT 49, v_arc, concat('"minsector_id":"',v_arc,'","valve_id":"',node_id,'"') FROM anl_mincut_result_valve WHERE result_id=-1;
		
		INSERT INTO audit_log_data (fprocesscat_id, feature_id, log_message)
		SELECT 49, v_arc, concat('"minsector_id":"',v_arc,'","hydrometer_id":"',hydrometer_id,'"') FROM anl_mincut_result_hydrometer WHERE result_id=-1;

	END LOOP;
	
RETURN v_count1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
