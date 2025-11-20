/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:3044

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_import_inp_curve(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_inp_curve(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_inp_curve($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{}}$$)

--fid:384

*/

DECLARE

rec_csv record;
v_result_id text= 'import inp curves';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_fid integer = 384;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- manage log (fid: v_fid)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3044", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3922", "function":"3044", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3934", "function":"3044", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "criticity":"4", "is_process":true}}$$)';

	-- reset sequence
	PERFORM setval('inp_curve_value_id_seq', (SELECT max(id) FROM inp_curve_value), true);

	-- starting process
	FOR rec_csv IN SELECT * FROM temp_csv WHERE cur_user=current_user AND fid = v_fid
	LOOP

		IF rec_csv.csv1 IS NOT NULL THEN -- to control those null rows because user has a bad structured csv file (common last lines)

			IF rec_csv.csv1 NOT IN (SELECT id FROM inp_curve) THEN

				-- insert log
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3936", "function":"3044", "parameters":{"rec_csv.csv1":"'||rec_csv.csv1||'"}, "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "table_id":"'||rec_csv.csv1||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';

				-- insert inp_curve
				INSERT INTO inp_curve VALUES (rec_csv.csv1, rec_csv.csv4, rec_csv.csv6, rec_csv.csv5::integer, concat('Insert by ',current_user,' on ', substring(now()::text,0,20)));

				-- insert into inp_curve_value
				INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES
				(rec_csv.csv1, rec_csv.csv2::float, rec_csv.csv3::float);


			ELSIF rec_csv.csv1 IN (SELECT id FROM inp_curve) AND rec_csv.csv1 IN (SELECT table_id FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user)   THEN

				-- insert into inp_curve_value
				INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES	(rec_csv.csv1, rec_csv.csv2::float, rec_csv.csv3::float);

			ELSIF rec_csv.csv1 IN (SELECT id FROM inp_curve) THEN

				IF rec_csv.csv1 IN (SELECT column_id FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user) THEN

				ELSE
					-- insert log
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3938", "function":"3044", "parameters":{"rec_csv.csv1":"'||rec_csv.csv1||'"}, "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "criticity":"2", "column_id":"'||rec_csv.csv1||'", "cur_user":"'||current_user||'", "prefix_id":"1002", "is_process":true}}$$)';
				END IF;
			END IF;
		END IF;
	END LOOP;

	-- manage log (fid: v_fid)
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3926", "function":"3044", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "criticity":"1", "is_process":true}}$$)';

	-- get log (fid: v_fid)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid ORDER BY criticity desc, id asc) row;
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