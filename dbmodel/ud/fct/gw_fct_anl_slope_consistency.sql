/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2986

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_slope_consistency(p_data json) RETURNS json AS 
$BODY$
/*EXAMPLE

SELECT gw_fct_anl_slope_consistency($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, 
"feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":["18920", "18945", "18921", "18922", "18944", "18923"]}, 
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"previousSelection","parameters":{}}}$$);

SELECT gw_fct_anl_slope_consistency($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
"form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
 "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}}}$$);
-- fid: 250

*/

DECLARE
    
v_id json;
v_expl_id integer;
v_selectionmode text;
v_worklayer text;
v_array text;

rec record;

v_result json;
v_result_info json;
v_result_line json;
v_version text;
v_error_context text;


BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version order by 1 desc limit 1;
	
	-- getting input data 	
	v_expl_id :=  ((p_data ->>'feature')::json->>'expl_id')::json;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	IF v_array = '()' THEN
		v_array  = null;
	END IF;

	-- Reset values
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid=250;
	DELETE FROM temp_arc WHERE  result_id = '250';

	-- Computing process
	IF v_selectionmode !='previousSelection' THEN

		EXECUTE 'INSERT INTO temp_arc (arc_id, arccat_id, state, expl_id, result_id, elevmax1, elevmax2, sector_id, the_geom)
		SELECT arc_id,arccat_id,state, expl_id, ''250'', sys_elev1, sys_elev2, sector_id,
		CASE WHEN sys_elev1 > sys_elev2 THEN the_geom
		WHEN sys_elev2 > sys_elev1 AND inverted_slope = true THEN the_geom
		WHEN sys_elev2 > sys_elev1 THEN St_reverse(the_geom)
		END AS geom
		FROM '||v_worklayer||';';
	ELSE
	
		EXECUTE 'INSERT INTO temp_arc (arc_id, arccat_id, state, expl_id, result_id, elevmax1, elevmax2, sector_id, the_geom)
		SELECT arc_id,arccat_id,state, expl_id, ''250'', sys_elev1, sys_elev2, sector_id,
		CASE WHEN sys_elev1 > sys_elev2 THEN the_geom
		WHEN sys_elev2 > sys_elev1 AND inverted_slope = true THEN the_geom
		WHEN sys_elev2 > sys_elev1 THEN St_reverse(the_geom)
		END AS geom
		FROM '||v_worklayer||' WHERE arc_id IN ('||v_array||');';
	END IF;

	FOR rec IN SELECT * FROM temp_arc WHERE result_id = '250' LOOP
		IF (SELECT the_geom::text FROM arc WHERE arc_id = rec.arc_id) != rec.the_geom::text  THEN

			INSERT INTO anl_arc (arc_id, arccat_id, state, expl_id, fid, elev1, elev2, the_geom)
			SELECT  arc_id, arccat_id, state, expl_id, result_id::integer, elevmax1, elevmax2, the_geom
			FROM temp_arc where arc_id = rec.arc_id AND result_id='250';

		END IF;

	END LOOP;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=250 order by id) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--points
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
		FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, elev1, elev2, fid, the_geom
		FROM  anl_arc WHERE cur_user="current_user"() AND fid=250) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}'); 


	-- set selector
	DELETE FROM selector_audit WHERE fid=250 AND cur_user=current_user;
	INSERT INTO selector_audit (fid,cur_user) VALUES (250, current_user);

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"line":'||v_result_line||
			'}}'||
	    '}')::json, 2108);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


