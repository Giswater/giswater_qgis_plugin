/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE FUNCTION gw_fct_maxflow_recursive(    node_id_arg character varying,    num_row integer,    intensity double precision,    runoff_coeff double precision)  RETURNS double precision AS
$BODY$

DECLARE
	first_track_id_var integer = 0;
	area_node double precision = 0.0;
	maxflow_node double precision = 0.0;
	total_capacity_var double precision;
	arc_capacity double precision;
	rec_table record;
	arc_maxflow_var double precision = 0.0;
	num_arcs integer;
	num_wet_arcs integer;


BEGIN

SET search_path='SCHEMA_NAME',public;

--	Check if the node is already computed
	SELECT first_track_id INTO first_track_id_var FROM temp_maxflow WHERE node_id = node_id_arg;

--	First its own area (in Ha!)
	SELECT SUM(area) INTO area_node FROM subcatchment WHERE node_id = node_id_arg;

--	Check existing subcatchment
	IF (area_node ISNULL) THEN
		area_node = 0.0;
	END IF;

--	Convert area into flow
	maxflow_node = area_node * runoff_coeff * intensity;


--	Compute area
	IF (first_track_id_var = 0) THEN
	
--		Update tracking value
		UPDATE temp_maxflow SET first_track_id = num_row WHERE node_id = node_id_arg;
		
--		Loop for all the upstream nodes
		FOR rec_table IN SELECT arc_id, flow, node_1 FROM arc WHERE node_2 = node_id_arg
		LOOP

--			Total capacity of the upstream node
			SELECT total_capacity INTO total_capacity_var FROM temp_maxflow WHERE node_id = rec_table.node_1;

--			Total number of upstream nodes
			SELECT num_outlet, num_wet_outlet INTO num_arcs, num_wet_arcs FROM temp_maxflow WHERE node_id = rec_table.node_1;

--			Check flow data availability for the current pipe
			IF ((total_capacity_var > 0.0) AND (rec_table.flow > 0.0)) THEN

--				Check flow availability for the other pipes
				IF ((num_arcs > 1) AND (total_capacity_var <> rec_table.flow)) THEN 
					arc_maxflow_var := (CAST (num_wet_arcs AS numeric) / CAST (num_arcs AS numeric)) * rec_table.flow * gw_fct_maxflow_recursive(rec_table.node_1, num_row, intensity, runoff_coeff) / total_capacity_var;
				ELSIF (num_arcs = 1) THEN
					arc_maxflow_var := rec_table.flow * gw_fct_maxflow_recursive(rec_table.node_1, num_row, intensity, runoff_coeff) / total_capacity_var;
				ELSE
					num_arcs := GREATEST(num_arcs, 1);
					arc_maxflow_var = gw_fct_maxflow_recursive(rec_table.node_1, num_row, intensity, runoff_coeff) / num_arcs;
				END IF;
			ELSE

--				If there is no data divide the flow
				IF (num_arcs > 0) THEN
					arc_maxflow_var = gw_fct_maxflow_recursive(rec_table.node_1, num_row, intensity, runoff_coeff) / num_arcs;
				ELSE
					arc_maxflow_var = gw_fct_maxflow_recursive(rec_table.node_1, num_row, intensity, runoff_coeff);
				END IF;
				
			END IF;

--			Max flow is limited by arc capacity
			IF (rec_table.flow > 0) THEN 
				arc_maxflow_var := LEAST(arc_maxflow_var, rec_table.flow);
			END IF;

--			Update arc area
			UPDATE arc_maxflow SET maxflow = arc_maxflow_var WHERE arc_id = rec_table.arc_id;

--			Total node area			
			maxflow_node := maxflow_node + arc_maxflow_var;

		END LOOP;
		
--		Fill node tables
		UPDATE temp_maxflow SET maxflow = maxflow_node WHERE node_id = node_id_arg;		

--	Cyclic!
	ELSIF (first_track_id_var = num_row) THEN

		SELECT maxflow INTO maxflow_node FROM temp_maxflow WHERE node_id = node_id_arg;

--	Previous result
	ELSE 
		SELECT maxflow INTO maxflow_node FROM temp_maxflow WHERE node_id = node_id_arg;
	END IF;

--	Return total area
	RETURN maxflow_node;

		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;