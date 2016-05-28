CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_mincut(IN element_id_arg character varying, IN type_element_arg character varying) RETURNS "pg_catalog"."int4" AS $BODY$
DECLARE
    node_1_aux		text;
    node_2_aux		text;
    controlValue	integer;
    exists_id		text;
    polygon_aux		geometry;
    polygon_aux2	geometry;
    srid_schema		text;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Create the temporal table for computing nodes        
    CREATE TABLE IF NOT EXISTS temp_mincut_node (
        node_id character varying(16) NOT NULL,
        -- Force indexed column (for performance)
        CONSTRAINT temp_mincut_node_pkey PRIMARY KEY (node_id)
    );
    DELETE FROM temp_mincut_node;

    -- Create the temporal table for computing pipes
    CREATE TABLE IF NOT EXISTS temp_mincut_arc (
        arc_id character varying(16) NOT NULL,
        -- Force indexed column (for performance)
        CONSTRAINT temp_mincut_arc_pkey PRIMARY KEY (arc_id)
    );
    DELETE FROM temp_mincut_arc;
   

    -- Create the temporal table for computing valves
    CREATE TABLE IF NOT EXISTS temp_mincut_valve (
        valve_id character varying(16) NOT NULL,
        -- Force indexed column (for performance)
        CONSTRAINT temp_mincut_valve_pkey PRIMARY KEY (valve_id)
    );
    DELETE FROM temp_mincut_valve;
       
    -- Create the temporal table to store polygon, the table should copy the SRID
    srid_schema := find_srid('SCHEMA_NAME', 'arc', 'the_geom')::text;
    EXECUTE format('
	CREATE TABLE IF NOT EXISTS SCHEMA_NAME.mincut_polygon (
		polygon_id character varying(16) NOT NULL,
		the_geom geometry(MULTIPOLYGON,%s),
		CONSTRAINT mincut_polygon_pkey PRIMARY KEY (polygon_id)
	)'
    ,srid_schema);


     -- The element to isolate could be an arc or a node
    IF type_element_arg = 'arc' THEN

        -- Check an existing arc
        SELECT COUNT(*) INTO controlValue FROM arc WHERE arc_id = element_id_arg;
        IF controlValue = 1 THEN

            -- Insert arc id
            INSERT INTO temp_mincut_arc VALUES(element_id_arg);
        
            -- Run for extremes node
            SELECT node_1, node_2 INTO node_1_aux, node_2_aux FROM arc WHERE arc_id = element_id_arg;

            -- Check extreme being a valve
            SELECT COUNT(*) INTO controlValue FROM v_valve WHERE node_id = node_1_aux AND (acessibility = FALSE) AND (broken  = FALSE);
            IF controlValue = 1 THEN

                -- Insert valve id
                INSERT INTO temp_mincut_valve VALUES(node_1_aux);
                
            ELSE

                -- Compute the tributary area using DFS
                PERFORM gw_fct_mincut_recursive(node_1_aux);

            END IF;


            -- Check other extreme being a valve
            SELECT COUNT(*) INTO controlValue FROM v_valve WHERE node_id = node_2_aux AND (acessibility = FALSE) AND (broken  = FALSE);
            IF controlValue = 1 THEN

                -- Check if the valve is already computed
                SELECT valve_id INTO exists_id FROM temp_mincut_valve WHERE valve_id = node_2_aux;

                -- Compute proceed
                IF NOT FOUND THEN

                    -- Insert valve id
                    INSERT INTO temp_mincut_valve VALUES(node_2_aux);

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
    polygon_aux := ST_Multi(ST_ConcaveHull(ST_Collect(ARRAY(SELECT a.the_geom FROM arc AS a, temp_mincut_arc AS b WHERE a.arc_id = b.arc_id)), 0.80));

    -- Concave hull for not included lines
--    polygon_aux2 := ST_Multi(ST_ConcaveHull(ST_Collect(ARRAY(SELECT the_geom FROM arc WHERE arc_id NOT IN (SELECT a.arc_id FROM temp_mincut_arc AS a) AND ST_Intersects(the_geom, polygon_aux))), 0.80));
    polygon_aux2 := ST_Multi(ST_Buffer(ST_Collect(ARRAY(SELECT the_geom FROM arc WHERE arc_id NOT IN (SELECT a.arc_id FROM temp_mincut_arc AS a) AND ST_Intersects(the_geom, polygon_aux))), 10, 'join=mitre mitre_limit=1.0'));


    -- Substract
    polygon_aux := ST_Multi(ST_Difference(polygon_aux, polygon_aux2));

    -- Insert into polygon table
    DELETE FROM mincut_polygon WHERE polygon_id = '1';
    INSERT INTO mincut_polygon VALUES('1',polygon_aux);

    RETURN 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



  

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_mincut_recursive(node_id_arg character varying) RETURNS void AS $BODY$
DECLARE
    exists_id character varying;
    rec_table record;
    controlValue integer;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Check node being a valve
    SELECT node_id INTO exists_id FROM v_valve WHERE node_id = node_id_arg AND (acessibility = FALSE) AND (broken  = FALSE);
    IF FOUND THEN

        -- Check if the node is already computed
        SELECT valve_id INTO exists_id FROM temp_mincut_valve WHERE valve_id = node_id_arg;

        -- Compute proceed
        IF NOT FOUND THEN

            -- Insert valve id
            INSERT INTO temp_mincut_valve VALUES(node_id_arg);

        END IF;

    ELSE

        -- Check if the node is already computed
        SELECT node_id INTO exists_id FROM temp_mincut_node WHERE node_id = node_id_arg;

        -- Compute proceed
        IF NOT FOUND THEN

            -- Update value
            INSERT INTO temp_mincut_node VALUES(node_id_arg);
        
            -- Loop for all the upstream nodes
            FOR rec_table IN SELECT arc_id, node_1 FROM arc WHERE node_2 = node_id_arg
            LOOP

                -- Insert into tables
                SELECT arc_id INTO exists_id FROM temp_mincut_arc WHERE arc_id = rec_table.arc_id;

                -- Compute proceed
                IF NOT FOUND THEN
                    INSERT INTO temp_mincut_arc VALUES(rec_table.arc_id);
                END IF;

                -- Call recursive function weighting with the pipe capacity
                PERFORM gw_fct_mincut_recursive(rec_table.node_1);
                
            END LOOP;

            -- Loop for all the downstream nodes
            FOR rec_table IN SELECT arc_id, node_2 FROM arc WHERE node_1 = node_id_arg
            LOOP

                -- Insert into tables
                SELECT arc_id INTO exists_id FROM temp_mincut_arc WHERE arc_id = rec_table.arc_id;

                -- Compute proceed
                IF NOT FOUND THEN
                    INSERT INTO temp_mincut_arc VALUES(rec_table.arc_id);
                END IF;

                -- Call recursive function weighting with the pipe capacity
                PERFORM gw_fct_mincut_recursive(rec_table.node_2);

            END LOOP;

        END IF;
    END IF;

    RETURN;

        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

