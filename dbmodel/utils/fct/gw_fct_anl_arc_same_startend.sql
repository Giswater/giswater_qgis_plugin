/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2104

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_arc_same_startend();
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_same_startend(p_data json) RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_arc_same_startend($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_edit_man_pipe", "id":["1004","1005"]},
"data":{"selectionMode":"previousSelection",
	"saveOnDatabase":true}}$$)
*/

DECLARE
    v_id json;
    v_selectionmode text;
    v_connectolerance float;
    v_saveondatabase boolean;
    v_worklayer text;
    v_result json;
    v_array text;
	v_version text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM version order by 1 desc limit 1;

	-- getting input data 	
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_array :=  replace(replace(replace (v_id::text, ']', ')'),'"', ''''), '[', '(');
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_saveondatabase :=  ((p_data ->>'data')::json->>'saveOnDatabase')::boolean;

	raise notice 'v_worklayer %  v_id %',v_worklayer ,v_array;

	-- Reset values
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=4;
	
	-- Computing process
	IF v_array != '()' THEN
		EXECUTE 'INSERT INTO anl_arc (arc_id, state, expl_id, fprocesscat_id, the_geom)
				SELECT arc_id, state, expl_id, 4, the_geom
				FROM '||v_worklayer||' WHERE node_1::text=node_2::text AND arc_id IN '||v_array||';';
	ELSE
		EXECUTE 'INSERT INTO anl_arc (arc_id, state, expl_id, fprocesscat_id, the_geom)
				SELECT arc_id, state, expl_id, 4, the_geom
				FROM '||v_worklayer||' WHERE node_1::text=node_2::text;';
	END IF;

	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=4) row; 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=4;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=4 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (4, current_user);
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

