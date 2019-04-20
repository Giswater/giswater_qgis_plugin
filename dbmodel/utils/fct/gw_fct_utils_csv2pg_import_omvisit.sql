/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2512

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_omvisit(boolean, boolean, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_omvisit(p_data json)
RETURNS json AS
$BODY$

/*
EXAMPLE
-------
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_omvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},
"data":{"visitDescript":"Test"}}$$)


INSTRUCTIONS
------------
Two parameters:
1: v_isvisitexists: 	- If true, no visit is added because events are related to existing visits
2: v_visit_descript:	- om_visit.descript value

Three steps:
1) PREVIOUS
	1) Check all the news visit_id does not exists on om_visit table
	2) Check the visicat_id is defined on om_visit_cat table
	3) Define the parameters that will be imported on the variable utils_csv2pg_om_visit_parameters on config_param_system  {"p1", "p2", "p3"......"p11"} according with rows csv10, csv11, csv12...... csv20
	4) Parameters defined on 3) must exists on om_visit_parameter table
	5) Dates must have the format of date

2) INSERT DATA ON temp_csv2pg (using any way any technology)
	data on table must be:
	(csv2pgcat_id, user_name, visit_id, visitcat_id, startdate, enddate, feature_type, feature_id, date, ext_code, user_field, parameter1, parameter2, parameter3, parameter4, parameter5, parameter6....	
				  csv1      csv2         csv3       csv4     csv5          csv6        csv7  csv8      csv9        csv10...

	DELETE FROM SCHEMA_NAME.temp_csv2pg where user_name=current_user AND csv2pgcat_id=2;
	INSERT INTO SCHEMA_NAME.temp_csv2pg (csv2pgcat_id, user_name, csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10, csv11, csv12) 
	SELECT 2, current_user, visit_id, visitcat_id, startdate, enddate, 'arc', "PrimeroDearc_id", "DATA", ext_code, user_name, "ESTAT_GENERAL", "ESTAT_SEDIMENTS", "DEFECTES_PUNTUALS" from public.traspas_events

select distinct "DEFECTES_PUNTUALS" from public.traspas_events
select distinct "ESTAT_SEDIMENTS" from public.traspas_events
select distinct "ESTAT_GENERAL" from public.traspas_events

	
3) MOVE DATA FROM temp_csv2pg TO om_visit tables
	SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_omvisit(2,'Events importats dels GIS vell')
*/

DECLARE
	v_parameters record;
	v_visit record;
	v_parameter_id text;
	v_csv integer = 0;
	v_csv_id text;
	v_parameter_value text;
	v_isvisitexists boolean;
	v_visit_descript text;
	v_result_id text= 'import visit file';
	v_result json;
	v_result_info json;
	v_project_type text;
	v_version text;
	v_featuretable text;
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1;

	-- get config parameteres
	v_isvisitexists = (SELECT value::json->>'isVisitExists' FROM config_param_system WHERE parameter = 'utils_csv2pg_om_visit_parameters');

	-- get input parameter
	v_visit_descript =  (p_data::json->>'data')::json->>'visitDescript';

	-- manage log (fprocesscat 42)
	DELETE FROM audit_check_data WHERE fprocesscat_id=42 AND user_name=current_user;
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('IMPORT VISIT FILE'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('----------------------'));
   
 	-- starting process
	-- Insert into audit table
	INSERT INTO audit_log_csv2pg 
	(csv2pgcat_id, user_name,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20)
	SELECT csv2pgcat_id, user_name,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20
	FROM temp_csv2pg WHERE csv2pgcat_id=9 AND user_name=current_user;

	FOR v_visit IN SELECT * FROM temp_csv2pg WHERE csv2pgcat_id=9 AND user_name=current_user
	LOOP
	
		IF v_isvisitexists IS FALSE OR v_isvisitexists IS NULL THEN
		
			-- Insert into visit table
			INSERT INTO om_visit (id, visitcat_id, startdate, enddate, ext_code, user_name, descript) 
			VALUES(v_visit.csv1::integer, v_visit.csv2::integer, v_visit.csv7::date, v_visit.csv7::date, v_visit.csv8, v_visit.csv9, v_visit_descript);
	
			-- Insert into feature table
			v_featuretable = concat ('om_visit_x_', v_visit.csv5);
			EXECUTE 'UPDATE '||v_featuretable||' SET is_last=FALSE where '||v_visit.csv5||'_id::text='||v_visit.csv6||'::text';
			EXECUTE 'INSERT '||v_featuretable||' (visit_id, '||v_visit.csv5||'_id) VALUES ( '||v_visit.csv1||','||v_visit.csv6||')';
		
		END IF;
	
		v_csv=10;
			
		FOR v_parameters IN SELECT json_array_elements((value::json->>'parameters')::json) FROM config_param_system WHERE parameter = 'utils_csv2pg_om_visit_parameters'
		LOOP			
			-- parameters are defined from row csv10 to row csv20
			IF v_csv = 10 THEN
				v_parameter_value = v_visit.csv10;
			ELSIF v_csv = 11 THEN
				v_parameter_value = v_visit.csv11;
			ELSIF v_csv = 12 THEN	
				v_parameter_value = v_visit.csv12;
			ELSIF v_csv = 13 THEN
				v_parameter_value = v_visit.csv13;
			ELSIF v_csv = 14 THEN
				v_parameter_value = v_visit.csv14;
			ELSIF v_csv = 15 THEN
				v_parameter_value = v_visit.csv15;
			ELSIF v_csv = 16 THEN
				v_parameter_value = v_visit.csv16;
			ELSIF v_csv = 17 THEN
				v_parameter_value = v_visit.csv17;
			ELSIF v_csv = 18 THEN
				v_parameter_value = v_visit.csv18;
			ELSIF v_csv = 19 THEN
				v_parameter_value = v_visit.csv19;
			ELSIF v_csv = 20 THEN
				v_parameter_value = v_visit.csv20;
			END IF;
			v_csv=v_csv+1;
				raise notice 'v_parameter_id: %, v_parameter_value: %', v_parameter_id, v_parameter_value;
	
			-- set previous to is_last=false
			EXECUTE 'UPDATE om_visit_event SET is_last=FALSE WHERE parameter_id= '||quote_literal(v_parameter_id)||' AND visit_id IN (SELECT visit_id FROM om_visit_x_'||v_visit.csv5||'
				WHERE '||v_visit.csv5||'_id = '||v_visit.csv6||'::text)';

			-- insert event
			INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (v_visit.csv1::bigint, v_parameter_id, v_parameter_value , v_visit.csv7::timestamp);			
		END LOOP;				
	END LOOP;

	-- Delete values on temporal table
	DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=9;

	-- manage log (fprocesscat 42)
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Reading values from temp_csv2pg table -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Inserting values on om_visit table -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Inserting values on ',v_featuretable,' table -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Inserting values on om_visit_event table -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Deleting values from temp_csv2pg -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Process finished'));
	
	-- get log (fprocesscat 42)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=42) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
			
	-- Control nulls
	v_version := COALESCE(v_version, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 
 
	-- Return
	RETURN ('{"status":"Accepted", "message":{"priority":0, "text":"Process executed"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;
	    
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","message":{"priority":2, "text":' || to_json(SQLERRM) || '}, "version":"'|| v_version ||'","SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

