/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:3046

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_import_inp_timeseries(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_inp_timeseries(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_inp_timeseries($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{}}$$)

--fid:385

*/

DECLARE

rec_csv record;
v_result_id text= 'import inp timeseries';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_fid integer = 385;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- manage log (fid: v_fid)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('IMPORT INP TIMESERIES'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('----------------------------------'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Reading values from temp_csv table -> Done'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Cheking for exisiting curve id on table inp_timeseries -> Done'));

	-- reset sequence
	PERFORM setval('SCHEMA_NAME.inp_timeseries_value_id_seq', (SELECT max(id) FROM inp_timeseries_value), true);

  	-- starting process
 	FOR rec_csv IN SELECT * FROM temp_csv WHERE cur_user=current_user AND fid = v_fid
	LOOP

		IF rec_csv.csv1 IS NOT NULL THEN -- to control those null rows because user has a bad structured csv file (common last lines)
			
			IF rec_csv.csv1 NOT IN (SELECT id FROM inp_timeseries) THEN

				-- insert log
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message, table_id) 
				VALUES (v_fid, v_result_id, 1, concat('INFO: Timeseries id (',rec_csv.csv1,') have been imported succesfully'), rec_csv.csv1);

				-- insert inp_timeseries
				INSERT INTO inp_timeseries VALUES (rec_csv.csv1, rec_csv.csv2,  rec_csv.csv3, rec_csv.csv1, concat('Imported by ',current_user,' on ', now()::date));
				
				-- insert into inp_timeseries_value
				IF rec_csv.csv3 = 'ABSOLUTE' THEN			
					INSERT INTO inp_timeseries_value (timser_id, date, hour, value) VALUES
					(rec_csv.csv1, rec_csv.csv4::date, rec_csv.csv5::time, rec_csv.csv6::float);
				ELSIF rec_csv.csv3 = 'RELATIVE' THEN
					INSERT INTO inp_timeseries_value (timser_id, "time", value) VALUES
					(rec_csv.csv1, rec_csv.csv4::time, rec_csv.csv5::float);
				END IF;


			ELSIF rec_csv.csv1 IN (SELECT id FROM inp_timeseries) AND rec_csv.csv1 IN (SELECT table_id FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user)   THEN

				-- insert into inp_timeseries_value
				IF rec_csv.csv3 = 'ABSOLUTE' THEN			
					INSERT INTO inp_timeseries_value (timser_id, date, hour, value) VALUES
					(rec_csv.csv1, rec_csv.csv4::date, rec_csv.csv5::time, rec_csv.csv6::float);
				ELSIF rec_csv.csv3 = 'RELATIVE' THEN
					INSERT INTO inp_timeseries_value (timser_id, "time", value) VALUES
					(rec_csv.csv1, rec_csv.csv4::time, rec_csv.csv5::float);
				END IF;

			ELSE 
			
				IF rec_csv.csv1 in (SELECT column_id FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user) THEN 
				
				ELSE 
					-- insert log
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message, column_id, cur_user) 
					VALUES (v_fid, v_result_id, 2, 
					concat('WARNING: Timseries id (',rec_csv.csv1,') already exists on inp_timeseries -> Import have been canceled for this timeseries'), rec_csv.csv1, current_user);
				END IF;
			END IF;
		END IF;
	END LOOP;

	-- manage log (fid: v_fid)
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 1, concat('Process finished'));

	-- get log (fid: v_fid)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid ORDER BY criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
			
	-- Control nulls
	v_version := COALESCE(v_version, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 
 
	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":0, "text":"Process executed"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;
	    
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","message":{"level":2, "text":' || to_json(SQLERRM) || '}, "version":"'|| v_version ||'","SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
