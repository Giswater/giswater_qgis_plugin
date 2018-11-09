/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2308

DROP FUNCTION IF EXISTS gw_fct_mincut_flowtrace(integer);
CREATE OR REPLACE FUNCTION gw_fct_mincut_flowtrace(result_id_arg integer)
RETURNS integer AS
$BODY$
DECLARE
    mincut_rec	   record;
    exists_id      text;
    polygon_aux    public.geometry;
    polygon_aux2   public.geometry;
    node_aux       public.geometry;    
    rec_table      record;
    first_row      boolean;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- starting process
    SELECT * INTO mincut_rec FROM anl_mincut_result_cat WHERE id=result_id_arg;

    -- Delete previous data from same result_id
    DELETE FROM "anl_mincut_result_node" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_arc" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_polygon" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_connec" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_hydrometer" where result_id=result_id_arg; 


    -- Loop for all the inlet nodes
    FOR rec_table IN SELECT v_edit_node.node_id, v_edit_node.the_geom FROM v_edit_node 
    JOIN value_state_type ON state_type=value_state_type.id JOIN node_type ON node_type.id=nodetype_id
    JOIN exploitation ON v_edit_node.expl_id=exploitation.expl_id
    WHERE ( type='TANK' OR type = 'SOURCE') AND (is_operative IS TRUE) AND (macroexpl_id=mincut_rec.macroexpl_id) AND v_edit_node.the_geom IS NOT NULL
    ORDER BY 1
    LOOP
        -- Insert into tables
        SELECT node_id INTO exists_id FROM anl_mincut_result_node WHERE node_id = rec_table.node_id AND result_id=result_id_arg ;
        
        -- Call recursive function weighting with the pipe capacity
        PERFORM gw_fct_mincut_flowtrace_engine(rec_table.node_id, result_id_arg);               
    END LOOP;

    -- Switch selection of node
    first_row = TRUE;
    FOR rec_table IN SELECT node_id, the_geom FROM v_edit_node JOIN value_state_type ON state_type=value_state_type.id 
    WHERE (node_id NOT IN (SELECT node_id FROM anl_mincut_result_node WHERE result_id=result_id_arg)) AND (is_operative IS TRUE) AND the_geom IS NOT NULL
    LOOP
        -- Delete old
        IF first_row THEN
            DELETE FROM anl_mincut_result_node WHERE result_id=result_id_arg;
            first_row = FALSE;
        END IF;
        INSERT INTO anl_mincut_result_node (node_id, the_geom, result_id)  VALUES(rec_table.node_id, rec_table.the_geom, result_id_arg);
    END LOOP; 

    -- Switch selection of arc
    first_row = TRUE;
    FOR rec_table IN SELECT arc_id, the_geom FROM v_edit_arc JOIN value_state_type ON state_type=value_state_type.id
    WHERE (arc_id NOT IN (SELECT arc_id FROM anl_mincut_result_arc WHERE result_id=result_id_arg)) AND (is_operative IS TRUE) AND the_geom IS NOT NULL
    LOOP

        -- Delete old
        IF first_row THEN
            DELETE FROM anl_mincut_result_arc WHERE result_id=result_id_arg;
            first_row = FALSE;
        END IF;

        INSERT INTO anl_mincut_result_arc (arc_id, the_geom, result_id) VALUES(rec_table.arc_id, rec_table.the_geom, result_id_arg);

    END LOOP; 
    
    -- Contruct concave hull for included lines
    polygon_aux := ST_Multi(ST_ConcaveHull(ST_Collect(ARRAY(SELECT the_geom FROM anl_mincut_result_arc WHERE result_id=result_id_arg)), 0.80));

    -- Concave hull for not included lines
    polygon_aux2 := ST_Multi(ST_Buffer(ST_Collect(ARRAY(SELECT the_geom FROM v_edit_arc JOIN value_state_type ON state_type=value_state_type.id
    WHERE arc_id NOT IN (SELECT arc_id FROM anl_mincut_result_arc WHERE result_id=result_id_arg) 
    AND ST_Intersects(the_geom, polygon_aux))), 1, 'join=mitre mitre_limit=1.0'));

    -- Substract
    IF polygon_aux2 IS NOT NULL THEN
        polygon_aux := ST_Multi(ST_Difference(polygon_aux, polygon_aux2));
    ELSE
        polygon_aux := polygon_aux;
    END IF;

    -- Insert into polygon table
    IF geometrytype(polygon_aux)='MULTIPOLYGON' THEN
	INSERT INTO anl_mincut_result_polygon (polygon_id, the_geom, result_id) 
	VALUES((select nextval('anl_mincut_result_polygon_polygon_seq'::regclass)),polygon_aux, result_id_arg);
    ELSE 
	INSERT INTO anl_mincut_result_polygon (polygon_id,  result_id) 
	VALUES((select nextval('anl_mincut_result_polygon_polygon_seq'::regclass)), result_id_arg);
    END IF;
   RETURN 1;


   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;