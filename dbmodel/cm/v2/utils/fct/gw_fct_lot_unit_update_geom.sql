/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3149

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_lot_unit_update_geom(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_lot_unit_update_geom(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
EXAMPLE
-------
SELECT SCHEMA_NAME.gw_fct_lot_unit_update_geom('{"data":{"parameters":{"lotId":"1031", "nodeBuffer":"2", "arcBuffer":"2", "linkBuffer":"1"}}}')

DETAIL
-------
function to update geometry of selected UM
*/

DECLARE

v_error_context text;
v_lot integer;
v_arcbuffer float;
v_linkbuffer float;
v_nodebuffer float;


BEGIN

	-- Search path
	SET search_path = SCHEMA_NAME, public;

	-- get variables
	v_lot = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'lotId');
	v_arcbuffer = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'arcBuffer');
	v_linkbuffer = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'linkBuffer');
	v_nodebuffer = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'nodeBuffer');

	-- setting values in case of null values for input parameters
	IF v_arcbuffer IS NULL THEN v_arcbuffer = (SELECT value::json->>'arcBuffer' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;
	IF v_linkbuffer IS NULL THEN v_linkbuffer = (SELECT value::json->>'linkBuffer' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;
	IF v_nodebuffer IS NULL THEN v_nodebuffer = (SELECT value::json->>'nodeBuffer' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;

	-- update geometries for units from gullies (orphan and not orphan)
	UPDATE om_visit_lot_x_unit u SET the_geom = a.geom FROM (
		SELECT unit_id, st_multi(st_buffer(st_collect(link.the_geom),v_linkbuffer)) 
		as geom FROM v_edit_link link
		JOIN gully on gully_id = feature_id
		JOIN om_visit_lot_x_gully USING (gully_id)
		WHERE lot_id=v_lot
		group by unit_id::integer)a	
	WHERE u.unit_id=a.unit_id;

	-- update geometries for units from orphan nodes
	UPDATE om_visit_lot_x_unit u SET the_geom = a.geom FROM
		(SELECT unit_id, ST_Multi(st_buffer(st_collect(geom),0.01)) as geom FROM
		(SELECT unit_id, ST_Multi((st_buffer(st_collect(the_geom),v_nodebuffer))) as geom 
		from om_visit_lot_x_node 
		JOIN v_edit_node USING (node_id) 
		WHERE lot_id=v_lot AND source='ORPHAN' group by unit_id::integer)a
		group by unit_id)a
	WHERE u.unit_id=a.unit_id;

	-- update geometries for units from arcs
	UPDATE om_visit_lot_x_unit u SET the_geom = a.geom FROM
		(SELECT unit_id, ST_Multi(st_buffer(st_collect(geom),0.01)) as geom FROM
		(SELECT unit_id, ST_Multi((st_buffer(st_collect(the_geom),v_arcbuffer))) as geom 
		from om_visit_lot_x_arc 
		JOIN v_edit_arc USING (arc_id) 
		WHERE lot_id=v_lot group by unit_id::integer)a
		group by unit_id)a
	WHERE u.unit_id=a.unit_id;

	-- update arc length
	UPDATE om_visit_lot_x_arc l
	SET length = gis_length::numeric(12,2)
	FROM v_edit_arc a
	WHERE l.arc_id = a.arc_id AND lot_id = v_lot ;

	-- update link length	
	UPDATE om_visit_lot_x_gully l
	SET length = gis_length::numeric(12,2)
	FROM v_edit_link a
	WHERE l.gully_id = a.feature_id AND feature_type='GULLY';

	-- update unit length
	UPDATE om_visit_lot_x_unit u
	SET length = a.length::numeric(12,2)
	FROM (SELECT unit_id, (sum(length))::numeric(12,2) as length FROM om_visit_lot_x_arc WHERE lot_id = v_lot GROUP by unit_id)a
	WHERE u.unit_id = a.unit_id;

	UPDATE om_visit_lot_x_unit u
	SET length = a.length::numeric(12,2)
	FROM (SELECT unit_id, (sum(length))::numeric(12,2) as length FROM om_visit_lot_x_gully WHERE lot_id = v_lot GROUP by unit_id)a
	WHERE u.unit_id = a.unit_id;

	UPDATE om_visit_lot_x_unit SET length = 0 WHERE length is null;
	
	-- Return
	RETURN ('{"status":"Accepted"}');

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$function$
;