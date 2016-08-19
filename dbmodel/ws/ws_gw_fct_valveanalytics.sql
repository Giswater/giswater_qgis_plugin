/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_valveanalytics() RETURNS "pg_catalog"."int4" AS $BODY$
DECLARE

    exists_id      text;
    polygon_aux    public.geometry;
    polygon_aux2   public.geometry;
    node_aux       public.geometry;    
    rec_table      record;
    first_row      boolean;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    DELETE FROM "anl_mincut_node";
    DELETE FROM "anl_mincut_arc";
    DELETE FROM "anl_mincut_valve";
    DELETE FROM "anl_mincut_polygon";


    -- Loop for all the inlet nodes
    FOR rec_table IN SELECT node_id, the_geom FROM node WHERE epa_type = 'TANK' OR epa_type = 'RESERVOIR'
    LOOP

        -- Insert into tables
        SELECT node_id INTO exists_id FROM anl_mincut_node WHERE node_id = rec_table.node_id;

        -- Call recursive function weighting with the pipe capacity
        PERFORM gw_fct_valveanalytics_recursive(rec_table.node_id);
                
    END LOOP;

    -- Switch selection of node
    first_row = TRUE;
    FOR rec_table IN SELECT node_id, the_geom FROM node WHERE node_id NOT IN (SELECT node_id FROM anl_mincut_node)
    LOOP
    
        -- Delete old
        IF first_row THEN
            DELETE FROM anl_mincut_node;
            first_row = FALSE;
        END IF;
        INSERT INTO anl_mincut_node VALUES(rec_table.node_id, rec_table.the_geom);
        
    END LOOP; 

    -- Switch selection of arc
    first_row = TRUE;
    FOR rec_table IN SELECT arc_id, the_geom FROM arc WHERE arc_id NOT IN (SELECT arc_id FROM anl_mincut_arc)
    LOOP

        -- Delete old
        IF first_row THEN
            DELETE FROM anl_mincut_arc;
            first_row = FALSE;
        END IF;

        INSERT INTO anl_mincut_arc VALUES(rec_table.arc_id, rec_table.the_geom);

    END LOOP; 
    
    -- Contruct concave hull for included lines
    polygon_aux := ST_Multi(ST_ConcaveHull(ST_Collect(ARRAY(SELECT the_geom FROM anl_mincut_arc)), 0.80));

    -- Concave hull for not included lines
    polygon_aux2 := ST_Multi(ST_Buffer(ST_Collect(ARRAY(SELECT the_geom FROM arc WHERE arc_id NOT IN (SELECT a.arc_id FROM anl_mincut_arc AS a) AND ST_Intersects(the_geom, polygon_aux))), 10, 'join=mitre mitre_limit=1.0'));
    
    -- Substract
    IF polygon_aux2 IS NOT NULL THEN
        polygon_aux := ST_Multi(ST_Difference(polygon_aux, polygon_aux2));
    ELSE
        polygon_aux := polygon_aux;
    END IF;

    -- Insert into polygon table
    DELETE FROM anl_mincut_polygon WHERE polygon_id = '1';
    INSERT INTO anl_mincut_polygon VALUES('1',polygon_aux);

    RETURN 0;
	RETURN SCHEMA_NAME.audit_function(0,320);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

