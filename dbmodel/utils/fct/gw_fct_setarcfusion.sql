/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2112

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_arc_fusion(character varying, character varying, date);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_arc_fusion(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setarcfusion (p_data json)
RETURNS json AS
$BODY$

/*

-- MODE 1: individual
SELECT SCHEMA_NAME.gw_fct_setarcfusion($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":7800}, "form":{}, "feature":{"id":["3470"]}, "data":{"filterFields":{}, "pageInfo":{}, "enddate":"2024-09-05", "action_mode": 2}}$$);

-- MODE 2: massive usign pure SQL
SELECT SCHEMA_NAME.gw_fct_setarcfusion(concat('
{"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":7800}, "form":{},
"feature":{"id":["',node_id,'"]}, "data":{"filterFields":{}, "pageInfo":{}, "enddate":"2024-09-05", "action_mode": 2}}')::json) FROM ... WHERE...;

-- fid: 214

*/

DECLARE

v_point_array1 geometry[];
v_point_array2 geometry[];
v_count integer;
v_exists_node_id varchar;
v_new_record SCHEMA_NAME.arc;
v_record1 SCHEMA_NAME.arc;
v_record2 SCHEMA_NAME.arc;
v_arc_geom geometry;
v_project_type text;
rec_param record;
rec_link record;
v_vnode integer;
v_node_geom public.geometry;
v_version  text;

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
v_array_addfields text[];
v_array_node_id json;
v_node_id text;
v_workcat_id text;
v_psector_id integer;
v_enddate date;
v_state_node int2;
v_state_arc int2;
v_old_node_graph text;
v_node2_graph text;
v_node1_graph text;
v_node_2 text;
v_node_1 text;
v_man_table text;
v_epa_table text;
v_state_type integer;
v_action_mode integer;

rec_addfields record;
v_sql text;
v_query_string_update text;
v_arc_childtable_name text;
v_arc_type text;
rec_addfield1 record;
rec_addfield2 record;
v_fid integer = 214;
v_result_id text= 'arc fusion';
v_schemaname text;
v_arccat_id text;
v_epatype text;


BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;


	-- Get parameters from input json
	v_array_node_id = lower(((p_data ->>'feature')::json->>'id')::text);
	v_node_id = (SELECT json_array_elements_text(v_array_node_id));
	v_workcat_id = (((p_data ->>'data')::json->>'workcatId')::text);
	v_psector_id = (((p_data ->>'data')::json->>'psectorId')::integer);
	v_enddate = ((p_data ->>'data')::json->>'enddate')::date;
	v_state_type = ((p_data ->>'data')::json->>'state_type')::integer;
	v_action_mode = ((p_data ->>'data')::json->>'action_mode')::integer;
	v_arccat_id = ((p_data ->>'data')::json->>'arccat_id')::text;
	v_arc_type = ((p_data ->>'data')::json->>'arc_type')::text;


	-- Get state_type from default value if this isn't on input json
	IF v_state_type IS NULL THEN

		IF v_psector_id IS NULL THEN
			IF v_action_mode = 1 THEN
				SELECT value INTO v_state_type FROM config_param_user WHERE parameter='edit_statetype_0_vdefault' AND cur_user=current_user;
			END IF;
		ELSE
			SELECT value INTO v_state_type FROM config_param_user WHERE parameter='edit_statetype_2_vdefault' AND cur_user=current_user;
		END IF;
	END IF;

	v_action_mode = COALESCE(v_action_mode, 1);

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=214 AND cur_user=current_user;

	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (214, null, 4, 'ARC FUSION');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (214, null, 4, '-------------------------------------------------------------');

	-- Check if the node exists
	SELECT node_id INTO v_exists_node_id FROM v_edit_node WHERE node_id = v_node_id;
	SELECT the_geom INTO v_node_geom FROM node WHERE node_id = v_node_id;

	-- Compute proceed
	IF FOUND THEN

		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (214, 1, concat('Fusion arcs using node: ', v_exists_node_id,'.'));

		-- Find arcs sharing node
		SELECT COUNT(*) INTO v_count FROM v_edit_arc WHERE node_1 = v_node_id OR node_2 = v_node_id AND state > 0;

		-- Accepted if there are just two distinct arcs
		IF v_count = 2 THEN

			-- Get both arc features
			SELECT * INTO v_record1 FROM arc WHERE (node_1 = v_node_id OR node_2 = v_node_id) AND state > 0 ORDER BY arc_id DESC LIMIT 1;
			SELECT * INTO v_record2 FROM arc WHERE (node_1 = v_node_id OR node_2 = v_node_id) AND state > 0 ORDER BY arc_id ASC LIMIT 1;

			-- get states
			SELECT state INTO v_state_node FROM node WHERE node_id = v_node_id;
			SELECT state INTO v_state_arc FROM arc WHERE arc_id = v_record1.arc_id;

			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (214, 1, concat('Arcs related to selected node: ', v_record1.arc_id,', ',v_record2.arc_id,'.'));

			IF v_arccat_id IS NOT NULL THEN
				v_record1.arccat_id = v_arccat_id;
				v_record2.arccat_id = v_arccat_id;
			END IF;

			-- Compare arcs
			IF v_record1.arccat_id = v_record2.arccat_id AND v_record1.sector_id = v_record2.sector_id AND v_record1.expl_id = v_record2.expl_id THEN

				-- Final geometry
				IF v_record1.node_1 = v_node_id THEN
					IF v_record2.node_1 = v_node_id THEN
						v_point_array1 := ARRAY(SELECT (ST_DumpPoints(ST_Reverse(v_record1.the_geom))).geom);
						v_point_array2 := array_cat(v_point_array1, ARRAY(SELECT (ST_DumpPoints(v_record2.the_geom)).geom));
					ELSE
						v_point_array1 := ARRAY(SELECT (ST_DumpPoints(v_record2.the_geom)).geom);
						v_point_array2 := array_cat(v_point_array1, ARRAY(SELECT (ST_DumpPoints(v_record1.the_geom)).geom));
					END IF;
				ELSE
					IF v_record2.node_1 = v_node_id THEN
						v_point_array1 := ARRAY(SELECT (ST_DumpPoints(v_record1.the_geom)).geom);
						v_point_array2 := array_cat(v_point_array1, ARRAY(SELECT (ST_DumpPoints(v_record2.the_geom)).geom));
					ELSE
						v_point_array1 := ARRAY(SELECT (ST_DumpPoints(v_record2.the_geom)).geom);
						v_point_array2 := array_cat(v_point_array1, ARRAY(SELECT (ST_DumpPoints(ST_Reverse(v_record1.the_geom))).geom));
					END IF;
				END IF;

				v_arc_geom := ST_MakeLine(v_point_array2);

				SELECT * INTO v_new_record FROM arc WHERE arc_id = v_record1.arc_id;

				-- Get arctype
				IF v_arc_type IS NULL THEN

					IF v_project_type = 'UD' THEN
						v_arc_type = v_new_record.arc_type;

					ELSIF v_project_type = 'WS' THEN

						v_sql := 'SELECT arctype_id FROM cat_arc WHERE id = '''||v_new_record.arccat_id||''';';
						EXECUTE v_sql
						INTO v_arc_type;
					END IF;
				END IF;

				-- setting values of new record
				v_new_record.arccat_id = v_record1.arccat_id;
				v_new_record.the_geom := v_arc_geom;
				v_new_record.node_1 := (SELECT node_id FROM v_edit_node WHERE ST_DWithin(ST_StartPoint(v_arc_geom), v_edit_node.the_geom, 0.01) LIMIT 1);
				v_new_record.node_2 := (SELECT node_id FROM v_edit_node WHERE ST_DWithin(ST_EndPoint(v_arc_geom), v_edit_node.the_geom, 0.01) LIMIT 1);
				v_new_record.arc_id := (SELECT nextval('urn_id_seq'));

				IF v_project_type = 'UD' THEN

					v_new_record.y1 := (SELECT y1 FROM arc WHERE node_2 = v_node_id AND arc_id IN ( v_record1.arc_id, v_record2.arc_id));
					v_new_record.custom_y1 := (SELECT custom_y1 FROM arc WHERE node_2 = v_node_id AND arc_id IN ( v_record1.arc_id, v_record2.arc_id));
					v_new_record.y2 := (SELECT y2 FROM arc WHERE node_1 = v_node_id AND arc_id IN ( v_record1.arc_id, v_record2.arc_id));
					v_new_record.custom_y2 := (SELECT custom_y2 FROM arc WHERE node_1 = v_node_id AND arc_id IN ( v_record1.arc_id, v_record2.arc_id));

				END IF;

				-- get man and epa tables
				IF v_project_type = 'UD' THEN
					v_new_record.arc_type = v_arc_type;
					SELECT man_table INTO v_man_table FROM sys_feature_class s JOIN cat_feature cf ON cf.feature_class = s.id JOIN cat_feature_arc c ON c.id = cf.id WHERE c.id=v_new_record.arc_type;
					SELECT epa_table, epa_default INTO v_epa_table, v_epatype FROM sys_feature_epa_type s JOIN cat_feature_arc c ON s.id=c.epa_default WHERE c.id=v_new_record.arc_type;
				ELSE
					SELECT man_table INTO v_man_table FROM sys_feature_class s JOIN cat_feature cf ON cf.feature_class = s.id JOIN cat_feature_arc c ON c.id = cf.id JOIN cat_arc ON arctype_id=c.id WHERE cat_arc.id=v_new_record.arccat_id;
					SELECT epa_table, epa_default INTO v_epa_table, v_epatype FROM sys_feature_epa_type s JOIN cat_feature_arc c ON s.id=c.epa_default JOIN cat_arc ON arctype_id=c.id WHERE cat_arc.id=v_new_record.arccat_id;
				END IF;

				v_new_record.epa_type = v_epatype;

				-- temporary dissable the arc_searchnodes_control in order to use the node1 and node2 getted before
				-- to get values topocontrol arc needs to be before, but this is not possible
				UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'activated', false) WHERE parameter = 'edit_arc_searchnodes';
				INSERT INTO arc SELECT v_new_record.*;
				UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'activated', true) WHERE parameter = 'edit_arc_searchnodes';

				UPDATE arc SET node_1=v_new_record.node_1, node_2=v_new_record.node_2 where arc_id=v_new_record.arc_id;

				-- remove duplicated vertex on new arc because of the fusion
				UPDATE arc SET the_geom=ST_RemoveRepeatedPoints(the_geom) WHERE arc_id=v_new_record.arc_id;

				v_arc_childtable_name := 'man_arc_' || lower(v_arc_type);

				IF (SELECT EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_schema = v_schemaname AND table_name = v_arc_childtable_name)) IS TRUE THEN
					EXECUTE 'INSERT INTO '||v_arc_childtable_name||' (arc_id) VALUES ('''||v_new_record.arc_id||''');';

					v_sql := 'SELECT column_name FROM information_schema.columns 
							WHERE table_schema = ''SCHEMA_NAME'' 
							AND table_name = '''||v_arc_childtable_name||''' 
							AND column_name !=''id'' AND column_name != ''arc_id'' ;';

					FOR rec_addfields IN EXECUTE v_sql
					LOOP

						--Compare addfields and assign them to new arc
						EXECUTE 'SELECT ' || rec_addfields.column_name || ' FROM '||v_arc_childtable_name||' WHERE arc_id = '''||v_record1.arc_id||''' ;'
						INTO rec_addfield1;

						EXECUTE 'SELECT ' || rec_addfields.column_name || ' FROM '||v_arc_childtable_name||' WHERE arc_id = ''' ||v_record2.arc_id||''' ;'
						INTO rec_addfield2;


						IF rec_addfield1 != rec_addfield2 THEN
							EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
							"data":{"message":"3008", "function":"2112","debug_msg":null, "is_process":true}}$$)' INTO v_audit_result;

						ELSIF rec_addfield2 IS NULL and rec_addfield1 IS NOT NULL THEN

							v_query_string_update = 'UPDATE '||v_arc_childtable_name||' SET '||rec_addfields.column_name|| ' = '
													'( SELECT '||rec_addfields.column_name||' FROM '||v_arc_childtable_name||' WHERE arc_id = '||quote_literal(v_record1.arc_id)||' ) '
													'WHERE '||v_arc_childtable_name||'.arc_id = '||quote_literal(v_new_record.arc_id)||';';

							IF v_query_string_update IS NOT NULL THEN
								EXECUTE v_query_string_update;
								INSERT INTO audit_check_data (fid, result_id, error_message)
								VALUES (v_fid, v_result_id, concat('Copy values for addfield ',rec_addfields.column_name,' to the new arc.'));
							END IF;

						ELSIF rec_addfield1 IS NULL and rec_addfield2 IS NOT NULL THEN

							v_query_string_update = 'UPDATE '||v_arc_childtable_name||' SET '||rec_addfields.column_name|| ' = 
													( SELECT '||rec_addfields.column_name||' FROM '||v_arc_childtable_name||' WHERE arc_id = '||quote_literal(v_record2.arc_id)||' ) 
													WHERE '||v_arc_childtable_name||'.arc_id = '||quote_literal(v_new_record.arc_id)||';';


							IF v_query_string_update IS NOT NULL THEN
								EXECUTE v_query_string_update;
								INSERT INTO audit_check_data (fid, result_id, error_message)
								VALUES (v_fid, v_result_id, concat('Copy values for addfield ',rec_addfields.column_name,' to the new arc.'));
							END IF;

						ELSE
							v_query_string_update = 'UPDATE '||v_arc_childtable_name||' SET '||rec_addfields.column_name|| ' = 
													( SELECT '||rec_addfields.column_name||' FROM '||v_arc_childtable_name||' WHERE arc_id = '||quote_literal(v_record1.arc_id)||' ) 
													WHERE '||v_arc_childtable_name||'.arc_id = '||quote_literal(v_new_record.arc_id)||';';

							IF v_query_string_update IS NOT NULL THEN
								EXECUTE v_query_string_update;
								INSERT INTO audit_check_data (fid, result_id, error_message)
								VALUES (v_fid, v_result_id, concat('Copy values for addfield ',rec_addfields.column_name,' to the new arc.'));
							END IF;
						END IF;

					END LOOP;

					-- delete rows for old arcs
					EXECUTE 'DELETE FROM '||v_arc_childtable_name||' WHERE arc_id = '||quote_literal(v_record1.arc_id)||';';
					EXECUTE 'DELETE FROM '||v_arc_childtable_name||' WHERE arc_id = '||quote_literal(v_record2.arc_id)||';';
				END IF;

				-- update link only with enabled variable
				IF (SELECT (value::json->>'fid')::boolean FROM config_param_system WHERE parameter='edit_custom_link') IS TRUE THEN
				    UPDATE arc SET link=v_new_record.arc_id where arc_id=v_new_record.arc_id;
				END IF;

				EXECUTE 'INSERT INTO '||v_man_table||' VALUES ('||v_new_record.arc_id||')';
				EXECUTE 'INSERT INTO '||v_epa_table||' VALUES ('||v_new_record.arc_id||')';

				--Insert data on audit_arc_traceability table
				IF v_psector_id IS NULL THEN

					INSERT INTO audit_arc_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", cur_user)
					VALUES ('ARC FUSION', v_new_record.arc_id, v_record2.arc_id,v_record1.arc_id,v_exists_node_id, CURRENT_TIMESTAMP, CURRENT_USER);

					-- update nodes
					SELECT count(node_id) INTO v_count FROM node WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;
					IF v_count > 0 THEN
						UPDATE node SET arc_id=v_new_record.arc_id WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (214, 1, concat('Reconnect ',v_count,' nodes.'));
					END IF;

					-- update operative connecs
					SELECT count(connec_id) INTO v_count FROM connec WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;
					IF v_count > 0 THEN
						UPDATE connec SET arc_id=v_new_record.arc_id WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (214, 1, concat('Reconnect operative ',v_count,' connecs.'));
					END IF;

					-- update operative gullies
					IF v_project_type='UD' THEN
						SELECT count(gully_id) INTO v_count FROM gully WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;
						IF v_count > 0 THEN
							UPDATE gully SET arc_id=v_new_record.arc_id WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;

							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (214, 1, concat('Reconnect operative ',v_count,' gullies.'));
						END IF;
					END IF;

					-- set new exit_id for operative connects
					UPDATE link SET exit_id=v_new_record.arc_id WHERE exit_id=v_record1.arc_id OR exit_id=v_record2.arc_id;

					-- update planned connecs
					SELECT count(connec_id) INTO v_count FROM plan_psector_x_connec WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;
					IF v_count > 0 THEN
						UPDATE plan_psector_x_connec SET arc_id=v_new_record.arc_id WHERE (arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id) AND state = 1;
						INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (214, 1, concat('Reconnect planned ',v_count,' connecs.'));
					END IF;

					-- update planned gullies
					IF v_project_type = 'UD' THEN
						SELECT count(gully_id) INTO v_count FROM plan_psector_x_gully WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;
						IF v_count > 0 THEN
							UPDATE plan_psector_x_gully SET arc_id=v_new_record.arc_id WHERE (arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id) AND state = 1;
							INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (214, 1, concat('Reconnect planned ',v_count,' gullies.'));
						END IF;
					END IF;

					IF v_state_node = 1 THEN

						-- update elements
						SELECT count(id) INTO v_count FROM element_x_arc WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;
						IF v_count > 0 THEN
							UPDATE element_x_arc SET arc_id=v_new_record.arc_id WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id
							AND element_id not in (select element_id FROM element_x_arc WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id);

							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (214, 1, concat('Copy ',v_count,' elements from old arcs to new one.'));
						END IF;

						-- update documents
						SELECT count(id) INTO v_count FROM doc_x_arc WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;
						IF v_count > 0 THEN
							UPDATE doc_x_arc SET arc_id=v_new_record.arc_id WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;

							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (214, 1, concat('Copy ',v_count,' documents from old arcs to new one.'));
						END IF;

						-- update visits
						SELECT count(id) INTO v_count FROM om_visit_x_arc WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;
						IF v_count > 0 THEN
							UPDATE om_visit_x_arc SET arc_id=v_new_record.arc_id WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id;

							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (214, 1, concat('Copy ',v_count,' visits from old arcs to new one.'));
						END IF;

						IF v_project_type = 'WS' THEN

							-- update to_arc for mapzones and system tables
							EXECUTE 'SELECT node_1, node_2 FROM v_edit_arc a WHERE a.arc_id='''||v_new_record.arc_id||''';'
							INTO v_node_1,v_node_2;

							EXECUTE 'SELECT gw_fct_setmapzoneconfig($${
							"client":{"device":4, "infoType":1,"lang":"ES"}	,"data":{"parameters":{"nodeIdOld":"'||v_node_1||'",
							"arcIdOld":'||v_record1.arc_id||',"arcIdNew":'||v_new_record.arc_id||',"action":"updateArc"}}}$$);';

							EXECUTE 'SELECT gw_fct_setmapzoneconfig($${
							"client":{"device":4, "infoType":1,"lang":"ES"},"data":{"parameters":{"nodeIdOld":"'||v_node_1||'",
							"arcIdOld":'||v_record2.arc_id||',"arcIdNew":'||v_new_record.arc_id||',"action":"updateArc"}}}$$);';

						END IF;

						-- Delete arcs
						DELETE FROM arc WHERE arc_id = v_record1.arc_id;
						DELETE FROM arc WHERE arc_id = v_record2.arc_id;

						-- Moving to obsolete the previous node
						IF v_action_mode = 1 THEN

							-- control if state_type is null
							IF v_state_type IS NULL THEN
								EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
								"data":{"message":"3134", "function":"2112","debug_msg":null, "is_process":true}}$$)' INTO v_audit_result;
							END IF;

							INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (214, 1, concat('Change state of node  ',v_node_id,' to obsolete.'));
							UPDATE node SET state=0, state_type=v_state_type, workcat_id_end=v_workcat_id, enddate=v_enddate WHERE node_id = v_node_id;
						END IF;

						-- Delete node if action is 'DELETE NODE'
						IF v_action_mode = 2 THEN
							INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (214, 1, concat('Delete node ',v_node_id));
							DELETE FROM node WHERE node_id = v_node_id;
						END IF;

					ELSIF v_state_node = 2 THEN

						-- Delete arcs
						DELETE FROM arc WHERE arc_id = v_record1.arc_id;
						DELETE FROM arc WHERE arc_id = v_record2.arc_id;

						-- Delete node
						INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (214, 1, concat('Delete planned node ',v_node_id));
						DELETE FROM node WHERE node_id = v_node_id;

					END IF;

				ELSIF v_psector_id IS NOT NULL THEN

					-- profilactic control for state_type
					if v_state_type is null then v_state_type = v_record1.state_type; end if;

					UPDATE arc SET state = 2, state_type = v_state_type WHERE arc_id = v_new_record.arc_id;

					UPDATE config_param_user SET value='false' WHERE parameter='edit_plan_order_control' AND cur_user=current_user;

					INSERT INTO plan_psector_x_arc (arc_id, psector_id, state, doable) VALUES (v_new_record.arc_id, v_psector_id, 1, false) ON CONFLICT (arc_id, psector_id) DO NOTHING;

					-- orphan nodes with arc_id not null
					SELECT count(*) INTO v_count FROM v_edit_node WHERE arc_id IN (v_record1.arc_id, v_record2.arc_id);
					IF v_count > 0 THEN
						INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (214, 1, concat('Warning: There are ',v_count,' orphan nodes related to existing arcs. Column arc_id remains with initial value.'));
					END IF;

					-- links from connec related to node
					FOR rec_link IN SELECT * FROM v_edit_link WHERE exit_type = 'NODE' AND exit_id = v_node_id AND feature_type = 'CONNEC' LOOP
						INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable) VALUES (rec_link.feature_id, v_new_record.arc_id, v_psector_id, 1, false);

						INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (214, 1, concat('Warning: Connec ',rec_link.feature_id,' has been reconected with new arc_id but keeping the feature exit from initial node.'));
					END LOOP;

					-- links from gully related to node
					FOR rec_link IN SELECT * FROM v_edit_link WHERE exit_type = 'NODE' AND exit_id = v_node_id AND feature_type = 'GULLY' LOOP
						INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable) VALUES (rec_link.feature_id, v_new_record.arc_id, v_psector_id, 1, false);

						INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (214, 1, concat('Warning: Gully ',rec_link.feature_id,' has been reconected with new arc_id but keeping the feature exit from initial node.'));
					END LOOP;

					-- update operative connecs
					SELECT count(connec_id) INTO v_count FROM connec WHERE arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id AND state = 1;
					IF v_count > 0 THEN
						INSERT INTO plan_psector_x_connec (psector_id, connec_id, arc_id, state, doable, link_id)
						SELECT v_psector_id, connec_id, arc_id, 0, false, link_id FROM connec c JOIN link l ON connec_id = feature_id
						WHERE arc_id IN (v_record1.arc_id, v_record2.arc_id) AND c.state = 1 and l.state = 1
						ON CONFLICT (psector_id, connec_id, state) DO NOTHING;

						INSERT INTO plan_psector_x_connec (psector_id, connec_id, arc_id, state, doable)
						SELECT v_psector_id, connec_id, arc_id, 1, false FROM connec c WHERE arc_id IN (v_record1.arc_id, v_record2.arc_id) AND state = 1
						ON CONFLICT (psector_id, connec_id, state) DO NOTHING;

						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (214, 1, concat('Reconnect operative ',v_count,' connecs.'));
					END IF;

					-- update operative gullies
					IF v_project_type='UD' THEN
						SELECT count(gully_id) INTO v_count FROM gully WHERE (arc_id=v_record1.arc_id OR arc_id=v_record2.arc_id) AND state = 1;
						IF v_count > 0 THEN

							INSERT INTO plan_psector_x_gully (psector_id, gully_id, arc_id, state, doable, link_id)
							SELECT v_psector_id, gully_id, arc_id, 0, false, link_id FROM gully c JOIN link l ON gully_id = feature_id
							WHERE arc_id IN (v_record1.arc_id, v_record2.arc_id) AND c.state = 1 and l.state = 1
							ON CONFLICT (psector_id, gully_id, state) DO NOTHING;

							INSERT INTO plan_psector_x_gully (psector_id, gully_id, arc_id, state, doable)
							SELECT v_psector_id, gully_id, arc_id, 1, false FROM gully c WHERE arc_id IN (v_record1.arc_id, v_record2.arc_id) AND state = 1
							ON CONFLICT (psector_id, gully_id, state) DO NOTHING;

							INSERT INTO audit_check_data (fid,  criticity, error_message)
							VALUES (214, 1, concat('Reconnect operative ',v_count,' gullies.'));
						END IF;
					END IF;

					-- update planned connecs
					SELECT count(connec_id) INTO v_count FROM plan_psector_x_connec WHERE psector_id=v_psector_id AND arc_id IN (v_record1.arc_id, v_record2.arc_id);
					IF v_count > 0 THEN
						UPDATE plan_psector_x_connec SET arc_id=v_new_record.arc_id WHERE psector_id=v_psector_id AND arc_id IN (v_record1.arc_id, v_record2.arc_id)
						AND state = 1;
						INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (214, 1, concat('Reconnect planned ',v_count,' connecs.'));
					END IF;

					-- update planned gullies
					IF v_project_type = 'UD' THEN
						SELECT count(gully_id) INTO v_count FROM plan_psector_x_gully WHERE psector_id=v_psector_id AND arc_id IN (v_record1.arc_id, v_record2.arc_id) AND state = 1;
						IF v_count > 0 THEN
							UPDATE plan_psector_x_gully SET arc_id=v_new_record.arc_id WHERE psector_id=v_psector_id AND arc_id IN (v_record1.arc_id, v_record2.arc_id)
							AND state = 1;
							INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (214, 1, concat('Reconnect planned ',v_count,' gullies.'));
						END IF;
					END IF;

					IF v_record1.state = 1 THEN
						INSERT INTO plan_psector_x_arc (psector_id, arc_id, state) VALUES (v_psector_id, v_record1.arc_id, 0)
						ON CONFLICT (psector_id, arc_id) DO NOTHING;
					ELSE
						DELETE FROM arc WHERE arc_id = v_record1.arc_id;
					END IF;

					IF v_record2.state = 1 THEN
						INSERT INTO plan_psector_x_arc (psector_id, arc_id, state) VALUES (v_psector_id, v_record2.arc_id, 0)
						ON CONFLICT (psector_id, arc_id) DO NOTHING;
					ELSE
						DELETE FROM arc WHERE arc_id = v_record2.arc_id;
					END IF;

					UPDATE config_param_user SET value='true' WHERE parameter='edit_plan_order_control' AND cur_user=current_user;

					IF v_state_node = 1 THEN
						INSERT INTO plan_psector_x_node (psector_id, node_id, state) VALUES (v_psector_id, v_node_id, 0)
						ON CONFLICT (psector_id, node_id) DO NOTHING;
					ELSE
						INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (214, 1, concat('Delete planned node ',v_node_id));
						DELETE FROM node WHERE node_id = v_node_id;
					END IF;

					-- set link_id NULL when connect doesn't has previous link but previous insert has triggered one
					UPDATE plan_psector_x_connec SET link_id = NULL WHERE connec_id NOT IN (SELECT distinct(connec_id) FROM plan_psector_x_connec
					JOIN link USING (link_id) WHERE psector_id=v_psector_id AND link.state=1) AND psector_id=v_psector_id;

					IF v_project_type = 'UD' THEN
						UPDATE plan_psector_x_gully SET link_id = NULL WHERE gully_id NOT IN (SELECT distinct(gully_id) FROM plan_psector_x_gully
						JOIN link USING (link_id) WHERE psector_id=v_psector_id AND link.state=1) AND psector_id=v_psector_id;
					END IF;

				END IF;

				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (214, 1, concat('Delete arcs: ',v_record1.arc_id,', ',v_record2.arc_id,'.'));

			-- Arcs has different catalogs or exploitation or sector
			ELSE
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"2004", "function":"2112","debug_msg":null, "is_process":true}}$$)' INTO v_audit_result;

			END IF;

		-- Node has not 2 arcs
		ELSE
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"2006", "function":"2112","debug_msg":null, "is_process":true}}$$)' INTO v_audit_result;
		END IF;

	-- Node not found
	ELSE

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"2002", "function":"2112","debug_msg":null, "is_process":true}}$$)' INTO v_audit_result;

	END IF;

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data
	WHERE cur_user="current_user"() AND fid=214 ORDER BY criticity desc, id asc) row;

	IF v_audit_result is null THEN
		v_status = 'Accepted';
		v_level = 3;
		v_message = 'Arc fusion done successfully';
	ELSE

		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

	END IF;

	v_result_info := COALESCE(v_result, '{}');
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

	v_status := COALESCE(v_status, '{}');
	v_level := COALESCE(v_level, '0');
	v_message := COALESCE(v_message, '{}');

	--  Return

	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
				',"body":{"form":{}'||
				',"data":{"info":'||v_result_info||'}}'
		'}')::json, 2112, null, null, null);

	-- Exception control
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ', "message":{"level":'||right(SQLSTATE, 1)||', "text":"'||SQLERRM||'"},"SQLSTATE":' || to_json(SQLSTATE)
	||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;


	END;
$BODY$
	LANGUAGE plpgsql VOLATILE
	COST 100;
