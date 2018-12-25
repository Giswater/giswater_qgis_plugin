/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2498



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_visit_event_update_xy()
  RETURNS trigger AS
$BODY$
DECLARE 
	v_node_1 varchar;
	v_node_2 varchar;
	v_the_geom public.geometry;
	v_unitarylength float;
	v_point public.geometry;


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- get the geom
	SELECT node_1, node_2, the_geom INTO v_node_1, v_node_2, v_the_geom FROM arc JOIN om_visit_x_arc ON om_visit_x_arc.arc_id=arc.arc_id 
	JOIN om_visit_event ON om_visit_x_arc.visit_id=om_visit_event.visit_id WHERE om_visit_event.visit_id=NEW.visit_id;

	RAISE NOTICE 'v_node_1 %, v_node_2 %, v_the_geom %', v_node_1, v_node_2, v_the_geom;

	IF v_the_geom IS NOT NULL AND NEW.position_value IS NOT NULL AND NEW.position_id IS NOT NULL THEN 
	
		-- control of the position_value againts arc length
		IF NEW.position_value <0 OR NEW.position_value> ST_length(v_the_geom) THEN
            RETURN audit_function(3012, 2498,NEW.link_id::text); 

		END IF;

		-- control of the position_id againsts arc's node_1 and node_2
		IF NEW.position_id!=v_node_1 AND NEW.position_id!=v_node_2 THEN
            RETURN audit_function(3014,2498,NEW.link_id::text); 
		ELSIF NEW.position_id=v_node_2 THEN
			v_the_geom = ST_reverse(v_the_geom);
		END IF;

		-- get parameter of unitary length
		v_unitarylength=NEW.position_value/(st_length(v_the_geom));
	
		-- get the point
		v_point=ST_LineInterpolatePoint(v_the_geom, v_unitarylength);

		--u pdating coordinates values
		UPDATE om_visit_event SET xcoord=ST_x(v_point),ycoord=ST_y(v_point) WHERE id=NEW.id;
	END IF;

	RETURN NEW;
	
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;