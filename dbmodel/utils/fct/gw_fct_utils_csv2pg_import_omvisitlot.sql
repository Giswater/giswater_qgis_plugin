-- Function: gw_fct_utils_csv2pg_import_elements(json)

-- DROP FUNCTION gw_fct_utils_csv2pg_import_elements(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_omvisitlot(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_omvisitlot($${
"data":{"featureType":"arc", "tableName":"ve_visit_arc_neteja"}}$$)
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
	SELECT wsoftware, giswater, epsg  INTO v_project_type, v_version, v_epsg FROM version order by 1 desc limit 1;

	-- get input parameter
	v_featuretype = (SELECT csv2 FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=21 LIMIT 1);
	v_featuretable = (SELECT tablename FROM config_api_visit WHERE visitclass_id=(SELECT csv3 FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=21 LIMIT 1)::integer);
	v_parameter1 = (SELECT parameter_id FROM om_visit_class_x_parameter cxp JOIN config_api_visit cav ON cav.visitclass_id=cxp.class_id WHERE cav.tablename = v_featuretable LIMIT 1);
	v_parameter2 = (SELECT parameter_id FROM om_visit_class_x_parameter cxp JOIN config_api_visit cav ON cav.visitclass_id=cxp.class_id WHERE cav.tablename = v_featuretable LIMIT 1 OFFSET 1);

	-- manage log (fprocesscat 54)
	DELETE FROM audit_check_data WHERE fprocesscat_id=54 AND user_name=current_user;
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (54, v_result_id, concat('IMPORT LOT VISITS'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (54, v_result_id, concat('------------------------------'));
   
 	-- starting process
	FOR v_visit IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=21
	LOOP 
		v_visit.csv8 := COALESCE(v_visit.csv8, ''); -- control NULL from csv8 (optional parameter)		 
		EXECUTE 'INSERT INTO ' ||v_featuretable||' (visit_id, ' ||v_featuretype|| '_id, class_id, lot_id, status, startdate, '||v_parameter1||', '||v_parameter2||') VALUES 
		((SELECT nextval(''om_visit_id_seq'')), '||quote_literal(v_visit.csv1)||','||quote_literal(v_visit.csv3)||', '||quote_literal(v_visit.csv4)||',
		'||quote_literal(v_visit.csv5)||','||quote_literal(v_visit.csv6)||','||quote_literal(v_visit.csv7)||', '||quote_literal(v_visit.csv8)||')';
			
	END LOOP;

	-- Delete values on temporal table
	DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=21;

	-- manage log (fprocesscat 54)
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (54, v_result_id, concat('Reading values from temp_csv2pg table -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (54, v_result_id, concat('Inserting values on ',v_featuretable,' table -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (54, v_result_id, concat('Deleting values from temp_csv2pg -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (54, v_result_id, concat('Process finished'));
	
	-- get log (fprocesscat 54)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=54) row; 
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
	--EXCEPTION WHEN OTHERS THEN 
	--RETURN ('{"status":"Failed","message":{"priority":2, "text":' || to_json(SQLERRM) || '}, "version":"'|| v_version ||'","SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

