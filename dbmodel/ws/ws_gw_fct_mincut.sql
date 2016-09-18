/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_mincut(character varying, character varying);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_mincut(element_id_arg character varying, type_element_arg character varying) RETURNS integer AS $BODY$
DECLARE
    node_1_aux		text;
    node_2_aux		text;
    controlValue	integer;
    exists_id		text;
    polygon_aux		public.geometry;
    polygon_aux2	public.geometry;
    arc_aux         public.geometry;
    node_aux        public.geometry;    
    srid_schema		text;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    DELETE FROM "anl_mincut_node";
    DELETE FROM "anl_mincut_arc";
    DELETE FROM "anl_mincut_valve";
    DELETE FROM "anl_mincut_polygon";

     -- The element to isolate could be an arc or a node
    IF type_element_arg = 'arc' THEN

        -- Check an existing arc
        SELECT COUNT(*) INTO controlValue FROM arc WHERE arc_id = element_id_arg;
        IF controlValue = 1 THEN

            -- Select public.geometry
            SELECT the_geom INTO arc_aux FROM arc WHERE arc_id = element_id_arg;

            -- Insert arc id
            INSERT INTO "anl_mincut_arc" VALUES(element_id_arg, arc_aux);
        
            -- Run for extremes node
            SELECT node_1, node_2 INTO node_1_aux, node_2_aux FROM arc WHERE arc_id = element_id_arg;

            -- Check extreme being a valve
            SELECT COUNT(*) INTO controlValue FROM v_edit_valve WHERE node_id = node_1_aux AND (acessibility = TRUE) AND (broken  = FALSE);
            IF controlValue = 1 THEN

                -- Select public.geometry
                SELECT the_geom INTO node_aux FROM node WHERE node_id = node_1_aux;

                -- Insert valve id
                INSERT INTO anl_mincut_valve VALUES(node_1_aux, node_aux);
                
            ELSE

                -- Compute the tributary area using DFS
                PERFORM gw_fct_mincut_recursive(node_1_aux);

            END IF;


            -- Check other extreme being a valve
            SELECT COUNT(*) INTO controlValue FROM v_edit_valve WHERE node_id = node_2_aux AND (acessibility = FALSE) AND (broken  = FALSE);
            IF controlValue = 1 THEN

                -- Check if the valve is already computed
                SELECT valve_id INTO exists_id FROM anl_mincut_valve WHERE valve_id = node_2_aux;

                -- Compute proceed
                IF NOT FOUND THEN

                    -- Select public.geometry
                    SELECT the_geom INTO node_aux FROM node WHERE node_id = node_2_aux;

                    -- Insert valve id
                    INSERT INTO anl_mincut_valve VALUES(node_2_aux, node_aux);

                END IF;
                
            ELSE

                -- Compute the tributary area using DFS
                PERFORM gw_fct_mincut_recursive(node_2_aux);

            END IF;

        -- The arc_id was not found
        ELSE 
            RAISE EXCEPTION 'Nonexistent Arc ID --> %', element_id_arg
            USING HINT = 'Please check your arc table';
        END IF;

    ELSE

        -- Check an existing node
        SELECT COUNT(*) INTO controlValue FROM node WHERE node_id = element_id_arg;
        IF controlValue = 1 THEN

            -- Compute the tributary area using DFS
            PERFORM gw_fct_mincut_recursive(element_id_arg);

        -- The arc_id was not found
        ELSE 
            RAISE EXCEPTION 'Nonexistent Node ID --> %', node_id_arg
            USING HINT = 'Please check your node table';
        END IF;

    END IF;

    -- Contruct concave hull for included lines
    polygon_aux := ST_Multi(ST_ConcaveHull(ST_Collect(ARRAY(SELECT the_geom FROM anl_mincut_arc)), 0.80));

    -- Concave hull for not included lines
    polygon_aux2 := ST_Multi(ST_Buffer(ST_Collect(ARRAY(SELECT the_geom FROM arc WHERE arc_id NOT IN (SELECT a.arc_id FROM anl_mincut_arc AS a) AND ST_Intersects(the_geom, polygon_aux))), 10, 'join=mitre mitre_limit=1.0'));

    --RAISE EXCEPTION 'Polygon = %', polygon_aux2;

    -- Substract
    IF polygon_aux2 IS NOT NULL THEN
        polygon_aux := ST_Multi(ST_Difference(polygon_aux, polygon_aux2));
    ELSE
        polygon_aux := polygon_aux;
    END IF;

    -- Insert into polygon table
    DELETE FROM anl_mincut_polygon WHERE polygon_id = '1';
    INSERT INTO anl_mincut_polygon VALUES('1',polygon_aux);

    -- Insert into result catalog tables
    PERFORM gw_fct_mincut_result_catalog();

    RETURN audit_function(0,310);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

