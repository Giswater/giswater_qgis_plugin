/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3304

CREATE OR REPLACE FUNCTION gw_fct_admin_manage_planmode(p_data json)
  RETURNS json AS
$BODY$

/*
INSTRUCTIONS
------------
This function disable/enable the plan mode in order to work in big projects without planmode wich can be the responsable for loss of performance
The function does:
- Toggle v_state_arc, v_state_node, v_state_connec, v_state_gully, v_state_link views without/with references of plan issues
- Add/remove state=2 on value_state combo
- Remove/add tab_psector for selector dialog


EXAMPLE
-------
SELECT gw_fct_admin_manage_planmode($${"data":{"action":"DISABLE", "valueStateDelete":false}}$$)
								    when there are objects with state=2 -->"valueStateDelete":false
								    when there are not objects with state=2 -->"valueStateDelete":true

SELECT gw_fct_admin_manage_planmode($${"data":{"action":"ENABLE", "valueStatePlanName":"PLANIFIED"}}$$)
*/


DECLARE 

v_message text;
v_action text;
v_version text;
v_error_context text;
v_project_type text;
v_valuestatedelete boolean;
v_valuestateplanname text;

BEGIN 
	-- search path
	SET search_path = "SCHEMA_NAME", public;

	 -- select project type
	SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get input parameters
	v_action := (p_data ->> 'data')::json->> 'action';
	v_valuestatedelete := (p_data ->> 'data')::json->> 'valueStateDelete';
	v_valuestateplanname := (p_data ->> 'data')::json->> 'valueStatePlanName';

	IF v_action = 'DISABLE' THEN

		IF v_valuestatedelete THEN
			DELETE FROM value_state WHERE id = 2;
		ELSE
			UPDATE config_param_system 
			SET value = '{"table":"value_state","selector":"selector_state","table_id":"id","selector_id":"state_id","label":"id, '' - '', name","manageAll":false,"query_filter":" AND id < 3"}'
			WHERE parameter = 'basic_selector_tab_network_state';
		END IF;

		UPDATE config_form_tabs SET formname = 'selector_basic_' where tabname = 'tab_psector' and formname = 'selector_basic';

		CREATE OR REPLACE VIEW v_state_arc AS 
		  SELECT arc.arc_id FROM selector_state, arc
		  WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text;

		CREATE OR REPLACE VIEW v_state_connec AS 
		  SELECT connec.connec_id, connec.arc_id,state AS flag
		  FROM selector_state, selector_expl, connec
		  WHERE connec.state = selector_state.state_id AND (connec.expl_id = selector_expl.expl_id OR connec.expl_id2 = selector_expl.expl_id)
		  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text;
		 
		CREATE OR REPLACE VIEW v_state_link AS 
		  SELECT link.link_id
		  FROM selector_state, selector_expl, link
		  WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) 
		  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text;

		CREATE OR REPLACE VIEW v_state_link_connec AS 
		 SELECT link.link_id
		 FROM selector_state,selector_expl, link
		 WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) 
		 AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'CONNEC'::text;
		  
		CREATE OR REPLACE VIEW v_state_node AS 
		  SELECT node.node_id FROM selector_state, node
		  WHERE node.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text;


		IF v_project_type = 'WS' THEN

			-- disconnect possibility to show for each connec different arc_id, exit_id and mapzones in function of planified link
			CREATE OR REPLACE VIEW v_connec AS 
			with s as (SELECT expl_id FROM selector_expl WHERE selector_expl.cur_user = current_user) 
			SELECT c.connec_id,c.code,c.elevation,c.depth,c.connec_type,c.sys_type,c.connecat_id,c.expl_id,c.macroexpl_id,
			c.sector_id,
			c.sector_name,c.macrosector_id,c.customer_code,c.cat_matcat_id,c.cat_pnom,c.cat_dnom,c.connec_length,c.state,c.state_type,
			c.n_hydrometer,v_state_connec.arc_id,c.annotation,c.observ,c.comment,
			c.minsector_id,
			c.dma_id,
			c.dma_name,
			c.macrodma_id,
			c.presszone_id, 
			c.presszone_name,
			c.staticpressure,
			c.dqa_id,
			c.dqa_name,
			c.macrodqa_id,
			c.soilcat_id,c.function_type,c.category_type,c.fluid_type,c.location_type,c.workcat_id,c.workcat_id_end,c.buildercat_id,
			c.builtdate,c.enddate,c.ownercat_id,c.muni_id,c.postcode,c.district_id,c.streetname,c.postnumber,c.postcomplement,
			c.streetname2,c.postnumber2,c.postcomplement2,c.descript,c.svg,c.rotation,c.link,c.verified,c.undelete,c.label,
			c.label_x,c.label_y,c.label_rotation,c.publish,c.inventory,c.num_value,c.connectype_id,
			c.pjoint_id,
			c.pjoint_type,
			c.tstamp,c.insert_user,c.lastupdate,c.lastupdate_user,c.the_geom,c.adate,c.adescript,c.accessibility,c.workcat_id_plan,c.asset_id,
			c.dma_style,c.presszone_style,c.epa_type,c.priority,c.valve_location,c.valve_type,c.shutoff_valve,c.access_type,c.placement_type,c.press_max,
			c.press_min,c.press_avg,c.demand,c.om_state,c.conserv_state,c.crmzone_id,c.crmzone_name,c.expl_id2,c.quality_max,c.quality_min,
			c.quality_avg,c.is_operative,c.region_id,c.province_id,c.plot_code
			FROM s , vu_connec c
			JOIN v_state_connec USING (connec_id)
			WHERE (c.expl_id = s.expl_id OR c.expl_id2 = s.expl_id);

		ELSE
			-- gully
			CREATE OR REPLACE VIEW v_state_gully AS 
			SELECT DISTINCT ON (gully_id) gully_id, arc_id 
			FROM selector_state, selector_expl, gully
			WHERE gully.state = selector_state.state_id AND (gully.expl_id = selector_expl.expl_id OR gully.expl_id2 = selector_expl.expl_id) 
			AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text;

			-- link gully
			CREATE OR REPLACE VIEW v_state_link_gully AS 
			SELECT DISTINCT link.link_id FROM selector_state, selector_expl,link
			WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id)
			AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'GULLY'::text;

			-- disconnect possibility to show for each connec different arc_id, exit_id and mapzones in function of planified link
			CREATE OR REPLACE VIEW v_connec AS 
			with s as (SELECT expl_id FROM selector_expl WHERE selector_expl.cur_user = current_user) 
			SELECT c.connec_id, c.code, c.customer_code, c.top_elev, c.y1, c.y2, c.connecat_id, c.connec_type, c.sys_type,
			c.private_connecat_id, c.matcat_id, c.expl_id, c.macroexpl_id,
			c.sector_id,
			c.macrosector_id,
			c.demand,c.state,c.state_type,c.connec_depth,c.connec_length,v_state_connec.arc_id,c.annotation,c.observ,c.comment,
			c.dma_id,
			c.macrodma_id,
			c.soilcat_id,c.function_type,c.category_type,c.fluid_type,c.location_type,c.workcat_id,c.workcat_id_end,c.buildercat_id,
			c.builtdate,c.enddate,c.ownercat_id,c.muni_id,c.postcode,c.district_id,c.streetname,c.postnumber,c.postcomplement,
			c.streetname2,c.postnumber2,c.postcomplement2,c.descript,c.svg,c.rotation,c.link,c.verified,c.undelete,c.label,
			c.label_x,c.label_y,c.label_rotation,c.accessibility,c.diagonal,c.publish,c.inventory,c.uncertain,c.num_value,
			c.pjoint_id, 
			c.pjoint_type,
			c.tstamp,c.insert_user,c.lastupdate,c.lastupdate_user,c.the_geom,c.workcat_id_plan,c.asset_id,c.drainzone_id,c.expl_id2,
			c.is_operative,c.region_id,c.province_id,c.adate,c.adescript,c.plot_code
			FROM s, vu_connec c
			JOIN v_state_connec USING (connec_id)
			WHERE (c.expl_id = s.expl_id OR c.expl_id2 = s.expl_id);

			-- disconnect possibility to show for each gully different arc_id, exit_id and mapzones in function of planified link
			CREATE OR REPLACE VIEW v_gully AS 
			with s as (SELECT expl_id FROM selector_expl WHERE selector_expl.cur_user = current_user) 
			SELECT vu_gully.gully_id,vu_gully.code,vu_gully.top_elev,vu_gully.ymax,vu_gully.sandbox,vu_gully.matcat_id,vu_gully.gully_type,vu_gully.sys_type,vu_gully.gratecat_id,vu_gully.cat_grate_matcat,
			vu_gully.units,vu_gully.groove,vu_gully.siphon,vu_gully.connec_arccat_id,vu_gully.connec_length,vu_gully.connec_depth,v_state_gully.arc_id,vu_gully.expl_id,vu_gully.macroexpl_id,
			vu_gully.sector_id,
			vu_gully.state,vu_gully.state_type,vu_gully.annotation,vu_gully.observ,vu_gully.comment,
			vu_gully.dma_id,
			vu_gully.macrodma_id,
			vu_gully.soilcat_id,vu_gully.function_type,vu_gully.category_type,vu_gully.fluid_type,vu_gully.location_type,vu_gully.workcat_id,vu_gully.workcat_id_end,vu_gully.buildercat_id,vu_gully.builtdate,
			vu_gully.enddate,vu_gully.ownercat_id,vu_gully.muni_id,vu_gully.postcode,vu_gully.district_id,vu_gully.streetname,vu_gully.postnumber,vu_gully.postcomplement,vu_gully.streetname2,vu_gully.postnumber2,
			vu_gully.postcomplement2,vu_gully.descript,vu_gully.svg,vu_gully.rotation,vu_gully.link,vu_gully.verified,vu_gully.undelete,vu_gully.label,vu_gully.label_x,vu_gully.label_y,vu_gully.label_rotation,
			vu_gully.publish,vu_gully.inventory,vu_gully.uncertain,vu_gully.num_value,
			vu_gully.pjoint_id,
			vu_gully.pjoint_type,
			vu_gully.tstamp,vu_gully.insert_user,vu_gully.lastupdate,vu_gully.lastupdate_user,vu_gully.the_geom,vu_gully.workcat_id_plan,vu_gully.asset_id,vu_gully.connec_matcat_id,vu_gully.gratecat2_id,
			vu_gully.connec_y1,vu_gully.connec_y2,vu_gully.epa_type,vu_gully.groove_height,vu_gully.groove_length,vu_gully.grate_width,vu_gully.grate_length,vu_gully.units_placement,vu_gully.drainzone_id,
			vu_gully.expl_id2,vu_gully.is_operative,vu_gully.region_id,vu_gully.province_id,vu_gully.adate,vu_gully.adescript,vu_gully.siphon_type,vu_gully.odorflap
			FROM s, vu_gully
			JOIN v_state_gully USING (gully_id)
			WHERE (vu_gully.expl_id = s.expl_id OR vu_gully.expl_id2 = s.expl_id);
		END IF;

		v_message = 'PLAN MODE SUCESSFULLY REMOVED';

	ELSIF v_action = 'ENABLE' THEN

		INSERT INTO value_state VALUES (2, v_valuestateplanname) ON CONFLICT (id) DO NOTHING;

		UPDATE config_param_system 
		SET value = '{"table":"value_state","selector":"selector_state","table_id":"id","selector_id":"state_id","label":"id, '' - '', name","manageAll":false,"query_filter":" AND id < 2"}'
		WHERE parameter = 'basic_selector_tab_network_state';

		UPDATE config_form_tabs SET formname = 'selector_basic' where tabname = 'tab_psector' and formname = 'selector_basic_';

		-- state node				
		CREATE OR REPLACE VIEW v_state_node AS(
			 SELECT node.node_id
			   FROM selector_state,
			    node
			  WHERE node.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
			EXCEPT
			 SELECT plan_psector_x_node.node_id
			   FROM selector_psector,
			    plan_psector_x_node
			  WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_node.state = 0
		) UNION
		 SELECT plan_psector_x_node.node_id
		   FROM selector_psector,
		    plan_psector_x_node
		  WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_node.state = 1;

		-- state arc
		CREATE OR REPLACE VIEW v_state_arc AS (
			 SELECT arc.arc_id
			   FROM selector_state,
			    arc
			  WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
			EXCEPT
			 SELECT plan_psector_x_arc.arc_id
			   FROM selector_psector,
			    plan_psector_x_arc
			     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
			  WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_arc.state = 0
		) UNION
		 SELECT plan_psector_x_arc.arc_id
		   FROM selector_psector,
		    plan_psector_x_arc
		     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
		  WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_arc.state = 1;

		-- state connec
		IF v_project_type = 'WS' THEN
		
			CREATE OR REPLACE VIEW v_state_connec AS 
			SELECT DISTINCT ON (a.connec_id) a.connec_id, a.arc_id, flag::smallint
			FROM (( SELECT connec.connec_id,
					    connec.arc_id,
					    1 AS flag
					   FROM selector_state,
					    selector_expl,
					    connec
					  WHERE connec.state = selector_state.state_id AND (connec.expl_id = selector_expl.expl_id OR connec.expl_id2 = selector_expl.expl_id) 
					  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
					EXCEPT
					 SELECT plan_psector_x_connec.connec_id,
					    plan_psector_x_connec.arc_id,
					    1 AS flag
					   FROM selector_psector,
					    selector_expl,
					    plan_psector_x_connec
					     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
					  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 0 
					  AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
				) UNION
				 SELECT plan_psector_x_connec.connec_id,
				    plan_psector_x_connec.arc_id,
				    2 AS flag
				   FROM selector_psector,
				    selector_expl,
				    plan_psector_x_connec
				     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
				  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 1 
				  AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
			  ORDER BY 1, 3 DESC) a;

		ELSE
			CREATE OR REPLACE VIEW v_state_connec AS 
			SELECT DISTINCT ON (a.connec_id) a.connec_id::varchar(30), a.arc_id, flag::smallint
			FROM (( SELECT connec.connec_id,
					    connec.arc_id,
					    1 AS flag
					   FROM selector_state,
					    selector_expl,
					    connec
					  WHERE connec.state = selector_state.state_id AND (connec.expl_id = selector_expl.expl_id OR connec.expl_id2 = selector_expl.expl_id) 
					  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
					EXCEPT
					 SELECT plan_psector_x_connec.connec_id,
					    plan_psector_x_connec.arc_id,
					    1 AS flag
					   FROM selector_psector,
					    selector_expl,
					    plan_psector_x_connec
					     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
					  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 0 
					  AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
				) UNION
				 SELECT plan_psector_x_connec.connec_id,
				    plan_psector_x_connec.arc_id,
				    2 AS flag
				   FROM selector_psector,
				    selector_expl,
				    plan_psector_x_connec
				     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
				  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 1 
				  AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
			  ORDER BY 1, 3 DESC) a;

		END IF;
	

		-- state link
		CREATE OR REPLACE VIEW v_state_link AS (
			 SELECT DISTINCT link.link_id
			   FROM selector_state,
			    selector_expl,
			    link
			  WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id)
			   AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
			EXCEPT ALL
			 SELECT plan_psector_x_connec.link_id
			   FROM selector_psector,
			    selector_expl,
			    plan_psector_x_connec
			     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
			  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
			  AND plan_psector_x_connec.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_connec.active IS TRUE
		) UNION ALL
		 SELECT plan_psector_x_connec.link_id
		   FROM selector_psector,
		    selector_expl,
		    plan_psector_x_connec
		     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
		  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
		  AND plan_psector_x_connec.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_connec.active IS TRUE;


		-- state link connec
		CREATE OR REPLACE VIEW v_state_link_connec AS (
			 SELECT DISTINCT link.link_id
			   FROM selector_state,
			    selector_expl,
			    link
			  WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) 
			  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'CONNEC'::text
			EXCEPT ALL
			 SELECT plan_psector_x_connec.link_id
			   FROM selector_psector,
			    selector_expl,
			    plan_psector_x_connec
			     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
			  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
			  AND plan_psector_x_connec.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_connec.active IS TRUE
		) UNION ALL
		 SELECT plan_psector_x_connec.link_id
		   FROM selector_psector,
		    selector_expl,
		    plan_psector_x_connec
		     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
		  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
		  AND plan_psector_x_connec.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_connec.active IS TRUE;


		IF v_project_type ='WS' THEN
		
			-- reconnect the possibility to show for each connec different arc_id, exit_id and mapzones in function of planified link
			CREATE OR REPLACE VIEW v_connec AS 
			with s as (SELECT expl_id FROM selector_expl WHERE selector_expl.cur_user = current_user) 
			SELECT c.connec_id,c.code,c.elevation,c.depth,c.connec_type,c.sys_type,c.connecat_id,c.expl_id,c.macroexpl_id,
			CASE WHEN a.sector_id IS NULL THEN c.sector_id ELSE a.sector_id END AS sector_id,
			c.sector_name,c.macrosector_id,c.customer_code,c.cat_matcat_id,c.cat_pnom,c.cat_dnom,c.connec_length,c.state,c.state_type,
			c.n_hydrometer,v_state_connec.arc_id,c.annotation,c.observ,c.comment,
			CASE WHEN a.minsector_id IS NULL THEN c.minsector_id ELSE a.minsector_id END AS minsector_id, 
			CASE WHEN a.dma_id IS NULL THEN c.dma_id ELSE a.dma_id END AS dma_id,
			CASE WHEN a.dma_name IS NULL THEN c.dma_name ELSE a.dma_name END AS dma_name,
			CASE WHEN a.macrodma_id IS NULL THEN c.macrodma_id ELSE a.macrodma_id END AS macrodma_id,
			CASE WHEN a.presszone_id IS NULL THEN c.presszone_id ELSE a.presszone_id::character varying(30) END AS presszone_id,
			CASE WHEN a.presszone_name IS NULL THEN c.presszone_name ELSE a.presszone_name END AS presszone_name,
			CASE WHEN a.presszone_name IS NULL THEN c.staticpressure ELSE a.staticpressure END AS staticpressure,
			CASE WHEN a.dqa_id IS NULL THEN c.dqa_id ELSE a.dqa_id END AS dqa_id,
			CASE WHEN a.dqa_name IS NULL THEN c.dqa_name ELSE a.dqa_name END AS dqa_name,
			CASE WHEN a.macrodqa_id IS NULL THEN c.macrodqa_id ELSE a.macrodqa_id END AS macrodqa_id,
			c.soilcat_id,c.function_type,c.category_type,c.fluid_type,c.location_type,c.workcat_id,c.workcat_id_end,c.buildercat_id,
			c.builtdate,c.enddate,c.ownercat_id,c.muni_id,c.postcode,c.district_id,c.streetname,c.postnumber,c.postcomplement,
			c.streetname2,c.postnumber2,c.postcomplement2,c.descript,c.svg,c.rotation,c.link,c.verified,c.undelete,c.label,
			c.label_x,c.label_y,c.label_rotation,c.publish,c.inventory,c.num_value,c.connectype_id,
			CASE WHEN a.exit_id IS NULL THEN c.pjoint_id ELSE a.exit_id END AS pjoint_id,
			CASE WHEN a.exit_type IS NULL THEN c.pjoint_type ELSE a.exit_type END AS pjoint_type,
			c.tstamp,c.insert_user,c.lastupdate,c.lastupdate_user,c.the_geom,c.adate,c.adescript,c.accessibility,c.workcat_id_plan,c.asset_id,
			c.dma_style,c.presszone_style,c.epa_type,c.priority,c.valve_location,c.valve_type,c.shutoff_valve,c.access_type,c.placement_type,c.press_max,
			c.press_min,c.press_avg,c.demand,c.om_state,c.conserv_state,c.crmzone_id,c.crmzone_name,c.expl_id2,c.quality_max,c.quality_min,
			c.quality_avg,c.is_operative,c.region_id,c.province_id,c.plot_code
			FROM s , vu_connec c
			JOIN v_state_connec USING (connec_id)
			LEFT JOIN ( SELECT DISTINCT ON (vu_link.feature_id) vu_link.link_id,
			vu_link.feature_type,vu_link.feature_id,vu_link.exit_type,vu_link.exit_id,vu_link.state,vu_link.expl_id,vu_link.sector_id,vu_link.dma_id,vu_link.presszone_id,vu_link.dqa_id,vu_link.minsector_id,
			vu_link.exit_topelev,vu_link.exit_elev,vu_link.fluid_type,vu_link.gis_length,vu_link.the_geom,vu_link.sector_name,vu_link.dma_name,vu_link.dqa_name,vu_link.presszone_name,vu_link.macrosector_id,
			vu_link.macrodma_id,vu_link.macrodqa_id,vu_link.expl_id2,vu_link.staticpressure
			FROM vu_link,s
			WHERE (vu_link.expl_id = s.expl_id OR vu_link.expl_id2 = s.expl_id) AND vu_link.state = 2) a ON a.feature_id::text = c.connec_id::text
			WHERE (c.expl_id = s.expl_id OR c.expl_id2 = s.expl_id);
		ELSE

			-- gully
			CREATE OR REPLACE VIEW v_state_gully AS 
			SELECT DISTINCT ON (a.gully_id) a.gully_id, a.arc_id
			FROM ((SELECT gully.gully_id,
				    gully.arc_id,
				    1 AS flag
				   FROM selector_state,
				    selector_expl,
				    gully
				  WHERE gully.state = selector_state.state_id AND (gully.expl_id = selector_expl.expl_id OR gully.expl_id2 = selector_expl.expl_id) 
				  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
				EXCEPT
				 SELECT plan_psector_x_gully.gully_id,
				    plan_psector_x_gully.arc_id,
				    1 AS flag
				   FROM selector_psector,
				    selector_expl,
				    plan_psector_x_gully
				     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
				  WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
				  AND plan_psector_x_gully.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
			) UNION
			 SELECT plan_psector_x_gully.gully_id,
			    plan_psector_x_gully.arc_id,
			    2 AS flag
			   FROM selector_psector,
			    selector_expl,
			    plan_psector_x_gully
			     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
			  WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
			  AND plan_psector_x_gully.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
			ORDER BY 1, 3 DESC) a;

			-- link gully
			CREATE OR REPLACE VIEW v_state_link_gully AS (
			 SELECT DISTINCT link.link_id
			   FROM selector_state,
			    selector_expl,
			    link
			  WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) 
			  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'GULLY'::text
			EXCEPT ALL
			 SELECT plan_psector_x_gully.link_id
			   FROM selector_psector,
			    selector_expl,
			    plan_psector_x_gully
			     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
			  WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
			  AND plan_psector_x_gully.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_gully.active IS TRUE
			) UNION ALL
			SELECT plan_psector_x_gully.link_id
			FROM selector_psector,
			selector_expl,
			plan_psector_x_gully
			JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
			WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
			AND plan_psector_x_gully.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_gully.active IS TRUE;

			-- reconnect the possibility to show for each connec different arc_id, exit_id and mapzones in function of planified link
			CREATE OR REPLACE VIEW v_connec AS 
			with s as (SELECT expl_id FROM selector_expl WHERE selector_expl.cur_user = current_user) 
			SELECT c.connec_id, c.code, c.customer_code, c.top_elev, c.y1, c.y2, c.connecat_id, c.connec_type, c.sys_type,
			c.private_connecat_id, c.matcat_id, c.expl_id, c.macroexpl_id,
			CASE WHEN a.sector_id IS NULL THEN c.sector_id ELSE a.sector_id END AS sector_id,
			CASE WHEN a.macrosector_id IS NULL THEN c.macrosector_id ELSE a.macrosector_id END AS macrosector_id,
			c.demand,c.state,c.state_type,c.connec_depth,c.connec_length,v_state_connec.arc_id,c.annotation,c.observ,c.comment,
			CASE WHEN a.dma_id IS NULL THEN c.dma_id ELSE a.dma_id END AS dma_id, 
			CASE WHEN a.macrodma_id IS NULL THEN c.macrodma_id ELSE a.macrodma_id END AS macrodma_id,
			c.soilcat_id,c.function_type,c.category_type,c.fluid_type,c.location_type,c.workcat_id,c.workcat_id_end,c.buildercat_id,
			c.builtdate,c.enddate,c.ownercat_id,c.muni_id,c.postcode,c.district_id,c.streetname,c.postnumber,c.postcomplement,
			c.streetname2,c.postnumber2,c.postcomplement2,c.descript,c.svg,c.rotation,c.link,c.verified,c.undelete,c.label,
			c.label_x,c.label_y,c.label_rotation,c.accessibility,c.diagonal,c.publish,c.inventory,c.uncertain,c.num_value,
			CASE WHEN a.exit_id IS NULL THEN c.pjoint_id ELSE a.exit_id END AS pjoint_id, 
			CASE WHEN a.exit_type IS NULL THEN c.pjoint_type ELSE a.exit_type END AS pjoint_type,
			c.tstamp,c.insert_user,c.lastupdate,c.lastupdate_user,c.the_geom,c.workcat_id_plan,c.asset_id,c.drainzone_id,c.expl_id2,
			c.is_operative,c.region_id,c.province_id,c.adate,c.adescript,c.plot_code
			FROM s, vu_connec c
			JOIN v_state_connec USING (connec_id)
			LEFT JOIN ( SELECT DISTINCT ON (vu_link.feature_id) vu_link.link_id,
			vu_link.feature_type,vu_link.feature_id,vu_link.exit_type,vu_link.exit_id,vu_link.state,vu_link.expl_id,vu_link.sector_id,vu_link.dma_id,vu_link.exit_topelev,vu_link.exit_elev,vu_link.fluid_type,
			vu_link.gis_length,vu_link.the_geom,vu_link.sector_name,vu_link.macrosector_id,vu_link.macrodma_id
			FROM vu_link, s
			WHERE (vu_link.expl_id = s.expl_id OR vu_link.expl_id2 = s.expl_id) AND vu_link.state = 2) a ON a.feature_id::text = c.connec_id::text
			WHERE (c.expl_id = s.expl_id OR c.expl_id2 = s.expl_id);

			-- reconnect the possibility to show for each gully different arc_id, exit_id and mapzones in function of planified link
			CREATE OR REPLACE VIEW v_gully AS 
			with s as (SELECT expl_id FROM selector_expl WHERE selector_expl.cur_user = current_user) 
			SELECT g.gully_id,g.code,g.top_elev,g.ymax,g.sandbox,g.matcat_id,g.gully_type,g.sys_type,g.gratecat_id,g.cat_grate_matcat,
			g.units,g.groove,g.siphon,g.connec_arccat_id,g.connec_length,g.connec_depth,v_state_gully.arc_id,g.expl_id,g.macroexpl_id,
			CASE WHEN a.sector_id IS NULL THEN g.sector_id ELSE a.sector_id END AS sector_id,
			CASE WHEN a.macrosector_id IS NULL THEN g.macrosector_id ELSE a.macrosector_id END AS macrosector_id,
			g.state,g.state_type,g.annotation,g.observ,g.comment,
			CASE WHEN a.dma_id IS NULL THEN g.dma_id ELSE a.dma_id END AS dma_id, 
			CASE WHEN a.macrodma_id IS NULL THEN g.macrodma_id ELSE a.macrodma_id END AS macrodma_id,
			g.soilcat_id,g.function_type,g.category_type,g.fluid_type,g.location_type,g.workcat_id,g.workcat_id_end,g.buildercat_id,g.builtdate,
			g.enddate,g.ownercat_id,g.muni_id,g.postcode,g.district_id,g.streetname,g.postnumber,g.postcomplement,g.streetname2,g.postnumber2,
			g.postcomplement2,g.descript,g.svg,g.rotation,g.link,g.verified,g.undelete,g.label,g.label_x,g.label_y,g.label_rotation,
			g.publish,g.inventory,g.uncertain,g.num_value,
			CASE WHEN a.exit_id IS NULL THEN g.pjoint_id ELSE a.exit_id END AS pjoint_id, 
			CASE WHEN a.exit_type IS NULL THEN g.pjoint_type ELSE a.exit_type END AS pjoint_type,
			g.tstamp,g.insert_user,g.lastupdate,g.lastupdate_user,g.the_geom,g.workcat_id_plan,g.asset_id,g.connec_matcat_id,g.gratecat2_id,
			g.connec_y1,g.connec_y2,g.epa_type,g.groove_height,g.groove_length,g.grate_width,g.grate_length,g.units_placement,g.drainzone_id,
			g.expl_id2,g.is_operative,g.region_id,g.province_id,g.adate,g.adescript,g.siphon_type,g.odorflap
			FROM s, vu_gully g
			JOIN v_state_gully USING (gully_id)
			LEFT JOIN ( SELECT DISTINCT ON (vu_link.feature_id) vu_link.link_id,
			vu_link.feature_type,vu_link.feature_id,vu_link.exit_type,vu_link.exit_id,vu_link.state,vu_link.expl_id,vu_link.sector_id,vu_link.dma_id,vu_link.exit_topelev,vu_link.exit_elev,
			vu_link.fluid_type,vu_link.gis_length,vu_link.the_geom,vu_link.sector_name,vu_link.macrosector_id,vu_link.macrodma_id
			FROM vu_link, s
			WHERE (vu_link.expl_id = s.expl_id OR vu_link.expl_id2 = s.expl_id) AND vu_link.state = 2) a ON a.feature_id::text = g.gully_id::text
			WHERE (g.expl_id = s.expl_id OR g.expl_id2 = s.expl_id);			
		END IF;

		v_message = 'PLAN MODE SUCESSFULLY RECOVERED';
	END IF;
	
	-- control NULL's
	v_message := COALESCE(v_message, '');
	
	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":0, "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{}}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;