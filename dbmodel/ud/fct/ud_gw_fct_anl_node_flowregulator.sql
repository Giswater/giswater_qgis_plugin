/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2208
DROP FUNCTION IF EXISTS "ud_sample".gw_fct_anl_node_flowregulator();
CREATE OR REPLACE FUNCTION "ud_sample".gw_fct_anl_node_flowregulator() 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT ud_sample.gw_fct_anl_node_flowregulator()
*/


DECLARE
	node_id_var    text;
	point_aux      public.geometry;
	srid_schema    text;
    	v_version text;
	v_saveondatabase boolean = true;
	v_result json;
BEGIN
	SET search_path = "ud_sample", public;

	-- select version
	SELECT giswater INTO v_version FROM version order by 1 desc limit 1;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=12;
    
	-- Computing process
	INSERT INTO anl_node (node_id, expl_id, fprocesscat_id, num_arcs, the_geom)
	SELECT node_1 as node_id, node.expl_id, 12, count(node_1) as num_arcs, node.the_geom 
	FROM arc JOIN node ON node_id=node_1 
	WHERE arc.state=1 and node.state=1
	GROUP BY node_1, node.expl_id, node.the_geom 
	HAVING count(node_1)> 1 
	ORDER BY 2 desc;

	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=12) row; 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=12;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=12 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (12, current_user);
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