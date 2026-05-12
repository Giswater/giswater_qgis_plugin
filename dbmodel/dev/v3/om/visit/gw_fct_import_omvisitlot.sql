/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: 2884

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_omvisitlot(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_omvisitlot(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_import_omvisitlot($${
"data":{"featureType":"arc", "tableName":"ve_visit_arc_neteja"}}$$)

--fid: 154
*/


DECLARE

v_visit record;
v_result_id text= 'import lot visits';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_epsg integer;
v_featuretype text;
v_featuretable text;
v_parameter1 text;
v_parameter2 text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater, epsg  INTO v_project_type, v_version, v_epsg FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get input parameter
	v_featuretype = (SELECT csv2 FROM temp_csv WHERE cur_user=current_user AND fid = 154 LIMIT 1);
	v_featuretable = (SELECT tablename FROM config_api_visit WHERE visitclass_id=(SELECT csv3 FROM temp_csv WHERE cur_user=current_user AND fid = 154 LIMIT 1)::integer);
	v_parameter1 = (SELECT parameter_id FROM config_visit_class_x_parameter cxp JOIN config_visit_class cav ON cav.id=cxp.class_id 
		WHERE cav.tablename = v_featuretable AND cav.active IS TRUE AND cxp.active IS TRUE LIMIT 1);
	v_parameter2 = (SELECT parameter_id FROM config_visit_class_x_parameter cxp JOIN config_visit_class cav ON cav.id=cxp.class_id 
		WHERE cav.tablename = v_featuretable AND cav.active IS TRUE AND cxp.active IS TRUE LIMIT 1 OFFSET 1);

	-- manage log (fid: 154)
	DELETE FROM audit_check_data WHERE fid=154 AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (154, v_result_id, concat('IMPORT LOT VISITS'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (154, v_result_id, concat('------------------------------'));
   
 	-- starting process
	FOR v_visit IN SELECT * FROM temp_csv WHERE cur_user=current_user AND fid = 154
	LOOP 
		v_visit.csv8 := COALESCE(v_visit.csv8, ''); -- control NULL from csv8 (optional parameter)		 
		EXECUTE 'INSERT INTO ' ||v_featuretable||' (visit_id, ' ||v_featuretype|| '_id, class_id, lot_id, status, startdate, '||v_parameter1||', '||v_parameter2||') VALUES 
		((SELECT nextval(''om_visit_id_seq'')), '||quote_literal(v_visit.csv1)||','||quote_literal(v_visit.csv3)||', '||quote_literal(v_visit.csv4)||',
		'||quote_literal(v_visit.csv5)||','||quote_literal(v_visit.csv6)||','||quote_literal(v_visit.csv7)||', '||quote_literal(v_visit.csv8)||')';
			
	END LOOP;

	-- manage log (fid: 154)
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (154, v_result_id, concat('Reading values from temp_csv table -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (154, v_result_id, concat('Inserting values on ',v_featuretable,' table -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (154, v_result_id, concat('Deleting values from temp_csv -> Done'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (154, v_result_id, concat('Process finished'));
	
	-- get log (fid: 154)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=154) row;
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
	--EXCEPTION WHEN OTHERS THEN 
	--RETURN json_build_object('status', 'Failed', 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'version', v_version, 'SQLSTATE', SQLSTATE)::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
