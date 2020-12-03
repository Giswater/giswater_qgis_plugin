/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2114

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_arc_divide(character varying);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_arc_divide(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setarcdivide(p_data json) RETURNS json AS
$BODY$

/*

SELECT SCHEMA_NAME.gw_fct_setarcdivide($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"id":["269951"]},
"data":{}}$$)

-- fid: 212

*/

DECLARE
v_node_geom public.geometry;
v_arc_id varchar;
v_code varchar;
v_arc_geom public.geometry;
v_line1 public.geometry;
v_line2 public.geometry;
v_intersect_loc	double precision;
v_project_type text;
v_state_arc integer;
v_state_node integer;
v_gully_id 	varchar;
v_connec_id varchar;
v_return smallint;
v_arc_divide_tolerance float =0.05;
v_array_connec varchar [];
v_array_gully varchar [];
v_arc_searchnodes float;
v_newarc varchar;
v_visitlocation	float;	
v_eventlocation	float;
v_srid integer;
v_newvisit1	int8;
v_newvisit2	int8;
v_psector integer;
v_ficticius	int2;
v_isarcdivide boolean;
v_manquerytext text;
v_manquerytext1	text;
v_manquerytext2	text;
v_epaquerytext text;
v_epaquerytext1	text;
v_epaquerytext2	text;
v_mantable text;
v_epatable text;
v_schemaname text;
v_node_type text;
v_version text;
v_arc_code text;
v_count integer;
v_count_connec integer=0;
v_count_gully integer=0;

rec_visit record;
rec_node record;
rec_event record;
rec_aux	 record;
rec_aux1 "SCHEMA_NAME".arc;
rec_aux2 "SCHEMA_NAME".arc;
rec_table	record;
v_query_string  text;
v_max_seq_id	int8;

v_result text;
v_result_info text;
v_result_point text;
v_result_line text;
v_result_polygon text;
v_error_context text;
v_audit_result text;
v_level integer;
v_status text;
v_message text;
v_hide_form boolean;
v_array_node_id json;
v_node_id text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	--set current process as users parameter
	DELETE FROM config_param_user  WHERE  parameter = 'utils_cur_trans' AND cur_user =current_user;

	INSERT INTO config_param_user (value, parameter, cur_user)
	VALUES (txid_current(),'utils_cur_trans',current_user );
   
	-- Get parameters from input json
	v_array_node_id = lower(((p_data ->>'feature')::json->>'id')::text);

	v_node_id = (SELECT json_array_elements_text(v_array_node_id)); 
	-- Get project type
	SELECT project_type, epsg, giswater INTO v_project_type, v_srid,v_version FROM sys_version LIMIT 1;
	
	-- set sequences
	FOR rec_table IN SELECT * FROM sys_table WHERE sys_sequence IS NOT NULL AND sys_sequence_field IS NOT NULL AND sys_sequence LIKE '%visit%'
	LOOP 
		v_query_string:= 'SELECT max('||rec_table.sys_sequence_field||') FROM '||rec_table.id||';' ;
		EXECUTE v_query_string INTO v_max_seq_id;	
		IF v_max_seq_id IS NOT NULL AND v_max_seq_id > 0 THEN 
			EXECUTE 'SELECT setval(''SCHEMA_NAME.'||rec_table.sys_sequence||' '','||v_max_seq_id||', true)';			
		END IF;
	END LOOP;

	-- Get node values
	SELECT the_geom INTO v_node_geom FROM node WHERE node_id = v_node_id;
	SELECT state INTO v_state_node FROM node WHERE node_id=v_node_id;
	
	IF v_project_type = 'WS' THEN
		SELECT isarcdivide, cat_feature_node.id INTO v_isarcdivide, v_node_type 
		FROM cat_feature_node JOIN cat_node ON cat_node.nodetype_id=cat_feature_node.id 
		JOIN node ON node.nodecat_id = cat_node.id WHERE node.node_id=v_node_id;
	ELSE
		SELECT isarcdivide, cat_feature_node.id INTO v_isarcdivide, v_node_type 
		FROM cat_feature_node JOIN node ON node.node_type = cat_feature_node.id WHERE node.node_id=v_node_id;
	END IF;

	-- get arc values
	select code INTO v_code FROM v_edit_arc  WHERE arc_id=v_arc_id;

	-- Get parameters from configs table
	SELECT ((value::json)->>'value') INTO v_arc_searchnodes FROM config_param_system WHERE parameter='edit_arc_searchnodes';
	SELECT value::smallint INTO v_psector FROM config_param_user WHERE "parameter"='plan_psector_vdefault' AND cur_user=current_user;
	SELECT value::smallint INTO v_ficticius FROM config_param_system WHERE parameter='plan_statetype_ficticius';
	SELECT value::boolean INTO v_hide_form FROM config_param_user where parameter='qgis_form_log_hidden' AND cur_user=current_user;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=212 AND cur_user=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (212, null, 4, 'ARC DIVIDE');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (212, null, 4, '-------------------------------------------------------------');

	-- State control
	IF v_state_arc=0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"1050", "function":"2114","debug_msg":null}}$$);' INTO v_audit_result;
	ELSIF v_state_node=0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"1052", "function":"2114","debug_msg":null}}$$);' INTO v_audit_result;
	ELSE

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
			SELECT arc_id, state, the_geom INTO v_arc_id, v_state_arc, v_arc_geom  FROM v_edit_arc AS a 
			WHERE ST_DWithin(v_node_geom, a.the_geom, v_arc_divide_tolerance) AND node_1 != v_node_id AND node_2 != v_node_id
			ORDER BY ST_Distance(v_node_geom, a.the_geom) LIMIT 1;

			IF v_arc_id IS NOT NULL THEN 

				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (212, 1, concat('Divide arc ', v_arc_id,'.'));

				--  Locate position of the nearest point
				v_intersect_loc := ST_LineLocatePoint(v_arc_geom, v_node_geom);
				
				-- Compute pieces
				v_line1 := ST_LineSubstring(v_arc_geom, 0.0, v_intersect_loc);
				v_line2 := ST_LineSubstring(v_arc_geom, v_intersect_loc, 1.0);
			
				-- Check if any of the 'lines' are in fact a point
				IF (ST_GeometryType(v_line1) = 'ST_Point') OR (ST_GeometryType(v_line2) = 'ST_Point') THEN

					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3094", "function":"2114","debug_msg":null}}$$);' INTO v_audit_result;
				ELSE

					-- Get arc data
					SELECT * INTO rec_aux1 FROM arc WHERE arc_id = v_arc_id;
					SELECT * INTO rec_aux2 FROM arc WHERE arc_id = v_arc_id;

					-- Update values of new arc_id (1)
					rec_aux1.arc_id := nextval('SCHEMA_NAME.urn_id_seq');
					rec_aux1.code := rec_aux1.arc_id;
					rec_aux1.node_2 := v_node_id ;-- rec_aux1.node_1 take values from original arc
					rec_aux1.the_geom := v_line1;

					-- Update values of new arc_id (2)
					rec_aux2.arc_id := nextval('SCHEMA_NAME.urn_id_seq');
					rec_aux2.code := rec_aux2.arc_id;
					rec_aux2.node_1 := v_node_id; -- rec_aux2.node_2 take values from original arc
					rec_aux2.the_geom := v_line2;

					-- getting table child information (man_table)
					v_mantable = (SELECT man_table FROM cat_feature_arc JOIN v_edit_arc ON id=arc_type WHERE arc_id=v_arc_id);
					v_epatable = (SELECT epa_table FROM cat_feature_arc JOIN v_edit_arc ON id=arc_type WHERE arc_id=v_arc_id);

					-- building querytext for man_table
					v_manquerytext:= (SELECT replace (replace (array_agg(column_name::text)::text,'{',','),'}','') FROM (SELECT column_name FROM information_schema.columns 
					WHERE table_name=v_mantable AND table_schema=v_schemaname AND column_name !='arc_id' ORDER BY ordinal_position)a);
					IF  v_manquerytext IS NULL THEN 
						v_manquerytext='';
					END IF;
					v_manquerytext1 =  'INSERT INTO '||v_mantable||' SELECT ';
					v_manquerytext2 =  v_manquerytext||' FROM '||v_mantable||' WHERE arc_id= '||v_arc_id||'::text';

					-- building querytext for epa_table
					v_epaquerytext:= (SELECT replace (replace (array_agg(column_name::text)::text,'{',','),'}','') FROM (SELECT column_name FROM information_schema.columns 
					WHERE table_name=v_epatable AND table_schema=v_schemaname AND column_name !='arc_id' ORDER BY ordinal_position)a);				
					IF  v_epaquerytext IS NULL THEN 
						v_epaquerytext='';
					END IF;
					v_epaquerytext1 =  'INSERT INTO '||v_epatable||' SELECT ';
					v_epaquerytext2 =  v_epaquerytext||' FROM '||v_epatable||' WHERE arc_id= '||v_arc_id||'::text';


					-- In function of states and user's variables proceed.....
					IF v_state_node=1 THEN 

						-- Insert new records into arc table
						INSERT INTO arc SELECT rec_aux1.*;
						INSERT INTO arc SELECT rec_aux2.*;

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Insert new arcs into arc table.');

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1, concat('Arc1: arc_id:', rec_aux1.arc_id,', code:',rec_aux1.code,' length:',
						round(st_length(rec_aux1.the_geom)::numeric,2),'.'));
						
						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1, concat('Arc1: arc_id:', rec_aux2.arc_id,', code:',rec_aux2.code,' length:',
						round(st_length(rec_aux2.the_geom)::numeric,2),'.'));

						-- insert new records into man_table
						EXECUTE v_manquerytext1||rec_aux1.arc_id::text||v_manquerytext2;
						EXECUTE v_manquerytext1||rec_aux2.arc_id::text||v_manquerytext2;

						-- insert new records into epa_table
						EXECUTE v_epaquerytext1||rec_aux1.arc_id::text||v_epaquerytext2;
						EXECUTE v_epaquerytext1||rec_aux2.arc_id::text||v_epaquerytext2;

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1, 'Insert new arcs into man and epa table.');

						-- update node_1 and node_2 because it's not possible to pass using parameters
						UPDATE arc SET node_1=rec_aux1.node_1,node_2=rec_aux1.node_2 where arc_id=rec_aux1.arc_id;
						UPDATE arc SET node_1=rec_aux2.node_1,node_2=rec_aux2.node_2 where arc_id=rec_aux2.arc_id;
						
						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Update values of arcs node_1 and node_2.');

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

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Copy addfields from old to new arcs.');

						-- update arc_id of disconnected nodes linked to old arc
						FOR rec_node IN SELECT node_id, the_geom FROM node WHERE arc_id=v_arc_id
						LOOP
							UPDATE node SET arc_id=(SELECT arc_id FROM v_edit_arc WHERE ST_DWithin(rec_node.the_geom, 
							v_edit_arc.the_geom,0.001) AND arc_id != v_arc_id LIMIT 1) 
							WHERE node_id=rec_node.node_id;
							
							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (212, 1,concat('Update arc_id for disconnected node: ',rec_node.node_id,'.'));
						END LOOP;

						-- Capture linked feature information to redraw (later on this function)
						-- connec
						FOR v_connec_id IN 
						SELECT connec_id FROM connec JOIN link ON link.feature_id=connec_id WHERE link.feature_type='CONNEC' AND arc_id=v_arc_id AND 
						connec.state=1
						LOOP
							v_array_connec:= array_append(v_array_connec, v_connec_id);
						END LOOP;

						SELECT count(connec_id) INTO v_count_connec FROM connec WHERE arc_id=v_arc_id AND state=1;

						UPDATE connec SET arc_id=NULL WHERE arc_id=v_arc_id;

						-- gully
						IF v_project_type='UD' THEN

							FOR v_gully_id IN SELECT gully_id FROM gully JOIN link ON link.feature_id=gully_id WHERE link.feature_type='GULLY' AND arc_id=v_arc_id  AND 
								gully.state=1
							LOOP
								v_array_gully:= array_append(v_array_gully, v_gully_id);
							END LOOP;

							SELECT count(gully_id) INTO v_count_gully FROM gully WHERE arc_id=v_arc_id AND state=1;

							UPDATE gully SET arc_id=NULL WHERE arc_id=v_arc_id;
						END IF;
								
						-- Insert data into traceability table
						select code INTO v_code FROM v_edit_arc  WHERE arc_id=v_arc_id;

						INSERT INTO audit_arc_traceability ("type", arc_id, code,arc_id1, arc_id2, node_id, tstamp, cur_user) 
						VALUES ('DIVIDE ARC',  v_arc_id, v_code, rec_aux1.arc_id, rec_aux2.arc_id, v_node_id,CURRENT_TIMESTAMP,CURRENT_USER);

						-- Update elements from old arc to new arcs
						SELECT count(id) into v_count FROM element_x_arc WHERE arc_id=v_arc_id;

						IF v_count > 0 THEN
							FOR rec_aux IN SELECT * FROM element_x_arc WHERE arc_id=v_arc_id  LOOP
								INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux1.arc_id);
								INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux2.arc_id);
								DELETE FROM element_x_arc WHERE arc_id=v_arc_id;
							END LOOP;

							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (212, 1, concat('Copy ',v_count,' elements from old to new arcs.'));
						END IF;
					
						-- Update documents from old arc to the new arcs
						SELECT count(id) into v_count FROM doc_x_arc WHERE arc_id=v_arc_id;
						IF v_count > 0 THEN
							FOR rec_aux IN SELECT * FROM doc_x_arc WHERE arc_id=v_arc_id  LOOP
								INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux1.arc_id);
								INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux2.arc_id);
								DELETE FROM doc_x_arc WHERE arc_id=v_arc_id;
							END LOOP;
						
							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (212, 1, concat('Copy ',v_count,' documents from old to new arcs.'));
						END IF;

						-- Update visits from old arc to the new arcs (only for state=1, state=1)
						SELECT count(id) INTO v_count FROM om_visit_x_arc WHERE arc_id=v_arc_id;

						IF v_count > 0 THEN
							FOR rec_visit IN SELECT om_visit.* FROM om_visit_x_arc JOIN om_visit ON om_visit.id=visit_id WHERE arc_id=v_arc_id LOOP

								IF rec_visit.the_geom IS NULL AND rec_visit.id IS NOT NULL THEN -- if visit does not has geometry, events may have. It's mandatory to distribute one by one

									-- Get visit data into two new visits
									INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, webclient_id,expl_id,descript,is_done, lot_id, class_id, status, visit_type)
									VALUES (rec_visit.visitcat_id, rec_visit.ext_code, rec_visit.startdate, rec_visit.enddate, rec_visit.user_name, rec_visit.webclient_id, rec_visit.expl_id,
									rec_visit.descript, rec_visit.is_done, rec_visit.lot_id, rec_visit.class_id, rec_visit.status, rec_visit.visit_type)
									RETURNING id INTO v_newvisit1;

									INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, webclient_id,expl_id,descript,is_done, lot_id, class_id, status, visit_type)
									VALUES (rec_visit.visitcat_id, rec_visit.ext_code, rec_visit.startdate, rec_visit.enddate, rec_visit.user_name, rec_visit.webclient_id, rec_visit.expl_id,
									rec_visit.descript, rec_visit.is_done, rec_visit.lot_id, rec_visit.class_id, rec_visit.status, rec_visit.visit_type)
									RETURNING id INTO v_newvisit2;
									
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
										
											-- insert new event related to new visit1
											INSERT INTO om_visit_event (event_code, visit_id, position_id, position_value, parameter_id,value, value1, value2,geom1, geom2, 
											geom3,xcoord,ycoord,compass,text, index_val,is_last) 
											SELECT event_code, v_newvisit1, position_id, position_value, parameter_id,value, value1, value2,geom1, geom2, 
											geom3,xcoord,ycoord,compass,text, index_val,is_last FROM om_visit_event WHERE id=rec_event.id;	
											
											-- insert new event related to new visit2
											INSERT INTO om_visit_event (event_code, visit_id, position_id, position_value, parameter_id,value, value1, value2,geom1, geom2, 
											geom3,xcoord,ycoord,compass,text, index_val,is_last) 
											SELECT event_code, v_newvisit2, position_id, position_value, parameter_id,value, value1, value2,geom1, geom2, 
											geom3,xcoord,ycoord,compass,text, index_val,is_last FROM om_visit_event WHERE id=rec_event.id;
										END IF;
									END LOOP;
																
									INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES (v_newvisit1, rec_aux1.arc_id);
									INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES (v_newvisit2, rec_aux2.arc_id);
								
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
									INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES (rec_visit.id, v_newarc);
									DELETE FROM om_visit_x_arc WHERE arc_id=v_arc_id;
								END IF;
							END LOOP;

							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (212, 1, concat('Copy ',v_count,' visits from old to new arcs.'));

						END IF;
						
						-- Update arc_id on node
						FOR rec_aux IN SELECT * FROM node WHERE arc_id=v_arc_id  LOOP

							-- find the new arc id
							SELECT arc_id INTO v_newarc FROM v_edit_arc AS a 
							WHERE ST_DWithin(rec_aux.the_geom, a.the_geom, 0.5) AND arc_id !=v_arc_id ORDER BY ST_Distance(rec_aux.the_geom, a.the_geom) LIMIT 1;

							-- update values
							UPDATE node SET arc_id=v_newarc WHERE node_id=rec_aux.node_id;
								
						END LOOP;

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1, 'Update arc_id on node.');
			
						-- reconnect links
						UPDATE arc SET state=0 WHERE arc_id=v_arc_id;

						IF v_count_connec > 0  AND v_array_connec IS NOT NULL THEN
							EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
							"feature":{"id":'|| array_to_json(v_array_connec)||'},"data":{"feature_type":"CONNEC"}}$$)';

							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (212, 1, concat('Reconnect ',v_count_connec,' connecs with state 1.'));
						END IF;
						IF v_count_gully > 0 AND v_array_gully IS NOT NULL THEN
							EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
							"feature":{"id":'|| array_to_json(v_array_gully)||'},"data":{"feature_type":"GULLY"}}$$)';

							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (212, 1, concat('Reconnect ',v_count_gully,' gullies with state 1.'));
						END IF;

						-- delete old arc
						DELETE FROM arc WHERE arc_id=v_arc_id;
						
						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1, concat('Delete old arc: ',v_arc_id,'.'));

				
					ELSIF v_state_node = 2 THEN --is psector

						-- set temporary values for config variables in order to enable the insert of arc in spite of due a 'bug' of postgres (it seems that does not recognize the new node inserted)
						UPDATE config_param_user SET value=TRUE WHERE parameter = 'edit_disable_statetopocontrol' AND cur_user=current_user;				

						IF v_state_arc=1 THEN -- ficticius arc

							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (212, 1, 'Arc with state =1, node with state = 2.');
											
							rec_aux1.state=2;
							rec_aux1.state_type=v_ficticius;
							
							rec_aux2.state=2;
							rec_aux2.state_type=v_ficticius;
							
						ELSIF v_state_arc = 2 THEN -- planned arc

							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (212, 1, 'Arc and node have both state = 2.');

						END IF;

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Insert new arcs into arc table.');

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1, concat('Arc1: arc_id:', rec_aux1.arc_id,', code:',rec_aux1.code,' length:',
						round(st_length(rec_aux1.the_geom)::numeric,2),'.'));
							
						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1, concat('Arc2: arc_id:', rec_aux2.arc_id,', code:',rec_aux2.code,' length:',
						round(st_length(rec_aux2.the_geom)::numeric,2),'.'));

						-- Insert new records into arc table
						INSERT INTO arc SELECT rec_aux1.*;
						INSERT INTO arc SELECT rec_aux2.*;

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Insert new arcs into man and epa table.');

						-- Insert new records into man table		
						EXECUTE v_manquerytext1||rec_aux1.arc_id::text||v_manquerytext2;
						EXECUTE v_manquerytext1||rec_aux2.arc_id::text||v_manquerytext2;

						-- Insert new records into epa table
						EXECUTE v_epaquerytext1||rec_aux1.arc_id::text||v_epaquerytext2;
						EXECUTE v_epaquerytext1||rec_aux2.arc_id::text||v_epaquerytext2;

						-- restore temporary value for edit_disable_statetopocontrol variable
						UPDATE config_param_user SET value=FALSE WHERE parameter = 'edit_disable_statetopocontrol' AND cur_user=current_user;

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Update values of arcs node_1 and node_2.');

						-- update node_1 and node_2 because it's not possible to pass using parameters
						UPDATE arc SET node_1=rec_aux1.node_1,node_2=rec_aux1.node_2 where arc_id=rec_aux1.arc_id;
						UPDATE arc SET node_1=rec_aux2.node_1,node_2=rec_aux2.node_2 where arc_id=rec_aux2.arc_id;

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Insert new values from new arcs into addfields table.');
						
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
						
						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Copy elements is not avaliable from old arc to new arc when node.state = 2');

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Copy documents is not avaliable from old arc to new arcs when node.state = 2');

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Copy visits is not avaliable from old arc to new arcs when node.state = 2');

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Reconnect disconnected nodes on this alternative');

						IF v_project_type='WS' THEN
							-- reconnect nodes (update arc_id of disconnected nodes linked to old arc)
							FOR rec_node IN SELECT node_id, the_geom FROM v_edit_node WHERE arc_id=v_arc_id AND state = 2
							LOOP												
								UPDATE node SET arc_id=(SELECT arc_id FROM v_edit_arc WHERE ST_DWithin(rec_node.the_geom, 
								v_edit_arc.the_geom,0.001) AND arc_id != v_arc_id LIMIT 1) 
								WHERE node_id=rec_node.node_id;

								INSERT INTO audit_check_data (fid,  criticity, error_message)
								VALUES (212, 1,concat('Update arc_id for disconnected node: ',rec_node.node_id,'.'));
							END LOOP;
						END IF;

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Update psector''s arc_id value for connec and gully setting null value to force trigger to get new arc_id as closest as possible');		
						
						IF v_state_arc = 1 THEN -- ficticius arc

							-- Insert data into traceability table
							INSERT INTO audit_arc_traceability ("type", arc_id, code, arc_id1, arc_id2, node_id, tstamp, cur_user) 
							VALUES ('DIVIDE EXISTING ARC WITH PLANNED NODE',  v_arc_id, v_code, rec_aux1.arc_id, rec_aux2.arc_id, v_node_id, now(), current_user);

							-- insert connec's on alternative in order to reconnect
							INSERT INTO plan_psector_x_connec (psector_id, connec_id, arc_id, state, doable)
							SELECT v_psector, connec_id, NULL, 1,false FROM connec WHERE arc_id = v_arc_id
							ON CONFLICT DO NOTHING;

							-- insert gully's on alternative in order to reconnect
							IF v_project_type='UD' THEN
								INSERT INTO plan_psector_x_gully (psector_id, gully_id, arc_id, state, doable)
								SELECT v_psector, gully_id, NULL, 1, false FROM gully WHERE arc_id = v_arc_id
								ON CONFLICT DO NOTHING;
							END IF;
							
							-- Update doability for the new arcs
							UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux1.arc_id;
							UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux2.arc_id;

							-- Insert existig arc (downgraded) to the current alternative
							INSERT INTO plan_psector_x_arc (psector_id, arc_id, state, doable) VALUES (v_psector, v_arc_id, 0, FALSE);

						ELSIF v_state_arc = 2 THEN -- planned arc									

							-- Insert data into traceability table
							INSERT INTO audit_arc_traceability ("type", arc_id, code, arc_id1, arc_id2, node_id, tstamp, cur_user) 
							VALUES ('DIVIDE PLANNED ARC WITH PLANNED NODE',  v_arc_id, v_code, rec_aux1.arc_id, rec_aux2.arc_id, v_node_id, CURRENT_TIMESTAMP, CURRENT_USER);

							-- in case of divide ficitius arc, new arcs will be ficticius, but we need to set doable false because they are inserted by default as true
							IF (SELECT state_type FROM arc WHERE arc_id=v_arc_id) = v_ficticius THEN
							
								UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux1.arc_id;
								UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux2.arc_id;
								
								INSERT INTO audit_check_data (fid,  criticity, error_message)
								VALUES (212, 1, 'Update psector_x_arc as doable for fictitious arcs.');
							END IF;	

							DELETE FROM plan_psector_x_arc WHERE arc_id=v_arc_id AND psector_id=v_psector;

							UPDATE plan_psector_x_connec SET arc_id=NULL WHERE arc_id=v_arc_id AND psector_id=v_psector;				
						END IF;


						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,concat('Insert old arc as downgraded into current psector: ',v_psector,'.'));
						
						-- reconnect connec
						UPDATE v_edit_connec SET arc_id=NULL WHERE arc_id=v_arc_id;					

						-- reconnect gully
						IF v_project_type='UD' THEN
							UPDATE v_edit_gully SET arc_id=NULL WHERE arc_id=v_arc_id;
						END IF;				

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (212, 1,'Set values on plan_psector_x_arc addparam.');	

						-- Set addparam (parent/child)
						UPDATE plan_psector_x_arc SET addparam='{"arcDivide":"parent"}' WHERE  psector_id=v_psector AND arc_id=v_arc_id;
						UPDATE plan_psector_x_arc SET addparam='{"arcDivide":"child"}' WHERE  psector_id=v_psector AND arc_id=rec_aux1.arc_id;
						UPDATE plan_psector_x_arc SET addparam='{"arcDivide":"child"}' WHERE  psector_id=v_psector AND arc_id=rec_aux2.arc_id;
													
						
				ELSIF (v_state_arc=2 AND v_state_node=1) THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3042", "function":"2114","debug_msg":null}}$$);' INTO v_audit_result;
				ELSE  

					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3044", "function":"2114","debug_msg":null}}$$);' INTO v_audit_result;

				END IF;
			END IF;
		ELSE
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3044", "function":"2114","debug_msg":null}}$$);' INTO v_audit_result;

		END IF;
	ELSE
		IF v_node_type IS NOT NULL THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3046", "function":"2114","debug_msg":"'||v_node_type||'"}}$$);' INTO v_audit_result;
		ELSE 

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3046", "function":"2114","debug_msg":null}}$$);' INTO v_audit_result;
		END IF;

	END IF;
	
	END IF;
			
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data 
	WHERE cur_user="current_user"() AND fid=212 ORDER BY criticity desc, id asc) row;
	
	IF v_audit_result is null THEN
		v_status = 'Accepted';
		v_level = 3;
		v_message = 'Arc divide done successfully';
        
	ELSE

		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

	END IF;

	v_result_info := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

	v_result_point = '{"geometryType":"", "features":[]}';
	v_result_line = '{"geometryType":"", "features":[]}';
	v_result_polygon = '{"geometryType":"", "features":[]}';

	v_status := COALESCE(v_status, '{}'); 
	v_level := COALESCE(v_level, '0'); 
	v_message := COALESCE(v_message, '{}'); 
	v_hide_form := COALESCE(v_hide_form, true); 

	--  Return
	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
				', "actions":{"hideForm":' || v_hide_form || '}'||
		       '}'||
	    '}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;