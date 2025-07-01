/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3137

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_lot_unit_recursive(p_node integer, p_trace integer, p_sourcenode integer, p_areafactor double precision, 
p_azimuthfactor double precision , p_elevfactor double precision, p_arc integer)  
RETURNS json AS 
$BODY$


DECLARE

v_version text;
rec_table record;
v_return json;
v_count integer = 0;
v_trace integer;
rec_upstream record;
v_bestarc integer;
v_bestnode integer;
v_isprofilesurface boolean;

BEGIN
	-- Search path
	SET search_path = SCHEMA_NAME, public;
	    
	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	    
	raise notice 'node %, trace %, source % arc %', p_node, p_trace, p_sourcenode, p_arc;

	-- look for best candidate
	DELETE FROM temp_lot_unit;
	INSERT INTO temp_lot_unit (arc_id, sourcenode, targetnode, nodetype, isprofilesurface, direction, 
	geom1, area, azimuth, sys_elev, f_factor, best_candidate)
	select * from (
	SELECT arc_id, p_sourcenode, node_2 as targetnode, nodetype_2 as nodetype, isprofilesurface, 'DOWNSTREAM' AS direction, 
	cat_geom1 geom1, COALESCE(area,0::FLOAT), st_azimuth(st_startpoint(a.the_geom),st_lineinterpolatepoint(a.the_geom,0.01)) azimuth, sys_elev1, 9, null::boolean FROM v_edit_arc a 
	JOIN cat_feature_node ON nodetype_2 = id 
	JOIN cat_arc c ON c.id = arccat_id 
	JOIN (SELECT arc_id FROM temp_anlgraph)z USING (arc_id)
	WHERE node_1::integer = p_node
	UNION ALL
	SELECT arc_id, p_sourcenode, node_1, nodetype_1, isprofilesurface, 'UPSTREAM',
	cat_geom1, COALESCE(area,0::FLOAT), st_azimuth(st_lineinterpolatepoint(a.the_geom,0.99),st_endpoint(a.the_geom)), sys_elev2, 9, null::boolean FROM v_edit_arc a 
	JOIN cat_feature_node ON nodetype_1 = id 
	JOIN cat_arc c ON c.id = arccat_id
	JOIN (SELECT arc_id FROM temp_anlgraph)z USING (arc_id)
	WHERE node_2::integer = p_node)a;

	FOR rec_table IN SELECT * FROM temp_lot_unit
	LOOP 
		UPDATE temp_lot_unit SET f_factor = (p_areafactor*abs(area-COALESCE(rec_table.area,0::FLOAT)))+(p_azimuthfactor*abs(azimuth-rec_table.azimuth))+(p_elevfactor*abs(sys_elev-rec_table.sys_elev)), coupled_arc = rec_table.arc_id
		WHERE (p_areafactor*abs(area-COALESCE(rec_table.area,0::FLOAT)))+(p_azimuthfactor*abs(azimuth-rec_table.azimuth))+(p_elevfactor*abs(sys_elev-rec_table.sys_elev)) < f_factor 
		AND arc_id != rec_table.arc_id;
	END LOOP;

	-- set best couple candidate on the intersection
	UPDATE temp_lot_unit SET best_candidate = true WHERE arc_id IN (SELECT arc_id FROM temp_lot_unit ORDER BY f_factor ASC limit 2);

	-- if source is best candidate or initial call
	IF (SELECT best_candidate FROM temp_lot_unit WHERE sourcenode = targetnode LIMIT 1) IS TRUE OR p_node = p_sourcenode THEN

		IF p_node != p_sourcenode THEN
			SELECT arc_id::integer, targetnode::integer, isprofilesurface INTO v_bestarc, v_bestnode, v_isprofilesurface
			FROM temp_lot_unit 
			JOIN temp_anlgraph USING (arc_id)
			WHERE best_candidate = TRUE AND direction ='UPSTREAM' AND targetnode != sourcenode
			AND water = 0;
		ELSE
			v_bestarc = p_arc;
			v_bestnode = (SELECT node_1 FROM arc WHERE arc_id = v_bestarc::text);
			v_isprofilesurface = (SELECT isprofilesurface FROM node JOIN cat_feature_node ON node_type = id WHERE node_id  = v_bestnode::text);
		END IF;

		raise notice '-> BEST CANDIDATE ARC: % NODE TARGET: %', v_bestarc, v_bestnode;
		UPDATE temp_anlgraph SET water = 1, trace = p_trace WHERE arc_id  = v_bestarc::text;
		UPDATE temp_anlgraph SET orderby = (SELECT sum(water) FROM temp_anlgraph) WHERE arc_id  = v_bestarc::text;
		
		-- call recursive
		IF v_bestnode IS NOT NULL AND v_isprofilesurface IS FALSE THEN
			PERFORM gw_fct_lot_unit_recursive(v_bestnode, p_trace, p_node, p_areafactor, p_azimuthfactor, p_elevfactor, p_trace);
		END IF;
	END IF;

	--  Return
	RETURN ('{"rec_table":"a"}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

