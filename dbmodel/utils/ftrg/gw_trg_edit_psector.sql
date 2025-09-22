/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2446

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_psector()
  RETURNS trigger AS
$BODY$

DECLARE
v_sql varchar;
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
v_plan_psector_force_delete text;
v_feature_id integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    v_projectype := (SELECT project_type FROM sys_version ORDER BY id DESC LIMIT 1);

	--get obsolete_planified state_type
	v_state_obsolete_planified:= (SELECT value::json ->> 'obsolete_planified' FROM config_param_system WHERE parameter='plan_psector_status_action');

	-- get state_type default values
	SELECT value::integer INTO v_statetype_obsolete FROM config_param_user WHERE parameter='edit_statetype_0_vdefault' AND cur_user=current_user;
	IF v_statetype_obsolete IS NULL THEN
	        EXECUTE 'SELECT SCHEMA_NAME.gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3134", "function":"2446","parameters":null}}$$);';
	END IF;

	SELECT value::integer INTO v_statetype_onservice FROM config_param_user WHERE parameter='edit_statetype_1_vdefault' AND cur_user=current_user;
	IF v_statetype_onservice IS NULL THEN
	        EXECUTE 'SELECT SCHEMA_NAME.gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3136", "function":"2446","parameters":null}}$$);';
	END IF;

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

		IF NEW.workcat_id NOT IN (SELECT id FROM cat_work) THEN
			NEW.workcat_id = NULL;
		END IF;

		NEW.psector_id:= (SELECT nextval('plan_psector_id_seq'));

		-- archived is false by default
		INSERT INTO plan_psector (psector_id, name, psector_type, descript, priority, text1, text2, observ, rotation, scale,
		 atlas_id, gexpenses, vat, other, the_geom, expl_id, active, ext_code, status, text3, text4, text5, text6, num_value, workcat_id, workcat_id_plan, parent_id)
		VALUES  (NEW.psector_id, NEW.name, NEW.psector_type, NEW.descript, NEW.priority, NEW.text1, NEW.text2, NEW.observ, NEW.rotation,
		NEW.scale, NEW.atlas_id, NEW.gexpenses, NEW.vat, NEW.other, NEW.the_geom, NEW.expl_id, NEW.active,
		NEW.ext_code, NEW.status, NEW.text3, NEW.text4, NEW.text5, NEW.text6, NEW.num_value, NEW.workcat_id, NEW.workcat_id_plan, NEW.parent_id);

	    RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

		UPDATE plan_psector
		SET psector_id=NEW.psector_id, name=NEW.name, psector_type=NEW.psector_type, descript=NEW.descript, priority=NEW.priority, text1=NEW.text1,
		text2=NEW.text2, observ=NEW.observ, rotation=NEW.rotation, scale=NEW.scale, atlas_id=NEW.atlas_id,
		gexpenses=NEW.gexpenses, vat=NEW.vat, other=NEW.other, expl_id=NEW.expl_id, active=NEW.active, ext_code=NEW.ext_code, status=NEW.status,
		text3=NEW.text3, text4=NEW.text4, text5=NEW.text5, text6=NEW.text6, num_value=NEW.num_value, workcat_id=new.workcat_id, workcat_id_plan=new.workcat_id_plan, parent_id=new.parent_id, updated_at=now(), updated_by=current_user
		WHERE psector_id=OLD.psector_id;
	
		--set v_action when status Executed or Canceled
			IF NEW.status IN (3, 4) THEN
				v_action='Execute psector';
			ELSIF NEW.status IN (5, 6) THEN
				v_action='Archived psector';
			ELSIF NEW.status = 7 THEN
				v_action='Cancel psector';		
			ELSE
				v_action = coalesce(v_action, 'PLANNED'); -- planned
			END IF;

		-- update psector status to EXECUTED (On Service)
		IF (OLD.status != NEW.status) AND (NEW.status IN (3, 4)) THEN

			-- get workcat id
			IF NEW.workcat_id IS NULL THEN
				NEW.workcat_id = (SELECT value FROM config_param_user WHERE parameter= 'edit_workcat_vdefault' AND cur_user=current_user);

				IF NEW.workcat_id IS NULL THEN
					RAISE EXCEPTION 'YOU NEED TO SET SOME WORKCATID TO EXECUTE PSECTOR';
				END IF;
			END IF;


			-- get psector geometry
			v_psector_geom = (SELECT the_geom FROM plan_psector WHERE psector_id=NEW.psector_id);

			-- copy values into traceability tables
			IF v_projectype = 'WS' THEN

				INSERT INTO archived_psector_connec (psector_id, psector_state, doable, psector_arc_id, link_id, audit_tstamp, audit_user, "action", psector_descript,
					connec_id, code, top_elev, "depth", conneccat_id, sector_id, customer_code, state, state_type, arc_id, connec_length, annotation, observ, "comment", dma_id, presszone_id,
					soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber,
					postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, rotation, the_geom, label_x, label_y, label_rotation, publish, inventory, expl_id,
					num_value, feature_type, created_at, pjoint_type, pjoint_id, updated_at, updated_by, created_by, minsector_id, dqa_id, staticpressure, district_id, adate, adescript, accessibility,
					workcat_id_plan, asset_id, epa_type, om_state, conserv_state, priority, access_type, placement_type, crmzone_id, expl_visibility, plot_code, brand_id, model_id, serial_number, label_quadrant,
					n_inhabitants, supplyzone_id, datasource, lock_level, block_zone, n_hydrometer
				)
				SELECT
					pc.psector_id, pc.state, pc.doable, pc.arc_id, l.link_id, now(), current_user, 'Execute psector', pc.descript,
					c.connec_id, c.code, c.top_elev, c.depth, c.conneccat_id, c.sector_id, c.customer_code, c.state, c.state_type, c.arc_id, c.connec_length, c.annotation, c.observ, c.comment, c.dma_id, c.presszone_id,
					c.soilcat_id, c.function_type, c.category_type, c.fluid_type, c.location_type, c.workcat_id, c.workcat_id_end, c.builtdate, c.enddate, c.ownercat_id, c.muni_id, c.postcode, c.streetaxis_id, c.postnumber,
					c.postcomplement, c.streetaxis2_id, c.postnumber2, c.postcomplement2, c.descript, c.link, c.verified, c.rotation, c.the_geom, c.label_x, c.label_y, c.label_rotation, c.publish, c.inventory, c.expl_id,
					c.num_value, c.feature_type, c.created_at, c.pjoint_type, c.pjoint_id, c.updated_at, c.updated_by, c.created_by, c.minsector_id, c.dqa_id, c.staticpressure, c.district_id, c.adate, c.adescript, c.accessibility,
					c.workcat_id_plan, c.asset_id, c.epa_type, c.om_state, c.conserv_state, c.priority, c.access_type, c.placement_type, c.crmzone_id, c.expl_visibility, c.plot_code, c.brand_id, c.model_id, c.serial_number, c.label_quadrant,
					c.n_inhabitants, c.supplyzone_id, c.datasource, c.lock_level, c.block_code, c.n_hydrometer
				FROM plan_psector_x_connec pc
				JOIN connec c USING (connec_id)
				JOIN link l USING (link_id)
				WHERE psector_id=NEW.psector_id;

				INSERT INTO archived_psector_link (
					psector_id, psector_state, doable, audit_tstamp, audit_user, "action", 
					link_id, code, sys_code, top_elev1, depth1, exit_id, exit_type, top_elev2, depth2, feature_type, feature_id, linkcat_id, state, state_type, expl_id, muni_id, sector_id, supplyzone_id, presszone_id, 
					dma_id, dqa_id, omzone_id, minsector_id, location_type, fluid_type, custom_length, staticpressure1, staticpressure2, annotation, observ, "comment", descript, link, num_value, workcat_id, 
					workcat_id_end,	builtdate, enddate, brand_id, model_id, verified, uncertain, userdefined_geom, datasource,
					is_operative, lock_level, expl_visibility, created_at, created_by, updated_at, updated_by, the_geom
					)
				SELECT
					pc.psector_id, pc.state, pc.doable, now(), current_user, v_action,
					link_id, code, sys_code, top_elev1, depth1, exit_id, exit_type, top_elev2, depth2, feature_type, feature_id, linkcat_id, l.state, state_type, expl_id, muni_id, sector_id, supplyzone_id, presszone_id, 
					dma_id, dqa_id, omzone_id, minsector_id, location_type, fluid_type, custom_length, staticpressure1, staticpressure2, annotation, observ, "comment", l.descript, link, num_value, workcat_id, 
					workcat_id_end,	builtdate, enddate, brand_id, model_id, verified, uncertain, userdefined_geom, datasource,
					is_operative, lock_level, expl_visibility, created_at, created_by, updated_at, updated_by, the_geom	
				FROM plan_psector_x_connec pc
				JOIN link l USING (link_id)
				WHERE pc.psector_id = NEW.psector_id;

				-- arc & node insert is different from ud because UD has legacy of _sys_length & _sys_elev and the impossibility to remove it from old production environments
				INSERT INTO archived_psector_arc (
					psector_id, psector_state, doable, addparam, audit_tstamp, audit_user, "action", psector_descript,
					arc_id, code, node_1, node_2, arccat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", custom_length, dma_id, presszone_id, soilcat_id, function_type,
					category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id,
					postnumber2, postcomplement2, descript, link, verified, the_geom, label_x, label_y, label_rotation, publish, inventory, expl_id, num_value, feature_type, created_at, updated_at,
					updated_by, created_by, minsector_id, dqa_id, district_id, adate, adescript, workcat_id_plan, asset_id, pavcat_id, nodetype_1, elevation1, depth1, staticpressure1, nodetype_2, elevation2,
					depth2, staticpressure2, om_state, conserv_state, parent_id, expl_visibility, brand_id, model_id, serial_number, label_quadrant, supplyzone_id, datasource,
					lock_level, is_scadamap
				)
				SELECT
					pa.psector_id, pa.state, pa.doable, pa.addparam, now(), current_user, 'Execute psector', pa.descript,
					a.arc_id, a.code, a.node_1, a.node_2, a.arccat_id, a.epa_type, a.sector_id, a.state, a.state_type, a.annotation, a.observ, a.comment, a.custom_length, a.dma_id, a.presszone_id::varchar, a.soilcat_id, a.function_type,
					a.category_type, a.fluid_type, a.location_type, a.workcat_id, a.workcat_id_end, a.builtdate, a.enddate, a.ownercat_id, a.muni_id, a.postcode, a.streetaxis_id, a.postnumber, a.postcomplement, a.streetaxis2_id,
					a.postnumber2, a.postcomplement2, a.descript, a.link, a.verified, a.the_geom, a.label_x, a.label_y, a.label_rotation, a.publish, a.inventory, a.expl_id, a.num_value, a.feature_type, a.created_at, a.updated_at,
					a.updated_by, a.created_by, a.minsector_id, a.dqa_id, a.district_id, a.adate, a.adescript, a.workcat_id_plan, a.asset_id, a.pavcat_id, a.nodetype_1, a.elevation1, a.depth1, a.staticpressure1, a.nodetype_2, a.elevation2,
					a.depth2, a.staticpressure2, a.om_state, a.conserv_state, a.parent_id, a.expl_visibility, a.brand_id, a.model_id, a.serial_number, a.label_quadrant, a.supplyzone_id, a.datasource,
					a.lock_level, a.is_scadamap
				FROM plan_psector_x_arc pa
				JOIN arc a USING (arc_id)
				WHERE pa.psector_id = NEW.psector_id;

				INSERT INTO archived_psector_node (
					psector_id, psector_state, doable, addparam, audit_tstamp, audit_user, "action", psector_descript,
					node_id, code, elevation, "depth", nodecat_id, epa_type, sector_id, arc_id, parent_id, state, state_type, annotation, observ, "comment", dma_id, presszone_id, soilcat_id, function_type,
					category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id,
					postnumber2, postcomplement2, descript, link, verified, rotation, the_geom, label_x, label_y, label_rotation, publish, inventory, hemisphere, expl_id, num_value, feature_type, created_at, updated_at,
					updated_by, created_by, minsector_id, dqa_id, staticpressure, district_id, adate, adescript, accessibility, workcat_id_plan, asset_id, om_state, conserv_state, access_type, placement_type, expl_visibility,
					brand_id, model_id, serial_number, label_quadrant, top_elev, custom_top_elev, datasource, supplyzone_id, lock_level, is_scadamap
				)
				SELECT
					pn.psector_id, pn.state, pn.doable, pn.addparam, now(), current_user, 'Execute psector', pn.descript,
					n.node_id, n.code, n.custom_top_elev, n.depth, n.nodecat_id, n.epa_type, n.sector_id, n.arc_id, n.parent_id, n.state, n.state_type, n.annotation, n.observ, n.comment, n.dma_id, n.presszone_id::varchar, n.soilcat_id, n.function_type,
					n.category_type, n.fluid_type, n.location_type, n.workcat_id, n.workcat_id_end, n.builtdate, n.enddate, n.ownercat_id, n.muni_id, n.postcode, n.streetaxis_id, n.postnumber, n.postcomplement, n.streetaxis2_id,
					n.postnumber2, n.postcomplement2, n.descript, n.link, n.verified, n.rotation, n.the_geom, n.label_x, n.label_y, n.label_rotation, n.publish, n.inventory, n.hemisphere, n.expl_id, n.num_value, n.feature_type, n.created_at, n.updated_at,
					n.updated_by, n.created_by, n.minsector_id, n.dqa_id, n.staticpressure, n.district_id, n.adate, n.adescript, n.accessibility, n.workcat_id_plan, n.asset_id, n.om_state, n.conserv_state, n.access_type, n.placement_type, n.expl_visibility,
					n.brand_id, n.model_id, n.serial_number, n.label_quadrant, n.top_elev, n.custom_top_elev, n.datasource, n.supplyzone_id, n.lock_level, n.is_scadamap
				FROM plan_psector_x_node pn
				JOIN node n USING (node_id)
				WHERE pn.psector_id = NEW.psector_id;

			ELSIF v_projectype = 'UD' THEN

				INSERT INTO archived_psector_arc (
					psector_id, psector_state, doable, addparam, audit_tstamp, audit_user, "action", psector_descript,
					arc_id, code, node_1, node_2, y1, y2, elev1, elev2, custom_y1, custom_y2, custom_elev1, custom_elev2, sys_elev1, sys_elev2, arc_type, arccat_id, matcat_id, epa_type, sector_id, state, state_type,
					annotation, observ, "comment", sys_slope, inverted_slope, custom_length, dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
					ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, the_geom, label_x, label_y, label_rotation,
					publish, inventory, uncertain, expl_id, num_value, feature_type, created_at, updated_at, updated_by, created_by, district_id, workcat_id_plan, asset_id, pavcat_id, nodetype_1, node_sys_top_elev_1,
					node_sys_elev_1, nodetype_2, node_sys_top_elev_2, node_sys_elev_2, parent_id, expl_visibility, adate, adescript, visitability, label_quadrant, minsector_id, brand_id, model_id, serial_number,
					dwfzone_id, initoverflowpath, omunit_id, registration_date, meandering, conserv_state, om_state, last_visitdate, negative_offset
				)
				SELECT
					pa.psector_id, pa.state, pa.doable, pa.addparam, now(), current_user, 'Execute psector', pa.descript,
					a.arc_id, a.code, a.node_1, a.node_2, a.y1, a.y2, a.elev1, a.elev2, a.custom_y1, a.custom_y2, a.custom_elev1, a.custom_elev2, a.sys_elev1, a.sys_elev2, a.arc_type, a.arccat_id,
					a.matcat_id, a.epa_type, a.sector_id, a.state, a.state_type, a.annotation, a.observ, a.comment, a.sys_slope, a.inverted_slope, a.custom_length, a.dma_id, a.soilcat_id,
					a.function_type, a.category_type, a.fluid_type, a.location_type, a.workcat_id, a.workcat_id_end, a.builtdate, a.enddate, a.ownercat_id, a.muni_id,
					a.postcode, a.streetaxis_id, a.postnumber, a.postcomplement, a.streetaxis2_id, a.postnumber2, a.postcomplement2, a.descript, a.link, a.verified, a.the_geom,
					a.label_x, a.label_y, a.label_rotation, a.publish, a.inventory, a.uncertain, a.expl_id, a.num_value, a.feature_type, a.created_at, a.updated_at, a.updated_by, a.created_by,
					a.district_id, a.workcat_id_plan, a.asset_id, a.pavcat_id, a.nodetype_1, a.node_sys_top_elev_1, a.node_sys_elev_1, a.nodetype_2, a.node_sys_top_elev_2,
					a.node_sys_elev_2, a.parent_id, a.expl_visibility, a.adate, a.adescript, a.visitability, a.label_quadrant, a.minsector_id, a.brand_id, a.model_id, a.serial_number,
					a.dwfzone_id, a.initoverflowpath, a.omunit_id, a.registration_date, a.meandering, a.conserv_state, a.om_state, a.last_visitdate, a.negative_offset
				FROM plan_psector_x_arc pa
				JOIN arc a USING (arc_id)
				WHERE psector_id=NEW.psector_id;

				INSERT INTO archived_psector_node (
					psector_id, psector_state, doable, addparam, audit_tstamp, audit_user, "action", psector_descript,
					node_id, code, top_elev, ymax, elev, custom_top_elev, custom_ymax, custom_elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", dma_id,
					soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, conserv_state, muni_id, postcode, streetaxis_id, postnumber, postcomplement,
					streetaxis2_id, postnumber2, postcomplement2, descript, rotation, link, verified, the_geom, label_x, label_y, label_rotation, publish, inventory, xyz_date, uncertain, unconnected,
					expl_id, num_value, feature_type, created_at, arc_id, updated_at, updated_by, created_by, matcat_id, district_id, workcat_id_plan, asset_id, parent_id, expl_visibility, adate, adescript,
					placement_type, access_type, label_quadrant, minsector_id, brand_id, model_id, serial_number, dwfzone_id, datasource, omunit_id, lock_level, pavcat_id
				)
				SELECT
					pn.psector_id, pn.state, pn.doable, pn.addparam, now(), current_user, 'Execute psector', pn.descript,
					n.node_id, n.code, n.top_elev, n.ymax, n.elev, n.custom_top_elev, n.custom_ymax, n.custom_elev, n.node_type, n.nodecat_id, n.epa_type, n.sector_id, n.state, n.state_type, n.annotation, n.observ,
					n.comment, n.dma_id, n.soilcat_id, n.function_type, n.category_type, n.fluid_type, n.location_type, n.workcat_id, n.workcat_id_end, n.builtdate, n.enddate, n.ownercat_id, n.conserv_state,
					n.muni_id, n.postcode, n.streetaxis_id, n.postnumber, n.postcomplement, n.streetaxis2_id, n.postnumber2, n.postcomplement2, n.descript, n.rotation, n.link, n.verified, n.the_geom,
					n.label_x, n.label_y, n.label_rotation, n.publish, n.inventory, n.xyz_date, n.uncertain, n.unconnected, n.expl_id, n.num_value, n.feature_type, n.created_at, n.arc_id, n.updated_at, n.updated_by,
					n.created_by, n.matcat_id, n.district_id, n.workcat_id_plan, n.asset_id, n.parent_id, n.expl_visibility, n.adate, n.adescript, n.placement_type, n.access_type,
					n.label_quadrant, n.minsector_id, n.brand_id, n.model_id, n.serial_number, n.dwfzone_id, n.datasource, n.omunit_id, n.lock_level, n.pavcat_id
				FROM plan_psector_x_node pn
				JOIN node n USING (node_id)
				WHERE psector_id=NEW.psector_id;

				INSERT INTO archived_psector_connec (
					psector_id, psector_state, doable, psector_arc_id, link_id, audit_tstamp, audit_user, "action", psector_descript,
					connec_id, code, top_elev, y1, y2, connec_type, conneccat_id, sector_id, customer_code, demand, state, state_type, connec_depth, connec_length,
					arc_id, annotation, observ, "comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
					ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, rotation, the_geom,
					label_x, label_y, label_rotation, accessibility, diagonal, publish, inventory, uncertain, expl_id, num_value, feature_type, created_at, pjoint_type, pjoint_id,
					updated_at, updated_by, created_by, matcat_id, district_id, workcat_id_plan, asset_id, expl_visibility, adate, adescript, plot_code, placement_type, access_type,
					label_quadrant, n_hydrometer, minsector_id, dwfzone_id, datasource, omunit_id, lock_level
				)
				SELECT
					pc.psector_id, pc.state, pc.doable, pc.arc_id, l.link_id, now(), current_user, 'Execute psector', pc.descript,
					c.connec_id, c.code, c.top_elev, c.y1, c.y2, c.connec_type, c.conneccat_id, c.sector_id, c.customer_code, c.demand, c.state, c.state_type, c.connec_depth, c.connec_length,
					c.arc_id, c.annotation, c.observ, c.comment, c.dma_id, c.soilcat_id, c.function_type, c.category_type, c.fluid_type, c.location_type, c.workcat_id, c.workcat_id_end, c.builtdate, c.enddate,
					c.ownercat_id, c.muni_id, c.postcode, c.streetaxis_id, c.postnumber, c.postcomplement, c.streetaxis2_id, c.postnumber2, c.postcomplement2, c.descript, c.link, c.verified, c.rotation, c.the_geom,
					c.label_x, c.label_y, c.label_rotation, c.accessibility, c.diagonal, c.publish, c.inventory, c.uncertain, c.expl_id, c.num_value, c.feature_type, c.created_at, c.pjoint_type, c.pjoint_id,
					c.updated_at, c.updated_by, c.created_by, c.matcat_id, c.district_id, c.workcat_id_plan, c.asset_id, c.expl_visibility, c.adate, c.adescript, c.plot_code, c.placement_type, c.access_type,
					c.label_quadrant, c.n_hydrometer, c.minsector_id, c.dwfzone_id, c.datasource, c.omunit_id, c.lock_level
				FROM plan_psector_x_connec pc
				JOIN connec c USING (connec_id)
				JOIN link l USING (link_id)
				WHERE psector_id=NEW.psector_id;

				INSERT INTO archived_psector_link (
					psector_id, psector_state, doable, audit_tstamp, audit_user, "action",
					link_id, code, sys_code, top_elev1, y1, exit_id, exit_type, top_elev2, y2, feature_type, feature_id, link_type, linkcat_id, state, 
					state_type, expl_id, expl_id2, muni_id, sector_id, dma_id, dwfzone_id, omzone_id, drainzone_outfall, dwfzone_outfall, location_type, 
					fluid_type, custom_length, sys_slope, annotation, observ, "comment", descript, link, num_value, workcat_id, workcat_id_end, builtdate, enddate, 
					brand_id, model_id, private_linkcat_id, verified, uncertain, userdefined_geom, datasource, is_operative, lock_level, expl_visibility, created_at, created_by, updated_at, updated_by, the_geom
				)
				SELECT
					pc.psector_id, pc.state, pc.doable, now(), current_user, v_action, 
					link_id, code, sys_code, top_elev1, y1, exit_id, exit_type, top_elev2, y2, feature_type, feature_id, link_type, linkcat_id, l.state, 
					state_type, expl_id, expl_id2, muni_id, sector_id, dma_id, dwfzone_id, omzone_id, drainzone_outfall, dwfzone_outfall, location_type, 
					fluid_type, custom_length, sys_slope, annotation, observ, "comment", l.descript, link, num_value, workcat_id, workcat_id_end, builtdate, enddate, 
					brand_id, model_id, private_linkcat_id, verified, uncertain, userdefined_geom, datasource, is_operative, lock_level, expl_visibility, created_at, created_by, updated_at, updated_by, the_geom
				FROM plan_psector_x_connec pc
				JOIN link l USING (link_id)
				WHERE pc.psector_id=NEW.psector_id;

				INSERT INTO archived_psector_gully (
					psector_id, psector_state, doable, psector_arc_id, link_id, audit_tstamp, audit_user, "action", psector_descript,
					gully_id, code, top_elev, ymax, sandbox, matcat_id, gully_type, gullycat_id, units, groove, siphon, connec_length, connec_depth, arc_id, "_pol_id_", sector_id, state, state_type, annotation, observ, "comment", dma_id, soilcat_id,
					function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript,
					link, verified, rotation, the_geom, label_x, label_y, label_rotation, publish, inventory, uncertain, expl_id, num_value, feature_type, created_at, pjoint_type, pjoint_id, updated_at, updated_by, created_by, district_id,
					workcat_id_plan, asset_id, connec_y2, epa_type, groove_height, groove_length, units_placement,  expl_visibility, adate, adescript, siphon_type, odorflap, placement_type, access_type, label_quadrant, minsector_id,
					dwfzone_id, datasource, omunit_id, lock_level, length, width
				)
				SELECT
					pg.psector_id, pg.state, pg.doable, pg.arc_id, l.link_id, now(), current_user, 'Execute psector', pg.descript,
					g.gully_id, g.code, g.top_elev, g.ymax, g.sandbox, g.matcat_id, g.gully_type, g.gullycat_id, g.units, g.groove, g.siphon, g.connec_length, g.connec_depth, g.arc_id, g."_pol_id_", g.sector_id, g.state, g.state_type, g.annotation, g.observ, g.comment, g.dma_id, g.soilcat_id,
					g.function_type, g.category_type, g.fluid_type, g.location_type, g.workcat_id, g.workcat_id_end, g.builtdate, g.enddate, g.ownercat_id, g.muni_id, g.postcode, g.streetaxis_id, g.postnumber, g.postcomplement, g.streetaxis2_id, g.postnumber2, g.postcomplement2, g.descript,
					g.link, g.verified, g.rotation, g.the_geom, g.label_x, g.label_y, g.label_rotation, g.publish, g.inventory, g.uncertain, g.expl_id, g.num_value, g.feature_type, g.created_at, g.pjoint_type, g.pjoint_id, g.updated_at, g.updated_by, g.created_by, g.district_id,
					g.workcat_id_plan, g.asset_id, g.connec_y2, g.epa_type, g.groove_height, g.groove_length, g.units_placement, g.expl_visibility, g.adate, g.adescript, g.siphon_type, g.odorflap, g.placement_type, g.access_type, g.label_quadrant, g.minsector_id,
					g.dwfzone_id, g.datasource, g.omunit_id, g.lock_level, g.length, g.width
				FROM plan_psector_x_gully pg JOIN gully g USING (gully_id)
				JOIN link l USING (link_id)
				WHERE psector_id=NEW.psector_id;

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

					IF lower(rec_type.id) = 'arc' THEN

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

						-- manage obsolete arcs for arc divide
						IF (SELECT value::json->>'setArcObsolete' FROM config_param_system WHERE parameter = 'edit_arc_divide')::boolean = TRUE THEN

							EXECUTE 'UPDATE arc SET state = 0, workcat_id_end = '||quote_literal(NEW.workcat_id)||', state_type = '||v_statetype_obsolete||
							' FROM plan_psector_x_arc p WHERE arc.arc_id = p.arc_id AND p.state = 1 AND p.psector_id='||OLD.psector_id||
							' AND p.arc_id = '''||rec.id||''' AND arc.state_type='||v_state_obsolete_planified||';';
						ELSE
							EXECUTE 'DELETE FROM plan_psector_x_arc  WHERE arc_id = '''||rec.id||''' AND psector_id='||OLD.psector_id||';';
							EXECUTE 'DELETE FROM arc WHERE arc_id = '''||rec.id||''';';
						END IF;

					END IF;

					-- set on service features where psector_x_* state is 1
					EXECUTE 'UPDATE '||lower(rec_type.id)||' n SET state = 1, workcat_id = '||quote_literal(NEW.workcat_id)||', workcat_id_plan = '||quote_nullable(NEW.workcat_id_plan)||
					', state_type = '||v_statetype_onservice||'	FROM plan_psector_x_'||lower(rec_type.id)||' p WHERE n.'||lower(rec_type.id)||'_id = p.'||lower(rec_type.id)||'_id 
					AND p.state = 1 AND p.psector_id='||OLD.psector_id||' AND n.'||lower(rec_type.id)||'_id = '''||rec.id||''' AND n.state_type<>'||v_state_obsolete_planified||';';

					-- set obsolete features where psector_x_* state is 0
					EXECUTE 'UPDATE '||lower(rec_type.id)||' n SET state = 0, workcat_id_end = '||quote_literal(NEW.workcat_id)||', state_type = '||v_statetype_obsolete||' 
					FROM plan_psector_x_'||lower(rec_type.id)||' p WHERE n.'||lower(rec_type.id)||'_id = p.'||lower(rec_type.id)||'_id 
					AND p.state = 0 AND p.psector_id='||OLD.psector_id||' AND n.'||lower(rec_type.id)||'_id = '''||rec.id||''';';

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

						-- set pjoint_id when pjoint_type=ARC getting it from exit_id on planified link
						EXECUTE 'UPDATE '||lower(rec_type.id)||' n SET pjoint_id = link.exit_id
						FROM plan_psector_x_'||lower(rec_type.id)||' p 
						JOIN link USING (link_id)
						WHERE n.'||lower(rec_type.id)||'_id = p.'||lower(rec_type.id)||'_id 
						AND p.state = 1 AND p.psector_id='||OLD.psector_id||' AND n.'||lower(rec_type.id)||'_id = '''||rec.id||'''
						AND n.pjoint_type=''ARC'';';

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

			-- reset psector geometry and set inactive
			UPDATE plan_psector SET the_geom=v_psector_geom, active=false WHERE psector_id=NEW.psector_id;

			--reset topology control
			UPDATE config_param_user SET value = 'false' WHERE parameter='edit_disable_statetopocontrol' AND cur_user=current_user;

		-- update psector status to EXECUTED (Traceability) or CANCELED (Traceability)
		ELSIF (OLD.status != NEW.status) AND (NEW.status = 5 OR NEW.status = 6 OR NEW.status = 7) THEN

			-- get psector geometry
			v_psector_geom = (SELECT the_geom FROM plan_psector WHERE psector_id=NEW.psector_id);
			-- copy values into traceability tables
			IF v_projectype = 'WS' THEN

				INSERT INTO archived_psector_connec (psector_id, psector_state, doable, psector_arc_id, link_id, link_the_geom, audit_tstamp, audit_user, "action", psector_descript,
					connec_id, code, top_elev, "depth", conneccat_id, sector_id, customer_code, state, state_type, arc_id, connec_length, annotation, observ, "comment", dma_id, presszone_id,
					soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber,
					postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, rotation, the_geom, label_x, label_y, label_rotation, publish, inventory, expl_id,
					num_value, feature_type, created_at, pjoint_type, pjoint_id, updated_at, updated_by, created_by, minsector_id, dqa_id, staticpressure, district_id, adate, adescript, accessibility,
					workcat_id_plan, asset_id, epa_type, om_state, conserv_state, priority, access_type, placement_type, crmzone_id, expl_visibility, plot_code, brand_id, model_id, serial_number, label_quadrant,
					n_inhabitants, supplyzone_id, datasource, lock_level, block_zone, n_hydrometer
				)
				SELECT
					pc.psector_id, pc.state, pc.doable, pc.arc_id, l.link_id, l.the_geom, now(), current_user, v_action, pc.descript,
					c.connec_id, c.code, c.top_elev, c.depth, c.conneccat_id, c.sector_id, c.customer_code, c.state, c.state_type, c.arc_id, c.connec_length, c.annotation, c.observ, c.comment, c.dma_id, c.presszone_id,
					c.soilcat_id, c.function_type, c.category_type, c.fluid_type, c.location_type, c.workcat_id, c.workcat_id_end, c.builtdate, c.enddate, c.ownercat_id, c.muni_id, c.postcode, c.streetaxis_id, c.postnumber,
					c.postcomplement, c.streetaxis2_id, c.postnumber2, c.postcomplement2, c.descript, c.link, c.verified, c.rotation, c.the_geom, c.label_x, c.label_y, c.label_rotation, c.publish, c.inventory, c.expl_id,
					c.num_value, c.feature_type, c.created_at, c.pjoint_type, c.pjoint_id, c.updated_at, c.updated_by, c.created_by, c.minsector_id, c.dqa_id, c.staticpressure, c.district_id, c.adate, c.adescript, c.accessibility,
					c.workcat_id_plan, c.asset_id, c.epa_type, c.om_state, c.conserv_state, c.priority, c.access_type, c.placement_type, c.crmzone_id, c.expl_visibility, c.plot_code, c.brand_id, c.model_id, c.serial_number, c.label_quadrant,
					c.n_inhabitants, c.supplyzone_id, c.datasource, c.lock_level, c.block_code, c.n_hydrometer
				FROM plan_psector_x_connec pc
				JOIN connec c USING (connec_id)
				LEFT JOIN link l USING (link_id)
				WHERE psector_id=NEW.psector_id;


				INSERT INTO archived_psector_link (
					psector_id, psector_state, doable, audit_tstamp, audit_user, "action",
					link_id, code, sys_code, top_elev1, depth1, exit_id, exit_type, top_elev2, depth2, feature_type, feature_id, linkcat_id, state, state_type, expl_id, muni_id, sector_id, supplyzone_id, presszone_id, 
					dma_id, dqa_id, omzone_id, minsector_id, location_type, fluid_type, custom_length, staticpressure1, staticpressure2, annotation, observ, "comment", descript, link, num_value, workcat_id, 
					workcat_id_end,	builtdate, enddate, brand_id, model_id, verified, uncertain, userdefined_geom, datasource,
					is_operative, lock_level, expl_visibility, created_at, created_by, updated_at, updated_by, the_geom
					)
				SELECT
					pc.psector_id, pc.state, pc.doable, now(), current_user, v_action,
					link_id, code, sys_code, top_elev1, depth1, exit_id, exit_type, top_elev2, depth2, feature_type, feature_id, linkcat_id, l.state, state_type, expl_id, muni_id, sector_id, supplyzone_id, presszone_id, 
					dma_id, dqa_id, omzone_id, minsector_id, location_type, fluid_type, custom_length, staticpressure1, staticpressure2, annotation, observ, "comment", l.descript, link, num_value, workcat_id, 
					workcat_id_end,	builtdate, enddate, brand_id, model_id, verified, uncertain, userdefined_geom, datasource,
					is_operative, lock_level, expl_visibility, created_at, created_by, updated_at, updated_by, the_geom	
				FROM plan_psector_x_connec pc
				JOIN link l USING (link_id)
				WHERE pc.psector_id = NEW.psector_id;

				-- arc & node insert is different from ud because UD has legacy of _sys_length & _sys_elev and the impossibility to remove it from old production environments
				INSERT INTO archived_psector_arc (
					psector_id, psector_state, doable, addparam, audit_tstamp, audit_user, "action", psector_descript,
					arc_id, code, node_1, node_2, arccat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", custom_length, dma_id, presszone_id, soilcat_id, function_type,
					category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id,
					postnumber2, postcomplement2, descript, link, verified, the_geom, label_x, label_y, label_rotation, publish, inventory, expl_id, num_value, feature_type, created_at, updated_at,
					updated_by, created_by, minsector_id, dqa_id, district_id, adate, adescript, workcat_id_plan, asset_id, pavcat_id, nodetype_1, elevation1, depth1, staticpressure1, nodetype_2, elevation2,
					depth2, staticpressure2, om_state, conserv_state, parent_id, expl_visibility, brand_id, model_id, serial_number, label_quadrant, supplyzone_id, datasource,
					lock_level, is_scadamap
				)
				SELECT
					pa.psector_id, pa.state, pa.doable, pa.addparam, now(), current_user, v_action, pa.descript,
					a.arc_id, a.code, a.node_1, a.node_2, a.arccat_id, a.epa_type, a.sector_id, a.state, a.state_type, a.annotation, a.observ, a.comment, a.custom_length, a.dma_id, a.presszone_id::varchar, a.soilcat_id, a.function_type,
					a.category_type, a.fluid_type, a.location_type, a.workcat_id, a.workcat_id_end, a.builtdate, a.enddate, a.ownercat_id, a.muni_id, a.postcode, a.streetaxis_id, a.postnumber, a.postcomplement, a.streetaxis2_id,
					a.postnumber2, a.postcomplement2, a.descript, a.link, a.verified, a.the_geom, a.label_x, a.label_y, a.label_rotation, a.publish, a.inventory, a.expl_id, a.num_value, a.feature_type, a.created_at, a.updated_at,
					a.updated_by, a.created_by, a.minsector_id, a.dqa_id, a.district_id, a.adate, a.adescript, a.workcat_id_plan, a.asset_id, a.pavcat_id, a.nodetype_1, a.elevation1, a.depth1, a.staticpressure1, a.nodetype_2, a.elevation2,
					a.depth2, a.staticpressure2, a.om_state, a.conserv_state, a.parent_id, a.expl_visibility, a.brand_id, a.model_id, a.serial_number, a.label_quadrant, a.supplyzone_id, a.datasource,
					a.lock_level, a.is_scadamap
				FROM plan_psector_x_arc pa
				JOIN arc a USING (arc_id)
				WHERE pa.psector_id = NEW.psector_id;

				INSERT INTO archived_psector_node (
					psector_id, psector_state, doable, addparam, audit_tstamp, audit_user, "action", psector_descript,
					node_id, code, elevation, "depth", nodecat_id, epa_type, sector_id, arc_id, parent_id, state, state_type, annotation, observ, "comment", dma_id, presszone_id, soilcat_id, function_type,
					category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id,
					postnumber2, postcomplement2, descript, link, verified, rotation, the_geom, label_x, label_y, label_rotation, publish, inventory, hemisphere, expl_id, num_value, feature_type, created_at, updated_at,
					updated_by, created_by, minsector_id, dqa_id, staticpressure, district_id, adate, adescript, accessibility, workcat_id_plan, asset_id, om_state, conserv_state, access_type, placement_type, expl_visibility,
					brand_id, model_id, serial_number, label_quadrant, top_elev, custom_top_elev, datasource, supplyzone_id, lock_level, is_scadamap
				)
				SELECT
					pn.psector_id, pn.state, pn.doable, pn.addparam, now(), current_user, v_action, pn.descript,
					n.node_id, n.code, n.custom_top_elev, n.depth, n.nodecat_id, n.epa_type, n.sector_id, n.arc_id, n.parent_id, n.state, n.state_type, n.annotation, n.observ, n.comment, n.dma_id, n.presszone_id::varchar, n.soilcat_id, n.function_type,
					n.category_type, n.fluid_type, n.location_type, n.workcat_id, n.workcat_id_end, n.builtdate, n.enddate, n.ownercat_id, n.muni_id, n.postcode, n.streetaxis_id, n.postnumber, n.postcomplement, n.streetaxis2_id,
					n.postnumber2, n.postcomplement2, n.descript, n.link, n.verified, n.rotation, n.the_geom, n.label_x, n.label_y, n.label_rotation, n.publish, n.inventory, n.hemisphere, n.expl_id, n.num_value, n.feature_type, n.created_at, n.updated_at,
					n.updated_by, n.created_by, n.minsector_id, n.dqa_id, n.staticpressure, n.district_id, n.adate, n.adescript, n.accessibility, n.workcat_id_plan, n.asset_id, n.om_state, n.conserv_state, n.access_type, n.placement_type, n.expl_visibility,
					n.brand_id, n.model_id, n.serial_number, n.label_quadrant, n.top_elev, n.custom_top_elev, n.datasource, n.supplyzone_id, n.lock_level, n.is_scadamap
				FROM plan_psector_x_node pn
				JOIN node n USING (node_id)
				WHERE pn.psector_id = NEW.psector_id;

			ELSIF v_projectype = 'UD' THEN


				INSERT INTO archived_psector_arc (
					psector_id, psector_state, doable, addparam, audit_tstamp, audit_user, "action", psector_descript,
					arc_id, code, node_1, node_2, y1, y2, elev1, elev2, custom_y1, custom_y2, custom_elev1, custom_elev2, sys_elev1, sys_elev2, arc_type, arccat_id, matcat_id, epa_type, sector_id, state, state_type,
					annotation, observ, "comment", sys_slope, inverted_slope, custom_length, dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
					ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, the_geom, label_x, label_y, label_rotation,
					publish, inventory, uncertain, expl_id, num_value, feature_type, created_at, updated_at, updated_by, created_by, district_id, workcat_id_plan, asset_id, pavcat_id,  nodetype_1, node_sys_top_elev_1,
					node_sys_elev_1, nodetype_2, node_sys_top_elev_2, node_sys_elev_2, parent_id, expl_visibility, adate, adescript, visitability, label_quadrant, minsector_id, brand_id, model_id, serial_number,
					dwfzone_id, initoverflowpath, omunit_id, registration_date, meandering, conserv_state, om_state, last_visitdate, negative_offset
				)
				SELECT
					pa.psector_id, pa.state, pa.doable, pa.addparam, now(), current_user, v_action, pa.descript,
					a.arc_id, a.code, a.node_1, a.node_2, a.y1, a.y2, a.elev1, a.elev2, a.custom_y1, a.custom_y2, a.custom_elev1, a.custom_elev2, a.sys_elev1, a.sys_elev2, a.arc_type, a.arccat_id,
					a.matcat_id, a.epa_type, a.sector_id, a.state, a.state_type, a.annotation, a.observ, a.comment, a.sys_slope, a.inverted_slope, a.custom_length, a.dma_id, a.soilcat_id,
					a.function_type, a.category_type, a.fluid_type, a.location_type, a.workcat_id, a.workcat_id_end, a.builtdate, a.enddate, a.ownercat_id, a.muni_id,
					a.postcode, a.streetaxis_id, a.postnumber, a.postcomplement, a.streetaxis2_id, a.postnumber2, a.postcomplement2, a.descript, a.link, a.verified, a.the_geom,
					a.label_x, a.label_y, a.label_rotation, a.publish, a.inventory, a.uncertain, a.expl_id, a.num_value, a.feature_type, a.created_at, a.updated_at, a.updated_by, a.created_by,
					a.district_id, a.workcat_id_plan, a.asset_id, a.pavcat_id,  a.nodetype_1, a.node_sys_top_elev_1, a.node_sys_elev_1, a.nodetype_2, a.node_sys_top_elev_2,
					a.node_sys_elev_2, a.parent_id, a.expl_visibility, a.adate, a.adescript, a.visitability, a.label_quadrant, a.minsector_id, a.brand_id, a.model_id, a.serial_number,
					a.dwfzone_id, a.initoverflowpath, a.omunit_id, a.registration_date, a.meandering, a.conserv_state, a.om_state, a.last_visitdate, a.negative_offset
				FROM plan_psector_x_arc pa
				JOIN arc a USING (arc_id)
				WHERE psector_id=NEW.psector_id;

				INSERT INTO archived_psector_node (
					psector_id, psector_state, doable, addparam, audit_tstamp, audit_user, "action", psector_descript,
					node_id, code, top_elev, ymax, elev, custom_top_elev, custom_ymax, custom_elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", dma_id,
					soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement,
					streetaxis2_id, postnumber2, postcomplement2, descript, rotation, link, verified, the_geom, label_x, label_y, label_rotation, publish, inventory, xyz_date, uncertain, unconnected,
					expl_id, num_value, feature_type, created_at, arc_id, updated_at, updated_by, created_by, matcat_id, district_id, workcat_id_plan, asset_id, parent_id, expl_visibility, adate, adescript,
					placement_type, access_type, label_quadrant, minsector_id, brand_id, model_id, serial_number, dwfzone_id, datasource, omunit_id, lock_level, pavcat_id
				)
				SELECT
					pn.psector_id, pn.state, pn.doable, pn.addparam, now(), current_user, v_action, pn.descript,
					n.node_id, n.code, n.top_elev, n.ymax, n.elev, n.custom_top_elev, n.custom_ymax, n.custom_elev, n.node_type, n.nodecat_id, n.epa_type, n.sector_id, n.state, n.state_type, n.annotation, n.observ,
					n.comment, n.dma_id, n.soilcat_id, n.function_type, n.category_type, n.fluid_type, n.location_type, n.workcat_id, n.workcat_id_end, n.builtdate, n.enddate, n.ownercat_id,
					n.muni_id, n.postcode, n.streetaxis_id, n.postnumber, n.postcomplement, n.streetaxis2_id, n.postnumber2, n.postcomplement2, n.descript, n.rotation, n.link, n.verified, n.the_geom,
					n.label_x, n.label_y, n.label_rotation, n.publish, n.inventory, n.xyz_date, n.uncertain, n.unconnected, n.expl_id, n.num_value, n.feature_type, n.created_at, n.arc_id, n.updated_at, n.updated_by,
					n.created_by, n.matcat_id, n.district_id, n.workcat_id_plan, n.asset_id,  n.parent_id, n.expl_visibility, n.adate, n.adescript, n.placement_type, n.access_type,
					n.label_quadrant, n.minsector_id, n.brand_id, n.model_id, n.serial_number, n.dwfzone_id, n.datasource, n.omunit_id, n.lock_level, n.pavcat_id
				FROM plan_psector_x_node pn
				JOIN node n USING (node_id)
				WHERE psector_id=NEW.psector_id;

				INSERT INTO archived_psector_connec (
					psector_id, psector_state, doable, psector_arc_id, link_id, link_the_geom, audit_tstamp, audit_user, "action", psector_descript,
					connec_id, code, top_elev, y1, y2, connec_type, conneccat_id, sector_id, customer_code, demand, state, state_type, connec_depth, connec_length,
					arc_id, annotation, observ, "comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
					ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, rotation, the_geom,
					label_x, label_y, label_rotation, accessibility, diagonal, publish, inventory, uncertain, expl_id, num_value, feature_type, created_at, pjoint_type, pjoint_id,
					updated_at, updated_by, created_by, matcat_id, district_id, workcat_id_plan, asset_id, expl_visibility, adate, adescript, plot_code, placement_type, access_type,
					label_quadrant, n_hydrometer, minsector_id, dwfzone_id, datasource, omunit_id, lock_level
				)
				SELECT
					pc.psector_id, pc.state, pc.doable, pc.arc_id, l.link_id, l.the_geom, now(), current_user, v_action, pc.descript,
					c.connec_id, c.code, c.top_elev, c.y1, c.y2, c.connec_type, c.conneccat_id, c.sector_id, c.customer_code,  c.demand, c.state, c.state_type, c.connec_depth, c.connec_length,
					c.arc_id, c.annotation, c.observ, c.comment, c.dma_id, c.soilcat_id, c.function_type, c.category_type, c.fluid_type, c.location_type, c.workcat_id, c.workcat_id_end, c.builtdate, c.enddate,
					c.ownercat_id, c.muni_id, c.postcode, c.streetaxis_id, c.postnumber, c.postcomplement, c.streetaxis2_id, c.postnumber2, c.postcomplement2, c.descript, c.link, c.verified, c.rotation, c.the_geom,
					c.label_x, c.label_y, c.label_rotation, c.accessibility, c.diagonal, c.publish, c.inventory, c.uncertain, c.expl_id, c.num_value, c.feature_type, c.created_at, c.pjoint_type, c.pjoint_id,
					c.updated_at, c.updated_by, c.created_by, c.matcat_id, c.district_id, c.workcat_id_plan, c.asset_id, c.expl_visibility, c.adate, c.adescript, c.plot_code, c.placement_type, c.access_type,
					c.label_quadrant, c.n_hydrometer, c.minsector_id, c.dwfzone_id, c.datasource, c.omunit_id, c.lock_level
				FROM plan_psector_x_connec pc
				JOIN connec c USING (connec_id)
				JOIN link l USING (link_id)
				WHERE psector_id=NEW.psector_id;

				INSERT INTO archived_psector_link (
					psector_id, psector_state, doable, audit_tstamp, audit_user, "action",
					link_id, code, sys_code, top_elev1, y1, exit_id, exit_type, top_elev2, y2, feature_type, feature_id, link_type, linkcat_id, state, 
					state_type, expl_id, expl_id2, muni_id, sector_id, dma_id, dwfzone_id, omzone_id, drainzone_outfall, dwfzone_outfall, location_type, 
					fluid_type, custom_length, sys_slope, annotation, observ, "comment", descript, link, num_value, workcat_id, workcat_id_end, builtdate, enddate, 
					brand_id, model_id, private_linkcat_id, verified, uncertain, userdefined_geom, datasource, is_operative, lock_level, expl_visibility, created_at, created_by, updated_at, updated_by, the_geom
				)
				SELECT
					pc.psector_id, pc.state, pc.doable, now(), current_user, v_action, 
					link_id, code, sys_code, top_elev1, y1, exit_id, exit_type, top_elev2, y2, feature_type, feature_id, link_type, linkcat_id, l.state, 
					state_type, expl_id, expl_id2, muni_id, sector_id, dma_id, dwfzone_id, omzone_id, drainzone_outfall, dwfzone_outfall, location_type, 
					fluid_type, custom_length, sys_slope, annotation, observ, "comment", l.descript, link, num_value, workcat_id, workcat_id_end, builtdate, enddate, 
					brand_id, model_id, private_linkcat_id, verified, uncertain, userdefined_geom, datasource, is_operative, lock_level, expl_visibility, created_at, created_by, updated_at, updated_by, the_geom
				FROM plan_psector_x_connec pc
				JOIN link l USING (link_id)
				WHERE pc.psector_id=NEW.psector_id;

				INSERT INTO archived_psector_gully (
					psector_id, psector_state, doable, psector_arc_id, link_id, audit_tstamp, audit_user, "action", psector_descript,
					gully_id, code, top_elev, ymax, sandbox, matcat_id, gully_type, gullycat_id, units, groove, siphon, connec_length, connec_depth, arc_id, "_pol_id_", sector_id, state, state_type, annotation, observ, "comment", dma_id, soilcat_id,
					function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript,
					link, verified, rotation, the_geom, label_x, label_y, label_rotation, publish, inventory, uncertain, expl_id, num_value, feature_type, created_at, pjoint_type, pjoint_id, updated_at, updated_by, created_by, district_id,
					workcat_id_plan, asset_id, connec_y2, epa_type, groove_height, groove_length, units_placement,  expl_visibility, adate, adescript, siphon_type, odorflap, placement_type, access_type, label_quadrant, minsector_id,
					dwfzone_id, datasource, omunit_id, lock_level, length, width
				)
				SELECT
					pg.psector_id, pg.state, pg.doable, pg.arc_id, pg.link_id, now(), current_user, v_action, pg.descript,
				    g.gully_id, g.code, g.top_elev, g.ymax, g.sandbox, g.matcat_id, g.gully_type, g.gullycat_id, g.units, g.groove, g.siphon, g.connec_length, g.connec_depth, g.arc_id, g."_pol_id_", g.sector_id, g.state, g.state_type, g.annotation, g.observ, g.comment, g.dma_id, g.soilcat_id,
					g.function_type, g.category_type, g.fluid_type, g.location_type, g.workcat_id, g.workcat_id_end, g.builtdate, g.enddate, g.ownercat_id, g.muni_id, g.postcode, g.streetaxis_id, g.postnumber, g.postcomplement, g.streetaxis2_id, g.postnumber2, g.postcomplement2, g.descript,
					g.link, g.verified, g.rotation, g.the_geom, g.label_x, g.label_y, g.label_rotation, g.publish, g.inventory, g.uncertain, g.expl_id, g.num_value, g.feature_type, g.created_at, g.pjoint_type, g.pjoint_id, g.updated_at, g.updated_by, g.created_by, g.district_id,
					g.workcat_id_plan, g.asset_id, g.connec_y2, g.epa_type, g.groove_height, g.groove_length, g.units_placement, g.expl_visibility, g.adate, g.adescript, g.siphon_type, g.odorflap, g.placement_type, g.access_type, g.label_quadrant, g.minsector_id,
					g.dwfzone_id, g.datasource, g.omunit_id, g.lock_level, g.length, g.width
				FROM plan_psector_x_gully pg JOIN gully USING (gully_id)
				JOIN gully g USING (gully_id)
				WHERE psector_id=NEW.psector_id;

			END IF;

			-- get v_plan_psector_force_delete and set to true in order to also delete from arc/node/connec when delete from plan_psector_x_*
			SELECT value INTO v_plan_psector_force_delete FROM config_param_user WHERE parameter='plan_psector_force_delete' AND cur_user=current_user;
			UPDATE config_param_user SET value='true' WHERE parameter='plan_psector_force_delete' AND cur_user=current_user;

			-- delete from plan_psector_x_* tables
			FOR rec_type IN (SELECT * FROM sys_feature_type WHERE classlevel IN (1,2) ORDER BY id asc) LOOP
				-- delete from psector_x_*
				FOR v_feature_id IN
					EXECUTE 'DELETE FROM plan_psector_x_'||lower(rec_type.id)||' 
					WHERE psector_id = '||OLD.psector_id||' RETURNING '|| lower(rec_type.id)||'_id'
				LOOP
					EXECUTE 'DELETE FROM '||lower(rec_type.id) ||'
					WHERE '||lower(rec_type.id) ||'_id = '||v_feature_id||' AND state = 2;';
				END LOOP;
			END LOOP;

			-- reset psector geometry and set inactive
			UPDATE plan_psector SET the_geom=v_psector_geom, active=false WHERE psector_id=NEW.psector_id;

			-- reset plan_psector_force_delete
			UPDATE config_param_user SET value=v_plan_psector_force_delete WHERE parameter='plan_psector_force_delete' AND cur_user=current_user;

		
		ELSIF OLD.status IN (5,6,7) AND NEW.status IN (1,2) THEN -- change the status of the psector in order to restore it
		
			EXECUTE '
			SELECT gw_fct_plan_recover_archived($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"psectorId":"'||NEW.psector_id||'"}}$$)
			';
	
		END IF;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM connec WHERE state = 2 AND connec_id IN (SELECT connec_id FROM plan_psector_x_connec WHERE psector_id = OLD.psector_id);
		IF v_projectype='UD' THEN
			DELETE FROM gully WHERE state = 2 AND gully_id IN (SELECT gully_id FROM plan_psector_x_gully WHERE psector_id = OLD.psector_id);
		END IF;
		DELETE FROM arc WHERE state = 2 AND arc_id IN (SELECT arc_id FROM plan_psector_x_arc WHERE psector_id = OLD.psector_id) ;
		DELETE FROM node WHERE state = 2 AND node_id IN (SELECT node_id FROM plan_psector_x_node WHERE psector_id = OLD.psector_id);

		DELETE FROM plan_psector WHERE psector_id = OLD.psector_id;

		RETURN NULL;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
