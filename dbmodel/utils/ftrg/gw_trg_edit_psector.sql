/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2446

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_psector()
  RETURNS trigger AS
$BODY$

DECLARE 
v_sql varchar;
om_aux text;
rec_type record;
v_plan_table text;
v_plan_table_id text;

rec record;

v_state_done_planified integer;
v_state_done_ficticious integer;
v_state_canceled_planified integer;
v_state_canceled_ficticious integer;
v_plan_statetype_ficticious integer;
v_plan_statetype_planned integer;
v_current_state_type integer;
v_id text; 
v_statetype_obsolete integer; 
v_statetype_onservice integer;
v_auto_downgrade_link boolean; 
v_ischild text;
v_execute_mode text;
v_parent_id integer;
v_temporal_psector_id integer;
v_current_psector integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    om_aux:= TG_ARGV[0];
    v_execute_mode:= (SELECT value::json ->> 'mode' FROM config_param_system WHERE parameter='plan_psector_execute_action');
    v_current_psector:= (SELECT value::integer FROM config_param_user WHERE parameter='plan_psector_vdefault' AND cur_user=current_user);

    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
		
	-- Scale_vdefault
	IF (NEW.scale IS NULL) THEN
		NEW.scale := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_scale_vdefault' AND "cur_user"="current_user"())::numeric (8,2);
	END IF;
		
	-- Rotation_vdefault
	IF (NEW.rotation IS NULL) THEN
		NEW.rotation := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_rotation_vdefault' AND "cur_user"="current_user"())::numeric (8,4);
	END IF;
		
	-- Gexpenses_vdefault
	IF (NEW.gexpenses IS NULL) THEN
		NEW.gexpenses := (SELECT "value" FROM config_param_user WHERE "parameter"='plan_psector_gexpenses_vdefault' AND "cur_user"="current_user"())::numeric(4,2);
	END IF;
		
	-- Vat_vdefault
	IF (NEW.vat IS NULL) THEN
		NEW.vat := (SELECT "value" FROM config_param_user WHERE "parameter"='plan_psector_vat_vdefault' AND "cur_user"="current_user"())::numeric(4,2);
	END IF;
		
	-- Other_vdefault
	IF (NEW.other IS NULL) THEN
		NEW.other := (SELECT "value" FROM config_param_user WHERE "parameter"='plan_psector_other_vdefault' AND "cur_user"="current_user"())::numeric(4,2);
	END IF;
	
	-- Type_vdefault
	IF (NEW.psector_type IS NULL) THEN
		NEW.psector_type := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_type_vdefault' AND "cur_user"="current_user"())::integer;
	END IF;
		
	-- Control insertions ID
	NEW.psector_id:= (SELECT nextval('plan_psector_id_seq'));
	
	IF om_aux='plan' THEN

		INSERT INTO plan_psector (psector_id, name, psector_type, descript, priority, text1, text2, observ, rotation, scale,
		 atlas_id, gexpenses, vat, other, the_geom, expl_id, active, ext_code, status, text3, text4, text5, text6, num_value)
		VALUES  (NEW.psector_id, NEW.name, NEW.psector_type, NEW.descript, NEW.priority, NEW.text1, NEW.text2, NEW.observ, NEW.rotation, 
		NEW.scale, NEW.atlas_id, NEW.gexpenses, NEW.vat, NEW.other, NEW.the_geom, NEW.expl_id, NEW.active,
		NEW.ext_code, NEW.status, NEW.text3, NEW.text4, NEW.text5, NEW.text6, NEW.num_value);
	END IF;

		
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

	IF om_aux='plan' THEN

		UPDATE plan_psector 
		SET psector_id=NEW.psector_id, name=NEW.name, psector_type=NEW.psector_type, descript=NEW.descript, priority=NEW.priority, text1=NEW.text1, 
		text2=NEW.text2, observ=NEW.observ, rotation=NEW.rotation, scale=NEW.scale, atlas_id=NEW.atlas_id, 
		gexpenses=NEW.gexpenses, vat=NEW.vat, other=NEW.other, expl_id=NEW.expl_id, active=NEW.active, ext_code=NEW.ext_code, status=NEW.status,
		text3=NEW.text3, text4=NEW.text4, text5=NEW.text5, text6=NEW.text6, num_value=NEW.num_value
		WHERE psector_id=OLD.psector_id;

		--onService mode transform all features afected by psector to its planified state and makes a copy of psector
		IF v_execute_mode='onService' THEN

			-- update psector status to EXECUTED
			IF (OLD.status != NEW.status) AND (NEW.status = 0) THEN

				--make a copy of the psector to mantain traceability
				EXECUTE 'SELECT SCHEMA_NAME.gw_fct_psector_duplicate($${
				"client":{"device":4, "infoType":1, "lang":"ES"},
				"form":{},"feature":{"type":"PSECTOR"},
				"data":{"psector_id":"'||OLD.psector_id||'","new_psector_name":"temporal_psector"}}$$);';

				SELECT value::integer INTO v_statetype_obsolete FROM config_param_user WHERE parameter='edit_statetype_0_vdefault' AND cur_user=current_user;
				IF v_statetype_obsolete IS NULL THEN
				        EXECUTE 'SELECT SCHEMA_NAME.gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3134", "function":"2446","debug_msg":null}}$$);';
				END IF;
				
				SELECT value::integer INTO v_statetype_onservice FROM config_param_user WHERE parameter='edit_statetype_1_vdefault' AND cur_user=current_user;
				IF v_statetype_onservice IS NULL THEN
				        EXECUTE 'SELECT SCHEMA_NAME.gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3136", "function":"2446","debug_msg":null}}$$);';
				END IF;
				
				--temporary remove topology control
				UPDATE config_param_system set value = 'false' WHERE parameter='edit_state_topocontrol';

				--use automatic downgrade link variable 
				SELECT value::boolean INTO v_auto_downgrade_link FROM config_param_user WHERE parameter='edit_connect_downgrade_link' AND cur_user=current_user;
				IF v_auto_downgrade_link IS NULL THEN
					INSERT INTO config_param_user VALUES ('edit_connect_downgrade_link', 'true', current_user);
				END IF;

				--change state/state_type of psector features acording to its current status on the psector_x_* table
				FOR rec_type IN (SELECT * FROM sys_feature_type WHERE classlevel = 1 OR classlevel = 2 ORDER BY id asc) LOOP

					v_sql = 'SELECT '||rec_type.id||'_id as id, state FROM plan_psector_x_'||lower(rec_type.id)||' WHERE psector_id = '||OLD.psector_id||';';

					FOR rec IN EXECUTE v_sql LOOP
							
						-- capture if arc is child in order to add their parents' relations
						SELECT ((addparam::json) ->> 'arcDivide') INTO v_ischild FROM plan_psector_x_arc WHERE arc_id=rec.id AND psector_id=OLD.psector_id;

						IF v_ischild='child' THEN
							-- get its parent_id
							SELECT arc_id::integer INTO v_parent_id FROM audit_arc_traceability WHERE (arc_id1=rec.id) or (arc_id2=rec.id);

							--insert related documents to child arc
							INSERT INTO doc_x_arc(doc_id, arc_id) 
							SELECT doc_id, rec.id FROM (SELECT doc_id FROM doc_x_arc WHERE arc_id::integer=v_parent_id)a;
						
							--insert related elements to child arc
							INSERT INTO element_x_arc(element_id, arc_id) 
							SELECT element_id, rec.id FROM (SELECT element_id FROM element_x_arc WHERE arc_id::integer=v_parent_id)a;
							
							--insert related visits to child arc
							INSERT INTO om_visit_x_arc(visit_id, arc_id) 
							SELECT visit_id, rec.id FROM (SELECT visit_id FROM om_visit_x_arc WHERE arc_id::integer=v_parent_id)a;

						END IF;

						-- set obsolete features where psector_x_* state is 0
						EXECUTE 'UPDATE '||lower(rec_type.id)||' n SET state = 0, state_type = '||v_statetype_obsolete||' 
						FROM plan_psector_x_'||lower(rec_type.id)||' p WHERE n.'||lower(rec_type.id)||'_id = p.'||lower(rec_type.id)||'_id 
						AND p.state = 0 AND p.psector_id='||OLD.psector_id||' AND n.'||lower(rec_type.id)||'_id = '''||rec.id||''';';
						
						-- delete from psector_x_* where state is 0
						EXECUTE 'DELETE FROM plan_psector_x_'||lower(rec_type.id)||' 
						WHERE psector_id = '||OLD.psector_id||' AND '||lower(rec_type.id)||'_id = '''||rec.id||''' AND '''||rec.state||''' = 0;';

						-- set on service feature where psector_x_* state is 1
						EXECUTE 'UPDATE '||lower(rec_type.id)||' n SET state = 1, state_type = '||v_statetype_onservice||' 
						FROM plan_psector_x_'||lower(rec_type.id)||' p WHERE n.'||lower(rec_type.id)||'_id = p.'||lower(rec_type.id)||'_id 
						AND p.state = 1 AND p.psector_id='||OLD.psector_id||' AND n.'||lower(rec_type.id)||'_id = '''||rec.id||''';';

						-- change arc_id for planified connecs (useful when existing connec changes to planified arc)
						IF lower(rec_type.id) IN ('connec', 'gully') THEN
							EXECUTE 'UPDATE '||lower(rec_type.id)||' n SET arc_id = p.arc_id
							FROM plan_psector_x_'||lower(rec_type.id)||' p WHERE n.'||lower(rec_type.id)||'_id = p.'||lower(rec_type.id)||'_id 
							AND p.state = 1 AND p.psector_id='||OLD.psector_id||' AND n.'||lower(rec_type.id)||'_id = '''||rec.id||''';';

							EXECUTE 'UPDATE link SET the_geom = link_geom, userdefined_geom = p.userdefined_geom
							FROM plan_psector_x_'||lower(rec_type.id)||' p WHERE link.feature_id = p.'||lower(rec_type.id)||'_id 
							AND p.state = 1 AND p.psector_id='||OLD.psector_id||' AND link.feature_id = '''||rec.id||''';';

							EXECUTE 'UPDATE vnode SET the_geom = vnode_geom	FROM plan_psector_x_'||lower(rec_type.id)||' p 
							JOIN link ON link.feature_id = p.'||lower(rec_type.id)||'_id AND p.state = 1 AND p.psector_id='||OLD.psector_id||' 
							AND link.feature_id = '''||rec.id||''' WHERE link.exit_id::integer=vnode.vnode_id;';
							
						END IF;

						-- delete from psector_x_* where state is 1
						EXECUTE 'DELETE FROM plan_psector_x_'||lower(rec_type.id)||' 
						WHERE psector_id = '||OLD.psector_id||' AND '||lower(rec_type.id)||'_id = '''||rec.id||''' AND '''||rec.state||''' = 1;';

						-- set link on service to connecs where psector_x_connec state is 1
						EXECUTE 'UPDATE link SET state=1 WHERE feature_id IN (SELECT connec_id FROM plan_psector_x_connec 
						WHERE psector_id = '||OLD.psector_id||' AND state= 1);';
						
					END LOOP;
				END LOOP;

				--reset downgrade link variable
				IF v_auto_downgrade_link IS NULL THEN
					DELETE FROM config_param_user WHERE parameter='edit_connect_downgrade_link' AND cur_user=current_user;
				END IF;

				--fill old psector with the copied values to mantain tracability (only state=1 values)
				SELECT psector_id INTO v_temporal_psector_id FROM plan_psector WHERE name='temporal_psector';
				
				INSERT INTO plan_psector_x_arc(arc_id, psector_id, state, doable, descript, addparam) 
				SELECT arc_id, OLD.psector_id, state, doable, descript, addparam FROM plan_psector_x_arc 
				WHERE psector_id=v_temporal_psector_id AND (addparam IS NULL  OR ((addparam::json) ->> 'arcDivide')='parent');

				INSERT INTO plan_psector_x_node(node_id, psector_id, state, doable, descript) 
				SELECT node_id, OLD.psector_id, state, doable, descript FROM plan_psector_x_node WHERE psector_id=v_temporal_psector_id;

				--only new connecs or ones which link's geom have changed
				INSERT INTO plan_psector_x_connec(connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom, userdefined_geom) 
				SELECT connec_id, pc.arc_id, OLD.psector_id, pc.state, pc.doable, pc.descript, link_geom, vnode_geom, pc.userdefined_geom FROM plan_psector_x_connec pc	
				JOIN arc ON ST_DWithin(st_buffer(vnode_geom, 0.5), arc.the_geom,0.001)
				WHERE pc.psector_id=v_temporal_psector_id AND arc.state=2;
				
				--delete temporal psector after all changes
				EXECUTE 'SELECT gw_fct_setdelete($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
				"feature":{"id":["'||v_temporal_psector_id||'"], "featureType":"PSECTOR", "tableName":"v_ui_plan_psector", "idName":"psector_id"},
				"data":{"filterFields":{}, "pageInfo":{}}}$$)';
				
				--set the same current psector from before execute
				UPDATE config_param_user SET value=v_current_psector WHERE parameter='plan_psector_vdefault' AND cur_user=current_user;

				PERFORM setval('plan_psector_id_seq', (SELECT max(psector_id) FROM plan_psector));
				
			END IF;
		END IF;

		--obsolete mode set all features afected to obsolete but manage their state_type
		IF v_execute_mode='obsolete' THEN
		
			--if the status of a psector had changed to 3 or 0 proceed with changes of feature states
			IF (OLD.status != NEW.status) AND (NEW.status = 0 OR NEW.status = 2 OR NEW.status = 3)  THEN

				--get the values of future state_types 
				SELECT ((value::json)->>'done_planified') INTO v_state_done_planified FROM config_param_system WHERE parameter='plan_psector_statetype';
				SELECT ((value::json)->>'done_ficticious') INTO v_state_done_ficticious FROM config_param_system WHERE parameter='plan_psector_statetype';
				SELECT ((value::json)->>'canceled_planified') INTO v_state_canceled_planified FROM config_param_system WHERE parameter='plan_psector_statetype';
				SELECT ((value::json)->>'canceled_ficticious') INTO v_state_canceled_ficticious FROM config_param_system WHERE parameter='plan_psector_statetype';
				SELECT value::integer INTO v_plan_statetype_ficticious FROM config_param_system WHERE parameter = 'plan_statetype_ficticius';
				SELECT value::integer INTO v_plan_statetype_planned FROM config_param_system WHERE parameter = 'plan_statetype_planned';

				--temporary remove topology control
				UPDATE config_param_system set value = 'false' WHERE parameter='edit_state_topocontrol';

				--loop over network feature types in order to get the data from each plan_psector_x_* table 
				FOR rec_type IN (SELECT * FROM sys_feature_type WHERE classlevel = 1 OR classlevel = 2 ORDER BY id asc) LOOP

					v_sql = 'SELECT '||rec_type.id||'_id as id FROM plan_psector_x_'||lower(rec_type.id)||' WHERE state = 1 AND psector_id = '||OLD.psector_id||';';

					--loop over each feature in plan_psector_x_* table in order to update state values
					FOR rec IN EXECUTE v_sql LOOP
					
						--get the current state_type of a feature
						EXECUTE 'SELECT state_type FROM v_edit_'||lower(rec_type.id)||' WHERE '||lower(rec_type.id)||'_id = '''||rec.id||''';'
						INTO v_current_state_type;

						--set planned features to obsolete and update state_type depending on the new status and current state_type
						IF NEW.status = 0 THEN	
							IF v_current_state_type = v_plan_statetype_ficticious OR v_current_state_type = v_state_canceled_ficticious THEN
								EXECUTE 'UPDATE v_edit_'||lower(rec_type.id)||' SET state = 0, state_type = '||v_state_done_ficticious||'
								WHERE '||lower(rec_type.id)||'_id = '''||rec.id||''';';
								
							ELSE
								EXECUTE 'UPDATE v_edit_'||lower(rec_type.id)||' SET state = 0, state_type = '||v_state_done_planified||'
								WHERE '||lower(rec_type.id)||'_id = '''||rec.id||''';';
							END IF;
							
						ELSIF NEW.status = 2 THEN
							IF v_current_state_type = v_state_done_ficticious OR v_current_state_type = v_state_canceled_ficticious THEN
								EXECUTE 'UPDATE v_edit_'||lower(rec_type.id)||' SET state = 2, state_type = '||v_plan_statetype_ficticious||'
								WHERE '||lower(rec_type.id)||'_id = '''||rec.id||''';';
								
							ELSE
								EXECUTE 'UPDATE v_edit_'||lower(rec_type.id)||' SET state = 2, state_type = '||v_plan_statetype_planned||'
								WHERE '||lower(rec_type.id)||'_id = '''||rec.id||''';';
								
							END IF;			
							
						ELSIF NEW.status = 3 THEN
							IF v_current_state_type = v_plan_statetype_ficticious OR v_current_state_type = v_state_done_ficticious THEN
								EXECUTE 'UPDATE v_edit_'||lower(rec_type.id)||' SET state = 0, state_type = '||v_state_canceled_ficticious||'
								WHERE '||lower(rec_type.id)||'_id = '''||rec.id||''';';
								
							ELSE
								EXECUTE 'UPDATE v_edit_'||lower(rec_type.id)||' SET state = 0, state_type = '||v_state_canceled_planified||'
								WHERE '||lower(rec_type.id)||'_id = '''||rec.id||''';';
								
							END IF;
						END IF;
						
					END LOOP;
					--reestablish topology control
					UPDATE config_param_system set value = 'true' WHERE parameter='edit_state_topocontrol';
					--show information about performed state update

					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3034", "function":"2446","debug_msg":null}}$$);';
				END LOOP;
				
			END IF;
		END IF;
	END IF;
               
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
    
	IF om_aux='plan' THEN

		DELETE FROM plan_psector WHERE psector_id = OLD.psector_id;
		DELETE FROM arc WHERE state = 2 AND arc_id IN (SELECT arc_id FROM plan_psector_x_arc WHERE psector_id = OLD.psector_id) ;	
		DELETE FROM node WHERE state = 2 AND node_id IN (SELECT node_id FROM plan_psector_x_node WHERE psector_id = OLD.psector_id);	
		DELETE FROM connec WHERE state = 2 AND connec_id IN (SELECT connec_id FROM plan_psector_x_connec WHERE psector_id = OLD.psector_id);
		IF (select project_type FROM sys_version LIMIT 1)='UD' THEN	
			DELETE FROM gully WHERE state = 2 AND gully_id IN (SELECT gully_id FROM plan_psector_x_gully WHERE psector_id = OLD.psector_id);
		END IF;
		RETURN NULL;
	END IF;

        RETURN NULL;
 
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;