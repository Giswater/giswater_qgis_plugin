/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_moveconnec(p_data json)
RETURNS json AS

$BODY$
/*
SELECT gw_fct_moveconnec ($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"connecId":"114466"}, "data":{"distance":1}}$$);


 
*/

DECLARE

p_action text;

v_srid integer;
v_geom0 public.geometry;
v_geom1 public.geometry;
v_geom2 public.geometry;
v_distance01 float;
v_distance02 float;
v_distance12 float;
v_distance012 float;
v_proportion1 float;
v_proportion2 float;
v_top0 float;
v_top1 float;
v_top2 float;
v_elev1 float;
v_elev2 float;
v_elev0 float;
v_top json;
v_elev json;
v_ang210 float;
v_ang120 float;
v_ymax json;
v_version text;
v_project text;
v_depth1 float;
v_depth2 float;

p_x float;
p_y float;
p_node1 text;
p_node2 text;

v_result text;
v_result_info json;
v_result_point json;
v_result_polygon json;
v_result_line json;
v_result_fields text;
v_result_ymax text;
v_result_top text;
v_result_elev text;
v_error_context text;

v_value json;
v_top_status boolean;
v_elev_status boolean;
v_ymax_status boolean;

v_col_top text;
v_col_ymax text;
v_col_elev text; 

v_node text;
v_querytext text;


BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get system variables
	SELECT  giswater, upper(project_type) INTO v_version, v_project FROM sys_version order by id desc limit 1;
	v_srid = (SELECT epsg FROM sys_version limit 1);

	-- get parameters
	v_connec = (((p_data ->>'feature')::json->>'connecId'));
	v_distance =


	-- get arcid (a partir de una interseccio espaial amb connec)
	v_arc = 


	-- si arcid es punto final o punto iniicla. para saberlo, tengo q saber si el node que té a sobre és un node_1 o node_"

		-- getnode (a partir de una intersecció espaial amb node)
		v_node = 
		-- quan tinguis el node -> ja saps is estas inici o final (node_1, node_2)

	-- get azimut
	si final
		v_azimut: (select st_azimuth(st_endpoint(arc.the_geom), ST_LineInterpolatePoint(arc.the_geom,0.999)) from ws36006.arc where arc_id = v_arc);
	si inici
		v_azac aseselect st_azimuth(+(arc.the_geom), ST_LineInterpolatePoint(arc.the_geom,0.001)) from ws36006.arc where arc_id = '2094'

	
	-- getting new coordinates
	x1 = st_x(the_geom)- sin(v_azimut)*distance from node WHERE node_id = v_ node;
	y1 = 

	-- getting new the_geom form connec
	v_new_the_geom

	-- applying new the_geom form connec
	UPDATE connec set the_geom = v_new_the_geom WHERE connec_id = v_connec;
	
	
	-- Control NULL's
	v_version:=COALESCE(v_version,'{}');
	v_result_info:=COALESCE(v_result_info,'{}');
	v_result_point:=COALESCE(v_result_point,'{}');
	v_result_line:=COALESCE(v_result_line,'{}');
	v_result_polygon:=COALESCE(v_result_polygon,'{}');
	v_result_fields:=COALESCE(v_result_fields,'{}');


	--return definition for v_audit_check_result
	RETURN  ('{"status":"Accepted", "message":{"level":1, "text":"Node interpolation done successfully"}, "version":"'||v_version||'"'||
		     ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||','||
					'"point":'||v_result_point||','||
					'"line":'||v_result_line||','||
					'"polygon":'||v_result_polygon||','||
					'"fields":'||v_result_fields||'}'||
			      '}}');

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;  
	RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "message":{"level":'||to_json(right(SQLSTATE, 1))||', "text":"'||to_json(SQLERRM)||'"},"SQLCONTEXT":' || to_json(v_error_context) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
