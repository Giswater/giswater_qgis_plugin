/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2114



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_arc_divide(node_id_arg character varying)
  RETURNS smallint AS

$BODY$
/*
SELECT "SCHEMA_NAME".gw_fct_arc_divide('1079');
*/
DECLARE
    node_geom    geometry;
    arc_id_aux    varchar;
    arc_geom    geometry;
    line1        geometry;
    line2        geometry;
    rec_aux        record;
    rec_aux1	"SCHEMA_NAME".arc;
    rec_aux2    "SCHEMA_NAME".arc;
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
	array_agg_connec varchar [];
	array_agg_gully varchar [];
	v_arc_searchnodes float;
    rec_node record;
    rec_event record;
    v_newarc varchar;
    v_visitlocation float;
    v_eventlocation float;
    v_srid integer;
    v_newvisit1 int8;
    v_newvisit2 int8;
    v_psector integer;
	v_ficticius int2;
	isarcdivide_arg boolean;
	v_querytext text;
	v_querytext1 text;
	v_querytext2 text;
	v_mantable text;
	v_schemaname text;
	
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;
    v_schemaname = 'SCHEMA_NAME';

	-- Get project type
	SELECT wsoftware, epsg INTO project_type_aux, v_srid FROM version LIMIT 1;
    
    -- Get node values
    SELECT the_geom INTO node_geom FROM node WHERE node_id = node_id_arg;
	SELECT state INTO state_node_arg FROM node WHERE node_id=node_id_arg;
	SELECT isarcdivide INTO isarcdivide_arg FROM node_type JOIN cat_node ON cat_node.nodetype_id=node_type.id JOIN node ON node.nodecat_id = cat_node.id WHERE node.node_id=node_id_arg;


    -- Get parameters from configs table
	SELECT ((value::json)->>'value') INTO v_arc_searchnodes FROM config_param_system WHERE parameter='arc_searchnodes';
	SELECT value::smallint INTO v_psector FROM config_param_user WHERE "parameter"='psector_vdefault' AND cur_user=current_user;
	SELECT value::smallint INTO v_ficticius FROM config_param_system WHERE parameter='plan_statetype_ficticius';

	
	-- State control
	IF state_aux=0 THEN
		PERFORM audit_function(1050,2114);
	ELSIF state_node_arg=0 THEN
		PERFORM audit_function(1052,2114);
	END IF;

	-- Control if node divides arc
	IF isarcdivide_arg=TRUE THEN 

		-- Check if it's a end/start point node in case of wrong topology without start or end nodes
		SELECT arc_id INTO arc_id_aux FROM v_edit_arc WHERE ST_DWithin(ST_startpoint(the_geom), node_geom, v_arc_searchnodes) OR ST_DWithin(ST_endpoint(the_geom), node_geom, v_arc_searchnodes) LIMIT 1;
		IF arc_id_aux IS NOT NULL THEN
			-- force trigger of topology in order to reconnect extremal nodes (in case of null's)
			UPDATE arc SET the_geom=the_geom WHERE arc_id=arc_id_aux;
			-- get another arc if exists
			SELECT arc_id INTO arc_id_aux FROM v_edit_arc WHERE ST_DWithin(the_geom, node_geom, v_arc_searchnodes) AND arc_id != arc_id_aux;
		END IF;

		-- For the specificic case of extremal node not reconnected due topology issues (i.e. arc state (1) and node state (2)

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
			SELECT * INTO rec_aux1 FROM arc WHERE arc_id = arc_id_aux;
			SELECT * INTO rec_aux2 FROM arc WHERE arc_id = arc_id_aux;

			-- Update values of new arc_id (1)
			rec_aux1.arc_id := nextval('SCHEMA_NAME.urn_id_seq');
			rec_aux1.code := rec_aux1.arc_id;
			rec_aux1.node_2 := node_id_arg ;-- rec_aux1.node_1 take values from original arc
			rec_aux1.the_geom := line1;

			-- Update values of new arc_id (2)
			rec_aux2.arc_id := nextval('SCHEMA_NAME.urn_id_seq');
			rec_aux2.code := rec_aux2.arc_id;
			rec_aux2.node_1 := node_id_arg; -- rec_aux2.node_2 take values from original arc
			rec_aux2.the_geom := line2;

			-- getting table child information (man_table)
			v_mantable = (SELECT man_table FROM arc_type JOIN v_edit_arc ON id=arc_type WHERE arc_id=arc_id_aux);

			-- building querytext for man_table
			v_querytext:= (SELECT replace (replace (array_agg(column_name::text)::text,'{',','),'}','') FROM information_schema.columns WHERE table_name=v_mantable AND table_schema=v_schemaname AND column_name !='arc_id');
			IF  v_querytext IS NULL THEN 
				v_querytext='';
			END IF;
			v_querytext1 =  'INSERT INTO '||v_mantable||' SELECT ';
			v_querytext2 =  v_querytext||' FROM '||v_mantable||' WHERE arc_id= '||arc_id_aux||'::text';

			-- In function of states and user's variables proceed.....
			IF (state_aux=1 AND state_node_arg=1) THEN 
			
				-- Insert new records into arc table
				INSERT INTO arc SELECT rec_aux1.*;
				EXECUTE v_querytext1||rec_aux1.arc_id::text||v_querytext2;
				
				INSERT INTO arc SELECT rec_aux2.*;
				EXECUTE v_querytext1||rec_aux2.arc_id::text||v_querytext2;

				-- update node_1 and node_2 because it's not possible to pass using parameters
				UPDATE arc SET node_1=rec_aux1.node_1,node_2=rec_aux1.node_2 where arc_id=rec_aux1.arc_id;
				UPDATE arc SET node_1=rec_aux2.node_1,node_2=rec_aux2.node_2 where arc_id=rec_aux2.arc_id;
				
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
				FOR connec_id_aux IN SELECT connec_id FROM connec JOIN link ON link.feature_id=connec_id WHERE link.feature_type='CONNEC' AND arc_id=arc_id_aux
				LOOP
					array_agg_connec:= array_append(array_agg_connec, connec_id_aux);
				END LOOP;
				UPDATE connec SET arc_id=NULL WHERE arc_id=arc_id_aux;

				-- gully
				IF project_type_aux='UD' THEN

					FOR gully_id_aux IN SELECT gully_id FROM gully JOIN link ON link.feature_id=gully_id WHERE link.feature_type='GULLY' AND arc_id=arc_id_aux
					LOOP
						array_agg_gully:= array_append(array_agg_gully, gully_id_aux);
					END LOOP;
					UPDATE gully SET arc_id=NULL WHERE arc_id=arc_id_aux;
				END IF;
						
				-- Insert data into traceability table
				INSERT INTO audit_log_arc_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", "user") 
				VALUES ('DIVIDE ARC',  arc_id_aux, rec_aux1.arc_id, rec_aux2.arc_id, node_id_arg,CURRENT_TIMESTAMP,CURRENT_USER);
			
				-- Update elements from old arc to new arcs
				FOR rec_aux IN SELECT * FROM element_x_arc WHERE arc_id=arc_id_aux  LOOP
					DELETE FROM element_x_arc WHERE arc_id=arc_id_aux;
					INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux1.arc_id);
					INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux2.arc_id);
				END LOOP;
			
				-- Update documents from old arc to the new arcs
				FOR rec_aux IN SELECT * FROM doc_x_arc WHERE arc_id=arc_id_aux  LOOP
					DELETE FROM doc_x_arc WHERE arc_id=arc_id_aux;
					INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux1.arc_id);
					INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux2.arc_id);

				END LOOP;

				-- Update visits from old arc to the new arcs (only for state=1, state=1)
				FOR rec_visit IN SELECT om_visit.* FROM om_visit_x_arc JOIN om_visit ON om_visit.id=visit_id WHERE arc_id=arc_id_aux LOOP

					IF rec_visit.the_geom IS NULL THEN -- if visit does not has geometry, events may have. It's mandatory to distribute one by one

						-- Get visit data into two new visits
						INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, webclient_id,expl_id,descript,is_done, lot_id, class_id, status, visit_type) 
						SELECT visitcat_id, ext_code, startdate, enddate, user_name, webclient_id, expl_id, descript, is_done, lot_id, class_id, status, visit_type 
						FROM om_visit WHERE id=rec_visit.id RETURNING id INTO v_newvisit1;

						INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, webclient_id, expl_id, descript, is_done, lot_id, class_id, status, visit_type) 
						SELECT visitcat_id, ext_code, startdate, enddate, user_name, webclient_id, expl_id, descript, is_done, lot_id, class_id, status, visit_type 
						FROM om_visit WHERE id=rec_visit.id RETURNING id INTO v_newvisit2;
						
						FOR rec_event IN SELECT * FROM om_visit_event WHERE visit_id=rec_visit.id LOOP
		
							IF rec_event.xcoord IS NOT NULL AND rec_event.ycoord IS NOT NULL THEN -- event must be related to one of the two new visits
								
								--  Locate position of the nearest point
								v_eventlocation := ST_LineLocatePoint(arc_geom, ST_ClosestPoint(arc_geom, ST_setSrid(ST_MakePoint(rec_event.xcoord, rec_event.ycoord), v_srid)));
								
								IF v_eventlocation < intersect_loc THEN
									UPDATE om_visit_event SET visit_id=v_newvisit1 WHERE id=rec_event.id;
								ELSE
									UPDATE om_visit_event SET visit_id=v_newvisit2 WHERE id=rec_event.id;
								END IF;
							ELSE 	-- event must be related on both new visits. As a result, new event must be created
							
								-- upate event to visit1
								UPDATE om_visit_event SET visit_id=v_newvisit1 WHERE id=rec_event.id;
								
								-- insert new event related to new visit2
								INSERT INTO om_visit_event (event_code, visit_id, position_id, position_value, parameter_id,value, value1, value2,geom1, geom2, 
								geom3,xcoord,ycoord,compass,text, index_val,is_last) 
								SELECT event_code, v_newvisit2, position_id, position_value, parameter_id,value, value1, value2,geom1, geom2, 
								geom3,xcoord,ycoord,compass,text, index_val,is_last FROM om_visit_event WHERE id=rec_event.id;
							
							END IF;
		
						END LOOP;
													
						INSERT INTO om_visit_x_arc (id, visit_id, arc_id) VALUES (nextval('om_visit_x_arc_id_seq'),v_newvisit1, rec_aux1.arc_id);
						INSERT INTO om_visit_x_arc (id, visit_id, arc_id) VALUES (nextval('om_visit_x_arc_id_seq'),v_newvisit2, rec_aux2.arc_id);
					
						-- delete old visit
						DELETE FROM om_visit WHERE id=rec_visit.id;
						
					ELSIF rec_visit.the_geom IS NOT NULL THEN -- if visit has geometry, events does not have geometry

						--  Locate position of the nearest point
						v_visitlocation := ST_LineLocatePoint(arc_geom, ST_ClosestPoint(arc_geom, rec_visit.the_geom));
						
						IF v_visitlocation < intersect_loc THEN
							v_newarc = rec_aux1.arc_id;
						ELSE
							v_newarc = rec_aux2.arc_id;
						END IF;
					
						-- distribute visit to new arc
						INSERT INTO om_visit_x_arc (id, visit_id, arc_id) VALUES (nextval('om_visit_x_arc_id_seq'),rec_visit.id, v_newarc);
						DELETE FROM om_visit_x_arc WHERE arc_id=arc_id_aux;
					END IF;
				END LOOP;

				-- Update arc_id on node
				FOR rec_aux IN SELECT * FROM node WHERE arc_id=arc_id_aux  LOOP

					-- find the new arc id
					SELECT arc_id INTO v_newarc FROM v_edit_arc AS a 
					WHERE ST_DWithin(rec_aux.the_geom, a.the_geom, 0.5) AND arc_id !=arc_id_aux ORDER BY ST_Distance(rec_aux.the_geom, a.the_geom) LIMIT 1;

					-- update values
					UPDATE node SET arc_id=v_newarc WHERE node_id=rec_aux.node_id;
						
				END LOOP;
				
				-- reconnect links
				UPDATE arc SET state=0 WHERE arc_id=arc_id_aux;
				PERFORM gw_fct_connect_to_network(array_agg_connec, 'CONNEC');
				PERFORM gw_fct_connect_to_network(array_agg_gully, 'GULLY');

				-- delete old arc
				DELETE FROM arc WHERE arc_id=arc_id_aux;
						
		
			ELSIF (state_aux=1 AND state_node_arg=2) THEN
				rec_aux1.state=2;
				rec_aux1.state_type=v_ficticius;
				
				rec_aux2.state=2;
				rec_aux2.state_type=v_ficticius;
				
				-- Insert new records into arc table
				UPDATE config_param_system SET value = replace (value, 'true', 'false') WHERE parameter='arc_searchnodes';
				INSERT INTO arc SELECT rec_aux1.*;
				EXECUTE v_querytext1||rec_aux1.arc_id::text||v_querytext2;
				
				INSERT INTO arc SELECT rec_aux2.*;
				EXECUTE v_querytext1||rec_aux2.arc_id::text||v_querytext2;
				
				UPDATE config_param_system SET value = replace (value, 'false', 'true') WHERE parameter='arc_searchnodes';

				-- update node_1 and node_2 because it's not possible to pass using parameters
				UPDATE arc SET node_1=rec_aux1.node_1,node_2=rec_aux1.node_2 where arc_id=rec_aux1.arc_id;
				UPDATE arc SET node_1=rec_aux2.node_1,node_2=rec_aux2.node_2 where arc_id=rec_aux2.arc_id;

				-- Update doability for the new arcs
				UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux1.arc_id;
				UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux2.arc_id;
			
				-- Insert existig arc (on service) to the current alternative
				INSERT INTO plan_psector_x_arc (psector_id, arc_id, state, doable) VALUES (v_psector, arc_id_aux, 0, FALSE);
				
	   
				-- Insert data into traceability table
				INSERT INTO audit_log_arc_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", "user") 
				VALUES ('DIVIDE WITH PLANIFIED NODE',  arc_id_aux, rec_aux1.arc_id, rec_aux2.arc_id, node_id_arg,CURRENT_TIMESTAMP,CURRENT_USER);

				-- Set addparam (parent/child)
				UPDATE plan_psector_x_arc SET addparam='{"arcDivide":"parent"}' WHERE  psector_id=v_psector AND arc_id=arc_id_aux;
				UPDATE plan_psector_x_arc SET addparam='{"arcDivide":"child"}' WHERE  psector_id=v_psector AND arc_id=rec_aux1.arc_id;
				UPDATE plan_psector_x_arc SET addparam='{"arcDivide":"child"}' WHERE  psector_id=v_psector AND arc_id=rec_aux2.arc_id;

					
			ELSIF (state_aux=2 AND state_node_arg=2) THEN 
			
				-- Insert new records into arc table
				UPDATE config_param_system SET value = replace (value, 'true', 'false') WHERE parameter='arc_searchnodes';
				INSERT INTO arc SELECT rec_aux1.*;
				EXECUTE v_querytext1||rec_aux1.arc_id::text||v_querytext2;

				INSERT INTO arc SELECT rec_aux2.*;
				EXECUTE v_querytext1||rec_aux2.arc_id::text||v_querytext2;

				UPDATE config_param_system SET value = replace (value, 'false', 'true') WHERE parameter='arc_searchnodes';


				-- update node_1 and node_2 because it's not possible to pass using parameters
				UPDATE arc SET node_1=rec_aux1.node_1,node_2=rec_aux1.node_2 where arc_id=rec_aux1.arc_id;
				UPDATE arc SET node_1=rec_aux2.node_1,node_2=rec_aux2.node_2 where arc_id=rec_aux2.arc_id;
				
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
				FOR connec_id_aux IN SELECT connec_id FROM connec JOIN link ON link.feature_id=connec_id WHERE link.feature_type='CONNEC' AND arc_id=arc_id_aux
				LOOP
					array_agg_connec:= array_append(array_agg_connec, connec_id_aux);
				END LOOP;
				UPDATE connec SET arc_id=NULL WHERE arc_id=arc_id_aux;

				-- gully
				IF project_type_aux='UD' THEN

					FOR gully_id_aux IN SELECT gully_id FROM gully JOIN link ON link.feature_id=gully_id WHERE link.feature_type='GULLY' AND arc_id=arc_id_aux
					LOOP
						array_agg_gully:= array_append(array_agg_gully, gully_id_aux);
					END LOOP;
					UPDATE gully SET arc_id=NULL WHERE arc_id=arc_id_aux;
				END IF;
							
				-- Insert data into traceability table
				INSERT INTO audit_log_arc_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", "user") 
				VALUES ('DIVIDE PLANIFIED ARC',  arc_id_aux, rec_aux1.arc_id, rec_aux2.arc_id, node_id_arg,CURRENT_TIMESTAMP,CURRENT_USER);
			
				-- Update elements from old arc to new arcs
				FOR rec_aux IN SELECT * FROM element_x_arc WHERE arc_id=arc_id_aux  LOOP
					INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux1.arc_id);
					INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux2.arc_id);
					DELETE FROM element_x_arc WHERE arc_id=arc_id_aux;
				END LOOP;
			
				-- Update documents from old arc to the new arcs
				FOR rec_aux IN SELECT * FROM doc_x_arc WHERE arc_id=arc_id_aux  LOOP
					INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux1.arc_id);
					INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux2.arc_id);
					DELETE FROM doc_x_arc WHERE arc_id=arc_id_aux;

				END LOOP;
			
				-- Visits are not updatable because it's impossible to have visits on arc with state=2
				
				-- Update arc_id on node
				FOR rec_aux IN SELECT * FROM node WHERE arc_id=arc_id_aux  LOOP

					-- find the new arc id
					SELECT arc_id INTO v_newarc FROM v_edit_arc AS a 
					WHERE ST_DWithin(rec_aux.the_geom, a.the_geom, 0.5) AND arc_id !=arc_id_aux ORDER BY ST_Distance(rec_aux.the_geom, a.the_geom) LIMIT 1;

					-- update values
					UPDATE node SET arc_id=v_newarc WHERE node_id=rec_aux.node_id;
						
				END LOOP;
				
				-- in case of divide ficitius arc, new arcs will be ficticius, but we need to set doable false because they are inserted by default as true
				IF (SELECT state_type FROM arc WHERE arc_id=arc_id_aux) = v_ficticius THEN
					UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux1.arc_id;
					UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux2.arc_id;
				END IF;

				-- reconnect links
				UPDATE arc SET state=0 WHERE arc_id=arc_id_aux;
				PERFORM gw_fct_connect_to_network(array_agg_connec, 'CONNEC');
				PERFORM gw_fct_connect_to_network(array_agg_gully, 'GULLY');
                
                -- update arc_id for linked features in psector after reconnect
				UPDATE plan_psector_x_connec a SET arc_id=c.arc_id FROM connec c WHERE c.connec_id=a.connec_id;
				
				IF project_type_aux='UD' THEN
					UPDATE plan_psector_x_gully a SET arc_id=c.arc_id FROM gully c WHERE c.gully_id=a.gully_id;
				END IF;
				
				-- delete old arc
				DELETE FROM arc WHERE arc_id=arc_id_aux;		

			ELSIF (state_aux=2 AND state_node_arg=1) THEN
				RETURN return_aux;		
			ELSE  
				PERFORM audit_function(2120,2114); 
				
			END IF;
		ELSE
			RETURN 0;
		END IF;
	ELSE
		RETURN 0;
	END IF;

	
RETURN return_aux;
 

  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;