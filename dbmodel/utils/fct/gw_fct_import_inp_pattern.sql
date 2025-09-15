/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:3048

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_import_inp_pattern(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_inp_pattern(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_inp_pattern($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{}}$$)

--fid:386

*/

DECLARE

rec_csv record;
v_result_id text= 'import inp patterns';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_fid integer = 386;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- manage log (fid: v_fid)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3048", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3922", "function":"3048", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3940", "function":"3048", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "criticity":"4", "is_process":true}}$$)';


	-- reset sequence
	IF v_project_type = 'WS' THEN
		PERFORM setval('inp_pattern_value_id_seq', (SELECT max(id) FROM inp_pattern_value), true);
	END IF;

  	-- starting process
 	FOR rec_csv IN SELECT * FROM temp_csv WHERE cur_user=current_user AND fid = v_fid
	LOOP
		IF rec_csv.csv1 IS NOT NULL THEN -- to control those null rows because user has a bad structured csv file (common last lines)


			IF rec_csv.csv1 NOT IN (SELECT pattern_id FROM inp_pattern) THEN

				-- insert log
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3942", "function":"3048", "parameters":{"rec_csv.csv1":"'||rec_csv.csv1||'"}, "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "table_id":"'||rec_csv.csv1||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';


				-- insert inp_pattern & inp_pattern_value
				IF v_project_type = 'UD' THEN

					INSERT INTO inp_pattern (pattern_id, pattern_type, observ, expl_id, log) VALUES (rec_csv.csv1, rec_csv.csv2, rec_csv.csv3, rec_csv.csv4::integer,
					concat('Insert by ',current_user,' on ', substring(now()::text,0,20)));

					INSERT INTO inp_pattern_value (pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12,
					factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24) VALUES
					(rec_csv.csv1, rec_csv.csv5::float, rec_csv.csv6::float, rec_csv.csv7::float, rec_csv.csv8::float, rec_csv.csv9::float
					, rec_csv.csv10::float, rec_csv.csv11::float, rec_csv.csv12::float, rec_csv.csv13::float, rec_csv.csv14::float, rec_csv.csv15::float, rec_csv.csv16::float, rec_csv.csv17::float
					, rec_csv.csv18::float, rec_csv.csv19::float, rec_csv.csv20::float, rec_csv.csv21::float, rec_csv.csv22::float, rec_csv.csv23::float, rec_csv.csv24::float, rec_csv.csv25::float
					, rec_csv.csv26::float, rec_csv.csv27::float, rec_csv.csv28::float);
				ELSE
					INSERT INTO inp_pattern (pattern_id, observ, tscode, tsparameters, expl_id, log) VALUES (rec_csv.csv1, rec_csv.csv2, null, null, rec_csv.csv3::integer, concat('Insert by ',current_user,' on ', substring(now()::text,0,20)));
				END IF;

			ELSIF rec_csv.csv1 IN (SELECT pattern_id FROM inp_pattern) AND rec_csv.csv1 IN (SELECT table_id FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user)   THEN

				-- insert inp_pattern_value
				IF v_project_type = 'WS' THEN

					INSERT INTO inp_pattern_value (pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12,
					factor_13, factor_14, factor_15, factor_16, factor_17, factor_18) VALUES
					(rec_csv.csv1, rec_csv.csv2::float, rec_csv.csv3::float, rec_csv.csv4::float, rec_csv.csv5::float, rec_csv.csv6::float, rec_csv.csv7::float, rec_csv.csv8::float, rec_csv.csv9::float
					, rec_csv.csv10::float, rec_csv.csv11::float, rec_csv.csv12::float, rec_csv.csv13::float, rec_csv.csv14::float, rec_csv.csv15::float, rec_csv.csv16::float, rec_csv.csv17::float
					, rec_csv.csv18::float, rec_csv.csv19::float);
				END IF;

			ELSE
				IF rec_csv.csv1 IN (SELECT column_id FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user) THEN

				ELSE
					-- insert log
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3944", "function":"3048", "parameters":{"rec_csv.csv1":"'||rec_csv.csv1||'"}, "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "column_id":"'||rec_csv.csv1||'", "cur_user":"'||current_user||'", "criticity":"2", "prefix_id":"1002", "is_process":true}}$$)';

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

END;
$BODY$
  LANGUAGE plpgsql VOLATILE