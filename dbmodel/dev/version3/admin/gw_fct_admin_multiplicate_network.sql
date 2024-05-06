/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:

CREATE OR REPLACE FUNCTION ws1_2802.gw_fct_admin_multiplicate_network(p_x integer, p_y integer, p_dx integer, p_dy integer)
RETURNS json AS 
$BODY$

/* example

-- execute
SELECT ws1_2802.gw_fct_admin_multiplicate_network(2,1,11000,15000);

*/


DECLARE
x integer;
y integer;

BEGIN


	-- Set search path to local schema
	SET search_path = "ws1_2802", public;
	
	-- set previous
	ALTER TABLE ext_plot ALTER COLUMN id SET DEFAULT nextval('ws1_2802.urn_id_seq'::regclass);

	ALTER TABLE node DISABLE TRIGGER gw_trg_edit_foreignkey;
	ALTER TABLE node DISABLE TRIGGER gw_trg_node_arc_divide;
	ALTER TABLE node DISABLE TRIGGER gw_trg_node_rotation_update;
	ALTER TABLE node DISABLE TRIGGER gw_trg_node_statecontrol;
	ALTER TABLE node DISABLE TRIGGER gw_trg_topocontrol_node;
	ALTER TABLE node DISABLE TRIGGER gw_trg_typevalue_fk;
	ALTER TABLE node DISABLE RULE insert_plan_psector_x_node;

	ALTER TABLE arc DISABLE TRIGGER gw_trg_arc_noderotation_update;
	ALTER TABLE arc DISABLE TRIGGER gw_trg_arc_vnodelink_update;
	ALTER TABLE arc DISABLE TRIGGER gw_trg_edit_foreignkey;
	ALTER TABLE arc DISABLE TRIGGER gw_trg_topocontrol_arc;
	ALTER TABLE arc DISABLE TRIGGER gw_trg_typevalue_fk;
	ALTER TABLE arc DISABLE RULE insert_plan_psector_x_arc;

	ALTER TABLE connec DISABLE TRIGGER gw_trg_connec_proximity_insert;
	ALTER TABLE connec DISABLE TRIGGER gw_trg_connec_proximity_update;
	ALTER TABLE connec DISABLE TRIGGER gw_trg_connect_update;
	ALTER TABLE connec DISABLE TRIGGER gw_trg_edit_foreignkey;
	ALTER TABLE connec DISABLE TRIGGER gw_trg_typevalue_fk;
	ALTER TABLE connec DISABLE TRIGGER gw_trg_unique_field;

	ALTER TABLE link DISABLE TRIGGER gw_trg_link_connecrotation_update;


	FOR y IN 0..p_y
	LOOP

		RAISE NOTICE 'Y LOOP % ',y;

		FOR x IN 1..p_x
		LOOP

			RAISE NOTICE 'X LOOP % , %',y,x;

			RAISE NOTICE 'nodes';
			INSERT INTO node (code, elevation, depth, nodecat_id, epa_type, sector_id, arc_id, parent_id, state, state_type, annotation, observ,comment, dma_id, presszone_id, 
				soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, buildercat_id, builtdate, enddate, ownercat_id, muni_id,streetaxis_id, 
				streetaxis2_id, postcode, postnumber, postnumber2, postcomplement, district_id,	postcomplement2, descript, link, rotation,verified, undelete,label_x,label_y,label_rotation,
				expl_id, publish, inventory, the_geom, hemisphere, num_value, adate, adescript, accessibility, lastupdate, lastupdate_user, asset_id)

			SELECT code, elevation, depth, nodecat_id, epa_type, sector_id, arc_id, parent_id, state, state_type, annotation, observ,comment, dma_id, presszone_id, 
				soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, buildercat_id, builtdate, enddate, ownercat_id, muni_id,streetaxis_id, 
				streetaxis2_id, postcode, postnumber, postnumber2, postcomplement, district_id,	postcomplement2, descript, link, rotation,verified, undelete,label_x,label_y,label_rotation,
				expl_id, publish, inventory, st_translate(the_geom,x*p_dx,y*p_dy), hemisphere, num_value, adate, adescript, accessibility, lastupdate, lastupdate_user, asset_id FROM node;

			INSERT INTO inp_junction SELECT node_id FROM node WHERE state >0 and epa_type = 'JUNCTION' ON CONFLICT (node_id) DO NOTHING;
			INSERT INTO inp_reservoir SELECT node_id FROM node WHERE state >0 and epa_type = 'RESERVOIR' ON CONFLICT (node_id) DO NOTHING;
			INSERT INTO inp_tank SELECT node_id FROM node WHERE state >0 and epa_type = 'TANK' ON CONFLICT (node_id) DO NOTHING;
			INSERT INTO inp_inlet SELECT node_id FROM node WHERE state >0 and epa_type = 'INLET' ON CONFLICT (node_id) DO NOTHING;
			INSERT INTO inp_valve SELECT node_id FROM node WHERE state >0 and epa_type = 'VALVE' ON CONFLICT (node_id) DO NOTHING;
			INSERT INTO inp_pump SELECT node_id FROM node WHERE state >0 and epa_type = 'PUMP' ON CONFLICT (node_id) DO NOTHING;
			INSERT INTO inp_shortpipe SELECT node_id FROM node WHERE state >0 and epa_type = 'SHORTPIPE' ON CONFLICT (node_id) DO NOTHING;

			-- TODO: insert man_junctio & others nodes.....	

			RAISE NOTICE 'arcs';
			INSERT INTO arc (code, node_1,node_2, arccat_id, epa_type, sector_id, "state", state_type, annotation, observ,"comment",custom_length,dma_id, presszone_id, soilcat_id, function_type, category_type, fluid_type, location_type,
							workcat_id, workcat_id_end, workcat_id_plan, buildercat_id, builtdate,enddate, ownercat_id, muni_id, postcode, district_id, streetaxis_id, postnumber, postcomplement,
							streetaxis2_id,postnumber2, postcomplement2,descript,link,verified,the_geom,undelete,label_x,label_y,label_rotation,  publish, inventory, expl_id, num_value, 
							depth, adate, adescript, lastupdate, lastupdate_user, asset_id, pavcat_id)
			SELECT code, node_1,node_2, arccat_id, epa_type, sector_id, "state", state_type, annotation, observ,"comment",custom_length,dma_id, presszone_id, soilcat_id, function_type, category_type, fluid_type, location_type,
							workcat_id, workcat_id_end, workcat_id_plan, buildercat_id, builtdate,enddate, ownercat_id, muni_id, postcode, district_id, streetaxis_id, postnumber, postcomplement,
							streetaxis2_id,postnumber2, postcomplement2,descript,link,verified, st_translate(the_geom,x*p_dx,y*p_dy), undelete,label_x,label_y,label_rotation,  publish, inventory, expl_id, num_value, 
							depth, adate, adescript, lastupdate, lastupdate_user, asset_id, pavcat_id FROM arc;

			INSERT INTO inp_pipe SELECT arc_id FROM arc WHERE state >0 and epa_type = 'PIPE' ON CONFLICT (arc_id) DO NOTHING;
			INSERT INTO inp_virtualvalve SELECT arc_id FROM arc WHERE state >0 and epa_type = 'VIRTUALVALVE' ON CONFLICT (arc_id) DO NOTHING;

			-- TODO: insert man_pipe

			RAISE NOTICE 'connecs';
			INSERT INTO connec (code, elevation, depth,connecat_id,  sector_id, customer_code,  state, state_type, annotation, observ, comment,dma_id, presszone_id, soilcat_id,
				function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, buildercat_id, builtdate, enddate, ownercat_id, streetaxis2_id, postnumber, postnumber2, 
				muni_id, streetaxis_id,  postcode, district_id, postcomplement, postcomplement2, descript, link, verified, rotation,  the_geom, undelete, label_x,label_y,label_rotation, expl_id,
				publish, inventory,num_value, connec_length, arc_id, minsector_id, dqa_id, staticpressure, pjoint_id, pjoint_type,
				adate, adescript, accessibility, lastupdate, lastupdate_user, asset_id, epa_type)
			SELECT 	code, elevation, depth,connecat_id,  sector_id, customer_code,  state, state_type, annotation, observ, comment,dma_id, presszone_id, soilcat_id,
				function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, workcat_id_plan, buildercat_id, builtdate, enddate, ownercat_id, streetaxis2_id, postnumber, postnumber2, 
				muni_id, streetaxis_id,  postcode, district_id, postcomplement, postcomplement2, descript, link, verified, rotation, st_translate(the_geom,x*p_dx,y*p_dy), undelete, label_x,label_y,label_rotation, expl_id,
				publish, inventory,num_value, connec_length, arc_id, minsector_id, dqa_id, staticpressure, pjoint_id, pjoint_type,
				adate, adescript, accessibility, lastupdate, lastupdate_user, asset_id, epa_type FROM connec;

			INSERT INTO inp_connec SELECT connec_id FROM connec WHERE epa_type = 'JUNCTION' ON CONFLICT (connec_id) DO NOTHING;

			RAISE NOTICE 'links';
			INSERT INTO link (feature_type, feature_id, expl_id, exit_id, exit_type, userdefined_geom, state, the_geom, vnode_topelev)
			SELECT feature_type, feature_id, expl_id, exit_id, exit_type, userdefined_geom, state,  st_translate(the_geom,x*p_dx,y*p_dy), vnode_topelev FROM link;

			RAISE NOTICE 'Vnode';
			INSERT INTO vnode (state, the_geom)
			SELECT state, st_translate(the_geom,x*p_dx,y*p_dy) FROM vnode;

			RAISE NOTICE 'Plot';
			INSERT INTO ext_plot (plot_code, muni_id,  postcode, streetaxis_id, postnumber, complement, placement, square, observ, text, the_geom, expl_id) 
			SELECT plot_code, muni_id,  postcode, streetaxis_id, postnumber, complement, placement, square, observ, text, st_translate(the_geom,x*p_dx,y*p_dy), expl_id FROM ext_plot;
			
		END LOOP;
		
	END LOOP;
	
	-- restore environment
	ALTER TABLE node ENABLE TRIGGER gw_trg_edit_foreignkey;
	ALTER TABLE node ENABLE TRIGGER gw_trg_node_arc_divide;
	ALTER TABLE node ENABLE TRIGGER gw_trg_node_rotation_update;
	ALTER TABLE node ENABLE TRIGGER gw_trg_node_statecontrol;
	ALTER TABLE node ENABLE TRIGGER gw_trg_topocontrol_node;
	ALTER TABLE node ENABLE TRIGGER gw_trg_typevalue_fk;
	ALTER TABLE node ENABLE RULE insert_plan_psector_x_node;

	ALTER TABLE arc ENABLE TRIGGER gw_trg_arc_noderotation_update;
	ALTER TABLE arc ENABLE TRIGGER gw_trg_arc_vnodelink_update;
	ALTER TABLE arc ENABLE TRIGGER gw_trg_edit_foreignkey;
	ALTER TABLE arc ENABLE TRIGGER gw_trg_topocontrol_arc;
	ALTER TABLE arc ENABLE TRIGGER gw_trg_typevalue_fk;
	ALTER TABLE arc ENABLE RULE insert_plan_psector_x_arc;

	ALTER TABLE connec ENABLE TRIGGER gw_trg_connec_proximity_insert;
	ALTER TABLE connec ENABLE TRIGGER gw_trg_connec_proximity_update;
	ALTER TABLE connec ENABLE TRIGGER gw_trg_connect_update;
	ALTER TABLE connec ENABLE TRIGGER gw_trg_edit_foreignkey;
	ALTER TABLE connec ENABLE TRIGGER gw_trg_typevalue_fk;
	ALTER TABLE connec ENABLE TRIGGER gw_trg_unique_field;

	ALTER TABLE link ENABLE TRIGGER gw_trg_link_connecrotation_update;
	     
	-- Return
	RETURN '{"status":"Accepted"}';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


