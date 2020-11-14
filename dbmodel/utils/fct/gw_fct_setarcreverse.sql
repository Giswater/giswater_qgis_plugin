/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3008
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setarcreverse(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

SELECT gw_fct_setarcreverse($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
"form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":["331"]},
 "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"previousSelection", "parameters":{}}}$$);

SELECT gw_fct_setarcreverse($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, 
"feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, 
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}}}$$);

-- fid: 357
*/

DECLARE
 
arcrec Record;
v_count integer;
v_count_partial integer=0;
v_result text;
v_version text;
v_projecttype text;
v_saveondatabase boolean;

v_id json;
v_array text;
v_result_info json;
v_result_point json;
v_result_line json;
v_selectionmode text;
v_error_context text;

BEGIN 

	SET search_path= 'SCHEMA_NAME','public';

	-- delete previous log results
	DELETE FROM anl_arc WHERE fid=357 AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE fid=357 AND cur_user=current_user;

	-- select config values
	SELECT project_type, giswater  INTO v_projecttype, v_version FROM sys_version order by 1 desc limit 1;

	-- getting input data 	
	v_id  :=  ((p_data ->>'feature')::json->>'id')::json;
	v_selectionmode := (p_data ->>'data')::json->>'selectionMode';
	v_array :=  replace(replace(replace (v_id::text, ']', ')'),'"', ''''), '[', '(');

	-- starting function
	INSERT INTO audit_check_data (fid, error_message) VALUES (357, concat('ARC REVERSE FUNCTION'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (357, concat('------------------------------'));

	IF v_selectionmode = 'previousSelection' THEN

		IF v_array ='()' THEN
			INSERT INTO audit_check_data (fid, error_message) VALUES (357, 'ERROR: No arcs have been selected');
		ELSE
			-- execute
			EXECUTE 'INSERT INTO anl_arc(fid, arc_id, the_geom, descript) 
			SELECT 357, arc_id, the_geom, ''Arc reversed before reverse'' FROM arc WHERE arc_id IN ' ||v_array || ' ORDER BY arc_id';
				
			EXECUTE 'UPDATE arc SET the_geom=st_reverse(the_geom) WHERE arc_id IN ' ||v_array;

			INSERT INTO audit_check_data (fid, error_message) VALUES (357, concat ('Reversed arcs: arc_id --> ', 
			(SELECT array_agg(arc_id) FROM (SELECT arc_id FROM anl_arc WHERE fid=357 AND cur_user=current_user)a )));
		END IF;
	ELSE 
		INSERT INTO audit_check_data (fid, error_message) VALUES (357, concat ('Selection mode ''Whole selection'' is not enabled in this function'));
	END IF;
		
	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT id, error_message AS message 
	FROM audit_check_data WHERE cur_user="current_user"() AND ( fid=357)) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');


	-- control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	
	-- return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"setVisibleLayers":[]'||
		       '}}'||
	'}')::json;

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;