/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:3046

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_import_inp_timeseries(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_inp_timeseries(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_inp_timeseries($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{}}$$)

-- fid:385

ORDER:
timseries, timser_type, times_type, descript, expl_id, date, hour, time, value
csv1, csv2, csv3, csv4, csv5, csv6, csv7, csv8, csv9
csv1 = timseries, csv2 = timser_type, csv3 = times_type, csv4 = descript, csv5 = expl_id, csv6 = date, csv7 = hour, csv8 = time, csv9 = value

*/

DECLARE

rec_csv record;
v_result_id text= 'import inp timeseries';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_fid integer = 385;
v_timsertype text;
v_count integer = 0;


BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- manage log (fid: v_fid)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user = CURRENT_USER;
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('IMPORT INP TIMESERIES'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('----------------------------------'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Reading values from temp_csv table -> Done'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Checking exisiting curve id on table inp_timeseries -> Done'));

	-- reset sequence
	PERFORM setval('SCHEMA_NAME.inp_timeseries_value_id_seq', (SELECT max(id) FROM inp_timeseries_value), true);

  	-- starting process
 	FOR rec_csv IN SELECT * FROM temp_csv WHERE cur_user = CURRENT_USER AND fid = v_fid
	LOOP
		IF rec_csv.csv1 IS NOT NULL THEN -- to control those null rows because user has a bad structured csv file (common last lines)

			IF rec_csv.csv1 NOT IN (SELECT id FROM inp_timeseries) THEN

				-- insert log
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message, table_id)
				VALUES (v_fid, v_result_id, 1, concat('INFO: Timeseries id (',rec_csv.csv1,') have been imported succesfully'), rec_csv.csv1);

				-- insert inp_timeseries
				INSERT INTO inp_timeseries (id, timser_type, times_type, descript, expl_id, log, addparam)
				VALUES (rec_csv.csv1, rec_csv.csv2, rec_csv.csv3, rec_csv.csv4, rec_csv.csv5::integer, concat('Insert by ',CURRENT_USER,' on ', substring(now()::text,0,20)), rec_csv.csv6::json);

				-- insert into inp_timeseries_value
				IF rec_csv.csv3 = 'ABSOLUTE' THEN
					INSERT INTO inp_timeseries_value (timser_id, date, hour, value) VALUES
					(rec_csv.csv1, rec_csv.csv6, rec_csv.csv7, rec_csv.csv9::float);
				ELSIF rec_csv.csv3 = 'RELATIVE' THEN
					INSERT INTO inp_timeseries_value (timser_id, "time", value) VALUES
					(rec_csv.csv1, rec_csv.csv8, rec_csv.csv9::float);
				END IF;

				v_timsertype = rec_csv.csv3;

				v_count = v_count + 1;

			ELSIF rec_csv.csv1 IN (SELECT id FROM inp_timeseries) AND rec_csv.csv1 IN (SELECT table_id FROM audit_check_data WHERE fid = v_fid AND cur_user = CURRENT_USER)   THEN

				-- insert into inp_timeseries_value
				IF v_timsertype = 'ABSOLUTE' THEN
					INSERT INTO inp_timeseries_value (timser_id, date, hour, value) VALUES
					(rec_csv.csv1, rec_csv.csv6, rec_csv.csv7, rec_csv.csv9::float);
				ELSIF v_timsertype = 'RELATIVE' THEN
					INSERT INTO inp_timeseries_value (timser_id, "time", value) VALUES
					(rec_csv.csv1, rec_csv.csv8, rec_csv.csv9::float);
				END IF;

				v_count = v_count + 1;
			ELSE
				IF rec_csv.csv1 in (SELECT column_id FROM audit_check_data WHERE fid = v_fid AND cur_user=CURRENT_USER) THEN

				ELSE
					-- insert log
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message, column_id, cur_user)
					VALUES (v_fid, v_result_id, 2,
					concat('WARNING: Timseries id (',rec_csv.csv1,') already exists on inp_timeseries -> Import have been canceled for this timeseries'), rec_csv.csv1, CURRENT_USER);
				END IF;
			END IF;
		END IF;
	END LOOP;

	-- manage log (fid: v_fid)
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 1, concat('Process finished with ', v_count, ' rows inserted'));

	-- get log (fid: v_fid)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user= CURRENT_USER AND fid = v_fid ORDER BY criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- Control nulls
	v_version := COALESCE(v_version, '{}');
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":0, "text":"Process executed"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
