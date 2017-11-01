DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_arc_divide(character varying);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_arc_divide(node_id_arg character varying)
  RETURNS smallint AS
$BODY$
DECLARE
    node_geom    geometry;
    arc_id_aux    varchar;
    arc_geom    geometry;
    line1        geometry;
    line2        geometry;
    rec_aux        record;
    rec_aux1	"SCHEMA_NAME".v_edit_arc;
    rec_aux2    "SCHEMA_NAME".v_edit_arc;
    intersect_loc    double precision;
    numArcs    integer;
    rec_doc record;
    rec_visit record;
    project_type_aux text;
    state_aux integer;
    state_node_arg integer;
    array_agg varchar [];
    gully_id_aux varchar;
    connec_id_aux varchar;
	
BEGIN

    --    Search path
    SET search_path = "SCHEMA_NAME", public;
      
    --    Get node geometry
    SELECT the_geom INTO node_geom FROM node WHERE node_id = node_id_arg;

    --    Get node tolerance from config table
    SELECT node2arc INTO rec_aux FROM config;

    -- Get project type
    SELECT SCHEMA_NAMEoftware INTO project_type_aux FROM version LIMIT 1;


     --    Find closest arc inside tolerance
    SELECT arc_id, state, the_geom INTO arc_id_aux, state_aux, arc_geom  FROM v_edit_arc AS a 
    WHERE ST_DWithin(node_geom, a.the_geom, rec_aux.node2arc) ORDER BY ST_Distance(node_geom, a.the_geom) LIMIT 1;

    
    --    Check state
    SELECT state INTO state_node_arg FROM node WHERE node_id=node_id_arg;
    
    IF state_aux=0 THEN
	RAISE EXCEPTION 'It is not possible to divide the arc because it has state=(0)';
    ELSIF state_node_arg=0 THEN
    	RAISE EXCEPTION 'It is not possible to divide the arc because the used node has state=(0)';
    ELSIF state_aux=1 AND state_node_arg=2 THEN
	RAISE EXCEPTION 'It is not possible to divide the arc because the arc has state=(1) and the node has state=(2)';
    END IF;

	
    --    Compute cut
    IF arc_geom IS NOT NULL THEN

        --    Locate position of the nearest point
        intersect_loc := ST_LineLocatePoint(arc_geom, node_geom);


        --    Compute pieces
        line1 := ST_LineSubstring(arc_geom, 0.0, intersect_loc);
        line2 := ST_LineSubstring(arc_geom, intersect_loc, 1.0);

        -- Check if any of the 'lines' are in fact a point
        IF (ST_GeometryType(line1) = 'ST_Point') OR (ST_GeometryType(line2) = 'ST_Point') THEN
            RETURN 1;
        END IF;

        --    Get arc data
        SELECT * INTO rec_aux1 FROM v_edit_arc WHERE arc_id = arc_id_aux;
        SELECT * INTO rec_aux2 FROM v_edit_arc WHERE arc_id = arc_id_aux;

        --    New arc_id
        rec_aux1.arc_id := nextval('SCHEMA_NAME.urn_id_seq');
        rec_aux2.arc_id := nextval('SCHEMA_NAME.urn_id_seq');

	rec_aux1.the_geom := line1;
	rec_aux2.the_geom := line2;
		
 /*
        --    Check longest
        IF ST_Length(line1) > ST_Length(line2) THEN

            --    Update arc
            UPDATE arc SET (arc_id, node_2, the_geom) = (rec_aux1.arc_id, node_id_arg, line1) WHERE arc_id = arc_id_aux;

            --    Insert new
            rec_aux2.the_geom := line2;
            rec_aux2.node_1 := node_id_arg;

        ELSE

            --    Update arc
            UPDATE arc SET (arc_id, node_1, the_geom) = (rec_aux1.arc_id, node_id_arg, line2) WHERE arc_id = arc_id_aux;

            --    Insert new
            rec_aux2.the_geom := line1;
            rec_aux2.node_2 := node_id_arg;

        END IF;
*/
        --    Insert new record into arc table
        INSERT INTO v_edit_arc SELECT rec_aux1.*;
	INSERT INTO v_edit_arc SELECT rec_aux2.*;

        INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
	SELECT 
	rec_aux2.arc_id,
	parameter_id,
	value_param
	FROM man_addfields_value WHERE feature_id=arc_id_aux;
    

    END IF;

		    -- Redraw the link and vnode (only userdefined_geom false and directly connected to arc)
		    FOR connec_id_aux IN SELECT connec_id FROM connec WHERE arc_id=arc_id_aux
		    LOOP
			array_agg:= array_append(array_agg, connec_id_aux);
		    END LOOP;
	
		    PERFORM gw_fct_connect_to_network(array_agg, 'CONNEC');

		    -- For those that are not redrawed (user defined true)
		    -- TO DO (so complex, must work using trace on the topology on links)

		    --UPDATE connec SET arc_id=rec_aux2.arc_id WHERE arc_id=arc_id_aux;

		    IF project_type_aux='UD' THEN
			FOR gully_id_aux IN SELECT gully_id FROM gully WHERE arc_id=arc_id_aux
			LOOP
				array_agg:= array_append(array_agg, gully_id_aux);
			END LOOP;
		
			PERFORM gw_fct_connec_to_network(array_agg, 'GULLY');
			
			-- For those that are not redrawed		
			-- TO DO (so complex, must work using trace on the topology on links)
			
		     END IF;



--INSERT DATA INTO OM_TRACEABILITY
	INSERT INTO om_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", "user") 
	VALUES ('DIVIDE ARC',  arc_id_aux, rec_aux1.arc_id, rec_aux2.arc_id, node_id_arg,CURRENT_TIMESTAMP,CURRENT_USER);

	--Copy elements from old arc to new arcs
	FOR rec_aux IN SELECT * FROM element_x_arc WHERE arc_id=arc_id_aux  LOOP
		INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux1.arc_id);
		INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux2.arc_id);
	END LOOP;	
			
	--Copy documents from old arc to the new arcs
	FOR rec_aux IN SELECT * FROM doc_x_arc WHERE arc_id=arc_id_aux  LOOP
		INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux1.arc_id);
		INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux2.arc_id);
	END LOOP;

	--Copy visits from old arc to the new arcs
	FOR rec_aux IN SELECT * FROM om_visit_x_arc WHERE arc_id=arc_id_aux  LOOP
		INSERT INTO om_visit_x_arc (id, visit_id, arc_id) VALUES (nextval('om_visit_x_arc_id_seq'),rec_aux.visit_id, rec_aux1.arc_id);
		INSERT INTO om_visit_x_arc (id, visit_id, arc_id) VALUES (nextval('om_visit_x_arc_id_seq'),rec_aux.visit_id, rec_aux2.arc_id);
	END LOOP;
	

	DELETE FROM arc WHERE arc_id=arc_id_aux;

	RETURN 1;
    --RETURN audit_function(0,90);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;