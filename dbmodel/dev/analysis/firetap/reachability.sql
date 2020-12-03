/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public;

DROP FUNCTION IF EXISTS fct_gw_anl_reachability(character varying, double precision, character varying);

CREATE OR REPLACE FUNCTION fct_gw_anl_reachability()
  RETURNS void AS
$BODY$
DECLARE

    rec_table      record;
    rec_axis       record;
    bus_geom       public.geometry;
    arc_geom       public.geometry;
    link_aux       public.geometry;    
    arc_id_aux     varchar;
    vnode_aux      public.geometry;
    maximum_cost   double precision;
    fraction_aux   double precision;
    arc_aux        public.geometry;
    arc_aux1       public.geometry;
    arc_aux2       public.geometry;
    cost1          double precision;
    cost2          double precision;
    endfraction    double precision;
    

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Hardcoded cost
    SELECT value INTO maximum_cost FROM config_param_text WHERE parameter = 'distance';

    -- delete tables
    DELETE FROM bus_stop_buffer_arc;
    DELETE FROM bus_stop_buffer_node;
    DELETE FROM link;
    DELETE FROM vnode;



    -- Loop for bus stop
    FOR rec_table IN SELECT * FROM bus_stop
    LOOP

            -- Output
            RAISE NOTICE 'Bus stop = %', rec_table.code;

            -- Get gully geometry
            bus_geom := rec_table.geom;

            -- Improved version for curved lines (not perfect!)
            WITH index_query AS
            (
                SELECT ST_Distance(geom, bus_geom) as d, id FROM street_axis ORDER BY geom <-> bus_geom LIMIT 10
            )
            SELECT id INTO arc_id_aux FROM index_query ORDER BY d limit 1;
            
            -- Get arc geometry
            SELECT geom INTO arc_geom FROM street_axis WHERE id = arc_id_aux;

            -- Compute link
            IF arc_geom IS NOT NULL THEN

                -- Link line
                link_aux := ST_ShortestLine(bus_geom, arc_geom);

                -- Line end point
                vnode_aux := ST_EndPoint(link_aux);
               
                -- Insert new vnode
                INSERT INTO vnode VALUES (rec_table.code, arc_id_aux, vnode_aux);
                
                -- Insert new link
                INSERT INTO link VALUES (rec_table.code, link_aux, arc_id_aux, rec_table.code);

                -- Start process
                SELECT * INTO rec_axis FROM street_axis WHERE id = arc_id_aux;
                fraction_aux := ST_LineLocatePoint(ST_LineMerge(rec_axis.geom), vnode_aux);
                arc_aux1 :=   ST_Reverse(ST_LineSubstring(ST_LineMerge(rec_axis.geom), 0.0, fraction_aux));
                arc_aux2 :=   ST_LineSubstring(ST_LineMerge(rec_axis.geom), fraction_aux, 1.0);
                cost1 := 1.0 / rec_axis.coef * rec_axis.length * fraction_aux;
                cost2 := 1.0 / rec_axis.coef * rec_axis.length * (1.0 - fraction_aux);


                -- Whole arc or part
                IF  cost1 < maximum_cost THEN

		    -- Output
		    RAISE NOTICE 'axis_id = %', rec_axis.id;
            
                    INSERT INTO bus_stop_buffer_arc VALUES(DEFAULT, rec_axis.id, arc_aux1, rec_table.code, cost1, 'to_node1');

                    -- Call recursive function weighting with the pipe capacity
                    PERFORM fct_gw_anl_reachability_recursive(rec_axis.node1, cost1, rec_table.code);

                ELSE

                    endfraction = maximum_cost / cost1;
                    arc_aux :=   ST_LineSubstring(arc_aux1, 0.0, endfraction);
                    INSERT INTO bus_stop_buffer_arc VALUES(DEFAULT, rec_axis.id, arc_aux, rec_table.code, maximum_cost, 'to_node1');
                    
                END IF;


                -- Whole arc or part
                DELETE FROM bus_stop_buffer_arc WHERE arc_id = rec_axis.id AND bus_id = rec_table.code AND direction = 'to_node2';
                IF  cost2 < maximum_cost THEN

		    -- Output
		    RAISE NOTICE 'axis_id = %', rec_axis.id;
		    
                    INSERT INTO bus_stop_buffer_arc VALUES(DEFAULT, rec_axis.id, arc_aux2, rec_table.code, cost2, 'to_node2');

                    -- Call recursive function weighting with the pipe capacity
                    PERFORM fct_gw_anl_reachability_recursive(rec_axis.node2, cost2, rec_table.code);

                ELSE

                    endfraction = maximum_cost / cost2;
                    arc_aux :=   ST_LineSubstring(arc_aux2, 0.0, endfraction);

                    INSERT INTO bus_stop_buffer_arc VALUES(DEFAULT, rec_axis.id, arc_aux, rec_table.code, maximum_cost, 'to_node2');
                    
                END IF;

            
            END IF;

    END LOOP;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;