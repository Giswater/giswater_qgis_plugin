/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public;



DROP FUNCTION fct_gw_anl_reachability_recursive(character varying, double precision, character varying);

CREATE OR REPLACE FUNCTION fct_gw_anl_reachability_recursive(
    node_id_arg character varying,
    cum_cost_arg double precision,
    bus_id_arg character varying)
  RETURNS void AS
$BODY$
DECLARE
    exists_id      character varying;
    rec_table      record;
    rec_table2      record;
    controlValue   integer;
    node_aux       public.geometry;
    arc_aux        public.geometry;
    point_aux      public.geometry;
    endfraction    double precision;
    maximum_cost   double precision;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;


    -- Hardcoded cost
    SELECT value INTO maximum_cost FROM bus_stop_config WHERE parameter = 'distance';


    -- Get node public.geometry
    SELECT geom INTO node_aux FROM nodes WHERE node_id = node_id_arg;


    -- Check if the node is already computed
    SELECT * INTO rec_table2 FROM bus_stop_buffer_node WHERE node_id = node_id_arg AND bus_id = bus_id_arg;


    -- Compute proceed
    IF NOT FOUND THEN

        -- Update value
        INSERT INTO bus_stop_buffer_node VALUES(DEFAULT, node_id_arg, node_aux, bus_id_arg, cum_cost_arg);

    ELSIF rec_table2.cost > cum_cost_arg THEN

        -- Shorter path
        UPDATE bus_stop_buffer_node SET cost = cum_cost_arg WHERE node_id = node_id_arg AND bus_id = bus_id_arg;
        
    ELSE

        RETURN;
    
    END IF;


        -- Loop for all the upstream nodes
        FOR rec_table IN SELECT id AS arc_id, node1 AS node_1, (1.0 / coef * length) AS cost, geom AS the_geom FROM street_axis WHERE node2 = node_id_arg
        LOOP

            -- Insert into tables
            SELECT * INTO rec_table2 FROM bus_stop_buffer_arc WHERE arc_id = rec_table.arc_id AND bus_id = bus_id_arg AND direction = 'to_node1';

            -- Compute proceed
            IF NOT FOUND OR rec_table2.cost > cum_cost_arg THEN

                -- Delete old
                DELETE FROM bus_stop_buffer_arc WHERE arc_id = rec_table.arc_id AND bus_id = bus_id_arg AND direction = 'to_node1';

                -- Whole arc or part
                IF (cum_cost_arg + rec_table.cost) < maximum_cost THEN

                    INSERT INTO bus_stop_buffer_arc VALUES(DEFAULT, rec_table.arc_id, ST_LineMerge(rec_table.the_geom), bus_id_arg, (cum_cost_arg + rec_table.cost), 'to_node1');

                    -- Call recursive function weighting with the pipe capacity
                    PERFORM fct_gw_anl_reachability_recursive(rec_table.node_1, (cum_cost_arg + rec_table.cost), bus_id_arg);

                ELSE

                    endfraction = (maximum_cost - cum_cost_arg) / rec_table.cost;
                    point_aux := ST_LineInterpolatePoint(ST_LineMerge(rec_table.the_geom), endfraction);

                    -- Don't reduce existing streets
                    arc_aux :=   ST_LineSubstring(ST_LineMerge(rec_table.the_geom), (1 - endfraction), 1.0);
                    
                    IF ST_Length(rec_table2.the_geom) > ST_Length(arc_aux) THEN
                        arc_aux := rec_table2.the_geom;
                    END IF;

                    INSERT INTO bus_stop_buffer_arc VALUES(DEFAULT, rec_table.arc_id, arc_aux, bus_id_arg, maximum_cost, 'to_node1');
                    
                END IF;
	    END IF;
		
        END LOOP;

        -- Loop for all the downstream nodes
        FOR rec_table IN SELECT id AS arc_id, node2 AS node_2, (1.0 / coef * length) AS cost, geom AS the_geom FROM street_axis WHERE node1 = node_id_arg
        LOOP

	    -- Insert into tables
            SELECT * INTO rec_table2 FROM bus_stop_buffer_arc WHERE arc_id = rec_table.arc_id AND bus_id = bus_id_arg AND direction = 'to_node2';
 
            -- Compute proceed
	    IF NOT FOUND OR rec_table2.cost > cum_cost_arg THEN

                -- Delete old
	        DELETE FROM bus_stop_buffer_arc WHERE arc_id = rec_table.arc_id AND bus_id = bus_id_arg AND direction = 'to_node2';

                -- Whole arc or part
                IF (cum_cost_arg + rec_table.cost) < maximum_cost THEN
 
                    INSERT INTO bus_stop_buffer_arc VALUES(DEFAULT, rec_table.arc_id, ST_LineMerge(rec_table.the_geom), bus_id_arg, (cum_cost_arg + rec_table.cost), 'to_node2');

                    -- Call recursive function weighting with the pipe capacity
                    PERFORM fct_gw_anl_reachability_recursive(rec_table.node_2, (cum_cost_arg + rec_table.cost), bus_id_arg);

                ELSE

                    endfraction = (maximum_cost - cum_cost_arg) / rec_table.cost;                    
                    point_aux := ST_LineInterpolatePoint(ST_LineMerge(rec_table.the_geom), endfraction);


                    -- Don't reduce existing streets
                    arc_aux :=   ST_LineSubstring(ST_LineMerge(rec_table.the_geom), 0.0, endfraction);
                    
                    IF ST_Length(rec_table2.the_geom) > ST_Length(arc_aux) THEN
                        arc_aux := rec_table2.the_geom;
                    END IF;

                    INSERT INTO bus_stop_buffer_arc VALUES(DEFAULT, rec_table.arc_id, arc_aux, bus_id_arg, maximum_cost, 'to_node2');
                    
                END IF;

            END IF;
            

        END LOOP;


    RETURN;

        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;