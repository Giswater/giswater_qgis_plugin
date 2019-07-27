/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


drop VIEW v_inp_subcatch2node;
drop VIEW v_inp_subcatchcentroid;
drop VIEW vi_coverages;
drop VIEW vi_groundwater;
drop VIEW vi_infiltration;
drop VIEW vi_lid_usage;
drop VIEW vi_loadings;
drop VIEW vi_subareas;
drop VIEW vi_subcatchments;
drop VIEW vi_gwf;
drop VIEW ve_subcatchment;
drop VIEW v_edit_subcatchment;


CREATE OR REPLACE VIEW vi_options AS 
 SELECT a.idval as parameter,
    b.value
   FROM audit_cat_param_user a
   JOIN config_param_user b ON a.id = b.parameter::text
   WHERE (a.layoutname = ANY (ARRAY['grl_general_1'::text, 'grl_general_2'::text, 'grl_hyd_3'::text, 'grl_hyd_4'::text, 'grl_date_13'::text, 'grl_date_14'::text]))
   AND b.cur_user::name = "current_user"()
   AND a.epaversion::json->>'from'='5.0.022'
   AND b.value IS NOT NULL
   UNION
	SELECT 'INFILTRATION' , infiltration as value from inp_selector_hydrology, cat_hydrology
	where cur_user=current_user;


CREATE OR REPLACE VIEW v_edit_inp_junction AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
elev AS sys_elev,
nodecat_id, 
v_node.sector_id, 
v_node.macrosector_id,
v_node.state, 
v_node.the_geom,
v_node.annotation, 
inp_junction.y0, 
inp_junction.ysur,
inp_junction.apond
FROM inp_selector_sector, v_node
     JOIN inp_junction ON inp_junction.node_id = v_node.node_id
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_edit_inp_divider AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
nodecat_id, 
v_node.sector_id, 
v_node.macrosector_id,
v_node.state, 
v_node.annotation, 
v_node.the_geom,
inp_divider.divider_type, 
inp_divider.arc_id, 
inp_divider.curve_id, 
inp_divider.qmin, 
inp_divider.ht, 
inp_divider.cd, 
inp_divider.y0, 
inp_divider.ysur, 
inp_divider.apond
FROM inp_selector_sector, v_node
     JOIN inp_divider ON (((v_node.node_id) = (inp_divider.node_id)))
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_outfall AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
nodecat_id, 
v_node.sector_id, 
v_node.macrosector_id,
v_node."state", 
v_node.the_geom,
v_node.annotation, 
inp_outfall.outfall_type, 
inp_outfall.stage, 
inp_outfall.curve_id, 
inp_outfall.timser_id,
inp_outfall.gate
FROM inp_selector_sector, v_node
     JOIN inp_outfall ON (((v_node.node_id) = (inp_outfall.node_id)))
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_storage AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
nodecat_id, 
v_node.sector_id, 
v_node.macrosector_id,
v_node."state", 
v_node.the_geom,
v_node.annotation,
inp_storage.storage_type, 
inp_storage.curve_id, 
inp_storage.a1, 
inp_storage.a2,
inp_storage.a0, 
inp_storage.fevap, 
inp_storage.sh, 
inp_storage.hc, 
inp_storage.imd, 
inp_storage.y0, 
inp_storage.ysur,
inp_storage.apond
FROM inp_selector_sector, v_node
     JOIN inp_storage ON (((v_node.node_id) = (inp_storage.node_id)))
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;
