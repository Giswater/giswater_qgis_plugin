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
v_node_geom	geometry;
v_arc_id    varchar;
v_arc_geom	geometry;
v_line1		geometry;
v_line2		geometry;
v_intersect_loc	double precision;
v_project_type text;
v_state 	integer;
v_state_node integer;
v_gully_id 	varchar;
v_connec_id 	varchar;
v_return 	smallint;
v_arc_divide_tolerance float =0.05;
v_array_connec varchar [];
v_array_gully varchar [];
v_arc_searchnodes float;
v_newarc	varchar;
v_visitlocation	float;	
v_eventlocation	float;
v_srid		integer;
v_newvisit1	int8;
v_newvisit2 	int8;
v_psector	integer;
v_ficticius	int2;
v_isarcdivide boolean;
v_manquerytext	text;
v_manquerytext1	text;
v_manquerytext2	text;
v_epaquerytext 	text;
v_epaquerytext1	text;
v_epaquerytext2	text;
v_mantable 	text;
v_epatable 	text;
v_schemaname 	text;

rec_visit 	record;
rec_node	record;
rec_event	record;
rec_aux		record;
rec_aux1	"SCHEMA_NAME".arc;
rec_aux2	"SCHEMA_NAME".arc;

BEGIN

-- Search path
    SET search_path = "SCHEMA_NAME", public;
    v_schemaname = 'SCHEMA_NAME';

	-- Get project type
	SELECT wsoftware, epsg INTO v_project_type, v_srid FROM version LIMIT 1;
    
    -- Get node values
    SELECT the_geom INTO v_node_geom FROM node WHERE node_id = node_id_arg;
	SELECT state INTO v_state_node FROM node WHERE node_id=node_id_arg;
	
	IF v_project_type = 'WS' THEN
		SELECT isarcdivide INTO v_isarcdivide FROM node_type JOIN cat_node ON cat_node.nodetype_id=node_type.id JOIN node ON node.nodecat_id = cat_node.id WHERE node.node_id=node_id_arg;
	ELSE
		SELECT isarcdivide INTO v_isarcdivide FROM node_type JOIN node ON node.node_type = node_type.id WHERE node.node_id=node_id_arg;
	END IF;

    -- Get parameters from configs table
	SELECT ((value::json)->>'value') INTO v_arc_searchnodes FROM config_param_system WHERE parameter='arc_searchnodes';
	SELECT value::smallint INTO v_psector FROM config_param_user WHERE "parameter"='psector_vdefault' AND cur_user=current_user;
	SELECT value::smallint INTO v_ficticius FROM config_param_system WHERE parameter='plan_statetype_ficticius';

	
	-- State control
	IF v_state=0 THEN
		PERFORM audit_function(1050,2114);
	ELSIF v_state_node=0 THEN
		PERFORM audit_function(1052,2114);
	END IF;

	-- Control if node divides arc
	IF v_isarcdivide=TRUE THEN 

		-- Check if it's a end/start point node in case of wrong topology without start or end nodes
		SELECT arc_id INTO v_arc_id FROM v_edit_arc WHERE ST_DWithin(ST_startpoint(the_geom), v_node_geom, v_arc_searchnodes) OR ST_DWithin(ST_endpoint(the_geom), v_node_geom, v_arc_searchnodes) LIMIT 1;
		IF v_arc_id IS NOT NULL THEN
			-- force trigger of topology in order to reconnect extremal nodes (in case of null's)
			UPDATE arc SET the_geom=the_geom WHERE arc_id=v_arc_id;
			-- get another arc if exists
			SELECT arc_id INTO v_arc_id FROM v_edit_arc WHERE ST_DWithin(the_geom, v_node_geom, v_arc_searchnodes) AND arc_id != v_arc_id;
		END IF;

		-- For the specificic case of extremal node not reconnected due topology issues (i.e. arc state (1) and node state (2)

		-- Find closest arc inside tolerance
		SELECT arc_id, state, the_geom INTO v_arc_id, v_state, v_arc_geom  FROM v_edit_arc AS a 
		WHERE ST_DWithin(v_node_geom, a.the_geom, v_arc_divide_tolerance) AND node_1 != node_id_arg AND node_2 != node_id_arg
		ORDER BY ST_Distance(v_node_geom, a.the_geom) LIMIT 1;

		IF v_arc_id IS NOT NULL THEN 

			--  Locate position of the nearest point
			v_intersect_loc := ST_LineLocatePoint(v_arc_geom, v_node_geom);
			
			-- Compute pieces
			v_line1 := ST_LineSubstring(v_arc_geom, 0.0, v_intersect_loc);
			v_line2 := ST_LineSubstring(v_arc_geom, v_intersect_loc, 1.0);
		
			-- Check if any of the 'lines' are in fact a point
			IF (ST_GeometryType(v_line1) = 'ST_Point') OR (ST_GeometryType(v_line2) = 'ST_Point') THEN
				RETURN 1;
			END IF;
		
			-- Get arc data
			SELECT * INTO rec_aux1 FROM arc WHERE arc_id = v_arc_id;
			SELECT * INTO rec_aux2 FROM arc WHERE arc_id = v_arc_id;

			-- Update values of new arc_id (1)
			rec_aux1.arc_id := nextval('SCHEMA_NAME.urn_id_seq');
			rec_aux1.code := rec_aux1.arc_id;
			rec_aux1.node_2 := node_id_arg ;-- rec_aux1.node_1 take values from original arc
			rec_aux1.the_geom := v_line1;

			-- Update values of new arc_id (2)
			rec_aux2.arc_id := nextval('SCHEMA_NAME.urn_id_seq');
			rec_aux2.code := rec_aux2.arc_id;
			rec_aux2.node_1 := node_id_arg; -- rec_aux2.node_2 take values from original arc
			rec_aux2.the_geom := v_line2;

			-- getting table child information (man_table)
			v_mantable = (SELECT man_table FROM arc_type JOIN v_edit_arc ON id=arc_type WHERE arc_id=v_arc_id);
			v_epatable = (SELECT epa_table FROM arc_type JOIN v_edit_arc ON id=arc_type WHERE arc_id=v_arc_id);

			-- building querytext for man_table
			v_manquerytext:= (SELECT replace (replace (array_agg(column_name::text)::text,'{',','),'}','') FROM information_schema.columns WHERE table_name=v_mantable AND table_schema=v_schemaname AND column_name !='arc_id');
			IF  v_manquerytext IS NULL THEN 
				v_manquerytext='';
			END IF;
			v_manquerytext1 =  'INSERT INTO '||v_mantable||' SELECT ';
			v_manquerytext2 =  v_manquerytext||' FROM '||v_mantable||' WHERE arc_id= '||v_arc_id||'::text';

			-- building querytext for epa_table
			v_epaquerytext:= (SELECT replace (replace (array_agg(column_name::text)::text,'{',','),'}','') FROM information_schema.columns WHERE table_name=v_epatable AND table_schema=v_schemaname AND column_name !='arc_id');
			IF  v_epaquerytext IS NULL THEN 
				v_epaquerytext='';
			END IF;
			v_epaquerytext1 =  'INSERT INTO '||v_epatable||' SELECT ';
			v_epaquerytext2 =  v_epaquerytext||' FROM '||v_epatable||' WHERE arc_id= '||v_arc_id||'::text';

			-- In function of states and user's variables proceed.....
			IF (v_state=1 AND v_state_node=1) THEN 
			
				-- Insert new records into arc table
				INSERT INTO arc SELECT rec_aux1.*;
				INSERT INTO arc SELECT rec_aux2.*;

				-- insert new records into man_table
				EXECUTE v_manquerytext1||rec_aux1.arc_id::text||v_manquerytext2;
				EXECUTE v_manquerytext1||rec_aux2.arc_id::text||v_manquerytext2;

				-- insert new records into epa_table
				EXECUTE v_epaquerytext1||rec_aux1.arc_id::text||v_epaquerytext2;
				EXECUTE v_epaquerytext1||rec_aux2.arc_id::text||v_epaquerytext2;

				-- update node_1 and node_2 because it's not possible to pass using parameters
				UPDATE arc SET node_1=rec_aux1.node_1,node_2=rec_aux1.node_2 where arc_id=rec_aux1.arc_id;
				UPDATE arc SET node_1=rec_aux2.node_1,node_2=rec_aux2.node_2 where arc_id=rec_aux2.arc_id;
				
				--Copy addfields from old arc to new arcs	
				INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
				SELECT 
				rec_aux2.arc_id,
				parameter_id,
				value_param
				FROM man_addfields_value WHERE feature_id=v_arc_id;
				
				INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
				SELECT 
				rec_aux1.arc_id,
				parameter_id,
				value_param
				FROM man_addfields_value WHERE feature_id=v_arc_id;
				
				-- update arc_id of disconnected nodes linked to old arc
				FOR rec_node IN SELECT node_id, the_geom FROM node WHERE arc_id=v_arc_id
				LOOP
					UPDATE node SET arc_id=(SELECT arc_id FROM v_edit_arc WHERE ST_DWithin(rec_node.the_geom, 
					v_edit_arc.the_geom,0.001) AND arc_id != v_arc_id LIMIT 1) 
					WHERE node_id=rec_node.node_id;
				END LOOP;

				-- Capture linked feature information to redraw (later on this function)
				-- connec
				FOR v_connec_id IN SELECT connec_id FROM connec JOIN link ON link.feature_id=connec_id WHERE link.feature_type='CONNEC' AND arc_id=v_arc_id
				LOOP
					v_array_connec:= array_append(v_array_connec, v_connec_id);
				END LOOP;
				UPDATE connec SET arc_id=NULL WHERE arc_id=v_arc_id;

				-- gully
				IF v_project_type='UD' THEN

					FOR v_gully_id IN SELECT gully_id FROM gully JOIN link ON link.feature_id=gully_id WHERE link.feature_type='GULLY' AND arc_id=v_arc_id
					LOOP
						v_array_gully:= array_append(v_array_gully, v_gully_id);
					END LOOP;
					UPDATE gully SET arc_id=NULL WHERE arc_id=v_arc_id;
				END IF;
						
				-- Insert data into traceability table
				INSERT INTO audit_log_arc_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", "user") 
				VALUES ('DIVIDE ARC',  v_arc_id, rec_aux1.arc_id, rec_aux2.arc_id, node_id_arg,CURRENT_TIMESTAMP,CURRENT_USER);
			
				-- Update elements from old arc to new arcs
				FOR rec_aux IN SELECT * FROM element_x_arc WHERE arc_id=v_arc_id  LOOP
					DELETE FROM element_x_arc WHERE arc_id=v_arc_id;
					INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux1.arc_id);
					INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux2.arc_id);
				END LOOP;
			
				-- Update documents from old arc to the new arcs
				FOR rec_aux IN SELECT * FROM doc_x_arc WHERE arc_id=v_arc_id  LOOP
					DELETE FROM doc_x_arc WHERE arc_id=v_arc_id;
					INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux1.arc_id);
					INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux2.arc_id);

				END LOOP;

				-- Update visits from old arc to the new arcs (only for state=1, state=1)
				FOR rec_visit IN SELECT om_visit.* FROM om_visit_x_arc JOIN om_visit ON om_visit.id=visit_id WHERE arc_id=v_arc_id LOOP

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
								v_eventlocation := ST_LineLocatePoint(v_arc_geom, ST_ClosestPoint(v_arc_geom, ST_setSrid(ST_MakePoint(rec_event.xcoord, rec_event.ycoord), v_srid)));
								
								IF v_eventlocation < v_intersect_loc THEN
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
						v_visitlocation := ST_LineLocatePoint(v_arc_geom, ST_ClosestPoint(v_arc_geom, rec_visit.the_geom));
						
						IF v_visitlocation < v_intersect_loc THEN
							v_newarc = rec_aux1.arc_id;
						ELSE
							v_newarc = rec_aux2.arc_id;
						END IF;
					
						-- distribute visit to new arc
						INSERT INTO om_visit_x_arc (id, visit_id, arc_id) VALUES (nextval('om_visit_x_arc_id_seq'),rec_visit.id, v_newarc);
						DELETE FROM om_visit_x_arc WHERE arc_id=v_arc_id;
					END IF;
				END LOOP;

				-- Update arc_id on node
				FOR rec_aux IN SELECT * FROM node WHERE arc_id=v_arc_id  LOOP

					-- find the new arc id
					SELECT arc_id INTO v_newarc FROM v_edit_arc AS a 
					WHERE ST_DWithin(rec_aux.the_geom, a.the_geom, 0.5) AND arc_id !=v_arc_id ORDER BY ST_Distance(rec_aux.the_geom, a.the_geom) LIMIT 1;

					-- update values
					UPDATE node SET arc_id=v_newarc WHERE node_id=rec_aux.node_id;
						
				END LOOP;
				
				-- reconnect links
				UPDATE arc SET state=0 WHERE arc_id=v_arc_id;
				PERFORM gw_fct_connect_to_network(v_array_connec, 'CONNEC');
				PERFORM gw_fct_connect_to_network(v_array_gully, 'GULLY');

				-- delete old arc
				DELETE FROM arc WHERE arc_id=v_arc_id;
						
		
			ELSIF (v_state=1 AND v_state_node=2) THEN
				rec_aux1.state=2;
				rec_aux1.state_type=v_ficticius;
				
				rec_aux2.state=2;
				rec_aux2.state_type=v_ficticius;
				
				UPDATE config_param_system SET value = replace (value, 'true', 'false') WHERE parameter='arc_searchnodes';

				-- Insert new records into arc table
				INSERT INTO arc SELECT rec_aux1.*;
				INSERT INTO arc SELECT rec_aux2.*;

				-- Insert new records into man table		
				EXECUTE v_manquerytext1||rec_aux1.arc_id::text||v_manquerytext2;
				EXECUTE v_manquerytext1||rec_aux2.arc_id::text||v_manquerytext2;

				-- Insert new records into epa table
				EXECUTE v_epaquerytext1||rec_aux1.arc_id::text||v_epaquerytext2;
				EXECUTE v_epaquerytext1||rec_aux2.arc_id::text||v_epaquerytext2;
				
				UPDATE config_param_system SET value = replace (value, 'false', 'true') WHERE parameter='arc_searchnodes';

				-- update node_1 and node_2 because it's not possible to pass using parameters
				UPDATE arc SET node_1=rec_aux1.node_1,node_2=rec_aux1.node_2 where arc_id=rec_aux1.arc_id;
				UPDATE arc SET node_1=rec_aux2.node_1,node_2=rec_aux2.node_2 where arc_id=rec_aux2.arc_id;

				-- Update doability for the new arcs
				UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux1.arc_id;
				UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux2.arc_id;
			
				-- Insert existig arc (on service) to the current alternative
				INSERT INTO plan_psector_x_arc (psector_id, arc_id, state, doable) VALUES (v_psector, v_arc_id, 0, FALSE);
				
	   
				-- Insert data into traceability table
				INSERT INTO audit_log_arc_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", "user") 
				VALUES ('DIVIDE WITH PLANIFIED NODE',  v_arc_id, rec_aux1.arc_id, rec_aux2.arc_id, node_id_arg,CURRENT_TIMESTAMP,CURRENT_USER);

				-- Set addparam (parent/child)
				UPDATE plan_psector_x_arc SET addparam='{"arcDivide":"parent"}' WHERE  psector_id=v_psector AND arc_id=v_arc_id;
				UPDATE plan_psector_x_arc SET addparam='{"arcDivide":"child"}' WHERE  psector_id=v_psector AND arc_id=rec_aux1.arc_id;
				UPDATE plan_psector_x_arc SET addparam='{"arcDivide":"child"}' WHERE  psector_id=v_psector AND arc_id=rec_aux2.arc_id;

					
			ELSIF (v_state=2 AND v_state_node=2) THEN 
			
				UPDATE config_param_system SET value = replace (value, 'true', 'false') WHERE parameter='arc_searchnodes';

				-- Insert new records into arc table
				INSERT INTO arc SELECT rec_aux1.*;
				INSERT INTO arc SELECT rec_aux2.*;

				-- Insert new records into man table		
				EXECUTE v_manquerytext1||rec_aux1.arc_id::text||v_manquerytext2;
				EXECUTE v_manquerytext1||rec_aux2.arc_id::text||v_manquerytext2;

				-- Insert new records into epa table
				EXECUTE v_epaquerytext1||rec_aux1.arc_id::text||v_epaquerytext2;
				EXECUTE v_epaquerytext1||rec_aux2.arc_id::text||v_epaquerytext2;

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
				FROM man_addfields_value WHERE feature_id=v_arc_id;
				
				INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
				SELECT 
				rec_aux1.arc_id,
				parameter_id,
				value_param
				FROM man_addfields_value WHERE feature_id=v_arc_id;
				
				-- update arc_id of disconnected nodes linked to old arc
				FOR rec_node IN SELECT node_id, the_geom FROM node WHERE arc_id=v_arc_id
				LOOP
					UPDATE node SET arc_id=(SELECT arc_id FROM v_edit_arc WHERE ST_DWithin(rec_node.the_geom, 
					v_edit_arc.the_geom,0.001) AND arc_id != v_arc_id LIMIT 1) 
					WHERE node_id=rec_node.node_id;
				END LOOP;

				-- Capture linked feature information to redraw (later on this function)
				-- connec
				FOR v_connec_id IN SELECT connec_id FROM connec JOIN link ON link.feature_id=connec_id WHERE link.feature_type='CONNEC' AND arc_id=v_arc_id
				LOOP
					v_array_connec:= array_append(v_array_connec, v_connec_id);
				END LOOP;
				UPDATE connec SET arc_id=NULL WHERE arc_id=v_arc_id;

				-- gully
				IF v_project_type='UD' THEN

					FOR v_gully_id IN SELECT gully_id FROM gully JOIN link ON link.feature_id=gully_id WHERE link.feature_type='GULLY' AND arc_id=v_arc_id
					LOOP
						v_array_gully:= array_append(v_array_gully, v_gully_id);
					END LOOP;
					UPDATE gully SET arc_id=NULL WHERE arc_id=v_arc_id;
				END IF;
							
				-- Insert data into traceability table
				INSERT INTO audit_log_arc_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", "user") 
				VALUES ('DIVIDE PLANIFIED ARC',  v_arc_id, rec_aux1.arc_id, rec_aux2.arc_id, node_id_arg,CURRENT_TIMESTAMP,CURRENT_USER);
			
				-- Update elements from old arc to new arcs
				FOR rec_aux IN SELECT * FROM element_x_arc WHERE arc_id=v_arc_id  LOOP
					INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux1.arc_id);
					INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux2.arc_id);
					DELETE FROM element_x_arc WHERE arc_id=v_arc_id;
				END LOOP;
			
				-- Update documents from old arc to the new arcs
				FOR rec_aux IN SELECT * FROM doc_x_arc WHERE arc_id=v_arc_id  LOOP
					INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux1.arc_id);
					INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux2.arc_id);
					DELETE FROM doc_x_arc WHERE arc_id=v_arc_id;

				END LOOP;
			
				-- Visits are not updatable because it's impossible to have visits on arc with state=2
				
				-- Update arc_id on node
				FOR rec_aux IN SELECT * FROM node WHERE arc_id=v_arc_id  LOOP

					-- find the new arc id
					SELECT arc_id INTO v_newarc FROM v_edit_arc AS a 
					WHERE ST_DWithin(rec_aux.the_geom, a.the_geom, 0.5) AND arc_id !=v_arc_id ORDER BY ST_Distance(rec_aux.the_geom, a.the_geom) LIMIT 1;

					-- update values
					UPDATE node SET arc_id=v_newarc WHERE node_id=rec_aux.node_id;
						
				END LOOP;
				
				-- in case of divide ficitius arc, new arcs will be ficticius, but we need to set doable false because they are inserted by default as true
				IF (SELECT state_type FROM arc WHERE arc_id=v_arc_id) = v_ficticius THEN
					UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux1.arc_id;
					UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux2.arc_id;
				END IF;

				-- reconnect links
				UPDATE arc SET state=0 WHERE arc_id=v_arc_id;
				PERFORM gw_fct_connect_to_network(v_array_connec, 'CONNEC');
				PERFORM gw_fct_connect_to_network(v_array_gully, 'GULLY');
                
                -- update arc_id for linked features in psector after reconnect
				UPDATE plan_psector_x_connec a SET arc_id=c.arc_id FROM connec c WHERE c.connec_id=a.connec_id;
				
				IF v_project_type='UD' THEN
					UPDATE plan_psector_x_gully a SET arc_id=c.arc_id FROM gully c WHERE c.gully_id=a.gully_id;
				END IF;
				
				-- delete old arc
				DELETE FROM arc WHERE arc_id=v_arc_id;		

			ELSIF (v_state=2 AND v_state_node=1) THEN
				RETURN v_return;		
			ELSE  
				PERFORM audit_function(2120,2114); 
				
			END IF;
		ELSE
			RETURN 0;
		END IF;
	ELSE
		RETURN 0;
	END IF;

	
RETURN v_return;
 

  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;