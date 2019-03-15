/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2202

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_arc_intersection(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_intersection(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_arc_intersection($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_edit_man_conduit", "id":["138","139"]},
"data":{"selectionMode":"previousSelection",
	"saveOnDatabase":true}}$$)
*/

DECLARE
	v_version text;
	v_result json;
	v_id json;
    v_selectionmode text;
    v_saveondatabase boolean;
    v_worklayer text;
    v_array text;


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

	-- Reset values
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=9;
	    
	-- Computing process
	IF v_array != '()' THEN
		EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fprocesscat_id, arc_id_aux, the_geom_p, arccat_id)
		SELECT a.arc_id AS arc_id_1, a.expl_id, 9, b.arc_id AS arc_id_2, 
		(ST_Dumppoints(ST_Multi(ST_Intersection(a.the_geom, b.the_geom)))).geom AS the_geom, arccat_id
		FROM '||v_worklayer||' AS a, '||v_worklayer||' AS b 
		WHERE a.state=1 AND b.state=1 AND ST_Intersects(a.the_geom, b.the_geom) AND a.arc_id != b.arc_id AND NOT ST_Touches(a.the_geom, b.the_geom)
		AND a.the_geom is not null and b.the_geom is not null AND a.arc_id IN '||v_array||';';
	ELSE
		EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fprocesscat_id, arc_id_aux, the_geom_p, arccat_id)
		SELECT a.arc_id AS arc_id_1, a.expl_id, 9, b.arc_id AS arc_id_2, 
		(ST_Dumppoints(ST_Multi(ST_Intersection(a.the_geom, b.the_geom)))).geom AS the_geom, arccat_id
		FROM '||v_worklayer||' AS a, '||v_worklayer||' AS b 
		WHERE a.state=1 AND b.state=1 AND ST_Intersects(a.the_geom, b.the_geom) AND a.arc_id != b.arc_id AND NOT ST_Touches(a.the_geom, b.the_geom)
		AND a.the_geom is not null and b.the_geom is not null;';
	END IF;

	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT * FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=9) row; 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=9;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=9 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (9,current_user);
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