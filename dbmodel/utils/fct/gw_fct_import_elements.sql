/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2514

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_elements(integer, text);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_elements(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_elements(p_data json)
RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_import_elements($${
"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "importParam":"node", "fid":"235"}}$$)::text

--fid: 235

*/


DECLARE

v_element record;
v_idlast int8;
v_result_id text= 'import elements';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_epsg integer;
v_featuretype text;
v_featuretable text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater, epsg  INTO v_project_type, v_version, v_epsg FROM sys_version order by 1 desc limit 1;

	-- get input parameter
	v_featuretype =  (p_data::json->>'data')::json->>'importParam';
	v_featuretable = concat ('element_x_',v_featuretype);

	-- manage log (fid: 235)
	DELETE FROM audit_check_data WHERE  fid = 235 AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (235, v_result_id, concat('IMPORT ELEMENTS FILE'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (235, v_result_id, concat('------------------------------'));
   
 	-- starting process
	FOR v_element IN SELECT * FROM temp_csv WHERE cur_user=current_user AND fid = 235
	LOOP 
		IF v_featuretype='node' THEN
			INSERT INTO element (element_id, code, elementcat_id,observ, comment, num_elements, state, state_type, workcat_id, verified, inventory) VALUES
			((SELECT nextval('urn_id_seq')),v_element.csv2, v_element.csv3, v_element.csv4, v_element.csv5, v_element.csv6::integer, 1, v_element.csv7::integer, 
			v_element.csv8, v_element.csv9, TRUE) RETURNING element_id INTO v_idlast;
			INSERT INTO element_x_node (element_id, node_id) VALUES (v_idlast, v_element.csv1);
			
		ELSIF v_featuretype='arc' THEN 
			INSERT INTO element (element_id, code, elementcat_id,observ, comment, num_elements, state, state_type, workcat_id, verified, inventory) VALUES
			((SELECT nextval('urn_id_seq')),v_element.csv2, v_element.csv3, v_element.csv4, v_element.csv5, v_element.csv6::integer, 1, v_element.csv7::integer, 
			v_element.csv8, v_element.csv9, TRUE) RETURNING element_id INTO v_idlast;
			INSERT INTO element_x_arc (element_id, arc_id) VALUES (v_idlast, v_element.csv1);
			
		ELSIF v_featuretype='connec' THEN	
			INSERT INTO element (element_id, code, elementcat_id,observ, comment, num_elements, state, state_type, workcat_id, verified, inventory) VALUES
			((SELECT nextval('urn_id_seq')),v_element.csv2, v_element.csv3, v_element.csv4, v_element.csv5, v_element.csv6::integer, 1, v_element.csv7::integer, 
			v_element.csv8, v_element.csv9, TRUE) RETURNING element_id INTO v_idlast;
			INSERT INTO element_x_connec (element_id, connec_id) VALUES (v_idlast, v_element.csv1);
			
		ELSIF v_featuretype='gully' THEN
			INSERT INTO element (element_id, code, elementcat_id,observ, comment, num_elements, state, state_type, workcat_id, verified, inventory) VALUES
			((SELECT nextval('urn_id_seq')),v_element.csv2, v_element.csv3, v_element.csv4, v_element.csv5, v_element.csv6::integer, 1, v_element.csv7::integer, 
			v_element.csv8, v_element.csv9, TRUE) RETURNING element_id INTO v_idlast;
			INSERT INTO element_x_gully (element_id, gully_id) VALUES (v_idlast, v_element.csv1);
		END IF;	
	END LOOP;

	-- manage log (fid: 235)
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (235, v_result_id, concat('Reading values from temp_csv table -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (235, v_result_id, concat('Inserting values on element table -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (235, v_result_id, concat('Inserting values on ',v_featuretable,' table -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (235, v_result_id, concat('Deleting values from temp_csv -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (235, v_result_id, concat('Process finished'));
	
	-- get log (fid: 235)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid = 235) row;
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
	--EXCEPTION WHEN OTHERS THEN 
	--RETURN ('{"status":"Failed","message":{"level":2, "text":' || to_json(SQLERRM) || '}, "version":"'|| v_version ||'","SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
