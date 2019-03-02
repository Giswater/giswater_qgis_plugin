/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2210

DROP FUNCTION IF EXISTS "ud_sample".gw_fct_anl_node_sink();
CREATE OR REPLACE FUNCTION "ud_sample".gw_fct_anl_node_sink() 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT ud_sample.gw_fct_anl_node_sink()
*/

DECLARE
	node_id_var    text;
	expl_id_var    integer;
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
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=13;
	    
	-- Computing process 
	FOR node_id_var, expl_id_var, point_aux IN SELECT node_id, expl_id, the_geom FROM node AS a WHERE state=1 AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_2 = a.node_id) > 0) AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_1 = a.node_id) = 0)
	LOOP
		-- Insert in analytics table
		INSERT INTO anl_node (node_id, expl_id, num_arcs, fprocesscat_id, the_geom) VALUES(node_id_var, expl_id_var, 
		(SELECT COUNT(*) FROM arc WHERE state = 1 AND (node_1 = node_id_var OR node_2 = node_id_var)), 13, point_aux);
	END LOOP;
	    
	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=13) row; 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=13;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=13 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (13, current_user);
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