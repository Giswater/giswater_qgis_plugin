/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- Function: SCHEMA_NAME.gw_fct_delete_node(character varying)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_delete_node(character varying);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_delete_node(node_id_arg character varying)
  RETURNS integer AS
$BODY$
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
	rec_doc_arc record;
	rec_doc_node record;
	rec_visit_node record;
	rec_visit_arc record;

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
                        pointArray1 := ARRAY(SELECT (ST_DumpPoints(ST_Reverse(myRecord1.the_geom))).geom);
                        pointArray2 := array_cat(pointArray1, ARRAY(SELECT (ST_DumpPoints(myRecord2.the_geom)).geom));
                    ELSE
                        pointArray1 := ARRAY(SELECT (ST_DumpPoints(myRecord2.the_geom)).geom);
                        pointArray2 := array_cat(pointArray1, ARRAY(SELECT (ST_DumpPoints(myRecord1.the_geom)).geom));
                    END IF;
                ELSE
                    IF myRecord2.node_1 = node_id_arg THEN
                        pointArray1 := ARRAY(SELECT (ST_DumpPoints(myRecord1.the_geom)).geom);
                        pointArray2 := array_cat(pointArray1, ARRAY(SELECT (ST_DumpPoints(myRecord2.the_geom)).geom));
                    ELSE
                        pointArray1 := ARRAY(SELECT (ST_DumpPoints(myRecord2.the_geom)).geom);
                        pointArray2 := array_cat(pointArray1, ARRAY(SELECT (ST_DumpPoints(ST_Reverse(myRecord1.the_geom))).geom));
                    END IF;
                END IF;

                arc_geom := ST_MakeLine(pointArray2);


                -- Select longest
                IF ST_Length(myRecord1.the_geom) > ST_Length(myRecord2.the_geom) THEN

                    -- Createa new arc
                    myRecord1.the_geom := arc_geom;
                    myRecord1.node_1 := (SELECT node_id FROM node WHERE  ST_DWithin(ST_StartPoint(arc_geom), node.the_geom, 0.001));
                    myRecord1.node_2 := (SELECT node_id FROM node WHERE  ST_DWithin(ST_EndPoint(arc_geom), node.the_geom, 0.001));

                    -- Insert new record
                    UPDATE arc SET node_1 = myRecord1.node_1, node_2 = myRecord1.node_2, the_geom = myRecord1.the_geom WHERE arc_id = myRecord1.arc_id;
                    
                ELSE
                    -- Create a new arc
                    myRecord2.the_geom := arc_geom;
                    myRecord2.node_1 := (SELECT node_id FROM node WHERE  ST_DWithin(ST_StartPoint(arc_geom), node.the_geom, 0.001));
                    myRecord2.node_2 := (SELECT node_id FROM node WHERE  ST_DWithin(ST_EndPoint(arc_geom), node.the_geom, 0.001));

                    -- Insert new record
                    UPDATE arc SET node_1 = myRecord2.node_1, node_2 = myRecord2.node_2, the_geom = myRecord2.the_geom WHERE arc_id = myRecord2.arc_id;

                END IF;
				
			--INSERT DATA INTO OM_TRACEABILITY
				INSERT INTO om_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", "user") VALUES ('ARC FUSION', myRecord2.arc_id, myRecord2.arc_id,myRecord1.arc_id,exists_id, CURRENT_TIMESTAMP, CURRENT_USER);
			
			--PASSING DOCUMENTS FROM DELETED NODE TO THE NEW ARC
			
			FOR rec_doc_node IN SELECT * FROM doc_x_node WHERE node_id=node_id_arg LOOP
				INSERT INTO doc_x_arc (id,doc_id, arc_id) VALUES (nextval('doc_x_node_seq'),rec_doc_node.doc_id, myRecord2.arc_id);
			END LOOP;
			
			--PASSING DOCUMENTS FROM DELETED ARC TO THE NEW ARC
					
			FOR rec_doc_arc IN SELECT * FROM doc_x_arc WHERE arc_id=myRecord1.arc_id  LOOP
				INSERT INTO doc_x_arc (id,doc_id, arc_id) VALUES (nextval('doc_x_arc_seq'),rec_doc_arc.doc_id, myRecord2.arc_id);
			END LOOP;

			--PASSING VISITS FROM DELETED NODE TO THE NEW ARC
			
			FOR rec_visit_node IN SELECT * FROM om_visit_x_node WHERE node_id=node_id_arg LOOP
				INSERT INTO om_visit_x_arc (id,visit_id, arc_id) VALUES (nextval('om_visit_id_seq'),rec_visit_node.visit_id, myRecord2.arc_id);
			END LOOP;		
						
			--PASSING VISITS FROM DELETED ARC TO THE NEW ARC

			FOR rec_visit_arc IN SELECT * FROM om_visit_x_arc WHERE arc_id=myRecord1.arc_id LOOP
				INSERT INTO om_visit_x_arc (id,visit_id, arc_id) VALUES (nextval('om_visit_id_seq'),rec_visit_arc.visit_id, myRecord2.arc_id);
			END LOOP;
			
                -- Delete previous node
                DELETE FROM node WHERE node_id = node_id_arg;

            -- Pipes has different types
            ELSE
                RETURN audit_function(510,80);
            END IF;
         
        -- Node has not 2 arcs
        ELSE
            RETURN audit_function(515,80);
        END IF;

    -- Node not found
    ELSE 
        RETURN audit_function(505,80);
    END IF;

    RETURN audit_function(0,80);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_delete_node(character varying)
  OWNER TO postgres;

