/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2786
--SELECT SCHEMA_NAME.gw_fct_check_importdxf();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_check_importdxf()
RETURNS json AS
$BODY$

DECLARE 
v_incorrect_arc text[];
v_count integer;
v_errortext text;
v_start_point geometry(Point,25831);
v_end_point geometry(Point,25831);
v_query text;
rec record;
v_result json;
v_result_info json;
v_result_point json;
v_project_type text;
v_version text;
v_result_polygon json;
v_result_line json;
v_missing_cat_node text;
v_missing_cat_arc text;
v_incorrect_start text[];
v_incorrect_end text[];

 
BEGIN 


	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- select config values
	SELECT wsoftware, giswater INTO v_project_type, v_version FROM version order by id desc limit 1;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id=106 AND user_name=current_user;
	DELETE FROM anl_node WHERE fprocesscat_id=106 AND cur_user=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (106, null, 4, concat('CHECK IMPORT DXF'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (106, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (106, null, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (106, null, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (106, null, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (106, null, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (106, null, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (106, null, 1, '-------');


	--check if there are nodes coming from dxf that overlap nodes existing in the network
	v_count=0;
	FOR rec IN SELECT * FROM temp_table WHERE temp_table.geom_point IS NOT NULL LOOP
		IF (SELECT node_id FROM node WHERE ST_DWithin(rec.geom_point,node.the_geom,0.01)) IS NOT NULL THEN
			v_count=+1;
			
			INSERT INTO anl_node(nodecat_id, fprocesscat_id, the_geom, descript)
			VALUES ('JUNCTION'::text, 106,rec.geom_point,'DUPLICATED');
		END IF;
	END LOOP;

	IF v_count > 0 THEN

		v_errortext=concat('WARNING: There are ', v_count, ' nodes from dxf that overlap nodes existing in the network.');

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (106, 2, v_errortext);
	END IF;

	--check if arcs have final nodes
	select distinct array_agg(id) INTO v_incorrect_start from temp_table 
	WHERE temp_table.geom_line is not null and fprocesscat_id=106 AND id not IN
	(SELECT a.id FROM temp_table a,temp_table b WHERE ST_DWithin(ST_startpoint(a.geom_line), b.geom_point, 0.01)
	AND a.fprocesscat_id=106 and b.fprocesscat_id=106);

	select distinct array_agg(id) INTO v_incorrect_end from temp_table 
	WHERE temp_table.geom_line is not null and fprocesscat_id=106 AND id not IN
	(SELECT a.id FROM temp_table a,temp_table b WHERE ST_DWithin(ST_endpoint(a.geom_line), b.geom_point, 0.01)
	AND a.fprocesscat_id=106 and b.fprocesscat_id=106);

	v_incorrect_arc=ARRAY(SELECT DISTINCT UNNEST(array_cat(v_incorrect_start,v_incorrect_end)));

	--v_count = array_length(v_incorrect_start,1) + array_length(v_incorrect_end,1);

	v_count = array_length(v_incorrect_arc,1);
	
	IF v_count > 0 THEN

		v_errortext=concat('WARNING: There are ', v_count, ' arcs without final nodes in dxf.');

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (106, 2, v_errortext);
	END IF;

	--check if there is a node located in the close distance from the missing end 
	--insert final node into anl_node if there is none found
	FOR rec IN SELECT * FROM temp_table WHERE temp_table.geom_line IS NOT NULL AND (id::text = ANY(v_incorrect_start) OR id::text = ANY(v_incorrect_end)) LOOP

		SELECT ST_Endpoint(geom_line) into v_start_point FROM temp_table WHERE temp_table.geom_line IS NOT NULL AND id=rec.id;
		SELECT ST_startpoint(geom_line) into v_end_point FROM temp_table WHERE temp_table.geom_line IS NOT NULL AND id=rec.id;

		IF (SELECT node_id FROM node WHERE ST_DWithin(the_geom,v_start_point,0.1) LIMIT 1) IS NULL THEN
			IF NOT EXISTS (SELECT * FROM temp_table WHERE fprocesscat_id=106 AND geom_point=v_start_point) THEN
				IF NOT EXISTS (SELECT * FROM anl_node WHERE fprocesscat_id=106 AND the_geom=v_start_point) THEN
							
					INSERT INTO anl_node(nodecat_id, fprocesscat_id, the_geom, descript)
					VALUES ('JUNCTION'::text, 106,v_start_point,'NEW');
				END IF;
			END IF;
		ELSE
			INSERT INTO anl_node(node_id, nodecat_id, state,expl_id, fprocesscat_id, the_geom,descript)
			SELECT node_id, nodecat_id, state,expl_id,106,the_geom,'EXISTS'
			FROM node WHERE ST_DWithin(the_geom,v_start_point,0.1);
       
		END IF;

		IF (SELECT node_id FROM node WHERE ST_DWithin(the_geom,v_end_point,0.1) LIMIT 1) IS NULL THEN	
			IF NOT EXISTS (SELECT * FROM temp_table WHERE fprocesscat_id=106 AND geom_point=v_end_point) THEN
				IF NOT EXISTS (SELECT * FROM anl_node WHERE fprocesscat_id=106 AND the_geom=v_end_point) THEN
					raise notice 'insert end';

					INSERT INTO anl_node(nodecat_id, fprocesscat_id, the_geom, descript)
					VALUES ('JUNCTION'::text, 106,v_end_point,'NEW');
				END IF;
			END IF;
		ELSE
			INSERT INTO anl_node(node_id, nodecat_id, state,expl_id, fprocesscat_id, the_geom, descript)
			SELECT node_id, nodecat_id, state,expl_id,106,the_geom, 'EXISTS'
			FROM node WHERE ST_DWithin(the_geom,v_end_point,0.1); 
		END IF;
		
	END LOOP;

	--check if there are catalogs from dxf are the same as those defined in giswater
	select replace(replace(string_agg(a::text,', '),'(',''),')','') into v_missing_cat_node FROM 
	(SELECT DISTINCT (text_column::json)->>'Layer' FROM temp_table 
	WHERE fprocesscat_id=106 and geom_point IS NOT NULL AND (text_column::json)->>'Layer' not in (SELECT id FROM cat_node) ) a;

	IF v_missing_cat_node IS NOT NULL THEN
		v_errortext=concat('WARNING: There are nodes which are not defined in cat_node: ',v_missing_cat_node,'.');

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (106, 2, v_errortext);
	END IF;

	select replace(replace(string_agg(a::text,', '),'(',''),')','') into v_missing_cat_arc FROM 
	(SELECT DISTINCT (text_column::json)->>'Layer' FROM temp_table 
	WHERE fprocesscat_id=106 and geom_line IS NOT NULL AND (text_column::json)->>'Layer' not in (SELECT id FROM cat_arc) ) a;

	IF v_missing_cat_arc IS NOT NULL THEN
		v_errortext=concat('WARNING: There are arcs which are not defined in cat_arc: ',v_missing_cat_arc,'.');

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (106, 2, v_errortext);
	END IF;

	-- get results
	-- info

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data 
	WHERE user_name="current_user"() AND fprocesscat_id=106 ORDER BY criticity desc, id asc) row; 
	
	v_result_info := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');


	--points
	v_result = null;

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id as feature_id, nodecat_id as feature_catalog, state, expl_id, descript,fprocesscat_id, the_geom 
	FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=106) row;

	v_result := COALESCE(v_result, '{}'); 
	
	IF v_result::text = '{}' THEN 
		v_result_point = '{"geometryType":"", "values":[]}';
	ELSE 
		v_result_point = concat ('{"geometryType":"Point", "values":',v_result,',"category_field":"descript","size":4}');
	END IF;

	v_result_line = '{"geometryType":"", "values":[],"category_field":""}';
	v_result_polygon = '{"geometryType":"", "values":[],"category_field":""}';

--  Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

