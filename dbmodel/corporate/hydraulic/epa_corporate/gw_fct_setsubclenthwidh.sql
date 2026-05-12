/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setsubclenthwidth(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setsubclenthwidth(p_data json)
RETURNS json AS
$BODY$

/*

-- to execute
SELECT gw_fct_setsubclenthwidth('{"data":{"parameters":{}}}');

UPDATE ve_inp_subcatchment set width =null, clength = null
select * from ve_inp_subcatchment

*/

DECLARE

v_result text;
v_result_info json;
v_version text;
v_error_context text;
v_fid integer = 489;
v_arcs integer;
v_nodes integer;


BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- getting system parameters
	v_version = (SELECT giswater from sys_version order by date desc limit 1);

	-- getting parameter from function
	v_result = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'resultId');
	
			
	 UPDATE ve_inp_subcatchment t
	    SET
	        "clength" = CASE
	            -- Rectangle equivalent
	            WHEN d.disc >= 0 THEN (d.s + sqrt(d.disc)) / 2.0
	            -- Cercle equivalent → r
	            ELSE sqrt(d.area_val / pi())
	        END,
	        "width" = CASE
	            -- Rectangle equivalent
	            WHEN d.disc >= 0 THEN (d.s - sqrt(d.disc)) / 2.0
	            -- Cercle equivalent → 2r
	            ELSE 2.0 * sqrt(d.area_val / pi())
	        END
	    FROM (
	        SELECT
	            "subc_id",
	            "hydrology_id",
	            ST_Area("the_geom") AS area_val,
	            ST_Perimeter("the_geom") AS perim_val,
	            ST_Perimeter("the_geom") / 2.0 AS s,
	            (ST_Perimeter("the_geom") / 2.0)^2
	              - 4.0 * ST_Area("the_geom") AS disc
	        FROM ve_inp_subcatchment
	        WHERE "the_geom" IS NOT NULL
	    ) d
	    WHERE t."subc_id" = d."subc_id"
	      AND t."hydrology_id" = d."hydrology_id";

	-- get log
	INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, 'INFO: Process have been executed');
	INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, concat('INFO: ', v_nodes, ' rows on nodes result table (rpt_node) have been imported from production enviroment'));
	INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, concat('INFO: ', v_arcs, ' rows on arc result table (rpt_arc) have been imported from production enviroment'));

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid IN (v_fid) order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"values":',v_result, '}');
	
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
		
	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":""}, "version":"'||v_version||'"'||',"body":{"form":{}, "data":{"info":'||v_result_info||'}}}')::json;


	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


  grant all on all functions in schema SCHEMA_NAME to role_basic;