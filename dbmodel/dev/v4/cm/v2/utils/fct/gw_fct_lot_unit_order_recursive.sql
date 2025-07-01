/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:3147

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_lot_unit_order_recursive (integer);
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_lot_unit_order_recursive (integer, integer,double precision,double precision,double precision );
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_lot_unit_order_recursive(p_node integer, p_areafactor double precision, p_azimuthfactor double precision , p_elevfactor double precision, p_lot integer, p_macro integer) 
RETURNS json AS 
$BODY$

-- fid: 134
/*
SELECT SCHEMA_NAME.gw_fct_lot_unit('{"data":{"parameters":{"isNew":true, "lotId":207, "geomParamUpdate":2}}}');
SELECT SCHEMA_NAME.gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":207, "step":1, "unitBuffer":2}}}')
SELECT SCHEMA_NAME.gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":207, "step":2, "unitBuffer":1}}}')

SELECT * FROM temp_anlgraph order by trace
SELECT text_column, sector_id as unit_id, macrosector_id as macrounit_id FROM temp_table order by addparam::text, id desc
SELECT * from om_visit_lot_x_unit where lot_id = 207

SELECT * from om_visit_lot_x_macrounit where lot_id = 207
SELECT * from om_visit_lot_x_arc where lot_id = 207
*/


DECLARE

rec_table record;
v_fid integer = 134;
v_count integer = 0;
v_log text;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;
		
	-- Check if the node is already computed
	IF (SELECT node_id FROM anl_node WHERE node_id::integer = p_node AND cur_user="current_user"() AND fid = v_fid AND sector_id = p_macro) IS NULL THEN

		-- Update value
		INSERT INTO anl_node (node_id, fid, cur_user, sector_id) VALUES (p_node, v_fid, current_user, p_macro);

		-- look for best candidate. Fisrt step create temp_lot_unit table
		DELETE FROM temp_lot_unit;
		INSERT INTO temp_lot_unit (arc_id, sourcenode, targetnode, nodetype, isprofilesurface, direction, 
		geom1, area, azimuth, sys_elev, f_factor, best_candidate, unit_id, macrounit_id)
		select * from (
		SELECT arc_id, node_1 as sourcenode, node_2 as targetnode, nodetype_2 as nodetype, isprofilesurface, 'DOWNSTREAM' AS direction, 
		cat_geom1 geom1, COALESCE(area,0::FLOAT), st_azimuth(st_startpoint(a.the_geom),st_lineinterpolatepoint(a.the_geom,0.01)) azimuth, sys_elev1, 9 as f_factor, null::boolean 
		as best_candidate, unit_id, macrounit_id FROM v_edit_arc a 
		JOIN cat_feature_node ON nodetype_2 = id 
		JOIN cat_arc c ON c.id = arccat_id 
		JOIN (SELECT arc_id, unit_id, macrounit_id FROM om_visit_lot_x_arc WHERE lot_id = p_lot) z USING (arc_id)
		WHERE node_1::integer = p_node
		UNION ALL
		SELECT arc_id, node_2 , node_1, nodetype_1, isprofilesurface, 'UPSTREAM',
		cat_geom1, COALESCE(area,0::FLOAT), st_azimuth(st_lineinterpolatepoint(a.the_geom,0.99),st_endpoint(a.the_geom)), sys_elev2, 9, null::boolean, unit_id, macrounit_id 
		FROM v_edit_arc a JOIN cat_feature_node ON nodetype_1 = id 
		JOIN cat_arc c ON c.id = arccat_id
		JOIN (SELECT arc_id, unit_id, macrounit_id FROM om_visit_lot_x_arc WHERE lot_id = p_lot)z USING (arc_id)
		WHERE node_2::integer = p_node)a;

		/*
		DELETE FROM temp_lot_unit;
		INSERT INTO temp_lot_unit (arc_id, sourcenode, targetnode, nodetype, isprofilesurface, direction, 
		geom1, area, azimuth, sys_elev, f_factor, best_candidate, macrounit_id)
		select * from (
		SELECT arc_id, node_1 as sourcenode, node_2 as targetnode, nodetype_2 as nodetype, isprofilesurface, 'DOWNSTREAM' AS direction, 
		cat_geom1 geom1, COALESCE(area,0::FLOAT), st_azimuth(st_startpoint(a.the_geom),st_lineinterpolatepoint(a.the_geom,0.01)) azimuth, sys_elev1, 9 as f_factor, null::boolean as best_candidate, macrounit_id
		FROM v_edit_arc a 
		JOIN cat_feature_node ON nodetype_2 = id 
		JOIN cat_arc c ON c.id = arccat_id 
		JOIN (SELECT arc_id, macrounit_id FROM om_visit_lot_x_arc WHERE lot_id = 207) z USING (arc_id)
		WHERE node_1::integer = 16539
		UNION ALL
		SELECT arc_id, node_2 , node_1, nodetype_1, isprofilesurface, 'UPSTREAM',
		cat_geom1, COALESCE(area,0::FLOAT), st_azimuth(st_lineinterpolatepoint(a.the_geom,0.99),st_endpoint(a.the_geom)), sys_elev2, 9, null::boolean, macrounit_id FROM v_edit_arc a 
		JOIN cat_feature_node ON nodetype_1 = id 
		JOIN cat_arc c ON c.id = arccat_id
		JOIN (SELECT arc_id, macrounit_id FROM om_visit_lot_x_arc WHERE lot_id = 207)z USING (arc_id)
		WHERE node_2::integer = 16539)a;
		*/

		-- look for best candidate. Fisrt step calculate the f_factor for each couple
		FOR rec_table IN SELECT * FROM temp_lot_unit
		LOOP 
			UPDATE temp_lot_unit SET f_factor = (p_areafactor*abs(area-COALESCE(rec_table.area,0::FLOAT)))+(p_azimuthfactor*abs(azimuth-rec_table.azimuth))+(p_elevfactor*abs(sys_elev-rec_table.sys_elev)), 
			coupled_arc = rec_table.arc_id
			WHERE (p_areafactor*abs(area-COALESCE(rec_table.area,0::FLOAT)))+(p_azimuthfactor*abs(azimuth-rec_table.azimuth))+(p_elevfactor*abs(sys_elev-rec_table.sys_elev)) < f_factor 
			AND arc_id != rec_table.arc_id;
		END LOOP;

		v_log = (SELECT array_agg(row_to_json(row)) FROM (SELECT arc_id, targetnode as node_1 FROM temp_lot_unit WHERE sourcenode::integer = p_node AND direction = 'UPSTREAM' 
		AND macrounit_id = p_macro ORDER BY f_factor DESC)row);
		raise notice 'v_log %', v_log;

		-- Loop for all the upstream arcs		
		FOR rec_table IN SELECT arc_id, targetnode as node_1, unit_id FROM temp_lot_unit WHERE sourcenode::integer = p_node AND direction = 'UPSTREAM' 
		AND macrounit_id = p_macro ORDER BY f_factor ASC
		LOOP
			RAISE NOTICE 'Flooding to new node - %', p_node;
			v_count = v_count +1;
			
			-- register into temp table
			INSERT INTO temp_table (fid, text_column, sector_id, macrosector_id) VALUES (v_fid, rec_table.arc_id, rec_table.unit_id, p_macro);

			-- Call recursive function weighting with the pipe capacity
			PERFORM gw_fct_lot_unit_order_recursive(rec_table.node_1::integer, p_areafactor, p_azimuthfactor, p_elevfactor, p_lot, p_macro);
		
		END LOOP;
	END IF;

	--Return
	RETURN ('{"status":"ok"}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
