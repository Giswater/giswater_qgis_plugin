/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: 2512

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_omvisit(boolean, boolean, text);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_omvisit(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_omvisit(p_data json)
RETURNS json AS
$BODY$

/*
EXAMPLE
-------
SELECT SCHEMA_NAME.gw_fct_import_omvisit($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},
"data":{"csv2pgCat":13, "importParam":"Test"}}$$)

fid = 237

INSTRUCTIONS
------------
CSV file may have four type of column data:

-- visit_id, visit_cat, visit_type, visit_class, visit_team, visit_date, ext_code ,feature_type, feature_id, inventory1, inventory2......., inventoryn, parameter1, parameter2.... parametern
--   csv1      csv2         csv3       csv4        csv5        csv6          csv7     csv8	    csv9	     csv10        csv11              csvn	  csvn+1      csvn+2          csvn+m
	
	Visit data: (csv1....csv5) - all mandatory
		visit_id: Check all the news visit_id does not exists on om_visit table
		visit_cat: Check the visicat_id is defined on om_visit_cat table
		visit_type: Unexpected / plannified
		visit_class: class of visit
		visit_team: Check the visicat_id is defined on team's table
		visit_date: Dates must have the format of date
		ext_code: Not mandatory code to put things like workorder or any other info
	
	Feature values:  (csv8,csv9)  - all mandatory
		feature_type (ARC / NODE / CONNEC /GULLY)
		feature_id
		
	Inventory values: (csv10....csvn) - not mandatory
		This is a not mandatory values defined on config_param_system: The goal of this is use the visit work to improve the inventory data. 
		Parameters defined must exists on table of inventory
		System must be cofigured. 
			To configure inventory columns to be checked use configure utils_csv2pg_om_visit_parameters_* 
				key "feature"."columns":["node1", "node2", "y1", "y2", "shape", "geom1", "geom2", "material")
			To configure tolerance values use utils_csv2pg_om_visit_parameters_* ,  
				key "feature"."tolerance": ["y1":">0.05", "y2":">0.05", "shape":"!=shape", "geom1":">0.05", "geom2":">0.05, "material":"!=shape"]
		
	Visit parameters: (csvn+1....csvn+m) - at least one mandatory
		Parameters defined must exists on config_visit_parameter table: At least one parameter is mandatory
		System must be configured 
			To configure the parameters use utils_csv2pg_om_visit_parameters_*
				key "visit"."firstCsvParameter" to define n+1 position
				key "visit"."visitParameters":["residus_percen", "estat_general", "estat_parets", "estat_solera", "estat_tester", "estat_volta", "observacions"])
		

Configuration tips:
	Variables on config_param_system
		visit for arc:  utils_csv2pg_om_visit_parameters_13
		visit for node: utils_csv2pg_om_visit_parameters_14
		visit for connec: utils_csv2pg_om_visit_parameters_15
		visit for gully: utils_csv2pg_om_visit_parameters_16
	
	Details of the structure configuration for variables
		{"id":"inspeccioPreviaTram", 
			"feature": {"tableName":"arc", "columns":["node1", "node2", "y1", "y2", "shape", "geom1", "geom2", "material"
					   "tolerance":["y1":">0.05", "y2":"0.05", "shape":"!=shape", "geom1":">0.05", "geom2":">0.05, "material":"!=shape"]}, 
			"visit":{"isVisitExists":false, "tableName":"om_visit_x_arc", "featureColumn":"arc_id", "firstCsvParameter":16, 
						"visitParameters": ["residus_percen", "estat_general", "estat_parets", "estat_solera", "estat_tester", "estat_volta", "observacions"]}}		
*/


DECLARE
	v_parameters text;
	v_visit record;
	v_parameter_id text;
	v_csv integer = 0;
	v_csv_id text;
	v_value text;
	v_isvisitexists boolean;
	v_visit_descript text;
	v_result_id text= 'import visit file';
	v_result json;
	v_result_info json;
	v_project_type text;
	v_version text;
	v_featuretable text;
	v_fid integer;
	v_column text;
	v_visittablename text;
	v_visitcolumnname text;
	v_featuretablename text;
	
BEGIN


	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get input parameter
	v_visit_descript =  (p_data::json->>'data')::json->>'importParam';
	v_fid =  (p_data::json->>'data')::json->>'csv2pgCat';

	-- get config parameteres
	v_isvisitexists = (SELECT (value::json->>'visit')::json->>'isVisitExists' FROM config_param_system WHERE parameter = concat('utils_csv2pg_om_visit_parameters_', v_fid));
	v_visittablename = (SELECT (value::json->>'visit')::json->>'tableName' FROM config_param_system WHERE parameter = concat('utils_csv2pg_om_visit_parameters_', v_fid));
	v_visitcolumnname = (SELECT (value::json->>'visit')::json->>'featureColumn' FROM config_param_system WHERE parameter = concat('utils_csv2pg_om_visit_parameters_', v_fid));
	v_featuretablename = (SELECT (value::json->>'feature')::json->>'tableName' FROM config_param_system WHERE parameter = concat('utils_csv2pg_om_visit_parameters_', v_fid));

	-- hardcoded to test
	----------------------------------------
	DELETE FROM om_visit;
	----------------------------------------
	
	RAISE NOTICE 'v_isvisitexists % v_visittablename % v_visitcolumnname  % v_featuretablename %', v_isvisitexists, v_visittablename, v_visitcolumnname, v_featuretablename;

	-- manage log (fid 237)
	DELETE FROM audit_check_data WHERE fid=237 AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('LOG IMPORTACIO DE FITXER DE VISITES DE LA CONTRATA DE SANEJAMENT'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('--------------------------------------------------------------------------------------'));
   
 	-- starting process
	FOR v_visit IN SELECT * FROM temp_csv WHERE fid = v_fid AND cur_user=current_user
	LOOP
		RAISE NOTICE 'v_visit %', v_visit;
	
		IF v_isvisitexists IS FALSE OR v_isvisitexists IS NULL THEN
		
			-- Insert into visit table
			INSERT INTO om_visit (id, visitcat_id, visit_type, class_id, startdate, enddate, ext_code, cur_user, descript) 
			VALUES(v_visit.csv1::integer, v_visit.csv2::integer, v_visit.csv3::integer, v_visit.csv4::integer, v_visit.csv6::date, v_visit.csv6::date, v_visit.csv7, v_visit.csv5, v_visit_descript);
	
			-- Insert into feature table
			EXECUTE 'UPDATE '||v_visittablename||' SET is_last=FALSE where '||v_visitcolumnname||'::text='||v_visit.csv7||'::text';
			EXECUTE 'INSERT INTO ' ||v_visittablename||' (visit_id, '||v_visitcolumnname||') VALUES ( '||v_visit.csv1||','||v_visit.csv7||')';
			
		END IF;

		-- feature columns
		v_csv=10;
			
		FOR v_column IN SELECT json_array_elements(((value::json->>'feature')::json->>'columns')::json) 
		FROM config_param_system WHERE parameter = concat('utils_csv2pg_om_visit_parameters_',v_fid)
		LOOP

			IF v_csv = 10 THEN	
				v_value = v_visit.csv10;
			ELSIF v_csv = 11 THEN
				v_value = v_visit.csv11;
			ELSIF v_csv = 12 THEN
				v_value = v_visit.csv12;
			ELSIF v_csv = 13 THEN
				v_value = v_visit.csv13;
			ELSIF v_csv = 14 THEN
				v_value = v_visit.csv14;
			ELSIF v_csv = 15 THEN
				v_value = v_visit.csv15;
			ELSIF v_csv = 16 THEN
				v_value = v_visit.csv16;
			ELSIF v_csv = 17 THEN
				v_value = v_visit.csv17;
			ELSIF v_csv = 18 THEN
				v_value = v_visit.csv18;
			END IF;
			
			v_csv=v_csv+1;
			raise notice 'v_column: %, v_value: %', v_column, v_value;

			-- need to compare values and create json log
			--LOOP COMPARING VALUES

		END LOOP;
	
		v_csv = (SELECT (value::json->>'visit')::json->>'firstCsvParameter' FROM config_param_system 
		WHERE parameter = concat('utils_csv2pg_om_visit_parameters_', v_fid))::integer;

		raise notice 'v_csv %', v_csv;
			
		FOR v_parameters IN SELECT json_array_elements(((value::json->>'visit')::json->>'visitParameters')::json) 
		FROM config_param_system WHERE parameter = concat('utils_csv2pg_om_visit_parameters_',v_fid)
		LOOP			
			raise notice 'v_parameters %', v_parameters;
			-- parameters are defined from row csv10 to row csv20

			IF v_csv = 10 THEN	
				v_value = v_visit.csv10;
			ELSIF v_csv = 11 THEN
				v_value = v_visit.csv11;
			ELSIF v_csv = 12 THEN
				v_value = v_visit.csv12;
			ELSIF v_csv = 13 THEN
				v_value = v_visit.csv13;
			ELSIF v_csv = 14 THEN
				v_value = v_visit.csv14;
			ELSIF v_csv = 15 THEN
				v_value = v_visit.csv15;
			ELSIF v_csv = 16 THEN
				v_value = v_visit.csv16;
			ELSIF v_csv = 17 THEN
				v_value = v_visit.csv17;
			ELSIF v_csv = 18 THEN
				v_value = v_visit.csv18;
			ELSIF v_csv = 19 THEN
				v_value = v_visit.csv19;
			ELSIF v_csv = 20 THEN
				v_value = v_visit.csv20;
			ELSIF v_csv = 21 THEN
				v_value = v_visit.csv21;
			ELSIF v_csv = 22 THEN
				v_value = v_visit.csv22;
			ELSIF v_csv = 23 THEN
				v_value = v_visit.csv23;
			ELSIF v_csv = 24 THEN
				v_value = v_visit.csv24;
			END IF;
			
			v_csv=v_csv+1;

			raise notice 'v_csv % v_parameter_id: %, v_value: %',v_csv, v_parameters, v_value;

			v_parameters=replace(v_parameters,'"','');
	
			-- set previous to is_last=false
			--EXECUTE 'UPDATE om_visit_event SET is_last=FALSE WHERE parameter_id= '||quote_literal(v_parameter_id)||' AND visit_id IN (SELECT visit_id FROM '||v_visittablename||' WHERE '||v_visitcolumnname||' = '||v_visit.csv4||'::text)';

			-- insert event
			INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp, is_last) VALUES (v_visit.csv1::bigint, v_parameters, v_value , v_visit.csv4::timestamp, true);			
		END LOOP;				
	END LOOP;

	-- Delete values on temporal table
	DELETE FROM temp_csv WHERE cur_user=current_user AND fid=v_fid;

	-- manage log (fid 237)
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('Reading values from temp_csv2pg table -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('Inserting values on om_visit table -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('Inserting values on ',v_featuretable,' table -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('Inserting values on om_visit_event table -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('Deleting values from temp_csv2pg -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (237, v_result_id, concat('Process finished'));

	-- get log (fid 237)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=237) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"values":',v_result, '}');
			
	-- Control nulls
	v_version := COALESCE(v_version, ''); 
	v_result_info := COALESCE(v_result_info, '{}'); 

	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":0, "text":"Process executed"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;
 
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN json_build_object('status', 'Failed', 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'version', v_version, 'SQLSTATE', SQLSTATE)::json;
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
