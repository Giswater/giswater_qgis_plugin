/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2784

--SELECT SCHEMA_NAME.gw_fct_insert_importdxf();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_insert_importdxf(p_data json)
RETURNS json AS
$BODY$


DECLARE 
v_incorrect_arc text[];
v_count integer;
v_errortext text;
v_start_point geometry(Point,25831);
v_end_point geometry(Point,25831);
v_query text;
v_result json;
v_result_info json;
v_result_point json;
v_result_polygon json;
v_result_line json;
v_missing_cat_node text;
v_missing_cat_arc text;

v_project_type text;
v_version text;
v_cat_feature text;
rec text;

BEGIN 


	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- select config values
	SELECT wsoftware, giswater INTO v_project_type, v_version FROM version order by id desc limit 1;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id=107 AND user_name=current_user;
	--DELETE FROM anl_node WHERE fprocesscat_id=107 AND cur_user=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (107, null, 4, concat('IMPORT DXF'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (107, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (107, null, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (107, null, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (107, null, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (107, null, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (107, null, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (107, null, 1, '-------');


	--insert missing catalogs
	IF v_project_type = 'WS' THEN
		SELECT id INTO v_cat_feature FROM arc_type WHERE type='PIPE' LIMIT 1;
		
		INSERT INTO cat_arc (id,arctype_id)
		SELECT DISTINCT (text_column::json)->>'Layer',v_cat_feature FROM temp_table 
		WHERE fprocesscat_id=106 and geom_line IS NOT NULL AND (text_column::json)->>'Layer' not in (SELECT id FROM cat_arc);

		FOR rec IN (SELECT DISTINCT (text_column::json)->>'Layer' FROM temp_table 
		WHERE fprocesscat_id=106 and geom_point IS NOT NULL AND (text_column::json)->>'Layer' not in (SELECT id FROM cat_node)) LOOP
		raise notice 'rec,%',rec;
		
			IF rec::text IN (SELECT id FROM node_type) THEN
				INSERT INTO cat_node (id,nodetype_id)
				VALUES (rec,rec);
			ELSIF  rec::text IN (SELECT type FROM node_type) THEN
				INSERT INTO cat_node (id,nodetype_id)
				SELECT rec,id FROM node_type WHERE rec=type LIMIT 1;
			ELSE
				RAISE NOTICE 'FALTA CAT FEATURE';
			END IF;
		END LOOP;

		IF 'JUNCTION' in (SELECT id FROM node_type) THEN
			INSERT INTO cat_node (id,nodetype_id) VALUES ('JUNCTION','JUNCTION') ON CONFLICT (id) DO NOTHING;
		ELSE 
			SELECT id INTO v_cat_feature FROM node_type WHERE type='JUNCTION';
			INSERT INTO cat_node (id,nodetype_id) VALUES ('JUNCTION',v_cat_feature) ON CONFLICT (id) DO NOTHING;
		END IF;

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (107, 1, 'INFO:Insert missing values into cat_arc and cat_node.');


		INSERT INTO v_edit_node (nodecat_id,state,state_type,the_geom)
		SELECT (text_column::json)->>'Layer'::text, 1, 2, geom_point
		FROM temp_table WHERE fprocesscat_id=106 and geom_point IS NOT NULL;


		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (107, 1, 'INFO:Insert nodes from dxf.');


		INSERT INTO v_edit_node (nodecat_id,state,state_type,the_geom)
		SELECT nodecat_id, 1, 2, the_geom FROM anl_node WHERE fprocesscat_id=106 AND descript='NEW';

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (107, 1, 'INFO:Insert missing final nodes.');


		INSERT INTO v_edit_arc (arccat_id,state,state_type,the_geom)
		SELECT DISTINCT ON (geom_line) (text_column::json)->>'Layer', 1, 2, geom_line
		FROM temp_table WHERE fprocesscat_id=106 and geom_line IS NOT NULL;

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (107, 1, 'INFO:Insert arcs from dxf.');

	ELSIF v_project_type='UD' THEN
		INSERT INTO cat_arc (id,arctype_id)
		SELECT DISTINCT (text_column::json)->>'Layer' FROM temp_table 
		WHERE fprocesscat_id=106 and geom_line IS NOT NULL AND (text_column::json)->>'Layer' not in (SELECT id FROM cat_arc);

		INSERT INTO cat_node(id,nodetype_id)
		SELECT DISTINCT (text_column::json)->>'Layer' FROM temp_table 
		WHERE fprocesscat_id=106 and geom_point IS NOT NULL AND (text_column::json)->>'Layer' not in (SELECT id FROM cat_node);

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (107, 1, 'INFO:Insert missing values into cat_arc and cat_node.');
	END IF;

	

	-- get results
	-- info

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data 
	WHERE user_name="current_user"() AND fprocesscat_id=107 ORDER BY criticity desc, id asc) row; 
	
	v_result_info := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');


	--points
	v_result = null;

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id as feature_id, nodecat_id as feature_catalog, state, expl_id, descript,fprocesscat_id, the_geom 
	FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=107) row;

	v_result := COALESCE(v_result, '{}'); 
	
	IF v_result::text = '{}' THEN 
		v_result_point = '{"geometryType":"", "values":[]}';
	ELSE 
		v_result_point = concat ('{"geometryType":"Point", "values":',v_result, '}');
	END IF;

	v_result_line = '{"geometryType":"", "values":[]}';
	v_result_polygon = '{"geometryType":"", "values":[]}';

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





-- tramos sin nodo final, pero en un buffer hay un nodo existente
-- tramos sin nodo y no hay nada cerca
-- crear nodo que falta y mostarlo de otro color
