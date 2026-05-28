/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
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
	SELECT epsg INTO v_srid FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get input data
	v_result = ((p_data->>'data')::json->>'parameters')::json->>'resultId';

	-- get user variables
	v_nullbuffer = (SELECT ((value::json->>'parameters')::json->>'node')::json->>'nullElevBuffer' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_cerobuffer = (SELECT ((value::json->>'parameters')::json->>'node')::json->>'ceroElevBuffer' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_diameter = (SELECT ((value::json->>'parameters')::json->>'pipe')::json->>'diameter' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_statsmethod = (SELECT ((value::json->>'parameters')::json->>'pipe')::json->>'roughness' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);


	RAISE NOTICE 'setting roughness for null values';
	EXECUTE 'SELECT '||v_statsmethod||'(roughness) FROM temp_t_arc '
	INTO v_roughness;
	UPDATE temp_t_arc SET roughness = v_roughness WHERE roughness IS NULL;

	RAISE NOTICE 'setting diameter for null values';
	UPDATE temp_t_arc SET diameter = v_diameter WHERE diameter IS NULL;

	RAISE NOTICE 'setting null top_elev values using closest points values';
	UPDATE temp_t_node SET top_elev = d.top_elev FROM
		(SELECT c.n1 as node_id, e2 as top_elev FROM (SELECT DISTINCT ON (a.node_id) a.node_id as n1, a.top_elev as e1, a.the_geom as n1_geom, b.node_id as n2, b.top_elev as e2, b.the_geom as n2_geom FROM node a, node b
		WHERE st_dwithin (a.the_geom, b.the_geom, v_nullbuffer) AND a.node_id != b.node_id AND a.top_elev IS NULL AND b.top_elev IS NOT NULL) c order by st_distance (n1_geom, n2_geom))d
		WHERE temp_t_node.top_elev IS NULL AND d.node_id=temp_t_node.node_id;

	RAISE NOTICE 'setting cero top_elev values using closest points values';
	UPDATE temp_t_node SET top_elev = d.top_elev FROM
		(SELECT c.n1 as node_id, e2 as top_elev FROM (SELECT DISTINCT ON (a.node_id) a.node_id as n1, a.top_elev as e1, a.the_geom as n1_geom, b.node_id as n2, b.top_elev as e2, b.the_geom as n2_geom FROM node a, node b
		WHERE st_dwithin (a.the_geom, b.the_geom, v_cerobuffer) AND a.node_id != b.node_id AND a.top_elev = 0 AND b.top_elev > 0) c order by st_distance (n1_geom, n2_geom))d
		WHERE temp_t_node.top_elev IS NULL AND d.node_id=temp_t_node.node_id;

    RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
