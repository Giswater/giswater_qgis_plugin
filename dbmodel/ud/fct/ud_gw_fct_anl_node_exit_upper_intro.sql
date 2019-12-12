/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2206

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_node_exit_upper_intro(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_exit_upper_intro(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE
	SELECT SCHEMA_NAME.gw_fct_anl_node_exit_upper_intro($${
	"client":{"device":3, "infoType":100, "lang":"ES"},
	"feature":{"tableName":"v_edit_man_manhole", "id":["60"]},
	"data":{"selectionMode":"previousSelection", "parameters":{"saveOnDatabase":true}
	}}$$)
*/


DECLARE
	sys_elev1_var numeric(12,3);
	sys_elev2_var numeric(12,3);
	rec_node record;
	rec_arc record;
	v_version text;
	v_saveondatabase boolean;
	v_result json;
	v_result_info json;
	v_result_point json;
	v_id json;
	v_selectionmode text;
	v_worklayer text;
	v_array text;
	v_sql text;
	v_querytext text;
	v_querytextres record;
	v_i integer;
	v_count text;

	
BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=11;
    
    	-- select version
	SELECT giswater INTO v_version FROM version order by 1 desc limit 1;

	-- getting input data 	
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_array :=  replace(replace(replace (v_id::text, ']', ')'),'"', ''''), '[', '(');
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_saveondatabase :=  (((p_data ->>'data')::json->>'parameters')::json->>'saveOnDatabase')::boolean;


	-- Computing process
	IF v_array != '()' THEN
		v_sql:= 'SELECT * FROM '||v_worklayer||' where node_id in (select node_1 from v_edit_arc) 
		and node_id in (select node_2 from v_edit_arc) and node_id IN '||v_array||';';
	ELSE
		v_sql:= ('SELECT * FROM '||v_worklayer||' where node_id in (select node_1 from v_edit_arc) 
		and node_id in (select node_2 from v_edit_arc)');
	END IF;
	

	FOR rec_node IN EXECUTE v_sql
		LOOP
			-- raise notice
			--raise notice '% - %', v_i, v_count;
			v_i=v_i+1;

			-- setting variables
			sys_elev1_var=0;
			sys_elev2_var=0;
			
			-- as node1
			v_querytext = 'SELECT * FROM v_edit_arc where node_1::integer='||rec_node.node_id;
			EXECUTE v_querytext INTO v_querytextres;
			IF v_querytextres.arc_id IS NOT NULL THEN
				FOR rec_arc IN EXECUTE v_querytext
				LOOP
					sys_elev1_var=greatest(sys_elev1_var,rec_arc.sys_elev1);
				END LOOP;
			ELSE
				sys_elev1_var=NULL;
			END IF;
			
			-- as node2
			v_querytext = 'SELECT * FROM v_edit_arc where node_2::integer='||rec_node.node_id;
			EXECUTE v_querytext INTO v_querytextres;
			IF v_querytextres.arc_id IS NOT NULL THEN
				FOR rec_arc IN EXECUTE v_querytext
				LOOP
					sys_elev2_var=greatest(sys_elev2_var,rec_arc.sys_elev2);
				END LOOP;
			ELSE
				sys_elev2_var=NULL;
			END IF;
			
			IF sys_elev1_var > sys_elev2_var AND sys_elev1_var IS NOT NULL AND sys_elev2_var IS NOT NULL THEN
				INSERT INTO anl_node (node_id, nodecat_id, expl_id, fprocesscat_id, the_geom, arc_distance, state) VALUES
				(rec_node.node_id,rec_node.nodecat_id, rec_node.expl_id, 11, rec_node.the_geom,sys_elev1_var - sys_elev2_var,rec_node.state );
				raise notice 'Node found % :[% / %] maxelevin % maxelevout %',rec_node.node_id, v_i, v_count, sys_elev2_var , sys_elev1_var ;
			END IF;
		
		END LOOP;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=11 order by id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--points
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, the_geom, fprocesscat_id FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=11) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "values":',v_result, '}');

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=11;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=11 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (11, current_user);
	END IF;
		
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 

	--  Return
	RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||
			'}}'||
	    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;