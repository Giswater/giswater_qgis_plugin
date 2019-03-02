/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2302

DROP FUNCTION IF EXISTS ws_sample.gw_fct_anl_node_topological_consistency() ;
CREATE OR REPLACE FUNCTION ws_sample.gw_fct_anl_node_topological_consistency() 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT ws_sample.gw_fct_anl_node_topological_consistency()
*/

DECLARE
	rec_node record;
	rec record;
	v_version text;
	v_saveondatabase boolean = true;
	v_result json;
BEGIN
	SET search_path = "ws_sample", public;

	-- select version
	SELECT giswater INTO v_version FROM version order by 1 desc limit 1;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND anl_node.fprocesscat_id=8;


	-- Computing process
	INSERT INTO anl_node (node_id, nodecat_id, state, num_arcs, expl_id, fprocesscat_id, the_geom)

	SELECT node_id, nodecat_id, v_edit_node.state, COUNT(*), v_edit_node.expl_id, 8, v_edit_node.the_geom FROM v_edit_node JOIN v_edit_arc ON v_edit_arc.node_1 = v_edit_node.node_id OR v_edit_arc.node_2 = v_edit_node.node_id
	JOIN node_type ON nodetype_id=id WHERE num_arcs=4
	GROUP BY v_edit_node.node_id, nodecat_id, v_edit_node.state, v_edit_node.expl_id, v_edit_node.the_geom HAVING COUNT(*) != 4
	UNION
	SELECT node_id, nodecat_id, v_edit_node.state, COUNT(*), v_edit_node.expl_id, 8, v_edit_node.the_geom FROM v_edit_node JOIN v_edit_arc ON v_edit_arc.node_1 = v_edit_node.node_id OR v_edit_arc.node_2 = v_edit_node.node_id
	JOIN node_type ON nodetype_id=id WHERE num_arcs=3
	GROUP BY v_edit_node.node_id, nodecat_id, v_edit_node.state, v_edit_node.expl_id, v_edit_node.the_geom HAVING COUNT(*) != 3
	UNION
	SELECT node_id, nodecat_id, v_edit_node.state, COUNT(*), v_edit_node.expl_id, 8, v_edit_node.the_geom FROM v_edit_node JOIN v_edit_arc ON v_edit_arc.node_1 = v_edit_node.node_id OR v_edit_arc.node_2 = v_edit_node.node_id
	JOIN node_type ON nodetype_id=id WHERE num_arcs=2
	GROUP BY v_edit_node.node_id, nodecat_id, v_edit_node.state, v_edit_node.expl_id, v_edit_node.the_geom HAVING COUNT(*) != 2
	UNION
	SELECT node_id, nodecat_id, v_edit_node.state, COUNT(*), v_edit_node.expl_id, 8, v_edit_node.the_geom FROM v_edit_node JOIN v_edit_arc ON v_edit_arc.node_1 = v_edit_node.node_id OR v_edit_arc.node_2 = v_edit_node.node_id
	JOIN node_type ON nodetype_id=id WHERE num_arcs=1
	GROUP BY v_edit_node.node_id, nodecat_id, v_edit_node.state, v_edit_node.expl_id, v_edit_node.the_geom HAVING COUNT(*) != 1;

	DELETE FROM selector_audit WHERE fprocesscat_id=8 AND cur_user=current_user;	
	INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (8, current_user);

	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=8) row; 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fprocesscat_id=8;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=8 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (8, current_user);
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