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
v_projectype text;
rec_type record;
rec record;
v_statetype_obsolete integer; 
v_statetype_onservice integer;
v_auto_downgrade_link boolean; 
v_ischild text;
v_parent_id integer;
v_state_obsolete_planified integer;
v_affectrow integer;
v_psector_geom geometry;
v_action text;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    om_aux:= TG_ARGV[0];
    v_projectype := (SELECT project_type FROM sys_version ORDER BY id DESC LIMIT 1);
   
	--get obsolete_planified state_type
	v_state_obsolete_planified:= (SELECT value::json ->> 'obsolete_planified' FROM config_param_system WHERE parameter='plan_psector_status_action');

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
		
	NEW.psector_id:= (SELECT nextval('plan_psector_id_seq'));
	
	IF om_aux='plan' THEN

		INSERT INTO plan_psector (psector_id, name, psector_type, descript, priority, text1, text2, observ, rotation, scale,
		 atlas_id, gexpenses, vat, other, the_geom, expl_id, active, ext_code, status, text3, text4, text5, text6, num_value, workcat_id, parent_id)
		VALUES  (NEW.psector_id, NEW.name, NEW.psector_type, NEW.descript, NEW.priority, NEW.text1, NEW.text2, NEW.observ, NEW.rotation, 
		NEW.scale, NEW.atlas_id, NEW.gexpenses, NEW.vat, NEW.other, NEW.the_geom, NEW.expl_id, true,
		NEW.ext_code, NEW.status, NEW.text3, NEW.text4, NEW.text5, NEW.text6, NEW.num_value, new.workcat_id, new.parent_id);
	END IF;

		
    RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

	IF om_aux='plan' THEN

		UPDATE plan_psector 
		SET psector_id=NEW.psector_id, name=NEW.name, psector_type=NEW.psector_type, descript=NEW.descript, priority=NEW.priority, text1=NEW.text1, 
		text2=NEW.text2, observ=NEW.observ, rotation=NEW.rotation, scale=NEW.scale, atlas_id=NEW.atlas_id, 
		gexpenses=NEW.gexpenses, vat=NEW.vat, other=NEW.other, expl_id=NEW.expl_id, active=NEW.active, ext_code=NEW.ext_code, status=NEW.status,
		text3=NEW.text3, text4=NEW.text4, text5=NEW.text5, text6=NEW.text6, num_value=NEW.num_value, workcat_id=new.workcat_id, parent_id=new.parent_id, lastupdate=now(), lastupdate_user=current_user
		WHERE psector_id=OLD.psector_id;

		-- update psector status to EXECUTED (On Service)
		IF (OLD.status != NEW.status) AND (NEW.status = 4) THEN
		
			-- get psector geometry
			v_psector_geom = (SELECT the_geom FROM plan_psector WHERE psector_id=NEW.psector_id);
		
			-- copy values into traceability tables
			INSERT INTO audit_psector_connec_traceability
			SELECT nextval('SCHEMA_NAME.audit_psector_connec_traceability_id_seq'), psector_id, pc.state, doable, pc.arc_id, l.link_id, l.the_geom, now(), current_user, 'Execute psector', connec.*
			FROM plan_psector_x_connec pc JOIN connec USING (connec_id)
			JOIN link l USING (link_id)
			WHERE psector_id=NEW.psector_id;

			IF v_projectype = 'WS' THEN

				-- arc & node insert is different from ud because UD has legacy of _sys_length & _sys_elev and the impossibility to remove it from old production environments
				INSERT INTO audit_psector_arc_traceability
				SELECT nextval('SCHEMA_NAME.audit_psector_arc_traceability_id_seq'), psector_id, pa.state, doable, addparam, now(), current_user, 'Execute psector', arc.*
				FROM plan_psector_x_arc pa JOIN arc USING (arc_id) 
				WHERE psector_id=NEW.psector_id;

				INSERT INTO audit_psector_node_traceability
				SELECT nextval('SCHEMA_NAME.audit_psector_node_traceability_id_seq'), psector_id, pn.state, doable, addparam, now(), current_user, 'Execute psector', node.*
				FROM plan_psector_x_node pn JOIN node USING (node_id) 
				WHERE psector_id=NEW.psector_id;
		
			ELSIF v_projectype = 'UD' THEN

				-- arc & node insert is different from ws because legacy of _sys_length & _sys_elev and the impossibility to remove it from old production environments
				INSERT INTO audit_psector_arc_traceability
				SELECT nextval('SCHEMA_NAME.audit_psector_arc_traceability_id_seq'), psector_id, pa.state, doable, addparam, now(), current_user, 'Execute psector',
				a.arc_id,code,node_1,node_2,y1,y2,elev1,elev2,custom_y1,custom_y2,custom_elev1,custom_elev2,sys_elev1,sys_elev2,arc_type,arccat_id,
				matcat_id,epa_type,sector_id,a.state,state_type,annotation,observ,comment,sys_slope,inverted_slope,custom_length,dma_id,soilcat_id,
				function_type,category_type,fluid_type,location_type,workcat_id,workcat_id_end,buildercat_id,builtdate,enddate,ownercat_id,muni_id,
				postcode,streetaxis_id,postnumber,postcomplement,streetaxis2_id,postnumber2,postcomplement2,a.descript,link,verified,the_geom,undelete,
				label_x,label_y,label_rotation,publish,inventory,uncertain,expl_id,num_value,feature_type,tstamp,lastupdate,lastupdate_user,a.insert_user,
				district_id,workcat_id_plan,asset_id,pavcat_id,drainzone_id,nodetype_1,node_sys_top_elev_1,node_sys_elev_1,nodetype_2,node_sys_top_elev_2,
				node_sys_elev_2,parent_id,expl_id2, adate, adescript	
				FROM plan_psector_x_arc pa JOIN arc a USING (arc_id) 
				WHERE psector_id=NEW.psector_id;

				INSERT INTO audit_psector_node_traceability
				SELECT nextval('SCHEMA_NAME.audit_psector_node_traceability_id_seq'), psector_id, pn.state, doable, addparam, now(), current_user, 'Execute psector', 
				n.node_id,code,top_elev,ymax,elev,custom_top_elev,custom_ymax,custom_elev,node_type,nodecat_id,epa_type,sector_id,n.state,state_type,annotation,observ,
				comment,dma_id,soilcat_id,function_type,category_type,fluid_type,location_type,workcat_id,workcat_id_end,buildercat_id,builtdate,enddate,ownercat_id,
				muni_id,postcode,streetaxis_id,postnumber,postcomplement,streetaxis2_id,postnumber2,postcomplement2,n.descript,rotation,link,verified,the_geom,undelete,
				label_x,label_y,label_rotation,publish,inventory,xyz_date,uncertain,unconnected,expl_id,num_value,feature_type,tstamp,arc_id,lastupdate,lastupdate_user,
				n.insert_user,matcat_id,district_id,workcat_id_plan,asset_id,drainzone_id,parent_id,expl_id2, adate, adescript
				FROM plan_psector_x_node pn JOIN node n USING (node_id) 
				WHERE psector_id=NEW.psector_id;
			
				INSERT INTO audit_psector_gully_traceability
				SELECT nextval('SCHEMA_NAME.audit_psector_gully_traceability_id_seq'), psector_id, pg.state, doable, pg.arc_id, l.link_id, l.the_geom, now(), current_user, 'Execute psector', gully.*
				FROM plan_psector_x_gully pg JOIN gully USING (gully_id)
				JOIN link l USING (link_id)
				WHERE psector_id=NEW.psector_id;
				
			END IF;

			-- get state_type default values
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
			UPDATE config_param_user SET value = 'true' WHERE parameter='edit_disable_statetopocontrol' AND cur_user=current_user;

			--use automatic downgrade link variable 
			SELECT value::boolean INTO v_auto_downgrade_link FROM config_param_user WHERE parameter='edit_connect_downgrade_link' AND cur_user=current_user;
			IF v_auto_downgrade_link IS NULL THEN
				INSERT INTO config_param_user VALUES ('edit_connect_downgrade_link', 'true', current_user);
			END IF;

			--change state/state_type of psector features acording to its current status on the psector_x_* table
			FOR rec_type IN (SELECT * FROM sys_feature_type WHERE classlevel = 1 OR classlevel = 2 ORDER BY id asc) LOOP

				v_sql = 'SELECT '||rec_type.id||'_id as id, state FROM plan_psector_x_'||lower(rec_type.id)||' WHERE psector_id = '||OLD.psector_id||' ORDER BY '||rec_type.id||'_id DESC;';

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

					
					-- set on service features where psector_x_* state is 1					
					EXECUTE 'UPDATE '||lower(rec_type.id)||' n SET state = 1, state_type = '||v_statetype_onservice||' 
					FROM plan_psector_x_'||lower(rec_type.id)||' p WHERE n.'||lower(rec_type.id)||'_id = p.'||lower(rec_type.id)||'_id 
					AND p.state = 1 AND p.psector_id='||OLD.psector_id||' AND n.'||lower(rec_type.id)||'_id = '''||rec.id||''' AND n.state_type<>'||v_state_obsolete_planified||';';

					GET DIAGNOSTICS v_affectrow = row_count;
					IF v_affectrow=0 THEN

                    
						-- set obsolete features where psector_x_* state is 1 but feature state_type is in plan_obsolete_state_type					
						EXECUTE 'UPDATE '||lower(rec_type.id)||' n SET state = 0, state_type = '||v_statetype_obsolete||' 
						FROM plan_psector_x_'||lower(rec_type.id)||' p WHERE n.'||lower(rec_type.id)||'_id = p.'||lower(rec_type.id)||'_id 
						AND p.state = 1 AND p.psector_id='||OLD.psector_id||' AND n.'||lower(rec_type.id)||'_id = '''||rec.id||''' AND n.state_type='||v_state_obsolete_planified||';';
                    

						GET DIAGNOSTICS v_affectrow = row_count;
						IF v_affectrow=0 THEN

							-- disconnect related connecs from arc about to be deleted
							EXECUTE 'UPDATE connec SET arc_id=NULL WHERE arc_id='''||rec.id||''';';
							IF v_projectype = 'UD' THEN
								EXECUTE 'UPDATE gully SET arc_id=NULL WHERE arc_id='''||rec.id||''';';
							END IF;

							-- delete parent arcs
							EXECUTE 'DELETE FROM arc n USING plan_psector_x_arc p WHERE n.arc_id = p.arc_id 
							AND n.arc_id = '''||rec.id||''' AND (p.addparam::json)->>''arcDivide''=''parent'';';

							GET DIAGNOSTICS v_affectrow = row_count;
							IF v_affectrow=0 THEN

								-- delete deprecated arcs
								EXECUTE 'DELETE FROM arc n USING plan_psector_x_arc p WHERE n.arc_id = p.arc_id 
								AND n.arc_id = '''||rec.id||''' AND (p.addparam::json)->>''nodeReplace''=''deprecated'';';

								GET DIAGNOSTICS v_affectrow = row_count;
								IF v_affectrow=0 THEN

									-- set obsolete features where psector_x_* state is 0									
									EXECUTE 'UPDATE '||lower(rec_type.id)||' n SET state = 0, state_type = '||v_statetype_obsolete||' 
									FROM plan_psector_x_'||lower(rec_type.id)||' p WHERE n.'||lower(rec_type.id)||'_id = p.'||lower(rec_type.id)||'_id 
									AND p.state = 0 AND p.psector_id='||OLD.psector_id||' AND n.'||lower(rec_type.id)||'_id = '''||rec.id||''';';

								END IF;
							END IF;	
						END IF;		
					END IF;

					IF lower(rec_type.id) IN ('connec', 'gully') THEN
						-- change arc_id for planified connecs (useful when existing connec changes to planified arc)
						EXECUTE 'UPDATE '||lower(rec_type.id)||' n SET arc_id = p.arc_id
						FROM plan_psector_x_'||lower(rec_type.id)||' p WHERE n.'||lower(rec_type.id)||'_id = p.'||lower(rec_type.id)||'_id 
						AND p.state = 1 AND p.psector_id='||OLD.psector_id||' AND n.'||lower(rec_type.id)||'_id = '''||rec.id||''';';
					
						-- set pjoint_id when pjoint_type=NODE getting it from exit_id on planified link
						EXECUTE 'UPDATE '||lower(rec_type.id)||' n SET pjoint_id = link.exit_id
						FROM plan_psector_x_'||lower(rec_type.id)||' p 
						JOIN link USING (link_id)
						WHERE n.'||lower(rec_type.id)||'_id = p.'||lower(rec_type.id)||'_id 
						AND p.state = 1 AND p.psector_id='||OLD.psector_id||' AND n.'||lower(rec_type.id)||'_id = '''||rec.id||'''
						AND n.pjoint_type=''NODE'';';
					
						-- set links to state 0 when its connec is 0 on psector
						EXECUTE 'UPDATE link SET state=0
						FROM plan_psector_x_'||lower(rec_type.id)||' p WHERE link.link_id = p.link_id 
						AND p.state = 0 AND p.psector_id='||OLD.psector_id||' AND link.feature_id = '''||rec.id||''';';
					
						-- set links to state 1 when its connec is 1 on psector
						EXECUTE 'UPDATE link SET state=1
						FROM plan_psector_x_'||lower(rec_type.id)||' p WHERE link.link_id = p.link_id 
						AND p.state = 1 AND p.psector_id='||OLD.psector_id||' AND link.feature_id = '''||rec.id||''';';
						
					END IF;

					-- delete from psector_x_* where state is 0
					EXECUTE 'DELETE FROM plan_psector_x_'||lower(rec_type.id)||' 
					WHERE psector_id = '||OLD.psector_id||' AND '||lower(rec_type.id)||'_id = '''||rec.id||''' AND '''||rec.state||''' = 0;';

					-- delete from psector_x_* where state is 1
					EXECUTE 'DELETE FROM plan_psector_x_'||lower(rec_type.id)||' 
					WHERE psector_id = '||OLD.psector_id||' AND '||lower(rec_type.id)||'_id = '''||rec.id||''' AND '''||rec.state||''' = 1;';
					
				END LOOP;
			END LOOP;

			--reset downgrade link variable
			IF v_auto_downgrade_link IS NULL THEN
				DELETE FROM config_param_user WHERE parameter='edit_connect_downgrade_link' AND cur_user=current_user;
			END IF;
		
			-- reset psector geometry
			UPDATE plan_psector SET the_geom=v_psector_geom WHERE psector_id=NEW.psector_id;

			--reset topology control
			UPDATE config_param_user SET value = 'false' WHERE parameter='edit_disable_statetopocontrol' AND cur_user=current_user;
				
		-- update psector status to EXECUTED (Traceability) or CANCELED (Traceability)
		ELSIF (OLD.status != NEW.status) AND (NEW.status = 0 OR NEW.status = 3) THEN
		
			-- get psector geometry
			v_psector_geom = (SELECT the_geom FROM plan_psector WHERE psector_id=NEW.psector_id);

			--set v_action when status Executed or Canceled
			IF NEW.status = 0 THEN	
				v_action='Execute psector';				
			ELSIF NEW.status = 3 THEN
				v_action='Cancel psector';
			END IF;

			-- copy values into traceability tables
			INSERT INTO audit_psector_arc_traceability
				SELECT nextval('SCHEMA_NAME.audit_psector_arc_traceability_id_seq'), psector_id, pa.state, doable, addparam, now(), current_user, v_action,
				a.arc_id,code,node_1,node_2,y1,y2,elev1,elev2,custom_y1,custom_y2,custom_elev1,custom_elev2,sys_elev1,sys_elev2,arc_type,arccat_id,
				matcat_id,epa_type,sector_id,a.state,state_type,annotation,observ,comment,sys_slope,inverted_slope,custom_length,dma_id,soilcat_id,
				function_type,category_type,fluid_type,location_type,workcat_id,workcat_id_end,buildercat_id,builtdate,enddate,ownercat_id,muni_id,
				postcode,streetaxis_id,postnumber,postcomplement,streetaxis2_id,postnumber2,postcomplement2,a.descript,link,verified,the_geom,undelete,
				label_x,label_y,label_rotation,publish,inventory,uncertain,expl_id,num_value,feature_type,tstamp,lastupdate,lastupdate_user,a.insert_user,
				district_id,workcat_id_plan,asset_id,pavcat_id,drainzone_id,nodetype_1,node_sys_top_elev_1,node_sys_elev_1,nodetype_2,node_sys_top_elev_2,
				node_sys_elev_2,parent_id,expl_id2			
			FROM plan_psector_x_arc pa JOIN arc a USING (arc_id) 
			WHERE psector_id=NEW.psector_id;
		
			INSERT INTO audit_psector_node_traceability			
				SELECT nextval('SCHEMA_NAME.audit_psector_node_traceability_id_seq'), psector_id, pn.state, doable, addparam, now(), current_user, v_action,
				n.node_id,code,top_elev,ymax,elev,custom_top_elev,custom_ymax,custom_elev,node_type,nodecat_id,epa_type,sector_id,n.state,state_type,annotation,observ,
				comment,dma_id,soilcat_id,function_type,category_type,fluid_type,location_type,workcat_id,workcat_id_end,buildercat_id,builtdate,enddate,ownercat_id,
				muni_id,postcode,streetaxis_id,postnumber,postcomplement,streetaxis2_id,postnumber2,postcomplement2,n.descript,rotation,link,verified,the_geom,undelete,
				label_x,label_y,label_rotation,publish,inventory,xyz_date,uncertain,unconnected,expl_id,num_value,feature_type,tstamp,arc_id,lastupdate,lastupdate_user,
				n.insert_user,matcat_id,district_id,workcat_id_plan,asset_id,drainzone_id,parent_id,expl_id2
			FROM plan_psector_x_node pn JOIN node n USING (node_id) 
			WHERE psector_id=NEW.psector_id;
		
			INSERT INTO audit_psector_connec_traceability
			SELECT nextval('SCHEMA_NAME.audit_psector_connec_traceability_id_seq'), psector_id, pc.state, doable, pc.arc_id, l.link_id, l.the_geom, now(), current_user, v_action, connec.*
			FROM plan_psector_x_connec pc JOIN connec USING (connec_id)
			JOIN link l USING (link_id)
			WHERE psector_id=NEW.psector_id;
		
			IF v_projectype = 'UD' THEN
				INSERT INTO audit_psector_gully_traceability
				SELECT nextval('SCHEMA_NAME.audit_psector_gully_traceability_id_seq'), psector_id, pg.state, doable, pg.arc_id, l.link_id, l.the_geom, now(), current_user, v_action, gully.*
				FROM plan_psector_x_gully pg JOIN gully USING (gully_id)
				JOIN link l USING (link_id)
				WHERE psector_id=NEW.psector_id;
			END IF;
		
			-- delete from plan_psector_x_* tables
			FOR rec_type IN (SELECT * FROM sys_feature_type WHERE classlevel = 1 OR classlevel = 2 ORDER BY id asc) LOOP
				-- delete from psector_x_*
				EXECUTE 'DELETE FROM plan_psector_x_'||lower(rec_type.id)||' 
				WHERE psector_id = '||OLD.psector_id||';';
			END LOOP;
			
			-- reset psector geometry
			UPDATE plan_psector SET the_geom=v_psector_geom WHERE psector_id=NEW.psector_id;
		
		END IF;
	END IF;
               
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
    
		IF om_aux='plan' THEN
	
			DELETE FROM plan_psector WHERE psector_id = OLD.psector_id;
			DELETE FROM arc WHERE state = 2 AND arc_id IN (SELECT arc_id FROM plan_psector_x_arc WHERE psector_id = OLD.psector_id) ;	
			DELETE FROM node WHERE state = 2 AND node_id IN (SELECT node_id FROM plan_psector_x_node WHERE psector_id = OLD.psector_id);	
			DELETE FROM connec WHERE state = 2 AND connec_id IN (SELECT connec_id FROM plan_psector_x_connec WHERE psector_id = OLD.psector_id);
			IF v_projectype='UD' THEN	
				DELETE FROM gully WHERE state = 2 AND gully_id IN (SELECT gully_id FROM plan_psector_x_gully WHERE psector_id = OLD.psector_id);
			END IF;
		
			RETURN NULL;
		END IF;
 
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
