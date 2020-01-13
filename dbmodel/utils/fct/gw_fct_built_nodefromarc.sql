/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2118


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_built_nodefromarc();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_built_nodefromarc(p_data json) RETURNS json AS
$BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_built_nodefromarc($${"client":{"device":9, "infoType":100, "lang":"ES"},
"form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
"parameters":{"exploitation":"1", "inserIntoNode":"true", "nodeTolerance":"0.01", "saveOnDatabase":"true"}}}$$)::text
*/

DECLARE
	rec_arc record;
	rec_table record;
	numnodes integer;
	v_version text;
	v_saveondatabase boolean = true;
	v_result json;
	v_result_info json;
	v_result_point json;
	v_node_proximity double precision;
	v_buffer double precision;
	v_nodetype text;
	v_expl integer;
	v_insertnode boolean;
	v_projecttype text;
	rec record;
	v_nodecat text;
	v_nodetype_id text;
	v_isarcdivide boolean;

BEGIN

	-- Search path
	SET search_path = SCHEMA_NAME, public;

	-- select version
	SELECT giswater, wsoftware INTO v_version, v_projecttype FROM version order by 1 desc limit 1;

	-- getting input data   
	v_expl :=  ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';
	v_buffer := ((p_data ->>'data')::json->>'parameters')::json->>'nodeTolerance';
	v_insertnode := ((p_data ->>'data')::json->>'parameters')::json->>'insertIntoNode';


	--  Reset values
	DELETE FROM temp_table WHERE user_name=current_user AND fprocesscat_id=16;
	DELETE FROM anl_node WHERE cur_user=current_user AND fprocesscat_id=16;

	-- inserting all extrem nodes on temp_node
	INSERT INTO temp_table (fprocesscat_id, geom_point)
	SELECT 	16, ST_StartPoint(the_geom) AS the_geom FROM arc WHERE expl_id=v_expl and (state=1 or state=2)
	UNION 
	SELECT 	16, ST_EndPoint(the_geom) AS the_geom FROM arc WHERE expl_id=v_expl and (state=1 or state=2);
	
	
	-- inserting into node table
	FOR rec_table IN SELECT * FROM temp_table WHERE user_name=current_user AND fprocesscat_id=16
	LOOP
	        -- Check existing nodes  
	        numNodes:= 0;
		numNodes:= (SELECT COUNT(*) FROM node WHERE st_dwithin(node.the_geom, rec_table.geom_point, v_buffer));
		IF numNodes = 0 THEN
			IF v_insertnode THEN
				INSERT INTO v_edit_node (the_geom) VALUES (rec_table.geom_point);
			ELSE 
				INSERT INTO anl_node (the_geom, state, fprocesscat_id) VALUES (rec_table.geom_point, 1, 16);
			END IF;
		ELSE

		END IF;
	END LOOP;
		
	-- repair arcs
	IF v_insertnode THEN
	
		-- set isarcdivide of chosed nodetype on false
		IF v_projecttype ='WS' THEN
			v_nodecat =  (SELECT value FROM config_param_user WHERE parameter='nodecat_vdefault' AND cur_user=current_user);
			SELECT nodetype_id INTO v_nodetype_id FROM cat_node WHERE id=v_nodecat;
		ELSE
			v_nodetype_id =  (SELECT value FROM config_param_user WHERE parameter='nodetype_vdefault' AND cur_user=current_user);		
		END IF;
	
		SELECT isarcdivide INTO v_isarcdivide FROM node_type WHERE id=v_nodetype_id;
		UPDATE node_type SET isarcdivide=FALSE WHERE id=v_nodetype_id;	
	
		-- execute function
		PERFORM gw_fct_repair_arc(arc_id, 0,0) FROM arc WHERE expl_id=v_expl AND (node_1 IS NULL OR node_2 IS NULL);
	
		-- restore isarcdivide to previous value
		UPDATE node_type SET isarcdivide=v_isarcdivide WHERE id=v_nodetype_id;	
		
	END IF;	

	-- get log
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT * FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=16) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--points
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, the_geom FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=16) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "values":',v_result, '}'); 
  
  	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fprocesscat_id=16;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=16 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (16, current_user);
	END IF;
		
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 

	--  Return
	RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"setVisibleLayers":[]'||
			'}}'||
	    '}')::json;

            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
