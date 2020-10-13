/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2496

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_repair_arc();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_arc_repair(p_data json) RETURNS json AS
$BODY$

/*EXAMPLE

-- fid: 103, 104

SELECT SCHEMA_NAME.gw_fct_arc_repair($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{}, "feature":{"tableName":"v_edit_arc",
"featureType":"ARC", "id":["2094"]},
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"previousSelection",
"parameters":{}}}$$);


*/

DECLARE
 
arcrec text;
v_count integer;
v_count_partial integer=0;
v_result text;
v_version text;
v_projecttype text;
v_saveondatabase boolean;
v_feature_text text;
v_feature_array text[];

v_id json;
v_selectionmode text;
v_worklayer text;
v_array text;
v_result_info json;
v_result_point json;
v_result_line json;

BEGIN 

	SET search_path= 'SCHEMA_NAME','public';

	-- Get parameters from input json
	v_feature_text = ((p_data ->>'feature')::json->>'id'::text);

    IF v_feature_text ILIKE '[%]' THEN
		v_feature_array = ARRAY(SELECT json_array_elements_text(v_feature_text::json)); 		
    ELSE 
		EXECUTE v_feature_text INTO v_feature_text;
		v_feature_array = ARRAY(SELECT json_array_elements_text(v_feature_text::json)); 
    END IF;
    
	-- Delete previous log results
	DELETE FROM anl_arc WHERE fid=118 AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fid=103 AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE fid=118 AND cur_user=current_user;

	-- select config values
	SELECT project_type, giswater  INTO v_projecttype, v_version FROM sys_version order by 1 desc limit 1;

	-- getting input data 	
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;
    
	-- Set config parameter
	UPDATE config_param_system SET value=TRUE WHERE parameter='edit_topocontrol_disable_error' ;

	-- execute
	IF v_selectionmode != 'previousSelection' THEN
		INSERT INTO anl_arc(fid, arc_id, the_geom, descript) 
		SELECT 103, arc_id, the_geom, 'b' FROM arc WHERE arc_id IN (SELECT arc_id FROM v_edit_arc WHERE state=1 AND (node_1 IS NULL OR node_2 IS NULL ));
		
		EXECUTE 'UPDATE arc SET the_geom=the_geom WHERE arc_id IN (SELECT arc_id FROM v_edit_arc WHERE state=1)';
		
		INSERT INTO anl_arc(fid, arc_id, the_geom, descript) 
		SELECT 103, arc_id, the_geom, 'a' FROM arc WHERE arc_id IN (SELECT arc_id FROM v_edit_arc WHERE state=1 AND (node_1 IS NULL OR node_2 IS NULL));
		
		INSERT INTO anl_arc(fid, arc_id, the_geom) SELECT 118, arc_id, the_geom FROM (SELECT arc_id, the_geom FROM anl_arc WHERE fid=103 AND descript='b' 
		AND cur_user=current_user AND arc_id NOT IN (SELECT arc_id FROM anl_arc WHERE fid=103 AND descript ='a' AND cur_user=current_user))a; 
	ELSE
		EXECUTE 'INSERT INTO anl_arc(fid, arc_id, the_geom, descript) 
		SELECT 103, arc_id, the_geom, ''b'' FROM arc WHERE arc_id IN (' ||v_array || ') AND state=1 AND node_1 IS NULL OR node_2 IS NULL';
		
		EXECUTE 'UPDATE arc SET the_geom=the_geom WHERE arc_id IN (' ||v_array || ') AND state=1';

		EXECUTE 'INSERT INTO anl_arc(fid, arc_id, the_geom, descript) 
		SELECT 103, arc_id, the_geom, ''a'' FROM arc WHERE arc_id IN (' ||v_array || ') AND state=1 AND node_1 IS NULL OR node_2 IS NULL';
		
		INSERT INTO anl_arc(fid, arc_id, the_geom) SELECT 118, arc_id, the_geom FROM (SELECT arc_id, the_geom FROM anl_arc WHERE fid=103 AND descript='b' 
		AND cur_user=current_user AND arc_id NOT IN (SELECT arc_id FROM anl_arc WHERE fid=103 AND descript ='a' AND cur_user=current_user))a; 
	END IF;

	INSERT INTO audit_check_data (fid, error_message) VALUES (118, concat('ARC REPAIR FUNCTION'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (118, concat('-----------------------------'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (118, concat ('Repaired arcs: arc_id --> ', 
	(SELECT array_agg(arc_id) FROM (SELECT arc_id FROM anl_arc WHERE fid=118 AND cur_user=current_user)a )));
	
	-- Set config parameter
	UPDATE config_param_system SET value=FALSE WHERE parameter='edit_topocontrol_disable_error' ;
	
	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND ( fid=118)) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--lines
	v_result = null;

	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript,fid, the_geom
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid = 118) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}'); 

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	
	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||
			'}}'||
	    '}')::json, 2496);
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
