/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:3252


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_valve_status(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_valve_status($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{}}$$)

--fid:v_fid

*/

DECLARE


v_result_id text= 'import valve status';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_count integer;
v_label text;
v_error_context text;
v_level integer;
v_status text;
v_message text;
v_audit_result text;
v_fid integer;
v_dscenario_id integer;
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;
    
  v_fid = ((p_data ->>'data')::json->>'fid')::text;
   	
  
	-- manage log (fid:  v_fid)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('IMPORT VALVE STATUS'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('------------------------------'));

	
	-- control of rows
	SELECT count(*) INTO v_count FROM temp_csv WHERE cur_user=current_user AND fid = v_fid;

	IF v_count =0 THEN
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Nothing to import'));
	ELSE
		-- inserting on catalog table
		PERFORM setval('SCHEMA_NAME.cat_dscenario_dscenario_id_seq'::regclass,(SELECT max(dscenario_id) FROM cat_dscenario) ,true);

		INSERT INTO cat_dscenario(name, descript, dscenario_type, active,  log)
		SELECT DISTINCT csv1, null, 'SHORTPIPE', true, concat('Insert by ',current_user,' on ', substring(now()::text,0,20), ' from import csv file.') FROM temp_csv 
		WHERE cur_user=current_user AND fid = v_fid ON CONFLICT (name) DO NOTHING RETURNING dscenario_id INTO v_dscenario_id;

		IF v_dscenario_id IS NULL THEN
			SELECT dscenario_id INTO v_dscenario_id FROM cat_dscenario 
			JOIN temp_csv ON name = csv1 WHERE cur_user=current_user AND fid = v_fid LIMIT 1;
		END IF;

		INSERT INTO inp_dscenario_shortpipe(
		dscenario_id, node_id, status)
		SELECT v_dscenario_id, csv2, csv3 FROM temp_csv WHERE cur_user=current_user AND fid = v_fid ON CONFLICT (node_id, dscenario_id) DO UPDATE SET 
		status = EXCLUDED.status;

		-- manage log (fid: v_fid)
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Reading values from temp_csv table -> Done'));
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Inserting values on cat_dscenario table -> Done'));
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Inserting values on inp_dscenario_shortpipe table -> Done'));
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Process finished'));

	END IF;

	-- get log (fid: v_fid)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid) row;

	IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message = 'Process done successfully';
    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;


	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"values":',v_result, '}');
				
	-- Control nulls
	v_version := COALESCE(v_version, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 
	
	-- Return
	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
            ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
