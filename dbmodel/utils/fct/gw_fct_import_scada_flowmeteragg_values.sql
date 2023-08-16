/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:3260

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_scada_flowmeteragg_values(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_scada_flowmeteragg_values($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{}}$$)

--fid:506

*/


DECLARE

v_addfields record;
v_result_id text= 'import flowmeter agg values';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_fid integer = 506;
i integer = 0;
v_count integer;
v_loop_numdays integer = 0;
v_volume_numdays integer = 0;
v_currentdate date;
v_nextdate date;
v_nextvol float = 0;
v_currentvol float = 0;
v_flag boolean = false;
v_time4date text = '23:59:59'; -- two values '00:00:00' or '23:59:59'. It depens where you consider measure;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;
   
	-- manage log (fid: v_fid)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	DELETE FROM temp_data;
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('IMPORT FLOWMETER AGGREGATED VALUES FILE'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('------------------------------------------'));

	-- refactoring data on temp csv
	FOR v_addfields IN SELECT * FROM temp_csv WHERE cur_user=current_user AND fid = v_fid
	LOOP
		-- setting dates
		v_nextdate := (SELECT csv3 FROM temp_csv WHERE cur_user=current_user AND fid = v_fid AND id = v_addfields.id+1)::date;
		v_currentdate = v_addfields.csv3::date;
		v_volume_numdays = v_nextdate - v_currentdate;

		-- setting numdays
		IF v_time4date = '00:00:00' THEN
			v_loop_numdays = v_nextdate - v_currentdate -1;
			i = 0;
		ELSIF v_time4date = '23:59:59' THEN
			v_loop_numdays = v_nextdate - v_currentdate;
			 i = 1;
		END IF;

		-- setting volumes
		v_nextvol := (SELECT csv4 FROM temp_csv WHERE cur_user=current_user AND fid = v_fid AND id = v_addfields.id+1)::double precision;
		v_currentvol := v_addfields.csv4::double precision;

		--loop inserting on temp table
		IF v_loop_numdays IS NOT NULL THEN  -- excluding by this way last row wich from temp_csv
			FOR n IN i..v_loop_numdays
			LOOP
				INSERT INTO temp_data (feature_id, date_value, float_value, int_value, fid, text_value, log_message) 
				VALUES (v_addfields.csv2, v_currentdate + n, ((v_nextvol -v_currentvol)/(v_volume_numdays))::numeric(12,4), v_addfields.csv5::integer, v_addfields.csv6::integer, v_addfields.csv7::text, v_addfields.csv1);
			END LOOP;	
		END IF;
	END LOOP;

	-- mapping values on table
	INSERT INTO ext_rtc_scada_x_data SELECT feature_id, date_value::date, float_value, int_value, fid, text_value, log_message FROM temp_data;
	
	-- couting
	SELECT count(*) INTO v_count FROM (SELECT DISTINCT csv1 FROM temp_csv WHERE cur_user=current_user AND fid = v_fid)a;
	SELECT count(*) INTO i FROM (SELECT feature_id FROM temp_data)a;


	-- manage log (fid: v_fid)
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Reading values from temp_csv table -> Done!'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Inserting values on ext_rtc_scada_x_data table -> Done!'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Deleting values from temp_csv -> Done!'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Refactorize value to one value per day -> Done!'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Process finished with ',i, ' rows inserted.'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Data from ',v_count, ' scada tags have been imported.'));

	-- get log (fid: v_fid)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid) row;
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
