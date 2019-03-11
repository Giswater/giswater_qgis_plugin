/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2110

DROP FUNCTION IF EXISTS "SCHEMA_NAME".c();
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_orphan() 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_node_orphan($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_edit_man_junction", "id":["1004","1005"]},
"data":{"selectionMode":"previousSelection",
	"saveOnDatabase":true}}$$)
*/

DECLARE

	rec_node record;
	v_closest_arc_id varchar;
	v_closest_arc_distance numeric;
	v_version text;
	v_saveondatabase boolean = true;
	v_result json;
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM version order by 1 desc limit 1;

	-- getting input data 	
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_array :=  replace(replace(replace (v_id::text, ']', ')'),'"', ''''), '[', '(');
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_saveondatabase :=  ((p_data ->>'data')::json->>'saveOnDatabase')::boolean;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=7;

	-- Computing process

	IF v_array != '()' THEN
		FOR rec_node IN EXECUTE 'SELECT DISTINCT * FROM '||v_worklayer||' a WHERE a.state=1 AND arc_id IN '||v_array||' AND 
		(SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id and arc.state=1) = 0' 
		LOOP
			--find the closest arc and the distance between arc and node
			SELECT ST_Distance(arc.the_geom, rec_node.the_geom) as d, arc.arc_id INTO v_closest_arc_distance, v_closest_arc_id 
			FROM arc ORDER BY arc.the_geom <-> rec_node.the_geom  LIMIT 1;
		
			INSERT INTO anl_node (node_id, state, expl_id, fprocesscat_id, the_geom, nodecat_id,arc_id,arc_distance) 
			VALUES (rec_node.node_id, rec_node.state, rec_node.expl_id, 7, rec_node.the_geom, rec_node.nodecat_id,v_closest_arc_id,v_closest_arc_distance);
		END LOOP;
	ELSE
		FOR rec_node IN EXECUTE 'SELECT DISTINCT * FROM '||v_worklayer||' a WHERE a.state=1 AND 
		(SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id and arc.state=1) = 0' 
		LOOP
			--find the closest arc and the distance between arc and node
			SELECT ST_Distance(arc.the_geom, rec_node.the_geom) as d, arc.arc_id INTO v_closest_arc_distance, v_closest_arc_id 
			FROM arc ORDER BY arc.the_geom <-> rec_node.the_geom  LIMIT 1;
		
			INSERT INTO anl_node (node_id, state, expl_id, fprocesscat_id, the_geom, nodecat_id,arc_id,arc_distance) 
			VALUES (rec_node.node_id, rec_node.state, rec_node.expl_id, 7, rec_node.the_geom, rec_node.nodecat_id,v_closest_arc_id,v_closest_arc_distance);
		END LOOP;
	END IF;


	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=7) row; 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=7;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=7 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (7, current_user);
	END IF;
		
	--    Control nulls
	v_result := COALESCE(v_result, '[]'); 

	--  Return
	RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "version":"'||v_version||'"'||
	     ',"body":{"form":{}'||
		     ',"data":{"result":' || v_result ||
			     '}'||
		       '}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 