/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_delete_node(node_id_arg varchar) RETURNS int4 AS $BODY$
DECLARE
    epa_type_aux varchar;
    rec_aux record;
    intersect_loc double precision;
    exists_id varchar;
    message_id integer;
    controlValue integer;
    myRecord1 SCHEMA_NAME.arc;
    myRecord2 SCHEMA_NAME.arc;
    arc_geom geometry;
    arc_id_1 varchar;
    arc_id_2 varchar;
    pointArray1 geometry[];
    pointArray2 geometry[];

BEGIN

    -- Search path
    SET search_path = SCHEMA_NAME, public;

    -- Check if the node is exists
    SELECT node_id INTO exists_id FROM node WHERE node_id = node_id_arg;

    -- Compute proceed
    IF FOUND THEN

        -- Find arcs sharing node
        SELECT COUNT(*) INTO controlValue FROM arc WHERE node_1 = node_id_arg OR node_2 = node_id_arg;

        -- Accepted if there are just two distinc arcs
        IF controlValue = 2 THEN

            -- Get both pipes features
            SELECT * INTO myRecord1 FROM arc WHERE node_1 = node_id_arg OR node_2 = node_id_arg ORDER BY arc_id DESC LIMIT 1;
            SELECT * INTO myRecord2 FROM arc WHERE node_1 = node_id_arg OR node_2 = node_id_arg ORDER BY arc_id ASC LIMIT 1;

            -- Compare pipes
            IF  myRecord1.arccat_id = myRecord2.arccat_id AND
                myRecord1.epa_type  = myRecord2.epa_type  AND
                myRecord1.sector_id = myRecord2.sector_id THEN

                -- Final geometry
                IF myRecord1.node_1 = node_id_arg THEN
                    IF myRecord2.node_1 = node_id_arg THEN
                        pointArray1 := ARRAY(SELECT ST_DumpPoints(ST_Reverse(myRecord1.the_geom)));
                        pointArray2 := array_cat(pointArray1, ARRAY(SELECT (ST_DumpPoints(myRecord2.the_geom)).geom));
                    ELSE
                        pointArray1 := ARRAY(SELECT (ST_DumpPoints(myRecord2.the_geom)).geom);
                        pointArray2 := array_cat(pointArray1, ARRAY(SELECT (ST_DumpPoints(myRecord1.the_geom)).geom));
                    END IF;
                ELSE
                    IF myRecord2.node_1 = node_id_arg THEN
                        pointArray1 := ARRAY(SELECT ST_DumpPoints(myRecord1.the_geom));
                        pointArray2 := array_cat(pointArray1, ARRAY(SELECT (ST_DumpPoints(myRecord2.the_geom)).geom));
                    ELSE
                        pointArray1 := ARRAY(SELECT ST_DumpPoints(myRecord2.the_geom));
                        pointArray2 := array_cat(pointArray1, ARRAY(SELECT (ST_DumpPoints(ST_Reverse(myRecord1.the_geom))).geom));
                    END IF;
                END IF;

                arc_geom := ST_MakeLine(pointArray2);

                -- Cascade bug
                DELETE FROM event_x_junction WHERE node_id = node_id_arg;
                DELETE FROM event_x_pipe WHERE arc_id = myRecord1.arc_id OR arc_id = myRecord2.arc_id;

                -- Select longest
                IF ST_Length(myRecord1.the_geom) > ST_Length(myRecord2.the_geom) THEN

                    -- Createa new arc
                    myRecord1.the_geom := arc_geom;
                    myRecord1.node_1 := (SELECT node_id FROM node WHERE  ST_DWithin(ST_StartPoint(arc_geom), node.the_geom, 0.001));
                    myRecord1.node_2 := (SELECT node_id FROM node WHERE  ST_DWithin(ST_EndPoint(arc_geom), node.the_geom, 0.001));

                    -- Delete previous node
                    DELETE FROM node WHERE node_id = node_id_arg;

                    -- Insert new record
                    INSERT INTO arc SELECT myRecord1.*;
                    
                ELSE
                    -- Create a new arc
                    myRecord2.the_geom := arc_geom;
                    myRecord2.node_1 := (SELECT node_id FROM node WHERE  ST_DWithin(ST_StartPoint(arc_geom), node.the_geom, 0.001));
                    myRecord2.node_2 := (SELECT node_id FROM node WHERE  ST_DWithin(ST_EndPoint(arc_geom), node.the_geom, 0.001));

                    -- Delete previous node
                    DELETE FROM node WHERE node_id = node_id_arg;

                    -- Insert new record
                    INSERT INTO arc SELECT myRecord2.*;

                END IF;

            -- Pipes has different types
            ELSE
                RETURN audit_function(202);
            END IF;
         
        -- Node has not 2 arcs
        ELSE
            RETURN audit_function(203);
        END IF;

    -- Node not found
    ELSE 
        RETURN audit_function(201);
    END IF;

    RETURN audit_function(0);

END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;

