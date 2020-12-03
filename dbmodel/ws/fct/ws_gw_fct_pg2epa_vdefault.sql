/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2846

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_vdefault(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_vdefault(p_data json)
RETURNS integer 
AS $BODY$

/*example

*/

DECLARE
v_roughness float = 0;
v_x float;
v_y float;
v_geom_point public.geometry;
v_geom_line public.geometry;
v_srid int2;
v_nullbuffer float;
v_cerobuffer float;
v_diameter float;
v_demandtype int2;
v_statsmethod text;
v_result text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get values
	SELECT epsg INTO v_srid FROM sys_version LIMIT 1;
	
	-- get input data
	v_result = ((p_data->>'data')::json->>'parameters')::json->>'resultId';

	-- get user variables
	v_nullbuffer = (SELECT ((value::json->>'parameters')::json->>'node')::json->>'nullElevBuffer' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_cerobuffer = (SELECT ((value::json->>'parameters')::json->>'node')::json->>'ceroElevBuffer' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_diameter = (SELECT ((value::json->>'parameters')::json->>'pipe')::json->>'diameter' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_statsmethod = (SELECT ((value::json->>'parameters')::json->>'pipe')::json->>'roughness' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);

	raise notice ' % % % %',v_nullbuffer,v_cerobuffer,v_diameter,v_statsmethod;

	RAISE NOTICE 'setting roughness for null values';
	EXECUTE 'SELECT '||v_statsmethod||'(roughness) FROM temp_arc '
	INTO v_roughness;
	UPDATE temp_arc SET roughness = v_roughness WHERE roughness IS NULL;

	RAISE NOTICE 'setting diameter for null values';
	UPDATE temp_arc SET diameter = v_diameter WHERE diameter IS NULL;

	RAISE NOTICE 'setting null elevation values using closest points values';
	UPDATE temp_node SET elevation = d.elevation FROM
		(SELECT c.n1 as node_id, e2 as elevation FROM (SELECT DISTINCT ON (a.node_id) a.node_id as n1, a.elevation as e1, a.the_geom as n1_geom, b.node_id as n2, b.elevation as e2, b.the_geom as n2_geom FROM node a, node b 
		WHERE st_dwithin (a.the_geom, b.the_geom, v_nullbuffer) AND a.node_id != b.node_id AND a.elevation IS NULL AND b.elevation IS NOT NULL) c order by st_distance (n1_geom, n2_geom))d
		WHERE temp_node.elevation IS NULL AND d.node_id=temp_node.node_id;

	RAISE NOTICE 'setting cero elevation values using closest points values';
	UPDATE temp_node SET elevation = d.elevation FROM
		(SELECT c.n1 as node_id, e2 as elevation FROM (SELECT DISTINCT ON (a.node_id) a.node_id as n1, a.elevation as e1, a.the_geom as n1_geom, b.node_id as n2, b.elevation as e2, b.the_geom as n2_geom FROM node a, node b 
		WHERE st_dwithin (a.the_geom, b.the_geom, v_cerobuffer) AND a.node_id != b.node_id AND a.elevation = 0 AND b.elevation > 0) c order by st_distance (n1_geom, n2_geom))d
		WHERE temp_node.elevation IS NULL AND d.node_id=temp_node.node_id;

    RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
