/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2108

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_duplicated(p_data json) RETURNS json AS 
$BODY$
/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_node_duplicated($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_edit_man_junction", "id":["1004","1005"]},
"data":{"selectionMode":"previousSelection",
	"parameters":{"nodeTolerance":3},
	"saveOnDatabase":true}}$$)
*/

DECLARE
    v_id json;
    v_selectionmode text;
    v_nodetolerance float;
    v_saveondatabase boolean;
    v_worklayer text;
    v_result json;
    v_array text;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_array :=  replace(replace(replace (v_id::text, ']', ')'),'"', ''''), '[', '(');
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_saveondatabase :=  ((p_data ->>'data')::json->>'saveOnDatabase')::boolean;
	v_nodetolerance := ((p_data ->>'data')::json->>'parameters')::json->>'nodeTolerance';

	raise notice 'v_worklayer % v_nodetolerance % v_id %',v_worklayer ,v_nodetolerance ,v_array;
	
	-- Computing process
	EXECUTE 'INSERT INTO anl_node (node_id, nodecat_id, state, node_id_aux, nodecat_id_aux, state_aux, expl_id, fprocesscat_id, the_geom)
			SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.state, t2.node_id, t2.nodecat_id, t2.state, t1.expl_id, 6, t1.the_geom
			FROM '||v_worklayer||' AS t1 JOIN '||v_worklayer||' AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom,('||v_nodetolerance||')) 
			WHERE t1.node_id != t2.node_id AND t1.node_id IN '||v_array||' ORDER BY t1.node_id';

	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=6) row; 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=6;
	ELSE;
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=6 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (6, current_user);
	END IF;

--    Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "version":"3.1.105"'||
             ',"body":{"form":{}'||
		     ',"data":{"result":' || v_result ||
			     '}'||
		       '}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;