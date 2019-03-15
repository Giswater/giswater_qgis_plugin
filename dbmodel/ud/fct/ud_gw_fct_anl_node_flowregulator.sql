/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2208
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_node_flowregulator(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_flowregulator(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_node_flowregulator($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_edit_man_manhole", "id":["138","139"]},
"data":{"selectionMode":"previousSelection",
	"saveOnDatabase":true}}$$)
*/


DECLARE
	node_id_var    text;
	point_aux      public.geometry;
	srid_schema    text;
    v_version text;
	v_saveondatabase boolean;
	v_result json;
	v_id json;
    v_selectionmode text;
    v_worklayer text;
    v_array text;

BEGIN
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM version order by 1 desc limit 1;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=12;
    
    -- getting input data 	
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_array :=  replace(replace(replace (v_id::text, ']', ')'),'"', ''''), '[', '(');
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_saveondatabase :=  ((p_data ->>'data')::json->>'saveOnDatabase')::boolean;

	-- Computing process
	IF v_array != '()' THEN
		EXECUTE 'INSERT INTO anl_node (node_id, expl_id, fprocesscat_id, num_arcs, the_geom,nodecat_id)
				SELECT node_1 as node_id, '||v_worklayer||'.expl_id, 12, count(node_1) as num_arcs, '||v_worklayer||'.the_geom,nodecat_id
				FROM arc JOIN '||v_worklayer||' ON node_id=node_1 AND node_id IN '||v_array||'
				WHERE arc.state=1 and '||v_worklayer||'.state=1
				GROUP BY node_1, '||v_worklayer||'.expl_id, '||v_worklayer||'.the_geom 
				HAVING count(node_1)> 1 
				ORDER BY 2 desc;'	
	ELSE
		EXECUTE 'INSERT INTO anl_node (node_id, expl_id, fprocesscat_id, num_arcs, the_geom,nodecat_id)
						SELECT node_1 as node_id, '||v_worklayer||'.expl_id, 12, count(node_1) as num_arcs, '||v_worklayer||'.the_geom, nodecat_id
						FROM arc JOIN '||v_worklayer||' ON node_id=node_1
						WHERE arc.state=1 and '||v_worklayer||'.state=1
						GROUP BY node_1, '||v_worklayer||'.expl_id, '||v_worklayer||'.the_geom 
						HAVING count(node_1)> 1 
						ORDER BY 2 desc;'
	END IF;


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