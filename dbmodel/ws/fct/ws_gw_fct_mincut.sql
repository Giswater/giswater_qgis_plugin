
CREATE OR REPLACE FUNCTION ws30.gw_fct_mincut(
    element_id_arg character varying,
    type_element_arg character varying,
    result_id_arg integer)
  RETURNS integer AS
$BODY$
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
    SET search_path = "ws30", public;

    -- Delete previous data from same result_id
    DELETE FROM "anl_mincut_result_node" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_arc" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_valve" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_polygon" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_connec" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_hydrometer" where result_id=result_id_arg; 


    -- Start process
    INSERT INTO anl_mincut_result_valve (result_id, node_id, unaccess, closed, broken, the_geom) 
    SELECT 
    result_id_arg,
    node_id, false::boolean, closed, broken, the_geom
    FROM v_anl_mincut_selected_valve;

    UPDATE anl_mincut_result_valve SET unaccess=true WHERE result_id=result_id_arg AND node_id IN 
    (SELECT node_id FROM anl_mincut_result_valve_unaccess WHERE result_id=result_id_arg);


     -- The element to isolate could be an arc or a node
    IF type_element_arg = 'arc' THEN

        -- Check an existing arc
        SELECT COUNT(*) INTO controlValue FROM v_edit_arc JOIN value_state_type ON state_type=value_state_type.id 
        WHERE (arc_id = element_id_arg) AND (is_operative IS TRUE);
        IF controlValue = 1 THEN

            -- Select public.geometry
            SELECT the_geom INTO arc_aux FROM v_edit_arc WHERE arc_id = element_id_arg;

            -- Insert arc id
            INSERT INTO "anl_mincut_result_arc" (arc_id, the_geom, result_id) VALUES (element_id_arg, arc_aux, result_id_arg);
        
            -- Run for extremes node
            SELECT node_1, node_2 INTO node_1_aux, node_2_aux FROM v_edit_arc WHERE arc_id = element_id_arg;
            RAISE NOTICE 'node_1 %, node_2 %',node_1_aux, node_2_aux ;

            -- Check extreme being a valve
            SELECT COUNT(*) INTO controlValue FROM anl_mincut_result_valve 
            WHERE node_id = node_1_aux AND (unaccess = FALSE) AND (broken  = FALSE) AND (closed = FALSE);
            IF controlValue = 1 THEN

                -- Set proposed valve
                UPDATE anl_mincut_result_valve SET proposed = TRUE WHERE node_id=node_1_aux AND result_id=result_id_arg;
                RAISE NOTICE 'node_1 %',node_1_aux;
                
            ELSE

                -- Compute the tributary area using DFS
                RAISE NOTICE 'node_4 %',node_1_aux;

                PERFORM gw_fct_mincut_engine(node_1_aux, result_id_arg);

            END IF;


            -- Check other extreme being a valve
            SELECT COUNT(*) INTO controlValue FROM anl_mincut_result_valve 
            WHERE node_id = node_2_aux AND (unaccess = FALSE) AND (broken  = FALSE) AND (closed = FALSE);
            IF controlValue = 1 THEN

                -- Check if the valve is already computed
               SELECT node_id INTO exists_id FROM anl_mincut_result_valve 
               WHERE node_id = node_id_arg AND (proposed = TRUE) AND result_id=result_id_arg;

                -- Compute proceed
                IF NOT FOUND THEN

			-- Set proposed valve
			UPDATE anl_mincut_result_valve SET proposed = TRUE 
			WHERE node_id=node_2_aux AND result_id=result_id_arg;
			RAISE NOTICE 'node_2 %',node_2_aux;
       
                END IF;
                
            ELSE
		RAISE NOTICE 'node_3 %',node_2_aux;

                -- Compute the tributary area using DFS
                PERFORM gw_fct_mincut_engine(node_2_aux, result_id_arg);

            END IF;

        -- The arc_id was not found
        ELSE 
            RAISE EXCEPTION 'Nonexistent Arc ID --> %', element_id_arg
            USING HINT = 'Please check your arc table';
        END IF;

    ELSE

        -- Check an existing node
        SELECT COUNT(*) INTO controlValue FROM v_edit_node JOIN value_state_type ON state_type=value_state_type.id  
        WHERE node_id = element_id_arg AND (is_operative IS TRUE);
        IF controlValue = 1 THEN

            -- Compute the tributary area using DFS
            PERFORM gw_fct_mincut_engine(element_id_arg, result_id_arg);

        -- The arc_id was not found
        ELSE 
            RAISE EXCEPTION 'Nonexistent Node ID --> %', node_id_arg
            USING HINT = 'Please check your node table';
        END IF;

    END IF;

    -- Contruct concave hull for included lines
    polygon_aux := ST_Multi(ST_ConcaveHull(ST_Collect(ARRAY(SELECT the_geom FROM anl_mincut_result_arc WHERE result_id=result_id_arg)), 0.80));

    -- Concave hull for not included lines
    polygon_aux2 := ST_Multi(ST_Buffer(ST_Collect(ARRAY(SELECT the_geom FROM v_edit_arc 
    WHERE arc_id NOT IN (SELECT arc_id FROM anl_mincut_result_arc WHERE result_id=result_id_arg) 
    AND ST_Intersects(the_geom, polygon_aux))), 1, 'join=mitre mitre_limit=1.0'));

    --RAISE EXCEPTION 'Polygon = %', polygon_aux2;

    -- Substract
    IF polygon_aux2 IS NOT NULL THEN
        polygon_aux := ST_Multi(ST_Difference(polygon_aux, polygon_aux2));
    ELSE
        polygon_aux := polygon_aux;
    END IF;

    -- Insert into polygon table
    INSERT INTO anl_mincut_result_polygon (polygon_id, the_geom, result_id) 
    VALUES((select nextval('ws30.anl_mincut_result_polygon_polygon_seq'::regclass)),polygon_aux, result_id_arg);

   PERFORM gw_fct_mincut_flowtrace (result_id_arg);

    
    -- Insert into result catalog tables
    -- PERFORM gw_fct_mincut_result_catalog();

   -- PERFORM audit_function(0,310);

   RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;