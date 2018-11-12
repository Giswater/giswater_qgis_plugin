/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2512


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_omvisit(p_isvisitexists boolean, p_isparametervalue boolean, p_visit_descript text)
  RETURNS integer AS
$BODY$


/*INSTRUCTIONS

Three parameters:
1: p_isvisitexists: 	- If true, no visit is added because events are related to existing visits
2: p_isparametervalue:	- On the column of om_visit_event.parameter_id in spite of insert parameter_id, parameter value is inserted. The field of parameter value keeps with nulls
3: p_visit_descript:	- om_visit.descript value

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
	v_parameters text[];
	v_visit record;
	v_parameter_id text;
	v_csv integer = 0;
	v_csv_id text;
	v_parameter_value text;
BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Get parameters
    SELECT value INTO v_parameters FROM config_param_system WHERE parameter = 'utils_csv2pg_om_visit_parameters';

	-- Check data
	-- visitcat_id
	-- visit_id

	-- Insert into audit table
	INSERT INTO audit_log_csv2pg 
	(csv2pgcat_id, user_name,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20)
	SELECT csv2pgcat_id, user_name,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20
	FROM temp_csv2pg;

	FOR v_visit IN SELECT * FROM temp_csv2pg WHERE csv2pgcat_id=2 AND user_name=current_user
	LOOP
	
		IF p_isvisitexists IS FALSE THEN
		
			-- Insert into visit table
			INSERT INTO om_visit (id, visitcat_id, startdate, enddate, ext_code, user_name, descript) 
			VALUES(v_visit.csv1::integer, v_visit.csv2::integer, v_visit.csv7::date, v_visit.csv7::date, v_visit.csv8, v_visit.csv9, p_visit_descript);
	
			-- Insert into feature table
			EXECUTE 'UPDATE om_visit_x_'||v_visit.csv5||' SET is_last=FALSE where '||v_visit.csv5||'_id::text='||v_visit.csv6||'::text';
			EXECUTE 'INSERT INTO om_visit_x_'||v_visit.csv5||' (visit_id, '||v_visit.csv5||'_id) VALUES ( '||v_visit.csv1||','||v_visit.csv6||')';
		
		END IF;
	
		v_csv=10;
			
		FOREACH v_parameter_id IN ARRAY v_parameters
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
	
			IF p_isparametervalue IS FALSE THEN
				-- set previous to is_last=false
				EXECUTE 'UPDATE om_visit_event SET is_last=FALSE WHERE parameter_id= '||quote_literal(v_parameter_id)||' AND visit_id IN (SELECT visit_id FROM om_visit_x_'||v_visit.csv5||'
					WHERE '||v_visit.csv5||'_id = '||v_visit.csv6||'::text)';
				-- insert event
				INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (v_visit.csv1::bigint, v_parameter_id, v_parameter_value , v_visit.csv7::timestamp);
			
			ELSIF p_isparametervalue IS TRUE AND v_parameter_value IS NOT NULL THEN 
				-- set previous to is_last=false
				EXECUTE 'UPDATE om_visit_event SET is_last=FALSE WHERE parameter_id= '||quote_literal(v_parameter_value)||' AND visit_id IN (SELECT visit_id FROM om_visit_x_'||v_visit.csv5||'
					WHERE '||v_visit.csv5||'_id = '||v_visit.csv6||'::text)';
				-- insert event
				INSERT INTO om_visit_event (visit_id, parameter_id, tstamp) VALUES (v_visit.csv1::bigint, v_parameter_value, v_visit.csv7::timestamp);
			END IF;
		END LOOP;				
	END LOOP;
	
RETURN 0;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

