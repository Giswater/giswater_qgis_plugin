-- Function: test_ws_1214.gw_fct_node2arc()

-- DROP FUNCTION test_ws_1214.gw_fct_node2arc();

CREATE OR REPLACE FUNCTION test_ws_1214.gw_fct_node2arc()
  RETURNS integer AS
$BODY$
DECLARE
    
    record_node test_ws_1214.node%ROWTYPE;
    record_arc1 test_ws_1214.arc%ROWTYPE;
    record_arc2 test_ws_1214.arc%ROWTYPE;
    record_new_arc test_ws_1214.arc%ROWTYPE;
    node_diameter double precision;
    valve_arc_geometry geometry;
    valve_arc_node_1_geom geometry;
    valve_arc_node_2_geom geometry;
    valve_arc_node_3_geom geometry;
    arc_reduced_geometry geometry;
    node_id_aux text;
    num_arcs integer;
    shortpipe_record record;
    loop_record record;
    to_arc_aux text;
    

BEGIN

--  Search path
    SET search_path = "test_ws_1214", public;

	
    RAISE NOTICE 'Starting node2arc process.';
	
--  Empty temp tables
    RAISE NOTICE 'Clear temp tables.';

    DELETE FROM temp_arc;
    DELETE FROM temp_node;
		
--  Copy into temp records
    RAISE NOTICE 'Copy records.';

    INSERT INTO temp_arc SELECT * FROM arc;
    INSERT INTO temp_node SELECT * FROM node;

--  Move valves to arc
    RAISE NOTICE 'Start loop.';

    
    FOR loop_record IN (SELECT node_id, to_arc FROM test_ws_1214.inp_valve UNION SELECT node_id, to_arc FROM test_ws_1214.inp_shortpipe UNION SELECT node_id, to_arc FROM test_ws_1214.inp_pump)
    LOOP

        -- Store node_id in a variable
	node_id_aux = loop_record.node_id;
	
--        RAISE NOTICE 'Process valve: %', node_id_aux;

        -- Get node data
        SELECT * INTO record_node FROM node WHERE node_id = node_id_aux;

        -- Get arc data
        SELECT COUNT(*) INTO num_arcs FROM arc WHERE node_1 = node_id_aux OR node_2 = node_id_aux;

        -- Get arcs
        SELECT * INTO record_arc1 FROM arc WHERE node_1 = node_id_aux;
        SELECT * INTO record_arc2 FROM arc WHERE node_2 = node_id_aux;

        -- Just 1 arcs
        IF num_arcs = 1 THEN

            -- Compute valve geometry
            IF record_arc2 ISNULL THEN

                -- Use arc 1 as reference
                record_new_arc = record_arc1;
    
                -- TODO: Control pipe shorter than 0.5 m!
                valve_arc_node_1_geom := ST_StartPoint(record_arc1.the_geom);
                valve_arc_node_2_geom := ST_LineInterpolatePoint(record_arc1.the_geom, (SELECT node2arc FROM config) / ST_Length(record_arc1.the_geom));

                -- Correct arc geometry
                arc_reduced_geometry := ST_LineSubstring(record_arc1.the_geom,ST_LineLocatePoint(record_arc1.the_geom,valve_arc_node_2_geom),1);
                UPDATE temp_arc AS a SET the_geom = arc_reduced_geometry, node_1 = (SELECT concat(node_id_aux, '_n2a_2')) WHERE arc_id = record_arc1.arc_id; 
            
            ELSIF record_arc1 ISNULL THEN
 
                -- Use arc 2 as reference
                record_new_arc = record_arc2;

                valve_arc_node_2_geom := ST_EndPoint(record_arc2.the_geom);
                valve_arc_node_1_geom := ST_LineInterpolatePoint(record_arc2.the_geom, 1 - (SELECT node2arc FROM config) / ST_Length(record_arc2.the_geom));

                -- Correct arc geometry
                arc_reduced_geometry := ST_LineSubstring(record_arc2.the_geom,0,ST_LineLocatePoint(record_arc2.the_geom,valve_arc_node_1_geom));
                UPDATE temp_arc AS a SET the_geom = arc_reduced_geometry, node_2 = (SELECT concat(node_id_aux, '_n2a_1')) WHERE arc_id = record_arc2.arc_id;

            END IF;

        -- Two arcs
        ELSIF num_arcs = 2 THEN

            -- Two 'node_2' arcs
            IF record_arc1 ISNULL THEN

                -- Define new arc direction
                IF loop_record.to_arc = (SELECT arc_id FROM arc WHERE node_2 = node_id_aux ORDER BY arc_id ASC LIMIT 1) THEN

                    -- Get arcs
                    SELECT * INTO record_arc2 FROM arc WHERE node_2 = node_id_aux ORDER BY arc_id DESC LIMIT 1;
                    SELECT * INTO record_arc1 FROM arc WHERE node_2 = node_id_aux ORDER BY arc_id ASC LIMIT 1;

                ELSE

                    -- Get arcs
                    SELECT * INTO record_arc2 FROM arc WHERE node_2 = node_id_aux ORDER BY arc_id ASC LIMIT 1;
                    SELECT * INTO record_arc1 FROM arc WHERE node_2 = node_id_aux ORDER BY arc_id DESC LIMIT 1;

                END IF;

                -- Use arc 1 as reference (TODO: Why?)
                record_new_arc = record_arc1;
    
                -- TODO: Control pipe shorter than 0.5 m!
                valve_arc_node_1_geom := ST_LineInterpolatePoint(record_arc2.the_geom, 1 - (SELECT node2arc FROM config) / ST_Length(record_arc2.the_geom) / 2);
                valve_arc_node_2_geom := ST_LineInterpolatePoint(record_arc1.the_geom, 1 - (SELECT node2arc FROM config) / ST_Length(record_arc1.the_geom) / 2);

                -- Correct arc geometry
                arc_reduced_geometry := ST_LineSubstring(record_arc1.the_geom,0,ST_LineLocatePoint(record_arc1.the_geom,valve_arc_node_2_geom));
                UPDATE temp_arc AS a SET the_geom = arc_reduced_geometry, node_2 = (SELECT concat(node_id_aux, '_n2a_2')) WHERE a.arc_id = record_arc1.arc_id; 

                arc_reduced_geometry := ST_LineSubstring(record_arc2.the_geom,0,ST_LineLocatePoint(record_arc2.the_geom,valve_arc_node_1_geom));
                UPDATE temp_arc AS a SET the_geom = arc_reduced_geometry, node_2 = (SELECT concat(node_id_aux, '_n2a_1')) WHERE a.arc_id = record_arc2.arc_id;


            -- Two 'node_1' arcs
            ELSIF record_arc2 ISNULL THEN

                -- Define new arc direction
                IF loop_record.to_arc = (SELECT arc_id FROM arc WHERE node_1 = node_id_aux ORDER BY arc_id DESC LIMIT 1) THEN

                    -- Get arcs
                    SELECT * INTO record_arc1 FROM arc WHERE node_1 = node_id_aux ORDER BY arc_id DESC LIMIT 1;
                    SELECT * INTO record_arc2 FROM arc WHERE node_1 = node_id_aux ORDER BY arc_id ASC LIMIT 1;

                ELSE

                    -- Get arcs
                    SELECT * INTO record_arc2 FROM arc WHERE node_1 = node_id_aux ORDER BY arc_id ASC LIMIT 1;
                    SELECT * INTO record_arc1 FROM arc WHERE node_1 = node_id_aux ORDER BY arc_id DESC LIMIT 1;

                END IF;
                

                -- Use arc 1 as reference (TODO: Why?)
                record_new_arc = record_arc1;
    
                -- TODO: Control pipe shorter than 0.5 m!
                valve_arc_node_1_geom := ST_LineInterpolatePoint(record_arc2.the_geom, (SELECT node2arc FROM config) / ST_Length(record_arc2.the_geom) / 2);
                valve_arc_node_2_geom := ST_LineInterpolatePoint(record_arc1.the_geom, (SELECT node2arc FROM config) / ST_Length(record_arc1.the_geom) / 2);

                -- Correct arc geometry
                arc_reduced_geometry := ST_LineSubstring(record_arc1.the_geom,ST_LineLocatePoint(record_arc1.the_geom,valve_arc_node_2_geom),1);
                UPDATE temp_arc AS a SET the_geom = arc_reduced_geometry, node_1 = (SELECT concat(node_id_aux, '_n2a_2')) WHERE a.arc_id = record_arc1.arc_id; 

                arc_reduced_geometry := ST_LineSubstring(record_arc2.the_geom,ST_LineLocatePoint(record_arc2.the_geom,valve_arc_node_1_geom),1);
                UPDATE temp_arc AS a SET the_geom = arc_reduced_geometry, node_1 = (SELECT concat(node_id_aux, '_n2a_1')) WHERE a.arc_id = record_arc2.arc_id;
                        

            -- One 'node_1' and one 'node_2'
            ELSE

                -- Use arc 1 as reference (TODO: Why?)
                record_new_arc = record_arc1;
                    
                -- TODO: Control pipe shorter than 0.5 m!
                valve_arc_node_1_geom := ST_LineInterpolatePoint(record_arc2.the_geom, 1 - (SELECT node2arc FROM config) / ST_Length(record_arc2.the_geom) / 2);
                valve_arc_node_2_geom := ST_LineInterpolatePoint(record_arc1.the_geom, (SELECT node2arc FROM config) / ST_Length(record_arc1.the_geom) / 2);

                -- Correct arc geometry
                arc_reduced_geometry := ST_LineSubstring(record_arc1.the_geom,ST_LineLocatePoint(record_arc1.the_geom,valve_arc_node_2_geom),1);
                UPDATE temp_arc AS a SET the_geom = arc_reduced_geometry, node_1 = (SELECT concat(a.node_1, '_n2a_2')) WHERE a.arc_id = record_arc1.arc_id; 

                arc_reduced_geometry := ST_LineSubstring(record_arc2.the_geom,0,ST_LineLocatePoint(record_arc2.the_geom,valve_arc_node_1_geom));
                UPDATE temp_arc AS a SET the_geom = arc_reduced_geometry, node_2 = (SELECT concat(a.node_2, '_n2a_1')) WHERE a.arc_id = record_arc2.arc_id;

		-- Check new arc direction
                IF loop_record.to_arc = record_arc2.arc_id THEN
		    valve_arc_node_3_geom = valve_arc_node_1_geom;
                    valve_arc_node_1_geom = valve_arc_node_2_geom;
                    valve_arc_node_2_geom = valve_arc_node_3_geom;
                END IF;
                        
            END IF;

        -- num_arcs 0 or > 2
        ELSE

            CONTINUE;
                        
        END IF;

        -- Create new arc geometry
        valve_arc_geometry := ST_MakeLine(valve_arc_node_1_geom, valve_arc_node_2_geom);

        -- Insert into arc table
        record_new_arc.arc_id := concat(node_id_aux, '_n2a');
        record_new_arc.custom_length := NULL;
        --record_new_arc.epa_type := 'VALVE';
        record_new_arc.the_geom := valve_arc_geometry;
	record_new_arc.node_1 := concat(node_id_aux, '_n2a_1');
	record_new_arc.node_2 := concat(node_id_aux, '_n2a_2');
	

        --Print insert data
        --RAISE NOTICE 'Data: %', record_new_arc;
        
        INSERT INTO temp_arc VALUES(record_new_arc.*);

        -- Add additional nodes
        record_node.epa_type := 'JUNCTION';
        record_node.the_geom := valve_arc_node_1_geom;
        record_node.node_id := concat(node_id_aux, '_n2a_1');
        INSERT INTO temp_node VALUES(record_node.*);

        record_node.the_geom := valve_arc_node_2_geom;
        record_node.node_id := concat(node_id_aux, '_n2a_2');
        INSERT INTO temp_node VALUES(record_node.*);

        -- Delete valve node
        DELETE FROM temp_node WHERE node_id =  node_id_aux;


    END LOOP;

    RETURN 1;
	
--	RETURN test_ws_1214.audit_function(0,90);

		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION test_ws_1214.gw_fct_node2arc()
  OWNER TO postgres;

