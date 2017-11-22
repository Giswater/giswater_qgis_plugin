/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE OR REPLACE FUNCTION gw_fct_upstream_recursive(
    node_id_arg character varying,
    num_row integer)
  RETURNS double precision AS
$BODY$DECLARE
	first_track_id_var integer = 0;
	area_node double precision = 0.0;
	total_capacity_var double precision;
	arc_capacity double precision;
	rec_table record;
	arc_area double precision = 0.0;
	num_arcs integer;
	num_wet_arcs integer;


BEGIN

SET search_path='SCHEMA_NAME',public;

--	Check if the node is already computed
	SELECT first_track_id INTO first_track_id_var FROM temp_contributing_area WHERE node_id = node_id_arg;

--	First its own area (in Ha!)
	SELECT area INTO area_node FROM subcatchment WHERE node_id = node_id_arg;

--	Check existing subcatchment
	IF (area_node ISNULL) THEN
		area_node = 0.0;
	END IF;

--	Compute area
	IF (first_track_id_var = 0) THEN
	
--		Update value
		UPDATE temp_contributing_area SET first_track_id = num_row WHERE node_id = node_id_arg;
		
--		Loop for all the upstream nodes
		FOR rec_table IN SELECT arc_id, flow, node_1 FROM arc WHERE node_2 = node_id_arg
		LOOP

--			Total capacity of the upstream node
			SELECT total_capacity INTO total_capacity_var FROM temp_contributing_area WHERE node_id = rec_table.node_1;

--			Total number of upstream nodes
			SELECT num_outlet, num_wet_outlet INTO num_arcs, num_wet_arcs FROM node_drain_area WHERE node_id = rec_table.node_1;
			
--			Call recursive function weighting with the pipe capacity
			IF ((total_capacity_var > 0.0) AND (rec_table.flow > 0.0)) THEN
				arc_area = (CAST (num_wet_arcs AS numeric) / CAST (num_arcs AS numeric)) * rec_table.flow * gw_fct_upstream_recursive(rec_table.node_1, num_row) / total_capacity_var;
			ELSE

--				If there is no data divide the flow
				IF (num_arcs > 0) THEN
					arc_area = gw_fct_upstream_recursive(rec_table.node_1, num_row) / num_arcs;
				ELSE
					arc_area = gw_fct_upstream_recursive(rec_table.node_1, num_row);
				END IF;
				
			END IF;
			
--			Update arc area & capacity
			UPDATE arc_drain_area SET area = arc_area WHERE arc_id = rec_table.arc_id;
			UPDATE arc_drain_area SET capacity = rec_table.flow WHERE arc_id = rec_table.arc_id;

--			Total node area			
			area_node := area_node + arc_area;

		END LOOP;

--		Fill node tables
		UPDATE node_drain_area SET area = area_node WHERE node_id = node_id_arg;		

--	Cyclic?
	ELSIF (first_track_id_var = num_row) THEN

--		Get previous result
		SELECT area INTO area_node FROM node_drain_area WHERE node_id = node_id_arg;

--		If the result is 0.0 perhaps is a cycle
		IF (area_node = -1.0) THEN
			UPDATE node_cycles SET cycle_id = num_row WHERE node_id IN (SELECT node_id FROM temp_contributing_area WHERE first_track_id_var =  num_row);
		END IF;


--	Previous result
	ELSE 
		SELECT area INTO area_node FROM node_drain_area WHERE node_id = node_id_arg;
	END IF;

--	Return total area
	RETURN area_node;

		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gw_fct_upstream_recursive(character varying, integer)
  OWNER TO postgres;