/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2114


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
    gully_id_aux varchar;
    connec_id_aux varchar;
    count_aux1 smallint;
    count_aux2 smallint;
    return_aux smallint;
	arc_divide_tolerance_aux float =0.05;
	plan_arc_vdivision_dsbl_aux boolean;
	array_agg_connec varchar [];
	array_agg_gully varchar [];
	v_arcsearch_nodes float;
    rec_node record;



	
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;
	
	-- Get project type
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
    
    -- Get node values
    SELECT the_geom INTO node_geom FROM node WHERE node_id = node_id_arg;
	SELECT state INTO state_node_arg FROM node WHERE node_id=node_id_arg;

    -- Get parameters from configs table
	SELECT value::boolean INTO plan_arc_vdivision_dsbl_aux FROM config_param_user WHERE "parameter"='plan_arc_vdivision_dsbl' AND cur_user=current_user;
	SELECT arc_searchnodes INTO v_arcsearch_nodes FROM config;
	
	-- State control
	IF state_aux=0 THEN
		PERFORM audit_function(1050,2114);
	ELSIF state_node_arg=0 THEN
		PERFORM audit_function(1052,2114);
	END IF;

	-- Check if it's a end/start point node in case of wrong topology without start or end nodes
	SELECT arc_id INTO arc_id_aux FROM v_edit_arc WHERE ST_DWithin(ST_startpoint(the_geom), node_geom, v_arcsearch_nodes) 
		    OR ST_DWithin(ST_endpoint(the_geom), node_geom, v_arcsearch_nodes) LIMIT 1;
	IF arc_id_aux IS NOT NULL THEN 
		IF (SELECT arc_id FROM v_edit_arc WHERE arc_id=arc_id_aux AND node_1 IS NULL OR node_2 IS NULL LIMIT 1) IS NOT NULL THEN
			UPDATE arc SET the_geom=the_geom WHERE arc_id=arc_id_aux;
			RETURN 0;
		END IF;
	END IF;

	-- Find closest arc inside tolerance
	SELECT arc_id, state, the_geom INTO arc_id_aux, state_aux, arc_geom  FROM v_edit_arc AS a 
	WHERE ST_DWithin(node_geom, a.the_geom, arc_divide_tolerance_aux) AND node_1 != node_id_arg AND node_2 != node_id_arg
	ORDER BY ST_Distance(node_geom, a.the_geom) LIMIT 1;

	IF arc_id_aux IS NOT NULL THEN 

	
		--  Locate position of the nearest point
		intersect_loc := ST_LineLocatePoint(arc_geom, node_geom);
		
		-- Compute pieces
		line1 := ST_LineSubstring(arc_geom, 0.0, intersect_loc);
		line2 := ST_LineSubstring(arc_geom, intersect_loc, 1.0);
	
		-- Check if any of the 'lines' are in fact a point
		IF (ST_GeometryType(line1) = 'ST_Point') OR (ST_GeometryType(line2) = 'ST_Point') THEN
			RETURN 1;
		END IF;
	
		-- Get arc data
		SELECT * INTO rec_aux1 FROM v_edit_arc WHERE arc_id = arc_id_aux;
		SELECT * INTO rec_aux2 FROM v_edit_arc WHERE arc_id = arc_id_aux;

		-- Update values of new arc_id (1)
		rec_aux1.arc_id := nextval('SCHEMA_NAME.urn_id_seq');
		rec_aux1.node_1 := null;
		rec_aux1.node_2 := null;
		rec_aux1.the_geom := line1;

		-- Update values of new arc_id (2)
		rec_aux2.arc_id := nextval('SCHEMA_NAME.urn_id_seq');	
		rec_aux2.node_1 := null;
		rec_aux2.node_2 := null;
		rec_aux2.the_geom := line2;
		
		-- In function of states and user's variables proceed.....
		IF (state_aux=1 AND state_node_arg=1) OR (state_aux=2 AND state_node_arg=2) THEN 
		
			-- Insert new records into arc table
			-- downgrade temporary the state_topocontrol to prevent conflicts	
			UPDATE config_param_system SET value='FALSE' where parameter='state_topocontrol';
			INSERT INTO v_edit_arc SELECT rec_aux1.*;
			INSERT INTO v_edit_arc SELECT rec_aux2.*;
			-- force trg topocontrol to prevent conflicts
			update arc set the_geom=the_geom where arc_id=rec_aux1.arc_id;
			update arc set the_geom=the_geom where arc_id=rec_aux2.arc_id;
			-- restore the state_topocontrol variable
			UPDATE config_param_system SET value='TRUE' where parameter='state_topocontrol';
			
			--Copy addfields from old arc to new arcs	
			INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
			SELECT 
			rec_aux2.arc_id,
			parameter_id,
			value_param
			FROM man_addfields_value WHERE feature_id=arc_id_aux;
			
			INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
			SELECT 
			rec_aux1.arc_id,
			parameter_id,
			value_param
			FROM man_addfields_value WHERE feature_id=arc_id_aux;
			
			-- update arc_id of disconnected nodes linked to old arc
			FOR rec_node IN SELECT node_id, the_geom FROM node WHERE arc_id=arc_id_aux
			LOOP
				UPDATE node SET arc_id=(SELECT arc_id FROM v_edit_arc WHERE ST_DWithin(rec_node.the_geom, 
				v_edit_arc.the_geom,0.001) AND arc_id != arc_id_aux LIMIT 1) 
				WHERE node_id=rec_node.node_id;
			END LOOP;

			-- Capture linked feature information to redraw (later on this function)
			-- connec
			FOR connec_id_aux IN SELECT connec_id FROM connec WHERE arc_id=arc_id_aux
			LOOP
				array_agg_connec:= array_append(array_agg_connec, connec_id_aux);
			END LOOP;
			UPDATE connec SET arc_id=NULL WHERE arc_id=arc_id_aux;	
	
			-- gully
			IF project_type_aux='UD' THEN

				FOR gully_id_aux IN SELECT gully_id FROM gully WHERE arc_id=arc_id_aux
				LOOP
					array_agg_gully:= array_append(array_agg_gully, gully_id_aux);
				END LOOP;
				UPDATE gully SET arc_id=NULL WHERE arc_id=arc_id_aux;		
			END IF;
					
			--INSERT DATA INTO OM_TRACEABILITY
			INSERT INTO audit_log_arc_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", "user") 
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
	
			-- delete relations from old arc
			DELETE FROM element_x_arc WHERE arc_id=arc_id_aux;
			DELETE FROM doc_x_arc WHERE arc_id=arc_id_aux;
			DELETE FROM om_visit_x_arc WHERE arc_id=arc_id_aux;
	
			-- delete old arc
			DELETE FROM arc WHERE arc_id=arc_id_aux;

			PERFORM gw_fct_connect_to_network(array_agg_connec, 'CONNEC');
			PERFORM gw_fct_connect_to_network(array_agg_gully, 'GULLY');

			
			
		ELSIF (state_aux=1 AND state_node_arg=2) AND plan_arc_vdivision_dsbl_aux IS NOT TRUE THEN 
			rec_aux1.state=2;
			rec_aux1.state_type=(SELECT value::smallint FROM config_param_user WHERE "parameter"='statetype_plan_vdefault' AND cur_user=current_user);
			
			rec_aux2.state=2;
			rec_aux2.state_type=(SELECT value::smallint FROM config_param_user WHERE "parameter"='statetype_plan_vdefault' AND cur_user=current_user);
			
			-- Insert new records into arc table
			-- downgrade temporary the state_topocontrol to prevent conflicts	
			UPDATE config_param_system SET value='FALSE' where parameter='state_topocontrol';
			INSERT INTO v_edit_arc SELECT rec_aux1.*;
			INSERT INTO v_edit_arc SELECT rec_aux2.*;
			-- force trg topocontrol to prevent conflicts
			update arc set the_geom=the_geom where arc_id=rec_aux1.arc_id;
			update arc set the_geom=the_geom where arc_id=rec_aux2.arc_id;
			-- restore the state_topocontrol variable
			UPDATE config_param_system SET value='TRUE' where parameter='state_topocontrol';
	
			-- Update doability for the new arcs
			UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux1.arc_id;
			UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux2.arc_id;
		
			-- Insert existig arc (on service) to the current alternative
			INSERT INTO plan_psector_x_arc (psector_id, arc_id, state, doable) VALUES (
			(SELECT value::smallint FROM config_param_user WHERE "parameter"='psector_vdefault' AND cur_user=current_user), arc_id_aux, 0, FALSE);
	
		ELSIF (state_aux=1 AND state_node_arg=2) AND plan_arc_vdivision_dsbl_aux IS TRUE THEN
			PERFORM audit_function(1054,2114);			

		ELSIF (state_aux=2 AND state_node_arg=1) THEN
			RETURN return_aux;		
		ELSE  
			PERFORM audit_function(2120,2114); 
			
		END IF;
	ELSE
		PERFORM audit_function(2122,2114);
	
	END IF;

	
RETURN return_aux;
 

  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
